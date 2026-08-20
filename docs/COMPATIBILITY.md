# 2.6.0 compatibility note

No provider, ownership, engine, or hook contract changes. `progression_pc_catches` keeps the same compatibility semantics and is only relocated in the rule menu. Gen1Recomp 0.2.14 remains the latest audited and exact-runtime-booted engine; supported range remains `>=0.1.86 <2.0.0`.

# 2.5.92 compatibility note

No engine/provider compatibility contract changes. Built-in death producers are now idempotent per committed death occurrence, which also makes compatibility/provider re-entry safer without changing ownership or provider APIs.

# 2.5.91 compatibility note

No engine/provider compatibility surface changes. This release only corrects internal migration dry-run comparison semantics for copied table values.

# 2.5.90 compatibility note

The vanilla version-aware Gift/Trade source catalog is now package-local `acquisition_catalog.lua`. Existing compatibility aliases continue to resolve through the same `buildGiftLookup`, `buildTradeLookup`, and deterministic-source helpers. No provider ownership or engine compatibility contract changes.

# 2.5.89 compatibility note

No compatibility/provider contract changes. DEV REPORT diagnostics were moved to `dev_report.lua` with current game identity supplied through a live getter. Engine range and the audited Gen1Recomp 0.2.14 profile remain unchanged.

# 2.5.88 compatibility UI note

No provider/API/engine compatibility contract changes in 2.5.88. MOD COMPAT keeps Compatibility API 29 behavior and only changes presentation/session navigation: its classic detail panel reserves a dedicated footer row and remembers selected row/scroll/detail page for the current mod session.

# 2.5.87 Compatibility cleanup

Compatibility API **29** fixes a metadata hole where the audited engine could be 0.2.14 while the engine-profile table stopped at 0.2.11. Profiles for 0.2.12, 0.2.13, and 0.2.14 are now present, and Release Safety verifies the active profile exists. Provider inventory and compatibility-summary helpers are additive/read-only. `compatible_from = 10`, Mod API 2, Save Schema 4, and `>=0.1.86 <2.0.0` remain unchanged.

The 2.5.86 Encounter Tracker marker experiment is reverted; actual graphical status symbols are deferred to the backlog.

# 2.5.86 Encounter Tracker status markers

> **2.5.86 note:** ENC TRACKER now uses font-safe `O CAUGHT`, `X FAILED`, `- OPEN`, `* SHINY`, and `X DEAD` labels across classic R/B/Y, native Gold/Silver, and Modern UI presentation. Text remains explicit for accessibility; encounter mechanics and stored state are unchanged.

# 2.5.85 Run History producer compatibility

Run History observes already-settled Nuzlocke transaction boundaries and does not take ownership away from the engine or compatibility providers. Ordinary captures journal only after the host `pokemon.caught` event and Nuzlocke tracker/area commit. Provider-backed catches that reach the same established registration path therefore receive the same history treatment, while starter/gift/trade/progression acquisitions retain their dedicated producer paths and persistent-identity dedupe.

Gym Leader F. TOKEN history is appended only after the reward ledger and real carried-token state commit. The permanent semantic Leader identity is also the history dedupe key, so duplicate battle-finalization/provider callbacks cannot mint duplicate chronology rows. Existing R/B/Y and Gold/Silver death paths are unchanged.

## 2.5.83 / Gen1Recomp 0.2.14 audit

> **2.5.84 note:** RS-CACHE-DEDUP-001 is fixed: unseeded Random Starter distinct-choice bookkeeping ignores scoped cache/internal marker rows and counts only canonical bare starter-slot mirrors. Seeded/deterministic starter behavior is unchanged. Gen1Recomp 0.2.14 is exact-runtime boot/DEV REPORT PASS.


The published **v0.2.14** tag is three commits ahead of **v0.2.13**. The reviewed tag delta changes only Android release packaging (`mobile/android/love/build.gradle`, disabling release minification) and iOS app-repository metadata (`mobile/ios/app-repo.json`). There are no changes to the Lua Runtime/Loader, published Mod API, GameVersion identity, Gen 2 VM/world callbacks, save contract, or Nuzlocke-facing gameplay seams.

Nuzlocke therefore advances `recompCompatAudited` to **0.2.14**, retains Mod API **2** and engine range `>=0.1.86 <2.0.0`, and makes no adapter/hook changes. No 0.2.14 feature is adopted because the release adds no new mod-facing capability. 2.5.82's successful boot and DEV REPORT render remain protected runtime evidence; exact 0.2.14 boot is still a focused runtime test for 2.5.83.

## 2.5.82 interoperability module note

Compatibility API remains **28**. The existing Public Interop API, provider registry, capability resolution, acquisition/item/storage/encounter policy objects, content registration, automatic compatibility scanning, and compatibility aliases are moved unchanged into package-local `public_interop.lua`. Dynamic game/save state is supplied through getters so module extraction does not freeze lifecycle state. Runtime boot/MOD COMPAT smoke testing is required.

## 2.5.81 modularization compatibility note

No engine hook, provider ownership, supported-game declaration, API version, or dependency contract changes. The rule/settings catalog is loaded package-locally and injected with the existing `Strings` dependency. Random Starter and encounter runtime paths are untouched.

## 2.5.80 Gen1Recomp 0.2.13 compatibility note

The audited Gen1Recomp marker advances to **0.2.13**. Mod API remains **2** and the supported engine range remains `>=0.1.86 <2.0.0`. The 0.2.13 source audit found no required contract break in the Gen 2 VM/world seams used by Nuzlocke (`script.command`, native portrait/cry callbacks, and starter grant callbacks). Stable wrappers are therefore preserved.

Release Safety source/package introspection is diagnostic-only in runtime environments: inability to read a package source file is a warning, not a boot-fatal invariant. The package now includes dedicated architecture modules for Run History, Release Safety, Dev assertions, migration shadow-store logic, and Stadium acquisition provenance.

### Stadium Prize cooperation

Transfer/import mods may call `mod.exports.nuzlocke_acquisition_provenance.mark(mon, origin)` after creating/importing the Pokémon. `origin` may be `stadium_1`, `stadium_2`, or omitted. Nuzlocke records the acquisition source as `stadium_prize` / `STADIUM_PRIZE` and does not synthesize a map location.

## 2.5.78 save/migration compatibility note

2.5.78 does not change Compatibility API 28, Save Schema 4, provider ownership, optional dependencies, or the supported engine range. It changes only how **older supported Nuzlocke schemas are advanced to schema 4**: numbered transitions are now shadow-preflighted and committed through a recoverable Nuzlocke-owned write-ahead journal. Newer-schema downgrade safe-stop remains authoritative and a transaction targeting a schema newer than this build is also treated as unsupported rather than guessed at. A migration/recovery failure uses a separate `migration_error` pause reason but reaches the same protective outcome: Nuzlocke-owned writes and rule enforcement do not continue against uncertain persisted state.

The journal is optional schema-control bookkeeping under the reserved `__nuzlocke_` namespace and is cleared after clean migration completion. Before numbered schema mutation, Nuzlocke creates a separate three-deep raw-save snapshot rotation through Gen1Recomp's engine-owned save path/filesystem; the engine's own `.bak`/`.tmp` recovery files remain untouched. No engine save-format field is added.

## 2.5.77 release-safety compatibility note

No compatibility adapter or engine-range change is made in 2.5.77. The release-safety runner now verifies that every advertised Compatibility API capability has a version entry and that required package-local integration sources remain readable. The stable audited Gen1Recomp marker remains **0.2.12** and the engine range remains `>=0.1.86 <2.0.0`.

## 2.5.76 documentation-hygiene compatibility note

No compatibility adapter changes are made in 2.5.76. The stable audited Gen1Recomp marker remains **0.2.12** and the engine range remains `>=0.1.86 <2.0.0`. Public compatibility documentation was sanitized for durable release/technical provenance only.

## 2.5.75 process-only compatibility note

No compatibility adapter changes are made in 2.5.75. The stable audited Gen1Recomp marker remains **0.2.12** and the engine range remains `>=0.1.86 <2.0.0`. Compatibility reviews now use durable structured records for explicit review scope, cleared/unreviewed surfaces, risk statements, and regression protection.

## 2.5.74 documentation-only compatibility note

No compatibility adapter changes are made in 2.5.74. The stable audited Gen1Recomp marker remains **0.2.12** and the engine range remains `>=0.1.86 <2.0.0`.

Current exact-edition evidence relevant to compatibility testing:

- Blue 2.5.71 Random Starter pre-selection portraits: **RUNTIME PASS**.
- Silver 2.5.73 Random Starter: randomized award **PASS**, Elm pre-selection portrait **FAIL**.
- Gold/Silver Random Starter therefore remains a Gen 2 presentation defect; do not infer parity from the working R/B/Y path.

