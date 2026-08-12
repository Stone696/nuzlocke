# Nuzlocke

A configurable, enforced Nuzlocke ruleset for **Pokémon Gen1Recomp**.

Version **2.0.0-beta.25 / 25D4-RBY2** is a runtime hotfix built forward from the beta.25 D4 stabilization line. It keeps the established beta.25 gameplay behavior while repairing two separate startup regressions discovered in testing: missing R/B/Y menu injection and the post-Oak white-screen transition into the player house.

> **Current hotfix status:** Blue and Yellow now show **SETUP** and successfully boot through the Oak intro into the bedroom. Gold still shows **GOLD BETA SETUP** and successfully boots into the bedroom. An existing Red save also loads with the Nuzlocke menus present in current smoke testing. The white-screen fix is therefore runtime-confirmed on Blue and Yellow, with Gold startup also reconfirmed.

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

After replacing an older build, fully quit Gen1Recomp and relaunch it. Existing Nuzlocke saves remain on save schema **4**.

## 25D4-RBY2 hotfix

This hotfix addresses two separate regressions found after the beta.25 GitHub upload.

### 1. R/B/Y SETUP / in-game menu regression

The R/B/Y title-screen setup path was restored to the historically proven behavior used by older stable builds. On a fresh Red/Blue/Yellow title screen without a vanilla **CONTINUE** entry, **SETUP** is inserted before **NEW GAME**.

The existing in-game Start Menu architecture remains the protected pattern: the mod lets the vanilla menu build first, then appends the Nuzlocke **RULES** and **TRACKER** entries to the returned list rather than modifying an input list that the engine may later rebuild.

The hotfix also retains the forward declarations for `getDisplayRoutes` and `getEncounterState`, preventing earlier closures from resolving nonexistent globals during recovery or rule checks.

### 2. Oak intro → bedroom white-screen regression

The white-screen failure occurred after Oak's intro finished, during the transition into the player's bedroom.

The optional Tier 3 Oak World Building message is no longer pushed directly from `intro.oak_speech.finished`. That lifecycle event remains responsible for the New Game setup-profile commit, but it no longer opens a Nuzlocke TextBox during the engine's intro-to-overworld fade/stack transition.

No battle, capture, Gym Guide, shop, healing, item-rule, level-cap, save-schema, or Gold gameplay enforcement behavior was changed for this fix.

## Runtime confirmation for this hotfix

| Test | Status |
| --- | --- |
| Blue fresh title shows SETUP | **PASS** |
| Blue Oak intro → bedroom | **PASS** |
| Yellow fresh title shows SETUP | **PASS** |
| Yellow Oak intro → bedroom | **PASS** |
| Gold title shows GOLD BETA SETUP | **PASS** |
| Gold New Game → bedroom | **PASS** |
| Red existing save loads with Nuzlocke menus | **SMOKE PASS** |
| Red fresh New Game → bedroom | **RETEST RECOMMENDED** |

Runtime evidence outranks static analysis. Paths already runtime-confirmed in beta.25 remain protected from unrelated changes.

## Game support

| Game | Status | Notes |
| --- | --- | --- |
| Red | Supported | Existing-save smoke test currently passes; fresh New Game startup should still receive a dedicated RBY2 retest. |
| Blue | Supported | SETUP and Oak-intro-to-bedroom startup are runtime-confirmed in RBY2. |
| Yellow | Supported | SETUP and Oak-intro-to-bedroom startup are runtime-confirmed in RBY2. |
| Gold | **Beta / Experimental** | Pre-New-Game SETUP and New Game boot into the bedroom are runtime-confirmed. Individual Gold gameplay rules remain beta unless separately tested. |
| Silver | Groundwork only | Not targeted by the manifest and not advertised as runnable. |
| Crystal | Groundwork only | Not targeted by the manifest and not advertised as runnable. |

Gold is intentionally **not** treated as Red with different data. The manifest targets `gen1` and `gold`, while Silver/Crystal remain future GSC-family architecture only.

