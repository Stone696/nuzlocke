# Nuzlocke 2.6.0

2.6.0 is the release promotion of the runtime-booted 2.5.92 line and a strict child of 2.5.92. **PC-Only Catches / PC Catches** is moved out of CLAUSES and placed at the very top of the **QOL** section so the progression/completion capture convenience is easier to find. Its key, default, save representation, progression-only eligibility, immediate PC transfer, permanent PC LOCKED behavior, encounter-slot exemption, Type Locke behavior, and withdrawal/release restrictions are unchanged. No other gameplay behavior changes.

The release carries forward the validated 2.5.92 Run History death-occurrence dedupe, 2.5.91 migration shadow structural-equality repair, the protected 2.5.89 DEV REPORT modularization runtime PASS, Compatibility API 29, Save Schema 4, Diagnostics API 1, Run History API 1, Mod API 2, and Gen1Recomp 0.2.14 exact-runtime boot/DEV REPORT PASS.

# Nuzlocke 2.5.92

2.5.92 is a strict child of 2.5.91. It fixes Run History death idempotency without collapsing legitimate repeat deaths after an F. TOKEN revival. Each authoritative death commit now increments a persistent per-Pokémon `nuzlockeDeathSequence`; `RunHistory.recordDeath` derives `death:<pokemonId>:<sequence>` when both identity and occurrence are available. Re-entry/retry of the same committed faint therefore dedupes, while a revived Pokémon can later record sequence 2, 3, and so on. Run History API/storage format remain v1 and gameplay death/F. TOKEN mechanics are unchanged.

# Nuzlocke 2.5.91

2.5.91 is a strict child of 2.5.90. It fixes the migration shadow store's dry-run diff logic so table-valued save keys are compared by recursive contents instead of Lua table identity. Touching and writing back an unchanged table no longer produces a false migration change. Migration commit ordering, save schema, recovery journaling, and gameplay behavior are unchanged.

# Nuzlocke 2.5.90

2.5.90 is a strict child of 2.5.89. It continues the targeted behavior-preserving `main.lua` split by extracting only the read-only, version-aware vanilla gift/trade acquisition source catalog and deterministic source fallback helpers into package-local `acquisition_catalog.lua`. Gift/trade transaction wrappers, encounter-slot enforcement, starter handling, Random Starter, Tracker, Run History, save migration, and rule logic remain in their existing paths.

The module receives only the existing live `getGameVersion` function. Public compatibility helper names (`buildGiftLookup`, `buildTradeLookup`, `deterministicSourceFallback`, and the existing `nuzlocke_compat` aliases that consume them) remain unchanged. Release Safety now includes the new module in package-read diagnostics. Runtime boot plus one gift/trade compatibility lookup smoke test is recommended before protecting this extraction boundary.

# Nuzlocke 2.5.89

2.5.89 is a strict child of 2.5.88. It continues the behavior-preserving `main.lua` split by extracting the DEV REPORT / NZR6 report-code, text-export, stored-report, diagnostics facade, and lifecycle breadcrumb registration surface into package-local `dev_report.lua`. Dynamic game identity is supplied through a getter, while Save Schema constants are injected explicitly. No diagnostic API names, Report Code format, gameplay behavior, save semantics, compatibility ownership, rules, Random Starter, Run History, or UI behavior change.

The extraction removes the large diagnostic/report surface from the monolithic entry chunk while retaining the same `mod.exports.__beta26.Dev` and `mod.exports.nuzlocke_dev` contracts. Release Safety now includes `dev_report.lua` in the expected package inventory. Runtime boot plus DEV REPORT open/report-code smoke testing remains required before treating this boundary as protected.

# Nuzlocke 2.5.88

## UI navigation memory and MOD COMPAT polish

2.5.88 is a strict child of 2.5.87. It is a presentation/QoL-only pass: MOD COMPAT's detail panel now reserves a clean footer row instead of allowing three help lines to crowd the page indicator, and Nuzlocke-owned menu navigation remembers the player's last position for the current mod session. ENC TRACKER remembers tab/row, MOD COMPAT remembers selected row/scroll/detail page, and DEV REPORT/Dev Tools remembers cursor/report scroll.

NUZ RULES/Setup already had semantic cursor/scroll memory and collapsed-section memory; 2.5.88 centralizes and explicitly protects that session-only UI state. None of this state is written into gameplay saves. Fresh process/mod reload starts with normal default menu positions. No gameplay, save schema, compatibility API, Run History, Random Starter, encounter, or F. TOKEN behavior changes.

# Nuzlocke 2.5.87

## Compatibility API cleanup and tracker rollback

2.5.87 is a strict child of 2.5.86. The 2.5.86 ENC TRACKER marker experiment is fully reverted to the pre-marker 2.5.85 presentation after runtime testing showed that ASCII `O` was not an acceptable substitute for the intended caught/check symbol. Graphical encounter-area status symbols are back on the backlog for a future font/glyph-aware implementation.

Compatibility API advances to **29** with additive introspection only. Engine profiles now include the already-audited 0.2.12, 0.2.13, and 0.2.14 releases; callers can query the active engine profile and a compatibility summary, and provider inventory can be enumerated through read-only snapshots. Release Safety now checks that the active engine profile exists. Mod API remains **2**, Save Schema remains **4**, engine range remains `>=0.1.86 <2.0.0`, and gameplay behavior is otherwise unchanged.

# Nuzlocke 2.5.86

## 2.5.86 — Encounter Tracker status markers

2.5.86 is a strict child of 2.5.85. ENC TRACKER now prefixes every encounter result with a compact font-safe status marker while retaining a plain-language status word: `O CAUGHT`, `X FAILED`, `- OPEN`, `* SHINY`, and `X DEAD`. The same semantic labels are used by the classic R/B/Y tracker, native Gold/Silver tracker, and Modern UI model. This is presentation-only; encounter state, catches, deaths, rerolls, area splitting, and Run History are unchanged.

# Nuzlocke 2.5.85

## 2.5.85 — Run History producer completion

2.5.85 is a strict child of 2.5.84. It completes the initial Run History v1 producer set without changing the journal format, Save Schema, Compatibility API, or Nuzlocke rule behavior. Ordinary successful `pokemon.caught` transactions now append `pokemon.caught` rows after both the engine capture and Nuzlocke tracker/area registration have committed. Existing starter/gift/trade/progression catch producers remain in place and continue to dedupe by persistent Pokémon identity.

The three authoritative death paths were audited and retained: R/B/Y battle permadeath, shared field-poison permadeath, and Gold/Silver battle permadeath already append `pokemon.died` only after the death record is committed. Route Forgiveness now journals both halves of the token lifecycle: Gym Leader rewards append `forgiveness.awarded` after the reward ledger and carried token count commit, while area rerolls and revivals continue to append `forgiveness.used` after a successful spend and now include the post-spend token balance. Gym awards use the permanent semantic Leader key as a dedupe key.

Static/harness coverage exercises Gen 1 and Gen 2 row provenance, catch identity dedupe, repeat deaths after revival semantics, Gym-award dedupe, token balances, summary counters, and Run History integrity. Exact-edition gameplay verification is still required before producer confidence is promoted to runtime PASS; a focused Red/Blue/Yellow catch+death+token test and an independent Gold/Silver equivalent are sufficient.

## 2.5.84 — Random Starter cache dedup correctness

2.5.84 is a strict child of 2.5.83. It fixes **RS-CACHE-DEDUP-001**, a source-confirmed low-severity Random Starter defect in the legacy **unseeded** distinct-choice path. The shared starter-choice table contains both canonical bare per-starter mirror rows and seed/style/scoped cache rows. Previously, every valid species value in that table was counted as already used, so stale scoped-cache values could incorrectly shrink the current unseeded candidate pool.

The used-species scan now counts only canonical bare starter-slot mirror entries and ignores scoped (`:`) cache keys plus internal `__...` markers. Seeded Random Starter selection, deterministic semantic namespaces, Gold/Silver three-ball slate generation, starter preview rendering, and starter award transactions are unchanged. No save-schema or API version changes are required because the stored cache format is unchanged.

Gen1Recomp **0.2.14 exact-runtime PASS** is also recorded from 2.5.83: the mod loaded and DEV REPORT rendered normally.

## 2.5.83 — Gen1Recomp 0.2.14 compatibility audit

2.5.83 is a strict child of runtime-boot-tested 2.5.82 and intentionally makes no gameplay, rule, hook, save, public API, or modularization behavior change. The published Gen1Recomp 0.2.13→0.2.14 tag delta was reviewed directly: it is three commits ahead and changes only Android release packaging (`mobile/android/love/build.gradle`) and iOS app-repository metadata (`mobile/ios/app-repo.json`). No Nuzlocke-facing Runtime/Loader/Mod API/GameVersion/Gen 2 VM/world contract changed.

The audited engine marker therefore advances to **0.2.14** while Mod API remains **2** and the supported engine range remains `>=0.1.86 <2.0.0`. No compatibility wrapper is replaced and no new upstream feature is adopted because 0.2.14 exposes no new mod-facing feature or contract. The 2.5.82 Public Interop extraction remains unchanged and its successful boot/DEV REPORT runtime smoke test is carried forward as protected evidence.

## 2.5.82 — Public Interop modularization

2.5.82 is a strict child of 2.5.81. It continues the behavior-preserving `main.lua` split by extracting the Public Interop / Capability API and legacy auto-compatibility infrastructure into package-local `public_interop.lua`. The extraction keeps live game/save state behind injected getters so lifecycle changes are not captured as stale module-load values. Public API names, capability ownership, provider registration, content registration, storage/item/encounter policy surfaces, and compatibility aliases are unchanged.

This removes about 1,366 lines from `main.lua` without touching Random Starter, encounter enforcement, save migration orchestration, or the runtime-validated rule catalog. 2.5.81 setup rendering remains protected runtime PASS. A focused 2.5.82 boot + MOD COMPAT/API smoke test is required.

## 2.5.81 — Rule catalog modularization