Future compatibility work is planned around an explicit engine-contract inventory, hook/provider ownership registry, capability/version handshake for cooperating mods, feature-health reporting (`ACTIVE` / `DEGRADED` / `UNAVAILABLE`), and exact-edition parity metadata. None of those contracts are introduced by 2.5.74.

## 2.5.73 / Gen1Recomp 0.2.12 audit

Gen1Recomp 0.2.12 is 15 commits ahead of 0.2.11. The reviewed delta changes Gen 1 BattleState/Game/Overworld/UI behavior, launcher/importer, sync/link behavior and platform lifecycle handling, but does not change the mod Runtime/Loader contract, GameVersion, the Gen 2 VM/Mon constructor, or the published Mod API surface Nuzlocke depends on. Nuzlocke therefore keeps `>=0.1.86 <2.0.0` and advances only its audited marker to 0.2.12.

The new `nuzlocke_run_history` API is an additive observation/export surface. It emits only after Nuzlocke has committed its own chronology row and does not claim ownership of another mod's Tracker, save, battle, or progression state. Companion mods should consume the public event/API instead of writing `run_history_v1` directly.

## 2.5.71 Gold/Silver Random Starter transaction parity

Early Gen 2 NEW GAME may replace the mod-save backing between Elm's preview opcodes and the final `givepoke`. Nuzlocke now treats the VM-private preview choice as transaction state rather than recomputing through save-backed randomizer cache at award time. This keeps compatibility with Gen1Recomp 0.2.11's native `Vm.new`/`hooks.givePoke` ownership and does not mutate generated script rows.

## 2.5.70 Gold/Silver Random Starter candidate parity

Gen1Recomp 0.2.11 constructs Gen 2 party members through `src.battle.gen2.Mon`, not the Gen 1 `src.pokemon.Pokemon` path. Nuzlocke's newer starter safety validator had accidentally imposed Gen 1-only `level1Moves`/`learnset` requirements on Gold/Silver candidates, collapsing the legal pool and triggering vanilla fallback. 2.5.70 validates the native Gen 2 `baseStats`/`levelMoves` contract while preserving provider/challenge filters and the current transaction wrapper. Engine range and compatibility API are unchanged.

## 2.5.69 Gold/Silver Random Starter grant repair

The Gen 2 Random Starter transaction continues to compose around `src.script.gen2.Vm.new` and its supplied `hooks.givePoke` callback. The exact game object identified at the `script.command` Elm `givepoke` seam is now carried into that private one-shot transaction instead of relying on global session rediscovery. Shared generated script rows remain unmodified. Compatibility API remains 28; runtime validation is required on both Gold and Silver.

## 2.5.68 NUZ STATUS presentation cleanup

No compatibility ownership or provider contracts changed. The existing R/B/Y ListMenu and shared Gold/Silver status-screen lifecycle remain intact; only source-owned row selection/labels were cleaned up. Compatibility API remains 28 and Gen1Recomp 0.2.11 remains the stable audited marker.

## 2.5.66 — Silver status / recovery compatibility hardening

Silver remains a declared beta target on Gen1Recomp 0.2.11. The shared Gen 2 NUZ STATUS screen now contains edition/provider-shape failures and records them through Dev diagnostics rather than allowing a launcher-level crash. Manual Encounter Tracker recovery now requires a canonical string area key before tracker-table access and treats live-Pokémon identity enrichment as optional maintenance metadata. Compatibility API remains 28.

## 2.5.65 — Silver beta target

Gen1Recomp 0.2.11 defines Silver as generation 2 using Gold's engine with edition-selected data. Nuzlocke now declares `silver` in the manifest and routes both Gold and Silver through the established Gen 2 adapters. Silver has a separate staged Setup profile; Crystal remains undeclared groundwork. Compatibility API stays 28 and the engine range stays `>=0.1.86 <2.0.0`. Runtime parity is required before individual Silver mechanics are marked PASS.

## 2.5.63 — nil-safe compatibility metadata

Compatibility/provider discovery now treats absent capability metadata as neutral `compose` ownership. This is defensive compatibility hardening only; Compatibility API remains 28 and Gen1Recomp 0.2.11 remains the stable audited marker.

## 2.5.62 — Gen1Recomp 0.2.11 audit

Published Gen1Recomp **0.2.11** is source-audited as the current stable marker. The 0.2.10→0.2.11 delta adds Silver/GameVersion work and changes Game/Game2, SaveData/Gen2 Save, Gen2 World, manifest targeting, launch/build code and Gen2 documentation. Mod API remains **2** and the Nuzlocke engine range remains `>=0.1.86 <2.0.0`. Nuzlocke now declares Red/Blue/Yellow/Gold/Silver; Silver is explicitly beta/test-required while parity evidence is accumulated. Crystal remains undeclared.

## 2.5.61 — Gen1Recomp 0.2.10 audit

Published Gen1Recomp **0.2.10** is source-audited as the current stable marker. Its cumulative delta from 0.2.7 includes changes to Mod Runtime/Loader, Gen 1 battle state/status, Game/Game2, SaveData/Gold Save, TextBox, Gold battle/UI/world code, and substantial launcher/sync infrastructure. The public contract remains Mod API 2 and the shared hook/event vocabulary remains intact, so Nuzlocke does not need an adapter or manifest-range change for this release. Existing composition/ownership rules remain authoritative. Runtime smoke testing is still required before promoting specific gameplay paths to PASS.

## 2.5.59 catalog-dialogue compatibility hardening

2.5.59 does not change provider ownership or external hook contracts. It prevents catalog-backed Nuzlocke dialogue from carrying unreachable fallback arguments that can mislead future compatibility or ROM-hack-specific text work into believing custom fallback content will render when the catalog key already wins.

## 2.5.58 cross-table compatibility hardening

2.5.58 does not change provider ownership or external hook contracts. It validates internal progression tables that compatibility and level-cap consumers depend on, so accidental table drift fails visibly instead of silently changing behavior.

## 2.5.57 active-guard compatibility hardening

2.5.57 does not change provider ownership or external hook contracts. The new regression gate distinguishes rule-enforcement mutations, which require `active()`, from intentional passive progression synchronization and Forgiveness Token save/inventory reconciliation, which remain available while the master rule is OFF. This preserves the established write/tracking/enforcement policy while making accidental guard loss self-detecting.

## 2.5.56 internal rule coercion hardening

2.5.56 does not change provider ownership or external hook contracts. Ordinary duplicated numeric dispatch in config reads/writes is replaced by metadata-driven coercion, while external provider delegation, legacy Level Cap migration, dynamic difficulty-provider selection, and other compatibility exceptions remain explicit.

## 2.5.55 internal rule-registration hardening

2.5.55 does not change provider ownership, hook contracts, save schema, engine support, or external compatibility behavior. It consolidates ordinary rule defaults/types onto the existing registration rows so later compatibility/UI/config work cannot silently drift across duplicated metadata tables.

## 2.5.54 internal compiler-budget refactor

No compatibility-provider ownership, hook contract, manifest range, dependency, save schema, or gameplay integration changed. The refactor is internal lifetime/namespace cleanup only. Existing runtime confidence and all protected compatibility paths carry forward because their implementation seams were not behaviorally changed.

## 2.5.53 Dev Report compatibility

NZR5 remains backward-compatible at the decoder boundary: old NZR4 codes can still be decoded and checked for contradictions. No gameplay compatibility surface changes in this build.

## 2.5.51 Gold Random Starter composition

Gold Random Starter no longer depends solely on an empty-party/canonical-species heuristic at the native grant callback. The exact Elm `givepoke` row arms private VM-local intent first, then the existing `givePoke` wrapper composes around the current engine hook and consumes that intent. Shared script rows are not mutated, and provider delegation remains authoritative.

## 2.5.50 F. TOKEN tracker integration

The area picker and ENC TRACKER reroll action consume the existing projected encounter-state/ledger model and call one shared reroll function. They do not create a second encounter ledger or depend on the player's current map. Presentation mods can identify `NuzlockeForgivenessArea` through the Nuzlocke UI ownership contract. The independent Encounter Indicator battle HUD remains unchanged.

## 2.5.49 F. TOKEN cursor compatibility

The R/B/Y forgiveness pages now use the same native cursor glyph path as other working Nuzlocke classic UI pages. Gold remains on `Chrome.cursor`. No dependency, engine-range, or save-schema changes.

## 2.5.48 F. TOKEN / Gym Guide compatibility

R/B/Y F. TOKEN rendering now uses the same full-page native tile surface as established Nuzlocke screens instead of a bespoke offset box. The Bag handoff from 2.5.47 remains. Gym Guide candy messages remain on the engine `Commands.show_text` blocking path and add explicit pages only; provider ownership and Bag transaction behavior are unchanged.

