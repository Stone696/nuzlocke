## 2.5.23-DEV development note

This build specifically repairs fresh-New-Game Yellow regressions found during real-device 2.5.22 testing. Random Starter, the Pallet Town starter log/provenance transaction, No Mom Heal, and Skip Catch Demo should now all be live on the same fresh New Game path, including when the opening Professor Oak explanation is skipped.

### 2.5.23 runtime priorities
- Yellow fresh New Game with **Random Starter ON**: starter must not silently fall back to Pikachu when Pikachu is excluded by the selected pool; the same seed/settings must remain deterministic.
- Yellow with **Skip Catch Demo ON**: Oak's Pallet Pikachu capture demonstration must be skipped while the story still proceeds into Oak's Lab normally.
- After receiving the starter, confirm its encounter/tracker entry is **Pallet Town**, not UNKNOWN/Oak Lab.
- With **No Mom Heal ON**, Mom must refuse the healing transaction and must not restore HP/PP/status.
- DEV SELF TEST should report healthy `late_runtime_phase_2`, `oak_catch_demo_gate`, `rby_starter_transaction_gate`, and Mom-heal gate rows, with the selected setting rows matching the setup choices.

# Nuzlocke 2.5.23-DEV user guide

## 2.5.22-DEV development note

This reliability build does not change randomizer algorithm **v1** results or any challenge rule. It hardens Gen 1 text kerning across mod reloads and makes starter RNG read the same algorithm-version source as encounter/learnset RNG. If upgrading directly from a pre-2.5.22 build through a hot reload, the old kerning wrapper may require one full game/process restart because older builds did not record enough wrapper identity to remove it safely.

### 2.5.22 runtime priorities
- Fresh process, R/B/Y: confirm normal Nuzlocke/Modern UI text kerning still renders correctly.
- Reload Nuzlocke within the same process, then render Gen 1 text again; confirm spacing is applied once and no stale/double wrapper behavior appears.
- Use a known randomizer seed and starter settings in 2.5.21 and 2.5.22; confirm algorithm v1 chooses the same starter.
- Confirm NUZ STATUS / rules surfaces still show the current RNG version beside an active seeded randomizer.

## 2.5.21-DEV development note

Trainer rewards and progression bookkeeping now agree on how a boss trainer is identified. This primarily hardens compatibility with alternate trainer/provider payloads; no player-facing rule or save format changes.

### 2.5.21 runtime priorities
- Defeat a normal R/B/Y Gym Leader and verify progression/cap state advances normally.
- Defeat a Gold Gym Leader and verify the same.
- Re-check a Forgiveness Token Gym reward alongside progression so both systems agree on the defeated Leader.

## 2.5.20-DEV development note
Turning **Nuzlocke OFF** pauses challenge-rule consequences; it does not make the mod forget ordinary boss progression. If you beat a Gym Leader, Elite Four member, or Champion while the master switch is OFF, that supported-save progression remains synchronized for level-cap/status purposes when you turn Nuzlocke back ON. Failed encounters, Forgiveness Tokens/rewards, trainer-money challenge scaling, and Permadeath cleanup do not run while Nuzlocke is OFF. A save written by a newer unsupported Nuzlocke schema remains read-only to this older build.

### 2.5.20 runtime priorities
- With Nuzlocke OFF, defeat a Gym Leader, turn Nuzlocke back ON, and confirm progression/caps recognize the win.
- With Nuzlocke OFF, fail an otherwise eligible wild encounter; after turning Nuzlocke ON, confirm that area was not silently consumed.
- With Route Forgiveness configured, confirm F. TOKEN is unavailable while Nuzlocke is OFF and returns when ON.
- Confirm normal Permadeath/Failed Encounter/Forgiveness behavior is unchanged while Nuzlocke is ON.

## 2.5.19-DEV development note
This reliability build does not intentionally change player-facing rules. It strengthens downgrade/newer-schema read-only safety and compatibility diagnostics. Existing explicit rule choices remain unchanged.


## 2.5.18-DEV development note
This build hardens developer/compatibility metadata only. Player-facing rule behavior and Save Schema remain unchanged from 2.5.17; runtime regression testing is still recommended.

## 2.5.17-DEV quick reference

