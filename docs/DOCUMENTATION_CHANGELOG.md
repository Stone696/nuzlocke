## 2.5.23-DEV
- Documented exact Yellow 2.5.22 runtime failures and the source-confirmed lexical-scope/staged-phase causes.
- Documented repaired Random Starter helper ownership, R/B/Y Commands installer scope, late-runtime phase-2 execution, fresh `save.created` lifecycle coverage, and conservative opening-starter Pallet provenance repair.
- Documented new DEV SELF TEST rows and process-level invariant/mutation ratchets for scope/phase/lifecycle regressions.
- Confirmed Save Schema 4 / Compatibility API 28 / Diagnostics API 1 / Mod API 2 / engine range unchanged.

## 2.5.22-DEV
- Documented Gen 1 kerning owner/session/previous/wrapper lifecycle hardening and the fresh-process boundary for ambiguous legacy wrapper chains.
- Documented starter RNG migration to the shared algorithm-version-aware seeded helper with v1 result preservation.
- Documented dynamic current RNG-version labels and regression-gate coverage.
- Confirmed Save Schema 4 / Compatibility API 28 / Diagnostics API 1 / Mod API 2 / engine range unchanged.

## 2.5.21-DEV
- Documented shared trainer ID/class/name normalization across reward and League progression paths.
- Added regression-gate coverage for R/B/Y, Gold, and provider class aliases.
- Confirmed Save Schema 4 / Compatibility API 28 / Diagnostics API 1 / Mod API 2 / engine range unchanged.

## 2.5.20-DEV
- Documented the split between save-write safety, passive progression synchronization, and active challenge enforcement.
- Documented that supported-save Gym/E4/Champion progress continues while Nuzlocke is OFF, while Failed Encounter/Forgiveness/economy/death consequences do not.
- Documented policy-aware local invariant checks and unchanged Save/API/engine contracts.

## 2.5.19-DEV
- Documented newer-schema starter/identity safe-stop hardening, defensive/fresh engine compatibility reporting, migration-bookkeeping descriptor coverage, and save-write wrapper lifecycle protection.


## 2.5.18-DEV
- Documented Compatibility API defensive snapshots, canonical effective-rule fallback, Rule Registry collision reporting, and expanded Save Schema 4 descriptor roles.
- Corrected stale current API examples to Compatibility API 28 / audited Gen1Recomp 0.2.7.
## 2.5.17-DEV
- Documented machine-readable build provenance and strict parent SHA binding.
- Documented the derived Rule Registry and Save Schema 4 configuration descriptor.
- Documented Compatibility API 28 per-capability contract-version negotiation; existing API-27 capability semantics remain compatible.
- Documented Diagnostics API 1 SELF TEST coverage for provenance/descriptor/contract integrity.
- Documented that repository CI/invariant tooling is development-only and excluded from the 15-file player package.
- Confirmed Save Schema 4 / Diagnostics API 1 / Mod API 2 / engine range unchanged; Compatibility API intentionally advances 27 -> 28 for the new public capability-version negotiation surface.

## 2.5.16-DEV
- Documented canonical `ruleActive()` missing-key semantics and `locke_type` fallback cleanup.
- Documented lifecycle identity hardening for automatic names, R/B/Y Permadeath, Gold nickname/Mart/gambling, QoL AUTO-REPEL, and Wilds paired capture wrappers.
- Expanded the documented Dev hook-health surface.
- Confirmed Save Schema 4 / Compatibility API 27 / Diagnostics API 1 / Mod API 2 remain unchanged.

## 2.5.15-DEV

- Documented field-poison Whiteout enforcement for R/B/Y and Gold, independent of Permadeath.
- Documented the Gold No Escape live-game resolution fix and explicit new-game `locke_type` snapshot write.
- Documented owner-aware lifecycle coverage for Party Size/PC withdrawal, Gold No Day Care, Gold Whiteout finish, Gold Headbutt tracking, and forgiveness-token mart stock.
- Updated current build/runtime priorities while keeping Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and engine range unchanged.

## 2.5.14-DEV

- Documented the R/B/Y starter/gift save-order repair and the canonical-default enforcement sweep.
- Documented owner-aware lifecycle sessions for the older R/B/Y catch/Permadeath and Gold capture direct wrappers.
- Clarified that the Gen1Recomp 0.2.7 TimeFishGroups review resulted in no code change because row-local day/night slots are intentionally authoritative over the fallback table.
- Updated current build references and runtime-test priorities; Save Schema/API/engine range remain unchanged.

## 2.5.13-DEV
- Documented the R/B/Y + Gold overworld-poison Permadeath gap and its generation-specific native seams.
- Clarified that 2.5.13 records/prunes field-poison deaths without replacing poison presentation or native whiteout/heal/warp sequencing.
- Recorded owner-aware reload handling for the two new direct wrappers.
- Kept Whiteout Clause semantics, Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and engine range unchanged.
- Marked the repair R/B/Y + Gold runtime TEST REQUIRED.

## 2.5.12-DEV
- Documented the completed published Gen1Recomp 0.2.7 source audit, including Gold TimeFishGroups/day-night fishing.
- Documented the Gold public final-encounter-registry facade repair (`gen2Encounters` with Gen 1 fallback).
- Clarified that gameplay randomization/reveal/selection semantics, Compatibility API 27, Save Schema 4, Mod API 2, and engine range are unchanged.
- Corrected the older runtime checklist's section-order expectation to GAME DIFFICULTY -> BATTLE MECHANICS -> AREA SPLITS.
- Kept the compatibility repair Gold runtime TEST REQUIRED.

## 2.5.11-DEV
- Documented completion of the World Building T3 -> T1 default migration in the live flavor/configuration fallback paths.
- Replaced stale `RECOMMENDED: TIER 3` rule copy with `DEFAULT: TIER 1`.
- Clarified that explicit saved OFF/T1/T2/T3 selections are preserved and no API/schema/engine/provider semantics changed.
- Kept the repair runtime TEST REQUIRED.

## 2.5.10-DEV
- Documented the Gold Pokégear NUZ RULES partial-page reachability fix and new `RULES x/y` / `A:MORE` affordance.
- Documented `NO ENTRIES YET` for empty native and Modern UI ENC TRACKER views.
- Clarified that the Modern UI placeholder does not change the real encounter count or selected encounter semantics.
- Recorded no API/schema/engine/provider behavior change and kept both UI repairs runtime TEST REQUIRED.

## 2.5.9-DEV
- Promoted Yellow 2.5.8 fresh Shiny Clause OFF/0 and Type Locke menu editing to runtime PASS.
- Recorded the separate Yellow 2.5.8 setup-save failure caused by an out-of-scope `TYPE_LOCK_SLOT_INDEX` reference.
- Documented the 2.5.9 stable Type Locke setup/profile accessor repair and related Gold status-key repair.
- Documented scrollable full loadout-change review and manual A/B paging for Nuzlocke-owned error dialogs.
- Documented GAME DIFFICULTY -> BATTLE MECHANICS immediately above AREA SPLITS.
- Source-audited Gold First Rival Mercy against Gen1Recomp 0.2.7 `BATTLETYPE_CANLOSE` behavior and recorded NO CODE CHANGE.

## 2.5.8-DEV
- Recorded Yellow 2.5.7 loadout-warning overflow and Type Locke edit error as runtime failures.
- Documented the bounded R/B/Y loadout preview and lifecycle-stable Type Locke slot/default repair.
- Changed documented fresh Shiny Clause default to OFF/0 without rewriting existing saved selections.
- Documented Route Forgiveness relocation from CLAUSES to GENERAL with unchanged mechanics.
- Kept both 2.5.8 repairs as runtime TEST REQUIRED.

## 2.5.7-DEV
- Promoted the 2.5.6 saved-report VIEW REPORT crash repair to Blue runtime PASS for the tested full-restart path.
- Recorded Dev Report, NZR4 Report Code, and Storage Info clipping/overflow as separate Blue 2.5.6 runtime UI failures.
- Documented the 16-character-safe R/B/Y Dev diagnostic width, long-token hard wrapping, and grouped Report Code presentation.
- Kept the shared 2.5.6 NUZ RULES edit repair as runtime TEST REQUIRED.
- Kept the loadout-change warning popup as a separate known Blue setup UI defect; 2.5.7 does not change it.

## 2.5.6-DEV
- Recorded the Blue 2.5.5 shared NUZ RULES update crash across multiple toggles.
- Recorded DEV TOOLS -> VIEW REPORT as a separate confirmed runtime crash.
- Documented the narrow Type Locke-mirror fallback and Dev report helper-scope repairs.
- Documented the MOD COMPAT left-column unbolding request.
- Preserved the 2.5.5 opening-sequence items as TEST REQUIRED rather than promoting them to PASS.

## 2.5.5-DEV
- Recorded Blue 2.5.4 opening-sequence runtime PASS/FAIL evidence.
- Documented starter-context, provenance, nickname and First Rival Mercy repair attempt.
- Added explicit fresh-game retest plan.

## 2.5.4-DEV
- Documented T1 World Building default.
- Removed Cap Messages as a configurable setting.
- Consolidated Solo Only into Party Size Limit.

## 2.5.3-DEV
- Updated rule naming/placement for No Catching and Ball Per Enc.
- Documented conditional Ball Per Enc. visibility.
- Documented GAME DIFFICULTY / BATTLE MECHANICS placement above GENERAL.

## 2.5.2-DEV
- Documented Gen1Recomp 0.2.2–0.2.7 compatibility review.
- Documented diagnostic-only Randomizer Info Policy storage validation.
- Confirmed no engine-range change is required.

## 2.5.1-DEV
- Reclassified the unreleased 2.5.0 candidate into another DEV validation step.
- No gameplay code or save-format changes.
- Added explicit pre-publication runtime test focus.

## 2.5.0
- Rebuilt README as a current release overview instead of a 2.4.79-focused compatibility note.
- Updated USER_GUIDE, API, COMPATIBILITY, FEATURE_CONFIDENCE, RELEASE_NOTES, CHANGELOG, and mod.card for publication.
- Documented NZR4 full-semver Report Codes and the non-circular report-body fingerprint contract.
- Synchronized current version/API/save/engine statements.
- Preserved historical changelog material; no documentation files added or removed.

## 2.4.100-DEV
- Documented Randomizer Info Policy UI readback repair and full numeric-selector plumbing audit.

## 2.4.99-DEV
- Documented completion of Encounter Ball Limit default/read/write plumbing and NZR3 diagnostic coverage.

## 2.4.98-DEV
- Documented Shiny Clause / Encounter Ball Limit setter bug, save repair, and diagnostics.

## 2.4.97-DEV
- Documented compact/joined legacy mod-ID compatibility repair.

## 2.4.96-DEV
- Recorded and repaired randomized-starter Pallet Town Tracker/map provenance.

## 2.4.95-DEV
- Recorded field-item rejection pacing failures and new blocking A-driven paginator.

## 2.4.94-DEV
- Recorded Yellow No Mom Heal regression and stale field-command session repair.
- Report Code format updated to NZR2.

## 2.4.93-DEV
- Added Dev Report Code format, live-report workflow, decoder contract, and fingerprint limitations.

## 2.4.92-DEV
- Recorded and repaired Storage Info overflow.
- Documented wrapped-row Dev Report scroll-bound correction.

## 2.4.91-DEV
- Recorded Yellow/AYN Thor Dev Report overflow and the wrapped-row presentation repair.

