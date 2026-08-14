# Nuzlocke 2.0 User Guide

This is the complete player guide for Nuzlocke `2.0.0-beta.29.2.7` on Pokémon Gen1Recomp.

The mod is focused first on **Red, Blue, and Yellow**. **Gold is supported as a beta target** with a deliberately smaller rule surface and additional TEST REQUIRED paths. Silver and Crystal are not currently declared targets.

## 1. Installing and updating

1. Fully close Gen1Recomp.
2. Install or replace the `nuzlocke` mod with the current package using Gen1Recomp's supported mod installation flow.
3. Relaunch Gen1Recomp.
4. Confirm the mod is enabled for the game you intend to play.
5. For a new run, configure **SETUP** before starting the game.

When updating an existing Nuzlocke save, keep a backup before testing a new beta. Save migrations are intended to be additive and idempotent, but Whiteout and other destructive mechanics can intentionally end a run.

### Save Editor users

The embedded Save Editor and normal gameplay create separate loader sessions. Nuzlocke avoids binding gameplay runtime patches to the Save Editor session.

After changing a save in Save Editor:

1. save the edit;
2. fully close Gen1Recomp;
3. reopen Gen1Recomp;
4. load gameplay normally;
5. only then test rule behavior.

This restart sequence is important. Yellow runtime testing confirmed No TMs and No Rare Candy after an edited-save full restart.

## 2. Starting a run

### Fresh save

Open **SETUP** before **NEW GAME**. Choose a preset or configure each rule manually. Setup applies to the next run and includes the supported new-game-only options.

### Existing save

Use **NUZ RULES** to inspect and, where allowed, change the active rules. Some settings are setup-only or may be locked by the current ruleset.

## 3. Controls

The current rule UI uses:

- **Up / Down** — move between entries.
- **A** — activate/change the selected supported rule.
- **Left / Right** — change supported boolean, numeric, or multi-state values.
- **B** — cancel/back where the screen permits it.

For current boolean/multi-state rules, Up/Down is navigation rather than value-changing input.

Collapsible category headers use Gen1Recomp's native theme-aware directional glyphs: the sideways cursor glyph indicates a collapsed section and the native more/down glyph indicates an expanded section.

## 4. Presets

| Preset | What it is for |
|---|---|
| **CUSTOM** | Configure every supported rule manually. |
| **NUZ** | Classic Nuzlocke-oriented starting point. |
| **HARD** | Adds Champion-level caps plus battle healing and X-item restrictions. If you also want SET battle style, use Gen1Recomp's native battle-style option. |
| **SOLO** | Adds Solo Only and Whiteout to the Nuzlocke foundation. |

Presets are starting configurations. The visible rules remain the authoritative state for the run.

### Setup and utility controls

| Control | Behavior |
|---|---|
| **Locke Type** | R/B/Y preset selector for CUSTOM, NUZ, HARD, and SOLO. Gold currently uses its reduced rule surface without this preset selector. |
| **Lock Rules** | Locks the visible Nuzlocke rules in place. The lock control itself remains usable so the owner can unlock the rules again. |
| **Save Setup** | Saves the next-new-game setup profile. R/B/Y and Gold profiles are stored separately so configuring one does not replace the other. |
| **Save Rules** | Saves the current active-save rule configuration. |
| **Recover Catches** | R/B/Y recovery flow for older-save Pokémon whose encounter location could not be recovered automatically. |
| **Money** | R/B/Y new-game starting money, 0–9999. Default is **3000**; an explicit **0000** is valid. |
| **Poke Balls** | R/B/Y new-game starting Poké Balls, placed in the room PC. |
| **Rare Candy** | R/B/Y new-game starting Rare Candies, placed in the room PC. |
| **Gym Guide Rare Candy** | R/B/Y Gym Guides keep their normal dialogue and can offer repeatable Rare Candy batches when enabled. This is separate from the starting Rare Candy setup value. |

## 5. Main Nuzlocke screens

### Nuzlocke Setup