This child is development infrastructure only: no challenge rule, loadout, encounter behavior, save representation, or gameplay default intentionally changes from 2.5.16. Dev Mode SELF TEST now checks the machine-readable Rule Registry, Save Schema configuration descriptor, exact parent build provenance, and Compatibility API capability-version coverage.

### 2.5.17 runtime priority
- Open **DEV TOOLS -> SELF TEST** and confirm `rule_registry_descriptor`, `save_config_descriptor`, `build_provenance`, and `compat_capability_versions` report PASS.
- Normal gameplay smoke testing should behave exactly like 2.5.16; any gameplay difference is a regression rather than an intended feature.
- The repository CI/tests used for automated development checks are not part of the player mod package.

## 2.5.16-DEV quick reference

This is a reliability/compatibility diagnostics child of 2.5.15. No rule name, explicit saved choice, save schema, or public API number changes. Missing default-ON settings and the loadout label now use the same canonical defaults everywhere, while wrapper health is stricter across reload/rebind scenarios.

### 2.5.16 runtime priorities
- Reload/session smoke test: automatic default names in R/B/Y and Gold should still trigger exactly once.
- R/B/Y: legal/blocked catch plus one Permadeath faint; confirm no duplicate messages/death records after reload.
- Gold: Nickname Rule, No Buying/No Selling, and No Gambling should remain enforced after leaving/re-entering the mod/game session.
- With QoL Toggles installed: **No Repels ON** must prevent AUTO-REPEL consumption; OFF must leave AUTO-REPEL native.
- With Wilds of Kanto installed: test one allowed and one rejected overworld capture and confirm an allowed catch reaches normal Nuzlocke tracking/provenance once.
- Dev Mode hook health should show the relevant loaded critical seams as HEALTHY or explain CHAINED/PENDING rather than silently omitting them.

## 2.5.15-DEV quick reference

This build is a focused reliability child of 2.5.14. No player-facing rule names or defaults change. **Whiteout** now also applies to a full-party overworld poison wipe even when Permadeath is OFF. Gold **No Escape** now blocks the shared RUN roll correctly. New-game preset/loadout selection is explicitly persisted with the rest of the staged rules.

### 2.5.15 runtime priorities
- R/B/Y: Whiteout ON + Permadeath OFF, poison the full party to 0 HP; confirm the run ends and the save is deleted rather than continuing from the heal point.
- Gold: repeat the same field-poison Whiteout test.
- Gold ordinary wild battle: No Escape ON should produce the native failed-run result and spend the turn; OFF should allow normal escape rules.
- New Game: choose a named Nuzlocke Loadout, save/start, then confirm the active `NUZ RULES` loadout label matches the staged choice.
- R/B/Y + Gold PC: Party Size Limit should reject a withdrawal/MOVE into the party at the cap after a reload.
- Gold: smoke-test No Day Care, battle Whiteout, Headbutt encounter tracking, and forgiveness-token shop stock after leaving/re-entering the mod session.

## 2.5.14-DEV quick reference

This build is a focused correctness/lifecycle child of 2.5.13. For players, no rule was renamed and no explicit saved choice is changed. The visible difference on a missing/legacy key is that enforcement now agrees with the documented fresh defaults: One Per Area ON, Nickname Rule ON, Dupes FAMILY, Allow Gifts ON, and Allow Trades ON. Gold World Building also falls back to the documented T1 default when no explicit value exists.

### 2.5.14 runtime priorities
- R/B/Y randomized or compatibility-modified Oak starter: confirm Pallet provenance and Nickname Rule still apply, with no second starter transaction.
- R/B/Y catch: one legal catch, one rejected catch, and Ball Per Enc. if enabled; confirm no duplicate ball spend/refund.
- R/B/Y player faint/Whiteout: confirm one death record and normal native battle teardown.
- Gold catch/Ball use: confirm one legal and one rejected Ball path after load/reload.
- Legacy/missing-key profile if available: confirm NUZ RULES display and actual enforcement agree on the canonical defaults above.

## 2.5.13-DEV quick reference

Use **NUZ RULES** to change active-run settings and **ENC TRACKER** to review encounter status. Numeric selectors use LEFT/RIGHT or A to cycle unless they are intentional resource editors such as starting money/Balls/Candies.

