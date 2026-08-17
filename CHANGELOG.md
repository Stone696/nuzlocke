# 2.4.10 — Forgiveness Token million-price purchase path

Direct child of 2.4.9 RC.

- Preserves the intentional advertised Forgiveness Token price of **¥1,000,000**.
- Adds a token-specific cap-aware settlement path instead of lowering the token to ¥100,000 or raising the global wallet ceiling.
- On engines with the native ¥999,999 wallet ceiling, a full wallet is the representable settlement requirement; purchasing consumes that full wallet while the Mart continues to present **¥1,000,000**.
- Normal Mart prices, ordinary item purchases, Trainer Money, and the global wallet ceiling are unchanged.
- Keeps the 2.4.9 `noBadgeBoosts`/AI-tier decoupling and Forgiveness modal correction.
- Gen1Recomp 0.1.99 compatibility audit retained. Per project manifest policy, the forward declaration is now five patch versions ahead: `>=0.1.86 <0.2.5`.
- Save schema remains unchanged.
- R/B/Y million-price purchase path is **TEST REQUIRED**. Gold native Mart behavior remains **TEST REQUIRED**; no new Gold runtime PASS is claimed.

# 2.4.9 RC — difficulty hardening + Forgiveness modal correction

Direct child of 2.4.8 RC.

- Decoupled `noBadgeBoosts` from `aiTier`, so badge-boost suppression now applies independently even for future profiles with `aiTier = 0`.
- Gen 1 private battle badge state is cleared before the AI-tier gate; Gold no longer depends on `trainer.attributes` being available for the independent badge-boost flag.
- Corrected the R/B/Y Forgiveness prompt's opaque panel rendering: it now paints its own panel/window instead of calling nonexistent `mod.ui.clear` / `game:clear` APIs.
- Preserves the 2.4.8 RC Gen1Recomp `>=0.1.86 <0.2.1` compatibility range and all unrelated behavior.

# 2.4.8 RC — launcher compatibility + battle feedback cleanup

- Direct child of 2.4.7 RC.
- Expanded launch compatibility from `>=0.1.86 <0.1.99` to `>=0.1.86 <0.2.1`, fixing 0.1.99 rejection and explicitly allowing 0.2.0.
- Hardened the R/B/Y Forgive Encounter prompt as an opaque Nuzlocke-owned screen so underlying battle/party HUD content does not bleed through.
- Gym Team Size refusal text is now limited to once per individual trainer-battle attempt. There is no new setting/toggle. Enforcement remains active on every over-limit attempt.
- Added semantic encounter-count status based on the same authoritative encounter eligibility used by Failed Encounter/capture rules. Dupes and other free encounters are not marked as spending the area.
- No global battle/menu draw monkey-patches were added.
- Runtime validation required before publication.

# 2.4.7 RC — provider load-order metadata fix

- Direct child of 2.4.6 RC.
- Added `gen1_modern_ui` and `gen_2_randomizer_plus` to `optional_dependencies`; both are actively discovered with `mod.find`.
- They remain optional integrations.
- Chuck → Pryce → Jasmine progression is documented intentional behavior and is unchanged.
- No unrelated gameplay changes.

# 2.4.6 RC — Gym Forgiveness activity guard

- Direct child of 2.4.5 RC.
- Fixed the confirmed missing `d.active()` guard in `awardGymLeaderForgiveness`.
- Demo/ghost battles are rejected before the one-shot Gym reward ledger/token path.
- Focused trainer-reward ledger audit found no second same-confidence defect.
- No unrelated gameplay changes.

# 2.4.5 RC — Summon / Quest System compatibility pass

- Direct child of the exact uploaded 2.4.4 RC.
- Source-reviewed Summon 1.0.2 and Quest System 1.0.5.
- Summon now classifies as both external encounter start and targeted encounter selector.
- Quest System now classifies as quest framework/presentation rather than generic quest-content ownership.
- Individual quest/source mods retain their own content and reward ownership.
- MOD COMPAT adds QUEST UI and QUEST DATA ownership rows.
- No named-mod gameplay enforcement branches added.
- Wide Menus runtime PASS remains protected and its integration code is unchanged.
- Runtime testing required before publication.

# 2.4.4 RC — Catch Helper / Area DexNav compatibility pass

- Direct child of 2.4.3 RC.
- Source-reviewed Catch Helper 1.4.0 and Area DexNav 1.0.0.
- Catch Helper is classified as capture mechanics + battle information because current 1.4.0 both displays live catch odds and intentionally retunes Ultra Ball HP-factor behavior.
- Area DexNav is classified as an encounter selector in addition to an external encounter starter.
- Added generic cooperative targeted-encounter selection policy for randomized BLIND INFO.
- Ordinary random encounters are never blocked by BLIND INFO.
- Under BLIND randomized encounters, compatible targeted selectors are asked not to deliberately choose an undiscovered hidden species; they can fall back to a normal random encounter.
- EncounterAPI now exposes/uses the targeted selection policy when a provider opts into targeted-selection context.
- MOD COMPAT adds ENC SELECT / CATCH ODDS / CATCH RULES ownership rows.
- Nuzlocke random encounters already mutate the final live encounter registry that Area DexNav reads, so no second/randomizer-specific registry was introduced.
- Catch Helper reads the already-active battle; BLIND INFO does not hide catch odds after the encounter is visibly underway.
- No hardcoded runtime branch for Catch Helper or Area DexNav.
- Wide Menus runtime PASS remains protected; tracker code unchanged.
- Runtime combination testing required before publication.

# 2.4.3 RC — Item Shortcut / Reusable Machines compatibility pass

- Direct child of 2.4.2 RC.
- Runtime report: latest parent build no longer crashes with Wide Menus. This is now recorded as a protected runtime PASS; 2.4.3 does not touch tracker/Wide Menus code.
- Source-reviewed Item Shortcut 1.4.0 and Reusable Machines 1.0.1.
- Corrected legacy capability classification: Item Shortcut is no longer reported as the Bag presentation owner.
- `AUTOMATIC_ITEM_USE` now canonicalizes to `item_use_entrypoint` instead of broad `item_provider`.
- `MACHINE_PROVIDER` now canonicalizes to `machine_mechanics` instead of broad `item_provider`.
- MOD COMPAT adds ITEM USE and MACHINES ownership rows while keeping ITEM RULES Nuzlocke-owned.
- Item Shortcut's reviewed direct/FAST use path intentionally re-enters the standard Bag USE flow, so Nuzlocke's ItemEffects legality gate remains authoritative.
- Reusable Machines starts its reusable-TM session from the normal TM/Party teaching flow; No TMs therefore remains upstream of the reusable-consumption behavior.
- No hardcoded enforcement branch for either mod.
- Runtime combination tests required before publication.

# 2.4.2 RC — Modern Bag / EXP Share compatibility pass

- Direct child of 2.4.1 RC; preserves the 2.4.1 Difficulty/cap fix.
- Modern Bag current indexed release 1.5.2 reviewed; index/release metadata is newer than the browsable source folder, so current-source status is not overstated.
- EXP Share Modes 1.0.0 current source reviewed.
- Legacy auto-compat discovery now prefers Gen1Recomp's authoritative loaded-mod graph.
- Split alternate Bag presentation ownership from item mechanics and Nuzlocke item policy.
- MOD COMPAT adds BAG UI / ITEM RULES / EXP DIST. / EXP CAP ownership rows and explanations.
- `nuzlocke.experience` is now API 2; its capAward/evaluateAward/preflight helper returns a real read-only cap ceiling instead of always allowing the requested EXP.
- Canonical Experience.apply -> exp.gain remains the preferred EXP path.
- No mod-specific gameplay enforcement branches added.
- Runtime combination testing required before publication.

# 2.4.1 RC — Difficulty/cap direct-party fix

- Direct child of published 2.4.0.
- Confirmed 2.4.0 bug: changing built-in Game Difficulty could leave NUZ STATUS NEXT CAP and the shared level-cap enforcement source at vanilla values.
- Root cause: R/B/Y trainer parties are commonly direct arrays at `trainer.parties[partyIndex]`; the cap reader selected that array and then incorrectly required a nested `.party/.roster/.team`, producing nil.
- `liveTrainerAce()` now uses the existing canonical `baseTrainerParty()` reader and `composedTrainerParty()` transaction already used by Gym Team Size.
- NEXT CAP, EXP edging, Rare Candy cap enforcement, Trainer Card/status consumers, and actual battle composition now derive from the same composed trainer-party shape.
- Defensive fallback also accepts direct-array party rows.
- Executable Lua regression harness PASS: stable Difficulty selection changes representative Yellow boss caps and projected caps match composed battle aces.
- Real in-game Yellow runtime confirmation is still required before any 2.4.1 publication.
- No save schema, Compatibility API number, package tree, or engine range change.

# 2.4.0 — published release

**Direct promotion of 2.3.35 RC. No additional runtime/gameplay behavior was changed during promotion.**

2.4.0 is the first published release after 2.3.12 and consolidates the 2.3.13–2.3.35 development line.

## Highlights since 2.3.12

### Stability and presentation
- Reworked R/B/Y ENC TRACKER presentation after runtime isolation of Wide Menus interactions; the final native-size tracker no longer shows the shrink regression seen during development.
- Fixed recurring ordinary-Pokémon `DETAIL SAFE MODE` in NUZ INFO.
- Added real R/B/Y NUZ INFO Catch / Stat / Move pages with A / Left / Right paging.
- Centered/bolded NUZ INFO and page titles with subtle glyph tracking while keeping data labels normal-weight.
- Reworked MOVE INFO into compact three-line cards to avoid overlapping move/type/stat text.
- Rebuilt MOD COMPAT into a readable RULE/OWNER ownership view with contextual plain-language help and Select/Tab detail paging.
- Added native-style `ACTIVE RULES:` emphasis to NUZ STATUS.
- Shortened constrained UI labels including `F. TOKEN`, `Rndm Seed`, `Rndm Strtr`, `Strtr Style`, and R/B/Y `NUZ STS.`.

### Randomizer
- Fixed manual Random Seed numeric storage and live reapply.
- Fixed Starter Style / Encounter Balance / Gold Egg Encounter / Bug Contest multi-choice setters.
- Added dependent Randomizer UI:
  - Random Starter -> Starter Style
  - Random Encounters -> Encounter Balance / Randomizer Info / Species Pool
  - Random Learnsets -> Learnset Gen
- Child selections remain saved while hidden and become inactive while the parent is OFF.
- Species Pool now belongs only to Random Encounters; Random Starter uses Starter Style over the full legal live pool.
- Added OPEN INFO / BLIND INFO encounter-information policy for compatible information tools.
- Fixed RNG Info OPEN/BLIND numeric cycling.

### Difficulty and level caps
- Fixed phantom Indigo Conference / IronMON / historical-provider warnings; historical IDs are recognition hints only and now require a real loaded mod.
- Added direct built-in Difficulty cap projection through the same composed trainer roster used by actual battles.
- Kept generic trainer-provider composition for external difficulty mods.
- Improved live Difficulty switching and boss-cap cache invalidation.

### Gym / challenge enforcement
- Dungeon Lock-In now reconciles transient lock state against the actual entered map, including compatible third-party map changes.
- Yellow runtime confirmed Gym Lock-In works.
- Fixed Gym Team Size enforcement at Gen1Recomp's real `trainer.before_battle` seam so normal R/B/Y Gym Leader dialogue cannot bypass the cap.
- Gym Team Size counts every carried non-Egg Pokémon, including fainted/dead party slots.
- Over-cap Leaders refuse the battle with tiered world-building dialogue before trainer-battle creation.
- No Fishing moved to GENERAL directly below No Static Enc.

### Compatibility and provider semantics
- Added first-class `trainer_capture` acquisition provenance for trainer catches / Snag-style integrations.
- No Catching now understands trainer captures.
- Public Ball classification became semantic: item metadata, Gold Ball pocket data, and registered item effects can identify compatible custom Balls.
- Added provider-agnostic learnset ownership/delegation hardening.
- Hardened capture policy for area-less compatible/provider battles.
- Fixed starter/gift/trade provenance ordering and duplicate starter fallback behavior.
- Upgraded storage transaction policy to API 2 with semantic WITHDRAW / DEPOSIT / RELEASE / SWAP and incoming-Pokémon legality parity.
- Added final composed encounter registry and encounter-information policy helpers.
- Added semantic translation source/catalog exports for Nuzlocke-owned UI strings.
- Added generic `nuzlocke_ui` screen ownership metadata for rules, tracker, and MOD COMPAT presenters.
- Consolidated compatibility documentation and source/release/runtime-evidence terminology.
- Reviewed current compatibility behavior/lessons for Pokémon Snag, Too Many Balls, Translation Generator, Shiny Pokémon, Weather FX, Gen 3 Inspired UI, Advanced Box System, Pokédex Plus, and historical IronMON / Enemy HP evidence.

### Gold
- Fixed Gold Egg Encounter / Bug Contest selectors.
- Fixed Gold Physical/Special Split temporary-state isolation.
- Fixed Gold egg provenance so eggs do not create synthetic UNKNOWN encounter areas.
- Improved Gold status/rule label clipping.
- Preserved Gold beta support and boot-safe initialization.

### Forgiveness Token / item rules
- Fixed the actual trainer-reward item definition and mart presentation to use `F. TOKEN`.
- Yellow runtime confirmed a full bag does not lose the Route Forgiveness Token reward; the Leader offers it again later.
- Yellow runtime confirmed No Rare Candy blocks candy use with explanatory dialogue after level-cap progression.

## Runtime-confirmed release-line results

Confirmed during the 2.3.13–2.3.35 development line:
- Yellow boot / fresh setup / existing save path inherited from 2.3.12 remains protected.
- Gold NEW GAME boot path remains protected.
- Yellow Gym Lock-In: PASS.
- Dependent Randomizer child-row hiding/restoration: PASS.
- Phantom Indigo/IronMON Difficulty warnings: fixed in runtime.
- NUZ STATUS presentation: improved in runtime.
- R/B/Y MOD COMPAT physical size: PASS.
- R/B/Y ENC TRACKER physical size: PASS.
- R/B/Y NUZ INFO page switching: PASS.
- `F. TOKEN` mart label: PASS.
- Route Forgiveness Token full-bag retry: PASS.
- No Rare Candy veto + explanatory dialogue: PASS.
- MOVE INFO is substantially improved and accepted for this release; more cosmetic refinement may follow later.

## Still recommended for broader validation
- Re-test the 2.3.32+ Gym Team Size refusal path across multiple Leaders/games.
- Continue broad Red / Blue / Yellow / Gold compatibility matrix testing before major feature expansion.
- Gold remains beta support.

---

# 2.3.35 RC — MOVE INFO overlap fix

- Direct child of 2.3.34 RC.
- Runtime feedback reports the rest of the recent NUZ INFO / MOD COMPAT presentation work improved; MOVE INFO remained the visible problem.
- Reworked MOVE INFO cards to a single-column three-line layout:
  - move number + name
  - TYPE + type name
  - compact `P / A / PP` stats
- Removed the competing TYPE/PWR and ACC/PP split columns that still overlapped on the native 160x144 surface.
- Long type/stat lines use the existing marquee-safe renderer rather than colliding.
- Two moves remain visible at once; Up/Down still reaches moves 3-4.
- No gameplay rules, move data, save schema, Compatibility API number, package tree, or engine range changed.

# 2.3.34 RC — NUZ INFO / MOD COMPAT runtime presentation follow-up

- Direct child of 2.3.33 RC.
- Recorded Yellow 2.3.32 MOD COMPAT physical-size fix as runtime PASS.
- Recorded Yellow 2.3.32 ENC TRACKER physical-size fix as runtime PASS.
- Recorded Yellow 2.3.32 F. TOKEN mart label as runtime PASS.
- Recorded R/B/Y NUZ INFO Catch/Stat/Move page switching as runtime PASS.
- MOD COMPAT bottom explanation now preserves the full wrapped text and pages it with Select/Tab, three lines at a time; moving to another ownership row resets detail paging to page 1.
- NUZ INFO and current page titles remain bold/centered but now use subtle 1-pixel glyph tracking instead of literal added spaces.
- Removed bold echo from Catch/Stat left-column labels; titles are the only bold elements.
- Rebuilt MOVE INFO as two visible three-line move cards: name, TYPE/PWR, ACC/PP. Long move names get the full name row and marquee instead of colliding with type text.
- Move 3/4 remain reachable with normal Up/Down scrolling.
- No gameplay rules, save schema, Compatibility API number, package tree, or engine range changed.

# 2.3.33 RC — Yellow runtime follow-up

- Direct child of 2.3.32 RC.
- Recorded Yellow 2.3.30 Route Forgiveness Token full-bag retry as runtime PASS.
- Recorded Yellow 2.3.30 No Rare Candy enforcement/dialogue as runtime PASS.
- Moved No Fishing from FIELD ITEMS to GENERAL directly below No Static Enc.
- R/B/Y START-menu label `NUZ ST.` is now `NUZ STS.` for clearer meaning. Gold retains the shorter legacy label because its native START box has the tighter safe label width.
- Fixed built-in Game Difficulty cap preview: NUZ STATUS now previews Nuzlocke-owned profiles directly through the same `Difficulty.composeParty()` transformation used by the actual trainer battle.
- External trainer/difficulty mods retain generic `trainer.party` composition preview.
- Difficulty selection still clears observed boss-cap cache on every in-game profile change.
- No gameplay formula duplication, save schema change, Compatibility API bump, package-tree change, or engine-range change.
- 2.3.32 Gym Team Size fix remains TEST REQUIRED.

# 2.3.32 RC — Yellow Gym Team Size enforcement fix

- Direct child of 2.3.31 RC.
- Records Yellow 2.3.30 Gym Lock-In runtime PASS.
- Records Yellow 2.3.30 Brock Gym Team Size runtime FAIL.
- Added primary Gym Team Size enforcement at Gen1Recomp's `trainer.before_battle` seam used by normal R/B/Y Gym Leader interactions.
- Exact next-Leader trainer class and party index are required; ordinary Gym Trainers and unrelated trainer battles are unaffected.
- Over-cap battle creation is deferred, tiered world-building refusal text is shown, then the pending battle is cancelled before `BattleState.newTrainer`.
- Existing scripted `start_battle trainer` gate remains as compatibility coverage and now shares the same refusal text helper.
- Gym party count now means all carried non-Egg Pokémon, including fainted/Nuzlocke-dead party slots.
- Gym Lock-In implementation is untouched.
- No save schema, Compatibility API number, package tree, or engine range change.

# 2.3.31 RC — runtime-feedback stabilization pass

- Direct child of runtime-tested 2.3.30 RC.
- Restored native-size R/B/Y ENC TRACKER presentation; removed the shrink-causing 304x144 logical surface and returned the box to 20 columns.
- Restored native-size R/B/Y MOD COMPAT presentation while retaining host ListMenu ownership, RULE/OWNER headers, bold left labels and contextual help.
- R/B/Y NUZ INFO now has actual Catch / Stat / Move pages switchable with A or Left/Right.
- Centered/bolded NUZ INFO and current page titles; only the left information column is bold.
- Fixed Randomizer Info OPEN/BLIND selector by adding its missing numeric setter branch.
- Renamed Random Seed -> Rndm Seed, Random Starter -> Rndm Strtr, Starter Style -> Strtr Style in the visible rule surface.
- Changed the authoritative trainer-reward item-data name to F. TOKEN so the actual mart renderer receives the compact label.
- Preserved confirmed 2.3.30 Difficulty/provider and dependent-row improvements.
- No save schema, Compatibility API number, package tree, or engine range change.

# 2.3.30 RC — dependency/UI and difficulty-warning stabilization

- Direct child of 2.3.29 RC.
- Fixed phantom Indigo Conference / IronMON / stronger-trainers difficulty-provider detection.
- Historical provider IDs now require a real loaded `mod.find(id)` result before entering the Difficulty selector or multi-mod warning path.
- Starter Style now hides while Random Starter is OFF.
- Encounter Balance and Randomizer Info now hide alongside Species Pool while Random Encounters is OFF.
- Learnset Gen remains hidden while Random Learnsets is OFF.
- Child selections remain saved and restore when their parent is enabled again.
- No gameplay provider is disabled or invented; active installed providers remain discoverable.
- No save-schema, Compatibility API-number, package-tree, or engine-range change.

# 2.3.29 RC — dependent randomizer controls + status polish

- Direct child of 2.3.28 RC.
- Species Pool is now owned only by Random Encounters.
- Learnset Gen is owned only by Random Learnsets.
- Both child rows hide dynamically in Setup and NUZ RULES while their parent is OFF.
- Hidden child selections remain saved and return when the parent is re-enabled.
- Hidden child selections have no runtime effect while their parent is OFF.
- Random Starter no longer consults Species Pool; Starter Style operates over the full legal live species pool.
- Added effective child-policy helpers and `getEffectiveRuleValue(...)` compatibility read.
- NUZ STATUS now shows bold-emphasized `ACTIVE RULES:`.
- No save schema, Compatibility API number, package tree, or engine-range change.

# 2.3.28 RC — MOD COMPAT presentation/accessibility pass

- Direct child of 2.3.27 RC.
- Keeps the stable host ListMenu as R/B/Y MOD COMPAT's state/input owner; does not restore the old crash-prone custom state.
- R/B/Y MOD COMPAT now owns a 304x144 presentation surface.
- Centered MOD COMPAT title and added explicit RULE / SYSTEM and OWNER headers.
- Bold-emphasized left-column rule/system labels.
- Added native cursor glyph selection, five-row scrolling, and left/right page movement.
- Added marquee-safe full-width rule and owner rendering.
- Added a bottom hover help panel explaining ownership relationships in plain language.
- Added semantic MOD COMPAT presentation metadata/model for compatible UI overhauls.
- No compatibility ownership, gameplay rule, save schema, Compatibility API number, package tree, or engine-range changes.

# 2.3.27 RC — NUZ INFO stabilization

- Direct child of 2.3.26 RC.
- Fixed ordinary R/B/Y Pokémon incorrectly falling into `DETAIL SAFE MODE`.
- Root cause was an early `getPokemonNuzInfo()` closure referencing the later local `Identity` module; Lua resolved a nil global before `pcall` could catch anything.
- The public NUZ INFO model now performs self-contained read-only shiny detection from explicit flags or the engine Stats DV predicate.
- Shortened only the constrained native Catch Info row label from `LOCATION` to `LOC.`.
- Added glyph-safe right-column fitting to R/B/Y native NUZ INFO rows to prevent label/value overlap.
- No gameplay shiny logic, legality rules, encounter behavior, save schema, Compatibility API number, package tree, or engine range changed.

# 2.3.26 RC — stabilization-only UI pass

- Direct child of 2.3.25 RC.
- Runtime report isolates the remaining ENC TRACKER crash to Wide Menus integration, not old Modern UI.
- Removed tracker-specific `wide-menus` detection/delegation.
- Removed the 20-vs-38-column Wide Menus draw branch.
- R/B/Y ENC TRACKER now always owns its 304x144 surface and 38-column box and marks itself classic/non-auto-widenable.
- Gold tracker presentation remains unchanged.
- Changed only the constrained shop-row Forgiveness Token label from `FORGIVE TOKEN` to `F. TOKEN`.
- Forgiveness Token price, quantity, purchase behavior, rule logic, dialogue, and descriptive naming are unchanged.
- No new gameplay features, save-schema change, Compatibility API-number change, package-tree change, or engine-range change.

# 2.3.25 RC — storage + encounter-information compatibility pass

- Direct child of 2.3.24 RC.
- Reviewed FAFF0x Advanced Box System 1.1.0 and Pokédex Plus 1.3.4.
- Upgraded `pcPolicy` to storage transaction API 2 with semantic WITHDRAW / DEPOSIT / RELEASE / SWAP normalization.
- Direct party/box SWAP now receives the same incoming-Pokémon legality check as WITHDRAW.
- Added begin/commit storage transaction events for provider-neutral composition.
- Added final composed encounter-registry information contract.
- Added Randomizer Info selector: OPEN INFO / BLIND INFO, default OPEN for backwards compatibility.
- BLIND INFO hides undiscovered randomized table data only through cooperative information APIs; it never alters the gameplay registry or encounter generation.
- No FAFF0x-specific runtime branches, save-schema change, Compatibility API-number change, package-tree change, or engine-range change.

# 2.3.24 RC — IronMON / Enemy HP upstream-resolution pass

- Direct child of 2.3.23 RC.
- Re-ran canonical-upstream discovery for historical IronMON Ultimate and Enemy HP compatibility entries.
- Confirmed surviving evidence only identifies IronMON Ultimate 0.4.20 as an evaluated package and Enemy HP as an uploaded/runtime-tested archive.
- GitHub, public-web, and File Library searches did not resolve trustworthy current Gen1Recomp repositories for either historical package.
- Kept the historical `ironmon_ultimate` provider ID compatibility path intact.
- Did not conflate the actively maintained community IronMON Ultimate challenge rules with the unresolved Gen1Recomp mod source.
- No gameplay, compatibility API, save schema, package tree, or engine-range changes.

# 2.3.23 RC — compatibility ledger consolidation

- Direct child of 2.3.22 RC.
- Consolidated the compatibility documentation into one canonical current ledger.
- Normalized current reviewed entries for Pokemon Snag 0.15.9, Too Many Balls 0.6.1, Translation Generator 0.7.0, Shiny Pokemon 1.0.1, Weather FX 2.6.0, and Gen 3 Inspired UI Overhaul 2.0.0.
- Explicitly marks IronMON Ultimate and Enemy HP as historical-package-only until their current canonical upstreams can be resolved and reviewed.
- Added compatibility-ledger policy separating source-reviewed, release-reviewed, expected-compatible, runtime-PASS, and historical evidence.
- No gameplay, UI behavior, API, save schema, package tree, or engine-range change.

# 2.3.22 RC — generic UI-overhaul compatibility contract

