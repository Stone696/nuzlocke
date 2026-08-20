# 2.6.0 user-facing note

**PC Catches** is now the first option in **QOL**. The feature itself has not changed: when enabled, compatible progression/completion-required captures that would otherwise be Nuzlocke-illegal can be sent directly to PC storage as permanently **PC LOCKED** without consuming the normal encounter slot. They still cannot be withdrawn into the active party or released.

# 2.5.92 user-facing note

No intended gameplay change. Run History/Graveyard-style consumers should no longer receive duplicate rows if the same faint is processed twice internally, while a Pokémon revived with an F. TOKEN can still have a later second death recorded normally.

# 2.5.91 user-facing note

No intended player-facing behavior change. Migration diagnostics are more accurate when older saves contain table-valued state.

# 2.5.90 user-facing note

No intended user-facing behavior changes. Gift and in-game Trade area attribution should behave exactly as in 2.5.89; this release only moves the underlying vanilla source catalog out of `main.lua`.

# 2.5.89 user-facing note

No intended user-facing behavior changes. DEV REPORT should look and behave exactly as it did in 2.5.88; this release only moves its implementation out of `main.lua` to reduce monolithic load/compiler pressure.

# 2.5.88 UI navigation QoL

During the current game/mod session, NUZ RULES/Setup, ENC TRACKER, MOD COMPAT, and DEV REPORT remember where you were when you close and reopen them. Collapsed NUZ RULES/Setup sections also stay collapsed for that session. These are convenience preferences only; they do not alter or persist as Nuzlocke challenge rules.

# 2.5.87 UI rollback / compatibility maintenance

The temporary 2.5.86 `O/X/-/*` Encounter Tracker marker experiment has been removed. ENC TRACKER uses the established pre-2.5.86 result presentation again. True graphical encounter-status symbols remain planned for a later font/glyph-aware implementation. Gameplay rules and saved encounter state are unchanged.

# 2.5.86 Encounter Tracker status markers

> **2.5.86 note:** ENC TRACKER now uses font-safe `O CAUGHT`, `X FAILED`, `- OPEN`, `* SHINY`, and `X DEAD` labels across classic R/B/Y, native Gold/Silver, and Modern UI presentation. Text remains explicit for accessibility; encounter mechanics and stored state are unchanged.

# 2.5.85 Run History producer completion

There is still no separate Run History player menu. The backend chronology is now wired for ordinary successful catches, Pokémon deaths, Gym Leader F. TOKEN awards, and successful F. TOKEN area/revive spends. This is groundwork for later Graveyard/Almanac/Run Recap presentation; existing ENC TRACKER, NUZ STATUS, and F. TOKEN controls behave the same as before.

## 2.5.83 compatibility-only update

> **2.5.84 note:** RS-CACHE-DEDUP-001 is fixed: unseeded Random Starter distinct-choice bookkeeping ignores scoped cache/internal marker rows and counts only canonical bare starter-slot mirrors. Seeded/deterministic starter behavior is unchanged. Gen1Recomp 0.2.14 is exact-runtime boot/DEV REPORT PASS.


2.5.83 does not add or change a player-facing rule or control. It updates Nuzlocke's audited Gen1Recomp marker to **0.2.14** after confirming that the engine's 0.2.13→0.2.14 changes are platform packaging/app metadata only. Existing Setup, NUZ RULES, encounters, Random Starter, save behavior, and compatibility-provider behavior are unchanged.

## 2.5.82 architecture-only update

2.5.82 does not add or change a player-facing rule. It moves the internal Public Interop / Capability API and automatic compatibility adapter infrastructure out of `main.lua` to reduce entry-file load/compiler pressure. Setup/rules behavior remains the runtime-confirmed 2.5.81 behavior.

A quick boot plus MOD COMPAT/provider smoke test is required for this extraction.

## 2.5.81 architecture-only update

2.5.81 does not add or change a player-facing rule. It moves the internal rule/settings catalog out of `main.lua` to reduce entry-file size and load/compiler pressure while preserving the same settings, defaults, descriptions, and save behavior.

The prior Gold runtime test confirmed 2.5.80 loads on Gen1Recomp 0.2.13 and Elm Random Starter shows and awards a randomized starter. Silver still needs its own separate confirmation.

## 2.5.80 Gold/Silver Random Starter retest

With **Random Starter** ON, inspect each of Elm's three Poké Balls before choosing. The displayed portrait and cry should match the randomized species that will be awarded from that Ball. A fixed Randomizer Seed should reproduce the same three choices on an unchanged fresh run. If Dev diagnostics are enabled, the Random Starter transaction health detail also reports whether the latest preview used the script-intent path or the native callback fallback.

Gold and Silver require separate runtime confirmation. R/B/Y behavior is unchanged.

## 2.5.78 save-safety update

2.5.78 does not add or change a player-facing rule. It hardens upgrades from older supported Nuzlocke save schemas so a numbered schema migration is preflighted before live writes, creates a verified three-deep pre-migration save snapshot rotation, and can recover from a recorded partial transition without treating it as committed. Save Schema remains 4.

Players normally do not interact with this system. If a migration cannot complete or recover safely, Nuzlocke pauses its own writes and rule enforcement rather than continuing on uncertain state. If a save was written by a **newer unsupported Nuzlocke schema**, the existing protective pause still applies rather than attempting a downgrade or guessing at unknown data.

## 2.5.77 release-safety update

2.5.77 does not add or change a player-facing Nuzlocke rule. It adds a fail-fast static release-safety gate for development/build validation. Existing runtime-known issues and exact-edition test requirements are unchanged.

## 2.5.76 documentation-only update

2.5.76 does not change player-facing rules, controls, save behavior, randomization, or UI mechanics. Public documentation was sanitized for durable release/technical provenance only.

## 2.5.75 process-only update

2.5.75 does not change player-facing rules, controls, save behavior, randomization, or UI mechanics. It formalizes the project's development/review workflow only.

The known Gold/Silver Random Starter presentation issue remains open: a randomized Pokémon can be awarded while Elm's pre-selection portrait/cry still needs exact-edition runtime repair/confirmation. Blue's 2.5.71 randomized starter portrait behavior remains protected.

## 2.5.74 documentation-only update

2.5.74 does not change rule behavior or add player-facing mechanics. It refreshes project documentation and planning only.

### Important current test note

On the tested Gold/Silver Random Starter path, the Pokémon actually awarded can be randomized while Elm's pre-selection Poké Ball portrait still shows the vanilla Johto starter. This is a known open Gen 2 presentation defect. Blue's randomized starter portraits were runtime-confirmed working on 2.5.71.

### Already implemented items that should not be confused with future plans

- **Physical/Special Split** is already available as a rule/QoL option.
- **Nickname Rule** already requires non-default nicknames on supported acquisition paths.

The newly documented ideas such as Smart Trainer AI, Catch-Up Training, battle-speed QoL, Move Relearner access, party HUDs, trainer-team redesigns and postgame facilities are **planned/investigation items only** unless a later release explicitly says otherwise.

## 2.5.73 Run History foundation

There is **no new Run History menu yet**. This build begins recording a bounded chronological backend for later Graveyard, Almanac/Run Recap and Confessional pages. Current Encounter Tracker and NUZ STATUS controls do not change.

The first recorded event families are successful catches, Permadeath deaths and F. TOKEN uses. Exact game edition is stored with the events so future recaps can distinguish Red, Blue, Yellow, Gold and Silver instead of collapsing by generation. If 2.5.73 is installed on an already-progressed run, the journal is marked partial rather than inventing older events; fresh runs started with the feature active are full-coverage.

## 2.5.71 Gold/Silver Random Starter retest

With **Random Starter** ON, inspect Elm's Ball preview, select that same Ball, and verify the Pokemon actually received is the exact displayed species. Use a fixed Randomizer Seed to confirm the same three previews repeat on an unchanged fresh run.

## 2.5.70 Gold/Silver Random Starter retest

