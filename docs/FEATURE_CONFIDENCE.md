> **Edition-specific evidence:** This confidence register describes the existing Gen 1/2 certification programme; Gen 3 beta feature availability and remaining manual ROM tests are listed in the [Gen 3 matrix](GEN3_FEATURE_MATRIX.md) and [test checklist](GEN3_TEST_CHECKLIST.md). Source-reviewed or automated-smoke passing does not automatically mean runtime-certified.

<!-- Current build: 2.9.72 -->
# Feature Confidence — 2.9.72

Evidence labels are intentionally strict: Runtime PASS/FAIL applies only to the exact tested edition/stack; Static/Semantic or Source/Compatibility review never upgrades itself to runtime certification.

## Current confidence
- UI presentation-ownership contract v1 / UI API 8: **STATIC CONTRACT PASS — external presentation stacks still require combined runtime evidence**.
- HGSS Visual Overhaul 1.0.2: **SOURCE REVIEW PASS / EXPECTED COMPATIBLE — Yellow combined runtime test required**.
- Nuzlocke UI input-semantics contract v1: **STATIC CONTRACT PASS — combined input-repeat mod runtime test still required**.

- Gen1Recomp 0.2.41 source compatibility: **SOURCE PASS — exact-edition runtime smoke remains separate**.
- Yellow 2.9.70 / Gen1Recomp 0.2.41 Random Field Items: **RUNTIME FAIL** — native pickup completed but configured field-item randomization was not applied.
- R/B/Y Random Field Items 2.9.71 repair: **STATIC/SOURCE PASS — runtime retest required**; primary visible-item seam moved to public `world.talk`.
- R/B/Y: **mature baseline**, with individual features retaining their historical runtime evidence.
- Gold/Silver: **beta**; exact-edition evidence remains independent.
- Crystal: **alpha**; exact-edition certification remains limited and must fail closed where evidence is absent.
- Red standalone built-in shiny test from 2.8.37: **RUNTIME PASS — PROTECTED**, only for that Red/Nuzlocke-only configuration.
- Gen-II Random Trainers: **RUNTIME FAIL / UNRESOLVED**; static pipeline/accepted-roster diagnostics exist but do not constitute a fix.
- Gen-II Random Field Items: **RUNTIME FAIL / UNRESOLVED**; static native-builder/script-projection diagnostics exist but do not constitute a fix.
- Shiny Pokémon 1.2.20, Kanto Reforged 1.5.3, QoL Toggles 1.30.8, current Randomizer coexistence targets, G9 Battle Engine family, The World/Wonder Trade, bag ecosystem, expanded species/type providers, and Blackjack Corner 0.8.2, Double Battles 0.6.1, Free Fly 1.8.0, and other compatibility targets: **SOURCE/CONTRACT REVIEWED — combined runtime certification remains target-specific unless separately recorded**.
- F. TOKEN failed-area directional confirmation repair: **STATIC/PARSE PASS — focused runtime reproduction pending unless separately reported**.
- Save Schema 5 / Compatibility API 37 / Diagnostics API 1 / Translation API 2 / Run History v2 / Randomizer algorithm v1: **CURRENT CONTRACT**.

2.9.40 classifies compatibility evidence as live-contract, source-reviewed, and combined-runtime-required while preserving exact-edition/stack Runtime PASS boundaries. Release Safety itself received semantic and false-positive hardening; no new Runtime PASS is claimed.

# Historical Feature Confidence — 2.8.48

## Gen1Recomp 0.2.28 / 0.2.29 compatibility

- **0.2.28 source diff:** PASS — HostShell/iOS metadata only; no Nuzlocke gameplay seam changed.
- **0.2.29 source diff:** PASS — launcher/importer/input/UI only; no battle/Pokémon/hook/Strings/Chrome/save/shiny/Randomizer-consumed data seam changed.
- **Compatibility API 36:** STATIC CONTRACT PASS target; additive semantic provider/capability status versioning only.
- **Save Schema:** remains 5; no migration is required.
- **Runtime certification:** no new exact-edition runtime PASS is claimed by this source audit.

# Feature Confidence — 2.8.41

## 2.8.41 Dev Mode semantic diagnostics

- System Health / provider ownership / encounter provenance / decision trace: **STATIC/PARSE TARGET — runtime UI smoke recommended**.
- Diagnostic-only contract: no intended gameplay/save-schema/provider-ownership change.


## 2.8.40 Release Safety expansion

- **Gameplay behavior:** unchanged from 2.8.39 by design.
- **Static regression bundle:** SOURCE/STRUCTURAL PASS target for native Gen II battle-party ownership, shiny single-owner failover, transaction journaling, and battle.started dual event shape.
- **Randomizer performance:** existing read-only structural audit promoted into the release gate; host/runtime performance certification remains separate.
- **Runtime evidence:** no new runtime PASS is claimed by this static-hardening build.


## 2.8.39 compatibility diagnostics update

- **Gameplay behavior:** unchanged from 2.8.38 by design.
- **Provider diagnostics:** STATIC PASS target; detected/advertised/selected/fallback states now have separate read-only descriptors.
- **Fallback cleanup:** no fallback was removed because each inventoried path still serves the supported engine/provider floor.
- **MOD COMPAT:** provider-health and retained-fallback summaries added; runtime visual verification remains pending.


## 2.8.38 localization coverage update

**STATIC PASS / RUNTIME TRANSLATION TEST REQUIRED.** The migrated Battle Clause, Forgiveness, Classic status/history, and recovery surfaces now route authored text through the engine `Strings` registry and are protected by a targeted Release Safety source audit. This establishes source-level readiness, not certification in any specific translated language or variable-width-font environment. World Building and Randomizer remain incomplete localization targets.

## 2.8.37 release certification update

**PASS — Red standalone shiny smoke:** Nuzlocke only, Shiny Rate = ALWAYS, Shiny Colors ON, Shiny Intro ON. Wild Rattata and Kakuna both appeared with shiny coloration and the shiny intro presentation. This protects the standalone Gen I owner/roll/recolor/intro path.


- Shiny Pokémon 1.2.7 provider/API ownership compatibility (Gen I + Gen II): **SOURCE AUDIT PASS — COMBINED RUNTIME CERTIFICATION REQUIRED**.
- Gen1Recomp 0.2.27 COLORS-transition renderer/asset ownership: **SOURCE AUDIT PASS — Nuzlocke performs no engine cache invalidation; runtime palette-switch smoke recommended**.


## Built-in shiny presentation

**Static/source confidence: medium-high; runtime certification required.** The implementation now uses the current engine seams specifically intended for per-instance Pokemon art (`pokemon.sprite` / `pokemon.icon`) and shiny/HUD overlays (`battle.overlay`), and Release Safety forbids constructor or native battle-draw ownership. Runtime testing is still required for the first derived-image bake, battle sparkle/audio timing, Summary/party presentation, external-provider failover, and exact-edition Gen-II behavior.

