# Nuzlocke 2.4.0 compatibility summary

2.4.0 consolidates the compatibility work performed after the 2.3.12 public release.

## Compatibility policy

Documentation distinguishes:
- **source-reviewed**: current source/package inspected;
- **release-reviewed**: release behavior/notes reviewed but source identity or package could not be fully validated;
- **runtime PASS**: actually confirmed during play;
- **historical evidence**: older package/integration evidence retained without claiming a current upstream.

Historical provider IDs are never treated as proof that a mod is installed. A real loaded provider must resolve before it can enter the live Difficulty/provider stack.

## Major generalized compatibility improvements

- trainer captures are a first-class acquisition kind;
- custom Ball detection uses semantics rather than fixed hardcoded IDs;
- learnset ownership is provider-agnostic;
- area-less compatible battles still pass through capture legality;
- storage legality follows the final incoming/outgoing transaction, including SWAP;
- encounter-information tools can request the final composed registry and honor OPEN/BLIND reveal policy;
- translation tools can enumerate Nuzlocke-owned semantic source strings;
- presentation mods can query screen ownership/role/fallback metadata;
- Dungeon Lock-In reconciles against the actual entered map after compatible teleports/map changes;
- built-in Difficulty previews use the same composed party transform as real trainer battles;
- external trainer providers remain on generic public hook composition.

## Reviewed compatibility set during this release line

Current/recent review work covered:
- Pokémon Snag 0.15.9
- Too Many Balls 0.6.1
- Translation Generator 0.7.0
- Shiny Pokémon 1.0.1
- Weather FX 2.6.0
- Gen 3 Inspired UI Overhaul canonical 2.0.0
- Advanced Box System 1.1.0
- Pokédex Plus 1.3.4

Historical/unresolved source identity is still documented for:
- IronMON Ultimate (historical 0.4.20 package evidence)
- Enemy HP (historical compatible test archive)

Do not treat a source/release review as runtime PASS unless explicitly marked.

---

## 2.3.35 RC — MOVE INFO presentation

No compatibility ownership changes.

MOVE INFO now uses one horizontal text lane per line instead of paired left/right stat columns. This is intentionally presentation-only and remains compatible with provider-supplied move names/types/stats because long lines use the existing marquee-safe renderer.

## 2.3.34 RC — MOD COMPAT detail paging

The R/B/Y MOD COMPAT screen keeps Gen1Recomp's host ListMenu as state/input owner. Long plain-language ownership descriptions are wrapped in full and displayed three lines at a time.

`select` advances the detail page; on default desktop bindings this corresponds to Tab. Changing the highlighted compatibility row resets the explanation to page 1.

Yellow 2.3.32 runtime confirms the native-size MOD COMPAT and ENC TRACKER presentations no longer show the previous shrunken-surface regression.

## 2.3.33 RC — Difficulty cap projection ownership

Nuzlocke-owned built-in Difficulty profiles now project boss levels directly with the same immutable-copy `Difficulty.composeParty()` transformation used by real trainer battles. This avoids a stale vanilla NUZ STATUS cap after an in-game profile change.

External trainer/difficulty providers are still previewed through Gen1Recomp's generic `trainer.party` composition seam. Nuzlocke does not call or assume an external provider's private implementation.

Runtime retest required in Yellow:
- VANILLA -> NUZ MEDIUM should update NEXT CAP immediately.
- NUZ MEDIUM -> YELLOW LEGACY* / SHIN-STYLE* should update again when the rounded live ace differs.
- returning to VANILLA should restore the live vanilla/provider cap.
- starting the battle should match the cap projection.

# Current Compatibility Ledger — 2.3.23 RC

This table is the canonical compatibility ledger for the current build. Older review notes remain below for historical detail, but the rows here are the current source of truth.

| Mod | Current reviewed version/status | Gen 1 | Gold | Confidence / notes |
|---|---:|---:|---:|---|
| **Pokemon Snag** (`mistermiracle3036/Pokemon-Snag`) | **0.15.9 source-reviewed** | Expected compatible | Expected compatible | Trainer-Pokemon capture and persistent snag provenance reviewed. Nuzlocke supports `trainer_capture` acquisition/provenance. Runtime combination test still required. |
| **Too Many Balls** (`mistermiracle3036/Too-Many-Balls`) | **0.6.1 source-reviewed** | Expected compatible | Expected compatible | Current mod publishes custom-Ball ownership and keeps purchase-event semantics. Nuzlocke uses semantic Ball detection in the public Item API. Runtime combination test still required. |
| **Gen1Recomp Translation Mod Generator** | **0.7.0 source-reviewed** | Expected compatible | Expected compatible | Gold translation pipeline reviewed. Nuzlocke exposes enumerable translation sources/catalog and UTF-8-safe presentation paths. Runtime combination test still required. |
| **Shiny Pokemon** | **1.0.1 source-reviewed** | Expected compatible | Expected compatible where supported | Current lifecycle/cache architecture reviewed. No ownership conflict found; Nuzlocke tracker presentation work is now snapshot-based. Runtime combination test still required. |
| **Weather FX** (`MrKrisSatan/Weather-fx`) | **2.6.0 release-reviewed** | Expected compatible | Unknown / not claimed | Release fixes stale indoor/outdoor state. Nuzlocke adopted generalized transient-map-state reconciliation. Tagged source packaging is irregular, so this remains release-reviewed rather than full source-reviewed. |
| **Gen 3 Inspired UI Overhaul** (`HighDrexler/Gen-3-inspired-UI-overhaul-for-Gen1Recomp`) | **2.0.0 source-reviewed** | Expected compatible | Expected compatible | Canonical parent reviewed. Presentation-only ownership model aligns with Nuzlocke's new `nuzlocke_ui` API 1. Linked `absol89` fork is older at 1.4.1. Runtime combination test still required. |
| **IronMON Ultimate** | **historical 0.4.20 package only; upstream resolution attempted 2026-08-16** | Historical compatibility evidence only | Unverified | GitHub repository search, public web search, and project File Library search did not identify a trustworthy canonical Gen1Recomp upstream. Historical evaluation covered shared trainer/item/rule surfaces. The separately maintained IronMON Ultimate community challenge rules are not treated as the mod upstream. |
| **Enemy HP** | **historical test archive only; upstream resolution attempted 2026-08-16** | Historical runtime evidence only | Unverified | GitHub repository search, public web search, and project File Library search did not identify the exact current Gen1Recomp mod/repository. Surviving records say the uploaded build appeared runtime-compatible, but archive version and tested game were not preserved. |

## Compatibility ledger policy

- A row marked **source-reviewed** means the named version's current source was inspected.
- A row marked **release-reviewed** means release metadata/packaging was reviewed, but complete current source was not reliably available from the tagged repository.
- **Expected compatible** is not a runtime PASS.
- Runtime PASS claims require an actual tested combination and should name the game/version tested.
- Historical package evidence never automatically transfers to a newer release.
- When a repository/fork changes canonical ownership, the ledger records the canonical upstream and keeps fork-specific notes separately.
- New compatibility lessons should be generalized into provider/ownership/state contracts where possible instead of hardcoded mod-ID behavior.

## 2.3.32 RC — Yellow Gym Team Size pre-battle fix

### Runtime evidence

Yellow runtime test on 2.3.30:

- **Gym Lock-In: PASS**
- **Brock Gym Team Size: FAIL** — Brock allowed battle with more than his two-Pokémon team.

### Root cause

Gen1Recomp's normal R/B/Y Gym Leader dialogue calls `OverworldState:engageTrainer(...)` directly. That path enters the engine's `trainer.before_battle` preparation hook immediately before trainer battle creation. The existing Nuzlocke gate primarily covered scripted `start_battle trainer ...` commands, so Yellow Brock's ordinary leader interaction could bypass it.

### 2.3.32 behavior

`trainer.before_battle` is now the primary Gym Team Size enforcement seam:

- verifies exact next-Leader trainer class + party index;
- leaves ordinary Gym Trainers and unrelated trainer battles untouched;
- counts every carried non-Egg Pokémon as a party slot;
- if over cap, defers battle creation, shows tiered world-building refusal text, then cleanly cancels the pending trainer battle;
- if at or below cap, delegates normally;
- retains the existing scripted command gate for compatible scripted/provider battles.

Gym Lock-In code was not changed.

**Runtime retest required:** Yellow Brock with 3+ Pokémon must refuse; with 1–2 Pokémon must battle normally.


## 2.3.31 RC — runtime-feedback stabilization pass

Built directly from the runtime-tested 2.3.30 RC.

### Confirmed runtime results carried forward

- dependent Randomizer rows hide/show correctly;
- Difficulty selector no longer reports uninstalled Indigo Conference / IronMON providers;
- NUZ STATUS presentation is improved;
- Rules selection/toggle behavior is improved.

### Fixes

- R/B/Y ENC TRACKER no longer requests a 304×144 logical surface; it returns to a native 160×144 / 20-column presentation to prevent the physically shrunken viewport regression.
- R/B/Y MOD COMPAT likewise returns to native 160×144 while preserving the stable host ListMenu state/input lifecycle, explicit RULE/OWNER columns, bold rule labels, and bottom ownership explanation.
- R/B/Y NUZ INFO is now genuinely paged: Catch / Stat / Move pages switch with A or Left/Right, with page count shown in the footer.
- `NUZ INFO` and the current page title are centered and native-bold; only the left data column receives bold emphasis.
- `Randomizer Info` now correctly cycles OPEN INFO / BLIND INFO; it had been missing from the numeric setter and was coerced as a boolean.
- Randomizer row labels shortened to `Rndm Seed`, `Rndm Strtr`, and `Strtr Style`.
- The authoritative Forgiveness Token item definition in `trainer_rewards.lua` now uses `F. TOKEN`, matching the already-shortened injected mart row.

Runtime retest is required for the tracker native-surface change because older development history had a tracker crash on one 160×144 path; this build removes only the newer shrink-causing oversized-surface override while retaining current tracker state/model hardening.


## 2.3.30 RC — difficulty-provider presence fix + additional dependent controls

### Phantom difficulty-provider warnings

Fixed a false-positive provider detector. Historical IDs such as `ironmon_ultimate`, `indigo_conference`, and `stronger_trainers` are recognition hints only. They no longer count as active merely because Nuzlocke knows their IDs.

A historical provider is now exposed in Game Difficulty / stack warnings only when `mod.find(id)` resolves an actually loaded provider. This removes Indigo Conference / IronMON multi-mod warnings on installations where those mods are absent.

### Additional parent/child Randomizer rows

The Setup and in-game NUZ RULES UI now treats these as true dependent rows:

- `Random Starter` → `Starter Style`
- `Random Encounters` → `Encounter Balance`, `Randomizer Info`, `Species Pool`
- `Random Learnsets` → `Learnset Gen`

Child selections remain saved while hidden and return when the parent is re-enabled.

`Failed Encounters` under `One Per Area` remains a candidate for a later dependency pass, but it was not changed here because its encounter-consumption semantics need a dedicated interaction audit first.


## 2.3.29 RC — dependent randomizer selectors + NUZ STATUS polish

### Dependent randomizer controls

`Species Pool` is now a true child of `Random Encounters`, and `Learnset Gen` is a true child of `Random Learnsets`.

- When the parent toggle is OFF, the child row is hidden from both fresh-game Setup and in-game NUZ RULES.
- The saved child selection is preserved while hidden.
- The hidden child has no runtime effect while its parent is OFF.
- Re-enabling the parent immediately restores the child row and its previous selection.
- Species Pool no longer affects Random Starter; starter generation continues to use Starter Style over the full legal live species pool.
- Learnset Gen continues to affect only Random Learnsets.

Compatibility consumers that need effective behavior can use `getEffectiveRuleValue(...)`; raw saved preferences remain available through `getRuleValue(...)`.

### NUZ STATUS

