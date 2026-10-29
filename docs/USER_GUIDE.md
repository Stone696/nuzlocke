> **Legacy Generation 1/2 guide.** This reference records the established pre-v3 rule system. For FireRed/LeafGreen/Ruby/Sapphire/Emerald, see the [Gen 3 feature matrix](GEN3_FEATURE_MATRIX.md), [overview](GEN3_PORT.md) and [manual test checklist](GEN3_TEST_CHECKLIST.md). Gen 3-specific differences are not retroactively applied to the historical instructions below.

<!-- Legacy Generation 1/2 reference: Nuzlocke 2.9.72 -->
# Legacy Generation 1/2 User Guide — 2.9.72

> This is the retained historical Generation 1/2 guide. For the current **v3.0.0-BETA** and Generation 3 options, see the [main README](../README.md) and [Gen 3 overview](GEN3_PORT.md).

## Supported games and confidence

Nuzlocke declares Red, Blue, Yellow, Gold, Silver, and Crystal. R/B/Y are the mature baseline; Gold/Silver are beta; Crystal is alpha. A Runtime PASS applies only to the exact edition and stack that was tested. Gen1Recomp `>=0.2.24 <2.0.0` is accepted, with source review current through 0.2.41. Gen1Recomp owns frame pacing/vsync/present synchronization; Nuzlocke does not override those engine settings.

## Controls and ownership

Nuzlocke-owned Setup/Rules screens use Up/Down for navigation, Left/Right for values/pages, A for confirm, and B for back. Numeric resources may use their documented numeric controls. Nuzlocke UI now exposes an explicit input-semantics contract: navigation/value stepping may be repeat-safe, while activation/back actions are edge-only and destructive confirmation is separately identified. The contract is descriptive and does not take over engine input-repeat timing, so compatible accessibility/hold-to-scroll mods can accelerate repeat-safe movement without being treated as owners of Nuzlocke actions. Presentation ownership is now also explicit: external Party/PC/Pokédex/Bag/Mart/battle-art/overworld renderers may own those visuals without acquiring Nuzlocke gameplay authority. Gold/Silver/Crystal keep the native Gen-II battle party and battle command routing; the optional Battle Menu UI is Gen I only. Nuzlocke does not replace native or companion-owned Bag, Party, PC, Pokédex, Mart, or battle presentation merely for visual consistency.

World Building defaults to **T3**. Player-facing Nuzlocke denials are player-paced where implemented rather than disappearing on a short timer.

## Randomizer

There are ten ownership methods: **Starter, Encounters, Field Items, Learnsets, Trainers, Evolutions, Shops, TM Contents, TM Locations, and Gift Items**. TM Contents changes what a TM teaches; TM Locations changes the TM item obtained from supported physical TM pickup sources and never moves HMs. Random Field Items keeps its historical broader behavior when TM Locations is off.

Compatible external Randomizers take ownership only when the overlapping feature is positively active. Installing one does not automatically disable the Nuzlocke option. Known Gen-II Random Trainer and Random Field Item runtime failures remain unresolved; do not treat their static diagnostics as a fix.

## Shiny behavior

Shiny Clause is always Nuzlocke policy. Shiny generation/presentation has one owner per edition/session: a healthy compatible external provider owns it when selected; otherwise Nuzlocke may use its built-in implementation. Gold/Silver/Crystal native shiny identity/presentation remains protected. Exact-edition certification still applies.

## Compatibility notes

- Kanto Ascendant 6.5.17 explicitly conflicts with standalone Nuzlocke and should use its integrated ASC RUN system instead.
- Wonder Trade is currently observed/reconciled after the swap; Wonderlocke is disabled because there is no safe pre-transaction seam.
- Useful Bag / Modern Bag UI / Bag Sort may own pockets, capacity, ordering, or presentation. Nuzlocke item legality is based on the actual item/action, not pocket or row position.
- Type/species providers compose through normalized merged species facts. Runtime typing is authoritative for concrete transformed Pokémon where available.
- Expanded/indexless species must be battle-safe before Randomizer inclusion; byte-addressed paths are not assumed safe.

## Dev Mode

Dev Mode is diagnostic-only unless a named tool explicitly says it changes state. Health, compatibility, hook-drift, Randomizer reproduction, transaction, performance, save/run identity, and bug-report views must not consume gameplay RNG, create unseen mappings, change ownership, or repair saves merely by being opened.

2.9.39 adds a structured internal rule-status explanation surface. It can distinguish catalog/structural presence, semantic/reconciliation evidence, exact-edition reachability, current operational/dependency state, and exact-edition runtime evidence. `RUNTIME PASS` is never inferred from source/static/semantic evidence or copied from another edition.

## Known WIP / unavailable

Wonderlocke remains disabled pending a safe pre-transaction Wonder Trade seam. Permanent Rule Seal remains WIP-disabled. Crystal is supported as an **alpha** target, not an unsupported edition.

## Difficulty Profiles — Full Mechanical Reference (2.8.72)

The in-game Difficulty chooser is intentionally concise. It is meant to help you choose a profile without turning Setup into a technical manual. This section is the authoritative player-facing explanation of every built-in Difficulty profile.

A profile changes trainer construction only. It does not rewrite the underlying trainer tables wholesale, and it does not disable an external trainer mod's own hooks. Historical names marked with `*` are inspired profiles, not byte-for-byte recreations of ROM hacks.

### How to read the profile numbers

**Trainer level scale.** A value such as `108/100` means the trainer's original level is multiplied by 108 and divided by 100, then rounded to the nearest whole level and clamped to 1–100. Example: level 25 becomes 27; level 50 becomes 54. Bosses can use a different scale.

**Team upgrade chance.** A value such as `30 of 100` means each eligible non-rival trainer slot gets a deterministic 30-in-100 upgrade roll. Rival species are deliberately preserved. An upgrade keeps at least one type in common with the original species, excludes legendary, mythical, and glitch species, and requires valid battle art in the live merged registry.

**Species BST tuning.** When a slot upgrades, Nuzlocke aims near `base BST + BST boost`; bosses receive another +12 target bias. The allowed ceiling is the target plus 40 BST for regular trainers or plus 55 BST for bosses, capped at 600. Candidates are sorted by closeness to the target, then stronger BST, then species name; one of the five closest candidates is selected deterministically.

**Move quality.**
- Tier 0 — vanilla moves are left alone.
- Tier 1 — legal level-up moves are optimized.
- Tier 2 — Tier 1 plus legal damaging TM/HM candidates.
- Tier 3 — aggressive competitive-style scoring over the same legal live move pool.
Provider-created/legal move data remains the source pool; the profile does not invent unavailable moves.

**Trainer AI.**
- Tier 0 — no Nuzlocke AI additions.
- Tier 1 — type-aware/basic decision layer.
- Tier 2 — tactical layer. In Gen I this composes AI modifiers 1 and 3; in Gen II it adds BASIC, SETUP, TYPES, OFFENSIVE, and STATUS behavior bits.
- Tier 3 — full smart layer. In Gen I this composes AI modifiers 1, 2, and 3. In Gen II it enables the broader SMART/OPPORTUNIST/AGGRESSIVE/CAUTIOUS set in addition to the Tier-2 behaviors. Bosses at Gen-II Tier 3 also receive the additional boss AI bit.
Existing trainer AI behavior is merged rather than stripped.

**Trainer Stat EXP.** Difficulty profiles use the same preset ladder as the independent trainer Stat EXP rule:
- Tier 0 = 0
- Tier 1 = 8192
- Tier 2 = 16384
- Tier 3 = 24576
- Tier 4 = 32768
- Tier 5 = 65535

