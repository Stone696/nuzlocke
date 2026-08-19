## 2.5.23-DEV Yellow / fresh-New-Game confidence

### Runtime evidence that triggered this child
- **2.5.22 Yellow fresh New Game, Skip Opening Intro:** broad smoke test was stable with no crash found, but Random Starter returned vanilla Pikachu, starter provenance/logging was UNKNOWN/not Pallet Town, No Mom Heal failed to enforce, and the Yellow Oak Pallet capture demo did not skip.

### Source-confirmed repairs
- Random Starter's 2.5.22 caller referenced `Randomizer` / `seededIndex` outside the local block that owned them. 2.5.23 exposes the deterministic helper deliberately across the phase boundary; algorithm-v1 results are preserved.
- The R/B/Y `heal_party` / resolver / `give_pokemon` wrapper tail had been stranded outside `installNuzlockeFieldCommandPatches`, so the installer could not establish the complete Mom/starter transaction session. The tail is back inside its owning scope.
- Late-runtime phase 2, which owns the Yellow Oak demo skip and authoritative script-command Mom fallback, was staged and then cleared without execution. 2.5.23 executes it and records machine-readable health.
- Critical R/B/Y wrapper installers now also revalidate at `save.created`, matching the actual fresh-New-Game lifecycle.

### Confidence
**RUNTIME FAIL REPAIRED IN SOURCE / STATIC GATES PASS REQUIRED / EXACT RUNTIME RETEST REQUIRED.** Highest-value retest is the same Yellow fresh-New-Game path: Random Starter ON, Skip Catch Demo ON, No Mom Heal ON, then verify the starter is randomized/deterministic, logged as Pallet Town, Oak's demo is skipped while story continues, Mom refuses to heal, and the new DEV SELF TEST rows are healthy.

## 2.5.22-DEV kerning / randomizer-version confidence

### Source-confirmed repairs
- Gen 1 kerning previously treated a historical `Font._nuzlockeAdvanceOf` predecessor marker as proof that the live wrapper belonged to the current Nuzlocke reload. 2.5.22 records exact session token / previous / wrapper identity and only unwraps an exact top-level stale Nuzlocke session.
- Starter seeded selection previously duplicated the v1 hash input with literal `"1"` / `"v1"` strings. 2.5.22 routes starter selection through the same `Randomizer.algorithmVersion` + `seededIndex()` source used by encounters and learnsets.
- Current algorithm version remains 1, and the shared helper receives the same `1:SEED:STARTER:SCOPE` input as the old inline starter hash, so existing v1 deterministic starter results are intentionally preserved.

### Confidence
STATIC/SOURCE REPAIR / RUNTIME TEST REQUIRED. Highest-value checks: fresh-process Gen 1 kerning, a Nuzlocke reload followed by Gen 1 text rendering, and a known seed/starter comparison against 2.5.21 to confirm the v1 starter result is unchanged. A direct hot-upgrade from <=2.5.21 may request one fresh process because the old format did not record wrapper identity.

## 2.5.21-DEV trainer identity confidence
- **SOURCE/STATIC PASS, RUNTIME TEST REQUIRED:** Gym reward recognition and R/B/Y + Gold League progression now consume the same normalized trainer ID/class/name identity surface.
- Local invariants verify the shared extractor covers Gen 1 `oppClass`, generic provider class aliases, and Gold `trainer.classId` / `trainer.class`, and verify progression no longer reconstructs an id/name-only path.

## 2.5.20-DEV tracking/enforcement confidence
**SOURCE/STATIC PASS, RUNTIME TEST REQUIRED:** battle finalization now distinguishes PASSIVE_PROGRESS from RULE_ENFORCEMENT. Supported-save boss progression remains synchronized while Nuzlocke is OFF; Failed Encounter, Forgiveness Tokens, trainer-money rewriting, and post-battle Permadeath cleanup remain challenge-only; unsupported newer-schema saves are protected by the write-safety policy. Highest-value runtime checks are one Gym win with Nuzlocke OFF then ON, one failed wild encounter while OFF, and Forgiveness Token shop behavior while OFF.

## 2.5.19-DEV save/API confidence
Static/source PASS: newer-schema starter repairs and identity mutation paths now stop before direct save-backed mutation; compatibility engine reporting is defensive/fresh; schema bookkeeping descriptors and save-write wrapper ownership are strengthened. Runtime regression test remains required.


## 2.5.18-DEV infrastructure confidence
- **SOURCE/STATIC PASS, RUNTIME TEST REQUIRED:** Compatibility metadata defensive-copy hardening, effective-rule canonical fallback, Rule Registry collision reporting, Save Schema descriptor mirror/legacy metadata, and DEV SELF TEST copy safety.
## 2.5.17-DEV development-quality infrastructure

### Source/static confidence
- Build provenance binds this child to 2.5.16-DEV and the exact parent package SHA-256.
- Rule Registry descriptors are derived from the existing rule table/default resolver rather than becoming a parallel enforcement source.
- Save Schema descriptor coverage is deliberately limited to configuration/schema-control fields and does not claim full internal-save coverage.
- Compatibility API 28 adds per-capability contract-version negotiation; existing API-27 capability meanings remain compatible.
- Dev SELF TEST now audits all four development descriptors/contracts.