The pre-run configuration screen for the next new save. Categories are collapsible and use the same underlying rule definitions as the active-save Rules screen.

### NUZ RULES

Shows the active save's rule configuration. If a rules lock applies, locked choices are presented without silently changing the run.

### ENC TRACKER

Tracks encounter-area state and history. Its LOG/MAP-style views are designed to answer questions such as:

- Have I encountered something here?
- Did I successfully catch the eligible encounter?
- Which encounter area does this location currently project to?
- What happened to earlier encounter attempts?

R/B/Y can optionally split Routes 1–25, Mt. Moon, and Safari Zone areas. The implementation retains physical-map provenance and reprojects the view when split settings change instead of discarding the canonical history.

### NUZ STATUS

Red, Blue, and Yellow expose Nuzlocke run status on the Nuzlocke side of the Trainer Card.

Gold keeps its native multi-page Trainer Card and uses a dedicated Start-menu Nuzlocke status surface instead.

### CATCH INFO

When enabled, supported owned Pokémon can expose stored Nuzlocke encounter/origin information. The information may include catch area, encounter source/type, provenance/recovery information, and death state where applicable.

## 6. Core rules

| Rule | Behavior |
|---|---|
| **Nuzlocke** | Master switch for Nuzlocke enforcement. |
| **Permadeath** | Fainted Pokémon are treated as dead and prevented from returning to normal use through supported paths. |
| **First Rival Mercy** | Forgives faint/Whiteout consequences only during the opening Rival battle. Hardcore disables this mercy behavior. |
| **One Per Area** | Only the first eligible capture opportunity per encounter area may be caught. |
| **Failed Encounters** | The eligible encounter can consume the area when it is defeated, flees, or is otherwise missed. |
| **Nickname Rule** | Requires supported new acquisitions to receive a non-empty nickname. |

### LOST versus DEATHS

The intended player-facing meaning is:

- **LOST** — an eligible encounter opportunity that was not caught, such as a fled or defeated encounter.
- **DEATH** — an owned Pokémon that fainted under Permadeath.

beta.29.2.0 separates these meanings. Failed encounter opportunities remain `FAILED` area states and are shown as **LOST ENC.**; new owned-Pokémon death history rows use `DEAD`. On load, older `LOST` history rows are migrated to `DEAD` only when death evidence is present. The legacy `nuzlocke_losses` counter is retained internally so older saves remain compatible.

## 7. Clauses

| Rule | Behavior |
|---|---|
| **Dupes Clause — OFF** | No duplicate exception. |
| **Dupes Clause — SPEC** | Exact-species duplicate handling. |
| **Dupes Clause — FAM** | Evolution-family duplicate handling. |
| **Shiny Clause** | Allows supported shiny captures to bypass applicable area/duplicate restrictions. |

## 8. Encounter-area splits — R/B/Y

### Common Route Splits

R/B/Y now offer three route splits independently instead of dividing every numbered route:

- **Route 2 Split** — North and South can count separately because Viridian Forest physically separates the two sections and normal progression reaches them at different stages.
- **Route 10 Split** — North and South can count separately because Rock Tunnel sits between the two route sections.
- **Route 20 Split** — West and East can count separately because Seafoam Islands divide the route into opposite-side sections during normal progression.

Each toggle defaults OFF. All other numbered routes remain one encounter area. Physical provenance is still retained internally so older CARDINAL-mode saves can be collapsed safely without deleting tracker history or granting new legal encounters.

### Mt Moon Splits

Optional separate encounter areas for Mt. Moon's major floors.

### Safari Splits

Optional separate encounter areas for Safari Zone Center, East, North, and West.

Gold does not expose these Kanto split selectors as an equivalent rule surface.

## 9. Starter rule

| Rule | Behavior |
|---|---|
| **Random Starter** | Randomizes the received starter while preserving the surrounding selected story-choice/ball path. It does not become a whole-game encounter or trainer randomizer. |

The selected randomized starter is persisted for the run so the same setup is not repeatedly rerolled by ordinary reload behavior.

## 10. Pokémon and acquisition rules

