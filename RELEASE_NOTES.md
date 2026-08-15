# Nuzlocke 2.2.2 RC

Direct child of 2.2.1 RC. Changes the compact Trainer Money label from `Trnr ¥` to `Btl. ¥`. Yellow 2.1.24 save-game runtime testing confirmed No Buying, No Selling, and No Center Heal / Pokémon Center healing enforcement; those paths are recorded as protected runtime PASS behavior. No enforcement logic or compatibility contract changed.

# Nuzlocke 2.2.1 RC

Direct child of 2.2.0 RC. This is a narrow Gold UI correction: the Setup/NUZ RULES value and toggle column is moved one native tile left after 2.1.24 runtime testing showed the previous right-edge anchor crowding the menu frame. The wider rule-label field is retained. No rule logic, save/API behavior, R/B/Y layout, or Gen1Recomp 0.1.94 compatibility behavior changed. Runtime visual retest is required.

# Nuzlocke 2.2.0 RC

Direct child of 2.1.24 RC. This build combines the requested Gen1Recomp 0.1.94 compatibility audit with the pending runtime repair pass that would otherwise have been 2.1.25.

Gen1Recomp 0.1.94 is now source-audited. The v0.1.93→v0.1.94 delta is 10 commits and primarily adds version-aware mod-conflict handling plus API-2 `mod.postLog`/`log_url`. Nuzlocke does not need outbound log delivery, so it keeps only `engine_internals` and does not request the new `network` permission. The engine range remains `>=0.1.86 <0.1.98`, with audited marker 0.1.94.

Runtime-facing repairs: NUZ INFO has a safe model/fallback boundary; MOD COMPAT is width-safe without Modern UI while retaining full labels with it; NUZ ST. carries explicit section headings; Yellow now skips Professor Oak's Pallet capture demonstration as well as the Viridian tutorial demo without skipping surrounding story progression; and Bryan uses native NPC rendering instead of the rough custom sprite. Runtime retest is required.

# Nuzlocke 2.1.24 RC

This narrow repair targets the remaining R/B/Y party-menu crash: NUZ INFO now uses Gen1Recomp's native mod-facing ListMenu and the existing read-only Nuz Info API model. The 2.1.23 randomized-starter and Trainer Money runtime PASSes are preserved. Gold NUZ INFO remains unchanged.

# Nuzlocke 2.1.23 RC

Direct child of 2.1.22 RC. This pass treats the repeatedly reported T3 dialogue issue as a system problem instead of continuing to patch individual NPCs. All Nuzlocke-owned overworld/world-building text now shares one 18-glyph/two-line page formatter, and at World Building T3 the R/B/Y ScriptRunner normalizes vanilla `\v` continuation dialogue through that same presentation boundary while preserving command flow, substitutions, choices, and flags. T0-T2 remain unchanged.

R/B/Y Skip Catch Demo now intercepts `old_man_demo`, the semantic command used by both Red/Blue and Yellow, so the battle demonstration is skipped without skipping the surrounding story script. Gold retains its separate tutorial implementation. Gold Setup/NUZ RULES also right-aligns short toggles farther right while restoring more label width. Runtime retesting is required.

---

# Nuzlocke 2.1.22 RC

Direct child of 2.1.21 RC. This repair targets the two remaining R/B/Y START-menu crashes reproduced on Yellow: NUZ ST. and MOD COMPAT. Both now use Gen1Recomp's stable ListMenu mod UI surface rather than custom hand-drawn states, while keeping Nuzlocke's underlying status and compatibility data. Gold keeps its existing generation-native paths. No rule mechanics or save/API semantics changed. Runtime confirmation is required.

---

# Nuzlocke 2.1.21 RC

Direct child of 2.1.20 RC. This is a narrow Gold presentation cleanup. The Gold-native Setup/NUZ RULES list now leaves one full tile between the rule name and its value/toggle. The value column remains seven tiles wide; the label field alone is reduced from 10 to 9 tiles so longer values such as money/type labels keep their existing room.

No rule mechanics, save/API semantics, R/B/Y configuration layout, or 2.1.20 Nuz-menu crash-recovery code changed. Runtime visual confirmation is required on Gold Setup and Gold in-game NUZ RULES.

---


# Nuzlocke 2.1.20 RC

This is a focused Yellow runtime-follow-up built directly from 2.1.19. It preserves the newly confirmed Setup, startup-resource, name-skip, Type Locke selector, and native Trainer Card PASS paths. The blocking change is safer NUZ RULES / NUZ STATUS error recovery: a custom-screen draw fault is now deferred to the update phase instead of popping the active state from inside draw, allowing the mod to surface the underlying diagnostic rather than escalating a recoverable menu error into a process crash.

Game Difficulty now has a dedicated section. Money controls use the native ¥ glyph, No Escape Rope has an unambiguous compact label, and PC Heal Items is presented as Heal Loadout. Type Locke mode semantics are unchanged and statically revalidated; gameplay enforcement still needs runtime testing.

## 2.1.19 release candidate

