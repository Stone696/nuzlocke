# Gen 3 ADVANCED RULES — Variants / Type Locke

**Version:** 3.0.0-BETA · **Menu:** START → NUZ MENU → NUZ RULES → ADVANCED RULES → VARIANTS.

**Requires:** CORE → NUZLOCKE enabled and a run that has not ended.
This is separate from Gen 1/2 rules; all settings live in the existing
Gen 3 save as `variantRules`. Switching the master OFF temporarily
suspends Type Locke without deleting its saved settings.

## Active rules

| Rule | Default | Behaviour |
| --- | --- | --- |
| **Type Locke** | OFF | OFF, MONO, DUO, TRI, QUAD, PENTA or HEXA. Number of allowed type lanes: 0–6. |
| **Type 1** | RANDOM | Available in MONO through HEXA; selects the first type. |
| **Type 2** | RANDOM | Available in DUO through HEXA; selects the second type. |
| **Type 3** | RANDOM | Available in TRI through HEXA. |
| **Type 4** | RANDOM | Available in QUAD through HEXA. |
| **Type 5** | RANDOM | Available in PENTA/HEXA. |
| **Type 6** | RANDOM | Available in HEXA. |
| **Catch Draft** | OFF | ON makes the first eligible successful **wild** catches establish the allowed lanes. Each catch adds at most one new type; after all lanes are filled, normal Type Locke restrictions apply. Gifts, NPC trades and starters do not draft. |

With Catch Draft ON, the active Type 1–6 rows become **read-only** and
display either the drafted type or AWAIT CATCH. The menu also displays
DRAFT: X/Y TYPES, and a successful wild catch generates a notice. With
Catch Draft OFF, Type selectors are manually editable and cycle
RANDOM, NORMAL, FIGHTING, FLYING,
POISON, GROUND, ROCK, BUG, GHOST, STEEL, FIRE, WATER, GRASS,
ELECTRIC, PSYCHIC, ICE, DRAGON and DARK.

**Gen 3 type IDs are used.** FIRE is native ID 10, WATER 11, and
GRASS 12. Internal ID 9 is TYPE_MYSTERY and is intentionally not
exposed as a selectable normal Pokémon type. This is independent of
the National Dex species IDs used for other catch bans.

## Catch behaviour

- A Pokémon is legal if **either** its primary or secondary type is
  in **any** active Type Locke lane. It need not match both types.
- Off-type Pokémon may still appear, be battled or fainted. Their Ball
  captures are blocked **before** native catch/storage processing.
- Off-type wild Pokémon do **not** consume the area's first encounter,
  including when Failed Encounters Count is ON. The next eligible
  encounter remains your first opportunity.
- Checks run at battle start AND at Ball use. They also run before
  optional scripted gifts and native NPC in-game trades. The
  mandatory opening starter remains progression-exempt.
- Shiny Clause does not bypass Type Locke; the two rules compose.
  Type Locke also composes with PKMN BAN, Colorlocke, Alphabetlocke,
  Legendary/Mythical/Pseudo and BST bans.
- Untamed-Advanced visible wandering wild Pokémon automatically use
  the same restrictions via the normal battle/catch path. No separate
  overworld enable rule is necessary.
- Existing party/PC Pokémon are not removed or retroactively changed.
  Pokémon types are tested at acquisition only; later evolution does
  not trigger a retrospective ban.
- Species with genuinely unavailable type metadata fail open rather
  than guessing. Types supplied by the live Gen1Recomp Pokémon
  registry remain authoritative for registered species.

## Catch Draft

Enable Type Locke in MONO–HEXA and turn Catch Draft **ON**. The first
successful wild catches determine your allowed Pokémon types rather
than preselecting or randomly assigning the lanes.

- While **at least one lane is empty**, wild Pokémon of any type are
  eligible for catching (subject to all the other ordinary Nuzlocke
  rules). Merely encountering or defeating a Pokémon, or throwing a
  failed Ball, does not add a draft type.
- The first successful wild catch adds one type, preferring its primary
  type. When the primary is already drafted and its secondary is a new
  type, the secondary is added instead.
- If **both types are already drafted**, the catch is still legal
  during the draft, but adds no new lane. A later successful catch with
  an undrafted type is needed to complete the draft.
- Once **all configured lanes are filled**, only Pokémon matching any
  drafted type can be caught. Off-type wilds then stop consuming route
  encounter slots and are refused before native catch transactions.