**DVs.** A DV floor such as `8/15` means every applicable DV is raised to at least 8 on the 0–15 Gen-I/II DV scale. `PERFECT` means the profile requests perfect DVs instead of merely a floor.

**Held items, Gen II only.**
- Tier 0 — no item enrichment.
- Tier 1 — bosses can receive a Berry; type-matching held items may also be selected.
- Tier 2 — bosses can receive Gold Berry or MiracleBerry; type items remain eligible; Berry is added to the general candidate set.
- Tier 3 — bosses can also receive Leftovers, MiracleBerry, or Gold Berry, plus type-matching options.
An item already supplied by the composed trainer/provider data wins and is not overwritten.

**Badge Boosts.** Profiles marked `OFF` suppress Nuzlocke's badge-boost behavior while that profile owns trainer difficulty.

### Universal profiles

| Profile | Levels regular / boss | Team upgrades regular / boss | BST boost regular / boss | Stat EXP regular / boss | DVs regular / boss | Moves regular / boss | AI regular / boss | Held regular / boss | Badge Boosts |
|---|---|---|---|---|---|---|---|---|---|
| VANILLA | 100/100 / 100/100 | none | none | independent rule | independent rule | vanilla | vanilla | none | rule-owned |
| NUZ MEDIUM | 104/100 / 106/100 | 8 of 100 / 22 of 100 | +14 / +26 | T2 / T2 | no forced floor | T1 / T2 | T1 / T2 | T1 / T2 | rule-owned |

`NUZ MEDIUM` is available in every supported edition and is designed as a modest built-in step above vanilla.

### Red profiles

| Profile | Levels regular / boss | Team upgrades | BST boost | Stat EXP | DVs | Moves | AI | Held | Badge Boosts |
|---|---|---|---|---|---|---|---|---|---|
| SHIN HARD* | 108/100 / 112/100 | 15 of 100 / 35 of 100 | +25 / +38 | T3 / T4 | min 8/15 / 10/15 | T2 / T3 | T3 / T3 | none | OFF |
| PURE RGB* | 105/100 / 109/100 | 28 of 100 / 52 of 100 | +22 / +34 | T2 / T3 | no regular floor / min 8/15 boss | T2 / T3 | T2 / T3 | none | rule-owned |

### Blue profiles

| Profile | Levels regular / boss | Team upgrades | BST boost | Stat EXP | DVs | Moves | AI | Held | Badge Boosts |
|---|---|---|---|---|---|---|---|---|---|
| SHIN HARD* | 108/100 / 112/100 | 15 of 100 / 35 of 100 | +25 / +38 | T3 / T4 | min 8/15 / 10/15 | T2 / T3 | T3 / T3 | none | OFF |
| BLUE KAIZO* | 115/100 / 121/100 | 62 of 100 / 90 of 100 | +65 / +88 | T4 / T5 | PERFECT / PERFECT | T3 / T3 | T3 / T3 | none | rule-owned |

### Yellow profiles

| Profile | Levels regular / boss | Team upgrades | BST boost | Stat EXP | DVs | Moves | AI | Held | Badge Boosts |
|---|---|---|---|---|---|---|---|---|---|
| YELLOW LEGACY* | 108/100 / 113/100 | 25 of 100 / 68 of 100 | +36 / +52 | T3 / T4 | PERFECT / PERFECT | T3 / T3 | T3 / T3 | none | rule-owned |
| SHIN-STYLE* | 106/100 / 111/100 | 18 of 100 / 42 of 100 | +28 / +40 | T3 / T4 | min 8/15 / 10/15 | T2 / T3 | T3 / T3 | none | OFF |

### Gold profiles

| Profile | Levels regular / boss | Team upgrades | BST boost | Stat EXP | DVs | Moves | AI | Held | Badge Boosts |
|---|---|---|---|---|---|---|---|---|---|
| POLISHED* | 108/100 / 113/100 | 30 of 100 / 68 of 100 | +42 / +58 | T3 / T4 | min 8/15 / 10/15 | T3 / T3 | T3 / T3 | T3 / T3 | OFF |
| LEGACY-STYLE* | 106/100 / 110/100 | 20 of 100 / 46 of 100 | +28 / +42 | T3 / T4 | PERFECT / PERFECT | T2 / T3 | T2 / T3 | T2 / T3 | rule-owned |

### Silver profiles

Silver has its own exact-edition catalog; it no longer falls through to Red or inherits an unrelated Gen-I profile list.

| Profile | Levels regular / boss | Team upgrades | BST boost | Stat EXP | DVs | Moves | AI | Held | Badge Boosts |
|---|---|---|---|---|---|---|---|---|---|
| SILVER POLISHED* | 107/100 / 112/100 | 28 of 100 / 64 of 100 | +38 / +54 | T3 / T4 | min 8/15 / 10/15 | T3 / T3 | T3 / T3 | T3 / T3 | OFF |
| SILVER LEGACY* | 105/100 / 109/100 | 18 of 100 / 44 of 100 | +26 / +40 | T3 / T4 | min 6/15 / 9/15 | T2 / T3 | T2 / T3 | T2 / T3 | rule-owned |

### Crystal profiles

Crystal also has its own exact-edition catalog. These are conservative Nuzlocke-built Crystal-focused profiles, not claims that Crystal originally shipped with these trainer changes.

| Profile | Levels regular / boss | Team upgrades | BST boost | Stat EXP | DVs | Moves | AI | Held | Badge Boosts |
|---|---|---|---|---|---|---|---|---|---|
| CRYSTAL POLISHED* | 108/100 / 114/100 | 32 of 100 / 72 of 100 | +44 / +62 | T3 / T4 | min 8/15 / 11/15 | T3 / T3 | T3 / T3 | T3 / T3 | OFF |
| CRYSTAL LEGACY* | 106/100 / 111/100 | 22 of 100 / 52 of 100 | +30 / +46 | T3 / T4 | min 7/15 / 10/15 | T2 / T3 | T2 / T3 | T2 / T3 | rule-owned |

### In-game chooser versus documentation

The in-game chooser intentionally shows only the most useful decision information: representative level gains at levels 25 and 50, the deterministic team-upgrade rate written as `N OF 100`, whether same-type species upgrades are active, move quality, AI quality, DV quality, held-item quality, and Badge Boost ownership.

The full formulas, tier meanings, exact per-profile values, and provider-composition behavior must always remain documented here whenever a built-in profile changes.



## 2.7.83 Rules / Setup controls

- **Nuzlocke Loadout:** select the row to open the complete loadout chooser. Move directly to any available choice. The screen shows a short description and how many loadout-owned rules differ; choosing a named loadout still opens the safety confirmation before anything changes. CUSTOM keeps the current hand-built challenge rules.
- **Game Difficulty:** select the row to open the direct profile chooser. The highlighted profile shows concrete ordinary-trainer/boss level, team, BST, move, AI, Stat EXP/DV, and Gold held-item effects where applicable. If another trainer/difficulty mod is active, Nuzlocke warns before committing because that mod's own hooks may still compose.
- **Manual Time (Gold/Silver, in-run):** choose a game hour and press A to apply it. The current minute and weekday stay unchanged. Applying manual time automatically turns **System Clock Sync OFF** so platform time cannot immediately overwrite the manual choice.
- **Starting Poke Balls:** the Setup description now explicitly says these are **deferred**. They are delivered only at the normal capture unlock (Oak Pokedex transition in R/B/Y; after the Mystery Egg return to Elm in Gold/Silver), unlike immediate PC Candy/healing/vitamin loadouts.
- **Rules position:** the compact current/total counter remains visible with the existing native scroll arrows, now placed at the top-right of the toggleable Rules area instead of consuming its own row.


