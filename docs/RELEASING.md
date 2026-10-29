# Releasing Nuzlocke — fork/Gen 3 beta

This project is a **fork**: `bryanthaboi/nuzlocke` → `Stone696/nuzlocke` → `Deluxe0111/nuzlocke`. Release communication must distinguish inherited code and contributors from the new Gen 3 port.

## Important existing release

A GitHub **[v3.0.0-BETA prerelease](https://github.com/Deluxe0111/nuzlocke/releases/tag/v3.0.0-BETA)** was already published on 28 October 2026 at 23:17 UTC by the old automated workflow. It has an installable ZIP, but its release page contains a raw list of recent commits rather than curated notes. **Do not overwrite the published tag or pretend it is an unpublished draft.** The existing release description can be edited on GitHub to use [the curated v3 notes](../RELEASE_NOTES.md); replacing the ZIP should be treated as a deliberate new patch/prerelease, not a silent change to the same version.

## Check permission and provenance before promoting to Discord

The original, Stone696 and Deluxe0111 GitHub repositories **do not currently expose a recognised software licence** in repository metadata or a root licence file. GitHub allows public forks within its service, but that is **not an automatic general redistribution licence** for third-party code in a separately shared ZIP. Authorship attribution is necessary but not a substitute for permission. Ask the original author and/or maintainers for their distribution/reuse terms, and retain any documented permission. A few weeks' inactivity should not be interpreted as an automatic transfer of project ownership or copyright.

Use **"Gen 3 beta port of the existing Nuzlocke mod (fork)"**, not "official successor" or "original Nuzlocke creator". Credit [bryanthaboi, Stone696, masterwebx and Deluxe0111](../CREDITS.md), preserving each person's distinct contribution. Do not add an SPDX licence covering inherited code without authorisation.

If redistribution permission is unclear, keep working on the public GitHub fork and seek clarification before actively distributing a new package elsewhere. The existing GitHub prerelease should be treated as already publicly accessible, not silently un-published by these documentation changes.

## Source and test cleanup policy

Development scripts and all `tests/gen3_*_smoke.lua` files **remain in Git** for maintainability and regression testing. The player ZIP contains root Lua runtime modules, manifest, mod metadata, minimal player documentation and assets only. No `tests/`, `.github/`, long historical guides or repository housekeeping files are included in the player package.

- `bash tests/run_gen3_smoke.sh` automatically discovers maintained Gen 3 smoke tests.
- `node tests/gen3_docs_gate.js` checks release/version/credits/document links.
- `bash tests/package_gate.sh /tmp/nuzlocke-package` creates and verifies a reproducible minimal player ZIP.
- `tests/invariants.js` is **historical** and hardcodes obsolete Gen 1-only manifest/schema and 15-file assumptions. It is not a v3 release gate.

## Prepare the next version

1. Work on the feature branch, open a PR to **main**, and let the Gen 3 regression suite and the package gate pass. Test the ZIP in the actual Gen1Recomp launcher with a disposable save.
2. Update `manifest.json`, README title, and the top of `RELEASE_NOTES.md` to the exact **new** version; do **not** reuse `v3.0.0-BETA` or rewrite historical entries.
3. Review the [feature matrix](GEN3_FEATURE_MATRIX.md), outstanding ROM/provider caveats and [credits](../CREDITS.md). Ensure the top release-notes section is a readable summary, not an unfiltered Git commit dump.
4. On GitHub, open **Actions → Release (manual) → Run workflow**, select **main**, supply the exact new manifest version and enter `PUBLISH`. The workflow refuses duplicate tags, rechecks docs, Lua and all Gen 3 smoke tests, builds the minimal reproducible ZIP and publishes the curated notes.
5. Verify the release asset actually installs, check its version and checksum, and only then share the release link in the appropriate Discord mod-release channel (after resolving redistribution terms). Mark it clearly **BETA**, ask testers for edition/build/reproduction details, and link back to the original project.

Do not create a public GitHub Release automatically on every main-branch push. Avoid force-moving published tags or quietly replacing binaries at the same version.

## What to say in Discord

Focus on **what changed in this fork**, not a claim that the earlier maintainers' mod is abandoned. Mention FireRed/LeafGreen/Ruby/Sapphire/Emerald support, native Gen 3 features, optional Untamed integration and known beta limitations. Link the source/credits and installable GitHub release. Say the former Gen 1/2 functionality is inherited and credit its contributors. Invite feedback; do not assert combined-mod certification without testing.