With **Random Starter ON**, Elm's three Ball previews should no longer be forced to the vanilla Johto trio. At least one choice should normally be a different legal species; the Pokemon actually received must exactly match the selected preview. Starter Style and challenge bans still constrain the candidate pool. With a fixed Randomizer Seed and unchanged settings, the same three choices should repeat. The selected physical Ball still controls the normal story/rival branch.

## 2.5.69 Gold/Silver Random Starter retest

For a fresh Gold or Silver run with **Random Starter ON**, Elm's three Ball previews should show their persisted randomized choices and the Pokemon actually received from the selected Ball should match that preview. The selected vanilla Ball still determines the normal story/rival branch. Nickname behavior remains controlled by the Nickname Rule. With a fixed Randomizer Seed and unchanged settings, repeating the run should produce the same three starter choices.

## 2.5.65 Silver beta support

On Gen1Recomp 0.2.11, Nuzlocke can now load on **Pokémon Silver**. Silver is beta/test-required and currently follows the same Gen 2 rule/UI architecture as Gold. A fresh Silver game should expose the same Nuzlocke **SETUP** entry used by Gold, while an existing Silver save should hide that new-game-only Setup row. Silver and Gold keep separate staged Setup profiles.

Automatic default names follow the running edition: Gold uses **GOLD** for the player and **SILVER** for the Rival; Silver uses **SILVER** for the player and **GOLD** for the Rival. Normal Pokémon nickname prompts remain controlled by the Nickname Rule.

## 2.5.63 Dev/recovery retest

Yellow runtime testing should retry Dev Tools **VIEW REPORT**, **RUN + SAVE**, and Encounter Tracker reassignment. The prior `reportCodeHash` nil error and compatibility `table index is nil` error are specifically repaired in this build. If an unexpected error remains, preserve the exact `NZERR-2.5.63-xxxxx` code.

## 2.5.62 Dev/recovery error behavior

Dev Tools **RUN + SAVE** and **VIEW REPORT** now use Gen1Recomp's bound mod-storage API correctly. If an unexpected Dev error remains, the Dev Tools screen shows an `NZERR-2.5.62-xxxxx` code and A/B/Start returns immediately. Encounter Tracker recovery/reassignment invalid combinations remain no-op and now show their feedback inside the editor; A/B/Start dismisses it.

## 2.5.61 safe recovery edits and Dev error codes

When **Recover Catches / Encounter Tracker editing** rejects an impossible or stale change, it now explains the problem and leaves the saved encounter data unchanged. This is normal validation and does not produce a bug code.

If the recovery screen or Dev Tools **RUN + SAVE** hits an unexpected internal error, Nuzlocke now attempts to keep the game alive and displays a code such as `NZERR-2.5.61-12345`. Please include the exact code and the action you were performing in the bug report. Full diagnostic detail is retained in Dev Mode when available.

## 2.5.59 reliability-only build

2.5.59 does not intentionally change player-facing controls, rules, or dialogue. It adds an internal lint that rejects unreachable fallback dialogue when a Nuzlocke world-text catalog entry already supplies the message.

## 2.5.58 reliability-only build

2.5.58 does not intentionally change player-facing controls or challenge behavior. It adds internal consistency checks for duplicated progression data used by level caps and badge tracking.

## 2.5.57 reliability-only build

2.5.57 does not intentionally change player-facing controls or challenge behavior. It adds internal regression protection so trainer rewards cannot silently lose their Nuzlocke-active enforcement checks, while background progression/reconciliation paths that are intentionally valid with the master rule OFF remain unchanged.

## 2.5.56 reliability-only build

2.5.56 does not intentionally change player-facing controls or challenge behavior. It continues the reliability refactor so ordinary numeric rule values are validated from the same rule definitions that already own their defaults and ranges. Existing saves and Setup/NUZ RULES choices keep the same meanings.

## 2.5.55 reliability-only build

2.5.55 does not intentionally change player-facing controls or challenge behavior. It begins a reliability refactor so each ordinary rule has one authoritative registration record for its default/type/range/UI metadata. Existing saves and Setup/NUZ RULES choices keep the same meanings and defaults.

## 2.5.54 stability-only build

2.5.54 does not intentionally change player-facing rules or controls. It is a compiler-budget refactor that gives the existing Lua code room to grow safely. Dev Report codes remain `NZR5-` as introduced in 2.5.53.

## 2.5.53 Dev Report codes

Fresh Dev Report codes now begin with `NZR5-`. Old `NZR4-` codes are still valid for diagnosis. NZR5 removes redundant health bits so a single code cannot say PASS while its own encoded counters say otherwise.

## 2.5.51 Gold Random Starter repair

Gold Random Starter still works the same from the player's perspective: turn it on before receiving Elm's starter, inspect the three balls, and choose normally. 2.5.51 changes only the internal handoff that makes the selected randomized preview become the Pokemon actually granted.

## 2.5.50 F. TOKEN rerolls

Choose **F. TOKEN → REROLL ENCOUNTER** to see every currently eligible FAILED encounter area; you do not need to travel back to that location first. You can also highlight an eligible FAILED area in **ENC TRACKER** and press **A:REROLL**. Both routes open the same confirmation page. No choice is selected initially: move to **YES** and press A to spend the token, or press B to cancel.

## 2.5.49 F. TOKEN selection

On R/B/Y, the currently highlighted F. TOKEN action and revive target are marked by the native sideways selection arrow. Use Up/Down to move, A to choose, and B to cancel.

## 2.5.48 F. TOKEN and Gym Guide text

On R/B/Y, F. TOKEN uses a full native Nuzlocke page for both the spend-choice and revive-selection screens. Gym Guide Rare Candy messages are player-paced: press A/B to advance each page before the quantity selector appears.

## 2.5.47 F. TOKEN screen repair
On R/B/Y, using an F. TOKEN now hands screen ownership to the Nuzlocke selector instead of leaving the native item-use UI underneath it. Gold continues to use its native Gen 2 Pack/Chrome presentation.

## 2.5.46 Gold Dev Mode

In Gold, enabling **Dev Mode** in NUZ RULES should make **DEV** appear in the START menu immediately when you return to it. Turning Dev Mode OFF should remove the row. If either behavior fails, record a runtime report before changing other settings.

## 2.5.45 F. TOKEN screen repair
On R/B/Y, the F. TOKEN spend selector and revival list now use the protected native-size Nuzlocke screen layout. Using the item should open a clean full custom screen rather than overlapping the Bag/item-target interface. Gold continues to use its native Gen 2 presentation.

## 2.5.44 Dev Report Code reliability

VIEW REPORT still shows an `NZR4` code. The code is now distributed across balanced hyphen-grouped rows so short trailing checksum characters are not stranded alone. Join the visible groups with hyphens when sharing the code.

When decoded through the Dev API, `consistent=true` means the code's redundant PASS/WARN summary bits agree with its own hook/lifecycle/safe-stop/rule/randomizer counters. `consistent=false` identifies an internally contradictory legacy/copied code and should be treated as diagnostic evidence requiring the full report or a fresh code.

## 2.5.43 Gold dialogue reliability

Gold Nuzlocke battle-rule refusals keep the player-paced A/B behavior from 2.5.42, but now leave the battle's own pending message/action queue untouched. After the final page, the battle returns to the exact state it was in before the refusal appeared.

## 2.5.42 gameplay text behavior

Nuzlocke-added gameplay dialogue that interrupts or denies an action is player-paced. It remains on screen until A/B is pressed. When the message needs more than the native two-line text area, A/B is required between pages. This applies to the Gold battle-rule refusal paths hardened in 2.5.42 and preserves the existing R/B/Y behavior.

## 2.5.41 — recent-feature repairs

F. TOKEN revival now fully respects a Party Size Limit that was lowered after a death. If another compatible system kept the dead Pokemon in your active party and reviving it there would leave the party above the current limit, the revived Pokemon is sent to a PC box with room instead. If no legal storage exists, the token is not spent.

Trade Evolutions still work only as the intended level-up alternative at level 40+. 2.5.41 tightens the internal trigger so link trades, evolution items, forced evolution paths, and other non-level-up checks stay native.

