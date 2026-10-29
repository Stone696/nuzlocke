# Gen 3 CLAUSES — Eggs and Route Forgiveness (implemented with limits)

Implemented in `gen3_eggs.lua` and `gen3_forgiveness.lua`, both loaded
only on Gen 3. This milestone uses native Gen 3 events and conservative
save-local rules; it does **not** modify the original Gen 1/2 code.

## Egg Encounter

The menu retains the approved options:

| Mode | Implemented behaviour and limitations |
| --- | --- |
| OFF | Normal breeding/hatching; no area slot is consumed |
| RECEIVED | A bred Egg is tagged with its native map at creation. On hatch, it consumes the *receipt map's* free encounter slot |
| HATCHED | On hatch, it consumes the free slot where the Egg hatches |
| GIFT | Daycare Eggs are exempt; actual story gift-Egg delivery still needs a reliable provenance event and therefore fails open |

The engine provides two dedicated events:
`breeding.egg_created` (passes `egg`, often `mother`/`father`) and
`egg.hatched` (passes `mon`, an old `egg` copy, the party slot and
species). Nuzlocke tags the original Egg's host-mon fields at creation,
then reads them when the hatch event arrives.

**Limitations — important:**

- Egg creation can occur before successful delivery. **RECEIVED currently
  claims the area when the Egg hatches**, using the saved receipt location.
  It does not yet reserve the slot at actual receipt.
- A hatchling from a spent route is marked
  `nuzEggProvenance="INELIGIBLE"` and logged; it is **not yet blocked from
  being used in battle**. The unresolved hatchling-use restriction remains a known beta limitation even though Egg tracking and slot-claim logic are implemented.
- UNKNOWN provenance fails open and leaves the encountered route untouched.
  This prevents making up a receipt location for scripted gift Eggs.
- Neither Eggs nor hatched Pokémon are deleted, recreated or forcibly
  moved. That avoids breaking the game's story/hatch flows.
- Eggs only enter ordinary Dupes tracking after their species is known and
  they hatch; future acquisition registry work will unify the events.

Hatches are listed in **CLAUSES → EGG HISTORY**. This list is save-local
metadata, not an invasive replacement for the native Pokémon summary.

## Route Forgiveness

The menu has **OFF / EARN / START 1**.

- OFF: no new token awards and no redemption.
- EARN: each **new** Gym Badge flag detected after enabling grants 1 token.
- START 1: one token is added on the first activation *per run*; subsequent
  Gym Badge awards are the same as EARN, with no bonus from toggling OFF/ON.

At activation, the current Gym Badge flags are recorded as a baseline;
badges already owned do **not** retroactively grant tokens. If native
badge data is unavailable at activation, the baseline is deferred rather
than awarding arbitrary existing badges. Tokens and observed badge IDs
persist under `gen3_classic_v1.forgiveness`.

The source for FRLG Gym Badges is the engine's native script flag range
`0x820..0x827`; this must still be verified independently for each RSE
edition and any alternative progression mod. The token tally refreshes
on map entry or opening the NUZ MENU, not by polling the battle every frame.

### Redeem a token

Navigate to **NUZ MENU → NUZ RULES → CLAUSES → REDEEM TOKEN**.
You'll see the token balance and eligible routes. Select a route and
confirm YES. A token can reopen **one failed/missed route** that
has `spent=true, caught=false`. An area where you caught a Pokémon is not
eligible. Each route can be forgiven **at most once per run**. A completed
or lost run cannot redeem forgiveness.

Redemption requires the main Nuzlocke rule to be ON and changes only the Nuzlocke encounter record, not world progress,
Pokédex entries, party, PC or inventory. For repeatable testing, **NUZ DEV → ADD TEST TOKEN** grants one token on a flagged disposable test save, behind a confirmation.

**Ordinary Route Forgiveness Pokémon revival remains unavailable**, even for new deaths with archived
full-individual data. A safe native party/PC transaction, destination
capacity checks, half-HP heal and token rollback on failure are prerequisites.

## Compatibility and public API

Existing saves still use `gen3_classic_v1`, and new fields are additive.
The public `gen3_clauses` API exposes the selected modes and read-only
`summary().forgivenessTokens` / `summary().eggsTracked`.
The Egg and Forgiveness helpers never accept raw writes from third-party
mods. The menu delegates decisions to them rather than duplicating logic.

### Live FireRed checklist

Use a **disposable test save**. For Egg tests, you may need a later-game save
with the Daycare, or a developer test egg.

- [ ] **EG01** — OFF: Hatch a bred Egg; no area slot should be claimed.
- [ ] **EG02** — RECEIVED: Obtain an Egg on map A, hatch on map B. Map A
  should be claimed (currently on hatch), map B should remain open.
- [ ] **EG03** — HATCHED: Obtain Egg on map A, hatch on map B. Map B is claimed.
- [ ] **EG04** — Already spent route: A new hatch is recorded as ineligible,
  but the existing area claim is unchanged and no Pokémon is deleted.
- [ ] **EG05** — GIFT: Bred Eggs remain exempt. Story gifts with missing
  provenance should be logged as UNKNOWN and not consume a guessed map.
- [ ] **EG06** — Save/reload and inspect Egg History.
- [ ] **FG01** — START 1: One token appears. Toggle OFF/ON to confirm no
  second starting token appears.
- [ ] **FG02** — EARN: Win a *new* Gym Badge after enabling, then change maps
  or open NUZ MENU. Token count should increase exactly once.
- [ ] **FG03** — Redeem on a failed route. Confirmed action consumes one
  token and reopens the encounter; Cancel changes nothing.
- [ ] **FG04** — A captured route and a previously forgiven route cannot
  consume another token. A lost run cannot redeem.
- [ ] **FG05** — Pokémon revival stays [Soon] and **does not spend tokens**.
- [ ] **FG06** — Save/reload; check tokens, badge history and one-time
  redemption records persist.

### Automated tests

```bash
lua5.1 tests/gen3_foundation_smoke.lua
lua5.1 tests/gen3_eggs_smoke.lua
lua5.1 tests/gen3_forgiveness_smoke.lua
```

Also run the existing `gen3_clauses_smoke.lua`,
`gen3_shiny_rate_smoke.lua`, and `gen3_archive_smoke.lua`.
Only real game testing certifies the native rendering, event sequencing
and edition-specific badge flags.