### Confidence
SOURCE/STATIC DEVELOPMENT-INFRASTRUCTURE PASS / GAMEPLAY RUNTIME SHOULD MATCH 2.5.16. Highest-value confirmation is DEV TOOLS -> SELF TEST showing PASS for `rule_registry_descriptor`, `save_config_descriptor`, `build_provenance`, and `compat_capability_versions`.

## 2.5.16-DEV reliability / diagnostics follow-up

### Source-confirmed repairs
- Public `ruleActive()` no longer reports a missing default-ON boolean rule as OFF.
- Missing `locke_type` reads/verification use the canonical NUZLOCKE fallback rather than historical CUSTOM/0 fallbacks.
- Remaining high-value direct wrappers verify live function identity, including AUTO-REPEL and both Wilds capture seams.
- Dev hook-health now reports substantially more enforcement/lifecycle seams.

### Confidence
STATIC/SOURCE REPAIR / RUNTIME TEST REQUIRED. Highest-value checks: missing-key/default-ON compatibility query if a safe dev seam exists; automatic names after reload; R/B/Y catch+Permadeath; Gold nickname/Mart/Game Corner; QoL AUTO-REPEL with No Repels; Wilds allowed/blocked overworld catch with tracking.

## 2.5.15-DEV reliability follow-up

**Static/source confidence: high; runtime confirmation required.**

- Confirmed: field-poison faints occur outside the battle Whiteout gates. 2.5.15 arms a generation-specific final-warp interception so **Whiteout ON** ends the run after an overworld poison wipe even with Permadeath OFF.
- Confirmed: Gold's `battle.run` payload carries a pure `Battle` object without `battle.game`; 2.5.15 resolves `currentGame/mod.game` so No Escape can activate on Gold.
- Confirmed: `applyNewGameSnapshot()` verified `locke_type` without writing it in that transaction. 2.5.15 persists the staged loadout before verification.
- Confirmed lifecycle risk: Party Size/PC withdrawal, Gold No Day Care, Gold battle Whiteout finish, Gold Headbutt tracking, and forgiveness-token mart stock still used boolean-only install markers. 2.5.15 moves those seams to owner-aware wrapper sessions.

Runtime test focus: poison full-party wipe with Whiteout ON + Permadeath OFF in one R/B/Y game and Gold; Gold ordinary wild RUN with No Escape ON/OFF; new-game preset persistence; PC party-limit withdrawal; Gold Day Care, Headbutt, Whiteout, and forgiveness-stock after a reload.

## 2.5.14-DEV bug-fixing / lifecycle follow-up

**Static/source confidence: high; runtime confirmation required.**

- Confirmed: R/B/Y `nuzlockeGivePokemon()` referenced `save.player.map` before its intended local `save = ctx.save` declaration. 2.5.14 fixes the ordering without changing gift/starter policy.
- Confirmed: several core enforcement reads used old inline OFF defaults despite the canonical fresh profile using One Per Area ON, Nickname Rule ON, Dupes FAMILY, Allow Gifts ON, and Allow Trades ON. 2.5.14 routes missing keys through the canonical default source; explicit saved values are untouched.
- Confirmed lifecycle risk: older R/B/Y catch/Permadeath and Gold capture wrappers relied on boolean install markers that can outlive a ModLoader's `mod` object. 2.5.14 records wrapper ownership/predecessors for future loader-session cleanup.
- Reviewed/no change: Gen1Recomp 0.2.7 TimeFishGroups row-local day/night values intentionally outrank the shared fallback table, so forced synchronization is not a safe compatibility fix.

Runtime test focus: starter provenance/nickname, R/B/Y catch refund/spend, R/B/Y faint/Whiteout, and Gold Ball/catch behavior.

## 2.5.13-DEV field-poison Permadeath follow-up

### Source-confirmed defect / static repair
- Gen1Recomp R/B/Y applies overworld poison directly in `OverworldState:applyFieldPoison`; the field path does not enter `BattleState:onFaint`.
- Gen1Recomp Gold `StepEvents.poisonStep` returns `poisonFaint` indices and `World:poisonFaintScript` owns the happiness/text/whiteout sequence; this path does not emit `battle.fainted`.
- Before 2.5.13, Nuzlocke's Permadeath bookkeeping was battle-faint driven, so a field-poison faint could remain outside `nuzlocke_history`/loss projection and be eligible for a later native heal.
- 2.5.13 records the exact field-fainted Pokémon through the existing death-history contract and removes those same live objects from the party while preserving native presentation and whiteout scheduling.
- Nuzlocke OFF and Permadeath OFF are unchanged; the new wrappers are owner-aware across loader sessions.