2.8.37 is the current full release. Red standalone shiny generation/presentation is runtime-PASS: Nuzlocke-only Shiny Rate = ALWAYS produced visibly recolored wild Rattata and Kakuna with shiny intro presentation. Other compatibility additions still retain exact-edition / combined-mod certification requirements where noted.

# Feature Confidence — 2.8.33

- Silver 2.8.31 Gen II Random Starter full identity chain: **RUNTIME PASS — PROTECTED**.
- 2.8.32 live type-chart / `steel_typing` integration: **STATIC REVIEW PASS — COMBINED-MOD RUNTIME REQUIRED**.
- PotatoVoxel 1.9.6 renderer/presentation coexistence: **SOURCE/STATIC AUDIT PASS — COMBINED-MOD RUNTIME REQUIRED**.
- Dramatic Shape Voxel Mod 1.9.0 (`DRAMATIC_SHAPE`) presentation coexistence: **SOURCE/TARGET VERIFIED — COMBINED-MOD RUNTIME REQUIRED**.
- Generalized presentation ownership guard (`render.compose`, `Gen2BattleState`, native BattleState draw methods): **STATIC CONTRACT PASS**.
- PotatoVoxel cache/prebuild non-progression behavior: **SOURCE AUDIT PASS — RUNTIME TRIPWIRE TEST RECOMMENDED**.

# Feature Confidence — 2.8.32

- Silver 2.8.31 Gen II Random Starter full identity chain: **RUNTIME PASS**.
- Type-chart companion / Starter Trio Typing live-chart integration: **STATIC REVIEW PASS — COMBINED-MOD RUNTIME REQUIRED**.

# Feature Confidence — 2.8.31

- Silver 2.8.30 Random Starter 3-STAGE: runtime PASS for base-form filtering, randomized Bellsprout portrait, actual Bellsprout award, and later nickname species identity; receipt/confirmation text remained mismatched and is the only 2.8.31 target.

- 2.8.29 Crystal native battle command UI + prohibited battle-item denial return: **runtime PASS**; protected.
- Gold Random Starter 3-STAGE base-form filtering: **source/semantic repair; runtime required**.
- Gold Elm randomized cry: reporter observed randomized cry before 2.8.31; preserved.
- Silver Elm randomized confirmation text: 2.8.30 runtime FAIL (`...`); 2.8.31 literal/raw-text repair **runtime required**.
- Gold final randomized starter grant: reporter received randomized Pupitar on 2.8.29; transaction execution is proven reachable, while corrected 3-STAGE species selection is **runtime required**.
- Wilds 2.2.0 compatibility hardening: unchanged; coexistence runtime testing remains separate.

# Feature Confidence — 2.8.29

- Crystal 2.8.27: field NUZ INFO, battle-owned party cancel/switch, and Pack party-target item use **runtime PASS**.
- 2.8.28: **runtime FAIL/quarantined** after Nuzlocke battle-menu presentation and Gen II item-denial freeze were reproduced.
- Prior 2.8.29 candidate: **runtime FAIL/quarantined**; Battle Menu UI was only guarded, not fully removed from Gen II runtime, and the denial freeze remained.
- 2.8.29 corrective candidate: Gen II Battle Menu UI registration removed and legacy custom denial phase retired; **runtime test required**.
- Gen I Battle Menu UI: preserved, no intentional behavior change.
- Wilds 2.2.0 compatibility hardening: static/source-audited; coexistence runtime testing still required.

# Feature Confidence — 2.8.29

- 2.8.27 Crystal field NUZ INFO: **runtime PASS**.
- 2.8.27 Crystal battle party cancel/switch ownership: **runtime PASS**.
- 2.8.27 Crystal Pack party-target item application: **runtime PASS**.
- 2.8.28 Crystal Battle Menu UI presentation: **runtime FAIL / quarantined**.
- 2.8.29 Gold/Silver/Crystal native battle-command ownership: **runtime retest required**.
- Gen I optional Battle Menu UI behavior is intentionally retained and requires no Gen II parity.
- Gen II battle-item rule denial return/freeze repair: **source/static candidate; exact Crystal runtime retest required**.

## Historical current note: Feature Confidence — 2.8.27

- Gen II battle party routing: **2.8.26 runtime FAIL; 2.8.27 test required**.
- Gen II PartyMenu method ownership: **source/static isolation complete**.
- Gen II party-target item execution: preserved at native/per-instance seams;
  **regression retest required**.

## 2.8.04 UI follow-up / protected runtime evidence

- Crystal 2.8.03: Gen II party-target item use runtime PASS.
- Crystal 2.8.03: Trainer Randomization runtime PASS; broader Randomizer options/sub-options observed working, with untested individual subsystems not promoted to independent PASS without direct evidence.
- 2.8.04 changes only Nuzlocke-owned Gen II presentation/layout paths for the reported utility screens; the above gameplay paths are protected from intentional modification.

# Feature Confidence — 2.8.01
## 2.8.01 runtime targets
- Crystal Trainer Randomizer options: **2.8.00 FAIL / missing; 2.8.01 STATIC FIX — RUNTIME REQUIRED**.
- Crystal last-usable-party overworld poison faint: **2.8.00 FAIL / continued play; 2.8.01 STATIC FIX — RUNTIME REQUIRED**.
- Gen II party-target item use: **KNOWN FAIL / unchanged in 2.8.01**.


## 2.8.00 runtime targets

- Crystal 2.7.106 Gen2 simple party consumables: **FAIL** — target selection succeeds, then healing items, vitamins and Rare Candy return to the Pack without applying.
- 2.8.00 Pack-seam authoritative-live-slot commit repair: **STATIC/SEMANTIC PASS — RUNTIME REQUIRED** with damaged Pokémon + Potion, one vitamin, and Rare Candy.
- Crystal Profile Slot / Save Profile / Load Profile: **PASS / protected**.
- Held UP/DOWN navigation functionality: **PASS**; 2.8.00 slower five-stage timing is **TEST REQUIRED for feel**.
- World Building fresh/default tier: **T3 / protected**.

## 2.7.106 runtime targets

- Crystal 2.7.105 chooser-mode repair: **PARTIAL PASS** — selecting a target no longer opens the ordinary Pokémon action submenu.
- Crystal Gen2 simple party consumables: **FAIL entering 2.7.106** — Rare Candy, vitamins, and healing items return to Pack without applying after target selection.
- 2.7.106 direct ItemEffects post-selection repair: **TEST REQUIRED** with a damaged Pokémon + Potion, one vitamin, and Rare Candy.
- Held UP/DOWN navigation: **FUNCTIONAL PASS in 2.7.105**, five-stage speed curve in 2.7.106 is **TEST REQUIRED for feel**.
- TOOLS Profile Slot / Save Profile / Load Profile: **protected runtime PASS**.

## 2.7.105 runtime targets

