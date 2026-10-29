# Gen 3 Nuzlocke — Hardcore Rules

**Version:** v3.0.0-BETA  
**Menu:** NUZ MENU → NUZ RULES → HARDCORE  
**Persistence:** `gen3_classic_v1.hardcoreRules`  
**Default:** all five toggles OFF. All require CORE Nuzlocke ON.

This category is **separate from the Hardcore Nuzlocke playstyle**.
The playstyle continues to force its established Core, Set Mode,
level-cap and item rules. These five Hardcore toggles can be
configured independently and remain in the save when Core is OFF.

## 1. No Escape

Ordinary wild Pokémon battles refuse RUN and the attempt still
consumes the player's turn. This uses the native
`Engine.tryFlee` boundary *before* Run Away, Smoke Ball and
speed-based checks, so those effects cannot bypass the rule.
Training/tutorial, link, Safari and scripted opening battles remain
native. Wild Pokémon may still run away themselves. This rule
does not alter trapping, catching or encounter eligibility.

## 2. Whiteout

A full-party blackout ends the run **unless a usable survivor
already exists in the party or PC**.

With ON:
- Fainted Pokémon are archived/removed by the existing permadeath
  policy before assessing the survivors.
- Eligible PC Pokémon must be alive, not Eggs/Bad Eggs, not recorded
  dead in the graveyard, and not progression/PC-locked.
- If the party has no usable member, **one existing living PC
  Pokémon is moved** into the party (not duplicated or revived).
  An Egg-only party can receive that resident beside its Eggs.
- If nobody eligible survives, the run is marked failed.
- First Rival Mercy still takes priority over whiteout failure
  in its existing opening-battle exemption.

With OFF: existing `CORE → Whiteout Ends Run` and
`PC Survivors` behaviour remains authoritative. The new toggle
does not erase existing graveyard entries or modify a save's
historical loss results.

**Important:** The Gen 3 mod currently records an ended run and
disables Nuzlocke gameplay via its `failed` state. It does **not**
delete the underlying game-save file merely because this setting
is enabled. This is safer than claiming the legacy Gen 1/2
save-deletion behaviour has been reproduced.

## 3. Gym Lock-In

While ON, entering an uncompleted recognised Gym prevents ordinary
door/stair exits until its badge has been earned.

The policy identifies supported Gym map IDs and consults the
game's real edition-specific `Flags.badgeInfo` and `getFlag`
data. Already-cleared Gyms are always allowed to exit.
Unknown map names, unavailable badge tables and missing script
state **fail open** rather than trapping the player.

**Interaction with Gym Team Size:** If that separate rule is ON,
Gym Lock-In currently **fails open**. Gym Team Size can require
leaving a Gym to deposit Pokémon before a leader will battle;
blocking the exit at the same time would be a softlock. This is
a deliberate safety exception, not a forgotten feature. A future
enhancement could allow precise exceptions only when the current
party exceeds that Leader's composed roster size.

This restriction never changes badge ownership, gym leader
trainer defeat flags or story scripting.

## 4. Dungeon Lock-In

This rule tracks the particular entrance used when walking from
outside into a **recognised multi-exit dungeon**:

- Mt. Moon
- Rock Tunnel
- Seafoam Islands
- Victory Road (FRLG and RSE)

It prevents the player from returning through the recorded entrance
portal. It does **not** seal all exits to the same outside map.
A different exit can still be used to finish the dungeon.

The entry record contains the outside map, inside arrival map
and coordinates. Return attempts are checked on native
door/stair/teleporter transition functions **before** the
transition is started. Because an arrival can step off the landing
tile, the first implementation uses a small ±1-tile proximity
window at that exact entrance location. It does not claim
pixel-perfect correspondence in every ROM. This must be tested
at real cave entrances and exits, especially when two portals
are adjacent.

While an active entrance record applies, using Escape Rope,
Dig, Teleport or Fly from the party/field menu is denied
before it starts the escape. Natural cave movement and other
legitimate exits remain available.

No fabricated region labels are used to guess a missing entry.
If the entrance coordinates, origin map, or map identity are
unknown, no lock is applied. The record is transient and
cleared on save-load/creation or after leaving the dungeon;
a player loading a save while already inside has no invented
entrance restriction. Changing Hardcore off also disables
its effects without rewriting game maps.

**RSE/FRLG verification required:** Caves with hidden portal
animations, connection-based exits or custom Untamed map movement
can use paths not represented by these native transition
functions. The rule does not promise those have all been covered.

## 5. No Held Items

The player cannot equip new held items. Native
`ItemUse.giveToMon`, `giveHeld` and `switchHeld` are denied
before the mutation and item transfer. Existing items stay
physically attached so they can still be **TAKEN** back into
the Bag; no inventory items are deleted.

The native `HeldItems.of` battle path suppresses item effects
for player-side battlers, while leaving trainer-side held items
untouched. Held-item bonuses are not merely hidden from the
summary screen: their effect lookup returns no effect. Other
mods that bypass native HeldItems paths may need additional
compatibility checks.

## In-game test checklist

1. **HC01 — Defaults:** All five OFF; Core OFF suppresses them,
   and toggles persist after reloading.
2. **HC02 — Escape:** In ordinary wild battles, RUN spends a turn
   but fails, including with Run Away and Smoke Ball. Safari and
   tutorials retain native behaviour.
3. **HC03 — Whiteout:** Black out with no eligible PC survivors:
   run fails and all deaths remain archived.
4. **HC04 — Rescue:** Black out with an eligible PC survivor:
   one is moved to party without restoring dead party Pokémon.
   Repeat with an Egg-only party.
5. **HC05 — Survivor exclusions:** Dead, Egg/Bad Egg and
   progression-locked PC Pokémon cannot rescue a whiteout.
6. **HC06 — Gym doors:** Test an uncleared Gym's normal exit.
   After earning its badge, confirm the exit works. Return
   to an already-cleared Gym and confirm free exit.
7. **HC07 — Gym Team Size:** With both rules ON, Gym Lock-In
   fails open, permitting a trip to the PC if the team is too large.
8. **HC08 — Dungeon portals:** Enter Mt. Moon from Route 3,
   test that entrance is blocked, and that the Route 4 exit works.
   Repeat Rock Tunnel, Seafoam Islands and Victory Road.
9. **HC09 — Dungeon travel:** Test Escape Rope, Dig, Teleport,
   Fly, menu toggles, saving/loading midway, and returning
   through alternative entrances/exits to the same map.
10. **HC10 — Held Items:** Existing held items stay attached
    but have no battle effects; taking them works. Newly
    giving/switching them is denied without Bag mutations.
11. **HC11 — Trainer equipment:** Opponent held item triggers
    remain normal, including in double battles.
12. **HC12 — Editions/mods:** Repeat representative paths
    in FireRed, LeafGreen, Ruby, Sapphire and Emerald,
    including randomised trainers and Untamed overworld battles.

Automated policy/UI tests cover value validation, map groups,
badge flags, whiteout rescue, route/source identity and native
entry-point wiring. Manual ROM-level tests are still required
for actual warp behaviour and cross-mod compatibility.