### Confidence
SOURCE/STATIC PERMADEATH REPAIR / RUNTIME TEST REQUIRED. Highest-value checks: one non-party-wipe poison faint and one full-party poison wipe in R/B/Y, then the same two cases in Gold. Confirm death count/history increments once per faint, the dead Pokémon is not restored by blackout healing, and Permadeath OFF leaves native behavior unchanged.

## 2.5.12-DEV Gen1Recomp 0.2.7 compatibility follow-up

### Source-confirmed defect / static repair
- Gold's shared `encounters` registry is merged into `game.data.gen2Encounters`; Nuzlocke's public `effectiveEncounters()` / `Registry.describe()` still exposed only `game.data.encounters`.
- 2.5.12 exposes the generation-correct final live table while preserving the existing randomizer/reveal/selection semantics.
- The final 0.2.7 Gold fishing schema (`TimeFishGroups`, `day`/`nite`) was reviewed. Nuzlocke's existing recursive randomizer and variadic fishing hook preserve the structure/signature; no encounter-generation rewrite is required.

### Confidence
STATIC/SOURCE COMPATIBILITY REPAIR / GOLD RUNTIME TEST REQUIRED. Useful smoke tests: Gold OPEN INFO + encounter-information consumer, day/night fishing with Good/Super Rod, No Catching/Ball Per Enc., and Gold mart restrictions.

## 2.5.11-DEV World Building T1 consistency follow-up

### Source-confirmed defect
- The canonical/default-rule path already returned World Building T1, but `worldTier()` still used a historical inline T3 fallback when the save key was absent.
- The generic numeric-value path also retained an inline T3 fallback for a missing/non-numeric World Building value.
- The rule description still said `RECOMMENDED: TIER 3`, contradicting the 2.5.4 default change.

### 2.5.11 static repair / TEST REQUIRED
- Live flavor resolution and configuration-value fallback now share `defaultRuleValue("world_building_tier")`.
- Rule copy now says `DEFAULT: TIER 1`.
- Explicit saved OFF/T1/T2/T3 selections are unchanged.

### Confidence
STATIC CONSISTENCY REPAIR / RUNTIME TEST REQUIRED. No enforcement, provider, API, schema, or engine-range semantics changed.

## 2.5.10-DEV Pokégear / tracker UI follow-up

### 2.5.9 source-confirmed defects
- Gold Pokégear NUZ RULES advanced by four rows but compared against a sliding-window max offset, making a non-multiple-of-four final page unreachable.
- The Pokégear RULES page gave no visible affordance that A advances the inner rule list.
- ENC TRACKER native and Modern UI views could show a blank list with no explicit empty-state explanation.

### 2.5.10 static repair / TEST REQUIRED
- Pokégear RULES uses true four-row page offsets, reaches final partial pages, shows `RULES x/y`, and advertises `A:MORE` when applicable.
- Native R/B/Y, native Gold, and Modern UI tracker views show translated `NO ENTRIES YET` for a genuinely empty selected data set.
- Modern UI still reports zero real entries and excludes the placeholder from selected detail/provider semantics.

### Confidence
STATIC UI REPAIR / RUNTIME TEST REQUIRED. No encounter/enforcement/save/provider semantics changed.

## 2.5.9-DEV Yellow setup follow-up

### Yellow 2.5.8 runtime PASS
- Fresh/new-profile Shiny Clause defaults to OFF/0.
- Type Locke can be edited in NUZ RULES without the prior generic update error.

### Yellow 2.5.8 runtime FAIL
- Saving NEW GAME setup failed with an attempt to index global `TYPE_LOCK_SLOT_INDEX`; the setup/profile code lived outside the lexical Type Locke owner block.
- Loadout warning readability improved, but it still hid additional owned-rule changes behind a `+N MORE` summary instead of allowing full review.

### 2.5.9 static repair / TEST REQUIRED
- Setup/profile Type Locke slot tests use the stable exported index accessor; Gold status Type Locke labels use the stable key accessor.
- Loadout warning scrolls through every changed owned rule with UP/DOWN.
- Nuzlocke-owned setup/rules/status errors use explicit manual pages.
- GAME DIFFICULTY then BATTLE MECHANICS are immediately above AREA SPLITS.

### Gold First Rival Mercy audit
NO CODE CHANGE. Gen1Recomp 0.2.7's `gen2_canlose_test.lua` pins the Cherrygrove battle to `BATTLETYPE_CANLOSE`: a loss resumes the script at the battle site with the starter still at 0 HP, and `.FinishRival` later runs `HealParty`. The existing G2 early return is therefore source-consistent; adding R/B/Y's temporary 1-HP bridge would be unnecessary divergence. Runtime Gold coverage remains useful, but this is not a confirmed defect.

## 2.5.8-DEV Yellow setup/rules repair

### Yellow 2.5.7 runtime FAIL
- Loadout-change warning remained visually broken: long preview rows crossed/clipped the modal frame.
- Changing Type Locke triggered the generic NUZ RULES update-error dialog (“Please report this text”).

