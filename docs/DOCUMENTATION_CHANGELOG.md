# 3.0.0-BETA

- Completed the release-facing Gen 3 **ported / adapted / new** feature matrix and recast README/RELEASE_NOTES/CHANGELOG around the final implementation rather than chronological feature development.
- Preserved the earlier 2.9 release notes and restored the missing **v2.9.73** historical entry from its published release without claiming later Gen 3 features for that version.
- Restored distinct original-mod, shiny-project, Gen 1/2 maintenance and Gen 3 port attribution in **CREDITS.md**.
- Updated the Gen 3 overview, CORE, Advanced Rules, developer guide and manual test checklist to match current menus, native area splits, OHKO, Egg/Forgiveness tokens, Run Journal, Mod Support and hidden Nuz Dev recovery.
- Flagged early Gen 3 clause-planning text as historical, not an active status catalogue; added CI checks for v3 feature/credit/version consistency and broken local documentation links.
- Kept older user guides and legacy source documentation rather than moving or deleting them.
- The remaining original 3.0 planning notes below document early beta authoring and should not be interpreted as final rule statuses.

- Replaced the historical 2.9.x README introduction with a concise Generation 1–3 v3 beta overview and linked the legacy guide/changelogs.
- Reconciled Gen 3 implementation status, Randomiser, levels and player-feedback documentation; beta limitations remain explicit.
- Added Untamed Advanced visible-wild compatibility to both projects' existing README structure and credited Deluxe0111 in Untamed's CREDITS.md.
- Documented the randomised encounter-chain identity fix: public name uses the visible defeated species, internal repeated-spawn weighting uses the authored slot.
- Updated packaging/release-version handling for the `3.0.0-BETA` manifest and `v3.0.0-BETA` prerelease tag.

# 2.9.73 — historical documentation release

- Published the Gen 3 new-game-only QoL setup/resource descriptions, native PC starter loadout behaviour and deferred Poké Ball unlock notes.
- Updated standalone startup validation cases without making claims about later v3 rule/menu/results features.
- This entry describes the published 2.9.73 release, not the completed v3.0.0-BETA.

# 2.9.72

- Documented Gen-II item-reference normalization, shop non-no-op selection, unified trainer tracing, and shiny private-image isolation.
- Kept runtime failures separate from static/source/package validation.

# 2.9.71

- Advanced all current documentation markers to Nuzlocke 2.9.71.
- Recorded Yellow 2.9.70 / Gen1Recomp 0.2.41 Random Field Items as Runtime FAIL.
- Documented the 2.9.71 Gen-I `world.talk` visible-field-item composition seam and its native-ownership boundaries.
- Kept Gen1Recomp source-review baseline at 0.2.41 and preserved strict separation between source/static review and Runtime PASS.

<!-- Historical 2.9.60 documentation snapshot; not the current v3 build. -->
## Earlier documentation history (2.9.x and before)

## 2.9.60
- Advanced Gen1Recomp source/documentation compatibility through 0.2.40 (`0cf543d597ce84e4d847b2aba782f1bf2799fde0`).
- Documented engine ownership of PresentSync/PresentProbe, VSync, FrameCap, and FixedStep presentation pacing.
- Revalidated the shared Gen-II mod API model and HiddenItems field-item constructor signatures without promoting runtime evidence.
- Corrected the current package inventory to 37 files / 27 Lua modules plus `mod.card`.
- Public Nuzlocke API/schema contracts remain unchanged.


## 2.9.55
- Advanced current documentation to 2.9.55, documented `item_policy.lua` ownership and the intentional package inventory increase to 36 files / 26 Lua modules plus `mod.card`; public API/schema/runtime confidence is unchanged.

## 2.9.54
- Advanced current documentation to 2.9.54, documented `species_policy.lua` ownership and the repaired build-provenance inventory count, and intentionally updated the protected package inventory to 35 files / 25 Lua modules plus `mod.card`; public API/schema/runtime confidence is unchanged.

## 2.9.53
- Advanced current documentation to 2.9.53, documented the new `encounter_tracker.lua` ownership boundary, and intentionally updated the protected package inventory to 34 files / 24 Lua modules plus `mod.card`; public API/schema/runtime confidence is unchanged.

## 2.9.52
- Advanced current documentation to 2.9.52, documented the new `pokemon_identity.lua` ownership boundary, and intentionally updated the protected package inventory to 33 files / 23 Lua modules plus `mod.card`; public API/schema/runtime confidence is unchanged.

## 2.9.47


## 2.9.51
- Advanced current documentation baseline to 2.9.51, documented the new `compatibility_runtime.lua` ownership boundary, and intentionally updated the player-package inventory contract to 32 files / 22 Lua modules plus `mod.card`; Compatibility API remains 37 and Runtime PASS evidence is unchanged.


## 2.9.50
- Advanced the current documentation baseline to 2.9.50 and recorded completion of the reviewed existing-owner modularization phase; public contracts and Runtime PASS evidence are unchanged.


## 2.9.49
- Advanced the current documentation baseline to 2.9.49 and recorded Gen-II title SETUP ownership activation in `title_setup_compat.lua`; public contracts and Runtime PASS evidence are unchanged.


## 2.9.48
- Advanced current documentation baseline to 2.9.48 and documented Dev-diagnostics ownership closure; public contracts and Runtime PASS evidence are unchanged.
- Reconciled documentation to the World Building ownership-completion build.


## 2.9.46
- Reconciled documentation to the diagnostic ownership-consolidation build.


## 2.9.45
- Reconciled player documentation to the 2.9.45 static catalog-consolidation build.
- Recorded the batched existing-owner modularization without promoting runtime evidence.


## 2.9.44
- Reconciled player documentation to the 2.9.44 save-schema descriptor modularization build.
- Recorded `main.lua` progress at 31,462 lines / 1,568,827 bytes, down 60 lines / 3,118 bytes from 2.9.43.
- No player-facing rule/API/schema behavior changed.

## 2.9.43
- Reconciled player documentation to the 2.9.43 descriptor-registry modularization build and added quantitative `main.lua` progress reporting.

## 2.9.42
- Reconciled player documentation to the 2.9.42 descriptor-construction modularization build.
- Updated current document headings/baselines while preserving historical sections and unchanged public contracts.
- No player-facing rule/API/schema behavior changed.

## 2.9.41
- Reconciled player documentation to the 2.9.41 pure rule-value coercion modularization build.
- No player-facing rule/API/schema behavior changed; current contracts remain Save Schema 5, Compatibility API 37, Diagnostics API 1, Translation API 2, Run History v2, and Randomizer algorithm v1.
# 2.9.40 documentation reconciliation

Documents the Release Safety semantic self-audit, compatibility evidence classes (`live_contract`, `source_reviewed`, `combined_runtime_required`), and the corrected role-document heading validation. No gameplay, provider-ownership, save-schema, or public API version changed.

# 2.9.39 documentation reconciliation

Documents the new private/internal structured rule-status certification diagnostics, exact-edition runtime evidence boundary, and the distinction between structural, semantic/reconciled metadata, reachability, and Runtime PASS. No gameplay or public API version changed.

# 2.9.5 documentation reconciliation

Documents the external healing/services ownership audit and preserves the distinction between service healing, item healing, story healing, and survivor-only external healing. No Runtime PASS promotion.

# Documentation Changelog — 2.9.2

