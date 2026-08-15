## 2.2.2 confidence update

**Runtime PASS inherited from Yellow 2.1.24 save-game testing:** No Buying; No Selling; No Center Heal / Pokémon Center healing ban. These enforcement paths are protected and unchanged in 2.2.2.

**Static/parser scope:** compact Trainer Money label only (`Trnr ¥` → `Btl. ¥`). No mechanics changed.

## 2.2.1 confidence update

**Runtime-confirmed defect entering this build:** Gold Setup/NUZ RULES values in 2.1.24 were positioned too close to the right border.

**Static/parser PASS:** the Gold value anchor is moved exactly one native tile left while the ten-tile label field remains intact; no R/B/Y or rule-mechanics path changed.

**Runtime RETEST REQUIRED:** Gold NEW GAME Setup and in-game NUZ RULES with short ON/OFF values plus longer money/type values.

## 2.2.0 confidence update

**Source/static PASS:** Gen1Recomp v0.1.94 tag audit; 10-commit v0.1.93→v0.1.94 comparison; Mod API remains 2; Nuzlocke save schema remains 4; no new permission required. 2.2.0 parser/static validation covers the NUZ INFO exception boundary, classic MOD COMPAT width fitting, NUZ ST. heading rows, Yellow Professor Oak direct-demo skip, and native Bryan rendering path.

**Inherited runtime PASS evidence:** Yellow Setup appears; Type Locke selector visibility works; startup name skip works; PC Heal, Rare Candy, and Vitamin starter loadouts work; native Trainer Card opens; randomized-starter received text names the actual Pokémon; randomized starter is present in party; Trainer Money uses the money symbol.

**Runtime TEST REQUIRED:** Gen1Recomp 0.1.94 boot/new-game/save-load; R/B/Y NUZ INFO with ordinary and randomized starters; MOD COMPAT with and without Gen1 Modern UI; NUZ ST. with and without Gen1 Modern UI; Yellow Professor Oak Pallet capture-demo skip and later Viridian tutorial skip; Bryan's T3 home/fan-club native appearance; T3 dialogue system regressions.

## 2.1.23 confidence delta

- **Confirmed runtime defect entering this build:** repeated stitched/continuation dialogue reports at Mom, Viridian tutorial, Oak's Lab and similar R/B/Y interactions while testing T3.
- **Static/source-audited repair:** Red/Blue and Yellow both route their demonstration through `old_man_demo`; 2.1.23 skips only that command when the NEW GAME option is staged.
- **Static validation:** shared T3 formatter is now used by Nuzlocke-owned world text and T3 ScriptRunner continuation dialogue.
- **Runtime TEST REQUIRED:** actual dialogue appearance, catch-tutorial story completion, and Gold row spacing.

## 2.1.22 runtime confidence

Yellow 2.1.21: NUZ ST. FAIL/crash; MOD COMPAT FAIL/crash. 2.1.22 replaces both R/B/Y custom presentation states with host ListMenu surfaces. Static/parser validation PASS; runtime RETEST REQUIRED. Previously confirmed Yellow Setup/name-skip/startup-resource/native Trainer Card PASS behavior remains protected.

## 2.1.21 runtime confidence update

Gold rule-label/value spacing is static-implemented and parser-validated. Runtime visual confirmation is required in Gold NEW GAME Setup and Gold in-game NUZ RULES. All 2.1.19 Yellow PASS observations and 2.1.20 menu-recovery work remain inherited; this build does not alter those paths.

**2.1.19 candidate / compatibility hardening:** parser/static validation covers generation-neutral kerning install retries, fail-closed Gen1 Modern UI registration, and reload-stable R/B/Y title SETUP dependency refresh/migration. These changes do not alter challenge-rule mechanics. Runtime remains **TEST REQUIRED** for R/B/Y title Setup, save-editor enter/leave in one process, hot reload/mod reload, Gen1 kerning after lifecycle transitions, and Modern UI present/absent/provider-refusal cases. The Yellow 2.1.16 PASS/FAIL evidence and 2.1.18 repair status below remain inherited.

## 2.1.20 runtime confidence update

Yellow 2.1.19 runtime PASS: NEW GAME Setup, Type Locke selector visibility/state presentation, automatic default names, PC Heal startup loadout, PC Rare Candy startup loadout, PC Vitamins startup loadout, and native Trainer Card opening. Yellow 2.1.19 runtime FAIL: entering a Nuzlocke-owned in-game menu can hard-crash. 2.1.20 changes the NUZ RULES and R/B/Y NUZ STATUS guards to defer stack mutation out of draw(); runtime retest is required to identify/confirm any underlying screen-specific exception. Type Locke acquisition enforcement is statically consistent but runtime TEST REQUIRED.

**2.1.18 candidate / Yellow runtime evidence:** 2.1.16 default-name skip PASS; PC Vitamins fresh-save PC grant PASS; opening the Nuzlocke-hijacked Trainer Card FAIL/crash. The 2.1.18 response removes that hijack and uses a standalone `NUZ ST.` status surface; this repair is parser/static PASS and runtime TEST REQUIRED. Generic per-script Nuzlocke message ownership is parser/static PASS and runtime TEST REQUIRED. The bedroom SNES screenshots were source-audited as vanilla Gen1 `cont` scrolling, not duplicate World Building; no upstream dialogue rewrite is claimed. 2.1.17 Game Difficulty and PC Heal Itms remain runtime TEST REQUIRED.

**2.1.16 candidate:** Trilocke, three-selector state normalization, menu relocation, and header micro-tracking are static-implemented. Type Locke legality remains centralized through `typeLockAllowedTypes()` / `typeLockAllowsSpecies()`: OFF produces no type restriction, MONO one active type, DUO two, TRI three. Runtime remains **TEST REQUIRED** on Gold and at least one R/B/Y game, including capture/gift/trade rejection and off-type encounter preservation.

**2.1.15 candidate:** configuration UI/state cleanup. Type Locke OFF now clears/hides both type selectors; MONO keeps Type 1 only. Reversible Rule Lock is restored independently of the WIP Permanent Rule Seal. Section-header centering/bold-like emphasis and left-aligned rule rows are static-implemented; runtime remains **TEST REQUIRED**.

**2.1.14 candidate:** Gold 2.1.12 runtime reproduction confirmed a presentation/state mismatch: Type Locke MONO still showed Type 2. Shared config logic now clears the secondary state and omits Type 2 while MONO is active, covering both R/B/Y and Gold Setup/Rules. Static/parser validation can be claimed after packaging; runtime remains **TEST REQUIRED**.

**2.1.13 candidate:** Yellow/T3 repair paths are parser/static PASS and source-audited; runtime remains TEST REQUIRED. Upstream Gen1Recomp 0.1.93 confirms `pokemon.before_give` precedes `Pokemon.new`; the hook itself is therefore retained. Random Starter now rejects partial concrete species/move records that would be unsafe for `Pokemon.new`/SummaryMenu. Mom response ownership, Pallet TV pagination, and Bryan's real T3 home NPC are RUNTIME TEST REQUIRED. Required Yellow checks: Random Starter OFF → vanilla Pikachu + Party/Summary; Random Starter ON → randomized starter + immediate Party/Summary; blocked Mom heal exactly one response/no heal; allowed Mom heal one-time T3 flavor then vanilla; T3 TV clean pages/no `Rule watch:`; Bryan visible/talkable at home; Setup, NUZ RULES, MOD COMPAT, and Wide Menus classic coexistence regression checks. No runtime PASS is claimed by this entry.

**2.1.12 candidate:** Gym-Leader-only Forgiveness reward logic is parser/static PASS and requires runtime confirmation on R/B/Y and Gold. Verify ordinary Gym Trainers give zero tokens, a Leader gives exactly one, and repeat/rematch paths do not pay again. Localization-safe `Nuz.`, `Dung.`, and `Itms` compact fallbacks are static PASS. Gen1Recomp 0.1.93 remains source-audited; runtime 0.1.93 is still TEST REQUIRED.