### 2.5.8 static repair
- R/B/Y loadout preview rows are bounded to a native-width line; long rule names marquee inside their budget instead of drawing through the frame.
- Type Locke edit/update paths use lifecycle-stable exported slot/default accessors, including random Type Locke resolution.
- Fresh/new-profile Shiny Clause default is OFF/0; explicit existing values are not migrated or reset.
- Route Forgiveness is listed under GENERAL with mechanics unchanged.

### Confidence
STATIC REPAIR / RUNTIME TEST REQUIRED. Re-test Yellow loadout warning rendering and Type Locke OFF/MONO/DUO editing before promotion to PASS. The 2.5.7 Dev Report layout repair also remains runtime TEST REQUIRED.

## 2.5.7-DEV Dev Report presentation repair

### Blue 2.5.6 runtime PASS
- DEV TOOLS -> VIEW REPORT opened a previously saved report after a full game exit/relaunch without crashing. The 2.5.6 saved-report View Report crash repair is runtime PASS for that path.

### Blue 2.5.6 runtime FAIL / UI
- Dev Report text and the NZR4 Report Code overflow/clipped past the native R/B/Y viewport.
- Storage Info long identifiers such as the playthrough ID likewise overflowed.

### 2.5.7 static repair
- R/B/Y diagnostic content width reduced to 16 characters.
- Dev-only wrapping now hard-splits unbroken identifiers while preserving ordinary menu wrapping elsewhere.
- NZR4 is displayed beneath `REPORT CODE:` using the existing hyphen groups as safe break points.

### Confidence
STATIC UI REPAIR / RUNTIME TEST REQUIRED for layout. Verify full code visibility, Storage Info wrapping, scroll bounds, and no View Report crash regression. The shared 2.5.6 NUZ RULES edit fix is still TEST REQUIRED. The loadout warning popup remains a separate runtime-confirmed UI defect.

## 2.5.6-DEV Blue runtime repair attempt

### Confirmed 2.5.5 runtime FAIL
- NUZ RULES: toggling No Mom Heal and other ordinary rules can fail in the shared update path with `ipairs(nil)` after the live save write.
- DEV TOOLS: choosing VIEW REPORT crashes the game on the following update frame.

### 2.5.6 static repair
- NUZ RULES title/setup synchronization now has a canonical Type Locke slot/default fallback instead of crashing unrelated rule edits when the shared table reference is unavailable.
- DEV report rendering now captures a forward-declared local helper rather than an unresolved global.
- MOD COMPAT left rule-name rows are no longer pseudo-bolded by drawing the same label twice.

### Confidence
STATIC REPAIR / RUNTIME TEST REQUIRED. Do not mark either crash as PASS until exercised on Blue 2.5.6-DEV. The 2.5.5 opening-sequence repair remains separately TEST REQUIRED.

## 2.5.5-DEV Blue opening repair attempt

### 2.5.4 runtime PASS carried forward
- Blue Oak intro skip.
- Starting Balls.
- Starting Rare Candies.
- Starting healing items.
- Starting vitamins.
- Random starter selection presented correct randomized choices.
- BASE starter-style filter.

### 2.5.4 runtime FAIL / regression cluster
- Randomized Blue starter could skip mandatory Nickname Rule.
- Randomized Exeggcute starter was not attributed to Pallet Town.
- First Rival Mercy dialogue fired but opening Rival loss could restart/rewind opening progression.
- Repeated starter acquisition occurred.
- On the repeat, player starter randomized again while Rival starter synchronization was lost.

### 2.5.5 repair status carried into 2.5.6
Static repair attempted in 2.5.5 and carried forward without an intentional opening-sequence rewrite in 2.5.6. Runtime validation is REQUIRED on 2.5.6-DEV before any item is promoted to PASS.

## 2.5.4-DEV rules consolidation

Static PASS:
- World Building new-run default is T1.
- Cap Messages removed from the rule catalog.
- Cap notice policy fixed to once per battle on the first blocked/banked EXP award.
- Solo Only removed from rule catalog and duplicate enforcement.
- Party Size Limit is authoritative; SOLO/IRON use limit 1.
- Legacy Solo saves migrate to Party Size Limit 1.

Runtime retest:
- New setup shows World Building T1.
- First capped EXP event shows one notice; later capped EXP in the same battle stays quiet.
- SOLO preset sets Party Size Limit to 1 and all standard party-growth gates use that cap.

## 2.5.3-DEV Blue menu runtime follow-up

Runtime evidence: Pokémon Blue / Gen1Recomp 0.2.7 showed the pre-fix GENERAL layout and Ball Limit alignment.

Static PASS:
- No Catching + Ball Per Enc. now belong to BATTLE ITEMS.
- Ball Per Enc. is hidden whenever No Catching is ON.
- No Catching changes rebuild dependent rows immediately.
- Ball Per Enc. default remains OFF.
- GAME DIFFICULTY and BATTLE MECHANICS precede GENERAL.

Runtime retest:
- No Catching ON -> Ball Per Enc. disappears immediately.
- No Catching OFF -> Ball Per Enc. reappears immediately.
- Ball Per Enc. value column visually aligns with other controls.
- Confirm section order: GAME DIFFICULTY, BATTLE MECHANICS, AREA SPLITS.

