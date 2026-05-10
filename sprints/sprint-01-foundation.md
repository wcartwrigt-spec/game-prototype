# Sprint 01 — Foundation & Engine

> **Execute this sprint first. All other sprints depend on its output.**
> **Estimated effort:** 1 agent session.

---

## Project Context

This repo is a kid-friendly HTML5 browser game. The existing game **MagiWolf Quest** lives at `export-html5/index.html` (~140 KB, everything in one file, no build tools). You are adding a second game **Lord of the Keys** (LOTR-inspired typing adventure, ages 5–12) and a launcher screen.

**Hard constraints:**
- Pure HTML5 + Vanilla CSS + Vanilla JS. No frameworks, no npm.
- Must run by double-clicking the HTML file in Chrome. No local server required.
- Canvas 1024×576. Use `requestAnimationFrame` with dt capped at 0.05s.
- Web Audio API for music (procedural synth — zero audio files).
- `localStorage` for saves. Key: `lotk_save`.
- Reuse Kenney sprites already in `export-html5/assets/`.

---

## Task 1 — Rename the existing game file

Copy `export-html5/index.html` to `export-html5/magiquest.html`. **Change zero code inside it.** Then add one `← Menu` anchor immediately after `<body>`:

```html
<a id="back-link" href="index.html"
   style="position:fixed;top:12px;left:16px;z-index:999;color:#ffe39b;
          font-family:'Trebuchet MS',sans-serif;font-size:13px;
          text-decoration:none;opacity:0.8;letter-spacing:0.5px;">
  ← Menu
</a>
```

Verify the full MagiWolf playthrough still works from `magiquest.html`.

---

## Task 2 — Create `export-html5/index.html` (Launcher)

A standalone ~150-line page. No canvas needed.

**Layout:** Full-screen dark background. Two game cards side by side. Footer.

**Background:** `background: radial-gradient(circle at center, #141628, #060710)`. Spawn floating alphabet glyphs upward via JS (one every 800ms, random letter from `ABCDEFGHIJKLMNOPQRSTUVWXYZαβΩ∑Ψ`, CSS `@keyframes` float upward over 7s, remove on finish).

**Header:** `✨ MAGI QUEST ACADEMY ✨` — gold color, centered, `font-family: 'Trebuchet MS', sans-serif`. Subtitle: `Choose your adventure`.

**Card A — MagiWolf Quest:**
- Emoji 🧙, title, subtitle `Spelling & Word Adventure`, tags `Ages 5–12 · Platformer · Spelling`
- Button `▶ Play Now` → `window.location.href = 'magiquest.html'`
- Accent: `#6f9bff`

**Card B — Lord of the Keys:**
- Emoji 💍, title, subtitle `Typing Quest Adventure`, tags `Ages 5–12 · Typing · LOTR-Inspired`
- Button `⚔ Begin Quest` → `window.location.href = 'lotk.html'`
- Accent: `#c4922a`

**Card CSS:** `background: rgba(20,20,32,0.82); border: 1px solid rgba(255,255,255,0.12); border-radius: 22px; backdrop-filter: blur(10px); width: min(340px,42vw); padding: 32px;`. Hover: `transform: translateY(-6px); transition: 0.2s ease;`.

---

## Task 3 — Create `export-html5/lotk.html` (Game Shell)

Everything in one file. Model the structure on `magiquest.html`.

### 3a. CSS Variables

```css
:root {
  --shadow: #0d0e1a; --ember: #c4922a; --ember-light: #f5c96c;
  --lembas: #f2e8c9; --mithril: #8ab4d4; --ring-glow: #ffdd44;
  --danger: #e05555; --forest: #4a8c5c;
  --panel: rgba(18,18,30,0.86); --panel-light: rgba(255,255,255,0.1);
}
```

Canvas, HUD, overlays, panels, buttons — copy the structural CSS from `magiquest.html` and retheme with the new variables.

### 3b. HTML DOM Skeleton

```
#game-wrap
  canvas#game (1024×576)
  #hud  (hero name · hearts · chapter · track badge)
  #quest-chip  (chapter goal)
  #prompt-chip
  #title      (display:none → display:grid when active)
  #hero-select
  #lesson-overlay
  #dialog
  #lore-quest
  #chapter-complete
  #victory
  #pause
  #bubble-layer  (position:absolute; inset:0; pointer-events:none)
  #touch-controls
  a#back-link href="index.html"
```

