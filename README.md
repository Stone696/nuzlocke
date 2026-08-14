# Nuzlocke 2.0

A configurable, enforced Nuzlocke ruleset for **Pokémon Gen1Recomp**, focused first on **Red, Blue, and Yellow** with **Gold beta support**.

**Release candidate:** `2.0.0-beta.29.2.7`  
**Targeted Gen1Recomp:** `0.1.83`  
**Games:** Red, Blue, Yellow, Gold  
**Gen1Recomp Mod API:** `2` · **Nuzlocke Compatibility API:** `25` · **Save schema:** `4`

This release candidate is built directly from beta.29.2.1. It preserves the Gen1Recomp 0.1.83 profile, starting-money correction, LOST-vs-DEATH split, deterministic encounter projection, native collapse glyphs, and Gym-Leader Permadeath hardening while adding Gym/Dungeon Lock-In rules and broader live trainer-roster cap discovery.

## Feature highlights

Nuzlocke 2.0 is more than a first-encounter/permadeath toggle. The current beta line includes:

- **Fresh-run Nuzlocke Setup** with presets and collapsible rule categories.
- **Separate R/B/Y and Gold Setup profiles**, rule locking/saving, legacy catch recovery, and R/B/Y starting Money/Poké Ball/Rare Candy controls.
- **NUZ RULES** for active-save rule review and supported editing.
- **Permadeath, Whiteout, One Per Area, Failed Encounters, Nickname Rule, Dupes Clause, and Shiny Clause**.
- **Encounter Tracker** with LOG/MAP-style views and persistent encounter provenance.
- **R/B/Y NUZ STATUS** on the Trainer Card plus a Gold Start-menu status surface.
- **Catch Info** for tracked owned Pokémon.
- **Live level caps** that can follow the final merged trainer rosters.
- **Independent Route 2, Route 10, Route 20, Mt. Moon, and Safari Zone encounter splitting** for R/B/Y.
- **Random Starter** while preserving the surrounding story choice path.
- **Legendary, Mythical, Pseudo, Maximum BST, Static, Glitch, Gift, and Trade controls**.
- **Player/Wild/Trainer starting Stat EXP presets**, **No Player Stat EXP Gain**, and independent **Perfect Player/Wild/Trainer DV** controls.
- **Battle restrictions** for healing items, X items, escape, and cumulative Ball tiers.
- **Field restrictions** for Repels, Escape Rope, healing, PP items, TMs, and Rare Candy.
- **Challenge rules** for buying, selling, Pokémon Center healing, Mom healing, Whiteout, Solo Only, **Gym Lock-In**, and conservative **Dungeon Lock-In**.
- **R/B/Y Gym Guide Rare Candy** utility with repeatable selectable batches.
- **Quality-of-life controls** including Default Names, Gold Skip Catch Demo, Catch Info, Area Guide, and B-button running.
- **Save Editor-aware loader handling**, stable Pokémon identity/provenance, and compatibility APIs for other mods.
- **Gold beta support** with generation-specific adapters and conservative unsupported-path handling.

## Recent major additions

The current development line has added or substantially hardened:

- independent Player/Wild/Trainer Stat EXP and DV controls;
- **No Pseudos** and **Maximum BST** acquisition rules;
- independent Route 2, Route 10, Route 20, Mt. Moon, and Safari encounter-area splits;
- live merged-roster level-cap discovery, including bounded nested roster containers used by trainer-content modifications;
- Gym Lock-In and conservative multi-exit Dungeon Lock-In enforcement;
- First Rival Mercy, No Static, No Gambling, and glitch-species handling;
- dynamic trainer-party and temporary-party Permadeath/Whiteout compatibility;
- Save Editor session separation and restart-safe gameplay rebinding;
- clearer **ENC TRACKER** / **NUZ RULES** menu naming and collapsible rule sections;
- a public compatibility API, translation surface, provider contracts, and capability relationships;
- dedicated Red/Blue/Yellow/Gold feature-confidence and versioned compatibility documentation.

For the exact per-build history, see [CHANGELOG.md](CHANGELOG.md). Public documentation-only changes and their rationale are tracked separately in [docs/DOCUMENTATION_CHANGELOG.md](docs/DOCUMENTATION_CHANGELOG.md).

## Runtime evidence and regression protection

Runtime-confirmed behavior is treated as the strongest project evidence and is protected from unrelated changes. Current evidence includes fresh-run and existing-save Setup behavior, rule-selection and collapsible-section behavior, shop and item restrictions, encounter tracking, nickname enforcement, Save Editor restart handling, and other core rule paths. When implementation touching a runtime-confirmed path changes, the historical pass remains recorded but the changed path requires renewed regression consideration before current-version confidence is raised again.

### Development-history recovery

The cumulative changelog is reconciled against preserved source, packages, runtime evidence, and retained development records. Exact per-build attribution is preserved only where supported; conflicting or incomplete historical records remain labeled rather than silently rewritten. The repository-only history audit keeps that recovery work durable for future releases.

