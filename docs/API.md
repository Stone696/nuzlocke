# Nuzlocke 2.4.0 API status

2.4.0 keeps the established public compatibility numbering:

- **Compatibility API:** 27
- **Save schema:** 4
- **Mod API:** 2
- **Engine range:** `>=0.1.86 <0.1.99`

No public API number was bumped during the 2.4.0 promotion from 2.3.35 RC.

## Additive compatibility surfaces introduced since 2.3.12

The 2.3.13–2.3.35 line added or hardened the following additive semantics:

- trainer-capture acquisition provenance (`trainer_capture` aliases including SNAG-style contexts);
- semantic custom-Ball classification through live item metadata / Gold Ball pocket / registered item effects;
- provider-safe learnset ownership/delegation;
- storage transaction policy API 2: WITHDRAW / DEPOSIT / RELEASE / SWAP;
- final composed encounter registry and encounter-information reveal policy;
- raw vs effective dependent-rule reads through `getEffectiveRuleValue(...)`;
- semantic translation source/catalog exports;
- generic `nuzlocke_ui` screen ownership metadata;
- MOD COMPAT semantic model detail paging;
- Gym Team Size exact next-Leader battle-context helpers;
- direct built-in Difficulty composition for cap projection while retaining generic external `trainer.party` composition.

All new surfaces are additive; existing 2.3.12 compatibility consumers should continue to degrade safely when they do not use them.

---

## 2.3.35 RC API status

No API changes. Compatibility API remains **27** and save schema remains **4**.

MOVE INFO still consumes the same read-only move fields; only its native presentation layout changed.

## 2.3.34 RC API status

Compatibility API remains **27** and save schema remains **4**.

MOD COMPAT's semantic model now includes `detailPage` and advertises Select/Tab detail paging. R/B/Y MOVE INFO keeps the same read-only Pokémon/move data and only changes its native presentation layout.

## 2.3.33 RC API status

Compatibility API remains **27** and save schema remains **4**.

No public contract was removed or version-bumped. Built-in Difficulty cap previews now call the existing internal `Difficulty.composeParty()` transformation directly; external trainer providers remain composed through the public `trainer.party` hook.

## 2.3.32 RC API status

Compatibility API remains **27** and save schema remains **4**.

Additive semantic helpers:

- `nuzlocke_compat.isNextGymLeaderBattleContext(game, context)`
- `nuzlocke_compat.gymTeamSizeRejectionText(game, info, partyCount)`

Gym Team Size now composes with Gen1Recomp's public `trainer.before_battle` preparation seam for standard trainer interactions while retaining the scripted command compatibility gate.

## 2.3.31 RC API status

No API-number changes. Compatibility API remains **27**, `nuzlocke_ui.api` remains **1**, `nuzlocke_translation.api` remains **1**, `pcPolicy.api` remains **2**, and save schema remains **4**.

The R/B/Y NUZ INFO semantic model now exposes the currently selected Catch/Stat/Move page and page count while retaining the same underlying read-only Pokémon information.

## 2.3.30 RC API status

No API changes. Compatibility API remains **27** and save schema remains **4**.

Difficulty provider discovery now requires `mod.find(providerId)` to resolve a real loaded provider before a historical provider ID is returned by `detectDifficultyProviders()`.

## 2.3.29 RC API additions

Compatibility API remains **27** and save schema remains **4**.

New effective-policy helpers:

- `__beta26.effectiveRandomSpeciesGeneration()`
- `__beta26.effectiveRandomLearnsetGeneration()`
- `nuzlocke_compat.getEffectiveRuleValue(key, fallback)`

Raw stored preferences remain available through `getRuleValue`. Effective reads return AUTO/0 for Species Pool or Learnset Gen whenever their owning randomizer is OFF.

## 2.3.28 RC API status

No compatibility-policy API-number change. Compatibility API remains **27** and save schema remains **4**.

`nuzlocke_ui.screens` now also describes `NuzlockeModCompatScreen` as a `compatibility_status` presentation with Nuzlocke-owned state and wide preferred layout.

The MOD COMPAT semantic presentation model includes:
- `columns`
- `rows`
- selected `index`
- `scroll`
- plain-language `details`
- `footer`

This is presentation metadata only.

## 2.3.27 RC API status

No API-number changes. Compatibility API remains **27**, `nuzlocke_ui.api` remains **1**, `nuzlocke_translation.api` remains **1**, `pcPolicy.api` remains **2**, and save schema remains **4**.

`getPokemonNuzInfo()` keeps the same return shape; its read-only shiny field no longer depends on a later lexical module.

## 2.3.26 RC API status

No API changes. Compatibility API remains **27**, `nuzlocke_ui.api` remains **1**, `nuzlocke_translation.api` remains **1**, `pcPolicy.api` remains **2**, and save schema remains **4**.

