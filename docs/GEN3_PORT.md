# Generation 3 beta — implementation overview

**Release target:** Nuzlocke **v3.0.0-BETA** · **Mod API:** 2 · **Save namespace:** `gen3_classic_v1`.

Gen 3 has an isolated `gen3_runtime.lua` selected by `entry.lua` for **FireRed, LeafGreen, Ruby, Sapphire and Emerald**. **Red, Blue, Yellow, Gold, Silver and Crystal** continue using the existing Gen 1/2 `main.lua`, including their original compatibility and save history.

The definitive **ported / adapted / new** classification is the [Gen 3 feature matrix](GEN3_FEATURE_MATRIX.md). Only v3-specific features are claimed here; earlier releases and collaborators retain their historical credit in [CREDITS.md](../CREDITS.md).

## Starting a run

- **NEW GAME** opens the native **NEW RUN SETUP** before the introduction. Configure the same CORE/CLAUSES/ADVANCED RULES/PLAYSTYLES controls used in-game, plus setup-only QOL resources. **LOCK FOR RUN** optionally prevents later rule changes.
- The first encounter counts **only after catch access is unlocked**, rather than exhausting early routes before the player has Poké Balls. Setup-only Balls are deferred to PC storage until the native catch-unlock point. On an existing save, Nuzlocke is opt-in under **NUZ RULES → CORE**.
- **NUZ RULES** presents CORE, CLAUSES, HARDCORE, GAME DIFFICULTY, RUN/PARTY, LEVELS, PLAYSTYLES, ADVANCED RULES, RANDOMIZER, QOL and QOL SETUP ONLY. The nine advanced categories are **Catch Rules, Battle Clauses, Status Bans, Variants, Battle Items, Field Items, Services & Economy, Pokémon Stats and Area Splits**. These categories now have implemented options; only individual explicitly unsupported rules are unavailable.
- The menu uses a 240×160 GBA-native layout with paginated/scrollable rows. Player-visible locations and Pokémon use friendly display names rather than raw internal IDs where resolvable.
- Gen 3 has no visible Nuz Dev home row. Hold **Select + A** on the NUZ MENU to unlock the developer-only screen; enabling edits flags the save. See [Nuz Dev](GEN3_NUZ_DEV.md).

## Journal, compatibility and results

- **RUN JOURNAL** consolidates the former Almanac/Status/Notices concepts: run overview, encounter and graveyard shortcuts and the latest 100 saved rule-event notices. It reuses the old notice data with no save migration.
- **MOD SUPPORT** reports live detection for **Untamed Advanced, National Dex Gen 3, G9 Battle Sprites, Modern Spawns and Gen 3 HD Sprites**, alongside external shiny/randomiser providers. Where a companion publishes a public API, the menu checks that the expected functions exist and reads its active/inactive status when safely available. Untamed's hook-based integration can only be detected, not verified through a public API. **DETECTED**, **API READY**, **INACTIVE** and **NOT VERIFIED** remain distinct: none certifies the combined game/mod stack. The screen is read-only and does not take over gameplay ownership.
- **END RUN** provides an explicit finalisation flow, preserves native save handling and opens the final screen. Champion and loss have different continuation policies; party/graveyard/stats export supports shiny details. See [Run results](GEN3_RUN_RESULTS.md).

**Implemented is not the same as ROM-certified.** Automated tests and menu controls do not guarantee parity across all five editions or external mods.

## What works now

