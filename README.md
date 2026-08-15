# Release candidate — 2.2.2

## 2.2.2 RC — battle-money label + Yellow enforcement runtime ledger

Direct child of 2.2.1 RC. This narrow follow-up renames the compact Trainer Money label from `Trnr ¥` to `Btl. ¥` so the control reads as battle-money scaling rather than trainer shorthand. Yellow 2.1.24 save-game runtime testing also confirmed No Buying, No Selling, and No Center Heal / Pokémon Center healing enforcement; those paths are protected and unchanged in 2.2.2. No rule mechanics, save/API behavior, file tree, Gold layout, or Gen1Recomp 0.1.94 compatibility behavior changed.

# Release candidate — 2.2.1

## 2.2.1 RC — Gold value-column visual correction

Direct child of 2.2.0 RC. Gold runtime testing showed the 2.1.23/2.2.0 right-aligned Setup/NUZ RULES value column sat one native tile too close to the right frame, causing ON/OFF/WIP values to crowd or clip the border. 2.2.1 keeps the improved ten-tile rule-label field and moves only the Gold value/toggle anchor one tile left. R/B/Y layout, Gold rule mechanics, Gen1Recomp 0.1.94 compatibility work, and all 2.2.0 runtime-repair paths are unchanged. Runtime visual retest is required in Gold Setup and in-game NUZ RULES.

# Release candidate — 2.2.0

## 2.2.0 RC — Gen1Recomp 0.1.94 compatibility + runtime repair rollup

Direct child of 2.1.24 RC. This is the requested major/minor version step for the newly released Gen1Recomp 0.1.94 compatibility pass. The v0.1.93→v0.1.94 tag delta was source-reviewed: 10 commits, centered on version-aware launcher mod conflicts and the new API-2 `mod.postLog`/manifest `log_url` reporting facility. No reviewed 0.1.94 gameplay-hook change requires a Nuzlocke battle, encounter, party, save, or Gold enforcement rewrite. Nuzlocke therefore keeps Mod API 2, save schema 4, `engine_internals` only, and the established `>=0.1.86 <0.1.98` engine envelope while updating its audited-engine marker to 0.1.94.

2.2.0 also rolls forward the open 2.1.24 runtime fixes: R/B/Y NUZ INFO now isolates optional API/provider failures and degrades to a safe read-only direct-Pokémon view instead of allowing a party-menu crash; classic MOD COMPAT uses width-bounded labels/owners while Modern UI keeps full semantic names; NUZ ST. carries explicit RUN STATUS and ACTIVE RULES headings so grouping survives Modern UI presentation; Yellow's Pallet Town Professor Oak capture demo is skipped at the direct `Commands.pushBattle` seam while preserving Oak's post-demo text and lab escort; and Bryan no longer uses the rough hand-painted true-color renderer, instead using native engine NPC walkers/palette/animation with no new asset file.

Runtime confirmation is still required for 0.1.94, NUZ INFO, both MOD COMPAT layouts, both NUZ ST. layouts, Yellow Skip Catch Demo, and Bryan's native appearance. Previously confirmed Yellow 2.1.23/2.1.24 behavior remains protected: randomized starter received-name/party delivery, Trainer Money symbol, Setup/Type Locke selector behavior, name skip, starter PC resource loadouts, and native Trainer Card.

# Release candidate — 2.1.24

## 2.1.24 RC — R/B/Y NUZ INFO native-menu crash repair

Direct child of 2.1.23 RC. Yellow runtime testing confirmed randomized-starter messaging, party delivery, and the Trainer Money symbol, but opening party NUZ INFO still crashed. 2.1.24 moves the remaining R/B/Y NUZ INFO presentation off the custom hand-drawn `NuzlockeCatchInfoScreen` and onto Gen1Recomp's host-owned `ListMenu`, using the existing API-27 read-only Pokemon info model. Gold keeps its native-styled NUZ INFO pages. No rule enforcement or save/API semantics changed. Runtime retest is required.

# Release candidate — 2.1.23

## 2.1.23 RC — systemic T3 dialogue presentation repair

Direct child of 2.1.22 RC. Repeated Yellow runtime reports showed that Mom, the Viridian catch sequence, Oak's Lab and other dialogue could exhibit the same stitched/continuation presentation while World Building T3 was enabled. 2.1.23 replaces location-by-location repairs with one shared T3 presentation boundary: Nuzlocke-owned world text is consistently wrapped/paginated, and ScriptRunner `show_text`/`ask` dialogue carrying Gen1's `\v` continuation marker is normalized at T3 without changing story logic. The R/B/Y catch tutorial now actually skips the semantic `old_man_demo` row while preserving the surrounding vanilla script. Gold rule values are right-aligned farther right and rule labels regain width. Runtime confirmation is required.

# Release candidate — 2.1.22

## 2.1.22 RC — R/B/Y Nuz menu native-surface repair

Direct child of 2.1.21 RC. Yellow 2.1.21 runtime confirmed that both NUZ ST. and MOD COMPAT could still hard-crash. For R/B/Y, those two START-menu surfaces now return Gen1Recomp's stable mod-facing ListMenu instead of hand-drawn custom states, preserving the same status/compatibility data while delegating scrolling, drawing, cancel input, and StateStack timing to the host UI. Gold keeps its generation-native status/Chrome paths. All previously confirmed Yellow Setup/name-skip/startup-resource/native-Trainer-Card PASS behavior and the 2.1.21 Gold spacing change are preserved. Runtime confirmation required.

# Release candidate — 2.1.21

## 2.1.21 RC — Gold Setup spacing cleanup

Direct child of 2.1.20 RC. Gold's native Setup/Rules renderer now reserves a full tile of visual separation between each rule label and its value/toggle by reducing only the label field from 10 tiles to 9 while preserving the existing seven-tile value column. This is a presentation-only Gold change: rule keys, values, controls, descriptions, R/B/Y layout, and the 2.1.20 Nuz-menu recovery work are unchanged. Runtime visual confirmation is required.

## 2.1.20 RC — Yellow runtime follow-up

Direct child of 2.1.19 RC. Yellow runtime testing confirmed NEW GAME Setup, Type Locke selector visibility, default-name skip, PC Heal loadout, Rare Candy loadout, PC Vitamins, and the native Trainer Card. 2.1.20 preserves those paths while hardening Nuzlocke-owned in-game menu recovery: draw failures are no longer allowed to mutate the StateStack from inside draw(), and NUZ RULES / NUZ STATUS defer error recovery to the next update tick so a recoverable screen fault can display a diagnostic instead of escalating into a hard crash.

Menu cleanup: Game Difficulty now has its own section (VANILLA remains its OFF/unaltered setting); Trainer Money and Starting Money use the native ¥ symbol; No Escape Rope displays as `No Esc. Rope`; and the fresh-PC medicine option is now `Heal Loadout`. Type Locke enforcement remains mode-authoritative: OFF allows every type, MONO uses only Type 1, DUO uses only Types 1-2, and TRI uses only Types 1-3. Runtime enforcement remains TEST REQUIRED.

`2.1.19` is a direct child of `2.1.18 RC` and is a narrow compatibility/lifecycle hardening pass based on code review. Gen1 kerning installation retries no longer depend on the currently active generation; the installed wrappers still remain Gen1-only at call time. Gen1 Modern UI adapter registration now requires an explicit `true` result, so `nil`/unexpected provider returns cannot be reported as successful registration. The R/B/Y title SETUP fallback now uses a stable mutable wrapper state that refreshes the current `openSetup`, translation, and save-editor dependencies across mod reloads, including migration from the exact 2.1.18 wrapper. No challenge-rule mechanics are changed. Runtime confirmation is required.

