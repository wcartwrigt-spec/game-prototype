# Sprint 03 — Ranger's Trial Track (⚔️)

> **Depends on Sprint 01 completing first.**
> **Can run in parallel with Sprint 02.**
> **Estimated effort:** 1 agent session.

---

## Context

Sprint 01 produced `export-html5/lotk.html` with a working shell. This sprint implements the **full Ranger's Trial track** (`game.track === 'ranger'`) — the path chosen by Magi Alastair and Silas Baggins, designed for ages 8–12.

**Note:** `LORE_QUESTS` (all 7 chapters) are defined in Sprint 02. If Sprint 02 has already run, those objects exist in `lotk.html` — do not redefine them, just wire them to `CHAPTERS[i].loreQuest`. If building in parallel, copy the `LORE_QUESTS` constant from `sprint-02-young-explorer.md`.

**Ranger's Trial core rules:**
- Players type **complete words** (case-insensitive, no punctuation stripped from answer).
- An 80% accuracy threshold in the lesson drill unlocks the Full Words tier for that chapter.
- Gate phase is **timed** — words fall and must be typed before reaching the bottom.
- WPM and accuracy are calculated and displayed on chapter complete.
- Stars: ⭐ < 70% accuracy / ⭐⭐ 70–89% / ⭐⭐⭐ ≥ 90%.

---

## Task 1 — Word Pools

Add word pools to each chapter's `typingLesson.ranger`:

```js
CHAPTERS[0].typingLesson.ranger = {
  keyZone: 'Home row: a s d f g h j k l',
  lessonWords: ['fall','flag','glad','dash','half','lass','hall','ask','has','gal','lash','fad'],
  fullWords:   ['flash','shall','glass','shale','harvest','meadow','daffodil','ladybug','shallow','hallway']
};

CHAPTERS[1].typingLesson.ranger = {
  keyZone: 'Top row: q w e r t y u i o p',
  lessonWords: ['tree','path','root','leaf','grow','flow','well','tower','power','write'],
  fullWords:   ['journey','whisper','feather','quarter','explore','protect','forward','flower','tower','require']
};

CHAPTERS[2].typingLesson.ranger = {
  keyZone: 'Bottom row: z x c v b n m',
  lessonWords: ['brave','night','climb','voice','storm','black','move','back','zinc','calm'],
  fullWords:   ['darkness','movement','branches','stumble','ancient','combine','become','warning','nervous','vibrant']
};

CHAPTERS[3].typingLesson.ranger = {
  keyZone: 'Full keyboard + numbers 1–9',
  lessonWords: ['bridge','beyond','tunnel','cavern','deep','stone','cave','mine','light','below'],
  fullWords:   ['ancient','discover','passage','mineral','echoing','silence','beneath','collapse','profound','labyrinth']
};

CHAPTERS[4].typingLesson.ranger = {
  keyZone: 'Shift key + capitals',
  lessonWords: ['Frodo','Shire','Elvish','Shire','Mirror','Quest'],
  fullWords:   ['Fellowship','Guardian','Glimmering','Reflection','Sanctuary','Peaceful','Graceful','Twilight','Wisdom','Radiant']
};

CHAPTERS[5].typingLesson.ranger = {
  keyZone: 'Full keyboard — speed focus',
  lessonWords: ['charge','rally','riders','shield','battle','march','brave','sword'],
  fullWords:   ['advance','courage','together','strength','victory','soldiers','persist','forward','champion','steadfast']
};

CHAPTERS[6].typingLesson.ranger = {
  keyZone: 'All keys — maximum difficulty',
  lessonWords: ['fire','ring','quest','climb','hope','forge','smoke'],
  fullWords:   ['fellowship','persevere','steadfast','determined','accomplish','darkness','extraordinary','relentless','triumphant','perseverance']
};
```

**Boss word pools** (always use Full Words tier regardless of skill threshold):