## 2.4.90-DEV
- Recorded Yellow catch-tutorial skip repair.

## 2.4.89-DEV
- Documented Cap Messages selector repair and new once-per-battle default.

## 2.4.88-DEV
- Corrected menu organization: Party Size Limit and Gym Team Size now live at the bottom of IRONMON.

## 2.4.87-DEV
- Recorded Yellow header-control runtime PASS evidence.
- Documented Party Size Limit and Gym Team Size relocation to GENERAL.

## 2.4.86-DEV
- Updated player-facing naming from `Nickname Rule` to `Nickname`.

## 2.4.85-DEV
- Added Encounter Ball Limit behavior, controls, and interaction documentation.

## 2.4.84-DEV
- Documented old-save boolean-to-numeric selector canonicalization.

## 2.4.83-DEV
- Recorded Yellow-specific starter nickname compatibility repair.

## 2.4.82-DEV
- Added Brazilian Portuguese translation-mod compatibility audit and runtime test requirements.

## 2.4.81-DEV
- Recorded current Gen1Recomp/launcher audit and BattleAPI compatibility surface.

## 2.4.80-DEV
- Documented localization compliance/glyph-safety pass.

## 2.4.79 — Gen1 Better Menus compatibility audit — 2026-08-18
- Documented the 1.0.3 shared-UI source audit and runtime-test matrix.
- Added optional-dependency/load-order and descriptive compose metadata without claiming runtime PASS.
- Preserved Save Schema 4, Compatibility API 27, Diagnostics API 1, and engine maximum `<2.0.0`.

## 2.4.78 — Type Locke expansion + Catch Draft — 2026-08-18
- Updated documentation for Mono through Hexalocke and Catch Draft.
- Documented dual-type draft preference, live mode changes, and runtime-test status.
- Preserved the 2.4.77 compatibility-audit history.

## 2.4.77 — compatibility audit consolidation — 2026-08-18
- Consolidated the completed second FAFF0x Gen1Recomp compatibility audit wave.
- Moved completed targets out of the active queue without promoting any source/static result to runtime PASS.
- Preserved explicit runtime matrices for alternate PC/item/move paths, custom/static encounters, gifts/rewards, quest battles, diagnostics, and presentation packages.
- Kept unresolved historical names explicit and retained the Modern UI + Encounter Tracker crash as unresolved pending fresh runtime testing.

# Documentation Changelog
## 2.4.76 — compatibility ledger and target queue — 2026-08-18

- Added the post-2.4.75 external-mod audit results without promoting any source/static result to runtime PASS.
- Added a prioritized current FAFF0x/gen1recomp target queue using repository package versions where README labels are stale.
- Highlighted Modern UI Fix 1.0.0 as the next highest-value target because of the unresolved historical Modern UI + Encounter Tracker crash report.
- Added explicit ownership policy for DV/EV Editor-style user edits: Nuzlocke does not silently become an anti-cheat loop unless a rule explicitly owns permanent state.
- Preserved project engine-range policy and all API/schema numbers.


## 2.4.75 — Kanto Reforged 1.2.0 interoperability — 2026-08-17
- Added KR 1.2.0 source-audit record.
- Documented read-only cap co-ownership and stricter-cap composition.
- Documented expanded-species, trainer-party, and held-item generic composition.


## 2.4.74 — Indigo Plateau Conference 1.1.0 audit — 2026-08-17
- Updated IPC compatibility marker from 1.0.2 to 1.1.0.
- Documented IPC CANLOSE/elimination/living-survivor healing ownership.
- Documented Nuzlocke's existing priority -1000 dead-Pokemon prune as the post-battle composition seam.
- Recorded that no new IPC-specific listener or gameplay behavior was introduced.


## 2.4.73 — Quick Start runtime documentation — 2026-08-17
- Recorded R/B/Y Quick Nuzlocke Start / intro bypass as user runtime PASS.
- Documented the recoverable outside-house / bedroom-PC pickup caveat.
- Updated the player-facing Quick Start description and confidence ledger without changing progression logic.


## 2.4.72 — Engine range policy correction — 2026-08-17
- Restored the manifest/documented engine range to `>=0.1.86 <2.0.0`.
- Recorded `<2.0.0` as a protected project policy that must not be changed unless explicitly directed by the project owner.
- Retained the 0.2.0 Gen1Recomp audit marker.


## 2.4.71 — Gen1Recomp 0.2.0 compatibility audit — 2026-08-17
- Updated current package/version references to 2.4.71 DEV.
- Corrected the audited Gen1Recomp marker from 0.2.1 to released 0.2.0.
- Narrowed the verified manifest range to `>=0.1.86 <0.3.0`.
- Documented the reviewed storage, hook/event, menu, Gold, manifest, and reload compatibility surfaces.


## 2.4.70 — Post-release safety / diagnostic hardening — 2026-08-17
- Updated current package/version references to 2.4.70 DEV and recorded 2.4.69 as the published parent.
- Documented that future-schema escaped save writes are now counted and blocked rather than observed-and-delegated.
- Documented direct Random Learnset, Quick Start, Skip Intro, and automatic-name safe-stop behavior.
- Documented Deferred Starting Balls and Skip Catch Tutorial safe-stop coverage found in the final sweep.
- Added Randomizer-integrity `FALLBACK` semantics for the intentional empty legal pool.
- Corrected lifecycle-counter wording so pre-reload persistence is not overstated.


## 2.4.69 — Published release — 2026-08-17
- Recorded the reviewed 2.4.69 package as the published full release.
- Consolidated release notes around the frozen RC feature surface and regression-test priorities.
- Confirmed no Save Schema, Compatibility API, Diagnostics API, or package-inventory change.


## 2.4.68 — Dev Randomizer integrity audit — 2026-08-17
- Updated current package/version references to 2.4.68.
- Documented live encounter-table scanning, canonical legality checks, delegation/content opt-outs, violation reporting, and public diagnostics API.
- Recorded that the audit is read-only and does not alter encounter tables.


## 2.4.67 — Dev rule-effectiveness audit — 2026-08-17
- Updated current package/version references to 2.4.67.
- Documented configured/effective/owner diagnostics, save-vs-default sourcing, delegation relationships, aggregate counts, and public diagnostics API.
- Clarified that master-switch/schema state is reported separately from per-rule effective values.


## 2.4.66 — Future-schema write diagnostics — 2026-08-17
- Updated current package/version references to 2.4.66.
- Documented transparent `mod.save:set(...)` observation during newer-schema safe-stop, per-key attempt reporting, breadcrumb behavior, self-test export, and reset/query APIs.
- Clarified that the detector observes/delegates and does not replace 2.4.63's safe-stop guards.


## 2.4.65 — Dev lifecycle counters — 2026-08-17
- Updated current package/version references to 2.4.65.
- Documented six lifecycle counters, duplicate-payload detection, lifecycle breadcrumbs, exported `[LIFECYCLE]` data, and reset/query diagnostics APIs.
- Recorded that event registration itself is unchanged.


## 2.4.64 — Dev hook / adapter health — 2026-08-17
- Updated current package/version references to 2.4.64.
- Documented the read-only hook-health states, 13-adapter scope, self-test/export integration, and public diagnostics query.
- Documented that CHAINED is compatibility evidence rather than automatic breakage.


## 2.4.63 — Future-schema downgrade safety — 2026-08-17
- Updated current package/version references to 2.4.63.
- Documented the enforced newer-schema safe stop, guarded lifecycle writers, session-only player warning, and `saveSchemaSupported()` query.
- Preserved Save Schema 4 and Compatibility API 27.

## 2.4.62 — Random Encounter rule-legality filtering — 2026-08-17
- Updated current package/version references to 2.4.62.
- Documented Random Encounter composition with Type Locke, species bans, and Maximum BST.
- Recorded the inherited runtime build-metadata synchronization from the 2.4.61 package.
- Preserved the future-schema downgrade-safety finding as queued work rather than mixing it into this build.

## 2.4.60 — Runtime crash diagnostic capture — 2026-08-17
- Documented full traceback capture for recoverable Config/Setup and NUZ STATUS screen runtime failures.
- Confirmed no gameplay/save/API changes and preserved existing 2.4.59/2.4.58 diagnostic behavior.

## 2.4.59 — Passive Dev diagnostic hardening — 2026-08-17
- Documented `Dev.pguard()` and its intentionally limited internal instrumentation.
- Documented new encounter-ledger and structural Shiny assertions.
- Explicitly retained 2.4.58 export/history behavior and the no-recursive-mechanics guardrail.
- Corrected stale `mod.card` engine-range metadata.

## 2.4.58 — Provenance + diagnostic history — 2026-08-17
- Documented pin-once encounter provenance.
- Documented full 48-breadcrumb export and bounded 16-report history.
- Documented READ vs READBACK semantics.

## 2.4.57 — Launcher range / capture-ledger docs — 2026-08-17
- Updated current engine range to `>=0.1.86 <2.0.0`.
- Documented capture-state monotonic reconciliation and new save/reload regression queue.
- Historical version entries remain unchanged.

## 2.4.56 — Documentation integrity reconciliation — 2026-08-17
- Reconciled all eight shipped docs against exact current code/manifest.
- Repaired 2.4.35–2.4.55 historical attribution.
- Updated Project Rules/Handoff and added per-document update rules.
- Corrected current engine to 0.2.1 and current package/API/schema state.

## 2.4.55 — Fast section navigation — 2026-08-17
- Documented SELECT+UP/DOWN section jumps and SELECT+LEFT/RIGHT collapse/expand all.

## 2.4.54 — Rule-list wraparound — 2026-08-17
- Documented first/last selectable-row wraparound.

## 2.4.53 — Historical Difficulty scope correction — 2026-08-17
- Restored intended profile list in current docs; retained deeper mechanics.

## 2.4.52 — Deeper historical Difficulty mechanics — 2026-08-17
- Documented boss/team/move/AI/DV/held-item tuning; temporary extra names later removed.

## 2.4.51 — Gold No Held Items — 2026-08-17
- Documented Gold-only rule and runtime-test requirements.

## 2.4.50 — Gen1Recomp 0.2.1 consolidation — 2026-08-17
- Documented no extra runtime migration beyond 0.2.0.

## 2.4.49 — Gen1Recomp 0.2.x storage migration — 2026-08-17
- Documented official `mod.storage` diagnostics migration.

## 2.4.48 — Native DEV cursor / wrapped info — 2026-08-17
## 2.4.47 — Verified diagnostic export / FILE INFO — 2026-08-17
## 2.4.46 — Deterministic self-test file — 2026-08-17
## 2.4.45 — DEV TOOLS layout repair — 2026-08-17
## 2.4.44 — Clipboard-first diagnostics — 2026-08-17
## 2.4.43 — DEV TOOLS / self-test — 2026-08-17
## 2.4.42 — Self-test + presentation-control unlock — 2026-08-17
## 2.4.41 — Rules row collision fix — 2026-08-17
## 2.4.40 — Lua loadability hotfix — 2026-08-17
## 2.4.39 — Tracker death projection — 2026-08-17
## 2.4.38 — Encounter indicator / cap messages — 2026-08-17
## 2.4.37 — Forgiveness modal UI — 2026-08-17
## 2.4.36 — Shiny / encounter-slot integrity — 2026-08-17
## 2.4.35 — Developer diagnostics mode — 2026-08-17

