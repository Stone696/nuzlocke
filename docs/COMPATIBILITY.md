# Nuzlocke 2.4.69 RC compatibility

## Future-schema downgrade safety
2.4.63 treats a Nuzlocke save schema newer than 4 as unsupported by this build. Migration stops, ordinary Nuzlocke enforcement pauses, and known lifecycle repair writers are suppressed. The player receives a session-only warning rather than having the older build silently reinterpret newer-format state.

## Dev hook-health diagnostics
2.4.64 can report whether selected observable adapters are top-level, composed beneath another live wrapper, missing, or pending. A **CHAINED** result is not automatically a conflict: another compatible mod may wrap above Nuzlocke while preserving the predecessor chain.

## Dev lifecycle diagnostics
2.4.65 adds passive event-delivery counters without changing listener installation. Repeated delivery of the same event payload is surfaced as duplicate-callback evidence, which is useful when validating engine/mod hot-reload behavior.

## Future-schema write-attempt diagnostics
2.4.66 instruments Nuzlocke's scoped save writer so downgrade testing can verify that no unguarded repair/enforcement path reaches persistent Nuzlocke state after the future-schema safe-stop activates. The instrumentation observes and delegates; it does not replace the existing guards.

## Dev rule-effectiveness diagnostics
2.4.67 exposes configured/effective rule values alongside current ownership. Delegated rows identify the external owner and relationship/capability context, making it easier to distinguish a rule that is intentionally neutralized by compatibility from one that is unexpectedly inactive.

## Dev Randomizer integrity
2.4.68 distinguishes Nuzlocke-owned Random Encounter output from externally delegated randomizers. Delegated ownership is surfaced with provider context and is not scanned against Nuzlocke's internal candidate contract. Content-provider slots that explicitly opt out through `shouldRandomizeEncounter` are likewise excluded.

## 2.4.69 RC compatibility status
The RC preserves the 2.4.68 compatibility surface unchanged: Save Schema 4, Compatibility API 27, Mod API 2, and manifest range `>=0.1.86 <2.0.0`. No provider contract is intentionally changed in the RC promotion.

## Current engine contract
- Audited Gen1Recomp: **0.2.1**
- Runtime-changing 0.2.x release: **0.2.0**
- Manifest range: **`>=0.1.86 <2.0.0`**
- Mod API: **2**
- Save Schema: **4**
- Compatibility API: **27**
- Games: Red / Blue / Yellow / Gold

## Launcher / engine-version policy
`game_version` is an engine-semver guard, not a launcher-build pin. 2.4.57 keeps the established minimum but broadens the upper bound below the next engine major: `>=0.1.86 <2.0.0`. Mod API 2 remains the separate breaking mod-surface contract. Runtime certification is still tracked independently from whether the manifest permits loading.

## Current parity notes
- Gold No Held Items: Gold ✅ / RBY omitted by design.
- Historical Difficulty transforms live composed trainer parties and respects provider ownership.
- Gold remains beta and some generation-specific seams still require targeted adapters/runtime tests.

## Maintained rule × game-family parity matrix
| Rule | R/B/Y | Gold | Notes |
|---|---:|---:|---|
| Core Nuzlocke / Permadeath / One Per Area | ✅ | ✅ | Gold runtime parity still needs continued regression coverage |
| Nickname Rule | ✅ | ✅ | Gold path is generation-specific |
| Dupes / Shiny / Failed Encounters | ✅ | ✅ | Limited Shiny combinations remain targeted tests |
| No Healing Items / No X Items | ✅ | ✅ | Gold TEST REQUIRED |
| No Held Items | — | ✅ | Introduced 2.4.51; runtime TEST REQUIRED |
| No Repels / Escape Rope / PP Items / TMs / Rare Candy | ✅ | ✅ | Gold TEST REQUIRED |
| No Buying / Selling / Center / Mom / Day Care | ✅ | ✅ | generation-specific service gates |
| Level caps / EXP edging | ✅ | ✅ | provider-aware |
| Historical Difficulty | ✅ | ✅ | current final profile set restored in 2.4.53 |
| Physical/Special Split | ✅ | ✅ | independent toggle |
| Travel / Gym / Dungeon Lock-In | ✅ | ✅ | runtime edge cases remain |
| Randomizer controls | ✅ | ✅ | generation-specific registries/providers |
| Party Size / Evolution Limits | ✅ | ✅ | runtime hardening remains |
| Encounter Tracker / indicator | ✅ | ✅ | Modern UI historical crash regression remains |

