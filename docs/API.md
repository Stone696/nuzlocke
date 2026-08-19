## 2.5.23-DEV runtime-scope / fresh-New-Game implementation note
Compatibility API remains **28**. The repaired Random Starter path consumes an explicitly exported internal seeded-index helper instead of reaching across a Lua lexical boundary, and the R/B/Y command/heal/starter transaction wrappers are again installed from the scope that owns their captured locals. Late-runtime phase 2 now executes and fresh `save.created` revalidates critical R/B/Y wrappers. These are internal runtime-conformance repairs; no public Compatibility API return shape, capability version, Diagnostics API contract, or save representation changes.

## 2.5.22-DEV lifecycle / RNG implementation note
Compatibility API remains **28**. Gen 1 kerning wrapper ownership and starter RNG versioning are internal implementation repairs. Kerning now tracks exact session/previous/wrapper identity on the persistent Font singleton; starter selection uses the existing versioned seeded-index helper. No public Compatibility API return shape, capability version, Diagnostics API contract, or save representation changes.

## 2.5.21-DEV trainer identity note
Compatibility API remains **28**. Internal trainer reward/progression bookkeeping now uses one shared normalized identity record covering trainer ID, class, and name aliases across R/B/Y, Gold, and compatible provider payloads. This is an implementation-consistency repair; no public return shape, capability contract, or API version changes.
# Nuzlocke API — 2.5.23-DEV


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
