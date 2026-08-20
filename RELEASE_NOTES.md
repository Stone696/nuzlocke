# Nuzlocke 2.6.0 — Release

2.6.0 promotes the current 2.5.x development line to a release build. The only new player-facing organization change is that **PC Catches** now appears first in the **QOL** section instead of under CLAUSES, making the progression/completion capture option easier to find. Its behavior is unchanged.

This release includes the recent reliability work from the 2.5.x line: recoverable migration infrastructure and correct migration dry-run table equality, incremental `main.lua` modularization, Compatibility API 29 / Gen1Recomp 0.2.14 audit coverage, completed Run History catch/death/F. TOKEN producers, and per-death-occurrence Run History deduplication.

# Nuzlocke 2.5.92 — Run History death-occurrence dedupe

Run History deaths are now idempotent per committed faint. The three authoritative death paths persist an occurrence counter on the Pokémon before archival/removal, and `recordDeath` uses Pokémon identity plus that occurrence as its dedupe key. This avoids duplicate journal rows if the same death producer is retried or re-entered, while still allowing a revived Pokémon to die again later and produce a distinct event. No Run History API/storage revision, Save Schema change, or gameplay behavior change is required.

# Nuzlocke 2.5.91 — migration shadow diff correctness

Fixes false-positive migration dry-run changes for table-valued save keys. Lua compares tables by identity, while the shadow store intentionally copies before/after values, so identical table contents previously appeared changed. 2.5.91 uses recursive structural equality for serialized save values instead. No gameplay or save-schema behavior changes.

# Nuzlocke 2.5.90 — targeted acquisition-catalog modularization

This architecture-only release moves the static version-aware vanilla Gift Pokémon / in-game Trade source tables and their lookup helpers out of `main.lua` into `acquisition_catalog.lua`. The transaction hooks and challenge enforcement that use those helpers remain untouched. No intended gameplay or UI behavior changes.

# Nuzlocke 2.5.89 — DEV report modularization

This release is an architecture-only child of 2.5.88. The DEV REPORT/NZR6 diagnostic surface now lives in `dev_report.lua` instead of the main entry chunk. Report Codes, stored self-tests, diagnostic lifecycle breadcrumbs, public `nuzlocke_dev` functions, and player-facing DEV REPORT behavior are intended to remain identical.

This reduces `main.lua` compiler/load pressure without changing gameplay. A focused runtime boot and DEV REPORT smoke test is required.

# Nuzlocke 2.5.88 — UI navigation QoL

Nuzlocke-owned menus are less repetitive to use. ENC TRACKER reopens on the tab/row you left, MOD COMPAT remembers its selected row and detail page, and DEV REPORT/Dev Tools remembers its cursor/report scroll for the current mod session. NUZ RULES/Setup keeps its existing semantic position and collapsed-section memory. These preferences are UI-only and are not written into challenge/save state.

The classic MOD COMPAT detail area also now shows only two wrapped help lines per detail page, reserving a clean bottom row for `SELECT:INFO` / detail-page indication instead of crowding the footer.

# Nuzlocke 2.5.87 — Compatibility API cleanup

The 2.5.86 Encounter Tracker marker experiment has been reverted completely. ENC TRACKER rendering is restored to the exact pre-marker 2.5.85 behavior, and graphical status symbols are returned to the backlog until a genuine supported glyph/icon implementation is available.

Compatibility API is now **29**. This is an additive compatibility/introspection revision: 0.2.12/0.2.13/0.2.14 engine profiles are now present, `getEngineProfile()` and `getCompatibilitySummary()` expose stable read-only metadata, capability-version lookup normalizes common case/separator differences, and Public Interop can return sorted read-only provider inventories. Release Safety also fails its static contract if the selected audited engine profile is missing. No Mod API, Save Schema, gameplay rule, Random Starter, Run History, or supported engine-range change is made.

# Nuzlocke 2.5.86 — Encounter Tracker status markers

ENC TRACKER results are now easier to scan at a glance. Each area/result uses a compact, font-safe marker plus an explicit text label: `O CAUGHT`, `X FAILED`, `- OPEN`, `* SHINY`, or `X DEAD`. The wording remains visible rather than relying on symbols alone, and the same semantics are used across R/B/Y, Gold/Silver, and Modern UI presentation. No encounter rules or saved state changed.

# Nuzlocke 2.5.85 — Run History producer completion

This strict child of 2.5.84 finishes the initial Run History v1 producer wiring. Ordinary successful catches now enter the chronology at the settled `pokemon.caught` transaction after Nuzlocke tracker/area registration. Starter/gift/trade/progression catches continue to use their existing dedicated producers.