- Crystal 2.7.104 party-item path: **FAIL, precisely localized** — "Use on which Pokémon?" opens, but selecting Steelix opens the ordinary field Pokémon submenu instead of invoking the item callback.
- 2.7.105 Gen2 `useItem` chooser-mode guard: **STATIC/SEMANTIC PASS — RUNTIME REQUIRED** for Potion, vitamin and Rare Candy.
- Crystal 2.7.103 TOOLS Profile Slot / Save Profile / Load Profile behavior: **PASS / protected**.
- Setup + NUZ RULES held UP/DOWN auto-repeat: **STATIC PASS — RUNTIME REQUIRED**; SELECT+UP/DOWN section jumping remains authoritative.
- World Building default T3 remains protected.

## 2.7.104 runtime targets

- Crystal 2.7.103 TOOLS profile behavior: **PASS / protected**.
- Crystal randomized Steelix party-target items: **FAIL entering 2.7.104**.
- 2.7.104 native-record materialization: **TEST REQUIRED** with damaged-Pokémon Potion, vitamin, and Rare Candy.
- World Building default T3 remains unchanged from 2.7.103.

## 2.7.103 runtime targets

- Crystal/Silver Gen2 party-target item use (Potion, vitamin, Rare Candy): TEST REQUIRED.
- TOOLS Profile Slot OFF/1/2/3 selection and distinct Save/Load actions: TEST REQUIRED.
- World Building fresh/default value T3 across R/B/Y and Gen2: STATIC PASS / RUNTIME TEST REQUIRED.

## 2.7.102 runtime targets

- Gold/Silver/Crystal party-target item use after Nuzlocke/randomized starter materialization: **TEST REQUIRED** for Potion, vitamin, and Rare Candy.
- Setup and in-run TOOLS shared profile target OFF/1/2/3, Save Profile, and Load Profile preview/apply: **TEST REQUIRED**.
- Crystal 2.7.99 ENC TRACKER LOG/MAP and MOD COMPAT no-crash evidence remains protected.

## 2.7.101 runtime targets

- Gen2 Center Heal ban: STATIC/SOURCE PASS — RUNTIME REQUIRED.
- Gen2 Shop Restrictions visibility/enforcement: STATIC/SOURCE PASS — RUNTIME REQUIRED.
- In-run Profile Save/Load + Encounter Assignment: STATIC/SOURCE PASS — RUNTIME REQUIRED.
- Crystal opening DST skip: STATIC/SOURCE PASS — RUNTIME REQUIRED.
- Gen1Recomp 0.2.25 compatibility: SOURCE/DOC PASS — exact-edition runtime smoke required.
- Random Starter selection/award remains protected from 2.7.94 runtime PASS evidence.

## 2.7.95 runtime targets

- **Protected 2.7.94 evidence:** Red Random Starter AUTO awarded Alakazam without crash; Silver Random Starter AUTO worked with correct starter provenance; Crystal Random Starter AUTO selected/awarded Growlithe without crash and Elm text said Growlithe, while the native Chikorita portrait intentionally remained.
- Gen-2 ENC TRACKER MAP canonical Johto/Kanto ordering and interior filtering: RETEST REQUIRED on Silver or Crystal.
- R/B/Y Setup all-black presentation: RETEST REQUIRED.
- MOD COMPAT title spacing, selector clearance, and slow down-arrow blink: RETEST REQUIRED.
- Battle Menu UI compact pixel-box presentation and native command parity: RETEST REQUIRED.
- Crystal randomized starter portrait parity remains open/ALPHA and is not changed in 2.7.95.

## 2.7.94 runtime targets

- **Historical bisect:** 2.7.44 Red New Game Random Starter PASS; 2.7.45 Red FAIL (vanilla starters). 2.7.54, 2.7.70, and 2.7.93 Red also FAIL. Published 2.7.28 Yellow New Game Random Starter PASS.
- **Primary acceptance:** 2.7.94 Red New Game + Random Starter ON must present/award a non-vanilla seeded starter choice. TEST REQUIRED.
- Yellow Random Starter regression protection: RETEST REQUIRED.
- Species Pool must remain effective for Encounters/Trainers/Evolutions while being inert for Random Starter. TEST REQUIRED.
- Gold/Silver/Crystal starter paths remain independent runtime evidence targets. Historical Gold 2.7.28 `No Glitch Pokemon` Elm text is not treated as the same Gen1 regression.
- `NUZLOCKE SETUP` / `NUZLOCKE RULES` title wording: R/B/Y presentation RETEST REQUIRED.

## 2.7.93 runtime targets

- Battle Menu UI OFF: native battle command presentation must remain unchanged.
- Battle Menu UI ON, one R/B/Y edition: ordinary FIGHT / POKEMON / BAG / RUN panel and native command behavior RETEST REQUIRED.
- Battle Menu UI is not exposed or rendered on Gold/Silver/Crystal; native Gen II presentation is the required behavior.
- Special Safari / Bug Contest / tutorial battle menus must remain native.
- Run / Surf OFF / HOLD B / ALWAYS: walking and Surf parity RETEST REQUIRED on one R/B/Y edition and Silver.
- Old split movement values: conservative migration to the more restrictive value RETEST REQUIRED.
- Silver vanilla Elm starter PASS from 2.7.90 remains protected.
- Silver Random Starter rerolled-seed crash hardening remains RETEST REQUIRED.
- Crystal Mom DST prompt remains deliberately deferred.

## 2.7.92 runtime targets

- Setup/Rules bold title + uniform black normal content: RETEST REQUIRED on one R/B/Y edition and one Gen-2 edition.
- Pager remains bottom-center and rule rows remain raised: inherited from 2.7.91; RETEST REQUIRED.
- Silver vanilla Elm starter PASS from 2.7.90 remains protected.
- Silver Random Starter rerolled-seed crash: 2.7.91 repair remains RETEST REQUIRED.
- Crystal Mom DST prompt remains deliberately deferred.

## 2.7.91 runtime targets

- Silver vanilla Elm starter: **PASS on 2.7.90**; protected in 2.7.91.
- Silver Random Starter after seed reroll: **CRASH on 2.7.90**; 2.7.91 RETEST REQUIRED.
- Random Starter fault fallback: RETEST REQUIRED; a failed randomization must award vanilla rather than crash.
- R/B/Y Random Starter: still RETEST REQUIRED.
- Setup/Rules pager bottom-center + rows moved upward: RETEST REQUIRED on one R/B/Y edition and one Gen-2 edition.
- Crystal Mom DST prompt remains deliberately deferred.

## 2.7.90 runtime targets

- Silver vanilla Elm starter: 2.7.89 FAIL false glitch rejection; 2.7.90 RETEST REQUIRED after shared same-script provenance and receipt-window repair.
- Crystal vanilla Elm starter: same 2.7.89 FAIL; 2.7.90 RETEST REQUIRED.
- R/B/Y Random Starter: 2.7.89/earlier current-line FAIL; 2.7.90 RETEST REQUIRED after save.created setup-intent durability.
- Gen-2 Random Starter: RETEST REQUIRED after the same durability fix plus mandatory-starter transaction repair.
- Setup/Rules second edition/run subtitle remains intentionally removed.
- Crystal Mom DST prompt remains deliberately deferred.

## 2.7.89 runtime targets