When Area Splits are OFF and several physical subsections are merged into one logical encounter area, spending an F. TOKEN forgives that **merged logical slot**. All failed subsection rows currently feeding that slot are cleared; turning splits ON later does not restore those forgiven failures.

Build/release names use only the numeric version from now on.

## 2.5.40 — F. TOKEN / Route Forgiveness

Route Forgiveness now gives you a real **F. TOKEN** item instead of prompting automatically or selling tokens in Marts. The setting still controls whether Gym Leaders award tokens and whether you may use them; its `0`/`1` NEW GAME modes still choose the starting quantity.

Use F. TOKEN **outside battle** and choose one action:

- **REROLL ENCOUNTER:** opens a list of every eligible FAILED encounter area in the tracker, regardless of where you are standing. Select an area, deliberately confirm YES, and one token reopens that area so its next legal encounter is another attempt. It cannot erase a completed catch.
- **REVIVE POKEMON:** choose a fallen Pokemon preserved by the Permadeath archive. It returns at half HP. If your party has room under Party Size Limit it rejoins the party; otherwise it is sent to a PC box with room. A full PC refuses the revival without consuming the token.

The token cannot be bought, sold, tossed, or given. Deaths recorded from 2.5.40 onward have exact revival snapshots; older tracker/history-only losses cannot safely be rebuilt because those records do not contain the full Pokemon state.

## 2.5.39+DEV — Trade Evolutions

A new **Trade Evolutions** option appears under **QOL** and defaults **OFF**. ON changes only otherwise trade-required evolutions:

- Ordinary trade evolutions become eligible on the next level-up at **level 40+**.
- In Gold, evolutions that normally require trading while holding an item still require that held item; it is consumed when the evolution succeeds.
- Holding the relevant Gold trade item preserves that branch when the species also has a normal level branch. For example, Slowpoke holding King's Rock waits for Slowking at level 40 instead of becoming Slowbro at 37. Remove King's Rock if you want the normal Slowbro evolution.
- Everstone still prevents the level-triggered trade evolution.
- Real link trades still work normally.
- Evolution Limits are separate challenge rules and can still block the evolution.

## 2.5.38+DEV feedback notes

- The battle `AREA:SPENT` encounter indicator is unchanged; a broader encounter-HUD redesign is planned separately.
- When Party Size Limit is **6**, PC behavior/messages are native. Nuzlocke-specific "party limit" refusal text appears only when you selected a challenge limit of **1-5**.
- With Gym Guide Rare Candy enabled, the post-Champion MAX-cap World Building reminder becomes **"You've earned it."**
- Starting with 2.5.38, DEV builds use `+DEV` build-metadata notation instead of `-DEV`; this is intentional and keeps the installed version equal in precedence to its own numeric release.

## 2.5.37-DEV bug-fix notes

This build does not add a new rule. It hardens recently added Random Field Items, PC-aware Whiteout, PC-Only Catches, and World/QoL lock behavior.

- With **Random Field Items ON**, HMs remain exactly where the base game authored them. In Gold, the Ice Path HM07 WATERFALL item ball must still award HM07.
- Gold storage may contain later Box tables even when an earlier Box table has never been created. Whiteout and Nuzlocke ownership/history scans now see those later boxes correctly.
- A **PC-Only Catch** made with five party members may temporarily become party member six; if the current Gold box is full but another box has room, Nuzlocke files it into the available box instead of leaving a PC-locked Pokemon on the active team.
- **Radio Nuzlocke** remains adjustable while Rule Lock is active.
- The **SOLO** loadout is destructive on a total wipe and is now described as **run-ending Blackout** in the loadout help text.

### 2.5.37 runtime priorities

Gold: test HM07 WATERFALL with Random Field Items ON; create/use a later Box while leaving an earlier Box table unused and wipe with Whiteout ON; test PC-Only Catch with party size 5, current Box full, another Box available; then enable Rule Lock and confirm Radio Nuzlocke still toggles. Also inspect the SOLO loadout description.

## 2.5.36-DEV compatibility notes

This build does not change Nuzlocke rules or gameplay. It records a fresh source audit of Gen1Recomp `dev` at **`def270f7c726ebd7bd87086ad90bc4a7b9622543`** while keeping **0.2.7** as the stable published compatibility baseline. Gold's read-only battle data can now expose Ball counts and native catch-chance previews to compatible HUD/diagnostic consumers; Nuzlocke itself still enforces catches through the same rule paths as before.

### 2.5.36 runtime priority

On a current Android build that supports returning to the launcher without restarting the app, smoke-test **Red or Yellow -> launcher -> Gold -> launcher -> Red or Yellow**. Confirm the Nuzlocke Setup/NUZ RULES surfaces still open normally, Gold Random Starter behaves normally, Running Shoes/Fast Surf retain their selected modes, Unlimited Bag Space retains its selected state/behavior, and no rule appears to run twice from a stale wrapper. Desktop/iOS do not need this specific hot-swap test unless the same in-process lifecycle is exposed there later.

## 2.5.35-DEV bug-fix notes

Gold Random Starter now keeps Elm's generated `givepoke` script data immutable. Preview rows remain presentation-only copies, and the native Gold give-Pokémon transaction is the sole point that substitutes the selected randomized species. The three Elm choices also reuse a stable per-seed/per-style slate cache.

Unlimited Bag Space remains a QoL control even after Rule Lock is enabled. Rule Lock still seals challenge-rule changes; it does not seal this QoL toggle.

### 2.5.35 runtime priorities

Test two or more Gold New Games in the same Gen1Recomp process, including changing Random Starter OFF/ON between runs; repeatedly inspect all three Elm balls with a fixed seed; then enable Rule Lock and verify Unlimited Bag Space can still be changed while a normal challenge rule cannot.

## 2.5.34-DEV Unlimited Bag Space

**Unlimited Bag Space** is a normal QoL toggle and defaults **OFF**. It is available in R/B/Y and Gold and remains adjustable independently of challenge-rule locking.

- **R/B/Y:** ON removes the distinct-item slot ceiling from the normal Bag.
- **Gold:** ON removes distinct-item slot pressure from the ordinary **ITEM** and **BALL** pockets. Gold's **KEY ITEM** and **TM/HM** capacities remain native.
- Item stacks still stop at **99**. This is more bag *slots*, not infinite quantities.
- PC item storage is unchanged. Nuzlocke item-use bans, shop rules, field-pickup legality, story/key-item acquisition, tossing, selling, and Bag ordering are unchanged.
- Turning the toggle OFF never deletes excess contents. Native/provider capacity simply becomes authoritative again for adding new distinct items.

### 2.5.34 runtime priorities
- R/B/Y: exceed the native distinct-item Bag limit while ON and successfully pick up another distinct ordinary item.
- Gold: exceed native ITEM and BALL pocket slot limits while ON; confirm KEY ITEM/TM-HM behavior remains native.
- Confirm a stack cannot exceed 99 even while Unlimited Bag Space is ON.
- Turn OFF while already above capacity: existing contents must remain, while a new distinct item is refused until the pocket has room again.

## 2.5.33-DEV Running Shoes and Fast Surf

Both movement QoL options use the same three positions and cycle with **Left / Right / A**:

- **OFF** — vanilla speed.
- **HOLD B** — 2x movement while B is held.
- **ALWAYS** — the same 2x movement without holding B.

**Running Shoes** applies only while walking on foot. It does not speed up the Bicycle or Surf. Existing saves that had the older Running Shoes ON toggle are migrated to **HOLD B**, preserving the behavior they already had.

**Fast Surf** applies only to ordinary player-controlled Surf movement. It does not speed up walking, biking, fishing, the act of starting Surf, Waterfall/scripted movement, or cutscenes. Both options are available in R/B/Y and Gold.

### 2.5.33 runtime priorities
- Running Shoes OFF: walking remains native. HOLD B: only held-B walking is faster. ALWAYS: walking is faster with or without B.
- Fast Surf OFF: Surf remains native. HOLD B: only held-B Surf is faster. ALWAYS: Surf is faster with or without B.
- Confirm bike speed and scripted movement remain unchanged.
- If QoL Toggles `run_hold_b` is installed, confirm held-B walking is not accidentally compounded to 4x.