ENC TRACKER still publishes generic presentation metadata, but its Gen 1 dimensions are no longer delegated by detecting Wide Menus.

## 2.3.25 RC API additions

Compatibility API remains **27** and save schema remains **4**.

### Storage transactions

`nuzlocke.pcPolicy.api = 2`

- `pcPolicy.describe(context)`
- `pcPolicy.evaluate(context)` / `evaluateTransaction(context)`
- `pcPolicy.can(context)` / `canTransaction(context)`
- `pcPolicy.begin(context)`
- `pcPolicy.commit(context)`

Recognized semantic actions: `WITHDRAW`, `DEPOSIT`, `RELEASE`, `SWAP`.

For SWAP, providers should identify the box Pokémon entering the party as `incoming` / `toParty` / `boxMon`, and the party Pokémon leaving as `outgoing` / `fromParty` / `partyMon`.

Events:

- `storage_transaction_begin`
- `storage_transaction_commit`

### Encounter information

The gameplay registry remains:

- `nuzlocke.registry.effectiveEncounters(game)`

Information consumers may use:

- `registry.encounterInformationPolicy(game)`
- `registry.canRevealEncounterInformation(context)`
- `registry.encounterInformation(context)`

`randomizer_info_policy`: `0 = OPEN INFO`, `1 = BLIND INFO`.

BLIND INFO is a cooperative presentation contract; it never returns a modified registry to encounter-generating gameplay code.

## 2.3.24 RC API status

No API changes. Compatibility API remains **27**, `nuzlocke_ui.api` remains **1**, `nuzlocke_translation.api` remains **1**, and save schema remains **4**.

The existing historical `ironmon_ultimate` difficulty-provider recognition is intentionally preserved for backwards compatibility.

## 2.3.23 RC API status

No API changes. Compatibility API remains **27**, `nuzlocke_ui.api` remains **1**, `nuzlocke_translation.api` remains **1**, and save schema remains **4**.

## 2.3.22 RC — `nuzlocke_ui` API 1

New additive export:

- `nuzlocke_ui.api = 1`
- `nuzlocke_ui.stateOwner = "nuzlocke"`
- `nuzlocke_ui.screens`
- `nuzlocke_ui.describeScreen(screenOrId)`

Screen metadata may include `role`, `stateOwner`, `preferredLayout`, `nativeFallback`, and `semanticAdapterSafe`.

This API is presentation-only. It does not transfer Nuzlocke rule, tracker, save, or action ownership to the presenter. Compatibility API remains **27** and save schema remains **4**.

## 2.3.21 RC compatibility helper

Compatibility API remains **27** and save schema remains **4**.

Existing compatibility surface adds:

- `nuzlocke_compat.reconcileDungeonLockState(game, mapId)`

The helper clears transient Dungeon Lock-In state when the actual current map no longer belongs to the owning dungeon family or when the rule is disabled.

## 2.3.20 RC translation API additions

`nuzlocke_translation.api` remains **1** and Compatibility API remains **27**.

Additive helpers:

- `nuzlocke_translation.sources()` → array of `{ source, kind, key }`
- `nuzlocke_translation.catalog()` → source-string to currently resolved translation map

The source list is generated from canonical live rule-category definitions rather than a duplicate table.

## 2.3.19 RC API additions

Compatibility API remains **27**; these are additive values inside existing API tables.

- `nuzlocke.acquisition.KINDS.trainer_capture = true`
- acquisition aliases `TRAINER_CAPTURE`, `TRAINER_CATCH`, and `SNAG`
- `trainerCapture`, `trainer_capture`, or `snag` context booleans classify as `trainer_capture`
- public Item API `classify()` now uses dynamic Ball metadata rather than the vanilla Ball ID list

Existing callers remain compatible.

## 2.3.18 RC API status

Compatibility API remains **27** and save schema remains **4**. This pass changes presentation fitting only; no public API behavior changed.

## 2.3.17 RC API status

Compatibility API remains **27** and save schema remains **4**. No public API behavior changed in this small pass.

## 2.3.16 RC API status

Compatibility API remains **27** and save schema remains **4**. No public contract changed. Provider acquisition provenance receives stricter precedence, and Gold damage overrides are now scoped to copied call data.

## 2.3.15 RC API status

Compatibility API remains **27**, `battle_classifier.api` remains 1, and save schema remains 4. No public API number changes. Internal learnset ownership now treats every delegated provider as authoritative.

## 2.3.14 RC API status

No public API number changes. Compatibility API remains 27 and save schema remains 4. This candidate changes tracker layout ownership, Running Shoes input gating, and internal numeric config persistence only.

## 2.3.13 RC current API status

