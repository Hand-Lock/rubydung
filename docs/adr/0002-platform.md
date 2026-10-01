# 0002. Platform: vanilla resource pack for 1.20.1

Date: 2026-10-01
Status: Accepted

## Context

The pack was made for and tested on Minecraft 1.20.1, where its recommended
companions (Golden Days, PACP+, Fast Better Grass: Untinted Edition) live.
Supporting newer versions means overlays, a second item-model system
(`items/` definitions from 1.21.4) and new textures to keep in sync, and
nobody tests there yet.

## Decision

- A plain vanilla resource pack for **Minecraft 1.20.1 only**:
  `pack_format` 15, no `supported_formats`, no overlays.
- 16x: textures keep the width of their vanilla 1.20.1 counterpart; only
  animated textures may be taller.
- `minecraft:` namespace, vanilla paths, vanilla file types only. No
  OptiFine features (CTM, CIT, CEM, random textures, emissive) and no
  mod-only files, so it works the same on vanilla, Fabric, Forge and with
  Sodium.
- `tools/check.sh` enforces this against lists of the 1.20.1 client jar
  (`tools/vanilla.sh`).

## Consequences

- Textures for blocks newer than 1.20.1 (pale oak, copper doors) would do
  nothing, so they live in `future/`, outside the shipped `assets/`.
- Widening the version range needs a new ADR that supersedes this one,
  with overlays and per-version checks as Billy Boarding does.