## 2.5.32-DEV Gold Random Starter behavior

With Random Starter enabled in Gold, Elm's three Poké Balls now represent a deterministic three-choice randomized slate. The same seed and Starter Style always give the same slate, and looking at the balls in a different order does not change it. The mod avoids duplicate choices when enough legal candidates are available. The portrait and cry shown for a ball are presentation-only rewrites; choosing that ball still lets Gold's native GIVEPOKE flow create and nickname the actual Pokémon.

## 2.5.31-DEV Whiteout / Blackout recovery

**Whiteout** once again means the run can survive a total-party KO. Turn Whiteout **ON** if you want that recovery behavior. After the faint/death bookkeeping finishes, Nuzlocke checks the whole usable roster:

- If at least one legal Pokemon remains in the active party or a PC Box, the Whiteout survives. The game uses its normal blackout return. If your party is empty, withdraw one of those reserves from the PC before continuing.
- Dead Pokemon, Eggs, and permanent **PC LOCKED** Pokemon from PC-Only Catches do not count as reserves. If those are all you have left, the run is over.
- Whiteout **OFF** is **Blackout**: a full wipe ends/deletes the run even when an otherwise legal Pokemon is sitting in the PC.
- First Rival Mercy still takes precedence for the one opening Rival battle.

With **Permadeath ON**, the wiped team is dead and removed before the reserve check, so survival normally requires a legal boxed Pokemon. With Permadeath OFF, the fainted party remains recoverable and the native blackout heal can restore it. Gold's Bill's PC normally refuses an empty party; 2.5.31 allows that PC to open specifically for a surviving Whiteout with an eligible boxed reserve.

Existing saves are migrated automatically so the behavior they had selected under the older inverted Whiteout boolean does not unexpectedly change. Fresh 2.5.31 saves already use the corrected meaning.

### 2.5.31 runtime priorities
- Whiteout ON + Permadeath ON: wipe while one ordinary Pokemon is boxed. Confirm the run survives, the dead active party stays gone, and the boxed reserve can be withdrawn.
- Repeat with no boxed reserve: confirm Blackout/run end instead of an empty-party softlock.
- Repeat with only a PC-locked catch or Egg boxed: confirm it does not rescue the run.
- Whiteout OFF + boxed reserve: confirm the run still ends.
- Gold: after a surviving empty-party Whiteout, confirm Bill's PC opens and withdrawal works.
- Repeat a field-poison full wipe and the First Rival Mercy loss path.

## 2.5.30-DEV Gold Random Starter repair

Gold **Random Starter** is intended to change only the concrete Pokemon received from the Elm Ball you select. The Ball choice itself still drives the normal Gold story/event and rival-counterpick branch. With Random Starter ON, the received Pokemon is selected deterministically from the chosen Starter Style and seed; the selected vanilla species is excluded from its own candidate pool when legal alternatives exist.

2.5.30 adds a direct transaction repair so the randomized species is applied at Gold's native `givepoke` grant, even if the earlier preview/script-command layer does not carry the replacement through. The first Elm preview/grant also restores the staged Random Starter toggle, Starter Style, and seed to the fresh save if Gold's NEW GAME save-backing handoff occurred before the full Setup profile commit.

The starter nickname rule is unchanged: if Nickname Rule is ON, the starter still requires a non-empty nickname.

### 2.5.30 runtime priorities
- Fresh Gold NEW GAME, set Random Starter ON and use a fixed nonzero seed. Receive an Elm starter and confirm it is not the vanilla species from the selected Ball.
- Repeat the same selected Ball, seed, and Starter Style from an equivalent fresh run and confirm the same species is selected.
- Confirm the chosen Elm Ball's story/rival path is unchanged.
- Confirm Nickname Rule still forces a non-empty starter nickname.
- Open DEV SELF TEST and confirm `gold_random_starter_transaction_gate` is healthy.

## 2.5.29-DEV Gold parity

### Gold Ball Per Encounter
Gold now exposes **Ball Per Enc.** in Setup and NUZ RULES. Choose **OFF / 1 / 2 / 3 / 5 / 10** legal Ball throws per catchable encounter. OFF is unlimited. Illegal or otherwise blocked Ball attempts do not spend the budget, and each new battle starts a fresh budget. When **No Catching** is ON, Ball Per Enc. is hidden while its saved choice is preserved.

### Gold NEW GAME starting resources
Gold now has dedicated resource rows; the R/B/Y resource profile is not reused.

- **Starting Money:** 000000-999999; default **003000** preserves vanilla Gold.
- **Starting Rare Candy:** 00-99; default **00**. The selected amount is placed in bedroom PC storage on the fresh save.
- **Starting Poke Balls:** 00-99; default **00**. This is an **extra PC allotment** in addition to Gold's normal 5-Ball story reward. The extra Balls are deliberately withheld during the opening and released only after the Mystery Egg is returned to Elm, so Route 29 cannot become capture-ready early just because Setup supplied Balls.

Quick Nuzlocke Start still grants/reconciles the normal 5-Ball milestone. Any configured extra Starting Poke Balls are then released to the PC from the same post-Elm progression state and only once.

### 2.5.29 runtime priorities
- In Gold Setup, verify Starting Money edits all six digits and Starting Balls/Candy edit two digits.
- Start a normal Gold NEW GAME with custom money/candy/balls. Money and Candy should match immediately; extra Balls should be absent before the Mystery Egg return and present in the PC afterward.
- Repeat with Quick Nuzlocke Start and verify the native 5 Balls plus the extra PC allotment exactly once.
- Set Ball Per Enc. to 1, throw one legal Ball that fails, and verify a second legal throw is refused; start another battle and verify the budget resets.
- Switch between R/B/Y and Gold Setup profiles and verify starting-resource values remain generation-specific.

## 2.5.28-DEV PC-Only Catches
**PC-Only Catches** is OFF by default. Turn it ON when you want to catch Pokemon for Pokedex completion or a story/progression requirement without making an otherwise illegal Pokemon usable in the Nuzlocke run.

If a capture is blocked by an eligible challenge rule (for example Type Locke, an already-used area/Dupes state, Static, a species ban, town/overworld eligibility, or Maximum BST), the game may complete the capture but immediately sends that Pokemon to a Box and marks it **PC LOCKED**. It does not spend the area's encounter, does not count as a Catch Draft lane, and does not make a future legal encounter a Dupe just because the research-only Pokemon is in storage.

A PC-locked Pokemon is permanent storage-only: you cannot withdraw it, move it from a Box into the party, or release it. You may still organize it between Boxes. Turning PC-Only Catches OFF later does not unlock Pokemon already marked this way.

Safety limits: glitch/malformed Pokemon remain blocked. Party Size Limit alone does not turn a legal catch into a PC-only catch. **No Catching still blocks ordinary captures even when PC-Only Catches is ON**; only a compatible scripted/progression capture that explicitly requests the progression exception may bypass No Catching. Storage must have room before an exception is allowed. In Gold, if your party is already full, the currently selected Box must have room because Gold checks that Box before the Ball is thrown. If the party has five members, a successful PC-only catch may briefly fill slot six and is then filed into the preflight-selected/next available Box; it is never meant to remain PC LOCKED in the active party.

## 2.5.27-DEV Maximum BST presets

Maximum BST now cycles through **OFF / 300 / 350 / 400 / 450 / 500 / 550 / 600 / 650 / 700**. OFF removes the BST restriction. Any numeric preset blocks newly acquired catches, gifts, and trades whose live merged BST is above that ceiling; mandatory starters remain exempt so progression cannot be broken.

Existing saved thresholds are not migrated. A legacy free-form value continues to enforce exactly as saved and shows as CUSTOM until you adjust the setting; the first adjustment anchors to the nearest preset and then cycles normally.

