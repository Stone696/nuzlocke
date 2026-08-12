# Nuzlocke

A configurable, enforced Nuzlocke ruleset for **Pokémon Gen1Recomp**.

Version **2.0.0-beta.27** is the new canonical public baseline, promoted directly from **beta.26.6**. The promotion itself intentionally changes only version/release metadata; gameplay code is the same beta.26.6 code that was runtime-tested immediately before release.

> **Current release status:** R/B/Y startup and core beta.26 systems have broad runtime coverage, including Yellow rules/tracker/catch behavior on beta.26.6. Gold beta.26.6 also runtime-passes fresh startup into the house, in-game RULES, TRACKER, Catch Info, and Cyndaquil starter acquisition. Gold remains **Beta / Experimental**: forced nicknames currently fail, Gold has no NUZ STATUS Trainer Card surface because its native card already uses both sides, and ordinary Gold gift-denial plus Gold Whiteout consequence still require dedicated runtime tests. A previously observed Yellow battle-lag report remains under investigation; static comparison has not identified a new beta.26.1/.26.2 per-frame battle update/draw hook.

## Requirements

- Gen1Recomp **0.1.78 or newer**, below 2.0.0.
- Mod API **2**.
- `engine_internals` permission.

## Installation / update

Install these files together in the Nuzlocke mod folder:

- `main.lua`
- `manifest.json`
- `README.md`
- `CHANGELOG.md`

Development/testing packages may also include:

- `DEV_ROADMAP.md`
- `BETA26_TEST_PLAN.md`
- `REVISION_NOTES.md`

After replacing an older build, fully quit Gen1Recomp and relaunch it. Existing Nuzlocke saves remain on save schema **4**.

## beta.27 release

beta.27 promotes **beta.26.6 directly** to the new public baseline. No gameplay rule, event hook, tracker behavior, battle behavior, or UI path was intentionally changed during this promotion.

### Runtime evidence added before promotion

- **Gold beta.26.6:** fresh startup works and New Game reaches the player's house.
- **Gold beta.26.6:** in-game **RULES** and **TRACKER** menus appear and function in the tested fresh run.
- **Gold beta.26.6:** Catch Info appears and functions.
- **Gold beta.26.6:** Cyndaquil starter acquisition succeeds, confirming the new Gold gift gate does not block the mandatory starter path.
- **Gold beta.26.6:** Forced Nicknames **FAIL**; the starter was not prompted for a nickname. This remains an open Gold adapter bug.
- **Gold beta.26.6:** Gold's native Trainer Card already has two sides, so the R/B/Y NUZ STATUS back-side approach does not surface. A generation-native Gold status-access design is still required.
- **Yellow beta.26.6:** in-game RULES and TRACKER continue to function on the tested save.
- **Yellow beta.26.6:** catch behavior and encounter tracking continue to function correctly.
- **Yellow beta.26.2:** toggling 1st Catch after an area's first encounter had already happened behaves correctly.

### Still test-required after beta.27 publication

- Gold ordinary allowed gift and rejected/used-area gift enforcement.
- Gold Whiteout ON run termination and Whiteout OFF vanilla blackout regression.
- Gen 1 Whiteout teardown from beta.26.5.
- Fallback/external `pokemon.received` gift/trade classification.
- beta.26.4 failed-result marquee and progression-aware TV.
- battle-text wrapping/paging and the open Yellow battle-lag A/B investigation.

## Runtime confirmation for beta.27

