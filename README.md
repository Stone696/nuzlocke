# Nuzlocke 2.5.23-DEV

Configurable Nuzlocke enforcement, tracking, variants, randomizer options, difficulty controls, World Building, compatibility adapters, and quality-of-life features for Pokémon Red/Blue/Yellow and beta Gold on Gen1Recomp.

This DEV build is the strict child of **2.5.22-DEV** and is intended for continued R/B/Y/Gold runtime validation before publication. Save Schema remains **4**, Compatibility API is **28**, Diagnostics API remains **1**, Mod API remains **2**, and the supported engine range remains **>=0.1.86 <2.0.0**.



## 2.5.23-DEV Yellow / fresh-New-Game correctness

2.5.23 responds directly to runtime testing of 2.5.22 on a fresh Yellow New Game. The test was stable overall but exposed four concrete failures: Random Starter fell back to Pikachu, the starter was left UNKNOWN/out of the Pallet Town log, No Mom Heal did not enforce, and Yellow's Oak Pallet catch demonstration did not skip.

The source audit traced those failures to two structural Lua-scope regressions and one staged-runtime phase that was defined but never executed. 2.5.23 restores the critical R/B/Y command-wrapper tail to its owning scope, executes late-runtime phase 2, gives fresh `save.created` its own lifecycle retries, and routes starter RNG through an explicitly exported shared helper. A conservative repair can restore opening-starter Pallet provenance for affected R/B/Y saves when the real starter flags/committed random choice make the identity unambiguous.

The development process is tightened at the same time: invariant and CI mutation gates now fail when a critical helper is referenced outside its owner scope, when a staged runtime phase is not executed, when the R/B/Y command installer loses its `give_pokemon`/heal resolver tail, or when fresh-New-Game lifecycle coverage is removed. Lua syntax compilation remains useful but is no longer treated as sufficient proof for these classes because Lua permits unresolved names to compile as globals.

Save Schema remains **4**, Compatibility API remains **28**, Diagnostics API remains **1**, Mod API remains **2**, and the engine range remains **>=0.1.86 <2.0.0**. Exact Yellow runtime re-test is required.


## 2.5.22-DEV kerning / seeded-RNG lifecycle consistency

2.5.22 closes two source-confirmed reliability gaps without changing current gameplay semantics. Gen 1 variable-width kerning now records exact wrapper-session identity on the persistent Font singleton, so a later Nuzlocke reload can safely remove only its own exact stale top-level wrapper and rebind the current session. Ambiguous legacy or foreign wrapper chains fail closed and request one fresh process instead of guessing.

Starter randomization now uses the same versioned deterministic hash helper as encounter and learnset randomization. With the current RNG algorithm version still at **1**, the hash input and seeded starter results remain unchanged; a future algorithm-version bump can no longer leave starter RNG silently pinned to v1. Current RNG status labels also derive from the shared version source.

Save Schema remains **4**, Compatibility API remains **28**, Diagnostics API remains **1**, Mod API remains **2**, and the engine range remains **>=0.1.86 <2.0.0**. Runtime reload/randomizer regression testing is still required.

## 2.5.21-DEV trainer identity consistency

2.5.21 centralizes trainer identity normalization for reward recognition and League progression. R/B/Y and Gold now use the same normalized trainer ID, class, and name evidence, including Gen 1 `oppClass`, generic provider class aliases, and Gold `trainer.classId` / `trainer.class`. This prevents a compatible trainer shape from being recognized by Gym rewards while being missed by Gym/E4/Champion progression bookkeeping.

No rule defaults, save representation, loadout behavior, Save Schema, Compatibility API, Diagnostics API, Mod API, or engine range changes. Runtime regression testing is still required.

## 2.5.20-DEV tracking / enforcement safety

2.5.20 separates three concepts that were previously easy to conflate: whether Nuzlocke-owned save data is safe to write, whether the Nuzlocke master switch is enabled, and whether challenge rules should be enforced in the current battle. Passive Gym/E4/Champion progression remains synchronized on a supported save even while the player temporarily turns Nuzlocke OFF, while rule consequences such as Failed Encounter, Forgiveness Tokens, trainer-money rewriting, and Permadeath cleanup remain inactive. Unsupported newer-schema saves remain read-only.