Direct child of 2.1.18 RC. This code-review hardening pass fixes three lifecycle/compatibility issues without changing Nuzlocke rule mechanics: kerning install retries are generation-neutral while rendering remains Gen1-gated; Gen1 Modern UI adapter registration accepts only explicit `true` as success; and the R/B/Y title SETUP fallback uses one reload-stable wrapper with mutable current dependencies instead of closing permanently over one mod instance. The title adapter also migrates the exact 2.1.18 legacy wrapper when safe and can rebind a legacy SETUP row to the current `openSetup` callback when another wrapper sits above it. Runtime testing is required, especially R/B/Y title Setup, save-editor enter/leave behavior, mod reload behavior, and Modern UI coexistence.

## 2.1.18 release candidate

Direct child of 2.1.17 RC. Yellow 2.1.16 runtime confirmed default-name skip and PC Vitamins, while opening the Nuzlocke-owned Trainer Card wrapper crashed. 2.1.18 restores full native ownership of the R/B/Y Trainer Card row and exposes Nuzlocke run status through a separate `NUZ ST.` START-menu entry that does not construct the native card. A shared script-transaction guard also prevents two Nuzlocke enforcement/flavor seams from showing two mod-authored boxes for one interaction. The reported SNES line overlap was verified as the original `_RedBedroomSNESText` `cont` scroll sequence and is intentionally not rewritten. Runtime testing is required.

## 2.1.16 release candidate

Direct child of 2.1.15 RC. Type Locke now supports OFF / MONO / DUO / TRI with 0 / 1 / 2 / 3 visible selectors respectively. The legality engine consumes exactly those active displayed selections; OFF returns an empty allowed-type set and therefore imposes no type restriction. Type 3 is persisted only for TRI and is kept distinct from Types 1 and 2. No Catching moves to GENERAL and Route Forgiveness moves to CLAUSES without changing their gameplay logic. Section headers retain the centered bold-like treatment but gain one-pixel inter-glyph tracking. Runtime testing is required on Gold and at least one R/B/Y game.

## 2.1.15 release candidate

Direct child of 2.1.14 RC. This pass is limited to configuration presentation/state consistency. Section headers are centered with bold-like pixel emphasis, rule labels reclaim the left gutter, Type Locke OFF has no visible/active type selectors, and the reversible Rule Lock control is restored independently of the still-disabled Permanent Rule Seal. Gold and R/B/Y share the same state invariant. Runtime testing is required.

## 2.1.14 release candidate

Focused Type Locke UI/state repair built directly from 2.1.13 RC. In MONO mode, Type 2 is now semantically NONE and removed from the shared R/B/Y + Gold configuration list while MONO is active. Switching back to DUO reconstructs a valid distinct Type 2. Runtime confirmation is required on Gold and at least one R/B/Y game.

## 2.1.13 release candidate

This is a focused Yellow/T3 repair candidate built from the canonical packaged 2.1.12 RC.

Yellow Random Starter now rejects incomplete compatibility/provider species records that cannot satisfy the concrete Pokémon + Summary-screen data contract. The existing `pokemon.before_give` transaction seam is preserved because Gen1Recomp creates the Pokémon after that event returns.

T3 home behavior is also repaired: Mom has a one-response transaction guard, Pallet TV reports are cleanly paginated with no `Rule watch:` append, and Bryan is inserted as a real T3 home NPC with rotating dialogue rather than existing only as flavor strings.

No runtime PASS is claimed yet. Yellow starter OFF/ON + Party/Summary, Mom, TV, Bryan, Setup/Rules/MOD COMPAT, and Wide Menus classic coexistence require runtime confirmation.

## 2.1.12 release candidate

Route Forgiveness now rewards badge progress rather than individual Gym Trainers: defeating a Gym Leader gives one token for that Gym, once. Ordinary Gym Trainers give none, and the Gym Guide is not a second payout source.

The compact-label system also adds `Nuz. Loadout`, `Dung. Lock-In`, `BATTLE ITMS`, `FIELD ITMS`, and compact `Itms` rule labels while keeping full natural phrases as the canonical translation keys.

## 2.1.11 release candidate

This candidate makes the compact rule-menu work safe for translation packs and source-audits the newly released Gen1Recomp 0.1.93.

Natural full labels are once again the canonical translation strings. English abbreviations are optional display fallbacks, not replacement source keys. A translated full label will never be replaced by an untranslated English shorthand.

Gen1Recomp 0.1.93 remains inside the existing `>=0.1.86 <0.1.98` envelope and is now source-audited. No new Nuzlocke permission or gameplay-hook rewrite was required.

## 2.1.10 release candidate

This candidate reduces unnecessary marquee scrolling by making the R/B/Y rule list itself more compact. Familiar abbreviations are used only in the short menu labels; the explanation box retains the full rule meaning.

Wide Menus coexistence remains on the safe classic/native-width path. The current marquee timing is unchanged because Yellow runtime testing approved it.

## 2.1.9 release candidate

This candidate keeps the now-approved marquee speed and avoids more unnecessary scrolling with a few familiar rule abbreviations.