## Compatibility research ledger policy (2.4.24)

This ledger is the project's source of truth for external-mod/tool research. Every future compatibility or learning pass must update the relevant row in the same build. A source review is **not** a runtime PASS, and design inspiration from a ROM hack is **not** Gen1Recomp interoperability. Code adapters should be added only when a public/cooperative seam exists or a concrete incompatibility is demonstrated; do not add speculative private-hook branches merely because two mods touch related concepts.

Evidence/status vocabulary:

- **RUNTIME PASS** — the named combination/behavior was exercised successfully.
- **SOURCE/STATIC** — implementation was inspected and composition was reasoned about, but the combination still needs runtime confirmation.
- **ARCHITECTURE/LEARNING** — researched for API/ownership/design lessons; not necessarily an installed-mod compatibility claim.
- **DESIGN INSPIRATION** — ROM-hack/challenge-rule research only; never call this runtime compatibility.

| Mod / tool | Version last inspected | Last audit | Analysis type | Current Nuzlocke treatment | Runtime status / limitation | Re-audit trigger |
|---|---:|---|---|---|---|---|
| Gen1Recomp upstream | 0.2.1 | 2026-08-17 / 2.4.55 | SOURCE/STATIC + historical runtime | 0.2.0 mod-runtime baseline plus launcher-only 0.2.1 hotfix; official `mod.storage`; improved Gold `catch.rate` context; explicit Gold fallbacks retained where parity is incomplete | Current source-audited engine; individual Nuzlocke features still carry their own runtime status | New Gen1Recomp release or changed documented hook/registry/storage contract |
| Kanto Ascendant | 6.5.4 | 2026-08-17 / 2.4.12 | SOURCE/STATIC | External difficulty/trainer-level/wild-level/Trainer Card presentation ownership classification | Combination TEST REQUIRED | Ascendant difficulty/provider contract changes |
| Wilds of Kanto | 2.1.7 | 2026-08-17 / 2.4.11 | SOURCE/STATIC | Audited overworld-catch policy + tracker bridge | Runtime combination TEST REQUIRED | Wilds catch/storage exports or overworld acquisition flow changes |
| Modern Party UI | 0.3.8 | 2026-08-17 / 2.4.11 | SOURCE/STATIC | Presentation provider; avoid controller double-wrapping | Runtime combination TEST REQUIRED | Party controller/ownership changes |
| Gen1 Modern UI | current audited project surface | 2026-08-17 | SOURCE/STATIC + historical runtime report | Dedicated presentation integration | Historical Encounter Tracker crash report remains unresolved without new PASS | Modern UI tracker/menu implementation changes or crash is retested |
| Stronger Trainers | audited beta.29-era build | 2026-08-14–15 | SOURCE/STATIC + RUNTIME PASS | Compose after final `trainer.party`; observe final party for cap preview | Yellow modified-cap runtime PASS; broader matrix not fully certified | Trainer-party hook ownership changes |
| Indigo Plateau Conference | 1.0.2 | 2026-08-14–15 | SOURCE/STATIC | IPC owns tournament staging/state/healing; Nuzlocke retains permadeath/whiteout/tracker semantics | Runtime combination TEST REQUIRED unless otherwise recorded | Tournament lifecycle/whiteout ownership changes |
| Kanto Life | historical project version; current upstream unresolved | 2026-08-17 / 2.4.31 resolution attempt | ARCHITECTURE/LEARNING / UPSTREAM UNRESOLVED | Preserve NPC coexistence/capability lessons; no named adapter inferred from stale evidence | Current source cannot be certified until canonical upstream is resolved | Canonical repository/version is identified |
| NPC Bubbles | historical project version; current upstream unresolved | 2026-08-17 / 2.4.31 resolution attempt | ARCHITECTURE/LEARNING / UPSTREAM UNRESOLVED | Preserve NPC presentation-coexistence lesson only; no current adapter claim | Current source cannot be certified until canonical upstream is resolved | Canonical repository/version is identified |
| Ironmon Ultimate | earlier researched version | by 2026-08-14 | ARCHITECTURE/LEARNING | Difficulty/Ironmon design and provider lessons | Not a runtime certification | Revisited for active interoperability |
| Enemy HP | earlier researched version | by 2026-08-14 | ARCHITECTURE/LEARNING | Battle presentation/hook coexistence lessons | Not a runtime certification | Revisited for active interoperability |
| Shiny Pokémon | 1.0.8 | 2026-08-17 / 2.4.31 | SOURCE/STATIC (R/B/Y) | Nuzlocke observes semantic shiny state/native DVs; no presentation ownership conflict; no named adapter | HIGH expected R/B/Y compatibility; Randomizer + shiny wrapper and Limited Shiny finite modes require runtime tests; Gold not certified | `Pokemon.new`/`BattleState.newWild` ownership changes, explicit Gen2 support, or shiny-state contract changes |
| Too Many Balls (formerly Kanto Balls) | 0.6.1 | 2026-08-17 / 2.4.31 | SOURCE/STATIC | Generic merged Ball/item detection; generation-specific custom-ball mechanics remain external-mod-owned; no named adapter | HIGH expected compatibility; Ball restrictions + custom-ball catches on Gen1/Gen2 remain runtime TEST REQUIRED | Ball registry/item metadata, Gold `catch.rate`, pocket/mart, or custom acquisition contract changes |
| QoL Toggles | 1.24.1 | 2026-08-17 / 2.4.31 | FULL SOURCE/HOOK AUDIT + LOCAL ADAPTER | Restriction > convenience precedence; option-aware running ownership; AUTO-REPEL direct-consumption guard | MEDIUM-HIGH expected -> HIGH target; targeted runtime combination tests required | Catch/heal/run/item/field-move/EXP/economy hook or option-key changes |
| Gen1Recomp built-in Save Editor | dev/current upstream audit | 2026-08-17 / 2.4.33 | FULL SOURCE/SAVE-MUTATION AUDIT + LOCAL RECONCILIATION | Whole-save decode/encode preserves mod fields; Nuzlocke reasserts dead-state and reports external party-cap violations without destructive correction; external additions retain EDITED provenance | HIGH structural; edited-save runtime round trips TEST REQUIRED | SaveData/editor mutation funnel, validation behavior, party capacity, or mod-state serialization changes |
| Quality of Life (unxpected-uxp) | 1.3.0 | 2026-08-17 / 2.4.32 | FULL SOURCE/HOOK AUDIT + LOCAL ADAPTER | Gen1 Easy Interactions SELECT shortcut suppressed during Travel/Dungeon vetoes; Gold native field-move path retained; Repels remain under existing item/native policy | HIGH expected compatibility; targeted runtime tests required | Easy Interactions field-move/Repel invocation or option architecture changes |
| Kanto Reforged | audited earlier project version | ~2026-08-10–11 | ARCHITECTURE/LEARNING | Broad content-expansion stress case: species/types/held items/trainers/wilds | Not a current runtime certification | Revisited for active interoperability |
| AIRivials | 2.1.0 | 2026-08-17 / 2.4.14–15 | SOURCE/STATIC (release surface limited) | No guessed adapter; persistent rival party should remain AIRivials-owned | 2.1.0 implementation asset was not fully source-auditable in connected tree | Release source becomes inspectable or trainer-party ownership changes |
| Floating Battle HUD | 0.5.7 | 2026-08-17 / 2.4.14–15 | SOURCE/STATIC (release surface limited) | Shared HUD visibility/coexistence principles; no guessed private adapter | Runtime/source package follow-up needed | New source/release or HUD ownership changes |
| All Pokémon Catchable 151 | 0.3.3-beta | 2026-08-17 / 2.4.22–23 | SOURCE/STATIC | Treat as ordinary merged content; Nuzlocke retains legality/area/dupes/species/BST/Shiny/Evolution Limits/tracker ownership | High expected compatibility; runtime combo TEST REQUIRED | Encounter/evolution acquisition model moves away from content registries |
| Gen1Recomp Content Editor | 2026-08-17 main | 2026-08-17 / 2.4.22–23 | ARCHITECTURE/LEARNING + SOURCE/STATIC | Generic content-mod resilience target: custom maps/species/balls/trainers/events | Tool itself is not a gameplay mod; generated mods vary | Generated runtime schema/content capabilities change |
| Trainer Talk | 0.2.6 | 2026-08-17 / 2.4.24 | SOURCE/STATIC | No adapter; live hooks are observational/audio and preserve ownership | HIGH expected compatibility; runtime combo untested | Commented catch/run/accuracy/Gym/E4/Champion hooks become active |
| Spaceworld's Sprites | 1.0 | 2026-08-17 / 2.4.24 | SOURCE/STATIC | Presentation-only sprite ownership; gameplay identity remains species/data based | HIGH expected compatibility; runtime combo untested | Begins modifying species/gameplay records or non-presentation hooks |
| Gen2-3D-Sprites / Stadium 2 Overworld Models | 0.2.81 | 2026-08-17 / 2.4.24 | SOURCE/STATIC | No speculative private adapter; existing Wilds/content policies expected to cover normal paths | MEDIUM-HIGH; direct overworld capture + party/box insertion and custom Gold UI require targeted runtime tests | Overworld capture/storage, embedded Wilds version, battle UI, or provider exports change |
| Pokémon Heart & Soul | researched 2026-08-17 | 2026-08-17 | DESIGN INSPIRATION | Backlog/challenge-option ideas only | Not a Gen1Recomp compatibility claim | Only if used as design research again |
| Pokémon Crystal Clear | researched 2026-08-17 | 2026-08-17 | DESIGN INSPIRATION | Backlog/challenge-option ideas only | Not a Gen1Recomp compatibility claim | Only if used as design research again |

