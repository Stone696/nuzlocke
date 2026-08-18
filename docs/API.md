# Nuzlocke 2.4.69 RC API / integration contract

## 2.4.69 RC API freeze
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
- Audited Gen1Recomp: **0.2.1**
- Manifest range: **`>=0.1.86 <2.0.0`**
- Save Schema: **4**
- Diagnostics API: **1**

2.4.69 RC keeps Compatibility API 27, Diagnostics API 1, and Save Schema 4 unchanged. The RC adds no new provider-authority or persistent-schema contract beyond the 2.4.68 development head.

## Gen1Recomp 0.2.x diagnostics storage
Dev diagnostics use official `mod.storage` with byte read-back verification. No host filesystem path or clipboard guarantee is part of the API contract.

## Gold capture compatibility
Gen1Recomp 0.2.0 exposes richer Gold `catch.rate` context. Nuzlocke still keeps its protected pre-consumption Gold capture-policy gate authoritative until a deliberate runtime-proven migration is justified.

## Core exports

### `mod.exports.nuzlocke_compat`

Compatibility/provider contract used by companion mods.

Important fields/functions include:

- `version = 27`
- `audited_recomp = "0.2.1"`
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

Consumers should feature-detect functions/capabilities rather than assuming every historical member exists.

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
