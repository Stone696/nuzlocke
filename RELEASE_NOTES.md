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
