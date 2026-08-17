## 2.4.10 current release

2.4.10 preserves the Forgiveness Token's intentional **¥1,000,000** advertised price with a token-specific cap-aware settlement path. The native wallet ceiling is not raised and ordinary Mart behavior is unchanged. With a native ¥999,999 ceiling, a full wallet is required and fully consumed. Runtime validation is still required for the new purchase path.

Compatibility is audited through Gen1Recomp 0.1.99; the manifest follows the project policy of declaring five patch versions ahead (`>=0.1.86 <0.2.5`).

## 2.4.9 RC hardening note

This RC descends directly from 2.4.8 RC. It decouples `noBadgeBoosts` from AI-tier processing and corrects the opaque R/B/Y Forgiveness confirmation panel. No save-schema change.

# Nuzlocke 2.4.5 RC

Direct development child of **2.4.4 RC**.

This pass improves generic compatibility semantics for **Summon 1.0.2** and **Quest System 1.0.5** while preserving prior runtime-confirmed behavior.

# Nuzlocke 2.4.4 RC

Development build, directly from **2.4.3 RC**.

This pass source-reviews Catch Helper 1.4.0 and Area DexNav 1.0.0 and improves generic encounter-selection/capture-mechanics ownership.

Wide Menus remains a protected runtime PASS and is untouched.

# Nuzlocke 2.4.3 RC

Development build, directly from **2.4.2 RC**.

This compatibility pass source-reviews Item Shortcut 1.4.0 and Reusable Machines 1.0.1 and makes MOD COMPAT ownership more precise.

**Protected runtime result:** the latest parent build was runtime-tested with Wide Menus and no longer crashes. 2.4.3 does not modify ENC TRACKER/Wide Menus presentation code.

# Nuzlocke 2.4.2 RC

Development build, directly from **2.4.1 RC**.

This pass reviews Modern Bag and EXP Share Modes and improves generic compatibility discovery, ownership semantics, MOD COMPAT reporting, and the external EXP-cap preflight API. The 2.4.1 Difficulty/NEXT CAP fix is preserved.

# Nuzlocke 2.4.1 RC

**Development build. Direct child of published 2.4.0. Do not promote until runtime-tested.**

This targeted stabilization fixes the remaining built-in Game Difficulty / level-cap projection bug. The cap path now reads the same direct or wrapped trainer party and runs the same composed `trainer.party` transaction used for battle creation.

# Nuzlocke 2.4.0

A configurable Nuzlocke/challenge-rules mod for Pokémon Gen1Recomp supporting **Red, Blue, Yellow**, with **Gold beta support**.

**2.4.0 is the direct published promotion of 2.3.35 RC and the first public release after 2.3.12.** No additional runtime behavior was added during the promotion.

## Release highlights

- Boot-safe lifecycle retained from 2.3.12.
- Stabilized ENC TRACKER and MOD COMPAT presentation.
- Paged Pokémon NUZ INFO with Catch / Stat / Move pages.
- Randomizer parent/child controls, fixed selectors, seed handling, and OPEN/BLIND information policy.
- Improved live Difficulty/provider handling and NUZ STATUS cap projection.
- Dungeon/Gym lock hardening and corrected Gym Team Size pre-battle enforcement.
- Expanded provider-safe compatibility for custom Balls, trainer captures, learnsets, storage transactions, encounter registries, translations, and presentation mods.
- Gold beta provenance/presentation/Physical-Special-Split hardening.
- Forgiveness Token shop/reward fixes and additional runtime-confirmed rule enforcement.

See **RELEASE_NOTES.md** for the complete 2.3.12 -> 2.4.0 release summary and **CHANGELOG.md** for detailed development history.

## Compatibility

- Gen1Recomp engine: `>=0.1.86 <0.1.99`
- Mod API: `2`
- Nuzlocke Compatibility API: `27`
- Save schema: `4`
- Games: Red / Blue / Yellow / Gold (Gold beta)

## Release confidence

The 2.4.0 line includes runtime-confirmed Yellow results for core boot/setup continuity, Gym Lock-In, Randomizer dependent controls, Difficulty warning cleanup, MOD COMPAT/ENC TRACKER sizing, NUZ INFO paging, F. TOKEN presentation, Route Forgiveness Token retry behavior, and No Rare Candy enforcement.

Gold remains beta and broader multi-game compatibility testing continues.

---

# Nuzlocke 2.3.35 RC

**2.3.35 RC is the direct child of 2.3.34 RC.**

This is a MOVE INFO-only presentation stabilization build. The remaining overlap is removed by giving each move a simple single-column three-line card.

# Nuzlocke 2.3.34 RC

**2.3.34 RC is the direct child of 2.3.33 RC.**

This presentation stabilization pass follows Yellow 2.3.32 runtime testing: MOD COMPAT and ENC TRACKER sizing are now recorded as working, F. TOKEN is confirmed, and NUZ INFO paging is confirmed. Remaining work focuses on readable detail text and MOVE INFO layout.

# Nuzlocke 2.3.33 RC

**2.3.33 RC is the direct child of 2.3.32 RC.**

This runtime-feedback build records two Yellow PASS results, cleans up rule/menu placement, and fixes stale NUZ STATUS level-cap presentation when switching Nuzlocke-owned Game Difficulty profiles.

# Nuzlocke 2.3.32 RC

**2.3.32 RC is the direct child of 2.3.31 RC.**

This targeted gameplay stabilization fixes the Yellow Brock Gym Team Size failure found in runtime testing. Normal R/B/Y Gym Leader interactions now enforce the party-size cap at Gen1Recomp's real pre-trainer-battle seam and refuse an oversized team with tiered world-building dialogue.

Gym Lock-In was runtime-confirmed working and is unchanged.

# Nuzlocke 2.3.31 RC

**2.3.31 RC is the direct child of runtime-tested 2.3.30 RC.**

This stabilization build responds directly to runtime UI feedback: native-size tracker/compat screens, real paged Pokémon NUZ INFO, a working OPEN/BLIND RNG Info selector, shorter Randomizer labels, and the actual mart-side F. TOKEN name.

# Nuzlocke 2.3.30 RC

**2.3.30 RC is the direct child of 2.3.29 RC.**

This stabilization pass removes phantom Difficulty multi-mod warnings for known-but-uninstalled historical providers and extends the parent/child Randomizer UI pattern to Starter Style, Encounter Balance, and Randomizer Info.

# Nuzlocke 2.3.29 RC

**2.3.29 RC is the direct child of 2.3.28 RC.**

This stabilization/UI pass makes Randomizer child selectors behave like actual dependent controls. Species Pool disappears and becomes inactive when Random Encounters is OFF; Learnset Gen does the same when Random Learnsets is OFF. Their previous selections are remembered if the parent is turned back on.

NUZ STATUS also receives the requested bold `ACTIVE RULES:` heading.

# Nuzlocke 2.3.28 RC

**2.3.28 RC is the direct child of 2.3.27 RC.**

This stabilization/UI pass redesigns R/B/Y MOD COMPAT for readability without replacing its proven ListMenu lifecycle. The page now clearly labels RULE / SYSTEM versus OWNER and explains the highlighted ownership relationship at the bottom of the screen.

# Nuzlocke 2.3.27 RC

**2.3.27 RC is the direct child of 2.3.26 RC.**

This stabilization build fixes the recurring R/B/Y **DETAIL SAFE MODE** fallback in NUZ INFO and hardens Catch Info row fitting. No new gameplay features are included.

# Nuzlocke 2.3.26 RC

**2.3.26 RC is the direct child of 2.3.25 RC.**

This stabilization-only build removes ENC TRACKER's Wide Menus layout delegation. R/B/Y now uses one Nuzlocke-owned 304x144 / 38-column tracker presentation regardless of installed UI companions. It also shortens the constrained mart-row token name to `F. TOKEN`.

# Nuzlocke 2.3.25 RC

**2.3.25 RC is the direct child of 2.3.24 RC.**

This compatibility pass generalizes lessons from Advanced Box System 1.1.0 and Pokédex Plus 1.3.4: storage legality follows the final party transaction rather than a menu verb, and encounter-generating data is separated from optional information/reveal policy.

A new Randomizer Info option supports OPEN INFO and BLIND INFO without changing randomized gameplay.

# Nuzlocke 2.3.24 RC

**2.3.24 RC is the direct child of 2.3.23 RC.**

This is a documentation/provenance-only compatibility pass for the two unresolved historical entries, IronMON Ultimate and Enemy HP. Their old compatibility evidence is preserved, but no current upstream/version is claimed without verifiable source identity.

Runtime code is unchanged except build metadata.

# Nuzlocke 2.3.23 RC

**2.3.23 RC is the direct child of 2.3.22 RC.**

This is a documentation/compatibility-ledger cleanup build. It makes `docs/COMPATIBILITY.md` a single current source of truth for the recent mod audits and clearly separates source-reviewed compatibility from runtime-PASS claims.

No gameplay or UI behavior changed.

# Nuzlocke 2.3.22 RC

**2.3.22 RC is the direct child of 2.3.21 RC.**

This pass generalizes UI-overhaul compatibility after reviewing Gen 3 Inspired UI Overhaul 2.0.0. Nuzlocke now explicitly tells presentation mods which custom screens it owns, what those screens represent, and which layout/fallback contract they expect, without handing over rule or tracker state.

# Nuzlocke 2.3.21 RC

**2.3.21 RC is the direct child of 2.3.20 RC.**

This pass applies a generalized transition-state lesson from Weather FX 2.6.0: transient world state must be validated from the current map rather than trusted indefinitely after a previous transition. Dungeon Lock-In state now reconciles on actual map entry, including map changes performed by compatible teleport/map providers outside the normal warp resolver.

# Nuzlocke 2.3.20 RC

**2.3.20 RC is the direct child of 2.3.19 RC.**

This compatibility-learning pass applies two general lessons from Translation Generator 0.7.0 and Shiny Pokemon 1.0.1: expose mod-owned translation sources semantically, and prepare expensive presentation data once instead of rebuilding it from every draw/model path.

# Nuzlocke 2.3.19 RC

**2.3.19 RC is the direct child of 2.3.18 RC** and applies generalized compatibility improvements learned from current Pokemon Snag 0.15.9 and Too Many Balls 0.6.1 source.

The changes are semantic rather than mod-specific: trainer captures become a real acquisition kind, trainer-battle catches get accurate provenance, and the public Item API recognizes custom Balls from live item metadata.

# Nuzlocke 2.3.18 RC

**2.3.18 RC is the direct child of 2.3.17 RC.** This is an intentionally smaller-risk presentation correctness pass because runtime testing is deferred.

It fixes one Difficulty display fallback and three UTF-8/text-fitting hazards. Gameplay logic is unchanged.

# Nuzlocke 2.3.17 RC

**2.3.17 RC is the direct child of 2.3.16 RC** and is the requested smaller follow-up bug-fix pass.

It is intentionally low risk: UTF-8-safe Gold status clipping, no phantom UNKNOWN egg-area visit, and one dead learnset-condition cleanup.

# Nuzlocke 2.3.16 RC

**2.3.16 RC is the direct child of 2.3.15 RC.** This is the requested medium-risk stabilization pass.

It fixes provider-facing capture/starter provenance behavior and isolates Gold Physical/Special Split's temporary damage-category state without changing the feature set.

# Nuzlocke 2.3.15 RC

**2.3.15 RC is the direct child of 2.3.14 RC** and is a stabilization pass with no new gameplay feature.

Key repairs: manual RNG Seed storage/reapply, Gold Egg Encounter and Bug Contest multi-choice controls, provider-safe learnset delegation, and capture-policy enforcement for area-less compatible battles. The 2.3.14 Running Shoes, Starter Style/Encounter Balance, and ENC TRACKER/Wide Menus work is preserved.

Runtime regression testing is required before promotion.

# Nuzlocke 2.3.13 RC

**2.3.13 RC is the direct child of the published 2.3.12 release.** This is a narrow ENC TRACKER stability candidate; the 2.3.12 boot-safe initialization, gameplay rules, save schema, Compatibility API, and Gold presentation are otherwise unchanged.

### ENC TRACKER crash investigation

Follow-up runtime testing corrected the original 2.3.12 diagnosis:

- ENC TRACKER **still crashes with Modern UI disabled**, so Modern UI is not established as the cause.
- ENC TRACKER **does not crash when Wide Menus is installed**.
- Wide Menus automatically gives this opaque Gen 1 mod screen a 304x144 UI surface and expands its full-screen box to that width.

2.3.13 RC makes the R/B/Y ENC TRACKER own that same 304x144 surface directly. Gold retains its native 20x18 / 160x144 tracker.

**Runtime validation required:** R/B/Y ENC TRACKER with neither UI mod installed, with Wide Menus, and with Modern UI. The earlier claim that Modern UI itself caused the crash is retracted.


# Nuzlocke 2.3.12

**2.3.12 is the final 2.3 release and the direct child of 2.3.11 RC.** It promotes the same boot-safe full-feature implementation that was runtime-validated on Yellow/Gen1Recomp 0.1.98 and Gold NEW GAME. No gameplay feature, rule, save schema, Compatibility API, or startup behavior is intentionally changed from 2.3.11.

### Runtime-confirmed release path

- Yellow title boot: **PASS**
- Yellow fresh NEW GAME → normal Nuzlocke SETUP: **PASS**
- Yellow SETUP → NEW GAME: **PASS**
- Yellow existing SAVE GAME load: **PASS**
- Existing Yellow save does not expose fresh-game SETUP: **PASS**
- Gold NEW GAME boot: **PASS**

### Boot-safe initialization retained

- `src.core.Strings` is the only eager engine import required by the main initializer.
- `src.pokemon.Stats` and `src.pokemon.Growth` are resolved lazily.
- the public `ui.title_menu.items` SETUP seam remains authoritative;
- the legacy `title_setup_compat.lua` fallback stays packaged but dormant on current engines;
- the first heavy runtime phase waits for `game.ready`;
- optional Modern UI and Pokégear integrations wait for lifecycle retry points instead of eager first-pass installation;
- Default Names installs at NEW GAME/lifecycle time rather than by pre-title OakSpeech/Gold World imports;
- Gold title dispatch is not probed on R/B/Y startup.

### Known issue

- **Corrected after release:** ENC TRACKER can crash even with Modern UI disabled. Wide Menus was observed to mask the crash; Modern UI is not established as the cause.