# Release candidate — 2.1.18

`2.1.18` is a direct child of `2.1.17 RC` and is a Yellow runtime-hardening pass. The native R/B/Y Trainer Card is no longer hijacked by Nuzlocke; `NUZ ST.` is a separate START-menu status surface, removing the wrapper path implicated in the reported Trainer Card crash. Nuzlocke-owned script messages now use one-response-per-transaction ownership to prevent compatibility seams from stacking duplicate mod boxes. The bedroom SNES screenshot was source-audited and is vanilla Gen1 `cont` scrolling, not T3 duplication, so upstream dialogue presentation is preserved. Runtime confirmation is required.

# Release candidate — 2.1.16

`2.1.16` is a direct child of `2.1.15 RC`. This focused rules/UI pass adds **TRI / Trilocke** to the shared R/B/Y + Gold Type Locke system, verifies the effective restriction is mode-authoritative (OFF = no type restriction; MONO = displayed Type 1 only; DUO = displayed Types 1–2; TRI = displayed Types 1–3), moves **Route Forgiveness** from CORE to CLAUSES and **No Catching** from CORE to GENERAL, and adds +1 pixel micro-tracking to the existing bold-like centered section headers so neighboring glyphs do not visually merge. Runtime confirmation is required.

# Release candidate — 2.1.15

`2.1.15` is a direct child of `2.1.14 RC`. It is a narrow configuration-UI repair: section headers are centered and receive bold-like pixel emphasis, ordinary rule rows use more of the left gutter, Type Locke OFF hides/clears both type selectors while MONO hides/clears only Type 2, and the reversible **Rule Lock** control is restored as a separate feature from the still-WIP **Permanent Rule Seal**. Runtime confirmation is required.

# Release candidate — 2.1.13

`2.1.13` is a direct child of the canonical packaged `2.1.12 RC`.

This is a narrow Yellow/T3 repair candidate. It does not add unrelated challenge features.

- Random Starter now filters its concrete starter pool against the engine contracts used by `Pokemon.new` and the party Summary screen. Partial/provider species records with missing growth, type, learnset, base-stat, or displayed-move data are skipped instead of being allowed to become a crash-prone starter.
- Vanilla Yellow Pikachu remains untouched when Random Starter is OFF. The existing pre-creation `pokemon.before_give` seam is retained because Gen1Recomp 0.1.93 constructs the Pokémon only after that event returns.
- Mom's blocked home-heal interaction is transaction-guarded so overlapping script-command/fallback seams cannot emit the same Nuzlocke rejection twice.
- Mom's allowed T3 Bryan flavor remains one-time-per-save; later allowed heals return to vanilla dialogue.
- The Pallet home TV no longer appends an unrelated `Rule watch:` suffix. Each T3 report is wrapped to the Gen1 textbox width and explicitly paginated.
- T3 Bryan now exists as an actual runtime NPC in `REDS_HOUSE_1F`, with a real map-script interaction and rotating home/Gen1Recomp/Pokémon Bois Club/game-console dialogue. No new sprite asset or repository file is added.
- T0–T2 TV behavior and non-TV interactions remain vanilla.
- Gen1Recomp 0.1.94 is the current source-audited target; engine range remains `>=0.1.86 <0.1.98`.

**Validation status:** parser/static/source-audit only until runtime retest. Yellow Random Starter OFF/ON, immediate Party/Summary opening, Mom blocked/allowed heals, T3 TV, Bryan home NPC, Setup, NUZ RULES, MOD COMPAT, and Wide Menus classic coexistence are runtime TEST REQUIRED.

# Release candidate — 2.1.12

`2.1.12` is a direct child of `2.1.11 RC`.

This candidate changes Route Forgiveness rewards and adds localization-safe compact UI fallbacks.

- `Nuzlocke Loadout` remains canonical/translatable; compact fallback: `Nuz. Loadout`.
- `Dungeon Lock-In` remains canonical/translatable; compact fallback: `Dung. Lock-In`.
- `BATTLE ITEMS` / `FIELD ITEMS` remain canonical section strings; compact fallbacks: `BATTLE ITMS` / `FIELD ITMS`.
- `No Healing Items`, `No X Items`, and `No PP Items` keep their full translation keys; compact fallbacks use `Itms`.
- Ordinary Gym Trainers no longer award Route Forgiveness Tokens.
- Defeating a Gym Leader awards exactly one Route Forgiveness Token for that Gym, once.
- The award is delivered directly by the Leader-victory reward path. The Gym Guide is not a second token source, preventing double awards.
- A persistent Leader-keyed ledger prevents rematches or alternate trainer-party identities from paying again.
- Existing old per-Gym-Trainer reward ledger data is ignored but not deleted.

Gen1Recomp 0.1.94 is source-audited; engine range remains `>=0.1.86 <0.1.98`.

# Release candidate — 2.1.11

`2.1.11` is a direct child of `2.1.10 RC`.

This candidate combines a localization-safe label architecture with the Gen1Recomp 0.1.93 compatibility audit.

## Localization-safe compact labels

Rule/category source strings are natural full phrases again. Compact English labels are stored separately as optional `shortName` / `shortTitle` display fallbacks.

R/B/Y display logic now:
1. translates the full canonical label;
2. keeps it if it fits the measured pixel budget;
3. if the full label overflows, tries the compact label only when it is safe to do so;
4. if a translation pack translated the full label but did not translate the compact label, Nuzlocke does **not** inject the English abbreviation — it marquee-scrolls the translated full label instead;
5. true overflow retains the approved slow marquee cadence.

Full descriptions remain canonical/translatable and are not abbreviated.

## Gen1Recomp 0.1.93

Gen1Recomp 0.1.93 is now the current source-audited engine target inside the existing `>=0.1.86 <0.1.98` envelope.

The upstream 0.1.92→0.1.93 delta is 14 commits. It touches launcher/updater infrastructure, data loading/default seeding, LegacyCompat, required-import/mobile picker infrastructure, TLS/update checking, and tests. No reviewed change requires a Nuzlocke gameplay-hook rewrite or new permission.

Nuzlocke's runtime compatibility report now advertises `0.1.93` as the audited engine version.

# Release candidate — 2.1.10

`2.1.10` is a direct child of `2.1.9 RC`.

Yellow runtime feedback confirmed the current marquee cadence is good and that Wide Menus can now coexist without the previous Setup crash. Nuzlocke intentionally remains on its classic/native-width configuration surface while Wide Menus is installed; this is the validated compatibility fallback, not an active wide-layout integration.

2.1.10 is a menu-density pass. Common rule labels are shortened so more rows stay static instead of entering marquee scrolling, while the description pane keeps the complete wording and behavior.

Highlights:
- section headers drop decorative `- ... -` wrappers;
- `AREA SPLITS` becomes `ROUTE SPLITS`;
- `RANDOMIZER` becomes `RNDMIZER`;
- route split rows become `Rt. 2`, `Rt. 10`, `Rt. 20`, `Mt. Moon`, `Safari`;
- commonly understood abbreviations are used for encounter, learnset, town, legendary/mythical, player/wild/trainer, money, BST, gifts/trades, level caps, healing, escape rope, candy, default names, and vitamins;
- full rule descriptions remain unabbreviated.

# Release candidate — 2.1.9

`2.1.9` is a direct child of `2.1.8 RC`.

Yellow / Gen1Recomp 0.1.92 runtime feedback:

- Current conditional marquee speed: PASS; unchanged.
- Several common rule labels still marquee unnecessarily.
- Fresh NEW GAME Setup still crashes when Wide Menus is installed.

2.1.9 changes only presentation/compatibility surfaces:

