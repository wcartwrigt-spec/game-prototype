# Sprint 04 — Polish & Integration

> **Depends on Sprints 01, 02, and 03 all completing.**
> **Execute last.**
> **Estimated effort:** 1 agent session.

---

## Context

Sprints 01–03 have produced a fully playable `export-html5/lotk.html` with both the Young Explorer and Ranger's Trial tracks across 7 chapters. This sprint adds music, visual polish, companion wiring, touch controls, full regression testing, and documentation updates.

Read the existing `lotk.html` thoroughly before making any changes. Understand all existing functions and state before modifying them.

---

## Task 1 — Music Patterns

Sprint 01 stubbed all music theme keys with placeholder patterns. Replace each with proper note patterns using the same Web Audio oscillator structure as `magiquest.html`.

The `MUSIC_PATTERNS` object has keys: `shire`, `forest`, `weathertop`, `moria`, `lothlorien`, `pelennor`, `mountdoom`, `victory`.

Each pattern has: `root` (Hz), `beat` (seconds per step), `sections` (array of 2 section objects, each with `pad`, `lead`, `bass` arrays of `noteRatio(semitones)` values).

Reference `magiquest.html` for the `noteRatio` helper and the oscillator frequency scheduling pattern.

**Theme specifications:**

```js
// SHIRE — warm, major key, pastoral. Root: 261.63 (C4). Beat: 0.36s.
// Pad: gently rocking I-IV-V-I. Lead: stepwise ascending melody. Bass: light walking.
// Feel: gentle Hobbiton morning. Slow, bright, safe.

// FOREST — mysterious, minor. Root: 220 (A3). Beat: 0.42s.
// Pad: minor i-VI-III-VII. Lead: wandering, non-resolving. Bass: sparse.
// Feel: Old Forest unease. Not scary — eerie and curious.

// WEATHERTOP — tense staccato. Root: 233.08 (Bb3). Beat: 0.28s.
// Pad: rapid minor stabs. Lead: short ascending figures that cut off. Bass: restless.
// Feel: danger approaching. Faster than Forest, more anxious.

// MORIA — deep, bass-heavy. Root: 130.81 (C3). Beat: 0.38s.
// Pad: very low, slow swells. Lead: sparse, high isolated notes. Bass: heavy drone.
// Feel: vast underground darkness. Reverberant weight.

// LOTHLORIEN — ethereal shimmer. Root: 329.63 (E4). Beat: 0.44s.
// Pad: wide-voiced major 7th chords. Lead: slow, dreamy with vibrato (tremolo oscillator).
// Bass: very soft. Feel: magical safety, wonder.

// PELENNOR — epic march. Root: 246.94 (B3). Beat: 0.22s (fast).
// Pad: bold power chords. Lead: heroic fanfare figure. Bass: driving pulse every beat.
// Feel: battle charge. Energetic, urgent, exciting.

// MOUNTDOOM — dissonant → resolving. Root: 220 (A3). Beat: 0.26s.
// Pad: tritone dissonance in section 1; resolves to major in section 2 (when boss HP drops to 0).
// Lead: tense chromatic motion. Bass: ominous low pedal.
// Swap to section 2 when tyrantState.defeated becomes true.

// VICTORY — triumphant, bright. Root: 392 (G4). Beat: 0.30s.
// Pad: full major arpeggio. Lead: soaring melody. Bass: celebratory.
// Feel: Grey Havens farewell. Joy and bittersweetness.
```

Use the same section cycling logic as `magiquest.html` (16-step sections, syncopation on steps 6 and 7).

**Mount Doom special:** When `game.tyrantState.defeated` flips to `true`, immediately set `MUSIC.section = 1` so the resolving section plays during the defeat animation.

---

## Task 2 — Visual Polish

### 2a. Chapter Intro Fade

When `loadChapter()` is called, the canvas should fade in from black:
```js
game._fadeIn = 0.4; // seconds remaining in fade
// In drawScene(): if game._fadeIn > 0, after drawing everything:
ctx.fillStyle = `rgba(0,0,0,${game._fadeIn / 0.4})`;
ctx.fillRect(0, 0, 1024, 576);
game._fadeIn = Math.max(0, game._fadeIn - dt);
```

### 2b. Hero Visual Upgrades

Draw a small icon overlay on the HUD (not on the canvas player sprite) to indicate equipment tier:

| Chapters | HUD badge |
|---|---|
| 1–2 | `🧥` Plain cloak |
| 3–4 | `🪄` Staff |
| 5–6 | `🏹` Elvish bow |
| 7 | `💍` Ring-bearer (pulsing gold glow via CSS animation on the badge element) |

In the HUD block for the hero name, add a `<span id="hero-badge">` element. Update it in `setHUD()`.

### 2c. Ring-Bearer Glow (Chapter 7)

