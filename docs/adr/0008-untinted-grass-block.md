# 0008. Untinted grass block

Date: 2026-10-01
Status: Accepted; supersedes the grass block bullet of 0007; amended
2026-10-01: no side overlay

## Context

0007 untinted the pack's coloured leaves but left `grass_block.json`
vanilla, relying on Fast Better Grass: Untinted Edition to replace it and
avoiding overriding the base pack's grass model. But `grass_block_top` is a
coloured texture too, and without FBG Untinted vanilla tints it. The rule
should be the same for every texture the pack colours.

The first version of this decision kept vanilla's side overlay, untinted,
on the premise that Golden Days Alpha's overlay is coloured. It isn't: GD
Alpha ships no overlay texture, so vanilla's greyscale
`grass_block_side_overlay` showed grey on every side. GD Alpha's own
`grass_block.json` is `cube_bottom_top` with no overlay.

## Decision

- The pack ships `grass_block.json` as Golden Days Alpha has it: parent
  `cube_bottom_top` (no `tintindex`), `top` `grass_block_top`, `side`
  `grass_block_side`, `bottom` `dirt`, no side overlay. The grass block item
  inherits it.
- Fast Better Grass: Untinted Edition, placed above RubyDung, still wins
  with its own untinted model.

## Consequences

- The grass top looks the same in every biome, with or without FBG.
- The side is whatever the base pack's `grass_block_side` is; the supported
  bases ship a coloured one.
- On vanilla or Programmer Art the side shows no green fringe. Those bases
  are unsupported (0007), so that is acceptable.
