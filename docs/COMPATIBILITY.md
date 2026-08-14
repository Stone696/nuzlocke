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
| **Pokemon Snag** | `mistermiracle3036/Pokemon-Snag` | **0.14.11** | Historical Nuzlocke compatibility evidence predates the preserved exact Snag version | 79% | 79% | 79% | 0%* | Nuzlocke exposes `canCapture`; a trainer-capture path that bypasses the normal throw transaction needs cooperative policy use. *Current published Snag release states R/B/Y support. Re-audit 0.14.11 before raising confidence. |
| **Too Many Balls** *(formerly Kanto Balls)* | `mistermiracle3036/Too-Many-Balls` | **0.4.7** | Historical **Kanto Balls** review version not preserved | 82% | 82% | 82% | N/E | The project was renamed/moved while keeping the `kanto_balls` release asset identity. Nuzlocke's historical custom-Ball compatibility evidence predates the preserved exact version, so 0.4.7 does **not** inherit that confidence automatically; re-audit the current release before raising or extending the claim to Gold. |
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
