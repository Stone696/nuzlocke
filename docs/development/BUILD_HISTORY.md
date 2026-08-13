# Internal Build History

Internal engineering record. Repository/dev-only. Excluded from public/player packages via `docs/development/` in `.modkitignore`.

## 2.0.0-beta.29.1.0 — Gen1Recomp 0.1.83 compatibility candidate, 2026-08-13

**Parent:** `2.0.0-beta.29.0.2`

### Goal

Make the beta.29.0.2 gameplay candidate loadable and testable on the current Gen1Recomp 0.1.83 release after exact-source seam review, without rewriting protected gameplay behavior solely for architectural cleanliness.

### Changes

- No intended gameplay behavior change from beta.29.0.2.
- `recompCompatAudited` advanced from 0.1.81 to 0.1.83.
- Added explicit engine profiles for 0.1.82 and 0.1.83.
- Manifest/mod.card range widened from `>=0.1.81 <0.1.82` to `>=0.1.81 <0.1.84`.
- Gen1Recomp Mod API remains 2; Nuzlocke Compatibility API remains 25 with floor 10; save schema remains 4.
- Existing ENC TRACKER implementation deliberately preserved; 0.1.83 Gold `mapOverview()` is additive and deferred for behavioral-equivalence evaluation rather than adopted immediately.

### Exact-source compatibility findings

- v0.1.83 retains compatible Gen 1 BattleState constructor/throw/faint/finish/nickname/damage methods used by Nuzlocke.
- `Status.residual`, `ItemEffects.use`, `ShopMenu.new`, and SaveData persistence/slot helpers remain compatible.
- Gold retains `BattleState:finishBattle`, `Specials.block`, `Vm` `loadwildmon`, shared battle lifecycle events, and MainMenu hook semantics relied on by Nuzlocke.
- Gen1Recomp Mod API is still 2 and engine save format is still 4.
- The 0.1.82→0.1.83 delta does not replace the protected Nuzlocke gameplay seams; its principal mod-facing addition is Gold `mapOverview()`.

### Runtime evidence available before this build

- Gen1Recomp 0.1.83 Mod Manager recognized a manually imported beta.29.0.2 candidate, its version/category, and R/B/Y/Gold targets.
- The old beta.29.0.2 `<0.1.82` compatibility gate correctly refused to load on 0.1.83.
- Pressing Update on the unpublished candidate installed the latest published beta.27.16 release, proving update/download/install plumbing but also demonstrating that unpublished candidates must be manually imported.
- The engine can present beta tags as a leading `2.0.0` update comparison; final public update behavior requires an end-to-end post-publication test.

### Protected behavior touched

No gameplay implementation path is intentionally changed. The compatibility metadata/profile touches release loading only. All beta.29.0.2 four-fix regression requirements and all earlier protected runtime behavior remain in force.

### Validation

- Exact-source 0.1.83 compatibility inspection: PASS for reviewed seams.
- Structural release gate: **55/55 PASS** before packaging.
- Player/repository ZIP integrity: PASS.
- Player package exclusion check: PASS; `docs/development/` and repository-only tooling are absent.
- Lua/LuaJIT behavior smoke: NOT EXECUTED here; compatible executable unavailable.
- Upstream modkit validate/lint/gen2check: NOT EXECUTED here; complete local 0.1.83 source/imported-data checkout unavailable.
- beta.29.1.0 gameplay runtime on 0.1.83: REQUIRED.

### Runtime tests required

1. Import beta.29.1.0 into Gen1Recomp 0.1.83 and confirm Ready rather than Incompatible.
2. Gold fresh Setup/New Game startup smoke.
3. Yellow existing-save Rules/Tracker/Catch Info smoke.
4. Run the beta.29.0.2 four-fix regression matrix.
5. Continue the high-priority numeric, temporary-party, Gold shop/item, and Whiteout tests already listed in `docs/TESTING.md`.
6. After an eventual public release, test beta.27.16 → beta.29.1.0 through the Mod Manager and verify the installed version after restart.

### Documentation

Updated README, User Guide, Compatibility, API, Feature Confidence, Documentation Changelog, main Changelog, Testing, mod.card, manifest, issue template, release gate, and internal engineering ledgers to reflect 0.1.83 support and remaining runtime obligations.

### Known issues / follow-up

- beta.29.0.2 scripted-gift/nickname, Gold PC-gift, First Rival Mercy, and scripted-static changes still require runtime confirmation.
- Lost-encounter vs Pokémon-death presentation remains open.
- UI-theme composition/native collapse glyph work remains open.
- Current Gen1Recomp beta-tag update comparison may display a redundant update notice; do not change Nuzlocke version lineage merely to mask this engine behavior.

## 2.0.0-beta.29.0.2 — reviewed bug-fix candidate, 2026-08-13