The battle finalizer now applies those policies explicitly, Forgiveness Tokens cannot appear/purchase/spend while enforcement is inactive or safe-stopped, Failed Encounter has both entry-point and write-site enforcement guards, and post-battle dead-party pruning now respects the same safe-stop. Local invariant tooling classifies these battle writers as PASSIVE_PROGRESS or RULE_ENFORCEMENT so a future handler cannot silently use the wrong guard. Save Schema remains **4**, Compatibility API remains **28**, Diagnostics API remains **1**, Mod API remains **2**, and the engine range remains **>=0.1.86 <2.0.0**.


## 2.5.19-DEV save-safety / API hardening

2.5.19 closes newer-schema read-only gaps found by the local invariant audit. R/B/Y and Gold randomized-starter repair paths now stop before touching save-backed tables when an unsupported newer schema is loaded; Pokémon identity lookup is genuinely read-only, while identity allocation/hydration refuses mutation in safe-stop mode. The public compatibility report now returns a defensive engine snapshot, and `engine_compat` is refreshed whenever Item Policy updates live engine-state diagnostics.

The Save Schema 4 descriptor now distinguishes migration-bookkeeping fields from current configuration/legacy inputs and reports per-role counts. The final `mod.save:set` barrier now uses owner/previous/wrapper session identity, Permanent Rule Seal reconciliation exits cleanly while safe-stopped, and the local invariant suite checks these protections. Save Schema remains **4**, Compatibility API remains **28**, Diagnostics API remains **1**, Mod API remains **2**, and the engine range remains **>=0.1.86 <2.0.0**.

## 2.5.18-DEV API/descriptor hardening

2.5.18 hardens the development/API infrastructure introduced in 2.5.17 without changing gameplay rules. Public Compatibility API metadata now uses defensive snapshots instead of aliasing Nuzlocke's internal relationship/ownership tables; dynamic mod-compat snapshots refresh after provider discovery. `getEffectiveRuleValue()` now falls back to the canonical rule default when no explicit fallback is supplied.

The Rule Registry records construction collisions instead of silently suppressing them, and the Save Schema 4 descriptor now documents the `hardcore_mode` / `elite_four_caps` compatibility mirrors plus migration-only legacy inputs. DEV SELF TEST no longer exposes the live capability-version table by reference. The local invariant gate now checks these contracts and ignores historical non-authoritative boolean markers while still rejecting authoritative boolean-only wrapper guards. Save Schema remains **4**, Compatibility API remains **28**, Diagnostics API remains **1**, Mod API remains **2**, and the engine range remains **>=0.1.86 <2.0.0**.

## 2.5.17-DEV development-quality infrastructure

2.5.17 adds machine-readable build provenance, a derived Rule Registry, a Save Schema 4 configuration descriptor, centralized owner-aware direct-wrapper installation, and stronger Dev SELF TEST contract checks. These surfaces are diagnostic/development infrastructure: challenge rules, explicit saved choices, loadouts, encounter behavior, and gameplay defaults intentionally remain identical to 2.5.16.

Compatibility API is intentionally advanced from **27 to 28** because companion mods can now use public `capability_versions` / `getCapabilityVersion(capability)` negotiation. Existing API-27 capability names and meanings remain compatible and all current capability contract versions begin at 1. Diagnostics API remains 1 and Save Schema remains 4. Repository CI/test files are development-only and excluded from the canonical 15-file player package.

## 2.5.16-DEV API/default/lifecycle diagnostics pass

2.5.16 aligns the public `ruleActive()` compatibility helper with the same canonical missing-key defaults used by Setup, NUZ RULES, and enforcement. A missing default-ON rule can no longer be reported OFF to a compatible consumer. Remaining `locke_type` read/verification fallbacks now use the canonical NUZLOCKE default rather than historical CUSTOM/0 values; explicit saved loadouts are unchanged.

Direct-wrapper lifecycle checks are tightened for automatic default names, Gold nickname/Mart/gambling enforcement, the R/B/Y Permadeath bundle, QoL Toggles AUTO-REPEL, and Wilds of Kanto's paired pre/post capture adapters. Wilds now treats both `_resolveCapture` and `giveCaughtPokemon` as one ownership contract, preventing one half from silently going stale. Dev hook-health reporting now covers substantially more catch, death, poison, party-size, Gold, and optional-compatibility seams. No public return shape, persisted representation, API number, or engine range changed.


## 2.5.15-DEV reliability / lifecycle pass