2.3.13 RC is a presentation-surface hotfix candidate only. **Compatibility API remains 27**, `battle_classifier.api` remains 1, and save schema remains 4. No provider contract or rule semantic is intentionally changed from 2.3.12.

## 2.3.12 current API status

2.3.12 is the final release child of 2.3.11 RC and preserves the complete restored API/provider surface without an API-number change. **Compatibility API remains 27**, `battle_classifier.api` remains 1, and save schema remains 4. The 2.3.0 battle snapshot/contextual-field compatibility additions, Skip Opening Intro delegation surface, and Quick Nuzlocke Start delegation surface remain active.

The 2.3.12 promotion changes release/version metadata only; it does not intentionally alter provider contracts or rule semantics.

## 2.3.11 current API status

2.3.11 restores the protected full API/provider surface from the original 2.3.0 RC through the 2.3.10 → 2.3.11 sequential lineage. Historical 2.3.4–2.3.9 diagnostic/removal notes below describe those older builds and do **not** describe the active 2.3.11 surface.

Compatibility API remains 27 and `battle_classifier.api` remains 1. The 2.3.0 battle snapshot/contextual-field compatibility additions are restored. Skip Opening Intro and Quick Nuzlocke Start provider/delegation surfaces are active again. No API number was changed by the boot-safety initialization changes.

## 2.3.9 diagnostic status

2.3.9 is a diagnostic-only build. The normal gameplay/provider API described below is **not active** in this build. Only static diagnostic exports, `src.core.Strings`, the minimal `NuzlockeConfigScreen`, and the public `ui.title_menu.items` SETUP insertion path execute. API behavior below remains documentation for the protected full implementation and must not be treated as runtime-validated by 2.3.9.

## 2.3.4 startup API note

Nuzlocke no longer wraps `intro.oak_speech.build` for an opening-intro skip, and it no longer exposes or runs the internal Quick Nuzlocke Start progression transaction. No public API version was increased for their removal because neither shortcut was a stable public provider contract.

## 2.3.2 Wide Menus interop note

No `mod.find("wide-menus")` lookup is expected. The supported interop is the screen-instance contract `uiModLayout = "classic"` plus `keepClassicUi = true`; Wide Menus reads those fields. The manifest optional dependency expresses that passive coexistence/load-order relationship, not ownership of Nuzlocke state or a request for a wide canvas.

## 2.3.2 API/interop note

No public API version changes.

Compatibility seam metadata now labels `mod.world:availableFieldActions/useFieldAction` as `transitive_native_guard`: the public facade is observed, while enforcement occurs at the native execution seams it delegates to. This is intentionally distinct from directly composed hooks such as `script.command`.

## 2.3.1 API note — Gen1Recomp 0.1.98 public facades

**2.3.1 startup-safety note:** compatibility feature reporting no longer materializes `mod.battle` or `mod.world` during title/New Game construction; it only reports already-materialized facades.

No existing Nuzlocke public API number is bumped. Compatibility API remains **27** and `battle_classifier.api` remains **1**; the additions are backward-compatible fields/functions.

### `mod.exports.battle_classifier.snapshot()`

On Gen1Recomp 0.1.98+, returns the detached record from `mod.battle:snapshot()` or `nil` outside battle. The record is the engine's generation-neutral view (`revision`, `kind`, `catchable`, `prompt`, messages, battlers, party, moves, and supported items). Mutating it cannot mutate the live battle. Nuzlocke does **not** submit battle intents through this export.

`battle_classifier.classify(game, battle, species)` remains the provenance-aware Nuzlocke classifier for callers that already possess a real battle object/event context.

### Compatibility report

`getCompatibilityReport()` adds `engine_features` booleans:
- `battle_snapshot`
- `battle_submit`
- `contextual_field_actions`

These report facade availability only; they do not imply Nuzlocke has delegated rule ownership.

The audited engine marker is now **0.1.98**.

## 2.2.21 API note — Quick Start

No existing public API number changes. Quick Start is implemented as a one-shot fresh-save reconciliation after the native world exists. The setup surface can delegate the whole shortcut through capability names:

- `quick_start_provider`
- `new_game_progression_provider`

When either resolves to an external provider, Nuzlocke clears its local one-shot request and does not mutate the provider-owned progression transaction. The internal diagnostic/apply seam is `mod.exports.__beta26.applyQuickNuzlockeStart(game)`; it is intentionally under `__beta26` and is **not** promoted as a stable public compatibility contract.

The public randomizer/starter-randomizer contracts are unchanged. Nuzlocke-owned Quick Start calls the existing seeded starter `select`/`commit` path, so no RNG API bump is needed. External starter randomizers that rely only on the native gift transaction do not automatically receive that transaction when Quick Start bypasses it; combined runtime validation is required unless the provider also owns Quick Start.

## 2.2.20 API note