During chapter 7, draw a radial gradient around the player on the canvas:
```js
if (game.chapter === 6) {
  const grad = ctx.createRadialGradient(
    game.player.x + 18 - game.camera.x, game.player.y + 26 - game.camera.y, 4,
    game.player.x + 18 - game.camera.x, game.player.y + 26 - game.camera.y, 40
  );
  grad.addColorStop(0, `rgba(255, 220, 60, ${0.18 + 0.06 * Math.sin(Date.now()/300)})`);
  grad.addColorStop(1, 'rgba(255,220,60,0)');
  ctx.fillStyle = grad;
  ctx.fillRect(game.player.x - 40 - game.camera.x, game.player.y - 30 - game.camera.y, 120, 120);
}
```

### 2d. Particle Effects Review

Ensure `spawnFx` is called for:
- Rune Stone pickup (gold burst, 12 particles)
- Enemy defeat — Young track (bright rainbow burst, 16 particles)
- Enemy defeat — Ranger track (gold/ember burst, 12 particles)
- Boss hit flash (white burst at boss center, 8 particles)
- Gate open (gold shower, 20 particles upward)
- Chapter complete (multi-color burst from center, 30 particles)
- Dark Tyrant ring crack (white + gold, 40 particles at ring position)

Copy `spawnFx`, `updateFx`, `drawFx` from `magiquest.html` if not already present.

### 2e. Boss Canvas Art

Ensure each boss is visually distinct. If Sprint 02/03 drew placeholder rectangles, replace with:

**Wraith Rider (Ch. 2):**
```js
// Body: tall dark grey trapezoid (cloak shape)
// Head: small dark circle with one red dot (eye)
// Mount: dark rectangle below, 4 short leg lines
// Animated: slight side-to-side sway (Math.sin(Date.now()/600) * 4 pixels)
```

**Witch-King (Ch. 5):**
```js
// Body: angular armored torso (dark polygon approximated as rects)
// Crown: 5 spike lines above head
// Phase 2 (HP ≤ 2): crown glows red, body gets red outline
// Animated: slow rise-and-fall (Math.sin(Date.now()/800) * 6 pixels)
```

**Dark Tyrant (Ch. 6):**
```js
// Body: very tall shadow rectangle, semi-transparent edges
// Ring: golden circle drawn above body, pulsing scale (Math.sin(Date.now()/400) * 0.1)
// Eye: single large red radial gradient in center of body
// HP cracks: at 3 HP draw 1 crack line on ring; at 2 HP draw 2; at 1 HP draw 3
// Defeat: ring circle shrinks to 0 radius over 0.8s; body translates down and fades
```

---

## Task 3 — Touch Controls

Copy the touch control system verbatim from `magiquest.html` into `lotk.html` if not already present. This includes:
- `#touch-controls` div with joystick + JUMP + E + P buttons
- Joystick touch event handlers (touchstart, touchmove, touchend)
- `game.touchAxisX` driving `INPUT.left` / `INPUT.right`
- Touch buttons for jump and interact

Verify the DOM input fields in the lesson and gate overlays auto-focus on mobile (triggering native keyboard). Add `inputmode="text"` to those inputs.

---

## Task 4 — Cheat Codes

If not wired in Sprint 01, add cheat codes now:

```js
const CHEAT_NEXT = ['ArrowUp','ArrowUp','ArrowDown','ArrowDown'];
const CHEAT_PREV = ['ArrowDown','ArrowDown','ArrowUp','ArrowUp'];

document.addEventListener('keydown', e => {
  game.cheatBuffer.push(e.code || e.key);
  if (game.cheatBuffer.length > 4) game.cheatBuffer.shift();
  if (JSON.stringify(game.cheatBuffer) === JSON.stringify(CHEAT_NEXT)) {
    loadChapter(Math.min(game.chapter + 1, CHAPTERS.length - 1));
  }
  if (JSON.stringify(game.cheatBuffer) === JSON.stringify(CHEAT_PREV)) {
    loadChapter(Math.max(game.chapter - 1, 0));
  }
});
```

---

## Task 5 — Victory Screen

`#victory` overlay. Shown after completing Chapter 7.

Content:
- Large ⭐⭐⭐ row.
- Title: `"The Quest is Complete!"`
- Flavor text: `"The Dark Tyrant is defeated. The keys are free. [Hero name] returns home a legend."`
- Stats summary (Ranger track only): total WPM average, best accuracy chapter.
- Buttons: `Play Again` (clear save, return to title) and `← Back to Menu` (navigate to `index.html`).

Victory music: switch to `victory` theme.

---

## Task 6 — End-to-End Regression Testing

Open `export-html5/index.html` in Chrome and verify every item:

### Launcher
- [ ] Both game cards render; hover effects work.
- [ ] MagiWolf Quest card → `magiquest.html` loads and plays correctly.
- [ ] Lord of the Keys card → `lotk.html` loads correctly.

### MagiWolf (zero regression)
- [ ] Full playthrough: Lodge Lobby → Water Park → Forest Trail → Inventor Workshop → Magi Tower → Boss Arena → Victory.
- [ ] Spelling gates work; audio replay works.
- [ ] STEM side quests grant hearts.
- [ ] Boss Stormshell Rex: correct spells damage, wrong spells counterattack, two misses reset.
- [ ] `localStorage` save/continue works.
- [ ] `← Menu` link returns to launcher.