## 2.5.47 F. TOKEN screen ownership
R/B/Y F. TOKEN use now follows the engine's full-screen field-item transition pattern: the Bag/use list is closed before the Nuzlocke selector is pushed. This prevents native item-target UI and UI-provider composition from remaining underneath the forgiveness screen. Gold's PackMenu/Chrome path is unchanged.

## 2.5.46 Gold START-menu lifecycle

Gold builds its START-menu item list once per opening. When Dev Mode changes while NUZ RULES overlays that menu, Nuzlocke now refreshes only its own marked DEV row in-place. Native rows and rows supplied by other mods are not reconstructed or removed.

## 2.5.45 F. TOKEN UI composition
R/B/Y F. TOKEN screens explicitly opt out of wide/modern logical-surface resizing by using the same native 160x144 classic-layout contract as other stabilized Nuzlocke screens. UI integrations should treat these screens as Nuzlocke-owned opaque surfaces. Gold remains on the native Gen 2 Chrome renderer.

## 2.5.44 Dev diagnostic composition

NZR4 remains format-compatible. The encoder now canonicalizes redundant PASS/WARN bits from its structured diagnostic counters/statuses, and the decoder exposes consistency flags. No gameplay/provider ownership changes are introduced.

Build provenance is corrected to the actual immediate 2.5.43 parent package, restoring the strict-child metadata chain used by Dev diagnostics.

## 2.5.43 Gold battle-queue composition repair

The Nuzlocke Gold refusal pager is now a true overlay around the previously installed `BattleState.update`: it does not clear, consume, or advance native/other-mod queue rows. It restores the exact pre-dialogue phase/message/timer state after the final A/B page, then subsequent updates continue through the captured wrapper chain normally.

## 2.5.42 text-flow compatibility

Gold Nuzlocke battle-rule refusal paging is internally composed around `BattleState.update` with an ownership/session guard. It intercepts only while Nuzlocke-owned refusal pages are active, then delegates to the previously installed update method, preserving other mods' update wrappers in the chain.

## 2.5.41 — recent-feature composition hardening

Trade Evolutions now follows the supported Gen1Recomp `evolution.check(game, mon, evo, trigger)` contract and only supplies the level-40 alternative when `trigger.kind == "levelup"`. Link, item, forced, preview, and future unrelated contexts remain owned by the engine/providers. Gold held-item branch suppression uses the same level-up-only gate.

F. TOKEN revival remains compatible with systems that retain dead Pokemon physically. If such a record is still in the party but current Party Size Limit is lower than the active count, revival relocates it to PC storage before reactivation rather than bypassing the cap. A failed relocation consumes no token.

## 2.5.40 — Forgiveness Token composition

F. TOKEN is no longer synthetic shop stock. R/B/Y's `item.use` hook owns only this custom item and delegates every other item unchanged; Gold intercepts the same custom id at its Pack `useSelected` seam. Shop compatibility is subtractive only: Nuzlocke filters its own token from BUY/SELL presentation and does not modify prices, wallet limits, or unrelated stock.

Permadeath revival stores a plain-data snapshot before the dead Pokemon is pruned, preserving generation/provider fields without requiring another mod to keep the dead object alive. Revival prefers a physically retained matching object when one exists and otherwise restores the archive to legal party/PC storage. Runtime cross-mod validation remains required.

## 2.5.39+DEV — shared evolution-hook composition

Trade Evolutions uses Gen1Recomp's existing shared `evolution.check` hook rather than replacing species data or the engine's link system. Gen 1 rows use `TRADE`/`species`; Gold uses `EVOLVE_TRADE`/`into`. The 2.5.39 code retained defensive Game/data-shape adapters, while 2.5.41 follows the documented `evolution.check(game, mon, evo, trigger)` contract and requires a true level-up trigger. External evolution-method registries and native link-trade ownership remain intact.

The QOL force decision runs before Nuzlocke's Evolution Limits filter, so `NO FINAL` and `NO EVOLUTION` remain authoritative challenge restrictions. Gold held-item trade branches retain their item identity; the item is consumed after a successful level-triggered evolution. No engine minimum or Compatibility API bump.

## 2.5.38+DEV — Gen1Recomp DEV-release update identity

Gen1Recomp's current GitHub mod updater parses a semver-like release tag but stores only its leading `x.y.z` triple for update comparison. A manifest version such as `2.5.38+DEV` is a SemVer prerelease and therefore sorts below candidate `2.5.38`, causing a published DEV build to advertise its own release. Beginning with 2.5.38, Nuzlocke uses `+DEV` as part of the canonical manifest/build identity; build metadata is ignored for SemVer precedence, making the installed version equal to candidate `2.5.38` while later numeric releases remain newer. The `github` repository hint stays enabled, so update discovery itself is not disabled.

No compatibility API or engine-range change.

## 2.5.37-DEV Gold storage / item identity repair

Current Gen1Recomp Gold storage deliberately materializes individual PC boxes on demand, so `save.boxes` may be sparse. Nuzlocke now treats that engine shape as authoritative and uses sparse-safe traversal for every cross-box ownership/recovery scan. This repairs Whiteout reserve discovery, PC-only catch storage discovery, legacy/provenance recovery, and Gold gift/starter ownership detection without changing upstream storage code.

Gen1Recomp item ids identify HMs as `HM_<MOVE>` (with machine metadata), not only numeric display labels such as HM07. Random Field Items now protects that canonical identity, including Gold's visible Ice Path WATERFALL HM. No engine minimum, compatibility provider contract, or registry ownership changes.

## 2.5.36-DEV current Gen1Recomp dev audit

Current Gen1Recomp `dev` head **`def270f7c726ebd7bd87086ad90bc4a7b9622543`** was source-audited against Nuzlocke 2.5.35. No required gameplay/enforcement adapter change was found. The stable published audit marker remains **0.2.7** rather than pinning `recompCompatAudited` to a moving development SHA. Supported engine range remains **`>=0.1.86 <2.0.0`**, Mod API remains **2**, and engine save format remains **4**.

Gold's official read-only BattleAPI now reports Ball inventory and exact stock `catchChance` values. Nuzlocke's existing optional `currentBattleSnapshot(game)` bridge already reads the generation-specific BattleAPI dynamically, so this is an additive diagnostics/presentation improvement rather than a capture-policy ownership change. If `catch.rate` is replaced by another provider, upstream intentionally omits the preview instead of guessing.

Gold battle-party navigation now offers `ui.party.grid_navigation`; Nuzlocke does not own or replace that presentation/input hook. Android's launcher can now unload a game and boot another in the same process after `Runtime.reset()`. Nuzlocke's owner-aware wrapper revalidation is source-consistent with that lifecycle, but a **Red/Yellow -> launcher -> Gold -> launcher -> Red/Yellow** runtime smoke test remains required for setup, Random Starter, movement assists, Unlimited Bag Space, and stale-wrapper absence.

## 2.5.35-DEV recent-feature compatibility

Gold Elm starter scripts are no longer mutated by Nuzlocke's `script.command` wrapper, preventing cross-New-Game process contamination and composing more safely with other wrappers that inspect the same generated row. No compatibility/provider API versions changed. Unlimited Bag Space remains QoL and Rule-Lock-exempt; its bag-capacity composition from 2.5.34 is unchanged.

## 2.5.34-DEV Unlimited Bag Space compatibility

Unlimited Bag Space composes at the engine's `Bag.capacity` boundary rather than replacing `Bag.add`. That keeps item-stack quantity, item ordering, pockets, acquisition scripts, and legality enforcement under the engine/other providers. When the toggle is OFF, Nuzlocke returns the exact downstream capacity; a compatible mod that changes the live Bag size therefore remains authoritative.

When ON, R/B/Y's ordinary Bag and Gold's ITEM/BALL pockets receive an effectively unbounded distinct-slot capacity. Gold KEY ITEM/TM-HM pockets are deliberately left downstream/native, and PC item storage is not part of this adapter. If another provider wraps `Bag.capacity` after Nuzlocke, lifecycle revalidation composes around the current live function rather than assuming an owner marker alone proves the old closure is still active. Compatibility API remains **28**.

## 2.5.33-DEV movement QoL compatibility

Running Shoes and Fast Surf compose through Gen1Recomp's shared `movement.speed` seam in both generations. Nuzlocke applies its multiplier after downstream providers and scopes it by the engine context: on-foot/non-bike for Running Shoes, `surfing=true` for Fast Surf. Gold's normal `movement.speed` call site explicitly supplies the same `onBike`, `surfing`, `input`, and save context as R/B/Y, with its additional player-state/downhill data.

QoL Toggles' source-confirmed `run_hold_b` option is no longer treated as full external ownership of Running Shoes because it cannot represent Nuzlocke's new ALWAYS mode. It is instead detected as a HOLD-B overlap: if B is already being accelerated downstream, Nuzlocke does not halve that same step again. ALWAYS still accelerates non-B walking steps. Fast Surf has no implicit external owner and simply composes with other movement-speed providers. Compatibility API remains 28.