- Added the authoritative battle-stack ownership contract and combined-runtime test matrix for G9/QoL/Nuzlocke overlaps.
- Clarified modern combat/stat ownership versus Nuzlocke challenge policy, native Gen-II identity DVs, semantic held-item enforcement, and native battle-party routing.
- Added the authoritative party-stack ownership contract and runtime test matrix.
- Clarified Modern Party UI 0.4.0 as Gen-I presentation ownership with engine/source controller ownership retained for semantic party actions.
- Reaffirmed protected native Gen-II party routing and follower/voxel presentation boundaries.
- No public API/schema change and no new Runtime PASS claim.

# 2.8.97 documentation reconciliation

Documented the Gen-II Random Field Items source/static pipeline audit, native script-projection evidence, and continued runtime-pending status.

---

# 2.8.89 documentation reconciliation

Documented the Gen-II Random Trainers source/static pipeline audit, read-only accepted-roster diagnostics, and continued runtime-pending status.

---

# 2.8.88 documentation reconciliation

Documented the new Random TM Locations method, the TM-content/TM-location ownership split, source-specific visible/hidden Item Randomizer delegation, and the correction from 2.8.87 report-only Field Item ownership to execution-time enforcement. Broader external-mod precedence remains provisional.

---

# 2.8.87 documentation reconciliation

Updated public compatibility documentation for the external Randomizer ownership audit: Pokémon Gen 1 Randomizer 0.46.4, Gen 2 Randomizer+ 2.9.0, and Item Randomizer 1.1.1. Clarified that the broader external-mod precedence policy remains undecided and that 2.8.86 Poison Save handling is case-specific.

---

# Documentation Changelog — 2.8.86
- 2.8.86: Updated QoL Toggles review to 1.30.8/Gen-I+Gen-II and documented Permadeath precedence over POISON SAVE plus revalidated TM/held-item/escape/heal/repel/running composition.
- 2.8.86: Revalidated Kanto Reforged 1.5.3 Gen-I/Gen-II compatibility ownership, fixed-static provenance, scoped encounter-randomizer delegation, held-item composition, and stricter level-cap composition; no public API/schema change.

- 2.8.86: Refreshes Gen1Recomp/UI compatibility baselines and status classes: engine 0.2.33 remains current; Gen1 Modern UI 0.9.2 is retired legacy; Modern Party UI 0.4.0 and Wide Menus 0.3.0 are current reviewed targets; legacy variable-width kerning remains unversioned/passive; Clean UI is successor-watch only.
- 2.8.83: Adds Dramatic Shape Voxel Mod 1.0.6 (`DRAMATIC_SHAPE`) to the explicit Gen-I presentation compatibility target registry while keeping it target-only rather than a manifest dependency.
- 2.8.82: Added a consolidated explicit compatibility-target alignment for maintained Shiny 1.2.20, PokéPC Followers 0.5.1, Followers EX 1.0.19, and the preserved Nuzlocke Wilds 2.2.0 target; retained all Nuzlocke-specific/translation targets and kept source targets distinct from Runtime PASS.
- 2.8.80: Documented the failed-area F. TOKEN confirmation safety repair: directional choices are now explicit/idempotent, with runtime confirmation still required; public API/schema contracts are unchanged.

- 2.8.79: Reconciled current public documentation with the cumulative release contract: preserved exact-edition support/confidence wording, public API/schema values, compatibility ownership boundaries, and known runtime failures; no gameplay behavior or public API changed. Internal project-process and research provenance remain outside player-facing documentation.