- `First Rival Mercy` → `1st Rival Mercy`
- `One Per Area` → `1 Per Area`
- `Failed Encounters` → `Failed Enc.`
- Existing concise Randomizer labels remain.
- Full descriptions remain unabbreviated in the explanation pane.
- `NuzlockeConfigScreen` now explicitly declares `uiModLayout = "classic"` and `keepClassicUi = true` for both Setup and in-game NUZ RULES.
- This is stronger than merely declining Wide Menus `claim()`: it prevents Wide Menus' later opaque-mod-screen auto-layout hooks from widening the screen.

# Release candidate — 2.1.8

`2.1.8` is a direct child of `2.1.7 RC`.

This candidate refines the R/B/Y variable-width rules presentation by reducing avoidable marquee use through familiar menu abbreviations while keeping full explanations in the description pane.

Menu-facing Randomizer labels are now:
- `Rndm Starter`
- `Rndm Enc.`
- `Rndm Learnset`

The underlying rule keys, behavior, save data, provider contracts, and full descriptions are unchanged.

Presentation policy remains:
- text that fits its measured pixel budget stays completely still;
- only true overflow marquee-scrolls;
- descriptions remain full, pixel-wrapped, and static unless they genuinely exceed the vertical description area;
- Wide Menus stays installed-safe via native-width fallback until a separately validated wide adapter exists.

# Release candidate — 2.1.7

`2.1.7` is a direct child of `2.1.6 RC`.

Yellow / Gen1Recomp 0.1.92 runtime testing found two remaining presentation/compatibility problems:
- installing Wide Menus caused the Nuzlocke rules screen to crash;
- the custom outline selection indicator rendered as ineffective stray colored marks near the divider.

2.1.7 takes the conservative release-hardening path:
- Nuzlocke no longer claims the Wide Menus canvas for its custom rules screen;
- Wide Menus may remain installed, but Nuzlocke stays on the validated native-width layout;
- custom `love.graphics` row highlighting is removed;
- the engine-native cursor glyph is restored for reliable selection visibility;
- the cursor is moved farther left and rule text begins at X=22 instead of the historical X=30, reclaiming some horizontal space;
- conditional marquee behavior from 2.1.6 remains: fitting text never scrolls, real overflow waits 3 seconds and moves at the slow historical cadence.

# Release candidate — 2.1.6

`2.1.6` is a direct child of `2.1.5 RC`.

Runtime feedback on Yellow showed two presentation regressions in 2.1.5:
- the new conditional marquee moved far faster than the historical marquee cadence;
- the filled reverse-video selection bar made row text unreadable on Yellow's palette/font path.

2.1.6 repairs both without giving back the reclaimed left-side text space:

- conditional marquee now waits 3 seconds and advances at the old slow cadence (about 2.4 seconds per glyph step);
- text that fits still never scrolls;
- filled selection bars are removed;
- selected R/B/Y rows use a thin outline rectangle instead, leaving font colors untouched;
- the left cursor gutter remains reclaimed for longer labels;
- MOD COMPAT overflow scrolling uses the same slow cadence.

# Release candidate — 2.1.5

`2.1.5` is a direct child of `2.1.4 RC`.

Yellow/Gen1Recomp 0.1.92 runtime testing showed that 2.1.4's static pixel-aware labels were an improvement for text that fit, but ellipsizing genuinely long rule names was not desirable.

2.1.5 changes the R/B/Y presentation policy:

- Text that fits its actual pixel budget stays completely static.
- Text that genuinely exceeds the budget marquee-scrolls by glyph spans.
- Normal rule/value labels no longer use ellipses.
- The old left-side per-row cursor glyph is removed from R/B/Y rules rows.
- Selection is shown with reverse-video/inverted row highlighting instead, reclaiming the cursor gutter for text.
- Rule names start farther left and receive a larger usable pixel budget.
- Descriptions remain pixel-wrapped and static unless they genuinely overflow vertically.
- MOD COMPAT keeps separate non-overlapping columns; a column scrolls only when its text truly exceeds that column's pixel budget.

Gold's native Gen2 presentation remains unchanged.

# Release candidate — 2.1.4

`2.1.4` is a direct child of `2.1.3 RC`.

This candidate is a presentation cleanup after Yellow/Gen1Recomp 0.1.92 runtime testing proved the Gen1 variable-width Font path is active and the MOD COMPAT crash is repaired.

Changes:
- R/B/Y Nuzlocke Setup and NUZ RULES now measure text with the active Font in pixels.
- Rule names and section headers no longer use marquee scrolling as their normal presentation.
- R/B/Y titles and value labels are static; genuine overflow is ellipsized instead of marquee-scrolled.
- Rule descriptions wrap to the full available pixel width and remain static whenever three lines fit.
- Description scrolling is retained only as a genuine vertical-overflow fallback.
- MOD COMPAT uses measured/truncated label and owner columns so kerning cannot make the two columns overlap.

Runtime evidence inherited from 2.1.3 RC:
- Yellow fresh Setup: PASS
- Setup-to-game boot: PASS
- Gen1 variable-width/kerning presentation: PASS
- MOD COMPAT crash repair: PASS
- Yellow Trainer Card / A:NUZ surface: PASS
- MOD COMPAT layout: FAIL in 2.1.3 due overlapping columns; repaired here and requires retest

# Release candidate — 2.1.3

`2.1.3` is a direct child of `2.1.2 RC`.

This candidate incorporates the final focused code-review repairs before release testing:

- Gym Trainer Forgiveness reward identities now normalize `id`, `class`, and `name` independently and preserve field boundaries in the persistent ledger key.
- Gen1 kerning now resolves the maintained active game through an injected `getCurrentGame()` dependency instead of relying on the never-assigned `mod.game` field.
- `compat21.pokemonLegality()` now recognizes the real string-valued `nuzlockeInvalidAcquisition` marker and exposes the specific reason as `invalidAcquisitionReason`.
- The 2.1.2 MOD COMPAT repair remains included: R/B/Y no longer requires the obsolete `src.render.Draw` module.

Yellow / Gen1Recomp 0.1.92 runtime evidence inherited and protected:
- fresh NEW GAME Setup appears: PASS
- Setup accepts choices and boots into gameplay: PASS

Still requiring runtime confirmation in this candidate:
- MOD COMPAT opens, scrolls, and closes cleanly
- Gen1 variable-width/kerning presentation is visibly active in Setup/Nuz Rules
- Gym Trainer Forgiveness awards once per distinct trainer
- invalid gift/trade acquisitions are reported as restricted through `compat21.pokemonLegality`

# Release candidate — 2.1.2

Direct child of the 2.1.1 release candidate.

Yellow / Gen1Recomp 0.1.92 runtime results inherited and protected:
- fresh NEW GAME Setup appears: PASS
- Setup accepts choices and boots into gameplay: PASS
- in-game MOD COMPAT screen: FAIL/crash in 2.1.1 RC
- expected Gen1 variable-width/kerning presentation was not visibly active in Setup or Nuz Rules

2.1.2 fixes the MOD COMPAT crash by removing its stale dependency on the removed `src.render.Draw` module and drawing through the current `src.render.Font` box API. It also retries the Gen1 kerning fallback after `game.ready` / `save.loaded`, when the game generation and Font surface are available, and corrects MOD COMPAT's kerning diagnostic marker.

# Release candidate — 2.1.1

`2.1.1` is the first candidate after the SemVer transition. It is a direct child of `2.1.0`.

Engine compatibility was re-audited against Gen1Recomp 0.1.92. The supported manifest envelope is now `>=0.1.86 <0.1.98`: 0.1.92 is source-reviewed, while 0.1.93–0.1.97 are an intentional forward-compatibility allowance and are **not** claimed as runtime-tested until each upstream release is reviewed.