## 2.5.32-DEV Gold Random Starter compatibility

The Gold starter slate has its own deterministic namespace/version and therefore does not require a global Randomizer algorithm bump that would reshuffle encounter or learnset results. If a constrained/modded species pool cannot provide three unique legal candidates, the slate fails soft by reusing the legal pool rather than breaking Elm's starter transaction. Preview wrappers no longer mutate shared Gen2 script data, improving compatibility with other `script.command` consumers.

## 2.5.31-DEV Whiteout / PC recovery compatibility

Compatibility API remains **28**. Whiteout recovery counts only ordinary usable party/Box Pokemon and explicitly excludes `nuzlockeDead`, `nuzlockePcLocked`, and Egg entries, so the new recovery path cannot legalize PC-Only Catches or revive recorded deaths. R/B/Y and Gold continue to delegate their native blackout heal/warp lifecycle on the survivable branch; Nuzlocke owns only the destructive Blackout consequence.

Gold's native PC requires a non-empty party. 2.5.31 composes `src.ui.gen2.PcMenu.new` and clears that construction-time refusal only when Nuzlocke is active, Whiteout is ON, the party is empty, and an eligible boxed reserve exists. All normal PC limits, Party Size policy, mail rules, and permanent PC-lock withdrawal/release gates remain in force.

## 2.5.30-DEV Gold Random Starter compatibility
Gold Random Starter now has a native Gen 2 `givepoke` transaction safety net in addition to the existing shared `script.command` adapter. The direct wrapper is owner-aware and composes around the live `src.script.gen2.Vm.new`; it shallow-copies the World's VM hook table and replaces only `givePoke`, so other VM callbacks and later/earlier compatible wrappers are preserved.

External starter-randomizer ownership still wins before any Nuzlocke selection or staged-profile synchronization. The transaction repair is limited to a zero-member party plus the three canonical Elm starter operands, so ordinary scripted gifts continue through the existing Gold gift policy unchanged. Compatibility API remains **28**.

## 2.5.29-DEV Gold resource/config compatibility
Compatibility API remains **28**. Gold Ball Per Encounter uses the existing Gold battle-Pack capture adapter; only the missing Nuzlocke configuration-row exposure changes. Gold starting resources are fresh-save setup behavior: money writes Gold's native `player.money`, Rare Candy writes native `pcItems`, and extra Starting Poke Balls wait for the live Gold Mystery-Egg-return event before entering PC storage. The engine's native 5-Ball story reward remains untouched, reducing conflict with story/progression or capture-provider mods. Runtime combination testing is still required for mods that replace Gold's opening story or PC item-storage transaction.

## 2.5.28-DEV PC-only catch compatibility
Compatibility API remains **28**. Nuzlocke uses the host's settled `pokemon.caught` event for both generations, so the engine first owns the real capture/Pokedex/storage transaction and Nuzlocke only moves/marks a successful research-only catch afterward. R/B/Y PC enforcement composes around the semantic `pc_box_withdraw` / `pc_box_release` ListMenu kinds; Gold composes around native `doWithdraw`, MOVE destination validation, and `askRelease`. The public Party/PC policy mirrors the same restriction for alternate PC providers.

A compatible progression capture can opt into the narrow No Catching exception only by declaring both progression-required and progression-exception permission. Ordinary wild catches do not inherit that exemption. Storage preflight fails closed for the exception; Gold also mirrors the native full-party/current-Box check before a Ball can be used. Provider/alternate-PC combination runtime testing remains required, especially for providers that mutate storage without consulting the public acquisition/PartyPC policies.

## 2.5.27-DEV Maximum BST compatibility
Compatibility API remains **28**. This build only expands Nuzlocke's UI preset choices; provider-supplied species metadata/BST composition and the numeric Maximum BST contract are unchanged. Existing free-form saved thresholds remain valid and are not rewritten.

## 2.5.26-DEV STAT INFO compatibility
R/B/Y STAT INFO consumes more of its own unused horizontal space only. No hook ownership, provider composition, Modern UI contract, Gold screen, or gameplay integration changes.

## 2.5.25-DEV Random Field Items compatibility
Compatibility API remains **28**. Nuzlocke composes around the live R/B/Y visible-item `talkTo` method and Gold `HiddenItems.ballPickupScript` method with owner-aware wrapper sessions. The option does not claim external randomizer ownership and does not touch hidden-item, gift, shop, fruit/apricorn, or scripted-reward paths. Protected key/HM pickups fail open to the authored item. Runtime combination testing with mods that replace visible item-ball handling remains required.

## 2.5.24-DEV UI navigation compatibility
Compatibility API remains **28**. Remembered Rules/Setup position is local to Nuzlocke's own configuration surfaces and is separated across R/B/Y vs Gold and Setup vs active Rules. It does not claim external menu ownership, change provider delegation, or persist compatibility state.

## 2.5.23-DEV fresh-session/runtime compatibility
Compatibility API remains **28**. Critical R/B/Y direct/script wrappers now revalidate on fresh `save.created`, and staged late-runtime phase 2 is actually executed rather than discarded. Random Starter uses an explicit internal cross-phase helper export, avoiding Lua's silent global fallback when a local is out of lexical scope. Provider ownership/public capability semantics are unchanged.

## 2.5.22-DEV reload/randomizer compatibility
Compatibility API remains **28**. Gen 1 kerning now refuses to guess through an ambiguous legacy/foreign wrapper chain during hot reload; exact Nuzlocke top-level wrappers can be replaced safely, while an ambiguous chain requires one fresh process. Starter deterministic RNG now shares the same algorithm-version source as encounter/learnset streams, preventing a future version bump from splitting those contracts. No provider ownership or public capability semantics change.

## 2.5.21-DEV trainer identity compatibility
Compatibility API remains **28**. Reward recognition and League progression now share one trainer identity normalization path covering ID, class, and name evidence, including R/B/Y `oppClass`, generic provider class aliases, and Gold `trainer.classId` / `trainer.class`. This reduces disagreement when another mod or provider changes trainer payload shape without changing provider ownership semantics.
# Compatibility — 2.5.30-DEV


## 2.5.20-DEV compatibility safety
Compatibility API remains **28**. No provider ownership or capability contract changes. Runtime enforcement now has an explicit write-safety boundary: passive boss progression may synchronize while Nuzlocke is OFF on a supported save, while rule-specific compatibility/reward paths remain disabled when the challenge is OFF or a newer unsupported schema is safe-stopped.

Compatibility API remains **28**. The change is internal policy hardening rather than a new compatibility surface.

## 2.5.19-DEV compatibility safety
Compatibility API remains **28**. Engine compatibility reports no longer expose internal mutable tables, the boot-time `engine_compat` snapshot is refreshed after Item Policy state changes, and Pokémon identity helpers cannot mutate unsupported newer-schema saves.
# Compatibility — 2.5.19-DEV

Compatibility API remains **28**. Public compatibility metadata is defensively snapshotted so consumer mutation cannot alter Nuzlocke's internal resolver state.


## 2.5.18 compatibility hardening
Compatibility API remains **28**. Public capabilities, engine/mod metadata, relationship defaults, and ownership are defensive snapshots; dynamic mod-compat snapshots refresh after provider discovery. Consumer mutation cannot change Nuzlocke's internal relationship resolver.
# Nuzlocke 2.5.17-DEV compatibility

## 2.5.17-DEV compatibility summary

Compatibility API is **28**. 2.5.17 adds per-capability contract-version metadata (`capability_versions`) and `getCapabilityVersion(capability)` so companion mods can negotiate one compatibility surface at a time. Every currently advertised capability starts at contract version **1**. Existing API-27 capability names, ownership relationships, return shapes, and provider precedence remain compatible; `compatible_from` remains 10.

Build provenance and Rule/Save descriptors are read-only development/diagnostic surfaces. They do not change gameplay registry ownership, Save Schema 4, or the engine range.

## 2.5.16-DEV compatibility summary

Compatibility API remains **27**. The public boolean rule query now honors canonical missing-key defaults, so compatible consumers see the same default-ON state as Nuzlocke enforcement. QoL Toggles AUTO-REPEL now records and verifies the exact live wrapper function, and the Wilds of Kanto adapter requires both its pre-capture resolver and post-catch placement wrapper to be live before declaring the session installed. Dev hook-health can report these optional adapters when the providers are loaded.

No compatibility provider ownership or API number changes.

## 2.5.15-DEV compatibility summary

The engine range remains **>=0.1.86 <2.0.0** and Compatibility API remains **27**. Gold No Escape now consumes the existing cross-generation `battle.run` payload correctly even though Gen 2's pure `Battle` object lacks `battle.game`; the live game is resolved through the current-game facade when necessary. No hook name, payload, or provider precedence changes.

