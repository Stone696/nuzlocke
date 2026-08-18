# Nuzlocke 2.4.69 RC user guide

## Release Candidate note
2.4.69 RC freezes the current feature set for regression testing. Existing saves remain on Save Schema 4. If testing a downgrade from a future build, use a copy of the save; a newer Nuzlocke schema should display the paused/safe-stop behavior rather than being rewritten by this RC.

## Dev Mode Randomizer integrity
The Dev export now includes `[RANDOMIZER INTEGRITY]`. `PASS` means every scanned Nuzlocke-owned randomized encounter slot satisfies the current candidate legality. `WARN` includes exact slot paths/species/reasons. `DELEGATED` means another mod owns encounter randomization, so Nuzlocke does not judge its tables.

## Dev Mode rule effectiveness
The Dev export now includes `[RULE EFFECTIVENESS]`. Each row shows `configured`, its source, `effective`, `owner`, and `relationship`. A configured value that differs from the effective value is not automatically a bug: external delegation or normalization may intentionally neutralize/change it. Check the owner/relationship column first.

## Dev Mode future-schema write detector
For downgrade testing, enable Dev Mode, reset `nuzlocke_dev.reset_safe_stop_writes()`, then load/use a copied save whose Nuzlocke schema is newer than this build supports. The exported `[SAFE STOP WRITES]` section should remain at `attempts=0`. Any nonzero value identifies a save key that still has an unguarded writer.

## Dev Mode lifecycle counters
The Dev export now includes `[LIFECYCLE]` with counts for ready/load/battle/catch/evolution events. `duplicate_callbacks` means the exact same event payload reached the diagnostic callback more than once. For reload testing, call `nuzlocke_dev.reset_lifecycle()` first, perform the reload, trigger one known event, and export the self-test.

## Dev Mode hook health
The Dev self-test export includes `[HOOK HEALTH]`. `HEALTHY` is directly verified ownership, `CHAINED` means another live wrapper sits above or replaced the visible top-level function, `MISSING` means an expected marker is absent on an already-loaded module, and `PENDING` means the module has not loaded yet. `CHAINED` is evidence to inspect, not automatically a bug.

## Newer-save protection
If this older build opens a save written by a future Nuzlocke save schema, it displays **NUZLOCKE PAUSED** and suspends Nuzlocke enforcement/save repairs for that save. Return to the newer Nuzlocke build that wrote the save rather than continuing under the downgraded mod.

2.4.69 RC preserves the frozen 2.4.68 gameplay/rule surface and includes the accumulated passive Dev Mode diagnostics from the 2.4.59–2.4.68 development line.

## 2.4.62 Random Encounter rule interaction
Random Encounters now build their species pool from species that are legal under the active Nuzlocke acquisition rules. Type Locke, No Legendaries, No Mythicals, No Pseudos, and Maximum BST therefore constrain Nuzlocke-owned randomized wild tables before Similar BST / evolution-stage balancing is applied. If no legal random species remain, the mod fails safely to vanilla encounter data instead of forcing an illegal candidate. Changing Type Locke, its selected types, Maximum BST, or the Legendary/Mythical/Pseudo bans mid-run reapplies Nuzlocke-owned encounter tables immediately.

## Rules/Setup navigation
- UP/DOWN wraps top ↔ bottom.
- SELECT+UP/DOWN jumps section headers with wraparound.
- A or LEFT/RIGHT collapses/expands one header.
- SELECT+LEFT collapses all sections.
- SELECT+RIGHT expands all sections.
- Numeric editing keeps its own controls.

## Current historical Difficulty profiles
- Red: SHIN HARD*, PURE RGB*
- Blue: SHIN HARD*, BLUE KAIZO*
- Yellow: YELLOW LEGACY*, SHIN-STYLE*
- Gold: POLISHED*, LEGACY-STYLE*

These profiles can improve live trainer teams, boss pressure, legal movesets, AI, trainer Stat EXP, DVs, BST pressure, and Gold held items. `*` means inspired behavior, not copied trainer tables.

## No Held Items — Gold only
Default OFF. GIVE is blocked, TAKE remains allowed, existing player-held effects are suppressed while ON, and enemy/trainer held items are unaffected. R/B/Y omits this rule.

## Dev Mode
Default OFF and diagnostics-only. In 2.4.60, recoverable NUZ RULES/SETUP and NUZ STATUS runtime crashes also retain their full traceback in the Dev breadcrumb/snapshot history before the on-screen message is shortened. Current DEV TOOLS uses Gen1Recomp 0.2.x `mod.storage`; no host path is promised. In 2.4.59, selected storage/save-upgrade/compat/provider exceptions automatically enter the Dev breadcrumb and snapshot trail. Read-only assertions also flag contradictory encounter ledgers and malformed Shiny state. These diagnostics do not change gameplay decisions.

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
- more behavior-level automated tests

Wonderlocke and Permanent Rule Seal remain WIP/disabled.

## Dev history
RUN + SAVE keeps `latest` and up to 16 sequenced reports for the active playthrough. Each report contains the full current 48-breadcrumb ring.
