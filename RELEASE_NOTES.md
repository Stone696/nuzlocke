# Nuzlocke 2.3.12 — final 2.3 release

Direct child of **2.3.11 RC**. This is a release promotion of the runtime-tested 2.3.11 code path; no gameplay feature, rule, save schema, compatibility API, or initialization behavior is intentionally changed.

## Runtime validation carried into release

Confirmed on **Gen1Recomp 0.1.98** during the 2.3.7–2.3.11 boot-repair sequence:

- Yellow reaches the title screen.
- Yellow fresh NEW GAME shows the normal Nuzlocke SETUP menu.
- Yellow SETUP proceeds successfully into NEW GAME.
- Yellow existing SAVE GAME loads successfully and does not incorrectly expose fresh-game SETUP.
- Gold NEW GAME boots successfully.

## Boot regression resolution

The 2.3.x Yellow pre-title freeze was isolated through staged startup probes. The final restored runtime keeps the full 2.3.0 feature surface while avoiding the unsafe eager startup pattern: the first heavy runtime phase activates at `game.ready`, optional Modern UI/Pokégear adapters do not perform eager first-pass installation, Stats/Growth remain lazy, and the legacy title fallback remains dormant on current public title-hook engines.

The later Gold trainer-battle Ball-policy scoping fix is retained.

## Release contract

- Version: **2.3.12**
- Mod API: **2**
- Compatibility API: **27**
- Save schema: **4**
- Engine range: **Gen1Recomp >=0.1.86 <0.1.99**
- Games: **Red / Blue / Yellow / Gold (Gold remains beta)**
- Package tree: unchanged; no files added or removed.

# Nuzlocke 2.3.11 RC — restored full candidate with boot-safe initialization

Direct child of **2.3.9 RC**.

## 2.3.11 boot-safety change

2.3.10 restored the full RC feature surface but Yellow 0.1.98 froze before title. 2.3.11 keeps that feature surface and changes activation timing: the first large runtime phase now waits for `game.ready`, and optional presentation/provider adapters no longer perform eager first-pass installation during mod load.

Primary validation: Yellow 0.1.98 should reach the title screen, hide SETUP when CONTINUE exists, show the real SETUP on a fresh game, and enter gameplay successfully.


## Why this build exists

Yellow proved three startup boundaries independently:

- **2.3.7:** inert package/manifest/loader → PASS to title.
- **2.3.8:** normal returned initializer + static metadata → PASS to title.
- **2.3.9:** public title hook + custom UI screen → PASS to title.

2.3.11 now restores the original 2.3.0 RC feature surface in one candidate while keeping unnecessary engine modules and monkey-patch installers out of the pre-title path.

## Restored

All rules, setup/profile handling, Nuzlocke screens, encounter/death tracking, world-building, randomizer/QoL features, compatibility/provider APIs, R/B/Y enforcement, Gold beta adapters, **Skip Opening Intro**, and **Quick Nuzlocke Start** from the 2.3.0 RC are active again.

## Boot-safety changes

`Stats` and `Growth` are lazy-loaded; the legacy internal title fallback is dormant; low-level gameplay adapters wait for normal lifecycle points; Default Names installs on NEW GAME selection; Gold title dispatch probing occurs only for Gold. The later Gold trainer-battle Ball-policy scoping correction is also retained.

## First runtime test

Use **Yellow + Gen1Recomp 0.1.98 + only Nuzlocke 2.3.11**.

1. Confirm title boot.
2. Existing save: confirm **SETUP is absent**.
3. No save: confirm **SETUP appears before NEW GAME**.
4. Open SETUP and confirm the **full real setup menu** is present and navigable.
5. Start NEW GAME and confirm the opening proceeds without a pre-title/startup crash.

If all five pass, 2.3.11 becomes the full-feature base for targeted rule regression testing.

# Nuzlocke 2.3.9 RC — Yellow public title/setup UI diagnostic

Direct child of **2.3.8 RC**.

**DO NOT USE 2.3.9 FOR A NUZLOCKE PLAYTHROUGH.** Gameplay rules remain intentionally inactive.

## Confirmed result from 2.3.8

**Yellow + Gen1Recomp 0.1.98 + Nuzlocke 2.3.8 only → PASS to title.**

