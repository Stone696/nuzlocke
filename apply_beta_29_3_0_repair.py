#!/usr/bin/env python3
"""
Nuzlocke beta.29.3.0 release-state repair.

Run from the root of Stone696/nuzlocke on branch nuzlocke-2.0-beta.
This is intentionally a metadata/documentation promotion only. It does not
rewrite gameplay logic and it does not globally replace historical 29.2.7
references.
"""
from pathlib import Path
import json, sys

ROOT = Path.cwd()
OLD = "2.0.0-beta.29.2.7"
NEW = "2.0.0-beta.29.3.0"

def fail(msg):
    print("ERROR:", msg, file=sys.stderr)
    raise SystemExit(1)

required = [
    "main.lua", "manifest.json", "README.md", "CHANGELOG.md", "mod.card",
    "docs/API.md", "docs/COMPATIBILITY.md", "docs/DOCUMENTATION_CHANGELOG.md",
    "docs/FEATURE_CONFIDENCE.md", "docs/TESTING.md", "docs/USER_GUIDE.md",
]
for p in required:
    if not (ROOT/p).is_file():
        fail(f"missing {p}; run this from the repository root")

# Manifest: exact current release identity only.
mp = ROOT/"manifest.json"
m = json.loads(mp.read_text(encoding="utf-8"))
if m.get("version") not in (OLD, NEW):
    fail(f"unexpected manifest version: {m.get('version')!r}")
m["version"] = NEW
mp.write_text(json.dumps(m, indent=2) + "\n", encoding="utf-8")

def replace_once(path, old, new, *, required=True):
    p = ROOT/path
    s = p.read_text(encoding="utf-8")
    n = s.count(old)
    if n == 0:
        if required and new not in s:
            fail(f"{path}: expected text not found: {old!r}")
        return
    if n != 1:
        fail(f"{path}: expected one targeted occurrence, found {n}: {old!r}")
    p.write_text(s.replace(old, new, 1), encoding="utf-8")

def prepend_once(path, marker, block):
    p = ROOT/path
    s = p.read_text(encoding="utf-8")
    if block.strip() in s:
        return
    if marker not in s:
        fail(f"{path}: insertion marker not found")
    p.write_text(s.replace(marker, block + "\n" + marker, 1), encoding="utf-8")

# main.lua: current build identity/export strings only; preserve historical lineage text.
replace_once(
    "main.lua",
    "-- Nuzlocke Rules 2.0.0-beta.29.2.7 - runtime-driven startup, cap-compatibility, and menu cleanup",
    "-- Nuzlocke Rules 2.0.0-beta.29.3.0 - release promotion of beta.29.2.7"
)
replace_once(
    "main.lua",
    'mod.exports.__beta26 = { build = "beta.29.2.7", setupProfileScope = "gen1" }',
    'mod.exports.__beta26 = { build = "beta.29.3.0", setupProfileScope = "gen1" }'
)
replace_once(
    "main.lua",
    'build = "beta.29.2.7",\n      get = function(source, ...)',
    'build = "beta.29.3.0",\n      get = function(source, ...)'
)

# README: advance current candidate identity and replace the misleading parent sentence.
replace_once("README.md",
    "**Release candidate:** `2.0.0-beta.29.2.7`",
    "**Release:** `2.0.0-beta.29.3.0`")
replace_once("README.md",
    "This release candidate is built directly from beta.29.2.1. It preserves the Gen1Recomp 0.1.83 profile, starting-money correction, LOST-vs-DEATH split, deterministic encounter projection, native collapse glyphs, and Gym-Leader Permadeath hardening while adding Gym/Dungeon Lock-In rules and broader live trainer-roster cap discovery.",
    "beta.29.3.0 is promoted directly from beta.29.2.7 with no intentional gameplay delta. It preserves the complete 29.2.7 gameplay state, the Gen1Recomp 0.1.83 audited profile, Compatibility API 25, save schema 4, and all protected runtime evidence while reconciling release identity and documentation.")
prepend_once("README.md", "## Feature highlights",
"""## beta.29.3.0 release promotion

- Immediate parent: **beta.29.2.7**.
- No intentional gameplay behavior change from the parent candidate.
- Current release identity is synchronized across manifest, code metadata, public documentation, and release notes.
- Runtime-confirmed PASS behavior remains protected; TEST REQUIRED items remain test obligations rather than being promoted to PASS.
""")

# Public docs: only their current-document identity lines.
replace_once("docs/USER_GUIDE.md",
    "This is the complete player guide for Nuzlocke `2.0.0-beta.29.2.7` on Pokémon Gen1Recomp.",
    "This is the complete player guide for Nuzlocke `2.0.0-beta.29.3.0` on Pokémon Gen1Recomp.")
