## 2.5.23 local gate baseline
2.5.23 adds regression ratchets for a class that normal Lua syntax compilation does not catch: an identifier intended to be a local can be referenced outside its lexical block and compile successfully as a global lookup, only failing when the runtime path executes. Critical cross-phase helpers therefore must be passed explicitly or exported through an intentional internal surface; staged runtime closures must be proven to execute before their staging slot is cleared; and wrapper tails must remain physically inside the installer that owns their captured locals.

The exact 2.5.22 Yellow runtime failures are now represented in the development gates: Random Starter must consume the explicitly exported seeded-index helper, the R/B/Y field-command installer must own its `heal_party` / `Commands.resolve` / `give_pokemon` tail, late-runtime phase 2 must execute, and fresh `save.created` must revalidate the critical heal/starter command wrappers. CI mutation checks deliberately reintroduce each structural break and require the invariant suite to reject it.

Before runtime testing, run `node tests/invariants.js .`, `NUZLOCKE_STRICT=1 node tests/invariants.js .`, `node tests/verify_parent.js <2.5.22 player zip>`, and `bash tests/package_gate.sh /tmp`. All invariant checks should pass with zero warnings. Lua 5.1/LuaJIT compilation remains required in CI when available, but syntax compilation is not considered proof of lexical ownership or staged-phase execution.

### Fresh-New-Game runtime matrix
For Yellow, exercise a fresh NEW GAME with Skip Opening Intro plus Random Starter, Skip Catch Demo, and No Mom Heal enabled. Verify Random Starter does not silently fall back to Pikachu, the same seed is deterministic, Oak's Pallet demo is skipped without breaking the lab story, the starter is logged under Pallet Town, and Mom does not heal. DEV SELF TEST should show healthy late-runtime-phase-2, Oak-demo, R/B/Y starter-transaction, and Mom-heal rows.

## 2.5.22 local gate baseline
The 2.5.22 gate adds two reliability ratchets. Gen 1 kerning must read/write an exact `_nuzlockeKerningSession`, prove live wrapper identity, unwrap only an exact top-level stale Nuzlocke session, and fail closed on ambiguous legacy/foreign chains. Starter randomization must derive its namespace from `Randomizer.algorithmVersion` and call the shared `seededIndex("STARTER", ...)` helper; current RNG-version labels must also derive from the shared version source. Mutation checks should fail if either path is reverted to a hardcoded/stale-marker implementation.

Before runtime testing, run `node tests/invariants.js .`, `NUZLOCKE_STRICT=1 node tests/invariants.js .`, `node tests/verify_parent.js <2.5.21 player zip>`, and `bash tests/package_gate.sh /tmp`. All invariant checks should pass with zero warnings.

## 2.5.21 local gate baseline
The 2.5.21 gate adds trainer-identity consistency checks on top of the 2.5.20 persistence/enforcement policy checks. `trainer_rewards.lua` must expose one shared normalized ID/class/name extractor, reward recognition must consume it, and R/B/Y + Gold League progression must consume the same extractor rather than reconstructing a private id/name-only path. The gate covers Gen 1 `oppClass`, generic provider `trainerClass` / `opponentClass`, and Gold `trainer.classId` / `trainer.class` aliases.

## 2.5.20 local gate baseline
The 2.5.20 gate adds policy-aware battle-writer checks. Persistent writers are classified by intent instead of being forced through one blanket `active()` rule: **PASSIVE_PROGRESS** writers must prove save-write safety but may run while Nuzlocke is OFF; **RULE_ENFORCEMENT** writers must stop when the master switch is OFF and when a newer unsupported schema is read-only. The gate specifically covers league progression, Failed Encounter, Forgiveness Tokens, encounter arming, and post-battle Permadeath cleanup.

Before runtime testing, run `node tests/invariants.js .`, `node tests/verify_parent.js <2.5.19 player zip>`, and `bash tests/package_gate.sh /tmp`. All invariant checks should pass with zero warnings.

# Nuzlocke development and testing

## Zero-cost automated checks

The repository CI is designed for GitHub's standard `ubuntu-latest` runner. It does not request larger runners, upload Actions artifacts, call the OpenAI API, or depend on a paid third-party service.

On pushes to `main`, pull requests, and manual workflow runs, `.github/workflows/nuzlocke-ci.yml` performs:

1. version / schema / API / package invariant checks;
2. Lua 5.1 syntax compilation for every player Lua file;
3. LuaJIT bytecode compilation for every player Lua file;
4. deterministic 15-file player-package creation and ZIP integrity/file-set validation;
5. latest-commit whitespace checking.

The CI-generated ZIP is temporary and is not uploaded as an Actions artifact. A human/runtime-tested build is still the release source of truth.

## Local commands

From the repository root:

```sh
node tests/invariants.js .
luac5.1 -p main.lua
luajit -b main.lua /tmp/nuzlocke-main.luac
bash tests/package_gate.sh /tmp

The package gate is reproducible: it fixes ZIP metadata, rebuilds the archive a second time, and fails if the two SHA-256 values differ.
```

When the immediately previous canonical ZIP is available locally, additionally run:

```sh
node tests/verify_parent.js /path/to/Nuzlocke_<parent>.zip
```

That gate hashes the actual parent ZIP and verifies the parent ZIP's `manifest.json` version against the `parentVersion` / `parentSha256` embedded in the current child.

## Invariant policy

CI failures are build blockers. Warnings identify existing technical debt that should not increase. `NUZLOCKE_STRICT=1 node tests/invariants.js .` may be used during cleanup work to promote warnings to failures; normal CI intentionally does not turn inherited debt into an unrelated release blocker.

Every confirmed runtime bug should eventually gain an automated regression check where a reliable headless seam exists. Runtime evidence remains stronger than static/CI evidence.

## Packaging boundary

The player package remains exactly 15 approved files. `.github/`, `tests/`, `docs/TESTING.md`, and `docs/development/` are repository-development material and are excluded by `.modkitignore`.

## Current contracts for 2.5.23-DEV

- Save Schema: 4
- Compatibility API: 28 (`compatible_from = 10`)
- Diagnostics API: 1
- Gen1Recomp Mod API: 2
- Engine range: `>=0.1.86 <2.0.0`
- Player package: exactly 15 files

Compatibility API 28 adds per-capability contract versions. Existing API-27 capability names and meanings remain compatible; each currently advertised capability begins at contract version 1. The 2.5.20 persistence/enforcement policy helpers are internal development surfaces and do not change the public API version.
