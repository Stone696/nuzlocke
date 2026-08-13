# Internal History Recovery Audit

Internal engineering record. Repository/dev-only. Excluded from public/player packages via `docs/development/` in `.modkitignore`.

Date: 2026-08-13

## Sources reviewed

- Current beta.29.0.1 RC changelog/source/docs.
- Local preserved beta.28.11, beta.28.14, beta.28.16, beta.28.20 and beta.29.0.0 test archives.
- Local `DEV_HISTORY.md`, `BUG_REPORTS.md`, release notes, test notes, and earlier packaging/reviewer artifacts.
- Current retained project-conversation history available in this workspace.
- Read-only project repository history, including the beta.27.16 branch changelog and older beta.15/beta.22/beta.25-era source/README/changelog commits.

## High-confidence changelog improvements

### Missing known revision: beta.12

The current cumulative changelog omits beta.12 even though a preserved beta.25-era reconstructed changelog records it explicitly.

Recovered beta.12 history:
- First surviving future-safe persistent save-schema baseline (schema 1).
- Marker-only/idempotent migration boundary for older saves without rewriting gameplay state.
- Existing beta.8-era Gym Guide direct-row composition and 1/10/25/50/99 selector preserved.
- Existing Setup/provenance/recovery/level-cap/provider/world-building/Tracker/Catch Info/Trainer Card systems carried forward.

Action: add a dedicated beta.12 heading. Never drop it again.

### beta.27.15 / beta.27.16 are under-documented in the consolidated changelog

The beta branch's preserved CHANGELOG has exact details that should be retained, including:
- beta.27.15 Gold trainer-shape boss progression; existing-save progression seeding; Johto Chuck/Pryce/Jasmine order correction; monotonic caps; unknown Gen1 fallback; fractional cap-scope normalization; dynamic trainer-party observation invalidation; API-report v22 match; default relationships; Gold World Building queue support; title-menu save detection hardening; provider alias/result normalization; dependency-free Node release gate and Lua smoke harness.
- beta.27.16 exact Gold Game Corner HANDLERS/ALL independent restoration; Gold Nickname Rule exposure/installation; no decline/blank nickname; blocking givepoke rename continuation; explicit static/fixed provenance for Ball gate; STANDARD vs ALL presentation; verified false positives; 66 structural checks and 49 smoke checks.

Action: expand both entries rather than leaving only condensed summaries.

### beta.28.11 is under-documented

Preserved beta.28.11 test package additionally establishes:
- Player acquisition coverage for catches, scripted gifts/starters, trades, compatible receive events, and Gold givepoke paths.
- Generation-neutral Gold battle-start fallback for wild/trainer Stat EXP/DV application.
- 0% is vanilla zero Stat EXP per stat.
- Presets clamp to 65,535 per stat.
- No Stat EXP Gain blocks normal battle Stat EXP before mutation while normal EXP remains intact.
- Stat EXP vitamins are vetoed before consumption.

Action: add these behaviors to beta.28.11.

### beta.28.14 is under-documented

Preserved beta.28.14 package establishes:
- Blue SETUP disappearance and Gold Mod Manager syntax failure were manifestations of the same compile failure.
- Speculative Gold `save.options` / ManagerState workaround was removed.
- Robust R/B/Y and Gold NEW GAME/CONTINUE recognition was preserved.
- Full-health starters/gifts remain full when Stat EXP/DVs raise max HP; damaged catches preserve actual battle HP.

Action: add these details to beta.28.14.

### beta.28.17–28.19 aggregate can be improved without inventing per-build allocation

Preserved beta.29.0.0 history states known post-.16 work represented in later source includes:
- party-menu composition hardening;
- checkpoint/savestate reconciliation of runtime-only observations;
- additional wrapper/restoration protections.

Action: retain individual 28.17/18/19 headings, but add the aggregate known-work note to each or to an adjacent explicit range note while continuing to mark exact per-build attribution unresolved.

### beta.25 internal development iterations are recoverable

The beta.25 README/changelog commit records D2/D3/D4 diagnostic/runtime iterations:
- D2 still failed at the Gym Guide quantity-screen handoff.
- D3 changed only that lifecycle to the current blocking `push_screen` flow and runtime-passed the 1/10/25/50/99 selector.
- D4 focused on No Repels and No X Items and runtime-passed both.
- beta.25 also documented six R/B/Y correctness fixes: pokemon.received classification order; forward-declared encounter-state access for gifts/trades; Whiteout wrapped-finish preservation; narrow Route 24 Charmander migration repair; Recover Catches reading flat rule keys; post-catch fallback respecting Overworld/Town catch counting.