replace_once("docs/FEATURE_CONFIDENCE.md",
    "# Feature confidence — beta.29.2.7",
    "# Feature confidence — beta.29.3.0")
replace_once("docs/COMPATIBILITY.md",
    "This document records compatibility claims for Nuzlocke `2.0.0-beta.29.2.7`.",
    "This document records compatibility claims for Nuzlocke `2.0.0-beta.29.3.0`.")
replace_once("docs/API.md",
    "This document describes the supported integration surface exported by Nuzlocke `2.0.0-beta.29.2.7`.",
    "This document describes the supported integration surface exported by Nuzlocke `2.0.0-beta.29.3.0`.")

# Testing.md was stale at 29.1.0. Replace the candidate-identity block, not historical evidence.
tp = ROOT/"docs/TESTING.md"
ts = tp.read_text(encoding="utf-8")
start = ts.find("## Candidate identity")
end = ts.find("## Local checks")
if start < 0 or end < 0 or end <= start:
    fail("docs/TESTING.md: candidate identity block not found")
new_block = """## Candidate identity

- Nuzlocke: `2.0.0-beta.29.3.0`
- Parent build: `2.0.0-beta.29.2.7`
- Intended gameplay delta: **none; release-state/documentation promotion only**
- Manifest engine range: `>=0.1.81 <0.1.84`
- Exact source-audited Gen1Recomp: `0.1.83`
- Games: Red, Blue, Yellow, Gold
- Nuzlocke Compatibility API: 25
- Save schema: 4

"""
ts = ts[:start] + new_block + ts[end:]
tp.write_text(ts, encoding="utf-8")

# CHANGELOG: add a release-promotion entry without altering 29.2.7 history.
prepend_once("CHANGELOG.md", "## 2.0.0-beta.29.2.7",
"""## 2.0.0-beta.29.3.0 — release promotion

- Promoted directly from beta.29.2.7.
- No intentional gameplay behavior change from beta.29.2.7.
- Reconciles current release identity across manifest, code metadata, README, public documentation, testing metadata, and release notes.
- Preserves Nuzlocke Compatibility API 25, save schema 4, Gen1Recomp Mod API 2, and the `>=0.1.81 <0.1.84` engine range.
- Preserves all runtime-confirmed PASS behavior and keeps existing TEST REQUIRED obligations explicit.
- Future development must descend directly from beta.29.3.0; older branches remain reference-only.
""")

# Documentation changelog: record this documentation repair.
prepend_once("docs/DOCUMENTATION_CHANGELOG.md",
             "## 2.0.0-beta.29.2.7",
"""## 2.0.0-beta.29.3.0 — release-state reconciliation

### Public docs

- Promoted current candidate/release identity from beta.29.2.7 to beta.29.3.0 without rewriting historical beta.29.2.7 entries.
- Corrected the README lineage statement so beta.29.3.0 is explicitly a direct promotion of beta.29.2.7.
- Advanced the User Guide, Compatibility, Developer API, and Feature Confidence current-document headers to beta.29.3.0.
- Added dedicated beta.29.3.0 release notes.

### Internal/release validation

- Advanced the stale Testing candidate block from beta.29.1.0 to beta.29.3.0 and recorded beta.29.2.7 as the immediate parent.
- No runtime TEST REQUIRED item was promoted to PASS by this documentation repair.
""")

# mod.card: retain historical known-issue references, but add explicit current release identity.
p = ROOT/"mod.card"
s = p.read_text(encoding="utf-8")
needle = 'return {\n  summary = '
if 'release = "2.0.0-beta.29.3.0"' not in s:
    if needle not in s:
        fail("mod.card: expected return-table opening not found")
    s = s.replace('return {\n', 'return {\n  release = "2.0.0-beta.29.3.0",\n', 1)
    p.write_text(s, encoding="utf-8")

# Add/replace release notes.
rp = ROOT/"docs/RELEASE_NOTES.md"
rp.write_text("""# Nuzlocke 2.0.0-beta.29.3.0

beta.29.3.0 is the public release promotion of beta.29.2.7.

**Immediate parent:** `2.0.0-beta.29.2.7`

No new gameplay behavior is intentionally introduced by this promotion. The release carries forward the complete beta.29.2.7 gameplay state, Nuzlocke Compatibility API 25, save schema 4, Gen1Recomp Mod API 2, and the audited `>=0.1.81 <0.1.84` engine range.

Runtime-confirmed behavior remains protected. Existing TEST REQUIRED items remain runtime obligations and are not converted into PASS claims by the release promotion.

Future development must descend directly from beta.29.3.0. Older builds are reference material only; missing changes may be ported surgically after comparison, but an older branch must never be restored wholesale.
""", encoding="utf-8")

print("beta.29.3.0 release-state repair applied.")
print("Review with: git diff -- main.lua manifest.json README.md CHANGELOG.md mod.card docs/")