It also addresses the remaining Wide Menus crash at fresh NEW GAME Setup. Nuzlocke Setup/Rules now explicitly opt into Wide Menus' classic/native layout contract instead of merely not claiming wide mode.

Please retest Yellow with Wide Menus installed: fresh NEW GAME → SETUP, then enter the game and open NUZ RULES.

## 2.1.8 release candidate

This is a small presentation refinement after the variable-width UI work.

Common Randomizer labels are shortened enough to fit the normal R/B/Y rule list more often, while the description pane keeps the full explanation. Marquee scrolling remains available only for labels that still genuinely exceed their measured pixel budget.

## 2.1.7 release candidate

This candidate focuses on Yellow UI stability.

Wide Menus may stay installed, but Nuzlocke no longer claims its wide canvas for NUZ RULES because the 2.1.6 runtime path crashed. The custom outline selection experiment is also removed; the native cursor glyph returns in a tighter left position so selection is obvious without giving back the entire old gutter.

Long text still scrolls only when it genuinely exceeds the measured pixel budget, using the restored slow cadence.

## 2.1.6 release candidate

This candidate corrects two Yellow presentation regressions from 2.1.5.

Long labels still scroll only when they genuinely exceed their pixel budget, but scrolling is back to the old slow pace after a three-second pause. The filled selection bar has been replaced with a thin outline so selected-row text remains readable while still reclaiming the old left-arrow gutter.

## 2.1.5 release candidate

This candidate refines the new variable-width R/B/Y rules presentation based on runtime feedback.

Labels that fit remain still. Labels that do not fit scroll instead of being shortened with `...`. The native left cursor glyph is replaced on Nuzlocke's R/B/Y rules rows with reverse-video selection, giving rule names more usable width.

Descriptions continue to use pixel-aware wrapping and only scroll vertically when the complete text cannot fit.

MOD COMPAT follows the same principle: safe separate columns, with scrolling only for true overflow.

## 2.1.4 release candidate

Yellow 0.1.92 testing confirmed that Gen1 variable-width text is now active and that MOD COMPAT no longer crashes. This candidate cleans up the presentation that became visibly outdated once kerning started working.

R/B/Y Setup and NUZ RULES now use pixel-aware static labels and descriptions. Marquee scrolling is removed from the normal Gen1 rules presentation; true horizontal overflow is ellipsized, and descriptions scroll only if their pixel-wrapped text genuinely exceeds the visible description area.

MOD COMPAT also now uses measured/truncated columns to prevent the overlap seen in 2.1.3 RC.

## 2.1.3 release candidate

Focused correctness candidate after the 2.1.2 Yellow/0.1.92 repair.

Three independently-reviewed issues are fixed: Gym Trainer reward-key collisions, dead Gen1 kerning caused by an unset `mod.game`, and false-LEGAL reporting for string-valued invalid acquisitions in the new `compat21` diagnostics API.

The engine envelope remains `>=0.1.86 <0.1.98`. Gen1Recomp 0.1.92 is source-reviewed; 0.1.93–0.1.97 remain forward-allowed rather than runtime-confirmed.

## 2.1.2 release candidate

Runtime repair for Yellow on Gen1Recomp 0.1.92. Fresh Setup/boot behavior from 2.1.1 is protected. The R/B/Y MOD COMPAT crash is repaired by using the current Font API instead of the removed Draw module. Gen1 kerning now retries after game/save lifecycle readiness.

Please retest MOD COMPAT and visible text spacing in both Setup and in-game Nuz Rules.

## 2.1.1 release candidate

This candidate updates Nuzlocke's Gen1Recomp compatibility declaration after a source review of engine 0.1.92. The engine range is now `>=0.1.86 <0.1.98`.

0.1.92 is source-reviewed. Versions 0.1.93–0.1.97 are proactively allowed under the project's five-patch forward-compatibility policy but are not called tested until they exist and are re-audited.

No new network/background permissions are requested. No save-schema or Mod API change.

## 2.1.0 — versioning transition

This is the same functional build as `2.0.0-beta.31.0.4`, renumbered to `2.1.0` so future Nuzlocke releases use straightforward updater-compatible semantic versions.

No gameplay changes were made by this transition.

## beta.31.0.4 — Wide Menus phase 1

When optional `wide-menus` V0.1.0 is active, the in-game R/B/Y **NUZ RULES** screen now uses its 304×144 presentation surface. Labels and descriptions get substantially more horizontal room while Nuzlocke continues to own every rule and action.

Native fallback, fresh Setup, and Gold are unchanged. Runtime visual/input test required.

## beta.31.0.3 — Mt. Moon Center lock-in fix

Dungeon Lock-In no longer treats Pokémon Center/Poké Mart service interiors as dungeon floors solely because their map identifier shares a dungeon prefix. This specifically targets the reported Mt. Moon Pokémon Center trap without weakening the real Mt. Moon floor lock.

Runtime retest required.

## beta.31.0.2 — Gen1Recomp 0.1.90 compatibility

