> **Generation scope:** This document primarily records existing Gen 1/2 engine/provider compatibility and its historical review evidence. Gen 3 has an isolated compatibility path for optional Untamed overworld spawns and recognised shiny providers; consult [Gen 3 overview](GEN3_PORT.md) and [Mod Support in the feature matrix](GEN3_FEATURE_MATRIX.md) instead of applying Gen 1/2 capability-owner settings to Gen 3.

<!-- Current build: 2.9.72 -->
# Nuzlocke Compatibility — 2.9.72


## 2.9.72 focused runtime repairs
Gen-II field-item pickup operands may arrive as numeric cartridge indexes. Nuzlocke now resolves those indexes through the active item registry to canonical IDs before Randomizer policy/persistence and converts the selected item back to the native representation for the pickup builder. Random Shops now exclude the authored item when a legal alternative exists. Random Trainers continue to use the existing `trainer.party` seam; 2.9.72 adds observational boundary tracing rather than requesting a new engine hook. Shiny presentation now recolors private ImageData copies rather than shared engine asset data.

# 2.9.71 — Gen-I Random Field Items seam correction

Yellow runtime testing on Nuzlocke 2.9.70 / Gen1Recomp 0.2.41 showed that visible Random Field Items were not replacing the authored pickup even though the native pickup itself completed. Source review confirmed that Gen1Recomp exposes `world.talk` as the public hook at the A-press boundary before `OverworldController:talkTo` consumes the object's item payload. Nuzlocke 2.9.71 therefore uses `world.talk` as the primary Gen-I visible-field-item composition seam rather than relying on direct method ownership of `OverworldController.talkTo`.

The downstream native handler still owns bag capacity, item removal/taken flags, item-name text, sounds, and retry behavior. Nuzlocke changes only the item payload for the duration of the downstream call and restores the authored object definition afterward. Because `world.talk` exists at the supported 0.2.24+ engine floor, 2.9.71 does not silently fall back to the retired direct `OverworldController.talkTo` wrapper. If the hook facade is unexpectedly unavailable, installation fails closed and Dev diagnostics report the missing pipeline.

This is a focused compatibility/correctness repair. Gen1Recomp remains source-reviewed through 0.2.41, with Mod API 2, Link Protocol 2, Save Format 5, and ROM cache v5. No Nuzlocke Compatibility API, Save Schema, or Randomizer algorithm bump is required. 2.9.71 does not claim Random Field Items Runtime PASS until exact-edition retesting succeeds.

# 2.9.63 — Gen1Recomp 0.2.40 compatibility refresh

Gen1Recomp **0.2.40** is source/documentation reviewed at release commit `0cf543d597ce84e4d847b2aba782f1bf2799fde0`. Mod API remains 2 and upstream Save Format remains 5. The 0.2.40 delta materially revises Gen-I/Gen-II battle presentation and Gen-II party-item/evolution stack handling while preserving the public loader/mod vocabulary. Nuzlocke continues to treat engine pacing and audio timing as **engine-owned**. Focused exact-edition runtime revalidation is required.

The current Gen-II compatibility reference continues to define one shared API vocabulary across generations, with generation-specific availability guarded by the engine. The 0.2.40 release does not identify a HiddenItems contract change that explains the unresolved Gen-II Random Field Items problem; runtime diagnosis remains required. Gen-II party-item/Rare-Candy flows receive focused revalidation because `Game2:usePartyItem` changed materially upstream.

The existing engine range `>=0.2.24 <2.0.0`, Nuzlocke Save Schema 5, Compatibility API 37, and exact-edition runtime-evidence rules are unchanged. Source/documentation review is not Runtime PASS.


## Compatibility evidence classes (2.9.40)

Compatibility diagnostics now keep three evidence facts separate. **Live contract** means a currently loaded external mod publishes a cooperation/compatibility surface; it does not by itself prove that the provider is active, selected, or runtime-certified. **Source reviewed** means Nuzlocke carries a reviewed descriptive adapter/ownership record for that target. **Combined runtime required** means the coexistence claim still requires exact-edition testing of the combined stack before it can be called Runtime PASS. A target may be both source reviewed and combined-runtime-required. Explicit do-not-combine targets remain source-reviewed conflicts rather than runtime-certification targets.

These classes are diagnostic confidence metadata only. They do not grant provider ownership, change rule precedence, or promote standalone runtime evidence to a combined-mod PASS.

## Level Match 0.7.0

**Source/Compatibility Reviewed — Runtime Test Required.** Level Match is a high-overlap Gen-II trainer/wild scaling target. It may alter trainer levels, moves/evolutions and boss roster cardinality, wild levels, and persisted roamer levels. Nuzlocke Random Trainers treats `trainer.party` as a dimensioned composition: it consumes the composed incoming roster, changes species identity only when Nuzlocke owns Random Trainers, and preserves legitimate incoming levels, moves, items and roster cardinality. Level-cap surfaces should observe the effective composed trainer ace where available. Runtime testing is required for Random Trainers, level caps, boss padding, wild scaling and roamers.

## Modern Start Menu UI 0.1.14

**Source/Compatibility Reviewed — Runtime Test Required.** The presentation consumes the final `ui.start_menu.items` composition and preserves supplied callbacks. Nuzlocke's single START action now supplies stable semantic id `nuzlocke.menu`; translated/rendered labels are presentation only and must not be used as the compatibility identity. Nuzlocke does not require or detect Modern Start Menu UI.

## Modern Party UI 0.4.0

The existing reviewed target is retained. Party/Summary/Naming/Relearn presentation may be replaced while the provider/native controller remains authoritative. Nuzlocke enforces challenge legality through semantic/native action seams and does not clone or broadly replace the Party controller.

Compatibility API remains **37**; this build hardens composition contracts without adding a new public API surface.


# 2.9.23 — Gen1Recomp 0.2.38 launcher compatibility refresh

Gen1Recomp **0.2.38** is source/documentation/launcher reviewed at release commit `73d004d47ecf7966c2546d8b475e7007038b29da`; 0.2.37 is represented at `16f30120f5839b05f7317c2ff457f55c7d85e58f`. Mod API remains 2 and upstream Save Format remains 5. The current launcher validates and displays manifests before game load without executing mod entry code, while the real loader remains authoritative at boot. Nuzlocke's existing manifest already supplies the launcher-relevant metadata it needs: `api: 2`, `game_version`, `profile`, `category`, `github`, `games`, `affects_link`, and the `engine_internals` permission. No new launcher permission, dependency, save schema, or gameplay hook is required.

The reviewed launcher can expose GitHub-backed Update/Versions actions for Nuzlocke through the existing `github: Stone696/nuzlocke` field. Compatibility warnings are derived from validated manifest metadata; Nuzlocke therefore keeps its existing `>=0.2.24 <2.0.0` engine range rather than pinning to 0.2.38. Gen-II cartridge save import/export is engine/launcher tooling and does not give Nuzlocke a safe transaction-veto seam or alter Nuzlocke save ownership. Exact-edition runtime smoke remains required.

# Nuzlocke Compatibility — 2.9.28

## 2.9.28 compatibility pass — encounter intent and presentation ownership

Source/Compatibility Reviewed — Runtime Test Required. Gold Next Encounter Spawner 1.2.2 is an explicit Gen-II encounter-transform target. Its public `encounter.species` wrapper intentionally replaces a resolved wild/sweet-scent candidate and consumes one-shot state only after a real wild `battle.started`. Nuzlocke's Random Encounters implementation projects the encounter registry rather than wrapping `encounter.species`, so the reviewed composition is: Nuzlocke/randomizer registry result -> intentional external candidate transform -> ordinary final-species Nuzlocke catch/acquisition legality. Nuzlocke must not repaint an intentionally selected final candidate merely to satisfy its deterministic Randomizer mapping. Exact Gold/Silver/Crystal runtime testing remains required.

Pokeball Colors 0.1.33 is an explicit Gen-I/Gen-II presentation target. It owns ball-toss/heal-machine coloration and now contains its own narrow ownership arbitration with other ball-art mods. Nuzlocke retains semantic catch/ball legality only and does not infer legality from palette/artwork or claim ball-presentation ownership. No Nuzlocke dependency or dedicated ball-color API is required.

Gen1BetterMenus is refreshed from the historical 1.0.3 target to current reviewed 1.0.32. Its dependency-free `isModOptions = true` semantic screen marker is compatible with Nuzlocke's existing options/configuration screens; 2.9.28 preserves those markers and treats self-described screen purpose as preferable to mod-ID/screen-ID recognition. Nuzlocke gameplay legality remains outside replacement Bag/Party/UI presentation.


## 2.9.5 compatibility-registry reconciliation

The compatibility registry, manifest signaling, legacy targets, and explicit exclusions were reconciled as one source/static contract. Manifest presence or load order is discovery/order evidence only, never gameplay ownership. Kanto Ascendant remains explicit conflict/do-not-combine and is intentionally absent from optional dependencies. SHINY_POKEMON remains a compatibility target but is intentionally absent as a reciprocal optional dependency. Dex Overflow and Safari All remain legacy-reviewed until current public source/index evidence is resolved. A read-only Release Safety audit now protects these relationships.

## 2.9.4 acquisition/provenance completeness audit

Acquisition provenance is source-specific rather than inferred from final party state. The audited source families are ordinary wild capture, static capture, roaming capture, starter, gift, in-game trade, fossil, Game Corner prize, egg/Day Care, scripted fixed acquisition, Wonder Trade, Stadium/transfer import, external import, and progression-required acquisition. Unknown imported or save-edited Pokémon remain unverified rather than consuming a guessed encounter slot. Post-mutation receive/trade events are observation/reconciliation seams, not destructive rollback authority. A read-only coverage audit now protects this taxonomy. Combined runtime remains source- and edition-specific.

## 2.9.2 battle-stack ownership audit

The battle stack is split into **combat/stat implementation**, **challenge policy**, **semantic action seams**, **identity/provenance**, and **presentation**. Loading or wrapping a battle engine does not automatically grant ownership of every one of those dimensions.

- **G9 Battle Engine 1.2.3 / `g9-battle-engine-beta` 2.0.2 (Gen II):** remain separate mod ids in one reviewed modern-combat family. Their advertised modern battle-stat/stat-growth dimensions may be external/exclusive; Nuzlocke does not rewrite those internals. Battle lifecycle, held-item behavior, status behavior, and move-category behavior remain observe/compose surfaces until combined runtime proves a stronger contract.
- **Identity DVs:** native Gen-II DVs remain identity-bearing for shiny/gender/Unown/Nuzlocke identity even when an external modern-stat engine owns combat calculations.
- **Nuzlocke challenge policy:** faint/permadeath, No Escape, item legality, party limits, battle finish/whiteout policy, and rule-owned held-item suppression remain semantic policy. They compose at the narrow engine/public seams already used by Nuzlocke rather than by replacing an external combat engine.
- **Trainer parties / EXP:** provider-composed trainer rosters and modern stat growth must not be overwritten merely because Nuzlocke observes the battle. Gen-I-only constructor/Experience interposition remains edition-scoped and is not treated as a G9 integration path.
- **QoL Toggles 1.30.8:** Poison Save precedence remains case-specific: it may not clamp away a Nuzlocke Permadeath field-poison faint. This does not create blanket Nuzlocke-first precedence for unrelated battle behavior.
- **Gen-II party routing:** remains native-owned as established by 2.9.1; battle-stack work must not reintroduce broad PartyMenu/BattleState routing replacement.

No speculative private G9 lifecycle patch was justified by this source/static pass. Combined runtime remains required for fainting, switching, escape, items, held items, battle completion, EXP/stat growth, trainer rosters, status behavior, and modern battle presentation.


## 2.9.3 healing/services ownership audit

Healing is not one ownership surface. Nuzlocke distinguishes **Center service**, **Mom service**, **field-item healing**, **battle-item healing**, **story/script healing**, and **external/post-battle convenience healing**. A provider or overhaul that heals in one dimension does not automatically own the others.

- Gen-II Center/Mom restrictions remain on the semantic `special HealParty` path, with service/map classification deciding whether `No Center Heal` or `No Mom Heal` applies. Unrelated story healing is deliberately left native.
- `No Field Heal` and `No Healing Items` remain item-context policies and are not inferred from service ownership.
- External convenience/overhaul healing may compose for living survivors where that feature owns the service. It may not make a durable `nuzlockeDead` Pokémon usable again; Nuzlocke reasserts death state at its protected lifecycle seams.
- QoL/overhaul detection alone is not permission to intercept every healing event. New service providers should use the public service-ownership/semantic compatibility surface where available.
- This is source/static compatibility evidence. Center/Mom plus external-healing combinations remain exact-edition runtime TEST REQUIRED.

## Current engine baseline

Gen1Recomp **0.2.40** is the current published/source/documentation-reviewed baseline at release commit `0cf543d597ce84e4d847b2aba782f1bf2799fde0`. Nuzlocke accepts `>=0.2.24 <2.0.0`, uses Mod API 2, and records upstream Save Format 4 for 0.2.24 and 5 from 0.2.25 through 0.2.40. The 0.2.36→0.2.38 review includes substantial launcher/save tooling work: launcher-side manifest-only mod inspection, GitHub-backed Update/Versions workflows, compatibility/status derivation, per-game targeting, launch sync/update options, and Gen-II cartridge save import/export. The launcher still does not execute a mod entry chunk before `Game:load`; the real loader remains boot authority. Nuzlocke does not claim ownership of launcher-side save conversion or bypass engine ONLINE policy. Exact-edition runtime smoke remains pending.

## Current ownership model

Compatibility is mechanic-specific. Detection or load order is not ownership. Nuzlocke resolves the narrow capability/method, prefers public provider/hook contracts, and falls back safely when a provider is absent or unhealthy. Presentation-only mods retain presentation ownership without becoming challenge-policy owners.

Randomizer ownership is method-specific across ten methods: Starter, Encounters, Field Items, Learnsets, Trainers, Evolutions, Shops, TM Contents, TM Locations, and Gift Items. TM contents and physical TM locations are separate. Visible/hidden field-item sources may also have different owners.

Bag compatibility similarly separates presentation, pockets, sorting/order, slot count, stack capacity, item-use legality, shop legality, and GameplayTransactions. Nuzlocke never enforces item legality by pocket number or list position.

## Current high-value reviewed targets

- Shiny Pokémon maintained fork 1.2.20 — external shiny generation/presentation owner when healthy; Shiny Clause remains Nuzlocke policy.
- Wilds of Kanto 2.2.0; PokéPC Followers 0.5.1; Followers EX 1.0.19; PotatoVoxel 1.9.6; Dramatic Shape 1.9.0; Battle Art Voxel Fork 1.10.0; Battle Cinematics 1.2.4 — composition/presentation targets with edition-specific runtime certification.
- Pokémon Gen1 Randomizer 0.46.4; Gen2 Randomizer+ 2.9.0; Item Randomizer 1.1.1 — active-feature/method-specific Randomizer delegation.
- Kanto Reforged 1.5.3; QoL Toggles 1.30.8; Delta Type 1.2.0; VanillaPlus 0.3.0; The World 6.54.15; Wonder Trade 1.2.1.
- G9 Battle Engine 1.2.3 and separate `g9-battle-engine-beta` 2.0.2 — invasive Gen-II battle/stat-growth family; combined runtime certification required.
- Useful Bag 2.6.3; Modern Bag UI 0.4.5; Bag Sort 0.1.0 — storage/presentation/order owners, not Nuzlocke legality owners.
- STEEL/FAIRY AND TYPING CHARTS 2.0.1; expanded-species/provider targets consume the final merged live type/species graph where stable.

