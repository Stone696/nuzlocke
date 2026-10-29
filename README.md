# Nuzlocke v3.0.3-beta

Configurable Pokémon challenge rules for [Gen1Recomp](https://github.com/bryanthaboi/gen1recomp), with a new **Generation 3 beta port** and the established Generation 1/2 mod preserved.

**Supported games:** Red, Blue, Yellow · Gold, Silver, Crystal · **FireRed, LeafGreen, Ruby, Sapphire, Emerald (Gen 3 beta)**.

**Installed version:** `3.0.3-beta` · **Mod API:** 2 · **Gen 3 save namespace:** `gen3_classic_v1`.

> **Beta:** automated smoke tests cover many rules and native hook contracts. All five Gen 3 ROM editions and third-party mod combinations still need manual validation. Back up saves, particularly before Permadeath, End Run and randomiser testing.

> **v3.0.3-beta:** Player-controlled starter rerolls (OFF / 1 / 3 / 5 / UNLIMITED), saved reroll counts, matching rival starters and improved guidance for optional Untamed Advanced / Modern Spawns compatibility. See [release notes](RELEASE_NOTES.md) for changes since v3.0.2-beta.

## Getting started

1. Install Gen1Recomp with your own supported game files and install Nuzlocke from the mod manager.
2. Start a **new Generation 3 game** to configure rules in **NEW RUN SETUP** (including optional **LOCK FOR RUN**), or open **Start → NUZ MENU → NUZ RULES → CORE** in-game.
3. Enable **Nuzlocke Enabled**; the rule is opt-in. Randomiser and selected QoL features can operate independently of the Nuzlocke challenge switch.
4. Set the **randomiser seed and options before the first randomised result**; settings lock when mappings have begun. If configured beforehand, **starter rerolls** are still allowed at the starter-choice screen (RSE: **Select**) or in Oak's lab (FRLG: **RANDOMIZER → REROLL STARTERS NOW**). For gameplay testing, use a disposable save.

## What's in v3.0.3-beta?

| Category | Features |
| --- | --- |
| **CORE & CLAUSES** | Permadeath, one encounter per area, failed encounters, mandatory catch naming, first-rival mercy, whiteout, PC survivors; Dupes, Shiny exceptions/rate, Roamer, Egg and Route Forgiveness |
| **PLAYSTYLES** | **Shiny Nuzlocke**, **Hardcore Nuzlocke**, or both together |
| **LEVELS, HARDCORE & DIFFICULTY** | Gym/League/Postgame level caps, EXP Edging, SET battle restrictions, optional hardship rules and difficulty profiles |
| **ADVANCED RULES** | Catch bans and gifted/traded Pokémon; OHKO/Battle Clauses; Status Bans/Sleep Clause; Type Locke/Catch Draft; battle/field items; services and economy; Pokémon stats; Kanto/Hoenn area splits |
| **RANDOMIZER** | Seeded Gen 3 starter, wild, trainer, static/gift/Egg, items/shops/TM, learnset and evolution randomisation; optional National Dex Gen 3 API-v2 species pool up to #1025, opt-in alternate forms, generation and BST filters; manual 0/1/3/5/unlimited starter rerolls with saved counters |
| **QOL & SETUP** | Instant Text, Run/Surf, bag and trade-evolution options; new-game starting resources, native catching unlock and settings lock |
| **RUN JOURNAL & RESULTS** | Encounter tracking, Graveyard, regional/form-aware names, readable event history, End Run, Champion/failed-run results and shareable single-image memorial/team poster with extended/shiny artwork where a supported provider exists |
| **MOD SUPPORT & NUZ DEV** | Live read-only diagnostics for Untamed Advanced, National Dex Gen 3, G9 Battle Sprites, Modern Spawns, Gen 3 HD Sprites and existing shiny/randomiser providers; hidden developer testing tools |

For a detailed **ported vs adapted vs new** breakdown, see the **[Gen 3 feature matrix](docs/GEN3_FEATURE_MATRIX.md)**. This matrix is the current v3 feature inventory rather than the historically evolving notes from early beta development.

### Untamed-Advanced integration

When a compatible [Untamed Advanced](https://github.com/Deluxe0111/Untamed-Advanced) build is installed, Nuzlocke's **Random Wild** option also randomises eligible visible wandering wild Pokémon **before** their sprite and battle are built. This shares seed, candidate pool and species legality with ordinary wild encounters, so the Pokémon shown, battled and caught agrees. Story actors, special roamers, followers and scripted exclusions remain governed by their respective mods.

Untamed is an **optional** companion. Newer Untamed Advanced builds separately integrate Modern Spawns' COMPLETE/RANDOM per-spawn species draws; **that functionality ships in Untamed Advanced, not in the Nuzlocke ZIP**. With Nuzlocke RANDOM WILD enabled, the Nuzlocke hook can further replace Untamed's selected species. The combined stack still needs in-game verification. The Nuzlocke **MOD SUPPORT** screen reports detected integrations but does not automatically certify them or take control of another mod's renderer.

### Important boundaries

- **NICKNAME TASKS** tracks unnamed gifts, trades and hatched Pokémon, but pending non-catch names may not yet prevent battle use on every path.
- **Route Forgiveness** supports missed-route token redemption; **normal Pokémon revival** remains unavailable. The separate hidden **NUZ DEV** full-archive restore is for testing only.
- Gen 2-only mechanics aren't misrepresented as Gen 3 options. **Wonderlocke was removed** from the Gen 3 catalogue.
- **Gen 1/2** continue to use the established `main.lua` runtime and save structures. The v3 port has its own implementation; existing legacy rules and records are not replaced.

## Documentation

[Browse the complete documentation index](docs/README.md) for current Gen 3 guides and preserved Gen 1/2 references.

| What you need | Reference |
| --- | --- |
| Full Gen 3 feature classification | [Ported, adapted and new features](docs/GEN3_FEATURE_MATRIX.md) |
| Native integration, editions and current limits | [Gen 3 overview](docs/GEN3_PORT.md) |
| CORE and rule precedence | [Core rule specification](docs/GEN3_CORE_SPEC.md) |
| Rules, playstyles, clauses and menus | [Advanced Catch Rules](docs/GEN3_ADVANCED_RULES.md) · [Playstyles](docs/GEN3_PLAYSTYLES.md) · [Battle Clauses](docs/GEN3_BATTLE_CLAUSES.md) · [Status Bans](docs/GEN3_STATUS_BANS.md) |
| Other advanced rule categories | [Variants](docs/GEN3_VARIANTS.md) · [Services](docs/GEN3_SERVICES_ECONOMY.md) · [Area Splits](docs/GEN3_AREA_SPLITS.md) · [Run/Party](docs/GEN3_RUN_PARTY.md) |
| Randomiser and Untamed interoperability | [Gen 3 Randomiser](docs/GEN3_RANDOMIZER.md) |
| Final screen and shareable results | [Run results](docs/GEN3_RUN_RESULTS.md) |
| Manual test cases and developer setup | [Gen 3 checklist](docs/GEN3_TEST_CHECKLIST.md) · [Developer guide](docs/DEVELOPER_GEN3.md) · [Hidden NUZ DEV](docs/GEN3_NUZ_DEV.md) |
| **Gen 1/2** behaviour and compatibility | [Legacy user guide](docs/USER_GUIDE.md) · [Compatibility reference](docs/COMPATIBILITY.md) |
| Versions and authorship | [v3 release notes and preserved older releases](RELEASE_NOTES.md) · [Full changelog](CHANGELOG.md) · [Credits](CREDITS.md) |

## Releasing and maintaining this fork

The [release guide](docs/RELEASING.md) explains the already-published v3 prerelease, safe future manual releases, deterministic player ZIPs, original contributor attribution and the missing upstream licence clarification. The [test suite inventory](tests/README.md) documents why active Gen 3 smoke tests stay in the repository but are excluded from player downloads.

## Credits

**[bryanthaboi](https://github.com/bryanthaboi)** created the original Nuzlocke mod; **[Stone696](https://github.com/Stone696)** continued its development, including significant Generation 1/2 features and compatibility work; **[masterwebx](https://github.com/masterwebx)** created the original Shiny Pokémon mod forming part of the shiny feature's lineage. **[Deluxe0111](https://github.com/Deluxe0111)** developed the Generation 3 port and its new integrations/features. See **[CREDITS.md](CREDITS.md)** for distinct contributions and project context.

**Release history:** Older `2.9.x` and preceding versions are retained in the changelog and tags. They are not being renamed to v3 or retroactively credited to the Gen 3 port.
