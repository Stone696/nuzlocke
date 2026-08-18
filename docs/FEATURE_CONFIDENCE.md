# Nuzlocke 2.4.69 RC feature-confidence ledger

**STATIC/SOURCE PASS is not RUNTIME PASS.**

## 2.4.69 RC — STATIC/SOURCE PASS / FULL RUNTIME REGRESSION REQUIRED
- No new gameplay behavior relative to 2.4.68 DEV.
- RC packages the sequential development head for broad runtime validation.
- All protected historical runtime-PASS items remain protected expectations, but are not reclassified as freshly runtime-tested by this static RC pass.
- Recent 2.4.62–2.4.68 changes remain runtime-test-required where previously marked.


## 2.4.68 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Randomizer integrity audit is read-only and recursively scans the live encounter registry.
- The legality check composes generation mode, glitch/runtime safety, and canonical Nuzlocke acquisition legality.
- Delegated/opted-out content is excluded from Nuzlocke-owned violation judgments.
- Runtime validation required for inactive, owned-active, delegated, and intentionally constrained Random Encounter configurations.


## 2.4.67 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Rule-effectiveness audit is read-only and reuses canonical config normalization and delegation resolution.
- Applicable rules are generation-filtered; master/schema state is reported separately.
- Runtime validation required with clean ownership and at least one external delegated rule.


## 2.4.66 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- `mod.save:set(...)` is transparently observed only for future-schema safe-stop diagnostics; delegated write semantics remain unchanged.
- Any observed write attempt becomes a Dev assertion warning and is exported with per-key evidence.
- Runtime downgrade test target: synthetic/copied schema 5+ save with `safe_stop_writes.attempts == 0` throughout ordinary play/navigation.


## 2.4.65 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Six lifecycle counters are updated only by the existing Dev diagnostic listeners.
- Weak payload identity tracking detects repeated delivery without retaining event payloads indefinitely.
- `duplicate_callbacks > 0` is a self-test warning; `battle_delta` is context only.
- Runtime hot-reload/listener-stacking test still required.


## 2.4.64 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- `Dev.hookHealth()` inspects only `package.loaded` modules and therefore does not import/install a subsystem as a side effect of diagnostics.
- 13 generation-aware observable adapters are covered.
- CHAINED is informational; only MISSING contributes to the self-test warning aggregate.
- Runtime validation required in clean R/B/Y, clean Gold, and at least one compatibility stack where another mod wraps above Nuzlocke.


## 2.4.63 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Source review confirms `saveSchemaTooNew` now disables the shared `active(...)` enforcement gate.
- Known lifecycle writers identified in the downgrade audit are explicitly suppressed while the safe stop is active.
- Player warning is session-only and does not write acknowledgement into the newer-schema save.
- Runtime test required with a copied/synthetic save declaring schema 5+; verify no enforcement/repair writes and verify normal schema-4 saves remain unchanged.


## 2.4.62 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Random Encounter species pool now composes with canonical Nuzlocke acquisition legality before balance filtering.
- Static source review confirms persisted slot validation checks membership in the current candidate pool, so newly illegal saved choices cannot remain active; relevant mid-run legality edits also enter the existing randomizer reapply path.
- Static source review confirms an empty pool returns safely from encounter randomization after restoring the encounter snapshot.
- Runtime matrix still required for MONO/DUO/TRI Type Locke, each species ban, Maximum BST, balance modes, rule toggles mid-run, R/B/Y, and Gold.

## 2.4.60 — STATIC PASS / RUNTIME TEST REQUIRED

- Config/Setup and NUZ STATUS runtime crash handlers preserve full `xpcall` tracebacks in Dev diagnostics when enabled.
- Existing deferred recovery/dialog behavior remains unchanged.
- Runtime fault-injection is still required to confirm update/draw failures produce the expected breadcrumb/snapshot labels in R/B/Y and Gold.

## 2.4.59 — STATIC PASS / RUNTIME TEST REQUIRED
- Recursion-safe `Dev.pguard()` exists and preserves guarded-call result tuples.
- Ten selected high-value failure seams feed Dev error breadcrumbs/snapshots when Dev Mode is enabled.
- Provider species-metadata alternate-signature fallback remains intentional and does not warn when fallback succeeds.
- Encounter-ledger contradiction and malformed Shiny-state assertions are read-only.
- Mechanics-capability calculation remains unwrapped to avoid diagnostic recursion.
- 2.4.58 export/history logic is unchanged.
- Runtime test: force a synthetic provider/storage callback throw with Dev Mode ON and verify one bounded error + snapshot appears without a crash or recursive flood.

## 2.4.58 — STATIC PASS / RUNTIME TEST REQUIRED
- Pin-once battle encounter provenance.
- Full 48-breadcrumb export.
- Bounded 16-report history plus latest.
- Bare reload no longer fabricates readback verification.
- Test split-boundary catch/failure, Gold time split, save/reload, >16 exports/history pruning, READ/READBACK display.

## 2.4.57 launcher range + capture ledger — STATIC PASS / RUNTIME TEST REQUIRED
- Manifest accepts `>=0.1.86 <2.0.0`.
- Successful consumed-catch evidence is protected from FAILED downgrade.
- Capture ledger reconciliation runs before projection and save writes.
- Runtime save/reload tests are required on R/B/Y and Gold.

## 2.4.56 documentation integrity — STATIC PASS
- Documentation/metadata-only child of 2.4.55.
- Exact packaged `main.lua` load gate required.
- Auxiliary integrations and package tree unchanged.
- No runtime confidence is promoted by this build.

## Current TEST REQUIRED
- Gen1Recomp 0.2.1 R/B/Y + Gold smoke + Dev storage.
- Gold No Held Items (introduced 2.4.51).
- Historical Difficulty deepening (2.4.52 mechanics / 2.4.53 final profile set).
- Rules navigation (2.4.54–2.4.55).
- Limited Shiny / encounter-slot combinations.
- Encounter Tracker death projection.
- Save Editor/external-save reconciliation.
- Gold shared-rule parity.
- Forgiveness Token ¥1,000,000 settlement.
- Modern UI + Encounter Tracker historical crash regression.
- Gen9Dex/QoL/alternate UI/provider combinations.

## Historical build validity
- 2.4.38: compiler-invalid (>200 locals).
- 2.4.39: inherited compiler-invalid state.
- 2.4.40: repaired loadability.
- Current canonical packaged `main.lua` must pass the exact Lua load gate before handoff.

## Current historical Difficulty profile set
- Red: SHIN HARD*, PURE RGB*
- Blue: SHIN HARD*, BLUE KAIZO*
- Yellow: YELLOW LEGACY*, SHIN-STYLE*
- Gold: POLISHED*, LEGACY-STYLE*

## Backlog governance
Implemented features leave Planned in the same cycle. Live-but-unvalidated work belongs under Implemented / TEST REQUIRED, not Planned.
