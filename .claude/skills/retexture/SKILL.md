---
name: retexture
description: Make or change one RubyDung texture in pre-Classic style — find the vanilla path and size, start from the nearest 2009 tile, derive the palette, write the PNG with Pillow, preview it. Use for any new or edited PNG under assets/minecraft/textures.
---

# Retexture

House rules (ADR 0003):

- Start from a 2009 tile (`rd-*`, `c0.0.11a`), never from a blank canvas
  or the 1.20.1 art. Where a tile exists for the block, use its pixels.
- Stone-like blocks reuse the rd-132211 rock pattern (`rd-132211:1`),
  recoloured. Ores are the ore pattern on that stone, with extra shadow or
  highlight where the ore colour gets lost.
- Wood keeps one shape: planks from `rd-160052:4` / `rd-161348:4`, saplings
  from `c0.0.11a:15`, leaves from the pack's oak leaves. Re-palettise per
  wood type with `tools/palette.py remap`.
- High contrast, few colours, hard edges. No gradients, anti-aliasing or
  noise filters.
- Emerald is Ruby (red); blue orchid is the Cyan Flower.

Steps (tools need `tools/setup.sh` and `tools/reference.sh` once):

1. **Vanilla path and size.** `grep 'textures/block/NAME' tools/vanilla-1.20.1-sizes.txt`.
   The width must match; only animated textures may be taller. Check
   `docs/reference/resourcepack-1.20.1.md` for tinting (a tinted texture
   should stay greyscale unless the model drops `tintindex`) and for
   textures drawn from `entity/` instead.
2. **Nearest reference.** `tools/preview.py rd-161348:all c0.0.11a:all` shows
   every 2009 tile; `docs/reference/rubydung-history.md` says which build
   is the faithful one. For a related pack texture, use it as the base.
3. **Preview both.** `tools/preview.py block/NAME --vanilla --ref SPEC`
   and Read the PNG it prints.
4. **Palette.** `tools/palette.py show vanilla:block/NAME` and
   `tools/palette.py show rd-160052:4` (or a pack texture). To recolour a
   base: `tools/palette.py remap BASE --like vanilla:block/NAME`, which
   maps colours by luminance rank and writes `.cache/preview/remap-*.png`.
   Adjust by hand if a rank lands on the wrong colour.
5. **Author the PNG** with a small Pillow script (`.venv/bin/python3`, in
   the scratchpad, not the repo): load the base, set pixels explicitly
   (`px[x, y] = (r, g, b, a)`), save to
   `assets/minecraft/textures/<path>.png` in RGBA. No resampling except
   nearest-neighbour.
6. **Preview the result** tiled and next to vanilla and the reference:
   `tools/preview.py block/NAME --tile 3 --vanilla --ref`. Read it; check
   seams, contrast against neighbours, and that it reads at 1×. For
   animations add `--anim`.
7. **Task loop** (AGENTS.md): `tools/check.sh`, a CHANGELOG line, SPEC
   coverage and README if they change, commit, push. If you added a new
   `REF` pairing, add it to `tools/preview.py`.
