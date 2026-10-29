> **Historical design notes (27 October 2026).** This document records the early Gen 3 CLAUSES planning contract, not current feature availability. Egg Encounter, Roamer, Shiny Rate and Route Forgiveness token/area redemption are implemented; only ordinary Pokémon revival remains disabled. For current behaviour use [Clauses](GEN3_CLAUSES.md), [Eggs/Forgiveness](GEN3_EGGS_FORGIVENESS.md) and the [feature matrix](GEN3_FEATURE_MATRIX.md). Historical original statements below are preserved as design history, not instructions.

# Gen 3 CLAUSES — agreed implementation contract

Status: **approved 27 October 2026**. Shiny Rate and Roamer Clause now have
opt-in **[WIP]** implementations and automated tests, pending FireRed/Hoenn
certification. Egg Encounter and Route Forgiveness remain **[Soon]**.

The design goal is a near-complete port of the existing Gen 1/2 Nuzlocke mod
without taking ownership from other active mods. The current Gen 3 runtime
keeps **mod API 2** to preserve the mature mod entry/legacy games.

## 1. Roamer Clause — already implemented [WIP]

*Option:* `OFF` or `SLOT` (defaults to OFF for old saves).

- **OFF:** roaming encounters use the normal area encounter rules.
- **SLOT:** roaming legendary Pokémon have one **species-specific persistent
  catch slot**, independent of the grass route currently occupied.
- Fleeing / fainting / missing the first roamer battle **does not consume**
  either the route slot or the roamer species slot.
- Capturing a roaming Pokémon closes **only** that roaming species slot.
- Dupes Clause still applies; Shiny Clause may bypass Dupes/area rules but
  cannot reopen a species-specific roamer slot already claimed.
- The adapter uses the Gen 3 engine's dedicated `roamer.encountered` event,
  or the native roaming Pokémon's `roamer=true` flag. Unsupported providers
  without either identification channel fall back to ordinary encounter rules.
- The saved `gen3_classic_v1.roamerClaims` map is persisted separately from
  `areas`. Nuz Dev's **RESET CLAUSE COUNTS** clears those test claims.

**Manual checks:**
- [ ] **R01:** Encounter and flee from a roaming legendary on Route A with
  Roamer SLOT + Failed Encounters ON. Route A stays open.
- [ ] **R02:** Catch an ordinary Pokémon later on Route A. Its normal slot
  is still available.
- [ ] **R03:** Encounter the same roamer later on Route B. It can be caught
  despite fleeing from the first one.
- [ ] **R04:** After catching it, the roamer slot closes without spending
  Route B's normal grass encounter.
- [ ] **R05:** Change Roamer SLOT -> OFF -> SLOT. Claimed species remain claimed.
- [ ] **R06:** Verify a second roaming species gets its own slot. On FireRed
  this may require a disposable altered save or a different edition.

## 2. Shiny Rate — implemented [WIP]

Original modes from Gen 1/2: `NATIVE`, `1/4096`, `1/1024`,
`1/512`, `1/100`, `1/10`, `ALWAYS`.

**Agreed Gen 3 scope:** newly generated wild Pokémon, including normal static
wild encounters. Exclude starters, gifts, Eggs, trainer Pokémon, tutorials and
persistent roamers until each has its own stable source/identity lifecycle.

Enhanced odds are applied **once at battle start**. The native 1/8192 chance
is evaluated first; only non-shinies get a conditional roll that raises the
*combined total* to the selected rate. Successful overrides set
`mon.isShiny=true` on that individual Pokémon and are cloned into the captured
Pokémon. They never change IVs, EVs, personality or base stats.

Gen 3's `Pokemon.isShiny()` may be called repeatedly by screens; Nuzlocke does
**not** add an independent random `shiny.roll` callback that rerolls on draws.
Where a verified active **SHINY_POKEMON** external provider owns shiny identity,
the menu reads `EXTERNAL`, Nuzlocke's own enhanced-rate mechanism is dormant
and the other provider remains authoritative. Other external mods will need
capability negotiation if they also claim shiny ownership.

**Need in-game validation:** GBA save persistence for the explicit shiny field,
static Pokémon, Safari, randomiser interoperation, and provider activation order.

## 3. Native shiny visuals — agreed

**Remove Shiny Colours and Shiny Intro from the Gen 3 CLAUSES menu.** FireRed,
LeafGreen and Hoenn already have native shiny palettes and animations.
Nuzlocke neither hides nor duplicates these; external presentation providers
remain responsible for their own visuals.

## 4. Egg Encounter — approved; [Soon] pending provenance hooks

Keep original Gen 2 semantics but adapt provenance for Gen 3 daycare and
gift-story Eggs:

- **OFF:** no route consumed; retain acquisition provenance.
- **RECEIVED:** egg claims the map where it was received, not where hatched.
- **HATCHED:** egg claims the map on which it hatches.
- **GIFT:** story gift Eggs use a separate one-off gift slot; bred Eggs
  still use their received/generated location.

**Approved:** Player-bred Eggs are unrestricted when Egg Encounter is OFF.
An Egg acquired/hatching in a spent location is recorded as pending/ineligible,
never silently destroyed and never allowed to corrupt story scripts. Eggs
count towards Dupes only when their species is established on hatch. Unknown
receipt origin must **fail open and log diagnostic provenance**, rather than
inventing a map. The menu switch stays [Soon] until reliable acquisition and
hatch hooks exist.

## 5. Route Forgiveness — approved; [Soon] pending restoration

Original modes: OFF / EARN / START 1. A Gym Leader earns one token once, which
can be spent to reopen a **failed** route or restore a fallen Pokémon.

**Approved:** Initially redeem tokens through a dedicated menu, with
confirmation; add the native inventory item later. The original Gym Leader
award rules remain (one token per unique defeated Leader; START 1 gives a
single initial token on new runs, not each time settings are changed).

Future revival requires a **complete Pokémon archive**, not species and level
metadata. `gen3_archive.lua` now preserves snapshot data on new deaths and
marks incomplete/cyclic records as non-restorable. Recovery itself remains
[SOON]: the native party/PC destination, safe half-HP restoration, pending
battle writes and capacity checks are not yet implemented.

When implemented, recover to the party if space, else PC; if neither has room,
keep the token and do not alter the graveyard. Forgiveness cannot reverse a
completed/lost run except through NUZ DEV. Legacy graveyard metadata cannot
reconstruct Pokémon and must never be treated as a valid recovery source.

## 6. API evolution

- Save schema stays `gen3_classic_v1` for backwards-compatible migration
  from existing FireRed tests.
- Future event consumers should use a **single acquisition provenance
  model** shared by eggs, gifts, trades, statics, roamers and normal catches.
- Expose safe, versioned query methods for provenance, spent locations,
  shiny ownership and token balances. No other mod should mutate raw tables.
- Other mods retain ownership of randomisers, shiny generation, gift scripts,
  UI rendering and PC storage unless a documented compatibility interface
  explicitly grants shared control.

## Remaining manual certification

The Roamer Clause code and isolated tests are complete, but native
FireRed/LeafGreen and Hoenn testing is required. Egg Encounter and Route Forgiveness deliberately remain **[Soon]** in the
player menu until provenance and safe full-individual recovery are validated.
The Shiny Rate and Roamer Clause controls are [WIP] pending live testing.
