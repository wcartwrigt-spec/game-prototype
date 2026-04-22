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
- Built-in music now uses softer synth playback with public-domain melody-inspired themes.
- Local test cheats allow fast scene skipping during development.

## Recent Changes
- Added a full art pass using free Kenney sprite packs stored in `export-html5/assets/`.
- Upgraded the HUD, title screen, prompts, gates, pickups, enemies, and background rendering.
- Expanded the adventure with a new `Inventor Workshop` platforming level.
- Added optional second-grade STEM side quests in multiple levels. Each station now pulls from a small multiple-choice question bank for replayability. Completing one grants `+1 max heart` and a full heal, capped at 6 hearts.
- Added a boss arena where correct spelling damages the boss and wrong spelling triggers a fire/lightning counterattack. Missed boss words recycle back into the queue instead of making the fight unwinnable.
- Side quests now hide audio replay so they behave like quick STEM multiple-choice checks instead of spoken spelling prompts.
- Improved the boss presentation with an intro cutscene, more animation, altar pulsing, projectile volleys between word phases, and a defeat crash/fade-out.
- Expanded the boss word bank to use the full current spelling set and increased boss HP so the finale lasts longer.
- Replaced the harsh procedural loop with softer melody-driven synth themes inspired by public-domain classical pieces.
- Added local development cheats:
  `Up, Up, Down, Down` skips forward one scene
  `Down, Down, Up, Up` skips backward one scene
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
- Development cheats:
  `Up, Up, Down, Down`: next scene
  `Down, Down, Up, Up`: previous scene

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
- The build has been iterated in-browser by the user, but the full route has not been re-playtested by Codex after the latest boss/music/STEM/UI pass.
- Next high-value work:
  playtest the full route from title through boss on desktop and Chromebook,
  verify the boss collapse timing feels satisfying and not too slow,
  decide whether to replace the melody-inspired synth with actual licensed/public-domain audio later,
  tune music arrangement variety if the exploration loop still feels repetitive over longer sessions.
