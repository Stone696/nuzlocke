#!/usr/bin/env bash
# Every Gen 3 Lua smoke lives in its own interpreter; no test ordering
# dependency and no hand-maintained workflow test manifest.
set -euo pipefail
cd "$(dirname "$0")/.."
shopt -s nullglob
files=(tests/gen3_*_smoke.lua)
if (( ${#files[@]} < 30 )); then
  echo "FAIL: expected the maintained Gen 3 regression suite (30+ files)" >&2
  exit 1
fi
count=0
for file in "${files[@]}"; do
  printf '\n=== %s ===\n' "$file"
  lua5.1 "$file"
  count=$((count+1))
done
printf '\nPASS: %d independent Gen 3 Lua regressions\n' "$count"