- Direct child of 2.3.21 RC.
- Reviewed absol89's Gen 3 Inspired UI fork (1.4.1) and the current HighDrexler parent (2.0.0).
- Added additive `nuzlocke_ui` API 1 describing Nuzlocke custom-screen presentation roles, state ownership, preferred layout, native fallback and semantic-adapter safety.
- NuzlockeConfigScreen and NuzlockeTrackerScreen now carry the same generic presentation metadata on their live screen instances.
- No Gen-3-UI-specific rule branch, gameplay ownership change, screen replacement, save-schema change, Compatibility API number change or package-tree change.

# 2.3.21 RC — Weather FX compatibility-learning pass

- Direct child of 2.3.20 RC.
- Reviewed Weather FX 2.6.0 release behavior.
- Added `map.entered` reconciliation for transient Dungeon Lock-In ownership so out-of-band map/teleport providers cannot leave a stale dungeon lock record active in the save.
- Reconciliation validates against the actual current dungeon family and also clears state when Nuzlocke/Dungeon Lock-In is disabled.
- Exported the reconciliation helper through the existing compatibility surface.
- No Weather-FX-specific enforcement branch, rule semantics, save-schema, Compatibility API number, package tree, or engine-range change.

# 2.3.20 RC — translation/performance compatibility learning pass

- Direct child of 2.3.19 RC.
- Reviewed gen1recomp-translation-mod-generator 0.7.0 and Shiny Pokemon 1.0.1.
- Added `nuzlocke_translation.sources()` and `catalog()` so translation tooling can enumerate live Nuzlocke section titles, rule names, short names, and descriptions from canonical rule definitions.
- ENC TRACKER now performs projection/cleanup/row preparation once per update and shares one read-only snapshot across native R/B/Y, Gold, and Modern UI presentation.
- Modern UI tracker model generation no longer mutates tracker/save state itself.
- Existing tracker-row helpers keep their original maintenance behavior for non-screen callers.
- No rule semantics, save schema, Compatibility API number, package tree, or engine range changed.

# 2.3.19 RC — recent-mod compatibility pass

- Direct child of 2.3.18 RC.
- Reviewed Pokemon Snag 0.15.9 and Too Many Balls 0.6.1.
- Added first-class `trainer_capture` acquisition semantics, including SNAG/TRAINER_CATCH aliases.
- Cooperative No Catching policy now covers trainer-capture attempts.
- Tracker provenance labels successful trainer-battle captures as `trainer_capture`.
- Public Item API now classifies custom Balls with the same semantic detector used by enforcement instead of a vanilla Ball ID list.
- Added descriptive legacy auto-compat hints for trainer-capture and custom-Ball providers.
- No mod-ID-specific enforcement branches, files, save-schema, or engine-range changes.

# 2.3.18 RC — smaller-risk presentation bug-fix pass

- Direct child of 2.3.17 RC.
- Fixed the R/B/Y Difficulty profile row's nil fallback displaying profile index 1 instead of VANILLA/index 0.
- Shared Nuzlocke marquee text now scrolls by engine font glyph spans rather than raw Lua bytes, preventing split UTF-8 translation characters.
- Recover Catches route-name fitting is now glyph-span safe.
- MOD COMPAT native fitting no longer byte-truncates translated text when font span helpers are unavailable.
- No rule, battle, save, encounter, provider, startup, API, schema, or package-tree changes.

# 2.3.17 RC — small bug-fix pass

- Direct child of 2.3.16 RC.
- Gold status/rule labels now clip with engine font glyph spans and pixel width instead of raw Lua byte counts, avoiding split UTF-8 translation characters.
- Gold egg provenance no longer registers or marks a synthetic UNKNOWN area as visited when current map resolution fails; UNKNOWN remains provenance-only.
- Removed a dead delegated-learnset condition after the authoritative-provider early return.
- No gameplay-rule, file-tree, API, or save-schema changes.

# 2.3.16 RC — medium-risk bug-fix pass

- Direct child of 2.3.15 RC.
- Completed nil-area capture-policy hardening in the actual catch path.
- Explicit gift/trade/prize provenance now outranks fallback starter heuristics.
- Repaired the logically unreachable duplicate-starter catch fallback.
- Gold Physical/Special Split now scopes temporary type/category changes to copied per-call damage data.
- No new features, files, API version, or save-schema changes.

# 2.3.15 RC — full bug-fixing pass

- Direct child of 2.3.14 RC.
- Fixed manual 8-digit Random Seed editing being coerced to boolean/0.
- Live Random Seed changes now re-project Nuzlocke-owned encounter and learnset randomization.
- Fixed Gold Egg Encounter and Bug Contest enum controls collapsing through the boolean setter path.
- Added semantic Gold labels for Egg Encounter and Bug Contest selections.
- Hardened external randomizer ownership: every delegated learnset provider now prevents Nuzlocke from restoring a stale local snapshot.
- Hardened capture legality when a custom/provider battle has no area key: only area-specific checks fail open; location-independent restrictions remain enforceable.
- Preserves 2.3.14 hold-B Running Shoes and ENC TRACKER/Wide Menus ownership behavior.
- No files added or removed; save schema remains 4; Compatibility API remains 27.

# 2.3.13 RC — ENC TRACKER hotfix candidate

- Direct child of the published 2.3.12 release.
- Corrects the diagnosis of the 2.3.12 ENC TRACKER crash: it reproduces with Modern UI disabled, while Wide Menus was observed to prevent it.
- R/B/Y ENC TRACKER now requests the same 304x144 UI surface that Wide Menus supplied on the working path.
- R/B/Y tracker full-screen box expands from 20 to 38 tiles to match that surface.
- Gold tracker presentation remains native 20x18 / 160x144.
- No tracker data, save, rule, input, boot-lifecycle, Compatibility API, or save-schema changes.
- Runtime validation required before promotion.

# 2.3.12 — final release

- Direct child of 2.3.11 RC.
- Promotes the runtime-tested 2.3.11 boot-safe full-feature code path to the final 2.3.12 release.
- No intentional gameplay/rule/save/API behavior changes from 2.3.11.
- Yellow + Gen1Recomp 0.1.98 runtime PASS: title boot, fresh-game SETUP, SETUP → NEW GAME, existing SAVE GAME load, and fresh-game-only SETUP gating.
- Gold NEW GAME runtime PASS on the same release-candidate code path.
- Preserves lifecycle-safe heavy-runtime activation at `game.ready`, lazy Stats/Growth loading, dormant legacy title fallback, and deferred optional Modern UI/Pokégear first-pass installation.
- Preserves the 2.3.2 Gold trainer-battle Ball-policy scoping correction.
- Corrects 2.3.11 documentation lineage: 2.3.11 descended from 2.3.10, with 2.3.9 used only as a boot-confirmed comparison point.
- No files added or removed; save schema remains 4; Compatibility API remains 27; engine support remains `>=0.1.86 <0.1.99`.
- Corrected after release: ENC TRACKER can crash with Modern UI disabled; Wide Menus was observed to mask the crash, so Modern UI is not established as the cause.

# 2.3.11 RC — full 2.3.0 feature restoration + Yellow 0.1.98 boot-safe initialization

- Direct child of 2.3.10 RC; 2.3.9 was the last boot-confirmed comparison point, and 2.3.0 was reference material only.
- Runtime ledger carried forward: Yellow 2.3.7 PASS to title; 2.3.8 PASS to title with the normal initializer; 2.3.9 PASS to title and public custom-setup screen.
- Restored the complete feature/rule/QoL/API surface that was present in the original 2.3.0 RC, including Skip Opening Intro and Quick Nuzlocke Start.
- Preserved the public `ui.title_menu.items` setup path proven by 2.3.9 and keeps the legacy `title_setup_compat.lua` engine-internal fallback dormant on startup.
- Replaced eager pre-title `src.pokemon.Stats` and `src.pokemon.Growth` imports with lazy, protected resolution at their actual use sites.
- Deferred No Day Care, Gold difficulty mechanics, item/field policy adapters, field-command patches, Center/Game Corner/shop gates, and Gold gameplay adapters to existing lifecycle retry points instead of installing them before title.
- Default-name adapters are installed when NEW GAME is selected and again at `game.ready`, avoiding pre-title OakSpeech/Gold World imports while preserving the feature.
- Gold title dispatch installation is requested only when the public title hook has identified Gold rather than probing Gen II menu modules on every game at startup.
- Preserved the 2.3.2 Gold trainer-battle Ball scoping fix: capture rules do not replace native trainer-battle Ball behavior.
- No files added or removed; save schema remains 4; engine support remains `>=0.1.86 <0.1.99`.
- Runtime validation is required before treating 2.3.11 as release-ready.

# 2.3.9 RC — public Yellow title/setup UI diagnostic

- Direct child of 2.3.8 RC.
- Yellow + Gen1Recomp 0.1.98 + Nuzlocke 2.3.8 only: **runtime PASS to title**.
- The absent Nuzlocke Setup row in 2.3.8 was expected because setup registration remained disabled.
- Restores only `src.core.Strings`, one minimal `NuzlockeConfigScreen`, and the public `ui.title_menu.items` hook that inserts SETUP before NEW GAME when CONTINUE is absent.
- Does **not** load `title_setup_compat.lua`, save/setup-profile state, gameplay events, rule enforcement, randomizers, or other split integrations.
- Test target: Yellow 0.1.98 should boot, show SETUP on a fresh title menu, open the diagnostic setup screen, allow basic cursor input, and return with B.

# 2.3.8 RC — initializer-boundary diagnostic

- Direct child of 2.3.7 RC.
- Yellow + Gen1Recomp 0.1.98 + Nuzlocke 2.3.7 only: **runtime PASS to title**.
- Restores only the normal `return function(mod) ... end` initializer execution model from 2.3.6.
- The initializer performs static export-table assignments only.
- No engine-module `require()`, event registration, save/storage access, hooks/patches, content writes, title modifications, or split integrations execute.
- Diagnostic only; gameplay remains intentionally disabled.
- No files added or removed.

# 2.3.7 RC — boot-safe loader diagnostic

- Direct child of 2.3.6 RC.
- Yellow 2.3.6 recorded as pre-title runtime FAIL.
- Replaced active `main.lua` execution with inert diagnostic exports only.
- No engine-internal requires, gameplay hooks, content writes, UI hooks, or split integrations execute.
- Package tree, manifest permissions, optional dependencies, game targets, and 0.1.98 engine range remain unchanged so the test isolates loader/package compatibility.
- Diagnostic only; gameplay is intentionally disabled.
- No files added or removed; save schema documentation remains historical and no save migration runs.

# 2.3.6 RC — pre-2.3 behavior compatibility probe

- Direct child of 2.3.5 RC.
- Yellow 2.3.5 recorded as pre-title runtime FAIL.
- Restored specific installer definitions/timing from the directly compared pre-2.3 baseline.
- Restored the existing title Setup compatibility fallback; this is separate from the deferred opening-intro shortcut.
- Repaired the accidentally removed `ItemPolicy.install()` definition from 2.3.3-2.3.5.
- Removed remaining 2.3-only Gen II healing-classifier additions for this diagnostic.
- Skip Opening Intro and Quick Nuzlocke Start remain removed.
- No files added or removed; save schema remains 4.

# 2.3.5 RC — 0.1.98 executable compatibility bisect

- Direct child of 2.3.4 RC.
- Yellow 2.3.4 recorded as pre-title runtime FAIL with all other mods disabled.
- Intro skip and Quick Start remain removed and are no longer the leading crash hypothesis.
- Temporarily disabled the executable 2.3.x public battle/contextual-field integrations and broad Gold item-policy additions while keeping 0.1.98 in the manifest range.
- Kept 2.3.3's safer deferred installer timing.
- No files added or removed; save schema remains 4.

# 2.3.4 RC — defer startup shortcuts / Yellow boot isolation

- Direct child of 2.3.3 RC.
- Removed active **Skip Opening Intro** implementation and setup control.
- Removed active **Quick Nuzlocke Start / Start With Poké Balls** implementation and setup control.
- Removed their Oak-speech step filtering, one-shot save staging, progression reconciliation, warp/nickname transaction, delegation entries, Gold exposure, and world-building text.
- Kept **Default Names** and **Skip Catch Demo** intact.
- Kept all unrelated 2.3.x Gen1Recomp 0.1.98 compatibility fixes.
- Yellow 2.3.3 pre-title crash recorded as runtime FAIL; 2.3.4 requires a title-screen-only retest.
- No files added or removed; save schema remains 4.

# 2.3.3 RC — Yellow pre-title boot-safety isolation

- Direct child of 2.3.2 RC.
- 2.3.0, 2.3.1, and 2.3.2 recorded as Yellow pre-title runtime FAIL on Gen1Recomp 0.1.98 with other mods disabled.
- Disabled invocation of the legacy 0.1.86 TitleState fallback; public `ui.title_menu.items` remains authoritative.
- Deferred non-title engine-internal installers until map/save/battle lifecycle points.
- No files added or removed; save schema remains 4.

# 2.3.2 RC — Gold trainer-ball policy scoping

- Clarified that `wide-menus` remains an intentional optional dependency for passive classic-layout coexistence; the historical 304px claimed-wide adapter remains disabled.

- Direct child of 2.3.1 RC.
- Gold's broad 0.1.98 battle-item denial pass now skips Balls entirely; the existing catchable-battle branch is the sole owner of Ball/capture policy.
- Prevents `No Catching` or other capture-specific Nuzlocke text from replacing native trainer-battle Ball behavior.
- Uses dynamic `ItemPolicy.isBall(...)` classification so custom/merged Ball records follow the same scope.
- Corrected `contextual_field_actions` seam metadata from `compose` to `transitive_native_guard`; Nuzlocke does not wrap `mod.world:useFieldAction` directly.
- No files added or removed. Save schema remains 4.

# 2.3.1 RC — Gen1Recomp 0.1.98 compatibility + public API hardening

- Direct child of 2.2.21 RC; no older branch restored.
- Source-audited Gen1Recomp v0.1.98 and widened manifest support to `>=0.1.86 <0.1.99`.
- Audited marker moved to `0.1.98`; added explicit 0.1.94/0.1.98 engine compatibility profiles.
- Added `battle_classifier.snapshot()` using the engine's detached `mod.battle:snapshot()` facade; existing classifier API number remains 1 and enforcement still uses established veto/event seams.
- Compatibility reports now include public-engine feature availability for battle snapshots/intents and contextual field actions.
- Added deep R/B/Y and Gold field-action guards so No Fishing also governs `mod.world:useFieldAction("fish")` and registered/direct field-item execution.
- Added `BERRY_JUICE`, `RAGECANDYBAR`, and `SACRED_ASH` to Gold field-healing policy coverage.
- Gold `BattleState:useItem` now honors every `evaluateItemUsePolicy` denial, fixing No Healing Items / No X Items fallthrough while retaining downstream species/static/type capture legality checks.
- Updated Gold nickname/item compatibility metadata for the 0.1.98 native paths.
- No save-schema, permission, dependency, or package-tree change; runtime validation required.

# 2.2.21 RC — Quick Nuzlocke Start

- Direct child of 2.2.20 RC; no older branch restored.
- Added NEW GAME-only **Quick Nuzlocke Start** under QoL; default OFF.
- Quick Start implies the local opening-intro/name shortcut, then waits for the native fresh world before reconciling story state.
- R/B/Y start at Pallet's Route 1 side with a level-5 starter, Pokédex, post-Pokédex Oak/Viridian state, and at least 5 Poké Balls; a larger configured Start Balls amount remains authoritative.
- The optional first Route 22 rival is deliberately left unbeaten/available and no early route encounter is consumed.
- Yellow restores the Pikachu-follower baseline without inventing a skipped lab-Rival battle result.
- Gold preserves InitClock, anchors the skipped weekday prompt to the host weekday, reconciles Mom/Pokégear/Elm starter/Mr. Pokémon/Pokédex/first Cherrygrove Rival/police/Mystery Egg return state, grants the mandatory Potion plus 5 Poké Balls, and starts at New Bark's Route 29 exit.
- Gold preserves the native Cherrygrove whiteout destination established by `blackoutmod` until a later Pokémon Center replaces it.
- Gold Guide Gent/Map Card, Mom banking, Route 29 encounters, and the Route 29 catch tutorial remain optional/unconsumed; Skip Catch Demo may still suppress the tutorial.
- Nickname Rule is honored by retaining only the starter nickname screen when required.
- Built-in seeded Random Starter is honored and the starter is registered through the normal Nuzlocke provenance path. External starter-provider composition is explicitly TEST REQUIRED when the provider does not also own Quick Start.
- Added Quick Start delegation capabilities `quick_start_provider` / `new_game_progression_provider`.
- Permanent Rule Seal does not govern the QoL shortcut.
- Save schema remains 4; package tree unchanged. Runtime validation required on Red, Blue, Yellow, and Gold.

# 2.2.20 RC — opening intro skip

- Direct child of 2.2.19 RC; no older branch restored.
- Added NEW GAME-only **Skip Opening Intro** under QoL; default OFF.
- Uses the upstream `intro.oak_speech.build` named-step hook instead of replacing New Game or setting progression flags.
- R/B/Y retain only hidden player/Rival name steps, which resolve through the existing canonical Default Names adapter.
- Gold retains `init_clock` plus the hidden player-name step; its later Rival naming story remains native.
- Added external ownership capability `opening_intro_skip_provider` / `tutorial_qol_provider`.
- Permanent Rule Seal does not affect the QoL option.
- No files added or removed; save schema remains 4.

# 2.2.19 RC — seeded structured randomizer

- Direct child of 2.2.18 RC; no older branch restored.
- Added an 8-digit shareable `Random Seed`; `00000000` means AUTO until a Nuzlocke-owned randomizer is enabled.
- Added deterministic RNG algorithm v1 with independent STARTER / ENCOUNTERS / LEARNSETS streams keyed by semantic slot identity.
- Seeded starter previews no longer depend on which starter ball is inspected first.
- Added Starter Style: ANY / 3-STAGE / BASE / SIM BST.
- 3-STAGE is derived from the live merged `evolutions[]` graph rather than a hardcoded species list.
- Added Encounter Balance: CHAOS / SIM BST / EVO / BALANCED.
- Similar-BST matching uses the live merged BST with ±15% tolerance and a minimum absolute tolerance of 25.
- EVO stage classification is `single/base/middle/final`; BALANCED prefers both BST and stage and relaxes only when the live pool has no candidate.
- Random Encounter structure remains untouched: species change, native levels/rates/time/fishing/tree/map slots do not.
- Existing pre-seed persisted encounter/learnset/starter choices are preserved when valid during upgrade rather than silently rerolled.
- `mod.exports.randomizer` remains API 1 and additively exposes `rngVersion` plus `seed(create)`.
- NUZ STATUS / Gold status rule lists show `RNG ######## v1` while a Nuzlocke-owned randomizer is active.
- External randomizer delegation remains authoritative.
- Save schema remains 4; package tree unchanged. Runtime validation required.

# 2.2.18 RC — rule-interaction hardening

- Direct child of 2.2.17 RC; no older branch restored.
- Failed Encounter arming now consults the authoritative capture policy so absolute capture bans, species/BST restrictions, Solo, Dupes, and consumed-area state cannot be converted into an unintended failed-area burn.
- Shiny Clause no longer indirectly changes Failed Encounter handling for encounters that another absolute rule already forbids.
- Gold encounter provenance now distinguishes grass, surf/water, and successful fishing. Time Split applies only to grass plus legacy `wild` records, not new water/fishing encounters.
- Random Starter candidate generation and persisted-choice validation now respect run-wide Type Lock, glitch, Legendary/Mythical/Pseudo, and Maximum BST legality. No Catching intentionally does not apply to the received starter.
- Automatic Default Names and Skip Catch Tutorial now yield completely to delegated external owners even when carried/stale local NEW GAME state remains ON.
- Fresh-save PC Vitamins and PC Heal Items skip their local grant when the corresponding starting-resource capability is delegated, preventing double grants.
- Synchronized stale public sub-API build stamps and corrected Forgiveness Token help text from Gym Trainers to Gym Leaders.
- Egg-hatch species-rule handling remains an explicit policy gap; no destructive hatch rollback was added.
- Save schema remains 4; package tree unchanged. Runtime interaction validation required.

# 2.2.17 RC — external Difficulty stacking warnings

- Direct child of 2.2.16 RC; no older branch restored.
- Game Difficulty now prepends a visible warning whenever an active external trainer/difficulty mod is not the selected exclusive provider.
- VANILLA explicitly warns that it disables only Nuzlocke's built-in transforms and does not disable Stronger Trainers or another external trainer mod.
- Built-in historical/NUZ MEDIUM profiles show **STACK WARNING** when an external trainer mod remains active underneath the composed trainer party.
- Selecting one external `[MOD]` provider while another trainer provider is active shows **MULTI-MOD WARNING**.
- Selecting Stronger Trainers `[MOD]` removes the Stronger-Trainers warning; selection remains manual and Nuzlocke never silently changes Difficulty ownership.
- Known historical providers (`stronger_trainers`, `ironmon_ultimate`, `indigo_conference`) are now queried directly through `mod.find` in addition to status/discovery scans.
- Save schema remains 4; package tree unchanged. Runtime UI/combination validation required.

# 2.2.16 RC — Gym Team Size + translation compatibility

- Direct child of 2.2.15 RC; no older branch restored.
- Added **Gym Team Size** under Battle Mechanics. When enabled, only the actual next Gym Leader battle is gated, and the player's active usable roster may not exceed the Leader's live composed party size. Fewer Pokémon remain legal.
- The Gym Team Size limit reads the live merged/composed trainer party rather than a hardcoded species/count table, allowing compatible trainer-party providers to change the Leader roster. Ordinary Gym Trainers are unaffected.
- R/B/Y matches the exact `start_battle trainer/class/party` command for the next Leader. Gold matches the loaded native Gen 2 trainer before `startbattle`, covering Johto and Kanto Gym Leaders but excluding Red.
- Gym Team Size defaults OFF; HARDCORE and IRONMON enable it, while NUZLOCKE and SOLO leave it OFF.
- Added known localization-companion diagnostics for `gen1_pt-br` 0.1.4 and `finnish` 0.1.0 without taking localization ownership.
- MOD COMPAT preserves a translated full semantic label before using compact English aliases and reports detected translation companions/known PT-BR layout overrides.
- Confirmed semantic shop enforcement remains localization-safe; no Portuguese/Finnish BUY/SELL literals were added to Nuzlocke.
- Reduced the inherited maximum nested upvalue count from the 2.2.15 hard-ceiling value of 48 to 47 by routing late Gym Guide refresh through the existing internal export namespace.
- Save schema remains 4; package tree unchanged. Runtime validation required.

# 2.2.15 RC — save migration coordinator hardening

- Direct child of 2.2.14 RC; no older branch restored.
- Centralized persisted-data upgrades into deterministic phases: **schema → semantic → reconstruction → projection**.
- Replaced the numbered schema `if/elseif` chain with explicit destination-version migrators for schema 1 through 4. A future schema bump with no registered migrator now fails with the exact missing `vN`.
- Moved the retired Ball-ban/No Catching correction into the named semantic phase without changing its ambiguity-preserving behavior.
- Moved retired blanket Route Splits translation out of `reprojectEncounterAreas()` and into the named semantic phase. Projection now only projects preserved encounter provenance.
- Centralized legacy `hardcore_mode` / `elite_four_caps` → `level_cap_scope` persistence; read-time conversion remains only as a defensive fallback.
- Registered legacy Rule Lock / dormant Permanent Rule Seal reconciliation as a named semantic step while retaining `game.ready` runtime enforcement.
- Registered tracker recovery and lazy persistent Pokémon identity assignment as `reconstruction/tracker_identity_reconstruction`.
- Registered encounter-area rebuilding as `projection/encounter_area_projection`; removed their separate `save.loaded` migration listeners.
- Added an inspectable internal `saveUpgrade.lastRun` report with completed step IDs and exact failure phase/step.
- A save from a schema newer than this build now safely stops the upgrade pipeline before reconstruction/reprojection rather than applying older assumptions to newer persisted data.
- Save schema remains **4**; no existing rule keys or migration markers were removed.
- No package files added or removed.

# 2.2.14 RC — Gen 2 Randomizer+ compatibility

- Added a Gold-specific source adapter for `gen_2_randomizer_plus`.
- Nuzlocke now delegates Random Starter, Random Encounters, and Random Learnsets
  only when Randomizer+'s corresponding source-confirmed setting is actually ON.
- External Randomizer+ ownership no longer risks Nuzlocke repainting its own
  encounter-table snapshot over the active Gold randomizer.
- Wild encounter/catch provenance now records Randomizer+ as the encounter
  provider even though Randomizer+ does not export the generic Nuzlocke provider
  contract.
- Challenge-policy ownership remains with Nuzlocke: encounter limits, Failed
  Encounters, Dupes, type locks, capture legality, and tracker state continue to
  evaluate the Pokemon that actually enters battle.
- No assumptions are made about the private implementation of the v2.6 Wilds of
  Kanto compatibility layer; Nuzlocke consumes its final battle identity.
- No files added or removed.



## 2.3.11 RC

- Direct child of 2.3.10 RC; no rollback or wholesale branch restoration.
- Preserves the full restored 2.3.0 RC feature surface.
- Moves the first large runtime installation phase from entry-chunk execution to `game.ready`, after Gen1Recomp services initialize.
- Defers the optional Modern UI kerning/provider first pass and Pokégear provider first pass to lifecycle events instead of mod-load time.
- Keeps 2.3.10 boot protections: lazy Stats/Growth, deferred legacy title fallback, deferred Default Names/field/shop adapters, and the corrected Gold trainer-battle Ball policy.
- Yellow 0.1.98 boot result: TEST REQUIRED.


## Gold-native features