- Reviewed the full upstream 0.1.89 → 0.1.90 delta.
- Existing engine range already supports 0.1.90.
- No gameplay code change was required.
- Gold benefits from upstream generation-aware PartyMenu field-move handling and save-slot recovery.
- Runtime smoke test on 0.1.90 is still required before calling compatibility runtime-confirmed.

## beta.31.0.1 — reviewed repair batch

- Fixed stable difficulty-provider staging after live profile changes.
- Hardened optional Modern UI against duplicate registration, unknown generation, and Gen1→Gold same-session transitions.
- Fixed R/B/Y title Setup fallback installation when the mod initially loads during a save-editor session.
- Hardened Trainer Rewards dependency validation and corrected R/B/Y Gym Leader success reporting.
- Prevented Gym Trainer reward suppression caused by leader-name matches formed only across concatenated identity fields.
- No new feature surface; runtime test required.

## beta.31.0.0 — development-line promotion

- Promotes the canonical development head from `.30.1.23` to `.31.0.0`.
- No intentional gameplay or presentation changes.
- Egglocke remains on the backlog above Wonderlocke; neither is active.

## beta.30.1.23 — Tier 3 World Building expansion

- Bryan has a larger recurring fictional Tier 3 presence at the Pokémon Bois Club and the player's Pallet home.
- He claims he created the Nuzlocke mod, claims he codes Gen1Recomp on the player's computer, says “boi” frequently, and treats the player's console like his own.
- Mom and Bryan can imply a relationship through non-graphic innuendo.
- Pallet TV gains rotating Bryan-related local-news reports, including a report about a man resembling the Bois Club leader sneaking through windows at night.
- Several existing Tier 3 rule messages receive more contextual wording.
- Achievements remain a design-only future feature. Once implemented, World Building is intended to let NPCs and occasional rule presentation react to unlocked achievements.
- Black Market remains backlog/design only: a future optional shop concept for unusually early rare items and Pokémon diversity, with progression/balance/provider safeguards.
- Runtime validation required.

## beta.30.1.22 — player-facing run intelligence

- Encounter Tracker / Area Guide gains semantic provenance tags and known provider context without exposing future randomizer mappings.
- MOD COMPAT expands from a small ownership summary into a broader mechanic-ownership page covering caps, difficulty, species/identity, encounters, escape/warps, movement and presentation surfaces.
- NUZ INFO Catch adds a **current-rules legality** verdict, restriction reasons, and provider/source provenance.
- The legality view is diagnostic only; it does not mutate Pokémon, encounters, save state, or rule state.
- Repairs stale `.30.1.20` executable build labels that remained inside the `.30.1.21` package.
- Runtime validation is still required for exact R/B/Y, Gold and mixed-mod presentation.


## beta.30.1.21 — compatibility intelligence and contextual guidance

- Encounter Tracker now exposes spoiler-safe external encounter-randomizer ownership without revealing future mappings.
- Adds a dedicated **MOD COMPAT** page showing which active provider owns starter RNG, encounter RNG, learnsets, trainer money, presentation and text layout.
- Hardens semantic UI matching to prefer stable ids/actions/values before translated labels; Mart BUY/SELL retains translated Strings fallback.
- Exposes a merged species-metadata API so compatible content mods can contribute types, classifications and stat metadata without Nuzlocke hard-coding their species.
- Adds adaptive/semantic presentation helpers for compatibility UI and tracker context.
- Extends World Building with context-sensitive Nuzlocke guidance for consumed areas, Lock-Ins, caps, Forgiveness Tokens, progression catches and externally randomized areas. Guidance is presentation only and never enforcement.
- Multi-provider randomizer composition UI remains deferred/backburnered.

# 2.0.0-beta.30.1.20

Gen1-only variable-width Nuzlocke presentation. R/B/Y Nuzlocke text can use tighter tile-font advances while wrapping and draw placement stay consistent. Gold/Gen2 is explicitly excluded and always falls through to the original Font behavior. Existing compatible external kerning is not stacked. No challenge mechanics or save semantics changed.

Parser/static/mock status: **PASS**. R/B/Y visual presentation and Gold no-effect behavior: **RUNTIME TEST REQUIRED**.

## 2.0.0-beta.30.0.0.10

This is a compatibility/conflict hardening build descended directly from 2.0.0-beta.30.0.0.9. It does not add a new gameplay ruleset. It makes external-provider ownership real at enforcement time, unifies public item/acquisition checks with the mature native rule paths, fixes stale/overbroad provider detection, repairs AutoCompat's Pokemon save-state source, delegates EXP Edging with external level caps, surfaces Gold No Fishing correctly, and hardens edited/legacy recovery matching.

Runtime tests are still intentionally deferred. R/B/Y catch-demo skipping and multi-provider randomizer registry restoration remain specifically flagged for proof rather than being declared fixed without evidence.

# Nuzlocke 2.0.0-beta.29.3.16

Direct child of `2.0.0-beta.29.3.15`.

This is the third and final small update split from the already-completed larger pass. It adds the multi-page NUZ INFO party screen and Compatibility API 27.

