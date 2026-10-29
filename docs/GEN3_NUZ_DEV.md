# NUZ DEV — Gen 3 testing tools

`NUZ DEV` is a **hidden developer-only test screen** in the Gen 3 Nuzlocke menu. It is not listed in the ordinary production menu; unlocking it is not a security boundary, because the sequence is visible in source.
It is intended for precisely the situation where a test permanently consumes
the route you need for the next test.

## Open it

1. Import the latest `feature/gen3-foundation` branch into Gen1Recomp.
2. Start a disposable FireRed/LeafGreen/Hoenn save.
3. Open **Start → NUZ MENU**, **hold SELECT and tap A**. On default keyboard bindings this is **Tab + Enter** (or Tab + Z); on a controller use **Select/Back + A**. This is the recommended shortcut.
   Alternatively, press **Up, Up, Down, Down, Left, Right, Left, Right**, with each repeated direction **released and pressed again**. Holding a direction for cursor repeat does not count as two presses.
4. On **DEV ACCESS**, select **OPEN DEV TOOLS**. Unlocking access is session-only and does **not** itself alter the save.
5. Choose **ENABLE DEV MODE**, confirm **YES: ENABLE**. This permanently marks the test save `dev.tainted=true`. Turning DEV back OFF does **not** remove that marker. Reopening a session requires the sequence again.

This unlock uses directional controls supported by both keyboards and controllers. Pressing it from any submenu or new-run setup does nothing. The normal menu never gains a visible developer row.

Only the mod's own UI can call the editing methods; other mods get a
**read-only** `mod.exports.gen3_dev_info.snapshot()` and `.status()`.

## Quick example — reuse the route you just tested

- Enable **NUZLOCKE ON**, **ONE PER AREA ON**, **FAILED ENCOUNTERS ON**.
- Knock out the first wild Pokémon; the area's catch slot is now consumed.
- In NUZ DEV choose **RE-ARM CURRENT → YES: RE-ARM**.
- In CORE, change **FAILED ENCOUNTERS OFF**.
- Fight the next wild Pokémon on the **same map**. It should now be catchable;
  another failed attempt should leave the slot open.
- After a successful catch, the subsequent wild Pokémon should be denied.
- You can repeat **RE-ARM CURRENT** to test again without switching routes.

**Re-arming changes only Nuzlocke's encounter record.** It does not remove
already caught Pokémon from the party/PC, roll back the Pokédex, restore
spent Balls, reverse deaths or rewind story flags. It is a deliberate
debug override, not a clean replay of the earlier game state.

## Available menu entries

| NUZ DEV option | What it does |
| --- | --- |
| **RE-ARM CURRENT** | Shortcut to set current native map to `spent=false, caught=false`, while retaining its attempt counter |
| **EDIT CURRENT AREA** | Opens the full editor for the map under the player's feet |
| **EDIT ALL AREAS** | Browse any previously recorded native map ID and open the same editor; entries are marked **C** caught, **X** spent or **O** open |
| **CLEAR ALL AREAS** | Deletes **all Nuzlocke encounter entries** (does not touch Pokémon) |
| **STATE INSPECTOR** | Shows current map, party count, area totals, graveyard deaths, lost status and developer-edit count |
| **RULE INSPECTOR** | Displays the eight CORE rule IDs, effective boolean settings and implementation statuses |
| **PRINT DEBUG REPORT** | Writes a compact map/rule/run/area summary into the running game's console, prefixed `[NUZ DEV]` |
| **RESET CLAUSE COUNTS** | Resets Shiny Clause exception usage, captured-species history and roamer claims; party/PC Pokémon and legacy graveyard evidence remain unchanged |
| **ADD TEST TOKEN** | Grants one Route Forgiveness token after confirmation; requires DEV mode and permanently flags the test run |
| **CLEAR GRAVEYARD** | Clears Nuzlocke memorial entries **without restoring permanently removed Pokémon** |
| **CLEAR RUN FAILURE** | Resets Nuzlocke's lost flag **only if a living, non-Egg party Pokémon remains**; does not revive or recreate anything |
| **DISABLE DEV MODE** | Locks all editing operations again; the test-save taint remains recorded |
| **RESTORE FROM GRAVE** | Recreates one archived individual only when the full original snapshot is available, after confirmation, at half maximum HP; inserts into an open party slot or, when full, a verified empty PC box slot. Duplicate individuals, corrupt/partial archives, full storage, battles and permanently ended runs are rejected. Removes that Pokémon's memorial entry and records the edit. |

### Per-area editor

Choose an area, then:

| Action | Nuzlocke result |
| --- | --- |
| **MARK OPEN** | `spent=false`, `caught=false`: next eligible encounter allowed |
| **MARK SPENT** | `spent=true`, `caught=false`: route is used without a capture |
| **MARK CAUGHT** | `spent=true`, `caught=true`: route is counted as captured |
| **CLEAR ENTRY** | Deletes this one area entry: back to a completely unvisited area |

All mutations use an explicit **CONFIRM EDIT** page, are refused during
an active battle, and are logged in a bounded save-local audit list
(`dev.history`, most recent 20 edit actions).

## Precautions and limitations

- **Always back up a disposable save.** The archive restoration tool can recreate a Pokémon from its full recorded individual data, but other edits and inventory changes cannot automatically be undone.
- An individual is restored at half HP with the original identity, moves, stats and shiny identity. No legacy species/level-only record can be restored. Restoring removes the corresponding memorial entry to prevent repeated creation.
- Restoring requires existing and inspectable native PC storage, even if the party has room; otherwise duplicate protection cannot be guaranteed. The tool never silently generates a new PC storage structure.
- Changes to the Nuzlocke state survive game restart **after a normal game
  save**. If you reload without saving, you may restore an older state.
- A graveyard clear affects records only and irrevocably discards any stored recovery snapshots. Use **RESTORE FROM GRAVE** first if you intend to recover an archived individual.
- DEV restoration is separate from the currently unimplemented ordinary Route Forgiveness revival option. It never spends forgiveness tokens or makes permadeath legal in an ordinary run.
- Clearing the failed-run flag when the party is empty or only fainted/eggs is
  rejected, because there's no safe way for Nuzlocke to recreate a party.
- The current area uses a **native map ID**, not a unified in-game route name.
- DEV edits cannot occur mid-battle; battle lifecycle references must remain
  stable for forced switching and party writeback.
- DEV Mode is a *per-run testing tool*. This does not enable unimplemented
  [Soon] clauses or remove rule configuration gates.
- The original Gen 1/2 Nuzlocke code is untouched.

## Automated verification

```bash
lua5.1 tests/gen3_foundation_smoke.lua
```

The smoke tests cover: menu opt-in/cancel; quick re-arm; marking individual
areas open/spent/caught/clear; attempted edit inside battle; confirmation
cancellation; clear-all; debug report; graveyard clearing; rejecting a
failed-run reset without a living Pokémon; hidden access/cancellation and enabling/disabling developer mode; persistence of the permanent test-run marker.
`tests/gen3_dev_restore_smoke.lua` additionally checks full-archive restoration, normal/PC placement, duplicate prevention, no-space and malformed storage refusal, battle gating and terminal-run integrity.

This verifies mocked hooks and state mutations, not the actual onscreen Gen 3
menu. A real FireRed in-game test is still required.