- Added Gold **Time Split** encounter projection with morning/day/night provenance and safe reprojection of existing encounter history.
- Added **Roamer Clause** with persistent species-specific encounter slots and free failed roamer meetings.
- Added **Egg Encounter** policies: OFF / RECEIVED / HATCHED / GIFT.
- Added **Bug Contest** policies: NORMAL / EXEMPT / SLOT, finalized from Gold's native `bug_contest.scored` seam.
- Added **Headbutt Split** using Gold's native Headbutt battle path.
- Added optional **Radio Nuzlocke** World Building through the existing Pokegear presentation provider; native station behavior remains owned by Gold.
- All new Gold rules default OFF/NORMAL and preserve R/B/Y behavior.
# 2.2.12 — complete built-in Difficulty RC

- Direct child of 2.2.11 RC; no older branch was restored.
- Expanded every built-in Game Difficulty profile beyond level/Stat EXP/DV metadata into live trainer-party transformations.
- Added separate ordinary/boss level scaling so boss-cap previews continue to follow the same composed party actually fought.
- Fixed 2.2.11 in-place trainer-party scaling: built-in Difficulty now transforms a copied party, so previews/repeated battles cannot compound levels or mutate shared provider/registry rows.
- Added deterministic type-preserving trainer roster upgrades from the live merged species registry; rival species are protected as story state.
- Added profile moveset optimization using each active species' merged level-up and, at higher tiers, compatible damaging TM/HM move pools. Existing provider moves remain candidates instead of being discarded before composition.
- Added real Gen 1 AI tiers using the engine's native LAYER_1/LAYER_2/LAYER_3 scoring pipeline.
- Added real Gold AI tiers by augmenting each battle's copied TrainerClassAttributes AI bitfield; no shared trainer registry is mutated.
- SHIN HARD*/SHIN-STYLE* and POLISHED* disable player badge battle boosts; Gen 1 clears only the battler's copied badge set, while Gold uses guarded per-battle engine-method wrappers keyed by the profile flag.
- Fixed unobserved Gold `gen2Trainers` NEXT CAP preview to apply the selected built-in boss level multiplier before the fight; observed composed parties still win once available.
- Added Gold profile held items using native held-item fields, while preserving any item already supplied by the base/provider party.
- Fixed Gold trainer Stat EXP/DV recalculation to use `src.battle.gen2.Mon.refreshStats` for split Special Attack/Special Defense records.
- Trainer creation now has one deterministic owner: VANILLA permits the separate Nuzlocke Trainer Stat EXP/DV controls; a built-in Difficulty profile owns those stats itself; an external Difficulty provider is left untouched.
- External difficulty-provider selections remain fully authoritative and skip all Nuzlocke built-in party/stat/AI transformations.
- Physical/Special Split remains independent under Battle Mechanics and is never implicitly enabled by POLISHED* or another Difficulty profile.
- Static/mock validation: all five Lua files compile/parse; copy-on-compose and repeat-construction stability PASS; Gen 1/Gold native-AI application PASS; Gold pre-battle cap scaling/observed precedence PASS.
- Compiler-pressure comparison to 2.2.11 is unchanged at 47 max nested-function upvalues and 128 max nested-function locals; no new function crosses either warning line.
- Package tree remains exactly 15 existing files; no additions/removals.

## 2.2.11 RC — Difficulty implementation audit
- Audited every built-in Game Difficulty profile against its live code path.
- Fixed built-in trainer Stat EXP and perfect-DV settings: these fields were previously attached as metadata by `trainer.party` but were not consumed by trainer construction.
- Built-in Difficulty now owns trainer starting Stat EXP/DVs independently of the Nuzlocke master switch and independently of the manual Trainer Stat EXP / Perfect Trainer IV controls.
- External difficulty providers retain ownership of their constructed Pokemon; Nuzlocke does not overwrite their trainer stats.
- Removed the inert built-in AI labels (`smart`/`strong`/`max`). The current engine/provider path did not consume those labels, so documentation no longer implies an AI change that is not actually enforced.
- Historical `*` profiles remain explicitly inspired profiles, not byte-identical reproductions. Their currently enforced native dimensions are trainer levels, trainer starting Stat EXP, perfect DVs where selected, and live boss-cap preview through the composed trainer party.

# 2.2.10 — cross-generation pools + Physical/Special Split RC

- Direct child of 2.2.9 RC.
- Added **Species Pool** for Random Starter and Random Encounters: AUTO / GEN1 / GEN2 / BOTH.
- `AUTO` preserves 2.2.9's active merged-registry behavior. `BOTH` targets Generation 1 + 2 species only when complete indexed/generation metadata is actually available.
- Gold Random Encounters now reads/writes the live `gen2Encounters` registry instead of the Gen 1 encounter path.
- Changing Species Pool revalidates persisted starter/encounter rolls so an out-of-pool saved roll cannot bleed into the new selection.
- External encounter-randomizer ownership now relinquishes Nuzlocke's encounter snapshot instead of restoring stale Nuzlocke data over the provider.
- Added optional **Phys/Spec Split**, OFF by default and independent of the Nuzlocke master switch.
- Phys/Spec Split is presented under **BATTLE MECHANICS**, not Game Difficulty.
- R/B/Y uses Gen1Recomp's existing per-move category override while retaining the native single Special stat.
- Gold uses per-move categories for damage stats and also realigns Reflect/Light Screen plus Counter/Mirror Coat physical/special identity.
- No public compatibility API, save-schema, Mod API, engine-range, or package-tree change.
- Runtime validation is required for the new feature paths; 2.2.9 runtime-PASS behavior remains protected.

# 2.2.9 — hardening RC

- Direct child of 2.2.8 RC.
- Project compiler policy adopted: warning at 40 upvalues / 130 locals; hard ceiling 48 upvalues / 160 locals.
- Split the near-limit late-runtime initializer again to create compiler headroom.
- Added a defensive empty-party POKEMON-menu guard for the runtime-confirmed full-wipe CTD.
- Made Dungeon Lock-In's dungeon-to-different-dungeon transition explicit and re-seed destination-family state.
- Removed erroneous Gold Zinc handling and centralized the five native vitamins.
- Clarified Wild-to-caught Player Stat EXP ownership.
- Preserves 2.2.8 dialogue and live Difficulty-cap repairs.

# 2.2.8 — dialogue ownership and live Difficulty cap repair

## 2.2.8 RC
- Direct child of 2.2.7 RC.
- Runtime reproduced duplicated/stiched vanilla Yellow SNES dialogue at World Building Tier 3.
- Removed the global T3 rewrite of vanilla `show_text` / `ask` `\v` continuation text.
- Preserved Nuzlocke-authored T3 formatting/ownership via the existing shared world-text paths.
- Fixed live boss-cap preview for Nuzlocke's own built-in Difficulty profiles by allowing `trainer.party` composition preview when a non-Vanilla internal profile is active.
- Clear observed boss-level cache entries when Difficulty changes at runtime.
- Preserved 2.2.7's split late-runtime closures and kept both phases below the Lua 5.1 upvalue ceiling.
- No file additions/removals, save-schema change, API change, engine-range change, or rule-default change.

# 2.2.7 — confirmed Lua 5.1 upvalue-limit startup repair

## 2.2.7 RC

- Direct child of 2.2.6 RC.
- Runtime error text confirmed the real compiler failure: `_lateRuntimeInit` had **more than 60 upvalues**.
- Corrected the earlier 200-local diagnosis; Lua 5.1's separate per-function upvalue ceiling was the active failure.
- Split the former monolithic `_lateRuntimeInit` into two sequential phases:
  - common/RBY late-runtime installation;
  - Gold/compatibility late-runtime installation.
- Preserved initialization order and reused/cleared the same private export slot between phases.
- Duplicated the tiny `hasHealthyParty` helper inside the Gold phase so no additional main-scope local or cross-phase upvalue is required.
- Preserved Yellow Skip Catch Demo, expanded NUZ INFO, native Pokémon Bois Club chairman walker, and existing protected runtime behavior.
- No file additions/removals, save-schema change, Mod API change, engine-range change, or rule-default change.
- Fresh NEW GAME Setup runtime retest required.

# 2.2.6 — confirmed Lua local-limit startup repair

## 2.2.6 RC

- Direct child of 2.2.5 RC.
- Runtime error screen confirmed that `main.lua` was rejected at compile/load time due to Lua's per-function local-variable ceiling.
- Corrected the incomplete 2.2.5 diagnosis: 2.2.4's extra renderer table was removed there, but 2.2.3 had already introduced another long-lived local helper.
- Converted `skipCatchTutorialRequested` from a local function to an internal `mod.exports.__beta26` function, preserving behavior without consuming another local slot in the giant mod entry function.
- Updated all Yellow/RBY/Gold catch-tutorial skip call sites to use the same internal helper.
- Preserved the 2.2.4 native Pokémon Bois Club walker repair.
- Preserved the 2.2.3 NUZ INFO completeness work.
- No save schema, Mod API, engine range, permissions, rule defaults, or package file-tree change.
- Fresh NEW GAME Setup runtime retest required.

# 2.2.5 — startup/local-limit regression repair

## 2.2.5 RC

- Direct child of 2.2.4 RC.
- Investigated a runtime report that New Game Nuzlocke Setup no longer appeared.
- Confirmed 2.2.4 added one extra long-lived local (`fanClubBryanSprites`) to the already-local-heavy `main.lua`.
- Removed that additional file-scope local to avoid crossing Lua 5.1's 200 active-local ceiling.
- Moved temporary Pokémon Bois Club renderer ownership state onto the chairman NPC itself.
- Preserved the 2.2.4 native-walker behavior and third-party ownership-safe restore semantics.
- No setup logic, save schema, engine range, API version, permissions, or package file tree change.
- New Game Setup runtime retest required.

# 2.2.4 — Pokémon Bois Club native-walker repair

## 2.2.4 RC

- Direct child of 2.2.3 RC; no older branch was restored.
- Confirmed the old `makeBryanBoiRenderer` hand-painted sprite generator was dead code: it had no call sites and its activation flag was never set.
- Kept the newer native-walker design rather than reconnecting the rough custom renderer.
- Tier-3 Pokémon Bois Club chairman now receives a genuine engine `SpriteRenderer`.
- Preferred native sprite candidates match Bryan-at-Home: Gambler first, then Black Hair Boy 1, with a safe same-map native fallback.
- Cached the exact original chairman renderer and restore it when World Building drops below Tier 3.
- Added ownership-safe restoration so Nuzlocke does not overwrite a sprite another mod replaced after the tribute was applied.
- Removed the obsolete pixel-by-pixel Bryan renderer and the unrelated Fan Club sprite flag assignment from Bryan-at-Home.
- Updated current documentation to describe the native-walker tribute accurately.
- No save schema, API version, permissions, engine range, asset set, or player-package file tree change.
- Yellow Skip Catch Demo and expanded NUZ INFO behavior from 2.2.3 are inherited unchanged and still require runtime confirmation.

# 2.2.3 — Yellow catch-demo hardening + NUZ INFO completeness

## 2.2.3 RC

- Direct child of the published 2.2.2 RC; no older branch was restored.
- Left the recently improved shared T3/world-building dialogue ownership path unchanged pending continued runtime testing.
- Hardened Yellow's Pallet Town Professor Oak catch-demo skip against the current upstream flow: Oak creates a level-5 Pikachu wild battle, marks it with `makeOldManDemo("PROF.OAK")`, assigns the normal post-demo callback, then calls `Commands.pushBattle`.
- Unified the NEW GAME Skip Catch Demo query across the staged profile, active mod save, and legacy transient save field so delayed tutorial seams observe the same setting.
- Made the Oak `Commands.pushBattle` wrapper reload-safe instead of permanently trusting the first installed wrapper.
- Existing R/B/Y Viridian `old_man_demo` and Gold Route 29 tutorial skips now use the same setting query.
- R/B/Y NUZ INFO remains on the host-native crash-safe `ListMenu`.
- NUZ INFO now displays enabled Catch/Stat/Move data more completely: shiny state, death cause, legality/BST details, provenance/provider/source fields, and move accuracy are no longer silently omitted.
- NUZ INFO SAFE MODE now reconstructs all enabled pages directly from the selected Pokémon instead of degrading to a small Catch-only block.
- Disabled Catch/Stat/Move pages are explicitly labeled `PAGE OFF`, preventing an intentionally disabled page from looking like missing data.
- No save schema, API version, permission, engine range, or repository/player-package file tree change.
- Runtime TEST REQUIRED for Yellow Pallet Skip Catch Demo and R/B/Y NUZ INFO with all page-toggle combinations.

# 2.2.2 — battle-money label + Yellow runtime ledger

## 2.2.2 RC

- Direct child of 2.2.1 RC; no older branch was restored.
- Renamed compact Trainer Money from `Trnr ¥` to `Btl. ¥`.
- Recorded Yellow 2.1.24 save-game runtime PASS for No Buying.
- Recorded Yellow 2.1.24 save-game runtime PASS for No Selling.
- Recorded Yellow 2.1.24 save-game runtime PASS for No Center Heal / Pokémon Center healing ban.
- No rule mechanics, API/save schema, permissions, engine range, or repository file tree changed.

# 2.2.1 — Gold value-column visual correction

## 2.2.1 RC

- Direct child of 2.2.0 RC; no older branch was restored.
- Gold 2.1.24 runtime testing confirmed the right-aligned Setup/NUZ RULES value column was one native tile too far right and could crowd/clip the frame.
- Preserved the wider ten-tile Gold rule-label field and moved only the live value/toggle anchor one tile left.
- R/B/Y presentation and all rule/enforcement behavior are unchanged.
- Gen1Recomp 0.1.94 audited compatibility, NUZ INFO/MOD COMPAT/NUZ ST. repairs, Yellow catch-demo work, and native Bryan path from 2.2.0 are preserved.
- Runtime visual RETEST REQUIRED for Gold NEW GAME Setup and in-game NUZ RULES.

# 2.2.0 — Gen1Recomp 0.1.94 compatibility and runtime repair rollup

## 2.2.0 RC

- Direct child of 2.1.24 RC; no older branch was restored.
- Renumbered the planned 2.1.25 work to 2.2.0 at user request.
- Source-audited Gen1Recomp v0.1.94 against v0.1.93. The release is 10 commits ahead; reviewed changes are concentrated in launcher/version-aware conflict evaluation plus API-2 one-way `mod.postLog` support (`log_url`, network-gated HTTPS destination). No reviewed gameplay seam used by Nuzlocke changed.
- Updated `recompCompatAudited` to `0.1.94`. Manifest engine envelope remains `>=0.1.86 <0.1.98`; Mod API 2 and save schema 4 are unchanged.
- Deliberately did **not** add `network` permission or `log_url`: Nuzlocke does not require outbound logging to function.
- R/B/Y NUZ INFO now pcall-isolates the API-27 model and its compatibility helpers, provides a direct-Pokémon SAFE MODE fallback, and protects native ListMenu construction so optional diagnostics cannot hard-crash party input.
- R/B/Y MOD COMPAT now uses full semantic labels when Gen1 Modern UI is active and width-bounded compact labels/provider names in the classic ListMenu path.
- R/B/Y NUZ ST. now contains explicit RUN STATUS and ACTIVE RULES heading rows so semantic grouping survives Modern UI and classic presentation.
- Yellow Skip Catch Demo now covers the Pallet Town Professor Oak Pikachu demonstration, which bypasses ScriptRunner and directly calls `Commands.pushBattle`; the demo battle is omitted while the existing onFinish continuation preserves Whew/Come With Me/lab escort progression. Existing Red/Blue/Yellow Viridian `old_man_demo` interception remains.
- Bryan's T3 home NPC no longer swaps in the rough custom true-color renderer. It prefers a native gambler/black-hair-boy walker when available and otherwise a known-good native house walker; the fan-club chairman also keeps native art. No new sprite asset was added.
- Protected runtime PASSes inherited from 2.1.23/2.1.24: Yellow randomized-starter received-name and party delivery, Trainer Money symbol, Setup/Type Locke selector visibility, startup name skip, PC Heal/Rare Candy/Vitamin loadouts, and native Trainer Card.
- Runtime TEST REQUIRED for Gen1Recomp 0.1.94 and every repaired UI/tutorial/Bryan path above.

# 2.1.24 — R/B/Y NUZ INFO native-menu crash repair

## 2.1.24 RC
- Direct child of 2.1.23 RC.
- Yellow 2.1.23 runtime PASS: randomized starter message names the actual received Pokemon; randomized Sandslash appears correctly in party; Trainer Money shows the money symbol.
- Yellow 2.1.23 runtime FAIL: selecting party NUZ INFO crashes.
- R/B/Y NUZ INFO now renders through host-owned `ListMenu` using API-27 `getPokemonNuzInfo()` / `getNuzInfoPages()` data instead of the custom hand-drawn screen.
- Gold NUZ INFO presentation is unchanged.
- Runtime retest required.

# 2.1.23 — systemic T3 dialogue + catch-demo repair

## 2.1.23 RC

- Direct child of 2.1.22 RC; no files added or removed.
- Runtime reports showed the same continuation/stitched-dialogue presentation in Mom, Viridian catch-tutorial, Oak's Lab, and other interactions. Replaced one-off T3 text fixes with a shared World Building paginator used by every Nuzlocke-owned overworld message.
- At World Building T3, ScriptRunner `show_text` / `ask` rows that use Gen1's native `\v` continuation marker are presentation-normalized through the same paginator. Story commands, substitutions, choices, flags, and program-counter flow are unchanged; T0-T2 preserve vanilla continuation behavior.
- R/B/Y Skip Catch Demo is now implemented at the semantic `old_man_demo` command used by Red/Blue and Yellow. Only the demonstration battle is skipped; surrounding vanilla dialogue, completion flags, movement, and object cleanup continue normally. Gold retains its separate Route 29 tutorial seam.
- Gold Setup/NUZ RULES values are now right-aligned to the native screen edge. Short ON/OFF toggles move farther right, rule labels regain a tenth tile, and long money/type values retain up to seven tiles.
- TV's currently runtime-good T3 path remains on the shared World Building presenter and was not replaced with a new special case.
- Runtime validation required, especially Yellow Mom/Lab/tutorial dialogue, R/B/Y catch-demo progression, and Gold Setup spacing.

# 2.1.22 — R/B/Y Nuz menu native-surface repair

## 2.1.22 RC

- Direct child of 2.1.21 RC; no files added or removed.
- Logged Yellow 2.1.21 runtime FAIL: NUZ ST. and MOD COMPAT still hard-crash.
- R/B/Y NUZ ST. now uses the host mod-facing ListMenu and presents caught/death/area/cap status plus the active-rule list.
- R/B/Y MOD COMPAT now uses ListMenu and preserves compatibility ownership rows.
- Removed the two failing R/B/Y paths from hand-drawn custom-state rendering/stack timing; Gold-native status/compat rendering is unchanged.
- Preserved all confirmed 2.1.19 Yellow PASS paths and 2.1.21 Gold Setup spacing.
- Runtime validation required.

# 2.1.21 — Gold Setup spacing cleanup

## 2.1.21 RC

- Direct child of 2.1.20 RC; no files added or removed.
- Gold Setup/NUZ RULES now reserve one native tile between the rule-label field and value/toggle field.
- Preserved the seven-tile Gold value column so money values and longer type labels retain their previous display capacity; only the label field was reduced from 10 tiles to 9.
- Presentation-only change: no rule mechanics, save keys, controls, descriptions, R/B/Y layout, or 2.1.20 menu-recovery behavior changed.
- Runtime visual confirmation required on Gold Setup and Gold in-game NUZ RULES.

## 2.1.20 RC

- Direct child of 2.1.19 RC; no files added or removed.
- Recorded Yellow 2.1.19 runtime PASS: NEW GAME Setup appears; Type Locke selector visibility behaves correctly; automatic default names work; PC Heal/rare-candy/vitamin startup grants work; native Trainer Card opens without the prior crash.
- Recorded Yellow 2.1.19 runtime FAIL: entering a Nuzlocke-owned in-game menu can hard-crash.
- Hardened NUZ RULES runtime recovery so a draw exception is recorded during draw and handled on the next update tick. The old guard could pop the state from inside `draw()`, which is unsafe while the engine is iterating/rendering the StateStack.
- Added the same deferred runtime-failure recovery to the standalone R/B/Y NUZ STATUS screen.
- Moved Game Difficulty out of LEVELS into its own GAME DIFFICULTY section. VANILLA is still the unmodified/OFF-equivalent setting; no difficulty save/API semantics changed.
- UI labels: `Trnr ¥`, `Start ¥`, `No Esc. Rope`, and `Heal Loadout`.
- Re-audited Type Locke legality: OFF returns no allowed-type filter; MONO returns only Type 1; DUO returns only Types 1-2; TRI returns only Types 1-3. Actual runtime acquisition enforcement is still TEST REQUIRED.

- Direct child of `2.1.18 RC`; no older branch was restored.
- Removed the active-generation precondition from Gen1 kerning installation retries. Installation now retries whenever Font is not yet wrapped and no external kerning provider owns the surface; `kerningEnabled()` still gates all visual effect to confirmed Gen1 at call time.
- Hardened Gen1 Modern UI registration so only an explicit `true` from `registerAdapter` counts as success. `nil` or any other non-true value leaves the integration inactive/unregistered with an error state.
- Reworked the R/B/Y title SETUP fallback into one stable wrapper backed by mutable dependency state, preventing Nuzlocke wrapper re-stacking and stale `openSetup`/translation/save-editor closures across hot reloads.
- Added safe migration from the exact 2.1.18 legacy wrapper when it is still directly installed; when another mod sits above that legacy wrapper, the new outer stateful wrapper rebinds the existing Nuzlocke SETUP row to the current callback instead of inserting a duplicate.
- Preserved the runtime save-editor check on every title-menu open; no install-time editor short-circuit was reintroduced.
- No challenge-rule mechanics changed. No files added or removed. Runtime validation remains required.

# 2.1.18 — Yellow runtime hardening: native Trainer Card + dialogue ownership

- Direct child of `2.1.17 RC`; no older branch was restored.
- Logged Yellow 2.1.16 runtime: default-name skip PASS; PC Vitamins starter loadout PASS; opening the Nuzlocke-hijacked Trainer Card FAIL/crash.
- Stopped replacing the native R/B/Y Trainer Card START-menu row. The engine Trainer Card is now upstream-owned again.
- Added a dedicated `NUZ ST.` START-menu entry for R/B/Y, matching Gold's separated status approach. The Gen1 status screen can run in `statusOnly` mode without constructing the native Trainer Card at all.
- Added generic per-ScriptRunner Nuzlocke message ownership so overlapping enforcement/compatibility seams cannot emit two mod-authored denial/flavor boxes for one script transaction.
- Audited the reported bedroom SNES sequence against Gen1Recomp and pret/pokered: the repeated visible line is vanilla `cont` scrolling from `_RedBedroomSNESText`, not duplicated Nuzlocke World Building. Vanilla text scrolling is therefore intentionally preserved.
- Existing `pushWorldText` protection against stacking optional World Building over an active TextBox remains in force.
- No files added or removed. Runtime validation remains required.

# 2.1.16 — Trilocke, Type Locke invariants, rule-section cleanup

- Direct child of `2.1.15 RC`.
- Added **TRI / Trilocke** with a third displayed type selector.
- Type Locke is now explicitly mode-authoritative: OFF = no type restriction and no selectors; MONO = Type 1 only; DUO = Types 1–2 only; TRI = Types 1–3 only.
- Random type resolution and live/staged edits keep every active displayed type concrete and distinct.
- Shared acquisition legality, off-type encounter handling, gifts/trades, starter filtering, and legality reporting all consume the same active Type Locke set.
- Moved **Route Forgiveness** from CORE to CLAUSES and **No Catching** from CORE to GENERAL; mechanics are unchanged.
- Added +1 px micro-tracking to centered bold-like section headers so adjacent glyphs retain separation.
- No files added or removed. Runtime validation remains required.

# 2.1.15 — Rules UI alignment, Type Locke OFF, reversible Rule Lock

- Centered R/B/Y and Gold rule-section headers inside the list area and added subtle bold-like emphasis using the existing pixel font only.
- Shifted ordinary R/B/Y rule labels left to reclaim menu space while retaining the native selection cursor.
- Type Locke OFF now clears and hides both Type 1 and Type 2; MONO keeps Type 1 only; DUO restores two distinct selectors.
- Restored a reversible **Rule Lock** control, separate from the dormant/WIP irreversible **Permanent Rule Seal**.
- Added migration logic for older non-permanent `rules_locked` state when no irreversible seal marker exists.
- No files added or removed. Runtime validation remains required.

# 2.1.14 — Type Locke MONO state/UI repair

- Direct child of `2.1.13 RC`.
- Gold 2.1.12 runtime reproduction: selecting Type Locke MONO left `Type 2` visible.
- MONO now clears the staged/live secondary type and hides the Type 2 row.
- Returning to DUO restores a valid secondary type distinct from Type 1.
- Shared config code means the repair applies to R/B/Y and Gold, Setup and in-game Rules.
- Runtime status: **TEST REQUIRED**.

# 2.1.13 — Yellow/T3 repair candidate

- Direct child of the canonical packaged `2.1.12 RC`.
- Preserved `pokemon.before_give`; upstream 0.1.93 source confirms it runs before `Pokemon.new`.
- Added concrete random-starter runtime-safety validation for species definitions, growth/type data, learnsets, base-stat calculation, and every move the level-5 starter will display.
- Invalid/partial provider species are skipped from the starter pool instead of being allowed to reach Party/Summary UI.
- Added per-script Mom response ownership so normal and fallback No Mom Heal seams cannot stack duplicate rejection boxes.
- Preserved one-time allowed-heal T3 Mom flavor and vanilla dialogue on later visits.
- Removed the Pallet TV `Rule watch:` suffix.
- Added explicit 18-glyph wrapping and page separation for T3 Pallet TV reports.
- Added a real T3 Bryan runtime NPC to `REDS_HOUSE_1F` using the engine NPC object contract and contributed map-script text.
- Added rotating Bryan home dialogue covering “boi”, Gen1Recomp/Nuzlocke coding claims, Pokémon Bois Club, game-console use, and non-explicit Mom/Bryan innuendo.
- No new assets or repository files.
- Gen1Recomp 0.1.93 remains source-audited; manifest envelope remains `>=0.1.86 <0.1.98`.
- Changed paths are parser/static/source-audit candidates only; runtime confirmation remains required.
- Full 15-file repository tree preserved.