2.5.81 is a strict child of 2.5.80. It continues the approved behavior-preserving `main.lua` split by moving the large rule/settings catalog, canonical legendary/mythical/pseudo fallback sets, and presentation preset tables into `rule_catalog.lua`. Existing rule keys, defaults, descriptions, exports, save semantics, presets, and enforcement consumers remain unchanged.

This extraction removes roughly 56 KB and 279 lines from `main.lua` without touching Random Starter, encounter enforcement, migration transaction orchestration, or protected gameplay hooks. 2.5.80's Gold runtime result is now protected: the mod loaded on Gen1Recomp 0.2.13 and Elm Random Starter displayed and awarded a randomized starter successfully. Silver still requires its own independent Random Starter runtime confirmation.

## 2.5.80 — Gen1Recomp 0.2.13 compatibility, modularization, and Stadium provenance

2.5.80 is a strict child of 2.5.79. It repairs the 0.2.13 Mod Manager boot failure caused by treating development-time package source introspection as a fatal Release Safety invariant. Package-read/source-introspection checks are now fail-soft diagnostics: genuine encoded invariants can still fail the audit, but an unavailable source read cannot make the gameplay mod unbootable.

This build begins the approved modularization of the monolithic entry file without changing rule semantics. Run History, Release Safety, the large Dev assertion surface, and the migration shadow-store helper now live in dedicated package modules loaded through the same package-local module pattern already used by the existing integrations. Transaction orchestration remains in `main.lua` until historical-save runtime tests protect a larger migration move.

The Gen1Recomp 0.2.13 source audit keeps Mod API 2 and the existing supported engine range. The Gen 2 VM/world callback seams used by Nuzlocke remain compatible, including `script.command`, `showPic`, `cry`, and `givePoke`; no stable wrapper is replaced merely because upstream internals changed.

A new acquisition-provenance surface can mark externally transferred Pokémon as **STADIUM PRIZE**, with optional `stadium_1` or `stadium_2` origin metadata. This records where the prize came from without inventing a fake encounter map/location.

## 2.5.79 — Johto Random Starter native preview repair

2.5.79 is a strict child of 2.5.78. It targets the remaining Gold/Silver Elm starter presentation split without changing the Random Starter rule, deterministic slate, or native grant transaction. The existing script-command preview intent remains preferred, but the Gen 2 VM's native `showPic` and `cry` callbacks now have a context-safe fallback that independently recognizes Elm's three canonical starter previews and substitutes the same deterministic randomized species when the transient script intent was not available.

The fallback does not mutate generated script rows and does not reroll the starter. Dev health now reports whether the latest preview used the script intent, the native fallback, or vanilla presentation. R/B/Y Random Starter paths are unchanged. Exact Gold and Silver runtime confirmation is still required before this repair is promoted to PASS.

## 2.5.78 — Save/migration integrity foundation

2.5.78 is a strict child of 2.5.77. It keeps Save Schema **4** and does not change Nuzlocke rule semantics, but hardens numbered schema upgrades with a versioned write-ahead transaction journal. Each schema step is first evaluated against an in-memory shadow of `mod.save`; only a successful preflight produces a deterministic write set for the live save. Ordinary writes are committed first, the migration checkpoint second, and the schema marker last.

If execution is interrupted before the schema marker commits, the next load restores the recorded pre-migration values before retrying. If the schema marker already reached the target, recovery completes checkpoint cleanup instead of rolling back a committed transition. If migration/recovery itself cannot complete safely, Nuzlocke persistence and rule enforcement pause with a distinct `migration_error` reason rather than continuing against uncertain state. A read-only `previewPendingSchemaMigrations()` surface exposes the same planned write set without touching the live save, and `saveUpgrade.status()` reports current schema/transaction state for diagnostics.

Before any numbered schema recovery/transition, 2.5.78 also uses Gen1Recomp's engine-owned save path/filesystem to create a separate bounded **three-deep whole-save pre-migration snapshot rotation**. These Nuzlocke snapshots do not replace or overwrite the engine's own `.bak`/`.tmp` recovery files. Backup creation is verified after write and recorded in migration status diagnostics.

The new transaction record uses the reserved `__nuzlocke_` namespace and is cleared after a clean commit. This first integrity tranche makes **numbered schema migrations** transactional; semantic/reconstruction/projection phases remain on the existing ordered coordinator and are not falsely described as transactional. Automated restore UI, corruption fuzzing, historical-save fixture coverage, and broader migration/gameplay transactions remain future work.

## 2.5.77 — Release Safety Framework automation

2.5.77 is a strict child of 2.5.76. It adds the first executable Release Safety Framework pass without changing Nuzlocke gameplay rules or save semantics. Existing static contracts are now aggregated by one read-only `releaseSafetyAudit()` report and enforced by `assertReleaseSafety()` during module load. The runner covers rule defaults/registry shape, Save Schema descriptor shape, dead-fallback lint, world-catalog snapshot, cross-table invariants, trainer-reward active-guard coverage, build provenance, Compatibility API capability-version coverage, and package-local source availability.

This is a **static/release-contract gate**, not runtime gameplay evidence. A PASS means the shipped package satisfies its encoded release-safety contracts; it does not promote any feature whose exact-edition runtime status is still TEST REQUIRED or FAIL. Gold/Silver Random Starter preview and Run History producer runtime validation therefore remain open.

## 2.5.76 — public documentation hygiene only

2.5.76 is a strict documentation-only child of 2.5.75. It removes transient internal-coordination provenance from player-package documentation and establishes a permanent public-documentation boundary. Public docs now describe durable release facts, behavior, evidence, compatibility, and testing status without exposing internal coordination sources. No gameplay, rule, hook, save, randomizer, Run History, compatibility-adapter, or custom-screen behavior changes.


## 2.5.75 — review/process consolidation only

2.5.75 is a **process/documentation-only child of 2.5.74**. It intentionally makes no gameplay, rule-enforcement, hook, save-schema, Run History, randomizer, compatibility-adapter, or custom-screen behavior change. `main.lua` changes only build/provenance metadata and `manifest.json` advances to 2.5.75.

The project workflow now uses durable, structured review records and repeatable quality controls. The canonical development process includes:

- a fixed review checklist and vertical-slice review method;
- explicit review modes, two-pass review, timeboxes, and stopping rules;
- a structured Bug & Investigation Tracker with a common severity rubric;
- Open Questions, Unreviewed Surface, and Cleared Investigation ledgers;
- one-line risk statements and regression protection proposed with every fix;
- a lightweight Definition of Done for every rule/feature;
- pre-ship review, versioned review summaries, and regression retrospectives;
- formal brainstorm intake/triage and periodic cold-read reviews.

No new player-package files were added and no player-visible behavior changed.

Current open runtime issue remains **Gold/Silver Random Starter preview presentation**: randomized awards work, but tested Elm pre-selection portrait/cry parity is not yet runtime-confirmed. Blue 2.5.71 randomized starter portraits remain protected. Run History v1 producers still require exact-edition runtime validation.

The stable Gen1Recomp audit marker remains **0.2.12** with engine range `>=0.1.86 <2.0.0`.

## 2.5.74 — documentation / roadmap consolidation only

2.5.74 is a **documentation-only planning child of 2.5.73**. It does not intentionally change Nuzlocke gameplay, rule enforcement, hooks, save representation, Run History behavior, Random Starter behavior, compatibility adapters, or player UI logic. `main.lua` changes only its displayed build/manifest identity.

This documentation pass consolidates the large architecture/quality backlog into coherent initiatives, records the latest runtime evidence, and adds newly proposed ROM-hack-inspired feature investigations. Two proposed items are already present and are therefore **not** re-added to the backlog: **Physical/Special Split** and the enforced **Nickname Rule**.

Current open runtime issue: **Gold/Silver Random Starter awards are randomized, but the Elm pre-selection portrait remains vanilla in tested Gen 2 builds.** Blue 2.5.71 randomized starter portraits are runtime-confirmed working and remain protected. Run History v1 remains a 2.5.73 architectural foundation whose gameplay producers still need runtime validation.

The stable Gen1Recomp audit marker remains **0.2.12** with engine range `>=0.1.86 <2.0.0`.

### Planning snapshot added in 2.5.74

The active roadmap now separates **reliability/architecture** from **gameplay/content** so planned work is not mistaken for implemented behavior. Major engineering initiatives include release-gate automation, save/migration safety, hook/provider ownership, deterministic RNG testing, transaction interruption safety, exact-edition parity contracts, diagnostics/support bundles, public API/portable-format stability, incremental `main.lua` modularization, localization/accessibility checks, and explicit Gen1Recomp engine-contract documentation.

Newly recorded gameplay/QoL investigations include:

- Catch-Up Training / Party Equalizer and smarter competitive-style Trainer AI.
- Enhanced/curated boss teams, trainer-team randomization, wild-moveset scaling and adaptive-rival experiments.
- Survivor/Postgame Gauntlet and longer-term Battle Facility ideas.
- Early Move Relearner/Move Deleter access, battle/text speed controls, optional persistent Auto-Repel behavior, party-wide battle status HUD, and a party-menu level-cap indicator.
- Boxed **living** Pokémon auto-heal policy investigation; Permadeath/PC-locked Pokémon must never be revived by a QoL heal.
- Arbitrary lead-Pokémon follower presentation, Nuzlocke-aware Pokédex flavor, starter-roulette presentation, Run Snapshot sharing/viewer and Audience Choice API groundwork.
- Long-term investigations: modern type/Fairy system, ability-provider compatibility, National Dex/time-based encounter changes, expanded item drops, Eggslocke breeding support and bespoke trainer content.

These are **planned or investigation-only** until a later changelog explicitly marks them implemented.

## 2.5.73 — Run History v1 foundation + Gen1Recomp 0.2.12 audit

2.5.73 adds the persistence/API foundation for the planned **Graveyard**, **Almanac / Run Recap**, **Confessional Log**, meta-run statistics and companion/Soul-Link integrations. It does **not** add those UI pages yet.