- 2.8.78: Audited Gen1Recomp 0.2.30–0.2.33; corrected upstream Save Format profile metadata; documented `pokemon.level_visible`, Gen II future opportunities, ONLINE-arena mod policy, protected-seam revalidation, and pending runtime evidence. Public Nuzlocke contracts remain Save Schema 5, Compatibility API 36, Diagnostics API 1, Translation API 2, Run History v2, and Randomizer algorithm v1.
- 2.8.77: Advanced Compatibility API 35→36 for corrected `runtime_environment` value semantics and atomic content-bundle prevalidation; documented Gen2 field-item Hook Health session repairs and semantic `trainer.party` diagnostics. Save Schema remains 5; Diagnostics API remains 1.
- 2.8.76: Documented R/B/Y Ball fail-closed handling, F. Token FAILED-state recovery semantics, and six-edition World Building certification accounting.
- 2.8.75: Documented explicit false preservation for Run History death shiny evidence and its focused regression self-test.
- 2.8.74: Documented Route 4 Magikarp deterministic gift fallback repair and catalog-driven acquisition consistency self-test.
- 2.8.73: Documented durable transaction payload identity, legacy receipt compatibility, transaction self-test repair, and fail-closed external item-policy exceptions.
- 2.8.72: Added full built-in Difficulty mechanical reference, Silver/Crystal profile catalogs, concise in-game chooser contract, percent-glyph-free explanation policy, native confirmation cursor, and scrollable profile-detail guidance.
- 2.8.71: Fixed Gen1 Difficulty Review lexical-scope crash, added R/B/Y profile-control value/result rendering, and documented numeric-rule registry bounds audit.
- 2.8.70: Documented Run History v2 abandon durability/backfill, generalized partial-detail coverage, live-pruning coverage, and dynamic stored-state history-version validation.
- 2.8.69: Consolidated translation registry roles, fixed Finnish optional ordering, reconciled German scope, and documented reviewed non-runtime placeholder/fork/tooling/engine-fork classifications after the final discovery sweep.
- 2.8.68: Added alternate Spanish spanish_translation 0.1.0 Red target, lineage, Battle UI override, loaded literal-handler mutation review, and focused certification notes.
- 2.8.67: Promoted Finnish 0.1.0 to a reviewed current Red target with glyph, presentation override, loaded replacement-script, and focused LOCAL CERT metadata.
- 2.8.66: Added translation-nl 0.0.2 Red/Blue compatibility, coverage/fallback metadata, and confirmed-loaded replacement-script mutation review.
- 2.8.65: Added zh_cn 0.3.1 R/B/Y compatibility, fixed-cell CJK/presentation-wrapper metadata, generalized translation presentation-wrapper policy, Chinese LOCAL CERT focus, and Literary Chinese engine-fork classification.
- 2.8.64: Added recomp-polish 1.0.0, conservative Red scope, fixed-cell Polish glyph/fallback behavior, and present-but-load-unconfirmed replacement-script review metadata.
- 2.8.63: Added primary/alternate Italian targets and generalized replacement-map-script mutation policy.
- 2.8.62: Added session-only manual localization runtime-certification workflow, exact translation-combination identity, ten-surface checklist, Dev Report controls, and report snapshot integration.
- 2.8.61: Documented the Japanese-driven byte-length/fixed-column UI audit, shared internal glyph helpers, Pokegear localization hardening, and additional Gen-II status/Pokegear sources.
- 2.8.60: Added Japanese Red/Blue translation target 0.4.2, CJK/TTF ownership documentation, UTF-8/glyph-span safeguards, matrix coverage and Japanese runtime checklist.
- 2.8.59: Added the formal translation compatibility matrix and expanded Translation API 2 discovery for Forgiveness/F. TOKEN, Battle Clause denials, common status/compatibility labels and selected runtime messages.
- 2.8.58: Added explicit translation-fr 0.8.0 all-six-edition compatibility and trad-fr-extended 0.2.0 overlay compatibility, including VWF/content-ownership and language-neutral gameplay documentation.
- 2.8.57: Added explicit Traduccion Espanola 0.1.0 compatibility, Red/Blue cartridge-layer scope, partial-without-EUR-dump behavior, optional load ordering, and language-neutral gameplay safeguards.
- 2.8.56: Documented glyph-safe long-string/VWF UI hardening and Translation API 2 World Building/Randomizer source expansion.
- 2.8.55: Expanded Translation API 2 source discovery for NUZ STATUS/tracker/world-summary UI and documented read-only Dev localization lifecycle/fallback diagnostics.
- 2.8.54: Added Translation German Universal 0.2.0 compatibility, Translation API 2 installed-vs-active lifecycle fields, restart/pending-language semantics, and canonical area-ID localization protection.
- 2.8.53: Documented inactive-provider ownership exclusion, canonical Compatibility API 35 snapshot dedupe, TX.api journal-version hardening, and explicit Run History critical=false preservation.
- 2.8.52: Corrected DEV REPORT SHINY Colors/Intro default readout to match the authoritative ON defaults; added Release Safety default-drift protection.
- 2.8.51: Documented false-value preservation repair in schema migration and durable exact-value transactions; Save Schema 5 and Compatibility API 35 remain unchanged.
- 2.8.50: Added explicit VersaoVermelha 0.2.5 Brazilian compatibility documentation, retained legacy gen1_pt-br separately, documented presentation ownership/export diagnostics, and formalized language-neutral semantic shop matching.
- 2.8.49: Documented Run History API/storage v2, durable achievement-evidence statistics, explicit partial-history semantics, failed-encounter journaling, and rule-integrity evidence. Global Save Schema remains 5.
- 2.8.48: Advanced Compatibility API 34→35 for semantic provider/capability status + compatibility snapshots; audited Gen1Recomp 0.2.28/0.2.29, added engine profiles, advanced the audited marker to 0.2.29, retained the >=0.2.24 <2.0.0 floor, and documented that Save Schema remains 5.
- 2.8.48: Advanced Compatibility API to 35 for semantic provider/capability status introspection; audited Gen1Recomp 0.2.28/0.2.29, advanced the current engine audit marker to 0.2.29, retained the >=0.2.24 floor and Save Schema 5, and documented the upstream HostShell/input/importer-only diffs.
- 2.8.47: Full documentation/release reconciliation. Added authoritative current-release contract sections to README/User Guide/API; synchronized engine range/audit marker, game support stages, API/schema versions, Randomizer subsystem scope, shiny ownership, compatibility semantics, Gen II hidden field-item ownership, and selected Crystal-inclusive rule descriptions. Historical notes are now explicitly version-scoped.
- 2.8.46: Completed the current Dev Mode backlog with Rule Configuration Consistency, Save/Run Identity Health, and bounded Compatibility Ownership History diagnostics.
- 2.8.45: Added Dev diagnostic severity/repetition coalescing and Dev-only performance counter documentation.
- 2.8.44: Added read-only Shiny and Randomizer Reproducibility Dev Mode diagnostics and API contracts.
- 2.8.43: Added Dev Mode Transaction Health and Hook/Wrapper Drift diagnostics, public read-only APIs, System Health integration, and Release Safety contracts.
- 2.8.42: Added DEV REPORT BUG REPORT snapshot documentation and the read-only `nuzlocke_dev.bug_report_snapshot(game)` API contract.
- 2.8.41 Dev Mode diagnostics: documented System Health, provider ownership detail, encounter provenance, bounded rule-decision traces, and the diagnostic-only contract.
- 2.8.41 Release Safety expansion: documented the new recurring-regression bundle for Gen II battle/party ownership, shiny ownership, transaction journaling, battle.started payload compatibility, and Randomizer structural performance.
- 2.8.39 compatibility/API cleanup: documented provider-state vocabulary, public read-only compatibility diagnostics, explicit fallback inventory, and the rule that supported historical fallbacks are removed only after their engine/provider floor is unreachable.
- 2.8.38 localization hardening: reclassified localization as implemented infrastructure with incomplete coverage; documented the first low-risk migrated text batch, English fallback behavior, targeted Release Safety protection, and dedicated future World Building/Randomizer phases.
- 2.8.37 full-release promotion: synchronized versioned documentation and recorded Red runtime PASS for Nuzlocke-only ALWAYS shiny generation, Gen I recoloring, and shiny intro presentation. No behavior change from the final corrected 2.8.36 candidate.
2.8.36 standalone shiny regression fix: external shiny ownership now requires a live separate provider handle before registry/API claims are trusted, preventing Nuzlocke-only runs from falsely standing down their built-in shiny system.
- 2.8.36 Shiny Pokémon 1.2.7 compatibility: documented generation-neutral provider/API detection, Gen I + Gen II external-owner failover, Gen1Recomp 0.2.27 engine-owned COLORS invalidation, and palette-signature-keyed private fallback shiny cache behavior.
- 2.8.36 corrective compile-budget rebuild: provider alias data is resolver-scoped; failed first package quarantined.
# Documentation Changelog — 2.8.40

- Documents the complete provider-absent shiny stack and the new Shiny Colors / Shiny Intro controls.
- Replaces the older Gen-I-only ownership assumption with edition-active capability-based shiny ownership.
- Documents immediate external-provider stand-down for generation, colors, sparkles, and SFX while preserving Nuzlocke shiny rule/tracker consumption.
- Documents current Gen1Recomp `pokemon.sprite`, `pokemon.icon`, and `battle.overlay` seams as the built-in presentation boundary.
- Records that Nuzlocke still must not replace Pokemon constructors, Gen-II battle screens, BattleState draw ownership, or renderer composition for shiny presentation.

# Documentation Changelog — 2.8.35

- Documents `SHINY_POKEMON` as an explicit optional Gen-I compatibility target.
- Documents the single-owner rule: external provider owns Gen-I shiny roll/presentation when healthy; Nuzlocke otherwise owns a lightweight fallback.
- Documents the new Shiny Rate rule and its NATIVE / enhanced values.
- Documents Gen-II use of the public `shiny.roll` seam and native shiny field.
- Clarifies that Nuzlocke's Gen-I fallback does not duplicate rich recolor/sparkle visuals and recommends the companion mod for those visuals.

# Documentation Changelog — 2.8.33

- 2.8.33: Documents explicit PotatoVoxel 1.9.6 compatibility and the generalized presentation-provider ownership contract.
- Documents that Nuzlocke must not own `render.compose`, `Gen2BattleState`, or native BattleState draw methods when composing with renderer mods.
- Documents PotatoVoxel cache/prebuild as graphics preparation rather than Nuzlocke traversal/progression.
- Adds edition-scoped combined-mod runtime requirements and preserves the 2.8.32 type-chart companion contract unchanged.
- Records the corrected executable lineage for this child: exact 2.8.32 parent.

# Documentation Changelog — 2.8.32

- 2.8.32: Documents explicit compatibility/recommendation for STEEL/FAIRY AND TYPING CHARTS 2.0.1 and the live merged type-chart ownership contract for Starter Trio Typing.
- Records 2.8.31 as a flawless Silver runtime PASS and canonical parent.

# Documentation Changelog — 2.8.31

- 2.8.31: Records Silver 2.8.30 partial runtime PASS (3-STAGE base form, portrait, award) and narrows the remaining repair to Elm confirmation literal rendering plus the pre-GIVEPOKE getmonname receipt buffer.

- Recorded 2.8.29 Crystal corrective runtime PASS and promotion to canonical parent.
- Documented the Gen II 3-STAGE evolution-target field mismatch (`into` vs `species`) and style-aware stale-cache invalidation.
- Documented Elm confirmation `rawtext` literal repair for the reported `...` textbox.
- Kept 2.8.29 Gen II battle ownership and Wilds compatibility notes unchanged.