The absence of Nuzlocke's setup menu in 2.3.8 was expected: that build restored only the initializer shell and static exports.

## What 2.3.9 restores

Only the minimum public setup/UI slice from the 2.3.6 behavior:

- `require("src.core.Strings")`
- one minimal custom `NuzlockeConfigScreen`
- `mod.ui.push`/screen pop behavior
- the public `ui.title_menu.items` hook
- fresh-game SETUP insertion before NEW GAME when CONTINUE is absent

It deliberately withholds `title_setup_compat.lua`, setup-profile persistence, save/storage access, gameplay events, battle/encounter/item enforcement, randomizers, and all other integrations.

## Test

**Yellow + Gen1Recomp 0.1.98 + only Nuzlocke 2.3.9:**

1. Does Yellow reach the title screen?
2. On a fresh game, does **SETUP** appear before **NEW GAME**?
3. Does selecting SETUP open the diagnostic Nuzlocke Setup screen?
4. Can the cursor react to input and can B return to the title menu?

A PASS clears the public title-hook/custom-screen path and moves the bisect to setup-profile/save state or later compatibility/gameplay initialization.

# Nuzlocke 2.3.8 RC — Yellow initializer-boundary diagnostic

Direct child of **2.3.7 RC**.

**DO NOT USE 2.3.8 FOR A NUZLOCKE PLAYTHROUGH.** Gameplay rules remain intentionally inactive.

## Confirmed result from 2.3.7

**Yellow + Gen1Recomp 0.1.98 + Nuzlocke 2.3.7 only → PASS to title.**

This confirms that the unchanged 15-file package tree, manifest permissions/dependencies/game targets, and inert top-level Nuzlocke entry can load successfully on 0.1.98. The earlier crash therefore lies in executable runtime initialization removed by 2.3.7.

## What 2.3.8 restores

2.3.8 restores only the normal `return function(mod) ... end` entry initializer used by 2.3.6. Inside that initializer it performs plain static export-table assignments, including the existing native-vitamin metadata. It intentionally performs no:

- engine-module `require()` calls;
- event registration;
- save or storage access;
- engine monkey patches or gameplay hooks;
- content registry writes;
- title/New Game modifications;
- split integration loading.

## Immediate test

**Yellow + Gen1Recomp 0.1.98 + Nuzlocke 2.3.8 only → does the title screen appear?**

- **If YES:** returned-initializer execution and static exports are cleared. The next child can restore the first engine-module imports / non-installing definitions.
- **If NO:** the failure is isolated to the normal initializer-execution boundary or something about the loader invoking the returned entry function, before any engine-facing Nuzlocke initialization occurs.

# Nuzlocke 2.3.7 RC — Yellow boot-safe diagnostic

Direct child of **2.3.6 RC**.

**DO NOT USE 2.3.7 FOR A NUZLOCKE PLAYTHROUGH.** Gameplay rules are intentionally inactive in this diagnostic build.

Yellow 2.3.6 still crashed before the title screen on Gen1Recomp 0.1.98 with all other mods disabled. 2.3.7 therefore reduces executable initialization to the smallest possible Nuzlocke entry while preserving the same package tree, manifest permissions, optional dependencies, game targets, and 0.1.98 engine range.

`main.lua` in this build:
- performs no engine-internal `require()`;
- installs no monkey patches;
- registers no gameplay/content hooks;
- loads none of the four split integration files;
- registers no title/New Game modifications;
- exports only inert diagnostic metadata.

## What this test proves

Test only:

**Yellow + Gen1Recomp 0.1.98 + Nuzlocke 2.3.7 only → does the title screen appear?**

- **If YES:** manifest/package loading works; the crash is inside executable Nuzlocke runtime initialization. We can re-enable systems in large binary-search blocks.
- **If NO:** the fault is outside the normal Nuzlocke runtime body—most likely manifest/loader/package interaction—and we should focus exclusively there.

# Nuzlocke 2.3.6 RC — pre-2.3 behavior on Gen1Recomp 0.1.98

Direct child of **2.3.5 RC**.

Yellow 2.3.5 still crashed before title. 2.3.6 therefore restores the remaining directly-compared pre-2.3 installer definitions and lifecycle timing while keeping Gen1Recomp 0.1.98 allowed by the manifest.

