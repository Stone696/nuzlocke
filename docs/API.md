# Developer API

This document describes the supported integration surface exported by Nuzlocke `2.0.0-beta.29.1.0`. It is intended for mod authors who want to query Nuzlocke policy or cooperate with shared engine seams without reading internal implementation details.

## Discovering Nuzlocke

```lua
local nuz = mod.find("nuzlocke")
if not (nuz and nuz.exports) then return end
local compat = nuz.exports.nuzlocke_compat
if not compat then return end
```

`mod.find` should be treated as optional: a missing, disabled, failed, or not-yet-loaded mod may return `nil`.

## Compatibility API identity

- `mod.exports.nuzlocke_compat.version = 25`
- `compatible_from = 10`
- `audited_recomp = "0.1.83"`
- `runtime_environment()` returns the current Nuzlocke loader environment (`gameplay` or `save_editor`).

The API also exposes engine/mod compatibility metadata in `engine_compat`, `mod_compat`, `relationships`, `cooperation`, and `ownership`.

The shipped engine-compatibility metadata includes explicit 0.1.81, 0.1.82, and 0.1.83 profiles. The manifest range for this candidate is `>=0.1.81 <0.1.84`. Gen1Recomp Mod API remains 2 across the audited 0.1.83 source; this is independent of Nuzlocke Compatibility API v25.

## Policy queries

### `canCapture(game, battle, species)`

Returns:

```text
allowed:boolean, reason:string|nil, details:table|nil
```

A denied Maximum BST result may include `details.bst` and `details.maximum`. A denied glitch result may include the glitch-classification record.

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
Returns current numeric modes for `routes`, `mt_moon`, and `safari`.

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