| Test | Status |
| --- | --- |
| Blue fresh title shows SETUP | **PASS** |
| Blue Oak intro → bedroom | **PASS** |
| Yellow fresh title/startup path | **PASS** |
| Gold shows NUZLOCKE GOLD / BETA SETUP | **PASS** |
| Gold fresh New Game → house | **PASS (26.6)** |
| Gold in-game RULES | **PASS (26.6)** |
| Gold in-game TRACKER | **PASS (26.6)** |
| Gold Catch Info | **PASS (26.6)** |
| Gold Cyndaquil starter acquisition | **PASS (26.6)** |
| Gold Forced Nicknames | **FAIL / OPEN** |
| Gold NUZ STATUS Trainer Card surface | **NOT AVAILABLE / REDESIGN NEEDED** |
| Gold individual Setup gameplay options | **BETA / TEST REQUIRED** |
| Yellow starting Money | **PASS** |
| Yellow starting Rare Candies | **PASS** |
| Yellow forced starter nickname | **PASS** |
| Yellow Trainer Card has only front + NUZ STATUS | **PASS** |
| Yellow pre-Ball Shiny Clause ON does not consume area | **PASS** |
| Yellow pre-Ball Shiny Clause OFF does not consume area | **PASS** |
| Blue Pokédex handoff activates route ledger | **PASS** |
| Blue configured starting Balls appear in home PC after Pokédex | **PASS** |
| Blue post-activation first encounter logs normally | **PASS** |
| Blue second used-area shiny with Shiny Clause OFF is denied | **PASS** |
| Yellow PokéCenter healing ON/OFF | **PASS** |
| Red existing-save No Buying / No Selling | **PASS** |
| Blue existing-save No Buying / No Selling | **PASS** |
| Yellow fresh-run No Buying / No Selling | **PASS** |
| Red/Blue fresh-run Mart parity | **RETEST RECOMMENDED** |
| Red Gym Guide Rare Candy service | **PASS** |
| beta.26.2 Gym Guide visual centering | **RUNTIME TEST REQUIRED** |
| Yellow No Mom Heal replaces vanilla Mom dialogue | **PASS** |
| Yellow starter Catch Info = Pallet Town immediately | **PASS** |
| beta.26.1 battle wrapping / paging | **RUNTIME TEST REQUIRED** |
| Yellow first-rival T3 timing after trainer reveal | **PASS / COMPLETE** |
| beta.26.3 second activation popup = Area Guide only | **RUNTIME TEST REQUIRED** |
| beta.26.3 allowed-Mom T3 de-duplication | **RUNTIME TEST REQUIRED** |
| beta.26.3 home-TV T3 base interaction | **RUNTIME TEST REQUIRED** |
| beta.26.4 progression-aware TV recap | **RUNTIME TEST REQUIRED** |
| Yellow UI controls OFF paths | **PASS** |
| Yellow 1st Catch toggle after prior area encounter | **PASS** |
| Yellow beta.26.6 RULES / TRACKER smoke | **PASS** |
| Yellow beta.26.6 catch behavior / encounter tracking | **PASS** |
| Yellow failed encounter writes Tracker state | **PASS** |
| Tracker/NUZ STATUS show next active cap | **PASS** |
| beta.26.4 failed-result marquee | **RUNTIME TEST REQUIRED** |
| beta.26.5 fallback gift/trade classification | **RUNTIME TEST REQUIRED** |
| beta.26.5 Gold native New Game resources preserved | **RUNTIME TEST REQUIRED** |
| beta.26.5 Gen 1 Whiteout engine teardown + run deletion | **RUNTIME TEST REQUIRED** |
| Gold ordinary gift pre-transaction enforcement | **RUNTIME TEST REQUIRED** |
| Gold Whiteout run-ending consequence | **RUNTIME TEST REQUIRED** |
| beta.26.2 reported battle lag | **OPEN / A-B PROFILE NEEDED** |

Runtime evidence outranks static analysis. Paths already runtime-confirmed remain protected from unrelated changes.

## Game support

| Game | Status | Notes |
| --- | --- | --- |
| Red | Supported | Existing-save menus and multiple gameplay rules are runtime-confirmed. Fresh-run coverage continues to expand. |
| Blue | Supported | SETUP/startup, Soft Start activation, post-activation encounter logging, and multiple rule paths are runtime-confirmed. |
| Yellow | Supported | SETUP/startup, starting resources, forced starter naming, Soft Start behavior, and PokéCenter toggles have runtime confirmation. |
| Gold | **Beta / Experimental** | Startup/house boot, RULES, TRACKER, Catch Info, and Cyndaquil acquisition runtime-pass on beta.26.6. Forced Nicknames currently fail; Gold NUZ STATUS access needs a generation-native design; gift denial and Whiteout remain test-required. |
| Silver | Groundwork only | Not targeted by the manifest and not advertised as runnable. |
| Crystal | Groundwork only | Not targeted by the manifest and not advertised as runnable. |