## 2.7.82 Silver / Gold notes

- **System Date/Time:** on a new Gold/Silver game, Nuzlocke initializes the native clock/weekday from platform-local time and now automatically handles Mom's complete initial DST ladder. The host clock already reflects local DST, so the cartridge DST bit stays clear.
- **Random Starter at Elm:** the rendered randomized starter preview is the authority for the immediately following confirmation, and the received starter can be registered from Elm's committed native story event if earlier grant callbacks miss the delayed party construction.
- **NUZ INFO:** the field Pokémon submenu uses the shared Gen-2 PartyMenu path and should appear on both Gold and Silver when Catch/Stat/Move info is enabled.
- **Starting Poké Balls:** unlike bedroom-PC Rare Candy/healing/vitamin loadouts, selected extra Balls remain deferred until normal capture unlock (Oak Pokédex transition in R/B/Y; after Mystery Egg return to Elm in Gold/Silver). This is intentional.
- **DEV REPORT:** package/document Release Safety and generated machine codes are build-process data, not in-game runtime health, and are no longer shown in the player Dev UI.


## 2.7.81 engine compatibility notes

On Gen1Recomp 0.2.21, **System Date/Time** remains a Gen2 NEW GAME option and **System Clock Sync** remains an in-run Gen2 QoL option. Automatic setup uses platform-local time/day and now covers either initial Daylight Saving Time branch without applying the cartridge DST adjustment a second time. Gold and Silver should still be tested independently. Historical note: at that build Crystal was not yet a supported Nuzlocke edition; current 2.9.1 support is alpha.
## 2.7.80 — Gold/Silver clock options and safer TO CAP batches

Gold/Silver NEW GAME setup now includes `System Date/Time`. When enabled, Nuzlocke uses the engine's native Gen-2 clock to initialize time and weekday from the platform local clock and bypass the manual opening clock flow where the engine path allows it. The regular QoL option `System Clock Sync` keeps that native clock aligned while enabled; turning it OFF stops further re-anchoring and leaves the current game-clock offset alone.

Randomized Elm starters now have an additional completion fallback when the granted Pokémon appears in the party only after GIVEPOKE returns. The exact pending transaction finalizes on the next safe world step so the actual starter, New Bark Tracker record, Random Starter state, and Elm story state can converge. Very old starter saves remain repairable only under narrow proven evidence; same-species Pokémon are not generally treated as the same identity.

For Rare Candy `TO CAP`, press B during a multi-candy batch to request a stop. The current candy's complete native level-up, stat, move-learning, and evolution sequence finishes first; the batch then stops before another candy is consumed and shows `Candy batch stopped.`

## 2.7.79 — Gold/Silver starter consistency

Gold and Silver now identify Elm's starter transaction from Elm Lab story context rather than requiring an empty party. When Random Starter is enabled, the species visibly shown in the starter preview can also drive the immediately following Elm confirmation text, keeping preview and dialogue on one choice. A Pokémon already proven as the New Bark starter can repair missing native Elm starter-state flags so older saves are not forced toward a second starter selection.

Older identity-less LEGACY starter rows are cleaned up only in a uniquely provable repair case; same-species Pokémon remain separate identities. Nuzlocke-owned Gen-2 utility screens also use a more consistent centered title/subtitle hierarchy.

## 2.7.78 — Starter identity and Recover Catches

A physical starter is now tracked once by its persistent Nuzlocke Pokemon identity. If an older save contains the same starter in LEGACY and in its hometown row, the proven identity is normalized into the correct Pallet Town (R/B/Y) or New Bark Town (Gold/Silver) record instead of duplicated. Gold and Silver now also expose `Recover Catches` in NUZ RULES for unresolved LEGACY/EDITED records. Manual assignment preserves the saved Pokemon identity even when a live party/box object cannot be attached.

## 2.7.77 — Silver starter and seed controls

On Gold/Silver, Random Starter now also updates Elm's starter confirmation text. NUZ INFO keeps the shared party-submenu path and has a direct Gen-2 PartyMenu fallback. Tracker MAP hides ordinary interiors such as houses, labs, marts, centers, gyms, gates, bedrooms, rooms, and offices unless a real encounter/log/catch state belongs there. `Reroll Seed` can be used during a run; `Auto Seed` returns the configured seed to AUTO and live randomizer projections rebuild immediately.

## 2.7.76 — Gen-2 starter and Tracker parity

Gold and Silver now use New Bark Town as the authoritative starter provenance location, while Red/Blue/Yellow retain Pallet Town. On Gen 2, authored Gen-1 Tracker seed rows appear only after real visit/encounter/catch evidence. DEV REPORT also exposes reachability counters for the shared Gen-2 script, starter, party-menu, and Tracker paths.

## 2.7.75 — Silver shared Gen-2 parity recovery

Silver now uses the same shared Gen-2 runtime path as Gold whenever exact edition detection identifies the game as Silver, even if lower-level generation helpers fail to do so. This is intended to prevent Gen-1 fallback behavior such as Pallet Town appearing on the tracker or Gen-2 party/gift integrations failing to install.

## 2.7.74 — Gold Nuzlocke info-page normalization

Gold's Nuzlocke-owned DEV REPORT and Pokémon CATCH/STAT/MOVE INFO pages now use the same clearer title hierarchy: emphasized centered page title, centered normal Pokémon/subject subtitle, compact body rows, and stable footer spacing. This is presentation-only and does not change Pokémon data or rule behavior.

## 2.7.73 — Reconstruction checkpoint

This build preserves the complete 2.7.72 feature/rule surface and repairs an internal Late Runtime dependency-order issue. Player-facing rule behavior is intentionally unchanged. Runtime smoke is required before reconstruction advances.

## 2.7.72 — Shared UI ownership hardening

- Explicit `wide` layout requests now fall back to the classic surface unless a usable wide-layout provider reports a real wider size; `applyLayout()` claims the resolved layout instead of the raw request.
- Shared Gen 1/Gen 2 row primitives now support caller-owned `preFitted` text.
- Both live R/B/Y Tracker tabs mark only their selected marquee row as pre-fitted, preventing the shared pixel fitter from adding a second ellipsis to an already-finalized scrolling slice.
- Non-selected Tracker rows retain the shared defensive pixel fit.
- Release Safety protects both contracts.

## 2.7.66 rule-availability audit, pass 2

- Continues the rule-availability audit in a deliberately small pass.
- Yellow no longer exposes Random Starter `Trio Typing` as a native rule because Yellow does not natively use the three-choice starter slate; an explicit compatible `starter_trio` provider can make it available.
- Encounter-slot modifiers now depend on `One Per Area`: Failed Encounters, Dupes, Gen II roamer/egg/contest policies, Town Catches, and area/time/headbutt split controls become dormant while area encounter limits are OFF.
- Type Locke now exposes/effects only the lanes selected by its mode. Catch Draft is hidden while Type Locke is OFF; manual type lanes are hidden/inert during Catch Draft; DUO through HEXA progressively reveal only the required lanes.
- Stored values are preserved while dormant and return when their prerequisite becomes applicable again.
- Release Safety extends the exact-edition/dependency source tripwire for these relationships.


# Nuzlocke User Guide — 2.7.65


## 2.7.64 MOD COMPAT ownership controls