## Quick start

1. Fully close Gen1Recomp before replacing an older Nuzlocke build.
2. Install the mod as the `nuzlocke` mod folder or import the packaged mod through Gen1Recomp's supported mod flow.
3. Start Gen1Recomp.
4. For a fresh run, open **SETUP** before **NEW GAME**.
5. Choose a preset or configure rules individually.
6. For an existing save, use **NUZ RULES** to review the active ruleset.
7. Use **ENC TRACKER**, **NUZ STATUS**, and **CATCH INFO** during the run.

**Save Editor note:** after editing a save, fully quit and relaunch Gen1Recomp before judging gameplay-rule behavior. The Save Editor and gameplay loader sessions are intentionally kept separate.

## Presets

| Preset | Intended use |
|---|---|
| **CUSTOM** | Build the ruleset manually. |
| **NUZ** | Classic Nuzlocke core rules. |
| **HARD** | Nuzlocke plus Champion-level caps and battle healing/X-item restrictions. Use Gen1Recomp's native SET battle style if you also want that convention. |
| **SOLO** | Nuzlocke plus Solo Only and Whiteout. |

## Main screens

**NUZLOCKE SETUP** configures the next new run. **Up/Down navigates** and **A or Left/Right changes supported boolean/multi-state rules**. Sections are collapsible.

**NUZ RULES** presents the active-save rule state using the same rule definitions as Setup.

**ENC TRACKER** records encounter areas and provides history/map-style views. R/B/Y split modes preserve the underlying physical-map provenance so changing the projection does not erase canonical encounter history.

**NUZ STATUS** summarizes run state. Red/Blue/Yellow use the Nuzlocke side of the Trainer Card; Gold preserves its native Trainer Card and uses a Start-menu status surface.

**CATCH INFO** exposes stored encounter/origin information for supported owned Pokémon.

## Full user guide

The complete player manual is in **[docs/USER_GUIDE.md](docs/USER_GUIDE.md)**. It covers installation and updating, controls, Setup, every rule, presets, encounter tracking, Catch Info, status terminology, level caps, existing saves, Save Editor behavior, Gold beta support, troubleshooting, and bug-report information.

## Screenshots

The public presentation is intended to use **authentic Gen1Recomp runtime captures**. This candidate includes no placeholder screenshots.

Before public publication, the preferred capture set is:

- Gold Setup with expanded/collapsed categories;
- Yellow NUZ RULES with a multi-state/numeric selector;
- ENC TRACKER LOG and MAP;
- R/B/Y Trainer Card NUZ STATUS;
- CATCH INFO;
- one clear rule-enforcement message;
- Gold Start-menu Nuzlocke status.

Repository capture guidance is kept in `docs/screenshots/README.md` and is excluded from the player package.

## Support status

| Game | Current position |
|---|---|
| **Red** | Primary support target. |
| **Blue** | Primary support target. |
| **Yellow** | Primary support target with extensive current runtime evidence. |
| **Gold** | Beta support; smaller surface and more TEST REQUIRED paths. |
| **Silver / Crystal** | Not currently declared or supported. Future investigation only after R/B/Y and Gold maturity. |

The complete evidence-weighted matrix is in [docs/FEATURE_CONFIDENCE.md](docs/FEATURE_CONFIDENCE.md). Percentages are confidence estimates based on runtime, behavior-test, compile/load, and static evidence—not measured failure rates.

## Compatibility

The candidate targets **Gen1Recomp `>=0.1.81 <0.1.84`**. Gen1Recomp 0.1.82 and 0.1.83 were source-audited against the protected Nuzlocke battle, item, shop, save, UI, and Gold script seams. Exact 0.1.83 gameplay runtime certification is still required before release approval.

Versioned third-party compatibility evidence and known UI-theme limitations are documented in [docs/COMPATIBILITY.md](docs/COMPATIBILITY.md). A newer third-party release never automatically inherits confidence from an older tested version.

## Developer integration

Other mod authors can use Nuzlocke's compatibility API instead of reverse-engineering internal state. [docs/API.md](docs/API.md) documents `nuzlocke_compat` v25, policy queries, level-cap providers, species metadata, Pokémon identity, battle classification, encounter projection, starter randomization, capability relationships, and shared-seam etiquette.

## Reviewed fixes awaiting runtime confirmation

The pre-runtime code-review batch is implemented in this candidate. Because these paths changed after earlier runtime evidence, they remain explicit runtime-test targets before approval:

- First Rival Mercy no longer writes unused `armed` / `triggered` save telemetry; the durable one-shot `battle_seen` state and battle-local forgiveness flags remain authoritative.
- Mandatory scripted starter/gift nicknames now synchronize the matching `nuzlocke_history` row after naming completes on R/B/Y and Gold without moving acquisition registration across the naming lifecycle.
- Gold scripted `givepoke` tracking now detects a newly owned Pokémon in either the party or PC boxes, so full-party gifts can still receive initialization, tracker/history registration, area consumption, and Nickname Rule handling.
- Scripted-static pending provenance is now consumed by the next battle event even when that battle is a trainer battle, preventing the marker from leaking forward into a later unrelated wild encounter.

