# Generation 3 — Advanced Status Bans

**Version:** v3.0.0-BETA  
**Menu:** Start → NUZ MENU → NUZ RULES → ADVANCED RULES → STATUS BANS

The menu offers **eight working controls** (a parent, six individual
status bans and an independent Sleep Clause toggle). All are default OFF and require CORE → Nuzlocke Enabled.
Values persist in the existing `gen3_classic_v1` state
(`statusBans`); Gen 1/2 behaviour is unaffected.

| Rule | Values | Effect |
| --- | --- | --- |
| **No Status Moves** | OFF / SELF / ENEMY / ALL | Bulk control: synchronises all six bans below to one side scope. It is **not** a general ban on every non-damaging move. Child rows hide while the parent is active. Returning the parent to OFF clears all six; they may then be set independently. |
| Paralysis | OFF / SELF / ENEMY / ALL | Prevents paralysis, including damaging-move secondary effects. |
| Confusion | OFF / SELF / ENEMY / ALL | Prevents inflicted confusion. |
| Sleep Ban | OFF / SELF / ENEMY / ALL | Prevents sleep applied by the chosen side. Self-induced Rest sleep remains allowed. Yawn is blocked before drowsiness is scheduled; delayed Yawn retains source identity for rechecking if options change mid-turn. |
| Poison/Toxic | OFF / SELF / ENEMY / ALL | Prevents normal and bad poisoning. |
| Burn Ban | OFF / SELF / ENEMY / ALL | Prevents burns. |
| Freeze | OFF / SELF / ENEMY / ALL | Prevents freezing. |
| **Sleep Clause** | OFF / ON | Either side may inflict sleep on at most one living opposing Pokémon at a time. A sleeping party member still counts after switching out. Rest/self-induced and unknown-origin sleep do not count. Independent of the No Status Moves parent. |

**SELF** denotes Pokémon on the player's side **causing** the status.
**ENEMY** denotes the opposing side causing it. **ALL** denotes both.
This is not a distinction by which Pokémon receives the effect.

## Enforcement boundaries

- Primary status moves and damaging-move secondary statuses are
  intercepted before `Secondary.set` runs.
- The native `Adapter.new` status application path also filters
  direct status attempts from abilities and other native transactions
  when an identifiable source side is provided.
- The registered Yawn effect is stopped before `expYawnTurns` is set
  whenever Sleep Ban or Sleep Clause already prohibits it. Allowed Yawn
  attaches the source side to its pending delayed sleep; the actual sleep
  is rechecked at resolution, including when another Pokémon falls asleep
  between Yawn and its delayed application.
- Sleep Clause records successful sleep inflictions by source side in the
  **live battle state**, using party indices. Switched-out Pokémon still
  count until they wake, are cured or faint. Existing sleep with unknown
  source (including from before the current battle) is not guessed to be
  opponent-inflicted. The restriction resets with a new battle; no native
  save format changes are made.
- Rest and other truly self-induced sleep remain allowed and never consume
  the Sleep Clause slot. Unknown sources are not guessed as SELF or ENEMY.
- Banning a secondary status does **not** cancel damage, alter the
  move's PP usage or remove an existing status retroactively.
- Native Pokémon HP and status writeback remain engine-owned.
  No engine fork changes are required.

These are beta implementations. Automated tests cover native-shaped
transactions and precedence, but full FireRed / LeafGreen / Ruby /
Sapphire / Emerald ROM verification remains necessary.

## Manual ROM test checklist

1. Check all status rows default OFF. Toggle each child through
   OFF → SELF → ENEMY → ALL → OFF; verify values save and reload.
2. Set **No Status Moves = SELF**. Check the six children hide and all
   receive SELF; toggle through ENEMY, ALL and back OFF. Children return
   with OFF values and are independently editable.
3. **Paralysis:** use Thunder Wave and Body Slam/ThunderPunch effects.
   Blocking the source side should prevent paralysis while retaining
   ordinary move damage.
4. **Poison/Toxic:** try Poison Powder, Toxic and Poison Sting.
   **Burn:** try Will-O-Wisp and Flamethrower. **Freeze:** try Ice Beam.
   Secondary damage must continue even when the status is prohibited.
5. **Confusion:** test Confuse Ray and Psybeam's side effect.
6. **Sleep Ban:** try Sleep Powder, Hypnosis and Yawn. Yawn should not
   make the target drowsy when banned. Test Rest independently:
   self-inflicted sleep should remain allowed. Test source-side scopes.
7. **Ability statuses:** where possible, trigger Static, Flame Body,
   Poison Point, Effect Spore and other native status sources from
   each side. They should respect the selected ban where the source
   is correctly identified.
8. Disable CORE → NUZLOCKE. All status effects should behave
   natively while menu selections persist. Re-enable and re-test.
9. Set **Sleep Clause = ON** with individual Sleep Ban OFF. Put one foe to sleep,
   switch that sleeping foe out, and attempt to sleep another. The second
   sleep must fail. Wake/cure the first foe and verify a new sleep succeeds.
   Repeat with enemy-inflicted sleep on the player's party and with Rest.
   Check Yawn both before and after another foe has fallen asleep.
10. Confirm Sleep Clause stays editable when No Status Moves hides the six
    child bans, persists after save/reload and is inert when Nuzlocke is OFF.

Use disposable saves; passive ability and delayed status coverage needs
actual in-game testing before a ROM-edition certification claim.
