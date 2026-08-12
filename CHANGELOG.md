# Changelog

## 2.0.0-beta.27 — promoted public baseline

- Promoted **beta.26.6 directly** to the new canonical public baseline.
- The beta.27 promotion intentionally changes release/version metadata only; gameplay code is unchanged from beta.26.6.
- **Runtime confirmation, Gold beta.26.6:** fresh startup works and New Game reaches the player's house.
- **Runtime confirmation, Gold beta.26.6:** in-game RULES and TRACKER function in the tested fresh run.
- **Runtime confirmation, Gold beta.26.6:** Catch Info appears and functions.
- **Runtime confirmation, Gold beta.26.6:** Cyndaquil starter acquisition succeeds, confirming the mandatory starter path is not blocked by the Gold gift gate.
- **Known Gold bug:** Forced Nicknames do not trigger; the starter was acquired without a nickname prompt.
- **Known Gold architecture gap:** Gold's native Trainer Card already uses both sides, so the R/B/Y NUZ STATUS back-side presentation does not appear and needs a generation-native access path.
- **Runtime confirmation, Yellow beta.26.6:** in-game RULES/TRACKER and catch/encounter tracking continue to function.
- **Runtime confirmation carried forward from Yellow beta.26.2:** toggling 1st Catch after the area's first encounter behaves correctly.
- Gold ordinary gift denial and Gold Whiteout consequence remain **RUNTIME TEST REQUIRED**.
- Gen 1 Whiteout teardown, fallback gift/trade classification, beta.26.4 Tracker/TV presentation, battle-text wrapping, and the battle-lag A/B investigation remain open/test-required.
- Save schema remains **4**.
- Future development continues numerically from this release: **beta.27.1, beta.27.2, ...**

### beta.27 release matrix

| Test | Result |
| --- | --- |
| Gold fresh startup / New Game → house | **PASS** |
| Gold RULES | **PASS** |
| Gold TRACKER | **PASS** |
| Gold Catch Info | **PASS** |
| Gold Cyndaquil starter acquisition | **PASS** |
| Gold Forced Nicknames | **FAIL / OPEN** |
| Gold NUZ STATUS Trainer Card access | **NOT AVAILABLE / REDESIGN NEEDED** |
| Gold ordinary gift denial | **RUNTIME TEST REQUIRED** |
| Gold Whiteout ON/OFF | **RUNTIME TEST REQUIRED** |
| Yellow beta.26.6 RULES / TRACKER | **PASS** |
| Yellow beta.26.6 catch / encounter tracking | **PASS** |
| Yellow 1st Catch toggle after prior area encounter | **PASS (26.2 evidence)** |
| Reported Yellow battle lag | **OPEN / A-B PROFILE NEEDED** |

## 2.0.0-beta.26.6 — Gold gift enforcement / Gold Whiteout consequence

- Built **only from beta.26.5**. The published beta.26 release remains the canonical public baseline.
- Fixed Gold `givepoke` handling so the shared gift legality policy runs **before** the vanilla command mutates party/story state.
- Gold starters remain exempt from ordinary gift rejection and continue to register through the New Bark Town starter path.
- Allowed Gold gifts still register provenance after the vanilla transaction; rejected gifts return before mutation and set the script check false with a Nuzlocke denial message.
- Added a Gen 2-specific `finishBattle` Whiteout consumer for the `nuzlockeGameOver` flag already set by `G2.onFaint`.
- Gold Whiteout now preserves native Gen 2 battle cleanup while suppressing the normal blackout callback that would heal, halve money, and warp home; Nuzlocke summary/save-deletion/Credits-title flow then owns the ended run.
- Whiteout OFF remains on the untouched vanilla Gold `finishBattle`/`onDone` path.
- **Runtime confirmation from beta.26.2 Yellow:** toggling 1st Catch after an area's first encounter had already occurred behaved as expected.
- **Performance note:** beta.26.2 Yellow showed reported lag, especially in battles. Static comparison found no new per-frame Yellow battle update/draw interception in beta.26.1/.26.2; controlled same-save A/B profiling remains open.
- No intentional changes to R/B/Y startup, Soft Start/Pokédex activation, Mom/PokéCenter/Field Heal, fresh Yellow Mart enforcement, first-rival T3 timing, Tracker/TV work, or Gym Guide behavior.
- Save schema remains **4**.

