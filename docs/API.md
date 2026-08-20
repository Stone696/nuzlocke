# 2.6.0 API note

No public API or save-schema revision. Compatibility API remains **29** (`compatible_from = 10`), Diagnostics API **1**, Run History API **1**, Save Schema **4**, and Gen1Recomp Mod API **2**. Moving `progression_pc_catches` to the top of QOL changes only menu categorization/order; its rule key and persisted representation are unchanged.

# 2.5.92 API note

Run History API remains **1** and storage remains v1. `pokemon.died` rows can now include scalar `deathSequence`, and the built-in death producer derives an internal dedupe key `death:<pokemonId>:<deathSequence>` when both values exist. This is additive and backward-compatible; event kind names and consumer functions are unchanged.

# 2.5.91 API note

No public API version changes. Internal migration-shadow `changes()` now uses structural value equality for table-shaped save data so dry-run output reports semantic changes rather than copied-table identity changes.

# 2.5.90 API note

No public API version changes. The existing acquisition-source helper functions retain their names and semantics; only their implementation/data moved to package-local `acquisition_catalog.lua`. Compatibility API remains **29**, Diagnostics API **1**, Run History API **1**, Save Schema **4**, and Mod API **2**.

# 2.5.89 API note

No public API version changes. Compatibility API remains **29**, Diagnostics API **1**, Run History API **1**, Save Schema **4**, and Mod API **2**. `dev_report.lua` is an internal package-local extraction only; the existing `mod.exports.__beta26.Dev` and `mod.exports.nuzlocke_dev` surfaces remain the public diagnostic contracts.

# 2.5.88 API note

No public API revision. Compatibility API remains **29** (`compatible_from = 10`), Diagnostics API remains **1**, Run History API remains **1**, Save Schema remains **4**, and Gen1Recomp Mod API remains **2**. The new `uiSessionState` export is diagnostic/internal UI state, not a compatibility contract and not gameplay save data.

# 2.5.87 Compatibility API 29

Compatibility API advances from 28 to **29** while remaining backward-compatible from API 10. `nuzlocke_compat.getEngineProfile(version?)` returns a public copy of a known engine profile (defaulting to the active audited profile); `getCompatibilitySummary()` returns the API version, compatibility floor, audited engine, active engine profile, resolved profile metadata, and capability contract versions. `getCapabilityVersion()` now normalizes case and common separators before lookup.

The capability-first Public Interop surface adds read-only `listProviders()` and `providerCount()` helpers plus legacy-compatible aliases `hasProviderCapability`, `providersWithCapability`, `listProviders`, and `providerCount`. Provider enumeration returns copied records so consumers cannot mutate the live registry accidentally. Engine profiles for Gen1Recomp 0.2.12, 0.2.13, and 0.2.14 are now explicitly present, and Release Safety verifies that the configured active engine profile resolves. Mod API remains 2.

The 2.5.86 tracker-marker presentation is reverted and has no API/state effect.

# 2.5.86 Encounter Tracker status markers

> **2.5.86 note:** ENC TRACKER now uses font-safe `O CAUGHT`, `X FAILED`, `- OPEN`, `* SHINY`, and `X DEAD` labels across classic R/B/Y, native Gold/Silver, and Modern UI presentation. Text remains explicit for accessibility; encounter mechanics and stored state are unchanged.

# 2.5.85 Run History producer completion

Run History API remains **1** and storage version remains **1**. No consumer-facing function or event name is removed. `pokemon.caught` is now produced for ordinary successful catches as well as the existing starter/gift/trade/progression acquisition paths. `pokemon.died` remains produced by the authoritative R/B/Y battle, field-poison, and Gold/Silver battle permadeath paths. `forgiveness.awarded` is now produced after a Gym Leader reward commits; `forgiveness.used` is produced after successful area/revive spends and includes the post-spend `tokens` value.

Catch payloads may additionally expose flat scalar `encounterTime`, `roamerSpecies`, `encounterSource`, `encounterProvider`, `encounterProviderVersion`, `pcLockReason`, and `pcBox` fields when known. These are additive fields under API 1; consumers must continue to tolerate absent optional fields. Gym award rows use a semantic Leader dedupe key. Built-in death rows use Pokémon identity plus `deathSequence` as an occurrence-level dedupe key; the sequence survives F. TOKEN revival, so a later genuine death receives a new sequence and remains chronological.

## 2.5.83 engine-audit API note

> **2.5.84 note:** RS-CACHE-DEDUP-001 is fixed: unseeded Random Starter distinct-choice bookkeeping ignores scoped cache/internal marker rows and counts only canonical bare starter-slot mirrors. Seeded/deterministic starter behavior is unchanged. Gen1Recomp 0.2.14 is exact-runtime boot/DEV REPORT PASS.


No public Nuzlocke API changes in 2.5.83. Compatibility API remains **28**, Diagnostics API **1**, Run History API **1**, Save Schema **4**, and Gen1Recomp Mod API **2**. The only executable metadata change is `recompCompatAudited = "0.2.14"`; the 0.2.14 upstream delta exposes no new mod-facing API to consume.

## 2.5.82 Public Interop module note

Compatibility API remains **28**, Diagnostics API **1**, Run History API **1**, Save Schema **4**, and Mod API **2**. `public_interop.lua` is an internal architecture module only; it does not rename, remove, or version-bump any public provider/capability surface.

## 2.5.81 rule-catalog module note

Compatibility API remains **28**, Diagnostics API **1**, Run History API **1**, Save Schema **4**, and Mod API **2**. `rule_catalog.lua` is an internal package-local architecture module; it does not create a new public API or change rule keys/defaults.

## 2.5.80 acquisition provenance and modularization note

Compatibility API remains **28**, Diagnostics API **1**, Run History API **1**, Save Schema **4**, and Mod API **2**.

A small cooperative acquisition-provenance API is available as `mod.exports.nuzlocke_acquisition_provenance`:

- `version = 1`
- `key = "stadium_prize"`
- `display = "STADIUM PRIZE"`
- `mark(mon, origin)` — marks an existing Pokémon as a Stadium prize; optional origin accepts Stadium 1/2 spellings and normalizes to `stadium_1` / `stadium_2`.
- `describe(mon)` — returns the normalized Stadium provenance record when applicable.

The API deliberately records acquisition provenance rather than a fake catch location. The internal implementation also mirrors the canonical origin into Nuzlocke's identity/provenance fields.

The entry file now loads `run_history.lua`, `release_safety.lua`, `dev_diagnostics.lua`, `save_migration.lua`, and `stadium_provenance.lua`. This is an implementation split, not an API-version bump.

## 2.5.78 save/migration integrity note

2.5.78 keeps Compatibility API **28**, Diagnostics API **1**, Run History API **1**, and Save Schema **4**. The internal `__beta26.saveUpgrade` surface adds transaction API 1 helpers for numbered schema migration safety: `previewPendingSchemaMigrations()`, `recoverSchemaTransaction(version)`, `applySchemaMigration(fromVersion, target, migrate)`, `status()`, and `audit()`.