| Rule | Behavior |
|---|---|
| **Overworld** | Allows supported overworld catches to participate in encounter-area tracking. |
| **Town Catches** | Allows supported town/city catches to count as encounters. |
| **No Legendaries** | Blocks supported new legendary acquisitions. Existing owned Pokémon are retained. |
| **No Mythicals** | Blocks supported new mythical acquisitions. Existing owned Pokémon are retained. |
| **No Pseudos** | Blocks supported pseudo-legendary acquisitions. Existing owned Pokémon are retained. |
| **Player Stat EXP** | Sets starting Stat EXP for newly acquired player Pokémon. |
| **Wild Stat EXP** | Sets starting Stat EXP for newly generated wild Pokémon. |
| **Trainer Stat EXP** | Sets starting Stat EXP for newly generated trainer Pokémon. |
| **No Stat EXP Gain** | Prevents additional player Stat EXP gain while preserving ordinary EXP and levels. |
| **Perfect Player IVs** | Gives supported newly acquired player Pokémon perfect Gen 1/2 DVs. |
| **Perfect Wild IVs** | Gives supported newly generated wild Pokémon perfect Gen 1/2 DVs. |
| **Perfect Trainer IVs** | Gives supported newly generated trainer Pokémon perfect Gen 1/2 DVs. |
| **No Static** | Blocks capture of supported fixed/scripted wild encounters. |
| **No Gambling** | Blocks supported Game Corner wagering and prize redemption before the relevant transaction mutates state. |
| **Maximum BST** | Blocks new acquisitions above the selected Base Stat Total threshold. `000` disables the restriction. Unknown/incomplete stat schemas fail open rather than guessing. |
| **Allow Glitches** | Controls new acquisition of recognized glitch/unregistered species. Existing owned glitch Pokémon are preserved. |
| **Gift Pokemon** | Allows supported gifts and records acquisition area/provenance. |
| **In-Game Trades** | Allows supported NPC trades and records trade area/provenance. |
| **Wonderlocke WIP** | Reserved compatibility surface; not an active selectable mechanic in this candidate. |

### Stat EXP presets

Player, Wild, and Trainer starting Stat EXP are independently configurable at supported presets including 0%, 25%, 50%, 75%, 100%, and 200%.

These are creation/acquisition-time rules. Enabling them is not intended to rewrite every Pokémon already stored in an existing save.

### Perfect DV controls

Player, Wild, and Trainer perfect-DV rules are independent. They apply to supported Pokémon created/acquired under the rule rather than serving as a blanket existing-save editor.

## 11. Battle rules

| Rule | Behavior |
|---|---|
| **Level Cap Scope** | `NONE`, `GYMS`, `E4`, `CHAMP`, or `POSTGAME`. |
| **No Healing Items** | Blocks supported battle HP/status/revival medicine. |
| **No X Items** | Blocks supported non-healing battle stat items. |
| **No Escape** | Prevents normal supported wild-battle escape. |
| **Ball Use Ban** | Cumulative restriction tiers: `POKE`, `GREAT`, `ULTRA`, `STANDARD`, or `ALL`. |

### Ball Use Ban tiers

The tiers are cumulative. `STANDARD` refers to the standard Ball family through the normal tier, while `ALL` also covers supported specialty/custom Ball use. The rule is about Ball use, not merely inventory ownership.

## 12. Level caps

The cap system can use generation-specific progression and live merged trainer rosters. Enforcement and status surfaces share the authoritative next-cap calculation so the number shown to the player is intended to match the number enforced.

Supported external cap providers can also participate through the compatibility API when they expose the expected capability contract.

Older saves seed known defeated-boss progression from available story/badge state where supported.

## 13. Field-item rules

| Rule | Behavior |
|---|---|
| **No Repels** | Blocks supported Repel-family use. |
| **No Escape Rope** | Blocks supported Escape Rope use. |
| **No Field Heal** | Blocks supported field HP/status/revival medicine. |
| **No PP Items** | Blocks supported PP recovery and PP-boosting item use. |
| **No TMs** | Blocks TM use while leaving HMs available. |
| **No Rare Candy** | Blocks Rare Candy use. |

