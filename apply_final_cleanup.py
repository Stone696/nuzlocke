#!/usr/bin/env python3
from pathlib import Path
import sys

R=Path.cwd()
def sub(path, old, new):
    p=R/path
    s=p.read_text(encoding="utf-8")
    if old not in s:
        if new in s: return
        raise SystemExit(f"{path}: expected text not found")
    p.write_text(s.replace(old,new,1),encoding="utf-8")

# The previous commit only added the repair helper files + manifest/release notes.
# Apply the actual narrow release promotion now.
sub("README.md","**Release candidate:** `2.0.0-beta.29.2.7`","**Release:** `2.0.0-beta.29.3.0`")
sub("README.md",
"This release candidate is built directly from beta.29.2.1. It preserves the Gen1Recomp 0.1.83 profile, starting-money correction, LOST-vs-DEATH split, deterministic encounter projection, native collapse glyphs, and Gym-Leader Permadeath hardening while adding Gym/Dungeon Lock-In rules and broader live trainer-roster cap discovery.",
"beta.29.3.0 is promoted directly from beta.29.2.7 with no intentional gameplay delta. It preserves the complete 29.2.7 gameplay state, the Gen1Recomp 0.1.83 audited profile, Compatibility API 25, save schema 4, and all protected runtime evidence.")

sub("main.lua",
"-- Nuzlocke Rules 2.0.0-beta.29.2.7 - runtime-driven startup, cap-compatibility, and menu cleanup",
"-- Nuzlocke Rules 2.0.0-beta.29.3.0 - release promotion of beta.29.2.7")
sub("main.lua",'mod.exports.__beta26 = { build = "beta.29.2.7", setupProfileScope = "gen1" }',
               'mod.exports.__beta26 = { build = "beta.29.3.0", setupProfileScope = "gen1" }')
sub("main.lua",'build = "beta.29.2.7",\n      get = function(source, ...)',
               'build = "beta.29.3.0",\n      get = function(source, ...)')

sub("docs/USER_GUIDE.md","This is the complete player guide for Nuzlocke `2.0.0-beta.29.2.7` on Pokémon Gen1Recomp.",
                         "This is the complete player guide for Nuzlocke `2.0.0-beta.29.3.0` on Pokémon Gen1Recomp.")
sub("docs/FEATURE_CONFIDENCE.md","# Feature confidence — beta.29.2.7","# Feature confidence — beta.29.3.0")
sub("docs/COMPATIBILITY.md","This document records compatibility claims for Nuzlocke `2.0.0-beta.29.2.7`.",
                            "This document records compatibility claims for Nuzlocke `2.0.0-beta.29.3.0`.")
sub("docs/API.md","This document describes the supported integration surface exported by Nuzlocke `2.0.0-beta.29.2.7`.",
                  "This document describes the supported integration surface exported by Nuzlocke `2.0.0-beta.29.3.0`.")

# Fix Testing's stale current candidate block.
p=R/"docs/TESTING.md"; s=p.read_text(encoding="utf-8")
a=s.index("## Candidate identity"); b=s.index("## Local checks")
block="""## Candidate identity

- Nuzlocke: `2.0.0-beta.29.3.0`
- Parent build: `2.0.0-beta.29.2.7`
- Intended gameplay delta: **none; release-state/documentation promotion only**
- Manifest engine range: `>=0.1.81 <0.1.84`
- Exact source-audited Gen1Recomp: `0.1.83`
- Games: Red, Blue, Yellow, Gold
- Nuzlocke Compatibility API: 25
- Save schema: 4

"""
p.write_text(s[:a]+block+s[b:],encoding="utf-8")

# Add release headings if not already present.
p=R/"CHANGELOG.md"; s=p.read_text(encoding="utf-8")
if "## 2.0.0-beta.29.3.0 — release promotion" not in s:
    marker="## 2.0.0-beta.29.2.7"
    entry="""## 2.0.0-beta.29.3.0 — release promotion
- Promoted directly from beta.29.2.7 with no intentional gameplay delta.
- Reconciles current release identity across manifest, code metadata, and documentation.
- Preserves Compatibility API 25, save schema 4, Mod API 2, and Gen1Recomp `>=0.1.81 <0.1.84`.
- Runtime-confirmed PASS behavior remains protected; TEST REQUIRED items remain test obligations.

"""
    if marker not in s: raise SystemExit("CHANGELOG marker missing")
    p.write_text(s.replace(marker,entry+marker,1),encoding="utf-8")

# Remove repair-only files accidentally committed to repository root.
for name in ("REPAIR_INSTRUCTIONS.md","apply_beta_29_3_0_repair.py"):
    p=R/name
    if p.exists(): p.unlink()

print("Final beta.29.3.0 cleanup applied.")
print("Review git diff, then run: node tests/release_gate.js main.lua")