`createPreMigrationBackup(game, save)` creates a bounded three-deep raw-save snapshot rotation beside the active save using Gen1Recomp's `SaveData.saveFilename()` / `persistenceFs()` surface; it never overwrites the engine's own `.bak`/`.tmp` files. `previewPendingSchemaMigrations()` is read-only with respect to live persistence. Schema migrators receive a save-like store and are preflighted against an in-memory shadow before commit. The live commit uses reserved bookkeeping key `__nuzlocke_schema_migration_txn`; it records touched-key pre/post state, writes the schema marker last, and is removed after successful completion. An interrupted transaction is either rolled back when the old schema marker remains or finalized when the target schema marker already committed. A failed migration/recovery also causes the existing Nuzlocke persistence/enforcement safety boundary to report `migration_error` and refuse further Nuzlocke-owned writes until recovery succeeds. This is distinct from `newer_schema` even though both pause unsafe persistence. These are internal/development surfaces and do not establish a new stable third-party API version.

The transaction mechanism currently covers numbered schema transitions only. Semantic, reconstruction, and projection upgrade steps remain under the existing deterministic coordinator but are not advertised as atomic.

## 2.5.77 release-safety diagnostic note

2.5.77 keeps Compatibility API **28**, Diagnostics API **1**, Run History API **1**, and Save Schema **4**. The internal/developer export surface gains `releaseSafetyAudit()` and `assertReleaseSafety()` under the existing compatibility namespace. The aggregate result is also represented in Dev self-test. These functions are read-only with respect to gameplay/save state except that `assertReleaseSafety()` raises on a failed static release contract. They do not constitute a new stable public API version.

## 2.5.76 documentation-hygiene API note

2.5.76 does not change the executable public API. Compatibility API remains **28**, Diagnostics API remains **1**, Run History API remains **1**, and Save Schema remains **4**. Public API documentation was sanitized for durable release/technical provenance only.

## 2.5.75 process-only API note

2.5.75 does not change the executable public API. Compatibility API remains **28**, Diagnostics API remains **1**, Run History API remains **1**, and Save Schema remains **4**. The new review/process contracts are development workflow only and expose no new mod API.

## 2.5.74 documentation-only API note

2.5.74 does not change the executable public API. Compatibility API remains **28**, Diagnostics API remains **1**, Run History API remains **1**, and Save Schema remains **4**. The planned public-namespace cleanup (`mod.exports.__beta26` -> canonical `mod.exports.nuzlocke` with a long-lived deprecated alias) is **planning only** and is not implemented by this build.

## 2.5.73 Run History API 1

A new additive API is exported as `mod.exports.nuzlocke_run_history`. It is independent of Compatibility API 28 and does not change Save Schema 4.

- `version = 1`
- `audited_recomp = "0.2.12"`
- `event = "nuzlocke.run_history"` — emitted after a journal row is committed. Payload: `{ game, event, run_id }`.
- `list(game, opts)` — returns copied chronological rows. Optional `opts.kind`, `opts.after_seq`, and `opts.limit` (1..512).
- `report(game)` — returns storage/API version, run ID, exact edition, generation, retained row count, lifetime counters, and first/last retained sequence IDs.
- `record(kind, payload, opts)` — additive companion/internal producer seam. Only scalar payload fields are persisted; engine objects/tables are deliberately discarded. Optional `opts.dedupe` makes an event idempotent while retained.

Storage is `run_history_v1` with format version 1. Root metadata includes `partial`, `coverage_start_build`, `baseline_catches`, and `baseline_deaths`; consumers must not present an upgraded mid-run journal as complete history. Rows contain `seq`, `kind`, exact `edition`, `generation`, `build`, optional `dedupe`, plus flat scalar event fields. Retention is capped at 512 rows. Lifetime counters are not decremented when old detail rows age out.

Initial canonical event kinds are `pokemon.caught`, `pokemon.died`, `badge.earned`, `forgiveness.awarded`, `forgiveness.used`, `run.blackout`, `run.completed`, and `note`. 2.5.73 wires producers for catches, deaths and forgiveness use; the remaining declared kinds reserve the stable vocabulary for later progression/run-lifecycle producers.

`run_history_v1` intentionally does not replace `tracker_log` or legacy `nuzlocke_history`. Tracker remains encounter-state/presentation data; legacy history remains compatibility state; Run History owns chronology for future readers.

## 2.5.71 Gen 2 Random Starter transaction identity

The existing starter-randomizer API remains version 2. Internally, Gold/Silver Elm previews now store the exact displayed choice in VM-private transaction state; the matching native `givepoke` consumes that choice without rerolling. No public API signature, Compatibility API version, Save Schema, or Diagnostics API version changes.

## 2.5.70 Gen 2 Random Starter candidate validation

No public API version bump. `starter_randomizer` remains API 2 and Compatibility API remains 28. Its candidate safety contract is now generation-aware: R/B/Y retain the Gen 1 Pokemon constructor checks; Gold/Silver validate Gen1Recomp's Gen 2 `Mon` record shape (`baseStats`, `growthRate`, `types`, `levelMoves`, and referenced move PP). Provider/delegation ownership is unchanged.

## 2.5.69 Gen 2 Random Starter transaction note

No public API version bump. `starter_randomizer` remains API 2 and Compatibility API remains 28. The private Gen 2 transaction now carries the exact live game object in its one-shot Elm starter intent so the native GivePoke substitution resolves against the correct fresh NEW GAME state. Silver is explicitly registered with the Johto starter family.

## 2.5.68 status-presentation note

No public API changes. NUZ STATUS row filtering/labels are presentation-only; Compatibility API remains 28, Diagnostics API remains 1, Save Schema remains 4, and NZR6 encoding is unchanged.

## 2.5.65 Silver / Gen 2 family note

`nuzlocke_compat.game_profiles` now treats `SILVER` as an experimental GSC profile. The historical private/runtime helper name `runtimeIsGold` is retained for compatibility but semantically answers whether the active game is generation 2; on Gen1Recomp 0.2.11 this includes Gold and Silver. Public Compatibility API remains 28.

## 2.5.63 Dev fingerprint/compatibility guard note

`Dev.reportFingerprint(text, bits)` now exposes the deterministic NZR5 hash operation needed outside the compiler-budget codec scope. Compatibility relationship lookup treats a missing capability as neutral compose metadata rather than attempting a nil-key table index.

## 2.5.62 storage-facade and engine-audit note

Compatibility API remains **28**, Diagnostics API **1**, Save Schema **4**, and Gen1Recomp Mod API **2**. Dev diagnostics now call the playthrough-bound `mod.storage` facade using its bound signatures (`context()`, `readBytes(key)`, `writeBytes(key, bytes)`, `list(prefix)`, `delete(key)`). Gen1Recomp 0.2.11 is the current stable audited marker; engine range remains `>=0.1.86 <2.0.0`.

## 2.5.61 runtime-error and engine-audit note