Action: represent D2, D3, D4/25D4 and 25D4-RBY2 as known internal development history where exact labels are supported. Do not collapse these into a single beta.25 paragraph.

### 26B10 should be individually represented

Current source repeatedly states beta.26 was promoted directly from runtime-tested `26B10`, but the public cumulative changelog has no standalone 26B10 heading.

Action: add a 26B10 internal-development heading using only the runtime-driven facts that can be recovered from the project record; preserve uncertainty for exact change allocation.

## Historical conflicts that must be documented, not silently resolved

### beta.15 conflict

Direct GitHub source at commit `53347683...` identifies itself as:
- `Nuzlocke Rules 2.0.0-beta.15 - Menu crash fix`
- save schema 2
- Nuzlocke compatibility API v6

A later beta.25-era reconstructed changelog instead says beta.15 was:
- Gen1Recomp 0.1.77 compatibility pass
- save schema advanced to 3
- Wonderlocke remained dormant

These cannot both describe one unique immutable beta.15 artifact as currently written.

Action: revise beta.15 to state that two surviving records labeled beta.15 conflict. Prefer the direct source for concrete code-state facts (header/schema/API) and retain the later reconstructed claim as an unresolved historical attribution/version-reuse note until an original beta.15 package proves the sequence. Do not continue asserting schema 3 at beta.15 as certain.

### beta.22 conflict

Direct GitHub beta.22 source at commit `33387ea...` identifies itself as:
- `beta.22 - static integrity + version/persistence hardening`
- save schema 4
- compatibility API v7
- no literal Gold/Gen2 references found in that source resource

A later beta.25-era reconstructed changelog says beta.22 added:
- Gold generation-native capture/permadeath/nickname/mart/starter-gift/area adapters
- Gen1 + Gold manifest targeting

Action: mark beta.22 as conflicting historical artifacts / possible version reuse or uncommitted later beta.22 revision. Do not silently discard either record. The direct GitHub source is strongest evidence for the committed beta.22 artifact; the later reconstructed record should remain explicitly labeled reconstructed/unresolved.

## Other useful preserved history

- beta.21 reconstructed record: GSC family/version-profile architecture, built-in GSC progression through Red, provider Expanded Postgame, and two-row R/B/Y Trainer Card.
- beta.23: experimental Gold Trainer Card status; Gen2 Egg/Day Care and roaming provenance; Gym Guide generation gate; schema 4.
- beta.24: Gold automatic Setup through shared intro hook attempted and runtime-failed/left vanilla; R/B/Y title Setup unchanged; schema 4.
- beta.20: direct reconstructed beta.25-era changelog agrees it was a compatibility/regression pass directly from beta.19 preserving schema 4 and strengthening item/purchase/capture policy, providers, level caps, identity/recovery, Trainer Card/Catch Info, and Gym Guide.
- beta.14: schema 2 at the preserved reconstructed snapshot, future-safe migration framework, tracker/recovery hardening, Wonderlocke inactive.
- beta.11: human-readable catch-location recovery + native Rare Candy selector cursor presentation.
- beta.10: native cursor/scroll presentation + Trainer Card refinements; Gym Guide direct-row selector retained.
- by beta.8: experimental Wonderlocke/provider infrastructure and critical Gym Guide direct-row composition fix.
- beta.5: legacy catch-location reconciliation/recovery.
- beta.4: World Building tiers + level-cap-aware Gym Guide feedback.
- by beta.3: provenance-aware catch recovery/compatibility and dedicated 1/10/25/50/99 Gym Guide selector.
- beta.1 surviving snapshot: battle-item/current-rule-profile and Whiteout-related work; later Gym Guide feature not yet present.

## Project-conversation evidence to preserve in future changelog enrichment

Retained project conversation history also supports runtime-evidence notes including:
- Save Editor modified Yellow save: No TMs and No Rare Candy worked after fully quitting/relaunching Gen1Recomp, establishing the loader-session/restart caveat.
- Gold NEW GAME Setup and collapsible sections runtime PASS.
- Yellow existing-save rule-selection/collapsible behavior runtime PASS.
- Player/rival name-skip runtime PASS in the later development line.

These should be associated only with the version actually under test when the surrounding conversation establishes it; otherwise retain them in evidence/BUILD_HISTORY rather than inventing exact changelog attribution.

## Conversation-history access limitation

The current workspace exposes retained summaries and available project-conversation excerpts, not every historical conversation thread. An older internal `DEV_HISTORY.md` also records that one supplied shared conversation log was reviewed while another exceeded a prior retrieval limit. Any future exported transcript or recovered package should be reconciled into this audit and the cumulative changelog without rewriting newer lineage.