### 3c. Game State Object

```js
const game = {
  scene: 'Title',
  chapter: 0,
  hero: null,       // 'magi'|'silas'|'benjamin'|'theodore'
  track: null,      // 'ranger'|'young'
  player: null,
  hearts: 3, maxHearts: 3,
  companions: { unlocked: [], active: null },
  loreCompleted: {},
  chapterStates: {},
  tyrantState: {
    active:false, defeated:false, hp:4, maxHp:4,
    mistakes:0, missThreshold:2, cooldown:0,
    hitFlash:0, fireballs:[], fall:0, vanish:0,
    wordQueue:[], roundIndex:0
  },
  lessonAccuracy: 0,
  wpm: 0, accuracy: 0,
  dialogQueue: [], dialogActive: false,
  quizActive: false, lessonActive: false,
  paused: false,
  camera: { x:0, y:0 },
  invuln: 0, fx: [], facing: 1,
  cheatBuffer: [],
  musicReady: false,
  promptText: '', promptTimer: 0,
  lastTick: 0, touchAxisX: 0
};
```

### 3d. Save / Load

```js
function saveGame() {
  const d = { chapter:game.chapter, hero:game.hero, track:game.track,
    hearts:game.hearts, maxHearts:game.maxHearts,
    companions:game.companions, loreCompleted:game.loreCompleted,
    chapterStates:game.chapterStates };
  try { localStorage.setItem('lotk_save', JSON.stringify(d)); } catch(e){}
}
function loadGame() {
  try { const r=localStorage.getItem('lotk_save'); return r?JSON.parse(r):null; }
  catch(e){ return null; }
}
function clearSave() {
  try { localStorage.removeItem('lotk_save'); } catch(e){}
}
```

### 3e. CHAPTERS Array (Stub)

Define the array with 7 objects. Sprints 2 & 3 populate the content fields.

```js
const CHAPTER_NAMES = [
  'The Shire','The Old Forest','Weathertop',
  'Mines of Moria','Lothlórien','Fields of Pelennor','Mount Doom'
];

const CHAPTERS = CHAPTER_NAMES.map((name, i) => ({
  index: i,
  name,
  background: { top:'#88c070', bottom:'#4a7040' }, // placeholder, Sprint 2/3 sets
  musicTheme: ['shire','forest','weathertop','moria','lothlorien','pelennor','mountdoom'][i],
  width: 1600,
  platforms: [],
  enemies: [],
  dialogs: [],
  loreQuest: null,
  typingLesson: { young: { letters:[] }, ranger: { lessonWords:[], fullWords:[], keyZone:'' } },
  gate: null,
  exit: { target: i + 1 },
  boss: null   // non-null for chapters 2, 5, 6
}));
```

### 3f. Player Physics

Copy `createPlayer`, the full physics update loop, and collision resolution from `magiquest.html` verbatim. Values: `speed:280, jumpPower:720, gravity:2200`. Apply `ctx.filter = 'hue-rotate(60deg) saturate(0.8)'` before drawing the player sprite; reset to `'none'` after.

### 3g. Input System

```js
const INPUT = { left:false, right:false, up:false, interact:false };
const KEYMAP = { ArrowLeft:'left', ArrowRight:'right', ArrowUp:'up', a:'left', d:'right', w:'up' };
const CHEAT_NEXT = ['ArrowUp','ArrowUp','ArrowDown','ArrowDown'];
const CHEAT_PREV = ['ArrowDown','ArrowDown','ArrowUp','ArrowUp'];
```

### 3h. Sprites

Copy the `SPRITES` object and the `preloadArt` / `loadImage` / `loadAssetGroup` functions from `magiquest.html` verbatim. No new sprite files needed.

### 3i. Title Screen

`#title` overlay has:
- Title `Lord of the Keys` with LOTR-style subtitle `"One Quest. Every Key."`
- Button **New Quest** → hide `#title`, show `#hero-select`
- Button **Resume Quest** → if `loadGame()` returns null, button is disabled; otherwise restore state and call `loadChapter(savedData.chapter)`

### 3j. Hero Select Screen

Four cards in a 2×2 grid inside `#hero-select`. On click:

```js
function selectHero(hero, track) {
  game.hero = hero;
  game.track = track;
  saveGame();
  document.getElementById('hero-select').style.display = 'none';
  loadChapter(0);
}
```