### Release surface

The complete restored 2.3 feature surface remains active: rules, setup/profile handling, encounter/death tracking, status and info screens, world-building, randomizer/QoL systems, compatibility/provider APIs, R/B/Y enforcement, Gold beta adapters, Skip Opening Intro, Quick Nuzlocke Start, Default Names, Skip Catch Demo, and the later Gold trainer-battle Ball scoping repair.

Gold remains beta and not every individual rule combination has new 2.3.12 runtime coverage; protected historical PASS behavior remains protected.


# Nuzlocke 2.3.11 RC — full feature restoration / Yellow boot test

> **2.3.11 RC compatibility note:** this build is the direct child of 2.3.10 and keeps the restored full RC feature set while deferring the first heavy runtime phase and optional presentation/provider first-pass installs until Gen1Recomp lifecycle events. Yellow 0.1.98 validation is required.


**2.3.11 is the direct child of 2.3.10 RC.** The diagnostic-only reduction is over: this candidate restores the full feature surface that existed in the original 2.3.0 RC while retaining the boot-safe boundaries learned from 2.3.7–2.3.9.

The original 2.3.0 package was used only as a comparison/reference source. Missing behavior was ported forward through the sequential 2.3.10 → 2.3.11 lineage rather than replacing the current tree with an old branch.

### Boot hardening carried into the restored build

- `src.core.Strings` remains the only eager engine module imported by the main initializer.
- `src.pokemon.Stats` and `src.pokemon.Growth` are resolved lazily when a rule actually needs them.
- the public `ui.title_menu.items` setup seam remains authoritative;
- the legacy engine-internal `title_setup_compat.lua` fallback remains packaged but dormant at startup;
- engine-internal gameplay adapters that are unnecessary before title now install from their existing lifecycle retry points;
- Default Names installs when NEW GAME is selected instead of eagerly importing OakSpeech/Gold World modules;
- Gold-specific title dispatch is not probed on R/B/Y startup.

### Restored surface

The full 2.3.0 RC rules, setup, tracking, status screens, randomizer/QoL systems, compatibility APIs, Skip Opening Intro, Quick Nuzlocke Start, Default Names, Skip Catch Demo, and Gold beta integrations are active again. The later Gold trainer-battle Ball scoping fix is retained.

**Immediate validation target:** Yellow + Gen1Recomp 0.1.98 with only Nuzlocke enabled. Confirm title boot, correct fresh-save-only SETUP visibility, full setup menu rendering, NEW GAME entry, and early gameplay before expanding the regression pass.

# Nuzlocke 2.3.9 RC — DIAGNOSTIC ONLY

**2.3.9 is not a playable Nuzlocke build.**

Yellow + Gen1Recomp 0.1.98 successfully reached the title screen with 2.3.8, proving the normal returned initializer itself is boot-safe. The missing Nuzlocke Setup row in 2.3.8 was intentional.

2.3.9 is the direct child of **2.3.8 RC**. It restores only the minimum public title/setup UI path: `src.core.Strings`, a minimal custom setup screen, and the public `ui.title_menu.items` hook. No real rules or setup-profile persistence are active.

Immediate test: launch a fresh Yellow title on Gen1Recomp 0.1.98 with only Nuzlocke 2.3.9 enabled. Confirm **SETUP** appears before **NEW GAME**, opens a diagnostic Nuzlocke Setup screen, accepts basic input, and returns with B.

# Nuzlocke 2.3.8 RC — DIAGNOSTIC ONLY

**2.3.8 is not a playable Nuzlocke build.**

Yellow + Gen1Recomp 0.1.98 successfully reached the title screen with 2.3.7 as the only enabled mod. That runtime PASS clears the package tree, manifest, and inert top-level loader path as the cause of the earlier pre-title crashes.

2.3.8 is the direct child of **2.3.7 RC** and restores exactly one execution boundary from 2.3.6: the normal returned `function(mod) ... end` initializer. Inside it, only static export metadata is assigned. No engine modules are required and no gameplay/UI/event/save/hook integration is installed.

Immediate test: launch Yellow on Gen1Recomp 0.1.98 with only Nuzlocke 2.3.8 enabled and report whether the title screen appears.

# Nuzlocke 2.3.7 RC — DIAGNOSTIC ONLY

**2.3.7 is not a playable Nuzlocke build.**

It exists solely to isolate the Yellow pre-title crash on Gen1Recomp 0.1.98. The package still contains the normal 15 files, but the entry file does not load or execute gameplay code. Only inert export metadata is registered.

Immediate test: launch Yellow with only Nuzlocke 2.3.7 enabled and report whether the title screen appears.

# Release candidate — 2.3.6

2.3.6 is the direct child of **2.3.5 RC**. It restores the remaining pre-2.3 installer behavior after direct comparison while keeping the two deferred startup shortcuts absent. The immediate validation target is Yellow boot-to-title on Gen1Recomp 0.1.98 with every other mod disabled.

# Release candidate — 2.3.5

2.3.5 is the direct child of **2.3.4 RC** and is a Yellow/Gen1Recomp 0.1.98 boot bisect. The experimental startup shortcuts remain removed. This build temporarily disables the executable 0.1.98-specific integrations added during 2.3.x while still allowing 0.1.98 in the manifest, so we can distinguish a new compatibility regression from an older Nuzlocke boot path that was never previously exercised on 0.1.98.

# Release candidate — 2.3.4

2.3.4 is the direct child of **2.3.3 RC**. It removes the experimental **Skip Opening Intro** and **Quick Nuzlocke Start** implementations from the active code path to isolate the Yellow pre-title crash on Gen1Recomp 0.1.98.

Those two features are deferred for a later build and redesign. **Default Names** and **Skip Catch Demo** are not part of this rollback and remain available.

No older branch was restored; only the specific 2.2.20/2.2.21 shortcut changes were reversed after comparison. All unrelated 2.3.x compatibility fixes remain.

# Release candidate — 2.3.3

2.3.3 is the direct child of **2.3.2 RC**. It is a Yellow pre-title boot-safety isolation build for Gen1Recomp 0.1.98.

## Yellow boot-safety isolation

- 2.3.0, 2.3.1, and 2.3.2 are recorded as Yellow **pre-title runtime FAIL** with other mods disabled.
- The public `ui.title_menu.items` hook remains the only title Setup integration on current engines. The old 0.1.86 `TitleState.openMenu` fallback is no longer invoked at boot.
- Non-title engine-internal monkey patches (item policy, day care, stat rules, field commands, Center, Game Corner, shops, Gold difficulty mechanics) are deferred until `map.entered`/`save.loaded`/`battle.started` as appropriate.
- No gameplay rule is intentionally removed; this changes installation timing only.

# Release candidate — 2.3.2

2.3.2 is the direct child of **2.3.1 RC**. It fixes Gold battle-item policy scoping on Gen1Recomp 0.1.98 and corrects contextual-field-action compatibility metadata. Save schema remains 4 and the package tree is unchanged.

## 2.3.2 compatibility hotfix

## Wide Menus optional dependency

`wide-menus` remains an intentional **optional dependency**, but the current integration is passive coexistence rather than a `mod.find()`/provider call. Nuzlocke marks every `NuzlockeConfigScreen` with `uiModLayout = "classic"` and `keepClassicUi = true`; Wide Menus reads those public instance markers and leaves Setup/NUZ RULES on the validated native-width path. This is the safety adapter introduced after the earlier claimed-wide Yellow crash. The old 304px Nuzlocke-owned wide layout remains disabled.


Gold's general battle-item policy pass now handles non-Ball items only. Ball/capture rules run only when the battle is actually catchable (wild or recognized static), so trainer-battle Ball attempts retain Gen1Recomp's native behavior rather than receiving a Nuzlocke `No Catching` denial.

`mod.world:useFieldAction` is not directly wrapped by Nuzlocke. No Fishing is enforced transitively because Gen1Recomp 0.1.98 delegates fishing through the guarded native R/B/Y `Overworld.useFishingRod` and Gold `World.useFieldItem` seams.

# Release candidate — 2.3.1

2.3.1 is the direct child of **2.2.21 RC** and the compatibility release for **Gen1Recomp 0.1.98**. The manifest now accepts `>=0.1.86 <0.1.99`; 0.1.98 is source-audited while runtime confirmation remains required. Save schema remains 4 and the package tree is unchanged.

## Gen1Recomp 0.1.98 integration

- **Public battle snapshots:** Nuzlocke's additive `battle_classifier.snapshot()` now forwards the engine's detached `mod.battle:snapshot()` view when available. This is read-only interop for companion/status mods; Nuzlocke rule enforcement continues to use its established battle hooks/events.
- **Contextual field actions:** 0.1.98 exposes `mod.world:availableFieldActions()` / `useFieldAction()` across R/B/Y and Gold. Nuzlocke now guards the underlying fishing execution seam too, so **No Fishing** cannot be bypassed by a companion UI calling the public field-action API instead of opening the Bag/Pack.
- **Gold item coverage:** **No Field Heal** now classifies `BERRY_JUICE`, `RAGECANDYBAR`, and `SACRED_ASH` as native Gen II healing items. The normal Pack gate retains tiered Nuzlocke feedback; the deeper Gold world guard prevents registered/public field-action bypasses.
- **Gold battle items:** the 0.1.98 Gold battle Pack routes balls, stat/X items, healing/status/revive items, and PP recovery through one native `BattleState:useItem` path. Any authoritative Nuzlocke item-policy denial now stops there instead of only special-casing No Catching/No PP Items, covering **No Healing Items** and **No X Items** consistently.
- **Gold starter nickname path:** 0.1.98 supplies the native Gold starter nickname transaction. Nuzlocke keeps its force-YES/nonblank nickname gate and retains the separate deferred gift-nickname path for scripted gifts.
- **Gold encounter fixes upstream:** 0.1.98 contains Gold encounter/fishing/time-routing corrections. Nuzlocke keeps Time Split restricted to grass/time-of-day tables; water/fishing remain unsplit.

## Compatibility boundary

2.3.1 deliberately stops at `<0.1.99`. Post-0.1.98 `dev` changes are not treated as release contracts. No new permission is required: Mod API remains 2 and Nuzlocke still uses only `engine_internals`.

# Release candidate — 2.2.21

2.2.21 is the direct child of **2.2.20 RC**. It adds a NEW GAME-only **Quick Nuzlocke Start** that advances the mandatory pre-capture opening to the first safe, capture-enabled hometown checkpoint while preserving Nuzlocke rules, starter provenance, and optional early content. Save schema remains 4 and the package tree is unchanged.

## Quick Nuzlocke Start