On selectable MOD COMPAT rows, use Left/Right to cycle the preferred owner. `AUTO` is recommended and chooses the live compatible provider normally. A row may also offer the native `Nuzlocke`/`Engine` owner and any installed provider that actually advertises the matching capability. Rows without a safe substitutable provider contract remain read-only. Gameplay-impacting changes show an OWNER WARNING before applying; Cancel leaves the preference unchanged.

> **Historical build:** 2.7.84. The shared Nuzlocke architecture remains canonical; that build advanced the Gen1Recomp compatibility audit through 0.2.24-era source and intentionally added Crystal as an ALPHA target with independent runtime evidence.

## 2.7.63 build note

Gold/Silver Encounter Tracker MAP rows now come from the active Gen II map catalog/order rather than the Gen I seed list. Difficulty selection is pre-confirmed whenever the proposed profile changes trainer semantics; the warning uses the same APPLY/CANCEL pattern as loadout changes and Cancel leaves the current selection untouched.


## 2.7.62 build note

Build **2.7.62** is a strict child of exact 2.7.61. Gold runtime testing confirmed No Buying and No Selling while exposing No Center Heal as unenforced. Gold/Silver Center and Mom healing now gate the native Gen II `HealParty` special only in the appropriate service context; story heals elsewhere remain native. Runtime retest is required.

## 2.7.60 build note

Build **2.7.60** is a UI build. It descends from exact 2.7.54 through the promoted forward lineage. This pass changes startup diagnostics only; gameplay rules and save behavior are unchanged.

> **2.7.57 only:** This build includes a Dev-only UI Gallery (DEV TOOLS -> SELECT) with five synthetic pages for hierarchy, encounter state, diagnostics, typography stress, and notice/wrapping stress. The Gallery is read-only and does not constitute gameplay Runtime PASS.

# Nuzlocke User Guide — 2.7.57

## UI architecture build

This build changes presentation only. Setup/NUZ RULES and ENC TRACKER begin using a shared Nuzlocke visual vocabulary that keeps exact-edition context visible while preserving the same controls and challenge semantics. The build is intentionally development-stage; 2.7.54 was retained as the fallback during development.

The intended control grammar remains Up/Down for vertical navigation, Left/Right for value/page movement where applicable, A for the primary action, and B for back/cancel. Existing special numeric/resource editing behavior is retained.

2.7.54 adds internal regression coverage for external-save reconciliation and Release Safety forward-reference linting; these do not change player-facing rule semantics.

## Safari Clause

- **STANDARD** — the whole Safari Zone shares one encounter slot; normal Failed Encounters applies.
- **PER AREA** — Center, East, North, and West each receive an encounter slot; normal Failed Encounters applies.
- **UNTIL CATCH** — the whole Safari Zone shares one slot, but failed/fled/defeated eligible Safari encounters do not consume it; the first successful catch consumes it.
- **AREA+CATCH** — Center, East, North, and West each receive a slot, and each stays open through Safari failures until a successful catch in that section.

Existing saves keep their old behavior: old OFF (0) is STANDARD and old COMMON (1) is PER AREA.

Randomizer certification now includes non-runtime seed reproducibility and release/documentation audits. These diagnostics are read-only and do not consume Randomizer choices or rewrite mappings. Exact-edition runtime certification remains pending.

<!-- 2.7.51 Phase J #7-9 certification; no player-facing Randomizer option changes. -->
# 2.7.46 Randomizer Phase I #4–6

Randomizer integration now exposes a read-only compatibility matrix for established cross-system ownership seams, an 8-digit seed sharing/import contract, and one deterministic subsystem-version report. Importing a seed changes only the configured seed and does not clear mappings or consume RNG. Existing stream names and algorithm-v1 behavior remain unchanged.

Randomizer Preset integrates the mature subsystem controls without replacing them. CUSTOM leaves every child setting alone. CHAOS enables all Nuzlocke-owned randomizers with broad policies; BALANCED enables them with progression-aware balance defaults. Provider-delegated subsystems remain externally owned and are not seized by a preset. Any manual Randomizer child edit returns the preset label to CUSTOM.

Species Pool is now shared by Random Starter, Random Encounters, Random Trainers, and Random Evolutions: AUTO uses the hard-safe live merged registry; GEN1/GEN2/BOTH apply the same generation-source filter before each subsystem's stronger legality/story constraints. This is an integration policy change, not an RNG algorithm-version change.

# 2.7.44 Randomizer Phase H completion

Gold/Silver Pack and item-PC transfers do not reroll randomized items: randomization occurs at acquisition/content projection, while native storage moves preserve item identity and quantity. Randomizer Info now reports Shop/TM/Gift mapping counts and policies; OPEN may reveal persisted choices while BLIND suppresses them. Phase H includes an executable economy/progression regression audit, but exact-edition runtime certification remains required.

# Nuzlocke User Guide — 2.7.43

### Broader Item / Shop / TM Randomization Phase H #7–9 (2.7.43)
Random Gift Items now also covers dedicated NPC reward-item command surfaces when exposed by the active game/provider. All broader item randomizers share fail-closed key/story/quest/progression exclusions. Random Shops never bypasses No Buying or No Selling, and Random TMs never bypasses No TMs: randomization projects content first while the existing authoritative transaction/use gates remain in control.

2.7.28 repairs Gold/Silver startup/title setup integration. On a fresh Gen2 game, SETUP belongs immediately before NEW GAME; when a valid save exposes CONTINUE, SETUP is intentionally hidden. Randomizer Phase E items 1–6 remain unchanged.
2.7.27 is a development build. Random Learnsets now exclude unusable/broken/invalid live move records and apply deterministic soft type-affinity plus authored damaging/status-shape weighting. These are soft preferences only; every hard-safe move remains reachable. Explicit STAB controls are reserved for Phase E #8.
Gold rules/setup help panes use **Select alone** to advance long descriptions one wrapped line at a time. A `^` cue means text exists above; the native down-arrow means text remains below. The footer shows the exact scroll position, such as **SEL:MORE 2/5**, and changes to **SEL:TOP 5/5** at the final position; another Select then returns to the beginning. The counter is a scroll-position counter, not a page number. **Select+Up/Down** remains the section-jump shortcut and does not page help text.

This guide describes **what the mod does now**. Historical changes belong in `CHANGELOG.md`.

World Building remains independent of the Nuzlocke master switch as a presentation feature. Encounter/Learnset Randomizer subsystems use explicit disabled/delegated/applied lifecycle states, and Randomizer information policy is shown whenever Nuzlocke owns at least one supported Randomizer surface, including learnset-only runs.


### Broader Item / Shop / TM Randomization Phase H #4–6 (2.7.43)

**Random TMs** changes the move taught by each TM without changing the TM item itself. HMs are never randomized. **TM Compatibility** has three policies: MOVE keeps native compatibility with the randomized move; SLOT preserves each species' authored eligibility for that TM slot; FULL allows every species to learn every randomized TM. **Random Gift Items** randomizes ordinary scripted GIVEITEM grants while leaving quantities, inventory capacity, script flags, and transaction completion native. Key/progression items, HMs, TMs, and provider-protected items are preserved. Dedicated NPC reward-item paths are included when exposed by the active game/provider.

## Getting started

Use **NUZLOCKE SETUP** before a new game to choose a preset or configure rules individually. The in-game **NUZ RULES** screen edits the active save. Ordinary toggles use Left/Right and/or A; numeric/resource selectors use the dedicated numeric editing behavior.

Presets are shortcuts over the same rule catalog. They do not create a separate rules engine. Changing a preset can update only the rules owned by that preset; unrelated clauses, presentation settings, and starting resources remain independent.

## Rule menu organization

