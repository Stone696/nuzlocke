# Nuzlocke 2.4.69 RC

2.4.69 RC is the strict child of **2.4.68 DEV**. It is a release-candidate consolidation build with no new gameplay feature added beyond the verified development head.

## 2.4.63 future-schema safe stop

- Newer-schema saves disable the shared Nuzlocke `active(...)` enforcement gate.
- Known save-repair/randomizer lifecycle writers also bail out while the safe stop is active.
- A session-only **NUZLOCKE PAUSED** message tells the player to return to the newer Nuzlocke build.
- The warning acknowledgement is not written into the incompatible save.

## 2.4.64 Dev hook health

- Dev Mode inspects 13 observable runtime adapters without importing modules just to test them.
- **HEALTHY** means Nuzlocke's recorded wrapper is the live top-level function.
- **CHAINED** means Nuzlocke's wrapper marker still exists but the current live function differs; this can be legitimate compatibility composition and is not automatically treated as broken.
- **MISSING** means the module is loaded but the expected Nuzlocke marker/wrapper is absent or incomplete.
- **PENDING** means the relevant module has not loaded yet and is not a failure.
- The self-test export includes a dedicated `[HOOK HEALTH]` section.

## 2.4.65 Dev lifecycle counters

- Counts six high-value lifecycle events while Dev Mode is enabled.
- Detects repeated delivery of the exact same event payload table and records it as a duplicate callback.
- Duplicate callbacks generate an immediate `lifecycle.duplicate` breadcrumb.
- `battle_delta` is exported for context but is not itself treated as a failure.
- `nuzlocke_dev.reset_lifecycle()` lets testers zero the counters immediately before a controlled reload test.
- Lifecycle state is session-only and never written into the Pokémon save.

## 2.4.66 Future-schema write diagnostics

- When a newer Nuzlocke save schema is loaded, the detector counts any attempted `mod.save:set(...)` call that still escapes the safe-stop guards.
- The detector records total attempts, first/last key, and per-key counts.
- The first attempt for each key emits a `safe_stop.write_attempt` breadcrumb while Dev Mode is enabled.
- The wrapper delegates the write unchanged; it is an observer, not a second write blocker.
- Use `nuzlocke_dev.reset_safe_stop_writes()` immediately before a controlled downgrade test.

## 2.4.67 Dev rule effectiveness

- Each applicable rule reports its configured value and whether it came from the save or the default.
- The effective value is resolved through the same `getConfigValue(...)` path used by the runtime UI/config layer.
- External ownership is resolved through the canonical delegation layer and includes owner plus relationship/capability context.
- The master Nuzlocke switch and future-schema support state are reported separately so they are not confused with per-rule normalization.
- The self-test export includes a dedicated `[RULE EFFECTIVENESS]` section.

## 2.4.68 Dev Randomizer integrity

- Scans every species-bearing slot in the currently applied Nuzlocke-owned encounter registry.
- Checks the same core legality used to build Random Encounter pools: generation mode, glitch/runtime safety, Type Locke/species bans/Maximum BST through `specialAcquisitionDenied(...)`.
- Externally delegated encounter randomizers are reported as **DELEGATED** rather than judged as Nuzlocke output.
- Content-provider slots explicitly excluded from Nuzlocke randomization are skipped.
- The self-test export includes `[RANDOMIZER INTEGRITY]`.

## 2.4.69 Release Candidate

This RC freezes the current gameplay/rule feature set and carries forward the full 2.4.x compatibility and diagnostic work. It is intended for broad runtime regression testing before a final release.

Release-candidate priorities:
- verify R/B/Y and Gold boot/new-game/save-game flows;
- verify protected core rule enforcement remains unchanged;
- verify Random Encounter legality under Type Locke/species bans/Maximum BST;
- verify future-schema safe-stop behavior with a copied synthetic schema-5+ save;
- verify Dev Mode exports for hook health, lifecycle, safe-stop writes, rule effectiveness, and Randomizer integrity;
- verify compatibility stacks do not create unexpected delegated/missing hook states.

## Current contract
- Audited Gen1Recomp: **0.2.1**
- Gen1Recomp Mod API: **2**
- Manifest range: **`>=0.1.86 <2.0.0`**
- Save Schema: **4**
- Compatibility API: **27**
- Games: Red / Blue / Yellow / Gold
- Player package: **15 existing files**


## 2.4.62 random encounter legality

- `speciesPool()` now routes candidate species through the canonical `specialAcquisitionDenied(...)` legality gate.
- Random Encounters therefore respect active Type Locke, No Legendaries, No Mythicals, No Pseudos, and Maximum BST settings.
- Similar-BST / stage balancing still applies only after legality filtering, so balance cannot reintroduce a species forbidden by the player's rules.
- Persisted random encounter choices are revalidated against the current legal candidate pool and rerolled deterministically when they are no longer legal. Mid-run Type Locke/BST/species-ban edits now trigger the existing randomizer reapply path immediately.
- If filtering produces no legal candidates, Nuzlocke restores/leaves the vanilla encounter registry rather than crashing.
- This build also synchronizes inherited runtime build metadata that remained at 2.4.60 inside the 2.4.61 package.
- The separately confirmed future-schema downgrade-safety issue is not included here and remains queued for a later sequential child.