Special status:
- **Kanto Ascendant 6.5.17:** explicit upstream conflict; do not advertise or certify coexistence with standalone Nuzlocke.
- **Dex Overflow 0.1.1** and **Safari All 1.1.0:** legacy reviewed/current source unresolved; no newer version is invented.
- **Wonder Trade:** post-mutation observe/reconcile only; Wonderlocke remains WIP/disabled.
- **SHINY_POKEMON:** explicit target but intentionally not a reciprocal optional dependency because the maintained fork already declares Nuzlocke optional.

## Current known runtime debt

Gen-II Random Trainers and Gen-II Random Field Items remain tester Runtime FAIL/unresolved. Crystal shiny native presentation and the 0.2.40 exact-edition engine smoke also remain pending. Other combined-mod targets retain the confidence stated in `docs/FEATURE_CONFIDENCE.md`; source review is not Runtime PASS.

---

## Historical compatibility notes

The material below records earlier audits in their original version context. Statements such as “current” or “unsupported” inside a historical section describe that historical build and do not override the authoritative 2.9.2 contract above.

# 2.8.98 — Gen1Recomp 0.2.36 compatibility refresh

Gen1Recomp **0.2.36** is the current published/source-reviewed baseline (release commit `fc56b9b05f01c559610c71f801355abfa4ae920f`). Review of the 0.2.33→0.2.36 forward delta found the newest release work concentrated in ONLINE tournament, spectator, team-selection, and remote-trade lifecycle/UI paths. Nuzlocke does not bypass engine ONLINE content-mod policy and does not infer new gameplay ownership from those paths. Mod API remains 2, upstream Save Format remains 5, and Nuzlocke's engine range remains `>=0.2.24 <2.0.0`. Exact-edition runtime smoke is still required.

# 2.8.97 Gen-II Random Field Item source audit

Gen1Recomp 0.2.33 retains `HiddenItems.ballPickupScript` and `HiddenItems.pickupScript` with signatures matching Nuzlocke's visible/hidden wrappers. No basic upstream seam gap was found. Nuzlocke adds observational decision/script evidence while preserving method-specific ownership; runtime reproduction remains required.

# 2.8.89 Gen-II Random Trainer source audit

Gen1Recomp 0.2.33 continues to expose `trainer.party` on Gen II with shared semantics. Nuzlocke therefore retains its existing semantic hook/native-Mon composition and adds observational accepted-roster evidence rather than declaring an upstream capability gap. Runtime reproduction is still required.

# Nuzlocke Compatibility — 2.8.88

## 2.8.88 method-specific Randomizer ownership

Randomizer ownership is now evaluated at the actual method/source seam where needed. `Random TMs` is TM-content ownership; `Random TM Locations` is physical TM-pickup ownership. These are independent. Item Randomizer visible and hidden Gen-II controls own only their corresponding pickup source class, and Pokémon Gen 1 Randomizer item/hidden/TM-location settings are mapped to their matching location methods rather than suppressing unrelated Nuzlocke Randomizer controls. Gen 2 Randomizer+ `randomTMs` remains TM-content ownership because its current implementation projects TM assignments and compatibility.

The 2.8.87 ownership metadata did not by itself suppress the collection-time Field Item transform; 2.8.88 closes that execution gap. Combined-mod runtime testing remains required.

---

## Current Gen1Recomp compatibility status

Historical 2.8.86 note: Gen1Recomp 0.2.33 was the latest published compatibility profile reviewed by that release. The 0.2.33 release commit is still the current gameplay/API baseline; the post-release `main` movement reviewed for 2.8.86 is packaging metadata only, and the protected `dev` branch is behind/diverged from the release line rather than a newer forward engine baseline. Engine range remains `>=0.2.24 <2.0.0`, Mod API remains 2, and the upstream engine Save Format is recorded as 4 for 0.2.24 and 5 for 0.2.25–0.2.33. Protected Gen II battle, item, save, and script compatibility remains unchanged.

The Gen-I `pokemon.level_visible` hook is available but not owned by Nuzlocke. It is a future Blind Levels/No Level Info opportunity and is separate from Randomizer BLIND INFO. Gen II save import/export, Pokedex registry, and MenuRepeat/transition work are likewise recorded as future opportunities, not active adapters.

Gen1Recomp 0.2.33's ONLINE arena intentionally disables ordinary content mods through the loader's `disableAll`/`cartOnly` policies. Nuzlocke does not bypass that restriction. Ordinary modded or LAN link sessions remain declared with `affects_link=true`.

The narrow Crystal shiny-flash safety retains its non-ownership boundary. No new 0.2.30–0.2.33 runtime certification is claimed. Gen2 Random Field Items and Random Trainers remain unresolved runtime failures; Crystal shiny exact-runtime evidence and engine smoke tests remain pending.

---


## 2.8.87 external Randomizer code audit

| Target | Reviewed baseline | Active ownership recognized by Nuzlocke | Confidence |
| --- | --- | --- | --- |
| `pokemon_randomizer` | published 0.46.4 | Starter, wild encounter tables, ordinary/hidden field-item locations, TM locations, learnsets, trainer species, evolutions, shops | Source/API reviewed; combined runtime required |
| `gen_2_randomizer_plus` | published 2.9.0 | Starter, wild Pokémon, world items, learnsets, trainer species, TM contents | Source/settings reviewed; combined runtime required |
| `item_randomizer` | 1.1.1 | Gen-I visible pickups; Gen-II item balls and native hidden/Itemfinder finds | Source/options reviewed; combined runtime required |

The Gen 2 Randomizer+ 2.9.0 release explicitly advertises Gold/Silver support, while the tagged source manifest still reports version 2.5.0 with Gold-only scope. Nuzlocke therefore does not use that stale source-manifest version as the ownership gate; it resolves the stable mod id and source-confirmed live option bucket.

External Randomizer ownership is subsystem-specific and active-state based. Merely installing any of these mods leaves the corresponding Nuzlocke Randomizer control available.

---

## 2.8.86 engine + UI freshness audit

| Target | Current reviewed baseline | Status / ownership | Runtime status |
| --- | --- | --- | --- |
| Gen1Recomp | 0.2.33 | Historical 2.8.86 engine baseline; superseded by the authoritative 2.9.2 / 0.2.36 section above | 0.2.30–0.2.33 exact-edition smoke was still required |
| `gen1_modern_ui` | 0.9.2 | Retired/frozen Gen-I presentation target; released `registerAdapter` contract remains available; conflicts with successor `gen1_clean_ui` | Combined runtime retest required |
| `modern_party_ui` | 0.4.0 | Active Gen-I party/summary presentation owner; source callbacks/controllers remain authoritative for actions such as rename/relearn/item/party flows | Combined runtime retest required |
| `wide-menus` | 0.3.0 | Active Gen-I/Gen-II layout target; Nuzlocke current `register`/`size` integration still matches the documented export contract | Combined runtime retest required |
| `variable_width_kerning` | legacy identity / current upstream unresolved | Passive typography coexistence only; Nuzlocke consumes live `Font` measurement and does not own glyph advances/kerning | No current-version claim |
| Clean UI successor family | watch only | `clean-ui-core` is shared non-installable source with Clean UI API V3 architecture; it is not a Nuzlocke dependency/target until a concrete installable product manifest is available | Not a runtime target |

The freshness audit deliberately separates **current release**, **retired legacy target**, **active target**, **unresolved legacy identity**, and **successor watch**. A source repository or architecture project is not promoted to a manifest dependency merely because it supersedes an older UI project.

---

## Explicit compatibility target registry — 2.8.86

2.8.86 continues to treat compatibility targets as an additive registry. Shared targets from the maintained Shiny fork are added where relevant, but they do not replace stronger/newer Nuzlocke audits or Nuzlocke-specific adapters. A target declaration means "reviewed/expected to compose under the documented ownership contract"; it does **not** mean an exact-edition combined runtime PASS.

### Shared Shiny-ecosystem targets

| Target | Reviewed target | Scope | Nuzlocke ownership/composition | Confidence |
| --- | --- | --- | --- | --- |
| `SHINY_POKEMON` | Stone696 maintained fork 1.2.20 | R/B/Y/G/S/C | External shiny generation/presentation owner when its provider contract is healthy; Nuzlocke retains Shiny Clause, legality, tracking, Catch Info, and Run History | Source/contract target; combined runtime certification edition-specific |
| `overworld_wild_spawns` | Nuzlocke audit 2.2.0 | current reviewed Wilds scope | Wilds owns its spawn/capture transaction surface; Nuzlocke composes capture legality/provenance | Nuzlocke's 2.2.0 audit retained; Shiny 1.2.20's 2.1.9 marker is older |
| `PokePCFollowers_VoxelMerge` | 0.5.1 | R/B/Y | External follower sprite/presentation owner; Nuzlocke observes party/Pokémon identity and does not own follower render/movement | Source/coexistence target; runtime combination required |
| `FOLLOWERS_EX` | 1.0.19 | R/B/Y | External trainer/Pokémon control and pack/trailer presentation owner; Nuzlocke retains encounter legality/provenance and challenge policy | Source/coexistence target; runtime combination required |
| `DRAMATIC_SHAPE` | 1.9.0 | R/B/Y | External 3D diorama/voxel presentation owner; Nuzlocke retains challenge rules, encounter/capture legality, progression, tracker state and gameplay transactions | Historical Shiny-ecosystem coexistence target; source identity verified; combined runtime required |

Current voxel compatibility treats `DRAMATIC_SHAPE`, `BATTLE_ART_VOXEL_FORK`, `DRAMALESS_SHAPE`, `potato_voxel`, `TERRARIUM`, and `VOXEL_ASCENDANT` as distinct renderer identities with separate ownership/conflict behavior rather than interchangeable aliases. Nuzlocke yields renderer/camera presentation ownership while retaining challenge legality and state.

The maintained Shiny 1.2.20 compatibility layer keeps public API v1 and explicit integration contracts for Nuzlocke, Wilds, PokéPC/follower integration, and Followers EX/shared follower rendering. The maintained fork's inherited voxel integration history also explicitly targets Dramatic Shape; Nuzlocke now carries that target forward separately as a presentation-coexistence contract. Nuzlocke consumes only the surfaces it needs and does not mirror Shiny's implementation internals.

### Existing Nuzlocke-specific reviewed targets retained

The following reviewed targets remain additive to the shared Shiny ecosystem targets:

- Indigo Conference 1.1.0
- Kanto Ascendant 6.5.17 — **explicit current conflict / do not combine**; Ascendant includes its own ASC RUN Nuzlocke system and declares standalone `nuzlocke` conflicting
- Kanto Reforged 1.5.3
- Delta Type 1.2.0
- Dex Overflow 0.1.1
- Safari All 1.1.0 — legacy reviewed target; not present in the current public mod-index snapshot, so no newer version is claimed
- Wonder Trade 1.2.1
- QOL Toggles 1.30.8
- VanillaPlus 0.3.0
- The World 6.54.15
- PotatoVoxel 1.9.6
- Dramatic Shape Voxel Mod 1.9.0 (`DRAMATIC_SHAPE`)
- Gen1 Better Menus 1.0.3
- Quality of Life / Easy Interactions 1.3.0
- G9 Battle Engine published target 1.2.3; current combat-only source line `g9-battle-engine-beta` 2.0.2
- STEEL/FAIRY AND TYPING CHARTS 2.0.1 (`steel_typing`)
- the existing Randomizer, UI, metadata, Stadium/Crystal-251, translation, and provider identities already documented in this file and declared through the manifest/provider contracts.

The translation target registry remains separately normalized below because it carries language/edition/overlay/legacy roles and LOCAL CERT requirements.

### Dependency direction

All shared Shiny-ecosystem integrations remain optional companions, but **targeting is not the same thing as declaring a manifest dependency**. Maintained Shiny 1.2.20 already declares `nuzlocke` as an optional dependency, so Nuzlocke intentionally does **not** declare `SHINY_POKEMON` back; current Gen1Recomp rejects dependency cycles. Shiny therefore loads after Nuzlocke and can register its provider/API into the already-loaded Nuzlocke surface. `FOLLOWERS_EX` requires PokéPC Followers + Wilds and optionally depends on Shiny. Nuzlocke declares PokéPC and Followers EX as optional load-order targets because neither creates a reciprocal Nuzlocke cycle. Dramatic Shape remains an explicit compatibility target only and is intentionally not added as a manifest dependency, matching the Shiny integration's historical dependency model. No new hard dependency or conflict is introduced.

---

# Run History v2 diagnostic compatibility — 2.8.70

Stored-state diagnostics now compare the persisted Run History root against the module's current `storage_version` instead of a stale literal v1 expectation. This prevents valid Run History v2 saves from incorrectly failing the hard `stored_nonrule_state` Release Safety gate.

No external compatibility contract or translation target changed in this build.

---

# Translation registry consolidation — 2.8.69

The translation source-discovery phase is now considered complete for the currently known public Gen1Recomp ecosystem. 2.8.69 reconciles the runtime companion registry, dependency ordering, compatibility matrix, and reviewed non-runtime classifications before exact LOCAL CERT testing begins.

## Normalized runtime target classes

Known companions now use explicit role metadata:

- `current_primary` — preferred current target for its language/scope.
- `current_alternate` — distinct current alternate with its own runtime identity.
- `current_overlay` — current companion overlay requiring a base translation.
- `legacy` — historical identity retained for compatibility/history but not eligible for new certification.
- `legacy_alternate` — installable alternate/beta retained for history and source compatibility, but not a current certification target.

`certificationEligible` is diagnostic compatibility metadata. It does not enable/disable a mod and does not alter gameplay.

## Consolidated current runtime targets

| Language / role | Runtime ID | Reviewed version | Reviewed editions | Role | Focus |
| --- | --- | --- | --- | --- | --- |
| Brazilian Portuguese | `versaovermelha` | 0.2.5 | existing reviewed scope | primary | presentation / exact runtime pending |
| German | `translation-german-universal` | 0.2.0 | R/B/Y/G/S/C | primary | toggle-aware presentation |
| Spanish | `traduccion_es` | 0.1.0 | R/B | primary | cartridge-derived content |
| Spanish alternate | `spanish_translation` | 0.1.0 | Red | alternate | battle UI + loaded replacement scripts |
| French | `translation-fr` | 0.8.0 | R/B/Y/G/S/C | primary | generated content |
| French overlay | `trad-fr-extended` | 0.2.0 | follows `translation-fr` | overlay | gap-filling companion |
| Japanese | `translation-ja-hrkt` | 0.4.2 | R/B | primary | TTF / kana / engine gaps |
| Italian | `translation-it` | 0.6.0 | R/B/Y | primary | proportional font + replacement scripts |
| Polish | `recomp-polish` | 1.0.0 | Red | primary | extended Latin; handler load unconfirmed |
| Simplified Chinese | `zh_cn` | 0.3.1 | R/B/Y | primary | fixed-cell CJK + presentation wrappers |
| Dutch | `translation-nl` | 0.0.2 | R/B | primary | loaded replacement scripts |
| Finnish | `finnish` | 0.1.0 | Red | primary | presentation overrides + loaded replacement scripts |

Legacy entries retained but not current certification targets:

- `gen1_pt-br` 0.1.5 — legacy Brazilian Portuguese identity.
- `recomp-italian` 0.1.0 — alternate/legacy Italian beta with incompletely documented edition scope.