# 2.1.12 — Leader-only Forgiveness + compact UI fallbacks

- Direct child of `2.1.11 RC`.
- `Nuzlocke Loadout` compact fallback: `Nuz. Loadout`.
- `Dungeon Lock-In` compact fallback: `Dung. Lock-In`.
- `BATTLE ITEMS` / `FIELD ITEMS` compact fallbacks: `BATTLE ITMS` / `FIELD ITMS`.
- Item-rule compact labels now use `Itms` where useful while preserving full canonical translation strings.
- Removed Route Forgiveness Token awards from ordinary Gym Trainers.
- Added one Route Forgiveness Token on Gym Leader victory, once per Gym.
- Added persistent `route_forgiveness_gym_leaders` ledger keyed by normalized Leader identity.
- The Gym Guide is not an independent token source.
- Removed the obsolete per-trainer reward identity helper.
- Old `route_forgiveness_gym_trainers` save data is left untouched for compatibility but no longer consulted.
- Starting-token modes and token-spending behavior are unchanged.
- Gen1Recomp 0.1.93 audit status and approved marquee cadence are preserved.
- Full 15-file repository tree preserved.

# 2.1.11 — localization-safe labels / Gen1Recomp 0.1.93 audit

- Direct child of `2.1.10 RC`.
- Restored natural full rule/category labels as canonical `Strings.source(...)` translation keys.
- Moved compact menu vocabulary into optional `shortName` / `shortTitle` fields.
- R/B/Y display now chooses full translated text first and only uses a compact label when the full label exceeds the measured pixel budget.
- Translation safety: if the full source has been translated but the short source has not, Nuzlocke keeps/marquees the translated full label instead of inserting an English abbreviation.
- Full descriptions remain unshortened and translation-friendly.
- Preserved the approved 3-second pause / ~2.4s-per-glyph true-overflow marquee cadence.
- Preserved explicit Wide Menus `classic`/`keepClassicUi` fallback.
- Audited Gen1Recomp 0.1.93 against 0.1.92; upstream delta is 14 commits.
- Reviewed 0.1.93 data-loader/default, LegacyCompat, updater/TLS, required-import/mobile, launcher/docs/test changes.
- Updated Nuzlocke's machine-readable audited-engine marker from 0.1.83 to 0.1.93.
- Existing engine range remains `>=0.1.86 <0.1.98`.
- No new permissions, save-schema change, Mod API bump, or gameplay-hook rewrite.
- Full 15-file repository tree preserved.

# 2.1.10 — compact rule-label candidate

- Direct child of `2.1.9 RC`.
- Kept the runtime-approved conditional marquee speed unchanged.
- Kept the explicit Wide Menus classic/native fallback; Wide Menus may be installed without Nuzlocke claiming a wider rules canvas.
- Removed decorative hyphens from collapsible section headers.
- Renamed section headers:
  - AREA SPLITS → ROUTE SPLITS
  - RANDOMIZER → RNDMIZER
- Shortened route-split rows to the route/area name only.
- Applied concise menu abbreviations including:
  - Catching
  - Rt. Forgiveness
  - Rndm Lrnset / Lrnset Gen
  - Twn Catches
  - No Lgndries / No Mythcs
  - Plyr / Wld / Trnr Stat EXP
  - No Stat EXP
  - No Gmblng
  - Trnr $
  - Max. BST
  - Alw. Glitches
  - Gift Mon
  - Ingame Trds
  - Wndrlocke
  - Lvl Cap Scope
  - No Heal Items
  - No Esc.
  - No Rare Cndy
  - Deflt Names
  - PC Vtmn
- Setup `Money` uses `$`; starting Rare Candy and Gym Guide Rare Candy use `Cndy`.
- Internal rule keys, saves, provider contracts, and full descriptions are unchanged.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file repository tree preserved.

# 2.1.9 — explicit Wide Menus refusal / concise core labels

- Direct child of `2.1.8 RC`.
- Recorded current marquee timing as runtime-approved; speed unchanged.
- Shortened common menu labels:
  - First Rival Mercy → 1st Rival Mercy
  - One Per Area → 1 Per Area
  - Failed Encounters → Failed Enc.
- Full rule descriptions remain intact.
- Fixed the remaining Wide Menus coexistence path by explicitly marking every `NuzlockeConfigScreen` as classic/native width.
- Added both `uiModLayout = "classic"` and `keepClassicUi = true`.
- This blocks Wide Menus' automatic widening of opaque mod-owned screens during both fresh Setup and in-game Rules.
- No gameplay, save, provider, or rule-key changes.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file repository tree preserved.

# 2.1.8 — concise-label presentation candidate

- Direct child of `2.1.7 RC`.
- Shortened only obvious Randomizer menu labels to reduce unnecessary marquee scrolling:
  - Random Starter → Rndm Starter
  - Random Encounters → Rndm Enc.
  - Random Learnsets → Rndm Learnset
- Kept full feature meaning in the description box and documentation.
- No rule keys, save semantics, randomizer ownership, provider APIs, or gameplay behavior changed.
- Conditional marquee remains a last resort: fitting text never scrolls.
- Wide Menus remains native-width fallback for Nuzlocke Rules pending a separately validated adapter.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file tree preserved.

# 2.1.7 — Wide Menus coexistence / selection repair candidate

- Direct child of `2.1.6 RC`.
- Recorded Yellow runtime crash when Wide Menus was installed and Nuzlocke claimed its wide layout.
- Disabled the Nuzlocke Wide Menus claim path until a separately validated wide-layout adapter exists.
- Wide Menus can remain installed; Nuzlocke Rules now stays on native width rather than crashing.
- Removed custom outline selection rendering after Yellow displayed only stray colored marks near the divider.
- Restored the engine-native cursor glyph for selected R/B/Y rows.
- Moved the cursor to X=10 and labels to X=22, reclaiming eight pixels compared with the historical X=30 label start.
- Preserved conditional slow marquee: no scrolling for fitting text; 3-second pause and ~2.4s/glyph for true overflow.
- Gold native presentation unchanged.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file tree preserved.

# 2.1.6 — Yellow selection/readability repair candidate

- Direct child of `2.1.5 RC`.
- Recorded Yellow runtime regression: conditional marquee was much too fast.
- Restored the historical slow marquee behavior: 3-second initial pause and ~2.4 seconds per glyph step.
- Fitting text still remains completely static.
- Removed filled reverse-video row selection after Yellow runtime showed selected-row glyphs becoming unreadable.
- Replaced filled selection with a thin outline highlight that does not recolor or cover font glyphs.
- Preserved the reclaimed left cursor gutter and expanded text budget.
- MOD COMPAT true-overflow marquee uses the same slow cadence.
- Gold native presentation unchanged.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file tree preserved.

# 2.1.5 — conditional-marquee / reverse-selection candidate

- Direct child of `2.1.4 RC`.
- Recorded 2.1.4 runtime feedback: pixel-aware static text worked, but ellipsized long rule labels were undesirable.
- Replaced R/B/Y rule/header/value ellipsis behavior with a conditional pixel-aware marquee:
  - fitting text never scrolls;
  - only true overflow scrolls.
- Marquee movement operates on glyph spans rather than raw string bytes.
- Removed the R/B/Y per-row left cursor glyph from the rules list.
- Added reverse-video selected-row highlighting to reclaim the cursor gutter.
- Moved rule labels left and increased their pixel budget.
- Kept descriptions pixel-wrapped/static, with vertical scrolling only for real overflow.
- MOD COMPAT retains collision-safe columns and now scrolls only truly overlong column text rather than ellipsizing it.
- Gold native UI behavior unchanged.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file tree preserved.

# 2.1.4 — pixel-aware presentation candidate

- Direct child of `2.1.3 RC`.
- Recorded Yellow/Gen1Recomp 0.1.92 runtime PASS for active Gen1 kerning/variable-width text.
- Recorded MOD COMPAT crash repair as runtime PASS.
- Replaced R/B/Y Nuzlocke-owned marquee-first rule/header/title presentation with pixel-measured static text.
- Added safe ellipsis for true horizontal overflow rather than continuous marquee scrolling.
- Replaced character-count description wrapping with pixel-width wrapping.
- Descriptions now remain fully static whenever they fit in the three visible description lines; vertical scrolling remains only for real overflow.
- Reworked R/B/Y MOD COMPAT into measured, non-overlapping label/owner columns with safe truncation.
- Preserved Gold native presentation and Gold-specific marquee behavior; this cleanup targets the now-validated Gen1 variable-width path only.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file repository tree preserved.

# 2.1.3 — focused review repair candidate

- Direct child of `2.1.2 RC`; no branch reset or older-tree restore.
- Fixed Gym Trainer Forgiveness ledger-key ambiguity by compacting identity fields separately and joining them after normalization.
- Fixed Gen1 kerning's permanently-false generation gate by injecting the maintained `currentGame` reference into `modern_ui_integration.lua`.
- Updated kerning lifecycle retries to use the same active-game resolver.
- Fixed `compat21.pokemonLegality()` so string-valued `nuzlockeInvalidAcquisition` flags are recognized as `INVALID ACQUISITION`.
- Added `invalidAcquisitionReason` to the legality result so compatibility consumers can distinguish reasons such as `legendary`, `area`, `solo`, `glitch`, or `disabled`.
- Preserved the 2.1.2 MOD COMPAT stale-Draw-module repair.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2 and save schema 4 unchanged.
- Existing 15-file repository tree preserved.
- Runtime PASS behavior from Yellow fresh Setup/boot remains protected.

# 2.1.2 — Yellow 0.1.92 runtime repair candidate

- Direct child of 2.1.1 RC.
- Protected Yellow fresh Setup and boot-to-game runtime PASS.
- Fixed release-blocking R/B/Y MOD COMPAT crash: the screen required stale `src.render.Draw`, which is absent in current Gen1Recomp; it now uses `src.render.Font.drawBox`.
- Hardened Gen1 kerning installation timing by retrying on `game.ready` and `save.loaded` after generation is known.
- Corrected MOD COMPAT TEXT LAYOUT detection to use the implementation's real `_nuzlockeAdvanceOf` marker.
- Gold remains generation-gated from the Gen1 kerning fallback.
- Engine range remains `>=0.1.86 <0.1.98`; Mod API 2/save schema 4 unchanged.
- Full 15-file tree preserved.
- MOD COMPAT and visible kerning behavior remain RUNTIME TEST REQUIRED.

# 2.1.1 — release candidate

- Direct child of `2.1.0`; no lineage reset.
- Source-audited Gen1Recomp 0.1.92 (`v0.1.90..v0.1.92`).
- Expanded engine declaration from `>=0.1.86 <0.1.91` to `>=0.1.86 <0.1.98`.
- 0.1.92 is source-reviewed; 0.1.93–0.1.97 are forward-allowed, not runtime-confirmed.
- Reviewed new sandbox compatibility layer and sanctioned `mod.fetch` / `mod.job` APIs.
- Nuzlocke intentionally requests neither `network` nor `background`: current rules do not require them.
- Confirmed no direct `love.filesystem`, `love.thread`, socket, `mod.fetch`, or `mod.job` use in the shipped Lua tree.
- Removed obsolete mod-card warning about the historical multi-part beta updater tag; 2.1.x now uses ordinary SemVer.
- Mod API remains 2; save schema remains 4; no gameplay-rule migration.
- Wide Menus phase-1 behavior from 2.1.0 remains runtime-test-required.
- Full 15-file tree preserved.

# 2.1.0 — canonical versioning transition

- Renumbered the current canonical `2.0.0-beta.31.0.4` development tree to `2.1.0`.
- No gameplay, save-schema, Mod API, compatibility, UI, or rule behavior changed.
- This establishes ordinary SemVer for future Gen1Recomp GitHub Release/update detection.
- The complete pre-2.1.0 beta lineage remains preserved below as historical development history.
- Full 15-file repository tree preserved.

# 2.0.0-beta.31.0.4 — optional Wide Menus Nuz Rules integration

- Direct child of `.31.0.3`; 15-file tree preserved.
- Added `wide-menus` as an optional dependency using its documented public presentation API.
- In-game R/B/Y `NuzlockeConfigScreen` claims the 304×144 wide layout when Wide Menus is active.
- Expanded the rule-list canvas from 20 to 38 columns, gives rule names/header names additional horizontal room, moves values/status to the right-side column, and expands description wrapping.
- Nuzlocke retains all rule state, input, collapse, numeric-editing, delegation and lock semantics.
- Wide Menus absent/disabled: existing 160×144 native layout remains the fallback.
- Fresh New Game Setup is deliberately excluded from Wide Menus in this first phase.
- Gold is deliberately excluded from Wide Menus in this first phase.
- No save-schema, Mod API, or challenge-rule change.
- Lua parser/static integration checks PASS; visual/input runtime validation remains required.

# 2.0.0-beta.31.0.3 — Mt. Moon Dungeon Lock-In repair

- Direct child of `.31.0.2`; full 15-file tree preserved.
- Fixed the reported R/B/Y case where the Pokémon Center beside Mt. Moon could be classified as the `MT_MOON` dungeon family and trap the player under Dungeon Lock-In.
- Hardened `dungeonFamily()` before prefix matching: Pokémon Center and Poké Mart service-interior identifiers fail open instead of inheriting a dungeon family from a landmark prefix.
- The exclusion is deliberately generic so similarly named dungeon-adjacent service interiors do not reproduce the same prefix-bleed bug.
- Actual Mt. Moon floor identifiers remain classified as `MT_MOON`; existing Dungeon Lock-In entrance/exit behavior is otherwise unchanged.
- Lua parser/static/mock classifier checks PASS; reported Mt. Moon Center scenario remains RUNTIME TEST REQUIRED.

# 2.0.0-beta.31.0.2 — Gen1Recomp 0.1.90 compatibility review

- Direct child of `.31.0.1`; full 15-file repository tree preserved.
- Reviewed upstream `v0.1.89...v0.1.90` changes.
- Confirmed the existing manifest envelope `>=0.1.86 <0.1.91` already admits 0.1.90.
- Upstream 0.1.90 primarily adds orphaned save-slot recovery and generation-aware PartyMenu field-move handling for Gold, plus platform/test hardening.
- Nuzlocke's SaveData use remains on engine-owned `saveFilename`, `activeSlot`, `deleteSlot`, and `persistenceFs` seams; no direct filesystem regression was introduced.
- Gold's new PartyMenu fallback to generic `overworld:useFieldMove(...)` is compatible with Nuzlocke's current rule architecture and is a useful future seam for deeper Dungeon Lock-In field-move hardening.
- No Nuzlocke mechanic required patching for 0.1.90; this build records the reviewed compatibility baseline.
- Lua parser/static PASS; runtime on Gen1Recomp 0.1.90 remains TEST REQUIRED.

# 2.0.0-beta.31.0.1 — lifecycle and progression repair

- Direct child of `.31.0.0`; 15-file tree preserved.
- Synchronizes live `difficulty_profile` changes with staged stable `difficulty_provider_id` state and documents why live changes leave `pendingRulesDirty=false`.
- Makes Modern UI registration generation-safe and one-shot, prevents unknown-game registration, marks the bridge inactive on Gold, and generation-gates model/actions so stale provider registrations cannot present Gen1 UI on Gold.
- Removes the install-time save-editor short-circuit from R/B/Y title Setup fallback so the installed wrapper can re-check editor state on every title-menu open.
- Trainer Rewards now validates `gymProgressKey`, returns `true` after recognized R/B/Y Gym Leader progression, and compares Gym Leader identity fields independently to prevent cross-field concatenation false matches.
- Champion progression already returned `true` in `.31.0.0` and was intentionally left unchanged.
- Lua parser/static checks PASS; runtime validation remains required.

# 2.0.0-beta.31.0.0 — World Building / Bryan expansion

- Direct child of `.30.1.22`; no repository files added, removed, or renamed.
- Expanded Tier 3 Pokémon Bois Club Bryan dialogue.
- Bryan explicitly claims he created the Nuzlocke mod and worked on Gen1Recomp using the player's bedroom computer.
- Tier 3 home flavor establishes Bryan as a recurring houseguest who uses the player's computer and game console.
- Added cheeky, non-graphic Mom/Bryan relationship innuendo at Tier 3.
- Added rotating Tier 3 Pallet TV reports, including sightings of a man resembling the Pokémon Bois Club leader walking Pallet Town and sneaking through windows at night.
- Polished several Tier 3 rule-specific World Building lines for greater contextual variety.
- Added design backlog notes for a future provider-aware Black Market shop and future NPC/rule reactions to achievements. Neither system is mechanically enabled here.
- Lua parser/static validation PASS; new dialogue paths remain RUNTIME TEST REQUIRED.

# 2.0.0-beta.30.1.22 — Tracker / Compat / NUZ INFO intelligence

- Direct child of `2.0.0-beta.30.1.21`; no repository files added, removed, or renamed.
- Encounter Tracker / Area Guide now display compact semantic encounter tags such as WILD, FISH, GIFT, STATIC, TRADE and RNG, with provider context where known. Randomizer information remains spoiler-safe.
- MOD COMPAT now reports a broader effective-ownership map: starter/encounter/learnset RNG, trainer money, level caps, difficulty profile, species metadata, Pokémon identity, encounter provider, escape/warp provider, movement, presentation and text layout.
- NUZ INFO Catch page now reports legality against the **current active rules** plus restriction reasons and provider/source provenance.
- NUZ INFO legality is read-only: it never removes, boxes, edits or reclassifies an existing Pokémon.
- Corrected stale internal build identifiers inherited from `.30.1.21`; all executable build exports now identify `.30.1.22`.
- Lua parser/static validation PASS; new UI behavior remains RUNTIME TEST REQUIRED.

## 2.0.0-beta.30.1.21 — compatibility intelligence and contextual guidance

- Added spoiler-safe external encounter-randomizer ownership context to Encounter Tracker.
- Added the dedicated MOD COMPAT ownership diagnostics screen.
- Expanded translation-safe semantic UI matching.
- Added merged external species metadata access.
- Added adaptive compatibility/tracker presentation helpers.
- Added context-sensitive World Building guidance for consumed areas, Lock-Ins, caps, Forgiveness Tokens, progression catches and externally randomized areas.

## 2.0.0-beta.30.1.20 — Gen1 variable-width Nuzlocke presentation

- Added internal R/B/Y-only variable-width tile-font presentation.
- Gold/Gen2 is hard-excluded from the Gen1 glyph transform.
- Compatible existing kerning ownership is not double-applied.
- Presentation only; challenge mechanics and save semantics were unchanged.

## 2.0.0-beta.30.0.0.10

### Fixed / hardened
- Made external-provider delegation effective at runtime for the delegated boolean mechanics, not UI-only.
- Preset application may update dormant delegated preferences without re-enabling Nuzlocke's duplicate runtime mechanic.
- EXP Edging now delegates with an external level-cap provider rather than remaining visibly ON but ineffective.
- Fixed the public `nuzlocke.delegation` export declaration-order bug with late-bound accessors.
- Routed the public item-policy API through `evaluateItemUsePolicy`, fixing master-switch behavior, Rare Candy key drift, and missing native item restrictions.
- Corrected Acquisition Type Locke integration and reused special gift/trade legality for external acquisitions.
- Changed AutoCompat Pokemon snapshots to authoritative `game.save.party` and `game.save.boxes`.
- Automatic legacy providers are cleared/rebuilt on scans so disabled/removed mods cannot remain stale owners.
- Generic `RANDOMIZER` name detection no longer claims starter/encounter/learnset controls; exclusive delegation requires granular capabilities.
- Gold PackMenu now presents `no_fishing` denial instead of falling through its reason whitelist.
- Legacy recovery no longer adds a second EDITED row for a Pokemon already attached to a saved legacy row.

### Still runtime-test required
- R/B/Y Skip Catch Demo remains unproven; Gold has the explicit `World.startCatchTutorial` seam.
- Randomizer restoration must be tested with providers that mutate encounter/learnset registries after Nuzlocke snapshots them.
- Passive external acquisition reconciliation is now pointed at the correct save shape, but provider-specific acquisition timing still needs runtime proof.

## 2.0.0-beta.29.3.16 — Nuz Info / Compatibility API 27

- Direct child of `2.0.0-beta.29.3.15`.
- Replaced the single-purpose party Catch Info row with composable NUZ INFO.
- Added independently toggleable Catch, Stat, and Move pages for R/B/Y and Gold.
- Stat page shows current stats, DVs, and raw Stat EXP; Gold models shared Special DV/Stat EXP correctly.
- Move page resolves type, power, accuracy, and current/max PP from the active merged move registry.
- A/Right cycles forward, Left cycles backward, and B returns to the party submenu.
- Nuz Info presentation toggles remain outside Permanent Rule Seal.
- Bumped Nuzlocke Compatibility API 26 → 27 with read-only Nuz Info helpers.
- Save schema remains 4; Mod API remains 2.
- Changed UI/API paths remain TEST REQUIRED.

## 2.0.0-beta.29.3.15 — Rule UI / Dialogue / Gold QoL

- Direct child of `2.0.0-beta.29.3.14`.
- Added a LEVELS section for Game Difficulty, Level Cap Scope, and EXP Edging.
- Kept BATTLE ITEMS limited to actual battle-item-use rules; moved No Catching to Core and No Escape to General.
- Clarified Player/Wild/Trainer Stat EXP defaults and the 0/25/50/75/100/200 challenge preset scale.
- Exposed Gold-only Skip Cherrygrove Tour QoL while preserving the native MAP CARD reward/cleanup tail.
- Expanded Rare Candy, TM, and field-healing rejection dialogue with item/move-aware World Building text.
- No Catching remains the only selectable capture-ban rule; the retired Ball tier remains migration-only.
- Compatibility API remains 26; save schema remains 4.
- Changed paths remain TEST REQUIRED.

## 2.0.0-beta.29.3.14 — Gold Runtime Repair

- Direct child of `2.0.0-beta.29.3.13`.
- Fixed Gold START-menu compact-label selection using the hook-supplied game.
- Rebuilt Gold No Buying / No Selling around native Mart entry and transaction seams.
- Split Random Starter preview from committed starter identity; Gold Elm portrait/cry now matches each ball's persisted randomized preview.
- Hardened Gold starter New Bark Town provenance and added conservative reconciliation for the narrow older UNKNOWN case.
- Clarified Gold Stat EXP descriptions while keeping native 0% defaults.
- Repository tree, save schema 4, Compatibility API 26, Mod API 2, and engine range are unchanged.
- Changed paths remain TEST REQUIRED until runtime retest.

## 2.0.0-beta.29.3.13 — migration / master-switch / compatibility hardening

- Rolled directly from `2.0.0-beta.29.3.12`; exact 11-file repository tree preserved.
- Fixed the legacy `ball_use_ban_tier` → `no_catching` migration. Partial historical Ball restrictions no longer become an absolute capture ban; an absent new key defaults OFF and explicit `no_catching` state is preserved. Already-migrated ambiguous saves are flagged for review instead of being destructively guessed back OFF.
- Fixed Trainer Money so both wallet snapshot and payout scaling obey the Nuzlocke master switch.
- Fixed a Trainer Money callback-scope defect by declaring its transient weak-table state before the `battle.started` callback that records into it.
- Added generation-neutral Trainer Money wallet access: R/B/Y use `save.money`; Gold uses `save.player.money`. Optional provider wallet-cap aliases are honored in deterministic precedence order, and an already-larger provider wallet is not truncated to the native cap when no cap is published.
- Made Game Difficulty identity stable: `difficulty_provider_id` is authoritative, setup profiles preserve it, old index-only saves bootstrap it once, and unavailable external providers temporarily fall back to VANILLA without erasing the requested ID.
- Fixed Route Forgiveness so rewards, token shop presentation, and failure-spend flow are disabled with the Nuzlocke master switch.
- Hardened Dungeon Lock-In to remember the exact exterior entrance warp. Different exits that land on the same exterior map are allowed; legacy coordinate-less state fails open.
- Corrected version-aware Game Corner deterministic source data for Scyther, Dratini, and Pinsir in both live lookup and legacy recovery.
- Replaced the stale Gen-I NPC-trade fallback table with the authoritative English Red/Blue and Yellow trade rosters/locations, removed impossible historical trade assumptions from legacy recovery, prevented ambiguous prize/trade/evolution-capable species from being auto-resolved as wild on a single table hit, and prevented Gold from inheriting Gen-I gift/trade source tables.
- Hardened source-less `pokemon.received` inference: a reported live location must match the version-valid vanilla source; when location is unavailable, only genuinely provenance-deterministic species may be inferred.
- Added a Gold native NPC-trade pre-transaction gate around `TradeMenu.chose` plus post-success tracking around `NpcTrade.perform`; blocked trades do not set the one-shot flag or remove the offered Pokemon. Gold now exposes Gift Pokemon and In-Game Trades on its beta rule surface.
- Hardened Random Mono/Duo type rolls to use types actually represented by the live merged species/provider pool when possible, avoiding empty vanilla Dark/Steel rolls.
- Made Gym/Dungeon Lock-In compose against the final downstream `warp.destination` result and clear stale dungeon state when the master or dungeon rule is disabled.
- Consolidated the first Level Cap + EXP Edging notification into one World Building message instead of two near-duplicate boxes in the same EXP transaction.
- Audited new-rule defaults: restrictive/challenge additions remain OFF by default, Trainer Money remains 100%, and Game Difficulty remains VANILLA.
- Improved rule descriptions for master-switch boundaries, Failed Encounters, Dupes, Shiny Clause, Type Locke, No Day Care, Trainer Money, Game Difficulty, No Catching, gifts/trades, and Gym/Dungeon Lock-In.
- Bumped Nuzlocke Compatibility API **25 → 26** with stable difficulty state, activity/rule queries, migration warnings, Type Locke/Forgiveness/Dungeon helpers, conservative acquisition classification, version-aware gift/trade location plus deterministic-source helpers, and expanded Pokémon-field ownership declarations.
- Save schema remains 4; Gen1Recomp Mod API remains 2; engine range remains `>=0.1.81 <0.1.84`.
- Targeted static/semantic smoke passes; normal standalone Lua `loadfile` still reaches the inherited >200-local outer-function limit, so no standard-Lua compile PASS is claimed. Changed gameplay/UI paths remain **TEST REQUIRED** in Gen1Recomp.

