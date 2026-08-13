# Internal Backlog and Runtime Audit

Internal engineering record. Repository/dev-only. Excluded from public/player packages via `docs/development/` in `.modkitignore`.

Date: 2026-08-13

## Evidence sources reviewed

- Current release-candidate source and documentation.
- Retained project-conversation history available in this workspace.
- Preserved development packages, release notes, test ledgers, and history-recovery records.
- Read-only repository history and metadata.
- Available runtime-test notes and compatibility records.

## Runtime evidence to preserve

Runtime-confirmed behavior remains the strongest regression evidence. Important preserved examples include:

- Gold pre-New-Game Setup.
- Gold collapsible Setup sections.
- Yellow existing-save rule selection and collapsible behavior.
- Save Editor modified Yellow save working after a full application quit/relaunch for No TMs and No Rare Candy.
- No Buying / No Selling runtime passes in the preserved tested combinations.
- Gym Guide Rare Candy offer/selector behavior in the preserved passing build.
- No PP Items, No Escape, No Healing Items, No Field Heal, Nickname Rule, PokéCenter, Repels, and X Item restrictions in their preserved tested combinations.
- First Rival Mercy and encounter-tracker cases recorded in the runtime ledger.
- Player/rival default-name skip behavior in the later development line.

When code touching one of these paths changes, preserve the historical PASS but lower current-version confidence until the changed path receives adequate regression validation.

## Current reviewed-fix status

The four substantive code-review findings were fixed in beta.29.0.2 and are carried into beta.29.1.0 unchanged. They are no longer unfixed code blockers; their affected paths remain runtime-regression targets:

1. First Rival Mercy inert telemetry removal.
2. Scripted starter/gift history nickname synchronization.
3. Gold party-plus-PC scripted-gift detection and area/history/nickname handling.
4. Single-use scripted-static provenance across intervening battles.

The detailed rationale and required tests remain in `CODE_REVIEW_HISTORY.md`.

## In-progress backlog

- Native directional glyphs for collapsible rule headers.
- UI-theme composition for Setup, NUZ RULES, ENC TRACKER LOG/MAP, R/B/Y NUZ STATUS, and CATCH INFO.
- Backward-compatible separation of lost encounters from Pokémon deaths in status/history presentation.
- Authentic runtime screenshot set.
- Gen1Recomp 0.1.83 runtime certification after the exact-source compatibility pass and manifest-range widening.

## Planned backlog

- Additional R/B/Y runtime parity/regression coverage.
- More behavior-level automated tests.
- Compatibility-version refreshes tied to exact versions and runtime combinations.
- Careful migration from private engine dependencies to equivalent stable public seams when proven safe, including evaluating the 0.1.83 Gold `mapOverview()` surface only after tracker equivalence is demonstrated.
- Continued Gold parity, field-rule, nickname, shop, and destructive-path testing.

## Under consideration / future

- Wonderlocke remains WIP/disabled until a safe tested transaction/provider contract exists.
- Optional battle-menu auxiliary shortcuts remain under consideration only.
- Native Pokémon-icon rendering remains under consideration only.
- Silver/Crystal investigation remains later work after R/B/Y stability and sufficient Gold maturity.

## Governance of backlog state

Project-owner decisions determine whether an item is in progress, planned, deferred, completed, or dropped. Completed work moves into durable version history; deferred or dropped work should retain an explicit historical status rather than disappearing silently.