Catch, Stat, and Move pages can each be enabled independently. Stat Info exposes current stats, DVs, and raw Stat EXP. Move Info reads the live merged move registry so compatible move-data providers are reflected. A/Right advances, Left goes backward, and B closes.

All changed 29.3.16 UI/API paths remain TEST REQUIRED until runtime validation.

# 2.0.0-beta.30.0.0.1
This development build expands the Randomizer beyond starters with **Random Encounters**, **Random Learnsets**, and **Learnset Gen** selection (AUTO/GEN1/GEN2). Rolls persist, encounter structure and learn levels are preserved, and unavailable generation move data fails open instead of inventing invalid references.

Runtime status: **TEST REQUIRED**.

## 2.0.0-beta.30.0.0.2
Adds **No Fishing**: Old/Good/Super Rod and compatible rod use is blocked before fishing starts. Rod inventory and all non-fishing encounter methods remain unaffected.

## 2.0.0-beta.30.0.0.3
Introduces the first **FAFF0x/full-mod-stack interoperability foundation**. Nuzlocke now exposes public capability, acquisition-policy, item-policy, effective-registry, registry-notification, and EXP-composition seams. The design deliberately avoids hardcoded FAFF0x mod names so Modern Bag, Item Shortcut, Repel Reuse, Area DexNav, Summon, Moves Manager, Pokédex Plus, EXP Share providers, quests, and future mods can compose through declared capabilities. Runtime status: TEST REQUIRED.

## 2.0.0-beta.30.0.0.4
Second FAFF0x compatibility pass. This build turns the 30.0.0.3 foundation into practical consumer seams for alternate Bags/item shortcuts, automatic Repel reuse, DexNav/Summon encounters, PC replacements, registry-driven Pokédex/move managers, and EXP providers. It remains capability-first and does not depend on FAFF0x package names. Runtime testing is intentionally deferred.

## 2.0.0-beta.30.0.0.5
Fixes the reported Yellow crash-to-desktop when using **REMOVE ENTRY** in Encounter Tracker recovery on an older save. The recovery screen had a path that could place a live Pokémon object inside persisted tracker data; removing/editing an entry could then send that UI object through save serialization. Recovery rows are now detached from persisted records, and legacy tracker data is narrowly sanitized before saving. RETEST REQUIRED.

## 2.0.0-beta.30.0.0.6
Third FAFF0x compatibility pass: quest/content integration. Compatible quest packs can now register dynamic areas and dungeons, scripted/repeatable encounters, gifts/rewards, boss metadata, and randomizer preservation policies through one generic content-provider API. Dungeon Lock-In can consume provider dungeon families, Encounter Tracker receives dynamic areas, and the randomizers can preserve story-critical content. No FAFF0x package IDs are hardcoded. TEST REQUIRED.

## 2.0.0-beta.30.0.0.7
Adds the automatic compatibility/legacy-adapter pass for existing FAFF0x releases that do not yet call the Nuzlocke API. The adapter scans active mods for behavior families, registers temporary capabilities only when no explicit provider exists, observes externally added Pokémon for provenance/recovery handling, and exposes compatibility gates for alternate item, encounter, PC, and registry paths. Explicit provider APIs remain preferred. TEST REQUIRED.

## 2.0.0-beta.30.0.0.8
Consolidation/compatibility-hardening build. The recent FAFF0x interoperability work now uses a clearer canonical capability taxonomy while retaining legacy aliases. Explicit providers take precedence over automatic adapters, and the public API now states the ownership model: external mods may provide mechanics, while Nuzlocke remains authoritative for challenge policy and provenance unless a rule deliberately delegates control. No new gameplay feature is introduced. TEST REQUIRED.

## 2.0.0-beta.30.0.0.9
Adds visible provider delegation to Nuzlocke Setup/Rules. Non-core duplicate features now grey out and become effective OFF/non-toggleable when another active mod owns that mechanic. You can still highlight the row; its help panel states which mod/provider is handling it. Saved Nuzlocke choices are not destroyed and return if that provider is removed. Core Nuzlocke rules remain authoritative and are never auto-disabled.

## 2.0.0-beta.30.0.0.11
Minimal Gen1Recomp 0.1.84 compatibility update. The previous manifest explicitly rejected 0.1.84 because its range ended at `<0.1.84`; this child expands the range to `<0.1.85`. No gameplay or rule-system changes are included. 30.0.0.10 remains the preserved feature-state parent, and future work continues sequentially from this compatibility child.

## 2.0.0-beta.30.0.0.12
Future-proofing checkpoint. Nuzlocke now accepts Gen1Recomp releases from 0.1.81 through the remaining pre-1.0 engine family instead of becoming unloadable every time the engine increments beyond a narrow patch ceiling. A future Gen1Recomp 1.0 remains an intentional review boundary. No gameplay behavior is intentionally changed.

## 2.0.0-beta.30.0.0.13
Startup compatibility repair for Gen1Recomp 0.1.86+. Fresh Blue and Gold runtime tests showed the vanilla title list without Nuzlocke SETUP. The normal public title hook remains primary; this build adds a narrow engine-internals fallback for each generation that inserts SETUP only when the game has no save/CONTINUE entry and SETUP is genuinely absent. Existing saves remain unaffected.

