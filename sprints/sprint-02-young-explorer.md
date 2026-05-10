# Sprint 02 — Young Explorer Track (🌱)

> **Depends on Sprint 01 completing first.**
> **Can run in parallel with Sprint 03.**
> **Estimated effort:** 1 agent session.

---

## Context

Sprint 01 produced `export-html5/lotk.html` with a working shell: hero select, save/load, player physics, stub chapter loader, and bubble layer. This sprint implements the **full Young Explorer track** (`game.track === 'young'`) — the path chosen by Benjamin Brandybuck and Theodore Took, designed for ages 5–7.

**Young Explorer core rules (never break these):**
- Only individual **lowercase letters** are typed. No words, no numbers, no Shift.
- One letter challenge at a time. Never queue more than one pending letter.
- First wrong press: gentle shake + retry, **no heart loss**.
- Boss letter rain is slow and always completable by a 5-year-old.
- Chapter-complete always awards ⭐⭐⭐. No WPM displayed.

---

## Task 1 — Populate CHAPTERS for Young Explorer

Open `lotk.html` and fill in each of the 7 `CHAPTERS[i]` entries with the content below. All fields already exist as stubs from Sprint 01. You are filling in the values.

### Chapter backgrounds

```js
// index: [top, bottom]
0: ['#b8e0a0','#6aad58']  // Shire — lush green
1: ['#8ec4a0','#3d7a50']  // Old Forest — deep green
2: ['#6080a0','#2a3a50']  // Weathertop — stormy grey-blue
3: ['#302828','#181010']  // Moria — near black, dark red
4: ['#c8e8d8','#80b898']  // Lothlórien — silver-green
5: ['#b04030','#601820']  // Pelennor — battle red
6: ['#401010','#200808']  // Mount Doom — deep crimson
```

### Chapter widths

Chapters 0–6: `1600, 1700, 1600, 1500, 1700, 1800, 1500`

### Letter pools per chapter

```js
CHAPTERS[0].typingLesson.young.letters = ['a','s','d','f'];
CHAPTERS[1].typingLesson.young.letters = ['a','s','d','f','g','h','j','k'];
CHAPTERS[2].typingLesson.young.letters = ['a','s','d','f','g','h','j','k','l','q','w','e'];
CHAPTERS[3].typingLesson.young.letters = ['a','s','d','f','g','h','j','k','l','q','w','e','r','t','y','u'];
CHAPTERS[4].typingLesson.young.letters = ['a','s','d','f','g','h','j','k','l','q','w','e','r','t','y','u','i','o','p','z'];
CHAPTERS[5].typingLesson.young.letters = ['a','s','d','f','g','h','j','k','l','q','w','e','r','t','y','u','i','o','p','z','x','c','v','b'];
CHAPTERS[6].typingLesson.young.letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
```

### New letters introduced per chapter (for lesson phase highlighting)

```js
CHAPTERS[0].typingLesson.young.newLetters = ['a','s','d','f'];
CHAPTERS[1].typingLesson.young.newLetters = ['g','h','j','k'];
CHAPTERS[2].typingLesson.young.newLetters = ['l','q','w','e'];
CHAPTERS[3].typingLesson.young.newLetters = ['r','t','y','u'];
CHAPTERS[4].typingLesson.young.newLetters = ['i','o','p','z'];
CHAPTERS[5].typingLesson.young.newLetters = ['x','c','v','b'];
CHAPTERS[6].typingLesson.young.newLetters = ['n','m'];
```

### Boss chapters

Chapters 2 (Weathertop), 5 (Pelennor), 6 (Mount Doom) have bosses. Set `CHAPTERS[i].boss`:

```js
CHAPTERS[2].boss = { name:'The Wraith Rider', hp:3, letterFallInterval:2.0, emoji:'🖤' };
CHAPTERS[5].boss = { name:'The Witch-King',   hp:4, letterFallInterval:1.6, emoji:'👑' };
CHAPTERS[6].boss = { name:'The Dark Tyrant',  hp:4, letterFallInterval:1.2, emoji:'💍' };
```

### Chapter dialog content

Add 2–3 dialog cards per chapter (title + body text). Use the LOTR narrative:

```js
CHAPTERS[0].dialogs = [
  { title:'The Green Dragon Inn', body:'Welcome, young adventurer! The Shire is peaceful and full of friends. Let\'s learn the keys together!' },
  { title:'Bilbo\'s Advice', body:'Start with these four keys: A, S, D, F. Press each letter when you see it glow!' }
];
CHAPTERS[1].dialogs = [
  { title:'Old Man Willow', body:'The Old Forest is tricky. New letters await — G, H, J, K join your quest!' },
  { title:'Tom Bombadil', body:'Hey-derry-merry! Press the glowing letter and the path will open!' }
];
CHAPTERS[2].dialogs = [
  { title:'Amon Sûl', body:'Weathertop is dangerous. The Wraith Rider approaches! Type fast and hold it off!' },
  { title:'Strider\'s Warning', body:'New letters L, Q, W, E will help you. Watch the skies!' }
];
CHAPTERS[3].dialogs = [
  { title:'Mines of Moria', body:'Darkness everywhere. But your letters glow in the deep. R, T, Y, U light the way.' },
  { title:'Speak, Friend', body:'The door is shut tight. Only the right letters will open it.' }
];
CHAPTERS[4].dialogs = [
  { title:'Lothlórien', body:'Lady Galadriel welcomes you. The forest shimmers. New keys: I, O, P, Z.' },
  { title:'The Mirror', body:'Look into the mirror. What letters do you see?' }
];
CHAPTERS[5].dialogs = [
  { title:'Pelennor Fields', body:'The great battle begins! X, C, V, B join your arsenal. Stand firm!' },
  { title:'Éowyn\'s Call', body:'I am no man! And you are no quitter. Type with courage!' }
];
CHAPTERS[6].dialogs = [
  { title:'Mount Doom', body:'The final two — N and M. Now you know all 26 letters. Use them!' },
  { title:'The Crack of Doom', body:'Type every letter the Tyrant sends. The Ring must be destroyed!' }
];
```

### Platform layouts

Add platforms to each chapter. Use the same format as MagiWolf's `SCENES` platforms (`{ x, y, w, h, type }`). Types: `'ground'`, `'wood'`, `'stone'`. Each chapter has a ground platform spanning the full width at y=510, plus 3–5 elevated platforms:

```js
// Chapter 0 — The Shire (example, use similar for all 7)
CHAPTERS[0].platforms = [
  { x:0,    y:510, w:1600, h:66, type:'ground' },
  { x:300,  y:420, w:180,  h:20, type:'wood' },
  { x:600,  y:360, w:200,  h:20, type:'wood' },
  { x:900,  y:300, w:160,  h:20, type:'wood' },
  { x:1200, y:380, w:140,  h:20, type:'wood' }
];
// Add similar layouts for chapters 1–6, varying heights/widths.
```

### Enemy spawns per chapter

Each chapter has 2–4 enemies. Use the same format as MagiWolf (`{ x, y, w, h, vx, minX, maxX }`). Enemies are slow (vx 30–50). For Young Explorer, each enemy also carries a random letter from the chapter pool (assigned at spawn time, not hardcoded):

```js
CHAPTERS[0].enemies = [
  { x:400, y:468, w:32, h:32, vx:35, minX:300, maxX:600 },
  { x:900, y:468, w:32, h:32, vx:-35, minX:700, maxX:1100 }
];
// Add similar for chapters 1–6
```

### Gate and exit positions

```js
// Set gate x near the right side, exit just past it
CHAPTERS[0].gate = { id:'shire',    x:1420, y:350, w:90, h:150 };
CHAPTERS[0].exit = { x:1510, y:350, w:70, h:150, target:1 };
CHAPTERS[1].gate = { id:'forest',   x:1520, y:350, w:90, h:150 };
CHAPTERS[1].exit = { x:1610, y:350, w:70, h:150, target:2 };
// ...and so on for chapters 2–6
CHAPTERS[6].exit = { x:1410, y:350, w:70, h:150, target:7 }; // target 7 = victory
```

---

## Task 2 — Lesson Phase (Young Explorer)

This phase runs at the start of each chapter **only if `game.track === 'young'`**.

The `#lesson-overlay` DOM panel covers the canvas. It shows:

1. **Header:** `"Chapter [N]: [Name] — Let's learn new keys!"`
2. **New letter announcement:** `"New letters this chapter: [A] [S] [D] [F]"` — each displayed as a large highlighted key badge.
3. **Drill area:** A giant glyph display (`font-size: 160px`, centered, gold color) showing the current target letter.
4. **On-screen keyboard diagram:** A simplified ASCII-art keyboard rendered as styled `<div>` elements. The target letter's key is highlighted in gold.
5. **Instruction:** `"Press this key on your keyboard!"`

**Drill logic:**
- Show each new letter 3 times in sequence (e.g., `a, a, a, s, s, s, d, d, d, f, f, f`).
- On correct keypress: play a cheerful Web Audio chime (short sine wave burst, 880Hz, 0.1s), sparkle FX, advance to next letter.
- On wrong keypress: gently shake the glyph div (`@keyframes shake`), no penalty.
- After all drill letters complete: show "Great job! Now go find the matching letters on your adventure!" → button `Start Adventure` → hide overlay, start adventure phase.

