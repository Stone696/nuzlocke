## 2.0.0-beta.30.0.0.10

When another active mod explicitly owns a duplicate non-core mechanic, the Nuzlocke row stays visible but is greyed and effectively OFF. Your saved Nuzlocke preference is not erased. Applying a Nuzlocke loadout while a provider is active also updates that dormant preference, so disabling the provider later restores the loadout's intended setting rather than an older stale value. EXP Edging follows an externally owned level-cap system.

# Nuzlocke 2.0 User Guide

This is the complete player guide for Nuzlocke `2.0.0-beta.29.3.13` on Pokémon Gen1Recomp.

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

## 2.0.0-beta.29.3.13 behavior notes

- Turning the **Nuzlocke** master switch OFF now also disables Trainer Money scaling and Route Forgiveness rewards/spending. QoL, World Building, UI options, and independent Game Difficulty remain available.
- **Game Difficulty** remembers a stable profile/provider identity. If a selected external difficulty provider is temporarily unavailable, the run safely uses VANILLA rather than silently selecting whatever moved into the old list position; the requested provider is remembered so it can return when re-enabled.
- **Dungeon Lock-In** seals the exact entrance used. A different legitimate exit is allowed even when it leads back to the same outside map. Old/ambiguous lock state fails open instead of trapping the player.
- **No Catching** is an absolute capture ban and is no longer inferred from retired partial Ball-ban settings. If an older beta may already have converted a partial Ball ban into No Catching, 29.3.13 flags that ambiguity for review rather than guessing whether a current ON value was migration-created or intentionally selected later.
- Source-less external gift/trade notifications are classified conservatively using version-valid source data and the live/reported location; if no location exists, only species with a genuinely deterministic vanilla source are inferred.
- Gold now exposes **Gift Pokemon** and **In-Game Trades** on its beta rule surface. Native NPC trades are refused before the outgoing Pokemon or one-shot trade flag changes when another active rule makes the received Pokemon illegal.
- RANDOM Mono/Duo type selection chooses from types represented by the live merged species/provider pool when possible, so vanilla R/B/Y cannot randomly start an empty Dark/Steel Type Locke.

New restrictive rules keep neutral defaults: Type Locke, No Day Care, Gym Lock-In, Dungeon Lock-In, Route Forgiveness, and No Catching are OFF; Trainer Money is 100%; Game Difficulty is VANILLA.

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

### Gold-native Nuzlocke screens

Gold uses its own menu presentation rather than reusing the R/B/Y pixel-positioned screens. Since `2.0.0-beta.29.3.9`, Nuzlocke Setup/Nuz Rules, ENC TRACKER, CATCH INFO, Route Forgiveness prompts, and NUZ STATUS use Gold's native 20x18 tile-grid box/cursor vocabulary. The rule and encounter data are shared; only the generation-specific presentation differs. This presentation is **TEST REQUIRED** until runtime validated.

## 4. Presets

| Preset | What it is for |
|---|---|
| **CUSTOM** | Configure every supported rule manually. |
| **NUZ** | Classic Nuzlocke-oriented starting point. |
| **HARD** | Adds Champion-level caps plus battle healing and X-item restrictions. If you also want SET battle style, use Gen1Recomp's native battle-style option. |
| **SOLO** | Adds Solo Only and Whiteout to the Nuzlocke foundation. |
| **IRON / IronMON** | IronMON-style Nuzlocke loadout using only challenge rules owned by this mod. |

Presets are starting configurations. The visible rules remain the authoritative state for the run.

### Setup and utility controls

| Control | Behavior |
|---|---|
| **Nuzlocke Loadout** | Shared Nuzlocke Loadout selector for CUSTOM, NUZ, HARD, SOLO, and IRON/IronMON where exposed by the generation-specific rule surface. |
| **Permanent Rule Seal** | Irreversibly seals challenge rules on that save after confirmation. Game Difficulty, World Building, QoL, and presentation controls remain adjustable. |
| **Save Setup** | Saves the next-new-game setup profile. R/B/Y and Gold profiles are stored separately so configuring one does not replace the other. |
| **Save Rules** | Saves the current active-save rule configuration. |
| **Recover Catches** | R/B/Y recovery flow for older-save Pokémon whose encounter location could not be recovered automatically. |
| **Money** | R/B/Y new-game starting money, 0–9999. Default is **3000**; an explicit **0000** is valid. |
| **Poke Balls** | R/B/Y new-game starting Poké Balls, placed in the room PC. |
| **Rare Candy** | R/B/Y new-game starting Rare Candies, placed in the room PC. |
| **Gym Guide Rare Candy** | R/B/Y Gym Guides keep their normal dialogue and can offer repeatable Rare Candy batches when enabled. This is separate from the starting Rare Candy setup value. |