### Targeted Gen2-3D-Sprites runtime matrix

Before promoting that row beyond SOURCE/STATIC, test Gold with its direct overworld capture enabled for: Nuzlocke capture legality (One Per Area/Dupes/Shiny/Type/BST/species bans), No Catching, Ball restrictions, failed-throw encounter consumption, tracker/physical-area attribution, Party Size Limit 1–5, full-party boxing, and Nuz Rules/Enc Tracker/Mods UI coexistence under its Stadium-style UI. A demonstrated bypass should be fixed at the narrowest public/cooperative seam available; do not preemptively patch private `addCaught()` internals.


## Generic content-mod hardening (2.4.23)

2.4.23 treats ordinary API-2 content mods as composers of the final runtime world, not automatic exclusive Nuzlocke providers. Tracker discovery now reads merged encounter registries as well as map registries; species category policy accepts common metadata tag/flag collections but fails open for unknown classifications; and semantic Ball detection can read dedicated merged Ball registries.

All Pokémon Catchable 151 therefore composes naturally through its encounter/evolution/item patches: Nuzlocke retains encounter legality, area ownership, Dupes, Type Locke, BST/species bans, Shiny Clause, Evolution Limits, and tracker state. Content-Editor-generated custom trainers are not guessed to be Gym Leaders from names/sprites; Gym Team Size and level-cap authority remain known-progression/provider-metadata driven.

