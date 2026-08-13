# Nuzlocke

A configurable Nuzlocke rules mod for Pokémon Gen1Recomp.

This package is **2.0.0-beta.27.16**, the final release candidate built from the beta.27 lineage. It targets Gen1Recomp **0.1.78 through 1.x**, with the compatibility audit performed against **0.1.79**. Save schema remains **4** and the Gen1Recomp manifest API remains **2**.

## Install

Place this directory in Gen1Recomp's mods directory as the `nuzlocke` mod folder. At minimum, keep these files together:

- `main.lua`
- `manifest.json`

Fully quit and relaunch Gen1Recomp after replacing an older build. This is important when the Save Editor has been used in the same application session because the mod owns protected runtime wrappers.

## Current feature surface

R/B/Y exposes the full configuration screen, including:

- core Nuzlocke, Permadeath, opening Rival forgiveness, First Catch, Failed Encounters, and forced nicknames;
- Species/Family Dupes and Shiny clauses;
- optional Route 1-25 cardinal splits, Mt. Moon floor splits, and Safari Zone area splits;
- town/overworld, gift, trade, legendary, mythical, static-encounter, Game Corner, Maximum BST, and glitch/MissingNo policy;
- Gym through Postgame level-cap scopes;
- battle, field-item, shop, healing, Whiteout, and Solo restrictions;
- World Building tiers, Catch Info, Area Guide, tracker, history, and Nuzlocke status UI.

All encounter split selectors default to **OFF**. Split changes are projected immediately from physical-map provenance, so the tracker, caught-area state, Catch Info, and future legality move between grouped and split views without deleting catch records.

Gold exposes a deliberately reduced beta surface: core encounter/death rules, Rival forgiveness, forced non-empty nicknames for supported catches and scripted gifts, Dupes/Shiny, Maximum BST, glitch handling, static/Game Corner bans, level caps, No Escape, Ball Use Ban, buying/selling, Whiteout, and Area Guide. Gold status is available from **NUZ STAT** in the START menu. Gold options are still labeled **TEST REQUIRED** in-game where complete runtime parity has not been demonstrated.

Ball Use Ban is cumulative. `POKE`, `GREAT`, and `ULTRA` ban the named standard Ball and weaker tiers. `STANDARD` bans Poke, Great, Ultra, and Master Balls while leaving specialty/custom Balls eligible. `ALL` bans every recognized Ball. Existing numeric tier-4 saves remain compatible.

## Release-candidate compatibility behavior

- Setup is a new-game-only title entry. If the final title menu contains `CONTINUE` or the Gold `continue` value, Setup is not inserted.
- One authoritative cap calculation feeds EXP enforcement, Rare Candy checks, NUZ STATUS, Trainer Card status, Gym Guide text, and tracker displays.
- Boss caps read the merged live trainer registry and runtime `trainer.party` results, so trainer-overhaul level edits are reflected without a Nuzlocke-specific patch.
- Cap progression is monotonic: a later modified boss cannot lower the active cap below a defeated boss's live ace level.
- Existing R/B/Y and Gold saves seed Gym/League progression from durable badges and story flags. Live Gold trainer wins are recognized even though the Gen 2 battle object has no Gen 1 `kind` field.
- External `level_caps` and `postgame_caps` providers accept common function/method and result-field aliases. Capability relationships are reported through `nuzlocke_compat` v22.
- Dynamic trainer observations are cleared whenever the loaded mod composition changes, preventing stale caps after a trainer mod is disabled or replaced.
- Save Editor sessions do not install the direct runtime wrappers that must remain bound to gameplay state.

## Rule precedence highlights

- The master Nuzlocke switch disables rule enforcement.
- The opening Rival forgiveness exception applies once, is consumed when the first eligible Rival battle begins, defaults ON, and is OFF in Hardcore.
- Static Encounter Ban is absolute; Shiny Clause does not bypass it.
- Shiny Clause may bypass area and duplicate restrictions, but not legendary/mythical, Maximum BST, static, or Solo restrictions.
- An eligible duplicate is handled before Maximum BST, so a duplicate over the limit remains a free duplicate encounter.
- Unknown or incomplete modded stat schemas fail open for Maximum BST instead of guessing.
- MissingNo, registry-flagged glitches, and malformed species are blocked by default but preserved safely if already owned. The Glitch Pokémon toggle allows new acquisitions.
- Mandatory starters are exempt from acquisition rules that could break story progression.
- Gold scripted gifts use the native blocking naming-screen seam, so the story VM resumes only after a required non-empty nickname is accepted.
- Native Gold fixed encounters and compatible mod-created battles carrying explicit static provenance both reach the No Static Ball gate.

## Validation

The package includes two release tests under `tests/`:

- `release_gate.js` performs structural, interaction-order, compatibility-contract, and optional engine-source checks.
- `smoke.lua` loads the complete mod with a headless API facade and exercises title menus, live caps, Gold progression, nickname enforcement, Game Corner registry restoration, native/modded static policy, Ball Use tiers, splits, BST/glitch policy, provider aliases, and World Building cleanup.

See [TESTING.md](TESTING.md) for commands and the final gate result. Headless tests are strong regression evidence but do not replace an in-game disposable-save matrix, especially for Gold options still marked TEST REQUIRED.

## Compatibility API

Cooperative mods can inspect `mod.exports.nuzlocke_compat` (v22). Important surfaces include:

- `getNextLevelCapInfo(save)`
- `canCapture(game, battle, species)`
- `getSpeciesBST(game, species)`
- `getGlitchSpeciesInfo(game, species)`
- `projectEncounterArea(...)`
- `getEncounterSplitModes()`
- `getCompatibilityReport()`
- `getModRelationship(modId, capability)`

The compatibility registry uses behavioral capabilities and explicit `compose`, `delegate`, `exclusive`, `observe`, or `incompatible` relationships. It does not match other mods by name.

## Release status

This is a **beta release candidate**, not a claim that every combination has been manually played through on every supported version. Before publishing a stable tag, run the disposable-save manual checks in [TESTING.md](TESTING.md), with particular attention to Gold death/Whiteout, scripted acquisitions, item-use vetoes, shops, Game Corner transactions, and the complete Johto → League → Kanto → Red cap ladder.