2.5.15 fixes four high-confidence defects found in the 2.5.14 self-audit. Overworld poison wipes now respect **Whiteout** independently of Permadeath in both R/B/Y and Gold: the engine keeps its native poison-faint/blackout text, but Nuzlocke intercepts the final heal-point/spawn warp and performs the run-ending save deletion/title flow instead. Gold **No Escape** now resolves the live game through the shared current-game path rather than requiring the Gen 1-only `battle.game` field.

New-game snapshot commit now explicitly persists `locke_type` before verifying it, preventing a fully applied rule set from keeping an older loadout label or repeatedly failing verification. The remaining high-value direct wrappers for Party Size/PC withdrawal, Gold No Day Care, Gold battle Whiteout finish, Gold Headbutt tracking, and Gold forgiveness-token mart stock now use owner/previous/wrapper session metadata instead of trusting boolean-only install markers. No rule defaults, provider ownership, Save Schema, Compatibility API, or engine range changed.

## 2.5.14-DEV bug-fixing / lifecycle pass

2.5.14 repairs the R/B/Y starter/gift transaction's save-context ordering, routes missing core encounter/acquisition keys through the same canonical defaults used by Setup/NUZ RULES, and upgrades older critical catch/Permadeath direct wrappers from boolean-only install markers to owner-aware session records. Gold's capture wrapper receives the same lifecycle protection, and Pokégear World Building presentation now shares the canonical T1 fallback. Existing explicit rule saves are never rewritten.

The 0.2.7 TimeFishGroups linkage was reviewed and intentionally left alone: row-local day/night slots are the engine's authoritative value when present, while `timeFishGroups` is a fallback.

## 2.5.13-DEV field-poison Permadeath repair

2.5.13 closes a source-confirmed Permadeath gap shared by R/B/Y and Gold: overworld poison faints happen outside the battle faint lifecycle, so the existing battle-only death adapters could miss them. A field-poison faint can now be recorded in the normal Nuzlocke death/history projection and the fainted Pokémon is pruned from the live party before a later native blackout heal can restore it.

The repair deliberately leaves Gen1Recomp's native poison timing, poison-faint happiness/text, whiteout decision, heal/warp flow, and Nuzlocke Whiteout Clause ownership unchanged. Permadeath OFF and Nuzlocke OFF remain vanilla. The new direct wrappers are session-owner aware so a mod reload can replace its own stale wrapper without stacking duplicate death bookkeeping. Runtime confirmation is required on at least one R/B/Y game and Gold.

## 2.5.12-DEV Gen1Recomp 0.2.7 compatibility completion

2.5.12 completes a fresh source audit of the published Gen1Recomp **0.2.7** release. The release adds Gold time-dependent fishing (`TimeFishGroups`) to the shared encounters registry and includes renderer/audio/platform fixes that do not require Nuzlocke ownership changes.

One Nuzlocke compatibility defect was confirmed: the public effective/final encounter-registry facade still returned only `game.data.encounters`, while Gold's merged shared `encounters` registry lives at `game.data.gen2Encounters`. Gameplay randomization already used the Gold table, but compatible encounter-information consumers such as DexNav/guide/provider integrations could receive nil from Nuzlocke's public facade. The facade and registry description now resolve `gen2Encounters` first with the Gen 1 table as fallback. Randomizer slot selection, reveal policy, save data, and encounter reroll behavior are unchanged. Runtime confirmation on Gold/0.2.7 is still required.


## 2.5.11-DEV World Building T1 default completion

2.5.11 completes the 2.5.4 change that made **World Building T1** the canonical fresh/default setting. The setup/default-rule model already selected T1, but the live flavor resolver still used the historical T3 fallback when no value was stored, and the rule description still called T3 recommended.

The live resolver and configuration-value fallback now both use the same canonical `defaultRuleValue("world_building_tier")` source, and the rule copy says **DEFAULT: TIER 1**. Existing explicit OFF/T1/T2/T3 save values are preserved; this does not migrate or overwrite a player's chosen tier.


## 2.5.10-DEV tracker / Pokégear UI follow-up

2.5.10 is a narrow presentation child of 2.5.9. Gold Pokégear **NUZ → RULES** now pages in true four-row blocks, including a final partial page, shows a compact `RULES x/y` position indicator, and advertises `A:MORE` when additional rules exist.

**ENC TRACKER** now shows **NO ENTRIES YET** when the current LOG/MAP data set is genuinely empty. The Modern UI adapter keeps the real entry count at zero and does not treat the placeholder as a real encounter row; native R/B/Y and Gold tracker surfaces show the same translated empty-state message. No encounter, save, rule, or provider semantics changed.