Owner-aware lifecycle records now cover the remaining high-value direct wrappers for Party Size/PC withdrawal, Gold No Day Care, Gold Whiteout finish, Gold Headbutt tracking, and forgiveness-token mart stock. A stale wrapper is unwrapped only when it is still exactly Nuzlocke's live top-level function; otherwise the current live function is composed rather than overwritten. Field-poison Whiteout uses generation-specific final-warp seams and does not synthesize battle events.

## 2.5.14-DEV compatibility summary

The engine range remains **>=0.1.86 <2.0.0** and Compatibility API remains **27**. 2.5.14 hardens direct wrapper ownership across repeated ModLoader sessions for R/B/Y catch/finalization/nickname UI, the R/B/Y Permadeath/Whiteout bundle, and Gold capture `useItem`. The repair unwraps only a stale wrapper that is still exactly Nuzlocke's recorded top-level function; it does not replace a different live function merely because a marker exists.

The Gen1Recomp 0.2.7 TimeFishGroups representation was rechecked. Fishing rows can contain direct `day`/`nite` slots while retaining `timeFishGroups` as fallback; the engine resolves direct row slots first. Nuzlocke therefore does not forcibly mirror those structures after randomization, preserving compatible row-level registry overrides.

## 2.5.13-DEV compatibility summary

The engine range remains **>=0.1.86 <2.0.0**. Compatibility API remains **27**. 2.5.13-DEV does not raise the engine minimum or maximum and does not change provider ownership semantics. It adds narrow owner-aware wrappers only because Gen1Recomp's field-poison faint paths do not emit the battle faint seam Nuzlocke normally consumes.

The final stabilization pass fixes legacy automatic capability detection for compact multi-word IDs and synchronizes exported build metadata. Name-based legacy adapters remain a fallback only; explicit provider registration is preferred.

Recent compatibility-sensitive fixes also preserve live wrapper identity rather than trusting stale owner markers, notably for the R/B/Y Mom-heal command path.

2.5.6 also hardens the in-game NUZ RULES post-write mirror so an unavailable Type Locke table reference cannot crash unrelated rule edits. This is internal UI/state synchronization only; compatibility ownership and effective-rule delegation are unchanged. Runtime re-test is required.

2.5.7 changes only Dev diagnostic presentation: long report/storage identifiers are hard-wrapped to the native viewport and NZR4 is displayed in grouped lines. Report Code encoding/decoding, provider contracts, ownership, and storage semantics are unchanged.




### 2.5.13 field-poison lifecycle note
R/B/Y field poison is owned by `OverworldState:applyFieldPoison`; Gold step poison is converted to a `poisonFaint` event and presented by `World:poisonFaintScript`. Neither is a battle faint. Nuzlocke therefore observes those native functions rather than synthesizing `battle.fainted` or replacing engine whiteout behavior. The wrappers are session-owner aware and preserve whatever live predecessor they wrap. No compatibility-provider precedence, encounter registry, item policy, battle hook, or public API contract changes.

### 2.5.12 Gen1Recomp 0.2.7 encounter-registry note
The published 0.2.7 Gold engine loads the shared `encounters` registry into `game.data.gen2Encounters` and extends fishing rows with optional `timeGroup`, `day`, and `nite` data plus a top-level `timeFishGroups` table. Nuzlocke gameplay randomization already resolves that live Gold registry and recursively preserves the nested structure.

The public Nuzlocke registry facade did not: `effectiveEncounters()` and `Registry.describe()` still exposed only `game.data.encounters`, which can be nil on Gold. 2.5.12 resolves the public facade through `gen2Encounters` first with the Gen 1 table as fallback. This keeps compatible DexNav/guide/provider consumers on the same final merged registry gameplay uses. No randomizer reroll, provider-ownership change, save migration, or Compatibility API bump is introduced. Gold/0.2.7 runtime confirmation remains required.


### 2.5.11 World Building compatibility note
The T1-default completion changes only Nuzlocke's missing-value presentation fallback and rule copy. Explicit saved values, provider ownership, compatibility detection, and public API contracts are unchanged.


### 2.5.10 presentation compatibility note
The Gold Pokégear card fix changes only Nuzlocke-owned card paging state and hints; it does not change the `pokegear_cards` registration contract. The ENC TRACKER empty-state row is presentation-only: Modern UI still receives the same real encounter data and a separate zero entry count, while the placeholder is excluded from selected detail/provider semantics. Compatibility API remains 27.

### 2.5.9 Gold First Rival Mercy source audit
Gen1Recomp 0.2.7 explicitly tests the Cherrygrove first-rival loss as `BATTLETYPE_CANLOSE`. Its native loss path does **not** whiteout, halve money, warp, or immediately heal; the battle returns `lose` to the continuing map script, and that script later calls `HealParty`. Nuzlocke's Gold mercy path therefore intentionally skips death/Whiteout bookkeeping while leaving the mon at 0 HP for the native script to heal. No compatibility adapter or battle-finish override was added for this review.

2.5.9 also fixes a Nuzlocke-only Gold status presentation reference that could resolve the Type Locke slot-key table as a nil global. Provider ownership and public compatibility contracts are unchanged.

## Future-schema downgrade safety
2.4.63 treats a Nuzlocke save schema newer than 4 as unsupported by this build. Migration stops, ordinary Nuzlocke enforcement pauses, and known lifecycle repair writers are suppressed. The player receives a session-only warning rather than having the older build silently reinterpret newer-format state.

## Dev hook-health diagnostics
2.4.64 can report whether selected observable adapters are top-level, composed beneath another live wrapper, missing, or pending. A **CHAINED** result is not automatically a conflict: another compatible mod may wrap above Nuzlocke while preserving the predecessor chain.

## Dev lifecycle diagnostics
2.4.65 adds passive event-delivery counters without changing listener installation. Repeated delivery of the same event payload is surfaced as duplicate-callback evidence, which is useful when validating engine/mod hot-reload behavior.

## Future-schema write-attempt diagnostics
2.4.66 introduced observation of Nuzlocke's scoped save writer for downgrade testing. **2.4.70 hardens that seam into a final barrier:** if an unguarded `mod.save:set(...)` reaches the writer while a newer-schema safe-stop is active, the attempt is recorded and refused. Explicit subsystem guards remain the primary protection; the central barrier prevents an omitted guard from corrupting the unsupported save.

## Dev rule-effectiveness diagnostics
2.4.67 exposes configured/effective rule values alongside current ownership. Delegated rows identify the external owner and relationship/capability context, making it easier to distinguish a rule that is intentionally neutralized by compatibility from one that is unexpectedly inactive.

## Dev Randomizer integrity
2.4.68 distinguishes Nuzlocke-owned Random Encounter output from externally delegated randomizers. Delegated ownership is surfaced with provider context and is not scanned against Nuzlocke's internal candidate contract. Content-provider slots that explicitly opt out through `shouldRandomizeEncounter` are likewise excluded.

## Gen1 Better Menus 1.0.3 — 2.4.79 source/static audit

Gen1 Better Menus is a Gen1 presentation overhaul that widens shared engine UI classes including OptionRows/OptionsMenu/ManagerState/Menu, TextBox/ChoiceBox, PartyMenu, TitleState, and battle UI. Nuzlocke deliberately does not replace global `src.ui.Menu.draw`; its rule/setup/tracker screens are custom content screens. The only directly shared title seam is Nuzlocke's stable `TitleState.openMenu` fallback wrapper, which calls the predecessor chain before inserting/rewiring SETUP, so Better Menus' wrapper can remain in that chain.

`gen1-better-menus` is now an optional dependency to make cooperative load ordering explicit without requiring installation. No private Better Menus function is patched and no presentation ownership is seized. Better Menus' live TextBox widening is expected to apply naturally to Nuzlocke-created TextBoxes. **R/B/Y combination runtime TEST REQUIRED**, especially title SETUP/CONTINUE, NUZ RULES, ENC TRACKER, Nuz Info, mod settings, dialogue prompts, battle overlays, and A/LEFT/RIGHT rule controls.

## 2.4.69 published-release compatibility status
The published 2.4.69 release preserves the 2.4.68 compatibility surface unchanged: Save Schema 4, Compatibility API 27, Mod API 2, and manifest range `>=0.1.86 <2.0.0`. No provider contract is intentionally changed in the RC promotion.

## 2.4.70 downgrade-safety hardening
Direct Random Learnset application, Quick Start/default-name shortcuts, Deferred Starting Balls release, and Skip Catch Tutorial now honor the future-schema pause in addition to the existing shared enforcement/lifecycle guards. Supported schema-4 behavior and provider ownership contracts are unchanged.

## Gen1Recomp 0.2.0 compatibility audit
2.4.71 is explicitly audited against the released Gen1Recomp **0.2.0** line. The previous `0.2.1` audit marker was inaccurate and has been corrected.