## Dependency-order reconciliation

The manifest optional-dependency ordering is reconciled with known runtime companions. In particular, `finnish` is now explicitly included after `translation-nl`; its omission after the 2.8.67 registry promotion was a metadata/load-order oversight, not a gameplay defect.

## Reviewed but not runtime companions

The following repositories were reviewed during discovery and are deliberately excluded from runtime companion detection and optional dependency ordering:

- `yyoossk/Gen1Recomp-translation-jp-mod` — **placeholder/incomplete**; README-only repository with no manifest, entry point, stable mod ID, version, or installable implementation.
- `ShiraTheMogul/gen1recomp-lzh` — **engine fork / alternate distribution**; translation ships with engine/gameplay changes and requires a separate engine-fork compatibility audit.
- `zhangjiyz/gen1recomp-translation-mod-generator-cn` — **tooling/generator**; not itself a stable runtime translation companion.
- `nevespt/VersaoEncarnada` — **fork/variant of existing Brazilian identity**; shares the `versaovermelha` runtime identity and is not a separate language target.

Final targeted discovery also found no concrete current runtime repository for Korean, Traditional Chinese, European Portuguese, Russian, Czech, Swedish, Turkish, or Greek. This is a discovery result, not a claim that such projects can never appear later.

## Certification boundary

Source/static compatibility remains distinct from runtime evidence. None of the consolidation metadata upgrades a translation to Runtime PASS. Exact edition + exact companion/version combinations still require LOCAL CERT, plus any companion-specific mutation/presentation focus checks already recorded in this document.

---

# Alternate Spanish compatibility — 2.8.68

## Target

- Mod ID: `spanish_translation`
- Name: **Edicion Roja (Traduccion Español)**
- Reviewed version: **0.1.0**
- Scope: **Red**
- Lineage: fork of `bryanthaboi/versaovermelha`
- Spanish source text: `einstein95/pokered-es`

This remains distinct from the existing primary `traduccion_es` target because the mod ID, lineage, runtime architecture and edition scope differ.

The reviewed runtime directly overrides BattleState text/menu/move-selection presentation and explicitly loads `lang/literal_handlers.lua`.

Those handlers include Museum payment and Bike Voucher → Bicycle mutations, so the existing `translation_presentation_wrapper` and `translation_replacement_script_mutation` contracts apply.

Runtime focus: standard LOCAL CERT plus battle UI, Museum payment, and Bike Voucher/Bicycle exchange.

No Runtime PASS is claimed by this source audit.

---

# Finnish translation compatibility — 2.8.67

## Current target

- Mod ID: `finnish`
- Name: **Suomi**
- Reviewed version: **0.1.0**
- Current reviewed scope: **Red only**
- Engine range: `>=0.0.0-dev <1.0.0`
- Permissions: `engine_internals`

The current upstream project documents itself as a Finnish translation of Pokémon Red, so Nuzlocke keeps the edition scope conservative rather than inferring Blue/Yellow support.

## Coverage / fallback model

The reviewed upstream documentation reports:

- dialogue: 2642 / 2645 translated;
- engine strings: 639 / 703;
- all 165 Gen-I moves;
- 72 named items;
- 32 trainer classes.

Species names, status abbreviations, route/location names, badge names, named trainers and selected branding terms intentionally remain English. Mixed Finnish/English presentation is therefore expected upstream behavior.

## Font / naming

Finnish adds a fixed-cell 8x8 extended-Latin glyph page at `0x100` for ä/ö/å and uppercase variants, with UTF-8 charmap registration. The naming grid replaces little-used Q/X/W cells with Finnish accented letters.

Nuzlocke's generalized glyph-safe localization boundary remains appropriate.

## Presentation ownership

The reviewed mod directly adapts several engine-owned UI surfaces for Finnish text length, including:

- global YES/NO choice-box geometry;
- BattleState text/menu/move-select rendering;
- level-up stat box;
- bindings capture box;
- Bill's PC box overlay;
- ListMenu layout;
- Move Learn menu;
- Trainer Card.

These are treated under Nuzlocke's existing `translation_presentation_wrapper` contract: presentation ownership may alter layout, but cannot become gameplay-policy ownership or a dependency for Nuzlocke-owned UI.

## Replacement scripts

Finnish explicitly reads and executes `lang/literal_handlers.lua`.

Those handlers include rule-sensitive mutations such as:

- museum payment: subtract ¥50 and set the museum ticket flag;
- Bike Shop voucher exchange: remove BIKE VOUCHER, add BICYCLE, set `EVENT_GOT_BICYCLE`.

Therefore Finnish is recorded as:

- replacement scripts present: yes;
- replacement scripts active/loaded: yes;
- mutation review required: yes.

The existing generalized `translation_replacement_script_mutation` contract applies; no Finnish-specific gameplay workaround is added.

## Runtime certification emphasis

Use standard LOCAL CERT plus focused checks for:

1. choice-box width;
2. battle UI layout;
3. level-up stat box;
4. bindings capture box;
5. Bill's PC box overlay;
6. Move Learn layout;
7. Trainer Card layout;
8. museum payment replacement handler;
9. Bike Voucher/Bicycle replacement handler.

No Runtime PASS is claimed by this source audit.

---

# Dutch translation compatibility — 2.8.66

## Current target

- Mod ID: `translation-nl`
- Name: **Dutch translation**
- Reviewed version: **0.0.2**
- Current reviewed scope: **Red / Blue**
- Upstream generator/runtime: `BartInTheField/gen1recomp-dutch-generator`
- Upstream engine range emitted by the generator: `>=0.0.0-dev`

The repository publishes a ready-to-import `translation-nl-0.0.2.zip`, so this is a concrete runtime target rather than tooling-only infrastructure.

## Coverage / fallback model

The reviewed release reports:

- ROM catalog: **3106/3106**
- RBY-related engine strings: **285/383**
- all engine strings: **290/533**

No official Dutch donor ROM/font exists in this project. Localized-font extraction is skipped, accents are ASCII-folded, several proper-name/name catalogs intentionally remain English, and untranslated engine/UI text falls back to English.

Mixed Dutch/English presentation is therefore expected and is not itself a Nuzlocke compatibility failure.

## Replacement scripts

The generated Dutch runtime explicitly reads and executes `lang/literal_handlers.lua` when present.

The reviewed handler recipes include rule-sensitive gameplay mutations such as:

- Museum payment: subtract $50 and set the museum ticket flag;
- Bike Shop voucher exchange: remove BIKE VOUCHER, grant BICYCLE, and set the bicycle event flag.

This makes Dutch stronger evidence for the generalized `translation_replacement_script_mutation` rule introduced in 2.8.63.

Unlike Polish, runtime loading is **confirmed by the generated main.lua architecture**. Nuzlocke therefore records:

- replacement scripts present: yes;
- replacement scripts active/loaded by generated runtime: yes;
- mutation review required: yes.

## Runtime certification emphasis

Use the standard LOCAL CERT checklist plus focused checks for:

1. Museum payment replacement handler.
2. Bike Voucher → Bicycle replacement handler.
3. Mixed Dutch/English fallback presentation.

A full Dutch compatibility claim requires confirming that loaded translated replacement handlers do not bypass enabled Nuzlocke restrictions.

No Dutch-specific gameplay branches are added.

---

# Simplified Chinese compatibility — 2.8.65

## Primary target

- Mod ID: `zh_cn`
- Name: **ZH-CN / Simplified Chinese (Mainland)**
- Reviewed version: **0.3.1**
- Reviewed edition scope: **Red / Blue / Yellow**
- Upstream engine range: `>=0.1.56 <1.0.0`
- Architecture: content catalogs + fixed-cell CJK glyph pages + narrowly-scoped engine-gap presentation wrappers.

The current upstream release reports full local text-key coverage for all three supported editions, 607 interface-string checks, New Game smoke tests on Red/Blue/Yellow, and a reproducible 1,995-glyph / eight-page font build. Nuzlocke does not convert that upstream smoke evidence into Nuzlocke Runtime PASS; exact-combination certification is still required.

## Text model

`zh_cn` registers eight custom glyph pages beginning at codepoint `0x100`, each using 8x8 cells and 8px advance. UTF-8 byte count, glyph count, and rendered width must therefore remain distinct concepts even though visible CJK glyphs are fixed-cell.

Nuzlocke's generalized glyph-span / UTF-8-safe fitting remains authoritative for Nuzlocke-owned UI.

## Presentation wrappers

The reviewed Chinese target uses several narrow compatibility overlays for engine strings that older Gen1Recomp paths do not route through normal registries:

- `script.command` for verified dynamic starter/gift Pokémon and badge substitutions;
- `ui.naming.grid`;
- `ui.options.rows`;
- `Strings.get` for exact stat-argument positions;
- `Font.draw` for exact caller/source/coordinate-specific stat/status labels;
- `OptionRows.draw` for the raw CANCEL footer.

These are treated as translation/presentation ownership, not Nuzlocke gameplay ownership.

## Generalized presentation-wrapper rule

Translation-owned `Strings`, `Font`, or UI wrappers must be:

1. **narrowly scoped** to known presentation gaps;
2. **compositional**, delegating to `next()` or the wrapped original behavior;
3. **identity-safe** for arbitrary player text such as nicknames;
4. **non-authoritative for gameplay**; display translation may not change rule decisions;
5. **non-required by Nuzlocke-owned UI**. Nuzlocke-owned screens must use their own `Strings(...)`, canonical semantic state, and generalized glyph-safe fitting rather than depending on a translation mod's caller-path or fixed-coordinate heuristics.

This rule is represented by the semantic compatibility seam `translation_presentation_wrapper`.

## Runtime certification emphasis

Use the standard LOCAL CERT ten-surface checklist plus focused observation of:

- stat/status labels;
- starter and gift Pokémon dynamic names;
- badge substitutions;
- Options footer;
- Party/Summary status labels;
- mixed CJK + numeric alignment.

Dev localization diagnostics expose these as companion-specific certification focus notes.

## Other Chinese projects

### Literary Chinese: `ShiraTheMogul/gen1recomp-lzh`

This is an **engine fork / alternate distribution**, not a normal Mod API translation companion. It changes engine/game behavior in addition to translation, including trade-evolution availability, outsider nickname handling, a Cangjie IME, and alternate Pokédex measurement presentation.

Do **not** add it to the normal known-companion registry. Supporting it requires a separate engine-fork compatibility audit against Nuzlocke's current Gen1Recomp engine assumptions.

### `gen1recomp-translation-mod-generator-cn`

The reviewed repository is tooling/generator work, not itself a runtime Chinese translation companion. Do not add it to the runtime compatibility matrix unless it produces a concrete installable Chinese mod artifact with a stable mod ID/version.

---

# Polish translation compatibility — 2.8.64

## Current target

- Mod ID: `recomp-polish`
- Name: **POKéMON Edycja Czerwona PL**
- Reviewed version: **1.0.0**
- Current Nuzlocke scope: **Red only**, conservatively derived from the upstream identity/documentation.
- Upstream manifest profile: content; category is labelled GAMEPLAY, but the reviewed implementation is primarily translation/content registration.

## Architecture

The reviewed implementation loads translation catalogs and applies them through normal Gen1Recomp content surfaces for dialogue, strings, species, moves, items, trainers, statuses, Pokédex category text, and an optional naming-grid wrapper.

Polish diacritics use an added fixed-cell Latin glyph page at codepoints `0x100+` plus explicit UTF-8 charmap entries for Polish letters. Nuzlocke therefore continues to treat byte length, glyph count, and rendered width as separate concepts.

Empty translation entries intentionally fall back to English. Mixed Polish/English presentation is valid upstream behavior and is not by itself a Nuzlocke compatibility failure.

## Replacement-script review

The repository contains generated `lang/literal_handlers.lua` handlers that reproduce gameplay mutations such as museum payment/flag changes and Bike Voucher → Bicycle inventory/flag changes.

The current source audit confirms those handlers **exist**, but did not establish that the released 1.0.0 `main.lua` actually loads/registers them. Nuzlocke therefore records:

- replacement scripts present: **yes**;
- runtime loading: **unconfirmed**;
- mutation review required: **yes**.

The generalized `translation_replacement_script_mutation` policy introduced in 2.8.63 applies if those handlers are active. No Polish-specific gameplay branch is added.

## Runtime focus

When runtime certification begins, test:

1. Red + `recomp-polish` 1.0.0 standard LOCAL CERT checklist.
2. Polish glyphs/diacritics in NUZ STATUS, rules, tracker and Dev Report.
3. Naming-grid behavior if enabled by the translation.
4. Museum payment and Bike Shop voucher exchange specifically to determine whether replacement handlers are active.
5. If active, verify Nuzlocke policy is not bypassed by translated replacement scripts.

No Runtime PASS is claimed by this source audit.

---

# Italian translation compatibility — 2.8.63

## Primary target: `translation-it` 0.6.0

The current primary Italian target is `translation-it` 0.6.0, reviewed for Red, Blue and Yellow. It is generated from the community translation pipeline and uses a proportional Fusion Pixel TTF plus several presentation/runtime wrappers.

Important compatibility seams include localized type-name wrapping through `Font.split`/`Font.draw`, temporary Options Menu font wrappers, a demo-battle name wrapper, and generated `literal_handlers.lua` map-script replacements.

Those literal handlers can reproduce vanilla gameplay mutations directly, including money changes, event flags and inventory awards. Therefore translation-owned replacement scripts are not assumed to be presentation-only.

## Alternate target: `recomp-italian` 0.1.0

`recomp-italian` 0.1.0 is retained as a distinct alternate/legacy beta target. Its reviewed architecture is simpler content override + custom glyph/charmap registration, and its upstream edition scope is not documented precisely enough for Nuzlocke to certify beyond source compatibility.

## Replacement-script mutation rule

A translation/content mod may replace a vanilla map script to translate dialogue, but if that replacement also performs gameplay mutation it must preserve the same Nuzlocke semantic policy boundary as the native interaction.

This includes purchases, sales, gifts, trades, inventory awards, healing/services, gambling, Day Care, held-item changes, and other rule-sensitive mutations.

Acceptable integration paths are:

1. preserve the native Nuzlocke-gated entrypoint; or
2. call the relevant Nuzlocke semantic policy before committing the mutation.

A translated script must not bypass a Nuzlocke restriction merely because it reimplemented the vanilla interaction.

For `translation-it`, runtime certification should specifically exercise museum/payment, Bike Shop/inventory award, and any other generated literal-handler seams that overlap enabled Nuzlocke restrictions.

---

# Localization runtime certification tooling — 2.8.62

The compatibility matrix distinguishes source/static review from exact runtime evidence. 2.8.62 adds a manual Dev Mode checklist to make that exact runtime evidence reproducible.

Certification identity includes the active edition and detected translation companion IDs/versions plus available activity/language/restart state. Changing that combination creates a separate session ledger.

No check is auto-passed. Static source compatibility, clean System Health, or translation detection alone cannot create runtime certification.

The checklist covers the ten surfaces currently considered the minimum localization certification set: setup/rules, status/tracker, battle denial, mart denial, party/info, Move Learn/Rare Candy, Forgiveness, Randomizer, World Building, and Dev localization reporting.

Session-only results may be copied into release/compatibility evidence after human runtime verification. They are not persisted into gameplay saves.

---

# Japanese/CJK UI audit follow-up — 2.8.61

The 2.8.60 Japanese audit exposed a useful code-quality question: whether any Nuzlocke-owned UI still equated Lua byte length with visible glyph count.