Gen1Recomp 0.1.92 adds sanctioned `mod.fetch` and `mod.job` background facilities and a broad `LegacyCompat` bridge for older sandbox-era calls. Nuzlocke does not need network/background work for its current mechanics, so this candidate does not request unnecessary new permissions. Existing scoped/safe persistence remains unchanged.

# Development update — 2.1.0

`2.1.0` is the new canonical development identity for the exact code/features previously packaged as `2.0.0-beta.31.0.4`. This is a versioning/distribution transition only: no gameplay or compatibility logic changed in the renumbering.

Future development proceeds forward from `2.1.0`.

# Development update — 2.0.0-beta.31.0.4

Direct child of `2.0.0-beta.31.0.3`. Adds optional Wide Menus V0.1.0 presentation support for the in-game R/B/Y **NUZ RULES** screen. Nuzlocke remains the sole state/action owner; fresh New Game Setup and Gold remain on their protected native layouts.

# Development update — 2.0.0-beta.31.0.3

Direct child of `2.0.0-beta.31.0.2`. Focused Dungeon Lock-In repair: service interiors such as the Pokémon Center beside Mt. Moon are no longer classified as dungeon maps merely because a runtime/provider map id shares the dungeon landmark prefix.

# Development update — 2.0.0-beta.31.0.2

Direct child of `2.0.0-beta.31.0.1`. Compatibility-review build for Gen1Recomp `0.1.90`. The existing supported engine envelope `>=0.1.86 <0.1.91` already includes 0.1.90, so no engine-range, Mod API, save-schema, or gameplay-rule change is required.

# Development update — 2.0.0-beta.31.0.1

Direct child of `2.0.0-beta.31.0.0`. Focused bug-fix/hardening build for live difficulty staging, Modern UI lifecycle/generation safety, R/B/Y title Setup save-editor lifecycle, and Trainer Rewards progression/leader matching. No new gameplay feature is introduced.

# Development update — 2.0.0-beta.31.0.0

Direct child of `2.0.0-beta.30.1.22`. This is a focused **World Building content pass**. Tier 3 gives Bryan a larger recurring fictional role around the Pokémon Bois Club and the player's Pallet home: he says “boi” constantly, claims he created the Nuzlocke mod, claims he worked on Gen1Recomp from the player's bedroom computer, stays at the house, uses the game console, and becomes the subject of increasingly strange Pallet TV reports. Mom/Bryan flavor uses cheeky non-graphic innuendo. No achievement mechanics or Black Market mechanics are enabled in this build.

# Development update — 2.0.0-beta.30.1.22

Direct child of `2.0.0-beta.30.1.21`. This build concentrates on three player-facing intelligence upgrades without changing challenge-policy ownership: **Encounter Tracker / Area Guide intelligence**, an expanded **MOD COMPAT** ownership page, and **NUZ INFO legality + provenance**. Tracker rows now expose compact encounter-source tags and provider context without revealing future randomized mappings. MOD COMPAT reports a broader set of active mechanic owners, including caps, difficulty, species metadata, identity, encounters, escape/warps, movement, presentation and text layout. NUZ INFO evaluates a Pokémon against the currently active restriction set and reports semantic provider/source provenance without mutating the Pokémon or save.

`2.0.0-beta.30.1.21` introduced compatibility intelligence, spoiler-safe Randomizer ownership context, merged species metadata, translation-safe semantic matching, and context-sensitive World Building guidance.

`2.0.0-beta.30.1.20` introduced the Gen1-only variable-width Nuzlocke presentation layer. Gold/Gen2 remains hard-excluded from the Gen1 glyph transform.

## 2.0.0-beta.30.0.0.10

Conflict-hardening pass over the 30.x compatibility layer. Delegated non-core mechanics now suppress their runtime implementation as well as their menu value; presets can still update the dormant Nuzlocke preference so removing a provider restores the intended preset state. EXP Edging follows level-cap ownership. Provider detection is rebuilt from the active mod graph and randomizer delegation requires granular capabilities instead of a generic RANDOMIZER name. The public delegation export is late-bound, the external item API routes through the same authoritative item policy used by native menus, the acquisition API uses the real Type Locke/special-acquisition policy, AutoCompat reads `game.save.party`/`game.save.boxes`, Gold surfaces No Fishing denial in PackMenu, and recovery no longer duplicates an EDITED mon already matched to a saved legacy row. Runtime validation remains required, especially R/B/Y catch-demo skipping and cross-mod randomizer registry composition.

# Nuzlocke 2.0

A configurable, enforced Nuzlocke ruleset for **Pokémon Gen1Recomp**, focused first on **Red, Blue, and Yellow** with **Gold beta support**.

**Current beta release:** `2.0.0-beta.29.3.16`  
**Targeted Gen1Recomp:** `0.1.83`  
**Games:** Red, Blue, Yellow, Gold  
**Gen1Recomp Mod API:** `2` · **Nuzlocke Compatibility API:** `27` · **Save schema:** `4`

This development build rolls directly from `2.0.0-beta.29.3.12`. It preserves the exact repository tree and protected runtime-PASS behavior while hardening migrations, master-switch boundaries, provider identity, acquisition provenance, dungeon entrances, and compatibility APIs.

## 29.3.16 — Nuz Info / Compatibility API 27

Direct child of `2.0.0-beta.29.3.15`.

This third small update contains the remaining already-completed UI/API work. The former single-purpose party Catch Info row becomes **NUZ INFO**, with independently toggleable **Catch**, **Stat**, and **Move** pages. A/Right advances, Left goes backward, and B closes. Stat Info shows current stats, DVs, and raw Stat EXP; Gold correctly shares Special DV/Stat EXP between Special Attack and Special Defense. Move Info reads name/type/power/accuracy/current-max PP from the active merged move registry.

Compatibility API **27** adds read-only Nuz Info page/Pokemon helpers so other UI/summary mods can compose with this data without scraping the screen. These presentation settings remain outside Permanent Rule Seal.

## 29.3.15 — Rule UI, dialogue, and Gold QoL

Direct child of `2.0.0-beta.29.3.14`.

This second small update contains the already-completed presentation/configuration work without the larger Nuz Info screen expansion. Game Difficulty, Level Cap Scope, and EXP Edging move into a dedicated **LEVELS** section; **BATTLE ITEMS** now contains only actual item-use restrictions; No Catching is presented as the single semantic capture-ban rule in Core; No Escape moves to General. Stat EXP descriptions now make the native 0% default and preset scale explicit.

Gold gains the optional **Skip Cherrygrove Tour** QoL setting: after accepting the Guide Gent's offer, the long walking/explanation segment is skipped while the native MAP CARD reward and cleanup still execute. Rare Candy, TM, and field-healing denials also receive more item/move-aware World Building dialogue. Compatibility API remains 26 here.

## 29.3.14 — Gold runtime repair

Direct child of `2.0.0-beta.29.3.13`.

This smaller update contains only the runtime-critical Gold fixes already completed in the larger work pass: compact Gold START-menu labels now use the hook-supplied Gold game; Gold No Buying / No Selling gate the native Mart BUY/SELL entry points and recheck the transaction seams; Random Starter keeps a stable preview per starter ball and commits only the accepted ball; Elm's Gold starter portrait/cry is rewritten to match the randomized grant; starter provenance is synchronously registered as New Bark Town / STARTER with conservative reconciliation for the 29.3.12/29.3.13 UNKNOWN case; and Gold Stat EXP descriptions now explicitly preserve the native 0% default.

