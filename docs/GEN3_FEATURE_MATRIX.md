# Generation 3 feature inventory — v3.0.0-BETA

**Scope:** FireRed, LeafGreen, Ruby, Sapphire and Emerald. Gen 3 uses an isolated runtime and `gen3_classic_v1` save namespace. **Implemented** means a code path and automated tests exist; it does **not** mean all five ROM editions or mod combinations have passed manual certification.

This is the canonical release-facing distinction between **ported**, **adapted/modified**, and **new-to-Gen-3**. A feature can appear in more than one column where the rule concept existed before but its Gen 3 integration is new.

## Ported challenge features

| Group | Available in Gen 3 beta |
| --- | --- |
| Core | Nuzlocke Enabled, Permadeath, One Encounter Per Area, Failed Encounters Count, mandatory wild-catch nickname, First Rival Mercy, Whiteout Ends Run, PC Survivors Allowed |
| Clauses | Dupes SPEC/FAM/SPLIT, Shiny catch exceptions, Shiny Rate, independent Roamer slots, Egg Encounter provenance, Route Forgiveness tokens and missed-route reopening |
| Levels and difficulty | Gym/Elite Four/Champion/Postgame level-cap scope, EXP Edging/EXP bank, Game Difficulty presets, Hardcore battle restrictions |
| Run / party | Team and party size restrictions, evolution limits, run progression controls |
| Catch rules | Species restrictions (Legendary, Mythical, Pseudo, BST, individual National Dex bans up to #1025 when registered), No Static, No Fishing, Town Catches, optional gifts/trades and encounter-slot policies, Colorlocke/Alphabetlocke, Allow Glitches |
| Battle and status | OHKO, Flinch, Trap, setup, evasion, accuracy/stat-drop clauses; No Status Moves, Paralysis, Confusion, Sleep, Poison, Burn, Freeze and Sleep Clause |
| Variants | Type Locke (one to six type lanes), saved random type selection, Catch Draft |
| Items and services | Battle items, Ball limits, field items, TMs/HMs distinction, travel restrictions, Pokémon Centre/Mom/Day Care, shops/gambling, trainer money |
| Pokémon stats / areas | EV/stat-experience and IV options, configurable Kanto/Hoenn route and dungeon splits, Safari handling |
| QoL | Instant Text, Run/Surf, Unlimited Bag Space and trade-evolution controls |
| Player records | Encounter Tracker, Graveyard, species/area display names, persistent notices and rule inspection |

## Adapted or modified for Generation 3

| Area | What changed from the Gen 1/2 implementation |
| --- | --- |
| Runtime and persistence | `entry.lua` selects isolated `gen3_runtime.lua`; Gen 3 uses native Game3 event/transaction boundaries without changing Gen 1/2 save schema or mod API 2 |
| Catching and acquisition | First encounters begin counting only after catching becomes possible; optional gift and NPC trade operations are checked before the native mutation; catch/area rules apply to visible Untamed wilds |
| Battle and permadeath | Uses Gen 3 battle copies, writeback and native item/move interception; OHKO fails at the native accuracy seam, and revival items cannot bypass permadeath |
| Shiny | Gen 3 shiny odds and shiny identity integrate with native Pokémon data, ROM front sprites and the existing mini-icons; compatible external shiny provider gets rate ownership |
| Randomiser | Seeded mappings for Gen 3 starters, ordinary/static/gift/egg encounters, trainers, items, shops, TMs, learnsets and evolutions; optional API-v2 National Dex roster up to 1,025 bases + 128 opt-in forms; Gen 1-9 pool filters, BST balance and source exceptions |
| Route identity | Gen 3-specific Kanto/Hoenn area grouping and optional area splits replace the initial map-only approximation |
| Interface | 240×160 GBA menu, rule descriptions, per-page scrolling, readable species/route names and new-game setup integration |

## New v3 functionality

| Feature | What players get |
| --- | --- |
| Shiny Nuzlocke | Only eligible shiny wild encounters count for catches; normal encounters do not consume area opportunities |
| Combined Hardcore + Shiny | Independently selectable playstyles whose compatible restrictions can operate together |
| New Run setup and lock | Configure CORE, advanced rules, playstyles, randomiser and setup-only resources at NEW GAME; optionally lock run settings |
| Setup-only starting resources | Starting Balls/candies/money and PC supplies, with deferred Balls until the native catch-unlock boundary |
| Untamed Advanced collaboration | Seed-consistent randomisation of visibly wandering wild Pokémon before spawning, so overworld sprites, fights and catches agree |
| Run Journal | One live run overview with area, death and catch summaries, encounter/graveyard shortcuts and retained event history |
| End Run/results | Terminal loss/forfeit/Champion outcomes, native save integration and shareable single-image party/graveyard/statistics poster with shiny artwork where available |
| Mod Support | Read-only live detection of Untamed Advanced, National Dex Gen 3, G9 Battle Sprites, Modern Spawns and Gen 3 HD Sprites, with public API readiness and active-status diagnostics where exposed; no unsafe ownership overrides or automatic combined-runtime certification |
| Hidden Nuz Dev tools | Session-only access, audited test-save state edits, encounter resets and guarded full-archive graveyard restoration |

## Current limitations / certification tasks

- **In-development National Dex roster:** full randomiser species coverage depends on the installed `national_dex_gen3` API v2. Alternate forms are opt-in; no provider means the vanilla roster. Separate Modern Spawns encounter ownership, expanded sprite rendering and colour metadata still require real six-mod validation.

- Manual ROM validation remains required across **all five Gen 3 editions**, including failed runs, Champion continuation, artwork export, native move/item edge cases and option combinations.
- Gift/trade/Egg Pokémon with pending required nicknames are recorded in **Nickname Tasks**; battle-use denial for every non-catch acquisition path is not yet guaranteed.
- Third-party custom gifts/trades, randomisers and UI providers can expose different native boundaries; detected compatibility is not equivalent to a tested combination.
- Egg receipt/hatch provenance can depend on the game's supported event path; not every scripted gift is certified.
- **Ordinary Route Forgiveness Pokémon revival is not implemented.** The **developer-only** complete-archive restore tool is intentionally separate and permanently flags a testing save.
- Gen 2-only systems such as clock/day splits and Cherrygrove-specific shortcuts are **not** Gen 3 features. Wonderlocke has been **removed** from Gen 3.
- The supported Gen 1/2 behaviour and older version-specific feature claims remain documented separately; this page makes no retroactive claims about those releases.

## Useful references

[Gen 3 overview](GEN3_PORT.md) · [Test checklist](GEN3_TEST_CHECKLIST.md) · [Randomiser](GEN3_RANDOMIZER.md) · [Run results](GEN3_RUN_RESULTS.md) · [Credits](../CREDITS.md)