### LOTK — Young Explorer (Benjamin or Theodore)
- [ ] Hero select sets track to `'young'` in localStorage.
- [ ] All 7 chapter lesson phases show giant letter glyphs, correct keys advance, wrong keys shake.
- [ ] Adventure phase: enemies carry single letters; correct key defeats, wrong key (first) shakes, wrong key (second) loses heart.
- [ ] Gate: letter sequence challenge completes on correct presses.
- [ ] Ch. 2 boss: letters rain at 2s intervals, correct key removes letter and damages boss.
- [ ] Ch. 5 boss: 1.6s intervals.
- [ ] Ch. 6 boss: 1.2s intervals, ring-crack defeat animation plays.
- [ ] Two letters reaching the bottom: boss resets and heals to full.
- [ ] Lore quests: all 7 chapters have working multiple-choice trivia; completion grants +1 max heart.
- [ ] Chapter complete always shows ⭐⭐⭐; no WPM shown.
- [ ] Companions unlock correctly (Moth Ch.2, Ent Ch.3, Eagle Ch.5).
- [ ] Full run Ch.1 → Ch.7 → Victory screen.
- [ ] Resume Quest after closing/reopening restores correct chapter.

### LOTK — Ranger's Trial (Magi or Silas)
- [ ] Hero select sets track to `'ranger'` in localStorage.
- [ ] Ch.1 lesson drill: 10 words from `lessonWords`; ≥8 correct unlocks Full Words.
- [ ] Adventure phase: enemies carry full words; correct typed word defeats; wrong letter highlights red; backspace works.
- [ ] Active enemy targeting: typing disambiguates by word prefix matching.
- [ ] Gate phase: words fall with visible timer bar; 6/8 correct opens gate; fall duration decreases each chapter.
- [ ] Ch.2 boss (Wraith Rider): 3 HP, correct word damages, 2-miss limit.
- [ ] Ch.5 boss (Witch-King): 4 HP, Phase 2 speed increase at 2 HP.
- [ ] Ch.6 boss (Dark Tyrant): 4 HP, 2-miss limit, ring-crack defeat animation, Mount Doom music resolves.
- [ ] WPM and accuracy displayed on chapter complete; stars correctly reflect accuracy.
- [ ] Companion abilities: Moth forgives first mistake; Ent slows enemies 15%; Eagle previews next word.
- [ ] Full run Ch.1 → Ch.7 → Victory screen.
- [ ] Resume Quest restores correct chapter and track.

### Shared
- [ ] Cheat codes `Up,Up,Down,Down` / `Down,Down,Up,Up` skip chapters.
- [ ] `Shift+P` pause works without interfering with typing.
- [ ] Music plays for all 8 themes (no silence, no JS error).
- [ ] Mount Doom music shifts to resolving section on Dark Tyrant defeat.
- [ ] All particle effects fire at correct moments.
- [ ] Hero badge updates per chapter milestone (cloak → staff → bow → ring-bearer).
- [ ] Ring-bearer glow draws around player in Ch.7.
- [ ] Touch controls functional on mobile Chrome (Android or iPad).
- [ ] Chromebook: ≤6 enemies on screen at once, no dropped frames.
- [ ] `node --check` passes on extracted script block.

---

## Task 7 — Update Documentation

### `README.md`

Add a new section **Lord of the Keys** below the existing content:

```markdown
## Lord of the Keys

Kid-friendly LOTR-inspired typing game. Open `export-html5/index.html` to choose
between MagiWolf Quest and Lord of the Keys from the launcher.

### Tracks
- **Young Explorer** (ages 5–7): Benjamin Brandybuck or Theodore Took.
  Single-letter keystroke challenges. Full 26-letter alphabet built across 7 chapters.
- **Ranger's Trial** (ages 8–12): Magi Alastair or Silas Baggins.
  Full-word typing. Home row → full keyboard + capitals. 3rd–5th grade vocabulary.

### Files
- `export-html5/index.html` — game mode launcher
- `export-html5/magiquest.html` — MagiWolf Quest (unchanged original)
- `export-html5/lotk.html` — Lord of the Keys typing game

### Controls (Lord of the Keys)
- Move: A/D or Arrow keys. Jump: Space/W/Up. Interact: E. Pause: Shift+P.
- Typing: keyboard input (no click needed). Backspace supported.
- Cheat codes: Up,Up,Down,Down (next chapter) / Down,Down,Up,Up (previous chapter).
```

### `Tasks.md`

Add a **Lord of the Keys — Next Steps** section with any open polish items discovered during testing.

---

## Acceptance Criteria

- [ ] All regression tests above pass.
- [ ] All 8 music themes play with distinct character (not all sounding like the lodge theme placeholder).
- [ ] Mount Doom music resolves on boss defeat.
- [ ] All 3 boss canvas designs are visually distinct (not identical placeholders).
- [ ] Hero badge updates correctly across chapter milestones.
- [ ] Ring-bearer glow visible in Ch.7 for both tracks.
- [ ] Touch controls work on mobile Chrome.
- [ ] `README.md` and `Tasks.md` reflect the new dual-game structure.
- [ ] Zero console errors in Chrome for both games.