This is a selective forward repair, not a wholesale old-branch restore. **Skip Opening Intro** and **Quick Nuzlocke Start** remain removed as requested.

2.3.6 also repairs an isolation mistake in 2.3.3-2.3.5: `ItemPolicy.install()` itself had accidentally been removed while its deferred callers remained.

## Immediate test

Yellow + Gen1Recomp 0.1.98 + only Nuzlocke 2.3.6 enabled:
**Does the title screen appear?**

If it still crashes before title, we have strong evidence that the pre-2.3 Nuzlocke codebase itself has a boot incompatibility with Gen1Recomp 0.1.98 rather than a regression caused by the new 2.3.x features.

# Nuzlocke 2.3.5 RC — Yellow 0.1.98 boot bisect

Direct child of **2.3.4 RC**.

Yellow 2.3.4 still crashed before the title screen with all other mods disabled. That definitively exonerates **Skip Opening Intro** and **Quick Nuzlocke Start** as the immediate cause; both remain removed.

2.3.5 is a diagnostic compatibility-minimum build. It keeps Gen1Recomp **0.1.98** allowed by the manifest, but temporarily removes the executable 2.3.x integrations added specifically for that update:

- public `mod.battle` snapshot probing/export;
- contextual field-action backstop;
- broad Gold 0.1.98 battle-item denial expansion;
- the 2.3.x-only Gen II healing-classifier additions;
- related public-feature compatibility metadata.

The safer 2.3.3 lifecycle deferrals remain in place so non-title engine-internal installers are not deliberately forced into pre-title execution.

### Immediate runtime test
Yellow + Gen1Recomp 0.1.98 + only Nuzlocke 2.3.5:
**Does the title screen appear?**

If it still crashes before title, the leading diagnosis becomes an inherited pre-2.3 Nuzlocke boot path that 2.2.21 never exercised on 0.1.98 because its old manifest range excluded that engine version.

# Nuzlocke 2.3.4 RC

Direct child of **2.3.3 RC**.

## Yellow boot-isolation rollback

The experimental startup shortcuts introduced in 2.2.20/2.2.21 are **removed from the active build and deferred for a later redesign**:

- **Skip Opening Intro** — removed.
- **Quick Nuzlocke Start / Start With Poké Balls** — removed.

This is a selective forward rollback only. 2.3.4 does **not** restore an older branch or discard unrelated 2.3.x compatibility work.

### Still retained

- **Default Names** remains available.
- **Skip Catch Demo** remains available.
- Gen1Recomp 0.1.98 compatibility changes remain.
- 2.3.2 Gold trainer-battle Ball-policy scoping remains.
- 2.3.3 boot-safety deferrals remain.

### Runtime status

Yellow on Gen1Recomp 0.1.98:
- 2.3.0: pre-title FAIL
- 2.3.1: pre-title FAIL
- 2.3.2: pre-title FAIL
- 2.3.3: pre-title FAIL
- 2.3.4: TEST REQUIRED

The first 2.3.4 test should be Yellow with all other mods disabled, verifying only that the title screen appears. If it still crashes pre-title, the intro/progression shortcuts are exonerated and the next pass should continue isolating 0.1.98 boot-time compatibility.

# Nuzlocke 2.3.3 RC

Direct child of **2.3.2 RC**. Yellow pre-title boot-safety isolation for Gen1Recomp 0.1.98.

- Records 2.3.0-2.3.2 Yellow pre-title crash as runtime FAIL.
- Stops invoking the legacy 0.1.86 TitleState fallback before title construction; current engines use the public title-menu hook.
- Defers non-title engine-internal patch installers until live runtime lifecycle events.
- Retains the 2.3.2 Gold trainer-ball fix and 0.1.98 compatibility work.
- Runtime validation required; static parsing is not a runtime PASS.

# Nuzlocke 2.3.2 RC

Direct child of **2.3.1 RC**.

## Gold trainer-battle Ball-policy hotfix

- Fixed Gold's 0.1.98 broad battle-item denial pass so it handles **non-Ball items only**.
- Ball/capture policy is now evaluated exclusively in the existing catchable-battle branch (`battle.wild` or explicit static encounter provenance).
- Throwing a Ball in an ordinary trainer battle therefore falls through to Gen1Recomp's native trainer-battle behavior instead of surfacing `No Catching` or another Nuzlocke capture-specific refusal.
- Ball detection uses the shared dynamic `ItemPolicy.isBall(...)` classifier rather than only `def.pocket == "BALL"`, preserving compatibility with merged/custom Ball records.
- Corrected compatibility metadata: `mod.world:availableFieldActions/useFieldAction` is not a directly composed wrapper. Nuzlocke observes the public facade while No Fishing is enforced transitively through the wrapped native execution seams.