# Documentation Changelog — 2.8.29

- Recorded 2.8.28 and the prior 2.8.29 candidate as runtime-failed/quarantined.
- Documented Battle Menu UI as Gen I-only at registration and configuration-surface level.
- Documented retirement of the custom Gen II battle-rule pager and native BattleState denial presentation.
- Preserved the reviewed Wilds 2.2.0 compatibility audit notes.

# Documentation Changelog — 2.8.29

- Recorded 2.8.28 as runtime-failed/quarantined after Crystal exposed Nuzlocke's Gen II custom battle-menu redraw and a separate battle-item denial freeze.
- Documented Battle Menu UI as Red/Blue/Yellow-only.
- Documented full native battle-command presentation ownership for Gold/Silver/Crystal.
- Replaced the custom Gen II rule-text BattleState phase/update pager with the native refusal state; exact runtime reproduction must pass before promotion.

## Historical current note: Documentation Changelog — 2.8.27

- Recorded the Crystal runtime failure of 2.8.26.
- Documented complete Gen II PartyMenu method ownership by the engine.
- Preserved native item-target and battle-menu responsibilities separately.

## 2.8.04

- Documented Gen II Nuzlocke-owned utility-screen hardening for NUZ STATUS, MOD COMPAT, ENC TRACKER, and DEV REPORT.
- Recorded that DEV REPORT no longer exposes the machine-oriented report-code page as its default/player-facing section.
- Recorded preservation of 2.8.03 Crystal item-use and Randomizer runtime PASS evidence.

# Documentation Changelog — 2.8.01
- 2.8.01: Documented restored Gen II Trainer Randomizer controls, independent post-poison wipe detection, and the unchanged Gen II party-target item-use known issue.


- 2.8.00: Packaged the requested full release; documented authoritative-live-slot Gen2 party-consumable commit ownership, target-sensitive legality recheck, preservation of specialized item paths, and the slower five-stage Setup/Rules navigation curve.

- 2.7.106: Documented the Crystal post-selection consumable failure, direct Gen2 ItemEffects repair, preservation of specialized PP/stone paths, and five-stage held-navigation acceleration.
- 2.7.105: Recorded the Crystal party-item failure's exact chooser-mode symptom, retired the disproven full-record starter mutation, documented the narrow Gen2 useItem PartyMenu contract guard, and added held Setup/Rules UP/DOWN repeat navigation with SELECT section-jump priority.
- 2.7.104: Documented protected TOOLS profile PASS evidence, retirement of direct Gen2 Pack routing, native randomized-starter record materialization, and the new runtime test target.
- 2.7.103: Documented direct native Gen2 party-item routing, distinct Profile Slot/Save/Load semantics, and the restored T3 World Building default.
- 2.7.102: Documented the Gen2 native party-item representation repair and restored TOOLS shared OFF/1/2/3 profile-target interaction.
- 2.7.101: Added in-run TOOLS/profile documentation, Gen2 service/shop visibility repairs, Crystal DST skip hardening, and advanced the Gen1Recomp source/documentation audit through 0.2.25 including read-only imported dataset views.
- 2.7.95: Recorded 2.7.94 Red/Silver/Crystal Random Starter runtime success; documented Gen-2 tracker canonical ordering/filtering, Setup monochrome repair, MOD COMPAT spacing/blink cleanup, and compact Battle Menu UI visual restoration.
- 2.7.94: Documented the exact 2.7.44 PASS -> 2.7.45 FAIL Red Random Starter runtime bisect, restored starter-specific Species Pool isolation, preserved Species Pool for Encounters/Trainers/Evolutions, and simplified R/B/Y Setup/Rules title wording.
- 2.7.93: Added the optional Battle Menu UI presentation toggle; merged Running Shoes + Fast Surf into Run / Surf with conservative legacy migration; fixed No Catching's Allow Glitches suppression key; retained 21 sections / 151 unique rules.
- 2.7.92: Implemented the approved Nuzlocke Setup/Rules visual contract: bold title, uniform black normal rows/values/pager/help text, preserved raised rows and bottom-centered pager.
- 2.7.91: Protected the runtime-PASS vanilla Elm transaction from optional Random Starter slate faults, hardened an empty duplicate-safe fallback pool, and moved the Setup/Rules pager to bottom-center while moving rule rows upward.
- 2.7.90: Replaced starter species/map heuristics with one VM-script-scoped mandatory-starter provenance marker, added a native receipt window across pokemon.received, and made New Game Random Starter settings durable at save.created.
- 2.7.89: Recovered runtime-proven starter transaction ownership for R/B/Y and Gen 2, removed redundant Setup/Rules edition/run-state subtitle, and explicitly deferred Crystal Mom DST cleanup.
- 2.7.88: Recorded the public Gen-2 Pokemon `index` identity contract, exact Elm GIVEPOKE operand fallback, R/B/Y Random Starter transaction hardening, Manual Time HH:MM summary, and explicit live NZR6 code generation.
- 2.7.87: Recorded the real Gen-2 Elm numeric-species identity defect, Random Starter index repair, Manual Time minute control, Crystal Mom DST completion, and restoration of the code-first DEV REPORT page.
- 2.7.86: Recorded Silver/Crystal vanilla Elm starter rejection/soft-lock evidence; restored Gen-2 clock setup applicability and documented canonical Gen-2 species registry resolution before glitch classification.
# Documentation Changelog — 2.7.85

- 2.7.85: Recorded Crystal 2.7.84 runtime boot/world/Elm PASS and starter-ball crash FAIL; documented the Crystal native-presentation fail-open repair and the stale DEV REPORT Randomizer validation-count repair.

- 2.7.84: Advanced the Gen1Recomp compatibility/documentation audit through the 0.2.24-era line; intentionally added Crystal as an explicit ALPHA target; documented independent Crystal runtime evidence, six-edition Release Safety, `activeBlockAt`/`map.occupancy_allowed`, intentional non-use of Gen-1-only `battle.field_residual`, Custom Carts/session/translation learnings, and the `OptionRows` / Gen-1-only `src.script.Commands` compatibility boundaries.

- 2.7.83: Documented the planned Rules/Setup UI pass: top-right rule counter, direct Loadout chooser with change preview/confirmation, direct Difficulty chooser with concrete trainer/boss summary and stacking warning, in-run Gold/Silver Manual Time authority, and explicit deferred Starting Ball wording. Crystal and the encounter-overlay redesign remain deferred.


- 2.7.82: Recorded the Silver/Gen-2 runtime-hardening batch: complete Mom DST-ladder ownership under System Date/Time, final Elm raw-text confirmation fallback, native Elm-event Tracker completion, lifecycle-exact Gen-2 NUZ INFO installation, build-time-only Release Safety, player-facing diagnostic-code cleanup, unchanged deferred starting-Ball timing, and focused runtime retest debt.


- 2.7.81: Recorded the Gen1Recomp 0.2.21 source audit, exact five-edition target boundary, engine developer/options-screen metadata, completed Gold/Silver DST setup coverage, native clock-helper ownership, Gen2 OptionRows warning, and runtime validation debt.
## 2.7.80

- Documents the exact pending Elm GIVEPOKE finalizer and narrow old-save starter proof contract.
- Documents Gen-2 `System Date/Time` setup and `System Clock Sync` QoL using native clock authority.
- Documents B-to-stop Rare Candy `TO CAP` at complete-candy boundaries.
- Records strict 2.7.79 -> 2.7.80 reconstruction lineage and explicitly leaves 2.6.81+ behavior unrecovered.

