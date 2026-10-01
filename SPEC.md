# RubyDung: Pre-Classic Revival — spec

## Vision

Minecraft as it looked in May 2009, when the first builds still carried the
name of Notch's earlier game, RubyDung: neon grass, cobble-like stone,
a single plank and sapling. The pack puts those textures on 1.20.1 and
extends their style to the blocks and items that came later.

## Principles

- **The 2009 sprites are the source of truth** (ADR 0003). Use their
  pixels where they exist, derive from them where they don't.
- **One look.** No variants, options or sub-packs (a "UI 2009" sub-pack is
  on the roadmap, not in the pack).
- **Vanilla files only** (ADR 0002): textures, `.mcmeta` animations,
  models, lang. No OptiFine features.
- **An add-on over a required Alpha-style base** (ADR 0007). The pack
  covers what had a 2009 look or a clear extrapolation, and only where it
  differs from the base (ADR 0009); the base pack below it covers the rest.

## Compatibility

| Target | Status |
|---|---|
| Minecraft 1.20.1 (`pack_format` 15) | Only target |
| Other versions | Not supported; the game marks the pack incompatible. Adding one needs an ADR. |
| Vanilla, Fabric, Forge, OptiFine, Sodium | Works; nothing loader-specific |
| Fast Better Grass: Untinted Edition | Recommended (optional Modrinth dependency) for full-block grass |

Pack order, top to bottom:

1. RubyDung: Pre-Classic Revival
2. Required Alpha-style base, one of:
   - Golden Days Base + Golden Days Alpha
   - PACP+ with its Beta and Alpha add-ons
3. Programmer Art (built into Minecraft)

## Coverage

`tools/coverage.sh` lists what's missing. Today: 193 of 928 vanilla block
textures, 25 of 582 item textures.

### Blocks

| Group | Covered | Notes |
|---|---|---|
| Stone | stone, andesite, diorite, granite, tuff, calcite, deepslate, cobbled deepslate, blackstone | RubyDung rock pattern, recoloured; deepslate and blackstone tops are the side texture |
| Ores | coal, iron, gold, copper, lapis, redstone, diamond, ruby (emerald); all eight in deepslate too | ore pattern on RubyDung stone |
| Stone derivatives | polished andesite, diorite, granite and deepslate; smooth stone (block and slab side); stone bricks | the stone's rock pattern with softened cracks and a bevel frame; bricks in vanilla's layout with black mortar |
| Cobblestone | cobblestone, mossy cobblestone | post-Beta 1.7 shape, pre-Classic contrast |
| Mineral blocks | iron, gold, diamond, ruby (emerald), netherite, lapis, redstone, coal, copper (plain, exposed, weathered, oxidized); cut copper (all four) | the iron block shine, recoloured; cut copper is four small panels in the copper colours; cube_all models for the first five |
| Raw ore blocks | raw iron, raw gold, raw copper | RubyDung rock pattern in the raw item's colours; green patina in raw copper's cracks |
| Sand and gravel | sand, gravel, sandstone (side, top, bottom), cut and chiseled sandstone, suspicious sand and gravel (all stages); red sand and the same red sandstone set | red ones are the pack's sand family recoloured to vanilla red sand, keeping each pixel's brightness |
| Grass | grass block top | bright green, top only; untinted `grass_block.json` (`cube_bottom_top`, no side overlay, as Golden Days Alpha) |
| Wood: planks | oak, spruce, birch, jungle, acacia, dark oak, mangrove, cherry, bamboo, crimson, warped | RubyDung plank, re-palettised |
| Wood: logs | bark for oak, spruce, jungle, acacia, dark oak, mangrove; models for those plus birch and cherry (placed cherry logs via `cherry_log_x/y/z`) | every log end is `oak_log_top`; sideways mangrove logs use `cube_column` on purpose, not `cube_column_horizontal` |
| Leaves | oak, spruce, birch, jungle, acacia, dark oak, mangrove, cherry, azalea, flowering azalea | untinted (`cube_all` models) |
| Saplings | oak, spruce, birch, jungle, acacia, dark oak, cherry | Classic 0.0.11a sapling, re-palettised |
| Doors | oak, spruce, birch, jungle, acacia, dark oak, mangrove, cherry, bamboo, crimson, warped, iron | hole-less; block and item; the mangrove and bamboo doors, and the crimson and warped door bottoms, are the base's (identical, ADR 0009); the oak and iron door bottoms are Programmer Art's (identical, ADR 0011) |
| Trapdoors | oak, jungle, acacia, mangrove, cherry, crimson, warped, iron | the base trapdoor with its holes filled from the pack's door bottom; spruce, birch and dark oak are already solid in the base |
| Glass | glass, tinted glass, all 16 stained glass; their pane edges | border-less second glass sprite; pane edges are its middle two columns |
| Ice | ice, packed ice, blue ice, frosted ice (all stages) | ice is the first, opaque glass sprite |
| Liquids | water (still, flow, overlay), lava (still, flow) | animated by scrolling the 2009 tiles; water greyscale (vanilla tint), lava in its 2009 colours |
| Other | TNT side, cobweb, cyan flower (blue orchid), bricks, end stone, end stone bricks | the TNT top and bottom and the bedrock (rd-161348 tile 17) are Programmer Art's (identical, ADR 0011) |
| Torches | torch, soul torch, redstone torch (on, off) | own models (Blockbench), floor and wall |