## Nuzlocke variants

### Type Locke — Monolocke / Duolocke

**Type Locke** has three modes:

- **OFF** — normal species eligibility.
- **MONO** — a Pokémon is legal when either of its types matches **Type 1**.
- **DUO** — a Pokémon is legal when either of its types matches **Type 1** or **Type 2**.

Type 1 and Type 2 use the shared Gen 1+2 type list. Dark and Steel can be selected in R/B/Y for content mods that supply those types. While DUO is active the two selections are kept distinct.

An off-type wild encounter cannot be caught and does **not** consume One Per Area, Failed Encounters, or a Route Forgiveness Token. Shiny Clause does not bypass Type Locke. Native gifts and trades are also checked where the engine exposes a safe pre-transaction gate.

If Random Starter is ON, its candidate pool is filtered toward the active Type Locke. The mandatory story starter is never blocked when no legal starter is available, preventing a new run from becoming impossible before encounters open. Existing Pokémon are never deleted when Type Locke is enabled mid-run.

### No Day Care

When **No Day Care** is ON, new Day Care deposits are refused. If a Pokémon was already deposited before the rule was enabled, you may still retrieve it. Gold also preserves existing parents, breeding progress, and any pending Egg state.

Both Type Locke and No Day Care are challenge rules and are therefore frozen by Permanent Rule Seal.

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
| **World Building** | Cosmetic OFF/T1/T2/T3 rule feedback for Kanto and Johto. T1 is clear, T2 adds challenge personality, and T3 adds region/NPC-aware flavor. At T3, Vermilion's Fan Club is also cosmetically presented as the **Pokemon Bois Club** with a Bryan-the-Boi tribute chairman sprite. It remains changeable after Permanent Rule Seal. |
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



## Route Forgiveness and Trainer Money (29.3.3)

Route Forgiveness has three setup values: OFF, 0, and 1. OFF disables the system. 0 enables it with no starting tokens; 1 enables it with one. Defeating a non-Leader Gym Trainer awards one token once. When an otherwise eligible failed encounter would consume an area, an available token is spent first and the area remains open. Duplicate encounters rejected by Dupes Clause never consume a token.

Trainer Money scales the final trainer payout at 0%, 25%, 50%, 75%, 100%, 150%, 200%, 300%, or 500%. 100% is vanilla/default.

Permanent Rule Seal is irreversible after its confirmation step. It freezes **challenge-rule configuration**, not runtime state. It does not freeze **Game Difficulty, World Building, QoL, or presentation controls**.

## 29.3.15
LEVELS now contains Game Difficulty, Level Cap Scope, and EXP Edging. BATTLE ITEMS contains only battle item-use bans. No Catching is the semantic full capture ban; the retired Ball tier is migration-only. Gold can optionally skip the Guide Gent's Cherrygrove walking tour while retaining the native MAP CARD reward and cleanup. Stat EXP 0% is the native default; 100% means 32768 and 200% means 65535 on the challenge preset scale.

## 29.3.16 NUZ INFO
The party submenu exposes NUZ INFO when at least one of Catch Page, Stat Page, or Move Page is enabled. A/Right advances to the next enabled page, Left goes backward, and B closes. Catch shows provenance; Stat shows current stats/DVs/raw Stat EXP; Move shows type/power/accuracy/current-max PP from the active merged move data. All three presentation toggles remain adjustable after Permanent Rule Seal.

## Randomizer expansion — beta.30.0.0.1
- **Random Starter** randomizes only the starter.
- **Random Encounters** replaces species in wild table slots while preserving level/rate/map/time/method structure.
- **Random Learnsets** replaces starting and level-up move identities while preserving learn levels and entry counts.
- **Learnset Gen**: AUTO = merged move registry; GEN1 = indices 1-165; GEN2 = 166-251. Missing source data safely leaves learnsets unchanged.

Existing Pokemon keep moves already learned. New paths are TEST REQUIRED.