These are implementation fixes, not runtime PASS claims. The targeted regression matrix is kept in the repository-only testing ledger.

**Current runtime priority:** beta.29.2.7 inherits the beta.29.2.1 Gym-Leader Permadeath reconciliation and beta.29.2.2 lock-in/trainer-cap hardening. Those paths still require their targeted runtime matrices before release approval.

## Planned work

The backlog is intentionally driven by confirmed bugs, runtime evidence, version parity, compatibility needs, and project priorities. **R/B/Y is the first priority; Gold advances as its support matures; Silver/Crystal remain later work.** Only project-owner decisions determine what stays, moves, is deferred, or is removed from this list.

### In progress

- Native directional glyphs for collapsible rule headers.
- UI-theme composition for Setup, NUZ RULES, ENC TRACKER LOG/MAP, R/B/Y NUZ STATUS, and CATCH INFO.
- Authentic runtime screenshot set for the public repository.
- Gen1Recomp 0.1.83 runtime certification across the release-gate matrix.

### Planned

- Additional R/B/Y runtime parity and regression coverage.
- More behavior-level automated tests that assert stated rule effects.
- Continued compatibility-version refreshes and exact-version runtime combinations.
- Careful migration from private engine dependencies to equivalent stable public seams when proven safe.
- Continued Gold parity, field-rule, nickname, shop, and destructive-path testing.

### Under consideration / future

- **Wonderlocke** remains intentionally WIP/disabled until a safe, tested provider/transaction contract exists; it must not mutate Wonder Trade transactions while dormant.
- Optional battle-menu auxiliary shortcuts previously discussed during beta.28 development; not implemented or promised.
- Native Pokémon-icon rendering where it improves supported UI surfaces; previously discussed, not implemented or promised.
- Silver/Crystal investigation after R/B/Y is stable and Gold support is sufficiently mature.

## What changed in beta.29.2.7

- R/B random starter presentation now rewrites the selection confirmation to the persisted rolled species and keeps the Dex preview/reward on that same roll.
- Level-cap UI can preview a known runtime-composed trainer party before the battle, allowing Trainer Card and Encounter Log caps to follow active trainer-balance changes instead of waiting for the fight to start.
- Gym Lock-In and Dungeon Lock-In moved from World into the Ironmon/Hardcore challenge section.
- The optional early-lab rival line is shortened so it no longer repeats the later "toughen it up" idea.


- Replaces the blanket Route 1–25 CARDINAL split option with independent **Route 2 Split**, **Route 10 Split**, and **Route 20 Split** rules for R/B/Y.
- Explains why each route is commonly split: Viridian Forest separates Route 2, Rock Tunnel separates Route 10, and Seafoam Islands divide Route 20.
- Existing saves/profiles that had the old blanket Route Splits rule ON carry that intent forward to all three new rules.
- Legacy child-area history on every other route collapses conservatively to the parent route without deleting tracker rows or creating a new legal encounter.
- Mt. Moon and Safari split behavior is unchanged.
- Preserves all beta.29.2.3 finite-number hardening and beta.29.2.2 lock-in/trainer-cap behavior.
- Exact runtime migration/reprojection testing remains required before publication.

## What changed in beta.29.2.2

- Adds **Gym Lock-In**: supported Gym exits stay closed until the Leader is defeated.
- Adds conservative **Dungeon Lock-In**: the entrance used to enter a supported multi-exit dungeon is sealed until a different legitimate exit is reached.
- Active Dungeon Lock-In also blocks Escape Rope use without requiring the separate No Escape Rope rule.
- Adds tiered lock-in rejection messages while preserving a plain explanation when optional World Building flavor is OFF.
- Broadens live trainer-roster ace detection for compatibility with nested party/team/roster containers.
- Preserves beta.29.2.1 deterministic encounter re-projection and Gym-Leader Permadeath reconciliation.
- Level Cap Scope **POST** remains the current additional-content/postgame provider option.
- Exact runtime testing is still required before publication.

## Reporting a bug

Please include the Nuzlocke version, Gen1Recomp version, game, save type, relevant rules/preset, other enabled mods when relevant, exact reproduction steps, expected/actual behavior, and whether a full Gen1Recomp restart changes the result.

The repository preview includes structured bug-report and feature-request forms under `.github/ISSUE_TEMPLATE/`.

## Credits

- **bryanthaboi** — original Nuzlocke mod and project baseline.
- **Stone696** — updater of bryanthaboi's original Nuzlocke mod.
- Built for **Gen1Recomp** and its native mod platform.

Pokémon and related names are trademarks of Nintendo / Creatures Inc. / GAME FREAK inc. This fan-made mod contains no ROM.