No public Nuzlocke API version changes. The new QoL path consumes Gen1Recomp's existing composable `intro.oak_speech.build` hook. External ownership may advertise `opening_intro_skip_provider` or the broader `tutorial_qol_provider`; when delegated, Nuzlocke does not remove Oak-speech steps.

All existing randomizer, starter-randomizer, battle-classifier, translation, interop, and compatibility API numbers remain unchanged; their build stamps report 2.2.20.

## 2.2.19 API note

The built-in `mod.exports.randomizer` surface remains **API 1** and gains additive fields without breaking the existing contract:

- `build = "2.2.19"`
- `rngVersion = 1`
- `seed(create)` returns the persisted 8-digit seed; with `create == true`, AUTO/0 generates and stores one.
- `apply`, `applyEncounters`, and `applyLearnsets` remain available.

Internal compatibility helpers also expose `mod.exports.__beta26.randomizerSeed(profile, create)` and `randomizerAlgorithmVersion()`. Deterministic slot selection uses separate `STARTER`, `ENCOUNTERS`, and `LEARNSETS` streams. No compatibility API, Mod API, permission, engine-range, or save-schema version changes.

## 2.2.18 API note

No compatibility API version or save schema changes. Public build stamps for `nuzlocke_translation`, `randomizer`, `starter_randomizer`, and `battle_classifier` are synchronized to 2.2.18. Existing delegation APIs now also govern Automatic Default Names, Skip Catch Tutorial, and fresh-save PC kit execution, not only UI ownership.

## 2.2.17 API note

`mod.exports.__beta26.difficultyStackWarning(selectedId)` returns the current human-readable external-provider composition warning for the supplied stable Difficulty id, or `nil` when no warning is needed. This is an internal compatibility/UI surface; provider selection itself remains stable-id based and manual.

## 2.2.16 API note

Compatibility API version is unchanged. Two read-only compatibility surfaces are added/clarified:

- `mod.exports.nuzlocke_compat.getNextGymTeamInfo(save)` returns the next Gym Leader identity plus the live composed `teamSize`/`limit`, class/party identifiers when available, and `source = "LIVE_COMPOSED_TRAINER_PARTY"`.
- `mod.exports.nuzlocke_translation.detect()` reports reviewed translation companions and diagnostic state such as PT-BR native Trainer Card / inventory-list layout overrides. Translation companions remain localization owners; this is detection only.

`gym_team_size_source` is `live_composed_trainer_party`. No save-schema, Mod API, permission, dependency, conflict, or engine-range change.

## 2.2.15 API note

No public Compatibility API, Mod API, save-schema, permission, or engine-range change. Save schema remains 4. Internally, `mod.exports.__beta26.saveUpgrade` now owns the ordered save-upgrade plan (`schema`, `semantic`, `reconstruction`, `projection`) and exposes transient `lastRun` diagnostics. `registerSaveUpgradeStep` and the coordinator are internal beta scaffolding, not a stable provider contract. Existing persisted migration markers and rule keys are preserved. Legacy Level Cap and Rule Lock reconciliation now register into the same internal plan; the Difficulty provider-ID bootstrap remains intentionally lazy because it depends on the live provider list.

## 2.2.12 API note

No public Compatibility API, Mod API, save-schema, permission, or engine-range change. Built-in Game Difficulty remains internal configuration. Its party transformations consume the existing `trainer.party` composition seam and live merged species/move data; Gen 1 AI uses the existing native trainer-AI layers and Gold AI is applied to a per-battle copy of TrainerClassAttributes. Selected external difficulty providers are not transformed.

The Gold badge-boost suppression used by selected built-in profiles is internal and battle-scoped. No new hook contract is introduced.

## 2.2.10
No public API version change. Internally, Random Starter and Random Encounters share a generation-aware live-species filter, and the optional Physical/Special Split composes through the existing `battle.damage` hook rather than introducing a new hook contract. Provider-owned move/type records are not mutated.

## 2.2.9
No public API change. Native vitamin IDs are centralized internally on the existing beta namespace.

## 2.2.8 API note

No public API change. Internal live cap preview now recognizes Nuzlocke's own active non-Vanilla Difficulty profile as a reason to preview `trainer.party`. Vanilla ScriptRunner text is no longer globally rewritten by the T3 presentation hook.

## 2.2.7 API note

No public API change. Internal late-runtime initialization now executes in two temporary closures instead of one oversized closure in order to remain below Lua 5.1's 60-upvalue limit. The temporary `_lateRuntimeInit` export remains an implementation detail and is cleared immediately after each phase.

## 2.2.6 API note

No public API change. `skipCatchTutorialRequested` is now stored on the existing internal `mod.exports.__beta26` namespace to reduce Lua local-variable pressure. This is an implementation detail, not a new supported compatibility surface.

## 2.2.5 API note