Key current selectors:
- **Shiny Clause:** OFF / 1 / 2 / 3 / UNLIMITED. Fresh/new profiles default to **OFF / 0**; existing saves keep their stored value.
- **Encounter Ball Limit:** OFF / 1 / 2 / 3 / 5 / 10 legal Ball throws.
- **Randomizer Info Policy:** OPEN INFO / BLIND INFO.

For Dev Mode, **DEV TOOLS → VIEW REPORT** shows the live report and its **NZR4** code without requiring a new export. Blue 2.5.6 runtime confirms the saved-report View Report path no longer crashes across a fresh game session. 2.5.7 reformats the report for the native viewport: **REPORT CODE:** is followed by the complete NZR4 value across multiple hyphen-grouped lines, and long diagnostic IDs are hard-wrapped instead of clipping off-screen. Use RUN + SAVE only when exact free-form diagnostic text is required.

Field-item rule refusals now use blocking dialogue pages with narrow wrapping; press A to advance.

A randomized starter counts as the **Pallet Town** starter encounter regardless of which species the randomizer selected.




### 2.5.13 field-poison Permadeath test note
With **Permadeath ON**, a Pokémon that reaches 0 HP from overworld poison should now be recorded as a death and remain gone even if the engine subsequently performs its normal blackout heal/warp. The ordinary poison faint text and native blackout sequence should still appear. With **Permadeath OFF** or **Nuzlocke OFF**, field poison remains engine-owned vanilla behavior. This repair still needs runtime confirmation in R/B/Y and Gold.

### 2.5.12 Gen1Recomp 0.2.7 Gold compatibility
The public final encounter-registry view now follows Gen1Recomp's Gold `gen2Encounters` target. This matters to cooperative encounter-information tools (DexNav/guide/provider-style consumers) and does not change which encounters Nuzlocke itself rolls. Gen1Recomp 0.2.7 also adds time-dependent Gold fishing rows; day/night fishing should be runtime-smoke-tested with the current build.


### 2.5.11 World Building default
**World Building** defaults to **TIER 1** for fresh/missing selections. T1 gives clear rule feedback; T2 adds challenge personality; T3 adds region/NPC-aware flavor. Existing saves keep any explicit OFF/T1/T2/T3 choice.


### 2.5.10 Pokégear RULES and empty tracker views
On Gold with the Pokégear integration, **NUZ → RULES** shows four active rules at a time. If more than four rules are active, press **A** for the next rule page; the header shows `RULES x/y` and the footer shows `A:MORE` while additional pages exist. The final page may contain fewer than four rules and remains reachable.

If the current **ENC TRACKER** LOG/MAP data set contains no rows yet, the screen now says **NO ENTRIES YET** instead of leaving the list area blank. This is presentation-only and does not create an encounter entry.

### 2.5.8 Yellow setup/rules re-test
Yellow 2.5.7 runtime testing confirmed the loadout warning still overflowed its frame and Type Locke edits could still trigger the generic NUZ RULES update error. In 2.5.8, re-test a loadout change from Setup and cycle Type Locke OFF/MONO/DUO (plus a type lane if practical). The warning should stay entirely inside its border and Type Locke changes should complete without the “Please report this text” dialog.

**Route Forgiveness** now appears under **GENERAL**. This is menu organization only; token rewards/spending are unchanged.

A genuinely fresh/new profile now starts **Shiny Clause at OFF / 0**. This does not rewrite an existing save or an explicitly saved setup profile.

### 2.5.9 Yellow setup re-test
Yellow 2.5.8 runtime confirms **Shiny Clause = OFF / 0** on a fresh profile and confirms Type Locke can be edited in NUZ RULES. Saving Setup then exposed a separate scope bug in the Type Locke slot index. 2.5.9 repairs the setup/profile lookup and should be re-tested by selecting a Type Locke mode/types, saving Setup, starting the game, and confirming those selections persisted.

The loadout warning no longer hides undisplayed changes behind `+N MORE`. Use **UP/DOWN** to review every affected loadout-owned rule, **LEFT/RIGHT** to choose APPLY/CANCEL, **A** to confirm that choice, and **B** to cancel without changes.

Nuzlocke-owned setup/rules/status error messages now stop on explicit two-line pages. Press **A/B** to advance each error page manually so the complete diagnostic can be photographed or transcribed.