No rule-menu reorganization, Nuz Info expansion, or new exposed QoL option is included yet; those are intentionally split into the next two sequential builds.

## 29.3.13 bugfix / hardening highlights

- **No Catching migration corrected:** retired partial Ball-ban tiers no longer silently become the absolute No Catching rule. An absent `no_catching` key takes the neutral OFF default; an explicitly saved No Catching choice is preserved.
- **Trainer Money master-switch + Gold fix:** payout scaling now records and applies only while the Nuzlocke master switch is active. Its transient wallet state is declared before the battle callback that uses it, and the wallet adapter supports both R/B/Y `save.money` and Gold `save.player.money`.
- **Stable Game Difficulty identity:** the selected difficulty is resolved by `difficulty_provider_id`, not by a mutable dynamic list index. Missing external providers temporarily fall back to VANILLA without erasing the requested ID; old index-only saves bootstrap a stable ID once. Setup profiles preserve the same identity.
- **Route Forgiveness master-switch fix:** token awards, shop presentation, and failure-spend prompts are inert while Nuzlocke is OFF.
- **Dungeon Lock-In entrance hardening:** the lock now remembers the exact exterior entrance warp rather than only its map. A different exit on the same outside map is therefore legitimate; legacy coordinate-less lock state fails open instead of risking a softlock.
- **Acquisition provenance hardening:** Game Corner prize sources are version-aware (including Scyther/Dratini/Pinsir), the English R/B and Yellow NPC-trade tables now match the authoritative game data, Gold no longer inherits Gen-I source tables, and source-less compatibility inference requires a matching live location or genuinely deterministic provenance.
- **Gold NPC-trade parity:** Gold's native `TradeMenu`/`NpcTrade` transaction is now gated before its one-shot flag or outgoing Pokemon changes, then successful trades are tracked from the live map. Gift/Trade toggles are exposed on the Gold beta rule surface.
- **Type Locke RANDOM hardening:** RANDOM chooses only types represented by the live merged species/provider pool when possible, preventing vanilla R/B/Y from rolling empty Dark/Steel runs.
- **Warp-provider compatibility:** Gym/Dungeon Lock-In evaluates the final composed `warp.destination` result after downstream providers run, while still owning the final lock-in policy.
- **World Building de-duplication:** the first capped EXP transaction with EXP Edging now shows one combined cap/banked-EXP message instead of two near-duplicate boxes back-to-back.
- **Defaults audited:** new restrictive systems remain opt-in: Type Locke OFF, No Day Care OFF, Gym/Dungeon Lock-In OFF, Route Forgiveness OFF, No Catching OFF; Trainer Money remains 100% and Game Difficulty remains VANILLA. QoL remains independently configurable.
- **Compatibility API 26:** adds stable difficulty-selection state, master/rule activity queries, Type Locke helpers, Forgiveness token access, Dungeon Lock state/family helpers, version-aware gift/trade lookup and acquisition classification, plus expanded persistent Pokémon-field ownership metadata.

The new/changed 29.3.13 paths are **TEST REQUIRED** until in-engine runtime validation. Existing protected runtime PASS results are not reclassified.

## 29.3.12 development highlights

- **Random Mono / Random Duo:** Type 1 and Type 2 selectors now accept RANDOM. At NEW GAME the request rolls once into a concrete type and persists it; Duo always resolves to two distinct types. In-game RANDOM selection resolves immediately.
- **Type Locke UI polish:** clearer type labels and persisted allowed-type presentation.
- **Dupes accounting hardening:** a duplicate encounter is stamped as a battle-scoped free encounter before failure handling, so it cannot consume an area or spend a Forgiveness Token.
- **Diglett's Cave normalization:** exact Gen I/Gold/provider spellings (`DIGLETT_CAVE`, `DIGLETTS_CAVE`, CamelCase equivalents) resolve to the single canonical `DIGLETT_CAVE` area.
- **Forgiveness polish:** the ¥1,000,000 shop row now carries clearer metadata and status surfaces show the live canonical token balance.
- **Starting-resource audit:** deterministic regression cases cover vanilla ¥3000, intentional ¥0, malformed values, clamping, Balls, and Rare Candies. Gold remains isolated from hidden Gen-I resource fields.
- **No Day Care polish:** T3 rejection text better distinguishes a closed Day Care from safe retrieval of existing occupants.

All new 29.3.12 behavior remains **TEST REQUIRED** until in-engine runtime validation.

## 29.3.11 development highlights

**Pokemon Bois Club** adds a new **Tier 3 World Building** cosmetic rebrand for Vermilion's Pokémon Fan Club. At T3, the club is presented as the **Pokemon Bois Club**, with safe rewording of relevant club/sign dialogue and a custom Bryan-the-Boi tribute chairman sprite. This is presentation-only and does not change story flags, item gifts, Bike Voucher flow, or other rule enforcement.

**Type Locke** adds one shared framework for **Monolocke** and **Duolocke** runs in R/B/Y and Gold. `OFF / MONO / DUO` selects normal play, one allowed type, or two allowed types. Dual-type Pokémon qualify when either type matches. Off-type wild encounters are rejected without consuming the area's encounter or a Route Forgiveness Token, and Shiny Clause does not bypass the type restriction. Native gifts/trades use the same legality rule where a pre-transaction seam exists. Random Starter now prefers the selected Type Locke pool when enabled. Unknown custom-species type schemas fail open rather than being guessed.

**No Day Care** blocks new Day Care deposits while Nuzlocke is active. R/B/Y gates the Day-Care Man before a new deposit; Gold gates the native Gen 2 breeding model before a party member is removed. Pokémon already deposited before the rule was enabled can still be retrieved, and Gold's existing parent/Egg state is left intact.

Permanent Rule Seal now explicitly follows the project invariant: it seals challenge rules such as Type Locke and No Day Care, but **does not seal Game Difficulty, World Building, QoL, or presentation controls**.

The mandatory starter remains progression-safe: Type Locke will not block the story-required starter path. A randomized starter is filtered toward the legal type pool when possible. Full roster quarantine/collection-only enforcement for pre-existing or progression-only off-type Pokémon remains future work.

The new 29.3.11 Pokemon Bois Club presentation path and the prior 29.3.10 Type Locke / No Day Care rule paths are **TEST REQUIRED** until runtime validated.

## 29.3.9 development highlights

Gold no longer reuses the R/B/Y pixel-positioned presentation for Nuzlocke-owned screens. **Setup / NUZ RULES, ENC TRACKER, CATCH INFO, Route Forgiveness prompts, and NUZ STATUS now render with Gen1Recomp's native Gen 2 `Chrome` vocabulary**: 20x18 tile-grid boxes, Gold cursor/down-arrow glyphs, native money formatting, scrolling lists, and Gold-sized text wrapping. The underlying rule, encounter, save, and compatibility state remains shared; this pass changes presentation ownership rather than gameplay legality.

The integration follows Gen1Recomp's documented Gen 2 rule that `src.ui.OptionRows` has no Gold facade because the Gen 1 options chrome is not a valid Gold presentation seam. Nuzlocke therefore owns only its custom screens and does not replace Gold's global renderer or native Trainer Card lifecycle. Existing R/B/Y screens are unchanged.

All new Gold-native presentation remains **TEST REQUIRED** until runtime validated.

## 29.3.8 development highlights

World Building now uses one shared OFF/T1/T2/T3 presentation catalogue for rule feedback, with clear Tier 1 explanations, more personality at Tier 2, and region-aware Kanto/Johto flavor at Tier 3. Gold now exposes the World Building selector instead of silently forcing flavor OFF. Catch denials, item restrictions, shops, healing, Game Corner restrictions, lock-ins, encounter failures/forgiveness, EXP Edging, trainer-money scaling, First Rival Mercy, Permadeath, and Whiteout presentation were consolidated onto the shared system where safe.