## 2.5.2-DEV engine/diagnostic audit

### Static PASS
- `randomizer_info_policy` boolean/out-of-range diagnostic detection.
- No save migration added for that selector because the historical setter was already numeric.
- Gen1Recomp 0.2.1 → 0.2.7 release deltas reviewed sequentially.
- 0.2.2 shared Gold move-grid hook classified as additive/not-owned.
- 0.2.3 Gold BattleAPI item/catch-preview expansion requires no Nuzlocke enforcement change.
- Mod API 2 / engine save format 4 retained through 0.2.7.
- Engine range remains `>=0.1.86 <2.0.0`.

### Runtime retest
- Normal Yellow/Gold smoke test on Gen1Recomp 0.2.7 remains recommended.
- Gold mart rules and encounter/catch restrictions are especially useful smoke-test targets after upstream Gold UI/catching changes.

## 2.5.1-DEV validation status

This is a runtime-validation child of the unreleased 2.5.0 candidate. No gameplay logic changed from that candidate.

Priority runtime retests:
- Yellow Mom Heal ON/OFF.
- Field-item rejection pacing.
- Randomized starter Pallet Town Tracker/map projection.
- Shiny Clause persistence.
- Encounter Ball Limit persistence/enforcement.
- Randomizer Info Policy display persistence.
- Dev Report Species Facts row.
- NZR4 Report Code on the 2.5.x version line.
- Gold and multi-mod compatibility where practical.

## 2.5.0 publication confidence

### Static PASS
- Strict parent lineage from 2.4.100-DEV verified by SHA-256.
- Lua syntax validation (when `luac` is available).
- ZIP integrity.
- Exact 15-file package set preserved.
- Manifest/main/mod.card/docs version synchronization.
- All 36 `numeric = true` rules represented in default/get/set config plumbing.
- No duplicate rule keys in the 108-rule catalog.
- Dev Species Facts check targets the live `getSpeciesFacts` resolver.
- NZR4 encodes/decodes full major/minor/patch.
- Public exported build fields resolve to the current authoritative build.
- Engine range remains `<2.0.0`.

### Runtime evidence carried forward
- Yellow / AYN Thor / recent dev: No Field Heal enforcement with Potion — PASS.
- Several recent defects were found through Yellow runtime testing and repaired in the 2.4.94–2.4.100 line.

### Runtime retests still valuable
- Mom Heal ON/OFF after stale-wrapper repair.
- Player-paced field-item rejection pages.
- Randomized starter Pallet Town Tracker/map projection.
- Shiny Clause and Encounter Ball Limit persistence/cycling.
- OPEN INFO / BLIND INFO display persistence.
- Gold parity and multi-mod combinations.

Static PASS is not presented as a substitute for these runtime checks.

## 2.4.100-DEV Randomizer Info Policy
- Gameplay enforcement read: previously correct.
- setConfigValue 0/1 persistence: previously correct.
- getConfigValue 0/1 UI readback: static PASS after repair.
- Full numeric-rule default/get/set coverage sweep: static PASS.
- Runtime OPEN INFO ↔ BLIND INFO display persistence: RETEST REQUIRED.

## 2.4.99-DEV Encounter Ball Limit config plumbing
- defaultRuleValue OFF default: static PASS.
- getConfigValue numeric 0..5 readback: static PASS.
- setConfigValue numeric 0..5 persistence: inherited static PASS from 2.4.98.
- default audit coverage: static PASS.
- Dev stored/read comparison row: static PASS.
- Runtime cycle + leave/reopen persistence: REQUIRED.

## 2.4.98-DEV numeric selector setter repair
- `shiny_clause` setConfigValue numeric branch: static PASS.
- `encounter_ball_limit` setConfigValue numeric branch: static PASS.
- Boolean-artifact semantic repair: static PASS.
- Numeric-selector sweep identified these as the two missing branches in the current rule catalog.
- R/B/Y + Gold runtime selector cycling/persistence: RETEST REQUIRED.

## 2.4.97-DEV compact legacy mod IDs
- `CatchHelper` → `CATCHHELPER` capability detection: static PASS.
- Joined/separated fallback coverage for all multi-word hints in `detectCapabilities`: static PASS.
- Runtime legacy-adapter scan with compact IDs: TEST REQUIRED.

## 2.4.96-DEV randomized starter provenance
- Yellow/AYN Thor Tangela Pallet Town Tracker/map: prior runtime FAIL.
- Provenance-based starter resolver: static PASS.
- Existing-save narrow repair: static PASS.
- Yellow randomized starter Tracker + map runtime retest: REQUIRED.

## 2.4.95-DEV field-item rejection presentation
- Yellow/AYN Thor No Field Heal enforcement: RUNTIME PASS.
- Yellow/AYN Thor No Field Heal message pacing: prior runtime FAIL; repair static PASS, retest required.
- Yellow/AYN Thor No Rare Candy message pacing: prior runtime FAIL; repair static PASS, retest required.
- Battle rejection path unchanged.

