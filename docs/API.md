## 2.0.0-beta.30.0.0.10

### Delegation
`mod.exports.nuzlocke.delegation.statusForRule(key, game)` is now late-bound and safe to call after initialization. `mod.exports.nuzlocke.delegation.rules()` returns the current non-core delegation table. Providers should claim granular randomizer capabilities rather than a generic randomizer capability when they require exclusive UI/runtime ownership.

### Item policy
`nuzlocke.itemPolicy.evaluate/beforeUse/canUse/check/checkUse` now route through the native `evaluateItemUsePolicy` authority. Consumers therefore receive the same Nuzlocke master-switch behavior and item restrictions as built-in menus.

### Acquisition policy
`nuzlocke.acquisitionPolicy` now uses `typeLockAllowsSpecies` and the shared special gift/trade acquisition policy where applicable. External providers should still supply accurate `kind`, `species`, and `areaId` context; wild encounter/catch legality remains richer when the provider uses the encounter policy with a battle/area context.

## beta.29.3.16 / Compatibility API 27 additions

API 27 is additive and keeps `compatible_from = 10`.

- `getNuzInfoPages()` returns enabled Nuz Info page IDs (`catch`, `stat`, `move`) in display order.
- `getPokemonNuzInfo(game, mon)` returns a defensive structured snapshot of catch provenance, current stats, DVs, raw Stat EXP, and current move metadata/PP.
- Move metadata is resolved from the active merged `game.data.moves` table.
- The compatibility report now declares `nuz_info = true` ownership for Nuzlocke's own presentation/data contract; this does not claim ownership of Gold's native Trainer Card.

# Developer API

This document describes the supported integration surface exported by Nuzlocke `2.0.0-beta.29.3.16`. It is intended for mod authors who want to query Nuzlocke policy or cooperate with shared engine seams without reading internal implementation details.

## Discovering Nuzlocke

```lua
local nuz = mod.find("nuzlocke")
if not (nuz and nuz.exports) then return end
local compat = nuz.exports.nuzlocke_compat
if not compat then return end
```

`mod.find` should be treated as optional: a missing, disabled, failed, or not-yet-loaded mod may return `nil`.

## Compatibility API identity

- `mod.exports.nuzlocke_compat.version = 26`
- `compatible_from = 10`
- `audited_recomp = "0.1.83"`
- `runtime_environment()` returns the current Nuzlocke loader environment (`gameplay` or `save_editor`).

The API also exposes engine/mod compatibility metadata in `engine_compat`, `mod_compat`, `relationships`, `cooperation`, and `ownership`.

The shipped engine-compatibility metadata includes explicit 0.1.81, 0.1.82, and 0.1.83 profiles. The manifest range for this candidate is `>=0.1.81 <0.1.84`. Gen1Recomp Mod API remains 2 across the audited 0.1.83 source; this is independent of Nuzlocke Compatibility API v27.

## Policy queries

### `canCapture(game, battle, species)`

Returns:

```text
allowed:boolean, reason:string|nil, details:table|nil
```

A denied Maximum BST result may include `details.bst` and `details.maximum`. A denied glitch result may include the glitch-classification record.

`reason` may also be `type_lock` when an otherwise catchable Pokémon does not match the active Monolocke/Duolocke type set. Type Locke is evaluated before Shiny/area/Dupes exceptions for new acquisitions, so a caller should treat it as a hard acquisition-eligibility denial. Existing owned Pokémon are not deleted or retroactively invalidated. Off-type wild encounters are not counted as failed encounters by Nuzlocke's own tracker.


```lua
local allowed, reason, details = compat.canCapture(game, battle, species)
if not allowed then
  -- Do not commit the custom capture transaction.
end
```

### `canUseItem(game, itemId, context)`

Returns:

```text
allowed:boolean, code:string|nil, decision:table|nil
```

`context` is optional. Useful fields include `data`, `save`, `target`, and semantic fields appropriate to the caller.

```lua
local allowed, code, decision = compat.canUseItem(game, itemId, {
  data = game.data,
  save = game.save,
  target = mon,
})
```

### `canPurchase(game, context)` / `canSell(game, context)`

