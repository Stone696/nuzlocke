# Nuzlocke v3.0.3-beta — Your Starter, Your Choice

**Reroll the starters you see, not just an invisible balancing calculation.**

This patch improves the Generation 3 randomiser in FireRed, LeafGreen, Ruby, Sapphire and Emerald. It continues the unofficial Nuzlocke fork's beta while preserving the original Gen 1/2 content and the expanded species/artwork features introduced in 3.0.2-beta.

## What's new since 3.0.2-beta

### Manual starter rerolls
- **Starter Rerolls now means what it says:** configure **OFF / 1 / 3 / 5 / UNLIMITED** in **NUZ MENU → NUZ RULES → RANDOMIZER** before the randomiser locks. This replaces the previous automatic best-of-three/five trio selection. **Starter Balance: CHAOS / SIM BST** remains independent.
- **Ruby/Sapphire/Emerald:** press **SELECT** on the starter-bag selection screen to reroll the whole trio; the remaining allowance is displayed on the bag.
- **FireRed/LeafGreen:** before taking your starter, use **RANDOMIZER → REROLL STARTERS NOW** from the Nuzlocke menu in Oak's lab. The new three choices appear by name.
- New trios are generated deterministically from the existing run seed, with distinct eligible species and the configured style, type, balance, generation and National Dex filters. The number of rerolls spent and the currently displayed trio are saved. Revisiting the starter screen or reloading does not grant free rerolls.
- **Rival continuity:** Oak/Brendan/May's compatible starter lineage continues to use the saved choice. Failed attempts to generate a genuinely different trio do not cost a reroll, and old beta saves with already-generated starter choices are left intact. After receiving a starter, rerolls stop.
- Existing randomiser seed and other category settings remain locked after the first randomised result; only an already-configured starter reroll action is permitted at the starter selection stage.

