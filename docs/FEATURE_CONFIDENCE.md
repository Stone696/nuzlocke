# Feature confidence — beta.29.1.0

These percentages express **confidence that the feature behaves as intended in this candidate**, based on the combination of runtime evidence, behavior/static checks, compile/load history, and how recently the relevant path changed. They are not literal observed success rates.

## Scale

- **99%** — repeated/exact runtime evidence plus strong supporting checks; no known issue in the tested path.
- **95–98%** — exact runtime PASS with strong supporting evidence.
- **90–94%** — runtime evidence exists, but edge cases or exact-current-build coverage are incomplete.
- **80–89%** — strong implementation/automated/shared-path evidence with limited exact runtime.
- **65–79%** — implemented but exact generation-specific runtime testing is still required.
- **1–64%** — partial or known-problem area.
- **0%** — intentionally unsupported/not active on that game.

Runtime failures override compile/static success. A material code change lowers confidence until the changed path is retested.

**Engine-profile note:** beta.29.1.0 changes compatibility metadata/profile coverage rather than gameplay logic. Gen1Recomp 0.1.83 is exact-source audited, but that does not promote feature confidence until the 0.1.83 runtime pass completes.

## Full matrix

| Area | Feature | Red | Blue | Yellow | Gold | Status | Evidence note |
|---|---|---:|---:|---:|---:|---|---|
| UI | **Fresh-game Setup boot** | 96% | 96% | 99% | 99% | Verified | Blue/Yellow historical fresh startup; current Gold Setup runtime PASS. |
| UI | **Collapsible rule sections** | 90% | 90% | 99% | 99% | Verified | Current Yellow and Gold runtime PASS; native directional glyph polish remains open. |
| UI | **Rule selection/navigation** | 92% | 92% | 99% | 94% | Verified | Current Yellow exact PASS for A/Left/Right selection with Up/Down navigation. |
| Setup | **Locke Type presets (CUSTOM/NUZ/HARD/SOLO)** | 90% | 90% | 95% | 0% | Supported | R/B/Y preset mapping is established; Gold intentionally does not expose the Locke Type preset control. |
| Setup | **Lock Rules** | 90% | 90% | 95% | 88% | Supported | Control is implemented on both R/B/Y and Gold surfaces and remains independently toggleable; exact per-game lock/unlock runtime matrix is incomplete. |
| Setup | **Save Setup profile** | 91% | 91% | 96% | 92% | Supported | Separate R/B/Y and Gold pre-game profiles are implemented; current Gold Setup runtime is healthy, but exact save/reload profile testing is not complete for every game. |
| UI | **Save Rules** | 92% | 92% | 97% | 90% | Supported | Active-save rule persistence is longstanding; exact Gold save/reopen rule matrix remains incomplete. |
| Recovery | **Recover Catches** | 84% | 84% | 88% | 0% | Test Required | R/B/Y legacy catch-recovery UI exists for unresolved older-save provenance; Gold does not expose this control. |
| Setup | **Starting Money** | 90% | 90% | 99% | 0% | Verified | Yellow new-game starting Money runtime PASS; R/B shares setup implementation. Not exposed on Gold. |
| Setup | **Starting Poke Balls** | 90% | 90% | 96% | 0% | Supported | R/B/Y starting-ball handoff/activation has runtime history; not exposed on Gold. |
| Setup | **Starting Rare Candy** | 90% | 90% | 99% | 0% | Verified | Yellow new-game starting Rare Candies runtime PASS; R/B shares setup implementation. Not exposed on Gold. |
| Utility | **Gym Guide Rare Candy** | 94% | 94% | 97% | 0% | Verified | R/B/Y repeatable Gym Guide Rare Candy mechanics were runtime-established in the beta.25/26 line. Not exposed on Gold. |
| UI | **ENC TRACKER** | 95% | 95% | 99% | 94% | Verified | Yellow and Gold runtime history; R/B shared code and older tracker coverage. |
| UI | **R/B/Y Trainer Card NUZ STATUS / Gold status screen** | 94% | 94% | 98% | 86% | Supported | Yellow Trainer Card runtime history; Gold uses separate Start-menu status path. |
| UI | **CATCH INFO** | 93% | 93% | 98% | 80% | Test Required | Yellow current/historical coverage and Gold beta26.6 runtime PASS; Gold PC-routed gift provenance changed in beta.29.0.2 and needs targeted runtime retest. |
| UI | **UI-theme replacement composition** | 62% | 62% | 65% | 65% | Known Issue | Six Nuzlocke-owned screens remain outside full UI-theme handling. |
| Core | **Nuzlocke master switch** | 95% | 95% | 98% | 88% | Supported | Longstanding shared enforcement; Gold reduced rule surface. |
| Core | **Permadeath** | 94% | 94% | 96% | 78% | Test Required | Longstanding R/B/Y path; Gold remains explicitly test-required and temporary-party hardening needs targeted runtime. |
| Core | **First Rival Mercy** | 88% | 88% | 92% | 70% | Test Required | beta.29.0.2 removed inert persisted telemetry while preserving the established one-shot/battle-local gate; targeted regression runtime is required after touching this path. |
| Core | **One Per Area** | 96% | 96% | 99% | 78% | Test Required | Yellow catch/encounter tracking runtime PASS; Gold PC-routed scripted-gift area consumption was fixed in beta.29.0.2 and needs runtime confirmation. |
| Core | **Failed Encounters** | 94% | 94% | 99% | 80% | Supported | Yellow failed Route 2 runtime PASS; Gold exact edge cases still open. |
| Core | **Nickname Rule** | 92% | 92% | 97% | 72% | Test Required | Live nickname enforcement has runtime history, but beta.29.1.0 changes post-naming history synchronization on R/B/Y and Gold and adds boxed-gift handling; targeted runtime retest required. |
| Clauses | **Dupes Clause** | 91% | 91% | 95% | 78% | Test Required | Shared merged evolution/species logic; exact current Gold combinations need runtime. |
| Clauses | **Shiny Clause** | 96% | 96% | 99% | 82% | Supported | Yellow pre-Ball Shiny ON/OFF route-preservation PASS; Gold exact combinations less tested. |
| Area | **Route Splits** | 86% | 86% | 90% | 0% | Supported | R/B/Y implemented with reversible projection; not part of Gold beta rule surface. |
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
| General | **No Static** | 84% | 84% | 87% | 68% | Test Required | beta.29.1.0 hardens the one-shot scripted-static lifecycle; genuine static and intervening-trainer/ordinary-wild regressions need runtime confirmation. |
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
| Battle | **Ball Use Ban** | 88% | 88% | 91% | 73% | Test Required | Strong structural/smoke coverage including STANDARD/ALL distinction; exact per-game runtime matrix incomplete. |
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
| World | **World Building** | 88% | 88% | 94% | 0% | Supported | Several Yellow/Blue runtime paths; Kanto-focused and not exposed on Gold beta rule surface. |
| QoL | **Default Names** | 90% | 90% | 92% | 88% | Supported | Player/Rival name skip has runtime PASS evidence; exact game of the latest pass is not preserved. |
| QoL | **Skip Catch Demo** | 0% | 0% | 0% | 75% | Test Required | Gold-only implementation; dedicated current runtime confirmation still needed. |
| UI | **Area Guide** | 93% | 93% | 97% | 90% | Supported | Tracker/map architecture with Yellow/Gold runtime evidence. |
| QoL | **B-Button Run** | 86% | 86% | 88% | 76% | Test Required | Generation-aware movement gates; exact current runtime matrix incomplete. |
| Compatibility | **Save Editor loader isolation** | 94% | 94% | 98% | 84% | Supported | Yellow full-restart recovery evidence; architecture explicitly isolates editor runtime patches. |
| Compatibility | **Temporary-party Permadeath/Whiteout reconciliation** | 84% | 84% | 86% | 80% | Test Required | beta.28.20 static/code hardening; targeted runtime with temporary-party systems remains open. |