The current catalog is organized as: **CORE, CLAUSES, HARDCORE, GAME DIFFICULTY, BATTLE MECHANICS, RUN / PARTY, LEVELS, CATCH RULES, BATTLE CLAUSES, STATUS BANS, VARIANTS, BATTLE ITEMS, FIELD ITEMS, SERVICES & ECONOMY, POKEMON STATS, AREA SPLITS, RANDOMIZER, WORLD, QOL, QOL SETUP ONLY, UI**. This organization does not change rule keys or enforcement. The IRONMON preset keeps its existing name. Dev Mode is under UI. Save Rules and encounter recovery/assignment are maintenance actions outside the ordinary rule-category list.

## Core Nuzlocke rules

### Nuzlocke Enabled
Master switch for Nuzlocke enforcement. Turning it off should stop Nuzlocke mutations/enforcement without destroying existing Nuzlocke history.

### Permadeath
A Pokémon recorded as dead remains dead. External healing or scripted callbacks must not resurrect a `nuzlockeDead` Pokémon; battle-entry reconciliation reasserts HP 0 when needed.

### One Per Area / Failed Encounters
One Per Area limits legal catches by encounter area. Failed Encounters can consume the area's opportunity when the first eligible encounter is defeated, escaped from, or otherwise missed. Area splits can deliberately divide selected routes/dungeons into separate encounter slots.

### Nickname Rule
Supported acquisition paths require a non-default nickname. The rule is independent of player/rival automatic naming options.

### Dupes / Shiny
Dupes can be OFF, exact-species, whole evolution-family, or SPLIT branch based. SPLIT keeps ancestor/descendant lines duplicate while allowing sibling branches after a genuine split (for example, Vaporeon does not block Jolteon). Shiny Clause is a numeric exception policy rather than an ordinary boolean toggle; explicit stored values are preserved.

### First Rival Mercy
Applies only to the intended first Rival battle and is consumed when that battle begins. Later Rival battles are not exempt.

## Encounter and acquisition rules

### Gifts, trades, statics and scripted acquisitions
Nuzlocke distinguishes acquisition source kinds instead of assuming everything is a normal wild catch. Gifts/trades, fixed statics, provider-owned captures, theft-style captures, and progression-required catches can therefore receive different area/source policies while still sharing species legality where appropriate.

### No Catching
Blocks real capture attempts. Progression-required PC Catch exceptions are allowed only when a cooperative source explicitly declares both progression requirement and exception permission, and real Box storage has room.

### PC Catches
When enabled, a qualifying mandatory progression catch may be accepted only into real PC storage. Party room does not substitute for Box space. Full Box storage fails closed.

### Encounter Ball Limit
Restricts the number of legal Ball throws during an eligible encounter. OFF preserves normal unlimited throws.

### Encounter Tracker / Area Guide
Shows encounter state and catch results by area. Catch Info records provenance where available. Route/Mt. Moon/Safari split settings update the canonical area interpretation used by tracking and legality.

## Pokémon restrictions

### Type Locke
Supports Mono through Hexa type configurations plus the existing random/draft-oriented selectors. Catch legality is based on the current species metadata/provider view, not a hard-coded assumption that only native Gen1/Gen2 species exist.

### Maximum BST
Rejects acquisitions above the configured maximum BST when reliable metadata is available. Provider/merged species metadata is preferred for expanded species.

### Species bans
Legendary, Mythical, Pseudo-Legendary, glitch, and explicit PKMN BAN policies use the current species facts/metadata contract. Unknown provider metadata is treated conservatively on authoritative legality paths.

## Level caps and difficulty

Level caps follow the selected scope and may consume live trainer/provider information where compatible mods change boss teams. When another compatible cap system is also active, dedicated adapters may use the stricter live cap without rewriting the other mod's state.

EXP that would exceed an authoritative Nuzlocke cap is trimmed/blocked at the final Nuzlocke clamp. A blocked award remains zero even when downstream mods multiply EXP.

Difficulty options are separate from Smart-AI/content ownership in other mods. Nuzlocke should not silently replace an external trainer/AI system merely because a numeric difficulty rule is enabled.

## Party, battle and move rules

### Party Size / Gym Team Size
Party Size limits usable player-party admission/withdrawal paths. Provider-owned acquisitions such as theft/owned captures deliberately participate in party admission policy. Gym Team Size may follow the final composed trainer team where provider data is available.

### Physical / Special Split
When enabled, explicit live/provider move categories outrank Nuzlocke fallback knowledge. External expanded moves that already declare a correct category are not overwritten.

### Battle clauses
Sleep/OHKO/Evasion and related clause logic uses source/target semantics rather than move-name guessing. Reactive self/foe effects are distinguished so the opponent's reaction is not attributed to the attacker incorrectly.

### Healing / items / escape
Rules exist for battle healing, X items, PP items, TMs, Rare Candy, field healing, Centers, Mom healing, Repels, Escape Rope, buying/selling, and other challenge surfaces. Each rule should block only the action it owns and preserve unrelated vanilla recovery/progression behavior.

### No Held Items
Native Gold/Silver held-item behavior is supported. On R/B/Y the rule appears only when a compatible external held-item capability exists. Compatible Gen1 providers can have GIVE removed while TAKE remains available; existing player-held values can be suppressed during battle and restored afterward rather than deleted.

## Day Care / breeding

No Day Care blocks **new deposits**, not withdrawal/recovery of already deposited Pokémon. Vanilla R/B/Y, native Gen2, and compatible replacement Day Care paths use separate engine/provider seams so a content mod cannot bypass the rule merely by replacing the original talk script.

## World restrictions

Gym Lock-In and Dungeon Lock-In prevent backing out after entry until the run reaches a legitimate alternate exit/release condition. Lock logic is topology/content aware and should fail open when map ownership is genuinely uncertain rather than trapping the player permanently.

World Building tiers affect presentation/dialogue only; they do not change rule enforcement.

## Randomizer

Random Starter, Random Encounters, Random Field Items, Random Learnsets, Random Trainers, Random Evolutions, and Random Shops use deterministic named randomizer streams where Nuzlocke owns the transformation. The global randomizer algorithm remains version 1; starter slates carry their own independent namespace version so starter-only improvements do not reshuffle encounter, field-item, or learnset results.

Random Starter currently exposes:

- **Starter Style** — `ANY`, `3-STAGE`, `BASE`, or `SIM BST`.
- **Starter Balance** — `INDEPENDENT` (default) or `BALANCED`. BALANCED prefers three-choice slates whose current strength plus evolutionary potential are reasonably comparable. It is a soft preference only.
- **Trio Typing** — `OFF` (default) or `AUTO`. AUTO prefers a three-way offensive type cycle across the three native Red/Blue or Gold/Silver starter positions and evaluates both types on dual-type species. Yellow's two-position Pikachu/Eevee starter/rival transaction does not apply this three-way preference.
- **Starter Rerolls** — `OFF` (default) or `ON`. When ON, a separate **Reroll Starter** action is available only before starter acceptance. It keeps the run seed fixed and advances only an isolated starter reroll index. Once the starter is accepted, rerolls are permanently closed for that save.

Hard starter legality always outranks Starter Style/Balance/Typing preferences. Active species bans, Type Locke, glitch safety, runtime construction safety, and acquisition restrictions are never relaxed. Multi-choice starter slates remain distinct whenever a complete legal distinct assignment exists. If a requested balance/type relationship cannot be produced, the preference relaxes to the normal legal distinct slate rather than blocking story progression.