## Current Gen1Recomp target

- Audited release: **0.2.1** (0.2.0 runtime; 0.2.1 launcher-only hotfix)
- Manifest: **`>=0.1.86 <2.0.0`**
- Mod API: **2**
- Games declared: Red, Blue, Yellow, Gold
- `affects_link: true`

2.4.57 broadened the manifest to `>=0.1.86 <2.0.0`. The range is an engine-semver load declaration, not automatic runtime certification; Mod API 2 remains the separate breaking mod-surface contract.


## Party Size Limit composition (2.4.22)

Party Size Limit uses Nuzlocke's existing acquisition and storage-transaction policy rather than replacing storage providers. Native R/B/Y and Gold PC withdrawal paths are composed at their public module seams; Gold box-to-party MOVE is denied only when it would grow the active party past the selected cap. Deposits and one-for-one moves remain provider-owned. Compatible alternate PC/storage mods can use `evaluateStorageTransaction` to honor the same rule. Runtime cross-provider confirmation remains TEST REQUIRED.

## Travel Restrictions composition (2.4.21)

Travel Restrictions reuses the shared `fieldmove.eligibility` chain. NORMAL delegates unchanged. NO FLY denies only `FLY`; NO FLY+TELEPORT denies `FLY` and `TELEPORT` while Nuzlocke is active. Other providers still receive unrelated field moves. Dungeon Lock-In is checked independently first and retains its existing DIG/TELEPORT/FLY denial while active. Scripted/story transportation does not use this player field-move rule. Runtime cross-provider confirmation remains TEST REQUIRED.