Compatibility API remains **28** (`compatible_from = 10`), Diagnostics API remains **1**, Save Schema remains **4**, and Gen1Recomp Mod API remains **2**. The development `__beta26.Dev` surface gains `errorCode(label, err)` / public diagnostic alias `error_code` for deterministic caught-runtime fingerprints; this is diagnostic infrastructure, not a new stable third-party compatibility contract. Published Gen1Recomp 0.2.10 is the new stable audited engine marker; the manifest range remains `>=0.1.86 <2.0.0`.

## 2.5.59 dead-fallback lint hardening

No public compatibility contract changes in 2.5.59. Compatibility API remains **28** (`compatible_from = 10`) and Diagnostics API remains **1**. Internally, `deadFallbackAudit(source)` is exposed on the development export surface and consumed at module load and by Dev assertions; it is not a new stable external compatibility contract.

## 2.5.58 cross-table invariant hardening

No public compatibility contract changes in 2.5.58. Compatibility API remains **28** (`compatible_from = 10`) and Diagnostics API remains **1**. Internally, `crossTableInvariantAudit()` is exposed on the development export surface and is also consumed by Dev assertions; it is not a new stable external compatibility contract.

## 2.5.57 active-guard contract hardening

No public compatibility contract changes in 2.5.57. Compatibility API remains **28** (`compatible_from = 10`) and Diagnostics API remains **1**. Internally, `trainer_rewards.lua` exposes an `activeGuardAudit(source)` development diagnostic used at module installation and by Dev assertions. It verifies required enforcement guards and documented persistence exceptions; it is not a new stable external compatibility contract.

## 2.5.56 rule coercion source consolidation

No public Compatibility API, Diagnostics API, or Save Schema version changes. Internally, ordinary rule numeric coercion now derives from the authoritative rule registration rows. `__beta26.ruleRegistry` descriptors additionally expose per-rule coercion metadata used by diagnostics/audit tooling.

## 2.5.55 rule-registration source consolidation

No public compatibility contract changes in 2.5.55. Compatibility API remains **28** (`compatible_from = 10`) and Diagnostics API remains **1**. Internally, ordinary rule defaults/types now originate on the same rule registration rows used by Setup/NUZ RULES; the existing read-only `__beta26.ruleRegistry` descriptors consume that same metadata.

## 2.5.54 compiler-budget refactor

No public API, save, compatibility, or diagnostics contract changes. Compatibility API remains **28**, Diagnostics API **1**, Save Schema **4**, and Mod API **2**. The refactor changes only internal helper lifetime/placement. `NZR5` and legacy `NZR4` decoding behavior are unchanged from 2.5.53.

## 2.5.53 Dev Report compact-code contract

Fresh `Dev.buildReportCode()` output uses `NZR5`. The decoder accepts both NZR4 and NZR5. In NZR5, hook health, lifecycle callbacks, safe-stop writes, rule effectiveness, and randomizer integrity are reconstructed from their encoded structured counters/status instead of being encoded a second time as summary bits.

## 2.5.51 Gold Random Starter internal transaction note

No public compatibility API changes. Gold's Random Starter implementation now carries the exact Elm starter decision from `script.command` to the native `hooks.givePoke` transaction through private per-VM one-shot state. External random-starter provider ownership still disables the Nuzlocke-owned substitution.

## 2.5.50 F. TOKEN area API behavior

`reopenFailedEncounterWithForgiveness(game, areaKey)` now accepts an optional explicit logical area key; omitting it preserves the historical current-area fallback for compatibility. `forgivenessAreaEligible(game, areaKey)` and `forgivenessAreaRows(game)` expose the same authoritative eligibility projection used by the F. TOKEN area picker and ENC TRACKER action. No Compatibility API or Save Schema version changed.

## 2.5.49 F. TOKEN UI behavior

R/B/Y F. TOKEN selectors now render the active row with `src.ui.Theme.cursor` through `Font.drawCode`, matching established native-style Nuzlocke menu pages. No public API or forgiveness mechanic changed.

## 2.5.48 UI/text behavior

No public save/API schema changed. R/B/Y F. TOKEN screens now render with the established full-page 20x18 tile layout. Gym Guide Rare Candy still uses the existing foreground script command, but its Nuzlocke-added text now contains explicit page boundaries before `NuzlockeRareCandyMenu` is pushed.

## 2.5.47 F. TOKEN R/B/Y presentation ownership
The R/B/Y `item.use` interception for F. TOKEN now closes the active Bag/use list before pushing `NuzlockeForgivenessItem`. `NuzlockeForgivenessItem` and `NuzlockeForgivenessRevive` are also published through `nuzlocke_ui.describeScreen()` as classic Nuzlocke-owned surfaces. No public save/API schema changed.

## 2.5.46 Gold Dev Mode visibility

`mod.exports.__beta26.Dev.enabled()` now resolves `dev_mode` through the same live config accessor used by NUZ RULES. `refreshGoldDevMenuRow(game, enabled)` updates only Nuzlocke's marked DEV row in the already-open Gold START menu; later openings still rebuild through `ui.start_menu.items`.

## 2.5.45 F. TOKEN presentation ownership
The internal `NuzlockeForgivenessItem` and `NuzlockeForgivenessRevive` screens now advertise stable screen IDs, `uiModLayout = "classic"`, `keepClassicUi = true`, and Nuzlocke presentation ownership/fallback metadata on R/B/Y. This is presentation-only and does not change public F. TOKEN APIs or persistence. Gold continues to render these screens through Gen 2 `Chrome`.

## 2.5.44 NZR4 consistency hardening

No public API version bump. `mod.exports.nuzlocke_dev.report_code(...)` still emits `NZR4`, but redundant summary bits for `hook_health`, `lifecycle_callbacks`, `safe_stop_writes`, `rule_effectiveness`, and `randomizer_integrity` are now derived from the same structured evidence that is encoded later in the payload.

`decode_report_code(code)` now additionally returns `consistent` and a `consistency` table with those five checks. This is additive Diagnostics API behavior and makes internally contradictory legacy/transcribed codes identifiable without changing the NZR4 bit layout.

## 2.5.43 Gold pager ownership correction

No public API version change. The internal Gold battle-rule pager no longer mutates `BattleState.queue` or calls `advanceQueue()`. It snapshots/restores only `phase`, `message`, and `messageTimer`; Compatibility API remains **28**.

## 2.5.42 player-paced Gold battle-rule text

No public API version change. Gold Nuzlocke battle-rule refusals now use an internal pager installed over `src.ui.gen2.BattleState.update`; it owns only Nuzlocke-authored refusal pages, consumes A/B to advance, then returns through `advanceQueue()`. Compatibility API remains **28**.

## 2.5.41 recent-feature hardening

Compatibility API remains **28**. `tradeEvolutionByLevelAllows(...)` and Gold branch suppression now require the supported `trigger.kind == "levelup"` contract; link/item/forced/other evolution contexts are never converted by the QoL path. `reviveWithForgiveness(...)` also detects a physically retained dead party member when the current Party Size Limit has since been lowered and relocates it to legal PC storage before clearing death state.