The verified manifest range is now **`>=0.1.86 <2.0.0`**. This includes the audited 0.2.0 release and preserves the project-mandated `<2.0.0` maximum. That maximum must not change unless explicitly requested by the project owner.

Reviewed surfaces include:
- Mod API 2 manifest validation and `engine_internals` permission;
- playthrough-scoped `mod.storage` context/read/write/list/delete APIs;
- Nuzlocke's current events and middleware hooks;
- R/B/Y and Gold battle/catch modules;
- title/start-menu integration;
- loader/reload/lifecycle assumptions.

Upstream 0.2.0 adds additional APIs and tooling, but this pass does not replace protected working Nuzlocke seams without a concrete compatibility benefit.

## Protected engine-range policy
The manifest maximum is **`<2.0.0`**. Future compatibility audits may update the audited engine version, but they must not narrow or widen this maximum unless the project owner explicitly requests it.

## Quick Start runtime confidence
R/B/Y Quick Nuzlocke Start has user runtime PASS evidence on the current implementation. The outside-house handoff does not remove access to the bedroom PC and is documented as a recoverable UX caveat. No compatibility seam was changed in 2.4.73.

## Indigo Plateau Conference 1.1.0 review

IPC 1.1.0 is Gold-only and uses a positively scoped `trainer.party` substitution for its own armed Colosseum opponent. Its tournament loss is intentionally `CANLOSE`; on loss IPC heals living party survivors and resets/eliminates tournament state rather than invoking a vanilla blackout.

Nuzlocke composes with this through its existing late priority `-1000` `battle.ended` invariant. Ordinary external listeners, including IPC's survivor-heal pass, run first; Nuzlocke then removes only Pokemon already marked `nuzlockeDead`. This preserves IPC's intended survivor healing while preventing a Nuzlocke Permadeath loss from becoming usable again.

No IPC-specific event listener or ownership seizure is required.

## Kanto Reforged 1.2.0 review

Kanto Reforged appends Gen 3 guests to selected composed trainer parties, exposes expanded species through the live content registries, and stores held items on normal Pokemon item fields. Those mechanics remain generic composition surfaces.

KR also has an optional persistent soft-cap system. Once its own `level_caps_on` flag is active, KR wraps EXP and Rare Candy progression using its own milestone calculation. Nuzlocke now treats that as a co-owned cap only while Nuzlocke Level Cap Scope is also active. The effective Nuzlocke cap is the lower of the Nuzlocke/provider cap and KR's live `LevelCaps.capFor(...)` result.

The adapter is read-only toward KR and does not disable either system.

## Current engine contract
- Source-audited Gen1Recomp marker: **0.2.7**
- Sequential 0.2.2-0.2.7 deltas reviewed; no required Nuzlocke enforcement rewrite identified. 2.5.12 repairs the Gold public final-encounter-registry alias exposed to cooperative consumers.
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
| Gen1Recomp upstream | 0.2.7 + dev `def270f7` | 2026-08-19 / 2.5.36 | SOURCE/STATIC + historical runtime | 0.2.7 published baseline plus current dev audit; official `mod.storage`; Gold BattleAPI Ball/catch previews; shared Gold party-grid hook; Android in-process game switching; explicit Gold fallbacks retained where parity is incomplete | Current published baseline source-audited; dev hot-swap matrix TEST REQUIRED; individual features retain their own runtime status | New release/dev contract change in hooks, registries, storage, Runtime reset, BattleAPI, or game-switch lifecycle |
| Kanto Ascendant | 6.5.4 | 2026-08-17 / 2.4.12 | SOURCE/STATIC | External difficulty/trainer-level/wild-level/Trainer Card presentation ownership classification | Combination TEST REQUIRED | Ascendant difficulty/provider contract changes |
| Wilds of Kanto | 2.1.7 | 2026-08-17 / 2.4.11 | SOURCE/STATIC | Audited overworld-catch policy + tracker bridge | Runtime combination TEST REQUIRED | Wilds catch/storage exports or overworld acquisition flow changes |
| Modern Party UI | 0.3.8 | 2026-08-17 / 2.4.11 | SOURCE/STATIC | Presentation provider; avoid controller double-wrapping | Runtime combination TEST REQUIRED | Party controller/ownership changes |
| Gen1 Modern UI | current audited project surface | 2026-08-17 | SOURCE/STATIC + historical runtime report | Dedicated presentation integration | Historical Encounter Tracker crash report remains unresolved without new PASS | Modern UI tracker/menu implementation changes or crash is retested |
| Stronger Trainers | audited beta.29-era build | 2026-08-14–15 | SOURCE/STATIC + RUNTIME PASS | Compose after final `trainer.party`; observe final party for cap preview | Yellow modified-cap runtime PASS; broader matrix not fully certified | Trainer-party hook ownership changes |
| Indigo Plateau Conference | 1.1.0 | 2026-08-17 / 2.4.74 | FULL SOURCE/HOOK RE-AUDIT | IPC owns tournament staging/CANLOSE/elimination/living-survivor healing; Nuzlocke retains Permadeath/death-marker/rule ownership | Gold runtime combination TEST REQUIRED | Tournament lifecycle, trainer-party scoping, CANLOSE, or post-battle healing ownership changes |
| Kanto Life | historical project version; current upstream unresolved | 2026-08-17 / 2.4.31 resolution attempt | ARCHITECTURE/LEARNING / UPSTREAM UNRESOLVED | Preserve NPC coexistence/capability lessons; no named adapter inferred from stale evidence | Current source cannot be certified until canonical upstream is resolved | Canonical repository/version is identified |
| NPC Bubbles | historical project version; current upstream unresolved | 2026-08-17 / 2.4.31 resolution attempt | ARCHITECTURE/LEARNING / UPSTREAM UNRESOLVED | Preserve NPC presentation-coexistence lesson only; no current adapter claim | Current source cannot be certified until canonical upstream is resolved | Canonical repository/version is identified |
| Ironmon Ultimate | earlier researched version | by 2026-08-14 | ARCHITECTURE/LEARNING | Difficulty/Ironmon design and provider lessons | Not a runtime certification | Revisited for active interoperability |
| Enemy HP | earlier researched version | by 2026-08-14 | ARCHITECTURE/LEARNING | Battle presentation/hook coexistence lessons | Not a runtime certification | Revisited for active interoperability |
| Shiny Pokémon | 1.0.8 | 2026-08-17 / 2.4.31 | SOURCE/STATIC (R/B/Y) | Nuzlocke observes semantic shiny state/native DVs; no presentation ownership conflict; no named adapter | HIGH expected R/B/Y compatibility; Randomizer + shiny wrapper and Limited Shiny finite modes require runtime tests; Gold not certified | `Pokemon.new`/`BattleState.newWild` ownership changes, explicit Gen2 support, or shiny-state contract changes |
| Too Many Balls (formerly Kanto Balls) | 0.6.1 | 2026-08-17 / 2.4.31 | SOURCE/STATIC | Generic merged Ball/item detection; generation-specific custom-ball mechanics remain external-mod-owned; no named adapter | HIGH expected compatibility; Ball restrictions + custom-ball catches on Gen1/Gen2 remain runtime TEST REQUIRED | Ball registry/item metadata, Gold `catch.rate`, pocket/mart, or custom acquisition contract changes |
| QoL Toggles | 1.24.1 | 2026-08-17 / 2.4.31 | FULL SOURCE/HOOK AUDIT + LOCAL ADAPTER | Restriction > convenience precedence; option-aware running ownership; AUTO-REPEL direct-consumption guard | MEDIUM-HIGH expected -> HIGH target; targeted runtime combination tests required | Catch/heal/run/item/field-move/EXP/economy hook or option-key changes |
| Gen1Recomp built-in Save Editor | dev/current upstream audit | 2026-08-17 / 2.4.33 | FULL SOURCE/SAVE-MUTATION AUDIT + LOCAL RECONCILIATION | Whole-save decode/encode preserves mod fields; Nuzlocke reasserts dead-state and reports external party-cap violations without destructive correction; external additions retain EDITED provenance | HIGH structural; edited-save runtime round trips TEST REQUIRED | SaveData/editor mutation funnel, validation behavior, party capacity, or mod-state serialization changes |
| Quality of Life (unxpected-uxp) | 1.3.0 | 2026-08-17 / 2.4.32 | FULL SOURCE/HOOK AUDIT + LOCAL ADAPTER | Gen1 Easy Interactions SELECT shortcut suppressed during Travel/Dungeon vetoes; Gold native field-move path retained; Repels remain under existing item/native policy | HIGH expected compatibility; targeted runtime tests required | Easy Interactions field-move/Repel invocation or option architecture changes |
| Kanto Reforged | 1.2.0 | 2026-08-17 / 2.4.75 | FULL SOURCE/HOOK RE-AUDIT | trainer.party/species/held items compose; level caps co-own by stricter live value | Runtime combination TEST REQUIRED | KR level-cap storage/module contract, trainer-party, species scope, or held-item model changes |
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