### beta.26.6 targeted runtime matrix

| Test | Result |
| --- | --- |
| Gold ordinary allowed gift | **RUNTIME TEST REQUIRED** |
| Gold disallowed/used-area gift rejected before mutation | **RUNTIME TEST REQUIRED** |
| Gold starter still bypasses ordinary gift rejection | **RUNTIME TEST REQUIRED** |
| Gold Whiteout ON ends run / deletes disposable save | **RUNTIME TEST REQUIRED** |
| Gold Whiteout OFF preserves vanilla blackout | **RUNTIME TEST REQUIRED** |
| Yellow 1st Catch toggle after prior encounter | **PASS (26.2 evidence)** |
| beta.26.2 battle-lag A/B comparison | **OPEN** |

## 2.0.0-beta.26.5 — code-correctness / acquisition / Gold / Whiteout

- Built **only from beta.26.4**. The published beta.26 release remains the canonical public baseline.
- Fixed `pokemon.received` fallback gift/trade handling by actually assigning `isGift` and `isTrade`; explicit `source` values win, with species lookup used only when source is absent.
- Restored the intended external/cooperating-mod acquisition path for gift/trade area tracking and rule checks without broadly reclassifying explicitly sourced Pokémon.
- Generation-gated R/B/Y New Game starting resources so Gold/Silver/Crystal native starting money and PC items are not overwritten by hidden/stale Gen1 Setup fields.
- Gold/Silver/Crystal no longer receive `nuzlockeDeferredStartingBalls`; stale mod-owned run-start snapshot/deferral metadata is cleared without touching native resources.
- Reworked the Whiteout game-over finish path to call through the already-wrapped engine `BattleState.finish` chain while temporarily suppressing only the vanilla blackout `onFinish` callback.
- Removed the normal successful Whiteout path's manual duplicate stack-pop / public `battle.ended` / finalizer substitution; engine teardown now owns those operations once.
- Retained a narrow defensive fallback if the engine finish chain itself errors.
- No intentional changes to beta.26.4 Tracker result formatting, progression-aware TV, Soft Start/Pokédex activation, Mom/PokéCenter rules, Mart enforcement, Gym Guide, or first-rival timing.
- **Runtime test required:** fallback gift/trade acquisition, Gold fresh-New-Game resource preservation, and especially Whiteout teardown/save deletion with a disposable save.


## 2.0.0-beta.26.4 — Tracker clarity / progression-aware TV

- Built **only from beta.26.3**. The published beta.26 release remains the canonical public baseline.
- Replaced cryptic failed-encounter labels such as `FAIL-W` with `FAILED <species>` on both Tracker LOG and MAP pages.
- Renamed the Tracker's right column from **CATCH** to **RESULT** so failed rows read naturally beside successful catches.
- Failed results now use the existing marquee path, allowing the full `FAILED <species>` label to scroll through the seven-character result window.
- Added lightweight `last_failed_encounter` presentation metadata when a failed encounter is recorded; encounter enforcement still uses the existing authoritative `encounter_states` table.
- Expanded the Tier 3 home-TV World Building path into a live run recap using story progression, caught Pokémon, failed encounters, losses, badge progress, the next active cap, and an active-rule reminder; repeated TV interactions cycle through the available report types.
- Preserved T0-T2 vanilla TV fallthrough and all beta.26.3 Soft Start / Mom / activation-message behavior unchanged.
- **Runtime confirmation from beta.26.2 Yellow:** UI controls can be turned OFF without leaking the disabled UI behavior.
- **Runtime confirmation from beta.26.2 Yellow:** defeating the first eligible Route 2 encounter produced the expected T3 failure feedback and a failed route entry in the Tracker.
- **Runtime confirmation from beta.26.2 Yellow:** level-cap displays on NUZ STATUS and the Encounter Tracker show the **next active cap**, not the maximum cap in the selected scope.
- **Runtime confirmation from beta.26.2 Yellow:** fresh-run No Buying / No Selling enforcement works.
- The Viridian Mart first-entry parcel-clerk spacing issue remains open; beta.26.4 does not broadly rewrite vanilla story text.
- Save schema remains **4**.

### beta.26.4 targeted runtime matrix