- **Separate from Skip Opening Intro:** Skip Opening Intro removes only Oak's presentation. Quick Nuzlocke Start additionally reconciles the mandatory early story state needed for a legal starter, Pokédex access, and Poké Balls. It defaults OFF and is setup-only.
- **R/B/Y:** begins outside the player's Pallet house at the Route 1 side of town with a level-5 starter, Pokédex, and at least 5 Poké Balls in the Bag. A larger configured R/B/Y **Start Balls** value is preserved. Oak's Parcel/lab handoff is complete, the Viridian old-man gate is in its post-Pokédex state, and the optional first Route 22 rival remains available. Quick Start does **not** mark that optional rival as beaten.
- **Yellow:** uses the normal Pikachu starter anchor (or Nuzlocke's selected Random Starter), activates Pikachu-follower state when Pikachu is actually the starter, and leaves the optional Route 22 battle available. Because the skipped lab Rival battle has no win/loss result, Yellow keeps the pre-battle baseline Rival evolution state rather than inventing an outcome.
- **Gold:** keeps the required InitClock hour/minute step, resolves the skipped mandatory Mom/Elm/Mr. Pokémon/Cherrygrove Rival/police/Mystery Egg return milestones, then begins at New Bark's Route 29 exit with a level-5 starter, Pokégear/Phone, Pokédex, the mandatory Potion, and 5 Poké Balls. The skipped Mom weekday prompt is anchored to the host's current weekday. The native post-Mr.-Pokémon whiteout destination remains Cherrygrove until a later Pokémon Center updates it.
- **Optional Gold content remains optional:** Guide Gent/Map Card, Mom's money-saving conversation, Route 29 encounters, and the Route 29 catch tutorial are not consumed. The tutorial remains armed unless **Skip Catch Demo** is also selected.
- **Nickname Rule is preserved:** Quick Start does not silently bypass a required starter nickname. If Nickname Rule is active, the only retained opening interaction is the starter nickname screen; the shortcut finishes after a valid nickname is entered.
- **Built-in Random Starter is preserved:** the story uses a canonical starter anchor while the actual level-5 starter is selected through the existing seeded Random Starter system, then registered in the normal Pallet/New Bark starter slot. External starter-randomizer composition remains runtime TEST REQUIRED because Quick Start bypasses the native gift transaction; an external provider that owns **Quick Start itself** takes full ownership and suppresses Nuzlocke's local shortcut.
- **Challenge rules still win:** Quick Start supplies the normal capture-ready resources but does not disable No Catching, Type Locks, species/BST restrictions, or any other selected challenge rule.

# Release candidate — 2.2.20

2.2.20 is the direct child of **2.2.19 RC**. It adds a fresh-game **Skip Opening Intro** QoL path using Gen1Recomp's named Oak-speech hook rather than bypassing New Game itself. Save schema remains 4 and the package tree is unchanged.

## Skip Opening Intro

- **R/B/Y:** skips Oak's welcome/demo/world speech, visible naming presentation, legend text, and shrink. The existing canonical-name adapter resolves the hidden player/Rival name steps, then Gen1Recomp's ordinary intro-finished callback begins the normal Pallet bedroom start.
- **Gold:** skips the visible Oak/Marill/world/name/legend presentation but deliberately preserves Gold's `init_clock` step before invisibly resolving the player name. The normal Johto fresh-game continuation follows; the later ???/SILVER Rival naming story is untouched.
- **No story-state fabrication:** the option does not set badges, Oak/Elm Lab flags, starter flags, parcel/Pokedex flags, tutorial flags, or map progression. It only removes the opening presentation.
- **Provider-aware:** an external opening-intro-skip provider can own the feature; Nuzlocke then yields its local shortcut.

## Seeded structured randomizer

- **Shareable seed:** `Random Seed` is an 8-digit decimal seed. `00000000` means AUTO; enabling a Nuzlocke-owned randomizer generates and stores a seed. The active seed is shown in NUZ RULES and as `RNG ######## v1` on run-status rule lists while a built-in randomizer is active.
- **Independent deterministic streams:** STARTER, ENCOUNTERS, and LEARNSETS hash the same seed through separate semantic streams. Turning Random Learnsets on later cannot perturb encounter-table choices, and inspecting starter balls in a different order cannot change seeded starter results.
- **Starter Style:** ANY / 3-STAGE / BASE / SIM BST. 3-STAGE uses the live merged evolution graph and requires a base form with an evolution followed by another evolution. BASE accepts species with no pre-evolution, including single-stage species. SIM BST targets roughly the original starter's live BST. If a structured style leaves no legal candidate, the mandatory starter falls back to the broader legal pool rather than blocking progression.
- **Encounter Balance:** CHAOS / SIM BST / EVO / BALANCED. SIM BST targets roughly ±15% of the original slot's live BST with a minimum tolerance of 25. EVO preserves broad evolution position (`single/base/middle/final`). BALANCED requires both when possible, then relaxes stage-only, BST-only, and finally full-pool only when necessary. Native encounter levels, rates, time blocks, fishing/tree methods, and map structure stay unchanged.
- **Legacy preservation:** already-persisted pre-seed randomizer choices from upgraded saves are preserved when valid instead of silently rerolling the existing run. Fresh 2.2.19+ generated choices are seed-reproducible.
- **Provider ownership is unchanged:** an external starter/encounter/learnset randomizer still owns that mechanic when delegated; Nuzlocke does not repaint provider-owned registries.

### Seed editing

Select **RNG Seed**, press A (or Left/Right) to enter digit editing, use Left/Right to choose one of eight digits, Up/Down to change it, and A to confirm. Setting all digits to `00000000` regenerates AUTO when a Nuzlocke randomizer is active.

## Inherited 2.2.18 rule-interaction hardening

- **Failed Encounters now reuses authoritative capture legality before arming a failure transaction.** Encounters already forbidden by No Catching, Type Lock, glitch restrictions, Static Encounter bans, Overworld/Town policy, Legendary/Mythical/Pseudo bans, Maximum BST, Solo Only, Dupes, or an already-consumed area cannot burn the area as a failed encounter. Shiny Clause only keeps its intended exceptions for area/Dupes policy; it no longer changes the outcome of an otherwise absolute ban.
- **Gold Time Split now distinguishes grass from water and fishing.** Successful fishing rolls receive explicit fishing provenance; ordinary surf encounters receive water provenance; ordinary land encounters receive grass provenance. Only grass (plus legacy records already stored as `wild`) participates in morning/day/night Time Split projection. Historical records that lack enough provenance are preserved rather than guessed.
- **Random Starter now respects run-wide species legality** for Type Locks, glitch restrictions, Legendary/Mythical/Pseudo bans, and Maximum BST. No Catching intentionally does not ban the required received starter.
- **Delegated non-core NEW GAME QoL now truly yields ownership.** Automatic Default Names, Skip Catch Tutorial, and fresh-save PC kits cannot execute from stale local state while another provider owns the capability.
- Public translation/randomizer/starter-randomizer/battle-classifier build stamps are synchronized to 2.2.18, and Forgiveness Token help text now correctly says Gym Leaders award them.

### Audit coverage

The source/model pass covered **89 unique rule/control keys**, verified all **35 preset-managed keys** across all four presets, and exercised **348 source-derived interaction combinations**. This is static/model validation only; it is not runtime PASS.

### Remaining policy/runtime gaps

Egg hatches can currently be tracked by the Gold Egg Encounter rule without a destructive answer for an off-type/otherwise banned hatchling. 2.2.18 deliberately does not invent deletion or rollback semantics; that interaction remains a documented policy decision. Gold encounter records created before explicit method provenance may remain legacy `wild` records because water/fishing cannot be reconstructed safely after the fact. All changed paths remain runtime TEST REQUIRED.

# Release candidate — 2.2.17

2.2.17 is the direct child of **2.2.16 RC**. It adds explicit external-trainer-mod stacking warnings to **Game Difficulty** without changing save schema 4 or automatically changing the player's selected Difficulty.

## External Difficulty stacking warning

When a loaded external trainer/difficulty provider such as **Stronger Trainers** is active, the Game Difficulty description now warns immediately if the current selection does not fully represent exclusive ownership:

- **VANILLA + active trainer mod:** warns that VANILLA only disables Nuzlocke's built-in Difficulty transforms; it does not disable the external mod.
- **Built-in profile + active trainer mod:** shows **STACK WARNING** because the provider's composed trainer party can remain underneath the selected built-in Nuzlocke transforms.
- **One external provider selected while another is active:** shows **MULTI-MOD WARNING** because Nuzlocke can choose its authoritative provider but cannot disable another mod's own hooks.
- Selecting the active provider's own **[MOD]** entry removes that provider from the warning. No automatic takeover occurs.

Known historical trainer providers are now queried directly through `mod.find` as well as mod-status/discovery surfaces, improving detection on runtimes where the status tree does not enumerate every loaded companion.

# Release candidate — 2.2.16

2.2.16 is the direct child of **2.2.15 RC**. It adds the optional **Gym Team Size** challenge rule and hardens compatibility with the translation companions previously reviewed. Save schema remains 4; no package files are added or removed.

## Gym Team Size

Under **BATTLE MECHANICS**, **Gym Team Size** limits the player's active usable roster at the actual next Gym Leader battle to that Leader's **live composed party size**. Fewer Pokémon are allowed; the rule never forces catches, revives, or automatic boxing. If the player carries too many eligible Pokémon, the Leader battle is refused before it starts and the player can box extras and challenge again. Ordinary Gym Trainers are unaffected.

The limit comes from the same merged/composed trainer-party path used for compatibility-aware boss information, so trainer-party providers can change the Leader's roster size without a hardcoded Nuzlocke table becoming stale. Gold includes the Johto leaders and the Kanto Gym leaders after Lance; Red at Mt. Silver is not treated as a Gym Leader. The option defaults **OFF**. The HARDCORE and IRONMON Nuzlocke presets enable it; standard NUZLOCKE and SOLO do not.

## Translation compatibility

The reviewed translation companions are now known to Nuzlocke diagnostics: **(PT-BR) Versão Brasileira 0.1.4** (`gen1_pt-br`) and **Suomi 0.1.0** (`finnish`). Translation mods remain localization owners; Nuzlocke does not rewrite their catalogs, native Trainer Card layout, fonts, or language-specific UI. Shop blocking remains semantic/`Strings()`-aware rather than hardcoding translated BUY/SELL words. MOD COMPAT can report an active translation companion and PT-BR's optional native Trainer Card / inventory-list layout overrides. Full translated labels are retained when available before compact English fallbacks are considered.

PT-BR 0.1.4 directly wraps native `TrainerCard.draw`, `BattleState.drawTextArea`, and `ListMenu.draw`, so combined runtime smoke testing is still required for native-list presentation. Finnish remains unchanged at 0.1.0 since the earlier review.

# Release candidate — 2.2.15


2.2.15 is a save-upgrade architecture hardening build directly from **2.2.14 RC**. It does not bump save schema 4 or change Nuzlocke gameplay semantics. Numbered schema migrations, semantic one-off corrections, tracker/Pokémon-identity reconstruction, and encounter reprojection now execute through one deterministic coordinator in that order. Every schema destination version has an explicit migrator entry (including marker-only steps), so a future schema bump without a migration fails visibly instead of being skipped. Route Split migration no longer hides inside encounter reprojection; legacy Level Cap and Rule Lock reconciliation are also named semantic steps, and migration diagnostics identify the exact phase/step that failed.


## Gold-native encounter and radio features — 2.2.13

Gold now adds six optional, independently changeable features:

- **Time Split** — morning/day/night encounter projections with immutable time provenance; changing the toggle reprojects tracked history instead of granting duplicate historical catches.
- **Roamer Clause** — Raikou/Entei use persistent species-specific slots. Failed roamer meetings do not burn the current route or the roamer slot; a successful catch closes the roamer slot.
- **Egg Encounter** — OFF / RECEIVED / HATCHED / GIFT policies use Gold egg creation/hatch provenance and mark a hatchling invalid when its selected encounter slot was already consumed.
- **Bug Contest** — NORMAL / EXEMPT / SLOT. The judged final contest Pokemon is authoritative; SLOT uses a dedicated National Park Contest encounter slot.
- **Headbutt Split** — Headbutt encounters can use a per-map slot separate from ordinary encounters.
- **Radio Nuzlocke** — optional Pokegear Radio status/world-building lines gated by World Building T1-T3. Native radio station ownership is preserved.

All six default to OFF/NORMAL and are Gold-only. R/B/Y behavior is unchanged.

2.2.12 is a Game Difficulty completion build directly from **2.2.11 RC**. Built-in transformations operate on a copied party, fixing the 2.2.11 in-place level-scaling path. Built-in profiles now transform the live composed trainer party across the dimensions the current engine can cleanly own: ordinary/boss levels, deterministic type-compatible roster strengthening, live-data movesets, native AI, profile Stat EXP/DVs, and Gold held items. SHIN-derived profiles and POLISHED* can also suppress player badge battle boosts without deleting badges. Rival species remain fixed, and selected external Difficulty providers are never run through Nuzlocke's built-in transformations. Historical names marked `*` are inspired profiles rather than exact ROM-hack trainer-table reproductions.

Physical/Special Split remains an independent **BATTLE MECHANICS** option. Species Pool / cross-generation randomizer support from 2.2.10 is inherited unchanged.

# Release candidate — 2.2.11

2.2.11 is the direct child of **2.2.10 RC** that audited built-in Game Difficulty, made profile Trainer Stat EXP/perfect-DV settings real, and removed inert AI labels pending the complete native-AI work delivered in 2.2.12.

# Release candidate — 2.2.10

2.2.10 is a feature build directly from 2.2.9 RC. It adds a provider-aware cross-generation Species Pool selector for Random Starter/Random Encounters and an optional modern per-move Physical/Special Split for R/B/Y and Gold. AUTO keeps 2.2.9 randomizer behavior; BOTH targets complete Generation 1 + 2 records available in the active merged registry. Gold natively supplies all 251 species. R/B/Y can use Gen 2 species when a compatible content provider supplies complete live records/assets; Nuzlocke does not fabricate unavailable ROM-derived species data.

Gold Random Encounters now uses the live `gen2Encounters` registry. The Physical/Special Split is OFF by default, leaves the shared move/type registries untouched, and composes through Gen1Recomp's `battle.damage` hook. Gold additionally realigns Reflect/Light Screen and Counter/Mirror Coat damage identity.

# Release candidate — 2.2.9

2.2.9 is a hardening build directly from 2.2.8. It deliberately stays below project-defined Lua compiler budgets rather than waiting for Lua 5.1's real ceilings, guards the post-wipe empty-party menu crash path, hardens Dungeon Lock-In transitions, and corrects Gold vitamin data.

# Release candidate — 2.2.8

## 2.2.8 RC — vanilla dialogue ownership + live Difficulty cap repair

Direct child of 2.2.7 RC.

Two runtime issues are fixed:

- **T3 vanilla dialogue:** the global T3 ScriptRunner normalizer was rewriting Gen1's native `\v` continuation markers through Nuzlocke's paginator. This could make ordinary vanilla interactions replay/overlap text, reproduced in Yellow's bedroom SNES interaction. 2.2.8 removes only that over-broad vanilla-text rewrite. Nuzlocke-authored T3/world-building text still uses the shared formatter and ownership path.
- **NUZ STATUS Next Cap:** built-in Game Difficulty profiles modify trainer levels through the `trainer.party` composition hook, but the live cap preview previously invoked that hook only for a specifically detected external trainer mod. 2.2.8 also previews the hook for an active built-in non-Vanilla Difficulty profile and clears stale observed boss levels when Difficulty changes mid-game.

The 2.2.7 two-phase startup repair is retained.

# Release candidate — 2.2.7

## 2.2.7 RC — confirmed Lua 5.1 upvalue-limit startup repair

Direct child of 2.2.6 RC. Runtime exposed the complete loader error: the former `_lateRuntimeInit` function had **more than 60 upvalues**, exceeding Lua 5.1's per-function upvalue limit and preventing the entire mod from compiling/loading.

2.2.7 keeps the same initialization order and behavior but splits that oversized late-runtime function into two sequential closures: common/RBY runtime installation first, then Gold/compatibility installation. Each phase captures only the outer state it actually uses. The temporary internal export slot is reused and cleared between phases, so no new long-lived main-scope local is introduced.

No rule, Setup option, save schema, API, engine range, permission, or package file-tree change is intended.

# Release candidate — 2.2.6

## 2.2.6 RC — Lua local-limit startup repair

Direct child of 2.2.5 RC. Runtime exposed the full Gen1Recomp loader error: `main.lua` was being rejected by the Lua compiler because the large mod entry function exceeded Lua 5.1's local-variable limit. 2.2.5 removed the extra renderer table introduced by 2.2.4, but 2.2.3 had already added one additional long-lived local helper for Skip Catch Tutorial.

2.2.6 preserves the helper's behavior but moves it onto the existing internal `mod.exports.__beta26` namespace instead of consuming another local slot in the giant entry function. No Nuzlocke Setup option or rule is intentionally changed.

# Release candidate — 2.2.5

## 2.2.5 RC — startup regression repair

Direct child of 2.2.4 RC. 2.2.4's Pokémon Bois Club native-walker repair introduced one additional long-lived local in `main.lua`. This file has previously reached Lua 5.1's 200 active-local ceiling, so the extra local could prevent the mod from loading and make New Game Nuzlocke Setup disappear. 2.2.5 removes that extra file-scope local and stores the temporary chairman renderer ownership directly on the NPC object instead. Intended 2.2.4 sprite behavior is preserved with no setup or gameplay-rule redesign.

# Release candidate — 2.2.4

## 2.2.4 RC — native Pokémon Bois Club tribute walker

Direct child of 2.2.3 RC. This focused cleanup fixes the dormant Tier-3 Pokémon Bois Club chairman tribute without reviving the retired hand-painted sprite renderer. At World Building Tier 3 the chairman now swaps to a genuine engine `SpriteRenderer`, preferring the same native Gambler / Black Hair Boy sprite family used by Bryan-at-Home and falling back to another valid native map sprite when needed. The exact original chairman renderer is cached and restored when the world-building tier drops below 3. Restoration is ownership-safe: if another mod replaces the chairman after Nuzlocke, Nuzlocke does not overwrite that third-party sprite. The obsolete pixel-by-pixel `makeBryanBoiRenderer` implementation and unrelated Bryan-at-Home Fan Club flag assignment are removed. No asset or repository file is added.

# Release candidate — 2.2.3

## 2.2.3 RC — Yellow catch-demo hardening + complete native NUZ INFO

Direct child of the published 2.2.2 RC. This focused pass leaves the recently improved T3 dialogue ownership system unchanged and concentrates on two follow-ups. Yellow Skip Catch Demo is hardened against the exact current Gen1Recomp Pallet flow (`makeOldManDemo("PROF.OAK")` → `Commands.pushBattle`) while preserving Oak's normal post-demo callback and lab escort. The skip choice is now read consistently from the staged NEW GAME profile, mod save, or the legacy transient save field. R/B/Y NUZ INFO keeps the crash-safe host `ListMenu`, but now displays the complete enabled Catch/Stat/Move model, including shiny/death details, provenance/provider information, BST legality details, and move accuracy. If the richer compatibility model fails, SAFE MODE now reconstructs all enabled pages directly from the selected Pokémon instead of collapsing to a minimal Catch-only view. Runtime confirmation is required.

# Release candidate — 2.2.2

## 2.2.2 RC — battle-money label + Yellow enforcement runtime ledger

Direct child of 2.2.1 RC. This narrow follow-up renames the compact Trainer Money label from `Trnr ¥` to `Btl. ¥` so the control reads as battle-money scaling rather than trainer shorthand. Yellow 2.1.24 save-game runtime testing also confirmed No Buying, No Selling, and No Center Heal / Pokémon Center healing enforcement; those paths are protected and unchanged in 2.2.2. No rule mechanics, save/API behavior, file tree, Gold layout, or Gen1Recomp 0.1.94 compatibility behavior changed.

# Release candidate — 2.2.1

## 2.2.1 RC — Gold value-column visual correction

Direct child of 2.2.0 RC. Gold runtime testing showed the 2.1.23/2.2.0 right-aligned Setup/NUZ RULES value column sat one native tile too close to the right frame, causing ON/OFF/WIP values to crowd or clip the border. 2.2.1 keeps the improved ten-tile rule-label field and moves only the Gold value/toggle anchor one tile left. R/B/Y layout, Gold rule mechanics, Gen1Recomp 0.1.94 compatibility work, and all 2.2.0 runtime-repair paths are unchanged. Runtime visual retest is required in Gold Setup and in-game NUZ RULES.

# Release candidate — 2.2.0

## 2.2.0 RC — Gen1Recomp 0.1.94 compatibility + runtime repair rollup

Direct child of 2.1.24 RC. This is the requested major/minor version step for the newly released Gen1Recomp 0.1.94 compatibility pass. The v0.1.93→v0.1.94 tag delta was source-reviewed: 10 commits, centered on version-aware launcher mod conflicts and the new API-2 `mod.postLog`/manifest `log_url` reporting facility. No reviewed 0.1.94 gameplay-hook change requires a Nuzlocke battle, encounter, party, save, or Gold enforcement rewrite. Nuzlocke therefore keeps Mod API 2, save schema 4, `engine_internals` only, and the established `>=0.1.86 <0.1.98` engine envelope while updating its audited-engine marker to 0.1.94.

2.2.0 also rolls forward the open 2.1.24 runtime fixes: R/B/Y NUZ INFO now isolates optional API/provider failures and degrades to a safe read-only direct-Pokémon view instead of allowing a party-menu crash; classic MOD COMPAT uses width-bounded labels/owners while Modern UI keeps full semantic names; NUZ ST. carries explicit RUN STATUS and ACTIVE RULES headings so grouping survives Modern UI presentation; Yellow's Pallet Town Professor Oak capture demo is skipped at the direct `Commands.pushBattle` seam while preserving Oak's post-demo text and lab escort; and Bryan no longer uses the rough hand-painted true-color renderer, instead using native engine NPC walkers/palette/animation with no new asset file.

Runtime confirmation is still required for 0.1.94, NUZ INFO, both MOD COMPAT layouts, both NUZ ST. layouts, Yellow Skip Catch Demo, and Bryan's native appearance. Previously confirmed Yellow 2.1.23/2.1.24 behavior remains protected: randomized starter received-name/party delivery, Trainer Money symbol, Setup/Type Locke selector behavior, name skip, starter PC resource loadouts, and native Trainer Card.

# Release candidate — 2.1.24

## 2.1.24 RC — R/B/Y NUZ INFO native-menu crash repair

Direct child of 2.1.23 RC. Yellow runtime testing confirmed randomized-starter messaging, party delivery, and the Trainer Money symbol, but opening party NUZ INFO still crashed. 2.1.24 moves the remaining R/B/Y NUZ INFO presentation off the custom hand-drawn `NuzlockeCatchInfoScreen` and onto Gen1Recomp's host-owned `ListMenu`, using the existing API-27 read-only Pokemon info model. Gold keeps its native-styled NUZ INFO pages. No rule enforcement or save/API semantics changed. Runtime retest is required.

# Release candidate — 2.1.23

## 2.1.23 RC — systemic T3 dialogue presentation repair

Direct child of 2.1.22 RC. Repeated Yellow runtime reports showed that Mom, the Viridian catch sequence, Oak's Lab and other dialogue could exhibit the same stitched/continuation presentation while World Building T3 was enabled. 2.1.23 replaces location-by-location repairs with one shared T3 presentation boundary: Nuzlocke-owned world text is consistently wrapped/paginated, and ScriptRunner `show_text`/`ask` dialogue carrying Gen1's `\v` continuation marker is normalized at T3 without changing story logic. The R/B/Y catch tutorial now actually skips the semantic `old_man_demo` row while preserving the surrounding vanilla script. Gold rule values are right-aligned farther right and rule labels regain width. Runtime confirmation is required.

# Release candidate — 2.1.22

## 2.1.22 RC — R/B/Y Nuz menu native-surface repair

Direct child of 2.1.21 RC. Yellow 2.1.21 runtime confirmed that both NUZ ST. and MOD COMPAT could still hard-crash. For R/B/Y, those two START-menu surfaces now return Gen1Recomp's stable mod-facing ListMenu instead of hand-drawn custom states, preserving the same status/compatibility data while delegating scrolling, drawing, cancel input, and StateStack timing to the host UI. Gold keeps its generation-native status/Chrome paths. All previously confirmed Yellow Setup/name-skip/startup-resource/native-Trainer-Card PASS behavior and the 2.1.21 Gold spacing change are preserved. Runtime confirmation required.

# Release candidate — 2.1.21

## 2.1.21 RC — Gold Setup spacing cleanup

Direct child of 2.1.20 RC. Gold's native Setup/Rules renderer now reserves a full tile of visual separation between each rule label and its value/toggle by reducing only the label field from 10 tiles to 9 while preserving the existing seven-tile value column. This is a presentation-only Gold change: rule keys, values, controls, descriptions, R/B/Y layout, and the 2.1.20 Nuz-menu recovery work are unchanged. Runtime visual confirmation is required.

## 2.1.20 RC — Yellow runtime follow-up

Direct child of 2.1.19 RC. Yellow runtime testing confirmed NEW GAME Setup, Type Locke selector visibility, default-name skip, PC Heal loadout, Rare Candy loadout, PC Vitamins, and the native Trainer Card. 2.1.20 preserves those paths while hardening Nuzlocke-owned in-game menu recovery: draw failures are no longer allowed to mutate the StateStack from inside draw(), and NUZ RULES / NUZ STATUS defer error recovery to the next update tick so a recoverable screen fault can display a diagnostic instead of escalating into a hard crash.

Menu cleanup: Game Difficulty now has its own section (VANILLA remains its OFF/unaltered setting); Trainer Money and Starting Money use the native ¥ symbol; No Escape Rope displays as `No Esc. Rope`; and the fresh-PC medicine option is now `Heal Loadout`. Type Locke enforcement remains mode-authoritative: OFF allows every type, MONO uses only Type 1, DUO uses only Types 1-2, and TRI uses only Types 1-3. Runtime enforcement remains TEST REQUIRED.

`2.1.19` is a direct child of `2.1.18 RC` and is a narrow compatibility/lifecycle hardening pass based on code review. Gen1 kerning installation retries no longer depend on the currently active generation; the installed wrappers still remain Gen1-only at call time. Gen1 Modern UI adapter registration now requires an explicit `true` result, so `nil`/unexpected provider returns cannot be reported as successful registration. The R/B/Y title SETUP fallback now uses a stable mutable wrapper state that refreshes the current `openSetup`, translation, and save-editor dependencies across mod reloads, including migration from the exact 2.1.18 wrapper. No challenge-rule mechanics are changed. Runtime confirmation is required.

# Release candidate — 2.1.18

`2.1.18` is a direct child of `2.1.17 RC` and is a Yellow runtime-hardening pass. The native R/B/Y Trainer Card is no longer hijacked by Nuzlocke; `NUZ ST.` is a separate START-menu status surface, removing the wrapper path implicated in the reported Trainer Card crash. Nuzlocke-owned script messages now use one-response-per-transaction ownership to prevent compatibility seams from stacking duplicate mod boxes. The bedroom SNES screenshot was source-audited and is vanilla Gen1 `cont` scrolling, not T3 duplication, so upstream dialogue presentation is preserved. Runtime confirmation is required.

# Release candidate — 2.1.16

`2.1.16` is a direct child of `2.1.15 RC`. This focused rules/UI pass adds **TRI / Trilocke** to the shared R/B/Y + Gold Type Locke system, verifies the effective restriction is mode-authoritative (OFF = no type restriction; MONO = displayed Type 1 only; DUO = displayed Types 1–2; TRI = displayed Types 1–3), moves **Route Forgiveness** from CORE to CLAUSES and **No Catching** from CORE to GENERAL, and adds +1 pixel micro-tracking to the existing bold-like centered section headers so neighboring glyphs do not visually merge. Runtime confirmation is required.

# Release candidate — 2.1.15

`2.1.15` is a direct child of `2.1.14 RC`. It is a narrow configuration-UI repair: section headers are centered and receive bold-like pixel emphasis, ordinary rule rows use more of the left gutter, Type Locke OFF hides/clears both type selectors while MONO hides/clears only Type 2, and the reversible **Rule Lock** control is restored as a separate feature from the still-WIP **Permanent Rule Seal**. Runtime confirmation is required.

# Release candidate — 2.1.13

`2.1.13` is a direct child of the canonical packaged `2.1.12 RC`.

This is a narrow Yellow/T3 repair candidate. It does not add unrelated challenge features.

- Random Starter now filters its concrete starter pool against the engine contracts used by `Pokemon.new` and the party Summary screen. Partial/provider species records with missing growth, type, learnset, base-stat, or displayed-move data are skipped instead of being allowed to become a crash-prone starter.
- Vanilla Yellow Pikachu remains untouched when Random Starter is OFF. The existing pre-creation `pokemon.before_give` seam is retained because Gen1Recomp 0.1.93 constructs the Pokémon only after that event returns.
- Mom's blocked home-heal interaction is transaction-guarded so overlapping script-command/fallback seams cannot emit the same Nuzlocke rejection twice.
- Mom's allowed T3 Bryan flavor remains one-time-per-save; later allowed heals return to vanilla dialogue.
- The Pallet home TV no longer appends an unrelated `Rule watch:` suffix. Each T3 report is wrapped to the Gen1 textbox width and explicitly paginated.
- T3 Bryan now exists as an actual runtime NPC in `REDS_HOUSE_1F`, with a real map-script interaction and rotating home/Gen1Recomp/Pokémon Bois Club/game-console dialogue. No new sprite asset or repository file is added.
- T0–T2 TV behavior and non-TV interactions remain vanilla.
- Gen1Recomp 0.1.94 is the current source-audited target; engine range remains `>=0.1.86 <0.1.98`.

**Validation status:** parser/static/source-audit only until runtime retest. Yellow Random Starter OFF/ON, immediate Party/Summary opening, Mom blocked/allowed heals, T3 TV, Bryan home NPC, Setup, NUZ RULES, MOD COMPAT, and Wide Menus classic coexistence are runtime TEST REQUIRED.

# Release candidate — 2.1.12

`2.1.12` is a direct child of `2.1.11 RC`.

This candidate changes Route Forgiveness rewards and adds localization-safe compact UI fallbacks.

- `Nuzlocke Loadout` remains canonical/translatable; compact fallback: `Nuz. Loadout`.
- `Dungeon Lock-In` remains canonical/translatable; compact fallback: `Dung. Lock-In`.
- `BATTLE ITEMS` / `FIELD ITEMS` remain canonical section strings; compact fallbacks: `BATTLE ITMS` / `FIELD ITMS`.
- `No Healing Items`, `No X Items`, and `No PP Items` keep their full translation keys; compact fallbacks use `Itms`.
- Ordinary Gym Trainers no longer award Route Forgiveness Tokens.
- Defeating a Gym Leader awards exactly one Route Forgiveness Token for that Gym, once.
- The award is delivered directly by the Leader-victory reward path. The Gym Guide is not a second token source, preventing double awards.
- A persistent Leader-keyed ledger prevents rematches or alternate trainer-party identities from paying again.
- Existing old per-Gym-Trainer reward ledger data is ignored but not deleted.

Gen1Recomp 0.1.94 is source-audited; engine range remains `>=0.1.86 <0.1.98`.

# Release candidate — 2.1.11

`2.1.11` is a direct child of `2.1.10 RC`.

This candidate combines a localization-safe label architecture with the Gen1Recomp 0.1.93 compatibility audit.

## Localization-safe compact labels

Rule/category source strings are natural full phrases again. Compact English labels are stored separately as optional `shortName` / `shortTitle` display fallbacks.

R/B/Y display logic now:
1. translates the full canonical label;
2. keeps it if it fits the measured pixel budget;
3. if the full label overflows, tries the compact label only when it is safe to do so;
4. if a translation pack translated the full label but did not translate the compact label, Nuzlocke does **not** inject the English abbreviation — it marquee-scrolls the translated full label instead;
5. true overflow retains the approved slow marquee cadence.

Full descriptions remain canonical/translatable and are not abbreviated.

## Gen1Recomp 0.1.93

Gen1Recomp 0.1.93 is now the current source-audited engine target inside the existing `>=0.1.86 <0.1.98` envelope.

The upstream 0.1.92→0.1.93 delta is 14 commits. It touches launcher/updater infrastructure, data loading/default seeding, LegacyCompat, required-import/mobile picker infrastructure, TLS/update checking, and tests. No reviewed change requires a Nuzlocke gameplay-hook rewrite or new permission.

Nuzlocke's runtime compatibility report now advertises `0.1.93` as the audited engine version.

# Release candidate — 2.1.10

`2.1.10` is a direct child of `2.1.9 RC`.

Yellow runtime feedback confirmed the current marquee cadence is good and that Wide Menus can now coexist without the previous Setup crash. Nuzlocke intentionally remains on its classic/native-width configuration surface while Wide Menus is installed; this is the validated compatibility fallback, not an active wide-layout integration.

2.1.10 is a menu-density pass. Common rule labels are shortened so more rows stay static instead of entering marquee scrolling, while the description pane keeps the complete wording and behavior.

Highlights:
- section headers drop decorative `- ... -` wrappers;
- `AREA SPLITS` becomes `ROUTE SPLITS`;
- `RANDOMIZER` becomes `RNDMIZER`;
- route split rows become `Rt. 2`, `Rt. 10`, `Rt. 20`, `Mt. Moon`, `Safari`;
- commonly understood abbreviations are used for encounter, learnset, town, legendary/mythical, player/wild/trainer, money, BST, gifts/trades, level caps, healing, escape rope, candy, default names, and vitamins;
- full rule descriptions remain unabbreviated.

# Release candidate — 2.1.9

`2.1.9` is a direct child of `2.1.8 RC`.

Yellow / Gen1Recomp 0.1.92 runtime feedback:

- Current conditional marquee speed: PASS; unchanged.
- Several common rule labels still marquee unnecessarily.
- Fresh NEW GAME Setup still crashes when Wide Menus is installed.

2.1.9 changes only presentation/compatibility surfaces:

- `First Rival Mercy` → `1st Rival Mercy`
- `One Per Area` → `1 Per Area`
- `Failed Encounters` → `Failed Enc.`
- Existing concise Randomizer labels remain.
- Full descriptions remain unabbreviated in the explanation pane.
- `NuzlockeConfigScreen` now explicitly declares `uiModLayout = "classic"` and `keepClassicUi = true` for both Setup and in-game NUZ RULES.
- This is stronger than merely declining Wide Menus `claim()`: it prevents Wide Menus' later opaque-mod-screen auto-layout hooks from widening the screen.

# Release candidate — 2.1.8

`2.1.8` is a direct child of `2.1.7 RC`.

This candidate refines the R/B/Y variable-width rules presentation by reducing avoidable marquee use through familiar menu abbreviations while keeping full explanations in the description pane.

Menu-facing Randomizer labels are now:
- `Rndm Starter`
- `Rndm Enc.`
- `Rndm Learnset`

The underlying rule keys, behavior, save data, provider contracts, and full descriptions are unchanged.

Presentation policy remains:
- text that fits its measured pixel budget stays completely still;
- only true overflow marquee-scrolls;
- descriptions remain full, pixel-wrapped, and static unless they genuinely exceed the vertical description area;
- Wide Menus stays installed-safe via native-width fallback until a separately validated wide adapter exists.

# Release candidate — 2.1.7

`2.1.7` is a direct child of `2.1.6 RC`.

Yellow / Gen1Recomp 0.1.92 runtime testing found two remaining presentation/compatibility problems:
- installing Wide Menus caused the Nuzlocke rules screen to crash;
- the custom outline selection indicator rendered as ineffective stray colored marks near the divider.

2.1.7 takes the conservative release-hardening path:
- Nuzlocke no longer claims the Wide Menus canvas for its custom rules screen;
- Wide Menus may remain installed, but Nuzlocke stays on the validated native-width layout;
- custom `love.graphics` row highlighting is removed;
- the engine-native cursor glyph is restored for reliable selection visibility;
- the cursor is moved farther left and rule text begins at X=22 instead of the historical X=30, reclaiming some horizontal space;
- conditional marquee behavior from 2.1.6 remains: fitting text never scrolls, real overflow waits 3 seconds and moves at the slow historical cadence.

# Release candidate — 2.1.6

`2.1.6` is a direct child of `2.1.5 RC`.

Runtime feedback on Yellow showed two presentation regressions in 2.1.5:
- the new conditional marquee moved far faster than the historical marquee cadence;
- the filled reverse-video selection bar made row text unreadable on Yellow's palette/font path.

2.1.6 repairs both without giving back the reclaimed left-side text space:

- conditional marquee now waits 3 seconds and advances at the old slow cadence (about 2.4 seconds per glyph step);
- text that fits still never scrolls;
- filled selection bars are removed;
- selected R/B/Y rows use a thin outline rectangle instead, leaving font colors untouched;
- the left cursor gutter remains reclaimed for longer labels;
- MOD COMPAT overflow scrolling uses the same slow cadence.

# Release candidate — 2.1.5

`2.1.5` is a direct child of `2.1.4 RC`.

Yellow/Gen1Recomp 0.1.92 runtime testing showed that 2.1.4's static pixel-aware labels were an improvement for text that fit, but ellipsizing genuinely long rule names was not desirable.

2.1.5 changes the R/B/Y presentation policy:

- Text that fits its actual pixel budget stays completely static.
- Text that genuinely exceeds the budget marquee-scrolls by glyph spans.
- Normal rule/value labels no longer use ellipses.
- The old left-side per-row cursor glyph is removed from R/B/Y rules rows.
- Selection is shown with reverse-video/inverted row highlighting instead, reclaiming the cursor gutter for text.
- Rule names start farther left and receive a larger usable pixel budget.
- Descriptions remain pixel-wrapped and static unless they genuinely overflow vertically.
- MOD COMPAT keeps separate non-overlapping columns; a column scrolls only when its text truly exceeds that column's pixel budget.

Gold's native Gen2 presentation remains unchanged.

# Release candidate — 2.1.4

`2.1.4` is a direct child of `2.1.3 RC`.

This candidate is a presentation cleanup after Yellow/Gen1Recomp 0.1.92 runtime testing proved the Gen1 variable-width Font path is active and the MOD COMPAT crash is repaired.

Changes:
- R/B/Y Nuzlocke Setup and NUZ RULES now measure text with the active Font in pixels.
- Rule names and section headers no longer use marquee scrolling as their normal presentation.
- R/B/Y titles and value labels are static; genuine overflow is ellipsized instead of marquee-scrolled.
- Rule descriptions wrap to the full available pixel width and remain static whenever three lines fit.
- Description scrolling is retained only as a genuine vertical-overflow fallback.
- MOD COMPAT uses measured/truncated label and owner columns so kerning cannot make the two columns overlap.

Runtime evidence inherited from 2.1.3 RC:
- Yellow fresh Setup: PASS
- Setup-to-game boot: PASS
- Gen1 variable-width/kerning presentation: PASS
- MOD COMPAT crash repair: PASS
- Yellow Trainer Card / A:NUZ surface: PASS
- MOD COMPAT layout: FAIL in 2.1.3 due overlapping columns; repaired here and requires retest

# Release candidate — 2.1.3

`2.1.3` is a direct child of `2.1.2 RC`.

This candidate incorporates the final focused code-review repairs before release testing:

- Gym Trainer Forgiveness reward identities now normalize `id`, `class`, and `name` independently and preserve field boundaries in the persistent ledger key.
- Gen1 kerning now resolves the maintained active game through an injected `getCurrentGame()` dependency instead of relying on the never-assigned `mod.game` field.
- `compat21.pokemonLegality()` now recognizes the real string-valued `nuzlockeInvalidAcquisition` marker and exposes the specific reason as `invalidAcquisitionReason`.
- The 2.1.2 MOD COMPAT repair remains included: R/B/Y no longer requires the obsolete `src.render.Draw` module.

Yellow / Gen1Recomp 0.1.92 runtime evidence inherited and protected:
- fresh NEW GAME Setup appears: PASS
- Setup accepts choices and boots into gameplay: PASS

Still requiring runtime confirmation in this candidate:
- MOD COMPAT opens, scrolls, and closes cleanly
- Gen1 variable-width/kerning presentation is visibly active in Setup/Nuz Rules
- Gym Trainer Forgiveness awards once per distinct trainer
- invalid gift/trade acquisitions are reported as restricted through `compat21.pokemonLegality`

# Release candidate — 2.1.2

Direct child of the 2.1.1 release candidate.

Yellow / Gen1Recomp 0.1.92 runtime results inherited and protected:
- fresh NEW GAME Setup appears: PASS
- Setup accepts choices and boots into gameplay: PASS
- in-game MOD COMPAT screen: FAIL/crash in 2.1.1 RC
- expected Gen1 variable-width/kerning presentation was not visibly active in Setup or Nuz Rules

2.1.2 fixes the MOD COMPAT crash by removing its stale dependency on the removed `src.render.Draw` module and drawing through the current `src.render.Font` box API. It also retries the Gen1 kerning fallback after `game.ready` / `save.loaded`, when the game generation and Font surface are available, and corrects MOD COMPAT's kerning diagnostic marker.

# Release candidate — 2.1.1

`2.1.1` is the first candidate after the SemVer transition. It is a direct child of `2.1.0`.

Engine compatibility was re-audited against Gen1Recomp 0.1.92. The supported manifest envelope is now `>=0.1.86 <0.1.98`: 0.1.92 is source-reviewed, while 0.1.93–0.1.97 are an intentional forward-compatibility allowance and are **not** claimed as runtime-tested until each upstream release is reviewed.

Gen1Recomp 0.1.92 adds sanctioned `mod.fetch` and `mod.job` background facilities and a broad `LegacyCompat` bridge for older sandbox-era calls. Nuzlocke does not need network/background work for its current mechanics, so this candidate does not request unnecessary new permissions. Existing scoped/safe persistence remains unchanged.

# Development update — 2.1.0

`2.1.0` is the new canonical development identity for the exact code/features previously packaged as `2.0.0-beta.31.0.4`. This is a versioning/distribution transition only: no gameplay or compatibility logic changed in the renumbering.

Future development proceeds forward from `2.1.0`.

# Development update — 2.0.0-beta.31.0.4

Direct child of `2.0.0-beta.31.0.3`. Adds optional Wide Menus V0.1.0 presentation support for the in-game R/B/Y **NUZ RULES** screen. Nuzlocke remains the sole state/action owner; fresh New Game Setup and Gold remain on their protected native layouts.

# Development update — 2.0.0-beta.31.0.3

Direct child of `2.0.0-beta.31.0.2`. Focused Dungeon Lock-In repair: service interiors such as the Pokémon Center beside Mt. Moon are no longer classified as dungeon maps merely because a runtime/provider map id shares the dungeon landmark prefix.

# Development update — 2.0.0-beta.31.0.2

Direct child of `2.0.0-beta.31.0.1`. Compatibility-review build for Gen1Recomp `0.1.90`. The existing supported engine envelope `>=0.1.86 <0.1.91` already includes 0.1.90, so no engine-range, Mod API, save-schema, or gameplay-rule change is required.

# Development update — 2.0.0-beta.31.0.1

Direct child of `2.0.0-beta.31.0.0`. Focused bug-fix/hardening build for live difficulty staging, Modern UI lifecycle/generation safety, R/B/Y title Setup save-editor lifecycle, and Trainer Rewards progression/leader matching. No new gameplay feature is introduced.

# Development update — 2.0.0-beta.31.0.0

Direct child of `2.0.0-beta.30.1.22`. This is a focused **World Building content pass**. Tier 3 gives Bryan a larger recurring fictional role around the Pokémon Bois Club and the player's Pallet home: he says “boi” constantly, claims he created the Nuzlocke mod, claims he worked on Gen1Recomp from the player's bedroom computer, stays at the house, uses the game console, and becomes the subject of increasingly strange Pallet TV reports. Mom/Bryan flavor uses cheeky non-graphic innuendo. No achievement mechanics or Black Market mechanics are enabled in this build.

# Development update — 2.0.0-beta.30.1.22

Direct child of `2.0.0-beta.30.1.21`. This build concentrates on three player-facing intelligence upgrades without changing challenge-policy ownership: **Encounter Tracker / Area Guide intelligence**, an expanded **MOD COMPAT** ownership page, and **NUZ INFO legality + provenance**. Tracker rows now expose compact encounter-source tags and provider context without revealing future randomized mappings. MOD COMPAT reports a broader set of active mechanic owners, including caps, difficulty, species metadata, identity, encounters, escape/warps, movement, presentation and text layout. NUZ INFO evaluates a Pokémon against the currently active restriction set and reports semantic provider/source provenance without mutating the Pokémon or save.

`2.0.0-beta.30.1.21` introduced compatibility intelligence, spoiler-safe Randomizer ownership context, merged species metadata, translation-safe semantic matching, and context-sensitive World Building guidance.

`2.0.0-beta.30.1.20` introduced the Gen1-only variable-width Nuzlocke presentation layer. Gold/Gen2 remains hard-excluded from the Gen1 glyph transform.

## 2.0.0-beta.30.0.0.10

Conflict-hardening pass over the 30.x compatibility layer. Delegated non-core mechanics now suppress their runtime implementation as well as their menu value; presets can still update the dormant Nuzlocke preference so removing a provider restores the intended preset state. EXP Edging follows level-cap ownership. Provider detection is rebuilt from the active mod graph and randomizer delegation requires granular capabilities instead of a generic RANDOMIZER name. The public delegation export is late-bound, the external item API routes through the same authoritative item policy used by native menus, the acquisition API uses the real Type Locke/special-acquisition policy, AutoCompat reads `game.save.party`/`game.save.boxes`, Gold surfaces No Fishing denial in PackMenu, and recovery no longer duplicates an EDITED mon already matched to a saved legacy row. Runtime validation remains required, especially R/B/Y catch-demo skipping and cross-mod randomizer registry composition.

# Nuzlocke 2.0

A configurable, enforced Nuzlocke ruleset for **Pokémon Gen1Recomp**, focused first on **Red, Blue, and Yellow** with **Gold beta support**.

**Current beta release:** `2.0.0-beta.29.3.16`  
**Targeted Gen1Recomp:** `0.1.83`  
**Games:** Red, Blue, Yellow, Gold  
**Gen1Recomp Mod API:** `2` · **Nuzlocke Compatibility API:** `27` · **Save schema:** `4`

This development build rolls directly from `2.0.0-beta.29.3.12`. It preserves the exact repository tree and protected runtime-PASS behavior while hardening migrations, master-switch boundaries, provider identity, acquisition provenance, dungeon entrances, and compatibility APIs.

## 29.3.16 — Nuz Info / Compatibility API 27

Direct child of `2.0.0-beta.29.3.15`.

This third small update contains the remaining already-completed UI/API work. The former single-purpose party Catch Info row becomes **NUZ INFO**, with independently toggleable **Catch**, **Stat**, and **Move** pages. A/Right advances, Left goes backward, and B closes. Stat Info shows current stats, DVs, and raw Stat EXP; Gold correctly shares Special DV/Stat EXP between Special Attack and Special Defense. Move Info reads name/type/power/accuracy/current-max PP from the active merged move registry.

Compatibility API **27** adds read-only Nuz Info page/Pokemon helpers so other UI/summary mods can compose with this data without scraping the screen. These presentation settings remain outside Permanent Rule Seal.

## 29.3.15 — Rule UI, dialogue, and Gold QoL

Direct child of `2.0.0-beta.29.3.14`.

This second small update contains the already-completed presentation/configuration work without the larger Nuz Info screen expansion. Game Difficulty, Level Cap Scope, and EXP Edging move into a dedicated **LEVELS** section; **BATTLE ITEMS** now contains only actual item-use restrictions; No Catching is presented as the single semantic capture-ban rule in Core; No Escape moves to General. Stat EXP descriptions now make the native 0% default and preset scale explicit.

Gold gains the optional **Skip Cherrygrove Tour** QoL setting: after accepting the Guide Gent's offer, the long walking/explanation segment is skipped while the native MAP CARD reward and cleanup still execute. Rare Candy, TM, and field-healing denials also receive more item/move-aware World Building dialogue. Compatibility API remains 26 here.

## 29.3.14 — Gold runtime repair

Direct child of `2.0.0-beta.29.3.13`.

This smaller update contains only the runtime-critical Gold fixes already completed in the larger work pass: compact Gold START-menu labels now use the hook-supplied Gold game; Gold No Buying / No Selling gate the native Mart BUY/SELL entry points and recheck the transaction seams; Random Starter keeps a stable preview per starter ball and commits only the accepted ball; Elm's Gold starter portrait/cry is rewritten to match the randomized grant; starter provenance is synchronously registered as New Bark Town / STARTER with conservative reconciliation for the 29.3.12/29.3.13 UNKNOWN case; and Gold Stat EXP descriptions now explicitly preserve the native 0% default.

No rule-menu reorganization, Nuz Info expansion, or new exposed QoL option is included yet; those are intentionally split into the next two sequential builds.

## 29.3.13 bugfix / hardening highlights

- **No Catching migration corrected:** retired partial Ball-ban tiers no longer silently become the absolute No Catching rule. An absent `no_catching` key takes the neutral OFF default; an explicitly saved No Catching choice is preserved.
- **Trainer Money master-switch + Gold fix:** payout scaling now records and applies only while the Nuzlocke master switch is active. Its transient wallet state is declared before the battle callback that uses it, and the wallet adapter supports both R/B/Y `save.money` and Gold `save.player.money`.
- **Stable Game Difficulty identity:** the selected difficulty is resolved by `difficulty_provider_id`, not by a mutable dynamic list index. Missing external providers temporarily fall back to VANILLA without erasing the requested ID; old index-only saves bootstrap a stable ID once. Setup profiles preserve the same identity.
- **Route Forgiveness master-switch fix:** token awards, shop presentation, and failure-spend prompts are inert while Nuzlocke is OFF.
- **Dungeon Lock-In entrance hardening:** the lock now remembers the exact exterior entrance warp rather than only its map. A different exit on the same outside map is therefore legitimate; legacy coordinate-less lock state fails open instead of risking a softlock.
- **Acquisition provenance hardening:** Game Corner prize sources are version-aware (including Scyther/Dratini/Pinsir), the English R/B and Yellow NPC-trade tables now match the authoritative game data, Gold no longer inherits Gen-I source tables, and source-less compatibility inference requires a matching live location or genuinely deterministic provenance.
- **Gold NPC-trade parity:** Gold's native `TradeMenu`/`NpcTrade` transaction is now gated before its one-shot flag or outgoing Pokemon changes, then successful trades are tracked from the live map. Gift/Trade toggles are exposed on the Gold beta rule surface.
- **Type Locke RANDOM hardening:** RANDOM chooses only types represented by the live merged species/provider pool when possible, preventing vanilla R/B/Y from rolling empty Dark/Steel runs.
- **Warp-provider compatibility:** Gym/Dungeon Lock-In evaluates the final composed `warp.destination` result after downstream providers run, while still owning the final lock-in policy.
- **World Building de-duplication:** the first capped EXP transaction with EXP Edging now shows one combined cap/banked-EXP message instead of two near-duplicate boxes back-to-back.
- **Defaults audited:** new restrictive systems remain opt-in: Type Locke OFF, No Day Care OFF, Gym/Dungeon Lock-In OFF, Route Forgiveness OFF, No Catching OFF; Trainer Money remains 100% and Game Difficulty remains VANILLA. QoL remains independently configurable.
- **Compatibility API 26:** adds stable difficulty-selection state, master/rule activity queries, Type Locke helpers, Forgiveness token access, Dungeon Lock state/family helpers, version-aware gift/trade lookup and acquisition classification, plus expanded persistent Pokémon-field ownership metadata.

The new/changed 29.3.13 paths are **TEST REQUIRED** until in-engine runtime validation. Existing protected runtime PASS results are not reclassified.

## 29.3.12 development highlights

- **Random Mono / Random Duo:** Type 1 and Type 2 selectors now accept RANDOM. At NEW GAME the request rolls once into a concrete type and persists it; Duo always resolves to two distinct types. In-game RANDOM selection resolves immediately.
- **Type Locke UI polish:** clearer type labels and persisted allowed-type presentation.
- **Dupes accounting hardening:** a duplicate encounter is stamped as a battle-scoped free encounter before failure handling, so it cannot consume an area or spend a Forgiveness Token.
- **Diglett's Cave normalization:** exact Gen I/Gold/provider spellings (`DIGLETT_CAVE`, `DIGLETTS_CAVE`, CamelCase equivalents) resolve to the single canonical `DIGLETT_CAVE` area.
- **Forgiveness polish:** the ¥1,000,000 shop row now carries clearer metadata and status surfaces show the live canonical token balance.
- **Starting-resource audit:** deterministic regression cases cover vanilla ¥3000, intentional ¥0, malformed values, clamping, Balls, and Rare Candies. Gold remains isolated from hidden Gen-I resource fields.
- **No Day Care polish:** T3 rejection text better distinguishes a closed Day Care from safe retrieval of existing occupants.

All new 29.3.12 behavior remains **TEST REQUIRED** until in-engine runtime validation.

## 29.3.11 development highlights

**Pokemon Bois Club** adds a new **Tier 3 World Building** cosmetic rebrand for Vermilion's Pokémon Fan Club. At T3, the club is presented as the **Pokemon Bois Club**, with safe rewording of relevant club/sign dialogue and a custom Bryan-the-Boi tribute chairman sprite. This is presentation-only and does not change story flags, item gifts, Bike Voucher flow, or other rule enforcement.

**Type Locke** adds one shared framework for **Monolocke** and **Duolocke** runs in R/B/Y and Gold. `OFF / MONO / DUO` selects normal play, one allowed type, or two allowed types. Dual-type Pokémon qualify when either type matches. Off-type wild encounters are rejected without consuming the area's encounter or a Route Forgiveness Token, and Shiny Clause does not bypass the type restriction. Native gifts/trades use the same legality rule where a pre-transaction seam exists. Random Starter now prefers the selected Type Locke pool when enabled. Unknown custom-species type schemas fail open rather than being guessed.

**No Day Care** blocks new Day Care deposits while Nuzlocke is active. R/B/Y gates the Day-Care Man before a new deposit; Gold gates the native Gen 2 breeding model before a party member is removed. Pokémon already deposited before the rule was enabled can still be retrieved, and Gold's existing parent/Egg state is left intact.

Permanent Rule Seal now explicitly follows the project invariant: it seals challenge rules such as Type Locke and No Day Care, but **does not seal Game Difficulty, World Building, QoL, or presentation controls**.

The mandatory starter remains progression-safe: Type Locke will not block the story-required starter path. A randomized starter is filtered toward the legal type pool when possible. Full roster quarantine/collection-only enforcement for pre-existing or progression-only off-type Pokémon remains future work.

The new 29.3.11 Pokemon Bois Club presentation path and the prior 29.3.10 Type Locke / No Day Care rule paths are **TEST REQUIRED** until runtime validated.

## 29.3.9 development highlights

Gold no longer reuses the R/B/Y pixel-positioned presentation for Nuzlocke-owned screens. **Setup / NUZ RULES, ENC TRACKER, CATCH INFO, Route Forgiveness prompts, and NUZ STATUS now render with Gen1Recomp's native Gen 2 `Chrome` vocabulary**: 20x18 tile-grid boxes, Gold cursor/down-arrow glyphs, native money formatting, scrolling lists, and Gold-sized text wrapping. The underlying rule, encounter, save, and compatibility state remains shared; this pass changes presentation ownership rather than gameplay legality.

The integration follows Gen1Recomp's documented Gen 2 rule that `src.ui.OptionRows` has no Gold facade because the Gen 1 options chrome is not a valid Gold presentation seam. Nuzlocke therefore owns only its custom screens and does not replace Gold's global renderer or native Trainer Card lifecycle. Existing R/B/Y screens are unchanged.

All new Gold-native presentation remains **TEST REQUIRED** until runtime validated.

## 29.3.8 development highlights

World Building now uses one shared OFF/T1/T2/T3 presentation catalogue for rule feedback, with clear Tier 1 explanations, more personality at Tier 2, and region-aware Kanto/Johto flavor at Tier 3. Gold now exposes the World Building selector instead of silently forcing flavor OFF. Catch denials, item restrictions, shops, healing, Game Corner restrictions, lock-ins, encounter failures/forgiveness, EXP Edging, trainer-money scaling, First Rival Mercy, Permadeath, and Whiteout presentation were consolidated onto the shared system where safe.

The World Building pass now gives every implemented selectable rule a complete T1/T2/Kanto-T3/Johto-T3 message entry (Wonderlocke remains intentionally WIP), while dialogue is injected only at safe player-facing events so passive configuration rules do not spam the player. The cleanup pass removes the retired live Poké Ball tier machinery now that **No Catching** is the semantic rule, removes the unreachable legacy `no_items` battle check, and de-duplicates R/B/Y/Gold catch-rejection text through one compatibility-safe presenter. Legacy `ball_use_ban_tier` is still read only for one-time save migration.

**IronMON is restored as a first-class Nuzlocke Loadout** alongside Custom, Standard, Hardcore, and Solo. Its preset is explicitly IronMON-style and uses only challenge rules this mod actually owns rather than claiming to reproduce every external IronMON rule.


## Feature highlights

Nuzlocke 2.0 is more than a first-encounter/permadeath toggle. The current beta line includes:

- **Fresh-run Nuzlocke Setup** with presets and collapsible rule categories.
- **Separate R/B/Y and Gold Setup profiles**, rule locking/saving, legacy catch recovery, and R/B/Y starting Money/Poké Ball/Rare Candy controls.
- **NUZ RULES** for active-save rule review and supported editing.
- **Permadeath, Whiteout, One Per Area, Failed Encounters, Nickname Rule, Dupes Clause, and Shiny Clause**.
- **Type Locke** with OFF/MONO/DUO/TRI modes for Monolocke, Duolocke, and Trilocke variants.
- **No Day Care** with safe retrieval of Pokémon deposited before the restriction was enabled.
- **Pokemon Bois Club** Tier 3 World Building cosmetic rebrand for Vermilion's Fan Club, including a custom Bryan-the-Boi chairman tribute sprite.
- **Encounter Tracker** with LOG/MAP-style views and persistent encounter provenance.
- **R/B/Y NUZ STATUS** on the Trainer Card plus a Gold Start-menu status surface.
- **Catch Info** for tracked owned Pokémon.
- **Live level caps** that can follow the final merged trainer rosters.
- **Independent Route 2, Route 10, Route 20, Mt. Moon, and Safari Zone encounter splitting** for R/B/Y.
- **Random Starter** while preserving the surrounding story choice path.
- **Legendary, Mythical, Pseudo, Maximum BST, Static, Glitch, Gift, and Trade controls**.
- **Player/Wild/Trainer starting Stat EXP presets**, **No Player Stat EXP Gain**, and independent **Perfect Player/Wild/Trainer DV** controls.
- **Battle restrictions** for healing items, X items, escape, and semantic **No Catching**.
- **Field restrictions** for Repels, Escape Rope, healing, PP items, TMs, and Rare Candy.
- **Challenge rules** for buying, selling, Pokémon Center healing, Mom healing, Whiteout, Solo Only, **Gym Lock-In**, and conservative **Dungeon Lock-In**.
- **R/B/Y Gym Guide Rare Candy** utility with repeatable selectable batches.
- **Quality-of-life controls** including Default Names, Gold Skip Catch Demo, Catch Info, Area Guide, and Running Shoes.
- **Save Editor-aware loader handling**, stable Pokémon identity/provenance, and compatibility APIs for other mods.
- **Gold beta support** with generation-specific adapters and conservative unsupported-path handling.

## Recent major additions

The current development line has added or substantially hardened:

- independent Player/Wild/Trainer Stat EXP and DV controls;
- **No Pseudos** and **Maximum BST** acquisition rules;
- independent Route 2, Route 10, Route 20, Mt. Moon, and Safari encounter-area splits;
- live merged-roster level-cap discovery, including bounded nested roster containers used by trainer-content modifications;
- Gym Lock-In and conservative multi-exit Dungeon Lock-In enforcement;
- First Rival Mercy, No Static, No Gambling, and glitch-species handling;
- dynamic trainer-party and temporary-party Permadeath/Whiteout compatibility;
- Save Editor session separation and restart-safe gameplay rebinding;
- clearer **ENC TRACKER** / **NUZ RULES** menu naming and collapsible rule sections;
- a public compatibility API, translation surface, provider contracts, and capability relationships;
- dedicated Red/Blue/Yellow/Gold feature-confidence and versioned compatibility documentation.

For the exact per-build history, see [CHANGELOG.md](CHANGELOG.md). Public documentation-only changes and their rationale are tracked separately in [docs/DOCUMENTATION_CHANGELOG.md](docs/DOCUMENTATION_CHANGELOG.md).

## Runtime evidence and regression protection

Runtime-confirmed behavior is treated as the strongest project evidence and is protected from unrelated changes. Current evidence includes fresh-run and existing-save Setup behavior, rule-selection and collapsible-section behavior, shop and item restrictions, encounter tracking, nickname enforcement, Save Editor restart handling, and other core rule paths. When implementation touching a runtime-confirmed path changes, the historical pass remains recorded but the changed path requires renewed regression consideration before current-version confidence is raised again.

### Development-history recovery

The cumulative changelog is reconciled against preserved source, packages, runtime evidence, and retained development records. Exact per-build attribution is preserved only where supported; conflicting or incomplete historical records remain labeled rather than silently rewritten. The repository-only history audit keeps that recovery work durable for future releases.

## Quick start

1. Fully close Gen1Recomp before replacing an older Nuzlocke build.
2. Install the mod as the `nuzlocke` mod folder or import the packaged mod through Gen1Recomp's supported mod flow.
3. Start Gen1Recomp.
4. For a fresh run, open **SETUP** before **NEW GAME**.
5. Choose a preset or configure rules individually.
6. For an existing save, use **NUZ RULES** to review the active ruleset.
7. Use **ENC TRACKER**, **NUZ STATUS**, and **CATCH INFO** during the run.

**Save Editor note:** after editing a save, fully quit and relaunch Gen1Recomp before judging gameplay-rule behavior. The Save Editor and gameplay loader sessions are intentionally kept separate.

## Presets

| Preset | Intended use |
|---|---|
| **CUSTOM** | Build the ruleset manually. |
| **NUZ** | Classic Nuzlocke core rules. |
| **HARD** | Nuzlocke plus Champion-level caps and battle healing/X-item restrictions. Use Gen1Recomp's native SET battle style if you also want that convention. |
| **SOLO** | Nuzlocke plus Solo Only and Whiteout. |
| **IRON** | IronMON-style solo/no-heal/no-shop challenge using only rules Nuzlocke owns. |

## Main screens

**NUZLOCKE SETUP** configures the next new run. **Up/Down navigates** and **A or Left/Right changes supported boolean/multi-state rules**. Sections are collapsible.

**NUZ RULES** presents the active-save rule state using the same rule definitions as Setup.

**ENC TRACKER** records encounter areas and provides history/map-style views. R/B/Y split modes preserve the underlying physical-map provenance so changing the projection does not erase canonical encounter history.

**NUZ STATUS** summarizes run state. Red/Blue/Yellow use the Nuzlocke side of the Trainer Card; Gold preserves its native Trainer Card and uses a Start-menu status surface.

**CATCH INFO** exposes stored encounter/origin information for supported owned Pokémon.

## Full user guide

The complete player manual is in **[docs/USER_GUIDE.md](docs/USER_GUIDE.md)**. It covers installation and updating, controls, Setup, every rule, presets, encounter tracking, Catch Info, status terminology, level caps, existing saves, Save Editor behavior, Gold beta support, troubleshooting, and bug-report information.

## Screenshots

The public presentation is intended to use **authentic Gen1Recomp runtime captures**. This release includes no placeholder screenshots.

Before public publication, the preferred capture set is:

- Gold Setup with expanded/collapsed categories;
- Yellow NUZ RULES with a multi-state/numeric selector;
- ENC TRACKER LOG and MAP;
- R/B/Y Trainer Card NUZ STATUS;
- CATCH INFO;
- one clear rule-enforcement message;
- Gold Start-menu Nuzlocke status.

Repository capture guidance is kept in `docs/screenshots/README.md` and is excluded from the player package.

## Support status

| Game | Current position |
|---|---|
| **Red** | Primary support target. |
| **Blue** | Primary support target. |
| **Yellow** | Primary support target with extensive current runtime evidence. |
| **Gold** | Beta support; smaller surface and more TEST REQUIRED paths. |
| **Silver / Crystal** | Not currently declared or supported. Future investigation only after R/B/Y and Gold maturity. |

The complete evidence-weighted matrix is in [docs/FEATURE_CONFIDENCE.md](docs/FEATURE_CONFIDENCE.md). Percentages are confidence estimates based on runtime, behavior-test, compile/load, and static evidence—not measured failure rates.

## Compatibility

### Mod Compat diagnostics

The in-game **MOD COMPAT** page reports active ownership for supported shared mechanics. Encounter Tracker can label externally randomized encounter ownership without exposing future encounter mappings. Compatible species/content mods can contribute semantic metadata through the merged species-metadata capability. World Building can provide contextual rule guidance without owning enforcement.



The release targets **Gen1Recomp `>=0.1.81 <0.1.84`**. Gen1Recomp 0.1.82 and 0.1.83 were source-audited against the protected Nuzlocke battle, item, shop, save, UI, and Gold script seams. Gen1Recomp 0.1.83 remains the exact source-audited profile; runtime coverage is substantial but not exhaustive, especially on Gold.

Versioned third-party compatibility evidence and known UI-theme limitations are documented in [docs/COMPATIBILITY.md](docs/COMPATIBILITY.md). A newer third-party release never automatically inherits confidence from an older tested version.

## Developer integration

Other mod authors can use Nuzlocke's compatibility API instead of reverse-engineering internal state. [docs/API.md](docs/API.md) documents `nuzlocke_compat` v26, policy queries, level-cap providers, species metadata, Pokémon identity, battle classification, encounter projection, starter randomization, capability relationships, and shared-seam etiquette.

## Reviewed fixes awaiting runtime confirmation

The pre-runtime code-review batch is implemented in this candidate. Because these paths changed after earlier runtime evidence, they remain explicit runtime-test targets before approval:

- First Rival Mercy no longer writes unused `armed` / `triggered` save telemetry; the durable one-shot `battle_seen` state and battle-local forgiveness flags remain authoritative.
- Mandatory scripted starter/gift nicknames now synchronize the matching `nuzlocke_history` row after naming completes on R/B/Y and Gold without moving acquisition registration across the naming lifecycle.
- Gold scripted `givepoke` tracking now detects a newly owned Pokémon in either the party or PC boxes, so full-party gifts can still receive initialization, tracker/history registration, area consumption, and Nickname Rule handling.
- Scripted-static pending provenance is now consumed by the next battle event even when that battle is a trainer battle, preventing the marker from leaking forward into a later unrelated wild encounter.

These are implementation fixes, not runtime PASS claims. The targeted regression matrix is kept in the repository-only testing ledger.

**Current runtime priority:** beta.29.3.13 preserves the protected behavior from 29.3.12 while changing several policy boundaries. Runtime focus is legacy No Catching migration safety, Trainer Money with the master switch ON/OFF in R/B/Y and Gold, stable/missing difficulty providers across reloads, exact Dungeon Lock entrance versus alternate-exit behavior with and without warp providers, Random Mono/Duo viable-type rolls, R/B/Y gift/trade provenance, Gold native NPC-trade rejection/success tracking, EXP Edging's consolidated cap message, and continued Gold UI regression coverage.

## Planned work

The backlog is intentionally driven by confirmed bugs, runtime evidence, version parity, compatibility needs, and project priorities. **R/B/Y is the first priority; Gold advances as its support matures; Silver/Crystal remain later work.** Only project-owner decisions determine what stays, moves, is deferred, or is removed from this list.

### In progress

- Native directional glyphs for collapsible rule headers.
- UI-theme composition for Setup, NUZ RULES, ENC TRACKER LOG/MAP, R/B/Y NUZ STATUS, and CATCH INFO.
- Authentic runtime screenshot set for the public repository.
- Gen1Recomp 0.1.83 runtime certification across the release-gate matrix.

### Planned

- Additional R/B/Y runtime parity and regression coverage.
- More behavior-level automated tests that assert stated rule effects.
- Continued compatibility-version refreshes and exact-version runtime combinations.
- Careful migration from private engine dependencies to equivalent stable public seams when proven safe.
- Continued Gold parity, field-rule, nickname, shop, and destructive-path testing.

### Under consideration / future

- **Wonderlocke** remains intentionally WIP/disabled until a safe, tested provider/transaction contract exists; it must not mutate Wonder Trade transactions while dormant.
- Optional battle-menu auxiliary shortcuts previously discussed during beta.28 development; not implemented or promised.
- Native Pokémon-icon rendering where it improves supported UI surfaces; previously discussed, not implemented or promised.
- Silver/Crystal investigation after R/B/Y is stable and Gold support is sufficiently mature.

## What changed in beta.29.3.1

This release rolls up the development work since the last published `2.0.0-beta.29.1.0`. Major changes include Gym/Dungeon Lock-In rules, common Route 2/10/20 splits, Running Shoes/QoL cleanup, native collapsible-section glyphs, deterministic split migration, stronger Permadeath reconciliation, Gold starter/provenance hardening, Random Starter presentation fixes, and expanded compatibility for trainer-modifying content.

A major compatibility fix in this release makes **NEXT CAP** displays observe composed trainer parties before battle. Yellow runtime testing with Stronger Trainers confirmed the Trainer Card and Encounter Log now show the modified cap rather than the vanilla value.

Gold remains beta and still needs broader runtime coverage. See `CHANGELOG.md`, `docs/FEATURE_CONFIDENCE.md`, and `docs/TESTING.md` for the detailed state of each feature and remaining release follow-ups.

## What changed in beta.29.2.2

- Adds **Gym Lock-In**: supported Gym exits stay closed until the Leader is defeated.
- Adds conservative **Dungeon Lock-In**: the entrance used to enter a supported multi-exit dungeon is sealed until a different legitimate exit is reached.
- Active Dungeon Lock-In also blocks Escape Rope use without requiring the separate No Escape Rope rule.
- Adds tiered lock-in rejection messages while preserving a plain explanation when optional World Building flavor is OFF.
- Broadens live trainer-roster ace detection for compatibility with nested party/team/roster containers.
- Preserves beta.29.2.1 deterministic encounter re-projection and Gym-Leader Permadeath reconciliation.
- Level Cap Scope **POST** remains the current additional-content/postgame provider option.
- Exact runtime testing is still required before publication.

## Reporting a bug

Please include the Nuzlocke version, Gen1Recomp version, game, save type, relevant rules/preset, other enabled mods when relevant, exact reproduction steps, expected/actual behavior, and whether a full Gen1Recomp restart changes the result.

The repository preview includes structured bug-report and feature-request forms under `.github/ISSUE_TEMPLATE/`.

## Credits

- **bryanthaboi** — original Nuzlocke mod and project baseline.
- **Stone696** — updater of bryanthaboi's original Nuzlocke mod.
- Built for **Gen1Recomp** and its native mod platform.

Pokémon and related names are trademarks of Nintendo / Creatures Inc. / GAME FREAK inc. This fan-made mod contains no ROM.

## 2.0.0-beta.30.0.0.1 randomizer expansion
The RANDOMIZER section now adds **Random Encounters** and **Random Learnsets**. Encounter rolls persist per table slot while preserving native levels, rates, time-of-day/fishing/tree structure, and maps. Learnset rolls persist per species/slot while preserving learn levels and entry counts.

**Learnset Gen**: AUTO uses the active merged move registry; GEN1 uses move indices 1-165; GEN2 uses 166-251. Missing generation data fails open. New paths are **TEST REQUIRED**.

## 2.0.0-beta.30.0.0.2
**No Fishing** is now available under Field Items and is independent from No Catching.

## 2.0.0-beta.30.0.0.3
### Interoperability API v1
FAFF0x/gen1recomp is a first-class compatibility target. Compatibility is capability-first rather than mod-name-first. `mod.exports.nuzlocke` exposes acquisition policy, item policy, effective registries, provider registration, registry notifications, and EXP composition seams.

## 2.0.0-beta.30.0.0.4
### FAFF0x QoL compatibility pass
Interop API v1 now includes alternate-item-UI gates, encounter/acquisition entry points, PC policy, registry revisions, and EXP cap discovery. These are designed for Modern Bag, Item Shortcut, Repel Reuse, Advanced Box, Area DexNav, Summon, Pokédex Plus, Moves Manager, Reusable Machines and EXP Share-style mods without hardcoded mod IDs.

## 2.0.0-beta.30.0.0.5
### Yellow Encounter Tracker removal repair
A legacy-recovery serialization bug dating back to the 29.3.16 path has been repaired. UI-only Pokémon references are no longer stored in `tracker_log`, and contaminated legacy rows are cleaned before serialization.

## 2.0.0-beta.30.0.0.6
### FAFF0x quest/content compatibility
The interop layer now supports dynamic quest maps/areas, provider-defined dungeon families, quest gifts, scripted/repeatable encounters, custom boss metadata, and randomizer opt-outs. `content.registerBundle()` is the preferred one-call integration for quest/content packs.

## 2.0.0-beta.30.0.0.7
### FAFF0x automatic compatibility — 30.0.0.7
Existing mods that predate the Nuzlocke provider API can now be described by a legacy adapter after the active mod graph loads. This bridges common Bag/item, PC, encounter, registry, EXP, quest, and machine behavior families while keeping explicit provider registration authoritative.

## 2.0.0-beta.30.0.0.8
### Compatibility consolidation — 30.0.0.8
Provider compatibility now resolves through canonical mechanic families (`item_provider`, `storage_provider`, `encounter_provider`, `exp_provider`, `registry_consumer`, `quest_content_provider`). Legacy adapter capability names remain supported. Explicit providers are preferred over inferred adapters.

## 2.0.0-beta.30.0.0.9
### External provider UI delegation — 30.0.0.9
Non-core duplicate mechanics no longer compete with an active external provider. Their Nuzlocke row is greyed, effective OFF, and locked, while hover/help text identifies the active provider. Core challenge rules remain Nuzlocke-owned.

## 2.0.0-beta.30.0.0.11
### Gen1Recomp 0.1.84 compatibility checkpoint
30.0.0.11 is intentionally small: it updates the supported engine range so the mod can load on 0.1.84 while preserving the 30.0.0.10 feature state. Runtime testing is still required before 0.1.84 is considered certified.

## 2.0.0-beta.30.0.0.12
### Engine compatibility policy
Starting with 30.0.0.12, the manifest targets the compatible pre-1.0 Gen1Recomp family (`>=0.1.81 <1.0.0`) rather than a single patch window. New 0.x releases are allowed to load unless an actual API/runtime incompatibility is discovered. Unknown future releases are supported-by-range, not automatically runtime-certified.

## 2.0.0-beta.30.0.0.13
### 30.0.0.13 — title setup compatibility
Adds an idempotent fallback for fresh-game Nuzlocke SETUP injection on the current Gen1Recomp 0.1.86–0.1.90 family. The public title-menu hook remains the preferred path; the fallback only repairs a missing row after vanilla construction.

## 2.0.0-beta.30.0.0.14
### 30.0.0.14 — parser hotfix
Repairs the load failure in 30.0.0.13 by isolating its title-menu compatibility helper locals inside a nested function. No intended feature changes.

## 2.0.0-beta.30.0.0.15
### 30.0.0.15 — first approved Lua split
`title_setup_compat.lua` now owns only the fresh-game title SETUP fallback. `main.lua` remains the primary entry point. This split follows Gen1Recomp's sandbox-supported `load(mod:read(...))` multi-file pattern and is intentionally narrow. No further Lua modules will be split without explicit approval.

## 2.0.0-beta.30.0.0.16
### 30.0.0.16 — second approved module split
`trainer_rewards.lua` owns the trainer reward/economy subsystem: Trainer Money scaling, Forgiveness Token mechanics, and Gym/E4/Champion progression bookkeeping. This removes meaningful top-level-local pressure from `main.lua`. No further Lua splitting will occur without explicit approval.

The remaining late runtime-install code is additionally wrapped in an internal nested scope to keep `main.lua` below Lua's compiler-local ceiling without creating more module files.

## 2.0.0-beta.30.0.0.17
### 30.0.0.17 — Permanent Rule Seal confirmation safety
Permanent Rule Seal now requires WARNING 1/2, FINAL WARNING 2/2, and then one final deliberate SEAL activation. Leaving the option or pressing B cancels the confirmation chain. Once finally sealed, the save-level seal remains irreversible by design.

## 2.0.0-beta.30.0.0.18
### 30.0.0.18 — durable Permanent Rule Seal
Permanent Rule Seal now persists immediately through playthrough-scoped storage instead of depending solely on the next ordinary Pokémon SAVE. Only this irreversible marker uses the immediate durable mirror; normal rule settings retain standard save behavior.

## 2.0.0-beta.30.0.0.19
### 30.0.0.19 — Permanent Rule Seal temporarily WIP
Permanent Rule Seal is visible but grey/unselectable, like Wonderlocke. Existing test seals are suspended so normal challenge rules can be edited, while the implementation and underlying historical markers are preserved for a deliberate future re-enable.

## 2.0.0-beta.30.0.0.20
### 30.0.0.20 — dialogue presentation guard
Optional World Building text can no longer nest over an active engine TextBox. This protects vanilla dialogue transactions from Nuzlocke cosmetic interruptions and targets the recurring repeated/overlapping text-page regression reported in Yellow.

## 2.0.0-beta.30.0.0.21
### 30.0.0.21 — percentage labels and Maximum BST presets
Trainer Money and other percentage-based presentation now retain `%` consistently. Maximum BST now offers OFF / 400 / 450 / 500 / 550 rather than arbitrary 000–999 editing.

## 2.0.0-beta.30.1.0

The 30.1.0 beta promotes the current Gen1Recomp 0.1.86+ compatibility line after successful Yellow runtime testing.

Runtime-confirmed Yellow behavior includes existing-save boot/menu access, opening Nuz Rules, the tested Gym Lock-In boundary rejection, and successful non-reproduction of the recurring duplicate-page bug on the specific Poké Mart NPC used for testing.

A key protected presentation rule now applies throughout future development: **optional Nuzlocke World Building text must not be pushed over an already-active TextBox.** This guard fixed the tested recurring overlap/repeated-phrase case and should be reused when similar dialogue bugs appear elsewhere.

Permanent Rule Seal remains WIP and unselectable. Maximum BST uses OFF/400/450/500/550 presets. The approved Lua structure remains limited to `main.lua`, `title_setup_compat.lua`, and `trainer_rewards.lua`.

## 2.0.0-beta.30.1.1

This is the corrected release candidate after a Gold NEW GAME -> SETUP runtime crash in 30.1.0.

Gold now relies only on the older shared title-menu injection + `MainMenu:choose()` adapter that existed in the last published runtime-PASS line. The newer Gold `buildList()` fallback is disabled and preserved in comments for later investigation.

No other Gold systems were rolled back.

## 2.0.0-beta.30.1.2

> **Gold beta warning:** fresh Gold NEW GAME currently has a known crash when selecting the Nuzlocke **SETUP** entry. Gold remains experimental and that startup configuration path is not considered functional in this release.

This release otherwise preserves the current 30.x feature and compatibility line. Yellow runtime testing confirms existing-save boot/menu access, Nuz Rules, the tested Gym Lock-In boundary rejection, and the specific duplicate-dialogue regression case used during testing.

Permanent Rule Seal remains WIP/unselectable. The active-TextBox World Building guard remains a protected presentation safeguard. Maximum BST uses OFF/400/450/500/550 presets.

## 2.0.0-beta.30.1.3 diagnostic

Setup and Nuz Rules now use a guarded screen opener. A failing configuration screen should report its underlying error in-game rather than crash to desktop.

The current main chunk is also confirmed to be at Lua's top-level local-variable ceiling: adding one more local made the compiler reject it. No additional split is made in this build; that structural work should be deliberate and separately runtime-tested.

## 2.0.0-beta.30.1.4 diagnostic

The configuration screen now guards both construction and runtime frames. If Setup still fails due to Lua code, the error should be surfaced in-game instead of becoming an opaque desktop crash.

## 2.0.0-beta.30.1.5 — Setup sandbox compatibility fix

Fresh-game Setup no longer touches the legacy filesystem facade blocked by the current Gen1Recomp mod sandbox. Setup preferences are kept separately for Gen1 and Gold for the current process/session.

Fresh Yellow and Gold NEW GAME -> SETUP remain RETEST REQUIRED.

## 2.0.0-beta.30.1.6

Current-engine fresh Setup compatibility has been runtime validated:

- Gold fresh Setup: **PASS**
- Yellow fresh Setup: **PASS**
- Blue fresh NEW GAME bedroom entry: **PASS**

The prior Setup CTD was caused by legacy direct filesystem access in pre-game Setup-profile persistence. Current Gen1Recomp blocks that facade for sandboxed mods. The Setup preference layer is now session-local.

**Temporary limitation:** fully restarting Gen1Recomp resets pre-game Setup preferences to defaults. Rules committed to an actual save keep their normal persistence.

Gold remains beta/experimental overall. Permanent Rule Seal remains WIP/unselectable.

## 2.0.0-beta.30.1.7 — Gold Pokégear integration

With active `pokegear_cards` API v1 on Gold:
- **NUZ card:** run status, encounters, rules, caps/difficulty.
- **MAP:** Nuzlocke landmark encounter-state markers.
- **RADIO:** tiered Nuzlocke World Building/status overlay.
- **PHONE:** intentionally unchanged.

The provider is optional. Missing/disabled/wrong-version Pokegear Cards leaves the existing Nuzlocke UI intact. No mechanical Nuzlocke rule depends on this integration.

## 2.0.0-beta.30.1.8

Provider delegation hardening:

- Trainer Money runtime enforcement now respects an active `economy_provider`.
- Delegated Trainer Money leaves the external provider's final payout untouched.
- Delegated numeric controls now support an explicit neutral value.
- Trainer Money's delegated display is **100%** rather than the misleading **0%**.

No unrelated gameplay behavior was intentionally changed from 30.1.7.

## 2.0.0-beta.30.1.9

Gold fallback level-cap progression now restores the previously intended monotonic mid-game order:

**Chuck 30 -> Pryce 31 -> Jasmine 35 -> Clair 40**

This changes only the ordered cap-progression stage list. Gold badge identities/slots remain unchanged.

No unrelated gameplay behavior was intentionally changed from 30.1.8.

## 2.0.0-beta.30.1.10

Title Setup compatibility fallback now treats save-editor state as dynamic session state:

- install-time editor guard retained;
- per-title-open editor guard added;
- SETUP is not injected into later save-editor title sessions by a previously installed wrapper.

No package files were added or removed.

## 2.0.0-beta.30.1.11

Route Forgiveness split-module repair:

- fixes Gold Standard Mart construction using an undefined bare `forgivenessEnabled()` call;
- fixes the Route Forgiveness status label using an undefined bare `forgivenessTokens()` call;
- both now use `mod.exports.__beta26.TrainerRewards`.

No package files were added or removed.

## 2.0.0-beta.30.1.12

Stored catch recovery is hardened:
- empty valid area -> restores normally;
- matching existing entry -> registers normally;
- conflicting occupied area -> stale location cleared and mon remains Legacy-Recovery eligible.

No unrelated behavior was intentionally changed.

## 2.0.0-beta.30.1.13

Solo Only now consistently covers scripted non-wild acquisitions:

- gifts: already enforced;
- NPC trades: now enforced too;
- wild catches: existing catch-time enforcement unchanged.

No package files were added or removed.

## 2.0.0-beta.30.1.14

First Rival Mercy now latches only on the real opening Rival battle.

- later/non-opening Rival: no mercy, no one-shot consumption;
- actual opener: consumes the one-shot;
- actual opener with Mercy ON: forgiveness arms;
- actual opener with Mercy OFF: slot is still consumed as intended.

No unrelated behavior was intentionally changed.

## 2.0.0-beta.30.1.15

World Building tier consistency fix:

- `queueTrainerFlavor` now carries its requested minimum tier through its fallback path;
- First Rival Mercy can therefore show its intended Tier 1/2 notice even when the battle object lacks `say`/`emit`;
- ordinary `worldOnce` callers still default to Tier 3.

No unrelated gameplay behavior was intentionally changed.

## 2.0.0-beta.30.1.16

Type Locke now recognizes the canonical **FAIRY** type.

- Fairy Monolocke / Fairy Duolocke selections are supported.
- Pure Fairy Pokémon no longer fall through the unknown-type fail-open path.
- Dual types such as Water/Fairy match either selected type normally.
- RANDOM includes Fairy only when represented in the live merged species pool.
- Save compatibility is preserved: selector `17` is still RANDOM; FAIRY is appended at `18`.

This compatibility is generic and does not require a hard dependency on a specific typing mod.

## 2.0.0-beta.30.1.17

R/B/Y Mart enforcement is now translation-safe.

- No Buying recognizes translated BUY labels.
- No Selling recognizes translated SELL labels.
- English behavior remains unchanged.
- Gold's semantic Mart enforcement is unchanged.

This was found while reviewing the Suomi/Finnish translation mod.

## 2.0.0-beta.30.1.18

### Optional Modern UI integration

Nuzlocke now exposes responsive semantic models for:
- Encounter Tracker / Area Guide
- NUZ INFO
- Trainer Card / Nuzlocke status

The integration is optional and Gen1-only. Native screens remain the fallback.

The rule editor and fresh Setup remain native in this build to protect their more complex interaction/state paths.


### Game Difficulty audit history — 2.2.11
2.2.11 established real trainer level/Stat EXP/DV ownership but intentionally stopped short of claiming teams, movesets, or AI. That audit state is superseded by the 2.2.12 implementation below; the historical `*` profiles remain inspired approximations rather than exact ROM-hack trainer-table reproductions.


### Built-in difficulty profiles — 2.2.12
Built-in profiles now transform the **live composed trainer party** rather than replacing trainer registries. Depending on profile, they can scale ordinary and boss levels separately, deterministically strengthen/diversify team species within the original species' type family, rebuild stronger movesets from the active merged level-up/TM move data, enable native trainer-AI layers, apply profile Stat EXP/perfect DVs, and add Gold held items only when another provider did not already assign one. SHIN-derived profiles and POLISHED* also disable player badge battle boosts, matching that difficulty characteristic without deleting owned badges. Rival species are preserved so starter/story identity is never rewritten. Roster slot count/order is preserved; only eligible species inside existing slots are upgraded. Historical names marked `*` remain inspired profiles rather than byte-identical ROM-hack tables. External difficulty providers are untouched when selected. Physical/Special Split remains an independent Battle Mechanics toggle and is never forced by a difficulty profile.

Trainer creation ownership is exclusive: VANILLA may use the separate Nuzlocke Trainer Stat EXP/DV controls; built-in Difficulty profiles use their own values; selected external difficulty providers are not rewritten by either built-in profile stats or Nuzlocke trainer-start stat rules.


## Gen 2 Randomizer+ v2.6 compatibility — 2.2.14

Nuzlocke now source-adapts the Gold-only `gen_2_randomizer_plus` mod when its
source-confirmed live settings own an overlapping mechanic. Random Starters,
Random Wild Pokemon, and Random Learnset delegate only while the corresponding
Randomizer+ toggle is actually ON; merely installing the mod does not disable
Nuzlocke controls. When Randomizer+ owns wild randomization, Nuzlocke leaves the
encounter randomization itself to that mod but continues to own challenge
policy: encounter limits, Failed Encounters, Dupes, type locks, capture legality,
tracker history, and catch provenance. Tracker entries record Randomizer+ as the
encounter provider when that delegation is active.

The v2.6 release notes additionally state that Randomizer+ can synchronize
Wilds of Kanto visible overworld Pokemon with the Pokemon actually battled while
preserving encounter levels. Nuzlocke intentionally consumes the final battle/
capture identity and does not attempt to rerandomize or predict the visible
spawn.
