> **API version context:** The mature Gen 1/2 compatibility and provider contracts described below are preserved. Gen 3 uses isolated `gen3_*` exports in `gen3_runtime.lua`, retains Mod API 2, and has a read-only Mod Support screen rather than Gen 1/2 owner-preference controls. See the [Gen 3 developer guide](DEVELOPER_GEN3.md).

<!-- Current build: 2.9.72 -->
# Nuzlocke API — 2.9.72

> Current compatibility/documentation baseline: **2.9.72**.

## Current public contract

## UI presentation-ownership contract

Conditional gameplay authority remains descriptive. `gameplayAuthorityFor(surface)` returns the descriptor, while `presentationOwnsGameplay(surface)` returns true only for unconditional ownership; callers must not treat `nuzlocke_randomizer_when_enabled` as active without resolving Randomizer state.


`mod.exports.nuzlocke_ui_system` now exposes UI API version 8 with presentation-contract version 1. `presentationPolicyFor(surface)` reports the declared renderer/controller ownership boundary for Nuzlocke screens, Party, PC, Pokédex, Bag, Mart, battle art/HUD, overworld rendering, generic ListMenu composition, and trainer-party presentation. `externalPresentationAllowed(surface)` is a convenience query for presentation integrations.

Presentation ownership never grants challenge/gameplay authority. In particular, an external Party/PC/battle-art renderer may own presentation while the engine retains the controller and Nuzlocke/Randomizer retains trainer-party/challenge authority when enabled.

## UI input-semantics contract

`mod.exports.nuzlocke_ui_system` exposes presentation-only UI metadata with UI API version 7 and input-contract version 1. `inputPolicyFor(screenId)` reports whether vertical/horizontal movement is repeat-safe, whether activation/back requires an edge-triggered action, and whether a screen is a destructive confirmation. `isRepeatSafe`, `requiresEdge`, `isDestructive`, and `applyInputContract` are convenience helpers.

This contract describes Nuzlocke-owned UI intent only. It does not intercept input, synthesize repeats, or claim ownership of external/native UI behavior.


- Compatibility API: **37**
- Diagnostics API: **1**
- Translation API: **2**
- Run History storage/API: **v2**
- Randomizer algorithm: **v1**
- Nuzlocke Save Schema: **5**
- Gen1Recomp source/documentation audit marker: **0.2.41**

2.9.40 does not change the public API or save schema. Its compatibility-evidence projection and Release Safety self-audits remain private/internal diagnostics and do not change the public provider contract.

## Randomizer ownership registry

The registry contains ten methods: `STARTER`, `ENCOUNTERS`, `FIELD_ITEMS`, `LEARNSETS`, `TRAINERS`, `EVOLUTIONS`, `SHOPS`, `TMS`, `TM_LOCATIONS`, and `GIFT_ITEMS`. `TMS` owns TM contents; `TM_LOCATIONS` owns physical TM pickup identity. Named adapters may resolve these independently. Generic provider capability vocabulary is unchanged.

## Compatibility semantics

Provider detection, advertised capability, selected ownership, degraded state, and Nuzlocke fallback are distinct states. Load/dependency order may determine when an adapter can inspect a provider, but it does not itself grant gameplay ownership. Presentation ownership is not gameplay authority.

Expanded species/type consumers use normalized merged/provider facts. Unknown provider schemas fail open. Acquisition provenance is explicit; presentation/import detection alone does not relabel a Pokémon acquisition. Wonder Trade remains post-mutation observe/reconcile only.


## Random Field Item visible-source contract

For Gen I visible item balls, Nuzlocke composes through Gen1Recomp's public `world.talk` hook. It temporarily projects the deterministic replacement into the native object's `def.item`, calls the downstream hook/native handler exactly once, and restores the authored definition afterward. This keeps bag-capacity checks, removal flags, item-name text, sounds, and other native pickup behavior in engine ownership. Gen-II visible and hidden field items continue to use their generation-specific `HiddenItems` script-builder seams.

`randomFieldItemEditionProfile(game).visibleSource` reports `world.talk` for Gen I and `HiddenItems.ballPickupScript` for Gen II. This is descriptive metadata and does not change Randomizer algorithm versioning.

## Engine compatibility metadata

Profiles through Gen1Recomp 0.2.41 are represented with Mod API 2 and the applicable upstream save-format metadata. The 0.2.41 profile is source reviewed; engine pacing remains engine-owned and exact-edition runtime certification remains separate. Nuzlocke does not bypass Gen1Recomp ONLINE policies that disable ordinary content mods.

## Diagnostics contract

The developer diagnostics surface remains Diagnostics API 1. 2.9.71 adds the read-only `field_item_pipeline` diagnostic. It reports the active edition's field-item hook/script-builder health plus the most recent observed field-item decision/projection when available. The diagnostic never requests a writable Randomizer seed or materializes unseen mappings.



Passive diagnostics are observational: they do not consume Randomizer RNG, materialize unseen mappings, mutate save/rule state, select ownership, or repair gameplay. Gen-II Random Trainer accepted-roster evidence and Gen-II Field Item decision/native-script evidence remain diagnostic aids for unresolved runtime failures.

2.9.39 adds private/internal `mod.exports.__beta26.Dev.ruleCertification(key, game)` and `Dev.explainRuleStatus(key, game, preGame)`. They project the existing rule catalog/availability/evidence contracts read-only and do not extend public Diagnostics API 1. Runtime evidence rows are exact-edition and remain `REQUIRED` where no exact evidence is recorded.

## Correctness hardening — 2.8.76

No public API version changes.

R/B/Y native Ball-use policy failures now fail closed. Forgiveness recovery requires an exact FAILED encounter state rather than mere row presence. World Building certification now enumerates all six exact editions.

## Run History death-event boolean preservation — 2.8.75

No public API version change.

`RunHistory.recordDeath()` now treats an explicitly supplied `shiny=false` value as authoritative and only falls back to live Pokemon shiny detection when the field is absent.

## Acquisition catalog consistency — 2.8.74

No public API version change.

The Gen-I deterministic gift fallback now includes Route 4 Magikarp, and the acquisition catalog exposes an internal consistency self-test that derives its expected common gifts from the authoritative catalog.

## Transaction/item-policy hardening — 2.8.73

No public API version changes.

The internal Gameplay Transaction Coordinator now treats the original request payload as part of durable transaction identity. New journals/receipts carry a compact payload fingerprint while legacy receipts remain readable.

The existing public item-use compatibility surface now fails closed with `policy_error` if Nuzlocke's authoritative evaluator throws. This is a safety correction to existing semantics, not a new API shape.

