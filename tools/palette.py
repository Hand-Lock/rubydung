#!/usr/bin/env python3
"""Palette tools for 16x pixel art.

Usage:
  tools/palette.py show TEXTURE
      Colours by count: hex, alpha, luminance, pixel count.
  tools/palette.py remap SRC --like PALETTE_SRC [-o OUT]
      Re-palettise SRC: its colours, ranked by luminance, take the colour of
      the same relative rank in PALETTE_SRC. This keeps SRC's shapes and
      shading and gives it PALETTE_SRC's colours (how planks, leaves and
      saplings were adapted to each wood type). Writes OUT, default
      .cache/preview/remap-<src>.png, and prints its path.

TEXTURE is a pack texture (block/stone), a reference tile (rd-161348:4), a
1.20.1 texture (vanilla:block/stone) or a PNG path.
"""
import argparse
import os
import sys

ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
try:
    from PIL import Image
except ImportError:
    venv = os.path.join(ROOT, ".venv", "bin", "python3")
    if os.path.exists(venv) and not os.environ.get("RD_VENV"):
        os.environ["RD_VENV"] = "1"
        os.execv(venv, [venv] + sys.argv)
    sys.exit("Pillow missing: run tools/setup.sh")


def path(name):
    if os.path.isfile(name):
        return name
    if name.startswith("vanilla:"):
        return os.path.join(ROOT, ".cache", "ref", "1.20.1", "textures", name[8:] + ".png")
    if ":" in name:
        ver, n = name.split(":", 1)
        return os.path.join(ROOT, ".cache", "ref", ver, "tiles", "%03d.png" % int(n))
    k = name[:-4] if name.endswith(".png") else name
    return os.path.join(ROOT, "assets", "minecraft", "textures", k.split("textures/", 1)[-1] + ".png")


def load(name):
    p = path(name)
    if not os.path.isfile(p):
        sys.exit("palette: no such texture: %s (%s)" % (name, p))
    return Image.open(p).convert("RGBA")


def lum(c):
    return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2]


def colours(im):
    """Opaque-ish colours (alpha > 0), sorted dark to light."""
    return sorted({c for _, c in im.getcolors(1 << 24) if c[3] > 0}, key=lambda c: (lum(c), c))


def show(args):
    im = load(args.texture)
    counts = sorted(im.getcolors(1 << 24), key=lambda nc: (lum(nc[1]), nc[1]))
    print("%s: %dx%d, %d colours" % (args.texture, im.width, im.height, len(counts)))
    for n, c in counts:
        print("  #%02x%02x%02x  a=%3d  L=%5.1f  %4d" % (c[0], c[1], c[2], c[3], lum(c), n))


def remap(args):
    src, like = load(args.src), load(args.like)
    a, b = colours(src), colours(like)
    if not a or not b:
        sys.exit("palette: no opaque colours")
    m = {}
    for i, c in enumerate(a):
        j = round(i * (len(b) - 1) / (len(a) - 1)) if len(a) > 1 else len(b) // 2
        m[c] = b[j][:3] + (c[3],)
    out = src.copy()
    px = out.load()
    for y in range(out.height):
        for x in range(out.width):
            px[x, y] = m.get(px[x, y], px[x, y])
    o = args.out or os.path.join(ROOT, ".cache", "preview",
                                 "remap-" + os.path.basename(path(args.src)))
    os.makedirs(os.path.dirname(os.path.abspath(o)), exist_ok=True)
    out.save(o)
    print("%d colours -> %d; %s" % (len(a), len(b), os.path.relpath(o, os.getcwd())))


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    s = sub.add_parser("show")
    s.add_argument("texture")
    r = sub.add_parser("remap")
    r.add_argument("src")
    r.add_argument("--like", required=True)
    r.add_argument("-o", "--out")
    args = ap.parse_args()
    show(args) if args.cmd == "show" else remap(args)


if __name__ == "__main__":
    main()
