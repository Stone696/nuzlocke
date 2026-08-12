# Nuzlocke 2.0 Development Roadmap

## Versioning / baseline

**Current canonical baseline: 2.0.0-beta.26.**

The beta.26 baseline is promoted from the 26B10 development revision. Lettered builds are retired. Every new revision must be created only from the immediately previous revision and will use numeric-only versioning:

- beta.26
- beta.26.1
- beta.26.2
- beta.26.3
- ...

Older builds, including beta.26 B-series artifacts, are reference material only and are never restored wholesale.

## Runtime-tested / protected

- Published 25D4-RBY2 startup/menu hotfix remains protected.
- Blue fresh startup through Oak -> bedroom.
- Yellow fresh startup through Oak -> bedroom from the published/startup line.
- Gold NEW GAME SETUP visibility/room boot on the published line; Gold beta-aware SETUP presentation confirmed on the beta.26 line.
- Existing Red save menus/functionality smoke-tested on published hotfix.
- Gym Guide Rare Candy selector established in earlier runtime testing.
- Earlier beta.25 passes: No PP Items, No Escape, battle healing restriction, Field Heal restriction, Nickname Rule, No PokéCenter, No Repels, No X Items.
- Yellow beta.26: starting Rare Candies and starting Money apply correctly.
- Yellow beta.26: Trainer Card has only vanilla + NUZ STATUS pages; immutable start Money/Balls/Candies appear inside NUZ STATUS.
- Yellow beta.26: forced starter nickname works.
- Yellow beta.26: pre-Ball shiny encounters with Shiny Clause ON or OFF do not consume the route.
- Yellow beta.26: PokéCenter healing toggle works correctly.
- Blue beta.26 line: Pokédex handoff activates the route ledger and configured starting Balls appear in the home PC.
- Mom heal ON/OFF, No Field Heal ON/OFF, No PokéCenter ON/OFF and No Escape have additional beta.26-development runtime evidence.

## Implemented / active beta.26 systems

- Soft Start / first usable Poké Ball permanently arms encounter rules.
- Deferred configured starting Poké Balls until the verified Pokédex handoff boundary.
- Route-ledger activation at the same boundary.
- Encounter-state cleanup work around first arm.
- Starter canonicalization work toward a single Pallet Town entry.
- Failed-encounter tracker-state groundwork.
- Immutable Run Start snapshot for Money/Balls/Candies inside NUZ STATUS.
- Gold-specific reduced BETA SETUP surface and beta-aware descriptions.
- Forced scripted starter/gift naming when Nickname Rule is ON.
- Rival T3 timing improvement after trainer reveal.

## Planned soon — beta.26.x

Priority work should be added in small isolated revisions with the startup hard gate rerun after each batch.

- Repair **No Buying / No Selling** against the live Gen1Recomp 0.1.79 Mart path without disturbing the previously passing shop architecture.
- **Dialogue ownership/formatting pass**:
  - replace Mom's vanilla rest text entirely when No Mom Heal owns the interaction;
  - investigate repeated/near-duplicate Oak and rival lines around the opening/Pokédex handoff;
  - fix missing spacing/line breaks;
  - fix Viridian Mart first-entry Shop Clerk formatting;
  - audit battle/world-building messages for native wrapping and advanceable paging.
- Update Pokédex-hand-off Ball wording to explicitly say the challenge Poké Balls are **waiting in the PC at home**, while preserving the already-working delivery boundary.
- Rival World Building polish: final target is after trainer reveal but before the opponent Pokémon is sent out.
- Explicit pre-Pokédex starter Catch Info verification/fix so the starter says **Pallet Town** immediately, not only after later cleanup.
- Add T2/T3 dialogue variety for Mom, Pokémon Center, Buying and Selling denial paths.
- Port/fix explicit gift/trade classification and recovery type preservation.
- Expandable/collapsible rule categories and navigation improvements.
- No TMs; HMs unaffected.
- Player No Status Moves.
- Trainer No Status Moves.
- Permanent Lock beta with two-step confirmation and beta warning.
- Conservative MissingNo/glitch handling.
- Mt. Moon / dungeon encounter grouping: one encounter for whole dungeon vs per-floor.

## Planned future

- Rare Candy use restriction: block **using** Rare Candy while still allowing acquisition/storage/tossing and buying/selling when other rules permit, mirroring the No TMs philosophy.
- Trainer Team Boost / difficulty scaling: stronger and/or expanded trainer teams, provider-aware and version-safe.
- No Exit dungeon/gym challenge with explicit softlock safeguards.
- Field-item randomization.
- Gym Leader TM reward randomization.
- Broader Ironmon-style randomized resource/item/move options with separate toggles.
- Maximum BST restriction.
- No Catching.
- No Evolution.
- No Trade Evolutions.
- Static encounter controls.
- Trainer item restrictions.
- Perfect DV/EV/IV options where supported.
- Game Corner prize controls.
- Alternate-start capability/provider integration.
- Special battle classifier.
- Recovery editor improvements.
- Safari Zone / route-split research beyond Mt. Moon.
- Pseudo-legendary classification controls.
- Town Map / richer encounter-history integration.
- Older Gen1Recomp compatibility through feature detection rather than version assumptions.

## Known bugs / open regressions

- Gen1Recomp 0.1.79: No Buying / No Selling currently do not enforce and produce no denial dialogue.
- Yellow: No Mom Heal blocks healing but vanilla rest dialogue plays first.
- Opening Professor Oak / rival World Building text can repeat, appear as slightly different duplicates, or have bad spacing around the early-game/Pokédex sequence.
- Yellow Viridian Pokémart first-entry Shop Clerk dialogue has a spacing/line-break problem.
- Rival T3 timing is improved but needs final placement before the opponent Pokémon appears.
- Starter location needs one explicit pre-Pokédex verification; post-Pokédex Pallet Town is confirmed in Yellow.
- Some battle/world-building denial text has historically overflowed native textboxes or bypassed normal paging; continue auditing.
- Gold gameplay options remain individually runtime-test-required unless separately marked passed.
- Actual-money vs Trainer Card current-money mismatch was observed once in a save-editor-contaminated test and remains unconfirmed.

## Development rule

Every new revision is created only from the immediately previous revision. Runtime-passing paths are protected. Older branches are never restored wholesale; only specific missing changes may be ported after comparison.