- Clarified Wide Menus compatibility: the manifest dependency is intentional for passive classic-layout coexistence (`uiModLayout` / `keepClassicUi`), not a direct `mod.find()` integration or active 304px claim.

## Validation status

Source/static validation only. Runtime validation required for:
- Gold trainer battle + Ball with No Catching ON/OFF;
- Gold wild/static Ball throws with No Catching and catch restrictions;
- Gold healing/X/PP item bans;
- R/B/Y and Gold No Fishing through native and contextual-field-action paths;
- Yellow New Game regression from 2.3.1.

# Nuzlocke 2.3.1 RC

Direct child of **2.2.21 RC**. Compatibility and hardening release for **Gen1Recomp 0.1.98**.

## What changed

- Engine envelope widened from `>=0.1.86 <0.1.98` to **`>=0.1.86 <0.1.99`** after source-auditing 0.1.98.
- Added read-only `battle_classifier.snapshot()` interop over Gen1Recomp's new shared `mod.battle:snapshot()` facade. Enforcement behavior is unchanged by this API addition.
- Added public-engine feature diagnostics for battle snapshots/intents and contextual field actions.
- Hardened **No Fishing** beneath R/B/Y `OverworldController:useFishingRod` and Gold `World:useFieldItem`, preventing the new `mod.world:useFieldAction("fish")` path from bypassing the rule.
- Expanded Gold **No Field Heal** classification to `BERRY_JUICE`, `RAGECANDYBAR`, and `SACRED_ASH` based on 0.1.98's native Gen II item implementation.
- Gold battle-item policy now vetoes every authoritative Nuzlocke denial at `BattleState:useItem`, fixing fallthrough for **No Healing Items** and **No X Items** while preserving ball-specific capture legality checks.
- Updated Gold compatibility metadata for the native starter nickname path and 0.1.98 item coverage.
- Save schema remains 4; no files added or removed; no network permission/log endpoint added.

## Runtime validation required

Test 0.1.98 boot/new game/save load on R/B/Y and Gold; No Fishing from native Pack/Bag, registered item where applicable, and companion `mod.world` field actions; Gold Berry Juice/RageCandyBar/Sacred Ash under No Field Heal; Gold battle healing/X-item/PP/ball rules; starter nickname flow; Quick Start; Time Split; seeded randomizer; MOD COMPAT/NUZ STATUS surfaces.

# Nuzlocke 2.2.21 RC

Direct child of **2.2.20 RC**. Adds a setup-only **Quick Nuzlocke Start** for players who want a capture-ready Nuzlocke without replaying the mandatory pre-Poké-Ball opening.

## Quick Nuzlocke Start

**R/B/Y**
- Starts outside the Pallet house at the Route 1 side of town.
- Gives/records a level-5 starter, Pokédex progression, post-Pokédex Oak/Viridian state, and at least 5 Poké Balls in the Bag.
- Honors larger configured Start Balls values.
- Leaves the optional first Route 22 rival unbeaten and available.
- Does not consume Route 1 or any other optional encounter.
- Yellow activates the Pikachu-follower baseline when appropriate without fabricating a result for the skipped lab Rival battle.

**Gold**
- Preserves the required InitClock step and anchors the skipped Mom weekday choice to the host weekday.
- Reconciles mandatory Pokégear/Phone, Elm starter, Mr. Pokémon/Pokédex, first Cherrygrove Rival, police Rival naming, Mystery Egg return, Potion, and 5-Poké-Ball milestones.
- Starts at New Bark's Route 29 exit.
- Preserves Cherrygrove as the native whiteout destination until a later Pokémon Center updates it.
- Leaves Guide Gent/Map Card, Mom banking, Route 29 encounters, and the Route 29 catch tutorial unconsumed.

