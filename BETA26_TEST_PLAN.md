# Beta.26 Baseline Regression / Next-Revision Test Plan

This file describes the protected gate for the canonical beta.26 baseline and the minimum checks required before any beta.26.x revision is accepted.

## Startup hard gate

- Blue fresh title: SETUP visible.
- Yellow fresh title: SETUP visible.
- Red fresh title: SETUP visible.
- Gold fresh title: GOLD BETA SETUP visible.
- Gold setup uses reduced beta-aware options/descriptions.
- Blue fresh New Game: Oak intro -> bedroom.
- Yellow fresh New Game: Oak intro -> bedroom.
- Red fresh New Game: Oak intro -> bedroom/overworld smoke pass.
- Gold fresh New Game: reaches room.
- Existing Red save: RULES/TRACKER remain available.
- Gym Guide Rare Candy protected path still works.

## Soft Start / setup resources

- Starting Poké Balls absent from bedroom PC at initial start.
- Starting Money applies.
- Starting Rare Candies apply.
- Pre-Ball wild encounter with Shiny Clause ON does not consume route.
- Pre-Ball wild encounter with Shiny Clause OFF does not consume route.
- Pokédex handoff triggers route-ledger activation message.
- Configured challenge Balls appear in the home PC after that handoff.
- First legitimate post-arm encounter can be caught/logged.
- Second encounter on the same used route is denied normally unless an active clause overrides it.
- Returning to zero Balls does not disarm encounter rules.

## Trainer Card / starter

- Trainer Card has exactly two views: vanilla and NUZ STATUS.
- NUZ STATUS shows immutable `Start $`, `Start Balls`, and `Start Candy` values.
- Spending/using those resources does not alter the Start snapshot rows.
- Nickname Rule ON forces starter naming with no YES/NO decline path.
- Empty nickname cannot be accepted; one-character nickname is accepted.
- Starter Catch Info and Tracker should say Pallet Town from the earliest possible point; explicitly check before and after Pokédex handoff.

## Known-issue verification for future fixes

Do not mark these as baseline failures unless the revision claims to fix them:

- No Buying / No Selling on 0.1.79.
- Mom vanilla-rest dialogue before Nuzlocke refusal.
- Oak/rival duplicate/spacing issues.
- Viridian Mart first-entry spacing issue.
- Rival T3 final timing before opponent Pokémon reveal.
- Gold gameplay adapters not yet individually validated.

## Versioning

The next development revision after this baseline is **beta.26.1**. No more lettered beta.26 builds.