## Difficulty documentation/edition contract — 2.8.72

No public API version changes.

Built-in Difficulty selection is now exact-edition aware for Red, Blue, Yellow, Gold, Silver, and Crystal. Generic `gen2` remains a fail-soft Gold-family fallback only after exact edition checks.

The in-game profile summary is a concise presentation surface. The authoritative player-facing mechanical specification for every built-in profile lives in `docs/USER_GUIDE.md` under **Difficulty Profiles — Full Mechanical Reference** and must be updated whenever a profile's enforcement fields change.

# Historical Nuzlocke API — 2.8.76

## Current API versions

- **Mod API:** 2
- **Compatibility API:** 37
- **Diagnostics API:** 1
- **Save Schema:** 5
- **Randomizer algorithm:** 1
- **Engine manifest range:** `>=0.2.24 <2.0.0`
- **Engine source/documentation audit marker (current):** 0.2.33
- **Manifest editions:** `red`, `blue`, `yellow`, `gold`, `silver`, `crystal`

## Compatibility API 37 — semantic battle roster and activity state

Compatibility API **37** adds two observational/cooperative surfaces without changing Nuzlocke gameplay ownership:

- `mod.exports.nuzlocke.battle` (API 1) exposes `describe(battle, context)` and `activeCombatants(battle, side, context)`. A cooperative provider may advertise `battle_roster` and supply `describeBattle`; otherwise the conservative native fallback reports the ordinary singular player/enemy battlers. This allows multi-active battle mods to describe plural combatants without Nuzlocke wrapping their private turn loop.
- `mod.exports.nuzlocke.activity` (API 1) exposes `current(game, context)`. A cooperative provider may advertise `activity_state` and supply `activityState`; otherwise the result is explicitly `known=false`/`mode=unknown`. This avoids inferring travel or other activity state from private UI/player fields.

The legacy `nuzlocke_compat` surface mirrors these as `battleApi` and `activityApi`. Existing Acquisition/Provenance API 1 already provides the authoritative opaque-token pre-transaction `begin`/`commitDecision` lifecycle; 2.9.27 preserves that stronger contract rather than adding a parallel acquisition API. Compatibility API 37 remains additive and preserves `compatible_from = 10`.

## Compatibility API 36 — corrected runtime environment and atomic content bundles

Compatibility API **36** corrects two existing public-contract behaviors while preserving `compatible_from = 10`.

- `nuzlocke_compat.runtime_environment` is now the current environment value (`"gameplay"` or `"save_editor"`) rather than an accidentally exposed function object.
- `registerContentBundle()` now validates the complete provider bundle before mutating content registries. An invalid child or Randomizer policy rejects the bundle before any earlier rows are registered.
- `nuzlocke_compat.content.validateBundle(bundle)` exposes the same read-only validation contract used by registration.
- Diagnostics API remains 1. Hook Health now reports the real Gen2 visible/hidden field-item wrapper sessions and adds read-only semantic health for the `trainer.party` Randomizer chain.

No Save Schema change is required; these changes do not alter serialized run data.

## Compatibility API 35 — semantic provider status

Compatibility API **35** formally versions the additive public introspection already shipped in the 2.8.39+ line: `providerStatus(id)`, `capabilityStatus(capability)`, and `compatibilitySnapshot()`, including the legacy/public `nuzlocke_compat` mirrors. API 35 preserves `compatible_from = 10` and does not remove or change API-34 rule-availability contracts. Consumers may use the new version to feature-detect semantic provider/ownership state rather than treating mod presence as authority.

## Run History API 2 / achievement evidence

`mod.exports.nuzlocke_run_history` is now version **2**. Existing `list`, `report`, `record`, and `nuzlocke.run_history` event behavior remains available. New read-only `statistics(game)` / `achievement_evidence(game)` expose the durable aggregate ledger.

The detailed event list is intentionally bounded. Achievement evidence is updated before pruning and therefore stores lifetime counters/dimensions separately. `coverage.partial` and `coverage.detail_complete` must be respected by future achievement consumers; incomplete historical evidence must never be treated as proof of a requirement that needs missing detail.

`rule_integrity` records coverage-start values, last observed values, and live configuration changes made through Nuzlocke's central rule editor. This is evidence only; it does not lock rules or award achievements.

Run History storage version 2 is a subsystem migration inside global Save Schema 5.

## Run History v2 correctness — 2.8.70

Run History remains public API/storage version **2**.

The durable summary mapping now includes `run.abandoned -> abandons`. Coverage semantics are corrected so `detail_complete=false` / `partial=true` whenever any summarized durable total exceeds retained detail, when pre-ledger catch/death baselines exist without matching detail, or when the bounded journal has truncated rows.

Existing v2 roots repair their missing abandon summary from persisted v2 statistics when available. This is a data-repair within the existing Run History v2 representation and does not change global Save Schema 5.

## Translation registry consolidation — 2.8.69

The public Translation API remains **2**. Known-companion diagnostics add normalized `targetClass` and `certificationEligible` metadata. These fields describe review/certification policy only and do not alter translation ownership or gameplay behavior.

Reviewed repositories that are not runtime companions are stored only under internal `__beta26.translationReviewExclusions`; they are not returned by Translation API detection and are not optional dependencies.

## Finnish companion metadata — 2.8.67

The public Translation API remains **2**.

`finnish` 0.1.0 is now a current known companion with Red scope, fixed-cell extended-Latin metadata, presentation-wrapper ownership, confirmed-loaded replacement scripts, mutation review, and companion-specific certification focus notes.

## Dutch companion metadata — 2.8.66

The public Translation API remains **2**.

`translation-nl` is recorded as a known Red/Blue companion with confirmed generated-runtime loading of replacement map scripts. Existing `replacementMapScripts`, `replacementMapScriptsPresent`, `mutationReviewRequired`, and `certificationFocus` diagnostics are sufficient; no API shape change is required.

## Translation presentation-wrapper contract — 2.8.65

The public Translation API remains **2**.

Semantic enforcement coverage now includes `translation_presentation_wrapper`, documenting that translation-owned `Strings`, `Font`, and UI wrappers are presentation-only compatibility overlays. They must remain narrow/compositional and must not become a prerequisite for Nuzlocke-owned UI rendering or gameplay decisions.

Known-companion diagnostics may expose `fixedCellCJK`, `engineInternalsPresentationWrappers`, and `certificationFocus` metadata. These are diagnostics/compatibility metadata, not new gameplay capabilities.

## Polish companion metadata — 2.8.64

The public Translation API remains **2**.

Known-companion diagnostics can now distinguish `replacementMapScriptsPresent` from confirmed `replacementMapScripts` so source-audit evidence does not falsely imply a replacement script is active at runtime.