**2.1.11 candidate:** localization-safe full/short label selection is parser/static PASS and requires visual testing with English plus at least one translation mod. Gen1Recomp 0.1.93 source audit PASS; runtime 0.1.93 remains TEST REQUIRED. Existing Yellow 0.1.92 Setup/boot, kerning, MOD COMPAT no-crash, Wide Menus classic-coexistence and marquee-cadence evidence remain inherited/protected unless a new regression is observed.

**2.1.10 candidate / Yellow 0.1.92:** marquee cadence runtime-approved. Wide Menus no longer crashes fresh Setup under the 2.1.9 explicit-classic fallback; Nuzlocke remains native-width by design. 2.1.10 compact labels and simplified section headers are presentation-only and parser/static PASS; final visual confirmation is recommended.

**2.1.9 candidate / Yellow 0.1.92:** conditional marquee speed runtime-approved. Wide Menus + fresh Setup remained FAIL/crash in 2.1.8 because opaque mod screens can be auto-widened even without an explicit claim. 2.1.9 explicit classic-layout markers are source/parser/static PASS and require runtime confirmation. Concise core-label changes are presentation-only.

**2.1.8 candidate / Yellow 0.1.92:** presentation-only label refinement on top of the 2.1.7 compatibility fallback. Randomizer abbreviations are static/parser PASS; gameplay semantics are unchanged. Runtime visual confirmation is still recommended for the final rules-screen layout.

**2.1.7 candidate / Yellow 0.1.92:** fresh Setup PASS; Setup-to-game PASS; Gen1 kerning PASS; MOD COMPAT no-crash PASS; Yellow Trainer Card/A:NUZ PASS. 2.1.6 with Wide Menus installed: FAIL/crash. 2.1.6 outline selection: FAIL/presentation. 2.1.7 Wide Menus coexistence fallback and native-cursor selection are parser/static PASS and require runtime confirmation.

**2.1.6 candidate / Yellow 0.1.92:** fresh Setup PASS; Setup-to-game PASS; Gen1 variable-width/kerning PASS; MOD COMPAT crash repair PASS; Yellow Trainer Card/A:NUZ PASS. 2.1.5 conditional overflow logic was runtime-visible but marquee speed and filled selection readability failed presentation review. 2.1.6 slow cadence + outline selection are parser/static PASS and require runtime visual confirmation.

**2.1.5 candidate / Yellow 0.1.92:** fresh Setup PASS; Setup-to-game PASS; Gen1 variable-width/kerning PASS; MOD COMPAT crash repair PASS; Yellow Trainer Card/A:NUZ PASS. 2.1.4 static pixel layout was runtime-visible, but long-label ellipsis was rejected on presentation grounds. 2.1.5 conditional marquee and reverse-video selection are parser/static PASS and require runtime visual confirmation.

**2.1.4 candidate / Yellow 0.1.92:** fresh Setup PASS; Setup-to-game PASS; Gen1 variable-width/kerning PASS; MOD COMPAT crash repair PASS; Yellow Trainer Card/A:NUZ PASS. 2.1.4 pixel-aware rules presentation and MOD COMPAT non-overlap layout are parser/static PASS and require runtime visual confirmation.

**2.1.3 candidate:** Yellow fresh NEW GAME Setup PASS and Setup-to-game boot PASS remain protected. MOD COMPAT repair, active Gen1 kerning, Gym Trainer Forgiveness structured dedup, and invalid-acquisition legality reporting are parser/static PASS and require focused runtime confirmation before promotion.

**2.1.2 Yellow / Gen1Recomp 0.1.92:** fresh NEW GAME Setup PASS; Setup-to-game boot PASS. 2.1.1 MOD COMPAT crash has a static/parser repair in 2.1.2 and requires runtime retest. Gen1 kerning lifecycle retry is parser/static PASS and requires visible runtime confirmation.

**2.1.1 engine compatibility:** Gen1Recomp 0.1.92 source/static review PASS. Manifest/parser checks PASS. 0.1.92 gameplay/runtime remains TEST REQUIRED on user hardware. 0.1.93–0.1.97 are forward-allowed only and must not be represented as runtime PASS before release-specific review.

**2.1.0 version transition:** feature/runtime confidence is inherited unchanged from the former `2.0.0-beta.31.0.4` tree. Renumbering itself introduces no mechanical change.

**31.0.4 Wide Menus:** public-API/static integration PASS for R/B/Y in-game Nuz Rules. Native fallback, fresh Setup exclusion, and Gold exclusion are statically protected. Visual/input behavior with Wide Menus V0.1.0 is RUNTIME TEST REQUIRED.

**31.0.3 Dungeon Lock-In:** static/mock classifier PASS for real Mt. Moon floors vs Mt. Moon-prefixed Pokémon Center/Mart service interiors. User-reported Mt. Moon Center scenario is RUNTIME TEST REQUIRED.

**31.0.2 / Gen1Recomp 0.1.90:** source/static compatibility review PASS. No Nuzlocke gameplay patch required. Gold field-move and save-slot behavior on 0.1.90 remains RUNTIME TEST REQUIRED.

**31.0.1 review-fix note:** parser/static validation covers live difficulty staging, Modern UI generation/lifecycle guards, title Setup save-editor runtime gating, Trainer Rewards required dependency validation, R/B/Y Gym Leader return semantics, and independent leader-field matching. Runtime behavior remains TEST REQUIRED.

**30.1.23 World Building note:** Bryan/Bois Club/home/TV additions are presentation-only and parser/static checked. Exact text dispatch, rotation, Mom dialogue timing, and Pallet TV behavior remain RUNTIME TEST REQUIRED. No achievement or Black Market mechanic is active.

**30.1.22 intelligence note:** Lua parsing/static validation covers expanded MOD COMPAT ownership rows, spoiler-safe tracker provenance tagging, and read-only NUZ INFO legality/provenance. Exact screen spacing, translated labels, provider names, and mixed-mod runtime composition remain TEST REQUIRED. No prior runtime PASS is promoted or invalidated by this static evidence.

**30.1.20 presentation note:** Gen1 variable-width tile-font integration passes Lua parser/static/mock validation, including generation gating and external-provider non-stacking. Exact R/B/Y visual quality, title Setup coverage, mixed font-mod behavior, and Gold no-effect behavior remain RUNTIME TEST REQUIRED. Challenge-rule confidence is unchanged because this delta is presentation-only.

## 2.0.0-beta.30.0.0.10

**Static hardening complete / runtime proof pending:** delegated runtime suppression, dormant preset state, late-bound delegation API, unified external item policy, Acquisition Type Locke/special-acquisition reuse, authoritative AutoCompat save shape, stale-provider cleanup, granular randomizer delegation, Gold No Fishing presentation, and EDITED recovery de-duplication.

**Still specifically unconfirmed:** R/B/Y Skip Catch Demo; passive acquisition timing with real external providers; encounter/learnset randomizer restoration when another provider mutates the same live registry after Nuzlocke's snapshot. Do not promote these to runtime-confirmed PASS without evidence.

# Feature confidence — beta.29.3.13

These percentages express **confidence that the feature behaves as intended in this release**, based on the combination of runtime evidence, behavior/static checks, compile/load history, and how recently the relevant path changed. They are not literal observed success rates.

**29.3.13 hardening note:** targeted static/semantic coverage now includes the confirmed No Catching migration, Trainer Money/master-switch and Gold wallet paths, stable difficulty identity, neutral-default audit, exact/final-composed Dungeon Lock entrance identity, Route Forgiveness master gating, authoritative prize/trade provenance, Gold native NPC-trade pre-mutation gating, Random Type viable-pool selection, World Building de-duplication, and API 26 markers. These changed paths remain TEST REQUIRED in-engine; prior runtime PASS entries are not promoted or downgraded by static evidence.

## Scale

- **99%** — repeated/exact runtime evidence plus strong supporting checks; no known issue in the tested path.
- **95–98%** — exact runtime PASS with strong supporting evidence.
- **90–94%** — runtime evidence exists, but edge cases or exact-current-build coverage are incomplete.
- **80–89%** — strong implementation/automated/shared-path evidence with limited exact runtime.
- **65–79%** — implemented but exact generation-specific runtime testing is still required.
- **1–64%** — partial or known-problem area.
- **0%** — intentionally unsupported/not active on that game.