```js
function startYoungLesson(chapter) {
  game.lessonActive = true;
  const lesson = chapter.typingLesson.young;
  const drill = lesson.newLetters.flatMap(l => [l,l,l]); // 3× each new letter
  let idx = 0;
  showLessonOverlay(drill[0], lesson.newLetters, chapter.index + 1, chapter.name);
  game._youngDrill = { drill, idx, onComplete: () => {
    hideLessonOverlay();
    game.lessonActive = false;
    startAdventurePhase(chapter);
  }};
}

document.addEventListener('keydown', e => {
  if (!game.lessonActive || game.track !== 'young') return;
  const d = game._youngDrill;
  if (e.key === d.drill[d.idx]) {
    playChime(880, 0.1);
    spawnFx({ x:512, y:288, count:12, color:'#ffe38f', life:0.6 });
    d.idx++;
    if (d.idx >= d.drill.length) { d.onComplete(); }
    else { updateLessonGlyph(d.drill[d.idx]); }
  } else {
    shakeLessonGlyph();
  }
});
```

---

## Task 3 — Adventure Phase (Young Explorer)

After the lesson, the canvas is active. Enemies walk toward the player. Each enemy has a randomly assigned letter from the chapter's current pool displayed in a large speech-bubble div above it.

**Bubble rendering:**
```js
function spawnEnemyBubble(enemy) {
  const el = document.createElement('div');
  el.className = 'letter-bubble';
  el.textContent = enemy.letter; // single uppercase letter for readability
  el.style.cssText = `position:absolute; font-size:32px; font-weight:900;
    background:rgba(255,248,220,0.95); border-radius:12px; padding:6px 14px;
    border:2px solid #c4922a; color:#2a1800; pointer-events:none;`;
  el.id = `bubble-${enemy.id}`;
  document.getElementById('bubble-layer').appendChild(el);
}

function updateEnemyBubblePos(enemy) {
  const pos = worldToScreen(enemy.x + enemy.w/2 - 24, enemy.y - 52);
  const el = document.getElementById(`bubble-${enemy.id}`);
  if (el) { el.style.left = pos.x+'px'; el.style.top = pos.y+'px'; }
}
```

**Keypress handling (adventure phase):**
- Determine the "active" enemy: the one whose letter matches the key pressed, prioritizing closest to the player.
- On correct key: defeat that enemy (remove from scene, remove bubble, sparkle FX).
- On wrong key (first press): show red flash on all bubbles (`.bubble-shake` class for 0.3s). No heart loss.
- On wrong key (second press): player loses 1 heart; invuln timer starts (same as MagiWolf).
- Enemy reaching player x position: player loses 1 heart, enemy removed.

**Pickup: Rune Stones** — 3 per chapter, same position logic as MagiWolf runes. Collect all 3 to unlock the gate.

---

## Task 4 — Gate Challenge (Young Explorer)

When the player reaches the gate and has all 3 Rune Stones, the gate challenge activates.

**UI:** A DOM overlay showing a sequence of 2–4 letters displayed as large styled keys, one at a time.

- Chapter 1: 4 letters (`a, s, d, f` one at a time)
- Chapter 2: sequence of 6 letters from pool
- Chapters 3–7: sequence of 8 letters from pool

**Logic:**
- Show first letter. Player presses it → correct chime + advance. Wrong → shake + retry.
- No time limit. No heart loss for wrong presses at the gate.
- Complete sequence → gate opens (draw open-door sprite), player can pass to exit.

---

## Task 5 — Boss Battles (Young Explorer)

Bosses appear in Chapters 2 (Weathertop), 5 (Pelennor), 6 (Mount Doom).

**Canvas-drawn boss** (same approach as Stormshell Rex in MagiWolf):
- A large dark rectangle with glowing ember details, drawn procedurally.
- Wraith Rider: grey cloak shape, red eye glow.
- Witch-King: armored angular silhouette, crown shape.
- Dark Tyrant: tall shadow with a floating golden ring shape above it.

**Boss mechanic (Young track):**

Letters fall from the top of the canvas, one at a time. Each letter is a large styled `<div>` in `#bubble-layer` that animates downward (`transition: top Xs linear`).