These rules restrict use on supported paths. They do not automatically delete the items from storage.

## 14. Challenge restrictions

| Rule | Behavior |
|---|---|
| **No Buying** | Prevents supported item-shop purchases. |
| **No Selling** | Prevents supported item-shop sales. |
| **No Center Heal** | Prevents supported Pokémon Center healing. |
| **No Mom Heal** | Prevents supported Mom healing. |
| **Whiteout** | Ends the run when the real post-battle party has no healthy Pokémon. |
| **Solo Only** | Restricts active-party use while preserving intended supported PC-swap behavior. |

### Whiteout warning

Whiteout is destructive. Use disposable test saves when validating it.

beta.28.20 specifically hardened Whiteout/Permadeath against trainer systems that temporarily narrow or reorder the player's party during battle and restore it during teardown. The rule should judge the restored real party rather than a temporary battle-only subset, but exact runtime combinations remain an active validation target.

## 15. World, quality-of-life, and UI options

| Rule | Behavior |
|---|---|
| **World Building** | Optional Kanto-focused flavor dialogue. Cosmetic. |
| **Default Names** | Skips supported new-game player/Rival naming screens using canonical defaults. |
| **Skip Catch Demo** | Gold-only setup option that skips the Route 29 catching demonstration while preserving progression. |
| **Catch Info** | Enables the supported owned-Pokémon Catch Info surface. |
| **Area Guide** | Enables the expanded Encounter Tracker area view. |
| **Running Shoes** | Hold B while normally walking to move faster. Bike, surf, scripted movement, and menus remain separate. |

## 16. Existing saves and migrations

Current save schema: **4**.

The mod is designed to preserve existing Pokémon and unrelated save fields conservatively. Rules that affect newly generated/acquired Pokémon should not rewrite existing Pokémon merely because the rule is loaded.

Stable Nuzlocke Pokémon identity/provenance is used where possible so evolution, save/load, and compatible object replacement do not turn one Pokémon into a different logical record.

A save written by a newer unsupported schema should not be silently downgraded.

## 17. Gold beta support

Gold has its own compatibility/adaptation path rather than pretending to be Red/Blue/Yellow internally.

Current Gold coverage includes the core Nuzlocke rules and selected acquisition, Stat EXP/DV, glitch/static/Game Corner, cap, escape/Ball, field-item, shop, Whiteout, tracker, running, naming, catching-demo, and starter-randomization controls.

Important differences:

- Gold preserves its native Trainer Card and exposes Nuzlocke status through the Start menu.
- Some field-item and generation-specific paths remain explicitly TEST REQUIRED.
- Gold support does not imply Silver or Crystal support.
- R/B/Y remains the first development and parity priority; Gold advances as evidence and compatibility support mature.

## 18. Compatibility with other mods

Nuzlocke uses capability relationships such as `compose`, `delegate`, `observe`, `exclusive`, and `incompatible` for supported shared seams. The detailed versioned compatibility list is in `COMPATIBILITY.md`.

A few practical expectations:

- A newer third-party version does not automatically inherit an older tested version's confidence.
- Runtime PASS on the exact combination is stronger than static inspection.
- Nuzlocke-owned custom screens are not yet automatically themed by every UI replacement.
- Systems that create unusual trainer parties, custom species metadata, custom Balls, or Pokémon identities should use the public compatibility surfaces when available.

## 19. Confidence percentages

`FEATURE_CONFIDENCE.md` records Red, Blue, Yellow, and Gold confidence by feature.

The percentages are **evidence-weighted confidence estimates**, not literal measured success rates. Evidence priority is roughly:

1. exact current runtime PASS;
2. repeated runtime coverage;
3. behavior-level automated test;
4. upstream modkit validation;
5. compile/load success;
6. structural/static inspection;
7. inference from a related game/path.

A known runtime failure overrides static success. A materially changed code path loses confidence until it is retested.

## 20. Known beta limitations