The section label is now `ACTIVE RULES:` and receives native-style bold emphasis without replacing the host ListMenu lifecycle.


## 2.3.28 RC — MOD COMPAT readability / ownership-help pass

R/B/Y MOD COMPAT keeps Gen1Recomp's stable host `ListMenu` as the real state/input owner, but now uses a Nuzlocke-owned 304×144 presentation layer.

Improvements:

- centered `MOD COMPAT` title;
- explicit `RULE / SYSTEM` and `OWNER` column headers;
- five visible compatibility rows with scrolling;
- native cursor glyph on the highlighted row;
- bold-emphasis rule/system labels;
- marquee-safe full-width rule and owner fields instead of the previous aggressive abbreviations;
- bottom hover panel explaining the selected ownership relationship in plain language;
- left/right page movement in addition to up/down row movement;
- generic `nuzlocke_ui` metadata for the MOD COMPAT screen;
- semantic model carries columns, selected row, and explanatory detail for compatible UI presenters.

Ownership help distinguishes Nuzlocke-owned, external-owner, shared-provider, merged-registry, engine/native, difficulty-profile, translation, and presentation-bridge relationships.

This is presentation/diagnostic only. It does not change compatibility negotiation or which provider actually owns a rule.


## 2.3.27 RC — NUZ INFO safe-mode + row-layout stabilization

Runtime feedback confirmed that ordinary R/B/Y Pokémon were repeatedly displaying **DETAIL SAFE MODE**.

Root cause: the public `getPokemonNuzInfo()` compatibility model is created before the later local `Identity` module exists in lexical scope, but its shiny lookup called `Identity.isShiny`. Lua therefore resolved a nil global before `pcall` could protect the call, causing the rich read-only model to fail and the native NUZ INFO screen to fall back to its emergency direct reader.

2.3.27 removes that forward dependency. The early public model now resolves shiny state locally from the Pokémon's explicit shiny flags or, when available, the engine Stats shiny predicate over DVs.

The R/B/Y native CATCH INFO list also shortens the constrained `LOCATION` row label to `LOC.` and glyph-fits right-column values so translated/long location text cannot collide with the left column.

No Pokémon legality, encounter, shiny determination used by gameplay, or tracker behavior is changed.


## 2.3.26 RC — Wide Menus tracker stabilization + shop-label cleanup

### ENC TRACKER / Wide Menus

New runtime feedback isolated the ENC TRACKER crash to the Wide Menus integration path rather than the old Modern UI path.

Earlier builds detected `wide-menus`, delegated the tracker surface to it, and also changed the native tracker box between 20 and 38 columns based on that external owner. 2.3.26 removes both branches.

For R/B/Y, ENC TRACKER now has one invariant presentation contract:

- Nuzlocke owns the **304×144** surface.
- Nuzlocke owns the **38-column × 18-row** box.
- The screen advertises `uiModLayout = "classic"` / `keepClassicUi = true`, asking auto-widening providers to leave it untouched.

Gold keeps its existing native Gen 2 tracker path.

**Status:** targeted fix; runtime confirmation still required for no UI companion, old Modern UI, Wide Menus, and Gold.

### Forgiveness Token shop row

The constrained mart row now displays **`F. TOKEN`** instead of `FORGIVE TOKEN`. Full Forgiveness Token wording remains in descriptive UI, dialogue, rules, and documentation. Price, quantity, purchase behavior, and token mechanics are unchanged.


## 2.3.25 RC — Advanced Box System 1.1.0 + Pokédex Plus 1.3.4

Reviewed the current FAFF0x mod-index metadata/documentation and live repository packages for **Advanced Box System 1.1.0** and **Pokédex Plus 1.3.4**.

### Advanced Box System 1.1.0

The current storage mod adds direct party/box SWAP plus alternate WITHDRAW, DEPOSIT and RELEASE flows while continuing to use Gen1Recomp's real `save.party`, `save.boxes`, `save.currentBox` and stock stat/happiness semantics.

Nuzlocke 2.3.25 therefore upgrades its provider-neutral PC policy into a storage-transaction contract. WITHDRAW and SWAP are judged by the Pokémon entering the active party, so a dead/unusable Pokémon cannot bypass Nuzlocke simply because a third-party PC calls the operation SWAP. DEPOSIT and RELEASE remain navigation/storage-provider-owned unless a separate challenge rule explicitly restricts them.

### Pokédex Plus 1.3.4

Pokédex Plus consumes habitat/encounter, evolution and learnset information. Nuzlocke now explicitly separates:

- the **final composed gameplay encounter registry**, which remains authoritative for encounter-generating providers; and
- an **information/reveal policy** for guide/Pokédex/DexNav-style presentation tools.

`Randomizer Info` has two modes:

- **OPEN INFO** — compatible tools may expose the final randomized encounter tables.
- **BLIND INFO** — compatible tools should conceal undiscovered randomized tables while gameplay providers continue using the same final registry.

The default is OPEN INFO for backwards compatibility. BLIND INFO is cooperative and does not monkey-patch another mod's UI.

Both current FAFF0x versions are source/package reviewed; combined runtime testing is still required.


## 2.3.24 RC — IronMON Ultimate / Enemy HP upstream-resolution pass

A fresh upstream-resolution pass was performed for the two remaining historical compatibility entries.

### IronMON Ultimate

- Surviving Nuzlocke records confirm an **0.4.20 package** was evaluated.
- The historical integration ID `ironmon_ultimate` remains recognized by Nuzlocke's difficulty-provider discovery for backwards compatibility.
- GitHub repository search, public web search, and File Library search did **not** produce a trustworthy canonical Gen1Recomp repository for that package.
- Current public IronMON Ultimate challenge rules were located, but they are a community ruleset and are **not evidence of the Gen1Recomp mod's repository or code lineage**.
- No current-version compatibility claim is made.

### Enemy HP

- Surviving Nuzlocke records confirm an uploaded Enemy HP build received runtime testing and appeared compatible.
- The exact archive version, tested game, mod ID, and canonical repository were not preserved.
- GitHub repository search, public web search, and File Library search did not resolve a trustworthy current upstream.
- No current-version compatibility claim is made.

### Code decision

No Nuzlocke runtime change is justified from unresolved source identity. Existing generalized compatibility surfaces already cover the interaction classes represented by these historical tests: composed trainer parties/difficulty ownership, final battle-state observation, provider-safe hook chaining, and presentation-only UI ownership.

This pass therefore updates provenance/confidence documentation only.


## 2.3.22 RC — Gen 3 Inspired UI Overhaul review

Reviewed the linked **absol89 fork (v1.4.1)** and its newer canonical parent **HighDrexler Gen 3 Inspired UI Overhaul 2.0.0**.

The current 2.0.0 architecture is explicitly presentation-only: engine/native systems retain battle state, Pokémon/storage state, progression, move learning, item semantics and other gameplay ownership while the UI mod owns layout/rendering. It supports both Gen I and Gen II and preserves active sprite-provider ownership.

Nuzlocke 2.3.22 adds a provider-neutral `nuzlocke_ui` presentation contract:

- Nuzlocke custom screens declare their semantic role and that Nuzlocke owns state/actions.
- Rules screen advertises a classic preferred layout.
- ENC TRACKER advertises adaptive presentation.
- Both advertise a native fallback and semantic-adapter safety.
- Presentation mods may query `nuzlocke_ui.describeScreen(...)` instead of guessing from screen names.

No Gen-3-UI-specific enforcement or rendering branch is added. The linked fork remains older than the current canonical 2.0.0 parent, so compatibility claims are source-reviewed rather than runtime-PASS.

## 2.3.21 RC — Weather FX 2.6.0 learning pass

Reviewed the **Weather FX 2.6.0** release metadata. Its headline bug fix is a stale indoor/outdoor classification that remained latched after entering a building, suppressing some weather on later outdoor routes. The release also adds a CYCLE weather option and configurable rare-weather weighting.

Nuzlocke does not currently need a Weather-FX-specific ownership hook: Weather FX operates on environmental presentation/state rather than Nuzlocke's capture, trainer, item, or difficulty ownership surfaces.

The review did expose the same general stale-transition risk in Nuzlocke's transient Dungeon Lock-In record. 2.3.21 now reconciles that record on `map.entered` against the actual engine map. If a map/teleport provider moved the player outside the owning dungeon family without traversing `warp.destination`, the stale lock is cleared immediately.

**Weather FX 2.6.0 status:** release-reviewed / expected compatible; combined runtime test still required.

## 2.3.20 RC — Translation Generator + Shiny Pokemon learning pass

Reviewed **gen1recomp-translation-mod-generator 0.7.0** and **Shiny Pokemon 1.0.1**.

- Translation Generator 0.7.0 adds a separate Gold pipeline and localizes public Gold UI-hook labels by semantic English source text. Nuzlocke now exposes enumerable live section/rule sources through `nuzlocke_translation.sources()` and `catalog()`.
- Shiny Pokemon 1.0.1 amortizes expensive overworld image work and reuses cached presentation assets. Nuzlocke now prepares ENC TRACKER projection/cleanup/row sorting once per update and shares that read-only snapshot across classic, Gold, and Modern UI presenters.

No runtime PASS claim is added until combinations are tested.

## 2.3.19 RC — current compatibility review

Reviewed **Pokemon Snag 0.15.9** and **Too Many Balls 0.6.1** against the 2.3.18 parent.

Generalized changes taken from that review:

- Acquisition API recognizes `trainer_capture` / `trainer_catch` / `snag` as one semantic capture family.
- No Catching applies to cooperative trainer-capture attempts.
- Successful captures from trainer battles are recorded as `trainer_capture` provenance instead of ordinary wild captures.
- Public Item API uses the same dynamic Ball classifier as enforcement, so custom Balls with `ball` metadata, `BALL` pocket metadata, or ItemEffects registration classify correctly.
- Legacy auto-compat can describe trainer-capture/custom-Ball providers without mod-specific enforcement branches.

No runtime PASS claim is made for either current combination yet.

## 2.3.18 RC compatibility notes

No provider or ownership behavior changed. Shared Nuzlocke presentation text now uses the engine font's glyph spans for marquee/truncation safety where applicable.

## 2.3.17 RC compatibility notes

Gold translated status text now uses font-aware clipping rather than raw byte truncation. Unresolved egg provenance remains recorded without advertising `UNKNOWN` as a real visited area.

## 2.3.16 RC compatibility notes

Provider-driven acquisition events now honor explicit source metadata before starter heuristics. Area-less capture calls are guarded correctly, and Gold Physical/Special Split no longer writes temporary category state into provider/engine-owned damage options.

## 2.3.15 RC compatibility notes

Delegated learnset ownership is now provider-agnostic: while an external provider owns Random Learnsets, Nuzlocke forgets its local snapshot and does not touch that registry. Capture policy also keeps location-independent restrictions active when a compatible battle omits an encounter-area key.

The 2.3.14 ENC TRACKER/Wide Menus ownership behavior is preserved.

## 2.3.14 RC compatibility status

ENC TRACKER now avoids duplicate layout ownership with Wide Menus: Wide Menus owns its widening when active; otherwise Nuzlocke supplies the proven 304x144 R/B/Y tracker surface. Modern UI remains a separate presentation adapter. Engine support remains `>=0.1.86 <0.1.99`.

## 2.3.13 RC compatibility status

R/B/Y ENC TRACKER now owns a 304x144 UI surface directly, matching the Wide Menus path that was observed not to crash. This candidate specifically needs runtime checks with no UI companion, Wide Menus, and Modern UI. Gold's native tracker presentation is unchanged.

Engine support remains **Gen1Recomp >=0.1.86 <0.1.99**.

## 2.3.12 final compatibility status