Runtime failures override compile/static success. A material code change lowers confidence until the changed path is retested.

**Current runtime note:** Yellow in-game collapse glyphs, Running Shoes/QoL placement, First Rival Mercy, and Stronger Trainers next-cap display on both Trainer Card and Encounter Log are runtime PASS on the current development lineage. Blue Random Starter presentation and several Gold menu/provenance paths still require release-build retest.

**Engine-profile note:** beta.29.3.13 inherits the audited Gen1Recomp 0.1.83 profile and protected runtime history from the immediate 29.3.12 parent. This build changes migration, Trainer Money, difficulty identity, Route Forgiveness, Dungeon Lock entrance/final-warp composition, Random Type selection, R/B/Y acquisition provenance, Gold NPC-trade gating/tracking, World Building cap/EXP presentation, and Compatibility API surfaces; those changed paths require current-version runtime validation in R/B/Y and Gold.

## Full matrix

| Area | Feature | Red | Blue | Yellow | Gold | Status | Evidence note |
|---|---|---:|---:|---:|---:|---|---|
| UI | **Fresh-game Setup boot** | 96% | 96% | 99% | 99% | Verified | Blue/Yellow historical fresh startup; current Gold Setup runtime PASS. |
| UI | **Collapsible rule sections** | 90% | 90% | 99% | 99% | Verified | Current Yellow and Gold runtime PASS; native directional glyph polish remains open. |
| UI | **Rule selection/navigation** | 92% | 92% | 99% | 94% | Verified | Current Yellow exact PASS for A/Left/Right selection with Up/Down navigation. |
| Setup | **Nuzlocke Loadouts (CUSTOM/NUZ/HARD/SOLO/IRON)** | 82% | 82% | 86% | 65% | Test Required | beta.29.3.9 restores IRON/IronMON and widens the selector to five choices. Gold exposes the shared loadout control through its separate rule surface. Existing preset behavior is inherited; restored IRON and Gold combinations require runtime validation. |
| Setup | **Permanent Rule Seal** | 82% | 82% | 86% | 78% | Test Required | Irreversible save-level configuration seal is exposed on both backends; rules remain viewable while runtime ledgers continue updating. Exact per-game confirmation/persistence regression is incomplete. |
| Setup | **Save Setup profile** | 91% | 91% | 96% | 92% | Supported | Separate R/B/Y and Gold pre-game profiles are implemented; current Gold Setup runtime is healthy, but exact save/reload profile testing is not complete for every game. |
| UI | **Save Rules** | 92% | 92% | 97% | 90% | Supported | Active-save rule persistence is longstanding; exact Gold save/reopen rule matrix remains incomplete. |
| Recovery | **Recover Catches** | 84% | 84% | 88% | 0% | Test Required | R/B/Y legacy catch-recovery UI exists for unresolved older-save provenance; Gold does not expose this control. |
| Setup | **Starting Money** | 82% | 82% | 86% | 0% | Test Required | Historical Yellow runtime PASS exists, but beta.29.1.0 player testing found untouched fresh-start Money at $0 instead of the intended $3,000. beta.29.2.0 carries the corrected shared R/B/Y seam; exact runtime retest required. Not exposed on Gold. |
| Setup | **Starting Poke Balls** | 90% | 90% | 96% | 0% | Supported | R/B/Y starting-ball handoff/activation has runtime history; not exposed on Gold. |
| Setup | **Starting Rare Candy** | 90% | 90% | 99% | 0% | Verified | Yellow new-game starting Rare Candies runtime PASS; R/B shares setup implementation. Not exposed on Gold. |
| Utility | **Gym Guide Rare Candy** | 94% | 94% | 97% | 0% | Verified | R/B/Y repeatable Gym Guide Rare Candy mechanics were runtime-established in the beta.25/26 line. Not exposed on Gold. |
| UI | **ENC TRACKER** | 95% | 95% | 99% | 94% | Verified | Yellow and Gold runtime history; R/B shared code and older tracker coverage. |
| UI | **R/B/Y Trainer Card NUZ STATUS / Gold status screen** | 94% | 94% | 98% | 86% | Supported | Yellow Trainer Card runtime history; Gold uses separate Start-menu status path. |
| UI/Data | **LOST ENC / DEATH semantics** | 82% | 82% | 86% | 76% | Test Required | beta.29.2.0 writes new death-history rows as `DEAD`, conservatively migrates legacy death rows, and keeps failed encounters in `FAILED` area state. Runtime old-save/new-save verification required. |
| UI | **CATCH INFO** | 93% | 93% | 98% | 80% | Test Required | Yellow current/historical coverage and Gold beta26.6 runtime PASS; Gold PC-routed gift provenance changed in beta.29.0.2 and needs targeted runtime retest. |
| UI | **Gold-native Nuzlocke UI** | 62% | 62% | 65% | 78% | Test Required | beta.29.3.9 moves Gold Setup/Nuz Rules, Tracker, Catch Info, Forgiveness, and Status onto native Gen 2 Chrome without changing R/B/Y screens. Exact Gold runtime presentation remains required. |
| Core | **Nuzlocke master switch** | 95% | 95% | 98% | 88% | Supported | Longstanding shared enforcement; Gold reduced rule surface. |
| Core | **Permadeath** | 84% | 84% | 88% | 70% | Test Required | Ordinary-battle behavior has runtime history. A Misty/Gym Leader report restored a dead Pokémon after battle; beta.29.2.1 adds a post-`onFinish` dead-party prune. Gym Leader, ordinary trainer, Whiteout, temporary-party, heal, and save/reload regression tests are required. |
| Core | **First Rival Mercy** | 88% | 88% | 92% | 70% | Test Required | beta.29.0.2 removed inert persisted telemetry while preserving the established one-shot/battle-local gate; targeted regression runtime is required after touching this path. |
| Core | **One Per Area** | 96% | 96% | 99% | 78% | Test Required | Yellow catch/encounter tracking runtime PASS; Gold PC-routed scripted-gift area consumption was fixed in beta.29.0.2 and needs runtime confirmation. |
| Core | **Failed Encounters** | 94% | 94% | 99% | 80% | Supported | Yellow failed Route 2 runtime PASS; Gold exact edge cases still open. |
| Core | **Nickname Rule** | 92% | 92% | 97% | 72% | Test Required | Live nickname enforcement has runtime history, but beta.29.2.0 changes post-naming history synchronization on R/B/Y and Gold and adds boxed-gift handling; targeted runtime retest required. |
| Clauses | **Dupes Clause** | 91% | 91% | 95% | 78% | Test Required | Shared merged evolution/species logic; exact current Gold combinations need runtime. |
| Clauses | **Shiny Clause** | 96% | 96% | 99% | 82% | Supported | Yellow pre-Ball Shiny ON/OFF route-preservation PASS; Gold exact combinations less tested. |
| Variants | **Type Locke (Mono/Duo)** | 65% | 65% | 68% | 62% | Test Required | beta.29.3.10: live species/provider type lookup, hard off-type catch/gift/trade policy, free off-type failed-encounter accounting, type-aware Random Starter candidate filtering, and Gold rule/UI exposure. Runtime matrix still required. |
| Cosmetic | **Pokemon Bois Club** | 72% | 74% | 70% | 68% | Test Required | beta.29.3.11: Tier 3-only Vermilion Fan Club cosmetic rebrand, Bryan-the-Boi chairman tribute sprite, and safe dialogue/sign presentation in R/B/Y and Gold. Validate that story flags, gifts, and lower-tier fallback presentation remain untouched. |
| General | **No Day Care** | 68% | 68% | 70% | 66% | Test Required | beta.29.3.10 carry-forward: R/B/Y empty-Day-Care conversation gate and Gold `Breeding.canDeposit` gate preserve existing withdrawals/state. Runtime deposit/retrieve tests still required. |
| Area | **Route 2 / 10 / 20 Splits** | 86% | 86% | 90% | 0% | Supported | R/B/Y independently selectable common route splits with reversible projection and legacy blanket-split migration; runtime migration regression still required. |
| Area | **Mt Moon Splits** | 84% | 84% | 88% | 0% | Supported | R/B/Y implemented; dedicated current runtime coverage limited. |
| Area | **Safari Splits** | 84% | 84% | 88% | 0% | Supported | R/B/Y implemented; dedicated current runtime coverage limited. |
| Starter | **Random Starter** | 84% | 84% | 86% | 74% | Test Required | Implementation/smoke coverage; exact per-game runtime matrix remains incomplete. |
| General | **Overworld** | 90% | 90% | 94% | 0% | Supported | R/B/Y acquisition classification path; not exposed on Gold beta rule surface. |
| General | **Town Catches** | 90% | 90% | 94% | 0% | Supported | R/B/Y path including starter exception; not exposed on Gold beta rule surface. |
| General | **No Legendaries** | 88% | 88% | 91% | 0% | Supported | Merged/provider-backed classification; not exposed on Gold beta rule surface. |
| General | **No Mythicals** | 88% | 88% | 91% | 0% | Supported | Merged/provider-backed classification; not exposed on Gold beta rule surface. |
| General | **No Pseudos** | 82% | 82% | 85% | 0% | Test Required | Added beta.28.10; representative acquisition runtime matrix still needed. |
| General | **Player Stat EXP** | 82% | 82% | 84% | 68% | Test Required | Compiled/structurally repaired and numeric bug fixed; representative runtime values still needed. |
| General | **Wild Stat EXP** | 82% | 82% | 84% | 68% | Test Required | Compiled/structurally repaired and numeric bug fixed; representative runtime values still needed. |
| General | **Trainer Stat EXP** | 82% | 82% | 84% | 68% | Test Required | Compiled/structurally repaired and numeric bug fixed; representative runtime values still needed. |
| General | **No Stat EXP Gain** | 80% | 80% | 82% | 67% | Test Required | Pre-mutation/award safeguards exist; battle/vitamin runtime matrix remains open. |
| General | **Perfect Player IVs/DVs** | 82% | 82% | 84% | 68% | Test Required | Creation-only implementation; exact runtime combinations remain open. |
| General | **Perfect Wild IVs/DVs** | 82% | 82% | 84% | 68% | Test Required | Creation-only implementation; exact runtime combinations remain open. |
| General | **Perfect Trainer IVs/DVs** | 82% | 82% | 84% | 68% | Test Required | Creation-only implementation; exact runtime combinations remain open. |
| General | **No Static** | 84% | 84% | 87% | 68% | Test Required | beta.29.2.0 hardens the one-shot scripted-static lifecycle; genuine static and intervening-trainer/ordinary-wild regressions need runtime confirmation. |
| General | **No Gambling** | 86% | 86% | 89% | 72% | Test Required | Pre-mutation transaction adapters; Gold exact runtime still required. |
| General | **Maximum BST** | 82% | 82% | 84% | 70% | Test Required | Numeric handling fixed in beta.28.15; representative values/acquisition paths still need runtime. |
| General | **Allow Glitches** | 84% | 84% | 86% | 68% | Test Required | Conservative classification and fail-open safety; exact current gameplay matrix limited. |
| General | **Gift Pokemon** | 90% | 90% | 94% | 0% | Supported | R/B/Y gift/recovery paths; Gold ordinary gift behavior exists internally but the rule is not exposed on Gold beta rule surface. |
| General | **In-Game Trades** | 88% | 88% | 92% | 0% | Supported | R/B/Y version-specific trade tracking; not exposed on Gold beta rule surface. |
| General | **Wonderlocke WIP** | 0% | 0% | 0% | 0% | Unsupported | Reserved/dormant by design; not active gameplay. |
| Battle | **Level Cap Scope** | 94% | 94% | 98% | 76% | Test Required | Next-cap display/runtime evidence R/B/Y; live boss/provider architecture; full Gold progression remains open. |
| Battle | **No Healing Items** | 94% | 94% | 97% | 0% | Verified | Historical runtime PASS on R/B/Y; not exposed on Gold beta rule surface. |
| Battle | **No X Items** | 95% | 95% | 97% | 0% | Verified | Runtime PASS in beta.25-era R/B/Y; not exposed on Gold beta rule surface. |
| Battle | **No Escape** | 95% | 95% | 97% | 78% | Supported | Established R/B/Y runtime PASS; Gold supported path remains test-required. |
| Battle | **No Catching** | 88% | 88% | 91% | 73% | Test Required | Semantic capture restriction replaced the retired Ball-ban tiers; custom-Ball/capture-provider and exact per-game runtime matrix remain incomplete. |
| Field | **No Repels** | 97% | 97% | 97% | 74% | Verified | R/B/Y runtime PASS across Repel/Super/Max; Gold field-Pack path requires exact runtime. |
| Field | **No Escape Rope** | 90% | 90% | 93% | 72% | Test Required | R/B/Y field-item framework established; Gold exact runtime needed. |
| Field | **No Field Heal** | 96% | 96% | 98% | 72% | Verified | Blue and Yellow runtime evidence; Gold exact runtime needed. |
| Field | **No PP Items** | 94% | 94% | 96% | 72% | Supported | Historical R/B/Y runtime PASS and expanded PP coverage; Gold exact runtime needed. |
| Field | **No TMs** | 90% | 90% | 99% | 74% | Verified | Yellow Save Editor-modified existing save PASS after full restart; R/B shared path, Gold exact runtime needed. |
| Field | **No Rare Candy** | 90% | 90% | 99% | 74% | Verified | Yellow Save Editor-modified existing save PASS after full restart; R/B shared path, Gold exact runtime needed. |
| Challenge | **No Buying** | 99% | 99% | 99% | 70% | Verified | Existing Red/Blue and fresh Yellow runtime PASS; Gold Mart adapter still test-required. |
| Challenge | **No Selling** | 99% | 99% | 99% | 70% | Verified | Existing Red/Blue and fresh Yellow runtime PASS; Gold Mart adapter still test-required. |
| Challenge | **No Center Heal** | 94% | 94% | 99% | 0% | Verified | Yellow runtime PASS and earlier shared evidence; not exposed on Gold beta rule surface. |
| Challenge | **No Mom Heal** | 92% | 92% | 99% | 0% | Verified | Yellow dialogue/heal runtime PASS; not exposed on Gold beta rule surface. |
| Challenge | **Whiteout** | 86% | 86% | 90% | 72% | Test Required | Teardown and temporary-party hardening exist; destructive exact current runtime remains important, especially Gold. |
| Challenge | **Solo Only** | 86% | 86% | 89% | 0% | Supported | R/B/Y enforcement architecture; not exposed on Gold beta rule surface. |
| World | **World Building** | 88% | 88% | 94% | 55% | Test Required | R/B/Y retain prior evidence. beta.29.3.9 adds the shared tiered catalogue and exposes Johto/Gold flavor; Gold presentation requires runtime validation. |
| World | **Gym Lock-In** | 72% | 72% | 74% | 62% | Test Required | beta.29.2.2 gates supported Gym exits through the shared warp destination seam and unlocks from leader progression. R/B/Y and Gold runtime alias/progression validation required. |
| World | **Dungeon Lock-In** | 70% | 70% | 72% | 60% | Test Required | beta.29.2.2 tracks the entry side for a conservative multi-exit dungeon set, blocks entry-side retreat plus Escape Rope/Dig/Teleport/Fly while active, allows a different legitimate exit, and fails open when entry provenance is unavailable. |
| QoL | **Default Names** | 90% | 90% | 92% | 88% | Supported | Player/Rival name skip has runtime PASS evidence; exact game of the latest pass is not preserved. |
| QoL | **Skip Catch Demo** | 0% | 0% | 0% | 75% | Test Required | Gold-only implementation; dedicated current runtime confirmation still needed. |
| UI | **Area Guide** | 93% | 93% | 97% | 90% | Supported | Tracker/map architecture with Yellow/Gold runtime evidence. |
| QoL | **B-Button Run** | 86% | 86% | 88% | 76% | Test Required | Generation-aware movement gates; exact current runtime matrix incomplete. |
| Compatibility | **Save Editor loader isolation** | 94% | 94% | 98% | 84% | Supported | Yellow full-restart recovery evidence; architecture explicitly isolates editor runtime patches. |
| Compatibility | **Temporary-party Permadeath/Whiteout reconciliation** | 84% | 84% | 86% | 80% | Test Required | beta.28.20 static/code hardening; targeted runtime with temporary-party systems remains open. |