## Dev localization certification — 2.8.62

The public Translation API remains **2**.

Dev-only internal diagnostics add:

- `Dev.localizationCertification(game)`
- `Dev.localizationCertificationMark(game, index[, state])`
- `Dev.localizationCertificationReset(game)`

These are session-only developer/tester helpers under the internal `__beta26` diagnostics namespace. They are not save data and do not extend the public Compatibility or Translation API contract.

## Translation API 2 — 2.8.61 internal glyph reuse

Translation API remains **2**. No public row shape changes.

The existing generalized glyph helpers are now exposed only on the internal `__beta26` namespace for split Nuzlocke-owned UI/adapters. This is not a new public compatibility contract.

Source discovery additionally includes Pokegear Cards authored labels and compact Gen-II NUZ STATUS templates.

## Translation API 2 — 2.8.59 catalog consolidation

Translation API remains **2**. The `{source, kind, key}` row shape is unchanged.

2.8.59 expands source discovery with `forgiveness_ui`, `forgiveness_message`, `battle_clause_message`, additional `ui_status` / `compat_ui`, and selected `runtime_message` entries. This is catalog coverage expansion only.

## Translation API 2 — French targets

2.8.58 adds `translation-fr` and `trad-fr-extended` to the known companion registry without changing Translation API 2's public shape. The base translation is recorded as an all-six-edition generated target; the overlay remains a distinct companion that requires the base.

## Translation API 2 — Spanish target note

2.8.57 adds `traduccion_es` 0.1.0 to the known companion registry without changing Translation API 2's public shape. The companion exposes no public lifecycle API of its own, so Nuzlocke reports it through the generic installed/active companion path and does not attempt to infer private cartridge-dump state.

## Translation API 2 — World Building / Randomizer expansion

2.8.56 keeps Translation API **2** and expands source discovery without changing the `{source, kind, key}` row shape.

`nuzlocke_translation.sources()` now also walks the live `worldRuleCatalog` and exposes each T1/T2/Kanto/Johto authored variant with its canonical rule key. Randomizer status templates and option values used by Nuzlocke-owned status/setup surfaces are also included.

The expansion is presentation/catalog-only and does not alter World Building or Randomizer policy.

## Translation API 2 — expanded source discovery

2.8.55 keeps Translation API **2** and expands the rows returned by `nuzlocke_translation.sources()` with high-value Nuzlocke-owned UI/status/tracker/world-summary source strings. The row shape remains `{source, kind, key}`; this is catalog coverage expansion, not an API-shape change.

`catalog()` continues to map each discoverable source to its current `Strings.lookup(...)` result.

Dev localization diagnostics are intentionally private under `mod.exports.__beta26.Dev.localizationDiagnostics()` rather than a new public translation API method. They compare discoverable sources against the current catalog read-only and report lifecycle/fallback coverage without changing language or translation ownership.

## Translation API 2 — active language lifecycle

`mod.exports.nuzlocke_translation.api` is now **2**.

`detect()` remains read-only and keeps its prior companion/presentation fields. API 2 additively exposes, when a companion provides them:

- `installed`
- `translationActive`
- `activity`
- `bootLanguage`
- `pendingLanguage`
- `restartRequired`
- `edition`

`activity` is `active`, `installed_inactive`, or `restart_required`. Presence/activity is descriptive only and does not delegate Nuzlocke gameplay policy.

Current explicit German target: `translation-german-universal`, reviewed stable release 0.2.0. Its English boot mode is treated as installed but translation-inactive.

## Translation companion diagnostics

`mod.exports.nuzlocke_translation.detect()` remains a read-only compatibility surface. In 2.8.50, presentation detection is capability-shaped rather than tied to `gen1_pt-br`: known companions may report exported `trainer_card`, `precos_linha`, `idioma_golpes`, and `mostrar_inimigo` values. These are descriptive presentation signals only.

Known Brazilian identities are distinct: legacy `gen1_pt-br` and current `versaovermelha` (reviewed stable release 0.2.5). Detection of either does not delegate Nuzlocke gameplay policy.

## 2.8.53 ownership-resolution clarification

Compatibility API 35 does not select providers that advertise a capability while statically disabled/inactive. Such providers remain visible to `providerStatus()` / `capabilityStatus()` diagnostics, but `resolveCapability().preferred` is chosen only from active/available candidates.

`compatibilitySnapshot()` canonicalizes capability aliases before building its capability set, so alias + canonical advertisements produce one semantic row.

## Current ownership rules

Compatibility is capability-based. Provider detection/advertisement alone never grants gameplay authority; the selected owner is reported separately. Nuzlocke retains challenge-policy ownership unless an explicit compatibility contract delegates the overlapping mechanic.

Shiny ownership follows a single-owner model: Nuzlocke owns built-in shiny generation/presentation only when no compatible external shiny provider owns the active edition. Shiny Clause remains Nuzlocke policy either way.

The Randomizer ownership registry currently contains ten subsystems: `STARTER`, `ENCOUNTERS`, `FIELD_ITEMS`, `LEARNSETS`, `TRAINERS`, `EVOLUTIONS`, `SHOPS`, `TMS`, `TM_LOCATIONS`, and `GIFT_ITEMS`.

For field items, visible item-ball sources are Nuzlocke-owned when routed through the supported field-item seam. Native Gen II hidden/BG-event item sources are also eligible when the adapter explicitly supplies `nuzlockeOwnedHidden=true`; arbitrary provider-defined hidden sources are not claimed automatically.

## Current diagnostics API

`mod.exports.nuzlocke_dev` remains Diagnostics API 1 and includes the read-only semantic surfaces added through 2.8.46: system health, provider ownership, encounter provenance, decision trace, bug-report snapshot, transaction health, hook/wrapper drift, shiny diagnostics, Randomizer reproducibility, performance counters, rule-configuration consistency, save/run identity health, and bounded ownership history.

These are diagnostics, not mutation or repair APIs.

## Historical API notes

The versioned material below is retained for compatibility/history. API numbers and support claims inside a historical section describe that release unless explicitly promoted above.

2.8.46 Dev diagnostics add read-only `rule_configuration_consistency(game)`, `save_run_identity_health(game)`, and bounded session-only `ownership_history(limit)`. These surfaces validate/compare/observe only; they never repair configuration, initialize run state, or select providers.

2.8.45 Dev diagnostics add severity/count/last-sequence metadata to bounded breadcrumbs and semantic decisions plus read-only `performance_counters()`. Performance counters are in-memory, Dev-only, and never persist or affect gameplay.