Build/manifest identity is numeric-only (`2.5.41`) from this version forward. Save Schema, Diagnostics API, Mod API, and engine range are unchanged.

## 2.5.40 Forgiveness Token internals

`forgivenessTokenItemId` is now `NUZLOCKE_FORGIVENESS_TOKEN`, backed by the live save inventory. `forgivenessTokens()` reads the carried quantity and keeps `route_forgiveness_tokens` only as a backward-compatible mirror; `setForgivenessTokens()` updates both. `ensureForgivenessTokenItem()` installs the runtime item definition and `syncForgivenessTokenItem()` migrates legacy unspent counts.

The old `forgivenessTokenShopId`, million-yen price/settlement helpers, Bag purchase bridge, and stock injector are retired. Private helpers `archiveForgivenessDeath`, `reopenFailedEncounterWithForgiveness`, and `reviveWithForgiveness` own lossless death snapshots and explicit spending. No public Compatibility API version bump.

## 2.5.39+DEV evolution QoL internals

Compatibility API remains **28**. The internal DEV export `tradeEvolutionLevel` is `40`, and `tradeEvolutionByLevelAllows(gameOrData, mon, evo, trigger)` models the new default-OFF Trade Evolutions QOL across the shared `evolution.check` seam. It recognizes both Gen 1 `TRADE` rows and Gold `EVOLVE_TRADE` rows.

The 2.5.39 adapter defensively accepted either a live Game or a merged-data-shaped first argument. Current Gen1Recomp documents the supported hook contract as `evolution.check(game, mon, evo, trigger)` for both generations; 2.5.41 therefore keys the QoL decision to `trigger.kind == "levelup"` while retaining the shape adapters for backward/provider tolerance. `evolutionTargetId` accepts both Gen 1 `species` and Gold `into` target fields. No public API contract/version changed.

## 2.5.38+DEV API note

Compatibility API remains **28**. `PartyPC.evaluate()` no longer reports the Nuzlocke `party_size_limit` denial when the configured value is 6, because 6 is native capacity rather than a challenge restriction. Limits 1-5 retain the same denial contract. `mod.exports.__beta26.build` and `mod.exports.__beta26.manifestVersion` both expose the canonical updater-safe `2.5.38+DEV` identity.

## 2.5.37-DEV storage/randomizer repair internals

No public API version changed. Compatibility API remains **28**, Diagnostics API **1**, Save Schema **4**, and Mod API **2**.

`mod.exports.__beta26.forEachExistingSaveBox(save, callback)` is an internal sparse-safe traversal used by Nuzlocke storage scans. Gold's `save.boxes` may omit never-used intermediate numeric slots, so internal code no longer relies on `ipairs(save.boxes)` for cross-box discovery. The callback receives `(box, numericIndex)` in ascending index order and may return `false` to stop early.

PC-Only Catch preflight now records the chosen filing box on the battle transaction. Post-catch filing treats that as a preferred target and falls back to any box with room, rather than re-applying Gold's *pre-throw* current-box-only rule after the catch has increased party size. Permanent `nuzlockePcLocked` metadata is written only after the caught Pokemon is confirmed in storage.

Random Field Item HM protection now uses both canonical `HM_` ids and `def.machine.kind/type == "HM"`; no randomizer API or RNG algorithm version changes.

## 2.5.36-DEV Gen1Recomp dev-audit internals

No public Nuzlocke API changed. `recompCompatAudited` intentionally remains **`0.2.7`**, the latest published release profile; current Gen1Recomp development head **`def270f7c726ebd7bd87086ad90bc4a7b9622543`** is recorded separately in compatibility documentation because a moving SHA is not a stable semantic compatibility version.

The existing `nuzlocke_compat.currentBattleSnapshot(game)` remains optional/read-only and dynamically loads the generation-appropriate official BattleAPI. On current Gold dev, its `items` snapshot can now contain Ball records with exact stock `catchChance` percentages. Nuzlocke does not calculate or enforce from those preview percentages; capture legality and Ball Per Encounter continue to use their established transaction hooks. Upstream may return `catchChance=nil` when another mod owns `catch.rate`.

Current Gold also exposes `ui.party.grid_navigation` for battle party menus. Nuzlocke claims no capability or ownership for that hook. Android in-process launcher switching calls upstream `Runtime.reset()` before another game boots; 2.5.36 adds no new lifecycle wrapper and relies on the existing owner-aware revalidation strategy.

## 2.5.35-DEV recent-feature repair internals

No public API versions changed. Gold Random Starter's `script.command` observer no longer rewrites the native `givepoke` command; concrete species substitution remains owned by the existing 2.5.30 `Vm.new` / `hooks.givePoke` transaction wrapper. Starter cache normalization now treats plain species-id keys as case-insensitive while preserving/canonicalizing the known opaque `GOLD_STARTER_SLATE:v1:s...:style...` scope.

## 2.5.34-DEV Unlimited Bag Space internals

No public Compatibility API capability was added; Compatibility API remains **28**. Unlimited Bag Space is implemented as an internal, session-safe wrapper around the engine's `src.inventory.Bag.capacity` function. The wrapper always asks the downstream/live capacity first. OFF returns that answer unchanged; ON raises the relevant ordinary carrying pocket to an effectively unbounded finite capacity.

`mod.exports.__beta26.unlimitedBagCapacity(nativeCapacity, pocket, game, enabled)` is an internal deterministic resolver used by the wrapper. R/B/Y's ordinary Bag is eligible. On Gold, only `ITEM` and `BALL` are expanded; `KEY_ITEM` and `TM_HM` preserve the downstream capacity. Stack quantity remains owned by `Bag.add` and therefore stays capped at 99.

`installUnlimitedBagSpace()` records owner/previous/wrapper identity on `Bag` and revalidates at safe lifecycle boundaries. Save Editor sessions skip the runtime patch so an editor loader cannot strand a stale `mod.save` closure in gameplay. No Save Schema field or migration marker is required because the new persisted setting is an ordinary default-OFF configuration row already covered by the canonical rule/save descriptor machinery.

## 2.5.33-DEV movement-assist internals

Compatibility API remains **28**. `automatic_running_shoes` is now a numeric three-state configuration value (`0=OFF`, `1=HOLD B`, `2=ALWAYS`) with defensive boolean compatibility (`false->0`, `true->1`). New `fast_surf` uses the same numeric mode. Internal helpers `__beta26.movementAssistMode` and `__beta26.movementAssistLabel` normalize/label the values.

No new public provider capability is introduced. Both assists compose through the existing engine `movement.speed` hook. The semantic migration marker `movement_assist_modes_2533` converts the historical Running Shoes boolean once and seeds Fast Surf OFF without changing Save Schema 4.

## 2.5.32-DEV Gold Random Starter slate internals