## 2.5.9-DEV Yellow setup follow-up

Yellow 2.5.8 runtime testing confirmed that fresh **Shiny Clause** now defaults to **OFF / 0** and Type Locke can be edited in NUZ RULES without the previous update error. Saving the NEW GAME setup still failed, however, because setup/profile code referenced the Type Locke slot-index table outside the lexical block that owns it.

2.5.9 routes every later setup/profile Type Locke slot lookup through lifecycle-stable exported accessors and also repairs the same out-of-scope key-table use in the Gold status summary. The loadout warning is now a true scrollable review: UP/DOWN walks through every loadout-owned rule change instead of replacing undisplayed rows with `+N MORE`; LEFT/RIGHT still chooses APPLY/CANCEL and B still cancels with no mutation.

All Nuzlocke-owned setup/rules/status error dialogs now pre-wrap into explicit two-line pages, so diagnostic text waits for manual A/B input rather than scrolling past automatically. Menu organization now places **GAME DIFFICULTY**, then **BATTLE MECHANICS**, immediately above **AREA SPLITS**.

A Gen1Recomp 0.2.7 source audit also cleared a suspected Gold First Rival Mercy asymmetry: Cherrygrove uses `BATTLETYPE_CANLOSE`, which intentionally leaves the losing starter at 0 HP until the continuing rival script runs its own `HealParty`. Nuzlocke should suppress death/Whiteout bookkeeping there but should not inject the R/B/Y temporary 1-HP bridge.

## Highlights

- In-game **NUZ RULES** with collapsible sections, preset/loadout support, and live rule changes.
- **ENC TRACKER / Area Guide** with encounter state, catch provenance, deaths, area splits, and map/status integration.
- Core Nuzlocke rules, Dupes/FAMILY modes, finite or unlimited Shiny Clause, nickname enforcement, gifts/trades, static encounter controls, and failed-encounter handling.
- Hardcore restrictions for healing, battle items, PP items, TMs, Rare Candy, shops, Centers, Mom healing, escape, Repels, fishing, travel, lock-ins, party size, Gym team size, and more.
- Type Locke from MONO through HEXA with Catch Draft and a stable RANDOM selector.
- Built-in Random Starter, Random Encounters, Random Learnsets, seed control, balance/generation selectors, and OPEN/BLIND information policy.
- Encounter Ball Limit: OFF / 1 / 2 / 3 / 5 / 10 legal Ball throws per eligible encounter.
- Difficulty profiles, level caps, Badge Boost control, stat EXP/IV options, Maximum BST, Legendary/Mythical/Pseudo restrictions, Physical/Special Split, and related challenge controls.
- New-game setup options including starting money, Balls, Rare Candies, PC supplies, intro/tutorial skips, default names, running shoes, and Quick Nuzlocke Start.
- Compatibility/provider APIs for companion mods, merged species metadata, encounter providers, trainer providers, presentation mods, localization mods, and randomizers.
- Dev Mode with self-test, hook/lifecycle diagnostics, storage diagnostics, rule-effectiveness checks, randomizer integrity, and compact **NZR4 Report Codes**.

## Important 2.5.x candidate fixes

The 2.4.94–2.4.100 stabilization line repaired several user-visible regressions and configuration-plumbing defects that are included here:

- R/B/Y Mom-heal command wrappers now verify their live bindings before declaring themselves healthy.
- Field-item rejection messages such as **No Field Heal** and **No Rare Candy** use readable, player-paced dialogue pages.
- Randomized starters retain Pallet Town provenance in Tracker/map even when the selected species is not a vanilla starter.
- Legacy compact mod IDs such as `CatchHelper` are recognized by automatic compatibility hints.
- Shiny Clause and Encounter Ball Limit numeric setters persist correctly.
- Encounter Ball Limit now has complete default/read/write/display plumbing.
- Randomizer Info Policy now displays the stored OPEN INFO / BLIND INFO value correctly.
- Dev Mode's Species Facts health check now points at the real `getSpeciesFacts` resolver instead of an obsolete symbol.
- Report Codes now encode the full semantic version and therefore remain valid across the 2.4.x → 2.5.0 boundary.
- Public exported `build` markers now follow the authoritative current build instead of retaining old implementation-version literals.

## Installation / update