## Current highest-priority confidence gaps

- beta.29.0.2 reviewed-fix regressions carried into beta.29.2.0 unchanged: First Rival Mercy, scripted gift/starter history nickname synchronization, Gold full-party/PC-routed gifts, and scripted-static provenance across an intervening trainer battle.
- Maximum BST and all Stat EXP/DV controls need representative numeric runtime tests after the beta.28.15 numeric-rule correction.
- Destructive Whiteout paths need disposable-save runtime coverage on the current code, especially Gold.
- Gold field/item/shop/nickname paths marked TEST REQUIRED should be exercised individually before their scores are promoted.
- Temporary-party Permadeath/Whiteout reconciliation needs an exact runtime combination that narrows/reorders and restores the party.
- UI-theme composition remains a known issue even though the underlying Nuzlocke screens function.

## Evidence carried into this candidate

- Current: Gold NEW GAME reaches Nuzlocke Setup; collapsible Setup sections work.
- Current: Yellow existing-save rule selection uses A/Left/Right without consuming Up/Down navigation; collapsible sections work.
- Historical/current: Yellow rules/tracker/catch behavior, failed encounter tracking, next-cap displays, fresh shops, Mom/Center behavior, starter nickname, starter Catch Info, and several early-game flows have runtime PASS evidence.
- Historical: Red/Blue shop behavior, Blue field healing, Red Gym Guide, R/B/Y startup, and multiple battle/field-item restrictions have runtime PASS evidence.
- Save Editor follow-up: Yellow No TMs and No Rare Candy passed after fully closing/reopening Gen1Recomp.