## 2.5.26-DEV R/B/Y Stat Info layout
On R/B/Y, NUZ INFO → STAT INFO now shifts the ATK/DEF/SPE/SPC detail column left and widens it so normal/native value + DV + Stat EXP strings fit without marquee scrolling. LEVEL/HP also have more room. Catch Info, Move Info, and Gold presentation are unchanged.

## 2.5.25-DEV Random Field Items

**Random Field Items** defaults OFF. When ON, ordinary visible overworld item-ball pickups in R/B/Y and Gold are replaced deterministically when collected. The feature uses a separate `FIELD_ITEMS` stream under the same 8-digit seed, so it does not alter the seeded choices for starters, encounter tables, or learnsets.

Progression safety is conservative: key items and HMs stay in their original authored pickup slots and cannot appear as random replacements. Hidden items, NPC gifts, shops, fruit/apricorn trees, and other scripted rewards are unchanged in this first scope. Already-collected item balls stay collected; changing the setting/seed affects only future unresolved pickups.

### 2.5.25 runtime priorities
- R/B/Y: enable Random Field Items with a known seed and collect at least three ordinary visible item balls; confirm the received items differ when expected and pickup objects disappear normally.
- Repeat the same seed/settings from a fresh equivalent save and confirm the same map/object slots resolve to the same items.
- Fill the bag and attempt a randomized visible pickup; confirm the native full-bag refusal leaves the ball available for retry.
- Verify at least one progression-critical visible pickup (especially an HM where applicable) remains its vanilla item.
- Gold: repeat an ordinary item-ball pickup plus the protected Ice Path HM07/Waterfall pickup.
- DEV hook health should show the generation-appropriate Random Field Items adapter HEALTHY once its engine module is loaded.

## 2.5.24-DEV development note

NUZ RULES and NEW GAME Setup now remember where you were during the current mod session. Close the screen and reopen it to return to the same selected rule/header and scroll window. R/B/Y and Gold keep separate positions, as do Setup and active-save Rules. This is navigation-only state: it is not saved into a game save or setup profile and resets on a fresh process/mod reload.

### 2.5.24 runtime priorities
- R/B/Y NUZ RULES: move several pages down, close with B, reopen, and confirm the same selected row and visible scroll window return.
- R/B/Y NEW GAME Setup: repeat the same check independently from NUZ RULES.
- Gold NUZ RULES/Setup: repeat both checks and confirm Gold does not inherit the R/B/Y position.
- Collapse/expand a section and toggle a parent that hides dependent rows (for example Random Starter/Style); confirm reopening never lands on an unrelated row or crashes.

## 2.5.23-DEV development note

This build specifically repairs fresh-New-Game Yellow regressions found during real-device 2.5.22 testing. Random Starter, the Pallet Town starter log/provenance transaction, No Mom Heal, and Skip Catch Demo should now all be live on the same fresh New Game path, including when the opening Professor Oak explanation is skipped.

### 2.5.23 runtime priorities
- Yellow fresh New Game with **Random Starter ON**: starter must not silently fall back to Pikachu when Pikachu is excluded by the selected pool; the same seed/settings must remain deterministic.
- Yellow with **Skip Catch Demo ON**: Oak's Pallet Pikachu capture demonstration must be skipped while the story still proceeds into Oak's Lab normally.
- After receiving the starter, confirm its encounter/tracker entry is **Pallet Town**, not UNKNOWN/Oak Lab.
- With **No Mom Heal ON**, Mom must refuse the healing transaction and must not restore HP/PP/status.
- DEV SELF TEST should report healthy `late_runtime_phase_2`, `oak_catch_demo_gate`, `rby_starter_transaction_gate`, and Mom-heal gate rows, with the selected setting rows matching the setup choices.

# Nuzlocke 2.5.30-DEV user guide

## 2.5.22-DEV development note

This reliability build does not change randomizer algorithm **v1** results or any challenge rule. It hardens Gen 1 text kerning across mod reloads and makes starter RNG read the same algorithm-version source as encounter/learnset RNG. If upgrading directly from a pre-2.5.22 build through a hot reload, the old kerning wrapper may require one full game/process restart because older builds did not record enough wrapper identity to remove it safely.

### 2.5.22 runtime priorities
- Fresh process, R/B/Y: confirm normal Nuzlocke/Modern UI text kerning still renders correctly.
- Reload Nuzlocke within the same process, then render Gen 1 text again; confirm spacing is applied once and no stale/double wrapper behavior appears.
- Use a known randomizer seed and starter settings in 2.5.21 and 2.5.22; confirm algorithm v1 chooses the same starter.
- Confirm NUZ STATUS / rules surfaces still show the current RNG version beside an active seeded randomizer.

## 2.5.21-DEV development note

Trainer rewards and progression bookkeeping now agree on how a boss trainer is identified. This primarily hardens compatibility with alternate trainer/provider payloads; no player-facing rule or save format changes.

### 2.5.21 runtime priorities
- Defeat a normal R/B/Y Gym Leader and verify progression/cap state advances normally.
- Defeat a Gold Gym Leader and verify the same.
- Re-check a Forgiveness Token Gym reward alongside progression so both systems agree on the defeated Leader.

## 2.5.20-DEV development note
Turning **Nuzlocke OFF** pauses challenge-rule consequences; it does not make the mod forget ordinary boss progression. If you beat a Gym Leader, Elite Four member, or Champion while the master switch is OFF, that supported-save progression remains synchronized for level-cap/status purposes when you turn Nuzlocke back ON. Failed encounters, Forgiveness Tokens/rewards, trainer-money challenge scaling, and Permadeath cleanup do not run while Nuzlocke is OFF. A save written by a newer unsupported Nuzlocke schema remains read-only to this older build.

### 2.5.20 runtime priorities
- With Nuzlocke OFF, defeat a Gym Leader, turn Nuzlocke back ON, and confirm progression/caps recognize the win.
- With Nuzlocke OFF, fail an otherwise eligible wild encounter; after turning Nuzlocke ON, confirm that area was not silently consumed.
- With Route Forgiveness configured, confirm F. TOKEN is unavailable while Nuzlocke is OFF and returns when ON.
- Confirm normal Permadeath/Failed Encounter/Forgiveness behavior is unchanged while Nuzlocke is ON.

## 2.5.19-DEV development note
This reliability build does not intentionally change player-facing rules. It strengthens downgrade/newer-schema read-only safety and compatibility diagnostics. Existing explicit rule choices remain unchanged.


## 2.5.18-DEV development note
This build hardens developer/compatibility metadata only. Player-facing rule behavior and Save Schema remain unchanged from 2.5.17; runtime regression testing is still recommended.

## 2.5.17-DEV quick reference

This child is development infrastructure only: no challenge rule, loadout, encounter behavior, save representation, or gameplay default intentionally changes from 2.5.16. Dev Mode SELF TEST now checks the machine-readable Rule Registry, Save Schema configuration descriptor, exact parent build provenance, and Compatibility API capability-version coverage.

### 2.5.17 runtime priority
- Open **DEV TOOLS -> SELF TEST** and confirm `rule_registry_descriptor`, `save_config_descriptor`, `build_provenance`, and `compat_capability_versions` report PASS.
- Normal gameplay smoke testing should behave exactly like 2.5.16; any gameplay difference is a regression rather than an intended feature.
- The repository CI/tests used for automated development checks are not part of the player mod package.

## 2.5.16-DEV quick reference

This is a reliability/compatibility diagnostics child of 2.5.15. No rule name, explicit saved choice, save schema, or public API number changes. Missing default-ON settings and the loadout label now use the same canonical defaults everywhere, while wrapper health is stricter across reload/rebind scenarios.

### 2.5.16 runtime priorities
- Reload/session smoke test: automatic default names in R/B/Y and Gold should still trigger exactly once.
- R/B/Y: legal/blocked catch plus one Permadeath faint; confirm no duplicate messages/death records after reload.
- Gold: Nickname Rule, No Buying/No Selling, and No Gambling should remain enforced after leaving/re-entering the mod/game session.
- With QoL Toggles installed: **No Repels ON** must prevent AUTO-REPEL consumption; OFF must leave AUTO-REPEL native.
- With Wilds of Kanto installed: test one allowed and one rejected overworld capture and confirm an allowed catch reaches normal Nuzlocke tracking/provenance once.
- Dev Mode hook health should show the relevant loaded critical seams as HEALTHY or explain CHAINED/PENDING rather than silently omitting them.

