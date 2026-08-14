# Nuzlocke 2.0.0-beta.29.3.0

## Release promotion

beta.29.3.0 is the public release promotion of beta.29.2.7.

**Immediate parent:** `2.0.0-beta.29.2.7`

No new gameplay behavior is intentionally introduced by the 29.3.0 promotion. The release carries forward the complete 29.2.7 gameplay state, Compatibility API 25, save schema 4, Gen1Recomp Mod API 2, and the audited `>=0.1.81 <0.1.84` engine range.

The release includes the accumulated late-29.2 work: R/B random-starter presentation correction, composed trainer-party cap preview, Gym/Dungeon Lock-In, common Route 2/10/20 split rules and migration, finite-number hardening, Indigo Plateau Conference compatibility work, Gold trainer-registry handling, Gold starter provenance hardening, and the inherited beta.29.2.1 Permadeath/deterministic encounter fixes.

Runtime-confirmed behavior remains protected. Items still marked TEST REQUIRED in the repository documentation remain test obligations; this promotion does not convert them into runtime PASS claims.

## Lineage rule

Future development must descend directly from beta.29.3.0. Older builds are reference material only; missing behavior may be ported surgically after comparison, but an older branch must never be restored wholesale.