Gold is intentionally **not** treated as Red with different data. The manifest targets `gen1` and `gold`, while Silver/Crystal remain future GSC-family architecture only.

## New Game setup

### Red / Blue / Yellow

When there is no vanilla **CONTINUE** entry, the title menu adds **SETUP** before **NEW GAME**. This stages the Nuzlocke profile for the next New Game without modifying an existing save.

New-Game-only resources include:

| Setting | Range | Behavior |
| --- | ---: | --- |
| Starting Money | 0–9,999 | Sets New Game starting money. |
| Starting Poké Balls | 0–99 | Withheld during Soft Start, then delivered to the **home PC after the Pokédex handoff** when the challenge ledger activates. |
| Starting Rare Candies | 0–99 | Places that many Rare Candies in the bedroom PC at New Game. |
| Gym Guide Rare Candy | Off / On | Enables the R/B/Y Gym Guide Rare Candy utility. |

The chosen starting Money, Poké Balls, and Rare Candies are also saved as an immutable setup snapshot and shown in **NUZ STATUS**. Spending or consuming those resources does not rewrite the recorded start values.

### Gold

Gold has a runtime-confirmed **NUZLOCKE GOLD / BETA SETUP** entry before NEW GAME. It intentionally exposes a smaller rule set than R/B/Y and uses beta-aware descriptions so unproven behavior is not presented as fully supported.

Gold and R/B/Y use separate persisted Setup profiles. Gen1-only or not-yet-ready controls remain hidden on Gold instead of appearing inert.

## Soft Start / encounter activation

Encounter rules remain inert before the run is genuinely armed. In the verified R/B/Y opening flow, configured challenge Poké Balls are withheld until the Pokédex handoff. Pre-Ball wild encounters do not spend the route, including when Shiny Clause is OFF.

At the Pokédex handoff, the route ledger activates and configured starting Poké Balls are delivered to the player's PC at home. Once the encounter system is armed, ordinary first-encounter rules remain active even if the player later has zero Poké Balls.

The starter itself must not arm Soft Start or consume a normal wild-area encounter.

## Locke Type presets

**Locke Type** provides presets using rules already enforced by the mod. Editing a managed rule returns the profile to **CUSTOM**.

| Preset | Core behavior |
| --- | --- |
| CUSTOM | Preserve the player's hand-built settings. |
| NUZ | Permadeath, first encounter, failed encounters, mandatory nicknames. |
| HARD | NUZ + Champion-level caps + no healing/X Items in battle. Use native Battle Style **SET** for the usual Hardcore format. |
| SOLO | NUZ + Solo Only + Whiteout. PC swaps remain available. |

## Rules

### Core

- **Nuzlocke** — master switch.
- **Permadeath** — fainted Pokémon are recorded as dead and removed according to the active generation adapter.
- **1st Catch** — only the first eligible catch per area may be taken once encounter rules are armed.
- **Failed Encounters** — losing the first eligible encounter consumes the area when enabled.
- **Nickname Rule** — supported caught/received Pokémon must receive a nickname.

### Clauses

- **Dupes Clause** — `OFF / SPEC / FAM`.
- **Shiny Clause** — shiny catches can override First Catch/Dupes restrictions when enabled.

### General

- **Overworld**
- **Town Catches**
- **No Legend**
- **No Mythic**
- **Gift Pokémon**
- **In-Game Trades**
- **Wonderlocke WIP** — remains disabled/inactive.

### Hardcore / field / Ironmon