2.8.44 Dev diagnostics add read-only `shiny_diagnostics(game)` and `randomizer_reproducibility(game)`. Shiny diagnostics never roll/present; Randomizer diagnostics use the existing persisted zero-RNG reproducibility report and never resolve AUTO or materialize mappings.

2.8.43 Dev diagnostics: `mod.exports.nuzlocke_dev` adds read-only `transaction_health()` and `hook_wrapper_drift()`. Transaction Health inspects the durable GameplayTransactions journal/receipts without recovery or mutation. Hook Drift inspects registered hook metadata and live probes without reinstallation or ownership reclamation.

2.8.42 Dev diagnostics: `mod.exports.nuzlocke_dev` adds read-only `bug_report_snapshot(game)`. It returns a structured current-state snapshot plus `text`, aggregating build/edition/save identity, System Health, provider ownership, encounter provenance, recent decisions, warnings/errors, and bounded breadcrumbs. It is observational only and does not run self-tests, rules, RNG, or repair paths.

2.8.41 Dev diagnostics: `mod.exports.nuzlocke_dev` adds read-only `system_health(game)`, `provider_ownership(game)`, `encounter_provenance(game, battle)`, and `decision_trace(limit)` surfaces. Diagnostics API remains version 1; these additions do not grant mutation authority.

2.8.41 Release Safety hardening: no public gameplay/save-schema API change. Promotion diagnostics add static regression checks for ownership, transaction journaling, battle event shape compatibility, and Randomizer performance contracts.

2.8.39 compatibility/API cleanup: no gameplay/save-schema change. The provider registry gains read-only diagnostics: `providerStatus(id)`, `capabilityStatus(capability)`, and `compatibilitySnapshot()`. The legacy `nuzlocke_compat` surface mirrors these helpers, and `getCapabilityStatus()`/fallback inventory data are available from the compatibility report.

2.8.38 localization hardening: no public API/save-schema change; additional Nuzlocke-authored player text now consumes Gen1Recomp 0.2.27 `Strings` overrides.

2.8.37 full release: behavior-preserving promotion of the final corrected 2.8.36 candidate after Red standalone shiny runtime PASS; compatibility API/ownership contracts are unchanged.
2.8.36 standalone shiny regression fix: external shiny ownership now requires a live separate provider handle before registry/API claims are trusted, preventing Nuzlocke-only runs from falsely standing down their built-in shiny system.
# Nuzlocke API — 2.8.41

## Shiny ownership / presentation

`shinySystemOwner(game)` reports the active owner. `shinyExternalProvider(game)` returns a compatible external owner or nil. `nativeShinyFallbackActive(game)` reports whether Nuzlocke owns shiny gameplay. `shinyPresentationStatus(game)` reports `{ owner, external, colors, intro }` for the active presentation layer.

External ownership is capability-based. The current explicit target exposes `isShiny` and `rollShiny`; future providers may explicitly claim shiny ownership while still supplying `isShiny`. Nuzlocke never requires the companion to be installed.

Built-in visual presentation uses only `pokemon.sprite`, `pokemon.icon`, and `battle.overlay`. The cache path is implementation detail and is not a public content registry.

# Nuzlocke API — 2.8.33

No gameplay API or save-schema version change. Compatibility diagnostics add the capability name `presentation`, defaulting to `compose`. It is diagnostic/ownership metadata only: a presentation provider does not receive Nuzlocke rule, capture, encounter, randomizer, or progression authority.

`potato_voxel` is an optional compatibility identity. When detected, MOD COMPAT can classify it as the presentation owner. Nuzlocke deliberately does not wrap `render.compose`, register `Gen2BattleState`, or replace native `BattleState.draw`, `drawWidescreen`, or `drawPic` as part of this contract.

# Nuzlocke API — 2.8.32

No public API or save-schema change. Starter Trio Typing now consumes `game.data.type_chart.matchups` when available and falls back to the legacy internal chart only when that runtime surface is absent. `steel_typing` is an optional compatibility dependency, not a required provider.

# Nuzlocke API — 2.8.31

No public API, Compatibility API, Diagnostics API, or save-schema version change. Internal Random Starter diagnostics now expose style-aware persisted-choice validation; Gen II starter lineage reads native evolution `into` targets.

# Nuzlocke API — 2.8.29

No public API or save-schema change. Gen II no longer registers Nuzlocke Battle Menu UI presentation hooks, and the retired Gen II battle-rule pager no longer wraps `BattleState.update`. Battle denials remain internal policy enforcement presented through native BattleState message handling.

# Nuzlocke API — 2.8.29

No public API or save-schema change. Battle Menu UI registers `battle.bottom_ui_visible` and `battle.overlay` composition only on Gen I. Gen II installs neither presentation wrapper. Gen II rule denials also no longer wrap `BattleState.update` or create a custom Nuzlocke battle phase.

## Historical current note: Nuzlocke API — 2.8.27

No public API or save-schema change. Gen II PartyMenu methods are no longer
wrapped by Nuzlocke. Field NUZ INFO continues through `ui.party.submenu`, with
`ctx.battle=true` returned unchanged.

## 2.8.01 API note
No public API version changes. This hotfix changes only Gen II rule visibility and Nuzlocke-owned field-poison wipe reconciliation.


## 2.8.00 API note

No public compatibility API version bump. The Gen2 party-consumable repair is internal: Nuzlocke's Pack legality seam now resolves a selected `useItem` party index back to the live save-party record before invoking Gen1Recomp's merged Gen2 ItemEffects. Existing public item-legality/provider surfaces remain unchanged.

## 2.7.106 API note

No public Compatibility API, Diagnostics API, Save Schema, or Randomizer algorithm version changes. The Gen2 repair is internal runtime ownership for simple party consumables and uses Gen1Recomp's existing `src.core.gen2.ItemEffects` and Game2 services. PP items and evolution stones remain native specialized paths. Five-stage Setup/Rules hold acceleration is screen-local input behavior.

## 2.7.105 API note

No public Compatibility API, Diagnostics API, Save Schema, or Randomizer algorithm version changes. The Gen2 repair is an internal PartyMenu constructor contract guard for the native `useItem` chooser. The read-only `gen2PartyRecordHealth` probe remains internal; the 2.7.104 automatic full-record materializer/repair snapshots are retired. Setup/Rules held navigation is screen-local input behavior and does not add an API surface.

## 2.7.104 API note

No public Compatibility API, Diagnostics API, Save Schema, or Randomizer algorithm version changes. A private/read-only `gen2PartyRecordHealth` diagnostic and last-repair snapshot are added under the existing internal beta export namespace for runtime diagnosis only.