## History-recovery evidence note

Preserved source/packages and runtime evidence were reconciled during the beta.29.2.0 documentation pass. Existing evidence—including Gold Setup/collapsible sections, Yellow existing-save controls, Save Editor restart behavior, and Default Names—was cross-checked against retained development records. Where an exact build under test could not be proven, the evidence remains in this ledger rather than being assigned to a guessed changelog version.

## beta.29.2.2 lock-in confidence

- **Gym Lock-In:** source/static implemented for R/B/Y and Gold through the shared `warp.destination` hook; **TEST REQUIRED** for live exit rejection, post-Leader unlock, and map aliases.
- **Dungeon Lock-In:** source/static implemented for a conservative multi-exit family set; **TEST REQUIRED** for entry-side rejection, alternate-exit release, Escape Rope/Dig/Teleport/Fly rejection, and older-save fail-open behavior.
- **Nested trainer-roster cap discovery:** source/static implemented; **TEST REQUIRED** against an actual trainer-content modification before compatibility confidence increases.


## 2.0.0-beta.29.3.3 TEST REQUIRED
- Route Forgiveness starting states, Gym Trainer one-time awards, and failed-encounter spending.
- Trainer Money scaling across R/B/Y and Gold and with trainer/economy mods.
- Permanent Rule Seal confirmation and monotonic persistence.
- Revised NUZLOCKE/HARDCORE defaults.
- Forgiveness Token 1,000,000 shop-price integration contract.


## 2.0.0-beta.29.3.10 — Type Locke + No Day Care static pass

- Source/static review confirms the new rules are registered on the shared rule surface and Gold beta surface.
- World Building catalogue coverage includes Type Locke mode, both selected types, and No Day Care.
- Type Locke is wired into native capture policy, Failed Encounter accounting, gift/trade acquisition policy, Random Starter candidate selection, R/B/Y and Gold value labels, and Gold status summary.
- No Day Care uses generation-specific non-destructive deposit gates.
- **Runtime status: TEST REQUIRED.**

## 2.0.0-beta.29.3.5 — Gold compatibility smoke pass

- Rolled directly from 2.0.0-beta.29.3.4; no repository files added or removed.
- Static smoke audit rechecked Gold-specific capture, nickname, Mart, field-item, catch-tutorial, gift, static, gambling, Whiteout, egg, roamer, and Nuz Status adapters.
- Gold adapters remain generation-scoped and fail-open when an upstream seam is unavailable.
- Route Forgiveness and No Catching remain TEST REQUIRED on Gold pending runtime validation.
- Existing R/B/Y runtime-PASS behavior was not intentionally changed.


## 2.0.0-beta.29.3.8 — World Building parity + cleanup

- R/B/Y World Building keeps its prior evidence; the centralized presenter is a code-path change and should receive regression attention where it now owns messages.
- Gold World Building is newly exposed and remains TEST REQUIRED.
- IronMON loadout restoration is TEST REQUIRED.
- Removal of retired Ball-tier helpers does not remove the one-time legacy migration read.

## 29.3.14 TEST REQUIRED
Gold START-menu overflow, Gold Mart No Buying/No Selling, Random Starter preview/commit, Elm portrait/cry, and starter provenance are changed and require runtime retest. Existing Yellow 29.3.12 No Buying/No Selling, No Rare Candy, overworld Potion, and No TMs PASS results remain protected.

## 29.3.15 TEST REQUIRED
Rule-menu placement, Skip Cherrygrove Tour, and revised item-specific World Building text require runtime validation. The underlying Yellow No Rare Candy / field Potion / No TMs enforcement PASS evidence remains protected.

## 29.3.16 TEST REQUIRED
NUZ INFO Catch/Stat/Move page rendering and controls require runtime validation in R/B/Y and Gold. API 27 structure is statically validated but external composition is TEST REQUIRED.

## beta.30.0.0.1 additions
| Feature | Static confidence | Runtime status |
|---|---|---|
| Random Encounters | Implemented / smoke-testable | TEST REQUIRED |
| Random Learnsets | Implemented / smoke-testable | TEST REQUIRED |
| Learnset Gen AUTO/GEN1/GEN2 | Implemented / registry-bounded | TEST REQUIRED |

## 2.0.0-beta.30.0.0.2
| No Fishing — R/B/Y + Gold | Implemented through shared item-use policy | TEST REQUIRED |

## 2.0.0-beta.30.0.0.3
| Interop API v1 | Implemented / static reviewed | TEST REQUIRED |
| FAFF0x capability-first foundation | Implemented | TEST REQUIRED |
| Alternate item UI policy seam | Implemented | TEST REQUIRED |
| Acquisition provider seam | Implemented | TEST REQUIRED |
| Effective registry + change notification | Implemented | TEST REQUIRED |
| EXP provider composition seam | Foundation only | TEST REQUIRED |

## 2.0.0-beta.30.0.0.4
| FAFF0x QoL interop layer | Static implemented | TEST REQUIRED |
| Alternate item UI enforcement API | Static implemented | TEST REQUIRED |
| DexNav/Summon acquisition API | Static implemented | TEST REQUIRED |
| Advanced Box PC policy API | Static implemented | TEST REQUIRED |
| Registry revision/consumer API | Static implemented | TEST REQUIRED |
| EXP provider cap-discovery API | Static implemented | TEST REQUIRED |

## 2.0.0-beta.30.0.0.5
| Yellow Encounter Tracker REMOVE ENTRY crash repair | Root cause identified; narrow serialization fix implemented | RETEST REQUIRED |

## 2.0.0-beta.30.0.0.6
| FAFF0x quest/content provider API | Static implemented | TEST REQUIRED |
| Dynamic quest areas → Encounter Tracker | Static implemented | TEST REQUIRED |
| Provider dungeons → Dungeon Lock-In | Static implemented | TEST REQUIRED |
| Quest gift/scripted encounter metadata | Static implemented | TEST REQUIRED |
| Randomizer story-content opt-out | Static implemented | TEST REQUIRED |

## 2.0.0-beta.30.0.0.7
| FAFF0x automatic/legacy adapter | Static implemented | TEST REQUIRED |
| Active-mod capability scan | Static implemented | TEST REQUIRED |
| Passive external acquisition detection | Static implemented / non-destructive | TEST REQUIRED |
| Alternate item/encounter/PC adapter gates | Static implemented | TEST REQUIRED |