## 2.4.94-DEV No Mom Heal
- Yellow/AYN Thor regression report: runtime FAIL on last release build.
- Stale-session/live-wrapper repair: static PASS.
- Dev `mom_heal_gate` health row: static PASS.
- Yellow No Mom Heal ON/OFF runtime retest: REQUIRED.
- Previous historical No Mom Heal runtime PASS remains evidence of intended behavior, not evidence that this regression is fixed.

## 2.4.93-DEV Report Code
- Bit-pack/base32 codec: static PASS.
- Live VIEW REPORT without storage/export: static PASS.
- Fixed-summary decode round-trip: source/static validated.
- Full free-form report binding: 20-bit fingerprint.
- Yellow/AYN Thor runtime: TEST REQUIRED.

## 2.4.92-DEV diagnostic UI layout
- Yellow/AYN Thor Storage Info overflow: confirmed runtime issue on last release build.
- Storage Info wrapped-row repair: static PASS; runtime retest required.
- Dev Report wrapped scrolling consistency: static PASS; runtime retest required.
- Diagnostic contents and gameplay remain unchanged.

## 2.4.91-DEV Dev Report layout
- Yellow/AYN Thor overflow report: confirmed runtime issue on last release build.
- Wrapped narrow-layout repair: static PASS; runtime retest required.
- Dev Report diagnostic contents are unchanged.

## 2.4.90-DEV Yellow Skip Catch Tutorial
- Static/source validation: PASS.
- Yellow opening Oak demo: RUNTIME RETEST REQUIRED.
- Yellow Viridian Old Man demo: TEST REQUIRED.

## 2.4.89-DEV Cap Messages
- Setter/type repair: static PASS.
- Default BATTLE: static PASS.
- Boolean-artifact migration: static PASS.
- Yellow A/LEFT/RIGHT runtime retest: REQUIRED.
- Level-cap enforcement itself is unchanged.

## 2.4.87-DEV menu runtime evidence
- Yellow: holding SELECT pages section headers — RUNTIME PASS.
- Yellow: SELECT + LEFT/RIGHT opens/closes all headers — RUNTIME PASS.
- Party Size Limit / Gym Team Size relocation — static PASS, presentation TEST REQUIRED.
- Existing rule enforcement is unchanged.

## 2.4.85-DEV Encounter Ball Limit
- Static/package validation: PASS.
- R/B/Y runtime: TEST REQUIRED.
- Gold runtime: TEST REQUIRED.
- Interaction tests required: No Catching, illegal encounter/species, successful catch before limit, failed throws through limit, new encounter reset.
- Prior runtime PASS evidence remains protected.

## 2.4.84-DEV old-save selector migration
- Static/package validation: PASS.
- Legacy `shiny_clause=true` migration to numeric 4: static PASS; runtime old-save TEST REQUIRED.
- Fresh-save Shiny selector behavior is unchanged.
- No Permanent Seal behavior changed.

## 2.4.83-DEV Yellow starter nickname
- Upstream Yellow native prompt: source/test confirmed.
- Nuzlocke Yellow composition: static PASS, runtime TEST REQUIRED.
- Red starter nickname prompt: prior runtime PASS preserved.
- Quick Start / intro-skip Yellow naming: TEST REQUIRED.

## 2.4.82-DEV PT-BR compatibility
- Static/source compatibility audit: PASS.
- `gen1_pt-br` v0.1.5 runtime combination: TEST REQUIRED.
- Priority tests: Yellow setup/starter naming, NUZ RULES, ENC TRACKER, Trainer Card/Nuz Info, battle UI, item lists, accented long text.
- Existing runtime PASS evidence remains protected.

## 2.4.81-DEV upstream compatibility
- Package/static validation: PASS.
- New BattleAPI snapshot consumption: TEST REQUIRED on a current engine.
- Yellow starter nickname flow: TEST REQUIRED.
- Prior runtime PASS behavior is not superseded.

## 2.4.80-DEV localization
- Static/package validation: PASS.
- Runtime translation-mod validation: TEST REQUIRED.
- No prior runtime PASS is superseded by this static pass.

# Nuzlocke 2.4.79 DEV feature-confidence ledger

**STATIC/SOURCE PASS is not RUNTIME PASS.**

## 2.4.79 — GEN1 BETTER MENUS SOURCE/STATIC COMPATIBILITY PASS; RUNTIME TEST REQUIRED

No gameplay feature receives a new runtime PASS. Gen1 Better Menus 1.0.3 shared UI seams were source-audited; deterministic optional-dependency ordering and descriptive compose metadata were added. R/B/Y combination remains TEST REQUIRED. Protected 2.4.78 Type Locke/Catch Draft behavior is unchanged.

## 2.4.78 — TYPE LOCKE EXPANSION / STATIC PASS, RUNTIME TEST REQUIRED
Source/static validation covers the 1-6 lane rule surface and Catch Draft state transitions. No runtime PASS is claimed yet for Quadlocke, Pentalocke, Hexalocke, Catch Draft completion, dual-type draft preference, or Gold draft behavior. Existing protected runtime PASS behavior remains protected.