The starter transaction is persisted by exact edition/position identity. Red/Blue store the three Oak positions; Gold/Silver store the three Elm positions; Yellow stores the Pikachu player position and Eevee rival position together. Canonical rival starter-family members derive from that same persisted slate rather than receiving an independent random roll.

**Randomizer Info** now also governs starter information. OPEN INFO can reveal the persisted starter slate to compatible information tools. BLIND INFO hides randomized starter species while still allowing read-only seed, algorithm/slate version, Starter Style/Balance/Typing, candidate-count, reroll-index and fallback diagnostics. Merely viewing this information consumes zero RNG and does not alter the run.

Yellow has one additional compatibility rule: if Random Starter replaces the opening Pikachu, the normal post-lab Pikachu-only follower/cry/text presentation is suppressed and the otherwise-orphaned Pikachu happiness field is raised only to the native Cerulean Bulbasaur gift threshold. This preserves that gift's progression availability without changing normal Pikachu runs.

Random Encounters use the same hard-safety/soft-preference architecture. `CHAOS` selects from the full hard-safe species pool. `SIM BST` tries the historical ~15% BST band, then ~25% and ~40%. `EVO` first prefers the same broad stage with similar family depth/remaining evolutions, then stage, then progression-adjusted strength. `BALANCED` combines progression shape with BST before relaxing through stage/progression and wider BST bands. Progression-aware strength uses the slot's native level, current BST, and a bounded contribution from reachable evolutionary ceiling; it never changes encounter levels or rates.

**Encounter Repeats** controls repetition within each encounter source group: `ALLOW` preserves independent slot rolls; `DIVERSE` softly lowers the weight of already-used species while keeping every legal species reachable; `UNIQUE` uses without-replacement selection until the group's legal pool is exhausted, then explicitly falls back. **Diversity Strength** appears only for DIVERSE: `LIGHT` uses 0.70-per-use weighting, `STANDARD` uses the 2.6.83/default 0.45 factor, and `STRONG` uses 0.25. No DIVERSE strength makes a legal candidate unreachable.

Encounter-table semantics are normalized explicitly. Land/grass, cave, Surf/water, fishing/rod, Headbutt/tree, Bug Contest, roamer, and provider-defined/other classes are tracked separately, and Gen 2 morning/day/night tables normalize to `MORN`, `DAY`, and `NITE`. Repeat grouping uses map + normalized class + time bucket + table id + structural parent path, so distinct methods/time blocks do not accidentally share repetition state.

Ordinary wild-table randomization also has a local protection gate before provider composition or candidate selection. Explicit non-randomizable, static, fixed, story, progression, quest, gift, trainer, roamer/roaming, or protected-policy records are preserved exactly rather than randomized as wild slots.

Each encounter source retains its canonical map/source/method/table/slot/path identity for persistence, while the historical Randomizer v1 encounter slot remains the RNG hash identity. The complete encounter source plan is sorted before replacements are generated, so map visit or table insertion order cannot determine results. `CHAOS + ALLOW` preserves the 2.6.82 mapping path; strengthened balance modes and active repetition policies use the encounter-only `ep2` namespace. `STANDARD` DIVERSE preserves 2.6.83's existing DIVERSE namespace; LIGHT/STRONG add only their diversity-strength suffix.


Area Splits do **not** become Random Encounter source keys. Route 2/10/20, Mt. Moon, Safari Zone, Gold Time Split, and Gold Headbutt Split change logical catch/tracker projection only. Changing one reprojects the encounter log/tracker view without deliberately rerolling or remapping the physical randomized wild table.

Randomizer Info exposes an encounter diagnostic view as well as the starter view. OPEN INFO may include live randomized species per encounter source. BLIND INFO removes species but still reports algorithm/policy version, seed, balance/repetition/diversity modes, normalized encounter class/time/group, canonical source identity, candidate counts, protected-source reasons, mapping counts, active split state, and fallback diagnostics. Information reads do not consume RNG or rewrite mappings.

Visible Field Items now use the same hard-safety candidate foundation. A permanent pickup identity is based on exact edition plus the existing map/object semantic source slot; the authored item is not part of that persistence key. Randomizer v1 still hashes the historical `<source slot>:<original item>` input so the identity migration itself does not intentionally reshuffle existing seeds.

Field-item safety is fail-closed. Explicit key-item flags/pockets, HMs, progression/story/quest/required metadata, provider opt-out/preservation policy, badges, missing definitions, and placeholder/unused records are protected. A protected authored pickup remains unchanged and protected items never enter the replacement pool.

Ordinary hard-safe items are now classified into semantic categories: BALL, HEAL, STATUS, REPEL, ESCAPE, BATTLE, PP, GROWTH, EVOLUTION, MACHINE, and GENERAL. **Field Item Balance** controls soft preference: `CHAOS` keeps the full hard-safe pool; `CATEGORY` prefers the original pickup's category; `BALANCED` prefers category + utility tier, then category, then utility tier. Providers/sources may additionally declare allowed or forbidden categories; those are hard constraints and cannot be relaxed by balance fallback.


**Field Item Repeats** controls duplicate pressure across physical visible pickup sources. `ALLOW` preserves independent rolls. `DIVERSE` usually follows a deterministic source-placement lane but periodically uses the independent lane, reducing repeat pressure without forbidding candidates. `UNIQUE` maps native numeric source/object ordinals into a seeded permutation of the shared semantic pool; distinct ordinals remain distinct until the pool wraps/exhausts. Provider sources with only nonnumeric ids degrade deterministically and are reported rather than silently claiming strict uniqueness.

Field-item source ownership is explicit. Native item-ball adapters identify themselves as `VISIBLE`. Native Gen II hidden/BG-event sources may also be owned when their adapter explicitly marks `nuzlockeOwnedHidden=true`; other hidden/provider sources remain unchanged by default. For backward compatibility, a legacy call that omits source-kind context is treated as the historical visible-item path. Hidden items, gifts, shops, fruit/apricorn trees, and scripted rewards remain outside this rule.


Field Item data also has an explicit generation model without creating a second registry. R/B/Y is treated as `GEN1_FLAT`: ball capability and TM/HM record/id semantics are normalized from the flat item table. Gold/Silver is treated as `GEN2_POCKETS`: BALL, KEY ITEM, and TM/HM pocket semantics are normalized explicitly. Both still use the engine's merged `game.data.items`.

Randomizer Info now covers visible Field Items. OPEN INFO may show persisted randomized item choices. BLIND INFO hides the randomized item/category/table class while still reporting exact edition/table model, Field Item modes, visible/hidden ownership, total/hard-safe/protected counts, category counts, persisted/legacy mapping counts, source keys, and fallback diagnostics. Reading this information consumes no RNG and does not rewrite mappings.




Random Trainers preserves trainer/story identity, party size, member order, and authored levels while replacing only each member's species. Each exact-edition trainer/class/party/member position has a stable source identity on the isolated `TRAINERS` RNG stream. Hard trainer-pool legality excludes reserved, missing, glitch, runtime-unsafe, and PKMN-BAN species. Player-only catch/acquisition restrictions are not projected onto opposing trainer teams.

**Trainer Balance** controls Phase F strength shaping: `CHAOS` keeps the full hard-safe pool and preserves the 2.7.33 deterministic mapping path; `EVO` prefers the original evolutionary stage and nearby lineage depth; `SIM BST` prefers live merged BST bands around the authored species; `BALANCED` combines stage and BST before widening deterministically. These are soft preferences only. Party levels are still authored/native, so no trainer-level scaling is introduced by this phase.