2.8.61 audits the owned UI surfaces and removes the remaining player-facing instances found in classic/recovery/status/Pokegear code. Shared glyph segmentation is now reused across split modules, with engine `Font.split` preferred and UTF-8-safe fallback.

Fixed-width byte formatting remains permitted for internal ASCII-only diagnostics/identifiers and numeric columns where no localized text is involved.

The optional Pokegear Cards surface also now translates its authored labels through the same injected translation function used by the rest of its integration.

---

# Translation compatibility matrix — 2.8.59

This matrix reconciles the current known-companion registry with the latest reviewed translation work. **Reviewed** means source/architecture compatibility was audited at the listed version. **Runtime-certified** is stricter and is only granted after exact game + exact mod-version testing.

| Identity | Reviewed version | Role | Reviewed edition scope | Current status | Runtime certification |
| --- | --- | --- | --- | --- | --- |
| `gen1_pt-br` | 0.1.5 | Legacy Brazilian Portuguese localization | Historical target; current upstream scope unverified | Legacy / upstream unverified | Not current-certified |
| `versaovermelha` | 0.2.5 | Brazilian Portuguese localization + presentation | Explicit current Brazilian target; exact edition runtime matrix still pending | Current target | Static/source compatible; runtime matrix pending |
| `translation-german-universal` | 0.2.0 | German localization + presentation | Red / Blue / Yellow / Gold / Silver / Crystal | Current target | Static/source compatible; runtime matrix pending |
| `traduccion_es` | 0.1.0 | Spanish localization + optional cartridge-derived content | Red / Blue full reviewed cartridge layer; Yellow has no reviewed Spanish cartridge spec | Current target | Static/source compatible; exact runtime pending |
| `spanish_translation` | 0.1.0 | Alternate Spanish Red fork with battle UI override + loaded literal handlers | Red | Alternate Spanish target | Static/source compatible; focused runtime pending |
| `translation-fr` | generator 0.8.0 | Generated French localization/content | Red / Blue / Yellow / Gold / Silver / Crystal | Current base French target | Static/source compatible; runtime matrix pending |
| `trad-fr-extended` | 0.2.0 | French gap-filling overlay | Requires `translation-fr`; applies where the base translation runs | Current overlay target | Static/source compatible; runtime matrix pending |
| `translation-ja-hrkt` | 0.4.2 | Japanese generated localization + engine Plain Pixel TTF | Red / Blue | Current Japanese target | Static/source compatible; runtime matrix pending |
| `translation-it` | 0.6.0 | Primary Italian generated localization + presentation/runtime wrappers | Red / Blue / Yellow | Current primary Italian target | Static/source compatible; runtime matrix pending |
| `recomp-italian` | 0.1.0 | Alternate Italian beta content/glyph translation | Upstream edition scope not explicitly documented | Alternate / legacy beta target | Not current-certified |
| `recomp-polish` | 1.0.0 | Polish content translation + custom fixed-cell glyph page | Red (conservative reviewed scope) | Current Polish target | Static/source compatible; runtime matrix pending |
| `zh_cn` | 0.3.1 | Simplified Chinese content translation + fixed-cell CJK + engine-gap presentation wrappers | Red / Blue / Yellow | Current primary Simplified Chinese target | Upstream R/B/Y smoke exists; Nuzlocke exact-combination runtime pending |
| `translation-nl` | 0.0.2 | Generated Dutch localization/content + loaded literal handlers | Red / Blue | Current Dutch target | Static/source compatible; mutation-focused runtime pending |
| `finnish` | 0.1.0 | Finnish content translation + fixed-cell extended Latin + presentation overrides + loaded literal handlers | Red (conservative reviewed scope) | Current Finnish target | Static/source compatible; focused runtime pending |

## Matrix rules

- Translation identity, gameplay identity, and runtime certification are separate facts.
- A translation companion never gains Nuzlocke gameplay-policy ownership merely by being detected.
- Edition evidence is never transferred from one game to another.
- A source/architecture audit is not a Runtime PASS.
- Localized display text is presentation only; canonical rule, area, species, item, move, encounter, Randomizer and transaction identities remain language-neutral.
- Companion-specific fonts, graphics, ROM-derived text, catalog overlays and native-layout modifications remain external ownership.
- Translation API 2 exposes Nuzlocke-owned source strings and lifecycle diagnostics; it does not install or redistribute translation content.

## Current recommended certification order

1. German Universal: one R/B/Y edition + one Gen-II edition, then Crystal.
2. Spanish: Red/Blue with matching Spanish EUR cartridge and one partial-without-dump check.
3. French: base-only and base+extended on Red, then Gen-II/Crystal smoke.
4. Brazilian current target: repeat exact current-version runtime matrix after generalized localization changes.
5. Finnish: first re-verify the current upstream target/version before certification.

---

## Japanese / CJK compatibility — 2.8.60

The current reviewed Japanese target is `translation-ja-hrkt` **0.4.2** (JP GREEN - Poketto Monsutā Midori), for **Red and Blue**. It is a generated/content translation and requires the player's own ROM import.

Unlike the Western targets, Japanese renders ordinary text through Gen1Recomp's bundled **Plain Pixel TTF**. The companion registers the TTF at size 10 while retaining digits, `/`, and `:` on vanilla tiles. At that size kana advance by one 8px engine cell while Latin text remains narrower. Nuzlocke must therefore avoid assuming that byte length, Unicode code-point count, and rendered width are interchangeable.

Nuzlocke's existing `nuzGlyphSpans` / `nuzGlyphLen` / `nuzGlyphSlice` boundary is retained and protected by Release Safety. It prefers engine `Font.split`, falls back to UTF-8 code-point boundaries, and never intentionally slices a multibyte character in Nuzlocke-owned wrapping/truncation.

The reviewed Japanese mod is currently complete for its ROM-derived catalogs but only partially translated for engine strings; untranslated entries intentionally fall back to English. Mixed Japanese/English presentation is therefore expected and is not itself a Nuzlocke compatibility failure.

The Japanese target also documents engine dependencies around TTF tile opt-outs, draw-color restoration, and boot-time TypeChart loading. Nuzlocke does not reproduce or own those engine fixes.

### Japanese runtime matrix

1. Red + Japanese 0.4.2: setup, NUZ RULES, ENC TRACKER and NUZ STATUS.
2. Blue + Japanese 0.4.2: same core smoke.
3. Long rule descriptions with kana/CJK next to untranslated English fallbacks.
4. Party / NUZ INFO / Move Learn with Japanese species/move names.
5. Mart and battle denial messages without matching Japanese display literals.
6. F. TOKEN and Battle Clause messages, including mixed translated/untranslated source fallback.
7. Randomizer labels and dynamic values.
8. Wide Menus compatibility if enabled.
9. Dev Report LOCALIZATION source/fallback counts.
10. Numeric alignment around levels, HP, PP, prices and page counters.

No exact-combination Runtime PASS is claimed by this source audit.

---

# French translation compatibility — 2.8.58

## Base target: Translation French

- Mod ID: `translation-fr`
- Reviewed generator release: **0.8.0**
- Generation model: reproducibly generated Gen1Recomp LANGUAGE/content mod
- Current reviewed edition scope: **Red, Blue, Yellow, Gold, Silver, Crystal**
- Optional companion only; never required by Nuzlocke.

The current generator release adds Crystal support and carries Gold/Silver engine-string coverage work forward. Its generated translation remains a standard content mod using Gen1Recomp text/string/name/font registries.

Current Latin builds default to proportional Fusion Pixel TTF support. Nuzlocke therefore composes through its generalized glyph-span/VWF-safe typography rather than through French-specific sizing branches.

## Optional overlay: Traduction FR etendue

- Mod ID: `trad-fr-extended`
- Reviewed version: **0.2.0**
- Hard dependency: `translation-fr`
- Priority: 200
- Role: fills remaining engine-string and Pokédex-kind gaps after the base translation.

The overlay intentionally does not register a font; it relies on the base translation. Its current implementation writes remaining `strings` entries and `dexEntry.kind` fields and documents last-writer-wins ordering after the base translation.

Nuzlocke treats these as two distinct compatibility identities rather than conflating the overlay with the base translation.

## Ownership

Neither French companion gains Nuzlocke gameplay authority. They own translated presentation/content only.

Nuzlocke retains:

- challenge-rule policy;
- encounter legality;
- canonical area identity;
- tracker/save state;
- Randomizer semantics;
- NUZ STATUS/setup/rules state.

French display words must never become gameplay matching literals.

## Runtime matrix

1. Red + `translation-fr`.
2. Red + `translation-fr` + `trad-fr-extended`.
3. Yellow + base French translation.
4. Gold or Silver + base French translation, especially Gen-II NUZ STATUS.
5. Crystal + base French translation smoke.
6. Long French rule names/descriptions and Randomizer values under classic UI.
7. Wide Menus + French.
8. Dev Report LOCALIZATION counts with base-only and base+overlay.
9. Mart BUY/SELL + Forgiveness.
10. Party / NUZ INFO / Move Learn.

No exact-combination runtime PASS is claimed by this source audit.

---

# Traduccion Espanola compatibility — 2.8.57

## Explicit target

- Mod ID: `traduccion_es`
- Name: **Traduccion Espanola**
- Reviewed current version: **0.1.0**
- Category/profile: LANGUAGE/content
- Current full cartridge-layer editions: **Red / Blue**
- Nuzlocke optional companion only; never required.

## Composition model

The reviewed target does not own Nuzlocke gameplay hooks. It registers/patches translated content through Gen1Recomp's content surfaces:

- engine `strings`;
- ROM `text`;
- Pokemon/move/item/trainer names;
- status labels;
- type-chart display names;
- Dex kind/metric presentation;
- font/charmap pages;
- boot/title and battle HUD derived assets when a matching Spanish cartridge is available.

Nuzlocke should therefore compose semantically rather than add Spanish-specific gameplay branches.

## Spanish EUR cartridge boundary

The companion's official cartridge layer requires a matching Spanish Red/Blue EUR dump in the engine `imports/` directory.

Without that dump:

- the companion's hand-translated engine strings still apply;
- cartridge-derived dialogue/content remains English;
- the companion itself may present its missing-dump notice.

Nuzlocke does not inspect the user's ROM files or mirror the companion's private missing-dump state.

Yellow currently has no Spanish cartridge spec in this target. Do not infer Red/Blue cartridge coverage onto Yellow, Gold, Silver or Crystal.

## Nuzlocke-authored text

The current Spanish companion cannot automatically know every Nuzlocke-authored source added after its own catalog. Nuzlocke Translation API 2 source/fallback diagnostics remain the supported way to identify untranslated Nuzlocke strings.

## Runtime matrix

1. Red + Traduccion Espanola + matching Spanish Red EUR dump.
2. Blue + Traduccion Espanola + matching Spanish Blue EUR dump.
3. Red without EUR dump: engine-text partial translation + missing-dump notice.
4. NUZ STATUS / rules / tracker / World Building long text.
5. Randomizer setup/status values.
6. Mart BUY/SELL restrictions and Forgiveness filtering.
7. Party menu / NUZ INFO.
8. Move Learn / Rare Candy TO CAP.
9. Dev Report LOCALIZATION fallback counts.
10. Yellow smoke only as partial/unsupported-cartridge behavior; do not certify full Spanish Yellow.

No runtime PASS is claimed by the static/source audit.

---

# Long-string / variable-width localization compatibility — 2.8.56

Nuzlocke-owned shared UI fitting now prefers Gen1Recomp glyph-span measurement and preserves UTF-8 boundaries in fallback paths. Two-column values are fitted before right alignment, diagnostic hard-wrapping is glyph-aware, and compact Gen-II NUZ STATUS summaries remain bounded.

This work is language-general. It does not detect specific languages or introduce Portuguese/German/Spanish/French/Japanese layout branches.

Translation API 2 also exposes the complete live World Building flavor catalog and additional Randomizer status/value sources so compatible translation packs can cover Nuzlocke-authored text without taking gameplay ownership.

---

# General localization compatibility — 2.8.55

## Discoverable Nuzlocke-owned strings

The Translation API 2 source catalog now includes a first batch of high-value Nuzlocke UI strings in addition to rule/section names and descriptions. Translation companions do not need language-specific gameplay adapters for these strings; they can override the stable source text through Gen1Recomp's normal `Strings` mechanism.

The current batch covers NUZ STATUS, Encounter Log / Area Guide labels and controls, tracker summaries, common encounter/history states, and high-tier Nuzlocke-over summaries.

## Diagnostic coverage

Dev Mode can report current translation lifecycle and source-resolution coverage. This is informational and read-only. It must never switch language, reload a translation, mutate another mod's options, or treat untranslated Nuzlocke UI as a gameplay failure.

A source resolving to itself is reported as fallback-like. This is a practical translation-author signal, not definitive proof of missing translation because some legitimate translations may intentionally be identical.

---

# Translation German Universal compatibility — 2.8.54

## Explicit target

- ID: `translation-german-universal`
- Reviewed stable release: **0.2.0**
- Scope: Red, Blue, Yellow, Gold, Silver, Crystal
- Shared supported engine window with Nuzlocke: `>=0.2.24 <1.0.0`
- Optional companion only; never required for Nuzlocke.

## Language lifecycle

Translation German Universal exposes boot-time language state and intentionally requires restart before a pending language change becomes materialized.

Nuzlocke Translation API 2 therefore separates:

- companion installation;
- current active localization;
- pending localization;
- restart-required state.

When available, diagnostics consume `bootLanguage`, `edition`, `pendingLanguage(game)`, and `restartRequired(game)` without mutating them.

English/no-op boot remains installed but inactive for German localization.

## Ownership boundaries

German Universal may own translated native presentation including its Gen-I battle command geometry, ChoiceBox sizing, Gen-II Chrome choice geometry, Pokédex metric/layout presentation, fonts, title graphics, Trainer Card graphics, map graphics, and translated content catalogs.

Nuzlocke does not copy these implementations and does not take their presentation ownership merely because the companion is detected.

Nuzlocke retains rule policy, encounter legality, tracker state, NUZ STATUS, setup/rules state, and Nuzlocke-authored screens.

## Canonical encounter areas

Localized map names are presentation only. One Per Area, Encounter Tracker persistence, encounter splits, catch provenance, and recovery remain keyed by canonical physical map/area IDs.

Changing English ↔ German must never create an additional encounter allocation for the same physical area.

## Runtime matrix still required

1. Red + German Universal, native battle menu.
2. Red + German Universal, Nuzlocke Gen-I Battle Menu UI ON.
3. Red Mart / party / Move Learn / NUZ STATUS.
4. Gold or Silver native battle/party + Nuzlocke custom screens.
5. Crystal startup/title + tracker/status smoke.
6. German → English pending-language state before restart and English boot after restart.

No exact-combination Runtime PASS is claimed by this source/static compatibility build.

---

# Brazilian Portuguese translation compatibility — 2.8.50

## Current explicit target: VersaoVermelha

- Mod ID: `versaovermelha`
- Reviewed stable release: **0.2.5**
- Scope: Gen-I Brazilian Portuguese localization plus presentation/layout changes.
- Repository manifest currently reports 0.2.5.1; Nuzlocke treats stable release 0.2.5 as the reviewed release target and records the mismatch rather than silently normalizing it.
- `versaovermelha` is an optional compatibility identity, never a required dependency.

The older `gen1_pt-br` identity remains a separate **legacy** known companion. Nuzlocke does not assume it is the same project as VersaoVermelha.