```js
function spawnBossLetter(pool, fallDuration) {
  const letter = pool[Math.floor(Math.random() * pool.length)];
  const el = document.createElement('div');
  el.className = 'falling-letter';
  el.textContent = letter.toUpperCase();
  const startX = 100 + Math.random() * 800;
  el.style.cssText = `position:absolute; left:${startX}px; top:0px;
    font-size:52px; font-weight:900; color:#ffdd44;
    text-shadow: 0 0 12px #ff8800; pointer-events:none;
    transition: top ${fallDuration}s linear;`;
  document.getElementById('bubble-layer').appendChild(el);
  el.dataset.letter = letter;
  el.dataset.id = Date.now() + Math.random();
  setTimeout(() => el.style.top = '510px', 50);
  // If letter reaches bottom without being caught → player loses heart, remove el
  el._timer = setTimeout(() => {
    if (el.parentNode) { el.parentNode.removeChild(el); takeHit(); }
  }, fallDuration * 1000);
  return el;
}
```

**Fall intervals by chapter:**
- Ch. 2 (Wraith Rider): 1 letter every 2.0 seconds.
- Ch. 5 (Witch-King): 1 letter every 1.6 seconds.
- Ch. 6 (Dark Tyrant): 1 letter every 1.2 seconds.

**Keypress:** When player presses a key matching any falling letter's `data-letter`, the first matching letter is removed with a sparkle, boss takes 1 HP damage, hit-flash drawn on boss canvas element. Boss HP reaches 0 → defeat animation (boss dissolves, light burst, chapter complete).

**Two misses (letters reaching the bottom):** Boss fully heals, battle resets. Show dialog: "Try again! The letters are coming!"

---

## Task 6 — Lore Quests (All 7 Chapters)

> **Note to Sprint 03 agent:** These `LORE_QUESTS` are defined here. Import/share the same object rather than redefining.

Optional multiple-choice trivia (4 questions each). Same DOM structure as MagiWolf STEM quests. Completing rewards `+1 max heart` (cap 6). Each quest station is a glowing object the player can interact with (press E).

```js
const LORE_QUESTS = [
  { // Chapter 0 — The Shire
    id:'shire', title:'Hobbit Wisdom', reward:'+1 max heart',
    questions:[
      { body:'What makes a good neighbor?', answer:'Kindness', choices:['Kindness','Loudness','Hiding','Arguing'] },
      { body:'Hobbits love to eat. How many meals do they try to have each day?', answer:'Seven', choices:['Two','Three','Five','Seven'] },
      { body:'What should you do when you meet someone new?', answer:'Say hello and smile', choices:['Run away','Say hello and smile','Ignore them','Yell'] },
      { body:'The Shire is a peaceful place. What word means peaceful?', answer:'Calm', choices:['Loud','Calm','Dark','Stormy'] }
    ]
  },
  { // Chapter 1 — Old Forest
    id:'forest', title:'Nature Quest', reward:'+1 max heart',
    questions:[
      { body:'What do trees need to grow tall?', answer:'Sunlight and water', choices:['Candy','Sunlight and water','Sand','Ice'] },
      { body:'What do roots do for a plant?', answer:'Hold it in the ground', choices:['Make flowers','Hold it in the ground','Catch birds','Make shade'] },
      { body:'What season do leaves fall from trees?', answer:'Autumn', choices:['Spring','Summer','Autumn','Winter'] },
      { body:'Which of these is a living thing?', answer:'A tree', choices:['A rock','A cloud','A tree','A puddle'] }
    ]
  },
  { // Chapter 2 — Weathertop
    id:'weathertop', title:'Weather Watch', reward:'+1 max heart',
    questions:[
      { body:'Which direction does the sun rise?', answer:'East', choices:['North','South','East','West'] },
      { body:'What should you do if you hear thunder?', answer:'Go inside', choices:['Go swimming','Climb a tree','Go inside','Run in circles'] },
      { body:'What causes rain?', answer:'Water drops in clouds', choices:['Giants crying','Water drops in clouds','Wind machines','Magic'] },
      { body:'Which is the coldest weather?', answer:'Snow', choices:['Rain','Wind','Fog','Snow'] }
    ]
  },
  { // Chapter 3 — Moria
    id:'moria', title:'Earth Explorer', reward:'+1 max heart',
    questions:[
      { body:'What hangs from the ceiling of a cave?', answer:'Stalactite', choices:['Stalactite','Stalagmite','Mushroom','Moss'] },
      { body:'What grows up from a cave floor?', answer:'Stalagmite', choices:['Stalactite','Stalagmite','Crystal','Water'] },
      { body:'What do we call rocks that contain metal?', answer:'Ore', choices:['Ore','Sand','Mud','Chalk'] },
      { body:'What is the center of the Earth made of?', answer:'Hot melted rock', choices:['Ice','Water','Hot melted rock','Dirt'] }
    ]
  },
  { // Chapter 4 — Lothlórien
    id:'lothlorien', title:'Star Gazing', reward:'+1 max heart',
    questions:[
      { body:'How many stars make up the Big Dipper?', answer:'Seven', choices:['Five','Six','Seven','Eight'] },
      { body:'What is the closest star to Earth?', answer:'The Sun', choices:['The Moon','The Sun','Venus','Polaris'] },
      { body:'What do we call a group of stars that form a picture?', answer:'Constellation', choices:['Galaxy','Constellation','Meteor','Planet'] },
      { body:'Stars twinkle because of what?', answer:'Earth\'s atmosphere', choices:['Wind','Magic','Earth\'s atmosphere','They blink'] }
    ]
  },
  { // Chapter 5 — Pelennor
    id:'pelennor', title:'Team Spirit', reward:'+1 max heart',
    questions:[
      { body:'What makes a team strong?', answer:'Working together', choices:['One person doing everything','Arguing','Working together','Being quiet'] },
      { body:'If a teammate makes a mistake, what should you do?', answer:'Encourage them', choices:['Laugh at them','Encourage them','Ignore them','Blame them'] },
      { body:'What does a team captain do?', answer:'Leads and listens', choices:['Does all the work','Leads and listens','Plays alone','Gives orders only'] },
      { body:'Why is it good to celebrate a team win together?', answer:'It makes everyone feel valued', choices:['It is not good','It makes everyone feel valued','Only winners should celebrate','It wastes time'] }
    ]
  },
  { // Chapter 6 — Mount Doom
    id:'mountdoom', title:'Never Give Up', reward:'+1 max heart',
    questions:[
      { body:'When something is hard, what helps most?', answer:'Keeping on trying', choices:['Giving up','Asking for magic','Keeping on trying','Waiting for it to get easy'] },
      { body:'What does perseverance mean?', answer:'Continuing even when it is tough', choices:['Giving up fast','Being perfect','Continuing even when it is tough','Doing it quickly'] },
      { body:'If you feel tired during a challenge, what should you do?', answer:'Take a short break and try again', choices:['Quit','Cry forever','Take a short break and try again','Wait for someone else'] },
      { body:'What is the best thing about finishing something hard?', answer:'You feel proud and grow stronger', choices:['Nothing','Getting a prize','You feel proud and grow stronger','Telling everyone you did it'] }
    ]
  }
];
```