Section order places **GAME DIFFICULTY**, then **BATTLE MECHANICS**, immediately above **AREA SPLITS**.

## 2.4.78 Type Locke sizes and Catch Draft
Type Locke now ranges from MONO through HEXA: Monolocke (1), Duolocke (2), Trilocke (3), Quadlocke (4), Pentalocke (5), and Hexalocke (6).

With **Catch Draft OFF**, choose Type 1 through the number required by the mode. RANDOM resolves once into a concrete type and persists.

With **Catch Draft ON**, Type selectors are hidden. Opening catches are unrestricted while they fill the selected number of lanes from their actual runtime types. Each catch contributes one lane, preferring a not-yet-drafted type if a dual-type catch offers one. Gifts and trades do not fill lanes. The final drafted lane immediately activates normal Type Locke enforcement.

Turning Catch Draft ON during a run clears current manual lanes and begins a fresh draft. Lowering the mode trims higher lanes; raising it keeps drafted lanes and waits for additional catches.

## 2.4.77 external-mod compatibility note
2.4.77 does not add new gameplay rules. It consolidates the completed external-mod audit wave and shrinks the future audit queue. Source/static/expected classifications are not runtime certifications; when a companion mod is marked TEST REQUIRED, use the relevant Nuzlocke rule in a small throwaway/runtime test before relying on that combination for a run.

## Quick Start runtime note
R/B/Y Quick Nuzlocke Start has user runtime PASS evidence. It can hand control back outside the Pallet house before bedroom-PC items are collected. If you wanted those items, simply walk back inside and use the PC; the shortcut does not make them inaccessible.

## Indigo Plateau Conference
With IPC 1.1.0, tournament losses are CANLOSE eliminations rather than ordinary blackouts. IPC may heal surviving party members after the battle. Nuzlocke's Permadeath marker remains authoritative: a Pokemon already lost under Permadeath is removed again after external post-battle healing.

## Kanto Reforged level caps
Kanto Reforged 1.2.0 can enable its own permanent soft-cap system after you accept its Rare Candy stack. If your Nuzlocke Level Cap Scope is also active, Nuzlocke uses the stricter live cap from the two systems. Turning Nuzlocke Level Caps OFF does not turn KR's cap off.

## Engine compatibility policy
The supported manifest range remains `>=0.1.86 <2.0.0`. Compatibility audits can advance within that range without changing the maximum unless the project owner explicitly directs otherwise.

## Gen1Recomp 0.2.0
2.4.71 is the compatibility-audited child for Gen1Recomp 0.2.0. No player-facing rule changes are introduced by this compatibility pass. If you are testing this build, use Gen1Recomp 0.2.0 and report any boot, menu, save/load, battle, catch, or Gold-specific regression separately from ordinary rule behavior.

## 2.4.70 post-release note
2.4.69 was published as the full release. 2.4.70 is its strict post-release hardening child. Existing saves remain on Save Schema 4. If testing a downgrade from a future build, use a copy of the save; a newer Nuzlocke schema should pause enforcement and refuse Nuzlocke-owned persistent writes.

Deferred Starting Balls and Skip Catch Tutorial are also suspended while a newer-schema save is paused, so story/world-step shortcuts cannot mutate or advance unsupported state.

## Dev Mode Randomizer integrity
The Dev export now includes `[RANDOMIZER INTEGRITY]`. `PASS` means every scanned Nuzlocke-owned randomized encounter slot satisfies the current candidate legality. `WARN` includes exact slot paths/species/reasons. `DELEGATED` means another mod owns encounter randomization, so Nuzlocke does not judge its tables. `FALLBACK` means the active rule set produced zero legal randomized species, so the intentional 2.4.62 behavior retained/restored vanilla encounters rather than forcing an illegal candidate.

## Dev Mode rule effectiveness
The Dev export now includes `[RULE EFFECTIVENESS]`. Each row shows `configured`, its source, `effective`, `owner`, and `relationship`. A configured value that differs from the effective value is not automatically a bug: external delegation or normalization may intentionally neutralize/change it. Check the owner/relationship column first.

## Dev Mode future-schema write detector
For downgrade testing, enable Dev Mode, reset `nuzlocke_dev.reset_safe_stop_writes()`, then load/use a copied save whose Nuzlocke schema is newer than this build supports. The exported `[SAFE STOP WRITES]` section should ideally remain at `attempts=0`. Any nonzero value identifies an unguarded writer; in 2.4.70 that escaped `mod.save:set(...)` attempt is also blocked before persistence.