# 2.4.34 Provider Capability Architecture + Gen9Dex Hardening — 2026-08-17

- Promoted 2.4.34 as the current development head, direct child of 2.4.33.
- Documented Gen9Dex 1.2.0 as a Gold-only modern-mechanics provider and distinguished native DVs from modern IV/EV/Nature battle stats.
- Documented the internal-only capability resolver and retained Compatibility API 27.
- Updated Evolution Limits documentation to use the executable merged evolution graph.

# 2.4.33 Save Editor / external save-state hardening — 2026-08-17

- Promoted 2.4.33 as the current development head, direct child of 2.4.32.
- Added the built-in Gen1Recomp Save Editor audit to the maintained compatibility ledger.
- Documented non-destructive over-cap reconciliation, persistent death authority, external/unverified provenance presentation, and immutable registration-species history.
- Added edited-save runtime validation cases.
- Save Schema remains 4; Compatibility API remains 27.

# 2.4.32 Quality of Life 1.3.0 compatibility hardening — 2026-08-17

- Promoted 2.4.32 as the current development head, direct child of 2.4.31.
- Added the Quality of Life 1.3.0 source/hook audit and compatibility-ledger entry.
- Documented the conservative Gen 1 Easy Interactions shortcut suppression used during active Travel Restrictions / Dungeon Lock-In.
- Documented that existing No Repels enforcement already covers the mod's Repel paths.
- No Save Schema or Compatibility API change.

# 2.4.31 compatibility ledger stale-target refresh — 2026-08-17

## 2.4.31 DEV

- Added QoL Toggles 1.24.1 full hook/ownership audit and adapter status.
- Documented restriction-over-convenience precedence and option-aware Automatic Running ownership.
- Recorded targeted runtime test requirements for overlapping QoL transactions.


- Promoted 2.4.31 as the current development head, direct child of 2.4.29.
- Re-audited Too Many Balls 0.6.1 and Shiny Pokémon 1.0.8 against the current Nuzlocke compatibility model.
- Updated the maintained compatibility ledger with current versions, treatment, limitations, and re-audit triggers.
- Marked Kanto Life and NPC Bubbles as UPSTREAM UNRESOLVED after their canonical current repositories could not be reliably identified from retained evidence.
- Corrected stale current-head parent wording carried in 2.4.29 README/main metadata.
- No gameplay rule, Save Schema 4, Compatibility API 27, engine range, or package file tree changed.

# 2.4.29 maintained rule-parity matrix — 2026-08-17

- Promoted 2.4.29 as the current development head, direct child of 2.4.28.
- Added a permanent rule × game-family parity matrix to `docs/COMPATIBILITY.md`.
- Matrix records R/B/Y support, Gold support, enforcement/adaptation mechanism, runtime confidence, and known generation/upstream limitations.
- Added a release gate requiring every future rule addition/removal/rename/exposure/enforcement change to update the matrix in the same build.
- Clarified that `✅` means an implementation exists, not that every runtime combination is certified.
- No gameplay rule, save schema, Compatibility API contract, engine range, or package file tree changed.

# 2.4.28 cross-version rule parity audit — 2026-08-17

- Promoted 2.4.28 as the current development head, direct child of 2.4.27.
- Audited every rule against R/B/Y vs Gold/Gen2 data/execution differences.
- Documented newly exposed shared Gold rules and the intentionally generation-specific controls that remain hidden.
- Documented the Gen2 `levelMoves` Random Learnsets repair and complete native Gen2 Legendary/Mythical fallbacks.
- Updated Gold parity metadata to 2.4.28.
- Save schema remains 4; Compatibility API remains 27.

# 2.4.27 Gold compact rule labels — 2026-08-17

- Promoted 2.4.27 as the current development head, direct child of 2.4.26.
- Ported the R/B/Y localization-safe `shortName` / `shortTitle` fallback policy to Gold Setup and NUZ RULES.
- Documented that Gold keeps a translated full label when the corresponding shorthand is not translated.
- No rule semantics, save schema, Compatibility API, permissions, or package files changed.

# 2.4.26 chronological changelog normalization — 2026-08-17

- Promoted 2.4.26 as the current development head, direct child of 2.4.25.
- Reordered the cumulative changelog into one newest-to-oldest chronology.
- Reconciled duplicate version headings without discarding unique historical notes.
- Restored the lost 2.1.19 RC heading from surviving contemporaneous documentation.
- Restored a minimal beta.30.1.19 lineage heading from surviving package evidence while leaving its exact delta explicitly unrecovered.
- Strengthened the append-only history release gate to validate chronology and duplicate version identities in addition to parent-heading preservation.
- No gameplay behavior, save schema, Compatibility API, engine range, or package tree changed.

# 2.4.25 full-history changelog repair — 2026-08-17

- Promoted 2.4.25 as the current development head, direct child of 2.4.24.
- Reconciled `CHANGELOG.md` against surviving earlier changelog/handoff records and added an explicit historical coverage index for the pre-2.3.1 RC development line.
- Added the permanent append-only changelog rule: future children may prepend/correct history but may not silently truncate or wholesale replace the immediate parent's historical record.
- Added a release-gate comparison requirement for historical version headings; approved duplicate cleanup must preserve all unique information.
- Corrected the stale API build-contract label discovered during the audit.
- No gameplay behavior, save schema, Compatibility API, package tree, or engine range changed.

---

# 2.4.24 compatibility-ledger reconciliation — 2026-08-17

- Promoted 2.4.24 as the current development head, direct child of 2.4.23.
- Added the maintained compatibility research ledger and evidence vocabulary to `COMPATIBILITY.md`.
- Added the standing rule that every compatibility/learning pass updates that ledger in the same build and that SOURCE/STATIC, RUNTIME PASS, ARCHITECTURE/LEARNING, and DESIGN INSPIRATION are distinct evidence states.
- Recorded All Pokémon Catchable 151, Gen1Recomp Content Editor, Trainer Talk 0.2.6, Spaceworld Sprites 1.0, and Gen2-3D-Sprites 0.2.81 alongside the previously audited/researched mod set.
- Added the targeted Gen2-3D-Sprites Gold direct-capture/UI test matrix without adding a speculative private adapter.
- Corrected stale 2.4.23 lineage wording: 2.4.23 is a child of 2.4.22.

---

# 2.4.23 documentation reconciliation — 2026-08-17

- Promoted 2.4.23 as the current development head, direct child of 2.4.22.
- Documented generic content-mod composition learned from All Pokémon Catchable 151 and Gen1Recomp Content Editor.
- Documented encounter-registry area discovery, richer species metadata classification, and merged custom-Ball detection.
- Preserved provider-driven boss/cap ownership and all historical 2.4.22 documentation below.

---

# 2.4.22 documentation reconciliation — 2026-08-17

- Promoted 2.4.22 as the current development head, direct child of 2.4.21.
- Documented Party Size Limit `1–6`, default 6, native/cooperative PC behavior, and non-destructive lowering semantics.
- Documented independence from Solo Only, Gym Team Size, and Nuzlocke Loadouts.
- Removed generalized Party Size Limit from the planned backlog because it is now implemented.
- Runtime status remains TEST REQUIRED in R/B/Y and Gold.

# 2.4.21 documentation reconciliation — 2026-08-17

- Promoted 2.4.21 as the current development head, direct child of 2.4.20.
- Documented Travel Restrictions `NORMAL / NO FLY / NO FLY+TELEPORT` and its player-field-move-only scope.
- Documented that Dig, Escape Rope, scripted/story transportation, warps, trains, and ferries are intentionally untouched.
- Kept Dungeon Lock-In independent and Loadouts non-owning.
- Removed Travel Restrictions / No Fly from the planned backlog because it is now implemented.
- Runtime status remains TEST REQUIRED in R/B/Y and Gold.

# 2.4.20 documentation reconciliation — 2026-08-17

- Promoted 2.4.20 as the current development head, direct child of 2.4.19.
- Documented Limited Shiny Clause `OFF / 1 / 2 / 3 / UNLIMITED`, persistent successful-use counting, historical boolean migration, and non-resetting mid-run limit changes.
- Removed Limited Shiny Clause from the planned backlog because it is now implemented.
- Kept Shiny Clause independent of loadout preset ownership and absolute capture restrictions.
- No unrelated backlog item was promoted. Save schema and package file set remain unchanged.

# 2.4.19 documentation reconciliation — 2026-08-17

- Promoted 2.4.19 as the current development head, direct child of 2.4.18.
- Documented Evolution Limits NORMAL / NO FINAL / NO EVOLUTION and conservative live-registry terminal-stage semantics.
- Removed Evolution Limits from the planned backlog because it is now implemented.
- Documented `evolution.check` enforcement and loadout independence.
- No unrelated backlog item was promoted. Save schema and package file set remain unchanged.

# 2.4.18 documentation reconciliation — 2026-08-17

- Promoted 2.4.18 as the current development head, direct child of 2.4.17.
- Documented VANILLA loadout, pre-apply warnings, bidirectional exact-match classification, stable historical preset IDs, reduced loadout ownership, and external-delegation behavior.

# 2.4.17 documentation reconciliation — 2026-08-17

- Promoted 2.4.17 as the current development head, direct child of 2.4.16.
- Documented the new Badge Boosts ON/OFF rule and its default-ON migration behavior.
- Removed Badge Boosts from the planned backlog because it is now implemented.
- Documented restrictive composition with built-in `noBadgeBoosts` difficulty profiles.
- No unrelated backlog item was promoted to implemented status.
- Save schema and package file set remain unchanged.

# 2.4.16 documentation reconciliation — 2026-08-17

- Promoted 2.4.16 as the current development head, direct child of 2.4.15.
- Documented the R/B/Y numeric edit-mode hint repair and preserved the 2.4.15 compatibility work as inherited behavior.
- No backlog feature was promoted or removed in this UI-only fix.

# 2.4.15 documentation reconciliation — 2026-08-17

- Promoted 2.4.15 as the current development head, direct child of 2.4.14.
- Documented concrete-mon Type Locke semantics and the new `typeLockAllowsPokemon` compatibility API.
- Documented the narrow Gold indexless-species encounter allowance without broadening starter/script/link claims.
- Added source-audited compatibility notes for Delta Type 1.2.0, Dex Overflow 0.1.1, Safari Zone All 1.1.0, and Wonder Trade 1.2.1.
- Kept Wonderlocke and Permanent Rule Seal correctly classified as WIP/disabled rather than planned-unimplemented or runtime-ready.

# 2.4.14 documentation reconciliation — 2026-08-17

- Replaced stale active README/user-guide/API/compatibility/confidence material with current 2.4.14 state while retaining historical product history in `CHANGELOG.md` and older documentation entries below.
- Reconciled the backlog directly against current code: Mono/Duo/Tri Type Locke, Physical/Special Split, Random Encounters, Random Learnsets, No Day Care, Catch Demo skipping, Gold Radio World Building, PC Vitamins, Safari area splits, Solo Only, and Gym Team Size are documented as implemented rather than future work.
- Corrected Permanent Rule Seal status to implemented groundwork / WIP-disabled.
- Synchronized the current Gen1Recomp audit marker to 0.1.99 and manifest range to `>=0.1.86 <0.2.5`.
- Documented public `item.use`, battle HUD visibility hooks, contextual field-action ownership, Gold hook gaps, and explicit link fingerprint participation.
- Added conservative compatibility notes for AIRivials 2.1.0 and Floating Battle HUD 0.5.7 without guessing unavailable release-asset source details.
- Repaired the human-facing `mod.card` into a valid Lua return table.
- No new runtime PASS claimed.

