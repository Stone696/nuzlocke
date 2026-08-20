# 2.6.0

- Release build; strict child of 2.5.92. Parent package SHA-256: `f96d91ed036c48320af5e283cd290ff890a7406c483d3cfbe74783956453ef91`.
- Moved **PC-Only Catches / PC Catches** from CLAUSES to the first row of the **QOL** section. This is menu organization only; the existing `progression_pc_catches` key/default/save and enforcement semantics are unchanged.
- Recorded 2.5.92 runtime boot + DEV REPORT rendering as PASS before release promotion.
- Preserved Run History death-occurrence dedupe, migration shadow structural equality, Compatibility API 29, Save Schema 4, Diagnostics API 1, Run History API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0`.
- Gold/Silver exact-edition confidence remains evidence-separated; Silver Random Starter preview/award still requires its own runtime confirmation.

# 2.5.92

- Strict child of 2.5.91. Parent package SHA-256: `8395f11aea40b8faa795402d4abaee930c07d44adc554a60a78f45adbf204ee3`.
- Fixed Run History death-producer idempotency across the three authoritative death bridges: R/B/Y battle, R/B/Y field poison, and Gold/Silver battle.
- Added a persistent per-Pokémon `nuzlockeDeathSequence`, incremented exactly when a new authoritative death is committed and preserved through the F. TOKEN archive/revive snapshot.
- `RunHistory.recordDeath` now derives `death:<pokemonId>:<deathSequence>` when possible, preventing duplicate rows for the same death occurrence without suppressing a legitimate later death after revival.
- Run History API/storage remain v1; Save Schema remains 4; no gameplay rule or token semantics changed.

# 2.5.91

- Strict child of 2.5.90. Parent package SHA-256: `a7f8ba6a311de482dc277c317fb59876b63316b92d3f39ea01c8103462b58846`.
- Fixed migration shadow-store dry-run equality for table-valued keys: recursive structural comparison now replaces raw table reference comparison.
- Added regression coverage for unchanged flat/nested tables and genuine nested changes.
- Save Schema remains 4; migration transaction ordering and recovery semantics are unchanged.

# 2.5.90

- Strict child of 2.5.89. Parent package SHA-256: `ceb089f156ccf64e9f7012511a4b337fa02b984545abf77c2aaee9c8748678d0`.
- Extracted the static/version-aware vanilla Gift Pokémon and in-game Trade source catalogs plus their lookup/fallback helpers from `main.lua` into `acquisition_catalog.lua`.
- Preserved existing `mod.exports.__beta26.buildGiftLookup`, `buildTradeLookup`, and `deterministicSourceFallback` names and behavior.
- Existing `nuzlocke_compat.giftLocationFor`, `tradeLocationFor`, and deterministic-source aliases remain in `main.lua` and consume the same exported helpers.
- Acquisition transaction enforcement, special-area conflict checks, starter logic, encounter rules, saves, and gameplay hooks are unchanged.
- Added `acquisition_catalog.lua` to Release Safety package inventory.
- No API/schema version changes.

# 2.5.89

- Strict child of 2.5.88. Parent package SHA-256: `0cb9aab2138ea188ac0cb0779b3ede527e37663e8f533904f28bd39c7a1bcb31`.
- Extracted DEV REPORT / NZR6 diagnostic presentation and codec infrastructure from `main.lua` into new package-local `dev_report.lua`.
- Preserved NZR4/NZR5 decoding, NZR6 generation, error fingerprints, self-test text/export/reload behavior, `nuzlocke_dev` facade, and lifecycle diagnostic listeners.
- Live `currentGame` state is injected through a getter so the module does not capture stale lifecycle state.
- Added `dev_report.lua` to the Release Safety package inventory.
- No gameplay, save schema, Compatibility API, Diagnostics API, Run History API, Random Starter, encounter, F. TOKEN, or rule behavior changes.
- Runtime boot + DEV REPORT / report-code smoke test required.

# 2.5.88

- Cleaned up the classic R/B/Y MOD COMPAT detail panel: help text now uses two lines per detail page, leaving the bottom control/page indicator row unobstructed.
- Added session-only navigation memory for ENC TRACKER (tab + row), MOD COMPAT (selected row + scroll + detail page), and DEV REPORT/Dev Tools (menu cursor + report scroll).
- Preserved and centralized the existing semantic NUZ RULES/Setup cursor/scroll memory and collapsed-section memory.
- UI navigation/fold state is intentionally not gameplay save data and resets on a fresh process/mod reload.
- No gameplay logic, Save Schema, Compatibility API, Diagnostics API, Run History API, Mod API, or engine-range change.

# 2.5.87

- Reverted the 2.5.86 ENC TRACKER status-marker presentation experiment completely; tracker result rendering is restored to the exact 2.5.85 behavior.
- Returned graphical encounter-area status symbols to the backlog. Future implementation must use actual supported glyphs/icons; ASCII `O` must not be presented as a substitute for a caught/check symbol.
- Advanced Compatibility API **28 -> 29** with additive introspection only; `compatible_from = 10` remains unchanged.
- Added missing Gen1Recomp engine compatibility profiles for **0.2.12, 0.2.13, and 0.2.14**, so the active audited `0.2.14` profile now resolves to real metadata.
- Added `getEngineProfile()` and `getCompatibilitySummary()` plus normalized `getCapabilityVersion()` lookup.
- Added read-only provider inventory helpers (`listProviders`, `providerCount`, capability lookup aliases) to the Public Interop surface.
- Release Safety now asserts that the configured active engine profile actually exists, preventing audited-engine metadata from silently pointing at a missing profile again.
- Removed a duplicate `nuz_info` ownership declaration. No gameplay rules, saves, Run History, Random Starter behavior, or engine-range policy changed.

# 2.5.86

- Added compact encounter-area status markers to ENC TRACKER: `O CAUGHT`, `X FAILED`, `- OPEN`, `* SHINY`, and `X DEAD`.
- Retained explicit English status text beside every marker for accessibility and font portability.
- Unified the status formatter across classic R/B/Y, native Gold/Silver, and Modern UI tracker presentation paths.
- Presentation-only change; encounter legality/state, Tracker storage, F. TOKEN rerolls, Run History, and gameplay hooks are unchanged.

# 2.5.85

- Completed Run History v1's initial catch/death/F. TOKEN producer integration.
- Added the missing ordinary successful `pokemon.caught` bridge after tracker/area commit; starter/gift/trade/progression producers remain unchanged and identity-deduped.
- Audited the existing death bridges and preserved all three authoritative paths: R/B/Y battle, shared field poison, and Gold/Silver battle.
- Added `forgiveness.awarded` after a Gym Leader reward commits, with semantic Leader-key dedupe.
- Enriched committed `forgiveness.used` rows with the remaining token count and source.
- Run History API remains 1, storage version remains 1, Save Schema remains 4, Compatibility API remains 28, and Mod API remains 2.
- Static Lua parse and dedicated Run History/trainer-reward harnesses pass; exact-edition runtime producer verification remains required.

# 2.5.84 — 2026-08-20

- Strict child of 2.5.83 (`bdfbe315ebab9310f860bcbecf4e918bfa3b6a21041f91bd0cb736307e96cf35`).
- Fixed **RS-CACHE-DEDUP-001**: legacy unseeded Random Starter distinct-choice bookkeeping now counts only canonical bare starter-slot mirror entries.
- Scoped seed/style cache rows and internal marker rows no longer contaminate the unseeded `used` species set.
- Seeded Random Starter behavior, deterministic Gold/Silver starter slate, preview path, award transaction, save format, and Randomizer algorithm version are unchanged.
- Recorded **Gen1Recomp 0.2.14 exact-runtime PASS** from 2.5.83: mod boot/load and DEV REPORT rendering succeeded.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2, engine range `>=0.1.86 <2.0.0`, and player-package file set remain unchanged.

# 2.5.83 — 2026-08-20

- Strict child of 2.5.82; documentation/compatibility-audit pass only.
- Advanced `recompCompatAudited` from 0.2.13 to **0.2.14** after reviewing the published tag delta.
- Gen1Recomp 0.2.14 is three commits ahead of 0.2.13 and changes only Android release packaging and iOS app-repository metadata; no Nuzlocke-facing Runtime/Loader/Mod API/GameVersion/Gen 2 VM/world contract changed.
- Retained Mod API 2, Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, and engine range `>=0.1.86 <2.0.0`.
- No gameplay hooks, rule behavior, Random Starter path, save migration logic, compatibility providers, or modularization boundaries changed.
- Carried forward 2.5.82 runtime PASS for normal boot and DEV REPORT rendering. A focused 0.2.14 boot smoke test remains required before marking the new audited engine exact-runtime PASS.

# 2.5.82 — 2026-08-20

- Strict child of 2.5.81 (`3d8cfaa0acaab7d55efd8324ef82f23f091a1f264f69ec7418dbc36bc9ac6fdf`).
- Extracted the 1,380-line Public Interop / Capability API block to new package-local `public_interop.lua`.
- Injected live current-game/current-save getters plus existing rule/area/delegation dependencies to preserve lifecycle semantics.
- Public provider, content, item, encounter, storage, EXP, registry, and auto-compat surfaces remain unchanged.
- `main.lua`: 37,138 -> 35,772 lines.
- Protected 2.5.81 runtime PASS: Setup/rule catalog still appears normal.
- Runtime test required for 2.5.82 boot and MOD COMPAT/provider smoke testing.

# 2.5.81 — 2026-08-20

- Strict child of 2.5.80 (`e6619127b579659a46221d1c7961a3e95dcbb0d3ba1b88a6f884e1c1943f8d0b`).
- Extracted the rule/settings catalog into new package-local `rule_catalog.lua`.
- Preserved canonical legendary/mythical/pseudo fallback sets, Stat EXP labels/values, Trainer Money labels, Maximum BST presets/helpers, rule keys/defaults/descriptions, and all existing consumers.
- Reduced `main.lua` from 37,417 to 37,138 lines (about 56 KB of catalog source moved out).
- Protected 2.5.80 Gold runtime PASS: mod boot/load succeeded on Gen1Recomp 0.2.13; Elm Random Starter portrait and awarded randomized starter worked.
- Silver Random Starter remains independently runtime-test-required.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` are unchanged.

# 2.5.80

- Repaired the Gen1Recomp 0.2.13 Mod Manager boot regression introduced by the first Release Safety gate: package/source introspection failures are warnings rather than fatal runtime assertions.
- Advanced the audited Gen1Recomp source marker to 0.2.13 while retaining Mod API 2 and the existing supported engine range.
- Began approved entry-file modularization with dedicated Run History, Release Safety, Dev assertion, and migration shadow-store modules.
- Added `stadium_provenance.lua` and the cooperative `nuzlocke_acquisition_provenance` API for `STADIUM PRIZE` metadata with optional Stadium 1/2 origin.
- Preserved 2.5.79's Johto Random Starter preview repair unchanged for runtime testing.

# 2.5.79 — 2026-08-20

## Johto Random Starter native preview repair

- Strict child of 2.5.78 (`3a0eb828e61ed37d772bd4d1d16e4b2d8a78999b07b93579a86203f70594c64e`).
- Preserved the existing deterministic Elm starter slate and working Gen 2 award transaction.
- Added a native `showPic`/`cry` fallback that can resolve Elm's randomized starter directly from the live Gen 2 game, Elm Lab map, empty-party state, and canonical starter species when the script-layer preview intent was not armed.
- The existing script-command intent remains the preferred path; generated script rows remain immutable.
- Added Dev health detail showing whether the latest Johto preview used `script_intent_*`, `native_fallback_*`, or vanilla presentation.
- R/B/Y Random Starter code is untouched. Blue 2.5.71 preview runtime PASS remains protected.
- Gold and Silver preview portrait/cry == awarded species remain **RUNTIME TEST REQUIRED** on 2.5.79.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2 and engine range `>=0.1.86 <2.0.0` are unchanged.

# 2.5.78 — 2026-08-20

## Save/migration integrity foundation

- Strict child of 2.5.77 (`0b222d009943f8ec0d11752242703163a2bc8d2aafdd013395531569bb6a0084`).
- Kept Save Schema 4 and all current rule semantics unchanged.
- Refactored numbered schema migrators to accept an explicit save-like store, allowing the same migration code to run against a shadow save before live mutation.
- Added deterministic dry-run planning through `previewPendingSchemaMigrations()`; dry-run reads/writes remain in memory and do not alter the live save.
- Added a versioned `__nuzlocke_schema_migration_txn` write-ahead journal recording each touched key's pre/post state.
- Live schema transitions now commit ordinary writes first, migration checkpoint second, and schema marker last.
- Added interrupted-transaction recovery: pre-commit interruption rolls back recorded values; post-schema-marker interruption completes cleanup rather than undoing a committed migration.
- Added a verified, bounded three-deep whole-save pre-migration snapshot rotation using Gen1Recomp's authoritative save filename/persistence filesystem; engine `.bak`/`.tmp` recovery files are left untouched.
- Failed live writes perform best-effort rollback and preserve the journal if rollback itself cannot complete.
- A migration/recovery failure now enters a distinct `migration_error` persistence pause: Nuzlocke-owned writes and rule enforcement stop until recovery succeeds, instead of continuing on uncertain state.
- Added `saveUpgrade.status()` plus structural save-migration integrity coverage in `releaseSafetyAudit()`.
- Save Schema descriptor now documents the optional migration-transaction bookkeeping field.
- Semantic/reconstruction/projection upgrade phases remain ordered but are not yet transactional; automated snapshot restore UI remains future work.
- Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2 and engine range `>=0.1.86 <2.0.0` are unchanged.

# 2.5.77 — 2026-08-20

## Release Safety Framework automation

- Strict child of 2.5.76 (`c0e62f8a71559ba4fa7d11de737fd8496d40f26175d5aa78f80e30da82310e7f`).
- Added a single machine-readable `releaseSafetyAudit()` aggregator over existing protected static contracts.
- Added `assertReleaseSafety()` and a boot-time release-safety gate so encoded invariant regressions fail fast instead of relying on manual review alone.
- Added Dev self-test visibility for aggregate release-safety PASS/WARN state.
- Initial automated coverage includes rule defaults/registry, Save Schema descriptor, dead-fallback lint, catalog snapshot, cross-table invariants, trainer-reward active guards, build provenance, Compatibility API capability-version coverage, and package-local source presence.
- The new gate is deliberately static/read-only and does not claim runtime gameplay confidence.
- No intended gameplay-rule, save-schema, randomizer, Run History, or compatibility-adapter behavior change.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2 and engine range `>=0.1.86 <2.0.0` are unchanged.

# 2.5.76 — 2026-08-20

## Public documentation hygiene only

- Strict child of 2.5.75 (`61f359114824ce117414ce330c0f9716883951b575b65eab81f47a477cf41283`).
- No intended gameplay, rule, hook, save, randomizer, Run History, compatibility-adapter, or custom-screen behavior change.
- Sanitized all player-package documentation so it contains durable release/technical facts only and does not expose transient internal-coordination provenance.
- Reworded historical documentation entries where necessary without changing their technical meaning or historical version attribution.
- Added a permanent project rule that public-facing documentation must never include internal coordination-source references.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2 and engine range `>=0.1.86 <2.0.0` are unchanged.

# 2.5.75 — 2026-08-20

## Process/review workflow consolidation only

- Strict child of 2.5.74 (`8a7bc811fb99f8cc2fadb4484c823c17ce82d5b1ef1d95ba6ce775e4a9cc7435`).
- No intended gameplay, rule, hook, save, randomizer, Run History, compatibility-adapter, or custom-screen behavior change.
- Formalized the recurring-session review checklist and vertical-slice review method.
- Added mandatory one-line risk statements and regression-protection proposals for fixes/features.
- Moved review earlier in the cadence: pre-ship audit is now part of normal DEV/release preparation.
- Formalized Open Questions, structured Bug & Investigation, Unreviewed Surface, and Cleared Investigation ledgers.
- Added a common severity rubric and evidence/status fields for findings.
- Added explicit review modes, review timeboxes, two-pass broad/deep review, stopping rules, and optional finding-only/fix separation for risky work.
- Added formal brainstorm intake/triage, versioned review summaries, regression retrospectives, and periodic cold-read reviews.
- Added a lightweight Definition of Done contract for each rule/feature so definition/default/applicability, persistence, enforcement, UI, guards, interactions, tests, docs and exact-edition confidence are checked deliberately.
- Process records remain in existing Project Rules/Handoff development artifacts; no player-package files were added.
- Gold/Silver Random Starter preview remains an open runtime defect; this build does not claim a repair.
- Run History v1 producer runtime validation remains open.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2 and engine range `>=0.1.86 <2.0.0` are unchanged.

# 2.5.74 — 2026-08-20

## Documentation / project-roadmap consolidation only

- Strict child of 2.5.73.
- **No intentional gameplay behavior change.** `main.lua` changes only build/manifest identity; gameplay logic, hooks, save schema, APIs, compatibility adapters and integrations are otherwise preserved.
- Consolidates the architecture/reliability suggestion ledger into a smaller set of master initiatives covering release safety, save/migration integrity, hook/provider health, deterministic RNG, transaction atomicity, diagnostics/support tooling, public API/format stability, modularization, localization/accessibility, engine contracts and release/process hygiene.
- Adds the latest ROM-hack-inspired feature investigations to the planned backlog without claiming implementation. Physical/Special Split and enforced Nickname Rule are recorded as already implemented rather than duplicated as new work.
- Records Blue 2.5.71 Random Starter pre-selection portraits as runtime PASS.
- Records Silver 2.5.73 Random Starter as **randomized award PASS / pre-selection portrait FAIL**; Gold/Silver native preview ownership remains an open defect and must not be described as fixed.
- Keeps Run History v1 as static/harness PASS only until catch/death/F. TOKEN producers receive exact-edition runtime evidence.
- Stable Gen1Recomp audit remains 0.2.12; Save Schema 4, Compatibility API 28, Diagnostics API 1 and engine range `>=0.1.86 <2.0.0` are unchanged.
- Updates project rules to require backlog retirement, exact-edition feature confidence, evidence-based external-feature attribution, and documentation-only build accounting.

# 2.5.73 — 2026-08-20

## Run History v1 architectural foundation + Gen1Recomp 0.2.12 audit

- Strict child of 2.5.72.
- Adds `run_history_v1`, a bounded append-only chronology journal kept separate from `tracker_log` and legacy `nuzlocke_history`; those existing structures retain their encounter/death projection responsibilities.
- Journal rows are flat scalar records with monotonic sequence IDs, exact edition, generation, build provenance and optional dedupe keys. Up to 512 recent rows are retained while lifetime summary counters remain cumulative. Fresh saves initialize full-coverage; already-progressed upgraded saves are marked partial and preserve baseline catch/death counters without fabricating old chronology.
- Wires the established catch transaction paths (ordinary/gift/starter/progression catches), R/B/Y + Gold/Silver Permadeath transaction paths, and F. TOKEN area-reopen/revive use into the journal.
- Catch dedupe uses persistent Pokémon identity. Deaths intentionally remain repeatable so a forgiven/revived Pokémon can later die again and create a second legitimate event.
- Adds `mod.exports.nuzlocke_run_history` API 1 with `list`, `report`, `record`, stable event-kind declarations and `nuzlocke.run_history` post-commit observation event. This is the shared backend planned for Graveyard, Almanac/Run Recap, Confessional, meta-run tracking and companion integrations.
- Adds Run History Dev integrity assertions for version, event cap, monotonic sequence ordering, scalar-only persistence, dedupe uniqueness, lifetime-counter shape and `next_seq` advancement.
- Does not add a player-facing Run History screen yet and does not replace/migrate the existing Tracker or legacy history. Save Schema remains 4.
- Advances `recompCompatAudited` to Gen1Recomp **0.2.12** after reviewing the 15-commit 0.2.11→0.2.12 delta. No Runtime/Loader/Gen 2 VM/GameVersion/mod-API signature change requires adapter work; engine range remains `>=0.1.86 <2.0.0`.
- Preserves 2.5.72 Gold/Silver Random Starter native-preview repair unchanged; runtime verification of that repair remains required.

# 2.5.72 — 2026-08-20

## Gold/Silver Random Starter native preview ownership repair

- Strict child of 2.5.71.
- Gold 2.5.71 runtime evidence showed the actual awarded starter remained genuinely randomized, but Elm's three pre-selection Poké Ball pictures still displayed the vanilla Johto starters. Record 2.5.71 as **RUNTIME PASS for non-vanilla award / RUNTIME FAIL for native preview presentation**.
- Moves Gen 2 starter preview substitution to the actual Gen1Recomp 0.2.11 VM presentation owners: the copied per-VM `hooks.showPic` and `hooks.cry` callbacks. The `script.command` layer now only detects the exact Elm `pokepic`/`cry` context and arms a one-command private presentation intent; generated script rows remain untouched.
- The native `showPic` acknowledgement records which randomized species was actually presented. The selected Elm `givepoke` transaction prefers that acknowledged species, preserving the 2.5.70 pool repair and 2.5.71 private award transaction without a second randomizer decision.
- Tightens `opening_starter_preview_award_parity`: an intended preview can no longer produce a false PASS. After a committed randomized starter, the check requires a native-render acknowledgement and exact preview == award identity.
- Preserves deterministic three-ball slate/seed/style behavior, challenge filters, native GivePoke construction/nickname flow, and vanilla Ball/rival story ownership.
- Runtime TEST REQUIRED on Gold and Silver: each Elm Ball picture/cry should match its randomized candidate; select a non-vanilla preview and verify the received Pokémon matches exactly.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, NZR6 and engine range remain unchanged.

# 2.5.71 — 2026-08-20

## Gold/Silver Random Starter preview-to-award synchronization repair

- Strict child of 2.5.70.
- Records Gold 2.5.70 runtime evidence: the candidate-pool repair worked (a non-vanilla Smoochum was actually awarded), but the selected Ball preview showed Cyndaquil. Actual randomization therefore works while preview -> award identity remained a runtime FAIL.
- Root cause: Elm preview and final `givepoke` could resolve the same deterministic slate through different `mod.save` backings during early NEW GAME adoption, allowing the grant-side lookup to rebuild a different slate after the player had already seen the preview.
- Each Gen 2 VM now remembers the exact displayed randomized species per vanilla Elm Ball in private transaction state. The matching `givepoke` consumes that recorded choice; an armed preview intent is never rerolled at the native grant seam.
- Adds Dev self-test row `opening_starter_preview_award_parity`, backed by the selected preview and actual committed award, so a future mismatch is reportable instead of silently hidden by the final commit.
- Keeps 2.5.70's generation-correct Gen 2 candidate validation, deterministic slate, Starter Style/seed behavior, native GivePoke ownership, story/rival Ball branch, nickname flow, challenge filters and no shared generated-script mutation.
- Runtime TEST REQUIRED on Gold and Silver: preview a non-vanilla species, select that exact Ball, and verify the received Pokemon matches the preview. Fixed seed + unchanged settings must reproduce the same three-ball slate.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, NZR6 and engine range remain unchanged.

# 2.5.70 — 2026-08-20

## Gold/Silver Random Starter candidate-pool parity repair

- Strict child of 2.5.69.
- Gold 2.5.69 runtime evidence showed all three Elm choices remained the vanilla Johto trio despite Random Starter being ON.
- Historical comparison found the older working Gold candidate pool accepted the live Gen 2 registry, while the modern safety gate accidentally required Gen 1-only `level1Moves`/`learnset` fields.
- Gen 2 candidate validation now follows Gen1Recomp 0.2.11's `src.battle.gen2.Mon` contract (`baseStats`, `growthRate`, `types`, `levelMoves`) while R/B/Y retain the Gen 1 safety path.
- Gold 2.5.70 runtime proved actual non-vanilla substitution is restored (Smoochum awarded), but also exposed preview -> award desynchronization, which is repaired in 2.5.71.

# 2.5.69 — 2026-08-20

## Gold/Silver Random Starter grant-path repair

- Strict child of 2.5.68.
- Carries the exact live Gen 2 `ctx.game` from Elm's identified `givepoke` command into the private one-shot starter intent consumed by the `Vm.new` / `hooks.givePoke` transaction wrapper.
- The concrete grant no longer depends on rediscovering `currentGame` during early NEW GAME, where the global can still be nil/stale and silently leave the vanilla species operand unchanged.
- Keeps the selected vanilla Ball/story/rival branch intact; only the species index passed into native GivePoke is substituted. Native construction, held item, Pokedex mutation, nickname flow, provenance and tracking remain engine-owned/composed as before.
- Registers Silver explicitly with the same Johto starter trio so edition-aware starter provenance/diagnostics never fall back to Red.
- Runtime TEST REQUIRED on both Gold and Silver with Random Starter ON. A fixed seed should repeat the same result and the actual received Pokemon must match the randomized preview for the selected Elm Ball.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, NZR6, and engine range are unchanged.

# 2.5.68 — 2026-08-20

## NUZ STATUS content/organization cleanup

- Keeps the established R/B/Y ListMenu and Gen 2 status-screen renderer/input lifecycle unchanged; this child changes status-row content only.
- Removes NEW GAME/setup-only resource/loadout rows from NUZ STATUS, including Starting Money/Balls/Candy and PC setup kits.
- Removes Gym Guide Rare Candy/service-state leakage and the redundant master `Nuzlocke ON` row from the active-rule list.
- Replaces R/B/Y raw Type Locke slot rows (`Type 2/3/4/5/6`) with one player-facing Type Locke summary matching the Gen 2 presentation.
- Shows the selected non-vanilla Difficulty by name, hides neutral Trainer Money 100%, and uses short player-facing rule names for generic rows where available.
- Uses `Loadout <name>` consistently across R/B/Y and Gold/Silver.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, engine range, and exact-edition NZR6 diagnostics are unchanged.
- Runtime retest required for NUZ STATUS content/layout on at least Yellow and Silver; protected renderer/input/runtime evidence is not intentionally changed.

# 2.5.67 — 2026-08-20

## Exact-edition diagnostics/UI + Silver status scope repair

- Records Yellow 2.5.66 manual recovery reassignment (Mankey → Route 1 → wild) as runtime PASS.
- Fixes the Silver NUZ STATUS failure caused by stale post-scope calls to `normalizeMovementAssistMode`; all post-scope callers now use the exported movement-assist normalizer.
- Adds exact-edition diagnostic identity (`red`, `blue`, `yellow`, `gold`, `silver`, `crystal`) to breadcrumbs, snapshots and self-test reports instead of collapsing them to `rby`/`gold`.
- Introduces NZR6 report codes with a 3-bit exact-edition field. Decoder remains backward-compatible with NZR4/NZR5. This lets future parity/feature-implementation graphs bucket evidence by exact game edition while generation still drives shared mechanics.
- NUZ RULES/STATUS headers identify the exact running edition; Gold and Silver no longer share a misleading GOLD BETA label, and R/B/Y identify themselves individually.
- Save Schema 4, Compatibility API 28, engine range and game targets are unchanged.

# 2.5.66 — 2026-08-20

## Silver NUZ STATUS containment + Yellow recovery reassignment hardening

- Records Silver 2.5.65 NEW GAME Setup and boot-to-bedroom as runtime PASS; NUZ STATUS as runtime FAIL/crash.
- Exception-contains the shared Gen 2 NUZ STATUS screen so a Gold/Silver status calculation failure renders a reportable in-screen error and can return safely instead of terminating the launcher.
- Hardens manual Encounter Tracker recovery assignment transactionally: the selected area must canonicalize to a non-empty string before table access, the recovered row is built off-table, and optional live-Pokemon identity/provenance enrichment can no longer abort an otherwise valid player-confirmed assignment.
- No Save Schema, Compatibility API, Diagnostics API, engine range, or declared-game-target change.
- Runtime retest required for Silver NUZ STATUS and Yellow Mankey → Route 1 → wild reassignment.

# 2.5.65 — 2026-08-20

## Silver beta enablement / Gold-engine parity foundation

- Declares Pokémon Silver as a beta-supported target on Gen1Recomp 0.2.11.
- Treats Gold and Silver as one Gen 2 engine family for title Setup and generation-specific adapters; the historical `runtimeIsGold` export name is retained for compatibility but now resolves the engine generation directly.
- Gives Silver its own persisted pre-game Setup profile so changing Silver Setup does not overwrite Gold's staged profile.
- Promotes the existing Silver GSC progression profile from groundwork to experimental/beta use.
- Extends Gold-family starter/source handling to Silver.
- Uses Silver's native first player-name preset (`SILVER`) and counterpart Rival default (`GOLD`) where Nuzlocke's automatic-name / Quick Start features bypass the native prompts.
- Keeps R/B/Y-only Gym Guide and Center adapters out of both Gen 2 editions.
- Crystal remains undeclared groundwork; no Crystal support claim is made.

Runtime parity remains TEST REQUIRED across Silver new game Setup, existing-save gating, starter/gift/capture/death rules, nickname flow, marts/healing, progression, Random Starter, Quick Start/default names, rules/status/tracker screens, and Dev diagnostics.

# 2.5.64 — 2026-08-20

- Yellow: canonicalize and validate Encounter Tracker recovery/reassignment area IDs before any save-table write.
- Harden compatibility relationship/provider lookups against incomplete nil metadata.
- R/B/Y: wrap and center Dev/Recovery error/report presentation to stay within the 160x144 native frame.
- Record Yellow 2.5.63 Dev RUN + VIEW REPORT as runtime PASS and the fresh NZR5 report as valid runtime diagnostics evidence.
- No save-schema, compatibility-API, diagnostics-API, or engine-range change.

# 2.5.63 — 2026-08-20

- Strict child of 2.5.62.
- Fixes Yellow Dev RUN / VIEW REPORT runtime error `attempt to call global 'reportCodeHash' (a nil value)` by exposing the scoped NZR5 fingerprint operation through the Dev API and using that exported operation from `selfTestText()`.
- Hardens compatibility relationship/provider inspection against missing capability metadata; nil capability now resolves to neutral compose semantics instead of raising `table index is nil`. This targets the exact Encounter Tracker recovery runtime failure reported at the old line 1157.
- No Save Schema, Compatibility API, Diagnostics API, engine range, or declared game-target change. Gen1Recomp 0.2.11 remains the stable audited marker.
- Runtime confirmation remains required for the three affected Yellow paths.

# 2.5.62

- Fixed Dev Tools storage-facade calls to match Gen1Recomp's playthrough-bound `mod.storage` API. This is the common root fix for RUN + SAVE and VIEW REPORT failures seen in Yellow runtime testing.
- Dev RUN/REPORT failures now remain inside the Dev Tools screen with immediate A/B recovery and an `NZERR-2.5.62-xxxxx` code instead of pushing a modal TextBox that can appear frozen.
- Encounter Tracker recovery/reassignment validation and unexpected errors now use an in-screen notice with A/B recovery instead of pushing a TextBox from the maintenance editor. Invalid/impossible combinations remain no-op and player-facing.
- Source-audited Gen1Recomp 0.2.11. Mod API 2 and the `<2.0.0` engine ceiling remain appropriate. Silver is now an engine version but is not yet a declared Nuzlocke target pending a dedicated parity pass.

# Nuzlocke 2.5.61 — 2026-08-20

- Strict child of 2.5.60; multi-fix scope explicitly authorized after Yellow 2.5.59 runtime crash reports.
- Hardens the legacy Encounter Tracker recovery/editor: stale entries and impossible area assignments are rejected before mutation with player-facing feedback; unexpected update/draw exceptions are contained and surfaced as `NZERR-2.5.61-xxxxx` report codes.
- Hardens Dev Mode **RUN + SAVE**: unexpected self-test/export exceptions return a structured failure and player-facing report code rather than escaping through the Dev Tools screen.
- Adds a compact deterministic Dev runtime error-code helper and records full tracebacks through existing Dev diagnostics where available.
- Source-audits published Gen1Recomp 0.2.10 and advances the stable audited marker from 0.2.7 to 0.2.10. Mod API remains 2; engine range remains `>=0.1.86 <2.0.0`.
- Corrects 2.5.60's stale embedded provenance in the new child: 2.5.61 correctly declares 2.5.60 and its canonical SHA as its immediate parent. The old 2.5.60 artifact is not rewritten.
- Runtime confirmation remains required for both reported crash paths and for the 0.2.10 smoke test.

# Nuzlocke 2.5.60

2.5.60 is a strict child of 2.5.59 and completes the planned **Phase B catalog golden/snapshot backstop**.

This build adds a deterministic semantic snapshot of every `worldRuleCatalog` row. The audit sorts all 96 catalog keys and snapshots each key plus its T1, T2, Kanto, and Johto text, representing 576 tier/region resolutions. Missing rows/fields, renamed keys, or unintended dialogue changes now fail fast; comments and source formatting do not affect the snapshot. Dev assertions expose the same failure as `catalog_snapshot`.

No gameplay, save-schema, compatibility-API, diagnostics-API, UI, or engine-range behavior is intentionally changed.

## 2.5.59 — 2026-08-20

- Strict child of 2.5.58.
- Adds a fail-fast source-level lint for dead `worldRuleTriplet` / `worldRuleText` fallback arguments when the literal rule key already exists in `worldRuleCatalog`.
- Removes the existing unreachable fallback arguments for catalog-backed calls; because catalog text already won precedence, this is behavior-neutral cleanup.
- Mirrors lint failures into Dev assertions as `dead_fallback_lint`.
- Keeps Save Schema 4, Compatibility API 28, Diagnostics API 1, and the `>=0.1.86 <2.0.0` engine range unchanged.

## 2.5.58 — 2026-08-20

- Strict child of 2.5.57.
- Adds fail-fast cross-table invariant auditing for duplicated progression facts without changing gameplay behavior.
- Verifies GSC badge mappings point to real progression stages with the correct Johto/Kanto storage family and complete unique 1–8 badge-index coverage, while every R/B/Y profile has a gym-cap table with one cap per named Gym Leader.
- Mirrors invariant failures into Dev assertions as `cross_table_invariant` for diagnostic visibility.
- Keeps Save Schema 4, Compatibility API 28, Diagnostics API 1, and the `>=0.1.86 <2.0.0` engine range unchanged.

## 2.5.57 — 2026-08-20

- Phase B reliability hardening: added executable `active()`-guard contracts around the trainer-reward/progression subsystem.
- Gameplay-state mutators (`rememberWallet`, Trainer Money scaling, Gym Leader Forgiveness rewards) must retain the Nuzlocke enforcement guard.
- Intentional master-OFF persistence paths are explicitly classified instead of being silently treated as guard omissions: passive Gym/E4/Champion progression sync and Forgiveness Token inventory/save reconciliation.
- The trainer-reward module now fails installation if a contracted function disappears or loses its required guard; Dev assertions surface the same contract drift.
- No gameplay/UI/save-schema/API/engine-range changes.

## 2.5.56 — 2026-08-20

- **Phase B reliability / single-source rule registration, step 2.** Ordinary rule value coercion now derives from each authoritative `ruleCategories` record instead of maintaining independent numeric-key ladders in `getConfigValue()` and `setConfigValue()`.
- Numeric bounds, malformed-value fallbacks, and legacy boolean compatibility exceptions now live beside the rule default/range metadata they qualify.
- Preserves explicit non-ordinary semantics for Locke preset identity, legacy Level Cap migration, Area Guide state, external provider delegation, and dynamic difficulty-provider selection.
- Static parity harness matched 2.5.55 coercion semantics for all 40 numeric rules across 1,600 representative read/write cases.
- No intended gameplay/UI behavior, Save Schema 4, Compatibility API 28, Diagnostics API 1, engine range, NUZ STATUS behavior, or Gold Random Starter behavior changes.

## 2.5.55 — 2026-08-20

- **Phase B reliability foundation / single-source rule registration, step 1.** All 114 ordinary rule records now carry their canonical default directly beside their existing key/UI/range/generation metadata.
- `defaultRuleValue()` now resolves ordinary defaults from those authoritative rule records instead of maintaining a separate handwritten dispatch tree. Only non-row profile metadata (`locke_type`, Rule Lock mirrors) remains explicit.
- The existing machine-readable Rule Registry consumes the same records, so UI registration, default resolution, and descriptor tooling can no longer disagree merely because a default was added to only one path.
- No gameplay rule semantics, Save Schema 4, Compatibility API 28, Diagnostics API 1, engine range, protected F. TOKEN behavior, NUZ STATUS content, or Gold Random Starter logic intentionally changes.
- Static release gate: exact packaged Lua compile/load PASS; 41-extra-local sentinel PASS; 42-extra-local sentinel expected FAIL; 114/114 ordinary rule rows have explicit defaults.

## 2.5.54 — 2026-08-20

- Strict child of 2.5.53 (`c636576f001b9567403f95a9455c646fd1bb5577e66a9c729820b0af7f84af4b`).
- Behavior-preserving compiler-budget refactor only: scoped NZR5 codec helpers, town/loadout/movement/Gym Guide/reconciliation helper lifetimes, removed an unnecessary `effectiveToggle` outer alias, and moved low-fanout helpers behind one private helper namespace.
- Exact `main.lua` compile/load check passes. A 41-extra-local sentinel compiles and a 42-extra-local sentinel fails, measuring the legacy outer function at 159 active locals and restoring compliance with the project `<160` hard gate.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, gameplay behavior, NZR5 format, NUZ STATUS behavior, F. TOKEN behavior, and Gold Random Starter behavior are unchanged.

## 2.5.53

- Rebuilt directly from valid 2.5.51; rejected 2.5.52 is not a lineage parent.
- Dev Report codes now emit `NZR5`.
- Removed duplicate encoded health bits for hook health, lifecycle callbacks, safe-stop writes, rule effectiveness, and randomizer integrity; decode reconstructs them from the already-encoded authoritative counters/status.
- Legacy `NZR4` codes remain decodable and can still report internal inconsistency.
- No gameplay, NUZ STATUS, F. TOKEN, or Gold Random Starter behavior changes.

## 2.5.51

- Fixed one issue only: Gold Random Starter transaction identification.
- Preserved the transaction-safe `Vm.new` / `hooks.givePoke` grant path and deterministic three-ball slate.
- The exact Elm `givepoke` command now arms a private one-shot intent for that VM, allowing the native grant wrapper to substitute the selected randomized species even when save/party timing or another composed hook makes the old heuristic unreliable.
- The intent is consumed by one `givepoke` transaction and explicitly cleared if a lower hook swallows the command, preventing leakage into later gifts.
- Shared generated script rows remain unmodified; native Gold construction, nickname flow, story/rival branch, provenance, and tracking remain in place.
- Dev Report/NZR4 consistency work is intentionally deferred to the next build.
- Gold runtime validation required.

## 2.5.50

- **F. TOKEN area picker:** REROLL ENCOUNTER now lists any eligible FAILED encounter area from the authoritative tracker/projection state instead of requiring the player to stand in that area.
- **Tracker reroll action:** the selected FAILED row in ENC TRACKER exposes `A:REROLL` when Route Forgiveness is active and at least one F. TOKEN is owned; the same confirmation/spend function is used by both entry points.
- **Explicit spend confirmation:** the confirmation page names the target area, begins with no YES/NO selection, ignores A until the player deliberately chooses, and B cancels without spending.
- Preserves the Yellow 2.5.49 runtime-PASS reroll mechanics and post-reroll catch attribution.
- Audited the `DUPE:FREE` battle badge: it belongs to the independent Encounter Indicator feature, not the retired F. TOKEN implementation, so no legacy F. TOKEN battle hook was removed.
- Strict child of 2.5.49. Parent package SHA-256: `5bdefcb4c707504830a438b4fe0ae05856625216ab1ea84ddbc5c8d1120e59e5`.

## 2.5.49

- **F. TOKEN native selection cursor:** R/B/Y spend and revive selectors now use the engine's native `Theme.cursor` glyph via `Font.drawCode`, matching the already-working Nuzlocke list/menu pages. Up/Down selection mechanics are unchanged; the active row is now visibly marked with the native sideways arrow.
- Preserves the runtime-confirmed 2.5.48 full-page F. TOKEN layout and does not change forgiveness spending/revival mechanics. Gold keeps its native Chrome cursor path.

## 2.5.48

- **R/B/Y F. TOKEN full-page UI repair:** replaced the broken pixel-style `Font.drawBox(8,10,18,15)` / revive equivalent with the same full 20x18 tile-page pattern already used by runtime-confirmed Nuzlocke screens. The prior coordinates were tile coordinates, which is why the selector rendered in the lower-right.
- **Gym Guide Rare Candy dialogue pacing:** Nuzlocke-added Yellow/R/B/Y Gym Guide messages now contain explicit page breaks and remain blocking through `Commands.show_text`; the quantity selector cannot open until the dialogue pages are acknowledged with A/B.
- Gold F. TOKEN Chrome rendering and unrelated runtime-PASS rule gates are unchanged.

## 2.5.47
- Strict child of 2.5.46. Parent package SHA-256: `4c007d86566709fcf990e09787a8c16c31c7f06b31e86f62b033c5042d038223`.
- Fixes the runtime-confirmed R/B/Y / Yellow F. TOKEN presentation failure by closing the live Bag/use list before the custom forgiveness selector takes over the screen. This matches vanilla full-screen field-item transitions and prevents the native USE POKEMON/item UI from remaining composited underneath.
- Registers both F. TOKEN screens in Nuzlocke's shared presentation contract and attaches `nuzlockeUi` metadata, instead of relying only on ad-hoc classic-layout flags.
- Gold keeps its separate Pack/Chrome route unchanged. Save Schema, Compatibility API, Diagnostics API, engine range, and package file set are unchanged.

## 2.5.46

- Fixed the runtime-confirmed Gold Dev Mode visibility failure. Turning Dev Mode ON/OFF in NUZ RULES now refreshes the already-open underlying Gold START menu immediately instead of waiting for a later menu reconstruction.
- Dev diagnostics now read `dev_mode` through the same live configuration accessor used by NUZ RULES, with the direct save read retained only as a defensive fallback.
- The Gold START-menu refresh owns only Nuzlocke's marked DEV row; native and other-mod rows are preserved, and the normal `ui.start_menu.items` hook remains authoritative on later menu openings.
- Runtime Gold validation required: ON -> DEV appears immediately, OFF -> DEV disappears immediately, reopen persistence, save/reload persistence, and no duplicate DEV rows.

## 2.5.45
- Fixes the runtime-confirmed R/B/Y F. TOKEN menu corruption/overlap by giving both forgiveness screens the same protected native 160x144 classic-layout ownership used by stabilized Nuzlocke screens.
- Adds explicit screen identity/presentation ownership metadata for the F. TOKEN action and revival selectors so wide/modern UI integrations cannot resize or partially composite them over the native item-use screen.
- Gold keeps its separate native Gen 2 Chrome rendering path. No F. TOKEN mechanics, Save Schema, Compatibility API, Diagnostics API, engine range, or package-file-set changes.

## 2.5.44

- Strict child of 2.5.43. Parent package SHA-256: `f64d044ad904e682ba05d9439e35200e4bbba2cfb5cef1d3f3137756ae0a0eb6`.
- Hardens NZR4 so redundant result bits for hook health, lifecycle callbacks, safe-stop writes, rule effectiveness, and randomizer integrity are derived from the same structured evidence encoded later in the payload; internally contradictory new codes are no longer emitted.
- `decode_report_code()` now returns `consistent` and per-section `consistency` flags, allowing legacy/copied contradictory NZR4 values to be identified explicitly.
- Rebalances on-screen NZR4 hyphen groups across Dev Report rows so the final checksum fragment is not orphaned on its own line.
- Repairs embedded build provenance to point to the actual immediate parent 2.5.43 and its exact SHA-256 rather than the stale 2.5.41 metadata inherited through 2.5.42/2.5.43.
- NZR4 bit layout/prefix, Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, and 15-file package structure are unchanged. Runtime Dev Report layout confirmation required.

## 2.5.43

- Strict child of 2.5.42.
- Fixes the 2.5.42 Gold battle-rule pager so it never clears `BattleState.queue` and never calls `advanceQueue()` for a Nuzlocke-owned overlay message.
- Snapshots/restores the exact pre-dialogue `phase`, `message`, and `messageTimer`, preserving queued vanilla and compatibility-mod actions/messages.
- Adds defensive active-game/mod input fallback without auto-advancing Nuzlocke text.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, and 15-file package structure remain unchanged. Runtime validation required.

## 2.5.42

- Strict child of 2.5.41.
- Establishes the gameplay-text UX rule that Nuzlocke-authored interruptions/denials must remain until A/B and multi-page text must require A/B between pages.
- Gold battle-rule denials now use a Nuzlocke-owned 18-column/two-line paginator rather than direct `self.message` + `messageTimer` assumptions. Covers blocked battle items, No Catching, illegal catch/encounter refusals, and Encounter Ball Limit exhaustion.
- R/B/Y blocking `TextBox` and battle queue pagination paths are preserved.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, and 15-file package structure remain unchanged. Runtime validation required.

## 2.5.41

- Strict child of 2.5.40. Parent package SHA-256: `dcd4f5593c265f5b3a77432e26bd19b7f167feafbb4b2a054437812f60336ecd`.
- Adopts numeric-only build/release titles: no DEV or RC suffixes from this version forward.
- Fixes F. TOKEN revival when a compatible system retains a dead Pokemon in an active party that is now above a lowered Party Size Limit: revival relocates that Pokemon to legal PC storage before reactivation, or refuses without spending if storage is full/unavailable.
- Hardens Trade Evolutions to Gen1Recomp's supported `evolution.check` contract: the level-40 QoL path and Gold competing-branch suppression now require `trigger.kind == "levelup"` and do not act on link/item/forced/other contexts.
- Clarifies Route Forgiveness + Area Splits semantics: spending a token forgives the current logical encounter slot as configured; all FAILED physical rows merged into that slot are cleared deliberately so split reprojection cannot recreate the failure.
- Synchronizes README/CHANGELOG/RELEASE_NOTES and current documentation with the 2.5.40 F. TOKEN rework and 2.5.41 repairs.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, and 15-file package structure remain unchanged. Runtime validation required.

## 2.5.40

- Reworked Route Forgiveness into a real player-carried F. TOKEN item rather than synthetic Mart stock/automatic spending.
- F. TOKEN can manually reopen the current FAILED encounter slot or revive an exact Permadeath archive snapshot at half HP with party/PC-safe placement.
- Tokens cannot be bought, sold, tossed, or given; legacy unspent token counts migrate to inventory-backed state.
- Exact revival is available only for deaths with a full archived Pokemon record; older summary-only history is not fabricated.
- Runtime validation required.

## 2.5.39+DEV

- Strict child of 2.5.38+DEV. Parent package SHA-256: `341319ab54d9c4a1ed288090c76d81725989e8a4873b0539a7133daca329fed3`.
- Adds **Trade Evolutions** under QOL, default OFF, for Red/Blue/Yellow and Gold.
- With Trade Evolutions ON, ordinary trade evolutions become eligible on the next level-up at **level 40+**. Native link trades remain valid and can still evolve at their original timing.
- Gold trade-with-held-item evolutions require the original held item at level 40+ and consume it on successful evolution. While that branch item is held, a competing native level evolution is suppressed so branches such as **Slowpoke -> Slowking** remain reachable; removing the item restores the native branch immediately. Everstone remains authoritative.
- The shared evolution-limit hook is hardened for Gold's hook payload/data shape and Gold's `into` evolution target field so **Evolution Limits** compose with the new QoL instead of silently failing open on Gold. NO FINAL / NO EVOLUTION remain challenge-owned and can still block the QoL evolution.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` unchanged. Runtime R/B/Y + Gold evolution validation required.

## 2.5.37-DEV

- Strict child of 2.5.36-DEV. Parent package SHA-256: `730f87424f8a4ebf926b6b570730a696394bed6ba2c42adc0453834972c5307b`.
- Bug-only repair pass; no new gameplay features.
- **Random Field Items:** fixes HM protection to recognize Gen1Recomp's canonical `HM_<MOVE>` ids and `machine.kind = HM` metadata. Gold's visible **HM07 WATERFALL** Ice Path pickup and all other HMs now stay authored/vanilla and are excluded from the replacement pool.
- **Gold sparse PC storage:** replaces dense `ipairs(save.boxes)` assumptions with one stable sparse-safe box traversal across Whiteout recovery, PC-Only Catch detection, legacy/provenance reconstruction, and gift/starter ownership scans. A legal reserve in a later materialized Gold box can no longer be skipped because an earlier box table is absent.
- **PC-Only Catches:** remembers the legal pre-throw filing target and uses post-catch storage policy when a catch grows the party from 5 to 6. A full current Gold box no longer strands a permanent PC-only catch in the active party when another box has room; the permanent lock marker is applied only after the mon is confirmed in storage.
- **Rule Lock:** Gold **Radio Nuzlocke** remains adjustable with the other World Building/QoL/presentation controls while challenge rules are locked.
- **Loadout text:** SOLO now describes its actual `Whiteout OFF` behavior as **run-ending Blackout** instead of the stale “Whiteout” wording.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` unchanged. Gold HM pickup, sparse-box Whiteout, PC-only 5->6 filing, Radio Nuzlocke Rule Lock, and SOLO description are runtime TEST REQUIRED.

## 2.5.36-DEV

- Strict child of 2.5.35-DEV. Parent package SHA-256: `f8540105bf2fc481aded340003df29b7c0adfd18311c8bcfd0b51bcc7750bcbf`.
- Compatibility/documentation-only pass; no gameplay behavior changes.
- Re-audited current Gen1Recomp `dev` head **`def270f7c726ebd7bd87086ad90bc4a7b9622543`** while retaining **0.2.7** as the stable published `recompCompatAudited` marker. Mod API 2, engine save format 4, ROM cache v5, and Nuzlocke's `>=0.1.86 <2.0.0` engine range remain valid.
- Confirmed Gold's official read-only BattleAPI now exposes Ball inventory and exact stock catch previews; Nuzlocke's existing optional BattleAPI bridge consumes the addition without changing capture enforcement ownership.
- Confirmed Gold battle-party grid navigation now uses the shared `ui.party.grid_navigation` hook; Nuzlocke continues to leave that presentation/input seam unowned.
- Reviewed Android in-process game switching: upstream resets Runtime hook/event buses before booting another game. Nuzlocke owner-aware wrappers are source-consistent, but Red/Yellow -> launcher -> Gold -> launcher -> Red/Yellow remains runtime TEST REQUIRED.
- Corrected stale compatibility-ledger/current-target text that still called 0.2.1 the current audited engine. Historical 0.2.1 notes remain intact as history.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, and Mod API 2 unchanged.

## 2.5.35-DEV

- Strict child of 2.5.34-DEV. Parent package SHA-256: `d5cb2b305cdcf460b5ff7f4110185719742caa5360d21994fe943d2546d37d54`.
- Bug-only repair pass; no new gameplay features.
- Gold Random Starter: stops the `script.command` gift tracker from mutating the VM's shared Elm `givepoke` command/operand tables. The 2.5.30 `Vm.new`/`hooks.givePoke` transaction wrapper is now the sole owner of concrete starter substitution.
- Gold Random Starter: fixes scoped three-ball slate cache identity. Species-id keys remain normalized, while opaque `GOLD_STARTER_SLATE:v1:s...:style...` keys retain their authored case; legacy uppercase scoped keys are canonicalized on read.
- QoL Rule Lock: Unlimited Bag Space now remains adjustable after challenge-rule locking, matching Running Shoes, Fast Surf, World Building, Difficulty, and the other QoL/presentation controls.
- Save Schema / Compatibility API / Diagnostics API unchanged. Runtime validation remains required for Gold Random Starter across repeated New Games in one process and for Rule Lock + Unlimited Bag Space.

## 2.5.34-DEV

- Strict child of 2.5.33-DEV. Parent package SHA-256: `9a6858e7c00207c65ec980edea5877c754224357ca33e059e50e7f7f49f3a45a`.
- Adds default-OFF **Unlimited Bag Space** under QoL for R/B/Y + Gold.
- R/B/Y removes the normal Bag's distinct-item slot ceiling while enabled. Gold expands only the ordinary ITEM and BALL pockets; KEY ITEM/TM-HM capacities remain native.
- Preserves the engine's 99-per-item stack cap, PC item storage, item legality/use rules, scripted acquisition behavior, ordering, tossing, and selling.
- OFF delegates to the live underlying `Bag.capacity` answer so engine changes or compatible bag-size providers are restored rather than replaced with a hard-coded vanilla value. Existing over-capacity contents are never deleted.
- Adds loader/session-safe `Bag.capacity` rebinding so the embedded Save Editor cannot leak its `mod.save` closure into gameplay.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and the canonical 15-file player package remain unchanged. Runtime R/B/Y + Gold capacity validation is required.

## 2.5.33-DEV

- Strict child of 2.5.32-DEV player package (parent SHA-256 `bc90a70fa72c723ea2053a6e493bfc45794e752fd0b4a625d1aff58c2a78066a`).
- Replaces the historical Running Shoes boolean with a three-state **OFF / HOLD B / ALWAYS** movement-assist selector. Existing saved ON values migrate to **HOLD B**, preserving their prior behavior.
- Adds **Fast Surf** with the same OFF / HOLD B / ALWAYS selector in R/B/Y and Gold. HOLD B/ALWAYS halve ordinary player-controlled Surf step duration while leaving Surf initiation, scripted movement, Waterfall, fishing, biking, and on-foot movement unchanged.
- Running Shoes and Fast Surf use the shared composable `movement.speed` hook. Running applies only off-bike/on-foot; Fast Surf applies only while the engine reports Surf state.
- QoL Toggles `run_hold_b` is now treated as a composable overlap rather than full ownership of the Nuzlocke control, so Nuzlocke's ALWAYS mode remains selectable and double-halving is avoided while B is already handled downstream.
- Adds one-time semantic migration marker `movement_assist_modes_2533`; Save Schema remains 4, Compatibility API remains 28, Diagnostics API remains 1, and Mod API remains 2.
- Source/static validation required; runtime TEST REQUIRED in R/B/Y and Gold for all three Running Shoes modes and all three Fast Surf modes.

## 2.5.32-DEV

- Strict child of 2.5.31-DEV player package (parent SHA-256 `88ae7a01af736a62d1d19fc04b81867a46afdd7f108df1ba2acedb028140f9f7`).
- Gold Random Starter now resolves Elm's three balls as one deterministic canonical slate rather than three independent seeded rolls.
- The slate avoids duplicate choices whenever another legal candidate exists while remaining preview-order independent.
- Added a dedicated `STARTER_SLATE` deterministic namespace/version so this repair does not reshuffle Random Encounters or Random Learnsets.
- Elm POKEPIC/CRY rewrites are now non-mutating: shared generated command/operand tables remain vanilla and only per-dispatch shallow copies carry the randomized species.
- The accepted starter is still committed only at the real GIVEPOKE transaction; starter nickname behavior is unchanged.

## 2.5.31-DEV

- Strict child of 2.5.30-DEV player package (parent SHA-256 `b5554d30a04f7b3197d60f81adaeef577936f07afead8d90cac01ae15ae8a7bc`).
- Restores the earlier public **Whiteout / Blackout** meaning and adds the requested PC-reserve exhaustion check. **Whiteout ON** survives a total-party KO only when at least one usable Pokemon remains in the party or Box storage; **Whiteout OFF** is destructive Blackout and ends/deletes the run.
- A recovery reserve must be a real usable Pokemon. `nuzlockeDead` Pokemon, permanent **PC LOCKED** progression catches, and Eggs never count. With Permadeath OFF, the fainted active party still counts because native blackout recovery can heal it; with Permadeath ON, dead party members are pruned before the reserve decision.
- If Whiteout ON survives with an empty party and boxed reserves, the native loss/heal-point warp remains engine-owned and Nuzlocke prompts the player to withdraw a reserve from the PC. Gold receives a narrow Bill's-PC access repair so an empty-party survivor can actually open storage when an eligible boxed reserve exists. The normal empty-party PC refusal remains intact when no legal reserve exists.
- Battle wipes and overworld-poison wipes use the same reserve classifier in R/B/Y and Gold. First Rival Mercy remains an earlier exception and still suppresses death/Whiteout/Blackout consequences for the opening Rival battle only.
- Existing saves receive a one-time semantic migration (`whiteout_semantics_restored_2531`) that inverts the old stored boolean so their previously selected behavior is preserved under the corrected ON/OFF meaning. Fresh 2.5.31 saves stamp the marker at creation. Save Schema remains 4.
- HARDCORE, SOLO, and IRONMON loadouts continue to be run-ending on a total wipe; their stored preset value is changed to **Whiteout OFF / Blackout** to preserve that behavior under the restored semantics.
- Source/static validated; **R/B/Y + Gold runtime TEST REQUIRED** for Whiteout with a boxed reserve, Whiteout with no legal reserves, Blackout with a boxed reserve, First Rival Mercy, field-poison wipe, save/reload migration, and Gold empty-party Bill's-PC access.

## 2.5.30-DEV

- Strict child of 2.5.29-DEV player package (parent SHA-256 `89cb2e3fb88eab0cda083993f237973befaa6d89794b4b87e1bcca9aef1c85dc`).
- Repairs the runtime-confirmed inherited **Gold Random Starter** failure. Gold's Elm `givepoke` now has a second, transaction-level safety net at the Gen 2 VM `hooks.givePoke` seam, so the concrete starter species no longer depends solely on the earlier `script.command` operand rewrite.
- Preserves Elm's selected canonical Ball/story branch and rival-counterpick flags while replacing only the species operand passed into native GivePoke. Native construction, OT/Pokedex mutation, held-item handling, and nickname flow remain engine-owned.
- Hardens fresh-NEW-GAME Random Starter configuration across Gold's save-backing handoff: if the immutable Setup snapshot is still authoritative, Random Starter copies only its toggle, Starter Style, and seed into the newly adopted mod.save bucket before the first Elm preview/grant. External starter-provider ownership still wins.
- Adds owner-aware `Vm.new` wrapper identity plus DEV SELF TEST health row `gold_random_starter_transaction_gate`, and revalidates Gold adapters on `save.created` as well as `game.ready`/`save.loaded`.
- Existing Gold starter nickname enforcement is intentionally unchanged. Save Schema remains 4, Compatibility API remains 28, Diagnostics API remains 1, Mod API remains 2, and the engine range remains `>=0.1.86 <2.0.0`.
- Runtime TEST REQUIRED: fresh Gold NEW GAME with Random Starter ON must receive a non-Chikorita/Cyndaquil/Totodile replacement for the selected vanilla starter (candidate pool excludes the original), retain the chosen Ball/story branch, and still enforce the starter nickname rule. Repeat a fixed seed to confirm determinism.

## 2.5.29-DEV

- Strict child of validated 2.5.28-DEV player package (parent SHA-256 `91004bee6be3725be9f3c25e285671a8757545ec435d863cdc1d1f325be694ef`).
- Gold now exposes **Ball Per Enc.** in Setup/NUZ RULES. The Gold battle-Pack counter/refusal mechanic already existed; this child closes the configuration-surface parity gap without changing its OFF / 1 / 2 / 3 / 5 / 10 semantics.
- Adds dedicated Gold-only NEW GAME resource controls instead of reusing the R/B/Y profile fields: **Starting Money** 0-999999 (default 3000), **Starting Rare Candy** 0-99 (default 0, bedroom PC), and **Starting Poke Balls** 0-99 (default 0).
- Gold Starting Poke Balls are an **extra PC allotment**, not a replacement for Gold's native 5-Ball story reward. They remain deferred until `EVENT_GAVE_MYSTERY_EGG_TO_ELM` is live, so Setup cannot arm the pre-Ball Route 29 opening early; Quick Nuzlocke Start still preserves the native 5-Ball milestone and then releases the configured extra PC allotment.
- Marks the historical R/B/Y `starting_*` rows explicitly R/B/Y-only in the machine-readable rule registry; Gold uses separate `gold_starting_*` keys and its native six-digit `player.money` field.
- Save Schema remains 4, Compatibility API remains 28, Diagnostics API remains 1, Mod API remains 2, and the supported engine range remains `>=0.1.86 <2.0.0`.
- Runtime TEST REQUIRED: Gold Ball Per Enc. selector/enforcement; Gold NEW GAME money/candy resources; normal-story and Quick Start extra-Ball release after Elm; 0/default values preserving native behavior; save/profile isolation from R/B/Y starting-resource choices.

## 2.5.28-DEV

- Added **PC-Only Catches**, a default-OFF progression/completion exception for otherwise Nuzlocke-illegal capture attempts in R/B/Y and Gold.
- Eligible exception catches keep the engine's real capture/Pokedex result but are immediately moved to Pokemon Box storage, marked `nuzlockePcLocked`, and treated as permanently unusable: native PC WITHDRAW, box-to-party MOVE, RELEASE, and the public Party/PC policy all refuse them.
- PC-only catches do **not** spend One Per Area/Failed Encounter state, do not enter the ordinary Encounter Tracker catch ledger, do not consume Type Locke draft lanes, and do not make a later legal encounter count as Dupes merely because the research-only Pokemon exists in storage.
- Ordinary **No Catching** remains absolute. It can be bypassed only when a compatible capture source explicitly declares both progression-required and progression-exception permission. Malformed/glitch safety is never bypassed, and Party Size Limit alone does not convert an otherwise legal catch into a permanent PC-only catch.
- The exception preflights Pokemon Box capacity before allowing the illegal capture; if all boxes are full, the throw is refused and the original Ball is not consumed by Nuzlocke's gate.
- Compatibility API remains 28. Cooperative acquisition results may now add `pcLock=true`, `permanent=true`, `consumeEncounter=false`, and `pcLockReason` on an explicitly progression-required exception; `PartyPC.evaluate` recognizes `progression_pc_lock` for incoming/release attempts.
- Save Schema remains 4, Diagnostics API remains 1, Mod API remains 2, and the supported engine range remains `>=0.1.86 <2.0.0`.
- Runtime TEST REQUIRED: R/B/Y + Gold illegal catch -> Box, no encounter spend, blocked withdraw/move/release, persistence after save/reload, full-box refusal, and ordinary No Catching remaining absolute.

## 2.5.27-DEV
- Strict child of validated 2.5.26-DEV player package (parent SHA-256 `e5549df2e46a4c8ab3a47f97790226c0c8c7b5911cc94b3883442674e5971d91`).
- Expands **Maximum BST** from OFF / 400 / 450 / 500 / 550 to **OFF / 300 / 350 / 400 / 450 / 500 / 550 / 600 / 650 / 700**.
- Keeps existing saved thresholds and the underlying catch/gift/trade enforcement semantics unchanged; legacy free-form values remain preserved until the player changes the control, then cycling begins from the nearest preset.
- The preset cycle now derives its size from one shared maximum-index constant instead of a hard-coded five-entry modulus, reducing future ladder-drift risk.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, randomizer behavior, loadout ownership, and engine range are unchanged.
- Runtime UI/rule test required in R/B/Y and Gold: cycle both directions across OFF/300 and 650/700 boundaries and confirm a cap actually blocks a species above the chosen threshold.

## 2.5.26-DEV
- Strict child of validated 2.5.25-DEV player package (parent SHA-256 `b85cdb96c03a4342b2c389c333b70ff8a6fdc4e527476fe7be7468bfbbd3fbba`).
- Rebalances the R/B/Y native NUZ INFO **STAT INFO** page: ATK/DEF/SPE/SPC value/DV/Stat EXP rows move left into unused label space and expand from the old 8-glyph marquee budget to 14 glyphs.
- Preserves the complete native worst-case stat string shape (`999 D15 E65535`) instead of pre-truncating STAT right-column values to the generic Catch-page budget. LEVEL/HP also gain width while keeping extra separation from their longer labels.
- Catch Info, Move Info, Gold NUZ INFO, gameplay rules, randomizer behavior, Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and the engine range are unchanged.
- Runtime visual test required on R/B/Y STAT INFO at ordinary and high Stat EXP values.

## 2.5.25-DEV
- Strict child of validated 2.5.24-DEV player package (parent SHA-256 `33dc2564cbfe63809ec39315ddc489d16a09443d4a2795b145d98a281ac2db39`).
- Adds **Random Field Items** (default OFF) for visible overworld item-ball pickups in R/B/Y and Gold. Ordinary visible pickup payloads are replaced only at collection time, leaving the engine's native bag-capacity, retry, disappearance/event-flag, text, and sound flows intact.
- Uses a dedicated deterministic `FIELD_ITEMS` RNG stream under the existing shared seed/algorithm version. Enabling field-item randomization therefore does not perturb Random Starter, Random Encounters, or Random Learnsets results for the same seed/settings.
- Progression-critical/key items and HMs are protected in place and excluded from the replacement pool. Hidden items, NPC gifts, shops, fruit/apricorn trees, and other scripted rewards are intentionally outside this first scope.
- Adds owner-aware R/B/Y `OverworldController.talkTo` and Gold `HiddenItems.ballPickupScript` lifecycle adapters plus Dev hook-health/self-test visibility.
- No loadout ownership, Save Schema, Compatibility API, Diagnostics API, Mod API, or engine-range change. Random Field Items is SOURCE/STATIC TEST REQUIRED and requires runtime pickup validation in R/B/Y and Gold.

## 2.5.24-DEV
- Strict child of validated 2.5.23-DEV player package (parent SHA-256 `a6466d34c23e44544846b5b716d4ff7870974ad4114d78e790b0b60bd69d179e`).
- NUZ RULES and NEW GAME Setup now remember the selected row and visible scroll anchor when the screen is closed and reopened during the same mod session.
- Navigation memory is isolated per surface (R/B/Y vs Gold and Setup vs active Rules) and uses semantic rule/header identities instead of raw list indices, so collapsed sections and dependent-row visibility cannot silently restore to an unrelated row.
- Navigation state is UI-only/session-only: it is not written to gameplay saves, setup profiles, or Save Schema 4 and naturally resets on a fresh process/mod reload.
- No rule/default/loadout/save representation changes. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` remain unchanged.
- Runtime test required: move deep into each Rules/Setup surface, close/reopen, and verify the same selected row/scroll window is restored; also smoke collapsed/dependent rows in R/B/Y and Gold.

## 2.5.23-DEV
- Strict child of validated 2.5.22-DEV player package (parent SHA-256 `f6124bb85e5e0d89bc3c181fddfb5ea1879c662f01a224eced3046ed5729ce95`).
- Repairs the runtime-confirmed 2.5.22 Random Starter regression: starter selection no longer reaches across a Lua lexical boundary for `Randomizer` / `seededIndex`; the owning randomizer phase exports the shared deterministic helper explicitly, preserving algorithm-v1 seeded results.
- Restores the R/B/Y `heal_party` / `Commands.resolve` / `give_pokemon` wrapper tail to the same installer scope that owns its captured locals. This restores No Mom Heal enforcement and the starter transaction/provenance path used to record R/B/Y starters under Pallet Town.
- Executes the staged late-runtime phase 2 instead of defining and discarding it. This restores the Yellow Oak Pallet catch-demo skip and the authoritative script-command healing fallback that were dormant in 2.5.22.
- Adds immediate and `save.created` lifecycle revalidation for the critical R/B/Y command/heal wrappers so a fresh NEW GAME is a first-class lifecycle boundary rather than relying only on `game.ready` / `save.loaded`.
- Adds a conservative repair for affected R/B/Y opening starters that were left with UNKNOWN/Oak-Lab tracker provenance, only when real starter flags or a committed random-starter choice identify the opening starter.
- Expands DEV SELF TEST with late-runtime phase-2, Oak-demo, R/B/Y starter-transaction, Random Starter, Skip Catch Demo, and No Mom Heal health/state rows.
- Strengthens local/CI regression gates for Lua lexical-scope mistakes, staged closure execution, installer-scope ownership, fresh-New-Game lifecycle coverage, and mutation tests that must fail if these exact regressions are reintroduced.
- No rule/default/loadout/save representation changes. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` remain unchanged.

## 2.5.22-DEV
- Strict child of validated 2.5.21-DEV player package (parent SHA-256 `89cbba7fa3daca0d4ef93992c8a0fe476be45c2f304bc39369649842060a8a77`).
- Lifecycle-hardens Gen 1 variable-width kerning on the persistent `src.render.Font` singleton with explicit session token / previous / wrapper identity instead of trusting predecessor markers from an older reload.
- Exact stale Nuzlocke kerning wrappers are safely unwrapped before rebinding; ambiguous legacy/foreign wrapper chains fail closed and require one fresh process rather than risking double kerning or deleting another mod's wrapper.
- Starter randomization now uses the shared versioned `seededIndex()` path and derives its semantic namespace from `Randomizer.algorithmVersion`, matching encounter and learnset randomization. Algorithm v1 preserves the exact existing starter hash input/results.
- Live RNG version labels derive from the shared algorithm-version source; historical changelog references to RNG v1 remain historical.
- Added local invariants for kerning reload ownership and randomizer algorithm-version synchronization.
- No rule/default/loadout/save representation changes. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` remain unchanged.

## 2.5.21-DEV
- Strict child of validated 2.5.20-DEV player package (parent SHA-256 `5e927a325ec9a3805b8d9e916687d5edd3efd9e656aebc4dfacae222c67fe693`).
- Centralized trainer identity normalization in `trainer_rewards.lua` so reward recognition and passive League progression use the same trainer ID/class/name evidence.
- Added Gen 1 `oppClass`, generic `trainerClass` / `opponentClass`, and Gold `trainer.classId` / `trainer.class` coverage to the shared identity extractor.
- R/B/Y Gym/E4/Champion and Gold stage progression now consume the shared identity matcher rather than rebuilding an id/name-only identity path.
- Added local invariant coverage that fails if reward/progression identity extraction drifts apart again.
- No rule/default/loadout/save representation changes. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` remain unchanged.

## 2.5.20-DEV
- Strict child of validated 2.5.19-DEV player package (parent SHA-256 `39dfe863d5cd893e45b6be753f254ffd2d1d2f99597c32a77ae00ccfffe35e49`).
- Separates Nuzlocke persistence safety (`canWriteNuzlockeSave`), master-switch state (`isNuzlockeEnabled`), and rule enforcement (`shouldEnforceNuzlocke`); historical/internal `active()` now explicitly aliases rule enforcement.
- Keeps Gym/E4/Champion progression synchronized on supported saves while Nuzlocke is temporarily OFF, but blocks all Nuzlocke-owned progression writes on unsupported newer schemas.
- Gates Failed Encounter, Forgiveness Token stock/purchase/spend/rewards, trainer-money rewriting, and post-battle Permadeath cleanup behind rule-enforcement policy.
- Adds defense-in-depth guards to `markEncounterFailed` and encounter-rule arming so unsupported newer schemas cannot mutate encounter bookkeeping through battle teardown.
- Extends local invariants with policy-aware PASSIVE_PROGRESS versus RULE_ENFORCEMENT checks instead of requiring a blanket `active()` guard on every battle writer.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` remain unchanged.

## 2.5.19-DEV
- Strict child of validated 2.5.18-DEV player package (parent SHA-256 `82b9b391928acbc7ee580ca9d3997d6f4f93fe35f2782dff3b4712f3340a7ac5`).
- Hard-stops R/B/Y and Gold randomized-starter repair on unsupported newer save schemas before save-backed table/Pokémon mutation.
- Makes Pokémon identity lookup read-only and blocks identity allocation/hydration while safe-stopped.
- Returns defensive Compatibility API engine reports and refreshes `engine_compat` after Item Policy state changes.
- Expands Save Schema 4 descriptor with migration-bookkeeping roles/counts.
- Lifecycle-hardens the final `mod.save:set` safe-stop wrapper and suppresses Permanent Rule Seal reconciliation while safe-stopped.
- Extends local invariants for these save-safety/API guarantees.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` remain unchanged.

## 2.5.18-DEV
- Strict child of the validated 2.5.17-DEV player package (parent SHA-256 `d9b075c3ba28c74537dcdd5b367a658c031bfb9f701e01e3b2eef062ea332ab9`).
- Defensive-copied public Compatibility API capabilities, engine/mod compatibility metadata, relationships, ownership, and legacy `mod.exports.owns` so consumer mutation cannot alter Nuzlocke's internal relationship resolver or ownership policy. Public dynamic mod-compat snapshots refresh after provider discovery; internal compatibility reports now return copies.
- Fixed `getEffectiveRuleValue()` so a missing key with no caller fallback uses `defaultRuleValue(key)`, matching `isRuleActive()` and enforcement semantics.
- Rule Registry construction now records duplicate-key collisions and exposes them through `describe()` / `audit()` instead of silently discarding them before audit.
- Save Schema 4 descriptor now explicitly documents `hardcore_mode` and `elite_four_caps` as compatibility mirrors of `level_cap_scope`, plus `solo_active`, `no_shopping`, `ball_use_ban_tier`, and `route_splits` as migration-only legacy inputs. No persisted representation changed.
- DEV SELF TEST now returns a defensive copy of capability contract versions.
- Updated local invariant tooling to validate defensive-copy/current-doc contracts and to flag only authoritative boolean-only wrapper guards; dormant historical compatibility markers no longer create misleading wrapper-debt warnings.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` engine range are unchanged. Runtime testing remains required.

## 2.5.17-DEV
- Strict child of the validated 2.5.16-DEV package (parent SHA-256 `2c1f981139332064f25b2f46cf2f7fd4044e4f8283ef3dc156569f147fbbc435`).
- Added machine-readable build provenance so Dev Mode/CI can verify the exact immediate parent version/SHA, Save Schema, API versions, audited Gen1Recomp marker, and 15-file player-package contract.
- Added a derived Rule Registry descriptor and Save Schema 4 configuration descriptor. They are read-only views over the existing canonical rule/default paths and do not replace enforcement or migrate player data.
- Added a reusable owner-aware direct-method wrapper installer for lifecycle-safe wrappers; this centralizes exact `owner` / `previous` / `wrapper` handling without changing rule semantics.
- Added stronger Dev SELF TEST assertions for Rule Registry integrity, Save Schema descriptor integrity, build provenance, and compatibility capability-version coverage. Diagnostics API remains 1 because the existing diagnostics contract remains backwards compatible.
- **Compatibility API advances from 27 to 28** because `capability_versions` and `getCapabilityVersion(capability)` are a new public consumer-visible negotiation surface. All existing API-27 capability names/meanings remain compatible and begin at capability contract version 1; `compatible_from` remains 10.
- Save Schema remains 4, Mod API remains 2, Diagnostics API remains 1, and engine range remains `>=0.1.86 <2.0.0`. No gameplay rule/default/loadout/encounter behavior intentionally changes from 2.5.16.
- Repository CI/invariant tooling is development-only and remains outside the canonical 15-file player package.
- 2.5.17 is a source/static development-infrastructure child; runtime gameplay should match 2.5.16 and DEV TOOLS -> SELF TEST should be smoke-tested.

## 2.5.16-DEV
- Strict child of the validated 2.5.15-DEV package.
- Fixed the public `ruleActive()` compatibility helper so missing persisted keys use `defaultRuleValue(key)` instead of an unconditional false fallback. Existing Compatibility API 27 semantics now agree with Setup/NUZ RULES/enforcement for default-ON boolean rules without changing the API version or return shape.
- Replaced remaining historical CUSTOM/0 `locke_type` read/verification fallbacks with the canonical `defaultRuleValue("locke_type")` source. Explicit saved CUSTOM/NUZ/HARD/etc. choices remain authoritative.
- Tightened live-wrapper identity checks for R/B/Y/Gold automatic default names, Gold nickname enforcement, Gold Mart BUY/SELL enforcement, Gold Game Corner handlers, and the R/B/Y Permadeath bundle. Owner markers alone no longer prove that the recorded wrapper is still live.
- Hardened QoL Toggles AUTO-REPEL compatibility with an explicit live wrapper marker so No Repels cannot silently trust a stale owner marker after rebinding.
- Hardened Wilds of Kanto compatibility so both `_resolveCapture` and `giveCaughtPokemon` must match the recorded Nuzlocke session before the adapter is considered installed; stale exact wrappers are unwrapped independently before rebinding.
- Expanded Dev hook-health reporting across catch/finalize/nickname, field-poison, party-limit, Gold capture/nickname/Whiteout/Headbutt/Day Care, R/B/Y Permadeath, Gold Mart/gambling, QoL AUTO-REPEL, and Wilds capture seams. Diagnostics API 1 is unchanged because this is additive reporting within the existing health surface.
- Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` are unchanged.
- 2.5.16 is a source/static reliability/diagnostics repair; runtime re-test is required.

## 2.5.15-DEV
- Strict child of the validated 2.5.14-DEV package.
- Fixed field-poison Whiteout enforcement in both R/B/Y and Gold. Overworld poison wipes now end/delete the run when Whiteout is ON even if Permadeath is OFF; native poison-faint/blackout presentation is retained and only the final heal-point/spawn warp is intercepted.
- Fixed Gold No Escape: the shared `battle.run` hook now resolves the live game through `battle.game` when available and otherwise `currentGame/mod.game`, matching Gold's pure Battle payload which has no `game` field.
- Fixed new-game snapshot persistence for `locke_type`: the selected loadout is now written explicitly before verification, preventing stale loadout labels / repeated snapshot verification retries when all managed rules were otherwise committed correctly.
- Replaced boolean-only install ownership on the remaining high-value direct wrappers with owner/previous/wrapper session records: R/B/Y + Gold Party Size/PC withdrawal, Gold No Day Care, Gold battle Whiteout finish, Gold Headbutt tracking, and Gold forgiveness-token mart stock. Historical boolean fields remain non-authoritative compatibility markers.
- Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` are unchanged.
- 2.5.15 is a source/static reliability repair / R/B/Y + Gold runtime TEST REQUIRED.

## 2.5.14-DEV
- Strict child of the validated 2.5.13-DEV package.
- Fixed the R/B/Y scripted starter/gift context ordering bug: `nuzlockeGivePokemon()` now binds `ctx.save` before the Pallet/Oak/Lab fallback reads `save.player.map`, so randomized/compatibility starter transactions can use the intended save-backed location evidence instead of an accidental outer/global lookup.
- Completed a canonical-default consistency sweep for core encounter/acquisition enforcement. Missing persisted keys for One Per Area, Nickname Rule, Dupes Clause, Allow Gifts, and Allow Trades now fall back through `defaultRuleValue()` instead of historical inline OFF values. Existing explicit saved values remain authoritative and are not migrated or rewritten.
- Gold Pokégear World Building presentation now receives the same canonical rule-default resolver, removing its last missing-key T0 fallback while preserving explicit OFF/T1/T2/T3 saves.
- Replaced stale boolean-only ownership guards on the older R/B/Y catch wrappers (`throwBall`, catch-finalize `finish`, nickname UI), R/B/Y Permadeath/Whiteout wrappers, and Gold capture `useItem` wrapper with owner/previous/wrapper session metadata. A later ModLoader session can unwrap an exact stale Nuzlocke top-level wrapper and bind the current mod/save instead of silently trusting an old marker. Historical marker fields remain for compatibility but no longer own installation decisions.
- Reviewed Gen1Recomp 0.2.7 TimeFishGroups semantics and made no randomizer rewrite: the engine intentionally prefers row-local `day`/`nite` fishing slots and uses `timeFishGroups` only as fallback; forcing those structures to re-synchronize could overwrite a compatible mod's deliberate row-level override.
- Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` are unchanged.
- 2.5.14 is a source/static repair / R/B/Y + Gold runtime TEST REQUIRED.

## 2.5.13-DEV
- Strict child of the validated 2.5.12-DEV package.
- Fixed a source-confirmed Permadeath gap for overworld poison faints in both R/B/Y and Gold. These paths mutate HP outside the battle faint lifecycle, so battle-only death hooks could miss the loss.
- R/B/Y now observes the native `OverworldState:applyFieldPoison` result, records only Pokémon that crossed from usable HP to 0 HP under active Permadeath, then prunes those exact party objects after native poison handling returns.
- Gold now observes `World:poisonFaintScript` using the engine-provided fainted party indices, lets native poison-faint happiness/text queue first, then records/prunes those exact Pokémon before a later native `whiteOut()->healParty()` can revive them.
- Field-poison deaths use the existing `nuzlocke_history`, `nuzlocke_losses`, `last_loss`, identity, glitch-label, and tracker-death projection contracts with `deathStatusCondition = POISON` / field-death metadata.
- Nuzlocke OFF and Permadeath OFF remain vanilla. Native poison timing/SFX/text and native whiteout/heal/warp sequencing are not replaced. Whiteout Clause semantics are unchanged by this narrow repair.
- Added session-owner-aware field-poison wrappers so a reload can remove Nuzlocke's own stale wrapper instead of stacking duplicate bookkeeping.
- Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` are unchanged.
- 2.5.13 is a source/static Permadeath repair / R/B/Y + Gold runtime TEST REQUIRED.

## 2.5.12-DEV
- Strict child of the validated 2.5.11-DEV package.
- Re-audited the published Gen1Recomp 0.2.7 release against Nuzlocke-owned and observed seams. Audio/device recovery, true-color/grass rendering, Gold title presentation, and related platform changes require no Nuzlocke ownership rewrite.
- Confirmed the 0.2.7 Gold encounter registry gained time-dependent fishing (`TimeFishGroups`) while retaining the shared `encounters` registry contract.
- Fixed Nuzlocke's public effective/final encounter-registry facade on Gold: it now exposes `game.data.gen2Encounters` (with `game.data.encounters` fallback) instead of returning only the Gen 1 alias.
- `Registry.describe()` now reports that same generation-correct live encounter table, keeping DexNav/guide/provider consumers aligned with the table gameplay actually uses.
- Random encounter table generation, OPEN/BLIND information policy, targeted-selection policy, provenance, save data, and reroll behavior are unchanged.
- Engine range remains `>=0.1.86 <2.0.0`; Mod API 2, Save Schema 4, Compatibility API 27, and Diagnostics API 1 are unchanged.
- 2.5.12 is a source/static compatibility repair / Gold runtime TEST REQUIRED.

## 2.5.11-DEV
- Strict child of the validated 2.5.10-DEV package.
- Completed the 2.5.4 World Building T3 -> T1 default migration: the live `worldTier()` resolver now falls back through canonical `defaultRuleValue("world_building_tier")` instead of hardcoding T3.
- Configuration-value fallback for `world_building_tier` now uses the same canonical T1 default rather than an inline T3 fallback when stored data is absent/non-numeric.
- Updated the World Building rule description from `RECOMMENDED: TIER 3` to `DEFAULT: TIER 1`.
- Existing explicit OFF/T1/T2/T3 saved selections are preserved; no save migration, schema bump, API change, engine-range change, or enforcement change is introduced.
- 2.5.11 is a static consistency repair / runtime TEST REQUIRED.

## 2.5.10-DEV
- Strict child of the validated 2.5.9-DEV package.
- Fixed Gold Pokégear NUZ RULES pagination so A advances through every four-row page, including non-multiple-of-four final pages, before wrapping to page 1.
- Added `RULES x/y` and an `A:MORE` footer affordance when the Pokégear rule list overflows four rows.
- Added a translated `NO ENTRIES YET` empty state to native R/B/Y, native Gold, and Modern UI ENC TRACKER presentation.
- Modern UI empty-state presentation preserves the real zero entry count and does not use the placeholder for selected-row detail/provider semantics.
- No Save Schema, Compatibility API, Diagnostics API, Mod API, engine range, encounter mechanics, or provider ownership semantics changed.
- 2.5.10 UI repairs are static / runtime TEST REQUIRED.

## 2.5.9-DEV
- Strict child of the validated 2.5.8-DEV package.
- Yellow 2.5.8 runtime PASS: fresh Shiny Clause defaults to OFF/0.
- Yellow 2.5.8 runtime PASS: Type Locke editing in NUZ RULES no longer raises the prior update error.
- Yellow 2.5.8 runtime FAIL: saving NEW GAME setup could raise an attempt to index global `TYPE_LOCK_SLOT_INDEX`; all later setup/profile slot checks now use the lifecycle-stable Type Locke accessor owned by the canonical lexical block.
- Repaired the related Gold status-summary use of the out-of-scope Type Locke slot-key table.
- Loadout confirmation now scrolls through every owned-rule change with UP/DOWN instead of truncating the preview with `+N MORE`; APPLY/CANCEL semantics are unchanged.
- Nuzlocke-owned setup/rules/status error dialogs now pre-wrap into explicit two-line TextBox pages, forcing manual A/B advancement so diagnostic text can be captured.
- Moved GAME DIFFICULTY then BATTLE MECHANICS immediately above AREA SPLITS.
- Reviewed the reported Gold First Rival Mercy 0-HP asymmetry against Gen1Recomp 0.2.7 `gen2_canlose_test.lua`; NO CODE CHANGE because BATTLETYPE_CANLOSE intentionally leaves the starter at 0 HP until the continuing Cherrygrove script calls HealParty.
- Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, engine range, and loadout ownership semantics are unchanged.
- 2.5.9 setup/UI repairs remain runtime TEST REQUIRED.

## 2.5.8-DEV
- Strict child of the validated 2.5.7-DEV package.
- Yellow 2.5.7 runtime confirmed the loadout-change warning still overflowed/clipped its native modal layout; R/B/Y warning rows are now bounded to a 16-glyph-safe line, show the destination value first, and marquee long rule names instead of drawing through the border.
- Yellow 2.5.7 runtime confirmed changing Type Locke could still trigger the generic NUZ RULES update error; Type Locke edit/update paths now obtain slot/default tables through lifecycle-stable exported accessors, and the random-selection resolver uses the same stable tables.
- Fresh/new-profile **Shiny Clause** default changed from UNLIMITED/4 to OFF/0. Existing saved values, historical boolean migration (`true -> 4`), and used-count telemetry are preserved.
- Moved **Route Forgiveness** from CLAUSES to **GENERAL**; enforcement, token awards/spending, and save keys are unchanged.
- Save Schema 4, Compatibility API 27, Mod API 2, engine range, starter/opening repair, and Dev Report encoding are unchanged.
- All 2.5.8 changes are static repairs/organization until runtime-confirmed.

## 2.5.7-DEV
- Strict child of the validated 2.5.6-DEV package.
- Blue 2.5.6 runtime confirms DEV TOOLS -> VIEW REPORT no longer crashes after a full game restart when a saved report exists.
- Dev Report and Storage Info remained visually broken on the native R/B/Y viewport because long unbroken identifiers bypassed the normal word wrapper and the R/B/Y diagnostic content width was too wide.
- Added a Dev-only hard wrapper for long diagnostic tokens and reduced R/B/Y Dev Report/Storage Info content to a 16-character-safe width.
- NZR4 Report Codes now display below a dedicated `REPORT CODE:` label and wrap only between existing hyphen groups, so every code character remains visible/shareable.
- Report Code generation/decoding, diagnostic payload semantics, Save Schema 4, Compatibility API 27, Mod API 2, engine range, and gameplay enforcement are unchanged.
- The 2.5.6 shared NUZ RULES edit repair still requires runtime confirmation; the loadout-warning popup remains a separate known UI issue.

## 2.5.6-DEV
- Strict child of the validated 2.5.5-DEV package.
- Blue runtime confirmed the shared NUZ RULES edit path could error after a rule write with `bad argument #1 to 'ipairs' (table expected, got nil)`; hardened the title/setup Type Locke mirror with a canonical local fallback so ordinary rule toggles do not depend on that table reference.
- Blue runtime confirmed DEV TOOLS -> VIEW REPORT could crash; forward-declared the wrapped report-line helper so the update closure no longer resolves a nil global on the next frame.
- Removed the extra one-pixel duplicate draw from the MOD COMPAT left rule-name column, leaving those row labels unbolded while preserving the existing title treatment.
- No Save Schema, Compatibility API, Mod API, engine-range, randomizer, starter, or First Rival Mercy behavior was intentionally changed.
- Both runtime crash repairs are static repairs and require Blue runtime re-test before promotion to PASS.

## 2.5.5-DEV
- Blue opening-sequence repair attempt.
- Hardened Oak/Pallet starter-context detection for randomized R/B starters.
- Intended to fix mandatory Nickname Rule and Pallet Town provenance on randomized starters.
- Hardened First Rival Mercy at battle finish so the native Oak-lab loss continuation can heal and advance story state without Nuzlocke Whiteout/restart interference.
- Prevented post-battle dead pruning from re-breaking the one mercy battle.
- Added committed starter diagnostic output.

## 2.5.4-DEV
- World Building default changed from T3 to T1.
- Removed Cap Messages user setting; cap notice is fixed to once per battle on first blocked/banked EXP.
- Retired Solo Only; Party Size Limit = 1 is now authoritative for Solo runs.
- Added legacy Solo-to-party-limit migration and updated SOLO/IRON presets.

## 2.5.3-DEV
- Blue runtime UI pass.
- Ball Limit renamed to Ball Per Enc.
- No Catching and Ball Per Enc. moved to BATTLE ITEMS.
- Ball Per Enc. now hides immediately while No Catching is ON and returns when catching is allowed.
- Preserved OFF as the vanilla Ball Per Enc. default and preserved dormant saved selections.
- Aligned Ball Per Enc. value placement with neighboring selector values.
- Moved GAME DIFFICULTY and BATTLE MECHANICS above GENERAL.

## 2.5.2-DEV
- Added diagnostic-only validation for malformed/boolean `randomizer_info_policy` storage; no migration added because no historical boolean encoding exists.
- Source-audited Gen1Recomp releases 0.2.2 through 0.2.7.
- Advanced `recompCompatAudited` to 0.2.7 and added sequential engine compatibility profiles.
- Recorded the additive `battle.move_grid_navigation` hook as available/not-owned.
- Kept engine requirement `>=0.1.86 <2.0.0`.

## 2.5.1-DEV
- Runtime-validation build created strictly from the unreleased 2.5.0 candidate.
- No gameplay or save-format changes from that candidate.
- Release documentation reclassified as DEV/testing rather than published.
- Intended to gather one more runtime pass before a public 2.5.x release.

## 2.5.0
- Publishable stabilization release, strict child of 2.4.100-DEV.
- Fixed stale Dev Species Facts diagnostic to validate `getSpeciesFacts`.
- Advanced Report Code to NZR4 with full major/minor/patch encoding for the 2.5.0 semver boundary.
- Synchronized public exported build markers with the authoritative mod build.
- Completed full package/documentation/version cleanup.
- Preserved Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0`.
- No files added or removed.

## 2.4.100-DEV
- Fixed Randomizer Info Policy always displaying OPEN INFO despite BLIND INFO being stored/enforced.
- Completed a full numeric-rule plumbing sweep across default/read/write paths.
- No gameplay randomizer behavior changed.

## 2.4.99-DEV
- Completed Encounter Ball Limit numeric config wiring in `defaultRuleValue` and `getConfigValue`.
- Added default-audit and Dev Report readback coverage.
- Report Code format is now NZR3.
- Shiny Clause read/default paths were verified already-correct; setter repair remains from 2.4.98.

## 2.4.98-DEV
- Fixed Shiny Clause and Encounter Ball Limit edits being silently persisted as `false`.
- Added semantic repair for boolean artifacts written by affected builds.
- Added Dev assertions for invalid/raw boolean selector state.

## 2.4.97-DEV
- Fixed joined-word legacy mod IDs not being auto-classified by `detectCapabilities`.
- Expanded compact-ID fallbacks consistently across multi-word capability hints.

## 2.4.96-DEV
- Fixed randomized R/B/Y starters losing Pallet Town provenance when the species is not a vanilla starter.
- Added safe repair for affected Oak/Lab/UNKNOWN tracker rows.
- No randomizer selection/RNG behavior changed.

## 2.4.95-DEV
- Field-item rejection messages are now blocking, paginated, and A-driven.
- Fix targets include No Field Heal and No Rare Candy.
- Battle item rejection behavior is unchanged.

## 2.4.94-DEV
- Fixed stale R/B/Y field-command sessions allowing No Mom Heal to stop enforcing after command rebinding.
- Added Mom heal gate health to Dev Mode.
- Bumped shareable Report Code format to NZR2 for the new diagnostic result bit.

## 2.4.93-DEV
- Added versioned `NZR1` shareable Dev Report Codes.
- VIEW REPORT now works live without first exporting.
- Report codes decode the complete fixed diagnostic summary and fingerprint free-form report detail.
- Export/storage remains available as an optional deep-debug fallback.

## 2.4.92-DEV
- Fixed Storage Info text overflow on R/B/Y.
- Made all Storage Info rows glyph-aware and scrollable.
- Fixed Dev Report scrolling to use wrapped-row counts.
- No gameplay changes.

## 2.4.91-DEV
- Fixed Dev Report text overflow on narrow R/B/Y displays.
- Wrapped report rows now scroll cleanly and preserve the footer.
- No gameplay changes.

## 2.4.90-DEV
- Repaired Yellow opening Oak Pikachu catch-demo skip.
- No unrelated gameplay changes.

## 2.4.89-DEV
- Fixed Cap Messages selector editability.
- Default changed from CAP to BATTLE (once per battle).
- Invalid boolean artifacts from the old setter migrate to BATTLE; valid 0..2 values remain unchanged.

## 2.4.88-DEV
- Moved Party Size Limit and Gym Team Size to the bottom of IRONMON.
- No gameplay changes.

## 2.4.87-DEV
- Moved Party Size Limit and Gym Team Size to the top of GENERAL.
- Recorded Yellow section-header paging and bulk open/close controls as runtime PASS.
- No gameplay changes.

## 2.4.86-DEV
- Renamed the player-facing `Nickname Rule` label to `Nickname`.
- No gameplay or save-format changes.

## 2.4.85-DEV
- Added Encounter Ball Limit: OFF / 1 / 2 / 3 / 5 / 10 throws per encounter.
- R/B/Y + Gold support; battle-local reset; denied throws do not spend Balls or budget.
- Default OFF; no existing preset behavior changed.

## 2.4.84-DEV
- Canonicalize unambiguous legacy boolean values for numeric selectors during save upgrade.
- Primary bug target: old saves with Shiny Clause ON/`true` now persist numeric UNLIMITED/`4` and can use modern selector editing consistently.
- No unrelated gameplay changes.

## 2.4.83-DEV
- Fixed Nuzlocke compatibility with the repaired upstream Yellow starter nickname flow.
- Preserved Red/Blue starter naming behavior.
- No unrelated gameplay changes.

## 2.4.82-DEV
- Added cooperative optional-dependency ordering for `gen1_pt-br` v0.1.5.
- Documented PT-BR translation/presentation overlap audit.
- No gameplay-rule changes.

## 2.4.81-DEV
- Current Gen1Recomp/launcher compatibility audit.
- Added safe optional read-only BattleAPI snapshot exposure for Gen 1 and Gold.
- Confirmed launcher update metadata and Manifest v2 compatibility.
- No gameplay-rule changes.

## 2.4.80-DEV
- Localization compliance audit: glyph-aware Nuzlocke wrapping/slicing and additional `Strings(...)` coverage.
- No gameplay changes; strict child of 2.4.79-DEV.

# Changelog

## 2.4.79 DEV — Gen1 Better Menus 1.0.3 compatibility audit
- Strict child of 2.4.78 DEV.
- Added optional-dependency/load-order metadata and a descriptive compose adapter for Gen1 Better Menus 1.0.3.
- Preserved Nuzlocke-owned custom screens and predecessor-chained title SETUP injection; no global Menu.draw patch added.
- No gameplay/save/API/package-tree changes; runtime combination TEST REQUIRED.


## 2.4.78 DEV — Type Locke Expansion + Catch Draft

- Expanded Type Locke to Monolocke, Duolocke, Trilocke, Quadlocke, Pentalocke, and Hexalocke.
- Added persisted Type 4, Type 5, and Type 6 selectors.
- Added Catch Draft: opening battle-backed catches populate the chosen 1-6 Type Locke lanes before enforcement begins.
- Dual-type catches prefer a new type when possible, otherwise use their primary type deterministically. Gifts and trades do not draft lanes.
- Manual RANDOM selection resolves once and persists across all six lanes.
- Setup/Rules hide unused lanes and hide manual selectors while Catch Draft is active.
- Extended Type Locke legality, randomizer interaction, summaries, Gold parity metadata, and World Building text for the new modes.
- Save Schema 4, Compatibility API 27, Diagnostics API 1, engine range `>=0.1.86 <2.0.0`.
- Static/package validation only; no new runtime PASS claimed.

## 2.4.77 DEV — Compatibility Audit Consolidation

- Strict child of **2.4.76 DEV**.
- Documentation/compatibility-consolidation pass only; mechanics remain unchanged from 2.4.76 apart from build/version identification strings.
- Consolidates completed audits for Modern UI Fix, Advanced Box System, Nickname Changer, Trade Evolution Fix, Universal Free TM Shop, Moves Manager, Quest System, The Mirage of Mew, Crystal Onix, Poachers in the Safari Zone, Kanto Achievements, Pokédex Plus, Catch Helper, Move Inspector, Rocket Gym Ambushes, Team Rocket Returns, Eevee Three Stones, The Sixth Bell, The Stolen Fossil, Whispers Beneath Cerulean, The Abandoned Cabin, The Black Flower, The Empty Throne, Ashes of Cinnabar, Echoes Beyond the Fog, Move Learn Stats, Performance Monitor, BATTLE_ART_VOXEL_FORK, new_icons, and New Item Icons.
- Removes those completed reviews from the active compatibility target queue while retaining explicit runtime-test requirements.
- Does not convert source/static/expected classifications into runtime PASS claims.
- No Save Schema, Compatibility API, Diagnostics API, or engine-range change.
- Engine policy remains **`>=0.1.86 <2.0.0`**.

## 2.4.76 DEV — Compatibility Documentation & Target Queue

- Strict child of 2.4.75 DEV.
- Documentation/compatibility-ledger pass only; mechanics remain unchanged from 2.4.75 apart from build/version identification strings.
- Recorded the completed audit wave for NPC Bubbles, Guaranteed Catch, Repel Reuse Prompt, HM Anywhere, New Game Plus, Area DexNav, Summon, Modern Bag, Item Shortcut, Reusable Machines, DV/EV Editor, EXP Share Modes, Free Rare Candy, Free Master Ball, Too Many Balls, and Better Battle UI.
- Refreshed the current FAFF0x Gen1Recomp compatibility target queue.
- Promoted Modern UI Fix 1.0.0, Advanced Box System 1.1.0, Nickname Changer 1.0.0, Trade Evolution Fix 1.0.0, Universal Free TM Shop 1.0.0, Moves Manager 1.0.1, Quest System 1.0.5, The Mirage of Mew 1.0.1, Crystal Onix 1.0.8, and Poachers in the Safari Zone 1.0.0 as the highest-value next audits.
- No runtime PASS claims were added.
- Save Schema 4 / Compatibility API 27 / Diagnostics API 1 unchanged.
- Engine policy remains `>=0.1.86 <2.0.0`.

# Nuzlocke Changelog

## 2.4.75 DEV — Kanto Reforged 1.2.0 Level-Cap Interop
- Strict child of **2.4.74 DEV**.
- Adds a source-confirmed adapter for **Kanto Reforged 1.2.0**.
- Detects KR only when its own `level_caps_on` save flag is active.
- Reads KR's current cap through its own `ui/level_caps.lua` calculation and never writes KR options/save.
- When both Nuzlocke Level Caps and KR Level Caps are active, Nuzlocke now enforces/displays the **stricter** cap.
- When Nuzlocke Level Caps are OFF, KR remains solely responsible for its own soft-cap behavior.
- Public cap info now exposes optional co-owner metadata (`effectiveOwner`, `nuzlockeCap`, `kantoReforgedCap`, `kantoReforged`) without changing Compatibility API version.
- Kanto Reforged trainer-party/species/held-item behavior remains on generic composition paths.
- No Save Schema, Compatibility API, Diagnostics API, or engine-range change.


## 2.4.74 DEV — Indigo Plateau Conference 1.1.0 Compatibility Audit
- Strict child of **2.4.73 DEV**.
- Updates the built-in Indigo Plateau Conference adapter audit marker from **1.0.2** to **1.1.0**.
- Re-audits IPC's current Gold-only tournament architecture: IPC owns Colosseum staging, CANLOSE/elimination flow, tournament state, and survivor healing; Nuzlocke retains Permadeath/death-marker/rule ownership.
- Confirms Nuzlocke's existing priority **-1000** post-`battle.ended` dead-Pokemon pruning already runs after ordinary external listeners, so IPC may heal living survivors without reviving a Pokemon already marked `nuzlockeDead`.
- Keeps `trainer.party` composition unchanged; IPC positively scopes its roster substitution to its own armed tournament battle.
- No new listener, provider contract, gameplay rule, Save Schema, Compatibility API, Diagnostics API, or engine-range change.


## 2.4.73 DEV — Quick Start Runtime Documentation
- Strict child of **2.4.72 DEV**.
- Records a user runtime **PASS** for the R/B/Y Quick Nuzlocke Start / intro-bypass flow.
- Documents the observed convenience caveat: the handoff can place the player outside before bedroom-PC item pickup, but the house remains accessible and the items can still be collected by walking back inside.
- Updates the player-facing Quick Start description and implementation comment so the documented checkpoint matches observed runtime behavior.
- No progression logic, save behavior, hook behavior, Save Schema, Compatibility API, Diagnostics API, or engine-range policy changes.


## 2.4.72 DEV — Engine Range Policy Correction
- Strict child of **2.4.71 DEV**.
- Restores the manifest engine range to **`>=0.1.86 <2.0.0`**.
- Records `<2.0.0` as a protected project policy: do not change the maximum unless explicitly directed by the project owner.
- Keeps the Gen1Recomp audited release marker at **0.2.0**.
- No gameplay, hook, Save Schema, Compatibility API, Diagnostics API, or provider behavior changes.


## 2.4.71 DEV — Gen1Recomp 0.2.0 Compatibility Audit
- Strict child of **2.4.70 DEV**.
- Audited against the released **Gen1Recomp 0.2.0** line.
- Corrects `recompCompatAudited` from the inaccurate `0.2.1` marker to `0.2.0`.
- Narrows the manifest's verified engine range from `>=0.1.86 <2.0.0` to `>=0.1.86 <0.3.0`.
- Reviewed current Nuzlocke hooks/events, `mod.storage`, manifest API 2, Gold battle/catch modules, menu hooks, and reload/lifecycle seams against upstream 0.2.0.
- Upstream 0.2.0 retains the compatibility surfaces Nuzlocke currently uses; no protected gameplay hook was replaced in this pass.
- Save Schema remains **4**; Compatibility API remains **27**; Diagnostics API remains **1**.


## 2.4.70 DEV — Post-Release Safety / Diagnostic Hardening
- Strict child of the published **2.4.69** release.
- Fixes a downgrade-safety hole in the 2.4.66 write detector: an escaped `mod.save:set(...)` attempt on a newer-schema save is now recorded **and blocked** with `false, "newer_schema"` instead of being allowed to mutate the unsupported save.
- The write barrier resolves the current exported `saveSchemaSupported()` predicate dynamically, avoiding a stale closed-over schema flag if loader/session wrappers survive a supported reload.
- Adds the missing `saveSchemaTooNew` guard to direct `Randomizer.applyLearnsets(...)` calls, preventing live learnset mutation when an unsupported newer-schema save is loaded.
- Quick Start, Skip Opening Intro, automatic default-name activation, and `applyQuickNuzlockeStart(...)` now fail closed while a newer-schema safe-stop is active, protecting direct raw save-table writes outside `mod.save:set(...)`.
- Deferred Starting Balls release and Skip Catch Tutorial queries also fail closed on unsupported newer-schema saves, closing the remaining world-step/story shortcut paths found in the final sweep.
- Fixes the 2.4.68 Randomizer integrity audit so an intentionally empty legal Random Encounter pool reports **FALLBACK** (vanilla encounters retained) instead of falsely scanning vanilla slots as illegal randomized output.
- Corrects lifecycle diagnostic wording: pre-reload counter totals are not promised to survive; duplicate delivery is detected when stacked callbacks resolve through the same current Dev export.
- Documentation now records 2.4.69 as the published full release rather than leaving current history labeled RC.
- Save Schema remains **4**; Compatibility API remains **27**; Diagnostics API remains **1**.


## 2.4.69 — Published Release
- Strict child of **2.4.68 DEV**.
- No new gameplay feature or rule behavior is introduced in this RC.
- Published from the 2.4.68 development head after sequential Dev Mode hardening from 2.4.64–2.4.68.
- Retains 2.4.62 Random Encounter legality filtering and 2.4.63 future-schema downgrade safety unchanged.
- Retains Dev diagnostics for hook health, lifecycle duplicate detection, future-schema write-attempt detection, rule effectiveness, and Randomizer integrity.
- Save Schema remains **4**; Compatibility API remains **27**; Diagnostics API remains **1**.
- Package inventory remains the existing **15 files**; no files added or removed.
- The packaged code was the reviewed 2.4.69 release-candidate tree and was subsequently published as the full 2.4.69 release.


## 2.4.68 DEV — Dev Randomizer Integrity Audit
- Strict child of **2.4.67 DEV**.
- Adds a read-only recursive scan of the currently applied Nuzlocke-owned wild encounter registry.
- Reuses Random Encounter legality dimensions from the live candidate pool: generation mode, glitch exclusion, runtime safety, and canonical `specialAcquisitionDenied(...)` rule legality.
- Skips externally delegated Random Encounter ownership and content-provider slots that explicitly opt out of Nuzlocke randomization.
- Reports scan count, violation count, status, delegation owner, and up to 64 deterministic violation rows with path/species/reason.
- Integrates the audit into Dev snapshots, self-test results, exported `[RANDOMIZER INTEGRITY]` text, and `nuzlocke_dev.randomizer_integrity()`.
- No encounter tables are changed by the audit and no gameplay/save/API behavior changes.


## 2.4.67 DEV — Dev Rule Effectiveness Audit
- Strict child of **2.4.66 DEV**.
- Adds read-only rule diagnostics showing each applicable rule's configured/stored value, normalized effective config value, and current owner/relationship.
- Reuses the canonical `getConfigValue(...)` and `externalRuleDelegation(...)` paths instead of duplicating rule/delegation semantics.
- Reports whether a value came from the save or the rule default, plus aggregate totals for applicable, delegated, changed, and errored rows.
- Reports the Nuzlocke master-switch state and future-schema support state separately rather than falsely rewriting every rule's effective value when the master switch is off.
- Adds rule-effectiveness evidence to Dev snapshots, self-test results, exported `[RULE EFFECTIVENESS]` text, and `nuzlocke_dev.rule_effectiveness()`.
- No gameplay, rule, save-schema, Compatibility API, or persistent-save behavior change.


## 2.4.66 DEV — Future-Schema Safe-Stop Write Diagnostics
- Strict child of **2.4.65 DEV**.
- Adds a transparent diagnostic wrapper around Nuzlocke's own `mod.save:set(...)` surface.
- While `saveSchemaTooNew` is active, every attempted Nuzlocke save write is counted by key and the first attempt per key emits a `safe_stop.write_attempt` breadcrumb when Dev Mode is enabled.
- The detector never blocks or changes the underlying write; 2.4.63's explicit safe-stop guards remain the protection mechanism. This build only proves whether an unguarded writer escaped them.
- Adds aggregate/first/last/per-key evidence to Dev assertions, snapshots, self-test results, and exported `[SAFE STOP WRITES]` text.
- Adds `nuzlocke_dev.safe_stop_writes()` and `nuzlocke_dev.reset_safe_stop_writes()` for controlled downgrade tests.
- No gameplay, rule, save-schema, Compatibility API, or intended persistent-save behavior change.


## 2.4.65 DEV — Dev Lifecycle Counters
- Strict child of **2.4.64 DEV**.
- Adds session-only Dev counters for `game.ready`, `save.loaded`, `battle.started`, `battle.ended`, `pokemon.caught`, and `pokemon.evolved`.
- Lifecycle counters are session-instance diagnostics. Their main reload value is detecting repeated delivery when stacked callbacks resolve through the same current Dev export; pre-reload totals are not guaranteed to persist.
- Uses weak event-payload identity tracking to detect the same event table reaching the Dev callback more than once; repeated delivery increments `duplicate_callbacks` and per-event duplicate counts.
- Duplicate callback detection pushes a `lifecycle.duplicate` breadcrumb immediately.
- `battle_delta` reports `battle.started - battle.ended` as context only; it is not automatically considered failure because a self-test can run during an active battle.
- Lifecycle evidence is included in Dev snapshots, self-test results, exported `[LIFECYCLE]` text, and the public diagnostics surface.
- Adds `nuzlocke_dev.lifecycle()` and `nuzlocke_dev.reset_lifecycle()` for controlled runtime tests.
- No event-registration, gameplay, rule, save-schema, Compatibility API, or persistent-save behavior changes.


## 2.4.64 DEV — Dev Hook / Adapter Health
- Strict child of **2.4.63 DEV**.
- Adds read-only `Dev.hookHealth()` inspection for 13 observable Nuzlocke runtime adapters across R/B/Y and Gold.
- Diagnostics never `require(...)` a module merely to inspect it; only already-loaded modules are observed, preserving boot/load order.
- Health states are deliberately conservative: **HEALTHY** (our wrapper is live top-level), **CHAINED** (our marker/wrapper exists but another live function is above it or replaced it), **MISSING** (loaded module lacks the expected Nuzlocke marker), and **PENDING** (module not loaded yet).
- `Dev.selfTest()`, snapshots, exported self-test text, and `nuzlocke_dev.hook_health()` now expose hook-health evidence.
- CHAINED is informational rather than an automatic failure because another compatible mod may legitimately compose above Nuzlocke.
- No gameplay, rule, save-schema, compatibility-API, hook-ordering, or persistent-save behavior change.


## 2.4.63 DEV — Future-Schema Downgrade Safety
- Strict child of **2.4.62 DEV**.
- A save whose `__nuzlocke_save_schema` is newer than schema 4 now suspends ordinary Nuzlocke enforcement through the shared `active(...)` gate instead of continuing under older schema assumptions.
- High-risk lifecycle repair writers that do not naturally pass through `active(...)` now bail out while the newer-schema safe-stop is active: WIP Wonderlocke cleanup, staged new-game rule commits, external-save reconciliation, Randomizer encounter/all reapplication, and Gym/E4 initialization.
- The first ready game session displays a non-persisted **NUZLOCKE PAUSED** warning explaining that the save came from a newer Nuzlocke build and that enforcement/save repairs are disabled to protect it.
- Adds `mod.exports.__beta26.saveSchemaSupported()` as the central read-only schema-support query.
- No Save Schema or Compatibility API bump.


## 2.4.62 DEV — Random Encounter Rule-Legality Filtering
- Strict child of **2.4.61 DEV**.
- Fixes Nuzlocke-owned Random Encounter pools ignoring active Type Locke, No Legendaries, No Mythicals, No Pseudos, and Maximum BST legality.
- Reuses the same canonical `specialAcquisitionDenied(...)` gate already used by Random Starter instead of duplicating rule logic.
- Existing persisted random encounter slots are revalidated against the current candidate pool; saved choices that become illegal are deterministically replaced. Mid-run Type Locke/BST/species-ban edits now trigger immediate randomizer reapplication.
- If the legal species pool is empty, encounter randomization safely leaves/restores the vanilla encounter registry rather than crashing.
- Corrects inherited runtime build metadata that still reported 2.4.60 inside `main.lua` despite the 2.4.61 package manifest/docs.
- Future-schema downgrade-safety finding remains queued and is not mixed into this gameplay-rule interaction patch.
- Save Schema remains **4**, Compatibility API remains **27**, Diagnostics API remains **1**.

## 2.4.61 DEV — Permanent Rule Seal Write Ordering
- Strict child of **2.4.60 DEV**.
- Fixes dormant `persistPermanentRuleSeal()` ordering so durable `mod.storage` persistence must succeed before `mod.save` is marked permanently locked.
- Storage unavailable, missing-playthrough, thrown-write, and unsuccessful-write returns now leave the in-memory lock flags untouched.
- Preserves the 2.4.59 `pguard` storage diagnostic path.
- Permanent Rule Seal remains intentionally WIP-disabled; no intended live gameplay-rule behavior change.
- Save Schema remains **4**, Compatibility API remains **27**, Diagnostics API remains **1**.

## 2.4.60 DEV — Runtime Crash Diagnostic Capture
- Strict child of **2.4.59 DEV**.
- Routes full NUZ RULES/SETUP `update`/`draw` `xpcall` tracebacks into `Dev.recordError` before player-facing truncation.
- Applies the same capture to the independent NUZ STATUS screen runtime-failure path with distinct labels.
- Keeps existing deferred screen-recovery behavior intact and protects diagnostic reporting with `pcall`.
- No gameplay-rule, save-schema, Compatibility API, or Diagnostics API change.

## 2.4.59 DEV — Passive Dev Diagnostic Hardening
- Strict child of **2.4.58 DEV**.
- Adds recursion-safe `Dev.pguard()` so selected high-value guarded failures enter the existing Dev breadcrumb/error/snapshot pipeline without changing normal `pcall` return semantics.
- Instruments permanent-seal storage access, save-upgrade steps, compat loader/provider discovery, active-provider callbacks, recovery/context callbacks, and the fallback species-metadata provider signature.
- Preserves intentional provider signature fallback: the first species-metadata signature may fail normally; Dev reports only when the fallback call also throws.
- Adds read-only encounter-ledger assertions for `encounter_states`/`caught_areas` contradictions.
- Adds structural Shiny Clause assertions for malformed mode/used values without falsely warning when a player legitimately lowers a finite limit after prior uses.
- Does **not** wrap mechanics-capability calculation itself, avoiding recursive diagnostic snapshots.
- Preserves 2.4.58 full 48-breadcrumb export and bounded 16-report history unchanged.
- Corrects stale `mod.card` engine metadata to match the manifest range `>=0.1.86 <2.0.0`.
- Save Schema remains **4**, Compatibility API remains **27**, Diagnostics API remains **1**.

## 2.4.58 DEV — Encounter Provenance + Diagnostic History
- Strict child of **2.4.57 DEV**.
- Pins battle encounter provenance once; catch, failed-encounter, and Ball-legality accounting can no longer drift to later map/cardinal/Gold-time state.
- Keeps battle-less current-location queries live; death-location records explicitly remain live-location semantics.
- Dev reload distinguishes READ success from true write/read-back verification.
- Exports the full bounded 48-breadcrumb ring.
- Verified exports update `dev/self_test_latest` and also create a sequenced history record.
- Retains the newest 16 history reports per playthrough via official `mod.storage`.
- Save Schema remains **4**, Compatibility API remains **27**, engine range remains `>=0.1.86 <2.0.0`.

## 2.4.57 DEV — Launcher Range + Capture Ledger Integrity
- Strict child of **2.4.56 DEV**.
- Broadens `game_version` from `>=0.1.86 <0.2.5` to **`>=0.1.86 <2.0.0`** so compatible Gen1Recomp/launcher updates do not disable Nuzlocke merely for crossing the 0.2.x version line.
- Keeps Mod API **2** as the breaking mod-surface contract; the upper engine-major guard remains below 2.0.0.
- Adds monotonic capture-state reconciliation: successful consumed-catch evidence from `tracker_log` / `caught_areas` cannot be downgraded to FAILED by a delayed callback or conflicting reconstructed state.
- Reconciles `caught_areas`, `encounter_states`, and `encounter_area_state_ledger` before projection and before save writes.
- Does not invent tracker catches, reopen areas, or convert Shiny/exempt `consumedArea=false` catches into consumed slots.
- Save Schema remains **4** and Compatibility API remains **27**.

## 2.4.56 DEV — Documentation Integrity Reconciliation
- Strict child of **2.4.55 DEV**.
- Documentation/current-metadata reconciliation only; no gameplay semantics changed.
- Repaired historical version attribution and current-state documentation across the full package.
- Corrected engine/current contracts to audited Gen1Recomp **0.2.1**, Save Schema **4**, Compatibility API **27**, manifest range **`>=0.1.86 <0.2.5`**.
- Added a permanent rule forbidding blanket historical version replacement.

## 2.4.55 DEV — Fast Section Navigation
- Strict child of **2.4.54 DEV**.
- Added SELECT+UP/DOWN section-header jump with wraparound.
- Added SELECT+LEFT/RIGHT collapse-all / expand-all on section headers.

## 2.4.54 DEV — Rule-List Wraparound Navigation
- Strict child of **2.4.53 DEV**.
- UP from the first selectable row wraps to the last; DOWN from the last wraps to the first.

## 2.4.53 DEV — Historical Difficulty Scope Correction
- Strict child of **2.4.52 DEV**.
- Restored the intended historical profile set/names while keeping the deeper 2.4.52 trainer-team/moves/AI/boss/DV mechanics.

## 2.4.52 DEV — Deeper Historical Difficulty Mechanics
- Strict child of **2.4.51 DEV**.
- Added deeper boss-specific team/BST/move/AI/Stat EXP/DV/held-item tuning and selected-profile summaries.
- Temporary extra profile names from this build were removed in 2.4.53.

## 2.4.51 DEV — Gold-Only No Held Items
- Strict child of **2.4.50 DEV**.
- Added Gold-only No Held Items: GIVE blocked, TAKE preserved, existing player-held effects suppressed, enemy/trainer held items unaffected.

## 2.4.50 DEV — Gen1Recomp 0.2.1 Compatibility Consolidation
- Strict child of **2.4.49 DEV**.
- Confirmed 0.2.1 adds no additional mod-runtime migration beyond 0.2.0.

## 2.4.49 DEV — Gen1Recomp 0.2.x Compatibility Migration
- Strict child of **2.4.48 DEV**.
- Migrated Dev diagnostics persistence to official `mod.storage`.
- Removed legacy direct filesystem/clipboard persistence assumptions.

## 2.4.48 DEV — Native DEV TOOLS Cursor + Wrapped Info
- Strict child of **2.4.47 DEV**.
- Added native cursor glyphs and wrapped diagnostic info.

## 2.4.47 DEV — Verified Diagnostic Export + FILE INFO
- Strict child of **2.4.46 DEV**.
- Added legacy write/read-back verification and FILE INFO diagnostics.

## 2.4.46 DEV — Deterministic Self-Test File
- Strict child of **2.4.45 DEV**.
- Added deterministic legacy self-test file target; later superseded by `mod.storage`.

## 2.4.45 DEV — DEV TOOLS Layout Repair
- Strict child of **2.4.44 DEV**.
- Fixed R/B/Y DEV TOOLS geometry and added cached report viewer/copy controls.

## 2.4.44 DEV — Clipboard-First Diagnostics
- Strict child of **2.4.43 DEV**.
- Prioritized clipboard delivery; later superseded by official storage.

## 2.4.43 DEV — DEV TOOLS + Self-Test
- Strict child of **2.4.42 DEV**.
- Added dedicated Dev Mode tools screen and structural self-test.

## 2.4.42 DEV — Self-Test + Presentation-Control Unlock
- Strict child of **2.4.41 DEV**.
- Kept Level Cap Messages / Encounter Indicator editable after challenge sealing and added initial self-test wiring.

## 2.4.41 DEV — Rules Row Collision Fix
- Strict child of **2.4.40 DEV**.
- Fixed R/B/Y label/value overlap.

## 2.4.40 DEV — Lua Loadability Hotfix
- Strict child of **2.4.39 DEV**.
- Repaired the >200-local compiler failure from 2.4.38/2.4.39.

## 2.4.39 DEV — Encounter Tracker Death Projection
- Strict child of **2.4.38 DEV**.
- Added persistent-ID death projection; inherited 2.4.38 compiler-invalid state.

## 2.4.38 DEV — Encounter Indicator + Cap Message Frequency
- Strict child of **2.4.37 DEV**.
- Added encounter indicator and cap-message frequency.
- Historical compiler-invalid build due to >200 locals.

## 2.4.37 DEV — Forgiveness Modal UI Polish
- Strict child of **2.4.36 DEV**.
- Rebuilt the R/B/Y forgiveness prompt as an opaque framed modal.

## 2.4.36 DEV — Shiny / Encounter-Slot Integrity
- Strict child of **2.4.35 DEV**.
- Fixed finite Shiny Clause accounting and centralized caught/failed slot conflict semantics.

## 2.4.35 DEV — Developer Diagnostics Mode
- Strict child of **2.4.34 DEV**.
- Added default-OFF read-only diagnostics mode.

# 2.4.34 — Provider Capability Architecture + Gen9Dex Hardening

## 2.4.34 DEV

- Strict child of 2.4.33 DEV; no older branch restoration.
- Added a private mechanics-capability resolver so compatibility can distinguish battle-stat ownership, stat-growth ownership, native-DV identity, move-category ownership, and merged evolution data instead of treating an entire mod as one feature owner.
- Added a source-audited Gen9Dex / Gen 9 Battle Engine 1.2.0 Gold adapter. Its modern IV/EV/Nature battle-stat growth is treated separately from Gold native DVs, which remain meaningful for shiny/gender/Unown identity.
- Gold Player/Wild/Trainer Stat EXP starting controls and No Stat EXP Gain now delegate when Gen9Dex owns modern EV growth rather than misleadingly appearing to control the active growth system. Perfect native DVs remain available.
- Added a normalized species-facts surface over merged species/provider data for BST/types/category/evolution consumers.
- Evolution Limits NO FINAL now evaluates outgoing evolutions against the final merged evolution-method registry; dormant unsupported National-Dex evolution rows no longer make a currently terminal species look non-final.
- Added g9-battle-engine as an optional dependency for deterministic compatibility discovery.
- Save Schema remains 4 and Compatibility API remains 27; the new capability resolver is intentionally internal until its contract is runtime-proven.

# 2.4.33 — Save Editor / External Save-State Hardening

## 2.4.33 DEV

- Direct child of 2.4.32 DEV; no older branch was restored.
- Audited Gen1Recomp's built-in Save Editor mutation and save-serialization paths against Nuzlocke Save Schema 4.
- Added load/re-entry reconciliation so a Pokemon already marked `nuzlockeDead` cannot be resurrected by an external HP edit while Permadeath is active.
- Added non-destructive external party-cap reconciliation: parties above the selected Party Size Limit are reported in MOD COMPAT, but Nuzlocke never auto-boxes, deletes, reorders, or chooses which Pokemon to remove.
- Preserved the existing persistent identity model: `speciesAtRegistration` remains historical while `currentSpecies` follows external/in-game species changes.
- Preserved the persisted `EDITED` provenance token for backward compatibility while changing player-facing Nuz Info presentation to EXTERNAL; no encounter location or catch slot is fabricated for editor-added Pokemon.
- Added Save Editor audit/runtime requirements to compatibility, API, user-guide, confidence, and release-note documentation.
- Save Schema remains 4; Compatibility API remains 27.

# 2.4.32 — Quality of Life 1.3.0 Compatibility Hardening

## 2.4.32 DEV

- Direct child of 2.4.31 DEV.
- Added `quality_of_life` as an optional dependency and audited compatibility adapter target.
- Gen 1 Easy Interactions SELECT shortcut can no longer bypass active Travel Restrictions or Dungeon Lock-In; the external shortcut handler is conservatively suppressed instead of wrapping low-level story-sensitive transport methods.
- Gold remains on native field-move permission paths.
- Existing No Repels enforcement remains authoritative for the mod's Repel shortcut/refill paths.
- Updated compatibility ledger, user/API docs, release notes, and confidence guidance.
- Save Schema remains 4; Compatibility API remains 27.

# 2.4.31 — QoL Toggles 1.24.1 compatibility hardening

## 2.4.31 DEV

- Direct child of 2.4.30 DEV; no older branch was restored.
- Added an option-aware audited adapter for QoL Toggles 1.24.1 across Gen 1 + Gold.
- Added `qol_toggles` as an optional dependency for deterministic coexistence ordering.
- Hardened No Escape and Travel Restrictions / Dungeon Lock-In public veto hooks at restriction priority so external convenience wrappers cannot short-circuit active Nuzlocke policy.
- Guarded QoL Toggles AUTO-REPEL's direct exported consumption helper when No Repels is active.
- Delegates only the duplicate Automatic Running convenience control, and only while QoL Toggles `run_hold_b` is actually enabled; the stored Nuzlocke choice remains dormant and returns when external ownership ends.
- Did not broaden No Field Heal, No Gambling, Perfect DVs, Dupes Clause, or other rule semantics merely to match similarly named QoL options.
- Save Schema remains 4 and Compatibility API remains 27.
- Runtime combination validation remains TEST REQUIRED.

# 2.4.30 — Compatibility ledger stale-target refresh

## 2.4.30 DEV

- Direct child of 2.4.29 DEV; no older branch was restored.
- Re-audited Too Many Balls 0.6.1 (historically Kanto Balls). Current source supports Gen 1 + Gen 2 with generation-specific custom-ball mechanics; Nuzlocke retains generic semantic Ball/content compatibility and adds no named adapter.
- Re-audited Shiny Pokémon 1.0.8. R/B/Y shiny identity remains visible through native shiny DVs / `mon.shiny`; targeted Limited Shiny Clause + Randomizer runtime combination testing remains required. Gold is not certified by this audit.
- Marked Kanto Life and NPC Bubbles as UPSTREAM UNRESOLVED after a fresh resolution attempt could not identify canonical current upstreams from retained evidence. Historical architecture lessons are preserved without pretending to be current certification.
- Corrected stale current-build lineage wording carried in 2.4.29 metadata.
- No gameplay rules, save keys/schema, Compatibility API methods, engine range, dependencies, or package files changed.

# 2.4.29 — Maintained rule × game-family parity matrix

## 2.4.29 DEV

- Direct child of 2.4.28 DEV; no older branch was restored.
- Added the promised permanent rule × game-family parity matrix to the existing `docs/COMPATIBILITY.md`.
- Matrix records R/B/Y and Gold implementation state, enforcement/adaptation mechanism, runtime confidence, and intentional/upstream limitations for the current rule surface.
- Added a release gate: every future rule addition, removal, rename, game-family exposure change, or generation-specific enforcement change must update the matrix in the same child build.
- Clarified that matrix `✅` means an implementation exists; it does not promote a TEST REQUIRED path to runtime PASS.
- No gameplay mechanics changed. Save Schema remains 4; Compatibility API remains 27.
- Package file tree remains unchanged.

# 2.4.28 — Cross-version rule parity audit

## 2.4.28 DEV

- Direct child of **2.4.27 DEV**; no older branch was restored.
- Audited every exposed rule against R/B/Y and Gold/Gen2-specific data and execution seams.
- Gold now exposes shared rules that already had generation-neutral enforcement but were omitted from the Gold beta allowlist: **Route Forgiveness, Overworld Encounters, Town Catches, No Legendaries, No Mythicals, No Pseudos, Trainer Money, Solo Only, Randomizer Seed, Starter Style, Encounter Balance, Randomizer Info, Random Learnsets, and Learnset Gen**.
- Gold Random Learnsets now supports the native Gen2 `levelMoves` species data shape in addition to the Gen1 `level1Moves` / `learnset` shapes. Learn levels and row counts are preserved; only move ids are replaced through the existing deterministic LEARNSETS RNG stream.
- Added native Gen2 fallback classification for **Raikou, Entei, Suicune, Lugia, and Ho-Oh** as Legendaries and **Celebi** as Mythical. Merged provider metadata remains authoritative when present.
- Kept genuinely Kanto/R/B/Y-specific controls off the Gold surface: Route 2/10/20 splits, Mt. Moon splits, Safari Zone splits, Gym Guide Rare Candy, and R/B/Y-only starting Money/Poke Balls/Rare Candy. Wonderlocke remains WIP/disabled.
- Updated Gold parity metadata to `2.4.28`.
- Save schema remains **4** and Compatibility API remains **27**; no public provider contract or incompatible persisted structure changed.
- Runtime validation is required for the newly exposed Gold rules, especially Random Learnsets, Route Forgiveness rewards, Trainer Money, species bans, Solo Only, town/overworld capture policy, and randomizer sub-controls.

# 2.4.27 — Gold compact rule-label parity

## 2.4.27 DEV

- Direct child of 2.4.26 DEV; no older branch was restored.
- Ported the existing R/B/Y localization-safe compact-label fallback into Gold's native Setup and NUZ RULES renderer.
- Gold now prefers the full translated rule/category label whenever it fits the native field, then consults existing `shortName` / `shortTitle` only when needed.
- If a full label is translated but its shorthand is not, Gold keeps the translated full label and uses the existing marquee instead of substituting untranslated English shorthand.
- Rule values, descriptions, controls, save keys, presets, provider ownership, and gameplay enforcement are unchanged.
- Save schema remains 4; Compatibility API remains 27; package file set remains 15 files.
- Runtime visual confirmation required for Gold NEW GAME Setup and in-game NUZ RULES, including long translated labels and section headers.

# Nuzlocke 2.4.26 DEV — Chronological Changelog Normalization

2.4.26 is the strict child of 2.4.25 DEV and changes no gameplay behavior. This build completes the structural changelog repair by turning the cumulative historical record into one coherent newest-to-oldest sequence.

## Repaired chronology

- Reordered all recovered version blocks into descending version chronology instead of leaving beta.30.0.0.x / beta.30.1.x records stranded after the early-beta archive.
- Reconciled duplicate version headings while preserving unique historical notes under a single version block.
- Restored the missing **2.1.19 RC** heading from surviving contemporaneous documentation; its unique compatibility/lifecycle notes had survived in 2.4.25 but were incorrectly attached to 2.1.20.
- Preserved evidence qualifiers and intentionally missing-number gaps; no unsupported release details were invented.
- Preserved all historical version identities carried by 2.4.25, including internal beta.25 milestone labels such as 25D2/25D3/25D4 and 26B10.
- Added a minimal `2.0.0-beta.30.1.19` lineage heading because surviving packaged-revision evidence confirms the build existed; its exact delta remains intentionally unattributed.

## Permanent release gates

`CHANGELOG.md` remains append-only historical evidence. In addition to preserving every immediate-parent version identity, future candidates must now verify that:

1. version blocks are in newest-to-oldest order;
2. duplicate version identities are reconciled into one chronological block unless an explicitly documented internal milestone intentionally shares the public version number;
3. historical content is never moved below older versions by an append operation;
4. unique notes from a reconciled duplicate are retained.

## Validation

- Documentation/version reconciliation only; no challenge rule, save schema, compatibility API, engine range, or gameplay hook is intentionally changed.
- Package file set remains unchanged.

---

# Nuzlocke 2.4.25 DEV — Full Historical Changelog Restoration

2.4.25 is the strict child of 2.4.24 DEV and changes no gameplay behavior. This build repairs the changelog regression discovered after 2.4.24 by making the surviving pre-2.3.1 RC development history explicit, searchable, and protected from future truncation.

## Repaired historical record

- Reconciled the current changelog against surviving earlier changelog/handoff records and verified artifact provenance.
- Restored explicit visibility for the pre-2.3.1 RC development line, including the detailed 2.2.x and 2.1.x histories and the surviving 2.0.0-beta development records.
- Preserved evidence qualifiers such as **surviving snapshot**, **reconstructed**, **runtime PASS**, **TEST REQUIRED**, and known conflicting historical records. Missing exact deltas are not invented.
- Added the historical coverage index below so the older development line can no longer appear to vanish simply because archival entries were stranded far below later release sections.
- Corrected the current API document's stale build-contract label while performing the documentation reconciliation.

## Historical coverage index

The detailed entries remain in this same file. The currently recovered project record includes:

- **2.4.x:** 2.4.0 through 2.4.25 development/release work represented by surviving entries.
- **2.3.x:** 2.3.1 RC through the 2.3.35 RC stabilization/compatibility line plus the 2.3.12 final release.
- **2.2.x:** 2.2.0 through 2.2.21 RC, including Gen1Recomp compatibility, UI/runtime safety, Difficulty, cross-generation pools, Randomizer, Gym Team Size, intro/tutorial shortcuts, and interaction hardening.
- **2.1.x:** 2.1.0 through 2.1.24 where surviving records exist, including localization/UI repair, Type Locke expansion, Gold UI/runtime work, NUZ INFO/status recovery, and compatibility hardening.
- **beta.31:** surviving 2.0.0-beta.31.0.0 through 31.0.4 records.
- **beta.30:** surviving 30.0.0.x and 30.1.x records, including the compatibility/presentation/API development line.
- **beta.29:** surviving 29.0.x, 29.1.x, 29.2.x, and 29.3.x records.
- **beta.28 / beta.27 / beta.26 / beta.25:** surviving development and runtime-stabilization records.
- **early beta history:** surviving/reconstructed beta.1, .3, .4, .5, .8, .10, .11, .12, .14, .15, .16, .19, .20, .21, .22, .23, and .24 records.

Where an exact internal revision has no surviving changelog evidence, the file intentionally does **not** fabricate an entry merely to fill a numbering gap.

## Permanent changelog rule

`CHANGELOG.md` is now **append-only historical evidence**. Future builds may prepend new entries and may make narrowly documented factual corrections, but they must not truncate, replace wholesale, or silently collapse older version history. Before packaging, the immediate parent's historical version headings must be compared against the candidate; any disappearing historical heading is a release-gate failure unless its removal was explicitly approved as a duplicate correction and the unique historical information remains present elsewhere in this file.

## Validation

- Documentation/version reconciliation only; no challenge rule, save schema, compatibility API, engine range, or gameplay hook is intentionally changed.
- Package file set remains unchanged.

---

---

# Nuzlocke 2.4.24 DEV — Compatibility Research Ledger + Audit Governance

2.4.24 is the direct child of 2.4.23 DEV and intentionally changes no gameplay rule. It reconciles the project's compatibility history into a maintained ledger and formalizes when source research is allowed to become runtime integration code. Save schema remains 4 and the 15-file package set is unchanged.

## Documentation / compatibility process

- Added the maintained compatibility research ledger to `docs/COMPATIBILITY.md`. Each entry records the mod/tool, version last inspected, audit date/build, analysis type, Nuzlocke treatment, runtime status, known limitations, and re-audit trigger.
- Added a standing project rule that every future compatibility/learning pass updates the ledger in the same build. Static/source review, architecture/learning research, design inspiration, and runtime-confirmed compatibility are separate evidence levels.
- Added current ledger entries for All Pokémon Catchable 151, Gen1Recomp Content Editor, Trainer Talk 0.2.6, Spaceworld Sprites 1.0, and Gen2-3D-Sprites / Stadium 2 Overworld Models 0.2.81, while retaining earlier audited integrations and research targets.
- Recorded Gen2-3D-Sprites' embedded Wilds/direct overworld-capture path as a targeted Gold runtime-test requirement, especially Party Size Limit, capture legality, Ball restrictions, encounter consumption, tracker area attribution, and Nuzlocke UI coexistence. No private/internal adapter is added without a demonstrated failure.
- Corrected stale 2.4.23 lineage comments/documentation that incorrectly named 2.4.21 as its parent; the true parent is 2.4.22.

## Validation

- Documentation/version reconciliation only; no challenge behavior or save data is intentionally changed.
- Runtime status of previously untested mod combinations remains TEST REQUIRED.

---

---

# Nuzlocke 2.4.23 DEV — Generic Content-Mod Compatibility Hardening

2.4.23 is the direct child of 2.4.22 DEV and adds no new challenge option. It hardens composition with ordinary API-2 content mods and editor-generated content.

## Hardened

- Tracker area discovery now also learns map IDs from merged encounter registries, covering content mods that publish encounters before/without a separately discoverable map registry row.
- Legendary/Mythical/Pseudo classification accepts common `tags`, `flags`, `traits`, and `categories` metadata collections in addition to dedicated booleans. Unknown classifications still fail open.
- Ball detection now accepts dedicated merged `balls` / `ballRegistry` / `ball_registry` registries as well as item metadata and legacy item-effect tables, so custom API-2 capture devices participate in semantic capture policy without hard-coded IDs.
- Existing merged BST/evolution/type handling and unknown-map support are preserved. Custom trainers are not guessed to be Gym Leaders; boss/cap ownership remains known-progression/provider driven.

## Compatibility policy

Ordinary content mods remain composers, not exclusive encounter or difficulty providers. Nuzlocke evaluates the final merged runtime world. Authored encounters remain intact with Random Encounters OFF; with Random Encounters ON, the player is explicitly asking Nuzlocke to randomize the merged tables.

## Validation

Static/source/package validation only. Runtime confirmation remains required with an encounter-expansion mod and with an editor-generated mod containing a custom map, custom species metadata, and a custom Ball. Save schema and package file set are unchanged.

---

---

# 2.4.22 — General Party Size Limit

Direct child of 2.4.21 DEV.

- Added `Party Size Limit` with selectable active-party capacity 1–6.
- Default 6 preserves vanilla party capacity and full-party auto-box behavior.
- Values below 6 gate catches, gifts, trades, and PC withdrawals before they can increase the active party past the cap.
- Preserved deposits and one-for-one PC moves/swaps; lowering the cap never destructively edits an existing oversized party.
- Extended the cooperative storage-transaction policy and native R/B/Y + Gold PC seams.
- Kept Solo Only, Gym Team Size, and Nuzlocke Loadouts independent.
- No save-schema or package-file-set change.
- Runtime status: TEST REQUIRED in R/B/Y and Gold.

---

# 2.4.21 — Travel Restrictions

Direct child of 2.4.20 DEV.

- Added `Travel Restrictions` with `NORMAL / NO FLY / NO FLY+TELEPORT`.
- Reused the existing shared `fieldmove.eligibility` seam instead of adding a second field-move wrapper.
- NO FLY blocks only player-invoked Fly while Nuzlocke is active; NO FLY+TELEPORT blocks Fly and Teleport.
- Preserved Dig, Escape Rope, scripted/story transportation, map warps, trains, ferries, and unrelated travel.
- Preserved Dungeon Lock-In's independent DIG/TELEPORT/FLY blocking while its entrance lock is active.
- Kept Travel Restrictions outside Nuzlocke Loadout ownership.
- Default is NORMAL; no save-schema change.
- Runtime status: TEST REQUIRED in R/B/Y and Gold.

---

# 2.4.20 — Limited Shiny Clause

Direct child of 2.4.19 DEV.

## Added / changed

- Upgraded Shiny Clause to `OFF / 1 / 2 / 3 / UNLIMITED`.
- Added persistent `shiny_clause_used` run telemetry.
- Successful shiny exceptions consume exactly one limited allowance; failed catch attempts do not.
- Historical boolean ON is read as UNLIMITED and OFF as OFF, preserving old-save behavior without a schema bump.
- Exhausted limited clauses stop bypassing area/Failed Encounter/Dupes restrictions.
- Mid-run limit changes do not reset the used counter.
- Shiny Clause remains outside Nuzlocke Loadout ownership.

## Validation

- Save schema unchanged.
- Package file set unchanged.
- Runtime R/B/Y + Gold confirmation required.

---

# 2.4.19 — Evolution Limits

Direct child of 2.4.18 DEV.

## Added

- Added **Evolution Limits** with NORMAL / NO FINAL / NO EVOLUTION for R/B/Y and beta Gold.
- NORMAL preserves vanilla evolution behavior and is the absent-key/default value.
- NO FINAL blocks evolution into a terminal target derived from the live merged `pokemon[*].evolutions` graph; branching targets are evaluated independently.
- NO EVOLUTION blocks all ordinary evolution decisions while Nuzlocke is active.
- Unknown/incomplete mod-added target metadata fails open instead of being guessed terminal.
- Enforcement uses the public shared `evolution.check` hook.
- Evolution Limits remains independent of Nuzlocke Loadout preset ownership.

## Validation

- Save schema unchanged.
- Package file set unchanged.
- Runtime R/B/Y + Gold confirmation required.

---

# 2.4.18 — Nuzlocke Loadout synchronization

Direct child of 2.4.17 DEV.

## Added / changed

- Added **VANILLA** loadout with neutral values for only loadout-owned challenge rules.
- Added pre-apply loadout confirmation showing the number of rules that will change and a compact affected-rule preview; Cancel is non-destructive.
- Manual edits to loadout-owned rules now reclassify to the exact matching preset or CUSTOM.
- Independent rules no longer force a loadout to CUSTOM.
- Reduced loadout ownership to the actual challenge footprint; Dupes, Shiny Clause, Type Locke, Maximum BST, glitch handling, Gym/Dungeon Lock-In, Difficulty, Randomizer, World Building, QoL, UI, area splits, Badge Boosts, and other independent options are not preset-owned.
- Preserved historical saved IDs 1-4 for NUZLOCKE/HARDCORE/SOLO/IRONMON; VANILLA is ID 5 and is inserted first only in UI cycle order.
- Preset application skips externally delegated rules and matching ignores those delegated rows.

## Validation

- Save schema unchanged.
- Package file set unchanged.
- Runtime R/B/Y + Gold confirmation required.

---

# 2.4.17 — Badge Boosts toggle

Direct child of 2.4.16 DEV.

## Added

- Added **Badge Boosts ON/OFF** under Battle Mechanics for R/B/Y and beta Gold.
- Default is ON, preserving vanilla behavior and making absent-key/old-save migration safe.
- OFF reuses the existing battle-only badge-boost suppression machinery; earned badges and overworld progression are untouched.
- Built-in difficulty composition is restrictive: either Badge Boosts OFF or a profile with `noBadgeBoosts=true` suppresses boosts.
- Active-rule status shows **No Badge Boosts** only while the user-facing rule is OFF.

## Scope / validation

- No other backlog feature was implemented.
- Save schema remains 4 and the package file set is unchanged.
- Source/static validation only until R/B/Y and Gold runtime tests confirm ON/OFF behavior.

---

# 2.4.16 — Gen1 numeric edit-hint repair

Direct child of 2.4.15 DEV.

## Fixed

- R/B/Y numeric rule edit mode no longer hides its control instructions behind unreachable draw logic.
- The edit hint is now rendered inside the selected numeric-rule branch, where `editingNumber` can actually be true.
- Numeric edit controls themselves are unchanged: Left/Right select a digit, Up/Down change the value, A confirms, and B backs out.
- Gold's already-working edit-mode hint path is unchanged.

## Validation

- Static/syntax smoke only; runtime R/B/Y UI confirmation remains TEST REQUIRED.
- Save schema remains 4 and package file set is unchanged.

---

# 2.4.15 — G1RecompMods compatibility hardening

Direct child of 2.4.14 DEV.

- Audited `zeak6464/G1RecompMods`, focusing on Delta Type 1.2.0, Dex Overflow 0.1.1, Safari Zone All 1.1.0, and Wonder Trade 1.2.1.
- Added `typeLockAllowsPokemon(game, mon)` and changed concrete-mon legality paths to prefer runtime Pokémon typing over the base species record. This prevents transformed Pokémon from being judged by stale species typing while keeping starter/setup candidate checks species-based.
- Failed Encounter handling, live capture denial, acquisition evaluation when a mon object is supplied, and NUZ INFO legality now use the concrete-mon Type Locke evaluator.
- Added a separate Gold random-encounter runtime-safety check. Gold encounter randomization may now select complete merged species records without `def.index`, enabling string-id species such as Dex Overflow's runtime-safe additions.
- The relaxed index rule is intentionally limited to encounter-table replacement. Starter, script-byte, save-byte, and link assumptions are not globally relaxed.
- Wired audited local compatibility adapters into MOD COMPAT discovery when another mod publishes no explicit Nuzlocke relationship metadata. Explicit external declarations still win.
- Added scoped Safari All ownership metadata and observe-only Wonder Trade metadata.
- Added `delta_type`, `dex_overflow`, `safari_all`, and `wonder_trade` as optional dependencies for deterministic load ordering without making any required.
- Gen1Recomp audit target remains 0.1.99; manifest remains `>=0.1.86 <0.2.5`; save schema unchanged.
- All new combination behavior is **TEST REQUIRED**. No new runtime PASS is claimed.

---

# 2.4.14 DEV — Gen1Recomp 0.1.99 documentation/compatibility cleanup

Direct child of 2.4.13.

- Source-audited the current Gen1Recomp 0.1.99 mod-author documentation, Gen2 compatibility matrix, registries, manifest/link semantics, public battle/field APIs, and current source-level hook additions relevant to Nuzlocke.
- Updated executable audited-engine metadata from 0.1.98 to 0.1.99 and added a dedicated 0.1.99 compatibility profile.
- Corrected `contextual_field_actions` metadata to `transitive_native_guard`; Nuzlocke does not wrap `mod.world:useFieldAction` itself.
- Records the new Gen 1 `item.use` BagMenu-dispatch hook as available but not authoritative; existing item policy enforcement remains unchanged.
- Records shared `battle.bottom_ui_visible` and `battle.status_hud_visible` presentation seams for battle-HUD coexistence/future encounter-HUD work.
- Added explicit `affects_link: true` because Nuzlocke modifies battle decisions and must participate in Gen1Recomp link fingerprinting.
- Fixed `mod.card`: historical text outside its Lua return table made the 2.4.13 card unparsable.
- Rebuilt current README/API/compatibility/user-guide/confidence documentation around actual 2.4.14 code and reconciled the planned backlog against implemented features.
- Clarified that Permanent Rule Seal has retained durable implementation but is currently WIP-disabled.
- Reviewed AIRivials 2.1.0 and Floating Battle HUD 0.5.7 at the accessible release/repository level; no speculative adapters were added because current implementation source lives in release assets unavailable to the connected source audit.
- All five shipped `.lua` files and repaired `mod.card` pass available `texlua` syntax/loadfile checks. `manifest.json` parses and all literal package-local `mod:read()` targets exist.
- Package file tree remains unchanged at 15 files; save schema remains 4.
- Full Gen1Recomp `modkit validate/lint/gen2check` and runtime certification remain unavailable/not run in this environment, so no new runtime PASS is claimed.

### Reconciled historical subrecord — 2.4.14 — Gen1Recomp 0.1.99 documentation + compatibility cleanup

Direct child of 2.4.13.

- Synchronized current compatibility metadata/docs to Gen1Recomp 0.1.99.
- Corrected contextual field-action ownership metadata to `transitive_native_guard`.
- Recognized the Gen 1 `item.use` dispatch and shared battle HUD visibility hooks without replacing protected enforcement paths.
- Explicitly declared `affects_link=true` for link fingerprint safety.
- Repaired malformed `mod.card` content and reconciled active documentation/backlog state.
- No gameplay-rule or save-schema rewrite; no new runtime PASS claimed.

---

# 2.4.13 — dedicated Gold parity pass

Direct child of 2.4.12.

- Audited the shared R/B/Y rule surface against Gold's implemented adapters and policy seams.
- Fixed a real Gold parity/UI gap: four rules that already had shared Gold-capable enforcement were omitted from `goldBetaRules` and therefore could not be configured from Gold's reduced rule surface.
- Gold now exposes **No Healing Items**, **No X Items**, **No Center Heal**, and **No Mom Heal**.
- Added Gold-specific descriptions for all four newly exposed rules.
- No new enforcement subsystem was invented: battle item legality continues through the shared item-use policy, while Center/Mom healing continues through the existing shared healing-service gates.
- Updated the exported Gold compatibility contract to identify battle-item and healing-service parity surfaces.
- Preserves Kanto Ascendant 6.5.4, Wilds of Kanto 2.1.7, and Modern Party UI 0.3.8 compatibility work from prior builds.
- Manifest remains `>=0.1.86 <0.2.5`, five patch versions ahead of the audited Gen1Recomp 0.1.99 engine.
- Save schema unchanged.
- Newly exposed Gold rule paths remain **TEST REQUIRED** until runtime validated.

---

# 2.4.12 — Kanto Ascendant 6.5.4 compatibility

Direct child of 2.4.11.

- Re-audited Kanto Ascendant against the v6.5.4 source/tag.
- Explicitly classifies Kanto Ascendant as an external difficulty owner for its badge-phased trainer and wild level transforms.
- Explicitly classifies Kanto Ascendant as a Trainer Card presentation owner.
- Prevents Nuzlocke compatibility composition from treating Ascendant-owned difficulty surfaces as unclaimed and reduces the risk of double-transforming trainer/wild difficulty when Ascendant is the selected external provider.
- Leaves Ascendant's `trainer.party`, `encounter.species`, deterministic randomizer, Johto pool expansion, protected encounters, followers, Archive PC, and storage behavior untouched.
- Preserves the 2.4.11 Wilds of Kanto and Modern Party UI adapters.
- Manifest remains `>=0.1.86 <0.2.5` under the five-versions-ahead project rule.
- Save schema unchanged.
- Kanto Ascendant 6.5.4 coexistence is **TEST REQUIRED**; no runtime PASS is claimed yet.

---

# 2.4.11 — Wilds of Kanto + Modern Party UI compatibility

Direct child of 2.4.10.

- Added an audited compatibility adapter for **Wilds of Kanto 2.1.7** (`overworld_wild_spawns`).
- Wilds overworld Ball catches now consult Nuzlocke capture policy before the Pokémon is granted. Denied catches are converted to Wilds' normal escape path and the consumed Ball is refunded.
- Successful Wilds overworld catches are routed through Nuzlocke's existing `pokemon.caught` tracker/provenance path so One Per Area, tracker history, Catch Info, shiny/dupes metadata, and provider provenance use the same registration code as normal catches.
- Added explicit **Modern Party UI 0.3.8** (`modern_party_ui`) compatibility classification. It is treated as party presentation only; Nuzlocke does not replace or double-wrap its preserved engine party controller.
- Added both mods as optional dependencies so load ordering is explicit without making either mod required.
- Preserves 2.4.10 Forgiveness Token pricing behavior and all prior runtime-PASS behavior.
- Manifest remains `>=0.1.86 <0.2.5` under the five-versions-ahead project rule.
- Save schema unchanged.
- Wilds overworld-catching integration and Modern Party UI coexistence are **TEST REQUIRED**; no runtime PASS is claimed yet.

---

# 2.4.10 — Forgiveness Token million-price purchase path

Direct child of 2.4.9 RC.

- Preserves the intentional advertised Forgiveness Token price of **¥1,000,000**.
- Adds a token-specific cap-aware settlement path instead of lowering the token to ¥100,000 or raising the global wallet ceiling.
- On engines with the native ¥999,999 wallet ceiling, a full wallet is the representable settlement requirement; purchasing consumes that full wallet while the Mart continues to present **¥1,000,000**.
- Normal Mart prices, ordinary item purchases, Trainer Money, and the global wallet ceiling are unchanged.
- Keeps the 2.4.9 `noBadgeBoosts`/AI-tier decoupling and Forgiveness modal correction.
- Gen1Recomp 0.1.99 compatibility audit retained. Per project manifest policy, the forward declaration is now five patch versions ahead: `>=0.1.86 <0.2.5`.
- Save schema remains unchanged.
- R/B/Y million-price purchase path is **TEST REQUIRED**. Gold native Mart behavior remains **TEST REQUIRED**; no new Gold runtime PASS is claimed.

---

# 2.4.9 RC — difficulty hardening + Forgiveness modal correction

Direct child of 2.4.8 RC.

- Decoupled `noBadgeBoosts` from `aiTier`, so badge-boost suppression now applies independently even for future profiles with `aiTier = 0`.
- Gen 1 private battle badge state is cleared before the AI-tier gate; Gold no longer depends on `trainer.attributes` being available for the independent badge-boost flag.
- Corrected the R/B/Y Forgiveness prompt's opaque panel rendering: it now paints its own panel/window instead of calling nonexistent `mod.ui.clear` / `game:clear` APIs.
- Preserves the 2.4.8 RC Gen1Recomp `>=0.1.86 <0.2.1` compatibility range and all unrelated behavior.

---

# 2.4.8 RC — launcher compatibility + battle feedback cleanup

- Direct child of 2.4.7 RC.
- Expanded launch compatibility from `>=0.1.86 <0.1.99` to `>=0.1.86 <0.2.1`, fixing 0.1.99 rejection and explicitly allowing 0.2.0.
- Hardened the R/B/Y Forgive Encounter prompt as an opaque Nuzlocke-owned screen so underlying battle/party HUD content does not bleed through.
- Gym Team Size refusal text is now limited to once per individual trainer-battle attempt. There is no new setting/toggle. Enforcement remains active on every over-limit attempt.
- Added semantic encounter-count status based on the same authoritative encounter eligibility used by Failed Encounter/capture rules. Dupes and other free encounters are not marked as spending the area.
- No global battle/menu draw monkey-patches were added.
- Runtime validation required before publication.

---

# 2.4.7 RC — provider load-order metadata fix

- Direct child of 2.4.6 RC.
- Added `gen1_modern_ui` and `gen_2_randomizer_plus` to `optional_dependencies`; both are actively discovered with `mod.find`.
- They remain optional integrations.
- Chuck → Pryce → Jasmine progression is documented intentional behavior and is unchanged.
- No unrelated gameplay changes.

---

# 2.4.6 RC — Gym Forgiveness activity guard

- Direct child of 2.4.5 RC.
- Fixed the confirmed missing `d.active()` guard in `awardGymLeaderForgiveness`.
- Demo/ghost battles are rejected before the one-shot Gym reward ledger/token path.
- Focused trainer-reward ledger audit found no second same-confidence defect.
- No unrelated gameplay changes.

---

# 2.4.5 RC — Summon / Quest System compatibility pass

- Direct child of the exact uploaded 2.4.4 RC.
- Source-reviewed Summon 1.0.2 and Quest System 1.0.5.
- Summon now classifies as both external encounter start and targeted encounter selector.
- Quest System now classifies as quest framework/presentation rather than generic quest-content ownership.
- Individual quest/source mods retain their own content and reward ownership.
- MOD COMPAT adds QUEST UI and QUEST DATA ownership rows.
- No named-mod gameplay enforcement branches added.
- Wide Menus runtime PASS remains protected and its integration code is unchanged.
- Runtime testing required before publication.

---

# 2.4.4 RC — Catch Helper / Area DexNav compatibility pass

- Direct child of 2.4.3 RC.
- Source-reviewed Catch Helper 1.4.0 and Area DexNav 1.0.0.
- Catch Helper is classified as capture mechanics + battle information because current 1.4.0 both displays live catch odds and intentionally retunes Ultra Ball HP-factor behavior.
- Area DexNav is classified as an encounter selector in addition to an external encounter starter.
- Added generic cooperative targeted-encounter selection policy for randomized BLIND INFO.
- Ordinary random encounters are never blocked by BLIND INFO.
- Under BLIND randomized encounters, compatible targeted selectors are asked not to deliberately choose an undiscovered hidden species; they can fall back to a normal random encounter.
- EncounterAPI now exposes/uses the targeted selection policy when a provider opts into targeted-selection context.
- MOD COMPAT adds ENC SELECT / CATCH ODDS / CATCH RULES ownership rows.
- Nuzlocke random encounters already mutate the final live encounter registry that Area DexNav reads, so no second/randomizer-specific registry was introduced.
- Catch Helper reads the already-active battle; BLIND INFO does not hide catch odds after the encounter is visibly underway.
- No hardcoded runtime branch for Catch Helper or Area DexNav.
- Wide Menus runtime PASS remains protected; tracker code unchanged.
- Runtime combination testing required before publication.

---

# 2.4.3 RC — Item Shortcut / Reusable Machines compatibility pass

- Direct child of 2.4.2 RC.
- Runtime report: latest parent build no longer crashes with Wide Menus. This is now recorded as a protected runtime PASS; 2.4.3 does not touch tracker/Wide Menus code.
- Source-reviewed Item Shortcut 1.4.0 and Reusable Machines 1.0.1.
- Corrected legacy capability classification: Item Shortcut is no longer reported as the Bag presentation owner.
- `AUTOMATIC_ITEM_USE` now canonicalizes to `item_use_entrypoint` instead of broad `item_provider`.
- `MACHINE_PROVIDER` now canonicalizes to `machine_mechanics` instead of broad `item_provider`.
- MOD COMPAT adds ITEM USE and MACHINES ownership rows while keeping ITEM RULES Nuzlocke-owned.
- Item Shortcut's reviewed direct/FAST use path intentionally re-enters the standard Bag USE flow, so Nuzlocke's ItemEffects legality gate remains authoritative.
- Reusable Machines starts its reusable-TM session from the normal TM/Party teaching flow; No TMs therefore remains upstream of the reusable-consumption behavior.
- No hardcoded enforcement branch for either mod.
- Runtime combination tests required before publication.

---

# 2.4.2 RC — Modern Bag / EXP Share compatibility pass

- Direct child of 2.4.1 RC; preserves the 2.4.1 Difficulty/cap fix.
- Modern Bag current indexed release 1.5.2 reviewed; index/release metadata is newer than the browsable source folder, so current-source status is not overstated.
- EXP Share Modes 1.0.0 current source reviewed.
- Legacy auto-compat discovery now prefers Gen1Recomp's authoritative loaded-mod graph.
- Split alternate Bag presentation ownership from item mechanics and Nuzlocke item policy.
- MOD COMPAT adds BAG UI / ITEM RULES / EXP DIST. / EXP CAP ownership rows and explanations.
- `nuzlocke.experience` is now API 2; its capAward/evaluateAward/preflight helper returns a real read-only cap ceiling instead of always allowing the requested EXP.
- Canonical Experience.apply -> exp.gain remains the preferred EXP path.
- No mod-specific gameplay enforcement branches added.
- Runtime combination testing required before publication.

---

# 2.4.1 RC — Difficulty/cap direct-party fix

- Direct child of published 2.4.0.
- Confirmed 2.4.0 bug: changing built-in Game Difficulty could leave NUZ STATUS NEXT CAP and the shared level-cap enforcement source at vanilla values.
- Root cause: R/B/Y trainer parties are commonly direct arrays at `trainer.parties[partyIndex]`; the cap reader selected that array and then incorrectly required a nested `.party/.roster/.team`, producing nil.
- `liveTrainerAce()` now uses the existing canonical `baseTrainerParty()` reader and `composedTrainerParty()` transaction already used by Gym Team Size.
- NEXT CAP, EXP edging, Rare Candy cap enforcement, Trainer Card/status consumers, and actual battle composition now derive from the same composed trainer-party shape.
- Defensive fallback also accepts direct-array party rows.
- Executable Lua regression harness PASS: stable Difficulty selection changes representative Yellow boss caps and projected caps match composed battle aces.
- Real in-game Yellow runtime confirmation is still required before any 2.4.1 publication.
- No save schema, Compatibility API number, package tree, or engine range change.

---

# 2.4.0 — published release

**Direct promotion of 2.3.35 RC. No additional runtime/gameplay behavior was changed during promotion.**

2.4.0 is the first published release after 2.3.12 and consolidates the 2.3.13–2.3.35 development line.

## Highlights since 2.3.12

### Stability and presentation
- Reworked R/B/Y ENC TRACKER presentation after runtime isolation of Wide Menus interactions; the final native-size tracker no longer shows the shrink regression seen during development.
- Fixed recurring ordinary-Pokémon `DETAIL SAFE MODE` in NUZ INFO.
- Added real R/B/Y NUZ INFO Catch / Stat / Move pages with A / Left / Right paging.
- Centered/bolded NUZ INFO and page titles with subtle glyph tracking while keeping data labels normal-weight.
- Reworked MOVE INFO into compact three-line cards to avoid overlapping move/type/stat text.
- Rebuilt MOD COMPAT into a readable RULE/OWNER ownership view with contextual plain-language help and Select/Tab detail paging.
- Added native-style `ACTIVE RULES:` emphasis to NUZ STATUS.
- Shortened constrained UI labels including `F. TOKEN`, `Rndm Seed`, `Rndm Strtr`, `Strtr Style`, and R/B/Y `NUZ STS.`.

### Randomizer
- Fixed manual Random Seed numeric storage and live reapply.
- Fixed Starter Style / Encounter Balance / Gold Egg Encounter / Bug Contest multi-choice setters.
- Added dependent Randomizer UI:
  - Random Starter -> Starter Style
  - Random Encounters -> Encounter Balance / Randomizer Info / Species Pool
  - Random Learnsets -> Learnset Gen
- Child selections remain saved while hidden and become inactive while the parent is OFF.
- Species Pool now belongs only to Random Encounters; Random Starter uses Starter Style over the full legal live pool.
- Added OPEN INFO / BLIND INFO encounter-information policy for compatible information tools.
- Fixed RNG Info OPEN/BLIND numeric cycling.

### Difficulty and level caps
- Fixed phantom Indigo Conference / IronMON / historical-provider warnings; historical IDs are recognition hints only and now require a real loaded mod.
- Added direct built-in Difficulty cap projection through the same composed trainer roster used by actual battles.
- Kept generic trainer-provider composition for external difficulty mods.
- Improved live Difficulty switching and boss-cap cache invalidation.

### Gym / challenge enforcement
- Dungeon Lock-In now reconciles transient lock state against the actual entered map, including compatible third-party map changes.
- Yellow runtime confirmed Gym Lock-In works.
- Fixed Gym Team Size enforcement at Gen1Recomp's real `trainer.before_battle` seam so normal R/B/Y Gym Leader dialogue cannot bypass the cap.
- Gym Team Size counts every carried non-Egg Pokémon, including fainted/dead party slots.
- Over-cap Leaders refuse the battle with tiered world-building dialogue before trainer-battle creation.
- No Fishing moved to GENERAL directly below No Static Enc.

### Compatibility and provider semantics
- Added first-class `trainer_capture` acquisition provenance for trainer catches / Snag-style integrations.
- No Catching now understands trainer captures.
- Public Ball classification became semantic: item metadata, Gold Ball pocket data, and registered item effects can identify compatible custom Balls.
- Added provider-agnostic learnset ownership/delegation hardening.
- Hardened capture policy for area-less compatible/provider battles.
- Fixed starter/gift/trade provenance ordering and duplicate starter fallback behavior.
- Upgraded storage transaction policy to API 2 with semantic WITHDRAW / DEPOSIT / RELEASE / SWAP and incoming-Pokémon legality parity.
- Added final composed encounter registry and encounter-information policy helpers.
- Added semantic translation source/catalog exports for Nuzlocke-owned UI strings.
- Added generic `nuzlocke_ui` screen ownership metadata for rules, tracker, and MOD COMPAT presenters.
- Consolidated compatibility documentation and source/release/runtime-evidence terminology.
- Reviewed current compatibility behavior/lessons for Pokémon Snag, Too Many Balls, Translation Generator, Shiny Pokémon, Weather FX, Gen 3 Inspired UI, Advanced Box System, Pokédex Plus, and historical IronMON / Enemy HP evidence.

### Gold
- Fixed Gold Egg Encounter / Bug Contest selectors.
- Fixed Gold Physical/Special Split temporary-state isolation.
- Fixed Gold egg provenance so eggs do not create synthetic UNKNOWN encounter areas.
- Improved Gold status/rule label clipping.
- Preserved Gold beta support and boot-safe initialization.

### Forgiveness Token / item rules
- Fixed the actual trainer-reward item definition and mart presentation to use `F. TOKEN`.
- Yellow runtime confirmed a full bag does not lose the Route Forgiveness Token reward; the Leader offers it again later.
- Yellow runtime confirmed No Rare Candy blocks candy use with explanatory dialogue after level-cap progression.

## Runtime-confirmed release-line results

Confirmed during the 2.3.13–2.3.35 development line:
- Yellow boot / fresh setup / existing save path inherited from 2.3.12 remains protected.
- Gold NEW GAME boot path remains protected.
- Yellow Gym Lock-In: PASS.
- Dependent Randomizer child-row hiding/restoration: PASS.
- Phantom Indigo/IronMON Difficulty warnings: fixed in runtime.
- NUZ STATUS presentation: improved in runtime.
- R/B/Y MOD COMPAT physical size: PASS.
- R/B/Y ENC TRACKER physical size: PASS.
- R/B/Y NUZ INFO page switching: PASS.
- `F. TOKEN` mart label: PASS.
- Route Forgiveness Token full-bag retry: PASS.
- No Rare Candy veto + explanatory dialogue: PASS.
- MOVE INFO is substantially improved and accepted for this release; more cosmetic refinement may follow later.

## Still recommended for broader validation
- Re-test the 2.3.32+ Gym Team Size refusal path across multiple Leaders/games.
- Continue broad Red / Blue / Yellow / Gold compatibility matrix testing before major feature expansion.
- Gold remains beta support.

---

---

# 2.3.35 RC — MOVE INFO overlap fix

- Direct child of 2.3.34 RC.
- Runtime feedback reports the rest of the recent NUZ INFO / MOD COMPAT presentation work improved; MOVE INFO remained the visible problem.
- Reworked MOVE INFO cards to a single-column three-line layout:
  - move number + name
  - TYPE + type name
  - compact `P / A / PP` stats
- Removed the competing TYPE/PWR and ACC/PP split columns that still overlapped on the native 160x144 surface.
- Long type/stat lines use the existing marquee-safe renderer rather than colliding.
- Two moves remain visible at once; Up/Down still reaches moves 3-4.
- No gameplay rules, move data, save schema, Compatibility API number, package tree, or engine range changed.

---

# 2.3.34 RC — NUZ INFO / MOD COMPAT runtime presentation follow-up

- Direct child of 2.3.33 RC.
- Recorded Yellow 2.3.32 MOD COMPAT physical-size fix as runtime PASS.
- Recorded Yellow 2.3.32 ENC TRACKER physical-size fix as runtime PASS.
- Recorded Yellow 2.3.32 F. TOKEN mart label as runtime PASS.
- Recorded R/B/Y NUZ INFO Catch/Stat/Move page switching as runtime PASS.
- MOD COMPAT bottom explanation now preserves the full wrapped text and pages it with Select/Tab, three lines at a time; moving to another ownership row resets detail paging to page 1.
- NUZ INFO and current page titles remain bold/centered but now use subtle 1-pixel glyph tracking instead of literal added spaces.
- Removed bold echo from Catch/Stat left-column labels; titles are the only bold elements.
- Rebuilt MOVE INFO as two visible three-line move cards: name, TYPE/PWR, ACC/PP. Long move names get the full name row and marquee instead of colliding with type text.
- Move 3/4 remain reachable with normal Up/Down scrolling.
- No gameplay rules, save schema, Compatibility API number, package tree, or engine range changed.

---

# 2.3.33 RC — Yellow runtime follow-up

- Direct child of 2.3.32 RC.
- Recorded Yellow 2.3.30 Route Forgiveness Token full-bag retry as runtime PASS.
- Recorded Yellow 2.3.30 No Rare Candy enforcement/dialogue as runtime PASS.
- Moved No Fishing from FIELD ITEMS to GENERAL directly below No Static Enc.
- R/B/Y START-menu label `NUZ ST.` is now `NUZ STS.` for clearer meaning. Gold retains the shorter legacy label because its native START box has the tighter safe label width.
- Fixed built-in Game Difficulty cap preview: NUZ STATUS now previews Nuzlocke-owned profiles directly through the same `Difficulty.composeParty()` transformation used by the actual trainer battle.
- External trainer/difficulty mods retain generic `trainer.party` composition preview.
- Difficulty selection still clears observed boss-cap cache on every in-game profile change.
- No gameplay formula duplication, save schema change, Compatibility API bump, package-tree change, or engine-range change.
- 2.3.32 Gym Team Size fix remains TEST REQUIRED.

---

# 2.3.32 RC — Yellow Gym Team Size enforcement fix

- Direct child of 2.3.31 RC.
- Records Yellow 2.3.30 Gym Lock-In runtime PASS.
- Records Yellow 2.3.30 Brock Gym Team Size runtime FAIL.
- Added primary Gym Team Size enforcement at Gen1Recomp's `trainer.before_battle` seam used by normal R/B/Y Gym Leader interactions.
- Exact next-Leader trainer class and party index are required; ordinary Gym Trainers and unrelated trainer battles are unaffected.
- Over-cap battle creation is deferred, tiered world-building refusal text is shown, then the pending battle is cancelled before `BattleState.newTrainer`.
- Existing scripted `start_battle trainer` gate remains as compatibility coverage and now shares the same refusal text helper.
- Gym party count now means all carried non-Egg Pokémon, including fainted/Nuzlocke-dead party slots.
- Gym Lock-In implementation is untouched.
- No save schema, Compatibility API number, package tree, or engine range change.

---

# 2.3.31 RC — runtime-feedback stabilization pass

- Direct child of runtime-tested 2.3.30 RC.
- Restored native-size R/B/Y ENC TRACKER presentation; removed the shrink-causing 304x144 logical surface and returned the box to 20 columns.
- Restored native-size R/B/Y MOD COMPAT presentation while retaining host ListMenu ownership, RULE/OWNER headers, bold left labels and contextual help.
- R/B/Y NUZ INFO now has actual Catch / Stat / Move pages switchable with A or Left/Right.
- Centered/bolded NUZ INFO and current page titles; only the left information column is bold.
- Fixed Randomizer Info OPEN/BLIND selector by adding its missing numeric setter branch.
- Renamed Random Seed -> Rndm Seed, Random Starter -> Rndm Strtr, Starter Style -> Strtr Style in the visible rule surface.
- Changed the authoritative trainer-reward item-data name to F. TOKEN so the actual mart renderer receives the compact label.
- Preserved confirmed 2.3.30 Difficulty/provider and dependent-row improvements.
- No save schema, Compatibility API number, package tree, or engine range change.

---

# 2.3.30 RC — dependency/UI and difficulty-warning stabilization

- Direct child of 2.3.29 RC.
- Fixed phantom Indigo Conference / IronMON / stronger-trainers difficulty-provider detection.
- Historical provider IDs now require a real loaded `mod.find(id)` result before entering the Difficulty selector or multi-mod warning path.
- Starter Style now hides while Random Starter is OFF.
- Encounter Balance and Randomizer Info now hide alongside Species Pool while Random Encounters is OFF.
- Learnset Gen remains hidden while Random Learnsets is OFF.
- Child selections remain saved and restore when their parent is enabled again.
- No gameplay provider is disabled or invented; active installed providers remain discoverable.
- No save-schema, Compatibility API-number, package-tree, or engine-range change.

---

# 2.3.29 RC — dependent randomizer controls + status polish

- Direct child of 2.3.28 RC.
- Species Pool is now owned only by Random Encounters.
- Learnset Gen is owned only by Random Learnsets.
- Both child rows hide dynamically in Setup and NUZ RULES while their parent is OFF.
- Hidden child selections remain saved and return when the parent is re-enabled.
- Hidden child selections have no runtime effect while their parent is OFF.
- Random Starter no longer consults Species Pool; Starter Style operates over the full legal live species pool.
- Added effective child-policy helpers and `getEffectiveRuleValue(...)` compatibility read.
- NUZ STATUS now shows bold-emphasized `ACTIVE RULES:`.
- No save schema, Compatibility API number, package tree, or engine-range change.

---

# 2.3.28 RC — MOD COMPAT presentation/accessibility pass

- Direct child of 2.3.27 RC.
- Keeps the stable host ListMenu as R/B/Y MOD COMPAT's state/input owner; does not restore the old crash-prone custom state.
- R/B/Y MOD COMPAT now owns a 304x144 presentation surface.
- Centered MOD COMPAT title and added explicit RULE / SYSTEM and OWNER headers.
- Bold-emphasized left-column rule/system labels.
- Added native cursor glyph selection, five-row scrolling, and left/right page movement.
- Added marquee-safe full-width rule and owner rendering.
- Added a bottom hover help panel explaining ownership relationships in plain language.
- Added semantic MOD COMPAT presentation metadata/model for compatible UI overhauls.
- No compatibility ownership, gameplay rule, save schema, Compatibility API number, package tree, or engine-range changes.

---

# 2.3.27 RC — NUZ INFO stabilization

- Direct child of 2.3.26 RC.
- Fixed ordinary R/B/Y Pokémon incorrectly falling into `DETAIL SAFE MODE`.
- Root cause was an early `getPokemonNuzInfo()` closure referencing the later local `Identity` module; Lua resolved a nil global before `pcall` could catch anything.
- The public NUZ INFO model now performs self-contained read-only shiny detection from explicit flags or the engine Stats DV predicate.
- Shortened only the constrained native Catch Info row label from `LOCATION` to `LOC.`.
- Added glyph-safe right-column fitting to R/B/Y native NUZ INFO rows to prevent label/value overlap.
- No gameplay shiny logic, legality rules, encounter behavior, save schema, Compatibility API number, package tree, or engine range changed.

---

# 2.3.26 RC — stabilization-only UI pass

- Direct child of 2.3.25 RC.
- Runtime report isolates the remaining ENC TRACKER crash to Wide Menus integration, not old Modern UI.
- Removed tracker-specific `wide-menus` detection/delegation.
- Removed the 20-vs-38-column Wide Menus draw branch.
- R/B/Y ENC TRACKER now always owns its 304x144 surface and 38-column box and marks itself classic/non-auto-widenable.
- Gold tracker presentation remains unchanged.
- Changed only the constrained shop-row Forgiveness Token label from `FORGIVE TOKEN` to `F. TOKEN`.
- Forgiveness Token price, quantity, purchase behavior, rule logic, dialogue, and descriptive naming are unchanged.
- No new gameplay features, save-schema change, Compatibility API-number change, package-tree change, or engine-range change.

---

# 2.3.25 RC — storage + encounter-information compatibility pass

- Direct child of 2.3.24 RC.
- Reviewed FAFF0x Advanced Box System 1.1.0 and Pokédex Plus 1.3.4.
- Upgraded `pcPolicy` to storage transaction API 2 with semantic WITHDRAW / DEPOSIT / RELEASE / SWAP normalization.
- Direct party/box SWAP now receives the same incoming-Pokémon legality check as WITHDRAW.
- Added begin/commit storage transaction events for provider-neutral composition.
- Added final composed encounter-registry information contract.
- Added Randomizer Info selector: OPEN INFO / BLIND INFO, default OPEN for backwards compatibility.
- BLIND INFO hides undiscovered randomized table data only through cooperative information APIs; it never alters the gameplay registry or encounter generation.
- No FAFF0x-specific runtime branches, save-schema change, Compatibility API-number change, package-tree change, or engine-range change.

---

# 2.3.24 RC — IronMON / Enemy HP upstream-resolution pass

- Direct child of 2.3.23 RC.
- Re-ran canonical-upstream discovery for historical IronMON Ultimate and Enemy HP compatibility entries.
- Confirmed surviving evidence only identifies IronMON Ultimate 0.4.20 as an evaluated package and Enemy HP as an uploaded/runtime-tested archive.
- GitHub, public-web, and File Library searches did not resolve trustworthy current Gen1Recomp repositories for either historical package.
- Kept the historical `ironmon_ultimate` provider ID compatibility path intact.
- Did not conflate the actively maintained community IronMON Ultimate challenge rules with the unresolved Gen1Recomp mod source.
- No gameplay, compatibility API, save schema, package tree, or engine-range changes.

---

# 2.3.23 RC — compatibility ledger consolidation

- Direct child of 2.3.22 RC.
- Consolidated the compatibility documentation into one canonical current ledger.
- Normalized current reviewed entries for Pokemon Snag 0.15.9, Too Many Balls 0.6.1, Translation Generator 0.7.0, Shiny Pokemon 1.0.1, Weather FX 2.6.0, and Gen 3 Inspired UI Overhaul 2.0.0.
- Explicitly marks IronMON Ultimate and Enemy HP as historical-package-only until their current canonical upstreams can be resolved and reviewed.
- Added compatibility-ledger policy separating source-reviewed, release-reviewed, expected-compatible, runtime-PASS, and historical evidence.
- No gameplay, UI behavior, API, save schema, package tree, or engine-range change.

---

# 2.3.22 RC — generic UI-overhaul compatibility contract

- Direct child of 2.3.21 RC.
- Reviewed absol89's Gen 3 Inspired UI fork (1.4.1) and the current HighDrexler parent (2.0.0).
- Added additive `nuzlocke_ui` API 1 describing Nuzlocke custom-screen presentation roles, state ownership, preferred layout, native fallback and semantic-adapter safety.
- NuzlockeConfigScreen and NuzlockeTrackerScreen now carry the same generic presentation metadata on their live screen instances.
- No Gen-3-UI-specific rule branch, gameplay ownership change, screen replacement, save-schema change, Compatibility API number change or package-tree change.

---

# 2.3.21 RC — Weather FX compatibility-learning pass

- Direct child of 2.3.20 RC.
- Reviewed Weather FX 2.6.0 release behavior.
- Added `map.entered` reconciliation for transient Dungeon Lock-In ownership so out-of-band map/teleport providers cannot leave a stale dungeon lock record active in the save.
- Reconciliation validates against the actual current dungeon family and also clears state when Nuzlocke/Dungeon Lock-In is disabled.
- Exported the reconciliation helper through the existing compatibility surface.
- No Weather-FX-specific enforcement branch, rule semantics, save-schema, Compatibility API number, package tree, or engine-range change.

---

# 2.3.20 RC — translation/performance compatibility learning pass

- Direct child of 2.3.19 RC.
- Reviewed gen1recomp-translation-mod-generator 0.7.0 and Shiny Pokemon 1.0.1.
- Added `nuzlocke_translation.sources()` and `catalog()` so translation tooling can enumerate live Nuzlocke section titles, rule names, short names, and descriptions from canonical rule definitions.
- ENC TRACKER now performs projection/cleanup/row preparation once per update and shares one read-only snapshot across native R/B/Y, Gold, and Modern UI presentation.
- Modern UI tracker model generation no longer mutates tracker/save state itself.
- Existing tracker-row helpers keep their original maintenance behavior for non-screen callers.
- No rule semantics, save schema, Compatibility API number, package tree, or engine range changed.

---

# 2.3.19 RC — recent-mod compatibility pass

- Direct child of 2.3.18 RC.
- Reviewed Pokemon Snag 0.15.9 and Too Many Balls 0.6.1.
- Added first-class `trainer_capture` acquisition semantics, including SNAG/TRAINER_CATCH aliases.
- Cooperative No Catching policy now covers trainer-capture attempts.
- Tracker provenance labels successful trainer-battle captures as `trainer_capture`.
- Public Item API now classifies custom Balls with the same semantic detector used by enforcement instead of a vanilla Ball ID list.
- Added descriptive legacy auto-compat hints for trainer-capture and custom-Ball providers.
- No mod-ID-specific enforcement branches, files, save-schema, or engine-range changes.

---

# 2.3.18 RC — smaller-risk presentation bug-fix pass

- Direct child of 2.3.17 RC.
- Fixed the R/B/Y Difficulty profile row's nil fallback displaying profile index 1 instead of VANILLA/index 0.
- Shared Nuzlocke marquee text now scrolls by engine font glyph spans rather than raw Lua bytes, preventing split UTF-8 translation characters.
- Recover Catches route-name fitting is now glyph-span safe.
- MOD COMPAT native fitting no longer byte-truncates translated text when font span helpers are unavailable.
- No rule, battle, save, encounter, provider, startup, API, schema, or package-tree changes.

---

# 2.3.17 RC — small bug-fix pass

- Direct child of 2.3.16 RC.
- Gold status/rule labels now clip with engine font glyph spans and pixel width instead of raw Lua byte counts, avoiding split UTF-8 translation characters.
- Gold egg provenance no longer registers or marks a synthetic UNKNOWN area as visited when current map resolution fails; UNKNOWN remains provenance-only.
- Removed a dead delegated-learnset condition after the authoritative-provider early return.
- No gameplay-rule, file-tree, API, or save-schema changes.

---

# 2.3.16 RC — medium-risk bug-fix pass

- Direct child of 2.3.15 RC.
- Completed nil-area capture-policy hardening in the actual catch path.
- Explicit gift/trade/prize provenance now outranks fallback starter heuristics.
- Repaired the logically unreachable duplicate-starter catch fallback.
- Gold Physical/Special Split now scopes temporary type/category changes to copied per-call damage data.
- No new features, files, API version, or save-schema changes.

---

# 2.3.15 RC — full bug-fixing pass

- Direct child of 2.3.14 RC.
- Fixed manual 8-digit Random Seed editing being coerced to boolean/0.
- Live Random Seed changes now re-project Nuzlocke-owned encounter and learnset randomization.
- Fixed Gold Egg Encounter and Bug Contest enum controls collapsing through the boolean setter path.
- Added semantic Gold labels for Egg Encounter and Bug Contest selections.
- Hardened external randomizer ownership: every delegated learnset provider now prevents Nuzlocke from restoring a stale local snapshot.
- Hardened capture legality when a custom/provider battle has no area key: only area-specific checks fail open; location-independent restrictions remain enforceable.
- Preserves 2.3.14 hold-B Running Shoes and ENC TRACKER/Wide Menus ownership behavior.
- No files added or removed; save schema remains 4; Compatibility API remains 27.

---

# 2.3.13 RC — ENC TRACKER hotfix candidate

- Direct child of the published 2.3.12 release.
- Corrects the diagnosis of the 2.3.12 ENC TRACKER crash: it reproduces with Modern UI disabled, while Wide Menus was observed to prevent it.
- R/B/Y ENC TRACKER now requests the same 304x144 UI surface that Wide Menus supplied on the working path.
- R/B/Y tracker full-screen box expands from 20 to 38 tiles to match that surface.
- Gold tracker presentation remains native 20x18 / 160x144.
- No tracker data, save, rule, input, boot-lifecycle, Compatibility API, or save-schema changes.
- Runtime validation required before promotion.

---

# 2.3.12 — final release

- Direct child of 2.3.11 RC.
- Promotes the runtime-tested 2.3.11 boot-safe full-feature code path to the final 2.3.12 release.
- No intentional gameplay/rule/save/API behavior changes from 2.3.11.
- Yellow + Gen1Recomp 0.1.98 runtime PASS: title boot, fresh-game SETUP, SETUP → NEW GAME, existing SAVE GAME load, and fresh-game-only SETUP gating.
- Gold NEW GAME runtime PASS on the same release-candidate code path.
- Preserves lifecycle-safe heavy-runtime activation at `game.ready`, lazy Stats/Growth loading, dormant legacy title fallback, and deferred optional Modern UI/Pokégear first-pass installation.
- Preserves the 2.3.2 Gold trainer-battle Ball-policy scoping correction.
- Corrects 2.3.11 documentation lineage: 2.3.11 descended from 2.3.10, with 2.3.9 used only as a boot-confirmed comparison point.
- No files added or removed; save schema remains 4; Compatibility API remains 27; engine support remains `>=0.1.86 <0.1.99`.
- Corrected after release: ENC TRACKER can crash with Modern UI disabled; Wide Menus was observed to mask the crash, so Modern UI is not established as the cause.

---

# 2.3.11 RC — full 2.3.0 feature restoration + Yellow 0.1.98 boot-safe initialization

- Direct child of 2.3.10 RC; 2.3.9 was the last boot-confirmed comparison point, and 2.3.0 was reference material only.
- Runtime ledger carried forward: Yellow 2.3.7 PASS to title; 2.3.8 PASS to title with the normal initializer; 2.3.9 PASS to title and public custom-setup screen.
- Restored the complete feature/rule/QoL/API surface that was present in the original 2.3.0 RC, including Skip Opening Intro and Quick Nuzlocke Start.
- Preserved the public `ui.title_menu.items` setup path proven by 2.3.9 and keeps the legacy `title_setup_compat.lua` engine-internal fallback dormant on startup.
- Replaced eager pre-title `src.pokemon.Stats` and `src.pokemon.Growth` imports with lazy, protected resolution at their actual use sites.
- Deferred No Day Care, Gold difficulty mechanics, item/field policy adapters, field-command patches, Center/Game Corner/shop gates, and Gold gameplay adapters to existing lifecycle retry points instead of installing them before title.
- Default-name adapters are installed when NEW GAME is selected and again at `game.ready`, avoiding pre-title OakSpeech/Gold World imports while preserving the feature.
- Gold title dispatch installation is requested only when the public title hook has identified Gold rather than probing Gen II menu modules on every game at startup.
- Preserved the 2.3.2 Gold trainer-battle Ball scoping fix: capture rules do not replace native trainer-battle Ball behavior.
- No files added or removed; save schema remains 4; engine support remains `>=0.1.86 <0.1.99`.
- Runtime validation is required before treating 2.3.11 as release-ready.


### Reconciled historical record: 2.3.11 RC


- Direct child of 2.3.10 RC; no rollback or wholesale branch restoration.
- Preserves the full restored 2.3.0 RC feature surface.
- Moves the first large runtime installation phase from entry-chunk execution to `game.ready`, after Gen1Recomp services initialize.
- Defers the optional Modern UI kerning/provider first pass and Pokégear provider first pass to lifecycle events instead of mod-load time.
- Keeps 2.3.10 boot protections: lazy Stats/Growth, deferred legacy title fallback, deferred Default Names/field/shop adapters, and the corrected Gold trainer-battle Ball policy.
- Yellow 0.1.98 boot result: TEST REQUIRED.


## Gold-native features

- Added Gold **Time Split** encounter projection with morning/day/night provenance and safe reprojection of existing encounter history.
- Added **Roamer Clause** with persistent species-specific encounter slots and free failed roamer meetings.
- Added **Egg Encounter** policies: OFF / RECEIVED / HATCHED / GIFT.
- Added **Bug Contest** policies: NORMAL / EXEMPT / SLOT, finalized from Gold's native `bug_contest.scored` seam.
- Added **Headbutt Split** using Gold's native Headbutt battle path.
- Added optional **Radio Nuzlocke** World Building through the existing Pokegear presentation provider; native station behavior remains owned by Gold.
- All new Gold rules default OFF/NORMAL and preserve R/B/Y behavior.

---

# 2.3.9 RC — public Yellow title/setup UI diagnostic

- Direct child of 2.3.8 RC.
- Yellow + Gen1Recomp 0.1.98 + Nuzlocke 2.3.8 only: **runtime PASS to title**.
- The absent Nuzlocke Setup row in 2.3.8 was expected because setup registration remained disabled.
- Restores only `src.core.Strings`, one minimal `NuzlockeConfigScreen`, and the public `ui.title_menu.items` hook that inserts SETUP before NEW GAME when CONTINUE is absent.
- Does **not** load `title_setup_compat.lua`, save/setup-profile state, gameplay events, rule enforcement, randomizers, or other split integrations.
- Test target: Yellow 0.1.98 should boot, show SETUP on a fresh title menu, open the diagnostic setup screen, allow basic cursor input, and return with B.

---

# 2.3.8 RC — initializer-boundary diagnostic

- Direct child of 2.3.7 RC.
- Yellow + Gen1Recomp 0.1.98 + Nuzlocke 2.3.7 only: **runtime PASS to title**.
- Restores only the normal `return function(mod) ... end` initializer execution model from 2.3.6.
- The initializer performs static export-table assignments only.
- No engine-module `require()`, event registration, save/storage access, hooks/patches, content writes, title modifications, or split integrations execute.
- Diagnostic only; gameplay remains intentionally disabled.
- No files added or removed.

---

# 2.3.7 RC — boot-safe loader diagnostic

- Direct child of 2.3.6 RC.
- Yellow 2.3.6 recorded as pre-title runtime FAIL.
- Replaced active `main.lua` execution with inert diagnostic exports only.
- No engine-internal requires, gameplay hooks, content writes, UI hooks, or split integrations execute.
- Package tree, manifest permissions, optional dependencies, game targets, and 0.1.98 engine range remain unchanged so the test isolates loader/package compatibility.
- Diagnostic only; gameplay is intentionally disabled.
- No files added or removed; save schema documentation remains historical and no save migration runs.

---

# 2.3.6 RC — pre-2.3 behavior compatibility probe

- Direct child of 2.3.5 RC.
- Yellow 2.3.5 recorded as pre-title runtime FAIL.
- Restored specific installer definitions/timing from the directly compared pre-2.3 baseline.
- Restored the existing title Setup compatibility fallback; this is separate from the deferred opening-intro shortcut.
- Repaired the accidentally removed `ItemPolicy.install()` definition from 2.3.3-2.3.5.
- Removed remaining 2.3-only Gen II healing-classifier additions for this diagnostic.
- Skip Opening Intro and Quick Nuzlocke Start remain removed.
- No files added or removed; save schema remains 4.

---

# 2.3.5 RC — 0.1.98 executable compatibility bisect

- Direct child of 2.3.4 RC.
- Yellow 2.3.4 recorded as pre-title runtime FAIL with all other mods disabled.
- Intro skip and Quick Start remain removed and are no longer the leading crash hypothesis.
- Temporarily disabled the executable 2.3.x public battle/contextual-field integrations and broad Gold item-policy additions while keeping 0.1.98 in the manifest range.
- Kept 2.3.3's safer deferred installer timing.
- No files added or removed; save schema remains 4.

---

# 2.3.4 RC — defer startup shortcuts / Yellow boot isolation

- Direct child of 2.3.3 RC.
- Removed active **Skip Opening Intro** implementation and setup control.
- Removed active **Quick Nuzlocke Start / Start With Poké Balls** implementation and setup control.
- Removed their Oak-speech step filtering, one-shot save staging, progression reconciliation, warp/nickname transaction, delegation entries, Gold exposure, and world-building text.
- Kept **Default Names** and **Skip Catch Demo** intact.
- Kept all unrelated 2.3.x Gen1Recomp 0.1.98 compatibility fixes.
- Yellow 2.3.3 pre-title crash recorded as runtime FAIL; 2.3.4 requires a title-screen-only retest.
- No files added or removed; save schema remains 4.

---

# 2.3.3 RC — Yellow pre-title boot-safety isolation

- Direct child of 2.3.2 RC.
- 2.3.0, 2.3.1, and 2.3.2 recorded as Yellow pre-title runtime FAIL on Gen1Recomp 0.1.98 with other mods disabled.
- Disabled invocation of the legacy 0.1.86 TitleState fallback; public `ui.title_menu.items` remains authoritative.
- Deferred non-title engine-internal installers until map/save/battle lifecycle points.
- No files added or removed; save schema remains 4.

---

# 2.3.2 RC — Gold trainer-ball policy scoping

- Clarified that `wide-menus` remains an intentional optional dependency for passive classic-layout coexistence; the historical 304px claimed-wide adapter remains disabled.

- Direct child of 2.3.1 RC.
- Gold's broad 0.1.98 battle-item denial pass now skips Balls entirely; the existing catchable-battle branch is the sole owner of Ball/capture policy.
- Prevents `No Catching` or other capture-specific Nuzlocke text from replacing native trainer-battle Ball behavior.
- Uses dynamic `ItemPolicy.isBall(...)` classification so custom/merged Ball records follow the same scope.
- Corrected `contextual_field_actions` seam metadata from `compose` to `transitive_native_guard`; Nuzlocke does not wrap `mod.world:useFieldAction` directly.
- No files added or removed. Save schema remains 4.

---

# 2.3.1 RC — Gen1Recomp 0.1.98 compatibility + public API hardening

- Direct child of 2.2.21 RC; no older branch restored.
- Source-audited Gen1Recomp v0.1.98 and widened manifest support to `>=0.1.86 <0.1.99`.
- Audited marker moved to `0.1.98`; added explicit 0.1.94/0.1.98 engine compatibility profiles.
- Added `battle_classifier.snapshot()` using the engine's detached `mod.battle:snapshot()` facade; existing classifier API number remains 1 and enforcement still uses established veto/event seams.
- Compatibility reports now include public-engine feature availability for battle snapshots/intents and contextual field actions.
- Added deep R/B/Y and Gold field-action guards so No Fishing also governs `mod.world:useFieldAction("fish")` and registered/direct field-item execution.
- Added `BERRY_JUICE`, `RAGECANDYBAR`, and `SACRED_ASH` to Gold field-healing policy coverage.
- Gold `BattleState:useItem` now honors every `evaluateItemUsePolicy` denial, fixing No Healing Items / No X Items fallthrough while retaining downstream species/static/type capture legality checks.
- Updated Gold nickname/item compatibility metadata for the 0.1.98 native paths.
- No save-schema, permission, dependency, or package-tree change; runtime validation required.


### Reconciled historical record: 2.3.1 RC — Yellow New Game startup hotfix

- Direct child of 2.3.0 RC.
- Records 2.3.0 Yellow New Game as runtime FAIL on Gen1Recomp 0.1.98.
- Removes eager pre-overworld `mod.battle` / `mod.world` capability probing from the title/New Game path.
- Defers the new 0.1.98 field-action backstop until `map.entered`, when a real overworld exists.
- Preserves the 2.3.0 No Fishing, Gold item-policy, Gen II healing classification, and battle-snapshot interoperability work.
- Runtime retest required; static checks are not runtime PASS.

---

# 2.2.21 RC — Quick Nuzlocke Start

- Direct child of 2.2.20 RC; no older branch restored.
- Added NEW GAME-only **Quick Nuzlocke Start** under QoL; default OFF.
- Quick Start implies the local opening-intro/name shortcut, then waits for the native fresh world before reconciling story state.
- R/B/Y start at Pallet's Route 1 side with a level-5 starter, Pokédex, post-Pokédex Oak/Viridian state, and at least 5 Poké Balls; a larger configured Start Balls amount remains authoritative.
- The optional first Route 22 rival is deliberately left unbeaten/available and no early route encounter is consumed.
- Yellow restores the Pikachu-follower baseline without inventing a skipped lab-Rival battle result.
- Gold preserves InitClock, anchors the skipped weekday prompt to the host weekday, reconciles Mom/Pokégear/Elm starter/Mr. Pokémon/Pokédex/first Cherrygrove Rival/police/Mystery Egg return state, grants the mandatory Potion plus 5 Poké Balls, and starts at New Bark's Route 29 exit.
- Gold preserves the native Cherrygrove whiteout destination established by `blackoutmod` until a later Pokémon Center replaces it.
- Gold Guide Gent/Map Card, Mom banking, Route 29 encounters, and the Route 29 catch tutorial remain optional/unconsumed; Skip Catch Demo may still suppress the tutorial.
- Nickname Rule is honored by retaining only the starter nickname screen when required.
- Built-in seeded Random Starter is honored and the starter is registered through the normal Nuzlocke provenance path. External starter-provider composition is explicitly TEST REQUIRED when the provider does not also own Quick Start.
- Added Quick Start delegation capabilities `quick_start_provider` / `new_game_progression_provider`.
- Permanent Rule Seal does not govern the QoL shortcut.
- Save schema remains 4; package tree unchanged. Runtime validation required on Red, Blue, Yellow, and Gold.

---

# 2.2.20 RC — opening intro skip

- Direct child of 2.2.19 RC; no older branch restored.
- Added NEW GAME-only **Skip Opening Intro** under QoL; default OFF.
- Uses the upstream `intro.oak_speech.build` named-step hook instead of replacing New Game or setting progression flags.
- R/B/Y retain only hidden player/Rival name steps, which resolve through the existing canonical Default Names adapter.
- Gold retains `init_clock` plus the hidden player-name step; its later Rival naming story remains native.
- Added external ownership capability `opening_intro_skip_provider` / `tutorial_qol_provider`.
- Permanent Rule Seal does not affect the QoL option.
- No files added or removed; save schema remains 4.

---

# 2.2.19 RC — seeded structured randomizer

- Direct child of 2.2.18 RC; no older branch restored.
- Added an 8-digit shareable `Random Seed`; `00000000` means AUTO until a Nuzlocke-owned randomizer is enabled.
- Added deterministic RNG algorithm v1 with independent STARTER / ENCOUNTERS / LEARNSETS streams keyed by semantic slot identity.
- Seeded starter previews no longer depend on which starter ball is inspected first.
- Added Starter Style: ANY / 3-STAGE / BASE / SIM BST.
- 3-STAGE is derived from the live merged `evolutions[]` graph rather than a hardcoded species list.
- Added Encounter Balance: CHAOS / SIM BST / EVO / BALANCED.
- Similar-BST matching uses the live merged BST with ±15% tolerance and a minimum absolute tolerance of 25.
- EVO stage classification is `single/base/middle/final`; BALANCED prefers both BST and stage and relaxes only when the live pool has no candidate.
- Random Encounter structure remains untouched: species change, native levels/rates/time/fishing/tree/map slots do not.
- Existing pre-seed persisted encounter/learnset/starter choices are preserved when valid during upgrade rather than silently rerolled.
- `mod.exports.randomizer` remains API 1 and additively exposes `rngVersion` plus `seed(create)`.
- NUZ STATUS / Gold status rule lists show `RNG ######## v1` while a Nuzlocke-owned randomizer is active.
- External randomizer delegation remains authoritative.
- Save schema remains 4; package tree unchanged. Runtime validation required.

---

# 2.2.18 RC — rule-interaction hardening

- Direct child of 2.2.17 RC; no older branch restored.
- Failed Encounter arming now consults the authoritative capture policy so absolute capture bans, species/BST restrictions, Solo, Dupes, and consumed-area state cannot be converted into an unintended failed-area burn.
- Shiny Clause no longer indirectly changes Failed Encounter handling for encounters that another absolute rule already forbids.
- Gold encounter provenance now distinguishes grass, surf/water, and successful fishing. Time Split applies only to grass plus legacy `wild` records, not new water/fishing encounters.
- Random Starter candidate generation and persisted-choice validation now respect run-wide Type Lock, glitch, Legendary/Mythical/Pseudo, and Maximum BST legality. No Catching intentionally does not apply to the received starter.
- Automatic Default Names and Skip Catch Tutorial now yield completely to delegated external owners even when carried/stale local NEW GAME state remains ON.
- Fresh-save PC Vitamins and PC Heal Items skip their local grant when the corresponding starting-resource capability is delegated, preventing double grants.
- Synchronized stale public sub-API build stamps and corrected Forgiveness Token help text from Gym Trainers to Gym Leaders.
- Egg-hatch species-rule handling remains an explicit policy gap; no destructive hatch rollback was added.
- Save schema remains 4; package tree unchanged. Runtime interaction validation required.

---

# 2.2.17 RC — external Difficulty stacking warnings

- Direct child of 2.2.16 RC; no older branch restored.
- Game Difficulty now prepends a visible warning whenever an active external trainer/difficulty mod is not the selected exclusive provider.
- VANILLA explicitly warns that it disables only Nuzlocke's built-in transforms and does not disable Stronger Trainers or another external trainer mod.
- Built-in historical/NUZ MEDIUM profiles show **STACK WARNING** when an external trainer mod remains active underneath the composed trainer party.
- Selecting one external `[MOD]` provider while another trainer provider is active shows **MULTI-MOD WARNING**.
- Selecting Stronger Trainers `[MOD]` removes the Stronger-Trainers warning; selection remains manual and Nuzlocke never silently changes Difficulty ownership.
- Known historical providers (`stronger_trainers`, `ironmon_ultimate`, `indigo_conference`) are now queried directly through `mod.find` in addition to status/discovery scans.
- Save schema remains 4; package tree unchanged. Runtime UI/combination validation required.

---

# 2.2.16 RC — Gym Team Size + translation compatibility

- Direct child of 2.2.15 RC; no older branch restored.
- Added **Gym Team Size** under Battle Mechanics. When enabled, only the actual next Gym Leader battle is gated, and the player's active usable roster may not exceed the Leader's live composed party size. Fewer Pokémon remain legal.
- The Gym Team Size limit reads the live merged/composed trainer party rather than a hardcoded species/count table, allowing compatible trainer-party providers to change the Leader roster. Ordinary Gym Trainers are unaffected.
- R/B/Y matches the exact `start_battle trainer/class/party` command for the next Leader. Gold matches the loaded native Gen 2 trainer before `startbattle`, covering Johto and Kanto Gym Leaders but excluding Red.
- Gym Team Size defaults OFF; HARDCORE and IRONMON enable it, while NUZLOCKE and SOLO leave it OFF.
- Added known localization-companion diagnostics for `gen1_pt-br` 0.1.4 and `finnish` 0.1.0 without taking localization ownership.
- MOD COMPAT preserves a translated full semantic label before using compact English aliases and reports detected translation companions/known PT-BR layout overrides.
- Confirmed semantic shop enforcement remains localization-safe; no Portuguese/Finnish BUY/SELL literals were added to Nuzlocke.
- Reduced the inherited maximum nested upvalue count from the 2.2.15 hard-ceiling value of 48 to 47 by routing late Gym Guide refresh through the existing internal export namespace.
- Save schema remains 4; package tree unchanged. Runtime validation required.

---

# 2.2.15 RC — save migration coordinator hardening

- Direct child of 2.2.14 RC; no older branch restored.
- Centralized persisted-data upgrades into deterministic phases: **schema → semantic → reconstruction → projection**.
- Replaced the numbered schema `if/elseif` chain with explicit destination-version migrators for schema 1 through 4. A future schema bump with no registered migrator now fails with the exact missing `vN`.
- Moved the retired Ball-ban/No Catching correction into the named semantic phase without changing its ambiguity-preserving behavior.
- Moved retired blanket Route Splits translation out of `reprojectEncounterAreas()` and into the named semantic phase. Projection now only projects preserved encounter provenance.
- Centralized legacy `hardcore_mode` / `elite_four_caps` → `level_cap_scope` persistence; read-time conversion remains only as a defensive fallback.
- Registered legacy Rule Lock / dormant Permanent Rule Seal reconciliation as a named semantic step while retaining `game.ready` runtime enforcement.
- Registered tracker recovery and lazy persistent Pokémon identity assignment as `reconstruction/tracker_identity_reconstruction`.
- Registered encounter-area rebuilding as `projection/encounter_area_projection`; removed their separate `save.loaded` migration listeners.
- Added an inspectable internal `saveUpgrade.lastRun` report with completed step IDs and exact failure phase/step.
- A save from a schema newer than this build now safely stops the upgrade pipeline before reconstruction/reprojection rather than applying older assumptions to newer persisted data.
- Save schema remains **4**; no existing rule keys or migration markers were removed.
- No package files added or removed.

---

# 2.2.14 RC — Gen 2 Randomizer+ compatibility

- Added a Gold-specific source adapter for `gen_2_randomizer_plus`.
- Nuzlocke now delegates Random Starter, Random Encounters, and Random Learnsets
  only when Randomizer+'s corresponding source-confirmed setting is actually ON.
- External Randomizer+ ownership no longer risks Nuzlocke repainting its own
  encounter-table snapshot over the active Gold randomizer.
- Wild encounter/catch provenance now records Randomizer+ as the encounter
  provider even though Randomizer+ does not export the generic Nuzlocke provider
  contract.
- Challenge-policy ownership remains with Nuzlocke: encounter limits, Failed
  Encounters, Dupes, type locks, capture legality, and tracker state continue to
  evaluate the Pokemon that actually enters battle.
- No assumptions are made about the private implementation of the v2.6 Wilds of
  Kanto compatibility layer; Nuzlocke consumes its final battle identity.
- No files added or removed.

---

# 2.2.12 — complete built-in Difficulty RC

- Direct child of 2.2.11 RC; no older branch was restored.
- Expanded every built-in Game Difficulty profile beyond level/Stat EXP/DV metadata into live trainer-party transformations.
- Added separate ordinary/boss level scaling so boss-cap previews continue to follow the same composed party actually fought.
- Fixed 2.2.11 in-place trainer-party scaling: built-in Difficulty now transforms a copied party, so previews/repeated battles cannot compound levels or mutate shared provider/registry rows.
- Added deterministic type-preserving trainer roster upgrades from the live merged species registry; rival species are protected as story state.
- Added profile moveset optimization using each active species' merged level-up and, at higher tiers, compatible damaging TM/HM move pools. Existing provider moves remain candidates instead of being discarded before composition.
- Added real Gen 1 AI tiers using the engine's native LAYER_1/LAYER_2/LAYER_3 scoring pipeline.
- Added real Gold AI tiers by augmenting each battle's copied TrainerClassAttributes AI bitfield; no shared trainer registry is mutated.
- SHIN HARD*/SHIN-STYLE* and POLISHED* disable player badge battle boosts; Gen 1 clears only the battler's copied badge set, while Gold uses guarded per-battle engine-method wrappers keyed by the profile flag.
- Fixed unobserved Gold `gen2Trainers` NEXT CAP preview to apply the selected built-in boss level multiplier before the fight; observed composed parties still win once available.
- Added Gold profile held items using native held-item fields, while preserving any item already supplied by the base/provider party.
- Fixed Gold trainer Stat EXP/DV recalculation to use `src.battle.gen2.Mon.refreshStats` for split Special Attack/Special Defense records.
- Trainer creation now has one deterministic owner: VANILLA permits the separate Nuzlocke Trainer Stat EXP/DV controls; a built-in Difficulty profile owns those stats itself; an external Difficulty provider is left untouched.
- External difficulty-provider selections remain fully authoritative and skip all Nuzlocke built-in party/stat/AI transformations.
- Physical/Special Split remains independent under Battle Mechanics and is never implicitly enabled by POLISHED* or another Difficulty profile.
- Static/mock validation: all five Lua files compile/parse; copy-on-compose and repeat-construction stability PASS; Gen 1/Gold native-AI application PASS; Gold pre-battle cap scaling/observed precedence PASS.
- Compiler-pressure comparison to 2.2.11 is unchanged at 47 max nested-function upvalues and 128 max nested-function locals; no new function crosses either warning line.
- Package tree remains exactly 15 existing files; no additions/removals.

---

# 2.2.11 RC — Difficulty implementation audit

- Audited every built-in Game Difficulty profile against its live code path.
- Fixed built-in trainer Stat EXP and perfect-DV settings: these fields were previously attached as metadata by `trainer.party` but were not consumed by trainer construction.
- Built-in Difficulty now owns trainer starting Stat EXP/DVs independently of the Nuzlocke master switch and independently of the manual Trainer Stat EXP / Perfect Trainer IV controls.
- External difficulty providers retain ownership of their constructed Pokemon; Nuzlocke does not overwrite their trainer stats.
- Removed the inert built-in AI labels (`smart`/`strong`/`max`). The current engine/provider path did not consume those labels, so documentation no longer implies an AI change that is not actually enforced.
- Historical `*` profiles remain explicitly inspired profiles, not byte-identical reproductions. Their currently enforced native dimensions are trainer levels, trainer starting Stat EXP, perfect DVs where selected, and live boss-cap preview through the composed trainer party.

---

# 2.2.10 — cross-generation pools + Physical/Special Split RC

- Direct child of 2.2.9 RC.
- Added **Species Pool** for Random Starter and Random Encounters: AUTO / GEN1 / GEN2 / BOTH.
- `AUTO` preserves 2.2.9's active merged-registry behavior. `BOTH` targets Generation 1 + 2 species only when complete indexed/generation metadata is actually available.
- Gold Random Encounters now reads/writes the live `gen2Encounters` registry instead of the Gen 1 encounter path.
- Changing Species Pool revalidates persisted starter/encounter rolls so an out-of-pool saved roll cannot bleed into the new selection.
- External encounter-randomizer ownership now relinquishes Nuzlocke's encounter snapshot instead of restoring stale Nuzlocke data over the provider.
- Added optional **Phys/Spec Split**, OFF by default and independent of the Nuzlocke master switch.
- Phys/Spec Split is presented under **BATTLE MECHANICS**, not Game Difficulty.
- R/B/Y uses Gen1Recomp's existing per-move category override while retaining the native single Special stat.
- Gold uses per-move categories for damage stats and also realigns Reflect/Light Screen plus Counter/Mirror Coat physical/special identity.
- No public compatibility API, save-schema, Mod API, engine-range, or package-tree change.
- Runtime validation is required for the new feature paths; 2.2.9 runtime-PASS behavior remains protected.

---

# 2.2.9 — hardening RC

- Direct child of 2.2.8 RC.
- Project compiler policy adopted: warning at 40 upvalues / 130 locals; hard ceiling 48 upvalues / 160 locals.
- Split the near-limit late-runtime initializer again to create compiler headroom.
- Added a defensive empty-party POKEMON-menu guard for the runtime-confirmed full-wipe CTD.
- Made Dungeon Lock-In's dungeon-to-different-dungeon transition explicit and re-seed destination-family state.
- Removed erroneous Gold Zinc handling and centralized the five native vitamins.
- Clarified Wild-to-caught Player Stat EXP ownership.
- Preserves 2.2.8 dialogue and live Difficulty-cap repairs.

---

# 2.2.8 — dialogue ownership and live Difficulty cap repair

### Historical subrecord — 2.2.8 RC
- Direct child of 2.2.7 RC.
- Runtime reproduced duplicated/stiched vanilla Yellow SNES dialogue at World Building Tier 3.
- Removed the global T3 rewrite of vanilla `show_text` / `ask` `\v` continuation text.
- Preserved Nuzlocke-authored T3 formatting/ownership via the existing shared world-text paths.
- Fixed live boss-cap preview for Nuzlocke's own built-in Difficulty profiles by allowing `trainer.party` composition preview when a non-Vanilla internal profile is active.
- Clear observed boss-level cache entries when Difficulty changes at runtime.
- Preserved 2.2.7's split late-runtime closures and kept both phases below the Lua 5.1 upvalue ceiling.
- No file additions/removals, save-schema change, API change, engine-range change, or rule-default change.

---

# 2.2.7 — confirmed Lua 5.1 upvalue-limit startup repair

### Historical subrecord — 2.2.7 RC

- Direct child of 2.2.6 RC.
- Runtime error text confirmed the real compiler failure: `_lateRuntimeInit` had **more than 60 upvalues**.
- Corrected the earlier 200-local diagnosis; Lua 5.1's separate per-function upvalue ceiling was the active failure.
- Split the former monolithic `_lateRuntimeInit` into two sequential phases:
  - common/RBY late-runtime installation;
  - Gold/compatibility late-runtime installation.
- Preserved initialization order and reused/cleared the same private export slot between phases.
- Duplicated the tiny `hasHealthyParty` helper inside the Gold phase so no additional main-scope local or cross-phase upvalue is required.
- Preserved Yellow Skip Catch Demo, expanded NUZ INFO, native Pokémon Bois Club chairman walker, and existing protected runtime behavior.
- No file additions/removals, save-schema change, Mod API change, engine-range change, or rule-default change.
- Fresh NEW GAME Setup runtime retest required.

---

# 2.2.6 — confirmed Lua local-limit startup repair

### Historical subrecord — 2.2.6 RC

- Direct child of 2.2.5 RC.
- Runtime error screen confirmed that `main.lua` was rejected at compile/load time due to Lua's per-function local-variable ceiling.
- Corrected the incomplete 2.2.5 diagnosis: 2.2.4's extra renderer table was removed there, but 2.2.3 had already introduced another long-lived local helper.
- Converted `skipCatchTutorialRequested` from a local function to an internal `mod.exports.__beta26` function, preserving behavior without consuming another local slot in the giant mod entry function.
- Updated all Yellow/RBY/Gold catch-tutorial skip call sites to use the same internal helper.
- Preserved the 2.2.4 native Pokémon Bois Club walker repair.
- Preserved the 2.2.3 NUZ INFO completeness work.
- No save schema, Mod API, engine range, permissions, rule defaults, or package file-tree change.
- Fresh NEW GAME Setup runtime retest required.

---

# 2.2.5 — startup/local-limit regression repair

### Historical subrecord — 2.2.5 RC

- Direct child of 2.2.4 RC.
- Investigated a runtime report that New Game Nuzlocke Setup no longer appeared.
- Confirmed 2.2.4 added one extra long-lived local (`fanClubBryanSprites`) to the already-local-heavy `main.lua`.
- Removed that additional file-scope local to avoid crossing Lua 5.1's 200 active-local ceiling.
- Moved temporary Pokémon Bois Club renderer ownership state onto the chairman NPC itself.
- Preserved the 2.2.4 native-walker behavior and third-party ownership-safe restore semantics.
- No setup logic, save schema, engine range, API version, permissions, or package file tree change.
- New Game Setup runtime retest required.

---

# 2.2.4 — Pokémon Bois Club native-walker repair

### Historical subrecord — 2.2.4 RC

- Direct child of 2.2.3 RC; no older branch was restored.
- Confirmed the old `makeBryanBoiRenderer` hand-painted sprite generator was dead code: it had no call sites and its activation flag was never set.
- Kept the newer native-walker design rather than reconnecting the rough custom renderer.
- Tier-3 Pokémon Bois Club chairman now receives a genuine engine `SpriteRenderer`.
- Preferred native sprite candidates match Bryan-at-Home: Gambler first, then Black Hair Boy 1, with a safe same-map native fallback.
- Cached the exact original chairman renderer and restore it when World Building drops below Tier 3.
- Added ownership-safe restoration so Nuzlocke does not overwrite a sprite another mod replaced after the tribute was applied.
- Removed the obsolete pixel-by-pixel Bryan renderer and the unrelated Fan Club sprite flag assignment from Bryan-at-Home.
- Updated current documentation to describe the native-walker tribute accurately.
- No save schema, API version, permissions, engine range, asset set, or player-package file tree change.
- Yellow Skip Catch Demo and expanded NUZ INFO behavior from 2.2.3 are inherited unchanged and still require runtime confirmation.

---

# 2.2.3 — Yellow catch-demo hardening + NUZ INFO completeness

### Historical subrecord — 2.2.3 RC

- Direct child of the published 2.2.2 RC; no older branch was restored.
- Left the recently improved shared T3/world-building dialogue ownership path unchanged pending continued runtime testing.
- Hardened Yellow's Pallet Town Professor Oak catch-demo skip against the current upstream flow: Oak creates a level-5 Pikachu wild battle, marks it with `makeOldManDemo("PROF.OAK")`, assigns the normal post-demo callback, then calls `Commands.pushBattle`.
- Unified the NEW GAME Skip Catch Demo query across the staged profile, active mod save, and legacy transient save field so delayed tutorial seams observe the same setting.
- Made the Oak `Commands.pushBattle` wrapper reload-safe instead of permanently trusting the first installed wrapper.
- Existing R/B/Y Viridian `old_man_demo` and Gold Route 29 tutorial skips now use the same setting query.
- R/B/Y NUZ INFO remains on the host-native crash-safe `ListMenu`.
- NUZ INFO now displays enabled Catch/Stat/Move data more completely: shiny state, death cause, legality/BST details, provenance/provider/source fields, and move accuracy are no longer silently omitted.
- NUZ INFO SAFE MODE now reconstructs all enabled pages directly from the selected Pokémon instead of degrading to a small Catch-only block.
- Disabled Catch/Stat/Move pages are explicitly labeled `PAGE OFF`, preventing an intentionally disabled page from looking like missing data.
- No save schema, API version, permission, engine range, or repository/player-package file tree change.
- Runtime TEST REQUIRED for Yellow Pallet Skip Catch Demo and R/B/Y NUZ INFO with all page-toggle combinations.

---

# 2.2.2 — battle-money label + Yellow runtime ledger

### Historical subrecord — 2.2.2 RC

- Direct child of 2.2.1 RC; no older branch was restored.
- Renamed compact Trainer Money from `Trnr ¥` to `Btl. ¥`.
- Recorded Yellow 2.1.24 save-game runtime PASS for No Buying.
- Recorded Yellow 2.1.24 save-game runtime PASS for No Selling.
- Recorded Yellow 2.1.24 save-game runtime PASS for No Center Heal / Pokémon Center healing ban.
- No rule mechanics, API/save schema, permissions, engine range, or repository file tree changed.

---

# 2.2.1 — Gold value-column visual correction

### Historical subrecord — 2.2.1 RC

- Direct child of 2.2.0 RC; no older branch was restored.
- Gold 2.1.24 runtime testing confirmed the right-aligned Setup/NUZ RULES value column was one native tile too far right and could crowd/clip the frame.
- Preserved the wider ten-tile Gold rule-label field and moved only the live value/toggle anchor one tile left.
- R/B/Y presentation and all rule/enforcement behavior are unchanged.
- Gen1Recomp 0.1.94 audited compatibility, NUZ INFO/MOD COMPAT/NUZ ST. repairs, Yellow catch-demo work, and native Bryan path from 2.2.0 are preserved.
- Runtime visual RETEST REQUIRED for Gold NEW GAME Setup and in-game NUZ RULES.

---

# 2.2.0 — Gen1Recomp 0.1.94 compatibility and runtime repair rollup

### Historical subrecord — 2.2.0 RC

- Direct child of 2.1.24 RC; no older branch was restored.
- Renumbered the planned 2.1.25 work to 2.2.0 at user request.
- Source-audited Gen1Recomp v0.1.94 against v0.1.93. The release is 10 commits ahead; reviewed changes are concentrated in launcher/version-aware conflict evaluation plus API-2 one-way `mod.postLog` support (`log_url`, network-gated HTTPS destination). No reviewed gameplay seam used by Nuzlocke changed.
- Updated `recompCompatAudited` to `0.1.94`. Manifest engine envelope remains `>=0.1.86 <0.1.98`; Mod API 2 and save schema 4 are unchanged.
- Deliberately did **not** add `network` permission or `log_url`: Nuzlocke does not require outbound logging to function.
- R/B/Y NUZ INFO now pcall-isolates the API-27 model and its compatibility helpers, provides a direct-Pokémon SAFE MODE fallback, and protects native ListMenu construction so optional diagnostics cannot hard-crash party input.
- R/B/Y MOD COMPAT now uses full semantic labels when Gen1 Modern UI is active and width-bounded compact labels/provider names in the classic ListMenu path.
- R/B/Y NUZ ST. now contains explicit RUN STATUS and ACTIVE RULES heading rows so semantic grouping survives Modern UI and classic presentation.
- Yellow Skip Catch Demo now covers the Pallet Town Professor Oak Pikachu demonstration, which bypasses ScriptRunner and directly calls `Commands.pushBattle`; the demo battle is omitted while the existing onFinish continuation preserves Whew/Come With Me/lab escort progression. Existing Red/Blue/Yellow Viridian `old_man_demo` interception remains.
- Bryan's T3 home NPC no longer swaps in the rough custom true-color renderer. It prefers a native gambler/black-hair-boy walker when available and otherwise a known-good native house walker; the fan-club chairman also keeps native art. No new sprite asset was added.
- Protected runtime PASSes inherited from 2.1.23/2.1.24: Yellow randomized-starter received-name and party delivery, Trainer Money symbol, Setup/Type Locke selector visibility, startup name skip, PC Heal/Rare Candy/Vitamin loadouts, and native Trainer Card.
- Runtime TEST REQUIRED for Gen1Recomp 0.1.94 and every repaired UI/tutorial/Bryan path above.

---

# 2.1.24 — R/B/Y NUZ INFO native-menu crash repair

### Historical subrecord — 2.1.24 RC
- Direct child of 2.1.23 RC.
- Yellow 2.1.23 runtime PASS: randomized starter message names the actual received Pokemon; randomized Sandslash appears correctly in party; Trainer Money shows the money symbol.
- Yellow 2.1.23 runtime FAIL: selecting party NUZ INFO crashes.
- R/B/Y NUZ INFO now renders through host-owned `ListMenu` using API-27 `getPokemonNuzInfo()` / `getNuzInfoPages()` data instead of the custom hand-drawn screen.
- Gold NUZ INFO presentation is unchanged.
- Runtime retest required.

---

# 2.1.23 — systemic T3 dialogue + catch-demo repair

### Historical subrecord — 2.1.23 RC

- Direct child of 2.1.22 RC; no files added or removed.
- Runtime reports showed the same continuation/stitched-dialogue presentation in Mom, Viridian catch-tutorial, Oak's Lab, and other interactions. Replaced one-off T3 text fixes with a shared World Building paginator used by every Nuzlocke-owned overworld message.
- At World Building T3, ScriptRunner `show_text` / `ask` rows that use Gen1's native `\v` continuation marker are presentation-normalized through the same paginator. Story commands, substitutions, choices, flags, and program-counter flow are unchanged; T0-T2 preserve vanilla continuation behavior.
- R/B/Y Skip Catch Demo is now implemented at the semantic `old_man_demo` command used by Red/Blue and Yellow. Only the demonstration battle is skipped; surrounding vanilla dialogue, completion flags, movement, and object cleanup continue normally. Gold retains its separate Route 29 tutorial seam.
- Gold Setup/NUZ RULES values are now right-aligned to the native screen edge. Short ON/OFF toggles move farther right, rule labels regain a tenth tile, and long money/type values retain up to seven tiles.
- TV's currently runtime-good T3 path remains on the shared World Building presenter and was not replaced with a new special case.
- Runtime validation required, especially Yellow Mom/Lab/tutorial dialogue, R/B/Y catch-demo progression, and Gold Setup spacing.

---

# 2.1.22 — R/B/Y Nuz menu native-surface repair

### Historical subrecord — 2.1.22 RC

- Direct child of 2.1.21 RC; no files added or removed.
- Logged Yellow 2.1.21 runtime FAIL: NUZ ST. and MOD COMPAT still hard-crash.
- R/B/Y NUZ ST. now uses the host mod-facing ListMenu and presents caught/death/area/cap status plus the active-rule list.
- R/B/Y MOD COMPAT now uses ListMenu and preserves compatibility ownership rows.
- Removed the two failing R/B/Y paths from hand-drawn custom-state rendering/stack timing; Gold-native status/compat rendering is unchanged.
- Preserved all confirmed 2.1.19 Yellow PASS paths and 2.1.21 Gold Setup spacing.
- Runtime validation required.

---

# 2.1.21 — Gold Setup spacing cleanup

### Historical subrecord — 2.1.21 RC

- Direct child of 2.1.20 RC; no files added or removed.
- Gold Setup/NUZ RULES now reserve one native tile between the rule-label field and value/toggle field.
- Preserved the seven-tile Gold value column so money values and longer type labels retain their previous display capacity; only the label field was reduced from 10 tiles to 9.
- Presentation-only change: no rule mechanics, save keys, controls, descriptions, R/B/Y layout, or 2.1.20 menu-recovery behavior changed.
- Runtime visual confirmation required on Gold Setup and Gold in-game NUZ RULES.

---

# 2.1.20 RC

- Direct child of 2.1.19 RC; no files added or removed.
- Recorded Yellow 2.1.19 runtime PASS: NEW GAME Setup appears; Type Locke selector visibility behaves correctly; automatic default names work; PC Heal/rare-candy/vitamin startup grants work; native Trainer Card opens without the prior crash.
- Recorded Yellow 2.1.19 runtime FAIL: entering a Nuzlocke-owned in-game menu can hard-crash.
- Hardened NUZ RULES runtime recovery so a draw exception is recorded during draw and handled on the next update tick. The old guard could pop the state from inside `draw()`, which is unsafe while the engine is iterating/rendering the StateStack.
- Added the same deferred runtime-failure recovery to the standalone R/B/Y NUZ STATUS screen.
- Moved Game Difficulty out of LEVELS into its own GAME DIFFICULTY section. VANILLA is still the unmodified/OFF-equivalent setting; no difficulty save/API semantics changed.
- UI labels: `Trnr ¥`, `Start ¥`, `No Esc. Rope`, and `Heal Loadout`.
- Re-audited Type Locke legality: OFF returns no allowed-type filter; MONO returns only Type 1; DUO returns only Types 1-2; TRI returns only Types 1-3. Actual runtime acquisition enforcement is still TEST REQUIRED.

---

# 2.1.19 RC — compatibility/lifecycle hardening

- Direct child of `2.1.18 RC`; no older branch was restored.
- Removed the active-generation precondition from Gen1 kerning installation retries. Installation now retries whenever Font is not yet wrapped and no external kerning provider owns the surface; `kerningEnabled()` still gates all visual effect to confirmed Gen1 at call time.
- Hardened Gen1 Modern UI registration so only an explicit `true` from `registerAdapter` counts as success. `nil` or any other non-true value leaves the integration inactive/unregistered with an error state.
- Reworked the R/B/Y title SETUP fallback into one stable wrapper backed by mutable dependency state, preventing Nuzlocke wrapper re-stacking and stale `openSetup`/translation/save-editor closures across hot reloads.
- Added safe migration from the exact 2.1.18 legacy wrapper when it is still directly installed; when another mod sits above that legacy wrapper, the new outer stateful wrapper rebinds the existing Nuzlocke SETUP row to the current callback instead of inserting a duplicate.
- Preserved the runtime save-editor check on every title-menu open; no install-time editor short-circuit was reintroduced.
- No challenge-rule mechanics changed. No files added or removed. Runtime validation remains required.

---

# 2.1.18 — Yellow runtime hardening: native Trainer Card + dialogue ownership

- Direct child of `2.1.17 RC`; no older branch was restored.
- Logged Yellow 2.1.16 runtime: default-name skip PASS; PC Vitamins starter loadout PASS; opening the Nuzlocke-hijacked Trainer Card FAIL/crash.
- Stopped replacing the native R/B/Y Trainer Card START-menu row. The engine Trainer Card is now upstream-owned again.
- Added a dedicated `NUZ ST.` START-menu entry for R/B/Y, matching Gold's separated status approach. The Gen1 status screen can run in `statusOnly` mode without constructing the native Trainer Card at all.
- Added generic per-ScriptRunner Nuzlocke message ownership so overlapping enforcement/compatibility seams cannot emit two mod-authored denial/flavor boxes for one script transaction.
- Audited the reported bedroom SNES sequence against Gen1Recomp and pret/pokered: the repeated visible line is vanilla `cont` scrolling from `_RedBedroomSNESText`, not duplicated Nuzlocke World Building. Vanilla text scrolling is therefore intentionally preserved.
- Existing `pushWorldText` protection against stacking optional World Building over an active TextBox remains in force.
- No files added or removed. Runtime validation remains required.

---

# 2.1.16 — Trilocke, Type Locke invariants, rule-section cleanup

- Direct child of `2.1.15 RC`.
- Added **TRI / Trilocke** with a third displayed type selector.
- Type Locke is now explicitly mode-authoritative: OFF = no type restriction and no selectors; MONO = Type 1 only; DUO = Types 1–2 only; TRI = Types 1–3 only.
- Random type resolution and live/staged edits keep every active displayed type concrete and distinct.
- Shared acquisition legality, off-type encounter handling, gifts/trades, starter filtering, and legality reporting all consume the same active Type Locke set.
- Moved **Route Forgiveness** from CORE to CLAUSES and **No Catching** from CORE to GENERAL; mechanics are unchanged.
- Added +1 px micro-tracking to centered bold-like section headers so adjacent glyphs retain separation.
- No files added or removed. Runtime validation remains required.

---

# 2.1.15 — Rules UI alignment, Type Locke OFF, reversible Rule Lock

- Centered R/B/Y and Gold rule-section headers inside the list area and added subtle bold-like emphasis using the existing pixel font only.
- Shifted ordinary R/B/Y rule labels left to reclaim menu space while retaining the native selection cursor.
- Type Locke OFF now clears and hides both Type 1 and Type 2; MONO keeps Type 1 only; DUO restores two distinct selectors.
- Restored a reversible **Rule Lock** control, separate from the dormant/WIP irreversible **Permanent Rule Seal**.
- Added migration logic for older non-permanent `rules_locked` state when no irreversible seal marker exists.
- No files added or removed. Runtime validation remains required.

---

# 2.1.14 — Type Locke MONO state/UI repair

- Direct child of `2.1.13 RC`.
- Gold 2.1.12 runtime reproduction: selecting Type Locke MONO left `Type 2` visible.
- MONO now clears the staged/live secondary type and hides the Type 2 row.
- Returning to DUO restores a valid secondary type distinct from Type 1.
- Shared config code means the repair applies to R/B/Y and Gold, Setup and in-game Rules.
- Runtime status: **TEST REQUIRED**.

---

# 2.1.13 — Yellow/T3 repair candidate

- Direct child of the canonical packaged `2.1.12 RC`.
- Preserved `pokemon.before_give`; upstream 0.1.93 source confirms it runs before `Pokemon.new`.
- Added concrete random-starter runtime-safety validation for species definitions, growth/type data, learnsets, base-stat calculation, and every move the level-5 starter will display.
- Invalid/partial provider species are skipped from the starter pool instead of being allowed to reach Party/Summary UI.
- Added per-script Mom response ownership so normal and fallback No Mom Heal seams cannot stack duplicate rejection boxes.
- Preserved one-time allowed-heal T3 Mom flavor and vanilla dialogue on later visits.
- Removed the Pallet TV `Rule watch:` suffix.
- Added explicit 18-glyph wrapping and page separation for T3 Pallet TV reports.
- Added a real T3 Bryan runtime NPC to `REDS_HOUSE_1F` using the engine NPC object contract and contributed map-script text.
- Added rotating Bryan home dialogue covering “boi”, Gen1Recomp/Nuzlocke coding claims, Pokémon Bois Club, game-console use, and non-explicit Mom/Bryan innuendo.
- No new assets or repository files.
- Gen1Recomp 0.1.93 remains source-audited; manifest envelope remains `>=0.1.86 <0.1.98`.
- Changed paths are parser/static/source-audit candidates only; runtime confirmation remains required.
- Full 15-file repository tree preserved.

---

# 2.1.12 — Leader-only Forgiveness + compact UI fallbacks

- Direct child of `2.1.11 RC`.
- `Nuzlocke Loadout` compact fallback: `Nuz. Loadout`.
- `Dungeon Lock-In` compact fallback: `Dung. Lock-In`.
- `BATTLE ITEMS` / `FIELD ITEMS` compact fallbacks: `BATTLE ITMS` / `FIELD ITMS`.
- Item-rule compact labels now use `Itms` where useful while preserving full canonical translation strings.
- Removed Route Forgiveness Token awards from ordinary Gym Trainers.
- Added one Route Forgiveness Token on Gym Leader victory, once per Gym.
- Added persistent `route_forgiveness_gym_leaders` ledger keyed by normalized Leader identity.
- The Gym Guide is not an independent token source.
- Removed the obsolete per-trainer reward identity helper.
- Old `route_forgiveness_gym_trainers` save data is left untouched for compatibility but no longer consulted.
- Starting-token modes and token-spending behavior are unchanged.
- Gen1Recomp 0.1.93 audit status and approved marquee cadence are preserved.
- Full 15-file repository tree preserved.

---

# 2.1.11 — localization-safe labels / Gen1Recomp 0.1.93 audit

- Direct child of `2.1.10 RC`.
- Restored natural full rule/category labels as canonical `Strings.source(...)` translation keys.
- Moved compact menu vocabulary into optional `shortName` / `shortTitle` fields.
- R/B/Y display now chooses full translated text first and only uses a compact label when the full label exceeds the measured pixel budget.
- Translation safety: if the full source has been translated but the short source has not, Nuzlocke keeps/marquees the translated full label instead of inserting an English abbreviation.
- Full descriptions remain unshortened and translation-friendly.
- Preserved the approved 3-second pause / ~2.4s-per-glyph true-overflow marquee cadence.
- Preserved explicit Wide Menus `classic`/`keepClassicUi` fallback.
- Audited Gen1Recomp 0.1.93 against 0.1.92; upstream delta is 14 commits.
- Reviewed 0.1.93 data-loader/default, LegacyCompat, updater/TLS, required-import/mobile, launcher/docs/test changes.
- Updated Nuzlocke's machine-readable audited-engine marker from 0.1.83 to 0.1.93.
- Existing engine range remains `>=0.1.86 <0.1.98`.
- No new permissions, save-schema change, Mod API bump, or gameplay-hook rewrite.
- Full 15-file repository tree preserved.

---

# 2.1.10 — compact rule-label candidate

- Direct child of `2.1.9 RC`.
- Kept the runtime-approved conditional marquee speed unchanged.
- Kept the explicit Wide Menus classic/native fallback; Wide Menus may be installed without Nuzlocke claiming a wider rules canvas.
- Removed decorative hyphens from collapsible section headers.
- Renamed section headers:
  - AREA SPLITS → ROUTE SPLITS
  - RANDOMIZER → RNDMIZER
- Shortened route-split rows to the route/area name only.
- Applied concise menu abbreviations including:
  - Catching
  - Rt. Forgiveness
  - Rndm Lrnset / Lrnset Gen
  - Twn Catches
  - No Lgndries / No Mythcs
  - Plyr / Wld / Trnr Stat EXP
  - No Stat EXP
  - No Gmblng
  - Trnr $
  - Max. BST
  - Alw. Glitches
  - Gift Mon
  - Ingame Trds
  - Wndrlocke
  - Lvl Cap Scope
  - No Heal Items
  - No Esc.
  - No Rare Cndy
  - Deflt Names
  - PC Vtmn
- Setup `Money` uses `$`; starting Rare Candy and Gym Guide Rare Candy use `Cndy`.
- Internal rule keys, saves, provider contracts, and full descriptions are unchanged.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file repository tree preserved.

---

# 2.1.9 — explicit Wide Menus refusal / concise core labels

- Direct child of `2.1.8 RC`.
- Recorded current marquee timing as runtime-approved; speed unchanged.
- Shortened common menu labels:
  - First Rival Mercy → 1st Rival Mercy
  - One Per Area → 1 Per Area
  - Failed Encounters → Failed Enc.
- Full rule descriptions remain intact.
- Fixed the remaining Wide Menus coexistence path by explicitly marking every `NuzlockeConfigScreen` as classic/native width.
- Added both `uiModLayout = "classic"` and `keepClassicUi = true`.
- This blocks Wide Menus' automatic widening of opaque mod-owned screens during both fresh Setup and in-game Rules.
- No gameplay, save, provider, or rule-key changes.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file repository tree preserved.

---

# 2.1.8 — concise-label presentation candidate

- Direct child of `2.1.7 RC`.
- Shortened only obvious Randomizer menu labels to reduce unnecessary marquee scrolling:
  - Random Starter → Rndm Starter
  - Random Encounters → Rndm Enc.
  - Random Learnsets → Rndm Learnset
- Kept full feature meaning in the description box and documentation.
- No rule keys, save semantics, randomizer ownership, provider APIs, or gameplay behavior changed.
- Conditional marquee remains a last resort: fitting text never scrolls.
- Wide Menus remains native-width fallback for Nuzlocke Rules pending a separately validated adapter.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file tree preserved.

---

# 2.1.7 — Wide Menus coexistence / selection repair candidate

- Direct child of `2.1.6 RC`.
- Recorded Yellow runtime crash when Wide Menus was installed and Nuzlocke claimed its wide layout.
- Disabled the Nuzlocke Wide Menus claim path until a separately validated wide-layout adapter exists.
- Wide Menus can remain installed; Nuzlocke Rules now stays on native width rather than crashing.
- Removed custom outline selection rendering after Yellow displayed only stray colored marks near the divider.
- Restored the engine-native cursor glyph for selected R/B/Y rows.
- Moved the cursor to X=10 and labels to X=22, reclaiming eight pixels compared with the historical X=30 label start.
- Preserved conditional slow marquee: no scrolling for fitting text; 3-second pause and ~2.4s/glyph for true overflow.
- Gold native presentation unchanged.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file tree preserved.

---

# 2.1.6 — Yellow selection/readability repair candidate

- Direct child of `2.1.5 RC`.
- Recorded Yellow runtime regression: conditional marquee was much too fast.
- Restored the historical slow marquee behavior: 3-second initial pause and ~2.4 seconds per glyph step.
- Fitting text still remains completely static.
- Removed filled reverse-video row selection after Yellow runtime showed selected-row glyphs becoming unreadable.
- Replaced filled selection with a thin outline highlight that does not recolor or cover font glyphs.
- Preserved the reclaimed left cursor gutter and expanded text budget.
- MOD COMPAT true-overflow marquee uses the same slow cadence.
- Gold native presentation unchanged.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file tree preserved.

---

# 2.1.5 — conditional-marquee / reverse-selection candidate

- Direct child of `2.1.4 RC`.
- Recorded 2.1.4 runtime feedback: pixel-aware static text worked, but ellipsized long rule labels were undesirable.
- Replaced R/B/Y rule/header/value ellipsis behavior with a conditional pixel-aware marquee:
  - fitting text never scrolls;
  - only true overflow scrolls.
- Marquee movement operates on glyph spans rather than raw string bytes.
- Removed the R/B/Y per-row left cursor glyph from the rules list.
- Added reverse-video selected-row highlighting to reclaim the cursor gutter.
- Moved rule labels left and increased their pixel budget.
- Kept descriptions pixel-wrapped/static, with vertical scrolling only for real overflow.
- MOD COMPAT retains collision-safe columns and now scrolls only truly overlong column text rather than ellipsizing it.
- Gold native UI behavior unchanged.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file tree preserved.

---

# 2.1.4 — pixel-aware presentation candidate

- Direct child of `2.1.3 RC`.
- Recorded Yellow/Gen1Recomp 0.1.92 runtime PASS for active Gen1 kerning/variable-width text.
- Recorded MOD COMPAT crash repair as runtime PASS.
- Replaced R/B/Y Nuzlocke-owned marquee-first rule/header/title presentation with pixel-measured static text.
- Added safe ellipsis for true horizontal overflow rather than continuous marquee scrolling.
- Replaced character-count description wrapping with pixel-width wrapping.
- Descriptions now remain fully static whenever they fit in the three visible description lines; vertical scrolling remains only for real overflow.
- Reworked R/B/Y MOD COMPAT into measured, non-overlapping label/owner columns with safe truncation.
- Preserved Gold native presentation and Gold-specific marquee behavior; this cleanup targets the now-validated Gen1 variable-width path only.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file repository tree preserved.

---

# 2.1.3 — focused review repair candidate

- Direct child of `2.1.2 RC`; no branch reset or older-tree restore.
- Fixed Gym Trainer Forgiveness ledger-key ambiguity by compacting identity fields separately and joining them after normalization.
- Fixed Gen1 kerning's permanently-false generation gate by injecting the maintained `currentGame` reference into `modern_ui_integration.lua`.
- Updated kerning lifecycle retries to use the same active-game resolver.
- Fixed `compat21.pokemonLegality()` so string-valued `nuzlockeInvalidAcquisition` flags are recognized as `INVALID ACQUISITION`.
- Added `invalidAcquisitionReason` to the legality result so compatibility consumers can distinguish reasons such as `legendary`, `area`, `solo`, `glitch`, or `disabled`.
- Preserved the 2.1.2 MOD COMPAT stale-Draw-module repair.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2 and save schema 4 unchanged.
- Existing 15-file repository tree preserved.
- Runtime PASS behavior from Yellow fresh Setup/boot remains protected.

---

# 2.1.2 — Yellow 0.1.92 runtime repair candidate

- Direct child of 2.1.1 RC.
- Protected Yellow fresh Setup and boot-to-game runtime PASS.
- Fixed release-blocking R/B/Y MOD COMPAT crash: the screen required stale `src.render.Draw`, which is absent in current Gen1Recomp; it now uses `src.render.Font.drawBox`.
- Hardened Gen1 kerning installation timing by retrying on `game.ready` and `save.loaded` after generation is known.
- Corrected MOD COMPAT TEXT LAYOUT detection to use the implementation's real `_nuzlockeAdvanceOf` marker.
- Gold remains generation-gated from the Gen1 kerning fallback.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file tree preserved.
- MOD COMPAT and visible kerning behavior remain RUNTIME TEST REQUIRED.

---

# 2.1.1 — release candidate

- Direct child of `2.1.0`; no lineage reset.
- Source-audited Gen1Recomp 0.1.92 (`v0.1.90..v0.1.92`).
- Expanded engine declaration from `>=0.1.86 <0.1.91` to `>=0.1.86 <0.1.98`.
- 0.1.92 is source-reviewed; 0.1.93–0.1.97 are forward-allowed, not runtime-confirmed.
- Reviewed new sandbox compatibility layer and sanctioned `mod.fetch` / `mod.job` APIs.
- Nuzlocke intentionally requests neither `network` nor `background`: current rules do not require them.
- Confirmed no direct `love.filesystem`, `love.thread`, socket, `mod.fetch`, or `mod.job` use in the shipped Lua tree.
- Removed obsolete mod-card warning about the historical multi-part beta updater tag; 2.1.x now uses ordinary SemVer.
- Mod API remains 2; save schema remains 4; no gameplay-rule migration.
- Wide Menus phase-1 behavior from 2.1.0 remains runtime-test-required.
- Full 15-file tree preserved.

---

# 2.1.0 — canonical versioning transition

- Renumbered the current canonical `2.0.0-beta.31.0.4` development tree to `2.1.0`.
- No gameplay, save-schema, Mod API, compatibility, UI, or rule behavior changed.
- This establishes ordinary SemVer for future Gen1Recomp GitHub Release/update detection.
- The complete pre-2.1.0 beta lineage remains preserved below as historical development history.
- Full 15-file repository tree preserved.

---

# 2.0.0-beta.31.0.4 — optional Wide Menus Nuz Rules integration

- Direct child of `.31.0.3`; 15-file tree preserved.
- Added `wide-menus` as an optional dependency using its documented public presentation API.
- In-game R/B/Y `NuzlockeConfigScreen` claims the 304×144 wide layout when Wide Menus is active.
- Expanded the rule-list canvas from 20 to 38 columns, gives rule names/header names additional horizontal room, moves values/status to the right-side column, and expands description wrapping.
- Nuzlocke retains all rule state, input, collapse, numeric-editing, delegation and lock semantics.
- Wide Menus absent/disabled: existing 160×144 native layout remains the fallback.
- Fresh New Game Setup is deliberately excluded from Wide Menus in this first phase.
- Gold is deliberately excluded from Wide Menus in this first phase.
- No save-schema, Mod API, or challenge-rule change.
- Lua parser/static integration checks PASS; visual/input runtime validation remains required.

---

# 2.0.0-beta.31.0.3 — Mt. Moon Dungeon Lock-In repair

- Direct child of `.31.0.2`; full 15-file tree preserved.
- Fixed the reported R/B/Y case where the Pokémon Center beside Mt. Moon could be classified as the `MT_MOON` dungeon family and trap the player under Dungeon Lock-In.
- Hardened `dungeonFamily()` before prefix matching: Pokémon Center and Poké Mart service-interior identifiers fail open instead of inheriting a dungeon family from a landmark prefix.
- The exclusion is deliberately generic so similarly named dungeon-adjacent service interiors do not reproduce the same prefix-bleed bug.
- Actual Mt. Moon floor identifiers remain classified as `MT_MOON`; existing Dungeon Lock-In entrance/exit behavior is otherwise unchanged.
- Lua parser/static/mock classifier checks PASS; reported Mt. Moon Center scenario remains RUNTIME TEST REQUIRED.

---

# 2.0.0-beta.31.0.2 — Gen1Recomp 0.1.90 compatibility review

- Direct child of `.31.0.1`; full 15-file repository tree preserved.
- Reviewed upstream `v0.1.89...v0.1.90` changes.
- Confirmed the existing manifest envelope `>=0.1.86 <0.1.91` already admits 0.1.90.
- Upstream 0.1.90 primarily adds orphaned save-slot recovery and generation-aware PartyMenu field-move handling for Gold, plus platform/test hardening.
- Nuzlocke's SaveData use remains on engine-owned `saveFilename`, `activeSlot`, `deleteSlot`, and `persistenceFs` seams; no direct filesystem regression was introduced.
- Gold's new PartyMenu fallback to generic `overworld:useFieldMove(...)` is compatible with Nuzlocke's current rule architecture and is a useful future seam for deeper Dungeon Lock-In field-move hardening.
- No Nuzlocke mechanic required patching for 0.1.90; this build records the reviewed compatibility baseline.
- Lua parser/static PASS; runtime on Gen1Recomp 0.1.90 remains TEST REQUIRED.

---

# 2.0.0-beta.31.0.1 — lifecycle and progression repair

- Direct child of `.31.0.0`; 15-file tree preserved.
- Synchronizes live `difficulty_profile` changes with staged stable `difficulty_provider_id` state and documents why live changes leave `pendingRulesDirty=false`.
- Makes Modern UI registration generation-safe and one-shot, prevents unknown-game registration, marks the bridge inactive on Gold, and generation-gates model/actions so stale provider registrations cannot present Gen1 UI on Gold.
- Removes the install-time save-editor short-circuit from R/B/Y title Setup fallback so the installed wrapper can re-check editor state on every title-menu open.
- Trainer Rewards now validates `gymProgressKey`, returns `true` after recognized R/B/Y Gym Leader progression, and compares Gym Leader identity fields independently to prevent cross-field concatenation false matches.
- Champion progression already returned `true` in `.31.0.0` and was intentionally left unchanged.
- Lua parser/static checks PASS; runtime validation remains required.

---

# 2.0.0-beta.31.0.0 — World Building / Bryan expansion

- Direct child of `.30.1.22`; no repository files added, removed, or renamed.
- Expanded Tier 3 Pokémon Bois Club Bryan dialogue.
- Bryan explicitly claims he created the Nuzlocke mod and worked on Gen1Recomp using the player's bedroom computer.
- Tier 3 home flavor establishes Bryan as a recurring houseguest who uses the player's computer and game console.
- Added cheeky, non-graphic Mom/Bryan relationship innuendo at Tier 3.
- Added rotating Tier 3 Pallet TV reports, including sightings of a man resembling the Pokémon Bois Club leader walking Pallet Town and sneaking through windows at night.
- Polished several Tier 3 rule-specific World Building lines for greater contextual variety.
- Added design backlog notes for a future provider-aware Black Market shop and future NPC/rule reactions to achievements. Neither system is mechanically enabled here.
- Lua parser/static validation PASS; new dialogue paths remain RUNTIME TEST REQUIRED.

---

# 2.0.0-beta.30.1.22 — Tracker / Compat / NUZ INFO intelligence

- Direct child of `2.0.0-beta.30.1.21`; no repository files added, removed, or renamed.
- Encounter Tracker / Area Guide now display compact semantic encounter tags such as WILD, FISH, GIFT, STATIC, TRADE and RNG, with provider context where known. Randomizer information remains spoiler-safe.
- MOD COMPAT now reports a broader effective-ownership map: starter/encounter/learnset RNG, trainer money, level caps, difficulty profile, species metadata, Pokémon identity, encounter provider, escape/warp provider, movement, presentation and text layout.
- NUZ INFO Catch page now reports legality against the **current active rules** plus restriction reasons and provider/source provenance.
- NUZ INFO legality is read-only: it never removes, boxes, edits or reclassifies an existing Pokémon.
- Corrected stale internal build identifiers inherited from `.30.1.21`; all executable build exports now identify `.30.1.22`.
- Lua parser/static validation PASS; new UI behavior remains RUNTIME TEST REQUIRED.

---

# 2.0.0-beta.30.1.21 — compatibility intelligence and contextual guidance

- Added spoiler-safe external encounter-randomizer ownership context to Encounter Tracker.
- Added the dedicated MOD COMPAT ownership diagnostics screen.
- Expanded translation-safe semantic UI matching.
- Added merged external species metadata access.
- Added adaptive compatibility/tracker presentation helpers.
- Added context-sensitive World Building guidance for consumed areas, Lock-Ins, caps, Forgiveness Tokens, progression catches and externally randomized areas.


### Reconciled historical record: 2.0.0-beta.30.1.21


- Added spoiler-safe randomizer ownership context to Encounter Tracker.
- Added dedicated MOD COMPAT ownership diagnostics screen.
- Expanded translation-safe semantic menu matching.
- Added merged external species metadata export.
- Added adaptive compatibility/tracker presentation helpers.
- Added context-sensitive World Building guidance API.


This file is the permanent cumulative development/release history. A known revision is retained even when its exact per-build delta is only partially recoverable; uncertain history is labeled rather than guessed. A beta.29.2.0 history-recovery pass reconciled preserved source, packages, runtime evidence, and retained development records; newly recovered details are added only where their version attribution is supportable.

---

# 2.0.0-beta.30.1.20 — Gen1 variable-width Nuzlocke presentation

- Added internal R/B/Y-only variable-width tile-font presentation.
- Gold/Gen2 is hard-excluded from the Gen1 glyph transform.
- Compatible existing kerning ownership is not double-applied.
- Presentation only; challenge mechanics and save semantics were unchanged.

---

# 2.0.0-beta.30.1.19 — surviving packaged revision

- Surviving project File Library evidence confirms that a packaged `2.0.0-beta.30.1.19` revision existed between `.30.1.18` and `.30.1.20`.
- The exact per-build feature delta has not been recovered from a trustworthy changelog/source snapshot, so no behavior is attributed to this revision here.
- This heading exists to preserve confirmed lineage without inventing historical details.

---

# 2.0.0-beta.30.1.18

Optional Gen1 Modern UI presentation integration, directly from 30.1.17.

## Added — responsive presentation for high-use Nuzlocke information screens

When an active `gen1_modern_ui` provider exposes its documented `registerAdapter` API, Nuzlocke now publishes a source-owned semantic screen contract for:

- Encounter Tracker / Area Guide;
- NUZ INFO Catch / Stat / Move pages;
- Nuzlocke Trainer Card / active-rule status page.

Nuzlocke continues to own all underlying state and actions. The UI provider receives only read-only row models plus semantic navigation callbacks.

### Fail-safe behavior

- No hard dependency on Modern UI.
- Provider is detected as active through `mod.find`, not installed-only.
- Registration retries across load lifecycle events.
- If the provider is absent, unsupported, disabled, or rejects the contract, classic Nuzlocke screens remain unchanged.
- If a semantic model cannot be produced, the provider can fall back instead of Nuzlocke replacing mechanics.
- Gold is not registered because the inspected Modern UI line is Gen1-only.

### Deliberately not adapted yet

`NuzlockeConfigScreen` (Setup / Nuz Rules editor) now has a stable screen ID but remains native. Fresh Setup is protected runtime behavior and the editor owns complex numeric editing, collapsed sections, permanent-seal confirmation, descriptions, and staged pre-game state. It will only move to an external presenter after dedicated runtime validation.

### Internal classic screens retained

Native R/B/Y and Gold draw/update implementations remain intact. The integration is presentation-only.

## Validation

- All five Lua files parser PASS.
- 15-file package tree.
- Mock adapter provider registration PASS.
- Semantic model/action harness PASS for Tracker, NUZ INFO and Trainer Card.
- `.30.1.17` localization-safe Mart gate retained.

---

# 2.0.0-beta.30.1.17

Translation-safe R/B/Y Mart enforcement, directly from 30.1.16.

## Fixed — translated BUY / SELL labels could bypass No Buying / No Selling

The R/B/Y ShopMenu compatibility wrapper previously identified the two shop actions by comparing the rendered menu label only to literal English `BUY` and `SELL`.

Localization mods legitimately build those rows through `Strings("BUY")` and `Strings("SELL")`. For example, the Finnish translation renders them as `OSTA` and `MYY`. The old wrapper therefore failed to decorate either action, allowing purchases/sales despite the Nuzlocke rules being enabled.

30.1.17 keeps the existing English recognition and additionally compares each row against the current live translated `Strings("BUY")` / `Strings("SELL")` values.

No shop mechanics, stock, pricing, token behavior, or Gold Mart logic are otherwise changed.

## Validation
- All four Lua files parser PASS.
- Focused localization harness PASS:
  - English BUY/SELL detected;
  - Finnish OSTA/MYY detected through translated source values;
  - unrelated menu labels remain untouched.
- Existing Route Forgiveness shop stock bridge remains in the same wrapper.
- 14-file package tree unchanged.

---

# 2.0.0-beta.30.1.16

Type Locke canonical Fairy compatibility repair, directly from 30.1.15.

## Fixed — Fairy typings could be treated as unknown by Mono/Duo Type Locke

Compatible typing/content mods can add the canonical `FAIRY` type to the merged species registry. Nuzlocke's Type Locke vocabulary previously stopped at Dark/Steel, so a pure-Fairy species could produce no recognized Type Locke metadata and hit the intentional "unknown custom schema" fail-open behavior.

That meant a legitimate Fairy species could be allowed by an unrelated Monolocke simply because Nuzlocke did not recognize the canonical type.

30.1.16 adds canonical Fairy awareness to Type Locke.

### Save-safe selector layout

Existing numeric selector meaning is preserved exactly:
- `0..16` = existing Normal through Steel values;
- `17` = RANDOM, unchanged from every prior build;
- `18` = FAIRY, newly appended.

RANDOM is deliberately **not moved**. No migration of old saves or pending Setup profiles is required.

### Runtime behavior

- Fairy Monolocke is now selectable.
- Fairy may be either side of a Duolocke.
- Pure Fairy species are evaluated as Fairy rather than unknown/fail-open.
- Dual types such as Water/Fairy match either appropriate allowed type.
- RANDOM can roll Fairy only when Fairy is represented in the live merged species pool.
- RANDOM still never persists as runtime legality state; it resolves once to concrete type(s).
- Unknown genuinely custom type schemas continue to fail open.
- Manual Dark/Steel/Fairy selections remain possible even when the current base species pool has no such species, preserving compatibility-mod challenge setups.

### Compatibility target

This specifically closes the Nuzlocke-side gap found while reviewing `steel_typing` / STEEL-FAIRY AND TYPING CHARTS 2.0.1, but the implementation is package-name agnostic and works with any mod that exposes canonical `FAIRY` through the merged Pokémon/type metadata.

## Validation

- All four Lua files parser PASS.
- Selector compatibility audit PASS: RANDOM remains 17; FAIRY is 18.
- Focused Type Locke harness PASS:
  - Fire Mono rejects pure Fairy;
  - Fairy Mono accepts pure Fairy;
  - Water Mono accepts Water/Fairy;
  - Fairy Mono accepts Water/Fairy;
  - random viable pool includes Fairy only when a Fairy species is present;
  - old RANDOM value 17 still resolves as RANDOM, never Fairy;
  - DUO duplicate correction skips the RANDOM sentinel.
- 14-file package tree unchanged.

---

# 2.0.0-beta.30.1.15

World Building tier-fallback consistency fix, directly from 30.1.14.

## Fixed — `queueTrainerFlavor` fallback ignored its caller-selected minimum tier

`queueTrainerFlavor(key, message, minimumTier)` correctly checked its requested tier before trying battle-native `say` / `emit`, but its last-resort path called `worldOnce(game, key, message)`.

`worldOnce` had a hardcoded Tier 3 gate. Therefore a caller such as First Rival Mercy, which explicitly requests Tier 1, could pass the outer Tier 1 gate and still lose its message on battle objects without `say` or `emit`.

30.1.15 makes `worldOnce` accept an optional `minimumTier`:
- omitted -> Tier 3, preserving its historical default;
- supplied -> honors the caller's explicit threshold.

`queueTrainerFlavor` now passes its own `minimumTier` into the fallback.

This preserves the same once-per-save flag behavior and the same `pushWorldText` safety path while making all three delivery seams agree on whether the message is eligible.

## Validation
- All four Lua files parser PASS.
- Focused fallback-tier harness PASS:
  - Tier 1 + minimum 1 + no say/emit -> fallback displays and sets once flag;
  - Tier 2 + minimum 1 -> fallback displays;
  - Tier 2 + default minimum 3 -> remains blocked;
  - failed text push -> does not consume once flag;
  - repeated successful call -> remains once-only.
- 14-file package tree unchanged.

---

# 2.0.0-beta.30.1.14

First Rival Mercy one-shot hardening, directly from 30.1.13.

## Fixed — non-opening rival-shaped battle could permanently burn First Rival Mercy

`armFirstRivalForgiveness()` previously persisted `nuzlocke_first_rival_battle_seen = true` immediately after the broad `isRivalBattle()` test, before the stricter `isOpeningRivalBattle()` check.

A later/reordered/rewound rival-classified battle could therefore consume the durable slot even though it was not the canonical opening encounter. If the true opening battle was reached afterward, First Rival Mercy could never arm for that save.

30.1.14 changes the latch semantics:
- non-rival battle: unchanged, ignored;
- rival but not opening rival: rejected without consuming the durable flag;
- actual opening rival: marks `nuzlocke_first_rival_battle_seen = true`;
- opening rival with First Rival Mercy OFF: still consumes the one-shot, preserving the original rule semantics;
- opening rival with First Rival Mercy ON: arms the battle-local forgiveness flag as before.

The existing `isOpeningRivalBattle()` old-save safeguard remains authoritative, so later rival fights on old saves are still never granted First Rival Mercy merely because the durable flag is absent.

## Validation
- All four Lua files parser PASS.
- Focused one-shot state-machine harness PASS.
- Static ordering audit confirms `isOpeningRivalBattle()` is evaluated before the durable save write and the save write occurs only after the `not opening` return.
- 14-file package tree unchanged.

---

# 2.0.0-beta.30.1.13

Solo Only scripted-trade enforcement fix, directly from 30.1.12.

## Fixed — Solo Only gated gifts but not NPC trades

`specialAcquisitionDenied()` applied the Solo Only party-slot check only when `kind == "gift"`.

Wild catches were already covered through the normal catch gate, and gifts were covered here, but scripted trades in both R/B/Y and Gold route through `specialAcquisitionDenied(..., "trade")` and therefore bypassed Solo Only.

A player could complete an NPC trade while Solo Only was active and add a second usable party Pokémon, violating the selected challenge rule.

30.1.13 extends only that final Solo Only acquisition check:

- gift acquisitions: unchanged, still gated;
- trade acquisitions: now gated by the same occupied-solo-slot check;
- all earlier special-acquisition rule ordering is unchanged;
- existing `acquisitionDeniedMessage(..., "solo", ...)` handling is reused, so no new dialogue plumbing is introduced.

## Validation
- All four Lua files parser PASS.
- Focused acquisition-gate harness PASS:
  - gift + occupied solo slot -> `solo`;
  - trade + occupied solo slot -> `solo`;
  - gift/trade + available solo slot -> allowed by Solo Only;
  - unrelated acquisition kind is not newly blocked by this check.
- 14-file package tree unchanged.

---

# 2.0.0-beta.30.1.12

Stored-location recovery orphan fix, directly from 30.1.11.

## Fixed — conflicting stored catch location could be falsely marked recovered

`importStoredCatchLocations()` previously set `mon.nuzlockeTrackerRegistered = true` even when the stored location conflicted with a different already-established catch in that area and no tracker/area entry was written.

That combination could permanently orphan the Pokémon:
- no new area log entry;
- no `caught_areas` restoration;
- stale `catchLocation` still present;
- false registered marker prevented later recovery logic from treating it as unresolved.

30.1.12 now marks the mon registered only when the stored location actually restores or matches tracker state. A true conflict clears the stale `catchLocation` and false registered marker so the mon remains eligible for normal Legacy Recovery.

Successful empty-area and matching-entry recovery behavior is otherwise unchanged.

## Validation
- All four Lua files parser PASS.
- Static recovery audit confirms the conflict branch clears `catchLocation` and registration.
- Focused three-case branch harness PASS: empty restore, matching restore, conflicting Legacy fallback.
- No files added or removed.

---

# 2.0.0-beta.30.1.11

Trainer Rewards split-module namespace repair, directly from 30.1.10.

## Fixed — Gold Mart Route Forgiveness crash

`G2.installMartGate()` called `forgivenessEnabled()` as a bare global from `main.lua`. That function belongs to the separately loaded `trainer_rewards.lua` module and is exported through `mod.exports.__beta26.TrainerRewards`.

On Gold, constructing a STANDARD Mart while Route Forgiveness was enabled could therefore throw `attempt to call a nil value (global 'forgivenessEnabled')`.

The Mart wrapper now calls:
`mod.exports.__beta26.TrainerRewards.forgivenessEnabled()`.

## Fixed — bare Forgiveness Token count call in rules/status presentation

A second instance of the same split-module namespace bug was found in the rule-label path:
`forgivenessTokens()` was also called as a bare global.

It now calls:
`mod.exports.__beta26.TrainerRewards.forgivenessTokens()`.

This prevents the Route Forgiveness status/summary path from depending on a nonexistent main-chunk global.

## Validation
- Searched `main.lua` for unqualified `forgivenessEnabled(` and `forgivenessTokens(` calls: none remain.
- All four Lua files parser PASS.
- 14-file package tree unchanged.
- Prior 30.1.8 Trainer Money fixes, 30.1.9 Gold cap order, and 30.1.10 title save-editor guard retained.

---

# 2.0.0-beta.30.1.10

Title Setup save-editor hardening, directly from 30.1.9.

## Fixed — recurring title wrapper used only install-time save-editor gating

`title_setup_compat.lua` previously checked `isSaveEditorSession()` only when installing the R/B/Y title fallback wrapper. If the wrapper was installed while editor mode was inactive, later title-menu opens could still run SETUP insertion after the process/session entered a save-editor context.

The R/B/Y wrapper now re-checks `isSaveEditorSession()` on every `TitleState:openMenu()` call before inspecting or modifying the final title row list.

The same per-call protection is applied to the Gold recurring title-list wrapper where that adapter is present.

The existing install-time checks remain as cheap early-outs, but runtime/session-sensitive editor state is no longer assumed to be permanent.

## Validation
- All four Lua files parser PASS.
- Static wrapper audit confirms per-call editor checks are present in recurring title-menu fallback callbacks.
- No files added or removed.
- 30.1.8 Trainer Money provider fixes and 30.1.9 Gold cap-order repair are retained.

---

# 2.0.0-beta.30.1.9

Gold level-cap ordering repair, directly from 30.1.8.

## Fixed — Johto middle-Gym cap regression

The current `gscStages` list had regressed to:

`Chuck 30 -> Jasmine 35 -> Pryce 31 -> Clair 40`

That reintroduced a non-monotonic raw stage ladder. The runtime cap floor could prevent the enforced value from physically dropping, but direct stage readers and boss presentation could still observe Pryce's raw 31 after Jasmine's 35.

The preserved project history already records the intended repair from beta.27.15: the cap-progression order is:

`Chuck -> Pryce -> Jasmine`

30.1.9 restores that ordering without inventing new cap numbers:

`Chuck 30 -> Pryce 31 -> Jasmine 35 -> Clair 40`

### Important distinction

Gold badge slot mappings are unchanged:
- Chuck / Storm remains badge slot 5.
- Jasmine / Mineral remains badge slot 6.
- Pryce / Glacier remains badge slot 7.

Those are save/badge identity mappings, not the ordered boss-cap ladder. Reordering `gscStages` does not rewrite or renumber Gold badges.

## Previous 30.1.8 fixes retained

- Trainer Money runtime scaling respects active `economy_provider` delegation.
- Delegated Trainer Money neutral display is 100% / index 4.

## Validation

- All four Lua files parser PASS.
- Static stage-order audit PASS.
- Gold Johto Gym fallback cap sequence is monotonic: 9, 16, 20, 25, 30, 31, 35, 40.
- No files added or removed.

---

# 2.0.0-beta.30.1.8

Provider-delegation bugfix child of 30.1.7.

## Fixed — Trainer Money provider delegation

Two related defects remained in the 30.0 provider-delegation system.

1. Runtime Trainer Money scaling ignored `externalRuleDelegation`.
   - The Rules UI could correctly show the control as externally owned while `trainer_rewards.lua` still applied Nuzlocke's stored multiplier after battle.
   - This could stack Nuzlocke payout scaling on top of an active `economy_provider`.
   - `scaleTrainerMoney()` now checks the same delegation seam and, when delegated, leaves the provider's final wallet result completely untouched.

2. Delegated numeric UI assumed `spec.min` was always the neutral value.
   - Trainer Money has `min = 0`, but index 0 means 0% payout.
   - Its actual neutral/vanilla value is index 4 = 100%.
   - Numeric rule specs can now declare `neutral`.
   - Trainer Money declares `neutral = 4`.
   - `getConfigValue()` resolves delegated numerics as `spec.neutral` first, then falls back to `spec.min`.

## Compatibility

- No provider: Trainer Money behavior remains unchanged.
- Active `economy_provider`: Nuzlocke performs no Trainer Money wallet rewrite.
- Delegated Trainer Money displays 100%, not 0%.
- Existing Gold Pokégear work from 30.1.7 is unchanged and remains runtime TEST REQUIRED.
- No files added or removed.

## Validation

- All four Lua files parser PASS.
- Dedicated mocked Trainer Money delegation test PASS:
  - delegated payout left untouched;
  - nondelegated 50% payout still scales correctly.
- Static neutral-value check PASS: delegated Trainer Money resolves to index 4.

---

# 2.0.0-beta.30.1.7

Gold Pokégear integration development build, directly from 30.1.6.

## New — optional Pokegear Cards integration

When active `pokegear_cards` API v1 is available on Gold, Nuzlocke now integrates through its append-only `mod.exports` API.

### NUZ Pokégear card
- Adds a `NUZ` strip card.
- Four pages: Run Status, Encounters, Rules, Caps & Difficulty.
- Live catches, deaths, Route Forgiveness Tokens, active Nuzlocke loadout, area counts, failed encounters, Gold rule names, next authoritative cap/boss, and selected difficulty provider.
- UP/DOWN changes pages. A on Rules advances additional rule rows. B returns through the provider's normal card behavior.

### MAP overlay
- Adds encounter-state markers without replacing the vanilla MAP.
- Aggregates visited/open, failed, and caught/claimed tracker state by Gen 2 landmark.
- Caught takes precedence over failed, which takes precedence over visited/open when several maps share a landmark.
- Filters Johto/Kanto landmark markers to the currently displayed regional map.
- Uses the provider's scissored overlay helper and does not own MAP input.

### RADIO World Building
- Adds one short Nuzlocke broadcast/status line when World Building is enabled.
- T1 is direct status, T2 uses Johto-report framing, T3 uses deterministic landmark/run-state flavor.
- Cosmetic only: never changes tuning, station availability, music, story flags, encounters, or enforcement.

### Compatibility
- PHONE intentionally untouched because Pokegear Cards documents visible phone appends as an input-loop fork.
- Detection is `mod.find("pokegear_cards")`: installed-but-disabled is not treated as active.
- Stable IDs: `nuzlocke_status`, `nuzlocke_map_status`, `nuzlocke_radio_world`.
- `pokegear_cards` added as an optional dependency.
- New focused `pokegear_integration.lua` uses sandbox-safe sibling loading.
- R/B/Y behavior unchanged.

## Validation
- Existing 30.1.6 Setup sandbox repair unchanged.
- Package tree expands from 13 to 14 files with the focused integration module; nothing removed.
- All four Lua files parser PASS.
- Mock provider registration PASS: one card, MAP append, RADIO append, zero PHONE appends.
- New Gold Pokégear paths remain TEST REQUIRED.

---

# 2.0.0-beta.30.1.6

Release candidate built directly from 30.1.5 with no intended gameplay behavior changes beyond version identity/documentation.

## Runtime-confirmed current-engine compatibility

- **Gold fresh NEW GAME -> Nuzlocke SETUP: RUNTIME PASS.**
- **Yellow fresh NEW GAME -> Nuzlocke SETUP: RUNTIME PASS.**
- **Blue fresh NEW GAME proceeds into the player's bedroom: RUNTIME PASS.**

These passes confirm the 30.1.5 fresh-Setup sandbox repair on the tested current Gen1Recomp line.

## Confirmed crash repair

The fresh-game Setup CTD was traced to legacy pre-game Setup-profile persistence touching the filesystem facade directly. Gen1Recomp 0.1.86 blocks that facade in sandboxed mods. The forbidden access occurred before `NuzlockeConfigScreen` was pushed, which is why earlier screen-level crash guards did not intercept it.

30.1.5 replaced that path with per-session Gen1/Gold Setup-profile storage. 30.1.6 preserves that implementation unchanged and records the successful runtime validation.

## Remaining limitation

- Setup-profile preferences currently persist only for the running Gen1Recomp session.
- Fully closing/reopening the application resets those pre-game Setup preferences to defaults.
- Rules committed to an actual game save continue using their normal save-backed persistence.

## Protected runtime evidence retained

- Yellow existing-save boot: PASS.
- Yellow Nuzlocke menus visible: PASS.
- Yellow in-game Nuz Rules: PASS.
- Yellow tested Gym Lock-In boundary rejection: PASS / protected.
- Yellow tested Poké Mart duplicate-dialogue regression case: PASS after the active-TextBox World Building guard.
- Gold and Yellow fresh Setup: PASS.
- Blue fresh NEW GAME bedroom entry: PASS.
- Permanent Rule Seal remains WIP / unselectable.
- Yellow `NUZ` vertical position remains a deferred cosmetic issue.

## Validation

- Direct child of 30.1.5.
- No older branch restored.
- Repository tree retained at 13 files.
- Lua sources: `main.lua`, `title_setup_compat.lua`, `trainer_rewards.lua`.
- All Lua files pass the real Lua parser.

---

# 2.0.0-beta.30.1.5

Fresh Setup sandbox compatibility repair, built directly from 30.1.4.

- Identified a concrete current-engine incompatibility before the Setup screen is pushed.
- The legacy Setup profile loader/saver directly accessed the mod-blocked filesystem facade.
- Gen1Recomp 0.1.86 explicitly blocks that facade inside sandboxed mods and directs mod authors to public mod persistence/read APIs instead.
- Because those accesses occurred before `NuzlockeConfigScreen` opened, earlier construction/update/draw crash guards could not intercept the failure.
- Replaced cross-restart Setup-profile file I/O with session-local Gen1/Gold profile copies.
- Fresh Setup no longer touches the blocked filesystem facade.
- Normal active-save rule persistence is otherwise unchanged.
- Temporary limitation: closing the application resets saved Setup-profile preferences to defaults until a later pass chooses a deliberate public cross-restart preference-storage contract.
- No additional Lua module split was added.

---

# 2.0.0-beta.30.1.4

Runtime-method crash diagnostic, built directly from 30.1.3.

- 30.1.3 still crashed without showing its guarded-construction error box.
- This strongly suggests `NuzlockeConfigScreen` is constructing/pushing successfully and failing on its first runtime frame rather than during `mod.ui.push`.
- Wrapped the configuration screen instance's `update()` and `draw()` methods with protected calls.
- On a Lua runtime failure, the faulty instance disables itself, attempts to pop, and shows `NUZ SETUP UPDATE ERROR` or `NUZ SETUP DRAW ERROR` containing the underlying error.
- `lastConfigScreenError` is updated with the phase and traceback/error.
- No additional module split or gameplay-rule change.

---

# 2.0.0-beta.30.1.3

Setup/Nuz Rules crash-containment diagnostic based directly on 30.1.2.

- The same Setup crash was reproduced using unchanged, **unsplit** published 29.3.0 gameplay Lua on the current engine. The existing split therefore is not sufficient evidence for the crash cause.
- Current Gen1Recomp's screen resolver pcall-isolates a failed mod screen factory and then attempts a built-in fallback. `NuzlockeConfigScreen` is custom-only, so a construction failure can become a missing-builtin desktop crash.
- Every Nuzlocke Setup/Nuz Rules open now goes through a protected public `mod.ui.push` transaction.
- If construction fails, the game should stay alive and show `NUZLOCKE SETUP ERROR` with the underlying error text.
- The error is retained in `mod.exports.__beta26.lastConfigScreenError`.
- While implementing this guard, adding one more top-level local caused Lua's **200-local compile limit** to fire. The guard is therefore export-backed rather than local. This confirms the monolithic chunk has essentially no local-variable headroom and strengthens the case for another carefully planned split later, but does not by itself explain the current Setup crash.
- No additional split is included in this diagnostic build.

---

# 2.0.0-beta.30.1.2

Release/documentation child of `2.0.0-beta.30.1.1`. **No intended gameplay/code behavior change beyond version identity.**

## Accepted known bug for this beta release

- **KNOWN RUNTIME CRASH — Gold fresh NEW GAME -> SETUP selection.**
- Runtime retest on 30.1.1 still crashes when selecting the Nuzlocke SETUP entry on Gold.
- The earlier attempt to withdraw the newer Gold `MainMenu:buildList()` compatibility fallback did **not** resolve the crash.
- The disabled fallback remains preserved in comments for future investigation.
- Do **not** claim Gold fresh-game SETUP is working in this release.
- Gold remains BETA/experimental and this specific startup configuration path is a known broken path accepted for release due to development pause.

## Runtime evidence retained

- Yellow existing-save boot: PASS.
- Yellow Nuzlocke menu visibility: PASS.
- Yellow in-game Nuz Rules: PASS.
- Yellow tested Gym Lock-In boundary rejection: PASS / protected.
- Yellow specific Poké Mart duplicate-dialogue regression case: PASS after the active-TextBox World Building guard.
- Permanent Rule Seal remains WIP / grey / unselectable.
- Yellow `NUZ` status vertical placement remains a known deferred cosmetic issue.

## Release discipline

- This build descends directly from 30.1.1.
- No older branch was restored.
- No additional Lua split was performed.
- All current repository files are retained.
- Lua parser validation passes for all three Lua sources.

---

# 2.0.0-beta.30.1.1

Gold NEW GAME -> SETUP crash containment, built directly from `2.0.0-beta.30.1.0`.

- Runtime FAIL: selecting the Nuzlocke Setup entry during a fresh Gold NEW GAME crashed the 30.1.0 candidate.
- Compared the current Gold title path against the last published `2.0.0-beta.29.1.0`.
- The published/runtime-PASS design already used the shared `ui.title_menu.items` injection plus the small Gold `src.ui.gen2.MainMenu:choose()` adapter.
- Disabled only the later 0.1.86-era Gold `MainMenu:buildList()` compatibility fallback from `title_setup_compat.lua`.
- The disabled `installGold()` implementation is preserved verbatim inside a Lua long comment for future diagnosis/recovery; it was not deleted.
- R/B/Y `title_setup_compat.lua` fallback remains active.
- No broader Gold gameplay systems, rules, tracker, randomizer, battle, item, mart, encounter, or provider changes were reverted.
- Gold NEW GAME -> SETUP is now RETEST REQUIRED.
- `2.0.0-beta.30.1.0` should be treated as a rejected runtime-crash candidate, not the release build.

---

# 2.0.0-beta.30.1.0

Promotion release based directly on `2.0.0-beta.30.0.0.21`.

## Runtime-confirmed Yellow results carried into this release
- **PASS — existing-save boot and Nuzlocke menu visibility.**
- **PASS — in-game Nuz Rules opens on an existing Yellow save.**
- **PASS — Gym Lock-In boundary enforcement.** The tested Yellow Gym boundary correctly prevented the prohibited entry/exit transition. This runtime-confirmed behavior is protected against casual rewrite.
- **PASS — duplicate-dialogue regression target, tested NPC.** The Yellow Poké Mart NPC that previously repeated trailing phrases across textbox pages no longer reproduced the defect after the 30.0.0.20 active-TextBox World Building guard.
- The active-TextBox guard is retained as a **protected presentation compatibility safeguard**: optional Nuzlocke World Building text must not be layered over an already-active engine/other-mod TextBox. This is presentation-only and must never become required for mechanical enforcement.

## Promoted development work
- Gen1Recomp 0.1.86–0.1.90 compatibility target.
- First approved modularization retained:
  - `title_setup_compat.lua`
  - `trainer_rewards.lua`
- Permanent Rule Seal remains **WIP / grey / unselectable**. Its dormant implementation and recovery map remain preserved for later work.
- Trainer Money/status percentage presentation uses explicit `%` labels.
- Maximum BST uses preset selection: **OFF / 400 / 450 / 500 / 550** while preserving legacy custom thresholds until changed.
- Yellow `NUZ` status placement remains a known deferred cosmetic issue: it is currently slightly too low and should later move upward a little, but not back to the previous overly-high position.

## Validation
- `main.lua`, `title_setup_compat.lua`, and `trainer_rewards.lua` pass the available Lua parser/compiler check before packaging.
- Static success is not promoted to runtime PASS unless explicitly listed above.
- Blue/Gold fresh-game SETUP behavior and modularized Trainer Money/Forgiveness/progression paths remain runtime-test targets where not already confirmed.

---

# 2.0.0-beta.30.0.0.21

- Percentage-based rule presentation is now consistent across Rules/Setup and Nuzlocke status surfaces.
- Trainer Money uses one shared percentage-label table everywhere: 0%, 25%, 50%, 75%, 100%, 150%, 200%, 300%, 500%.
- Maximum BST is no longer a free-form three-digit editor.
- Maximum BST now cycles through **OFF / 400 / 450 / 500 / 550** with A or Left/Right like other preset controls.
- The enforcement/API contract still uses the actual BST threshold value, not a preset index.
- Older development saves containing a non-preset custom BST value preserve that exact enforcement value until the player changes Maximum BST; the UI marks it CUSTOM, and the next change snaps to the nearest point on the preset ladder before moving in the requested direction.
- No new Lua modules/files added or removed.
- Yellow NUZ vertical placement remains deferred; duplicate-dialogue `.20` fix remains independently RETEST REQUIRED.

---

# 2.0.0-beta.30.0.0.20

- Yellow runtime on 30.0.0.16 reconfirmed the recurring dialogue-page overlap/duplication defect: unrelated vanilla NPC text repeated trailing phrases at the start of subsequent pages.
- This recurrence is now tracked as a protected regression target rather than a one-off.
- Added a global **World Building presentation invariant**: `pushWorldText()` refuses to push optional Nuzlocke flavor text if any `TextBox` is already active on the game state stack.
- Rationale: Gen1Recomp textboxes are foreground/blocking states. Optional nested Nuzlocke text must not interrupt a vanilla dialogue transaction and then resume it at an already-presented page/scroll boundary.
- This guard affects cosmetic World Building presentation only. Mechanical enforcement must not depend on `pushWorldText()` and remains unchanged.
- Direct rule-denial flows that intentionally replace a blocked action remain separate and are not globally suppressed.
- Yellow `NUZ` trainer-card/status vertical placement remains a known deferred cosmetic issue: current position is too low and should later move slightly upward, but not back to its previous overly-high position.
- Permanent Rule Seal remains WIP/grey/unselectable from 30.0.0.19.
- No Lua files/modules added or removed.

---

# 2.0.0-beta.30.0.0.19

- **Permanent Rule Seal moved to WIP/dormant status.**
- The row remains visible but is grey, displays `WIP`, is skipped by cursor navigation, and cannot be activated, matching Wonderlocke's placeholder behavior.
- The complete confirmation, immediate `mod.storage` durability, durable-read, and lifecycle reconciliation implementation remains in `main.lua` behind `mod.exports.__beta26.permanentRuleSealWip = true`; it was not deleted.
- Existing `.17/.18` development-test seals are **not enforced while WIP**, so challenge rules become editable again. Their `rules_permanently_locked` and `rules/permanent_seal` markers are preserved rather than erased.
- Generic setters/presets cannot activate the effective `rules_locked` state while WIP.
- No additional Lua module split was made and no files were added/removed.

---

# 2.0.0-beta.30.0.0.18

- Yellow runtime PASS on 30.0.0.17: Permanent Rule Seal correctly prevented modification of challenge-rule sections while leaving QoL, World Building, and UI/presentation sections editable.
- Yellow runtime FAIL on 30.0.0.17: the permanent seal did not survive exiting/reloading when no subsequent ordinary Pokémon SAVE had persisted `mod.save`.
- Root cause aligned with Gen1Recomp 0.1.86's documented persistence model: `mod.save` is stored inside normal progress and therefore requires an ordinary Pokémon SAVE to become durable.
- Permanent Rule Seal now mirrors its irreversible commitment immediately to playthrough-scoped `mod.storage` under `rules/permanent_seal`.
- On `save.loaded` and `game.ready`, Nuzlocke reconciles the durable storage marker back into `rules_permanently_locked` + `rules_locked`.
- Older saves that already contain the permanent `mod.save` marker are automatically mirrored into durable storage when loaded.
- If playthrough storage is temporarily unavailable, current-session `mod.save` locking still occurs and lifecycle reconciliation retries later.
- No other rule is moved to independent storage; ordinary configurable rules continue to follow the Pokémon SAVE model.
- No new Lua files/modules added or removed.

---

# 2.0.0-beta.30.0.0.17

- Yellow runtime PASS on 30.0.0.16: existing save booted, Nuzlocke menu entries were visible, and in-game Nuz Rules opened successfully.
- Yellow runtime observation: Permanent Rule Seal correctly remained irreversible after activation, but activation safety was too weak.
- Replaced the old one-warning/two-press seal with **two explicit warning stages plus a third deliberate SEAL activation**.
- Warning 1/2 explains irreversibility; Warning 2/2 is a final confirmation; only the next activation commits the permanent seal.
- Moving the cursor away, collapsing/expanding a section, activating another control, or pressing B cancels the staged confirmation.
- Added a short input debounce between confirmation stages to reduce accidental keyboard/gamepad double advancement.
- The description panel now shows the active warning stage in both R/B/Y and Gold, including title Setup where overworld/world-text presentation is unavailable.
- No new Lua modules were added and no existing files were removed.
- Permanent Rule Seal persistence remains monotonic by design once the final confirmation is committed.

---

# 2.0.0-beta.30.0.0.16

- **Approved second Lua module split.** Added `trainer_rewards.lua`; no existing file was removed.
- A real Lua parser reproduced 30.0.0.15's failure exactly: `too many local variables (limit is 200) in function at line 23`.
- The first narrow wallet-only extraction was intentionally rejected before packaging because parser validation showed `main.lua` still exceeded the limit.
- The completed second module therefore uses the originally approved cohesive boundary: trainer-money scaling, Forgiveness Token counters/shop bridge/Gym-trainer awards, trainer reward identity helpers, and Gym/E4/Champion progression bookkeeping.
- Core battle/death rules, encounter legality, failed-encounter finalization, tracker, randomizers, title setup, general provider policy, and Gold gameplay systems remain in `main.lua`.
- `trainer_rewards.lua` uses Gen1Recomp's documented sandbox-safe `load(mod:read(...))` multi-file pattern.
- Directly affected systems are Trainer Money, Forgiveness Tokens/shop presentation/awards, and trainer progression used by level-cap reporting. These are RETEST REQUIRED.
- Other systems have no intentional logic change but remain smoke-test targets after the structural compile repair.
- Every Lua file and `manifest.json` are validated before packaging.
- Further Lua splitting requires new explicit user approval.

- Added a non-module structural safeguard after the approved second split: the late runtime-installer section now executes inside a nested function stored temporarily on `mod.exports.__beta26`. This creates a separate Lua local scope without adding another repository file or changing system ownership.
- This was necessary because parser validation showed the approved trainer-reward extraction alone still left `main.lua` above the 200-active-local ceiling.
- Final packaged state passes the available Lua parser for `main.lua`, `title_setup_compat.lua`, and `trainer_rewards.lua`.

- Added a non-module structural safeguard after the approved second split: the late runtime-installer section executes inside a nested function stored temporarily on `mod.exports.__beta26`. This creates a separate Lua local scope without adding another repository file or changing system ownership.
- Parser validation showed the approved trainer-reward extraction alone still left `main.lua` above the 200-active-local ceiling; the nested scope supplies the remaining compiler headroom.
- Final packaged state passes the available Lua parser for `main.lua`, `title_setup_compat.lua`, and `trainer_rewards.lua`.

---

# 2.0.0-beta.30.0.0.15

- **Approved first Lua module split.** Added `title_setup_compat.lua`; no existing file was removed.
- Moved only the 0.1.86 fresh-game title SETUP compatibility fallback out of `main.lua`.
- Uses Gen1Recomp 0.1.86's documented sandbox-safe multi-file pattern: source is read with `mod:read(...)`, compiled with sandboxed `load(...)`, and therefore inherits the mod's sandbox environment.
- Fixes 30.0.0.14's `ambiguous syntax` parser failure by removing the IIFE entirely rather than applying another parser workaround.
- Rationale: 30.0.0.13 hit the large main chunk's parser/local pressure; 30.0.0.14 then introduced an ambiguous statement boundary. Isolating this self-contained compatibility adapter lowers main-chunk pressure and follows upstream's supported multi-file design.
- Expected impact is limited to title/startup SETUP injection. Core rules, saves, encounters, battles, tracker, randomizers, compatibility providers, and Gold gameplay are not intentionally changed.
- **Compatibility confidence is temporarily reduced until runtime tests confirm Blue and Gold startup, Setup selection, existing-save behavior, and representative gameplay.**
- Further Lua splitting requires new explicit user approval.

---

# 2.0.0-beta.30.0.0.14

- Fixed a load-blocking Lua parser failure introduced in 30.0.0.13.
- Root cause: the 0.1.86 title-menu compatibility fallback added enough locals to the already-large top-level `main.lua` chunk to exceed the runtime parser's local-variable ceiling.
- Moved the complete title fallback implementation into a nested immediately-invoked function so its helper locals belong to a separate Lua function prototype instead of the top-level chunk.
- No title-menu behavior was intentionally changed from 30.0.0.13.
- No gameplay rules, save schema, provider behavior, randomizer behavior, or documentation file set changed.
- Fresh Blue and Gold SETUP runtime test remains required after confirming the mod now loads.

---

# 2.0.0-beta.30.0.0.13

- Compatibility repair for runtime-confirmed missing Nuzlocke SETUP on genuinely fresh Blue and Gold boots under Gen1Recomp 0.1.86.
- Preserves `ui.title_menu.items` as the primary public title-menu integration.
- Adds conservative generation-specific title-list fallbacks that run after normal menu construction and insert SETUP only when there is no CONTINUE row and no existing SETUP row.
- R/B/Y fallback wraps `src.ui.TitleState:openMenu`; Gold fallback wraps `src.ui.gen2.MainMenu:buildList`.
- Fallbacks are idempotent and explicitly refuse duplicate SETUP insertion.
- Existing-save behavior remains unchanged: SETUP stays hidden when CONTINUE/a save is present.
- Narrowed the experimental 30.0.0.12 `<1.0.0` engine range to the actively investigated `>=0.1.86 <0.1.91` family.
- No gameplay-rule, save-schema, randomizer, tracker, or provider-policy behavior intentionally changed.
- Runtime retest required on fresh Blue and Gold saves.

---

# 2.0.0-beta.30.0.0.12

- Future-proofed the manifest engine range from `>=0.1.81 <0.1.85` to `>=0.1.81 <1.0.0`.
- Future Gen1Recomp 0.x patch/minor releases will no longer be rejected solely because their version number crossed our previous ceiling.
- Kept a deliberate `<1.0.0` major compatibility boundary: a future 1.0 may legitimately change contracts and should be reviewed rather than silently trusted.
- Remains Mod API 2 and save schema 4; no gameplay rules or save semantics changed.
- This does not claim unknown future engine releases are runtime-certified. It changes loader policy from exact-patch allowlisting to API-family compatibility.
- No files added or removed.

---

# 2.0.0-beta.30.0.0.11

- Compatibility-only child of 2.0.0-beta.30.0.0.10.
- Expanded the engine compatibility range from `>=0.1.81 <0.1.84` to `>=0.1.81 <0.1.85`, allowing Gen1Recomp 0.1.84 to load the mod.
- Gen1Recomp 0.1.84 still documents Mod API 2 as the current standard, so no API-level migration was made.
- No gameplay rules, save schema, compatibility providers, randomizers, tracker logic, UI behavior, or protected fixes were intentionally changed.
- This build is a minimal boot-compatibility checkpoint so broader 30.0.0.10 work remains preserved for subsequent children.
- Runtime validation on 0.1.84 is required.

---

# 2.0.0-beta.30.0.0.10

### Fixed / hardened
- Made external-provider delegation effective at runtime for the delegated boolean mechanics, not UI-only.
- Preset application may update dormant delegated preferences without re-enabling Nuzlocke's duplicate runtime mechanic.
- EXP Edging now delegates with an external level-cap provider rather than remaining visibly ON but ineffective.
- Fixed the public `nuzlocke.delegation` export declaration-order bug with late-bound accessors.
- Routed the public item-policy API through `evaluateItemUsePolicy`, fixing master-switch behavior, Rare Candy key drift, and missing native item restrictions.
- Corrected Acquisition Type Locke integration and reused special gift/trade legality for external acquisitions.
- Changed AutoCompat Pokemon snapshots to authoritative `game.save.party` and `game.save.boxes`.
- Automatic legacy providers are cleared/rebuilt on scans so disabled/removed mods cannot remain stale owners.
- Generic `RANDOMIZER` name detection no longer claims starter/encounter/learnset controls; exclusive delegation requires granular capabilities.
- Gold PackMenu now presents `no_fishing` denial instead of falling through its reason whitelist.
- Legacy recovery no longer adds a second EDITED row for a Pokemon already attached to a saved legacy row.

### Still runtime-test required
- R/B/Y Skip Catch Demo remains unproven; Gold has the explicit `World.startCatchTutorial` seam.
- Randomizer restoration must be tested with providers that mutate encounter/learnset registries after Nuzlocke snapshots them.
- Passive external acquisition reconciliation is now pointed at the correct save shape, but provider-specific acquisition timing still needs runtime proof.

---

# 2.0.0-beta.30.0.0.9

- Added provider-owned non-core feature delegation in the Nuzlocke Setup/Rules UI.
- When an active provider explicitly owns a duplicate non-core mechanic, Nuzlocke shows its duplicate control as effective OFF, greys the row, and prevents toggling.
- Delegated rows remain selectable so the description panel identifies the handling mod/provider and version.
- Stored Nuzlocke preferences are preserved dormant and automatically become effective again if the external provider is disabled/removed.
- Core Nuzlocke challenge policy is never implicitly delegated: death, One Per Area, Dupes, catch legality, Type Locke, item bans, lock-ins, legendary/mythical/pseudo bans, etc. remain Nuzlocke-owned.
- Initial delegated duplicate mechanics include level caps, starter/encounter/learnset randomizers, running shoes, default naming/tutorial-skip QoL, trainer-money provider, and starting-resource provider capabilities.
- Explicit providers take precedence; legacy/automatic adapters remain fallback-only.
- Added automatic recognition hints for Randomizer, Level Cap, and Running Shoes behavior families.
- Preserved all 30.0.0.8 compatibility consolidation and the Yellow tracker crash repair.

---

# 2.0.0-beta.30.0.0.8

- Consolidated the 30.0.0.3–30.0.0.7 compatibility architecture without adding a new gameplay feature.
- Added canonical provider capability families: `item_provider`, `storage_provider`, `encounter_provider`, `exp_provider`, `registry_consumer`, and `quest_content_provider`.
- Existing legacy capability names remain additive aliases; no provider integration was intentionally broken.
- Added `interop.resolveCapability()` with explicit-provider precedence over automatic legacy adapters.
- Documented provider-owned mechanics vs Nuzlocke-owned challenge policy/provenance.
- Preserved the Yellow Encounter Tracker REMOVE ENTRY serialization repair.
- Preserved FAFF0x QoL, content-provider, randomizer opt-out, and automatic-adapter work.
- No repository files added or removed.
- Compatibility changes remain TEST REQUIRED until the planned runtime certification pass.

---

# 2.0.0-beta.30.0.0.7

- Added the FAFF0x automatic/legacy compatibility adapter layer.
- Scans the active mod graph after `mods.loaded` and describes common behavior families (alternate Bag/item UI, automatic item use, PC UI, external encounter starters, registry consumers, EXP distributors, quest providers, reusable machines) without using those names as enforcement branches.
- Explicit provider registration still wins; automatic adapters only fill gaps for released mods that predate the Nuzlocke API.
- Added passive Pokémon acquisition reconciliation after game/save readiness so externally granted Pokémon can be surfaced as scripted/provider acquisitions instead of being silently treated as vanilla catches.
- Added convenience adapter gates for external item use, encounter starts, PC actions, and effective-registry snapshots.
- Automatic acquisition reconciliation is observational and never deletes externally granted Pokémon.
- Preserved 30.0.0.5 Yellow tracker crash repair and 30.0.0.6 quest/content provider APIs.
- Runtime certification remains deferred.

---

# 2.0.0-beta.30.0.0.6

- Added the FAFF0x quest/content provider layer to Interop API v1.
- Added dynamic area registration that feeds the existing Encounter Tracker catalogue.
- Added provider-declared dungeon families so Gym/Dungeon Lock-In can recognize mod-added dungeons without hardcoded quest names.
- Added custom boss metadata registration for future difficulty/cap consumers.
- Added quest gift and scripted/repeatable encounter source registration.
- Acquisition policy can now fill missing kind/species/area metadata from registered content sources.
- Added randomizer opt-out policies for story-critical encounters and species learnsets.
- Random Encounter Tables honors encounter-record/provider `randomizable=false` policies.
- Random Learnsets honors provider/species preservation policies.
- Added `content.registerBundle()` so quest packs can register areas, dungeons, bosses, gifts, encounters, and randomizer policies in one call.
- Preserved the 30.0.0.5 Yellow Encounter Tracker serialization repair unchanged.
- Runtime certification remains deferred / TEST REQUIRED.

---

# 2.0.0-beta.30.0.0.5

- Fixed a fatal Encounter Tracker recovery/removal path reported on an existing Yellow save originating from beta.29.3.16.
- Root cause: the legacy-recovery UI could attach a live Pokémon object directly to a persisted `tracker_log.__LEGACY__` entry, then serialize that contaminated tracker table during REMOVE ENTRY.
- Legacy recovery rows are now detached UI views; live Pokémon references never mutate persisted tracker records.
- Added a narrow migration sanitizer that removes only known transient UI fields (`mon`, `logEntry`, `savedEntry`) from legacy tracker records before tracker serialization.
- Manual recovery now maps detached UI rows back to their original saved record explicitly.
- No catch history, provenance, encounter-rule semantics, or unrelated tracker behavior was rewritten.
- Runtime status: FIX IMPLEMENTED / RETEST REQUIRED, especially Yellow existing-save REMOVE ENTRY.

---

# 2.0.0-beta.30.0.0.4

- Expanded Interop API v1 for the FAFF0x QoL compatibility pass.
- Added `itemPolicy.beforeUse/canUse/check/checkUse` for Modern Bag, Item Shortcut, Repel Reuse, favorites and other alternate item-use paths.
- Added `acquisitionPolicy.begin/commit` and explicit acquisition kinds for DexNav, Summon and scripted providers.
- Added `encounterPolicy.evaluate` convenience entry for external encounter starters.
- Added `pcPolicy.evaluate/can` for alternate PC/box UIs; dead Pokémon remain unusable without trapping ordinary PC navigation.
- Added registry revision counters and `registry.describe()` for Pokédex Plus/Moves Manager-style consumers.
- Added EXP cap discovery helper while preserving provider-owned distribution.
- Bridged selected new APIs through legacy `nuzlocke_compat` exports.
- No hardcoded FAFF0x IDs added. All runtime certification remains deferred.

---

# 2.0.0-beta.30.0.0.3

- Added public `mod.exports.nuzlocke` interoperability API v1.
- Added capability/provider registration instead of hardcoded mod-name compatibility.
- Added acquisition classification/evaluation for wild, gift, trade, starter, scripted, editor, summon, quest, forced, and Wonder Trade sources.
- Added public item-policy evaluation for alternate Bag/shortcut/automatic-use UIs.
- Added effective Pokémon/encounter/move/learnset registry access plus registry-change notifications.
- Added a post-distribution EXP ownership seam so EXP providers can own distribution while Nuzlocke retains cap enforcement.
- Random Encounter/Learnset transforms now notify registry consumers.
- FAFF0x collection is now an explicit first-class compatibility target, implemented through capabilities rather than FAFF0x IDs.
- All new interop paths are TEST REQUIRED.

---

# 2.0.0-beta.30.0.0.2

- Added **No Fishing** under Field Items; blocks rod use before fishing begins while leaving rod ownership and non-fishing encounters untouched. Includes tiered Kanto/Johto world-building. Gold is TEST REQUIRED.

---

# 2.0.0-beta.30.0.0.1

- Added Random Encounters with persistent per-slot species rolls.
- Added Random Learnsets with persistent per-species/per-slot move rolls.
- Added Learnset Gen: AUTO / GEN1 / GEN2.
- Preserves encounter levels/structure and learnset levels/size.
- Reversible runtime-registry transforms reapply after load/provider lifecycle events.
- No repository files added or removed.
- New paths are TEST REQUIRED.

---

# 2.0.0-beta.29.3.16 — Nuz Info / Compatibility API 27

- Direct child of `2.0.0-beta.29.3.15`.
- Replaced the single-purpose party Catch Info row with composable NUZ INFO.
- Added independently toggleable Catch, Stat, and Move pages for R/B/Y and Gold.
- Stat page shows current stats, DVs, and raw Stat EXP; Gold models shared Special DV/Stat EXP correctly.
- Move page resolves type, power, accuracy, and current/max PP from the active merged move registry.
- A/Right cycles forward, Left cycles backward, and B returns to the party submenu.
- Nuz Info presentation toggles remain outside Permanent Rule Seal.
- Bumped Nuzlocke Compatibility API 26 → 27 with read-only Nuz Info helpers.
- Save schema remains 4; Mod API remains 2.
- Changed UI/API paths remain TEST REQUIRED.

---

# 2.0.0-beta.29.3.15 — Rule UI / Dialogue / Gold QoL

- Direct child of `2.0.0-beta.29.3.14`.
- Added a LEVELS section for Game Difficulty, Level Cap Scope, and EXP Edging.
- Kept BATTLE ITEMS limited to actual battle-item-use rules; moved No Catching to Core and No Escape to General.
- Clarified Player/Wild/Trainer Stat EXP defaults and the 0/25/50/75/100/200 challenge preset scale.
- Exposed Gold-only Skip Cherrygrove Tour QoL while preserving the native MAP CARD reward/cleanup tail.
- Expanded Rare Candy, TM, and field-healing rejection dialogue with item/move-aware World Building text.
- No Catching remains the only selectable capture-ban rule; the retired Ball tier remains migration-only.
- Compatibility API remains 26; save schema remains 4.
- Changed paths remain TEST REQUIRED.

---

# 2.0.0-beta.29.3.14 — Gold Runtime Repair

- Direct child of `2.0.0-beta.29.3.13`.
- Fixed Gold START-menu compact-label selection using the hook-supplied game.
- Rebuilt Gold No Buying / No Selling around native Mart entry and transaction seams.
- Split Random Starter preview from committed starter identity; Gold Elm portrait/cry now matches each ball's persisted randomized preview.
- Hardened Gold starter New Bark Town provenance and added conservative reconciliation for the narrow older UNKNOWN case.
- Clarified Gold Stat EXP descriptions while keeping native 0% defaults.
- Repository tree, save schema 4, Compatibility API 26, Mod API 2, and engine range are unchanged.
- Changed paths remain TEST REQUIRED until runtime retest.

---

# 2.0.0-beta.29.3.13 — migration / master-switch / compatibility hardening

- Rolled directly from `2.0.0-beta.29.3.12`; exact 11-file repository tree preserved.
- Fixed the legacy `ball_use_ban_tier` → `no_catching` migration. Partial historical Ball restrictions no longer become an absolute capture ban; an absent new key defaults OFF and explicit `no_catching` state is preserved. Already-migrated ambiguous saves are flagged for review instead of being destructively guessed back OFF.
- Fixed Trainer Money so both wallet snapshot and payout scaling obey the Nuzlocke master switch.
- Fixed a Trainer Money callback-scope defect by declaring its transient weak-table state before the `battle.started` callback that records into it.
- Added generation-neutral Trainer Money wallet access: R/B/Y use `save.money`; Gold uses `save.player.money`. Optional provider wallet-cap aliases are honored in deterministic precedence order, and an already-larger provider wallet is not truncated to the native cap when no cap is published.
- Made Game Difficulty identity stable: `difficulty_provider_id` is authoritative, setup profiles preserve it, old index-only saves bootstrap it once, and unavailable external providers temporarily fall back to VANILLA without erasing the requested ID.
- Fixed Route Forgiveness so rewards, token shop presentation, and failure-spend flow are disabled with the Nuzlocke master switch.
- Hardened Dungeon Lock-In to remember the exact exterior entrance warp. Different exits that land on the same exterior map are allowed; legacy coordinate-less state fails open.
- Corrected version-aware Game Corner deterministic source data for Scyther, Dratini, and Pinsir in both live lookup and legacy recovery.
- Replaced the stale Gen-I NPC-trade fallback table with the authoritative English Red/Blue and Yellow trade rosters/locations, removed impossible historical trade assumptions from legacy recovery, prevented ambiguous prize/trade/evolution-capable species from being auto-resolved as wild on a single table hit, and prevented Gold from inheriting Gen-I gift/trade source tables.
- Hardened source-less `pokemon.received` inference: a reported live location must match the version-valid vanilla source; when location is unavailable, only genuinely provenance-deterministic species may be inferred.
- Added a Gold native NPC-trade pre-transaction gate around `TradeMenu.chose` plus post-success tracking around `NpcTrade.perform`; blocked trades do not set the one-shot flag or remove the offered Pokemon. Gold now exposes Gift Pokemon and In-Game Trades on its beta rule surface.
- Hardened Random Mono/Duo type rolls to use types actually represented by the live merged species/provider pool when possible, avoiding empty vanilla Dark/Steel rolls.
- Made Gym/Dungeon Lock-In compose against the final downstream `warp.destination` result and clear stale dungeon state when the master or dungeon rule is disabled.
- Consolidated the first Level Cap + EXP Edging notification into one World Building message instead of two near-duplicate boxes in the same EXP transaction.
- Audited new-rule defaults: restrictive/challenge additions remain OFF by default, Trainer Money remains 100%, and Game Difficulty remains VANILLA.
- Improved rule descriptions for master-switch boundaries, Failed Encounters, Dupes, Shiny Clause, Type Locke, No Day Care, Trainer Money, Game Difficulty, No Catching, gifts/trades, and Gym/Dungeon Lock-In.
- Bumped Nuzlocke Compatibility API **25 → 26** with stable difficulty state, activity/rule queries, migration warnings, Type Locke/Forgiveness/Dungeon helpers, conservative acquisition classification, version-aware gift/trade location plus deterministic-source helpers, and expanded Pokémon-field ownership declarations.
- Save schema remains 4; Gen1Recomp Mod API remains 2; engine range remains `>=0.1.81 <0.1.84`.
- Targeted static/semantic smoke passes; normal standalone Lua `loadfile` still reaches the inherited >200-local outer-function limit, so no standard-Lua compile PASS is claimed. Changed gameplay/UI paths remain **TEST REQUIRED** in Gen1Recomp.

---

# 2.0.0-beta.29.3.12 — Type Locke / encounter accounting stabilization

- Rolled directly from `2.0.0-beta.29.3.11`; repository tree unchanged.
- Added RANDOM Type 1/Type 2 selection for Monolocke/Duolocke. Rolls resolve once and persist concrete types; Duo rolls are always distinct.
- Polished Type Locke labels/status presentation and RANDOM descriptions.
- Hardened Dupes Clause with a battle-scoped free-encounter decision so duplicates cannot reach Failed Encounter consumption or Route Forgiveness spending.
- Canonicalized exact `DIGLETT_CAVE` / `DIGLETTS_CAVE` / CamelCase spellings to one physical `DIGLETT_CAVE` encounter area across R/B/Y, Gold, and providers.
- Added deterministic starting-resource regression audit cases for vanilla/default ¥3000, intentional ¥0, clamping, malformed values, Balls, and Rare Candies.
- Polished Forgiveness Token shop metadata/status balance presentation.
- Polished No Day Care T3 rejection copy while retaining safe withdrawal of existing occupants.
- Compatibility API 25, save schema 4, Mod API 2, engine range `>=0.1.81 <0.1.84`.
- New behavior remains TEST REQUIRED pending in-engine runtime validation.

---

# 2.0.0-beta.29.3.11 — Pokemon Bois Club world-building pass

- Rolled directly from `2.0.0-beta.29.3.10`; repository files remain the same set.
- Added a **Tier 3 World Building** cosmetic rebrand for Vermilion's **Pokemon Fan Club**, presenting it as the **Pokemon Bois Club** when World Building is set to T3.
- Added safe T3-only dialogue/sign rewording for the club in R/B/Y and Gold without changing item rewards, story flags, yes/no branches, or Bike Voucher / Rare Candy transactions.
- Added a custom **Bryan-the-Boi tribute chairman sprite** for the T3 presentation path while preserving vanilla presentation at lower World Building tiers.
- This pass is cosmetic only; no rules, encounter legality, save schema, or compatibility API behavior changed.
- New Pokemon Bois Club presentation paths are **TEST REQUIRED** until runtime validated.

---

# 2.0.0-beta.29.3.10 — Type Locke + No Day Care

- Rolled directly from `2.0.0-beta.29.3.9`; repository tree unchanged.
- Added **Type Locke** as a shared `OFF / MONO / DUO` framework for Monolocke and Duolocke runs.
- Added separate **Type 1** and **Type 2** selectors using a stable 17-type Gen 1+2 index.
- Type legality reads live merged species data first and optional species-metadata provider data second; unreadable custom schemas fail open.
- Off-type wild encounters are rejected without consuming an encounter area or Route Forgiveness Token.
- Shiny Clause does not bypass Type Locke.
- Native gift/trade acquisition gates now include Type Locke legality where a pre-transaction seam exists.
- Random Starter filters candidates through the selected Type Locke when possible while preserving the mandatory starter progression-safe fallback.
- Added **No Day Care**. R/B/Y blocks new deposits at the hand-ported Day Care interaction; Gold blocks new deposits at `Breeding.canDeposit`.
- Existing Day Care occupants remain retrievable; Gold existing parent/Egg state is preserved.
- Added complete T1/T2/Kanto-T3/Johto-T3 World Building entries for Type Locke selectors and No Day Care.
- Corrected Permanent Rule Seal boundaries: challenge rules remain sealed; Game Difficulty, World Building, QoL, and presentation controls remain adjustable.
- Compatibility API remains 25, save schema remains 4, Mod API remains 2, and engine range remains `>=0.1.81 <0.1.84`.
- New Type Locke and No Day Care paths are **TEST REQUIRED** until runtime validated.

---

# 2.0.0-beta.29.3.9 — Gold-native custom UI integration

- Rolled directly from `2.0.0-beta.29.3.8`; repository tree unchanged.
- Replaced R/B/Y-style pixel-positioned rendering on Nuzlocke-owned Gold screens with Gen1Recomp's native Gen 2 `src.ui.gen2.Chrome` vocabulary.
- Gold Setup / **NUZ RULES** now use a 20x18 tile-grid layout, native cursor/down-arrow glyphs, Gold money formatting, scrolling rule rows, collapsible section presentation, and a native description panel while retaining the shared configuration/update model.
- Gold **ENC TRACKER** now renders LOG/MAP data through native Gold boxes/text while retaining the same canonical encounter state and cap source.
- Gold **CATCH INFO** now uses native Gold presentation without changing ownership/provenance semantics.
- Gold Route Forgiveness confirmation now uses native Gold boxes, cursor, wrapped text, and live token count while preserving the existing spend transaction.
- Gold **NUZ STATUS** continues to use its dedicated Start-menu surface; Nuzlocke does not replace the native Trainer Card lifecycle.
- Follows upstream Gen1Recomp guidance that `src.ui.OptionRows` is not a Gen 2 facade and must not be used to paint Gen 1 option chrome over Gold.
- R/B/Y presentation and protected gameplay enforcement are unchanged.
- New Gold-native presentation is **TEST REQUIRED** until runtime validated.
- Compatibility API remains 25, save schema remains 4, Mod API remains 2, and engine range remains `>=0.1.81 <0.1.84`.

---

# 2.0.0-beta.29.3.8 — World Building parity + cleanup

- Rolled directly from `2.0.0-beta.29.3.7`; repository tree unchanged.
- Expanded World Building OFF/T1/T2/T3 presentation to Gold/Johto with region-aware Tier 3 text instead of forcing the Gold backend to Tier 0.
- Added one shared rule-feedback catalogue with complete T1/T2/Kanto-T3/Johto-T3 coverage for every implemented selectable rule (Wonderlocke remains intentionally WIP), while only presenting text at safe player-facing seams. R/B/Y and Gold can now reuse tiered catch, item, shop, healing, gambling, lock-in, encounter, forgiveness, Shiny Clause, EXP Edging, trainer-money, Rival Mercy, Permadeath, and Whiteout presentation without duplicating legality logic.
- Added Johto Gym-Leader flavor beats at Tier 3 while keeping native battle introductions first.
- Consolidated R/B/Y and Gold catch-denial text onto one presenter.
- Removed retired live Ball-ban tier/rank code; the legacy `ball_use_ban_tier` key remains read only for migration into No Catching.
- Removed the unreachable legacy `no_items` battle branch, which had no selectable rule key.
- Restored IRON / IronMON as a first-class Nuzlocke Loadout and widened the loadout state/UI range from four choices to five. The preset is IronMON-style and only configures rules Nuzlocke itself owns.
- Updated stale internal build metadata and player documentation.
- Existing runtime-PASS behavior remains protected; new Gold flavor and IronMON preset behavior are TEST REQUIRED.

---

# 2.0.0-beta.29.3.7 — split Nuzlocke loadout / game difficulty

- Separates **Nuzlocke Loadout** from **Game Difficulty**. Difficulty selection no longer changes Permadeath, encounter, healing, or other Nuzlocke rules.
- Game Difficulty defaults to **VANILLA** and is changeable mid-game until the Permanent Rule Seal is applied.
- Adds **NUZ MEDIUM**, the mod's own moderate trainer profile.
- Adds two documented ROM-hack-inspired choices per supported game. A `*` suffix means an inspired compatibility profile, not a byte-identical reproduction of the source hack.
- Active compatible trainer/difficulty providers are appended as `[MOD]` choices and remain authoritative for their own composed trainer parties.
- Built-in difficulty profiles operate on future composed trainer parties and preserve explicit moves supplied by another trainer/content provider rather than overwriting them.
- Renames the irreversible configuration control to **Permanent Rule Seal** in the player-facing UI while retaining the existing save representation.
- All new difficulty behavior is **TEST REQUIRED**.

### Historical subrecord — 2.0.0-beta.29.3.7

- Added optional EXP Edging: cap-blocked EXP is banked per Pokemon and released through the normal EXP path when a later authoritative cap allows it.
- Added Difficulty selector groundwork: VANILLA / NUZ / HARD / EXT, with capability-first discovery of active external difficulty/cap providers. External providers are never enabled, disabled, or guessed solely by mod name.
- Gold exposes both systems through its separate backend; all new behavior is TEST REQUIRED.


### Reconciled historical record: 2.0.0-beta.29.3.7 — Gold compatibility smoke pass


- Rolled directly from 2.0.0-beta.29.3.4; no repository files added or removed.
- Static smoke audit rechecked Gold-specific capture, nickname, Mart, field-item, catch-tutorial, gift, static, gambling, Whiteout, egg, roamer, and Nuz Status adapters.
- Gold adapters remain generation-scoped and fail-open when an upstream seam is unavailable.
- Route Forgiveness and No Catching remain TEST REQUIRED on Gold pending runtime validation.
- Existing R/B/Y runtime-PASS behavior was not intentionally changed.

---

# 2.0.0-beta.29.3.3

- Rebased sequentially from the recovered 29.3.1 package while reconstructing the 29.3.2 compatibility intent; no repository files added or removed.
- Added Route Forgiveness setup states: OFF, enabled with 0 starting tokens, or enabled with 1 starting token. Non-Leader Gym Trainers award one token once per trainer. Eligible failed encounters consume a token before an area is marked failed; Dupes never consume the area or a token.
- Added Trainer Money scaling: 0/25/50/75/100/150/200/300/500%, applied to the final composed trainer payout. Default is vanilla 100%.
- Made Rule Lock permanent/monotonic per save with a second-confirmation step. Locked rules remain viewable; runtime state continues to update.
- Reworked startup defaults: NUZLOCKE is now the default mode, FAMILY Dupes and Shiny Clause are enabled by default, and Nickname Rule remains part of the conventional core. Hardcore keeps Champion caps, battle healing/X-item restrictions, First Rival Mercy OFF and Whiteout loss, but Gym/Dungeon Lock-Ins remain optional rather than being silently bundled into Hardcore.
- Published the Forgiveness Token aspirational shop price as 1,000,000 (one above the native 999,999 wallet ceiling) for shop/UI integrations. Native cross-generation Mart stock injection remains TEST REQUIRED and is not claimed as runtime PASS.
- New behavior in this build is TEST REQUIRED; existing runtime-confirmed PASS behavior remains protected.

### Historical subrecord — 2.0.0-beta.29.3.3

Development repair build based directly on `2.0.0-beta.29.3.0`.

### Fixes

- Corrected Gold midgame cap-ladder presentation to Chuck → Jasmine → Pryce; the existing monotonic cap floor prevents the displayed/enforced cap from dropping from Jasmine's 35 to Pryce's 31.
- Corrected Gold positional badge fallbacks: Storm/Chuck is slot 5 and Mineral/Jasmine is slot 6.
- Fixed Legacy Recovery encounter-limit policy to read the canonical flat `nuzlocke_enabled` and `encounter_limit` save keys instead of a nonexistent nested `rules` table.
- Corrected Celadon Eevee gift provenance for Yellow as well as Red/Blue and removed fictitious Yellow Jolteon/Vaporeon/Flareon gift aliases.
- Version-gated Legacy Recovery's version-specific trades so impossible R/B or Yellow trade provenance is not fabricated as DETERMINED. This includes R/B Lickitung, Electrode, and Kangaskhan and Yellow Machoke.
- Unified Solo Only wild and gift acquisition checks behind one active-party occupancy helper. A fainted but living Pokemon still occupies the Solo Only slot when Permadeath is off, matching the documented active-party rule; PC swaps remain intentionally allowed.

### Validation

- Expanded the static release gate with regression checks for all six reviewed areas.
- Static release gate: **95/95 PASS**.
- Runtime testing is still required, especially for Gold cap progression and Legacy Recovery migrations.

---

# 2.0.0-beta.29.3.0

Full beta release roll-up from the development line after `2.0.0-beta.29.1.0`.

### Runtime-confirmed improvements

- Yellow level-cap displays now follow Stronger Trainers' composed boss rosters in the Trainer Card and Encounter Log instead of showing vanilla caps.
- Yellow First Rival Mercy was runtime-confirmed working.
- Blue/Yellow new-game Default Names, Starting Money, Starting Rare Candies, Soft Start, No Mom Heal, No Center Heal, Random Starter grants, starter provenance, and Forced Nicknames retained their runtime-confirmed behavior where tested.
- Yellow in-game Nuz Rules section expand/collapse glyphs work with the intended native right/down arrows.
- Running Shoes appears under Quality of Life.
- Nuz Status on the back of the Trainer Card remains functional in Blue/Yellow.

### Rules and challenge organization

- Added Gym Lock-In and Dungeon Lock-In, including conservative fail-open handling for older saves and escape-method enforcement intended to avoid softlocks.
- Moved Gym Lock-In and Dungeon Lock-In into the Ironmon/Hardcore challenge section.
- Replaced blanket numbered-route splitting with independent Route 2, Route 10, and Route 20 split rules.
- Route-split descriptions now explain the geography/progression reason those three routes are commonly treated as separate encounter areas.
- Existing Mt. Moon and Safari split behavior remains available.
- Legacy blanket Route Splits saves migrate conservatively without granting free encounters.

### Setup and quality-of-life

- Renamed B-button running to Running Shoes and placed it under Quality of Life.
- Maximum BST setup editing now follows the same numeric-editing model used by Starting Money/Poké Balls/Rare Candies.
- Setup/profile numeric boundaries reject non-finite corrupted values instead of persisting invalid numeric state.
- Setup and in-game Rules collapsible sections use native right/down directional glyphs.
- Front Trainer Card `A:NUZ` placement was lowered for better alignment.

### Random Starter and opening sequence

- Random Starter acquisition continues to use one persisted roll so the actual awarded Pokémon and tracker provenance stay aligned.
- R/B starter presentation was hardened so confirmation text uses the same persisted randomized species while the selected vanilla ball still controls the native story/rival-choice branch.
- Yellow non-Pikachu randomized starters no longer receive Pikachu-only post-lab presentation handling.
- Early-lab Rival text was trimmed to avoid repeating the same "toughen it up" idea immediately after battle.
- Repeated opening-sequence dialogue remains a targeted runtime regression area; no broad text-suppression hack was introduced.

### Encounter tracking and provenance

- Gold starter/gift tracking was hardened for numeric species identifiers.
- Gold starter events canonicalize through the New Bark Town starter path so randomized starters can immediately consume the correct encounter slot and report New Bark Town rather than Unknown.
- Split-area reprojection is deterministic when child areas are merged.
- Legacy encounter-history migration preserves consumed encounter state and tracker rows.
- Persistent Pokémon identity remains slot-independent across party/PC movement.

### Permadeath and battle lifecycle

- Added a second post-finish Permadeath reconciliation so scripted trainer/Gym callbacks cannot restore a Pokémon that Nuzlocke already marked dead.
- Cooperative post-battle healing can restore surviving Pokémon while Nuzlocke-dead Pokémon remain at 0 HP.
- Tournament/CANLOSE battle flows remain composable with Nuzlocke rule ownership.

### Compatibility

- Added and hardened composed `trainer.party` observation for trainer-modifying content.
- Fixed the hook-priority ordering bug that previously caused Nuzlocke to observe vanilla trainer parties before downstream trainer transformations.
- Added pre-battle composed-party preview so next-cap UI can display modified boss ace levels before the battle begins.
- Gold live trainer inspection now prefers the canonical Gen 2 trainer registry shape.
- Added a compatibility pass for Indigo Plateau Conference v1.0.2 while preserving tournament ownership of its own NPCs, flow, and survivor healing.
- Compatibility API remains 25; Save Schema remains 4; Gen1Recomp Mod API remains 2.
- Audited engine target remains Gen1Recomp 0.1.83 with manifest support `>=0.1.81 <0.1.84`.

### Known runtime follow-ups

- R/B Random Starter still needs a final runtime pass confirming every starter preview sprite/confirmation surface matches the randomized award.
- Gold in-game menu layout, native status glyphs, randomized-starter display/provenance, and caught-count refresh need full runtime confirmation on the release build.
- Opening Oak/Rival/Mart dialogue duplication remains under focused investigation.
- Gym/Dungeon Lock-In still needs broader cross-game runtime coverage.
- Gold support remains beta.

---

# 2.0.0-beta.29.2.7

- R/B Random Starter selection confirmation now names the persisted randomized species, with the existing Dex preview and actual grant bound to the same roll.
- Added protected pre-battle trainer-party preview for known runtime trainer-balance composition so Trainer Card and Encounter Log can show the actual next boss ace before the fight starts.
- Gym Lock-In and Dungeon Lock-In moved from World to the Ironmon/Hardcore challenge section; rule behavior is unchanged.
- Cleaned up the optional early Oak-lab Rival line to avoid repeating the later post-battle "toughen it up" idea.
- Preserves Yellow in-game section glyphs and Running Shoes/QoL placement confirmed by runtime testing.

---

# 2.0.0-beta.29.2.6

- Audited compatibility with Indigo Plateau Conference v1.0.2 (Gold).
- Trainer-party observation now runs outside normal priority-0 content wrappers, so Nuzlocke records the final composed tournament party rather than observing vanilla before a downstream replacement.
- Gold trainer-data inspection now understands the canonical `game.data.gen2Trainers.classes` shape while retaining the existing R/B/Y trainer registry path.
- Added a narrow Indigo Conference adapter declaration: its Colosseum NPC/state/CANLOSE flow remains tournament-owned; Nuzlocke retains death, rules, tracker, and Whiteout ownership.
- Scripted post-battle healing is allowed for surviving Pokemon, while already Nuzlocke-dead party members are reasserted at 0 HP after battle/map reconciliation.
- No IPC map, NPC, trainer, event-flag, tournament-state, or save keys are patched or overwritten.

---

# 2.0.0-beta.29.2.5 — focused common-route split rules

- Gold START-menu labels for Nuz Status, Encounter Tracker, and Nuz Rules now use compact native-width labels so they do not draw through the menu border.
- Gold Nuz Status now uses the native Gen 2 down-arrow glyph for additional rule rows.
- Hardened Gold randomized-starter registration so numeric species IDs are resolved before tracker/history writes and explicit starter events canonicalize to New Bark Town.
- Gold starter provenance now refreshes the tracker/Catch Info path immediately when the starter is received.

- Built directly from beta.29.2.3.
- Retires the player-facing blanket Route 1–25 CARDINAL rule.
- Adds independent **Route 2 Split**, **Route 10 Split**, and **Route 20 Split** ON/OFF rules for R/B/Y, with descriptions explaining the progression/geography reason each route is commonly split.
- Route 2 uses North/South around Viridian Forest, Route 10 uses North/South around Rock Tunnel, and Route 20 uses West/East around Seafoam Islands.
- Existing saves with the retired blanket Route Splits rule enabled carry that intent forward to all three new route toggles. Legacy split rows on every other route collapse deterministically to their parent route while preserving every tracker row and consumed encounter state, so migration cannot create free encounters.
- The compatibility API retains the legacy `routes` field as `0` and adds independent `route_2`, `route_10`, and `route_20` mode fields without changing Nuzlocke Compatibility API 25 or save schema 4.
- Mt. Moon and Safari split behavior is unchanged.
- Runtime migration and ON/OFF reprojection tests are required before public release.

---

# 2.0.0-beta.29.2.3 — finite-number and review hardening

- Built directly from beta.29.2.2.
- Sanitizes non-finite numeric Setup/profile inputs (`NaN`, positive infinity, negative infinity) at rule normalization and profile-copy boundaries, falling back to established defaults before clamping/persistence.
- Adds a serializer defense-in-depth guard so a non-finite number cannot be emitted as a persisted Setup-profile literal even if it bypasses earlier normalization.
- Leaves normal gameplay arithmetic unchanged; this is corrupted/external-input hardening rather than a change to EXP, level caps, Stat EXP, or battle math.
- Preserves beta.29.2.2 Gym/Dungeon Lock-In, trainer-cap compatibility hardening, and all beta.29.2.1 determinism/Permadeath fixes.
- Expands repository-only review rationale and regression obligations for investigated technical edge cases that did not justify production changes.

---

# 2.0.0-beta.29.2.2 — lock-in and trainer-cap compatibility hardening

### Goal

Build directly from beta.29.2.1 and add the missing Gym/Dungeon Lock-In rule family while improving live trainer-roster cap discovery without disturbing the beta.29.2.1 Permadeath and deterministic encounter-projection fixes.

### Added

- **Gym Lock-In** is now a selectable Setup/NUZ RULES option. Supported Gym exits are blocked until the corresponding Gym Leader is defeated; already-cleared Gyms fail open. R/B/Y and Gold Gym map aliases are normalized before lookup.
- **Dungeon Lock-In** is now a selectable Setup/NUZ RULES option for a conservative set of known multi-exit dungeon families. The entrance used to enter is sealed, while reaching a different legitimate exterior exit releases the lock.
- Escape Rope use is blocked while an active Dungeon Lock-In is in force, even when the separate No Escape Rope rule is OFF. Dig, Teleport, and Fly are also denied through the shared field-move eligibility seam if they would otherwise be usable from the locked dungeon.
- Lock-In rejection text has plain/Tier 1, Tier 2, and Tier 3 presentation. Turning optional World Building OFF still leaves a plain enforcement explanation instead of silent rejection.

### Compatibility hardening

- Live trainer ace-level discovery now walks a bounded, cycle-safe set of common nested party containers (`party`, `team`, `pokemon`, `mons`, `roster`, `members`) instead of requiring an immediate vanilla party array. This is intended to make level caps follow trainer-content modifications that preserve semantic Pokémon rows but wrap the roster differently.
- Level Cap Scope **POST** remains the supported opt-in for provider-driven postgame caps; the older separate expanded/additional-content toggle is not restored.
- The current Gen1Recomp launcher updater downgrade behavior with multi-part beta tags remains a known install/update issue; manual installation of the newest release remains the safe path until version-resolution behavior is corrected.

### Safety / preservation

- Built directly from beta.29.2.1; no older branch was restored.
- Dungeon coverage is deliberately conservative and excludes dead-end/single-exit locations unless a safe completion seam exists, preventing the rule itself from manufacturing a softlock.
- A save loaded inside a dungeon without trustworthy entry-side state fails open rather than inventing a lock.
- Save schema remains 4; Nuzlocke Compatibility API remains 25; Gen1Recomp Mod API remains 2.
- Gym Leader Permadeath reconciliation, LOST-vs-DEATH semantics, native collapse glyphs, starting-money fallback, and unrelated rule paths remain inherited from the immediate parent.

### Runtime validation required

- R/B/Y: enter an uncleared Gym, verify ordinary exit rejection, defeat Leader, verify exit succeeds.
- Gold: repeat on at least one Johto Gym.
- Dungeon: enter a supported multi-exit dungeon, verify the entry exit is blocked, Escape Rope plus Dig/Teleport/Fly cannot bypass the lock, and a different legitimate exit releases the lock.
- Existing/older save loaded inside a dungeon must fail open rather than trap the player.
- Trainer-content compatibility: verify a modified Brock/early boss roster changes the displayed/enforced live cap instead of falling back to the vanilla value.

---

# 2.0.0-beta.29.2.1 — determinism and Gym-Leader Permadeath hardening

- Built directly from beta.29.2.0.
- Made split-area re-projection deterministic instead of allowing merged representative encounter state to depend on Lua table iteration order.
- Added a post-finish Permadeath reconciliation pass so special/Gym trainer teardown cannot restore a Pokémon already marked dead during battle.
- Structural release-gate coverage was expanded for both fixes; exact runtime validation remained required.

---

# 2.0.0-beta.29.2.0 — status semantics and native UI polish

### Goal

Turn the narrow beta.29.1.1 money checkpoint into a broader player-facing update while preserving the published beta.29.1.0 behavior baseline and every runtime-protected path.

### Changed

- Carries forward beta.29.1.1's R/B/Y fresh-start money correction: missing/unset Money defaults to **$3,000**, while an explicit **$0** remains valid.
- Collapsible SETUP/NUZ RULES category headers now use Gen1Recomp's theme-aware native directional glyphs instead of ASCII `+` / `-`. Collapsed uses the native sideways cursor glyph; expanded uses the native more/down glyph.
- New Pokémon-death history rows now use `status = "DEAD"` instead of overloading `"LOST"`.
- Existing saves are migrated conservatively: legacy `LOST` history rows are rewritten to `DEAD` only when they carry death evidence such as a death location/cause/opponent.
- Failed/fled/KO'd eligible encounters remain represented separately by `encounter_states[area].status = "FAILED"` and feed **LOST ENC.** counts.
- Run-over summaries now label the owned-Pokémon counter as **DEATHS** / **LAST DEATH** rather than LOST, while the underlying legacy `nuzlocke_losses` save key remains intact for save compatibility.
- Reconciled the cumulative version record against preserved source, packages, runtime evidence, and retained development records, enriching beta.19, beta.21, beta.27.3, beta.27.8, and beta.27.9 where the recovered attribution is strong enough to preserve without guessing.

### Compatibility / preservation

- Built directly from beta.29.1.1; no older branch was restored.
- Save schema remains 4 because the migration is backward-compatible and does not remove or rename persisted keys.
- Nuzlocke Compatibility API remains 25; no exported compatibility function signature changed.
- Gen1Recomp compatibility remains `>=0.1.81 <0.1.84`, with 0.1.83 exact-source audited.
- First Rival Mercy, acquisition provenance, Gold PC gifts, starter/gift nickname sync, temporary-party handling, item/shop/healing rules, and all unrelated gameplay paths are untouched.

### Validation

- Structural release gate expanded with assertions for the money fallback, explicit $0 preservation, native collapse glyphs, new `DEAD` history writes, legacy death-history migration, and LOST-encounter/DEATH separation.
- Exact in-game runtime regression remains required before publication.

### Known current runtime issue

- A runtime report shows Permadeath working in an ordinary fight but failing to leave a Pokémon unusable after it faints against a Gym Leader (reported against Misty); the Pokémon remained in the party and could be healed at a Pokémon Center. This is treated as a current release-blocking reconciliation bug until the Gym Leader/special-trainer post-battle path is reproduced and fixed.

---

# 2.0.0-beta.29.1.1 — fresh-start money default hotfix

### Goal

Fix the runtime-confirmed R/B/Y NEW GAME regression found in the published beta.29.1.0 player build without changing unrelated gameplay or compatibility behavior.

### Fixed

- The `save.new_game` starting-money fallback now matches the Setup default: a missing staged value produces **$3,000** instead of $0.
- An explicit player selection of **$0** remains valid; only a missing/unset value receives the $3,000 fallback.

### Preserved

- Built directly from published beta.29.1.0.
- Gen1Recomp compatibility remains `>=0.1.81 <0.1.84`, with 0.1.83 as the exact source-audited profile.
- Gen1Recomp Mod API 2, Nuzlocke Compatibility API 25, compatibility floor 10, save schema 4, and R/B/Y/Gold targets are unchanged.
- Starting Poké Balls, starting Rare Candies, Gold native starting resources, Soft Start, and all beta.29.0.2 acquisition/provenance fixes are untouched.

### Validation

- Static release gate includes explicit assertions for the $3,000 missing-value fallback and the preservation of explicit $0.
- Exact in-game R/B/Y fresh-start retest remains required; runtime evidence is authoritative.

---

# 2.0.0-beta.29.1.0 — Gen1Recomp 0.1.83 compatibility profile

### Goal

Prepare the beta.29.0.2 gameplay candidate for release testing on the current Gen1Recomp 0.1.83 engine without rewriting protected gameplay paths merely because newer public engine surfaces exist.

### Changed

- Built directly from beta.29.0.2 with **no intended gameplay behavior change**.
- Advanced the exact source-audited Gen1Recomp profile from 0.1.81 to 0.1.83 and added explicit 0.1.82/0.1.83 engine-profile records.
- Widened the manifest engine range from `>=0.1.81 <0.1.82` to `>=0.1.81 <0.1.84` so the release candidate can run on Gen1Recomp 0.1.83 for certification.
- Preserved Gen1Recomp Mod API 2, Nuzlocke Compatibility API 25, compatibility floor 10, and Nuzlocke save schema 4.
- Kept the established ENC TRACKER implementation unchanged. Gen1Recomp 0.1.83's additive Gold `mapOverview()` API is recorded for later equivalence evaluation rather than being substituted for a runtime-proven tracker path immediately before release.

### Compatibility audit

- Exact Gen1Recomp v0.1.83 source retains the protected Gen 1 battle constructors and `throwBall`, `askNicknameUI`, `computeDamage`, `onFaint`, `playerMonFainted`, and `finish` seams used by Nuzlocke.
- `Status.residual`, `ItemEffects.use`, `ShopMenu.new`, and the SaveData persistence/slot helpers used by Nuzlocke retain compatible signatures/contracts.
- Gold retains `BattleState:finishBattle`, the blocking `Specials.block` contract, `Vm` `loadwildmon` state, shared `battle.started`/faint/end lifecycle events, and the title-menu hook shape used by Setup.
- The 0.1.82→0.1.83 engine delta is limited to launcher/importer changes plus the additive generation-neutral map-overview surface; it does not replace the protected Nuzlocke battle/item/shop/save wrappers.

### Runtime evidence carried into this build

- On Gen1Recomp 0.1.83, manual import of beta.29.0.2 was recognized with its version/category/game targets.
- The beta.29.0.2 `<0.1.82` manifest gate correctly blocked gameplay on engine 0.1.83.
- Using Update on the unpublished local candidate successfully installed the latest published Nuzlocke release, confirming repository download/install plumbing while also proving unpublished candidates must be imported manually.
- Current Gen1Recomp beta-tag release comparison can show a redundant `v2.0.0 available` notice because its release comparison uses the leading `x.y.z` triple; this is recorded as an engine update-status limitation, not a Nuzlocke gameplay failure.

### Validation / still required

- Exact-source compatibility inspection: **PASS** for the reviewed 0.1.83 seams listed above.
- Local structural release gate: **55/55 PASS**.
- Player and repository candidate ZIP integrity: **PASS**.
- Player distribution exclusion check: **PASS**; repository-only development/testing material is not present in the player ZIP.
- Lua/LuaJIT behavior smoke: **NOT EXECUTED in this workspace** because a compatible runtime executable is not installed.
- Upstream modkit validate/lint/gen2check: **NOT EXECUTED in this workspace** because a complete local Gen1Recomp 0.1.83 source/imported-data tree is not available.
- Required next step: runtime certification of beta.29.1.0 on Gen1Recomp 0.1.83, beginning with Mod Manager Ready status/startup smoke and the beta.29.0.2 four-fix regression matrix.

---

# 2.0.0-beta.29.0.2 — reviewed acquisition and provenance bug fixes

### Goal

Apply the four pre-runtime code-review decisions with the smallest practical changes, preserving previously established acquisition, battle, save, and compatibility behavior while making the newly touched paths explicit runtime-regression targets.

### Fixed

- Removed write-only First Rival Mercy `armed` / `triggered` save telemetry. The durable first-Rival-seen state and battle-local forgiveness flags remain authoritative; legacy values already present in older saves are harmlessly ignored.
- Added stable-identity history-name synchronization after mandatory scripted starter/gift naming completes on R/B/Y and Gold. Acquisition/tracker registration remains at its established transaction point instead of being moved across naming-screen lifecycle boundaries.
- Gold `givepoke` acquisition detection now snapshots and diffs party plus PC boxes, while still preferring a new party member first. Full-party gifts can therefore reach the same initialization, tracker/history, area-consumption, and Nickname Rule handling as party-delivered gifts.
- `pendingStaticEncounter` is now a single-use next-battle provenance token: every actual battle consumes it before trainer/wild classification, so an intervening trainer battle cannot leave stale static state for a later unrelated wild encounter.

### Protected behavior

- First Rival Mercy remains opening-battle-only and one-time.
- Existing party-delivered Gold starter/gift flow, random starter behavior, pre-mutation gift legality, Gold VM resume behavior, tracker deduplication, and stable Pokémon identity remain in place.
- R/B/Y scripted gift registration timing is unchanged; only the matching stored history name is refreshed after mandatory naming.
- Canonical R/B/Y and Gold static encounters still use the existing provenance/classification system; explicit battle-provided static metadata remains independent of the temporary pending marker.

### Validation

- Local structural release gate: **49/49 PASS**.
- Added behavior-smoke regression cases for Rival Mercy persisted-state cleanup, Gold history nickname synchronization, Gold full-party PC-routed gifts, and intervening-trainer static-provenance invalidation.
- Lua/LuaJIT behavior smoke: **NOT EXECUTED in this workspace** because a compatible runtime executable is not installed.
- Upstream modkit validate/lint/gen2check: **NOT EXECUTED in this workspace** because a complete compatible Gen1Recomp checkout/imported-data tree is not available.
- Targeted in-game runtime matrix remains required before approval.

---

# 2.0.0-beta.29.0.1 — release-candidate packaging and developer documentation

- Built directly from beta.29.0.0 with no intended gameplay behavior change.
- Reorganized the release around a lean player distribution and a separate repository/tooling layout.
- Added a dedicated `docs/USER_GUIDE.md` exhaustive player manual while refocusing `README.md` as the repository landing page and quick-start guide.
- Expanded the README feature highlights/recent-major-features presentation so the repository front page advertises the collective current ruleset rather than only the current packaging delta.
- Added `mod.card`, `.modkitignore`, structured issue forms, developer API documentation, feature-confidence tracking, and a versioned compatibility guide.
- Updated manifest metadata to identify the maintained repository, use the `BALANCE` category, and target Red/Blue/Yellow/Gold explicitly.
- Removed the legacy generation-wide Gen 2 target from the candidate manifest so Silver/Crystal are not implied.
- Rebuilt the cumulative changelog so every known revision remains represented, including revisions whose exact per-build delta is only partially recoverable.
- Current candidate remains targeted to the audited Gen1Recomp 0.1.81 line; newer engine compatibility is not claimed by this build.

---

# 2.0.0-beta.29.0.0 — beta.29 development-line baseline

- Created directly from beta.28.20 with no intended gameplay changes.
- Began the beta.29 development line and consolidated the player-facing documentation/package baseline.
- Recorded current runtime evidence for Gold Setup/collapsible sections and Yellow existing-save navigation/collapsible sections.

---

# 2.0.0-beta.28.20 — temporary-party compatibility hardening

- Built directly from beta.28.19.
- Hardened Permadeath against trainer systems that temporarily narrow/reorder the player party and restore it during battle teardown.
- Whiteout now re-evaluates the restored real post-battle party so healthy reserves prevent a false run-ending Whiteout.
- Restored dead Pokémon are reconciled after temporary-party restoration rather than remaining usable.

---

# 2.0.0-beta.28.19 — preserved development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not been fully recovered from surviving release records. Preserved later history places beta.28.17–28.19 in an aggregate hardening period that included party-menu composition protection, checkpoint/savestate reconciliation of runtime-only observations, and additional wrapper/restoration safeguards before beta.28.20's temporary-party fix.
- Those aggregate changes are deliberately **not** assigned to one specific .17/.18/.19 build without stronger evidence.

---

# 2.0.0-beta.28.18 — preserved development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not been fully recovered from surviving release records. Preserved later history places beta.28.17–28.19 in an aggregate hardening period that included party-menu composition protection, checkpoint/savestate reconciliation of runtime-only observations, and additional wrapper/restoration safeguards before beta.28.20's temporary-party fix.
- Those aggregate changes are deliberately **not** assigned to one specific .17/.18/.19 build without stronger evidence.

---

# 2.0.0-beta.28.17 — preserved development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not been fully recovered from surviving release records. Preserved later history places beta.28.17–28.19 in an aggregate hardening period that included party-menu composition protection, checkpoint/savestate reconciliation of runtime-only observations, and additional wrapper/restoration safeguards before beta.28.20's temporary-party fix.
- Those aggregate changes are deliberately **not** assigned to one specific .17/.18/.19 build without stronger evidence.

---

# 2.0.0-beta.28.16 — menu-label clarity

- Renamed the in-game mod-menu entries to **ENC TRACKER** and **NUZ RULES**.
- No intentional gameplay behavior change was associated with the label cleanup.

---

# 2.0.0-beta.28.15 — numeric-rule correctness

- Corrected Maximum BST and the Player/Wild/Trainer Stat EXP selectors being treated as booleans instead of numeric/multi-state rules.
- Retained the lexically scoped Stat EXP/DV implementation used to stay below Lua 5.1 active-local limits.

---

# 2.0.0-beta.28.14 — compiler/runtime regression repair

- Confirmed that the reported missing Blue SETUP entry and Gold Mod Manager syntax error were one Lua compilation regression: beta.28.11's Stat EXP/DV additions crossed Lua 5.1's 200-active-local limit, so the mod failed before either UI path could register.
- Lexically scoped the Stat EXP/DV implementation behind the existing beta export namespace so the full mod could compile without adding long-lived main-function locals.
- Removed the speculative Gold `save.options`/ManagerState workaround used during diagnosis; it was not the root cause.
- Preserved robust R/B/Y and Gold NEW GAME/CONTINUE recognition.
- Preserved HP semantics when creation-time Stat EXP/DV changes alter maximum HP: full-health starters/gifts remain full, while damaged catches retain their actual battle HP.
- Preserved release-gate evidence from the test package while keeping Gold's new Stat EXP/DV paths runtime TEST REQUIRED.

---

# 2.0.0-beta.28.13 — compiler/runtime diagnosis iteration

- Preserved development revision in the beta.28 compiler-repair sequence.
- Exact per-build diagnostic changes are only partially recovered; the sequence addressed the active-local compiler failure introduced after beta.28.11.

---

# 2.0.0-beta.28.12 — compiler/runtime diagnosis iteration

- Preserved development revision in the beta.28 compiler-repair sequence.
- Exact per-build diagnostic changes are only partially recovered; the sequence addressed the active-local compiler failure introduced after beta.28.11.

---

# 2.0.0-beta.28.11 — Stat EXP and DV rule family

- Added independent Player/Wild/Trainer starting Stat EXP presets: 0%, 25%, 50%, 75%, 100%, and 200%.
- Added No Player Stat EXP Gain while preserving ordinary EXP and levels; battle Stat EXP is blocked before mutation and Stat EXP vitamins are vetoed before consumption.
- Added independent Perfect Player/Wild/Trainer DV controls.
- Covered supported player catches, scripted gifts/starters, in-game trades, compatible receive events, and Gold `givepoke` acquisitions.
- Added a generation-neutral battle-start fallback for Gold wild/trainer Stat EXP/DV application where R/B/Y constructors are not shared.
- Starting Stat EXP is bounded by the engine's 65,535 per-stat storage ceiling; 0% preserves the vanilla newly-created value of zero Stat EXP.
- Creation-time rules were designed not to rewrite existing Pokémon merely because the rules were loaded or enabled.
- The original layout crossed Lua 5.1's 200-active-local limit, leading to the beta.28.12–28.14 repair sequence.

---

# 2.0.0-beta.28.10 — No Pseudos

- Added the No Pseudos acquisition restriction with supported pseudo-legendary classification.
- Existing owned Pokémon are preserved rather than removed when the rule is enabled.

---

# 2.0.0-beta.28.9 — 0.1.81 compatibility targeting and local-scope cleanup

- Targeted the Gen1Recomp 0.1.81 compatibility profile.
- Continued removing/restructuring unreachable long-lived locals to keep the large Lua chunk within compiler limits.

---

# 2.0.0-beta.28.8 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.7 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.6 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.5 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.4 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.3 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.2 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.1 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28 — beta.28 development-line start

- Started the beta.28 development line directly after beta.27.16.
- The early beta.28 sequence collectively expanded Gold integration, compatibility reporting, setup/QoL features, and engine-version hardening; some exact per-build allocation remains partially reconstructed.

---

# 2.0.0-beta.27.16 — final beta.27 reported-bug hardening

- Hardened Gold Game Corner `Specials.HANDLERS`/`Specials.ALL` capture and restoration independently, without manufacturing a handler where vanilla or another mod left a registry entry absent.
- Restored/exposed the Gold Nickname Rule and required non-empty nicknames for supported catches and scripted gifts.
- Used Gold's VM-blocking rename seam for supported `givepoke` acquisitions so story-command continuation resumes at the exact native point.
- Broadened the Gold Ball gate to accept explicit static/fixed provenance as well as the native `battle.wild` shape for compatible fixed encounters.
- Clarified Ball Use tier 4 as `STANDARD` and tier 5 as `ALL`; the change corrected presentation while preserving the already-distinct cumulative mechanics.
- Preserved the generation-specific R/B/Y versus Gold Game Corner map IDs after review showed they were intentionally different, not a typo.
- The preserved beta.27.16 package recorded an expanded **66-check structural/engine gate** and **49-check headless interaction smoke suite**.

---

# 2.0.0-beta.27.15 — repository and release-candidate hardening

- Fixed Gold boss progression to recognize Gen 2 trainer-battle shapes rather than requiring Gen 1's `battle.kind == "trainer"`.
- Seeded existing R/B/Y Elite Four/Champion completion and Gold Johto/Kanto Gym/League progression from supported story/badge state.
- Corrected the Johto middle-Gym order to Chuck → Pryce → Jasmine while retaining live ace-level lookup.
- Prevented level-cap regression when an earlier defeated boss becomes stronger than the next boss through trainer overhaul mods.
- Added safe fallback for unknown/future Gen 1 version identifiers and normalized malformed fractional level-cap scope values.
- Invalidated dynamic `trainer.party` observations when the active mod set changes.
- Corrected the compatibility report to match exported Nuzlocke Compatibility API v22 and ensured every advertised capability had an explicit default relationship.
- Expanded provider method/result aliases, Gold World Building queue compatibility, and title-menu save/new-game detection while preventing duplicate Setup insertion.
- Added the first preserved dependency-free Node release gate and headless Lua smoke harness for this line.

---

# 2.0.0-beta.27.14 — live boss-cap compatibility

- Centralized authoritative next-cap calculation across enforcement and status UI.
- Read merged trainer rosters and observed composed trainer-party results so runtime trainer-level edits can feed cap calculation.
- Added public `getNextLevelCapInfo` compatibility output.

---

# 2.0.0-beta.27.13 — encounter-area splits

- Added OFF/CARDINAL splitting for Routes 1–25.
- Added OFF/COMMON Mt. Moon floor splitting and Safari Zone area splitting.
- Added physical-map provenance and reversible projection across tracker/history/catch-state views.

---

# 2.0.0-beta.27.12 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

---

# 2.0.0-beta.27.11 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

---

# 2.0.0-beta.27.10 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

---

# 2.0.0-beta.27.9 — glitch/MissingNo acquisition handling

- Added conservative MissingNo/glitch-species classification for known MissingNo identities plus flagged, malformed, or unregistered species records.
- Added the player-facing **Allow Glitches** rule: OFF blocks new glitch-species acquisitions on supported R/B/Y and Gold paths while preserving already-owned Pokémon.
- Normalized Catch Info/tracker/history handling for supported glitch-species records instead of assuming every acquisition maps cleanly to ordinary registered species data.
- Classification remained conservative/fail-open when incomplete modded metadata could not prove a species was a glitch.

---

# 2.0.0-beta.27.8 — Maximum BST acquisition rule

- Added numeric **Maximum BST** with `000/OFF` or `001–999` selection.
- Applied supported BST acquisition checks to wild catches, scripted gifts, and trades while keeping mandatory starters exempt from rejection.
- Used Gen 1 combined SPECIAL and Gold split special-stat data appropriately when computing base-stat totals.
- Merged available species metadata and failed open when complete/reliable base stats were unavailable rather than blocking an unknown modded species on guessed data.
- Preserved Dupes evaluation ahead of the BST gate and exposed the rule through Nuzlocke Compatibility API v15-era metadata.
- Lua 5.1 structural validation passed for the implementation; representative in-game numeric/acquisition coverage remained required.

---

# 2.0.0-beta.27.7 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

---

# 2.0.0-beta.27.6 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

---

# 2.0.0-beta.27.5 — Gold compatibility-surface refinement

- Added Gen2Compat coverage/member inspection for compatibility reporting.
- Stopped trying to replace Gold's already multi-page Trainer Card for Nuzlocke status; Gold status moved to its own Start-menu screen path.

---

# 2.0.0-beta.27.4 — Save Editor and compatibility-layer hardening

- Detected Gen1Recomp's embedded Save Editor loader session and avoided installing gameplay-bound runtime monkey patches there.
- Separated engine-version compatibility metadata from inter-mod compatibility relationships.

---

# 2.0.0-beta.27.3 — shared-seam compatibility negotiation

- Built directly from beta.27.2 and audited against the Gen1Recomp 0.1.79 line.
- Repaired the shared `ItemEffects.use` seam used by item-rule enforcement.
- Expanded advertised compatibility capabilities to shared engine/UI surfaces such as item use, shops, battle finish, Trainer Card, party/start menus, screens, static encounters, trainer parties, and boss caps.
- Began separating encounter-loss presentation from owned-Pokémon death presentation with **LOST ENC.** / **DEATHS** terminology, while the deeper legacy-history status overlap remained for the later beta.29.2.0 migration.
- Advanced the additive compatibility surface to Nuzlocke Compatibility API v11 while retaining backward-compatible older provider expectations.

---

# 2.0.0-beta.27.2 — preserved beta.27 development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not yet been recovered from surviving records; no history is inferred beyond its confirmed place in the sequence.

---

# 2.0.0-beta.27.1 — preserved beta.27 development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not yet been recovered from surviving records; no history is inferred beyond its confirmed place in the sequence.

---

# 2.0.0-beta.27 — promoted public baseline

- Promoted directly from the runtime-tested beta.26.6 line without an intentional gameplay change during promotion.
- Gold fresh startup/New Game, RULES, TRACKER, Catch Info, and Cyndaquil starter acquisition had runtime PASS evidence at promotion.
- Yellow RULES/TRACKER/catch behavior and prior 1st Catch toggle behavior carried runtime PASS evidence.
- Save schema remained 4.

---

# 2.0.0-beta.26.6 — Gold gift enforcement and Whiteout consequence

- Ran supported Gold `givepoke` gift legality checks before story/party mutation while preserving mandatory starter handling.
- Added the Gen 2 `finishBattle` consumer for the Nuzlocke Whiteout path while leaving Whiteout OFF on the native path.
- Gold ordinary gift denial and destructive Whiteout still required dedicated runtime confirmation at this revision.

---

# 2.0.0-beta.26.5 — acquisition and Whiteout correctness

- Corrected fallback gift/trade acquisition classification and generation-gated R/B/Y starting resources.
- Reworked Whiteout teardown to preserve the engine's wrapped finish chain instead of duplicating public teardown operations.

---

# 2.0.0-beta.26.4 — Tracker clarity and progression-aware TV

- Replaced cryptic failed-encounter labels with `FAILED <species>` and renamed the Tracker result column for clarity.
- Added failed-result marquee presentation and progression-aware Tier 3 home-TV run recaps.
- Preserved runtime evidence for Yellow UI controls, failed encounters, next-cap display, and fresh No Buying/No Selling.

---

# 2.0.0-beta.26.3 — early-game dialogue and TV polish

- Clarified Pokédex activation messaging and added adaptive Tier 3 home-TV flavor.
- Preserved runtime evidence for Yellow Setup/bedroom startup, starter Catch Info, No Mom Heal, PokéCenter behavior, and opening-rival flavor timing.

---

# 2.0.0-beta.26.2 — Gym Guide alignment and runtime-evidence rollup

- Re-centered the R/B/Y Gym Guide Rare Candy quantity screen without changing service mechanics.
- Recorded runtime PASS evidence for existing Red/Blue No Buying/No Selling, Red Gym Guide service, Blue No Field Heal, and nickname-aware catch flavor.

---

# 2.0.0-beta.26.1 — dialogue and starter-metadata polish

- Improved No Mom Heal dialogue ownership, starting-Ball wording, early R/B/Y starter Catch Info canonicalization, and Nuzlocke battle-message wrapping/paging.

---

# 2.0.0-beta.26 — runtime-tested canonical baseline

- Promoted the runtime-tested 26B10 development revision and retired the prior lettered internal-revision convention.
- Carried the published 25D4-RBY2 title/startup repair, Soft Start, Pokédex handoff, starting resources, two-view R/B/Y Trainer Card, Gold beta Setup, nickname handling, and first-rival timing.
- Save schema remained 4.

---

# 26B10 — runtime-tested beta.26 promotion candidate

- Known internal development revision directly descended from the published 25D4-RBY2 startup/menu hotfix and promoted forward as `2.0.0-beta.26`.
- This era accumulated runtime-driven verification/fixes around Gold Setup, PP-item restrictions, Pokémon Center restrictions, No Buying/No Selling, Gym Guide behavior, Repels, X Items, startup/menu lifecycle, and related compatibility paths.
- Exact per-change attribution inside the B-series is incomplete, so only the confirmed `26B10` promotion point is given its own heading.
- Its runtime PASS evidence became protected baseline evidence for later beta.26/27 development.

---

# 2.0.0-beta.25 — 25D4-RBY2 — R/B/Y startup/menu hotfix

- Runtime-confirmed Blue and Yellow title SETUP plus Oak-intro-to-bedroom startup.
- Runtime-reconfirmed Gold Setup/New Game and smoke-tested an existing Red save.
- Restored the proven title Setup injection and removed an unsafe optional post-intro screen push that caused a white screen.

### Historical subrecord — 2.0.0-beta.25 — 25D2 — Gym Guide handoff diagnostic

- The Gym Guide Rare Candy offer/registration path was functioning, but runtime testing still failed at the quantity-screen handoff.
- The failure was isolated to selector lifecycle/continuation rather than the long-lived direct-row Gym Guide composition or candy policy.

### Historical subrecord — 2.0.0-beta.25 — 25D3 — Gym Guide selector lifecycle repair

- Changed only the failing quantity-screen lifecycle to use Gen1Recomp's current blocking `push_screen` script-command behavior.
- Preserved NPC registration, vanilla dialogue composition, quantity choices, and candy-grant policy.
- Runtime testing reported the 1/10/25/50/99 selector working after this repair.

### Historical subrecord — 2.0.0-beta.25 — 25D4 — item-rule and Gym Guide stabilization

- Runtime-confirmed No Repels and No X Items and retained established passes for No Escape, healing/field restrictions, nickname, Center, shops, and Gym Guide quantity selection.
- Hardened item recognition, PP-item coverage, acquisition/recovery paths, and Whiteout teardown while preserving save schema 4.

---

# 2.0.0-beta.24 — Gold Setup experiment

- Attempted Gold automatic New Game Setup through an intro hook; runtime evidence showed the attempt remained vanilla, leading to the later title-menu design.

---

# 2.0.0-beta.23 — early Gold status and provenance work

- Added experimental Gold Trainer Card status integration and Gen 2 Egg/Day Care/roaming provenance support.
- Generation-gated the R/B/Y Gym Guide integration.

---

# 2.0.0-beta.22 — conflicting surviving records

- A directly surviving committed beta.22 source identifies itself as **"static integrity + version/persistence hardening"**, carries save schema 4 and Nuzlocke Compatibility API v7, and does not contain the later Gold/Gen2 adapter markers visible in beta.25-era source.
- A later reconstructed beta.25 changelog attributes generation-native Gold capture, permadeath, nickname, Mart, starter/gift, area-tracking adapters, and Gen 1 + Gold manifest targeting to a beta.22 stage.
- Because these records conflict, the current history preserves both facts without pretending they describe the same exact code snapshot. The Gold adapter work was present by the later beta.23–25 line, but its precise first beta.22 build/revision is unresolved.

---

# 2.0.0-beta.21 — Gold/GSC architecture groundwork

- Reconstructed directly from beta.20 while preserving save schema 4 and existing rule/save behavior.
- Added version-profile architecture and experimental Gold/GSC targeting groundwork; the surviving reconstruction audited against Gen1Recomp 0.1.78.
- Expanded progression architecture through Red/postgame-provider concepts and the R/B/Y Trainer Card active-rule display.
- Preserved a two-row R/B/Y Trainer Card rule display and expanded World Building Tier 1/2/3 labels in the reconstructed build.
- The reconstructed beta.21 compatibility surface is recorded as Nuzlocke Compatibility API v9; later planned semantics not proven present in that source remain unassigned.

---

# 2.0.0-beta.20 — compatibility and regression hardening

- Built as a surgical update from beta.19 rather than a branch replacement.
- Centralized item/capture/shop policy exports, improved provider surfaces, persistent identity/recovery, Trainer Card/Catch Info, and Gym Guide behavior while preserving save schema 4.

---

# 2.0.0-beta.19 — protected reconciliation baseline

- Served as the protected canonical baseline for the beta.20 surgical update line.
- Recovered project-log evidence identifies beta.19 as the point where split **No Buying** / **No Selling** replaced the retired combined shop rule, persistent Pokémon identities were established, and Dupes supported OFF / SPECIES / FAMILY modes.
- Numeric starting resources, separate item restrictions, presets, R/B/Y-specific handling, additive save/persistence reconciliation, and transactional gift/trade enforcement were present in the protected baseline.
- Multiple legitimate same-area tracker catches were preserved as separate records instead of being collapsed together.
- Wonderlocke remained visible/dormant and forced OFF; the baseline also carried the v0.1.77-era audit work, Blue/Yellow Setup/cursor fixes, and removal of the old NEXT BOSS display.
- Some earlier feature-by-feature introduction points remain unrecovered, so this entry records known beta.19 baseline properties rather than claiming every listed feature originated in beta.19.

---

# 2.0.0-beta.16 — reconstructed from surviving source/release records

- Fixed Setup-menu helper scoping/order behavior and retained the established Gym Guide architecture.

---

# 2.0.0-beta.15 — surviving source with conflicting later reconstruction

- The directly surviving committed beta.15 source identifies itself as **"Menu crash fix"**, carries **save schema 2**, and exports **Nuzlocke Compatibility API v6**.
- A later reconstructed beta.25 changelog instead attributes a Gen1Recomp 0.1.77 compatibility pass and the move to save schema 3 to beta.15.
- The conflict is retained explicitly. Current evidence does not safely identify which later beta.15/internal revision first carried schema 3, so the changelog no longer states that transition as certain.
- Wonderlocke remained disabled/dormant through the surviving records.

---

# 2.0.0-beta.14 — reconstructed save-schema revision

- Surviving history shows the future-safe migration framework at **save schema 2** by this snapshot.
- Continued tracker/recovery hardening while keeping unfinished Wonderlocke behavior non-active.

---

# 2.0.0-beta.12 — first surviving versioned save-schema baseline

- Added the first surviving future-safe persistent save-schema baseline at **schema 1**.
- Used an idempotent marker-only migration so older/vanilla saves could establish a versioned migration boundary without rewriting unrelated gameplay data.
- Preserved the established beta.8-era Gym Guide direct-row composition/selector and the existing Setup, provenance/recovery, level-cap, Tracker/Catch Info, and Trainer Card systems.

---

# 2.0.0-beta.11 — surviving development snapshot

- Improved catch-location recovery for human-readable saved locations.
- Changed the Rare Candy selector cursor presentation to the native theme cursor without changing selector lifecycle.
- Only source-supported history is retained; broader exact delta is not inferred.

---

# 2.0.0-beta.10 — surviving development snapshot

- Added native cursor/scroll presentation work and Trainer Card refinements.
- Continued the established Gym Guide direct-row + dedicated-selector behavior and dormant Wonderlocke-era infrastructure.
- Only source-supported history is retained; broader exact delta is not inferred.

---

# 2.0.0-beta.8 — surviving development snapshot

- Experimental provider/Wonderlocke-era infrastructure was present by this revision.
- The Gym Guide direct-row composition architecture that survived into later releases was already established by this period.

---

# 2.0.0-beta.5 — surviving legacy-reconciliation snapshot

- Added legacy catch-location reconciliation/recovery work.
- Gym Guide behavior remained on the earlier implementation of that period.
- Only source-supported history is retained; broader exact delta is not inferred.

---

# 2.0.0-beta.4 — World Building introduction

- Added World Building tiers and associated optional flavor/mechanic messaging.
- Added level-cap-aware Gym Guide feedback before the Rare Candy selector.

---

# 2.0.0-beta.3 — surviving logic-audit snapshot

- Added/expanded provenance-aware catch recovery and compatibility work by this surviving snapshot.
- The Gym Guide Rare Candy feature was already present with its dedicated **1 / 10 / 25 / 50 / 99** quantity selector.
- Only source-supported history is retained; broader exact delta is not inferred.

---

# 2.0.0-beta.1 — surviving Whiteout-fix snapshot

- A surviving source snapshot identifies this revision as an early Whiteout-fix stage.
- Only source-supported history is retained; broader exact delta is not inferred.