## 2.0.0-beta.30.0.0.14
Parser hotfix for 30.0.0.13. The new title-menu compatibility helpers are now isolated inside a nested function, avoiding the Lua top-level local-variable limit that prevented the mod from loading. Functional intent remains identical to 30.0.0.13.

## 2.0.0-beta.30.0.0.15
Structural startup-compatibility repair. With explicit approval, the Gen1Recomp 0.1.86 title SETUP fallback is now the mod's first extracted Lua module (`title_setup_compat.lua`). Gen1Recomp's own Sandbox documents `load(mod:read(...))` as the multi-file mod pattern, which this build uses. This removes the parser-sensitive fallback block from the giant `main.lua`. No gameplay system is intentionally changed, but startup/menu and regression smoke tests are required before confidence is restored.

## 2.0.0-beta.30.0.0.16
Parser/compiler-limit repair. `main.lua` had exceeded Lua's 200-active-local limit. With explicit approval, the cohesive trainer reward/economy subsystem is now isolated in `trainer_rewards.lua`. This includes Trainer Money, Forgiveness Token reward/shop plumbing, and trainer progression bookkeeping. A failed narrower extraction was caught by pre-package parser validation and was not shipped. All packaged Lua files pass the available Lua parser; runtime testing remains required.

The final `.16` package also scopes the late runtime installer block inside a nested initializer. This is not another module split; it simply prevents late helper locals from counting against `main.lua`'s top-level Lua local limit. All three Lua files pass static parser validation before packaging.

## 2.0.0-beta.30.0.0.17
Permanent Rule Seal safety hotfix. Yellow runtime testing confirmed 30.0.0.16 loads an existing save and exposes the Nuzlocke menus, but the irreversible seal was too easy to activate. It now requires two explicit warnings followed by a third deliberate SEAL activation. Moving away or backing out cancels confirmation. Irreversibility after the final confirmation remains intentional.

## 2.0.0-beta.30.0.0.18
Permanent Rule Seal persistence repair. The seal now uses Gen1Recomp's playthrough-scoped `mod.storage` as an immediate durable mirror, because normal `mod.save` changes are only written with an ordinary Pokémon SAVE. A sealed run should therefore remain sealed after quitting/reloading even if the player did not save again after committing the seal. The existing rule-lock scope is unchanged: challenge rules are locked; QoL, World Building, and UI/presentation remain editable.

## 2.0.0-beta.30.0.0.19
Permanent Rule Seal is temporarily disabled. It now behaves like Wonderlocke WIP: visible, grey, marked WIP, skipped by selection, and non-activatable. The implementation remains dormant in `main.lua` and is mapped in `docs/API.md` for recovery. Existing development-test seal markers are retained but not enforced while the feature is WIP.

## 2.0.0-beta.30.0.0.20
Dialogue-overlap hardening. Optional Nuzlocke World Building text will no longer open while a vanilla/other TextBox is already active. This is a conservative presentation safeguard aimed at the recurring Yellow page-overlap/repeated-phrase bug without changing rule enforcement. The Yellow NUZ vertical-position issue is documented but intentionally deferred.

## 2.0.0-beta.30.0.0.21
Rules UI cleanup. Percentage rules now keep their `%` labels on status surfaces, with Trainer Money using a shared label source. Maximum BST is now a preset selector instead of manual numeric entry: OFF, 400, 450, 500, or 550. Existing legacy/custom BST values are preserved until the control is changed.

# Nuzlocke 2.0.0-beta.30.1.0

This beta promotes the current 30.0 development line after successful Yellow runtime checks.

### Confirmed in Yellow
- Existing-save boot works with Nuzlocke menus visible.
- Nuz Rules opens in game.
- Gym Lock-In correctly rejects the tested prohibited Gym boundary transition.
- The specific Poké Mart NPC used to reproduce the recurring duplicate-page dialogue bug no longer repeats text after the active-TextBox presentation guard.

### Important current behavior
- Permanent Rule Seal is temporarily **WIP**, greyed out, and unselectable. Its implementation is preserved for future recovery/testing.
- Optional World Building dialogue will not open on top of an already-active TextBox. Keep this safeguard when adding future dialogue/world-building hooks.
- Trainer Money and other percentage-based controls display percentage labels consistently.
- Maximum BST now cycles through **OFF / 400 / 450 / 500 / 550** instead of free-form three-digit editing.
- The Yellow `NUZ` status label is known to sit slightly too low; that cosmetic adjustment is intentionally deferred.

### Structure and compatibility
The approved module split remains intentionally small: `main.lua`, `title_setup_compat.lua`, and `trainer_rewards.lua`. No additional Lua split was made for this release. The compatibility target remains Gen1Recomp `>=0.1.86 <0.1.91`, Mod API 2.

# 2.0.0-beta.30.1.1

Gold startup crash containment.

