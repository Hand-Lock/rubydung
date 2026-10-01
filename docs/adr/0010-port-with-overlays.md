# 0010. Port: one zip with overlays

Date: 2026-10-01
Status: Proposed (would supersede the version part of 0002)

## Context

0002 keeps the pack on 1.20.1 only. Both base packs (Golden Days 16.4)
already run from 1.20 to 26.3, and Billy Boarding (0008 there) ships one
zip for 1.20.1 to 26.3 with overlays. What changes for RubyDung after
1.20.1:

- New blocks: pale oak (released in 1.21.4) and copper doors (1.21.9).
  Their textures wait in `future/`.
- Armor textures move from `models/armor/` to `entity/equipment/` in
  1.21.2, so R3's netherite armor needs a second path.
- 26.3 drops `shade` from model elements in favour of
  `shade_direction_override`; the torch models use `"shade": false`.
- `tools/check.sh` and `tools/coverage.sh` read only the
  `vanilla-1.20.1*.txt` lists.

The alternative, a branch and a zip per version, keeps each pack plain
but repeats every texture change on every branch.

## Decision (proposed)

- One zip. `assets/` stays the exact 1.20.1 pack; `pack.mcmeta` keeps
  `pack_format` 15 and states the range both ways (`supported_formats`
  and `min_format`/`max_format`), as Billy Boarding does.
- One overlay per first version that needs a file: pale oak in the 1.21.4
  overlay, copper doors in the 1.21.9 one, the moved armor in the 1.21.2
  one. `future/` empties into them.
- Torch models carry both `"shade": false` and
  `"shade_direction_override": "up"`, so no 26.3 copy is needed.
- `max_format` rises only for a version check.sh covers: `tools/vanilla.sh
  <version>` per target, and check.sh builds each version's effective pack
  and checks it against that list.

## Consequences

- If accepted: a new ADR supersedes 0002's version rules, AGENTS.md and
  SPEC.md drop "1.20.1 only", and zips are named `+1.20.1-<last>`.
- Format numbers and paths above need checking against each version's
  jar before the overlays are written.
- R3 (gear) can be done on 1.20.1 first; the port adds the second armor
  path.
