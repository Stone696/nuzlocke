## 2.0.0-beta.29.2.7 — runtime-driven startup and cap compatibility
- Documented pre-battle composed-party cap preview, R/B starter-presentation correction, lock-in section move, and current Yellow runtime evidence.
- Added focused regression targets for Stronger Trainers cap display and protected Yellow menu glyph/QoL behavior.

# Documentation Changelog

This file records public-document changes separately from gameplay/code changes. `CHANGELOG.md` remains the authoritative product/version history. Documentation entries explain what changed and the reason/goal so future releases do not silently rewrite the public record.

## 2.0.0-beta.29.2.5 — startup/UI and compatibility documentation

### Public docs

- Renamed B-button running to **Running Shoes** and documented its Quality-of-Life placement.
- Documented the R/B starter preview correction, Yellow randomized-starter post-lab presentation handling, lowered Trainer Card prompt, Maximum BST digit editor, and final-composed trainer-cap observation.
- Promoted new Blue/Yellow runtime PASS evidence while leaving repeated opening-sequence dialogue as an unresolved regression target.
- Kept the right-arrow/down-arrow collapse-glyph contract explicit for Setup and in-game Rules.

### Internal docs

- Added beta.29.2.5 lineage, Stronger Trainers compatibility rationale, protected Yellow First Rival Mercy evidence, and focused startup/dialogue regression tests.

## 2.0.0-beta.29.2.4 — common route-split documentation

### Public docs

- Replaced blanket Route 1–25 split wording with the independently selectable Route 2, Route 10, and Route 20 rules.
- Added the geography/progression rationale for each common split and documented legacy CARDINAL-save migration behavior.
- Updated the compatibility API description to retain `routes = 0` while exposing `route_2`, `route_10`, and `route_20`.
- Preserved Mt. Moon/Safari split documentation and all beta.29.2.3 numeric-hardening notes.

### Internal docs

- Added beta.29.2.4 lineage, migration safety, regression obligations, and protected encounter-history behavior.

## 2.0.0-beta.29.2.3 — numeric-boundary and review documentation

### Public docs

- Advanced current candidate references to beta.29.2.3.
- Documented finite-number Setup/profile hardening as a defensive corrupted/external-input safeguard, not a change to normal gameplay arithmetic.
- Preserved the beta.29.2.2 lock-in and trainer-cap runtime obligations.

### Internal docs

- Added durable conclusions for the latest investigated RAM, serialization, reload, RNG, Safari, turbo, logging, shadowing, and faint-transition edge cases.
- Recorded why no production change was made for rejected or unconfirmed reports, what protected behavior discouraged speculative changes, and what evidence would justify reconsideration.
- Added finite-number corruption regression coverage and retained persistent-history idempotence/static-tooling follow-ups.

## 2.0.0-beta.29.2.2 — lock-in and compatibility documentation

### Public docs

- Documented **Gym Lock-In** and **Dungeon Lock-In**, including Setup/NUZ RULES availability, already-cleared Gym behavior, conservative multi-exit dungeon coverage, and older-save fail-open handling.
- Documented Dungeon Lock-In protection against Escape Rope plus Dig, Teleport, and Fly when those field moves would otherwise provide an escape path.
- Clarified that Level Cap Scope **POST** is the current postgame/additional-content provider scope rather than restoring the retired separate toggle.
- Documented broader nested trainer-roster ace discovery as compatibility hardening that still requires runtime validation against modified trainer content.
- Updated install guidance for the known launcher behavior that can offer an older published build for this multi-part beta tag line; manual installation of the newest package remains recommended.
- Updated current candidate identity, feature-confidence notes, runtime matrix, and validation counts for beta.29.2.2.

### Internal docs

- Recorded the immediate-parent lineage and protected beta.29.2.1 paths.
- Added durable rationale for confirmed fixes and for reviewed speculative issues that did not justify production changes.
- Added targeted lock-in, trainer-cap, Permadeath, and updater regression obligations without attributing them to ephemeral discussion history.
- Retained the documentation-provenance isolation rule: project records preserve durable facts, evidence, decisions, and uncertainty without embedding ephemeral source references.