## 2.0.0-beta.29.3.12 — Type Locke / encounter accounting stabilization

- Rolled directly from `2.0.0-beta.29.3.11`; repository tree unchanged.
- Added RANDOM Type 1/Type 2 selection for Monolocke/Duolocke. Rolls resolve once and persist concrete types; Duo rolls are always distinct.
- Polished Type Locke labels/status presentation and RANDOM descriptions.
- Hardened Dupes Clause with a battle-scoped free-encounter decision so duplicates cannot reach Failed Encounter consumption or Route Forgiveness spending.
- Canonicalized exact `DIGLETT_CAVE` / `DIGLETTS_CAVE` / CamelCase spellings to one physical `DIGLETT_CAVE` encounter area across R/B/Y, Gold, and providers.
- Added deterministic starting-resource regression audit cases for vanilla/default ¥3000, intentional ¥0, clamping, malformed values, Balls, and Rare Candies.
- Polished Forgiveness Token shop metadata/status balance presentation.
- Polished No Day Care T3 rejection copy while retaining safe withdrawal of existing occupants.
- Compatibility API 25, save schema 4, Mod API 2, engine range `>=0.1.81 <0.1.84`.
- New behavior remains TEST REQUIRED pending in-engine runtime validation.

## 2.0.0-beta.29.3.11 — Pokemon Bois Club world-building pass

- Rolled directly from `2.0.0-beta.29.3.10`; repository files remain the same set.
- Added a **Tier 3 World Building** cosmetic rebrand for Vermilion's **Pokemon Fan Club**, presenting it as the **Pokemon Bois Club** when World Building is set to T3.
- Added safe T3-only dialogue/sign rewording for the club in R/B/Y and Gold without changing item rewards, story flags, yes/no branches, or Bike Voucher / Rare Candy transactions.
- Added a custom **Bryan-the-Boi tribute chairman sprite** for the T3 presentation path while preserving vanilla presentation at lower World Building tiers.
- This pass is cosmetic only; no rules, encounter legality, save schema, or compatibility API behavior changed.
- New Pokemon Bois Club presentation paths are **TEST REQUIRED** until runtime validated.

## 2.0.0-beta.29.3.10 — Type Locke + No Day Care

- Rolled directly from `2.0.0-beta.29.3.9`; repository tree unchanged.
- Added **Type Locke** as a shared `OFF / MONO / DUO` framework for Monolocke and Duolocke runs.
- Added separate **Type 1** and **Type 2** selectors using a stable 17-type Gen 1+2 index.
- Type legality reads live merged species data first and optional species-metadata provider data second; unreadable custom schemas fail open.
- Off-type wild encounters are rejected without consuming an encounter area or Route Forgiveness Token.
- Shiny Clause does not bypass Type Locke.
- Native gift/trade acquisition gates now include Type Locke legality where a pre-transaction seam exists.
- Random Starter filters candidates through the selected Type Locke when possible while preserving the mandatory starter progression-safe fallback.
- Added **No Day Care**. R/B/Y blocks new deposits at the hand-ported Day Care conversation; Gold blocks new deposits at `Breeding.canDeposit`.
- Existing Day Care occupants remain retrievable; Gold existing parent/Egg state is preserved.
- Added complete T1/T2/Kanto-T3/Johto-T3 World Building entries for Type Locke selectors and No Day Care.
- Corrected Permanent Rule Seal boundaries: challenge rules remain sealed; Game Difficulty, World Building, QoL, and presentation controls remain adjustable.
- Compatibility API remains 25, save schema remains 4, Mod API remains 2, and engine range remains `>=0.1.81 <0.1.84`.
- New Type Locke and No Day Care paths are **TEST REQUIRED** until runtime validated.

## 2.0.0-beta.29.3.9 — Gold-native custom UI integration

- Rolled directly from `2.0.0-beta.29.3.8`; repository tree unchanged.
- Replaced R/B/Y-style pixel-positioned rendering on Nuzlocke-owned Gold screens with Gen1Recomp's native Gen 2 `src.ui.gen2.Chrome` vocabulary.
- Gold Setup / **NUZ RULES** now use a 20x18 tile-grid layout, native cursor/down-arrow glyphs, Gold money formatting, scrolling rule rows, collapsible section presentation, and a native description panel while retaining the shared configuration/update model.
- Gold **ENC TRACKER** now renders LOG/MAP data through native Gold boxes/text while retaining the same canonical encounter state and cap source.
- Gold **CATCH INFO** now uses native Gold presentation without changing ownership/provenance semantics.
- Gold Route Forgiveness confirmation now uses native Gold boxes, cursor, wrapped text, and live token count while preserving the existing spend transaction.
- Gold **NUZ STATUS** continues to use its dedicated Start-menu surface; Nuzlocke does not replace the native Trainer Card lifecycle.
- Follows upstream Gen1Recomp guidance that `src.ui.OptionRows` is not a Gen 2 facade and must not be used to paint Gen 1 option chrome over Gold.
- R/B/Y presentation and protected gameplay enforcement are unchanged.
- New Gold-native presentation is **TEST REQUIRED** until runtime validated.
- Compatibility API remains 25, save schema remains 4, Mod API remains 2, and engine range remains `>=0.1.81 <0.1.84`.

## 2.0.0-beta.29.3.8 — World Building parity + cleanup

- Rolled directly from `2.0.0-beta.29.3.7`; repository tree unchanged.
- Expanded World Building OFF/T1/T2/T3 presentation to Gold/Johto with region-aware Tier 3 text instead of forcing the Gold backend to Tier 0.
- Added one shared rule-feedback catalogue with complete T1/T2/Kanto-T3/Johto-T3 coverage for every implemented selectable rule (Wonderlocke remains intentionally WIP), while only presenting text at safe player-facing seams. R/B/Y and Gold can now reuse tiered catch, item, shop, healing, gambling, lock-in, encounter, forgiveness, Shiny Clause, EXP Edging, trainer-money, Rival Mercy, Permadeath, and Whiteout presentation without duplicating legality logic.
- Added Johto Gym-Leader flavor beats at Tier 3 while keeping native battle introductions first.
- Consolidated R/B/Y and Gold catch-denial text onto one presenter.
- Removed retired live Ball-ban tier/rank code; the legacy `ball_use_ban_tier` key remains read only for migration into No Catching.
- Removed the unreachable legacy `no_items` battle branch, which had no selectable rule key.
- Restored IRON / IronMON as a first-class Nuzlocke Loadout and widened the loadout state/UI range from four choices to five. The preset is IronMON-style and only configures rules Nuzlocke itself owns.
- Updated stale internal build metadata and player documentation.
- Existing runtime-PASS behavior remains protected; new Gold flavor and IronMON preset behavior are TEST REQUIRED.

## 2.0.0-beta.29.3.7 — split Nuzlocke loadout / game difficulty

- Separates **Nuzlocke Loadout** from **Game Difficulty**. Difficulty selection no longer changes Permadeath, encounter, healing, or other Nuzlocke rules.
- Game Difficulty defaults to **VANILLA** and is changeable mid-game until the Permanent Rule Seal is applied.
- Adds **NUZ MEDIUM**, the mod's own moderate trainer profile.
- Adds two documented ROM-hack-inspired choices per supported game. A `*` suffix means an inspired compatibility profile, not a byte-identical reproduction of the source hack.
- Active compatible trainer/difficulty providers are appended as `[MOD]` choices and remain authoritative for their own composed trainer parties.
- Built-in difficulty profiles operate on future composed trainer parties and preserve explicit moves supplied by another trainer/content provider rather than overwriting them.
- Renames the irreversible configuration control to **Permanent Rule Seal** in the player-facing UI while retaining the existing save representation.
- All new difficulty behavior is **TEST REQUIRED**.

## 2.0.0-beta.29.3.7

- Added optional EXP Edging: cap-blocked EXP is banked per Pokemon and released through the normal EXP path when a later authoritative cap allows it.
- Added Difficulty selector groundwork: VANILLA / NUZ / HARD / EXT, with capability-first discovery of active external difficulty/cap providers. External providers are never enabled, disabled, or guessed solely by mod name.
- Gold exposes both systems through its separate backend; all new behavior is TEST REQUIRED.

# 2.0.0-beta.29.3.3

- Rebased sequentially from the recovered 29.3.1 package while reconstructing the 29.3.2 compatibility intent; no repository files added or removed.
- Added Route Forgiveness setup states: OFF, enabled with 0 starting tokens, or enabled with 1 starting token. Non-Leader Gym Trainers award one token once per trainer. Eligible failed encounters consume a token before an area is marked failed; Dupes never consume the area or a token.
- Added Trainer Money scaling: 0/25/50/75/100/150/200/300/500%, applied to the final composed trainer payout. Default is vanilla 100%.
- Made Rule Lock permanent/monotonic per save with a second-confirmation step. Locked rules remain viewable; runtime state continues to update.
- Reworked startup defaults: NUZLOCKE is now the default mode, FAMILY Dupes and Shiny Clause are enabled by default, and Nickname Rule remains part of the conventional core. Hardcore keeps Champion caps, battle healing/X-item restrictions, First Rival Mercy OFF and Whiteout loss, but Gym/Dungeon Lock-Ins remain optional rather than being silently bundled into Hardcore.
- Published the Forgiveness Token aspirational shop price as 1,000,000 (one above the native 999,999 wallet ceiling) for shop/UI integrations. Native cross-generation Mart stock injection remains TEST REQUIRED and is not claimed as runtime PASS.
- New behavior in this build is TEST REQUIRED; existing runtime-confirmed PASS behavior remains protected.

## 2.0.0-beta.29.3.3

Development repair build based directly on `2.0.0-beta.29.3.0`.

### Fixes

- Corrected Gold midgame cap-ladder presentation to Chuck → Jasmine → Pryce; the existing monotonic cap floor prevents the displayed/enforced cap from dropping from Jasmine's 35 to Pryce's 31.
- Corrected Gold positional badge fallbacks: Storm/Chuck is slot 5 and Mineral/Jasmine is slot 6.
- Fixed Legacy Recovery encounter-limit policy to read the canonical flat `nuzlocke_enabled` and `encounter_limit` save keys instead of a nonexistent nested `rules` table.
- Corrected Celadon Eevee gift provenance for Yellow as well as Red/Blue and removed fictitious Yellow Jolteon/Vaporeon/Flareon gift aliases.
- Version-gated Legacy Recovery's version-specific trades so impossible R/B or Yellow trade provenance is not fabricated as DETERMINED. This includes R/B Lickitung, Electrode, and Kangaskhan and Yellow Machoke.
- Unified Solo Only wild and gift acquisition checks behind one active-party occupancy helper. A fainted but living Pokemon still occupies the Solo Only slot when Permadeath is off, matching the documented active-party rule; PC swaps remain intentionally allowed.

### Validation

- Expanded the static release gate with regression checks for all six reviewed areas.
- Static release gate: **95/95 PASS**.
- Runtime testing is still required, especially for Gold cap progression and Legacy Recovery migrations.

## 2.0.0-beta.29.3.0

Full beta release roll-up from the development line after `2.0.0-beta.29.1.0`.

### Runtime-confirmed improvements

- Yellow level-cap displays now follow Stronger Trainers' composed boss rosters in the Trainer Card and Encounter Log instead of showing vanilla caps.
- Yellow First Rival Mercy was runtime-confirmed working.
- Blue/Yellow new-game Default Names, Starting Money, Starting Rare Candies, Soft Start, No Mom Heal, No Center Heal, Random Starter grants, starter provenance, and Forced Nicknames retained their runtime-confirmed behavior where tested.
- Yellow in-game Nuz Rules section expand/collapse glyphs work with the intended native right/down arrows.
- Running Shoes appears under Quality of Life.
- Nuz Status on the back of the Trainer Card remains functional in Blue/Yellow.

### Rules and challenge organization

- Added Gym Lock-In and Dungeon Lock-In, including conservative fail-open handling for older saves and escape-method enforcement intended to avoid softlocks.
- Moved Gym Lock-In and Dungeon Lock-In into the Ironmon/Hardcore challenge section.
- Replaced blanket numbered-route splitting with independent Route 2, Route 10, and Route 20 split rules.
- Route-split descriptions now explain the geography/progression reason those three routes are commonly treated as separate encounter areas.
- Existing Mt. Moon and Safari split behavior remains available.
- Legacy blanket Route Splits saves migrate conservatively without granting free encounters.

### Setup and quality-of-life

- Renamed B-button running to Running Shoes and placed it under Quality of Life.
- Maximum BST setup editing now follows the same numeric-editing model used by Starting Money/Poké Balls/Rare Candies.
- Setup/profile numeric boundaries reject non-finite corrupted values instead of persisting invalid numeric state.
- Setup and in-game Rules collapsible sections use native right/down directional glyphs.
- Front Trainer Card `A:NUZ` placement was lowered for better alignment.

### Random Starter and opening sequence

- Random Starter acquisition continues to use one persisted roll so the actual awarded Pokémon and tracker provenance stay aligned.
- R/B starter presentation was hardened so confirmation text uses the same persisted randomized species while the selected vanilla ball still controls the native story/rival-choice branch.
- Yellow non-Pikachu randomized starters no longer receive Pikachu-only post-lab presentation handling.
- Early-lab Rival text was trimmed to avoid repeating the same "toughen it up" idea immediately after battle.
- Repeated opening-sequence dialogue remains a targeted runtime regression area; no broad text-suppression hack was introduced.

### Encounter tracking and provenance

- Gold starter/gift tracking was hardened for numeric species identifiers.
- Gold starter events canonicalize through the New Bark Town starter path so randomized starters can immediately consume the correct encounter slot and report New Bark Town rather than Unknown.
- Split-area reprojection is deterministic when child areas are merged.
- Legacy encounter-history migration preserves consumed encounter state and tracker rows.
- Persistent Pokémon identity remains slot-independent across party/PC movement.

### Permadeath and battle lifecycle

- Added a second post-finish Permadeath reconciliation so scripted trainer/Gym callbacks cannot restore a Pokémon that Nuzlocke already marked dead.
- Cooperative post-battle healing can restore surviving Pokémon while Nuzlocke-dead Pokémon remain at 0 HP.
- Tournament/CANLOSE battle flows remain composable with Nuzlocke rule ownership.

### Compatibility

- Added and hardened composed `trainer.party` observation for trainer-modifying content.
- Fixed the hook-priority ordering bug that previously caused Nuzlocke to observe vanilla trainer parties before downstream trainer transformations.
- Added pre-battle composed-party preview so next-cap UI can display modified boss ace levels before the battle begins.
- Gold live trainer inspection now prefers the canonical Gen 2 trainer registry shape.
- Added a compatibility pass for Indigo Plateau Conference v1.0.2 while preserving tournament ownership of its own NPCs, flow, and survivor healing.
- Compatibility API remains 25; Save Schema remains 4; Gen1Recomp Mod API remains 2.
- Audited engine target remains Gen1Recomp 0.1.83 with manifest support `>=0.1.81 <0.1.84`.

### Known runtime follow-ups

- R/B Random Starter still needs a final runtime pass confirming every starter preview sprite/confirmation surface matches the randomized award.
- Gold in-game menu layout, native status glyphs, randomized-starter display/provenance, and caught-count refresh need full runtime confirmation on the release build.
- Opening Oak/Rival/Mart dialogue duplication remains under focused investigation.
- Gym/Dungeon Lock-In still needs broader cross-game runtime coverage.
- Gold support remains beta.

## 2.0.0-beta.29.2.7
- R/B Random Starter selection confirmation now names the persisted randomized species, with the existing Dex preview and actual grant bound to the same roll.
- Added protected pre-battle trainer-party preview for known runtime trainer-balance composition so Trainer Card and Encounter Log can show the actual next boss ace before the fight starts.
- Gym Lock-In and Dungeon Lock-In moved from World to the Ironmon/Hardcore challenge section; rule behavior is unchanged.
- Cleaned up the optional early Oak-lab Rival line to avoid repeating the later post-battle "toughen it up" idea.
- Preserves Yellow in-game section glyphs and Running Shoes/QoL placement confirmed by runtime testing.

## 2.0.0-beta.29.2.6
- Audited compatibility with Indigo Plateau Conference v1.0.2 (Gold).
- Trainer-party observation now runs outside normal priority-0 content wrappers, so Nuzlocke records the final composed tournament party rather than observing vanilla before a downstream replacement.
- Gold trainer-data inspection now understands the canonical `game.data.gen2Trainers.classes` shape while retaining the existing R/B/Y trainer registry path.
- Added a narrow Indigo Conference adapter declaration: its Colosseum NPC/state/CANLOSE flow remains tournament-owned; Nuzlocke retains death, rules, tracker, and Whiteout ownership.
- Scripted post-battle healing is allowed for surviving Pokemon, while already Nuzlocke-dead party members are reasserted at 0 HP after battle/map reconciliation.
- No IPC map, NPC, trainer, event-flag, tournament-state, or save keys are patched or overwritten.

# Changelog

## 2.0.0-beta.30.1.21

- Added spoiler-safe randomizer ownership context to Encounter Tracker.
- Added dedicated MOD COMPAT ownership diagnostics screen.
- Expanded translation-safe semantic menu matching.
- Added merged external species metadata export.
- Added adaptive compatibility/tracker presentation helpers.
- Added context-sensitive World Building guidance API.


This file is the permanent cumulative development/release history. A known revision is retained even when its exact per-build delta is only partially recoverable; uncertain history is labeled rather than guessed. A beta.29.2.0 history-recovery pass reconciled preserved source, packages, runtime evidence, and retained development records; newly recovered details are added only where their version attribution is supportable.

## 2.0.0-beta.29.2.5 — focused common-route split rules
- Gold START-menu labels for Nuz Status, Encounter Tracker, and Nuz Rules now use compact native-width labels so they do not draw through the menu border.
- Gold Nuz Status now uses the native Gen 2 down-arrow glyph for additional rule rows.
- Hardened Gold randomized-starter registration so numeric species IDs are resolved before tracker/history writes and explicit starter events canonicalize to New Bark Town.
- Gold starter provenance now refreshes the tracker/Catch Info path immediately when the starter is received.

- Built directly from beta.29.2.3.
- Retires the player-facing blanket Route 1–25 CARDINAL rule.
- Adds independent **Route 2 Split**, **Route 10 Split**, and **Route 20 Split** ON/OFF rules for R/B/Y, with descriptions explaining the progression/geography reason each route is commonly split.
- Route 2 uses North/South around Viridian Forest, Route 10 uses North/South around Rock Tunnel, and Route 20 uses West/East around Seafoam Islands.
- Existing saves with the retired blanket Route Splits rule enabled carry that intent forward to all three new route toggles. Legacy split rows on every other route collapse deterministically to their parent route while preserving every tracker row and consumed encounter state, so migration cannot create free encounters.
- The compatibility API retains the legacy `routes` field as `0` and adds independent `route_2`, `route_10`, and `route_20` mode fields without changing Nuzlocke Compatibility API 25 or save schema 4.
- Mt. Moon and Safari split behavior is unchanged.
- Runtime migration and ON/OFF reprojection tests are required before public release.

## 2.0.0-beta.29.2.3 — finite-number and review hardening

- Built directly from beta.29.2.2.
- Sanitizes non-finite numeric Setup/profile inputs (`NaN`, positive infinity, negative infinity) at rule normalization and profile-copy boundaries, falling back to established defaults before clamping/persistence.
- Adds a serializer defense-in-depth guard so a non-finite number cannot be emitted as a persisted Setup-profile literal even if it bypasses earlier normalization.
- Leaves normal gameplay arithmetic unchanged; this is corrupted/external-input hardening rather than a change to EXP, level caps, Stat EXP, or battle math.
- Preserves beta.29.2.2 Gym/Dungeon Lock-In, trainer-cap compatibility hardening, and all beta.29.2.1 determinism/Permadeath fixes.
- Expands repository-only review rationale and regression obligations for investigated technical edge cases that did not justify production changes.

## 2.0.0-beta.29.2.2 — lock-in and trainer-cap compatibility hardening

### Goal

Build directly from beta.29.2.1 and add the missing Gym/Dungeon Lock-In rule family while improving live trainer-roster cap discovery without disturbing the beta.29.2.1 Permadeath and deterministic encounter-projection fixes.

### Added

- **Gym Lock-In** is now a selectable Setup/NUZ RULES option. Supported Gym exits are blocked until the corresponding Gym Leader is defeated; already-cleared Gyms fail open. R/B/Y and Gold Gym map aliases are normalized before lookup.
- **Dungeon Lock-In** is now a selectable Setup/NUZ RULES option for a conservative set of known multi-exit dungeon families. The entrance used to enter is sealed, while reaching a different legitimate exterior exit releases the lock.
- Escape Rope use is blocked while an active Dungeon Lock-In is in force, even when the separate No Escape Rope rule is OFF. Dig, Teleport, and Fly are also denied through the shared field-move eligibility seam if they would otherwise be usable from the locked dungeon.
- Lock-In rejection text has plain/Tier 1, Tier 2, and Tier 3 presentation. Turning optional World Building OFF still leaves a plain enforcement explanation instead of silent rejection.

### Compatibility hardening

- Live trainer ace-level discovery now walks a bounded, cycle-safe set of common nested party containers (`party`, `team`, `pokemon`, `mons`, `roster`, `members`) instead of requiring an immediate vanilla party array. This is intended to make level caps follow trainer-content modifications that preserve semantic Pokémon rows but wrap the roster differently.
- Level Cap Scope **POST** remains the supported opt-in for provider-driven postgame caps; the older separate expanded/additional-content toggle is not restored.
- The current Gen1Recomp launcher updater downgrade behavior with multi-part beta tags remains a known install/update issue; manual installation of the newest release remains the safe path until version-resolution behavior is corrected.

### Safety / preservation

- Built directly from beta.29.2.1; no older branch was restored.
- Dungeon coverage is deliberately conservative and excludes dead-end/single-exit locations unless a safe completion seam exists, preventing the rule itself from manufacturing a softlock.
- A save loaded inside a dungeon without trustworthy entry-side state fails open rather than inventing a lock.
- Save schema remains 4; Nuzlocke Compatibility API remains 25; Gen1Recomp Mod API remains 2.
- Gym Leader Permadeath reconciliation, LOST-vs-DEATH semantics, native collapse glyphs, starting-money fallback, and unrelated rule paths remain inherited from the immediate parent.

### Runtime validation required

- R/B/Y: enter an uncleared Gym, verify ordinary exit rejection, defeat Leader, verify exit succeeds.
- Gold: repeat on at least one Johto Gym.
- Dungeon: enter a supported multi-exit dungeon, verify the entry exit is blocked, Escape Rope plus Dig/Teleport/Fly cannot bypass the lock, and a different legitimate exit releases the lock.
- Existing/older save loaded inside a dungeon must fail open rather than trap the player.
- Trainer-content compatibility: verify a modified Brock/early boss roster changes the displayed/enforced live cap instead of falling back to the vanilla value.

## 2.0.0-beta.29.2.1 — determinism and Gym-Leader Permadeath hardening

- Built directly from beta.29.2.0.
- Made split-area re-projection deterministic instead of allowing merged representative encounter state to depend on Lua table iteration order.
- Added a post-finish Permadeath reconciliation pass so special/Gym trainer teardown cannot restore a Pokémon already marked dead during battle.
- Structural release-gate coverage was expanded for both fixes; exact runtime validation remained required.

## 2.0.0-beta.29.2.0 — status semantics and native UI polish

### Goal

Turn the narrow beta.29.1.1 money checkpoint into a broader player-facing update while preserving the published beta.29.1.0 behavior baseline and every runtime-protected path.

### Changed

- Carries forward beta.29.1.1's R/B/Y fresh-start money correction: missing/unset Money defaults to **$3,000**, while an explicit **$0** remains valid.
- Collapsible SETUP/NUZ RULES category headers now use Gen1Recomp's theme-aware native directional glyphs instead of ASCII `+` / `-`. Collapsed uses the native sideways cursor glyph; expanded uses the native more/down glyph.
- New Pokémon-death history rows now use `status = "DEAD"` instead of overloading `"LOST"`.
- Existing saves are migrated conservatively: legacy `LOST` history rows are rewritten to `DEAD` only when they carry death evidence such as a death location/cause/opponent.
- Failed/fled/KO'd eligible encounters remain represented separately by `encounter_states[area].status = "FAILED"` and feed **LOST ENC.** counts.
- Run-over summaries now label the owned-Pokémon counter as **DEATHS** / **LAST DEATH** rather than LOST, while the underlying legacy `nuzlocke_losses` save key remains intact for save compatibility.
- Reconciled the cumulative version record against preserved source, packages, runtime evidence, and retained development records, enriching beta.19, beta.21, beta.27.3, beta.27.8, and beta.27.9 where the recovered attribution is strong enough to preserve without guessing.

### Compatibility / preservation

- Built directly from beta.29.1.1; no older branch was restored.
- Save schema remains 4 because the migration is backward-compatible and does not remove or rename persisted keys.
- Nuzlocke Compatibility API remains 25; no exported compatibility function signature changed.
- Gen1Recomp compatibility remains `>=0.1.81 <0.1.84`, with 0.1.83 exact-source audited.
- First Rival Mercy, acquisition provenance, Gold PC gifts, starter/gift nickname sync, temporary-party handling, item/shop/healing rules, and all unrelated gameplay paths are untouched.

### Validation

- Structural release gate expanded with assertions for the money fallback, explicit $0 preservation, native collapse glyphs, new `DEAD` history writes, legacy death-history migration, and LOST-encounter/DEATH separation.
- Exact in-game runtime regression remains required before publication.

