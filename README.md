# MagiWolf Quest

Kid-friendly browser platformer prototype for Chromebook-friendly HTML5 play.

## Current Build
- Playable export lives in `export-html5/index.html`.
- Flow: `Lodge Lobby -> Water Park -> Forest Trail -> Inventor Workshop -> Magi Tower -> Boss Arena -> Victory`.
- Main character: `Magi Alastair`.
- Current gate mechanic: spelling practice, not math.
- Current pet companion: `Pine Pup`.
- New optional layer: STEM side quests that increase the heart meter.
- Final encounter: `Stormshell Rex`, a spiky turtle-dragon boss defeated through spelling spells.

## Recent Changes
- Added a full art pass using free Kenney sprite packs stored in `export-html5/assets/`.
- Upgraded the HUD, title screen, prompts, gates, pickups, enemies, and background rendering.
- Expanded the adventure with a new `Inventor Workshop` platforming level.
- Added optional second-grade STEM side quests in multiple levels. Completing one grants `+1 max heart` and a full heal, capped at 6 hearts.
- Added a boss arena where correct spelling damages the boss and wrong spelling triggers a fire/lightning counterattack. Two boss spelling misses reset the battle.
- Side quests now hide audio replay so they behave like quick STEM answers instead of spoken spelling prompts.
- Improved the boss presentation with more animation, altar pulsing, and projectile volleys between word phases.
- Replaced the old spelling set with:
  `Blonde`, `Soccer`, `Chicken`, `Panda`, `Harry Potter`, `Inventor`, `Piano`, `Tennis`, `Engineer`, `Music`
- Spelling gates now use:
  audio pronunciation via the browser Speech Synthesis API,
  a definition,
  a sentence with the target word blanked out,
  typed answer entry,
  replay and hint support.

## Controls
- `Left/Right` or `A/D`: move
- `Space`, `W`, or `Up`: jump
- `E`: interact / advance dialog
- `Shift+P`: pause
- During spelling gates:
  `Enter`: submit typed answer
  `R`: replay the spoken word

## Run
1. Open `export-html5/index.html` in Chrome or another modern browser.
2. No local server is required for the current prototype.
3. For the spelling gates, use a browser with `speechSynthesis` support so the word can be spoken aloud.

## Project Files
- `export-html5/index.html`: current playable build
- `export-html5/assets/`: imported sprite assets
- `Design_Doc.md`: higher-level game notes
- `Tasks.md`: active handoff / next-step checklist
- `TESTING.md`: manual test notes

## Handoff Notes
- The build has passed `node --check` on the extracted script.
- The new level flow, optional STEM quests, and boss battle have not yet been browser playtested end to end after this gameplay pass.
- Next high-value work:
  playtest the full route from title through boss on desktop and Chromebook,
  tune boss pacing and health if it feels too short or too punishing,
  decide whether to add recorded voice prompts later or keep browser TTS,
  push once the new boss battle feels right in-browser.