Gold now exposes `goldRandomStarterSlate(game, seed, style)` internally. It builds the complete Elm three-ball slate in canonical starter order, uses the dedicated versioned `STARTER_SLATE` deterministic namespace, and avoids replacement while legal alternatives remain. The accepted starter scalar is still written only by `commitRandomStarter`. Preview rewriting returns copied args/cmd values for the current `script.command` dispatch rather than modifying shared generated source tables.

## 2.5.31-DEV Whiteout recovery internals

Compatibility API remains **28**, Diagnostics API remains **1**, and Save Schema remains **4**. 2.5.31 adds internal `__beta26` helpers for classifying Whiteout recovery reserves and deciding survivable Whiteout versus destructive Blackout. These are implementation helpers, not new Compatibility API capabilities/providers. A one-time semantic marker `whiteout_semantics_restored_2531` documents the corrected persisted meaning of the existing `whiteout_clause` configuration key.

Gold's empty-party Bill's-PC recovery wrapper composes the native `PcMenu.new` construction seam only when Whiteout recovery has at least one eligible boxed Pokemon; it does not alter the public Party/PC compatibility policy or the permanent PC-Only-Catch lock contract.

## 2.5.30-DEV Gold Random Starter implementation note
Compatibility API remains **28**. The repair is internal: Gold now composes around the Gen 2 VM constructor so each VM receives a copied hook table whose `givePoke` callback can replace only the canonical first-party Elm starter species. No public capability name, provider contract, return shape, or API version changes.

`mod.exports.__beta26.randomStarterRuleEnabled(game)` is an internal development helper used to bridge the immutable NEW GAME Setup snapshot into the freshly adopted mod.save bucket for the Random Starter toggle/style/seed only. External `random_starter` provider ownership remains authoritative. DEV diagnostics add the internal `gold_random_starter_transaction_gate` health row under Diagnostics API 1.

## 2.5.29-DEV Gold starting-resource / Ball-limit API note
Compatibility API remains **28**. This child adds no public capability or return-shape change. `encounter_ball_limit` was already a normal numeric rule contract; Gold now exposes that existing rule on its configuration surface. Gold NEW GAME resources use internal setup keys `gold_starting_money`, `gold_starting_pokeballs`, and `gold_starting_rare_candies` so R/B/Y and Gold staged profiles do not reinterpret the same resource fields. The Gold Ball deferral marker is engine/save-internal and is not a new public Compatibility API field.

## 2.5.28-DEV progression/completion catch API note
Compatibility API remains **28**. The existing acquisition and Party/PC policy surfaces gain additive semantics for the PC-only progression exception; no capability name or capability-version number changes.

For a cooperative capture source that sets `captureAttempt=true`, `progressionRequired=true`, and `allowProgressionException=true`, `Acquisition.evaluate/begin/commit` may return an allowed exception with `pcLock=true`, `permanent=true`, `consumeEncounter=false`, `rule="progression_pc_catches"`, and `pcLockReason=<original denial>`. `Acquisition.commit` will attempt to apply the permanent storage marker when a concrete committed `mon`/`pokemon` is supplied. Providers remain responsible for respecting the normal evaluate-before-mutate transaction order.

`PartyPC.evaluate` now returns `allowed=false`, `rule="progression_pc_lock"`, `reason="progression_pc_locked"` when a PC-locked Pokemon would enter the active party or when RELEASE targets one. `compat21.pokemonLegality()` reports `PC LOCKED`, and `compat21.pokemonProvenance()` additively exposes `pcLocked`, `pcLockReason`, and the progression-catch location. These additions are backward-compatible optional fields under Compatibility API 28.

## 2.5.27-DEV Maximum BST preset implementation note
Maximum BST remains an internal numeric rule value exposed through the existing Compatibility API 28 surfaces. The UI preset ladder expands to OFF/300/350/400/450/500/550/600/650/700, but `getMaximumBST()` and compatibility consumers still receive the exact numeric threshold (or 0 for OFF). No public API or capability version changes.

## 2.5.26-DEV STAT INFO layout implementation note
R/B/Y native NUZ INFO keeps the existing host-owned ListMenu integration. STAT rows now preserve up to 14 right-column glyphs and draw ATK/DEF/SPE/SPC from x=40, while LEVEL/HP draw from x=64 with an 11-glyph budget. This is presentation-only; Compatibility API 28 and all public data contracts are unchanged.

## 2.5.25-DEV field-item randomizer implementation note
Compatibility API remains **28**. Random Field Items uses internal owner-aware engine adapters and the existing internal versioned seeded helper; it adds no Compatibility API capability, provider ownership claim, save-schema field, or public API version bump. The public `mod.exports.randomizer` API remains version 1.

## 2.5.24-DEV UI navigation implementation note
Compatibility API remains **28**. Rules/Setup cursor and scroll memory is an internal, session-only UI concern keyed by configuration surface and semantic row identity. It does not add public API fields, change capability versions, write gameplay save data, or alter Save Schema 4.

## 2.5.23-DEV runtime-scope / fresh-New-Game implementation note
Compatibility API remains **28**. The repaired Random Starter path consumes an explicitly exported internal seeded-index helper instead of reaching across a Lua lexical boundary, and the R/B/Y command/heal/starter transaction wrappers are again installed from the scope that owns their captured locals. Late-runtime phase 2 now executes and fresh `save.created` revalidates critical R/B/Y wrappers. These are internal runtime-conformance repairs; no public Compatibility API return shape, capability version, Diagnostics API contract, or save representation changes.

## 2.5.22-DEV lifecycle / RNG implementation note
Compatibility API remains **28**. Gen 1 kerning wrapper ownership and starter RNG versioning are internal implementation repairs. Kerning now tracks exact session/previous/wrapper identity on the persistent Font singleton; starter selection uses the existing versioned seeded-index helper. No public Compatibility API return shape, capability version, Diagnostics API contract, or save representation changes.

## 2.5.21-DEV trainer identity note
Compatibility API remains **28**. Internal trainer reward/progression bookkeeping now uses one shared normalized identity record covering trainer ID, class, and name aliases across R/B/Y, Gold, and compatible provider payloads. This is an implementation-consistency repair; no public return shape, capability contract, or API version changes.
# Nuzlocke API — 2.5.30-DEV


## 2.5.20-DEV persistence/enforcement policy note
Compatibility API remains **28**. Internal runtime policy now distinguishes `canWriteNuzlockeSave(game)`, `isNuzlockeEnabled()`, and `shouldEnforceNuzlocke(game, battle)`. The distinction prevents passive boss-progression synchronization from being disabled merely because the challenge master switch is OFF, while still preventing rule consequences and all Nuzlocke-owned writes on unsupported newer schemas. These helpers are internal `__beta26` development surfaces; no public Compatibility API contract changes.

2.5.20 keeps Compatibility API 28, Diagnostics API 1, Save Schema 4, and Mod API 2 unchanged while separating persistence safety, passive progression tracking, and active challenge enforcement.