**Rule/compat behavior**
- Nickname Rule still requires the starter nickname; Quick Start opens only that naming screen when necessary.
- Nuzlocke's seeded Random Starter still chooses the concrete starter while a canonical starter acts only as the skipped story anchor.
- No Catching and all other challenge rules remain authoritative after the shortcut.
- An external Quick Start provider fully suppresses Nuzlocke's local transaction. External starter-randomizer composition without a Quick Start provider remains runtime TEST REQUIRED.

## Validation status

Source/static validation only. Required runtime coverage: Red/Blue/Yellow/Gold fresh runs; nickname ON/OFF; built-in Random Starter ON/OFF; configured R/B/Y Start Balls; Route 22 availability; Yellow follower behavior; Gold weekday/phone/Pokédex/scenes/whiteout target; Route 29 tutorial with Skip Catch Demo ON/OFF; save/reload immediately after Quick Start; external provider combinations.

---

# Nuzlocke 2.2.20 RC

Direct child of **2.2.19 RC**. Adds a NEW GAME-only **Skip Opening Intro** QoL toggle.

### Skip Opening Intro
- R/B/Y remove Oak's visible opening speech/movie and resolve the canonical player/Rival names without showing the naming menus, then continue through the engine's normal fresh-game handoff to the Pallet bedroom.
- Gold keeps the required `init_clock` intro step, resolves the canonical player name without the visible Oak sequence, then continues through the normal Johto fresh-game handoff. The later Rival naming event is preserved.
- The implementation wraps Gen1Recomp's composable `intro.oak_speech.build` hook and keeps only the required semantic steps. It does not teleport the player or synthesize story flags.
- Setup-only, defaults OFF, remains outside Permanent Rule Seal, and yields to an external intro-skip provider.

### Validation status
Source/static validation only. Runtime validation is required for Red, Blue, Yellow, and Gold fresh starts, especially Gold clock setup and interaction with translation/intro providers.

# Nuzlocke 2.2.19 RC

Direct child of **2.2.18 RC**. This candidate upgrades the built-in randomizer to deterministic, shareable seeds and adds structured starter/encounter modes without changing encounter rates, levels, map tables, save schema, or external-provider ownership.

### New randomizer controls
- **RNG Seed:** 8 digits; `00000000` = AUTO. The generated/entered seed is shown in NUZ RULES and run-status rule lists as `RNG ######## v1`.
- **Starter Style:** ANY / 3-STAGE / BASE / SIM BST.
- **Encounter Balance:** CHAOS / SIM BST / EVO / BALANCED.
- **Species Pool** and **Learnset Gen** continue to compose with these controls.

### Reproducibility contract
For fresh 2.2.19+ rolls, the same game/content registry, randomizer settings, seed, and RNG algorithm version produce the same semantic slot choices. STARTER, ENCOUNTERS, and LEARNSETS use independent streams, so enabling one does not reshuffle the others. Already-persisted rolls from older builds are preserved on upgrade and therefore may predate the seed contract.

**Runtime TEST REQUIRED:** fresh R/B/Y and Gold seeds, all starter styles, all encounter-balance modes, seed entry/regeneration, save/reload reproducibility, external randomizer delegation, Gen1/Gen2/BOTH species pools, and provider-added evolution/species metadata.

# Nuzlocke 2.2.18 RC

Direct child of **2.2.17 RC**. This candidate hardens cross-rule precedence after a source-derived interaction audit. Failed Encounters now share the same eligibility decision as capture policy, Gold Time Split no longer treats new water/fishing encounters as timed grass slots, Random Starter respects active species/BST restrictions, and delegated default-name/tutorial/starting-kit features no longer execute from stale local settings. Save schema remains 4.

**Runtime validation remains required.** Priority combinations are Shiny + Failed Encounter + absolute species bans, No Catching + Failed Encounter, Solo + Failed Encounter, Gold Time Split with grass/surf/fishing, Random Starter with Type/BST/Legendary restrictions, and delegated tutorial/PC starting-resource providers. Egg hatches versus run-wide species/type restrictions remain a policy decision rather than a destructive auto-fix.

# Nuzlocke 2.2.17 RC

Direct child of **2.2.16 RC**. This candidate adds explicit Difficulty-stacking warnings for active external trainer mods while preserving manual provider selection and save schema 4.