## 2.0.0-beta.30.0.0.2
## No Fishing
Enable **No Fishing** under **FIELD ITEMS** to block fishing-rod use. Rods can still be owned; Surf and other encounter methods are unaffected.

## 2.0.0-beta.30.0.0.3
## Mod-stack compatibility
No new player setup is required for the interoperability API. Compatible mods can ask Nuzlocke whether an item/acquisition is legal and can consume the effective randomized registries. FAFF0x collection certification is being built on these generic seams.

## 2.0.0-beta.30.0.0.4
## Compatibility note — 30.0.0.4
No new player-facing setup is required. This build improves how compatible alternate Bag, PC, encounter, EXP, Pokédex and move-management mods can ask Nuzlocke for the effective rules/data instead of bypassing enforcement.

## 2.0.0-beta.30.0.0.5
## Encounter Tracker recovery repair
`REMOVE ENTRY` on a recovered/legacy tracker row now safely returns the record to the unassigned legacy list without persisting UI-only Pokémon references. Existing saves that passed through the older recovery UI are sanitized when this path saves again.

## 2.0.0-beta.30.0.0.6
## Mod-added quest content
Compatible quest/content mods can now tell Nuzlocke about new catch areas, dungeons, gifts and scripted encounters. Player-facing rules continue to work normally; story-critical encounters can be marked non-randomizable by the content provider.

## 2.0.0-beta.30.0.0.7
## Existing FAFF0x releases
No setup is required for the automatic compatibility bridge. When compatible older mods are active, Nuzlocke can recognize common alternate Bag, PC, encounter, EXP, quest and registry-consumer behavior families. Runtime certification will be performed later.

## 2.0.0-beta.30.0.0.8
## Compatibility consolidation
No player-facing settings changed in 30.0.0.8. This build hardens how Nuzlocke composes with alternate Bags, storage systems, encounter providers, EXP providers, registry consumers, and quest/content mods.

## 2.0.0-beta.30.0.0.9
## Greyed external-provider rules
If a non-core setting is greyed and says OFF, highlight it to read the help panel. The panel names the active mod/provider handling that feature. You cannot toggle the duplicate Nuzlocke control until that provider is disabled or removed. Your previous Nuzlocke choice is preserved and returns automatically afterward.

## 2.0.0-beta.30.0.0.11
## 0.1.84 compatibility build
This build is intended to restore loading on Gen1Recomp 0.1.84 with the smallest possible change. All existing Nuzlocke settings and feature work are retained; runtime validation remains pending.

## 2.0.0-beta.30.0.0.12
## Future engine updates
Routine Gen1Recomp 0.x updates should no longer make Nuzlocke disappear or refuse to load merely because the engine version increased. If a future engine actually changes a hook or runtime contract, affected features may still require a compatibility repair; 1.0 and later remain intentionally blocked pending review.

## 2.0.0-beta.30.0.0.13
## Fresh-game SETUP on current Gen1Recomp
On a game version with no existing save, the title menu should expose SETUP before NEW GAME. If a valid save exists and CONTINUE is present, SETUP intentionally remains hidden; use in-game Nuzlocke Rules for an existing run.

## 2.0.0-beta.30.0.0.14
## 30.0.0.14
This build is a parser hotfix for 30.0.0.13. Expected user-facing SETUP behavior is unchanged.

## 2.0.0-beta.30.0.0.15
## 30.0.0.15 test build
The title compatibility code is now loaded as a separate internal Lua module. User-facing behavior should remain the same: fresh games expose SETUP; existing saves do not. Until runtime validation is complete, treat this build as TEST REQUIRED.

## 2.0.0-beta.30.0.0.16
## 30.0.0.16 test build
Internal code is now split across `main.lua`, `title_setup_compat.lua`, and `trainer_rewards.lua`. Expected player behavior is unchanged, but title SETUP, Trainer Money, Forgiveness Tokens, and progression/cap reporting require runtime confirmation before this build is considered stable.

The build now passes static Lua parsing, but runtime confirmation is still required before treating the new module/scoping structure as stable.

## 2.0.0-beta.30.0.0.17
## Permanent Rule Seal confirmation
Permanent Rule Seal is intentionally irreversible after commitment. To prevent accidental activation, it now requires three deliberate activations: the first displays WARNING 1/2, the second displays FINAL WARNING 2/2, and the third permanently seals challenge-rule configuration. Move away from the option or press B before the final activation to cancel.