- **Current release blocker:** a reported R/B/Y Gym Leader case (Misty) left a Pokémon usable after it fainted even though Permadeath worked in an ordinary battle; the Pokémon could then be healed at a Pokémon Center. Treat Gym Leader/special-trainer post-battle Permadeath reconciliation as unverified until the current candidate is fixed and runtime-retested.
- beta.29.2.0 carries the beta.29.0.2 reviewed fixes for scripted gift history naming, Gold PC-routed gift tracking, and stale scripted-static provenance unchanged. Those paths remain runtime-test required until confirmed in game.
- Gold still has TEST REQUIRED rule paths.
- Nuzlocke-owned Setup/Rules/Tracker/NUZ STATUS/Catch Info screens are not yet fully composed/themed by every UI replacement.
- Authentic runtime screenshots are not yet bundled into this candidate.
- Gen1Recomp 0.1.83 is source-audited and allowed by this candidate, but the exact 0.1.83 gameplay runtime pass is still required before release approval.
- For an **unpublished local test build**, do not use the Mod Manager Update action: it installs the latest published repository release, which can replace a newer local candidate with an older public build. Current Gen1Recomp beta-tag comparison may also display a redundant `v2.0.0 available` notice.

## 21. Troubleshooting

### A rule appeared to stop working after Save Editor

Fully close Gen1Recomp, reopen it, load gameplay normally, and test again.

### Up/Down changes a setting instead of navigating

That is not the intended current behavior for supported boolean/multi-state selectors. Up/Down should navigate; use A or Left/Right to change the selected value.

### A UI replacement changes normal menus but not Nuzlocke screens

That is a known beta compatibility gap for several Nuzlocke-owned screens.

### I changed a Route/Mt. Moon/Safari split. Did I lose encounter history?

The current design records physical-map provenance and reprojects the live encounter-area view instead of deleting canonical records.

### I enabled a Stat EXP/DV rule and my existing Pokémon did not change

That is expected for creation/acquisition-time rules. They are not intended to rewrite all existing Pokémon in the save.

### Whiteout deleted my run during testing

Whiteout is intentionally destructive. Use disposable saves when testing that path.

## 22. Reporting a bug

Include as much of the following as possible:

- Nuzlocke version;
- Gen1Recomp version;
- Red, Blue, Yellow, or Gold;
- fresh save, existing save, or Save Editor-modified save;
- active preset and relevant rules;
- other enabled mods if compatibility might be involved;
- exact reproduction steps;
- expected behavior;
- actual behavior;
- whether fully restarting Gen1Recomp changes the result.

## 23. Where to find technical details

- **Full version history:** `../CHANGELOG.md`
- **Feature confidence:** `FEATURE_CONFIDENCE.md`
- **Versioned compatibility:** `COMPATIBILITY.md`
- **Developer API:** `API.md`

## Credits

- **bryanthaboi** — original Nuzlocke mod and project baseline.
- **Stone696** — updater of bryanthaboi's original Nuzlocke mod.
- Built for **Gen1Recomp** and its native mod platform.

Pokémon and related names are trademarks of Nintendo / Creatures Inc. / GAME FREAK inc. This fan-made mod contains no ROM.

## Lock-In rules

### Gym Lock-In

When enabled, entering a supported Gym commits the run to that Gym until its Leader is defeated. Ordinary exits are rejected before the destination transition runs. Already-cleared Gyms remain open, and unknown/unrecognized Gym maps fail open rather than risking a softlock. The rule is available in Setup and NUZ RULES.

### Dungeon Lock-In

Dungeon Lock-In deliberately targets known **multi-exit** dungeon families rather than every cave/interior. The exterior entrance used to enter is sealed behind the player; reaching a different legitimate exterior exit clears the lock. Escape Rope is also rejected while the lock is active. A save loaded inside a dungeon without reliable entry-side state fails open. This conservative design avoids turning dead-end locations into permanent traps.

Lock-In feedback follows the World Building tier when enabled. With World Building OFF, a plain rule-enforcement explanation is still shown.