The World Building pass now gives every implemented selectable rule a complete T1/T2/Kanto-T3/Johto-T3 message entry (Wonderlocke remains intentionally WIP), while dialogue is injected only at safe player-facing events so passive configuration rules do not spam the player. The cleanup pass removes the retired live Poké Ball tier machinery now that **No Catching** is the semantic rule, removes the unreachable legacy `no_items` battle check, and de-duplicates R/B/Y/Gold catch-rejection text through one compatibility-safe presenter. Legacy `ball_use_ban_tier` is still read only for one-time save migration.

**IronMON is restored as a first-class Nuzlocke Loadout** alongside Custom, Standard, Hardcore, and Solo. Its preset is explicitly IronMON-style and uses only challenge rules this mod actually owns rather than claiming to reproduce every external IronMON rule.


## Feature highlights

Nuzlocke 2.0 is more than a first-encounter/permadeath toggle. The current beta line includes:

- **Fresh-run Nuzlocke Setup** with presets and collapsible rule categories.
- **Separate R/B/Y and Gold Setup profiles**, rule locking/saving, legacy catch recovery, and R/B/Y starting Money/Poké Ball/Rare Candy controls.
- **NUZ RULES** for active-save rule review and supported editing.
- **Permadeath, Whiteout, One Per Area, Failed Encounters, Nickname Rule, Dupes Clause, and Shiny Clause**.
- **Type Locke** with OFF/MONO/DUO/TRI modes for Monolocke, Duolocke, and Trilocke variants.
- **No Day Care** with safe retrieval of Pokémon deposited before the restriction was enabled.
- **Pokemon Bois Club** Tier 3 World Building cosmetic rebrand for Vermilion's Fan Club, including a custom Bryan-the-Boi chairman tribute sprite.
- **Encounter Tracker** with LOG/MAP-style views and persistent encounter provenance.
- **R/B/Y NUZ STATUS** on the Trainer Card plus a Gold Start-menu status surface.
- **Catch Info** for tracked owned Pokémon.
- **Live level caps** that can follow the final merged trainer rosters.
- **Independent Route 2, Route 10, Route 20, Mt. Moon, and Safari Zone encounter splitting** for R/B/Y.
- **Random Starter** while preserving the surrounding story choice path.
- **Legendary, Mythical, Pseudo, Maximum BST, Static, Glitch, Gift, and Trade controls**.
- **Player/Wild/Trainer starting Stat EXP presets**, **No Player Stat EXP Gain**, and independent **Perfect Player/Wild/Trainer DV** controls.
- **Battle restrictions** for healing items, X items, escape, and semantic **No Catching**.
- **Field restrictions** for Repels, Escape Rope, healing, PP items, TMs, and Rare Candy.
- **Challenge rules** for buying, selling, Pokémon Center healing, Mom healing, Whiteout, Solo Only, **Gym Lock-In**, and conservative **Dungeon Lock-In**.
- **R/B/Y Gym Guide Rare Candy** utility with repeatable selectable batches.
- **Quality-of-life controls** including Default Names, Gold Skip Catch Demo, Catch Info, Area Guide, and Running Shoes.
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
| **IRON** | IronMON-style solo/no-heal/no-shop challenge using only rules Nuzlocke owns. |

## Main screens

**NUZLOCKE SETUP** configures the next new run. **Up/Down navigates** and **A or Left/Right changes supported boolean/multi-state rules**. Sections are collapsible.

**NUZ RULES** presents the active-save rule state using the same rule definitions as Setup.

**ENC TRACKER** records encounter areas and provides history/map-style views. R/B/Y split modes preserve the underlying physical-map provenance so changing the projection does not erase canonical encounter history.

**NUZ STATUS** summarizes run state. Red/Blue/Yellow use the Nuzlocke side of the Trainer Card; Gold preserves its native Trainer Card and uses a Start-menu status surface.

**CATCH INFO** exposes stored encounter/origin information for supported owned Pokémon.

## Full user guide

The complete player manual is in **[docs/USER_GUIDE.md](docs/USER_GUIDE.md)**. It covers installation and updating, controls, Setup, every rule, presets, encounter tracking, Catch Info, status terminology, level caps, existing saves, Save Editor behavior, Gold beta support, troubleshooting, and bug-report information.

## Screenshots

The public presentation is intended to use **authentic Gen1Recomp runtime captures**. This release includes no placeholder screenshots.

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

### Mod Compat diagnostics

The in-game **MOD COMPAT** page reports active ownership for supported shared mechanics. Encounter Tracker can label externally randomized encounter ownership without exposing future encounter mappings. Compatible species/content mods can contribute semantic metadata through the merged species-metadata capability. World Building can provide contextual rule guidance without owning enforcement.



The release targets **Gen1Recomp `>=0.1.81 <0.1.84`**. Gen1Recomp 0.1.82 and 0.1.83 were source-audited against the protected Nuzlocke battle, item, shop, save, UI, and Gold script seams. Gen1Recomp 0.1.83 remains the exact source-audited profile; runtime coverage is substantial but not exhaustive, especially on Gold.

Versioned third-party compatibility evidence and known UI-theme limitations are documented in [docs/COMPATIBILITY.md](docs/COMPATIBILITY.md). A newer third-party release never automatically inherits confidence from an older tested version.

## Developer integration

Other mod authors can use Nuzlocke's compatibility API instead of reverse-engineering internal state. [docs/API.md](docs/API.md) documents `nuzlocke_compat` v26, policy queries, level-cap providers, species metadata, Pokémon identity, battle classification, encounter projection, starter randomization, capability relationships, and shared-seam etiquette.

## Reviewed fixes awaiting runtime confirmation

The pre-runtime code-review batch is implemented in this candidate. Because these paths changed after earlier runtime evidence, they remain explicit runtime-test targets before approval:

- First Rival Mercy no longer writes unused `armed` / `triggered` save telemetry; the durable one-shot `battle_seen` state and battle-local forgiveness flags remain authoritative.
- Mandatory scripted starter/gift nicknames now synchronize the matching `nuzlocke_history` row after naming completes on R/B/Y and Gold without moving acquisition registration across the naming lifecycle.
- Gold scripted `givepoke` tracking now detects a newly owned Pokémon in either the party or PC boxes, so full-party gifts can still receive initialization, tracker/history registration, area consumption, and Nickname Rule handling.
- Scripted-static pending provenance is now consumed by the next battle event even when that battle is a trainer battle, preventing the marker from leaking forward into a later unrelated wild encounter.

These are implementation fixes, not runtime PASS claims. The targeted regression matrix is kept in the repository-only testing ledger.

**Current runtime priority:** beta.29.3.13 preserves the protected behavior from 29.3.12 while changing several policy boundaries. Runtime focus is legacy No Catching migration safety, Trainer Money with the master switch ON/OFF in R/B/Y and Gold, stable/missing difficulty providers across reloads, exact Dungeon Lock entrance versus alternate-exit behavior with and without warp providers, Random Mono/Duo viable-type rolls, R/B/Y gift/trade provenance, Gold native NPC-trade rejection/success tracking, EXP Edging's consolidated cap message, and continued Gold UI regression coverage.

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

## What changed in beta.29.3.1

This release rolls up the development work since the last published `2.0.0-beta.29.1.0`. Major changes include Gym/Dungeon Lock-In rules, common Route 2/10/20 splits, Running Shoes/QoL cleanup, native collapsible-section glyphs, deterministic split migration, stronger Permadeath reconciliation, Gold starter/provenance hardening, Random Starter presentation fixes, and expanded compatibility for trainer-modifying content.

