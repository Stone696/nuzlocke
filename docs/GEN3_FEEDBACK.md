# Gen 3 — player feedback and Rare Candy regression

The player's immediate actions should explain *why* a Nuzlocke rule affected
them. Battle notices use the native Gen 3 battle dialogue queue. Events are
also saved to the latest **100 RUN JOURNAL events** (Start > NUZ MENU > RUN JOURNAL > EVENT HISTORY).
Long descriptions are split into readable GBA-sized rows.

The notice history is stored under `gen3_classic_v1.notices` and does not
change any old Gen 1 / Gen 2 saves. Selecting a notice shows its full text.

## Feedback added

| Action | Feedback |
|---|---|
| First eligible wild encounter | Clearly announces the first opportunity; warns that fleeing/fainting uses the chance if Failed Encounters is ON |
| Blocked Poke Ball | One Per Area (including route name), Dupes Clause, claimed Roamer slot or Shiny Nuzlocke denying a non-shiny |
| Successful area catch | Records that the area's encounter slot has been used |
| Successful Shiny Clause exception | States that the extra encounter was allowed |
| Captured roamer | Explains the species-specific roamer slot |
| EXP at level cap | Shows how much EXP was banked, or lost when edging is OFF |
| Banked EXP released | States how much saved EXP is paid out on the next native award |
| Rare Candy at level cap | Item refuses use with a reason before consumption |
| Permadeath | Identifies the fainted Pokémon and its Graveyard entry |
| First Rival Mercy | Explains why that opening rival fight exempts faint deaths |
| Whiteout/run failed | Adds run-ending notice |
| PC survivor rescue | Explains why a boxed Pokémon was moved into the team |
| Egg Encounter, nicknames | Reports hatch status or pending naming tasks |
| Forgiveness tokens | Reports earned badges/tokens and route redemption |
| Level cap progression | Logs the newly active Gym/League cap when progression advances |

Game3 battle notices are queued instead of forcing an immediate overworld
textbox, which could overwrite scripted dialogue, or native battle
animations. Overworld outcomes are always in the Notice history. Item use
errors use the native field menu's existing error-text return contract.

## Why Rare Candy was getting through

The normal bag's party-target screen goes through
`src.ui.game3.party_menu`. In its `mode == "use"` level-item branch,
the native code **directly removes the item and increments the Pokémon's
level**, bypassing both `ItemUse.useRareCandy` and the `item.use` mod hook.
That is why the earlier guards and mocks passed while Rare Candy remained
usable in a real game.

The new guard intercepts the party menu's confirm input **before** that
branch can run, shows a readable level-cap explanation and returns to item
selection without consuming anything. The previous `item.use` and
`ItemUse.useRareCandy` guards remain for other callers.

Capture Nickname Requirement also previously depended on being able to load
the native naming module during `battle.started`; a failed early require
meant the Yes/No prompt was never guarded. Now the prompt guard is installed
independently and automatically chooses the native name-entry path whenever
the rule is active. Naming validation is applied as soon as the native
name-entry module is available, including at the capture prompt itself.

## Disposable-ROM testing checklist

- [ ] **F01:** FireRed, GYMS cap 14; use Rare Candy on Lv14 Pokémon.
      It **must not become Lv15**, consume Candy or play a success animation.
      It should explain the cap.
- [ ] **F02:** Use the same item at Lv13. It should work normally and consume
      one Candy, as before.
- [ ] **F03:** Repeat F01–F02 with an RSE edition and with any level-up Enigma
      Berry effect supported by that ROM.
- [ ] **F04:** Throw a ball after an area was spent; see the One Per Area
      reason in *battle dialogue* and in RUN JOURNAL > EVENT HISTORY (ordinary failed catch
      randomness should remain normal).
- [ ] **F05:** Repeat F04 with Dupes and claimed Roamer clauses, checking
      the correct reason (and Shiny Clause override, if enabled).
- [ ] **F06:** At Lv14 cap, battle with EXP Edging ON. Read the banked EXP
      message. Turn edging OFF and confirm EXP-loss wording; repeat after
      gaining Boulder Badge and confirm the stored EXP release message.
- [ ] **F07:** Let a party Pokémon faint: permadeath notice and Graveyard
      entry; opening rival exemption should show mercy instead.
- [ ] **F08:** Complete a badge and a League battle: watch cap stage change;
      RUN JOURNAL > EVENT HISTORY should preserve both updates.
- [ ] **F09:** Claim a Route Forgiveness token, hatch an Egg, and leave an
      unnamed Pokémon in PC. Each event should be traceable through notices.
- [ ] **F10:** Whiteout / PC rescue on a disposable save. Confirm the correct
      outcome notification and that native party/PC data is consistent.
- [ ] **F11:** Open RUN JOURNAL > EVENT HISTORY, inspect several long messages, and verify
      text is *fully readable* instead of cut off.

CI smoke tests cover the field item-hook cancellation and battle notice
contracts, but **real-ROM testing is still necessary**, especially for native
bag messages, battle animation timing and RSE item differences.

## Follow-up real-game checks

- [ ] **F12:** With first Gym Lv14 cap, select a Rare Candy from the BAG and
      choose a Lv14 Pokémon in the *party selection screen*. No item is spent,
      no success animation or level change occurs, and the party screen gives
      the cap reason. Repeat after leaving/re-entering the map and loading a save.
- [ ] **F13:** Below cap (e.g. Lv13), the *same* BAG → Party Menu sequence
      permits one level, consuming exactly one Candy.
- [ ] **F14:** Catch a new Pokémon with Nickname Rule ON. The game must go
      directly to the native naming screen; there must be no way to select
      NO and skip it.
- [ ] **F15:** Attempt the Pokémon's unchanged species name or a blank
      nickname. The native name-entry screen must reopen. A valid custom name
      allows the capture to finish.
- [ ] **F16:** Confirm the first eligible route encounter says
      "First encounter" / "your chance", not "Failed Encounters" as though
      the capture had already failed.

**Shiny Nuzlocke:** A non-shiny Ball attempt is rejected with an explicit
reason in the native battle dialogue and saved in RUN JOURNAL > EVENT HISTORY. The area
remains available. Eligible shiny encounters follow One Per Area and
Failed Encounters as described in [PLAYSTYLES](GEN3_PLAYSTYLES.md).