These queries deliberately describe supported **item-shop** transactions. Use a semantic context such as:

```lua
local allowed = compat.canPurchase(game, { kind = "item_shop" })
local allowed = compat.canSell(game, { kind = "item_shop" })
```

They do not reinterpret every money-changing service as a Poké Mart transaction.

### `canGamble(game)`

Returns `false` when Nuzlocke's active gambling restriction owns the supported transaction.

## Level caps

### `getNextLevelCapInfo(save)`

Returns a record shaped like:

```lua
{
  cap = 21,
  level = 21,
  boss = "Misty",
  name = "Misty",
  maximum = false,
  source = "AUTHORITATIVE_LIVE",
}
```

The authoritative live-cap path is shared by enforcement and status displays.

`level_cap_source` describes the current cap-source model.

### External level-cap providers

A discovered `level_caps` provider may be a direct function or a table exposing a supported alias such as:

```text
get_next_cap / getNextCap / get_cap / getLevelCap /
get_level_cap / next_cap / nextCap
```

Postgame providers may expose `get_stages` or `getStages`. Provider results accept common cap/name aliases. Nuzlocke retries table methods with the provider table as `self` when the free-function shape is invalid.

## Species and acquisition metadata

### `getSpeciesBST(game, species)`
Returns the best reliable merged/provider-backed BST known to Nuzlocke, or `nil` when it cannot be determined safely.

### `getMaximumBST()`
Returns the currently configured Maximum BST rule value.

### `getGlitchSpeciesInfo(game, species)`
Returns the conservative glitch-classification record used by Nuzlocke.

### `isGlitchSpecies(game, species)`
Boolean convenience query.

### `species_metadata` provider

A provider may advertise `species_metadata` and expose one of:

```text
get_metadata(game, species)
metadata(game, species)
get_species_metadata(game, species)
```

The returned table may supply legendary/mythical classification and optional BST/base-stat metadata. Unknown/incomplete stat data is not guessed for Maximum BST enforcement.

## Pokémon identity

### `getPokemonId(mon)`
Reads an existing stable Nuzlocke Pokémon identity without forcing a new one.

### `ensurePokemonId(mon, game, origin)`
Explicitly ensures a Nuzlocke-owned stable token when an integration genuinely needs one.

### `pokemon_identity` provider

A provider that recreates or extends Pokémon objects may advertise `pokemon_identity` with one of:

```text
get_id(mon, game)
get_identity(mon, game)
get_pokemon_id(mon, game)
```

Return a stable string/number for the same Pokémon across save/load/evolution. Nuzlocke preserves unrelated Pokémon fields and does not treat fingerprints as the preferred long-term identity source.

## Battle classification

### `classifyBattle(game, battle, species)`
Read-only, generation-neutral classification. It does not mutate encounters, rule state, parties, or story progression.

The same classifier is exported as:

```lua
nuz.exports.battle_classifier.api       -- 1
nuz.exports.battle_classifier.classify  -- function
```

Convenience queries:

- `isRivalBattle(battle)`
- `isFirstRivalForgivenessActive(game, battle)`
- `isStaticEncounter(game, battle)`

## Encounter-area projection

### `projectEncounterArea(mapId, safari, x, y, width, height)`
Projects physical map/provenance information into the current R/B/Y encounter-area split mode.

### `getEncounterSplitModes()`

Returns the active split configuration. The legacy numeric `routes` field is retained as `0` for compatibility; current R/B/Y callers should read `route_2`, `route_10`, and `route_20` independently, alongside `mt_moon` and `safari`.

## Starter randomization

### `selectRandomStarter(game, original)`
Also available as:

```lua
nuz.exports.starter_randomizer = {
  api = 1,
  select = ...,
}
```

The Nuzlocke implementation randomizes only the starter acquisition and preserves the surrounding story choice path.

## Game/profile helpers

- `getGameVersion()`
- `getGameProfile()`
- `game_profiles`

These expose Nuzlocke's game-version profile view without requiring an integration to reproduce version tables.

## Compatibility reports and relationships

### `getCompatibilityReport()`
Returns the current compatibility API, runtime environment, audited engine profile, and discovered mod-relationship report.