## 2.4.13
- Documented the dedicated Gold parity audit.
- Added Gold documentation for No Healing Items, No X Items, No Center Heal, and No Mom Heal.
- Marked all four newly exposed paths TEST REQUIRED.
- Preserved the five-versions-ahead Gen1Recomp declaration.

## 2.4.12
- Documented the Kanto Ascendant 6.5.4 source-level compatibility audit.
- Documented external ownership of badge-phased trainer/wild difficulty.
- Documented Trainer Card presentation ownership.
- Added Kanto Ascendant as an optional dependency.
- Preserved `>=0.1.86 <0.2.5`; no new runtime PASS claimed.

## 2.4.11
- Documented Wilds of Kanto 2.1.7 overworld-capture interoperability.
- Documented Modern Party UI 0.3.8 as party-presentation ownership.
- Added both as optional dependencies.
- Preserved `>=0.1.86 <0.2.5`; no new runtime PASS claimed.

## 2.4.10
- Documented the ¥1,000,000 Forgiveness Token cap-aware settlement contract.
- Updated the manifest-policy declaration to five Gen1Recomp patch versions beyond audited 0.1.99 (`<0.2.5`).
- No new runtime PASS claimed.

## 2.4.8 RC

- Documented 0.1.99/0.2.0 launcher compatibility.
- Documented Forgive Encounter modal cleanup.
- Documented once-per-battle Gym Team Size refusal text; no setting added.
- Documented encounter-spend indicator API/state.

## 2.4.7 RC

- Added Modern UI and Gen 2 Randomizer+ optional dependency metadata.
- Recorded Chuck → Pryce → Jasmine as intentional rather than a defect.
- No files added or removed.

## 2.4.6 RC

- Documented confirmed Gym Forgiveness demo/ghost activity-guard fix.
- No files added or removed.

## 2.4.5 RC

- Added Summon 1.0.2 source review.
- Added Quest System 1.0.5 source review.
- Added targeted Summon classification.
- Split quest framework/presentation from source quest content/rewards.
- Preserved Wide Menus runtime PASS.
- No files added or removed.

## 2.4.4 RC

- Added current source review for Catch Helper 1.4.0.
- Added current source review for Area DexNav 1.0.0.
- Added encounter-selector/capture-mechanics compatibility semantics.
- Added cooperative BLIND targeted-encounter selection contract.
- Recorded that Catch Helper active-battle odds are not hidden by BLIND INFO.
- Preserved Wide Menus runtime PASS.
- No files added or removed.

## 2.4.3 RC

- Recorded Wide Menus no-crash runtime PASS for the latest parent build.
- Added current source review for Item Shortcut 1.4.0.
- Added current source review for Reusable Machines 1.0.1.
- Documented item-use-entrypoint and machine-mechanics capability semantics.
- No files added or removed.

## 2.4.2 RC

- Added Modern Bag 1.5.2 current release/index review.
- Added EXP Share Modes 1.0.0 current source review.
- Documented item presentation vs item policy.
- Documented EXP distribution vs EXP cap ownership.
- Documented Experience provider API 2 read-only cap preflight.
- Documented authoritative loaded-mod discovery.
- No files added or removed.

## 2.4.1 RC

- Recorded published 2.4.0 Difficulty/NEXT CAP runtime failure.
- Documented direct-array R/B/Y trainer-party root cause.
- Documented canonical party-reader/composition fix.
- Recorded executable Lua regression-harness PASS.
- Explicitly left in-game Yellow validation as TEST REQUIRED before publication.
- No files added or removed.

# Documentation Changelog

## 2.4.0

- Promoted 2.3.35 RC directly to the published 2.4.0 release.
- Rewrote top-level release documentation to summarize all material changes since the last published 2.3.12.
- Consolidated runtime-confirmed Yellow results from the 2.3.13–2.3.35 development line.
- Updated API/compatibility documentation for additive trainer-capture, custom-Ball, storage transaction, encounter information, translation, UI ownership, Difficulty, and Gym Team Size semantics.
- Clarified that Gold remains beta.
- Documented MOVE INFO as substantially improved/acceptable for release with further cosmetic polish deferred.
- No package files added or removed.

---

## 2.3.35 RC

- Documented the remaining MOVE INFO overlap from 2.3.34 runtime testing.
- Documented the single-column three-line move-card fix.
- No files added or removed.

## 2.3.34 RC

- Logged Yellow 2.3.32 MOD COMPAT sizing PASS.
- Logged Yellow 2.3.32 ENC TRACKER sizing PASS.
- Logged Yellow 2.3.32 F. TOKEN label PASS.
- Logged NUZ INFO page switching PASS.
- Documented Select/Tab MOD COMPAT help paging.
- Documented title-only NUZ INFO bolding and tracked titles.
- Documented dedicated MOVE INFO card layout.
- No files added or removed.

## 2.3.33 RC

- Logged Yellow Route Forgiveness Token full-bag retry PASS.
- Logged Yellow No Rare Candy dialogue/enforcement PASS.
- Documented No Fishing move to GENERAL.
- Documented R/B/Y `NUZ STS.` START-menu label.
- Documented direct built-in Difficulty cap projection fix.
- No files added or removed.

## 2.3.32 RC

- Recorded Yellow 2.3.30 Gym Lock-In PASS.
- Recorded Yellow 2.3.30 Brock Gym Team Size FAIL.
- Documented standard Gym Leader `trainer.before_battle` enforcement fix.
- Clarified that carried non-Egg party slots count toward Gym Team Size.
- No files added or removed.

## 2.3.31 RC

- Recorded runtime-tested 2.3.30 successes and remaining UI regressions.
- Documented native-size tracker/MOD COMPAT restoration.
- Documented paged R/B/Y NUZ INFO and title/column emphasis.
- Documented RNG Info numeric-selector fix and compact Randomizer labels.
- Documented authoritative F. TOKEN item-data fix.
- No files added or removed.

## 2.3.30 RC

- Documented/fixed phantom historical difficulty-provider warnings.
- Documented Starter Style as a Random Starter child.
- Documented Encounter Balance / Randomizer Info / Species Pool as Random Encounters children.
- Preserved Learnset Gen as a Random Learnsets child.
- No files added or removed.

## 2.3.29 RC

- Documented Species Pool as a Random Encounters-only child.
- Documented Learnset Gen as a Random Learnsets-only child.
- Documented dynamic Setup/Rules hiding and saved-value restoration.
- Documented `ACTIVE RULES:` status presentation polish.
- No files added or removed.

## 2.3.28 RC

- Documented clearer R/B/Y MOD COMPAT ownership table.
- Added plain-language ownership relationship help descriptions.
- Documented native cursor, explicit columns, scrolling, and wide presentation surface.
- No files added or removed.

## 2.3.27 RC

- Documented/fixed recurring ordinary-Pokémon DETAIL SAFE MODE.
- Documented lexical forward-reference root cause in the NUZ INFO model.
- Documented `LOC.` constrained row label and glyph-safe right-value fitting.
- No files added or removed.

## 2.3.26 RC

- Recorded runtime isolation of ENC TRACKER crash to Wide Menus integration.
- Documented the invariant Nuzlocke-owned 304x144 / 38-column Gen 1 tracker surface.
- Documented compact `F. TOKEN` mart-row label.
- No files added or removed.

## 2.3.25 RC

- Reviewed Advanced Box System 1.1.0 and Pokédex Plus 1.3.4 from FAFF0x's current synchronized mod index/repository.
- Documented storage transaction API 2.
- Documented OPEN INFO / BLIND INFO randomized encounter visibility.
- Added both reviewed versions to the current compatibility narrative.
- No files added or removed.

## 2.3.24 RC

- Recorded fresh upstream-resolution attempts for IronMON Ultimate and Enemy HP.
- Clarified that the public IronMON Ultimate challenge ruleset is not evidence of the old Gen1Recomp mod's code lineage.
- Preserved historical compatibility evidence without promoting it to current-version confidence.
- No files added or removed.

## 2.3.23 RC

- Consolidated current compatibility status into one canonical ledger.
- Normalized reviewed versions/status for Snag, Too Many Balls, Translation Generator, Shiny Pokemon, Weather FX, and Gen 3 Inspired UI.
- Marked IronMON Ultimate and Enemy HP as historical/upstream-unresolved instead of implying current compatibility.
- Added explicit compatibility confidence terminology/policy.

## 2.3.22 RC

- Reviewed the Gen 3 Inspired UI Overhaul fork and current canonical 2.0.0 parent.
- Documented new provider-neutral Nuzlocke presentation contract.
- No files added or removed.

## 2.3.21 RC

- Reviewed Weather FX 2.6.0 release behavior.
- Documented transient Dungeon Lock-In reconciliation on actual map entry.
- Marked Weather FX 2.6.0 release-reviewed / runtime combination test required.
- No files added or removed.

## 2.3.20 RC

- Reviewed Translation Generator 0.7.0 and Shiny Pokemon 1.0.1.
- Documented enumerable Nuzlocke translation-source API.
- Documented single-refresh ENC TRACKER presentation snapshots.
- No files added or removed.

## 2.3.19 RC

- Re-audited Pokemon Snag at 0.15.9 and Too Many Balls at 0.6.1.
- Updated compatibility rows to current source-reviewed versions.
- Documented generalized trainer-capture and custom-Ball improvements.
- No files added or removed.

## 2.3.18 RC

- Documented the smaller-risk presentation pass.
- Added Difficulty fallback and UTF-8-safe marquee/route/compat fitting fixes.
- No files added or removed.

## 2.3.17 RC

- Documented the small follow-up bug-fix pass.
- Added UTF-8-safe Gold status clipping and UNKNOWN egg-area bookkeeping correction.
- No files added or removed.

## 2.3.16 RC

- Documented the medium-risk stabilization pass.
- Added area-less capture, starter provenance/duplicate, and Gold Physical/Special Split state-isolation fixes.
- No files added or removed.

## 2.3.15 RC

- Documented RNG Seed, Gold enum-selector, delegated learnset ownership, and area-less capture-policy fixes.
- Preserved 2.3.14 tracker/Running Shoes/randomizer-selector behavior.
- No files added or removed.

## 2.3.14 RC

- Documented Wide Menus tracker ownership fix.
- Documented strict B-held Running Shoes behavior.
- Documented four-way Starter Style and Encounter Balance selector fix.

## 2.3.13 RC

- Corrected the ENC TRACKER crash diagnosis: it reproduces with Modern UI disabled, while Wide Menus was observed to prevent it.
- Documented the R/B/Y 304x144 tracker-surface hotfix candidate.
- Retracted the claim that Modern UI itself was the confirmed cause.
- No files added or removed.

## 2.3.12

- Promoted 2.3.11 RC to the final 2.3.12 release with no intentional gameplay/API/save behavior change.
- Recorded Yellow 0.1.98 runtime PASS for title boot, normal fresh-game SETUP, SETUP → NEW GAME, existing SAVE GAME load, and correct fresh-game-only SETUP gating.
- Recorded Gold NEW GAME boot PASS.
- Documented the retained lifecycle-safe startup architecture.
- Corrected the 2.3.11 lineage typo: 2.3.11 is the direct child of 2.3.10, not 2.3.9.
- Kept the existing 15-file package tree unchanged.
- Documented the confirmed 2.3.12 Modern UI + ENC TRACKER crash as a known issue.

