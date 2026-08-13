# Nuzlocke 2.0

A configurable, enforced Nuzlocke ruleset for **Pokémon Gen1Recomp**, focused first on **Red, Blue, and Yellow** with **Gold beta support**.

**Release candidate:** `2.0.0-beta.29.1.0`  
**Targeted Gen1Recomp:** `0.1.83`  
**Games:** Red, Blue, Yellow, Gold  
**Gen1Recomp Mod API:** `2` · **Nuzlocke Compatibility API:** `25` · **Save schema:** `4`

This candidate is built directly from beta.29.0.2. It preserves beta.29.0.2 gameplay behavior while adding an exact-source compatibility profile for Gen1Recomp 0.1.83 and widening the declared engine range for the upcoming runtime certification pass.

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
- **Route 1–25, Mt. Moon, and Safari Zone encounter splitting** for R/B/Y.
- **Random Starter** while preserving the surrounding story choice path.
- **Legendary, Mythical, Pseudo, Maximum BST, Static, Glitch, Gift, and Trade controls**.
- **Player/Wild/Trainer starting Stat EXP presets**, **No Player Stat EXP Gain**, and independent **Perfect Player/Wild/Trainer DV** controls.
- **Battle restrictions** for healing items, X items, escape, and cumulative Ball tiers.
- **Field restrictions** for Repels, Escape Rope, healing, PP items, TMs, and Rare Candy.
- **Challenge rules** for buying, selling, Pokémon Center healing, Mom healing, Whiteout, and Solo Only.
- **R/B/Y Gym Guide Rare Candy** utility with repeatable selectable batches.
- **Quality-of-life controls** including Default Names, Gold Skip Catch Demo, Catch Info, Area Guide, and B-button running.
- **Save Editor-aware loader handling**, stable Pokémon identity/provenance, and compatibility APIs for other mods.
- **Gold beta support** with generation-specific adapters and conservative unsupported-path handling.

## Recent major additions

The current development line has added or substantially hardened:

- independent Player/Wild/Trainer Stat EXP and DV controls;
- **No Pseudos** and **Maximum BST** acquisition rules;
- Route 1–25, Mt. Moon, and Safari encounter-area splits;
- live merged-roster level-cap discovery;
- First Rival Mercy, No Static, No Gambling, and glitch-species handling;
- dynamic trainer-party and temporary-party Permadeath/Whiteout compatibility;
- Save Editor session separation and restart-safe gameplay rebinding;
- clearer **ENC TRACKER** / **NUZ RULES** menu naming and collapsible rule sections;
- a public compatibility API, translation surface, provider contracts, and capability relationships;
- dedicated Red/Blue/Yellow/Gold feature-confidence and versioned compatibility documentation.

For the exact per-build history, see [CHANGELOG.md](CHANGELOG.md). Public documentation-only changes and their rationale are tracked separately in [docs/DOCUMENTATION_CHANGELOG.md](docs/DOCUMENTATION_CHANGELOG.md).

## Runtime evidence and regression protection

Runtime-confirmed behavior is treated as the strongest project evidence and is protected from unrelated changes. Current evidence includes fresh-run and existing-save Setup behavior, rule-selection and collapsible-section behavior, shop and item restrictions, encounter tracking, nickname enforcement, Save Editor restart handling, and other core rule paths. When implementation touching a runtime-confirmed path changes, the historical pass remains recorded but the changed path requires renewed regression consideration before current-version confidence is raised again.

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

## Planned work

The backlog is intentionally driven by confirmed bugs, runtime evidence, version parity, compatibility needs, and project priorities. **R/B/Y is the first priority; Gold advances as its support matures; Silver/Crystal remain later work.** Only project-owner decisions determine what stays, moves, is deferred, or is removed from this list.

### In progress

- Native directional glyphs for collapsible rule headers.
- UI-theme composition for Setup, NUZ RULES, ENC TRACKER LOG/MAP, R/B/Y NUZ STATUS, and CATCH INFO.
- Backward-compatible separation of **lost encounters** from Pokémon **deaths** in status/history presentation.
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

## What changed in beta.29.1.0

- Built directly from beta.29.0.2 with **no intended gameplay behavior change**.
- Audited the exact Gen1Recomp 0.1.83 source for every protected engine seam used by Nuzlocke, including Gen 1 battle/item/shop/save hooks and Gold battle/script/UI adapters.
- Added explicit engine profiles for Gen1Recomp 0.1.82 and 0.1.83; the current audited profile is now 0.1.83.
- Widened the manifest engine range to `>=0.1.81 <0.1.84` so the candidate can be runtime-tested on the current 0.1.83 release.
- Kept Gen1Recomp Mod API 2, Nuzlocke Compatibility API 25, compatibility floor 10, and save schema 4 unchanged.
- Kept the existing ENC TRACKER implementation intact. Gen1Recomp 0.1.83's new Gold `mapOverview()` surface is additive and is recorded as a future public-seam migration opportunity rather than a reason to rewrite runtime-proven tracker behavior immediately before release.
- Recorded the Mod Manager runtime evidence: manual beta.29.0.2 import/discovery worked on 0.1.83; the old `<0.1.82` gate correctly blocked gameplay; and pressing Update on an unpublished local candidate installed the latest published Nuzlocke release instead.
- Recorded the current Gen1Recomp beta-tag update-comparison limitation so it is not mistaken for a Nuzlocke gameplay failure.

## Reporting a bug

Please include the Nuzlocke version, Gen1Recomp version, game, save type, relevant rules/preset, other enabled mods when relevant, exact reproduction steps, expected/actual behavior, and whether a full Gen1Recomp restart changes the result.

The repository preview includes structured bug-report and feature-request forms under `.github/ISSUE_TEMPLATE/`.

## Credits

- **bryanthaboi** — original Nuzlocke mod and project baseline.
- **Stone696** — updater of bryanthaboi's original Nuzlocke mod.
- Built for **Gen1Recomp** and its native mod platform.

Pokémon and related names are trademarks of Nintendo / Creatures Inc. / GAME FREAK inc. This fan-made mod contains no ROM.
