# Nuzlocke

A configurable, enforced Nuzlocke ruleset for **Pokémon Gen1Recomp**.

Version **2.0.0-beta.25** is a stabilization release built directly from beta.24. The release priority is Red, Blue, and Yellow. Gold remains an experimental target, and only generation-specific integrations that are isolated behind verified Gen 2 hooks are retained.

> **Release status:** R/B/Y remain the primary supported path. Gold pre-New-Game SETUP is now **runtime-confirmed working** and is labeled **GOLD BETA**. Gold shows only the smaller subset of rules with implemented Gold/shared enforcement paths; individual Gold gameplay rules still require runtime validation.

## Requirements

- Gen1Recomp **0.1.78 or newer**, below 2.0.0.
- Mod API **2**.
- `engine_internals` permission.

## Installation / update

Install these three files as:

- `main.lua`
- `manifest.json`
- `README.md`

After replacing an older build, fully quit Gen1Recomp and relaunch it. Existing Nuzlocke saves remain on save schema **4**.

## Game support

| Game | Status | Notes |
| --- | --- | --- |
| Red | Supported | Primary regression target. |
| Blue | Supported | Shares the mature R/B path with version-specific data. |
| Yellow | Supported | Uses Yellow-specific progression/data where required. |
| Gold | **Beta / Experimental** | Pre-New-Game SETUP is runtime-confirmed. The menu is labeled GOLD BETA and only exposes the conservative implemented Gold/shared rule subset. |
| Silver | Groundwork only | Not targeted by the manifest and not advertised as runnable. |
| Crystal | Groundwork only | Not targeted by the manifest and not advertised as runnable. |

Gold is intentionally **not** treated as Red with different data. The manifest targets `gen1` and `gold`, while Silver/Crystal remain future GSC-family architecture only.

## New Game setup

### Red / Blue / Yellow

When there is no vanilla **CONTINUE** entry, the title menu adds **SETUP**. This stages the full Nuzlocke profile for the next New Game without modifying an existing save.

New-Game-only resources include:

| Setting | Range | Behavior |
| --- | ---: | --- |
| Starting Money | 0–9,999 | Sets New Game starting money. |
| Starting Poké Balls | 0–99 | Places that many Poké Balls in the bedroom PC. |
| Starting Rare Candies | 0–99 | Places that many Rare Candies in the bedroom PC. |
| Gym Guide Rare Candy | Off / On | Enables the R/B/Y Gym Guide Rare Candy utility. |

### Gold

Gold now has a **runtime-confirmed SETUP entry before NEW GAME** on its native title menu. D3 labels the screen **GOLD BETA** and intentionally shows a smaller rule set than R/B/Y.

For now, Gold exposes only controls that have an implemented shared or dedicated Gen 2 enforcement path: the Nuzlocke master switch, Permadeath, First Catch, Failed Encounters, Nickname Rule, Dupes, Shiny Clause, Gold/GSC level-cap scope, No Escape, No Buying, No Selling, Whiteout, Area Guide, Lock Rules, and Save Setup. Descriptions explicitly identify Gold-beta behavior and call out paths that still need runtime validation.

Gen1-only or not-yet-ready controls are hidden on Gold instead of appearing inert. This currently includes Gym Guide Rare Candy, Overworld/Town catch toggles, Legendary/Mythical bans, gifts/trades/Wonderlocke controls, battle/field item bans, PokéCenter/Mom restrictions, Solo Only, World Building, Catch Info, Recover Catches, Locke Type presets, and starting-resource injection.

Gold and R/B/Y also use **separate persisted Setup profiles**. Changing Gold Setup no longer changes the next R/B/Y startup profile, and vice versa. The old unscoped setup profile is treated only as a legacy Gen1 profile.