### Difficulty provider warnings
- Nuzlocke does **not** automatically switch to Stronger Trainers when that mod is installed/active.
- If **VANILLA** is selected while an external trainer mod is active, the selector warns that the external mod may still alter trainer battles.
- If **NUZ MEDIUM** or a built-in historical-inspired profile is selected while an external trainer mod is active, the selector shows **STACK WARNING** because both layers may affect the composed trainer party.
- If an external `[MOD]` provider is selected while another provider is also active, the selector shows **MULTI-MOD WARNING**.
- Selecting the active Stronger Trainers `[MOD]` entry suppresses the Stronger-Trainers stacking warning; disabling Stronger Trainers also removes it.
- Detection of known historical trainer providers now has a direct loaded-mod fallback via `mod.find`.

Runtime validation is still required with Stronger Trainers alone, Stronger Trainers + built-in Difficulty, and multiple external trainer providers.

# Nuzlocke 2.2.16 RC

Direct child of **2.2.15 RC**. This candidate adds an optional next-Gym-Leader roster-size restriction and translation-companion hardening without changing save schema 4.

### Gym Team Size
- New **BATTLE MECHANICS → Gym Team Size** toggle, default OFF.
- At the actual next Gym Leader battle, the player's non-Egg, non-dead active roster may not exceed that Leader's live composed party count. Fewer Pokémon are legal.
- Rejection happens before the Leader battle command runs; Nuzlocke does not auto-box or delete party members.
- Ordinary Gym Trainers are unaffected.
- The limit follows the merged/composed trainer party so compatible trainer-party providers can alter the count.
- HARDCORE and IRONMON presets enable the rule; NUZLOCKE and SOLO do not.

### Translation compatibility
- Reviewed/recognized **PT-BR 0.1.4** and **Finnish/Suomi 0.1.0** companions.
- Nuzlocke continues to use semantic action fields plus translated `Strings()` values for shops rather than language-specific literals.
- MOD COMPAT now reports translation companions and preserves a valid full localized label before compact English fallback.
- PT-BR's optional native Trainer Card and inventory-list layout overrides are diagnostic-only from Nuzlocke's side; runtime coexistence testing remains required.

**Runtime retest targets:** R/B/Y and Gold next-Leader battles with over-limit/exact/under-limit parties; ordinary Gym Trainers; Gold Kanto postgame Gyms; a trainer-party provider that changes roster size; PT-BR 0.1.4 with its Trainer Card and inventory-line-break options both ON/OFF; No Buying/No Selling; NUZ STATUS, NUZ INFO, MOD COMPAT, ENC TRACKER, and battle rejection messages.

# Nuzlocke 2.2.15 RC

Direct child of **2.2.14 RC**. This candidate hardens old-save upgrades without changing save schema 4 or challenge behavior. Save upgrades now have one owner and one order: numbered schema migrations, semantic one-off corrections, tracker/Pokémon-identity reconstruction, then encounter reprojection. The retired Route Split translation is no longer a side effect of projection, legacy Level Cap and Rule Lock reconciliation are named semantic steps, and every numbered schema destination has an explicit migrator so missing future steps fail visibly. Runtime diagnostics retain the exact failed phase/step.

**Runtime retest targets:** load a pre-schema/old Nuzlocke save, a schema-4 current save, a save carrying legacy `no_shopping`/boolean Dupes data, a legacy blanket Route Splits save, and a save with existing tracker/identity history; confirm idempotent repeated loads and unchanged encounter availability.

# Nuzlocke 2.2.12 RC

Direct child of **2.2.11 RC**. This candidate completes the native built-in Game Difficulty pipeline while preserving the live merged trainer party as the compatibility base.

