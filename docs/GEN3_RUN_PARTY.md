# Gen 3 Nuzlocke — Run / Party rules

**Version:** v3.0.0-BETA  
**Menu:** NUZ MENU → NUZ RULES → RUN / PARTY.

Three existing legacy rules have been implemented using the native
Gen 3 engine. All are OFF / vanilla-equivalent by default and require
**CORE → NUZLOCKE** to be enabled. Values persist independently in
`gen3_classic_v1.runPartyRules`; they never change Gen 1/2 saves.

## Gym Team Size

- **OFF** by default. **ON** means that a Gym Leader battle cannot
  begin if you have more active Pokémon than the Leader's live
  opponent party. Fewer Pokémon are fine.
- The guard runs at native `Battle.start` after Gen 3's
  `trainer.party` hook is composed. It counts `opts.foeParty`
  first, then `opts.foe.party` rather than hardcoding Brock,
  Misty, Roxanne, Tate & Liza, or vanilla party sizes.
- Only the actual Gym Leader class is eligible: FRLG
  `TRAINER_CLASS_LEADER` (84); Ruby/Sapphire
  `TRAINER_CLASS_LEADER` (25); Emerald `TRAINER_CLASS_LEADER`
  (32). The recognised exact textual Gym Leader class can also
  come from a trainer provider.
- Gym Trainers, Champions, Elite Four, Aqua/Magma bosses,
  trainer facilities, recorded/link/wild battles and tutorials
  are excluded.
- If the opponent's composed party cannot be identified,
  enforcement fails open rather than inventing a cap.
- **Important:** The final exact-team check is inside native
  `Battle.start`, after the field's transition may have begun.
  The engine receives a failed battle-start result and its usual
  cancellation/unlock path. In-game testing must confirm the
  interrupted Gym Leader dialogue returns cleanly to the overworld
  in all editions. No badges or battle victory flags are granted
  by this mod.

## Party Size Limit

Selectable maximum from **1 to 6** (default 6). In Solo mode,
choose **1**.

This rule limits **active party slots**; it does not reduce the
storage box capacity or delete any Pokémon. If an existing save
already has more members than the new limit, they stay in the
party. You must deposit extras before acquiring or withdrawing
more, but may reduce the party and swap Pokémon normally.

Native integration:
- Wild captures are denied at the `catch.rate` pre-capture hook
  when a catch would add a Pokémon above the configured cap.
  A second native `Catching.storeCaught` check prevents
  out-of-band mutations before Pokédex/party/storage writes.
- Scripted gifts and starters use `Party.giveMon`; blocked
  gifts return the native can't-give status. The mandatory
  starter is still allowed while the party is empty.
- Normal NPC trades exchange one Pokémon for another and do
  **not** grow the active party, so remain legal.
- PC `Storage.withdraw`, box-to-empty-party
  `Storage.moveMon` and `Storage.placeHeldMon` are denied
  before mutation if the resulting party would exceed the cap.
  One-for-one swaps, moving between boxes and deposits remain
  legal. A native six-member party still uses vanilla PC transfer.
- When an eligible **Nincada → Ninjask** evolution would create
  an extra Shedinja over the configured cap, the newly created
  Shedinja is placed in the PC instead. If the PC is already
  completely full, the evolution is refused *before* mutation,
  to prevent losing Shedinja.

**Important interaction:** Unlike standard vanilla PC overflow,
a cap below six rejects new **capture/gift transactions** that
would add an active party member. The player must deposit
Pokémon first. Captures denied this way do not mark a new
successful catch; the encounter's ordinary Failed Encounters
policy still applies. A pre-capture Ball hook can be invoked
after the game has entered the Ball transaction; confirm the
on-screen message and Ball count in a ROM-level test.

## Evolution Limits

Select one of three modes:

| Mode | Effect |
| --- | --- |
| **NORMAL** | Native level, item, trade and other evolution checks |
| **NO FINAL** | Forbid a selected evolution if its target is a known terminal species with no further native evolution |
| **NO EVOLUTION** | Forbid all normal evolution attempts, including level-up, stone/item and trade evolutions |

Gen 3 uses a common `Evolution.targetSpecies` resolver
for native level, item and trade evolution, so the guard
rejects the chosen target before an evolution scene or
stone consumption. A second guard in `Evolution.apply`
protects normal evolution paths that bypass the resolver.

For **NO FINAL** the decision is based on the selected
target's **live merged evolution list**, not the source.
Branching lines are evaluated target-by-target. Unknown
target species and incomplete modded metadata fail open.
Explicit scripted/story species changes are not blocked
by the ordinary-evolution guard.

## In-game verification checklist (FRLG and RSE)

1. **RP01 — Defaults:** With Nuzlocke ON verify Gym Team
   Size OFF, Party Size 6/6, Evolution NORMAL. With the master
   switch OFF all three controls should stop enforcing.
2. **RP02 — Gym Leaders:** With Gym Team Size ON, bring
   more party Pokémon than the next Gym Leader has; the
   battle must not start. Box extras, talk again and verify
   battle starts. Check that no gym badge, trainer flag,
   victory rewards or stuck field lock are introduced.
3. **RP03 — Ordinary trainers:** Trainer battles inside
   the same gym must be unaffected.
4. **RP04 — Provider composition:** With a trainer-party
   randomiser/difficulty modifier, check that a Gym Leader's
   *actual* composed team size is used. Exercise doubles
   with Tate & Liza in Hoenn.
5. **RP05 — Solo cap:** Set Party Size to 1 with an
   existing two-or-more-Pokémon party. Verify no party
   Pokémon is removed. Deposit all but one, then test
   a wild catch and a scripted gift.
6. **RP06 — PC:** Confirm an empty-slot withdrawal
   cannot exceed cap; party/box swaps still work,
   and deposits always remain available.
7. **RP07 — Trade and egg:** Trade one party Pokémon
   for another and hatch an existing egg. Both should
   preserve legal party size.
8. **RP08 — Evolution:** With NO FINAL, Ivysaur →
   Venusaur should be blocked while Bulbasaur →
   Ivysaur is allowed. Verify branching and a Pokémon
   with unknown external evolution metadata.
9. **RP09 — NO EVOLUTION:** Level, stone, trade and
   native spontaneous evolution should all be suppressed.
   No item should disappear due to a blocked stone use.
10. **RP10 — Shedinja:** With Party Size 1, evolve
    Nincada if the separate Nincada-to-Ninjask evolution
    is permitted. Ninjask stays in the party; Shedinja
    is transferred to PC, not discarded.
11. **RP11 — ROM compatibility:** Repeat in FireRed,
    LeafGreen, Ruby, Sapphire and Emerald with both the
    native trainer roster and supported trainer randomiser.
12. **RP12 — Saved policy:** Save/reload with nondefault
    rules. Values persist without editing already-held
    Pokémon, battle data or ROM assets.

Automated tests cover validation, persistence, gym-class
identification by edition, provider-composed party sizes,
evolution targets, native seam wiring and menu controls.
These are **not substitutes** for the Gym Leader dialogue /
transition and item-consumption checks in real gameplay.