## 2.0.0-beta.30.0.0.8
| Compatibility capability consolidation | Static implemented | TEST REQUIRED |
| Explicit-provider precedence | Static implemented | TEST REQUIRED |
| Legacy capability aliases | Preserved | TEST REQUIRED |
| Yellow tracker REMOVE ENTRY repair | Preserved from 30.0.0.5 | RETEST REQUIRED |

## 2.0.0-beta.30.0.0.9
| External-provider grey/lock UI | Static implemented | TEST REQUIRED |
| Provider identification in hover/help text | Static implemented | TEST REQUIRED |
| Effective-OFF dormant preference behavior | Static implemented | TEST REQUIRED |
| Core-rule non-delegation invariant | Static implemented | TEST REQUIRED |
| Yellow tracker REMOVE ENTRY repair | Preserved | RETEST REQUIRED |

## 2.0.0-beta.30.0.0.11
| Gen1Recomp 0.1.84 loader compatibility | Manifest/API static update | RUNTIME TEST REQUIRED |
| 30.0.0.10 gameplay/compatibility state | Preserved unchanged | Existing confidence statuses preserved |

## 2.0.0-beta.30.0.0.12
| Future Gen1Recomp 0.x loader acceptance | Manifest family range `>=0.1.81 <1.0.0` | STATIC POLICY; each new engine still needs runtime validation |
| Gen1Recomp 1.0+ | Deliberately blocked | COMPATIBILITY REVIEW REQUIRED |

## 2.0.0-beta.30.0.0.13
| Fresh Blue Nuzlocke SETUP on Gen1Recomp 0.1.86 | Compatibility fallback implemented | RETEST REQUIRED |
| Fresh Gold Nuzlocke SETUP on Gen1Recomp 0.1.86 | Compatibility fallback implemented | RETEST REQUIRED |
| Existing-save SETUP hidden behavior | Preserved by explicit CONTINUE/save checks | PROTECTED; RETEST |
| Public `ui.title_menu.items` integration | Preserved as primary path | UPSTREAM 0.1.86 seam confirmed |

## 2.0.0-beta.30.0.0.14
| Mod load after 30.0.0.13 title fallback | Structural parser-limit fix applied in 30.0.0.14 | RETEST REQUIRED |
| Fresh Blue SETUP | Same fallback logic as 30.0.0.13, now parser-safe | RETEST REQUIRED |
| Fresh Gold SETUP | Same fallback logic as 30.0.0.13, now parser-safe | RETEST REQUIRED |

## 2.0.0-beta.30.0.0.15
| 30.0.0.14 ambiguous-syntax load failure | Removed IIFE; adapter extracted to sandbox-loaded module | STATIC FIX; RETEST REQUIRED |
| Multi-file module loading | Uses upstream-documented `load(mod:read(...))` pattern | STATICALLY ALIGNED; RUNTIME TEST REQUIRED |
| Fresh Blue SETUP | Extracted fallback | RETEST REQUIRED |
| Fresh Gold SETUP | Extracted fallback | RETEST REQUIRED |
| Core rules / saves / encounters / battles | No intentional logic change | REGRESSION SMOKE TEST |
| Tracker / randomizers / provider compatibility | No intentional logic change | REGRESSION SMOKE TEST |

## 2.0.0-beta.30.0.0.16
| `main.lua` compilation | 200-local overflow addressed by approved trainer-reward extraction | STATIC PARSER PASS; RUNTIME LOAD REQUIRED |
| `title_setup_compat.lua` compilation | First approved module | STATIC PARSER PASS; RUNTIME RETEST |
| `trainer_rewards.lua` compilation | Second approved module | STATIC PARSER PASS; RUNTIME RETEST |
| Trainer Money / provider wallets | Module boundary changed | RETEST REQUIRED |
| Forgiveness Tokens / Mart Bag bridge / Gym awards | Module boundary changed | RETEST REQUIRED |
| Gym/E4/Champion progression / cap reporting | Module boundary changed | RETEST REQUIRED |
| Core rules / encounters / faint handling | No intentional logic change | REGRESSION SMOKE TEST |
| Tracker / randomizers / provider policy / Gold gameplay | No intentional logic change | REGRESSION SMOKE TEST |

| Late runtime lexical-scope move | No intended behavioral change; compiler-pressure safeguard | STATIC PARSER PASS; REGRESSION SMOKE TEST |

## 2.0.0-beta.30.0.0.17
| Yellow existing-save boot on 30.0.0.16 | Runtime PASS |
| Yellow Nuzlocke menu visibility on 30.0.0.16 | Runtime PASS |
| Yellow in-game Nuz Rules open on 30.0.0.16 | Runtime PASS |
| Permanent Rule Seal irreversibility | Runtime observed as working/intended |
| Two-warning seal activation safety | Implemented in 30.0.0.17 | RETEST REQUIRED |
| Seal confirmation cancellation/debounce | Implemented in 30.0.0.17 | RETEST REQUIRED |

## 2.0.0-beta.30.0.0.18
| Yellow Permanent Rule Seal challenge-rule lock scope (.17) | Runtime PASS |
| QoL / World Building / UI remain editable after seal (.17) | Runtime PASS |
| Permanent seal reload persistence (.17) | Runtime FAIL |
| Immediate `mod.storage` permanent-seal mirror (.18) | STATIC IMPLEMENTED; RETEST REQUIRED |
| Older permanent-seal migration to storage (.18) | STATIC IMPLEMENTED; RETEST REQUIRED |

## 2.0.0-beta.30.0.0.19
| Permanent Rule Seal UI (.19) | Grey/unselectable WIP placeholder | STATIC IMPLEMENTED; UI RETEST |
| Permanent Rule Seal enforcement (.19) | Suspended while WIP | STATIC IMPLEMENTED; RETEST |
| Existing `.17/.18` seal markers | Preserved, not enforced | STATIC IMPLEMENTED |
| Dormant seal recovery | Implementation retained in `main.lua` + recovery map | DOCUMENTED |
| Other rules after old test seal | Expected editable while WIP | RETEST REQUIRED |

## 2.0.0-beta.30.0.0.20
| Yellow recurring dialogue page overlap / repeated phrases | Reproduced again on 30.0.0.16 | RUNTIME FAIL; `.20` RETEST REQUIRED |
| Optional World Building while vanilla TextBox active | Now suppressed | STATIC IMPLEMENTED; RETEST REQUIRED |
| Mechanical rule enforcement | No intentional change | PROTECTED / SMOKE TEST |
| Yellow NUZ vertical position | Too low | KNOWN DEFERRED COSMETIC ISSUE |

## 2.0.0-beta.30.0.0.21
| Trainer Money `%` labels across Rules/status | Shared presentation table | STATIC PASS; UI RETEST |
| Stat EXP `%` labels | Existing shared labels preserved | PROTECTED / SMOKE TEST |
| Maximum BST preset selector | OFF/400/450/500/550 | STATIC PASS; UI RETEST |
| Maximum BST enforcement/API actual threshold | Preserved | STATIC PASS; ACQUISITION RETEST |
| Legacy custom Maximum BST values | Preserved until changed | STATIC PASS; RETEST |

## 2.0.0-beta.30.1.0 confidence update

| Feature/path | Status |
|---|---|
| Yellow existing-save boot | **RUNTIME PASS** |
| Yellow Nuzlocke menu visibility | **RUNTIME PASS** |
| Yellow in-game Nuz Rules open | **RUNTIME PASS** |
| Yellow tested Gym Lock-In boundary rejection | **RUNTIME PASS — PROTECTED** |
| Yellow specific Poké Mart duplicate-dialogue regression case | **RUNTIME PASS on latest tested build** |
| Active-TextBox World Building guard | **RUNTIME SUPPORTED by tested regression case — PROTECTED** |
| Permanent Rule Seal | **WIP / grey / unselectable** |
| Maximum BST OFF/400/450/500/550 selector | **STATIC PASS; UI/acquisition RETEST** |
| Trainer Money `%` presentation | **STATIC PASS; UI RETEST** |
| Yellow `NUZ` vertical placement | **KNOWN DEFERRED COSMETIC ISSUE** |
| Blue/Gold fresh-game SETUP | **TEST REQUIRED unless separately runtime-confirmed** |
| Trainer reward module paths | **TEST REQUIRED unless separately runtime-confirmed** |

