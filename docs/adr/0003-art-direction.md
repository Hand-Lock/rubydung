# 0003. Art direction

Date: 2026-10-01
Status: Accepted

## Context

The pack exists to show what Minecraft looked like in May 2009, when it was
still called RubyDung internally. Those builds had only a handful of
textures (grass, rock, later stone, dirt, cobblestone, planks, a sapling);
everything else in 1.20.1 has to be invented in their style.
`docs/reference/rubydung-history.md` lists which textures exist in which
build.

## Decision

- **Source of truth**: the sprites in the `rd-*` builds and Classic 0.0.11a
  (`tools/reference.sh` fetches them). Where a tile exists, use its pixels.
  Later Classic and Indev sprites (first glass, first leaves) are the next
  source, then the pack's own extrapolation.
- **Stone family**: the rd-132211 "rock" (tile 1, the cobble-like stone)
  is `block/stone`, pixel for pixel; deepslate, andesite, diorite, granite,
  tuff, calcite and blackstone reuse its pattern, recoloured. (rd-20090515
  reused the same pattern, with less contrast, as cobblestone.)
- **Ores** are the ore pattern overlaid on RubyDung stone (or its deepslate
  version), with an extra shadow or highlight where an ore colour would get
  lost against the stone (coal).
- **Wood**: planks (the rd planks tile, 4), leaves and saplings (the
  earliest sapling, Classic 0.0.11a tile 15) keep one shape and are
  re-palettised per wood type by luminance rank (`tools/palette.py remap`).
  Log ends share `oak_log_top`.
- **Look**: high contrast, few colours, hard pixel edges; no gradients,
  no anti-aliasing, no noise filters.
- **Ruby**: Emerald becomes Ruby, a nod to the name — a red gem, red ore
  flecks, and lang renames (Ruby, Ruby Ore, Block of Ruby). The blue orchid
  is a cyan rose renamed Cyan Flower, after the flower of early Pocket
  Edition.
- Grass is top-only and bright; full-block grass sides are left to Fast
  Better Grass: Untinted Edition.

## Consequences

- New textures start from a reference tile and its palette, never from a
  blank canvas or from the vanilla 1.20.1 art.
- The `retexture` skill encodes these rules; update it with this ADR.