- Recent historical runtime evidence protects R/B/Y Random Starter actual grant and Gold/Silver randomized award behavior. 2.7.89 restores those transaction ownership contracts by comparison rather than restoring an old tree.
- Red 2.7.88 Random Starter: FAIL; 2.7.89 RETEST REQUIRED.
- Crystal 2.7.88 vanilla Elm starter: FAIL false glitch rejection; 2.7.89 RETEST REQUIRED.
- Silver/Gold starter paths: RETEST REQUIRED after shared Elm ownership change.
- Crystal remaining Mom DST prompt: intentionally DEFERRED.
- Setup/Rules second edition/run-state subtitle: intentionally removed in 2.7.89.

## 2.7.88 runtime targets

- Silver vanilla Elm starter: 2.7.87 FAIL (false glitch rejection); 2.7.88 RETEST REQUIRED.
- Crystal vanilla Elm starter: 2.7.87 FAIL (false glitch rejection); 2.7.88 RETEST REQUIRED.
- Gen-2 Random Starter: previous FAIL evidence; 2.7.88 RETEST REQUIRED after native-index and legality repair.
- R/B/Y Random Starter: implementation audited/hardened in 2.7.88; runtime regression matrix REQUIRED.
- Manual Time editor hour + minute: editor PASS on 2.7.87; NUZ RULES summary minutes missing; 2.7.88 RETEST REQUIRED.
- DEV REPORT CODE page frame: restored on 2.7.87 but payload blank; 2.7.88 explicitly generates NZR6 payload; RETEST REQUIRED.
- Crystal loadouts: healing / vitamins / Rare Candy PASS on 2.7.86 and protected.
- Crystal System Date/Time DST suppression: 2.7.87 repair retained; runtime retest still required.

## 2.7.87 runtime targets

- Silver vanilla Elm starter: 2.7.86 FAIL (false glitch rejection); 2.7.87 RETEST REQUIRED.
- Crystal vanilla Elm starter: 2.7.86 FAIL (false glitch rejection); 2.7.87 RETEST REQUIRED.
- Gen-2 Random Starter: 2.7.85 FAIL; 2.7.87 RETEST REQUIRED after canonical species/index repair.
- Crystal System Date/Time: name/time/weekday skip PASS on 2.7.86; Mom DST prompt FAIL; 2.7.87 RETEST REQUIRED.
- Crystal loadouts: healing / vitamins / Rare Candy runtime PASS on 2.7.86 and protected.
- Manual Time hour edit: PASS; minute edit missing on 2.7.86; 2.7.87 RETEST REQUIRED.
- DEV REPORT actionable dashboard: PASS on Silver 2.7.86; code-first page restored in 2.7.87 and RETEST REQUIRED.

## 2.7.86 runtime targets

- Silver vanilla Elm starter: 2.7.85 FAIL; 2.7.86 RETEST REQUIRED.
- Crystal vanilla Elm starter: 2.7.85 FAIL; 2.7.86 RETEST REQUIRED.
- Crystal System Date/Time setup control/bypass: 2.7.85 control missing; 2.7.86 RETEST REQUIRED.
- Red `gen1.field_poison_permadeath` install health: observed FAIL in 2.7.85 DEV REPORT; focused retest required before promotion.

# Feature Confidence — 2.7.85

## 2.7.85 focused evidence

| Surface | Status | Evidence / next test |
| --- | --- | --- |
| Crystal boot / bedroom / world / Elm Lab entry | RUNTIME PASS on 2.7.84 | User reached Elm Lab successfully. |
| Crystal Elm starter-ball interaction | 2.7.84 RUNTIME FAIL; 2.7.85 RETEST REQUIRED | 2.7.85 bypasses Nuzlocke portrait/cry substitution on Crystal while preserving the grant transaction. |
| Red DEV REPORT stored-state Randomizer validation | 2.7.84 FALSE WARN; 2.7.85 RETEST REQUIRED | Historical fixed-size expectations were stale against the live expanded registries; 2.7.85 derives live expected sizes. |



## 2.7.84 focused evidence

| Surface | Confidence | Notes |
|---|---|---|
| Gen1Recomp 0.2.24-era compatibility profile | STATIC/SOURCE PASS — RUNTIME REQUIRED | Mod API/range unchanged; reviewed Crystal, developer, map, field-residual, translation, cart, and lifecycle changes. |
| Crystal manifest/edition routing | STATIC/PARSE PASS — RUNTIME REQUIRED | Explicit sixth target; exact `crystal` identity; shared Gen-2 predicate and edition diagnostics extended. |
| Crystal Alpha in-game labeling | STATIC/PARSE PASS — RUNTIME REQUIRED | Nuzlocke-owned Gen-2 surfaces use `CRYSTAL ALPHA`; exact diagnostic id remains `crystal`. |
| Crystal shared rule applicability | STATIC/SEMANTIC PASS — RUNTIME REQUIRED | Six-edition native matrix and three-choice Gen-2 starter applicability include Crystal. |
| Gen-2 compatibility traps | STATIC PASS | `OptionRows` remains absent; `src.script.Commands` remains protected by explicit non-Gen-2 routing. |
| Crystal gameplay certification | ALPHA / UNTESTED | Gold/Silver evidence is not inherited. Crystal-specific story/progression/encounter/Battle Tower seams require dedicated runtime passes. |


## 2.7.83 focused evidence

| Surface | Confidence | Notes |
|---|---|---|
| Top-right Rules counter | Static/Parse PASS; Runtime Required | Reuses the existing current/total navigation state and native scroll arrows. |
| Direct Nuzlocke Loadout chooser | Static/Parse PASS; Runtime Required | Any preset can be highlighted directly; named presets still use staged exact-change confirmation. |
| Direct Difficulty chooser | Static/Parse PASS; Runtime Required | Uses existing profile summaries, impact diffs, and provider-stack warnings before mutation. |
| Gold/Silver Manual Time | Static/Parse PASS; Runtime Required | Native Clock write; System Clock Sync disabled on apply; minute/weekday preserved. |
| Deferred Starting Ball wording | Static PASS | Timing behavior is unchanged; Setup descriptions now state the capture-unlock delay explicitly. |


## 2.7.82 focused evidence

| Surface | Confidence | Notes |
|---|---|---|
| Silver System Date/Time full Mom DST ladder | Static/Semantic PASS; Runtime Required | Uses live `Vm:specialName()` and transaction state; keeps `rtc.dst=false`. |
| Silver randomized Elm confirmation | Static/Semantic PASS; Runtime Required | Adds final one-shot `Vm:showRaw` fallback after higher seams. |
| Silver starter Tracker New Bark registration | Static/Semantic PASS; Runtime Required | Native Elm event + zero badges + exactly one party Pokémon; identity-idempotent. |
| Silver field Party NUZ INFO | Static/Semantic PASS; Runtime Required | PartyMenu wrapper installs without early edition snapshot; live `self.game` gates behavior. |
| DEV REPORT runtime/build separation | Static PASS; Runtime Required | Release Safety and opaque machine codes are no longer player-facing. |


