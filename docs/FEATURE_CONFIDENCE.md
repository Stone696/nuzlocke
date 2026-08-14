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
