# Changelog

## 2.0.0-beta.25 — 25D4-RBY2 hotfix

- **Runtime confirmation:** Blue fresh title now shows **SETUP** and successfully transitions through Oak's intro into the player's bedroom.
- **Runtime confirmation:** Yellow fresh title now shows **SETUP** and successfully transitions through Oak's intro into the player's bedroom.
- **Runtime reconfirmation:** Gold still shows **GOLD BETA SETUP** and successfully boots into the player's bedroom.
- **Existing-save smoke confirmation:** Red loads with the Nuzlocke menus present and appears to be functioning normally in current testing.
- Restored the R/B/Y title **SETUP** injection to the historically proven menu behavior used by earlier stable builds, removing the later callback-shape dependency that could suppress SETUP on Blue/Yellow.
- Retained the protected Start-menu pattern where the vanilla menu is built first and Nuzlocke **RULES/TRACKER** entries are appended afterward.
- Added/retained forward declarations for `getDisplayRoutes` and `getEncounterState` so earlier recovery/rule closures capture the intended locals instead of resolving nonexistent globals.
- Fixed the reproducible R/B/Y post-intro white screen by preventing the optional Tier 3 Oak World Building TextBox from being pushed directly during `intro.oak_speech.finished`.
- The normal New Game staged-profile commit at `intro.oak_speech.finished` remains intact; only the unsafe cosmetic screen push was removed from that transition.
- No battle, capture, Gym Guide, shop, healing, item-rule, level-cap, save-schema, or Gold gameplay enforcement behavior was changed for the RBY2 white-screen fix.
- Save schema remains **4**.
- This remains **beta.25**; RBY2 is a runtime hotfix/diagnostic revision, not beta.26.

### RBY2 startup matrix

| Test | Result |
| --- | --- |
| Blue fresh title → SETUP | **PASS** |
| Blue Oak intro → bedroom | **PASS** |
| Yellow fresh title → SETUP | **PASS** |
| Yellow Oak intro → bedroom | **PASS** |
| Gold title → GOLD BETA SETUP | **PASS** |
| Gold New Game → bedroom | **PASS** |
| Red existing save → Nuzlocke menus | **SMOKE PASS** |
| Red fresh New Game → bedroom | **RETEST RECOMMENDED** |

## 2.0.0-beta.25 — 25D4

- **25D4 runtime confirmation:** No Repels passes with Repel, Super Repel, and Max Repel blocked when enabled and normal use restored when disabled.
- **25D4 runtime confirmation:** No X Items passes in battle.
- Gym Guide Rare Candy quantity selection is runtime-PASS; only a small centering/alignment cleanup remains.
- Hardened No Repels and No X Items recognition to accept both item data keys and item display names.
- The shared `ItemEffects.use` gate rebinds once per diagnostic build instead of trusting a permanent boolean sentinel.
- No Escape, No Healing Items, No Field Heal, No PP Items, No PokéCenter, No Buying, No Selling, Nickname Rule, Gold Setup, and the Gym Guide selector remain protected runtime-PASS behavior.
- Gen1 level-cap logic remained unchanged pending clean E4/Champion/Postgame retesting.
- Gold pre-New-Game SETUP remained runtime-confirmed with the smaller **GOLD BETA** rule surface.
- Gold and R/B/Y retained separate persisted Setup profiles.
- Preserved the working Gym Guide registration/dialogue and 1/10/25/50/99 selector UI using the blocking `push_screen` lifecycle.
- Fixed No PP Items to include PP Up-style boosters alongside Ether/Elixer-family recovery.
- Strengthened No Mom Heal at Mom's scripted heal/fade path.
- Left No Buying / No Selling unchanged after runtime confirmation.
- Fixed `pokemon.received` gift/trade classification.
- Fixed failed-encounter state access for gifts/trades through the intended `getEncounterState` closure.
- Fixed Whiteout teardown to preserve the engine's normal wrapped `BattleState.finish` cleanup chain.
- Narrowed the Red/Blue Route 24 Charmander migration cleanup.
- Fixed Recover Catches to read the actual flat rule keys.
- Fixed post-catch Overworld/Town fallback handling.
- Corrected affected lifecycle consumers to unwrap `game.ready` as `{ game = liveGame }`.
- Retained shared in-game Start Menu RULES/TRACKER integration and isolated Gold adapters.
- Preserved the R/B/Y two-row Trainer Card rule display.
- Save schema remained **4**.

## 2.0.0-beta.24

- Attempted Gold automatic New Game Setup through the shared intro build hook. Runtime testing showed that implementation still remained vanilla; beta.25 moved Gold Setup to the pre-New-Game title menu.
- R/B/Y title-screen SETUP remained unchanged.
- Save schema remained 4.

## 2.0.0-beta.23

- Added experimental Gold Trainer Card status integration.
- Added Gen 2 Egg/Day Care provenance and roaming Pokémon provenance.
- Generation-gated the R/B/Y Gym Guide integration.
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

### 2.0.0-beta.16

- Fixed the Setup-menu helper scoping/order crash.
- Gym Guide Rare Candy behavior remained on the beta.8 direct-row architecture.

### 2.0.0-beta.15

- Gen1Recomp 0.1.77 compatibility pass.
- Save schema advanced to 3 and unfinished Wonderlocke behavior remained disabled/dormant.

### 2.0.0-beta.14

- Added the future-safe save-schema/migration framework.
- Continued tracker/recovery hardening and kept Wonderlocke non-active.

### Present by 2.0.0-beta.8

- Added experimental Wonderlocke/provider work and additional rule/profile infrastructure.
- Established the Gym Guide direct-row composition architecture that remains protected in beta.25.

### 2.0.0-beta.4

- Added World Building tiers and associated flavor/mechanic messaging.
- Added level-cap-aware Gym Guide feedback before the Rare Candy selector.
