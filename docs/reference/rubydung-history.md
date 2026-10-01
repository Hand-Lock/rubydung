# RubyDung history and the pre-Classic textures

What each 2009 build contains, and where the pack's sources come from. Tile
numbers are `terrain.png` indices (row × 16 + column) as sliced by
`tools/reference.sh` into `.cache/ref/<version>/tiles/NNN.png`. View them
with `tools/preview.py rd-161348:all`.

## Background

RubyDung was a colony-building game Notch worked on in early 2009, inspired
by Dwarf Fortress. Its code and its grass and rock textures became the
first Minecraft builds, which still carried the RubyDung name. The `rd-ddhhmm` version names stand for RubyDung plus
the build's day, hour and minute (Stockholm time); rd-20090515 uses the
full date instead.
([pre-Classic](https://minecraft.wiki/w/Java_Edition_pre-Classic),
[rd-132211](https://minecraft.wiki/w/Java_Edition_pre-Classic_rd-132211))

## The launcher jars are not the originals

The pre-Classic jars in Mojang's launcher were repackaged in 2013 and are
"technically not original"
([pre-Classic](https://minecraft.wiki/w/Java_Edition_pre-Classic)):

- **rd-20090515** in the launcher downloads and runs **rd-161348**; the two
  jars' `terrain.png` are identical.
  ([rd-20090515](https://minecraft.wiki/w/Java_Edition_pre-Classic_rd-20090515))
- **rd-161348**'s launcher jar uses the `terrain.png` of **Classic
  0.0.13a** (May 22, 2009), so its sapling, water and lava tiles are 0.0.13a
  art, not pre-Classic.
  ([rd-161348](https://minecraft.wiki/w/Java_Edition_pre-Classic_rd-161348),
  [0.0.13a](https://minecraft.wiki/w/Java_Edition_Classic_0.0.13a))

So the most faithful copies of the pre-Classic art are rd-132211 /
rd-132328, rd-160052 and Classic 0.0.11a (May 17, 2009), whose sapling
predates the 0.0.13a redraw.

## Tiles per build (launcher jars)

| Build | Date (2009) | Tiles | Notes |
|---|---|---|---|
| rd-132211 | May 13 | 0 grass, 1 rock | Only grass and stone ("rock", the cobble-like texture). |
| rd-132328 | May 13 | 0, 1 | Same `terrain.png` as rd-132211. Adds `char.png`, the humanoid mob (its model came from Notch's *Zombie Town*). |
| rd-20090515 | May 15 | = rd-161348 | Launcher runs rd-161348. The real build added cobblestone (the old rock pattern, lower contrast), dirt, planks, a three-texture grass block and a new stone. |
| rd-160052 | May 15/16 | 0 grass, 1 stone, 2 dirt, 3 grass side, 4 planks (pinkish), 16 cobblestone | Closest to the real rd-20090515 set. |
| rd-161348 | May 16 | 0–4, 13–17, 30, 31 | 0.0.13a sheet: 4 planks (tan), 13/14 water, 15 sapling (0.0.13a), 16 cobblestone, 17 bedrock, 30 lava, 31 identical to tile 0 (the grass top; also in c0.0.11a), so nothing to use. Real rd-161348 added the sapling (hidden on key 6 because Notch disliked it) and redrew planks. |
| c0.0.11a | May 17 | 0–4, 15, 16, 31 | 15 is the earliest sapling sprite. |

Later firsts the pack uses, outside these jars:

- Classic 0.0.14a (May 27): coal, iron and gold ore, sand, gravel, oak
  logs and leaves. The pack doesn't use the 0.0.14a ores, which sit on
  the later Classic stone: its ores are the ore pattern on rd stone
  (ADR 0003). That is settled; a port shouldn't reopen it.
  ([0.0.14a](https://minecraft.wiki/w/Java_Edition_Classic_0.0.14a))
- Classic 0.0.19a: glass; 0.0.19a_01 used the border-less development
  texture, 0.0.19a_02 added the border.
  ([Glass](https://minecraft.wiki/w/Glass#History))

## What the pack takes from where

"Checked" means compared pixel by pixel or by pattern against the tiles;
the other rows are what the pack's author describes.

| Pack texture | Source | |
|---|---|---|
| `block/stone` | rd-132211 tile 1 (rock), unchanged | checked |
| andesite, deepslate | rd rock pattern, recoloured | checked |
| diorite, granite, tuff, calcite, blackstone, ores | rd rock pattern, recoloured; ores overlaid | |
| planks (all woods) | rd planks pattern (tile 4), re-palettised. rd-160052 (pinkish) and rd-161348 (tan) share the shape; the oak colours are neither, but Alpha oak: 24 of 256 pixels differ from Golden Days oak planks | checked |
| saplings (all woods) | c0.0.11a tile 15, re-palettised | checked |
| `block/grass_block_top` | rd grass (tile 0), bright green | |
| `block/ice` | the first (opaque) glass sprite | |
| `block/glass`, stained, tinted | the border-less second glass sprite | |
| `block/water_still`, `water_flow` | rd-161348 tile 14, greyscale for the vanilla tint; still drifts 1 px diagonally per frame (16 frames), flow is the tile 2x2 scrolling down (32 frames). Pre-0.0.19a water was static, so the motion is derived | checked |
| `block/lava_still`, `lava_flow` | rd-161348 tile 30 in its exact colours, animated like water | checked |
| `block/bedrock` | rd-161348 tile 17, unchanged (the Classic-to-Beta bedrock) | checked |
| `block/cobblestone`, mossy | post-Beta 1.7 shape with pre-Classic contrast | |

When a texture has no 2009 counterpart, see ADR 0003 for how to derive it.
