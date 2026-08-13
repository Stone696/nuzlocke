# Changelog

## 2.0.0-beta.27.16 — final reported-bug hardening

### Fixed

- Gold Game Corner `Specials.HANDLERS` and `Specials.ALL` entries are now captured, wrapped, and restored independently. The adapter no longer manufactures a handler in a registry where vanilla or another mod left the slot absent.
- Gold Nickname Rule is again installed and exposed on the reduced Gold configuration surface.
- Gold catches cannot decline a required nickname, and empty or all-space nickname entries cannot close the native naming screen.
- Gold `givepoke` acquisitions—including the Johto starter—now use the VM's blocking rename seam, preserving the exact story-command continuation point.
- The Gold Ball gate now accepts explicit static/fixed provenance in addition to the native `battle.wild` shape, supporting fixed encounters constructed by other mods.
- Ball Use tier 4 is displayed as `STANDARD` instead of the misleading `MASTER`, and its messages correctly explain that specialty/custom Balls remain eligible. Tier 5 `ALL` retains the every-Ball ban.

### Verified false positives and hardening

- R/B/Y `GAME_CORNER_PRIZE_ROOM` and Gold `CELADON_GAME_CORNER_PRIZE_ROOM` are intentionally different engine IDs. They are now centralized in one generation-specific table so future edits cannot conflate them.
- Native Gold `loadwildmon` scripted encounters already create `opts.wild`, and `Battle.new` sets `battle.wild = true`; No Static was reachable for stock fixed encounters. The broader explicit-provenance predicate was added for mod compatibility.
- Ball Use tiers were already cumulative and mechanically distinct: tier 4 bans the four standard Balls while tier 5 additionally bans specialty/custom Balls. The release changes presentation, not persisted mechanics.

### Release gate

- Expanded the structural/engine gate to 66 checks.
- Expanded the headless interaction smoke suite to 49 checks, including Gold catch/gift nickname enforcement, exact wrapper restoration, native and mod-created static battles, and distinct ULTRA/STANDARD/ALL Ball behavior.

## 2.0.0-beta.27.15 — repository release-candidate hardening

### Fixed

- Gold boss progression now recognizes the Gen 2 trainer-battle shape instead of requiring Gen 1's `battle.kind == "trainer"` field.
- Existing R/B/Y saves seed Elite Four and Champion completion from story flags.
- Existing Gold saves seed Johto/Kanto Gym and League progression from named badges and story flags.
- Corrected the Johto middle-Gym order to Chuck → Pryce → Jasmine while retaining live ace-level lookup.
- Level caps can no longer regress when a trainer overhaul makes an earlier defeated boss stronger than the next boss.
- Unknown/future Gen 1 version identifiers now fall back safely to the Red cap table instead of indexing `nil`.
- Malformed fractional `level_cap_scope` save values are normalized to a valid integer enum.
- Dynamic `trainer.party` cap observations are invalidated after the active mod set changes.
- Compatibility API report version now matches the exported API v22.
- Every advertised compatibility capability now has an explicit default relationship.
- World Building battle flavor can use Gold's event queue as well as Gen 1's message queue, preserving native intro order.
- Title-menu save detection accepts native labels or stable Gold values, prevents duplicate Nuzlocke Setup insertion, and remains new-game-only.

### Compatibility

- External level-cap providers may be direct functions or tables using `get_next_cap`, `getNextCap`, `get_cap`, `getLevelCap`, `get_level_cap`, `next_cap`, or `nextCap`.
- Provider results accept `cap`, `level`, `ace`, `max_level`, `maxLevel`, or `levelCap`, plus common boss/stage naming fields.
- Postgame stage providers accept `get_stages` or `getStages` and the same cap aliases.
- Provider methods are retried with the provider table as `self` when the free-function call shape is not valid.

### Release gate

- Added a dependency-free Node structural/engine compatibility gate.
- Added a headless Lua smoke harness covering live Gen 1 and Gold boss caps, Gold League progression, save-aware Setup visibility, reversible encounter projections, Maximum BST, MissingNo, static-vs-shiny precedence, provider aliases, and World Building text cleanup.

## 2.0.0-beta.27.14 — live boss-cap compatibility

- Centralized the authoritative next-cap calculation used by enforcement and every status UI.
- Reads final merged trainer rosters so Gym, Elite Four, Champion, and Gold boss level edits from other mods are reflected live.
- Observes composed `trainer.party` results for dynamically generated or runtime-modified teams.
- Added public `getNextLevelCapInfo` compatibility output.

## 2.0.0-beta.27.13 — encounter-area splits

- Added OFF/CARDINAL splitting for every numbered Kanto route, Route 1 through Route 25.
- Added OFF/COMMON floor splitting for Mt. Moon.
- Added OFF/COMMON area splitting for Safari Zone Center, East, North, and West.
- Added immutable physical-map provenance and reversible live reprojection for tracker logs, encounter states, caught areas, visited areas, Catch Info, failure summaries, and Pokémon history.

## 2.0.0-beta.27.6 through beta.27.12 — consolidated rule and interaction pass

- Cleaned World Building presentation, spacing, once-per-save flags, and duplicate presentation paths.
- Added Maximum BST acquisition restriction with merged-registry/provider metadata and fail-open handling for unknown stat schemas.
- Added safe MissingNo/glitch classification, blocking, opt-in acquisition, UI labeling, and preservation of existing Pokémon.
- Added opening Rival forgiveness, ON by default and OFF in Hardcore, with faint and Whiteout consequences forgiven only for that battle.
- Added Static Encounter Ban based on encounter provenance rather than species lists.
- Added Celadon/Gold Game Corner gambling and prize-redemption bans at pre-mutation transaction points.
- Expanded rule/UI, compatibility, Save Editor, item-use, acquisition, and Gold adapter audits while preserving save schema 4.

## Earlier history

The beta.27 line descends directly from the runtime-tested beta.26/25D4-RBY2 work. Earlier release history remains available in the repository's previous tags and packages; beta.27.16 does not reset or migrate the save schema.