Once an overworld save is active, the shared Start Menu integration can expose **RULES** and **TRACKER**. Individual Gold gameplay rules remain beta until each receives runtime testing.

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
- **Expanded Postgame** — optional provider-driven stages after the built-in progression.
- **No Healing Items**
- **No X Items**
- **No Escape**
- **No Repels** — blocks Repel, Super Repel, and Max Repel in the field.
- **No Escape Rope** — blocks Escape Rope use in the field.
- **No Field Heal** — blocks HP healing, status cures, and revival medicine outside battle.
- **No PP Items** — blocks Ether/Elixer-family PP recovery plus PP Up-style PP boosters.
- **No Buying**
- **No Selling**
- **No PokéCenter**
- **No Mom Heal**
- **Whiteout**
- **Solo Only**

Gen1Recomp's native **OPTIONS → BATTLE STYLE** remains the only Set/Shift setting.

### UI / world

- **World Building** — optional Kanto flavor tiers.
- **Catch Info** — Nuzlocke metadata in the party UI.
- **Area Guide** — full-area Tracker page.

## R/B/Y level caps

The R/B/Y cap calculator remains shared by enforcement, Tracker, Trainer Card, and Gym Guide feedback.

### Gym caps

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

### League caps

| Battle | Cap |
| --- | ---: |
| Lorelei | 56 |
| Bruno | 58 |
| Agatha | 60 |
| Lance | 62 |
| Champion | 65 |

Gym/League progression is recorded from supported defeated-boss signals rather than assuming the current badge inventory is authoritative.

## Trainer Card, Tracker, and Catch Info

R/B/Y retain the Nuzlocke Trainer Card wrapper. **A** flips between the vanilla card and Nuzlocke status. The Nuzlocke rule block keeps the requested **two visible rule rows**, and the update/draw window sizes are kept in sync so scrolling reaches the final rule correctly.

The Start menu includes **TRACKER** and **RULES**. Tracker state preserves visited/caught areas, failed encounters, multiple legitimate catches, encounter provenance, and the current level-cap reminder.

When **Catch Info** is enabled, owned Pokémon expose their tracked origin/status/death information without rebuilding the live Pokémon object.

## Gym Guide Rare Candy — R/B/Y

The recovered beta.8 through beta.16 snapshots reveal the important historical behavior: the vanilla Gym Guide `ScriptRunner` rows were copied directly and the Nuzlocke Rare Candy command was appended to that same row list. This avoided nesting another foreground command around the Guide dialogue.

Beta.25 preserves that long-lived row-composition architecture and the dedicated **1 / 10 / 25 / 50 / 99** selector UI. Runtime testing confirms that the NPC registration and Rare Candy offer dialogue work.

D2 still failed at the quantity-screen handoff. D3 changes **only that failing lifecycle**: the selector is now opened with Gen1Recomp's current blocking `push_screen` script command, which waits for the exact screen instance to leave the stack before the Gym script continues. The NPC registration, vanilla dialogue composition, quantity choices, and candy-grant policy are otherwise left intact.

Gold does not register this R/B/Y `map_scripts` integration.

## R/B/Y field items and healing services

Beta.25 keeps the field restrictions at the centralized item-use transaction boundary. **No Repels**, **No Escape Rope**, and **No Field Heal** retain their existing classifications. **No PP Items** includes Ether/Max Ether, Elixer/Max Elixer, and PP Up-style PP boosters. Runtime testing confirms PP Up is blocked when the toggle is ON and works normally when the toggle is OFF.

Pokémon Center and Mom healing use different engine paths and remain separate:

- **No PokéCenter** gates the R/B/Y nurse dispatch before healing begins, with a narrow `nurseHeal` fallback. **Runtime PASS:** Nurse Joy no longer heals while the rule is ON.
- **No Mom Heal** retains the scripted `heal_party`/fade interception and is still awaiting runtime retest.

No Buying / No Selling are protected runtime-passing behavior and were not changed in this revision.

## Save compatibility

Save schema remains **4**. Existing migrations remain additive/idempotent, including:

