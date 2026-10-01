# 0007. An add-on over an Alpha base; untint only what the pack colours

Date: 2026-10-01
Status: Accepted; the grass block bullet is superseded by 0008; refined by 0009

## Context

The pack's leaves and grass top are coloured textures, drawn to sit on
Golden Days Base + Golden Days Alpha, whose models drop `tintindex`.
Vanilla 1.20.1 models still multiply them by the foliage colormap or a
fixed colour, so on their own they look darker or shifted.

RubyDung was never meant to be complete. It ships the RubyDung, Cave Game
and early-Minecraft textures that the Alpha-style packs lack, and relies on
one of them for everything else. The docs said "Programmer Art works too",
which isn't true.

## Decision

- RubyDung is an add-on over a required Alpha-style base, placed below it:
  Golden Days Base + Golden Days Alpha, or PACP+ with its Beta and Alpha
  add-ons. It is not standalone and won't cover every texture.
- Pack models drop `tintindex` only for textures the pack colours itself:
  the oak, spruce, birch, jungle, acacia, dark oak and mangrove leaves get
  `cube_all` models. This is a fallback; the base is still required.
- `grass_block.json` stays vanilla: Fast Better Grass: Untinted Edition,
  above RubyDung, replaces it, and a RubyDung copy would override the base
  pack's grass model.
- Other tinted plants (grass, ferns, vines, lily pad, sugar cane, pink
  petals) come from the base pack, already coloured and untinted.

## Consequences

- Alone, or on Programmer Art or vanilla, the pack is incomplete and the
  grass top is tinted. That is expected.
- A new coloured texture of a tinted block needs a model without
  `tintindex`, or must be left to the base pack.