| Surface | Confidence | Notes |
| --- | --- | --- |
| Gen1Recomp 0.2.21 engine profile | STATIC/SOURCE PASS — RUNTIME REQUIRED | Source-audited compatibility; Mod API/range unchanged; exact-edition smoke required. |
| Gold/Silver System Date/Time DST handling | STATIC PASS — RUNTIME REQUIRED | Both initial DST branches are intercepted and `rtc.dst` is cleared while host-local clock authority owns setup. |
| `isModOptions` settings metadata | STATIC PASS — RUNTIME REQUIRED | Exactly Config, Pokémon Ban, and Mod Compat screens are marked. |

## 2.7.80

Pending Elm post-GIVEPOKE completion, deeper randomized confirmation fallback, narrow legacy starter reconciliation, System Date/Time, System Clock Sync, and Rare Candy TO CAP cancellation are STATIC/PARSE/INTEGRITY targets until exercised at runtime. Gold and Silver clock/starter evidence remains independent; R/B/Y and Gen-2 candy cancellation require separate runtime checks.

## 2.7.79

Gen-2 Elm transaction classification, proven-starter story reconciliation, rendered-preview confirmation authority, scoped identity-less LEGACY cleanup, new reachability diagnostics, and shared Gen-2 utility-title presentation are STATIC/PARSE/INTEGRITY targets until exercised at runtime. Gold and Silver evidence remains independent.


2.7.77 recovery paths are STATIC/PARSE/INTEGRITY PASS targets until runtime exercised. Silver is the primary acceptance edition; Gold and R/B/Y remain independent regression targets.


## 2.7.78

Starter identity normalization, existing-save repair, Gen-2 Recover Catches parity, and identity-preserving manual assignment are STATIC/PARSE/INTEGRITY targets until runtime exercised. The reported Gold duplicate-starter save is the priority acceptance case.
## 2.7.76

2.7.76 Gen-2 authority repairs are STATIC/PARSE/INTEGRITY targets until Silver/Gold/RBY runtime acceptance is exercised.

## 2.7.66 rule-availability audit, pass 2

- Continues the rule-availability audit in a deliberately small pass.
- Yellow no longer exposes Random Starter `Trio Typing` as a native rule because Yellow does not natively use the three-choice starter slate; an explicit compatible `starter_trio` provider can make it available.
- Encounter-slot modifiers now depend on `One Per Area`: Failed Encounters, Dupes, Gen II roamer/egg/contest policies, Town Catches, and area/time/headbutt split controls become dormant while area encounter limits are OFF.
- Type Locke now exposes/effects only the lanes selected by its mode. Catch Draft is hidden while Type Locke is OFF; manual type lanes are hidden/inert during Catch Draft; DUO through HEXA progressively reveal only the required lanes.
- Stored values are preserved while dormant and return when their prerequisite becomes applicable again.
- Release Safety extends the exact-edition/dependency source tripwire for these relationships.


# Feature Confidence — 2.7.65

## 2.7.65 rule availability evidence

- Exact-edition/provider availability contract: STATIC/SOURCE PASS — RUNTIME RETEST REQUIRED.
- Dependency/dominance suppression: STATIC/SOURCE PASS — RUNTIME RETEST REQUIRED.
- R/B/Y Gym Guide Rare Candy + Safari Clause applicability and provider-gated Overworld policy: STATIC/SOURCE PASS — RUNTIME RETEST REQUIRED.

## 2.7.64 MOD COMPAT ownership evidence

- Capability-backed owner candidate retention / preference resolver: STATIC/SOURCE PASS — RUNTIME RETEST REQUIRED.
- MOD COMPAT Left/Right cycling on R/B/Y and Gold/Silver paths: STATIC/SOURCE PASS — RUNTIME RETEST REQUIRED.
- Gameplay-impacting owner warning + cancel-no-mutation path: STATIC/SOURCE PASS — RUNTIME RETEST REQUIRED.
- Fixed-policy/read-only rows remain non-selectable by construction.

## 2.7.63 Tracker / Difficulty evidence

- **Gold Encounter Tracker LOG:** Runtime PASS on 2.7.61-era UI runtime pass: Chikorita recorded in New Bark Town.
- **Gold Encounter Tracker MAP:** Runtime FAIL on 2.7.61-era UI runtime pass: displayed Gen I seed areas/order. 2.7.63 repair is STATIC/SOURCE PASS — RUNTIME RETEST REQUIRED.
- **Gold/Silver Difficulty impact confirmation:** STATIC/SOURCE PASS — RUNTIME TEST REQUIRED per edition.

## 2.7.62 Gen II service parity evidence

- **Gold No Buying:** Runtime PASS on 2.7.61.
- **Gold No Selling:** Runtime PASS on 2.7.61.
- **Gold No Center Heal:** Runtime FAIL on 2.7.61; 2.7.62 repair is STATIC/SOURCE PASS — RUNTIME RETEST REQUIRED.
- **Gold/Silver No Mom Heal:** adjacent Gen II seam gap repaired in 2.7.62 — RUNTIME TEST REQUIRED separately per edition.
- **Gen II semantic seam audit:** STATIC PASS for advertised healing, mart, capture, nickname, gift, trade, static, held-item, field-item, and whiteout adapter installation. This does not convert shared-source coverage into exact-edition runtime PASS.

## 2.7.61 runtime/UI evidence

- **Boot/load:** PASS on runtime-tested Yellow and Gold parent TEST.6 after startup hardening.
- **TEST.7 UI geometry:** TEST REQUIRED. This build repairs observed overlaps but has not yet received runtime certification.
- **Randomizer diagnostic crash repair:** static source repair complete; runtime retest required.


- **2.7.59 startup recovery:** the 104-key World Building catalog currently hashes to `513036232`; the older `926265119` golden had become stale after later presentation-text evolution. Startup no longer hard-asserts on presentation-only catalog drift; Dev/Release Safety still audit it.
## 2.7.57 UI confidence

- Shared typography metrics/fit/wrap/right alignment: **STATIC PASS / RUNTIME TEST REQUIRED**.
- Semantic focus/status row primitive: **STATIC PASS / RUNTIME TEST REQUIRED**.
- Standardized notice fixture: **STATIC PASS / RUNTIME TEST REQUIRED**.
- Variable-width/kerning provider coexistence: **SOURCE/STATIC HARDENED / RUNTIME TEST REQUIRED**.
- Dev UI Gallery typography + notice pages: **STATIC PASS / RUNTIME VISUAL TEST REQUIRED**.

# Feature Confidence — 2.7.57

- **Experimental UI architecture:** STATIC/SYNTAX PASS only. Shared presentation module and initial Setup/NUZ RULES + ENC TRACKER conversion require exact-edition runtime visual/interaction testing.
- **Compatibility with alternative UI renderers:** ARCHITECTURAL/STATIC REVIEW only; Runtime TEST REQUIRED.
- **Gameplay semantics:** intentionally unchanged from canonical 2.7.54; this build does not create new Runtime PASS evidence for gameplay.