`run_history_v1` is a separate bounded chronology journal alongside the existing encounter Tracker and legacy `nuzlocke_history`. Existing structures keep their current gameplay responsibilities; Run History records chronological events at already-proven transaction boundaries so later readers do not need to reconstruct history from mutable save state.

The first producers are catches, Pokémon deaths and F. TOKEN use. Rows carry exact edition, generation, build, stable sequence number and flat scalar event data. The journal retains up to 512 recent event rows while lifetime counters remain cumulative. Catch rows dedupe by persistent Pokémon identity. Death rows dedupe by persistent Pokémon identity plus a per-Pokémon death occurrence number, so duplicate handling of one faint is idempotent while a Pokémon revived by Route Forgiveness can later die again and produce another valid death event. It initializes on game/save lifecycle boundaries: a fresh 2.5.73 run is full-coverage, while an already-progressed upgraded save is marked `partial` and retains baseline catch/death counters instead of pretending older chronology was observed.

A new read/export surface, `mod.exports.nuzlocke_run_history` API 1, exposes report/list/record operations and publishes `nuzlocke.run_history` after a committed append. Dev assertions validate the journal's ordering/bounds/scalar/dedupe invariants. Save Schema remains 4 because this is additive gameplay history, not a reinterpretation of existing schema fields.

The audited Gen1Recomp marker advances from **0.2.11 to 0.2.12** after reviewing the 15-commit delta. The engine range remains `>=0.1.86 <2.0.0`; no Runtime/Loader/Gen 2 VM/GameVersion contract rewrite was required.


## 2.5.72 — Gen 2 Random Starter native preview ownership repair

Gold 2.5.71 runtime testing proved the randomized award path works, but Elm's pre-selection Poké Ball portraits still showed the vanilla Johto trio. 2.5.72 keeps the modern random candidate/slate/grant architecture and moves only presentation substitution to Gen1Recomp 0.2.11's native Gen 2 VM callbacks: `hooks.showPic` for the actual portrait and `hooks.cry` for the cry.

The script-command layer now identifies the exact Elm preview command and arms a private one-command intent. The native callback consumes that intent, renders the randomized species, and acknowledges what was actually presented. The matching `givepoke` then prefers that acknowledged species. Generated script rows are never mutated.

Dev Self-Test preview/award parity is also stricter: after a committed randomized starter it requires a native-render acknowledgement and exact identity equality, so intended-but-unrendered previews cannot masquerade as PASS.

**Runtime test required:** fresh Gold/Silver NEW GAME with Random Starter ON; verify each Ball's picture/cry is randomized, then select a non-vanilla preview and confirm the received Pokémon is identical.


## 2.5.71 — Gen 2 Random Starter preview-to-award synchronization repair

Gold 2.5.70 runtime testing proved the candidate-pool fix restored real randomization, but also exposed a new transaction mismatch: Elm displayed **Cyndaquil** while the selected Ball awarded **Smoochum**. The preview and final award were resolving the randomizer through different early-NEW-GAME save backings.

2.5.71 keeps the current deterministic three-ball slate and native Gen 2 grant architecture, but records the exact species displayed for each Elm Ball in the VM-private transaction state. When the player selects that Ball, the matching `givepoke` consumes the recorded preview species directly. An armed preview choice is never rerolled at the grant seam.

Dev Self-Test now includes `opening_starter_preview_award_parity`, allowing a future preview/award mismatch to be captured in diagnostic evidence. The 2.5.70 Gen 2 candidate validator remains intact. Save Schema 4, Compatibility API 28, Diagnostics API 1, NZR6, exact-edition identity and the engine range remain unchanged.

**Runtime test required:** Gold and Silver fresh NEW GAME with Random Starter ON. At least one preview should be non-vanilla, and the received Pokemon must exactly match the selected Ball's displayed species. A fixed seed with unchanged settings must reproduce the same slate.

## 2.5.70 — Gen 2 Random Starter candidate-pool parity repair

2.5.70 corrected Gold/Silver candidate validation to use Gen1Recomp's real Gen 2 `Mon` schema (`baseStats` / `levelMoves`) instead of Gen 1-only `level1Moves` / `learnset`. Runtime testing confirmed that real non-vanilla randomization returned, but preview-to-award identity could still desynchronize during early NEW GAME save adoption; 2.5.71 repairs that handoff without reverting the pool fix.

## 2.5.69 — Gen 2 Random Starter grant repair

Gold/Silver Random Starter now carries the exact live Gen 2 game object from the identified Elm `givepoke` script command into the private one-shot VM grant intent. The native `givePoke` wrapper therefore resolves the randomized species/index against the correct fresh NEW GAME state instead of depending on an early-session `currentGame` lookup. Silver also has an explicit Johto starter-family registration. Runtime confirmation is still required on both Gold and Silver.

## 2.5.68 — NUZ STATUS cleanup

NUZ STATUS is now a live challenge card rather than a dump of setup/config state. Setup-only starting resources and PC kits, Gym Guide Candy/service state, redundant master-ON rows, and raw Type Locke slot labels are removed. Type Locke is summarized once in player-facing terms, non-vanilla Difficulty is named, neutral Trainer Money 100% is hidden, generic rows prefer short display names, and Gold/Silver now show the same Loadout summary as R/B/Y. The existing R/B/Y ListMenu and Gen 2 status renderer/input behavior are unchanged.


## 2.5.67 — Exact edition identity

Diagnostics and player-facing rule/status surfaces now preserve the exact game edition (Red, Blue, Yellow, Gold or Silver) even when mechanics are shared by generation. NZR6 encodes that edition directly for future parity and feature-coverage analysis. Silver NUZ STATUS also receives the movement-assist scope repair exposed by the 2.5.66 runtime test.


## 2.5.66 — Silver status + recovery hardening

2.5.66 is the strict child of 2.5.65. Silver Setup and boot-to-bedroom are now runtime-confirmed, while the first Silver NUZ STATUS attempt crashed the launcher. The shared Gen 2 status screen is now exception-contained and reportable. Yellow Encounter Tracker recovery now validates a canonical string area key before any table access and treats optional live-Pokémon identity enrichment as best-effort so a valid manual assignment is not aborted by stale/provider metadata.


## Silver beta support

2.5.65 is the strict child of 2.5.64 and enables Pokémon Silver as a beta target on Gen1Recomp 0.2.11. Silver uses the same Gen 2 engine modules as Gold upstream, so Nuzlocke now routes Silver through the established Gold/Gen 2 adapters while preserving edition-specific names and a separate Silver Setup profile. Runtime parity is still required before individual Silver paths are promoted to PASS.

## 2.5.64 — Yellow recovery assignment hardening + UI fit cleanup

2.5.64 is a strict child of 2.5.63. Yellow runtime testing confirmed Dev RUN and VIEW REPORT now work and produced the first valid runtime NZR5 report. Encounter Tracker reassignment still exposed a guarded `table index is nil` failure when manually assigning Mankey to Route 1. This build canonicalizes/validates the selected area before any tracker table write, hardens adjacent nil provider metadata assumptions, and wraps/centers R/B/Y Dev/Recovery notice text so titles, details, codes, and footers stay inside the native 160x144 frame.

Runtime retest is required for manual encounter reassignment. Dev RUN/VIEW REPORT on Yellow 2.5.63 are protected runtime PASS.

# Nuzlocke 2.5.63

## 2.5.63 — Dev report fingerprint scope repair + recovery compatibility nil guards

2.5.63 is a strict child of 2.5.62 based directly on Yellow runtime report codes from Dev RUN, VIEW REPORT, and Encounter Tracker recovery editing. Dev report generation no longer references the compiler-scoped `reportCodeHash` helper after its scope ends; the deterministic fingerprint operation is exposed through the Dev surface while still in scope. Compatibility relationship inspection now treats a missing capability as neutral `compose` metadata instead of indexing provider/default tables with a nil key.

Runtime retest is required for Yellow Dev **VIEW REPORT**, **RUN + SAVE**, and Encounter Tracker reassignment.

# Nuzlocke 2.5.62

## 2.5.62 — Dev storage/API repair + recoverable editor errors + Gen1Recomp 0.2.11 audit

2.5.62 is a strict child of 2.5.61. Yellow runtime testing showed Dev RUN could error and appear frozen, VIEW REPORT could show `REPORT FAIL`, and Encounter Tracker recovery/reassignment could temporarily appear frozen after invalid changes. The Dev root cause was a bound `mod.storage` facade being called with an extra `game` argument; context/read/write/list/delete now use Gen1Recomp's documented bound signature. Dev and recovery-editor failures now remain inside their owning screen and clear with A/B/Start instead of pushing another modal TextBox.

Gen1Recomp **0.2.11** is source-audited as the current stable marker. Mod API 2 and the `>=0.1.86 <2.0.0` engine range remain unchanged. Silver is now a declared Nuzlocke beta target and shares the upstream Gen 2 engine path with Gold; individual Silver mechanics remain test-required until runtime-confirmed.

## 2.5.61 — runtime crash containment + Gen1Recomp 0.2.10 audit

2.5.61 is a strict child of 2.5.60 and is an explicitly authorized multi-fix runtime-hardening build. The Yellow legacy Encounter Tracker recovery/editor now rejects stale or impossible edits with player-paced feedback and wraps unexpected update/draw failures in a reportable `NZERR-2.5.61-xxxxx` message instead of allowing a mod-owned screen exception to escape. Dev Mode **RUN + SAVE** is likewise protected by an exception boundary and displays a report code on unexpected self-test/export failures.

Gen1Recomp **0.2.10** was source-audited. Mod API 2, the shared R/B/Y/Gold mod contract, Save Format 4 compatibility profile, and the Nuzlocke-owned seams remain compatible; the manifest range stays `>=0.1.86 <2.0.0`. Runtime smoke testing on 0.2.10 is still required.

# Nuzlocke 2.5.60