## Current highest-priority confidence gaps

- beta.29.0.2 reviewed-fix regressions carried into beta.29.1.0 unchanged: First Rival Mercy, scripted gift/starter history nickname synchronization, Gold full-party/PC-routed gifts, and scripted-static provenance across an intervening trainer battle.
- Maximum BST and all Stat EXP/DV controls need representative numeric runtime tests after the beta.28.15 numeric-rule correction.
- Destructive Whiteout paths need disposable-save runtime coverage on the current code, especially Gold.
- Gold field/item/shop/nickname paths marked TEST REQUIRED should be exercised individually before their scores are promoted.
- Temporary-party Permadeath/Whiteout reconciliation needs an exact runtime combination that narrows/reorders and restores the party.
- UI-theme composition remains a known issue even though the underlying Nuzlocke screens function.
- Lost-encounter presentation must be separated from Pokémon death presentation without rewriting historical save meaning.

## Evidence carried into this candidate

- Current: Gold NEW GAME reaches Nuzlocke Setup; collapsible Setup sections work.
- Current: Yellow existing-save rule selection uses A/Left/Right without consuming Up/Down navigation; collapsible sections work.
- Historical/current: Yellow rules/tracker/catch behavior, failed encounter tracking, next-cap displays, fresh shops, Mom/Center behavior, starter nickname, starter Catch Info, and several early-game flows have runtime PASS evidence.
- Historical: Red/Blue shop behavior, Blue field healing, Red Gym Guide, R/B/Y startup, and multiple battle/field-item restrictions have runtime PASS evidence.
- Save Editor follow-up: Yellow No TMs and No Rare Candy passed after fully closing/reopening Gen1Recomp.