**Corrected 2.3.12 finding:** ENC TRACKER can crash with Modern UI disabled. Wide Menus was observed to mask the native crash, so Modern UI is not established as the cause.
2.3.12 is the final release child of 2.3.11 RC. Engine support remains **Gen1Recomp >=0.1.86 <0.1.99**, with 0.1.98 specifically exercised during the Yellow boot-repair sequence.

Runtime-confirmed on the release-candidate code path: Yellow title boot, fresh-game SETUP, SETUP → NEW GAME, existing SAVE GAME load with correct SETUP suppression, and Gold NEW GAME boot. The boot-safe lifecycle changes from 2.3.11 are unchanged in 2.3.12.

Gold remains beta; untested individual Gold rules and third-party compositions should not be inferred as runtime-confirmed from the boot/new-game PASS alone.

## 2.3.11 full-surface compatibility candidate

2.3.11 restores the 2.3.0 RC compatibility surface while preserving the startup boundaries runtime-cleared by 2.3.7–2.3.9.

2.3.10 freeze result: restoring the full RC code while leaving the first large runtime phase in entry-chunk execution was not sufficient.

For Yellow/Gen1Recomp 0.1.98, pre-title initialization now avoids eager Stats/Growth imports, legacy TitleState fallback execution, R/B/Y-irrelevant Gold title probing, and gameplay monkey-patch installation that can wait until lifecycle events. The public `ui.title_menu.items` path remains authoritative.

The 2.3.2 Gold trainer-battle Ball scoping correction is retained. Historical notes below about feature deferral apply only to their named older builds.

## 2.3.9 public title/setup UI isolation

Yellow 2.3.8 reached title on Gen1Recomp 0.1.98 with the normal initializer active. 2.3.9 restores only `src.core.Strings`, a minimal custom setup screen, and the public `ui.title_menu.items` seam. The internal `title_setup_compat.lua` fallback and all broader runtime initialization remain disabled.

A 2.3.9 PASS clears the public title-menu hook/custom-screen boundary and moves the compatibility bisect to setup-profile/save state or later engine-facing integrations.

## 2.3.8 initializer-boundary isolation

Yellow 2.3.7 reached the title screen on Gen1Recomp 0.1.98 with Nuzlocke as the only enabled mod. 2.3.8 therefore preserves the same manifest/package surface and restores only the normal returned `function(mod)` initializer with static export assignments. Engine-module imports, events, saves, hooks, UI/content writes, and split integrations remain disabled.

A 2.3.8 boot PASS clears this initializer boundary and moves the compatibility bisect to the first engine-facing definitions/imports.

## 2.3.7 loader isolation

2.3.7 keeps the 2.3.6 manifest compatibility surface but runs an inert entry file. This isolates manifest/package/loader behavior from Nuzlocke runtime initialization on Gen1Recomp 0.1.98.

## 2.3.5 diagnostic compatibility mode

2.3.5 keeps Gen1Recomp 0.1.98 inside the manifest range but temporarily disables the executable 2.3.x public battle/contextual-field integrations and broad Gold item-policy expansion. This is a diagnostic boot-isolation build, not the final intended 0.1.98 feature set.

## 2.3.4 Yellow boot-isolation note

The experimental `intro.oak_speech.build` filtering used by **Skip Opening Intro** and the full **Quick Nuzlocke Start** progression transaction are no longer present in the active build. Both features are deferred.

This is intentionally narrower than a rollback of 2.3.x: Gen1Recomp 0.1.98 compatibility work, item-policy fixes, field-action enforcement, and boot-safety lifecycle deferrals remain.

If Yellow still crashes before title with 2.3.4 and no other mods enabled, these two startup shortcuts are not the cause.

## 2.3.3 Yellow boot isolation

Gen1Recomp 0.1.98 Yellow crashed before title on 2.3.0-2.3.2 with all other mods disabled. 2.3.3 removes unnecessary pre-title engine-internal patch installation. Current R/B/Y Setup relies on the public `ui.title_menu.items` hook; the packaged legacy title adapter remains dormant for comparison. Runtime retest required.

## 2.3.2 Wide Menus dependency note

`wide-menus` remains in `optional_dependencies` intentionally. Nuzlocke does not call `mod.find("wide-menus")`; its current compatibility contract is passive: `NuzlockeConfigScreen` sets `uiModLayout = "classic"` and `keepClassicUi = true`, which Wide Menus consumes to suppress automatic widening of Nuzlocke's custom Setup/Rules screens. Gen1Recomp also uses present optional dependencies as load-order edges. The historical 304px claimed-wide adapter remains disabled after the Yellow crash evidence recorded below.

## 2.3.2 compatibility correction

- `contextual_field_actions` is reported as **transitive_native_guard**, not `compose`. Nuzlocke does not replace or wrap `mod.world:useFieldAction` itself.
- On Gen1Recomp 0.1.98, contextual fishing delegates to native execution seams guarded by Nuzlocke: R/B/Y `Overworld.useFishingRod` and Gold `World.useFieldItem`.
- Gold Ball/capture policy is scoped only to catchable battles. The general Gold battle-item policy pass is non-Ball-only, preserving native trainer-battle Ball behavior.

## 2.3.1 / Gen1Recomp 0.1.98 compatibility audit

**Audited upstream tag:** `v0.1.98` (`0e40a7a1f4cd956b37fd74ad50193c259161aac5`)  
**Manifest envelope:** `>=0.1.86 <0.1.99`  
**Mod API:** 2  
**Nuzlocke save schema:** 4

The 0.1.98 review confirms two new generation-neutral public facades relevant to Nuzlocke composition:

- `mod.battle:snapshot()` / `submit(intent)` expose detached current-battle state and validated controls on R/B/Y and Gold. Nuzlocke consumes only the read-only snapshot for interop; it does not drive battles or replace enforcement with intent submission.
- `mod.world:availableFieldActions()` / `useFieldAction()` expose contextual field actions without reopening native inventory screens. Because fishing can now be launched directly through this facade, Nuzlocke 2.3.1 guards the underlying R/B/Y `useFishingRod` and Gold `useFieldItem` seams in addition to its Bag/Pack policy.

0.1.98 also makes Gold's field/battle item behavior more complete. Nuzlocke now treats Berry Juice, RageCandyBar, and Sacred Ash as field healing and makes the Gold battle-item adapter honor every authoritative item-policy rejection rather than a two-code whitelist.

Gold's native starter nickname path is now present upstream. Nuzlocke's native starter force/nonblank gate remains, while scripted gift naming continues through the separate deferred gift path. Quick Start still uses its own controlled starter/nickname transaction and therefore remains runtime TEST REQUIRED with external starter providers.

No new permission is required. Nuzlocke does not opt into network reporting. Versions `0.1.99+` remain intentionally excluded until reviewed.

## 2.2.21 compatibility note — capture-ready Quick Start

Quick Start does **not** replace Gen1Recomp New Game globally. It lets the normal save skeleton, Oak/InitClock semantic setup, and first world initialization occur, then reconciles only the mandatory pre-capture progression before warping to the safe hometown exit. This ordering preserves Gold's native event-bitfield initialization and avoids writing story flags into an uninitialized save.

- External providers advertising `quick_start_provider` or `new_game_progression_provider` own the whole shortcut; Nuzlocke yields.
- Nuzlocke's built-in seeded Random Starter composes because Quick Start explicitly uses the existing starter select/commit contract.
- External starter randomizers that patch only the native starter gift may not see a gift when Nuzlocke owns Quick Start. That combination remains **TEST REQUIRED** and should be treated as canonical-starter fallback unless the companion also supplies a Quick Start integration.
- Translation mods are not text-matched by the shortcut. The only retained interactive text under Nickname Rule is the normal engine naming screen, so existing localization ownership remains authoritative.
- Gold preserves `blackoutMap = CHERRYGROVE_CITY`, matching the native `blackoutmod` state from Mr. Pokémon's house until a later Pokémon Center naturally replaces it.
- No encounter slot is pre-consumed; external encounter randomizers still encounter the normal Route 1/29 runtime seams after control is returned.

## 2.2.20 compatibility note

Skip Opening Intro composes through Gen1Recomp's named `intro.oak_speech.build` wrapper rather than replacing `OakSpeech`, `Game:newGame`, or title flow. Downstream intro mods run first; when Nuzlocke owns the skip, only the required semantic steps are retained. A provider advertising `opening_intro_skip_provider` or `tutorial_qol_provider` suppresses the local Nuzlocke skip. Translation mods remain free to own their catalogs/layout because no translated string matching is used.

Gold retains the engine's `init_clock` step, so intro skipping does not bypass the Gen 2 clock dependency. Runtime multi-mod validation remains required.

## 2.2.19 compatibility note

Seeded randomization remains subordinate to the existing ownership/delegation model. If an external provider owns Random Starter, Random Encounters, or Random Learnsets, Nuzlocke does not apply its seeded transform to that provider-owned surface. The local seed may remain stored for later hand-back, but it does not override the external provider.

Structured modes read only live merged data: BST through the existing merged species/BST compatibility path and evolutionary depth from each live species record's `evolutions[]`. Provider-added species can participate when their records are complete enough for the existing runtime-safety checks. Unknown/incomplete BST or evolution metadata degrades to broader legal pools rather than inventing data or blocking progression.

Pre-2.2.19 persisted randomizer slot maps are migration-safe: valid existing choices are copied/preserved when encountered rather than wholesale rerolled. Because those older choices were generated before a shareable seed existed, a newly displayed seed cannot retroactively make those historical rolls reproducible in a fresh save.

## 2.2.18 compatibility note

Delegated non-core ownership is now enforced at execution time for Automatic Default Names, Skip Catch Tutorial, and fresh-save PC vitamin/heal kits, preventing stale local settings from double-running beside a provider. Gold encounter provenance distinguishes fishing and surf/water from grass so Time Split composition does not multiply provider-generated water/fishing slots. Runtime multi-mod validation remains required.

## 2.2.17 compatibility note

External Difficulty/trainer providers now produce explicit selector warnings when their active hooks can coexist with a different Nuzlocke Difficulty selection. `VANILLA` no longer visually implies a fully vanilla trainer game when Stronger Trainers or another provider remains active. Known historical provider ids are queried directly through `mod.find` as a loaded-mod fallback in addition to the existing status/discovery scan.

## 2.2.16 compatibility note

### Translation companions

The source-reviewed translation companions are **hydhyro/gen1_pt-br_mod 0.1.4** (`gen1_pt-br`) and **eioo/gen1recomp-finnish-mod 0.1.0** (`finnish`). Finnish has no newer release/commit since the earlier review. PT-BR advanced from the previously reviewed 0.1.1 package through 0.1.2, 0.1.3b, and 0.1.4.

PT-BR uses API-2 content/string registries for most localization, including translated `BUY`/`SELL`, but also wraps native `TrainerCard.draw`, `BattleState.drawTextArea`, and `ListMenu.draw` for language-specific layout. Nuzlocke deliberately does not take ownership of those translation/layout choices. R/B/Y Nuzlocke status remains a separate NUZ STATUS surface rather than replacing the native Trainer Card. Shop restrictions continue to identify semantic menu actions first and translated `Strings("BUY")` / `Strings("SELL")` second; no language-specific action words are hardcoded.

`nuzlocke_translation.detect()` and MOD COMPAT now expose the active reviewed translation companion and known PT-BR layout options for diagnostics. Classic MOD COMPAT keeps a real localized full label when one exists; compact English aliases are only fallback labels. Combined PT-BR runtime testing is still required because its generic ListMenu/BattleState wrappers can affect any host-native screen after load-order composition.

### Gym Team Size

The new optional Gym Team Size rule reads the next Leader's **final composed trainer party** through the same `trainer.party` chain used by runtime trainer composition. R/B/Y gates only the exact next Leader's `start_battle` class/party command. Gold gates only `startbattle` when the VM's currently loaded trainer matches the next Johto/Kanto Gym Leader. This deliberately avoids hardcoded party counts and ordinary Gym Trainer interference. Fewer player Pokémon are allowed; only an over-limit roster is rejected.