## 2.0.0-beta.30.0.0.18
## Permanent Rule Seal persistence
After the final seal confirmation, the challenge-rule lock is intended to survive immediately even if you quit before making another normal Pokémon SAVE. Nuzlocke stores the irreversible seal marker in playthrough-scoped durable storage while normal configurable rules continue to use the game's ordinary save flow. QoL, World Building, and UI/presentation settings remain editable after sealing.

## 2.0.0-beta.30.0.0.19
## Permanent Rule Seal — temporarily unavailable
Permanent Rule Seal is currently a WIP placeholder. It appears grey in Setup/Nuz Rules and cannot be selected or activated. Older development-test seals are not enforced while the feature is disabled, so normal challenge rules remain editable. The underlying implementation is being retained for possible reintroduction after further persistence/runtime validation.

## 2.0.0-beta.30.0.0.20
## Dialogue compatibility
Nuzlocke World Building flavor text is presentation-only. If the game is already showing dialogue, optional Nuzlocke flavor now waits by simply not opening another box, rather than interrupting the active dialogue. This is intended to prevent repeated/overlapping page text.

## 2.0.0-beta.30.0.0.21
## Percentage rules and Maximum BST
Percentage-based rules display their percentage value, including Trainer Money and Player/Wild/Trainer Stat EXP.

Maximum BST is now a preset control:
- OFF — no BST restriction
- 400
- 450
- 500
- 550

Use A or Left/Right to cycle the preset. Direct three-digit editing is no longer used. Older development saves with a custom Maximum BST remain at that exact value until you change the option; the row shows CUSTOM until it is moved onto the preset ladder.

## 2.0.0-beta.30.1.0 notes

Permanent Rule Seal is currently unavailable and appears as a grey WIP option.

Maximum BST uses five choices: **OFF, 400, 450, 500, 550**.

Percentage-based controls display their percentage values, including Trainer Money and starting Stat EXP presets.

World Building dialogue is optional. When another textbox is already active, Nuzlocke suppresses its optional flavor text instead of stacking a second textbox on top. This protects story/NPC dialogue from repeated or overlapping page text.

Yellow runtime testing has confirmed the tested Gym Lock-In boundary rejection and successful non-reproduction of the previously demonstrated Poké Mart dialogue duplication case.

## Gold Setup status — 30.1.1

Gold Nuzlocke Setup remains intended to appear for a fresh NEW GAME. This candidate removes a newer compatibility fallback that caused a runtime crash when selecting Setup. The older Gold title integration remains active.

Gold NEW GAME -> SETUP should be treated as TEST REQUIRED until the corrected path is runtime confirmed.

## 2.0.0-beta.30.1.2 — Gold warning

Gold support is experimental.

**Known bug:** on a fresh Gold NEW GAME, selecting the Nuzlocke SETUP entry currently crashes in the tested Gen1Recomp environment. Do not rely on the Gold fresh-game Setup screen in this release.

This known issue does not change the documented R/B/Y rule usage. Permanent Rule Seal remains unavailable/WIP.

## Setup diagnostic — 30.1.3

If SETUP or Nuz Rules cannot open, the game should now show `NUZLOCKE SETUP ERROR` rather than closing. Please capture the exact text shown so the failing subsystem can be repaired directly.

## Setup diagnostic — 30.1.4

If SETUP or Nuz Rules fails, look for `NUZ SETUP UPDATE ERROR` or `NUZ SETUP DRAW ERROR`. Please capture the full message shown.

## Setup profile persistence — 30.1.5

Fresh-game Setup keeps its profile selections during the current application session. Fully closing and reopening Gen1Recomp resets the Setup-profile preference layer to defaults in this diagnostic build.

Rules committed to an actual save continue using their normal save-backed persistence.

## 2.0.0-beta.30.1.6 — Setup compatibility

Fresh-game Nuzlocke Setup has been runtime validated on the current tested engine path for Gold and Yellow, and Blue fresh NEW GAME has been confirmed to proceed into the player's bedroom.

### Setup-profile persistence note

Your pre-game Setup selections are retained during the current Gen1Recomp session. If you completely close and reopen Gen1Recomp before starting the run, the Setup preference layer returns to defaults.

Once rules are committed to an actual game save, normal save-backed Nuzlocke persistence applies.