- **2.7.35 Phase F #7–9:** STATIC/SEMANTIC validation for team diversity/type-cohesion policy isolation and rival-starter ownership composition. Exact R/B/Y/G/S runtime trainer battles remain TEST REQUIRED.
- **2.7.34 Phase F #4–6:** STATIC/SEMANTIC/HARNESS PASS for trainer hard-pool legality, PKMN BAN exclusion, party level/size preservation, deterministic persisted CHAOS reuse, and separate versioned non-CHAOS policy keys. Exact R/B/Y/G/S trainer-battle runtime determinism remains TEST REQUIRED.
- **2.7.32 Gold help-position cues:** STATIC/SEMANTIC/INTEGRITY validation required; above/below cues and exact line-scroll position are implemented. Runtime TEST REQUIRED.
- **2.7.31 Gold help paging repair:** STATIC/SEMANTIC/INTEGRITY validation required; Gold Select-alone paging now shares native four-line render geometry and visible hints. Runtime TEST REQUIRED.
- **2.7.28 Gen2 title repair:** Gold fresh SETUP/open/back-to-NEW-GAME and existing-save CONTINUE-without-SETUP are user runtime PASS on exact 2.7.28. Silver equivalent paths remain TEST REQUIRED.
- **2.7.27 Phase E #4–6:** STATIC/SEMANTIC/INTEGRITY validation required; hard move safety plus type/category soft weighting are implemented, but exact R/B/Y/G/S runtime determinism remains TEST REQUIRED.
- **2.7.25 release promotion:** STATIC/SEMANTIC/INTEGRITY PASS inherited from exact 2.7.24 plus release-provenance validation. 2.7.25 itself remains RUNTIME TEST REQUIRED until separately exercised.
- **2.7.24 documentation audit + Run History baseline persistence:** Static/Semantic PASS; documentation was reconciled to current shipped contracts and malformed baseline-counter persistence is covered by a pure Release Safety audit. Runtime behavior of ordinary gameplay is unchanged; malformed-save normalization remains Runtime TEST REQUIRED if exercised against a real edited/legacy save.
- **2.7.23 Public Interop context consistency:** Static/Semantic PASS; multi-context compatibility inspection remains Runtime TEST REQUIRED.
- **2.7.22 transaction failure/future-journal hardening:** Static/Semantic PASS; Rare Candy transaction-error propagation and future-journal helper rejection remain Runtime TEST REQUIRED.
- **2.7.21 World critical feedback / encounter profile hoisting:** Static/Semantic PASS; T0 critical messaging and balanced Randomizer apply/info timing remain Runtime TEST REQUIRED.
- **2.7.20 Randomizer diagnostic/presentation consistency:** Static/Semantic PASS; disabled projection audit and learnset-only NUZ STATUS rendering remain Runtime TEST REQUIRED.
- **2.7.19 Stadium provenance precedence/provider identity:** Static/Semantic PASS; Stadium import + deterministic gift/trade species and multi-provider runtime smoke remain TEST REQUIRED.
- **2.7.18 acquisition/receipt/Run History API hardening:** Static/Semantic PASS; provider decision-handoff, receipt-collision, and future-history public-read runtime smoke remain TEST REQUIRED.
- **2.7.17 persistence-integrity repairs:** Static/Semantic PASS; forced interruption/rejected-write progression and death-archive recovery remain Runtime TEST REQUIRED.
- **2.7.16 title/status integration fixes:** Static/Semantic PASS; Save Editor title isolation, R/B/Y N/A, Gold active adapter, and master-OFF World Building status remain Runtime TEST REQUIRED.
- **2.7.15 installer/transaction/migration integrity:** Static/Semantic PASS; Save Editor health, future-journal, and rejected-write migration runtime smoke remain TEST REQUIRED.
- **2.7.14 Run History/NZR6 integrity:** Static/Semantic PASS; malformed/future-history and malformed-code runtime smoke remains TEST REQUIRED.
- **2.7.13 World Building/Randomizer lifecycle fixes:** Static/Semantic PASS; master-OFF World Building and early-lifecycle disabled-Randomizer runtime smoke remain TEST REQUIRED.
- **2.7.12 optional UI lifecycle hardening:** Static/Semantic PASS; provider reload/replacement runtime smoke remains TEST REQUIRED.
- **2.7.11 acquisition/Stadium interaction fixes:** Static/Semantic PASS; final-slot progression catch and Stadium-provider combinations remain Runtime TEST REQUIRED.
- **2.7.10:** Governance/documentation-only; no runtime behavior changed from 2.7.9.
- **2.7.9 transaction verification / Forgiveness history reconciliation:** Static/Semantic PASS; forced interruption/recovery remains Runtime TEST REQUIRED.
- **2.7.8 installer/feature-health consistency:** Static/Semantic PASS; cross-edition runtime diagnostic smoke remains TEST REQUIRED.
- **2.7.7 loader/diagnostic/token-normalization repairs:** Static/Semantic PASS; Runtime TEST REQUIRED.
- **2.7.5 compatibility/diagnostic repairs:** Static/Semantic PASS; external-provider reload and denied-source-read runtime smoke remain recommended.
- **2.7.4 Forgiveness transaction / Run History repairs:** Static/Semantic PASS; interruption recovery remains runtime-test-required.
- **2.7.3 progression-PC commit + Stadium provenance repairs:** Static/Semantic PASS; focused runtime tests remain required for progression exception storage and external Stadium importer integrations.
- **2.7.2 classic Randomizer status ownership/info presentation:** Static/Semantic PASS; runtime coexistence presentation smoke TEST REQUIRED.
- **2.7.1 transaction / Release Safety repairs:** STATIC/SEMANTIC PASS — RUNTIME TEST REQUIRED. Existing 2.7.0/2.6.98 runtime evidence remains protected.
- **2.6.96 documentation/header packaging repair:** STATIC/SEMANTIC PASS — RUNTIME RETEST REQUIRED. Release Safety header expectations are restored without changing gameplay.
- **2.6.95 NUZ RULES diagnostic repair:** STATIC/SEMANTIC PASS — RUNTIME RETEST REQUIRED. The rival-sync audit now closes over its intended local helper.
- **2.6.94 Lua unpack audit scope:** STATIC/SEMANTIC PASS — RUNTIME REQUIRED. All shipped Lua modules are now scanned through the authoritative package inventory.


- **Stadium / Crystal 251 compatibility snapshot + explicit Stadium-import provenance v2:** Static/Semantic PASS; combination runtime smoke TEST REQUIRED. Presentation/model imports do not auto-mark Pokémon acquisitions.
- **2.6.92 MOD MANAGER / World Building catalog startup:** RUNTIME FAIL — stale 97-key golden rejected the legitimate 104-key live catalog.
- **2.6.93 catalog repair:** STATIC/SEMANTIC PASS — RUNTIME REQUIRED. Golden refreshed to 104 / 1560 / 926265119 with explicit key-identity drift reporting.

Confidence is tracked on two independent axes:

- **Player/runtime confidence** — does the feature work for normal play on the exact edition/build tested?
- **Provider/API interoperability confidence** — do third-party callers/providers receive the documented semantic contract?