No compatibility API version, save schema, Mod API, engine range, permission, dependency, or conflict change.

## 2.2.12 compatibility note

Built-in Game Difficulty is a **composition layer**, not a trainer-registry replacement. Nuzlocke receives the live `trainer.party` result, preserves roster slot count/order, and applies deterministic built-in transformations only when a Nuzlocke built-in profile is selected. The returned party and move entries are copied before transformation, so cap previews and repeated battle construction cannot mutate or cumulatively rescale shared trainer/provider rows. Existing live species/move registries remain the source of eligible team and moveset data. Existing Gold held items are preserved.

A selected **external difficulty provider is authoritative**: Nuzlocke skips its built-in roster, level, moveset, Stat EXP/DV, AI, held-item, and badge-boost transformations rather than stacking a second difficulty model on top. VANILLA also skips built-in transforms and continues to permit the separate Trainer Stat EXP / Perfect Trainer IV rules.

Gen 1 AI augmentation is battle-local through the engine's existing `enemyAIMods` scoring layers. Gold AI augmentation copies TrainerClassAttributes before changing the AI bytes, so the shared merged trainer record is not mutated. Profile badge-boost suppression is likewise battle-scoped and does not remove owned badges.

No Compatibility API, Mod API, dependency, conflict, permission, save-schema, or engine-version-range change.

## 2.2.10

Cross-generation species selection remains registry/provider-aware. Gold uses its native Generation 1+2 Pokémon data and `gen2Encounters`. R/B/Y does not assume Gold ROM data is loaded in a Gen 1 session; Gen 2 candidates become eligible only when the active merged content registry exposes complete compatible species records/assets.

`Species Pool = AUTO` preserves 2.2.9 behavior. GEN1/GEN2/BOTH filter only Nuzlocke-owned Random Starter/Random Encounters. If an external encounter randomizer owns that mechanic, Nuzlocke drops its snapshot and does not restore stale encounter data over the provider.

The optional Physical/Special Split wraps the shared `battle.damage` hook and passes its modified context onward, so other damage-hook providers remain in the chain. Nuzlocke uses per-call copies/overrides instead of mutating shared move/type registry records. Gold's `battle.damage_dealt` path is also used to keep Counter/Mirror Coat damage identity aligned.

No Compatibility API, Mod API, dependency, conflict, or engine-version-range change.

## 2.2.9
Internal runtime initialization is split further for Lua 5.1 headroom. No public compatibility API change.

## 2.2.8 compatibility note

Vanilla ScriptRunner dialogue is once again left engine-owned at T3; only Nuzlocke-authored world-building text is normalized by Nuzlocke's paginator. This reduces interference with vanilla text semantics and other script providers.

For built-in Nuzlocke Difficulty profiles, live cap UI now previews the same `trainer.party` composition hook used by future trainer battles. External provider behavior is otherwise unchanged.

## 2.2.7 compatibility note

2.2.7 specifically repairs compatibility with the Lua 5.1 compiler limit of 60 upvalues per function. The former monolithic late-runtime installer is split into two sequential closures while preserving installation order and the existing compatibility architecture. No public provider/API or engine-version-range change.

## 2.2.6 compatibility note

2.2.6 addresses a Lua 5.1 compiler compatibility limit in the monolithic mod entry function. The Skip Catch Tutorial query no longer consumes an additional long-lived local variable; it is stored on the already-existing internal beta export table instead. No engine range or provider API contract changes.

## 2.2.5 compatibility note

No public compatibility-contract change. The 2.2.4 chairman renderer ownership table is removed from file scope and replaced by NPC-local marker state to avoid increasing the long-lived local count in `main.lua`. This is specifically intended to preserve Lua 5.1 compiler compatibility on the current Gen1Recomp target.

## 2.2.4 compatibility note

No engine-range or provider-contract change. The Tier-3 Pokémon Bois Club chairman now uses a genuine Gen1Recomp `SpriteRenderer` backed by an existing entry in `game.data.sprites`, matching the native-walker strategy already used by Bryan-at-Home. Restoration is conservative: Nuzlocke restores the cached vanilla chairman only while its own replacement still owns the live sprite slot, avoiding clobbering a later third-party replacement. Gen1Recomp 0.1.94 remains the source-audited target within `>=0.1.86 <0.1.98`.

## 2.2.3 compatibility note

No compatibility contract or engine-range change. Gen1Recomp 0.1.94 remains the source-audited target within `>=0.1.86 <0.1.98`. The Yellow Pallet skip is aligned to the audited upstream flow where `story2.lua` creates a level-5 Pikachu battle, calls `makeOldManDemo("PROF.OAK")`, sets `battle.onFinish`, and routes it through `Commands.pushBattle`. The wrapper still delegates every non-target battle unchanged. NUZ INFO continues to use the host-native ListMenu and read-only API-27 data so Modern UI/party-menu providers do not need to scrape a custom screen.

## 2.2.2 compatibility note

Direct child of 2.2.1. This is a presentation/documentation-only follow-up: Trainer Money now displays as `Btl. ¥`. Yellow 2.1.24 runtime testing confirmed No Buying, No Selling, and No Center Heal enforcement on an existing save. No provider contract, engine range, permission, save schema, or enforcement path changed. Gen1Recomp 0.1.94 remains the audited target.

## 2.2.1 compatibility note

Direct child of 2.2.0. The only runtime change is a Gold-native menu geometry correction: values/toggles are anchored one native tile farther left to avoid the right frame. No upstream hook, provider, engine range, permission, save-schema, R/B/Y, or enforcement contract changed. Gen1Recomp 0.1.94 remains the audited target.

## 2.2.0 / Gen1Recomp 0.1.94 compatibility audit

**Audited upstream tag:** `v0.1.94` (`5d2c13ed2bdc215ad4655b3361e8af294322062c`)

**Manifest envelope:** `>=0.1.86 <0.1.98`  
**Mod API:** 2  
**Nuzlocke save schema:** 4  
**Permissions:** `engine_internals`

The v0.1.93→v0.1.94 comparison is 10 commits ahead. The reviewed compatibility-relevant changes are mod-platform infrastructure: launcher conflicts can now respect version ranges, and API-2 mods may opt into one-way log reporting through a manifest-declared HTTPS `log_url` plus the `network` permission. Nuzlocke currently declares no conflicts and does not require outbound log reporting, so 2.2.0 intentionally adds neither a conflict migration nor the network permission/log URL.

No reviewed v0.1.94 change alters the battle, PartyMenu, ScriptRunner, ListMenu, Pokémon construction, encounter, save-schema, or Gen2 enforcement contracts Nuzlocke relies on. Existing 0.1.93-era gameplay seams are therefore retained; 0.1.94 runtime remains TEST REQUIRED until user smoke testing completes.

2.2.0 also hardens optional presentation/provider boundaries discovered during Yellow runtime testing: R/B/Y NUZ INFO cannot let API-27/provider diagnostics escape into the party menu; classic MOD COMPAT clamps both columns while Modern UI receives full semantics; NUZ ST. carries semantic heading rows; and Yellow's Pallet Professor Oak demo is intercepted at the direct `Commands.pushBattle` path because it is not a ScriptRunner `old_man_demo` row.

## 2.1.23 compatibility note

The T3 dialogue pass is presentation-only and does not replace ScriptRunner ownership: the existing `script.command` chain still receives the same command and story state, with only T3 `show_text`/`ask` text payload presentation normalized when a continuation marker is present. R/B/Y catch-demo skipping consumes only the semantic `old_man_demo` command. Gold continues to use its independent Gen2 tutorial seam.

## 2.1.22 R/B/Y menu-surface compatibility

R/B/Y NUZ ST. and MOD COMPAT now delegate presentation and StateStack behavior to Gen1Recomp ListMenu after Yellow runtime crashes in the previous custom-state implementations. Gold paths are unchanged.

## 2.1.21 compatibility note

Gold's native configuration renderer changes only column spacing: label capacity is reduced by one tile while the seven-tile value column is preserved. No compatibility API, save schema, provider contract, or R/B/Y UI surface changes.

## 2.1.19 lifecycle/reload compatibility

## 2.1.20 compatibility note

No compatibility API or save-schema bump. Game Difficulty keeps the same stable provider/profile IDs; only its menu section changed. NUZ RULES and R/B/Y NUZ STATUS now defer custom-screen runtime-failure cleanup to update-time so the renderer/StateStack is not mutated from inside draw.

This candidate hardens three compatibility seams without changing rules. Gen1 kerning wrapper installation can retry on lifecycle events regardless of the active generation, while its effect remains Gen1-only. The optional Gen1 Modern UI adapter now requires the provider's documented explicit `true` success result. The R/B/Y title SETUP fallback is reload-stable and refreshes its current callback/translation/editor dependencies rather than binding permanently to one mod instance. Runtime retest is required for ordinary R/B/Y title Setup, save-editor enter/leave in one process, mod reload/hot reload, and Modern UI present/absent cases.

## 2.1.18 Trainer Card and dialogue ownership compatibility

R/B/Y's native Trainer Card is no longer wrapped or replaced by the Nuzlocke START-menu hook. `NUZ ST.` is a separate status screen, mirroring the already-separated Gold model and reducing collision risk with Gen1 Modern UI, portrait, badge, translation, and Trainer Card providers. The historical combined screen remains internally capable of degrading to status-only, but normal Nuzlocke navigation does not construct the native card. Script-command denial/flavor presentation now marks the active ScriptRunner context once a Nuzlocke response is shown, preventing a second Nuzlocke seam from stacking another response in the same transaction. No provider API or save-schema bump.

## 2.1.18 configuration compatibility

No provider contract changed. Game Difficulty now constrains UI cycling to the live merged difficulty-provider list, preventing out-of-range numeric selections. `pc_starting_heal_items` is a QoL starting-resource control and participates in the same `starting_resource_provider` delegation family as PC Vitamins. Runtime composition with external starting-resource providers remains TEST REQUIRED.

## 2.1.16 shared Type Locke compatibility

R/B/Y and Gold use the same OFF/MONO/DUO/TRI invariant. Provider/custom species metadata continues to fail open when no recognizable type metadata exists. Compatible concrete DARK/STEEL/FAIRY content remains selectable. `type_lock_tertiary` is local Nuzlocke configuration state and does not change external provider ownership/delegation rules. No Catching and Route Forgiveness were only reorganized in the menu; their compatibility behavior is unchanged.

## 2.1.15 shared configuration compatibility repair

R/B/Y and Gold now share the same Type Locke visibility/state invariant: OFF exposes no type selectors, MONO exposes Type 1 only, and DUO exposes both. The restored reversible Rule Lock is local configuration state and does not change provider delegation or Permanent Rule Seal compatibility semantics. Runtime retest required.

## 2.1.14 shared Type Locke configuration repair

The shared R/B/Y + Gold configuration surface now treats MONO as a true one-type state: the secondary type is inactive/cleared and the Type 2 row is not exposed. DUO re-establishes a distinct secondary. No provider API or acquisition-policy semantics changed. Runtime confirmation remains required.

## 2.1.13 Yellow/T3 compatibility repair

Gen1Recomp 0.1.93 source confirms `pokemon.before_give` is emitted before `Pokemon.new`, so the existing starter species transform remains the correct pre-creation seam. The repair therefore keeps that hook and hardens which species may be selected: a concrete starter must have the growth/type/learnset/stat data and displayed move definitions required by the engine's `Pokemon.new` and `SummaryMenu` paths.

This is especially important for compatibility providers that publish partial species metadata for legality, BST, typing, or future cross-generation pools. Such records remain usable by their intended compatibility APIs but are excluded from concrete starter generation until the active engine data can fully construct and display them.