| Test | Result |
| --- | --- |
| Yellow UI controls OFF | **PASS (26.2 evidence)** |
| Yellow failed Route 2 encounter state | **PASS (26.2 evidence)** |
| Yellow next-cap display on Tracker / NUZ STATUS | **PASS (26.2 evidence)** |
| Yellow fresh-run No Buying / No Selling | **PASS (26.2 evidence)** |
| Failed row reads `FAILED <species>` and marquee scrolls | **RUNTIME TEST REQUIRED** |
| T3 TV changes with caught / failed / lost / progression state | **RUNTIME TEST REQUIRED** |
| T3 TV still adapts to active rules | **RUNTIME TEST REQUIRED** |
| T0-T2 TV remains vanilla | **RUNTIME TEST REQUIRED** |
| Viridian Mart parcel-clerk spacing | **OPEN / BACKLOG** |

## 2.0.0-beta.26.3 — Early-game dialogue / TV World Building polish

- Built **only from beta.26.2**. The published beta.26 release remains the canonical public baseline.
- Preserved the runtime-PASS Pokédex Soft Start/delivery boundary. The configured challenge Poké Balls still go to the **home PC after the Pokédex handoff**.
- Clarified the two activation popups: the Ball-delivery message says the Balls are waiting in the PC at home; the follow-up now discusses **only the Area Guide / Nuzlocke Tracker** and no longer repeats Ball-receipt wording.
- Added a Tier 3 World Building interaction for the Red's House 1F TV. The line adapts to active rules, while T0-T2 fall through to the vanilla TV interaction.
- Added a one-per-save Tier 3 Mom post-heal flavor guard when Mom healing is allowed, aimed at preventing repeated custom Mom flavor on repeated heals.
- **Runtime confirmation from beta.26.2 Yellow:** fresh SETUP visible and New Game reaches the bedroom.
- **Runtime confirmation from beta.26.2 Yellow:** configured starting Rare Candies/resources work.
- **Runtime confirmation from beta.26.2 Yellow:** Pikachu reports **Pallet Town immediately on acquisition**, before the Pokédex cleanup boundary.
- **Runtime confirmation from beta.26.2 Yellow:** No Mom Heal replaces Mom's normal rest dialogue.
- **Runtime confirmation from beta.26.2 Yellow:** PokéCenter healing behavior remains correct.
- **Runtime confirmation from beta.26.2 Yellow:** first-rival Tier 3 World Building timing is now accepted as complete.
- Oak/rival dialogue duplication and spacing problems remain a known issue and are not claimed fixed.
- Save schema remains **4**.

### beta.26.3 targeted runtime matrix

| Test | Result |
| --- | --- |
| Yellow fresh SETUP / bedroom boot (26.2 evidence) | **PASS** |
| Yellow starter immediately = Pallet Town (26.2 evidence) | **PASS** |
| Yellow No Mom Heal owns dialogue (26.2 evidence) | **PASS** |
| Yellow first-rival T3 timing (26.2 evidence) | **PASS / COMPLETE** |
| Pokédex first popup says Balls are in PC at home | **PROTECTED / RECONFIRM** |
| Pokédex second popup mentions Area Guide only | **RUNTIME TEST REQUIRED** |
| Allowed Mom heal does not duplicate T3 flavor | **RUNTIME TEST REQUIRED** |
| Home TV at T3 shows adaptive Nuzlocke flavor | **RUNTIME TEST REQUIRED** |
| Home TV at T0-T2 remains vanilla | **RUNTIME TEST REQUIRED** |
| Oak/rival duplicate/spacing cleanup | **OPEN / BACKLOG** |

## 2.0.0-beta.26.2 — Gym Guide alignment / runtime evidence rollup