**Parent:** `2.0.0-beta.29.0.1`

### Goal

Implement only the four completed pre-runtime code-review decisions, preserve previously runtime-confirmed behavior around the touched seams, add targeted regression coverage, and produce the next candidate for in-game testing.

### Code changes

- Removed unused First Rival Mercy `armed` / `triggered` persisted writes; retained `nuzlocke_first_rival_battle_seen` and battle-local authorization/trigger flags.
- Added `syncHistoryNickname(mon)` on the existing internal export namespace and call it only after mandatory scripted naming completes on R/B/Y and Gold.
- Added Gold owned-Pokémon snapshot/diff helpers covering party plus boxes, with party-first detection preserved.
- Changed pending scripted-static provenance to be consumed by every actual battle before trainer/wild stamping.

### Protected runtime-sensitive behavior touched

- First Rival Mercy and native loss flow.
- R/B/Y and Gold starter/gift acquisition registration, nickname enforcement, tracker/history, and area ownership.
- Gold full-party storage behavior.
- R/B/Y and Gold static classification / No Static enforcement.

Historical runtime passes remain evidence, but current confidence on changed paths is reduced pending retest.

### API/save/engine impact

- Gen1Recomp Mod API remains 2.
- Nuzlocke Compatibility API remains 25; compatibility floor remains 10.
- Save schema remains 4; no migration added.
- Existing ignored legacy Rival telemetry keys are not deleted from old saves.
- Manifest engine range remains `>=0.1.81 <0.1.82`.

### Validation

- Structural release gate: PASS (49/49).
- Behavior smoke suite extended for all four fixes but NOT EXECUTED here because a compatible Lua/LuaJIT runtime is unavailable.
- Upstream modkit validate/lint/gen2check NOT EXECUTED here because the required compatible engine/imported-data checkout is unavailable.
- Targeted in-game runtime validation: REQUIRED.

### Next step

Run the beta.29.0.2 runtime matrix before promoting confidence or treating these fixes as runtime-confirmed.

## 2.0.0-beta.29.0.1 — release-candidate rebuild, 2026-08-13

**Parent:** `2.0.0-beta.29.0.0`

### Goal

Rebuild the unapproved beta.29.0.1 release-candidate package without changing gameplay behavior, while strengthening documentation history, credit wording, regression evidence, known-issue visibility, and internal development records.

### Public-document changes

- `README.md`: runtime-evidence/regression-protection section, narrowed Credits, planned-work recovery, current code-review blockers.
- `CHANGELOG.md`: expanded recoverable version/dev history and explicit treatment of conflicting historical artifacts.
- `docs/USER_GUIDE.md`: narrowed Credits and current limitations.
- `docs/DOCUMENTATION_CHANGELOG.md`: document-by-document reasoning and rebuild record.
- `docs/FEATURE_CONFIDENCE.md`: current code-review defects reflected in affected confidence rows.
- `docs/COMPATIBILITY.md`: interoperability evidence wording normalized.
- `docs/API.md`: API namespaces explicitly separated.
- `mod.card`: narrowed credit role and current known limitations.

### Internal-development changes

- `CODE_REVIEW_HISTORY.md` retains the four current code-review findings and decisions.
- `HISTORY_RECOVERY_AUDIT.md` retains recovered changelog evidence and unresolved historical conflicts.
- `BACKLOG_RUNTIME_AUDIT.md` retains runtime evidence, known blockers, and planned/future work without feature-level attribution.
- Structural release-gate checks expanded to protect the public documentation/credit conventions.

### Gameplay/API/save impact

- No intended gameplay change from beta.29.0.0.
- Gen1Recomp Mod API remains 2.
- Nuzlocke Compatibility API remains 25 with compatibility floor 10.
- Save schema remains 4.
- Manifest engine range remains `>=0.1.81 <0.1.82`.

### Known code-review blockers before the next runtime-test candidate

1. First Rival Mercy write-only telemetry cleanup.
2. Scripted gift/starter history-name synchronization after mandatory naming.
3. Gold PC-routed scripted-gift acquisition detection.
4. Gold one-shot static-provenance lifecycle hardening.

### Validation

- Structural release gate: PASS (45 checks after rebuild).
- Public/internal text scrub for prohibited provenance wording: PASS.
- Public credit-role scan: PASS.
- Upstream `modkit validate`, `modkit lint`, and `modkit gen2check`: NOT EXECUTED in this workspace because a complete compatible Gen1Recomp checkout/imported-data tree is not available.
- Lua/LuaJIT behavior smoke suite: NOT EXECUTED in this workspace because a compatible runtime executable is not installed.

### Next step

Apply the reviewed bug-fix batch in the next versioned candidate, add targeted regression checks, then perform runtime validation on that resulting build.