Bryan's T3 home object is runtime-only, uses a high synthetic object index, checks live walkability/occupancy before insertion, and adds no persistent map-definition object. T0–T2 does not insert him.

No new engine permission is required. Current declaration remains `>=0.1.86 <0.1.98`; audited marker remains `0.1.93`.

## 2.1.12 Route Forgiveness reward ownership

Nuzlocke now owns a single reward source for each Gym clear: the Gym Leader victory path. Ordinary Gym Trainers and the Gym Guide do not independently mint Route Forgiveness Tokens. The persistent reward ledger is keyed by normalized Leader identity so provider/rematch party changes cannot duplicate a Gym reward.

Old `route_forgiveness_gym_trainers` data may remain in saves but is ignored; no destructive migration is performed.

Compact UI labels remain presentation-only and do not change rule keys or translation-source semantics.

## Gen1Recomp 0.1.93 — 2.1.11

Current engine declaration remains:

`>=0.1.86 <0.1.98`

0.1.93 is source-audited. The upstream 0.1.92→0.1.93 comparison contains 14 commits and modifies launcher/updater docs and code, `src/core/Data.lua`, `src/mods/LegacyCompat.lua`, update/TLS infrastructure, mobile import-picker support, save-editor support, and tests.

Notable reviewed engine behavior:
- data loading/default seeding is hardened, including Gold optional table handling;
- Yellow stale-cache correction includes version-specific trade/demo data;
- LegacyCompat continues to route removed sandbox filesystem behavior through controlled compatibility storage;
- new required/optional-import infrastructure remains manifest-scoped and does not require Nuzlocke changes;
- no reviewed battle/encounter/shop/save hook change requires a Nuzlocke mechanics rewrite.

Nuzlocke's internal audited-engine marker is updated to `0.1.93`.

Versions 0.1.94–0.1.97 remain forward-allowed only and must be re-audited when released.

## Translation compatibility

Compact menu strings are no longer the canonical translation keys. Full natural labels remain canonical, while optional short labels are presentation metadata. If a translation pack only knows the full label, that translation remains authoritative even when it has to marquee-scroll.

## 2.1.10 Wide Menus status

Wide Menus can be installed alongside Nuzlocke without the previous Yellow fresh-Setup crash. Nuzlocke explicitly keeps `NuzlockeConfigScreen` on the classic/native-width path (`uiModLayout = "classic"`, `keepClassicUi = true`).

Therefore the Nuzlocke Setup/Rules screen is **not expected to become wider** in this candidate. A true Wide Menus layout remains deferred until it can be implemented and runtime-validated without sacrificing Setup stability.

## 2.1.9 Wide Menus explicit classic layout

Wide Menus 0.1.0 can auto-widen opaque mod-owned screens even when a mod never calls `claim()`. Nuzlocke therefore explicitly marks `NuzlockeConfigScreen` instances with:

- `uiModLayout = "classic"`
- `keepClassicUi = true`

This applies to both fresh NEW GAME Setup and in-game NUZ RULES. The intent is coexistence: Wide Menus remains free to affect its own supported screens while Nuzlocke's custom configuration screen stays on its validated native-width path.

## 2.1.8 presentation note

No compatibility contract changes. The Randomizer rule keys and provider ownership remain `random_starter`, `random_encounter_tables`, and `random_learnsets`; only their Nuzlocke-owned menu labels are abbreviated.

## 2.1.7 Wide Menus coexistence

The optional `wide-menus` mod may remain installed, but Nuzlocke 2.1.7 does not claim its wide canvas for the custom NUZ RULES screen. Yellow runtime testing on Gen1Recomp 0.1.92 showed that the previous claimed-wide path could crash.

Until a separately tested adapter is implemented, native-width fallback is the compatibility-safe behavior. This does not disable Wide Menus for other mods/screens.

## 2.1.6 Yellow variable-width presentation

R/B/Y configuration text remains pixel-measured. Text that fits never scrolls; true overflow uses the slower historical marquee cadence. Selection highlighting no longer depends on palette-sensitive filled reverse video and instead uses an outline, preserving font rendering under Yellow's palette path.

Gold remains on its native Gen2 presentation path.

## 2.1.5 variable-width R/B/Y presentation

Nuzlocke-owned R/B/Y configuration screens continue to use the current engine Font's pixel measurement. Text remains stationary when it fits. Only genuine overflow enters a glyph-safe marquee path.

Selection no longer depends on the native left cursor glyph in these Nuzlocke-owned rows; reverse-video highlighting frees that space for labels. This is presentation-only and does not alter rule semantics or input behavior.

Gold stays on its native Gen2 UI path.

## 2.1.4 Gen1 presentation compatibility

After 2.1.3 runtime validation proved the Gen1 variable-width Font path active, Nuzlocke's R/B/Y-owned screens now use the engine Font's actual pixel measurement (`width`, glyph spans and fitting helpers) instead of fixed character windows for primary rule presentation.

This avoids old fixed-width marquee assumptions and keeps MOD COMPAT columns from colliding under variable-width text.

Gold remains on its native Gen2 presentation path.

## 2.1.3 focused compatibility hardening

- Modern UI/kerning integration receives the actual maintained active game through dependency injection; it no longer depends on `mod.game` being populated.
- MOD COMPAT continues to use the current Gen1Recomp Font drawing surface rather than the removed Draw module.
- `compat21.pokemonLegality()` correctly surfaces preserved-but-invalid gift/trade acquisitions.
- Gym Trainer reward dedup keys preserve semantic trainer identity boundaries.

Engine declaration remains `>=0.1.86 <0.1.98`. 0.1.92 is source-audited; 0.1.93–0.1.97 are proactive forward allowance only.

## Yellow / Gen1Recomp 0.1.92 — 2.1.2

Runtime: fresh Setup and Setup-to-game boot PASS on Yellow. The 2.1.1 MOD COMPAT screen crashed because it referenced the obsolete `src.render.Draw` module; 2.1.2 uses the current Font drawing surface. Gen1 kerning fallback now retries after game/save readiness. Both repaired paths require runtime retest.

## Gen1Recomp 0.1.92 / forward envelope — 2.1.1

Manifest engine range: `>=0.1.86 <0.1.98`.

- 0.1.86–0.1.90: inherited supported envelope.
- 0.1.92: source-audited against the upstream `v0.1.90..v0.1.92` delta.
- 0.1.93–0.1.97: proactive forward allowance only; re-audit required as each version ships.
- 0.1.98+: deliberately excluded until the envelope is renewed.

The 0.1.92 changes are concentrated in loader/sandbox compatibility, background HTTP/jobs, ROM import performance and launcher/UI infrastructure. No reviewed change requires Nuzlocke to take new permissions or replace its current gameplay hooks.

## 2.1.0 version identity

Nuzlocke now uses ordinary semantic versioning for distribution/update detection. `2.1.0` is functionally the same code tree as the former `2.0.0-beta.31.0.4`; compatibility envelopes, provider contracts, Mod API and save schema are unchanged.

## Wide Menus V0.1.0 — beta.31.0.4

Optional presentation integration is enabled for the in-game R/B/Y `NuzlockeConfigScreen` only. Nuzlocke uses Wide Menus' documented `claim`/layout contract; Wide Menus does not own Nuzlocke state or actions.

- Active Wide Menus + R/B/Y in-game Nuz Rules: wide presentation.
- Wide Menus absent/disabled: native 160×144 fallback.
- Fresh Setup: native.
- Gold: native.
- No hard dependency and no save coupling.

## beta.31.0.3 dungeon-map classification

Dungeon-family fallback matching now excludes service-interior identifiers (Pokémon Centers and Poké Marts) before landmark-prefix matching. External map/content providers can still supply an explicit semantic `dungeonFamily`; the fallback no longer guesses that an adjacent service building is part of a dungeon.

## Gen1Recomp 0.1.90 — reviewed in beta.31.0.2

Static/source compatibility review PASS. The manifest remains `>=0.1.86 <0.1.91`.

Relevant upstream changes:
- SaveData can re-index orphaned slot files when the options slot registry is lost.
- PartyMenu field actions now choose generation-appropriate field-move paths, including Gold fallbacks.
- No Mod API bump or Nuzlocke hook-breaking surface was found in the 0.1.89 → 0.1.90 delta.

Nuzlocke continues to use engine-owned SaveData APIs rather than direct title-time filesystem access. Runtime smoke testing on 0.1.90 remains required.

## 2.0.0-beta.31.0.1

Modern UI registration is now deferred until the active game is known, performed at most once per provider registration state, and considered inactive on Gold/Gen2. Adapter model/action callbacks also fail closed outside confirmed Gen1 so a stale external registration cannot expose Gen1 presentation after a same-process game switch.

## Future design notes recorded in beta.30.1.23

A future Black Market feature should remain provider-aware: Nuzlocke may own challenge-policy legality while external item/species/economy providers retain their mechanics. It must not silently overwrite randomized/content-provider registries or bypass progression-required safeguards. Achievement reactions are likewise planned as semantic World Building consumers once an achievement provider contract exists.

## 2.0.0-beta.30.1.22 — visible effective ownership

The in-game **MOD COMPAT** screen now exposes a broader effective-ownership matrix rather than merely reporting whether a companion mod is installed. Provider rows are derived from active delegation/provider resolution where available. Encounter Tracker and NUZ INFO consume only known semantic provenance; they do not reveal future randomized mappings or infer provider ownership from a package name when no supported ownership seam exists.

NUZ INFO legality is evaluated against current Nuzlocke restrictions and is diagnostic only. Existing Pokémon are never deleted or rewritten merely because a later rule change makes them display as restricted.

## 2.0.0-beta.30.1.21 — Gen1 font presentation interoperability

Nuzlocke now contains its own Gen1-only variable-width tile-font presentation layer, independently implemented after the compatibility review of `SliferDaG/TextKerningGen1Recomp`. The wrapper is generation-gated on every call: Red/Blue/Yellow may use the tighter glyph metrics, while Gold/Gen2 always receives the pre-existing Font behavior. If the reviewed external kerning marker (`Font._origAdvanceOf`) is already present, Nuzlocke declines to stack another transform. This is presentation interoperability only and does not transfer challenge-policy ownership. Exact mixed-mod and Gold runtime behavior remains TEST REQUIRED.

## 2.0.0-beta.30.0.0.10

Provider ownership now distinguishes **stored preference** from **effective mechanic**. A delegated non-core Nuzlocke option is effectively OFF while the provider is active, but its dormant stored preference survives and presets may update that dormant value. Removing the provider therefore restores the correct intended Nuzlocke configuration. Generic mod IDs containing `RANDOMIZER` no longer own all randomizer families; providers should advertise `starter_randomizer_provider`, `encounter_randomizer_provider`, or `learnset_randomizer_provider` explicitly. Automatic legacy adapters are rebuilt from the active graph to avoid stale ownership. EXP Edging follows level-cap ownership.

External item UIs should use `nuzlocke.itemPolicy`; it now reaches the same authoritative policy as native item menus. External gift/trade/acquisition providers should use `nuzlocke.acquisitionPolicy`; Type Locke and special acquisition bans now share native helpers. AutoCompat snapshots `game.save.party` and `game.save.boxes`, matching current engine save ownership.

# Compatibility

This document records compatibility claims for Nuzlocke `2.0.0-beta.29.3.13`. A compatibility percentage is an evidence-weighted confidence estimate, not a measured failure rate.

Repository/release metadata in the named-project table was refreshed on **2026-08-13** where a canonical repository could be verified. Historical test confidence remains attached to the exact tested/reviewed version, not automatically to the refreshed latest release.

## Engine support

