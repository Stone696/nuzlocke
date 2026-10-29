# Gen 3 Nuzlocke — CLAUSES milestone

The CLAUSES screen uses the original Gen 1/2 **option meanings** where safe,
but is scoped to Generation 3. The original Johto **Bug Catching Contest**
setting is intentionally omitted. Dupes and Shiny Catch Exceptions are
implemented in Gen 3 and await full real-ROM certification. Roamer, Egg Encounter and Route Forgiveness route-token/redemption controls are also implemented; **ordinary Pokémon revival is not implemented**. Their native edition and external-provider edge cases still need testing.

## Implemented policy and status

| Menu item | Modes / description | Status |
| --- | --- | --- |
| **DUPES CLAUSE** | `OFF`, `SPEC`, `FAM`, `SPLIT` | Implemented (edition/evolution validation pending) |
| **SHINY CLAUSE** | `OFF`, `1`, `2`, `3`, `UNLIMITED` | Implemented (native shiny validation pending) |
| **SHINY RATE** | NATIVE / 1/4096 / 1/1024 / 1/512 / 1/100 / 1/10 / ALWAYS | Implemented (native rate/ownership validation pending) |
| **ROAMER CLAUSE** | OFF / SLOT; roaming species get independent catch slots without spending grass routes | Implemented (native roamer validation pending) |
| **EGG ENCOUNTER** | OFF / RECEIVED / HATCHED / GIFT; bred Egg provenance and hatch-based area claims | Implemented with provenance limitations |
| **ROUTE FORGIVENESS** | OFF / EARN / START 1; badge-based tokens and missed-route reopening | Tokens/routes implemented; ordinary revival unavailable |

FireRed, LeafGreen and Hoenn already have native shiny palettes and battle
intro effects. **Shiny Colours and Shiny Intro are removed from the Gen 3
menu**, with the native effects left untouched. Their old Gen 1/2 settings
and functionality remain unchanged.

**Existing saves:** Both new CLAUSES settings default to OFF in Gen 3 to avoid
retroactively blocking captures on earlier test saves. In contrast, the
original mature Gen 1/2 rules have different defaults; this is deliberate
until a Gen 3 new-game setup/preset UI is implemented.

## Dupes Clause

- **OFF**: previously obtained Pokémon do not affect future encounters.
- **SPEC**: the exact same species is ineligible.
- **FAM**: Pokémon anywhere in the same connected evolution family are
  ineligible. Example: Vaporeon and Jolteon are both in Eevee's family.
- **SPLIT**: only ancestors or descendants of the exact line count as
  duplicates. Vaporeon does **not** exclude its sibling Jolteon, but either
  excludes Eevee.

Eligibility is checked **before consuming an encounter**. A duplicate does
not spend the location, even with **Failed Encounters ON**. Trying to capture
the duplicate is rejected at `catch.rate`; an eligible species encountered
later in that location can consume the slot normally.

Previous acquisitions are inferred from the existing captured-species log,
caught encounter records, living party, boxed Pokémon and the graveyard.
Evolution relationships are read from the native ROM-backed
`Pokemon.evolutions()` graph. Internal species IDs are normalised through the
engine's `Pokemon.speciesOf()` where available.

**Known gaps:** Capture legality now composes with supported story gifts, trades and static battles; encounter keys use the configured [Area Splits](GEN3_AREA_SPLITS.md) policy. ROM/provider transformations of the evolution graph still need testing; if the evolution graph is unavailable, FAM/SPLIT fail open rather than blocking an unrelated Pokémon. Implemented policy does not imply in-game certification.

## Shiny Catch Exception

- **OFF**: no extra catches outside regular area and Dupes restrictions.
- **1/2/3**: that many successful *exceptional shiny captures* per run.
- **UNLIMITED**: traditional Shiny Clause, unrestricted allowance.

The clause does **not alter shiny odds**. It reads
`Pokemon.isShiny(mon)`, which respects native Gen 3 identity and the engine's
`shiny.roll` seam, including results from compatible shiny providers.

A shiny on an **already spent route** or a **duplicate shiny** may be caught
using an available exception. A failed Ball does not spend allowance;
successful capture does. Exceptional shiny captures do not consume/rewrite a
separate normal encounter slot. A shiny that was already eligible for a
normal encounter simply uses that normal encounter.

Counters persist under `gen3_classic_v1.shinyExceptionsUsed`. Changing the
allowance mid-run does not refund any previously used exception.

The clause cannot bypass other mods' catch-rate denial or future absolute
rules such as No Catching, species bans or Type Locke. The policy calls
`next(...)` for permitted catches rather than forcing a capture.

## Shiny Rate (implemented; native verification pending)

The setting controls **rarity, not Shiny Clause capture exceptions**.
Enhanced rates are applied once when a newly generated wild or standard static
battle Pokémon appears, before catch eligibility is checked. Existing
native shinies remain shiny. Additional probability is conditional on the
native 1/8192 roll having failed, so total odds equal the selected rate rather
than stacking two full rolls.

The result is attached to the individual Pokémon (`isShiny`) instead of
randomising inside each repeated `Pokemon.isShiny()` call. The native
capture path copies the Pokémon's full fields; Nuzlocke also preserves the
flag when the `pokemon.caught` event fires.