A fresh Gold runtime test crashed when selecting Nuzlocke SETUP in the 30.1.0 candidate. Comparison with the last published 29.1.0 showed that Gold already had a previously runtime-PASS title integration through the shared title-menu hook and `MainMenu:choose()` adapter.

This build disables only the newer Gold `MainMenu:buildList()` fallback added during the 0.1.86 compatibility work. Its full code is retained dormant in comments for recovery. R/B/Y fallback behavior is unchanged.

Gold NEW GAME -> SETUP must be runtime retested before release.

# Nuzlocke 2.0.0-beta.30.1.2

This beta is being released with one important known runtime bug.

## ⚠ Known issue — Gold NEW GAME Setup

On the current tested Gen1Recomp environment, a fresh Gold game can reach the title-side Nuzlocke SETUP entry, but **selecting SETUP crashes the game**.

The 30.1.1 attempt to remove the newer Gold title-list fallback did not fix the crash. That fallback remains disabled and preserved in comments for later investigation. Gold therefore remains explicitly experimental, and **fresh Gold NEW GAME -> Nuzlocke SETUP should be considered broken in this release**.

No further Gold startup changes are being attempted in this release.

## Confirmed Yellow runtime behavior

- Existing save boots with Nuzlocke menus visible.
- Nuz Rules opens correctly.
- The tested Gym Lock-In boundary rejection works.
- The specific Poké Mart dialogue used to reproduce the recurring duplicated-page bug no longer reproduces it after the active-TextBox World Building guard.

## Other current notes

- Permanent Rule Seal is WIP, greyed out, and unselectable.
- Maximum BST uses OFF / 400 / 450 / 500 / 550 presets.
- Percentage-based controls retain percentage labels.
- Yellow `NUZ` status placement is slightly too low; cosmetic fix deferred.
- Approved Lua structure remains `main.lua`, `title_setup_compat.lua`, and `trainer_rewards.lua`.

# 2.0.0-beta.30.1.3

Diagnostic crash guard for Setup/Nuz Rules. Instead of allowing a custom configuration-screen construction error to cascade into a desktop crash, the mod should now display `NUZLOCKE SETUP ERROR` with the underlying failure.

Please capture that exact message. The old unsplit 29.3.0 reproduced the same runtime crash, although the current monolithic main chunk is also confirmed to be at Lua's 200-local ceiling and will need a deliberate future split for maintainability/headroom.

# 2.0.0-beta.30.1.4

Second-stage Setup crash diagnostic. Construction is already guarded; this build additionally guards the Setup/Nuz Rules screen's first `update()` and `draw()` frames.

If the failure is a Lua runtime error, the game should remain alive and display either `NUZ SETUP UPDATE ERROR` or `NUZ SETUP DRAW ERROR`. Please capture that exact message.

# 2.0.0-beta.30.1.5

This build targets the first concrete cause found for the current-engine fresh Setup crash.

The old pre-game Setup profile path accessed a filesystem API that Gen1Recomp 0.1.86 no longer exposes to sandboxed mods. That happens before the custom Setup screen is pushed, which is why earlier screen crash guards did not catch it.

Setup-profile preferences are now session-local. Fresh Yellow and Gold NEW GAME -> SETUP should be retested.

Temporary limitation: Setup-profile preferences do not survive a full application restart in this diagnostic build. Rules committed to an actual game save retain their normal save behavior.

# Nuzlocke 2.0.0-beta.30.1.6

This release restores fresh-game Nuzlocke Setup compatibility on the current tested Gen1Recomp line.

## Runtime validation

- **Pokémon Gold:** fresh NEW GAME -> SETUP opens without crashing.
- **Pokémon Yellow:** fresh NEW GAME -> SETUP opens without crashing.
- **Pokémon Blue:** fresh NEW GAME proceeds into the player's bedroom.

## What fixed the crash

The old pre-game Setup-profile loader/saver used direct filesystem access. Current Gen1Recomp sandboxes that API from mods. Because the failure happened before the Setup screen was opened, previous screen-level crash guards could not catch it.

The Setup preference layer now stays in memory for the current application session instead of using the blocked filesystem facade.

## Temporary limitation

Setup-profile preferences reset after fully closing Gen1Recomp. Rules committed to an actual game save continue to use normal save persistence.

## Other current notes

- Gold remains beta/experimental overall despite the fresh Setup runtime pass.
- Permanent Rule Seal remains WIP and unselectable.
- Maximum BST uses OFF / 400 / 450 / 500 / 550 presets.
- Yellow `NUZ` status placement is slightly too low; cosmetic adjustment remains deferred.

# Nuzlocke 2.0.0-beta.30.1.7 — development test build

Adds optional Gold Pokegear Cards API v1 integration:
- four-page NUZ status card;
- Nuzlocke encounter markers on vanilla MAP;
- tiered Nuzlocke World Building line on vanilla RADIO.

The integration is additive and deliberately leaves PHONE untouched. R/B/Y are unchanged.

Runtime test requested: Gold with Pokegear Cards active — open NUZ, page through it, inspect MAP markers, inspect RADIO with World Building enabled, verify vanilla card navigation, then verify Nuzlocke still behaves normally with Pokegear Cards disabled.