| Gen1Recomp | Status | Confidence | Evidence |
|---|---|---:|---|
| **0.1.81** | Supported / historical audited profile | **96%** | Protected source profile plus substantial R/B/Y and Gold runtime history from the beta.28/29 line. |
| **0.1.82** | Source-audited / supported by range | **88%** | Exact-source review confirmed the protected battle, item, shop, save, UI, and Gold script seams remain available; exact 0.1.82 gameplay runtime coverage is limited. |
| **0.1.83** | Current source-audited profile / runtime test required | **88%** | Exact v0.1.83 source review confirms Gen1Recomp Mod API 2, save format 4, and the Nuzlocke wrapper signatures/contracts. Mod Manager import/discovery and the old-version gate were exercised on 0.1.83; gameplay certification remains pending. |

The release manifest uses `>=0.1.81 <0.1.84`. Widening the range is based on exact-source compatibility review, not on assumed forward compatibility. Runtime coverage on 0.1.83 remains an ongoing beta requirement, with Gold retaining the largest unverified surface.

Gen1Recomp 0.1.83 adds a public Gold `mod.world:mapOverview()` surface without removing the existing Nuzlocke tracker seams. This release intentionally keeps the established ENC TRACKER implementation unchanged; a future migration can be considered only after behavioral equivalence is demonstrated.

### Mod Manager beta-release limitation

Current Gen1Recomp release parsing compares beta-tagged releases by their leading `x.y.z` triple. A tag such as `2.0.0-beta.29.3.11` can therefore be presented as `v2.0.0 available` even when the installed beta is current. This is an update-status limitation, not a Nuzlocke gameplay compatibility failure.

Before publication, local development builds remain ahead of what the repository can serve; using **Update** on one of those builds can install the latest published Nuzlocke release instead. After publication, the in-game updater still needs an end-to-end beta-tag test.

## Game targeting

The release declares exactly:

```json
"games": ["red", "blue", "yellow", "gold"]
```

Gold support does not imply Silver/Crystal support.

## Gold UI ownership

Gold and R/B/Y share public UI hooks but not the same native menu chrome. Gen1Recomp's Gen 2 compatibility documentation explicitly lists `src.ui.OptionRows` as a module with no Gen 2 facade because it paints the Gen 1 option layout over Gold. `2.0.0-beta.29.3.9` therefore keeps Nuzlocke configuration/encounter state shared while rendering Nuzlocke-owned Gold screens with `src.ui.gen2.Chrome`. Nuzlocke does not replace Gold's global menu renderer or native Trainer Card lifecycle.

The Gold-native presentation currently covers Setup/Nuz Rules, ENC TRACKER, CATCH INFO, Route Forgiveness, and NUZ STATUS. Runtime validation remains required; this is a presentation compatibility change, not new gameplay evidence.

## Compatibility architecture

Nuzlocke compatibility API v26 separates:

- **engine compatibility** — audited engine profiles and generation-specific seams;
- **mod compatibility** — capability discovery and `compose`, `delegate`, `exclusive`, `observe`, or `incompatible` relationships.

Discovery is capability/behavior based rather than a hard-coded mod-name allowlist. Providers are revalidated against the active loader composition so stale disabled providers do not remain authoritative.

Important capabilities include item use, shopping, healing, battle finish, Trainer Card/party/start menus, screens, encounters, static encounters, trainer parties, boss caps, Pokémon identity, species metadata, battle classification, movement speed, and starter randomization.

## beta.29.3.13 compatibility hardening

- Trainer Money now reads/writes both supported save-wallet shapes (`save.money` in R/B/Y and `save.player.money` in Gold) and is completely inert when the Nuzlocke master switch is OFF.
- Trainer Money respects an economy provider's published wallet ceiling aliases (`maxMoney`, `moneyMax`, or `walletCap`) in deterministic precedence order; absent an explicit cap, it will not truncate a provider-created wallet already above the native ¥999,999 ceiling.
- Dynamic Game Difficulty providers are identified by stable provider/profile ID. Load-order, enable/disable, and provider-name/order changes no longer make a saved numeric index authoritative. Missing providers degrade to VANILLA without destroying the requested ID.
- Dungeon Lock-In records the exact exterior entrance warp from the public `warp.destination` context. This avoids false lockouts where multiple entrances share one outside map; old state without enough information fails open.
- Source-less Pokémon acquisition fallback is deliberately conservative: version-aware gift/trade inference requires location agreement rather than classifying on species alone. This is safer for encounter/randomizer mods that can place prize/gift species in ordinary wild tables.
- Compatibility API 26 exposes the above state through read-only helpers instead of requiring companion mods to infer private implementation details, including migration warnings and deterministic-source checks for location-less acquisition events.

These changes are designed to fail open when authoritative external metadata is absent and to preserve predecessor/next behavior on shared seams. Exact multi-mod runtime matrices remain TEST REQUIRED.

- **Final-destination warp composition:** the lock-in wrapper calls downstream `warp.destination` providers first, then applies Nuzlocke policy to their final map/cell. The upstream resolver is pure, so this does not duplicate a warp side effect.
- **Gold NPC trades:** the native Gen 2 `TradeMenu` is gated before `NpcTrade.markDone`/`NpcTrade.perform`; successful trades are tracked after the native transaction. This avoids destructive rollback and gives Type Locke/Gift-Trade policy a real pre-mutation seam.
- **Conservative source inference:** Gen-I gift/trade lookup is generation-gated, authoritative R/B/Yellow trade data is used, explicit provider locations win, and unknown-location source-less inference is limited to provenance-deterministic species.
- **Random Type compatibility:** RANDOM Type Locke selection discovers viable types from the live merged species registry plus the optional species-metadata provider. Unknown provider schemas continue to fail open.

## Save Editor

Gen1Recomp's embedded Save Editor creates a separate ModLoader inside the same process. Nuzlocke avoids installing gameplay-bound runtime monkey patches in the Save Editor loader session and expects the gameplay loader to bind them normally.

**Testing rule:** after editing a save, fully close and relaunch Gen1Recomp before judging a gameplay-rule result.

A Yellow existing-save test that initially appeared inconsistent after Save Editor use passed No TMs and No Rare Candy after a full close/reopen cycle.

## Temporary-party compatibility

beta.28.20 hardened Permadeath/Whiteout around battle systems that temporarily narrow or reorder the player's party and restore it during teardown:

- Whiteout is evaluated against the real restored post-battle party.
- A healthy restored reserve prevents a false run-ending Whiteout.
- A restored Pokémon already marked dead is reconciled by Permadeath rather than becoming usable again.

Exact runtime coverage of every temporary-party implementation remains a testing target.

## UI replacement/theme compatibility

Current runtime evidence shows the core rule UI works, including current Yellow navigation and Gold/Yellow collapsible sections. A known compatibility gap remains: several Nuzlocke-owned screens are not yet automatically rendered/themed by every UI replacement.

Known affected surfaces:

- Nuzlocke Setup
- NUZ RULES
- ENC TRACKER — LOG
- ENC TRACKER — MAP
- R/B/Y NUZ STATUS
- CATCH INFO

This is active beta.29 work rather than a claim of full UI-theme compatibility.

## Versioned third-party compatibility evidence

Only identifiable projects with preserved evidence are listed as named entries. “Latest” means the latest version verified from that project's canonical repository at candidate preparation time; confidence applies to the **tested version**, not automatically to a newer release.

| Project | Canonical repository | Latest verified | Exact reviewed/tested version | Red | Blue | Yellow | Gold | Evidence / known boundary |
|---|---|---:|---:|---:|---:|---:|---:|---|
| **Shiny Pokemon** | `masterwebx/gen1recomp-shiny-pokemon` | **1.0.1** | **1.0.1** | 96% | 96% | 97% | 0%* | The 1.0.1 combination received runtime testing and compatibility evaluation; no direct Nuzlocke gameplay-hook collision was observed. *Its manifest does not declare Gold, so Gold is not scored as a supported combination. |
| **Pokemon Snag** | `mistermiracle3036/Pokemon-Snag` | **0.15.9 reviewed** | Current source reviewed 2026-08-16 | 82% | 82% | 82% | 76%* | 0.15.9 now targets Gen 1 + Gold and implements trainer-Pokemon capture plus persistent snag provenance. Nuzlocke 2.3.19 adds first-class `trainer_capture` acquisition semantics and tracker provenance. *Gold remains runtime-unverified together. |
| **Too Many Balls** *(formerly Kanto Balls)* | `mistermiracle3036/Too-Many-Balls` | **0.6.1 reviewed** | Current source reviewed 2026-08-16 | 88% | 88% | 88% | 84%* | 0.6.1 supports both generations, publishes Ball ownership, and folds Shop Events into the main mod while preserving the `shop.purchased` event contract. Nuzlocke 2.3.19 now reports provider-added Balls through the public Item API using semantic Ball metadata instead of the vanilla-ID list. *Gold remains runtime-unverified. |
| **IronMON Ultimate** | canonical repository not yet verified | unknown | **0.4.20** package evaluated | 84% | 84% | 86% | 72% | Compatibility evaluation covered broad shared rule/trainer/item surfaces; exact game-specific runtime evidence is not preserved in the current ledger. |
| **Enemy HP** | canonical repository/version not yet verified | unknown | uploaded test archive | 90% | 90% | 90% | N/E | The uploaded build received runtime testing and appeared compatible; exact archive version and tested game were not preserved, so confidence is capped. |
| **Gen1Recomp Translation Mod Generator** | `thibautbus/gen1recomp-translation-mod-generator` | **0.6.0** | **0.6.0** tooling evaluation | Tool | Tool | Tool | Tool | Development/tooling compatibility evidence; not a gameplay mod combination. Nuzlocke exposes a translation API with stable English source strings. |
| **UI/theme replacements (generic)** | varies | varies | current runtime combination not canonically identified | 62% | 62% | 65% | 65% | Core menus function, but the six Nuzlocke-owned screens listed above are not yet fully themed/composed. |

`N/E` means there is not enough version/game-specific evidence to publish a numeric compatibility claim without guessing.

## Historical compatibility-review set

Earlier compatibility reviews also covered Repel reuse, dual-screen battle presentation, trainer difficulty/party changes, randomization, in-battle evolution, per-Pokémon metadata/ribbons, and large merged-dex content. Exact project versions were not consistently preserved in the surviving ledger, so this candidate does not pretend those reviews verify today's latest releases.

The current compatibility surface addresses these interaction classes through semantic pre-checks (`canUseItem`, `canCapture`, shop policy), merged data, stable Pokémon identity, explicit capability relationships, dynamic trainer-party observation, and conservative failure behavior.

## Confidence policy

- Exact runtime PASS on the same game/version is strongest evidence.
- Behavior-level headless tests and `modkit` validation are strong supporting evidence.
- Compile/load and static inspection are necessary but cannot establish full gameplay parity alone.
- A known runtime FAIL overrides static success.
- Changing a relevant code path lowers confidence until that path is retested.
- A newer third-party version never inherits the older version's confidence automatically.

## Historical compatibility record

The beta.29.2.0 history-recovery pass added two supported historical checkpoints without changing the current compatibility contract:

- beta.21 surviving reconstruction: Gen1Recomp 0.1.78 audit era, save schema 4, Nuzlocke Compatibility API v9.
- beta.27.3: Gen1Recomp 0.1.79 audit era, shared `ItemEffects.use` repair, Nuzlocke Compatibility API v11.

These are historical records only. Current integration targets remain the version/API values documented at the top of this file.

## beta.29.2.2 trainer-roster compatibility hardening

Level caps continue to read the final merged trainer registry at point of use. beta.29.2.2 broadens ace-level discovery to a bounded set of nested semantic roster containers (`party`, `team`, `pokemon`, `mons`, `roster`, `members`) so compatible trainer-content changes do not have to preserve one exact immediate-array shape. Runtime confirmation is still required for any named trainer-content package/version before compatibility is promoted beyond TEST REQUIRED.

Level Cap Scope **POST** is the current opt-in for provider-driven postgame cap stages. The retired separate expanded/additional-content control is not expected to appear in current Setup/NUZ RULES.