- Built **only from beta.26.1**. The published beta.26 release remains the canonical public baseline.
- Re-centered the R/B/Y Gym Guide Rare Candy quantity screen: title, prompt, 1 / 10 / 25 / 50 / 99 values, cursor placement, and A/B hints now share the same menu-box centerline.
- The Gym Guide Rare Candy service logic, quantities, inventory behavior, and level-cap warnings were not changed.
- **Runtime confirmation:** existing Red save No Buying ON/OFF passes.
- **Runtime confirmation:** existing Red save No Selling ON/OFF passes.
- **Runtime confirmation:** existing Blue save No Buying ON/OFF passes.
- **Runtime confirmation:** existing Blue save No Selling ON/OFF passes.
- **Runtime confirmation:** existing Red save Gym Guide Rare Candy NPC/service still works mechanically.
- **Runtime confirmation:** Blue No Field Heal blocks healing and produces the expected Tier 3 World Building response.
- **Runtime confirmation:** Blue catch-time Tier 3 World Building referenced the active Nickname Rule when Nickname Rule was ON.
- Static inspection confirms the nickname-specific World Building path is explicitly gated by `nickname_rule`; an OFF-state runtime regression check remains planned.
- beta.26.1 Mom-dialogue ownership, PC-at-home Ball wording, pre-Pokédex Pallet Town Catch Info repair, and battle wrapping/paging are carried forward unchanged and remain runtime-test-required.
- Fresh-run/first-entry Mart coverage remains open because earlier Gen1Recomp 0.1.79 testing conflicted with the newer existing-save Red/Blue passes.
- Save schema remains **4**.

### beta.26.2 targeted runtime matrix

| Test | Result |
| --- | --- |
| Red existing save No Buying ON/OFF | **PASS** |
| Red existing save No Selling ON/OFF | **PASS** |
| Blue existing save No Buying ON/OFF | **PASS** |
| Blue existing save No Selling ON/OFF | **PASS** |
| Red Gym Guide Rare Candy service | **PASS** |
| Blue No Field Heal + T3 response | **PASS** |
| Blue nickname-aware catch T3 with Nickname Rule ON | **PASS** |
| Nickname-specific T3 with Nickname Rule OFF | **RETEST PLANNED** |
| Gym Guide menu centering | **RUNTIME TEST REQUIRED** |
| Fresh-run / first-entry Mart policy | **RETEST REQUIRED** |

## 2.0.0-beta.26.1 — Dialogue / starter metadata polish

- Built **only from the canonical beta.26 baseline**.
- Replaced Mom's post-starter vanilla rest line at its exact R/B/Y script row when **No Mom Heal** is ON, so the Nuzlocke refusal attempts to own the interaction before the vanilla rest/heal sequence begins.
- Preserved the proven Pokédex Soft Start activation/delivery boundary while changing the configured Ball message to explicitly say the challenge Poké Balls are **waiting in the PC at home**.
- Added immediate R/B/Y starter Catch Info canonicalization: a starter temporarily reporting Oak's Lab/unknown is repaired to **Pallet Town** when Catch Info opens.
- Gold/New Bark starter handling was not changed.
- Added Nuzlocke-authored battle-message wrapping to the native battle-text width.
- Added CONT-style player advancement for longer Nuzlocke battle denial/flavor messages.
- Applied the battle formatter to catch-denial messages and queued trainer World Building flavor.
- Advanced the item-policy diagnostic owner marker so same-process diagnostic reloads do not silently retain an older closure.
- No Soft Start rule, Pokédex activation boundary, starting-resource quantity, Trainer Card page structure, Gold rule adapter, shop enforcement, or rival final-timing behavior was intentionally redesigned.
- Save schema remains **4**.

### beta.26.1 targeted runtime matrix

| Test | Result |
| --- | --- |
| Blue/Yellow/Red/Gold setup/startup regression gate | **RETEST REQUIRED** |
| No Mom Heal ON replaces vanilla rest text | **RUNTIME TEST REQUIRED** |
| No Mom Heal OFF remains vanilla | **RUNTIME TEST REQUIRED** |
| Pre-Pokédex R/B/Y starter Catch Info = Pallet Town | **RUNTIME TEST REQUIRED** |
| Pokédex Balls still delivered to home PC | **PROTECTED / RECONFIRM** |
| Updated PC-at-home notification wording | **RUNTIME TEST REQUIRED** |
| Catch-denial battle wrapping/paging | **RUNTIME TEST REQUIRED** |
| Trainer World Building wrapping/paging | **RUNTIME TEST REQUIRED** |

## 2.0.0-beta.26 — Canonical published baseline