## 2.4.61 persistence correctness

- `persistPermanentRuleSeal()` now validates storage availability and playthrough context, performs the durable `mod.storage` write, and only then sets `rules_locked` / `rules_permanently_locked` in `mod.save`.
- Failed durable writes no longer leave the current in-memory save state claiming a permanent seal that was never durably mirrored.
- Permanent Rule Seal remains WIP-disabled, so this is a dormant-path correctness fix with no intended live gameplay effect.
- 2.4.60 runtime crash diagnostics, 2.4.59 `pguard`/assertions, and 2.4.58 provenance/history behavior remain unchanged.

## 2.4.60 diagnostics

- Config/Setup screen `update` and `draw` exceptions now call `Dev.recordError` with the full `xpcall` traceback and current game context.
- The independent NUZ STATUS screen recovery path receives the same coverage with distinct `status_screen_update` / `status_screen_draw` labels.
- Existing deferred screen recovery and player-facing error dialogs are unchanged; diagnostic reporting is additionally wrapped in `pcall` so telemetry cannot turn a recoverable UI failure into a hard crash.
- No gameplay-rule or save-schema behavior changes.

## 2.4.59 diagnostics
- `Dev.pguard()` preserves ordinary guarded-call behavior while reporting selected thrown failures into the bounded Dev breadcrumb/snapshot pipeline.
- High-value coverage includes save upgrades, permanent-seal storage, compat/provider discovery, provider activity/context/recovery, and species-metadata fallback failure.
- Passive assertions now flag contradictory encounter ledgers and malformed Shiny Clause state.
- Legal finite-Shiny limit reductions are not treated as corruption, and mechanics-capability calculation is intentionally not guarded recursively.
- 2.4.58's 48-breadcrumb export and 16-report history remain unchanged.

## Current implemented highlights
- Core Nuzlocke rules, clauses, Type Locke variants, party/evolution limits.
- Randomizer controls and species-pool generation.
- Level-cap scope, EXP edging, Badge Boost toggle, Physical/Special Split.
- Current historical-inspired Difficulty set:
  - Red: SHIN HARD*, PURE RGB*
  - Blue: SHIN HARD*, BLUE KAIZO*
  - Yellow: YELLOW LEGACY*, SHIN-STYLE*
  - Gold: POLISHED*, LEGACY-STYLE*
- Gold-only **No Held Items**.
- Encounter Tracker / Nuz Info / Encounter Indicator.
- Dev Mode + DEV TOOLS using Gen1Recomp 0.2.x `mod.storage`.
- Rules/Setup wraparound plus section jump and collapse-all/expand-all.

## Rules/Setup navigation
- UP/DOWN wraps top ↔ bottom.
- SELECT+UP/DOWN jumps between section headers.
- A or LEFT/RIGHT controls one header.
- SELECT+LEFT collapses all.
- SELECT+RIGHT expands all.
- Numeric edit mode remains separate.

## Current TEST REQUIRED
- Gold No Held Items.
- Historical Difficulty teams/moves/AI/boss/DV/held behavior.
- Rules navigation in R/B/Y + Gold.
- Gen1Recomp 0.2.1 runtime smoke + Dev storage workflow.
- Shiny/encounter-slot combinations and tracker death projection.
- Gold rule parity and special-acquisition/service paths.
- Save Editor/provider/alternate UI compatibility.
- Forgiveness Token ¥1,000,000 settlement.

## Current unfinished backlog
Contained/medium:
- EXP Share Ban
- RNG Escape Mercy
- Force native Set Mode
- Safari Clause
- potential No Auto-Heal
- potential modern-provider No EV Gain

Potential Rules/Setup UI:
- sticky section header
- visible-position indicator
- remember cursor/scroll position
- native offscreen scroll indicators
- changed-value marker
- collapsed-section summaries

Larger:
- Egglocke
- progression-only / PC-locked catches
- Town Map Nuzlocke Log / overlay
- fuller Encounter HUD
- End/Abandon Run statistics
- Unlimited Bag Space
- multi-provider difficulty composition
- Split-Evolution Dupes behavior
- localization validation
- Gen1+Gen2 cross-generation expansion, then Hoenn investigation
- additional behavior-level automated tests

Wonderlocke and Permanent Rule Seal remain intentionally WIP/disabled.

## Documentation roles
- `CHANGELOG.md`: cumulative history
- `README.md`: current overview
- `RELEASE_NOTES.md`: current-build notes
- `docs/API.md`: current API/engine/storage contract
- `docs/COMPATIBILITY.md`: current parity + compatibility ledger
- `docs/DOCUMENTATION_CHANGELOG.md`: documentation history
- `docs/FEATURE_CONFIDENCE.md`: confidence/test ledger
- `docs/USER_GUIDE.md`: player-facing current behavior

## 2.4.57 capture-state integrity
Successful consumed catches are now monotonic across reconstruction/save: tracker/caught evidence can repair a conflicting FAILED state, while exempt `consumedArea=false` catches remain free and no new tracker history is invented.

## 2.4.58 diagnostics
Self-test exports include all 48 retained breadcrumbs. Verified RUN + SAVE keeps `latest` plus the newest 16 sequenced history snapshots. RELOAD SAVED reports READ success separately from genuine READBACK verification.