## 2.5.19-DEV API safety note
Compatibility API remains **28**. `getCompatibilityReport().engine` is now a defensive fresh snapshot; `getPokemonId(mon)` is read-only; and `ensurePokemonId(mon, game, origin)` refuses identity mutation while a newer unsupported save schema is safe-stopped. Save Schema remains 4 and audited Gen1Recomp remains 0.2.7.

# Nuzlocke 2.5.17-DEV API / integration contract

## 2.5.17-DEV current contract

Public Compatibility API is **28**, Diagnostics API remains **1**, and Save Schema remains **4**. 2.5.17 adds read-only development metadata plus a new public per-capability compatibility-version negotiation surface. `mod.exports.__beta26.buildProvenance()` reports the exact immediate parent version/SHA plus schema/API/audited-engine/package-count metadata.

`mod.exports.__beta26.ruleRegistry.describe()` derives rule key/type/default/generation/setup metadata from the existing `ruleCategories` and canonical `defaultRuleValue()` path. `saveSchemaDescriptor.describe()` describes the persisted configuration/schema-control surface and explicitly marks itself incomplete for internal gameplay-history/telemetry state; it does not migrate or rewrite saves.

Compatibility API 28 exposes `capability_versions` and `getCapabilityVersion(capability)`. All currently advertised capabilities begin at contract version 1. Existing API-27 capability names/meanings remain compatible, and `compatible_from` remains 10. Diagnostics API 1 exposes the provenance/descriptors and audits them during SELF TEST without changing the diagnostics API number.

## 2.5.16-DEV current contract

Public Compatibility API remains **27**, Diagnostics API remains **1**, and Save Schema remains **4**. Public export `build` fields identify 2.5.16-DEV. No public return shape or provider contract changes. `ruleActive(game, key, battle)` now uses the same canonical missing-key default as the rule model instead of forcing missing keys to false; this repairs API-27 conformance for default-ON rules rather than introducing a new API. Dev hook-health rows are expanded additively under Diagnostics API 1.

Direct-wrapper lifecycle validation now also requires live function identity for automatic names, Gold nickname/Mart/gambling enforcement, the R/B/Y Permadeath bundle, QoL Toggles AUTO-REPEL, and both Wilds of Kanto capture functions. These records remain internal implementation state; historical boolean markers are non-authoritative. `locke_type` remains save-profile metadata and its missing-value fallback now comes from the canonical default source.

## 2.5.15-DEV current contract

Public Compatibility API remains **27**, Diagnostics API remains **1**, and Save Schema remains **4**. Public export `build` fields identify 2.5.15-DEV. No new public provider is added. The field-poison Whiteout repair is internal run-ending enforcement; Gold No Escape continues to use the existing shared `battle.run` hook contract.

Direct-wrapper lifecycle ownership is extended to Party Size/PC withdrawal, Gold No Day Care, Gold Whiteout finish, Gold Headbutt tracking, and forgiveness-token mart stock. These records are internal implementation state; historical boolean markers remain non-authoritative. `locke_type` snapshot persistence is save-profile metadata and does not change the public rule/provider API.

## 2.5.14-DEV current contract

Public Compatibility API remains **27**, Diagnostics API remains **1**, and Save Schema remains **4**. Public export `build` fields now identify 2.5.14-DEV. No new public provider is added. Internal direct-wrapper ownership now records the active mod owner plus previous/wrapper functions for the R/B/Y catch/Permadeath and Gold capture seams so a later loader session can discard only an exact stale Nuzlocke top-level wrapper. Historical boolean marker fields remain non-authoritative compatibility markers.

Missing core rule keys consumed by encounter/acquisition enforcement now use the same `defaultRuleValue()` source as configuration. This changes only the fallback for an absent key; explicit saved values and the public rule schema are unchanged.

## 2.5.13-DEV current contract

Public compatibility version remains **27**, Diagnostics API remains **1**, and Save Schema remains **4**. Public export `build` fields reference the authoritative 2.5.13-DEV build. 2.5.13 adds no new public provider or compatibility contract; the field-poison Permadeath repair is internal enforcement/bookkeeping at existing engine seams. The 2.5.12 generation-correct final-encounter-registry contract remains unchanged.

### Report Code v4

`mod.exports.nuzlocke_dev.report_code(game, report, fullText)` emits `NZR4-...`. NZR4 stores **major, minor, and patch** independently, so 2.5.16-DEV and future minor-version releases decode correctly. `decode_report_code(code)` returns `major`, `minor`, `patch`, reconstructed `build`, the fixed diagnostic summary, assertion fingerprint, and report-body fingerprint.

The report-body fingerprint covers the complete generated report body **before** the generated `report_code=` line is inserted; excluding that line is intentional to avoid a circular fingerprint.

Unknown Report Code prefixes are rejected instead of being guessed.


## 2.4.79 compatibility note
No public API changes. Gen1 Better Menus 1.0.3 is recorded only through optional-dependency and descriptive local compatibility metadata. Compatibility API remains 27, Diagnostics API remains 1, and Save Schema remains 4.

## 2.4.78 Type Locke internal surface
The existing internal `__beta26` Type Locke surface now accepts modes 0-6 and `typeLockAllowedTypes()` can expose up to six lanes. Catch Draft adds internal state helpers without changing Compatibility API 27 or creating a new public third-party contract.

## 2.4.77 documentation-only note
No public API, Compatibility API, Diagnostics API, Save Schema, provider contract, or engine-range behavior changes. Compatibility API remains 27, Diagnostics API remains 1, Save Schema remains 4, and `game_version` remains `>=0.1.86 <2.0.0`.

## 2.4.75 cap metadata
`getNextLevelCapInfo()` keeps its existing fields and may additionally return `effectiveOwner`, `nuzlockeCap`, `kantoReforgedCap`, and `kantoReforged` when KR cap co-ownership is active. Compatibility API remains 27.

## 2.4.74 compatibility note
The descriptive `compat.Mods.adapters.indigo_conference.tested` marker is now `1.1.0`. No public Compatibility API number changes. The generic late post-battle dead-Pokemon invariant remains the composition mechanism rather than an IPC-specific API.

## 2.4.73 behavior note
No API contract changes. R/B/Y Quick Start runtime testing confirmed the current one-shot progression transaction is playable; the possible outside-house handoff before bedroom-PC pickup is documentation-only and does not alter exported APIs.

## Engine-range policy
`game_version` remains `>=0.1.86 <2.0.0`. The `<2.0.0` maximum is project policy and must not be changed without explicit project-owner direction.

## 2.4.71 engine audit
Audited Gen1Recomp release: **0.2.0**.  
Verified engine range: **`>=0.1.86 <2.0.0`**.

The mod continues to use Mod API 2 and Compatibility API 27. Existing public Nuzlocke exports are unchanged in this compatibility pass.

## 2.4.70 safety semantics
On an unsupported newer save schema, Nuzlocke's wrapped `mod.save:set(...)` returns `false, "newer_schema"` instead of delegating the write. This is a defensive internal persistence contract; Save Schema remains 4 and Compatibility API remains 27.

