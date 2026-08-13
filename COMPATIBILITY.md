# Compatibility contract

## Engine target

- Manifest API: 2
- Supported version range: `>=0.1.78 <2.0.0`
- Audited Gen1Recomp source/release: 0.1.79
- Save schema: 4
- Games declared: Gen 1 and Gold

The mod uses `engine_internals`, so compatibility is validated at both public hook/event seams and guarded direct-wrapper seams. Runtime wrappers are session-owned and are not installed by the embedded Save Editor loader.

Gold nickname and Game Corner replacements preserve the exact method/registry slot they wrap. On a loader-session change, the mod restores only its own still-live wrapper; it does not overwrite a later replacement installed by another mod. `Specials.HANDLERS` and `Specials.ALL` remain independent.

## Inter-mod behavior

`nuzlocke_compat` v22 advertises 24 behavioral capabilities. Every capability has an explicit default relationship:

- `compose`: both mods participate and wrappers preserve the next/previous implementation;
- `delegate`: an external provider supplies authoritative data consumed by Nuzlocke;
- `exclusive`: the provider owns the mechanic and Nuzlocke does not duplicate it;
- `observe`: read-only/telemetry integration;
- `incompatible`: reported as unsafe instead of silently combined.

Level-cap and postgame-cap providers default to `delegate`. Encounter providers default to `compose`. Pokémon identity/species metadata providers default to `delegate`.

Provider discovery is capability-based. The mod never identifies another mod by display name or description, and provider code is not executed merely to discover compatibility metadata.

## Trainer and level-cap mods

No dedicated provider is required when a mod patches the merged trainer registry or composes the public `trainer.party` hook. Nuzlocke reads those final rosters and uses their highest valid level as the boss ace.

An explicit `level_caps` provider takes precedence when active. It may be a function or table method and may return a number or a table. See the aliases listed in CHANGELOG.md. After a mod reload, runtime-observed teams are cleared so stale data cannot survive a disabled/replaced trainer mod.

## Save and encounter provenance

Nuzlocke-owned Pokémon identity and encounter provenance fields are additive. Split-mode projection preserves the physical encounter map separately from its current display/legal area. Unknown mod maps are accepted when their IDs are safe identifiers, so content mods are not rejected solely for adding areas.

Unknown/incomplete modded BST data fails open. Explicit species metadata providers can supply classification, glitch flags, legendary/mythical flags, direct BST, or base stats.

Native Gold `loadwildmon` battles use the engine's ordinary non-trainer `battle.wild` shape. For compatibility, No Static also accepts the explicit provenance fields advertised by `isStaticEncounter`, allowing a mod-created fixed battle to reach the pre-throw gate even when it did not use native `opts.wild` construction.

Ball Use Ban tier 4 (`STANDARD`) blocks only the four strength-ranked standard Balls. Unranked Balls identified through item metadata, the Ball pocket, or another item's Ball registry remain eligible until tier 5 (`ALL`). This distinction supports Gold's specialty Balls and custom item mods without requiring their names to be hard-coded.

## Guarded fallback hooks

`battle.nickname` and `battle.use_item` are registered as compatibility fallbacks for engine builds that expose them. Current authoritative enforcement also has guarded direct transaction adapters because those public hooks are not present in every audited build. The release gate treats these two registrations as fallback-only rather than claiming the current engine emits them.