Permadeath producer coverage was audited rather than rewritten: R/B/Y battle deaths, shared field-poison deaths, and Gold/Silver battle deaths already append at their authoritative committed death paths. F. TOKEN history is now symmetrical: Gym Leader rewards append `forgiveness.awarded` after the permanent reward ledger/token update, and successful area/revive spends append `forgiveness.used` with the remaining token balance. Duplicate Gym-finalization callbacks cannot create duplicate award rows because the semantic Leader key is used for both the reward ledger and Run History dedupe.

No journal/storage/API/schema bump is needed. Run History API stays **1**, Save Schema **4**, Compatibility API **28**, Diagnostics API **1**, Mod API **2**, and the Gen1Recomp range remains `>=0.1.86 <2.0.0` with 0.2.14 exact-runtime boot/DEV REPORT PASS. Static parsing and dedicated Gen 1/Gen 2 producer harnesses pass; gameplay producer verification remains TEST REQUIRED.

# Nuzlocke 2.5.84

## Random Starter cache dedup fix

2.5.84 is a strict child of 2.5.83 and fixes **RS-CACHE-DEDUP-001**. In unseeded Random Starter runs, the legacy distinct-choice helper previously scanned every value in the shared starter-choice cache. Because scoped seed/style cache rows also contain valid species values, stale scoped entries could be mistaken for already-selected starter choices and unnecessarily remove species from the current unseeded pool.

The scan now considers only canonical bare per-starter mirror entries. Scoped cache keys and internal marker rows are ignored. Seeded deterministic selection, the Gold/Silver three-ball slate, preview identity, and starter award behavior are unchanged.

2.5.83 has also been runtime-confirmed on Gen1Recomp **0.2.14**: the mod loaded and DEV REPORT rendered normally.

# Previous release — 2.5.83

## Gen1Recomp 0.2.14 audit-only pass

2.5.83 is a strict child of 2.5.82. The published 0.2.13→0.2.14 engine delta was reviewed and contains no mod-facing Lua/loader/API/gameplay contract change: upstream changes are limited to Android release packaging and iOS app-repository metadata. Nuzlocke therefore advances its audited engine marker to **0.2.14** without changing Mod API 2, the `>=0.1.86 <2.0.0` engine range, compatibility providers, gameplay hooks, save behavior, or modularization.

The 2.5.82 boot/DEV REPORT runtime PASS remains protected. Exact 0.2.14 boot confirmation is the only focused runtime check requested for this child.

# Previous release — 2.5.82

- Strict child of 2.5.81 (`3d8cfaa0acaab7d55efd8324ef82f23f091a1f264f69ec7418dbc36bc9ac6fdf`).
- Extracts the Public Interop / Capability API into `public_interop.lua`.
- Keeps dynamic game/save lifecycle state behind getters; no public compatibility contract changes.
- `main.lua` reduced from 37,138 to 35,772 lines.
- Player package grows from 21 to 22 files.
- Runtime test required: boot/load plus MOD COMPAT/provider surface smoke test.

# Nuzlocke 2.5.81


## Rule catalog modularization

The next behavior-preserving modularization step moves the large rules/settings metadata catalog into `rule_catalog.lua`. The new module owns the same rule records and preset/fallback tables previously constructed inline in `main.lua`; callers still receive the same objects through the same established names and exports. No rule behavior, save key, default, API version, or Random Starter path changes.

`main.lua` is reduced from 37,417 to 37,138 lines, moving roughly 56 KB of source out of the monolithic entry file.

## Runtime evidence carried forward

2.5.80 successfully loaded on Gen1Recomp 0.2.13 in Gold. The DEV REPORT opened, and Elm's Random Starter displayed a randomized starter picture and awarded a randomized starter. Gold's Gen 2 preview repair is therefore protected as runtime PASS; Silver remains independently pending.

## 0.2.13 compatibility and boot recovery

Release Safety package-source introspection is now fail-soft. An engine that does not expose a development-time source read can report a warning without preventing Nuzlocke from loading. The audited Gen1Recomp marker advances to **0.2.13**; Mod API 2 and the supported engine range are unchanged.

## First modularization tranche

`run_history.lua`, `release_safety.lua`, `dev_diagnostics.lua`, and `save_migration.lua` isolate four architecture surfaces from the entry file. This is intentionally incremental: the migration transaction coordinator stays in `main.lua` until exact-engine historical-save tests protect a larger extraction.

## Stadium Prize provenance

Cooperative transfer/import mods can mark a Pokémon through `mod.exports.nuzlocke_acquisition_provenance.mark(mon, origin)`. The canonical source is `stadium_prize`, displayed as **STADIUM PRIZE**; optional origins are `stadium_1` and `stadium_2`. No fake Stadium map location is created.

## Johto Random Starter native preview repair

2.5.79 keeps the existing Gold/Silver Random Starter grant transaction and deterministic three-Ball slate, while adding a native portrait/cry fallback at the Gen 2 VM callback boundary. If the earlier script-command preview intent is absent, the native callback can still recognize Elm's starter preview from the live map/party/species context and render the same randomized choice. The new Dev health detail records whether the latest preview used the script intent, native fallback, or vanilla path.