A feature can be strong on one axis and still require testing on the other.

2.6.91 learnset/Rare Candy correctness hardening is **STATIC/HARNESS PASS — RUNTIME REQUIRED**. Learnset drift is now scoped to the three owned move-list fields; Rare Candy partial recovery requires a durable native-effect checkpoint; and Rare Candy attempt IDs use a durable versioned sequence with same-state uniqueness self-test. The 2.6.90 external-randomizer ownership hardening remains **STATIC/HARNESS PASS — RUNTIME REQUIRED**. Named active-feature detection now covers Item Randomizer visible pickups in addition to the existing PokemonRecompRandomizer, Gen 2 Randomizer+, and Kanto Reforged adapters; generic visible Field Item ownership is available through `field_item_randomizer_provider`. Randomizer feature phases remain paused and no algorithm/mapping behavior changed. Exact-edition runtime testing remains deferred. Static/harness evidence covers shared hard-safe candidate resolution, permanent edition/source persistence identity independent of authored item contents, preserved historical Randomizer-v1 field-item seed input, adoption of valid pre-D mappings, authoritative key/HM/progression/story/quest/provider protection, and a seven-case field-item foundation audit. Phase C implementation remains complete through item 11 with its item 12 runtime certification deferred.

## Evidence labels

- **RUNTIME PASS** — observed on the exact build/edition/environment.
- **RUNTIME FAIL** — observed failure on the exact build/edition/environment.
- **STATIC/HARNESS PASS — RUNTIME REQUIRED** — source/compiler/focused harness passes, but no exact runtime claim.
- **PROVIDER PASS** — provider/API behavior exercised through a representative external/public-call path.
- **PROVIDER TEST REQUIRED** — player behavior may be healthy, but public provider semantics are not yet runtime-confirmed.
- **DELEGATED / NOT APPLICABLE** — another owner is authoritative or the feature does not apply.

## Current 2.6.93 touched surfaces

| Surface | Player/runtime | Provider/API interop | Notes |
| --- | --- | --- | --- |
| Random Starter Balance / Trio Typing | STATIC/HARNESS PASS — RUNTIME REQUIRED | N/A | Defaults preserve the v2 starter namespace; BALANCED/AUTO use the v3 starter-only namespace. Exact R/B/Y/G/S starter/rival runtime checks remain required. |
| Starter Rerolls / Starter Info / Yellow dependencies | STATIC/HARNESS PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | Reroll indices are starter-only; public starter information is Compatibility API 30; Yellow non-Pikachu starters receive the narrow Cerulean happiness-gate repair. |
| Random Encounter candidate engine / source identity / order independence | STATIC/HARNESS PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | Canonical source storage is separate from the preserved v1 RNG slot; live encounter work plans are sorted before generation. |
| Encounter repeats / progression-aware balance | STATIC/HARNESS PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | ALLOW/DIVERSE/UNIQUE are group-local; EVO/BALANCED use bounded family-depth/ceiling data and native encounter level without changing table structure. |
| Diversity strength / encounter classes / protected sources | STATIC/HARNESS PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | DIVERSE strength is configurable; Gen 2 methods/time buckets are normalized; explicit static/story/progression-like records are never ordinary wild-table randomization targets. |
| Area Splits × Random Encounters / Encounter Info | STATIC/HARNESS PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | Logical split projection is separated from physical randomizer mapping; Compatibility API 31 exposes spoiler-aware encounter diagnostics without consuming RNG or rewriting mappings. |
| Field Item candidate engine / permanent source identity / progression classification | STATIC/HARNESS PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | Visible pickup candidates use shared hard safety; persistence identity excludes authored item; key/HM/progression/provider-protected items fail closed. |
| Field Item repeats / deterministic placement / visible-hidden ownership | STATIC/HARNESS PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | ALLOW preserves legacy behavior; UNIQUE uses stable native source ordinals within a shared pool; hidden/BG-event sources are not owned. |
| Field Item Gen1/Gen2 normalization / Randomizer Info | STATIC/HARNESS PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | Shared `data.items` is normalized as GEN1_FLAT or GEN2_POCKETS; Compatibility API 32 exposes spoiler-aware read-only diagnostics. |
| External randomizer ownership hardening | STATIC/HARNESS PASS — RUNTIME REQUIRED | COEXISTENCE TEST REQUIRED | Item Randomizer visible-pickup ownership is active-option gated; generic field-item provider delegation and DEV ownership reporting are wired. |
| Random Learnset ownership projection | STATIC/HARNESS PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | Snapshot, applied-state capture, and drift comparison share the same `level1Moves`/`learnset`/`levelMoves` projection; unrelated Pokémon metadata is outside learnset ownership. |
| Rare Candy transaction recovery / attempt identity | STATIC/HARNESS PASS — RUNTIME REQUIRED | N/A | Inventory-only recovery requires a transaction-specific native-effect checkpoint; v2 IDs use a durable monotonic attempt sequence so identical revisited Pokémon state cannot reuse retained receipts. |
| Gameplay transaction coordinator v1 | STATIC/HARNESS PASS — RUNTIME REQUIRED | N/A | In-memory interruption harness proves applied-before-journal, receipt-before-clear, replay suppression, busy-journal semantics, durable payload checkpoints, and monotonic sequence allocation. Exact-engine save/reload interruption testing remains required. |
| SafeInstall v2 | STATIC/SOURCE PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | Existing Gen2 installer calls route through the compatibility alias; explicit false returns now produce diagnostic failure. |
| Hook Registry v1 | STATIC/SOURCE PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | Existing owner-aware wrappers feed owner/previous/wrapper/priority/mode metadata where available. Legitimate interposition remains non-fatal. |
| Feature Health v1 | STATIC/SOURCE PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | Stable ACTIVE/DEGRADED/UNAVAILABLE summary exposed through Dev snapshots/API. |
| Gen1Recomp 0.2.20 engine profile | STATIC/SOURCE PASS — RUNTIME REQUIRED | PROVIDER TEST REQUIRED | 0.2.19→0.2.20: 6 commits / 26 files reviewed. Session teardown is stronger and Gold/Silver gain label-keyed ROM text; no Nuzlocke source migration or Mod API bump is required. Exact-edition runtime smoke remains required. |

## Protected historical runtime evidence

Previously recorded exact-build/edition Runtime PASS evidence remains historical evidence. 2.6.57 adds **transaction/diagnostic harness evidence**, not new runtime evidence. The inherited 2.6.56 engine-source compatibility audit remains source evidence only. The inherited 2.6.55 semantic regression suite remains STATIC/HARNESS evidence: its acquisition/randomizer contract regression suite is STATIC/HARNESS PASS when Release Safety succeeds, while exact-edition gameplay paths still require runtime confirmation before 2.6.55 itself can inherit a fresh Runtime PASS claim.

Important historical protected classes include R/B/Y rule input behavior, selected Yellow/Blue enforcement paths, Silver exact-edition diagnostics, Encounter Tracker reassignment, Gold/Silver Random Starter award behavior, F. TOKEN/UI repairs, exact-edition detection, and previously confirmed battle/item/shop/healing paths.