- Audited published release: **0.2.7**
- Additional moving-development audit: **`dev` @ `def270f7c726ebd7bd87086ad90bc4a7b9622543`** (2026-08-19 / Nuzlocke 2.5.36)
- Manifest: **`>=0.1.86 <2.0.0`**
- Mod API: **2**
- Engine save format: **4**
- Games declared: Red, Blue, Yellow, Gold
- `affects_link: true`

The stable `recompCompatAudited` marker remains 0.2.7 because the `dev` SHA is moving development state, not a published compatibility profile. 2.4.57 broadened the manifest to `>=0.1.86 <2.0.0`; that range is an engine-semver load declaration, not automatic runtime certification, and Mod API 2 remains the separate breaking mod-surface contract.


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

## 2.4.76 external-mod audit ledger refresh

This section records the compatibility audits performed after 2.4.75. These are **source/package classifications, not runtime PASS results**. No adapter is added merely because a mod is listed here.

| Mod | Version audited/current | Classification | Main Nuzlocke overlap / required follow-up |
|---|---:|---|---|
| NPC Bubbles | 2.3.11 | HIGH expected compatibility | Presentation/observational NPC markers; custom code-driven NPCs may receive generic markers; R/B/Y smoke test recommended |
| Guaranteed Catch | 1.0.0 | Expected compatible | Catch-roll replacement must still pass acquisition legality, One Per Area, Type Locke/BST/species/static rules; illegal-catch runtime test required |
| Repel Reuse Prompt | 1.0.0 | Likely compatible / path not fully source-confirmed | Verify YES reuse cannot bypass No Repels via a direct inventory/step reset |
| HM Anywhere | 1.1.0 | Structurally compatible | Required-badge behavior is compatible; verify custom FLY cannot bypass Travel Restrictions or Dungeon/Gym Lock-Ins |
| New Game Plus | 1.0.0 | Structurally compatible | Treat as continuation of the same playthrough; verify encounter/death ledger persistence and scaled trainer/wild composition |
| Area DexNav | 1.0.0 | Expected compatible | Forced encounter comes from current area's real encounter table; verify consumed-area legality/tracker behavior |
| Summon | 1.0.2 | HIGH-priority runtime test | Arbitrary species forced into a normal wild encounter; verify area provenance plus species/Type/BST/static legality and tracker consumption |
| Modern Bag | 1.5.2 | Expected compatible | Alternate Bag UI; verify USE still reaches No Field Heal/Repels/Rope/PP/X/Rare Candy enforcement |
| Item Shortcut | 1.4.0 | HIGH-priority runtime test | Direct/FAST item use; verify no alternate-use bypass of item restrictions or cap enforcement |
| Reusable Machines | 1.0.1 | Expected compatible | TM non-consumption/HM forgetting; verify any Nuzlocke TM restriction applies to teaching, not consumption only |
| DV/EV Editor | 1.0.1 | Mechanically compatible / explicit external override | Editor intentionally writes DVs and Stat EXP. Current policy: generation/accumulation rules do not make Nuzlocke an anti-cheat loop that silently undoes editor changes |
| EXP Share Modes | 1.0.0 | HIGH expected compatibility | Per-mon `exp.gain` cap should trim/block redistributed EXP; test capped participant/bench and EXP Edging |
| Free Rare Candy | 1.0.0 | Expected compatible | No Buying, No Rare Candy, and level-cap use policy should remain authoritative despite free inventory source |
| Free Master Ball | 1.0.0 | Expected compatible | No Buying and capture legality remain authoritative; regression-test Master-specific restriction semantics |
| Too Many Balls | 0.6.1 | Strong source/static compatibility | Custom rate/roll/post-catch balls across Gen1+Gold; verify custom-ball identity never bypasses capture legality and Cradle/Heal post-catch effects preserve provenance/death semantics |
| Better Battle UI | 0.2.1 | HIGH expected presentation compatibility | Additive battle overlay; test spatial overlap with Encounter Indicator/status and optionally Dramatic Shape |

## 2.4.77 completed FAFF0x audit wave

The following targets were inspected after 2.4.76. These remain **source/package/static/expected classifications, not runtime PASS results**. A compatibility adapter should only be added after a concrete bypass or ownership gap is demonstrated.

| Mod | Current package/version evidence | Classification | Nuzlocke ownership / runtime requirement |
|---|---|---|---|
| Modern UI Fix | `modern_ui_fix_v1.0.0.zip` | Presentation add-on / potentially helpful | Does **not** close the historical Gen1 Modern UI + Encounter Tracker crash by itself. Fresh combo test: ENC TRACKER pages, Catch Info, Nuz Status, duplicate-screen ownership. |
| Advanced Box System | `advanced_box_system_v1.1.0.zip` | Architecture-aligned | Test dead-mon withdraw/swap rejection, Party Size growth vs one-for-one SWAP, Solo, release persistence, provenance/EXP-edging retention. |
| Nickname Changer | `nickname_changer_v1.0.0.zip` | Expected compatible | Nickname Rule is acquisition-time naming, not a permanent rename lock. Verify the initial nickname requirement cannot be bypassed. |
| Trade Evolution Fix | `trade_evolution_fix_v1.0.0.zip` | Architecture-aligned | Converts four Gen I trade evolutions to level 40. Evolution Limits must evaluate the attempted evolution regardless of trigger method. |
| Universal Free TM Shop | `all_tm_shop_v1.0.0.zip` | Potentially compatible | Custom purchase surface: No Buying must still own transaction legality; TM-use restrictions must still own teaching. |
| Moves Manager | `moves_manager_v1.0.1.zip` | Mechanically compatible | Do not blanket-block an intentional move editor. Test only rules that explicitly own move acquisition/PP/TM behavior. |
| Quest System | `quest_system_v1.0.5.zip` | Framework-compatible | Keep framework neutral; audit each downstream quest for reward/acquisition provenance, trainer battles, warps, and progression writes. |
| The Mirage of Mew | `mew_mirage_v1.0.1.zip` | High-priority runtime target | Test No Mythicals, No Static Encounters, One Per Area, Failed Encounters, shiny interaction, and quest/static provenance. |
| Crystal Onix | `crystal_onix_v1.0.8.zip` | Structurally promising | Test custom/static species metadata, No Static Encounters, One Per Area, Maximum BST, Type Locke, tracker identity, retry semantics. |
| Poachers in the Safari Zone | `poachers_in_the_safari_zone_v1.0.0.zip` | High-priority content target | Test Safari splits OFF/ON, scripted encounters, Failed Encounters, trainer battles, quest rewards, tracker stability. |
| Kanto Achievements | `kanto_achievements_v1.0.6.zip` | Low-risk observational | Smoke test catch/Dex/badge/battle observations; rejected Nuzlocke acquisitions must not become false kept-catch state. |
| Pokédex Plus | `pokedex_plus_v1.3.4.zip` | Strong expected compatibility | Custom species/UI smoke test; Pokédex seen/owned state must remain separate from Nuzlocke area consumption. |
| Catch Helper | `catch_helper_v1.4.0.zip` | Low-risk observational | Test custom balls + Guaranteed Catch; displayed odds remain informational and must not own encounter legality or RNG state. |
| Move Inspector | `move_inspector_v1.0.0.zip` | Strong expected compatibility | Presentation-only battle move information; smoke test No X/Healing/Escape/PP and Physical/Special Split display coexistence. |
| Rocket Gym Ambushes | `rocket_gym_ambushes_v1.0.1.zip` | High-value reward-acquisition target | Recruitable Rocket Pokémon should be gift/reward provenance, not One Per Area consumption; added battles must respect death/caps. |
| Team Rocket Returns | `team_rocket_returns_v1.0.1.zip` | Expected architectural compatibility | Reward Porygon is gift/reward; Master Ball possession is fine; scaled trainers still pass death/cap enforcement. |
| Eevee Three Stones / Three-Stone Covenant | `eevee_three_stones_v1.0.2.zip` | High-value multi-gift target | Jolteon/Vaporeon/Flareon rewards should not consume area encounters; test party restrictions and battle death/caps. |
| The Sixth Bell | `the_sixth_bell_v1.1.4.zip` | Expected architectural compatibility | Gengar reward should use gift/reward provenance; quest battles use normal Permadeath/caps. |
| The Stolen Fossil | `the_stolen_fossil_v1.0.1.zip` | Expected compatible | Chosen Omanyte/Kabuto reward should be gift/reward, not Mt. Moon encounter consumption. |
| Whispers Beneath Cerulean | `whispers_beneath_cerulean_v1.0.1.zip` | Architecture-aligned | Starmie reward is gift/reward; preserve intentional max-DV/max-Stat-EXP reward rather than anti-cheat rewriting it. |
| The Abandoned Cabin | `the_abandoned_cabin_v1.0.0.zip` | Expected compatible | Electabuzz reward is gift/reward; preserve max DVs/Stat EXP; quest battles respect Permadeath/caps. |
| The Black Flower | `the_black_flower_v1.0.0.zip` | Architecture-aligned | Vileplume reward is gift/reward; preserve max stats; boss battles use normal rule enforcement. |
| The Empty Throne | `the_empty_throne_v1.0.0.zip` | High-value scripted-content target | Test boss sequence, rewards, progression, death/caps, and area accounting. |
| Ashes of Cinnabar | `ashes_of_cinnabar_v1.0.0.zip` | Architecture-aligned | Test scripted encounters/rewards, Cinnabar/Mansion area accounting, static/species restrictions, and cap/death behavior. |
| Echoes Beyond the Fog | `echoes_beyond_the_fog_v2.2.0.zip` | Very high-value runtime target | Perfect level-50 Dragonite reward should be gift/reward; test Pseudo/Type/BST restrictions, custom maps, battles, and perfect-stat preservation. |
| Move Learn Stats | `move_learn_stats_v1.0.2.zip` | Strong expected compatibility | Move-learning UI only; smoke test level-up/TM/HM/Moves Manager/Reusable Machines and Physical/Special Split metadata. |
| Performance Monitor | `performance_monitor_v1.3.0.zip` | Strong expected compatibility | Combined-diagnostics test: no recursive instrumentation, doubled counters, listener-order behavior change, save mutation, or severe slowdown. |
| BATTLE_ART_VOXEL_FORK | Gen1 `1.7.8`; Gen2 `1.8.0` | Presentation-oriented / packaged source | Battle UI runtime certification required in R/B/Y and Gold, including faint/switch/status overlays and field/battle rule rejection paths. |
| new_icons | `new_icons_v1.1.1.zip` | Presentation-only | No adapter justified. Visual smoke test in party/PC/tracker/status/custom-species displays. |
| New Item Icons | `new_item_icons_v1.0.0.zip` | Presentation-only | No alternate item-use path found; no adapter justified. Visual Bag/TM-HM smoke test only. |