## 2.7.103 API note

No public compatibility API contract changes. The Gen2 repair is an internal engine-ownership routing correction at the native Pack/Game2 boundary.

## 2.7.102 API note

No public Compatibility API, Diagnostics API, Save Schema, or Randomizer algorithm version changes. The Gen2 party-item repair is an internal representation-normalization seam; Saved Setup Preset persistence continues to use the existing installation-scoped cache contract.

## 2.7.101 API note

Nuzlocke public API numbers are unchanged. The engine source/documentation compatibility marker advances to **0.2.25** while the minimum remains `>=0.2.24 <2.0.0`. Gen1Recomp 0.2.25 adds read-only imported-version dataset views; this build records that capability but does not use it to replace active-game transaction authority.

# Nuzlocke API — 2.7.85

## 2.7.85 API / ownership notes

No public API or schema version changes. Compatibility API remains 34, Diagnostics API remains 1, and Save Schema remains 5. Crystal's starter presentation now explicitly fails open to the engine-owned native POKEPIC/cry callbacks; Nuzlocke retains transaction ownership only at the existing shared GIVEPOKE/tracker seam. DEV stored-state validation derives expected Randomizer registry sizes from exported live registries rather than hardcoded historical counts.



## 2.7.84 API / ownership notes

No Nuzlocke public API number changes: Compatibility API remains 34 and Diagnostics API remains 1. The engine compatibility marker advances to **0.2.24**, the minimum engine becomes `>=0.2.24 <2.0.0`, and the explicit manifest target set becomes Red/Blue/Yellow/Gold/Silver/Crystal. Crystal is tagged internally as `stage = "ALPHA"`; exact edition remains `crystal`, generation remains 2, and shared Gen-2 providers/adapters are reused only where the underlying engine contract is common.

Upstream `mod.developer` remains the engine-owned developer signal. `mod.world:activeBlockAt()` and `map.occupancy_allowed` are recorded as useful Gen-1 map-safety seams but are not new Nuzlocke API surfaces. `battle.field_residual` remains intentionally unused until Gen-2 parity exists. `src.ui.OptionRows` remains forbidden on Gen-2 Nuzlocke UI, and direct `src.script.Commands` use remains a Gen-1-only compatibility boundary.


## 2.7.83 API / ownership notes

No public API version changes. Compatibility API remains 34 and Diagnostics API remains 1. The new loadout and Difficulty selectors consume existing internal `LockePreset.preview/apply`, `difficultyProfileSummary()`, `difficultyImpactChanges()`, and `difficultyStackWarning()` ownership rather than adding a parallel configuration API. Manual Gen-2 time is a Nuzlocke-owned UI action over the engine's native `src.core.gen2.Clock`; it does not introduce a new clock provider contract.


## 2.7.82 API / ownership notes

No public API version changes in 2.7.82: Compatibility API remains 34 and Diagnostics API remains 1. `releaseSafetyAudit()` is retained as an internal/build-process capability but is no longer executed or inserted into player-facing `Dev.selfTest()` results. Internal report-code/fingerprint helpers are retained for compatibility/testing but normal/exported Dev text no longer depends on or renders them. Gen-2 adapter installation now accepts the exact lifecycle Game through `G2.installAll(game)` internally; this is an ownership/lifecycle repair, not a new public provider surface.


## Gen1Recomp 0.2.21 compatibility surface

The source-audited engine profile is 0.2.21. Mod API remains 2. `mod.developer` is recorded as engine-owned diagnostic metadata and is intentionally separate from Nuzlocke's `dev_mode`. Gen2 clock integration prefers native `Clock.hostMinutes()` / `hostWeekday()` and writes only through `Clock.setTime()` / `setWeekday()`. `battle.field_residual` is noted as available on Gen1 but is not adopted by Nuzlocke in this build.

## 2.7.80 internal transaction/clock behavior

No public API or save-schema version changes. 2.7.80 adds internal Gen-2 pending Elm transaction finalization, native clock integration, and Rare Candy batch-cancellation state only. Compatibility API remains 34 and Diagnostics API remains 1.

## 2.7.79 internal Gen-2 starter authority

No public API/schema version changes. 2.7.79 changes internal shared Gen-2 Elm transaction classification, proven-starter story reconciliation, reachability diagnostics, and presentation helpers only; Compatibility API remains 34 and Diagnostics API remains 1.


No public API/schema version changes. 2.7.77 changes internal Gen-2 UI/script/randomizer integration only; Compatibility API remains 34 and Diagnostics API remains 1.


## 2.7.78 internal recovery behavior

No public API/schema version changes. 2.7.78 changes internal starter identity normalization and cross-edition Recover Catches availability only; Compatibility API remains 34 and Diagnostics API remains 1.
## 2.7.76 internal Gen-2 diagnostics

No public API/schema version changes. 2.7.76 adds internal Gen-2 adapter reachability diagnostics only.

## 2.7.66 rule-availability audit, pass 2

- Continues the rule-availability audit in a deliberately small pass.
- Yellow no longer exposes Random Starter `Trio Typing` as a native rule because Yellow does not natively use the three-choice starter slate; an explicit compatible `starter_trio` provider can make it available.
- Encounter-slot modifiers now depend on `One Per Area`: Failed Encounters, Dupes, Gen II roamer/egg/contest policies, Town Catches, and area/time/headbutt split controls become dormant while area encounter limits are OFF.
- Type Locke now exposes/effects only the lanes selected by its mode. Catch Draft is hidden while Type Locke is OFF; manual type lanes are hidden/inert during Catch Draft; DUO through HEXA progressively reveal only the required lanes.
- Stored values are preserved while dormant and return when their prerequisite becomes applicable again.
- Release Safety extends the exact-edition/dependency source tripwire for these relationships.


# Nuzlocke API — 2.7.65

## Rule availability contract — Compatibility API 34 / 2.7.65

`ruleNativeAvailableForEdition(rule, edition)`, `ruleAvailableForGame(rule, game)`, and `ruleOperationalState(key, preGame, game)` expose the shared availability/dependency decision used by configuration UI and effective gameplay reads. Hidden dependent/superseded values remain stored but resolve neutral while inactive.

## Compatibility owner preferences — API 33 / 2.7.64

The compatibility surface exposes live owner-choice helpers used by MOD COMPAT: `compatOwnerPreference(capability)`, `setCompatOwnerPreference(capability, value)`, and `compatOwnerChoices(capability, nativeOwner)`. Choices are derived only from the native owner plus providers discovered through advertised capability contracts. Preferences are save-local and default to `auto`.

