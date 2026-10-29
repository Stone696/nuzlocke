## 3.0.3-beta — Manual starter rerolls and companion integration guidance

- Starter Rerolls is now a player-driven allowance: **OFF / 1 / 3 / 5 / UNLIMITED** replaces the old automatic best-of-three/five starter balancing selection. Starter Balance **CHAOS / SIM BST** remains a separate setting.
- In Ruby/Sapphire/Emerald, press **SELECT** while viewing the starter bag to generate a new legal trio. In FireRed/LeafGreen, use **NUZ RULES → RANDOMIZER → REROLL STARTERS NOW** while in Oak's lab before accepting a starter.
- Each reroll preserves the configured seed and other randomised mappings; the resulting three distinct species and reroll usage are saved. Reroll counts cannot be exhausted by backing out of the selection screen or reloading a save.
- Rivals continue to follow the currently selected starter slot and native evolutionary progression. Legacy beta starter trios are preserved rather than silently regenerated; unavailable new alternatives do not consume the allowance.
- Documented the **separate Untamed Advanced integration** with Modern Spawns' COMPLETE/RANDOM per-visible-spawn pools. This lives in the companion Untamed Advanced mod; no new runtime dependency or cross-mod certification is claimed in the Nuzlocke release.
- Added manual-reroll regression coverage. Combined provider/load-order behaviour and all five Gen 3 ROM editions remain subject to manual testing.
- Gen 1/2 gameplay, Gen 3 save namespace `gen3_classic_v1`, and Mod API 2 remain unchanged.

## 3.0.2-beta — Expanded National Dex, form-aware results and Mod Support

- Optional National Dex Gen 3 API-v2 roster expands supported Gen 3 randomisation from the original 386 Pokémon to registered base species through #1025, with generation filters, opt-in alternate forms, and deterministic seed behaviour.
- Advanced individual-species bans and supported extended-species classification follow the installed National Dex provider while preserving vanilla run compatibility when it is absent.
- End Run artwork, shiny sprites, party and memorial snapshots resolve provider artwork using the saved extended engine species identity and preserve safe native fallbacks for older/unknown shiny records.
- Graveyard, encounter tracker and final results display supported National Dex and regional-form names, including existing archive records, without rewriting saved species identities or nicknames.
- Mod Support now distinguishes installed companion mods, public API readiness, optional active status and **not-verified** combined runtime for Untamed Advanced, National Dex Gen 3, G9 Battle Sprites, Modern Spawns and Gen 3 HD Sprites.
- Added Lua regression coverage for expanded rosters, form-name resolution, results-artwork selection and safe read-only Mod Support detection. Documentation and manual multi-mod testing checklist updated.
- No new mandatory dependencies, save schema, public Mod API or Mega/Gigantamax mechanics. Manual Gen 3 ROM and six-mod combined validation remain required.

## 3.0.1-beta — Gen 3 beta release polish and clean player distribution

- Refined the Generation 3-facing README, player description, release notes and credit attribution. The existing v3.0.0-BETA feature implementation and historical 2.9.x entries are retained below.
- Replaced the oversized source-tree release archive with a verified **runtime-only, reproducible ZIP** that excludes development smokes, workflows and historical documentation while retaining all Gen 1/2 and Gen 3 runtime files.
- Simplified Gen 3 CI by automatically discovering separate Lua smoke cases; retired obsolete Gen 1-only packaging assumptions without removing those source files.
- Added 240×160 player-menu text wrapping, improved scrolling test coverage and more accurate resolved-area labels.
- Made subsequent release publication deliberate, version-checked and backed by curated notes, with no unexpected auto-publication for normal merges.
- No new gameplay rules are claimed in this packaging follow-up; see v3.0.0-BETA below for the original Gen 3 feature port and [feature matrix](docs/GEN3_FEATURE_MATRIX.md) for the full list.
- **Beta limitation:** in-game edition/provider certification remains separate from automated Lua tests.

## 3.0.0-BETA — Generation 3 compatibility and features

**First Generation 3 beta release:** FireRed, LeafGreen, Ruby, Sapphire and Emerald. Adds a separate native Game3 implementation and `gen3_classic_v1` state while preserving the Gen 1/2 runtime, save schema, Mod API 2 and pre-3.0 release history.

### Ported from Generation 1/2

- CORE: Permadeath, One Encounter Per Area, Failed Encounters, Nickname Requirement, First Rival Mercy, Whiteout Ends Run and PC Survivors.
- CLAUSES: Dupes, Shiny Catch Exception/Rate, Roamer, Egg Encounter and Route Forgiveness token redemption.
- LEVELS, HARDCORE, GAME DIFFICULTY and RUN/PARTY: cap scopes, EXP Edging, SET and other battle restrictions, party/evolution limits and difficulty settings.
- ADVANCED RULES: species/capture bans, gifts/trades, Colorlocke/Alphabetlocke, Type Locke/Catch Draft, OHKO/Battle Clauses, Status Bans/Sleep Clause, Battle Items, Field Items, Services & Economy, Pokémon Stats and Gen 3 Area Splits.
- QOL: Instant Text, Run/Surf, bag limits and trade-evolution options.
- Seeded Randomiser: starter, wild, static, gift/Egg, trainer, field/gift-item, shop, TM, learnset and evolution pools with generation/BST/options as supported by Gen 3 hooks.

### Adapted for native Gen 3

- Implemented Game3 encounter/acquisition, battle, item/PP/TM, move, scripted gift/NPC trade, progression and PC-storage hooks, applying legality checks before native mutations where supported.
- First encounters do not count until the player can obtain Pokémon; native Ball access establishes the durable catch-unlock boundary.
- Native battle-copy writeback, graveyard archives and survivor rescue handle Permadeath and whiteout without deleting native game saves or patching the base engine.
- Shiny integration retains Gen 3 individual identity, native PC/party mini-icons and ROM shiny portraits where supported; other verified shiny providers retain rate ownership.
- GBA-native 240×160 menus use implemented-status controls, scoped descriptions and readable species/area names.

### New v3 Gen 3 functionality

- Shiny Nuzlocke and Hardcore Nuzlocke playstyles (may combine); NEW RUN SETUP and LOCK FOR RUN; native starting items and PC loadouts with deferred Balls.
- Untamed-Advanced visible overworld spawn integration, preserving matching sprite/battle/capture species and respecting scripted special exclusions.
- RUN JOURNAL merges status, Graveyard/Tracker shortcuts and retained rule-event history, replacing duplicate Almanac and NUZ NOTICES screens.
- Native End Run/Champion/failure final-results experience and shareable full-team/graveyard/stats poster with shiny identification.
- Read-only MOD SUPPORT replaces an unsafe/unimplemented manual Gen 3 compatibility ownership placeholder.
- Hidden production Nuz Dev access (Select held + A) and audited full-archive Pokémon restoration for developer testing. It never unlocks a terminal run.
- Removed the unimplemented Wonderlocke entry and the redundant Overworld Encounters toggle from the Gen 3 rules catalogue.
- Added policy/native-smoke and menu regression coverage, with manual FireRed/LeafGreen/Ruby/Sapphire/Emerald checks maintained separately.

### Scope, safety and authorship

- Ordinary Route Forgiveness Pokémon revival is still not implemented; full-archive restoration is developer-only. Some non-catch nickname eligibility and third-party scripted gifts/trades still require further verification.
- Passing automated tests is not proof of exact-ROM or third-party mod compatibility; v3 remains explicitly **BETA**.
- Earlier Gen 1/2 contributors and the original Shiny Pokémon lineage retain credits: **bryanthaboi**, **Stone696**, **masterwebx**. **Deluxe0111** is credited for the Gen 3 port and new features. See [CREDITS.md](CREDITS.md).
- For a feature-by-feature categorisation, see [Gen 3 feature matrix](docs/GEN3_FEATURE_MATRIX.md), [release notes](RELEASE_NOTES.md) and [manual test checklist](docs/GEN3_TEST_CHECKLIST.md).

## 2.9.73 — Historical pre-v3 new-game setup update

Published on **28 October 2026**, before the `v3.0.0-BETA` release. Recorded from the published v2.9.73 GitHub release; this is **not** a retroactive claim that the final Gen 3 beta or its later rules shipped in 2.9.73.

- Extended the early Gen 3 new-game-only QoL setup and selection of native PC resources/loadouts, with updated preset labels.
- Fixed deferred starting Poké Ball delivery after the native catch-unlock boundary, including when the player's current Ball inventory is empty.
- Applied the setup resources to the native `save.created` event before the live `game.session` is attached.
- Added isolated native PC storage and catching-unlock tests and documentation for edition-specific startup cases.

## 2.9.72

- Normalizes Gen-II numeric item operands through the active item registry before Random Field Item classification, TM detection, persistence identity, and selection, then converts the chosen canonical item back to the native numeric index required by Gen-II pickup builders.
- Prevents Random Shops from selecting the authored item when at least one legal alternative exists; preserves the original only when no legal replacement is available.
- Adds read-only shop traces and item-normalization evidence to bug-report diagnostics.
- Adds a unified Random Trainer trace spanning enabled/delegation state, authored/composed roster, primary projection, finalizer output, and battle-accepted roster. No additional RNG is consumed.
- Repairs a shiny-presentation isolation defect: Nuzlocke no longer recolors the ImageData returned by the engine asset cache in place. Shiny art is generated from a private copy, preventing palette bleed into unrelated Pokemon/menu surfaces.
- Adds party shiny-identity and last sprite/icon projection evidence to the SHINY Dev page and bug-report snapshot.
- No other-mod delegation is required for these fixes; runtime evidence supplied for this investigation used Nuzlocke as the only installed mod.
- No Save Schema, Compatibility API, Diagnostics API, Translation API, UI contract, or Randomizer algorithm version bump. Runtime retest is required before PASS promotion.

## 2.9.71

- Repairs the Yellow/Gen-I Random Field Items runtime failure observed on 2.9.70 with Gen1Recomp 0.2.41.
- Moves the primary R/B/Y visible-item composition seam from direct `OverworldController.talkTo` method ownership to Gen1Recomp's public `world.talk` hook, which runs immediately before the native talk/pickup handler consumes the item payload.
- Preserves native bag-capacity checks, pickup removal/taken flags, item-name text, sounds, and retry behavior by temporarily projecting only the deterministic replacement item during the downstream call and restoring the authored object definition afterward.
- Adds explicit R/B/Y Random Field Item pipeline diagnostics and hook-health reporting for the `world.talk` registration.
- Updates Randomizer visible-source metadata and compatibility seam metadata to identify `world.talk` as the Gen-I visible-field-item owner boundary.
- Retires the legacy direct `OverworldController.talkTo` path from normal Gen-I field-item installation. Because `world.talk` is present at the supported 0.2.24+ floor, a missing hook facade now fails closed and is reported by Dev diagnostics instead of silently falling back to the fragile direct wrapper.
- Keeps Yellow 2.9.70 Random Field Items recorded as Runtime FAIL. 2.9.71 remains un-certified until exact-edition retest.
- Preserves the Gen1Recomp 0.2.41 source-review baseline.
- No Nuzlocke Save Schema, Compatibility API, Diagnostics API, Translation API, UI contract, or Randomizer algorithm version bump.
- No Runtime PASS is promoted by static/package validation.

## 2.9.70

- Advances the Gen1Recomp source-review baseline from 0.2.40 to 0.2.41 release commit `3d3a9ba4b66832b8c70ac26e1e88dbae612efcd0`.
- Confirms upstream Mod API 2, Link Protocol 2, Save Format 5, and ROM cache v5 remain unchanged.
- Reviews the 0.2.41 platform/launcher expansion, FixedStep/PresentSync pacing hardening, and Gen-II save-export map-context changes; no Nuzlocke-critical public mod contract break was found.
- Keeps FixedStep, PresentSync, VSync, FrameCap and presentation pacing engine-owned and read-only from Nuzlocke.
- Fixes `normalizedInputPolicy` so an invalid/misspelled profile reports the actually resolved fallback profile (`navigation`) instead of returning contradictory profile metadata.
- Adds Release Safety guards for the 0.2.41 engine profile and consistent input-profile resolution.
- Preserves the 2.9.69 conditional-authority fix, 2.9.68 `Typography.centerX` repair, and 2.9.67 Dev Report dependency repair.
- No Nuzlocke Save Schema, Compatibility API, Diagnostics API, Translation API, Run History, Randomizer algorithm, or UI contract-version bump.
- No Runtime PASS is promoted by source/static/package validation.

## 2.9.69

- Fixes conditional presentation/gameplay ownership semantics: `presentationOwnsGameplay("trainer_party")` no longer treats the descriptor `nuzlocke_randomizer_when_enabled` as unconditional ownership.
- Adds `gameplayAuthorityFor(surface)` so integrations can read the descriptive authority value without coercing it to a boolean.
- Repairs the stale `ui_input_contract_version` Release Safety test by checking the feature-scoped `inputContractVersion = 1` rather than pinning the shared UI API counter to obsolete version 7.
- Adds a regression guard preserving conditional gameplay-authority semantics.
- Preserves the 2.9.68 `Typography.centerX` repair and 2.9.67 Dev Report dependency repair.
- No gameplay-rule, save-schema, Compatibility API, UI contract-version, Randomizer algorithm, or compatibility-target bump.
- No Runtime PASS is promoted by static/package validation.

## 2.9.68

- Fixes the Gen-II/Gold utility-screen draw crash at `classic_ui.lua:6568` where the shared typography object lacked the `centerX` helper used by centered Nuzlocke titles.
- Adds `Typography.centerX(text, leftEdge, rightEdge)` to the existing Nuzlocke UI typography contract.
- Adds Release Safety coverage tying the ClassicUI `T.centerX(...)` consumer to the helper definition.
- Preserves the 2.9.67 Dev Report dependency repair, 2.9.66 UI input/presentation contracts, HGSS compatibility target, gameplay rules, save schema, Compatibility API, and Randomizer behavior.
- Runtime evidence remains granular: the reported Gen-II draw crash is a separate UI defect from the earlier Dev Report dependency failure.
- No Runtime PASS is promoted until the affected Gold/Gen-II screen and Dev Report are reopened on 2.9.68.

## 2.9.67

- Fixes the Yellow runtime Dev Report crash at `dev_diagnostics.lua:2448` where `compatPublicCopy` was resolved as a nonexistent global.
- Restores explicit split-safe ownership by injecting `compatPublicCopy` from `main.lua` into `dev_diagnostics.lua` and asserting that dependency at module registration.
- Adds a Release Safety guard so the Dev Report compatibility projection cannot regress to an accidental `_ENV` lookup.
- Preserves the 2.9.66 UI presentation/input contracts, HGSS compatibility target, gameplay rules, save schema, Compatibility API, Randomizer algorithm, and all unrelated behavior.
- Yellow 2.9.66 runtime evidence retained: game load PASS and ABANDON RUN flow PASS; Dev Report FAIL is isolated to this diagnostic dependency defect.
- No Runtime PASS is promoted for 2.9.67 until the Dev Report is reopened on the repaired build.

## 2.9.66

- Adds UI presentation-ownership contract v1 and advances the Nuzlocke presentation UI API to v8.
- Makes Party, PC, Pokédex, Bag, Mart, battle art/HUD, overworld rendering, generic ListMenu composition, Nuzlocke-owned screens, and trainer-party presentation/controller boundaries machine-readable.
- Adds HGSS Visual Overhaul 1.0.2 (`HGSS_SPRITES`) as an explicit Yellow compatibility target and optional dependency.
- Source review preserves HGSS ownership of presentation while Nuzlocke keeps challenge legality, provenance/tracker state, gameplay transactions, and Random Trainer party authority when enabled.
- Hardens the Gen-I `BattleState.newTrainer` wrapper contract so Nuzlocke explicitly supports being inside or outside a presentation wrapper chain; Nuzlocke calls its captured prior implementation exactly once on every constructor path and does not require itself to remain outermost.
- Adds read-only trainer-wrapper chain health diagnostics and Release Safety guards for the new presentation and shared-wrapper contracts.
- No save schema, Compatibility API, Diagnostics API, Translation API, Randomizer algorithm, or gameplay-rule behavior change.
- No Runtime PASS is promoted by source/static/package validation.

## 2.9.65

- Adds Nuzlocke UI input-contract v1 and advances the presentation UI API to v7.
- Every known Nuzlocke-owned screen now has an explicit semantic input policy: repeat-safe navigation/value stepping where appropriate, edge-only activation/back, and a separate destructive-confirmation classification.
- Adds query helpers for input-aware integrations: `inputPolicyFor`, `isRepeatSafe`, `requiresEdge`, `isDestructive`, and `applyInputContract`.
- Keeps the contract descriptive only: Nuzlocke does not synthesize repeats, wrap global input, or take ownership from the engine or accessibility/input-repeat mods.
- Documents WizzStar HoldToScrollUI 1.1.0 as a reviewed compatibility target by repository/release behavior; combined runtime testing and package-source review remain separate.
- Adds Release Safety checks for the input-contract version, repeat/edge semantics, destructive confirmation, and presentation-only boundary.
- No gameplay rule, save schema, Compatibility API, Diagnostics API, Translation API, Randomizer algorithm, or deferred Encounter Log / Area Log presentation change.

## 2.9.64

- Refreshes current voxel/presentation compatibility targets: Dramatic Shape 1.9.0, Battle Art Voxel Fork 1.10.0, and Battle Cinematics 1.2.4.
- Keeps PotatoVoxel 1.9.6, Voxel Ascendant 2.0.2, Terrarium 1.27.0-mobile, Dramaless Shape 2.0.3, and Flying Overhaul 1.2.1 at their already-current reviewed versions.
- Treats the active voxel renderers as distinct mutually exclusive presentation owners rather than interchangeable aliases; Nuzlocke continues to retain challenge legality/state while yielding renderer/camera ownership.
- Reconciles stale current-document references to the older Dramatic Shape 1.0.6 target.
- Adds Release Safety exact-target checks for the refreshed Dramatic Shape, Battle Art, and Battle Cinematics versions.
- No gameplay-rule, save-schema, compatibility-API, Randomizer-algorithm, or deferred Encounter Log / Area Log presentation changes.

## 2.9.63

- Fixed the remaining release-blocking ClassicUI split-safety load failure by exporting the tracker-owned `legacyCandidates` function and explicitly binding it before ClassicUI registration.
- Expanded Release Safety dependency coverage so required ClassicUI injections are checked as a set instead of surfacing one missing dependency at runtime.
- Restored World Building tiered/region-specific denial text for `no_healing_items` and `no_battle_items` while preserving battle/bag decision metadata.
- Advanced Gen1Recomp source/documentation compatibility review through 0.2.40. Mod API 2, upstream Save Format 5, and the accepted engine range remain unchanged; focused runtime revalidation remains required.
- No save-schema, compatibility-API, Randomizer algorithm, or Encounter Log / Area Log presentation changes.

## 2.9.62

- Fixed a release-blocking split-safety regression where `classic_ui.lua` and `late_runtime.lua` required the Gen-I tracker seed-ID table but `main.lua` passed an undefined global instead of the tracker-owned table.
- `encounter_tracker.lua` now explicitly exports its stable `GEN1_SEED_IDS` table and `main.lua` binds that export before either consumer is registered.
- Added a Release Safety dependency audit to prevent this captured-before-owner/accidental-global failure from recurring.
- No gameplay rules, Randomizer algorithms, save schema, compatibility API, or deferred Encounter Log / Area Log presentation were changed.

## 2.9.62

- Fixed the release-blocking Gen-I load regression where `classic_ui.lua` and `late_runtime.lua` were injected an unresolved `GEN1_SEED_IDS` dependency.
- Restored explicit ownership by exporting the stable seeded-area identity table from `encounter_tracker.lua` and binding it in `main.lua` before dependent module registration.
- Added Release Safety guards for the owner export and registration-order dependency.
- No gameplay, Randomizer algorithm, save schema, compatibility API, or tracker presentation changes.

## 2.9.61

- Fixed Gen I Randomizer Evolution Balance labels so DEPTH/SIM BST/BALANCED render semantically instead of as raw numeric values.
- Fixed setup preset load warnings by comparing normalized profiles and showing semantic rule values.
- Fixed F. Token status reporting to resolve against the active game/save context.
- Corrected randomized starter history provenance so starters are identified as STARTER rather than ordinary catches/gifts.
- Updated Almanac randomizer status to report the live enabled feature state and clarified ambiguous summary labels.
- Fixed NUZ MENU overflow with a scrolling viewport; MOD COMPAT and optional DEV TOOLS now precede END RUN, which remains the final destructive action.
- Fixed END RUN/ABANDON selection by wiring Nuzlocke-owned ListMenu actions through the engine menu callback contract and restored framed presentation.
- Corrected battle item denial copy so battle healing/X-item restrictions remain battle-specific at every World Building tier; removed the misleading Gym Guide attribution from field Rare Candy denial text.
- Deferred the encounter/area log presentation cleanup for a later focused pass; no tracker layout rewrite is included here.

## 2.9.60

- Fully reviewed Gen1Recomp 0.2.39 source and current modding/Gen-II API documentation.
- Advanced the source/documentation compatibility baseline to release commit `f90c3370e8c2a2116dbe31201af6adc2dea46471`.
- Added the 0.2.39 compatibility profile; Mod API 2, upstream Save Format 5, and the existing engine range remain unchanged.
- Classified the new PresentSync/PresentProbe, VSync, FrameCap, and FixedStep presentation-pacing subsystem as engine-owned.
- Added a read-only PresentSync diagnostic snapshot without taking pacing ownership.
- Added Release Safety tripwires preventing Nuzlocke from applying frame caps, VSync, FixedStep refresh periods, present waits, probe resets/reprobes, or software sleeps.
- Revalidated the Gen-II shared API model and the native HiddenItems pickup signatures used by Random Field Items.
- Gen-II Random Field Items remains unresolved; 0.2.39 does not supply evidence of a signature mismatch.
- Corrected the current README package count to 37 files.
- No Save Schema, Compatibility API, Randomizer algorithm, or Runtime PASS changes.

## 2.9.59

- Advanced explicit Shiny Pokemon compatibility review from Stone fork 1.2.20 to supplied 1.2.41.
- Added additive consumption of Shiny 1.2.41 Nuzlocke integration validation when available, with legacy fallback preserved.
- Added provider lifecycle fingerprints and stale-evidence tracking across provider handle, exports, registration, hook identity, value, and version.
- Added cross-project Shiny audit-freshness metadata; newer Shiny versions require a new review before the recorded baseline advances.
- Added reviewed voxel/3D coexistence targets from the Shiny 1.2.41 matrix, including Battle Art Voxel Fork, Voxel Ascendant, Terrarium, Dramaless Shape, Battle Cinematics, 3D Pokedex, Flying Overhaul, Dynamic Weather, and Dramatic Sky Ride; Dramatic Shape target advanced to 1.8.1.
- Added conservative provider-owned shiny-source policy so explicitly provider-owned voxel/overworld source contexts do not receive a second Nuzlocke recolor bake.
- Added machine-readable compatibility seam registry covering public/provider seams and retained bounded direct shiny seams.
- Added release gates for Shiny 1.2.41 target/freshness, provider fingerprints, integration validation, source ownership, seam registration, shiny configuration defaults, and mod-local loader classification.
- No shiny odds, Save Schema, public Compatibility API, or Runtime PASS changes.
- Gen-II Random Field Items remain unchanged.

## 2.9.58

- Fixed Random Trainers calling an out-of-scope `effectiveRandomSpeciesGeneration`, which could resolve as a nil global at runtime.
- Fixed two Randomizer diagnostic fields to use the canonical `Randomizer.algorithmVersion`.
- Fixed AUTO compatibility ownership so it can skip an inactive first provider and select the next live candidate.
- Fixed Gen-II NUZ STATUS rule rendering to resolve the live game before shiny/Colorlocke/Alphabetlocke status projection.
- Added focused regression audits for trainer scope, AUTO provider fallback, and Gen-II live-game status resolution.
- Random Field Items behavior is unchanged pending runtime evidence.
- No save-schema, compatibility API, diagnostics API, translation API, or Runtime PASS change.

## 2.9.57

- Fixed the PokemonIdentity future-save-schema mutation guard by threading `saveSchemaTooNew` through a live getter.
- Added owner-aware Release Safety source routing and reconciled moved World Building, Forgiveness, compatibility, and DEV diagnostic checks.
- Added source-owner readability and PokemonIdentity future-schema guard regression checks.
- No gameplay feature, save-schema, public API, or Runtime PASS change.

# Changelog
- Expands Gen 3 **ADVANCED RULES → CATCH RULES** with Town Catches (native FR/RU/SA/EM settlement-map classification), Alphabetlocke OFF/RANDOM/CHOOSE with a persisted represented A–Z letter, and Allow Glitches (blocks malformed/unregistered wild species unless explicitly enabled). Adds menu selectors, encounter-source checks, ROM test cases and policy regression coverage.

## 2.9.57

- Added `evolution_policy.lua` as the dedicated owner for Evolution Limits and Trade Evolution QoL over `evolution.check`.
- Preserved Randomizer evolution mappings, UI/config, identity/provenance, and acquisition policy under their existing owners.
- Advanced the protected player package to 37 files / 27 Lua modules plus `mod.card`.
- Paused further consolidation/relocation work after this build by user direction.
- No save-schema, public API, Randomizer-algorithm, or Runtime PASS change.

## 2.9.55

- Strict child of exact packaged 2.9.54 (`f78967b861507c8a90967a8689fc54f3b51021bfb5315336b2075e43ec2bb186`).
- Added `item_policy.lua` as the dedicated owner for shared item-use classification/legality, denial presentation, and ItemEffects/field-action guard installation.
- Kept No Buying/No Selling compatibility policy, battle fallback orchestration, Difficulty, and unrelated challenge enforcement outside the module.
- Preserved live current-game/current-save resolution across the module boundary and retained the existing `ItemPolicy` / `evaluateItemUsePolicy` call surfaces in `main.lua`.
- Intentionally advanced the protected package contract to 36 files / 26 Lua modules plus `mod.card`.
- Save Schema 5, Compatibility API 37, Diagnostics API 1, Translation API 2, Run History v2, and Randomizer algorithm v1 are unchanged. No new Runtime PASS is claimed.

## 2.9.54

- Added `species_policy.lua` as the dedicated owner for Type/Color/Alphabet Locke species policy, glitch classification, BST/species facts, and legendary/mythical/pseudo challenge classification.
- Preserved Pokémon instance identity/provenance, tracker state, shiny generation/presentation, Randomizer mappings, and acquisition enforcement outside species-policy ownership.
- Passed current-game, game-version, and category catalogs through live getters; focused harness passed Type Locke, BST/glitch, canonical Colorlocke, and late catalog resolution.
- Repaired inherited build-provenance package-count drift by advancing `player_package_files` from stale 31 to the actual 35-file contract.
- Intentionally advanced the protected package contract to 35 files / 25 Lua modules plus `mod.card`.
- No Save Schema/API/Randomizer version or Runtime PASS changed.

## 2.9.53

- Added `encounter_tracker.lua` as the dedicated owner for area catalogs, encounter-area projection, tracker persistence, legacy catch recovery, and save reconstruction.
- Consumes the stable `pokemon_identity.lua` service for persistent IDs/provenance instead of duplicating identity behavior.
- Late-bound current game, display-route, and game-version dependencies cross the module boundary through explicit getters.
- Intentionally advanced the protected package contract to 34 files / 24 Lua modules plus `mod.card`.
- No Save Schema/API/Randomizer version or Runtime PASS changed.


## 2.9.52

- Added `pokemon_identity.lua` as the dedicated owner for stable Pokemon instance identity, species-definition/provider metadata lookup, persistent IDs, origin/baseline state, and provenance initialization.
- Preserved Type/Color/Alphabet Locke policy, shiny generation/presentation, tracker reconstruction, and challenge legality outside the identity owner.
- Passed mutable game/save state through live getters and preserved the existing Identity category helper call surface.
- Intentionally advanced the protected package contract to 33 files / 23 Lua modules plus `mod.card`.
- No Save Schema/API/Randomizer version or Runtime PASS changed.

## 2.9.51

- Began the intentionally approved new-module phase from exact packaged 2.9.50.
- Added `compatibility_runtime.lua` as the first-class owner for compatibility/provider discovery, ownership resolution, evidence classification, engine/mod relationship metadata, and compatibility public projections.
- Preserved late-bound runtime dependencies through explicit getters for current game, rule activity/defaults, and catch policy; no registration-time snapshots are used for those mutable surfaces.
- Updated the protected package contract intentionally from 31 files / 21 Lua modules to 32 files / 22 Lua modules plus `mod.card`.
- Compatibility API remains 37; no Save Schema/Randomizer version or Runtime PASS changed.

## 2.9.50

- Continued existing-owner modularization from exact packaged 2.9.49.
- Moved the remaining R/B/Y Forgiveness Token shop-filter implementation into `forgiveness.lua` verbatim.
- Preserved semantic BUY/SELL identification, SELL-list rebuild filtering, stable wrapper-session ownership, and `game.ready` / `save.loaded` reinstall hooks.
- Declared the currently reviewed existing-owner extraction phase substantially complete; future large splits should introduce approved first-class module owners.
- No Save Schema/API/Randomizer version or Runtime PASS changed.

## 2.9.49

- Continued existing-owner modularization from exact packaged 2.9.48.
- Activated `title_setup_compat.lua` as the owner of the live Gen-II `MainMenu:choose()` and final-list SETUP adapter.
- Kept setup-profile persistence/staging lifecycle in `main.lua` behind explicit callbacks; the historical R/B/Y engine-internal fallback remains dormant.
- Focused semantic harness PASS for fresh-list insertion, existing-save suppression, setup/new/continue routing, and vanilla delegation.
- No Save Schema/API/Randomizer version or Runtime PASS changed.

## 2.9.48

- Continued existing-owner modularization from exact packaged 2.9.47.
- Moved `Dev.hookHealth`, diagnostic snapshot/error/logging helpers, and self-test orchestration into `dev_diagnostics.lua` with a live current-game getter and explicit configuration dependencies.
- Retained the small core Dev instrumentation primitives used across runtime (`push`, lifecycle/performance counters, decision trace, `pguard`) in `main.lua`.
- `main.lua` reduced from 30,242 lines / 1,493,307 bytes to the sealed 2.9.48 measurement reported in release notes.
- No Save Schema/API/Randomizer version or Runtime PASS changed.

## 2.9.47

- Continued existing-owner modularization from exact packaged 2.9.46.
- Moved the remaining reviewed shared World Building text/pagination, presentation transaction, tier-selection, once-per-save flavor, feedback, and pure tier-audit implementation into `world_building.lua`.
- Challenge legality/enforcement remains outside the presentation owner; no runtime rule semantics moved.
- No Save Schema/API/Randomizer version or Runtime PASS changed.

## 2.9.46

- Continued existing-owner modularization from exact packaged 2.9.45.
- Moved read-only Rule Effectiveness, Randomizer Integrity, Gen-II Edition Parity, and Storage Context diagnostics into `dev_diagnostics.lua` with explicit stable dependencies and a live current-game getter.
- Deliberately retained `Dev.hookHealth`, snapshot/error capture, and self-test orchestration in `main.lua` pending separate live-hook dependency review.
- No Save Schema/API/Randomizer version or Runtime PASS changed.

## 2.9.45

- Continued existing-owner modularization from exact packaged 2.9.44 with a larger dependency-clean static/configuration batch.
- Moved Locke preset definitions, shared Gen-II beta rule/description metadata, pure Pokemon-ban set normalization helpers, and pure RBY/Gen-II starting-resource resolution/audits into `rule_catalog.lua`.
- Kept live preset application/classification, game-data species lookup, save-backed species-ban checks, `save.new_game`, enforcement, migrations, and provider/runtime ownership in `main.lua`.
- No Save Schema/API/Randomizer version or Runtime PASS changed.

## 2.9.44

- Continued conservative modularization from exact packaged 2.9.43.
- Moved pure read-only save-schema descriptor presentation and structural/default-type auditing (`describe`, `audit`) into existing semantic owner `rule_catalog.lua`.
- Kept live save-schema versioning, migrations, transaction/storage-key ownership, persistence, and save reads/writes in `main.lua`; only the already-built field snapshot and current schema value cross the module boundary.
- Preserved the established `__beta26.saveSchemaDescriptor` export and deep-copy behavior.
- Save-schema descriptor parity PASS across 166 authoritative descriptor rows and 185 generated save fields, including role counts, bad-default/missing-field fault detection, and copy isolation.
- `main.lua` reduced from 31,522 lines / 1,571,945 bytes to 31,462 lines / 1,568,827 bytes: net -60 lines / -3,118 bytes; approximately 69 implementation lines relocated with 9 lines of delegation/comments retained in `main.lua`.
- Advanced executable and independent Release Safety provenance to exact packaged 2.9.43.
- Save Schema 5 / Compatibility API 37 / Diagnostics API 1 / Translation API 2 / Run History v2 / Randomizer algorithm v1 unchanged.
- Static/Semantic evidence only; no gameplay behavior or Runtime PASS changed.

## 2.9.43

- Continued conservative modularization from exact packaged 2.9.42.
- Moved pure read-only rule-registry presentation and structural/default-type auditing (`describe`, `get`, `audit`) into existing semantic owner `rule_catalog.lua`.
- Kept live enum/coercion certification and stored-save validation in `main.lua` because they depend on runtime-owned surfaces.
- Preserved the established `__beta26.ruleRegistry` export and deep-copy behavior.
- Registry parity PASS across all 166 authoritative descriptor rows, unknown-key lookup, structural audit output, and copy isolation.
- `main.lua` reduced from 31,561 lines / 1,573,227 bytes to 31,522 lines / 1,571,945 bytes: net -39 lines / -1,282 bytes; approximately 48 implementation lines relocated.
- Advanced executable and independent Release Safety provenance to exact packaged 2.9.42.
- Save Schema 5 / Compatibility API 37 / Diagnostics API 1 / Translation API 2 / Run History v2 / Randomizer algorithm v1 unchanged.
- Static/Semantic evidence only; no gameplay behavior or Runtime PASS changed.

## 2.9.42

- Continued conservative modularization from exact packaged 2.9.41 after dependency review of the machine-readable rule/save descriptor subsystem.
- Moved only the pure descriptor-construction layer into existing semantic owner `rule_catalog.lua`: authoritative rule descriptor rows/index/collision construction, deep-copy support for descriptor values, and deterministic save-field map assembly.
- Kept live stored-value validation, enum/coercion auditing, save-schema auditing, transaction-owner access, `mod.save` access, and exported runtime descriptor surfaces in `main.lua`.
- Descriptor construction receives current rule/default inputs and explicit schema/transaction keys; it does not capture live save state or runtime owners.
- Read-only construction parity PASS across all 166 authoritative descriptor rows and the complete generated save-field map.
- Strengthened module-ownership evidence with a stable `Module owner: RuleCatalog` marker rather than tying ownership proof to one individual helper name.
- Reconciled public-document current headings/baselines to 2.9.42 without changing public API versions or gameplay claims.
- Advanced executable and independent Release Safety provenance to exact packaged 2.9.41.
- Save Schema 5 / Compatibility API 37 / Diagnostics API 1 / Translation API 2 / Run History v2 / Randomizer algorithm v1 unchanged.
- Static/Semantic evidence only; no gameplay behavior or Runtime PASS changed.

## 2.9.41

- Resumed the paused modularization program from exact packaged 2.9.40 with a deliberately small existing-owner pure/static split.
- Moved ordinary rule-value coercion into `rule_catalog.lua`, beside the authoritative rule definitions/ranges/defaults it consumes.
- Preserved `__beta26.coerceRuleValue` as a behavior-compatible delegating surface and passes the live definition index per call to avoid stale captured state.
- Updated module-ownership Release Safety evidence to require `coerceRuleValue` ownership in `rule_catalog.lua`.
- Read-only full-catalog coercion parity matrix PASS: 8,226 comparisons across every authoritative rule definition and representative read/write/malformed/range inputs.
- Advanced executable and independent Release Safety provenance to exact packaged 2.9.40.
- Save Schema 5 / Compatibility API 37 / Diagnostics API 1 / Translation API 2 / Run History v2 / Randomizer algorithm v1 unchanged.
- Static/Semantic evidence only; no gameplay behavior or Runtime PASS changed.

## 2.9.40

- Audited Release Safety itself and replaced the G9 battle-stack adapter serialization/string-order tripwires with semantic assertions against the authoritative compatibility adapter tables.
- Retained only a bounded set of narrow source checks for runtime seams that do not yet expose structured descriptors, and reports semantic/source evidence counts for that audit.
- Added read-only compatibility evidence classification with independent `live_contract`, `source_reviewed`, and `combined_runtime_required` facts; no class grants ownership or Runtime PASS.
- Added `compatibilityEvidenceClassificationAudit()` and `releaseSafetySelfAudit()` and wired both into promotion-facing Release Safety.
- Compatibility reports now expose the evidence projection; discovered live compatibility layers are marked as live-contract evidence without implying active/selected ownership.
- Explicit do-not-combine targets remain source-reviewed conflicts and are not mislabeled as combined-runtime certification targets.
- Advanced executable and independent Release Safety provenance to exact packaged 2.9.39.
- Save Schema 5 / Compatibility API 37 / Diagnostics API 1 / Translation API 2 / Run History v2 / Randomizer algorithm v1 unchanged.
- Static/Semantic evidence only; no gameplay behavior or Runtime PASS changed.

## 2.9.39

- Added read-only `Dev.ruleCertification(key, game)` and structured `Dev.explainRuleStatus(key, game, preGame)` diagnostics over the authoritative rule catalog and edition-availability contract.
- Added per-edition certification rows for Red/Blue/Yellow/Gold/Silver/Crystal with explicit reachability, exact-edition runtime evidence, and `REQUIRED` / `N/A` states where evidence is absent.
- Runtime evidence is deliberately sparse and exact-edition: existing documented Random Starter PASS evidence is attached only to the editions that were actually tested and is not generalized to Blue, Gold, or combined-mod stacks.
- Semantic evidence distinguishes full dedicated PASS, source-reviewed, disposition-reconciled, enum/range metadata PASS, and not-yet-assessed states instead of collapsing them into Runtime PASS.
- Added `ruleStatusCertificationAudit()` and Release Safety coverage for edition isolation, Gen-I/Gen-II reachability disposition, unknown-rule handling, and non-generalization of runtime evidence.
- Advanced executable and independent Release Safety provenance to exact packaged 2.9.38.
- Save Schema 5 / Compatibility API 37 / Diagnostics API 1 / Translation API 2 / Run History v2 / Randomizer algorithm v1 unchanged.
- Diagnostic/certification behavior only; no gameplay enforcement, persistence, provider ownership, or runtime certification changed.

## 2.9.38

- Added `saveReferenceConsumerIndex()`, a generated/read-only persistence-reference map over authoritative described save keys and shipped Lua source consumers.
- Added bounded diagnostic limits: 512 described keys, 24 consumer hints per key, and 64 unresolved/unreadable/undescribed detail rows.
- Literal `mod.save:get/set` references are classified as reads/writes; dynamic accesses are counted separately; other quoted references remain non-authoritative literal hints.
- Source-read failure is fail-open and diagnostic-only; Release Safety validates structure/bounds while reporting incomplete source introspection non-fatally.
- Dev stored-state diagnostics surface incomplete/truncated index state and bounded undescribed-key samples.
- Advanced executable and independent Release Safety provenance to exact packaged 2.9.37.
- Save Schema 5 / Compatibility API 37 / Diagnostics API 1 / Translation API 2 / Run History v2 / Randomizer algorithm v1 unchanged.
- Static/Semantic evidence only; no Runtime PASS promoted.

## 2.9.37
- Added an authoritative read-only catch-denial disposition catalog and semantic audit reconciling progression-PC override eligibility with the existing executable eligible set.
- Added numeric enum/range completeness certification for finite ordered bounds, in-range defaults, and canonical min/max clamping.
- Release Safety now runs both audits. No catch legality, progression exception behavior, save schema, API, Randomizer algorithm, or runtime evidence changed.
- Advanced executable and independent Release Safety provenance to exact packaged 2.9.36.
- Reconciled the stale README visible release heading forward to the current build.


## 2.9.36
- Fixed Gen-II Config visibility for Colorlocke and Alphabetlocke (mode + child selector rows).
- Added semantic/table-driven Gen-II reachability certification for those rules.
- Repaired stale independent Release Safety parent provenance to exact 2.9.35.
- No runtime certification added; Gen-II challenge-locke runtime testing remains pending.


## 2.9.35
- Consolidated eight pure rule/value helper responsibilities into existing `rule_catalog.lua` without changing their exported interfaces.
- Reduced `main.lua` while preserving runtime-sensitive ownership boundaries.
- Updated exact-parent provenance to 2.9.34.


- Strict child of exact packaged 2.9.32 (`41faef47c0611f54cbf771e8f1d90b388246a202f78202d9d77e6c0ed90973fc`).
- Moved the pure rule-definition index, duplicate-key collision scan, and default value-type normalization into existing `rule_catalog.lua`.
- Preserved the established `ruleDefinitionByKey` and `ruleDefinitionCollisions` exports in `main.lua`; no gameplay enforcement or save semantics intentionally changed.
- Updated executable and Release Safety parent provenance to exact packaged 2.9.32.
- Static/Semantic validation only; no new Runtime PASS claimed.

# 2.9.32 — First low-risk modularization relocation

- Strict child of 2.9.31.
- Extracted presentation-only rule description/interaction logic from `main.lua` into existing `rule_catalog.lua`.
- Uses live dependency getters to preserve setup/current-game semantics.
- No gameplay enforcement or persistence behavior intentionally changed.
- Corrected stale independent Release Safety parent expectations to 2.9.31.

# 2.9.31 — Stepwise module ownership audit

- Strict child of exact packaged 2.9.30.
- Performed a conservative existing-module ownership inventory before further modularization.
- Intentionally moved no gameplay code in this step; runtime/static-protected seams remain untouched pending focused split-safety proof.
- Recorded the next safe modularization direction and high-risk exclusions for subsequent one-scope builds.
- Repaired parent provenance forward to exact packaged 2.9.30 (`d75895232e25fa9c7095a5ef77cd76a1a643fd07f176619e8bf2aeee105c3b89`).
- No Save Schema, Compatibility API, Diagnostics API, Translation API, UI API, Run History, or Randomizer algorithm bump.

# 2.9.30 — Colorlocke canonical data repair

- Strict child of exact packaged 2.9.29 (`d3cbf770f3b5ae39312d2e106ca2b43570e013cb4822714b4bce922cad124135`).
- Fixes the confirmed Colorlocke semantic no-op caused by absent vanilla Gen-I/II color metadata.
- Adds a complete 251-entry National Dex color-id fallback using the PokéAPI/Veekun Pokédex-search color classification.
- Preserves provider/runtime metadata precedence and unknown-custom-species fail-open behavior.
- Adds semantic Release Safety coverage for dataset completeness, valid category IDs, and representative species in all ten color categories.
- No Save Schema/API/Randomizer algorithm bump and no new Runtime PASS claim.

# 2.9.29 — Level Match + modern menu compatibility hardening

- Strict child of exact packaged 2.9.28 (`537048f7f9d46df41585239b1e566892e5426f228a29db8cf6dddd119c1eea35`).
- Added Level Match 0.7.0 as an explicit Gen-II high-overlap compatibility target. Random Trainers now has a protected composition contract: it consumes the composed incoming `trainer.party`, owns species identity only, and preserves legitimate external roster size, levels, moves, items and other trainer-safe state.
- Added Modern Start Menu UI 0.1.14 as an explicit Gen-I/Gen-II presentation target and assigned the Nuzlocke START action stable semantic id `nuzlocke.menu` so renderers/localizations need not recognize its label.
- Refreshed the Modern Party UI 0.4.0 contract around controller-preserving Party/Summary/Naming/Relearn presentation.
- Added Release Safety coverage for trainer-transform dimensions and stable START identity.
- Reconciled stale packaged version metadata: `manifestVersion` now matches 2.9.29 and parent provenance points to exact packaged 2.9.28.
- Save Schema 5, Compatibility API 37, Diagnostics API 1, Randomizer algorithm v1 and gameplay defaults are unchanged. Combined runtime certification remains required.

## 2.9.28

- Added explicit compatibility profiles for Gold Next Encounter Spawner 1.2.2 and Pokeball Colors 0.1.33, and refreshed Gen1BetterMenus to 1.0.32.
- Audited encounter-transform precedence: Nuzlocke Random Encounters projects encounter tables, while intentional next-encounter spawning transforms the resolved candidate; final Nuzlocke catch/acquisition legality therefore evaluates the actual final species without repainting the external intentional selection.
- Preserved dependency-free `isModOptions = true` markers for Nuzlocke-owned options/configuration screens so compatible widescreen UI can recognize screen purpose without hardcoded mod IDs.
- Documented narrow ball-presentation ownership: cosmetic ball art/color remains external while Nuzlocke retains semantic catch/ball legality.
- No Save Schema or public API bump. All three compatibility combinations remain Runtime Test Required.

## 2.9.27

- Added Blackjack Corner 0.8.2 as a source-reviewed high-overlap compatibility target.
- Added additive semantic battle-roster and activity-state observation surfaces for cooperative compatibility without taking ownership of external battle/travel mechanics.
- Preserved the existing opaque-token pre-transaction acquisition lifecycle; no parallel acquisition authority was added.
- Corrected packaged parent provenance metadata to exact 2.9.26.
- No gameplay rule, Randomizer algorithm, or save-schema change.

# 2.9.27 — Compatibility expansion

- Adds explicit source-reviewed compatibility targets for Double Battles 0.6.1 and Free Fly 1.8.0.
- Defines conservative ownership boundaries: external mods keep their multi-battle/flight mechanics while Nuzlocke retains challenge legality, durable death state, acquisition policy and history.
- Adds manifest optional-dependency signaling and Release Safety coverage for both targets.
- Combined runtime certification remains required; no Runtime PASS is claimed.
- No Save Schema, public API, gameplay-rule default, or Randomizer algorithm change.

# 2.9.25 — Colorlocke + Alphabetlocke

- Adds Colorlocke with OFF / RANDOM / CHOOSE modes and ten canonical species colors.
- Adds Alphabetlocke with OFF / RANDOM / CHOOSE modes and A-Z selection.
- RANDOM resolution is deterministic; Alphabetlocke RANDOM selects only initials represented in the live species registry.
- Both are prospective acquisition restrictions: existing Pokemon and later evolutions remain legal.
- Both compose with Type Locke, PKMN BAN, BST, legendary/mythical/pseudo/glitch, party, and acquisition policies.
- Nuzlocke-owned Randomizer candidate legality reuses the same acquisition gate; mappings are not rerolled merely to satisfy these rules.
- Unknown custom color metadata fails open rather than guessing from sprites. Localized names never change Alphabetlocke legality.
- No Save Schema or public API bump. Runtime certification is required per edition.

# 2.9.24 — Attribution and project-lineage hardening

- Adds explicit permanent credit for bryanthaboi as creator of the original Nuzlocke mod/project baseline.
- Adds explicit permanent credit for masterwebx as creator of the original Shiny Pokémon mod whose original implementation/project is part of the shiny code/design lineage.
- Clarifies Stone696 as current Nuzlocke maintainer/developer and maintainer of the Shiny Pokémon fork.
- Adds prominent README attribution and preserves the distinction between original authorship, maintained fork work, and the substantially reworked current Nuzlocke shiny subsystem.
- No gameplay, rule, Randomizer, save-schema, API, ownership, or default changes.

# 2.9.23 — Gen1Recomp 0.2.38 launcher compatibility refresh

- Advances the Gen1Recomp source/documentation/launcher compatibility audit from 0.2.36 through 0.2.38.
- Adds explicit 0.2.37 and 0.2.38 compatibility profiles while retaining Mod API 2, upstream Save Format 5, and the existing `>=0.2.24 <2.0.0` engine range.
- Reviews the current launcher manifest-only mod manager, GitHub Update/Versions support, per-game targeting/status metadata, launch sync/update flow, and Gen-II cartridge save import/export.
- Confirms Nuzlocke's existing manifest already supplies the relevant launcher metadata; no new gameplay hook, permission, Save Schema, or Compatibility API bump is required.
- Updates Release Safety current-engine assertions through 0.2.38.
- Exact-edition 0.2.38 runtime certification remains pending.

# 2.9.22 — Split-Evolution Dupes repair

- Fixes SPLIT Dupes enforcement: the saved mode 3 now survives `dupesMode()` normalization instead of silently collapsing to FAM.
- Fixes the main Nuzlocke Config marquee so SPLIT displays as SPLIT instead of OFF.
- Restores Movement Assist normalization to its documented OFF / HOLD B / ALWAYS range.
- Adds the missing Dev decision trace for Party Size Limit catch refusals without making that hard refusal eligible for progression-catch override.
- Strengthens Release Safety around enum range → normalization → UI label → runtime dispatch for SPLIT Dupes.
- No save/API/schema/default changes. Runtime certification remains required.

# 2.9.21 — Split-Evolution Dupes

- Expanded Dupes Clause from OFF / SPEC / FAM to OFF / SPEC / FAM / SPLIT.
- SPLIT preserves duplicate ancestry within a branch but allows sibling split-evolution branches to remain eligible.
- Branch checks traverse live merged/provider evolution rows and fail open on incomplete custom metadata.
- Preserved FAM as the default and retained legacy boolean coercion to FAM; no save migration or schema bump.
- Updated Nuzlocke-owned rule labels, Gen-II applicability text, World Building copy, and public documentation.
- TEST REQUIRED: exact-edition runtime certification for linear families, split families, custom/provider evolution graphs, Failed Encounters, Shiny Clause, and Randomizer combinations.

# 2.9.20 — Special Acquisition Policy expansion

- Added independent **Gift Slot Policy** and **Trade Slot Policy** controls: AREA preserves historical One Per Area consumption; BONUS records the acquisition without consuming the ordinary area slot.
- Gift Slot Policy applies to the existing gift family, including fossils and Game Corner prize Pokemon when they arrive through gift provenance.
- Existing **Gift Pokemon** and **In-Game Trades** allow/deny rules remain independent transaction-legality controls. Species bans, Type Locke, Maximum BST, party limits, and other acquisition legality continue to apply in BONUS mode.
- BONUS mode bypasses only ordinary encounter-slot occupancy; it does not bypass species legality or mutate/delete post-transaction external acquisitions.
- Existing saves default to AREA, preserving 2.9.19 behavior without a Save Schema bump.
- No Runtime PASS is claimed; exact-edition transaction and tracker testing remains required.

# 2.9.20 — Release Safety self-audit hardening

- Repaired stale Release Safety source tripwires exposed by executing the shipped self-audit against the current source tree.
- Updated World Building failed-encounter critical-callsite detection (`key` -> `area`) without changing gameplay behavior.
- Updated Difficulty Review checks to protect semantic function/title presence rather than frozen call/assignment shapes.
- Reconciled Gen-II healing, encounter-feedback, Randomizer ownership, options-screen-count, and current Shiny target assertions with their current owners/source shapes.
- Fixed public-document hygiene auditing so ordinary gameplay/API uses of the word “handoff” are not mistaken for internal continuity-document leakage; removed one actual historical internal-governance phrase.
- Hardened package/document drift checks around document-role version cadences and release-note subtitles instead of requiring every maintained document heading to equal the player build.
- No gameplay rules/defaults, Save Schema, Compatibility API, Randomizer algorithm, ownership behavior, or Runtime PASS evidence changed.
- Static/Semantic PASS; runtime behavior remains inherited and runtime certification debt is unchanged.

# 2.9.18 — End / Abandon Run

- Added **END RUN** to the Nuzlocke-owned NUZ MENU.
- Added explicit **ABANDON RUN** lifecycle handling backed by the existing durable `run.abandoned` Run History v2 event.
- Abandonment is deliberately distinct from natural progression-owned completion: the UI cannot manufacture a completed run.
- Destructive confirmation defaults to **NO**, is idempotent/deduped per run, and commits durable abandonment before disabling the Nuzlocke master switch through the ordinary rule setter.
- Successful abandonment opens the Almanac so the player can immediately view the final recap; completed/already-abandoned runs are read-only in END RUN.
- Added lifecycle DEV health and Release Safety contracts. No Save Schema, public API, Randomizer algorithm, compatibility ownership, or Runtime PASS change.

## 2.9.17
- Strict child of exact packaged 2.9.16 (`50e00064fe29c29ef1e5114f22861b75693bdd07283ed04c0cc9e6fccdd69eaa`).
- Added a translated, read-only Almanac / Run Recap under NUZ MENU.
- Almanac summarizes durable Run History v2 totals for catches, deaths, badges/progression, failed encounters, blackouts, forgiveness, completion/abandon state, rule-integrity evidence, and recorded Randomizer run metadata.
- Added explicit PARTIAL/COMPLETE history-coverage presentation so legacy or pruned detail is never guessed.
- Added read-only Almanac DEV health and Release Safety contracts; the viewer creates no parallel save ledger and consumes no Randomizer RNG.
- Save Schema remains 5; Run History remains v2; no API/default/support-level changes or new Runtime PASS are claimed. RUNTIME TEST REQUIRED.

## 2.9.16
- Strict child of exact packaged 2.9.15 (`78339f693cfcbb740104eadef3ac5da6359f3d419300f514df7d909542500803`).
- Added a translated, read-only Graveyard Viewer under NUZ INFO with chronological fallen-Pokémon list and per-Pokémon memorial details.
- Graveyard projects existing `nuzlocke_history` DEAD/REVIVED state, Run History v2, and the F. TOKEN dead archive; no duplicate graveyard ledger or Save Schema bump was introduced.
- Future death records preserve optional level enrichment; legacy missing fields remain UNKNOWN rather than inferred.
- Added read-only Graveyard Health diagnostics and Release Safety regression checks.
- RUNTIME TEST REQUIRED; no new Runtime PASS claimed.

## 2.9.15
- Strict child of exact packaged 2.9.12 (`b876bfc720d430142af7aab50da54387d78c3dfe51cc1203ce6169abb91cd13d`).
- Fixed tracker caught-area and catch-total counters so stale/untracked area keys no longer inflate current player-facing tracker/Pokegear counts.
- Applied the same tracked-area filter to the optional Pokegear integration's duplicated area counters.
- Added a Release Safety regression check for current-area count filtering.
- No Save Schema, Compatibility API, Randomizer algorithm, defaults, support-level, or Runtime PASS change.

## 2.9.12
- Strict child of exact packaged 2.9.11 (`cfe5b25ba03c4916fe7d9ab3c9dbaadbdd528e09eee62133406d2980ef2dc63b`).
- Added the missing `FIELD_ITEMS` ↔ `TM_LOCATIONS` entry to the declarative Randomizer compatibility matrix, documenting the implemented precedence contract for authored TM pickups.
- Fixed R/B/Y Elite Four progression to use the transactional league-progression path, so Elite Four victories can be deduped and recorded in Run History like Gym Leaders, GSC stages, and the Champion.
- Added Release Safety checks for both repaired contracts.
- No Save Schema, Compatibility API, Randomizer algorithm, defaults, support-level, or Runtime PASS change.

## 2.9.11
- Strict child of exact packaged 2.9.10 (`58ad613dab705ec6fbe3cacd228f3f20f2a065f3896fcdd30ee7c972c25e9d60`).
- Fixed audit-confirmed compatibility drift by declaring `DRAMATIC_SHAPE` in `manifest.json` optional dependencies.
- Added `dramatic_shape_optional_dependency` to Release Safety so the manifest and compatibility registry must remain synchronized.
- No gameplay/schema/API/Randomizer/default/Runtime PASS change.

## 2.9.10
- Added explicit DEV hook-health coverage for Random TM Locations (`TM_LOCATIONS` / `random_tm_locations`) so shared pickup-wrapper/session drift cannot fail silently behind Field Item coverage.
- Fixed `RunHistory.list(..., {limit=N})` to return the most recent matching tail when no `after_seq` cursor is supplied; cursor-based calls keep forward-pagination behavior.

## 2.9.7
- DEV/diagnostics completeness and lifecycle-contract audit. Protects observational diagnostics, explicit lifecycle stages, and the rule that self-test evidence cannot become Runtime PASS.

## 2.9.7
- Final static Randomizer contract audit covering all ten subsystems, deterministic/persisted mappings, ownership boundaries, and unresolved Gen-II trainer/field-item runtime debt. No new Runtime PASS.

# 2.9.7 — Compatibility registry reconciliation

- Strict child of exact packaged 2.9.4 (`f575985792631e70812c959b39b3ef62b01cedff99b710916b009d1dcc42113d`).
- Reconciles explicit compatibility adapters, manifest optional-dependency signaling, legacy-reviewed targets, presentation-only targets, and explicit conflicts/exclusions.
- Adds a read-only Release Safety registry audit covering current high-overlap target identities and required exclusions.
- Preserves `kanto_ascendant` as explicit conflict/do-not-combine and absent from optional dependencies; preserves SHINY_POKEMON as a target without reciprocal optional dependency.
- Keeps Dex Overflow and Safari All legacy-reviewed rather than inventing current-source certification.
- No gameplay ownership is inferred from manifest presence or load order, and no Runtime PASS is promoted.
- No gameplay defaults, Save Schema, public API, Randomizer algorithm, or edition-support level changed.

# 2.9.4 — Acquisition/provenance completeness audit

- Strict child of exact packaged 2.9.3 (`cf5a83385d3d101bf839b7ac2ec446564b1cbf1ee09eaa824fe19b531beb456a`).
- Audits acquisition/provenance coverage across wild/static/roaming captures, starters, gifts, in-game trades, fossils, Game Corner prizes, eggs/Day Care, scripted fixed sources, Wonder Trade, Stadium/transfer imports, external imports, and progression-required acquisitions.
- Adds a read-only `acquisitionProvenanceCoverageAudit()` inventory; it consumes no RNG and mutates no gameplay/save state.
- Reaffirms that unknown imported/edited Pokémon fail open as unverified rather than consuming guessed encounter provenance, and post-mutation acquisition events are observation/reconciliation seams rather than destructive rollback authority.
- Repairs inherited independent Release Safety parent inputs so they again point at the exact immediate packaged parent instead of stale 2.9.1 metadata.
- No gameplay defaults, Save Schema, public API, Randomizer algorithm, or Runtime PASS evidence changed.

# 2.9.3 — External healing/services compatibility audit

Strict child of exact packaged 2.9.2 (`aeb489f59364cbb496f2b7f1bff3dcd686ff5b78ac73a635d9caf654704757fa`). Audits healing as separate semantic surfaces: Center, Mom, field-item, battle-item, story, and external/post-battle convenience healing. Revalidates the Gen-II `special HealParty` service gate and its map/service classification, preserves unrelated story healing, retains survivor-only composition for external overhaul healing, and protects durable `nuzlockeDead` state from revival. Adds a static Release Safety healing/service ownership audit. No gameplay defaults, schemas/APIs, deterministic Randomizer behavior, or Runtime PASS status change.

# 2.9.2 — Battle-stack compatibility audit

- Strict child of exact packaged 2.9.1.
- Re-audits G9 Battle Engine 1.2.3, `g9-battle-engine-beta` 2.0.2, QoL Toggles 1.30.8 and Nuzlocke battle-policy overlap.
- Preserves external modern combat/stat ownership only for advertised dimensions while keeping native Gen-II DVs identity-bearing and Nuzlocke challenge policy on narrow semantic seams.
- Adds a Release Safety battle-stack ownership audit covering G9 scope, lifecycle observe-only status, trainer/item/battle-finish composition, native Gen-II party routing, held-item semantics and the case-specific QoL Poison Save precedence.
- Adds no speculative private battle-engine patch and claims no new Runtime PASS.

# 2.9.1 — Party-stack compatibility audit

- Audits the current party-stack boundary against Modern Party UI 0.4.0, QoL Toggles 1.30.8, PokéPC Followers 0.5.1, Followers EX 1.0.19, PotatoVoxel 1.9.6, and the protected native Gen-II party/item routing.
- Records Modern Party UI as a Gen-I presentation owner only: its screen-record replacement does not transfer ownership of party targeting, TM/HM targeting, trades, forced battle switches, field moves, or other engine party-controller actions.
- Reaffirms that Nuzlocke must not wrap Gen-II PartyMenu.new/openSubmenu/submenuItems for ordinary field features and must preserve native BattleState:openParty behavior.
- Keeps the narrow Gen-II party-target item and held-item legality seams already required by Nuzlocke rules; no new broad PartyMenu interception is added.
- Reaffirms follower/voxel mods as presentation/control companions rather than Nuzlocke party-state authorities; durable death, party-size legality, encounter provenance, and challenge rules remain Nuzlocke-owned.
- Adds Release Safety tripwires for the Modern Party UI party-controller ownership contract.
- No gameplay default, save schema, compatibility API, diagnostics API, translation API, Run History format, or Randomizer algorithm changes. Combined runtime certification remains required.

# 2.9.0 — Full external documentation and code audit

- Strict child of exact packaged 2.8.99 (`db8c1fc55de631685d956d613fc10e38f73e8506d82affaaeb339aded0c0fbfc`).
- Restores the requested 2.9.x numbering convention: 2.9.0, 2.9.1, …, 2.9.10, 2.9.11.
- Repairs stale executable and independent Release Safety parent metadata to the actual 2.8.99 immediate parent.
- Advances stale Release Safety current-engine assertions from Gen1Recomp 0.2.33 to 0.2.36 and requires the 0.2.34–0.2.36 profiles while preserving historical audit aliases.
- Corrects the Randomizer release-documentation package expectation from 30 to the canonical 31-file package contract.
- Reconciles README, User Guide, API, Compatibility, Feature Confidence, Documentation Changelog, Release Notes, manifest/build identity, and current support wording.
- Corrects current Randomizer scope from nine to ten ownership methods by including separate TM Locations.
- Corrects stale current-facing Crystal “unsupported” wording; Crystal remains explicit alpha support.
- No gameplay rules/defaults, save schema, public API versions, Run History version, or Randomizer algorithm changed. No new Runtime PASS claimed.

## 2.8.99

- Internal process-governance maintenance release. No gameplay behavior, compatibility API, save schema, diagnostics API, translation API, or Randomizer algorithm changes.
- Gen1Recomp reviewed baseline remains 0.2.36; exact-edition runtime certification remains pending.

# 2.8.98 — Gen1Recomp 0.2.36 Compatibility Refresh

- Advances the source/documentation audit marker from Gen1Recomp 0.2.33 to 0.2.36.
- Adds engine compatibility profiles for 0.2.34, 0.2.35, and 0.2.36; Mod API remains 2 and upstream Save Format remains 5.
- Reviews the 0.2.33→0.2.36 forward release delta, including current ONLINE tournament/spectator/team-selection/remote-trade lifecycle changes, without bypassing engine ONLINE content-mod policy or claiming new gameplay ownership.
- Keeps the supported engine range at `>=0.2.24 <2.0.0`.
- No Nuzlocke Save Schema, Compatibility API, Diagnostics API, Translation API, Run History, or Randomizer algorithm bump.
- No new Runtime PASS claimed.

# 2.8.97 — Transfer / Stadium / Crystal-251 provenance audit

- Revalidates the explicit-only Stadium acquisition-provenance contract and keeps presentation/importer detection separate from Pokémon acquisition.
- Records upstream Gen-I/Gen-II wire preservation behavior without treating serialization as a gameplay transaction seam.
- Explicitly classifies current Gen-II link trade as not yet a usable/certified acquisition transaction; no speculative veto or private hook added.
- Clarifies Wonder Trade as post-mutation observe-only and preserves the no-destructive-rollback rule.
- Unknown imported/edited Pokémon remain unverified rather than consuming guessed encounter provenance.
- No save/API/schema/randomizer-algorithm bump and no Runtime PASS claimed.

# 2.8.97 — Type-system compatibility audit

- Unifies Game Difficulty type-sensitive decisions with Nuzlocke's normalized merged/provider species-facts path.
- Revalidates Type Locke and Random Starter Trio Typing against the live merged species/type-chart architecture.
- Retains Delta Type 1.2.0 and `steel_typing` 2.0.1 compatibility boundaries without private type-chart copying.
- No save/API/schema/Randomizer algorithm bump; no Runtime PASS claimed.

# 2.8.97 — Expanded species / Dex-provider compatibility audit

- Revalidates the generic merged-species/provider path used by Maximum BST, species bans, Type Locke and Randomizer pools.
- Retains Dex Overflow 0.1.1 as legacy reviewed because no newer/current public source was resolved.
- Fixes normalized species facts so provider-supplied evolution data is used when the merged species row lacks evolutions.
- Re-establishes Lua syntax validation using `texluac -p`; the 2.8.94 validation failure was a command-line misuse of `texlua -e`, not a source failure.
- No schema/API/Randomizer algorithm bump; no Runtime PASS claimed.

# 2.8.97 — Bag/inventory ecosystem compatibility audit

- Adds explicit targets for Useful Bag 2.6.3, Modern Bag UI 0.4.5 and Bag Sort 0.1.0.
- Separates presentation/storage/order ownership from semantic item legality.
- No schema/API/Randomizer algorithm bump; no Runtime PASS claimed.

# 2.8.97 — G9 Battle Engine lifecycle compatibility refresh

- Refreshes published G9 Battle Engine to 1.2.3 and adds current combat-only `g9-battle-engine-beta` 2.0.2 as a separate Gen-II target.
- Modern-stat ownership can resolve through either G9 id. Battle lifecycle/held-item/status surfaces remain observe-only and TEST REQUIRED; no speculative private battle patches.
- Repairs stale Kanto Ascendant optional-dependency prose from 2.8.92.
- No schema/API/Randomizer algorithm bump; no Runtime PASS claimed.

# 2.8.97 — Safari / expanded-content acquisition compatibility audit

- Re-audits Safari All, Kanto Ascendant and VanillaPlus acquisition/encounter overlap.
- Safari All 1.1.0 is retained as a legacy scoped target but is no longer represented as current-index verified; no newer public source was found in the current mod index.
- Refreshes Kanto Ascendant from historical 6.5.4 coexistence assumptions to current 6.5.17: its manifest explicitly conflicts with standalone Nuzlocke and includes its own ASC RUN Nuzlocke system. Removes `kanto_ascendant` from Nuzlocke optional dependencies and adds a read-only unsupported-stack warning.
- Revalidates VanillaPlus 0.3.0 progression captures, badge-scaled Rocket ambushes, captain healing and random rewards. Existing progression exceptions remain exact and narrow; dead-Pokemon and item-use rules remain authoritative at their existing seams.
- No save/API/schema/randomizer-algorithm bump and no new Runtime PASS.

# 2.8.97 — The World 6.54.15 + Wonder Trade 1.2.1 compatibility refresh

- Re-audits The World against current 6.54.15 documentation and refreshes the explicit target from 5.10.0 to 6.54.15 across Gen I and Gen II.
- Records that current The World embeds Wonder Trader and declares standalone `wonder_trade` conflicting; adds a read-only stack warning when both are detected.
- Re-audits standalone Wonder Trade 1.2.1. Its transaction still mutates the party before `pokemon.received` / `trade.completed`, so Nuzlocke remains observe-only and Wonderlocke remains disabled pending a safe pre-transaction cooperation seam.
- No gameplay rule precedence is inferred from installation alone. No save/API/schema/randomizer-algorithm bump.

# 2.8.97 — Gen-II Random Field Item Static Pipeline Audit

- Performs the second planned no-runtime root-cause pass, focused on Gen-II visible item balls and native hidden/BG-event items.
- Revalidates Gen1Recomp 0.2.33 `HiddenItems.ballPickupScript(item, quantity, objectId, sfxId)` and `HiddenItems.pickupScript(item, event)` signatures against Nuzlocke's direct-method wrappers; no upstream capability/signature gap was found in source.
- Preserves the 2.8.88 method-specific ownership and deterministic mapping behavior; no speculative item-randomization rewrite is made.
- Adds read-only decision evidence (`original`, mapped `choice`, source identity/context) and native pickup-script evidence showing the item embedded in `getitemname`/`giveitem` commands.
- Adds `auditGen2FieldItemPipeline()` to verify both native builders and both live Nuzlocke-owned wrapper sessions without consuming RNG or materializing mappings.
- Random Field Items remains runtime-unresolved until an exact-edition reproduction is tested.

---

# 2.8.89 — Gen-II Random Trainer Static Pipeline Audit

- Performs a no-runtime root-cause audit of the Gen-II Random Trainers pipeline against Gen1Recomp 0.2.33's shared `trainer.party` contract.
- Confirms the engine still exposes `trainer.party` on Gen II with the same class/party-index/roster semantics; no upstream capability gap was found in source.
- Preserves the existing native Gen-II `Mon.new` rematerialization path and highest-priority final trainer authority; no speculative gameplay rewrite is made without runtime evidence.
- Adds read-only `battle.started` accepted-roster evidence so DEV diagnostics can compare the finalizer's projected roster with the native `enemyParty` actually consumed by Gen-II battle.
- Adds `auditGen2TrainerRandomizerPipeline()` for static hook-registration/order/native-constructor checks. It is explicitly static/observational evidence and cannot promote Runtime PASS.
- Random Trainers remains runtime-unresolved until an exact-edition reproduction is tested.

---

# 2.8.88 — Method-Specific Item / TM Randomizer Ownership

- Adds **Random TM Locations** as a separate Nuzlocke Randomizer option from **Random TMs**. Random TMs continues to change TM contents; Random TM Locations changes the TM item found at supported physical TM pickup sources while preserving HMs and native collection flow.
- Adds an isolated deterministic `TM_LOCATIONS` stream and persisted source map so the new method does not perturb Starter, Encounter, Field Item, Learnset, Trainer, Evolution, Shop, TM-content, or Gift Item mappings.
- Preserves historical Random Field Items behavior when Random TM Locations is OFF. When both are ON, the TM-only location method takes precedence for authored TM pickups.
- Repairs the 2.8.87 external Field Item ownership path so delegation is enforced at the actual collection-time transformation seam rather than diagnostics/UI only.
- Makes Item Randomizer ownership source-specific: Gen-II `gold_ball_items` owns visible item balls only and `gold_finder_items` owns native hidden/Itemfinder sources only; Gen-I `overworld_items` continues to own supported visible pickups.
- Treats Pokémon Gen 1 Randomizer TM-location settings as ownership of the new TM-location method, not Nuzlocke TM-content randomization. Its ordinary/hidden item ownership is likewise source-method aware.
- Keeps Gen 2 Randomizer+ `randomTMs` mapped to TM-content ownership because its current implementation rewrites TM assignments/compatibility rather than physical pickup locations.
- Keeps the broader external-mod precedence philosophy provisional and case-specific pending later user review.
- No Save Schema, Compatibility API, Diagnostics API, Translation API, or global Randomizer algorithm bump. Runtime coexistence certification remains required.

---

# 2.8.87 — External Randomizer Compatibility Ownership Refresh

- Re-audits active external Randomizer targets against Pokémon Gen 1 Randomizer 0.46.4, Gen 2 Randomizer+ 2.9.0 release behavior, and Item Randomizer 1.1.1.
- Expands `pokemon_randomizer` active-run delegation to source-confirmed Trainer, Evolution, Shop, ordinary field-item, and hidden-item ownership in addition to Starter/Wild/Learnset ownership.
- Expands `gen_2_randomizer_plus` active-option delegation to Random Trainers, Random World Items, and Random TMs in addition to Starter/Wild/Learnset ownership.
- Expands Item Randomizer Gen-II field-item delegation so `gold_finder_items` (native hidden/Itemfinder finds) is recognized alongside `gold_ball_items`.
- Preserves installation-only fail-open behavior: no external Randomizer disables a Nuzlocke subsystem unless the matching external feature is positively active.
- Records the Gen 2 Randomizer+ 2.9.0 release/source-manifest discrepancy for diagnostics: the published release advertises Gold/Silver support while the tagged source manifest still reports version 2.5.0 / Gold-only. Nuzlocke does not depend on that stale manifest version for ownership.
- Downgrades the 2.8.86 external-convenience precedence statement from permanent governance to a provisional case-specific decision pending later user review.
- No Save Schema, Compatibility API, Diagnostics API, Translation API, or Nuzlocke Randomizer algorithm bump. Combined-mod runtime testing remains required.

---

# 2.8.86 — QoL Toggles 1.30.8 Compatibility Hardening

- Advances the reviewed QoL Toggles baseline from 1.24.1 to **1.30.8** and recognizes its current Gen-I/Gen-II scope.
- Adds a narrow provider-helper guard so QoL **POISON SAVE** cannot clamp away a field-poison faint while Nuzlocke Permadeath is active; Permadeath OFF preserves QoL behavior.
- Revalidates existing precedence for No TMs vs Unlimited TMs, No Held Items vs Gen-II held-item restoration, No Escape vs Instant Flee/quick-run conveniences, post-battle dead-mon pruning vs Heal After Battle, Auto-Repel vs No Repels, and HOLD-B running composition.
- No save/API/schema/Randomizer algorithm bump. Runtime combination testing remains required.

---

# 2.8.85 — Kanto Reforged 1.5.3 Compatibility Revalidation

- Revalidates the Kanto Reforged compatibility adapter against current **1.5.3** source, including its expanded Gen-I/Gen-II support.
- Confirms the existing `core.host` scoped Random Spawn option contract, `ui.level_caps.capFor` soft-cap seam, Gen-I held-item catalog path, and native Gen-II held-item effect composition remain valid.
- Revalidates Kanto Reforged fixed legendary/mythical encounter provenance already recognized by Nuzlocke.
- Retains Kanto Reforged ownership of its content/battle systems while Nuzlocke remains authoritative for challenge legality, death state, encounter/capture policy, and the stricter active level cap.
- No Save Schema, Compatibility API, Diagnostics API, Translation API, or Randomizer algorithm change. Combined-mod runtime certification remains separate.

---

# 2.8.84 — Gen1Recomp + UI Compatibility Freshness

- Re-scanned the current Gen1Recomp release/main/dev state; 0.2.33 remains the current published gameplay/API baseline and no newer forward engine seam was identified.
- Updates the Gen1 Modern UI reviewed baseline to 0.9.2 and records it as retired/frozen Gen-I legacy compatibility.
- Updates Modern Party UI from the older 0.3.8 audit baseline to 0.4.0; presentation remains externally owned while source/engine controllers retain semantic actions.
- Updates Wide Menus to 0.3.0 and revalidates Nuzlocke's `register`/`size` integration against the current documented export contract.
- Retains `variable_width_kerning` as a passive legacy identity without inventing a current version.
- Tracks Clean UI/`clean-ui-core` as a successor-watch architecture only; no installable target or dependency is claimed.
- No gameplay, save schema, Compatibility API, Diagnostics API, Translation API, or Randomizer algorithm changes.

---

# 2.8.83 — Shiny-Ecosystem Voxel Target Completion

- Completes the cross-project voxel/visual compatibility sweep against the maintained Shiny fork's current tree and historical integration work.
- Adds **Dramatic Shape Voxel Mod 1.0.6** (`DRAMATIC_SHAPE`) as an explicit Gen-I presentation coexistence target.
- Preserves Dramatic Shape as a target-only relationship rather than a manifest dependency, matching Shiny's historical integration model and avoiding unnecessary load-order constraints.
- Retains all existing Nuzlocke targets including Shiny 1.2.20, Wilds 2.2.0, PokéPC Followers 0.5.1, Followers EX 1.0.19, PotatoVoxel 1.9.6, BATTLE_ART_VOXEL_FORK, translations, Randomizer integrations and other reviewed adapters.
- Nuzlocke retains challenge rules, encounter/capture legality, tracker/progression state and gameplay transactions while Dramatic Shape owns its voxel/diorama presentation.
- Adds Release Safety coverage so the explicit Dramatic Shape target cannot silently disappear.
- No gameplay rule, save data, Randomizer mapping, public API/schema, dependency direction, or deterministic behavior changes. Combined-mod runtime certification remains separate.

# 2.8.82 — Explicit Compatibility Target Alignment

- Updates the explicit `SHINY_POKEMON` reviewed target from maintained fork 1.2.7 to the current published maintained fork **1.2.20**.
- Adds **PokéPC Followers (Voxel Merge) 0.5.1** (`PokePCFollowers_VoxelMerge`) and **Followers EX 1.0.19** (`FOLLOWERS_EX`) as explicit optional Gen-I coexistence targets.
- Removes Nuzlocke's reciprocal manifest `SHINY_POKEMON` optional-dependency edge because maintained Shiny 1.2.20 already declares `nuzlocke` optional; this prevents the Gen1Recomp loader from rejecting the pair as an optional-dependency cycle while preserving provider/API integration.
- Preserves Nuzlocke's newer **Wilds of Kanto 2.2.0** audit rather than replacing it with Shiny 1.2.20's older 2.1.9 audit marker.
- Preserves all existing Nuzlocke-specific compatibility adapters, translation targets, optional identities, ownership rules, and exact-edition confidence boundaries.
- Adds Release Safety tripwires so the Shiny 1.2.20/PokéPC/Followers EX target declarations cannot silently disappear from a later build.
- No gameplay rule, save data, Randomizer mapping, Compatibility API, Diagnostics API, Translation API, Run History format, or Randomizer algorithm behavior changes. New target declarations are not Runtime PASS claims.

# 2.8.81 — DEV Stored-State Audit Coverage Accounting Fix

- Strict child of exact packaged 2.8.80.
- Fixes `storedStateAudit()` in `dev_diagnostics.lua` passing `present=false` for `randomizer_phase_h_economy_progression` even when `randomizerItemEconomyRegressionAudit` exists and executes.
- The Phase-H economy audit now passes `present=true` in the function-present branch, matching sibling stored-state audits; the missing-function branch remains `present=false`.
- This restores accurate `report.present` coverage accounting used by DEV diagnostics/assertions.
- No gameplay behavior, rule defaults, Randomizer mappings, Save Schema, Compatibility API, Diagnostics API, Translation API, Run History format, or Randomizer algorithm version changed.

# 2.8.80 — F. TOKEN Confirmation Safety

- Fixes the failed-area F. TOKEN spend confirmation so directional input selects an explicit YES/NO value instead of toggling the current value after the first press.
- Left/Up always selects YES; Right/Down always selects NO. Repeating the same direction is now idempotent and cannot flip the cursor to the opposite destructive choice.
- No rule defaults, save schema, public API versions, Randomizer mappings, compatibility ownership behavior, or transaction semantics changed.
- Exact runtime reproduction/confirmation remains required before marking this repair Runtime PASS.

# 2.8.79 — Documentation Reconciliation

- Reconciles current public documentation with the cumulative project contract without changing gameplay.
- Preserves exact-edition support/confidence wording: R/B/Y mature baseline, Gold/Silver beta, Crystal alpha.
- Reaffirms current public API/schema and compatibility ownership boundaries.
- Keeps known Gen II Random Field Item/Trainer runtime failures and pending Crystal/engine certification explicit.
- No gameplay rules, defaults, save schema, Randomizer mappings, deterministic namespaces, transactions, compatibility ownership behavior, or public API versions changed.

# 2.8.78 — Gen1Recomp 0.2.30–0.2.33 Compatibility Audit

- Strict child of exact 2.8.77 (`1c3e3d0e866a8010c42a534b73a4f33ae5f4c927fe92098b0f5c9b34ed4b8e69`).
- Advances `recompCompatAudited` from 0.2.29 to 0.2.33 and adds profiles for 0.2.30–0.2.33.
- Corrects upstream engine Save Format metadata: 0.2.24 is 4; 0.2.25–0.2.33 are 5.
- Source-revalidates protected Gen II seams and the Crystal shiny-flash safety boundary without claiming a new runtime PASS.
- Records `pokemon.level_visible` as a future Gen-I Blind Levels/No Level Info opportunity, distinct from Randomizer BLIND INFO.
- Records Gen II save import/export, Pokedex registry, and MenuRepeat/transition integration opportunities.
- Documents the Gen1Recomp 0.2.33 ONLINE arena's intentional `disableAll`/`cartOnly` ordinary-content-mod policy; Nuzlocke does not bypass it, while ordinary modded/LAN link remains `affects_link=true`.
- Engine range, Save Schema 5, Compatibility API 36, Diagnostics API 1, Translation API 2, Run History v2, and Randomizer algorithm v1 remain unchanged.
- Gen2 Random Field Items and Random Trainers remain unresolved; Crystal shiny exact-runtime certification and 0.2.30–0.2.33 smoke tests remain pending.

# 2.8.77 — Migration / Compatibility / Randomizer Diagnostics Hardening

- Strict child of exact 2.8.76 (`f673cae7db46c7c018a52483b2d6897008df6a40e47121380a3369863dd102c2`).
- Fixes `save_migration.lua` shadow-store copy-on-read asymmetry: staged `after_value` tables are now returned through `deps.copy()` instead of exposing the journal's internal table by reference.
- Extends the transaction/self-test harness with nested shadow copy-isolation coverage.
- Advances Compatibility API **35 → 36** because `nuzlocke_compat.runtime_environment` now exposes the current environment string rather than an accidental function object.
- Makes `Content.registerBundle()` prevalidate the entire content/provider bundle before mutation, preventing a bad late child or Randomizer policy from leaving partial registrations.
- Adds `Content.validateBundle()` and a focused bundle atomicity self-test proving an invalid child causes zero registrations.
- Corrects Gen2 visible Field Item Hook Health to use `__nuzlockeRandomFieldItemBallSession2808`.
- Adds Gen2 hidden Field Item Hook Health for `HiddenItems.pickupScript` / `__nuzlockeRandomHiddenItemSession2808`.
- Adds read-only semantic `trainer.party` Hook Health using the actual Runtime hook chain, including primary/finalizer registration and last Gen2 trainer Randomizer evidence.
- Adds Release Safety tripwires for all of the above defect families.
- Save Schema remains 5; Diagnostics API remains 1; Translation API remains 2; Run History remains v2; Randomizer algorithm remains 1.
- Reported Gen2 Random Field Item and Random Trainer gameplay failures remain open pending runtime diagnosis; this release improves diagnostic truthfulness and does not claim those gameplay paths fixed.

# 2.8.76 — Ball Policy / Forgiveness Recovery / Six-Edition Audit Fixes

- Strict child of exact 2.8.75.
- R/B/Y native Ball use now fails closed if the authoritative item-use policy evaluator throws.
- Policy exceptions produce `policy_error`, preserve diagnostic detail, enter the existing denial/refund path, and cannot arm encounter bookkeeping or consume the encounter Ball budget.
- Normal allowed/denied Ball behavior and the existing progression-catch override remain unchanged.
- Adds `rbyBallPolicyErrorSelfTest()` and a Release Safety runtime gate for the policy-error normalization path.
- Fixes `forgiveness.lua` treating any `encounter_states[key]` row as a FAILED projection.
- F. Token recovery now recognizes only `status == "FAILED"` as failed; `CAUGHT`, missing, and unrelated states do not falsely block transaction reconciliation.
- Adds `forgivenessFailedProjectionStateSelfTest()` covering FAILED, CAUGHT, other, missing-status, and nil states.
- Updates World Building catalog certification from five to six exact editions: Red, Blue, Yellow, Gold, Silver, Crystal.
- Removes repeated magic-number edition counts from certification math and derives totals from an explicit exact-edition list.
- The World Building audit now also verifies the exact edition-ID set, not just its count.
- No gameplay tuning, Difficulty profiles, acquisition rules, translation behavior, Randomizer behavior, Save Schema, or public API version changed.

# 2.8.75 — Run History Death Boolean Evidence Fix

- Strict child of exact 2.8.74.
- Fixes `RunHistory.recordDeath()` using Lua `and/or` pseudo-ternary logic for the `shiny` field.
- An explicit caller-supplied `shiny=false` is now preserved exactly.
- Live Pokemon shiny detection is used only when the caller leaves `fields.shiny` unset.
- Adds `RunHistory.deathShinyBooleanSelfTest()`, which supplies a Pokemon that resolves shiny while explicitly recording `shiny=false` and verifies the archived death payload remains false.
- Adds Release Safety guards preventing reintroduction of the broken `and/or` form.
- No gameplay rule, Difficulty, acquisition, transaction, translation, Randomizer, UI, save schema, or public API behavior changed.

# 2.8.74 — Gen-I Gift Provenance Consistency

- Strict child of exact 2.8.73.
- Fixes `MAGIKARP` being omitted from the deterministic common-gift fallback table.
- Source-less compatibility events for the Route 4 gift Magikarp can now be classified as deterministic gift provenance consistently with the authoritative Gen-I gift catalog.
- Adds `acquisitionCatalogConsistencySelfTest()`.
- The self-test derives expectations from `GIFT_LOCATIONS` rather than maintaining another hardcoded list.
- Every version-neutral (`version=nil`) Gen-I gift must resolve as deterministic fallback in Red, Blue, and Yellow.
- Current catalog count: 9 version-neutral gifts.
- The self-test explicitly skips non-Gen-I editions because this catalog is not active there.
- Adds Release Safety guards for the Magikarp fallback and catalog-driven self-test.
- No unrelated acquisition, trade, encounter, toast, UI, Difficulty, Randomizer, translation, save, or API behavior changed.

# 2.8.73 — Transaction Identity + External Item Policy Hardening

- Strict child of exact 2.8.72.
- Gameplay Transaction identity now protects the requested payload in addition to transaction ID and kind.
- New transaction journals store an immutable request-payload fingerprint.
- New committed receipts retain that compact fingerprint.
- Reusing the same ID and kind with a different pending payload now fails with `transaction_payload_mismatch`.
- Reusing the same committed ID and kind with a different payload now fails with `receipt_payload_mismatch`.
- Legitimate crash/reload replay remains allowed when ID, kind, and original request payload match.
- Checkpoint fields may still extend the working transaction payload without invalidating a legitimate replay because the fingerprint represents the original request, not mutable checkpoint state.
- Legacy pre-2.8.73 receipts without a fingerprint remain readable and retain prior compatibility behavior; historical payload detail is not invented.
- Expanded the Gameplay Transaction self-test for pending-payload collision, receipt-payload collision, and legitimate checkpoint replay.
- Repaired the pre-existing future-version self-test fixture so it uses a registered handler and actually reaches the intended `newer_transaction` guard.
- External `ItemAPI.evaluate()` now fails closed if the authoritative item-use policy evaluator throws.
- Policy exceptions return `allowed=false`, `rule/reason/code=policy_error`, preserve the error detail diagnostically, and cannot silently authorize alternate Bag/shortcut/auto-item use.
- Normal allowed and denied item-policy behavior is unchanged.
- If no authoritative item-policy evaluator exists at all, the compatibility fallback remains unchanged.
- Adds Release Safety guards for transaction payload identity and external item-policy fail-closed behavior.
- No gameplay feature, Difficulty profile, translation target, save schema, public API version, or Run History version changes.

# 2.8.72 — Difficulty UX, Silver/Crystal Profiles, and Full Documentation

- Strict child of exact 2.8.71.
- Replaces the Gen1 APPLY/CANCEL textual `>` marker with the native Gen1 cursor glyph so the safe CANCEL default and current confirmation selection are visibly obvious.
- Difficulty Review now keeps profile browsing on directional input and adds paged detail scrolling with SELECT; both Gen1 and Gen2 surfaces show a detail position/hint when more text exists.
- Rewrites the in-game built-in profile summary as concise player-facing information rather than raw internal tuning fields.
- In-game level effects are shown with concrete examples at trainer levels 25 and 50.
- Team upgrade frequency is written as `N OF 100`, avoiding the unavailable native percent glyph.
- Move, AI, DV, held-item, and Badge Boost behavior use plain labels instead of unexplained internal tier-number dumps.
- Difficulty confirmation impact rows no longer render percent signs; trainer-level transitions use concrete level-25 gains and team upgrade transitions use `N/100`.
- Adds exact edition routing for Silver and Crystal. They no longer fall through to Red difficulty catalogs.
- Adds `SILVER POLISHED*`, `SILVER LEGACY*`, `CRYSTAL POLISHED*`, and `CRYSTAL LEGACY*` built-in profiles. These are explicitly conservative Nuzlocke-built edition-focused profiles, not claims of byte-identical historical trainer tables.
- Keeps generic `gen2` identity only as a fail-soft Gold-family fallback after exact Gold/Silver/Crystal checks.
- Adds a full mechanical reference for every built-in difficulty profile to the User Guide: level formula, deterministic team-upgrade selection, BST candidate rules, move tiers, AI tiers/Gen-II bit behavior, Stat EXP tiers, DVs, held items, Badge Boost ownership, and complete profile tables for Red/Blue/Yellow/Gold/Silver/Crystal plus NUZ MEDIUM/VANILLA.
- Adds the project/release rule that in-game Difficulty copy is concise decision support, while full mechanics for every built-in profile must remain documented whenever profile behavior changes.
- Adds Release Safety gates for exact Silver/Crystal routing, native cursor use, scrollable review details, percent-glyph-free player copy, and complete difficulty documentation.
- No Save Schema, Compatibility API, Diagnostics API, Translation API, or Run History version bump.

# 2.8.71 — Gen1 Setup/Profile Runtime Repair + Numeric Rule Audit

- Strict child of exact 2.8.70.
- Fixes the Discord-reported Red/Blue/Yellow Difficulty Review crash.
- Root cause: `NuzlockeDifficultyReview`'s Gen1 draw path called `wrapPixelText`, but that helper is a later local inside the Setup/Rules renderer and is not in lexical scope on the standalone review screen.
- The review screen now renders from its already-computed safe `wrapText` lines; Gold's separate Gen2 path is unchanged.
- Adds explicit R/B/Y rendering for Profile Slot, Save Profile, and Load Profile.
- Profile Slot now visibly shows OFF/1/2/3 and `*` for populated slots.
- Save Profile now visibly shows OFF/SAVE/SAVED/ERROR.
- Load Profile now visibly shows OFF/LOAD/EMPTY/LOADED.
- Gold Load Profile also gains the same visible LOADED success state.
- Audited all 67 catalog numeric rules plus the locke_type numeric descriptor against shared registry coercion.
- Adds Release Safety checks that numeric rules carry valid default/min/max metadata and clamp correctly at both bounds.
- Confirms modern `getConfigValue`/`setConfigValue` use shared `coerceRuleValue`; the older `randomizer_info_policy` missing-branch bug class is not present.
- No gameplay rule semantics, save schema, Randomizer behavior, or compatibility API changed.

# 2.8.70 — Run History v2 Correctness Repair

- Strict child of exact 2.8.69.
- Adds `run.abandoned -> abandons` to the authoritative Run History durable-summary map.
- Existing v2 saves from 2.8.49–2.8.69 backfill `summary.abandons` from the already-persisted `statistics.counters.abandons` when available, preserving abandon totals even if detailed rows were already pruned.
- Rebuilds now restore `stats.counters.abandons` and `stats.flags.abandoned` from durable evidence.
- Replaces catch/death-only partial-detail detection with one `summary_kinds`-driven completeness loop covering catches, deaths, failed encounters, badges, forgiveness awards/uses, blackouts, completions, and abandons.
- Existing materialized v2 statistics are reconciled in place so old saves receive corrected coverage without discarding dimensions or rule-integrity history.
- Live bounded-journal pruning immediately marks statistics coverage `journal_truncated=true`, `detail_complete=false`, and `partial=true`.
- Fixes `storedStateAudit()`'s stale `history.version == 1` assertion. It now compares against `RunHistory.storage_version`, so valid Run History v2 saves no longer spuriously fail Dev diagnostics / Release Safety.
- Adds Release Safety tripwires for durable abandon summaries, summary-driven completeness checks, and dynamic history-version validation.
- Focused regression harness passes complete-detail, each summarized-kind partial case, catch/death baselines, existing-v2 abandon backfill, new abandon append, and live-pruning coverage behavior.
- No gameplay policy, achievement awarding, translation behavior, Randomizer behavior, or save-schema representation changes.
- Save Schema remains 5; Compatibility API remains 35; Diagnostics API remains 1; Translation API remains 2; Run History API/storage remains v2.

# 2.8.69 — Translation Compatibility Consolidation

- Strict child of exact 2.8.68.
- Reconciles the full known translation companion registry after the final discovery sweep.
- Normalizes companion roles as current primary, current alternate, current overlay, legacy, or legacy alternate.
- Adds diagnostic `certificationEligible` metadata without changing Translation API 2 shape or gameplay.
- Fixes the missing `finnish` optional dependency ordering introduced when Finnish was promoted to a current target in 2.8.67.
- Reconciles German edition metadata with the compatibility matrix (R/B/Y/G/S/C).
- Records reviewed non-runtime repositories internally: alternate-Japanese placeholder, Literary Chinese engine fork, Chinese generator tooling, and `VersaoEncarnada` Brazilian fork variant.
- Documents that the final targeted discovery sweep found no concrete current runtime targets for Korean, Traditional Chinese, European Portuguese, Russian, Czech, Swedish, Turkish, or Greek.
- Preserves existing presentation-wrapper and replacement-script mutation policies and all companion-specific LOCAL CERT focus notes.
- No translation is promoted to Runtime PASS by this build.
- Save Schema 5, Compatibility API 35, Diagnostics API 1, Translation API 2 and Run History v2 remain unchanged.

# 2.8.68 — Alternate Spanish Compatibility

- Strict child of exact 2.8.67.
- Adds `spanish_translation` 0.1.0 as a separate alternate Spanish Red target.
- Preserves `traduccion_es` 0.1.0 as the existing primary Spanish target.
- Records fork lineage from `versaovermelha` and source text from `einstein95/pokered-es`.
- Records direct Battle UI presentation overrides and confirmed-loaded replacement map scripts.
- Reuses `translation_presentation_wrapper` and `translation_replacement_script_mutation`.
- Adds focused LOCAL CERT guidance for battle UI, Museum payment, and Bike Voucher/Bicycle exchange.
- No Spanish display literal becomes gameplay semantics.
- No API/schema bump.

# 2.8.67 — Finnish Translation Compatibility

- Strict child of exact 2.8.66.
- Promotes `finnish` 0.1.0 from `upstream_unverified` to the current reviewed Finnish target.
- Uses a conservative Red-only edition scope from upstream documentation.
- Records fixed-cell extended-Latin glyph support for ä/ö/å and uppercase variants, naming-grid customization, and intentional mixed Finnish/English fallback.
- Records invasive but presentation-only layout overrides across choice boxes, battle UI, stat box, bindings, Bill's PC overlay, ListMenu, Move Learn, and Trainer Card.
- Records replacement map scripts as both present and explicitly loaded.
- Marks `mutationReviewRequired=true` and reuses the existing `translation_presentation_wrapper` and `translation_replacement_script_mutation` contracts.
- Adds focused LOCAL CERT guidance for the major Finnish UI overrides plus Museum and Bike Shop mutation seams.
- No Finnish display literal becomes gameplay semantics.
- Save Schema 5, Compatibility API 35, Diagnostics API 1, Translation API 2 and Run History v2 remain unchanged.

# 2.8.66 — Dutch Translation Compatibility

- Strict child of exact 2.8.65.
- Adds `translation-nl` 0.0.2 as the current Dutch translation target for Red and Blue.
- Records its generated-content architecture, `>=0.0.0-dev` emitted engine range, ASCII-folded accent model, lack of localized donor font, and intentional English fallback.
- Records reviewed coverage metadata: ROM 3106/3106, RBY engine strings 285/383, all engine strings 290/533.
- Marks Dutch replacement map scripts as both present and **known loaded** by the generated runtime.
- Marks `mutationReviewRequired=true` and reuses the generalized `translation_replacement_script_mutation` contract from 2.8.63.
- Adds Dutch LOCAL CERT focus for museum payment, Bike Voucher/Bicycle exchange, and mixed Dutch/English fallback.
- No Dutch display literals become gameplay semantics.
- Save Schema 5, Compatibility API 35, Diagnostics API 1, Translation API 2 and Run History v2 remain unchanged.

# 2.8.65 — Simplified Chinese Compatibility + Presentation Wrapper Contract

- Strict child of exact 2.8.64.
- Adds `zh_cn` 0.3.1 as the primary Simplified Chinese translation target for Red, Blue, and Yellow.
- Records the reviewed upstream engine range `>=0.1.56 <1.0.0`.
- Records its fixed-cell CJK model: eight custom glyph pages / 1,995 reviewed glyphs.
- Records its narrow engine-gap presentation wrappers around dynamic `script.command` substitutions, naming/options rows, `Strings.get`, `Font.draw`, and `OptionRows.draw`.
- Adds a generalized `translation_presentation_wrapper` semantic compatibility contract: translation presentation wrappers must be narrow, compositional, identity-safe, gameplay-neutral, and must not become a dependency of Nuzlocke-owned UI.
- Nuzlocke-owned screens remain responsible for their own `Strings(...)`, semantic state, and generalized glyph-safe fitting rather than depending on caller-path or fixed-coordinate translation heuristics.
- Dev localization diagnostics now identify fixed-cell CJK companions, engine-internals presentation wrappers, and companion-specific LOCAL CERT focus notes.
- Adds Chinese-focused runtime emphasis for stat/status labels, starter/gift names, badge substitutions, Options footer, Party/Summary status labels, and mixed CJK/numeric alignment.
- Documents Literary Chinese `gen1recomp-lzh` as an engine-fork/alternate-distribution audit target rather than a normal companion.
- Does not add the Chinese generator/tooling repository as a runtime companion.
- No Chinese display literal becomes gameplay policy.
- Save Schema 5, Compatibility API 35, Diagnostics API 1, Translation API 2 and Run History v2 remain unchanged.

# 2.8.64 — Polish Translation Compatibility

- Strict child of exact 2.8.63.
- Adds `recomp-polish` 1.0.0 as the current Polish translation target.
- Uses a conservative Red-only compatibility scope because upstream documentation identifies Pokémon Red but does not provide enough evidence to transfer support to Blue/Yellow/Gen II.
- Records its fixed-cell extended-Latin glyph architecture and intentional partial English fallback behavior.
- Records that generated replacement map scripts are present in the repository and can perform gameplay mutations, while keeping runtime loading explicitly **unconfirmed**.
- Marks the Polish target `mutationReviewRequired=true`, reusing the generalized replacement-script mutation policy from 2.8.63.
- Dev localization diagnostics distinguish known-active replacement scripts from scripts that are merely present in source but not confirmed loaded.
- Adds optional dependency ordering and compatibility-matrix coverage.
- No Polish display literals become gameplay policy.
- Save Schema 5, Compatibility API 35, Diagnostics API 1, Translation API 2 and Run History v2 remain unchanged.

# 2.8.63 — Italian Translation Compatibility + Replacement Script Policy

- Adds `translation-it` 0.6.0 as the primary Italian Red/Blue/Yellow target.
- Adds `recomp-italian` 0.1.0 as a distinct alternate/legacy beta target.
- Records `translation-it`'s proportional font, presentation wrappers, and generated replacement map scripts.
- Adds a generalized semantic-enforcement contract for translation/content replacement scripts that perform gameplay mutation.
- Replacement scripts must preserve native Nuzlocke-gated entrypoints or call semantic policy before mutation.
- Dev localization diagnostics now flag companions that require replacement-script mutation review.
- No Italian gameplay literals or language-specific rule branches added.
- Save Schema 5, Compatibility API 35, Diagnostics API 1, Translation API 2, Run History v2 unchanged.

# 2.8.62 — Localization Runtime Certification Tooling

- Strict child of exact 2.8.61.
- Adds a **LOCAL CERT** page to DEV REPORT for exact-combination translation runtime testing.
- Certification identity is keyed to the active game edition plus detected translation companion IDs, versions, activity state, boot language, pending language, restart state, and companion-reported edition when available.
- Adds a fixed 10-surface runtime checklist:
  - Setup / NUZ RULES
  - NUZ STATUS / ENC TRACKER
  - Battle denial
  - Mart BUY / SELL
  - Party / NUZ INFO
  - Move Learn / Rare Candy
  - F. TOKEN / Forgiveness
  - Randomizer labels
  - World Building text
  - Dev Report / Localization
- Tester controls on LOCAL CERT:
  - Up/Down selects a check.
  - A cycles `UNTESTED → PASS → FAIL → UNTESTED`.
  - Left/Right changes Dev Report section.
- Certification state is **session-only Dev memory**. It never writes to the Nuzlocke/game save.
- Static diagnostics never auto-mark a check PASS.
- `certified=true` is only possible when a translation companion is present, all 10 checks are manually completed, and none are FAIL.
- Generates a compact exact-combination summary such as `RED / translation-ja-hrkt 0.4.2 / 10 checks / 8 PASS / 0 FAIL / 2 UNTESTED`.
- Adds the manual certification state to the structured Bug Report Snapshot and full text Dev report.
- Adds internal Dev export functions for reading, marking and resetting the current session certification ledger.
- Adds Translation API 2 source discovery for the certification UI/check labels; public API shape remains unchanged.
- No gameplay, save representation, translation ownership, Randomizer, encounter, or rule changes.
- Save Schema remains 5; Compatibility API remains 35; Diagnostics API remains 1; Translation API remains 2; Run History remains v2.

# 2.8.61 — Japanese-Driven Byte/FIxed-Column UI Audit

- Strict child of exact 2.8.60.
- Exposes the existing `nuzGlyphSpans`, `nuzGlyphLen`, and `nuzGlyphSlice` helpers internally under `mod.exports.__beta26` so split Nuzlocke UI/adapters use one glyph-boundary implementation.
- Fixes the optional Gen-II Pokegear Cards integration's remaining `#text` / `text:sub(...)` truncation. It now uses shared glyph length/slicing with UTF-8 fallback.
- Routes Pokegear-authored labels through its injected translation callback instead of concatenating untranslated English fragments.
- Replaces remaining player-facing classic UI byte slicing for recovery species names, NUZ STATUS compact area/event strings, Run History details, Move Info names, and contained error messages with glyph/pixel-safe fitting.
- Replaces Gen-II centered-bold `#label` centering with actual rendered-width fitting/centering.
- Fixes Gen-II contained NUZ STATUS error clipping to preserve multibyte character boundaries.
- Routes compact Gen-II status templates through `Strings(...)`.
- Expands Translation API 2 source discovery with Pokegear Cards labels and compact Gen-II status templates.
- Retains byte slicing only where data is explicitly ASCII/internal (for example hash fragments/version normalization), not localized player text.
- No gameplay policy, Randomizer semantics, encounter state, save representation, or translation ownership changes.
- Save Schema remains 5; Compatibility API remains 35; Diagnostics API remains 1; Translation API remains 2; Run History remains v2.

# 2.8.60 — Japanese / CJK Compatibility

- Strict child of exact 2.8.59.
- Adds `translation-ja-hrkt` 0.4.2 as the current explicit Japanese compatibility target for Red and Blue.
- Records its engine Plain Pixel TTF ownership model, ROM-import requirement, partial engine-string fallback behavior, and fixed-cell kana behavior.
- Adds the Japanese target to optional companion ordering and the formal translation compatibility matrix.
- Retains and Release-Safety-protects Nuzlocke's generalized glyph-span helpers: engine `Font.split` first, UTF-8 code-point fallback second.
- Adds Japanese-specific static guards against gameplay matching on localized battle/menu literals.
- Documents the Japanese runtime matrix with special attention to mixed CJK/Latin fallback, numeric tile alignment, wrapping/truncation, party/move names and Nuzlocke-owned UI.
- No Japanese translation assets or catalogs are bundled.
- No Save Schema, Compatibility API, Diagnostics API, Translation API or Run History bump.

# 2.8.59 — Translation Matrix + Source Catalog Consolidation

- Strict child of exact 2.8.58.
- Adds a formal translation compatibility matrix to `docs/COMPATIBILITY.md`, reconciling every currently tracked translation identity, reviewed version, role, edition scope, status, and runtime-certification state.
- Matrix explicitly distinguishes source/static compatibility from exact-combination Runtime PASS evidence.
- Adds Release Safety tying the matrix back to the live known-companion registry so tracked translation identities cannot silently disappear from documentation.
- Expands Translation API 2 source discovery for the complete high-value Forgiveness/F. TOKEN flow, including revive/reroll screens, confirmation/error messages and transaction outcomes.
- Adds Battle Clause authored denial messages to source discovery. Rule enforcement remains semantic; only the player-facing explanation is translatable.
- Adds additional common Nuzlocke status/compatibility/runtime labels such as NUZ INFO, MOD COMPAT, PROVIDER, LEGALITY, RECOVERY, buying/selling/item-use denials and Rare Candy safety messages.
- No translation content is bundled. No per-language gameplay branches are added.
- Save Schema remains 5; Compatibility API remains 35; Diagnostics API remains 1; Translation API remains 2; Run History remains v2.

# 2.8.58 — French Translation Compatibility

- Strict child of exact 2.8.57.
- Adds generated **Translation French** (`translation-fr`) as an explicit optional compatibility target, reviewed against translation-generator release **0.8.0**.
- Records the current French generator target as supporting Red, Blue, Yellow, Gold, Silver, and Crystal.
- Adds **Traduction FR etendue** (`trad-fr-extended`) as a separate optional compatibility target, reviewed against current version **0.2.0**.
- The extended overlay remains distinct from the base translation and declares `translation-fr` as its required companion.
- Adds explicit optional dependency ordering for both French targets.
- The base generated translation remains a content/localization companion; Nuzlocke does not treat it as a gameplay provider.
- Current generator v0.8.0 uses the normal Gen1Recomp translation/content model and now includes Crystal support plus Gold/Silver translation coverage improvements.
- Current generated Latin-language builds use a proportional Fusion Pixel TTF by default, making the 2.8.56 glyph/VWF hardening directly relevant to French.
- The FR Extended overlay does not register a competing font. It fills engine-string and Pokédex-kind gaps after the base translation and relies on last-writer-wins content ordering.
- No French `ACHETER`, `VENDRE`, `FUITE`, `ATTAQUE`, or other display literals are introduced into Nuzlocke gameplay policy.
- Translation API remains 2; no Save Schema, Compatibility API, Diagnostics API, or Run History API bump.
- Runtime combination certification remains required.

# 2.8.57 — Spanish Translation Compatibility

- Strict child of exact 2.8.56.
- Adds **Traduccion Espanola** (`traduccion_es`) as an explicit optional compatibility target, reviewed against current version **0.1.0**.
- Adds `traduccion_es` to optional dependency ordering so composition with Nuzlocke is explicit rather than relying on equal-priority discovery order.
- Records the current translation as a content/LANGUAGE companion rather than a gameplay owner.
- The reviewed Spanish mod has no `mod.exports` compatibility API, no `BattleState` wrapper, and no general hook ownership. It composes primarily through Gen1Recomp content registries.
- Its hand-authored engine `strings` catalog remains active without a Spanish EUR cartridge dump.
- Its cartridge-derived dialogue, names, types, Dex metric data, accent glyphs, HUD sheets and version ribbon require a matching Spanish Red/Blue EUR cartridge in `imports/`.
- The cartridge layer is explicitly Red/Blue-only. Yellow currently has no Spanish cartridge spec; Nuzlocke does not claim Yellow Spanish runtime certification from this target.
- Nuzlocke's Translation API 2 treats an installed `traduccion_es` companion as an active translation companion, while its own fallback diagnostics continue to reveal Nuzlocke-specific strings that remain English.
- Nuzlocke does not probe the companion's private `missingDump` local or inspect the user's ROM files. Full/partial Spanish coverage remains the translation mod's own responsibility.
- No Spanish `COMPRAR`, `VENDER`, `HUIR`, `LUCHAR`, or other display literals are introduced into Nuzlocke gameplay policy.
- No Save Schema, Compatibility API, Diagnostics API, Translation API, or Run History API bump.
- Runtime combination certification remains required.

# 2.8.56 — Long-String/VWF Localization Hardening

- Strict child of exact 2.8.55.
- Hardens the shared Nuzlocke UI typography fitter to prefer engine glyph spans (`Font.split` / `Font.spansFitting`) rather than byte-by-byte truncation.
- Adds UTF-8-boundary-safe fallback truncation when glyph spans are unavailable.
- Hardens shared Gen-I and Gen-II two-column Nuzlocke rows so a long translated value is fitted before right-alignment; translated values can no longer push their draw origin off-screen before clipping.
- Hardens the player-visible Dev Report wrapper so long diagnostic IDs/translation names are split by glyph boundaries rather than arbitrary bytes.
- Bounds compact Gen-II NUZ STATUS summary rows with the existing glyph-aware marquee helper instead of allowing translated summary text to overrun the 20-column frame.
- Expands Translation API 2 source discovery to the complete live World Building authored catalog (`t1`, `t2`, `kanto`, `johto`) while preserving canonical rule keys.
- Adds World Building dynamic templates (`Allowed`, BST/Limit, generic catch rejection) to source discovery.
- Type Lock rejection detail now resolves each displayed type label through `Strings` before composing the translated template.
- Adds Randomizer active-status templates and option/value labels to Translation API 2 source discovery.
- Randomizer status templates now resolve inserted option labels through `Strings`, so translating the outer template no longer leaves values such as CHAOS/BALANCED/ANY untranslated.
- No Randomizer seed, mapping, RNG stream, legality, World Building policy, encounter state, or UI ownership behavior changes.
- Save Schema remains 5; Compatibility API remains 35; Diagnostics API remains 1; Translation API remains 2; Run History remains v2.

# 2.8.55 — Generalized Localization Catalog + Diagnostics

- Strict child of exact 2.8.54.
- Expands the existing **Nuzlocke Translation API 2** source catalog with a first high-value batch of Nuzlocke-authored UI strings that were already routed through `Strings(...)` at runtime but were not discoverable through `nuzlocke_translation.sources()`.
- New discoverable groups include:
  - NUZ STATUS labels (`RUN STATUS`, `CAUGHT`, `LOST ENC.`, `DEATHS`, area/token/cap labels);
  - common tracker/history states (`OPEN`, `CAUGHT`, `FAILED`, `DIED`, `NONE`, `UNKNOWN`);
  - Encounter Log / Area Guide titles and footer controls;
  - tracker summary templates (`NEXT CAP`, OPEN/CAUGHT/FAILED summary, entry count, RNG/type detail);
  - high-tier Nuzlocke-over/death summary templates.
- Runtime behavior of these strings is unchanged: they continue to resolve through the engine `Strings` system. The change makes the stable source keys discoverable to translation tooling instead of requiring translation authors to grep UI code.
- Adds read-only `Dev.localizationDiagnostics()`:
  - installed translation companion count;
  - active translation count;
  - restart-required count;
  - total discoverable Nuzlocke source count;
  - current source-resolves-to-itself fallback count;
  - resolved count and per-kind coverage;
  - companion lifecycle rows with boot/pending language and edition where available.
- A source resolving to exactly the same text is counted as a fallback-like source for diagnostics. This is a translation-author aid, not proof that a same-text translation is missing.
- Adds **LOCALIZATION** to Dev System Health, the compact Bug Report Snapshot systems list, full text Dev reports, and the player-visible DEV REPORT dashboard.
- Localization incompleteness does **not** automatically fail System Health. Active translation with fallback sources remains informational/OK; a pending restart is surfaced as WARN.
- No language is switched, no translation catalog is installed, and no companion state is mutated by the diagnostics.
- Existing Brazilian and German Universal compatibility remains unchanged.
- Save Schema remains 5; Compatibility API remains 35; Diagnostics API remains 1; Nuzlocke Translation API remains 2; Run History remains v2.

# 2.8.54 — German Universal Translation Compatibility

- Strict child of exact 2.8.53.
- Adds **Translation German Universal** (`translation-german-universal`) as an explicit optional compatibility target, reviewed against stable release **0.2.0**.
- Advances the dedicated `nuzlocke_translation` API from **1 → 2**. This is independent from Compatibility API 35.
- Translation diagnostics now distinguish **installed** from **actively translating**.
- Toggle-aware companions may expose:
  - `bootLanguage`
  - active `edition`
  - `pendingLanguage(game)`
  - `restartRequired(game)`
- Detection now reports `translationActive`, `activity`, `bootLanguage`, `pendingLanguage`, `restartRequired`, and `edition` when available.
- For Translation German Universal, English boot mode is treated as installed-but-inactive rather than as an active German localization.
- Pending language changes can report `restart_required` without pretending the currently materialized language changed live.
- Translation detection remains descriptive only; it does not grant gameplay-rule ownership or alter Nuzlocke rules.
- Adds explicit optional dependency ordering for `translation-german-universal`.
- Adds Release Safety coverage protecting canonical encounter-area identity from localized display names: internal/persisted area keys remain canonical IDs, while localized names stay presentation-only.
- Existing Brazilian targets remain unchanged.
- No Gen-I/Gen-II battle, party, Trainer Card, ChoiceBox, Chrome, Pokédex, asset, or translation code from the external mod is copied or owned by Nuzlocke.
- Save Schema remains 5; Compatibility API remains 35; Diagnostics API remains 1; Run History remains v2.

# 2.8.53 — Compatibility Ownership + Transaction/Run-History Hardening

- Strict child of exact 2.8.52.
- Fixes `public_interop.resolveCapability()` so providers advertising a capability but explicitly marked `enabled=false`, `active=false`, or `disabled=true` remain detected/advertised but cannot become the selected/preferred owner.
- Active explicit providers still outrank active automatic providers; deterministic provider-ID ordering is preserved inside each tier.
- If only inactive providers advertise a capability, `capabilityStatus()` now reports `external_advertised_inactive` / degraded with no selected owner, allowing Nuzlocke fallback gameplay ownership to resume.
- Fixes Compatibility API 35 snapshots so aliases are canonicalized before insertion into the capability set. A provider advertising both an alias and its canonical form now produces one canonical snapshot row/count.
- Hardens the Gameplay Transaction Coordinator so journal creation and recovery use the single authoritative `TX.api` version constant instead of duplicated literal `1`s.
- Fixes `RunHistory.recordDeath()` so an explicit `critical=false` is preserved rather than falling through to `mon.deathCritical`.
- Adds Release Safety guards for all four contracts.
- No provider capability is added/removed, no public Compatibility API shape is extended, and no save representation changes.
- Save Schema remains 5; Compatibility API remains 35; Diagnostics API remains 1; Run History remains v2.

# 2.8.52 — Dev SHINY Default Readout Fix

- Strict child of exact 2.8.51.
- Fixes `DEV REPORT > SHINY` default readout for `shiny_colors` and `shiny_intro`.
- Both rules default to ON in the authoritative Rule Catalog and runtime; the diagnostic had incorrectly used `false` as the fallback for unset save keys.
- Fresh/default saves now correctly report `COLORS: ON` and `INTRO: ON` when Nuzlocke owns shiny presentation.
- External-provider ownership reporting remains unchanged (`EXTERNAL` still takes precedence in the SHINY panel).
- Adds a Release Safety guard requiring Dev diagnostic fallbacks to match the Rule Catalog defaults.
- No shiny generation, identity, recoloring, intro/sparkle behavior, provider ownership, rules, RNG, save data, or UI ownership changes.
- Save Schema remains 5; Compatibility API remains 35; Diagnostics API remains 1; Run History remains v2.

# 2.8.51 — False-Value Transaction Preservation

- Strict child of exact 2.8.50.
- Fixes one shared Lua `and/or` false-value preservation defect across schema migration and durable gameplay transaction primitives.
- `save_migration.lua` shadow-store snapshots now preserve a present literal `false` instead of collapsing it to `nil`.
- `save.set_exact` durable transaction snapshots now preserve a pre-transaction `false`.
- `save.set_exact.perform()` now preserves an intended post-transaction `false` instead of writing `nil`.
- Schema migration apply, rollback, failing-row rollback, and prior-applied-row rollback now select presence/value explicitly and preserve `false`.
- Adds Release Safety tripwires against reintroducing the vulnerable presence/value `and/or` idiom.
- Adds focused regression validation for `false -> true`, `true -> false`, `absent -> false`, `false -> absent`, interrupted exact-value recovery, and schema migration rollback.
- No rule behavior, defaults, deterministic namespaces, compatibility ownership, Randomizer algorithm, or UI behavior intentionally changes.
- Save Schema remains 5; Compatibility API remains 35; Diagnostics API remains 1; Run History remains v2.

# 2.8.50 — Brazilian Translation Compatibility Hardening

- Strict child of exact 2.8.49.
- Adds current Brazilian Portuguese translation **VersaoVermelha** (`versaovermelha`) as a separate explicit compatibility target, reviewed against stable release **0.2.5**.
- Retains legacy `gen1_pt-br` as its own historical compatibility identity; it is not silently aliased to or replaced by VersaoVermelha.
- Adds `versaovermelha` to optional dependency ordering so load composition is explicit when both mods are installed.
- Generalizes translation diagnostics away from `id == "gen1_pt-br"` checks. Any known translation companion exporting compatible presentation signals can now report:
  - native Trainer Card override (`trainer_card`)
  - inventory price/quantity line layout (`precos_linha`)
  - move-language mode (`idioma_golpes`)
  - enemy-label option (`mostrar_inimigo`)
- Fixes the R/B/Y Forgiveness Token shop-list filter so it no longer uppercases the displayed menu title and compares it to English `BUY` / `SELL`.
- Shop classification now prefers semantic ListMenu metadata (`kind`, `shopKind`, `action`, `semanticKind`) and falls back only to the canonical localized `Strings("BUY")` / `Strings("SELL")` source values.
- No Portuguese-specific `COMPRAR` / `VENDER` literals are added.
- Nuzlocke gameplay policy remains language-neutral; translation detection does not grant gameplay ownership.
- Current VersaoVermelha presentation ownership remains external: native Trainer Card layout, native Gen-I battle text-area layout, Move Learn layout, ListMenu price/quantity positioning, party submenu label presentation, and title rendering remain the translation mod's responsibility.
- Nuzlocke retains its own NUZ STATUS/rules/tracker state and uses compositional engine hooks rather than copying or replacing translation code.
- Save Schema remains 5; Compatibility API remains 35; Diagnostics API remains 1.
- Runtime combination certification is still required.

# 2.8.49 — Run History v2 / Achievement Evidence

- Strict child of exact 2.8.48.
- **No achievement system is enabled yet.** This build records durable background evidence so future achievements can evaluate runs retroactively where the evidence is complete.
- Run History advances from public/storage API **1 → 2** inside the existing Nuzlocke Save Schema 5.
- The detailed Run History journal remains bounded to 512 rows, but a separate durable `statistics` ledger is updated before pruning.
- Durable lifetime counters cover catches, deaths, failed encounters, badges, forgiveness awards/uses, blackouts, completions, shiny catches/deaths, and arbitrary event-kind totals going forward.
- Durable dimensions retain achievement-useful facts such as catch/death/failed-encounter species, catch encounter type/source, death cause/opponent species, badge identity, forgiveness mode, and completion target.
- First/last core event facts and boolean flags (`caught_shiny`, `had_death`, `had_failed_encounter`, `used_forgiveness`, `blacked_out`, `completed`, etc.) are retained independently from detailed journal pruning.
- Run rule-integrity evidence stores the rule values present when achievement coverage starts, last observed values, and every live Nuzlocke configuration key changed through the central `setConfigValue` path.
- Failed encounters now append a deduped `encounter.failed` Run History event at the already-authoritative `markEncounterFailed` transaction boundary.
- Existing Run History v1 data migrates in place to v2 without discarding its journal/summary. Legacy summary/baseline counts are preserved exactly; details that cannot be proven from retained rows are explicitly marked **partial** rather than guessed.
- `nuzlocke_run_history` advances to API 2 and exposes read-only `statistics()` / `achievement_evidence()` plus the existing list/report/record surface.
- Release Safety now runs Run History integrity and protects v2 evidence, failed-encounter capture, rule-change evidence, and the unchanged global Save Schema 5.
- Compatibility API remains 35; Diagnostics API remains 1; Randomizer algorithm remains 1.

# 2.8.48 — Compatibility API 35 + Gen1Recomp 0.2.29 Audit

- Strict child of exact 2.8.47.
- Advances **Compatibility API 34 → 35**. `compatible_from` remains 10.
- API 35 formally versions the additive semantic compatibility introspection already shipped in the current implementation:
  - `providerStatus(id)`
  - `capabilityStatus(capability)`
  - `compatibilitySnapshot()`
- API-34 rule availability/dependency contracts remain unchanged and available.
- **Save Schema remains 5**; this build makes no persisted-format change and needs no migration.
- Advances the source/documentation-audited Gen1Recomp marker from **0.2.27 → 0.2.29** while keeping the manifest engine range `>=0.2.24 <2.0.0`.
- Adds explicit engine profiles for **0.2.28** and **0.2.29**.
- 0.2.28 audit: only `HostShell.lua` plus iOS release metadata changed from 0.2.27. The HostShell change normalizes subprocess commands through `HostShell.shellCommand(...)`; no Nuzlocke gameplay/mod-hook seam changed.
- 0.2.29 audit: changes are confined to `GamepadMap.lua`, `RomImporter.lua`, `Kit.lua`, `VirtualKeyboard.lua`, plus iOS metadata. Relevant changes restore raw L2/R2 trigger mapping/scrolling and scope the on-screen VirtualKeyboard to Linux handhelds.
- No battle, Pokémon construction, hook registry, Strings, Chrome, Gen-II gameplay, save, shiny, or Randomizer-consumed data seam changed in 0.2.28/0.2.29.
- Existing 0.2.27 `catch.nickname`, Chrome/palette, shiny, Gen-II native battle ownership, and compatibility fallbacks remain the applicable gameplay contract.
- Release Safety now promotes the 0.2.29 audited marker/profile set, retained 0.2.27 gameplay seams, source-revalidated Gen-II shiny-flash boundary, and Compatibility API 35 semantic-status surface.
- No new exact-edition runtime certification is claimed.

# 2.8.47 — Documentation / Release Reconciliation

- Strict child of exact 2.8.46.
- Documentation-only/release-metadata pass; no challenge-rule, encounter, battle, Randomizer generation, shiny generation/presentation, save-schema, transaction, or provider-ownership behavior is intentionally changed.
- Adds an authoritative current-release contract to README, USER_GUIDE, and API docs so historical notes no longer masquerade as current support/API requirements.
- Reconciles current values to the executable/manifest:
  - Gen1Recomp manifest range `>=0.2.24 <2.0.0`
  - source/documentation audit marker 0.2.27
  - Mod API 2
  - Save Schema 5
  - Compatibility API 34
  - Diagnostics API 1
  - Randomizer algorithm 1
  - manifest games Red/Blue/Yellow/Gold/Silver/Crystal
  - R/B/Y mature baseline, Gold/Silver beta, Crystal alpha
- Documents the current nine-subsystem Randomizer ownership registry: Starter, Encounters, Field Items, Learnsets, Trainers, Evolutions, Shops, TMs, and Gift Items.
- Corrects stale Random Field Items prose: native Gen II hidden/BG-event items are supported when explicitly marked Nuzlocke-owned; arbitrary third-party hidden sources are not claimed.
- Corrects stale shiny-control wording so external ownership applies to the active edition rather than Gen I only.
- Reconciles selected shared Gen-II rule descriptions from Gold/Silver wording to Gold/Silver/Crystal where the rule metadata/implementation is shared across all six manifest editions.
- Clarifies that optional compatibility identities are optional and that detection/advertising is distinct from selected ownership.
- Retains historical release/API notes but labels them historical so their older support/API numbers are not read as the 2.8.47 contract.

# 2.8.46 — Dev Rule Consistency + Save/Run Identity + Ownership History

- Strict child of exact 2.8.45.
- Adds **DEV REPORT > RULE CONFIG**.
- Uses the authoritative Rule Registry's read-only stored-value validation plus registry/availability audits.
- Reports invalid/stale persisted values, rule-definition/descriptor mismatches, and non-default child settings currently dormant because a prerequisite/superseding parent makes them operationally inactive.
- RULE CONFIG never coerces, rewrites, enables, disables, or repairs a rule.
- Adds **DEV REPORT > SAVE/RUN**.
- Compares active edition/generation/profile scope and current Save Schema against playthrough storage context, raw Run History identity, and an existing Randomizer run snapshot when present.
- Reports mismatches only; it never initializes/repairs Run History, storage, profile, Randomizer, or save state.
- Adds **DEV REPORT > OWNER HISTORY**.
- Keeps a bounded 32-row, session-only history of observed capability-owner/state transitions while Dev diagnostics inspect compatibility state.
- Provider history never selects, unregisters, reprioritizes, or reclaims a provider.
- System Health and Bug Report Snapshot aggregate all three new diagnostics.
- Public `nuzlocke_dev` adds `rule_configuration_consistency(game)`, `save_run_identity_health(game)`, and `ownership_history(limit)`.
- Release Safety promotion-gates all three passive contracts and pages.
- No gameplay, rule enforcement, save schema, encounter, Randomizer, shiny, transaction, or compatibility-ownership behavior is intentionally changed.

# 2.8.45 — Dev Severity Coalescing + Performance Counters

- Strict child of exact 2.8.44.
- Dev breadcrumbs now carry explicit `INFO / WARN / ERROR` severity.
- Consecutive identical WARN/ERROR breadcrumbs coalesce into one bounded row with `count` and `lastSeq` instead of flooding the 48-entry ring.
- Semantic rule decisions now carry severity; consecutive identical warning/error-class decisions also coalesce in the bounded 32-entry decision ring.
- The Bug Report Snapshot and public breadcrumb/decision diagnostics retain coalesced count/severity metadata.
- Adds cheap in-memory Dev-only performance counters and **DEV REPORT > PERFORMANCE**.
- Initial counters cover Randomizer encounter-evolution profile builds, learnset projections, trainer primary composition, and final trainer composition.
- Counters increment only while Nuzlocke Dev Mode is enabled and never persist to the save.
- System Health and Bug Report Snapshot include a performance summary.
- Release Safety guards severity coalescing, Dev-only counter ownership, and the PERFORMANCE page.
- No gameplay, rule, RNG, Randomizer mapping, shiny, encounter, save-schema, transaction, or compatibility behavior is intentionally changed.

# 2.8.44 — Dev Shiny + Randomizer Reproducibility Diagnostics

- Strict child of exact 2.8.43.
- Adds **DEV REPORT > SHINY**: owner/provider/version, configured rate, Colors/Intro ownership, and already-materialized current/last enemy shiny identity/source.
- SHINY diagnostics never roll odds, request sprites/palettes, or change provider ownership.
- Adds **DEV REPORT > RANDOM REPRO** using the existing read-only Randomizer reproducibility report.
- Reports fixed/AUTO mode, already-resolved/shareable seed when present, algorithm/run schema, reproducibility state, mid-run settings drift, ownership metadata, and materialized source-map cardinalities.
- RANDOM REPRO never resolves an unset AUTO seed, advances RNG, or materializes unseen mappings.
- System Health and BUG REPORT aggregate both new diagnostics.
- Public `nuzlocke_dev` adds `shiny_diagnostics(game)` and `randomizer_reproducibility(game)`.
- Release Safety guards both diagnostics and their DEV REPORT pages.
- No gameplay, shiny generation/presentation, Randomizer generation/mapping, save-schema, or compatibility-ownership behavior is intentionally changed.

# 2.8.43 — Dev Transaction Health + Hook Drift

- Strict child of exact 2.8.42.
- Adds **DEV REPORT > TRANSACTIONS**, a read-only gameplay-transaction health view.
- Reports transaction API/handler counts, bounded receipt usage, pending journal id/kind/state/detail/build, durable sequence namespace count, last committed receipt, and the fail-closed `probe_or_refuse` recovery policy.
- Adds **DEV REPORT > HOOK DRIFT**, a read-only view of Nuzlocke's registered wrapper/hook surfaces.
- Distinguishes `OK`, `DRIFT`, and `N/A`; drift means another layer interposed/replaced the direct wrapper after registration and is reported rather than reclaimed.
- System Health now includes a HOOKS row and richer TRANSACTIONS detail.
- BUG REPORT snapshot now includes transaction-health and hook-drift summaries.
- Public `nuzlocke_dev` adds `transaction_health()` and `hook_wrapper_drift()`.
- Release Safety promotion-gates both diagnostic surfaces and their player-facing pages.
- No gameplay, rule, Randomizer, shiny, encounter, save-schema, transaction-execution, or compatibility-ownership behavior is intentionally changed.

# 2.8.42 — Dev Mode bug-report snapshot

- Strict child of exact 2.8.41.
- Adds a read-only **BUG REPORT** page to DEV REPORT.
- Aggregates build/parent, edition/generation/engine family, profile/save/run identity, overall System Health, provider ownership counts, current encounter provenance, recent rule decisions, current warnings/errors, and the latest bounded breadcrumbs.
- Exposes the same structured snapshot through `mod.exports.nuzlocke_dev.bug_report_snapshot(game)`, including a compact `text` representation suitable for logging/sharing.
- The snapshot is observational only: it does not run the Dev self-test, invoke rule decisions, resolve AUTO seeds, consume RNG, repair save state, mutate encounters, or alter transactions.
- Release Safety now promotion-gates the snapshot API and player-facing BUG REPORT page.
- No gameplay, rule, Randomizer, shiny, encounter, save-schema, or compatibility-ownership behavior is intentionally changed.

# 2.8.41 — Dev Mode semantic diagnostics

- Strict child of 2.8.40.
- Adds a read-only **SYSTEM HEALTH** summary across engine/hooks, save safety, rules, encounter state, battle lifecycle, Randomizer, providers, shiny ownership, UI health, and gameplay transactions.
- Adds detailed provider/capability ownership diagnostics that distinguish detected/advertised providers from the selected owner and Nuzlocke fallback.
- Adds read-only live encounter provenance inspection: projected area, physical source, species, source/provider, eligibility, spend/free reason, clause state, area state, and shiny identity.
- Adds a bounded semantic rule-decision trace for core catch, item-use, buying, and selling denials. The trace records decisions after they occur and never invokes rules, RNG, or state repair.
- DEV REPORT gains HEALTH / PROVIDERS / ENCOUNTER / DECISIONS sections.
- Adds Release Safety guards for all four new diagnostic surfaces.
- No intentional gameplay, rule, encounter, Randomizer, shiny, save-schema, or provider-ownership behavior change.

# 2.8.40 — Release Safety/static regression expansion

- Strict child of exact 2.8.39 (`66716c8b580329072527684c07c3c426f3254adcb82bfac23a4345e4cd793e68`).
- No gameplay/rule, shiny, Randomizer, save-schema, encounter, or compatibility ownership behavior change intended.
- Adds a promotion-facing recurring-regression bundle protecting native Gen II battle/party ownership and retired PartyMenu wrappers.
- Adds explicit static protection for shiny single-owner failover and the rule that Nuzlocke never invalidates engine Renderer/Assets/PaletteFX resources.
- Adds a Rare Candy transaction-journal structural tripwire covering fresh attempt ids, durable native-effect checkpoints, and fail-closed external mutation recovery.
- Adds battle.started dual-payload-shape protection and Randomizer performance-tripwire retention checks.
- Runs the existing read-only Randomizer structural performance audit as part of the release-safety promotion gate.

# 2.8.39 — Compatibility/API cleanup

- Strict child of exact 2.8.38 (`546ad502c88bbf7aed8a19399dab01613a0c20852333e879021570a7caea359b`).
- Adds explicit provider-state diagnostics that separate detected, advertised, selected, inactive/degraded, and Nuzlocke-fallback states without changing provider resolution semantics.
- Adds public `providerStatus`, `capabilityStatus`, and `compatibilitySnapshot` read-only diagnostics to the Interop surface and mirrors them through `nuzlocke_compat`.
- Adds an explicit compatibility fallback inventory. The current `catch.nickname` legacy path, historical Shiny direct exports, pre-registry provider metadata, and automatic legacy adapters remain retained because the supported engine/provider floor still reaches them.
- MOD COMPAT now surfaces provider-health and retained-fallback summary rows before ownership rows.
- Release Safety protects the fallback inventory and diagnostic API surfaces.
- No gameplay/rule, shiny, Randomizer, save-schema, or encounter behavior change intended.

# 2.8.38 — Localization hardening batch 1

- Strict child of canonical 2.8.37; no shiny-generation/presentation, encounter, battle-rule, save-schema, or Randomizer behavior changes.
- Routes remaining Battle Clause denial text through Gen1Recomp `Strings`, covering Sleep/OHKO/Evasion/Flinch/Trap, status bans, setup boosts, accuracy drops, and other stat-drop messages across the supported battle paths.
- Localizes Forgiveness action labels (`REROLL ENCOUNTER`, `REVIVE POKEMON`) in both Gen I and Gen II Nuzlocke-owned layouts.
- Localizes Classic NUZ STATUS dynamic templates (catch/lost, death/token, areas/visited, area, last event) and Run History event labels without using dynamically-generated source keys.
- Localizes Legacy Recovery fallback title/error text.
- Adds targeted Release Safety coverage for the migrated localization surfaces.
- Reclassifies the cumulative localization backlog from "unimplemented" to "infrastructure implemented / coverage incomplete"; World Building and Randomizer remain separate future localization phases.
- Corrects independent Release Safety lineage inputs to the exact 2.8.37 parent for this child.

# 2.8.37 — Full release promotion

- Promotes the corrected 2.8.36 candidate to a full release without changing the runtime-passed shiny implementation.
- Red runtime PASS: Nuzlocke-only `Shiny Rate = ALWAYS` produced visibly recolored shiny wild Rattata and Kakuna with shiny intro presentation.
- Preserves Shiny Pokémon 1.2.7 explicit compatibility, Gen1Recomp 0.2.27 compatibility work, provider failover, Shiny Clause integration, and the existing Gen II native-shiny architecture.
- Version/package/docs metadata synchronized to 2.8.37.

2.8.36 standalone shiny regression fix: external shiny ownership now requires a live separate provider handle before registry/API claims are trusted, preventing Nuzlocke-only runs from falsely standing down their built-in shiny system.
- **2.8.36 Shiny Pokémon 1.2.7 compatibility hardening:** explicitly audits the maintained 1.2.7 / Gen1Recomp 0.2.27 provider contract across Gen I and Gen II. External shiny ownership now prefers Nuzlocke's public provider registry (`SHINY_IDENTITY` + `SHINY_PRESENTATION`) and the generation-neutral `exports.shiny_pokemon` API before falling back to the inherited Gen-I `isShiny`/`rollShiny` exports. This closes the Gen-II detection gap created by Shiny 1.2.x deliberately not executing its inherited Gen-I main.lua. Nuzlocke also adopts 1.2.7's palette-transition ownership lesson: Gen1Recomp alone owns Renderer/Assets invalidation; Nuzlocke never flushes engine resources on COLORS changes. Its private derived-shiny cache instead includes the relevant PaletteFX mode/custom-ramp signature for custom species, so palette changes naturally select a new private artifact without an engine reset. Release Safety and MOD COMPAT diagnostics were updated accordingly. Runtime combined certification remains required.
- **2.8.36 Gen1Recomp 0.2.27 compatibility completion (items 3-4):** source-revalidated the Crystal Gen II `shiny-flash` safety boundary against 0.2.27, retained the narrow advanceQueue-only event suppression/picture-latch restore with no Gen II draw/update ownership, advanced the global audited-engine marker to 0.2.27, added explicit 0.2.26/0.2.27 compatibility profiles, expanded Release Safety coverage, and synchronized compatibility/user/confidence documentation. Exact-edition 0.2.27 runtime certification remains required.
- **2.8.36 / Gen1Recomp 0.2.27 compatibility phase 1:** R/B/Y Nickname Rule now prefers the new public `catch.nickname` decision seam while retaining `askNicknameUI` enforcement and the historical `battle.nickname` fallback for 0.2.24-0.2.26. Gen II NUZ STATUS and Recover Catches now render through palette-aware `src.ui.gen2.Chrome`, and the shared Gen II Setup/NUZ RULES surface no longer resets raw black/white draw colors inside the Chrome path. Added a focused Release Safety audit for these two migrations.
- **2.8.36 Gen II ALWAYS-shiny identity handoff hardening:** Crystal runtime showed the Nuzlocke-owned sparkle could appear for the player while a wild Sentret still entered battle non-shiny with Shiny Rate = ALWAYS. The Gen II `shiny.roll` wrapper now records the exact species/level/DV decision and the wild `battle.started` path verifies that the decision reached `mon.shiny` without re-rolling probability. Nonstandard wild providers that bypass the native builder get one fail-soft roll at battle start. The already-working Gen II palette/sparkle presentation and `shiny-flash` safety shim are unchanged.
- **2.8.36 corrective shiny-control / Gen II safety rebuild:** when Nuzlocke is the active shiny owner, its Shiny Rate / Shiny Colors / Shiny Intro controls remain visible and authoritative. When a compatible external shiny provider is detected, those three Nuzlocke controls are hidden so the external provider keeps the single shiny configuration surface; Shiny Clause remains Nuzlocke-owned. Added the Crystal-certified Gen II `shiny-flash` safety behavior: Nuzlocke consumes only the unsafe native presentation event, restores both battler picture latches, and continues the native queue while its existing `battle.overlay` supplies optional sparkle/SFX. No Gen II `draw` or `update` ownership was added.
- **2.8.36 corrective rebuild:** fixed Lua local-limit packaging failure; rebuilt from exact 2.8.35.
# 2.8.36 — Full built-in shiny presentation / provider failover

- Strict child of exact 2.8.35.
- Expands provider-absent shiny support from identity/rate semantics to built-in shiny colors, battle sparkle/audio intro, and live sprite/icon presentation.
- Adds `Shiny Colors` and `Shiny Intro` player controls beside Shiny Clause / Shiny Rate.
- Uses current Gen1Recomp sanctioned `pokemon.sprite`, `pokemon.icon`, and `battle.overlay` seams rather than Pokemon constructors or BattleState draw ownership.
- Keeps Gen-I enhanced odds as `mon.shiny` identity without DV/stat rewrites; keeps Gen-II enhanced odds on public `shiny.roll`.
- Generalizes single-owner failover: any active compatible shiny provider with identity plus roll/ownership capability immediately owns shiny generation and presentation for that edition.
- Nuzlocke performs no recolor, sparkle, SFX, or second roll while an external shiny owner is active; Shiny Clause/tracker/legality continue to consume the provider's identity.
- Adds Release Safety checks for the visual hooks, provider guard, new controls, and continued constructor/draw ownership prohibition.

# 2.8.35 — Shiny control clarity

- Clarifies the two adjacent shiny controls without changing mechanics: **Shiny Clause = catch exceptions only**; **Shiny Rate = rarity only**.
- Changes the Shiny Clause short/summary wording to `Shiny Catch` / `Shiny Clause ...` so it cannot be confused with the rate control.
- External-provider summary now reads `Shiny Rate EXTERNAL`.
- Adds a Release Safety clarity/adjacency audit for both controls.
- Carries 2.8.34 shiny-provider ownership, odds, identity, and fallback mechanics forward unchanged.

# 2.8.34 — Shiny provider compatibility / native fallback

- Strict child of exact 2.8.33 (`153e7a7a753f948b0e84e347bc2f92b62acec6f742e822d371e37a2177df5ec0`).
- Adds `SHINY_POKEMON` as an optional explicit compatibility target.
- Delegates Gen-I shiny generation/presentation to the external provider only when its audited `isShiny` and `rollShiny` export surface is actually present.
- Adds provider-neutral `shinySystemOwner`, `shinyExternalProvider`, and native-fallback diagnostics.
- Adds `Shiny Rate` fallback rule: NATIVE / 1/4096 / 1/1024 / 1/512 / 1/100 / 1/10 / ALWAYS.
- Gen-I fallback marks wild `mon.shiny` only; it does not rewrite DVs/stats or copy the external mod's recolor/sparkle renderer.
- Gen-II fallback composes through the public `shiny.roll` seam and preserves native Gen-II shiny ownership.
- Enhanced rates account for the natural 1/8192 roll instead of double-counting it.
- Existing Shiny Clause, tracker, Catch Info, and `Identity.isShiny` semantics consume either provider's identity unchanged.
- MOD COMPAT reports shiny-provider ownership/health.
- Adds Release Safety provider-isolation checks and preserves all 2.8.33 renderer-ownership tripwires.

# 2.8.33 — PotatoVoxel / renderer compatibility hardening

- Strict child of exact 2.8.32 (`9e4e1ff224f41ca34c726f8be0a402ea12ea1c67ef5eeb8676ffe2065dcb7007`).
- Adds `potato_voxel` as an optional compatibility identity; it is never required.
- Adds a generalized diagnostic `presentation` compatibility capability so renderer ownership can be reported without delegating Nuzlocke gameplay policy.
- Adds an explicit PotatoVoxel 1.9.6 compatibility adapter/health probe based on its published presentation capabilities rather than fragile version-string equality.
- Preserves PotatoVoxel ownership of voxel world/battle presentation while Nuzlocke retains challenge rules, encounter/capture legality, randomizer state, and gameplay transactions.
- Gen II remains native-battle-state authoritative: Nuzlocke does not register `Gen2BattleState`, wrap `render.compose`, or own native `BattleState` draw methods.
- Gen I keeps Nuzlocke's public battle overlay composition while PotatoVoxel may stage the native battle renderer beneath it.
- MOD COMPAT now reports PotatoVoxel as the active presentation owner when detected.
- Adds Release Safety coverage that fails if Nuzlocke later starts owning `render.compose`, `Gen2BattleState`, `BattleState.draw`, `drawWidescreen`, or `drawPic`.
- Treats PotatoVoxel cache/prebuild work as render-data activity, not map traversal or Nuzlocke encounter/progression activity.
- Repairs stale executable lineage markers inherited inside the exact 2.8.32 package so 2.8.33 records its actual immediate parent as 2.8.32.
- Preserves 2.8.32 live type-chart compatibility and 2.8.31 runtime-passed Gen II starter behavior unchanged.

# 2.8.32 — Live type-chart companion compatibility

- Strict child of runtime-PASS 2.8.31.
- Adds `steel_typing` as an optional compatibility identity; it is recommended, never required.
- Random Starter Trio Typing now evaluates `game.data.type_chart.matchups` first, so merged FAIRY and customized Steel/Dark relationships drive AUTO starter-cycle selection.
- Treats absent live matchup rows as neutral, matching Gen1Recomp semantics; the legacy Gen I/II table is used only if the live runtime chart is unavailable.
- Preserves the fully runtime-passed 2.8.31 Gen II starter selection, preview, dialogue, receipt, nickname, and award transaction unchanged.

# 2.8.31 — Gen II Random Starter text finalization

- Strict child of Silver-tested 2.8.30.
- Preserves the runtime-confirmed 3-STAGE base-form selection, randomized starter portrait/cry, and actual GIVEPOKE award transaction.
- Fixes Elm confirmation fallback rendering `...` by sending the one-shot randomized sentence through Vm:showRaw instead of re-feeding it to Vm:showText as though it were a generated text key.
- Fixes the native `{PLAYER} received <starter>!` line naming the vanilla ball species by rewriting only Elm's same-script `getmonname` operand to the already-rendered randomized starter.
- Does not mutate generated script data, story flags, yes/no flow, sound/prompt ordering, GIVEPOKE, or nickname handling.

# 2.8.30 — Gold Random Starter 3-STAGE / confirmation repair

- Built only from exact runtime-valid 2.8.29 (`4eb5df7fead2c88c817b2a512e828a492933edeb1fd2b225736772008d929155`).
- Fixes Gen II Starter Style lineage parsing: native Gen II evolution rows use `into`, while the starter lineage resolver previously read only Gen I-style `species`. This made Gen II 3-STAGE appear empty and fall back to ANY, allowing middle/final forms such as Pupitar at level 5.
- Revalidates persisted/scoped starter choices against the current Starter Style candidate pool so stale 3-STAGE fallback rolls are not resurrected after the parser fix.
- Fixes Elm randomized confirmation substitution so the synthetic Gen II `rawtext` row carries its literal in `cmd.args[1]`, preventing the `...` missing-text fallback.
- Does not change Gen II battle menu ownership, item-denial handling, party switching, or Wilds compatibility behavior.
- Gold runtime test required before promotion.

# 2.8.29 — Gen II native battle ownership repair

- Rebuilt from exact runtime-valid 2.8.27; failed 2.8.28 and the prior 2.8.29 candidate are quarantined.
- Battle Menu UI is now Gen I-only at registration time. Gold, Silver, and Crystal never register Nuzlocke's `battle.bottom_ui_visible` or `battle.overlay` command-menu wrappers, and the Battle Menu UI row is absent from Gen II Setup/NUZ RULES.
- Retires the legacy Gen II `BattleState.update` rule pager and removes the custom `nuzlocke-rule-text` phase.
- Gen II battle-item/capture denials now use the engine's native `showPages` + `resolving` message path, preserving A/B paging and native return to the battle command menu.
- Ports the reviewed Wilds of Kanto 2.2.0 compatibility diagnostics from failed 2.8.28 without changing its capture transaction.
- Runtime retest required in Crystal before promotion.

# 2.8.29 — Gen II native battle-menu ownership

- Rebuilt directly from exact runtime-valid 2.8.27; runtime-failed 2.8.28 is quarantined.
- Removes Battle Menu UI from the Gold/Silver/Crystal rule surface.
- Registers the optional custom battle command renderer only on Gen I; Gen II installs neither battle presentation hook and always keeps its native FIGHT / PKMN / BAG / RUN presentation.
- Does not change native Gen II battle input, switching, item screens, party screens, or action dispatch.
- Ports only the reviewed Wilds of Kanto 2.2.0 compatibility observability/session metadata from 2.8.28.
- Replaces the Gen II custom `nuzlocke-rule-text` pager/update wrapper with the native BattleState refusal path so a blocked Pack item returns through engine-owned battle state.

## Historical current note: 2.8.27 — Gen II PartyMenu ownership isolation

- Quarantines 2.8.26 after Crystal wild-battle runtime testing reproduced the
  field-party/overworld escape failure unchanged.
- Removes Nuzlocke's global Gen II `PartyMenu.new`, `openSubmenu`, and
  `submenuItems` wrappers.
- Actively unwraps legacy PartyMenu method sessions retained across a mod
  reload, including the R/B/Y-only Day Care facade wrapper beneath them.
- Keeps field item targeting on the native direct chooser plus the existing
  exact-instance callback seam.
- Prevents the R/B/Y-only custom Day Care PartyMenu constructor guard from
  remaining installed through Gen II's write-through compatibility facade.
- Keeps NUZ INFO out of `ctx.battle=true` menus and adds Release Safety coverage
  for the native-ownership boundary. Runtime confirmation remains required.

## 2.8.22
- Recovered from the last runtime-valid 2.8.19 parent after quarantining load-invalid 2.8.20 and 2.8.21.
- Internal runtime compatibility hardening for Gen I Trainer Randomizer.
- Added exact hook-registration and entry/completion diagnostics without moving callbacks out of scope.
- Added a Gen-I-only trainer-construction fallback when Nuzlocke owns Random Trainers but its live trainer hooks are absent.
- DEV REPORT now distinguishes hook-bus state, exact Nuzlocke hook registration, callback completion, final sample, fallback use, and constructed species.
- Gen II behavior is unchanged.
- Runtime testing required before Gen I Trainer Randomizer is marked PASS.

## 2.8.22
- Strict child of exact 2.8.18 recovery build.
- Ports only the two reviewed Trainer Randomizer changes that were missing from 2.8.18.
- Canonical rival starter-family synchronization now persists its chosen species into the deterministic Trainer Randomizer slot map, preventing the final authority from regenerating that starter-owned rival slot as an ordinary trainer member.
- DEV REPORT > RANDOM now surfaces Gen I Trainer Randomizer runtime evidence: trainer class/party, members/generated/reapplied, seed/reset, all-vanilla state, configured species mode, per-slot original/final/choice, candidate-pool counts/mode normalization, and the roster observed when the battle actually started.
- 2.8.18's recovered trainer candidate safety, symmetric Species Pool normalization, final trainer authority, battle-observed diagnostics, Gen II Mon rematerialization hardening, and other unrelated behavior are preserved unchanged.
- No Crystal item-randomizer or tutorial-skip work is included in this build.
- Runtime testing required; do not mark Gen I or Gen II Trainer Randomization PASS based on this build alone.

## 2.8.22
- Quarantines compiler-invalid 2.8.16 and 2.8.17; rebuilt from exact 2.8.15, the last valid parent.
- Fixes the Mod Manager syntax failure caused by the unintended `local local function randomizerToggleOn2816` tangent by excluding that unrelated field-item code entirely.
- Ports forward only the reviewed PHASE F Trainer Randomizer work from the invalid 2.8.16/2.8.17 packages.
- Trainer candidates now use a dedicated construction-safety gate rather than the wild/starter level-scaled completeness gate.
- Trainer safety validates native species/stat structure plus only the bounded move set the native trainer constructor can actually materialize.
- Trainer Species Pool normalization is symmetric between generations without rewriting the saved player setting.
- Gen I keeps deterministic persisted trainer mappings and final runtime projection.
- Gen II keeps its native Mon rematerialization path and protected constructor fallback.
- No Crystal field-item tangent from 2.8.16/2.8.17 was carried forward.
- Runtime testing required; Yellow Trainer Randomizer remains FAIL until confirmed otherwise.

## 2.8.22
- Yellow/Gen I Trainer Randomizer remains runtime-confirmed FAIL on 2.8.14; this build is another targeted repair and requires runtime testing.
- Gen I trainer candidate pools now normalize an impossible Gen-II-only shared Species Pool to an effective Gen-I pool without rewriting the player's configured value.
- Added per-trainer diagnostics for configured/effective species-pool mode, registry size, generation-allowed count, hard-safe count, seed, original species, final species, generated/reapplied members, and all-vanilla detection.
- Gen I final trainer authority now snapshots the engine-authored roster before inner `trainer.party` wrappers so balance/randomization decisions are based on the true vanilla source party rather than an already-mutated downstream result.
- Trainer slot mappings are now seed-aware. Changing/rerolling the Randomizer seed invalidates cached trainer-slot choices so the new seed can actually produce new trainer mappings.
- Persisted authored/same-species mappings continue to be treated as stale when a legal alternative exists.
- Gen II Trainer Randomizer behavior is unchanged from 2.8.14.
- No claim of a confirmed Gen I Trainer Randomizer fix until Yellow runtime testing passes.

## 2.8.22
- Hardened the Gen II Trainer Randomizer native Mon rematerialization path.
- `Gen2Mon.new(...)` itself is now protected with `pcall`; previously only the module `require` was guarded.
- A constructor exception or invalid return now falls into the existing species/sync/stat-refresh fallback instead of escaping the `trainer.party` hook chain.
- Added actionable `lastGen2TrainerRandomizerError` diagnostics distinguishing builder failure/bad return from builder unavailability.
- Reviewed Gen1Recomp 0.2.26 `Mon.new`: missing DVs/stat EXP are natively defaulted, so nil authored DV/stat-exp fields alone are not confirmed as the cause of the reported Gen II Trainer Randomizer uncertainty.
- No Gen I Trainer Randomizer behavior changed in this build.
- Runtime testing is required before claiming any Gen II Trainer Randomizer behavior change.

## 2.8.22
- Gen1Recomp 0.2.26 compatibility/documentation review completed.
- Mod API 2, the existing `trainer.party` contract, hook priority semantics, and the current `>=0.2.24 <2.0.0` engine range remain compatible; no manifest range bump is required.
- Recorded 0.2.26 as the latest audited Gen1Recomp compatibility surface.
- 0.2.26 additions reviewed for future Nuzlocke use include public `mod.developer`, Gen I `battle.field_residual`, conditional map occupancy/active-block APIs, Crystal target documentation, and broader Gen II fixes. None require replacing Nuzlocke's current gameplay owners in this build.
- Gen I Trainer Randomizer follow-up: stale persisted trainer mappings equal to the authored species are now invalidated and deterministically recomputed whenever a legal alternative exists. This targets the Yellow Weedle/Kakuna runtime reproduction that survived 2.8.12.
- Gen I Trainer Balance / Diversity / Theme now render semantic named modes instead of raw numeric values.
- Gen II trainer materialization remains untouched.
- Runtime testing is required before claiming the Gen I Trainer Randomizer failure fixed.

## 2.8.22
- Full Randomizer configuration hierarchy audit across both Gen I and Gen II.
- Every true Randomizer child is now ordered directly beneath its parent on Setup/NUZ RULES. Parent-dependent rows retain their saved values but disappear while the parent is OFF.
- Global Randomizer controls (Preset, Seed, Info Policy, shared Species Pool) remain top-level rather than being falsely assigned to one subsystem.
- Starter reroll action now stays with the Random Starter cluster; seed actions stay with Randomizer Seed.
- Gen I Trainer Randomizer: replaced the 2.8.11 map-only late guard with an outermost, self-sufficient final party-definition authority.
- If the normal trainer policy mapping is missing, Gen I now deterministically rebuilds a hard-safe replacement at the exact final trainer.party boundary instead of silently materializing the authored vanilla species.
- This Gen I fallback does not run on Gen II and does not change trainer party size, order, or authored levels.
- Gen I Trainer Randomizer repair requires runtime confirmation; Yellow Bug Catcher is the primary reproduction case.

## 2.8.22
- Targeted Gen I Trainer Randomizer repair.
- Confirmed the 2.8.07 Gen II native-Mon rematerialization fix is Gen II-specific; Gen I materializes fresh Pokemon only after the `trainer.party` hook returns.
- Added a Gen I-only late trainer-party projection guard that reasserts the already-determined deterministic slot mapping after downstream hook/provider composition, preventing a later wrapper from silently restoring the vanilla species.
- The guard does not reroll, change authored levels, party size, or move fields, and does not run on Gen II.
- Added a diagnostic record when the late Gen I guard actually has to reapply one or more trainer species.
- Other 2.8.10 behavior is unchanged.

## 2.8.09
- Crystal/Gen II Randomizer UI: Shop Balance and TM Compatibility now render semantic values instead of raw 0/1/2 in the Setup/Rules value lane.
- Gen II Randomizer rows are grouped parent -> children without changing Red/Blue/Yellow menu ordering. Existing dependency visibility remains authoritative, so children appear under their parent only while active.
- Gen II No Center Heal now intercepts the Nurse at the pre-script talk seam and replaces the vanilla nurse conversation with the Nuzlocke refusal instead of appending the refusal after native dialogue.
- Gen II battle-item hardening: the field-only `useItem` PartyMenu chooser repair no longer claims any chooser while a Gen II BattleState is present on the stack. Battle PACK/item lifecycle is returned to Gen1Recomp's native battle owner.
- 2.8.07 Trainer Randomizer rematerialization and 2.8.08 hidden-field-item randomization are preserved unchanged.

## 2.8.09
- Focused Crystal/Gen II item-randomizer follow-up.
- Random Field Items now owns both native visible item balls and native hidden BGEVENT_ITEM pickups in Gen II.
- Hidden pickups use deterministic exact-edition/map/event identities and retain all progression/key/HM protection.
- Provider-defined hidden-item sources remain unclaimed unless they explicitly opt into Nuzlocke ownership.
- Trainer Randomizer materialization fix from 2.8.07 is preserved unchanged.
- Battle-item freezing, starter-image presentation, and broader death-message timing remain separate follow-up issues.

## 2.8.09
- Gen II Trainer Randomizer repair: randomized trainer members are rebuilt as native Gen II Mon records instead of changing only the species field.
- Preserves authored trainer levels and trainer-safe intrinsic state while allowing the existing Difficulty layer to adapt afterward.
- Gen I Trainer Randomizer behavior is unchanged.


## 2.8.09
- Gen II-only UI cleanup: redesigned NUZ STATUS hierarchy and ENC TRACKER three-row cards.
- Tracker cards restore explicit encounter state, species, and source/type while giving long area names more room.
- Removed cryptic compact tracker summary glyphs from the Gen II header.
- Gen I menu layouts are intentionally unchanged.
- Outcome-dependent Nuzlocke presentation contract: allowed actions must resolve natively before result-revealing feedback; rejection explanations remain immediate.
## 2.8.09

- Continued Gen II Nuzlocke-owned UI cleanup after Crystal runtime review.
- ENC TRACKER LOG/MAP now uses compact one-line rows and shows more entries without wasting body space.
- NUZ STATUS uses clearer fixed summary rows and gives AREA/LAST values the full content lane.
- RUN HISTORY now has a framed Gen II renderer instead of the generic borderless list presentation.
- MOD COMPAT uses compact one-line ownership rows and more of the available body.
- Hardened the Gen II field-poison last-Pokémon whiteout path by promoting a proven wipe onto the native poison event before Gen1Recomp handles it.
- Preserves runtime-PASS Crystal party-item use and Randomizer behavior from 2.8.03.

# 2.8.09 — Gen II Nuzlocke UI hardening

- Reworked the active Gen II NUZ STATUS screen around the shared Nuzlocke Chrome/title contract: centered emphasized title, separate edition subtitle, bounded label/value rows, cleaner RULES spacing, and split footer prompts.
- Reworked Gen II MOD COMPAT into compact single-line label/owner rows with centered emphasized title, six visible rows, bounded text, and consistent footer spacing.
- Reworked Gen II ENC TRACKER MAP/LOG spacing to use more of the 20x18 tile surface, five two-line result rows, and explicit STATE context instead of an unexplained trailing tag.
- Reworked Gen II DEV REPORT presentation to open on semantic SUMMARY instead of exposing opaque report-code strings, use eleven bounded body rows, and apply consistent centered title/footer/navigation spacing to report, known-issues, and storage views.
- Preserves the runtime-confirmed Crystal 2.8.03 Gen II party-item fix and Randomizer visibility/runtime fixes without changing their gameplay paths.

# 2.8.03 — Gen II item/poison retry + Randomizer surface audit

Strict child of exact 2.8.02 (`b9058576184a889e5a5cf8f31dc990e387fda66dead6cc25f9f11db3b29f3338`). This corrective build makes another targeted attempt at the two major Gen II runtime defects under active investigation and completes a full Gen II Randomizer configuration-surface audit.

- **Gen II party-target items:** the exact `useItem` chooser instance now intercepts a non-CANCEL A press before native PartyMenu update/compatibility callbacks can swallow it. The selected index is resolved to the authoritative live save-party slot, legality is rechecked, and the existing native `ItemEffects` transaction runs from that early input seam. Item-effect exceptions are captured into `lastGen2PartyItemError` and surface a DEV REPORT message instead of silently returning to the Pack. Specialized PP/evolution-stone/TM/HM paths remain unchanged.
- **Gen II field poison wipe timing:** Whiteout/Blackout is now pre-armed before the native poison-faint handler runs so a synchronous native spawn warp can see the Nuzlocke decision. The post-prune independent wipe check remains as fallback, while a decision consumed by a synchronous warp is not re-armed onto a later unrelated warp.
- **Randomizer Setup/Rules audit:** all 30 current Randomizer parent/child controls are now included in the Gen II rule surface. This restores previously omitted Preset, Shops/Shop Balance, TMs/TM Compatibility, Gift Items, Evolution Balance, and Learnset STAB rows in addition to the Trainer controls fixed in 2.8.01/2.8.02. Every declarative Randomizer parent dependency is also covered by the live dependent-row refresh trigger.

Runtime certification remains required, especially Crystal Potion/vitamin/Rare Candy use and final-party-member overworld poison faint.

# 2.8.01 — Gen II trainer-option + field-poison hotfix

Strict child of exact published 2.8.00 (`16d2c356639d4a5b90f9f775e258c12aeadc517711fe68f542356b747443adfe`). Crystal runtime confirmed the Trainer Randomizer controls were absent from Setup/NUZ RULES because all four trainer rows were omitted from the Gen II rule allowlist. This hotfix restores `random_trainers`, `random_trainer_balance`, `random_trainer_diversity`, and `random_trainer_theme`; child controls retain their established dependency on Random Trainers being ON.

A separate Crystal report confirmed that the final usable party Pokémon could faint from overworld poison and gameplay would continue. The Gen II poison adapter previously trusted Gen1Recomp's `event.whiteout` flag as the sole wipe signal. 2.8.01 now independently checks the live party after Nuzlocke records/prunes poison deaths. If no healthy party member remains, the normal Nuzlocke Whiteout/Blackout decision is armed even when the engine flag is absent; a destructive Blackout ends the run immediately after the native poison handler returns, while a survivable Whiteout requests the native Gen II spawn warp and keeps recovery ownership on the existing warp seam.

The known Gen II party-target item-use defect remains unresolved and unchanged. Existing 2.8.00 scrolling/profile/T3 behavior is preserved.

# 2.8.00 — Full release: Gen2 party-item commit repair + refined progressive navigation

Strict child of exact 2.7.106 (`10b482d6e535d318ff6b4e7ada052dac4fdd269ec6b4e2ac5fbf27368babb092`). This is the requested 2.8.00 full-release package. Crystal runtime on 2.7.106 confirms the Gen2 `useItem` target chooser itself works but healing items, vitamins, and Rare Candy still return to the Pack without committing their effects. 2.8.00 therefore moves the simple-consumable repair to the earlier Pack USE seam: after Nuzlocke legality checks it opens the native Gen2 party chooser, resolves the selected index back to the authoritative live `game.save.party[index]` record, executes Gen1Recomp's own merged `ItemEffects` result on that live record, consumes the item, and presents the native result. Target-sensitive legality is rechecked after selection. PP items, evolution stones, TMs/HMs, battle items, and non-party field items stay on their specialized existing paths. Rare Candy-to-cap remains available when a finite cap exists.

Held UP/DOWN Setup/Rules navigation keeps five progressive speed gates but ramps more slowly and tops out more slowly than 2.7.106. The initial repeat delay is about 0.48 s, then the cadence progresses through approximately 0.27 s → 0.23 s → 0.19 s → 0.15 s → 0.11 s per step. SELECT+UP/DOWN retains section-jump priority; numeric digit editing remains tap-only. Runtime-PASS TOOLS profile semantics and the T3 World Building default are unchanged.

# 2.7.106 — Gen2 party-consumable execution + progressive held navigation

Strict child of exact 2.7.105 (`7ebcc84f91d710e2fc6f69bfa24f830b7e7827e601e21d94a9f1716d906f5386`). Crystal runtime on 2.7.105 confirms the wrong Pokémon action submenu is fixed, but selecting a target still returns to the Pack without applying Rare Candy, vitamins, or healing-item effects. 2.7.106 therefore repairs the shared post-selection consumable seam instead of changing Pokémon structure or chooser presentation again. For Gen2 healing, status, revive, vitamin, and Rare Candy families, Nuzlocke now invokes Gen1Recomp's own `ItemEffects` routine directly on the selected party record, then uses the native Game2 item-consumption/message/after-Rare-Candy services. PP items and evolution stones retain their specialized native paths. Finite-cap Rare Candy batches retain the existing transaction controller; a no-finite-cap candy executes once on the already-selected Pokémon instead of re-entering the party chooser after it has closed.

Held UP/DOWN navigation is also retuned from 2.7.105's single fast repeat into a slower five-stage acceleration curve. Taps remain one row; holding begins after a longer delay and gradually accelerates through five repeat gates. SELECT+UP/DOWN keeps section-jump priority and uses the same progressive cadence. Numeric digit editing remains tap-only. Runtime certification required for damaged-Pokémon healing, vitamin, Rare Candy, and the new scroll feel.

# 2.7.105 — Gen2 party-item chooser repair + held rule navigation

Strict child of exact 2.7.104 (`5a446e88ff69ba13f17c127efc33ee221e98dff1fb6489c89177af2a106297f3`). Crystal runtime on 2.7.104 proved the party-item failure occurs **after** the correct "Use on which Pokémon?" screen appears: selecting the target incorrectly opens the ordinary field Pokémon submenu (field move / STATS / SWITCH / MOVE / ITEM / NUZ INFO) instead of invoking the item chooser callback. 2.7.105 therefore fixes the actual chooser-mode boundary rather than mutating Pokémon records. Gen2 `PartyMenu.new` screens opened with the native `useItem` prompt are forced to remain direct `onChoose` choosers; ordinary field, battle, TM/HM, held-item and NUZ INFO menus are unchanged. The unsuccessful 2.7.104 full-record starter materialization is retired; only the prior narrow semantic species-key canonicalization remains before native party-item processing.

Setup and in-run NUZ RULES also gain held UP/DOWN navigation: a tap still moves one row, while holding begins rapid repeat after a short delay. SELECT retains priority, so SELECT+UP/DOWN continues to jump by section and also follows the repeat cadence while held. Numeric digit editing remains edge-only. Runtime certification required for Potion/vitamin/Rare Candy use and held navigation.

# 2.7.104 — Gen2 randomized-starter native record materialization

Strict child of exact 2.7.103 (`e80b6ef71ff293a883eb8816882b6f9d81028c1b28fd4ff6501fd1fae3ebe7aa`). Crystal runtime confirms the 2.7.103 TOOLS profile semantics PASS, but Potion/vitamin/Rare Candy use on the randomized Steelix remains FAIL. 2.7.104 retires the unsuccessful 2.7.103 direct Pack→Game2 routing experiment and restores Gen1Recomp's native Pack→World→Game2 dispatch after Nuzlocke legality checks. The randomized Elm starter is now materialized against Gen1Recomp's own Gen2 `Mon.new` structural contract while preserving the already-owned table identity, live HP/status/EXP/moves/held item/OT, and Nuzlocke provenance. Existing tracked starters receive the same idempotent repair immediately before native party-item handling, so current saves can recover without restarting. A read-only Gen2 party-record health diagnostic records unresolved species/native-shape failures. Runtime certification remains required.

# 2.7.103 — Gen2 party-item routing + TOOLS semantics + World Building T3

Strict child of exact 2.7.102. Crystal runtime testing showed 2.7.102 still did not restore party-target item use, and Save Profile / Load Profile visually behaved like duplicate Profile Slot selectors. 2.7.103 routes engine-owned Gen2 party-effect consumables directly from the field Pack USE seam into native `Game2:usePartyItem` after Nuzlocke legality checks, leaving target selection/effects/messages/consumption native. Profile Slot alone selects OFF/1/2/3; Save Profile and Load Profile are distinct actions against that selected slot. World Building defaults return to T3 across all games for new/default configurations; explicit existing save choices are preserved. Runtime certification required.

# 2.7.102 — Gen2 party-item + TOOLS profile-selector repair

Strict child of exact packaged 2.7.101 (`48d3e97d76cb8f7b266a5d6d0eace9bd5f983733f72a733a627204b6b98651b5`).

- Repairs the still-failing Gen2 party-target item path by canonicalizing owned party `mon.species` records at the native `Game2.usePartyItem` boundary before native Potion/vitamin/Rare Candy processing. This generalizes 2.7.101's Elm-finalizer-only representation repair without changing species identity, moves, stats, provenance, inventory consumption, or native item-effect ownership.
- Restores the TOOLS profile target as a shared `OFF / 1 / 2 / 3` selector. LEFT/RIGHT on Profile Slot, Save Profile, or Load Profile changes the shared target; A cycles Profile Slot, while A on Save Profile/Load Profile performs the selected action only when a numbered slot is active.
- Saved profiles remain installation-scoped configuration only; run progress is never serialized. Load Profile still uses the existing preview/confirmation path.
- Protected Random Starter selection/award behavior, Crystal ENC TRACKER LOG/MAP, MOD COMPAT safe rendering, and unrelated rule/randomizer behavior are unchanged.
- Runtime certification required on Gold/Silver/Crystal for Potion, vitamin, and Rare Candy party use plus Setup/in-run TOOLS selector/save/load behavior.

## 2.7.101
- Removes the player-facing Save Setup action; Setup still stages rules into NEW GAME automatically, while persistent reusable configuration is owned by Profile Slot / Save Profile / Load Profile.
- Repairs the 2.7.97 Gen2 MOD COMPAT crash by restoring the previously safe Gen2 Chrome renderer; cosmetic redesign is deferred until that path is runtime-stable again.
- Repairs Gen2 native vitamin USE classification while Nuzlocke is enabled by restoring the 0.2.25 native ITEMMENU_PARTY metadata for HP Up, Protein, Iron, Carbos, and Calcium.
- Preserves the 2.7.97 tracker and Crystal Quick Start nickname fixes.
- Random Starter/random-moves implementation remains unchanged.

## 2.7.101
- Focused Gen2 UI/runtime repair built strictly from 2.7.96.
- TOOLS is now an explicit final subsection in both New Game Setup and in-run Rules; Encounter Assignment is available there in both contexts.
- Gen2 ENC TRACKER MAP now seeds the full canonical Johto/Kanto progression catalog so eligible unseen areas can be browsed; ordinary visited interiors no longer appear solely because they were visited.
- Crystal Quick Start nickname completion now follows Gen1Recomp 0.2.25's native Gen2NamingScreen completion contract.
- Gen2 MOD COMPAT now uses a compact one-row RULE/OWNER layout with selected-row detail text.
- Crystal DST remains deferred.
- Random Starter award/random-moves logic is otherwise preserved.
- Vitamin GIVE/TAKE behavior was not patched pending a mods-off Gen1Recomp reproduction.

# 2.7.101 — Gen2 services/tools + Gen1Recomp 0.2.25 compatibility

Strict child of exact 2.7.95. Repairs the Gen2 Pokemon Center service gate by resolving HealParty and map identity semantically across 0.2.25-era script contexts; exposes the existing Shop Restrictions selector on the Gen2 rule surface so NO BUY / NO SELL / NEITHER are configurable; and adds a final in-run TOOLS section with Profile Slot, Save Profile, Load Profile, Save Rules, and Encounter Assignment. Saved profiles remain configuration-only and loading previews changes before application. Crystal System Date/Time opening handling now seeds its DST skip state from semantic SetDayOfWeek rather than depending on a generated ISITDST text label.

The Gen1Recomp compatibility audit advances through 0.2.25. The review covers the new read-only `mod.datasets` imported-version views and the release's Gen2 VM/battle/save/world changes. Nuzlocke does not replace protected active-game transactions with cross-version dataset views. The 2.7.94 Random Starter selection/award repair remains intentionally untouched. Runtime retest is required for Center Heal, mart restrictions, in-run profile tools, Encounter Assignment, and Crystal DST skip.

# 2.7.95 — Tracker / Setup / MOD COMPAT / Battle UI cleanup

Strict child of exact 2.7.94 (`3bcc5dddf6cf7143ed13746f1e49084252f5e5108f5562439ade15a746915e94`).

- Freezes the 2.7.94 Random Starter repair after runtime PASS on Red, Silver, and Crystal. Random Starter selection/grant code is unchanged.
- Gen-2 ENC TRACKER MAP now uses a player-facing canonical progression order: Johto progression first, then Kanto, then evidence-backed custom/unknown areas. It no longer treats raw ROM `mapOrder` as presentation order.
- Gen-2 MAP is now an encounter-area guide rather than a raw map browser: ordinary interiors such as cafes/shops are hidden unless they carry real tracker evidence; New Bark Town remains visible for starter provenance.
- Red/Blue/Yellow pre-game NUZLOCKE SETUP explicitly clears inherited title-screen palette tint so normal Setup rows, values, pager, arrows, help text, and chrome render black-on-white like live NUZLOCKE RULES.
- MOD COMPAT gives the title a dedicated row, moves the help-page selector safely above the bottom edge, changes it to `SEL n/n`, and gives the right-side down arrow a slow blink.
- Battle Menu UI ON keeps native input/action authority but replaces the 2.7.93 large translucent rounded rectangle with a compact native-pixel box in the battle-owned bottom-right command region.
- Existing `NUZLOCKE SETUP` / `NUZLOCKE RULES` slash-free titles remain.
- Crystal randomized starter portrait parity remains deliberately unresolved/ALPHA; 2.7.94 runtime confirmed randomized text/award without crash while native Chikorita portrait remains the safe preview.
- No Save Schema, Compatibility API, Diagnostics API, rule count, or Randomizer algorithm change.

# 2.7.94 — Random Starter regression repair

Strict child of exact 2.7.93 (`c7f626def623821e46487dc7f6ac612c4c4b2ed42cb62b62e3969a9e03ab5c00`).

- Runtime bisect established the Gen1 Random Starter regression boundary exactly: **2.7.44 Red PASS → 2.7.45 Red FAIL**. Later Red tests on 2.7.54, 2.7.70, and 2.7.93 also fail by presenting/awarding vanilla starters; published 2.7.28 Yellow is runtime PASS.
- The 2.7.45 delta first coupled Random Starter candidate construction and persisted-choice validation to the shared **Species Pool** generation filter. 2.7.94 surgically restores the last runtime-proven 2.7.44 starter contract: Random Starter uses its own hard-safe live species pool plus Starter Style and challenge legality, independent of Species Pool.
- Species Pool remains available to Random Encounters, Random Trainers, and Random Evolutions. Randomizer presets and every later Randomizer subsystem remain intact.
- This is a forward port into the exact 2.7.93 parent; no older source tree is restored wholesale.
- Changes the R/B/Y Nuzlocke-owned screen header wording from `NUZLOCKE / SETUP` / `NUZLOCKE / RULES` to **NUZLOCKE SETUP** / **NUZLOCKE RULES**.
- Gold 2.7.28's historical `No Glitch Pokemon` Elm symptom remains tracked separately as an older Gen2 provenance/transaction issue; this Gen1 bisect repair does not claim to solve it.
- Rule count remains 151 canonical unique rules across 21 sections. Save Schema remains 5; Compatibility API 34; Diagnostics API 1.
- Runtime certification required: Red New Game Random Starter is the primary acceptance test; Yellow and Gen2 remain independent targets.

# 2.7.93 — Battle Menu UI + Run / Surf consolidation

Strict child of exact 2.7.92 (`fb2ab4828f8c9afed48be01f7abf0f909f29d812287fbbfe5e72f26e5f2e57b9`).

- Adds **Battle Menu UI** under UI, default OFF. OFF leaves Gen1Recomp's native battle command presentation untouched. ON uses the shared public `battle.bottom_ui_visible` + draw-only `battle.overlay` seams to replace only the ordinary four-command battle menu with a centered Nuzlocke-owned 2x2 panel: FIGHT / POKEMON / BAG / RUN.
- Battle Menu UI is presentation-only: native `menuIndex`, input, action dispatch, move selection, party/item screens, HP/status HUD, link/battle mechanics, and challenge-rule enforcement remain authoritative. Safari, Bug Contest, and tutorial/demo command menus deliberately stay native.
- Merges **Running Shoes** and **Fast Surf** into one QOL rule: **Run / Surf** with OFF / HOLD B / ALWAYS. One authoritative mode now controls both player-controlled walking and Surf speed assists.
- Existing saves and old Setup presets migrate conservatively: when old Running Shoes and Fast Surf values disagree, the new Run / Surf value takes the more restrictive mode. Legacy save keys remain synchronized as compatibility mirrors.
- Fixes the intended No Catching dependency metadata for **Allow Glitches** by correcting the stale `allow_glitches` key to the canonical `allow_glitch_pokemon`.
- Rule taxonomy remains 21 sections and 151 canonical unique rules: Battle Menu UI adds one row while the two movement rows become one.
- Preserves 2.7.92 Setup/Rules visual treatment and 2.7.91 Random Starter crash hardening.
- Crystal Mom DST remains deliberately deferred.
- Save Schema remains 5; Compatibility API 34; Diagnostics API 1.

# 2.7.92 — Setup/Rules palette + bold chrome polish

Strict child of exact 2.7.91 (`148dc68fb49e9aa17cc14f2efd792c4f5f72d2b092abdd16850d3749679cd27f`).

- Implements the approved Setup/Rules presentation across R/B/Y and Gold/Silver/Crystal.
- `NUZLOCKE / SETUP` and `NUZLOCKE / RULES` use the bold Nuzlocke-owned title treatment.
- Normal rule names, values, selection/navigation glyphs, the bottom-centered `▲ current/total ▼` pager, and help text use one consistent black/dark treatment. Selection remains communicated by the cursor rather than changing row text color.
- WIP/delegated rows may still dim so their special state remains visible.
- Preserves 2.7.91's raised rule rows and bottom-centered pager geometry.
- Preserves 2.7.91's Random Starter crash containment and empty-pool hardening unchanged.
- Crystal Mom DST remains deliberately deferred.
- No rule-default, Save Schema, Compatibility API, Diagnostics API, Randomizer algorithm version, or package-inventory change.

# 2.7.91 — Random Starter crash hardening + Setup/Rules pager layout

Strict child of exact 2.7.90 (`ea7e42c5a9249090934f6b53a999397b5cf618e385624dcaecfdc2886cdf091f`).

- Protects the newly runtime-PASS Silver vanilla Elm starter path from Random Starter failures: canonical starter-slate materialization is now wrapped at the optional randomizer boundary. If a seed/slate/materialization fault occurs, the mandatory native starter transaction fails open to the selected vanilla starter instead of crashing.
- Fixes an explicit empty without-replacement fallback edge in atomic starter slate generation: when distinct assignment is already proven impossible and the remaining duplicate-safe pool is empty, the code now uses the first hard-safe candidate instead of ever calling `random(1, 0)`.
- Preserves the 2.7.90 same-script Elm provenance and duplicate-gate receipt-window repair unchanged.
- Setup/Rules UI on R/B/Y and Gold/Silver/Crystal now moves the three visible rule rows upward into the reclaimed subtitle space.
- The pager cluster is now centered at the bottom of the list panel as `▲ current/total ▼`, rather than living near the top/right.
- Crystal Mom DST remains deliberately deferred.
- No rule-default, Save Schema, Compatibility API, Diagnostics API, Randomizer algorithm version, or package-inventory change.

# 2.7.90 — mandatory starter provenance / duplicate-gate repair

Strict child of exact 2.7.89 (`a1674ce6b30b2bcc214c1e3cda1313fa9f5184be013d74171308ae4a16b4f8a9`).

- Replaces the remaining Silver/Crystal Elm starter guesswork with a same-script mandatory-starter provenance marker. A starter POKEPIC arms the marker for that exact VM script run; the following GIVEPOKE consumes it. Map-label spelling and species-registry shape are no longer allowed to downgrade the mandatory Elm transaction into an ordinary gift.
- Opens a one-transaction mandatory-starter receipt window around native Gen-2 givePoke so the post-transaction pokemon.received gate cannot re-run generic gift/glitch legality on the same starter before Tracker finalization.
- A declined starter ball cannot leak provenance into a later script because the marker is keyed by scriptKey and consumed/cleared only by the matching GIVEPOKE.
- Random Starter setup intent is seeded into the fresh save-backed mod.save bucket at save.created while the immutable New Game Setup profile is still authoritative. This applies to R/B/Y and Gen 2 and prevents the Random Starter toggle/style/seed from disappearing when Gen1Recomp adopts the new save before the starter transaction.
- Preserves the 2.7.89 Setup/Rules subtitle cleanup.
- Crystal Mom DST remains deliberately deferred.
- No rule-default, Save Schema, Compatibility API, Diagnostics API, Randomizer algorithm, or package-inventory change.

# 2.7.89 — runtime-known-good starter transaction recovery

Strict child of exact 2.7.88 (`60246223e257c476231527339f99f1d16db0a198de66e318e2da856518b6dd68`).

- Restores the recent runtime-proven starter ownership contract instead of adding another species-legality heuristic.
- Gold/Silver/Crystal: any GIVEPOKE reached from Elm Lab's starter-ball story context is treated as the mandatory starter transaction before optional gift/glitch legality. Species identity refines the selected ball/Random Starter choice but no longer decides whether Elm's mandatory story grant is an ordinary gift.
- Gen-2 preview state now carries the last exact Elm original + randomized choice forward to GIVEPOKE, preserving preview -> confirmation -> grant identity when early-runtime species representation is incomplete.
- R/B/Y Random Starter: restores the first-party canonical opening-starter transaction as authority and removes the brittle map-label prerequisite that could prevent the actual `pokemon.before_give` mutation.
- Removes the redundant edition / NEW RUN / LIVE second title line from Nuzlocke-owned Setup and Rules headers on all supported editions.
- Crystal Mom DST suppression is deliberately deferred to a later child per owner instruction.
- No rule-default, Save Schema, Compatibility API, Diagnostics API, Randomizer algorithm, or package-inventory change.

# 2.7.88 — complete starter transaction / clock summary / DEV code repair

Strict child of exact 2.7.87 (`3ffe5a2bcdd1f0111acaaa9f3f0e8ccf169134902c4efa2308ca8b0e6bf5193b`).

- Fixes the remaining Silver/Crystal false-glitch starter veto at the actual shared legality boundary: numeric Gen-2 species identities now resolve against each live Pokemon registry row's public `index` field, not just physical table keys or optional aliases.
- Hardens Elm starter recognition around the exact canonical cartridge GIVEPOKE operands (Chikorita 152, Cyndaquil 155, Totodile 158) plus Elm Lab context. These numeric constants identify the mandatory story transaction; they are not a glitch-rule whitelist.
- Gen-2 canonical-name <-> native-index conversion now prefers the public Pokemon registry `index` field, falls back to generated species order when available, and retains exact Elm operand fallback if early-load registry metadata is temporarily unavailable.
- Gen-2 Random Starter preview/grant paths use the same shared native-index resolver.
- R/B/Y Random Starter's `pokemon.before_give` seam now mutates the gift only when Random Starter is actually enabled, validates the selected species, and commits the exact same identity.
- Manual Time's NUZ RULES row now displays the live `HH:MM` value rather than `HH:--`.
- DEV TOOLS -> VIEW REPORT now explicitly generates the live NZR6 shareable code with `Dev.reportCode(...)`; the restored CODE page no longer depends on a `report.report_code` field that `selfTestText()` intentionally stopped populating in 2.7.82.
- The Crystal System Date/Time / Mom DST transaction repair from 2.7.87 is retained unchanged pending runtime retest.
- Crystal loadout PASS evidence is protected. No rule default, save-schema, Compatibility API, Diagnostics API, or package-inventory change.

# 2.7.87 — Gen-2 Elm identity / clock / DEV report runtime repair

Strict child of exact 2.7.86 (`ca592afd62cc46cb90823278733f225c53da6e3cc4a898da36bac23cbcac0ee0`).

- Fixes the real Silver/Crystal Elm starter identity defect by resolving Gen-2 numeric script species through Gen1Recomp's canonical `gen2Constants.speciesOrder` before starter recognition or legality checks. Ordinary Chikorita/Cyndaquil/Totodile must no longer become numeric-string pseudo-species and trigger the glitch rule.
- Adds the reverse canonical-name -> native Gen-2 species-index resolver and uses it for Random Starter preview/grant transactions, addressing the separately observed 2.7.85 Gen-2 Random Starter failure without adding a starter whitelist.
- Manual Time now edits both hour and minute: Up/Down selects the field, Left/Right changes it, A applies it. Applying still disables System Clock Sync and clears DST ownership.
- Crystal's initial Mom DST ladder is skipped by exact Players House 1F script transaction identity when System Date/Time is active. The bypass does not match English display text and does not touch Mom's later phone/banking prompts.
- Restores the long NZR report-code page as the first page after DEV TOOLS -> VIEW REPORT. The human-readable SUMMARY/PROBLEMS/HOOKS/RULES/RANDOM pages remain behind it; the old noisy RAW dump/error-code pages remain retired.
- Crystal remains ALPHA. Save Schema 5, Compatibility API 34, Diagnostics API 1, rule defaults, and package inventory are unchanged.
- Runtime retest required on Silver and Crystal vanilla/randomized Elm starters, Crystal Mom DST skip, Manual Time minutes, and DEV REPORT code-first navigation.

# 2.7.86 — Gen-2 starter grant + setup applicability runtime repair

Strict child of exact 2.7.85 (`fb8eb72e1f9292a99e047b697170b2b17b99dd0f6a241773e999ad67e4271a72`).

- Fixes the shared Gold/Silver/Crystal species resolver so canonical string species such as CYNDAQUIL/TOTODILE/CHIKORITA can resolve against Gen-2 registries keyed by numeric id or row metadata before glitch legality is evaluated. This prevents ordinary Elm starters from being rejected as malformed/glitch acquisitions.
- Restores `System Date/Time` and `System Clock Sync` to the maintained shared Gen-2 applicability allowlist, so the setup-only System Date/Time control can actually appear on Gold/Silver/Crystal configuration surfaces.
- Crystal remains ALPHA and keeps the 2.7.85 native POKEPIC/cry fail-open boundary.
- No rule defaults, save schema, Compatibility API, Randomizer algorithm, or package inventory changes.
- Runtime retest required on Silver and Crystal starter grants, Crystal setup clock bypass, and Red field-poison install health.

# 2.7.86 — Crystal Elm starter runtime safety and DEV REPORT validation repair

Strict child of exact 2.7.84 (`748c46cdee61c1e634f00a46aab48922af90e5f9fbde27926e787ef06215993e`). Crystal 2.7.84 runtime evidence establishes boot/world/Elm Lab PASS but starter-ball interaction FAIL. 2.7.86 keeps Crystal intentionally supported as ALPHA while failing only Nuzlocke's Crystal POKEPIC/cry substitution open to the native animated presentation path; the shared GIVEPOKE transaction remains authoritative for the actual starter grant. Player-facing stored-state Randomizer validation no longer compares the current 10-stream / 10-source-map / 3-projection / extensible compatibility surface against stale historical expectations, and staged-profile validation now includes the Crystal profile. No rule defaults, save schema, Compatibility API, Randomizer algorithm, or package inventory changes. Runtime retest is required.

# 2.7.84 — Gen1Recomp 0.2.24-era compatibility and Crystal Alpha support

Strict child of exact 2.7.83 (`844d12b19e063e11a4093168fd19f0653113265b78d6fc3c5e130a0ec6a296b1`). Advances `recompCompatAudited` to **0.2.24** after a fresh review of the current upstream compatibility/documentation surface and intentionally adds **Crystal** to the manifest as an **ALPHA** Nuzlocke target. Shared Gen-2 runtime classification, 251-species rule surfaces, native rule availability, Random Starter trio applicability, starter provenance fallback, Random Field Item source identity, default-name handling, and edition-parity diagnostics now admit Crystal without collapsing Crystal evidence into Gold or Silver. Nuzlocke-owned Gen-2 titles expose the support stage as `CRYSTAL ALPHA`.

Release Safety now expects the exact six-edition manifest, requires the Crystal Alpha declaration, preserves the upstream `src.ui.OptionRows` Gen-2 refusal, and verifies that `src.script.Commands` remains guarded away from Gen-2 runtime use. The audit records upstream `activeBlockAt`/`map.occupancy_allowed`, `battle.field_residual`, `mod.developer`, Custom Carts, expanded Gen-2 translation, and session-lifecycle work; Nuzlocke intentionally does not adopt the Gen-1-only field-residual hook or wholesale-migrate working map enforcement. Save Schema 5, Compatibility API 34, Diagnostics API 1, rule defaults, Randomizer algorithm state, remain unchanged. The engine floor advances to `>=0.2.24 <2.0.0` because older API-2 loaders may reject the explicit Crystal target token. Crystal runtime certification is required independently.

# 2.7.83 — Planned Rules / Setup UI and configuration pass

Strict child of exact 2.7.82 (`fd384960a0ebdfc299c42be239f23cc26ac852f5e8f447e59f0477f3df302222`). Implements only the UI/configuration batch explicitly deferred by the 2.7.82 handoff: moves the compact current/total Rules counter to the top-right without consuming a list row; replaces sequential Nuzlocke Loadout stepping with a direct chooser and preserves exact change-count/confirmation safety; replaces numeric Difficulty stepping with direct profile selection backed by `difficultyProfileSummary()` and `difficultyStackWarning()`; adds an in-run Gold/Silver Manual Time action that writes through the native Gen-2 Clock, preserves minute/weekday, and disables continuous System Clock Sync; and clarifies that selected Starting Poke Balls are delivered only after capture unlock. Crystal support and the encounter battle-overlay redesign remain deferred. Rule defaults, Save Schema 5, Compatibility API 34, Diagnostics API 1, Randomizer mappings, and the five-edition manifest target set are unchanged. Runtime validation is required.

# 2.7.82 — Silver runtime hardening and diagnostic separation


Strict child of exact 2.7.81. Recovers only the reviewed historical 2.6.82 runtime-hardening batch after comparison: resolves Gen-2 special operands through `Vm:specialName()` for Mom's full System Date/Time DST ladder; adds a final one-shot `Vm:showRaw` Elm confirmation fallback; finishes starter Tracker provenance from the committed native Elm story event only under a zero-badge, exactly-one-party-Pokémon proof; installs the actual Gen-2 PartyMenu NUZ INFO wrapper without an early global-edition decision and passes the exact lifecycle Game into `G2.installAll(game)`; removes build/package Release Safety and generated NZR/NZERR/hash/raw-machine output from player-facing Dev surfaces; and updates Release Safety's role-specific documentation-header audit. Starting Poké Ball timing, Crystal support, presets/difficulty UI, manual Gen-2 time selection, rule defaults, public APIs, save schema, and engine range are unchanged. Runtime retest remains required.


Strict child of exact 2.7.80. Recovers the reviewed 2.6.81 compatibility batch only: advances the source-audited Gen1Recomp profile to 0.2.21; preserves the exact Red/Blue/Yellow/Gold/Silver manifest target set while upstream `gen2` expands to Crystal; records `mod.developer` separately from player Dev Mode; marks NuzlockeConfigScreen, NuzlockePokemonBanScreen, and NuzlockeModCompatScreen as genuine mod-options surfaces; completes System Date/Time coverage for both `InitialSetDSTFlag` and `InitialClearDSTFlag`; and clears `rtc.dst` while host-local clock authority is active. Release Safety protects these contracts and the Gen2 `src.ui.OptionRows` incompatibility trap. No 2.6.82+ runtime-fix behavior is included.

- Strict child of exact 2.7.79.
- Ports only the reviewed mistaken 2.6.79 -> 2.6.80 delta: deeper Elm randomized-confirmation fallback, pending post-GIVEPOKE starter finalization, narrowly proven legacy starter reconciliation, Gen-2 System Date/Time, Gen-2 System Clock Sync, and safe B-cancel for multi-candy Rare Candy TO CAP batches.
- Clock writes use the engine's native Gen-2 Clock authority; the preferred opening skip has a defensive InitClock auto-confirm fallback.
- Candy cancellation is boundary-safe: B never interrupts the current candy transaction, move learning, stat presentation, or evolution halfway through.
- Species equality remains forbidden as general starter identity evidence.
- No 2.6.81+ compatibility/clock corrections or later mistaken-package behavior are included.
- Static/parse/integrity validation only; exact-edition runtime testing remains required.

# 2.7.79 — Gen-2 Elm starter authority / utility titles

- Strict child of exact 2.7.78.
- Ports only the reviewed mistaken 2.6.78 -> 2.6.79 delta: Elm starter classification by live Gen-2/Elm/GIVEPOKE context, proven-starter native Elm story reconciliation, rendered-preview confirmation authority, additional Gen-2 starter reachability diagnostics, tightly scoped identity-less LEGACY starter cleanup, and the shared Gen-2 Nuzlocke utility-title hierarchy.
- Empty party is no longer the deciding Elm starter predicate; fresh starter registration still never merges by species.
- Native Gold/Silver game UI and the native Mod Manager are not restyled.
- No 2.6.80 post-GIVEPOKE finalizer, system-clock QoL, or later mistaken-package behavior is included.
- Static/parse/integrity validation only; exact-edition runtime testing is still required.

## 2.7.78 — Starter identity / recovery parity

- Strict child of exact 2.7.77.
- Ports only the reviewed mistaken 2.6.77 -> 2.6.78 delta: identity-idempotent starter registration/history, conservative existing-save duplicate repair, safer Pallet -> New Bark migration, Gold/Silver Recover Catches parity, and identity-preserving manual recovery.
- Same-species Pokemon are never merged by species alone.
- No 2.6.79 starter-story/rendered-preview reconciliation or later mistaken-package behavior is included.
- Static/parse/integrity validation only; exact-edition runtime testing is still required.

# 2.7.77 — Silver/randomizer usability recovery

- Strict child of exact 2.7.76.
- Ports only the reviewed mistaken 2.6.76 -> 2.6.77 delta: direct Gen-2 PartyMenu targeting, randomized Elm confirmation text, starter grant-delta fallback, ordinary-interior Tracker filtering, and live Reroll/Auto Seed controls.
- No 2.6.78 identity-idempotence/recovery work or later mistaken-package behavior is included.
- Static/parse/integrity validation only; exact-edition runtime testing is still required.

## 2.7.76 — Gen-2 authority / Silver parity recovery

- Strict child of exact 2.7.75.
- Ports only the reviewed mistaken 2.6.75 -> 2.6.76 repair delta: edition-correct starter hometown provenance, conservative early-starter migration, Gen-2 Tracker seed isolation, script-authority consolidation, PartyMenu NUZ INFO fallback, and reachability diagnostics.
- Does not include later 2.6.77 randomizer/QOL/UI corrections.

## 2.7.75 — Silver shared Gen-2 parity recovery

- Strict child of exact packaged 2.7.74.
- Recovers only the reviewed semantic delta from mistaken 2.6.74 -> 2.6.75.
- Exact GOLD/SILVER/CRYSTAL identities now force the shared Gen-2 runtime predicate when engine generation helpers fail to identify the title.
- This reconnects Silver to the existing shared Gen-2 adapter path instead of allowing accidental Gen-1 fallthrough.
- Gen-2 parity diagnostics now also verify the shared predicate plus gift-tracking and capture-gate installer success.
- No separate Silver clone was introduced.
- No Randomizer mapping, rule default, save schema, Compatibility API, native host UI, or package inventory change.

## 2.7.74 — Gold utility-screen visual normalization

- Strict child of exact runtime-observed 2.7.73.
- Recovers only the post-2.7.72 presentation delta from the mistaken 2.6.74 child.
- Gold Nuzlocke-owned DEV REPORT, CATCH INFO, STAT INFO, and MOVE INFO use centered emphasized primary titles.
- NUZ INFO Pokémon/subject subtitles are centered at normal weight.
- Gold STAT INFO uses compact fixed `STAT / VAL / DV / EXP` columns.
- Gold CATCH INFO uses denser label/value rows and the utility footer/body spacing is normalized.
- No gameplay rules, Randomizer mappings, Save Schema, Compatibility API, supported editions, or native Gen1Recomp UI are changed.

## 2.7.73
- Reconstructed strictly from exact 2.7.72.
- Recovered Late Runtime dependency-order fix: rule-message helpers are resolved live instead of captured as possibly-nil registration-time snapshots.
- No gameplay-rule semantics, defaults, Randomizer mappings, Save Schema, or Compatibility API changes.

## 2.7.72 — Shared UI ownership hardening

- Explicit `wide` layout requests now fall back to the classic surface unless a usable wide-layout provider reports a real wider size; `applyLayout()` claims the resolved layout instead of the raw request.
- Shared Gen 1/Gen 2 row primitives now support caller-owned `preFitted` text.
- Both live R/B/Y Tracker tabs mark only their selected marquee row as pre-fitted, preventing the shared pixel fitter from adding a second ellipsis to an already-finalized scrolling slice.
- Non-selected Tracker rows retain the shared defensive pixel fit.
- Release Safety protects both contracts.

## 2.7.71 — T3 World Building dialogue cleanup

- Removes the generic T3 run-summary page that was appended after unrelated World Building/rule dialogue.
- Messages such as `1 teammate lost in this run.`, badge totals, catch totals, and the opening-chapter line are no longer injected globally by `worldFlavorText()`.
- T3 keeps its richer regional/flavor wording; only the unrelated recap page is removed.
- Consequential post-encounter failure feedback from 2.7.70 remains unchanged and still fires at every World Building tier.
- Release Safety now checks that generic T3 dialogue cannot regain the global run-context append.

## 2.7.70 — Encounter feedback contract cleanup

- Retires the obsolete player-facing `Encounter Indicator` rule and the dead built-in battle HUD installation path. The old always-on AREA:COUNT / AREA:SPENT overlay remains intentionally removed.
- Preserves the read-only `encounterSpendIndicator()` semantic projection for compatibility/information consumers; it no longer depends on a player toggle.
- Post-battle failed-encounter feedback is now routed through one dedicated helper and remains consequential feedback at every World Building tier.
- World Building OFF/T0 and T1 use the plain failed-encounter explanation; T2 adds challenge flavor; T3 uses the richer regional wording.
- Release Safety now verifies that the retired battle HUD cannot silently return and that failed-encounter feedback keeps its all-tier critical-feedback contract.

## 2.7.69 — Combined Shop Restrictions

- Replaces the two public `No Buying` / `No Selling` rows with one `Shop Restrictions` selector.
- Modes are `OFF`, `NO BUY`, `NO SELL`, and `NEITHER`.
- Existing saves migrate losslessly: the previous two booleans are converted into the matching four-state mode.
- Legacy `no_buying` / `no_selling` state remains synchronized internally so existing R/B/Y, Gold/Silver, Randomizer, world-building, compatibility-provider, and transaction-gate code keeps the same behavior.
- Presets, Difficulty profiles, and compatibility paths that still write the legacy booleans reverse-sync the combined selector, preventing UI/state disagreement.
- Game Corner restrictions remain a separate `No Gambling` rule.

## 2.7.68 — Rule applicability & dominance audit completion

- Completes the planned Battle Mechanics, Battle Clauses, Battle/Field Items, Services & Economy, World, and QoL applicability pass.
- The reviewed shared mechanics now carry an explicit Red/Blue/Yellow/Gold/Silver native-edition matrix instead of relying only on generation-wide assumptions.
- Gen-II content-specific `Radio Nuzlocke` and `Skip Cherrygrove Tour` remain native only where their content exists, but can become available elsewhere only through explicit `pokegear_radio` / `cherrygrove_tour` provider capabilities.
- `Evasion Clause` is now hidden and behaviorally dormant when `No Setup Moves = ALL`, because that stronger clause already blocks every positive evasion-stage boost on both sides. SELF/ENEMY setup scopes remain distinct, so Evasion Clause stays available there.
- No false dominance was added between healing-item, field-heal, PP-item, Center, Mom, buying/selling, gambling, or stat-drop rules because those retain independent legal effects.
- Release Safety now trips if this reviewed exact-edition matrix, provider gating, or battle-clause dominance wiring disappears.

## 2.7.67 — Difficulty profile review

- Changing Difficulty now opens a dedicated full-screen profile browser before anything is committed.
- Left/Right cycles every available Difficulty mode; each mode gets its own page showing its trainer changes versus VANILLA.
- Up/Down scrolls longer change lists. A confirms the displayed profile; B returns with no mutation.
- After A, the existing Difficulty interaction warning still appears when the transition affects other rule semantics; only confirming that warning applies the change.
- External Difficulty providers receive their own page and are identified as provider-owned rather than inventing unsupported internal details.

## 2.7.66 — Exact-game audit, pass 2

- Continues the rule-availability audit in a deliberately small pass.
- Yellow no longer exposes Random Starter `Trio Typing` as a native rule because Yellow does not natively use the three-choice starter slate; an explicit compatible `starter_trio` provider can make it available.
- Encounter-slot modifiers now depend on `One Per Area`: Failed Encounters, Dupes, Gen II roamer/egg/contest policies, Town Catches, and area/time/headbutt split controls become dormant while area encounter limits are OFF.
- Type Locke now exposes/effects only the lanes selected by its mode. Catch Draft is hidden while Type Locke is OFF; manual type lanes are hidden/inert during Catch Draft; DUO through HEXA progressively reveal only the required lanes.
- Stored values are preserved while dormant and return when their prerequisite becomes applicable again.
- Release Safety extends the exact-edition/dependency source tripwire for these relationships.

## 2.7.65 — Rule availability / suppression architecture

- Rules now have a shared exact-edition availability contract for Red, Blue, Yellow, Gold, and Silver.
- Mechanics that are not native to the running edition are hidden and behaviorally inert; compatible providers may expose explicitly capability-gated mechanics.
- Dependency and dominance suppression preserve stored choices while preventing hidden child rules from affecting gameplay.
- Randomizer subordinate rows collapse when their owning randomizer feature is OFF; No Catching and No Status Moves suppress redundant subordinate restrictions.
- Kanto-only route/Mt. Moon/Safari and R/B/Y Gym Guide controls no longer appear as native Gen II rules.
- Release Safety audits the availability graph, exact-edition metadata, dependency cycles, and UI/effective-state wiring.

# 2.7.65 — exact-edition rule availability and rule suppression

- Audits rule applicability separately for Red, Blue, Yellow, Gold, and Silver instead of assuming every shared catalog row is meaningful everywhere.
- Rules for mechanics absent from the active game are hidden and behaviorally inert. A compatible provider may make an explicitly capability-gated mechanic available without changing Nuzlocke challenge-policy ownership.
- Centralizes parent/dependency and dominance suppression so subordinate settings keep their stored preference but disappear and have no effect while their parent is OFF or a stronger rule supersedes them.
- Randomizer subordinate controls now follow the same shared dependency contract, reducing inactive Randomizer clutter without deleting saved configuration.
- Corrects native applicability for R/B/Y Gym Guide Rare Candy and Safari Zone policy, and treats overworld-spawn encounter policy as provider-enabled rather than a native mechanic.
- Adds Release Safety validation for unknown dependencies, contradictory edition flags, and dependency cycles.

# Nuzlocke 2.7.64 — MOD COMPAT ownership controls

> **Lineage:** **2.7.64** is a strict child of exact **2.7.63** (`807ee2f1e45fda6e0f472a86af6e49d7f0ce34c2e879c15b277f4511b18df7a1`).

- MOD COMPAT Left/Right owner cycling for capability-backed rows only.
- AUTO/native/provider preferences feed the live compatibility-provider resolver rather than changing display text only.
- Gameplay-impacting ownership changes are pre-confirmed with the shared warning modal; Cancel performs zero mutation.
- Missing/inactive pinned providers fail open to AUTO.
- Fixed Nuzlocke policy and host-owned presentation rows remain read-only.
- Added Release Safety coverage for provider candidate retention, persisted preferences, resolver integration, owner cycling, and warning-before-mutation.

# Nuzlocke 2.7.63 — Gen II Tracker parity + Difficulty impact confirmation

> **Lineage:** **2.7.63** is a strict child of exact **2.7.62** (`f0dcd4550671d7adb67886b54a6fd801b19fbf510efba2781b1e3d75b68b27bd`).

- Fix Gold/Silver Encounter Tracker MAP using Gen I seed rows/order instead of the active Gen II map catalog.
- Discover Gen II map tables and order rows by the host `gen2Constants.mapOrder`; keep New Bark Town as the starter hometown.
- Preserve already-recorded town encounter evidence even when Town Catches is subsequently disabled.
- Add a pre-commit Difficulty impact warning using the existing confirmation UI; Cancel performs no mutation.
- No Randomizer RNG/mapping, save schema, encounter accounting, or battle-rule semantics changed.

# Nuzlocke 2.7.62 — Gen II healing-service parity

> **Lineage:** **2.7.62** is a strict child of **2.7.61** (`8fb0ea8517e03cdac3bb387bfcd2c3a0c1b673169637716676a9837f6dddef9c`).

- Runtime evidence on Gold: **No Buying PASS**, **No Selling PASS**, **No Center Heal FAIL** on 2.7.61.
- Repairs Gold/Silver No Center Heal at the authoritative Gen II `special HealParty` script-command seam. The gate applies only on Pokemon Center maps and ends the heal transaction before native success animation/dialogue.
- Repairs the adjacent No Mom Heal parity gap at the same semantic seam, scoped only to `PLAYERS_HOUSE_1F`; unrelated story heals, including first-rival continuation healing, remain native.
- Adds a Release Safety `gen2_semantic_seams` audit that verifies the shipped Gen II adapter installs the advertised healing, mart, capture, nickname, gift, trade, static, held-item, field-item, and whiteout owners.
- Focused parity review found no additional obvious missing Gen II installer among the public RBYGS semantic-coverage operations; exact-edition runtime evidence remains independent and required.

## Nuzlocke 2.7.61 — canonical UI lineage

> **Lineage:** **2.7.61** is a strict child of **2.7.60**. Nuzlocke-owned UI changes remain independent; third-party UI references are compatibility-only.


- Repairs Yellow/Gold runtime-observed overlap in Tracker, Rules/Setup, Dev Tools, status rows, and footer/detail regions.
- Adds explicit shared header/body/detail/footer frame geometry for Nuzlocke-owned custom screens.
- Reduces Dev Report/Known Issues/Storage visible-line budgets so content cannot enter the footer band.
- Removes duplicate loadout-confirmation cancel presentation on Gen 2.
- Fixes the Randomizer diagnostic snapshot crash caused by calling `projectionState` as a global function instead of reading the authoritative projection-state table.
- Hardens UI compatibility around Gen1Recomp's stable widget/input/screen-stack conventions; gameplay semantics are unchanged.

# Nuzlocke 2.7.60

- Startup hardening pass for the UI lineage.
- Presentation-only World Building source/catalog audits no longer abort mod loading; failures are preserved for Dev diagnostics and Release Safety promotion gates instead.
- Release Safety now audits dead-fallback coverage across both `main.lua` and `world_building.lua`, and explicitly checks Maximum BST rejection detail coverage.
- Dev diagnostics mirror the expanded presentation audits.
- Gameplay-critical startup guards remain fail-fast. No rule semantics, saves, encounter accounting, Randomizer RNG/mappings, or UI design expansion changed.

# 2.7.59 — Startup recovery / catalog-golden repair

Strict child of exact **2.7.58** (`258d40c5c5f64959a8a8e1f65ede5048377b6b9b841a56d4ac677b661835e351`).

- Fixes the runtime-blocking startup failure in `world_building.lua`: the live 104-key presentation catalog computes semantic checksum `513036232`, while the stale protected golden still expected `926265119`.
- Refreshes the golden to `513036232` without changing any World Building dialogue rows, rule legality, persistence, or Randomizer behavior.
- Hardens startup so future World Building **presentation-only** snapshot drift is recorded/logged and caught by Dev/Release Safety instead of aborting the entire mod during module initialization.
- Preserves 2.7.58 as the exact immediate parent.

# 2.7.58 — Controlled shared-component compatibility pass

- Strict child of exact 2.7.57 (`f5bb6c38bcc539b90d2bffa867209314da3e0de03e15b76bdc1ea3851741149a`); canonical 2.7.54 was the original fallback/root during development.
- Extends the shared Nuzlocke UI row and notice primitives to both Gen I and Gen II presentation paths.
- Migrates the F. TOKEN menu family and the Dev Tools action list onto shared focus/row/notice presentation while preserving their existing gameplay, token, diagnostic, and input semantics.
- Keeps text measurement provider-neutral and adds compatibility hardening for variable-width font providers; Nuzlocke does not own global kerning.
- Continues Wide Menus compatibility hardening through explicit Nuzlocke screen layout policies and parent/child surface continuity.
- Does not migrate DEV REPORT internals or Randomizer screens in this pass. Runtime/UI verification remains required.

# 2.7.57 — Typography and semantic-component pass

- Removes the Nuzlocke-owned Gen 1 kerning wrapper/table from the forward lineage. Nuzlocke now consumes live authoritative font metrics and does not own glyph advances or glyph offsets.
- Adds shared typography measurement, fit, wrapping, and right-edge alignment primitives to the Nuzlocke UI system.
- Adds shared semantic row focus/status classification and a standardized notice model/render primitive.
- Expands the Dev-only UI Gallery from four to five pages with variable-width text, right-alignment, long-label, and notice/wrapping stress fixtures.
- Corrects forward-lineage provenance: exact immediate parent is 2.7.56 (`8f5a4c46146f190350197a411c22e29856b540a3c50ad5754660e24b6a0cf9d6`); exact canonical 2.7.54 was the original fallback/root during development.
- Compatibility hardening targets variable-width/kerning font providers without requiring or reproducing any provider-specific glyph behavior.
- No gameplay rule semantics, Save Schema, Randomizer algorithm/RNG stream, encounter accounting, or native/external gameplay UI ownership changed. Runtime UI certification remains required.

# 2.7.56 — UI architecture build

- Adds explicit per-screen layout policies and logical-surface context so Nuzlocke-owned screens no longer assume a fixed 160x144 canvas.
- NUZ RULES / Setup can use a true 38-column wide composition on compatible Gen 1 hosts while retaining the same rule semantics and controls.
- ENC TRACKER now reallocates its area/result lanes on a wide logical surface instead of scaling a 160px drawing. Gold/Silver remain on the native Gen 2 Chrome path.
- Small confirmation and F. TOKEN flows use centered presentation policy to avoid unnecessary full-width dialogs.
- Adds a Dev-only, read-only UI Gallery with hierarchy, tracker-state, diagnostics, and long-label stress fixtures.
- Adds compatibility hardening for host UI width providers through their public layout contract; Nuzlocke remains functional without such providers.
- No gameplay rule semantics, Save Schema, Randomizer algorithm/RNG stream, or seeded mapping contracts changed. Runtime UI certification remains required.

# 2.7.55 — UI architecture build

- Adds a Nuzlocke-owned semantic UI system with shared Gen 1 / Gen 2 header, footer, fit, status, and composition primitives.
- Migrates Setup/NUZ RULES and ENC TRACKER headers onto the shared presentation contract while retaining their existing rule, encounter, input, and save logic.
- Establishes exact-edition presentation context for Red, Blue, Yellow, Gold, and Silver through the same Nuzlocke UI vocabulary.
- Keeps native/external Bag, PC, Party, Pokédex, battle, Mart, and other host presentation surfaces outside Nuzlocke UI ownership.
- Adds compatibility-oriented presentation boundaries for alternative UI renderers; no specific third-party renderer is made authoritative for Nuzlocke gameplay.
- Package tree is 31 files because the promoted shared UI system is isolated in its own module; 31 files / 21 Lua is the new canonical package contract.
- No gameplay rule semantics, Save Schema, Randomizer algorithm/RNG stream, or seeded mapping contracts changed. Runtime UI certification remains required.

- Adds a synthetic, read-only external-save reconciliation regression audit covering adjacent PC-locked party entries, persistent-death HP restoration, and external party-size over-cap detection.
- Adds Release Safety detection for accidental calls to later `local function` helpers without an explicit forward declaration; this guards the historical implicit-global/forward-reference failure shape without modifying `_G` or `_ENV`.
- Documents Encounter Tracker display evidence precedence directly in `getTrackerMapRows`: tracker log > failed encounter state > caught-areas legacy fallback > unknown.
- Repairs inherited Release Safety immediate-parent constants so executable and independent provenance both identify exact 2.7.53.
- No gameplay rule semantics or Randomizer seeded contracts changed.

# 2.7.53

- Replaces the binary Safari Splits presentation with **Safari Clause**: STANDARD, PER AREA, UNTIL CATCH, and AREA+CATCH.
- Existing persisted values 0/1 retain their exact old whole-zone/per-area behavior.
- UNTIL CATCH modes suppress Safari failed-encounter consumption only; successful catches still consume the projected Safari slot normally.
- Tracker/catch projection remains live and deterministic across whole-zone/per-area changes.

- Phase J #10: adds a read-only full seed reproducibility matrix across every named Randomizer stream using synthetic fixed seeds, repeated-input checks, and cross-stream isolation checks.
- Phase J #11: adds Randomizer release/documentation contract auditing and Release Safety build-marker reconciliation across the primary shipped documentation.
- Runtime certification remains deferred to Phase J #12.

## 2.7.51
- Phase J #7–9: Randomizer performance, save-schema/migration, and BLIND/OPEN information-leak certification audits.
- Added read-only certification surfaces; no new randomized gameplay surface.

## 2.7.50

- Phase J #4: added read-only progression-safety certification for key/story/quest/HM/provider-protected item contracts and existing economy/evolution safety audits.
- Phase J #5: added a declarative Randomizer x Nuzlocke-rule interaction matrix and audit covering capture rules, PKMN BAN, Maximum BST starter exemption, level/difficulty composition, and No Buying/No Selling/No TMs ownership.
- Phase J #6: added read-only provider/delegation certification across all nine Randomizer subsystems and live-registry projection ownership contracts.
- Runtime gameplay/provider certification remains separate and is not claimed.

# 2.7.50

- Phase J #1: added a read-only static determinism audit for RNG stream registry/isolation and canonical sorted species/move candidate pools.
- Phase J #2: added a read-only save/reload determinism audit covering every persisted Randomizer source-map bucket and the authoritative persisted-mapping policy.
- Phase J #3: added cross-edition determinism auditing and fixed the deferred Silver Field Item ALLOW identity debt. Gold preserves the historical `gold:` namespace; fresh Silver ALLOW placements now use `silver:`. Existing persisted mappings remain authoritative.
- No Randomizer algorithm version or existing stream name changed. Exact-edition runtime certification remains required.

# 2.7.48

- Randomizer Phase I #10-12: explicit mid-run setting-change policy, comprehensive seed reproducibility reporting, and a whole-Randomizer read-only regression harness.
- Existing materialized source mappings remain authoritative after mid-run setting changes; unseen sources use current settings and drift is reported against the immutable run-start contract.
- Corrected executable/release-safety immediate-parent provenance to exact 2.7.47.

## 2.7.47 — Randomizer Phase I #7–9

- Unified OPEN/BLIND spoiler ownership across Randomizer information surfaces; BLIND now authoritatively suppresses requested species/item reveals.
- Hardened provider delegation across all nine Randomizer subsystems and fixed subsystem ownership detection to recognize the provider ownership records returned by the compatibility layer.
- Integrated Randomizer presets with both staged NEW GAME Setup and live rules through the same provider-aware configuration path; added a read-only Phase I integration audit.
- Expanded the Randomizer compatibility snapshot from the original four systems to all nine current subsystems.

# Nuzlocke 2.7.46 — Randomizer Phase I #4–6

Strict child of exact 2.7.45 (`9cfc18508b24cafce9bc3205b5c47784873c199ac8bb5f34d17db776eb10dfe9`). Continues Randomizer Integration & Presets with a read-only cross-randomizer compatibility matrix/audit, an eight-digit seed share/import presentation contract, and deterministic subsystem version reporting. These additions consume no RNG and do not rename existing streams or rewrite persisted mappings. Phase I #7–12 remain.

# Nuzlocke 2.7.45 — Randomizer Phase I #1–3

Strict child of exact 2.7.44 (`c435d2f4247bb4a9d4a72a44695121f657f0aa9fb84dcd74864b4dfadbeff254`). Begins Randomizer Integration & Presets. Adds a unified CUSTOM/CHAOS/BALANCED Randomizer preset layer, a read-only subsystem ownership registry that preserves external-provider delegation, and shared Species Pool semantics for Starter/Encounter/Trainer/Evolution randomizers. Presets are deterministic convenience configuration only: they do not change the shared seed or existing RNG stream names/versions, and manual child edits return the preset to CUSTOM. Phase I #4–12 remain.

# 2.7.44 — Randomizer Phase H #10–12

Strict child of exact 2.7.43. Completes Phase H implementation/certification scaffolding: Gold/Silver Pack and item-PC transfers remain native identity/quantity moves and never reroll randomized acquisitions; Randomizer Info gains read-only Shop/TM/Gift mapping coverage with BLIND suppression; and an executable economy/progression regression audit checks diagnostic immutability, authoritative No Buying/No Selling/No TMs ownership, progression protection, native pricing, and Gen2 storage non-reroll contracts. Exact-edition runtime cases remain required before Runtime PASS.

# 2.7.43

- Randomizer Phase H #7–9: NPC reward-item projection, centralized key/progression exclusions, and No Buying / No Selling / No TMs interaction hardening.
- Dedicated reward command adapters preserve native quantity/flags/capacity/transaction ownership and fail closed through the shared protected-item classifier.
- Random Shops remains content-only before purchase/sale gates; Random TMs remains content-only before TM-use legality.

# 2.7.43

- Randomizer Phase H #4–6: adds deterministic TM-content randomization, explicit TM compatibility policy (MOVE/SLOT/FULL), and ordinary scripted gift-item randomization. TM identity, HMs, key/progression items, quantities, script flags, inventory capacity, and native transaction ownership remain protected. Gift rewards with dedicated/non-GIVEITEM seams remain Phase H #7. Phase H #7–12 remain pending.

# 2.7.41

- Randomizer Phase H #1–3: adds deterministic ordinary Mart stock randomization through a new isolated SHOPS stream, PRICE TIER/BALANCED semantic shop policies, and hard economy safety that preserves native item prices and transaction ownership. Key/progression items, HMs, TMs, and Gen2 Bargain Shop custom-price rows remain authored. Phase H #4–12 remain pending.

# 2.7.40

- Randomizer Phase G #10-11: Starter, Trainer, and Encounter evolution classifiers remain anchored to immutable authored topology; added read-only evolution diagnostics/audits. Phase G #12 remains deferred.

## 2.7.39

Strict child of exact 2.7.38. Implements Randomizer Phase G #7–9: split evolutions prefer distinct hard-safe targets, while evolution method/trigger metadata is treated as immutable target-adjacent data. Level, stone/item, trade, friendship, and Gen2 time/stat-specific conditions remain authored; a projection guard restores the authored row if any non-target trigger metadata changes. Existing single-row seeded evolution identities remain unchanged. Phase G #10–12 remain later work.

# Changelog

## 2.7.38
Strict child of exact 2.7.37 (`cd22c7378b77cf5e9e7916195bd9cf30566b663bfee268d3f6211692ee58dd27`). Implements Randomizer Phase G #4–6: prevents newly-created evolution cycles/self-evolutions, adds original-chain DEPTH preservation, and adds SIM BST/BALANCED target selection with deterministic relaxation. Hard-safe construction and acyclic topology are never relaxed. Also fixes evolution-only Randomizer seed/info visibility and prevents Evolution Randomizer from exposing Trainer-only child settings. Phase G #7–12 and all deferred #12 certification remain pending.

## 2.7.37

Strict child of exact 2.7.36 (`e0350c60c95584241c0b965f9e9668c259aa3ffc5b7e16aa6dc3ba560d27c3b7`). Begins Randomizer Phase G with steps #1–3: immutable original evolution topology, deterministic evolution-target projection using an isolated EVOLUTIONS stream and exact-edition/species/row identities, and hard-safe constructible target selection. Evolution source species and native trigger metadata remain unchanged; starter/rival lineage reads the original topology. Existing Randomizer algorithm v1 streams are not perturbed. Phase G #4–12 and subsystem #12 runtime certification remain deferred.

## 2.7.36

- Advances Randomizer Phase F through steps 10–11: boss specialization and Difficulty/trainer-party provider composition hardening.
- Boss TYPE themes now anchor on the authored ace; non-CHAOS boss balance softly avoids replacements below 90% of authored BST when a qualifying hard-safe candidate exists.
- Reorders the Random Trainers composition seam so base/provider parties resolve first and built-in Difficulty transforms the randomized species afterward, keeping Difficulty-generated moves/items/stats coherent with the final species.
- Leaves Phase F #12 exact-edition regression certification deferred.

## 2.7.35

- Advances Randomizer Phase F through steps 7–9: trainer-team diversity, optional type cohesion, and rival starter synchronization under simultaneous Random Starter + Random Trainers.
- Adds Trainer Diversity (OFF / DIVERSE / UNIQUE) and Trainer Theme (OFF / TYPE). Enabled team policy uses a versioned `tt1` namespace; both OFF preserve the 2.7.34 mapping path.
- Canonical rival starter-family members now bypass independent Trainer-stream replacement while Random Starter owns their lineage, including the no-op case where the synchronized species equals the authored species.
- Party size, order, levels, hard legality, PKMN BAN, and Trainer Balance remain preserved. Phase F #10–12 remain pending.

## 2.7.34

- Advances Randomizer Phase F through steps 4–6: hard trainer species-pool legality, evolutionary-stage scaling, and BST/power balancing.
- Adds Trainer Balance: CHAOS / EVO / SIM BST / BALANCED. CHAOS preserves the 2.7.33 mapping/seed input; non-CHAOS modes use a versioned trainer-policy namespace.
- Trainer hard safety rejects reserved/missing/glitch/runtime-unsafe species and honors PKMN BAN without incorrectly applying player-only acquisition restrictions to enemy teams.
- Repairs the inherited 2.7.33 manifest/runtime build-identity mismatch and fixes RNG status visibility for trainer-only randomizer runs.
- Phase F #7–12 remain pending.

## 2.7.33

- Began Randomizer Phase F with steps 1–3: stable exact-edition trainer-party source identities, isolated deterministic trainer-species replacement, and preservation of party size/order/levels and trainer/story identity.
- Added the dedicated `TRAINERS` RNG stream and persisted trainer-slot source map without changing existing randomizer stream names or established seeded inputs.

# 2.7.32 — Gold help-position cues + feedback style contract

- Adds an above-position `^` cue when Gold long-help text is scrolled below the first wrapped-line position.
- Keeps the native Gold down-arrow whenever additional wrapped lines remain below.
- Adds a compact exact scroll-position counter to the Gold help footer (`SEL:MORE n/N`, `SEL:TOP N/N`).
- Explicitly documents that the counter reports line-scroll positions, because Select advances one wrapped line rather than one four-line page.
- Adds a shared rule-feedback language contract covering mechanical blocks, state explanations, World Building flavor, critical/T0 feedback, and configuration descriptions.
- No Randomizer behavior changes; the deferred Learnset policy-alias and Gold 3-STAGE Starter Style bugs remain pending.

# 2.7.31 — Gold help paging repair

- Makes Gold Select-alone help scrolling use the same native `Chrome.wrap()` text and 4-line geometry as the renderer.
- Adds visible `SEL:MORE` and `SEL:TOP` paging hints in the Gold help pane.
- Preserves Select+Up/Down section jumping and all existing A/Left/Right rule editing.
- Centralizes dynamic description text used by paging/rendering so Locke Type summaries and Permanent Rule Seal warnings cannot calculate a different scroll range from what is displayed.
- Repairs malformed duplicate quote characters in the inherited 2.7.30 provenance SHA literals while updating lineage to exact 2.7.30.
- No Randomizer behavior changes; the Gold 3-STAGE Starter Style issue remains pending.

# 2.7.30 — Randomizer Phase E items 10–11

- Centralizes learnset species/row safety for provider-owned/protected content and live move hard-safety.
- Keeps Gen1 `level1Moves`/`learnset` and Gen2 `levelMoves` as the single projected source used by normal evolution/level-up/relearn consumers.
- Adds spoiler-aware read-only Learnset diagnostics and a no-mutation diagnostic audit.
- Advances Learnset policy namespace to `lp4`; existing legal prior mappings remain migration candidates.
- Phase E #12 remains pending.

# 2.7.29 — Randomizer Phase E items 7–9

- Adds early-game learnset move-quality floors as deterministic soft weighting: usable early damaging moves are favored while every hard-safe candidate remains reachable.
- Adds explicit Learnset STAB control: OFF / PREFER / STRONG. PREFER preserves the established mild same-type affinity; STRONG increases it without becoming a hard requirement.
- Adds progression-aware damaging-move power scaling using authored slot power when available blended with a conservative learn-level curve.
- Advances the Learnset policy namespace to `lp3`; legal earlier mappings remain migration candidates under the existing stable-choice migration contract.
- Expands the Phase E foundation audit for STAB modes, early quality, and progression power.
- Phase E #10–12 remain pending.

# 2.7.28 — Gen2 boot/title repair

- Fixes the inherited Gen2 late-runtime dependency-order failure by materializing shared rule-message helpers before `late_runtime.lua` loads.
- Adds a Gen2 `MainMenu.buildList` final-list fallback for fresh Gold/Silver title sessions on Gen1Recomp 0.2.20.
- Preserves NEW-GAME-only setup semantics: an existing save/CONTINUE row suppresses SETUP and stale Nuzlocke-owned SETUP rows are removed.
- Adds active-wrapper audit coverage for the Gen2 `buildList` wrapper and Release Safety coverage for late-runtime message dependencies.
- Preserves Randomizer Phase E items 1–6 unchanged.

# 2.7.27 — Randomizer Phase E items 4–6

- Completes Phase E #4 hard move safety: sentinel/missing moves, invalid/broken/unusable/disabled/placeholders/internal-only records, explicit provider opt-outs/policies, nameless records, and non-positive/missing PP records are excluded as hard constraints. Zero-power fixed-damage/special-effect moves remain legal when otherwise valid.
- Adds Phase E #5 type-aware move weighting. Candidate moves matching any live species type receive a mild deterministic soft weight; every hard-safe move remains reachable. This is infrastructure/default affinity only, not the configurable STAB controls reserved for Phase E #8.
- Adds Phase E #6 damaging/status balance by softly preferring replacements with the same damaging-vs-status semantic shape as the authored move slot while keeping every hard-safe candidate reachable.
- Learnset policy namespace advances to `lp2` for fresh policy-weighted results, while legal prior `gN` mappings are adopted for upgraded runs instead of being gratuitously rerolled.
- Hardens generic `stableChoice` legacy adoption so a simultaneous policy-namespace + storage-identity upgrade can recover the historical seed/source slot.
- Expands the Phase E Release Safety audit with hard-safety, weighting, and deterministic weighted-selection checks.
- No Phase E #7–12 features are implemented here; Randomizer algorithm version remains 1.

# 2.7.26 — Randomizer Phase E items 1–3

- Migrates Learnset Randomizer move selection onto the shared candidate-policy engine.
- Adds immutable `LEARNSET_SOURCE:v1` identities preserving species, authored table shape, slot index, and authored level independently of the randomized move.
- Preserves historical algorithm-v1 LEARNSETS RNG identity/mappings by separating new storage identity from the legacy seed slot and adopting legal historical rows.
- Adds pass-scoped semantic move metadata (type, category, damaging/status state, power/power band, accuracy, priority) for later Phase E balancing steps; items 1–3 intentionally add no new weighting/preferences.
- Adds hard-safe candidate filtering for missing/sentinel and explicitly provider-protected/broken/unusable moves.
- Adds a Release Safety Phase E foundation audit for source-identity and semantic-classification invariants.
- Phase E items 4–12 remain unimplemented/deferred.

# 2.7.25 — 2.7.x release promotion

- Promotes exact 2.7.24 as the 2.7.x release build.
- Carries forward the completed second/third-pass hardening, documentation audit, Gen1Recomp 0.2.20 source audit, and Run History normalization persistence fix.
- Release promotion itself changes only version/provenance/release documentation.
- No new gameplay semantics, Randomizer algorithms/mappings, Save Schema, or public API version changes.

# 2.7.24 — Documentation audit and Run History baseline repair

- Performs a full shipped-document audit and restores current-state documentation roles.
- Removes duplicated release timelines from README/API/Compatibility/User Guide while preserving full history in CHANGELOG.
- Restores the missing 2.7.17 CHANGELOG entry.
- Reconciles current API/package/version, World Building, Randomizer ownership, Stadium provenance, transaction, and runtime-evidence wording.
- Persists normalized malformed Run History baseline catch/death counters and adds Release Safety regression coverage.
- No challenge-rule, Randomizer algorithm/mapping, provider ownership, Save Schema, or public API version changes.

# 2.7.23 — Public registry context consistency

- Makes `Registry.describe(game)` use its resolved game context for Randomizer delegation/ownership fields.
- Adds a focused context-consistency audit and Release Safety coverage.
- No Randomizer or gameplay semantics changed.

# 2.7.22 — Transaction failure visibility and future-journal preservation

- Preserves actual Rare Candy `TX.execute()` failure reasons.
- Adds Rare Candy failure-reason pass-through regression coverage.
- Makes transaction journal mutators fail closed on future schema versions.
- Extends transaction self-test across advance/checkpoint/targeted-clear/broad-clear future-journal cases.
- No gameplay semantics changed.

# 2.7.21 — Critical World feedback + pass-scoped encounter profiling

- Restores plain critical feedback at World Building T0 for external gift denial, external trade denial, and failed-encounter area consumption.
- Keeps ordinary World Building flavor suppressed at T0.
- Hoists encounter evolution-profile construction to balanced apply/report pass boundaries.
- Preserves zero profile construction for CHAOS.
- Adds Release Safety/semantic tripwires for critical call sites and profile sharing.
- No Randomizer algorithm or mapping changes.

# 2.7.20 — Randomizer diagnostic/presentation consistency

- Accepts `disabled` as a valid Randomizer projection state.
- Shows Randomizer OPEN/BLIND policy for learnset-only Nuzlocke-owned runs.
- Adds Randomizer projection ownership to Release Safety.
- No Randomizer algorithm or mapping changes.

# 2.7.19 — Stadium provenance precedence and release coverage

- Makes authoritative Stadium Pokémon provenance outrank heuristic vanilla gift/trade inference.
- Tracks importer-provider identity separately from Stadium origin and exposes provider ambiguity.
- Auto-detected Stadium imports inherit provider ID only when exactly one importer provider is active.
- Adds Stadium provenance module/API ownership checks to Release Safety.
- No acquisition catalog data or ordinary gameplay semantics changed.

# 2.7.18 — Public acquisition and persistence identity hardening

- Replaces caller-trusted acquisition decision tables with opaque one-shot Nuzlocke-issued decision tokens.
- Requires Gameplay Transaction receipt identity to match both ID and kind.
- Adds receipt-kind collision coverage to the transaction self-test.
- Preserves Run History forward-compatibility errors through public `list()` and `report()` reads.
- No ordinary gameplay semantics changed.

# 2.7.17 — Persistence-integrity repairs

- Centralizes authoritative Run History dedupe queries behind the Run History API.
- Makes league progression and required Run History evidence one recoverable semantic transaction.
- Checks Elite Four progression persistence.
- Makes Route Forgiveness death archival fail closed and reconciles archive-pending dead Pokémon before physical cleanup.
- No rule defaults, Randomizer mappings, Save Schema, or ordinary challenge semantics changed.

# 2.7.16 — Title setup context and World Building status consistency

- Suppresses the live title SETUP/staging hook in Save Editor sessions.
- Reports the Gen 2 title adapter as N/A in Save Editor and on non-Gen2 editions.
- Keeps independent World Building state visible in NUZ STATUS while Nuzlocke is OFF.
- Leaves the dormant legacy title fallback deferred.
- No gameplay semantics changed.

# 2.7.15 — Installer, transaction, and migration integrity

- Reports Battle Clauses as N/A in Save Editor sessions.
- Enforces future Gameplay Transaction versions directly in `TX.execute()`.
- Adds a transaction self-test for future-version direct execution.
- Makes Permanent Rule Lock semantic reconciliation use checked save writes and propagate migration failure.
- Makes dormant Permanent Rule Seal reconciliation require acknowledged durable persistence.
- Surfaces game-ready permanent-lock reconciliation failures in Feature Health.
- No ordinary gameplay semantics changed.

# 2.7.14 — Run History and NZR6 integrity hardening

- Fails closed on future Run History sub-schema versions instead of downgrading them.
- Rebuilds and audits the retained-event dedupe index when stale, missing, or fabricated.
- Preserves Run History `ensure()` failure reasons through `append()`.
- Enforces exact NZR6 payload length and zero-padding validation.
- Leaves NZR4/NZR5 legacy decoder compatibility unchanged.
- No gameplay semantics changed.

# 2.7.13 — World Building independence and Randomizer disabled-state health

- Removes the unintended World Building dependency on the Nuzlocke master switch.
- Routes World Building dialogue rotation through the safe-write boundary with session fallback.
- Treats disabled Encounter/Learnset Randomizers as N/A instead of false failure when no restoration is owed.
- Preserves restoration requirements for an existing Nuzlocke-owned Randomizer snapshot.
- No gameplay-rule defaults or Randomizer algorithms/mappings changed.

# 2.7.12 — Optional UI provider lifecycle hardening

- Clears stale Pokegear capability exports whenever the installation session is retired.
- Protects Pokegear provider calls and reports lifecycle registration health explicitly.
- Makes Pokegear provider health exact-edition aware.
- Strengthens Modern UI registration identity to provider handle + exports table + register function.
- Reports Modern UI lifecycle registration outcomes through Feature Health.
- Classic UI semantics remain unchanged.

# 2.7.11 — Acquisition commit continuity and Stadium provenance authority

- Preserves a public acquisition's authoritative `begin()` result through matching `commit()`.
- Adds explicit `commitDecision(context, decision)` for providers that reconstruct context tables.
- Restricts automatic Stadium origin selection to importer-capable providers and reports multi-importer origin ambiguity.
- Keeps exact running edition authoritative while preserving importer/source edition separately.
- No gameplay-rule defaults, Randomizer mappings, Save Schema, or acquisition catalog entries changed.

# 2.7.10 — Version-numbering governance update

- Adds the project-wide 2.8.x zero-padded patch-numbering convention: `2.8.00`, `2.8.01`, ... `2.8.09`, `2.8.22`, `2.8.22`, and onward.
- Preserves strict immediate-parent lineage requirements.
- No gameplay or runtime semantics changed.

# 2.7.9 — Transaction verification and history reconciliation

- Requires a post-`perform()` reconciliation probe to prove `applied` before Gameplay Transactions advance to `performed`.
- Makes Forgiveness reroll/revival and Gym Leader F. TOKEN transaction writes fail closed on rejected authoritative save writes.
- Moves Forgiveness Run History materialization inside the transaction's reconciliation contract so an interruption after gameplay mutation cannot permanently omit the event.
- Extends the transaction self-test with a false-success handler that must not receive a committed receipt.
- No rule defaults, Randomizer mappings, Save Schema, provider ownership, or ordinary challenge semantics changed.

# 2.7.8 — Installer and feature-health state consistency

- Preserves N/A and PENDING across `safeInstall()` and Feature Health instead of converting skipped installers into ACTIVE features.
- Reports `gen2.install_all` as N/A outside Gen 2 and during save-editor sessions.
- Adds Release Safety cross-surface validation for installer/feature-health state consistency.
- No challenge semantics, rule defaults, Randomizer mappings, Save Schema, or provider ownership changed.

# 2.7.7 — Loader contract, install-health, and F. TOKEN normalization

- Centralizes required split-module reads/compilation with explicit required-module errors while keeping diagnostic rereads fail-soft.
- Prevents `safeInstall()` from recording an edition-probe exception string as the edition.
- Clamps malformed F. TOKEN inventory/mirror values to 0–99 before transaction payloads can observe them.
- No rule defaults, Randomizer mappings, Save Schema, or unrelated gameplay semantics changed.

# 2.7.6 — Runtime/installer observability hardening

- Fail-soft optional presentation module loading.
- Observable Gen 2 install orchestration.
- Aggregated Randomizer apply results and lifecycle health.
- Core Battle Clause hook-session verification.

# 2.7.5 — Compatibility and diagnostics lifecycle hardening

- Rebinds Modern UI registration when the active provider instance changes.
- Makes Pokegear lifecycle installation session-based and independent of optional `api.get()`.
- Fixes NZR6 derived-result consistency reconstruction.
- Makes World Building and DEV source-introspection diagnostics fail soft when `mod:read()` is unavailable.
- Aligns stored-state Run History sequence validation with the repaired journal invariant.

# 2.7.4 — Forgiveness transaction and Run History recovery hardening

- Journals F. TOKEN encounter rerolls and revivals through Gameplay Transactions with durable attempt identities and idempotent recovery.
- Journals Gym Leader F. TOKEN awards so the token and permanent Leader ledger cannot diverge across interruption.
- Repairs Run History `next_seq` from retained event chronology and audits absent/invalid sequence state.
- No rule defaults, Randomizer mappings, Save Schema, or unrelated gameplay semantics changed.

# 2.7.3 — Acquisition fail-closed and Stadium provenance hardening

- Progression-PC acquisition commits now fail closed unless the required permanent PC lock succeeds; missing Pokemon/locker, thrown lock operations, and explicit false returns no longer emit a successful committed acquisition.
- Stadium provenance marking now replaces the complete Stadium provenance tuple so a later v1-compatible mark cannot retain stale origin/provider/edition metadata.
- Stadium compatibility diagnostics now default `presentation_only` from importer capability, preventing importer rows from also being mislabeled presentation-only unless explicitly overridden.
- No rule defaults, Randomizer mappings, Save Schema, or unrelated gameplay behavior changed.

# 2.7.2 — Classic status ownership and installer observability

- Corrected classic NUZ STATUS Randomizer presentation so externally delegated visible Field Item randomization no longer shows dormant Nuzlocke RNG/Field Item Balance/Field Item Repetition state.
- Randomizer Info OPEN/BLIND status now appears for Nuzlocke-owned Field Item-only runs, matching the documented Randomizer Info scope.
- Hardened the dormant `title_setup_compat.lua` fallback installer: installer exceptions and unavailable hooks are now logged instead of disappearing behind bare `pcall`. The module remains dormant under the current main path.
- No Randomizer generation/mapping, gameplay legality, save-schema, provider-ownership, or rule-default semantics changed.

# 2.7.1 — Transaction and Release Safety hardening

- Fixed Gameplay Transaction recovery so a durable committed receipt is authoritative before handler availability is checked.
- Extended the transaction self-test to cover receipt-written/journal-leftover recovery with the historical handler deliberately absent.
- Made save-pause-helper and Lua-unpack full-package audits fail soft when package source introspection is unavailable.
- Expanded bare exported-installer `pcall` lint from a three-file list to every readable shipped Lua module in the authoritative package inventory.
- No gameplay rule/default, Randomizer mapping, Save Schema, or compatibility-ownership changes.

# 2.7.0 — Release promotion

- Promotes exact runtime-confirmed 2.6.98 to release as a strict child of `4b5834bb54ff2cc4564ed62057210185c7619ceea1735ff50f1aa4cb97419cd0`.
- Release notes summarize the full development delta since the previous release build, 2.6.0.
- Carries forward 2.6.97 Release Safety Runtime PASS and the user-confirmed 2.6.98 Setup/NUZ RULES constructor repair.
- No gameplay, rule-default, Randomizer mapping, Save Schema, compatibility-provider, or package-inventory behavior changes from 2.6.98.

# 2.6.98 — Setup / NUZ RULES constructor repair

- Fixed the shared `NuzlockeConfigScreen` constructor used by fresh New Game Setup and in-save NUZ RULES. `rebuildVisibleItems()` iterates `candidate` rows but one Random Starter reroll visibility condition mistakenly dereferenced `item.isStarterRerollControl`, which can resolve nil during initial screen construction.
- The condition now uses `candidate.isStarterRerollControl`; no rule defaults, legality, Randomizer mappings, provider ownership, save schema, or Release Safety semantics changed.
- 2.6.97 runtime evidence is retained: DEV REPORT showed NO ACTIONABLE PROBLEMS / ALL ACTIONABLE CHECKS PASS before the config-screen factory failure was isolated.

# 2.6.97 — Build provenance release-gate repair

- Fixes the runtime-confirmed final Release Safety blocker in 2.6.96: executable provenance still named 2.6.93 while the independent Release Safety expected-parent fields still named 2.6.72.
- Both provenance surfaces now identify exact canonical parent 2.6.96 (`117d7bdcf1219918af6d957025b486a4f4b6085de2ee25f488d7406fd64ba374`).
- Adds an explicit lineage-consistency Release Safety check so executable/audit parent disagreement is named directly.
- No gameplay, Randomizer mapping, rule, save-schema, compatibility-provider, or package-inventory behavior changes.

# 2.6.96 — Documentation header packaging repair

- Fixes the runtime-confirmed Release Safety package-drift failure in 2.6.95: current release notes had been prepended as secondary `##` headings above the role-specific canonical document headers.
- Restores each required first-line current-build header without weakening Release Safety.
- Restores exactly one canonical current-version changelog heading, so `changelog_current_version_unique` resolves to 1 instead of 0.
- No gameplay, Randomizer mapping, save schema, compatibility API, rule catalog, or package inventory behavior changes.

## 2.6.95 — Randomizer rival-sync diagnostic runtime repair

- Fixed `randomizerRivalSyncAudit()` being defined before its local `canonicalRivalClass()` dependency, which made Lua resolve the helper as a nil global when NUZ RULES ran diagnostics.
- Preserved the existing rival-class semantics and Randomizer mappings; only declaration/closure ordering changed.
- This single defect had two visible consequences: `stored_state_validation:randomizer_rival_sync` warning and the enclosing Release Safety failure.
- Runtime retest required before marking the NUZ RULES path PASS.

## 2.6.94 — Lua unpack audit scope hardening

Strict child of exact 2.6.93 (`8aeafd1f10c236f19164a1abf24a7c8d6de96c2f1a34b630a1d1e8af22fb6ddb`). Fixes the confirmed Release Safety coverage defect where `luaUnpackCompatibilityAudit()` scanned only four historical files even though the player package ships 20 Lua modules. The audit now iterates the authoritative `packagePaths` inventory, filters every shipped `.lua` module, and includes self-tests for direct `table.unpack(...)`, bare `unpack(...)`, and the allowed `table.unpack or unpack` compatibility fallback. No gameplay rule, save schema, compatibility provider, randomizer mapping, or package inventory changes. Runtime confirmation remains required.

## 2.6.93 — World Building catalog snapshot repair

Strict child of exact 2.6.92 (`0d33e210ab13f921fd972284c75fd9d577283c51007e5cfa73f636b1b497f128`). Repairs the runtime-blocking MOD MANAGER startup assertion caused by a stale World Building semantic golden snapshot. The live catalog intentionally contains 104 presentation keys; seven Randomizer presentation rows added after the former 97-key golden were legitimate but the protected snapshot had not been refreshed. The corrected golden is **104 keys / 1560 exact-edition-tier surfaces / checksum 926265119**.

The audit is also hardened: the approved key identities are now explicit, key-count and resolved-surface totals derive from that set, and future drift reports the specific missing/unexpected key before the checksum check. No rule defaults, enforcement, Randomizer algorithm/mappings, Save Schema, Compatibility API, Diagnostics API, or package inventory change. The reported 2.6.92 MOD MANAGER failure is Runtime FAIL evidence; 2.6.93 startup/runtime confirmation remains required.

## 2.6.92 — Legacy mod_Compat Beta_26 interoperability

- Publishes an explicit read-only `mod.exports.mod_Compat.Beta_26` alias and `nuzlocke_compat.legacy_compat` metadata for older cooperating mods that identify the historical `mod_Compat Beta_26` wording/namespace.
- Keeps `nuzlocke_compat` API 32 and explicit capability/provider contracts authoritative for modern integrations; the alias does not grant ownership or delegate mechanics merely because another mod is installed.
- Runtime interoperability confirmation remains TEST REQUIRED.
# 2.6.91 — Learnset projection and Rare Candy transaction safety

- Added explicit compatibility recognition for Stadium Overworld Models, Stadium UI Model Viewer, Stadium 2 Overworld Models, and Crystal 251 Stadium bridge surfaces, including exact-edition-preserving `stadium_compat` DEV REPORT diagnostics.
- Upgraded `nuzlocke_acquisition_provenance` to v2 with explicit `markImported()` provider/edition metadata. Stadium model/ROM import remains presentation-only and never auto-labels ordinary Pokémon as Stadium prizes; only actual transfer/import paths may mark created Pokémon.
- Reviewed the Aghanim-3C Crystal-251-compatible Stadium Overworld/UI fork as a presentation/importer compatibility target; combination runtime smoke remains required.

Strict child of exact 2.6.90 (`9871ee43bb39be1cdf18f99c7cc05bb0c6ca0bacfefda273d4b6b5a3ddac2f9c`). Fixes the three defects confirmed during the 2.6.90 focused review and makes no unrelated Randomizer phase changes.

**Learnset ownership projection:** Randomizer learnset snapshot, applied-state capture, and drift comparison now share one projection containing only `level1Moves`, `learnset`, and `levelMoves`. Unrelated provider changes to Pokémon stats, types, or metadata no longer transfer learnset ownership or contaminate the restoration baseline.

**Rare Candy recovery causality:** the gameplay transaction coordinator now supports durable transaction-payload checkpoints. A Rare Candy step checkpoints `native_effect_returned=true` after the native candy effect returns and before bag removal. Recovery may finish inventory-only only when that exact pending transaction contains the checkpoint; a coincidental `level=before+1` / unchanged-candy state without the checkpoint is ambiguous and fails closed instead of guessing.

**Rare Candy attempt identity:** transaction IDs move to the `rare_candy_to_cap:v2:` namespace and use a durable monotonic sequence stored with gameplay-transaction receipts, outside Pokémon records. Each user attempt gets a fresh sequence before journal begin, so an externally rolled-back level cannot recreate an old receipt ID. Sequence gaps after interruption are intentionally harmless; reuse is not. Release Safety now includes a same-Pokémon/same-level identity self-test, while the generic gameplay-transaction self-test covers durable checkpoints and monotonic sequence allocation.

Randomizer algorithm v1, all five named streams, mappings, rule defaults, Save Schema 4, Compatibility API 32, Diagnostics API 1, and the approved 30-file/20-Lua package tree are unchanged. Runtime testing remains required before Runtime PASS.

# 2.6.90 — Randomizer compatibility hardening

Strict child of exact 2.6.89 (`a6a6b25a20588b0640b96f1a03761fc79bee7f60e58c6366406f4c70cacf4ebf`). Keeps the Randomizer feature roadmap paused and performs a narrow coexistence hardening pass instead.

Adds source-confirmed active-feature detection for the external `item_randomizer` mod. Nuzlocke now delegates `Random Field Items`, `Field Item Balance`, and `Field Item Repeats` only when the overlapping visible-pickup feature is actually enabled: `overworld_items` on R/B/Y or `gold_ball_items` on Gold/Silver. Merely installing Item Randomizer does not disable Nuzlocke controls. Item Randomizer's hidden finds, shops, gifts, berries, held-item, and PC-item features do not claim Nuzlocke's visible Field Item control.

Adds the generic `field_item_randomizer_provider` interop capability alongside the existing starter, encounter, and learnset randomizer provider seams. Compatible mods can therefore claim visible Field Item randomization without requiring another hard-coded adapter. The two dependent Field Item policy controls delegate with the same owner so their stored Nuzlocke values remain dormant rather than appearing active underneath an externally owned field-item pass.

Preserves the existing active-run adapters for PokemonRecompRandomizer, Gen 2 Randomizer+, and Kanto Reforged. Adds a read-only four-mechanic randomizer compatibility snapshot and a compact DEV REPORT line showing current starter / encounter / field-item / learnset ownership. Absent or installed-but-inactive randomizers remain N/A/Nuzlocke-owned rather than FAIL or delegated. No Randomizer algorithm, stream, mapping, rule default, Save Schema, Compatibility API, Diagnostics API, package-tree, or gameplay-randomization behavior changes. Runtime coexistence smoke remains recommended.

# 2.6.89 — Gen1/Gen2 Field Item normalization and Randomizer Info

Strict child of exact 2.6.88 (`301195543f161a6876cda8943ee01f74b9f7b36563029addf9cebb9d341c3bb6`). Completes Phase D implementation items 10–11 and establishes a clean pause point for the current randomizer-development sequence.

**Explicit Gen1/Gen2 item-table handling:** the randomizer continues to consume the engine's one merged `game.data.items` registry, but now records the edition-specific representation explicitly. R/B/Y uses the `GEN1_FLAT` model and recognizes flat-record ball capability plus canonical TM/HM identifiers/provider machine metadata; Gold/Silver uses the `GEN2_POCKETS` model and treats BALL, KEY ITEM, and TM/HM pocket semantics as authoritative where present. The live edition profile also records the exact edition, merged registry owner, native visible pickup seam, and hidden-item ownership state. A pure nine-case cross-generation audit covers Gen1 Ball/TM/HM/item and Gen2 Ball/TM/HM/key/item classification without depending on the currently running edition.

**Field Item Randomizer Info:** adds read-only `randomizerFieldItemInfo(game, reveal)` and public `Registry.fieldItemDiagnostics(context)`. It reports Randomizer algorithm/source versions, seed, Field Item Balance, Field Item Repeats, exact edition/table model, visible/hidden ownership, total/hard-safe/protected item counts, semantic-category counts, edition-table-class counts, canonical persisted mapping count, legacy mapping count, canonical source keys, and recorded FIELD_ITEMS fallback diagnostics. OPEN INFO may reveal persisted randomized item choices plus their category/table class. BLIND INFO exposes structural/count/diagnostic metadata but omits randomized item choices and their derived category/table-class data. The dedicated audit verifies repeated OPEN/BLIND reads do not change diagnostic-ledger length or field-item mapping count and that BLIND does not leak item choices.

`Registry.describe()` now reports Random Field Item ownership/info policy, and Randomizer Info remains visible when Field Items are the only active supported information surface. Compatibility API advances **31 → 32** for the additive public Field Item diagnostics contract. Global Randomizer algorithm version 1, all five named RNG streams, Save Schema 4, Diagnostics API 1, the 138-rule catalog, and the 30-file player package remain unchanged.

Phase D implementation is now complete through item 11. Phase D item 12 runtime/progression certification, Phase B item 12 runtime certification, and Phase C item 12 runtime certification remain explicit deferred debt. Further randomizer implementation phases are intentionally paused after this release and should resume from exact 2.6.89 (or its strict future release descendants), not from an older randomizer branch.

# 2.6.88 — Field Item repetition control, deterministic placement, and visible-item ownership

Strict child of exact 2.6.87 (`366a964eed57ac25dc67485fc0d95b5360c5b5298e5c3090d6d6f6a448caa23f`). Continues Phase D items 7–9.

Adds **Field Item Repeats** with `ALLOW` (default), `DIVERSE`, and `UNIQUE`. ALLOW preserves the exact 2.6.87 independent deterministic pickup behavior and mapping namespace. DIVERSE uses a deterministic physical-source placement lane on 3/4 of source/seed combinations while retaining the historical independent lane on the remaining quarter, reducing duplicate pressure without making any hard-safe candidate unreachable. UNIQUE uses a stable source-ordinal permutation over the exact semantic hard-safe pool. Native R/B/Y and Gold/Silver visible item-ball wrappers provide numeric object/source ordinals, so sibling sources using the same pool receive distinct placement indices until the candidate pool wraps/exhausts. Provider-defined nonnumeric source ids fall back deterministically and emit a `DEGRADED_SOURCE_ORDINAL` FIELD_ITEMS diagnostic rather than claiming full uniqueness.

DIVERSE/UNIQUE retain the authored item in the pool so all same-policy sources with the same semantic pool actually share an identical permutation domain; ALLOW keeps the historical “avoid the original when another candidate exists” behavior. New repeat modes use `:repeat1` / `:repeat2` permanent mapping rows and deliberately do not adopt legacy ALLOW rows. Randomizer algorithm v1 and the historical `<semantic source>:<original item>` FIELD_ITEMS RNG identity remain unchanged.

Field Item ownership is now explicit. Native item-ball wrappers tag their seam as `VISIBLE`; `randomFieldItemOwnership` treats visible/item-ball sources as owned and hidden/BG-event sources as not owned. Passing a hidden source to the field-item randomizer returns the authored item unchanged. This formalizes the existing scope boundary: hidden items, gifts, shops, fruit/apricorn trees, and scripted rewards remain outside visible Field Item randomization until a later feature explicitly claims them. Adds a five-case placement/ownership audit covering visible/hidden ownership, native source-ordinal permutation uniqueness, deterministic repeatability, nonnumeric-provider degradation, and repetition-range safety. Runtime confirmation remains deferred.

# 2.6.87 — Semantic Field Item pools and category balancing

Strict child of exact 2.6.86 (`c790432efd165791511200795d4ecc8e2d3f8c5c093cf1ccafbbfd4ea63e5eb5`). Continues Phase D items 4–6. Adds semantic Field Item categories (`BALL`, `HEAL`, `STATUS`, `REPEL`, `ESCAPE`, `BATTLE`, `PP`, `GROWTH`, `EVOLUTION`, `MACHINE`, `GENERAL`) and broad utility tiers. Adds source-level hard category constraints through `allowedCategories` / `fieldItemCategories` and `forbiddenCategories` / `fieldItemForbiddenCategories`; these operate below balancing and can never admit key/HM/progression/provider-protected items. Adds **Field Item Balance** with `CHAOS` (default, exact 2.6.86 behavior), `CATEGORY` (prefer original semantic category), and `BALANCED` (prefer category + utility tier, then category, then utility tier, then hard-safe fallback). Non-CHAOS modes use balance-specific permanent mapping rows while preserving the historical Randomizer-v1 FIELD_ITEMS RNG semantic input. R/B/Y item-ball definitions can pass provider-authored category constraints through the existing collection wrapper; Gold/Silver retain the same physical source identity/context and can consume constraints when supplied by compatible callers/providers. Adds an 11-case semantic/category audit. Runtime confirmation remains deferred.

# 2.6.86 — Field Item candidate engine, permanent source identity, and progression safety

Strict child of exact 2.6.85 (`c99cb88f7fc5b2b7d67fe620227fd0a43169e20c9f7ac5721e1d12e1f008b509`). Begins Phase D with Field Item Randomizer foundation work.

**Shared candidate engine:** visible overworld/item-ball candidates now pass through the same hard-safety candidate-policy engine used by the other randomizer subsystems. Field Items currently request the complete hard-safe pool with no semantic soft stages yet; semantic item-pool preferences remain reserved for the next Phase D work. The hard-safe resolver records FIELD_ITEMS diagnostics for real selection and uses `record=false` for the dedicated audit path.

**Permanent field-item source identity:** persistence is now keyed by `FIELD_ITEM:v1:<edition>:<semantic source slot>` and no longer includes the authored item occupying that pickup. The previous RNG semantic input `<semanticSlot>:<originalItem>` remains unchanged for Randomizer algorithm v1, so Phase D source-ownership migration does not intentionally reshuffle existing seeded field-item results. Existing pre-D seed-scoped rows are adopted into the canonical source row when still legal. R/B/Y and Gold/Silver continue to supply map/object-based semantic slots through their existing acquisition-time wrappers, so native pickup disappearance, bag limits, text, sound, and retry behavior remain engine-owned.

**Progression/key-item classification:** one authoritative field-item classifier now separates ordinary randomizable items from protected KEY_ITEM, PROGRESSION, PROTECTED, and INVALID categories. Hard protection covers explicit key-item flags/pockets, HMs, badge/placeholder identifiers, missing/placeholder definitions, provider opt-out/preservation policy, and explicit progression/story/quest/required metadata. Protected authored pickups are returned unchanged and protected candidates can never enter the replacement pool. This is fail-closed: later semantic pool work may narrow ordinary choices but cannot relax progression protection.

Adds a seven-case Field Item foundation diagnostic covering key/HM/progression/ordinary classification, permanent source identity, live hard-safe candidate-pool cleanliness, and source-identity versioning. Global Randomizer algorithm version 1, all five named RNG streams, Save Schema 4, Compatibility API 31, Diagnostics API 1, the 136-rule catalog, and the 30-file player package remain unchanged. Runtime confirmation is deferred.

# 2.6.85 — Area Split identity hardening and encounter Randomizer Info

Strict child of exact 2.6.84 (`7c793d05aa515a09c02efba5f7b3ba3bf5e7009411581d4b686471534dba7270`). Completes Phase C implementation items 10–11.

**Area Splits × Random Encounters:** Randomized encounter-table persistence remains keyed to immutable physical encounter-source identity and the historical Randomizer v1 RNG semantic slot. Route 2/10/20, Mt. Moon, Safari Zone, Gold Time Split, and Gold Headbutt Split now explicitly reproject tracker/logical encounter ownership without calling `Randomizer.applyEncounters`, so changing a catch-area split cannot itself reroll or remap the underlying randomized wild table. Gold Time/Headbutt split changes now participate in the same live encounter-area reprojection/invalidation path as the Kanto split controls. The public split-mode report now includes Gold time/headbutt state. A dedicated split contract audit verifies that split state does not alter canonical randomizer source/RNG identity.

**Encounter Randomizer Info:** Adds read-only `randomizerEncounterInfo` diagnostics and public `Registry.encounterDiagnostics(context)`. The surface reports Randomizer algorithm version, encounter policy version, seed, Encounter Balance, Encounter Repeats, Diversity Strength, species-generation mode, source/protected/mapping counts, active area-split state, canonical source identity, legacy RNG slot, normalized encounter class/time bucket/group identity, candidate counts, preference/relaxation state, protected-source reasons, and recorded ENCOUNTERS fallback diagnostics. OPEN INFO may reveal the live randomized species for each source. BLIND INFO keeps species absent while retaining safe structural/diagnostic metadata. Candidate resolution explicitly uses `record=false`, and the diagnostic audit verifies no fallback-ledger or mapping-count mutation from repeated reads.

The existing `Registry.encounterInformation(context)` now carries the same spoiler-aware diagnostics alongside its reveal decision; under BLIND it no longer returns the whole randomized registry merely because one encounter is marked discovered, and Compatibility API advances **30 → 31** for the additive public encounter-diagnostics surface. A live-control repair also adds `random_encounter_repetition` and `random_encounter_diversity_strength` to the encounter randomizer reapply list; before this build those settings persisted but were omitted from that live refresh list. Global Randomizer algorithm version 1, all five named streams, encounter source/RNG identities, Save Schema 4, and Diagnostics API 1 remain unchanged. Phase C implementation is now complete through item 11; item 12 exact-edition runtime/regression certification remains explicitly deferred.

# 2.6.84 — Encounter diversity strength, Gen 2 table classes, and protected-source isolation

Strict child of exact 2.6.83 (`62e7ca3698af965e2209b697052a470a6b17d6f8296d0e4fb13e00d5b325fcb6`). Continues Phase C with **Diversity Strength** for `Encounter Repeats = DIVERSE`: `LIGHT` uses a 0.70-per-use multiplier, `STANDARD` (default) preserves 2.6.83's 0.45 factor, and `STRONG` uses 0.25. All three remain soft weighting only; every hard-safe candidate remains reachable. The STANDARD setting deliberately retains the existing 2.6.83 DIVERSE mapping namespace, while LIGHT/STRONG append only a diversity-strength suffix inside the encounter policy namespace.

Encounter sources now receive an explicit normalized table class and time bucket without changing canonical persistence identity or the historical Randomizer v1 RNG slot. The classifier distinguishes land/grass, cave, Surf/water, fishing/rod, Headbutt/tree, Bug Contest, roamer, and provider-defined/other methods; Gen 2 morning/day/night semantics normalize to `MORN`, `DAY`, and `NITE`. Repetition grouping now uses map + normalized class + time bucket + table id + structural parent path, keeping grass/cave, water, fishing, tree, contest, and time-of-day pools independent even when provider metadata uses different raw method spellings.

Wild-table randomization now fails closed away from explicit protected content before provider composition or candidate selection. Records marked non-randomizable, static, fixed, story, progression, quest, gift, trainer, roamer/roaming, deny/provider/preserve/story/external/owned policy, or a corresponding protected structural path are left untouched. The public encounter provider context receives the normalized class/time bucket only after this local protection gate passes. Adds a 17+ case class/protection/diversity audit covering land, morning land, Surf, fishing, Headbutt, Bug Contest, roamer classification; explicit protected flags/kinds/policies; and monotonic diversity-strength factors. Global Randomizer algorithm version 1, encounter source/RNG identity, Save Schema 4, Compatibility API 30, and Diagnostics API 1 remain unchanged. Runtime confirmation remains deferred.

# 2.6.83 — Encounter repetition control and progression-aware balancing

Strict child of exact 2.6.82 (`39de659ca36a4829e4122baaa751893473d7fecb59e4bb77f071c9bb68a7e7d2`). Continues Phase C with a new **Encounter Repeats** control: `ALLOW` (default) preserves independent slot rolls, `DIVERSE` uses deterministic soft diversity weighting within each canonical encounter source group, and `UNIQUE` uses without-replacement selection within that group until the legal candidate pool is exhausted. UNIQUE relaxation is explicit and recorded in randomizer constraint diagnostics; DIVERSE never makes a legal species unreachable. Group identity uses map/method/table plus the structural parent path, so repetition control is local to the relevant wild table/time/method group rather than global across the run.

Hardens all four existing Encounter Balance modes. CHAOS remains the full hard-safe pool. SIM BST now tries the historical ~15% band first, then deterministic ~25% and ~40% bands before relaxing to the hard-safe pool. EVO now prefers the same broad stage plus similar evolution-family depth/remaining evolution count, then stage alone, then progression-adjusted strength. BALANCED first combines progression shape with similar BST, then relaxes through stage/progression matching and wider BST bands. The progression score uses the slot's native level, current BST, and a bounded contribution from the strongest reachable evolutionary ceiling; no level/rate/table structure is changed.

The strengthened balance modes and active DIVERSE/UNIQUE mappings use an encounter-only policy namespace `ep2`; established 2.6.82 balance-mode mappings are adopted forward when repetition remains ALLOW and the stored result is still legal under the new candidate set. `CHAOS + ALLOW` deliberately keeps the exact 2.6.82 mapping scope/hash path. Global Randomizer algorithm version 1 and the historical encounter RNG semantic slot remain unchanged. Adds a policy audit covering without-replacement filtering/exhaustion, diversity weighting, group identity, policy versioning, and live evolution-profile structure. Runtime confirmation remains deferred.

# 2.6.82 — Encounter candidate engine, source identity, and order-independent generation

Strict child of exact 2.6.81 (`de2702495f148be2f912bc99ed6828e51da81b79dfd78479cd703a681b91e035`). Begins Phase C by migrating Random Encounters onto the shared Phase A candidate-policy foundation. Encounter species now pass through one hard-safety candidate layer for reserved/missing species, glitch exclusion, selected Species Pool generation, runtime construction safety, and acquisition restrictions. Existing encounter balance modes remain behaviorally equivalent but are expressed as ordered soft preferences through the shared resolver: CHAOS uses the full hard-safe pool; SIM BST prefers the historical ±15%/minimum-25 BST band; EVO prefers the original evolution-shape match; BALANCED prefers BST+stage, then stage, then BST, then the hard-safe pool. Hard safety can never be relaxed.

Formal encounter source identity is now separate from RNG identity. Every randomized encounter leaf receives a canonical identity containing available map/source/method/table/slot metadata plus its structural path as a collision-proof fallback. Persistence uses that canonical source identity, while RNG hashing deliberately continues to use the exact historical 2.6.81 structural `.species` slot. Existing seed-scoped rows are adopted into the canonical storage namespace when present, so the identity migration does not intentionally reshuffle established or fresh Randomizer algorithm v1 encounter results.

Encounter application now materializes the complete encounter-leaf work plan, sorts it by canonical source identity, and only then performs replacements. Results therefore do not depend on provider table insertion order, map visit order, or which encounter table a consumer inspects first. Adds a read-only encounter-plan surface and a three-case source-identity/order audit covering metadata-order stability, synthetic table insertion-order invariance, and duplicate/empty canonical identity detection against the live registry. Global Randomizer algorithm version 1, all five named RNG streams, rule catalog/defaults, Save Schema 4, Compatibility API 30, and Diagnostics API 1 remain unchanged. Runtime confirmation is deferred.

# 2.6.81 — Starter rerolls, Randomizer Info, and Yellow starter progression hardening

Strict child of exact 2.6.80 (`6a04a3ebfcd213ae86a3921f602398b0d804b16efcf660e7190241bfbb0250a5`). Adds **Starter Rerolls** (`OFF` default / `ON`) plus a separate **Reroll Starter** action that exists only before starter acceptance. Rerolls retain the run seed and advance only a starter reroll index; index 0 preserves the existing initial-slate namespace, while reroll indices use the starter-only v3 namespace and never consume encounter, field-item, or learnset streams. When a prior positional slate exists, generation rejects an identical full reroll whenever another legal distinct slate can be constructed. Committing the starter permanently locks rerolls for that save. Adds a read-only `randomizerStarterInfo` diagnostic surface exposing algorithm/slate versions, seed, Starter Style, Balance, Trio Typing, candidate counts, reroll state, and STARTER fallback diagnostics; actual persisted slate species are exposed only under OPEN INFO. The public Registry gains `starterInformationPolicy` / `starterInformation`, so Compatibility API advances from 29 to 30. BLIND INFO hides the generated starter slate while retaining non-spoiler diagnostic metadata. Completes a static Yellow starter-dependency audit: the existing post-lab follower/cry/Pikachu-text suppression remains, opening-starter provenance/nickname paths already use the committed randomized starter, and the confirmed Cerulean Bulbasaur gift dependency is hardened by setting Yellow's otherwise-orphaned starter-Pikachu happiness field to the native 147 gift threshold only when the accepted randomized opening starter is not Pikachu. Normal Pikachu runs are unchanged. Adds DEV diagnostics for read-only starter info and Yellow dependency contracts. Global Randomizer algorithm version 1 remains unchanged.

# 2.6.80 — Starter Balance and Trio Typing

Strict child of exact 2.6.79 (`f2202fdd68cd4c891e162de8e7cfae86541532ac7dde50a6010469ff216ecf47`). Adds two Random Starter child settings. **Starter Balance** defaults to INDEPENDENT and adds BALANCED, which prefers three-choice starter slates with comparable current BST plus a partial evolutionary-ceiling contribution; deterministic tolerance widens through 55/85/125/180 score points before the preference relaxes. **Trio Typing** defaults OFF and adds AUTO, which prefers a three-way offensive type cycle using every candidate's full dual typing and the correct Gen 1/Gen 2 effectiveness differences; unknown/provider types simply do not manufacture an advantage. When both are active, the generator first seeks a balanced type-cycle slate, then preserves BALANCED while relaxing AUTO typing, then falls back to the ordinary legal distinct slate. Both are soft preferences only: hard starter legality, Starter Style safety, active challenge restrictions, and the complete distinct-assignment guarantee remain authoritative. Preference search is deterministically bounded to the first 80 ranked legal candidates per native slot so provider-expanded registries cannot create cubic startup work; the existing full candidate pools remain available to the exhaustive distinctness fallback. Red/Blue and Gold/Silver consume both settings; Yellow's two-position Pikachu/Eevee transaction intentionally stays on the established starter path. Default INDEPENDENT/OFF runs remain on the exact 2.6.79 starter-slate v2 namespace, preserving established/default seeded starter results. Only active new preferences use starter-slate v3. Randomizer algorithm version 1 and all unrelated RNG namespaces remain unchanged. Rival starter-family synchronization now consumes the already-persisted positional slate before consulting live setup values, so later edits to Starter Style/Balance/Trio Typing cannot rewrite an established rival family. Adds preference-state diagnostics and exact UI/status/world-building labels for both settings.

# 2.6.79 — Random Starter original lineage, positional identity, and rival synchronization

Strict child of exact 2.6.78 (`1c094b3c066ad0d3da7570bee5f82d5a33a7c659cfbb6e7a3bcf00844dc796ed`). Hardens Starter Style classification around one captured original merged evolution lineage: BASE/3-STAGE classification and rival-family depth projection no longer depend on any later evolution projection, self-links/missing targets are ignored, split children are ordered deterministically, and malformed/cyclic ancestry is bounded instead of recursing indefinitely. Persists the exact starter transaction identity separately from the choice cache with edition tag, slate version, seed, style, canonical slot order, and slot-to-species mapping; reopening previews or reloading the save therefore resolves the same positional slate. Yellow now persists a two-position native transaction (`PIKACHU` player slot and `EEVEE` rival slot), while Red/Blue and Gold/Silver retain their three physical Oak/Elm positions. Rival starter-family synchronization is composed through `trainer.party`: canonical rival classes map only their native starter-family members to the corresponding stored randomized slate position, preserving the original member's evolution depth when the randomized family supports it and leaving levels, moves, party size, non-starter rival species, and non-rival trainers untouched. Rival species are never independently rerolled. Adds lineage, position-state, and rival-sync diagnostics. Randomizer algorithm version 1 and unrelated RNG namespaces remain unchanged.

# 2.6.78 — Random Starter candidate engine and atomic distinct slates

Strict child of exact 2.6.77 (`a80b91b4844121dcc641f2f9dc5a478703e65b85c76437b684591e441707e1b3`). Begins Phase B by migrating Random Starter candidate construction onto the shared Phase A policy engine: existing runtime/species-pool, glitch, Type Locke, acquisition, and construction checks are hard-safety predicates that can never be relaxed, while 3-STAGE, BASE, and SIM BST are soft Starter Style preferences that fall back only to the hard-safe pool when empty. Canonical starter transactions now generate and persist one atomic slate on first access: Red/Blue resolve the three Oak choices together, Gold/Silver resolve the three Elm choices together, and Yellow uses the same transaction path for its player starter without changing rival behavior yet. Fresh multi-choice slates use a deterministic complete matching search, guaranteeing distinct starter species whenever a legal distinct assignment exists; duplicate fallback is permitted only after the full matching search proves uniqueness impossible and is recorded through the randomizer constraint diagnostics. Existing valid saved starter choices from the same seed and Starter Style namespace are adopted before filling missing slate positions, protecting established runs from unnecessary regeneration. The shared randomizer algorithm remains version 1; the new starter-slate namespace is independently versioned as v2 so encounter, field-item, and learnset seed namespaces remain unchanged.

# 2.6.77 — Randomizer uniqueness, projection ownership, and fallback diagnostics

Strict child of exact 2.6.76 (`2b7f786dc996cb9cefd2761bd69f5f2fdcad2a8af45fd795b1ee3781b13a5663`). Adds deterministic without-replacement candidate primitives that exclude already-used legal candidates when possible and degrade back to the full legal pool only when uniqueness is mathematically exhausted. Formalizes the two shipped temporary live-registry projections—encounters and learnsets—under explicit owner/domain/rule contracts with tracked states for snapshot, apply, restore, provider adoption, and external delegation while preserving the existing same-table provider-drift behavior. Adds a bounded 24-row per-run randomizer constraint/fallback diagnostic ledger plus a governed resolver that records requested policy, candidate counts, relaxation stage, fallback status, and reason without consuming RNG. Candidate-policy diagnostics now cover eight cases, and new projection/constraint audits verify the ownership and diagnostic contracts. Existing gameplay randomizers do not yet migrate onto the new uniqueness/resolver helpers, so algorithm version 1, existing stream identifiers/hash inputs, established seeded outputs, and randomized gameplay scope remain unchanged.

# 2.6.76 — Randomizer candidate-policy foundation

Strict child of exact 2.6.75 (`15a0f6b8b486e2a9f89ceb561eb6071f88c8728d242894643636e51d890dbafc`). Adds shared pure candidate-policy primitives for semantic hard-safety filtering, ordered progressive relaxation of soft preferences, and deterministic soft diversity weighting. Hard-safety predicates can never be relaxed; an exhausted preference ladder falls back only to the hard-safe pool. Diversity weighting keeps every legal candidate reachable instead of turning repetition control into a hidden ban. A five-case diagnostic audit verifies hard-safety retention, progressive relaxation, safe-pool fallback, positive diversity weights, and deterministic weighted selection. Existing randomizer features do not consume the new policy engine yet, so algorithm version 1, existing stream identifiers, existing seeded outputs, rule defaults, and randomized gameplay scope remain unchanged.

# 2.6.75 — Randomizer stream isolation and persistent source mappings

Strict child of exact 2.6.74 (`9f2e2dbf56d5552677f9c618e553d8aa8af34515a8ded7196337d58703cf34df`). Completes authoritative ownership of the five shipped named randomizer streams and adds a pure 45-case isolation audit proving deterministic outputs do not change when other streams are interleaved. Centralizes persistent source-map ownership for starters, starter slates, encounters, field items, and learnsets. Random Field Items now persist the first generated result per seed/source identity while preserving the exact historical 2.6.74 seeded choice on first materialization, so later candidate-pool growth cannot silently reshuffle an established pickup.

# 2.6.74 — Randomizer run snapshot and stream registry foundation

Strict child of exact 2.6.73 (`fc9fc32934b7e7125db05c9a8fc4b60eda84763298de21f2f5522382d16b8980`). Adds an immutable per-run randomizer configuration snapshot containing algorithm version, resolved run seed, exact edition, and the ten shipped randomizer settings. Establishes one authoritative registry for the five existing named RNG streams—STARTER, STARTER_SLATE, ENCOUNTERS, FIELD_ITEMS, and LEARNSETS—without renaming any stream or bumping algorithm version 1, preserving existing seeded outputs. Adds stream-registry and run-snapshot diagnostics while leaving existing runtime randomizer setting reads unchanged for compatibility.

# 2.6.73 — Rule-section taxonomy and Release Safety hardening

Strict child of exact 2.6.72 (`02f9f53f0f860fd6d50c119422ccdaf5746535d58dfb20faa37fa629741e4414`). Reorganizes the 131-rule catalog into 21 clearer player-facing sections without changing rule keys, defaults, save schema, enforcement semantics, provider ownership, presets, or package inventory. CORE is followed by CLAUSES, HARDCORE, GAME DIFFICULTY, BATTLE MECHANICS, RUN / PARTY, and LEVELS; acquisition restrictions move to CATCH RULES; OHKO/Flinch/Trap plus stat-stage restrictions move to BATTLE CLAUSES; healing/services and commerce combine under SERVICES & ECONOMY; Stat EXP/DV controls move to POKEMON STATS; QOL is split from QOL SETUP ONLY; Dev Mode remains in UI. Save Rules and encounter recovery/assignment utilities remain non-catalog controls and are not moved into rule sections.

Release Safety's `save_pause_helper_scope` audit now derives coverage from the authoritative shipped package inventory and scans every `.lua` file, rather than only `main.lua`. A detector self-test proves the historical bare cross-module `saveWritePauseReason()` form is rejected while the required `mod.exports.__beta26.saveWritePauseReason()` form is accepted. No current bare call existed in the 2.6.72 parent; this closes the false-negative regression-guard gap.

# 2.6.72 — Runtime UI readability and navigation polish

Strict child of exact 2.6.71. Removes DEV page underlines in favor of centered tracked-bold titles, restores a true upward scroll arrow, reflows DEV TOOLS LAST/SNAP status, and gives DEV REPORT HOOKS/RULES compact two-column wrapping. NUZ STATUS drops the redundant edition suffix, centers/bolds RUN STATUS and rule-section headers, groups active rules by the same catalog sections used by Setup/NUZ RULES, adds a SETUP ONLY section, clarifies current-area/last-event labels, and moves RUN HISTORY help to the footer. RUN HISTORY receives the same emphasized title treatment. NUZ RULES removes the redundant R/B/Y edition/revision subline and moves its blinking lower-help arrow to a reserved bottom-right gutter. Nuz Info compacts move P/A/PP spacing, explains D/DV and E/Stat EXP on the stat page, and keeps scroll arrows out of move data. MOD COMPAT removes build/engine identity from the ordinary ownership screen and uses the recovered space for an additional row. Also repairs inherited executable release identity so main.lua/manifest/provenance agree on 2.6.72.

# 2.6.71 — Dev storage contract and diagnostic UX repair

Strict child of exact 2.6.70. Repairs DEV snapshot persistence by calling Gen1Recomp `mod.storage` methods with their required receiver and live game arguments, including context/read/write/list/delete/history operations. DEV TOOLS is reorganized into clearer primary/diagnostic/advanced actions, renames RELOAD SAVED to LOAD SNAPSHOT and LOG SNAP to WRITE LOG SNAP, adds contextual action help plus separate LAST/SNAP status, and gives DEV TOOLS, DEV REPORT, STORAGE INFO, and KNOWN ISSUES a shared emphasized single-pass title treatment. Classic R/B/Y report pages now use a real upward indicator instead of the right-facing menu cursor glyph. STORAGE INFO uses state-aware WRITE/READBACK/VERIFIED output, and lifecycle-pending hooks are informational in KNOWN ISSUES. Existing 2.6.70 NUZ STATUS Run History and ACTIVE RULES repairs are preserved.

# 2.6.70 — Runtime presentation and Dev Tools follow-up repair

Strict child of exact 2.6.69. Fixes the remaining Release Safety changelog-heading UTF-8 comparison, shortens DEV TOOLS run status to fit the native viewport, de-duplicates Release Safety problem counting, centers STORAGE INFO and KNOWN ISSUES, gives STORAGE INFO live engine/game fallbacks when optional snapshot storage is unavailable, and makes KNOWN ISSUES derive from the live report plus only runtime-only manual items. NUZ STATUS now opens RUN HISTORY correctly through ListMenu's `onChoose` contract, cleans up `A: OPEN` spacing, and removes the fake-bold ACTIVE RULES overdraw. The encounter-spend badge is suppressed on battle-owned screens so AREA:SPENT/AREA:COUNT no longer overlays battle sprites/UI.

# 2.6.69 — DEV TOOLS runtime UX and diagnostic-state repair

Strict child of exact 2.6.68. DEV TOOLS now labels its first action `RUN TESTS`, reports diagnostic execution separately from optional snapshot persistence, and distinguishes installer `N/A`/`PENDING` from genuine failures. Optional QOL compatibility guards no longer inflate Install Health when their external mods are absent. Release Safety parent expectations now match exact 2.6.68 provenance, and package-drift header checks accept the canonical descriptive changelog heading. No gameplay-rule behavior changes.

# 2.6.68 — Dev diagnostics follow-up repair

- Fixes the remaining CHANGELOG Release Safety false positive by accepting the canonical current-build heading with an em-dash descriptive suffix.
- Treats the Gold/Silver-only `pc.whiteout_recovery` installer as a clean not-applicable no-op on Red/Blue/Yellow instead of recording an installer failure.
- Improves DEV REPORT > PROBLEMS readability with short labels, separated problem/detail rows, deterministic installer ordering, and compact human-readable failure text.
- Preserves the 2.6.67 dashboard, storage diagnostic repair, preset-diff diagnostic repair, randomizer integrity audit, and complete RAW report.
- Strict child of exact 2.6.67 package SHA-256 `8b9e4b9e55b0e465170a009047808c5566c3b2d2724fbe277c7803e901850a04`.

# 2.6.66 — Save migration helper-scope recovery

Recovery child of exact 2.6.57. Yellow 2.6.65 runtime diagnostics identified the migration safe-stop cause: semantic/permanent rule-lock reconciliation called bare global `saveWritePauseReason`, which is nil because the helper is exported as `mod.exports.__beta26.saveWritePauseReason`. All three remaining bare runtime call sites were corrected to the qualified export, including Randomizer Runtime, Classic UI, and Late Runtime dependency injection. Release Safety now rejects reintroduction of a bare save-pause helper call. The safe-stop itself was unchanged during build development.

# 2.6.65 — Lua unpack runtime compatibility recovery

Recovery child of exact 2.6.57. 2.6.64 is quarantined after Yellow runtime reached `main.lua:186` and confirmed that this engine exposes legacy global `unpack` but not `table.unpack`. The full shipped Lua surface was audited. All executable direct `table.unpack(...)` and bare `unpack(...)` calls in main.lua, late_runtime.lua, classic_ui.lua, and battle_clauses.lua now route through a module-local `unpackValues = table.unpack or unpack` resolver with an explicit capability assertion. Release Safety now rejects reintroduction of direct/bare unpack calls in those modules. The previously confirmed pre-init Dev harness repair is retained by reviewed port.

# 2.6.64 — Runtime initialization recovery

Recovery child of exact 2.6.57 (`7dcfcefb53713c8d27369c013e2518cacf49797a8af64b1427bafa6901660eb5`). Builds 2.6.58–2.6.63 are quarantined after Yellow exposed an initialization-time nil-index failure. Comparison traced the defect to `wrapperInterpositionHarness` being assigned through `mod.exports.__beta26.Dev` thousands of lines before the Dev table is initialized. 2.6.64 ports the reviewed 2.6.58–2.6.63 deltas onto 2.6.57 and moves only that diagnostic harness registration to immediately after Dev initialization. No harness behavior or gameplay policy is changed.

# 2.6.63 — World Building dialogue rotation

Strict child of 2.6.62. Raises the World Building catalogue quality floor to at least three preset choices for every rule at T1, T2, Kanto T3, and Johto T3; exact-edition rotation state is independent for Red, Blue, Yellow, Gold, and Silver. Dialogue cycles persist per run and never repeat the same option back-to-back without consuming gameplay RNG. T3 appends read-only run context. The Pallet home TV now has three-choice T1/T2 rotations, retains compatible vanilla TV dialogue in those rotations, and T3 retains vanilla as an eligible report alongside live run reports and Pallet/Bryan broadcasts.

# 2.6.62 — World Building hardening and dialogue variety

Strict child of 2.6.61. Makes mandatory rule explanations an explicit presentation primitive separate from optional World Building flavor, adds a World Building delivery-coverage matrix and Release Safety audit for high-risk enforcement surfaces, and permits deterministic T3 regional dialogue pools without consuming gameplay RNG. Adds initial T3 variety for Mom Heal, Center Heal, Gym Lock-In, and Dungeon Lock-In. No legality, save-schema, compatibility-API, or rule-default change.

# 2.6.61 — Saved Setup Presets

Strict child of 2.6.60. Adds three persistent Saved Setup Preset slots per existing Setup profile scope using Gen1Recomp 0.2.19's public installation-scoped `mod.cache` API. Setup can select a slot, save the current configuration-only profile, and load it through the existing bulk-change preview/confirmation surface. Presets never serialize catches, deaths, badges, party state, Run History, or mutable gameplay balances.

# 2.6.60 — Installer Health rollout completion

Strict child of 2.6.59. Routes all remaining exported fail-soft `installX` lifecycle calls through `attemptInstall` using stable subsystem IDs, preserving every existing lifecycle boundary, retry point, ordering rule, and installer body. Adds a Release Safety audit that fails if a future exported installer is invoked through a bare `pcall`. No gameplay-policy, save-schema, compatibility-API, or package-tree change.

# 2.6.59 — Rare Candy → current level cap

Strict child of 2.6.58. Adds a QoL batch action for field Rare Candy use across R/B/Y and Gold/Silver. The action consumes the existing live level-cap resolver, rechecks it before every level, uses real candies only, preserves intermediate move/evolution flows, and adopts GameplayTransactions v1 for exactly-once level+inventory steps. No new rule toggle, save-schema change, compatibility-API change, or package-tree change. Runtime verification required.

# 2.6.58 — wrapper interposition + Randomizer same-table provider hardening

Strict child of 2.6.57. Adds an actual isolated direct-wrapper interposition harness and changes owner-aware wrapper re-entry so a later external top-level wrapper is never clobbered. Resolves the Randomizer same-table late-provider mutation investigation by detecting content drift from Nuzlocke's last applied registry image and adopting the live provider-mutated table as the new authoritative snapshot before any restore/reapply. No save-schema/API/tree change. Static/Harness/Integrity PASS; runtime/provider-combination testing remains required.

# 2.6.57

**Transaction interruption / exactly-once recovery + Hook/Feature Health foundation.** Strict child of exact reconstructed 2.6.56 (parent player ZIP SHA-256 `67746084fd34fbf7cb000e6f272e9a78175020088ff11bf7ac97259db005a5bf`).

- **Gameplay transaction coordinator v1:** adds one durable `intent -> perform -> commit -> clear` journal for interruption-sensitive gameplay mutations, plus bounded committed receipts so a stable transaction id cannot replay after success.
- **Reconciliation-first recovery:** every registered mutation kind must provide a probe that can distinguish `applied`, `not_applied`, and `unknown`. Recovery replays only when `not_applied`; ambiguous state fails closed rather than guessing.
- **Interruption windows covered:** the coordinator recovers the dangerous case where the side effect completed but the journal still says `intent`, and the case where the durable receipt was written but journal cleanup was interrupted.
- **Same-tick clobber protection:** only one pending gameplay transaction may own the durable journal at a time; a different transaction receives `busy` instead of overwriting pending intent.
- **Generic exact-value mutation:** `save.set_exact` / `setExact()` provides a reusable recovery-safe primitive for future per-feature rollout without serializing Lua closures into saves.
- **Release Safety:** a pure in-memory interruption harness verifies exactly-once recovery, replay suppression, receipt-finalization cleanup, and busy-journal protection without touching the live save.
- **SafeInstall v2:** the previous Gen 2 `attemptInstall` recorder now routes through a central fail-soft installer service. Explicit installer `false` results are diagnostic failures instead of being misreported as successful `pcall`s.
- **Hook Registry v1:** records stable hook ids with owner, previous/wrapper functions where available, priority, mode, feature owner, source, and live/interposed status. Existing owner-aware direct wrappers and Dev Hook Health feed this registry rather than creating a second wrapper system.
- **Feature Health v1:** stable `ACTIVE` / `DEGRADED` / `UNAVAILABLE` states summarize installer and hook health. CHAINED/interposed wrappers are diagnostic degradation, not automatically a release-fatal compatibility error.
- **Diagnostics:** Dev snapshots/report exports now include Hook Registry, Feature Health, and gameplay transaction status. Install failures use standardized `[Nuzlocke:Subsystem]` diagnostic prefixes.
- **Save contract:** Save Schema remains **4**. The two new optional bookkeeping keys are described by the existing Save Schema descriptor; they do not change rule defaults or gameplay configuration semantics.
- No Compatibility API, Diagnostics API, Mod API, engine range, supported-edition list, or player-file-count change.
- Evidence: **STATIC/HARNESS PASS — RUNTIME REQUIRED**. Per-feature adoption of the transaction coordinator must be rolled out only at transaction boundaries whose reconciliation semantics are proven; 2.6.57 does not falsely claim that every historical gameplay mutation is already atomic.

# 2.6.56

2.6.56 is a strict compatibility-certification child of exact 2.6.55 (parent player ZIP SHA-256 `e9f4c899b6f8d85c42909822475db06a646575621b13197c144fc729182c8cb7`). It reviews the complete 17-commit Gen1Recomp v0.2.18→v0.2.19 delta and advances `recompCompatAudited` to **0.2.19** without changing Nuzlocke Save Schema 4, Compatibility API 29, Diagnostics API 1, Mod API 2, engine range `>=0.1.86 <2.0.0`, supported editions, rule defaults, or the 30-file player inventory.

Material upstream changes include Gen 2 battle/EXP, Bill's PC BoxMenu, Pack/Item-PC UI, SaveData resilience, Gen2Compat/Loader facades, overworld/transitions, Bag/Stats, and Gold/Silver import data. The protected Bill's PC methods `doWithdraw`, `checkSpaceInDestination`, and `askRelease` retain compatible semantic roles, so Party Size and progression-catch PC wrappers remain unchanged. Gen 2 `battle.exp_award` now honors an explicit announce argument; Nuzlocke records the capability for future EXP-policy work but does not adopt that seam in this release.

Static/source compatibility certification does not replace runtime evidence. Exact 0.2.19 smoke testing remains required across supported editions, with focused Gold/Silver PC withdraw/MOVE/release plus Party Size/progression-lock checks.

# 2.6.55

**Semantic enforcement coverage + behavior regression foundation.** Strict child of exact 2.6.54.

- **Coverage matrix:** high-risk rule promises now map semantic operations to rule keys, edition/capability scope, enforcement seam, provider surface and evidence class.
- **Behavior-level regression suite:** Release Safety now executes non-mutating assertions over acquisition-kind semantics, classifier precedence, randomizer policy aliases/canonical values and required coverage rows. These are release-gate failures, not informational diagnostics.
- **Process:** extends the proven bug-specific-audit pattern into a reusable semantic contract so a known hook existing is no longer treated as proof that every equivalent operation reaches it.
- No Save Schema, Compatibility API, Diagnostics API, Mod API, engine range, supported-edition list, rule default, or player-file-count change.

# 2.6.54

**Post-review correctness, diagnostics, and documentation consolidation.** Strict child of exact 2.6.53.

- **Symptom — provider randomizer ownership could be ignored depending on entry point:** encounter registration, inline encounter context, encounter policy setters and learnset policy setters/readers did not share one alias/canonical vocabulary. In particular a canonical learnset `provider`/`deny` policy could fall through to randomization. **Repair:** one `normalizeRandomizerPolicy` now owns `allow`/`deny`/`provider` plus compatibility aliases (`preserve`/`story`, `external`/`owned`, booleans) across all equivalent entry points.
- **Symptom — Release Safety could prefix-match or mis-handle future nonnumeric version text:** current-version checks partially escaped Lua patterns and treated every public document as if it were a version-history file. **Repair:** source/manifest versions are compared as exact values; public documents use role-specific exact headers; CHANGELOG uniqueness counts only the exact current heading.
- **Symptom — Gen 2 installers could fail inside `G2.installAll()` with no durable session evidence:** bare `pcall` results were discarded. **Repair:** Gen 2 installer attempts now use a shared install-health registry surfaced by Dev self-test.
- **Engineering hardening — storage fallbacks:** R/B/Y and Gold/Silver box count/capacity fallbacks now come from one generation-aware `engineBoxConstants` source consumed by PC Catches and Forgiveness storage paths.
- **Documentation architecture:** README and USER_GUIDE now describe current truth; RELEASE_NOTES is current-release-only; CHANGELOG is the canonical release history; API/COMPATIBILITY/FEATURE_CONFIDENCE are current-contract documents. FEATURE_CONFIDENCE now separates player/runtime confidence from provider/API interoperability confidence.
- No Save Schema, Compatibility API, Diagnostics API, Mod API, engine range, supported-edition list, rule default, or player-file-count change.

# 2.6.53

2.6.53 is a strict child of exact 2.6.52 and repairs public acquisition-kind dispatch. The public Acquisition API now uses one exhaustive semantic kind-policy matrix, so trainer-owned captures, theft, and owned_capture transactions deliberately participate in No Catching on actual capture attempts, canonical species legality, and configured Party Size without being misclassified as ordinary area acquisitions. Generic scripted/forced/editor sources remain deliberately neutral and Wonder Trade remains observe-only. Initialization asserts that every Acquisition.KINDS member has a complete policy row, preventing future vocabulary additions from silently bypassing enforcement. No save-schema, rule-default, engine-range, or Compatibility API revision is required. Static/semantic PASS; runtime/provider confirmation remains required.

# 2.6.52

2.6.52 is a strict child of exact 2.6.51 and advances the existing Kanto Reforged adapter from 1.2.0 to source-audited 1.3.0. It composes expanded species/moves/trainers/status mechanics, preserves stricter-of-two level-cap ownership, activates the capability-driven No Held Items rule on R/B/Y while KR supplies its held-item system, delegates KR Full/Pure spawn randomization while preserving curated-mode composition, recognizes KR fixed statics, and registers restored Gold Viridian Forest through the generic Dungeon Lock-In content contract. Mt. Moon/Seafoam already match native dungeon families; Safari Zone remains area-split territory and Cerulean Cave is deliberately not force-classified. Exact-edition combination runtime testing remains required.

# 2.6.51

2.6.51 is a strict child of exact 2.6.50. It source-maps Kanto Reforged 1.3.0 fixed legendary/mythical encounters as static, non-randomizable provenance without treating KR roamers as statics. KR Full Spawn Mix and Pure Random Spawn are recognized as authoritative encounter-randomizer ownership so Nuzlocke does not double-randomize those tables; curated KR encounter tables remain composable. No save-schema or public API version changes are required.

# 2.6.50

2.6.50 is a strict child of exact 2.6.49. No Held Items is now capability-driven instead of hard-coded to Gen2: native Gold/Silver remain supported, vanilla R/B/Y keeps the rule hidden, and compatible Gen1 held-item providers can expose the rule through a provider capability/profile. The generic Gen1 path removes player GIVE actions while preserving TAKE and transiently suppresses existing player-held item values during battle without deleting them. Runtime provider testing remains required.

# 2.6.49

2.6.49 is a strict child of exact 2.6.48. It preserves the already-correct vanilla R/B/Y story2 and native Gold/Silver No Day Care gates, and adds a reload-safe custom Day Care pick-only deposit guard so content mods that replace the R/B/Y Day Care talk flow cannot bypass No Day Care. Existing deposited Pokemon, parents, pending Eggs, and all withdrawal/recovery paths remain untouched. No save-schema or public API version changes are required.

# 2.6.48

2.6.48 is a strict compatibility-certification child of exact 2.6.47 (parent player ZIP SHA-256 `7e4d6cbc9aecbb17748e530cd5566657c7631d3002924c7bcd36630c7c770945`). It source-audits Gen1Recomp 0.2.17 and 0.2.18 and advances the audited-engine marker to **0.2.18** without changing gameplay rules, save data, Compatibility API 29, Diagnostics API 1, Mod API 2, Save Schema 4, the `>=0.1.86 <2.0.0` engine range, supported editions, or the 30-file player inventory.

The 0.2.16 → 0.2.17 delta is confined to Skin Studio/UI presentation. The 0.2.17 → 0.2.18 delta is confined to touch-skin, launcher presentation, Playfield/Renderer, UI-kit viewport, and associated test changes. No Mod API, Loader, battle-engine, Gen 2 API, registry, hook, save, or required-import contract changes were found, so Nuzlocke needs no new gameplay adapter or manifest migration. The public `battle.charge_required` seam adopted into Nuzlocke compatibility metadata in 2.6.47 remains the latest relevant battle API addition.

2.6.48 therefore changes compatibility certification/provenance and documentation only. The 2.6.47 source-header/compiler-budget repairs remain unchanged. Static/source audit does not replace an exact 0.2.18 runtime boot, NUZ RULES, DEV REPORT, save-load, and trainer-battle smoke test on each supported edition.

# 2.6.47

2.6.47 is a strict compatibility/integrity child of exact 2.6.46 (parent player ZIP SHA-256 `c59bb4ed687a99c3528d3a3ed125209106128d42907abf8a8e86defc426a41a5`). It source-audits Gen1Recomp 0.2.15 and 0.2.16, advances the audited-engine marker to **0.2.16**, and records both release profiles without changing Mod API 2, Save Schema 4, the `>=0.1.86 <2.0.0` engine range, supported editions, rule defaults, or the 30-file player inventory.

Gen1Recomp 0.2.16 adds the shared guarded `battle.charge_required` hook to both battle engines. Nuzlocke does not currently need to override charge decisions and performs no private charge-state surgery, so 2.6.47 records this as an available/not-owned compatibility seam rather than adding a gameplay wrapper. The launcher also adds streamed required-import/install-cache infrastructure; Nuzlocke declares no `required_imports`, so no manifest migration is required.

The audit also repairs stale source-header provenance inherited from 2.6.42-era text: `main.lua` now identifies the current build as 2.6.47. Static/semantic validation does not replace an exact 0.2.16 runtime boot/DEV REPORT smoke test.

The full release gate also found an inherited compiler-budget violation in the classic R/B/Y configuration draw path: one nested function had reached 169 locals, above the project hard ceiling of 160. 2.6.47 scopes that unchanged draw branch into a nested helper, reducing that function to 57 locals and restoring package-wide nested-function maxima to 41 upvalues / 129 locals. Release Safety now also checks the readable `main.lua` source header against the executable build, preventing this provenance drift from recurring silently.

# 2.6.46

- Strict child of exact 2.6.45. Parent player ZIP SHA-256: `ec79f8e39ab60b6f1bb1835125550b5c39887cfa4ff35c5b8c7c4f5fdd0f45a8`.
- Adds a descriptive compatibility profile for The World 5.10.0 across Red/Blue/Yellow/Gold without taking ownership of its simulation, weather, factions, maps, AI trainers, or save state.
- The profile composes live trainer parties, boss-level observations, merged species metadata, encounters, held items/healing and acquisition policy; Wonder Trade remains observe-only.
- The World detection accepts the known/likely manifest-id spellings and also the exact display name `The World` from the live mod graph, avoiding dependence on one packaged id spelling.
- Dynamic Champion, Rocket Ball and WX semantics are consumed only when the runtime supplies semantic battle/acquisition/encounter metadata through the generic 2.6.43-2.6.45 contracts; Nuzlocke does not infer hidden package state.
- Adds contextual warnings for Random Encounters and Physical/Special Split while The World is active.
- No rule default/save schema/engine range/package-tree change. Full combination runtime testing required.

# 2.6.45

- Strict child of exact 2.6.44. Parent player ZIP SHA-256: `e725627b0b289ade0285eb17438ff8b45c2c707a9be7d7cd9a84e7ee23d4a77d`.
- Extends the public acquisition classifier with semantic `theft` and `owned_capture` source kinds for mods that capture or steal already-owned Pokemon. These remain subject to capture legality/species restrictions but are not silently redefined as ordinary wild area encounters.
- Generalizes encounter randomizer ownership to `allow`, `deny`, or `provider`; provider-owned encounters make Nuzlocke step aside instead of rewriting an authoritative external encounter.
- Registered encounter metadata can preserve variant/form identity and randomization ownership through acquisition/randomizer evaluation.
- Wonder Trade remains observe-only; no unsafe post-transaction interception was added.
- No rule default/save schema/engine range/package-tree change. Runtime confirmation required.

# 2.6.44

- Strict child of exact 2.6.43. Parent player ZIP SHA-256: `ac44dc8ac80a104e8bd8cba34f832276b6d25f7abe15d51dea219fb793282405`.
- Strengthens live merged species facts for expanded-content mods by exposing merged/provider generation metadata alongside existing live types/BST/category flags.
- Adds metadata-availability telemetry so compatibility diagnostics can distinguish known external facts from unknown classification instead of silently assuming a vanilla schema.
- Physical/Special Split now honors explicit provider/live move-category contracts before Nuzlocke's canonical Gen 1/2 fallback mapping; plain native old-era `move.category` remains recategorizable unless explicitly marked authoritative.
- No rule default/save schema/engine range/package-tree change. Runtime confirmation required.

# 2.6.43

- Strict child of exact 2.6.42. Parent player ZIP SHA-256: `6fadf9ca7094d0acab8cb4fb9ce1b436b153ba0a7af1c17ff01f87b5c63e2b54`.
- Hardens level-cap EXP composition: the authoritative clamp now runs at priority 1000000, marks blocked/trimmed EXP context semantically, and preserves zero after ordinary downstream multipliers.
- Adds semantic battle-role metadata (`rival`, `gym_leader`, `elite_four`, `champion`, `progression_boss`) so dynamic trainer/League providers can identify battle meaning without trainer-ID hard-coding.
- The World tournament-EXP concern was reviewed as a composition risk, not a reproduced 2.6.42 bug: Nuzlocke already ran outside the default-priority multiplier. 2.6.43 makes that ordering contract explicit and harder to upset.
- No rule default/save schema/engine range/package-tree change. Runtime confirmation required.

# 2.6.42

- Strict child of exact 2.6.41. Parent player ZIP SHA-256: `4cfd5c1674968152b806c349581243c4a8fc6817088d5cc800ff044cc0b4b675`.
- Fixes a 2.6.40 regression where the progression-only PC Catches gate required an eligible denial reason but accidentally omitted `no_catching` from that set.
- Explicitly declared progression-required/exception-allowed captures can again use PC Catches when No Catching is the blocking rule, provided real Box storage has room.
- Ordinary catches cannot bypass No Catching because the progression declaration requirement remains mandatory.
- Refreshes Release Safety's independent expected-parent version/SHA from stale 2.6.38 values to exact 2.6.41 so parent-provenance drift is detected correctly.
- No save schema/API/default/engine-range/edition/package-tree change. Runtime confirmation required.

# 2.6.41

- Strict child of exact 2.6.40. Parent player ZIP SHA-256: `03d1d1cca7a31996093a5aed7bf19811c9efe5bf26d8d17f8246843bf32bfbde`.
- Adds an audited VanillaPlus 0.3.0 compatibility profile without taking ownership of its quests/maps/NPCs.
- Recognizes exactly three mandatory VanillaPlus story catches (Bulbasaur Lv12 Viridian Forest; Squirtle Lv18 Route 25; Charmander Lv12 Rock Tunnel B1F) as progression-required fixed/non-randomizable sources.
- Publishes those sources through the generic Content API and lets registered source metadata fill absent progression/randomizer context fields.
- Adds an in-UI Random Starter compatibility warning for VanillaPlus's vanilla `EVENT_CHOSE_*` quest branching.
- Optional cave ambushes and guardian Starmie are deliberately not progression exceptions.
- No save schema/API version/rule default/engine-range/package-tree change. Runtime combination testing required.

# 2.6.40

- Strict child of exact 2.6.39. Parent player ZIP SHA-256: `d739db42ee299b4f73bffededf2ad01724b17df285580f727c316692a1ea79fa`.
- Fixes PC Catches eligibility so every exception requires explicit progression-required plus exception-allowed metadata.
- Makes Nuzlocke movement-speed assists preserve an already-accelerated downstream result instead of stacking another 2x multiplier.
- Hardens Rival classification to explicit flags/canonical Rival identities rather than arbitrary substring matches.
- Reasserts Permadeath's durable `nuzlockeDead` invariant at `battle.started` against external pre-battle HP restoration.
- No mod-specific adapter, new rule, save/API/schema/engine-range/package-tree change. Runtime confirmation required.

# 2.6.39

- Strict child of exact 2.6.38. Parent player ZIP SHA-256: `841004812e3e4ea8939e1304d87afe5698a1ef1616a7b4efb92c7a5155fdfa77`.
- Corrects executable build identity/provenance to 2.6.39 with exact parent 2.6.38 and the 30-file package contract.
- Reorganizes the Late Runtime dependency-forwarding closure so the exact injected dependency surface is preserved while the closure no longer exceeds the 48-upvalue hard ceiling.
- Hardens Release Safety to require one current-version top heading per public document, reject stale `Current build` banners, and verify exact parent SHA/version plus package-count provenance.
- Consolidates duplicate 2.6.38 public-document sections, removes stale 2.6.33 current-build banners, and deduplicates the 2.6.38 `mod.card` known entry while preserving unique history.
- No gameplay rule/default/save/API/engine-range/edition/package-tree behavior change. Existing 2.6.38 runtime-validation debt remains unchanged.

# 2.6.38

- Strict child of exact 2.6.37. Parent player ZIP SHA-256: `0328e50fb794daafb719415f26eb2de7a5b699757e66bee3534cf7446867f4aa`.
- Fixes the five confirmed issues from the full 2.6.37 bug review without adding rules, changing defaults, or changing the package tree.
- Gold/Silver **No Setup Moves** now blocks only self-boosts caused by the move user. Reactive **Rage** Attack boosts survive even though they occur inside the opponent's `useMove` call and are no longer attributed to the attacking side's SELF/ENEMY scope.
- R/B/Y, Gold/Silver, and public/provider capture/acquisition boundaries now **fail closed** when the authoritative legality policy raises an error. The transaction is refused/refunded where applicable and diagnostic detail is recorded in `lastAcquisitionPolicyError` instead of silently legalizing the catch/acquisition.
- Extracted Classic UI, Late Runtime, and Randomizer Runtime mutation guards now use the full authoritative save-block predicate, covering both **newer schema** and **migration error** safe-stop states.
- **Sleep Clause** provenance is scoped to one sleep episode. Rest explicitly clears opponent-inflicted provenance in both generations, and awake party members clear stale provenance when scanned.
- Restores the accidentally omitted **2.6.35 README** release-history section.
- Retained-module cleanup peels the older Flinch/Trap wrapper above the 2.6.37 move-context owner before replacing that owner, then reinstalls Flinch/Trap.
- Save Schema 4, Compatibility API 29, Diagnostics API 1, Randomizer API 1, engine range, supported editions, and package inventory are unchanged. Runtime confirmation required.

# 2.6.37

- Strict child of exact 2.6.36. Parent player ZIP SHA-256: `11e1eb443020ab25ce1f13dec4ef72bcf9a90b2e2538aab3fdbf3a8d25e7c818`.
- Fixes four confirmed battle-rule/classification defects found by the Chat #21 full Gen 1/Gen 2 battle classifier audit.
- R/B/Y **Burn Ban** now suppresses burn application without suppressing the native Fire-hit defrost branch carried by the same Gen 1 burn-side-effect record.
- Gold/Silver **No Setup Moves** now applies only while a move is being resolved. X Items, Berserk Gene, Rage/passive boosts, and other non-move positive stage changes are no longer accidentally swallowed by the generic `changeStage` wrapper.
- Gold/Silver **Other Stat Drops** now also covers move-origin self drops such as non-Ghost Curse's Speed -1, while ordinary foe-directed drops continue through the existing attacker-aware `changeStageAgainstMist` path.
- Optional **Physical/Special Split** now classifies **Mirror Coat** as Special instead of letting the default canonical-move fallback mark it Physical.
- Retained-module reload cleanup retires the old 2.6.36 generic Setup wrapper before composing current Gen 2 `changeStage` wrappers, preventing the stale over-broad behavior from surviving a hot reload.
- Rule defaults, save keys, Save Schema, public API versions, engine range, supported editions, and package inventory are unchanged. Runtime confirmation required.

# 2.6.36

- Strict child of exact 2.6.35. Parent player ZIP SHA-256: `cd2009a7aef2d7bc24aa28b7198764d7c16d2b8435b4ba7f1cab5c66ade422e3`.
- Fixes the remaining reviewed classic 2.6.31 layout bugs without changing gameplay, saves, APIs, or package inventory.
- Classic R/B/Y **NEW GAME Setup** no longer lets the upper-right `current/total` position indicator collide with the longer `NUZLOCKE SETUP` header. The title keeps the full top row; the position indicator moves to the second header row on classic pre-game Setup only, and the `EDITION NEW GAME` subtitle now fits to the remaining safe width.
- Classic R/B/Y lower help-pane text now stays fully inside the 12/6 split frame. Wrapped descriptions and section-help rows use the safe `104 / 116 / 128` baselines, and the blinking more-text arrow also uses the final safe baseline instead of intruding into the bottom border.
- Gold/Silver native layout, in-game classic NUZ RULES header layout, four visible classic config rows, and all 2.6.35 Catch Info / Accuracy-wrapper repairs are preserved.
- Runtime confirmation required.

# 2.6.35

- Fixed classic R/B/Y Catch Info's compact Pokemon label to use drawable `<PK><MN>` ligatures instead of the runtime-only `<PKMN>` substitution token.
- Added explicit stale-wrapper retirement for Accuracy Drops on retained-module ModLoader reloads. R/B/Y retires the 2.6.34 Accuracy owner and legacy `__nuzlockeStatusScope2624_*` Accuracy owner before installing the 2.6.35 independent wrapper; Gen 2 performs the equivalent cleanup for `__nuzlockeStatDropScopesSession2634` and `__nuzlockeAccuracyScopeSession2624`.
- Preserved 2.6.34 rule semantics, save keys, API versions, engine range, and package inventory.
- Left the separately reviewed 2.6.31 classic Setup/header and help-pane geometry findings outstanding for the next repair pass.
- Runtime confirmation required.

# 2.6.34

- Strict child of exact 2.6.33. Parent player ZIP SHA-256: `9527f33868abb9688b1cceafb9da10d71c816763d40b5d95234c263fd93e888f`.
- Reorganizes battle restrictions into **STATUS BANS** and **SETUP & STAT BANS**, reducing the overloaded Clauses section.
- Adds **Burn Ban** as a new `OFF / SELF / ENEMY / ALL` No Status Moves child. Secondary burn suppression preserves the damaging hit.
- No Status Moves now synchronizes exactly six outright status bans: Paralysis, Confusion, Sleep Ban, Poison/Toxic, Burn, and Freeze.
- Moves **Sleep Clause** into Status Bans for discoverability without changing its behavior or allowing No Status Moves to synchronize/hide it.
- Moves **Accuracy Drops** out of the No Status Moves child family and into Setup & Stat Bans. Its persisted key/value is preserved; future No Status Moves changes no longer overwrite it.
- Adds **Other Stat Drops** (`OFF / SELF / ENEMY / ALL`) for negative Attack/Defense/Speed/Special-family/Evasion stages while keeping Accuracy separate and preserving damaging hits whose secondary drop is blocked.
- Keeps **No Setup Moves** and **Evasion Clause** in Setup & Stat Bans. OHKO, Flinch, and Trap remain standalone clauses.
- Gold/Silver Setup and NUZ RULES now expose Sleep Clause, OHKO Clause, and Evasion Clause along with the reorganized/new battle rules.
- Save Schema 4, Compatibility API 29, Diagnostics API 1, Randomizer API 1, engine range, and package inventory are unchanged. Exact-edition runtime confirmation is required.

# 2.6.33

- Strict child of exact 2.6.32. Parent player ZIP SHA-256: `5d7053ec61efd460409e84071ed94c1a09fade11cfcc93029c0cb8071dc2fed5`.
- Polishes classic R/B/Y **NUZ INFO → CATCH INFO** only: `POKEMON` was changed to `<PKMN>` and `ENCOUNTER` to `ENC.`. A later 2.6.35 review found `<PKMN>` is runtime-only at this direct font boundary and corrects it to drawable `<PK><MN>`.
- Replaces the fixed x=88 / 8-glyph Catch Info value column with label-aware placement starting at x=72, giving common rows up to two additional value glyphs while pushing longer-label rows right enough to avoid collisions.
- STAT INFO, MOVE INFO, Gold/Silver NUZ INFO, gameplay, saves, providers, Randomizer behavior, compatibility contracts, and public APIs are unchanged.

# 2.6.32

- Strict child of exact 2.6.31. Parent player ZIP SHA-256: `37a7a483489c8ef73952011131dbbc3596e719515cd5e81be61b9e0f20769ae3`.
- Removes the accidental Dev Mode `KEY <internal_rule_key> |` prefix from normal Setup/NUZ RULES description panes on classic R/B/Y and native Gold/Silver.
- Internal rule keys remain available through developer diagnostics; the player-facing rule descriptions themselves are unchanged.
- Preserves the 2.6.31 DEV REPORT text-encoding fix and four-row classic Setup/NUZ RULES layout.
- No gameplay, save-schema, default, provider, Randomizer, compatibility, or public-API behavior changes.

# 2.6.31

- Strict child of exact 2.6.30. Parent player ZIP SHA-256: `4c058ddf993efc929c4ec20b46611f034a64881c24066ffaf10247103a919f55`.
- Fixes the Yellow runtime DEV REPORT glyph corruption: classic R/B/Y `Font.draw` was receiving raw ASCII for dynamic report rows even though the renderer expects `Strings(...)` cartridge encoding.
- Applies the same draw-boundary encoding to DEV REPORT body rows, storage-info rows, known-issue rows, and dynamic DEV error text; wrapping/report semantics remain unchanged.
- Moves the classic R/B/Y live `current/total` position indicator from its dedicated strip into the upper-right header and increases the classic config page from three to four visible rows. The upper/lower frame split changes from 11/7 tiles to 12/6 so fourth-row collapsed summaries remain above the divider and the lower pane still fits three help lines.
- Gold/Silver keep their native Gen 2 position strip and three-row config geometry. No rule/default/enforcement/save/provider/API/engine-range change.

# 2.6.30

- Stability hotfix built directly from the last runtime-valid 2.6.28 package. Parent player ZIP SHA-256: `1b7bf2f064d80e0ad36886c3f9db0fa5145ee90b9e88c6cdef7ed690a5d00083`. The runtime-failed 2.6.29 artifact is not used as a parent.
- Fixes the Yellow initialization failure `forgiveness.lua:11: forgiveness requires getDisplayRoutes`. `getDisplayRoutes` is assigned only after `classic_ui.lua` initializes, so passing its earlier value into Forgiveness froze `nil`; Forgiveness now receives a live resolver that follows the later Classic UI owner.
- Ports the reviewed 2.6.29 split-scope repairs surgically onto 2.6.28: module-owned Identity helpers, progression/default forward declarations, Classic UI text-fit ownership, Public Interop live policy wrappers/getters, and Late Runtime message-helper injection.
- Adds registration-order validation for extracted-module asserted dependencies so a required helper cannot silently be handed nil merely because its owner initializes later.
- No rule/default/enforcement/save/API/engine-range change. Save Schema 4, Compatibility API 29, Diagnostics API 1, Run History API/storage 1, Randomizer API/algorithm 1, and Mod API 2 remain unchanged.
- Status Bans / Setup & Stat Bans reorganization remains deferred until runtime confirms this stability hotfix.

# 2.6.28

- Strict child of 2.6.27. Parent player ZIP SHA-256: `4052f7ea8ff4f028a9a6e9fb3be8f0a6bd82599aa284c72428cf26b0c0e23345`.
- Extends **No Status Moves** from four to six child scopes by adding **Poison/Toxic** and **Freeze**, both using `OFF / SELF / ENEMY / ALL` and the existing parent synchronization/hiding behavior.
- Poison/Toxic covers ordinary poison, Toxic/bad poison, and modeled damaging poison side effects; Freeze covers modeled freeze side effects. When a blocked effect belongs to a damaging move, the hit still deals its normal damage.
- Adds **Flinch Clause: OFF / SELF / ENEMY / ALL**. It suppresses newly caused flinch effects by the selected side(s) while preserving move damage; on Gen 2 it also covers newly caused King's Rock flinches.
- Adds **Trap Clause: OFF / SELF / ENEMY / ALL** for partial-trapping mechanics such as Wrap, Bind, Clamp, and Fire Spin. Initial move damage is preserved while the lock/continuation effect is suppressed.
- Existing Sleep Clause, OHKO Clause, Evasion Clause, No Setup Moves, battle damage, save schema, provider ownership, APIs, engine range, and package inventory remain unchanged.
- Static/semantic harness validation is PASS; exact-edition battle runtime confirmation remains required.

# 2.6.27

- Strict child of 2.6.26. Parent player ZIP SHA-256: `10e639ac18327ac7ec41cc0d525ca9f53461e2c6122e37cfba1aadd6d93fbeba`.
- Audited the shared Gen 2 Setup/NUZ RULES description surface for exact-edition leakage. One stale shared description that named only SILVER now uses running-edition/counterpart-edition wording that is correct in both Gold and Silver.
- Added a read-only `gen2DescriptionParityAudit()` so future shared Gen 2 descriptions fail diagnostics when they name Gold without Silver, Silver without Gold, or claim an exact-edition-only contract on the shared surface.
- Added a Silver-focused `Dev.gen2EditionParityAudit()` that verifies exact edition, engine family, profile scope, semantic Gen 2 adapter IDs, the 251-row PKMN BAN selector, and Random Starter transaction-health identity without treating hook HEALTHY/MISSING state as parity evidence.
- DEV snapshots/self-tests now carry exact `edition`, `engine_family`, and `profile_scope` fields plus the Gen 2 parity report. Text exports show semantic adapter IDs and a dedicated Gen 2 edition-parity section.
- Gen 2 Random Starter transaction health now carries exact edition/profile metadata and semantic adapter ID `random_starter_transaction_gen2`; the historical health export remains available.
- No gameplay rules, save semantics, defaults, provider ownership, Compatibility API, Save Schema, Diagnostics API, Run History API, Mod API, or engine range changed.
- Static validation is PASS; exact Gold and Silver runtime evidence remains separate and Silver runtime smoke is still required before promoting runtime confidence.

# 2.6.26

- Strict child of 2.6.25. Parent player ZIP SHA-256: `10445c2dd4566679abde7544c9080c044f11dec2f6851a8827ffb9f991eb9e84`.
- Canonicalized internal shared-engine terminology from historical Gold naming to Gen 2 naming: `runtimeIsGen2`, `gen2Only`, `gen2BetaRules`, and `gen2BetaDescriptions`.
- Retained `runtimeIsGold`, `goldBetaRules`, and `goldBetaDescriptions` as compatibility aliases; persisted `gold_*` keys and edition-specific setup profile names are deliberately unchanged.
- Rule Registry descriptors now identify current Gen 2-only rows as `generation=gen2`, expose `gen2_only=true`, and retain `legacy_generation=gold` as a read-only compatibility hint.
- DEV hook-health diagnostics now report exact edition separately from shared engine family and expose semantic `adapter_id` values while keeping historical `id` values stable.
- Native presentation and Route 29 diagnostic text now identifies Gold versus Silver exactly.
- Updated the Cherrygrove World Building fallback from Gold-only to Gen 2-only; catalog snapshot remains 97 keys / 582 resolutions with checksum `1623887322`.
- No gameplay, save, rule-default, provider, public Compatibility API, Diagnostics API revision, Randomizer algorithm, engine-range, or package-inventory changes.

# 2.6.25

- Strict child of 2.6.24.
- Extended PKMN BAN to the shared Gold/Silver rule surface with National Dex #001-#251 while preserving R/B/Y #001-#151 behavior.
- Generalized species-ban identity helpers around generation-correct National Dex limits; retained the older Gen 1 helper names for private compatibility.
- Added a native Gen 2 PKMN BAN presenter using Chrome plus the engine's filled cursor, native up/down scroll glyphs, five-row paging, and live banned-count display.
- Kept acquisition/Randomizer/Failed Encounter/mandatory-starter semantics unchanged while applying them to Gen 2's additional 100 species.
- Corrected current player-facing shared-adapter wording from Gold-only to Gold/Silver or Gen 2 where appropriate.
- No Save Schema, Compatibility API, Diagnostics API, Run History API, Randomizer algorithm, Mod API, engine-range, or package-inventory change.
- Gold and Silver runtime validation remain separate evidence requirements.

# 2.6.24

- Strict child of 2.6.23. Parent player ZIP SHA-256: `2c1da0d1c6f9d7d522749b8b81af5d4bbc690138705df1923fad0782aca724ff`.
- Adds **No Status Moves: OFF / SELF / ENEMY / ALL** as a bulk parent for four initial scoped status-effect restrictions: Accuracy Drops, Paralysis, Confusion, and Sleep Ban. Changing the parent synchronizes those four child values; while the parent is non-OFF the redundant child rows are hidden. Returning the parent to OFF exposes the children for mixed per-effect scopes.
- Adds **No Setup Moves: OFF / SELF / ENEMY / ALL**. It suppresses positive in-battle stat-stage setup for the selected side(s) while leaving the damaging portion of moves intact when the boost is only a secondary effect.
- Keeps the existing Sleep Clause, OHKO Clause, and Evasion Clause independent. Sleep Ban is an outright side-scoped infliction restriction; Sleep Clause keeps its existing one-opposing-sleeper semantics and Rest/self-sleep exemption.
- Adds R/B/Y-only **PKMN BAN** beside the existing species restrictions. It opens a classic native-cursor list ordered by National Dex #001-#151; A toggles the hovered species, Up/Down scrolls, Left/Right pages by five, and B returns.
- PKMN BAN blocks selected species from ordinary catches, optional gifts, trades, and Nuzlocke-owned Random Starter/Random Encounter candidate pools. Existing Pokemon are preserved. The mandatory opening starter retains the established progression-safety exemption, while Random Starter candidates honor the ban.
- Banned wild encounters are rejected by the authoritative catch policy before Failed Encounter eligibility is armed, so they do not consume an area merely by being encountered.
- The World Building rule-feedback catalog adds a PKMN BAN rejection row; current snapshot is **97 keys / 582 tier-region resolutions / checksum 210615434**.
- No new player-package files. Save Schema remains **4**; Compatibility API **29**, Diagnostics API **1**, Run History API/storage **1**, Randomizer API/algorithm **1**, Mod API **2**, engine range `>=0.1.86 <2.0.0`, and exact game targets remain Red/Blue/Yellow/Gold/Silver.
- Runtime confirmation is still required for the new battle scopes on Gen 1 and Gen 2 and for the R/B/Y PKMN BAN picker/enforcement flow.

# 2.6.23

- Strict child of 2.6.22. Parent player ZIP SHA-256: `3d26b60cac0fdfccebc730cdb8b939906216c78117be902dbd50b4c7bcbab2d5`.
- Adds a compact **up / current-total / down** navigation strip to NEW GAME Setup and NUZ RULES on both classic R/B/Y and native Gold/Silver presenters.
- The numeric position is the selected row within the live navigable `flatItemList`; collapsing sections and hiding dependent rows therefore updates both the current position and total without a parallel/static count.
- Up/down indicators mean offscreen content exists above/below the current visible window, not merely that the cursor can move. They disappear at the corresponding list boundary.
- Gold/Silver reuse the native ScrollingMenu arrow tiles (`$61` up and `$EE` down). Classic R/B/Y reuse the native `$EE` more-below tile and rotate that exact tile for the up indicator rather than depending on an unsupported text glyph.
- Classic list rows are placed on a 16px cadence starting at Y=40 so the new 8px position strip fits between the existing two-line title and the first row while preserving the third row and the 2.6.22 collapsed-summary second line inside the upper panel.
- Cursor movement, fold state, section reset, hidden-row logic, rule values/defaults, saves, gameplay enforcement, and provider ownership are unchanged.
- Save Schema remains **4**; Compatibility API **29**, Diagnostics API **1**, Run History API/storage **1**, Randomizer API/algorithm **1**, Mod API **2**, engine range `>=0.1.86 <2.0.0`, and the 30-file package inventory remain unchanged.

# 2.6.22

- Strict child of 2.6.21. Parent player ZIP SHA-256: `e0149c35852c59069f9ebcf9c6b195e4f4e268172c4baeb7fe601d65a72c80ef`.
- Adds compact summaries to collapsed NUZ RULES / NEW GAME Setup section headers on both the classic R/B/Y presenter and native Gen 2 presenter.
- A collapsed section shows **DEFAULT** when all catalog-backed settings on that surface match their canonical defaults, or **N CHANGED** when N effective displayed settings differ from those defaults.
- Summary counts exclude action-only rows such as Reroll Seed and use the same effective values shown by the menu, including provider delegation, so the header cannot disagree with the visible rule state.
- Uses the existing unused second line inside each section-header row; list length, cursor/fold behavior, section reset, rule values, saves, enforcement, and provider ownership are unchanged.
- Save Schema remains **4**; Compatibility API **29**, Diagnostics API **1**, Run History API/storage **1**, Mod API **2**, RNG algorithm **v1**, engine range, and 30-file package inventory are unchanged.

# 2.6.21

- Strict child of 2.6.20. Parent player ZIP SHA-256: `d6bcc8d4e432ca14c5628c9fcbf46806c587150e1693281a079d0c987751b668`.
- Changes `randomizer_seed = 00000000` from "generate once and overwrite Setup" to a persistent **AUTO** configuration. AUTO now resolves a separate nonzero playthrough seed for each NEW GAME that enables Random Starter, Random Encounters, Random Field Items, or Random Learnsets.
- Existing nonzero seeds are backward-compatible **FIXED** seeds; 2.6.20-and-earlier profiles/runs that already contain a nonzero seed keep that exact seed and deterministic behavior.
- Adds a Setup-only **Reroll Seed** action directly below Rndm Seed. Reroll creates a new nonzero fixed seed immediately; returning the numeric seed to `00000000` restores AUTO mode.
- Stores AUTO's resolved value under playthrough-local internal state rather than rewriting the canonical `randomizer_seed` rule, so the staged Setup profile remains AUTO across consecutive NEW GAME runs.
- Fresh NEW GAME snapshot commit now resolves the run seed after the fresh mod.save bucket is authoritative and re-applies Random Encounters/Random Learnsets. This prevents the prior run's live randomized registries from being reused when starting another NEW GAME in the same process.
- NUZ STATUS reads the effective resolved seed for its `RNG ######## v1` row; DEV SELF-TEST reports both `randomizer_seed_mode` and `randomizer_run_seed`. Stored-state diagnostics validate the optional resolved seed as an integer in `1..99999999`.
- No RNG algorithm-version bump: stream hashing remains algorithm **v1**. Save Schema stays **4**; Compatibility API **29**, Diagnostics API **1**, Run History API/storage **1**, Mod API **2**, engine range and package inventory are unchanged.

# 2.6.20

- Strict child of 2.6.19. Parent player ZIP SHA-256: `317317fcb6b021b87a6a4818a2f455dd19b6e80acbdeb01efae7ae603bf77c23`.
- Fixes fresh-save schema lifecycle on both generations: NEW GAME emits `save.created` rather than `save.loaded`, so a newly created current-build save now receives required Save Schema **4** immediately instead of waiting for its first later CONTINUE.
- Fresh-save initialization now clears save-scoped `newer_schema` / `migration_error` pause state and warning/write-attempt diagnostics inherited from an abandoned prior save before writing into the newly adopted save namespace. This prevents a brand-new run from remaining paused after returning to the title from an unsupported newer-schema save.
- Preserves the existing fresh-save Whiteout and movement-assist semantic markers and writes the schema marker last.
- Adds `saveUpgrade.initializeFreshSave()` and requires it through the existing Save/Migration Integrity audit.
- No rule-default, gameplay-enforcement, package-inventory, engine-range, or public-API revision. Save Schema remains **4**; Compatibility API remains **29**; Diagnostics API remains **1**; Run History API/storage remains **1**; Mod API remains **2**.

# 2.6.19

- Strict child of 2.6.18. Parent player ZIP SHA-256: `5b72598cb29e4d84bab4a43026c80975875b2f90300894bb5f0a904e53a70804`.
- Fixes Maximum BST catch-rejection feedback so the World Building message now includes the rejected species' resolved BST and the configured Maximum BST limit instead of computing and discarding both values.
- Preserves the existing World Building T1/T2/Kanto/Johto catalog wording by resolving `maximum_bst` through `worldRuleText()` first, then appending the live `BST / Limit` detail on a second line.
- Adds a narrow source-level regression audit that fails if the Maximum BST rejection branch stops consuming the live BST/limit values or loses the dynamic detail line.
- No rule-default, enforcement, save-schema, package-inventory, engine-range, or public-API changes. Save Schema remains 4; Compatibility API remains 29; Diagnostics API remains 1; Run History API remains 1; Mod API remains 2.

# 2.6.18

- Strict child of 2.6.17. Parent player ZIP SHA-256: `7d506fb6e32b8ac40bb47a862b51f4af0489c0d530c8aecc14bac7d419b3da54`.
- Continues staged `main.lua` modularization by extracting Randomizer runtime, World Building/flavor, and F. TOKEN/Forgiveness into dedicated modules.
- Reduces `main.lua` from 27,851 lines to 24,907 lines.
- Release Safety now validates the 30-file player package and ownership markers for the three additional modules.
- No intended gameplay, save, rule-default, encounter, battle, UI, or public-API behavior changes.

# 2.6.17

- Strict child of 2.6.16. Parent package SHA-256: `468b0e77367b023cf2c81f2e87822371cf23dd4286f19295cec56e687d4b5432`.
- Extracts classic Nuzlocke UI/Encounter Tracker presentation into `classic_ui.lua`, competitive battle-clause wiring into `battle_clauses.lua`, and the late-runtime Gold/Silver plus compatibility/presentation phase into `late_runtime.lua`.
- Reduces `main.lua` from 36,338 lines to 27,851 lines while keeping the extracted implementation at the same initialization points.
- New modules receive explicit dependency tables; mutable runtime state such as the current game/save and schema write barrier is resolved at call time instead of being frozen during module load.
- Release Safety now validates the 27-file player-package inventory and ownership markers for the three new modules.
- No intended gameplay, rule, save-schema, public-API, encounter, battle, or UI behavior changes. Save Schema remains 4; Compatibility API remains 29; Diagnostics API remains 1; Run History API remains 1; Mod API remains 2.

# 2.6.16

- Strict child of 2.6.15. Parent package SHA-256: `d2126b518523147485ce9cbbf3ee360befc0b678e089af951c7fc65a3bd2da5e`.
- Expands NUZ RULES dependency guidance across the catalog with bounded `N/A:`, `REDUNDANT:`, and `INTERACTION:` explanations.
- Nuzlocke-OFF challenge rows now explain that they are inactive, while independent Randomizer, Difficulty, Battle Mechanics, Area Split, World Building, QoL, UI, and setup tuning remain unaffected.
- Adds encounter, Type Locke, Randomizer, level-cap, F. TOKEN, item/service, party-size, World Building, and QoL dependency explanations without changing enforcement or saved values.
- Provider-owned settings now use an explicit `LOCKED:` explanation while preserving the saved Nuzlocke choice for restoration when the provider is removed/disabled.
- No gameplay, save-schema, public-API, or rule-default changes. Save Schema remains 4; Compatibility API remains 29; Diagnostics API remains 1; Run History API remains 1; Mod API remains 2.

# 2.6.15

- Strict child of 2.6.14. Parent package SHA-256: `56e991309a4aa76a69d0d7369e24dde121207537ba253045dbd4b70ba17afdd0`.
- Adds **Sleep Clause**: either side is prevented from putting a second opposing living Pokemon to sleep while another living opposing Pokemon remains asleep from that side's move. Self-induced sleep such as Rest does not count. Default OFF.
- Adds **OHKO Clause**: one-hit-KO move effects fail for both sides before damage is applied. Default OFF.
- Adds **Evasion Clause**: positive evasion-stage boosts are blocked for both sides; accuracy-lowering moves are unchanged. Default OFF.
- NUZ RULES section headers can reset their section to the active named preset (or canonical defaults for CUSTOM) after confirmation. Delegated/locked rows remain untouched.
- Rule descriptions can report bounded `N/A:` reasons and warning-only interaction notes without changing enforcement.
- Moves the shared Catch/Stat/Move Info footer slightly upward for safer border clearance.
- Expands read-only persisted-state validation, pure-helper/property coverage, diagnostic-prefix checks, and Release Safety package/document/API/provider drift assertions.
- Save Schema remains 4; Compatibility API remains 29; Diagnostics API remains 1; Run History API remains 1; Mod API remains 2.

# 2.6.14

- Strict child of 2.6.13. Parent package SHA-256: `a2ada354d132704956caac144f2245fedfef1952f982f3afb353e3ffd495cfc9`.
- Refines the classic Encounter Tracker LOG/MAP layout after 2.6.13 runtime confirmation that the screen opens correctly on Yellow.
- Unselected area/result rows stay stable and bounded; only the selected row may marquee. Selection changes reset marquee timing.
- Classic Tracker columns are rebalanced to keep area labels, compact results, and source/context tags inside fixed row bounds without visual overlap.
- No encounter legality, Tracker persistence, Run History, rule, save, or public API behavior changes.

# 2.6.13

- Strict child of 2.6.12. Parent package SHA-256: `1643184a68fdad8d7929cf4f5c134cbf3637d25ec13e3ee589eff170259163dc`.
- Fixes the remaining Yellow/R/B/Y ENC TRACKER rendering failure caused by the Tracker screen calling the NUZ RULES-local `fitPixelText` helper outside its lexical scope.
- ENC TRACKER now owns its own bounded pixel-fit helper for the summary row.
- Runtime evidence from 2.6.12: DEV TOOLS opens correctly on Yellow; ENC TRACKER degrades safely and reports the exact nil-helper fault instead of crashing the process.
- No encounter legality, Tracker persistence, Run History, rule, save, or public API behavior changes.

# 2.6.12

- Strict child of 2.6.11. Parent package SHA-256: `bdfdb65f6883f1ece4705ed3943c927afc99aba198e5c8b29c038e5b630bb3af`.
- Fixes a Yellow/R/B/Y DEV TOOLS crash caused by the screen calling a text-fit helper outside that helper's lexical scope. DEV TOOLS now owns its bounded helper locally.
- Cleans up NUZ STATUS area/state spacing so the area label cannot collide with OPEN/CAUGHT/FAILED.
- Splits the classic NUZ RULES title/revision presentation into bounded rows (`NUZ RULES` / `YELLOW R1`) and moves the list down to preserve spacing.
- Long classic NUZ RULES labels now marquee only while selected; unselected rows remain stable and bounded.
- No gameplay, rule, save, Run History, encounter, or public API behavior changes.

# 2.6.11

- Strict child of 2.6.10. Parent package SHA-256: `ef629d53b7092a61e8d9b339779f8084adc210b68233631a1945d696c2d8e609`.
- Hardened ENC TRACKER construction, projection, summary counting, update, and draw paths so malformed legacy/provider rows or a failed projection degrade safely instead of escaping the custom screen and terminating the process.
- Tracker row preparation now preserves whichever LOG/MAP view can be built and records the failing stage in Dev diagnostics.
- Runtime evidence from 2.6.10: mod boot PASS, NUZ RULES lower-border overlap fix PASS, general menu smoke test mostly PASS; ENC TRACKER opening reproduced a crash-to-desktop and is the target of this repair.
- No intended encounter legality, Tracker save data, Run History, rule, or API behavior changes.

# 2.6.10

- Strict child of 2.6.9. Parent package SHA-256: `93202d84016cfa18ad4153b57922c68d589b4399e75fdd5e145079e109815b06`.
- Fixed a startup-blocking catalog snapshot false positive by refreshing the semantic golden checksum to the current canonical 96-row / 576-combination World Rule catalog.
- The World Rule catalog contents are unchanged from 2.6.9; this is a Release Safety snapshot correction only.
- No gameplay, rule, save, Run History, Compatibility API, or UI behavior changes.

# 2.6.9

- Strict child of 2.6.8. Parent package SHA-256: `734be5ce0ee3c5e2f40ac6939e836c6c192ba9dc0ac5c88d8e806b53f59dd1ef`.
- Clearer Nuzlocke Loadout presentation: hand-edited combinations now display **CUSTOM*** and the selected loadout help identifies the nearest named preset plus the number of differing loadout-owned rules.
- Loadout confirmation rows now show **FROM>TO** values for every pending rule change instead of showing only the destination value.
- Added the authoritative current level cap to the Run History and Dev compatibility/status summaries.
- Added machine-readable public API ownership/stability metadata plus a defensive-copy `getContractMetadata()` reader.
- Standardized Nuzlocke-owned runtime log prefixes by subsystem and expanded Release Safety checks for provider inventory and public API contract shape.
- No Save Schema, Compatibility API, Diagnostics API, Run History API, Mod API, or engine-range changes.

# 2.6.8

- Strict child of 2.6.7. Parent package SHA-256: `7a0a7abc8c9b3f0053e75d7db40fe0125895f3500303a6f0c52719aefe86bc9f`.
- Added **Instant Text** to QOL. When enabled, ordinary dialogue lines render without per-character delay while native page breaks, CONT prompts, A/B waits, scrolling, sound waits, choice boxes, and scripted text timing remain intact.
- PC Catches remains the first QOL row; Instant Text is immediately below it.
- No Save Schema, Compatibility API, Diagnostics API, Run History API, Mod API, or engine-range changes.

# 2.6.7

- Strict child of 2.6.6. Parent package SHA-256: `d34c823f1a92fd1ddb4af3fa76fa1308e5cbe40a6569942d0ef06b6f8528f68d`.
- Shortened the compact Dungeon Lock-In rule label to **Dng Lock-IN**.
- Moved the pre-game/classic rules list upward four pixels so the third visible rule row remains fully inside the upper NUZLOCKE SETUP frame instead of being clipped by the divider or drawing into the description box.
- Description wrapping, scrolling, footer prompts, rule behavior, saves, and API versions are unchanged.

# 2.6.6

- Strict child of 2.6.5. Parent package SHA-256: `2b9c27657c4fa619e495e51113c64cc15cdab16307c8ef3833178872e059538b`.
- Added a read-only **RUN HISTORY** viewer from NUZ STATUS, showing the newest retained catches, deaths, badge awards, F. TOKEN awards/uses, blackouts, and completion events.
- Added Run History producers for `badge.earned`, survivable `run.blackout`, and `run.completed`. Red/Blue/Yellow completion records at Champion victory; Gold/Silver completion records at Red victory.
- Added the **RECOMMENDED** Nuzlocke loadout: classic Nuzlocke core rules plus Gym level caps, without adding battle-item, healing, shop, field-item, or service restrictions.
- Encounter Tracker OPEN/CAUGHT/FAILED summary counts remain the 2.6.5 implementation.
- Run History API/storage remain v1; Save Schema remains 4; Compatibility API remains 29.

# 2.6.5

- Strict child of 2.6.4 (`caf1a244e4edc8496fa1a36a71e78f1d9786d85384f268a999ed6f37db5062d6`).
- NUZ STATUS now shows F. TOKEN balance, current-area encounter state, and the latest retained Run History event in compact bounded rows.
- MOD COMPAT now shows exact edition / audited Gen1Recomp / Nuzlocke build identity.
- DEV REPORT now begins with a compact compatibility-health summary, and Dev Tools adds a scrollable Known Issues panel.
- Dev Mode rule help now exposes canonical rule keys without widening ordinary rule rows.
- ENC TRACKER now shows OPEN / CAUGHT / FAILED summary counts on both Gen 1 and Gen 2 native layouts.
- UI layouts reserve fixed rows for new status text and apply clipping/wrapping so labels do not cross borders, overwrite footers, or overlap existing content.
- No gameplay-rule, default, Save Schema, Compatibility API, Diagnostics API, Run History API, Mod API, or engine-range change.

# 2.6.4

- Strict child of 2.6.3 (`3740ff0d9cc326d8167cf46ae47d524a577054c5388e674675fb4e26791ae7f3`).
- General stability improvements.
- No gameplay-rule, default, Save Schema, Compatibility API, Diagnostics API, Run History API, Mod API, or engine-range change.

# 2.6.3

- Strict child of 2.6.2 (`e7dff58bcd276b409a86183ff8df94fd081d5cc6f9206560ad1312386e6ec435`).
- General stability improvements.
- No gameplay-rule, default, Save Schema, Compatibility API, Diagnostics API, Run History API, Mod API, or engine-range change.

# 2.6.2

- Strict child of 2.6.1 (`d97fda5ae8b6bb54c4a3d725f4ea89918c5852432e036c5c122da75b79f87938`).
- General stability improvements.
- No gameplay-rule, default, Save Schema, Compatibility API, Diagnostics API, Run History API, Mod API, or engine-range change.

# 2.6.1

- Strict child of 2.6.0 (`f0483a8c7f17e65d51051ef17d9af0ebb0cd8a8770fe6b232d556d62c9e63c5d`).
- Added executable Compatibility API 29 shape/contract assertions for the legacy `nuzlocke_compat` and modern `nuzlocke` surfaces, including version/floor/audited-engine metadata, provider inventory, engine-profile/summary defensive copies, and required core functions/tables.
- Removed the redundant profile-metadata registration of `randomizer_seed`; the ordinary rule-catalog row remains the single authoritative registration, so Rule Registry collision audit is clean.
- Added a read-only Rule Registry stored-value validator covering every persisted canonical rule/profile value. It checks canonical type, finite/integer numeric form, min/max range, and optional allowed-value sets; accepted legacy numeric booleans are reported as stale/coercible rather than silently rewritten.
- Added deterministic pure-helper/property audits for finite-number guards, movement-mode clamps, range cycling/wraparound, trainer-money percentage flooring, Item Policy key normalization, Maximum BST presets, Stat EXP preset monotonicity, rule coercion, and validator behavior.
- Production numeric cycling, Trainer Money percentage scaling, and Item Policy key normalization now call the same pure helpers exercised by those audits.
- Corrected build-provenance package inventory from the historical 15-file value to the current 24-file modular player package.
- No gameplay-rule, default, Save Schema, Compatibility API, Diagnostics API, Run History API, Mod API, or engine-range change.

# 2.6.0

- Release build; strict child of 2.5.92. Parent package SHA-256: `f96d91ed036c48320af5e283cd290ff890a7406c483d3cfbe74783956453ef91`.
- Moved **PC-Only Catches / PC Catches** from CLAUSES to the first row of the **QOL** section. This is menu organization only; the existing `progression_pc_catches` key/default/save and enforcement semantics are unchanged.
- Recorded 2.5.92 runtime boot + DEV REPORT rendering as PASS before release promotion.
- Preserved Run History death-occurrence dedupe, migration shadow structural equality, Compatibility API 29, Save Schema 4, Diagnostics API 1, Run History API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0`.
- Gold/Silver exact-edition confidence remains evidence-separated; Silver Random Starter preview/award still requires its own runtime confirmation.

# 2.5.92

- Strict child of 2.5.91. Parent package SHA-256: `8395f11aea40b8faa795402d4abaee930c07d44adc554a60a78f45adbf204ee3`.
- Fixed Run History death-producer idempotency across the three authoritative death bridges: R/B/Y battle, R/B/Y field poison, and Gold/Silver battle.
- Added a persistent per-Pokémon `nuzlockeDeathSequence`, incremented exactly when a new authoritative death is committed and preserved through the F. TOKEN archive/revive snapshot.
- `RunHistory.recordDeath` now derives `death:<pokemonId>:<deathSequence>` when possible, preventing duplicate rows for the same death occurrence without suppressing a legitimate later death after revival.
- Run History API/storage remain v1; Save Schema remains 4; no gameplay rule or token semantics changed.

# 2.5.91

- Strict child of 2.5.90. Parent package SHA-256: `a7f8ba6a311de482dc277c317fb59876b63316b92d3f39ea01c8103462b58846`.
- Fixed migration shadow-store dry-run equality for table-valued keys: recursive structural comparison now replaces raw table reference comparison.
- Added regression coverage for unchanged flat/nested tables and genuine nested changes.
- Save Schema remains 4; migration transaction ordering and recovery semantics are unchanged.

# 2.5.90

- Strict child of 2.5.89. Parent package SHA-256: `ceb089f156ccf64e9f7012511a4b337fa02b984545abf77c2aaee9c8748678d0`.
- Extracted the static/version-aware vanilla Gift Pokémon and in-game Trade source catalogs plus their lookup/fallback helpers from `main.lua` into `acquisition_catalog.lua`.
- Preserved existing `mod.exports.__beta26.buildGiftLookup`, `buildTradeLookup`, and `deterministicSourceFallback` names and behavior.
- Existing `nuzlocke_compat.giftLocationFor`, `tradeLocationFor`, and deterministic-source aliases remain in `main.lua` and consume the same exported helpers.
- Acquisition transaction enforcement, special-area conflict checks, starter logic, encounter rules, saves, and gameplay hooks are unchanged.
- Added `acquisition_catalog.lua` to Release Safety package inventory.
- No API/schema version changes.

# 2.5.89

- Strict child of 2.5.88. Parent package SHA-256: `0cb9aab2138ea188ac0cb0779b3ede527e37663e8f533904f28bd39c7a1bcb31`.
- Extracted DEV REPORT / NZR6 diagnostic presentation and codec infrastructure from `main.lua` into new package-local `dev_report.lua`.
- Preserved NZR4/NZR5 decoding, NZR6 generation, error fingerprints, self-test text/export/reload behavior, `nuzlocke_dev` facade, and lifecycle diagnostic listeners.
- Live `currentGame` state is injected through a getter so the module does not capture stale lifecycle state.
- Added `dev_report.lua` to the Release Safety package inventory.
- No gameplay, save schema, Compatibility API, Diagnostics API, Run History API, Random Starter, encounter, F. TOKEN, or rule behavior changes.
- Runtime boot + DEV REPORT / report-code smoke test required.

# 2.5.88

- Cleaned up the classic R/B/Y MOD COMPAT detail panel: help text now uses two lines per detail page, leaving the bottom control/page indicator row unobstructed.
- Added session-only navigation memory for ENC TRACKER (tab + row), MOD COMPAT (selected row + scroll + detail page), and DEV REPORT/Dev Tools (menu cursor + report scroll).
- Preserved and centralized the existing semantic NUZ RULES/Setup cursor/scroll memory and collapsed-section memory.
- UI navigation/fold state is intentionally not gameplay save data and resets on a fresh process/mod reload.
- No gameplay logic, Save Schema, Compatibility API, Diagnostics API, Run History API, Mod API, or engine-range change.

# 2.5.87

- Reverted the 2.5.86 ENC TRACKER status-marker presentation experiment completely; tracker result rendering is restored to the exact 2.5.85 behavior.
- Reverted the ASCII encounter-area marker experiment; the original tracker presentation remains active.
- Advanced Compatibility API **28 -> 29** with additive introspection only; `compatible_from = 10` remains unchanged.
- Added missing Gen1Recomp engine compatibility profiles for **0.2.12, 0.2.13, and 0.2.14**, so the active audited `0.2.14` profile now resolves to real metadata.
- Added `getEngineProfile()` and `getCompatibilitySummary()` plus normalized `getCapabilityVersion()` lookup.
- Added read-only provider inventory helpers (`listProviders`, `providerCount`, capability lookup aliases) to the Public Interop surface.
- Release Safety now asserts that the configured active engine profile actually exists, preventing audited-engine metadata from silently pointing at a missing profile again.
- Removed a duplicate `nuz_info` ownership declaration. No gameplay rules, saves, Run History, Random Starter behavior, or engine-range policy changed.

# 2.5.86

- Added compact encounter-area status markers to ENC TRACKER: `O CAUGHT`, `X FAILED`, `- OPEN`, `* SHINY`, and `X DEAD`.
- Retained explicit English status text beside every marker for accessibility and font portability.
- Unified the status formatter across classic R/B/Y, native Gold/Silver, and Modern UI tracker presentation paths.
- Presentation-only change; encounter legality/state, Tracker storage, F. TOKEN rerolls, Run History, and gameplay hooks are unchanged.

# 2.5.85

- Completed Run History v1's initial catch/death/F. TOKEN producer integration.
- Added the missing ordinary successful `pokemon.caught` bridge after tracker/area commit; starter/gift/trade/progression producers remain unchanged and identity-deduped.
- Audited the existing death bridges and preserved all three authoritative paths: R/B/Y battle, shared field poison, and Gold/Silver battle.
- Added `forgiveness.awarded` after a Gym Leader reward commits, with semantic Leader-key dedupe.
- Enriched committed `forgiveness.used` rows with the remaining token count and source.
- Run History API remains 1, storage version remains 1, Save Schema remains 4, Compatibility API remains 28, and Mod API remains 2.
- Static Lua parse and dedicated Run History/trainer-reward harnesses pass; exact-edition runtime producer verification remains required.

# 2.5.84 — 2026-08-20

- Strict child of 2.5.83 (`bdfbe315ebab9310f860bcbecf4e918bfa3b6a21041f91bd0cb736307e96cf35`).
- Fixed **RS-CACHE-DEDUP-001**: legacy unseeded Random Starter distinct-choice bookkeeping now counts only canonical bare starter-slot mirror entries.
- Scoped seed/style cache rows and internal marker rows no longer contaminate the unseeded `used` species set.
- Seeded Random Starter behavior, deterministic Gold/Silver starter slate, preview path, award transaction, save format, and Randomizer algorithm version are unchanged.
- Recorded **Gen1Recomp 0.2.14 exact-runtime PASS** from 2.5.83: mod boot/load and DEV REPORT rendering succeeded.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2, engine range `>=0.1.86 <2.0.0`, and player-package file set remain unchanged.

# 2.5.83 — 2026-08-20

- Strict child of 2.5.82; documentation/compatibility-audit pass only.
- Advanced `recompCompatAudited` from 0.2.13 to **0.2.14** after reviewing the published tag delta.
- Gen1Recomp 0.2.14 is three commits ahead of 0.2.13 and changes only Android release packaging and iOS app-repository metadata; no Nuzlocke-facing Runtime/Loader/Mod API/GameVersion/Gen 2 VM/world contract changed.
- Retained Mod API 2, Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, and engine range `>=0.1.86 <2.0.0`.
- No gameplay hooks, rule behavior, Random Starter path, save migration logic, compatibility providers, or modularization boundaries changed.
- Carried forward 2.5.82 runtime PASS for normal boot and DEV REPORT rendering. A focused 0.2.14 boot smoke test remains required before marking the new audited engine exact-runtime PASS.

# 2.5.82 — 2026-08-20

- Strict child of 2.5.81 (`3d8cfaa0acaab7d55efd8324ef82f23f091a1f264f69ec7418dbc36bc9ac6fdf`).
- Extracted the 1,380-line Public Interop / Capability API block to new package-local `public_interop.lua`.
- Injected live current-game/current-save getters plus existing rule/area/delegation dependencies to preserve lifecycle semantics.
- Public provider, content, item, encounter, storage, EXP, registry, and auto-compat surfaces remain unchanged.
- `main.lua`: 37,138 -> 35,772 lines.
- Protected 2.5.81 runtime PASS: Setup/rule catalog still appears normal.
- Runtime test required for 2.5.82 boot and MOD COMPAT/provider smoke testing.

# 2.5.81 — 2026-08-20

- Strict child of 2.5.80 (`e6619127b579659a46221d1c7961a3e95dcbb0d3ba1b88a6f884e1c1943f8d0b`).
- Extracted the rule/settings catalog into new package-local `rule_catalog.lua`.
- Preserved canonical legendary/mythical/pseudo fallback sets, Stat EXP labels/values, Trainer Money labels, Maximum BST presets/helpers, rule keys/defaults/descriptions, and all existing consumers.
- Reduced `main.lua` from 37,417 to 37,138 lines (about 56 KB of catalog source moved out).
- Protected 2.5.80 Gold runtime PASS: mod boot/load succeeded on Gen1Recomp 0.2.13; Elm Random Starter portrait and awarded randomized starter worked.
- Silver Random Starter remains independently runtime-test-required.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` are unchanged.

# 2.5.80

- Repaired the Gen1Recomp 0.2.13 Mod Manager boot regression introduced by the first Release Safety gate: package/source introspection failures are warnings rather than fatal runtime assertions.
- Advanced the audited Gen1Recomp source marker to 0.2.13 while retaining Mod API 2 and the existing supported engine range.
- Began approved entry-file modularization with dedicated Run History, Release Safety, Dev assertion, and migration shadow-store modules.
- Added `stadium_provenance.lua` and the cooperative `nuzlocke_acquisition_provenance` API for `STADIUM PRIZE` metadata with optional Stadium 1/2 origin.
- Preserved 2.5.79's Johto Random Starter preview repair unchanged for runtime testing.

# 2.5.79 — 2026-08-20

## Johto Random Starter native preview repair

- Strict child of 2.5.78 (`3a0eb828e61ed37d772bd4d1d16e4b2d8a78999b07b93579a86203f70594c64e`).
- Preserved the existing deterministic Elm starter slate and working Gen 2 award transaction.
- Added a native `showPic`/`cry` fallback that can resolve Elm's randomized starter directly from the live Gen 2 game, Elm Lab map, empty-party state, and canonical starter species when the script-layer preview intent was not armed.
- The existing script-command intent remains the preferred path; generated script rows remain immutable.
- Added Dev health detail showing whether the latest Johto preview used `script_intent_*`, `native_fallback_*`, or vanilla presentation.
- R/B/Y Random Starter code is untouched. Blue 2.5.71 preview runtime PASS remains protected.
- Gold and Silver preview portrait/cry == awarded species remain **RUNTIME TEST REQUIRED** on 2.5.79.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2 and engine range `>=0.1.86 <2.0.0` are unchanged.

# 2.5.78 — 2026-08-20

## Save/migration integrity foundation

- Strict child of 2.5.77 (`0b222d009943f8ec0d11752242703163a2bc8d2aafdd013395531569bb6a0084`).
- Kept Save Schema 4 and all current rule semantics unchanged.
- Refactored numbered schema migrators to accept an explicit save-like store, allowing the same migration code to run against a shadow save before live mutation.
- Added deterministic dry-run planning through `previewPendingSchemaMigrations()`; dry-run reads/writes remain in memory and do not alter the live save.
- Added a versioned `__nuzlocke_schema_migration_txn` write-ahead journal recording each touched key's pre/post state.
- Live schema transitions now commit ordinary writes first, migration checkpoint second, and schema marker last.
- Added interrupted-transaction recovery: pre-commit interruption rolls back recorded values; post-schema-marker interruption completes cleanup rather than undoing a committed migration.
- Added a verified, bounded three-deep whole-save pre-migration snapshot rotation using Gen1Recomp's authoritative save filename/persistence filesystem; engine `.bak`/`.tmp` recovery files are left untouched.
- Failed live writes perform best-effort rollback and preserve the journal if rollback itself cannot complete.
- A migration/recovery failure now enters a distinct `migration_error` persistence pause: Nuzlocke-owned writes and rule enforcement stop until recovery succeeds, instead of continuing on uncertain state.
- Added `saveUpgrade.status()` plus structural save-migration integrity coverage in `releaseSafetyAudit()`.
- Save Schema descriptor now documents the optional migration-transaction bookkeeping field.
- Semantic/reconstruction/projection upgrade phases remain ordered but are not yet transactional; automated snapshot restore UI remains future work.
- Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2 and engine range `>=0.1.86 <2.0.0` are unchanged.

# 2.5.77 — 2026-08-20

## Release Safety Framework automation

- Strict child of 2.5.76 (`c0e62f8a71559ba4fa7d11de737fd8496d40f26175d5aa78f80e30da82310e7f`).
- Added a single machine-readable `releaseSafetyAudit()` aggregator over existing protected static contracts.
- Added `assertReleaseSafety()` and a boot-time release-safety gate so encoded invariant regressions fail fast instead of relying on manual review alone.
- Added Dev self-test visibility for aggregate release-safety PASS/WARN state.
- Initial automated coverage includes rule defaults/registry, Save Schema descriptor, dead-fallback lint, catalog snapshot, cross-table invariants, trainer-reward active guards, build provenance, Compatibility API capability-version coverage, and package-local source presence.
- The new gate is deliberately static/read-only and does not claim runtime gameplay confidence.
- No intended gameplay-rule, save-schema, randomizer, Run History, or compatibility-adapter behavior change.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2 and engine range `>=0.1.86 <2.0.0` are unchanged.

# 2.5.76 — 2026-08-20

- Strict child of 2.5.75 (`61f359114824ce117414ce330c0f9716883951b575b65eab81f47a477cf41283`).
- General stability improvements.
- No intended gameplay, rule, hook, save, randomizer, Run History, compatibility-adapter, or custom-screen behavior change.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2 and engine range `>=0.1.86 <2.0.0` are unchanged.

# 2.5.75 — 2026-08-20

- Strict child of 2.5.74 (`8a7bc811fb99f8cc2fadb4484c823c17ce82d5b1ef1d95ba6ce775e4a9cc7435`).
- Gold/Silver Random Starter preview parity remained open; this build did not claim a repair.
- Run History v1 producer runtime validation remained open.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Run History API 1, Mod API 2 and engine range `>=0.1.86 <2.0.0` were unchanged.

# 2.5.74 — 2026-08-20

- Strict child of 2.5.73.
- Recorded Blue 2.5.71 Random Starter pre-selection portraits as runtime PASS.
- Recorded Silver 2.5.73 Random Starter as **randomized award PASS / pre-selection portrait FAIL**; Gold/Silver native preview ownership remained an open defect.
- Run History v1 remained static/harness PASS only pending exact-edition catch/death/F. TOKEN producer runtime evidence.
- Stable Gen1Recomp audit remained 0.2.12; Save Schema 4, Compatibility API 28, Diagnostics API 1 and engine range `>=0.1.86 <2.0.0` were unchanged.

# 2.5.73 — 2026-08-20

## Run History v1 architectural foundation + Gen1Recomp 0.2.12 audit

- Strict child of 2.5.72.
- Adds `run_history_v1`, a bounded append-only chronology journal kept separate from `tracker_log` and legacy `nuzlocke_history`; those existing structures retain their encounter/death projection responsibilities.
- Journal rows are flat scalar records with monotonic sequence IDs, exact edition, generation, build provenance and optional dedupe keys. Up to 512 recent rows are retained while lifetime summary counters remain cumulative. Fresh saves initialize full-coverage; already-progressed upgraded saves are marked partial and preserve baseline catch/death counters without fabricating old chronology.
- Wires the established catch transaction paths (ordinary/gift/starter/progression catches), R/B/Y + Gold/Silver Permadeath transaction paths, and F. TOKEN area-reopen/revive use into the journal.
- Catch dedupe uses persistent Pokémon identity. Deaths intentionally remain repeatable so a forgiven/revived Pokémon can later die again and create a second legitimate event.
- Adds `mod.exports.nuzlocke_run_history` API 1 with `list`, `report`, `record`, stable event-kind declarations and `nuzlocke.run_history` post-commit observation event. This is the shared backend planned for Graveyard, Almanac/Run Recap, Confessional, meta-run tracking and companion integrations.
- Adds Run History Dev integrity assertions for version, event cap, monotonic sequence ordering, scalar-only persistence, dedupe uniqueness, lifetime-counter shape and `next_seq` advancement.
- Does not add a player-facing Run History screen yet and does not replace/migrate the existing Tracker or legacy history. Save Schema remains 4.
- Advances `recompCompatAudited` to Gen1Recomp **0.2.12** after reviewing the 15-commit 0.2.11→0.2.12 delta. No Runtime/Loader/Gen 2 VM/GameVersion/mod-API signature change requires adapter work; engine range remains `>=0.1.86 <2.0.0`.
- Preserves 2.5.72 Gold/Silver Random Starter native-preview repair unchanged; runtime verification of that repair remains required.

# 2.5.72 — 2026-08-20

## Gold/Silver Random Starter native preview ownership repair

- Strict child of 2.5.71.
- Gold 2.5.71 runtime evidence showed the actual awarded starter remained genuinely randomized, but Elm's three pre-selection Poké Ball pictures still displayed the vanilla Johto starters. Record 2.5.71 as **RUNTIME PASS for non-vanilla award / RUNTIME FAIL for native preview presentation**.
- Moves Gen 2 starter preview substitution to the actual Gen1Recomp 0.2.11 VM presentation owners: the copied per-VM `hooks.showPic` and `hooks.cry` callbacks. The `script.command` layer now only detects the exact Elm `pokepic`/`cry` context and arms a one-command private presentation intent; generated script rows remain untouched.
- The native `showPic` acknowledgement records which randomized species was actually presented. The selected Elm `givepoke` transaction prefers that acknowledged species, preserving the 2.5.70 pool repair and 2.5.71 private award transaction without a second randomizer decision.
- Tightens `opening_starter_preview_award_parity`: an intended preview can no longer produce a false PASS. After a committed randomized starter, the check requires a native-render acknowledgement and exact preview == award identity.
- Preserves deterministic three-ball slate/seed/style behavior, challenge filters, native GivePoke construction/nickname flow, and vanilla Ball/rival story ownership.
- Runtime TEST REQUIRED on Gold and Silver: each Elm Ball picture/cry should match its randomized candidate; select a non-vanilla preview and verify the received Pokémon matches exactly.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, NZR6 and engine range remain unchanged.

# 2.5.71 — 2026-08-20

## Gold/Silver Random Starter preview-to-award synchronization repair

- Strict child of 2.5.70.
- Records Gold 2.5.70 runtime evidence: the candidate-pool repair worked (a non-vanilla Smoochum was actually awarded), but the selected Ball preview showed Cyndaquil. Actual randomization therefore works while preview -> award identity remained a runtime FAIL.
- Root cause: Elm preview and final `givepoke` could resolve the same deterministic slate through different `mod.save` backings during early NEW GAME adoption, allowing the grant-side lookup to rebuild a different slate after the player had already seen the preview.
- Each Gen 2 VM now remembers the exact displayed randomized species per vanilla Elm Ball in private transaction state. The matching `givepoke` consumes that recorded choice; an armed preview intent is never rerolled at the native grant seam.
- Adds Dev self-test row `opening_starter_preview_award_parity`, backed by the selected preview and actual committed award, so a future mismatch is reportable instead of silently hidden by the final commit.
- Keeps 2.5.70's generation-correct Gen 2 candidate validation, deterministic slate, Starter Style/seed behavior, native GivePoke ownership, story/rival Ball branch, nickname flow, challenge filters and no shared generated-script mutation.
- Runtime TEST REQUIRED on Gold and Silver: preview a non-vanilla species, select that exact Ball, and verify the received Pokemon matches the preview. Fixed seed + unchanged settings must reproduce the same three-ball slate.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, NZR6 and engine range remain unchanged.

# 2.5.70 — 2026-08-20

## Gold/Silver Random Starter candidate-pool parity repair

- Strict child of 2.5.69.
- Gold 2.5.69 runtime evidence showed all three Elm choices remained the vanilla Johto trio despite Random Starter being ON.
- Historical comparison found the older working Gold candidate pool accepted the live Gen 2 registry, while the modern safety gate accidentally required Gen 1-only `level1Moves`/`learnset` fields.
- Gen 2 candidate validation now follows Gen1Recomp 0.2.11's `src.battle.gen2.Mon` contract (`baseStats`, `growthRate`, `types`, `levelMoves`) while R/B/Y retain the Gen 1 safety path.
- Gold 2.5.70 runtime proved actual non-vanilla substitution is restored (Smoochum awarded), but also exposed preview -> award desynchronization, which is repaired in 2.5.71.

# 2.5.69 — 2026-08-20

## Gold/Silver Random Starter grant-path repair

- Strict child of 2.5.68.
- Carries the exact live Gen 2 `ctx.game` from Elm's identified `givepoke` command into the private one-shot starter intent consumed by the `Vm.new` / `hooks.givePoke` transaction wrapper.
- The concrete grant no longer depends on rediscovering `currentGame` during early NEW GAME, where the global can still be nil/stale and silently leave the vanilla species operand unchanged.
- Keeps the selected vanilla Ball/story/rival branch intact; only the species index passed into native GivePoke is substituted. Native construction, held item, Pokedex mutation, nickname flow, provenance and tracking remain engine-owned/composed as before.
- Registers Silver explicitly with the same Johto starter trio so edition-aware starter provenance/diagnostics never fall back to Red.
- Runtime TEST REQUIRED on both Gold and Silver with Random Starter ON. A fixed seed should repeat the same result and the actual received Pokemon must match the randomized preview for the selected Elm Ball.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, NZR6, and engine range are unchanged.

# 2.5.68 — 2026-08-20

## NUZ STATUS content/organization cleanup

- Keeps the established R/B/Y ListMenu and Gen 2 status-screen renderer/input lifecycle unchanged; this child changes status-row content only.
- Removes NEW GAME/setup-only resource/loadout rows from NUZ STATUS, including Starting Money/Balls/Candy and PC setup kits.
- Removes Gym Guide Rare Candy/service-state leakage and the redundant master `Nuzlocke ON` row from the active-rule list.
- Replaces R/B/Y raw Type Locke slot rows (`Type 2/3/4/5/6`) with one player-facing Type Locke summary matching the Gen 2 presentation.
- Shows the selected non-vanilla Difficulty by name, hides neutral Trainer Money 100%, and uses short player-facing rule names for generic rows where available.
- Uses `Loadout <name>` consistently across R/B/Y and Gold/Silver.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, engine range, and exact-edition NZR6 diagnostics are unchanged.
- Runtime retest required for NUZ STATUS content/layout on at least Yellow and Silver; protected renderer/input/runtime evidence is not intentionally changed.

# 2.5.67 — 2026-08-20

## Exact-edition diagnostics/UI + Silver status scope repair

- Records Yellow 2.5.66 manual recovery reassignment (Mankey → Route 1 → wild) as runtime PASS.
- Fixes the Silver NUZ STATUS failure caused by stale post-scope calls to `normalizeMovementAssistMode`; all post-scope callers now use the exported movement-assist normalizer.
- Adds exact-edition diagnostic identity (`red`, `blue`, `yellow`, `gold`, `silver`, `crystal`) to breadcrumbs, snapshots and self-test reports instead of collapsing them to `rby`/`gold`.
- Introduces NZR6 report codes with a 3-bit exact-edition field. Decoder remains backward-compatible with NZR4/NZR5. This lets future parity/feature-implementation graphs bucket evidence by exact game edition while generation still drives shared mechanics.
- NUZ RULES/STATUS headers identify the exact running edition; Gold and Silver no longer share a misleading GOLD BETA label, and R/B/Y identify themselves individually.
- Save Schema 4, Compatibility API 28, engine range and game targets are unchanged.

# 2.5.66 — 2026-08-20

## Silver NUZ STATUS containment + Yellow recovery reassignment hardening

- Records Silver 2.5.65 NEW GAME Setup and boot-to-bedroom as runtime PASS; NUZ STATUS as runtime FAIL/crash.
- Exception-contains the shared Gen 2 NUZ STATUS screen so a Gold/Silver status calculation failure renders a reportable in-screen error and can return safely instead of terminating the launcher.
- Hardens manual Encounter Tracker recovery assignment transactionally: the selected area must canonicalize to a non-empty string before table access, the recovered row is built off-table, and optional live-Pokemon identity/provenance enrichment can no longer abort an otherwise valid player-confirmed assignment.
- No Save Schema, Compatibility API, Diagnostics API, engine range, or declared-game-target change.
- Runtime retest required for Silver NUZ STATUS and Yellow Mankey → Route 1 → wild reassignment.

# 2.5.65 — 2026-08-20

## Silver beta enablement / Gold-engine parity foundation

- Declares Pokémon Silver as a beta-supported target on Gen1Recomp 0.2.11.
- Treats Gold and Silver as one Gen 2 engine family for title Setup and generation-specific adapters; the historical `runtimeIsGold` export name is retained for compatibility but now resolves the engine generation directly.
- Gives Silver its own persisted pre-game Setup profile so changing Silver Setup does not overwrite Gold's staged profile.
- Promotes the existing Silver GSC progression profile from groundwork to experimental/beta use.
- Extends Gold-family starter/source handling to Silver.
- Uses Silver's native first player-name preset (`SILVER`) and counterpart Rival default (`GOLD`) where Nuzlocke's automatic-name / Quick Start features bypass the native prompts.
- Keeps R/B/Y-only Gym Guide and Center adapters out of both Gen 2 editions.
- Crystal remains undeclared groundwork; no Crystal support claim is made.

Runtime parity remains TEST REQUIRED across Silver new game Setup, existing-save gating, starter/gift/capture/death rules, nickname flow, marts/healing, progression, Random Starter, Quick Start/default names, rules/status/tracker screens, and Dev diagnostics.

# 2.5.64 — 2026-08-20

- Yellow: canonicalize and validate Encounter Tracker recovery/reassignment area IDs before any save-table write.
- Harden compatibility relationship/provider lookups against incomplete nil metadata.
- R/B/Y: wrap and center Dev/Recovery error/report presentation to stay within the 160x144 native frame.
- Record Yellow 2.5.63 Dev RUN + VIEW REPORT as runtime PASS and the fresh NZR5 report as valid runtime diagnostics evidence.
- No save-schema, compatibility-API, diagnostics-API, or engine-range change.

# 2.5.63 — 2026-08-20

- Strict child of 2.5.62.
- Fixes Yellow Dev RUN / VIEW REPORT runtime error `attempt to call global 'reportCodeHash' (a nil value)` by exposing the scoped NZR5 fingerprint operation through the Dev API and using that exported operation from `selfTestText()`.
- Hardens compatibility relationship/provider inspection against missing capability metadata; nil capability now resolves to neutral compose semantics instead of raising `table index is nil`. This targets the exact Encounter Tracker recovery runtime failure reported at the old line 1157.
- No Save Schema, Compatibility API, Diagnostics API, engine range, or declared game-target change. Gen1Recomp 0.2.11 remains the stable audited marker.
- Runtime confirmation remains required for the three affected Yellow paths.

# 2.5.62

- Fixed Dev Tools storage-facade calls to match Gen1Recomp's playthrough-bound `mod.storage` API. This is the common root fix for RUN + SAVE and VIEW REPORT failures seen in Yellow runtime testing.
- Dev RUN/REPORT failures now remain inside the Dev Tools screen with immediate A/B recovery and an `NZERR-2.5.62-xxxxx` code instead of pushing a modal TextBox that can appear frozen.
- Encounter Tracker recovery/reassignment validation and unexpected errors now use an in-screen notice with A/B recovery instead of pushing a TextBox from the maintenance editor. Invalid/impossible combinations remain no-op and player-facing.
- Source-audited Gen1Recomp 0.2.11. Mod API 2 and the `<2.0.0` engine ceiling remain appropriate. Silver is now an engine version but is not yet a declared Nuzlocke target pending a dedicated parity pass.

# Nuzlocke 2.5.61 — 2026-08-20

- Strict child of 2.5.60; multi-fix scope explicitly authorized after Yellow 2.5.59 runtime crash reports.
- Hardens the legacy Encounter Tracker recovery/editor: stale entries and impossible area assignments are rejected before mutation with player-facing feedback; unexpected update/draw exceptions are contained and surfaced as `NZERR-2.5.61-xxxxx` report codes.
- Hardens Dev Mode **RUN + SAVE**: unexpected self-test/export exceptions return a structured failure and player-facing report code rather than escaping through the Dev Tools screen.
- Adds a compact deterministic Dev runtime error-code helper and records full tracebacks through existing Dev diagnostics where available.
- Source-audits published Gen1Recomp 0.2.10 and advances the stable audited marker from 0.2.7 to 0.2.10. Mod API remains 2; engine range remains `>=0.1.86 <2.0.0`.
- Corrects 2.5.60's stale embedded provenance in the new child: 2.5.61 correctly declares 2.5.60 and its canonical SHA as its immediate parent. The old 2.5.60 artifact is not rewritten.
- Runtime confirmation remains required for both reported crash paths and for the 0.2.10 smoke test.

# Nuzlocke 2.5.60

2.5.60 is a strict child of 2.5.59 and completes the planned **Phase B catalog golden/snapshot backstop**.

This build adds a deterministic semantic snapshot of every `worldRuleCatalog` row. The audit sorts all 96 catalog keys and snapshots each key plus its T1, T2, Kanto, and Johto text, representing 576 tier/region resolutions. Missing rows/fields, renamed keys, or unintended dialogue changes now fail fast; comments and source formatting do not affect the snapshot. Dev assertions expose the same failure as `catalog_snapshot`.

No gameplay, save-schema, compatibility-API, diagnostics-API, UI, or engine-range behavior is intentionally changed.

## 2.5.59 — 2026-08-20

- Strict child of 2.5.58.
- Adds a fail-fast source-level lint for dead `worldRuleTriplet` / `worldRuleText` fallback arguments when the literal rule key already exists in `worldRuleCatalog`.
- Removes the existing unreachable fallback arguments for catalog-backed calls; because catalog text already won precedence, this is behavior-neutral cleanup.
- Mirrors lint failures into Dev assertions as `dead_fallback_lint`.
- Keeps Save Schema 4, Compatibility API 28, Diagnostics API 1, and the `>=0.1.86 <2.0.0` engine range unchanged.

## 2.5.58 — 2026-08-20

- Strict child of 2.5.57.
- Adds fail-fast cross-table invariant auditing for duplicated progression facts without changing gameplay behavior.
- Verifies GSC badge mappings point to real progression stages with the correct Johto/Kanto storage family and complete unique 1–8 badge-index coverage, while every R/B/Y profile has a gym-cap table with one cap per named Gym Leader.
- Mirrors invariant failures into Dev assertions as `cross_table_invariant` for diagnostic visibility.
- Keeps Save Schema 4, Compatibility API 28, Diagnostics API 1, and the `>=0.1.86 <2.0.0` engine range unchanged.

## 2.5.57 — 2026-08-20

- Phase B reliability hardening: added executable `active()`-guard contracts around the trainer-reward/progression subsystem.
- Gameplay-state mutators (`rememberWallet`, Trainer Money scaling, Gym Leader Forgiveness rewards) must retain the Nuzlocke enforcement guard.
- Intentional master-OFF persistence paths are explicitly classified instead of being silently treated as guard omissions: passive Gym/E4/Champion progression sync and Forgiveness Token inventory/save reconciliation.
- The trainer-reward module now fails installation if a contracted function disappears or loses its required guard; Dev assertions surface the same contract drift.
- No gameplay/UI/save-schema/API/engine-range changes.

## 2.5.56 — 2026-08-20

- **Phase B reliability / single-source rule registration, step 2.** Ordinary rule value coercion now derives from each authoritative `ruleCategories` record instead of maintaining independent numeric-key ladders in `getConfigValue()` and `setConfigValue()`.
- Numeric bounds, malformed-value fallbacks, and legacy boolean compatibility exceptions now live beside the rule default/range metadata they qualify.
- Preserves explicit non-ordinary semantics for Locke preset identity, legacy Level Cap migration, Area Guide state, external provider delegation, and dynamic difficulty-provider selection.
- Static parity harness matched 2.5.55 coercion semantics for all 40 numeric rules across 1,600 representative read/write cases.
- No intended gameplay/UI behavior, Save Schema 4, Compatibility API 28, Diagnostics API 1, engine range, NUZ STATUS behavior, or Gold Random Starter behavior changes.

## 2.5.55 — 2026-08-20

- **Phase B reliability foundation / single-source rule registration, step 1.** All 114 ordinary rule records now carry their canonical default directly beside their existing key/UI/range/generation metadata.
- `defaultRuleValue()` now resolves ordinary defaults from those authoritative rule records instead of maintaining a separate handwritten dispatch tree. Only non-row profile metadata (`locke_type`, Rule Lock mirrors) remains explicit.
- The existing machine-readable Rule Registry consumes the same records, so UI registration, default resolution, and descriptor tooling can no longer disagree merely because a default was added to only one path.
- No gameplay rule semantics, Save Schema 4, Compatibility API 28, Diagnostics API 1, engine range, protected F. TOKEN behavior, NUZ STATUS content, or Gold Random Starter logic intentionally changes.
- Static release gate: exact packaged Lua compile/load PASS; 41-extra-local sentinel PASS; 42-extra-local sentinel expected FAIL; 114/114 ordinary rule rows have explicit defaults.

## 2.5.54 — 2026-08-20

- Strict child of 2.5.53 (`c636576f001b9567403f95a9455c646fd1bb5577e66a9c729820b0af7f84af4b`).
- Behavior-preserving compiler-budget refactor only: scoped NZR5 codec helpers, town/loadout/movement/Gym Guide/reconciliation helper lifetimes, removed an unnecessary `effectiveToggle` outer alias, and moved low-fanout helpers behind one private helper namespace.
- Exact `main.lua` compile/load check passes. A 41-extra-local sentinel compiles and a 42-extra-local sentinel fails, measuring the legacy outer function at 159 active locals and restoring compliance with the `<160` Lua local-variable limit.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, gameplay behavior, NZR5 format, NUZ STATUS behavior, F. TOKEN behavior, and Gold Random Starter behavior are unchanged.

## 2.5.53

- Rebuilt directly from valid 2.5.51; rejected 2.5.52 is not a lineage parent.
- Dev Report codes now emit `NZR5`.
- Removed duplicate encoded health bits for hook health, lifecycle callbacks, safe-stop writes, rule effectiveness, and randomizer integrity; decode reconstructs them from the already-encoded authoritative counters/status.
- Legacy `NZR4` codes remain decodable and can still report internal inconsistency.
- No gameplay, NUZ STATUS, F. TOKEN, or Gold Random Starter behavior changes.

## 2.5.51

- Fixed one issue only: Gold Random Starter transaction identification.
- Preserved the transaction-safe `Vm.new` / `hooks.givePoke` grant path and deterministic three-ball slate.
- The exact Elm `givepoke` command now arms a private one-shot intent for that VM, allowing the native grant wrapper to substitute the selected randomized species even when save/party timing or another composed hook makes the old heuristic unreliable.
- The intent is consumed by one `givepoke` transaction and explicitly cleared if a lower hook swallows the command, preventing leakage into later gifts.
- Shared generated script rows remain unmodified; native Gold construction, nickname flow, story/rival branch, provenance, and tracking remain in place.
- Dev Report/NZR4 consistency work is intentionally deferred to the next build.
- Gold runtime validation required.

## 2.5.50

- **F. TOKEN area picker:** REROLL ENCOUNTER now lists any eligible FAILED encounter area from the authoritative tracker/projection state instead of requiring the player to stand in that area.
- **Tracker reroll action:** the selected FAILED row in ENC TRACKER exposes `A:REROLL` when Route Forgiveness is active and at least one F. TOKEN is owned; the same confirmation/spend function is used by both entry points.
- **Explicit spend confirmation:** the confirmation page names the target area, begins with no YES/NO selection, ignores A until the player deliberately chooses, and B cancels without spending.
- Preserves the Yellow 2.5.49 runtime-PASS reroll mechanics and post-reroll catch attribution.
- Audited the `DUPE:FREE` battle badge: it belongs to the independent Encounter Indicator feature, not the retired F. TOKEN implementation, so no legacy F. TOKEN battle hook was removed.
- Strict child of 2.5.49. Parent package SHA-256: `5bdefcb4c707504830a438b4fe0ae05856625216ab1ea84ddbc5c8d1120e59e5`.

## 2.5.49

- **F. TOKEN native selection cursor:** R/B/Y spend and revive selectors now use the engine's native `Theme.cursor` glyph via `Font.drawCode`, matching the already-working Nuzlocke list/menu pages. Up/Down selection mechanics are unchanged; the active row is now visibly marked with the native sideways arrow.
- Preserves the runtime-confirmed 2.5.48 full-page F. TOKEN layout and does not change forgiveness spending/revival mechanics. Gold keeps its native Chrome cursor path.

## 2.5.48

- **R/B/Y F. TOKEN full-page UI repair:** replaced the broken pixel-style `Font.drawBox(8,10,18,15)` / revive equivalent with the same full 20x18 tile-page pattern already used by runtime-confirmed Nuzlocke screens. The prior coordinates were tile coordinates, which is why the selector rendered in the lower-right.
- **Gym Guide Rare Candy dialogue pacing:** Nuzlocke-added Yellow/R/B/Y Gym Guide messages now contain explicit page breaks and remain blocking through `Commands.show_text`; the quantity selector cannot open until the dialogue pages are acknowledged with A/B.
- Gold F. TOKEN Chrome rendering and unrelated runtime-PASS rule gates are unchanged.

## 2.5.47
- Strict child of 2.5.46. Parent package SHA-256: `4c007d86566709fcf990e09787a8c16c31c7f06b31e86f62b033c5042d038223`.
- Fixes the runtime-confirmed R/B/Y / Yellow F. TOKEN presentation failure by closing the live Bag/use list before the custom forgiveness selector takes over the screen. This matches vanilla full-screen field-item transitions and prevents the native USE POKEMON/item UI from remaining composited underneath.
- Registers both F. TOKEN screens in Nuzlocke's shared presentation contract and attaches `nuzlockeUi` metadata, instead of relying only on ad-hoc classic-layout flags.
- Gold keeps its separate Pack/Chrome route unchanged. Save Schema, Compatibility API, Diagnostics API, engine range, and package file set are unchanged.

## 2.5.46

- Fixed the runtime-confirmed Gold Dev Mode visibility failure. Turning Dev Mode ON/OFF in NUZ RULES now refreshes the already-open underlying Gold START menu immediately instead of waiting for a later menu reconstruction.
- Dev diagnostics now read `dev_mode` through the same live configuration accessor used by NUZ RULES, with the direct save read retained only as a defensive fallback.
- The Gold START-menu refresh owns only Nuzlocke's marked DEV row; native and other-mod rows are preserved, and the normal `ui.start_menu.items` hook remains authoritative on later menu openings.
- Runtime Gold validation required: ON -> DEV appears immediately, OFF -> DEV disappears immediately, reopen persistence, save/reload persistence, and no duplicate DEV rows.

## 2.5.45
- Fixes the runtime-confirmed R/B/Y F. TOKEN menu corruption/overlap by giving both forgiveness screens the same protected native 160x144 classic-layout ownership used by stabilized Nuzlocke screens.
- Adds explicit screen identity/presentation ownership metadata for the F. TOKEN action and revival selectors so wide/modern UI integrations cannot resize or partially composite them over the native item-use screen.
- Gold keeps its separate native Gen 2 Chrome rendering path. No F. TOKEN mechanics, Save Schema, Compatibility API, Diagnostics API, engine range, or package-file-set changes.

## 2.5.44

- Strict child of 2.5.43. Parent package SHA-256: `f64d044ad904e682ba05d9439e35200e4bbba2cfb5cef1d3f3137756ae0a0eb6`.
- Hardens NZR4 so redundant result bits for hook health, lifecycle callbacks, safe-stop writes, rule effectiveness, and randomizer integrity are derived from the same structured evidence encoded later in the payload; internally contradictory new codes are no longer emitted.
- `decode_report_code()` now returns `consistent` and per-section `consistency` flags, allowing legacy/copied contradictory NZR4 values to be identified explicitly.
- Rebalances on-screen NZR4 hyphen groups across Dev Report rows so the final checksum fragment is not orphaned on its own line.
- Repairs embedded build provenance to point to the actual immediate parent 2.5.43 and its exact SHA-256 rather than the stale 2.5.41 metadata inherited through 2.5.42/2.5.43.
- NZR4 bit layout/prefix, Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, and 15-file package structure are unchanged. Runtime Dev Report layout confirmation required.

## 2.5.43

- Strict child of 2.5.42.
- Fixes the 2.5.42 Gold battle-rule pager so it never clears `BattleState.queue` and never calls `advanceQueue()` for a Nuzlocke-owned overlay message.
- Snapshots/restores the exact pre-dialogue `phase`, `message`, and `messageTimer`, preserving queued vanilla and compatibility-mod actions/messages.
- Adds defensive active-game/mod input fallback without auto-advancing Nuzlocke text.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, and 15-file package structure remain unchanged. Runtime validation required.

## 2.5.42

- Strict child of 2.5.41.
- Establishes the gameplay-text UX rule that Nuzlocke-authored interruptions/denials must remain until A/B and multi-page text must require A/B between pages.
- Gold battle-rule denials now use a Nuzlocke-owned 18-column/two-line paginator rather than direct `self.message` + `messageTimer` assumptions. Covers blocked battle items, No Catching, illegal catch/encounter refusals, and Encounter Ball Limit exhaustion.
- R/B/Y blocking `TextBox` and battle queue pagination paths are preserved.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, and 15-file package structure remain unchanged. Runtime validation required.

## 2.5.41

- Strict child of 2.5.40. Parent package SHA-256: `dcd4f5593c265f5b3a77432e26bd19b7f167feafbb4b2a054437812f60336ecd`.
- Adopts numeric-only build/release titles: no DEV or RC suffixes from this version forward.
- Fixes F. TOKEN revival when a compatible system retains a dead Pokemon in an active party that is now above a lowered Party Size Limit: revival relocates that Pokemon to legal PC storage before reactivation, or refuses without spending if storage is full/unavailable.
- Hardens Trade Evolutions to Gen1Recomp's supported `evolution.check` contract: the level-40 QoL path and Gold competing-branch suppression now require `trigger.kind == "levelup"` and do not act on link/item/forced/other contexts.
- Clarifies Route Forgiveness + Area Splits semantics: spending a token forgives the current logical encounter slot as configured; all FAILED physical rows merged into that slot are cleared deliberately so split reprojection cannot recreate the failure.
- Synchronizes README/CHANGELOG/RELEASE_NOTES and current documentation with the 2.5.40 F. TOKEN rework and 2.5.41 repairs.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, engine range, and 15-file package structure remain unchanged. Runtime validation required.

## 2.5.40

- Reworked Route Forgiveness into a real player-carried F. TOKEN item rather than synthetic Mart stock/automatic spending.
- F. TOKEN can manually reopen the current FAILED encounter slot or revive an exact Permadeath archive snapshot at half HP with party/PC-safe placement.
- Tokens cannot be bought, sold, tossed, or given; legacy unspent token counts migrate to inventory-backed state.
- Exact revival is available only for deaths with a full archived Pokemon record; older summary-only history is not fabricated.
- Runtime validation required.

## 2.5.39+DEV

- Strict child of 2.5.38+DEV. Parent package SHA-256: `341319ab54d9c4a1ed288090c76d81725989e8a4873b0539a7133daca329fed3`.
- Adds **Trade Evolutions** under QOL, default OFF, for Red/Blue/Yellow and Gold.
- With Trade Evolutions ON, ordinary trade evolutions become eligible on the next level-up at **level 40+**. Native link trades remain valid and can still evolve at their original timing.
- Gold trade-with-held-item evolutions require the original held item at level 40+ and consume it on successful evolution. While that branch item is held, a competing native level evolution is suppressed so branches such as **Slowpoke -> Slowking** remain reachable; removing the item restores the native branch immediately. Everstone remains authoritative.
- The shared evolution-limit hook is hardened for Gold's hook payload/data shape and Gold's `into` evolution target field so **Evolution Limits** compose with the new QoL instead of silently failing open on Gold. NO FINAL / NO EVOLUTION remain challenge-owned and can still block the QoL evolution.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` unchanged. Runtime R/B/Y + Gold evolution validation required.

## 2.5.37-DEV

- Strict child of 2.5.36-DEV. Parent package SHA-256: `730f87424f8a4ebf926b6b570730a696394bed6ba2c42adc0453834972c5307b`.
- Bug-only repair pass; no new gameplay features.
- **Random Field Items:** fixes HM protection to recognize Gen1Recomp's canonical `HM_<MOVE>` ids and `machine.kind = HM` metadata. Gold's visible **HM07 WATERFALL** Ice Path pickup and all other HMs now stay authored/vanilla and are excluded from the replacement pool.
- **Gold sparse PC storage:** replaces dense `ipairs(save.boxes)` assumptions with one stable sparse-safe box traversal across Whiteout recovery, PC-Only Catch detection, legacy/provenance reconstruction, and gift/starter ownership scans. A legal reserve in a later materialized Gold box can no longer be skipped because an earlier box table is absent.
- **PC-Only Catches:** remembers the legal pre-throw filing target and uses post-catch storage policy when a catch grows the party from 5 to 6. A full current Gold box no longer strands a permanent PC-only catch in the active party when another box has room; the permanent lock marker is applied only after the mon is confirmed in storage.
- **Rule Lock:** Gold **Radio Nuzlocke** remains adjustable with the other World Building/QoL/presentation controls while challenge rules are locked.
- **Loadout text:** SOLO now describes its actual `Whiteout OFF` behavior as **run-ending Blackout** instead of the stale “Whiteout” wording.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` unchanged. Gold HM pickup, sparse-box Whiteout, PC-only 5->6 filing, Radio Nuzlocke Rule Lock, and SOLO description are runtime TEST REQUIRED.

## 2.5.36-DEV

- Strict child of 2.5.35-DEV. Parent package SHA-256: `f8540105bf2fc481aded340003df29b7c0adfd18311c8bcfd0b51bcc7750bcbf`.
- General stability improvements; no gameplay behavior changes.
- Re-audited current Gen1Recomp `dev` head **`def270f7c726ebd7bd87086ad90bc4a7b9622543`** while retaining **0.2.7** as the stable published `recompCompatAudited` marker. Mod API 2, engine save format 4, ROM cache v5, and Nuzlocke's `>=0.1.86 <2.0.0` engine range remain valid.
- Confirmed Gold's official read-only BattleAPI now exposes Ball inventory and exact stock catch previews; Nuzlocke's existing optional BattleAPI bridge consumes the addition without changing capture enforcement ownership.
- Confirmed Gold battle-party grid navigation now uses the shared `ui.party.grid_navigation` hook; Nuzlocke continues to leave that presentation/input seam unowned.
- Reviewed Android in-process game switching: upstream resets Runtime hook/event buses before booting another game. Nuzlocke owner-aware wrappers are source-consistent, but Red/Yellow -> launcher -> Gold -> launcher -> Red/Yellow remains runtime TEST REQUIRED.
- Corrected stale compatibility text that still called 0.2.1 the current audited engine. Historical 0.2.1 notes remain intact as history.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, and Mod API 2 unchanged.

## 2.5.35-DEV

- Strict child of 2.5.34-DEV. Parent package SHA-256: `d5cb2b305cdcf460b5ff7f4110185719742caa5360d21994fe943d2546d37d54`.
- Bug-only repair pass; no new gameplay features.
- Gold Random Starter: stops the `script.command` gift tracker from mutating the VM's shared Elm `givepoke` command/operand tables. The 2.5.30 `Vm.new`/`hooks.givePoke` transaction wrapper is now the sole owner of concrete starter substitution.
- Gold Random Starter: fixes scoped three-ball slate cache identity. Species-id keys remain normalized, while opaque `GOLD_STARTER_SLATE:v1:s...:style...` keys retain their authored case; legacy uppercase scoped keys are canonicalized on read.
- QoL Rule Lock: Unlimited Bag Space now remains adjustable after challenge-rule locking, matching Running Shoes, Fast Surf, World Building, Difficulty, and the other QoL/presentation controls.
- Save Schema / Compatibility API / Diagnostics API unchanged. Runtime validation remains required for Gold Random Starter across repeated New Games in one process and for Rule Lock + Unlimited Bag Space.

## 2.5.34-DEV

- Strict child of 2.5.33-DEV. Parent package SHA-256: `9a6858e7c00207c65ec980edea5877c754224357ca33e059e50e7f7f49f3a45a`.
- Adds default-OFF **Unlimited Bag Space** under QoL for R/B/Y + Gold.
- R/B/Y removes the normal Bag's distinct-item slot ceiling while enabled. Gold expands only the ordinary ITEM and BALL pockets; KEY ITEM/TM-HM capacities remain native.
- Preserves the engine's 99-per-item stack cap, PC item storage, item legality/use rules, scripted acquisition behavior, ordering, tossing, and selling.
- OFF delegates to the live underlying `Bag.capacity` answer so engine changes or compatible bag-size providers are restored rather than replaced with a hard-coded vanilla value. Existing over-capacity contents are never deleted.
- Adds loader/session-safe `Bag.capacity` rebinding so the embedded Save Editor cannot leak its `mod.save` closure into gameplay.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and the canonical 15-file player package remain unchanged. Runtime R/B/Y + Gold capacity validation is required.

## 2.5.33-DEV

- Strict child of 2.5.32-DEV player package (parent SHA-256 `bc90a70fa72c723ea2053a6e493bfc45794e752fd0b4a625d1aff58c2a78066a`).
- Replaces the historical Running Shoes boolean with a three-state **OFF / HOLD B / ALWAYS** movement-assist selector. Existing saved ON values migrate to **HOLD B**, preserving their prior behavior.
- Adds **Fast Surf** with the same OFF / HOLD B / ALWAYS selector in R/B/Y and Gold. HOLD B/ALWAYS halve ordinary player-controlled Surf step duration while leaving Surf initiation, scripted movement, Waterfall, fishing, biking, and on-foot movement unchanged.
- Running Shoes and Fast Surf use the shared composable `movement.speed` hook. Running applies only off-bike/on-foot; Fast Surf applies only while the engine reports Surf state.
- QoL Toggles `run_hold_b` is now treated as a composable overlap rather than full ownership of the Nuzlocke control, so Nuzlocke's ALWAYS mode remains selectable and double-halving is avoided while B is already handled downstream.
- Adds one-time semantic migration marker `movement_assist_modes_2533`; Save Schema remains 4, Compatibility API remains 28, Diagnostics API remains 1, and Mod API remains 2.
- Source/static validation required; runtime TEST REQUIRED in R/B/Y and Gold for all three Running Shoes modes and all three Fast Surf modes.

## 2.5.32-DEV

- Strict child of 2.5.31-DEV player package (parent SHA-256 `88ae7a01af736a62d1d19fc04b81867a46afdd7f108df1ba2acedb028140f9f7`).
- Gold Random Starter now resolves Elm's three balls as one deterministic canonical slate rather than three independent seeded rolls.
- The slate avoids duplicate choices whenever another legal candidate exists while remaining preview-order independent.
- Added a dedicated `STARTER_SLATE` deterministic namespace/version so this repair does not reshuffle Random Encounters or Random Learnsets.
- Elm POKEPIC/CRY rewrites are now non-mutating: shared generated command/operand tables remain vanilla and only per-dispatch shallow copies carry the randomized species.
- The accepted starter is still committed only at the real GIVEPOKE transaction; starter nickname behavior was unchanged during build development.

## 2.5.31-DEV

- Strict child of 2.5.30-DEV player package (parent SHA-256 `b5554d30a04f7b3197d60f81adaeef577936f07afead8d90cac01ae15ae8a7bc`).
- Restores the earlier public **Whiteout / Blackout** meaning and adds the requested PC-reserve exhaustion check. **Whiteout ON** survives a total-party KO only when at least one usable Pokemon remains in the party or Box storage; **Whiteout OFF** is destructive Blackout and ends/deletes the run.
- A recovery reserve must be a real usable Pokemon. `nuzlockeDead` Pokemon, permanent **PC LOCKED** progression catches, and Eggs never count. With Permadeath OFF, the fainted active party still counts because native blackout recovery can heal it; with Permadeath ON, dead party members are pruned before the reserve decision.
- If Whiteout ON survives with an empty party and boxed reserves, the native loss/heal-point warp remains engine-owned and Nuzlocke prompts the player to withdraw a reserve from the PC. Gold receives a narrow Bill's-PC access repair so an empty-party survivor can actually open storage when an eligible boxed reserve exists. The normal empty-party PC refusal remains intact when no legal reserve exists.
- Battle wipes and overworld-poison wipes use the same reserve classifier in R/B/Y and Gold. First Rival Mercy remains an earlier exception and still suppresses death/Whiteout/Blackout consequences for the opening Rival battle only.
- Existing saves receive a one-time semantic migration (`whiteout_semantics_restored_2531`) that inverts the old stored boolean so their previously selected behavior is preserved under the corrected ON/OFF meaning. Fresh 2.5.31 saves stamp the marker at creation. Save Schema remains 4.
- HARDCORE, SOLO, and IRONMON loadouts continue to be run-ending on a total wipe; their stored preset value is changed to **Whiteout OFF / Blackout** to preserve that behavior under the restored semantics.
- Source/static validated; **R/B/Y + Gold runtime TEST REQUIRED** for Whiteout with a boxed reserve, Whiteout with no legal reserves, Blackout with a boxed reserve, First Rival Mercy, field-poison wipe, save/reload migration, and Gold empty-party Bill's-PC access.

## 2.5.30-DEV

- Strict child of 2.5.29-DEV player package (parent SHA-256 `89cb2e3fb88eab0cda083993f237973befaa6d89794b4b87e1bcca9aef1c85dc`).
- Repairs the runtime-confirmed inherited **Gold Random Starter** failure. Gold's Elm `givepoke` now has a second, transaction-level safety net at the Gen 2 VM `hooks.givePoke` seam, so the concrete starter species no longer depends solely on the earlier `script.command` operand rewrite.
- Preserves Elm's selected canonical Ball/story branch and rival-counterpick flags while replacing only the species operand passed into native GivePoke. Native construction, OT/Pokedex mutation, held-item handling, and nickname flow remain engine-owned.
- Hardens fresh-NEW-GAME Random Starter configuration across Gold's save-backing transition: if the immutable Setup snapshot is still authoritative, Random Starter copies only its toggle, Starter Style, and seed into the newly adopted mod.save bucket before the first Elm preview/grant. External starter-provider ownership still wins.
- Adds owner-aware `Vm.new` wrapper identity plus DEV SELF TEST health row `gold_random_starter_transaction_gate`, and revalidates Gold adapters on `save.created` as well as `game.ready`/`save.loaded`.
- Existing Gold starter nickname enforcement is intentionally unchanged. Save Schema remains 4, Compatibility API remains 28, Diagnostics API remains 1, Mod API remains 2, and the engine range remains `>=0.1.86 <2.0.0`.
- Runtime TEST REQUIRED: fresh Gold NEW GAME with Random Starter ON must receive a non-Chikorita/Cyndaquil/Totodile replacement for the selected vanilla starter (candidate pool excludes the original), retain the chosen Ball/story branch, and still enforce the starter nickname rule. Repeat a fixed seed to confirm determinism.

## 2.5.29-DEV

- Strict child of validated 2.5.28-DEV player package (parent SHA-256 `91004bee6be3725be9f3c25e285671a8757545ec435d863cdc1d1f325be694ef`).
- Gold now exposes **Ball Per Enc.** in Setup/NUZ RULES. The Gold battle-Pack counter/refusal mechanic already existed; this child closes the configuration-surface parity gap without changing its OFF / 1 / 2 / 3 / 5 / 10 semantics.
- Adds dedicated Gold-only NEW GAME resource controls instead of reusing the R/B/Y profile fields: **Starting Money** 0-999999 (default 3000), **Starting Rare Candy** 0-99 (default 0, bedroom PC), and **Starting Poke Balls** 0-99 (default 0).
- Gold Starting Poke Balls are an **extra PC allotment**, not a replacement for Gold's native 5-Ball story reward. They remain deferred until `EVENT_GAVE_MYSTERY_EGG_TO_ELM` is live, so Setup cannot arm the pre-Ball Route 29 opening early; Quick Nuzlocke Start still preserves the native 5-Ball milestone and then releases the configured extra PC allotment.
- Marks the historical R/B/Y `starting_*` rows explicitly R/B/Y-only in the machine-readable rule registry; Gold uses separate `gold_starting_*` keys and its native six-digit `player.money` field.
- Save Schema remains 4, Compatibility API remains 28, Diagnostics API remains 1, Mod API remains 2, and the supported engine range remains `>=0.1.86 <2.0.0`.
- Runtime TEST REQUIRED: Gold Ball Per Enc. selector/enforcement; Gold NEW GAME money/candy resources; normal-story and Quick Start extra-Ball release after Elm; 0/default values preserving native behavior; save/profile isolation from R/B/Y starting-resource choices.

## 2.5.28-DEV

- Added **PC-Only Catches**, a default-OFF progression/completion exception for otherwise Nuzlocke-illegal capture attempts in R/B/Y and Gold.
- Eligible exception catches keep the engine's real capture/Pokedex result but are immediately moved to Pokemon Box storage, marked `nuzlockePcLocked`, and treated as permanently unusable: native PC WITHDRAW, box-to-party MOVE, RELEASE, and the public Party/PC policy all refuse them.
- PC-only catches do **not** spend One Per Area/Failed Encounter state, do not enter the ordinary Encounter Tracker catch ledger, do not consume Type Locke draft lanes, and do not make a later legal encounter count as Dupes merely because the research-only Pokemon exists in storage.
- Ordinary **No Catching** remains absolute. It can be bypassed only when a compatible capture source explicitly declares both progression-required and progression-exception permission. Malformed/glitch safety is never bypassed, and Party Size Limit alone does not convert an otherwise legal catch into a permanent PC-only catch.
- The exception preflights Pokemon Box capacity before allowing the illegal capture; if all boxes are full, the throw is refused and the original Ball is not consumed by Nuzlocke's gate.
- Compatibility API remains 28. Cooperative acquisition results may now add `pcLock=true`, `permanent=true`, `consumeEncounter=false`, and `pcLockReason` on an explicitly progression-required exception; `PartyPC.evaluate` recognizes `progression_pc_lock` for incoming/release attempts.
- Save Schema remains 4, Diagnostics API remains 1, Mod API remains 2, and the supported engine range remains `>=0.1.86 <2.0.0`.
- Runtime TEST REQUIRED: R/B/Y + Gold illegal catch -> Box, no encounter spend, blocked withdraw/move/release, persistence after save/reload, full-box refusal, and ordinary No Catching remaining absolute.

## 2.5.27-DEV
- Strict child of validated 2.5.26-DEV player package (parent SHA-256 `e5549df2e46a4c8ab3a47f97790226c0c8c7b5911cc94b3883442674e5971d91`).
- Expands **Maximum BST** from OFF / 400 / 450 / 500 / 550 to **OFF / 300 / 350 / 400 / 450 / 500 / 550 / 600 / 650 / 700**.
- Keeps existing saved thresholds and the underlying catch/gift/trade enforcement semantics unchanged; legacy free-form values remain preserved until the player changes the control, then cycling begins from the nearest preset.
- The preset cycle now derives its size from one shared maximum-index constant instead of a hard-coded five-entry modulus, reducing future ladder-drift risk.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, randomizer behavior, loadout ownership, and engine range are unchanged.
- Runtime UI/rule test required in R/B/Y and Gold: cycle both directions across OFF/300 and 650/700 boundaries and confirm a cap actually blocks a species above the chosen threshold.

## 2.5.26-DEV
- Strict child of validated 2.5.25-DEV player package (parent SHA-256 `b85cdb96c03a4342b2c389c333b70ff8a6fdc4e527476fe7be7468bfbbd3fbba`).
- Rebalances the R/B/Y native NUZ INFO **STAT INFO** page: ATK/DEF/SPE/SPC value/DV/Stat EXP rows move left into unused label space and expand from the old 8-glyph marquee budget to 14 glyphs.
- Preserves the complete native worst-case stat string shape (`999 D15 E65535`) instead of pre-truncating STAT right-column values to the generic Catch-page budget. LEVEL/HP also gain width while keeping extra separation from their longer labels.
- Catch Info, Move Info, Gold NUZ INFO, gameplay rules, randomizer behavior, Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and the engine range are unchanged.
- Runtime visual test required on R/B/Y STAT INFO at ordinary and high Stat EXP values.

## 2.5.25-DEV
- Strict child of validated 2.5.24-DEV player package (parent SHA-256 `33dc2564cbfe63809ec39315ddc489d16a09443d4a2795b145d98a281ac2db39`).
- Adds **Random Field Items** (default OFF) for visible overworld item-ball pickups in R/B/Y and Gold. Ordinary visible pickup payloads are replaced only at collection time, leaving the engine's native bag-capacity, retry, disappearance/event-flag, text, and sound flows intact.
- Uses a dedicated deterministic `FIELD_ITEMS` RNG stream under the existing shared seed/algorithm version. Enabling field-item randomization therefore does not perturb Random Starter, Random Encounters, or Random Learnsets results for the same seed/settings.
- Progression-critical/key items and HMs are protected in place and excluded from the replacement pool. Hidden items, NPC gifts, shops, fruit/apricorn trees, and other scripted rewards are intentionally outside this first scope.
- Adds owner-aware R/B/Y `OverworldController.talkTo` and Gold `HiddenItems.ballPickupScript` lifecycle adapters plus Dev hook-health/self-test visibility.
- No loadout ownership, Save Schema, Compatibility API, Diagnostics API, Mod API, or engine-range change. Random Field Items is SOURCE/STATIC TEST REQUIRED and requires runtime pickup validation in R/B/Y and Gold.

## 2.5.24-DEV
- Strict child of validated 2.5.23-DEV player package (parent SHA-256 `a6466d34c23e44544846b5b716d4ff7870974ad4114d78e790b0b60bd69d179e`).
- NUZ RULES and NEW GAME Setup now remember the selected row and visible scroll anchor when the screen is closed and reopened during the same mod session.
- Navigation memory is isolated per surface (R/B/Y vs Gold and Setup vs active Rules) and uses semantic rule/header identities instead of raw list indices, so collapsed sections and dependent-row visibility cannot silently restore to an unrelated row.
- Navigation state is UI-only/session-only: it is not written to gameplay saves, setup profiles, or Save Schema 4 and naturally resets on a fresh process/mod reload.
- No rule/default/loadout/save representation changes. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` remain unchanged.
- Runtime test required: move deep into each Rules/Setup surface, close/reopen, and verify the same selected row/scroll window is restored; also smoke collapsed/dependent rows in R/B/Y and Gold.

## 2.5.23-DEV
- Strict child of validated 2.5.22-DEV player package (parent SHA-256 `f6124bb85e5e0d89bc3c181fddfb5ea1879c662f01a224eced3046ed5729ce95`).
- Repairs the runtime-confirmed 2.5.22 Random Starter regression: starter selection no longer reaches across a Lua lexical boundary for `Randomizer` / `seededIndex`; the owning randomizer phase exports the shared deterministic helper explicitly, preserving algorithm-v1 seeded results.
- Restores the R/B/Y `heal_party` / `Commands.resolve` / `give_pokemon` wrapper tail to the same installer scope that owns its captured locals. This restores No Mom Heal enforcement and the starter transaction/provenance path used to record R/B/Y starters under Pallet Town.
- Executes the staged late-runtime phase 2 instead of defining and discarding it. This restores the Yellow Oak Pallet catch-demo skip and the authoritative script-command healing fallback that were dormant in 2.5.22.
- Adds immediate and `save.created` lifecycle revalidation for the critical R/B/Y command/heal wrappers so a fresh NEW GAME is a first-class lifecycle boundary rather than relying only on `game.ready` / `save.loaded`.
- Adds a conservative repair for affected R/B/Y opening starters that were left with UNKNOWN/Oak-Lab tracker provenance, only when real starter flags or a committed random-starter choice identify the opening starter.
- Expands DEV SELF TEST with late-runtime phase-2, Oak-demo, R/B/Y starter-transaction, Random Starter, Skip Catch Demo, and No Mom Heal health/state rows.
- Strengthens local/CI regression gates for Lua lexical-scope mistakes, staged closure execution, installer-scope ownership, fresh-New-Game lifecycle coverage, and mutation tests that must fail if these exact regressions are reintroduced.
- No rule/default/loadout/save representation changes. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` remain unchanged.

## 2.5.22-DEV
- Strict child of validated 2.5.21-DEV player package (parent SHA-256 `89cbba7fa3daca0d4ef93992c8a0fe476be45c2f304bc39369649842060a8a77`).
- Lifecycle-hardens Gen 1 variable-width kerning on the persistent `src.render.Font` singleton with explicit session token / previous / wrapper identity instead of trusting predecessor markers from an older reload.
- Exact stale Nuzlocke kerning wrappers are safely unwrapped before rebinding; ambiguous legacy/foreign wrapper chains fail closed and require one fresh process rather than risking double kerning or deleting another mod's wrapper.
- Starter randomization now uses the shared versioned `seededIndex()` path and derives its semantic namespace from `Randomizer.algorithmVersion`, matching encounter and learnset randomization. Algorithm v1 preserves the exact existing starter hash input/results.
- Live RNG version labels derive from the shared algorithm-version source; historical changelog references to RNG v1 remain historical.
- Added local invariants for kerning reload ownership and randomizer algorithm-version synchronization.
- No rule/default/loadout/save representation changes. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` remain unchanged.

## 2.5.21-DEV
- Strict child of validated 2.5.20-DEV player package (parent SHA-256 `5e927a325ec9a3805b8d9e916687d5edd3efd9e656aebc4dfacae222c67fe693`).
- Centralized trainer identity normalization in `trainer_rewards.lua` so reward recognition and passive League progression use the same trainer ID/class/name evidence.
- Added Gen 1 `oppClass`, generic `trainerClass` / `opponentClass`, and Gold `trainer.classId` / `trainer.class` coverage to the shared identity extractor.
- R/B/Y Gym/E4/Champion and Gold stage progression now consume the shared identity matcher rather than rebuilding an id/name-only identity path.
- Added local invariant coverage that fails if reward/progression identity extraction drifts apart again.
- No rule/default/loadout/save representation changes. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` remain unchanged.

## 2.5.20-DEV
- Strict child of validated 2.5.19-DEV player package (parent SHA-256 `39dfe863d5cd893e45b6be753f254ffd2d1d2f99597c32a77ae00ccfffe35e49`).
- Separates Nuzlocke persistence safety (`canWriteNuzlockeSave`), master-switch state (`isNuzlockeEnabled`), and rule enforcement (`shouldEnforceNuzlocke`); historical/internal `active()` now explicitly aliases rule enforcement.
- Keeps Gym/E4/Champion progression synchronized on supported saves while Nuzlocke is temporarily OFF, but blocks all Nuzlocke-owned progression writes on unsupported newer schemas.
- Gates Failed Encounter, Forgiveness Token stock/purchase/spend/rewards, trainer-money rewriting, and post-battle Permadeath cleanup behind rule-enforcement policy.
- Adds defense-in-depth guards to `markEncounterFailed` and encounter-rule arming so unsupported newer schemas cannot mutate encounter bookkeeping through battle teardown.
- Extends local invariants with policy-aware PASSIVE_PROGRESS versus RULE_ENFORCEMENT checks instead of requiring a blanket `active()` guard on every battle writer.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` remain unchanged.

## 2.5.19-DEV
- Strict child of validated 2.5.18-DEV player package (parent SHA-256 `82b9b391928acbc7ee580ca9d3997d6f4f93fe35f2782dff3b4712f3340a7ac5`).
- Hard-stops R/B/Y and Gold randomized-starter repair on unsupported newer save schemas before save-backed table/Pokémon mutation.
- Makes Pokémon identity lookup read-only and blocks identity allocation/hydration while safe-stopped.
- Returns defensive Compatibility API engine reports and refreshes `engine_compat` after Item Policy state changes.
- Expands Save Schema 4 descriptor with migration-bookkeeping roles/counts.
- Lifecycle-hardens the final `mod.save:set` safe-stop wrapper and suppresses Permanent Rule Seal reconciliation while safe-stopped.
- Extends local invariants for these save-safety/API guarantees.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` remain unchanged.

## 2.5.18-DEV
- Strict child of the validated 2.5.17-DEV player package (parent SHA-256 `d9b075c3ba28c74537dcdd5b367a658c031bfb9f701e01e3b2eef062ea332ab9`).
- Defensive-copied public Compatibility API capabilities, engine/mod compatibility metadata, relationships, ownership, and legacy `mod.exports.owns` so consumer mutation cannot alter Nuzlocke's internal relationship resolver or ownership policy. Public dynamic mod-compat snapshots refresh after provider discovery; internal compatibility reports now return copies.
- Fixed `getEffectiveRuleValue()` so a missing key with no caller fallback uses `defaultRuleValue(key)`, matching `isRuleActive()` and enforcement semantics.
- Rule Registry construction now records duplicate-key collisions and exposes them through `describe()` / `audit()` instead of silently discarding them before audit.
- Save Schema 4 descriptor now explicitly documents `hardcore_mode` and `elite_four_caps` as compatibility mirrors of `level_cap_scope`, plus `solo_active`, `no_shopping`, `ball_use_ban_tier`, and `route_splits` as migration-only legacy inputs. No persisted representation changed.
- DEV SELF TEST now returns a defensive copy of capability contract versions.
- Updated local invariant tooling to validate defensive-copy/current-doc contracts and to flag only authoritative boolean-only wrapper guards; dormant historical compatibility markers no longer create misleading wrapper-debt warnings.
- Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and `>=0.1.86 <2.0.0` engine range are unchanged. Runtime testing remains required.

## 2.5.17-DEV
- Strict child of the validated 2.5.16-DEV package (parent SHA-256 `2c1f981139332064f25b2f46cf2f7fd4044e4f8283ef3dc156569f147fbbc435`).
- Added machine-readable build provenance so Dev Mode/CI can verify the exact immediate parent version/SHA, Save Schema, API versions, audited Gen1Recomp marker, and 15-file player-package contract.
- Added a derived Rule Registry descriptor and Save Schema 4 configuration descriptor. They are read-only views over the existing canonical rule/default paths and do not replace enforcement or migrate player data.
- Added a reusable owner-aware direct-method wrapper installer for lifecycle-safe wrappers; this centralizes exact `owner` / `previous` / `wrapper` handling without changing rule semantics.
- Added stronger Dev SELF TEST assertions for Rule Registry integrity, Save Schema descriptor integrity, build provenance, and compatibility capability-version coverage. Diagnostics API remains 1 because the existing diagnostics contract remains backwards compatible.
- **Compatibility API advances from 27 to 28** because `capability_versions` and `getCapabilityVersion(capability)` are a new public consumer-visible negotiation surface. All existing API-27 capability names/meanings remain compatible and begin at capability contract version 1; `compatible_from` remains 10.
- Save Schema remains 4, Mod API remains 2, Diagnostics API remains 1, and engine range remains `>=0.1.86 <2.0.0`. No gameplay rule/default/loadout/encounter behavior intentionally changes from 2.5.16.
- Repository CI/invariant tooling is development-only and remains outside the canonical 15-file player package.
- 2.5.17 is a source/static development-infrastructure child; runtime gameplay should match 2.5.16 and DEV TOOLS -> SELF TEST should be smoke-tested.

## 2.5.16-DEV
- Strict child of the validated 2.5.15-DEV package.
- Fixed the public `ruleActive()` compatibility helper so missing persisted keys use `defaultRuleValue(key)` instead of an unconditional false fallback. Existing Compatibility API 27 semantics now agree with Setup/NUZ RULES/enforcement for default-ON boolean rules without changing the API version or return shape.
- Replaced remaining historical CUSTOM/0 `locke_type` read/verification fallbacks with the canonical `defaultRuleValue("locke_type")` source. Explicit saved CUSTOM/NUZ/HARD/etc. choices remain authoritative.
- Tightened live-wrapper identity checks for R/B/Y/Gold automatic default names, Gold nickname enforcement, Gold Mart BUY/SELL enforcement, Gold Game Corner handlers, and the R/B/Y Permadeath bundle. Owner markers alone no longer prove that the recorded wrapper is still live.
- Hardened QoL Toggles AUTO-REPEL compatibility with an explicit live wrapper marker so No Repels cannot silently trust a stale owner marker after rebinding.
- Hardened Wilds of Kanto compatibility so both `_resolveCapture` and `giveCaughtPokemon` must match the recorded Nuzlocke session before the adapter is considered installed; stale exact wrappers are unwrapped independently before rebinding.
- Expanded Dev hook-health reporting across catch/finalize/nickname, field-poison, party-limit, Gold capture/nickname/Whiteout/Headbutt/Day Care, R/B/Y Permadeath, Gold Mart/gambling, QoL AUTO-REPEL, and Wilds capture seams. Diagnostics API 1 is unchanged because this is additive reporting within the existing health surface.
- Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` are unchanged.
- 2.5.16 is a source/static reliability/diagnostics repair; runtime re-test is required.

## 2.5.15-DEV
- Strict child of the validated 2.5.14-DEV package.
- Fixed field-poison Whiteout enforcement in both R/B/Y and Gold. Overworld poison wipes now end/delete the run when Whiteout is ON even if Permadeath is OFF; native poison-faint/blackout presentation is retained and only the final heal-point/spawn warp is intercepted.
- Fixed Gold No Escape: the shared `battle.run` hook now resolves the live game through `battle.game` when available and otherwise `currentGame/mod.game`, matching Gold's pure Battle payload which has no `game` field.
- Fixed new-game snapshot persistence for `locke_type`: the selected loadout is now written explicitly before verification, preventing stale loadout labels / repeated snapshot verification retries when all managed rules were otherwise committed correctly.
- Replaced boolean-only install ownership on the remaining high-value direct wrappers with owner/previous/wrapper session records: R/B/Y + Gold Party Size/PC withdrawal, Gold No Day Care, Gold battle Whiteout finish, Gold Headbutt tracking, and Gold forgiveness-token mart stock. Historical boolean fields remain non-authoritative compatibility markers.
- Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` are unchanged.
- 2.5.15 is a source/static reliability repair / R/B/Y + Gold runtime TEST REQUIRED.

## 2.5.14-DEV
- Strict child of the validated 2.5.13-DEV package.
- Fixed the R/B/Y scripted starter/gift context ordering bug: `nuzlockeGivePokemon()` now binds `ctx.save` before the Pallet/Oak/Lab fallback reads `save.player.map`, so randomized/compatibility starter transactions can use the intended save-backed location evidence instead of an accidental outer/global lookup.
- Completed a canonical-default consistency sweep for core encounter/acquisition enforcement. Missing persisted keys for One Per Area, Nickname Rule, Dupes Clause, Allow Gifts, and Allow Trades now fall back through `defaultRuleValue()` instead of historical inline OFF values. Existing explicit saved values remain authoritative and are not migrated or rewritten.
- Gold Pokégear World Building presentation now receives the same canonical rule-default resolver, removing its last missing-key T0 fallback while preserving explicit OFF/T1/T2/T3 saves.
- Replaced stale boolean-only ownership guards on the older R/B/Y catch wrappers (`throwBall`, catch-finalize `finish`, nickname UI), R/B/Y Permadeath/Whiteout wrappers, and Gold capture `useItem` wrapper with owner/previous/wrapper session metadata. A later ModLoader session can unwrap an exact stale Nuzlocke top-level wrapper and bind the current mod/save instead of silently trusting an old marker. Historical marker fields remain for compatibility but no longer own installation decisions.
- Reviewed Gen1Recomp 0.2.7 TimeFishGroups semantics and made no randomizer rewrite: the engine intentionally prefers row-local `day`/`nite` fishing slots and uses `timeFishGroups` only as fallback; forcing those structures to re-synchronize could overwrite a compatible mod's deliberate row-level override.
- Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` are unchanged.
- 2.5.14 is a source/static repair / R/B/Y + Gold runtime TEST REQUIRED.

## 2.5.13-DEV
- Strict child of the validated 2.5.12-DEV package.
- Fixed a source-confirmed Permadeath gap for overworld poison faints in both R/B/Y and Gold. These paths mutate HP outside the battle faint lifecycle, so battle-only death hooks could miss the loss.
- R/B/Y now observes the native `OverworldState:applyFieldPoison` result, records only Pokémon that crossed from usable HP to 0 HP under active Permadeath, then prunes those exact party objects after native poison handling returns.
- Gold now observes `World:poisonFaintScript` using the engine-provided fainted party indices, lets native poison-faint happiness/text queue first, then records/prunes those exact Pokémon before a later native `whiteOut()->healParty()` can revive them.
- Field-poison deaths use the existing `nuzlocke_history`, `nuzlocke_losses`, `last_loss`, identity, glitch-label, and tracker-death projection contracts with `deathStatusCondition = POISON` / field-death metadata.
- Nuzlocke OFF and Permadeath OFF remain vanilla. Native poison timing/SFX/text and native whiteout/heal/warp sequencing are not replaced. Whiteout Clause semantics are unchanged by this narrow repair.
- Added session-owner-aware field-poison wrappers so a reload can remove Nuzlocke's own stale wrapper instead of stacking duplicate bookkeeping.
- Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0` are unchanged.
- 2.5.13 is a source/static Permadeath repair / R/B/Y + Gold runtime TEST REQUIRED.

## 2.5.12-DEV
- Strict child of the validated 2.5.11-DEV package.
- Re-audited the published Gen1Recomp 0.2.7 release against Nuzlocke-owned and observed seams. Audio/device recovery, true-color/grass rendering, Gold title presentation, and related platform changes require no Nuzlocke ownership rewrite.
- Confirmed the 0.2.7 Gold encounter registry gained time-dependent fishing (`TimeFishGroups`) while retaining the shared `encounters` registry contract.
- Fixed Nuzlocke's public effective/final encounter-registry facade on Gold: it now exposes `game.data.gen2Encounters` (with `game.data.encounters` fallback) instead of returning only the Gen 1 alias.
- `Registry.describe()` now reports that same generation-correct live encounter table, keeping DexNav/guide/provider consumers aligned with the table gameplay actually uses.
- Random encounter table generation, OPEN/BLIND information policy, targeted-selection policy, provenance, save data, and reroll behavior are unchanged.
- Engine range remains `>=0.1.86 <2.0.0`; Mod API 2, Save Schema 4, Compatibility API 27, and Diagnostics API 1 are unchanged.
- 2.5.12 is a source/static compatibility repair / Gold runtime TEST REQUIRED.

## 2.5.11-DEV
- Strict child of the validated 2.5.10-DEV package.
- Completed the 2.5.4 World Building T3 -> T1 default migration: the live `worldTier()` resolver now falls back through canonical `defaultRuleValue("world_building_tier")` instead of hardcoding T3.
- Configuration-value fallback for `world_building_tier` now uses the same canonical T1 default rather than an inline T3 fallback when stored data is absent/non-numeric.
- Updated the World Building rule description from `RECOMMENDED: TIER 3` to `DEFAULT: TIER 1`.
- Existing explicit OFF/T1/T2/T3 saved selections are preserved; no save migration, schema bump, API change, engine-range change, or enforcement change is introduced.
- 2.5.11 is a static consistency repair / runtime TEST REQUIRED.

## 2.5.10-DEV
- Strict child of the validated 2.5.9-DEV package.
- Fixed Gold Pokégear NUZ RULES pagination so A advances through every four-row page, including non-multiple-of-four final pages, before wrapping to page 1.
- Added `RULES x/y` and an `A:MORE` footer affordance when the Pokégear rule list overflows four rows.
- Added a translated `NO ENTRIES YET` empty state to native R/B/Y, native Gold, and Modern UI ENC TRACKER presentation.
- Modern UI empty-state presentation preserves the real zero entry count and does not use the placeholder for selected-row detail/provider semantics.
- No Save Schema, Compatibility API, Diagnostics API, Mod API, engine range, encounter mechanics, or provider ownership semantics changed.
- 2.5.10 UI repairs are static / runtime TEST REQUIRED.

## 2.5.9-DEV
- Strict child of the validated 2.5.8-DEV package.
- Yellow 2.5.8 runtime PASS: fresh Shiny Clause defaults to OFF/0.
- Yellow 2.5.8 runtime PASS: Type Locke editing in NUZ RULES no longer raises the prior update error.
- Yellow 2.5.8 runtime FAIL: saving NEW GAME setup could raise an attempt to index global `TYPE_LOCK_SLOT_INDEX`; all later setup/profile slot checks now use the lifecycle-stable Type Locke accessor owned by the canonical lexical block.
- Repaired the related Gold status-summary use of the out-of-scope Type Locke slot-key table.
- Loadout confirmation now scrolls through every owned-rule change with UP/DOWN instead of truncating the preview with `+N MORE`; APPLY/CANCEL semantics are unchanged.
- Nuzlocke-owned setup/rules/status error dialogs now pre-wrap into explicit two-line TextBox pages, forcing manual A/B advancement so diagnostic text can be captured.
- Moved GAME DIFFICULTY then BATTLE MECHANICS immediately above AREA SPLITS.
- Reviewed the reported Gold First Rival Mercy 0-HP asymmetry against Gen1Recomp 0.2.7 `gen2_canlose_test.lua`; NO CODE CHANGE because BATTLETYPE_CANLOSE intentionally leaves the starter at 0 HP until the continuing Cherrygrove script calls HealParty.
- Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, engine range, and loadout ownership semantics are unchanged.
- 2.5.9 setup/UI repairs remain runtime TEST REQUIRED.

## 2.5.8-DEV
- Strict child of the validated 2.5.7-DEV package.
- Yellow 2.5.7 runtime confirmed the loadout-change warning still overflowed/clipped its native modal layout; R/B/Y warning rows are now bounded to a 16-glyph-safe line, show the destination value first, and marquee long rule names instead of drawing through the border.
- Yellow 2.5.7 runtime confirmed changing Type Locke could still trigger the generic NUZ RULES update error; Type Locke edit/update paths now obtain slot/default tables through lifecycle-stable exported accessors, and the random-selection resolver uses the same stable tables.
- Fresh/new-profile **Shiny Clause** default changed from UNLIMITED/4 to OFF/0. Existing saved values, historical boolean migration (`true -> 4`), and used-count telemetry are preserved.
- Moved **Route Forgiveness** from CLAUSES to **GENERAL**; enforcement, token awards/spending, and save keys are unchanged.
- Save Schema 4, Compatibility API 27, Mod API 2, engine range, starter/opening repair, and Dev Report encoding are unchanged.
- All 2.5.8 changes are static repairs/organization until runtime-confirmed.

## 2.5.7-DEV
- Strict child of the validated 2.5.6-DEV package.
- Blue 2.5.6 runtime confirms DEV TOOLS -> VIEW REPORT no longer crashes after a full game restart when a saved report exists.
- Dev Report and Storage Info remained visually broken on the native R/B/Y viewport because long unbroken identifiers bypassed the normal word wrapper and the R/B/Y diagnostic content width was too wide.
- Added a Dev-only hard wrapper for long diagnostic tokens and reduced R/B/Y Dev Report/Storage Info content to a 16-character-safe width.
- NZR4 Report Codes now display below a dedicated `REPORT CODE:` label and wrap only between existing hyphen groups, so every code character remains visible/shareable.
- Report Code generation/decoding, diagnostic payload semantics, Save Schema 4, Compatibility API 27, Mod API 2, engine range, and gameplay enforcement are unchanged.
- The 2.5.6 shared NUZ RULES edit repair still requires runtime confirmation; the loadout-warning popup remains a separate known UI issue.

## 2.5.6-DEV
- Strict child of the validated 2.5.5-DEV package.
- Blue runtime confirmed the shared NUZ RULES edit path could error after a rule write with `bad argument #1 to 'ipairs' (table expected, got nil)`; hardened the title/setup Type Locke mirror with a canonical local fallback so ordinary rule toggles do not depend on that table reference.
- Blue runtime confirmed DEV TOOLS -> VIEW REPORT could crash; forward-declared the wrapped report-line helper so the update closure no longer resolves a nil global on the next frame.
- Removed the extra one-pixel duplicate draw from the MOD COMPAT left rule-name column, leaving those row labels unbolded while preserving the existing title treatment.
- No Save Schema, Compatibility API, Mod API, engine-range, randomizer, starter, or First Rival Mercy behavior was intentionally changed.
- Both runtime crash repairs are static repairs and require Blue runtime re-test before promotion to PASS.

## 2.5.5-DEV
- Blue opening-sequence repair attempt.
- Hardened Oak/Pallet starter-context detection for randomized R/B starters.
- Intended to fix mandatory Nickname Rule and Pallet Town provenance on randomized starters.
- Hardened First Rival Mercy at battle finish so the native Oak-lab loss continuation can heal and advance story state without Nuzlocke Whiteout/restart interference.
- Prevented post-battle dead pruning from re-breaking the one mercy battle.
- Added committed starter diagnostic output.

## 2.5.4-DEV
- World Building default changed from T3 to T1.
- Removed Cap Messages user setting; cap notice is fixed to once per battle on first blocked/banked EXP.
- Retired Solo Only; Party Size Limit = 1 is now authoritative for Solo runs.
- Added legacy Solo-to-party-limit migration and updated SOLO/IRON presets.

## 2.5.3-DEV
- Blue runtime UI pass.
- Ball Limit renamed to Ball Per Enc.
- No Catching and Ball Per Enc. moved to BATTLE ITEMS.
- Ball Per Enc. now hides immediately while No Catching is ON and returns when catching is allowed.
- Preserved OFF as the vanilla Ball Per Enc. default and preserved dormant saved selections.
- Aligned Ball Per Enc. value placement with neighboring selector values.
- Moved GAME DIFFICULTY and BATTLE MECHANICS above GENERAL.

## 2.5.2-DEV
- Added diagnostic-only validation for malformed/boolean `randomizer_info_policy` storage; no migration added because no historical boolean encoding exists.
- Source-audited Gen1Recomp releases 0.2.2 through 0.2.7.
- Advanced `recompCompatAudited` to 0.2.7 and added sequential engine compatibility profiles.
- Recorded the additive `battle.move_grid_navigation` hook as available/not-owned.
- Kept engine requirement `>=0.1.86 <2.0.0`.

## 2.5.1-DEV
- Runtime-validation build created strictly from the unreleased 2.5.0 candidate.
- No gameplay or save-format changes from that candidate.
- Release documentation reclassified as DEV/testing rather than published.
- Intended to gather one more runtime pass before a public 2.5.x release.

## 2.5.0
- Publishable stabilization release, strict child of 2.4.100-DEV.
- Fixed stale Dev Species Facts diagnostic to validate `getSpeciesFacts`.
- Advanced Report Code to NZR4 with full major/minor/patch encoding for the 2.5.0 semver boundary.
- Synchronized public exported build markers with the authoritative mod build.
- Completed full package/documentation/version cleanup.
- Preserved Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and engine range `>=0.1.86 <2.0.0`.
- No files added or removed.

## 2.4.100-DEV
- Fixed Randomizer Info Policy always displaying OPEN INFO despite BLIND INFO being stored/enforced.
- Completed a full numeric-rule plumbing sweep across default/read/write paths.
- No gameplay randomizer behavior changed.

## 2.4.99-DEV
- Completed Encounter Ball Limit numeric config wiring in `defaultRuleValue` and `getConfigValue`.
- Added default-audit and Dev Report readback coverage.
- Report Code format is now NZR3.
- Shiny Clause read/default paths were verified already-correct; setter repair remains from 2.4.98.

## 2.4.98-DEV
- Fixed Shiny Clause and Encounter Ball Limit edits being silently persisted as `false`.
- Added semantic repair for boolean artifacts written by affected builds.
- Added Dev assertions for invalid/raw boolean selector state.

## 2.4.97-DEV
- Fixed joined-word legacy mod IDs not being auto-classified by `detectCapabilities`.
- Expanded compact-ID fallbacks consistently across multi-word capability hints.

## 2.4.96-DEV
- Fixed randomized R/B/Y starters losing Pallet Town provenance when the species is not a vanilla starter.
- Added safe repair for affected Oak/Lab/UNKNOWN tracker rows.
- No randomizer selection/RNG behavior changed.

## 2.4.95-DEV
- Field-item rejection messages are now blocking, paginated, and A-driven.
- Fix targets include No Field Heal and No Rare Candy.
- Battle item rejection behavior was unchanged during build development.

## 2.4.94-DEV
- Fixed stale R/B/Y field-command sessions allowing No Mom Heal to stop enforcing after command rebinding.
- Added Mom heal gate health to Dev Mode.
- Bumped shareable Report Code format to NZR2 for the new diagnostic result bit.

## 2.4.93-DEV
- Added versioned `NZR1` shareable Dev Report Codes.
- VIEW REPORT now works live without first exporting.
- Report codes decode the complete fixed diagnostic summary and fingerprint free-form report detail.
- Export/storage remains available as an optional deep-debug fallback.

## 2.4.92-DEV
- Fixed Storage Info text overflow on R/B/Y.
- Made all Storage Info rows glyph-aware and scrollable.
- Fixed Dev Report scrolling to use wrapped-row counts.
- No gameplay changes.

## 2.4.91-DEV
- Fixed Dev Report text overflow on narrow R/B/Y displays.
- Wrapped report rows now scroll cleanly and preserve the footer.
- No gameplay changes.

## 2.4.90-DEV
- Repaired Yellow opening Oak Pikachu catch-demo skip.
- No unrelated gameplay changes.

## 2.4.89-DEV
- Fixed Cap Messages selector editability.
- Default changed from CAP to BATTLE (once per battle).
- Invalid boolean artifacts from the old setter migrate to BATTLE; valid 0..2 values remain unchanged.

## 2.4.88-DEV
- Moved Party Size Limit and Gym Team Size to the bottom of IRONMON.
- No gameplay changes.

## 2.4.87-DEV
- Moved Party Size Limit and Gym Team Size to the top of GENERAL.
- Recorded Yellow section-header paging and bulk open/close controls as runtime PASS.
- No gameplay changes.

## 2.4.86-DEV
- Renamed the player-facing `Nickname Rule` label to `Nickname`.
- No gameplay or save-format changes.

## 2.4.85-DEV
- Added Encounter Ball Limit: OFF / 1 / 2 / 3 / 5 / 10 throws per encounter.
- R/B/Y + Gold support; battle-local reset; denied throws do not spend Balls or budget.
- Default OFF; no existing preset behavior changed.

## 2.4.84-DEV
- Canonicalize unambiguous legacy boolean values for numeric selectors during save upgrade.
- Primary bug target: old saves with Shiny Clause ON/`true` now persist numeric UNLIMITED/`4` and can use modern selector editing consistently.
- No unrelated gameplay changes.

## 2.4.83-DEV
- Fixed Nuzlocke compatibility with the repaired upstream Yellow starter nickname flow.
- Preserved Red/Blue starter naming behavior.
- No unrelated gameplay changes.

## 2.4.82-DEV
- Added cooperative optional-dependency ordering for `gen1_pt-br` v0.1.5.
- Documented PT-BR translation/presentation overlap audit.
- No gameplay-rule changes.

## 2.4.81-DEV
- Current Gen1Recomp/launcher compatibility audit.
- Added safe optional read-only BattleAPI snapshot exposure for Gen 1 and Gold.
- Confirmed launcher update metadata and Manifest v2 compatibility.
- No gameplay-rule changes.

## 2.4.80-DEV
- Localization compliance audit: glyph-aware Nuzlocke wrapping/slicing and additional `Strings(...)` coverage.
- No gameplay changes; strict child of 2.4.79-DEV.

# Changelog

## 2.4.79 DEV — Gen1 Better Menus 1.0.3 compatibility audit
- Strict child of 2.4.78 DEV.
- Added optional-dependency/load-order metadata and a descriptive compose adapter for Gen1 Better Menus 1.0.3.
- Preserved Nuzlocke-owned custom screens and predecessor-chained title SETUP injection; no global Menu.draw patch added.
- No gameplay/save/API/package-tree changes; runtime combination TEST REQUIRED.


## 2.4.78 DEV — Type Locke Expansion + Catch Draft

- Expanded Type Locke to Monolocke, Duolocke, Trilocke, Quadlocke, Pentalocke, and Hexalocke.
- Added persisted Type 4, Type 5, and Type 6 selectors.
- Added Catch Draft: opening battle-backed catches populate the chosen 1-6 Type Locke lanes before enforcement begins.
- Dual-type catches prefer a new type when possible, otherwise use their primary type deterministically. Gifts and trades do not draft lanes.
- Manual RANDOM selection resolves once and persists across all six lanes.
- Setup/Rules hide unused lanes and hide manual selectors while Catch Draft is active.
- Extended Type Locke legality, randomizer interaction, summaries, Gold parity metadata, and World Building text for the new modes.
- Save Schema 4, Compatibility API 27, Diagnostics API 1, engine range `>=0.1.86 <2.0.0`.
- Static/package validation only; no new runtime PASS claimed.

## 2.4.77 DEV — Compatibility Audit Consolidation

- Strict child of **2.4.76 DEV**.
- Documentation/compatibility-consolidation pass only; mechanics remain unchanged from 2.4.76 apart from build/version identification strings.
- Consolidates completed audits for Modern UI Fix, Advanced Box System, Nickname Changer, Trade Evolution Fix, Universal Free TM Shop, Moves Manager, Quest System, The Mirage of Mew, Crystal Onix, Poachers in the Safari Zone, Kanto Achievements, Pokédex Plus, Catch Helper, Move Inspector, Rocket Gym Ambushes, Team Rocket Returns, Eevee Three Stones, The Sixth Bell, The Stolen Fossil, Whispers Beneath Cerulean, The Abandoned Cabin, The Black Flower, The Empty Throne, Ashes of Cinnabar, Echoes Beyond the Fog, Move Learn Stats, Performance Monitor, BATTLE_ART_VOXEL_FORK, new_icons, and New Item Icons.
- Removes those completed reviews from the active compatibility target queue while retaining explicit runtime-test requirements.
- Does not convert source/static/expected classifications into runtime PASS claims.
- No Save Schema, Compatibility API, Diagnostics API, or engine-range change.
- Engine policy remains **`>=0.1.86 <2.0.0`**.

## 2.4.76 DEV — Compatibility Documentation & Target Queue

- Strict child of 2.4.75 DEV.
- General stability improvements; mechanics remain unchanged from 2.4.75 apart from build/version identification strings.
- Recorded the completed audit wave for NPC Bubbles, Guaranteed Catch, Repel Reuse Prompt, HM Anywhere, New Game Plus, Area DexNav, Summon, Modern Bag, Item Shortcut, Reusable Machines, DV/EV Editor, EXP Share Modes, Free Rare Candy, Free Master Ball, Too Many Balls, and Better Battle UI.
- Refreshed the current FAFF0x Gen1Recomp compatibility target queue.
- Promoted Modern UI Fix 1.0.0, Advanced Box System 1.1.0, Nickname Changer 1.0.0, Trade Evolution Fix 1.0.0, Universal Free TM Shop 1.0.0, Moves Manager 1.0.1, Quest System 1.0.5, The Mirage of Mew 1.0.1, Crystal Onix 1.0.8, and Poachers in the Safari Zone 1.0.0 as the highest-value next audits.
- No runtime PASS claims were added.
- Save Schema 4 / Compatibility API 27 / Diagnostics API 1 unchanged.
- Engine policy remains `>=0.1.86 <2.0.0`.

# Nuzlocke Changelog

## 2.4.75 DEV — Kanto Reforged 1.2.0 Level-Cap Interop
- Strict child of **2.4.74 DEV**.
- Adds a source-confirmed adapter for **Kanto Reforged 1.2.0**.
- Detects KR only when its own `level_caps_on` save flag is active.
- Reads KR's current cap through its own `ui/level_caps.lua` calculation and never writes KR options/save.
- When both Nuzlocke Level Caps and KR Level Caps are active, Nuzlocke now enforces/displays the **stricter** cap.
- When Nuzlocke Level Caps are OFF, KR remains solely responsible for its own soft-cap behavior.
- Public cap info now exposes optional co-owner metadata (`effectiveOwner`, `nuzlockeCap`, `kantoReforgedCap`, `kantoReforged`) without changing Compatibility API version.
- Kanto Reforged trainer-party/species/held-item behavior remains on generic composition paths.
- No Save Schema, Compatibility API, Diagnostics API, or engine-range change.


## 2.4.74 DEV — Indigo Plateau Conference 1.1.0 Compatibility Audit
- Strict child of **2.4.73 DEV**.
- Updates the built-in Indigo Plateau Conference adapter audit marker from **1.0.2** to **1.1.0**.
- Re-audits IPC's current Gold-only tournament architecture: IPC owns Colosseum staging, CANLOSE/elimination flow, tournament state, and survivor healing; Nuzlocke retains Permadeath/death-marker/rule ownership.
- Confirms Nuzlocke's existing priority **-1000** post-`battle.ended` dead-Pokemon pruning already runs after ordinary external listeners, so IPC may heal living survivors without reviving a Pokemon already marked `nuzlockeDead`.
- Keeps `trainer.party` composition unchanged; IPC positively scopes its roster substitution to its own armed tournament battle.
- No new listener, provider contract, gameplay rule, Save Schema, Compatibility API, Diagnostics API, or engine-range change.


## 2.4.73 DEV — Quick Start Runtime Documentation
- Strict child of **2.4.72 DEV**.
- Records a user runtime **PASS** for the R/B/Y Quick Nuzlocke Start / intro-bypass flow.
- Documents the observed convenience caveat: the transition can place the player outside before bedroom-PC item pickup, but the house remains accessible and the items can still be collected by walking back inside.
- Updates the player-facing Quick Start description and implementation comment so the documented checkpoint matches observed runtime behavior.
- No progression logic, save behavior, hook behavior, Save Schema, Compatibility API, Diagnostics API, or engine-range policy changes.


## 2.4.72 DEV — Engine Range Policy Correction
- Strict child of **2.4.71 DEV**.
- Restores the manifest engine range to **`>=0.1.86 <2.0.0`**.
- Keeps the supported engine maximum below **2.0.0**.
- Keeps the Gen1Recomp audited release marker at **0.2.0**.
- No gameplay, hook, Save Schema, Compatibility API, Diagnostics API, or provider behavior changes.


## 2.4.71 DEV — Gen1Recomp 0.2.0 Compatibility Audit
- Strict child of **2.4.70 DEV**.
- Audited against the released **Gen1Recomp 0.2.0** line.
- Corrects `recompCompatAudited` from the inaccurate `0.2.1` marker to `0.2.0`.
- Narrows the manifest's verified engine range from `>=0.1.86 <2.0.0` to `>=0.1.86 <0.3.0`.
- Reviewed current Nuzlocke hooks/events, `mod.storage`, manifest API 2, Gold battle/catch modules, menu hooks, and reload/lifecycle seams against upstream 0.2.0.
- Upstream 0.2.0 retains the compatibility surfaces Nuzlocke currently uses; no protected gameplay hook was replaced in this pass.
- Save Schema remains **4**; Compatibility API remains **27**; Diagnostics API remains **1**.


## 2.4.70 DEV — Post-Release Safety / Diagnostic Hardening
- Strict child of the published **2.4.69** release.
- Fixes a downgrade-safety hole in the 2.4.66 write detector: an escaped `mod.save:set(...)` attempt on a newer-schema save is now recorded **and blocked** with `false, "newer_schema"` instead of being allowed to mutate the unsupported save.
- The write barrier resolves the current exported `saveSchemaSupported()` predicate dynamically, avoiding a stale closed-over schema flag if loader/session wrappers survive a supported reload.
- Adds the missing `saveSchemaTooNew` guard to direct `Randomizer.applyLearnsets(...)` calls, preventing live learnset mutation when an unsupported newer-schema save is loaded.
- Quick Start, Skip Opening Intro, automatic default-name activation, and `applyQuickNuzlockeStart(...)` now fail closed while a newer-schema safe-stop is active, protecting direct raw save-table writes outside `mod.save:set(...)`.
- Deferred Starting Balls release and Skip Catch Tutorial queries also fail closed on unsupported newer-schema saves, closing the remaining world-step/story shortcut paths found in the final sweep.
- Fixes the 2.4.68 Randomizer integrity audit so an intentionally empty legal Random Encounter pool reports **FALLBACK** (vanilla encounters retained) instead of falsely scanning vanilla slots as illegal randomized output.
- Corrects lifecycle diagnostic wording: pre-reload counter totals are not promised to survive; duplicate delivery is detected when stacked callbacks resolve through the same current Dev export.
- Documentation now records 2.4.69 as the published full release rather than leaving current history labeled RC.
- Save Schema remains **4**; Compatibility API remains **27**; Diagnostics API remains **1**.


## 2.4.69 — Published Release
- Strict child of **2.4.68 DEV**.
- No new gameplay feature or rule behavior is introduced in this RC.
- Published from the 2.4.68 development head after sequential Dev Mode hardening from 2.4.64–2.4.68.
- Retains 2.4.62 Random Encounter legality filtering and 2.4.63 future-schema downgrade safety unchanged.
- Retains Dev diagnostics for hook health, lifecycle duplicate detection, future-schema write-attempt detection, rule effectiveness, and Randomizer integrity.
- Save Schema remains **4**; Compatibility API remains **27**; Diagnostics API remains **1**.
- Package inventory remains the existing **15 files**; no files added or removed.
- The packaged code was the reviewed 2.4.69 release-candidate tree and was subsequently published as the full 2.4.69 release.


## 2.4.68 DEV — Dev Randomizer Integrity Audit
- Strict child of **2.4.67 DEV**.
- Adds a read-only recursive scan of the currently applied Nuzlocke-owned wild encounter registry.
- Reuses Random Encounter legality dimensions from the live candidate pool: generation mode, glitch exclusion, runtime safety, and canonical `specialAcquisitionDenied(...)` rule legality.
- Skips externally delegated Random Encounter ownership and content-provider slots that explicitly opt out of Nuzlocke randomization.
- Reports scan count, violation count, status, delegation owner, and up to 64 deterministic violation rows with path/species/reason.
- Integrates the audit into Dev snapshots, self-test results, exported `[RANDOMIZER INTEGRITY]` text, and `nuzlocke_dev.randomizer_integrity()`.
- No encounter tables are changed by the audit and no gameplay/save/API behavior changes.


## 2.4.67 DEV — Dev Rule Effectiveness Audit
- Strict child of **2.4.66 DEV**.
- Adds read-only rule diagnostics showing each applicable rule's configured/stored value, normalized effective config value, and current owner/relationship.
- Reuses the canonical `getConfigValue(...)` and `externalRuleDelegation(...)` paths instead of duplicating rule/delegation semantics.
- Reports whether a value came from the save or the rule default, plus aggregate totals for applicable, delegated, changed, and errored rows.
- Reports the Nuzlocke master-switch state and future-schema support state separately rather than falsely rewriting every rule's effective value when the master switch is off.
- Adds rule-effectiveness evidence to Dev snapshots, self-test results, exported `[RULE EFFECTIVENESS]` text, and `nuzlocke_dev.rule_effectiveness()`.
- No gameplay, rule, save-schema, Compatibility API, or persistent-save behavior change.


## 2.4.66 DEV — Future-Schema Safe-Stop Write Diagnostics
- Strict child of **2.4.65 DEV**.
- Adds a transparent diagnostic wrapper around Nuzlocke's own `mod.save:set(...)` surface.
- While `saveSchemaTooNew` is active, every attempted Nuzlocke save write is counted by key and the first attempt per key emits a `safe_stop.write_attempt` breadcrumb when Dev Mode is enabled.
- The detector never blocks or changes the underlying write; 2.4.63's explicit safe-stop guards remain the protection mechanism. This build only proves whether an unguarded writer escaped them.
- Adds aggregate/first/last/per-key evidence to Dev assertions, snapshots, self-test results, and exported `[SAFE STOP WRITES]` text.
- Adds `nuzlocke_dev.safe_stop_writes()` and `nuzlocke_dev.reset_safe_stop_writes()` for controlled downgrade tests.
- No gameplay, rule, save-schema, Compatibility API, or intended persistent-save behavior change.


## 2.4.65 DEV — Dev Lifecycle Counters
- Strict child of **2.4.64 DEV**.
- Adds session-only Dev counters for `game.ready`, `save.loaded`, `battle.started`, `battle.ended`, `pokemon.caught`, and `pokemon.evolved`.
- Lifecycle counters are session-instance diagnostics. Their main reload value is detecting repeated delivery when stacked callbacks resolve through the same current Dev export; pre-reload totals are not guaranteed to persist.
- Uses weak event-payload identity tracking to detect the same event table reaching the Dev callback more than once; repeated delivery increments `duplicate_callbacks` and per-event duplicate counts.
- Duplicate callback detection pushes a `lifecycle.duplicate` breadcrumb immediately.
- `battle_delta` reports `battle.started - battle.ended` as context only; it is not automatically considered failure because a self-test can run during an active battle.
- Lifecycle evidence is included in Dev snapshots, self-test results, exported `[LIFECYCLE]` text, and the public diagnostics surface.
- Adds `nuzlocke_dev.lifecycle()` and `nuzlocke_dev.reset_lifecycle()` for controlled runtime tests.
- No event-registration, gameplay, rule, save-schema, Compatibility API, or persistent-save behavior changes.


## 2.4.64 DEV — Dev Hook / Adapter Health
- Strict child of **2.4.63 DEV**.
- Adds read-only `Dev.hookHealth()` inspection for 13 observable Nuzlocke runtime adapters across R/B/Y and Gold.
- Diagnostics never `require(...)` a module merely to inspect it; only already-loaded modules are observed, preserving boot/load order.
- Health states are deliberately conservative: **HEALTHY** (our wrapper is live top-level), **CHAINED** (our marker/wrapper exists but another live function is above it or replaced it), **MISSING** (loaded module lacks the expected Nuzlocke marker), and **PENDING** (module not loaded yet).
- `Dev.selfTest()`, snapshots, exported self-test text, and `nuzlocke_dev.hook_health()` now expose hook-health evidence.
- CHAINED is informational rather than an automatic failure because another compatible mod may legitimately compose above Nuzlocke.
- No gameplay, rule, save-schema, compatibility-API, hook-ordering, or persistent-save behavior change.


## 2.4.63 DEV — Future-Schema Downgrade Safety
- Strict child of **2.4.62 DEV**.
- A save whose `__nuzlocke_save_schema` is newer than schema 4 now suspends ordinary Nuzlocke enforcement through the shared `active(...)` gate instead of continuing under older schema assumptions.
- High-risk lifecycle repair writers that do not naturally pass through `active(...)` now bail out while the newer-schema safe-stop is active: WIP Wonderlocke cleanup, staged new-game rule commits, external-save reconciliation, Randomizer encounter/all reapplication, and Gym/E4 initialization.
- The first ready game session displays a non-persisted **NUZLOCKE PAUSED** warning explaining that the save came from a newer Nuzlocke build and that enforcement/save repairs are disabled to protect it.
- Adds `mod.exports.__beta26.saveSchemaSupported()` as the central read-only schema-support query.
- No Save Schema or Compatibility API bump.


## 2.4.62 DEV — Random Encounter Rule-Legality Filtering
- Strict child of **2.4.61 DEV**.
- Fixes Nuzlocke-owned Random Encounter pools ignoring active Type Locke, No Legendaries, No Mythicals, No Pseudos, and Maximum BST legality.
- Reuses the same canonical `specialAcquisitionDenied(...)` gate already used by Random Starter instead of duplicating rule logic.
- Existing persisted random encounter slots are revalidated against the current candidate pool; saved choices that become illegal are deterministically replaced. Mid-run Type Locke/BST/species-ban edits now trigger immediate randomizer reapplication.
- If the legal species pool is empty, encounter randomization safely leaves/restores the vanilla encounter registry rather than crashing.
- Corrects inherited runtime build metadata that still reported 2.4.60 inside `main.lua` despite the 2.4.61 package manifest/docs.
- Future-schema downgrade-safety finding remains queued and is not mixed into this gameplay-rule interaction patch.
- Save Schema remains **4**, Compatibility API remains **27**, Diagnostics API remains **1**.

## 2.4.61 DEV — Permanent Rule Seal Write Ordering
- Strict child of **2.4.60 DEV**.
- Fixes dormant `persistPermanentRuleSeal()` ordering so durable `mod.storage` persistence must succeed before `mod.save` is marked permanently locked.
- Storage unavailable, missing-playthrough, thrown-write, and unsuccessful-write returns now leave the in-memory lock flags untouched.
- Preserves the 2.4.59 `pguard` storage diagnostic path.
- Permanent Rule Seal remains intentionally WIP-disabled; no intended live gameplay-rule behavior change.
- Save Schema remains **4**, Compatibility API remains **27**, Diagnostics API remains **1**.

## 2.4.60 DEV — Runtime Crash Diagnostic Capture
- Strict child of **2.4.59 DEV**.
- Routes full NUZ RULES/SETUP `update`/`draw` `xpcall` tracebacks into `Dev.recordError` before player-facing truncation.
- Applies the same capture to the independent NUZ STATUS screen runtime-failure path with distinct labels.
- Keeps existing deferred screen-recovery behavior intact and protects diagnostic reporting with `pcall`.
- No gameplay-rule, save-schema, Compatibility API, or Diagnostics API change.

## 2.4.59 DEV — Passive Dev Diagnostic Hardening
- Strict child of **2.4.58 DEV**.
- Adds recursion-safe `Dev.pguard()` so selected high-value guarded failures enter the existing Dev breadcrumb/error/snapshot pipeline without changing normal `pcall` return semantics.
- Instruments permanent-seal storage access, save-upgrade steps, compat loader/provider discovery, active-provider callbacks, recovery/context callbacks, and the fallback species-metadata provider signature.
- Preserves intentional provider signature fallback: the first species-metadata signature may fail normally; Dev reports only when the fallback call also throws.
- Adds read-only encounter-ledger assertions for `encounter_states`/`caught_areas` contradictions.
- Adds structural Shiny Clause assertions for malformed mode/used values without falsely warning when a player legitimately lowers a finite limit after prior uses.
- Does **not** wrap mechanics-capability calculation itself, avoiding recursive diagnostic snapshots.
- Preserves 2.4.58 full 48-breadcrumb export and bounded 16-report history unchanged.
- Corrects stale `mod.card` engine metadata to match the manifest range `>=0.1.86 <2.0.0`.
- Save Schema remains **4**, Compatibility API remains **27**, Diagnostics API remains **1**.

## 2.4.58 DEV — Encounter Provenance + Diagnostic History
- Strict child of **2.4.57 DEV**.
- Pins battle encounter provenance once; catch, failed-encounter, and Ball-legality accounting can no longer drift to later map/cardinal/Gold-time state.
- Keeps battle-less current-location queries live; death-location records explicitly remain live-location semantics.
- Dev reload distinguishes READ success from true write/read-back verification.
- Exports the full bounded 48-breadcrumb ring.
- Verified exports update `dev/self_test_latest` and also create a sequenced history record.
- Retains the newest 16 history reports per playthrough via official `mod.storage`.
- Save Schema remains **4**, Compatibility API remains **27**, engine range remains `>=0.1.86 <2.0.0`.

## 2.4.57 DEV — Launcher Range + Capture Ledger Integrity
- Strict child of **2.4.56 DEV**.
- Broadens `game_version` from `>=0.1.86 <0.2.5` to **`>=0.1.86 <2.0.0`** so compatible Gen1Recomp/launcher updates do not disable Nuzlocke merely for crossing the 0.2.x version line.
- Keeps Mod API **2** as the breaking mod-surface contract; the upper engine-major guard remains below 2.0.0.
- Adds monotonic capture-state reconciliation: successful consumed-catch evidence from `tracker_log` / `caught_areas` cannot be downgraded to FAILED by a delayed callback or conflicting reconstructed state.
- Reconciles `caught_areas`, `encounter_states`, and `encounter_area_state_ledger` before projection and before save writes.
- Does not invent tracker catches, reopen areas, or convert Shiny/exempt `consumedArea=false` catches into consumed slots.
- Save Schema remains **4** and Compatibility API remains **27**.

## 2.4.56 DEV — Documentation Integrity Reconciliation

- Strict child of **2.4.55 DEV**.
- Corrected current compatibility metadata to audited Gen1Recomp **0.2.1**, Save Schema **4**, Compatibility API **27**, and manifest range **`>=0.1.86 <0.2.5`**.
- No gameplay semantics changed.

## 2.4.55 DEV — Fast Section Navigation
- Strict child of **2.4.54 DEV**.
- Added SELECT+UP/DOWN section-header jump with wraparound.
- Added SELECT+LEFT/RIGHT collapse-all / expand-all on section headers.

## 2.4.54 DEV — Rule-List Wraparound Navigation
- Strict child of **2.4.53 DEV**.
- UP from the first selectable row wraps to the last; DOWN from the last wraps to the first.

## 2.4.53 DEV — Historical Difficulty Scope Correction
- Strict child of **2.4.52 DEV**.
- Restored the intended historical profile set/names while keeping the deeper 2.4.52 trainer-team/moves/AI/boss/DV mechanics.

## 2.4.52 DEV — Deeper Historical Difficulty Mechanics
- Strict child of **2.4.51 DEV**.
- Added deeper boss-specific team/BST/move/AI/Stat EXP/DV/held-item tuning and selected-profile summaries.
- Temporary extra profile names from this build were removed in 2.4.53.

## 2.4.51 DEV — Gold-Only No Held Items
- Strict child of **2.4.50 DEV**.
- Added Gold-only No Held Items: GIVE blocked, TAKE preserved, existing player-held effects suppressed, enemy/trainer held items unaffected.

## 2.4.50 DEV — Gen1Recomp 0.2.1 Compatibility Consolidation
- Strict child of **2.4.49 DEV**.
- Confirmed 0.2.1 adds no additional mod-runtime migration beyond 0.2.0.

## 2.4.49 DEV — Gen1Recomp 0.2.x Compatibility Migration
- Strict child of **2.4.48 DEV**.
- Migrated Dev diagnostics persistence to official `mod.storage`.
- Removed legacy direct filesystem/clipboard persistence assumptions.

## 2.4.48 DEV — Native DEV TOOLS Cursor + Wrapped Info
- Strict child of **2.4.47 DEV**.
- Added native cursor glyphs and wrapped diagnostic info.

## 2.4.47 DEV — Verified Diagnostic Export + FILE INFO
- Strict child of **2.4.46 DEV**.
- Added legacy write/read-back verification and FILE INFO diagnostics.

## 2.4.46 DEV — Deterministic Self-Test File
- Strict child of **2.4.45 DEV**.
- Added deterministic legacy self-test file target; later superseded by `mod.storage`.

## 2.4.45 DEV — DEV TOOLS Layout Repair
- Strict child of **2.4.44 DEV**.
- Fixed R/B/Y DEV TOOLS geometry and added cached report viewer/copy controls.

## 2.4.44 DEV — Clipboard-First Diagnostics
- Strict child of **2.4.43 DEV**.
- Prioritized clipboard delivery; later superseded by official storage.

## 2.4.43 DEV — DEV TOOLS + Self-Test
- Strict child of **2.4.42 DEV**.
- Added dedicated Dev Mode tools screen and structural self-test.

## 2.4.42 DEV — Self-Test + Presentation-Control Unlock
- Strict child of **2.4.41 DEV**.
- Kept Level Cap Messages / Encounter Indicator editable after challenge sealing and added initial self-test wiring.

## 2.4.41 DEV — Rules Row Collision Fix
- Strict child of **2.4.40 DEV**.
- Fixed R/B/Y label/value overlap.

## 2.4.40 DEV — Lua Loadability Hotfix
- Strict child of **2.4.39 DEV**.
- Repaired the >200-local compiler failure from 2.4.38/2.4.39.

## 2.4.39 DEV — Encounter Tracker Death Projection
- Strict child of **2.4.38 DEV**.
- Added persistent-ID death projection; inherited 2.4.38 compiler-invalid state.

## 2.4.38 DEV — Encounter Indicator + Cap Message Frequency
- Strict child of **2.4.37 DEV**.
- Added encounter indicator and cap-message frequency.
- Historical compiler-invalid build due to >200 locals.

## 2.4.37 DEV — Forgiveness Modal UI Polish
- Strict child of **2.4.36 DEV**.
- Rebuilt the R/B/Y forgiveness prompt as an opaque framed modal.

## 2.4.36 DEV — Shiny / Encounter-Slot Integrity
- Strict child of **2.4.35 DEV**.
- Fixed finite Shiny Clause accounting and centralized caught/failed slot conflict semantics.

## 2.4.35 DEV — Developer Diagnostics Mode
- Strict child of **2.4.34 DEV**.
- Added default-OFF read-only diagnostics mode.

# 2.4.34 — Provider Capability Architecture + Gen9Dex Hardening

## 2.4.34 DEV

- Strict child of 2.4.33 DEV; no older branch restoration.
- Added a private mechanics-capability resolver so compatibility can distinguish battle-stat ownership, stat-growth ownership, native-DV identity, move-category ownership, and merged evolution data instead of treating an entire mod as one feature owner.
- Added a source-audited Gen9Dex / Gen 9 Battle Engine 1.2.0 Gold adapter. Its modern IV/EV/Nature battle-stat growth is treated separately from Gold native DVs, which remain meaningful for shiny/gender/Unown identity.
- Gold Player/Wild/Trainer Stat EXP starting controls and No Stat EXP Gain now delegate when Gen9Dex owns modern EV growth rather than misleadingly appearing to control the active growth system. Perfect native DVs remain available.
- Added a normalized species-facts surface over merged species/provider data for BST/types/category/evolution consumers.
- Evolution Limits NO FINAL now evaluates outgoing evolutions against the final merged evolution-method registry; dormant unsupported National-Dex evolution rows no longer make a currently terminal species look non-final.
- Added g9-battle-engine as an optional dependency for deterministic compatibility discovery.
- Save Schema remains 4 and Compatibility API remains 27; the new capability resolver is intentionally internal until its contract is runtime-proven.

# 2.4.33 — Save Editor / External Save-State Hardening

## 2.4.33 DEV

- Direct child of 2.4.32 DEV; no older branch was restored.
- Audited Gen1Recomp's built-in Save Editor mutation and save-serialization paths against Nuzlocke Save Schema 4.
- Added load/re-entry reconciliation so a Pokemon already marked `nuzlockeDead` cannot be resurrected by an external HP edit while Permadeath is active.
- Added non-destructive external party-cap reconciliation: parties above the selected Party Size Limit are reported in MOD COMPAT, but Nuzlocke never auto-boxes, deletes, reorders, or chooses which Pokemon to remove.
- Preserved the existing persistent identity model: `speciesAtRegistration` remains historical while `currentSpecies` follows external/in-game species changes.
- Preserved the persisted `EDITED` provenance token for backward compatibility while changing player-facing Nuz Info presentation to EXTERNAL; no encounter location or catch slot is fabricated for editor-added Pokemon.
- Added Save Editor audit/runtime requirements to compatibility, API, user-guide, confidence, and release-note documentation.
- Save Schema remains 4; Compatibility API remains 27.

# 2.4.32 — Quality of Life 1.3.0 Compatibility Hardening

## 2.4.32 DEV

- Direct child of 2.4.31 DEV.
- Added `quality_of_life` as an optional dependency and audited compatibility adapter target.
- Gen 1 Easy Interactions SELECT shortcut can no longer bypass active Travel Restrictions or Dungeon Lock-In; the external shortcut handler is conservatively suppressed instead of wrapping low-level story-sensitive transport methods.
- Gold remains on native field-move permission paths.
- Existing No Repels enforcement remains authoritative for the mod's Repel shortcut/refill paths.
- Updated compatibility information, user/API docs, release notes, and confidence guidance.
- Save Schema remains 4; Compatibility API remains 27.

# 2.4.31 — QoL Toggles 1.24.1 compatibility hardening

## 2.4.31 DEV

- Direct child of 2.4.30 DEV; no older branch was restored.
- Added an option-aware audited adapter for QoL Toggles 1.24.1 across Gen 1 + Gold.
- Added `qol_toggles` as an optional dependency for deterministic coexistence ordering.
- Hardened No Escape and Travel Restrictions / Dungeon Lock-In public veto hooks at restriction priority so external convenience wrappers cannot short-circuit active Nuzlocke policy.
- Guarded QoL Toggles AUTO-REPEL's direct exported consumption helper when No Repels is active.
- Delegates only the duplicate Automatic Running convenience control, and only while QoL Toggles `run_hold_b` is actually enabled; the stored Nuzlocke choice remains dormant and returns when external ownership ends.
- Did not broaden No Field Heal, No Gambling, Perfect DVs, Dupes Clause, or other rule semantics merely to match similarly named QoL options.
- Save Schema remains 4 and Compatibility API remains 27.
- Runtime combination validation remains TEST REQUIRED.

# 2.4.30 — Compatibility target refresh

## 2.4.30 DEV

- Direct child of 2.4.29 DEV; no older branch was restored.
- Re-audited Too Many Balls 0.6.1 (historically Kanto Balls). Current source supports Gen 1 + Gen 2 with generation-specific custom-ball mechanics; Nuzlocke retains generic semantic Ball/content compatibility and adds no named adapter.
- Re-audited Shiny Pokémon 1.0.8. R/B/Y shiny identity remains visible through native shiny DVs / `mon.shiny`; targeted Limited Shiny Clause + Randomizer runtime combination testing remains required. Gold is not certified by this audit.
- Marked Kanto Life and NPC Bubbles as UPSTREAM UNRESOLVED after a fresh resolution attempt could not identify canonical current upstreams from retained evidence. Historical architecture lessons are preserved without pretending to be current certification.
- Corrected stale current-build lineage wording carried in 2.4.29 metadata.
- No gameplay rules, save keys/schema, Compatibility API methods, engine range, dependencies, or package files changed.

# 2.4.29 — Maintained rule × game-family parity matrix

## 2.4.29 DEV

- Direct child of 2.4.28 DEV; no older branch was restored.
- Added the promised permanent rule × game-family parity matrix to the existing `docs/COMPATIBILITY.md`.
- Matrix records R/B/Y and Gold implementation state, enforcement/adaptation mechanism, runtime confidence, and intentional/upstream limitations for the current rule surface.
- Added a release gate: every future rule addition, removal, rename, game-family exposure change, or generation-specific enforcement change must update the matrix in the same child build.
- Clarified that matrix `✅` means an implementation exists; it does not promote a TEST REQUIRED path to runtime PASS.
- No gameplay mechanics changed. Save Schema remains 4; Compatibility API remains 27.
- Package file tree remains unchanged.

# 2.4.28 — Cross-version rule parity audit

## 2.4.28 DEV

- Direct child of **2.4.27 DEV**; no older branch was restored.
- Audited every exposed rule against R/B/Y and Gold/Gen2-specific data and execution seams.
- Gold now exposes shared rules that already had generation-neutral enforcement but were omitted from the Gold beta allowlist: **Route Forgiveness, Overworld Encounters, Town Catches, No Legendaries, No Mythicals, No Pseudos, Trainer Money, Solo Only, Randomizer Seed, Starter Style, Encounter Balance, Randomizer Info, Random Learnsets, and Learnset Gen**.
- Gold Random Learnsets now supports the native Gen2 `levelMoves` species data shape in addition to the Gen1 `level1Moves` / `learnset` shapes. Learn levels and row counts are preserved; only move ids are replaced through the existing deterministic LEARNSETS RNG stream.
- Added native Gen2 fallback classification for **Raikou, Entei, Suicune, Lugia, and Ho-Oh** as Legendaries and **Celebi** as Mythical. Merged provider metadata remains authoritative when present.
- Kept genuinely Kanto/R/B/Y-specific controls off the Gold surface: Route 2/10/20 splits, Mt. Moon splits, Safari Zone splits, Gym Guide Rare Candy, and R/B/Y-only starting Money/Poke Balls/Rare Candy. Wonderlocke remains WIP/disabled.
- Updated Gold parity metadata to `2.4.28`.
- Save schema remains **4** and Compatibility API remains **27**; no public provider contract or incompatible persisted structure changed.
- Runtime validation is required for the newly exposed Gold rules, especially Random Learnsets, Route Forgiveness rewards, Trainer Money, species bans, Solo Only, town/overworld capture policy, and randomizer sub-controls.

# 2.4.27 — Gold compact rule-label parity

## 2.4.27 DEV

- Direct child of 2.4.26 DEV; no older branch was restored.
- Ported the existing R/B/Y localization-safe compact-label fallback into Gold's native Setup and NUZ RULES renderer.
- Gold now prefers the full translated rule/category label whenever it fits the native field, then consults existing `shortName` / `shortTitle` only when needed.
- If a full label is translated but its shorthand is not, Gold keeps the translated full label and uses the existing marquee instead of substituting untranslated English shorthand.
- Rule values, descriptions, controls, save keys, presets, provider ownership, and gameplay enforcement are unchanged.
- Save schema remains 4; Compatibility API remains 27; package file set remains 15 files.
- Runtime visual confirmation required for Gold NEW GAME Setup and in-game NUZ RULES, including long translated labels and section headers.

# Nuzlocke 2.4.26 DEV — Chronological Changelog Normalization

2.4.26 is the strict child of 2.4.25 DEV and changes no gameplay behavior. This build completes the structural changelog repair by turning the cumulative historical record into one coherent newest-to-oldest sequence.

## Repaired chronology

- Reordered all recovered version blocks into descending version chronology instead of leaving beta.30.0.0.x / beta.30.1.x records stranded after the early-beta archive.
- Reconciled duplicate version headings while preserving unique historical notes under a single version block.
- Restored the missing **2.1.19 RC** heading from surviving contemporaneous documentation; its unique compatibility/lifecycle notes had survived in 2.4.25 but were incorrectly attached to 2.1.20.
- Preserved evidence qualifiers and intentionally missing-number gaps; no unsupported release details were invented.
- Preserved all historical version identities carried by 2.4.25, including internal beta.25 milestone labels such as 25D2/25D3/25D4 and 26B10.
- Added a minimal `2.0.0-beta.30.1.19` lineage heading because surviving packaged-revision evidence confirms the build existed; its exact delta remains intentionally unattributed.

## Permanent release gates

`CHANGELOG.md` remains append-only historical evidence. In addition to preserving every immediate-parent version identity, future candidates must now verify that:

1. version blocks are in newest-to-oldest order;
2. duplicate version identities are reconciled into one chronological block unless an explicitly documented internal milestone intentionally shares the public version number;
3. historical content is never moved below older versions by an append operation;
4. unique notes from a reconciled duplicate are retained.

## Validation

- Documentation/version reconciliation only; no challenge rule, save schema, compatibility API, engine range, or gameplay hook is intentionally changed.
- Package file set remains unchanged.

---

# Nuzlocke 2.4.25 DEV

- Strict child of 2.4.24 DEV.
- General stability improvements.
- No gameplay behavior changed.

# Nuzlocke 2.4.24 DEV — Compatibility research update

2.4.24 is the direct child of 2.4.23 DEV and intentionally changes no gameplay rule. It consolidates compatibility history into `docs/COMPATIBILITY.md` and clarifies which findings are source-reviewed versus runtime-confirmed. Save schema remains 4 and the 15-file package set was unchanged during build development.

## Compatibility documentation

- Expanded `docs/COMPATIBILITY.md` with version, audit type, Nuzlocke treatment, runtime status, known limitations, and re-check conditions for researched mods/tools.
- Compatibility entries distinguish static/source review, architecture/compatibility research and runtime-confirmed coexistence so evidence levels are not conflated.
- Added current ledger entries for All Pokémon Catchable 151, Gen1Recomp Content Editor, Trainer Talk 0.2.6, Spaceworld Sprites 1.0, and Gen2-3D-Sprites / Stadium 2 Overworld Models 0.2.81, while retaining earlier audited integrations and research targets.
- Recorded Gen2-3D-Sprites' embedded Wilds/direct overworld-capture path as a targeted Gold runtime-test requirement, especially Party Size Limit, capture legality, Ball restrictions, encounter consumption, tracker area attribution, and Nuzlocke UI coexistence. No private/internal adapter is added without a demonstrated failure.
- Corrected stale 2.4.23 lineage comments/documentation that incorrectly named 2.4.21 as its parent; the true parent is 2.4.22.

## Validation

- Documentation/version reconciliation only; no challenge behavior or save data is intentionally changed.
- Runtime status of previously untested mod combinations remains TEST REQUIRED.

---

---

# Nuzlocke 2.4.23 DEV — Generic Content-Mod Compatibility Hardening

2.4.23 is the direct child of 2.4.22 DEV and adds no new challenge option. It hardens composition with ordinary API-2 content mods and editor-generated content.

## Hardened

- Tracker area discovery now also learns map IDs from merged encounter registries, covering content mods that publish encounters before/without a separately discoverable map registry row.
- Legendary/Mythical/Pseudo classification accepts common `tags`, `flags`, `traits`, and `categories` metadata collections in addition to dedicated booleans. Unknown classifications still fail open.
- Ball detection now accepts dedicated merged `balls` / `ballRegistry` / `ball_registry` registries as well as item metadata and legacy item-effect tables, so custom API-2 capture devices participate in semantic capture policy without hard-coded IDs.
- Existing merged BST/evolution/type handling and unknown-map support are preserved. Custom trainers are not guessed to be Gym Leaders; boss/cap ownership remains known-progression/provider driven.

## Compatibility policy

Ordinary content mods remain composers, not exclusive encounter or difficulty providers. Nuzlocke evaluates the final merged runtime world. Authored encounters remain intact with Random Encounters OFF; with Random Encounters ON, the player is explicitly asking Nuzlocke to randomize the merged tables.

## Validation

Static/source/package validation only. Runtime confirmation remains required with an encounter-expansion mod and with an editor-generated mod containing a custom map, custom species metadata, and a custom Ball. Save schema and package file set are unchanged.

---

---

# 2.4.22 — General Party Size Limit

Direct child of 2.4.21 DEV.

- Added `Party Size Limit` with selectable active-party capacity 1–6.
- Default 6 preserves vanilla party capacity and full-party auto-box behavior.
- Values below 6 gate catches, gifts, trades, and PC withdrawals before they can increase the active party past the cap.
- Preserved deposits and one-for-one PC moves/swaps; lowering the cap never destructively edits an existing oversized party.
- Extended the cooperative storage-transaction policy and native R/B/Y + Gold PC seams.
- Kept Solo Only, Gym Team Size, and Nuzlocke Loadouts independent.
- No save-schema or package-file-set change.
- Runtime status: TEST REQUIRED in R/B/Y and Gold.

---

# 2.4.21 — Travel Restrictions

Direct child of 2.4.20 DEV.

- Added `Travel Restrictions` with `NORMAL / NO FLY / NO FLY+TELEPORT`.
- Reused the existing shared `fieldmove.eligibility` seam instead of adding a second field-move wrapper.
- NO FLY blocks only player-invoked Fly while Nuzlocke is active; NO FLY+TELEPORT blocks Fly and Teleport.
- Preserved Dig, Escape Rope, scripted/story transportation, map warps, trains, ferries, and unrelated travel.
- Preserved Dungeon Lock-In's independent DIG/TELEPORT/FLY blocking while its entrance lock is active.
- Kept Travel Restrictions outside Nuzlocke Loadout ownership.
- Default is NORMAL; no save-schema change.
- Runtime status: TEST REQUIRED in R/B/Y and Gold.

---

# 2.4.20 — Limited Shiny Clause

Direct child of 2.4.19 DEV.

## Added / changed

- Upgraded Shiny Clause to `OFF / 1 / 2 / 3 / UNLIMITED`.
- Added persistent `shiny_clause_used` run telemetry.
- Successful shiny exceptions consume exactly one limited allowance; failed catch attempts do not.
- Historical boolean ON is read as UNLIMITED and OFF as OFF, preserving old-save behavior without a schema bump.
- Exhausted limited clauses stop bypassing area/Failed Encounter/Dupes restrictions.
- Mid-run limit changes do not reset the used counter.
- Shiny Clause remains outside Nuzlocke Loadout ownership.

## Validation

- Save schema unchanged.
- Package file set unchanged.
- Runtime R/B/Y + Gold confirmation required.

---

# 2.4.19 — Evolution Limits

Direct child of 2.4.18 DEV.

## Added

- Added **Evolution Limits** with NORMAL / NO FINAL / NO EVOLUTION for R/B/Y and beta Gold.
- NORMAL preserves vanilla evolution behavior and is the absent-key/default value.
- NO FINAL blocks evolution into a terminal target derived from the live merged `pokemon[*].evolutions` graph; branching targets are evaluated independently.
- NO EVOLUTION blocks all ordinary evolution decisions while Nuzlocke is active.
- Unknown/incomplete mod-added target metadata fails open instead of being guessed terminal.
- Enforcement uses the public shared `evolution.check` hook.
- Evolution Limits remains independent of Nuzlocke Loadout preset ownership.

## Validation

- Save schema unchanged.
- Package file set unchanged.
- Runtime R/B/Y + Gold confirmation required.

---

# 2.4.18 — Nuzlocke Loadout synchronization

Direct child of 2.4.17 DEV.

## Added / changed

- Added **VANILLA** loadout with neutral values for only loadout-owned challenge rules.
- Added pre-apply loadout confirmation showing the number of rules that will change and a compact affected-rule preview; Cancel is non-destructive.
- Manual edits to loadout-owned rules now reclassify to the exact matching preset or CUSTOM.
- Independent rules no longer force a loadout to CUSTOM.
- Reduced loadout ownership to the actual challenge footprint; Dupes, Shiny Clause, Type Locke, Maximum BST, glitch handling, Gym/Dungeon Lock-In, Difficulty, Randomizer, World Building, QoL, UI, area splits, Badge Boosts, and other independent options are not preset-owned.
- Preserved historical saved IDs 1-4 for NUZLOCKE/HARDCORE/SOLO/IRONMON; VANILLA is ID 5 and is inserted first only in UI cycle order.
- Preset application skips externally delegated rules and matching ignores those delegated rows.

## Validation

- Save schema unchanged.
- Package file set unchanged.
- Runtime R/B/Y + Gold confirmation required.

---

# 2.4.17 — Badge Boosts toggle

Direct child of 2.4.16 DEV.

## Added

- Added **Badge Boosts ON/OFF** under Battle Mechanics for R/B/Y and beta Gold.
- Default is ON, preserving vanilla behavior and making absent-key/old-save migration safe.
- OFF reuses the existing battle-only badge-boost suppression machinery; earned badges and overworld progression are untouched.
- Built-in difficulty composition is restrictive: either Badge Boosts OFF or a profile with `noBadgeBoosts=true` suppresses boosts.
- Active-rule status shows **No Badge Boosts** only while the user-facing rule is OFF.

## Scope / validation

- No other backlog feature was implemented.
- Save schema remains 4 and the package file set was unchanged during build development.
- Source/static validation only until R/B/Y and Gold runtime tests confirm ON/OFF behavior.

---

# 2.4.16 — Gen1 numeric edit-hint repair

Direct child of 2.4.15 DEV.

## Fixed

- R/B/Y numeric rule edit mode no longer hides its control instructions behind unreachable draw logic.
- The edit hint is now rendered inside the selected numeric-rule branch, where `editingNumber` can actually be true.
- Numeric edit controls themselves are unchanged: Left/Right select a digit, Up/Down change the value, A confirms, and B backs out.
- Gold's already-working edit-mode hint path was unchanged during build development.

## Validation

- Static/syntax smoke only; runtime R/B/Y UI confirmation remains TEST REQUIRED.
- Save schema remains 4 and package file set was unchanged during build development.

---

# 2.4.15 — G1RecompMods compatibility hardening

Direct child of 2.4.14 DEV.

- Audited `zeak6464/G1RecompMods`, focusing on Delta Type 1.2.0, Dex Overflow 0.1.1, Safari Zone All 1.1.0, and Wonder Trade 1.2.1.
- Added `typeLockAllowsPokemon(game, mon)` and changed concrete-mon legality paths to prefer runtime Pokémon typing over the base species record. This prevents transformed Pokémon from being judged by stale species typing while keeping starter/setup candidate checks species-based.
- Failed Encounter handling, live capture denial, acquisition evaluation when a mon object is supplied, and NUZ INFO legality now use the concrete-mon Type Locke evaluator.
- Added a separate Gold random-encounter runtime-safety check. Gold encounter randomization may now select complete merged species records without `def.index`, enabling string-id species such as Dex Overflow's runtime-safe additions.
- The relaxed index rule is intentionally limited to encounter-table replacement. Starter, script-byte, save-byte, and link assumptions are not globally relaxed.
- Wired audited local compatibility adapters into MOD COMPAT discovery when another mod publishes no explicit Nuzlocke relationship metadata. Explicit external declarations still win.
- Added scoped Safari All ownership metadata and observe-only Wonder Trade metadata.
- Added `delta_type`, `dex_overflow`, `safari_all`, and `wonder_trade` as optional dependencies for deterministic load ordering without making any required.
- Gen1Recomp audit target remains 0.1.99; manifest remains `>=0.1.86 <0.2.5`; save schema unchanged.
- All new combination behavior is **TEST REQUIRED**. No new runtime PASS is claimed.

---

# 2.4.14 DEV — Gen1Recomp 0.1.99 documentation/compatibility cleanup

Direct child of 2.4.13.

- Source-audited the current Gen1Recomp 0.1.99 mod-author documentation, Gen2 compatibility matrix, registries, manifest/link semantics, public battle/field APIs, and current source-level hook additions relevant to Nuzlocke.
- Updated executable audited-engine metadata from 0.1.98 to 0.1.99 and added a dedicated 0.1.99 compatibility profile.
- Corrected `contextual_field_actions` metadata to `transitive_native_guard`; Nuzlocke does not wrap `mod.world:useFieldAction` itself.
- Records the new Gen 1 `item.use` BagMenu-dispatch hook as available but not authoritative; existing item policy enforcement remains unchanged.
- Records shared `battle.bottom_ui_visible` and `battle.status_hud_visible` presentation seams for battle-HUD coexistence/future encounter-HUD work.
- Added explicit `affects_link: true` because Nuzlocke modifies battle decisions and must participate in Gen1Recomp link fingerprinting.
- Fixed `mod.card`: historical text outside its Lua return table made the 2.4.13 card unparsable.
- Rebuilt current README/API/compatibility/user-guide/confidence documentation around actual 2.4.14 code and reconciled the planned backlog against implemented features.
- Clarified that Permanent Rule Seal has retained durable implementation but is currently WIP-disabled.
- Reviewed AIRivials 2.1.0 and Floating Battle HUD 0.5.7 at the accessible release/repository level; no speculative adapters were added because current implementation source lives in release assets unavailable to the connected source audit.
- All five shipped `.lua` files and repaired `mod.card` pass available `texlua` syntax/loadfile checks. `manifest.json` parses and all literal package-local `mod:read()` targets exist.
- Package file tree remains unchanged at 15 files; save schema remains 4.
- Full Gen1Recomp `modkit validate/lint/gen2check` and runtime certification remain unavailable/not run in this environment, so no new runtime PASS is claimed.

### Reconciled historical subrecord — 2.4.14 — Gen1Recomp 0.1.99 documentation + compatibility cleanup

Direct child of 2.4.13.

- Synchronized current compatibility metadata/docs to Gen1Recomp 0.1.99.
- Corrected contextual field-action ownership metadata to `transitive_native_guard`.
- Recognized the Gen 1 `item.use` dispatch and shared battle HUD visibility hooks without replacing protected enforcement paths.
- Explicitly declared `affects_link=true` for link fingerprint safety.
- Repaired malformed `mod.card` content and reconciled active documentation/backlog state.
- No gameplay-rule or save-schema rewrite; no new runtime PASS claimed.

---

# 2.4.13 — dedicated Gold parity pass

Direct child of 2.4.12.

- Audited the shared R/B/Y rule surface against Gold's implemented adapters and policy seams.
- Fixed a real Gold parity/UI gap: four rules that already had shared Gold-capable enforcement were omitted from `goldBetaRules` and therefore could not be configured from Gold's reduced rule surface.
- Gold now exposes **No Healing Items**, **No X Items**, **No Center Heal**, and **No Mom Heal**.
- Added Gold-specific descriptions for all four newly exposed rules.
- No new enforcement subsystem was invented: battle item legality continues through the shared item-use policy, while Center/Mom healing continues through the existing shared healing-service gates.
- Updated the exported Gold compatibility contract to identify battle-item and healing-service parity surfaces.
- Preserves Kanto Ascendant 6.5.4, Wilds of Kanto 2.1.7, and Modern Party UI 0.3.8 compatibility work from prior builds.
- Manifest remains `>=0.1.86 <0.2.5`, five patch versions ahead of the audited Gen1Recomp 0.1.99 engine.
- Save schema unchanged.
- Newly exposed Gold rule paths remain **TEST REQUIRED** until runtime validated.

---

# 2.4.12 — Kanto Ascendant 6.5.4 compatibility

Direct child of 2.4.11.

- Re-audited Kanto Ascendant against the v6.5.4 source/tag.
- Explicitly classifies Kanto Ascendant as an external difficulty owner for its badge-phased trainer and wild level transforms.
- Explicitly classifies Kanto Ascendant as a Trainer Card presentation owner.
- Prevents Nuzlocke compatibility composition from treating Ascendant-owned difficulty surfaces as unclaimed and reduces the risk of double-transforming trainer/wild difficulty when Ascendant is the selected external provider.
- Leaves Ascendant's `trainer.party`, `encounter.species`, deterministic randomizer, Johto pool expansion, protected encounters, followers, Archive PC, and storage behavior untouched.
- Preserves the 2.4.11 Wilds of Kanto and Modern Party UI adapters.
- Manifest remains `>=0.1.86 <0.2.5`.
- Save schema unchanged.
- Kanto Ascendant 6.5.4 coexistence is **TEST REQUIRED**; no runtime PASS is claimed yet.

---

# 2.4.11 — Wilds of Kanto + Modern Party UI compatibility

Direct child of 2.4.10.

- Added an audited compatibility adapter for **Wilds of Kanto 2.1.7** (`overworld_wild_spawns`).
- Wilds overworld Ball catches now consult Nuzlocke capture policy before the Pokémon is granted. Denied catches are converted to Wilds' normal escape path and the consumed Ball is refunded.
- Successful Wilds overworld catches are routed through Nuzlocke's existing `pokemon.caught` tracker/provenance path so One Per Area, tracker history, Catch Info, shiny/dupes metadata, and provider provenance use the same registration code as normal catches.
- Added explicit **Modern Party UI 0.3.8** (`modern_party_ui`) compatibility classification. It is treated as party presentation only; Nuzlocke does not replace or double-wrap its preserved engine party controller.
- Added both mods as optional dependencies so load ordering is explicit without making either mod required.
- Preserves 2.4.10 Forgiveness Token pricing behavior and all prior runtime-PASS behavior.
- Manifest remains `>=0.1.86 <0.2.5`.
- Save schema unchanged.
- Wilds overworld-catching integration and Modern Party UI coexistence are **TEST REQUIRED**; no runtime PASS is claimed yet.

---

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

---

# 2.4.9 RC — difficulty hardening + Forgiveness modal correction

Direct child of 2.4.8 RC.

- Decoupled `noBadgeBoosts` from `aiTier`, so badge-boost suppression now applies independently even for future profiles with `aiTier = 0`.
- Gen 1 private battle badge state is cleared before the AI-tier gate; Gold no longer depends on `trainer.attributes` being available for the independent badge-boost flag.
- Corrected the R/B/Y Forgiveness prompt's opaque panel rendering: it now paints its own panel/window instead of calling nonexistent `mod.ui.clear` / `game:clear` APIs.
- Preserves the 2.4.8 RC Gen1Recomp `>=0.1.86 <0.2.1` compatibility range and all unrelated behavior.

---

# 2.4.8 RC — launcher compatibility + battle feedback cleanup

- Direct child of 2.4.7 RC.
- Expanded launch compatibility from `>=0.1.86 <0.1.99` to `>=0.1.86 <0.2.1`, fixing 0.1.99 rejection and explicitly allowing 0.2.0.
- Hardened the R/B/Y Forgive Encounter prompt as an opaque Nuzlocke-owned screen so underlying battle/party HUD content does not bleed through.
- Gym Team Size refusal text is now limited to once per individual trainer-battle attempt. There is no new setting/toggle. Enforcement remains active on every over-limit attempt.
- Added semantic encounter-count status based on the same authoritative encounter eligibility used by Failed Encounter/capture rules. Dupes and other free encounters are not marked as spending the area.
- No global battle/menu draw monkey-patches were added.
- Runtime validation required before publication.

---

# 2.4.7 RC — provider load-order metadata fix

- Direct child of 2.4.6 RC.
- Added `gen1_modern_ui` and `gen_2_randomizer_plus` to `optional_dependencies`; both are actively discovered with `mod.find`.
- They remain optional integrations.
- Chuck → Pryce → Jasmine progression is documented intentional behavior and was unchanged during build development.
- No unrelated gameplay changes.

---

# 2.4.6 RC — Gym Forgiveness activity guard

- Direct child of 2.4.5 RC.
- Fixed the confirmed missing `d.active()` guard in `awardGymLeaderForgiveness`.
- Demo/ghost battles are rejected before the one-shot Gym reward ledger/token path.
- Focused trainer-reward ledger audit found no second same-confidence defect.
- No unrelated gameplay changes.

---

# 2.4.5 RC — Summon / Quest System compatibility pass

- Direct child of the exact uploaded 2.4.4 RC.
- Source-reviewed Summon 1.0.2 and Quest System 1.0.5.
- Summon now classifies as both external encounter start and targeted encounter selector.
- Quest System now classifies as quest framework/presentation rather than generic quest-content ownership.
- Individual quest/source mods retain their own content and reward ownership.
- MOD COMPAT adds QUEST UI and QUEST DATA ownership rows.
- No named-mod gameplay enforcement branches added.
- Wide Menus runtime PASS remains protected and its integration code was unchanged during build development.
- Runtime testing required before publication.

---

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

---

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

---

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

---

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

---

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
- Compatibility-audited current behavior for Pokémon Snag, Too Many Balls, Translation Generator, Shiny Pokémon, Weather FX, Gen 3 Inspired UI, Advanced Box System, Pokédex Plus, and historical IronMON / Enemy HP evidence.

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

---

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

---

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

---

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

---

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

---

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

---

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

---

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

---

# 2.3.27 RC — NUZ INFO stabilization

- Direct child of 2.3.26 RC.
- Fixed ordinary R/B/Y Pokémon incorrectly falling into `DETAIL SAFE MODE`.
- Root cause was an early `getPokemonNuzInfo()` closure referencing the later local `Identity` module; Lua resolved a nil global before `pcall` could catch anything.
- The public NUZ INFO model now performs self-contained read-only shiny detection from explicit flags or the engine Stats DV predicate.
- Shortened only the constrained native Catch Info row label from `LOCATION` to `LOC.`.
- Added glyph-safe right-column fitting to R/B/Y native NUZ INFO rows to prevent label/value overlap.
- No gameplay shiny logic, legality rules, encounter behavior, save schema, Compatibility API number, package tree, or engine range changed.

---

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

---

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

---

# 2.3.24 RC — IronMON / Enemy HP upstream-resolution pass

- Direct child of 2.3.23 RC.
- Re-ran canonical-upstream discovery for historical IronMON Ultimate and Enemy HP compatibility entries.
- Confirmed surviving evidence only identifies IronMON Ultimate 0.4.20 as an evaluated package and Enemy HP as an uploaded/runtime-tested archive.
- GitHub, public-web, and File Library searches did not resolve trustworthy current Gen1Recomp repositories for either historical package.
- Kept the historical `ironmon_ultimate` provider ID compatibility path intact.
- Did not conflate the actively maintained community IronMON Ultimate challenge rules with the unresolved Gen1Recomp mod source.
- No gameplay, compatibility API, save schema, package tree, or engine-range changes.

---

# 2.3.23 RC — compatibility status consolidation

- Direct child of 2.3.22 RC.
- Consolidated the compatibility documentation into one current status table.
- Normalized current compatibility-audit entries for Pokemon Snag 0.15.9, Too Many Balls 0.6.1, Translation Generator 0.7.0, Shiny Pokemon 1.0.1, Weather FX 2.6.0, and Gen 3 Inspired UI Overhaul 2.0.0.
- Explicitly marks IronMON Ultimate and Enemy HP as historical-package-only until their current canonical upstreams can be resolved and reviewed.
- Clarified the distinction between source-reviewed, release-reviewed, expected-compatible, runtime-PASS, and historical evidence.
- No gameplay, UI behavior, API, save schema, package tree, or engine-range change.

---

# 2.3.22 RC — generic UI-overhaul compatibility contract

- Direct child of 2.3.21 RC.
- Compatibility-audited absol89's Gen 3 Inspired UI fork (1.4.1) and the current HighDrexler parent (2.0.0).
- Added additive `nuzlocke_ui` API 1 describing Nuzlocke custom-screen presentation roles, state ownership, preferred layout, native fallback and semantic-adapter safety.
- NuzlockeConfigScreen and NuzlockeTrackerScreen now carry the same generic presentation metadata on their live screen instances.
- No Gen-3-UI-specific rule branch, gameplay ownership change, screen replacement, save-schema change, Compatibility API number change or package-tree change.

---

# 2.3.21 RC — Weather FX compatibility-learning pass

- Direct child of 2.3.20 RC.
- Reviewed Weather FX 2.6.0 release behavior.
- Added `map.entered` reconciliation for transient Dungeon Lock-In ownership so out-of-band map/teleport providers cannot leave a stale dungeon lock record active in the save.
- Reconciliation validates against the actual current dungeon family and also clears state when Nuzlocke/Dungeon Lock-In is disabled.
- Exported the reconciliation helper through the existing compatibility surface.
- No Weather-FX-specific enforcement branch, rule semantics, save-schema, Compatibility API number, package tree, or engine-range change.

---

# 2.3.20 RC — translation/performance compatibility learning pass

- Direct child of 2.3.19 RC.
- Reviewed gen1recomp-translation-mod-generator 0.7.0 and Shiny Pokemon 1.0.1.
- Added `nuzlocke_translation.sources()` and `catalog()` so translation tooling can enumerate live Nuzlocke section titles, rule names, short names, and descriptions from canonical rule definitions.
- ENC TRACKER now performs projection/cleanup/row preparation once per update and shares one read-only snapshot across native R/B/Y, Gold, and Modern UI presentation.
- Modern UI tracker model generation no longer mutates tracker/save state itself.
- Existing tracker-row helpers keep their original maintenance behavior for non-screen callers.
- No rule semantics, save schema, Compatibility API number, package tree, or engine range changed.

---

# 2.3.19 RC — recent-mod compatibility pass

- Direct child of 2.3.18 RC.
- Reviewed Pokemon Snag 0.15.9 and Too Many Balls 0.6.1.
- Added first-class `trainer_capture` acquisition semantics, including SNAG/TRAINER_CATCH aliases.
- Cooperative No Catching policy now covers trainer-capture attempts.
- Tracker provenance labels successful trainer-battle captures as `trainer_capture`.
- Public Item API now classifies custom Balls with the same semantic detector used by enforcement instead of a vanilla Ball ID list.
- Added descriptive legacy auto-compat hints for trainer-capture and custom-Ball providers.
- No mod-ID-specific enforcement branches, files, save-schema, or engine-range changes.

---

# 2.3.18 RC — smaller-risk presentation bug-fix pass

- Direct child of 2.3.17 RC.
- Fixed the R/B/Y Difficulty profile row's nil fallback displaying profile index 1 instead of VANILLA/index 0.
- Shared Nuzlocke marquee text now scrolls by engine font glyph spans rather than raw Lua bytes, preventing split UTF-8 translation characters.
- Recover Catches route-name fitting is now glyph-span safe.
- MOD COMPAT native fitting no longer byte-truncates translated text when font span helpers are unavailable.
- No rule, battle, save, encounter, provider, startup, API, schema, or package-tree changes.

---

# 2.3.17 RC — small bug-fix pass

- Direct child of 2.3.16 RC.
- Gold status/rule labels now clip with engine font glyph spans and pixel width instead of raw Lua byte counts, avoiding split UTF-8 translation characters.
- Gold egg provenance no longer registers or marks a synthetic UNKNOWN area as visited when current map resolution fails; UNKNOWN remains provenance-only.
- Removed a dead delegated-learnset condition after the authoritative-provider early return.
- No gameplay-rule, file-tree, API, or save-schema changes.

---

# 2.3.16 RC — medium-risk bug-fix pass

- Direct child of 2.3.15 RC.
- Completed nil-area capture-policy hardening in the actual catch path.
- Explicit gift/trade/prize provenance now outranks fallback starter heuristics.
- Repaired the logically unreachable duplicate-starter catch fallback.
- Gold Physical/Special Split now scopes temporary type/category changes to copied per-call damage data.
- No new features, files, API version, or save-schema changes.

---

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

---

# 2.3.13 RC — ENC TRACKER hotfix candidate

- Direct child of the published 2.3.12 release.
- Corrects the diagnosis of the 2.3.12 ENC TRACKER crash: it reproduces with Modern UI disabled, while Wide Menus was observed to prevent it.
- R/B/Y ENC TRACKER now requests the same 304x144 UI surface that Wide Menus supplied on the working path.
- R/B/Y tracker full-screen box expands from 20 to 38 tiles to match that surface.
- Gold tracker presentation remains native 20x18 / 160x144.
- No tracker data, save, rule, input, boot-lifecycle, Compatibility API, or save-schema changes.
- Runtime validation required before promotion.

---

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

---

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


### Reconciled historical record: 2.3.11 RC


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

---

# 2.3.9 RC — public Yellow title/setup UI diagnostic

- Direct child of 2.3.8 RC.
- Yellow + Gen1Recomp 0.1.98 + Nuzlocke 2.3.8 only: **runtime PASS to title**.
- The absent Nuzlocke Setup row in 2.3.8 was expected because setup registration remained disabled.
- Restores only `src.core.Strings`, one minimal `NuzlockeConfigScreen`, and the public `ui.title_menu.items` hook that inserts SETUP before NEW GAME when CONTINUE is absent.
- Does **not** load `title_setup_compat.lua`, save/setup-profile state, gameplay events, rule enforcement, randomizers, or other split integrations.
- Test target: Yellow 0.1.98 should boot, show SETUP on a fresh title menu, open the diagnostic setup screen, allow basic cursor input, and return with B.

---

# 2.3.8 RC — initializer-boundary diagnostic

- Direct child of 2.3.7 RC.
- Yellow + Gen1Recomp 0.1.98 + Nuzlocke 2.3.7 only: **runtime PASS to title**.
- Restores only the normal `return function(mod) ... end` initializer execution model from 2.3.6.
- The initializer performs static export-table assignments only.
- No engine-module `require()`, event registration, save/storage access, hooks/patches, content writes, title modifications, or split integrations execute.
- Diagnostic only; gameplay remains intentionally disabled.
- No files added or removed.

---

# 2.3.7 RC — boot-safe loader diagnostic

- Direct child of 2.3.6 RC.
- Yellow 2.3.6 recorded as pre-title runtime FAIL.
- Replaced active `main.lua` execution with inert diagnostic exports only.
- No engine-internal requires, gameplay hooks, content writes, UI hooks, or split integrations execute.
- Package tree, manifest permissions, optional dependencies, game targets, and 0.1.98 engine range remain unchanged so the test isolates loader/package compatibility.
- Diagnostic only; gameplay is intentionally disabled.
- No files added or removed; save schema documentation remains historical and no save migration runs.

---

# 2.3.6 RC — pre-2.3 behavior compatibility probe

- Direct child of 2.3.5 RC.
- Yellow 2.3.5 recorded as pre-title runtime FAIL.
- Restored specific installer definitions/timing from the directly compared pre-2.3 baseline.
- Restored the existing title Setup compatibility fallback; this is separate from the deferred opening-intro shortcut.
- Repaired the accidentally removed `ItemPolicy.install()` definition from 2.3.3-2.3.5.
- Removed remaining 2.3-only Gen II healing-classifier additions for this diagnostic.
- Skip Opening Intro and Quick Nuzlocke Start remain removed.
- No files added or removed; save schema remains 4.

---

# 2.3.5 RC — 0.1.98 executable compatibility bisect

- Direct child of 2.3.4 RC.
- Yellow 2.3.4 recorded as pre-title runtime FAIL with all other mods disabled.
- Intro skip and Quick Start remain removed and are no longer the leading crash hypothesis.
- Temporarily disabled the executable 2.3.x public battle/contextual-field integrations and broad Gold item-policy additions while keeping 0.1.98 in the manifest range.
- Kept 2.3.3's safer deferred installer timing.
- No files added or removed; save schema remains 4.

---

# 2.3.4 RC — defer startup shortcuts / Yellow boot isolation

- Direct child of 2.3.3 RC.
- Removed active **Skip Opening Intro** implementation and setup control.
- Removed active **Quick Nuzlocke Start / Start With Poké Balls** implementation and setup control.
- Removed their Oak-speech step filtering, one-shot save staging, progression reconciliation, warp/nickname transaction, delegation entries, Gold exposure, and world-building text.
- Kept **Default Names** and **Skip Catch Demo** intact.
- Kept all unrelated 2.3.x Gen1Recomp 0.1.98 compatibility fixes.
- Yellow 2.3.3 pre-title crash recorded as runtime FAIL; 2.3.4 requires a title-screen-only retest.
- No files added or removed; save schema remains 4.

---

# 2.3.3 RC — Yellow pre-title boot-safety isolation

- Direct child of 2.3.2 RC.
- 2.3.0, 2.3.1, and 2.3.2 recorded as Yellow pre-title runtime FAIL on Gen1Recomp 0.1.98 with other mods disabled.
- Disabled invocation of the legacy 0.1.86 TitleState fallback; public `ui.title_menu.items` remains authoritative.
- Deferred non-title engine-internal installers until map/save/battle lifecycle points.
- No files added or removed; save schema remains 4.

---

# 2.3.2 RC — Gold trainer-ball policy scoping

- Clarified that `wide-menus` remains an intentional optional dependency for passive classic-layout coexistence; the historical 304px claimed-wide adapter remains disabled.

- Direct child of 2.3.1 RC.
- Gold's broad 0.1.98 battle-item denial pass now skips Balls entirely; the existing catchable-battle branch is the sole owner of Ball/capture policy.
- Prevents `No Catching` or other capture-specific Nuzlocke text from replacing native trainer-battle Ball behavior.
- Uses dynamic `ItemPolicy.isBall(...)` classification so custom/merged Ball records follow the same scope.
- Corrected `contextual_field_actions` seam metadata from `compose` to `transitive_native_guard`; Nuzlocke does not wrap `mod.world:useFieldAction` directly.
- No files added or removed. Save schema remains 4.

---

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


### Reconciled historical record: 2.3.1 RC — Yellow New Game startup hotfix

- Direct child of 2.3.0 RC.
- Records 2.3.0 Yellow New Game as runtime FAIL on Gen1Recomp 0.1.98.
- Removes eager pre-overworld `mod.battle` / `mod.world` capability probing from the title/New Game path.
- Defers the new 0.1.98 field-action backstop until `map.entered`, when a real overworld exists.
- Preserves the 2.3.0 No Fishing, Gold item-policy, Gen II healing classification, and battle-snapshot interoperability work.
- Runtime retest required; static checks are not runtime PASS.

---

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

---

# 2.2.20 RC — opening intro skip

- Direct child of 2.2.19 RC; no older branch restored.
- Added NEW GAME-only **Skip Opening Intro** under QoL; default OFF.
- Uses the upstream `intro.oak_speech.build` named-step hook instead of replacing New Game or setting progression flags.
- R/B/Y retain only hidden player/Rival name steps, which resolve through the existing canonical Default Names adapter.
- Gold retains `init_clock` plus the hidden player-name step; its later Rival naming story remains native.
- Added external ownership capability `opening_intro_skip_provider` / `tutorial_qol_provider`.
- Permanent Rule Seal does not affect the QoL option.
- No files added or removed; save schema remains 4.

---

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

---

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

---

# 2.2.17 RC — external Difficulty stacking warnings

- Direct child of 2.2.16 RC; no older branch restored.
- Game Difficulty now prepends a visible warning whenever an active external trainer/difficulty mod is not the selected exclusive provider.
- VANILLA explicitly warns that it disables only Nuzlocke's built-in transforms and does not disable Stronger Trainers or another external trainer mod.
- Built-in historical/NUZ MEDIUM profiles show **STACK WARNING** when an external trainer mod remains active underneath the composed trainer party.
- Selecting one external `[MOD]` provider while another trainer provider is active shows **MULTI-MOD WARNING**.
- Selecting Stronger Trainers `[MOD]` removes the Stronger-Trainers warning; selection remains manual and Nuzlocke never silently changes Difficulty ownership.
- Known historical providers (`stronger_trainers`, `ironmon_ultimate`, `indigo_conference`) are now queried directly through `mod.find` in addition to status/discovery scans.
- Save schema remains 4; package tree unchanged. Runtime UI/combination validation required.

---

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

---

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

---

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

---

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

---

# 2.2.11 RC — Difficulty implementation audit

- Audited every built-in Game Difficulty profile against its live code path.
- Fixed built-in trainer Stat EXP and perfect-DV settings: these fields were previously attached as metadata by `trainer.party` but were not consumed by trainer construction.
- Built-in Difficulty now owns trainer starting Stat EXP/DVs independently of the Nuzlocke master switch and independently of the manual Trainer Stat EXP / Perfect Trainer IV controls.
- External difficulty providers retain ownership of their constructed Pokemon; Nuzlocke does not overwrite their trainer stats.
- Removed the inert built-in AI labels (`smart`/`strong`/`max`). The current engine/provider path did not consume those labels, so documentation no longer implies an AI change that is not actually enforced.
- Historical `*` profiles remain explicitly inspired profiles, not byte-identical reproductions. Their currently enforced native dimensions are trainer levels, trainer starting Stat EXP, perfect DVs where selected, and live boss-cap preview through the composed trainer party.

---

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

---

# 2.2.9 — hardening RC

- Direct child of 2.2.8 RC.
- Compiler safety thresholds: warning at 40 upvalues / 130 locals; hard ceiling 48 upvalues / 160 locals.
- Split the near-limit late-runtime initializer again to create compiler headroom.
- Added a defensive empty-party POKEMON-menu guard for the runtime-confirmed full-wipe CTD.
- Made Dungeon Lock-In's dungeon-to-different-dungeon transition explicit and re-seed destination-family state.
- Removed erroneous Gold Zinc handling and centralized the five native vitamins.
- Clarified Wild-to-caught Player Stat EXP ownership.
- Preserves 2.2.8 dialogue and live Difficulty-cap repairs.

---

# 2.2.8 — dialogue ownership and live Difficulty cap repair

### Historical subrecord — 2.2.8 RC
- Direct child of 2.2.7 RC.
- Runtime reproduced duplicated/stiched vanilla Yellow SNES dialogue at World Building Tier 3.
- Removed the global T3 rewrite of vanilla `show_text` / `ask` `\v` continuation text.
- Preserved Nuzlocke-authored T3 formatting/ownership via the existing shared world-text paths.
- Fixed live boss-cap preview for Nuzlocke's own built-in Difficulty profiles by allowing `trainer.party` composition preview when a non-Vanilla internal profile is active.
- Clear observed boss-level cache entries when Difficulty changes at runtime.
- Preserved 2.2.7's split late-runtime closures and kept both phases below the Lua 5.1 upvalue ceiling.
- No file additions/removals, save-schema change, API change, engine-range change, or rule-default change.

---

# 2.2.7 — confirmed Lua 5.1 upvalue-limit startup repair

### Historical subrecord — 2.2.7 RC

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

---

# 2.2.6 — confirmed Lua local-limit startup repair

### Historical subrecord — 2.2.6 RC

- Direct child of 2.2.5 RC.
- Runtime error screen confirmed that `main.lua` was rejected at compile/load time due to Lua's per-function local-variable ceiling.
- Corrected the incomplete 2.2.5 diagnosis: 2.2.4's extra renderer table was removed there, but 2.2.3 had already introduced another long-lived local helper.
- Converted `skipCatchTutorialRequested` from a local function to an internal `mod.exports.__beta26` function, preserving behavior without consuming another local slot in the giant mod entry function.
- Updated all Yellow/RBY/Gold catch-tutorial skip call sites to use the same internal helper.
- Preserved the 2.2.4 native Pokémon Bois Club walker repair.
- Preserved the 2.2.3 NUZ INFO completeness work.
- No save schema, Mod API, engine range, permissions, rule defaults, or package file-tree change.
- Fresh NEW GAME Setup runtime retest required.

---

# 2.2.5 — startup/local-limit regression repair

### Historical subrecord — 2.2.5 RC

- Direct child of 2.2.4 RC.
- Investigated a runtime report that New Game Nuzlocke Setup no longer appeared.
- Confirmed 2.2.4 added one extra long-lived local (`fanClubBryanSprites`) to the already-local-heavy `main.lua`.
- Removed that additional file-scope local to avoid crossing Lua 5.1's 200 active-local ceiling.
- Moved temporary Pokémon Bois Club renderer ownership state onto the chairman NPC itself.
- Preserved the 2.2.4 native-walker behavior and third-party ownership-safe restore semantics.
- No setup logic, save schema, engine range, API version, permissions, or package file tree change.
- New Game Setup runtime retest required.

---

# 2.2.4 — Pokémon Bois Club native-walker repair

### Historical subrecord — 2.2.4 RC

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

---

# 2.2.3 — Yellow catch-demo hardening + NUZ INFO completeness

### Historical subrecord — 2.2.3 RC

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

---

# 2.2.2 — battle-money label + Yellow runtime ledger

### Historical subrecord — 2.2.2 RC

- Direct child of 2.2.1 RC; no older branch was restored.
- Renamed compact Trainer Money from `Trnr ¥` to `Btl. ¥`.
- Recorded Yellow 2.1.24 save-game runtime PASS for No Buying.
- Recorded Yellow 2.1.24 save-game runtime PASS for No Selling.
- Recorded Yellow 2.1.24 save-game runtime PASS for No Center Heal / Pokémon Center healing ban.
- No rule mechanics, API/save schema, permissions, engine range, or repository file tree changed.

---

# 2.2.1 — Gold value-column visual correction

### Historical subrecord — 2.2.1 RC

- Direct child of 2.2.0 RC; no older branch was restored.
- Gold 2.1.24 runtime testing confirmed the right-aligned Setup/NUZ RULES value column was one native tile too far right and could crowd/clip the frame.
- Preserved the wider ten-tile Gold rule-label field and moved only the live value/toggle anchor one tile left.
- R/B/Y presentation and all rule/enforcement behavior are unchanged.
- Gen1Recomp 0.1.94 audited compatibility, NUZ INFO/MOD COMPAT/NUZ ST. repairs, Yellow catch-demo work, and native Bryan path from 2.2.0 are preserved.
- Runtime visual RETEST REQUIRED for Gold NEW GAME Setup and in-game NUZ RULES.

---

# 2.2.0 — Gen1Recomp 0.1.94 compatibility and runtime repair rollup

### Historical subrecord — 2.2.0 RC

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

---

# 2.1.24 — R/B/Y NUZ INFO native-menu crash repair

### Historical subrecord — 2.1.24 RC
- Direct child of 2.1.23 RC.
- Yellow 2.1.23 runtime PASS: randomized starter message names the actual received Pokemon; randomized Sandslash appears correctly in party; Trainer Money shows the money symbol.
- Yellow 2.1.23 runtime FAIL: selecting party NUZ INFO crashes.
- R/B/Y NUZ INFO now renders through host-owned `ListMenu` using API-27 `getPokemonNuzInfo()` / `getNuzInfoPages()` data instead of the custom hand-drawn screen.
- Gold NUZ INFO presentation was unchanged during build development.
- Runtime retest required.

---

# 2.1.23 — systemic T3 dialogue + catch-demo repair

### Historical subrecord — 2.1.23 RC

- Direct child of 2.1.22 RC; no files added or removed.
- Runtime reports showed the same continuation/stitched-dialogue presentation in Mom, Viridian catch-tutorial, Oak's Lab, and other interactions. Replaced one-off T3 text fixes with a shared World Building paginator used by every Nuzlocke-owned overworld message.
- At World Building T3, ScriptRunner `show_text` / `ask` rows that use Gen1's native `\v` continuation marker are presentation-normalized through the same paginator. Story commands, substitutions, choices, flags, and program-counter flow are unchanged; T0-T2 preserve vanilla continuation behavior.
- R/B/Y Skip Catch Demo is now implemented at the semantic `old_man_demo` command used by Red/Blue and Yellow. Only the demonstration battle is skipped; surrounding vanilla dialogue, completion flags, movement, and object cleanup continue normally. Gold retains its separate Route 29 tutorial seam.
- Gold Setup/NUZ RULES values are now right-aligned to the native screen edge. Short ON/OFF toggles move farther right, rule labels regain a tenth tile, and long money/type values retain up to seven tiles.
- TV's currently runtime-good T3 path remains on the shared World Building presenter and was not replaced with a new special case.
- Runtime validation required, especially Yellow Mom/Lab/tutorial dialogue, R/B/Y catch-demo progression, and Gold Setup spacing.

---

# 2.1.22 — R/B/Y Nuz menu native-surface repair

### Historical subrecord — 2.1.22 RC

- Direct child of 2.1.21 RC; no files added or removed.
- Logged Yellow 2.1.21 runtime FAIL: NUZ ST. and MOD COMPAT still hard-crash.
- R/B/Y NUZ ST. now uses the host mod-facing ListMenu and presents caught/death/area/cap status plus the active-rule list.
- R/B/Y MOD COMPAT now uses ListMenu and preserves compatibility ownership rows.
- Removed the two failing R/B/Y paths from hand-drawn custom-state rendering/stack timing; Gold-native status/compat rendering was unchanged during build development.
- Preserved all confirmed 2.1.19 Yellow PASS paths and 2.1.21 Gold Setup spacing.
- Runtime validation required.

---

# 2.1.21 — Gold Setup spacing cleanup

### Historical subrecord — 2.1.21 RC

- Direct child of 2.1.20 RC; no files added or removed.
- Gold Setup/NUZ RULES now reserve one native tile between the rule-label field and value/toggle field.
- Preserved the seven-tile Gold value column so money values and longer type labels retain their previous display capacity; only the label field was reduced from 10 tiles to 9.
- Presentation-only change: no rule mechanics, save keys, controls, descriptions, R/B/Y layout, or 2.1.20 menu-recovery behavior changed.
- Runtime visual confirmation required on Gold Setup and Gold in-game NUZ RULES.

---

# 2.1.20 RC

- Direct child of 2.1.19 RC; no files added or removed.
- Recorded Yellow 2.1.19 runtime PASS: NEW GAME Setup appears; Type Locke selector visibility behaves correctly; automatic default names work; PC Heal/rare-candy/vitamin startup grants work; native Trainer Card opens without the prior crash.
- Recorded Yellow 2.1.19 runtime FAIL: entering a Nuzlocke-owned in-game menu can hard-crash.
- Hardened NUZ RULES runtime recovery so a draw exception is recorded during draw and handled on the next update tick. The old guard could pop the state from inside `draw()`, which is unsafe while the engine is iterating/rendering the StateStack.
- Added the same deferred runtime-failure recovery to the standalone R/B/Y NUZ STATUS screen.
- Moved Game Difficulty out of LEVELS into its own GAME DIFFICULTY section. VANILLA is still the unmodified/OFF-equivalent setting; no difficulty save/API semantics changed.
- UI labels: `Trnr ¥`, `Start ¥`, `No Esc. Rope`, and `Heal Loadout`.
- Re-audited Type Locke legality: OFF returns no allowed-type filter; MONO returns only Type 1; DUO returns only Types 1-2; TRI returns only Types 1-3. Actual runtime acquisition enforcement is still TEST REQUIRED.

---

# 2.1.19 RC — compatibility/lifecycle hardening

- Direct child of `2.1.18 RC`; no older branch was restored.
- Removed the active-generation precondition from Gen1 kerning installation retries. Installation now retries whenever Font is not yet wrapped and no external kerning provider owns the surface; `kerningEnabled()` still gates all visual effect to confirmed Gen1 at call time.
- Hardened Gen1 Modern UI registration so only an explicit `true` from `registerAdapter` counts as success. `nil` or any other non-true value leaves the integration inactive/unregistered with an error state.
- Reworked the R/B/Y title SETUP fallback into one stable wrapper backed by mutable dependency state, preventing Nuzlocke wrapper re-stacking and stale `openSetup`/translation/save-editor closures across hot reloads.
- Added safe migration from the exact 2.1.18 legacy wrapper when it is still directly installed; when another mod sits above that legacy wrapper, the new outer stateful wrapper rebinds the existing Nuzlocke SETUP row to the current callback instead of inserting a duplicate.
- Preserved the runtime save-editor check on every title-menu open; no install-time editor short-circuit was reintroduced.
- No challenge-rule mechanics changed. No files added or removed. Runtime validation remains required.

---

# 2.1.18 — Yellow runtime hardening: native Trainer Card + dialogue ownership

- Direct child of `2.1.17 RC`; no older branch was restored.
- Logged Yellow 2.1.16 runtime: default-name skip PASS; PC Vitamins starter loadout PASS; opening the Nuzlocke-hijacked Trainer Card FAIL/crash.
- Stopped replacing the native R/B/Y Trainer Card START-menu row. The engine Trainer Card is now upstream-owned again.
- Added a dedicated `NUZ ST.` START-menu entry for R/B/Y, matching Gold's separated status approach. The Gen1 status screen can run in `statusOnly` mode without constructing the native Trainer Card at all.
- Added generic per-ScriptRunner Nuzlocke message ownership so overlapping enforcement/compatibility seams cannot emit two mod-authored denial/flavor boxes for one script transaction.
- Audited the reported bedroom SNES sequence against Gen1Recomp and pret/pokered: the repeated visible line is vanilla `cont` scrolling from `_RedBedroomSNESText`, not duplicated Nuzlocke World Building. Vanilla text scrolling is therefore intentionally preserved.
- Existing `pushWorldText` protection against stacking optional World Building over an active TextBox remains in force.
- No files added or removed. Runtime validation remains required.

---

# 2.1.16 — Trilocke, Type Locke invariants, rule-section cleanup

- Direct child of `2.1.15 RC`.
- Added **TRI / Trilocke** with a third displayed type selector.
- Type Locke is now explicitly mode-authoritative: OFF = no type restriction and no selectors; MONO = Type 1 only; DUO = Types 1–2 only; TRI = Types 1–3 only.
- Random type resolution and live/staged edits keep every active displayed type concrete and distinct.
- Shared acquisition legality, off-type encounter handling, gifts/trades, starter filtering, and legality reporting all consume the same active Type Locke set.
- Moved **Route Forgiveness** from CORE to CLAUSES and **No Catching** from CORE to GENERAL; mechanics are unchanged.
- Added +1 px micro-tracking to centered bold-like section headers so adjacent glyphs retain separation.
- No files added or removed. Runtime validation remains required.

---

# 2.1.15 — Rules UI alignment, Type Locke OFF, reversible Rule Lock

- Centered R/B/Y and Gold rule-section headers inside the list area and added subtle bold-like emphasis using the existing pixel font only.
- Shifted ordinary R/B/Y rule labels left to reclaim menu space while retaining the native selection cursor.
- Type Locke OFF now clears and hides both Type 1 and Type 2; MONO keeps Type 1 only; DUO restores two distinct selectors.
- Restored a reversible **Rule Lock** control, separate from the dormant/WIP irreversible **Permanent Rule Seal**.
- Added migration logic for older non-permanent `rules_locked` state when no irreversible seal marker exists.
- No files added or removed. Runtime validation remains required.

---

# 2.1.14 — Type Locke MONO state/UI repair

- Direct child of `2.1.13 RC`.
- Gold 2.1.12 runtime reproduction: selecting Type Locke MONO left `Type 2` visible.
- MONO now clears the staged/live secondary type and hides the Type 2 row.
- Returning to DUO restores a valid secondary type distinct from Type 1.
- Shared config code means the repair applies to R/B/Y and Gold, Setup and in-game Rules.
- Runtime status: **TEST REQUIRED**.

---

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

---

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

---

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

---

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

---

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

---

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

---

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

---

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

---

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

---

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

---

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

---

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

---

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

---

# 2.1.0 — canonical versioning transition

- Renumbered the current canonical `2.0.0-beta.31.0.4` development tree to `2.1.0`.
- No gameplay, save-schema, Mod API, compatibility, UI, or rule behavior changed.
- This establishes ordinary SemVer for future Gen1Recomp GitHub Release/update detection.
- The complete pre-2.1.0 beta lineage remains preserved below as historical development history.
- Full 15-file repository tree preserved.

---

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

---

# 2.0.0-beta.31.0.3 — Mt. Moon Dungeon Lock-In repair

- Direct child of `.31.0.2`; full 15-file tree preserved.
- Fixed the reported R/B/Y case where the Pokémon Center beside Mt. Moon could be classified as the `MT_MOON` dungeon family and trap the player under Dungeon Lock-In.
- Hardened `dungeonFamily()` before prefix matching: Pokémon Center and Poké Mart service-interior identifiers fail open instead of inheriting a dungeon family from a landmark prefix.
- The exclusion is deliberately generic so similarly named dungeon-adjacent service interiors do not reproduce the same prefix-bleed bug.
- Actual Mt. Moon floor identifiers remain classified as `MT_MOON`; existing Dungeon Lock-In entrance/exit behavior is otherwise unchanged.
- Lua parser/static/mock classifier checks PASS; reported Mt. Moon Center scenario remains RUNTIME TEST REQUIRED.

---

# 2.0.0-beta.31.0.2 — Gen1Recomp 0.1.90 compatibility review

- Direct child of `.31.0.1`; full 15-file repository tree preserved.
- Reviewed upstream `v0.1.89...v0.1.90` changes.
- Confirmed the existing manifest envelope `>=0.1.86 <0.1.91` already admits 0.1.90.
- Upstream 0.1.90 primarily adds orphaned save-slot recovery and generation-aware PartyMenu field-move handling for Gold, plus platform/test hardening.
- Nuzlocke's SaveData use remains on engine-owned `saveFilename`, `activeSlot`, `deleteSlot`, and `persistenceFs` seams; no direct filesystem regression was introduced.
- Gold's new PartyMenu fallback to generic `overworld:useFieldMove(...)` is compatible with Nuzlocke's current rule architecture and is a useful future seam for deeper Dungeon Lock-In field-move hardening.
- No Nuzlocke mechanic required patching for 0.1.90; this build records the reviewed compatibility baseline.
- Lua parser/static PASS; runtime on Gen1Recomp 0.1.90 remains TEST REQUIRED.

---

# 2.0.0-beta.31.0.1 — lifecycle and progression repair

- Direct child of `.31.0.0`; 15-file tree preserved.
- Synchronizes live `difficulty_profile` changes with staged stable `difficulty_provider_id` state and documents why live changes leave `pendingRulesDirty=false`.
- Makes Modern UI registration generation-safe and one-shot, prevents unknown-game registration, marks the bridge inactive on Gold, and generation-gates model/actions so stale provider registrations cannot present Gen1 UI on Gold.
- Removes the install-time save-editor short-circuit from R/B/Y title Setup fallback so the installed wrapper can re-check editor state on every title-menu open.
- Trainer Rewards now validates `gymProgressKey`, returns `true` after recognized R/B/Y Gym Leader progression, and compares Gym Leader identity fields independently to prevent cross-field concatenation false matches.
- Champion progression already returned `true` in `.31.0.0` and was intentionally left unchanged.
- Lua parser/static checks PASS; runtime validation remains required.

---

# 2.0.0-beta.31.0.0 — World Building / Bryan expansion

- Direct child of `.30.1.22`; no repository files added, removed, or renamed.
- Expanded Tier 3 Pokémon Bois Club Bryan dialogue.
- Bryan explicitly claims he created the Nuzlocke mod and worked on Gen1Recomp using the player's bedroom computer.
- Tier 3 home flavor establishes Bryan as a recurring houseguest who uses the player's computer and game console.
- Added cheeky, non-graphic Mom/Bryan relationship innuendo at Tier 3.
- Added rotating Tier 3 Pallet TV reports, including sightings of a man resembling the Pokémon Bois Club leader walking Pallet Town and sneaking through windows at night.
- Polished several Tier 3 rule-specific World Building lines for greater contextual variety.
- No Black Market shop or achievement-reactive NPC/rule system is mechanically enabled in this build.
- Lua parser/static validation PASS; new dialogue paths remain RUNTIME TEST REQUIRED.

---

# 2.0.0-beta.30.1.22 — Tracker / Compat / NUZ INFO intelligence

- Direct child of `2.0.0-beta.30.1.21`; no repository files added, removed, or renamed.
- Encounter Tracker / Area Guide now display compact semantic encounter tags such as WILD, FISH, GIFT, STATIC, TRADE and RNG, with provider context where known. Randomizer information remains spoiler-safe.
- MOD COMPAT now reports a broader effective-ownership map: starter/encounter/learnset RNG, trainer money, level caps, difficulty profile, species metadata, Pokémon identity, encounter provider, escape/warp provider, movement, presentation and text layout.
- NUZ INFO Catch page now reports legality against the **current active rules** plus restriction reasons and provider/source provenance.
- NUZ INFO legality is read-only: it never removes, boxes, edits or reclassifies an existing Pokémon.
- Corrected stale internal build identifiers inherited from `.30.1.21`; all executable build exports now identify `.30.1.22`.
- Lua parser/static validation PASS; new UI behavior remains RUNTIME TEST REQUIRED.

---

# 2.0.0-beta.30.1.21 — compatibility intelligence and contextual guidance

- Added spoiler-safe external encounter-randomizer ownership context to Encounter Tracker.
- Added the dedicated MOD COMPAT ownership diagnostics screen.
- Expanded translation-safe semantic UI matching.
- Added merged external species metadata access.
- Added adaptive compatibility/tracker presentation helpers.
- Added context-sensitive World Building guidance for consumed areas, Lock-Ins, caps, Forgiveness Tokens, progression catches and externally randomized areas.


### Reconciled historical record: 2.0.0-beta.30.1.21


- Added spoiler-safe randomizer ownership context to Encounter Tracker.
- Added dedicated MOD COMPAT ownership diagnostics screen.
- Expanded translation-safe semantic menu matching.
- Added merged external species metadata export.
- Added adaptive compatibility/tracker presentation helpers.
- Added context-sensitive World Building guidance API.


This file records cumulative release history. When an exact per-build delta is uncertain, it is labeled rather than guessed.

---

# 2.0.0-beta.30.1.20 — Gen1 variable-width Nuzlocke presentation

- Added internal R/B/Y-only variable-width tile-font presentation.
- Gold/Gen2 is hard-excluded from the Gen1 glyph transform.
- Compatible existing kerning ownership is not double-applied.
- Presentation only; challenge mechanics and save semantics were unchanged.

---

# 2.0.0-beta.30.1.19 — surviving packaged revision

- Surviving release evidence confirms that a packaged `2.0.0-beta.30.1.19` revision existed between `.30.1.18` and `.30.1.20`.
- The exact per-build feature delta has not been recovered from a trustworthy changelog/source snapshot, so no behavior is attributed to this revision here.
- This heading exists to preserve confirmed lineage without inventing historical details.

---

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

---

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

---

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

---

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

---

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

---

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

---

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

---

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

---

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

---

# 2.0.0-beta.30.1.9

Gold level-cap ordering repair, directly from 30.1.8.

## Fixed — Johto middle-Gym cap regression

The current `gscStages` list had regressed to:

`Chuck 30 -> Jasmine 35 -> Pryce 31 -> Clair 40`

That reintroduced a non-monotonic raw stage ladder. The runtime cap floor could prevent the enforced value from physically dropping, but direct stage readers and boss presentation could still observe Pryce's raw 31 after Jasmine's 35.

Earlier release history records the intended repair from beta.27.15: the cap-progression order is:

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

---

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

---

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

---

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

---

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

---

# 2.0.0-beta.30.1.4

Runtime-method crash diagnostic, built directly from 30.1.3.

- 30.1.3 still crashed without showing its guarded-construction error box.
- This strongly suggests `NuzlockeConfigScreen` is constructing/pushing successfully and failing on its first runtime frame rather than during `mod.ui.push`.
- Wrapped the configuration screen instance's `update()` and `draw()` methods with protected calls.
- On a Lua runtime failure, the faulty instance disables itself, attempts to pop, and shows `NUZ SETUP UPDATE ERROR` or `NUZ SETUP DRAW ERROR` containing the underlying error.
- `lastConfigScreenError` is updated with the phase and traceback/error.
- No additional module split or gameplay-rule change.

---

# 2.0.0-beta.30.1.3

Setup/Nuz Rules crash-containment diagnostic based directly on 30.1.2.

- The same Setup crash was reproduced using unchanged, **unsplit** published 29.3.0 gameplay Lua on the current engine. The existing split therefore is not sufficient evidence for the crash cause.
- Current Gen1Recomp's screen resolver pcall-isolates a failed mod screen factory and then attempts a built-in fallback. `NuzlockeConfigScreen` is custom-only, so a construction failure can become a missing-builtin desktop crash.
- Every Nuzlocke Setup/Nuz Rules open now goes through a protected public `mod.ui.push` transaction.
- If construction fails, the game should stay alive and show `NUZLOCKE SETUP ERROR` with the underlying error text.
- The error is retained in `mod.exports.__beta26.lastConfigScreenError`.
- While implementing this guard, adding one more top-level local caused Lua's **200-local compile limit** to fire. The guard is therefore export-backed rather than local. This confirms the monolithic chunk has essentially no local-variable headroom and strengthens the case for another carefully planned split later, but does not by itself explain the current Setup crash.
- No additional split is included in this diagnostic build.

---

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

---

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

---

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

---

# 2.0.0-beta.30.0.0.21

- Percentage-based rule presentation is now consistent across Rules/Setup and Nuzlocke status surfaces.
- Trainer Money uses one shared percentage-label table everywhere: 0%, 25%, 50%, 75%, 100%, 150%, 200%, 300%, 500%.
- Maximum BST is no longer a free-form three-digit editor.
- Maximum BST now cycles through **OFF / 400 / 450 / 500 / 550** with A or Left/Right like other preset controls.
- The enforcement/API contract still uses the actual BST threshold value, not a preset index.
- Older development saves containing a non-preset custom BST value preserve that exact enforcement value until the player changes Maximum BST; the UI marks it CUSTOM, and the next change snaps to the nearest point on the preset ladder before moving in the requested direction.
- No new Lua modules/files added or removed.
- Yellow NUZ vertical placement remains deferred; duplicate-dialogue `.20` fix remains independently RETEST REQUIRED.

---

# 2.0.0-beta.30.0.0.20

- Yellow runtime on 30.0.0.16 reconfirmed the recurring dialogue-page overlap/duplication defect: unrelated vanilla NPC text repeated trailing phrases at the start of subsequent pages.
- This recurrence is now tracked as a protected regression target rather than a one-off.
- Added a global **World Building presentation invariant**: `pushWorldText()` refuses to push optional Nuzlocke flavor text if any `TextBox` is already active on the game state stack.
- Rationale: Gen1Recomp textboxes are foreground/blocking states. Optional nested Nuzlocke text must not interrupt a vanilla dialogue transaction and then resume it at an already-presented page/scroll boundary.
- This guard affects cosmetic World Building presentation only. Mechanical enforcement must not depend on `pushWorldText()` and remains unchanged.
- Direct rule-denial flows that intentionally replace a blocked action remain separate and are not globally suppressed.
- Yellow `NUZ` trainer-card/status vertical placement remains a known deferred cosmetic issue: current position is too low and should later move slightly upward, but not back to its previous overly-high position.
- Permanent Rule Seal remains WIP/grey/unselectable from 30.0.0.19.
- No Lua files/modules added or removed.

---

# 2.0.0-beta.30.0.0.19

- **Permanent Rule Seal moved to WIP/dormant status.**
- The row remains visible but is grey, displays `WIP`, is skipped by cursor navigation, and cannot be activated, matching Wonderlocke's placeholder behavior.
- The complete confirmation, immediate `mod.storage` durability, durable-read, and lifecycle reconciliation implementation remains in `main.lua` behind `mod.exports.__beta26.permanentRuleSealWip = true`; it was not deleted.
- Existing `.17/.18` development-test seals are **not enforced while WIP**, so challenge rules become editable again. Their `rules_permanently_locked` and `rules/permanent_seal` markers are preserved rather than erased.
- Generic setters/presets cannot activate the effective `rules_locked` state while WIP.
- No additional Lua module split was made and no files were added/removed.

---

# 2.0.0-beta.30.0.0.18

- Yellow runtime PASS on 30.0.0.17: Permanent Rule Seal correctly prevented modification of challenge-rule sections while leaving QoL, World Building, and UI/presentation sections editable.
- Yellow runtime FAIL on 30.0.0.17: the permanent seal did not survive exiting/reloading when no subsequent ordinary Pokémon SAVE had persisted `mod.save`.
- Root cause aligned with Gen1Recomp 0.1.86's documented persistence model: `mod.save` is stored inside normal progress and therefore requires an ordinary Pokémon SAVE to become durable.
- Permanent Rule Seal now mirrors its irreversible commitment immediately to playthrough-scoped `mod.storage` under `rules/permanent_seal`.
- On `save.loaded` and `game.ready`, Nuzlocke reconciles the durable storage marker back into `rules_permanently_locked` + `rules_locked`.
- Older saves that already contain the permanent `mod.save` marker are automatically mirrored into durable storage when loaded.
- If playthrough storage is temporarily unavailable, current-session `mod.save` locking still occurs and lifecycle reconciliation retries later.
- No other rule is moved to independent storage; ordinary configurable rules continue to follow the Pokémon SAVE model.
- No new Lua files/modules added or removed.

---

# 2.0.0-beta.30.0.0.17

- Yellow runtime PASS on 30.0.0.16: existing save booted, Nuzlocke menu entries were visible, and in-game Nuz Rules opened successfully.
- Yellow runtime observation: Permanent Rule Seal correctly remained irreversible after activation, but activation safety was too weak.
- Replaced the old one-warning/two-press seal with **two explicit warning stages plus a third deliberate SEAL activation**.
- Warning 1/2 explains irreversibility; Warning 2/2 is a final confirmation; only the next activation commits the permanent seal.
- Moving the cursor away, collapsing/expanding a section, activating another control, or pressing B cancels the staged confirmation.
- Added a short input debounce between confirmation stages to reduce accidental keyboard/gamepad double advancement.
- The description panel now shows the active warning stage in both R/B/Y and Gold, including title Setup where overworld/world-text presentation is unavailable.
- No new Lua modules were added and no existing files were removed.
- Permanent Rule Seal persistence remains monotonic by design once the final confirmation is committed.

---

# 2.0.0-beta.30.0.0.16

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

---

# 2.0.0-beta.30.0.0.15

- **Approved first Lua module split.** Added `title_setup_compat.lua`; no existing file was removed.
- Moved only the 0.1.86 fresh-game title SETUP compatibility fallback out of `main.lua`.
- Uses Gen1Recomp 0.1.86's documented sandbox-safe multi-file pattern: source is read with `mod:read(...)`, compiled with sandboxed `load(...)`, and therefore inherits the mod's sandbox environment.
- Fixes 30.0.0.14's `ambiguous syntax` parser failure by removing the IIFE entirely rather than applying another parser workaround.
- Rationale: 30.0.0.13 hit the large main chunk's parser/local pressure; 30.0.0.14 then introduced an ambiguous statement boundary. Isolating this self-contained compatibility adapter lowers main-chunk pressure and follows upstream's supported multi-file design.
- Expected impact is limited to title/startup SETUP injection. Core rules, saves, encounters, battles, tracker, randomizers, compatibility providers, and Gold gameplay are not intentionally changed.
- **Compatibility confidence is temporarily reduced until runtime tests confirm Blue and Gold startup, Setup selection, existing-save behavior, and representative gameplay.**
- Further Lua splitting requires new explicit user approval.

---

# 2.0.0-beta.30.0.0.14

- Fixed a load-blocking Lua parser failure introduced in 30.0.0.13.
- Root cause: the 0.1.86 title-menu compatibility fallback added enough locals to the already-large top-level `main.lua` chunk to exceed the runtime parser's local-variable ceiling.
- Moved the complete title fallback implementation into a nested immediately-invoked function so its helper locals belong to a separate Lua function build instead of the top-level chunk.
- No title-menu behavior was intentionally changed from 30.0.0.13.
- No gameplay rules, save schema, provider behavior, randomizer behavior, or documentation file set changed.
- Fresh Blue and Gold SETUP runtime test remains required after confirming the mod now loads.

---

# 2.0.0-beta.30.0.0.13

- Compatibility repair for runtime-confirmed missing Nuzlocke SETUP on genuinely fresh Blue and Gold boots under Gen1Recomp 0.1.86.
- Preserves `ui.title_menu.items` as the primary public title-menu integration.
- Adds conservative generation-specific title-list fallbacks that run after normal menu construction and insert SETUP only when there is no CONTINUE row and no existing SETUP row.
- R/B/Y fallback wraps `src.ui.TitleState:openMenu`; Gold fallback wraps `src.ui.gen2.MainMenu:buildList`.
- Fallbacks are idempotent and explicitly refuse duplicate SETUP insertion.
- Existing-save behavior remains unchanged: SETUP stays hidden when CONTINUE/a save is present.
- Narrowed the experimental 30.0.0.12 `<1.0.0` engine range to the actively investigated `>=0.1.86 <0.1.91` family.
- No gameplay-rule, save-schema, randomizer, tracker, or provider-policy behavior intentionally changed.
- Runtime retest required on fresh Blue and Gold saves.

---

# 2.0.0-beta.30.0.0.12

- Future-proofed the manifest engine range from `>=0.1.81 <0.1.85` to `>=0.1.81 <1.0.0`.
- Future Gen1Recomp 0.x patch/minor releases will no longer be rejected solely because their version number crossed our previous ceiling.
- Kept a deliberate `<1.0.0` major compatibility boundary: a future 1.0 may legitimately change contracts and should be reviewed rather than silently trusted.
- Remains Mod API 2 and save schema 4; no gameplay rules or save semantics changed.
- This does not claim unknown future engine releases are runtime-certified. It changes loader policy from exact-patch allowlisting to API-family compatibility.
- No files added or removed.

---

# 2.0.0-beta.30.0.0.11

- Compatibility-only child of 2.0.0-beta.30.0.0.10.
- Expanded the engine compatibility range from `>=0.1.81 <0.1.84` to `>=0.1.81 <0.1.85`, allowing Gen1Recomp 0.1.84 to load the mod.
- Gen1Recomp 0.1.84 still documents Mod API 2 as the current standard, so no API-level migration was made.
- No gameplay rules, save schema, compatibility providers, randomizers, tracker logic, UI behavior, or protected fixes were intentionally changed.
- This build is a minimal boot-compatibility checkpoint so broader 30.0.0.10 work remains preserved for subsequent children.
- Runtime validation on 0.1.84 is required.

---

# 2.0.0-beta.30.0.0.10

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

---

# 2.0.0-beta.30.0.0.9

- Added provider-owned non-core feature delegation in the Nuzlocke Setup/Rules UI.
- When an active provider explicitly owns a duplicate non-core mechanic, Nuzlocke shows its duplicate control as effective OFF, greys the row, and prevents toggling.
- Delegated rows remain selectable so the description panel identifies the handling mod/provider and version.
- Stored Nuzlocke preferences are preserved dormant and automatically become effective again if the external provider is disabled/removed.
- Core Nuzlocke challenge policy is never implicitly delegated: death, One Per Area, Dupes, catch legality, Type Locke, item bans, lock-ins, legendary/mythical/pseudo bans, etc. remain Nuzlocke-owned.
- Initial delegated duplicate mechanics include level caps, starter/encounter/learnset randomizers, running shoes, default naming/tutorial-skip QoL, trainer-money provider, and starting-resource provider capabilities.
- Explicit providers take precedence; legacy/automatic adapters remain fallback-only.
- Added automatic recognition hints for Randomizer, Level Cap, and Running Shoes behavior families.
- Preserved all 30.0.0.8 compatibility consolidation and the Yellow tracker crash repair.

---

# 2.0.0-beta.30.0.0.8

- Consolidated the 30.0.0.3–30.0.0.7 compatibility architecture without adding a new gameplay feature.
- Added canonical provider capability families: `item_provider`, `storage_provider`, `encounter_provider`, `exp_provider`, `registry_consumer`, and `quest_content_provider`.
- Existing legacy capability names remain additive aliases; no provider integration was intentionally broken.
- Added `interop.resolveCapability()` with explicit-provider precedence over automatic legacy adapters.
- Documented provider-owned mechanics vs Nuzlocke-owned challenge policy/provenance.
- Preserved the Yellow Encounter Tracker REMOVE ENTRY serialization repair.
- Preserved FAFF0x QoL, content-provider, randomizer opt-out, and automatic-adapter work.
- No repository files added or removed.
- Compatibility changes remain TEST REQUIRED until the planned runtime certification pass.

---

# 2.0.0-beta.30.0.0.7

- Added the FAFF0x automatic/legacy compatibility adapter layer.
- Scans the active mod graph after `mods.loaded` and describes common behavior families (alternate Bag/item UI, automatic item use, PC UI, external encounter starters, registry consumers, EXP distributors, quest providers, reusable machines) without using those names as enforcement branches.
- Explicit provider registration still wins; automatic adapters only fill gaps for released mods that predate the Nuzlocke API.
- Added passive Pokémon acquisition reconciliation after game/save readiness so externally granted Pokémon can be surfaced as scripted/provider acquisitions instead of being silently treated as vanilla catches.
- Added convenience adapter gates for external item use, encounter starts, PC actions, and effective-registry snapshots.
- Automatic acquisition reconciliation is observational and never deletes externally granted Pokémon.
- Preserved 30.0.0.5 Yellow tracker crash repair and 30.0.0.6 quest/content provider APIs.
- Runtime certification remains deferred.

---

# 2.0.0-beta.30.0.0.6

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

---

# 2.0.0-beta.30.0.0.5

- Fixed a fatal Encounter Tracker recovery/removal path reported on an existing Yellow save originating from beta.29.3.16.
- Root cause: the legacy-recovery UI could attach a live Pokémon object directly to a persisted `tracker_log.__LEGACY__` entry, then serialize that contaminated tracker table during REMOVE ENTRY.
- Legacy recovery rows are now detached UI views; live Pokémon references never mutate persisted tracker records.
- Added a narrow migration sanitizer that removes only known transient UI fields (`mon`, `logEntry`, `savedEntry`) from legacy tracker records before tracker serialization.
- Manual recovery now maps detached UI rows back to their original saved record explicitly.
- No catch history, provenance, encounter-rule semantics, or unrelated tracker behavior was rewritten.
- Runtime status: FIX IMPLEMENTED / RETEST REQUIRED, especially Yellow existing-save REMOVE ENTRY.

---

# 2.0.0-beta.30.0.0.4

- Expanded Interop API v1 for the FAFF0x QoL compatibility pass.
- Added `itemPolicy.beforeUse/canUse/check/checkUse` for Modern Bag, Item Shortcut, Repel Reuse, favorites and other alternate item-use paths.
- Added `acquisitionPolicy.begin/commit` and explicit acquisition kinds for DexNav, Summon and scripted providers.
- Added `encounterPolicy.evaluate` convenience entry for external encounter starters.
- Added `pcPolicy.evaluate/can` for alternate PC/box UIs; dead Pokémon remain unusable without trapping ordinary PC navigation.
- Added registry revision counters and `registry.describe()` for Pokédex Plus/Moves Manager-style consumers.
- Added EXP cap discovery helper while preserving provider-owned distribution.
- Bridged selected new APIs through legacy `nuzlocke_compat` exports.
- No hardcoded FAFF0x IDs added. All runtime certification remains deferred.

---

# 2.0.0-beta.30.0.0.3

- Added public `mod.exports.nuzlocke` interoperability API v1.
- Added capability/provider registration instead of hardcoded mod-name compatibility.
- Added acquisition classification/evaluation for wild, gift, trade, starter, scripted, editor, summon, quest, forced, and Wonder Trade sources.
- Added public item-policy evaluation for alternate Bag/shortcut/automatic-use UIs.
- Added effective Pokémon/encounter/move/learnset registry access plus registry-change notifications.
- Added a post-distribution EXP ownership seam so EXP providers can own distribution while Nuzlocke retains cap enforcement.
- Random Encounter/Learnset transforms now notify registry consumers.
- FAFF0x collection is now an explicit first-class compatibility target, implemented through capabilities rather than FAFF0x IDs.
- All new interop paths are TEST REQUIRED.

---

# 2.0.0-beta.30.0.0.2

- Added **No Fishing** under Field Items; blocks rod use before fishing begins while leaving rod ownership and non-fishing encounters untouched. Includes tiered Kanto/Johto world-building. Gold is TEST REQUIRED.

---

# 2.0.0-beta.30.0.0.1

- Added Random Encounters with persistent per-slot species rolls.
- Added Random Learnsets with persistent per-species/per-slot move rolls.
- Added Learnset Gen: AUTO / GEN1 / GEN2.
- Preserves encounter levels/structure and learnset levels/size.
- Reversible runtime-registry transforms reapply after load/provider lifecycle events.
- No repository files added or removed.
- New paths are TEST REQUIRED.

---

# 2.0.0-beta.29.3.16 — Nuz Info / Compatibility API 27

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

---

# 2.0.0-beta.29.3.15 — Rule UI / Dialogue / Gold QoL

- Direct child of `2.0.0-beta.29.3.14`.
- Added a LEVELS section for Game Difficulty, Level Cap Scope, and EXP Edging.
- Kept BATTLE ITEMS limited to actual battle-item-use rules; moved No Catching to Core and No Escape to General.
- Clarified Player/Wild/Trainer Stat EXP defaults and the 0/25/50/75/100/200 challenge preset scale.
- Exposed Gold-only Skip Cherrygrove Tour QoL while preserving the native MAP CARD reward/cleanup tail.
- Expanded Rare Candy, TM, and field-healing rejection dialogue with item/move-aware World Building text.
- No Catching remains the only selectable capture-ban rule; the retired Ball tier remains migration-only.
- Compatibility API remains 26; save schema remains 4.
- Changed paths remain TEST REQUIRED.

---

# 2.0.0-beta.29.3.14 — Gold Runtime Repair

- Direct child of `2.0.0-beta.29.3.13`.
- Fixed Gold START-menu compact-label selection using the hook-supplied game.
- Rebuilt Gold No Buying / No Selling around native Mart entry and transaction seams.
- Split Random Starter preview from committed starter identity; Gold Elm portrait/cry now matches each ball's persisted randomized preview.
- Hardened Gold starter New Bark Town provenance and added conservative reconciliation for the narrow older UNKNOWN case.
- Clarified Gold Stat EXP descriptions while keeping native 0% defaults.
- Repository tree, save schema 4, Compatibility API 26, Mod API 2, and engine range are unchanged.
- Changed paths remain TEST REQUIRED until runtime retest.

---

# 2.0.0-beta.29.3.13 — migration / master-switch / compatibility hardening

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

---

# 2.0.0-beta.29.3.12 — Type Locke / encounter accounting stabilization

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

---

# 2.0.0-beta.29.3.11 — Pokemon Bois Club world-building pass

- Rolled directly from `2.0.0-beta.29.3.10`; repository files remain the same set.
- Added a **Tier 3 World Building** cosmetic rebrand for Vermilion's **Pokemon Fan Club**, presenting it as the **Pokemon Bois Club** when World Building is set to T3.
- Added safe T3-only dialogue/sign rewording for the club in R/B/Y and Gold without changing item rewards, story flags, yes/no branches, or Bike Voucher / Rare Candy transactions.
- Added a custom **Bryan-the-Boi tribute chairman sprite** for the T3 presentation path while preserving vanilla presentation at lower World Building tiers.
- This pass is cosmetic only; no rules, encounter legality, save schema, or compatibility API behavior changed.
- New Pokemon Bois Club presentation paths are **TEST REQUIRED** until runtime validated.

---

# 2.0.0-beta.29.3.10 — Type Locke + No Day Care

- Rolled directly from `2.0.0-beta.29.3.9`; repository tree unchanged.
- Added **Type Locke** as a shared `OFF / MONO / DUO` framework for Monolocke and Duolocke runs.
- Added separate **Type 1** and **Type 2** selectors using a stable 17-type Gen 1+2 index.
- Type legality reads live merged species data first and optional species-metadata provider data second; unreadable custom schemas fail open.
- Off-type wild encounters are rejected without consuming an encounter area or Route Forgiveness Token.
- Shiny Clause does not bypass Type Locke.
- Native gift/trade acquisition gates now include Type Locke legality where a pre-transaction seam exists.
- Random Starter filters candidates through the selected Type Locke when possible while preserving the mandatory starter progression-safe fallback.
- Added **No Day Care**. R/B/Y blocks new deposits at the hand-ported Day Care interaction; Gold blocks new deposits at `Breeding.canDeposit`.
- Existing Day Care occupants remain retrievable; Gold existing parent/Egg state is preserved.
- Added complete T1/T2/Kanto-T3/Johto-T3 World Building entries for Type Locke selectors and No Day Care.
- Corrected Permanent Rule Seal boundaries: challenge rules remain sealed; Game Difficulty, World Building, QoL, and presentation controls remain adjustable.
- Compatibility API remains 25, save schema remains 4, Mod API remains 2, and engine range remains `>=0.1.81 <0.1.84`.
- New Type Locke and No Day Care paths are **TEST REQUIRED** until runtime validated.

---

# 2.0.0-beta.29.3.9 — Gold-native custom UI integration

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

---

# 2.0.0-beta.29.3.8 — World Building parity + cleanup

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

---

# 2.0.0-beta.29.3.7 — split Nuzlocke loadout / game difficulty

- Separates **Nuzlocke Loadout** from **Game Difficulty**. Difficulty selection no longer changes Permadeath, encounter, healing, or other Nuzlocke rules.
- Game Difficulty defaults to **VANILLA** and is changeable mid-game until the Permanent Rule Seal is applied.
- Adds **NUZ MEDIUM**, the mod's own moderate trainer profile.
- Adds two documented ROM-hack-inspired choices per supported game. A `*` suffix means an inspired compatibility profile, not a byte-identical reproduction of the source hack.
- Active compatible trainer/difficulty providers are appended as `[MOD]` choices and remain authoritative for their own composed trainer parties.
- Built-in difficulty profiles operate on future composed trainer parties and preserve explicit moves supplied by another trainer/content provider rather than overwriting them.
- Renames the irreversible configuration control to **Permanent Rule Seal** in the player-facing UI while retaining the existing save representation.
- All new difficulty behavior is **TEST REQUIRED**.

### Historical subrecord — 2.0.0-beta.29.3.7

- Added optional EXP Edging: cap-blocked EXP is banked per Pokemon and released through the normal EXP path when a later authoritative cap allows it.
- Added Difficulty selector groundwork: VANILLA / NUZ / HARD / EXT, with capability-first discovery of active external difficulty/cap providers. External providers are never enabled, disabled, or guessed solely by mod name.
- Gold exposes both systems through its separate backend; all new behavior is TEST REQUIRED.


### Reconciled historical record: 2.0.0-beta.29.3.7 — Gold compatibility smoke pass


- Rolled directly from 2.0.0-beta.29.3.4; no repository files added or removed.
- Static smoke audit rechecked Gold-specific capture, nickname, Mart, field-item, catch-tutorial, gift, static, gambling, Whiteout, egg, roamer, and Nuz Status adapters.
- Gold adapters remain generation-scoped and fail-open when an upstream seam is unavailable.
- Route Forgiveness and No Catching remain TEST REQUIRED on Gold pending runtime validation.
- Existing R/B/Y runtime-PASS behavior was not intentionally changed.

---

# 2.0.0-beta.29.3.3

- Rebased sequentially from the recovered 29.3.1 package while reconstructing the 29.3.2 compatibility intent; no repository files added or removed.
- Added Route Forgiveness setup states: OFF, enabled with 0 starting tokens, or enabled with 1 starting token. Non-Leader Gym Trainers award one token once per trainer. Eligible failed encounters consume a token before an area is marked failed; Dupes never consume the area or a token.
- Added Trainer Money scaling: 0/25/50/75/100/150/200/300/500%, applied to the final composed trainer payout. Default is vanilla 100%.
- Made Rule Lock permanent/monotonic per save with a second-confirmation step. Locked rules remain viewable; runtime state continues to update.
- Reworked startup defaults: NUZLOCKE is now the default mode, FAMILY Dupes and Shiny Clause are enabled by default, and Nickname Rule remains part of the conventional core. Hardcore keeps Champion caps, battle healing/X-item restrictions, First Rival Mercy OFF and Whiteout loss, but Gym/Dungeon Lock-Ins remain optional rather than being silently bundled into Hardcore.
- Published the Forgiveness Token aspirational shop price as 1,000,000 (one above the native 999,999 wallet ceiling) for shop/UI integrations. Native cross-generation Mart stock injection remains TEST REQUIRED and is not claimed as runtime PASS.
- New behavior in this build is TEST REQUIRED; existing runtime-confirmed PASS behavior remains protected.

### Historical subrecord — 2.0.0-beta.29.3.3

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

---

# 2.0.0-beta.29.3.0

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

---

# 2.0.0-beta.29.2.7

- R/B Random Starter selection confirmation now names the persisted randomized species, with the existing Dex preview and actual grant bound to the same roll.
- Added protected pre-battle trainer-party preview for known runtime trainer-balance composition so Trainer Card and Encounter Log can show the actual next boss ace before the fight starts.
- Gym Lock-In and Dungeon Lock-In moved from World to the Ironmon/Hardcore challenge section; rule behavior was unchanged during build development.
- Cleaned up the optional early Oak-lab Rival line to avoid repeating the later post-battle "toughen it up" idea.
- Preserves Yellow in-game section glyphs and Running Shoes/QoL placement confirmed by runtime testing.

---

# 2.0.0-beta.29.2.6

- Audited compatibility with Indigo Plateau Conference v1.0.2 (Gold).
- Trainer-party observation now runs outside normal priority-0 content wrappers, so Nuzlocke records the final composed tournament party rather than observing vanilla before a downstream replacement.
- Gold trainer-data inspection now understands the canonical `game.data.gen2Trainers.classes` shape while retaining the existing R/B/Y trainer registry path.
- Added a narrow Indigo Conference adapter declaration: its Colosseum NPC/state/CANLOSE flow remains tournament-owned; Nuzlocke retains death, rules, tracker, and Whiteout ownership.
- Scripted post-battle healing is allowed for surviving Pokemon, while already Nuzlocke-dead party members are reasserted at 0 HP after battle/map reconciliation.
- No IPC map, NPC, trainer, event-flag, tournament-state, or save keys are patched or overwritten.

---

# 2.0.0-beta.29.2.5 — focused common-route split rules

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
- Mt. Moon and Safari split behavior was unchanged during build development.
- Runtime migration and ON/OFF reprojection tests are required before public release.

---

# 2.0.0-beta.29.2.3 — finite-number and review hardening

- Built directly from beta.29.2.2.
- Sanitizes non-finite numeric Setup/profile inputs (`NaN`, positive infinity, negative infinity) at rule normalization and profile-copy boundaries, falling back to established defaults before clamping/persistence.
- Adds a serializer defense-in-depth guard so a non-finite number cannot be emitted as a persisted Setup-profile literal even if it bypasses earlier normalization.
- Leaves normal gameplay arithmetic unchanged; this is corrupted/external-input hardening rather than a change to EXP, level caps, Stat EXP, or battle math.
- Preserves beta.29.2.2 Gym/Dungeon Lock-In, trainer-cap compatibility hardening, and all beta.29.2.1 determinism/Permadeath fixes.
- Expands repository-only review rationale and regression obligations for investigated technical edge cases that did not justify production changes.

---

# 2.0.0-beta.29.2.2 — lock-in and trainer-cap compatibility hardening

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

---

# 2.0.0-beta.29.2.1 — determinism and Gym-Leader Permadeath hardening

- Built directly from beta.29.2.0.
- Made split-area re-projection deterministic instead of allowing merged representative encounter state to depend on Lua table iteration order.
- Added a post-finish Permadeath reconciliation pass so special/Gym trainer teardown cannot restore a Pokémon already marked dead during battle.
- Structural release-gate coverage was expanded for both fixes; exact runtime validation remained required.

---

# 2.0.0-beta.29.2.0 — status semantics and native UI polish

### Goal

Turn the narrow beta.29.1.1 money checkpoint into a broader player-facing update while preserving the published beta.29.1.0 behavior baseline and every runtime-protected path.

### Changed

- Carries forward beta.29.1.1's R/B/Y fresh-start money correction: missing/unset Money defaults to **$3,000**, while an explicit **$0** remains valid.
- Collapsible SETUP/NUZ RULES category headers now use Gen1Recomp's theme-aware native directional glyphs instead of ASCII `+` / `-`. Collapsed uses the native sideways cursor glyph; expanded uses the native more/down glyph.
- New Pokémon-death history rows now use `status = "DEAD"` instead of overloading `"LOST"`.
- Existing saves are migrated conservatively: legacy `LOST` history rows are rewritten to `DEAD` only when they carry death evidence such as a death location/cause/opponent.
- Failed/fled/KO'd eligible encounters remain represented separately by `encounter_states[area].status = "FAILED"` and feed **LOST ENC.** counts.
- Run-over summaries now label the owned-Pokémon counter as **DEATHS** / **LAST DEATH** rather than LOST, while the underlying legacy `nuzlocke_losses` save key remains intact for save compatibility.
- Clarified historical version notes for beta.19, beta.21, beta.27.3, beta.27.8, and beta.27.9 where release evidence supports the attribution.

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

---

# 2.0.0-beta.29.1.1 — fresh-start money default hotfix

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

---

# 2.0.0-beta.29.1.0 — Gen1Recomp 0.1.83 compatibility profile

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

---

# 2.0.0-beta.29.0.2 — reviewed acquisition and provenance bug fixes

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

---

# 2.0.0-beta.29.0.1 — release packaging and documentation

- Built directly from beta.29.0.0 with no intended gameplay behavior change.
- Reorganized the release around a lean player distribution and a separate repository/tooling layout.
- Added a dedicated `docs/USER_GUIDE.md` exhaustive player manual while refocusing `README.md` as the repository landing page and quick-start guide.
- Expanded the README feature highlights/recent-major-features presentation so the repository front page advertises the collective current ruleset rather than only the current packaging delta.
- Added `mod.card`, `.modkitignore`, structured issue forms, developer API documentation, feature-confidence tracking, and a versioned compatibility guide.
- Updated manifest metadata to identify the maintained repository, use the `BALANCE` category, and target Red/Blue/Yellow/Gold explicitly.
- Removed the legacy generation-wide Gen 2 target from the candidate manifest so Silver/Crystal are not implied.
- Rebuilt the cumulative changelog so every known revision remains represented, including revisions whose exact per-build delta is only partially recoverable.
- Current candidate remains targeted to the audited Gen1Recomp 0.1.81 line; newer engine compatibility is not claimed by this build.

---

# 2.0.0-beta.29.0.0 — beta.29 development-line baseline

- Created directly from beta.28.20 with no intended gameplay changes.
- Established the beta.29 player-package baseline.
- Recorded current runtime evidence for Gold Setup/collapsible sections and Yellow existing-save navigation/collapsible sections.

---

# 2.0.0-beta.28.20 — temporary-party compatibility hardening

- Built directly from beta.28.19.
- Hardened Permadeath against trainer systems that temporarily narrow/reorder the player party and restore it during battle teardown.
- Whiteout now re-evaluates the restored real post-battle party so healthy reserves prevent a false run-ending Whiteout.
- Restored dead Pokémon are reconciled after temporary-party restoration rather than remaining usable.

---

# 2.0.0-beta.28.19 — preserved development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not been fully recovered from surviving release records. Preserved later history places beta.28.17–28.19 in an aggregate hardening period that included party-menu composition protection, checkpoint/savestate reconciliation of runtime-only observations, and additional wrapper/restoration safeguards before beta.28.20's temporary-party fix.
- Those aggregate changes are deliberately **not** assigned to one specific .17/.18/.19 build without stronger evidence.

---

# 2.0.0-beta.28.18 — preserved development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not been fully recovered from surviving release records. Preserved later history places beta.28.17–28.19 in an aggregate hardening period that included party-menu composition protection, checkpoint/savestate reconciliation of runtime-only observations, and additional wrapper/restoration safeguards before beta.28.20's temporary-party fix.
- Those aggregate changes are deliberately **not** assigned to one specific .17/.18/.19 build without stronger evidence.

---

# 2.0.0-beta.28.17 — preserved development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not been fully recovered from surviving release records. Preserved later history places beta.28.17–28.19 in an aggregate hardening period that included party-menu composition protection, checkpoint/savestate reconciliation of runtime-only observations, and additional wrapper/restoration safeguards before beta.28.20's temporary-party fix.
- Those aggregate changes are deliberately **not** assigned to one specific .17/.18/.19 build without stronger evidence.

---

# 2.0.0-beta.28.16 — menu-label clarity

- Renamed the in-game mod-menu entries to **ENC TRACKER** and **NUZ RULES**.
- No intentional gameplay behavior change was associated with the label cleanup.

---

# 2.0.0-beta.28.15 — numeric-rule correctness

- Corrected Maximum BST and the Player/Wild/Trainer Stat EXP selectors being treated as booleans instead of numeric/multi-state rules.
- Retained the lexically scoped Stat EXP/DV implementation used to stay below Lua 5.1 active-local limits.

---

# 2.0.0-beta.28.14 — compiler/runtime regression repair

- Confirmed that the reported missing Blue SETUP entry and Gold Mod Manager syntax error were one Lua compilation regression: beta.28.11's Stat EXP/DV additions crossed Lua 5.1's 200-active-local limit, so the mod failed before either UI path could register.
- Lexically scoped the Stat EXP/DV implementation behind the existing beta export namespace so the full mod could compile without adding long-lived main-function locals.
- Removed the speculative Gold `save.options`/ManagerState workaround used during diagnosis; it was not the root cause.
- Preserved robust R/B/Y and Gold NEW GAME/CONTINUE recognition.
- Preserved HP semantics when creation-time Stat EXP/DV changes alter maximum HP: full-health starters/gifts remain full, while damaged catches retain their actual battle HP.
- Preserved release-gate evidence from the test package while keeping Gold's new Stat EXP/DV paths runtime TEST REQUIRED.

---

# 2.0.0-beta.28.13 — compiler/runtime diagnosis iteration

- Preserved development revision in the beta.28 compiler-repair sequence.
- Exact per-build diagnostic changes are only partially recovered; the sequence addressed the active-local compiler failure introduced after beta.28.11.

---

# 2.0.0-beta.28.12 — compiler/runtime diagnosis iteration

- Preserved development revision in the beta.28 compiler-repair sequence.
- Exact per-build diagnostic changes are only partially recovered; the sequence addressed the active-local compiler failure introduced after beta.28.11.

---

# 2.0.0-beta.28.11 — Stat EXP and DV rule family

- Added independent Player/Wild/Trainer starting Stat EXP presets: 0%, 25%, 50%, 75%, 100%, and 200%.
- Added No Player Stat EXP Gain while preserving ordinary EXP and levels; battle Stat EXP is blocked before mutation and Stat EXP vitamins are vetoed before consumption.
- Added independent Perfect Player/Wild/Trainer DV controls.
- Covered supported player catches, scripted gifts/starters, in-game trades, compatible receive events, and Gold `givepoke` acquisitions.
- Added a generation-neutral battle-start fallback for Gold wild/trainer Stat EXP/DV application where R/B/Y constructors are not shared.
- Starting Stat EXP is bounded by the engine's 65,535 per-stat storage ceiling; 0% preserves the vanilla newly-created value of zero Stat EXP.
- Creation-time rules were designed not to rewrite existing Pokémon merely because the rules were loaded or enabled.
- The original layout crossed Lua 5.1's 200-active-local limit, leading to the beta.28.12–28.14 repair sequence.

---

# 2.0.0-beta.28.10 — No Pseudos

- Added the No Pseudos acquisition restriction with supported pseudo-legendary classification.
- Existing owned Pokémon are preserved rather than removed when the rule is enabled.

---

# 2.0.0-beta.28.9 — 0.1.81 compatibility targeting and local-scope cleanup

- Targeted the Gen1Recomp 0.1.81 compatibility profile.
- Continued removing/restructuring unreachable long-lived locals to keep the large Lua chunk within compiler limits.

---

# 2.0.0-beta.28.8 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.7 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.6 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.5 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.4 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.3 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.2 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28.1 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

---

# 2.0.0-beta.28 — beta.28 development-line start

- Started the beta.28 development line directly after beta.27.16.
- The early beta.28 sequence collectively expanded Gold integration, compatibility reporting, setup/QoL features, and engine-version hardening; some exact per-build allocation remains partially reconstructed.

---

# 2.0.0-beta.27.16 — final beta.27 reported-bug hardening

- Hardened Gold Game Corner `Specials.HANDLERS`/`Specials.ALL` capture and restoration independently, without manufacturing a handler where vanilla or another mod left a registry entry absent.
- Restored/exposed the Gold Nickname Rule and required non-empty nicknames for supported catches and scripted gifts.
- Used Gold's VM-blocking rename seam for supported `givepoke` acquisitions so story-command continuation resumes at the exact native point.
- Broadened the Gold Ball gate to accept explicit static/fixed provenance as well as the native `battle.wild` shape for compatible fixed encounters.
- Clarified Ball Use tier 4 as `STANDARD` and tier 5 as `ALL`; the change corrected presentation while preserving the already-distinct cumulative mechanics.
- Preserved the generation-specific R/B/Y versus Gold Game Corner map IDs after review showed they were intentionally different, not a typo.
- The preserved beta.27.16 package recorded an expanded **66-check structural/engine gate** and **49-check headless interaction smoke suite**.

---

# 2.0.0-beta.27.15 — repository and release-candidate hardening

- Fixed Gold boss progression to recognize Gen 2 trainer-battle shapes rather than requiring Gen 1's `battle.kind == "trainer"`.
- Seeded existing R/B/Y Elite Four/Champion completion and Gold Johto/Kanto Gym/League progression from supported story/badge state.
- Corrected the Johto middle-Gym order to Chuck → Pryce → Jasmine while retaining live ace-level lookup.
- Prevented level-cap regression when an earlier defeated boss becomes stronger than the next boss through trainer overhaul mods.
- Added safe fallback for unknown/future Gen 1 version identifiers and normalized malformed fractional level-cap scope values.
- Invalidated dynamic `trainer.party` observations when the active mod set changes.
- Corrected the compatibility report to match exported Nuzlocke Compatibility API v22 and ensured every advertised capability had an explicit default relationship.
- Expanded provider method/result aliases, Gold World Building queue compatibility, and title-menu save/new-game detection while preventing duplicate Setup insertion.
- Added the first preserved dependency-free Node release gate and headless Lua smoke harness for this line.

---

# 2.0.0-beta.27.14 — live boss-cap compatibility

- Centralized authoritative next-cap calculation across enforcement and status UI.
- Read merged trainer rosters and observed composed trainer-party results so runtime trainer-level edits can feed cap calculation.
- Added public `getNextLevelCapInfo` compatibility output.

---

# 2.0.0-beta.27.13 — encounter-area splits

- Added OFF/CARDINAL splitting for Routes 1–25.
- Added OFF/COMMON Mt. Moon floor splitting and Safari Zone area splitting.
- Added physical-map provenance and reversible projection across tracker/history/catch-state views.

---

# 2.0.0-beta.27.12 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

---

# 2.0.0-beta.27.11 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

---

# 2.0.0-beta.27.10 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

---

# 2.0.0-beta.27.9 — glitch/MissingNo acquisition handling

- Added conservative MissingNo/glitch-species classification for known MissingNo identities plus flagged, malformed, or unregistered species records.
- Added the player-facing **Allow Glitches** rule: OFF blocks new glitch-species acquisitions on supported R/B/Y and Gold paths while preserving already-owned Pokémon.
- Normalized Catch Info/tracker/history handling for supported glitch-species records instead of assuming every acquisition maps cleanly to ordinary registered species data.
- Classification remained conservative/fail-open when incomplete modded metadata could not prove a species was a glitch.

---

# 2.0.0-beta.27.8 — Maximum BST acquisition rule

- Added numeric **Maximum BST** with `000/OFF` or `001–999` selection.
- Applied supported BST acquisition checks to wild catches, scripted gifts, and trades while keeping mandatory starters exempt from rejection.
- Used Gen 1 combined SPECIAL and Gold split special-stat data appropriately when computing base-stat totals.
- Merged available species metadata and failed open when complete/reliable base stats were unavailable rather than blocking an unknown modded species on guessed data.
- Preserved Dupes evaluation ahead of the BST gate and exposed the rule through Nuzlocke Compatibility API v15-era metadata.
- Lua 5.1 structural validation passed for the implementation; representative in-game numeric/acquisition coverage remained required.

---

# 2.0.0-beta.27.7 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

---

# 2.0.0-beta.27.6 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

---

# 2.0.0-beta.27.5 — Gold compatibility-surface refinement

- Added Gen2Compat coverage/member inspection for compatibility reporting.
- Stopped trying to replace Gold's already multi-page Trainer Card for Nuzlocke status; Gold status moved to its own Start-menu screen path.

---

# 2.0.0-beta.27.4 — Save Editor and compatibility-layer hardening

- Detected Gen1Recomp's embedded Save Editor loader session and avoided installing gameplay-bound runtime monkey patches there.
- Separated engine-version compatibility metadata from inter-mod compatibility relationships.

---

# 2.0.0-beta.27.3 — shared-seam compatibility negotiation

- Built directly from beta.27.2 and audited against the Gen1Recomp 0.1.79 line.
- Repaired the shared `ItemEffects.use` seam used by item-rule enforcement.
- Expanded advertised compatibility capabilities to shared engine/UI surfaces such as item use, shops, battle finish, Trainer Card, party/start menus, screens, static encounters, trainer parties, and boss caps.
- Began separating encounter-loss presentation from owned-Pokémon death presentation with **LOST ENC.** / **DEATHS** terminology, while the deeper legacy-history status overlap remained for the later beta.29.2.0 migration.
- Advanced the additive compatibility surface to Nuzlocke Compatibility API v11 while retaining backward-compatible older provider expectations.

---

# 2.0.0-beta.27.2 — preserved beta.27 development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not yet been recovered from surviving records; no history is inferred beyond its confirmed place in the sequence.

---

# 2.0.0-beta.27.1 — preserved beta.27 development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not yet been recovered from surviving records; no history is inferred beyond its confirmed place in the sequence.

---

# 2.0.0-beta.27 — promoted public baseline

- Promoted directly from the runtime-tested beta.26.6 line without an intentional gameplay change during promotion.
- Gold fresh startup/New Game, RULES, TRACKER, Catch Info, and Cyndaquil starter acquisition had runtime PASS evidence at promotion.
- Yellow RULES/TRACKER/catch behavior and prior 1st Catch toggle behavior carried runtime PASS evidence.
- Save schema remained 4.

---

# 2.0.0-beta.26.6 — Gold gift enforcement and Whiteout consequence

- Ran supported Gold `givepoke` gift legality checks before story/party mutation while preserving mandatory starter handling.
- Added the Gen 2 `finishBattle` consumer for the Nuzlocke Whiteout path while leaving Whiteout OFF on the native path.
- Gold ordinary gift denial and destructive Whiteout still required dedicated runtime confirmation at this revision.

---

# 2.0.0-beta.26.5 — acquisition and Whiteout correctness

- Corrected fallback gift/trade acquisition classification and generation-gated R/B/Y starting resources.
- Reworked Whiteout teardown to preserve the engine's wrapped finish chain instead of duplicating public teardown operations.

---

# 2.0.0-beta.26.4 — Tracker clarity and progression-aware TV

- Replaced cryptic failed-encounter labels with `FAILED <species>` and renamed the Tracker result column for clarity.
- Added failed-result marquee presentation and progression-aware Tier 3 home-TV run recaps.
- Preserved runtime evidence for Yellow UI controls, failed encounters, next-cap display, and fresh No Buying/No Selling.

---

# 2.0.0-beta.26.3 — early-game dialogue and TV polish

- Clarified Pokédex activation messaging and added adaptive Tier 3 home-TV flavor.
- Preserved runtime evidence for Yellow Setup/bedroom startup, starter Catch Info, No Mom Heal, PokéCenter behavior, and opening-rival flavor timing.

---

# 2.0.0-beta.26.2 — Gym Guide alignment and runtime-evidence rollup

- Re-centered the R/B/Y Gym Guide Rare Candy quantity screen without changing service mechanics.
- Recorded runtime PASS evidence for existing Red/Blue No Buying/No Selling, Red Gym Guide service, Blue No Field Heal, and nickname-aware catch flavor.

---

# 2.0.0-beta.26.1 — dialogue and starter-metadata polish

- Improved No Mom Heal dialogue ownership, starting-Ball wording, early R/B/Y starter Catch Info canonicalization, and Nuzlocke battle-message wrapping/paging.

---

# 2.0.0-beta.26 — runtime-tested canonical baseline

- Promoted the runtime-tested 26B10 revision to `2.0.0-beta.26`.
- Carried the published 25D4-RBY2 title/startup repair, Soft Start, Pokédex transition, starting resources, two-view R/B/Y Trainer Card, Gold beta Setup, nickname handling, and first-rival timing.
- Save schema remained 4.

---

# 26B10 — runtime-tested beta.26 promotion candidate

- Known revision directly descended from the published 25D4-RBY2 startup/menu hotfix and promoted forward as `2.0.0-beta.26`.
- This era accumulated runtime-driven verification/fixes around Gold Setup, PP-item restrictions, Pokémon Center restrictions, No Buying/No Selling, Gym Guide behavior, Repels, X Items, startup/menu lifecycle, and related compatibility paths.
- Exact per-change attribution inside the B-series is incomplete, so only the confirmed `26B10` promotion point is given its own heading.
- Its runtime PASS evidence became protected baseline evidence for later beta.26/27 development.

---

# 2.0.0-beta.25 — 25D4-RBY2 — R/B/Y startup/menu hotfix

- Runtime-confirmed Blue and Yellow title SETUP plus Oak-intro-to-bedroom startup.
- Runtime-reconfirmed Gold Setup/New Game and smoke-tested an existing Red save.
- Restored the proven title Setup injection and removed an unsafe optional post-intro screen push that caused a white screen.

### Historical subrecord — 2.0.0-beta.25 — 25D2 — Gym Guide transition diagnostic

- The Gym Guide Rare Candy offer/registration path was functioning, but runtime testing still failed at the quantity-screen transition.
- The failure was isolated to selector lifecycle/continuation rather than the long-lived direct-row Gym Guide composition or candy policy.

### Historical subrecord — 2.0.0-beta.25 — 25D3 — Gym Guide selector lifecycle repair

- Changed only the failing quantity-screen lifecycle to use Gen1Recomp's current blocking `push_screen` script-command behavior.
- Preserved NPC registration, vanilla dialogue composition, quantity choices, and candy-grant policy.
- Runtime testing reported the 1/10/25/50/99 selector working after this repair.

### Historical subrecord — 2.0.0-beta.25 — 25D4 — item-rule and Gym Guide stabilization

- Runtime-confirmed No Repels and No X Items and retained established passes for No Escape, healing/field restrictions, nickname, Center, shops, and Gym Guide quantity selection.
- Hardened item recognition, PP-item coverage, acquisition/recovery paths, and Whiteout teardown while preserving save schema 4.

---

# 2.0.0-beta.24 — Gold Setup experiment

- Attempted Gold automatic New Game Setup through an intro hook; runtime evidence showed the attempt remained vanilla, leading to the later title-menu design.

---

# 2.0.0-beta.23 — early Gold status and provenance work

- Added experimental Gold Trainer Card status integration and Gen 2 Egg/Day Care/roaming provenance support.
- Generation-gated the R/B/Y Gym Guide integration.

---

# 2.0.0-beta.22 — conflicting surviving records

- A directly surviving committed beta.22 source identifies itself as **"static integrity + version/persistence hardening"**, carries save schema 4 and Nuzlocke Compatibility API v7, and does not contain the later Gold/Gen2 adapter markers visible in beta.25-era source.
- A later reconstructed beta.25 changelog attributes generation-native Gold capture, permadeath, nickname, Mart, starter/gift, area-tracking adapters, and Gen 1 + Gold manifest targeting to a beta.22 stage.
- Because these records conflict, the current history preserves both facts without pretending they describe the same exact code snapshot. The Gold adapter work was present by the later beta.23–25 line, but its precise first beta.22 build/revision is unresolved.

---

# 2.0.0-beta.21 — Gold/GSC architecture groundwork

- Reconstructed directly from beta.20 while preserving save schema 4 and existing rule/save behavior.
- Added version-profile architecture and experimental Gold/GSC targeting groundwork; the surviving reconstruction audited against Gen1Recomp 0.1.78.
- Expanded progression architecture through Red/postgame-provider concepts and the R/B/Y Trainer Card active-rule display.
- Preserved a two-row R/B/Y Trainer Card rule display and expanded World Building Tier 1/2/3 labels in the reconstructed build.
- The reconstructed beta.21 compatibility surface is recorded as Nuzlocke Compatibility API v9; later planned semantics not proven present in that source remain unassigned.

---

# 2.0.0-beta.20 — compatibility and regression hardening

- Built as a surgical update from beta.19 rather than a branch replacement.
- Centralized item/capture/shop policy exports, improved provider surfaces, persistent identity/recovery, Trainer Card/Catch Info, and Gym Guide behavior while preserving save schema 4.

---

# 2.0.0-beta.19 — protected reconciliation baseline

- Served as the protected canonical baseline for the beta.20 surgical update line.
- Release-history evidence identifies beta.19 as the point where split **No Buying** / **No Selling** replaced the retired combined shop rule, persistent Pokémon identities were established, and Dupes supported OFF / SPECIES / FAMILY modes.
- Numeric starting resources, separate item restrictions, presets, R/B/Y-specific handling, additive save/persistence reconciliation, and transactional gift/trade enforcement were present in the protected baseline.
- Multiple legitimate same-area tracker catches were preserved as separate records instead of being collapsed together.
- Wonderlocke remained visible/dormant and forced OFF; the baseline also carried the v0.1.77-era audit work, Blue/Yellow Setup/cursor fixes, and removal of the old NEXT BOSS display.
- Some earlier feature-by-feature introduction points remain unrecovered, so this entry records known beta.19 baseline properties rather than claiming every listed feature originated in beta.19.

---

# 2.0.0-beta.16 — reconstructed from surviving source/release records

- Fixed Setup-menu helper scoping/order behavior and retained the established Gym Guide architecture.

---

# 2.0.0-beta.15 — surviving source with conflicting later reconstruction

- The directly surviving committed beta.15 source identifies itself as **"Menu crash fix"**, carries **save schema 2**, and exports **Nuzlocke Compatibility API v6**.
- A later reconstructed beta.25 changelog instead attributes a Gen1Recomp 0.1.77 compatibility pass and the move to save schema 3 to beta.15.
- The conflict is retained explicitly. Current evidence does not safely identify which later beta.15/internal revision first carried schema 3, so the changelog no longer states that transition as certain.
- Wonderlocke remained disabled/dormant through the surviving records.

---

# 2.0.0-beta.14 — reconstructed save-schema revision

- Surviving history shows the future-safe migration framework at **save schema 2** by this snapshot.
- Continued tracker/recovery hardening while keeping unfinished Wonderlocke behavior non-active.

---

# 2.0.0-beta.12 — first surviving versioned save-schema baseline

- Added the first surviving future-safe persistent save-schema baseline at **schema 1**.
- Used an idempotent marker-only migration so older/vanilla saves could establish a versioned migration boundary without rewriting unrelated gameplay data.
- Preserved the established beta.8-era Gym Guide direct-row composition/selector and the existing Setup, provenance/recovery, level-cap, Tracker/Catch Info, and Trainer Card systems.

---

# 2.0.0-beta.11 — surviving development snapshot

- Improved catch-location recovery for human-readable saved locations.
- Changed the Rare Candy selector cursor presentation to the native theme cursor without changing selector lifecycle.
- Only source-supported history is retained; broader exact delta is not inferred.

---

# 2.0.0-beta.10 — surviving development snapshot

- Added native cursor/scroll presentation work and Trainer Card refinements.
- Continued the established Gym Guide direct-row + dedicated-selector behavior and dormant Wonderlocke-era infrastructure.
- Only source-supported history is retained; broader exact delta is not inferred.

---

# 2.0.0-beta.8 — surviving development snapshot

- Experimental provider/Wonderlocke-era infrastructure was present by this revision.
- The Gym Guide direct-row composition architecture that survived into later releases was already established by this period.

---

# 2.0.0-beta.5 — surviving legacy-reconciliation snapshot

- Added legacy catch-location reconciliation/recovery work.
- Gym Guide behavior remained on the earlier implementation of that period.
- Only source-supported history is retained; broader exact delta is not inferred.

---

# 2.0.0-beta.4 — World Building introduction

- Added World Building tiers and associated optional flavor/mechanic messaging.
- Added level-cap-aware Gym Guide feedback before the Rare Candy selector.

---

# 2.0.0-beta.3 — surviving logic-audit snapshot

- Added/expanded provenance-aware catch recovery and compatibility work by this surviving snapshot.
- The Gym Guide Rare Candy feature was already present with its dedicated **1 / 10 / 25 / 50 / 99** quantity selector.
- Only source-supported history is retained; broader exact delta is not inferred.

---

# 2.0.0-beta.1 — surviving Whiteout-fix snapshot

- A surviving source snapshot identifies this revision as an early Whiteout-fix stage.
- Only source-supported history is retained; broader exact delta is not inferred.

### 2.8.36
- Standalone Gen-I shiny fallback now accepts both Gen1Recomp `battle.started` payload shapes (`payload.battle` and a direct BattleState), fixing Shiny Rate ALWAYS doing nothing in Red/Blue/Yellow when Nuzlocke is the only shiny owner. corrective rebuild — standalone shiny parity
- Fixed Gen I standalone Shiny Rate timing: the exact live wild is rolled at the current `pokemon.sprite` boundary before battle art resolves, with `battle.started` retained only as a no-double-roll fail-soft.
- Added official Crystal shiny color pairs for all Gen I species as data-only runtime palette input; no ROM-derived sprites are shipped.
- Gen II keeps native Gen1Recomp shiny identity/palette ownership through `shiny.roll` and `mon.shiny`; Nuzlocke only adds its configured intro cue while it owns the shiny system.
- Compatible external shiny providers still cause immediate full generation/presentation stand-down.


## 2.9.8
- Added a static cross-rule interaction matrix covering the highest-risk policy combinations and shared ownership seams.
- Added a focused save migration/idempotence audit for presence/value preservation, isolated dry-run state, schema-marker-last ordering, and exactly-once transaction recovery.
- No gameplay, schema/API, Randomizer algorithm, or Runtime PASS change.


## 2.9.9
- Added a hook lifecycle/install-order Release Safety audit covering registration, installer health, load-order resolution, and protected native Gen-II ownership.
- Added edition-capability and failure-policy reconciliation across all six declared editions.
- Formalized existing failure boundaries: unknown custom metadata generally fails open; durable ambiguity/policy exceptions fail closed; optional compatibility installation remains fail-soft.
- No gameplay, schema/API, Randomizer algorithm, or Runtime PASS change.

## 2.9.15
- Added Action/Legality API 1, Services API 1, and Capability API 1 as additive semantic interoperability surfaces.
- The new APIs delegate to existing policy owners and do not create new rule state, save state, or gameplay defaults.

## 2.9.15
- Added Acquisition/Provenance API 1 by formalizing the existing acquisition preflight/commit lifecycle and explicit observation-only mode.
- Added Event Contract 1 for non-persistent semantic interoperability events; Run History remains the durable chronology owner.

## 2.9.34
- Batched three low-risk static ownership moves into existing `rule_catalog.lua`: movement-assist labels, battle-scope labels, and the Nuzlocke-authored translation source catalog.
- Preserved existing exported helpers and runtime behavior contracts; no runtime-sensitive subsystem was relocated.
- No save/API/Randomizer algorithm/default/support-level/Runtime PASS change.

