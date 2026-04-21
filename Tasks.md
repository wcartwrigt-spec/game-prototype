# Tasks and Handoff

## Current Scope
- Keep the prototype playable directly from `export-html5/index.html`.
- Preserve the current scene flow:
  `Lodge Lobby -> Water Park -> Forest Trail -> Inventor Workshop -> Magi Tower -> Boss Arena -> Victory`
- Keep the Kenney art pass in place.
- Keep spelling practice as the gate mechanic.
- Keep optional STEM side quests rewarding extra health.

## Spelling Gate Design
- Audio-first prompt using browser `speechSynthesis`.
- Show a definition and a sentence with the target word blanked out.
- Require typed answers instead of multiple choice.
- Allow replay with `R` or the `Hear Word` button.
- Side quests should not expose replay audio.
- Keep wrong answers retryable.
- Current word list:
  `Blonde`, `Soccer`, `Chicken`, `Panda`, `Harry Potter`, `Inventor`, `Piano`, `Tennis`, `Engineer`, `Music`

## Boss / Side Quest Design
- Final boss uses a wand-casting spelling battle in `Boss Arena`.
- Correct boss answers damage the boss.
- Wrong boss answers deal damage back and increase the miss counter.
- Two boss misses reset the battle.
- Boss should feel active between prompts with visible attack motion and projectiles.
- Optional STEM side quests now exist in:
  `Lodge Lobby`, `Water Park`, `Forest Trail`, `Inventor Workshop`, `Magi Tower`
- Completing a STEM side quest grants `+1 max heart` and a full heal, capped at 6 hearts.

## Immediate Next Steps
- Browser playtest the full game end to end.
- Verify the boss battle restarts correctly after two misses.
- Check that the boss exit stays blocked until the boss is defeated.
- Verify each STEM side quest only rewards one heart upgrade.
- Check that audio replay works reliably on Chrome after user interaction.
- Verify `Shift+P` pause does not interfere with spelling words containing `p`.
- Tune hint timing and difficulty if the words still feel too easy or too frustrating.
- Verify mobile/touch usability for the new spelling input overlay and boss sequence.
- Decide whether to add more boss rounds or simple cut-scene transitions later.

## Acceptance Checklist
- `export-html5/index.html` runs without a server.
- Player can finish all scenes, unlock every gate, and beat the boss.
- Spelling prompts do not display the answer directly in visible text.
- Audio can replay during spelling rounds on supported browsers.
- Wrong answers allow retry without soft-locking progression.
- STEM side quests are optional and increase health only once.
- Boss battle ends in victory after correct spellcasting and resets after two misses.
- README and task docs reflect the current build.
