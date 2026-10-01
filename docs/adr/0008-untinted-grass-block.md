# 0008. Untinted grass block

Date: 2026-10-01
Status: Accepted; supersedes the grass block bullet of 0007

## Context

0007 untinted the pack's coloured leaves but left `grass_block.json`
vanilla, relying on Fast Better Grass: Untinted Edition to replace it and
avoiding overriding the base pack's grass model. But `grass_block_top` is a
coloured texture too, and without FBG Untinted vanilla tints it. The rule
should be the same for every texture the pack colours.

## Decision

- The pack ships `grass_block.json`: the vanilla 1.20.1 model with every
  `tintindex` removed, on the top and on the side overlay. The grass block
  item inherits it.
- The overlay is untinted too: this model replaces the base pack's, and
  Golden Days Alpha's overlay is coloured and untinted, so a tinted overlay
  would re-tint it.
- Fast Better Grass: Untinted Edition, placed above RubyDung, still wins
  with its own untinted model.

## Consequences

- The grass top looks the same in every biome, with or without FBG.
- On vanilla or Programmer Art the greyscale side overlay goes grey. Those
  bases are unsupported (0007), so that is acceptable.
