# Nuzlocke developer guide — local setup and architecture

This repository is a **mod**, not the Gen1Recomp engine. Most work on Nuzlocke
belongs here. The engine lives in a separate repo, `Deluxe0111/gen1recomp`.
The mod is Lua; Gen1Recomp runs through LÖVE/LuaJIT. ROM assets are **not**
stored in either repo.

## Windows setup: Visual Studio Code (recommended)

**Visual Studio Code and full Visual Studio are different products.** For a
Lua/LÖVE mod, Visual Studio Code is far lighter and has better Lua editing
support. You can use full Visual Studio as a text editor, but there is no C# or
C++ project to build in the Nuzlocke mod repo.

1. Install **Git for Windows** from https://git-scm.com/downloads/win .
2. Install **Visual Studio Code** from https://code.visualstudio.com/ .
3. In VS Code, install the extension **Lua** by **sumneko** / **Lua Language
   Server** (search `Lua` in Extensions). Optional: GitLens.
4. Open a PowerShell or VS Code terminal (`Ctrl+``) and run:

   ```powershell
   mkdir C:\Dev -ErrorAction SilentlyContinue
   cd C:\Dev
   git clone https://github.com/Deluxe0111/nuzlocke.git
   cd nuzlocke
   git switch feature/gen3-foundation
   code .
   ```

   This opens the **development branch**, which is not yet merged into `main`.

5. To cross-reference the actual game engine and API, from `C:\Dev` run:

   ```powershell
   git clone --branch dev https://github.com/Deluxe0111/gen1recomp.git
   ```

6. For the game itself, use the installed Gen1Recomp launcher. You can import a
   ZIP of the mod from the launcher **MODS → Import**. For engine-from-source
   development, its `Play-Windows.bat` bootstraps Python/LÖVE and requires the
   user's legitimate ROM: see
   https://github.com/Deluxe0111/gen1recomp/blob/dev/docs/guides/running-from-source.md .

A productive VS Code workspace has the two folders side by side:
`C:\Dev\nuzlocke` (mod code) and `C:\Dev\gen1recomp` (engine source).

## Files to open first

| File | Job |
| --- | --- |
| `manifest.json` | Mod identity, targeted games, API compatibility, permissions and entry path. |
| `entry.lua` | Dispatch. Gen 1/2 runs legacy `main.lua`; Gen 3 runs `gen3_runtime.lua`. |
| `gen3_runtime.lua` | Our **current Gen 3 gameplay adapter**. Subscribes to encounters, catches, faints and battle end; delegates policy to the CORE rule registry. |
| `gen3_core_rules.lua` | Our **CORE rule contract**. Eight stable rule IDs, defaults, support status, configuration validation and pure catch/whiteout decisions. |
| `gen3_clauses.lua` | Gen 3 Dupes Clause, Shiny Clause allowances, Shiny Rate settings, Roamer Clause and the approved Egg/Forgiveness roadmap. |
| `gen3_shiny_rate.lua` | One-time wild/static shiny generation; honours a verified external shiny provider. |
| `gen3_archive.lua` | Complete Pokémon snapshots for new deaths and guarded Nuz Dev recovery. Ordinary Route Forgiveness Pokémon revival remains disabled. |
| `docs/GEN3_CLAUSES.md` | Clause modes, compatibility limitations and fourteen manual test cases. |
| `gen3_menu.lua` | Our **current Gen 3 UI**. Presents NUZ MENU, reads CORE rules from the registry and shows all remaining Gen 1/2 rules as planned features. |
| `gen3_dev.lua` | Developer-only save-local area editor and recovery utilities. All mutations require deliberate opt-in and are recorded in the test-run audit trail. |
| `gen3_display.lua` | ROM-backed display names for species and locations; old numeric-ID graveyard entries are resolved at viewing time. |
| `docs/GEN3_NUZ_DEV.md` | Developer-menu controls, constraints and the route re-arm testing workflow. |
| `docs/GEN3_CORE_SPEC.md` | Approved eight-rule behaviour, whiteout versus PC precedence, and phased implementation plan. |
| `tests/gen3_foundation_smoke.lua` | Mocked tests for Gen 3 gameplay and menu wiring. |
| `docs/GEN3_PORT.md` | Gen 3 feature scope, known gaps and manual in-game test plan. |
| `main.lua` | Large established Gen 1/2 composition root. Loads split modules and wires mature rule hooks/UI. **Do not start by editing this** for Gen 3. |
| `rule_catalog.lua` | The **161 rules across 21 categories** used as the feature roadmap for the new menu. |
| `classic_ui.lua` | Mature Gen 1/2 menus: Status, Graveyard, Encounter Tracker and supporting screens. |
| `nuzlocke_ui_system.lua` | Presentation/layout helpers used by the mature Nuzlocke UI. |

## Other mature Gen 1/2 modules

- `late_runtime.lua`: deferred rule enforcement, lifecycle and integration glue.
- `compatibility_runtime.lua`: capabilities, other-mod interoperability and ownership.
- `pokemon_identity.lua`: identity across catches, party and PC.
- `encounter_tracker.lua`: encounter provenance, areas and tracker logic.
- `species_policy.lua`: legendary, mythical and species eligibility rules.
- `evolution_policy.lua`: restrictions and checks around evolution.
- `battle_clauses.lua`: competitive/battle restrictions.
- `item_policy.lua`: item and healing restrictions.
- `randomizer_runtime.lua`: starter, encounter, item and other randomisers.
- `world_building.lua`: world-modification features.
- `forgiveness.lua`: optional challenge exceptions and recovery.
- `run_history.lua`: completed/failed run recordkeeping.
- `save_migration.lua`: migration/safety for older mod saves.
- `acquisition_catalog.lua`: locations/sources of non-standard acquisitions.
- `public_interop.lua`: public compatibility surface exported to other mods.
- `modern_ui_integration.lua`, `pokegear_integration.lua`,
  `title_setup_compat.lua`: targeted UI / edition integrations.
- `dev_diagnostics.lua`, `dev_report.lua`, `release_safety.lua`: diagnostics,
  validation and release checks.
- `trainer_rewards.lua`, `stadium_provenance.lua`: specialised gameplay systems.

## Runtime pipeline (Gen 3)

```text
Gen1Recomp loads manifest.json
   |
   +-- entry.lua -> GameVersion.generation()
           |
           +-- 1 or 2 -> main.lua (original full mod)
           |
           +-- 3 -> gen3_runtime.lua
                       |-- gen3_core_rules.lua: CORE policy/defaults/API
                       |-- mod.save: persistent gen3_classic_v1 bucket
                       |-- mod.events:on: game/battle notifications
                       |-- mod.hooks:wrap: catch.rate + start menu
                       |-- native Gen3 battle item guard: blocks revives
                       +-- gen3_menu.lua -> Game3 native stack (240x160)
```

The **event** API observes what happened. The **hook** API can alter an
operation by calling or skipping `next(...)`. `mod.save:get/set` persists
per-playthrough mod data. Never modify the Gen 3 battle's
`battle.playerParty` array mid-battle; its slot indices feed forced switches.
The faint event marks the death immediately, and the party is compacted only
after battle writeback.

### Trace a first catch

1. A wild fight fires `battle.started`. The Gen 3 runtime checks
   `state.enabled` and claims the current *native map ID* if not already used.
2. A Poké Ball triggers `catch.rate`. If the active wild battle is a **repeat**
   in that area, the hook returns `false, 0` instead of calling `next`.
3. `pokemon.caught` marks a successful eligible catch. A run/faint still
   consumes the area's first opportunity.
4. The state persists in `gen3_classic_v1.areas`.

### Trace a faint

1. The Gen 3 battle adapter emits `battle.fainted` for a player Pokémon.
2. Nuzlocke records its graveyard entry, marks the battle-copy Pokémon dead and
   blocks standard in-battle revival.
3. The Gen 3 battle finishes naturally, then `battle.ended` removes the dead
   member from `session.party`. A party wipe marks the run failed.

## Menu roadmap

The Generation 3 `NUZ MENU` is a native 240×160 interface rather than the Gen 1/2 menu runtime. It includes:

- **NUZ RULES** with working CORE/CLAUSES/LEVELS/PLAYSTYLES/RANDOMIZER/QOL categories, HARDCORE, GAME DIFFICULTY, RUN/PARTY and nine ADVANCED RULES categories.
- **ENC TRACKER** uses the effective [Area Splits](GEN3_AREA_SPLITS.md) policy and displays readable names.
- **RUN JOURNAL** consolidates former NUZ STATUS/ALMANAC/NUZ NOTICES into one live summary and saved event history.
- **GRAVEYARD** displays archived individuals and readable causes/locations, with shareable results after run finalisation.
- **MOD SUPPORT** is an active, read-only external provider diagnostic screen; it does not offer unsupported manual ownership switches.
- **END RUN** opens an irreversible confirmation and a native saved terminal results screen.
- **NUZ DEV** is hidden from production navigation; from the NUZ MENU, hold Select and tap A (default keyboard Tab+Enter). Read-only inspector, encounter edits and complete-archive restore are guarded and saved as dev-tainted test actions.

Rules that cannot operate in Gen 3 are not enabled just because their names exist in the older Gen 1/2 catalogue. The feature matrix in [GEN3_FEATURE_MATRIX.md](GEN3_FEATURE_MATRIX.md) records the current implementation and outstanding live-ROM certification.

## Testing and iteration

From the **Nuzlocke repository root**:

```powershell
# Lua 5.1 or LuaJIT installed on PATH:
lua tests/gen3_foundation_smoke.lua

# Review changes:
git status
git diff
```

Or use the **Gen 3 foundation smoke** workflow in GitHub Actions; it installs
Lua 5.1 and runs the mocked test. For the engine's compatibility scan, from
`C:\Dev\gen1recomp`:

```powershell
python tools/modkit.py gen3check C:\Dev\nuzlocke
```

After each menu/UI change, refresh the installed mod in the launcher and restart
the game. For permadeath changes, **use a separate disposable save**. The GitHub
tests prove API wiring in a mocked harness; **FireRed/LeafGreen/RSE gameplay
still needs manual testing**.

## Git workflow

Keep `main` stable and work on `feature/gen3-foundation`:

```powershell
git status
git add gen3_menu.lua gen3_runtime.lua tests/gen3_foundation_smoke.lua
git commit -m "feat(gen3): improve menu"
git push origin feature/gen3-foundation
```

PR: https://github.com/Deluxe0111/nuzlocke/pull/1

The mod is Lua data/scripts: **there is no Visual Studio Build button**.
The game launcher or LÖVE runs it; the automated smoke test exercises it
outside the game.