Provider consumers continue to resolve through the normal live compatibility resolver; selecting a provider is therefore functional rather than display-only. Missing or inactive pinned providers fail open to `auto`.

## 2.7.57 presentation API addendum

`mod.exports.nuzlocke_ui_system` / `mod.exports.__beta26.UiSystem` is an experimental presentation-only API (v3). It exposes provider-neutral logical-surface policies plus live-font typography helpers for measured fit, wrapping, right-edge alignment, semantic rows, and notice models. These APIs carry no gameplay authority and remains internal and may evolve without public-API stability guarantees.

# Nuzlocke API — 2.7.57

This build does not change Compatibility API, Diagnostics API, Run History API/storage, Randomizer public API/algorithm, or Save Schema versions. It adds an internal/exported experimental `nuzlocke_ui_system` presentation object for Nuzlocke-owned screens; it is not yet a stable third-party compatibility API and must not be treated as one until explicitly versioned/promoted.

2.7.27 adds internal Learnset Randomizer hard-safety and soft semantic weighting only. Public API versions remain unchanged; providers can opt moves out through existing randomizable/protection metadata and should expose usable move records with a non-empty name and positive PP.
2.7.25 is a release promotion only. Public API versions and the provider/developer contract are unchanged from exact 2.7.24.
This document describes the **current provider/developer contract**. Historical API changes belong in `CHANGELOG.md`.

2.7.24 changes no public API version. The documentation audit reconciles the current transaction, Randomizer-ownership, Stadium provenance, Run History, and exact-game-context contracts with the shipped implementation. `Registry.describe(game)` uses one resolved game context for all returned registry and Randomizer-ownership fields.

## Versions

- Compatibility API: **32**
- Compatible from: **10**
- Diagnostics API: **1**
- Run History API/storage: **1**
- Randomizer public API/algorithm: **1**
- Save Schema: **4**

The canonical namespace is `mod.exports.nuzlocke`; the long-lived `__beta26` alias remains for compatibility.

### Randomizer ownership providers

The public interop capability resolver recognizes explicit ownership providers for overlapping randomizer mechanics:

- `starter_randomizer_provider`
- `encounter_randomizer_provider`
- `field_item_randomizer_provider`
- `learnset_randomizer_provider`

These provider capabilities are ownership/coexistence signals rather than permission to bypass Nuzlocke legality. A provider should advertise ownership only while it actually controls the overlapping mechanic. 2.6.90 adds `field_item_randomizer_provider`; it does not change Compatibility API 32 because the legacy `nuzlocke_compat` function surface was unchanged during build development.

### Compatibility API 32 — Field Item information

Compatibility API 32 adds spoiler-aware Field Item diagnostics:

- `Registry.fieldItemInformationPolicy(game)` — returns OPEN/BLIND policy and whether persisted randomized Field Item mappings may be revealed.
- `Registry.fieldItemDiagnostics(context)` — returns the read-only Field Item diagnostic payload. OPEN may include persisted randomized item choices; BLIND omits randomized item/category/table-class values while retaining safe edition/source/count/ownership/fallback metadata.
- `Registry.describe(game)` now includes `randomFieldItems` and `fieldItemInformation`.

Field Item diagnostic reads do not request a writable/AUTO seed, consume randomizer RNG, or intentionally mutate the FIELD_ITEMS mapping/constraint ledger.

### Field Item randomizer helper contracts

The internal compatibility namespace exposes read-only Field Item foundation helpers for diagnostics/integration:

- `randomFieldItemClassification(itemId, def)` — returns the authoritative protection category/reason.
- `randomFieldItemSourceIdentity(game, semanticSlot, context)` — returns permanent edition/source identity; authored item contents are not part of the canonical persistence key.
- `randomFieldItemOwnership(context)` — reports whether the source belongs to Nuzlocke Field Item randomization. Visible sources are eligible, and native Gen II hidden/BG-event sources are eligible only when explicitly marked `nuzlockeOwnedHidden=true`; other hidden/provider sources are not claimed.
- `randomFieldItemEditionProfile(game)` — reports exact edition/generation, `GEN1_FLAT` vs `GEN2_POCKETS`, merged `data.items` ownership, native visible pickup seam, and hidden-item ownership state.
- `randomFieldItemEditionTableClass(game, itemId, def)` — normalizes the live item definition to an edition-specific item-table class.
- `randomizerFieldItemInfo(game, reveal)` — internal read-only diagnostic payload used by Compatibility API 32.

These internal helpers did not themselves bump the public API. At that historical release, the public Compatibility API was **32**; public Field Item information is exposed through the Registry methods above.

### Randomizer information registry additions

Compatibility API 30 added read-only starter-information access through the public registry:

- `Registry.starterInformationPolicy(game)` — returns OPEN/BLIND starter reveal policy and whether Random Starter is active.
- `Registry.starterInformation(context)` — returns the policy plus read-only starter diagnostics. OPEN INFO may include the persisted positional starter slate; BLIND INFO suppresses species while retaining version/seed/settings/candidate/fallback metadata.

These calls consume no randomizer RNG and do not materialize or rewrite starter mappings.


Compatibility API 31 adds encounter diagnostics:

- `Registry.encounterDiagnostics(context)` — returns spoiler-aware, read-only encounter randomizer metadata. OPEN INFO may include live randomized source species; BLIND INFO excludes species while retaining source identity, class/time/group, candidate/protection/split/mapping/fallback metadata.
- `Registry.encounterInformation(context)` — now includes the same `diagnostics` payload. API 31 also hardens BLIND behavior: a discovered/owned context may be individually allowed, but BLIND never returns the whole randomized registry; OPEN retains full-registry reveal.
- Area Split changes may emit `registry_changed` with kind `encounter_identity`; this invalidates logical tracker/information views only and does not imply that the physical randomized encounter registry was regenerated.

Encounter diagnostic reads consume no RNG and do not intentionally mutate encounter mappings or the constraint ledger.

## Acquisition API

`Acquisition.evaluate(context)` is the canonical public legality entry point for non-native/provider acquisitions. The acquisition vocabulary is defined by `Acquisition.KINDS`; semantic enforcement is defined by `Acquisition.KIND_POLICY`. Adding a kind without a complete policy row is an initialization error.

### Acquisition kind semantics

