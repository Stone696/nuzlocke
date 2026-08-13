# 2.0.0-beta.27.16 release notes

beta.27.16 is the final release candidate for the complete beta.27 feature line. It is built directly from beta.27.15 and preserves save schema 4, manifest API 2, and compatibility API v22.

This pass reviewed five reported release blockers against both the mod and the audited Gold engine:

- Kept R/B/Y's `GAME_CORNER_PRIZE_ROOM` and Gold's `CELADON_GAME_CORNER_PRIZE_ROOM` as distinct, correct engine IDs and centralized all Game Corner IDs to prevent accidental cross-generation substitution.
- Fixed Gold Game Corner wrappers so `Specials.HANDLERS` and `Specials.ALL` are captured, wrapped, and restored independently. Missing registry entries remain missing across installation and reload.
- Restored Gold Nickname Rule installation and configuration visibility. Supported catches cannot decline the prompt, empty/all-space names cannot exit, and scripted gifts—including the Johto starter—block on Gold's native naming screen before the story VM resumes.
- Confirmed native Gold `loadwildmon` encounters already use `battle.wild`; additionally broadened the Ball gate to accept explicit static/fixed provenance from other mods that construct fixed battles outside the native `opts.wild` path.
- Clarified Ball Use Ban tier 4 as `STANDARD`: it bans Poke, Great, Ultra, and Master Balls while leaving specialty/custom Balls eligible. `ALL` remains the distinct every-Ball ban. Persisted numeric values and mechanics are unchanged, and denial guidance now accurately describes the remaining scope.

The package includes the full mod source, manifest, documentation, compatibility notes, checksums, and repeatable release tests. The final automated gate passes, but Gold rules labeled TEST REQUIRED should still receive the disposable-save manual pass in `TESTING.md` before a stable/non-beta tag.

## Upgrade notes

- Save schema remains 4; no destructive migration is introduced.
- Tier 4 Ball Use Ban saves remain value `4`; only its displayed name changes from `MASTER` to `STANDARD`.
- Fully quit and relaunch Gen1Recomp after replacing an older build so module-level wrappers cannot survive from the previous session.
- Back up important saves before validating Whiteout or Permadeath.
- Setup appears only when the final title menu has no detected save/CONTINUE entry.
- Route, Mt. Moon, and Safari split modes default OFF and can be changed without deleting tracker history.