No public API change. Internal Pokémon Bois Club renderer ownership state now lives on the NPC object instead of an additional file-scope weak table. This reduces active-local pressure in `main.lua`.

## 2.2.4 API note

No public API, save-schema, permission, or compatibility-contract change. The Pokémon Bois Club chairman's Tier-3 presentation now builds a replacement through the engine's existing `src.render.SpriteRenderer.new(spriteDef, seed)` contract instead of retaining the obsolete custom in-memory renderer implementation. Existing Nuzlocke Compatibility API remains 27.

## 2.2.3 API note

Compatibility API remains 27 with no signature changes. `getNuzInfoPages()` and `getPokemonNuzInfo(game, mon)` retain their existing contracts. The R/B/Y native consumer now renders more of the already-exposed model (including `catch.shiny`, `catch.cause`, `catch.provenance`, legality BST fields, and move `accuracy`) and reconstructs equivalent direct-Pokémon data when the optional rich model fails. Skip Catch Demo hardening is internal and does not add a public API.

## 2.2.2 API note

No API, save-schema, permission, or compatibility-contract changes. 2.2.2 only changes the compact Trainer Money presentation label to `Btl. ¥` and records Yellow runtime PASS evidence for shop and Pokémon Center enforcement. Compatibility API remains 27 and audited Gen1Recomp remains 0.1.94.

## 2.2.1 API note

No API, save-schema, permission, or compatibility-contract changes. 2.2.1 only adjusts the Gold Setup/NUZ RULES value-column presentation. Compatibility API remains 27 and audited Gen1Recomp remains 0.1.94.

## 2.2.0 API / engine-audit note

`getCompatibilityReport().audited_recomp` now reports **`0.1.94`**. Nuzlocke Compatibility API remains **27**; no exported function signature changes in 2.2.0.

Gen1Recomp 0.1.94 introduces an engine API-2 facility, `mod.postLog`, backed by a manifest `log_url` and the `network` permission. Nuzlocke 2.2.0 does **not** opt into that facility and does not add network permission. It is documented here only as a newly available upstream diagnostic seam.

`getPokemonNuzInfo(game, mon)` retains its existing read-only shape. The R/B/Y consumer now isolates failures from optional legality/provenance providers; if the richer model cannot be produced, NUZ INFO displays safe direct Pokémon facts instead of propagating an exception into PartyMenu.

## 2.1.23 internal presentation helper

`mod.exports.__beta26.formatWorldText(message)` is the shared World Building formatter used by Nuzlocke-owned overworld text. It cleans, wraps to the Gen1 dialogue width, converts mod-owned continuation-style text into explicit pages, and is presentation-only. No public compatibility API version or signature changed.

## 2.1.22 presentation note

No Nuzlocke API contract changed. R/B/Y NUZ ST. and MOD COMPAT changed presentation implementation only, from custom states to host ListMenu surfaces.

## 2.1.21 API note

No API changes. Gold configuration row spacing is presentation-only.

## 2.1.19 compatibility lifecycle note

## 2.1.20 API note

No public API signature changes. `getTypeLockAllowedTypes()` remains mode-authoritative: it returns an empty list when Type Locke is OFF, one configured type for MONO, two distinct configured types for DUO, and three distinct configured types for TRI. An empty list therefore means no type restriction.

- Gen1 Modern UI registration is now fail-closed: Nuzlocke marks the adapter active only when the provider returns explicit boolean `true`. Provider exceptions, `false`, `nil`, and other unexpected results remain inactive and expose an error state rather than a phantom registration.
- Gen1 kerning hook installation is lifecycle-driven rather than generation-driven. Installation may occur while Gold/Gen2 is active, but `kerningEnabled()` still makes the wrapped font methods behaviorally inert unless a confirmed Gen1 game is active.
- The R/B/Y title SETUP fallback now stores mutable dependencies on `TitleState.__nuzlockeSetupFallbackState`; hot reload refreshes that state instead of stacking another Nuzlocke wrapper.

## 2.1.18 presentation ownership note

No public API or save-schema bump. R/B/Y navigation now treats the native Trainer Card as engine-owned and launches Nuzlocke status separately with `NuzlockeTrainerCardScreen` context `{ statusOnly = true }`. Internal ScriptRunner contexts may receive `__nuzlockeRuleMessageShown = true` after a mod-authored denial/flavor response; this is transient transaction metadata only and is never persisted.

## 2.1.18 configuration note

No compatibility-API or save-schema bump. The new stored config key is `pc_starting_heal_items` (boolean, default false); the one-shot save marker is `nuzlockePcHealItemsGranted`. Difficulty presentation now cycles by the live `difficultyOptions()` list and stable `difficulty_provider_id` rather than exposing unused numeric slots.

## 2.1.16 Type Locke state note

