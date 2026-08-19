#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${1:-$ROOT/dist}"
mkdir -p "$OUT_DIR"

VERSION="$(node -e 'const fs=require("fs");const m=JSON.parse(fs.readFileSync(process.argv[1],"utf8"));process.stdout.write(String(m.version))' "$ROOT/manifest.json")"
ZIP="$OUT_DIR/Nuzlocke_${VERSION}.zip"

FILES=(
  CHANGELOG.md
  README.md
  RELEASE_NOTES.md
  docs/API.md
  docs/COMPATIBILITY.md
  docs/DOCUMENTATION_CHANGELOG.md
  docs/FEATURE_CONFIDENCE.md
  docs/USER_GUIDE.md
  main.lua
  manifest.json
  mod.card
  modern_ui_integration.lua
  pokegear_integration.lua
  title_setup_compat.lua
  trainer_rewards.lua
)

# Reproducible player packaging. Git checkouts and local copies have different
# mtimes/UID metadata, so Info-ZIP's default output is not byte-stable even when
# every player file is identical. Build the archive with fixed ZIP metadata so
# the same 15 bytesets always produce the same SHA-256.
rm -f "$ZIP"
python3 - "$ROOT" "$ZIP" "${FILES[@]}" <<'PY'
import pathlib, sys, zipfile
root = pathlib.Path(sys.argv[1])
out = pathlib.Path(sys.argv[2])
files = sys.argv[3:]
FIXED_TIME = (1980, 1, 1, 0, 0, 0)
for rel in files:
    if not (root / rel).is_file():
        raise SystemExit(f"FAIL: missing package file: {rel}")
with zipfile.ZipFile(out, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
    for rel in files:
        info = zipfile.ZipInfo(rel, FIXED_TIME)
        info.compress_type = zipfile.ZIP_DEFLATED
        info.create_system = 3
        info.external_attr = (0o100644 << 16)
        info.flag_bits |= 0x800  # UTF-8 names
        zf.writestr(info, (root / rel).read_bytes(), compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
PY

unzip -tq "$ZIP" >/dev/null
EXPECTED="$(printf '%s\n' "${FILES[@]}" | LC_ALL=C sort)"
ACTUAL="$(unzip -Z1 "$ZIP" | LC_ALL=C sort)"
if [[ "$ACTUAL" != "$EXPECTED" ]]; then
  echo "FAIL: package file set differs from the canonical 15 paths" >&2
  diff -u <(printf '%s\n' "$EXPECTED") <(printf '%s\n' "$ACTUAL") || true
  exit 1
fi

COUNT="$(unzip -Z1 "$ZIP" | wc -l | tr -d ' ')"
[[ "$COUNT" == "15" ]] || { echo "FAIL: expected 15 entries, got $COUNT" >&2; exit 1; }

# Rebuild independently and require the byte hash to match. This proves the
# packager itself is deterministic, not merely that one archive is valid.
REPRO="$OUT_DIR/.Nuzlocke_${VERSION}.repro.zip"
rm -f "$REPRO"
python3 - "$ROOT" "$REPRO" "${FILES[@]}" <<'PY'
import pathlib, sys, zipfile
root = pathlib.Path(sys.argv[1])
out = pathlib.Path(sys.argv[2])
files = sys.argv[3:]
FIXED_TIME = (1980, 1, 1, 0, 0, 0)
with zipfile.ZipFile(out, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
    for rel in files:
        info = zipfile.ZipInfo(rel, FIXED_TIME)
        info.compress_type = zipfile.ZIP_DEFLATED
        info.create_system = 3
        info.external_attr = (0o100644 << 16)
        info.flag_bits |= 0x800
        zf.writestr(info, (root / rel).read_bytes(), compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
PY
SHA="$(sha256sum "$ZIP" | awk '{print $1}')"
REPRO_SHA="$(sha256sum "$REPRO" | awk '{print $1}')"
rm -f "$REPRO"
[[ "$SHA" == "$REPRO_SHA" ]] || {
  echo "FAIL: package output is not reproducible: $SHA != $REPRO_SHA" >&2
  exit 1
}

echo "PASS: package=$ZIP"
echo "PASS: entries=$COUNT"
echo "PASS: reproducible=yes"
echo "PASS: sha256=$SHA"