A major compatibility fix in this release makes **NEXT CAP** displays observe composed trainer parties before battle. Yellow runtime testing with Stronger Trainers confirmed the Trainer Card and Encounter Log now show the modified cap rather than the vanilla value.

Gold remains beta and still needs broader runtime coverage. See `CHANGELOG.md`, `docs/FEATURE_CONFIDENCE.md`, and `docs/TESTING.md` for the detailed state of each feature and remaining release follow-ups.

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

## 2.0.0-beta.30.0.0.1 randomizer expansion
The RANDOMIZER section now adds **Random Encounters** and **Random Learnsets**. Encounter rolls persist per table slot while preserving native levels, rates, time-of-day/fishing/tree structure, and maps. Learnset rolls persist per species/slot while preserving learn levels and entry counts.

**Learnset Gen**: AUTO uses the active merged move registry; GEN1 uses move indices 1-165; GEN2 uses 166-251. Missing generation data fails open. New paths are **TEST REQUIRED**.

## 2.0.0-beta.30.0.0.2
**No Fishing** is now available under Field Items and is independent from No Catching.

## 2.0.0-beta.30.0.0.3
### Interoperability API v1
FAFF0x/gen1recomp is a first-class compatibility target. Compatibility is capability-first rather than mod-name-first. `mod.exports.nuzlocke` exposes acquisition policy, item policy, effective registries, provider registration, registry notifications, and EXP composition seams.

## 2.0.0-beta.30.0.0.4
### FAFF0x QoL compatibility pass
Interop API v1 now includes alternate-item-UI gates, encounter/acquisition entry points, PC policy, registry revisions, and EXP cap discovery. These are designed for Modern Bag, Item Shortcut, Repel Reuse, Advanced Box, Area DexNav, Summon, Pokédex Plus, Moves Manager, Reusable Machines and EXP Share-style mods without hardcoded mod IDs.

## 2.0.0-beta.30.0.0.5
### Yellow Encounter Tracker removal repair
A legacy-recovery serialization bug dating back to the 29.3.16 path has been repaired. UI-only Pokémon references are no longer stored in `tracker_log`, and contaminated legacy rows are cleaned before serialization.

## 2.0.0-beta.30.0.0.6
### FAFF0x quest/content compatibility
The interop layer now supports dynamic quest maps/areas, provider-defined dungeon families, quest gifts, scripted/repeatable encounters, custom boss metadata, and randomizer opt-outs. `content.registerBundle()` is the preferred one-call integration for quest/content packs.

## 2.0.0-beta.30.0.0.7
### FAFF0x automatic compatibility — 30.0.0.7
Existing mods that predate the Nuzlocke provider API can now be described by a legacy adapter after the active mod graph loads. This bridges common Bag/item, PC, encounter, registry, EXP, quest, and machine behavior families while keeping explicit provider registration authoritative.

## 2.0.0-beta.30.0.0.8
### Compatibility consolidation — 30.0.0.8
Provider compatibility now resolves through canonical mechanic families (`item_provider`, `storage_provider`, `encounter_provider`, `exp_provider`, `registry_consumer`, `quest_content_provider`). Legacy adapter capability names remain supported. Explicit providers are preferred over inferred adapters.

## 2.0.0-beta.30.0.0.9
### External provider UI delegation — 30.0.0.9
Non-core duplicate mechanics no longer compete with an active external provider. Their Nuzlocke row is greyed, effective OFF, and locked, while hover/help text identifies the active provider. Core challenge rules remain Nuzlocke-owned.

## 2.0.0-beta.30.0.0.11
### Gen1Recomp 0.1.84 compatibility checkpoint
30.0.0.11 is intentionally small: it updates the supported engine range so the mod can load on 0.1.84 while preserving the 30.0.0.10 feature state. Runtime testing is still required before 0.1.84 is considered certified.

## 2.0.0-beta.30.0.0.12
### Engine compatibility policy
Starting with 30.0.0.12, the manifest targets the compatible pre-1.0 Gen1Recomp family (`>=0.1.81 <1.0.0`) rather than a single patch window. New 0.x releases are allowed to load unless an actual API/runtime incompatibility is discovered. Unknown future releases are supported-by-range, not automatically runtime-certified.

## 2.0.0-beta.30.0.0.13
### 30.0.0.13 — title setup compatibility
Adds an idempotent fallback for fresh-game Nuzlocke SETUP injection on the current Gen1Recomp 0.1.86–0.1.90 family. The public title-menu hook remains the preferred path; the fallback only repairs a missing row after vanilla construction.

## 2.0.0-beta.30.0.0.14
### 30.0.0.14 — parser hotfix
Repairs the load failure in 30.0.0.13 by isolating its title-menu compatibility helper locals inside a nested function. No intended feature changes.

## 2.0.0-beta.30.0.0.15
### 30.0.0.15 — first approved Lua split
`title_setup_compat.lua` now owns only the fresh-game title SETUP fallback. `main.lua` remains the primary entry point. This split follows Gen1Recomp's sandbox-supported `load(mod:read(...))` multi-file pattern and is intentionally narrow. No further Lua modules will be split without explicit approval.

## 2.0.0-beta.30.0.0.16
### 30.0.0.16 — second approved module split
`trainer_rewards.lua` owns the trainer reward/economy subsystem: Trainer Money scaling, Forgiveness Token mechanics, and Gym/E4/Champion progression bookkeeping. This removes meaningful top-level-local pressure from `main.lua`. No further Lua splitting will occur without explicit approval.

The remaining late runtime-install code is additionally wrapped in an internal nested scope to keep `main.lua` below Lua's compiler-local ceiling without creating more module files.

## 2.0.0-beta.30.0.0.17
### 30.0.0.17 — Permanent Rule Seal confirmation safety
Permanent Rule Seal now requires WARNING 1/2, FINAL WARNING 2/2, and then one final deliberate SEAL activation. Leaving the option or pressing B cancels the confirmation chain. Once finally sealed, the save-level seal remains irreversible by design.

## 2.0.0-beta.30.0.0.18
### 30.0.0.18 — durable Permanent Rule Seal
Permanent Rule Seal now persists immediately through playthrough-scoped storage instead of depending solely on the next ordinary Pokémon SAVE. Only this irreversible marker uses the immediate durable mirror; normal rule settings retain standard save behavior.

## 2.0.0-beta.30.0.0.19
### 30.0.0.19 — Permanent Rule Seal temporarily WIP
Permanent Rule Seal is visible but grey/unselectable, like Wonderlocke. Existing test seals are suspended so normal challenge rules can be edited, while the implementation and underlying historical markers are preserved for a deliberate future re-enable.

## 2.0.0-beta.30.0.0.20
### 30.0.0.20 — dialogue presentation guard
Optional World Building text can no longer nest over an active engine TextBox. This protects vanilla dialogue transactions from Nuzlocke cosmetic interruptions and targets the recurring repeated/overlapping text-page regression reported in Yellow.

## 2.0.0-beta.30.0.0.21
### 30.0.0.21 — percentage labels and Maximum BST presets
Trainer Money and other percentage-based presentation now retain `%` consistently. Maximum BST now offers OFF / 400 / 450 / 500 / 550 rather than arbitrary 000–999 editing.

## 2.0.0-beta.30.1.0

The 30.1.0 beta promotes the current Gen1Recomp 0.1.86+ compatibility line after successful Yellow runtime testing.

Runtime-confirmed Yellow behavior includes existing-save boot/menu access, opening Nuz Rules, the tested Gym Lock-In boundary rejection, and successful non-reproduction of the recurring duplicate-page bug on the specific Poké Mart NPC used for testing.

