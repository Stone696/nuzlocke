# Gen 3 Advanced Rules — Pokémon Stats

**Version:** v3.0.0-BETA  
**Menu:** START → NUZ MENU → NUZ RULES → ADVANCED RULES → POKEMON STATS.

Seven controls use the Gen 3-only `gen3_classic_v1.statRules` save
namespace. All require CORE → NUZLOCKE. Settings persist when CORE is OFF.

Gen 1/2 use DVs and Stat EXP, but Gen 3 uses six independent **IVs** in
0–31 and six **EVs** in 0–255 with an overall 510-EV limit. The old
Gen 1/2 rule keys ending in `_stat_exp` are retained internally for
compatibility, but these Gen 3 controls work with native EVs instead.

| Setting | Default | Enforced Gen 3 behaviour |
| --- | --- | --- |
| **Player Starting EVs** | 0 EV/stat | Freshly acquired Pokémon can receive 16, 32, 48, 64 or 85 EVs **in each of the six stats**, subject to the 510 cap. A 0 setting retains the native EV distribution. Existing Pokémon are untouched. |
| **Wild Starting EVs** | 0 EV/stat | New native wild battle Pokémon receive the selected even EV spread. Existing overworld residents are not modified until their native battle creation. |
| **Trainer Starting EVs** | 0 EV/stat | New NPC trainer battle Pokémon receive the selected EV spread before their battle stats are calculated. Does not change trainer rosters, species, moves or template data. |
| **No EV Gain** | OFF | Stops additional native EVs earned from defeated foes or ordinary positive-EV vitamins. Existing EVs, EXP and level gain remain intact. Gen 3 EV-reduction berries remain legal. |
| **Perfect Player IVs** | OFF | Freshly caught, gifted and native NPC-traded Pokémon receive 31 in all six IVs. Existing Pokémon are not changed. |
| **Perfect Wild IVs** | OFF | Newly generated wild Pokémon receive six 31 IVs. Capture may then apply the separate Player IV rule. |
| **Perfect Trainer IVs** | OFF | Newly generated NPC trainer Pokémon receive six 31 IVs, including RSE trainers, instead of the native IV preset. |

### EV preset scale

| Menu level | EV per stat | Total EVs |
| --- | ---: | ---: |
| 0 | 0 (native/no override) | unchanged |
| 1 | 16 | 96 |
| 2 | 32 | 192 |
| 3 | 48 | 288 |
| 4 | 64 | 384 |
| 5 | 85 | 510 |

This is an **even distribution**, not six separate 252-EV maxima.
The max preset is precisely legal. A value of zero means no override,
not a reset of earned EVs or NPC trade metadata.

### Native boundaries and safeguards

- **Opponent generation:** A guarded native `Battle.start` passes
  cloned encounter descriptors into the engine, modifying their IV/EV
  inputs but leaving actual stat computation to `foe_mon_from` and
  `Damage.ensureStats` **after final personality/nature is decided**.
  Original encounter tables, trainer definitions, ROM data, and the
  randomiser's species pools are unchanged.
- **Player acquisition:** Native `pokemon.caught` emits the stored
  mon object; a successful gift passes through `Party.giveMon`;
  and an actual native NPC trade passes through `Trade.tradeMons`.
  These three operations are authoritative moments at which a new
  Pokémon may be modified. Their unsuccessful variants do nothing.
  Link trades and link battles are outside these NPC/wild rules.
- **EV restriction:** Native `Pokemon.gainEVs` and
  `Pokemon.raiseEvFromItem` are intercepted only for objects
  identical to a Pokémon in the current player's party. This avoids
  blocking enemy or provider-owned calculations. Positive EV vitamins
  are denied before consumption; EV-reducing berries are not prohibited.
  An Enigma Berry with a positive-EV effect is guarded separately.
- **HP safety:** Recalculating a newly acquired Pokémon's stats
  retains its prior HP damage. Fainted Pokémon are never revived.
- **No retroactivity:** Adjusting rules will not respec an existing
  party or PC. This is not a global stat editor, save migration or
  hidden modifier of the original Gen 1/2 behaviour.

## Manual ROM tests (FR/LG/R/S/E)

1. **PS01 — Menu:** Verify three EV preset selectors and four toggles
   are accessible. Cycle all presets, then save/restart. Values persist.
2. **PS02 — Wild IV:** Enable Perfect Wild IVs and start a new wild
   battle. Inspect actual opponent IVs with a suitable developer
   diagnostic. All six must be 31. Confirm all nature-dependent
   stats still match the Pokémon's personality.
3. **PS03 — Trainer:** Enable Trainer Starting EVs = 85 and Perfect
   Trainer IVs. Compare a newly created NPC party's six EVs and IVs
   against the 510 total and 31 cap. Repeat in RSE and double battles.
4. **PS04 — Player capture:** Enable Player Starting EVs = 32 and
   Perfect Player IVs; catch a wild Pokémon, verify 32 in each EV
   and all 31 IVs in party or PC, including while party is full.
5. **PS05 — Gifts:** With the above enabled receive a starter or
   scripted gift. Verify the actual received Pokémon is changed, but
   other existing party members are not. Repeat with PC delivery.
6. **PS06 — NPC trade:** Complete an allowed native NPC trade. Only
   the received Pokémon adopts the player presets, not the sent Pokémon.
7. **PS07 — No EV Gain:** With this rule enabled win a battle and try
   an HP Up / Protein / Iron / Carbos / Calcium / Zinc. EVs and
   inventories must not change. EXP and levels still progress normally.
8. **PS08 — EV decrease:** In Emerald use an EV-reducing Berry when
   it can lower the stat. It should still reduce EVs (and apply its
   native friendship effects).
9. **PS09 — Master OFF:** Turn off CORE Nuzlocke without deleting
   presets. New wilds, trainer Pokémon and native player acquisitions
   return to normal generation. Toggle CORE back on to restore settings.
10. **PS10 — Compat:** Repeat with randomised species and
    Untamed-Advanced visible overworld Pokémon. Wild stats must use
    the final native battled species, not the original spawn slot.
    Linked Pokémon must remain untouched.

The automated smoke verifies definitions, save coercion, the six
native IV/EV values, 510 cap, source immutability and guard wiring.
In-game testing is still required for edition-specific transactions
and third-party modern-stat providers.