Gen1Recomp's in-game update flow is currently treated as unsafe for this beta tag line when it resolves a newer installed beta to an older published candidate. Until the engine's version-resolution behavior is verified corrected, use the newest release package manually rather than accepting an offered downgrade.

### Indigo Plateau Conference 1.0.2

Audited for Pokemon Gold. Indigo Plateau Conference owns its Colosseum staging, runtime NPCs, tournament run state, CANLOSE setup, challenger substitution, and intended survivor healing. Nuzlocke does not overwrite those systems.

`trainer.party` is cooperative: Nuzlocke observes the final composed party and does not replace it. Gold trainer-content inspection also understands the canonical `gen2Trainers.classes` registry.

Permadeath remains Nuzlocke-owned. Tournament healing may restore surviving Pokemon, but a Pokemon already recorded dead by Nuzlocke is returned to 0 HP during post-battle/map reconciliation. Whiteout also remains Nuzlocke-owned; if enabled, it can still end a Nuzlocke run even though the tournament itself uses CANLOSE.


### Stronger Trainers runtime cap preview

The active boss roster can be produced only through the shared `trainer.party` composition path. Nuzlocke therefore performs a protected preview of that semantic hook for the next boss when the relevant runtime trainer-balance mod is active, then reads the ace from the composed result. The real battle still owns and recomputes its own party normally; Nuzlocke does not replace trainer teams. Runtime certification is still required because 29.2.6 showed vanilla caps before this pre-battle preview existed.


### Stronger Trainers runtime status

The current release observes the composed `trainer.party` chain from the outside and can preview the composed next-boss party before battle for supported R/B/Y boss-cap displays. Yellow runtime testing on the beta.29.2.7 lineage confirmed that both the Trainer Card and Encounter Log displayed the Stronger Trainers-modified next cap instead of the vanilla cap.

If the external trainer transformation is disabled or unavailable, Nuzlocke falls back to its normal authoritative live/vanilla cap source rather than mutating trainer data.


## 29.3.3 economy / rule-lock notes
Trainer Money scales the payout observed from the composed battle result instead of replacing trainer definitions. Permanent Rule Seal freezes Nuzlocke configuration only; compatibility/runtime ledgers remain writable. Forgiveness Token shop price is exposed as compatibility metadata at 1,000,000 so shop integrations do not need to hardcode a second value.


## 2.0.0-beta.29.3.7 — Gold compatibility smoke pass

- Rolled directly from 2.0.0-beta.29.3.4; no repository files added or removed.
- Static smoke audit rechecked Gold-specific capture, nickname, Mart, field-item, catch-tutorial, gift, static, gambling, Whiteout, egg, roamer, and Nuz Status adapters.
- Gold adapters remain generation-scoped and fail-open when an upstream seam is unavailable.
- Route Forgiveness and No Catching remain TEST REQUIRED on Gold pending runtime validation.
- Existing R/B/Y runtime-PASS behavior was not intentionally changed.


## 2.0.0-beta.29.3.11 — Pokemon Bois Club compatibility notes

Type Locke reads the live merged species definition and recognizes the engine's normal `types` array plus common provider schemas (`type`, `type1`/`type2`, and primary/secondary type fields). Optional species-metadata providers are consulted without becoming dependencies. If a custom species has no readable type metadata, legality fails open rather than falsely banning it.

The capture rule is semantic: off-type wild Pokémon are denied before capture and are excluded from Failed Encounter accounting, so they do not consume an area or Route Forgiveness Token. Native gift/trade transactions use the same legality check before mutation where supported. Mandatory starters stay progression-safe.

No Day Care is deliberately generation-specific. R/B/Y wraps the existing hand-ported Day Care conversation only when the Day Care is empty; an already-deposited Pokémon delegates to vanilla withdrawal. Gold wraps `src.core.gen2.Breeding.canDeposit`, which is also called by the native Day Care UI/model, and leaves withdrawal, breeding progress, and pending Egg state untouched.

- Pokemon Bois Club is a Tier 3 World Building cosmetic feature for the Vermilion Fan Club and should not alter story or reward flow.
- The custom Bryan-the-Boi chairman sprite should appear only while World Building is T3; lower tiers should preserve vanilla presentation.
- Type Locke and No Day Care remain carried forward unchanged from 29.3.10.

All 29.3.11 Pokemon Bois Club presentation behavior and the carried 29.3.10 Type Locke/No Day Care behavior are **TEST REQUIRED** until current runtime validation.

## 2.0.0-beta.29.3.9 — Gold-native UI compatibility notes

- World Building remains presentation-only and does not become a new compatibility owner for rule legality.
- Catch-denial presentation is shared between R/B/Y and Gold, reducing duplicate branches while preserving generation-specific battle UI seams.
- Gold World Building uses the same player setting but Johto-specific Tier 3 source text.
- The retired Ball-ban tier/rank runtime machinery was removed; `ball_use_ban_tier` remains read only for migration to the semantic No Catching rule.

## beta.29.3.14
Gold Mart enforcement now uses native Gold Mart entry/transaction seams. Random Starter distinguishes stable per-ball preview from the actual accepted starter transaction. Compatibility API remains 26 in this first split update.

## beta.29.3.15
Compatibility API remains 26. This update changes rule presentation and adds a Gold-only Guide Gent tour-skip wrapper but does not alter the public API contract.

## beta.29.3.16
Compatibility API 27 adds read-only Nuz Info helpers. NUZ INFO reads the merged runtime move registry and does not replace Gold's native Trainer Card lifecycle.

## Randomizer composition — beta.30.0.0.1
Random Encounters and Random Learnsets transform the live merged runtime registries after provider composition. Encounter providers retain rates, levels, maps, time-of-day, fishing/tree, and other metadata. Learnset providers retain species structure and learn levels. GEN2 sourcing never fabricates unavailable Gen 2 moves.

## 2.0.0-beta.30.0.0.2
No Fishing recognizes canonical rods and provider items that semantically identify themselves as fishing/rod items.

## 2.0.0-beta.30.0.0.3
## FAFF0x collection — first-class target
The FAFF0x collection is now a formal compatibility target. 30.0.0.3 establishes generic seams for Modern Bag/Item Shortcut/Repel Reuse item actions, Area DexNav/Summon/quest acquisitions, Pokédex Plus/Moves Manager registry consumers, EXP Share distribution providers, PC replacements, and quest/content providers. This build is the API foundation; per-mod runtime certification remains TEST REQUIRED.

Compatibility rule: prefer capability/provider registration and merged runtime registries over hardcoded mod IDs or vanilla-only tables.

## 2.0.0-beta.30.0.0.4
## FAFF0x QoL integration layer — 30.0.0.4
Targeted seams now cover Modern Bag, Item Shortcut, Repel Reuse, Reusable Machines, EXP Share Modes, Advanced Box, Moves Manager, Pokédex Plus, Area DexNav and Summon behavior classes. This is architectural compatibility, not runtime certification. The design intentionally remains capability-based so equivalent mods from other authors use the same contract.

## 2.0.0-beta.30.0.0.5
## Tracker serialization hardening
Recovery UI state is now strictly separated from persisted tracker records. This also improves compatibility with save editors/providers because live Pokémon tables are never embedded into tracker-log persistence as UI metadata.

## 2.0.0-beta.30.0.0.6
## FAFF0x quest/content layer — 30.0.0.6
The compatibility target now includes quest packs that add maps/dungeons, gifts, scripted or repeatable wild encounters, custom bosses, and story-critical encounters. Providers can describe content semantically; Nuzlocke no longer needs quest-specific hardcoded tables for those classes. Dynamic dungeon metadata feeds Dungeon Lock-In and dynamic areas feed Encounter Tracker. Randomizer preservation is provider-controlled.

## 2.0.0-beta.30.0.0.7
## FAFF0x legacy adapter — 30.0.0.7
The current released FAFF0x collection predates Nuzlocke's provider API. Nuzlocke now performs a conservative active-mod scan and maps recognizable behavior families to generic capabilities. This is a bridge, not a replacement for explicit cooperation. No rule enforcement is keyed directly to a FAFF0x package ID. External Pokémon additions are passively detected and surfaced for acquisition/provenance handling without destructive rollback.

## 2.0.0-beta.30.0.0.8
## Consolidated compatibility contract — 30.0.0.8
Compatibility should be negotiated by capability rather than package name. Explicit provider declarations are authoritative; automatic detection is a fallback for older mods. Multiple mods that provide the same mechanic can coexist in discovery without causing Nuzlocke to duplicate the mechanic. Nuzlocke evaluates legality/policy against the effective action/data rather than replacing another provider's UI or mechanic.

## 2.0.0-beta.30.0.0.9
## Provider-owned duplicate controls
When a provider owns a non-core mechanic, Nuzlocke no longer competes with it. The duplicate Nuzlocke setting becomes effective OFF and read-only while the active provider exists. The UI identifies the preferred provider. Core Nuzlocke challenge policy is intentionally excluded from implicit delegation even when another mod touches the same engine subsystem.

## 2.0.0-beta.30.0.0.11
## Gen1Recomp 0.1.84
The manifest now accepts engine 0.1.84 (`>=0.1.81 <0.1.85`). Upstream 0.1.84 continues to document Mod API 2 as current. This checkpoint does not claim every gameplay hook has been runtime-certified on 0.1.84.

## 2.0.0-beta.30.0.0.12
## Forward compatibility policy
The loader range is now `>=0.1.81 <1.0.0`. This prevents routine 0.x Gen1Recomp version bumps from disabling the entire mod at manifest validation. Mod API 2 remains the contract baseline. Runtime-confirmed versions and merely range-accepted versions must still be distinguished in compatibility claims. Gen1Recomp 1.0 is intentionally excluded until reviewed.

## 2.0.0-beta.30.0.0.13
## Gen1Recomp 0.1.86 title-menu regression
Runtime evidence showed SETUP absent on genuinely fresh Blue and Gold boots. 30.0.0.13 adds generation-specific post-construction fallbacks while preserving the public title hook. Engine range is `>=0.1.86 <0.1.91`. Fresh Blue and Gold are RETEST REQUIRED.

## 2.0.0-beta.30.0.0.14
## 30.0.0.14
Fixes the parser/local-variable-limit regression in 30.0.0.13. The Gen1Recomp 0.1.86 title fallback behavior is unchanged; Blue/Gold fresh-save retesting remains required.

## 2.0.0-beta.30.0.0.15
## First modular compatibility adapter
The 0.1.86 title SETUP fallback was extracted into `title_setup_compat.lua`. Expected impact is title/startup only, but because module loading and callback ownership changed structurally, Blue/Gold startup, Setup selection, existing saves, rules UI, encounters, battles, tracker, randomizers, and provider interoperability remain regression-smoke-test targets until runtime evidence is collected.

## 2.0.0-beta.30.0.0.16
## Compiler-limit compatibility repair
30.0.0.15 was parser-confirmed to exceed Lua's 200-local function limit. The approved trainer-reward module extraction frees substantial main-chunk local capacity. Direct compatibility retests: Trainer Money with alternate wallets/economy mods; Forgiveness Token Bag/Mart bridge and Gym awards; Gym/E4/Champion progression and level-cap reporting. Fresh Blue/Gold SETUP remains RETEST REQUIRED from the first module.

Static parser validation now passes for every Lua source in the package. Runtime validation is still required because the trainer reward subsystem changed module ownership and the late runtime-install block changed lexical scope, even though its logic is intended to remain identical.

Static parser validation passes for every Lua source in the package. Runtime validation is still required because the trainer reward subsystem changed module ownership and the late runtime-install block changed lexical scope, even though its logic is intended to remain identical.

## 2.0.0-beta.30.0.0.17
## Yellow runtime evidence — 30.0.0.16
Existing-save boot, Nuzlocke menu visibility, and opening Nuz Rules passed on Yellow. 30.0.0.17 changes only Permanent Rule Seal activation UX; permanent persistence semantics remain unchanged. Blue/Gold fresh Setup and the modularized trainer-reward paths remain independently RETEST REQUIRED.