| Kind | Capture rule | Species legality | Area legality | Party admission | Source rule |
| --- | ---: | ---: | ---: | ---: | --- |
| `wild` | yes when `captureAttempt=true` | native catch path | native catch path | native catch path | normal encounter |
| `gift` | no | yes | yes | yes | gift policy |
| `trade` | no | yes | yes | yes | trade policy |
| `trainer_capture` | yes when capture attempt | yes | no | yes | provider-owned capture |
| `theft` | yes when capture attempt | yes | no | yes | provider-owned capture |
| `owned_capture` | yes when capture attempt | yes | no | yes | provider-owned capture |
| `quest` | deliberate provider/source semantics | policy-defined | policy-defined | policy-defined | content/provider |
| `summon` | deliberate provider/source semantics | policy-defined | policy-defined | policy-defined | content/provider |
| `scripted` | neutral unless caller supplies specific policy | no automatic sweep | no | no | scripted owner |
| `forced` | neutral unless caller supplies specific policy | no automatic sweep | no | no | scripted owner |
| `editor` | neutral | no | no | no | tooling/editor |
| `wonder_trade` | observe-only | no transaction veto | no | provider transaction | external owner |

For the current matrix, `trainer_capture`, `theft`, and `owned_capture` deliberately receive No Catching on true capture attempts, species legality (Type Locke, species bans, Maximum BST, glitch policy, etc.), and Party Size admission without pretending they are ordinary area encounters.

### Species legality

Species legality may consult merged/provider metadata for types, BST/base stats, generation, Legendary/Mythical/Pseudo flags and other classification facts. Authoritative legality paths fail closed on provider/classifier exceptions rather than silently allowing an acquisition.

## Semantic enforcement coverage and regression contract

`mod.exports.__beta26.semanticEnforcementCoverage()` returns a defensive copy of the high-risk operation coverage matrix. Each row identifies rule keys, edition/capability scope, authoritative enforcement seam, provider surface, and evidence class. It is a review/test map from behavioral promises to enforcement owners, not another source of rule defaults.

`mod.exports.__beta26.semanticBehaviorRegressionAudit()` is the non-mutating behavior-level regression suite. Release Safety executes it on every full gate. The initial 2.6.55 suite exhaustively checks acquisition-kind policy shape, critical acquisition semantics, classifier precedence, the complete randomizer policy/alias vocabulary, and required semantic-coverage rows. A failed assertion fails the release gate.

## Stadium acquisition provenance API v2

`mod.exports.nuzlocke_acquisition_provenance` is the cooperative Stadium provenance surface. Model/render imports and Pokémon acquisitions are intentionally separate.

- `mark(mon, origin, context?)` marks one actual Pokémon as `STADIUM PRIZE`; `origin` accepts Stadium 1/2 forms. Optional `provider_id`/`mod_id` and exact-edition metadata are retained.
- `markImported(mon, context)` is the explicit transfer/import helper. `context.origin` is required unless `use_detected_origin=true` is deliberately supplied.
- `describe(mon)` returns saved Stadium acquisition source/origin/provider/edition metadata when present.
- `compatibilitySnapshot(game)` is read-only and reports the exact running edition plus detected Stadium Overworld/UI, Stadium 2, and Crystal 251 presentation/importer surfaces. Its `acquisition_policy` is `explicit_only`: simply loading or importing Stadium models never marks a Pokémon as Stadium-derived.

Compatible transfer/import mods should mark only the Pokémon they actually create. Presentation-only Stadium mods should not call the acquisition marker.

## Content / encounter API

Content providers may register areas, dungeons, bosses, gifts and encounters. Encounter metadata can include source id, map/area id, species, static/fixed provenance, progression requirement, randomizability, provider ownership and variant/form identity.

### Randomizer policy vocabulary

One canonical normalizer is used across encounter registration, encounter policy setters, inline encounter contexts, learnset policy setters and readers.

Canonical values:

| Value | Meaning |
| --- | --- |
| `allow` | Nuzlocke may perform its randomizer transform. |
| `deny` | Preserve this encounter/learnset; Nuzlocke does not transform it. |
| `provider` | Another provider owns randomization; Nuzlocke steps aside. |

Aliases:

- `true` → `allow`
- `false` → `deny`
- `preserve` / `story` → `deny`
- `external` / `owned` → `provider`

Unknown values are rejected rather than silently interpreted.

## Battle-role API

Dynamic trainer providers should publish semantic roles instead of relying on trainer-name substring matching. Supported roles include:

- `rival`
- `gym_leader`
- `elite_four`
- `champion`
- `progression_boss`
- ordinary trainer/default

Live trainer-party providers may also supply the final composed team so level-cap/team-size diagnostics follow actual battle content.

## Species / move metadata

Live merged/provider species metadata is first-class evidence. Nuzlocke prefers explicit provider/live move-category metadata over fallback Physical/Special mappings. External moves that explicitly declare a correct category are not rewritten merely because they belong to an older type family.

## Level-cap / EXP composition

Authoritative Nuzlocke EXP clamps run outside ordinary EXP multipliers. A blocked cap award remains zero. Cooperative contexts may expose `nuzlockeExpBlocked`, block reason and cap metadata.

## Held-item capability

Gold/Silver use the native held-item engine. R/B/Y can expose No Held Items only when a compatible external held-item capability is present. Providers should keep GIVE/TAKE semantics distinguishable so Nuzlocke can block GIVE while preserving safe removal/recovery.

## Gameplay transaction contract

`mod.exports.__beta26.GameplayTransactions` is the v1 interruption-recovery coordinator. It owns one durable pending journal (`__nuzlocke_gameplay_txn_v1`) plus bounded committed receipts (`__nuzlocke_gameplay_txn_receipts_v1`). A transaction kind is registered with `register(kind, { probe=..., perform=... })`; `probe` must return applied/not-applied/unknown semantics and `perform` owns all externally visible mutation. The durable COMMIT state is a journal marker, not a second arbitrary side-effect callback.

`execute(id, kind, payload)` provides exactly-once replay protection for a stable logical transaction identity. Durable receipt authority is **ID + kind**; an ID collision with another kind fails closed. `recover()` resumes a pending transaction after load. Unknown/ambiguous reconciliation fails closed. Unsupported future transaction journals are preserved: execute/recover and journal-mutating helpers (`advance`, `checkpoint`, targeted `clear`, and broad `clear`) reject them with `newer_transaction` rather than rewriting or deleting them. `setExact(id, key, value)` is the initial generic recovery-safe save-value primitive.

The coordinator is infrastructure, not a blanket claim that every historical gameplay action is atomic. Feature owners adopt it only when they can prove a stable id and a deterministic reconciliation probe.

## Install / diagnostics contract

`mod.exports.__beta26.safeInstall(spec, fn, ...)` is the central fail-soft installer entry point. `spec` may provide stable `id`, `feature`, `required`, `priority`, and `mode` metadata. `attemptInstall(name, fn, ...)` remains a compatibility alias. An explicit installer `false` is a diagnostic failure rather than a successful `pcall`.