`Randomizer.applyLearnsets(game)` also returns `false` while the future-schema safe-stop is active.

Deferred Starting Balls release and Skip Catch Tutorial queries likewise return without applying their Nuzlocke shortcut behavior while the safe-stop is active.

## 2.4.69 published API baseline
No API number changes in this RC. Compatibility API remains 27, Diagnostics API remains 1, Save Schema remains 4, and the 2.4.68 diagnostics/public surfaces are preserved.

## Diagnostics Randomizer-integrity API
`mod.exports.nuzlocke_dev.randomizer_integrity(game)` returns a report containing `status`, `active`, `delegated`, `scanned`, `violation_count`, `violations`, `truncated`, plus optional provider/detail fields.

Violation rows contain `path`, `species`, and `reason`. The function is read-only.

## Diagnostics rule-effectiveness API
`mod.exports.nuzlocke_dev.rule_effectiveness(game)` returns `{ game, nuzlocke_enabled, schema_supported, counts, rows }`.

Each row includes `key`, `category`, `configured`, `configured_source`, `effective`, `owner`, `relationship`, `delegated`, `changed`, and optional `owner_id`, `capability`, or `error`.

## Diagnostics future-schema write API
`mod.exports.nuzlocke_dev.safe_stop_writes()` returns `{ active, total, by_key, first_key, last_key }`.

`mod.exports.nuzlocke_dev.reset_safe_stop_writes()` clears only the session diagnostic counters. Neither function changes rules, save schema, or enforcement state.

## Diagnostics lifecycle API
`mod.exports.nuzlocke_dev.lifecycle()` returns `{ counts, duplicate_callbacks, duplicate_by_event, battle_delta }`.

`mod.exports.nuzlocke_dev.reset_lifecycle()` resets only session diagnostic counters/identity tracking. It does not touch rules, gameplay state, or persistent save data.

## Diagnostics hook-health API
`mod.exports.nuzlocke_dev.hook_health(game)` returns `{ game, counts, rows }` for the observable adapter set. Each row includes `id`, `path`, `method`, `generation`, `state`, and `detail`. The check is read-only and does not require unloaded modules.

## Save-schema support query
`mod.exports.__beta26.saveSchemaSupported()` returns false after the migration coordinator detects a save schema newer than this build's schema 4. While false, shared enforcement and guarded lifecycle repair paths remain paused.

- Compatibility API: **27**
- Gen1Recomp Mod API: **2**
- Audited Gen1Recomp: **0.2.0**
- Manifest range: **`>=0.1.86 <2.0.0`**
- Save Schema: **4**
- Diagnostics API: **1**

The published 2.4.69 release keeps Compatibility API 27, Diagnostics API 1, and Save Schema 4 unchanged. 2.4.70 preserves those API numbers.

## Gen1Recomp 0.2.x diagnostics storage
Dev diagnostics use official `mod.storage` with byte read-back verification. No host filesystem path or clipboard guarantee is part of the API contract.

## Gold capture compatibility
Gen1Recomp 0.2.0 exposes richer Gold `catch.rate` context. Nuzlocke still keeps its protected pre-consumption Gold capture-policy gate authoritative until a deliberate runtime-proven migration is justified.

## Core exports

### `mod.exports.nuzlocke_compat`

Compatibility/provider contract used by companion mods.

Important fields/functions include:

- `version = 28`
- `audited_recomp = "0.2.7"`
- `capabilities`
- `engine_compat`
- `mod_compat`
- `ownership`
- `cooperation`
- `gold`
- `canUseItem(game, itemId, context)`
- `canPurchase(game, context)`
- `canSell(game, context)`
- random-starter selection/commit helpers
- `typeLockAllowsSpecies(game, species)` for pre-construction/species-level legality
- `typeLockAllowsPokemon(game, mon)` for concrete runtime Pokémon legality

Consumers should feature-detect functions/capabilities rather than assuming every historical member exists. Public metadata tables are defensive snapshots: mutating them does not alter Nuzlocke's internal compatibility ownership/relationship policy. `getEffectiveRuleValue(key)` uses the canonical rule default when no explicit fallback is supplied; `getRuleValue(key)` remains the raw persisted-value accessor.

### `mod.exports.nuzlocke_ui`

API 1 semantic presentation contract. Nuzlocke retains state/action ownership while compatible UI mods may provide presentation adapters. Screen records identify roles such as rules, tracker, compatibility status, and run/status information.

### `mod.exports.nuzlocke_translation`

API 1 generation-neutral localization helper around Gen1Recomp's `Strings` service. Missing translation keys fall back through the engine.

### `mod.exports.randomizer`

API 1 structured randomizer helper:

- current seed
- algorithm/RNG version
- apply all
- apply encounters
- apply learnsets


### Runtime species safety

`mod.exports.__beta26.randomEncounterRuntimeSafe(game, species, level)` separates encounter construction safety from starter construction safety. On Gold this permits complete string-id species records without requiring an 8-bit `index`, while retaining structural checks for the stats/types/level-move data battle construction needs. This is deliberately narrower than a blanket "indexless species are safe everywhere" claim.

### `mod.exports.starter_randomizer`

API 2 starter selection/commit contract.

### `mod.exports.battle_classifier`

API 1 battle classification plus a read-only current battle snapshot helper. The snapshot delegates to `mod.battle:snapshot()` where available and is detached from live battle state.

## Engine seams used or recognized

### Shared public hooks/events actively used

- `ui.start_menu.items`
- `ui.title_menu.items`
- `trainer.party`
- `battle.damage`
- `battle.run`
- `exp.gain`
- `fieldmove.eligibility`
- `encounter.fishing`
- `movement.speed`
- `warp.destination`
- `intro.oak_speech.build`
- `ui.party.submenu`
- `script.command`
- `pokemon.caught`
- `battle.started` / `battle.ended` / `battle.fainted` / related battle events
- `map.entered` / `map.reloaded` / `world.stepped`
- `checkpoint.restored`

Some names have generation-specific coverage; see `COMPATIBILITY.md`.

### Contextual field actions

Gen1Recomp exposes:

- `mod.world:availableFieldActions()`
- `mod.world:useFieldAction(id, opts)`

Nuzlocke reports this relationship as **`transitive_native_guard`**. It does not replace/wrap the public API itself. Restrictions are enforced at the underlying execution seams used by the engine, including R/B/Y fishing and Gold field-item paths.

### `item.use`

Gen1Recomp 0.2.x retains the public **Gen 1 BagMenu dispatch hook**:

`item.use(next, game, battle, id, target, list, moveIndex, picker)`

Nuzlocke recognizes it but does not make it the authoritative item-policy seam because:

1. it wraps Gen 1 BagMenu dispatch rather than every possible direct item transaction;
2. Gold's Pack does not expose the same authoritative item-use hook in the audited Gen2 surface;
3. Nuzlocke's existing item-policy gate already returns through the native item-result/message path and covers provider/native backstops.