## 2.0.0-beta.30.0.0.18
## Gen1Recomp 0.1.86 save/storage composition
Gen1Recomp documents `mod.save` as part of the ordinary progress record, while `mod.storage` is an independent playthrough-scoped persistent API. Permanent Rule Seal now composes both: `mod.save` remains the in-progress state; `mod.storage` provides immediate irreversible durability. Runtime reload testing is required on R/B/Y and Gold.

## 2.0.0-beta.30.0.0.19
## Permanent Rule Seal WIP suspension
The experimental immediate-durability design from `.18` is retained but dormant. This removes an insufficiently validated irreversible feature from normal runtime without discarding its implementation. Existing test markers are preserved but not enforced. No provider, trainer-reward, tracker, randomizer, Gold adapter, or core rule behavior is intentionally changed.

## 2.0.0-beta.30.0.0.20
## TextBox composition — 30.0.0.20
Gen1Recomp's TextBox is a foreground/blocking stack state. Nuzlocke now avoids nesting optional World Building TextBoxes over any active textbox, improving compatibility with vanilla scripts and other mods that own dialogue presentation. This is intentionally fail-open for presentation and does not replace mechanical enforcement.

## 2.0.0-beta.30.0.0.21
## Numeric-rule presentation — 30.0.0.21
Trainer Money percentage labels are centralized so alternate UI/status paths no longer lose the `%` value. Maximum BST keeps its existing actual-threshold enforcement/API semantics while changing only the player selector to a fixed preset ladder. Legacy custom thresholds remain valid until explicitly changed.

## 2.0.0-beta.30.1.0 runtime compatibility evidence

Yellow runtime evidence:
- existing save boot: PASS
- Nuzlocke menus visible: PASS
- Nuz Rules open: PASS
- tested Gym Lock-In boundary rejection: PASS
- specific Poké Mart duplicate-dialogue regression case after active-TextBox guard: PASS

The duplicate-dialogue repair should be treated as a reusable compatibility pattern: optional Nuzlocke dialogue must not interrupt a currently active engine/other-mod TextBox. Similar future defects should first be checked for nested presentation before adding script-specific rewrites.

Unconfirmed paths remain TEST REQUIRED. In particular, do not infer Blue/Gold fresh-game SETUP or every dialogue path from the Yellow results above.

## Gold NEW GAME Setup — 30.1.1

30.1.0 runtime result: CRASH when selecting SETUP on fresh Gold.

Comparison with published 29.1.0 isolated the newer Gold `MainMenu:buildList()` fallback as a post-release delta. 30.1.1 disables that layer while preserving the older shared title hook + `MainMenu:choose()` design that had prior Gold runtime PASS evidence.

This is a surgical rollback of one compatibility adapter, not a wholesale Gold branch restore. Gold NEW GAME -> SETUP remains RETEST REQUIRED.

## 2.0.0-beta.30.1.2 known compatibility issue

### Gold fresh NEW GAME SETUP — RUNTIME FAIL

Observed sequence:
1. Launch Gold with a fresh/new-game context.
2. Nuzlocke SETUP is available.
3. Selecting SETUP crashes.

30.1.1 disabled the newer Gold `MainMenu:buildList()` fallback, but runtime retest still crashed. Therefore that fallback was not sufficient to explain the defect.

Current release position:
- Gold remains BETA/experimental.
- Gold fresh NEW GAME -> SETUP is **known broken**.
- No additional speculative startup rewrite is included in 30.1.2.
- R/B/Y and unrelated Gold gameplay paths are not declared failed by this specific result.

## Setup crash containment — 30.1.3

Current engine `Screens.push()` falls back from a failed mod-owned factory to a built-in screen id. Nuzlocke's configuration screen is custom-only. 30.1.3 protects the whole push so the original construction error can be surfaced without the nonexistent-builtin fallback causing a CTD.

Unsplit 29.3.0 also crashes on this engine, so module splitting is not established as the runtime root cause. Separately, static compilation proves current `main.lua` is at the Lua 200-local ceiling, so future development should reduce top-level local pressure through a deliberate additional module boundary.

## Setup crash phase isolation — 30.1.4

30.1.3's guarded `mod.ui.push` did not intercept the CTD, which makes post-push runtime work the next suspect. 30.1.4 therefore guards the screen's `update` and `draw` methods to distinguish Lua runtime faults from lower-level engine/render failures.

## Gen1Recomp 0.1.86 fresh Setup repair

The current sandbox explicitly denies direct mod access to the legacy filesystem facade. Nuzlocke still used that facade in pre-game Setup profile load/save before opening the configuration screen.

30.1.5 removes that title-time dependency and keeps Setup-profile preferences in session memory instead. This is the first concrete engine incompatibility identified in the fresh Setup CTD path.

## 2.0.0-beta.30.1.6 current-engine validation

The fresh-game Setup crash caused by legacy direct filesystem access is runtime-confirmed repaired on the tested current Gen1Recomp line.

### Runtime PASS

- Gold fresh NEW GAME -> Nuzlocke SETUP.
- Yellow fresh NEW GAME -> Nuzlocke SETUP.
- Blue fresh NEW GAME -> player's bedroom.

The repair removes the forbidden pre-game filesystem dependency and keeps Setup-profile preferences in session memory.

### Remaining compatibility note

Cross-restart pre-game Setup preference persistence is temporarily disabled. Fully restarting the application returns Setup preferences to defaults. Actual save-backed Nuzlocke rules are not intentionally changed by this limitation.

Gold support remains beta/experimental beyond these specifically validated paths.

## Pokegear Cards — 30.1.7

Optional Gold integration targets API v1 and uses active-provider detection with `mod.find`.

Nuzlocke adds one custom card plus append-only MAP/RADIO overlays. It never replaces vanilla Pokégear cards and deliberately does not use PHONE append because the provider documents that path as a native phone-input fork.

Provider absent/disabled/wrong API => clean no-op. R/B/Y do not use the provider. Runtime validation remains required.

## Trainer Money provider ownership — 30.1.8

The provider-delegation UI and runtime behavior are now aligned.

When `economy_provider` resolves to an active external provider:
- Trainer Money is externally owned;
- Nuzlocke does not rescale the trainer payout;
- the delegated UI presents 100% as the neutral value.

When no provider owns the capability, the configured Nuzlocke 0/25/50/75/100/150/200/300/500% scaling behavior remains active.

## Gold boss-cap progression — 30.1.9

The static Johto fallback ladder is monotonic again:

Falkner 9 -> Bugsy 16 -> Whitney 20 -> Morty 25 -> Chuck 30 -> Pryce 31 -> Jasmine 35 -> Clair 40.

Live trainer/provider cap resolution continues to compose on top of these fallback stages. Existing monotonic-floor protection remains in place for trainer-overhaul mods that make an earlier defeated boss stronger than the next boss.

## Save-editor/title compatibility — 30.1.10

R/B/Y and Gold title fallback wrappers no longer assume save-editor state is fixed at installation time. Each recurring title-menu callback re-checks editor state before SETUP insertion.

This avoids leaking Nuzlocke title UI into later editor sessions within the same process.

## Gold Mart / Trainer Rewards module boundary — 30.1.11

Gold Mart integration now respects the split-module boundary introduced for Trainer Rewards. STANDARD Mart stock augmentation queries the qualified Trainer Rewards export rather than a nonexistent global symbol.

The same correction applies to Route Forgiveness token-count presentation.

## Stored catch recovery — 30.1.12

Conflicting stored catch metadata no longer creates a false-success state. If an area is already claimed by a different established catch, the stale location is discarded and the Pokémon remains available for player-assisted Legacy Recovery.

## Solo Only scripted acquisitions — 30.1.13

R/B/Y and Gold NPC trade wrappers already route through the shared special-acquisition policy. With 30.1.13, the shared Solo Only gate now covers both gifts and trades, keeping cross-game scripted acquisitions consistent with wild-catch enforcement.

## First Rival Mercy and reordered battle content — 30.1.14

Compatible mods that reorder or add Rival-classified trainer battles can no longer accidentally burn the First Rival Mercy semaphore merely by presenting a non-opening Rival first.

The stricter opening-battle classifier remains the gate. This preserves old-save protection while allowing the genuine opener to arm later in rewind/checkpoint/reordered-flow edge cases.

## Battle flavor delivery fallback — 30.1.15

World Building eligibility is now consistent across all supported trainer-flavor delivery seams:
- battle `say`;
- battle `emit`;
- generic `pushWorldText` fallback.

A caller's explicit minimum tier is preserved when falling back, which matters on engine/mod battle objects that expose neither `say` nor `emit`.

## Canonical Fairy / typing-mod compatibility — 30.1.16

Nuzlocke Type Locke now understands merged species metadata containing canonical `FAIRY`.

This closes the compatibility gap with STEEL/FAIRY AND TYPING CHARTS 2.0.1 and any other mod that exposes Fairy through normal merged Pokémon/type metadata.

No package-name check is required. Nuzlocke remains the challenge-policy owner and reads the resulting live species typing.

Save compatibility is explicit:
- old `17 = RANDOM` remains `17 = RANDOM`;
- new `18 = FAIRY`;
- no selector migration is performed.

Unknown noncanonical/custom type schemas still use the existing fail-open safety policy.

## Localization / translated Mart compatibility — 30.1.17

R/B/Y No Buying and No Selling no longer assume the rendered Mart labels are English.

Localization mods may translate the normal engine source strings. Nuzlocke compares the live menu rows against the active translated BUY/SELL strings while retaining English fallback recognition.

Verified by mock with Finnish:
- BUY -> OSTA
- SELL -> MYY

No dependency on the Finnish package ID was added; the fix is generic.

## Gen1 Modern UI — 30.1.18

Optional compatibility is implemented against the public `gen1_modern_ui` adapter contract.

Nuzlocke detects an active provider and registers responsive presentation for Tracker, NUZ INFO and Trainer Card/status. It never requires Modern UI and never lets the presenter own challenge mechanics.

The linked Espinas customized release is based on Gen1 Modern UI, but its attached customized ZIP was not available for exact source audit through GitHub's repository API. Runtime verification with that exact archive remains required.

Gold does not register this adapter because the inspected Gen1 Modern UI architecture is Gen1-only.

## PokemonRecompRandomizer — 30.1.19

Optional R/B/Y compatibility uses the provider's public contract-v1 `save.activeRun()` state rather than installation alone. Nuzlocke challenge policy remains authoritative while duplicate randomizer mechanics delegate to the active provider. Provider-owned learnsets are never overwritten by Nuzlocke stale restoration. Arbitrary randomized Oak starters remain mandatory-story safe. Gold does not use this adapter.

Status: static/mock PASS; combined runtime **TEST REQUIRED**.



## beta.30.1.21

- PokemonRecompRandomizer encounter ownership can be surfaced in the tracker without exposing future mappings.
- MOD COMPAT reports effective ownership instead of merely installed mods.
- Species metadata providers may contribute partial semantic metadata; Nuzlocke merges missing live registry facts.
- UI gates prefer semantic ids/actions/values and use translated labels only as fallback.

## 2.1.24 R/B/Y NUZ INFO compatibility
R/B/Y NUZ INFO no longer depends on a custom hand-drawn screen state; it uses Gen1Recomp's mod-facing ListMenu. Gold retains the generation-native page renderer. No compatibility ownership semantics changed.

### Gen1Recomp 0.1.98 startup note (2.3.1)
2.3.0 exposed a Yellow New Game runtime freeze. 2.3.1 therefore keeps 0.1.98 battle/world compatibility additive but avoids instantiating those facades during title/New Game construction. The field-action policy backstop is installed only after `map.entered`.