- Built-in profiles now have separate ordinary/boss level scaling, deterministic type-compatible roster strengthening, stronger movesets drawn from live merged level-up/TM data, native trainer-AI tiers, profile-owned Stat EXP/DVs, and Gold held-item enrichment.
- Trainer-party composition is copied before transformation, fixing the 2.2.11 in-place scaling path so previews and repeat constructions cannot compound levels or alter shared trainer data.
- Rival species remain fixed so starter/story identity cannot be rewritten. Existing provider moves remain candidates, and existing Gold held items are never overwritten.
- Gen 1 uses the engine's native `LAYER_1`/`LAYER_2`/`LAYER_3` trainer-AI scoring. Gold augments a per-battle copy of TrainerClassAttributes AI flags; shared trainer registry data is not mutated.
- SHIN HARD*, SHIN-STYLE*, and POLISHED* suppress player badge battle boosts as a profile mechanic. Owned badges themselves are never removed.
- Gold trainer Stat EXP/DV recalculation now uses the split-special Gen 2 Mon path.
- Gold pre-battle `NEXT CAP` now applies the selected built-in boss multiplier even before the boss party has been observed.
- Trainer-stat ownership is exclusive: VANILLA permits the separate Trainer Stat EXP / Perfect Trainer IV controls; built-in Difficulty owns those dimensions itself; selected external Difficulty providers remain authoritative and are not transformed by Nuzlocke.
- Historical names marked `*` remain inspired/composed profiles, not byte-identical copies of ROM-hack trainer tables.
- Physical/Special Split remains a separate Battle Mechanics toggle and is never forced by a Difficulty profile.

**Runtime retest targets:** cycle every built-in profile in R/B/Y and Gold; inspect ordinary and boss teams, moves and levels; verify Gen 1 trainer move choice changes; verify Gold AI/held items; test SHIN/POLISHED badge suppression; cycle `NEXT CAP`; switch back to VANILLA mid-run; and test with an external Difficulty provider selected.

# Nuzlocke 2.2.11 RC

Direct child of **2.2.10 RC**. Difficulty audit build. It fixed built-in Trainer Stat EXP and perfect-DV settings that had previously been attached as metadata but not consumed during trainer construction, and removed inert `smart`/`strong`/`max` labels instead of claiming AI changes that were not yet implemented. External difficulty providers remained authoritative.

# Nuzlocke 2.2.10 RC

Direct child of 2.2.9 RC. This candidate adds two opt-in mechanics while keeping both defaults vanilla-compatible:

- **Species Pool — AUTO / GEN1 / GEN2 / BOTH.** Shared by Random Starter and Random Encounters. Gold can natively draw from all 251 Generation 1+2 species. R/B/Y can draw Gen 2 species only when the active merged content registry actually supplies complete compatible records/assets; unavailable species are never invented. Gold wild randomization now targets the native `gen2Encounters` table.
- **Phys/Spec Split — OFF / ON.** OFF preserves the Generation 1/2 type-based split. ON uses modern per-move physical/special identity. R/B/Y keeps its one Special stat; Gold keeps its native split Special Attack/Defense and additionally aligns Reflect/Light Screen and Counter/Mirror Coat with the selected move category.

The split is implemented through the shared battle-damage hook and does not mutate Gen1Recomp's global move/type registries. Existing external encounter-randomizer ownership also remains authoritative.

**Runtime retest targets:** fresh R/B/Y and Gold setup; Random Starter with each Species Pool; Random Encounters with GEN1/GEN2/BOTH including reload persistence; Gold grass/time/fishing encounter tables; representative category flips (Fire Punch, Hyper Beam, Shadow Ball, Crunch); Reflect/Light Screen; Counter/Mirror Coat; and switching Phys/Spec Split mid-run.

# Nuzlocke 2.2.9 RC

Hardening build directly from 2.2.8. Focus: compiler headroom, full-party-wipe safety, exhaustive Dungeon Lock-In state, canonical vitamin data, and Stat EXP semantics. No existing package files were removed and no new package files were added.

# Nuzlocke 2.2.8 RC

Direct child of 2.2.7 RC.

### Fixed
- Yellow bedroom SNES / similar vanilla text no longer gets routed through Nuzlocke's T3 paginator. Native Gen1 continuation semantics remain engine-owned.
- Nuzlocke-authored T3 dialogue continues to use the shared cleaned/paginated ownership path.
- NUZ STATUS `NEXT CAP` now previews Nuzlocke's currently selected built-in Difficulty profile instead of always reading the underlying vanilla trainer level.
- Changing Game Difficulty mid-run clears previously observed boss-level cache entries so an old composition cannot pin `NEXT CAP`.

Runtime retest targets: Yellow SNES text, several previously-good T3 NPC interactions, and NUZ STATUS cap while cycling Vanilla/Medium/historical built-in Difficulty profiles.

# Nuzlocke 2.2.7 RC

Direct child of 2.2.6 RC.