## 2.7.79

- Documents context-based Gold/Silver Elm starter classification, proven-starter native story reconciliation, rendered-preview confirmation authority, starter reachability diagnostics, and the tightly scoped identity-less LEGACY repair exception.
- Documents the shared Gen-2 Nuzlocke utility-title hierarchy and protected native-UI boundary.
- Records strict 2.7.78 -> 2.7.79 reconstruction lineage and explicitly leaves 2.6.80+ behavior unrecovered.

## 2.7.78

- Documents the one-physical-Pokemon/one-active-encounter identity invariant for starter recovery.
- Documents exact-ID starter history dedupe, conservative existing-save repair, safer hometown migration, Gold/Silver Recover Catches parity, and saved-identity preservation during manual assignment.
- Records strict 2.7.77 -> 2.7.78 reconstruction lineage and keeps 2.6.79+ behavior unrecovered.

## 2.7.77

- Documents direct Gen-2 PartyMenu targeting, randomized Elm confirmation text, GIVEPOKE grant-delta recovery, ordinary-interior Tracker filtering, and live Reroll/Auto Seed controls.
- Records strict 2.7.76 -> 2.7.77 reconstruction lineage and keeps 2.6.78+ behavior unrecovered.

## 2.7.76

- Documents edition-correct starter hometown provenance, Gen-2 Tracker seed isolation, live Gen-2 script authority, the PartyMenu NUZ INFO safety net, and Gen-2 adapter reachability diagnostics.
- Explicitly leaves later 2.6.77 randomizer/QOL work unrecovered.

## 2.7.75
- Recorded the controlled recovery of the shared Gen-2 exact-edition predicate and parity diagnostics from the reviewed mistaken 2.6.75 delta.
- Silver is reconnected to shared Gen-2 adapters without cloning Gold behavior.
- Runtime validation remains required for Silver tracker/starter/NUZ INFO behavior and Gold regression smoke.

## 2.7.74
- Recorded Silver NEW GAME Setup as runtime evidence sufficient to promote the 2.7.73 Late Runtime recovery.
- Recovered the isolated Gold utility-screen visual-normalization delta from the mistaken 2.6.74 child.
- Kept gameplay, Randomizer, persistence, compatibility, and native host UI unchanged.

## 2.7.73
- Began controlled reconstruction from exact canonical 2.7.72.
- Documented the Late Runtime dependency-order recovery and strict one-batch-at-a-time recovery policy.

## 2.7.72
- Documented safe explicit-wide fallback and selected Tracker marquee ownership.

## 2.7.71
- Removed the global T3 World Building run-summary page append and documented recap-context isolation.

## 2.7.66 rule-availability audit, pass 2

- Continues the rule-availability audit in a deliberately small pass.
- Yellow no longer exposes Random Starter `Trio Typing` as a native rule because Yellow does not natively use the three-choice starter slate; an explicit compatible `starter_trio` provider can make it available.
- Encounter-slot modifiers now depend on `One Per Area`: Failed Encounters, Dupes, Gen II roamer/egg/contest policies, Town Catches, and area/time/headbutt split controls become dormant while area encounter limits are OFF.
- Type Locke now exposes/effects only the lanes selected by its mode. Catch Draft is hidden while Type Locke is OFF; manual type lanes are hidden/inert during Catch Draft; DUO through HEXA progressively reveal only the required lanes.
- Stored values are preserved while dormant and return when their prerequisite becomes applicable again.
- Release Safety extends the exact-edition/dependency source tripwire for these relationships.


# Documentation Changelog — 2.7.65

## 2.7.65

- Documents exact-edition rule availability, capability-gated mechanics, dependency hiding, and dominance suppression.
- Documents that dormant child preferences remain stored but behaviorally neutral.

## 2.7.64

- Documents interactive MOD COMPAT ownership preferences for contract-backed capability rows.
- Documents AUTO/native/provider cycling, gameplay-impact confirmation, fail-open fallback, and read-only policy rows.

## 2.7.63

- Records Gold Encounter Tracker LOG PASS / MAP ordering FAIL from runtime testing.
- Documents Gen II map-order repair and New Bark starter-area visibility.
- Documents the new pre-commit Difficulty impact warning.

## 2.7.62

- Records Gold runtime PASS for No Buying/No Selling and FAIL for No Center Heal on 2.7.61.
- Documents the Gen II `special HealParty` service gate repair for Pokemon Centers and Mom's house.
- Adds the cross-generation semantic-seam Release Safety contract and preserves exact-edition runtime evidence requirements.

## 2.7.61

- Runtime UI geometry hardening: explicit header/body/detail/footer regions, safer row budgets, measured status rows, and footer isolation across Nuzlocke-owned utility screens.
- Compatibility hardening follows Gen1Recomp stable UI/widget, game-input, and screen-stack contracts.
- Randomizer diagnostics no longer call a nonexistent global `projectionState`.

## 2.7.60

Pre-test startup hardening: presentation-only World Building source/catalog checks remain visible to diagnostics and Release Safety but no longer abort module initialization. Gameplay-critical invariant gates are unchanged.


- **2.7.59 startup recovery:** the 104-key World Building catalog currently hashes to `513036232`; the older `926265119` golden had become stale after later presentation-text evolution. Startup no longer hard-asserts on presentation-only catalog drift; Dev/Release Safety still audit it.
## 2.7.57

- Documents provider-neutral typography metrics, semantic row/notice primitives, five-page UI Gallery coverage, and corrected immediate-parent provenance for the UI lineage.
- Records compatibility hardening for variable-width/kerning font providers without adding a font-provider dependency.

# Documentation Changelog — 2.7.57

- Marks this build as a UI architecture build descending from exact 2.7.54.
- Documents the shared Nuzlocke-owned presentation boundary and five-edition UI target.
- Records that compatibility work concerns coexistence with alternative UI renderers; gameplay authority remains inside Nuzlocke/host semantic seams rather than presentation paths.
- Preserves the distinction between Static/Semantic evidence and Runtime PASS.

- Records external-save reconciliation regression coverage and forward-local-reference Release Safety linting.
- Records repaired exact 2.7.53 immediate-parent provenance.
- No player-facing rule or Randomizer seeded-contract change.

# 2.7.53 documentation update

- Documents Safari Clause replacing the old binary Safari Splits presentation.
- Records save-compatible 0/1 semantics and new until-catch modes 2/3.

Documents Phase J #10 seed reproducibility certification and #11 release-safety/documentation reconciliation. Final runtime certification remains Phase J #12.

## 2.7.51
- Documented Phase J #7–9 non-runtime Randomizer certification.

## 2.7.50

- Documented Randomizer Phase J #1–3 non-runtime certification surfaces.
- Recorded the Silver Field Item ALLOW exact-edition namespace repair and compatibility policy preserving Gold and existing persisted mappings.
- Runtime exact-edition certification remains deferred.

## 2.7.48
- Documented Randomizer Phase I #10-12: mid-run mutation policy, reproducibility report, and whole-Randomizer regression harness.

## 2.7.47
- Documented Phase I #7–9 unified spoiler policy, provider ownership hardening, and Setup preset integration.

# 2.7.46
- Documents Randomizer Phase I #4–6: compatibility matrix, seed sharing/import presentation, and deterministic subsystem version reporting.

# 2.7.45

- Documents Randomizer Phase I #1–3: unified presets, subsystem ownership/delegation, and shared Species Pool semantics.

# Documentation Changelog — 2.7.44

