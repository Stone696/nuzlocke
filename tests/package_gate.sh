#!/usr/bin/env bash
# Canonical player package for all supported generations.
# Source tests, CI config, historical guides and development documents stay
# in Git but are never copied into the installable mod .zip.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${1:-$ROOT/dist}"
mkdir -p "$OUT_DIR"
VERSION="$(node -e 'const m=require(process.argv[1]); process.stdout.write(m.version)' "$ROOT/manifest.json")"
ZIP="$OUT_DIR/nuzlocke-${VERSION}.zip"
REPRO="$OUT_DIR/.nuzlocke-${VERSION}.repro.zip"
rm -f "$ZIP" "$REPRO"

python3 - "$ROOT" "$ZIP" "$REPRO" <<'PY'
import json
import pathlib
import sys
import zipfile

root = pathlib.Path(sys.argv[1])
destinations = [pathlib.Path(arg) for arg in sys.argv[2:]]
required = ["entry.lua", "main.lua", "gen3_runtime.lua",
            "manifest.json", "mod.card", "README.md", "CREDITS.md",
            "RELEASE_NOTES.md"]
for name in required:
    if not (root / name).is_file():
        raise SystemExit("FAIL: missing required release file: " + name)
manifest = json.loads((root / "manifest.json").read_text(encoding="utf-8"))
if manifest.get("id") != "nuzlocke" or manifest.get("api") != 2:
    raise SystemExit("FAIL: invalid player package manifest")
files = sorted(set(
    [root / p for p in required]
    + list(root.glob("*.lua"))
    + [p for p in (root / "assets").rglob("*")
       if p.is_file() and p.name != ".gitkeep"]
))
if len(files) < 50:
    raise SystemExit("FAIL: unexpectedly few Lua runtime modules")
names = [p.relative_to(root).as_posix() for p in files]
if any(n.startswith(("tests/", ".github/", "docs/")) for n in names):
    raise SystemExit("FAIL: development material in release payload")
stamp = (1980, 1, 1, 0, 0, 0)
for dest in destinations:
    with zipfile.ZipFile(dest, "w", compression=zipfile.ZIP_DEFLATED,
                         compresslevel=9) as zf:
        for file, name in zip(files, names):
            entry = zipfile.ZipInfo(name, stamp)
            entry.compress_type = zipfile.ZIP_DEFLATED
            entry.create_system = 3
            entry.external_attr = 0o100644 << 16
            entry.flag_bits |= 0x800
            zf.writestr(entry, file.read_bytes(),
                        compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
    with zipfile.ZipFile(dest) as zf:
        assert zf.testzip() is None
        assert zf.namelist() == names
print("PASS: installable runtime files:", len(files))
print("PASS: no tests, CI config or historical docs in player ZIP")
PY

SUM="$(sha256sum "$ZIP" | awk '{print $1}')"
REPRO_SUM="$(sha256sum "$REPRO" | awk '{print $1}')"
rm -f "$REPRO"
if [[ "$SUM" != "$REPRO_SUM" ]]; then
  echo "FAIL: player ZIP not reproducible" >&2
  exit 1
fi
echo "PASS: deterministic archive: $ZIP"
echo "PASS: sha256=$SUM"