## 2.0.0-beta.29.1.1 — starting-money hotfix documentation

### Public docs

**Changed**
- Advanced current-version references to beta.29.1.1.
- Documented the corrected R/B/Y $3,000 default while preserving an explicitly selected $0.
- Downgraded current-version Starting Money confidence to TEST REQUIRED pending runtime confirmation of the hotfix.

**Reason / goal**
- Keep player-facing defaults and confidence claims aligned with the runtime-confirmed beta.29.1.0 regression and the narrow beta.29.1.1 fix.

## 2.0.0-beta.29.1.0 — Gen1Recomp 0.1.83 release-readiness documentation

### `README.md`

**Changed**
- Updated candidate lineage to beta.29.0.2 → beta.29.1.0 with no intended gameplay delta.
- Replaced the former 0.1.82-audit backlog item with the completed 0.1.83 source audit and remaining 0.1.83 runtime certification.
- Added the widened `>=0.1.81 <0.1.84` range and the Mod Manager beta/update test caveats.

**Reason / goal**
- Make the landing page match the engine actually being used for release testing without overstating source review as gameplay runtime proof.

### `docs/USER_GUIDE.md`

**Changed**
- Updated Known Beta Limitations for 0.1.83 source-audited/runtime-pending support.
- Added guidance not to use the Update action on an unpublished local candidate.

**Reason / goal**
- Prevent a tester from accidentally replacing a newer local build with the latest older public release and clearly separate engine-source compatibility from runtime certification.

### `docs/COMPATIBILITY.md`

**Changed**
- Added distinct 0.1.81, 0.1.82, and 0.1.83 engine rows.
- Documented the exact-source 0.1.83 seam audit, the new Gold `mapOverview()` opportunity, and the current beta-tag update-status limitation.

**Reason / goal**
- Publish the exact basis for widening the engine range while keeping untested runtime claims conservative.

### `docs/API.md`

**Changed**
- Advanced `audited_recomp` documentation to 0.1.83 and documented the explicit engine profiles/range.
- Reaffirmed that Gen1Recomp Mod API remains 2 and is independent of Nuzlocke Compatibility API v25.

**Reason / goal**
- Keep integration metadata synchronized with the exact engine audit and prevent API-namespace confusion.

### `docs/FEATURE_CONFIDENCE.md`

**Changed**
- Clarified that beta.29.1.0 is an engine-profile revision, not a new gameplay implementation revision.
- Preserved the beta.29.0.2 regression-confidence reductions until their runtime tests pass on 0.1.83.

**Reason / goal**
- Do not let a successful source audit incorrectly raise gameplay confidence.

### `mod.card` and `manifest.json`

**Changed**
- Advanced version metadata to beta.29.1.0.
- Widened engine compatibility to `>=0.1.81 <0.1.84`.
- Added 0.1.83 runtime-pending and beta-update-status notes to human-facing known limitations.

**Reason / goal**
- Allow the current engine release to load the candidate for certification while accurately communicating remaining release obligations.

### `CHANGELOG.md`

**Changed**
- Added beta.29.1.0 as a distinct compatibility-profile revision with parent, rationale, exact-source findings, carried runtime evidence, and remaining tests.

**Reason / goal**
- Preserve the compatibility decision contemporaneously instead of reconstructing it later.

## 2.0.0-beta.29.0.2 — reviewed bug-fix candidate documentation

### `README.md`

**Changed**
- Replaced the pre-runtime blocker section with the four implemented reviewed fixes and their remaining runtime-test obligation.
- Updated the current-version summary from documentation-only hardening to the narrow gameplay-fix scope.
- Updated the current-version change summary.

**Reason / goal**
- Keep the landing page aligned with the candidate actually being tested without presenting static fixes as runtime-confirmed behavior.

### `docs/USER_GUIDE.md`

**Changed**
- Updated candidate version and Known Beta Limitations to identify the newly fixed paths that still require runtime confirmation.

**Reason / goal**
- Prevent older runtime evidence from being read as confirmation of code paths changed in beta.29.0.2.

### `docs/FEATURE_CONFIDENCE.md`