## 2.7.44
- Documents Randomizer Phase H #10–12: native Gold/Silver Pack/item-PC transfer ownership, Shop/TM/Gift Randomizer Info coverage, and the economy/progression regression audit.

# Documentation Changelog — 2.7.43

## 2.7.43
- Document Phase H #7–9 implementation and interaction ownership.

# Documentation Changelog — 2.7.43

## 2.7.43
- Documents Randomizer Phase H #4–6: TM contents, TM compatibility policy, and ordinary scripted gift-item randomization with progression/HM/TM transaction protections.

# 2.7.41
- Documents Randomizer Phase H #1–3: ordinary Mart stock randomization, semantic/price-tier shop balancing, native-price economy safety, and explicit preservation of TMs/key/HM/Bargain custom-price rows.

# 2.7.39
- Documents Randomizer Phase G #7–9: split-evolution distinctness and immutable evolution method/trigger metadata, including Gen2 time/stat-specific conditions.

# 2.7.38
- Documents Randomizer Phase G #4–6: cycle prevention, Evolution Balance DEPTH/SIM BST/BALANCED, and the corrected evolution-only setup/status visibility.
- Records Phase G #1–6 implemented with #7–12 pending.

## 2.7.37

- Documents Randomizer Phase G #1–3 and the new Random Evolutions rule/EVOLUTIONS deterministic stream.
- Records Phase F #1–11 complete with #12 deferred and Phase G #4–12 pending.

- 2.7.35: Documented Trainer Randomizer Phase F #7–9 diversity, type cohesion, team-policy namespace isolation, and rival starter synchronization.
- 2.7.34: Documented Trainer Randomizer Phase F #4–6 hard species-pool legality, Trainer Balance modes, 2.7.33 CHAOS namespace preservation, and the current F→J roadmap state.
- 2.7.32: Documented Gold above/below help orientation, exact line-scroll position semantics, and the shared rule-feedback language contract for mechanical blocks, state explanations, World Building, critical/T0 feedback, configuration descriptions, and provider fallback presentation.
- 2.7.31: Documented Gold Select-alone description paging, `SEL:MORE`/`SEL:TOP` hints, four-line native geometry, and corrected the exact 2.7.28 Gold title runtime-evidence status.
- 2.7.28: Documented confirmed Gen2 late-runtime/title failure, Yellow control PASS, Gen2 final-list repair, and continued-game SETUP suppression contract.
- 2.7.27: Documented Phase E #4 move hard-safety, #5 type-aware soft weighting, #6 damaging/status soft balance, `lp2` learnset policy migration, and remaining #7–12 scope.
- 2.7.25: Promoted the audited 2.7.24 documentation set to the 2.7.x release build and replaced checkpoint wording with release wording; no gameplay/API documentation contract changed.
- 2.7.24: Performed a full shipped-document audit; restored README/API/Compatibility/User Guide to their current-state roles, removed duplicated release timelines from those documents, reconciled current transaction/Randomizer/Stadium/World Building context language, restored missing 2.7.17 history to CHANGELOG, source-audited Gen1Recomp 0.2.20, and documented the Run History baseline-normalization persistence hardening.
- 2.7.23: Documented `Registry.describe(game)` exact-context Randomizer ownership and its regression audit.
- 2.7.22: Documented Rare Candy transaction error pass-through and future-version protection for transaction journal mutators.
- 2.7.21: Documented critical World Building T0 feedback, pass-scoped encounter profiling, CHAOS zero-build behavior, and regression tripwires.
- 2.7.20: Documented valid Randomizer `disabled` projection state, learnset-only OPEN/BLIND status visibility, and Release Safety projection audit coverage.
- 2.7.19: Documented authoritative Stadium source precedence, importer-provider ambiguity/identity, and Release Safety Stadium API coverage.
- 2.7.18: Documented opaque acquisition decision tokens, ID+kind transaction receipt identity, and forward-compatible Run History public read errors.
- 2.7.17: Documented authoritative Run History dedupe queries, transactional league progression/history, checked E4 writes, and fail-closed Forgiveness death archival.
- 2.7.16: Documented Save Editor title-hook isolation, Gen 2 title adapter N/A contexts, and World Building visibility while Nuzlocke is OFF.
- 2.7.15: Documented Save Editor Battle Clause N/A state, direct transaction-version enforcement, and checked Permanent Rule Lock migration writes.
- 2.7.14: Documented future Run History fail-closed behavior, retained-event dedupe validation, and strict NZR6 payload/padding validation.
- 2.7.13: Documented World Building master-switch independence, safe cosmetic persistence, and disabled Randomizer N/A lifecycle state.
- 2.7.12: Documented stale Pokegear capability teardown, observable provider-registration health, and stronger Modern UI provider identity binding.
- 2.7.11: Documented acquisition begin/commit continuity, explicit decision handoff, importer-only Stadium origin detection, ambiguity handling, and exact-edition provenance.
- 2.7.10: Added the future 2.8.x zero-padded patch-numbering convention.
- 2.7.9: Documented mandatory post-perform transaction verification, checked Forgiveness/reward writes, and transaction-bound Run History reconciliation.
- 2.7.8: Documented N/A/PENDING feature-health preservation, Gen 2 aggregate-install N/A semantics, and Release Safety consistency validation.
- 2.7.7: Clarified required module-loading vs diagnostic reread policy and documented install-health/F. TOKEN normalization repairs.
- 2.7.5: Documented Modern UI/Pokegear lifecycle repairs, NZR6 decoding, fail-soft source diagnostics, and Run History audit alignment.
- 2.7.4: Documented crash-atomic Forgiveness/Gym token transactions and Run History sequence recovery.
- 2.7.3: Documented fail-closed progression-PC acquisition commit behavior and Stadium provenance/diagnostic corrections.
- 2.7.2: Documented classic status ownership/info fixes and dormant title/setup installer observability hardening.
- 2.7.1: Documented receipt-before-handler transaction recovery, fail-soft package-source audits, and full-inventory bare-installer audit coverage.
- 2.6.96: Restored role-specific first-line current-build headers and exactly one canonical current-version CHANGELOG heading after the 2.6.95 packaging drift.
- 2.6.95: Documented the Randomizer rival-sync diagnostic closure/order runtime repair.
- 2.6.94: Documented full-package Lua unpack compatibility audit coverage and detector self-tests.
- 2.6.93: Documented the World Building catalog golden refresh from 97 to 104 keys, 1560 exact-edition-tier surfaces, checksum 926265119, and explicit missing/unexpected-key drift diagnostics.
- 2.6.91: Documented Stadium / Crystal 251 presentation/importer detection, exact-edition preservation, and explicit-only `STADIUM PRIZE` provenance API v2.

## 2.6.91
- Documented shared three-field Random Learnset ownership projection.
- Documented durable Rare Candy native-effect recovery checkpoint and fail-closed ambiguous-state handling.
- Documented versioned monotonic Rare Candy transaction IDs and new Release Safety identity/self-tests.
- Randomizer roadmap remains paused after Phase D; public API/schema versions are unchanged.

## 2.6.90
- Added active-feature Item Randomizer coexistence for visible pickups (`overworld_items` on R/B/Y, `gold_ball_items` on Gold/Silver).
- Added generic `field_item_randomizer_provider` delegation alongside starter/encounter/learnset randomizer providers.
- Documented that install-only detection never delegates a randomizer without an active ownership signal.
- Added read-only starter/encounter/field-item/learnset ownership snapshot and DEV REPORT owner summary.
- Kept the Randomizer roadmap paused; no Phase E implementation began.