## 2.5.60 — Phase-B catalog golden/snapshot hardening

2.5.60 is a strict, behavior-preserving child of 2.5.59. It adds a deterministic semantic golden snapshot over all 96 `worldRuleCatalog` rows: each sorted key plus T1, T2, Kanto, and Johto text is covered, representing 576 tier/region resolutions. Missing keys/fields, renamed keys, or unintended dialogue drift now fail fast and appear in Dev diagnostics as `catalog_snapshot`; source whitespace/comments do not affect the snapshot.

# Nuzlocke 2.5.59

## 2.5.59 — Phase-B dead-fallback lint hardening

2.5.59 is a strict, behavior-preserving child of 2.5.58. Calls to `worldRuleTriplet()` / `worldRuleText()` can provide fallback dialogue only when the requested literal key is absent from `worldRuleCatalog`; supplying fallback text for an existing catalog key is now a fail-fast lint error because those arguments can never render. Existing dead fallback arguments were removed without changing runtime text.

## 2.5.58 — Phase-B cross-table invariant hardening

2.5.58 is a strict, behavior-preserving child of 2.5.57. Static progression tables that intentionally duplicate facts now validate their relationships at module load and in Dev assertions, preventing silent table drift from shipping.

## 2.5.57 — Phase-B active-guard hardening

2.5.57 is a strict, behavior-preserving child of 2.5.56. The trainer-reward/progression subsystem now carries executable source-level contracts that require `active()` on challenge-enforcement mutations and explicitly document the small set of persistence paths intentionally allowed while the master Nuzlocke switch is OFF. Module installation and Dev assertions both detect contract drift.

# Nuzlocke 2.5.56

## 2.5.56 — Phase-B rule coercion hardening

2.5.56 is a strict, behavior-preserving child of 2.5.55. Ordinary rule reads/writes now use the authoritative rule registration metadata for numeric bounds and compatibility coercion rather than parallel handwritten key dispatch ladders. Special migration/profile/provider behavior remains explicit.

## 2.5.55 — Phase-B rule-registration hardening

2.5.55 is a strict, behavior-preserving child of 2.5.54 and starts the reliability/architecture phase before additional gameplay fixes/features. The existing ordinary rule catalog is now the authoritative registration source for each rule's key, default, value type, numeric range, generation applicability, and UI metadata. `defaultRuleValue()` and the machine-readable Rule Registry consume those same records instead of duplicating the default map in another handwritten dispatch tree.

This is the first incremental step toward a full single-source configuration pipeline. Setter/coercion derivation and the remaining Phase-B lint/invariant gates stay intentionally separate for later child builds. Save Schema remains 4, Compatibility API remains 28, Diagnostics API remains 1, and the engine range remains `>=0.1.86 <2.0.0`.

## 2.5.54 — compiler-budget refactor and release-gate hardening

2.5.54 is a strict, behavior-preserving child of 2.5.53. It reduces the monolithic outer `main.lua` function from the Lua emergency edge to a measured **159 active locals** by scoping short-lived helper tables/closures and moving low-fanout helpers behind one private helper namespace. No gameplay rule, save schema, compatibility API, diagnostics format, F. TOKEN behavior, NUZ STATUS content, or Gold Random Starter logic is intentionally changed.

The exact packaged Lua source passes an actual `loadfile()`-equivalent compile check. A temporary 41-local sentinel also compiles while 42 does not, providing an enforceable regression probe that keeps the outer function below the project hard ceiling of 160 active locals.

# Nuzlocke 2.5.53

## 2.5.53 — Dev Report NZR5 load-safe repair

2.5.53 is built directly from the valid 2.5.51 package. It changes Dev Report compact-code handling only. New codes use `NZR5`, omit the five redundant health summary bits that could contradict the structured counters/status already in the same payload, and reconstruct those results during decode. Legacy `NZR4` codes remain decodable and retain contradiction detection. The rejected 2.5.52 package is not a lineage parent.

# Nuzlocke 2.5.51


## 2.5.51 — Gold Random Starter transaction repair

2.5.51 fixes one issue only: Gold Random Starter. The current transaction-safe `Vm.new` / `hooks.givePoke` design remains the owner of the actual Pokemon grant, but the exact Elm `givepoke` script row now arms a private one-shot per-VM starter intent before the native transaction runs. This restores the older working adapter's reliable Elm-starter identification without mutating shared generated script rows or rolling back the newer deterministic starter slate, preview, nickname, tracking, or native story flow. Gold runtime re-test is required.

## 2.5.50 — F. TOKEN area selection + confirmation
F. TOKEN rerolls are no longer tied to the player's current map. **REROLL ENCOUNTER** now opens an eligible failed-area picker sourced from the encounter tracker, and eligible FAILED rows can start the same reroll flow directly from **ENC TRACKER**. Before any token is spent, a dedicated confirmation page names the selected area and starts with **no YES/NO choice selected**; the player must deliberately move to YES and press A. B cancels without spending. The underlying reroll ledger mechanics are unchanged from the Yellow 2.5.49 runtime PASS.

The in-battle `DUPE:FREE` / `AREA:COUNT` badge is the independent **Encounter Indicator** setting, not legacy F. TOKEN code, so 2.5.50 leaves it unchanged.


## 2.5.49 — F. TOKEN native cursor
R/B/Y F. TOKEN spend/revive pages now use the native Gen 1 sideways selection cursor (`Theme.cursor`) instead of text `>` prefixes, matching established working Nuzlocke UI pages. The 2.5.48 full-page layout and mechanics are unchanged.


## 2.5.48 — F. TOKEN full-page UI + Gym Guide dialogue pacing
Yellow runtime testing showed the F. TOKEN selector still rendering in the lower-right and Gym Guide candy dialogue proceeding without explicit page acknowledgement. 2.5.48 moves the R/B/Y F. TOKEN/revive screens onto the same full 20x18 tile-page pattern used by working Nuzlocke UI pages, and adds explicit A/B page boundaries to the Nuzlocke-added Gym Guide candy dialogue.

## Historical 2.5.47

## 2.5.47 F. TOKEN R/B/Y state-ownership repair
Runtime testing on Yellow 2.5.46 confirmed that F. TOKEN still composited over the native USE POKEMON/item screen. 2.5.47 fixes the transition itself: the active R/B/Y Bag/use list is closed before Nuzlocke pushes its forgiveness selector, and both forgiveness screens are now declared in the same Nuzlocke presentation contract used by stabilized custom screens. Gold remains on its separate Gen 2 Pack/Chrome path. Runtime R/B/Y confirmation is required.

## 2.5.46 Gold Dev Mode menu repair
Gold runtime testing on 2.5.44 confirmed that enabling **Dev Mode** in NUZ RULES did not expose the **DEV** START-menu row. Gold constructs its native START list once per opening, while NUZ RULES is pushed on top of that existing menu. 2.5.46 refreshes only Nuzlocke's DEV row when the toggle changes and uses the same live config reader for diagnostics visibility. R/B/Y behavior is unchanged.

## 2.5.45 F. TOKEN R/B/Y presentation repair
Runtime testing on 2.5.44 confirmed that opening the F. TOKEN could partially composite the custom selector over the native item-use screen. 2.5.45 marks both F. TOKEN custom screens as protected classic 160x144 Nuzlocke-owned surfaces, matching the stabilized presentation contract used by NUZ RULES and ENC TRACKER. Gold remains on its native Gen 2 Chrome path.

This is a strict child of 2.5.44. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, and the canonical 15-file package structure are unchanged. R/B/Y runtime confirmation is required for REROLL ENCOUNTER, REVIVE POKEMON, and B cancel/back flows.

# Nuzlocke 2.5.44

Strict child of **2.5.43**. Parent SHA-256: `f64d044ad904e682ba05d9439e35200e4bbba2cfb5cef1d3f3137756ae0a0eb6`.

## 2.5.44 Dev Report consistency and layout repair

NZR4 Report Codes now derive redundant PASS/WARN bits for hook health, lifecycle duplicates, safe-stop writes, rule-effectiveness errors, and randomizer integrity directly from the structured counters/status values encoded later in the same code. The decoder exposes `consistent` plus per-section consistency flags, so a copied or legacy code that contradicts itself is detectable instead of silently producing a misleading summary.

The Dev Report code display now balances existing NZR4 hyphen groups across viewport-safe rows instead of greedily wrapping them, preventing tiny orphan fragments such as the trailing `D8` seen in the 2.5.43 R/B/Y report screenshot. The underlying NZR4 alphabet/layout remains v4.

Canonical provenance is also repaired: 2.5.44 records **2.5.43** and its exact package SHA-256 as its immediate parent. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, and the 15-file package structure are unchanged. Runtime confirmation of the Dev Report display is required.

---

# Nuzlocke 2.5.43

Strict child of **2.5.42**.

## 2.5.43 Gold pager state repair

Gold Nuzlocke battle-rule pagination no longer clears or advances the native `BattleState.queue`. The pager snapshots only the battle fields it temporarily owns (`phase`, `message`, and `messageTimer`) and restores those exact values after the final A/B-confirmed page. This preserves already-queued vanilla/other-mod battle messages and actions while retaining the player-paced text behavior introduced in 2.5.42.

Input lookup also accepts the active game/mod input object as a defensive compatibility fallback if the battle state's direct game reference is temporarily unavailable. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, and the 15-file package structure are unchanged. Gold runtime validation remains required.

---

# Nuzlocke 2.5.42

Strict child of **2.5.41**.

## 2.5.42 player-paced Nuzlocke text

Nuzlocke-authored gameplay dialogue must be player-paced: interrupted/denied actions stay visible until A/B, and text longer than the native two-line window requires an A/B press between pages. R/B/Y retains its existing `TextBox` / battle queue pagination. Gold battle-rule denials now use a Nuzlocke-owned two-line paginator instead of relying on `messageTimer` behavior or a single direct `self.message` assignment, keeping the rule stable across the supported engine range.