### Untamed Advanced and Modern Spawns
- The separate [Untamed Advanced](https://github.com/Deluxe0111/Untamed-Advanced) mod now supports per-visible-spawn species draws through Modern Spawns' COMPLETE/RANDOM pools (see its [integration PR](https://github.com/Deluxe0111/Untamed-Advanced/pull/3)). That **is not bundled with this Nuzlocke ZIP**; update the companion mod separately.
- Nuzlocke's optional **Random Wild** integration still randomises eligible ordinary Untamed overworld species after Untamed's own source selection. When both randomisers are active, Nuzlocke may choose a different final species. Cross-mod ownership, expanded artwork and load-order behaviour require real-game validation.
- There are **no new required mods, engine patches, Mod API revisions or saved-run migrations** in this Nuzlocke patch.

## Install / update

1. Download **`nuzlocke-3.0.3-beta.zip`** from the GitHub release.
2. In Gen1Recomp select **MODS → Import mod .zip**, then enable the updated Nuzlocke.
3. Back up your save. For manual starter-reroll testing, start a disposable **new Gen 3 run** with Random Starters enabled and set the reroll allowance before viewing the starter choices.
4. If testing the expanded overworld combination, update **Untamed Advanced** independently and select **COMPLETE** in Modern Spawns; the six-mod stack has not yet been fully certified.

**Supported games:** Red, Blue, Yellow; Gold, Silver, Crystal; and **FireRed, LeafGreen, Ruby, Sapphire, Emerald (beta)**. **Mod API:** 2. **Game engine range:** `>=0.2.24 <2.0.0`. **Gen 3 save namespace:** `gen3_classic_v1`.

## Known beta limitations

The current code has automated regression coverage, but all five Gen 3 ROM editions, live scripted starter-selection UI and all combinations of Untamed Advanced / Modern Spawns / National Dex / sprite providers require hands-on playtesting. Some non-catch nickname restrictions and uncommon gifts/trades remain incomplete or unverified. Ordinary Route Forgiveness does not revive Pokémon; the dev-only full-archive restore is not a normal gameplay feature. No Mega Evolution or Gigantamax battle mechanics are added by this release.

**Credits:** [bryanthaboi](https://github.com/bryanthaboi) created the original Nuzlocke mod; [Stone696](https://github.com/Stone696) continued its Gen 1/2 work; [masterwebx](https://github.com/masterwebx) authored the original Shiny Pokémon mod; [Deluxe0111](https://github.com/Deluxe0111) developed this fork's Gen 3 port and integrations.

[Source and credits](https://github.com/Deluxe0111/nuzlocke) · [Gen 3 feature inventory](docs/GEN3_FEATURE_MATRIX.md) · [In-game test checklist](docs/GEN3_TEST_CHECKLIST.md)

---

# Nuzlocke v3.0.2-beta — Expanded Pokémon & Better Memories

**More Pokémon to encounter, more forms to recognise, and better ways to remember your run.**

This update builds on the Generation 3 beta in FireRed, LeafGreen, Ruby, Sapphire and Emerald, without replacing the established Gen 1/2 features. It is an **unofficial community fork** maintained for the Gen 3 port by **Deluxe0111**, with the inherited work credited to its original contributors.

## What's new since 3.0.1-beta

### Expanded National Dex randomisation
- **Optional National Dex Gen 3 API v2 integration** extends the Gen 3 randomiser's registered species pool to 1,025 National Dex Pokémon. Players can include newer generations and opt into supported alternate forms, while leaving the vanilla pool untouched when the provider is absent.
- Species bans and supported catch-rule classifications recognise registered Gen 4–9 Pokémon, including individual species through #1025, instead of assuming the original 386-only cartridge.
- Randomiser seeds and old-save behaviour stay independent of optional providers; enabling a larger pool is a deliberate configuration choice.

### Correct party and memorial artwork
- The **End Run shareable poster** resolves expanded Pokémon from their actual engine species slot and uses compatible artwork-provider hooks for normal/shiny pictures where available.
- The **Graveyard, encounter tracker, final party and results artwork** now resolve supported regional and alternate-form names (including older saved records), rather than displaying generic base-species names or internal IDs where provider metadata is available.
- Nicknames and existing save identities are preserved; unavailable art and unknown legacy shiny state degrade safely rather than fabricating a form or shiny appearance.

### Clearer companion Mod Support
- **MOD SUPPORT** now lists Untamed Advanced, National Dex Gen 3, G9 Battle Sprites, Modern Spawns and Gen 3 HD Sprites, plus existing shiny/randomiser diagnostics.
- Diagnostics distinguish *detected*, *API ready*, *inactive* and *not verified*. Untamed's hook-based integration is detection-only. Finding an installed mod is **not** a claim that the six-mod combination has passed real-game tests.
- No new mandatory dependencies, species-slot rewrites, rule-ownership overrides or save migrations are introduced by this diagnostic work.

## Install / update

1. Download **`nuzlocke-3.0.2-beta.zip`** from this release.
2. In Gen1Recomp, choose **MODS → Import mod .zip**, install and enable Nuzlocke.
3. If using National Dex Gen 3 and companion sprite/spawn mods, confirm each is enabled; expanded randomiser forms are opt-in in Nuzlocke's randomiser settings.
4. **Back up your save**, especially for Permadeath, End Run and randomiser experimentation.

**Games:** Red, Blue, Yellow; Gold, Silver, Crystal; and **FireRed, LeafGreen, Ruby, Sapphire, Emerald (beta)**. **Mod API:** 2. **Game engine range:** `>=0.2.24 <2.0.0`. **Gen 3 save namespace:** `gen3_classic_v1`.

## Known beta limitations

The Gen 3 regression and packaging tests cover the changes, but **all five ROM editions and the combined six-mod stack still require hands-on validation**. Third-party spawn ownership and rendered sprites are provider-dependent. Some non-catch nickname restrictions, unusual scripted gifts/trades and ordinary Route Forgiveness revival remain incomplete or unverified. The expanded National Dex, G9 sprites, Modern Spawns and HD sprite integrations are **optional**; Mega Evolution and Gigantamax battle mechanics are **not** part of Nuzlocke 3.0.2.

**Credits:** [bryanthaboi](https://github.com/bryanthaboi) created the original Nuzlocke mod; [Stone696](https://github.com/Stone696) continued its Gen 1/2 development; [masterwebx](https://github.com/masterwebx) authored the original Shiny Pokémon mod; [Deluxe0111](https://github.com/Deluxe0111) developed this fork's Gen 3 port and integrations.

[Source and credits](https://github.com/Deluxe0111/nuzlocke) · [Gen 3 feature inventory](docs/GEN3_FEATURE_MATRIX.md) · [In-game test checklist](docs/GEN3_TEST_CHECKLIST.md)

---

# Nuzlocke v3.0.1-beta — A New Generation of Challenges

**Kanto and Hoenn are ready for a different kind of journey.**

Every encounter is a decision. Every Pokémon has a story. And when one of your partners falls, that loss matters.

Nuzlocke brings the challenge to **Pokémon FireRed, LeafGreen, Ruby, Sapphire and Emerald**, building on the original Generation 1 and 2 mod rather than replacing it. This is an **unofficial community fork**, with the Gen 3 port developed and maintained by **Deluxe0111** and the inherited Gen 1/2 work credited to its original contributors.

## Your adventure, your rules

Choose a traditional Nuzlocke or build something far more demanding. Switch on **Permadeath** and **one encounter per area**, enforce nicknames, customise Failed Encounters, and decide whether a whiteout ends everything or a living PC survivor offers one last chance. Your opening rival battle can have mercy, but the rest of the journey may not.

Go further with **Hardcore** restrictions and level caps, hunt exclusively for shiny encounters with **Shiny Nuzlocke**, or combine the playstyles. Want a different challenge? Experiment with **Type Locke**, **Catch Draft**, **Colorlocke**, **Alphabetlocke**, species bans, battle/status clauses, item restrictions, service limitations, economy rules and configurable area splits.

The new **run setup** lets you decide your rules before the first adventure begins, choose optional starting resources and **lock the settings for the entire run**.

## Make familiar regions unfamiliar

A **seeded Gen 3 randomiser** can reshuffle wild encounters, starters, trainers, gifts, static Pokémon, items, shops, TMs, learnsets and evolutions, using selectable pools and balancing options. Your seed makes those choices reproducible.

With compatible **Untamed Advanced** installed, eligible wandering overworld Pokémon use the same randomiser: the Pokémon you **see** is the one you **fight and catch**. Untamed is optional; normal encounters work without it.

## Remember the journey

The **Run Journal** keeps encounter progress, important rule events and fallen partners together. The **Graveyard** preserves the Pokémon you've lost, and **End Run** provides an outcome screen for defeat, abandonment or Champion victory.

Create a **shareable results image** showing the final party, graveyard and run statistics, including shiny details where available. Winning the League can be a celebration; losing your last partner can be a memorial.

Readable areas, species names, a redesigned Game Boy Advance menu and a read-only **Mod Support** status screen make the Gen 3 experience easier to navigate.

## What's improved in v3.0.1-beta

This is the **first packaging and presentation follow-up** to the v3.0.0-BETA port, rather than a claim that every feature above was introduced in this patch.

- **Smaller, cleaner installable ZIP** containing the mod runtime and essential player files instead of tests, GitHub workflows and long historical developer documents.
- **Release presentation and documentation** rewritten around the actual Gen 3 features and clear distinctions between original, ported, adapted and new work.
- **Game UI polish** for long descriptions, scrolling and player-facing run/area terminology.
- **Tested release gates**, with the Gen 3 regression suite, reproducible archive verification and contributor credits checked before packaging.
- Future releases use curated release notes and deliberately chosen versions rather than raw commit lists and automatically publishing on each main-branch push.

## Installation

1. Download **`nuzlocke-3.0.1-beta.zip`** from this GitHub release.
2. In Gen1Recomp, open **MODS → Import mod .zip**, choose the downloaded archive and enable Nuzlocke.
3. Start a supported game, configure **NEW RUN SETUP** in Gen 3, or open **NUZ MENU → NUZ RULES**. Enable Nuzlocke enforcement when you're ready.
4. **Back up valuable saves first.** Death, terminal End Run outcomes and some advanced rules are deliberately irreversible.

**Supported games:** Red, Blue, Yellow; Gold, Silver, Crystal; and **FireRed, LeafGreen, Ruby, Sapphire, Emerald (beta)**. **Mod API 2**. Compatible engine range: `>=0.2.24 <2.0.0`. Optional Untamed Advanced integration.

## Beta notes

Gen 3 has extensive automated tests, but not every combination of edition, progression, external mod and native event has been manually certified. Some non-catch nickname enforcement and scripted gift/trade interactions still need further testing; **ordinary Route Forgiveness Pokémon revival is not enabled**. Report bugs with your edition, Gen1Recomp version, installed mods and steps to reproduce.

**Credits and collaboration:** [bryanthaboi](https://github.com/bryanthaboi) created the original Nuzlocke mod; [Stone696](https://github.com/Stone696) expanded and maintained the Gen 1/2 project; [masterwebx](https://github.com/masterwebx) created the original Shiny Pokémon project; [Deluxe0111](https://github.com/Deluxe0111) developed the Gen 3 port and integrations. This fork is offered for upstream collaboration, with the intention that Gen 3 can be maintained alongside the existing Gen 1/2 work. It is not presented as an official replacement for the original maintainers.

[Source and credits](https://github.com/Deluxe0111/nuzlocke) · [Feature inventory](https://github.com/Deluxe0111/nuzlocke/blob/main/docs/GEN3_FEATURE_MATRIX.md) · [Full historical release notes](https://github.com/Deluxe0111/nuzlocke/blob/main/RELEASE_NOTES.md)

---

# Nuzlocke v3.0.0-BETA — Generation 3 compatibility

**First Generation 3 beta release.** Adds FireRed, LeafGreen, Ruby, Sapphire and Emerald support without replacing the existing Red/Blue/Yellow/Gold/Silver/Crystal runtime.

**Installed version:** `3.0.0-BETA` · **Intended GitHub tag:** `v3.0.0-BETA` (tag/release publication is separate from this documentation update) · **Mod API:** 2 · **Gen 3 save key:** `gen3_classic_v1`.

## Ported from the existing Nuzlocke feature set

- **CORE:** Nuzlocke Enabled, Permadeath, One Encounter Per Area, Failed Encounters, Nickname Requirement, First Rival Mercy, Whiteout Ends Run and PC Survivors.
- **CLAUSES:** Dupes, Shiny Catch Exception and Shiny Rate, Roamer slots, Egg Encounter provenance and Route Forgiveness tokens/route reopening.
- **Levels, Hardcore, Game Difficulty and Run/Party:** level caps, EXP Edging, battle restrictions, team limits, evolution limits and trainer difficulty options.
- **Advanced Catch and Variants:** legendary/mythical/pseudo/BST/individual species bans, fishing and static restrictions, optional gifts/trades with AREA/BONUS accounting, Colorlocke, Alphabetlocke, Type Locke and Catch Draft.
- **Battle and status rules:** OHKO Clause; Flinch/Trap/Setup/Evasion/Accuracy/Stat-drop restrictions; individual status bans and Sleep Clause.
- **Other advanced rules:** battle and field items, Ball Per Encounter, heal/PP/TM/Rare Candy restrictions, services/economy, Pokémon IV/EV policies and Kanto/Hoenn area splits.
- **Quality of life:** Instant Text, Run/Surf, Unlimited Bag Space and trade-evolution options.

## Adapted and substantially reworked for Gen 3

- Independent Game3 `gen3_runtime.lua`, native event/action/battle integration and isolated persisted rule state; no Gen 1/2 save migration or upstream engine patch required for the port.
- Enforces eligible encounter counting only **after native Ball/catching access is available**, rather than consuming opening routes during early story battles.
- Checks supported scripted gifts, trades, party, item and battle actions at their Gen 3 native transaction boundaries. Handles Pokémon death snapshots and native battle writeback safely.
- Rebuilds the seeded randomiser for Gen 3: starters, wild/overworld, static/gift/Egg Pokémon, trainers, items, shops, TM contents/locations/compatibility, learnsets and evolutions. Supports defined pool and balancing options.
- Uses native Gen 3 shiny identity, ROM front sprites for relevant portraits/results and standard mini-icons in party/PC boxes.
- Uses a GBA-native **240×160** menu with active-rule status, area names and readable Pokémon details.

## New Gen 3 beta features and integrations

- **Shiny Nuzlocke** and **Hardcore Nuzlocke** playstyles, independently toggleable and combinable.
- **NEW RUN SETUP**, configurable starting resources and **LOCK FOR RUN**.
- Optional **Untamed Advanced** visible-overworld Pokémon randomisation, sharing wild seed/settings and matching the shown sprite to the battle/capture; follower, roamer and scripted actor exclusions are preserved.
- **RUN JOURNAL** merges current run summaries, encounters, Graveyard and up to 100 recent rule-event messages.
- **End Run / results screen** records loss, forfeit or Champion completion, integrates native saving, and creates a shareable party/graveyard/statistics image with shiny details.
- **MOD SUPPORT** provides read-only detection of supported external integrations and shiny-rate ownership, without untested override switches.
- Hidden, audited **NUZ DEV** testing tools: encounter resets, report and verified full-archive Pokémon restoration; developer changes taint the test save.

## Explicit exclusions / work still requiring testing

- Gen 3 **Wonderlocke** was removed from the menu. Old **Almanac/NUZ NOTICES** entries are consolidated in **RUN JOURNAL**; old **MOD COMPAT** is replaced by the safe read-only **MOD SUPPORT** screen.
- Ordinary **Route Forgiveness Pokémon revival** remains unimplemented (developer-only archive restore is not a regular gameplay clause).
- Non-catch nickname restrictions, uncommon custom gifts/trades, and certain provider-specific boundaries need further work and game verification.
- Automated Lua smoke/CI coverage does **not** certify real ROM playthroughs across all five editions or combined third-party mod stacks.
- Existing Gen 1/2 rules, author credits and older version history are retained. Earlier release sections below remain historical and are not amended to claim later Gen 3 functionality.

**Feature inventory:** [Gen 3 feature matrix](docs/GEN3_FEATURE_MATRIX.md) · **In-game tests:** [Gen 3 checklist](docs/GEN3_TEST_CHECKLIST.md) · **Credits:** [CREDITS.md](CREDITS.md).

---

# Nuzlocke 2.9.73 — Historical pre-v3 setup update

**Published 28 October 2026.** This preceding 2.9.x release focused on early Generation 3 new-run resource setup: native PC starter supplies, deferred Poké Ball delivery after catch unlock, the `save.created` integration and supporting regression tests. It did **not** include the completed v3 menu, rules, results, journal or developer features described above.

The original public release remains available as [v2.9.73](https://github.com/Deluxe0111/nuzlocke/releases/tag/v2.9.73). Older release sections below are unchanged.

# Nuzlocke 2.9.72 — Randomizer tracing and shiny isolation

2.9.72 is a focused runtime-repair/diagnostic build from exact sealed 2.9.71. It addresses the confirmed Gen-II numeric item-reference mismatch, removes legal Random Shop no-op selections, exposes the existing Random Trainer pipeline end-to-end, and prevents Nuzlocke shiny recoloring from mutating shared engine ImageData.

Random Field Items, Random Shops, Random Trainers, and shiny presentation remain runtime-test-required on 2.9.72. The new diagnostics are designed so a failed retest identifies the boundary that failed rather than merely reporting that the feature looked vanilla.

# Nuzlocke 2.9.71 — Random Field Items repair

2.9.71 is a focused Random Field Items runtime repair built strictly from sealed 2.9.70.

Yellow runtime testing on 2.9.70 with Gen1Recomp 0.2.41 showed a clear failure: the native overworld pickup completed, but Random Field Items did not replace the authored item. Source review confirmed that Gen1Recomp provides `world.talk` as the public Gen-I hook immediately before `OverworldController:talkTo` handles an object. 2.9.71 moves the Gen-I visible-item Randomizer to that supported composition seam.

The native pickup path still owns bag capacity, item removal state, pickup text, item names, sounds, and retry behavior. Nuzlocke temporarily projects the deterministic replacement into the item's object definition only while the downstream hook/native handler runs, then restores the authored definition.

2.9.71 also adds focused R/B/Y field-item pipeline diagnostics so the Dev tools can report whether the `world.talk` hook registration is actually present.

The Gen1Recomp compatibility baseline remains 0.2.41. No save-schema or public API version bump is required. Random Field Items require runtime retest before any PASS is recorded.

# Nuzlocke 2.9.70

2.9.70 is a Gen1Recomp 0.2.41 compatibility-review and UI-contract correctness release built strictly from sealed 2.9.69.

The engine review advances Nuzlocke's source baseline to the official 0.2.41 release commit. Upstream Mod API 2, Link Protocol 2, Save Format 5 and ROM cache v5 are unchanged. The reviewed delta is concentrated in platform/launcher support, presentation pacing, and Gen-II save export. Nuzlocke continues to leave presentation timing entirely engine-owned, and no Nuzlocke-critical public mod contract break was found.

This build also fixes the previously identified dormant input-contract bug: an invalid profile name now falls back both behavior and reported profile identity to `navigation`.

Exact-edition runtime testing remains required; this release does not promote Runtime PASS from source review.

# Nuzlocke 2.9.69

2.9.69 is a focused UI-contract correctness and Release Safety hotfix built strictly from sealed 2.9.68.

The presentation contract now keeps conditional trainer-party authority descriptive instead of coercing `nuzlocke_randomizer_when_enabled` to unconditional true. A new `gameplayAuthorityFor(surface)` query exposes the descriptor directly, while `presentationOwnsGameplay(surface)` reports only unconditional ownership.

The input-contract Release Safety check no longer hardcodes the obsolete shared UI API version 7; it guards the feature's own `inputContractVersion = 1` instead.

No Runtime PASS is promoted by this build.

# Nuzlocke 2.9.68

2.9.68 is a focused Gen-II UI hotfix built strictly from sealed 2.9.67.

Gold runtime testing exposed a crash at `classic_ui.lua:6568`: the Gen-II Nuzlocke utility-page title renderer calls `T.centerX(...)`, but the shared typography object exported `measure`, `fit`, `rightX`, and `wrap` without `centerX`. This build adds the missing helper to the shared typography contract and protects the consumer/definition pair with Release Safety.

The earlier 2.9.67 `compatPublicCopy` Dev Report repair is preserved. No gameplay, save schema, Compatibility API, Randomizer algorithm, HGSS ownership, or UI input/presentation ownership behavior changes are included.

# Nuzlocke 2.9.67

2.9.67 is a focused runtime diagnostic hotfix built strictly from sealed 2.9.66.

Yellow runtime testing confirmed that 2.9.66 loads and the ABANDON RUN flow works, but opening Dev Report crashed at `dev_diagnostics.lua:2448` because `compatPublicCopy` was referenced as a global after the diagnostics split. The helper already had a stable owner in `main.lua`; this build injects it explicitly into `dev_diagnostics.lua` and asserts the dependency at registration.

A Release Safety tripwire now protects that dependency boundary. No gameplay, save-schema, Compatibility API, UI contract, HGSS compatibility ownership, or Randomizer behavior changes are included.

# Nuzlocke 2.9.66

2.9.66 is a focused presentation-ownership and compatibility hardening release built strictly from sealed 2.9.65.

The Nuzlocke UI system now exposes presentation-ownership contract v1 (UI API 8). External Party, PC, Pokédex, Bag, Mart, battle-art/HUD and overworld renderers may own those visuals without acquiring Nuzlocke challenge or controller authority.

HGSS Visual Overhaul 1.0.2 is now an explicit Yellow compatibility target. Its source was reviewed at the PartyMenu/ListMenu, battle-art, shiny-art and `BattleState.newTrainer` seams. Nuzlocke continues to own challenge legality, provenance/tracker state, gameplay transactions and Random Trainer party transformation when enabled.

The Gen-I Random Trainer constructor wrapper now publishes an explicit shared-wrapper chaining contract and read-only health diagnostic. It supports either load order with presentation wrappers and does not require Nuzlocke to remain the outermost wrapper.

No Runtime PASS is promoted by this source/static compatibility release.

# Nuzlocke 2.9.65

2.9.65 is a focused UI-contract hardening release built strictly from sealed 2.9.64.

Nuzlocke-owned screens now publish a semantic input contract that distinguishes repeat-safe navigation/value stepping from edge-only activation/back behavior. Destructive confirmation is identified separately, so input-repeat/accessibility integrations can accelerate safe movement without being treated as owners of Nuzlocke actions.

The contract is presentation-only. Nuzlocke does not synthesize held-input repeats or replace engine/native/external input timing.

WizzStar HoldToScrollUI 1.1.0 is documented as a reviewed compatibility target based on its public repository/release behavior. Combined runtime testing and package-source review remain separate; no Runtime PASS is promoted by this build.

No gameplay, save-schema, Compatibility API, Randomizer, or tracker-presentation behavior changes are included.

# Nuzlocke 2.9.64

2.9.64 is a focused compatibility-target refresh built strictly from sealed 2.9.63.

Current reviewed presentation targets are advanced to Dramatic Shape 1.9.0, Battle Art Voxel Fork 1.10.0, and Battle Cinematics 1.2.4. Existing current targets PotatoVoxel 1.9.6, Voxel Ascendant 2.0.2, Terrarium 1.27.0-mobile, Dramaless Shape 2.0.3, and Flying Overhaul 1.2.1 remain unchanged.

The compatibility registry now documents the active voxel renderers as distinct presentation owners with separate identities/conflict behavior. Battle Cinematics remains the external camera/director layer; renderer/environment ownership remains with the selected renderer/provider. Nuzlocke keeps challenge legality and state ownership.

No Runtime PASS is promoted by this source/static compatibility refresh.

# Nuzlocke 2.9.63

2.9.63 is a focused load/correctness/compatibility hotfix built strictly from sealed 2.9.62.

The fatal 2.9.62 Red/Gold load failure was traced to a second missing dependency from the earlier encounter-tracker split: `legacyCandidates` remained private to `encounter_tracker.lua` while `main.lua` passed an undefined name into ClassicUI. The tracker now exports its existing function and `main.lua` explicitly binds it before ClassicUI registration. Release Safety now checks the ClassicUI required-injection set rather than relying only on one-name tripwires.

This build also restores the existing World Building T1/T2/T3 denial progression for banned battle healing/X Items while retaining the newer `{ context="battle", source="bag" }` metadata.

Gen1Recomp source/documentation compatibility is reviewed through 0.2.40 (`0cf543d597ce84e4d847b2aba782f1bf2799fde0`). Mod API 2, upstream Save Format 5, and `>=0.2.24 <2.0.0` remain valid. Static/source review does not promote Runtime PASS; focused 0.2.40 battle and Gen-II party-item/Rare-Candy smoke remains required.

# Nuzlocke 2.9.62

Emergency Gen-I load hotfix. Yellow 2.9.61 runtime testing exposed a fatal `classic_ui requires GEN1_SEED_IDS` registration failure that prevented Nuzlocke from loading. The seeded-area table already had a stable owner in `encounter_tracker.lua`, but the owner did not export it, leaving later module dependency injection to resolve a nonexistent `_ENV` global. 2.9.62 exports and explicitly binds that stable table before ClassicUI/LateRuntime registration and adds a Release Safety tripwire.

No Runtime PASS is claimed until Yellow is relaunched and Nuzlocke loads successfully.

# Nuzlocke 2.9.62

This is a focused release-blocking load hotfix for the Yellow 2.9.61 failure. The encounter tracker already owned `GEN1_SEED_IDS`, but that table was not exported during the 2.9.53 tracker split; `main.lua` therefore passed nil to ClassicUI and LateRuntime, causing the required dependency assertion to abort Nuzlocke loading.

2.9.62 exports and explicitly binds the existing stable table before those consumers register, and adds a split-safety Release Safety guard. No Runtime PASS is promoted by static/package validation.

# Nuzlocke 2.9.61

This focused runtime-repair release addresses defects observed during Red testing without reopening the mostly-good encounter/area-log presentation. It repairs Randomizer Evolution Balance labels, normalized preset warnings, F. Token live reporting, randomized-starter history attribution, live Almanac randomizer reporting, NUZ MENU scrolling/order, END RUN/ABANDON selection, and battle-specific item-denial messaging.

The encounter/area log cleanup is deliberately deferred to a later focused pass. No Runtime PASS is promoted by packaging/static validation alone.

# Nuzlocke 2.9.60

This build advances Nuzlocke's full Gen1Recomp source/documentation compatibility review through **0.2.39**. The release's new PresentSync/PresentProbe and revised VSync/FrameCap/FixedStep behavior are explicitly treated as engine-owned presentation pacing; Nuzlocke only exposes passive diagnostic status and does not interfere with the engine's timing or synchronization controls.

The Gen-II mod API model and HiddenItems pickup signatures were revalidated. The unresolved Random Field Items issue is therefore still a runtime-diagnosis item rather than an identified 0.2.39 API break.

No runtime certification is promoted by this source review.

# Nuzlocke 2.9.59

This release hardens Nuzlocke against the supplied Shiny Pokemon 1.2.41 maintained fork. It updates the explicit compatibility baseline, consumes Shiny's newer validation/lifecycle evidence when available, records cross-project audit freshness, expands the reviewed voxel/3D ownership matrix, and adds conservative no-double-recolor source ownership plus release-safety tripwires.

The existing single-owner shiny architecture is preserved: a healthy external Shiny provider owns shiny generation/presentation; Nuzlocke consumes shiny identity for challenge policy and tracking. Standalone Nuzlocke behavior, shiny odds, Gen-II native ownership, and renderer/resource invalidation policy are not intentionally changed.

No new runtime certification is claimed.

# Nuzlocke 2.9.58

This is a focused post-audit defect-repair release. It fixes a Random Trainers scope bug, AUTO compatibility provider fallback, and a Gen-II NUZ STATUS live-game lookup issue. It also corrects Randomizer algorithm-version diagnostics and adds regression coverage. Random Field Items are intentionally unchanged pending runtime evidence.

No save schema or public API version changes are made, and this release does not claim new runtime certification.

# 2.9.57

- Fixed the PokemonIdentity future-save-schema mutation guard by threading `saveSchemaTooNew` through a live getter.
- Added owner-aware Release Safety source routing and reconciled moved World Building, Forgiveness, compatibility, and DEV diagnostic checks.
- Added source-owner readability and PokemonIdentity future-schema guard regression checks.
- No gameplay feature, save-schema, public API, or Runtime PASS change.

# Nuzlocke 2.9.57 — Evolution policy module

2.9.56 is a strict child of exact packaged 2.9.55 (`8ee4efa0f4908f935cbd10f986f583dfd30b5c5a592eafe8687dba3cd9979dbb`).

This build moves Evolution Limits and Trade Evolution QoL into the new `evolution_policy.lua` owner over the shared `evolution.check` seam. Randomizer evolution mappings, UI/config rendering, Pokemon identity/provenance, and acquisition policy remain outside the module. Mutable current-game state is resolved through a live getter.

The protected package inventory intentionally advances to **37 files / 27 Lua modules plus `mod.card`**. Save Schema 5, Compatibility API 37, Diagnostics API 1, Translation API 2, Run History v2, and Randomizer algorithm v1 are unchanged. No new Runtime PASS is claimed.

Further consolidation/relocation into Lua modules is paused after this build by user direction.
