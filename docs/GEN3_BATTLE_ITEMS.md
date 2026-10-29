# Gen 3 Advanced Rules — Battle Items

**Version:** 3.0.0-BETA
**Menu:** START → NUZ MENU → NUZ RULES → ADVANCED RULES → BATTLE ITEMS.

All four rules are functional and saved in the existing
`gen3_classic_v1.battleItemRules` namespace. They apply only while
CORE → NUZLOCKE is enabled and the run has not ended. Existing Gen 1/2
battle-item rules and all native inventory/party structures are untouched.

## Controls

| Rule | Default | Behaviour |
| --- | --- | --- |
| **No Healing Items** | OFF | Prevents direct battle use of HP restoratives, status cures, Full Restore, revival items and healing berries. PP-only items are controlled separately by Field Items → No PP Items (currently [Soon] in Gen 3). |
| **No X Items** | OFF | Disallows battle stat boosters, X Attack/Defend/Speed/Accuracy/Special and Guard Spec/Dire Hit, including native effect-classified boosters. Ordinary Balls and non-stat battle items (such as Poké Doll) are unaffected. |
| **No Catching** | OFF | Blocks all recognised Balls, including provider-registered custom Balls, before their native use or catch transaction. Does not block optional scripted gifts or NPC trades; their separate Catch Rules apply. Wild battles cannot spend area slots merely by starting while catching is disabled. |
| **Ball Per Enc.** | OFF | Limits **legal** Ball throws in each wild battle to 1, 2, 3, 5, or 10. OFF = unlimited. Counter resets at the next battle. |

### Rule precedence

- The native **BattleItems.isBattleUsable**, **canUseOn** and **use**
  transaction paths are guarded. Denied item usage does not call
  native `use`, remove a bag item, or consume a battle turn.
- `catch.rate` is also guarded; other direct catch-hook callers cannot
  bypass No Catching or a depleted Ball budget.
- An **allowed** Ball throw counts against the budget whether the
  Pokémon is caught or breaks free. A disallowed Ball attempt does **not**
  consume the budget: species bans, Type Locke, No Catching, route
  eligibility, Dupes, Shiny Nuzlocke, etc. are checked before counting.
- Ball throws used for an allowed Shiny Clause exception do count;
  a failed permitted throw still counts. Pokémon gifts/trades do not.
- A battle's throw count lives in runtime battle state, not permanent
  save data; this intentionally resets on each encounter.
- Native Battle Items `isBall` recognises standard Gen 3 and registered
  custom Balls, so custom Balls are not silently exempt from the bans.
- **Hardcore Nuzlocke** continues to ban non-Ball battle items
  independently; it does not override No Catching or Ball Per Enc.
- Trainer, link, first/tutorial scripted battle item behaviour stays
  native where the engine identifies these scenes. Wild catch rules
  apply normally to eligible wild battles.
- All settings persist with the Nuzlocke master switch OFF but are not
  enforced until the master is ON again.

## In-game verification

1. On a disposable Gen 3 save, visit ADVANCED RULES → BATTLE ITEMS.
   Confirm three OFF toggles and Ball Per Enc. OFF. Cycle Ball Per Enc.
   through 1, 2, 3, 5, 10, OFF, then restart to test persistence.
2. Enable No Healing Items. In battle attempt Potion, Antidote,
   Full Restore, Revive, Oran Berry and Lum Berry. They should be
   refused with no inventory or turn use; a PP-only Leppa Berry is
   intentionally not covered by this particular rule.
3. Enable No X Items. Try X Attack, X Speed, X Special, Dire Hit,
   Guard Spec and an effect-registered custom stat booster. They should
   not be consumed. Poké Doll and Balls should remain available.
4. Enable No Catching with Failed Encounters Count ON. Start a first
   wild battle on an unused route and attempt to throw a Ball.
   Nothing should be caught; no Ball should be consumed and no route
   encounter slot should have been claimed. Test custom Balls too.
5. Turn No Catching OFF, choose Ball Per Enc. = 2, and encounter a
   legal wild Pokémon. Throw two Balls that fail, then try a third.
   Exactly two should reach native processing; the third must not
   consume a Ball or turn. The next wild battle starts at zero.
6. Test an illegal species (PKMN BAN, Type Locke or Legendary ban)
   with Ball Per Enc. enabled. Banned throws should not count toward
   that encounter's legal Ball budget. Repeat with a Shiny Clause
   exception allowed by the normal catch rules.
7. Enable Hardcore and verify non-Ball items remain prohibited even
   if both individual item bans are OFF. Test normal Balls, No Catching
   and Ball Per Enc. independently under Hardcore.
8. Switch CORE → NUZLOCKE OFF and verify the native battle item bag
   works normally while all selected rule values stay saved.
9. Repeat with FireRed/LeafGreen and Ruby/Sapphire/Emerald, including
   a registered custom Ball from a compatible mod.

Automated smoke tests are ROM-free and cannot substitute for manual
verification of inventory, battle UI, animation and provider behaviour
in all supported editions.