This pass covers the Gold battle Pack/item denial, No Catching denial, illegal encounter/catch denial, and exhausted Encounter Ball Limit text. Runtime validation is required in R/B/Y and Gold.

## 2.5.41 recent-change hardening

This build is a focused repair/documentation child of 2.5.40. **F. TOKEN revival** now respects a Party Size Limit that was lowered after a compatible system retained a dead Pokemon in the active party: if reviving in place would leave the party above the current cap, the Pokemon is moved to legal PC storage first; a full PC refuses without spending the token.

**Trade Evolutions** now follows Gen1Recomp's supported `evolution.check` trigger contract in both generations. The level-40 QoL path and Gold branch-preservation logic run only for `trigger.kind == "levelup"`; link, item, forced, preview, and unrelated hook contexts are left native.

Route Forgiveness semantics with Area Splits are now explicit: one F. TOKEN forgives the **current logical encounter slot as presently configured**. If disabled splits merge multiple failed physical subsections into that one slot, the failed rows projecting into that merged slot are all cleared so it genuinely reopens. Turning splits on later does not resurrect those forgiven failures.

Version/build titles are numeric-only from this build forward: **2.5.41**, with no DEV or RC suffix. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, file set, and engine range are unchanged. Runtime validation is still required for the repaired F. TOKEN and Trade Evolution paths.

## 2.5.40 F. TOKEN rework

2.5.40 replaced synthetic shop/automatic Route Forgiveness with a real carried **F. TOKEN**. It can be spent manually outside battle to reopen the current FAILED encounter slot or revive an exact archived Permadeath record at half HP. Tokens cannot be bought, sold, tossed, or given; Gym Leaders award them while Route Forgiveness is active. Revival uses legal party/PC placement and refuses without spending if no storage is available.

## 2.5.39 Trade Evolutions QoL

Trade Evolutions added a default-OFF QOL option for R/B/Y and Gold. Ordinary trade evolutions can occur on level-up at **level 40+**; Gold held-item trade evolutions retain and consume their required item, with branch preservation such as Slowpoke -> Slowking. Native link trades and Evolution Limits remain authoritative. 2.5.41 tightens this path to the supported level-up trigger contract.

# Nuzlocke 2.5.37-DEV

Strict child of **2.5.36-DEV** (`730f87424f8a4ebf926b6b570730a696394bed6ba2c42adc0453834972c5307b`). This is a bug-only reliability build.

## 2.5.37 recent-feature repairs

**Random Field Items** now protects Gen1Recomp's actual HM ids (`HM_CUT`, `HM_SURF`, `HM_WATERFALL`, etc.) and HM machine metadata. This closes the progression-lock risk where Gold's visible Ice Path HM07 could be randomized away. HMs remain vanilla authored pickups and never enter the replacement pool.

Gold PC traversal is now sparse-safe everywhere Nuzlocke scans storage. Gold only materializes individual box tables as they are used, so a missing Box 2 must not hide a real reserve in Box 3. Whiteout recovery, PC-only storage detection, legacy/provenance recovery, and gift/starter ownership scans now enumerate every existing numeric box rather than stopping at the first nil slot.

**PC-Only Catches** also preserve the pre-throw storage target. If the party has five members, the current Gold box is full, and another box has room, the caught Pokemon can fill party slot six temporarily and is then filed into that available box. The permanent PC LOCKED marker is applied only once storage succeeds.

Rule Lock now leaves Gold **Radio Nuzlocke** adjustable like other World Building/QoL/presentation controls. The SOLO loadout's menu description now correctly says **run-ending Blackout** rather than Whiteout. Save Schema remains 4, Compatibility API 28, Diagnostics API 1, and Mod API 2.

# Nuzlocke 2.5.36-DEV

Strict child of **2.5.35-DEV** (`f8540105bf2fc481aded340003df29b7c0adfd18311c8bcfd0b51bcc7750bcbf`). This is a compatibility/documentation audit build with no gameplay behavior changes.

## 2.5.36-DEV Gen1Recomp current-dev audit

- Re-audited the current Gen1Recomp `dev` head at **`def270f7c726ebd7bd87086ad90bc4a7b9622543`** while keeping the stable published compatibility marker at **0.2.7**. The engine remains Mod API 2 / save format 4 / ROM cache v5, and Nuzlocke's supported range remains **`>=0.1.86 <2.0.0`**.
- No required Nuzlocke gameplay adapter or enforcement rewrite was found. Recent upstream changes are additive or engine-owned.
- Gold's official read-only BattleAPI now exposes Ball inventory plus exact stock `catchChance` previews. Nuzlocke's existing optional `currentBattleSnapshot()` bridge consumes this automatically; rule enforcement remains on the existing capture transaction seams.
- Gold battle-party grid navigation now participates in the shared `ui.party.grid_navigation` hook; Nuzlocke does not claim that presentation/input seam.
- Android can return to the launcher and switch games in-process. Upstream resets the runtime hook/event buses during that transition; Nuzlocke's owner-aware wrappers are source-consistent, but cross-game hot-swap remains **RUNTIME TEST REQUIRED**.
- Corrected stale compatibility documentation that still described 0.2.1 as the current target/current source-audited engine. Historical 0.2.1 audit notes remain historical.

No Save Schema, Compatibility API, Diagnostics API, or Mod API bump.

## 2.5.35-DEV

Strict child of **2.5.34-DEV** (`d5cb2b305cdcf460b5ff7f4110185719742caa5360d21994fe943d2546d37d54`). This is a bug-only repair build for recently implemented features.

### Recent-feature repairs

- **Gold Random Starter transaction isolation:** accepting an Elm starter no longer mutates the shared generated `givepoke` script row. The native Gold `hooks.givePoke` transaction wrapper remains the single concrete-species replacement seam.
- **Stable three-ball slate cache:** opaque seeded starter-slate keys keep their semantic casing, so repeated previews reuse the same cached slate rather than rebuilding it because of key normalization. Legacy uppercase scoped keys are canonicalized on read.
- **Unlimited Bag Space QoL lock behavior:** Unlimited Bag Space stays editable when challenge rules are locked, consistent with the mod's QoL/presentation lock policy.

Runtime priorities: start multiple Gold New Games without restarting Gen1Recomp and confirm a prior randomized starter cannot contaminate the next run; inspect all three Elm previews repeatedly with a fixed seed; and confirm Unlimited Bag Space can still be changed after Rule Lock while challenge rules remain sealed.

## 2.5.34-DEV

Configurable Nuzlocke enforcement, tracking, variants, randomizer options, difficulty controls, World Building, compatibility adapters, and quality-of-life features for Pokémon Red/Blue/Yellow and beta Gold on Gen1Recomp.

This historical 2.5.34 DEV section describes the strict child of **2.5.33-DEV** and its runtime-validation status at that build. Save Schema remains **4**, Compatibility API is **28**, Diagnostics API remains **1**, Mod API remains **2**, and the supported engine range remains **>=0.1.86 <2.0.0**.

## 2.5.34-DEV Unlimited Bag Space QoL

- Adds **Unlimited Bag Space** under **QOL**, default **OFF**, for Red/Blue/Yellow and Gold.
- R/B/Y: ON removes the distinct-item slot ceiling from the normal Bag.
- Gold: ON removes distinct-item slot pressure from the ordinary **ITEM** and **BALL** pockets. **KEY ITEM** and **TM/HM** pocket capacities remain native.
- The native **99-per-item stack limit remains unchanged**, as do PC item storage, item legality/use rules, acquisition scripts, tossing, selling, and ordering.
- Turning the option OFF immediately restores the live engine/provider capacity. Items already carried are not deleted; new distinct-item slots are simply subject to capacity again.
- The implementation composes around the live `src.inventory.Bag.capacity` function rather than hard-coding vanilla capacity on the OFF path, so compatible bag-size providers retain ownership when this QoL is disabled.

Runtime validation is required in R/B/Y and Gold: fill beyond native distinct-slot limits with ON, toggle OFF while over capacity, verify existing items remain, and confirm a new distinct item is refused until capacity is available again.

## 2.5.33-DEV three-state movement QoL

- **Running Shoes:** OFF / HOLD B / ALWAYS. HOLD B preserves the historical behavior; ALWAYS gives the same 2x walking speed without holding B. Bike and Surf movement are unaffected by this row.
- **Fast Surf:** OFF / HOLD B / ALWAYS. HOLD B gives 2x player-controlled Surf speed while B is held; ALWAYS keeps that Surf speed active continuously.
- Both controls are ordinary left/right/A-cycle QoL settings in R/B/Y and Gold. They do not use the numeric-resource edit interaction.
- Existing Running Shoes ON saves migrate to HOLD B, so no established save silently changes from manual running to always-running.
- Surf start animations, Waterfall/scripted steps, fishing, biking, and other non-player-controlled movement stay native.

Runtime validation is required in both generations, especially HOLD B vs ALWAYS while walking/surfing and interactions with the optional QoL Toggles `run_hold_b` setting.






## 2.5.32-DEV Gold Random Starter slate hardening

- Elm's three starter balls are now generated as one deterministic slate in canonical CHIKORITA / CYNDAQUIL / TOTODILE order.
- The slate draws without replacement whenever another legal candidate exists, so seeded runs no longer allow accidental duplicate starter choices just because each ball was rolled independently.
- Preview order cannot affect the slate. The same seed/style produces the same three options regardless of which ball is inspected first.
- Elm POKEPIC/CRY presentation rewrites now use shallow copies for the one script-command dispatch instead of mutating the generated shared script row or operand table.
- The actual GIVEPOKE transaction still commits only the starter the player accepts, preserving the 2.5.30 native transaction repair and nickname flow.

## 2.5.31-DEV PC-aware Whiteout / Blackout recovery

The total-party-wipe behavior now matches the earlier intended model, with the PC-reserve condition from the latest feedback. **Whiteout ON** is the survivable option: after Permadeath bookkeeping settles, the run may continue only if at least one legal recovery Pokemon remains either in the party or in Box storage. If the party is empty but a legal Box reserve exists, the engine performs its normal loss/heal-point return and Nuzlocke tells the player to withdraw a reserve.

