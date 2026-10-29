# Documentation index

This index separates the **current Generation 3 beta** from the **existing Generation 1/2** reference and historical development records. Version-specific notes are preserved rather than rewritten for newer functionality.

## Start here — v3.0.0-BETA

- **[Feature matrix](GEN3_FEATURE_MATRIX.md)** — the canonical ported, adapted and new Gen 3 feature list, plus limitations.
- **[Implementation overview](GEN3_PORT.md)** — Game3 architecture, menus, progression, existing integrations and beta boundaries.
- **[Manual test checklist](GEN3_TEST_CHECKLIST.md)** — edition-by-edition scenarios, UI, randomiser, end-run and integration tests.
- **[Developer guide](DEVELOPER_GEN3.md)** — repository setup, architecture, native hooks and testing.
- **[Run results](GEN3_RUN_RESULTS.md)** — loss/Champion results, saving and final shareable graphics.
- **[NUZ DEV](GEN3_NUZ_DEV.md)** — hidden access and safe, audited test operations.

## Gen 3 rules and mechanics

| Area | Documentation |
| --- | --- |
| Core and catch restrictions | [CORE](GEN3_CORE_SPEC.md) · [Catch Rules](GEN3_ADVANCED_RULES.md) |
| Core encounter clauses | [CLAUSES](GEN3_CLAUSES.md) · [Eggs and Forgiveness](GEN3_EGGS_FORGIVENESS.md) |
| Battle and status | [Battle Clauses](GEN3_BATTLE_CLAUSES.md) · [Status Bans](GEN3_STATUS_BANS.md) · [Battle Items](GEN3_BATTLE_ITEMS.md) |
| Other advanced rules | [Variants](GEN3_VARIANTS.md) · [Field Items](GEN3_FIELD_ITEMS.md) · [Services and Economy](GEN3_SERVICES_ECONOMY.md) |
| Area, party and statistics | [Area Splits](GEN3_AREA_SPLITS.md) · [Run / Party](GEN3_RUN_PARTY.md) · [Pokémon Stats](GEN3_POKEMON_STATS.md) |
| Difficulty | [Hardcore Rules](GEN3_HARDCORE_RULES.md) · [Game Difficulty](GEN3_GAME_DIFFICULTY.md) · [Playstyles](GEN3_PLAYSTYLES.md) · [Levels](GEN3_LEVELS.md) |
| Randomisation | [Gen 3 Randomiser](GEN3_RANDOMIZER.md) |
| Quality of life | [QOL](GEN3_QOL.md) · [Setup-only QOL](GEN3_QOL_SETUP.md) |
| Messages | [Feedback and Notices](GEN3_FEEDBACK.md) |

## Existing Gen 1/2 implementation and cross-project APIs

- [Legacy user guide](USER_GUIDE.md) — Gen 1/2 challenge rules and controls.
- [Compatibility register](COMPATIBILITY.md) — historical engine/provider reviews and Gen 1/2 ownership.
- [Public API reference](API.md) — legacy export, compatibility and provider contracts.
- [Feature confidence](FEATURE_CONFIDENCE.md) — evidence/certification levels.
- [Historical testing gates](TESTING.md).

## Release records and historical planning

- [v3 release notes and older releases](../RELEASE_NOTES.md)
- [Full historical changelog](../CHANGELOG.md)
- [Documentation changes](DOCUMENTATION_CHANGELOG.md)
- [Safe fork-release workflow and permission check](RELEASING.md)
- [Current and historical test suites](../tests/README.md)
- [Original contributors and Gen 3 port credits](../CREDITS.md)
- [Early Gen 3 CLAUSES design](GEN3_CLAUSES_NEXT.md) — archived planning snapshot; **not** the current status reference.

Every implemented Gen 3 menu option still requires **real-ROM certification** before being described as fully tested across FireRed, LeafGreen, Ruby, Sapphire and Emerald.