R/B/Y Random Starter behavior is unchanged. Gold and Silver exact runtime confirmation remains required.

## Save/migration integrity foundation

2.5.78 hardens the existing Save Schema 4 migration path without changing player rules or bumping the schema. Numbered schema migrators now run against a shadow save first, producing a deterministic write set before any live mutation occurs. A write-ahead journal records pre/post values, commits the schema marker last, and supports recovery after an interrupted migration.

Before a numbered schema recovery/transition, the mod also creates a verified three-deep Nuzlocke-owned whole-save snapshot rotation using Gen1Recomp's engine-owned persistence path. These snapshots are separate from and do not overwrite the engine's `.bak`/`.tmp` files. New internal/development diagnostics include a non-mutating pending-migration preview, migration/backup status report, and structural transaction audit integrated into the Release Safety Framework. A failed migration/recovery now pauses Nuzlocke writes and rule enforcement under a distinct `migration_error` reason until a later load can recover safely. The transaction record is optional bookkeeping under schema 4 and is removed after clean completion. Semantic/reconstruction/projection upgrade phases are still ordered by the existing coordinator but are not yet transactional.

No Compatibility API, Diagnostics API, Run History API, Mod API, engine range, or supported-game declaration changes.

## Release Safety Framework automation

2.5.77 is a strict child of 2.5.76. It adds one executable, read-only release-safety runner that aggregates existing static contracts and fails module load when a protected release invariant regresses. It does not change gameplay rules, save schema, Compatibility API, Diagnostics API, Run History API, or the supported engine range.

The runner currently checks:

- canonical rule-default audit;
- rule-registry descriptor integrity;
- Save Schema descriptor integrity;
- dead-fallback source lint;
- world-rule catalog semantic snapshot;
- cross-table invariants;
- trainer-reward `active()` guard contract;
- immediate-parent build provenance;
- Compatibility API capability-version coverage;
- availability of required package-local Lua/card sources.

The same aggregate result is surfaced through Dev self-test. This is static/release evidence only and does not replace exact-edition runtime testing.

## Public documentation hygiene

2.5.76 is a strict child of 2.5.75 and intentionally makes **no gameplay changes**. Player-package documentation was sanitized so release notes, changelogs, guides, compatibility/API notes, and confidence records contain only durable project facts and no transient internal-coordination provenance. Save Schema remains 4, Compatibility API remains 28, Diagnostics API remains 1, Run History API remains 1, and the supported Gen1Recomp range remains `>=0.1.86 <2.0.0`.


## Process/review workflow consolidation

2.5.75 is a strict child of 2.5.74 and intentionally makes **no gameplay changes**. `main.lua` differs only in version/provenance metadata, and `manifest.json` advances to 2.5.75. Save Schema remains 4, Compatibility API remains 28, Diagnostics API remains 1, Run History API remains 1, and the supported Gen1Recomp range remains `>=0.1.86 <2.0.0` with 0.2.12 as the latest stable audited release.

### Development-process changes

The project now formally requires:

- a fixed review checklist covering recurring bug shapes;
- vertical-slice reviews for rules/features rather than isolated-file review alone;
- one-line risk statements for new features/fixes;
- pre-ship review before DEV/release handoff;
- a single Open Questions ledger;
- explicit timeboxes and stopping rules for exploratory review;
- separation of finding-only and fix passes when risk warrants it;
- a structured Bug & Investigation Tracker;
- a consistent severity/impact rubric;
- a proposed regression test/assertion with every bug fix;
- an Unreviewed Surface ledger;
- broad-skim then deep-dive two-pass review;
- a Cleared Investigation / false-positive ledger;
- formal brainstorm intake and triage;
- versioned review summaries;
- explicit brainstorm/audit/fix/runtime/release modes;
- a “why wasn’t this caught earlier?” retro for regressions;
- a Definition of Done checklist for each rule/feature;
- periodic cold-read reviews.

These are process controls only; they do not change player-visible behavior.

### Current evidence carried forward

- **Blue Random Starter:** 2.5.71 runtime PASS for randomized pre-selection portraits; protected.
- **Gold/Silver Random Starter:** randomized award path works, but Elm pre-selection portrait/cry parity remains an open runtime defect.
- **Run History v1:** static/harness PASS; gameplay producers still require exact-edition runtime validation.
- **Silver exact-edition diagnostics:** NZR6 exact `silver` identity runtime PASS on 2.5.67.
- **Yellow Encounter Tracker reassignment:** Mankey -> Route 1 -> wild runtime PASS on 2.5.66.

### No tree/API/schema changes

- Player package: 15 files.
- No new modules/files.
- Save Schema: 4.
- Compatibility API: 28 (`compatible_from = 10`).
- Diagnostics API: 1.
- Run History API: 1.
- Gen1Recomp Mod API: 2.