A reserve does **not** count if it is dead, an Egg, or permanently **PC LOCKED** by PC-Only Catches. If Whiteout ON has no eligible Pokemon left anywhere, it escalates to Blackout and the run ends. **Whiteout OFF** is always Blackout, even when boxed reserves exist. First Rival Mercy remains the one opening-battle exception.

Gold has an additional narrow recovery bridge: its native Bill's PC normally refuses to open with an empty party, so 2.5.31 relaxes only that refusal when Nuzlocke is active, Whiteout is ON, the party is empty, and at least one eligible Box reserve exists. PC-locked Pokemon remain impossible to withdraw or release. R/B/Y keeps its native PC path. Battle and field-poison wipes use the same recovery test.

Because 2.5.30 and earlier used the Whiteout boolean with the opposite internal meaning, existing saves are migrated once so the behavior they had selected does not silently flip. Fresh saves use the corrected semantics directly. HARDCORE, SOLO, and IRONMON remain destructive-on-wipe presets by selecting Whiteout OFF / Blackout. Save Schema remains 4, Compatibility API 28, Diagnostics API 1, and Mod API 2.

Runtime validation is required in both generations. The highest-value checks are: Whiteout ON + Permadeath ON + one ordinary boxed reserve (survive, empty party, PC accessible); repeat with only a PC-locked/Egg reserve (game over); Whiteout OFF with a legal boxed reserve (still game over); and First Rival Mercy (still survives independently).

## 2.5.30-DEV Gold Random Starter repair

Gold Random Starter is repaired at the native Gen 2 starter transaction. Runtime testing on Gold 2.5.22 showed the starter stayed vanilla with **Random Starter ON** while starter nickname enforcement still worked; because that random-starter grant path had not been intentionally changed afterward, 2.5.30 treats it as an inherited defect rather than another test-only question.

The earlier Gold adapter rewrote Elm's `script.command` `givepoke` row. 2.5.30 keeps that preview/tracking layer but adds a direct owner-aware wrapper around the Gen 2 VM's `hooks.givePoke` transaction. Only the first-party canonical Elm starter is eligible. The selected vanilla Ball and story/rival flags remain untouched; the species passed into native GivePoke is replaced with the persisted deterministic Random Starter choice. Native construction, OT/Pokedex mutation, held item, and nickname flow remain engine-owned.

Fresh NEW GAME also gets a narrow configuration handoff repair: if Gold has adopted the new save before the full Setup snapshot is committed, the Random Starter toggle, Starter Style, and seed are copied from the immutable staged profile into the new mod.save bucket before Elm's first preview/grant. External randomizer-provider ownership still wins. DEV SELF TEST now reports `gold_random_starter_transaction_gate`.

This is source/static validated and **Gold runtime TEST REQUIRED**. Use a fixed seed, verify the selected Elm Ball gives a different species than its vanilla starter, verify the same seed repeats the same result, and confirm the already-working mandatory starter nickname flow still works.


## 2.5.29-DEV Gold parity: Ball Per Encounter + starting resources

Gold now exposes **Ball Per Enc.** on the same OFF / 1 / 2 / 3 / 5 / 10 ladder already enforced by its battle-Pack adapter. No Catching continues to hide the row while all capture attempts are prohibited.

Gold NEW GAME Setup also has dedicated **Starting Money**, **Starting Poke Balls**, and **Starting Rare Candy** controls. They do not reuse the R/B/Y profile keys. Gold money follows its native six-digit 0-999999 wallet and defaults to 3000; Rare Candies go to bedroom PC storage and default to 0. Gold Starting Poke Balls are an **extra** 0-99 PC allotment: Gold's native 5-Ball story reward is left untouched, and the extra Balls are not released until the Mystery Egg has been returned to Elm, preserving the native pre-capture opening. Quick Start follows the same rule.

This is source/static validated and **Gold runtime TEST REQUIRED**, especially the normal-story and Quick Start Ball-release boundaries.

## 2.5.28-DEV PC-Only progression/completion catches

**PC-Only Catches** is a new default-OFF clause for players who want to complete the Pokedex or satisfy a story/progression capture requirement without turning a normally illegal Pokemon into a legal Nuzlocke teammate. When an ordinary capture would be refused by Type Locke, Static, town/overworld eligibility, Legendary/Mythical/Pseudo bans, Dupes/used-area state, or Maximum BST, this option may let the real capture finish and then immediately files that Pokemon in PC storage with a permanent **PC LOCKED** marker.

A PC-only catch never spends One Per Area or Failed Encounter state, never fills a Catch Draft lane, is omitted from the ordinary Encounter Tracker catch ledger, and does not make a later legal encounter a duplicate merely because it is stored. It cannot be withdrawn, moved from a box into the active party, or released. The lock lives on the Pokemon, so turning the option OFF later does not legalize an already locked catch.

Safety boundaries remain deliberate. Glitch/malformed-species safety is never bypassed. Party Size Limit by itself does not turn a legal encounter into a permanently locked catch. **No Catching** remains absolute for ordinary encounters; only a compatible source that explicitly marks a capture as progression-required *and* progression-exception-allowed may use the PC-only escape hatch. The mod also checks native storage capacity before allowing the exception, so it never intentionally creates an unboxable research-only catch. In Gold, a full party must have room in the currently selected Box because the native Ball transaction refuses before the throw when that Box is full.

Compatibility API remains 28; existing provider ownership does not change. Cooperative acquisition policy may add PC-lock metadata for an explicit progression-required exception, and the existing Party/PC policy refuses locked Pokemon entering the party or being released. Runtime validation is required in R/B/Y and Gold, including save/reload persistence and full-box behavior.


## 2.5.27-DEV Maximum BST presets

**Maximum BST** now offers a wider preset ladder: **OFF / 300 / 350 / 400 / 450 / 500 / 550 / 600 / 650 / 700**. The underlying restriction is unchanged: the selected value caps newly acquired catches, gifts, and trades, while mandatory starters remain progression-safe and unknown/incomplete modded stat schemas fail open.

Existing exact saved values remain intact. Older free-form thresholds still display as CUSTOM until changed; once the player adjusts Maximum BST, the control starts from the nearest preset and cycles through the expanded ladder.

This child does not change Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, randomizer outputs, loadout ownership, or the supported engine range. Runtime validation should cycle the new low/high endpoints in both directions and verify one over-cap acquisition is rejected.

## 2.5.26-DEV R/B/Y Stat Info layout

The R/B/Y **NUZ INFO → STAT INFO** page now uses the otherwise-empty middle of the native 160×144 surface for its value/DV/Stat EXP column. ATK/DEF/SPE/SPC values start farther left and receive a 14-glyph budget, large enough for the native worst-case `999 D15 E65535` shape without marquee scrolling. LEVEL/HP retain extra separation from their longer labels while also gaining width. Catch and Move page layouts are unchanged.

This is a presentation-only child: no rule values, randomizer results, save data, APIs, or engine compatibility contracts change. Runtime visual confirmation is required on R/B/Y.

## 2.5.25-DEV Random Field Items

**Random Field Items** is a new default-OFF Randomizer toggle for visible overworld item-ball pickups in R/B/Y and Gold. Ordinary pickup slots use their map/object identity plus the shared seed through a dedicated `FIELD_ITEMS` deterministic stream, so this option can be enabled without changing the seeded results of Random Starter, Random Encounters, or Random Learnsets.

Key/story items and HMs are protected: a protected authored pickup stays vanilla, and protected items are never chosen as replacements. Hidden items, NPC gifts, shops, fruit/apricorn trees, and other scripted rewards are outside this first implementation. Native bag-full retries, pickup disappearance/event flags, text, and sounds are preserved. Runtime validation is required in R/B/Y and Gold.


## 2.5.24-DEV remembered Rules/Setup position

2.5.24 completes the backlog item to remember Rules/Setup cursor and scroll position. When a player closes and reopens NUZ RULES or NEW GAME Setup during the same mod session, the screen returns to the same semantic row and visible scroll window instead of restarting at the first row. R/B/Y and Gold keep independent positions, and Setup remains independent from active-save Rules.

The remembered anchor uses stable rule/header identity rather than a raw row number. This keeps restoration conservative when collapsible sections or dependent Randomizer/Type Locke rows change the visible list. Navigation memory is UI-only and session-only: it is not written into gameplay saves or setup profiles and does not change Save Schema 4.

No rule defaults, loadouts, Compatibility API, Diagnostics API, Mod API, or engine range change. Runtime validation should cover reopen behavior on R/B/Y and Gold plus collapsed/dependent-row transitions.


## 2.5.23-DEV Yellow / fresh-New-Game correctness

2.5.23 responds directly to runtime testing of 2.5.22 on a fresh Yellow New Game. The test was stable overall but exposed four concrete failures: Random Starter fell back to Pikachu, the starter was left UNKNOWN/out of the Pallet Town log, No Mom Heal did not enforce, and Yellow's Oak Pallet catch demonstration did not skip.

The source audit traced those failures to two structural Lua-scope regressions and one staged-runtime phase that was defined but never executed. 2.5.23 restores the critical R/B/Y command-wrapper tail to its owning scope, executes late-runtime phase 2, gives fresh `save.created` its own lifecycle retries, and routes starter RNG through an explicitly exported shared helper. A conservative repair can restore opening-starter Pallet provenance for affected R/B/Y saves when the real starter flags/committed random choice make the identity unambiguous.

The development process is tightened at the same time: invariant and CI mutation gates now fail when a critical helper is referenced outside its owner scope, when a staged runtime phase is not executed, when the R/B/Y command installer loses its `give_pokemon`/heal resolver tail, or when fresh-New-Game lifecycle coverage is removed. Lua syntax compilation remains useful but is no longer treated as sufficient proof for these classes because Lua permits unresolved names to compile as globals.