## 2.5.15-DEV quick reference

This build is a focused reliability child of 2.5.14. No player-facing rule names or defaults change. **Whiteout** now also applies to a full-party overworld poison wipe even when Permadeath is OFF. Gold **No Escape** now blocks the shared RUN roll correctly. New-game preset/loadout selection is explicitly persisted with the rest of the staged rules.

### 2.5.15 runtime priorities
- R/B/Y: Whiteout ON + Permadeath OFF, poison the full party to 0 HP; confirm the run ends and the save is deleted rather than continuing from the heal point.
- Gold: repeat the same field-poison Whiteout test.
- Gold ordinary wild battle: No Escape ON should produce the native failed-run result and spend the turn; OFF should allow normal escape rules.
- New Game: choose a named Nuzlocke Loadout, save/start, then confirm the active `NUZ RULES` loadout label matches the staged choice.
- R/B/Y + Gold PC: Party Size Limit should reject a withdrawal/MOVE into the party at the cap after a reload.
- Gold: smoke-test No Day Care, battle Whiteout, Headbutt encounter tracking, and forgiveness-token shop stock after leaving/re-entering the mod session.

## 2.5.14-DEV quick reference

This build is a focused correctness/lifecycle child of 2.5.13. For players, no rule was renamed and no explicit saved choice is changed. The visible difference on a missing/legacy key is that enforcement now agrees with the documented fresh defaults: One Per Area ON, Nickname Rule ON, Dupes FAMILY, Allow Gifts ON, and Allow Trades ON. Gold World Building also falls back to the documented T1 default when no explicit value exists.

### 2.5.14 runtime priorities
- R/B/Y randomized or compatibility-modified Oak starter: confirm Pallet provenance and Nickname Rule still apply, with no second starter transaction.
- R/B/Y catch: one legal catch, one rejected catch, and Ball Per Enc. if enabled; confirm no duplicate ball spend/refund.
- R/B/Y player faint/Whiteout: confirm one death record and normal native battle teardown.
- Gold catch/Ball use: confirm one legal and one rejected Ball path after load/reload.
- Legacy/missing-key profile if available: confirm NUZ RULES display and actual enforcement agree on the canonical defaults above.

## 2.5.13-DEV quick reference

Use **NUZ RULES** to change active-run settings and **ENC TRACKER** to review encounter status. Numeric selectors use LEFT/RIGHT or A to cycle unless they are intentional resource editors such as starting money/Balls/Candies.

Key current selectors:
- **Shiny Clause:** OFF / 1 / 2 / 3 / UNLIMITED. Fresh/new profiles default to **OFF / 0**; existing saves keep their stored value.
- **Encounter Ball Limit:** OFF / 1 / 2 / 3 / 5 / 10 legal Ball throws.
- **Randomizer Info Policy:** OPEN INFO / BLIND INFO.

For Dev Mode, **DEV TOOLS → VIEW REPORT** shows the live report and its **NZR4** code without requiring a new export. Blue 2.5.6 runtime confirms the saved-report View Report path no longer crashes across a fresh game session. 2.5.7 reformats the report for the native viewport: **REPORT CODE:** is followed by the complete NZR4 value across multiple hyphen-grouped lines, and long diagnostic IDs are hard-wrapped instead of clipping off-screen. Use RUN + SAVE only when exact free-form diagnostic text is required.

Field-item rule refusals now use blocking dialogue pages with narrow wrapping; press A to advance.

A randomized starter counts as the **Pallet Town** starter encounter regardless of which species the randomizer selected.




### 2.5.13 field-poison Permadeath test note
With **Permadeath ON**, a Pokémon that reaches 0 HP from overworld poison should now be recorded as a death and remain gone even if the engine subsequently performs its normal blackout heal/warp. The ordinary poison faint text and native blackout sequence should still appear. With **Permadeath OFF** or **Nuzlocke OFF**, field poison remains engine-owned vanilla behavior. This repair still needs runtime confirmation in R/B/Y and Gold.

### 2.5.12 Gen1Recomp 0.2.7 Gold compatibility
The public final encounter-registry view now follows Gen1Recomp's Gold `gen2Encounters` target. This matters to cooperative encounter-information tools (DexNav/guide/provider-style consumers) and does not change which encounters Nuzlocke itself rolls. Gen1Recomp 0.2.7 also adds time-dependent Gold fishing rows; day/night fishing should be runtime-smoke-tested with the current build.


### 2.5.11 World Building default
**World Building** defaults to **TIER 1** for fresh/missing selections. T1 gives clear rule feedback; T2 adds challenge personality; T3 adds region/NPC-aware flavor. Existing saves keep any explicit OFF/T1/T2/T3 choice.


### 2.5.10 Pokégear RULES and empty tracker views
On Gold with the Pokégear integration, **NUZ → RULES** shows four active rules at a time. If more than four rules are active, press **A** for the next rule page; the header shows `RULES x/y` and the footer shows `A:MORE` while additional pages exist. The final page may contain fewer than four rules and remains reachable.

If the current **ENC TRACKER** LOG/MAP data set contains no rows yet, the screen now says **NO ENTRIES YET** instead of leaving the list area blank. This is presentation-only and does not create an encounter entry.

### 2.5.8 Yellow setup/rules re-test
Yellow 2.5.7 runtime testing confirmed the loadout warning still overflowed its frame and Type Locke edits could still trigger the generic NUZ RULES update error. In 2.5.8, re-test a loadout change from Setup and cycle Type Locke OFF/MONO/DUO (plus a type lane if practical). The warning should stay entirely inside its border and Type Locke changes should complete without the “Please report this text” dialog.

**Route Forgiveness** now appears under **GENERAL**. This is menu organization only; token rewards/spending are unchanged.

A genuinely fresh/new profile now starts **Shiny Clause at OFF / 0**. This does not rewrite an existing save or an explicitly saved setup profile.

### 2.5.9 Yellow setup re-test
Yellow 2.5.8 runtime confirms **Shiny Clause = OFF / 0** on a fresh profile and confirms Type Locke can be edited in NUZ RULES. Saving Setup then exposed a separate scope bug in the Type Locke slot index. 2.5.9 repairs the setup/profile lookup and should be re-tested by selecting a Type Locke mode/types, saving Setup, starting the game, and confirming those selections persisted.

The loadout warning no longer hides undisplayed changes behind `+N MORE`. Use **UP/DOWN** to review every affected loadout-owned rule, **LEFT/RIGHT** to choose APPLY/CANCEL, **A** to confirm that choice, and **B** to cancel without changes.

Nuzlocke-owned setup/rules/status error messages now stop on explicit two-line pages. Press **A/B** to advance each error page manually so the complete diagnostic can be photographed or transcribed.

Section order places **GAME DIFFICULTY**, then **BATTLE MECHANICS**, immediately above **AREA SPLITS**.

## 2.4.78 Type Locke sizes and Catch Draft
Type Locke now ranges from MONO through HEXA: Monolocke (1), Duolocke (2), Trilocke (3), Quadlocke (4), Pentalocke (5), and Hexalocke (6).

With **Catch Draft OFF**, choose Type 1 through the number required by the mode. RANDOM resolves once into a concrete type and persists.

With **Catch Draft ON**, Type selectors are hidden. Opening catches are unrestricted while they fill the selected number of lanes from their actual runtime types. Each catch contributes one lane, preferring a not-yet-drafted type if a dual-type catch offers one. Gifts and trades do not fill lanes. The final drafted lane immediately activates normal Type Locke enforcement.

Turning Catch Draft ON during a run clears current manual lanes and begins a fresh draft. Lowering the mode trims higher lanes; raising it keeps drafted lanes and waits for additional catches.