| Card | hero value | track |
|---|---|---|
| 🧙 Magi Alastair — *"Scholar-adventurer. For experienced typists."* — Ages 8–12 | `'magi'` | `'ranger'` |
| 🌿 Silas Baggins — *"A hobbit who never wanted adventure — until it came knocking."* — Ages 8–12 | `'silas'` | `'ranger'` |
| 🐾 Benjamin Brandybuck — *"Brave, bold, always hungry. Perfect for little adventurers!"* — Ages 5–7 | `'benjamin'` | `'young'` |
| 🌟 Theodore Took — *"Curious beyond measure. Great for first-time keyboard explorers!"* — Ages 5–7 | `'theodore'` | `'young'` |

Ranger cards: ember-gold (`#c4922a`) border. Young cards: forest-green (`#4a8c5c`) border.
Footer note: *"Not sure? Ask a grown-up to help you choose!"*

### 3k. Chapter Loader (Stub)

```js
function loadChapter(index) {
  if (index >= CHAPTERS.length) { showVictory(); return; }
  const ch = CHAPTERS[index];
  game.chapter = index;
  game.scene = ch.name;
  game.player = createPlayer({ x:100, y:420 });
  game.camera = { x:0, y:0 };
  clearBubbles();
  saveGame();
  setHUD();
  showChapterIntro(ch); // shows 2–3 dialog cards, then starts lesson phase
}
```

### 3l. HUD

```js
function setHUD() {
  // hero name + scene name in left block
  // heart icons (copy icon rendering from magiquest.html)
  // track badge: '🌱 Young Explorer' or '⚔️ Ranger\'s Trial'
  // active companion name
  // quest chip: chapter goal text
}
```

### 3m. Bubble Layer (Stub)

```js
function worldToScreen(wx, wy) {
  const r = canvas.getBoundingClientRect();
  return {
    x: (wx - game.camera.x) * (r.width/1024),
    y: (wy - game.camera.y) * (r.height/576)
  };
}
function updateBubbles() {} // Sprint 2/3 implements
function clearBubbles() {
  document.getElementById('bubble-layer').innerHTML = '';
}
```

### 3n. Music Engine

Copy the Web Audio oscillator setup (`MUSIC_VOLUME`, `ensureMusic`, `updateMusic`, `setMusicMute`, `getMusicTheme`) from `magiquest.html`. Define `MUSIC_PATTERNS` with stubs — each of the 8 theme keys can clone the `lodge` pattern as a placeholder. Sprint 4 replaces them with proper patterns.

Theme keys: `shire`, `forest`, `weathertop`, `moria`, `lothlorien`, `pelennor`, `mountdoom`, `victory`.

### 3o. Game Loop

```js
function tick(timestamp) {
  const dt = Math.min((timestamp - (game.lastTick||timestamp)) / 1000, 0.05);
  game.lastTick = timestamp;
  updateMusic();
  if (!game.paused && !game.dialogActive && !game.quizActive && !game.lessonActive) {
    updatePlayer(dt);
    updateEnemies(dt);
    updateFx(dt);
    checkPickups();
    checkTriggers();
  }
  drawScene();
  setHUD();
  requestAnimationFrame(tick);
}
```

### 3p. Shared Utility Functions

Copy these verbatim from `magiquest.html`: `rectsOverlap`, `clamp`, `hexToRgba`, `spawnFx`, `updateFx`, `drawFx`, `showDialog`, `quickDialog`, `nextDialog`, `queueDialog`, `setPrompt`, `createHudIcon`, `drawImageFit`, `tileImageX`.

---

## Acceptance Criteria

- [ ] `index.html` launcher loads; both cards navigate correctly.
- [ ] `magiquest.html` plays the full MagiWolf game with zero code changes.
- [ ] `lotk.html` loads without JS errors in Chrome.
- [ ] New Quest → Hero Select → card click → chapter stub loads; player can move.
- [ ] Resume Quest is disabled with no save; loads saved chapter with one.
- [ ] `localStorage.getItem('lotk_save')` contains `{ hero, track, chapter }` after selection.
- [ ] HUD shows hero name and track badge (🌱 or ⚔️).
- [ ] Music plays (placeholder pattern OK).
- [ ] Cheat codes `Up,Up,Down,Down` / `Down,Down,Up,Up` cycle chapters.
- [ ] `← Menu` link works in both game files.
- [ ] `node --check` passes on the extracted `<script>` block.