- **Level Cap Scope** — `NONE / GYMS / E4 / CHAMP / POSTGAME`.
- **Expanded Postgame**
- **No Healing Items**
- **No X Items**
- **No Escape**
- **No Repels**
- **No Escape Rope**
- **No Field Heal**
- **No PP Items**
- **No Buying**
- **No Selling**
- **No PokéCenter**
- **No Mom Heal**
- **Whiteout**
- **Solo Only**

Gen1Recomp's native **OPTIONS → BATTLE STYLE** remains the only Set/Shift setting.

### UI / world

- **World Building** — optional flavor tiers. Higher tiers can adapt messages to active rules; rule-specific flavor must remain gated by the rule it references.
- **Catch Info** — Nuzlocke metadata in the party UI.
- **Area Guide** — full-area Tracker page.
- **NUZ STATUS** — Trainer Card back page with run statistics, active rules, and immutable starting-resource information.

## R/B/Y level caps

| Gym | Red / Blue | Yellow |
| --- | ---: | ---: |
| Brock | 14 | 12 |
| Misty | 21 | 21 |
| Lt. Surge | 24 | 28 |
| Erika | 29 | 32 |
| Koga | 43 | 50 |
| Sabrina | 43 | 50 |
| Blaine | 47 | 54 |
| Giovanni | 50 | 55 |

| League battle | Cap |
| --- | ---: |
| Lorelei | 56 |
| Bruno | 58 |
| Agatha | 60 |
| Lance | 62 |
| Champion | 65 |

## Protected runtime-PASS behavior

The following established paths have runtime evidence in the beta.25/beta.26 development line and should not be changed incidentally:

- R/B/Y title SETUP / startup behavior already confirmed.
- Gold pre-New-Game **NUZLOCKE GOLD / BETA SETUP** visibility.
- Soft Start pre-Ball encounter forgiveness.
- Pokédex handoff route-ledger activation and configured challenge-Ball delivery to the home PC.
- Starting Money / Rare Candy setup behavior tested in Yellow.
- Forced starter nickname tested in Yellow.
- Two-page Trainer Card with start-resource rows inside NUZ STATUS.
- No PP Items ON blocks PP Up; OFF restores normal use.
- No Escape enforcement.
- No Healing Items in battle.
- No Field Heal, including current Blue T3 feedback evidence.
- Nickname Rule enforcement.
- No PokéCenter.
- No Repels.
- No X Items.
- Existing-save No Buying / No Selling in Red and Blue.
- Gym Guide Rare Candy NPC/service and 1 / 10 / 25 / 50 / 99 selector mechanics.

Fresh-run / first-entry Mart coverage remains open because older 0.1.79 testing conflicted with the newer existing-save passes.

## Save compatibility

Save schema remains **4**. beta.26.3 adds no schema migration.

Existing migrations remain additive/idempotent, including legacy `no_shopping` → separate No Buying/No Selling, legacy boolean Dupes → numeric `OFF / SPEC / FAM`, and forcing unfinished Wonderlocke state dormant.

## Compatibility API

`mod.exports.nuzlocke_compat` remains at API version **10**. The compatibility/provider architecture remains available for cooperating mods and future generation-specific adapters.

## Validation status

beta.26.3 is a development/test revision. Its Area Guide-only follow-up popup, allowed-Mom Tier 3 de-duplication, and home-TV Tier 3 flavor require direct runtime confirmation. The fresh Yellow beta.26.2 results listed above are protected evidence, including immediate Pallet Town starter metadata, Mom blocked-heal dialogue ownership, PokéCenter behavior, and first-rival Tier 3 timing. Oak/rival duplicate/spacing issues remain open.

Static checks do not replace gameplay testing.

## Credits

- Original Nuzlocke mod and repository: **bryanthaboi**.
- Current beta development/update work: **Stone696**.
- Built for **Gen1Recomp** and its native mod API.

Pokémon and related names are trademarks of Nintendo / Creatures Inc. / GAME FREAK inc. This is a fan-made mod and contains no ROM.