### Ownership contract

Translation content remains external. Nuzlocke composes with translated `Strings`, font/charmap pages, Pokémon/move/item/trainer/status display data, and public UI hooks.

When exposed by a known translation companion, Nuzlocke diagnostics may report presentation signals such as:

- `trainer_card`
- `precos_linha`
- `idioma_golpes`
- `mostrar_inimigo`

Those signals are diagnostic only and do not grant gameplay-policy authority.

VersaoVermelha's native Trainer Card, Gen-I battle text-area, Move Learn, ListMenu, party-label, and title presentation are external presentation ownership. Nuzlocke retains challenge rules, encounter legality, NUZ STATUS, tracker, setup/rules state, and its own custom screens.

### Language-neutral shop policy

R/B/Y Forgiveness shop filtering must not identify a shop from English display literals. The filter prefers semantic menu metadata and only falls back to canonical localized engine `Strings("BUY")` / `Strings("SELL")`.

Do not add Portuguese `COMPRAR` / `VENDER` checks. The same contract must work for future German, Spanish, French, Japanese, Dutch, Finnish, and other translations.

### Runtime matrix still required

Focused combination tests should cover:

1. Red native battle menu + VersaoVermelha.
2. Red Nuzlocke Gen-I Battle Menu UI ON + VersaoVermelha.
3. Mart BUY/SELL restrictions and Forgiveness Token filtering.
4. Field party submenu + NUZ INFO.
5. Native Trainer Card plus NUZ STATUS.
6. Move Learn / Rare Candy TO CAP.
7. Yellow title/new-game setup smoke.

No exact-edition combination Runtime PASS is claimed by this static/source audit.

---

# Nuzlocke Compatibility — 2.8.48

## Gen1Recomp 0.2.28 / 0.2.29 audit

The current source-audited engine marker is **Gen1Recomp 0.2.29**. The supported manifest range remains `>=0.2.24 <2.0.0`; neither 0.2.28 nor 0.2.29 introduces a new Nuzlocke-required gameplay or Mod API seam.

- **0.2.28:** relative to 0.2.27, the engine changes only `src/core/HostShell.lua` plus iOS app-repository metadata. `HostShell.popen` now normalizes the command through `HostShell.shellCommand(...)` before `io.popen`, improving host-shell command handling. Nuzlocke does not own this launcher/subprocess path.
- **0.2.29:** relative to 0.2.28, the code changes are `GamepadMap`, `RomImporter`, `Kit`, and `VirtualKeyboard` plus iOS metadata. The input changes restore raw L2/R2 trigger mapping/scrolling and scope the on-screen VirtualKeyboard to Linux handhelds. These are launcher/importer/UI changes; no Nuzlocke battle, Pokémon, hooks, Strings, Chrome, save, shiny, or Randomizer data seam changed.
- Mod API remains 2 and the audited engine save format remains 4.
- Existing 0.2.27 public `catch.nickname`, Chrome/palette, shiny, and battle integration remains the applicable gameplay contract because those source boundaries are unchanged in 0.2.28/0.2.29.
- Exact-edition runtime certification remains separate from source compatibility.

## Compatibility API 36

2.8.77 advances the Nuzlocke Compatibility API from **35 to 36** because the public `nuzlocke_compat.runtime_environment` field changes from an accidental function object to its documented/current environment value, and content-bundle registration now guarantees prevalidation before registry mutation. `compatible_from = 10` remains unchanged.

The content bundle contract now rejects an invalid area/dungeon/boss/gift/encounter or Randomizer policy before applying any earlier bundle rows. This prevents partial provider registration after a late validation error.

Diagnostics API remains 1. Gen2 Field Item Hook Health now resolves the actual visible-item and hidden-item session markers, and Random Trainers gain semantic `trainer.party` chain observability without changing gameplay ownership.

## Compatibility API 35

2.8.48 advances the Nuzlocke Compatibility API from **34 to 35**. This is an additive contract-version reconciliation, not a gameplay ownership change. API 35 formally includes the public semantic status helpers already present in the current implementation: provider status, capability status, and compatibility snapshots, while preserving API-34 rule availability/dependency APIs and `compatible_from = 10`.

2.8.41 Dev diagnostics can now report provider detection, advertised capabilities, selected external owner, degraded state, and Nuzlocke fallback without altering provider resolution.

2.8.41 Release Safety hardening: compatibility ownership semantics are unchanged from 2.8.39; promotion checks now explicitly guard native Gen II battle/party ownership, shiny single-owner failover, and the prohibition on Nuzlocke invalidating engine renderer/assets.

2.8.39 compatibility/API cleanup: compatibility diagnostics now distinguish **detected**, **advertised**, **selected external owner**, **inactive/degraded**, and **Nuzlocke fallback** states. MOD COMPAT shows provider-health and retained-fallback summary rows. No gameplay ownership policy changes.

Historical fallback inventory retained in 2.8.39:
- `catch.nickname` is preferred on Gen1Recomp 0.2.27+, while `battle.nickname` + naming-screen enforcement remains for the supported 0.2.24-0.2.26 range.
- Shiny provider registry / `shiny_compat` API is preferred; direct `isShiny`/`rollShiny` exports remain for older supported Shiny builds.
- Public Interop registration is preferred; legacy `nuzlocke_provider` relationship metadata and automatic adapters remain for supported mods that have not migrated.

2.8.38 localization hardening: compatibility ownership and gameplay hooks are unchanged from 2.8.37; migrated Nuzlocke UI/messages now compose with Gen1Recomp `strings` registry translation providers.
2.8.37 full release: behavior-preserving promotion of the final corrected 2.8.36 candidate after Red standalone shiny runtime PASS; compatibility API/ownership contracts are unchanged.
2.8.36 standalone shiny regression fix: external shiny ownership now requires a live separate provider handle before registry/API claims are trusted, preventing Nuzlocke-only runs from falsely standing down their built-in shiny system.
# Nuzlocke Compatibility — 2.8.41

## Translation/string-provider compatibility

2.8.38 expands use of Gen1Recomp's source-keyed `Strings` registry for Nuzlocke-authored Battle Clause denials, Forgiveness actions, Classic status/history templates, and recovery fallback text. Nuzlocke does not own font rendering or translation-provider lifecycle; it consumes the engine registry and falls back to English when a key is absent. Dynamic Run History details (species, area, badge names) are appended to translated authored labels rather than turned into unstable dynamic translation keys.


## Gen1Recomp 0.2.27 compatibility

This build has completed the four targeted compatibility actions from the 0.2.27 review. On Red/Blue/Yellow, the Nickname Rule now enters through the public `catch.nickname` hook introduced by RFC 0015. Nuzlocke still keeps its naming-screen enforcement so a required nickname cannot be declined or confirmed empty; `battle.nickname` remains registered only for older 0.2.24-0.2.26 engine compatibility.

On Gold/Silver/Crystal, Nuzlocke-owned NUZ STATUS and Recover Catches surfaces now use the engine's palette-aware `src.ui.gen2.Chrome` drawing contract for paper, boxes, cursors, ink and wrapped text. This allows 0.2.27 custom GB/COLOR palettes to carry through those utility screens. Setup/NUZ RULES already used Chrome and no longer applies raw black/white resets inside its Gen II path.

The Gen II shiny send-out safety boundary was also source-revalidated against 0.2.27. The engine still contains the queued `shiny-flash` event, so Nuzlocke retains the narrow Crystal workaround while it owns shiny presentation: it consumes only that event, restores both `picHidden` latches, and immediately resumes the native queue. The replacement cue remains on `battle.overlay`; Nuzlocke does not replace Gen II `BattleState.draw` or `BattleState.update`. This is **source compatibility**, not a claim that Crystal/Gold/Silver runtime certification has been completed on 0.2.27.

The global source/documentation-audited engine profile is now **Gen1Recomp 0.2.27**. Mod API 2, Save Format 4, and the existing `>=0.2.24 <2.0.0` manifest range remain valid. Exact-edition runtime evidence is still tracked separately.


## Shiny Pokémon maintained fork 1.2.20 (current target; historical 1.2.7 audit retained)

Shiny Pokémon **1.2.20** is the current explicit shiny companion target. The earlier 1.2.7/Gen1Recomp 0.2.27 audit remains historical evidence rather than the current target marker. Its maintained 1.2.x architecture is generation-neutral at the compatibility layer but intentionally split internally: Gen I still runs the inherited presentation/generation implementation, while Gen II registers options and uses the engine-native `shiny.roll` / native presentation path without executing the inherited Gen-I `main.lua`. Therefore Nuzlocke must not require the old top-level `exports.isShiny` / `exports.rollShiny` pair to recognize a Gen-II owner.

Nuzlocke now prefers the public provider registration that Shiny Pokémon publishes into `nuzlocke.interop` (`SHINY_IDENTITY` + `SHINY_PRESENTATION`). If registration order has not completed yet, Nuzlocke can also inspect the maintained `exports.shiny_pokemon` / `exports.shiny_compat` API and its `shiny_identity` / `shiny_presentation` ownership descriptors. The historical direct export probe remains a fallback only. This keeps external-owner failover functional on Red/Blue/Yellow and Gold/Silver/Crystal.

The maintained Shiny 1.2.x line also preserves the Gen1Recomp COLORS-transition boundary established by the 1.2.7 audit: **Gen1Recomp alone owns Renderer/Assets invalidation.** Nuzlocke performs no renderer reset, asset reset, or palette-transition engine-cache flush. Official Gen-I Crystal shiny pairs are independent of the selected engine COLORS mode. For custom/unknown species whose fallback shiny colors derive from `PaletteFX.monPal`, Nuzlocke includes the active PaletteFX mode/custom-ramp signature in its own private derived-image cache key. A COLORS transition therefore selects/rebuilds only a Nuzlocke-private artifact and never invalidates engine resources.

When Shiny Pokémon 1.2.20 is active, its Mod Manager controls remain authoritative and Nuzlocke hides/stands down `Shiny Rate`, `Shiny Colors`, and `Shiny Intro`. `Shiny Clause` remains visible because it is Nuzlocke challenge policy. On Gen II the external provider's own battle-presentation safety path remains untouched; Nuzlocke's Crystal `shiny-flash` workaround runs only while Nuzlocke itself is the shiny owner. Combined runtime certification is still edition-specific.

## Shiny providers

`SHINY_POKEMON` remains an explicit optional target, but 2.8.36 formalizes a generalized single-owner contract. A loaded provider that exposes shiny identity plus roll/ownership capability owns both shiny generation and presentation for that active edition. Nuzlocke then becomes a read-only shiny consumer for Shiny Clause, catch policy, tracker, Catch Info, and run history.

When no provider owns shinies, Nuzlocke owns the complete built-in stack. Generation remains on the narrow gameplay seams established in 2.8.34; presentation uses the current engine's `pokemon.sprite`, `pokemon.icon`, and `battle.overlay` hooks. Nuzlocke deliberately does not replace Pokemon constructors, Gen-II battle screens, native BattleState draw methods, or renderer composition. This is also the compatibility boundary with PotatoVoxel and other presentation-heavy mods.

The built-in shiny derived-image cache is Nuzlocke-owned and does not change species records or shared content registries. If a provider becomes the active owner, Nuzlocke's visual hooks delegate immediately rather than drawing over provider output.

# Nuzlocke Compatibility — 2.8.33

## PotatoVoxel 1.9.6

PotatoVoxel is an explicitly audited optional presentation companion. Compatibility is capability-based: PotatoVoxel may own voxel world rendering and staged battle presentation, while Nuzlocke owns challenge semantics and gameplay transactions. Nuzlocke does not compete for `render.compose`, `Gen2BattleState`, or native `BattleState` draw ownership.

On Gen II, PotatoVoxel's bridge constructs the native Gen II battle state and layers voxel presentation around it; Nuzlocke therefore keeps its already-established native Gold/Silver/Crystal battle-menu and party/item ownership rules. On Gen I, PotatoVoxel may wrap native battle drawing, while Nuzlocke's optional Battle Menu UI continues through public overlay hooks rather than replacing PotatoVoxel's renderer.

PotatoVoxel cache/prebuild activity is classified as render-data work. It must not count as map traversal, consume encounter areas, trigger Gym/Dungeon lock-ins, or advance Nuzlocke tracker/progression state.

The compatibility health check intentionally relies on provider capabilities rather than exact reported version strings. `potato_voxel` remains optional, and absence of the mod is not an error. Test with only one voxel renderer enabled at a time, matching PotatoVoxel's own conflict model. Combined runtime evidence is required separately for Red/Blue/Yellow and for each Gen II edition being claimed.

# Nuzlocke Compatibility — 2.8.32

## STEEL/FAIRY AND TYPING CHARTS 2.0.1

Explicit companion compatibility is supported through merged Gen1Recomp data rather than copied implementation. Nuzlocke Type Locke, trainer/randomizer typing consumers, and now Random Starter Trio Typing read live merged species/move/type metadata. Trio Typing uses `game.data.type_chart.matchups`, so FAIRY and customized Steel/Dark relationships are evaluated from the same chart used by the running game. `steel_typing` is optional and recommended, not required. Exact-edition runtime evidence remains edition-scoped.

# Nuzlocke Compatibility — 2.8.31

Gen II Random Starter now follows Gen1Recomp's native evolution-row shape (`into`) when classifying starter lineages, while remaining compatible with Gen I/provider rows that use `species`. Elm confirmation substitution supplies the current Gen II VM `rawtext` command shape without replacing GIVEPOKE ownership.

2.8.29's native Gen II battle-command ownership and battle-rule denial path remain unchanged. Wilds of Kanto 2.2.0 compatibility behavior is unchanged from the reviewed 2.8.29 baseline.

# Nuzlocke Compatibility — 2.8.29

Gold/Silver/Crystal retain native battle command rendering and input ownership. Nuzlocke's optional Battle Menu UI hooks register only on Gen I. Gen II battle-item/capture refusals use the native `BattleState:showPages`/`resolving` path; the legacy `nuzlocke-rule-text` phase and `BattleState.update` wrapper are retired, including stale in-process wrapper sessions.

Wilds of Kanto 2.2.0 compatibility diagnostics from the 2.8.28 audit are preserved while its alternate-capture transaction remains unchanged.

# Nuzlocke Compatibility — 2.8.29

Gold/Silver/Crystal battle command presentation is fully engine-owned. Nuzlocke does not register its Battle Menu UI hooks on Gen II even when an older saved preference is ON; that preference applies only to Red/Blue/Yellow. Gen II rule denials also use the native BattleState refusal state rather than a Nuzlocke-owned update phase.

Wilds of Kanto 2.2.0 remains an alternate overworld encounter/capture provider, not a Nuzlocke Randomizer owner. The existing pre/post direct-capture composition is unchanged; 2.8.29 ports only explicit provider-version/surface diagnostics from the reviewed 2.8.28 work.

## Historical current note: Nuzlocke Compatibility — 2.8.27

Gen II PartyMenu construction, battle cancellation, and native direct item
targeting remain engine-owned. The R/B/Y custom Day Care constructor guard is
explicitly removed when the shared PartyMenu facade is serving Gen II, including
legacy wrapper sessions retained through an in-process mod reload.

## 2.8.01 Gen II hotfix compatibility
Trainer Randomizer configuration is restored to the Gen II allowlist without changing trainer randomization runtime ownership. Field-poison wipe detection now derives from the live post-prune party state as well as the engine event flag, preserving the existing native spawn-warp/recovery seam when Whiteout survives.


## 2.8.00 Gen2 party-item compatibility