### `getModRelationship(modId, capability)`
Returns one of:

- `compose`
- `delegate`
- `exclusive`
- `observe`
- `incompatible`

### `getGen2Coverage(moduleName)` / `getGen2MemberStatus(moduleName, member)`
Read-only access to Gen1Recomp's Gen2Compat coverage when that engine service is available.

## Declaring a provider

Nuzlocke discovers providers through `mod.exports.nuzlocke_provider[capability]`; for backward-compatible cases it can also inspect a matching top-level export.

```lua
mod.exports.nuzlocke_provider = {
  species_metadata = {
    relationship = "delegate",
    get_metadata = function(game, species)
      -- Return only metadata your mod actually knows.
      return { classification = "custom" }
    end,
  },
}
```

Provider discovery is capability-based and revalidated against the active mod set. An installed-but-disabled provider is not treated as authoritative.

## Relationship declaration

Compatibility metadata can declare a relationship through `relationship`, `mode`, or `policy`; legacy `exclusive = true` is also understood for older provider contracts.

General intent:

- **compose** — both systems can participate; preserve predecessor/next behavior.
- **delegate** — Nuzlocke may ask the provider for the authoritative value/decision.
- **exclusive** — the provider explicitly owns the capability for the active context.
- **observe** — read/report without taking transaction ownership.
- **incompatible** — do not attempt cooperative ownership of that capability.

## Shared-seam etiquette

When wrapping a shared hook/menu surface:

1. Call the predecessor/`next` implementation unless the semantic contract explicitly requires a veto.
2. Decorate the returned result rather than rebuilding a fresh list that can erase another participant's entries.
3. Preserve all return values from the predecessor.
4. When your feature is inactive, return predecessor behavior unchanged.
5. Prefer semantic anchors/labels and public registries over hard-coded indices/private internals.

Nuzlocke advertises chain-friendly cooperation for item use, shopping, healing, battle finish, Trainer Card/party/start menus, NPC talk, encounters, and screens where its current implementation supports composition.

## beta.29.3.13 / Compatibility API 26 additions

API 26 is additive and keeps `compatible_from = 10`. It makes recently added challenge systems easier to compose without reading private save keys.

- `isActive(game, battle)` — authoritative Nuzlocke-master activity query.
- `isRuleActive(game, key, battle)` — activity-aware boolean rule query.
- `getRuleValue(key, fallback)` — raw persisted value for integrations that intentionally need enum/numeric state.
- `getTypeLockAllowedTypes()` / `typeLockAllowsSpecies(game, species)` — current Type Locke legality vocabulary/query. Returned type lists are copied.
- `getForgivenessTokens()` — canonical Route Forgiveness balance.
- `getDifficultySelection()` — `{requestedId, activeId, index, available, fallback, name, external, ...}`. `requestedId` remains stable when an external provider is temporarily unavailable; `activeId` reports the safe runtime fallback.
- `dungeonFamily(mapId)`, `dungeonLockActive(game)`, `getDungeonLockState()` — read-only lock-in integration helpers. Lock state is returned as a defensive copy.
- `giftLocationFor(species)` / `tradeLocationFor(species)` — version-aware native Gen-I special-source lookup. A returned location does not by itself prove unique provenance.
- `isDeterministicGiftSource(species)` / `isDeterministicTradeSource(species)` — whether the current native Gen-I catalog can safely infer that source when a provider supplies no location.
- `classifyAcquisition(game, species, source, location)` — conservative provenance helper. Explicit source wins; source-less inference requires a version-valid source and matching reported area; when the location is genuinely unavailable, only a deterministic source is inferred.
- `getMigrationWarnings()` — defensive-copy list of unresolved migration-review notices. In 29.3.13 this can flag an already-migrated legacy Ball-ban/No Catching ambiguity without rewriting the player's current rule.

The ownership table now declares EXP Edging and built-in difficulty metadata written onto Pokémon records (`nuzlockeBankedExp`, `nuzlockeDifficultyProfile`, `nuzlockeDifficultyAI`, `nuzlockeDifficultyStatExp`, `nuzlockeDifficultyPerfectIV`) in addition to the previously documented identity/death/provenance fields.

