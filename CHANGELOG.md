# Changelog

## 2.0.0-beta.26 — Canonical baseline

The 26B10 development revision is promoted to the canonical **beta.26** baseline. No gameplay behavior was intentionally changed during this promotion; this is a versioning/documentation consolidation so future work can proceed as **beta.26.1, beta.26.2, ...** instead of lettered builds.

### Runtime evidence promoted with the baseline

- Blue NEW GAME SETUP: PASS.
- Blue fresh Oak intro -> bedroom: PASS.
- Yellow NEW GAME SETUP/startup path: PASS from the published/startup line and current beta.26 testing.
- Gold GOLD BETA SETUP visibility/presentation: PASS; gameplay options remain individually test-required.
- Yellow starting Money: PASS.
- Yellow starting Rare Candies: PASS.
- Yellow Trainer Card two-view design with Start Money/Balls/Candy inside NUZ STATUS: PASS.
- Yellow forced starter nickname: PASS.
- Yellow pre-Ball Soft Start with Shiny Clause ON: PASS; route not consumed.
- Yellow pre-Ball Soft Start with Shiny Clause OFF: PASS; route not consumed.
- Yellow PokéCenter healing ON/OFF: PASS.
- Blue Pokédex handoff -> route ledger activation -> configured starting Balls delivered to the home PC: PASS.
- Blue first legitimate post-activation encounter logging/capture behavior: PASS in the beta.26 development line.
- Earlier beta.25 runtime passes for Gym Guide Rare Candy, No PP Items, No Escape, healing restrictions, Nickname Rule, No PokéCenter, No Repels and No X Items remain protected.

### Included beta.26 work

- Preserves the published 25D4-RBY2 startup/menu white-screen hotfix.
- Soft Start / first-Ball encounter activation work.
- Deferred configured starting Poké Balls at the Pokédex handoff.
- Route-ledger activation feedback at the same boundary.
- Gold-specific reduced BETA SETUP surface and beta-aware descriptions.
- Mandatory scripted starter/gift naming when Nickname Rule is ON.
- R/B/Y starter canonicalization work toward Pallet Town.
- Immutable New Game start-resource snapshot shown inside NUZ STATUS.
- Two-page Trainer Card design only; no separate RUN START page.
- Rival T3 timing improvement so trainer reveal occurs before the added flavor line.

### Known issues carried into beta.26

- No Buying / No Selling do not currently enforce on the Gen1Recomp 0.1.79 test environment.
- No Mom Heal still allows vanilla rest dialogue before the Nuzlocke refusal.
- Opening Oak/rival text can repeat, duplicate or have poor spacing.
- Viridian Mart first-entry Shop Clerk text has a spacing/line-break problem.
- Rival T3 timing still needs final placement before the opponent Pokémon is sent out.
- Pre-Pokédex starter Catch Info location still needs explicit confirmation; post-Pokédex Pallet Town is confirmed in Yellow.
- General world-building/battle textbox wrapping/paging needs a dedicated cleanup pass.
- Gold gameplay adapters remain conservative and individually test-required.

---

## Internal beta.26 development history

The following lettered revisions are retained only as historical development notes. They are no longer the active versioning scheme.

### 26B10
- Restored Gold-mode state in the shared setup screen.
- Added Gold beta-aware header/descriptions and reduced setup surface.
- Forced scripted starter/gift nickname entry when Nickname Rule is ON.
- Moved R/B/Y starter handling toward immediate Pallet Town canonicalization.
- Queued rival/Gym T3 flavor behind the vanilla trainer reveal.

### 26B9
- Removed the separate RUN START Trainer Card page.
- Moved immutable starting Money/Balls/Candies into the existing NUZ STATUS list.

### 26B8
- Continued Soft Start boundary/starter cleanup.
- Added immutable starting-resource snapshot fields.
- Shortened encounter-used denial text.

### 26B7
- Added additional Soft Start state cleanup and failed-encounter tracker work.

### 26B6
- Initialization-safe Soft Start implementation; Blue and Gold SETUP visibility passed.
