# MagiWolf Quest

Kid-friendly browser platformer prototype for Chromebook-friendly HTML5 play.

## Current Build
- Playable export lives in `export-html5/index.html`.
- Flow: `Lodge Lobby -> Water Park -> Forest Trail -> Magi Tower -> Victory`.
- Main character: `Magi Alastair`.
- Current gate mechanic: spelling practice, not math.
- Current pet companion: `Pine Pup`.

## Recent Changes
- Added a full art pass using free Kenney sprite packs stored in `export-html5/assets/`.
- Upgraded the HUD, title screen, prompts, gates, pickups, enemies, and background rendering.
- Replaced math gates with spelling gates using these words:
  `gnarl`, `wrist`, `coach`, `city`, `game`, `match`, `limb`, `judge`, `know`, `knew`
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
- `P`: pause
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
- The new spelling flow has not yet been browser playtested end to end after the typed-input rewrite.
- Next high-value work:
  playtest the spelling gate loop in-browser,
  tune hint difficulty and retry pacing,
  decide whether to keep browser TTS or add recorded audio later,
  commit and push once behavior is verified.