## 2.4.77 external-mod compatibility note
2.4.77 does not add new gameplay rules. It consolidates the completed external-mod audit wave and shrinks the future audit queue. Source/static/expected classifications are not runtime certifications; when a companion mod is marked TEST REQUIRED, use the relevant Nuzlocke rule in a small throwaway/runtime test before relying on that combination for a run.

## Quick Start runtime note
R/B/Y Quick Nuzlocke Start has user runtime PASS evidence. It can hand control back outside the Pallet house before bedroom-PC items are collected. If you wanted those items, simply walk back inside and use the PC; the shortcut does not make them inaccessible.

## Indigo Plateau Conference
With IPC 1.1.0, tournament losses are CANLOSE eliminations rather than ordinary blackouts. IPC may heal surviving party members after the battle. Nuzlocke's Permadeath marker remains authoritative: a Pokemon already lost under Permadeath is removed again after external post-battle healing.

## Kanto Reforged level caps
Kanto Reforged 1.2.0 can enable its own permanent soft-cap system after you accept its Rare Candy stack. If your Nuzlocke Level Cap Scope is also active, Nuzlocke uses the stricter live cap from the two systems. Turning Nuzlocke Level Caps OFF does not turn KR's cap off.

## Engine compatibility policy
The supported manifest range remains `>=0.1.86 <2.0.0`. Compatibility audits can advance within that range without changing the maximum unless the project owner explicitly directs otherwise.

## Gen1Recomp 0.2.0
2.4.71 is the compatibility-audited child for Gen1Recomp 0.2.0. No player-facing rule changes are introduced by this compatibility pass. If you are testing this build, use Gen1Recomp 0.2.0 and report any boot, menu, save/load, battle, catch, or Gold-specific regression separately from ordinary rule behavior.

## 2.4.70 post-release note
2.4.69 was published as the full release. 2.4.70 is its strict post-release hardening child. Existing saves remain on Save Schema 4. If testing a downgrade from a future build, use a copy of the save; a newer Nuzlocke schema should pause enforcement and refuse Nuzlocke-owned persistent writes.

Deferred Starting Balls and Skip Catch Tutorial are also suspended while a newer-schema save is paused, so story/world-step shortcuts cannot mutate or advance unsupported state.

## Dev Mode Randomizer integrity
The Dev export now includes `[RANDOMIZER INTEGRITY]`. `PASS` means every scanned Nuzlocke-owned randomized encounter slot satisfies the current candidate legality. `WARN` includes exact slot paths/species/reasons. `DELEGATED` means another mod owns encounter randomization, so Nuzlocke does not judge its tables. `FALLBACK` means the active rule set produced zero legal randomized species, so the intentional 2.4.62 behavior retained/restored vanilla encounters rather than forcing an illegal candidate.

## Dev Mode rule effectiveness
The Dev export now includes `[RULE EFFECTIVENESS]`. Each row shows `configured`, its source, `effective`, `owner`, and `relationship`. A configured value that differs from the effective value is not automatically a bug: external delegation or normalization may intentionally neutralize/change it. Check the owner/relationship column first.

## Dev Mode future-schema write detector
For downgrade testing, enable Dev Mode, reset `nuzlocke_dev.reset_safe_stop_writes()`, then load/use a copied save whose Nuzlocke schema is newer than this build supports. The exported `[SAFE STOP WRITES]` section should ideally remain at `attempts=0`. Any nonzero value identifies an unguarded writer; in 2.4.70 that escaped `mod.save:set(...)` attempt is also blocked before persistence.

## Dev Mode lifecycle counters
The Dev export now includes `[LIFECYCLE]` with counts for ready/load/battle/catch/evolution events. `duplicate_callbacks` means the exact same event payload reached the diagnostic callback more than once. For reload testing, call `nuzlocke_dev.reset_lifecycle()` before the controlled test when possible, trigger known events after the reload, and inspect duplicate delivery. Pre-reload totals are not guaranteed to persist across a full main-chunk reload.

## Dev Mode hook health
The Dev self-test export includes `[HOOK HEALTH]`. `HEALTHY` is directly verified ownership, `CHAINED` means another live wrapper sits above or replaced the visible top-level function, `MISSING` means an expected marker is absent on an already-loaded module, and `PENDING` means the module has not loaded yet. `CHAINED` is evidence to inspect, not automatically a bug.

## Newer-save protection
If this older build opens a save written by a future Nuzlocke save schema, it displays **NUZLOCKE PAUSED** and suspends Nuzlocke enforcement/save repairs for that save. Return to the newer Nuzlocke build that wrote the save rather than continuing under the downgraded mod.

The published 2.4.69 release preserves the frozen 2.4.68 gameplay/rule surface and includes the accumulated passive Dev Mode diagnostics from the 2.4.59–2.4.68 development line.

## 2.4.62 Random Encounter rule interaction
Random Encounters now build their species pool from species that are legal under the active Nuzlocke acquisition rules. Type Locke, No Legendaries, No Mythicals, No Pseudos, and Maximum BST therefore constrain Nuzlocke-owned randomized wild tables before Similar BST / evolution-stage balancing is applied. If no legal random species remain, the mod fails safely to vanilla encounter data instead of forcing an illegal candidate. Changing Type Locke, its selected types, Maximum BST, or the Legendary/Mythical/Pseudo bans mid-run reapplies Nuzlocke-owned encounter tables immediately.

## Rules/Setup navigation
- UP/DOWN wraps top ↔ bottom.
- SELECT+UP/DOWN jumps section headers with wraparound.
- A or LEFT/RIGHT collapses/expands one header.
- SELECT+LEFT collapses all sections.
- SELECT+RIGHT expands all sections.
- Numeric editing keeps its own controls.

## Current historical Difficulty profiles
- Red: SHIN HARD*, PURE RGB*
- Blue: SHIN HARD*, BLUE KAIZO*
- Yellow: YELLOW LEGACY*, SHIN-STYLE*
- Gold: POLISHED*, LEGACY-STYLE*

These profiles can improve live trainer teams, boss pressure, legal movesets, AI, trainer Stat EXP, DVs, BST pressure, and Gold held items. `*` means inspired behavior, not copied trainer tables.

## No Held Items — Gold only
Default OFF. GIVE is blocked, TAKE remains allowed, existing player-held effects are suppressed while ON, and enemy/trainer held items are unaffected. R/B/Y omits this rule.

## Dev Mode
Default OFF and diagnostics-only. In 2.4.60, recoverable NUZ RULES/SETUP and NUZ STATUS runtime crashes also retain their full traceback in the Dev breadcrumb/snapshot history before the on-screen message is shortened. Current DEV TOOLS uses Gen1Recomp 0.2.x `mod.storage`; no host path is promised. In 2.4.59, selected storage/save-upgrade/compat/provider exceptions automatically enter the Dev breadcrumb and snapshot trail. Read-only assertions also flag contradictory encounter ledgers and malformed Shiny state. These diagnostics do not change gameplay decisions.

## Current unfinished backlog
Contained/medium:
- EXP Share Ban
- RNG Escape Mercy
- Force native Set Mode
- Safari Clause
- potential No Auto-Heal
- potential modern-provider No EV Gain

Potential Rules/Setup UI:
- sticky section header
- visible-position indicator
- native offscreen scroll indicators
- changed-value marker
- collapsed-section summaries

Larger:
- expand Item Randomization beyond visible item balls (hidden items / NPC gifts / shops as separately scoped options after safety review)
- Egglocke
- Town Map Nuzlocke Log / overlay
- fuller Encounter HUD
- End/Abandon Run statistics
- multi-provider difficulty composition
- Split-Evolution Dupes behavior
- localization validation
- Gen1+Gen2 cross-generation expansion, then Hoenn investigation
- more behavior-level automated tests

Wonderlocke and Permanent Rule Seal remain WIP/disabled.

## Dev history
RUN + SAVE keeps `latest` and up to 16 sequenced reports for the active playthrough. Each report contains the full current 48-breadcrumb ring.

## Translations
Nuzlocke follows Gen1Recomp's translation/fallback path for player-facing text where supported. In 2.4.80, Nuzlocke's own shared text wrapping was hardened for translated glyphs and accented/multibyte text.