## 2.4.77 — DOCUMENTATION-ONLY COMPATIBILITY AUDIT CONSOLIDATION

No gameplay feature receives a new runtime PASS in 2.4.77. The completed external-mod audit wave is consolidated in `docs/COMPATIBILITY.md`; all source/static/expected classifications remain below runtime certification. Protected historical PASS entries are unchanged.

## 2.4.76 — DOCUMENTATION-ONLY COMPATIBILITY LEDGER REFRESH

No gameplay feature receives a new runtime PASS in 2.4.76. Recent external-mod audits are recorded in `docs/COMPATIBILITY.md` as source/static/expected-compatibility classifications with explicit runtime-test requirements. Protected historical PASS entries are unchanged.

## 2.4.75 — KANTO REFORGED 1.2.0 CAP INTEROP STATIC PASS
- Source-confirmed KR `level_caps_on` storage and `LevelCaps.capFor(...)` calculation are adapted read-only.
- Simultaneous Nuzlocke + KR caps select the stricter live cap.
- Nuzlocke caps OFF leaves KR solely responsible.
- Runtime TEST REQUIRED for Gen1 and Gold combinations, including cases where Nuzlocke is stricter, KR is stricter, and both are equal.


## 2.4.74 — IPC 1.1.0 STATIC COMPATIBILITY PASS / GOLD RUNTIME TEST REQUIRED
- Indigo Plateau Conference adapter marker updated to 1.1.0.
- Existing priority -1000 post-battle dead-party prune structurally composes after IPC's ordinary survivor-heal listener.
- No new compatibility listener added.
- Runtime Gold combination still required: tournament win, tournament loss with a living survivor, and tournament loss involving a Nuzlocke-marked death.


## 2.4.73 — QUICK START USER RUNTIME PASS RECORDED
- R/B/Y Quick Nuzlocke Start / intro bypass: **USER RUNTIME PASS**.
- Observed caveat: handoff may occur outside before bedroom-PC item pickup; player can walk back inside and collect those items.
- Classified as a recoverable convenience issue, not a progression failure.
- Gold Quick Start remains separately runtime-test-required.


## 2.4.72 — STATIC POLICY CORRECTION PASS
- Restores the protected engine maximum `<2.0.0`.
- No runtime behavior changes relative to 2.4.71.


## 2.4.71 — STATIC COMPATIBILITY PASS / RUNTIME TEST REQUIRED
- Audited against released Gen1Recomp 0.2.0.
- Existing hook/event and storage contracts used by Nuzlocke remain present upstream.
- No gameplay adapter was changed solely for API novelty.
- Runtime smoke tests on Gen1Recomp 0.2.0 are still required for R/B/Y and Gold.


## 2.4.70 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Newer-schema escaped `mod.save:set(...)` attempts are now blocked after being counted; normal supported-schema writes still delegate.
- Direct Randomizer learnset application and Quick Start/default-name shortcut paths now fail closed while the newer-schema safe-stop is active.
- Deferred Starting Balls release and Skip Catch Tutorial are also guarded against newer-schema execution.
- Randomizer integrity recognizes the intentional zero-candidate vanilla fallback.
- Runtime tests required for schema-5+ write blocking, ordinary schema-4 save writes, Quick Start/default-name regression, Random Learnsets, and Randomizer-integrity FALLBACK reporting.


## 2.4.69 — PUBLISHED RELEASE / PRIOR STATIC RC PASS
- No new gameplay behavior relative to 2.4.68 DEV.
- RC packages the sequential development head for broad runtime validation.
- All protected historical runtime-PASS items remain protected expectations, but are not reclassified as freshly runtime-tested by this static RC pass.
- Recent 2.4.62–2.4.68 changes remain runtime-test-required where previously marked.


## 2.4.68 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Randomizer integrity audit is read-only and recursively scans the live encounter registry.
- The legality check composes generation mode, glitch/runtime safety, and canonical Nuzlocke acquisition legality.
- Delegated/opted-out content is excluded from Nuzlocke-owned violation judgments.
- Runtime validation required for inactive, owned-active, delegated, and intentionally constrained Random Encounter configurations.


## 2.4.67 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Rule-effectiveness audit is read-only and reuses canonical config normalization and delegation resolution.
- Applicable rules are generation-filtered; master/schema state is reported separately.
- Runtime validation required with clean ownership and at least one external delegated rule.


## 2.4.66 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- `mod.save:set(...)` is transparently observed only for future-schema safe-stop diagnostics; delegated write semantics remain unchanged.
- Any observed write attempt becomes a Dev assertion warning and is exported with per-key evidence.
- Runtime downgrade test target: synthetic/copied schema 5+ save with `safe_stop_writes.attempts == 0` throughout ordinary play/navigation.


## 2.4.65 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Six lifecycle counters are updated only by the existing Dev diagnostic listeners.
- Weak payload identity tracking detects repeated delivery without retaining event payloads indefinitely.
- `duplicate_callbacks > 0` is a self-test warning; `battle_delta` is context only.
- Runtime hot-reload/listener-stacking test still required.