## 2.3.11

- Recorded the user-confirmed Yellow 2.3.9 boot/public-setup-screen PASS and the expected diagnostic-only UI limitations.
- Restored documentation status for the complete 2.3.0 RC feature surface, including Skip Opening Intro and Quick Nuzlocke Start.
- Documented lazy Stats/Growth loading, dormant legacy title fallback, lifecycle-deferred gameplay installers, NEW GAME-time Default Names installation, and Gold-only title probing.
- Carried forward the 2.3.2 Gold trainer-battle Ball scoping correction.
- Clarified that 2.3.4–2.3.9 deferral/diagnostic notices are historical and no longer describe the current active build.

## 2.3.9

- Recorded Yellow 2.3.8 as runtime PASS to title on Gen1Recomp 0.1.98.
- Clarified that 2.3.8's absent Setup row was expected.
- Documented the 2.3.9 public title/setup UI diagnostic boundary.

## 2.3.8

- Recorded Yellow 2.3.7 as runtime PASS to title on Gen1Recomp 0.1.98.
- Documented the returned-initializer boundary test and continued diagnostic-only status.

## 2.3.7

- Added explicit diagnostic-only warning.
- Recorded Yellow 2.3.6 as pre-title FAIL.
- Documented the inert-entry loader isolation test.

## 2.3.6

- Recorded Yellow 2.3.5 as pre-title FAIL.
- Documented restoration of pre-2.3 installer behavior and repair of the accidentally missing ItemPolicy installer.

## 2.3.5

- Recorded Yellow 2.3.4 as a pre-title runtime FAIL.
- Documented the 0.1.98 executable compatibility bisect.
- Confirmed intro-skip features remain deferred and are no longer the leading crash hypothesis.

## 2.3.4

- Marked Skip Opening Intro and Quick Nuzlocke Start as deferred and removed from the active build.
- Recorded Yellow 2.3.3 as a pre-title runtime FAIL.
- Clarified that Default Names and Skip Catch Demo remain supported.

## 2.3.3

- Recorded Yellow pre-title runtime failures for 2.3.0-2.3.2.
- Documented boot-time installer deferral and dormant legacy title fallback.

## 2.3.2

- Corrected contextual field-action seam terminology from direct composition to transitive native guarding.
- Documented Gold trainer-battle Ball-policy scoping and the distinction between general item bans and capture rules.

## 2.3.1

- Documented the Gen1Recomp 0.1.98 source audit and new `>=0.1.86 <0.1.99` envelope.
- Documented the shared `mod.battle` snapshot/intents and contextual `mod.world` field-action APIs, including Nuzlocke's read-only/use-only policy.
- Documented the No Fishing public-field-action backstop.
- Documented Berry Juice, RageCandyBar, and Sacred Ash under Gold No Field Heal.
- Documented the all-denial Gold battle-item gate and native Gold starter nickname flow.
- Kept runtime claims conservative: all changed paths remain TEST REQUIRED.

## 2.2.21

- Documented Quick Nuzlocke Start as a separate capture-ready shortcut from the presentation-only Skip Opening Intro.
- Documented R/B/Y Pallet checkpoint, Start Balls minimum, optional Route 22 preservation, and Yellow-specific follower/Rival behavior.
- Documented Gold InitClock/weekday handling, mandatory early-state reconciliation, New Bark checkpoint, Route 29 tutorial preservation, and Cherrygrove whiteout state.
- Documented Nickname Rule, seeded Random Starter, challenge-rule, and provider-ownership interactions.
- Marked all new paths runtime TEST REQUIRED.

## 2.2.20

- Documented NEW GAME-only Skip Opening Intro.
- Documented R/B/Y hidden canonical-name resolution and normal Pallet-bedroom handoff.
- Documented Gold InitClock preservation and later Rival-name story preservation.
- Documented provider ownership and the guarantee that no progression/story flags are fabricated.

## 2.2.19

- Documented the new 8-digit shareable seed and RNG algorithm version 1.
- Documented independent STARTER / ENCOUNTERS / LEARNSETS deterministic streams.
- Added Starter Style semantics for ANY / 3-STAGE / BASE / SIM BST.
- Added Encounter Balance semantics for CHAOS / SIM BST / EVO / BALANCED.
- Documented BST tolerance, evolution-stage classification, progression-safe fallback, legacy roll preservation, and external-provider ownership.
- Added seed editing instructions and status-display behavior.

## 2.2.18

- Documented rule-interaction audit and corrected Failed Encounter precedence.
- Documented Gold grass/water/fishing provenance for Time Split.
- Documented Random Starter species/BST legality and delegated default-name/tutorial/PC-kit ownership.
- Corrected Forgiveness Token wording to Gym Leaders.
- Recorded Egg hatch/type-species legality as an unresolved policy choice rather than claiming enforcement.

## 2.2.17

- Documented manual external Difficulty ownership and the new VANILLA / STACK / MULTI-MOD warnings.
- Clarified that installing Stronger Trainers does not automatically select its `[MOD]` Difficulty entry.
- Documented direct known-provider detection fallback through `mod.find`.

## 2.2.16
- Documented Gym Team Size semantics, presets, live composed trainer-party source, and pre-Leader battle rejection behavior.
- Added PT-BR 0.1.4 and Finnish 0.1.0 to reviewed translation-companion compatibility notes.
- Documented PT-BR native Trainer Card/ListMenu/BattleState layout ownership and localization-safe shop/action matching.
- Documented new read-only `getNextGymTeamInfo()` and translation companion diagnostics.
- Recorded compiler-pressure improvement from 48 to 47 maximum nested upvalues.

## 2.2.15
- Documented the centralized save-upgrade coordinator and deterministic phase order.
- Documented centralized legacy Level Cap and Rule Lock reconciliation, and the intentionally lazy Difficulty provider-ID bootstrap.
- Documented that save schema remains 4 and that the coordinator is internal beta scaffolding, not a public compatibility API.
- Added old-save/idempotency runtime retest targets.
- No package files added or removed.

## 2.2.12
- Documented the full built-in Game Difficulty transformation pipeline and its provider-ownership boundaries.
- Clarified that historical `*` choices are inspired profiles and that Phys/Spec Split is independent.

## 2.2.10
- Documented Species Pool AUTO/GEN1/GEN2/BOTH and the provider-aware R/B/Y cross-generation boundary.
- Documented Gold `gen2Encounters` randomization support.
- Documented optional per-move Physical/Special Split semantics for R/B/Y and Gold.
- Classified Phys/Spec Split under **BATTLE MECHANICS** rather than Game Difficulty; behavior and default remain unchanged.
- Added runtime validation targets and compatibility ownership notes.
- No package files added or removed.

## 2.2.9
Compiler-budget policy, empty-party safety, Dungeon Lock-In cross-family handling, five-vitamin canonical data, and Stat EXP acquisition semantics documented.

## 2.2.8
- Corrected T3 dialogue documentation: vanilla engine text is no longer globally repaginated by Nuzlocke.
- Documented live Difficulty-aware `NEXT CAP` preview and cache invalidation on runtime Difficulty changes.
- No package file additions or removals.

## 2.2.7

- Recorded the full runtime compiler error: the late-runtime function exceeded Lua 5.1's 60-upvalue ceiling.
- Corrected prior documentation that focused on the separate 200-local ceiling.
- Documented the two-phase late-runtime initialization repair.
- No package files added or removed.

## 2.2.6

- Recorded the confirmed Lua local-variable compiler-limit startup failure.
- Corrected the remaining 2.2.3 helper that still consumed a long-lived local after 2.2.5.
- Documented that Skip Catch Tutorial behavior is preserved through the existing internal beta export namespace.
- No file additions or removals.

## 2.2.5

- Documented the 2.2.4 startup regression diagnosis and removal of the extra long-lived local.
- Clarified that the Pokémon Bois Club renderer ownership marker now lives on the NPC rather than in a new file-scope table.
- No public API or file-tree change.

## 2.2.4

- Corrected current Pokémon Bois Club documentation after confirming the old hand-painted Bryan renderer was dormant/dead code.
- Documented the replacement native-engine walker strategy and ownership-safe restoration.
- Recorded that no asset or repository/player-package file was added or removed.
- Preserved all historical 2.2.3 and earlier release notes unchanged.

## 2.2.3

- Documented the focused Yellow Professor Oak catch-demo hardening and the unified NEW GAME skip-setting query.
- Documented complete R/B/Y NUZ INFO rendering, explicit disabled-page rows, move accuracy, provenance/BST details, and full SAFE MODE page reconstruction.
- Recorded that shared T3 dialogue ownership is intentionally unchanged while runtime testing continues.
- No documentation files were added or removed.

## 2.2.2

- Updated current documentation for the `Btl. ¥` compact Trainer Money label.
- Added Yellow 2.1.24 runtime PASS evidence for No Buying, No Selling, and No Center Heal.
- Historical changelog entries retain their historical labels where applicable.

## 2.2.1

- Documented the Gold 2.1.24 runtime finding that the value/toggle column was slightly too far right.
- Recorded the one-tile left correction while preserving the wider rule-label field.
- Confirmed no API, rule-mechanics, file-tree, or Gen1Recomp 0.1.94 compatibility change.

## 2.2.0

- Updated every existing release/documentation surface for the requested 2.2.0 version step from parent 2.1.24.
- Documented the Gen1Recomp v0.1.94 source audit, 10-commit delta, version-aware conflict handling, and new opt-in `mod.postLog`/`log_url` facility.
- Recorded the decision not to add `network` permission or a logging endpoint.
- Updated compatibility/audited-engine language from 0.1.93 to 0.1.94 where it describes the current candidate; historical entries remain historical.
- Documented the NUZ INFO safe fallback, classic/Modern UI MOD COMPAT behavior, NUZ ST. semantic headings, Yellow Professor Oak demo skip, and native Bryan sprite direction.
- Updated runtime-confidence/test guidance for all affected paths.

## 2.1.23

Documented the systemic T3 dialogue presentation boundary, R/B/Y semantic catch-demo skip, and Gold value-column alignment change. No files were added or removed.

## 2.1.22

Documented the Yellow NUZ ST./MOD COMPAT runtime crash and R/B/Y migration to native ListMenu presentation.

# 2.1.19

## 2.1.21

- Documented the Gold Setup/NUZ RULES label-value spacing cleanup.
- No API, rule-mechanics, or save-schema documentation changes.

## 2.1.20

Documented Yellow 2.1.19 runtime PASS/FAIL results, deferred Nuz-menu crash recovery, dedicated Game Difficulty section, updated compact labels, and the current Type Locke enforcement confidence state.

- Documented the compatibility-only scope of the 2.1.19 child build.
- Documented generation-neutral kerning installation retries with Gen1-only call-time behavior.
- Documented fail-closed Modern UI adapter registration requiring explicit `true`.
- Documented the reload-stable R/B/Y title SETUP wrapper and 2.1.18 legacy-wrapper migration behavior.
- Kept the 2.1.18 Yellow runtime evidence and unresolved runtime tests intact as inherited history.

# 2.1.18