- **Optional gifts and NPC trades cannot draft types.** During a partial
  draft they must already match a previously drafted type; before the
  first wild catch establishes a type, optional gifts and NPC trades
  are blocked. The mandatory story starter remains exempt.
- The selection is saved as native type IDs in
  `variantRules.drafted_types`, persists across saves and is not
  changed by failed captures, previously owned Pokémon, or evolutions.
  The actual final Pokémon species determines its types, including
  randomised and Untamed wandering wild encounters.
- Switching Catch Draft OFF or changing the Type Locke mode **resets
  draft progress**; an OFF-mode Type Locke setting remains inert.
  Manually configured type lanes are retained and restored when
  Catch Draft is turned off. You cannot manually overwrite an active
  draft lane.

## RANDOM lanes

When Catch Draft is OFF, RANDOM is not a constant reroll. On the first eligible encounter or
supported optional acquisition, the mod scans available native
National Dex species for represented types, selects distinct valid
types for RANDOM lanes, and saves them in
`variantRules.random_types`. Selection is deterministic for the
trainer identity/seed; reloading does not change the chosen types.
A manually selected type is excluded from other RANDOM lanes.
Explicit duplicate types selected by the player are permitted.
Changing Type Locke mode or a Type selector clears generated
allocations so the new configuration can resolve consistently.

RANDOM does **not** alter a Pokémon's species, actual types or
the native randomiser's encounter population: it only determines
which types the player is allowed to acquire.

## Manual test checklist

1. On a disposable Gen 3 save, enable Nuzlocke; open VARIANTS. Confirm
   Type Locke and Catch Draft are initially OFF. The menu contains no unused trade variant.
2. Choose MONO and set Type 1 = FIRE. A Fire Pokémon (e.g. Charmander)
   must be catchable, subject to other rules; a Water Pokémon (e.g.
   Squirtle) must be refused without spending the route.
3. Set DUO and Type 2 = WATER. Both Fire and Water become eligible;
   an unrelated Normal/Flying Pokémon remains ineligible.
4. Select POISON as one lane and encounter Bulbasaur (GRASS/POISON):
   either matching type must allow it.
5. Progress TRI → QUAD → PENTA → HEXA, verifying only the chosen number
   of Type rows appear; return to OFF to hide them all.
6. Set multiple lanes to RANDOM. After a first wild encounter, inspect
   RND:TYPE labels, save, restart and verify that every selection stays
   the same and no two RANDOM lanes duplicate a type.
7. Try a supported scripted gift and NPC trade with prohibited types:
   their native transaction must not mutate party/PC or spend an area.
   Try allowed types on a new map and verify AREA/BONUS policies.
8. Test a wandering Untamed wild and a randomised wild: the **final**
   battle species' actual types decide eligibility, not the original
   encounter slot's species.
9. Confirm Shiny Nuzlocke and Shiny Clause do not override a mismatch,
   and turning Nuzlocke OFF disables Type Locke without clearing it.
10. Set DUO + Catch Draft ON. Check that Type 1 and Type 2 display
    AWAIT CATCH, that they cannot be changed by A presses, and that
    DRAFT: 0/2 TYPES is displayed. Failed Balls and battles must
    not advance that counter.
11. Catch a dual-type Grass/Poison Pokémon: it drafts GRASS. Catch
    another Grass/Poison Pokémon on a fresh legal route: it should
    draft POISON rather than reselect GRASS. Saving and reloading
    must preserve the order and count.
12. With only GRASS drafted, wild catches of any type remain legal,
    but optional gifts/NPC trades must already match GRASS. Before
    any wild has been caught, optional gifts and NPC trades must
    not proceed. A legal gift/trade must never advance the draft.
13. Once DUO drafting is complete, a Pokémon of neither drafted
    type must be refused without spending its route. Test
    a dual-type Pokémon where only the secondary type matches.
14. Catch a Pokémon whose two types are already drafted while
    drafting TRI. It must not silently fill the third lane. Catch
    a different-type Pokémon and confirm the third slot is filled.
15. Switch mode or turn Catch Draft OFF: saved draft selections
    are cleared, and original manual Type selectors return.
    Repeat with randomised/Untamed wild Pokémon and confirm
    the **final** species' actual types are used.

Automated Lua smoke tests are not a substitute for exact-edition
FireRed, LeafGreen, Ruby, Sapphire and Emerald in-game verification.