The existing Type Locke API remains signature-compatible, but `typeLockMode()` now accepts mode `3` (TRI) and `typeLockAllowedTypes()` can return three concrete type ids. New internal configuration key: `type_lock_tertiary`. OFF returns an empty allowed-type list, MONO returns exactly the primary type, DUO returns exactly two distinct types, and TRI returns exactly three distinct types. `resolveRandomTypeLockSelection(profile)` clears inactive selectors and resolves active RANDOM selections once. No compatibility API version bump.

## 2.1.15 configuration-state note

Adds the internal reversible `rule_lock` configuration key. It is distinct from dormant Permanent Rule Seal state (`rules_locked` / `rules_permanently_locked`). `NuzlockeConfigScreen` treats `rule_lock` as a temporary editing guard and preserves Permanent Rule Seal behind its existing WIP gate. Type Locke profile normalization now clears both selectors in OFF and the secondary selector in MONO. No public compatibility API version change.

## 2.1.14 Type Locke state note

`typeLockAllowedTypes()` remains mode-authoritative. MONO returns only Type 1. The config surface now also clears/hides the secondary selector in MONO, while DUO recreates a valid distinct secondary when needed. No API signature changed.

## 2.1.13 repair notes

No public compatibility API or save-schema bump.

`randomStarterCandidates(game, original)` now admits only concrete species records that satisfy the runtime construction/Summary-screen contract. This intentionally does **not** change provider legality APIs: a provider may expose partial species metadata for legality/BST/type purposes without that partial record automatically becoming a valid concrete Random Starter.

T3 Bryan-at-home uses an internal runtime NPC plus a contributed `map_scripts` talk id; no new public NPC-provider contract is introduced.

## 2.1.12 reward and presentation notes

`route_forgiveness_gym_leaders` is the authoritative one-time reward ledger for Gym Leader Forgiveness awards. The previous per-Gym-Trainer reward path is no longer active.

Canonical labels remain full natural `Strings.source(...)` values. Compact forms such as `Nuz. Loadout`, `Dung. Lock-In`, `BATTLE ITMS`, and `No PP Itms` are optional presentation metadata only.

No public compatibility API version bump.

## 2.1.11 localization-safe presentation metadata

Rule objects may now carry:

```lua
name = Strings.source("Random Encounters")
shortName = Strings.source("Rndm Enc.")
```

The stable rule key remains the machine contract (`random_encounter_tables` in this example). `name` is the canonical natural-language source string. `shortName` is presentation-only and must never be treated as a semantic identifier.

R/B/Y display selects the full translated label first. If it overflows, a short label may be used. When the full label is translated but the short label is not, Nuzlocke preserves the translated full label and uses its normal slow marquee rather than injecting untranslated English shorthand.

Section headers can likewise carry `shortTitle`.

`getCompatibilityReport().audited_recomp` now reports `0.1.93`.

## 2.1.10 presentation-only update

No API, rule-key, save-schema, or provider-contract changes. The compact vocabulary affects only Nuzlocke-owned player-facing menu labels and section titles.

## 2.1.9 presentation/compatibility note

No Nuzlocke API contract changes. `NuzlockeConfigScreen` now declares the Wide Menus-compatible classic layout markers on each instance. Internal rule keys remain unchanged despite shorter player-facing labels.

## 2.1.8 presentation-only update

No API change. Randomizer internal rule keys and compatibility identifiers are unchanged; only player-facing menu labels are abbreviated.

## 2.1.7 presentation/compatibility note

No compatibility API changes. Nuzlocke temporarily declines the Wide Menus presentation claim for its rules screen and uses native-width fallback. The optional dependency remains non-owning of Nuzlocke rule state.

## 2.1.6 presentation-only update

No compatibility API changes. Conditional overflow scrolling timing and R/B/Y selection rendering were adjusted for Yellow runtime readability.

## 2.1.5 presentation-only update

No compatibility API contract changes. The R/B/Y configuration and MOD COMPAT screens use glyph-span-safe conditional scrolling on measured overflow. Rule/ownership semantics are unchanged.

## 2.1.4 presentation-only note

No compatibility API contract changes. R/B/Y Nuzlocke-owned diagnostic/configuration screens now consume the current engine Font measurement helpers for pixel-aware layout. Semantic provider/legality contracts are unchanged.

## 2.1.3 compatibility API correction

`compat21.pokemonLegality(game, mon)` now treats a non-empty string in `mon.nuzlockeInvalidAcquisition` as an invalid acquisition. The returned result still includes `reasons = { "INVALID ACQUISITION", ... }` and now also exposes:

```lua
invalidAcquisitionReason = "disabled" | "glitch" | "legendary" | "mythical" | "pseudo" | "area" | "solo" | ...
```

