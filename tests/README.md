# Test suite map — Nuzlocke

Tests are **developer source**, not player mod payloads.

## Current automated gates

- **`tests/run_gen3_smoke.sh`**: discovers every `gen3_*_smoke.lua` file and runs each in a separate Lua 5.1 process. Independent test files are intentionally retained: removing a file because another uses a similar mock can silently lose specific native-boundary coverage.
- **`tests/gen3_docs_gate.js`**: checks release version, contributor credit, documentation links and retained version history.
- **`tests/package_gate.sh`**: packages all root runtime Lua files plus mod metadata and minimal player documents, verifies no development files leak and checks byte-for-byte archive reproducibility.

## What the Gen 3 smoke files cover

- **Core/native integration**: foundation, new-core nickname/rival/PC, title/new-run setup, run-results native save and UI, QoL and nickname boundaries.
- **Catch/clauses and battle safety**: advanced catch bans, Dupes/Shiny/Roamer/Egg/Forgiveness, OHKO and battle/status clauses, battle/field items.
- **Randomisation and visuals**: seeded starter/wild/trainer/etc, Untamed overworld shiny interactions, shiny rate and shiny art/mini-icons.
- **Progression**: level caps, Hardcore/playstyle, Services & Economy, Pokémon Stats, Area Splits, Game Difficulty, Run/Party.
- **Archives and development**: snapshot copier, terminal results and guarded Nuz Dev restoration.

These are separate concerns even where fixture setup overlaps. **No active Gen 3 smoke is being discarded simply to make the repository appear smaller.** The CI file has instead been reduced from ~40 hand-maintained steps to a short, automatically discovered suite.

## Retired historical gate

`tests/invariants.js` was designed around a former Gen 1-only four-game manifest and 15-file release. It cannot legitimately validate the current Gen 1–3 repository and remains available **for history only**, not in current CI. `tests/release_gate.js` is a compatibility command that runs the maintained documentation/release gate. Legacy gameplay itself still needs manual regression testing alongside Gen 3.

## When deleting a test is appropriate

Only delete or merge a smoke after reviewing the specific assertions and demonstrating that a **maintained test** covers those exact regressions; keep CI green before and after the change. Do not prune tests merely because their filename contains `smoke`.
