# Design Doc — MagiWolf Quest

## Flow (critical path ~45 minutes)
1. **Lodge Lobby**: learn controls, collect 3 runes → math gate (addition ≤10).
2. **Water Park**: moving float hazards, collect Golden Key → math gate (± ≤20).
3. **Forest Trail**: adopt first pet (Pine Pup), light exploration.
4. **Magi Tower**: collect Wand → math gate (× 2–5) → Victory.

## Pets (light, any 1 active)
- Pine Pup: small jump forgiveness (grace window).
- Bubbloon: one hazard forgiveness per scene.
- Glimmowl: sparkle hint near secrets.

## Systems
- Platformer character (forgiving physics).
- Dialog cards (E to continue).
- Quiz overlay (blocks input; 1–4 answers).
- Checkpoints and **localStorage** save/continue.
- HUD: hearts, inventory (runes/key/wand), pet icon, level name, player name.

## Chromebook performance notes
- Resolution 1024×576 (16:9). Fit to window.
- Keep moving hazards ≤ 6 on screen.
- Prefer tweens; avoid heavy physics or huge textures.