- legacy `no_shopping` → separate **No Buying** and **No Selling**;
- legacy boolean Dupes → numeric `OFF / SPEC / FAM`;
- older Wonderlocke state forced dormant while Wonderlocke remains WIP.

Beta.25 does not add or remove persisted rule keys relative to beta.24.

## Compatibility API

`mod.exports.nuzlocke_compat` remains at API version **10** and retains cooperative policy surfaces for item use, purchasing, selling, capture legality, species metadata, identity, level-cap providers, and postgame providers.

The provider model remains additive; beta.25 does not broaden global inventory/money/storage interception during this stabilization pass.

## Gold compatibility retained in beta.25

Gold-only behavior remains isolated behind explicit version/generation checks. Beta.25 keeps the existing experimental adapters for the areas that have dedicated Gen 2 seams, including:

- capture legality on the Gen 2 battle item/Ball path;
- faint/permadeath event handling;
- native Gen 2 nickname flow;
- Gen 2 mart buying/selling gates;
- `givepoke` starter/gift provenance;
- discovery-driven GSC area tracking;
- Gold Trainer Card status integration;
- Egg/Day Care provenance;
- roaming Pokémon provenance;
- GSC progression/profile and Expanded Postgame architecture.

These are **experimental**, not a claim that a complete Gold Nuzlocke run has passed smoke testing. Gold Setup is implemented at the actual title menu before NEW GAME through Gold's native `{label,value}` row and a narrow `src.ui.gen2.MainMenu:choose()` adapter. The title entry is now **runtime-confirmed working**. D3 gives Gold a separate persisted Setup profile and exposes only the conservative Gold-beta rule subset.

## R/B/Y stabilization checklist

The D4 diagnostic revision keeps the compact in-game build marker and the separate **GOLD BETA** header. D4 changes only the two item-rule paths that failed runtime testing: No Repels and No X Items.

Before pushing beta.25, the recommended in-game pass is:

1. Red fresh New Game: title **SETUP**, staged rules, starting resources.
2. Red existing save: **RULES**, **TRACKER**, Trainer Card two-row status.
3. Gym Guide Rare Candy in an early gym: vanilla/base dialogue first, dedicated 1 / 10 / 25 / 50 / 99 quantity screen second, repeat interaction.
4. First-catch success, failed encounter, Dupes, and Shiny Clause paths.
5. Permadeath and Whiteout separately.
6. Level-cap EXP and Rare Candy rejection at cap.
7. Field-item restrictions individually: Repel, Escape Rope, Potion/status/revive medicine, Ether/Elixer, and PP Up.
8. No Buying and No Selling independently (regression smoke only; implementation unchanged).
9. PokéCenter refusal before healing starts, then Mom refusal without the white-heal sequence.
10. Gift/trade tracking and Catch Info.
11. Blue smoke pass for startup, capture, Gym Guide, level caps.
12. Yellow smoke pass for startup, capture, Gym Guide, level caps, and Yellow-specific progression.

## Beta.25 R/B/Y correctness fixes

This stabilization pass also repairs six rule/data-flow bugs found during review of the beta.20-era R/B/Y implementation:

- `pokemon.received` now classifies gifts and in-game trades before applying the post-transaction fallback, so compatible acquisition paths no longer bypass registration simply because they did not use the native command wrappers.
- Gift/trade area checks now reach the real failed-encounter state through a correctly forward-declared `getEncounterState` upvalue.
- Whiteout run-ending teardown now delegates through the engine's wrapped `BattleState.finish` chain while suppressing only the normal blackout callback, preserving engine cleanup and the canonical `battle.ended` boundary before run deletion/credits.
- The old Red/Blue Route 24 Charmander migration repair is now narrowly scoped to a deterministically recovered vanilla gift artifact. It no longer deletes arbitrary non-Pallet Charmander tracker entries, manual recovery, provider data, or future legitimate placements.
- Recover Catches reads the actual flat `nuzlocke_enabled` and `encounter_limit` save keys, so manual recovery no longer enforces one-catch-per-area when that rule is disabled.
- Post-catch fallback handling now respects Overworld Encounters and Town Catches before consuming encounter state. Non-counting provider/direct catches retain provenance without being reconstructed into a consumed area on later loads.