## Limited Shiny Clause composition (2.4.20)

The finite allowance is Nuzlocke-owned run state and does not change provider ownership. External capture providers that route successful catches through Nuzlocke's established `pokemon.caught` registration path share the same successful-catch allowance consumption. Absolute capture denials still resolve before Shiny Clause. Runtime cross-provider confirmation remains TEST REQUIRED.

## Evolution Limits composition (2.4.19)

Evolution Limits uses Gen1Recomp's public `evolution.check` hook, which is the engine evolution decision seam and is shared by R/B/Y and Gold in the current hook reference. NO FINAL derives terminal status from the final merged species records, so content mods that add a valid further evolution naturally extend the line. Missing/incomplete target metadata fails open. The rule is independent of Nuzlocke Loadout preset ownership. Runtime cross-mod confirmation remains TEST REQUIRED.

## Loadout/provider composition (2.4.18)

Loadout application does not write a rule currently delegated to an external provider, and delegated rows are ignored when deciding whether the remaining Nuzlocke-owned footprint exactly matches a named preset. Difficulty and other independent provider systems remain outside Nuzlocke Loadout ownership.

## Badge Boosts composition (2.4.17)

The player-facing `badge_boosts` rule owns only Nuzlocke's native battle-boost suppression path. OFF suppresses native badge boosts even with VANILLA Game Difficulty. Built-in profiles carrying `noBadgeBoosts=true` also suppress boosts, so the two controls compose without an ON setting overriding a profile restriction. External difficulty providers are not introspected or rewritten by this feature. Combination behavior remains TEST REQUIRED.

## What the 0.2.x audit changes for Nuzlocke

### Sandbox and diagnostics persistence

Gen1Recomp 0.2.x blocks direct mod access to `love.filesystem` and `love.system` and directs mods to engine-owned surfaces. Nuzlocke therefore persists Dev self-test bytes with `mod.storage`, which scopes data by game version, playthrough, and mod ID. No host path is exposed or documented as recoverable from the mod. Legacy compatibility shims are not used as the current implementation.

### Public APIs to prefer

- `mod.battle:snapshot()` for detached read-only current-battle state.
- `mod.world:availableFieldActions()` / `useFieldAction()` for contextual field actions.
- `battle.bottom_ui_visible` and `battle.status_hud_visible` for battle-presentation ownership.
- Public menu hooks (`ui.start_menu.items`, `ui.title_menu.items`, `ui.party.submenu`, `ui.list_menu`) instead of replacing whole menus when the public hook covers the need.
- Registry/content APIs during the merge phase; hooks/events for live per-save behavior.

### Public seam deliberately not promoted to authoritative enforcement

Gen1Recomp 0.2.x retains the Gen 1 BagMenu `item.use` dispatch hook. It is useful for integrations/animations, but it is not in the documented Gold hook set and does not replace every direct provider transaction. Nuzlocke therefore keeps its proven item-policy execution gates and advertises `item.use` as available, not authoritative.