Crystal runtime showed the 2.7.106 Game2 post-selection wrappers could still lose the item transaction. 2.8.00 moves simple field party-consumable ownership to the Pack USE seam after Nuzlocke legality checks and uses the authoritative `game.save.party[index]` target. Specialized PP, stone, TM/HM, battle and non-party field-item flows remain delegated to their existing owners.

## 2.7.106 Gen2 party-consumable compatibility

Crystal runtime established that the `useItem` party chooser can now select a Pokémon correctly, but the downstream effect handoff still fails for healing items, vitamins, and Rare Candy. Nuzlocke now owns only that narrow post-selection seam for simple Gen2 consumables and calls Gen1Recomp's merged `ItemEffects` record directly on the selected party member. Native Game2 consumption/messages and Rare Candy follow-up remain authoritative; PP items and evolution stones are not redirected. This avoids additional Pokémon-record mutation and does not alter ordinary field-party or battle-party menus.

## 2.7.105 Gen2 party-item chooser ownership

Runtime evidence shows native item selection reaches Gen1Recomp's Gen2 PartyMenu correctly, but the target screen can be contaminated into ordinary field-submenu mode. Nuzlocke now guards only PartyMenu instances opened with the native `useItem` prompt: `submenu`/`battleSubmenu` are forced false and the screen remains a direct `onChoose` chooser. Ordinary field Pokémon menus still own field moves, STATS/SWITCH/MOVE/ITEM and NUZ INFO; battle and TM/HM chooser contracts are unchanged. Permitted items remain owned by Gen1Recomp's native Game2/ItemEffects/consumption flow. The 2.7.104 full-record materialization experiment is retired.

## 2.7.104 Gen2 native party-record contract

Gen1Recomp's Gen2 `Mon.new` record—not only `mon.species`—is now treated as the native structural authority for a randomized Elm starter. The repair keeps the existing owned table reference and persistent Nuzlocke identity, but refreshes native structural fields from the engine builder while preserving live HP/status/EXP/moves/held item/OT. The 2.7.103 direct Pack→Game2 routing experiment is retired; native Pack→World→Game2 dispatch is restored after Nuzlocke legality checks.

## 2.7.103 Gen2 party-item routing

Crystal runtime evidence showed that species canonicalization at `Game2.usePartyItem` was not sufficient. 2.7.103 instead recognizes Gen1Recomp's native Gen2 party-effect records at the field Pack USE seam and, after Nuzlocke item-policy approval, dispatches them directly to the live game's native `Game2:usePartyItem`. This deliberately bypasses Pack/world field-item classification while preserving native party selection, item effects, item consumption, Rare Candy/evolution handling, and messages. Runtime certification remains required.

## 2.7.102 Gen2 party-item representation compatibility

Gen1Recomp Gen2 party-item effects resolve Pokemon definitions by semantic `mon.species` key. 2.7.102 repairs compatible numeric owned-Pokemon species representations at `Game2.usePartyItem` dispatch rather than relying only on randomized Elm-starter finalization. Native item-effect and inventory ownership are preserved. Runtime certification remains required.

## 2.7.101 / Gen1Recomp 0.2.25

The source/documentation audit advances through 0.2.25. The new read-only `mod.datasets` API can inspect already-imported version registries without switching the active game; Nuzlocke records it for future compatibility/randomizer metadata but does not move protected active-game transactions to it in this build. Gen2 service and Crystal opening-clock gates are hardened around semantic script/map identity. Runtime certification remains required.

## 2.7.95 presentation ownership

Gen-2 tracker MAP ordering is display-only. It does not rewrite area IDs, encounter state, provenance, catch history, provider ownership, or physical map identity. Encounter-registry membership plus concrete tracker evidence determines ordinary MAP visibility; raw host `mapOrder` is no longer treated as a player-facing sort contract.

Battle Menu UI continues to compose only through the public battle presentation seams and does not own action dispatch. The 2.7.95 visual changes only replace the Nuzlocke-owned command panel geometry.

## 2.7.94 Random Starter / Species Pool ownership boundary

Random Starter no longer consumes `random_species_generation`. Its candidate eligibility is owned by starter hard safety, Starter Style, Type Locke, acquisition legality, and exact-edition runtime safety. The shared Species Pool remains authoritative for Random Encounters, Random Trainers, and Random Evolutions only. This restores the exact behavioral boundary present in runtime-PASS 2.7.44 while keeping all later provider/delegation and Randomizer subsystem architecture.

## 2.7.93 battle UI / movement contracts

In Red/Blue/Yellow only, Battle Menu UI composes through Gen1Recomp's public `battle.bottom_ui_visible` and draw-only `battle.overlay` hooks. It does not replace battle update/input/action code, HP/status HUD rendering, move selection, party/Bag screens, or special Safari/tutorial menus. Gold/Silver/Crystal never use this renderer. The Gen I toggle defaults OFF.

Run / Surf continues to use the shared `movement.speed` hook and preserves the existing monotonic composition rule: Nuzlocke does not stack another 2x acceleration on a downstream provider that has already accelerated the same player-controlled step. The old `automatic_running_shoes` and `fast_surf` save fields are legacy compatibility mirrors; `run_surf` is authoritative after migration.

## 2.7.92 UI palette contract

The Nuzlocke-owned Setup/Rules chrome now has a semantic palette contract: title = emphasized/bold chrome; normal interactive content = black/dark; WIP/delegated = dimmed exceptional state. Selection is expressed by the native cursor glyph, not by changing normal row text color. This applies to R/B/Y and Gold/Silver/Crystal Nuzlocke-owned surfaces only and does not recolor protected native game menus.

## 2.7.91 mandatory-story fail-open boundary

Random Starter is optional transformation work around a mandatory native starter transaction. Errors while materializing a canonical starter slate must not abort the native story grant. For supported canonical starter transactions, the safe fallback is the selected vanilla starter. This boundary composes with the 2.7.90 mandatory-starter provenance/receipt contract rather than replacing it.

## 2.7.90 duplicate acquisition-gate contract

A mandatory starter must have one transaction owner across pre-command, native mutation, and post-receipt layers. Gen-2 POKEPIC -> GIVEPOKE uses a VM scriptKey-scoped marker; native givePoke opens a matching receipt window so pokemon.received cannot reinterpret the same object as a generic gift. New Game setup state must be transferred into the fresh save-backed mod bucket at save.created before any starter hook depends on it.

## 2.7.89 starter ownership compatibility

Starter transaction identity is story/context authority, not a speculative data-shape classifier. Gen-2 Elm Lab GIVEPOKE is mandatory starter flow; R/B/Y `pokemon.before_give` is restricted by first party acquisition plus canonical native opening-starter species. Representation helpers may refine species identity but may not downgrade the mandatory starter into an optional gift.

## 2.7.88 Gen1Recomp Pokemon identity boundary

For Gen 2, the public `pokemon` registry remains semantically string-keyed and each record exposes the cartridge species byte as `index`. Nuzlocke must resolve numeric script identities by `row.index`; physical table-key shape is not semantic identity. Elm's native GIVEPOKE operands are 152/155/158 for Chikorita/Cyndaquil/Totodile and are used only to identify the mandatory Elm Lab transaction when early-load metadata is unavailable. Gold, Silver, and Crystal share this boundary; Crystal remains ALPHA.

## 2.7.87 Gen1Recomp Gen-2 species identity contract

Gen1Recomp's Gen-2 VM supplies numeric species IDs to GIVEPOKE, while the public canonical name ordering is `game.data.gen2Constants.speciesOrder`. Nuzlocke must use that ordering for numeric <-> canonical translation rather than infer identity from the physical key shape of `game.data.pokemon`. This contract applies to Gold, Silver, and Crystal (ALPHA).

## 2.7.86 Gen-2 registry/applicability compatibility

Gen1Recomp Gen-2 species data may be indexed numerically while script transactions carry canonical species strings. Nuzlocke now resolves row aliases before treating an unregistered identity as glitch-shaped. Gold/Silver/Crystal also share the System Date/Time and System Clock Sync configuration applicability contract. Crystal remains independently runtime-certified as ALPHA.

# Nuzlocke Compatibility — 2.7.85

## 2.7.85 Crystal starter presentation compatibility

Crystal's current engine uses an edition-specific animated front-pic path. Runtime testing of 2.7.84 crashed when the first Elm starter ball entered the shared Nuzlocke preview-substitution layer. 2.7.85 therefore does not replace Crystal's native POKEPIC or cry operand. This is a deliberate Alpha fail-open boundary, not a rollback of Crystal support: Crystal remains an explicit manifest target, and the shared Gen-2 GIVEPOKE transaction/tracker path remains installed. Gold/Silver preview substitution is unchanged.



## 2.7.84 Gen1Recomp 0.2.24-era compatibility / Crystal Alpha

Nuzlocke now intentionally targets all six upstream editions: **Red, Blue, Yellow, Gold, Silver, and Crystal**. Crystal is explicitly **ALPHA**. It may use the shared Gen-2 implementation only where the engine exposes the same semantic contract; Crystal-specific story, script-special, progression, Battle Tower, encounter, and presentation differences require their own evidence. Gold PASS or Silver PASS never certifies Crystal.

The aggregate source/documentation audit through the 0.2.24-era line preserves Mod API 2, engine save format 4, and Nuzlocke Save Schema 5. The engine floor intentionally advances to `>=0.2.24 <2.0.0`: under API 2 an older loader that does not recognize the explicit `crystal` game token can reject the manifest instead of safely ignoring that edition. New/expanded upstream surfaces reviewed include Crystal engine support; `mod.developer`; Gen-2 translation improvements; centralized session teardown; Custom Carts; Gen-1 `mod.world:activeBlockAt()`; `map.occupancy_allowed`; and Gen-1 `battle.field_residual`. `activeBlockAt` is a useful future fail-closed map-signature seam but working Nuzlocke map rules are not mass-migrated. `battle.field_residual` is intentionally unused because upstream documents no Gold/Silver/Crystal parity yet.

Two upstream compatibility traps are explicit: `src.ui.OptionRows` has no Gen-2 adapter and must not drive Nuzlocke Gen-2 configuration UI; `src.script.Commands` is a valid R/B/Y dependency but must never be required/used as a Gen-2 command runner. Release Safety protects both boundaries.

### Crystal Alpha runtime policy

- Exact edition id is `crystal`; Nuzlocke-owned Gen-2 screens display `CRYSTAL ALPHA`.
- Crystal has its own runtime-evidence ledger; no Gold/Silver inheritance.
- Shared Gen-2 rules are available when their semantic owner is genuinely common.
- Missing Crystal-specific evidence must fail closed or remain explicitly TEST REQUIRED rather than silently claiming enforcement.
- Crystal-specific progression/static/gift/Battle Tower behavior is a priority certification backlog.


## 2.7.83 configuration compatibility

The direct Difficulty chooser continues to respect external trainer/difficulty providers. Selecting a built-in or VANILLA profile cannot disable another mod's own trainer hooks, so `difficultyStackWarning()` is shown before commit whenever stacking may remain. Manual Gen-2 time writes only through the upstream Clock API and disables Nuzlocke System Clock Sync to avoid competing authorities. Exact manifest targets remain Red, Blue, Yellow, Gold, and Silver; Crystal remains outside this build.


## 2.7.82 Gen1Recomp 0.2.21 runtime hardening

The audited engine target remains Gen1Recomp 0.2.21. The Gen-2 script VM can carry numeric `special` operands, so Nuzlocke now resolves Mom clock/DST specials through the live VM's `specialName()` before ownership decisions. Lifecycle-sensitive Gen-2 installation uses the exact Game supplied by `game.ready`, `save.loaded`, or `save.created`, while the PartyMenu NUZ INFO wrapper gates on its live `self.game`. Historical note: that build explicitly declared Red, Blue, Yellow, Gold, and Silver and did not infer Crystal from upstream generation aliases. Current 2.9.2 explicitly declares Crystal as alpha.


## Gen1Recomp 0.2.21 source audit

2.7.81 source-audits Gen1Recomp 0.2.21. Mod API 2, Save Format 4, and Nuzlocke's `>=0.1.86 <2.0.0` engine envelope remain compatible. Upstream `gen2` now includes Crystal, but Nuzlocke intentionally keeps the exact manifest set Red/Blue/Yellow/Gold/Silver. Gold and Silver remain independent runtime-evidence targets.

0.2.21 also provides `mod.developer`, `isModOptions` propagation, expanded Gen2 ROM-text/translation coverage, stronger session teardown, Custom Carts, and new map/world/link seams. Nuzlocke adopts only the reviewed compatibility metadata and clock/DST integration needed here. `src.ui.OptionRows` remains unsuitable for Gen2 Nuzlocke UI, and `trainer.before_battle` is not assumed to have full Gold/Silver parity. Runtime smoke on 0.2.21 remains required.

## 2.7.80 Gen-2 native clock and Elm timing integration

Gold/Silver continue sharing one Gen-2 implementation while retaining independent runtime evidence. System Date/Time and System Clock Sync write through `src.core.gen2.Clock` rather than creating a parallel Nuzlocke clock. Elm completion tolerates the native GIVEPOKE visibility delay by carrying one exact pending transaction to the next safe world step. Generated/shared ROM script rows remain immutable, and native/non-Nuzlocke UI ownership is unchanged. Compatibility API remains 34.

## 2.7.79 shared Gold/Silver Elm authority

Gold and Silver use the same live Gen-2/Elm/GIVEPOKE starter-transaction contract and the same rendered-preview confirmation authority. The repair does not create Silver-only gameplay ownership or transfer provider authority. Native game UI and the Mod Manager are not restyled. Compatibility API remains 34.


2.7.77 hardens exact Silver reachability without creating a Silver-only implementation: the shared Gen-2 PartyMenu fallback prefers `src.ui.gen2.PartyMenu`, Elm text substitution stays inside Elm's Lab and Random Starter ownership, and Gold remains the shared regression control. No provider-ownership or compatibility API version changes.


## 2.7.78 identity/recovery parity

Gold/Silver now share the existing Recover Catches maintenance surface with R/B/Y. Starter dedupe is based on Nuzlocke Pokemon identity, not species, and does not transfer compatibility/provider ownership. No compatibility API version changes.
## 2.7.76 Gen-2 authority recovery

2.7.76 consolidates Gold/Silver shared runtime authority and keeps exact-edition evidence independent. No compatibility ownership/API version changes.

## 2.7.66 rule-availability audit, pass 2

- Continues the rule-availability audit in a deliberately small pass.
- Yellow no longer exposes Random Starter `Trio Typing` as a native rule because Yellow does not natively use the three-choice starter slate; an explicit compatible `starter_trio` provider can make it available.
- Encounter-slot modifiers now depend on `One Per Area`: Failed Encounters, Dupes, Gen II roamer/egg/contest policies, Town Catches, and area/time/headbutt split controls become dormant while area encounter limits are OFF.
- Type Locke now exposes/effects only the lanes selected by its mode. Catch Draft is hidden while Type Locke is OFF; manual type lanes are hidden/inert during Catch Draft; DUO through HEXA progressively reveal only the required lanes.
- Stored values are preserved while dormant and return when their prerequisite becomes applicable again.
- Release Safety extends the exact-edition/dependency source tripwire for these relationships.


# Nuzlocke Compatibility — 2.7.65

## Exact-edition mechanic availability (2.7.65)