Wire each `LORE_QUESTS[i]` to `CHAPTERS[i].loreQuest = LORE_QUESTS[i]`.

**Quest station trigger:** A glowing sign prop on the canvas (drawn as a glowing rect with `★ QUEST` text). When player is within 80px and presses E, show the lore quest overlay. Same logic as MagiWolf side quests.

---

## Task 7 — Chapter Complete Screen

After boss defeat (boss chapters) or gate passage (non-boss chapters), show `#chapter-complete`:

- Title: `"Chapter [N] Complete!"`
- Three gold stars: ⭐⭐⭐ (always, no accuracy check for Young track)
- Praise message (rotate through): `"Amazing!", "You're a hero!", "Fantastic typing!", "The Fellowship is proud!"`
- Companion earned (if Lore Quest completed this chapter): show companion name + emoji + ability description
- Button `Continue the Quest →` → `loadChapter(game.chapter + 1)`

Save to localStorage before showing the screen.

---

## Acceptance Criteria

- [ ] Selecting Benjamin Brandybuck or Theodore Took sets `game.track === 'young'`.
- [ ] Chapter 1 lesson phase shows giant letter glyphs for `a,s,d,f` (3× each). Correct press advances, wrong press shakes.
- [ ] Chapter 1 adventure phase: enemies carry single letters; correct key press defeats enemy with sparkle.
- [ ] Wrong key (first press): bubbles shake, no heart loss. Wrong key (second press): lose 1 heart.
- [ ] Gate opens after collecting 3 Rune Stones and completing the letter sequence.
- [ ] Chapter 3 boss: letters rain at 1 per 2 seconds; correct key removes letter and damages boss.
- [ ] Boss HP reaches 0: defeat animation plays, chapter complete screen shows.
- [ ] Two letters reaching the ground: boss resets and heals.
- [ ] Chapter complete always shows ⭐⭐⭐, no WPM.
- [ ] Lore Quest station is interactable (press E); completion grants +1 max heart.
- [ ] All 7 chapters flow from Ch.1 → Ch.7 → Victory screen.
- [ ] Game saves chapter progress to localStorage after each chapter complete.