Future migration is appropriate only when it preserves equivalent R/B/Y + Gold enforcement and presentation.

### Battle HUD presentation hooks

Gen1Recomp 0.2.x exposes shared:

- `battle.bottom_ui_visible`
- `battle.status_hud_visible`

Nuzlocke treats these as **coexistence/presentation ownership** seams. It does not currently hide the vanilla battle HUD globally. Future Encounter HUD work should compose through these/public rendering seams rather than blindly double-drawing over another HUD provider.

### `trainer.before_battle`

Used for the existing Gen 1 Gym Team Size transaction. The audited Gen1Recomp 0.2.x surface still does not provide this as a Gold party-selection contract, so it must not be treated as a shared Gold party-selection contract.

## Provider philosophy

- External providers keep ownership of capabilities they explicitly claim.
- Nuzlocke should not double-transform an external difficulty/trainer-party/encounter/presentation surface.
- Alternate inventory/capture UIs are encouraged to call `nuzlocke_compat.canUseItem` / related provider APIs before committing a transaction.
- Provider discovery is revalidated at use-time; disabled/failed providers should not retain ownership.

## Link safety

`manifest.json` explicitly sets `affects_link: true`. Nuzlocke changes battle decisions through hooks, so a peer should not silently enter a lockstep battle while ignoring that ruleset difference.

## Save/editor behavior

Nuzlocke runtime monkey patches are skipped for the embedded Save Editor loader session and rebound at gameplay lifecycle boundaries. Permanent Rule Seal groundwork uses `mod.storage`, but the feature is currently WIP-disabled.


### 2.4.48 encounter-spend presentation

`nuzlocke_compat.encounterSpendIndicator(battle)` returns the read-only current presentation state used by Nuzlocke's own encounter badge. It may report `counts`, `spent`, `dupe_free`, `shiny_free`, or `blocked`; consumers must not treat the display result as a mutation/commit API.

## 2.4.60 runtime crash diagnostics

No API version changes. Internal config/status screen recovery handlers now call the existing `Dev.recordError` surface when Dev Mode is enabled, preserving full `xpcall` tracebacks in the established diagnostic history.

## 2.4.59 Dev diagnostics
Diagnostics API remains version 1. `nuzlocke_dev.pguard(label, fn, ...)` preserves protected-call return semantics while reporting thrown failures to the existing Dev error/breadcrumb/snapshot path when Dev Mode is enabled. Internal use is deliberately limited to high-value failure seams; intentional capability probes and mechanics-capability calculation are not blanket-instrumented.

`assertions(game?)` now also reports contradictory `encounter_states`/`caught_areas` persistence and malformed Shiny Clause mode/used values. A finite Shiny limit lower than the already-used count is not itself an invariant failure because rule changes do not reset historical usage.

2.4.58 history behavior remains unchanged: `reload_self_test(game?, key?)` and `stored_self_tests(game?)` expose read-only stored history access, bounded to 16 sequenced reports plus `latest`.

## 2.4.62 Random Encounter legality
The internal Nuzlocke Random Encounter candidate pool now composes with the existing `specialAcquisitionDenied(...)` legality path. Compatibility/provider surfaces and API versions are unchanged; external randomizer delegation remains authoritative when active.

## Localization seam (2.4.80)
`mod.exports.nuzlocke_translation` remains API 1. English source strings are stable lookup keys. Nuzlocke-owned shared wrapping/slicing is glyph-aware so translator-provided multibyte/charmap text is not split by Lua byte offsets.

## Gen1Recomp BattleAPI bridge (2.4.81)
On engines that provide it, `nuzlocke_compat.currentBattleSnapshot(game)` returns the official read-only Gen 1 or Gen 2 BattleAPI snapshot. It returns `nil` on older engines or when unavailable. This is a presentation/diagnostic surface, not a rule-enforcement bypass.

## Encounter Ball Limit (2.4.85)
The rule is stored as selector mode `encounter_ball_limit` (0..5), mapped to OFF/1/2/3/5/10. Runtime accounting is intentionally battle-local in `battle.nuzlockeEncounterBallThrowsUsed`; it is not persistent save state. Compatibility consumers may use `__beta26.encounterBallThrowAvailable` / `consumeEncounterBallThrow` when composing an alternate capture UI.

## Dev Report Code API (2.4.93)
`mod.exports.nuzlocke_dev.report_code(game, report, fullText)` returns a versioned `NZR1` base32 code. `decode_report_code(code)` returns the fixed summary fields plus `assertion_fingerprint` and `full_report_fingerprint`. The format is intentionally versioned; consumers must reject unknown prefixes rather than guessing field layouts.

## Report Code v2 (2.4.94)
The fixed result vector gained the `mom_heal_gate` bit, so report codes now use prefix `NZR2`. Consumers must not decode NZR1 payloads with the NZR2 field layout.

## Legacy adapter ID matching
`detectCapabilities()` normalizes IDs but now checks both separator-preserving and joined-word spellings for multi-word legacy hints. Explicit provider registration remains preferred over name-based auto-detection.

## Report Code v3 (2.4.99)
The fixed diagnostic result vector now includes `encounter_ball_limit_setting`, so new report codes use `NZR3`. Older NZR2 payloads must not be decoded using the NZR3 field layout.

## Gen1Recomp 0.2.7 audit
Nuzlocke's current source-audited engine profile is 0.2.7. The engine remains Mod API 2 / save format 4. The final 0.2.7 release adds Gold `TimeFishGroups` / day-night fishing fields under the shared `encounters` registry and routes that registry to `game.data.gen2Encounters` on Gold. `Registry.effectiveEncounters(game)` and `Registry.describe(game).encounters` now expose that generation-correct final live table, while R/B/Y continue to use `game.data.encounters`.

This is a repair of the existing `final_encounter_registry`/encounter-information contract, not a Compatibility API bump. Randomizer mutation continues to operate on the same live registry it already used; OPEN/BLIND reveal policy and targeted-selection policy are unchanged. The 0.2.2 `battle.move_grid_navigation` hook remains an available shared hook Nuzlocke does not own, and Gold `mod.battle` Ball/catch-preview records added in 0.2.3 remain read-only snapshot data when available.


## 2.5.67 exact-edition diagnostics / NZR6

`mod.exports.__beta26.Dev.gameId(game)` returns the exact normalized edition id (`red`, `blue`, `yellow`, `gold`, `silver`, or future `crystal` groundwork). `Dev.gameLabel(game)` returns the uppercase display label. Shared generation mechanics should continue to use the generation predicate; diagnostics, parity accounting, breadcrumbs, and player-facing version labels should use exact edition identity.

The compact Dev Report format is now **NZR6**. NZR6 stores the exact edition in three bits instead of the historical one-bit RBY/Gold family flag. `Dev.decodeReportCode` remains backward-compatible with NZR4 and NZR5 codes. This makes exact-edition runtime evidence available for future per-game feature implementation/parity graphs without duplicating Gen 1/Gen 2 mechanics.