## 2.0.0-beta.30.1.1 confidence update

| Feature/path | Status |
|---|---|
| Gold NEW GAME -> SETUP on 30.1.0 | **RUNTIME FAIL — CRASH** |
| Gold newer `MainMenu:buildList()` fallback | **DISABLED / DORMANT** |
| Gold shared title hook + `MainMenu:choose()` path | **RESTORED AS SOLE GOLD SETUP PATH; RETEST REQUIRED** |
| Disabled Gold fallback recovery code | **PRESERVED IN COMMENTS** |
| R/B/Y title compatibility fallback | **UNCHANGED** |
| Other Gold gameplay systems | **NO INTENTIONAL CHANGE** |
| Yellow runtime PASS evidence from 30.1.0 promotion docs | **PRESERVED** |

## 2.0.0-beta.30.1.2 confidence update

| Feature/path | Status |
|---|---|
| Gold fresh NEW GAME -> SETUP selection | **KNOWN RUNTIME FAIL — CRASH** |
| Gold title SETUP row visibility | Observed, but selection path broken |
| Disabled Gold `buildList()` fallback | Dormant/preserved; disabling did not fix crash |
| Gold overall support | **BETA / EXPERIMENTAL** |
| Yellow existing-save boot | **RUNTIME PASS** |
| Yellow Nuzlocke menus visible | **RUNTIME PASS** |
| Yellow in-game Nuz Rules | **RUNTIME PASS** |
| Yellow tested Gym Lock-In boundary rejection | **RUNTIME PASS — PROTECTED** |
| Yellow tested duplicate-dialogue NPC after guard | **RUNTIME PASS** |
| Active-TextBox World Building guard | **PROTECTED PRESENTATION SAFEGUARD** |
| Permanent Rule Seal | **WIP / UNSELECTABLE** |
| Yellow `NUZ` vertical position | **KNOWN DEFERRED COSMETIC ISSUE** |

## 2.0.0-beta.30.1.3

| Path | Status |
|---|---|
| Yellow/Gold Setup current engine | **RUNTIME FAIL before .13; RETEST** |
| Unsplit 29.3.0 Setup current engine | **RUNTIME FAIL** |
| Guarded config-screen push | **STATIC PASS; RUNTIME RETEST** |
| Visible underlying Setup error | **STATIC PASS; RUNTIME RETEST** |
| Existing Lua split as crash cause | **UNCONFIRMED / evidence against simple attribution** |
| Main chunk local-variable headroom | **CONFIRMED EXHAUSTED (200-local ceiling)** |
| Additional Lua split | **NEEDED FOR HEADROOM, DEFERRED PENDING DIAGNOSTIC** |

## 2.0.0-beta.30.1.4

| Path | Status |
|---|---|
| Config screen construction guard | Runtime did not catch CTD |
| Config screen update guard | STATIC PASS; RUNTIME RETEST |
| Config screen draw guard | STATIC PASS; RUNTIME RETEST |
| Lua split as root cause | STILL UNCONFIRMED |
| Setup current engine | RUNTIME FAIL; phase isolation ongoing |

## 2.0.0-beta.30.1.5

| Path | Status |
|---|---|
| Legacy blocked filesystem use in fresh Setup | **REMOVED / STATIC PASS** |
| Yellow fresh NEW GAME -> SETUP | **RETEST REQUIRED** |
| Gold fresh NEW GAME -> SETUP | **RETEST REQUIRED** |
| Setup profile within current process | **STATIC PASS** |
| Setup profile after full application restart | **TEMPORARILY NOT PERSISTED** |
| Existing-save Nuz Rules | Prior Yellow runtime PASS; smoke test |
| Additional Lua split | Not part of this repair |

## 2.0.0-beta.30.1.6

| Feature/path | Status |
|---|---|
| Gold fresh NEW GAME -> SETUP | **RUNTIME PASS** |
| Yellow fresh NEW GAME -> SETUP | **RUNTIME PASS** |
| Blue fresh NEW GAME -> bedroom | **RUNTIME PASS** |
| Legacy blocked filesystem use in fresh Setup | **REMOVED / REPAIR RUNTIME VALIDATED** |
| Setup profile during current application session | **RUNTIME-SUPPORTED PATH** |
| Setup profile after full application restart | **TEMPORARILY NOT PERSISTED** |
| Yellow existing-save boot | **RUNTIME PASS** |
| Yellow Nuzlocke menus visible | **RUNTIME PASS** |
| Yellow in-game Nuz Rules | **RUNTIME PASS** |
| Yellow tested Gym Lock-In boundary rejection | **RUNTIME PASS — PROTECTED** |
| Yellow tested duplicate-dialogue NPC after guard | **RUNTIME PASS — PROTECTED CASE** |
| Permanent Rule Seal | **WIP / UNSELECTABLE** |
| Yellow `NUZ` vertical position | **KNOWN DEFERRED COSMETIC ISSUE** |

## 2.0.0-beta.30.1.7

| Feature/path | Status |
|---|---|
| Gold fresh NEW GAME -> SETUP | **RUNTIME PASS (30.1.6)** |
| Yellow fresh NEW GAME -> SETUP | **RUNTIME PASS (30.1.6)** |
| Blue fresh NEW GAME -> bedroom | **RUNTIME PASS (30.1.6)** |
| Pokegear Cards API v1 detection | **STATIC/MOCK PASS; RUNTIME TEST** |
| Gold NUZ Pokégear card | **STATIC/MOCK PASS; RUNTIME TEST** |
| Gold MAP encounter overlay | **STATIC/MOCK PASS; RUNTIME TEST** |
| Gold RADIO World Building overlay | **STATIC/MOCK PASS; RUNTIME TEST** |
| PHONE integration | **INTENTIONALLY NONE** |
| Pokegear Cards absent/disabled | **STATIC graceful no-op; RUNTIME TEST** |
| Permanent Rule Seal | **WIP / UNSELECTABLE** |
| Yellow `NUZ` position | **KNOWN DEFERRED COSMETIC ISSUE** |

## 2.0.0-beta.30.1.8

| Feature/path | Status |
|---|---|
| Trainer Money without external provider | **STATIC/MOCK PASS; prior behavior preserved** |
| Trainer Money with `economy_provider` | **MOCK PASS — provider payout left untouched** |
| Delegated Trainer Money UI neutral | **STATIC PASS — 100% / index 4** |
| Gold fresh NEW GAME -> SETUP | **RUNTIME PASS (30.1.6)** |
| Yellow fresh NEW GAME -> SETUP | **RUNTIME PASS (30.1.6)** |
| Blue fresh NEW GAME -> bedroom | **RUNTIME PASS (30.1.6)** |
| Gold NUZ Pokégear card | **STATIC/MOCK PASS; RUNTIME TEST** |
| Gold MAP encounter overlay | **STATIC/MOCK PASS; RUNTIME TEST** |
| Gold RADIO World Building overlay | **STATIC/MOCK PASS; RUNTIME TEST** |

## 2.0.0-beta.30.1.9

| Feature/path | Status |
|---|---|
| Johto fallback cap ordering | **STATIC PASS — monotonic** |
| Chuck -> Pryce -> Jasmine mid-game order | **RESTORED** |
| Gold badge identity/slot mappings | **UNCHANGED** |
| Trainer Money external-provider delegation | **MOCK PASS (30.1.8)** |
| Delegated Trainer Money UI neutral | **STATIC PASS — 100%** |
| Gold fresh NEW GAME -> SETUP | **RUNTIME PASS (30.1.6)** |
| Yellow fresh NEW GAME -> SETUP | **RUNTIME PASS (30.1.6)** |
| Blue fresh NEW GAME -> bedroom | **RUNTIME PASS (30.1.6)** |
| Gold NUZ Pokégear card | **STATIC/MOCK PASS; RUNTIME TEST** |
| Gold MAP encounter overlay | **STATIC/MOCK PASS; RUNTIME TEST** |
| Gold RADIO World Building overlay | **STATIC/MOCK PASS; RUNTIME TEST** |