- Documented Yellow runtime PASS for default-name skip and PC Vitamins, plus Trainer Card FAIL/crash evidence from 2.1.16.
- Documented restoration of native R/B/Y Trainer Card ownership and separate `NUZ ST.` status navigation.
- Documented one-response-per-script Nuzlocke dialogue ownership.
- Clarified that the bedroom SNES line overlap is vanilla Gen1 `cont` scrolling, not duplicate T3 World Building.
- Retained documentation for the 2.1.17 menu/QOL changes now inherited by 2.1.18.

# 2.1.16

- Documented Trilocke and the Type 3 selector.
- Clarified OFF/MONO/DUO/TRI effective Type Locke behavior.
- Documented No Catching → GENERAL and Route Forgiveness → CLAUSES menu relocation.
- Documented one-pixel header micro-tracking.

# 2.1.15

- Documented centered/emphasized rule-section headers and left-shifted rule rows.
- Documented Type Locke OFF/MONO/DUO selector visibility.
- Restored documentation for reversible Rule Lock as distinct from Permanent Rule Seal.

# 2.1.14

- Documented MONO as a true one-type configuration state.
- Documented Type 2 clearing/hiding in shared R/B/Y + Gold Setup/Rules and DUO secondary reinitialization.

# 2.1.13

- Documented the Yellow Random Starter concrete-data safety gate and retained pre-creation hook contract.
- Documented transactional Mom T3/No Mom Heal behavior.
- Documented clean Pallet TV pagination and removal of the unrelated rule suffix.
- Documented Bryan as a real T3 home NPC with rotating contextual dialogue.
- Recorded parser/static/source-audit status separately from runtime TEST REQUIRED.
- No save-schema, Mod API, permission, or repository-tree change.

# 2.1.12

- Changed Route Forgiveness reward source from ordinary Gym Trainers to one award per defeated Gym Leader.
- Documented Leader-keyed one-time reward ledger and no double-award Gym Guide behavior.
- Added localization-safe compact fallbacks for Nuzlocke Loadout, Dungeon, and Items labels.
- No save-schema or Mod API bump.

# 2.1.11

- Restored full natural labels as canonical translation strings.
- Added optional compact-label metadata and translation-safe fallback rules.
- Documented Gen1Recomp 0.1.93 source audit and updated audited-engine marker.
- Engine envelope remains `>=0.1.86 <0.1.98`.

# 2.1.10

- Recorded Wide Menus coexistence without active widening as the current safe state.
- Simplified collapsible section headers.
- Added compact player-facing rule abbreviations to reduce marquee use.
- Full descriptions and gameplay semantics remain unchanged.

# 2.1.9

- Recorded approved marquee cadence.
- Added 1st / 1 / Enc. menu abbreviations for common rules.
- Documented explicit Wide Menus classic-layout refusal for Setup and Rules.
- No gameplay or save changes.

# 2.1.8

- Documented concise Randomizer menu labels intended to reduce unnecessary marquee scrolling.
- Full rule descriptions remain unchanged in meaning.
- No gameplay/API/save changes.

# 2.1.7

- Recorded Yellow 2.1.6 Wide Menus crash.
- Recorded failed custom outline selection rendering.
- Documented temporary native-width fallback when Wide Menus is installed.
- Documented restored native cursor with reduced gutter.

# 2.1.6

- Recorded 2.1.5 Yellow runtime feedback for marquee speed and selected-row readability.
- Restored historical marquee timing for true overflow only.
- Replaced filled selection highlight with a non-destructive outline.
- Preserved reclaimed left-side text space.

# 2.1.5

- Recorded 2.1.4 runtime presentation feedback.
- Changed R/B/Y long-label behavior from ellipsis to conditional pixel-aware marquee.
- Documented reverse-video row selection and reclaimed left-side text space.
- Documented MOD COMPAT conditional-overflow scrolling.

# 2.1.4

- Recorded Yellow 0.1.92 Gen1 kerning runtime PASS.
- Recorded MOD COMPAT no-crash runtime PASS.
- Documented pixel-measured static R/B/Y rule presentation.
- Documented description wrapping/overflow behavior.
- Documented measured MOD COMPAT columns and pending visual retest.

# 2.1.3

- Recorded Gym Trainer Forgiveness identity-key repair.
- Recorded active-game dependency injection for Gen1 kerning.
- Recorded `compat21.pokemonLegality` invalid-acquisition correction and new reason metadata.
- Preserved Yellow 0.1.92 Setup/boot PASS evidence and pending runtime checks.

# 2.1.2

- Recorded Yellow 0.1.92 fresh Setup and boot runtime PASS.
- Recorded and repaired the 2.1.1 R/B/Y MOD COMPAT crash.
- Documented Gen1 kerning lifecycle retry and pending runtime verification.

# 2.1.1

- Documented Gen1Recomp 0.1.92 source audit.
- Documented the `>=0.1.86 <0.1.98` engine envelope and the distinction between audited and forward-allowed versions.
- Removed obsolete multi-part-beta updater guidance now that Nuzlocke uses ordinary SemVer.

# 2.1.0

- Established `2.1.0` as the canonical development version, replacing the former `2.0.0-beta.31.0.4` identity without changing its code behavior.
- Preserved the complete historical beta lineage in documentation.

# 2.0.0-beta.31.0.4

- Added Wide Menus V0.1.0 to the optional compatibility surface.
- Documented phase-1 R/B/Y in-game Nuz Rules integration and protected native fallbacks.

# 2.0.0-beta.31.0.3

- Documented the Mt. Moon Pokémon Center Dungeon Lock-In repair and generic service-interior classifier hardening.

# 2.0.0-beta.31.0.2

- Recorded Gen1Recomp 0.1.90 source compatibility review.
- Confirmed the existing supported engine envelope already includes 0.1.90.
- Added the upstream Gold field-move and orphaned-slot recovery implications to compatibility documentation.

# 2.0.0-beta.31.0.1

- Documented the reviewed lifecycle/progression repair batch and synchronized build identity.
- Clarified that Champion progression already had a correct `true` return and was not modified.
- Preserved all prior release history.

# 2.0.0-beta.31.0.0

- Documented the Tier 3 Bryan/Bois Club/Pallet home/TV World Building expansion.
- Recorded future achievement-reactive World Building and the provider-aware Black Market shop concept as backlog only.
- Explicitly distinguished those future designs from implemented mechanics.

# 2.0.0-beta.30.1.22

- Documented Tracker/Area Guide provenance tags, expanded MOD COMPAT ownership reporting, and NUZ INFO current-rules legality/provenance.
- Corrected stale `.30.1.21` documentation that mislabeled the `.30.1.20` kerning change and repaired executable build-identity documentation.
- Preserved prior release history and the runtime-test boundary.

# 2.0.0-beta.30.1.21

- Documented the Gen1-only internal variable-width presentation layer, Gold hard exclusion, external kerning non-stacking behavior, and runtime-test boundary.
- Synchronized current build identity to beta.30.1.20 without rewriting historical release entries.

## 2.0.0-beta.30.0.0.10

Updated all existing release documentation for the compatibility/conflict-hardening pass. Clarified stored-vs-effective delegated state, granular randomizer ownership, unified public item/acquisition policy behavior, AutoCompat save ownership, Gold No Fishing handling, and the remaining runtime-test flags. No documentation files were added or removed.

## 2.0.0-beta.29.3.13

- Refreshed all release-facing documentation to 29.3.13 and Compatibility API 26.
- Documented corrected No Catching migration, Trainer Money master/Gold behavior, stable difficulty-provider identity, Route Forgiveness master gating, exact/final-composed Dungeon Lock semantics, Random Type viable-pool behavior, authoritative Gen-I prize/trade provenance, Gold native NPC-trade gating, conservative source-less acquisition inference, and Level Cap/EXP Edging message consolidation.
- Documented the audited neutral defaults for new restrictive rules.
- Added API 26 helper/ownership documentation and compatibility guidance for stable difficulty IDs, migration warnings, deterministic source-less acquisition checks, provider wallet ceilings, and shared `warp.destination` composition.
- Preserved runtime-vs-static confidence boundaries; new 29.3.13 paths remain TEST REQUIRED.

## 2.0.0-beta.29.3.12

- Updated README, release notes, compatibility notes, and user-facing summaries for the Pokemon Bois Club Tier 3 World Building pass.
- Aligned current-version documentation references on the 29.3.11 build label.

## 2.0.0-beta.29.3.10

- Documented Type Locke (`OFF / MONO / DUO`), Type 1/Type 2 selection, off-type free-encounter semantics, Shiny precedence, Random Starter interaction, provider fail-open behavior, and mandatory-starter progression safety.
- Documented No Day Care for both generation backends, including guaranteed retrieval of pre-existing deposits and preservation of Gold breeding/Egg state.
- Corrected Permanent Rule Seal documentation so Game Difficulty, World Building, QoL, and presentation remain adjustable after sealing.
- Updated current build/version and confidence references without rewriting historical entries.

## 2.0.0-beta.29.3.9

- Documented the Gold-native custom UI integration for Setup/Nuz Rules, ENC TRACKER, CATCH INFO, Route Forgiveness, and NUZ STATUS.
- Recorded the upstream Gen1Recomp guidance that `src.ui.OptionRows` is not a Gold compatibility facade and should not be used as Gold chrome.
- Corrected the Nuzlocke Loadout documentation to include IRON/IronMON.
- Removed the remaining Feature Confidence reference to the retired Ball Use Ban tier system in favor of No Catching.
- Preserved TEST REQUIRED status for the new Gold presentation.

## 2.0.0-beta.29.3.8

- Updated all player-facing version references for the World Building parity/cleanup pass.
- Documented Gold/Johto World Building OFF/T1/T2/T3 support, full implemented-rule catalogue coverage, safe-seam presentation policy, and its TEST REQUIRED status.
- Restored IRON / IronMON to the documented Nuzlocke Loadout list.
- Removed stale references to cumulative Ball-ban tiers in favor of semantic No Catching.

# 2.0.0-beta.29.3.3 documentation update

Documented Route Forgiveness, Trainer Money, Permanent Rule Lock, revised preset/default policy, and the 1,000,000 Forgiveness Token shop-price contract. New behavior remains TEST REQUIRED.

## 2.0.0-beta.29.3.3

- Documented the Gold progression/badge corrections, Legacy Recovery flat-key fix, version-aware Eevee/trade provenance corrections, and unified Solo Only active-party semantics.
- Added static regression coverage for the reviewed defects.
- Preserved the distinction between static validation and runtime confirmation.

## 2.0.0-beta.29.3.0 — full release documentation roll-up

### Public docs

- Promoted the 29.2.x development line into the 29.3.0 full beta release.
- Consolidated all public-facing changes since published beta.29.1.0 into the main changelog and README release summary.
- Added a standalone `RELEASE_NOTES.md` for the public 29.3.0 package.
- Updated compatibility documentation to reflect runtime-confirmed Stronger Trainers next-cap support on Yellow.
- Updated Gold, lock-in, route-split, Random Starter, Permadeath, and menu/UI confidence notes without overstating untested paths.
- Preserved known runtime follow-ups rather than marking untested behavior as verified.

### Internal docs

- Recorded beta.29.3.0 as the direct child of beta.29.2.7.
- Promoted the Yellow + Stronger Trainers next-cap result to protected runtime evidence.
- Preserved the reasons for rejected speculative code-review findings and the conditions that would reopen them.