**Changed**
- Lowered current confidence/status on First Rival Mercy, Gold PC-routed acquisition/Catch Info, One Per Area, Nickname Rule, and No Static where beta.29.0.2 changed implementation.
- Added the four reviewed-fix regressions to the highest-priority confidence gaps.

**Reason / goal**
- Preserve historical runtime evidence while requiring new runtime evidence for materially changed paths.

### `docs/TESTING.md`

**Changed**
- Replaced the documentation-only candidate identity with the beta.29.0.2 four-fix delta.
- Updated structural-gate result to 49/49 and placed the four reviewed fixes at the front of the runtime matrix.

**Reason / goal**
- Make the release-test obligations precise and reproducible.

### `mod.card`

**Changed**
- Removed the three now-fixed code-review blockers from known issues and replaced them with a targeted runtime-confirmation note.

**Reason / goal**
- Distinguish an implemented-but-unverified fix from a known unfixed defect.

### `CHANGELOG.md`

**Changed**
- Added the beta.29.0.2 goal, fixes, protected behavior, and validation status.

**Reason / goal**
- Preserve exactly why each reviewed fix was implemented and what behavior it was intended not to disturb.

## 2.0.0-beta.29.0.1 — release-candidate documentation line

### Release-candidate rebuild

**Changed**
- Standardized public credit wording to bryanthaboi as original author and Stone696 only as updater.
- Removed feature-level/tester attribution language from public documentation.
- Renamed the internal contribution/backlog audit to an attribution-neutral backlog/runtime audit.
- Removed platform-specific provenance references from internal development records.
- Tightened compatibility-document wording so it stays focused on interoperability evidence.
- Updated the structural release gate to enforce the narrower public credit wording.

**Reason / goal**
- Keep public credit simple and limited to the intended project roles.
- Keep internal records focused on technical evidence, decisions, runtime results, and backlog state.
- Keep compatibility documentation focused on interoperability evidence.

### `README.md`

**Changed**
- Reworked the repository opening around collective feature highlights and recent major additions.
- Added a runtime-evidence and regression-protection section.
- Expanded planned work into In Progress, Planned, and Under Consideration/Future so previously discussed Wonderlocke, optional battle-menu shortcuts, and native Pokémon-icon ideas do not silently disappear.
- Added the current pre-runtime code-review blockers so confirmed edge cases are not hidden by older runtime evidence.
- Standardized Credits to the original author and the current updater.

**Reason / goal**
- Make the repository landing page communicate the mod's real current scope quickly.
- Preserve runtime evidence as regression history without assigning feature-level credit.
- Keep previously discussed future ideas visible while clearly distinguishing them from committed features.

### `docs/USER_GUIDE.md`

**Changed**
- Added runtime-evidence guidance and standardized Credits.
- Added the current pre-runtime code-review blockers to Known Beta Limitations.

**Reason / goal**
- Make the relationship between runtime evidence, regression protection, and confidence labels explicit.

### `docs/API.md`

**Changed**
- Added explicit API namespace terminology: Gen1Recomp Mod API 2 versus Nuzlocke Compatibility API 25, compatibility floor 10, and save schema 4.

**Reason / goal**
- Prevent independent API/version namespaces from being confused in future development or integration documentation.

### `docs/FEATURE_CONFIDENCE.md`

**Changed**
- Downgraded affected Gold acquisition/static confidence rows to Known Issue where current code review found a real gap.
- Reduced R/B/Y Nickname Rule confidence slightly because scripted gift/starter history-name synchronization is also affected there.

**Reason / goal**
- Runtime history must not override a newly confirmed current-code defect; confidence reflects the candidate actually being reviewed.

### `mod.card`

**Changed**
- Standardized credits to the original author and current updater.
- Added the current user-visible code-review blockers to human-facing known limitations.

**Reason / goal**
- Keep human-facing mod metadata aligned with the README/User Guide credit wording.

### `CHANGELOG.md`

**Changed**
- History-recovery pass restores additional evidence-backed development details, preserves conflicting historical records explicitly, and adds known intermediate development revisions where supported.

**Reason / goal**
- Make every recoverable development step durable so later releases do not need to reconstruct history from memory or whichever old ZIP happens to survive.
