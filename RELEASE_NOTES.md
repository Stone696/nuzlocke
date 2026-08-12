# Nuzlocke 2.0.0-beta.27 Release Notes

beta.27 is promoted **directly from beta.26.6** and is the new canonical public baseline.

The promotion intentionally changes only release/version metadata. Gameplay logic is unchanged from the beta.26.6 test build.

## Newly recorded runtime evidence

- Gold fresh startup and New Game -> house: PASS.
- Gold in-game RULES: PASS.
- Gold in-game TRACKER: PASS.
- Gold Catch Info: PASS.
- Gold Cyndaquil starter acquisition: PASS.
- Yellow beta.26.6 RULES/TRACKER: PASS.
- Yellow beta.26.6 catch behavior / encounter tracking: PASS.
- Yellow beta.26.2 1st Catch toggle after an area's first encounter: PASS.

## Known Gold limitations at release

- Forced Nicknames currently FAIL on Gold; starter acquisition did not open a nickname prompt.
- Gold's native Trainer Card already has two sides, so the R/B/Y NUZ STATUS back-side design does not appear. A Gold-native access design is required.
- Ordinary Gold gift denial is still runtime-test-required.
- Gold Whiteout run termination is still runtime-test-required.

## Other open validation

- Gen 1 Whiteout teardown/save deletion.
- fallback/external gift/trade classification.
- failed-result marquee and progression-aware T3 TV.
- battle-text wrapping/paging.
- Yellow battle-lag A/B profiling.

## Development lineage

beta.27 is now the protected baseline. Future builds must be created only from the immediately previous numeric revision:

- beta.27.1 from beta.27
- beta.27.2 from beta.27.1
- and so on.

README.md and CHANGELOG.md remain separate and retain the protected documentation style unless explicitly changed by the user.