Save Schema remains **4**, Compatibility API remains **28**, Diagnostics API remains **1**, Mod API remains **2**, and the engine range remains **>=0.1.86 <2.0.0**. Exact Yellow runtime re-test is required.


## 2.5.22-DEV kerning / seeded-RNG lifecycle consistency

2.5.22 closes two source-confirmed reliability gaps without changing current gameplay semantics. Gen 1 variable-width kerning now records exact wrapper-session identity on the persistent Font singleton, so a later Nuzlocke reload can safely remove only its own exact stale top-level wrapper and rebind the current session. Ambiguous legacy or foreign wrapper chains fail closed and request one fresh process instead of guessing.

Starter randomization now uses the same versioned deterministic hash helper as encounter and learnset randomization. With the current RNG algorithm version still at **1**, the hash input and seeded starter results remain unchanged; a future algorithm-version bump can no longer leave starter RNG silently pinned to v1. Current RNG status labels also derive from the shared version source.

Save Schema remains **4**, Compatibility API remains **28**, Diagnostics API remains **1**, Mod API remains **2**, and the engine range remains **>=0.1.86 <2.0.0**. Runtime reload/randomizer regression testing is still required.

## 2.5.21-DEV trainer identity consistency

2.5.21 centralizes trainer identity normalization for reward recognition and League progression. R/B/Y and Gold now use the same normalized trainer ID, class, and name evidence, including Gen 1 `oppClass`, generic provider class aliases, and Gold `trainer.classId` / `trainer.class`. This prevents a compatible trainer shape from being recognized by Gym rewards while being missed by Gym/E4/Champion progression bookkeeping.

No rule defaults, save representation, loadout behavior, Save Schema, Compatibility API, Diagnostics API, Mod API, or engine range changes. Runtime regression testing is still required.

## 2.5.20-DEV tracking / enforcement safety

2.5.20 separates three concepts that were previously easy to conflate: whether Nuzlocke-owned save data is safe to write, whether the Nuzlocke master switch is enabled, and whether challenge rules should be enforced in the current battle. Passive Gym/E4/Champion progression remains synchronized on a supported save even while the player temporarily turns Nuzlocke OFF, while rule consequences such as Failed Encounter, Forgiveness Tokens, trainer-money rewriting, and Permadeath cleanup remain inactive. Unsupported newer-schema saves remain read-only.

The battle finalizer now applies those policies explicitly, Forgiveness Tokens cannot appear/purchase/spend while enforcement is inactive or safe-stopped, Failed Encounter has both entry-point and write-site enforcement guards, and post-battle dead-party pruning now respects the same safe-stop. Local invariant tooling classifies these battle writers as PASSIVE_PROGRESS or RULE_ENFORCEMENT so a future handler cannot silently use the wrong guard. Save Schema remains **4**, Compatibility API remains **28**, Diagnostics API remains **1**, Mod API remains **2**, and the engine range remains **>=0.1.86 <2.0.0**.


## 2.5.19-DEV save-safety / API hardening

2.5.19 closes newer-schema read-only gaps found by the local invariant audit. R/B/Y and Gold randomized-starter repair paths now stop before touching save-backed tables when an unsupported newer schema is loaded; Pokémon identity lookup is genuinely read-only, while identity allocation/hydration refuses mutation in safe-stop mode. The public compatibility report now returns a defensive engine snapshot, and `engine_compat` is refreshed whenever Item Policy updates live engine-state diagnostics.

The Save Schema 4 descriptor now distinguishes migration-bookkeeping fields from current configuration/legacy inputs and reports per-role counts. The final `mod.save:set` barrier now uses owner/previous/wrapper session identity, Permanent Rule Seal reconciliation exits cleanly while safe-stopped, and the local invariant suite checks these protections. Save Schema remains **4**, Compatibility API remains **28**, Diagnostics API remains **1**, Mod API remains **2**, and the engine range remains **>=0.1.86 <2.0.0**.

## 2.5.18-DEV API/descriptor hardening

2.5.18 hardens the development/API infrastructure introduced in 2.5.17 without changing gameplay rules. Public Compatibility API metadata now uses defensive snapshots instead of aliasing Nuzlocke's internal relationship/ownership tables; dynamic mod-compat snapshots refresh after provider discovery. `getEffectiveRuleValue()` now falls back to the canonical rule default when no explicit fallback is supplied.

The Rule Registry records construction collisions instead of silently suppressing them, and the Save Schema 4 descriptor now documents the `hardcore_mode` / `elite_four_caps` compatibility mirrors plus migration-only legacy inputs. DEV SELF TEST no longer exposes the live capability-version table by reference. The local invariant gate now checks these contracts and ignores historical non-authoritative boolean markers while still rejecting authoritative boolean-only wrapper guards. Save Schema remains **4**, Compatibility API remains **28**, Diagnostics API remains **1**, Mod API remains **2**, and the engine range remains **>=0.1.86 <2.0.0**.

## 2.5.17-DEV development-quality infrastructure

2.5.17 adds machine-readable build provenance, a derived Rule Registry, a Save Schema 4 configuration descriptor, centralized owner-aware direct-wrapper installation, and stronger Dev SELF TEST contract checks. These surfaces are diagnostic/development infrastructure: challenge rules, explicit saved choices, loadouts, encounter behavior, and gameplay defaults intentionally remain identical to 2.5.16.

Compatibility API is intentionally advanced from **27 to 28** because companion mods can now use public `capability_versions` / `getCapabilityVersion(capability)` negotiation. Existing API-27 capability names and meanings remain compatible and all current capability contract versions begin at 1. Diagnostics API remains 1 and Save Schema remains 4. Repository CI/test files are development-only and excluded from the canonical 15-file player package.

## 2.5.16-DEV API/default/lifecycle diagnostics pass

2.5.16 aligns the public `ruleActive()` compatibility helper with the same canonical missing-key defaults used by Setup, NUZ RULES, and enforcement. A missing default-ON rule can no longer be reported OFF to a compatible consumer. Remaining `locke_type` read/verification fallbacks now use the canonical NUZLOCKE default rather than historical CUSTOM/0 values; explicit saved loadouts are unchanged.

Direct-wrapper lifecycle checks are tightened for automatic default names, Gold nickname/Mart/gambling enforcement, the R/B/Y Permadeath bundle, QoL Toggles AUTO-REPEL, and Wilds of Kanto's paired pre/post capture adapters. Wilds now treats both `_resolveCapture` and `giveCaughtPokemon` as one ownership contract, preventing one half from silently going stale. Dev hook-health reporting now covers substantially more catch, death, poison, party-size, Gold, and optional-compatibility seams. No public return shape, persisted representation, API number, or engine range changed.


## 2.5.15-DEV reliability / lifecycle pass

2.5.15 fixes four high-confidence defects found in the 2.5.14 self-audit. Overworld poison wipes now respect **Whiteout** independently of Permadeath in both R/B/Y and Gold: the engine keeps its native poison-faint/blackout text, but Nuzlocke intercepts the final heal-point/spawn warp and performs the run-ending save deletion/title flow instead. Gold **No Escape** now resolves the live game through the shared current-game path rather than requiring the Gen 1-only `battle.game` field.

New-game snapshot commit now explicitly persists `locke_type` before verifying it, preventing a fully applied rule set from keeping an older loadout label or repeatedly failing verification. The remaining high-value direct wrappers for Party Size/PC withdrawal, Gold No Day Care, Gold battle Whiteout finish, Gold Headbutt tracking, and Gold forgiveness-token mart stock now use owner/previous/wrapper session metadata instead of trusting boolean-only install markers. No rule defaults, provider ownership, Save Schema, Compatibility API, or engine range changed.

## 2.5.14-DEV bug-fixing / lifecycle pass

2.5.14 repairs the R/B/Y starter/gift transaction's save-context ordering, routes missing core encounter/acquisition keys through the same canonical defaults used by Setup/NUZ RULES, and upgrades older critical catch/Permadeath direct wrappers from boolean-only install markers to owner-aware session records. Gold's capture wrapper receives the same lifecycle protection, and Pokégear World Building presentation now shares the canonical T1 fallback. Existing explicit rule saves are never rewritten.

The 0.2.7 TimeFishGroups linkage was reviewed and intentionally left alone: row-local day/night slots are the engine's authoritative value when present, while `timeFishGroups` is a fallback.

## 2.5.13-DEV field-poison Permadeath repair

2.5.13 closes a source-confirmed Permadeath gap shared by R/B/Y and Gold: overworld poison faints happen outside the battle faint lifecycle, so the existing battle-only death adapters could miss them. A field-poison faint can now be recorded in the normal Nuzlocke death/history projection and the fainted Pokémon is pruned from the live party before a later native blackout heal can restore it.

The repair deliberately leaves Gen1Recomp's native poison timing, poison-faint happiness/text, whiteout decision, heal/warp flow, and Nuzlocke Whiteout Clause ownership unchanged. Permadeath OFF and Nuzlocke OFF remain vanilla. The new direct wrappers are session-owner aware so a mod reload can replace its own stale wrapper without stacking duplicate death bookkeeping. Runtime confirmation is required on at least one R/B/Y game and Gold.

## 2.5.12-DEV Gen1Recomp 0.2.7 compatibility completion

2.5.12 completes a fresh source audit of the published Gen1Recomp **0.2.7** release. The release adds Gold time-dependent fishing (`TimeFishGroups`) to the shared encounters registry and includes renderer/audio/platform fixes that do not require Nuzlocke ownership changes.

One Nuzlocke compatibility defect was confirmed: the public effective/final encounter-registry facade still returned only `game.data.encounters`, while Gold's merged shared `encounters` registry lives at `game.data.gen2Encounters`. Gameplay randomization already used the Gold table, but compatible encounter-information consumers such as DexNav/guide/provider integrations could receive nil from Nuzlocke's public facade. The facade and registry description now resolve `gen2Encounters` first with the Gen 1 table as fallback. Randomizer slot selection, reveal policy, save data, and encounter reroll behavior are unchanged. Runtime confirmation on Gold/0.2.7 is still required.