Install the package through Gen1Recomp's normal mod workflow. Existing supported Nuzlocke saves migrate through the same ordered Save Schema 4 pipeline; no schema bump is required for 2.5.16-DEV.

If an older build opens a save written by a future Nuzlocke schema, downgrade safety pauses Nuzlocke writes rather than interpreting unknown save data.

## Runtime confidence

Recent user runtime testing on Pokémon Yellow confirmed working enforcement for No Field Heal with Potion and exposed the message-pacing, randomized-starter provenance, Mom-heal, and related defects repaired in the stabilization line. Some combinations—especially Gold parity and third-party mod combinations—remain explicitly tracked as runtime retests rather than being claimed from static analysis.

## Known/WIP

**Permanent Rule Seal** and **Wonderlocke** remain intentionally WIP-disabled. Gold support remains beta and should be treated as requiring broader runtime coverage than R/B/Y.

## Credits

Original mod by **bryanthaboi**. Continued development and release maintenance by **Stone696**.


## Release status

**2.5.10-DEV is a runtime repair candidate, not a public release.** 2.5.0 was never published. Continue validation before any 2.5.x publication.

## 2.5.2-DEV engine compatibility
The current source-audited Gen1Recomp profile is **0.2.7**. The published 0.2.2–0.2.7 engine deltas were reviewed without finding a required Nuzlocke enforcement rewrite. The supported engine range remains `>=0.1.86 <2.0.0`.

## 2.5.3-DEV menu organization
GAME DIFFICULTY and BATTLE MECHANICS now appear above GENERAL. No Catching and Ball Per Enc. are grouped under BATTLE ITEMS. Ball Per Enc. is shown only when catching is allowed and defaults to OFF (vanilla unlimited throws).

## 2.5.8-DEV Yellow rules/setup follow-up
Yellow 2.5.7 runtime testing confirmed two remaining UI/update defects: the loadout warning rows could run through the modal border, and changing Type Locke could still fall into the generic “Please report this text” update error. 2.5.8 keeps the confirmation on the native 160x144 surface with bounded/marquee change rows and routes Type Locke edits through lifecycle-stable slot/default accessors instead of relying on a stale local table reference.

Fresh/new configuration defaults now set **Shiny Clause to OFF / 0**; existing saves and staged profiles keep their explicit stored value. **Route Forgiveness** is now listed under **GENERAL** instead of CLAUSES with no gameplay semantic change. Runtime confirmation is still required.

## 2.5.7-DEV Dev Report presentation repair
Blue 2.5.6 runtime testing confirms **DEV TOOLS -> VIEW REPORT** no longer crashes when reopening a saved report across a fresh game session. The report and Storage Info pages still overflowed the native R/B/Y viewport: long NZR4 codes, playthrough IDs, storage keys, and other unbroken identifiers could extend off-screen. 2.5.7 adds Dev-only hard wrapping, uses a 16-character-safe R/B/Y content width, and renders the NZR4 value under a dedicated **REPORT CODE:** label in hyphen-grouped viewport-safe lines. This is a presentation repair only; report-code encoding/decoding and diagnostic payload semantics are unchanged. Runtime layout confirmation is required.

The shared 2.5.6 NUZ RULES edit crash repair still needs runtime confirmation. The loadout-change warning popup remains a separate known Blue setup UI issue and is not changed by 2.5.7.

## 2.5.6-DEV runtime repair status
Blue 2.5.5 runtime testing confirmed a shared NUZ RULES edit-path crash across multiple toggles and a DEV TOOLS -> VIEW REPORT crash. 2.5.6 hardened those two paths and removed the pseudo-bold duplicate draw from the MOD COMPAT left rule-name column. The saved-report VIEW REPORT crash repair now has Blue runtime PASS evidence across a full game restart; the shared NUZ RULES edit repair still needs runtime confirmation. The 2.5.5 opening-sequence repair is carried forward unchanged and remains runtime TEST REQUIRED.

## 2.5.5-DEV opening repair carried forward
The Blue opening-sequence repair candidate targets randomized starter nickname enforcement, Pallet Town provenance, and native First Rival Mercy loss continuation. None of those items is promoted to PASS by 2.5.7; re-test them from a fresh Blue save.

## 2.5.4-DEV rules cleanup
World Building now defaults to T1. Cap messages use one fixed once-per-battle policy. Solo Only has been retired: use Party Size Limit = 1 for Solo runs.