A key protected presentation rule now applies throughout future development: **optional Nuzlocke World Building text must not be pushed over an already-active TextBox.** This guard fixed the tested recurring overlap/repeated-phrase case and should be reused when similar dialogue bugs appear elsewhere.

Permanent Rule Seal remains WIP and unselectable. Maximum BST uses OFF/400/450/500/550 presets. The approved Lua structure remains limited to `main.lua`, `title_setup_compat.lua`, and `trainer_rewards.lua`.

## 2.0.0-beta.30.1.1

This is the corrected release candidate after a Gold NEW GAME -> SETUP runtime crash in 30.1.0.

Gold now relies only on the older shared title-menu injection + `MainMenu:choose()` adapter that existed in the last published runtime-PASS line. The newer Gold `buildList()` fallback is disabled and preserved in comments for later investigation.

No other Gold systems were rolled back.

## 2.0.0-beta.30.1.2

> **Gold beta warning:** fresh Gold NEW GAME currently has a known crash when selecting the Nuzlocke **SETUP** entry. Gold remains experimental and that startup configuration path is not considered functional in this release.

This release otherwise preserves the current 30.x feature and compatibility line. Yellow runtime testing confirms existing-save boot/menu access, Nuz Rules, the tested Gym Lock-In boundary rejection, and the specific duplicate-dialogue regression case used during testing.

Permanent Rule Seal remains WIP/unselectable. The active-TextBox World Building guard remains a protected presentation safeguard. Maximum BST uses OFF/400/450/500/550 presets.

## 2.0.0-beta.30.1.3 diagnostic

Setup and Nuz Rules now use a guarded screen opener. A failing configuration screen should report its underlying error in-game rather than crash to desktop.

The current main chunk is also confirmed to be at Lua's top-level local-variable ceiling: adding one more local made the compiler reject it. No additional split is made in this build; that structural work should be deliberate and separately runtime-tested.

## 2.0.0-beta.30.1.4 diagnostic

The configuration screen now guards both construction and runtime frames. If Setup still fails due to Lua code, the error should be surfaced in-game instead of becoming an opaque desktop crash.

## 2.0.0-beta.30.1.5 — Setup sandbox compatibility fix

Fresh-game Setup no longer touches the legacy filesystem facade blocked by the current Gen1Recomp mod sandbox. Setup preferences are kept separately for Gen1 and Gold for the current process/session.

Fresh Yellow and Gold NEW GAME -> SETUP remain RETEST REQUIRED.

## 2.0.0-beta.30.1.6

Current-engine fresh Setup compatibility has been runtime validated:

- Gold fresh Setup: **PASS**
- Yellow fresh Setup: **PASS**
- Blue fresh NEW GAME bedroom entry: **PASS**

The prior Setup CTD was caused by legacy direct filesystem access in pre-game Setup-profile persistence. Current Gen1Recomp blocks that facade for sandboxed mods. The Setup preference layer is now session-local.

**Temporary limitation:** fully restarting Gen1Recomp resets pre-game Setup preferences to defaults. Rules committed to an actual save keep their normal persistence.

Gold remains beta/experimental overall. Permanent Rule Seal remains WIP/unselectable.

## 2.0.0-beta.30.1.7 — Gold Pokégear integration

With active `pokegear_cards` API v1 on Gold:
- **NUZ card:** run status, encounters, rules, caps/difficulty.
- **MAP:** Nuzlocke landmark encounter-state markers.
- **RADIO:** tiered Nuzlocke World Building/status overlay.
- **PHONE:** intentionally unchanged.

The provider is optional. Missing/disabled/wrong-version Pokegear Cards leaves the existing Nuzlocke UI intact. No mechanical Nuzlocke rule depends on this integration.

## 2.0.0-beta.30.1.8

Provider delegation hardening:

- Trainer Money runtime enforcement now respects an active `economy_provider`.
- Delegated Trainer Money leaves the external provider's final payout untouched.
- Delegated numeric controls now support an explicit neutral value.
- Trainer Money's delegated display is **100%** rather than the misleading **0%**.

No unrelated gameplay behavior was intentionally changed from 30.1.7.

## 2.0.0-beta.30.1.9

Gold fallback level-cap progression now restores the previously intended monotonic mid-game order:

**Chuck 30 -> Pryce 31 -> Jasmine 35 -> Clair 40**

This changes only the ordered cap-progression stage list. Gold badge identities/slots remain unchanged.

No unrelated gameplay behavior was intentionally changed from 30.1.8.

## 2.0.0-beta.30.1.10

Title Setup compatibility fallback now treats save-editor state as dynamic session state:

- install-time editor guard retained;
- per-title-open editor guard added;
- SETUP is not injected into later save-editor title sessions by a previously installed wrapper.

No package files were added or removed.

## 2.0.0-beta.30.1.11

Route Forgiveness split-module repair:

- fixes Gold Standard Mart construction using an undefined bare `forgivenessEnabled()` call;
- fixes the Route Forgiveness status label using an undefined bare `forgivenessTokens()` call;
- both now use `mod.exports.__beta26.TrainerRewards`.

No package files were added or removed.

## 2.0.0-beta.30.1.12

Stored catch recovery is hardened:
- empty valid area -> restores normally;
- matching existing entry -> registers normally;
- conflicting occupied area -> stale location cleared and mon remains Legacy-Recovery eligible.

No unrelated behavior was intentionally changed.

## 2.0.0-beta.30.1.13

Solo Only now consistently covers scripted non-wild acquisitions:

- gifts: already enforced;
- NPC trades: now enforced too;
- wild catches: existing catch-time enforcement unchanged.

No package files were added or removed.

## 2.0.0-beta.30.1.14

First Rival Mercy now latches only on the real opening Rival battle.

- later/non-opening Rival: no mercy, no one-shot consumption;
- actual opener: consumes the one-shot;
- actual opener with Mercy ON: forgiveness arms;
- actual opener with Mercy OFF: slot is still consumed as intended.

No unrelated behavior was intentionally changed.

## 2.0.0-beta.30.1.15

World Building tier consistency fix:

- `queueTrainerFlavor` now carries its requested minimum tier through its fallback path;
- First Rival Mercy can therefore show its intended Tier 1/2 notice even when the battle object lacks `say`/`emit`;
- ordinary `worldOnce` callers still default to Tier 3.

No unrelated gameplay behavior was intentionally changed.

## 2.0.0-beta.30.1.16

Type Locke now recognizes the canonical **FAIRY** type.

- Fairy Monolocke / Fairy Duolocke selections are supported.
- Pure Fairy Pokémon no longer fall through the unknown-type fail-open path.
- Dual types such as Water/Fairy match either selected type normally.
- RANDOM includes Fairy only when represented in the live merged species pool.
- Save compatibility is preserved: selector `17` is still RANDOM; FAIRY is appended at `18`.

This compatibility is generic and does not require a hard dependency on a specific typing mod.

## 2.0.0-beta.30.1.17

R/B/Y Mart enforcement is now translation-safe.

- No Buying recognizes translated BUY labels.
- No Selling recognizes translated SELL labels.
- English behavior remains unchanged.
- Gold's semantic Mart enforcement is unchanged.

This was found while reviewing the Suomi/Finnish translation mod.

## 2.0.0-beta.30.1.18

### Optional Modern UI integration

Nuzlocke now exposes responsive semantic models for:
- Encounter Tracker / Area Guide
- NUZ INFO
- Trainer Card / Nuzlocke status

The integration is optional and Gen1-only. Native screens remain the fallback.

The rule editor and fresh Setup remain native in this build to protect their more complex interaction/state paths.