These fixes do not add persisted rule keys and do not require a save-schema migration.

## Runtime test ledger

Runtime evidence outranks static analysis. Runtime-PASS paths are protected from unrelated changes.

| Feature | Status |
|---|---|
| Gold pre-New-Game SETUP | **PASS** |
| No PP Items ON blocks PP Up | **PASS** |
| No PP Items OFF allows normal use | **PASS** |
| No Escape | **PASS** |
| No Healing Items in battle | **PASS** |
| No Field Heal | **PASS** |
| Nickname Rule | **PASS** |
| No PokéCenter | **PASS** |
| No Buying | **PASS** |
| No Selling | **PASS** |
| No Buying + No Selling together | **PASS** |
| Gym Guide Rare Candy offer text | **PASS** |
| Gym Guide 1/10/25/50/99 selector | **PASS in D3** |
| No Repels | **PASS in D4** |
| No X Items | **PASS in D4** |
| Remaining Gold rule adapters | **UNTESTED / BETA** |

## Known cosmetic / future work

- **Gym Guide quantity selector:** runtime-PASS; its current box/list alignment is slightly off-center. Treat this as cosmetic only and do not change the working selector lifecycle while adjusting layout.
- **Town Map Nuzlocke Log:** future feature request to surface Nuzlocke encounter/log information directly from the Gen1 Town Map. Defer until the current Beta.25 stabilization pass is complete.
- **Gen1 level caps:** GYMS showing MAX on the current test save is not considered a confirmed bug because that save was manually given all eight badges. E4/Champion/Postgame still need a clean progression-state retest.

## Validation status

Beta.25 receives static checks for Lua syntax, JSON manifest validity, schema preservation, rule-key preservation, R/B/Y title/start-menu hooks, R/B/Y capture/faint/shop/nickname paths, Gym Guide direct-row registration/dedicated quantity-screen structure, field-item classification, R/B/Y Pokémon Center nurse-dispatch interception, Mom command interception, corrected `game.ready` payload handling, two-row Trainer Card consistency, Gold adapter isolation, the Gold title-row/MainMenu Setup adapter, and the six correctness fixes above.

Static checks do not replace gameplay testing. Gold title Setup has passed runtime testing; individual Gold gameplay-rule adapters remain experimental until each is tested.

## Credits

- Original Nuzlocke mod and repository: **bryanthaboi**.
- Built for **Gen1Recomp** and its native mod API.

Pokémon and related names are trademarks of Nintendo / Creatures Inc. / GAME FREAK inc. This is a fan-made mod and contains no ROM.

# Changelog

## 2.0.0-beta.25