### Gold coverage that matters

0.2.x retains broad shared Gold support for battle, encounter, menu, rendering, catch/evolution, and world hooks. In 0.2.0 the Gold Ball path additionally supplies the live battle, target mon, and species definition to `catch.rate`, then runs the shared caught/ball-thrown tail. Several holes still remain important to Nuzlocke:

- no Gold `trainer.before_battle` yet;
- no Gold `pokemon.before_give` / `pokemon.received` yet;
- Gold `encounter.roll` / `encounter.species` do not cover Headbutt, Rock Smash, or Roamer checks;
- Gold battle snapshot item inventory is intentionally limited by Pack architecture;
- Gold-specific content record shapes differ for Pokémon, trainers, encounters, statuses, held items, and several other registries.

Nuzlocke's Gold adapters should therefore remain explicit and guarded where these holes affect an enforced transaction.

## Known/current mod integrations

| Mod / surface | Current Nuzlocke treatment | Confidence |
|---|---|---|
| Kanto Ascendant 6.5.4 | External difficulty / trainer-level / wild-level / Trainer Card presentation ownership classification | Source-audited; combination TEST REQUIRED |
| Wilds of Kanto 2.1.7 | Direct overworld-catch policy/tracker bridge for catches that bypass normal BattleState lifecycle | Source-audited; runtime TEST REQUIRED |
| Modern Party UI 0.3.8 | Party presentation provider; avoid unnecessary controller double-wrapping | Source-audited; runtime TEST REQUIRED |
| Gen1 Modern UI | Dedicated Nuzlocke presentation integration exists | Historical Encounter Tracker crash report remains; do not claim fixed without runtime PASS |
| Wide Menus | Tracker/layout ownership composition | Historical runtime coexistence evidence exists; re-test when affected |
| Gen 2 Randomizer Plus / Randomizer providers | Capability/provider ownership; avoid double-randomization where ownership is declared | Combination-dependent |
| Kanto/Gold content & difficulty providers generally | Nuzlocke composes through provider capabilities and active merged data where possible | Provider-specific |


## G1RecompMods audit — 2.4.15

### Delta Type 1.2.0 (`delta_type`)

Delta Type stamps permanent transformed typing onto concrete Pokémon. Nuzlocke now prefers a concrete mon's runtime type fields for Type Locke legality. This is generic transformation compatibility rather than a Delta-specific catch exception. **TEST REQUIRED.**

### Dex Overflow 0.1.1 (`dex_overflow`)

Gold can battle with complete string-id species records that do not expose an 8-bit ROM `index`. Nuzlocke's Random Encounter pool now uses an encounter-specific runtime safety contract instead of globally requiring `def.index` on Gold. This allowance is intentionally not extended to starter/script/link byte-addressed paths. **TEST REQUIRED.**

### Safari Zone All 1.1.0 (`safari_all`)

Safari All changes the final species inside Safari/National Park scope. Nuzlocke records this as scoped encounter ownership while continuing to evaluate the resulting Pokémon for area, Dupes, Type Locke, BST/species bans, and tracker rules. It does not globally delegate all random encounters to Safari All. **TEST REQUIRED.**

### Wonder Trade 1.2.1 (`wonder_trade`)

Wonder Trade emits `pokemon.received` / `trade.completed` after its party swap. Nuzlocke classifies the integration as observe-only and does not attempt destructive rollback. This implementation is useful groundwork for a future Wonderlocke provider contract, but Wonderlocke remains disabled until a safe pre-transaction seam exists. **TEST REQUIRED.**

All four are optional dependencies so load ordering is explicit without requiring the mods. When an external mod publishes its own compatibility relationship, that declaration takes precedence over Nuzlocke's audited local fallback metadata.

## AIRivials 2.1.0 review

The 2.1.0 release metadata points to `ai_rivals_v2.1.0_life_paths_foundation.zip`. The repository/tag available to source inspection contains the README plus an older packaged ZIP rather than the 2.1.0 implementation.