### Stable difficulty identity

`difficulty_profile` remains the UI/index field for backward compatibility, but it is no longer authoritative once `difficulty_provider_id` exists. Integrations should use `getDifficultySelection()` or `selectedDifficulty()` rather than caching an option-array index. A provider disappearing from the active mod set causes a temporary VANILLA fallback while retaining its requested stable ID.

### Shared warp composition

Dungeon/Gym lock enforcement composes at `warp.destination`. Wrappers must call their predecessor/`next` when they do not veto a transition and should preserve the destination/context values they do not own.

### Acquisition provenance and lock-in composition

`giftLocationFor(species)` and `tradeLocationFor(species)` are **vanilla Gen-I special-source lookup helpers**, not universal provenance oracles and not assertions that a species has only one possible origin; they return no Gen-I fallback on Gold. Use `isDeterministicGiftSource` / `isDeterministicTradeSource` before inferring a source with no reported location. `classifyAcquisition(game, species, source, location)` prefers explicit provider source/location, requires a matching version-valid location for source-less inference, and only infers from an unknown location when that species has deterministic vanilla provenance. Mods should pass explicit `source` and `location` whenever they know them.

Dungeon/Gym lock enforcement composes through the engine's `warp.destination` hook. Nuzlocke calls downstream providers first and evaluates the final resolved destination. Providers should call `next()` exactly once and should not treat Nuzlocke's `nuzlockeLockBlocked` context annotation as ownership of the underlying warp table.

## Translation surface

```lua
local tr = nuz.exports.nuzlocke_translation
tr.api       -- 1
tr.get(source, ...)
tr.source(text)
```

English source strings are the stable lookup keys; missing translations fall back through Gen1Recomp's normal string system.

## Ownership

`mod.exports.owns` is the same ownership table published inside `nuzlocke_compat.ownership`. Integrations should use it rather than guessing which persistent Pokémon fields belong to Nuzlocke.

## Dormant Wonderlocke adapter

`handleWonderTrade(...)` currently returns `false`. The Wonderlocke surface is intentionally reserved but inactive; integrations must not assume that Nuzlocke consumes or replaces Wonder Trade transactions in this release.

## Stability guidance

Treat `mod.exports.nuzlocke_compat`, `nuzlocke_translation`, `starter_randomizer`, `battle_classifier`, and `mod.exports.owns` as the intended developer-facing surface. Names under `mod.exports.__beta26` are implementation scaffolding and should not be treated as a stable external contract.

## History/status semantics

`nuzlocke_history` is persisted run history rather than a versioned public function API. In beta.29.2.0, new owned-Pokémon death rows use `status = "DEAD"`. Legacy `status = "LOST"` death rows may be migrated to `DEAD` when explicit death evidence is present. Failed encounter opportunities remain represented separately by `encounter_states[area].status = "FAILED"`. The legacy `nuzlocke_losses` and `last_loss` save keys are retained for backward compatibility.

## Historical compatibility-API checkpoints

The beta.29.2.0 history-recovery pass preserves two older integration checkpoints for maintainers reviewing old packages or provider contracts:

- beta.21 surviving reconstruction: Nuzlocke Compatibility API v9, save schema 4, Gen1Recomp 0.1.78 audit era.
- beta.27.3: Nuzlocke Compatibility API v11, Gen1Recomp 0.1.79 audit era, including the shared `ItemEffects.use` seam repair and broader capability negotiation.

These are historical compatibility records, not alternate current APIs. Integrations targeting this candidate should use Nuzlocke Compatibility API v26 and the current compatibility floor documented above.

## beta.29.2.2 rule-state additions

Two persisted boolean rule keys are added without changing the Nuzlocke Compatibility API version: `gym_lock_in` and `dungeon_lock_in`. They are ordinary Nuzlocke rule state, not new provider contracts. Dungeon lock state is internal and must not be treated as a public compatibility API.


## 29.3.3 additions
`mod.exports.__beta26.forgivenessTokens()` returns the current Route Forgiveness token balance. `mod.exports.__beta26.forgivenessTokenShopPrice` is `1000000`. These are additive compatibility helpers in Compatibility API 26.

