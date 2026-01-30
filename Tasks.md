# Tasks for Codex (Milestone M1 → Playable Loop)

## M1 Scope
- Title + 4 gameplay scenes + Victory.
- Player controller + HUD + dialog + quiz system + one pet.
- Save/continue via localStorage.
- HTML5 export placed in `export-html5/`.

## Scene Acceptance
- **Lobby**: 3 runes, gate needs 3; math difficulty: addition ≤10.
- **Water Park**: 2 moving hazards, Golden Key, gate needs key; ± within 20.
- **Forest Trail**: adopt Pine Pup after simple prompt; 2 checkpoints.
- **Tower**: collect Wand; final × 2–5 gate; Victory.

## Technical
- GDevelop (web). Base 1024×576. Fit to window.
- Input: arrows/WASD, Space/W/↑, E, P, 1–4 for quizzes.
- Pet system via external events; quiz system via external events.
- Export: HTML5 → `export-html5/`.

## Delivery checklist
- `export-html5/index.html` runs on Chromebook with no server.
- Wrong quiz answers allow immediate retry (no hard fail).
- Title shows “Continue” if a save exists.