Rule availability is evaluated independently for Red, Blue, Yellow, Gold, and Silver. `rbyOnly`, `gen2Only`, exact `nativeEditions`, and optional `capabilityGate` metadata determine whether a rule is meaningful. Capability gates are presence contracts only: they can expose a rule for a mechanic added by another mod, but they do not transfer Nuzlocke challenge-policy ownership.

The first optional mechanic-presence capability is `overworld_encounters`; other N/A mechanics remain hidden until a real semantic provider contract exists.

## MOD COMPAT ownership preferences (2.7.64)

For capability-backed rows, MOD COMPAT can cycle the Nuzlocke resolver preference with Left/Right through `AUTO`, the native Nuzlocke/Engine path, and installed providers that actually advertise that capability. `AUTO` remains the default. A pinned provider that disappears or becomes inactive falls back to `AUTO`. Fixed Nuzlocke policy and presentation-only rows remain read-only.

This preference controls **Nuzlocke's provider resolver**. It does not disable another mod or guarantee that an external mod will stop independently changing game behavior outside the advertised compatibility contract. Gameplay-impacting preference changes require confirmation before mutation.

## 2.7.58 presentation compatibility audit

The UI architecture includes compatibility hardening for Wide Menus logical-surface changes and Variable-Width Kerning font-metric changes. Nuzlocke-owned screens consume active layout/font metrics without taking ownership of third-party rendering, kerning, native Bag/PC/Party/Pokédex, or battle presentation. Runtime verification is still required.

## 2.7.57 typography/layout compatibility addendum

The UI architecture build does not patch glyph advances or own kerning. Nuzlocke-owned screens consume the active host font metrics, allowing compatible variable-width/kerning and font-replacement providers to remain authoritative. Alternative width providers are consumed only through documented public layout contracts; absence of either provider class must leave Nuzlocke functional. Runtime coexistence remains TEST REQUIRED.

# Nuzlocke Compatibility — 2.7.57

## Experimental UI compatibility boundary

The UI build deliberately modernizes only Nuzlocke-owned surfaces. Native or externally presented Bag, PC, Party, Pokédex, battle, Mart, Trainer Card, and other host surfaces remain outside Nuzlocke presentation ownership. Nuzlocke legality and state must continue to operate on semantic game actions/identities rather than menu rows, displayed labels, visual pockets, or renderer coordinates.

The current compatibility audit track covers alternative Pokédex, PC/storage, Bag/inventory, Party/Summary, Start-menu, broad Gen 1/Gen 2 UI overhaul, translucent/compositor, and battle presentation mods. This build does not claim Runtime PASS with any combination yet. Combination tests must verify both functional enforcement and clean presentation return/stack behavior.

2.7.27 keeps provider ownership semantics unchanged. Provider-added moves remain eligible only when the live move record is usable and not explicitly protected/non-randomizable; type/category weighting is soft and never overrides provider hard safety.
2.7.25 is a release promotion only. Compatibility ownership/composition rules are unchanged from exact 2.7.24.
This file describes **current compatibility ownership and composition rules**. Historical compatibility work belongs in `CHANGELOG.md`.

Explicit game/context arguments are authoritative. A compatibility function may resolve a missing game through the current runtime once, but it must not mix registries from the requested game with ownership/delegation state from another current/global game. Randomizer ownership is provider-agnostic and Nuzlocke relinquishes local projection ownership while an external provider is active.

## Randomizer / transaction coexistence

Learnset coexistence now compares only Nuzlocke-owned move-list fields (`level1Moves`, `learnset`, `levelMoves`). External providers may change unrelated Pokémon stats/types/metadata without accidentally transferring learnset ownership. No provider capability or Compatibility API version changes.

Rare Candy to Cap now uses transaction-specific durable recovery checkpoints and versioned monotonic attempt IDs. These are internal save-safety mechanisms and do not change public compatibility ownership.

## Stadium / Crystal 251 presentation and import compatibility

The Stadium provenance surface is now version 2 and explicitly distinguishes **model/ROM import** from **Pokémon acquisition**. Nuzlocke recognizes loaded `STADIUM_OVERWORLD_MODELS`, `STADIUM_UI_MODEL_VIEWER`, `STADIUM2_OVERWORLD_MODELS`, and `CRYSTAL_251` presentation/importer surfaces for diagnostics while preserving the engine's exact running Red/Blue/Yellow/Gold/Silver edition identity. Crystal 251 is therefore treated as an overlay/content provider, not as permission to rewrite the underlying edition to "Crystal".

Importing Stadium model assets never relabels ordinary party Pokémon. A real Stadium transfer/prize/import path must explicitly call `nuzlocke_acquisition_provenance.mark()` / `markImported()` (or preserve equivalent provenance fields) for the Pokémon it actually creates. `markImported()` requires Stadium 1/2 origin unless the caller deliberately opts into the detected active Stadium origin. Optional provider/mod id and exact-edition metadata are preserved with that acquisition record.

`compatibilitySnapshot(game)` reports the exact edition plus detected Stadium/Crystal-251 presentation/importer rows. DEV REPORT exposes this as `stadium_compat=...`, making the Aghanim-3C Crystal-251-compatible Stadium fork and compatible upstream variants diagnosable without hard-coding gameplay ownership to one fork. The Aghanim-3C repository ships forked Stadium Overworld Models and Stadium UI Model Viewer packages and describes them as Crystal 251 compatible; combination runtime testing remains required.

## Randomizer coexistence hardening — 2.6.90

Nuzlocke yields duplicate randomizer controls only when an external mechanic is positively active, never merely because a mod is installed.

Source-confirmed named adapters currently include:

- `pokemon_randomizer` — active-run starter, wild encounter, ordinary/hidden field-item, TM-location, learnset, trainer, evolution, and shop ownership from its exported run contract.
- `gen_2_randomizer_plus` — starter, wild encounter, world-item, learnset, trainer-species, and TM-content ownership from its live source-confirmed option bucket.
- `Kanto-Reforged` — encounter ownership only while its supported spawn-randomization modes are active.
- `item_randomizer` — source-specific Field Item/TM-location ownership while `overworld_items` is true in R/B/Y, `gold_ball_items` is true for Gen-II visible item balls, or `gold_finder_items` is true for Gen-II hidden/Itemfinder sources.

For `item_randomizer`, Gen-II native hidden/Itemfinder finds now overlap Nuzlocke's supported Gen-II hidden field-item sources and therefore claim `Random Field Items` when `gold_finder_items` is active. Shops, gifts, berries, held items, PC items, and other non-field-pickup features remain composition-only.

Generic provider ownership is also supported through `starter_randomizer_provider`, `encounter_randomizer_provider`, `field_item_randomizer_provider`, and `learnset_randomizer_provider`. External mods without a stable active-run signal or provider capability are not guessed as owners.

The read-only randomizer compatibility snapshot reports current owner state for starters, encounters, visible field items, and learnsets. DEV REPORT includes this as a compact ownership line. Missing or inactive external mods are normal/N/A, not compatibility failures.


## Engine baseline

- Gen1Recomp Mod API: **2**
- Supported engine range: **`>=0.1.86 <2.0.0`**
- Latest source/documentation-audited release: **0.2.27**
- Declared exact editions: Red, Blue, Yellow, Gold, Silver

The complete 0.2.19 → 0.2.20 upstream delta was reviewed: **6 commits / 26 changed files**. The compatibility-relevant change is stronger in-process session teardown. Returning from a game or embedded Save Editor now unmounts the active cache, unloads generated Data, resets the mod Runtime, Assets loader, and LegacyCompat state, and calls generation-specific `Game:reset()` / `Game2:reset()` cleanup before another launcher session. Upstream also added a regression test for opening a second mod-aware Save Editor session in the same process. This is favorable for Nuzlocke's lifecycle assumptions: stale mod loaders/provider state should be less likely to leak across Edit/Play or game-switch sessions.

Gold/Silver now import a label-keyed `rom_text.lua` table and load it into `Game2.data.text`, allowing shared `RomText` readers to use extracted Gen 2 engine strings rather than Lua fallbacks. The remaining 0.2.20 changes are concentrated in ROM/cache hygiene, palette/tile rendering, trade animation, Magnet Train presentation, Yellow title palette tests, and generated Gold/Silver manifest data. No `src/mods` hook/runtime contract file, Bill's PC wrapper seam, battle-clause seam, or public Mod API contract changed in this delta. Nuzlocke therefore requires **no source migration** for 0.2.20. Mod API 2, Save Schema 4, and the `>=0.1.86 <2.0.0` engine range remain unchanged. Exact-edition 0.2.20 runtime smoke testing is still required.

## Randomizer information compatibility

Compatibility API 30 adds spoiler-aware starter information to the public registry. Compatible tools should call `Registry.starterInformation(context)` rather than reading starter cache keys directly. OPEN INFO may reveal the persisted slate; BLIND INFO must not reveal randomized starter species. The returned diagnostic metadata is read-only and consumes no RNG.

Compatibility API 31 adds `Registry.encounterDiagnostics(context)` and augments `Registry.encounterInformation(context)` with read-only spoiler-aware encounter diagnostics. Compatible encounter/tracker tools should treat `encounter_identity` registry changes as logical-area invalidation: Area Split toggles can change Nuzlocke tracker ownership without changing the physical randomized encounter mapping. OPEN INFO may expose live randomized source species and the full registry; BLIND INFO must not return the whole randomized registry or source species. Source/class/time/group/candidate/protection/split/fallback metadata remains available under BLIND.

## Compatibility API 32 Field Item diagnostics

Compatible tools should use `Registry.fieldItemDiagnostics(context)` instead of reading `__nuzlocke_random_field_item_slots` directly. OPEN INFO may reveal canonical persisted randomized item choices. BLIND INFO retains exact edition/table model, ownership, item/category counts, mapping counts/source keys, and fallback diagnostics but must not reveal randomized item choices or their derived semantic category/table class.

The engine's effective item registry remains `game.data.items` in both generations. Nuzlocke normalizes R/B/Y as `GEN1_FLAT` and Gold/Silver as `GEN2_POCKETS`; providers should preserve normal merged item records rather than creating a parallel Nuzlocke-only registry.

## Field Item randomizer compatibility

Visible Field Item randomization remains acquisition-time and cooperative. Providers that expose item definitions may mark required content through key-item pocket/flags, progression/story/quest/required metadata, `randomizable=false`, `nuzlockeRandomizable=false`, or preserve/deny/provider/external/owned randomization policy. These signals are hard protection and cannot be relaxed by later item-pool preferences.

Field-item persistence uses permanent edition/source identity while Randomizer v1 continues hashing the historical semantic source plus authored item. Provider source/object identity should therefore remain stable across reloads when possible.


Phase D repetition-aware providers should supply a stable numeric `sourceId` / `objectId` or explicit `sourceOrdinal` when possible. `UNIQUE` can then use the native ordinal as a deterministic permutation lane; nonnumeric ids are supported deterministically but report degraded uniqueness. Providers should also set `sourceKind="HIDDEN"` for hidden/BG-event items they route through this helper, because visible Field Item ownership intentionally rejects those sources. Legacy calls that omit source-kind context preserve the historical visible-source assumption.

## Semantic enforcement coverage

2.6.55 added a machine-audited coverage map for high-risk cross-mod operations. Compatibility is no longer inferred merely from the presence of a historical hook: the map records the semantic operation, its rule family, enforcement seam, provider surface, and evidence class. The first behavior-level regression suite protects acquisition and randomizer public contracts on every Release Safety run.

STATIC/HARNESS evidence is not Runtime/Provider PASS. Replacement UI or transaction paths introduced by external mods still require exact combination testing when they bypass an engine-native operation.

## Ownership model

Nuzlocke owns its challenge legality and tracking. External content mods continue to own their maps, quests, weather, trainer design, abilities, economies and other systems unless they explicitly delegate a semantic capability.

Prefer this order:

1. explicit live/provider semantic metadata;
2. compatible public capability/provider contract;
3. Nuzlocke fallback knowledge;
4. conservative/unknown behavior when correctness cannot be established.

Do not double-apply a non-core feature when another mod already owns it.

## Canonical provider vocabularies

### Acquisition kinds

The authoritative kind vocabulary is `Acquisition.KINDS`; the enforcement meaning of every kind is `Acquisition.KIND_POLICY`. New kinds must be classified explicitly before they are usable. See `docs/API.md` for the matrix.

### Encounter / learnset randomizer ownership

Canonical values are `allow`, `deny`, and `provider`. Aliases normalize centrally (`preserve/story` → deny; `external/owned` → provider). Providers should not maintain their own shadow vocabulary.

### Battle roles

Use semantic roles such as `rival`, `gym_leader`, `elite_four`, `champion`, and `progression_boss` rather than arbitrary trainer-id substring matching.

## Kanto Reforged 1.5.3

Kanto Reforged is treated as a high-overlap content provider, not a replacement Nuzlocke ruleset.

- **Level caps:** Nuzlocke may compose with KR's live `level_caps_on`/`capFor` system and use the stricter live cap without mutating KR state.
- **Held items:** KR can provide held-item capability on R/B/Y. No Held Items removes player GIVE while preserving TAKE/recovery and does not delete held-item values.
- **Encounter randomization:** curated KR tables can compose with Nuzlocke. KR Full Spawn Mix / Pure Random are provider-owned so Nuzlocke does not double-randomize them.
- **Fixed statics:** source-confirmed KR fixed legendary/mythical encounters are marked static/non-randomizable; roamers are not treated as statics merely because of species identity.
- **Day Care:** KR's custom two-parent R/B/Y Day Care is covered by the custom-deposit guard; withdrawal/recovery remains available.
- **Gold restored content:** restored Viridian Forest uses the generic Dungeon Content API; Mt. Moon/Seafoam already match existing families. Safari remains an area-split concern; Cerulean Cave is not force-classified into a trapping lock.
- **Species/moves:** expanded Gen1–3 metadata/categories should flow through live/provider metadata rather than duplicated Nuzlocke tables.

Combination runtime testing remains required.

## The World 6.54.15

The World is handled capability-first. Nuzlocke does not read private The World save state merely to infer Dynamic Champion, Rocket Ball, WX, weather or simulation semantics.

- dynamic trainer parties/roles may compose through semantic trainer providers;
- expanded species/move data may compose through merged metadata;
- weather/living-world simulation remains externally owned;
- theft/owned-capture style acquisitions can use the public Acquisition API;
- Wonder Trade remains observe-only unless a safe pre-transaction provider seam exists.

Combination runtime testing remains required.

## Safari All + expanded-content acquisition refresh (2.8.97)

- **Safari All 1.1.0:** retained as a legacy source-reviewed scoped encounter target. The current public mod-index snapshot no longer lists it, so this build does not fabricate a newer version or broaden the old contract. Installation alone never delegates global encounter legality.
- **Kanto Ascendant 6.5.17:** current manifest explicitly conflicts with standalone `nuzlocke` and directs users to its integrated ASC RUN system. Nuzlocke therefore removes `kanto_ascendant` from optional dependencies and treats a forced stack as unsupported. Historical difficulty/presentation detection remains defensive only.
- **VanillaPlus 0.3.0:** current source still describes the Lost Bulbasaur, Problematic Squirtle, Scared Kid/Charmander, badge-scaled Rocket ambushes, captain pre-battle healing, and random rewards. Existing exact progression-capture exceptions remain narrow; ordinary ambushes and the no-catch guardian Starmie receive no exception.

## VanillaPlus 0.3.0

VanillaPlus remains owner of its quests/maps/NPCs/rewards/story flags. The audited progression-required captures are identified by exact source context rather than broad species rules. PC Catches may apply only when the source explicitly marks a mandatory progression acquisition and permits the exception; ordinary catches remain subject to normal rules.