## Randomizer runtime surface — beta.30.0.0.1
`mod.exports.randomizer` (`api = 1`) exposes `apply(game)`, `applyEncounters(game)`, and `applyLearnsets(game)`. Choices persist in Nuzlocke save data. Encounter transforms own only `species`; learnset transforms own only `level1Moves` and `learnset[].move`.

## 2.0.0-beta.30.0.0.2
The shared item-use policy now classifies fishing rods for the `no_fishing` rule.

## 2.0.0-beta.30.0.0.3
## Interoperability API v1
`mod.exports.nuzlocke` exposes:
- `interop.registerProvider(provider)`, `unregisterProvider`, `hasCapability`, `providersWith`, `on`, `emit`
- `acquisitionPolicy.classify(context)` and `evaluate(context)`
- `itemPolicy.classify(context)` and `evaluate(context)`
- `registry.effectivePokemon(game)`, `effectiveEncounters(game)`, `effectiveMoves(game)`, `effectiveLearnset(species, game)`, `changed(...)`
- `experience.capAward(context)` as the explicit post-distribution composition seam

Provider capabilities are intentionally generic. External mods should declare behavior/capabilities rather than requiring Nuzlocke to recognize their package name.

## 2.0.0-beta.30.0.0.4
## Interop API v1 additions — 30.0.0.4
- `itemPolicy.beforeUse(context)` / `canUse(context)` / aliases `check`, `checkUse`
- `acquisitionPolicy.begin(context)` / `commit(context)` / `KINDS`
- `encounterPolicy.evaluate(context)`
- `pcPolicy.evaluate(context)` / `can(context)`
- `registry.getRevision()` / `registry.describe(game)`
- `experience.getCap(game)`

Alternate item UIs should call `itemPolicy.canUse` immediately before invoking the engine item effect. Registry consumers can refresh when `registry_changed` fires or when the revision changes.

## 2.0.0-beta.30.0.0.5
## Tracker persistence invariant — 30.0.0.5
`tracker_log` records must remain plain provenance/data records. UI/provider code must not attach live Pokémon objects or screen-only references to persisted entries; use detached view objects instead.

## 2.0.0-beta.30.0.0.6
## Content Provider API — 30.0.0.6
`mod.exports.nuzlocke.content` exposes:
- `registerArea(def)`
- `registerDungeon(def)`
- `dungeonFamily(mapId)`
- `registerBoss(def)`
- `registerGift(def)`
- `registerEncounter(def)`
- `setEncounterRandomizerPolicy(id, policy)`
- `setLearnsetRandomizerPolicy(species, policy)`
- `shouldRandomizeEncounter(context)`
- `shouldRandomizeLearnset(species, def)`
- `registerBundle(bundle)`
- `describe()`

`registerBundle` accepts provider metadata plus `areas`, `dungeons`, `bosses`, `gifts`, `encounters`, `randomizerEncounterPolicies`, and `randomizerLearnsetPolicies`. Story-critical encounter/species records may also expose `randomizable=false` / `nuzlockeRandomizable=false`.

## 2.0.0-beta.30.0.0.7
## Automatic compatibility adapter
`mod.exports.nuzlocke.autoCompat` exposes `scan()`, `install()`, `snapshotPokemon(game)`, `reconcilePokemon(game, sourceHint)`, `beforeExternalItemUse(context)`, `beforeExternalEncounter(context)`, `beforeExternalPCAction(context)`, and `registrySnapshot(game)`. Automatic provider records use `automatic=true` and `source="legacy_adapter"`; explicit registered providers take precedence.

## 2.0.0-beta.30.0.0.8
## Capability consolidation — 30.0.0.8
`interop.resolveCapability(capability)` returns the canonical capability, whether it is supplied, explicit providers, automatic adapters, and the preferred provider. Explicit registration always wins over inferred legacy adapters.

Canonical families:
- `item_provider`
- `storage_provider`
- `encounter_provider`
- `exp_provider`
- `registry_consumer`
- `quest_content_provider`

`mod.exports.nuzlocke.ownership` documents mechanic/policy ownership. External mods may own mechanics; Nuzlocke owns challenge policy and provenance unless a selected rule explicitly delegates them.

