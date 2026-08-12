# Nuzlocke 2.0.0-beta.26

**Canonical beta.26 baseline.** This release promotes the most recent 26B10 development build to the new beta.26 baseline after runtime testing. Future revisions use numeric-only versioning: **beta.26.1, beta.26.2, beta.26.3, ...**

This baseline was built forward through the beta.26 B-series from the published **25D4-RBY2** startup/menu hotfix. The old lettered B-series labels are now historical development markers only; they are not the versioning scheme going forward.

## Runtime-protected baseline

The following behavior has runtime evidence and should not be changed incidentally:

- Blue and Yellow NEW GAME SETUP visibility and startup through Oak into the bedroom.
- Gold GOLD BETA SETUP visibility; Gold uses the reduced beta-aware setup surface.
- Existing Red save menus/functionality smoke-tested on the published hotfix line.
- Blue/Yellow Soft Start behavior before first Ball activation: pre-Ball encounters do not consume the route regardless of Shiny Clause state.
- Pokédex handoff is the working activation boundary for configured starting Poké Balls: Oak's paperwork/route-ledger message fires and configured Balls appear in the home PC.
- Yellow starting Money and starting Rare Candies apply correctly.
- Trainer Card uses only the vanilla front and **NUZ STATUS** back; immutable starting Money/Balls/Candies are shown in the NUZ STATUS scrolling list.
- Forced starter nickname works when Nickname Rule is ON.
- Yellow PokéCenter healing ON/OFF works.
- Earlier beta.25 runtime passes remain protected for Gym Guide Rare Candy, No PP Items, No Escape, battle/field healing restrictions, Nickname Rule, No PokéCenter, No Repels and No X Items.

## Current beta.26 behavior

### Soft Start / first Poké Ball

Encounter rules stay inert until the run reaches the verified Pokédex/starting-Ball activation boundary or otherwise becomes genuinely armed by usable Ball ownership. Pre-Ball encounters should not spend an area. Once the run is armed, normal first-encounter rules apply and do not turn back off when Ball count returns to zero.

Configured starting Poké Balls are intentionally **not** in the bedroom PC at the very start. At the Pokédex handoff, the route ledger opens and the configured challenge Balls are delivered to the home PC.

### New Game setup

R/B/Y and Gold have separate setup-profile scopes. Gold displays a reduced **NUZLOCKE GOLD / BETA SETUP** rule surface with beta-aware descriptions because most Gold gameplay adapters still require individual runtime validation.

Starting setup supports Money, Poké Balls and Rare Candies. The selected starting values are snapshotted at New Game and shown later on NUZ STATUS so current inventory/spending does not rewrite the run's original setup history.

### Starter and nickname handling

R/B/Y starters are intended to use **Pallet Town** as their canonical Nuzlocke encounter location. Nickname Rule ON forces scripted starter/gift naming rather than allowing the normal YES/NO decline path.

### Trainer Card

The Trainer Card remains a two-view design:

- vanilla Trainer Card
- **NUZ STATUS**

NUZ STATUS includes catches/losses/progression, active rules and immutable starting-resource rows such as `Start $...`, `Start Balls ...` and `Start Candy ...`.

## Known issues / open work

- **No Buying / No Selling:** both previously passed on older builds but currently fail on the Gen1Recomp 0.1.79 test environment and produce no denial dialogue. This needs a dedicated Mart adapter repair.
- **Mom dialogue ownership:** No Mom Heal blocks healing, but vanilla rest dialogue can play first. The Nuzlocke denial should replace the vanilla interaction when the rule owns it.
- **Opening dialogue cleanup:** Professor Oak/rival World Building lines can repeat, appear as near-duplicates, or have poor spacing around the opening/Pokédex sequence.
- **Viridian Mart first-entry text:** Shop Clerk dialogue has a spacing/line-break issue in Yellow.
- **Rival T3 timing:** improved so the trainer appears first; final polish should place the flavor line after trainer reveal but before the opponent Pokémon comes out.
- **Starter location pre-Pokédex:** post-Pokédex Pikachu is confirmed as Pallet Town, but the pre-Pokédex Catch Info value still needs direct runtime confirmation on this baseline.
- Some world-building/battle denial messages still need a general wrapping/paging audit.
- Gold gameplay options shown in GOLD BETA SETUP remain individually test-required unless separately listed as runtime-passed.

See `DEV_ROADMAP.md` for planned beta.26.x work and `BETA26_TEST_PLAN.md` for the regression gate.