The current README promises:

- rival progression state separated from player progression;
- persistent rival parties and PC boxes;
- rival catches, inventory, economy, badges and world progress;
- player battles through the normal trainer-battle system using the rival's actual persistent party.

That model is compatible in principle with Nuzlocke's player-owned rules. The main risk is Nuzlocke's built-in Difficulty composing `trainer.party`: an AIRivials battle should not have its persistent roster silently rewritten unless AIRivials intentionally delegates that ownership. Because the release implementation was not available in the connected source tree, **2.4.15 adds no guessed mod-id branch or adapter**.

## Floating Battle HUD 0.5.7 review

The release asset is `FloatingBattleHUD_v0.5.7.zip`; the Git tag itself exposes only a minimal README/license. Without release-asset source, 2.4.15 does not guess its mod id or hook implementation.

The engine-level compatibility direction is nevertheless clear: future Nuzlocke Encounter HUD work should use/recognize `battle.bottom_ui_visible`, `battle.status_hud_visible`, `battle.overlay`, `render.hud`, or another documented public presentation seam rather than assuming sole ownership of the battle screen.

## Link compatibility

Nuzlocke now explicitly declares `affects_link=true`. Gen1Recomp fingerprints mods that affect link simulation; mods changing battle rules need matching peers to avoid hidden lockstep divergence. Gold currently exposes no link menu, so this primarily affects supported Gen 1 link play.

## Private-engine access policy

The manifest still declares `engine_internals` because several Nuzlocke paths require behavior not fully represented by a shared public API, especially historical presentation and Gold-specific transactions. Private access is not a license to replace stable public hooks: migrate only when the public seam is behaviorally equivalent and regression-tested.

## Runtime certification

Source compatibility and runtime compatibility are separate. A source-audited integration is labeled TEST REQUIRED until tested in-engine. Protected historical PASS results remain evidence but do not automatically certify a newly changed interaction.

## Gen1Recomp 0.2.1 audit

Nuzlocke 2.4.55 includes the completed 0.2.1 compatibility review. The 0.2.1 delta from 0.2.0 does not change the sandbox, `mod.storage`, battle hooks, Gold capture seam, save API, registries, or generation adapters. The 2.4.49 0.2.x migration therefore remains the required runtime implementation.

## Gold held-item rule

Nuzlocke's **No Held Items** rule composes through Gold's held-item trigger rather than altering item records. It suppresses only effects belonging to exact members of the player's battle party; trainer-held items and difficulty-provider trainer equipment remain untouched.

## Historical Difficulty composition

2.4.55 continues to apply built-in historical-inspired Difficulty transforms **after** the live `trainer.party` composition base rather than replacing a provider's roster wholesale. External Difficulty entries remain authoritative when selected. Stable profile IDs are persisted independently of their numeric menu position.

## 2.4.60 runtime crash diagnostics

Config/Setup and NUZ STATUS runtime `xpcall` failures now enter the existing Dev diagnostic surface with their full traceback and current game snapshot when Dev Mode is enabled. This is diagnostics-only and does not change companion-mod authority or provider contracts.

## 2.4.59 passive diagnostics
Selected thrown failures at storage, save-upgrade, compat-loader, provider-discovery/activity/context/recovery, and provider species-metadata boundaries now enter Dev Mode's bounded error/snapshot trail. Intentional provider probing remains tolerant: alternate species-metadata signatures are tried before failure is reported. Mechanics-capability calculation itself is deliberately not guarded to avoid recursive diagnostics.

## 2.4.58 provenance/storage
Encounter provenance is battle-scoped and immutable after first resolution. Dev history uses only official `mod.storage` byte/list/delete APIs.

## 2.4.62 Random Encounter legality composition
Nuzlocke-owned encounter randomization now reuses the canonical acquisition-legality predicate when building its candidate species pool. This keeps Type Locke, Legendary/Mythical/Pseudo bans, and Maximum BST consistent with Random Starter and acquisition enforcement while preserving provider-backed species metadata/classification. External randomizer ownership/delegation behavior is unchanged.
