# Resource pack cheat sheet for 1.20.1

The parts of the 1.20.1 resource pack format this pack uses. Checked
against the 1.20.1 client jar; sources on
[minecraft.wiki](https://minecraft.wiki/w/Resource_pack).

## pack.mcmeta and pack.png

```json
{ "pack": { "description": "…", "pack_format": 15 } }
```

1.20 and 1.20.1 are resource pack format 15
([Pack format](https://minecraft.wiki/w/Pack_format)). `supported_formats`
(1.20.2+) and overlays (1.20.2+) are not used (ADR 0002). `pack.png` is the
square icon shown in the pack list.

## Texture paths

Everything is under `assets/minecraft/textures/`. The full list with sizes
is `tools/vanilla-1.20.1-sizes.txt`.

| Folder | What | Notes |
|---|---|---|
| `block/` | block faces, also used by block items | 16×16; animated ones are 16×(16·n) |
| `item/` | flat item icons | 16×16 |
| `entity/` | mob and block-entity skins | sized to their UV layout (creeper 64×32, player 64×64, dragon 256×256) |
| `models/armor/` | worn armor: `<material>_layer_1.png` (helmet, chest, boots) and `_layer_2.png` (leggings), plus `leather_layer_*_overlay.png` | 64×32 |
| `trims/models/armor/` | armor trim patterns, palettes in `trims/color_palettes/` | |
| `environment/` | `sun.png`, `moon_phases.png` (4×2 phases), `end_sky.png`, clouds, rain, snow | |
| `painting/` | one PNG per motive, 16 px per block (`sea` 32×16, `stage` 32×32) | |
| `misc/` | overlays: `spyglass_scope.png`, pumpkin blur, vignette… | drawn stretched to the screen |
| `colormap/` | `grass.png`, `foliage.png` biome tints | 256×256 |

A texture at a path vanilla doesn't have is only loaded if a pack model
points at it. Block textures are stitched into the block atlas from all of
`textures/block/`, so even unused ones there take atlas space and their
`.mcmeta` errors are logged.

## Animation (`<texture>.png.mcmeta`)

```json
{ "animation": { "frametime": 2, "interpolate": false,
                 "frames": [0, 1, {"index": 2, "time": 4}],
                 "width": 16, "height": 16 } }
```

- Frames are stacked vertically. With no `width`/`height`, a frame is a
  square of the image's smaller side; the image must be a whole number of
  frames.
- `frametime` is ticks per frame (default 1). `frames` lists frame indices
  (or `{index, time}`) in play order; an index past the last frame is an
  error. Omitted, frames play top to bottom.
- `{"animation": {}}` on a one-frame image is valid and static.
- Vanilla liquids: `water_still` / `lava_still` are 16×16 frames,
  `water_flow` / `lava_flow` are 32×32 frames (the flowing face samples the
  middle 16 px of a 32 px frame, so a 16 px flow texture shows 8 px per
  block, magnified).
- `.mcmeta` is read from the same pack as the PNG: overriding a vanilla
  animated PNG without its own `.mcmeta` makes it static.

## Models

`assets/minecraft/models/block/*.json` and `models/item/*.json`. A pack model
at a vanilla path replaces it; blockstates (`blockstates/*.json`) map block
states to models.

```json
{ "parent": "minecraft:block/cube_column",
  "textures": { "end": "minecraft:block/oak_log_top", "side": "minecraft:block/oak_log" } }
```

Parents this pack uses:

- `block/cube_all` (`all`) — mineral blocks.
- `block/cube_column` (`end`, `side`) — upright logs.
- `block/cube_column_horizontal` (`end`, `side`) — sideways logs; vanilla
  blockstates rotate it with `x: 90` (and `y: 90` for the x axis). Using
  `cube_column` there turns the bark grain the wrong way.
- `block/template_torch`, `template_torch_wall` (`torch`) — torches; the
  pack replaces both templates with its own geometry.

Gotchas:

- Cherry logs use `cherry_log_x`, `cherry_log_y`, `cherry_log_z`, not
  `cherry_log` / `cherry_log_horizontal`; the `_x/_y/_z` models are what
  appear in the world.
- Refs without a namespace (`block/stone`) are `minecraft:`.
- An element with `"tintindex"` is multiplied by a colour from code.

## Tinting

Vanilla multiplies these textures by a biome or fixed colour; a colourful
texture comes out darker or shifted unless its model drops `tintindex`:

- Grass colormap: `grass_block_top`, `grass_block_side_overlay`, `grass`,
  `tall_grass`, `fern`, `large_fern`, sugar cane.
- Foliage colormap: oak, jungle, acacia, dark oak and mangrove leaves, vines.
- Fixed: birch leaves `#80a755`, spruce leaves `#619961`, lily pad.
- Not tinted: cherry and azalea leaves.
- Water: `water_still` / `water_flow` / `water_overlay` are tinted by the
  biome water colour, so vanilla keeps them greyscale.

## Built-in (entity) renderers

These items and blocks are drawn by code from `entity/` textures, not from
item or block textures:

- Shield: `item/shield.json` is `builtin/entity`; it draws
  `entity/shield_base.png` / `shield_base_nopattern.png` and
  `entity/shield/*.png` patterns. There is no `item/shield.png` in 1.20.1.
- Banners (`entity/banner/`), chests (`entity/chest/normal.png`, `_left`,
  `_right`, trapped, ender, christmas), beds (`entity/bed/`), signs
  (`entity/signs/`), shulker boxes, conduit, bell, decorated pots.

## Lang

`assets/minecraft/lang/<locale>.json` maps translation keys to names. A
pack file is merged over vanilla, so it only needs the keys it changes.
Keys must exist in vanilla (`tools/vanilla-1.20.1-lang.txt`). This pack
overrides `en_us` only, so other languages keep the vanilla names.