## New Game setup

### Red / Blue / Yellow

When there is no vanilla **CONTINUE** entry, the title menu adds **SETUP** before **NEW GAME**. This stages the full Nuzlocke profile for the next New Game without modifying an existing save.

New-Game-only resources include:

| Setting | Range | Behavior |
| --- | ---: | --- |
| Starting Money | 0–9,999 | Sets New Game starting money. |
| Starting Poké Balls | 0–99 | Places that many Poké Balls in the bedroom PC. |
| Starting Rare Candies | 0–99 | Places that many Rare Candies in the bedroom PC. |
| Gym Guide Rare Candy | Off / On | Enables the R/B/Y Gym Guide Rare Candy utility. |

### Gold

Gold has a **runtime-confirmed SETUP entry before NEW GAME** on its native title menu and is labeled **GOLD BETA**. Gold intentionally exposes a smaller rule set than R/B/Y.

For now, Gold exposes only controls with an implemented shared or dedicated Gen 2 enforcement path: the Nuzlocke master switch, Permadeath, First Catch, Failed Encounters, Nickname Rule, Dupes, Shiny Clause, Gold/GSC level-cap scope, No Escape, No Buying, No Selling, Whiteout, Area Guide, Lock Rules, and Save Setup.

Gen1-only or not-yet-ready controls remain hidden on Gold instead of appearing inert. Gold and R/B/Y use separate persisted Setup profiles.

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
- **1st Catch** — only the first eligible catch per area may be taken.
- **Failed Encounters** — losing the first eligible encounter consumes the area when enabled.
- **Nickname Rule** — caught/received Pokémon must receive a nickname through supported acquisition paths.

### Clauses

- **Dupes Clause** — `OFF / SPEC / FAM`.
- **Shiny Clause** — shiny catches can override First Catch/Dupes restrictions.

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

- **World Building** — optional Kanto flavor tiers. RBY2 suppresses the special Oak-intro T3 popup at the unsafe intro-finished transition; other World Building behavior is unchanged.
- **Catch Info** — Nuzlocke metadata in the party UI.
- **Area Guide** — full-area Tracker page.

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

## Protected beta.25 runtime-PASS behavior

The following established beta.25 paths were not behaviorally changed by RBY2:

- Gold pre-New-Game SETUP
- No PP Items ON blocks PP Up
- No PP Items OFF allows normal use
- No Escape
- No Healing Items in battle
- No Field Heal
- Nickname Rule
- No PokéCenter
- No Buying
- No Selling
- No Buying + No Selling together
- Gym Guide Rare Candy offer text
- Gym Guide 1 / 10 / 25 / 50 / 99 selector
- No Repels
- No X Items

Remaining Gold gameplay-rule adapters remain **UNTESTED / BETA** unless separately runtime-confirmed.

## Save compatibility

Save schema remains **4**. RBY2 adds no migration and no new persisted gameplay rule keys.

Existing migrations remain additive/idempotent, including legacy `no_shopping` → separate No Buying/No Selling, legacy boolean Dupes → numeric `OFF / SPEC / FAM`, and forcing unfinished Wonderlocke state dormant.

## Compatibility API

`mod.exports.nuzlocke_compat` remains at API version **10**. The provider model and compatibility surfaces are unchanged by this hotfix.

## Validation status

RBY2 has direct runtime confirmation for Blue and Yellow title Setup plus Oak-intro-to-bedroom startup, Gold Setup plus New Game boot into the bedroom, and an existing Red save loading with Nuzlocke menus present. Red fresh-New-Game startup should still be repeated as a dedicated confirmation before treating the entire R/B/Y startup matrix as closed.

Static checks do not replace gameplay testing.

## Credits

- Original Nuzlocke mod and repository: **bryanthaboi**.
- Built for **Gen1Recomp** and its native mod API.

Pokémon and related names are trademarks of Nintendo / Creatures Inc. / GAME FREAK inc. This is a fan-made mod and contains no ROM.