## 2.0.0-beta.29.2.7 — runtime-driven startup and cap compatibility
- Documented pre-battle composed-party cap preview, R/B starter-presentation correction, lock-in section move, and current Yellow runtime evidence.
- Added focused regression targets for Stronger Trainers cap display and protected Yellow menu glyph/QoL behavior.

# Documentation Changelog

This file records public-document changes separately from gameplay/code changes. `CHANGELOG.md` remains the authoritative product/version history. Documentation entries explain what changed and the reason/goal so future releases do not silently rewrite the public record.

## 2.0.0-beta.29.2.5 — startup/UI and compatibility documentation

### Public docs

- Renamed B-button running to **Running Shoes** and documented its Quality-of-Life placement.
- Documented the R/B starter preview correction, Yellow randomized-starter post-lab presentation handling, lowered Trainer Card prompt, Maximum BST digit editor, and final-composed trainer-cap observation.
- Promoted new Blue/Yellow runtime PASS evidence while leaving repeated opening-sequence dialogue as an unresolved regression target.
- Kept the right-arrow/down-arrow collapse-glyph contract explicit for Setup and in-game Rules.

### Internal docs

- Added beta.29.2.5 lineage, Stronger Trainers compatibility rationale, protected Yellow First Rival Mercy evidence, and focused startup/dialogue regression tests.

## 2.0.0-beta.29.2.4 — common route-split documentation

### Public docs

- Replaced blanket Route 1–25 split wording with the independently selectable Route 2, Route 10, and Route 20 rules.
- Added the geography/progression rationale for each common split and documented legacy CARDINAL-save migration behavior.
- Updated the compatibility API description to retain `routes = 0` while exposing `route_2`, `route_10`, and `route_20`.
- Preserved Mt. Moon/Safari split documentation and all beta.29.2.3 numeric-hardening notes.

### Internal docs

- Added beta.29.2.4 lineage, migration safety, regression obligations, and protected encounter-history behavior.

## 2.0.0-beta.29.2.3 — numeric-boundary and review documentation

### Public docs

- Advanced current candidate references to beta.29.2.3.
- Documented finite-number Setup/profile hardening as a defensive corrupted/external-input safeguard, not a change to normal gameplay arithmetic.
- Preserved the beta.29.2.2 lock-in and trainer-cap runtime obligations.

### Internal docs

- Added durable conclusions for the latest investigated RAM, serialization, reload, RNG, Safari, turbo, logging, shadowing, and faint-transition edge cases.
- Recorded why no production change was made for rejected or unconfirmed reports, what protected behavior discouraged speculative changes, and what evidence would justify reconsideration.
- Added finite-number corruption regression coverage and retained persistent-history idempotence/static-tooling follow-ups.

## 2.0.0-beta.29.2.2 — lock-in and compatibility documentation

### Public docs

- Documented **Gym Lock-In** and **Dungeon Lock-In**, including Setup/NUZ RULES availability, already-cleared Gym behavior, conservative multi-exit dungeon coverage, and older-save fail-open handling.
- Documented Dungeon Lock-In protection against Escape Rope plus Dig, Teleport, and Fly when those field moves would otherwise provide an escape path.
- Clarified that Level Cap Scope **POST** is the current postgame/additional-content provider scope rather than restoring the retired separate toggle.
- Documented broader nested trainer-roster ace discovery as compatibility hardening that still requires runtime validation against modified trainer content.
- Updated install guidance for the known launcher behavior that can offer an older published build for this multi-part beta tag line; manual installation of the newest package remains recommended.
- Updated current candidate identity, feature-confidence notes, runtime matrix, and validation counts for beta.29.2.2.

### Internal docs

- Recorded the immediate-parent lineage and protected beta.29.2.1 paths.
- Added durable rationale for confirmed fixes and for reviewed speculative issues that did not justify production changes.
- Added targeted lock-in, trainer-cap, Permadeath, and updater regression obligations without attributing them to ephemeral discussion history.
- Retained the documentation-provenance isolation rule: project records preserve durable facts, evidence, decisions, and uncertainty without embedding ephemeral source references.

## 2.0.0-beta.29.1.1 — starting-money hotfix documentation

### Public docs

**Changed**
- Advanced current-version references to beta.29.1.1.
- Documented the corrected R/B/Y $3,000 default while preserving an explicitly selected $0.
- Downgraded current-version Starting Money confidence to TEST REQUIRED pending runtime confirmation of the hotfix.

**Reason / goal**
- Keep player-facing defaults and confidence claims aligned with the runtime-confirmed beta.29.1.0 regression and the narrow beta.29.1.1 fix.

## 2.0.0-beta.29.1.0 — Gen1Recomp 0.1.83 release-readiness documentation

### `README.md`

**Changed**
- Updated candidate lineage to beta.29.0.2 → beta.29.1.0 with no intended gameplay delta.
- Replaced the former 0.1.82-audit backlog item with the completed 0.1.83 source audit and remaining 0.1.83 runtime certification.
- Added the widened `>=0.1.81 <0.1.84` range and the Mod Manager beta/update test caveats.

**Reason / goal**
- Make the landing page match the engine actually being used for release testing without overstating source review as gameplay runtime proof.

### `docs/USER_GUIDE.md`

**Changed**
- Updated Known Beta Limitations for 0.1.83 source-audited/runtime-pending support.
- Added guidance not to use the Update action on an unpublished local candidate.

**Reason / goal**
- Prevent a tester from accidentally replacing a newer local build with the latest older public release and clearly separate engine-source compatibility from runtime certification.

### `docs/COMPATIBILITY.md`

**Changed**
- Added distinct 0.1.81, 0.1.82, and 0.1.83 engine rows.
- Documented the exact-source 0.1.83 seam audit, the new Gold `mapOverview()` opportunity, and the current beta-tag update-status limitation.

**Reason / goal**
- Publish the exact basis for widening the engine range while keeping untested runtime claims conservative.

### `docs/API.md`

**Changed**
- Advanced `audited_recomp` documentation to 0.1.83 and documented the explicit engine profiles/range.
- Reaffirmed that Gen1Recomp Mod API remains 2 and is independent of Nuzlocke Compatibility API v25.

**Reason / goal**
- Keep integration metadata synchronized with the exact engine audit and prevent API-namespace confusion.

### `docs/FEATURE_CONFIDENCE.md`

**Changed**
- Clarified that beta.29.1.0 is an engine-profile revision, not a new gameplay implementation revision.
- Preserved the beta.29.0.2 regression-confidence reductions until their runtime tests pass on 0.1.83.

**Reason / goal**
- Do not let a successful source audit incorrectly raise gameplay confidence.

### `mod.card` and `manifest.json`

**Changed**
- Advanced version metadata to beta.29.1.0.
- Widened engine compatibility to `>=0.1.81 <0.1.84`.
- Added 0.1.83 runtime-pending and beta-update-status notes to human-facing known limitations.

**Reason / goal**
- Allow the current engine release to load the candidate for certification while accurately communicating remaining release obligations.

### `CHANGELOG.md`

**Changed**
- Added beta.29.1.0 as a distinct compatibility-profile revision with parent, rationale, exact-source findings, carried runtime evidence, and remaining tests.

**Reason / goal**
- Preserve the compatibility decision contemporaneously instead of reconstructing it later.

## 2.0.0-beta.29.0.2 — reviewed bug-fix candidate documentation

### `README.md`

**Changed**
- Replaced the pre-runtime blocker section with the four implemented reviewed fixes and their remaining runtime-test obligation.
- Updated the current-version summary from documentation-only hardening to the narrow gameplay-fix scope.
- Updated the current-version change summary.

**Reason / goal**
- Keep the landing page aligned with the candidate actually being tested without presenting static fixes as runtime-confirmed behavior.

### `docs/USER_GUIDE.md`

**Changed**
- Updated candidate version and Known Beta Limitations to identify the newly fixed paths that still require runtime confirmation.

**Reason / goal**
- Prevent older runtime evidence from being read as confirmation of code paths changed in beta.29.0.2.

### `docs/FEATURE_CONFIDENCE.md`

**Changed**
- Lowered current confidence/status on First Rival Mercy, Gold PC-routed acquisition/Catch Info, One Per Area, Nickname Rule, and No Static where beta.29.0.2 changed implementation.
- Added the four reviewed-fix regressions to the highest-priority confidence gaps.

**Reason / goal**
- Preserve historical runtime evidence while requiring new runtime evidence for materially changed paths.

### `docs/TESTING.md`

**Changed**
- Replaced the documentation-only candidate identity with the beta.29.0.2 four-fix delta.
- Updated structural-gate result to 49/49 and placed the four reviewed fixes at the front of the runtime matrix.

**Reason / goal**
- Make the release-test obligations precise and reproducible.

### `mod.card`

**Changed**
- Removed the three now-fixed code-review blockers from known issues and replaced them with a targeted runtime-confirmation note.

**Reason / goal**
- Distinguish an implemented-but-unverified fix from a known unfixed defect.

### `CHANGELOG.md`

**Changed**
- Added the beta.29.0.2 goal, fixes, protected behavior, and validation status.

**Reason / goal**
- Preserve exactly why each reviewed fix was implemented and what behavior it was intended not to disturb.

## 2.0.0-beta.29.0.1 — release-candidate documentation line

### Release-candidate rebuild

**Changed**
- Standardized public credit wording to bryanthaboi as original author and Stone696 only as updater.
- Removed feature-level/tester attribution language from public documentation.
- Renamed the internal contribution/backlog audit to an attribution-neutral backlog/runtime audit.
- Removed platform-specific provenance references from internal development records.
- Tightened compatibility-document wording so it stays focused on interoperability evidence.
- Updated the structural release gate to enforce the narrower public credit wording.

**Reason / goal**
- Keep public credit simple and limited to the intended project roles.
- Keep internal records focused on technical evidence, decisions, runtime results, and backlog state.
- Keep compatibility documentation focused on interoperability evidence.

### `README.md`

**Changed**
- Reworked the repository opening around collective feature highlights and recent major additions.
- Added a runtime-evidence and regression-protection section.
- Expanded planned work into In Progress, Planned, and Under Consideration/Future so previously discussed Wonderlocke, optional battle-menu shortcuts, and native Pokémon-icon ideas do not silently disappear.
- Added the current pre-runtime code-review blockers so confirmed edge cases are not hidden by older runtime evidence.
- Standardized Credits to the original author and the current updater.

**Reason / goal**
- Make the repository landing page communicate the mod's real current scope quickly.
- Preserve runtime evidence as regression history without assigning feature-level credit.
- Keep previously discussed future ideas visible while clearly distinguishing them from committed features.

### `docs/USER_GUIDE.md`

**Changed**
- Added runtime-evidence guidance and standardized Credits.
- Added the current pre-runtime code-review blockers to Known Beta Limitations.

**Reason / goal**
- Make the relationship between runtime evidence, regression protection, and confidence labels explicit.

### `docs/API.md`

**Changed**
- Added explicit API namespace terminology: Gen1Recomp Mod API 2 versus Nuzlocke Compatibility API 25, compatibility floor 10, and save schema 4.

**Reason / goal**
- Prevent independent API/version namespaces from being confused in future development or integration documentation.

### `docs/FEATURE_CONFIDENCE.md`

**Changed**
- Downgraded affected Gold acquisition/static confidence rows to Known Issue where current code review found a real gap.
- Reduced R/B/Y Nickname Rule confidence slightly because scripted gift/starter history-name synchronization is also affected there.