**Trainer Diversity** adds OFF / DIVERSE / UNIQUE team-level duplicate control. **Trainer Theme** adds OFF / TYPE soft cohesion using the authored team anchor type. Both operate only after hard legality and Trainer Balance and use a separate deterministic team-policy namespace. When Random Starter and Random Trainers are both enabled, canonical rival starter-family members remain synchronized to the persisted randomized starter lineage instead of receiving an independent Trainer-stream roll.

### External randomizer coexistence

Nuzlocke does not disable its randomizers merely because another randomizer mod is installed. Duplicate controls yield only to an active, source-confirmed owner or an explicit provider capability.

The current named ownership adapters cover PokemonRecompRandomizer, Gen 2 Randomizer+, Kanto Reforged encounter randomization, and Item Randomizer visible pickups. For Item Randomizer, only R/B/Y `overworld_items` or Gold/Silver `gold_ball_items` overlaps Nuzlocke's visible Field Item randomizer. Its hidden/shop/gift/berry/held/PC features remain separate.

Compatible mods can also advertise starter, encounter, visible field-item, or learnset ownership through the generic provider capabilities. DEV REPORT includes a compact ownership snapshot for those four mechanics.


### Randomizer roadmap

Implementation is complete through Phase A; Phase B #1–11; Phase C #1–11; Phase D #1–11; Phase E #1–11; Phase F #1–11; Phase G #1–11; Phase H #1–12; and Phase I #1–6. Earlier deferred #12 exact-edition/runtime certification debt remains tracked where not already completed. Phase I #7–12 remain, followed by Phase J Certification/Stabilization.

Provider ownership can explicitly say:

- `allow` — Nuzlocke may randomize.
- `deny` — preserve the provider/story result.
- `provider` — another provider owns randomization.

Aliases (`preserve`, `story`, `external`, `owned`) normalize to those canonical values. Provider-owned encounter tables are not double-randomized.

## Setup and QoL

Available setup/QoL surfaces include starting resources, Quick Nuzlocke Start, default player/rival names, Running Shoes, catch-tutorial skip, Instant Text, Unlimited Bag Space, intro-related skips, starting supplies and other edition-aware helpers. QoL features must not silently bypass an enabled challenge rule such as No Repels.

## Run History / Forgiveness

NUZ STATUS presents a live RUN STATUS summary, then groups ACTIVE RULES under the same catalog sections used by Setup/NUZ RULES and lists NEW GAME-only configuration under SETUP ONLY. CURRENT AREA / AREA SLOT describe the present encounter slot; LAST EVENT reports the latest Run History event known to this mod. Select RUN HISTORY and press A to open the chronological event viewer. Saves created before Run History producers existed can only show events recorded after those producers were introduced; the mod does not invent missing historical events.

Run History records chronological Nuzlocke events for later diagnostics/recap consumers. F. TOKEN / Route Forgiveness can reopen eligible failed encounter opportunities or restore an archived dead Pokémon only through the defined storage/party legality rules; full storage prevents unsafe revival placement.

## Gold / Silver

Gold and Silver share the Gen2 engine family but remain separate runtime-evidence targets. Gen2-specific adapters cover capture, nickname, mart/item, static, trade/gift, Whiteout, poison faint, Headbutt, Random Starter, title/setup and related paths without forcing Gen1 implementations onto Gen2 modules.

## Compatibility behavior

Nuzlocke composes with external mods through public semantic contracts where possible: trainer-party providers, battle roles, species/move metadata, encounter ownership, acquisition kinds, held-item capability, level-cap providers and content registrations. When an external mod owns a non-core feature and safe composition is not available, Nuzlocke should delegate/grey the overlapping control rather than double-apply it.

See `docs/COMPATIBILITY.md` for current named-mod notes and `docs/API.md` for provider contracts.

## Dev Mode and troubleshooting

Dev Mode includes self-test/report surfaces for build provenance, rule registry/schema checks, hook health, lifecycle duplication, safe-stop writes, randomizer integrity, provider composition and install health. A feature can be player-runtime healthy while a provider API remains unverified; these are tracked separately in `docs/FEATURE_CONFIDENCE.md`. Stadium/Crystal-251 coexistence is also reported separately: importing Stadium model assets does not change catch provenance, while an actual cooperating Stadium transfer/import can be recorded as `STADIUM PRIZE` with Stadium 1/2 origin and provider metadata.

## WIP / unavailable

Wonderlocke remains disabled until a safe pre-transaction Wonder Trade seam exists. Permanent Rule Seal remains WIP-disabled. Historical note: Crystal was not declared by the build described in this old section; current 2.9.1 declares Crystal as alpha.
## Reliability / interruption behavior

2.6.57 adds internal recovery infrastructure for future interruption-sensitive gameplay mutations. A pending supported transaction is reconciled on load before normal schema migration/enforcement resumes. If Nuzlocke cannot prove whether an interrupted mutation already happened, it fails closed rather than repeating the mutation blindly. This infrastructure does not change ordinary rule choices or claim that every existing gameplay path has already adopted transaction recovery.

Dev Mode can report Hook Registry, Feature Health, installer failures, and pending gameplay-transaction state. `ACTIVE` means the tracked feature/hook is present as expected; `DEGRADED` can include legitimate wrapper interposition that deserves inspection; `UNAVAILABLE` means an expected tracked surface is missing or failed.



## Rare Candy → Current Level Cap

When a finite Nuzlocke level cap is active, using a Rare Candy on a Pokémon can use the normal single-candy path or a **TO CAP** batch. TO CAP uses only real Rare Candies, never exceeds the live cap, and stops early if the bag runs out. The cap is re-read before every level, so compatible trainer/cap providers remain authoritative. Intermediate level-up moves and evolutions are still offered normally. **No Rare Candy** blocks both the single and batch paths. With no finite cap, Rare Candy use remains vanilla one-at-a-time behavior. Each TO CAP step is journaled independently: interrupted recovery only completes a missing inventory removal when that exact transaction durably recorded that its native Rare Candy effect returned; ambiguous partial state fails closed rather than replaying or guessing.


### World Building tiers and rule explanations

World Building changes presentation only; it does not decide legality. Optional flavor is suppressed when World Building is OFF. Consequential enforcement/state-change feedback must remain understandable at T0: the protected critical paths use their plain Tier-1 wording instead of disappearing. T2 adds personality, and T3 may use region-aware contextual dialogue. Generic T3 rule/world messages do not append run-summary pages such as loss, badge, or catch totals; recap context belongs only on explicitly recap-oriented surfaces. Some T3 messages have deterministic variety; this presentation selection does not consume or alter gameplay RNG.


### Evolution Randomizer Phase G #4–6 (2.7.38)
Random Evolutions now rejects targets that would create a cycle in the projected evolution graph. `Evolution Balance` offers CHAOS, DEPTH, SIM BST, and BALANCED. DEPTH uses the immutable authored topology; SIM BST compares against the authored target strength; BALANCED combines both. These are deterministic preferences only: hard species construction safety and cycle prevention always win. Evolution trigger metadata remains authored.


### Evolution Randomizer Phase G #7–9 (2.7.39)
Split evolutions prefer different randomized targets for each authored branch whenever the legal acyclic pool permits. Random Evolutions changes only the target species: level, stone/item, trade, friendship, and other method metadata remain authored. Gold/Silver day/night/stat-specific evolution conditions are likewise preserved exactly; if a projection ever changes non-target trigger metadata, that row fails safely back to its authored form.