## Current provider-interop test debt

Highest-value provider tests:

- Kanto Reforged 1.5.3: custom Day Care, held items, fixed statics, Full/Pure spawn ownership, Gold restored content and dual-cap composition.
- The World 6.54.15: dynamic trainers/roles, expanded species/moves, acquisition kinds, weather/status composition and Wonder Trader stability.
- public randomizer policy calls using every canonical value and alias through registration, inline encounter context and learnset policy setters.
- provider acquisitions using `trainer_capture`, `theft`, `owned_capture`, and deliberate neutral/scripted kinds.

## Exact-edition rule

Red, Blue, Yellow, Gold and Silver are five independent runtime-evidence targets. Shared architecture does not automatically transfer Runtime PASS from one exact edition to another.


### 2.6.66 Rare Candy → current cap
- **Status:** Static/Integrity PASS; Runtime Required.
- R/B/Y and Gold/Silver batch paths use the canonical live level-cap resolver and real inventory.
- Every candy is a separate `rare_candy_step` exactly-once transaction; intermediate move/evolution flows are preserved.
- Runtime evidence is still required for finite-cap, insufficient-candy, move-learning, evolution, No Rare Candy, provider-cap, and interruption/reload cases.

## 2.7.56 evidence

Logical-surface policy, wide Gen 1 Rules/Setup/Tracker composition, and the Dev UI Gallery are static/parse validated only. Runtime UI PASS is not claimed for any edition.

- 2.8.36 Gen II Shiny Rate ALWAYS: Crystal RETEST REQUIRED after exact shiny.roll -> mon.shiny handoff verification repair.

## Gen1Recomp 0.2.27 compatibility

- R/B/Y `catch.nickname` integration: **STATIC PASS / RUNTIME REQUIRED**.
- Older-engine nickname fallback and mandatory naming-screen enforcement: **PRESERVED**.
- Gen II NUZ STATUS palette-aware Chrome migration: **STATIC PASS / VISUAL RUNTIME REQUIRED**.
- Gen II Recover Catches palette-aware Chrome migration: **STATIC PASS / VISUAL RUNTIME REQUIRED**.
- Gen II `shiny-flash` safety source revalidation: **STATIC/SOURCE PASS / EXACT-EDITION RUNTIME REQUIRED**.
- 0.2.27 audited profile + diagnostics marker: **STATIC PASS**.
- Overall 0.2.27 source/documentation compatibility review: **PASS**; gameplay/UI runtime certification remains edition-specific and pending.


## 2.8.89 Randomizer method-specific ownership evidence

**STATIC/PARSE PASS — RUNTIME REQUIRED.** A dedicated `TM_LOCATIONS` stream/source map is present; Random TMs and Random TM Locations are distinct controls; the collection-time Field Item path now checks source/method-specific external ownership before applying a Nuzlocke transform; and Item Randomizer visible/hidden source controls no longer globally suppress each other. No Runtime PASS is claimed for the new TM-location behavior or combined-mod ownership.

## 2.8.87 compatibility evidence
External Randomizer ownership expansion is **Source/API Reviewed / Runtime Pending**. No new gameplay Runtime PASS is claimed.


### Bag compatibility
Source-reviewed targets: Useful Bag 2.6.3, Modern Bag UI 0.4.5, and Bag Sort 0.1.0. Nuzlocke composes with presentation/storage/order and enforces item legality by actual item/action rather than pocket position. Combined runtime certification is pending.


### Expanded species compatibility
Expanded species are consumed through final merged species data and the existing species metadata/evolution provider contracts. BST/type/species-ban rules and Randomizer eligibility therefore do not require a hardcoded native-only Pokédex assumption. Dex Overflow 0.1.1 remains a legacy reviewed target; combined expanded-Dex runtime certification is pending.


### Transfer/import provenance
Stadium/Crystal-251 model or ROM import is not Pokémon acquisition. Real external acquisitions must explicitly mark the concrete Pokémon through the public acquisition-provenance surface (or preserve equivalent fields). Unknown imports are not guessed into encounter slots. Gen-II link Pokémon codecs exist upstream, but the full Gen-II trade transaction is not yet a certified Nuzlocke acquisition seam.


### Graveyard Viewer — 2.9.16
- **R/B/Y:** STATIC/SEMANTIC PASS — RUNTIME TEST REQUIRED.
- **Gold/Silver:** STATIC/SEMANTIC PASS — RUNTIME TEST REQUIRED.
- **Crystal:** STATIC/SEMANTIC PASS — RUNTIME TEST REQUIRED.
- Read-only projection over existing death/history state; no Save Schema bump and no Runtime PASS claimed.


### Almanac / Run Recap — 2.9.17
- Evidence: **STATIC/SEMANTIC PASS — RUNTIME TEST REQUIRED**.
- Read-only projection over persisted Run History v2 statistics/summary and the already-recorded Randomizer run snapshot.
- Explicitly labels incomplete legacy/pruned evidence PARTIAL and leaves unavailable individual facts UNKNOWN.
- Does not call RunHistory.ensure() while opening/viewing, so the UI does not trigger history repair/migration writes.
- No Save Schema, Run History format, Randomizer algorithm, compatibility ownership, or gameplay default change.

## End / Abandon Run — 2.9.18
- **STATIC/SEMANTIC PASS — RUNTIME TEST REQUIRED.** Explicit abandonment uses existing Run History v2 `run.abandoned`, defaults destructive confirmation to NO, commits history before disabling challenge enforcement, and cannot manufacture natural completion evidence. Exact-edition runtime certification remains pending.


## 2.9.21 Split-Evolution Dupes
- **STATIC/SEMANTIC PASS — RUNTIME TEST REQUIRED.** Dupes Clause now includes SPLIT mode. Exact species and ancestor/descendant lines remain duplicates; sibling branches after a split remain independently eligible. Live merged/provider evolution rows are used and incomplete custom metadata fails open.


## 2.9.22 Split-Evolution Dupes repair
- **STATIC/SEMANTIC PASS — RUNTIME TEST REQUIRED.**
- Source-confirmed 2.9.21 defect repaired: `dupesMode()` now preserves mode 3 so the SPLIT runtime branch is reachable.
- Main Config marquee now maps mode 3 to SPLIT.
- Release Safety now checks the enum path beyond mere token/branch presence.
- No Runtime PASS is inferred from this repair.

## 2.9.23 Gen1Recomp 0.2.38 launcher compatibility refresh
- 0.2.37/0.2.38 source/documentation/launcher review: **SOURCE/DOC PASS**.
- Manifest compatibility with launcher metadata contract: **STATIC/SEMANTIC PASS**.
- Exact-edition 0.2.38 gameplay/runtime smoke: **TEST REQUIRED**.

- 2.9.72 Gen-II item normalization / Random Shop non-no-op / Random Trainer trace / shiny private-copy repair: **STATIC/SOURCE PASS — runtime retest required**.