## 2.5.11-DEV World Building T1 default completion

2.5.11 completes the 2.5.4 change that made **World Building T1** the canonical fresh/default setting. The setup/default-rule model already selected T1, but the live flavor resolver still used the historical T3 fallback when no value was stored, and the rule description still called T3 recommended.

The live resolver and configuration-value fallback now both use the same canonical `defaultRuleValue("world_building_tier")` source, and the rule copy says **DEFAULT: TIER 1**. Existing explicit OFF/T1/T2/T3 save values are preserved; this does not migrate or overwrite a player's chosen tier.


## 2.5.10-DEV tracker / Pokégear UI follow-up

2.5.10 is a narrow presentation child of 2.5.9. Gold Pokégear **NUZ → RULES** now pages in true four-row blocks, including a final partial page, shows a compact `RULES x/y` position indicator, and advertises `A:MORE` when additional rules exist.

**ENC TRACKER** now shows **NO ENTRIES YET** when the current LOG/MAP data set is genuinely empty. The Modern UI adapter keeps the real entry count at zero and does not treat the placeholder as a real encounter row; native R/B/Y and Gold tracker surfaces show the same translated empty-state message. No encounter, save, rule, or provider semantics changed.

## 2.5.9-DEV Yellow setup follow-up

Yellow 2.5.8 runtime testing confirmed that fresh **Shiny Clause** now defaults to **OFF / 0** and Type Locke can be edited in NUZ RULES without the previous update error. Saving the NEW GAME setup still failed, however, because setup/profile code referenced the Type Locke slot-index table outside the lexical block that owns it.

2.5.9 routes every later setup/profile Type Locke slot lookup through lifecycle-stable exported accessors and also repairs the same out-of-scope key-table use in the Gold status summary. The loadout warning is now a true scrollable review: UP/DOWN walks through every loadout-owned rule change instead of replacing undisplayed rows with `+N MORE`; LEFT/RIGHT still chooses APPLY/CANCEL and B still cancels with no mutation.

All Nuzlocke-owned setup/rules/status error dialogs now pre-wrap into explicit two-line pages, so diagnostic text waits for manual A/B input rather than scrolling past automatically. Menu organization now places **GAME DIFFICULTY**, then **BATTLE MECHANICS**, immediately above **AREA SPLITS**.

A Gen1Recomp 0.2.7 source audit also cleared a suspected Gold First Rival Mercy asymmetry: Cherrygrove uses `BATTLETYPE_CANLOSE`, which intentionally leaves the losing starter at 0 HP until the continuing rival script runs its own `HealParty`. Nuzlocke should suppress death/Whiteout bookkeeping there but should not inject the R/B/Y temporary 1-HP bridge.

## Highlights

- In-game **NUZ RULES** with collapsible sections, preset/loadout support, and live rule changes.
- **ENC TRACKER / Area Guide** with encounter state, catch provenance, deaths, area splits, and map/status integration.
- Core Nuzlocke rules, Dupes/FAMILY modes, finite or unlimited Shiny Clause, nickname enforcement, gifts/trades, static encounter controls, and failed-encounter handling.
- Hardcore restrictions for healing, battle items, PP items, TMs, Rare Candy, shops, Centers, Mom healing, escape, Repels, fishing, travel, lock-ins, party size, Gym team size, and more.
- Type Locke from MONO through HEXA with Catch Draft and a stable RANDOM selector.
- Built-in Random Starter, Random Encounters, Random Field Items, Random Learnsets, seed control, balance/generation selectors, and OPEN/BLIND information policy.
- Encounter Ball Limit: OFF / 1 / 2 / 3 / 5 / 10 legal Ball throws per eligible encounter.
- Difficulty profiles, level caps, Badge Boost control, stat EXP/IV options, Maximum BST, Legendary/Mythical/Pseudo restrictions, Physical/Special Split, and related challenge controls.
- New-game setup options including starting money, Balls, Rare Candies, PC supplies, intro/tutorial skips, default names, running shoes, and Quick Nuzlocke Start.
- Compatibility/provider APIs for companion mods, merged species metadata, encounter providers, trainer providers, presentation mods, localization mods, and randomizers.
- Dev Mode with self-test, hook/lifecycle diagnostics, storage diagnostics, rule-effectiveness checks, randomizer integrity, and compact **NZR4 Report Codes**.

## Important 2.5.x candidate fixes

The 2.4.94–2.4.100 stabilization line repaired several user-visible regressions and configuration-plumbing defects that are included here:

- R/B/Y Mom-heal command wrappers now verify their live bindings before declaring themselves healthy.
- Field-item rejection messages such as **No Field Heal** and **No Rare Candy** use readable, player-paced dialogue pages.
- Randomized starters retain Pallet Town provenance in Tracker/map even when the selected species is not a vanilla starter.
- Legacy compact mod IDs such as `CatchHelper` are recognized by automatic compatibility hints.
- Shiny Clause and Encounter Ball Limit numeric setters persist correctly.
- Encounter Ball Limit now has complete default/read/write/display plumbing.
- Randomizer Info Policy now displays the stored OPEN INFO / BLIND INFO value correctly.
- Dev Mode's Species Facts health check now points at the real `getSpeciesFacts` resolver instead of an obsolete symbol.
- Report Codes now encode the full semantic version and therefore remain valid across the 2.4.x → 2.5.0 boundary.
- Public exported `build` markers now follow the authoritative current build instead of retaining old implementation-version literals.

## Installation / update

Install the package through Gen1Recomp's normal mod workflow. Existing supported Nuzlocke saves migrate through the same ordered Save Schema 4 pipeline; no schema bump is required for 2.5.16-DEV.

If an older build opens a save written by a future Nuzlocke schema, downgrade safety pauses Nuzlocke writes rather than interpreting unknown save data.

## Runtime confidence

Recent user runtime testing on Pokémon Yellow confirmed working enforcement for No Field Heal with Potion and exposed the message-pacing, randomized-starter provenance, Mom-heal, and related defects repaired in the stabilization line. Some combinations—especially Gold parity and third-party mod combinations—remain explicitly tracked as runtime retests rather than being claimed from static analysis.

## Known/WIP

**Permanent Rule Seal** and **Wonderlocke** remain intentionally WIP-disabled. Gold support remains beta and should be treated as requiring broader runtime coverage than R/B/Y.

## Credits

Original mod by **bryanthaboi**. Continued development and release maintenance by **Stone696**.


## Release status

**2.5.10-DEV is a runtime repair candidate, not a public release.** 2.5.0 was never published. Continue validation before any 2.5.x publication.

## 2.5.2-DEV engine compatibility
The current **published-release** Gen1Recomp audit profile is **0.2.7**. In 2.5.36, the moving `dev` branch was additionally source-audited at **`def270f7c726ebd7bd87086ad90bc4a7b9622543`** without finding a required Nuzlocke enforcement rewrite. The supported engine range remains `>=0.1.86 <2.0.0`; the moving dev SHA is documented separately and does not replace the stable 0.2.7 release marker.

## 2.5.3-DEV menu organization
GAME DIFFICULTY and BATTLE MECHANICS now appear above GENERAL. No Catching and Ball Per Enc. are grouped under BATTLE ITEMS. Ball Per Enc. is shown only when catching is allowed and defaults to OFF (vanilla unlimited throws).

## 2.5.8-DEV Yellow rules/setup follow-up
Yellow 2.5.7 runtime testing confirmed two remaining UI/update defects: the loadout warning rows could run through the modal border, and changing Type Locke could still fall into the generic “Please report this text” update error. 2.5.8 keeps the confirmation on the native 160x144 surface with bounded/marquee change rows and routes Type Locke edits through lifecycle-stable slot/default accessors instead of relying on a stale local table reference.

Fresh/new configuration defaults now set **Shiny Clause to OFF / 0**; existing saves and staged profiles keep their explicit stored value. **Route Forgiveness** is now listed under **GENERAL** instead of CLAUSES with no gameplay semantic change. Runtime confirmation is still required.

## 2.5.7-DEV Dev Report presentation repair
Blue 2.5.6 runtime testing confirms **DEV TOOLS -> VIEW REPORT** no longer crashes when reopening a saved report across a fresh game session. The report and Storage Info pages still overflowed the native R/B/Y viewport: long NZR4 codes, playthrough IDs, storage keys, and other unbroken identifiers could extend off-screen. 2.5.7 adds Dev-only hard wrapping, uses a 16-character-safe R/B/Y content width, and renders the NZR4 value under a dedicated **REPORT CODE:** label in hyphen-grouped viewport-safe lines. This is a presentation repair only; report-code encoding/decoding and diagnostic payload semantics are unchanged. Runtime layout confirmation is required.

The shared 2.5.6 NUZ RULES edit crash repair still needs runtime confirmation. The loadout-change warning popup remains a separate known Blue setup UI issue and is not changed by 2.5.7.

## 2.5.6-DEV runtime repair status
Blue 2.5.5 runtime testing confirmed a shared NUZ RULES edit-path crash across multiple toggles and a DEV TOOLS -> VIEW REPORT crash. 2.5.6 hardened those two paths and removed the pseudo-bold duplicate draw from the MOD COMPAT left rule-name column. The saved-report VIEW REPORT crash repair now has Blue runtime PASS evidence across a full game restart; the shared NUZ RULES edit repair still needs runtime confirmation. The 2.5.5 opening-sequence repair is carried forward unchanged and remains runtime TEST REQUIRED.

## 2.5.5-DEV opening repair carried forward
The Blue opening-sequence repair candidate targets randomized starter nickname enforcement, Pallet Town provenance, and native First Rival Mercy loss continuation. None of those items is promoted to PASS by 2.5.7; re-test them from a fresh Blue save.

## 2.5.4-DEV rules cleanup
World Building now defaults to T1. Cap messages use one fixed once-per-battle policy. Solo Only has been retired: use Party Size Limit = 1 for Solo runs.