### Broader Item / Shop / TM Randomization Phase H #1–3 (2.7.41)
Random Shops randomizes ordinary Mart BUY stock on the isolated `SHOPS` stream while preserving stock-slot count/order and native transaction behavior. Shop Balance supports CHAOS, PRICE TIER, and BALANCED. PRICE TIER groups purchasable items by native price bands; BALANCED first prefers both semantic item category and price tier before deterministic relaxation. Key/progression items, HMs, TMs, and Gen2 Bargain Shop custom-price rows remain authored. Replacement items retain their own native item-definition price, so quantity selection, affordability checks, buy deductions, sell values, Bag capacity, and money clamps remain engine-owned.


### Randomizer integration (2.7.47)
OPEN/BLIND is one authoritative spoiler policy across Randomizer information surfaces. Randomizer presets work in NEW GAME Setup and live NUZ RULES through the same provider-aware ownership path; externally delegated subsystems remain externally owned.


## Randomizer mid-run policy (2.7.48)
Changing Randomizer settings during a run does not retroactively reroll already materialized semantic source mappings. Existing mappings remain authoritative; previously unseen sources use the current settings. The run-start Randomizer snapshot remains immutable so diagnostics can report configuration drift and preserve reproducibility evidence.


## Randomizer certification (2.7.50)

Phase J has begun. The mod now exposes read-only static determinism, save/reload persistence, and cross-edition determinism audits. These diagnostics do not consume Randomizer RNG or create mappings. Gold keeps the established field-item ALLOW namespace; fresh Silver field-item ALLOW placements use an edition-specific namespace. Existing saved mappings remain authoritative. Exact-edition gameplay certification is still required.

## UI architecture

2.7.57 is a development-stage preview. Dev Tools SELECT opens the read-only UI Gallery. On compatible Gen 1 wide-menu hosts, Rules/Setup and Encounter Tracker may use additional logical width; Gold/Silver retain their native Gen 2 presentation.

### Why some rules disappear

The Rules and Setup lists show only settings that can currently matter. Edition-specific mechanics are omitted when the active game does not have them. Child settings disappear while their parent feature is OFF, and redundant settings disappear while a stronger rule already controls the same behavior. Their saved choices are preserved and return if they become meaningful again. Compatible mods can expose specifically declared missing mechanics through Nuzlocke's compatibility capability contracts.

## Gen II Nuzlocke utility-screen layout (2.8.04)

Nuzlocke-owned Gold/Silver/Crystal utility screens use the shared Gen II Chrome layout. NUZ STATUS, MOD COMPAT, ENC TRACKER, and DEV REPORT reserve a centered emphasized title band, bounded body text inside the native 20x18 tile frame, and a dedicated footer row. Long labels/values are fitted to their assigned lane instead of being allowed to cross the border. DEV REPORT opens on its semantic SUMMARY view; machine-oriented report codes remain diagnostic data rather than the default player-facing page.


### Bag compatibility
Source-reviewed targets: Useful Bag 2.6.3, Modern Bag UI 0.4.5, and Bag Sort 0.1.0. Nuzlocke composes with presentation/storage/order and enforces item legality by actual item/action rather than pocket position. Combined runtime certification is pending.


### Expanded species compatibility
Expanded species are consumed through final merged species data and the existing species metadata/evolution provider contracts. BST/type/species-ban rules and Randomizer eligibility therefore do not require a hardcoded native-only Pokédex assumption. Dex Overflow 0.1.1 remains a legacy reviewed target; combined expanded-Dex runtime certification is pending.


### Transfer/import provenance
Stadium/Crystal-251 model or ROM import is not Pokémon acquisition. Real external acquisitions must explicitly mark the concrete Pokémon through the public acquisition-provenance surface (or preserve equivalent fields). Unknown imports are not guessed into encounter slots. Gen-II link Pokémon codecs exist upstream, but the full Gen-II trade transaction is not yet a certified Nuzlocke acquisition seam.


## Graveyard Viewer (2.9.16)

Open **NUZ MENU → GRAVEYARD** to view Pokémon that are still authoritatively fallen. The list is chronological; select a Pokémon with **A** for its **IN MEMORY** page and use **B** to return.

The viewer is read-only. It does not move Pokémon, alter Permadeath, consume F. TOKENs, change encounter legality, or create a separate graveyard save. It projects the existing durable death/history records. If a Pokémon is legitimately revived by F. TOKEN, its old death remains part of Run History but it no longer appears as currently fallen in the Graveyard.

Memorial details show only information the mod actually recorded. Older/legacy deaths can therefore show **UNKNOWN** for level, location, opponent, move, or cause. The viewer never guesses missing history. New deaths preserve level in the existing history payload when available.

Graveyard labels use the normal translation/fallback path. 2.9.16 is **STATIC/SEMANTIC PASS — RUNTIME TEST REQUIRED** across the declared editions.


## Almanac / Run Recap (2.9.17)

Open **NUZ MENU → ALMANAC** to view a read-only summary of the current run. The Almanac uses the existing Run History v2 durable aggregate/evidence ledger and recorded Randomizer run snapshot; it does not create a second history save. Pages cover run totals/status, progression, Pokémon history, rule-integrity evidence, Randomizer metadata, and history coverage.

When an older run predates complete history capture or detailed journal rows have been pruned, the Almanac displays **PARTIAL** rather than inventing missing facts. Missing individual values display **UNKNOWN**. Opening the Almanac does not change rules, catches, deaths, Randomizer state, mappings, or history. Labels use the normal translation/fallback path. 2.9.17 is **STATIC/SEMANTIC PASS — RUNTIME TEST REQUIRED** across declared editions.

## End / Abandon Run (2.9.18)

Open **NUZ MENU → END RUN** to explicitly abandon an active Nuzlocke run. **ABANDON RUN** opens a destructive confirmation that always defaults to **NO**; **B** or choosing **NO** makes no changes.

Choosing **YES** records the durable Run History v2 abandonment first. Only after that commit succeeds does the mod disable the Nuzlocke master switch through its normal rule path. This preserves the final history/rule-integrity state and releases transient challenge locks consistently. If history cannot be written safely, the run remains active instead of silently ending without a record.

END RUN cannot mark a run completed. Natural completion remains tied to actual game progression. Completed or already-abandoned runs are read-only here. After a successful abandonment, the Almanac opens to show the final recap. Graveyard, encounter history, Randomizer records, and unrelated save data are preserved. 2.9.18 is **STATIC/SEMANTIC PASS — RUNTIME TEST REQUIRED** across declared editions.


## Colorlocke and Alphabetlocke (2.9.25)

**Color classification:** for canonical National Dex #001-#251 species, Nuzlocke uses provider/runtime Pokédex-color metadata when available and otherwise its bundled PokéAPI/Veekun Pokédex-search color classification. Sprite palettes, shiny colors, UI recolors, and localization do not change Colorlocke legality. Unknown custom species without color metadata fail open.


**Colorlocke**: OFF disables it; RANDOM deterministically chooses one of BLACK, BLUE, BROWN, GRAY, GREEN, PINK, PURPLE, RED, WHITE, YELLOW; CHOOSE uses the Color selector. Classification is species metadata, not sprite pixels, so shiny/visual mods cannot change legality. Unknown custom metadata fails open.

**Alphabetlocke**: OFF disables it; RANDOM deterministically chooses an A-Z initial represented by the live species registry; CHOOSE uses the Letter selector. Classification uses canonical species identity rather than localized display text.

Both rules apply only when a Pokemon is newly acquired. Existing Pokemon are never removed and evolution does not retroactively invalidate a legal teammate. They are additional hard acquisition restrictions and therefore compose with Type Locke, PKMN BAN, Maximum BST, legendary/mythical/pseudo/glitch restrictions, gifts/trades, and Randomizer-produced species.