Consumers should use the semantic result rather than reading Nuzlocke's internal Pokémon fields directly.

No public compatibility-API version bump accompanies this correction because the change fixes the implementation to match the existing intended contract.

## 2.1.2 engine-surface repair

R/B/Y MOD COMPAT no longer imports the obsolete `src.render.Draw` private module and instead uses the current `src.render.Font` drawing API. Gen1 kerning installation is lifecycle-retried after game generation is resolvable. No public Nuzlocke API version change.

## 2.1.1 / Gen1Recomp 0.1.92 audit

Gen1Recomp 0.1.92 introduces `mod.fetch` (permission: `network`) and `mod.job` (permission: `background`) as sanctioned asynchronous facilities. Nuzlocke 2.1.1 does not consume either API because current rule enforcement, compatibility providers and presentation do not require background HTTP or worker computation.

The engine also adds a legacy sandbox compatibility layer. Nuzlocke continues to prefer current scoped engine APIs rather than depending on compatibility shims.

Mod API remains 2. Nuzlocke compatibility/save contracts are unchanged.

## 2.1.0

Versioning transition only. No Nuzlocke compatibility API or save-schema bump accompanies the move from the former `2.0.0-beta.31.0.4` identity to `2.1.0`.

## Wide Menus V0.1.0 presentation bridge

No Nuzlocke API version bump. `NuzlockeConfigScreen` advertises/claims Wide Menus' public `wide` layout only for non-pre-game R/B/Y instances. No Nuzlocke state is delegated to the UI provider.

## beta.31.0.3

No compatibility API version change. `nuzlocke_compat.dungeonFamily` retains the same contract; its built-in fallback now fails open for Pokémon Center/Poké Mart service-interior identifiers before dungeon-prefix matching.

## Gen1Recomp 0.1.90 compatibility review

No Nuzlocke compatibility API or save-schema bump is required. The upstream 0.1.90 delta does not change the public Nuzlocke provider contracts.

## beta.31.0.1

No compatibility API version bump. Existing contracts are preserved. Optional Modern UI integration now reports current `active` state separately from historical registration state and fails closed when generation is unknown or Gold/Gen2.

## beta.30.1.22 diagnostic additions

`mod.exports.__beta26.compat21.trackerCatchContext(game, catch, area)` returns spoiler-safe semantic encounter context (`tag`, `status`, known `provider`, `encounterType`). It never exposes future randomizer mappings.

`mod.exports.__beta26.compat21.pokemonLegality(game, mon)` is a read-only diagnostic against the currently active roster restrictions. It returns `legal`, `status`, `reasons`, `bst`, and `maximumBST`; it does not mutate the Pokémon or save.

`mod.exports.__beta26.compat21.pokemonProvenance(game, mon)` returns known Nuzlocke/provider/source fields without inventing missing provenance.

`compat21.surfaceRows(game)` now reports a broader effective ownership map for the MOD COMPAT presentation.

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

`reason` may also be `type_lock` when an otherwise catchable Pokémon does not match the active Mono/Duo/Trilocke type set. Type Locke is evaluated before Shiny/area/Dupes exceptions for new acquisitions, so a caller should treat it as a hard acquisition-eligibility denial. Existing owned Pokémon are not deleted or retroactively invalidated. Off-type wild encounters are not counted as failed encounters by Nuzlocke's own tracker.


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

## 2.0.0-beta.30.1.7 — Pokegear Cards consumer

Nuzlocke consumes only an active `pokegear_cards` handle whose exports report `apiVersion == 1`.

Stable IDs:
- `nuzlocke_status` — custom card
- `nuzlocke_map_status` — MAP overlay
- `nuzlocke_radio_world` — RADIO overlay

Successful registration publishes informational metadata at `mod.exports.pokegear_cards`. `mod.exports.__beta26.goldPokegearRuleNames()` exposes the same Gold rule labels used by Nuzlocke's native Gold status UI for this optional presentation provider.

No PHONE append is registered.

## 2.0.0-beta.30.1.8 — delegated numeric neutrality

Internal rule specs may declare `neutral` for numeric controls whose neutral/provider-owned display is not the same as their minimum.

`trainer_money_multiplier` declares `neutral = 4`, corresponding to 100%.

`trainer_rewards.lua` now receives the existing `externalRuleDelegation` dependency and uses it before applying Trainer Money scaling. An active `economy_provider` therefore owns the final trainer payout without a second Nuzlocke wallet rewrite.

No public compatibility API version bump.

## 2.0.0-beta.30.1.9 — Gold cap-stage ordering

The fallback `VersionCompat.gscStages` progression order is restored to Chuck -> Pryce -> Jasmine for the Johto mid-game.

This does not alter `gscBadgeStages`: badge-key and positional fallback identities remain Chuck/Storm 5, Jasmine/Mineral 6, Pryce/Glacier 7.