```js
const BOSS_WORDS = {
  wraith:  ['darkness','stumble','movement','branches','ancient','warning','nervous','vibrant','becomes','climbed'],
  witchking: ['advance','courage','together','strength','victory','champion','steadfast','forward','soldiers','persist'],
  tyrant:  ['fellowship','persevere','steadfast','determined','accomplish','darkness','relentless','extraordinary','triumphant','perseverance']
};
```

---

## Task 2 — Lesson Phase (Ranger's Trial)

Runs at the start of each chapter when `game.track === 'ranger'`.

The `#lesson-overlay` shows:

1. **Header:** `"Chapter [N]: [Name] — Keyboard Zone: [keyZone]"`
2. **Keyboard diagram:** A visual keyboard rendered as styled HTML divs. The current chapter's new key zone is highlighted in ember-gold. All other keys are dimmed.
3. **Instructions:** `"Type each word as it appears. Hit ≥ 80% to unlock harder words!"`
4. **Drill word display:** One word at a time, large centered text.
5. **Input field:** A text `<input>` (same styling as MagiWolf `#quiz-input`). `autocomplete="off" autocapitalize="none" spellcheck="false"`.
6. **Progress bar:** Shows `X / 10 words` drilled.

**Drill logic:**
- Pull 10 words randomly from `lessonWords` pool.
- Display word. Player types and presses Enter (or auto-submit on word-length match for shorter words).
- `normalizeAnswer(input) === normalizeAnswer(word)` → correct (green flash, advance).
- Wrong → red shake, clear input, retry same word (counts as miss).
- Track `correctCount` / 10. After 10 words: if `correctCount >= 8` → set `game.lessonAccuracy = correctCount/10`, unlock Full Words for this chapter (`game.chapterStates[i].fullWordsUnlocked = true`). Else → Lesson Tier only.
- Show result: "You got [X]/10! [Full Words Unlocked! / Keep practicing — you've got this!]"
- Button `Begin Adventure →` → hide overlay, start adventure phase.

```js
function normalizeAnswer(text) {
  return (text || '').trim().toLowerCase().replace(/[^a-z]/g,'');
}
```

**Keyboard diagram rendering:**
```js
const KB_ROWS = [
  ['q','w','e','r','t','y','u','i','o','p'],
  ['a','s','d','f','g','h','j','k','l'],
  ['z','x','c','v','b','n','m']
];
// Render each as a <div class="kb-key"> with CSS. Highlight chapter's new zone in --ember color.
```

---

## Task 3 — Adventure Phase (Ranger's Trial)

After the lesson, the canvas is active. Enemies walk toward the player.

**Word selection:** If `game.chapterStates[i].fullWordsUnlocked`, use `fullWords` pool; else use `lessonWords`. Each spawned enemy is assigned a word from the pool (random, no repeat until pool exhausted). Shuffle pool when exhausted.

**Bubble rendering (word bubbles):**

```js
function spawnWordBubble(enemy) {
  const el = document.createElement('div');
  el.className = 'word-bubble';
  el.id = `bubble-${enemy.id}`;
  el.dataset.word = enemy.word;
  el.dataset.typed = '';
  // Render word as individual <span> elements for character-by-character highlighting
  el.innerHTML = enemy.word.split('').map(ch =>
    `<span class="wch">${ch}</span>`
  ).join('');
  el.style.cssText = `position:absolute; font-size:20px; font-weight:700;
    background:rgba(255,248,220,0.95); border-radius:12px; padding:8px 14px;
    border:2px solid #c4922a; color:#2a1800; pointer-events:none;
    display:flex; gap:1px; align-items:center;`;
  document.getElementById('bubble-layer').appendChild(el);
}
```

**Active enemy:** Only one enemy is "active" at a time — the one whose word starts with the key the player is pressing. If multiple enemies match, prioritize the closest to the player.

**Input handling (adventure phase — Ranger):**