## 2.6.89
- Documented explicit `GEN1_FLAT` vs `GEN2_POCKETS` Field Item normalization over the shared `game.data.items` registry.
- Added nine-case cross-generation item-table audit coverage.
- Added spoiler-aware Field Item Randomizer Info and Compatibility API 32 `Registry.fieldItemDiagnostics(context)`.
- Documented zero-RNG / no-mapping-write Field Item information reads and BLIND item-choice suppression.
- Marked Phase D items 1–11 implementation/static complete; item 12 runtime/progression certification remains deferred.
- Recorded 2.6.89 as the intentional pause point for further randomizer implementation phases.

## 2.6.88
- Added Field Item Repeats (`ALLOW` / `DIVERSE` / `UNIQUE`).
- Documented deterministic native source-ordinal permutation and degraded nonnumeric-provider fallback.
- Documented separate repeat-policy mapping rows with ALLOW preserving 2.6.87 behavior.
- Formalized visible-vs-hidden Field Item ownership; explicit hidden/BG-event sources remain untouched.
- Added five-case Field Item placement/ownership diagnostics.
- Marked Phase D items 7–9 implementation/static complete.

## 2.6.87
- Added semantic Field Item categories and utility tiers.
- Added source/provider allowed/forbidden category hard constraints.
- Added Field Item Balance (`CHAOS` / `CATEGORY` / `BALANCED`) with CHAOS preserving 2.6.86 behavior.
- Added 11-case Field Item semantic/category diagnostics.
- Marked Phase D items 4–6 implementation/static complete.

## 2.6.86
- Documented Field Item migration onto the shared hard-safety candidate engine.
- Documented permanent `FIELD_ITEM:v1:<edition>:<source>` persistence identity separated from the preserved historical Randomizer-v1 RNG input.
- Documented authoritative key/HM/progression/story/quest/provider-protection classification.
- Recorded seven-case Field Item foundation diagnostic evidence with runtime confirmation deferred.
- Marked Phase D items 1–3 implementation/static complete.

## 2.6.85
- Documented Area Split/logical tracker projection as separate from physical Random Encounter source/RNG identity.
- Added Gold Time/Headbutt to the live encounter-area reprojection/invalidation contract.
- Documented spoiler-aware encounter Randomizer Info, source/class/time/group/candidate/protection/split/mapping/fallback metadata, and zero-RNG/zero-mapping-write reads.
- Recorded Compatibility API 31 `Registry.encounterDiagnostics(context)` and the augmented `encounterInformation(context)` payload.
- Recorded the live Encounter Repeats/Diversity Strength reapply-list repair.
- Marked Phase C implementation complete through item 11 with exact-edition runtime certification deferred.

## 2.6.84
- Added Diversity Strength (`LIGHT` / `STANDARD` / `STRONG`) for DIVERSE encounter weighting.
- Documented explicit land/cave/Surf/fishing/Headbutt/Bug Contest/roamer and Gen 2 time-bucket classification.
- Documented fail-closed protected-source isolation for static/fixed/story/progression/quest/gift/trainer/roamer encounter records.
- Recorded STANDARD DIVERSE namespace preservation and LIGHT/STRONG encounter-policy suffixing.
- Added class/protection/diversity diagnostic evidence with runtime confirmation deferred.

## 2.6.83
- Added Encounter Repeats (`ALLOW` / `DIVERSE` / `UNIQUE`) and documented group-local soft diversity / without-replacement fallback.
- Documented strengthened SIM BST, EVO, and BALANCED progressive preference ladders.
- Documented native-level/evolution-family progression scoring and cycle-bounded lineage inspection.
- Recorded `CHAOS + ALLOW` 2.6.82 namespace preservation and encounter-policy `ep2` isolation.
- Added encounter policy diagnostic evidence with runtime confirmation deferred.

## 2.6.82
- Documented Random Encounter migration to shared semantic hard-safety and ordered balance preferences.
- Documented canonical encounter source identity separate from the preserved Randomizer v1 RNG semantic slot.
- Documented complete sorted encounter-plan generation and order-independence guarantees.
- Added encounter identity/order diagnostic evidence with runtime confirmation deferred.

## 2.6.81
- Documented deterministic pre-selection Starter Rerolls and permanent close after starter acceptance.
- Expanded Randomizer Info documentation to the spoiler-aware starter diagnostic surface.
- Recorded Compatibility API 30 starter-information registry additions.
- Documented the Yellow Cerulean Bulbasaur happiness-gate repair for non-Pikachu randomized opening starters.
- Marked Phase B #9-11 static/harness complete with runtime evidence deferred.

## 2.6.80
- Documented Starter Balance (`INDEPENDENT` / `BALANCED`) and Trio Typing (`OFF` / `AUTO`) in the Randomizer section.
- Documented that both are soft preferences beneath hard starter legality, Starter Style safety, and distinctness.
- Documented exact starter-position persistence and same-slate rival synchronization.
- Recorded default starter-slate v2 parity and active-preference v3 isolation from the global Randomizer v1 streams.

## 2.6.79
- Documented original merged evolution-lineage ownership for Starter Style classification.
- Documented persistent exact starter-position identity across Red/Blue, Yellow, Gold, and Silver.
- Documented same-slate rival starter-family synchronization and evolution-depth preservation.

## 2.6.78
- Documented Random Starter migration onto the shared hard-safety/soft-preference candidate engine.
- Documented atomic starter-slate generation and exhaustive distinct-assignment behavior.

## 2.6.77
- Documented deterministic without-replacement selection, encounter/learnset projection ownership, and bounded fallback diagnostics.

## 2.6.76
- Documented shared semantic candidate safety, progressive preference relaxation, and deterministic soft-diversity weighting.

## 2.6.75
- Randomizer improvements.


## 2.6.74
- Randomizer improvements.

## 2.6.73
- Updated all current-build headers and release summaries to the exact 2.6.73 <- 2.6.72 lineage.
- Documented the 21-section rule taxonomy, including HARDCORE, RUN / PARTY, CATCH RULES, BATTLE CLAUSES, SERVICES & ECONOMY, POKEMON STATS, QOL, QOL SETUP ONLY, and Dev Mode under UI.
- Documented that the IRONMON preset name is unchanged and that Save Rules plus encounter recovery/assignment remain separate utilities.
- Documented package-wide Release Safety coverage for the bare save-pause helper regression.

## 2.6.72

- Documents the no-underline tracked-bold DEV title treatment and corrected native up/down indicators.
- Documents grouped NUZ STATUS active/setup sections, clearer area/history labels, and Run History footer navigation.
- Documents Nuz Info move/stat readability and MOD COMPAT identity cleanup.
- Records the forward repair of stale executable release identity inherited from 2.6.71.

## 2.6.71

- Documents the DEV TOOLS storage-contract repair and clearer diagnostic action naming.
- Records the shared emphasized DEV page-title and corrected upper-scroll indicator treatment.
- Clarifies that lifecycle-pending hooks are informational unless they become genuinely missing/failed.
- Preserves the 2.6.70 NUZ STATUS Run History/ACTIVE RULES behavior.

## 2.6.70
- DEV TOOLS storage/known-issues pages now use live runtime identity and live diagnostic evidence.
- Remaining changelog UTF-8 Release Safety false positive is corrected.
- NUZ STATUS Run History and presentation follow-up are documented.

## 2.6.69
- Clarified DEV TOOLS run-vs-snapshot status and installer N/A/PENDING semantics.
- Normalized Release Safety documentation-header contracts.

## 2.6.68