# Nuzlocke 2.0.0-beta.30.1.8

Small provider-compatibility fix on top of 30.1.7.

### Trainer Money
When another active mod owns the `economy_provider` capability, Nuzlocke now leaves that provider's trainer payout completely untouched. Previously the Rules UI could show Trainer Money as delegated while Nuzlocke still applied its stored multiplier after battle.

Delegated Trainer Money also now displays its true neutral value, **100%**, rather than incorrectly displaying **0%**.

The Gold NUZ Pokégear card, MAP overlay, and RADIO World Building integration from 30.1.7 are otherwise unchanged and still require Gold runtime testing.

# Nuzlocke 2.0.0-beta.30.1.9

Small Gold level-cap regression fix on top of 30.1.8.

The Johto cap-stage list had slipped back to Chuck -> Jasmine -> Pryce, producing a raw 35 -> 31 step. This build restores the previously intended project ordering:

**Chuck 30 -> Pryce 31 -> Jasmine 35 -> Clair 40**

Gold's actual badge identity/slot mappings are unchanged.

The Trainer Money provider fixes from 30.1.8 and the optional Gold Pokégear work remain otherwise unchanged.

# Nuzlocke 2.0.0-beta.30.1.10

Small title-menu compatibility hardening release.

The fallback SETUP-row adapters now re-check save-editor session status every time the title menu is rebuilt/opened, rather than relying only on the state that existed when the wrapper was first installed.

This prevents a long-lived title wrapper from injecting Nuzlocke SETUP into a later save-editor session.

No unrelated gameplay behavior is intentionally changed.

# Nuzlocke 2.0.0-beta.30.1.11

Fixes two split-module namespace errors involving Route Forgiveness.

- Gold Standard Marts now call the Trainer Rewards module's qualified `forgivenessEnabled()` export instead of a nonexistent bare global.
- Route Forgiveness token status now calls the qualified `forgivenessTokens()` export.

The Gold Mart bug could otherwise crash shop construction when Route Forgiveness was enabled.

No unrelated gameplay behavior is intentionally changed.

# Nuzlocke 2.0.0-beta.30.1.12

Fixes an encounter-recovery edge case where an older Pokémon could be silently lost from the tracker recovery flow.

If its stored catch location conflicts with a different catch already established in that area, Nuzlocke now treats the location as unresolved and sends the mon back through Legacy Recovery instead of falsely marking it registered.

# Nuzlocke 2.0.0-beta.30.1.13

Fixes a Solo Only enforcement gap.

NPC trades now obey the same Solo Only party-slot restriction as gifts and wild catches. Previously a scripted trade could add a second usable Pokémon while Solo Only was active.

The existing Solo Only rejection/world-building message is reused. No unrelated acquisition-rule behavior is intentionally changed.

# Nuzlocke 2.0.0-beta.30.1.14

Fixes an edge case in **First Rival Mercy**.

A battle that looked like a Rival battle but was not the canonical opening Rival encounter could previously consume the one-time mercy slot permanently. The durable slot is now consumed only when the actual opening Rival battle is positively identified.

Later Rival fights still do not receive mercy on old saves, and reaching the real opener still consumes the one-shot even when First Rival Mercy is disabled.

# Nuzlocke 2.0.0-beta.30.1.15

Fixes a World Building fallback inconsistency.

First Rival Mercy explicitly allows its battle flavor notice at World Building Tier 1, but on battle objects without native `say` or `emit`, the fallback path still required Tier 3. The fallback now honors the same minimum tier requested by the caller.

The normal World Building once-only flag and safe text-push behavior are unchanged.

# Nuzlocke 2.0.0-beta.30.1.16

Adds canonical **Fairy** awareness to Mono/Duo Type Locke for compatibility with modern typing/content mods.

Most importantly, this is save-safe: the existing numeric value **17 remains RANDOM**. Fairy is appended as value **18**, so an old RANDOM selection can never silently become Fairy.

Pure Fairy and dual Fairy Pokémon now participate correctly in Type Locke legality, while RANDOM includes Fairy only when Fairy actually exists in the live merged species pool.

# Nuzlocke 2.0.0-beta.30.1.17

Fixes **No Buying / No Selling** with localization mods on Red/Blue/Yellow.

The Mart gate now recognizes both the canonical English source labels and the active translated `Strings("BUY")` / `Strings("SELL")` labels. Finnish `OSTA` / `MYY`, for example, can no longer bypass the rule.

Gold's semantic Mart gates are unchanged.

# Nuzlocke 2.0.0-beta.30.1.18

Adds an optional presentation bridge for **Gen1 Modern UI**.

With a compatible active Modern UI provider, Encounter Tracker, NUZ INFO and the Nuzlocke Trainer Card/status page can render as responsive modern cards instead of dropping back to the classic 160×144 presentation.

Nuzlocke still owns every rule and action. With Modern UI absent or incompatible, the existing screens are unchanged.

Setup / Nuz Rules editing intentionally stays on the proven native renderer for now.