### Package-version evidence rule

When the `FAFF0x/gen1recomp` README and root package filename disagree, the root package filename is treated as the current package evidence. Known examples include Advanced Box System 1.1.0, Kanto Achievements 1.0.6, Move Learn Stats 1.0.2, and new_icons 1.1.1. This is a packaging/version classification only, not a runtime compatibility claim.

## Remaining active compatibility targets

The large direct-overlap queue from 2.4.76 is now substantially exhausted. Remaining work should prioritize **mechanic ownership or unresolved runtime risk**, not visual popularity.

### Priority A — unresolved/high-risk runtime combinations

1. **Gen1 Modern UI + Modern UI Fix + Nuzlocke Encounter Tracker** — historical tracker crash remains unresolved until fresh runtime testing.
2. **Advanced Box System 1.1.0** — runtime PC transaction matrix for dead-mon projection, Party Size, Solo, release, and provenance.
3. **Summon 1.0.2 / Area DexNav 1.0.0** — forced encounter provenance/area legality under One Per Area, Type Locke, BST/species rules.
4. **Modern Bag 1.5.2 / Item Shortcut 1.4.0 / Repel Reuse Prompt 1.0.0** — alternate item-use paths against No Field Heal, No Repels, Rope, PP, X Items, Rare Candy and cap policy.
5. **Echoes Beyond the Fog 2.2.0 / Mirage of Mew 1.0.1 / Crystal Onix 1.0.8** — custom species/static/gift provenance and species-legality matrix.
6. **Quest reward family** — verify gift/reward provenance for Rocket Gym Ambushes, Team Rocket Returns, Eevee Three Stones, The Sixth Bell, The Stolen Fossil, Whispers, Abandoned Cabin, Black Flower, Empty Throne, Ashes, and Poachers.
7. **EXP Share Modes 1.0.0** — cap/EXP Edging redistribution matrix.
8. **Too Many Balls 0.6.1** — Gen1+Gold custom-ball matrix, especially Master-like balls, Cradle/Heal post-catch behavior, and No Buying.

### Priority B — lower-risk runtime certification

- Better Battle UI 0.2.1, BATTLE_ART_VOXEL_FORK, Performance Monitor, Catch Helper, Pokédex Plus, Kanto Achievements, Move Inspector, Move Learn Stats, new_icons, New Item Icons, and other art/sprite packages.
- Presentation-only mods should not receive custom Nuzlocke adapters without a demonstrated state-ownership conflict.

### Unresolved historical names

- **Kanto Life** — no current canonical upstream under the historical exact name.
- **Ironmon Ultimate** — no fresh canonical current Gen1Recomp upstream located.
- **Enemy HP** — exact historical upstream unresolved; Better Battle UI is tracked separately and must not be substituted as the same mod.

### Target-selection rule

Audit by **mechanic ownership**. Alternate transactions—catch, item use, PC swap/release, evolution, gift/static acquisition, warp, save lifecycle—outrank cosmetic changes. Build a new Nuzlocke child only when a concrete compatibility gap is found; otherwise update documentation and keep runtime behavior untouched.

## Translation mods — 2.4.80 audit
Nuzlocke composes through Gen1Recomp `Strings(...)` and English fallback. Shared description/world-text wrapping is glyph-aware as of 2.4.80. Translation packs should not need to patch Nuzlocke gameplay logic. Runtime combinations remain TEST REQUIRED until verified.

## Current Gen1Recomp / launcher audit — 2.4.81
Current upstream development adds read-only BattleAPI modules for both generations and expands Manifest v2 / launcher handling. Nuzlocke consumes BattleAPI only as an optional read-only compatibility surface. The existing `github: Stone696/nuzlocke` field is already the launcher repository hint for update/version discovery. Engine support remains `>=0.1.86 <2.0.0`.

## `(PT-BR) Versão Brasileira` / `gen1_pt-br` v0.1.5 — 2.4.82
Status: **TEST REQUIRED**.

The translation mod uses Gen1Recomp content registries for dialogue, strings, species, moves, items, trainers and statuses, and also patches presentation classes including `TrainerCard`, `BattleState`, `ListMenu`, `MoveLearnMenu`, `Font`, and `TitleState`. Nuzlocke declares it as an optional dependency for deterministic cooperative ordering and does not patch PT-BR private functions.

Main runtime-risk surfaces are Trainer Card/Nuz Info composition, battle/menu geometry, globally localized `Font.draw`/`Font.split`, Yellow-specific presentation, translated item-name width, and accented/multibyte wrapping. Nuzlocke 2.4.80+'s glyph-safe wrappers are intended to make the latter safe.

## Yellow starter naming — 2.4.83
Current Gen1Recomp repaired Yellow's Oak-lab Pikachu `give_pokemon` row so it leaves `skipNickname` unset and reaches native AskName. Nuzlocke now preserves that native Yellow prompt. With Nickname Rule enabled, declining it falls through to Nuzlocke's mandatory non-empty NamingScreen. Red/Blue's existing path is unchanged.

## Old-save selector migration — 2.4.84
Legacy saves may contain boolean values for rules that are numeric selectors today. The central save-upgrade pipeline now persists the unambiguous modern equivalents for Shiny Clause, Dupes Clause, Gold Egg Encounter, Gold Bug Contest, and the historical Starting Rare Candies resource. This is canonicalization only; it does not reset run counters or alter ambiguous intent.

## Encounter Ball Limit — 2.4.85
R/B/Y composes at the existing `BattleState.throwBall` seam after capture legality and before the native throw. Gold composes at its existing battle `useItem` Ball path before native consumption. Custom capture providers that bypass those engine Ball-use seams are not silently counted; they should compose through the exposed compatibility helpers rather than receiving guessed accounting.

## Gen1Recomp 0.2.2–0.2.7
The release deltas through 0.2.7 were source-audited. No change to the Nuzlocke engine requirement is needed; it remains `>=0.1.86 <2.0.0`. The final 0.2.7 Gold encounter schema includes TimeFishGroups/day-night fishing under the shared `encounters` registry; Nuzlocke's public final-registry facade now resolves the Gold `gen2Encounters` target. Newer additive battle/UI/render/audio surfaces are observed rather than commandeered, preserving compatibility with presentation and input mods.


## Exact edition versus shared generation (2.5.67)

Red, Blue and Yellow continue to share Gen 1 mechanics; Gold and Silver continue to share the Gen 2 engine path. That sharing no longer means diagnostic identity is shared: runtime reports and user-facing status/rules surfaces identify the exact edition. Compatibility code should branch on generation only when the engine/mechanic is genuinely shared, and on exact edition only for edition-specific data or behavior.