- **25D4 runtime confirmation:** No Repels now passes with Repel, Super Repel, and Max Repel blocked when enabled and normal use restored when disabled.
- **25D4 runtime confirmation:** No X Items now passes in battle.
- Gym Guide Rare Candy quantity selection is runtime-PASS; only a small centering/alignment cleanup remains.
- Added the future backlog item to surface the Nuzlocke encounter/log view directly from the Gen1 Town Map after stabilization.
- **25D4 runtime-driven item fix:** No Repels and No X Items were confirmed failing in D3. Their canonical Gen1 item IDs already matched the engine, so D4 keeps the existing policy and hardens only those two recognition paths to accept both item data keys and item display names.
- The shared `ItemEffects.use` gate now rebinds once per diagnostic build instead of trusting a permanent boolean sentinel. This prevents a previously loaded Beta.25 closure from silently remaining active after a Lua update.
- No Escape, No Healing Items, No Field Heal, No PP Items, No PokéCenter, No Buying, No Selling, Nickname Rule, Gold Setup, and the Gym Guide selector are runtime-PASS/protected and are not behaviorally changed by D4.
- Gen1 level-cap logic is intentionally unchanged pending a clean E4/Champion/Postgame retest; the earlier GYMS=MAX result was explained by the test save already having all eight badges.
- **25D3 runtime-driven revision:** Gold pre-New-Game SETUP is runtime-confirmed. Gold now uses a smaller **GOLD BETA** rule surface rather than displaying R/B/Y-only controls.
- Split persisted Setup profiles into separate **Gen1** and **Gold** files. The old unscoped profile is treated only as a legacy Gen1 profile.
- Removed the overlapping full diagnostic stamp from the second header line; Gold shows **GOLD BETA**, while the in-game build marker is a compact **D3**.
- Protected runtime-confirmed No PP Items, No PokéCenter, No Buying, and No Selling paths from unrelated changes.
- Preserved the working Gym Guide registration/dialogue and 1/10/25/50/99 selector UI. Only the failing screen handoff changed: it now uses the current engine's blocking `push_screen` script command instead of manual runner yield/resume callbacks.
- **25D2 runtime results:** Gold title SETUP passed; No PP Items ON/OFF passed; No PokéCenter passed; No Buying/No Selling remained passing; Gym Guide offer text passed but the quantity selector failed to appear.
- No Buying / No Selling remain untouched because they are runtime-confirmed protected behavior.
- R/B/Y stabilization pass built directly from beta.24.
- Restored the established R/B/Y Gym Guide Rare Candy registration behavior while using the boot-selected game version solely to keep the Gen 1 `map_scripts` bridge out of Gold.
- Fixed **No PP Items** so PP Up-style PP boosters are blocked alongside Ether/Elixer-family recovery; re-audited Repel, Escape Rope, and field medicine classifications at the centralized item-use gate.
- Strengthened **No Mom Heal** at Mom's actual `heal_party`/fade script path so the party is not healed and the refusal does not leave the white heal transition running.
- Left No Buying / No Selling unchanged after runtime confirmation that buying and selling restrictions work independently and together.
- Fixed `pokemon.received` gift/trade classification so compatible non-wrapper acquisition paths are registered and checked instead of falling through dead branches.
- Fixed the early `specialAreaUnavailable` closure so failed encounter states correctly block gifts/trades when First Catch + Failed Encounters consume the area.
- Fixed Whiteout teardown to run through the engine's normal wrapped battle `finish()` chain while suppressing only the vanilla blackout callback before Nuzlocke save deletion/credits.
- Narrowed the Red/Blue Route 24 Charmander legacy repair to the specific deterministic vanilla migration artifact; arbitrary Charmander tracker entries are no longer removed on load.
- Fixed Recover Catches to read the actual flat rule keys instead of a nonexistent nested `rules` table.
- Fixed post-catch Overworld/Town fallback handling so disabled encounter categories do not consume encounter state or reappear as consumed areas after tracker reconstruction.
- Corrected all live-game consumers in the affected lifecycle paths to unwrap `game.ready` as `{ game = liveGame }`; this also fixes Gym Guide refresh and Center UI code that could otherwise hold the event wrapper instead of the game.
- Retained the shared in-game Start Menu RULES/TRACKER integration and isolated Gold adapters that use dedicated Gen 2 hooks.
- Audited the README against the actual Lua and removed implementation claims for catch-tutorial skipping and opening-rival forgiveness, which are not present in this build.
- Preserved the requested R/B/Y two-row Trainer Card rule display.
- Save schema remains 4; no persisted rule keys were added or removed.

## 2.0.0-beta.24

- Attempted Gold automatic New Game Setup through the shared intro build hook. Runtime testing showed that implementation still remained vanilla; the current beta.25 removes the post-NEW-GAME intro approach in favor of a pre-NEW-GAME title-menu adapter.
- R/B/Y title-screen SETUP remained unchanged.
- Save schema remained 4.