**Confirmed startup fix:** Gen1Recomp reported `function at line 16995 has more than 60 upvalues`. That function was Nuzlocke's monolithic `_lateRuntimeInit` closure.

2.2.7 splits the same late-runtime work into two sequential closures so neither reaches Lua 5.1's 60-upvalue ceiling. Common/RBY initialization runs first, followed by Gold/compatibility initialization. The tiny `hasHealthyParty` helper is duplicated locally in the Gold phase rather than creating another shared main-scope local/upvalue.

The Yellow Skip Catch Demo work, expanded NUZ INFO, T3 dialogue ownership changes, and native Pokémon Bois Club chairman walker are preserved. Fresh-game runtime confirmation is required.

# Nuzlocke 2.2.6 RC

Direct child of 2.2.5 RC.

This build fixes the confirmed Lua compiler/local-limit startup failure that prevented the mod from loading and therefore prevented New Game Nuzlocke Setup from appearing.

The remaining over-limit addition came from 2.2.3's `skipCatchTutorialRequested` helper. Its logic is preserved, but it now lives on the already-existing internal beta export table rather than as another long-lived local inside `return function(mod)`.

The 2.2.4 Pokémon Bois Club native-walker repair, Yellow Skip Catch Demo logic, and expanded NUZ INFO remain present. Fresh-game runtime confirmation is required.

# Nuzlocke 2.2.5 RC

Startup regression repair. Direct child of 2.2.4 RC.

2.2.4 added one extra long-lived local variable while implementing the native Pokémon Bois Club chairman walker. `main.lua` has previously been constrained by Lua 5.1's 200 active-local limit, making that additional local a likely compile/load regression that can prevent the mod's New Game Setup hook from appearing.

2.2.5 removes the extra file-scope renderer table and keeps ownership state directly on the chairman NPC. The native-walker tribute, safe restoration, Yellow Skip Catch Demo changes, and NUZ INFO expansion are otherwise preserved unchanged.

Runtime confirmation of New Game Setup is required.

# Nuzlocke 2.2.4 RC

Direct child of 2.2.3 RC. Fixes the previously dormant Tier-3 Pokémon Bois Club chairman tribute. The abandoned hand-painted in-memory Bryan renderer has been removed; T3 now uses a genuine native Gen1Recomp `SpriteRenderer`, preferring the same Gambler / Black Hair Boy sprite family as Bryan-at-Home and falling back to another native map sprite if necessary. The vanilla chairman renderer is restored below T3, with an ownership guard so another mod's later sprite replacement is not clobbered. No new asset or repository file was added. Yellow Skip Catch Demo and expanded NUZ INFO from 2.2.3 are inherited unchanged and remain runtime-test targets.

# Nuzlocke 2.2.3 RC

Direct child of the published 2.2.2 RC. This is a focused Yellow/NUZ INFO repair pass. Yellow's opening Professor Oak capture demonstration is now hardened against the exact current Gen1Recomp Pallet flow and uses one shared NEW GAME setting query across staged, mod-save, and legacy save state; the actual demo battle is omitted while Oak's existing post-demo callback still drives Whew, Come With Me, and the lab escort. R/B/Y NUZ INFO stays on the crash-safe native ListMenu but now exposes the complete enabled Catch/Stat/Move model, including shiny/death details, provenance, BST legality information, move accuracy, explicit PAGE OFF rows, and a full safe-mode reconstruction if the richer API model fails. Shared T3 dialogue ownership is intentionally unchanged. Runtime testing remains required.

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


## Gen 2 Randomizer+ compatibility

2.2.14 adds source-confirmed ownership detection for Gen 2 Randomizer+. If its
Random Wild Pokemon, Random Starters, or Random Learnset option is enabled,
Nuzlocke yields that randomization surface while retaining Nuzlocke challenge
policy and provenance. This is particularly important for Randomizer+ v2.6's
Wilds of Kanto support: Randomizer+ owns visible-spawn/battle synchronization;
Nuzlocke judges the Pokemon that actually enters battle and does not consume an
area merely because a visible overworld object exists.

## 2.3.1 RC hotfix
2.3.0 froze when starting a new Yellow game on Gen1Recomp 0.1.98. This child build removes eager compatibility/overworld initialization from the title and fresh-game path while retaining the 0.1.98 gameplay compatibility fixes. Yellow New Game is the first required runtime retest.