## 2.4.64 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- `Dev.hookHealth()` inspects only `package.loaded` modules and therefore does not import/install a subsystem as a side effect of diagnostics.
- 13 generation-aware observable adapters are covered.
- CHAINED is informational; only MISSING contributes to the self-test warning aggregate.
- Runtime validation required in clean R/B/Y, clean Gold, and at least one compatibility stack where another mod wraps above Nuzlocke.


## 2.4.63 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Source review confirms `saveSchemaTooNew` now disables the shared `active(...)` enforcement gate.
- Known lifecycle writers identified in the downgrade audit are explicitly suppressed while the safe stop is active.
- Player warning is session-only and does not write acknowledgement into the newer-schema save.
- Runtime test required with a copied/synthetic save declaring schema 5+; verify no enforcement/repair writes and verify normal schema-4 saves remain unchanged.


## 2.4.62 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Random Encounter species pool now composes with canonical Nuzlocke acquisition legality before balance filtering.
- Static source review confirms persisted slot validation checks membership in the current candidate pool, so newly illegal saved choices cannot remain active; relevant mid-run legality edits also enter the existing randomizer reapply path.
- Static source review confirms an empty pool returns safely from encounter randomization after restoring the encounter snapshot.
- Runtime matrix still required for MONO/DUO/TRI Type Locke, each species ban, Maximum BST, balance modes, rule toggles mid-run, R/B/Y, and Gold.

## 2.4.60 — STATIC PASS / RUNTIME TEST REQUIRED

- Config/Setup and NUZ STATUS runtime crash handlers preserve full `xpcall` tracebacks in Dev diagnostics when enabled.
- Existing deferred recovery/dialog behavior remains unchanged.
- Runtime fault-injection is still required to confirm update/draw failures produce the expected breadcrumb/snapshot labels in R/B/Y and Gold.

## 2.4.59 — STATIC PASS / RUNTIME TEST REQUIRED
- Recursion-safe `Dev.pguard()` exists and preserves guarded-call result tuples.
- Ten selected high-value failure seams feed Dev error breadcrumbs/snapshots when Dev Mode is enabled.
- Provider species-metadata alternate-signature fallback remains intentional and does not warn when fallback succeeds.
- Encounter-ledger contradiction and malformed Shiny-state assertions are read-only.
- Mechanics-capability calculation remains unwrapped to avoid diagnostic recursion.
- 2.4.58 export/history logic is unchanged.
- Runtime test: force a synthetic provider/storage callback throw with Dev Mode ON and verify one bounded error + snapshot appears without a crash or recursive flood.

## 2.4.58 — STATIC PASS / RUNTIME TEST REQUIRED
- Pin-once battle encounter provenance.
- Full 48-breadcrumb export.
- Bounded 16-report history plus latest.
- Bare reload no longer fabricates readback verification.
- Test split-boundary catch/failure, Gold time split, save/reload, >16 exports/history pruning, READ/READBACK display.

## 2.4.57 launcher range + capture ledger — STATIC PASS / RUNTIME TEST REQUIRED
- Manifest accepts `>=0.1.86 <2.0.0`.
- Successful consumed-catch evidence is protected from FAILED downgrade.
- Capture ledger reconciliation runs before projection and save writes.
- Runtime save/reload tests are required on R/B/Y and Gold.

## 2.4.56 documentation integrity — STATIC PASS
- Documentation/metadata-only child of 2.4.55.
- Exact packaged `main.lua` load gate required.
- Auxiliary integrations and package tree unchanged.
- No runtime confidence is promoted by this build.

## Current TEST REQUIRED
- Gen1Recomp 0.2.1 R/B/Y + Gold smoke + Dev storage.
- Gold No Held Items (introduced 2.4.51).
- Historical Difficulty deepening (2.4.52 mechanics / 2.4.53 final profile set).
- Rules navigation (2.4.54–2.4.55).
- Limited Shiny / encounter-slot combinations.
- Encounter Tracker death projection.
- Save Editor/external-save reconciliation.
- Gold shared-rule parity.
- Forgiveness Token ¥1,000,000 settlement.
- Modern UI + Encounter Tracker historical crash regression.
- Gen9Dex/QoL/alternate UI/provider combinations.

## Historical build validity
- 2.4.38: compiler-invalid (>200 locals).
- 2.4.39: inherited compiler-invalid state.
- 2.4.40: repaired loadability.
- Current canonical packaged `main.lua` must pass the exact Lua load gate before handoff.

## Current historical Difficulty profile set
- Red: SHIN HARD*, PURE RGB*
- Blue: SHIN HARD*, BLUE KAIZO*
- Yellow: YELLOW LEGACY*, SHIN-STYLE*
- Gold: POLISHED*, LEGACY-STYLE*

## Backlog governance
Implemented features leave Planned in the same cycle. Live-but-unvalidated work belongs under Implemented / TEST REQUIRED, not Planned.