## 2.0.0-beta.30.0.0.9
## Rule delegation API — 30.0.0.9
`mod.exports.nuzlocke.delegation.statusForRule(ruleKey, game)` returns provider ownership metadata for delegable non-core controls, or nil when Nuzlocke owns the mechanic. `delegation.rules` exposes the current rule-to-capability map.

Delegation is effective-state only: the user's stored Nuzlocke value is preserved dormant. Consumers should treat a non-nil delegation result as external mechanic ownership and should not write the duplicate Nuzlocke setting.

## 2.0.0-beta.30.0.0.11
## Engine compatibility — 30.0.0.11
The manifest accepts Gen1Recomp 0.1.84 while remaining on Mod API 2. No Nuzlocke public API contract was intentionally changed in this checkpoint.

## 2.0.0-beta.30.0.0.12
## Engine/API compatibility policy — 30.0.0.12
Nuzlocke continues to target Mod API 2 while allowing Gen1Recomp `>=0.1.81 <1.0.0`. A loader-compatible future engine is not automatically a runtime-certified engine. Public Nuzlocke API and save schema are unchanged.

## 2.0.0-beta.30.0.0.13
## 30.0.0.13 startup compatibility
No public Nuzlocke API contract changed. `ui.title_menu.items` remains the primary engine seam. Internal title-class adapters are fallback-only and require the already-declared `engine_internals` permission.

## 2.0.0-beta.30.0.0.14
## 30.0.0.14 parser hotfix
No API changes. The 30.0.0.13 internal compatibility fallback was structurally isolated into a nested Lua function to stay under the runtime parser's top-level local-variable limit.

## 2.0.0-beta.30.0.0.15
## Multi-file structure — 30.0.0.15
The title compatibility adapter is loaded from the mod's own directory using `mod:read("title_setup_compat.lua")` plus the sandbox-provided `load`. This follows Gen1Recomp 0.1.86 Sandbox guidance for multi-file mods. No public Nuzlocke API changed.

## 2.0.0-beta.30.0.0.16
## Module structure — 30.0.0.16
`trainer_rewards.lua` is sandbox-loaded through `load(mod:read(...))` and receives explicit dependencies from `main.lua`. Existing `mod.exports.__beta26.forgivenessTokens`, `installForgivenessTokenBagBridge`, and `withForgivenessTokenStock` exports are preserved by the module. No intended public API removal.

The late runtime installer uses a temporary internal `mod.exports.__beta26._lateRuntimeInit` function only during initialization, then clears that field. It is not a public compatibility API and should not be consumed by other mods.

## 2.0.0-beta.30.0.0.17
## 30.0.0.17
No public API changes. Permanent Rule Seal UI activation now uses an internal three-stage state (two warnings plus commit) with cancellation/debounce safeguards.

## 2.0.0-beta.30.0.0.18
## Permanent Rule Seal persistence — 30.0.0.18
Internal helpers `persistPermanentRuleSeal(game)` and `readPermanentRuleSeal(game)` mirror the irreversible seal to `mod.storage` key `rules/permanent_seal`. This is an internal durability mechanism, not a new provider contract. Standard Nuzlocke rule configuration remains in `mod.save`.

## 2.0.0-beta.30.0.0.19
## Dormant Permanent Rule Seal recovery map — 30.0.0.19

Permanent Rule Seal is gated by `mod.exports.__beta26.permanentRuleSealWip = true`.

The implementation remains in `main.lua`. Recovery points:
- durable storage key: `rules/permanent_seal`
- save marker: `rules_permanently_locked`
- effective lock key: `rules_locked`
- writer: `persistPermanentRuleSeal(game)`
- reader: `readPermanentRuleSeal(game)`
- UI activation block: `NuzlockeConfigScreen` branch for `item.rule.key == "rules_locked"`
- lifecycle reconciler: `enforcePermanentRuleLock(payload)`
- preserved confirmation flow: WARNING 1/2 -> FINAL WARNING 2/2 -> final commit
- intended eventual scope: challenge rules only; Game Difficulty, QoL, World Building, and UI/presentation remain adjustable.