## 2.0.0-beta.23

- Added experimental Gold Trainer Card status integration.
- Added Gen 2 Egg/Day Care provenance and roaming Pokémon provenance.
- Generation-gated the R/B/Y Gym Guide integration; beta.25 corrects the entry-time gate used by that change.
- Save schema remained 4.

## 2.0.0-beta.22

- Added experimental Gold generation-native capture, permadeath, nickname, mart, starter/gift, and area-tracking adapters.
- Added Gen 1 + Gold manifest targeting.
- Save schema remained 4.

## 2.0.0-beta.21

- Added GSC family/version-profile architecture and experimental Gold targeting groundwork.
- Added built-in GSC progression through Red plus provider-driven Expanded Postgame architecture.
- Expanded the R/B/Y Trainer Card rule window to two visible rows.

## 2.0.0-beta.20

- Compatibility hardening and regression pass built directly from beta.19.
- Preserved schema 4 while strengthening item/purchase/capture policy exports, provider surfaces, level-cap enforcement, persistent identity/recovery, Trainer Card/Catch Info, and Gym Guide Rare Candy behavior.

## Reconstructed earlier history from surviving Lua snapshots

The following entries are reconstructed from surviving source snapshots. Missing snapshots mean an exact introduction beta cannot always be proven; wording such as **present by** is intentional.

### 2.0.0-beta.16

- Fixed the Setup-menu helper scoping/order crash.
- Gym Guide Rare Candy behavior remained on the beta.8 direct-row architecture.

### 2.0.0-beta.15

- Gen1Recomp 0.1.77 compatibility pass.
- Save schema advanced to 3 and unfinished Wonderlocke behavior remained disabled/dormant.
- Gym Guide Rare Candy behavior remained unchanged from the established direct-row implementation.

### 2.0.0-beta.14

- Added the future-safe save-schema/migration framework (schema 2 at this snapshot).
- Continued tracker/recovery hardening and kept Wonderlocke non-active.

### 2.0.0-beta.12

- Added the first surviving future-safe persistent save-schema baseline (schema 1), using an idempotent marker-only migration so older saves could establish a versioned migration boundary without rewriting gameplay data.
- Kept the beta.8-era Gym Guide direct-row composition and dedicated Rare Candy selector unchanged.
- Continued the existing new-game Setup profile, provenance/recovery, level-cap scope, Wonderlocke/provider, world-building, Tracker/Catch Info, and Trainer Card systems.

### 2.0.0-beta.11

- Improved catch-location recovery for human-readable saved locations.
- Changed the Rare Candy selector cursor presentation to the native theme cursor without changing its screen lifecycle.

### 2.0.0-beta.10

- Added native cursor/scroll presentation work and Trainer Card refinements.
- Continued the established Gym Guide direct-row + dedicated-selector behavior.

### Present by 2.0.0-beta.8

- Added experimental Wonderlocke/provider work and additional rule/profile infrastructure.
- **Important Gym Guide fix:** stopped treating `MapScripts.baseTalk()` as a callable handler. The vanilla ScriptRunner rows are copied and the Nuzlocke Rare Candy command is appended directly. This architecture remains present through beta.16.

### 2.0.0-beta.5

- Added legacy catch-location reconciliation/recovery work.
- Gym Guide behavior remained on the earlier implementation of that period.

### 2.0.0-beta.4

- Added World Building tiers and associated flavor/mechanic messaging.
- Added level-cap-aware Gym Guide feedback before the Rare Candy selector.

### Present by 2.0.0-beta.3

- Added/expanded provenance-aware catch recovery and compatibility work.
- Gym Guide Rare Candy is present with its dedicated **1 / 10 / 25 / 50 / 99** quantity selector.

### Surviving beta.1 snapshot

- Battle-item enforcement/current-rule-profile and Whiteout-related work are present.
- The later Gym Guide Rare Candy feature is not present in this surviving snapshot.