Use `document.addEventListener('keydown')`. Maintain a `game._rangerInput = ''` buffer. On each keydown (printable characters only):

1. Append to buffer.
2. Find the active enemy whose word starts with `normalizeAnswer(buffer)`.
3. If found: highlight the matched prefix in the active enemy's bubble green; unhighlight all others.
4. If `normalizeAnswer(buffer) === normalizeAnswer(enemy.word)`: enemy defeated (sparkle, remove bubble, increment accuracy counters). Clear buffer.
5. On Backspace: remove last char from buffer, re-highlight.
6. On wrong character (buffer doesn't match any enemy prefix): flash all bubbles red for 0.3s. First wrong: no heart loss. Second wrong: lose 1 heart, clear buffer.

**Rune Stone pickups:** 3 per chapter, same behavior as MagiWolf. Collect all 3 to unlock the gate.

**Enemy speed (Ranger):** `vx: 45–65` (slightly faster than Young track). Reaching the player: 1 heart lost, enemy removed.

**Character platforms and enemies:** Use the same layout data defined in Sprint 02 (`CHAPTERS[i].platforms`, `CHAPTERS[i].enemies`). If Sprint 02 has not run yet, define platform and enemy layouts here using the same format — they are shared between both tracks.

---

## Task 4 — Gate Phase (Ranger's Trial — Timed)

When the player reaches the gate with 3 Rune Stones, the **timed word gate** activates.

This is a full DOM overlay (`#lesson-overlay` repurposed or a new `#gate-overlay`):

- Canvas dims to 40% opacity (css `filter: brightness(0.4)` on the canvas element).
- Words fall from the top — one at a time (next word spawns when current word is typed or reaches the bottom).
- Each falling word has a **timer bar** — a thin colored bar below the word that shrinks from full width to zero over the fall duration.
- Fall duration: `3.5s` (Ch. 1) → `2.2s` (Ch. 7), decreasing by 0.2s per chapter.

```js
const GATE_FALL_DURATION = [3.5, 3.2, 3.0, 2.8, 2.6, 2.4, 2.2]; // by chapter index

function startRangerGate(chapterIndex) {
  const pool = game.chapterStates[chapterIndex].fullWordsUnlocked
    ? CHAPTERS[chapterIndex].typingLesson.ranger.fullWords
    : CHAPTERS[chapterIndex].typingLesson.ranger.lessonWords;
  const wordQueue = shuffle([...pool]).slice(0, 8); // 8 words to pass gate
  let correct = 0, missed = 0;
  // ... spawn words one at a time, track results
  // Gate opens when 6/8 words correct (forgiving threshold)
}
```

**Input:** Reuse the same hidden `<input>` field approach as MagiWolf spelling gates. Auto-focus on gate start. Enter or word-length auto-submit.

**Result:** Correct → word disappears with sparkle + chime. Miss (reaches bottom) → player loses 1 heart, next word spawns. 6/8 words correct → gate opens. All hearts lost → game over (restart chapter from checkpoint).

---

## Task 5 — Boss Battles (Ranger's Trial)

Three boss chapters: 2 (Wraith Rider), 5 (Witch-King), 6 (Dark Tyrant).

Use the same `tyrantState` pattern as MagiWolf's `bossState`.

**Boss visual (canvas-drawn):**

Draw each boss as a large canvas shape at the right side of the arena. Mirror the pattern used for Stormshell Rex in `magiquest.html`:
- A large colored rectangle for the body.
- Animated eye glow (radial gradient pulsing via `Math.sin(Date.now()/400)`).
- Hit flash on `tyrantState.hitFlash > 0`.
- Defeat: fall + fade (`tyrantState.fall` increases → translate down; `tyrantState.vanish` increases → alpha decreases).

**Battle mechanic:**

Words appear one at a time (shown in a styled DOM panel at the bottom of the screen, like MagiWolf's spelling gate but without audio). Player types and presses Enter.

- Correct: boss takes 1 HP damage. Hit flash. Sparkle FX. Next word.
- Wrong: boss counterattack — fires a fireball (canvas animated projectile moving left). If fireball reaches player: 1 heart lost. Increment `tyrantState.mistakes`.
- `tyrantState.mistakes >= tyrantState.missThreshold (2)`: boss fully heals, battle resets. Show dialog: "The Dark Tyrant grows stronger! Try again!"

**Boss-specific word pools and HP:**

| Boss | Chapter | HP | Word source | Phase notes |
|---|---|---|---|---|
| Wraith Rider | 2 | 3 | `BOSS_WORDS.wraith` | Single phase. 3 correct words = defeat. |
| Witch-King | 5 | 4 | `BOSS_WORDS.witchking` | Phase 1 (2 HP): words presented at 4s intervals. Phase 2 (2 HP): words at 2.5s intervals, two words queued. |
| Dark Tyrant | 6 | 4 | `BOSS_WORDS.tyrant` | Same 4-HP / 2-miss pattern as Stormshell Rex. At 2 HP: ring motif pulses faster on canvas. At 0 HP: ring cracks → dissolve animation. |

**Dark Tyrant intro cutscene:** 3-card dialog sequence before battle:
1. "The Dark Tyrant stirs in the fires of Mount Doom..."
2. "The Ring glows. Its power is almost free..."
3. "Only your typing can destroy it. Every word is a crack in the Ring!"

**Dark Tyrant defeat animation:**
- `tyrantState.fall`: boss rect translates downward 200px over 1.2s.
- Ring shape (circle drawn above boss): `tyrantState.vanish` drives alpha from 1 to 0 with a white flash burst (`spawnFx` with 30 particles, white/gold color) at the moment hp hits 0.

---

## Task 6 — WPM & Accuracy Tracking

Start timing when the adventure phase begins (after lesson overlay closes). Stop timing when the gate/boss is defeated.

```js
function startSession() {
  game._sessionStart = performance.now();
  game._charsTyped = 0;
  game._wordAttempts = 0;
  game._wordCorrect = 0;
}

function recordCorrectWord(word) {
  game._charsTyped += word.length;
  game._wordAttempts++;
  game._wordCorrect++;
}

function recordMiss() {
  game._wordAttempts++;
}

function calcResults() {
  const elapsed = (performance.now() - game._sessionStart) / 1000 / 60; // minutes
  game.wpm = Math.round((game._charsTyped / 5) / Math.max(elapsed, 0.1));
  game.accuracy = game._wordAttempts > 0
    ? game._wordCorrect / game._wordAttempts : 1;
}
```

---

## Task 7 — Chapter Complete Screen (Ranger's Trial)

After boss/gate:
1. Call `calcResults()`.
2. Show `#chapter-complete` with:
   - Title: `"Chapter [N] Complete!"`
   - Stars: ⭐ if accuracy < 0.70, ⭐⭐ if 0.70–0.89, ⭐⭐⭐ if ≥ 0.90.
   - WPM display: `"Your speed: [X] WPM"`
   - Accuracy display: `"Accuracy: [X]%"`
   - Encouragement message keyed to star count:
     - 3 stars: `"Outstanding! The Fellowship is proud of you!"`
     - 2 stars: `"Well done! Keep practicing and you'll be unstoppable."`
     - 1 star: `"You made it through! Try again to improve your score."`
   - Companion earned (if Lore Quest completed): show name + ability.
   - Button `Continue →` → `loadChapter(game.chapter + 1)`.
3. Save to localStorage.

---

## Task 8 — Chapter Platform & Enemy Layouts

If Sprint 02 has NOT yet populated `CHAPTERS[i].platforms` and `CHAPTERS[i].enemies`, define them here (they are shared by both tracks). Use the following guide:

- Each chapter ground platform: `{ x:0, y:510, w: chapter.width, h:66, type:'ground' }`
- 3–5 elevated platforms per chapter, staggered heights between y:230 and y:440.
- 2–4 enemies per chapter. For Ranger, enemies move at `vx: 50–65`.
- Boss chapters (2, 5, 6): leave right side of map clear for boss (no platforms past x:1200).

Example for Chapter 2 (Weathertop — stormy feel, fewer safe ledges):
```js
CHAPTERS[2].platforms = [
  { x:0,    y:510, w:1600, h:66, type:'ground' },
  { x:200,  y:430, w:150,  h:18, type:'stone' },
  { x:480,  y:370, w:130,  h:18, type:'stone' },
  { x:720,  y:310, w:140,  h:18, type:'stone' },
  { x:950,  y:260, w:110,  h:18, type:'stone' }
];
CHAPTERS[2].enemies = [
  { x:350, y:468, w:34, h:34, vx:55, minX:250, maxX:600 },
  { x:800, y:468, w:34, h:34, vx:-55, minX:600, maxX:1050 }
];
```

---

## Task 9 — Companions System

Companions are unlocked by completing Lore Quests. Only one active at a time; player selects at the chapter-start screen (a small UI element before the lesson phase).

```js
const COMPANIONS = {
  moth:  { id:'moth',  name:"Gandalf's Moth", emoji:'🦋', unlockedByChapter:1,
           ability:'Forgives 1 typing mistake per chapter (word re-queues instead of causing damage).' },
  ent:   { id:'ent',   name:'Ent-Sapling',    emoji:'🌱', unlockedByChapter:2,
           ability:'Slows all enemies by 15%, giving more time to type each word.' },
  eagle: { id:'eagle', name:"Eagle of Manwë", emoji:'🦅', unlockedByChapter:4,
           ability:'Reveals the next incoming word 0.8s before it appears.' }
};
```

**Ability implementation:**

- **Moth:** On the first mistake each chapter, set a `game._mothUsed = true` flag and re-queue the word instead of dealing damage. Reset flag at chapter start.
- **Ent:** Multiply all enemy `vx` values by `0.85` when this companion is active (apply at chapter load time).
- **Eagle:** In the gate phase and boss phase, show the next word in a dimmed "preview" position 0.8s before it becomes the active word.

---

## Acceptance Criteria

- [ ] Selecting Magi Alastair or Silas Baggins sets `game.track === 'ranger'`.
- [ ] Chapter 1 lesson: 10-word drill from `lessonWords`, accurate count tracked, 80% threshold unlocks Full Words.
- [ ] Adventure phase: enemies carry full words; typing the correct word defeats the enemy.
- [ ] Word bubble shows real-time character highlighting (green for matched prefix, red for mismatch).
- [ ] Backspace correctly removes the last character from the typed buffer and updates highlights.
- [ ] Gate phase: words fall with visible timer bars; 6/8 correct opens gate.
- [ ] Gate fall duration: ~3.5s for Ch.1, ~2.2s for Ch.7.
- [ ] Boss Ch.2 (Wraith Rider): 3 HP, single phase, 2-miss limit.
- [ ] Boss Ch.5 (Witch-King): 4 HP, two-phase (speed increase at 2 HP).
- [ ] Boss Ch.6 (Dark Tyrant): 4 HP, 2-miss limit, ring-crack defeat animation.
- [ ] Two misses: boss resets (same as MagiWolf bossState behavior).
- [ ] WPM and accuracy calculated and shown on chapter-complete screen.
- [ ] Stars correctly reflect accuracy (⭐/⭐⭐/⭐⭐⭐).
- [ ] Lore Quest completion grants +1 max heart and unlocks correct companion.
- [ ] Companion abilities are active when selected.
- [ ] All 7 chapters flow Ch.1 → Ch.7 → Victory screen.
- [ ] Save written to localStorage after each chapter complete.