### Items

| Group | Covered |
|---|---|
| Axes | wooden, stone, iron, golden, diamond, netherite (double-headed) |
| Materials | ruby (emerald), raw iron, raw gold, raw copper, nether star |
| Doors | the 12 doors above |
| Other | flint and steel (black), pufferfish |

### Entities, environment, paintings

| Texture | Notes |
|---|---|
| Creeper and charged creeper (`entity/creeper/`) | grey creeper by ArkyFursblack, from Oak Sapling |
| Ender dragon | grey |
| Steve (`entity/player/wide/steve.png`) | |
| Sun, moon phases, end sky | |
| Paintings: sea, stage | |
| Spyglass scope | |

### Lang (`en_us`, copied to `en_gb`, `en_au`, `en_ca`, `en_nz`)

| Vanilla | RubyDung |
|---|---|
| Emerald | Ruby |
| Emerald Ore, Deepslate Emerald Ore | Ruby Ore, Deepslate Ruby Ore |
| Block of Emerald | Block of Ruby |
| Emerald Material (armor trims) | Ruby Material |
| Blue Orchid, Potted Blue Orchid | Cyan Flower, Potted Cyan Flower |

## Known gaps

From the setup audit (2026-10-01). Each one is either a roadmap item or a
`tools/check.sh` warning.

- **Biome tint.** Vanilla tints grass, leaves and some plants. The leaves
  are coloured textures, so the pack gives them `cube_all` models without
  `tintindex`. `grass_block_top` is coloured too, so the pack's
  `grass_block.json` drops the tint on the top and has no side overlay. Other tinted
  plants (grass, ferns, vines, lily pad, sugar cane) come from the base pack.
  Water is greyscale, as vanilla, so its tint is fine.
- **Shield**: `item/shield.png` does nothing; 1.20.1 draws the shield from
  `entity/shield_base*.png`.
- **Other default skins.** rd-132328's `char.png` (the same in rd-160052,
  rd-161348 and c0.0.11a) is the pack's `player/wide/steve`. Offline
  players can get any of the other 17 default skins (Alex and the seven
  others, wide and slim); Golden Days covers Alex and slim Steve, the rest
  stay vanilla.
- **Stripped log tops** stay with the base: it gives each wood the oak end's
  rings in its own colours, the pack's re-palettising rule.
- **Bamboo trapdoor** keeps its holes: the pack's bamboo door has them too.
- **Dirt, grass side and the "new stone"** of rd-160052 aren't covered:
  they are identical to Golden Days, so the base shows them (ADR 0009).
- **Bedrock, TNT top and bottom, oak and iron door bottoms** aren't
  shipped: they are identical to Programmer Art, which no base overrides
  there (ADR 0011). Without Programmer Art they are vanilla's.
- **Unused files** (check.sh warnings; they do nothing in game):
  - `_alt` textures: blackstone, chiseled and cut sandstone, cobblestone,
    mossy cobblestone, emerald ore, deepslate emerald ore, emerald block,
    redstone torch (on, off), fire 0/1, soul fire 0/1; models
    `template_torch_alt`, `template_torch_wall_alt`.
  - `mossy_stone.png` (no such block).
- **Newer blocks.** Pale oak (door, leaves, log, planks, sapling, item
  door) and copper doors arrive after 1.20.1. Their textures wait in
  `future/`, which `tools/build.sh` doesn't ship, for the port.

## Roadmap

- **R1 — 1.0.0**: first release of the current pack, with the setup fixes.
- **R2 — Liquids**: done. Water and lava scroll their 2009 tiles; water
  keeps its vanilla tint.
- **R3 — Gear**: shield via `entity/shield_base*.png`.
- **R4 — UI 2009**: an optional sub-pack for the GUI, which needs an ADR
  (it breaks "one look").

## Non-goals

- Other Minecraft versions.
- OptiFine CTM, CIT, CEM or random entities.
- Standalone use / full coverage. The base pack covers what has no 2009
  counterpart; alone, or on Programmer Art or vanilla only, the pack is
  incomplete.

## Distribution

Modrinth (`rubydung-pre-classic-revival`, ADR 0005) and GitHub Releases,
as `rubydung-X.Y.Z+1.20.1.zip`, CC BY-SA 4.0 (ADR 0004). README.md is the
Modrinth page.
