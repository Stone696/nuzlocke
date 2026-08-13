# Compatibility

This document records compatibility claims for Nuzlocke `2.0.0-beta.29.1.0`. A compatibility percentage is an evidence-weighted confidence estimate, not a measured failure rate.

Repository/release metadata in the named-project table was refreshed on **2026-08-13** where a canonical repository could be verified. Historical test confidence remains attached to the exact tested/reviewed version, not automatically to the refreshed latest release.

## Engine support

| Gen1Recomp | Status | Confidence | Evidence |
|---|---|---:|---|
| **0.1.81** | Supported / historical audited profile | **96%** | Protected source profile plus substantial R/B/Y and Gold runtime history from the beta.28/29 line. |
| **0.1.82** | Source-audited / supported by range | **88%** | Exact-source review confirmed the protected battle, item, shop, save, UI, and Gold script seams remain available; exact 0.1.82 gameplay runtime coverage is limited. |
| **0.1.83** | Current source-audited profile / runtime test required | **88%** | Exact v0.1.83 source review confirms Gen1Recomp Mod API 2, save format 4, and the Nuzlocke wrapper signatures/contracts. Mod Manager import/discovery and the old-version gate were exercised on 0.1.83; gameplay certification remains pending. |

The candidate manifest uses `>=0.1.81 <0.1.84`. Widening the range is based on exact-source compatibility review, not on assumed forward compatibility. Runtime approval on 0.1.83 remains a release requirement.

Gen1Recomp 0.1.83 adds a public Gold `mod.world:mapOverview()` surface without removing the existing Nuzlocke tracker seams. This candidate intentionally keeps the established ENC TRACKER implementation unchanged; a future migration can be considered only after behavioral equivalence is demonstrated.

### Mod Manager beta-release limitation

Current Gen1Recomp release parsing compares beta-tagged releases by their leading `x.y.z` triple. A tag such as `2.0.0-beta.29.1.0` can therefore be presented as `v2.0.0 available` even when the installed beta is current. This is an update-status limitation, not a Nuzlocke gameplay compatibility failure.

An unpublished local candidate is also ahead of what the repository can serve: using **Update** on that local build installs the latest **published** Nuzlocke release. Manual import should be used for unpublished runtime candidates. The public release requires an end-to-end update test after publication.

## Game targeting

The candidate declares exactly:

```json
"games": ["red", "blue", "yellow", "gold"]
```

Gold support does not imply Silver/Crystal support.

## Compatibility architecture

Nuzlocke compatibility API v25 separates:

- **engine compatibility** — audited engine profiles and generation-specific seams;
- **mod compatibility** — capability discovery and `compose`, `delegate`, `exclusive`, `observe`, or `incompatible` relationships.

Discovery is capability/behavior based rather than a hard-coded mod-name allowlist. Providers are revalidated against the active loader composition so stale disabled providers do not remain authoritative.

Important capabilities include item use, shopping, healing, battle finish, Trainer Card/party/start menus, screens, encounters, static encounters, trainer parties, boss caps, Pokémon identity, species metadata, battle classification, movement speed, and starter randomization.

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
