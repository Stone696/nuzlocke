# Testing and release validation

This repository keeps automated checks and runtime evidence separate. Automated checks reduce regressions but do not replace in-game testing.

## Candidate identity

- Nuzlocke: `2.0.0-beta.29.1.0`
- Parent build: `2.0.0-beta.29.0.2`
- Intended gameplay delta: **none; engine compatibility/profile revision only**
- Manifest engine range: `>=0.1.81 <0.1.84`
- Exact source-audited Gen1Recomp: `0.1.83`
- Games: Red, Blue, Yellow, Gold
- Save schema: 4

## Local checks

### Structural release gate

```sh
node tests/release_gate.js main.lua
```

When a matching Gen1Recomp source checkout is available:

```sh
node tests/release_gate.js main.lua /path/to/gen1recomp
```

### Gen1Recomp modkit

Run from a compatible Gen1Recomp checkout with the candidate installed as a mod folder:

```sh
python3 tools/modkit.py validate mods/nuzlocke --base imported
python3 tools/modkit.py lint mods/nuzlocke
python3 tools/modkit.py gen2check mods/nuzlocke
```

Do not mark these PASS unless the commands actually executed against the intended engine source/build.

### Behavior smoke suite

```sh
luajit tests/smoke.lua
```

The suite may be marked PASS only when a compatible LuaJIT/Lua environment actually executes it.

## Candidate preparation results

- **PASS:** local structural release gate — **55/55 checks**.
- **PASS:** manifest JSON parses and all candidate-facing version strings agree.
- **PASS:** prohibited provenance-text scan for release/repository artifacts.
- **PASS:** player-package layout excludes repository-only `docs/development/`, tests, issue templates, and development dotfiles.
- **PASS:** player and repository candidate ZIP integrity tests.
- **NOT EXECUTED HERE:** upstream `modkit validate`, `modkit lint`, and `modkit gen2check`; the current preparation environment does not contain a full local Gen1Recomp 0.1.83 source/imported-data checkout.
- **NOT EXECUTED HERE:** LuaJIT behavior smoke suite; this preparation environment does not provide a compatible Lua/LuaJIT executable.

These NOT EXECUTED items remain release-test obligations rather than being treated as passes.

### Exact-source 0.1.83 compatibility audit

Read-only inspection of the exact Gen1Recomp v0.1.83 source confirmed the protected Nuzlocke seams remain present with compatible call shapes: Gen 1 `BattleState` construction/throw/faint/finish/nickname/damage methods, `Status.residual`, `ItemEffects.use`, `ShopMenu.new`, SaveData persistence/slot helpers, Gold `BattleState:finishBattle`, Gold `Specials.block`, Gold `Vm` `loadwildmon`, the shared Gold battle lifecycle events, and the Gold MainMenu title-menu contract. Gen1Recomp Mod API remains 2 and engine save format remains 4.

The 0.1.82→0.1.83 delta is limited to launcher/importer work plus the additive generation-neutral map-overview API. No protected Nuzlocke gameplay wrapper requires a compatibility rewrite for this candidate.


## Current runtime evidence

### Gen1Recomp 0.1.83 Mod Manager / compatibility gate

- PASS: manually imported beta.29.0.2 was discovered with its Nuzlocke version, BALANCE category, GEN 1+2 targeting, and R/B/Y/Gold enable toggles.
- PASS / expected: beta.29.0.2 was blocked as incompatible because its manifest explicitly required `<0.1.82` while the engine was 0.1.83.
- PASS plumbing / test-build caveat: pressing Update on the unpublished local beta.29.0.2 installed the latest published Nuzlocke release (beta.27.16). This confirms repository update/download/install plumbing, but unpublished candidates must be imported manually.
- Known engine limitation: beta-tag release comparison may show a redundant `v2.0.0 available` notice because the release parser compares the leading `x.y.z` triple.
- NOT YET TESTED: beta.29.1.0 loading as Ready on 0.1.83 and gameplay behavior under the widened range.

### Gold

- PASS: NEW GAME reaches Nuzlocke Setup.
- PASS: collapsible Setup sections work.

### Yellow existing save

- PASS: broad rule behavior appeared healthy in the latest reported pass.
- PASS: numeric/multi-state selection uses A or Left/Right rather than consuming Up/Down navigation.
- PASS: collapsible Rules sections work.
- PASS: after Save Editor modification followed by a full application restart, No TMs and No Rare Candy worked.

## Priority runtime matrix for the next approval cycle

1. Gen1Recomp 0.1.83 hard gate: import beta.29.1.0, confirm the Mod Manager row is **Ready** rather than Incompatible, and confirm R/B/Y/Gold targeting remains correct.
2. 0.1.83 startup smoke: Gold fresh Setup/New Game boot plus Yellow existing-save NUZ RULES/ENC TRACKER/Catch Info access before deeper rule testing.
3. R/B/Y mandatory starter/gift nickname: chosen nickname remains on the live Pokémon and the matching history row stores the same nickname.
4. Gold normal party-delivered scripted starter/gift: naming, tracker/history, and area behavior remain unchanged.
5. Gold full-party scripted gift: Pokémon is delivered to PC storage, receives the required nickname, appears in history/tracking, and consumes the intended area exactly once.
6. Gold scripted static: genuine fixed encounter is still classified static and No Static blocks it when enabled.
7. Gold stale-static regression: scripted-static setup followed by a trainer battle, then an ordinary wild encounter; the trainer consumes the pending marker and the later wild remains catchable with No Static enabled.
8. First Rival Mercy: opening Rival forgiveness arms once, forgiven faint retains native battle/loss flow without Nuzlocke death/Whiteout mutation, and later Rival battles cannot reuse it.
9. Maximum BST at representative values and at OFF/000.
10. Player/Wild/Trainer Stat EXP presets at representative values.
11. No Stat EXP Gain through battle and relevant vitamin paths while normal EXP/levels continue.
12. Perfect Player/Wild/Trainer DV controls individually and in combination.
13. No Pseudos across catch/gift/trade paths that are in scope for each game.
14. Temporary-party battle: healthy restored reserve prevents false Whiteout; restored dead Pokémon is reconciled by Permadeath.
15. Gold field-item, shop, and Whiteout paths already marked TEST REQUIRED.
16. R/B/Y UI regression pass after native collapse-glyph/UI-theme work lands in a later revision.

## Release-package checks

Before an approved public package is published:

- manifest/main.lua/README/CHANGELOG versions agree;
- changelog contains the current heading and retains every known historical revision;
- repository/distribution contents match their intended roles;
- JSON parses and Lua structural checks pass;
- ZIP integrity passes;
- SHA-256 digest is generated for the final distribution archive;
- runtime evidence is reviewed against `docs/FEATURE_CONFIDENCE.md`;
- compatibility entries identify exact tested versions and do not transfer confidence to untested updates.