## 2.0.0-beta.30.1.10

| Feature/path | Status |
|---|---|
| R/B/Y fallback title SETUP insertion | **STATIC PASS; prior runtime behavior protected** |
| R/B/Y save-editor exclusion after wrapper install | **STATIC PASS; RUNTIME TEST** |
| Gold fallback title save-editor exclusion | **STATIC PASS where wrapper active; RUNTIME TEST** |
| Gold fresh NEW GAME -> SETUP | **RUNTIME PASS (30.1.6)** |
| Yellow fresh NEW GAME -> SETUP | **RUNTIME PASS (30.1.6)** |
| Blue fresh NEW GAME -> bedroom | **RUNTIME PASS (30.1.6)** |
| Trainer Money provider delegation | **MOCK PASS (30.1.8)** |
| Johto cap ordering | **STATIC PASS (30.1.9)** |

## 2.0.0-beta.30.1.11

| Feature/path | Status |
|---|---|
| Gold Standard Mart + Route Forgiveness | **STATIC PASS; RUNTIME TEST** |
| Route Forgiveness token status label | **STATIC PASS; RUNTIME TEST** |
| Bare Trainer Rewards helper globals in main.lua | **AUDIT PASS — NONE REMAIN** |
| Trainer Money provider delegation | **MOCK PASS (30.1.8)** |
| Johto cap ordering | **STATIC PASS (30.1.9)** |
| R/B/Y title save-editor per-call guard | **STATIC PASS (30.1.10)** |
| Gold NUZ Pokégear card | **STATIC/MOCK PASS; RUNTIME TEST** |

## 2.0.0-beta.30.1.12

| Feature/path | Status |
|---|---|
| Stored catch -> empty tracked area | **MOCK PASS** |
| Stored catch -> matching entry | **MOCK PASS** |
| Stored catch -> conflicting occupied area | **MOCK PASS — Legacy fallback** |
| False tracker registration on conflict | **FIXED / STATIC PASS** |
| Gold Standard Mart + Route Forgiveness | **STATIC PASS; RUNTIME TEST (30.1.11)** |
| Trainer Money provider delegation | **MOCK PASS (30.1.8)** |
| Johto cap ordering | **STATIC PASS (30.1.9)** |
| R/B/Y title save-editor guard | **STATIC PASS (30.1.10)** |

## 2.0.0-beta.30.1.13

| Feature/path | Status |
|---|---|
| Solo Only + gift acquisition | **MOCK PASS** |
| Solo Only + NPC trade acquisition | **MOCK PASS** |
| Solo Only + wild catch | **Existing enforcement unchanged** |
| Trade Solo rejection text | **Existing shared message path; RUNTIME TEST** |
| Stored-location Legacy fallback | **MOCK PASS (30.1.12)** |
| Gold Standard Mart + Route Forgiveness | **STATIC PASS; RUNTIME TEST (30.1.11)** |
| Trainer Money provider delegation | **MOCK PASS (30.1.8)** |
| Johto cap ordering | **STATIC PASS (30.1.9)** |

## 2.0.0-beta.30.1.14

| Feature/path | Status |
|---|---|
| Non-opening Rival before opener | **MOCK PASS — does not consume mercy slot** |
| Opening Rival + Mercy ON | **MOCK PASS — consumes and arms** |
| Opening Rival + Mercy OFF | **MOCK PASS — consumes without arming** |
| Repeated opener after consumption | **MOCK PASS — cannot re-arm** |
| Old-save later Rival protection | **Classifier behavior preserved; RUNTIME TEST** |
| Solo Only + NPC trades | **MOCK PASS (30.1.13)** |
| Stored-location Legacy fallback | **MOCK PASS (30.1.12)** |
| Gold Mart + Route Forgiveness | **STATIC PASS; RUNTIME TEST (30.1.11)** |

## 2.0.0-beta.30.1.15

| Feature/path | Status |
|---|---|
| First Rival Mercy flavor via battle.say | **Existing path unchanged** |
| First Rival Mercy flavor via battle.emit | **Existing path unchanged** |
| First Rival Mercy Tier 1/2 generic fallback | **MOCK PASS** |
| Default Tier 3 worldOnce behavior | **MOCK PASS** |
| Once flag only after successful fallback push | **MOCK PASS** |
| First Rival Mercy one-shot latch | **MOCK PASS (30.1.14)** |
| Solo Only + NPC trades | **MOCK PASS (30.1.13)** |
| Stored-location Legacy fallback | **MOCK PASS (30.1.12)** |

## 2.0.0-beta.30.1.16

| Feature/path | Status |
|---|---|
| Type Locke FAIRY recognition | **MOCK/STATIC PASS** |
| Fairy Monolocke | **MOCK PASS; RUNTIME TEST** |
| Fairy Duolocke | **MOCK PASS; RUNTIME TEST** |
| Pure Fairy rejected by unrelated Mono type | **MOCK PASS** |
| Water/Fairy dual-type matching | **MOCK PASS** |
| RANDOM selector remains numeric 17 | **STATIC/MOCK PASS** |
| FAIRY selector numeric 18 | **STATIC/MOCK PASS** |
| RANDOM live-pool Fairy eligibility | **MOCK PASS** |
| Unknown custom type fail-open | **Existing policy preserved** |
| First Rival Mercy fallback tier | **MOCK PASS (30.1.15)** |
| First Rival Mercy one-shot | **MOCK PASS (30.1.14)** |
| Solo Only + NPC trades | **MOCK PASS (30.1.13)** |

## 2.0.0-beta.30.1.17

| Feature/path | Status |
|---|---|
| R/B/Y No Buying with English BUY | **MOCK PASS** |
| R/B/Y No Selling with English SELL | **MOCK PASS** |
| R/B/Y No Buying with Finnish OSTA | **MOCK PASS; RUNTIME TEST** |
| R/B/Y No Selling with Finnish MYY | **MOCK PASS; RUNTIME TEST** |
| Gold Mart No Buying / No Selling | **Semantic path unchanged** |
| Type Locke FAIRY compatibility | **MOCK/STATIC PASS (30.1.16)** |
| First Rival Mercy fallback tier | **MOCK PASS (30.1.15)** |

## 2.0.0-beta.30.1.18

| Feature/path | Status |
|---|---|
| Modern UI adapter registration | **MOCK/STATIC PASS; RUNTIME TEST** |
| Modern Encounter Tracker | **MOCK PASS; RUNTIME TEST** |
| Modern Area Guide page | **MOCK PASS; RUNTIME TEST** |
| Modern NUZ INFO Catch page | **MOCK PASS; RUNTIME TEST** |
| Modern NUZ INFO Stat/Move pages | **MOCK PASS; RUNTIME TEST** |
| Modern Trainer Card / Nuz status | **MOCK PASS; RUNTIME TEST** |
| Native fallback without Modern UI | **STATIC PASS; existing native paths retained** |
| Nuz Rules / fresh Setup | **Native/protected; no presenter change** |
| Localized R/B/Y Mart enforcement | **MOCK PASS (30.1.17)** |

## 2.0.0-beta.30.1.21

| Surface | Confidence | Evidence |
| --- | --- | --- |
| PokemonRecompRandomizer contract-v1 detection | Static/mock PASS | Public `contractVersion` + read-only `save.activeRun()` adapter |
| Per-surface randomizer ownership | Static/mock PASS | Starter/wild/learnset ownership matrix |
| Fishing-only composition | Static/mock PASS | Fishing does not claim encounter-table transform |
| Provider-owned learnset stale-restore protection | Static/mock PASS | Delegation resolves before snapshot/restore |
| Arbitrary Oak starter with Gift Pokemon OFF | Static/mock PASS | Opening story-context exemption |
| Gold exclusion | Static/mock PASS | Adapter generation guard |
| Combined in-game behavior | TEST REQUIRED | Requires both mods in Gen1Recomp runtime |

## 2.1.24 confidence update
Yellow 2.1.23 runtime PASS: randomized-starter received-name, party presence, Trainer Money symbol. Yellow 2.1.23 runtime FAIL: party NUZ INFO crash. 2.1.24 native-list repair is parser/static validated; runtime TEST REQUIRED.