### Brazilian Portuguese
`gen1_pt-br` v0.1.5 is recognized as an optional translation companion as of 2.4.82. Translation fallback and accented glyph-safe wrapping are supported, but Trainer Card, battle UI, Yellow flow and long translated labels remain runtime TEST REQUIRED.

### Encounter Ball Limit
Choose OFF, 1, 2, 3, 5, or 10 legal Ball throws per catchable encounter. OFF is unlimited and is the default. A/LEFT/RIGHT cycles the setting. Only legal attempted throws count; a Ball rejected by No Catching or another absolute capture restriction does not spend the budget. Once the budget is exhausted, further Ball use is refused without consuming the Ball. A new encounter receives a fresh budget.

### General section ordering
Party Size Limit and Gym Team Size are placed at the bottom of IRONMON. On Yellow, holding SELECT pages between section headers, while SELECT + LEFT/RIGHT opens or closes all section headers; both behaviors are runtime-confirmed.

### Cap Messages
Choose ALWAYS, BATTLE, or CAP with A/LEFT/RIGHT. BATTLE is the default and allows at most one blocked-EXP level-cap popup per battle. CAP allows one message for each distinct active cap until it changes; ALWAYS reports every blocked EXP transaction. This setting affects notification frequency only.

### Yellow Skip Catch Tutorial
Skips Oak's pre-lab Pikachu demonstration while preserving surrounding story progression, plus the later Viridian Old Man demonstration.

### Dev Report layout
On R/B/Y, long Dev Report rows wrap inside the native 160x144 screen and can be scrolled rather than being clipped or drawn beyond the frame.

### Diagnostic screen wrapping
Dev Report and Storage Info wrap long diagnostic rows inside the native viewport. UP/DOWN scrolling includes wrapped continuation rows, so long paths, history keys, capability names, and status fields remain readable without drawing outside the frame.

### Dev Report Code
Open **DEV TOOLS → VIEW REPORT** to generate a fresh live report. The second report line is `report_code=NZR1-...`; you can send that code with the game/build when reporting a problem. A/LEFT/RIGHT refreshes the live report and code.

The code losslessly carries the fixed diagnostic summary (PASS/WARN result bits, schema, core settings, hook/lifecycle/safe-stop/rule/randomizer counters). Free-form strings such as provider names, detailed hook text, rule rows and breadcrumbs are represented by fingerprints because arbitrary text cannot fit reversibly in a short seed-style code. Use **RUN + SAVE** only when a developer specifically needs those exact free-form strings.

### No Mom Heal
When ON, Mom must refuse to heal the party; when OFF, vanilla healing remains available. 2.4.94 adds lifecycle repair for stale command bindings and a `mom_heal_gate` Dev Report check. On R/B/Y, a healthy report should show this row as PASS.

### Field-item rejection messages
When a field item is blocked by a Nuzlocke rule, the rejection message pauses in normal dialogue pages instead of scrolling away automatically. Each page uses the native narrow dialogue width and at most two lines; press A to continue. Battle-item messages keep their normal battle presentation.

### Random Starter encounter location
The Pokemon you actually accept from Oak counts as the Pallet Town starter encounter regardless of what species Random Starter chose. Tracker and map use the committed accepted starter, not the vanilla starter species list.

### Legacy mod ID compatibility
For older mods that do not publish Nuzlocke capability metadata, automatic compatibility hints now accept both separated and compact multi-word IDs (for example `CATCH_HELPER` and `CATCHHELPER`).

### Shiny Clause and Encounter Ball Limit
These are numeric selectors, not booleans. 2.4.98 fixes an edit-path bug that could save either selector as OFF regardless of the value chosen. If an affected older build already stored a boolean artifact, the migration restores a safe canonical numeric value; reselect the desired mode if necessary.

### Encounter Ball Limit persistence
2.4.99 completes the numeric configuration path for Encounter Ball Limit. The Rules screen can now read back and display the saved selector value correctly after leaving and reopening the menu.

### Randomizer Info Policy display
OPEN INFO and BLIND INFO now round-trip correctly through the Rules UI. The underlying gameplay behavior was already using the stored numeric setting; 2.4.100 fixes the menu readback so the displayed mode matches the enforced mode.

### 2.5.2 Dev diagnostic note
Dev Mode now reports a warning if `randomizer_info_policy` is ever found in an impossible boolean or malformed numeric storage shape. It does not rewrite the value because no historical boolean encoding exists for this selector.

### Ball Per Enc.
**Ball Per Enc.** is in **BATTLE ITEMS** beside **No Catching** in R/B/Y and, as of 2.5.29, Gold. It is hidden while No Catching is ON because Ball-throw budgeting has no active purpose when all catching is prohibited. When catching is allowed, choose OFF / 1 / 2 / 3 / 5 / 10. OFF is the vanilla default. A previously selected value is preserved while the row is hidden.

### Solo runs
There is no separate Solo Only rule anymore. Set **Party Size Limit** to **1**, or choose the SOLO loadout. The same party-limit system now governs catches, gifts, trades, and PC withdrawals consistently.

### Level-cap messages
Cap message frequency is no longer configurable. The mod shows one message per battle, at the first EXP award that is actually blocked or banked by the active cap.

### World Building default
New configurations default to **T1**. Existing saves keep their selected World Building tier.

### 2.5.5 Blue validation note
For a randomized Blue starter, Nickname Rule should force a non-default nickname and the received Pokémon should immediately appear as the Pallet Town starter encounter. If First Rival Mercy is ON, losing the Oak's Lab Rival battle should continue the native lab story after healing; it must not restart the opening sequence or offer another starter.

### 2.5.7 Dev Report layout re-test note
On R/B/Y, verify VIEW REPORT and STORAGE INFO after 2.5.7: every line should stay inside the bordered 160px surface, the full NZR4 code should be readable by joining the displayed hyphen-grouped lines, long playthrough/storage identifiers should wrap rather than clip, and UP/DOWN scrolling should still reach the final rows. This is presentation-only; the NZR4 code format itself remains v4.

The 2.5.6 saved-report View Report crash repair has Blue runtime PASS evidence across a full game restart. The shared ordinary NUZ RULES edit repair still needs runtime confirmation. Yellow 2.5.7 additionally exposed a Type Locke-specific edit error and loadout-warning layout failure; 2.5.8 contains static repairs for both and requires runtime confirmation.

### 2.5.6 Blue UI/Dev status
2.5.5 runtime testing found that changing multiple NUZ RULES could error in the shared post-write update path, and DEV TOOLS -> VIEW REPORT could crash. 2.5.6 contains targeted repairs for both. VIEW REPORT now has Blue runtime PASS evidence for reopening a saved report after a full game restart; ordinary LEFT/RIGHT/A NUZ RULES edits still need runtime confirmation. MOD COMPAT rule-name rows on the left are intentionally normal weight rather than pseudo-bold.

## 2.5.68 NUZ STATUS

**NUZ STATUS** is the live challenge card. It shows current run metrics and active challenge rules, not NEW GAME setup bookkeeping. Starting Money/Balls/Candy, PC starting kits, Gym Guide Rare Candy service state, UI-only controls, and the redundant master-ON row are intentionally omitted. Type Locke is summarized as one mode/type row rather than exposing internal `Type 1..6` slots. A non-vanilla Difficulty profile is shown by name; vanilla Difficulty and neutral Trainer Money 100% are omitted. Loadout names use the same player-facing format in Red, Blue, Yellow, Gold, and Silver. Use **NUZ RULES/Setup** when you need to review configuration choices that are intentionally not part of the live challenge card.

## 2.5.66 runtime notes
Silver is beta/test-required. Setup and boot to the bedroom have runtime-passed; NUZ STATUS must be retested on 2.5.66. If the Gen 2 status surface encounters an unexpected edition/provider shape, it now shows a reportable in-screen error instead of terminating the launcher. Yellow manual recovery reassignment also requires retest, especially Mankey → Route 1 → wild.