**Reason / goal**
- Runtime history must not override a newly confirmed current-code defect; confidence reflects the candidate actually being reviewed.

### `mod.card`

**Changed**
- Standardized credits to the original author and current updater.
- Added the current user-visible code-review blockers to human-facing known limitations.

**Reason / goal**
- Keep human-facing mod metadata aligned with the README/User Guide credit wording.

### `CHANGELOG.md`

**Changed**
- History-recovery pass restores additional evidence-backed development details, preserves conflicting historical records explicitly, and adds known intermediate development revisions where supported.

**Reason / goal**
- Make every recoverable development step durable so later releases do not need to reconstruct history from memory or whichever old ZIP happens to survive.

## 2.0.0-beta.29.3.14
Split the completed Gold runtime-critical repair work into the first small sequential update. Compatibility API remains 26.

## 2.0.0-beta.29.3.15
Documented the second split update: rule-menu reorganization, Stat EXP default clarification, Gold Cherrygrove tour skip, and richer item-rule dialogue.

## 2.0.0-beta.29.3.16
Documented the third split update: multi-page NUZ INFO and Compatibility API 27.

## 2.0.0-beta.30.0.0.1
- Documented Random Encounters.
- Documented Random Learnsets and Learnset Gen.
- Documented persistence, merged-registry composition, reversibility, and fail-open behavior.
- Marked new runtime paths TEST REQUIRED.

## 2.0.0-beta.30.0.0.2
- Documented No Fishing behavior and test status.

## 2.0.0-beta.30.0.0.3
- Added Interoperability API v1 documentation.
- Declared FAFF0x/gen1recomp a first-class compatibility target.
- Documented capability-first provider, acquisition, item, registry, and EXP composition philosophy.

## 2.0.0-beta.30.0.0.4
- Documented second FAFF0x compatibility pass and practical consumer APIs for item, encounter, PC, registry and EXP integrations.

## 2.0.0-beta.30.0.0.5
- Documented the Yellow existing-save Encounter Tracker REMOVE ENTRY crash and the detached-view serialization repair.

## 2.0.0-beta.30.0.0.6
- Documented the FAFF0x quest/content provider layer, dynamic areas/dungeons, quest acquisition metadata, boss metadata and randomizer preservation policies.

## 2.0.0-beta.30.0.0.7
- Documented FAFF0x automatic compatibility/legacy adapters, capability scanning, passive acquisition detection, and explicit-provider precedence.

## 2.0.0-beta.30.0.0.8
- Consolidated compatibility/provider terminology.
- Documented canonical capability families, explicit-provider precedence, and provider-mechanics/Nuzlocke-policy ownership.

## 2.0.0-beta.30.0.0.9
- Documented greyed external-provider controls, provider identification, effective-OFF behavior, dormant preference restoration, and the core-rule non-delegation invariant.

## 2.0.0-beta.30.0.0.11
- Added the 30.0.0.11 Gen1Recomp 0.1.84 compatibility checkpoint and documented the intentionally narrow scope.

## 2.0.0-beta.30.0.0.12
- Replaced patch-by-patch engine ceiling maintenance with a pre-1.0 compatibility-family policy and documented the distinction between loader acceptance and runtime certification.

## 2.0.0-beta.30.0.0.13
- Documented the 0.1.86 fresh-game SETUP regression, fallback architecture, narrowed engine family, and required Blue/Gold retest.

## 2.0.0-beta.30.0.0.14
- Recorded the 30.0.0.13 parser regression and 30.0.0.14 structural fix.

## 2.0.0-beta.30.0.0.15
- Documented the explicitly approved first Lua split, upstream sandbox rationale, parser failures in .13/.14, expected system impact, and runtime-test requirements. Further Lua splitting requires explicit approval.

## 2.0.0-beta.30.0.0.16
- Documented the parser-confirmed 200-local failure, rejected pre-package narrow extraction, completed cohesive trainer-reward module boundary, preserved exports, expected compatibility impact, and mandatory parser validation.

- Added the final `.16` nested-scope safeguard and recorded that all packaged Lua sources pass parser validation.

## 2.0.0-beta.30.0.0.17
- Recorded Yellow 30.0.0.16 runtime PASS evidence and updated Permanent Rule Seal documentation from one confirmation step to two explicit warnings plus final commit.

## 2.0.0-beta.30.0.0.18
- Recorded Yellow `.17` seal-scope PASS and reload-persistence FAIL.
- Documented the Gen1Recomp `mod.save` versus `mod.storage` persistence model and the `.18` permanent-seal durable mirror.

## 2.0.0-beta.30.0.0.19
- Marked Permanent Rule Seal WIP/dormant in `.19`.
- Added an implementation recovery map to `docs/API.md`.
- Recorded that prior development-test markers are preserved but suspended rather than deleted.

## 2.0.0-beta.30.0.0.20
- Promoted recurring Yellow duplicate/overlapping dialogue to a known regression target.
- Documented the `.20` active-TextBox World Building guard.
- Recorded the Yellow `NUZ` vertical-position issue as deferred.

## 2.0.0-beta.30.0.0.21
- Documented shared percentage-label presentation.
- Replaced Maximum BST free-entry documentation with OFF / 400 / 450 / 500 / 550 presets and legacy custom-value handling.

## 2.0.0-beta.30.1.0
- Promoted 30.0.0.21 directly to 30.1.0.
- Recorded Yellow runtime PASS for existing-save boot/menu access, Nuz Rules, tested Gym Lock-In boundary rejection, and the specific duplicate-dialogue regression NPC.
- Marked the active-TextBox World Building safeguard as protected/reusable for future duplicate-dialogue defects.
- Preserved Permanent Rule Seal as WIP.
- Preserved the deferred Yellow `NUZ` vertical-position issue.
- Kept runtime confidence separate from static/parser validation.

## 2.0.0-beta.30.1.1
- Recorded Gold NEW GAME -> SETUP crash on 30.1.0.
- Compared against published 29.1.0 Gold title architecture.
- Documented surgical disabling of the newer `MainMenu:buildList()` fallback.
- Documented that its implementation remains preserved in comments.
- Marked 30.1.0 as rejected and Gold Setup as RETEST REQUIRED.

## 2.0.0-beta.30.1.2
- Converted the current 30.1.1 code into a release/documentation child with no intended behavior change.
- Recorded repeat Gold NEW GAME -> SETUP runtime crash after the 30.1.1 fallback disable.
- Marked Gold fresh Setup as an accepted known bug for this beta release.
- Preserved Yellow runtime PASS evidence and other known/deferred issues.

## 2.0.0-beta.30.1.3
- Added Setup/Nuz Rules crash containment and visible underlying-error reporting.
- Recorded unsplit 29.3.0 reproduction.
- Recorded confirmed Lua 200-local ceiling pressure in the current main chunk.
- Deferred any additional split until the surfaced runtime error identifies the failing Setup subsystem.

## 2.0.0-beta.30.1.4
- Recorded that construction-level guarding did not intercept the Setup crash.
- Added update/draw phase protection and visible phase-specific diagnostics.

## 2.0.0-beta.30.1.5
- Recorded the blocked filesystem facade as the first concrete fresh-Setup crash cause.
- Replaced pre-game profile disk persistence with session-local profile persistence.
- Kept prior crash guards temporarily for diagnosis.
- No additional Lua split.

## 2.0.0-beta.30.1.6

- Promoted the 30.1.5 Setup sandbox repair after runtime validation.
- Recorded Gold fresh Setup as RUNTIME PASS.
- Recorded Yellow fresh Setup as RUNTIME PASS.
- Recorded Blue fresh NEW GAME bedroom entry as RUNTIME PASS.
- Reclassified the prior fresh Setup CTD as repaired on the tested current-engine path.
- Kept session-local Setup-profile persistence documented as a temporary limitation.

## 2.0.0-beta.30.1.7
- Added optional Pokegear Cards API v1 integration.
- Added Gold NUZ card, MAP encounter overlay, and RADIO World Building overlay.
- Documented stable IDs, active-provider detection, and explicit PHONE avoidance.
- Added approved focused `pokegear_integration.lua`.

## 2.0.0-beta.30.1.8
- Fixed Trainer Money runtime enforcement ignoring economy-provider delegation.
- Added generic numeric rule `neutral` support.
- Set Trainer Money delegated neutral index to 4 / 100%.
- Updated provider compatibility documentation.

## 2.0.0-beta.30.1.9
- Restored the previously intended Chuck -> Pryce -> Jasmine Gold cap-stage order.
- Clarified that boss-cap ordering is separate from Gold badge slot identities.
- Recorded monotonic fallback sequence validation.

## 2.0.0-beta.30.1.10
- Added per-call save-editor gating to recurring title-menu fallback wrappers.
- Clarified that editor status is runtime/session state rather than an install-time invariant.

## 2.0.0-beta.30.1.11
- Fixed bare `forgivenessEnabled()` call in Gold Mart construction.
- Fixed bare `forgivenessTokens()` call in Route Forgiveness status presentation.
- Documented qualified `TrainerRewards` access as the required split-module boundary.

## 2.0.0-beta.30.1.12
- Fixed false successful-registration state in conflicting stored-location recovery.
- Documented Legacy Recovery fallback for unresolved stored locations.

## 2.0.0-beta.30.1.13
- Added Solo Only enforcement to scripted NPC trades.
- Documented shared gift/trade party-slot gating and reuse of the existing Solo Only denial message.

## 2.0.0-beta.30.1.14
- Moved First Rival Mercy durable one-shot consumption behind positive opening-Rival identification.
- Documented old-save and reordered/rewound Rival behavior.
- Added state-machine regression coverage for non-opening and opening Rival cases.

## 2.0.0-beta.30.1.15
- Added optional minimum-tier support to internal `worldOnce`.
- Threaded `queueTrainerFlavor`'s minimum tier through the generic fallback.
- Documented Tier 1 First Rival Mercy fallback behavior.

## 2.0.0-beta.30.1.16
- Added canonical FAIRY to Mono/Duo Type Locke.
- Preserved RANDOM selector index 17 and appended FAIRY at index 18.
- Documented sparse selector semantics for API consumers.
- Added compatibility notes for merged-registry typing mods.
- Added regression coverage for pure/dual Fairy legality and random viability.

## 2.0.0-beta.30.1.17
- Made R/B/Y No Buying / No Selling recognition localization-safe.
- Added Finnish OSTA/MYY regression coverage.
- Documented generic translated-string compatibility rather than package-specific hardcoding.

## 2.0.0-beta.30.1.18
- Added optional Gen1 Modern UI semantic adapter module.
- Added stable screen IDs for Nuzlocke Tracker, NUZ INFO, Trainer Card, and future Config integration.
- Kept Setup/Nuz Rules native and documented why.
- Added fail-safe/provider lifecycle behavior and runtime test requirements.

## 2.0.0-beta.30.1.21

Documented the PokemonRecompRandomizer public active-run ownership adapter, Gen1-only scope, fishing composition exception, provider-owned learnset protection, and story-context Oak starter recognition. Runtime status remains TEST REQUIRED.

## 2.1.24
Documented the R/B/Y NUZ INFO migration to host-owned ListMenu after the Yellow 2.1.23 runtime crash.

- 2.3.1: documented Yellow New Game runtime FAIL in 2.3.0 and the deferred 0.1.98 compatibility initialization hotfix.
