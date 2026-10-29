# Gen1Recomp Mod Index — Nuzlocke and the Generation 3 fork

**Do not submit this as a second mod entry with ID `nuzlocke` yet.**

The public index already contains **`mods/Stone696@nuzlocke/`**, pointing to
`Stone696/nuzlocke`. Index validation explicitly forbids duplicate mod IDs
(rule **MI203**). Submitting `mods/Deluxe0111@nuzlocke/` would fail regardless
of its title or author field.

## Intended collaboration

The Nuzlocke project history is:

1. **bryanthaboi** — original Nuzlocke mod.
2. **Stone696** — continued and expanded Gen 1/2 Nuzlocke.
3. **Deluxe0111** — independently ported and extended Nuzlocke for Gen 3,
   particularly FireRed/LeafGreen and Ruby/Sapphire/Emerald.

Deluxe0111 maintains the Gen 3 fork and would be happy to contribute it
upstream, **if Stone696 wants it**. The intended cooperative arrangement is
Stone696 overseeing Gen 1/2 and Deluxe0111 maintaining Gen 3.
Until explicitly agreed, this is an offer rather than an upstream endorsement.

**Do not silently replace Stone696's existing index URL with this fork.**
If accepted upstream, open an index PR **editing the existing entry**, after
the repository, version and maintainer attribution are agreed. If a distinct
listing is preferable, the index would require a distinct mod ID and a
coordinated identity/save/compatibility review before changing the manifest.

## Suggested index description (for collaborative update)

# Nuzlocke — Generations 1, 2 & 3

**Every encounter is a choice. Every fallen partner is remembered.**

The configurable Gen1Recomp Nuzlocke now supports Red, Blue, Yellow,
Gold, Silver and Crystal, with an optional **Generation 3 beta** port for
**FireRed, LeafGreen, Ruby, Sapphire and Emerald**.

Choose traditional Permadeath, First Encounter and Nickname rules, or go
further with Hardcore, Shiny Nuzlocke, type/colour/species restrictions,
level caps, battle clauses, field-item/service rules and seeded randomisation.

In Gen 3, configure a new run before the adventure begins, optionally lock
its rules, explore native area splits, and follow your team's story through
the Run Journal and Graveyard. Complete or lose a run to create a shareable
final-party and memorial summary.

Compatible Untamed Advanced builds can use the same seed for **visible
wandering wild Pokémon**, ensuring overworld sprites match what you battle
and catch. Untamed is optional.

**Beta limitations:** Manual edition and mod-combination verification is
still ongoing. Some non-catch nickname and special scripted acquisition
paths require testing. Save important progress before testing permadeath.

**Credits:** Original work by bryanthaboi; Gen 1/2 expansion and maintenance
by Stone696; original Shiny Pokémon lineage by masterwebx; Gen 3 port
and new integrations by Deluxe0111.

## Metadata fields if an upstream update is agreed

- **ID:** `nuzlocke` (unchanged)
- **API:** `2`
- **Profile:** `content`
- **Engine:** `>=0.2.24 <2.0.0`
- **Permissions:** `engine_internals`
- **Categories:** GAMEPLAY, BALANCE, QOL
- **Tags:** nuzlocke, gen3, hardcore, shiny, randomizer, permadeath, challenge, untamed
- **Link play:** enabled (matches manifest `affects_link: true`)
- **Version:** `3.0.1-beta` once published
- **Repository:** only change the existing index `github` to an agreed
  source repository, not unilaterally to a fork.

Index guidelines: https://github.com/bryanthaboi/gen1recomp-mod-index/blob/main/CONTRIBUTING.md

The index's nightly process updates versions after an entry has been
approved. It does not require a PR for each new release.