### Known current runtime issue

- A runtime report shows Permadeath working in an ordinary fight but failing to leave a Pokémon unusable after it faints against a Gym Leader (reported against Misty); the Pokémon remained in the party and could be healed at a Pokémon Center. This is treated as a current release-blocking reconciliation bug until the Gym Leader/special-trainer post-battle path is reproduced and fixed.

## 2.0.0-beta.29.1.1 — fresh-start money default hotfix

### Goal

Fix the runtime-confirmed R/B/Y NEW GAME regression found in the published beta.29.1.0 player build without changing unrelated gameplay or compatibility behavior.

### Fixed

- The `save.new_game` starting-money fallback now matches the Setup default: a missing staged value produces **$3,000** instead of $0.
- An explicit player selection of **$0** remains valid; only a missing/unset value receives the $3,000 fallback.

### Preserved

- Built directly from published beta.29.1.0.
- Gen1Recomp compatibility remains `>=0.1.81 <0.1.84`, with 0.1.83 as the exact source-audited profile.
- Gen1Recomp Mod API 2, Nuzlocke Compatibility API 25, compatibility floor 10, save schema 4, and R/B/Y/Gold targets are unchanged.
- Starting Poké Balls, starting Rare Candies, Gold native starting resources, Soft Start, and all beta.29.0.2 acquisition/provenance fixes are untouched.

### Validation

- Static release gate includes explicit assertions for the $3,000 missing-value fallback and the preservation of explicit $0.
- Exact in-game R/B/Y fresh-start retest remains required; runtime evidence is authoritative.

## 2.0.0-beta.29.1.0 — Gen1Recomp 0.1.83 compatibility profile

### Goal

Prepare the beta.29.0.2 gameplay candidate for release testing on the current Gen1Recomp 0.1.83 engine without rewriting protected gameplay paths merely because newer public engine surfaces exist.

### Changed

- Built directly from beta.29.0.2 with **no intended gameplay behavior change**.
- Advanced the exact source-audited Gen1Recomp profile from 0.1.81 to 0.1.83 and added explicit 0.1.82/0.1.83 engine-profile records.
- Widened the manifest engine range from `>=0.1.81 <0.1.82` to `>=0.1.81 <0.1.84` so the release candidate can run on Gen1Recomp 0.1.83 for certification.
- Preserved Gen1Recomp Mod API 2, Nuzlocke Compatibility API 25, compatibility floor 10, and Nuzlocke save schema 4.
- Kept the established ENC TRACKER implementation unchanged. Gen1Recomp 0.1.83's additive Gold `mapOverview()` API is recorded for later equivalence evaluation rather than being substituted for a runtime-proven tracker path immediately before release.

### Compatibility audit

- Exact Gen1Recomp v0.1.83 source retains the protected Gen 1 battle constructors and `throwBall`, `askNicknameUI`, `computeDamage`, `onFaint`, `playerMonFainted`, and `finish` seams used by Nuzlocke.
- `Status.residual`, `ItemEffects.use`, `ShopMenu.new`, and the SaveData persistence/slot helpers used by Nuzlocke retain compatible signatures/contracts.
- Gold retains `BattleState:finishBattle`, the blocking `Specials.block` contract, `Vm` `loadwildmon` state, shared `battle.started`/faint/end lifecycle events, and the title-menu hook shape used by Setup.
- The 0.1.82→0.1.83 engine delta is limited to launcher/importer changes plus the additive generation-neutral map-overview surface; it does not replace the protected Nuzlocke battle/item/shop/save wrappers.

### Runtime evidence carried into this build

- On Gen1Recomp 0.1.83, manual import of beta.29.0.2 was recognized with its version/category/game targets.
- The beta.29.0.2 `<0.1.82` manifest gate correctly blocked gameplay on engine 0.1.83.
- Using Update on the unpublished local candidate successfully installed the latest published Nuzlocke release, confirming repository download/install plumbing while also proving unpublished candidates must be imported manually.
- Current Gen1Recomp beta-tag release comparison can show a redundant `v2.0.0 available` notice because its release comparison uses the leading `x.y.z` triple; this is recorded as an engine update-status limitation, not a Nuzlocke gameplay failure.

### Validation / still required

- Exact-source compatibility inspection: **PASS** for the reviewed 0.1.83 seams listed above.
- Local structural release gate: **55/55 PASS**.
- Player and repository candidate ZIP integrity: **PASS**.
- Player distribution exclusion check: **PASS**; repository-only development/testing material is not present in the player ZIP.
- Lua/LuaJIT behavior smoke: **NOT EXECUTED in this workspace** because a compatible runtime executable is not installed.
- Upstream modkit validate/lint/gen2check: **NOT EXECUTED in this workspace** because a complete local Gen1Recomp 0.1.83 source/imported-data tree is not available.
- Required next step: runtime certification of beta.29.1.0 on Gen1Recomp 0.1.83, beginning with Mod Manager Ready status/startup smoke and the beta.29.0.2 four-fix regression matrix.

## 2.0.0-beta.29.0.2 — reviewed acquisition and provenance bug fixes

### Goal

Apply the four pre-runtime code-review decisions with the smallest practical changes, preserving previously established acquisition, battle, save, and compatibility behavior while making the newly touched paths explicit runtime-regression targets.

### Fixed

- Removed write-only First Rival Mercy `armed` / `triggered` save telemetry. The durable first-Rival-seen state and battle-local forgiveness flags remain authoritative; legacy values already present in older saves are harmlessly ignored.
- Added stable-identity history-name synchronization after mandatory scripted starter/gift naming completes on R/B/Y and Gold. Acquisition/tracker registration remains at its established transaction point instead of being moved across naming-screen lifecycle boundaries.
- Gold `givepoke` acquisition detection now snapshots and diffs party plus PC boxes, while still preferring a new party member first. Full-party gifts can therefore reach the same initialization, tracker/history, area-consumption, and Nickname Rule handling as party-delivered gifts.
- `pendingStaticEncounter` is now a single-use next-battle provenance token: every actual battle consumes it before trainer/wild classification, so an intervening trainer battle cannot leave stale static state for a later unrelated wild encounter.

### Protected behavior

- First Rival Mercy remains opening-battle-only and one-time.
- Existing party-delivered Gold starter/gift flow, random starter behavior, pre-mutation gift legality, Gold VM resume behavior, tracker deduplication, and stable Pokémon identity remain in place.
- R/B/Y scripted gift registration timing is unchanged; only the matching stored history name is refreshed after mandatory naming.
- Canonical R/B/Y and Gold static encounters still use the existing provenance/classification system; explicit battle-provided static metadata remains independent of the temporary pending marker.

### Validation

- Local structural release gate: **49/49 PASS**.
- Added behavior-smoke regression cases for Rival Mercy persisted-state cleanup, Gold history nickname synchronization, Gold full-party PC-routed gifts, and intervening-trainer static-provenance invalidation.
- Lua/LuaJIT behavior smoke: **NOT EXECUTED in this workspace** because a compatible runtime executable is not installed.
- Upstream modkit validate/lint/gen2check: **NOT EXECUTED in this workspace** because a complete compatible Gen1Recomp checkout/imported-data tree is not available.
- Targeted in-game runtime matrix remains required before approval.

## 2.0.0-beta.29.0.1 — release-candidate packaging and developer documentation

- Built directly from beta.29.0.0 with no intended gameplay behavior change.
- Reorganized the release around a lean player distribution and a separate repository/tooling layout.
- Added a dedicated `docs/USER_GUIDE.md` exhaustive player manual while refocusing `README.md` as the repository landing page and quick-start guide.
- Expanded the README feature highlights/recent-major-features presentation so the repository front page advertises the collective current ruleset rather than only the current packaging delta.
- Added `mod.card`, `.modkitignore`, structured issue forms, developer API documentation, feature-confidence tracking, and a versioned compatibility guide.
- Updated manifest metadata to identify the maintained repository, use the `BALANCE` category, and target Red/Blue/Yellow/Gold explicitly.
- Removed the legacy generation-wide Gen 2 target from the candidate manifest so Silver/Crystal are not implied.
- Rebuilt the cumulative changelog so every known revision remains represented, including revisions whose exact per-build delta is only partially recoverable.
- Current candidate remains targeted to the audited Gen1Recomp 0.1.81 line; newer engine compatibility is not claimed by this build.

## 2.0.0-beta.29.0.0 — beta.29 development-line baseline

- Created directly from beta.28.20 with no intended gameplay changes.
- Began the beta.29 development line and consolidated the player-facing documentation/package baseline.
- Recorded current runtime evidence for Gold Setup/collapsible sections and Yellow existing-save navigation/collapsible sections.

## 2.0.0-beta.28.20 — temporary-party compatibility hardening

- Built directly from beta.28.19.
- Hardened Permadeath against trainer systems that temporarily narrow/reorder the player party and restore it during battle teardown.
- Whiteout now re-evaluates the restored real post-battle party so healthy reserves prevent a false run-ending Whiteout.
- Restored dead Pokémon are reconciled after temporary-party restoration rather than remaining usable.

## 2.0.0-beta.28.19 — preserved development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not been fully recovered from surviving release records. Preserved later history places beta.28.17–28.19 in an aggregate hardening period that included party-menu composition protection, checkpoint/savestate reconciliation of runtime-only observations, and additional wrapper/restoration safeguards before beta.28.20's temporary-party fix.
- Those aggregate changes are deliberately **not** assigned to one specific .17/.18/.19 build without stronger evidence.

## 2.0.0-beta.28.18 — preserved development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not been fully recovered from surviving release records. Preserved later history places beta.28.17–28.19 in an aggregate hardening period that included party-menu composition protection, checkpoint/savestate reconciliation of runtime-only observations, and additional wrapper/restoration safeguards before beta.28.20's temporary-party fix.
- Those aggregate changes are deliberately **not** assigned to one specific .17/.18/.19 build without stronger evidence.

## 2.0.0-beta.28.17 — preserved development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not been fully recovered from surviving release records. Preserved later history places beta.28.17–28.19 in an aggregate hardening period that included party-menu composition protection, checkpoint/savestate reconciliation of runtime-only observations, and additional wrapper/restoration safeguards before beta.28.20's temporary-party fix.
- Those aggregate changes are deliberately **not** assigned to one specific .17/.18/.19 build without stronger evidence.

## 2.0.0-beta.28.16 — menu-label clarity

- Renamed the in-game mod-menu entries to **ENC TRACKER** and **NUZ RULES**.
- No intentional gameplay behavior change was associated with the label cleanup.

## 2.0.0-beta.28.15 — numeric-rule correctness

- Corrected Maximum BST and the Player/Wild/Trainer Stat EXP selectors being treated as booleans instead of numeric/multi-state rules.
- Retained the lexically scoped Stat EXP/DV implementation used to stay below Lua 5.1 active-local limits.

## 2.0.0-beta.28.14 — compiler/runtime regression repair

- Confirmed that the reported missing Blue SETUP entry and Gold Mod Manager syntax error were one Lua compilation regression: beta.28.11's Stat EXP/DV additions crossed Lua 5.1's 200-active-local limit, so the mod failed before either UI path could register.
- Lexically scoped the Stat EXP/DV implementation behind the existing beta export namespace so the full mod could compile without adding long-lived main-function locals.
- Removed the speculative Gold `save.options`/ManagerState workaround used during diagnosis; it was not the root cause.
- Preserved robust R/B/Y and Gold NEW GAME/CONTINUE recognition.
- Preserved HP semantics when creation-time Stat EXP/DV changes alter maximum HP: full-health starters/gifts remain full, while damaged catches retain their actual battle HP.
- Preserved release-gate evidence from the test package while keeping Gold's new Stat EXP/DV paths runtime TEST REQUIRED.

## 2.0.0-beta.28.13 — compiler/runtime diagnosis iteration

- Preserved development revision in the beta.28 compiler-repair sequence.
- Exact per-build diagnostic changes are only partially recovered; the sequence addressed the active-local compiler failure introduced after beta.28.11.

## 2.0.0-beta.28.12 — compiler/runtime diagnosis iteration

- Preserved development revision in the beta.28 compiler-repair sequence.
- Exact per-build diagnostic changes are only partially recovered; the sequence addressed the active-local compiler failure introduced after beta.28.11.

## 2.0.0-beta.28.11 — Stat EXP and DV rule family

- Added independent Player/Wild/Trainer starting Stat EXP presets: 0%, 25%, 50%, 75%, 100%, and 200%.
- Added No Player Stat EXP Gain while preserving ordinary EXP and levels; battle Stat EXP is blocked before mutation and Stat EXP vitamins are vetoed before consumption.
- Added independent Perfect Player/Wild/Trainer DV controls.
- Covered supported player catches, scripted gifts/starters, in-game trades, compatible receive events, and Gold `givepoke` acquisitions.
- Added a generation-neutral battle-start fallback for Gold wild/trainer Stat EXP/DV application where R/B/Y constructors are not shared.
- Starting Stat EXP is bounded by the engine's 65,535 per-stat storage ceiling; 0% preserves the vanilla newly-created value of zero Stat EXP.
- Creation-time rules were designed not to rewrite existing Pokémon merely because the rules were loaded or enabled.
- The original layout crossed Lua 5.1's 200-active-local limit, leading to the beta.28.12–28.14 repair sequence.

## 2.0.0-beta.28.10 — No Pseudos

- Added the No Pseudos acquisition restriction with supported pseudo-legendary classification.
- Existing owned Pokémon are preserved rather than removed when the rule is enabled.

## 2.0.0-beta.28.9 — 0.1.81 compatibility targeting and local-scope cleanup

- Targeted the Gen1Recomp 0.1.81 compatibility profile.
- Continued removing/restructuring unreachable long-lived locals to keep the large Lua chunk within compiler limits.

## 2.0.0-beta.28.8 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.7 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.6 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.5 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.4 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.3 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.2 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.1 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28 — beta.28 development-line start

- Started the beta.28 development line directly after beta.27.16.
- The early beta.28 sequence collectively expanded Gold integration, compatibility reporting, setup/QoL features, and engine-version hardening; some exact per-build allocation remains partially reconstructed.

## 2.0.0-beta.27.16 — final beta.27 reported-bug hardening

- Hardened Gold Game Corner `Specials.HANDLERS`/`Specials.ALL` capture and restoration independently, without manufacturing a handler where vanilla or another mod left a registry entry absent.
- Restored/exposed the Gold Nickname Rule and required non-empty nicknames for supported catches and scripted gifts.
- Used Gold's VM-blocking rename seam for supported `givepoke` acquisitions so story-command continuation resumes at the exact native point.
- Broadened the Gold Ball gate to accept explicit static/fixed provenance as well as the native `battle.wild` shape for compatible fixed encounters.
- Clarified Ball Use tier 4 as `STANDARD` and tier 5 as `ALL`; the change corrected presentation while preserving the already-distinct cumulative mechanics.
- Preserved the generation-specific R/B/Y versus Gold Game Corner map IDs after review showed they were intentionally different, not a typo.
- The preserved beta.27.16 package recorded an expanded **66-check structural/engine gate** and **49-check headless interaction smoke suite**.

## 2.0.0-beta.27.15 — repository and release-candidate hardening

- Fixed Gold boss progression to recognize Gen 2 trainer-battle shapes rather than requiring Gen 1's `battle.kind == "trainer"`.
- Seeded existing R/B/Y Elite Four/Champion completion and Gold Johto/Kanto Gym/League progression from supported story/badge state.
- Corrected the Johto middle-Gym order to Chuck → Pryce → Jasmine while retaining live ace-level lookup.
- Prevented level-cap regression when an earlier defeated boss becomes stronger than the next boss through trainer overhaul mods.
- Added safe fallback for unknown/future Gen 1 version identifiers and normalized malformed fractional level-cap scope values.
- Invalidated dynamic `trainer.party` observations when the active mod set changes.
- Corrected the compatibility report to match exported Nuzlocke Compatibility API v22 and ensured every advertised capability had an explicit default relationship.
- Expanded provider method/result aliases, Gold World Building queue compatibility, and title-menu save/new-game detection while preventing duplicate Setup insertion.
- Added the first preserved dependency-free Node release gate and headless Lua smoke harness for this line.

## 2.0.0-beta.27.14 — live boss-cap compatibility

- Centralized authoritative next-cap calculation across enforcement and status UI.
- Read merged trainer rosters and observed composed trainer-party results so runtime trainer-level edits can feed cap calculation.
- Added public `getNextLevelCapInfo` compatibility output.

## 2.0.0-beta.27.13 — encounter-area splits

- Added OFF/CARDINAL splitting for Routes 1–25.
- Added OFF/COMMON Mt. Moon floor splitting and Safari Zone area splitting.
- Added physical-map provenance and reversible projection across tracker/history/catch-state views.

## 2.0.0-beta.27.12 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

## 2.0.0-beta.27.11 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

## 2.0.0-beta.27.10 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

## 2.0.0-beta.27.9 — glitch/MissingNo acquisition handling

- Added conservative MissingNo/glitch-species classification for known MissingNo identities plus flagged, malformed, or unregistered species records.
- Added the player-facing **Allow Glitches** rule: OFF blocks new glitch-species acquisitions on supported R/B/Y and Gold paths while preserving already-owned Pokémon.
- Normalized Catch Info/tracker/history handling for supported glitch-species records instead of assuming every acquisition maps cleanly to ordinary registered species data.
- Classification remained conservative/fail-open when incomplete modded metadata could not prove a species was a glitch.

## 2.0.0-beta.27.8 — Maximum BST acquisition rule

- Added numeric **Maximum BST** with `000/OFF` or `001–999` selection.
- Applied supported BST acquisition checks to wild catches, scripted gifts, and trades while keeping mandatory starters exempt from rejection.
- Used Gen 1 combined SPECIAL and Gold split special-stat data appropriately when computing base-stat totals.
- Merged available species metadata and failed open when complete/reliable base stats were unavailable rather than blocking an unknown modded species on guessed data.
- Preserved Dupes evaluation ahead of the BST gate and exposed the rule through Nuzlocke Compatibility API v15-era metadata.
- Lua 5.1 structural validation passed for the implementation; representative in-game numeric/acquisition coverage remained required.

## 2.0.0-beta.27.7 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

## 2.0.0-beta.27.6 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

## 2.0.0-beta.27.5 — Gold compatibility-surface refinement

- Added Gen2Compat coverage/member inspection for compatibility reporting.
- Stopped trying to replace Gold's already multi-page Trainer Card for Nuzlocke status; Gold status moved to its own Start-menu screen path.

## 2.0.0-beta.27.4 — Save Editor and compatibility-layer hardening

- Detected Gen1Recomp's embedded Save Editor loader session and avoided installing gameplay-bound runtime monkey patches there.
- Separated engine-version compatibility metadata from inter-mod compatibility relationships.

## 2.0.0-beta.27.3 — shared-seam compatibility negotiation

- Built directly from beta.27.2 and audited against the Gen1Recomp 0.1.79 line.
- Repaired the shared `ItemEffects.use` seam used by item-rule enforcement.
- Expanded advertised compatibility capabilities to shared engine/UI surfaces such as item use, shops, battle finish, Trainer Card, party/start menus, screens, static encounters, trainer parties, and boss caps.
- Began separating encounter-loss presentation from owned-Pokémon death presentation with **LOST ENC.** / **DEATHS** terminology, while the deeper legacy-history status overlap remained for the later beta.29.2.0 migration.
- Advanced the additive compatibility surface to Nuzlocke Compatibility API v11 while retaining backward-compatible older provider expectations.

## 2.0.0-beta.27.2 — preserved beta.27 development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not yet been recovered from surviving records; no history is inferred beyond its confirmed place in the sequence.

## 2.0.0-beta.27.1 — preserved beta.27 development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not yet been recovered from surviving records; no history is inferred beyond its confirmed place in the sequence.

## 2.0.0-beta.27 — promoted public baseline

- Promoted directly from the runtime-tested beta.26.6 line without an intentional gameplay change during promotion.
- Gold fresh startup/New Game, RULES, TRACKER, Catch Info, and Cyndaquil starter acquisition had runtime PASS evidence at promotion.
- Yellow RULES/TRACKER/catch behavior and prior 1st Catch toggle behavior carried runtime PASS evidence.
- Save schema remained 4.

## 2.0.0-beta.26.6 — Gold gift enforcement and Whiteout consequence

- Ran supported Gold `givepoke` gift legality checks before story/party mutation while preserving mandatory starter handling.
- Added the Gen 2 `finishBattle` consumer for the Nuzlocke Whiteout path while leaving Whiteout OFF on the native path.
- Gold ordinary gift denial and destructive Whiteout still required dedicated runtime confirmation at this revision.

## 2.0.0-beta.26.5 — acquisition and Whiteout correctness

- Corrected fallback gift/trade acquisition classification and generation-gated R/B/Y starting resources.
- Reworked Whiteout teardown to preserve the engine's wrapped finish chain instead of duplicating public teardown operations.

## 2.0.0-beta.26.4 — Tracker clarity and progression-aware TV

- Replaced cryptic failed-encounter labels with `FAILED <species>` and renamed the Tracker result column for clarity.
- Added failed-result marquee presentation and progression-aware Tier 3 home-TV run recaps.
- Preserved runtime evidence for Yellow UI controls, failed encounters, next-cap display, and fresh No Buying/No Selling.

## 2.0.0-beta.26.3 — early-game dialogue and TV polish

- Clarified Pokédex activation messaging and added adaptive Tier 3 home-TV flavor.
- Preserved runtime evidence for Yellow Setup/bedroom startup, starter Catch Info, No Mom Heal, PokéCenter behavior, and opening-rival flavor timing.

## 2.0.0-beta.26.2 — Gym Guide alignment and runtime-evidence rollup

- Re-centered the R/B/Y Gym Guide Rare Candy quantity screen without changing service mechanics.
- Recorded runtime PASS evidence for existing Red/Blue No Buying/No Selling, Red Gym Guide service, Blue No Field Heal, and nickname-aware catch flavor.

## 2.0.0-beta.26.1 — dialogue and starter-metadata polish

- Improved No Mom Heal dialogue ownership, starting-Ball wording, early R/B/Y starter Catch Info canonicalization, and Nuzlocke battle-message wrapping/paging.

## 2.0.0-beta.26 — runtime-tested canonical baseline

- Promoted the runtime-tested 26B10 development revision and retired the prior lettered internal-revision convention.
- Carried the published 25D4-RBY2 title/startup repair, Soft Start, Pokédex handoff, starting resources, two-view R/B/Y Trainer Card, Gold beta Setup, nickname handling, and first-rival timing.
- Save schema remained 4.

## 26B10 — runtime-tested beta.26 promotion candidate

- Known internal development revision directly descended from the published 25D4-RBY2 startup/menu hotfix and promoted forward as `2.0.0-beta.26`.
- This era accumulated runtime-driven verification/fixes around Gold Setup, PP-item restrictions, Pokémon Center restrictions, No Buying/No Selling, Gym Guide behavior, Repels, X Items, startup/menu lifecycle, and related compatibility paths.
- Exact per-change attribution inside the B-series is incomplete, so only the confirmed `26B10` promotion point is given its own heading.
- Its runtime PASS evidence became protected baseline evidence for later beta.26/27 development.

## 2.0.0-beta.25 — 25D4-RBY2 — R/B/Y startup/menu hotfix

- Runtime-confirmed Blue and Yellow title SETUP plus Oak-intro-to-bedroom startup.
- Runtime-reconfirmed Gold Setup/New Game and smoke-tested an existing Red save.
- Restored the proven title Setup injection and removed an unsafe optional post-intro screen push that caused a white screen.

## 2.0.0-beta.25 — 25D2 — Gym Guide handoff diagnostic

- The Gym Guide Rare Candy offer/registration path was functioning, but runtime testing still failed at the quantity-screen handoff.
- The failure was isolated to selector lifecycle/continuation rather than the long-lived direct-row Gym Guide composition or candy policy.

## 2.0.0-beta.25 — 25D3 — Gym Guide selector lifecycle repair

- Changed only the failing quantity-screen lifecycle to use Gen1Recomp's current blocking `push_screen` script-command behavior.
- Preserved NPC registration, vanilla dialogue composition, quantity choices, and candy-grant policy.
- Runtime testing reported the 1/10/25/50/99 selector working after this repair.

## 2.0.0-beta.25 — 25D4 — item-rule and Gym Guide stabilization

- Runtime-confirmed No Repels and No X Items and retained established passes for No Escape, healing/field restrictions, nickname, Center, shops, and Gym Guide quantity selection.
- Hardened item recognition, PP-item coverage, acquisition/recovery paths, and Whiteout teardown while preserving save schema 4.

## 2.0.0-beta.24 — Gold Setup experiment

- Attempted Gold automatic New Game Setup through an intro hook; runtime evidence showed the attempt remained vanilla, leading to the later title-menu design.

## 2.0.0-beta.23 — early Gold status and provenance work

- Added experimental Gold Trainer Card status integration and Gen 2 Egg/Day Care/roaming provenance support.
- Generation-gated the R/B/Y Gym Guide integration.

## 2.0.0-beta.22 — conflicting surviving records

- A directly surviving committed beta.22 source identifies itself as **"static integrity + version/persistence hardening"**, carries save schema 4 and Nuzlocke Compatibility API v7, and does not contain the later Gold/Gen2 adapter markers visible in beta.25-era source.
- A later reconstructed beta.25 changelog attributes generation-native Gold capture, permadeath, nickname, Mart, starter/gift, area-tracking adapters, and Gen 1 + Gold manifest targeting to a beta.22 stage.
- Because these records conflict, the current history preserves both facts without pretending they describe the same exact code snapshot. The Gold adapter work was present by the later beta.23–25 line, but its precise first beta.22 build/revision is unresolved.

## 2.0.0-beta.21 — Gold/GSC architecture groundwork