| Feature | Behaviour and reference |
| --- | --- |
| **CORE** | Nuzlocke Enabled, Permadeath, One Encounter Per Area, Failed Encounters, Nickname Requirement, First Rival Mercy, Whiteout Ends Run and PC Survivors Allowed. See [CORE specification](GEN3_CORE_SPEC.md). |
| **CLAUSES** | Dupes, Shiny Catch Exception, Shiny Rate, Roamer Clause, Egg Encounter and Route Forgiveness. See [Clauses](GEN3_CLAUSES.md) and [Eggs and Forgiveness](GEN3_EGGS_FORGIVENESS.md). |
| **PLAYSTYLES** | **Shiny Nuzlocke** restricts catches to shinies; **Hardcore Nuzlocke** forces strict encounter/death rules, SET style, no battle items except Balls, and Gym/League caps through Champion. Modes may combine. See [Playstyles](GEN3_PLAYSTYLES.md). |
| **LEVELS** | Gym/Elite Four/Champion/Postgame cap scopes, native EXP clamping and optional EXP banking (EXP Edging). Native Rare Candy checks. See [LEVELS](GEN3_LEVELS.md). |
| **RANDOMIZER** | Seeded starter, step/fishing, static, gift/Egg, trainer, field/gift items, shop, TM, move-learnset and evolution randomisation with supported presets, generation/pool limits and balancing. See [Randomiser](GEN3_RANDOMIZER.md). |
| **Overworld wild compatibility** | Untamed-Advanced's generated wandering Pokémon use the same Random Wild setting/seed via `untamed.owe.species`, before the sprite and battle are constructed. |
| **Player feedback** | Rule explanations during relevant native battles plus RUN JOURNAL (run recap, event history, encounter/graveyard links). See [Feedback](GEN3_FEEDBACK.md). |
| **Player tools** | Native encounter tracker, graveyard, nickname tasks and hidden Nuz Dev test utilities (including safe full-archive restoration). See [Nuz Dev](GEN3_NUZ_DEV.md). |

### Encounter and death handling

The first eligible wild encounter is recorded against its **resolved encounter area**. Native map IDs are used as the source identity, while [Area Splits](GEN3_AREA_SPLITS.md) can group or separate floors and sections depending on the configured policy.
With Failed Encounters enabled, that attempt spends the area even if the
Pokémon escapes or faints; when **Shiny Nuzlocke** is active, only an
eligible *shiny* attempt can spend the area. When Failed Encounters is
disabled, the first eligible successful
catch closes the area. Dupes and Shiny eligibility are resolved before
claiming the route. Native Balls still run through the normal catch
transaction, which explains denial reasons.

A player Pokémon that faints is recorded for Permadeath in the battle
and moved to the save-local graveyard after the native battle completes.
The mod does not delete the native save. Whiteout Ends Run takes priority
over rescuing a living eligible PC survivor. Gifts/trades/hatched Pokémon
without custom nicknames are listed under Nickname Tasks; some non-catch
naming and battle-eligibility edge cases still require testing.

### Random Wild + Untamed-Advanced

Untamed's generated overworld encounters do not use Gen 3's regular
`encounter.species` hook. The compatible Untamed branch exposes
`untamed.owe.species`, which Nuzlocke supplies with a seed-stable
replacement **before sprite rendering, cry, and the ensuing wild battle**.

- The visible species is the one battled and caught.
- Replacements use the same Random Wild settings and seeded candidate pool.
- The chain popup tracks the **visible, defeated species** (e.g.,
  Feraligatr instead of the original Rattata encounter slot). Untamed
  privately retains the original slot for repeated-spawn odds.
- Followers, roamers, outbreaks, Feebas specials and manually scripted
  actors are excluded from this hook.
- Untamed works without Nuzlocke; Nuzlocke's usual step encounters work
  without Untamed. Both compatible builds are needed for the integration.

[Untamed-Advanced](https://github.com/Deluxe0111/Untamed-Advanced) documents
its own follower, overworld-wild and encounter-chain features and credits
the Nuzlocke compatibility integration there.

## Known beta boundaries

- Gen 1/2-only features are not automatically offered in Gen 3; the feature matrix records the supported Gen 3 controls.
- Area grouping and splits operate on the native map source and configured policy; unknown third-party map identities still need testing.
- Field/story revival, non-catch nickname eligibility, unusual trainer
  modes, special scripted losses, link/facility encounters and certain
  item-provider overlaps still need native-ROM validation.
- Randomiser seed/settings lock after first successful replacement to
  prevent contradictory mappings on the same save.
- Ordinary Route Forgiveness Pokémon revival remains unavailable. A complete snapshot may be restored only with the hidden, tainting Nuz Dev tool; old/incomplete memorials cannot be reconstituted. Back up saves before testing death/whiteout paths.

## Testing and reference material

Run the isolated Gen 3 Lua checks under `.github/workflows/gen3-smoke.yml`
or follow [Gen 3 test checklist](GEN3_TEST_CHECKLIST.md). The
[Randomiser checklist](GEN3_RANDOMIZER.md) includes an Untamed-specific
visible-spawn, species-matching and chain test section.

**Passing mocked tests does not guarantee real-ROM behaviour.** Test
FireRed, LeafGreen, Ruby, Sapphire and Emerald separately on disposable
saves, and retest combinations of installed mods.
