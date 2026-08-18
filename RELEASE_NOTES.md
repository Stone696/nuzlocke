# Nuzlocke 2.4.69 RC — Release Candidate

**Parent:** 2.4.68 DEV  
**Save Schema:** 4  
**Compatibility API:** 27  
**Diagnostics API:** 1  
**Engine range:** `>=0.1.86 <2.0.0`  
**Games:** Red / Blue / Yellow / Gold

## Release-candidate scope

2.4.69 RC introduces no new gameplay feature. It promotes the exact sequential 2.4.68 development head into a release-candidate package and freezes the current feature surface for regression testing.

## Major functionality represented in this RC

- Configurable Nuzlocke core rules, clauses, hardcore restrictions, world/travel rules, setup resources, loadouts, Type Locke variants, area splits, difficulty controls, and Gold parity work.
- Random Encounter and starter randomization with rule-aware species legality.
- Maximum BST, species bans, Evolution Limits, Badge Boosts, Party Size Limit, Travel Restrictions, Limited Shiny Clause, and Historical Difficulty.
- R/B/Y and Gold UI/setup/status integrations plus compatibility/provider negotiation.
- Future-save-schema downgrade protection that pauses Nuzlocke enforcement/repair on a save written by a newer schema.
- Capture-ledger monotonicity and encounter-provenance protections.
- Dev Mode diagnostics: bounded breadcrumbs/history, runtime crash capture, hook health, lifecycle duplicate detection, future-schema write-attempt detection, rule effectiveness, and applied Randomizer integrity.

## Key recent fixes retained

- 2.4.62: Random Encounter pools now obey Type Locke, Legendary/Mythical/Pseudo bans, and Maximum BST through the canonical acquisition-legality path.
- 2.4.63: newer-schema saves trigger an actual runtime safe-stop rather than merely stopping migration.
- 2.4.64–2.4.68: read-only Dev Mode diagnostics expanded without intentionally changing gameplay behavior.

## RC validation required

This package has passed static Lua parsing, manifest/package checks, and structural source checks. It still requires broad runtime regression testing in R/B/Y and Gold, especially:
- boot, new game, existing save, setup, rules, status, and tracker screens;
- protected runtime-PASS rule paths;
- Random Encounter legality and mid-run legality changes;
- compatibility/provider ownership;
- synthetic future-schema safe-stop;
- Dev Mode self-test/export surfaces.

**Status:** RELEASE CANDIDATE — STATIC/SOURCE PASS / RUNTIME REGRESSION TEST REQUIRED.