## Dev Mode lifecycle counters
The Dev export now includes `[LIFECYCLE]` with counts for ready/load/battle/catch/evolution events. `duplicate_callbacks` means the exact same event payload reached the diagnostic callback more than once. For reload testing, call `nuzlocke_dev.reset_lifecycle()` before the controlled test when possible, trigger known events after the reload, and inspect duplicate delivery. Pre-reload totals are not guaranteed to persist across a full main-chunk reload.

## Dev Mode hook health
The Dev self-test export includes `[HOOK HEALTH]`. `HEALTHY` is directly verified ownership, `CHAINED` means another live wrapper sits above or replaced the visible top-level function, `MISSING` means an expected marker is absent on an already-loaded module, and `PENDING` means the module has not loaded yet. `CHAINED` is evidence to inspect, not automatically a bug.

## Newer-save protection
If this older build opens a save written by a future Nuzlocke save schema, it displays **NUZLOCKE PAUSED** and suspends Nuzlocke enforcement/save repairs for that save. Return to the newer Nuzlocke build that wrote the save rather than continuing under the downgraded mod.

The published 2.4.69 release preserves the frozen 2.4.68 gameplay/rule surface and includes the accumulated passive Dev Mode diagnostics from the 2.4.59–2.4.68 development line.

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

## Translations
Nuzlocke follows Gen1Recomp's translation/fallback path for player-facing text where supported. In 2.4.80, Nuzlocke's own shared text wrapping was hardened for translated glyphs and accented/multibyte text.

### Brazilian Portuguese
`gen1_pt-br` v0.1.5 is recognized as an optional translation companion as of 2.4.82. Translation fallback and accented glyph-safe wrapping are supported, but Trainer Card, battle UI, Yellow flow and long translated labels remain runtime TEST REQUIRED.

### Encounter Ball Limit
Choose OFF, 1, 2, 3, 5, or 10 legal Ball throws per catchable encounter. OFF is unlimited and is the default. A/LEFT/RIGHT cycles the setting. Only legal attempted throws count; a Ball rejected by No Catching or another absolute capture restriction does not spend the budget. Once the budget is exhausted, further Ball use is refused without consuming the Ball. A new encounter receives a fresh budget.

### General section ordering
Party Size Limit and Gym Team Size are placed at the bottom of IRONMON. On Yellow, holding SELECT pages between section headers, while SELECT + LEFT/RIGHT opens or closes all section headers; both behaviors are runtime-confirmed.

### Cap Messages
Choose ALWAYS, BATTLE, or CAP with A/LEFT/RIGHT. BATTLE is the default and allows at most one blocked-EXP level-cap popup per battle. CAP allows one message for each distinct active cap until it changes; ALWAYS reports every blocked EXP transaction. This setting affects notification frequency only.

### Yellow Skip Catch Tutorial
Skips Oak's pre-lab Pikachu demonstration while preserving surrounding story progression, plus the later Viridian Old Man demonstration.

### Dev Report layout
On R/B/Y, long Dev Report rows wrap inside the native 160x144 screen and can be scrolled rather than being clipped or drawn beyond the frame.

### Diagnostic screen wrapping
Dev Report and Storage Info wrap long diagnostic rows inside the native viewport. UP/DOWN scrolling includes wrapped continuation rows, so long paths, history keys, capability names, and status fields remain readable without drawing outside the frame.

### Dev Report Code
Open **DEV TOOLS → VIEW REPORT** to generate a fresh live report. The second report line is `report_code=NZR1-...`; you can send that code with the game/build when reporting a problem. A/LEFT/RIGHT refreshes the live report and code.

The code losslessly carries the fixed diagnostic summary (PASS/WARN result bits, schema, core settings, hook/lifecycle/safe-stop/rule/randomizer counters). Free-form strings such as provider names, detailed hook text, rule rows and breadcrumbs are represented by fingerprints because arbitrary text cannot fit reversibly in a short seed-style code. Use **RUN + SAVE** only when a developer specifically needs those exact free-form strings.