`mod.exports.__beta26.hookRegistry` records hook ids with owner, prior/wrapper references where available, priority, mode, feature and source metadata. `describe()` returns a defensive diagnostic view; `audit()` treats malformed ownership/metadata as failure while legitimate top-level interposition is reported as a warning rather than automatically breaking release safety.

`mod.exports.__beta26.featureHealth` summarizes supported feature/install state as `ACTIVE`, `DEGRADED`, or `UNAVAILABLE`. Existing detailed Dev Hook Health remains the engine-facing diagnostic source and feeds this stable summary. Install failures are retained with standardized `[Nuzlocke:Subsystem]` diagnostic prefixes.

## Stability rules for providers

- Treat public tables as read-only unless a setter/register function explicitly owns mutation.
- Prefer semantic capabilities over mod-name checks.
- Preserve explicit caller values; provider/default metadata should fill only absent values.
- Do not rely on accidental `_ENV` lookup or private Nuzlocke locals.
- Provider/API correctness has its own confidence status; player-facing Runtime PASS does not imply provider-interop PASS.


## Gen1Recomp 0.2.20 source-compatibility audit

The 0.2.19 → 0.2.20 delta changes no public Nuzlocke provider API requirement and no Gen1Recomp Mod API version. The main compatibility-relevant engine change is stronger launcher/session teardown: generated Data, mod Runtime state, Assets loader state, LegacyCompat state, and generation-specific Game instance fields are reset before a later in-process Edit/Play session. Gold/Silver also gain extracted label-keyed engine text through `data.text`. These changes require no Nuzlocke API migration; runtime validation remains separate from source compatibility.

## Gen1Recomp 0.2.19 mod-options persistence audit

Gen1Recomp's `modOptions` store is installation/options state rather than Pokémon save progress. Engine tests explicitly round-trip `modOptions.nuzlocke` through the flat `options.lua` store and verify Gold reads/writes the same flat store as Gen 1.

For Nuzlocke preset design, however, the public API boundary matters: `mod.options` exposes `define(schema)` and `get(key)`, but no runtime `set` method. The in-game/launcher option manager owns writes and persistence. Supported schema row types are toggle, choice, number, and text. Therefore a future named Saved Setup Presets feature should not reach behind the public facade or mutate engine internals merely to write arbitrary preset blobs. Keep the existing working setup-profile persistence until a supported writable installation-scoped API is available, or represent a deliberately bounded preset surface as normal engine-owned option rows.

## Experimental presentation API

`nuzlocke_ui_system` apiVersion 2 is test-only. It adds screen policies and logical layout contexts. It is not yet a stable public compatibility API.

## Gen1Recomp 0.2.27 catch nickname seam

On 0.2.27+, Nuzlocke subscribes to `catch.nickname(mon, ctx)` for Red/Blue/Yellow catch-name policy. When Nickname Rule is active it returns `true` at the engine decision boundary and marks the mon as nickname-required; the existing naming-screen enforcement remains responsible for rejecting an empty result. The historical `battle.nickname` subscription is retained solely for supported older engine builds.
## Shiny provider ownership detection (2.8.36 / Shiny Pokémon 1.2.7)

Nuzlocke's external shiny-owner resolver prefers the existing public `nuzlocke.interop` provider registry. A `SHINY_POKEMON` registration advertising `SHINY_IDENTITY` plus `SHINY_PRESENTATION` is sufficient for Nuzlocke to stand down its own shiny generation/presentation. If registration order has not completed, Nuzlocke may read the companion's generation-neutral `exports.shiny_pokemon` / `exports.shiny_compat` API and ownership descriptors. The older top-level `isShiny` / `rollShiny` surface remains compatibility fallback only. This changes no Nuzlocke public API version.

Palette/COLORS changes do not authorize Nuzlocke to invalidate engine Renderer/Assets state. Nuzlocke's custom-species fallback shiny cache is private and palette-signature-keyed instead.

## Semantic APIs added in 2.9.15

The following additive API-v1 surfaces are exported under `mod.exports.nuzlocke` without changing Compatibility API 36:

- `action` — `evaluate(action, context)` / `canPerform(action, context)` for semantic challenge actions. It delegates to the existing item, acquisition, service, and escape-policy owners rather than duplicating rule state.
- `services` — `evaluate(kind, context)` / `canUse(kind, context)` for `CENTER`, `MOM`, `STORY_HEAL`, `EXTERNAL_HEAL`, `SHOP_BUY`, `SHOP_SELL`, and `DAYCARE`. Story/external healing are intentionally distinct from Center/Mom ownership.
- `capability` — read-only `describe(game)` / `supports(name, game)` edition and feature-capability introspection. Edition maturity remains Red/Blue/Yellow mature, Gold/Silver beta, Crystal alpha.

Unknown actions/services fail open as unknown semantic vocabulary; internal policy evaluation errors fail closed. These APIs do not change gameplay defaults or save representation.

## Acquisition/Provenance API 1 and Event Contract 1 (2.9.15)

`mod.exports.nuzlocke.acquisition` formalizes the existing acquisition lifecycle with `classify`, `evaluate`, `begin`, `commit`, `commitDecision`, `observe`, and `capabilities`. Pre-transaction policy and post-mutation observation are explicitly distinct. Observation-only integrations must never imply that a received Pokémon can safely be rolled back.

`mod.exports.nuzlocke.events` provides Event Contract 1: a small semantic envelope (`api`, session-local `seq`, `kind`, `edition`, `source`, optional `subject`, `context`, and `data`) plus `emit`. The event contract is observational and non-persistent; it does not change Save Schema 5 or replace Run History's durable chronology.


## Graveyard diagnostic surface (2.9.16)

`mod.exports.__beta26.graveyardHealth(game)` and `graveyardRows(game)` are internal diagnostic/presentation helpers, not a new public compatibility API. They are read-only projections over existing durable history. External integrations should continue to use the published semantic APIs rather than treating Graveyard internals as a compatibility contract.


## Almanac diagnostic surface (2.9.17)

`mod.exports.__beta26.almanacSnapshot(game)` returns the read-only player-facing projection used by the Almanac. `mod.exports.__beta26.almanacHealth(game)` reports structural availability/partial-coverage state for DEV diagnostics. These are internal diagnostic/UI surfaces, not a new public compatibility API. They do not repair/migrate Run History or write save state.

## 2.9.72 additive diagnostics
`randomTrainerTrace(game)` is read-only observational evidence for the latest trainer pipeline. Bug-report snapshots also include the latest Random Shop trace, field-item normalization record, and shiny presentation record. These surfaces do not roll RNG or materialize unseen mappings.