Starter Pokémon, Eggs, gifts, trainers, scripted tutorial encounters and
persistent roaming Pokémon are excluded until their stable acquisition
identity can be certified. The master Nuzlocke enforcement switch does not
turn this independent generation feature off.

A recognised active `SHINY_POKEMON` provider takes precedence: the menu shows
**EXTERNAL** and Nuzlocke makes no shiny-rate alterations. Additional
third-party provider APIs must be reviewed before certification.

## API / compatibility

- `gen3_clauses.lua` is separate from `gen3_core_rules.lua`: menus must
  never implement their own catch decisions.
- `mod.exports.gen3_clauses` (API 1) exposes:
  `definitions()`, `getMode(key)`, `setMode(key, value)`, and `summary()`.
- Unsupported CLAUSES settings are rejected by `setMode`, not silently
  enabled. Failed runs cannot change clause configuration.
- `capturedSpecies`, `shinyExceptionsUsed` and `clauses` are added to the
  same backwards-compatible `gen3_classic_v1` save bucket; old records stay
  readable.
- No `shiny.roll` override is installed: the approved Shiny Rate works on
  the individual native wild battle Pokémon, with conditional probability.
- The helper `gen3_shiny_rate.lua` exposes `externalProvider`, `modeLabel`,
  `extraProbability` and one-time `apply` logic.
- Roamer Clause listens for native `roamer.encountered` and native `roamer=true`,
  recording captures in `roamerClaims` rather than consuming `areas`. See
  [GEN3_CLAUSES_NEXT.md](GEN3_CLAUSES_NEXT.md) for proposed remaining clauses.
- The mature Gen 1/2 runtime, menu and save schema remain unchanged.

## Recommended in-game test matrix

Use a disposable save and **NUZ DEV → RE-ARM CURRENT** between tests. Remember:
re-arming an area doesn't remove Pokémon from party/PC or graveyard, which
can themselves continue triggering Dupes Clause.

- [ ] **CL01** — Set Dupes OFF. Capture two Pokémon of the same species in
  two unused locations (or with One Per Area OFF). Both should be permitted.
- [ ] **CL02** — Set Dupes SPEC. With a Pidgey in your party/PC, encounter a
  Pidgey on an unused route. Capture blocked; route remains free.
- [ ] **CL03** — Still on that route, encounter a species you don't own.
  Capture allowed; now the route is consumed.
- [ ] **CL04** — Set Dupes FAM. With Caterpie in party/PC, encounter
  Metapod or Butterfree. It should count as a duplicate.
- [ ] **CL05** — Set Dupes SPLIT. With Vaporeon owned, Jolteon should not
  count as a duplicate; Eevee should. (Use a randomiser or DEV save if needed.)
- [ ] **CL06** — Set Shiny Clause OFF. A shiny duplicate/used-route encounter
  should still be denied.
- [ ] **CL07** — Set Shiny Clause 1. A shiny duplicate or shiny found on a
  spent route should be catchable once; a second exceptional shiny should be
  denied. Non-shiny repeats remain denied.
- [ ] **CL08** — Miss several Balls on an eligible exceptional shiny, then
  catch it. The allowance should increment **once**, only on success.
- [ ] **CL09** — Toggle Shiny Clause 1→2 after using the first allowance.
  One more exceptional catch should be available; usage must not reset.
- [ ] **CL10** — A normally eligible shiny on a fresh route should **not**
  consume a Shiny Clause exception.
- [ ] **CL11** — Save and reload after captures. Dupes history, selected
  modes and exceptional shiny usage should persist.
- [ ] **CL12** — Confirm Shiny Rate cycles all seven modes, native shiny
  palettes/intros remain intact; Egg/Route Forgiveness options are selectable, while the unsupported ordinary revival action remains [Soon].
  Roamer Clause supports OFF/SLOT; see R01–R06 in the
  [next milestone notes](GEN3_CLAUSES_NEXT.md).
- [ ] **CL13** — In NUZ DEV, confirm **RESET CLAUSE COUNTS** clears the
  shiny exception counter and capture log, but does not erase actual party/PC
  Pokémon or legacy graveyard evidence. Cancellation must change nothing.
- [ ] **CL14** — Repeat basic SPEC and Shiny Clause behaviour on another Gen 3
  edition (Emerald recommended) and note any other enabled mods.

## Unit and engine testing

```bash
lua5.1 tests/gen3_foundation_smoke.lua
lua5.1 tests/gen3_clauses_smoke.lua
lua5.1 tests/gen3_shiny_rate_smoke.lua
lua5.1 tests/gen3_archive_smoke.lua
```

The dedicated Gen 3 GitHub Actions workflow runs both tests. They confirm
Lua-level behaviour with mocks; they **do not** certify every vanilla/modified
species in FireRed, LeafGreen, Ruby, Sapphire or Emerald. Please report the
exact edition, other enabled mods and test ID when something fails.

Egg Encounter and Route Forgiveness have a separate twelve-case live test
matrix: [GEN3_EGGS_FORGIVENESS.md](GEN3_EGGS_FORGIVENESS.md).