- Promoted the runtime-tested 26B10 development revision to the canonical **beta.26** public baseline without intentionally changing gameplay behavior during promotion.
- Retired lettered internal revisions. Future builds use numeric revisions: **beta.26.1, beta.26.2, beta.26.3, ...**.
- Preserved the published 25D4-RBY2 title-menu and Oak-intro startup hotfix.
- Added/continued Soft Start: encounter rules remain inert before first usable Ball activation.
- Configured starting Poké Balls are deferred until the verified Pokédex handoff, then delivered to the player's home PC as the route ledger activates.
- Added immutable New Game start-resource history for Money, Poké Balls, and Rare Candies inside **NUZ STATUS**.
- Preserved a two-view Trainer Card design: vanilla front + NUZ STATUS back; no separate RUN START page.
- Added Gold-specific reduced **NUZLOCKE GOLD / BETA SETUP** presentation with beta-aware descriptions.
- Improved scripted starter/gift nickname handling so Nickname Rule ON cannot be declined through the normal YES/NO path.
- Continued R/B/Y starter canonicalization work toward **Pallet Town**.
- Improved rival Tier 3 timing so the trainer reveal occurs before the added World Building line.
- Save schema remains **4**.

### beta.26 runtime matrix promoted with the baseline

| Test | Result |
| --- | --- |
| Blue fresh title → SETUP | **PASS** |
| Blue Oak intro → bedroom | **PASS** |
| Yellow startup path | **PASS** |
| Gold → NUZLOCKE GOLD / BETA SETUP | **PASS** |
| Yellow starting Money | **PASS** |
| Yellow starting Rare Candies | **PASS** |
| Yellow forced starter nickname | **PASS** |
| Yellow Trainer Card front + NUZ STATUS only | **PASS** |
| Yellow pre-Ball Shiny Clause ON → route preserved | **PASS** |
| Yellow pre-Ball Shiny Clause OFF → route preserved | **PASS** |
| Yellow PokéCenter ON/OFF | **PASS** |
| Blue Pokédex handoff → route ledger activation | **PASS** |
| Blue Pokédex handoff → configured Balls in home PC | **PASS** |
| Blue first legitimate post-arm Route 2 encounter | **PASS** |

## 2.0.0-beta.25 — 25D4-RBY2 hotfix

- **Runtime confirmation:** Blue fresh title shows **SETUP** and successfully transitions through Oak's intro into the player's bedroom.
- **Runtime confirmation:** Yellow fresh title shows **SETUP** and successfully transitions through Oak's intro into the player's bedroom.
- **Runtime reconfirmation:** Gold still shows **GOLD BETA SETUP** and successfully boots into the player's bedroom.
- **Existing-save smoke confirmation:** Red loads with the Nuzlocke menus present and appears to be functioning normally in current testing.
- Restored the R/B/Y title **SETUP** injection to the historically proven menu behavior used by earlier stable builds, removing the later callback-shape dependency that could suppress SETUP on Blue/Yellow.
- Retained the protected Start-menu pattern where the vanilla menu is built first and Nuzlocke **RULES/TRACKER** entries are appended afterward.
- Added/retained forward declarations for `getDisplayRoutes` and `getEncounterState` so earlier recovery/rule closures capture the intended locals instead of resolving nonexistent globals.
- Fixed the reproducible R/B/Y post-intro white screen by preventing the optional Tier 3 Oak World Building TextBox from being pushed directly during `intro.oak_speech.finished`.
- The normal New Game staged-profile commit at `intro.oak_speech.finished` remains intact; only the unsafe cosmetic screen push was removed from that transition.
- No battle, capture, Gym Guide, shop, healing, item-rule, level-cap, save-schema, or Gold gameplay enforcement behavior was changed for the RBY2 white-screen fix.
- Save schema remains **4**.

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
- Gym Guide Rare Candy quantity selection is runtime-PASS; only a small centering/alignment cleanup remained for later work.
- Hardened No Repels and No X Items recognition to accept both item data keys and item display names.
- The shared `ItemEffects.use` gate rebinds once per diagnostic build instead of trusting a permanent boolean sentinel.
- No Escape, No Healing Items, No Field Heal, No PP Items, No PokéCenter, No Buying, No Selling, Nickname Rule, Gold Setup, and the Gym Guide selector remained protected runtime-PASS behavior.
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
- Established the Gym Guide direct-row composition architecture that remains protected in beta.25+.

### 2.0.0-beta.4

- Added World Building tiers and associated flavor/mechanic messaging.
- Added level-cap-aware Gym Guide feedback before the Rare Candy selector.
