# Gen 3 Nuzlocke — QOL Setup Only

**Version:** v3.0.0-BETA  
**Menu:** NEW GAME → NEW RUN SETUP → QOL SETUP ONLY (also shown in NUZ RULES)  
**Policy file:** \`gen3_qol_setup.lua\`  
**Save settings:** \`gen3_classic_v1.setupRules\`  
**Native apply point:** \`save.new_game\` in Gen1Recomp's
\`src/core/game3/save_schema_firered.lua\`.

This category is intended to configure **the next fresh Gen 3
playthrough**, not retrofit an existing save. All options default to
native behaviour. The UI contains only five native-backed controls
with a final DETAILS row.

| Rule | Values | Default | Effect on the next New Game |
| --- | --- | --- | --- |
| Starting Poke Balls | 0–99; menu presets 0/5/10/25/50/99 | 0 | Adds that many Balls to the Player PC **after the native first-Ball capture unlock** |
| Starting Rare Candy | 0–99; menu presets 0/5/10/25/50/99 | 0 | Adds Rare Candies to the Player PC |
| Starting Money | NATIVE or 0–999999; menu presets | NATIVE | Overrides the new session wallet only when non-native |
| Heal Loadout | OFF / ON | OFF | Adds 10 each of nine standard healing items to the Player PC |
| PC Vitamins | OFF / ON | OFF | Adds 10 each of six Gen 3 vitamins to the Player PC |

The heal loadout covers Potion, Super Potion, Max Potion, Antidote,
Burn Heal, Ice Heal, Awakening, Parlyz Heal and Full Heal.
The six native Gen 3 vitamins are HP Up, Protein, Iron,
Carbos, Calcium and Zinc.

**Extra Poké Balls are deferred until native capture unlock.**
They are neither placed in the early Bag nor seeded into the early
Player PC. When a native Ball is first carried (or a previous valid
catch proves that happened), the additional Balls enter the Player PC.
The count survives save/reload, and retrying cannot duplicate the grant.
The player must still retrieve those extra Balls from the PC.
Pre-Ball scripted fights cannot spend the first encounter for an area.

## Atomic new-game behaviour

The code wraps the native \`save.new_game\` transaction and acts
on the newly initialised Gen 3 session, **after** its normal
starter data, Bag, PC, story flags, RNG seed, options, and metadata
have been prepared.

It stages PC contents in a new list, validates every item,
preserves the native starting Potion, checks the edition's PC item
slot capacity and maximum per-item stack amount, and commits
the whole loadout only when validation succeeds.

If the whole kit would overflow PC capacity or an item stack,
**nothing is granted, and money is not changed**. The failure
does not abort the player's new game.

A persisted \`session.modData.nuzQolSetupApplied\` marker guards
against repeat application. The transaction is *not* invoked
during \`save.loaded\`, regular map transitions, or exiting a
menu. Previously acquired items and existing PC storage are
never deleted or silently topped up.

Changing setup settings on an existing save configures a future
New Game only; it cannot retroactively award items or change
money on the currently running save. Selecting **LOCK FOR RUN**
in NEW RUN SETUP makes all Gen 3 Nuzlocke settings read-only
once the new save is created, including the five QoL setup options.

## Deliberately deferred

Opening-intro skipping, automatic player/rival name selection,
quick-start story flag changes and capture-tutorial skipping
are **not shown** in the Gen 3 Setup menu yet. The original
Gen 1/2 implementation is not a safe direct replacement for
Gen 3's separate FRLG, RS and Emerald startup scripts.
Those would need explicit edition-specific transition tests
before being called working.

The older Gen 1/2 rule catalogue is not modified.

## FRLG/RSE test checklist

1. **QS01:** Open QOL SETUP ONLY; check five rows and a DETAILS
   row, all defaults 0/NATIVE/OFF.
2. **QS02:** Select 5 Poké Balls, 10 Rare Candies, starting
   money 5000 and both optional PC kits. Start an **actual
   new game** in FireRed and verify the new wallet/PC.
3. **QS03:** Confirm the native starting Potion is retained
   (11 if Heal Loadout was enabled), no duplicated PC item
   slots, and the kit's six vitamin IDs are correct.
4. **QS04:** Reload that save; visit PC and save again.
   Confirm the kit is not re-granted.
5. **QS05:** Change setup settings while playing an existing
   save; verify that save's PC, Bag and money do not change.
6. **QS06:** Select NATIVE money and zero supplies; confirm
   the next fresh save begins with native resources.
7. **QS07:** Set extreme values through the exported API;
   verify 99 maximum Balls/Candies and 999999 wallet cap,
   while invalid inputs are rejected.
8. **QS08:** Repeat in LeafGreen, Ruby, Sapphire, Emerald.
   Pay particular attention to RSE PC item capacity,
   new-game flow and catch tutorial timing.
9. **QS09:** Confirm extra PC Balls **are not present** before
   the first native Ball, then appear once and only once after it.
   The route ledger must not advance during early scripted battles.
10. **QS10:** Confirm Nuzlocke CORE ON/OFF and Hardcore do
    not bypass or alter the native new-game resource action.

The automated smoke suite validates config defaults, title
confirmation/cancel, PC slot/stack failures, deferred native
Ball delivery, settings lock, persistence and duplicate-protection.
**In-game testing is still essential**, especially whether the
selected mod setup state remains available when the native
New Game scene initializes a brand-new save.