No public compatibility API version bump.

## 2.0.0-beta.30.1.10

No public API changes.

Internal title fallback adapters now evaluate `isSaveEditorSession()` at callback time as well as install time. This is lifecycle hardening only.

## 2.0.0-beta.30.1.11

No public API change.

Internal callers outside `trainer_rewards.lua` must access Route Forgiveness helpers through `mod.exports.__beta26.TrainerRewards`. Bare main-chunk calls to `forgivenessEnabled` / `forgivenessTokens` have been removed.

## 2.0.0-beta.30.1.12

No public API change. Internally, `nuzlockeTrackerRegistered` now reflects successful stored-location recovery rather than merely the presence of a tracked `catchLocation`.

## 2.0.0-beta.30.1.13

No public API change.

Internal `specialAcquisitionDenied(game, species, area, kind)` now applies the Solo Only party-slot check to both `gift` and `trade` acquisition kinds.

## 2.0.0-beta.30.1.14

No public API version change.

`mod.exports.__beta26.armFirstRivalForgiveness(game, battle)` now persists `nuzlocke_first_rival_battle_seen` only after `isOpeningRivalBattle(game, battle)` succeeds. Non-opening Rival classifications return false without mutating the durable one-shot.

## 2.0.0-beta.30.1.15

No public API change.

Internal `worldOnce(game, key, message, minimumTier?)` now accepts an optional threshold. If omitted, the historical Tier 3 requirement remains. `queueTrainerFlavor` forwards its own threshold to this fallback.

## 2.0.0-beta.30.1.16 — Type Locke canonical Fairy support

The Type Locke selector now has a sparse compatibility-stable layout:

- concrete legacy types: indices 0..16;
- RANDOM sentinel: index 17, unchanged;
- FAIRY: index 18.

`mod.exports.__beta26.typeLockTypes[18] == "FAIRY"`.

`typeLockTypeCount` now reports 18 concrete canonical types. Consumers must not infer that every numeric value from 0 through the highest selector value is concrete; index 17 remains the RANDOM selector sentinel.

Internal helpers `normalizeTypeLockIndex` and `nextTypeLockConcreteIndex` keep runtime legality and DUO distinct-type handling sentinel-safe.

The public Nuzlocke compatibility surface continues to expose allowed type strings rather than requiring consumers to understand selector indices.

## 2.0.0-beta.30.1.17

No public API change.

The internal R/B/Y `ShopMenu.new` gate now resolves action identity against both literal canonical English labels and the current `Strings("BUY")` / `Strings("SELL")` translations before wrapping the action callbacks.

## 2.0.0-beta.30.1.18 — Gen1 Modern UI presentation contract

When loaded, Nuzlocke exports:

`mod.exports.gen1ModernUi`

with `apiVersion = 1` and semantic screen entries for:
- `NuzlockeTrackerScreen`
- `NuzlockeCatchInfoScreen`
- `NuzlockeTrainerCardScreen`

The contract is presentation-only. Models contain plain row/detail data. Actions delegate back to methods on the source Nuzlocke screen state.

`mod.exports.__beta26.ModernUiIntegration` exposes integration diagnostics including `registered`, `providerId`, `lastError`, `contract`, and `tryRegister()`.

No gameplay compatibility API version change.

## 2.0.0-beta.30.1.21 — PokemonRecompRandomizer ownership adapter

For active Gen1 gameplay, Nuzlocke recognizes mod id `pokemon_randomizer` when `exports.contractVersion == 1` and `exports.save.activeRun()` returns a public run with settings. The adapter is read-only and never mutates provider state.

Ownership mapping: `starters != "off"` → Random Starter; `wild_pokemon != "off"` → Random Encounter Tables; `pokemon_movesets != "vanilla"` or `learnset_levels != "vanilla"` → Random Learnsets and its generation selector. Fishing is intentionally not treated as encounter-table ownership. Gold is excluded.



## beta.30.1.21 compatibility additions

`mod.exports.nuzlocke_compat.species_metadata.get(game, species)` returns merged semantic species metadata. Provider metadata is preserved and live merged species data fills missing types/base stats/BST where available. `species_metadata.api = 2` and `merged = true` advertise this behavior.

`mod.exports.__beta26.compat21.randomizerTrackerContext(game)` returns spoiler-safe ownership context only; it never exposes randomized encounter mappings. `compat21.surfaceRows(game)` supplies semantic ownership rows for presentation, and `compat21.guidance(game, context)` returns optional World Building guidance without enforcement side effects.

## 2.1.24 presentation note
R/B/Y party NUZ INFO now consumes the existing API-27 `getNuzInfoPages()` and `getPokemonNuzInfo(game, mon)` helpers through a host-owned ListMenu. No API signatures changed.