- DEV REPORT navigation now separates Summary, Problems, Hooks, Rules, Randomizer, and Raw views.
- Dev storage export/reload calls use the documented callable API shape.
- Release Safety preset-diff diagnostics now receive the live production helper at construction time.

## 2.6.66
- Quarantined 2.6.65 after its Yellow Dev Report isolated a migration helper-scope failure.
- Qualified all remaining `saveWritePauseReason` runtime calls through the exported helper.
- Added Release Safety regression coverage for bare save-pause helper calls.
- Preserved the working save safe-stop and prior initialization compatibility repairs.

## 2.6.65
- Quarantined 2.6.64 after Yellow exposed missing `table.unpack`.
- Audited all shipped Lua unpack call sites and normalized them through `table.unpack or unpack`.
- Added Release Safety regression audit for direct/bare unpack calls.
- Retained the confirmed Dev initialization-order repair while rebuilding from exact 2.6.57.

## 2.6.64
- Quarantined 2.6.58–2.6.63 after Yellow runtime initialization failure.
- Recovered from exact 2.6.57 and ported reviewed later deltas.
- Moved `wrapperInterpositionHarness` registration after Dev initialization; diagnostic body unchanged.

## 2.6.63
- Raised World Building to a three-choice minimum for every rule/tier/region with independent exact-edition rotation state.
- Added persistent no-back-to-back dialogue cycling without gameplay RNG.
- Added contextual T3 run beats.
- Expanded the safely owned Pallet home TV to T1/T2/T3 rotations while retaining non-conflicting vanilla TV dialogue.

## 2.6.62
- Documented mandatory rule-explanation vs optional World Building flavor semantics.
- Added delivery-coverage auditing across high-risk R/B/Y and Gen2 enforcement surfaces.
- Added deterministic T3 dialogue-pool support without gameplay RNG consumption.

## 2.6.61
- Added three installation-scoped Saved Setup Preset slots per existing Setup profile scope.
- Presets use the supported public `mod.cache` facade, not engine internals or Pokémon save identity.
- Loads use bulk-change preview/confirmation and contain configuration only.

## 2.6.60
- Completed Install Health / Feature Health enrollment for remaining exported fail-soft installers without changing their lifecycle behavior.
- Added a Release Safety bare-installer-pcall regression audit.
- Recorded Gen1Recomp 0.2.19 mod-options API audit: option values are save-independent and shared across Gen1/Gen2 through `options.lua`, but the public runtime facade is read-only (`define`/`get`); arbitrary in-mod preset writes are not currently exposed through `mod.options`.

## 2.6.59
- Documented Rare Candy → current level cap QoL for R/B/Y and Gold/Silver.
- Clarified live-cap/provider authority, real-candy consumption, per-level move/evolution handling, and exactly-once transaction recovery.
- No save-schema, compatibility-API, or package-tree change.

# 2.6.59 — wrapper interposition + Randomizer same-table provider hardening

Strict child of 2.6.57. Adds an actual isolated direct-wrapper interposition harness and changes owner-aware wrapper re-entry so a later external top-level wrapper is never clobbered. Resolves the Randomizer same-table late-provider mutation investigation by detecting content drift from Nuzlocke's last applied registry image and adopting the live provider-mutated table as the new authoritative snapshot before any restore/reapply. No save-schema/API/tree change. Static/Harness/Integrity PASS; runtime/provider-combination testing remains required.

# Documentation Changelog — 2.6.57

## 2.6.57 transaction / feature-health documentation

- Documented the gameplay transaction v1 exactly-once/reconciliation contract and its two optional bookkeeping keys.
- Replaced the narrow install-health API text with SafeInstall v2, Hook Registry v1, and Feature Health v1 semantics.
- Added the rule that CHAINED/interposed wrappers are diagnostic degradation rather than automatic incompatibility.
- Recorded that the transaction coordinator is infrastructure requiring per-feature proven reconciliation, not a blanket Runtime PASS or claim that every mutation is already atomic.

## 2.6.56 Gen1Recomp 0.2.19 compatibility certification

- Advanced all current-state document identities to 2.6.56 while preserving full release history in `CHANGELOG.md`.
- Updated engine compatibility documentation from audited 0.2.18 to audited 0.2.19 and recorded the 17-commit source-review result.
- Recorded preserved Gold/Silver Bill's PC wrapper seams, the future-use Gen 2 EXP announce capability, and exact 0.2.19 runtime-test debt without promoting static evidence to Runtime PASS.

## Prior documentation history — through 2.6.55

## 2.6.55 semantic coverage documentation

- API now documents the semantic enforcement coverage export and behavior-level regression audit.
- Compatibility distinguishes semantic operation coverage from mere hook presence.
- Feature Confidence treats the new suite as STATIC/HARNESS evidence rather than runtime evidence.
- README/USER_GUIDE remain current-state documents; no historical release timeline was reintroduced.

## 2.6.54 documentation architecture consolidation

The public documentation was reorganized by responsibility:

- `CHANGELOG.md` is now the sole full version-history archive.
- `README.md` describes the current mod, installation, support and documentation map.
- `RELEASE_NOTES.md` describes only the current release.
- `docs/USER_GUIDE.md` describes current behavior by topic instead of by release number.
- `docs/API.md` describes current public provider contracts and canonical vocabularies.
- `docs/COMPATIBILITY.md` describes current ownership/composition contracts.
- `docs/FEATURE_CONFIDENCE.md` separates player/runtime confidence from provider/API interoperability confidence.
- this file records meaningful documentation-structure/content changes rather than duplicating gameplay release history.

Release Safety now validates each document's role-specific exact current header instead of requiring every file to look like a changelog.

Historical gameplay/release information removed from duplicated README/USER_GUIDE/RELEASE_NOTES timelines remains preserved in `CHANGELOG.md`.

## 2.7.56

Documented logical-surface policy, responsive Gen 1 build coverage, centered child-flow continuity, Dev UI Gallery, and runtime-test-required status.

- 2.8.36 / 0.2.27 phase 1: documented R/B/Y `catch.nickname` migration, older-engine fallback, and palette-aware Gen II NUZ STATUS / Recover Catches Chrome surfaces.

## 2.9.18
- Documented END RUN / ABANDON RUN lifecycle behavior, NO-default destructive confirmation, durable-history-first commit order, progression-owned completion boundary, and Almanac final recap.


## 2.9.21
- Documented the new SPLIT Dupes Clause mode and its branch-aware ancestor/descendant semantics.


## 2.9.22
- Corrected public confidence/release documentation for the 2.9.21 SPLIT Dupes source-confirmed defects and 2.9.22 repair.
- Recorded Party Size Limit decision-trace completeness repair and Movement Assist enum normalization cleanup.

## 2.9.23
- Advanced Gen1Recomp source/documentation/launcher compatibility coverage through 0.2.38 and documented the launcher manifest/update/save-tooling boundaries.


## 2.9.24
- Formalized permanent upstream attribution: bryanthaboi for the original Nuzlocke mod/project baseline, masterwebx for the original Shiny Pokémon mod and its code/design lineage, and Stone696 for current Nuzlocke development/maintenance and the maintained Shiny Pokémon fork.
- Added prominent README credit and technical compatibility/provenance wording while distinguishing current reworked shiny architecture from original lineage.

- 2.9.27: Documented Compatibility API 37 semantic battle-roster/activity-state observations, Blackjack Corner 0.8.2 compatibility ownership, exact 2.9.26 parent provenance, and preserved Acquisition/Provenance API 1 as the sole cooperative pre-transaction acquisition authority.