- Reconstructed directly from beta.20 while preserving save schema 4 and existing rule/save behavior.
- Added version-profile architecture and experimental Gold/GSC targeting groundwork; the surviving reconstruction audited against Gen1Recomp 0.1.78.
- Expanded progression architecture through Red/postgame-provider concepts and the R/B/Y Trainer Card active-rule display.
- Preserved a two-row R/B/Y Trainer Card rule display and expanded World Building Tier 1/2/3 labels in the reconstructed build.
- The reconstructed beta.21 compatibility surface is recorded as Nuzlocke Compatibility API v9; later planned semantics not proven present in that source remain unassigned.

## 2.0.0-beta.20 — compatibility and regression hardening

- Built as a surgical update from beta.19 rather than a branch replacement.
- Centralized item/capture/shop policy exports, improved provider surfaces, persistent identity/recovery, Trainer Card/Catch Info, and Gym Guide behavior while preserving save schema 4.

## 2.0.0-beta.19 — protected reconciliation baseline

- Served as the protected canonical baseline for the beta.20 surgical update line.
- Recovered project-log evidence identifies beta.19 as the point where split **No Buying** / **No Selling** replaced the retired combined shop rule, persistent Pokémon identities were established, and Dupes supported OFF / SPECIES / FAMILY modes.
- Numeric starting resources, separate item restrictions, presets, R/B/Y-specific handling, additive save/persistence reconciliation, and transactional gift/trade enforcement were present in the protected baseline.
- Multiple legitimate same-area tracker catches were preserved as separate records instead of being collapsed together.
- Wonderlocke remained visible/dormant and forced OFF; the baseline also carried the v0.1.77-era audit work, Blue/Yellow Setup/cursor fixes, and removal of the old NEXT BOSS display.
- Some earlier feature-by-feature introduction points remain unrecovered, so this entry records known beta.19 baseline properties rather than claiming every listed feature originated in beta.19.

## 2.0.0-beta.16 — reconstructed from surviving source/release records

- Fixed Setup-menu helper scoping/order behavior and retained the established Gym Guide architecture.

## 2.0.0-beta.15 — surviving source with conflicting later reconstruction

- The directly surviving committed beta.15 source identifies itself as **"Menu crash fix"**, carries **save schema 2**, and exports **Nuzlocke Compatibility API v6**.
- A later reconstructed beta.25 changelog instead attributes a Gen1Recomp 0.1.77 compatibility pass and the move to save schema 3 to beta.15.
- The conflict is retained explicitly. Current evidence does not safely identify which later beta.15/internal revision first carried schema 3, so the changelog no longer states that transition as certain.
- Wonderlocke remained disabled/dormant through the surviving records.

## 2.0.0-beta.14 — reconstructed save-schema revision

- Surviving history shows the future-safe migration framework at **save schema 2** by this snapshot.
- Continued tracker/recovery hardening while keeping unfinished Wonderlocke behavior non-active.

## 2.0.0-beta.12 — first surviving versioned save-schema baseline

- Added the first surviving future-safe persistent save-schema baseline at **schema 1**.
- Used an idempotent marker-only migration so older/vanilla saves could establish a versioned migration boundary without rewriting unrelated gameplay data.
- Preserved the established beta.8-era Gym Guide direct-row composition/selector and the existing Setup, provenance/recovery, level-cap, Tracker/Catch Info, and Trainer Card systems.

## 2.0.0-beta.11 — surviving development snapshot

- Improved catch-location recovery for human-readable saved locations.
- Changed the Rare Candy selector cursor presentation to the native theme cursor without changing selector lifecycle.
- Only source-supported history is retained; broader exact delta is not inferred.

## 2.0.0-beta.10 — surviving development snapshot

- Added native cursor/scroll presentation work and Trainer Card refinements.
- Continued the established Gym Guide direct-row + dedicated-selector behavior and dormant Wonderlocke-era infrastructure.
- Only source-supported history is retained; broader exact delta is not inferred.

## 2.0.0-beta.8 — surviving development snapshot

- Experimental provider/Wonderlocke-era infrastructure was present by this revision.
- The Gym Guide direct-row composition architecture that survived into later releases was already established by this period.

## 2.0.0-beta.5 — surviving legacy-reconciliation snapshot

- Added legacy catch-location reconciliation/recovery work.
- Gym Guide behavior remained on the earlier implementation of that period.
- Only source-supported history is retained; broader exact delta is not inferred.

## 2.0.0-beta.4 — World Building introduction

- Added World Building tiers and associated optional flavor/mechanic messaging.
- Added level-cap-aware Gym Guide feedback before the Rare Candy selector.

## 2.0.0-beta.3 — surviving logic-audit snapshot

- Added/expanded provenance-aware catch recovery and compatibility work by this surviving snapshot.
- The Gym Guide Rare Candy feature was already present with its dedicated **1 / 10 / 25 / 50 / 99** quantity selector.
- Only source-supported history is retained; broader exact delta is not inferred.

## 2.0.0-beta.1 — surviving Whiteout-fix snapshot

- A surviving source snapshot identifies this revision as an early Whiteout-fix stage.
- Only source-supported history is retained; broader exact delta is not inferred.


## 2.0.0-beta.29.3.7 — Gold compatibility smoke pass

- Rolled directly from 2.0.0-beta.29.3.4; no repository files added or removed.
- Static smoke audit rechecked Gold-specific capture, nickname, Mart, field-item, catch-tutorial, gift, static, gambling, Whiteout, egg, roamer, and Nuz Status adapters.
- Gold adapters remain generation-scoped and fail-open when an upstream seam is unavailable.
- Route Forgiveness and No Catching remain TEST REQUIRED on Gold pending runtime validation.
- Existing R/B/Y runtime-PASS behavior was not intentionally changed.

## 2.0.0-beta.30.0.0.1
- Added Random Encounters with persistent per-slot species rolls.
- Added Random Learnsets with persistent per-species/per-slot move rolls.
- Added Learnset Gen: AUTO / GEN1 / GEN2.
- Preserves encounter levels/structure and learnset levels/size.
- Reversible runtime-registry transforms reapply after load/provider lifecycle events.
- No repository files added or removed.
- New paths are TEST REQUIRED.

## 2.0.0-beta.30.0.0.2
- Added **No Fishing** under Field Items; blocks rod use before fishing begins while leaving rod ownership and non-fishing encounters untouched. Includes tiered Kanto/Johto world-building. Gold is TEST REQUIRED.

## 2.0.0-beta.30.0.0.3
- Added public `mod.exports.nuzlocke` interoperability API v1.
- Added capability/provider registration instead of hardcoded mod-name compatibility.
- Added acquisition classification/evaluation for wild, gift, trade, starter, scripted, editor, summon, quest, forced, and Wonder Trade sources.
- Added public item-policy evaluation for alternate Bag/shortcut/automatic-use UIs.
- Added effective Pokémon/encounter/move/learnset registry access plus registry-change notifications.
- Added a post-distribution EXP ownership seam so EXP providers can own distribution while Nuzlocke retains cap enforcement.
- Random Encounter/Learnset transforms now notify registry consumers.
- FAFF0x collection is now an explicit first-class compatibility target, implemented through capabilities rather than FAFF0x IDs.
- All new interop paths are TEST REQUIRED.

## 2.0.0-beta.30.0.0.4
- Expanded Interop API v1 for the FAFF0x QoL compatibility pass.
- Added `itemPolicy.beforeUse/canUse/check/checkUse` for Modern Bag, Item Shortcut, Repel Reuse, favorites and other alternate item-use paths.
- Added `acquisitionPolicy.begin/commit` and explicit acquisition kinds for DexNav, Summon and scripted providers.
- Added `encounterPolicy.evaluate` convenience entry for external encounter starters.
- Added `pcPolicy.evaluate/can` for alternate PC/box UIs; dead Pokémon remain unusable without trapping ordinary PC navigation.
- Added registry revision counters and `registry.describe()` for Pokédex Plus/Moves Manager-style consumers.
- Added EXP cap discovery helper while preserving provider-owned distribution.
- Bridged selected new APIs through legacy `nuzlocke_compat` exports.
- No hardcoded FAFF0x IDs added. All runtime certification remains deferred.

## 2.0.0-beta.30.0.0.5
- Fixed a fatal Encounter Tracker recovery/removal path reported on an existing Yellow save originating from beta.29.3.16.
- Root cause: the legacy-recovery UI could attach a live Pokémon object directly to a persisted `tracker_log.__LEGACY__` entry, then serialize that contaminated tracker table during REMOVE ENTRY.
- Legacy recovery rows are now detached UI views; live Pokémon references never mutate persisted tracker records.
- Added a narrow migration sanitizer that removes only known transient UI fields (`mon`, `logEntry`, `savedEntry`) from legacy tracker records before tracker serialization.
- Manual recovery now maps detached UI rows back to their original saved record explicitly.
- No catch history, provenance, encounter-rule semantics, or unrelated tracker behavior was rewritten.
- Runtime status: FIX IMPLEMENTED / RETEST REQUIRED, especially Yellow existing-save REMOVE ENTRY.

## 2.0.0-beta.30.0.0.6
- Added the FAFF0x quest/content provider layer to Interop API v1.
- Added dynamic area registration that feeds the existing Encounter Tracker catalogue.
- Added provider-declared dungeon families so Gym/Dungeon Lock-In can recognize mod-added dungeons without hardcoded quest names.
- Added custom boss metadata registration for future difficulty/cap consumers.
- Added quest gift and scripted/repeatable encounter source registration.
- Acquisition policy can now fill missing kind/species/area metadata from registered content sources.
- Added randomizer opt-out policies for story-critical encounters and species learnsets.
- Random Encounter Tables honors encounter-record/provider `randomizable=false` policies.
- Random Learnsets honors provider/species preservation policies.
- Added `content.registerBundle()` so quest packs can register areas, dungeons, bosses, gifts, encounters, and randomizer policies in one call.
- Preserved the 30.0.0.5 Yellow Encounter Tracker serialization repair unchanged.
- Runtime certification remains deferred / TEST REQUIRED.

## 2.0.0-beta.30.0.0.7
- Added the FAFF0x automatic/legacy compatibility adapter layer.
- Scans the active mod graph after `mods.loaded` and describes common behavior families (alternate Bag/item UI, automatic item use, PC UI, external encounter starters, registry consumers, EXP distributors, quest providers, reusable machines) without using those names as enforcement branches.
- Explicit provider registration still wins; automatic adapters only fill gaps for released mods that predate the Nuzlocke API.
- Added passive Pokémon acquisition reconciliation after game/save readiness so externally granted Pokémon can be surfaced as scripted/provider acquisitions instead of being silently treated as vanilla catches.
- Added convenience adapter gates for external item use, encounter starts, PC actions, and effective-registry snapshots.
- Automatic acquisition reconciliation is observational and never deletes externally granted Pokémon.
- Preserved 30.0.0.5 Yellow tracker crash repair and 30.0.0.6 quest/content provider APIs.
- Runtime certification remains deferred.

## 2.0.0-beta.30.0.0.8
- Consolidated the 30.0.0.3–30.0.0.7 compatibility architecture without adding a new gameplay feature.
- Added canonical provider capability families: `item_provider`, `storage_provider`, `encounter_provider`, `exp_provider`, `registry_consumer`, and `quest_content_provider`.
- Existing legacy capability names remain additive aliases; no provider integration was intentionally broken.
- Added `interop.resolveCapability()` with explicit-provider precedence over automatic legacy adapters.
- Documented provider-owned mechanics vs Nuzlocke-owned challenge policy/provenance.
- Preserved the Yellow Encounter Tracker REMOVE ENTRY serialization repair.
- Preserved FAFF0x QoL, content-provider, randomizer opt-out, and automatic-adapter work.
- No repository files added or removed.
- Compatibility changes remain TEST REQUIRED until the planned runtime certification pass.

## 2.0.0-beta.30.0.0.9
- Added provider-owned non-core feature delegation in the Nuzlocke Setup/Rules UI.
- When an active provider explicitly owns a duplicate non-core mechanic, Nuzlocke shows its duplicate control as effective OFF, greys the row, and prevents toggling.
- Delegated rows remain selectable so the description panel identifies the handling mod/provider and version.
- Stored Nuzlocke preferences are preserved dormant and automatically become effective again if the external provider is disabled/removed.
- Core Nuzlocke challenge policy is never implicitly delegated: death, One Per Area, Dupes, catch legality, Type Locke, item bans, lock-ins, legendary/mythical/pseudo bans, etc. remain Nuzlocke-owned.
- Initial delegated duplicate mechanics include level caps, starter/encounter/learnset randomizers, running shoes, default naming/tutorial-skip QoL, trainer-money provider, and starting-resource provider capabilities.
- Explicit providers take precedence; legacy/automatic adapters remain fallback-only.
- Added automatic recognition hints for Randomizer, Level Cap, and Running Shoes behavior families.
- Preserved all 30.0.0.8 compatibility consolidation and the Yellow tracker crash repair.

## 2.0.0-beta.30.0.0.11
- Compatibility-only child of 2.0.0-beta.30.0.0.10.
- Expanded the engine compatibility range from `>=0.1.81 <0.1.84` to `>=0.1.81 <0.1.85`, allowing Gen1Recomp 0.1.84 to load the mod.
- Gen1Recomp 0.1.84 still documents Mod API 2 as the current standard, so no API-level migration was made.
- No gameplay rules, save schema, compatibility providers, randomizers, tracker logic, UI behavior, or protected fixes were intentionally changed.
- This build is a minimal boot-compatibility checkpoint so broader 30.0.0.10 work remains preserved for subsequent children.
- Runtime validation on 0.1.84 is required.

## 2.0.0-beta.30.0.0.12
- Future-proofed the manifest engine range from `>=0.1.81 <0.1.85` to `>=0.1.81 <1.0.0`.
- Future Gen1Recomp 0.x patch/minor releases will no longer be rejected solely because their version number crossed our previous ceiling.
- Kept a deliberate `<1.0.0` major compatibility boundary: a future 1.0 may legitimately change contracts and should be reviewed rather than silently trusted.
- Remains Mod API 2 and save schema 4; no gameplay rules or save semantics changed.
- This does not claim unknown future engine releases are runtime-certified. It changes loader policy from exact-patch allowlisting to API-family compatibility.
- No files added or removed.

## 2.0.0-beta.30.0.0.13
- Compatibility repair for runtime-confirmed missing Nuzlocke SETUP on genuinely fresh Blue and Gold boots under Gen1Recomp 0.1.86.
- Preserves `ui.title_menu.items` as the primary public title-menu integration.
- Adds conservative generation-specific title-list fallbacks that run after normal menu construction and insert SETUP only when there is no CONTINUE row and no existing SETUP row.
- R/B/Y fallback wraps `src.ui.TitleState:openMenu`; Gold fallback wraps `src.ui.gen2.MainMenu:buildList`.
- Fallbacks are idempotent and explicitly refuse duplicate SETUP insertion.
- Existing-save behavior remains unchanged: SETUP stays hidden when CONTINUE/a save is present.
- Narrowed the experimental 30.0.0.12 `<1.0.0` engine range to the actively investigated `>=0.1.86 <0.1.91` family.
- No gameplay-rule, save-schema, randomizer, tracker, or provider-policy behavior intentionally changed.
- Runtime retest required on fresh Blue and Gold saves.

## 2.0.0-beta.30.0.0.14
- Fixed a load-blocking Lua parser failure introduced in 30.0.0.13.
- Root cause: the 0.1.86 title-menu compatibility fallback added enough locals to the already-large top-level `main.lua` chunk to exceed the runtime parser's local-variable ceiling.
- Moved the complete title fallback implementation into a nested immediately-invoked function so its helper locals belong to a separate Lua function prototype instead of the top-level chunk.
- No title-menu behavior was intentionally changed from 30.0.0.13.
- No gameplay rules, save schema, provider behavior, randomizer behavior, or documentation file set changed.
- Fresh Blue and Gold SETUP runtime test remains required after confirming the mod now loads.

## 2.0.0-beta.30.0.0.15
- **Approved first Lua module split.** Added `title_setup_compat.lua`; no existing file was removed.
- Moved only the 0.1.86 fresh-game title SETUP compatibility fallback out of `main.lua`.
- Uses Gen1Recomp 0.1.86's documented sandbox-safe multi-file pattern: source is read with `mod:read(...)`, compiled with sandboxed `load(...)`, and therefore inherits the mod's sandbox environment.
- Fixes 30.0.0.14's `ambiguous syntax` parser failure by removing the IIFE entirely rather than applying another parser workaround.
- Rationale: 30.0.0.13 hit the large main chunk's parser/local pressure; 30.0.0.14 then introduced an ambiguous statement boundary. Isolating this self-contained compatibility adapter lowers main-chunk pressure and follows upstream's supported multi-file design.
- Expected impact is limited to title/startup SETUP injection. Core rules, saves, encounters, battles, tracker, randomizers, compatibility providers, and Gold gameplay are not intentionally changed.
- **Compatibility confidence is temporarily reduced until runtime tests confirm Blue and Gold startup, Setup selection, existing-save behavior, and representative gameplay.**
- Further Lua splitting requires new explicit user approval.

## 2.0.0-beta.30.0.0.16
- **Approved second Lua module split.** Added `trainer_rewards.lua`; no existing file was removed.
- A real Lua parser reproduced 30.0.0.15's failure exactly: `too many local variables (limit is 200) in function at line 23`.
- The first narrow wallet-only extraction was intentionally rejected before packaging because parser validation showed `main.lua` still exceeded the limit.
- The completed second module therefore uses the originally approved cohesive boundary: trainer-money scaling, Forgiveness Token counters/shop bridge/Gym-trainer awards, trainer reward identity helpers, and Gym/E4/Champion progression bookkeeping.
- Core battle/death rules, encounter legality, failed-encounter finalization, tracker, randomizers, title setup, general provider policy, and Gold gameplay systems remain in `main.lua`.
- `trainer_rewards.lua` uses Gen1Recomp's documented sandbox-safe `load(mod:read(...))` multi-file pattern.
- Directly affected systems are Trainer Money, Forgiveness Tokens/shop presentation/awards, and trainer progression used by level-cap reporting. These are RETEST REQUIRED.
- Other systems have no intentional logic change but remain smoke-test targets after the structural compile repair.
- Every Lua file and `manifest.json` are validated before packaging.
- Further Lua splitting requires new explicit user approval.

- Added a non-module structural safeguard after the approved second split: the late runtime-installer section now executes inside a nested function stored temporarily on `mod.exports.__beta26`. This creates a separate Lua local scope without adding another repository file or changing system ownership.
- This was necessary because parser validation showed the approved trainer-reward extraction alone still left `main.lua` above the 200-active-local ceiling.
- Final packaged state passes the available Lua parser for `main.lua`, `title_setup_compat.lua`, and `trainer_rewards.lua`.

- Added a non-module structural safeguard after the approved second split: the late runtime-installer section executes inside a nested function stored temporarily on `mod.exports.__beta26`. This creates a separate Lua local scope without adding another repository file or changing system ownership.
- Parser validation showed the approved trainer-reward extraction alone still left `main.lua` above the 200-active-local ceiling; the nested scope supplies the remaining compiler headroom.
- Final packaged state passes the available Lua parser for `main.lua`, `title_setup_compat.lua`, and `trainer_rewards.lua`.

## 2.0.0-beta.30.0.0.17
- Yellow runtime PASS on 30.0.0.16: existing save booted, Nuzlocke menu entries were visible, and in-game Nuz Rules opened successfully.
- Yellow runtime observation: Permanent Rule Seal correctly remained irreversible after activation, but activation safety was too weak.
- Replaced the old one-warning/two-press seal with **two explicit warning stages plus a third deliberate SEAL activation**.
- Warning 1/2 explains irreversibility; Warning 2/2 is a final confirmation; only the next activation commits the permanent seal.
- Moving the cursor away, collapsing/expanding a section, activating another control, or pressing B cancels the staged confirmation.
- Added a short input debounce between confirmation stages to reduce accidental keyboard/gamepad double advancement.
- The description panel now shows the active warning stage in both R/B/Y and Gold, including title Setup where overworld/world-text presentation is unavailable.
- No new Lua modules were added and no existing files were removed.
- Permanent Rule Seal persistence remains monotonic by design once the final confirmation is committed.

## 2.0.0-beta.30.0.0.18
- Yellow runtime PASS on 30.0.0.17: Permanent Rule Seal correctly prevented modification of challenge-rule sections while leaving QoL, World Building, and UI/presentation sections editable.
- Yellow runtime FAIL on 30.0.0.17: the permanent seal did not survive exiting/reloading when no subsequent ordinary Pokémon SAVE had persisted `mod.save`.
- Root cause aligned with Gen1Recomp 0.1.86's documented persistence model: `mod.save` is stored inside normal progress and therefore requires an ordinary Pokémon SAVE to become durable.
- Permanent Rule Seal now mirrors its irreversible commitment immediately to playthrough-scoped `mod.storage` under `rules/permanent_seal`.
- On `save.loaded` and `game.ready`, Nuzlocke reconciles the durable storage marker back into `rules_permanently_locked` + `rules_locked`.
- Older saves that already contain the permanent `mod.save` marker are automatically mirrored into durable storage when loaded.
- If playthrough storage is temporarily unavailable, current-session `mod.save` locking still occurs and lifecycle reconciliation retries later.
- No other rule is moved to independent storage; ordinary configurable rules continue to follow the Pokémon SAVE model.
- No new Lua files/modules added or removed.

## 2.0.0-beta.30.0.0.19
- **Permanent Rule Seal moved to WIP/dormant status.**
- The row remains visible but is grey, displays `WIP`, is skipped by cursor navigation, and cannot be activated, matching Wonderlocke's placeholder behavior.
- The complete confirmation, immediate `mod.storage` durability, durable-read, and lifecycle reconciliation implementation remains in `main.lua` behind `mod.exports.__beta26.permanentRuleSealWip = true`; it was not deleted.
- Existing `.17/.18` development-test seals are **not enforced while WIP**, so challenge rules become editable again. Their `rules_permanently_locked` and `rules/permanent_seal` markers are preserved rather than erased.
- Generic setters/presets cannot activate the effective `rules_locked` state while WIP.
- No additional Lua module split was made and no files were added/removed.

## 2.0.0-beta.30.0.0.20
- Yellow runtime on 30.0.0.16 reconfirmed the recurring dialogue-page overlap/duplication defect: unrelated vanilla NPC text repeated trailing phrases at the start of subsequent pages.
- This is the second occurrence in the current testing conversation and is now tracked as a recurring protected regression target rather than a one-off.
- Added a global **World Building presentation invariant**: `pushWorldText()` refuses to push optional Nuzlocke flavor text if any `TextBox` is already active on the game state stack.
- Rationale: Gen1Recomp textboxes are foreground/blocking states. Optional nested Nuzlocke text must not interrupt a vanilla dialogue transaction and then resume it at an already-presented page/scroll boundary.
- This guard affects cosmetic World Building presentation only. Mechanical enforcement must not depend on `pushWorldText()` and remains unchanged.
- Direct rule-denial flows that intentionally replace a blocked action remain separate and are not globally suppressed.
- Yellow `NUZ` trainer-card/status vertical placement remains a known deferred cosmetic issue: current position is too low and should later move slightly upward, but not back to its previous overly-high position.
- Permanent Rule Seal remains WIP/grey/unselectable from 30.0.0.19.
- No Lua files/modules added or removed.

## 2.0.0-beta.30.0.0.21
- Percentage-based rule presentation is now consistent across Rules/Setup and Nuzlocke status surfaces.
- Trainer Money uses one shared percentage-label table everywhere: 0%, 25%, 50%, 75%, 100%, 150%, 200%, 300%, 500%.
- Maximum BST is no longer a free-form three-digit editor.
- Maximum BST now cycles through **OFF / 400 / 450 / 500 / 550** with A or Left/Right like other preset controls.
- The enforcement/API contract still uses the actual BST threshold value, not a preset index.
- Older development saves containing a non-preset custom BST value preserve that exact enforcement value until the player changes Maximum BST; the UI marks it CUSTOM, and the next change snaps to the nearest point on the preset ladder before moving in the requested direction.
- No new Lua modules/files added or removed.
- Yellow NUZ vertical placement remains deferred; duplicate-dialogue `.20` fix remains independently RETEST REQUIRED.

# 2.0.0-beta.30.1.0

Promotion release based directly on `2.0.0-beta.30.0.0.21`.

## Runtime-confirmed Yellow results carried into this release
- **PASS — existing-save boot and Nuzlocke menu visibility.**
- **PASS — in-game Nuz Rules opens on an existing Yellow save.**
- **PASS — Gym Lock-In boundary enforcement.** The tested Yellow Gym boundary correctly prevented the prohibited entry/exit transition. This runtime-confirmed behavior is protected against casual rewrite.
- **PASS — duplicate-dialogue regression target, tested NPC.** The Yellow Poké Mart NPC that previously repeated trailing phrases across textbox pages no longer reproduced the defect after the 30.0.0.20 active-TextBox World Building guard.
- The active-TextBox guard is retained as a **protected presentation compatibility safeguard**: optional Nuzlocke World Building text must not be layered over an already-active engine/other-mod TextBox. This is presentation-only and must never become required for mechanical enforcement.

## Promoted development work
- Gen1Recomp 0.1.86–0.1.90 compatibility target.
- First approved modularization retained:
  - `title_setup_compat.lua`
  - `trainer_rewards.lua`
- Permanent Rule Seal remains **WIP / grey / unselectable**. Its dormant implementation and recovery map remain preserved for later work.
- Trainer Money/status percentage presentation uses explicit `%` labels.
- Maximum BST uses preset selection: **OFF / 400 / 450 / 500 / 550** while preserving legacy custom thresholds until changed.
- Yellow `NUZ` status placement remains a known deferred cosmetic issue: it is currently slightly too low and should later move upward a little, but not back to the previous overly-high position.

## Validation
- `main.lua`, `title_setup_compat.lua`, and `trainer_rewards.lua` pass the available Lua parser/compiler check before packaging.
- Static success is not promoted to runtime PASS unless explicitly listed above.
- Blue/Gold fresh-game SETUP behavior and modularized Trainer Money/Forgiveness/progression paths remain runtime-test targets where not already confirmed.

