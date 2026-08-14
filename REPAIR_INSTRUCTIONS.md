# beta.29.3.0 release repair set

This package repairs the current `Stone696/nuzlocke` `nuzlocke-2.0-beta` branch from its partially promoted beta.29.2.7 identity to beta.29.3.0.

## Why this is a patcher instead of wholesale replacement files

The live repository contains a ~694 KB `main.lua` and large cumulative documentation/history files. The safe project rule is to preserve the current branch and make narrow forward edits, not replace it from an older snapshot. The included patcher edits only current release identity/documentation and deliberately preserves historical beta.29.2.7 references.

## Use

1. Check out `nuzlocke-2.0-beta`.
2. Make sure your working tree contains the current GitHub HEAD you intend to repair.
3. Copy `apply_beta_29_3_0_repair.py` to the repository root.
4. Run `python apply_beta_29_3_0_repair.py`.
5. Copy `manifest.json` and `docs/RELEASE_NOTES.md` from this package over the generated versions if desired; they are included as canonical references.
6. Review `git diff`.
7. Run `node tests/release_gate.js main.lua`.
8. Commit only after the diff shows release-state/documentation changes and no gameplay logic changes.

## Expected modified/added files

- `main.lua` — build metadata strings only; no gameplay logic.
- `manifest.json`
- `README.md`
- `CHANGELOG.md`
- `mod.card`
- `docs/API.md`
- `docs/COMPATIBILITY.md`
- `docs/DOCUMENTATION_CHANGELOG.md`
- `docs/FEATURE_CONFIDENCE.md`
- `docs/TESTING.md`
- `docs/USER_GUIDE.md`
- `docs/RELEASE_NOTES.md` — added/replaced.

Historical beta.29.2.7 changelog entries and evidence references are intentionally retained.
