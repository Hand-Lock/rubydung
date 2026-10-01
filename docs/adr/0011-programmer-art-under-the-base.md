# 0011. Programmer Art under the base

Date: 2026-10-01
Status: Accepted; refines 0007 and 0009

## Context

0009 compares the pack with the base packs and with "what players see when
the base doesn't retexture it", which was vanilla. Programmer Art is built
into Minecraft and carries the pre-1.14 textures, several of which are the
same old textures this pack ships.

Comparing every pack PNG with Programmer Art 1.20.1, and with Golden Days
Base/Alpha 16.4 and PACP 2.5.3 with Beta-Fied and Alpha-Fied 26-2 (only
`assets/`, since none of their overlays apply on format 15):

- `block/bedrock`, `tnt_top`, `tnt_bottom`, `oak_door_bottom` and
  `iron_door_bottom` are identical to Programmer Art, and no base pack
  retextures them.
- `spruce_door_top` and `spruce_door_bottom` are identical to Programmer
  Art, but Golden Days Base overrides them with different pixels.

## Decision

Programmer Art is part of the required base: it goes at the bottom of the
pack order, under Golden Days or PACP+.

A texture identical to Programmer Art that neither Golden Days Base/Alpha
nor PACP/Beta-Fied/Alpha-Fied overrides is left to Programmer Art. A
texture a base pack overrides stays, even if it matches Programmer Art.

So bedrock, the TNT top and bottom, and the oak and iron door bottoms are
removed. Bedrock is still rd-161348 tile 17: Programmer Art has the same
tile. The spruce door stays.

## Consequences

- Without Programmer Art, those five textures fall back to vanilla 1.20.1.
- 0009's diff for a new texture also covers Programmer Art.