# 2.0.0-beta.30.1.1

Gold NEW GAME -> SETUP crash containment, built directly from `2.0.0-beta.30.1.0`.

- Runtime FAIL: selecting the Nuzlocke Setup entry during a fresh Gold NEW GAME crashed the 30.1.0 candidate.
- Compared the current Gold title path against the last published `2.0.0-beta.29.1.0`.
- The published/runtime-PASS design already used the shared `ui.title_menu.items` injection plus the small Gold `src.ui.gen2.MainMenu:choose()` adapter.
- Disabled only the later 0.1.86-era Gold `MainMenu:buildList()` compatibility fallback from `title_setup_compat.lua`.
- The disabled `installGold()` implementation is preserved verbatim inside a Lua long comment for future diagnosis/recovery; it was not deleted.
- R/B/Y `title_setup_compat.lua` fallback remains active.
- No broader Gold gameplay systems, rules, tracker, randomizer, battle, item, mart, encounter, or provider changes were reverted.
- Gold NEW GAME -> SETUP is now RETEST REQUIRED.
- `2.0.0-beta.30.1.0` should be treated as a rejected runtime-crash candidate, not the release build.

# 2.0.0-beta.30.1.2

Release/documentation child of `2.0.0-beta.30.1.1`. **No intended gameplay/code behavior change beyond version identity.**

## Accepted known bug for this beta release

- **KNOWN RUNTIME CRASH — Gold fresh NEW GAME -> SETUP selection.**
- Runtime retest on 30.1.1 still crashes when selecting the Nuzlocke SETUP entry on Gold.
- The earlier attempt to withdraw the newer Gold `MainMenu:buildList()` compatibility fallback did **not** resolve the crash.
- The disabled fallback remains preserved in comments for future investigation.
- Do **not** claim Gold fresh-game SETUP is working in this release.
- Gold remains BETA/experimental and this specific startup configuration path is a known broken path accepted for release due to development pause.

## Runtime evidence retained

- Yellow existing-save boot: PASS.
- Yellow Nuzlocke menu visibility: PASS.
- Yellow in-game Nuz Rules: PASS.
- Yellow tested Gym Lock-In boundary rejection: PASS / protected.
- Yellow specific Poké Mart duplicate-dialogue regression case: PASS after the active-TextBox World Building guard.
- Permanent Rule Seal remains WIP / grey / unselectable.
- Yellow `NUZ` status vertical placement remains a known deferred cosmetic issue.

## Release discipline

- This build descends directly from 30.1.1.
- No older branch was restored.
- No additional Lua split was performed.
- All current repository files are retained.
- Lua parser validation passes for all three Lua sources.

# 2.0.0-beta.30.1.3

Setup/Nuz Rules crash-containment diagnostic based directly on 30.1.2.

- The same Setup crash was reproduced using unchanged, **unsplit** published 29.3.0 gameplay Lua on the current engine. The existing split therefore is not sufficient evidence for the crash cause.
- Current Gen1Recomp's screen resolver pcall-isolates a failed mod screen factory and then attempts a built-in fallback. `NuzlockeConfigScreen` is custom-only, so a construction failure can become a missing-builtin desktop crash.
- Every Nuzlocke Setup/Nuz Rules open now goes through a protected public `mod.ui.push` transaction.
- If construction fails, the game should stay alive and show `NUZLOCKE SETUP ERROR` with the underlying error text.
- The error is retained in `mod.exports.__beta26.lastConfigScreenError`.
- While implementing this guard, adding one more top-level local caused Lua's **200-local compile limit** to fire. The guard is therefore export-backed rather than local. This confirms the monolithic chunk has essentially no local-variable headroom and strengthens the case for another carefully planned split later, but does not by itself explain the current Setup crash.
- No additional split is included in this diagnostic build.

# 2.0.0-beta.30.1.4

Runtime-method crash diagnostic, built directly from 30.1.3.

- 30.1.3 still crashed without showing its guarded-construction error box.
- This strongly suggests `NuzlockeConfigScreen` is constructing/pushing successfully and failing on its first runtime frame rather than during `mod.ui.push`.
- Wrapped the configuration screen instance's `update()` and `draw()` methods with protected calls.
- On a Lua runtime failure, the faulty instance disables itself, attempts to pop, and shows `NUZ SETUP UPDATE ERROR` or `NUZ SETUP DRAW ERROR` containing the underlying error.
- `lastConfigScreenError` is updated with the phase and traceback/error.
- No additional module split or gameplay-rule change.

# 2.0.0-beta.30.1.5

Fresh Setup sandbox compatibility repair, built directly from 30.1.4.

- Identified a concrete current-engine incompatibility before the Setup screen is pushed.
- The legacy Setup profile loader/saver directly accessed the mod-blocked filesystem facade.
- Gen1Recomp 0.1.86 explicitly blocks that facade inside sandboxed mods and directs mod authors to public mod persistence/read APIs instead.
- Because those accesses occurred before `NuzlockeConfigScreen` opened, earlier construction/update/draw crash guards could not intercept the failure.
- Replaced cross-restart Setup-profile file I/O with session-local Gen1/Gold profile copies.
- Fresh Setup no longer touches the blocked filesystem facade.
- Normal active-save rule persistence is otherwise unchanged.
- Temporary limitation: closing the application resets saved Setup-profile preferences to defaults until a later pass chooses a deliberate public cross-restart preference-storage contract.
- No additional Lua module split was added.

# 2.0.0-beta.30.1.6

Release candidate built directly from 30.1.5 with no intended gameplay behavior changes beyond version identity/documentation.

## Runtime-confirmed current-engine compatibility

- **Gold fresh NEW GAME -> Nuzlocke SETUP: RUNTIME PASS.**
- **Yellow fresh NEW GAME -> Nuzlocke SETUP: RUNTIME PASS.**
- **Blue fresh NEW GAME proceeds into the player's bedroom: RUNTIME PASS.**

These passes confirm the 30.1.5 fresh-Setup sandbox repair on the tested current Gen1Recomp line.

## Confirmed crash repair

The fresh-game Setup CTD was traced to legacy pre-game Setup-profile persistence touching the filesystem facade directly. Gen1Recomp 0.1.86 blocks that facade in sandboxed mods. The forbidden access occurred before `NuzlockeConfigScreen` was pushed, which is why earlier screen-level crash guards did not intercept it.

30.1.5 replaced that path with per-session Gen1/Gold Setup-profile storage. 30.1.6 preserves that implementation unchanged and records the successful runtime validation.

## Remaining limitation

- Setup-profile preferences currently persist only for the running Gen1Recomp session.
- Fully closing/reopening the application resets those pre-game Setup preferences to defaults.
- Rules committed to an actual game save continue using their normal save-backed persistence.

## Protected runtime evidence retained

- Yellow existing-save boot: PASS.
- Yellow Nuzlocke menus visible: PASS.
- Yellow in-game Nuz Rules: PASS.
- Yellow tested Gym Lock-In boundary rejection: PASS / protected.
- Yellow tested Poké Mart duplicate-dialogue regression case: PASS after the active-TextBox World Building guard.
- Gold and Yellow fresh Setup: PASS.
- Blue fresh NEW GAME bedroom entry: PASS.
- Permanent Rule Seal remains WIP / unselectable.
- Yellow `NUZ` vertical position remains a deferred cosmetic issue.

## Validation

- Direct child of 30.1.5.
- No older branch restored.
- Repository tree retained at 13 files.
- Lua sources: `main.lua`, `title_setup_compat.lua`, `trainer_rewards.lua`.
- All Lua files pass the real Lua parser.

# 2.0.0-beta.30.1.7

Gold Pokégear integration development build, directly from 30.1.6.

## New — optional Pokegear Cards integration

When active `pokegear_cards` API v1 is available on Gold, Nuzlocke now integrates through its append-only `mod.exports` API.

### NUZ Pokégear card
- Adds a `NUZ` strip card.
- Four pages: Run Status, Encounters, Rules, Caps & Difficulty.
- Live catches, deaths, Route Forgiveness Tokens, active Nuzlocke loadout, area counts, failed encounters, Gold rule names, next authoritative cap/boss, and selected difficulty provider.
- UP/DOWN changes pages. A on Rules advances additional rule rows. B returns through the provider's normal card behavior.

### MAP overlay
- Adds encounter-state markers without replacing the vanilla MAP.
- Aggregates visited/open, failed, and caught/claimed tracker state by Gen 2 landmark.
- Caught takes precedence over failed, which takes precedence over visited/open when several maps share a landmark.
- Filters Johto/Kanto landmark markers to the currently displayed regional map.
- Uses the provider's scissored overlay helper and does not own MAP input.

### RADIO World Building
- Adds one short Nuzlocke broadcast/status line when World Building is enabled.
- T1 is direct status, T2 uses Johto-report framing, T3 uses deterministic landmark/run-state flavor.
- Cosmetic only: never changes tuning, station availability, music, story flags, encounters, or enforcement.

### Compatibility
- PHONE intentionally untouched because Pokegear Cards documents visible phone appends as an input-loop fork.
- Detection is `mod.find("pokegear_cards")`: installed-but-disabled is not treated as active.
- Stable IDs: `nuzlocke_status`, `nuzlocke_map_status`, `nuzlocke_radio_world`.
- `pokegear_cards` added as an optional dependency.
- New focused `pokegear_integration.lua` uses sandbox-safe sibling loading.
- R/B/Y behavior unchanged.

## Validation
- Existing 30.1.6 Setup sandbox repair unchanged.
- Package tree expands from 13 to 14 files with the focused integration module; nothing removed.
- All four Lua files parser PASS.
- Mock provider registration PASS: one card, MAP append, RADIO append, zero PHONE appends.
- New Gold Pokégear paths remain TEST REQUIRED.

# 2.0.0-beta.30.1.8

Provider-delegation bugfix child of 30.1.7.

## Fixed — Trainer Money provider delegation

Two related defects remained in the 30.0 provider-delegation system.

1. Runtime Trainer Money scaling ignored `externalRuleDelegation`.
   - The Rules UI could correctly show the control as externally owned while `trainer_rewards.lua` still applied Nuzlocke's stored multiplier after battle.
   - This could stack Nuzlocke payout scaling on top of an active `economy_provider`.
   - `scaleTrainerMoney()` now checks the same delegation seam and, when delegated, leaves the provider's final wallet result completely untouched.

2. Delegated numeric UI assumed `spec.min` was always the neutral value.
   - Trainer Money has `min = 0`, but index 0 means 0% payout.
   - Its actual neutral/vanilla value is index 4 = 100%.
   - Numeric rule specs can now declare `neutral`.
   - Trainer Money declares `neutral = 4`.
   - `getConfigValue()` resolves delegated numerics as `spec.neutral` first, then falls back to `spec.min`.

## Compatibility

- No provider: Trainer Money behavior remains unchanged.
- Active `economy_provider`: Nuzlocke performs no Trainer Money wallet rewrite.
- Delegated Trainer Money displays 100%, not 0%.
- Existing Gold Pokégear work from 30.1.7 is unchanged and remains runtime TEST REQUIRED.
- No files added or removed.

## Validation

- All four Lua files parser PASS.
- Dedicated mocked Trainer Money delegation test PASS:
  - delegated payout left untouched;
  - nondelegated 50% payout still scales correctly.
- Static neutral-value check PASS: delegated Trainer Money resolves to index 4.

# 2.0.0-beta.30.1.9

Gold level-cap ordering repair, directly from 30.1.8.

## Fixed — Johto middle-Gym cap regression

The current `gscStages` list had regressed to:

`Chuck 30 -> Jasmine 35 -> Pryce 31 -> Clair 40`

That reintroduced a non-monotonic raw stage ladder. The runtime cap floor could prevent the enforced value from physically dropping, but direct stage readers and boss presentation could still observe Pryce's raw 31 after Jasmine's 35.

The preserved project history already records the intended repair from beta.27.15: the cap-progression order is:

`Chuck -> Pryce -> Jasmine`

30.1.9 restores that ordering without inventing new cap numbers:

`Chuck 30 -> Pryce 31 -> Jasmine 35 -> Clair 40`

### Important distinction

Gold badge slot mappings are unchanged:
- Chuck / Storm remains badge slot 5.
- Jasmine / Mineral remains badge slot 6.
- Pryce / Glacier remains badge slot 7.

Those are save/badge identity mappings, not the ordered boss-cap ladder. Reordering `gscStages` does not rewrite or renumber Gold badges.

## Previous 30.1.8 fixes retained

- Trainer Money runtime scaling respects active `economy_provider` delegation.
- Delegated Trainer Money neutral display is 100% / index 4.

## Validation

- All four Lua files parser PASS.
- Static stage-order audit PASS.
- Gold Johto Gym fallback cap sequence is monotonic: 9, 16, 20, 25, 30, 31, 35, 40.
- No files added or removed.

# 2.0.0-beta.30.1.10

Title Setup save-editor hardening, directly from 30.1.9.

## Fixed — recurring title wrapper used only install-time save-editor gating

`title_setup_compat.lua` previously checked `isSaveEditorSession()` only when installing the R/B/Y title fallback wrapper. If the wrapper was installed while editor mode was inactive, later title-menu opens could still run SETUP insertion after the process/session entered a save-editor context.

The R/B/Y wrapper now re-checks `isSaveEditorSession()` on every `TitleState:openMenu()` call before inspecting or modifying the final title row list.

The same per-call protection is applied to the Gold recurring title-list wrapper where that adapter is present.

The existing install-time checks remain as cheap early-outs, but runtime/session-sensitive editor state is no longer assumed to be permanent.

## Validation
- All four Lua files parser PASS.
- Static wrapper audit confirms per-call editor checks are present in recurring title-menu fallback callbacks.
- No files added or removed.
- 30.1.8 Trainer Money provider fixes and 30.1.9 Gold cap-order repair are retained.

# 2.0.0-beta.30.1.11

Trainer Rewards split-module namespace repair, directly from 30.1.10.

## Fixed — Gold Mart Route Forgiveness crash

`G2.installMartGate()` called `forgivenessEnabled()` as a bare global from `main.lua`. That function belongs to the separately loaded `trainer_rewards.lua` module and is exported through `mod.exports.__beta26.TrainerRewards`.

On Gold, constructing a STANDARD Mart while Route Forgiveness was enabled could therefore throw `attempt to call a nil value (global 'forgivenessEnabled')`.

The Mart wrapper now calls:
`mod.exports.__beta26.TrainerRewards.forgivenessEnabled()`.

## Fixed — bare Forgiveness Token count call in rules/status presentation

A second instance of the same split-module namespace bug was found in the rule-label path:
`forgivenessTokens()` was also called as a bare global.

It now calls:
`mod.exports.__beta26.TrainerRewards.forgivenessTokens()`.

This prevents the Route Forgiveness status/summary path from depending on a nonexistent main-chunk global.

## Validation
- Searched `main.lua` for unqualified `forgivenessEnabled(` and `forgivenessTokens(` calls: none remain.
- All four Lua files parser PASS.
- 14-file package tree unchanged.
- Prior 30.1.8 Trainer Money fixes, 30.1.9 Gold cap order, and 30.1.10 title save-editor guard retained.

# 2.0.0-beta.30.1.12

Stored-location recovery orphan fix, directly from 30.1.11.

## Fixed — conflicting stored catch location could be falsely marked recovered

`importStoredCatchLocations()` previously set `mon.nuzlockeTrackerRegistered = true` even when the stored location conflicted with a different already-established catch in that area and no tracker/area entry was written.

That combination could permanently orphan the Pokémon:
- no new area log entry;
- no `caught_areas` restoration;
- stale `catchLocation` still present;
- false registered marker prevented later recovery logic from treating it as unresolved.

30.1.12 now marks the mon registered only when the stored location actually restores or matches tracker state. A true conflict clears the stale `catchLocation` and false registered marker so the mon remains eligible for normal Legacy Recovery.

Successful empty-area and matching-entry recovery behavior is otherwise unchanged.

## Validation
- All four Lua files parser PASS.
- Static recovery audit confirms the conflict branch clears `catchLocation` and registration.
- Focused three-case branch harness PASS: empty restore, matching restore, conflicting Legacy fallback.
- No files added or removed.

# 2.0.0-beta.30.1.13

Solo Only scripted-trade enforcement fix, directly from 30.1.12.

## Fixed — Solo Only gated gifts but not NPC trades

`specialAcquisitionDenied()` applied the Solo Only party-slot check only when `kind == "gift"`.

Wild catches were already covered through the normal catch gate, and gifts were covered here, but scripted trades in both R/B/Y and Gold route through `specialAcquisitionDenied(..., "trade")` and therefore bypassed Solo Only.

A player could complete an NPC trade while Solo Only was active and add a second usable party Pokémon, violating the selected challenge rule.

30.1.13 extends only that final Solo Only acquisition check:

- gift acquisitions: unchanged, still gated;
- trade acquisitions: now gated by the same occupied-solo-slot check;
- all earlier special-acquisition rule ordering is unchanged;
- existing `acquisitionDeniedMessage(..., "solo", ...)` handling is reused, so no new dialogue plumbing is introduced.

## Validation
- All four Lua files parser PASS.
- Focused acquisition-gate harness PASS:
  - gift + occupied solo slot -> `solo`;
  - trade + occupied solo slot -> `solo`;
  - gift/trade + available solo slot -> allowed by Solo Only;
  - unrelated acquisition kind is not newly blocked by this check.
- 14-file package tree unchanged.

# 2.0.0-beta.30.1.14

First Rival Mercy one-shot hardening, directly from 30.1.13.

## Fixed — non-opening rival-shaped battle could permanently burn First Rival Mercy

`armFirstRivalForgiveness()` previously persisted `nuzlocke_first_rival_battle_seen = true` immediately after the broad `isRivalBattle()` test, before the stricter `isOpeningRivalBattle()` check.

A later/reordered/rewound rival-classified battle could therefore consume the durable slot even though it was not the canonical opening encounter. If the true opening battle was reached afterward, First Rival Mercy could never arm for that save.

30.1.14 changes the latch semantics:
- non-rival battle: unchanged, ignored;
- rival but not opening rival: rejected without consuming the durable flag;
- actual opening rival: marks `nuzlocke_first_rival_battle_seen = true`;
- opening rival with First Rival Mercy OFF: still consumes the one-shot, preserving the original rule semantics;
- opening rival with First Rival Mercy ON: arms the battle-local forgiveness flag as before.

The existing `isOpeningRivalBattle()` old-save safeguard remains authoritative, so later rival fights on old saves are still never granted First Rival Mercy merely because the durable flag is absent.

## Validation
- All four Lua files parser PASS.
- Focused one-shot state-machine harness PASS.
- Static ordering audit confirms `isOpeningRivalBattle()` is evaluated before the durable save write and the save write occurs only after the `not opening` return.
- 14-file package tree unchanged.

# 2.0.0-beta.30.1.15

World Building tier-fallback consistency fix, directly from 30.1.14.

## Fixed — `queueTrainerFlavor` fallback ignored its caller-selected minimum tier

`queueTrainerFlavor(key, message, minimumTier)` correctly checked its requested tier before trying battle-native `say` / `emit`, but its last-resort path called `worldOnce(game, key, message)`.

`worldOnce` had a hardcoded Tier 3 gate. Therefore a caller such as First Rival Mercy, which explicitly requests Tier 1, could pass the outer Tier 1 gate and still lose its message on battle objects without `say` or `emit`.

30.1.15 makes `worldOnce` accept an optional `minimumTier`:
- omitted -> Tier 3, preserving its historical default;
- supplied -> honors the caller's explicit threshold.

`queueTrainerFlavor` now passes its own `minimumTier` into the fallback.

This preserves the same once-per-save flag behavior and the same `pushWorldText` safety path while making all three delivery seams agree on whether the message is eligible.

## Validation
- All four Lua files parser PASS.
- Focused fallback-tier harness PASS:
  - Tier 1 + minimum 1 + no say/emit -> fallback displays and sets once flag;
  - Tier 2 + minimum 1 -> fallback displays;
  - Tier 2 + default minimum 3 -> remains blocked;
  - failed text push -> does not consume once flag;
  - repeated successful call -> remains once-only.
- 14-file package tree unchanged.

# 2.0.0-beta.30.1.16

Type Locke canonical Fairy compatibility repair, directly from 30.1.15.

## Fixed — Fairy typings could be treated as unknown by Mono/Duo Type Locke

Compatible typing/content mods can add the canonical `FAIRY` type to the merged species registry. Nuzlocke's Type Locke vocabulary previously stopped at Dark/Steel, so a pure-Fairy species could produce no recognized Type Locke metadata and hit the intentional "unknown custom schema" fail-open behavior.

That meant a legitimate Fairy species could be allowed by an unrelated Monolocke simply because Nuzlocke did not recognize the canonical type.

30.1.16 adds canonical Fairy awareness to Type Locke.

### Save-safe selector layout

Existing numeric selector meaning is preserved exactly:
- `0..16` = existing Normal through Steel values;
- `17` = RANDOM, unchanged from every prior build;
- `18` = FAIRY, newly appended.

RANDOM is deliberately **not moved**. No migration of old saves or pending Setup profiles is required.

### Runtime behavior

- Fairy Monolocke is now selectable.
- Fairy may be either side of a Duolocke.
- Pure Fairy species are evaluated as Fairy rather than unknown/fail-open.
- Dual types such as Water/Fairy match either appropriate allowed type.
- RANDOM can roll Fairy only when Fairy is represented in the live merged species pool.
- RANDOM still never persists as runtime legality state; it resolves once to concrete type(s).
- Unknown genuinely custom type schemas continue to fail open.
- Manual Dark/Steel/Fairy selections remain possible even when the current base species pool has no such species, preserving compatibility-mod challenge setups.

### Compatibility target

This specifically closes the Nuzlocke-side gap found while reviewing `steel_typing` / STEEL-FAIRY AND TYPING CHARTS 2.0.1, but the implementation is package-name agnostic and works with any mod that exposes canonical `FAIRY` through the merged Pokémon/type metadata.

## Validation

- All four Lua files parser PASS.
- Selector compatibility audit PASS: RANDOM remains 17; FAIRY is 18.
- Focused Type Locke harness PASS:
  - Fire Mono rejects pure Fairy;
  - Fairy Mono accepts pure Fairy;
  - Water Mono accepts Water/Fairy;
  - Fairy Mono accepts Water/Fairy;
  - random viable pool includes Fairy only when a Fairy species is present;
  - old RANDOM value 17 still resolves as RANDOM, never Fairy;
  - DUO duplicate correction skips the RANDOM sentinel.
- 14-file package tree unchanged.

# 2.0.0-beta.30.1.17

Translation-safe R/B/Y Mart enforcement, directly from 30.1.16.

## Fixed — translated BUY / SELL labels could bypass No Buying / No Selling

The R/B/Y ShopMenu compatibility wrapper previously identified the two shop actions by comparing the rendered menu label only to literal English `BUY` and `SELL`.

Localization mods legitimately build those rows through `Strings("BUY")` and `Strings("SELL")`. For example, the Finnish translation renders them as `OSTA` and `MYY`. The old wrapper therefore failed to decorate either action, allowing purchases/sales despite the Nuzlocke rules being enabled.

30.1.17 keeps the existing English recognition and additionally compares each row against the current live translated `Strings("BUY")` / `Strings("SELL")` values.

No shop mechanics, stock, pricing, token behavior, or Gold Mart logic are otherwise changed.

## Validation
- All four Lua files parser PASS.
- Focused localization harness PASS:
  - English BUY/SELL detected;
  - Finnish OSTA/MYY detected through translated source values;
  - unrelated menu labels remain untouched.
- Existing Route Forgiveness shop stock bridge remains in the same wrapper.
- 14-file package tree unchanged.

# 2.0.0-beta.30.1.18

Optional Gen1 Modern UI presentation integration, directly from 30.1.17.

## Added — responsive presentation for high-use Nuzlocke information screens

When an active `gen1_modern_ui` provider exposes its documented `registerAdapter` API, Nuzlocke now publishes a source-owned semantic screen contract for:

- Encounter Tracker / Area Guide;
- NUZ INFO Catch / Stat / Move pages;
- Nuzlocke Trainer Card / active-rule status page.

Nuzlocke continues to own all underlying state and actions. The UI provider receives only read-only row models plus semantic navigation callbacks.

### Fail-safe behavior

- No hard dependency on Modern UI.
- Provider is detected as active through `mod.find`, not installed-only.
- Registration retries across load lifecycle events.
- If the provider is absent, unsupported, disabled, or rejects the contract, classic Nuzlocke screens remain unchanged.
- If a semantic model cannot be produced, the provider can fall back instead of Nuzlocke replacing mechanics.
- Gold is not registered because the inspected Modern UI line is Gen1-only.

### Deliberately not adapted yet

`NuzlockeConfigScreen` (Setup / Nuz Rules editor) now has a stable screen ID but remains native. Fresh Setup is protected runtime behavior and the editor owns complex numeric editing, collapsed sections, permanent-seal confirmation, descriptions, and staged pre-game state. It will only move to an external presenter after dedicated runtime validation.

### Internal classic screens retained

Native R/B/Y and Gold draw/update implementations remain intact. The integration is presentation-only.

## Validation

- All five Lua files parser PASS.
- 15-file package tree.
- Mock adapter provider registration PASS.
- Semantic model/action harness PASS for Tracker, NUZ INFO and Trainer Card.
- `.30.1.17` localization-safe Mart gate retained.

## 2.3.1 RC — Yellow New Game startup hotfix
- Direct child of 2.3.0 RC.
- Records 2.3.0 Yellow New Game as runtime FAIL on Gen1Recomp 0.1.98.
- Removes eager pre-overworld `mod.battle` / `mod.world` capability probing from the title/New Game path.
- Defers the new 0.1.98 field-action backstop until `map.entered`, when a real overworld exists.
- Preserves the 2.3.0 No Fishing, Gold item-policy, Gen II healing classification, and battle-snapshot interoperability work.
- Runtime retest required; static checks are not runtime PASS.