While WIP, the UI refuses activation and lifecycle handling clears only effective `rules_locked`. It intentionally does **not** erase `rules_permanently_locked` or the `rules/permanent_seal` storage record, preserving recovery/migration evidence.

## 2.0.0-beta.30.0.0.20
## Dialogue presentation invariant — 30.0.0.20
`mod.exports.__beta26.pushWorldText(game, ...)` now returns `false` whenever an active state-stack entry has `isTextBox == true`. Callers must continue treating World Building presentation as optional; no mechanical rule may rely on successful flavor-text display.

## 2.0.0-beta.30.0.0.21
## Maximum BST preset UI — 30.0.0.21
The UI exposes OFF / 400 / 450 / 500 / 550, but `getMaximumBST()` continues returning the actual threshold (0/400/450/500/550, or an untouched legacy custom value until changed). `maximumBstPresetValues`, `maximumBstPresetLabels`, and `maximumBstPresetIndex(value)` are internal beta helpers, not a new compatibility API version.

## 2.0.0-beta.30.1.0 compatibility notes

The active-TextBox presentation guard introduced in 30.0.0.20 is now runtime-supported by the tested Yellow Poké Mart regression case. `pushWorldText(game, ...)` must continue to return `false` rather than opening optional World Building text when a TextBox is already active. This is a presentation contract only; mechanical rule enforcement must not depend on successful flavor-text display.

The approved internal module structure remains:
- `main.lua`
- `title_setup_compat.lua`
- `trainer_rewards.lua`

No additional module boundary is introduced in 30.1.0.

Permanent Rule Seal remains dormant behind its WIP gate. The existing recovery map, storage key, save marker, writer/reader helpers, activation block, and lifecycle reconciler remain preserved for future deliberate reactivation.

## Gold title compatibility rollback boundary — 30.1.1

The post-29.1.0 `src.ui.gen2.MainMenu:buildList()` fallback in `title_setup_compat.lua` is dormant.

Gold Setup currently relies on:
1. shared `ui.title_menu.items` injection in `main.lua`;
2. Gold `MainMenu:choose()` handling of `nuzlocke_setup` in `main.lua`.

The disabled fallback implementation is retained verbatim in a Lua long comment in `title_setup_compat.lua`. This is deliberate recovery material, not live API behavior.

## 2.0.0-beta.30.1.2 release status

No public API behavior change is intended from 30.1.1.

Gold fresh NEW GAME -> Nuzlocke SETUP is a known runtime-crash path. The newer Gold `MainMenu:buildList()` fallback remains disabled and preserved as dormant recovery code. The crash therefore cannot currently be attributed solely to that fallback and requires future investigation across the remaining shared title-hook / `MainMenu:choose()` / `NuzlockeConfigScreen` transition.

Consumers must not infer Gold fresh-Setup availability from the presence of the title row.

## 30.1.3 diagnostic exports

`mod.exports.__beta26.pushNuzlockeConfigScreen(game, opts)` protects the complete public screen push. `mod.exports.__beta26.lastConfigScreenError` stores the latest synchronous failure. These are diagnostic beta surfaces, not a compatibility API version bump.

## 30.1.4 diagnostic runtime guard

`NuzlockeConfigScreen` wraps its instance `update()` and `draw()` methods with protected calls. Failures are mirrored into `mod.exports.__beta26.lastConfigScreenError`. This is temporary diagnostic behavior, not a stable API.

## 30.1.5 Setup profile bridge

`mod.exports.__beta26.sessionSetupProfiles` temporarily stores copied `gen1` and `gold` pre-game profiles for the running process. This replaces the legacy direct filesystem-based Setup-profile preference layer.

This is an internal compatibility bridge, not a stable public API.

## 2.0.0-beta.30.1.6

No compatibility API version bump is introduced.

The 30.1.5 session-local Setup-profile bridge remains active and is now runtime-validated for fresh Gold and Yellow Setup. `mod.exports.__beta26.sessionSetupProfiles` is still an internal beta implementation detail rather than a stable public API.

The diagnostic `lastConfigScreenError` / guarded screen opener remain present for compatibility diagnostics but are not promoted as public API guarantees.