## Rule-feedback language contract

Nuzlocke-owned player-facing feedback should use one consistent voice even when the underlying enforcement seam differs.

- **Mechanical block:** identify the rule first and state the prevented action/effect plainly: `[Rule] blocked/prevented [action or effect].`
- **State explanation:** when an action is unavailable because of run state, say what is unavailable and why: `[Action] is unavailable because [rule/state].`
- **World Building:** flavor may lead, but the actual restriction must remain unambiguous. Higher flavor tiers may add personality; they must not obscure whether the action was allowed, blocked, or redirected.
- **Critical / T0:** keep the message short, direct, and mechanically unmistakable. Flavor must never replace the essential rule result.
- **Configuration descriptions:** explain what the rule does first, then its scope/exceptions, then notable interactions. Avoid requiring the player to infer core behavior from flavor text.
- **Provider/delegated feedback:** a provider may own its own presentation, but Nuzlocke-owned fallback messages should follow this same vocabulary rather than inventing a separate tone for each subsystem.

This is a consistency contract, not a requirement that every historical sentence be rewritten at once. New or materially edited feedback should follow it, and future audits may migrate older outliers when doing so does not alter gameplay flow.

## Presentation / UI mods

Modern UI, Wide Menus-style layouts and other presentation mods should own their surfaces. Nuzlocke uses native/classic fallbacks where a shared expanded layout cannot be proven safe. Presentation compatibility is independent from gameplay enforcement confidence.

## Trainer / randomizer / metadata providers

- final trainer-party providers should expose the actual composed team;
- species providers should expose types/BST/classification where possible;
- move providers should expose explicit category metadata where possible;
- encounter providers should identify ownership/randomization policy rather than expecting order-dependent wrapper behavior;
- acquisition providers should call the canonical Acquisition API with a deliberate kind and `captureAttempt` truthfully set.

## Diagnostics / wrapper composition

2.6.57 centralizes the previous install-health recorder into SafeInstall, Hook Registry and Feature Health. Existing owner-aware wrapper/session composition remains authoritative; the registry observes those owners rather than replacing them. A live wrapper installed above Nuzlocke is represented as CHAINED/`DEGRADED`, not automatically as a fatal conflict, because legitimate mods may compose above the Nuzlocke wrapper. Missing required ownership can be represented as `UNAVAILABLE`.

Gen2 adapter installation still uses stable subsystem ids and is now routed through `safeInstall()` via the compatibility `attemptInstall()` alias. Explicit `false` returns no longer masquerade as successful installs merely because `pcall` itself succeeded.

Static/source compatibility claims never imply Runtime PASS. Red, Blue, Yellow, Gold and Silver evidence is tracked independently; provider-interop evidence is also tracked separately from ordinary player-runtime evidence.

## 2.7.56 layout compatibility

Nuzlocke-owned screens now declare an explicit classic, centered, or adaptive layout policy. A public width-provider contract may supply a 304x144 logical surface, but Nuzlocke remains functional without it. Small child flows stay centered; Gen 2 screens remain on native Chrome unless a dedicated wider composition is independently validated.

## Shiny ownership parity (2.8.36 corrective)
Nuzlocke standalone uses the live `pokemon.sprite` seam to establish Gen I wild shiny identity before first art resolution and derives the visible shiny from official Crystal palette pairs. On Gen II, `shiny.roll` and native `mon.shiny`/Gen-II palette rendering remain engine-owned. Any compatible external shiny provider with the audited identity/ownership capability causes Nuzlocke to stand down from both generation and presentation for that edition.

## Shiny provider ownership

Nuzlocke has a complete built-in shiny fallback. When no compatible shiny provider is active, Nuzlocke exposes and owns Shiny Rate, Shiny Colors, and Shiny Intro. When a compatible provider such as `SHINY_POKEMON` is active for the edition, those three Nuzlocke controls are hidden and Nuzlocke immediately becomes a shiny-identity/rules consumer only. Shiny Clause remains Nuzlocke-owned.

On Gen II, Nuzlocke uses the public `shiny.roll` identity seam and the engine's ROM-extracted shiny palettes. The 0.2.27 source still carries the same queued `shiny-flash` event that was runtime-confirmed on 0.2.26 Crystal to leave battler pictures hidden. Until exact-edition 0.2.27 runtime evidence proves the native event safe, Nuzlocke suppresses that event while it owns shiny presentation, restores the picture latches, and continues the native queue. The replacement sparkle remains on `battle.overlay`; Nuzlocke does not own Gen II `draw` or `update`.

### Gen II shiny identity handoff hardening (2.8.36)
When Nuzlocke owns shinies, its Gen II `shiny.roll` wrapper records the exact species/level/DV decision and the following wild battle verifies that the created mon carries the same `mon.shiny` identity. This is a verification/repair layer, not a second roll: matched false decisions remain false, matched true decisions are repaired only if the battle mon lost the boolean, and only builders that bypass `shiny.roll` entirely receive one fail-soft battle-start roll. External shiny providers bypass this layer completely.


## Bag / inventory ecosystem — 2.8.97 source audit
- **Useful Bag 2.6.3**: canonical `save.inventory` / `Bag.order` remains the hidden bag; pocketing/capacity/presentation compose externally.
- **Modern Bag UI 0.4.5**: presentation/capacity owner; current documentation preserves owning native controllers for item use, party targeting, battle turns, TMs/HMs, tossing and contextual items.
- **Bag Sort 0.1.0**: order-only target.
- Nuzlocke item restrictions are semantic, never pocket-index/list-row based. No Buying/Selling are transaction rules independent of storage size. Expanded x999 storage does not alter GameplayTransactions exactly-once requirements.
- Combined runtime certification remains pending.


## Expanded species / Dex-provider audit — 2.8.97

- **Dex Overflow 0.1.1** is retained as a legacy reviewed Gold target. The current public index/source surface did not resolve a newer/current package during this audit, so no newer-version claim is made.
- Generic expanded-species compatibility is capability-based through the existing `species_metadata` and `species_evolutions` contracts, not tied to a particular Dex mod id.
- Challenge classification reads the final merged species record plus provider metadata for BST, types, generation, legendary/mythical/pseudo flags. Unknown provider schemas fail open instead of falsely banning an expanded species.
- 2.8.97 closes a normalized-facts gap: when a merged species row lacks evolutions but the selected metadata provider supplies them, `getSpeciesFacts(...).evolutions` now carries the provider evolution data.
- Maximum BST, species bans, Type Locke and Randomizer eligibility remain based on merged/provider facts. Indexless species are allowed into runtime Randomizer pools only when the final merged record is battle-safe; byte-addressed script/link paths remain excluded.
- Run History remains identity/event based and must preserve canonical string species ids rather than forcing expanded species into the native 151/251 numeric range.
- No new provider capability/API version was required. Combined expanded-Dex runtime certification remains pending.


# Type-system compatibility audit — 2.8.97

Nuzlocke's type-sensitive challenge surfaces now share the normalized final species facts path: Type Locke, Maximum BST/species filters, Randomizer classification, and Game Difficulty species/STAB/type-item choices consume merged species data plus the established `species_metadata` composition contract rather than introducing companion-specific type tables.

The engine's API-2 data model defines `pokemon.types` as id-typed fields resolved after registry merge, and `type_chart` is a deep merged registry. Random Starter Trio Typing continues to consume the live `game.data.type_chart.matchups`, so Steel/Dark/Fairy and compatible chart patches are evaluated from the running game's merged chart rather than a copied Nuzlocke chart.

- **Delta Type 1.2.0** remains the explicit transformed-Pokemon target. Concrete runtime Pokemon typing remains authoritative for Type Locke; base/provider species facts are fallback before a concrete transformed mon is available.
- **STEEL/FAIRY AND TYPING CHARTS 2.0.1 (`steel_typing`)** remains an explicit optional companion. No private type-chart implementation is copied into Nuzlocke.
- Unknown truly custom type identifiers outside Nuzlocke's stable 18-type Type Locke vocabulary continue to fail open rather than being falsely rejected.
- Game Difficulty's species matching, STAB scoring, and type-themed held-item selection now use the normalized species-facts type path instead of directly assuming `def.types` is the complete compatibility surface.

No Runtime PASS is claimed; exact-edition and combined-mod testing remains required.


## Transfer / Stadium / Crystal-251 acquisition provenance — 2.8.97 audit

This pass re-audits Pokémon that enter a save outside ordinary wild capture and scripted gift/trade transactions. The existing `nuzlocke_acquisition_provenance` v2 surface remains the correct cooperation point for Stadium prize/import providers. Presentation/model import alone never implies that a Pokémon was acquired from Stadium. A provider must explicitly mark the concrete created Pokémon with `mark()` / `markImported()` or preserve equivalent provenance fields.

Current Gen1Recomp link protocol serializes Pokémon as plain data and reconstructs derived stats from the receiver's live species data. Gen-I wire records preserve OT/OT ID and the JSON-safe `extra` namespace; Gen-II codecs also preserve held item, happiness, Pokérus, caught level, egg state and `extra`. This is favorable to durable Nuzlocke-owned metadata where a supported transaction actually carries it, but serialization support is not itself an acquisition-policy seam.

The upstream Gen-II link design explicitly states that the Gen-II trade session/UI/mail transaction is not yet built. Nuzlocke therefore does **not** invent a Gen-II transfer veto or claim trade certification from the existence of `packMon2`/`unpackMon2`. When a future engine transaction exists, compatibility must be reviewed at its actual pre-commit/commit event boundary.

Crystal-251 remains an overlay/content/importer compatibility surface. It never changes the exact running edition identity. Stadium/Crystal presentation detection is diagnostics-only; acquisition origin is explicit-only.

Wonder Trade remains post-mutation observe-only: `pokemon.received` / `trade.completed` occur after replacement, so Nuzlocke preserves the received Pokémon and does not perform destructive rollback. Wonderlocke remains WIP until a safe pre-transaction cooperation seam exists.

Run History and persistent identity consume explicit Pokémon provenance when available. Unknown imported/edited Pokémon must remain EXTERNAL/UNVERIFIED or legacy-recovered rather than being guessed into a route, gift, trade, Stadium, or encounter slot.


## Upstream attribution and shiny lineage (2.9.24)

The original Nuzlocke project baseline was created by **bryanthaboi**. The original Shiny Pokémon mod was created by **masterwebx**; that implementation/project is part of the code/design lineage and technical foundation behind the shiny ecosystem this project integrates with. **Stone696** maintains the current Nuzlocke project and the maintained Shiny Pokémon fork.

Nuzlocke's current built-in shiny subsystem has been substantially reworked around current Gen1Recomp public seams and single-owner compatibility architecture. Attribution to masterwebx is therefore retained as project/code-design lineage rather than a claim that the current subsystem is a wholesale copy of the original mod.


## Newly source-reviewed in 2.9.27

### Double Battles 0.6.1
Explicit coexistence target; **SOURCE/COMPATIBILITY REVIEWED — COMBINED RUNTIME TEST REQUIRED**. Double Battles owns its multi-battler turn loop, target selection, partner/refill state and double-battle presentation. Nuzlocke retains challenge legality, catch/ball/item restrictions, durable faint/death/permadeath state, encounter provenance and run history. Nuzlocke does not replace Double Battles' private turn loop. Focused testing should cover wild/trainer doubles, catching either target, switching, blocked items, faint/death/whiteout handling, trainer completion and Random Trainers composition.

### Free Fly 1.8.0
Explicit coexistence target; **SOURCE/COMPATIBILITY REVIEWED — COMBINED RUNTIME TEST REQUIRED**. Free Fly owns airborne movement, landing/story/badge gates, its FREEFLY party action, aerial interception and flight lifecycle. Nuzlocke retains challenge/acquisition legality and must not infer encounter consumption merely from airborne traversal. Free Fly's optional quick-start gift remains subject to ordinary Nuzlocke acquisition legality/provenance where a safe acquisition seam is observable; Nuzlocke must not destructively roll back an external post-mutation gift. Focused testing should cover Travel/Dungeon/Gym lock-ins, field-move legality, aerial encounters, blackout/permadeath, and quick-start gift handling in Gen I and Gen II.


## Blackjack Corner 0.8.2

**Source/Compatibility Reviewed — Runtime Test Required.** Blackjack Corner is treated as a high-overlap external content/minigame owner. Its starter/prize Pokemon and item delivery, casino economy, shiny presentation/provider composition, trainer content, and world/progression presentation remain externally owned. Nuzlocke retains challenge legality and provenance through cooperative semantic pre-transaction acquisition seams when available; post-mutation observation must never trigger destructive rollback. Ordinary Mart buy/sell hooks are not assumed to own casino coin conversion or other distinct transactions. No manifest dependency is declared solely for recognition.

## Semantic multi-active battle and activity state

Compatibility API 37 adds observational `nuzlocke.battle` and `nuzlocke.activity` surfaces. Multi-battler mods can advertise `battle_roster` and return plural active combatants without surrendering their turn-loop ownership. Travel/activity mods can advertise `activity_state` instead of forcing consumers to infer state from private movement/UI fields. Missing providers return conservative native/unknown observations and do not create gameplay authority.

## Hold-to-scroll / input-repeat UI mods

WizzStar HoldToScrollUI 1.1.0 is a reviewed compatibility target by repository/release behavior. It advertises menu-only D-pad repeat, standard input/ListMenu composition, all six editions, and battle/minigame bypasses. Nuzlocke's UI input-semantics contract marks navigation/value stepping as repeat-safe where appropriate and activation/back/destructive confirmation as edge-only semantics. Combined runtime testing is still required; this review does not claim package-source or Runtime PASS evidence.



## Gen1Recomp 0.2.41 source review

Nuzlocke 2.9.70 advances its source-review baseline to Gen1Recomp 0.2.41 release commit `3d3a9ba4b66832b8c70ac26e1e88dbae612efcd0`. Upstream Mod API remains 2, Link Protocol remains 2, Save Format remains 5, and the ROM cache remains `rom-cache-v5`.

The 0.2.40→0.2.41 delta is primarily platform/launcher expansion, presentation-pacing hardening, and Gen-II save-export map-context support. `FixedStep` now more aggressively bounds catch-up debt and reseeds pacing after discarded catch-up; `PresentSync` continues to own display-sync probing and FixedStep refresh-period application. Those systems remain engine-owned: Nuzlocke does not wrap, reset, reprobe, cap, or retime them.

Gen-II save conversion gained map-context support for export. Nuzlocke does not own raw SRAM export and no Nuzlocke save-schema migration is required. No Nuzlocke-critical public mod-loader/provider contract break was found by source review. Exact-edition runtime certification remains separate.

## HGSS Visual Overhaul 1.0.2

`HGSS_SPRITES` 1.0.2 is an explicit Yellow presentation compatibility target. Source review found scoped PartyMenu/ListMenu and BattleState presentation wrappers that chain previously installed implementations. Nuzlocke therefore yields overworld, Party/PC, and battle-art presentation while retaining challenge legality, provenance/tracker state, transactions, and Random Trainer party authority when enabled.

The shared `BattleState.newTrainer` seam is intentionally order-independent: Nuzlocke may wrap an earlier presentation implementation or itself be wrapped later. Nuzlocke does not require itself to remain the outermost constructor wrapper. Combined runtime certification is still required, especially for Random Trainers, HGSS Party/PC presentation, shiny artwork, and one voxel renderer.
