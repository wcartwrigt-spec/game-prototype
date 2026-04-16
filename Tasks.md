# Tasks and Handoff

## Current Scope
- Keep the prototype playable directly from `export-html5/index.html`.
- Preserve the current scene flow:
  `Lodge Lobby -> Water Park -> Forest Trail -> Magi Tower -> Victory`
- Keep the Kenney art pass in place.
- Keep spelling practice as the gate mechanic.

## Spelling Gate Design
- Audio-first prompt using browser `speechSynthesis`.
- Show a definition and a sentence with the target word blanked out.
- Require typed answers instead of multiple choice.
- Allow replay with `R` or the `Hear Word` button.
- Keep wrong answers retryable.
- Current word list:
  `gnarl`, `wrist`, `coach`, `city`, `game`, `match`, `limb`, `judge`, `know`, `knew`

## Immediate Next Steps
- Browser playtest the spelling gates end to end.
- Check that audio replay works reliably on Chrome after user interaction.
- Tune hint timing and difficulty if the words still feel too easy or too frustrating.
- Verify mobile/touch usability for the new spelling input overlay.
- Decide whether to add scoring, streaks, or stars for clean spelling rounds.

## Acceptance Checklist
- `export-html5/index.html` runs without a server.
- Player can finish all scenes and unlock every gate.
- Spelling prompts do not display the answer directly in visible text.
- Audio can replay during spelling rounds on supported browsers.
- Wrong answers allow retry without soft-locking progression.
- README and task docs reflect the current build.