### No Mom Heal
When ON, Mom must refuse to heal the party; when OFF, vanilla healing remains available. 2.4.94 adds lifecycle repair for stale command bindings and a `mom_heal_gate` Dev Report check. On R/B/Y, a healthy report should show this row as PASS.

### Field-item rejection messages
When a field item is blocked by a Nuzlocke rule, the rejection message pauses in normal dialogue pages instead of scrolling away automatically. Each page uses the native narrow dialogue width and at most two lines; press A to continue. Battle-item messages keep their normal battle presentation.

### Random Starter encounter location
The Pokemon you actually accept from Oak counts as the Pallet Town starter encounter regardless of what species Random Starter chose. Tracker and map use the committed accepted starter, not the vanilla starter species list.

### Legacy mod ID compatibility
For older mods that do not publish Nuzlocke capability metadata, automatic compatibility hints now accept both separated and compact multi-word IDs (for example `CATCH_HELPER` and `CATCHHELPER`).

### Shiny Clause and Encounter Ball Limit
These are numeric selectors, not booleans. 2.4.98 fixes an edit-path bug that could save either selector as OFF regardless of the value chosen. If an affected older build already stored a boolean artifact, the migration restores a safe canonical numeric value; reselect the desired mode if necessary.

### Encounter Ball Limit persistence
2.4.99 completes the numeric configuration path for Encounter Ball Limit. The Rules screen can now read back and display the saved selector value correctly after leaving and reopening the menu.

### Randomizer Info Policy display
OPEN INFO and BLIND INFO now round-trip correctly through the Rules UI. The underlying gameplay behavior was already using the stored numeric setting; 2.4.100 fixes the menu readback so the displayed mode matches the enforced mode.

### 2.5.2 Dev diagnostic note
Dev Mode now reports a warning if `randomizer_info_policy` is ever found in an impossible boolean or malformed numeric storage shape. It does not rewrite the value because no historical boolean encoding exists for this selector.

### Ball Per Enc.
**Ball Per Enc.** is in **BATTLE ITEMS** beside **No Catching**. It is hidden while No Catching is ON because Ball-throw budgeting has no active purpose when all catching is prohibited. When catching is allowed, choose OFF / 1 / 2 / 3 / 5 / 10. OFF is the vanilla default. A previously selected value is preserved while the row is hidden.

### Solo runs
There is no separate Solo Only rule anymore. Set **Party Size Limit** to **1**, or choose the SOLO loadout. The same party-limit system now governs catches, gifts, trades, and PC withdrawals consistently.

### Level-cap messages
Cap message frequency is no longer configurable. The mod shows one message per battle, at the first EXP award that is actually blocked or banked by the active cap.

### World Building default
New configurations default to **T1**. Existing saves keep their selected World Building tier.

### 2.5.5 Blue validation note
For a randomized Blue starter, Nickname Rule should force a non-default nickname and the received Pokémon should immediately appear as the Pallet Town starter encounter. If First Rival Mercy is ON, losing the Oak's Lab Rival battle should continue the native lab story after healing; it must not restart the opening sequence or offer another starter.

### 2.5.7 Dev Report layout re-test note
On R/B/Y, verify VIEW REPORT and STORAGE INFO after 2.5.7: every line should stay inside the bordered 160px surface, the full NZR4 code should be readable by joining the displayed hyphen-grouped lines, long playthrough/storage identifiers should wrap rather than clip, and UP/DOWN scrolling should still reach the final rows. This is presentation-only; the NZR4 code format itself remains v4.

The 2.5.6 saved-report View Report crash repair has Blue runtime PASS evidence across a full game restart. The shared ordinary NUZ RULES edit repair still needs runtime confirmation. Yellow 2.5.7 additionally exposed a Type Locke-specific edit error and loadout-warning layout failure; 2.5.8 contains static repairs for both and requires runtime confirmation.

### 2.5.6 Blue UI/Dev status
2.5.5 runtime testing found that changing multiple NUZ RULES could error in the shared post-write update path, and DEV TOOLS -> VIEW REPORT could crash. 2.5.6 contains targeted repairs for both. VIEW REPORT now has Blue runtime PASS evidence for reopening a saved report after a full game restart; ordinary LEFT/RIGHT/A NUZ RULES edits still need runtime confirmation. MOD COMPAT rule-name rows on the left are intentionally normal weight rather than pseudo-bold.
