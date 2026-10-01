#!/usr/bin/env python3
"""Upscaled, labelled contact sheets of textures, for reading pixel art.

Usage: tools/preview.py TEXTURE... [--tile N] [--vanilla] [--ref [SPEC]]
                        [--anim] [--scale S] [-o OUT]

TEXTURE is a pack texture (block/stone, textures/block/stone.png), a
reference tile (rd-161348:1, c0.0.11a:all) or a PNG path. One row per
texture: the texture itself, then 1.20.1 (--vanilla) and RubyDung tiles
(--ref). --ref without SPEC uses REF below; SPEC is VERSION:N[,N...] or
VERSION:all, comma-free versions joined with "+". --tile N tiles each image
N x N to show seams and repetition. --anim lays animation frames out in a
strip. Writes .cache/preview/<name>.png (or OUT) and prints its path.
Reference textures come from tools/reference.sh.
"""
import argparse
import os
import sys

ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
try:
    from PIL import Image, ImageDraw
except ImportError:
    venv = os.path.join(ROOT, ".venv", "bin", "python3")
    if os.path.exists(venv) and not os.environ.get("RD_VENV"):
        os.environ["RD_VENV"] = "1"
        os.execv(venv, [venv] + sys.argv)
    sys.exit("Pillow missing: run tools/setup.sh")

PACK = os.path.join(ROOT, "assets", "minecraft", "textures")
REFDIR = os.path.join(ROOT, ".cache", "ref")
VANILLA = os.path.join(REFDIR, "1.20.1", "textures")
LATEST = "rd-161348"
# Pack texture -> RubyDung tiles it derives from (docs/reference/rubydung-history.md).
REF = {
    "block/grass_block_top": "rd-132211:0+rd-161348:0",
    "block/stone": "rd-132211:1+rd-161348:1",
    "block/cobblestone": "rd-161348:16+rd-132211:1",
    "block/dirt": "rd-161348:2",
    "block/grass_block_side": "rd-161348:3",
    "block/oak_planks": "rd-160052:4+rd-161348:4",
    "block/oak_sapling": "c0.0.11a:15+rd-161348:15",
    "block/bedrock": "rd-161348:17",
    "block/water_still": "rd-161348:13+rd-161348:14",
    "block/lava_still": "rd-161348:30",
}
BG = (40, 40, 48, 255)
FG = (230, 230, 230, 255)
CHECK = ((92, 92, 100, 255), (72, 72, 80, 255))


def resolve(name):
    """Return (label, path) for a texture argument."""
    if os.path.isfile(name):
        return os.path.basename(name), name
    if ":" in name:
        ver, n = name.split(":", 1)
        return name, os.path.join(REFDIR, ver, "tiles", "%03d.png" % int(n))
    key = texkey(name)
    return key, os.path.join(PACK, key + ".png")


def texkey(name):
    k = name[:-4] if name.endswith(".png") else name
    k = k.split("textures/", 1)[-1]
    return k


def refs(spec):
    """Expand a SPEC into [(label, path)]."""
    out = []
    for part in spec.split("+"):
        ver, ns = part.split(":", 1)
        tiles = os.path.join(REFDIR, ver, "tiles")
        if ns == "all":
            idx = sorted(int(f[:3]) for f in os.listdir(tiles)) if os.path.isdir(tiles) else []
        else:
            idx = [int(n) for n in ns.split(",")]
        out += [("%s:%d" % (ver, i), os.path.join(tiles, "%03d.png" % i)) for i in idx]
    return out


def load(path):
    return Image.open(path).convert("RGBA") if os.path.isfile(path) else None


def frames(im):
    s = min(im.width, im.height)
    return [im.crop((x, y, x + s, y + s)) for y in range(0, im.height - s + 1, s)
            for x in range(0, im.width - s + 1, s)]


def tile(im, n):
    out = Image.new("RGBA", (im.width * n, im.height * n))
    for y in range(n):
        for x in range(n):
            out.paste(im, (x * im.width, y * im.height))
    return out


def checker(w, h, cell):
    out = Image.new("RGBA", (w, h))
    d = ImageDraw.Draw(out)
    for y in range(0, h, cell):
        for x in range(0, w, cell):
            d.rectangle((x, y, x + cell - 1, y + cell - 1), fill=CHECK[(x // cell + y // cell) % 2])
    return out


def cell(label, im, args):
    """One labelled, upscaled image (or a 'missing' placeholder)."""
    if im is None:
        body = Image.new("RGBA", (16 * args.scale, 16 * args.scale), BG)
        ImageDraw.Draw(body).text((4, 4), "missing", fill=(255, 96, 96, 255))
    else:
        parts = frames(im) if args.anim and im.height != im.width else [im]
        if args.tile > 1:
            parts = [tile(p, args.tile) for p in parts]
        w = sum(p.width for p in parts) + (len(parts) - 1)
        strip = Image.new("RGBA", (w, max(p.height for p in parts)), (0, 0, 0, 0))
        x = 0
        for p in parts:
            strip.paste(p, (x, 0))
            x += p.width + 1
        s = args.scale
        big = strip.resize((strip.width * s, strip.height * s), Image.NEAREST)
        body = checker(big.width, big.height, s * 2)
        body.alpha_composite(big)
        if args.anim and len(parts) > 1:
            label += " (%d frames)" % len(parts)
        elif im.size != (16, 16):
            label += " %dx%d" % im.size
    out = Image.new("RGBA", (max(body.width, 8 * len(label) + 8), body.height + 16), BG)
    ImageDraw.Draw(out).text((2, 2), label, fill=FG)
    out.paste(body, (0, 16))
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("textures", nargs="+")
    ap.add_argument("--tile", type=int, default=1)
    ap.add_argument("--vanilla", action="store_true")
    ap.add_argument("--ref", nargs="?", const="", default=None)
    ap.add_argument("--anim", action="store_true")
    ap.add_argument("--scale", type=int, default=0)
    ap.add_argument("-o", "--out")
    args = ap.parse_args()

    names = []
    for t in args.textures:
        if t.endswith(":all"):
            names += refs(t)
        else:
            names.append(resolve(t))
    if not args.scale:
        args.scale = max(2, 12 // max(1, args.tile))

    rows = []
    for label, path in names:
        cells = [cell(label, load(path), args)]
        key = texkey(label) if ":" not in label else None
        if args.vanilla and key:
            cells.append(cell("1.20.1 " + key, load(os.path.join(VANILLA, key + ".png")), args))
        if args.ref is not None and key:
            spec = args.ref or REF.get(key)
            if spec:
                cells += [cell(l, load(p), args) for l, p in refs(spec)]
            else:
                print("preview: no REF entry for %s; pass --ref VERSION:N" % key, file=sys.stderr)
        rows.append(cells)

    gap = 8
    perrow = max(1, 1200 // (max(c.width for r in rows for c in r) + gap)) if rows and not (args.vanilla or args.ref is not None) else 0
    if perrow:  # plain sheet: wrap single cells into a grid
        flat = [c for r in rows for c in r]
        rows = [flat[i:i + perrow] for i in range(0, len(flat), perrow)]
    w = max(sum(c.width for c in r) + gap * (len(r) + 1) for r in rows)
    h = sum(max(c.height for c in r) + gap for r in rows) + gap
    sheet = Image.new("RGBA", (w, h), BG)
    y = gap
    for r in rows:
        x = gap
        for c in r:
            sheet.paste(c, (x, y))
            x += c.width + gap
        y += max(c.height for c in r) + gap

    out = args.out
    if not out:
        base = "_".join(texkey(l).replace("/", "-").replace(":", "-") for l, _ in names[:4])
        if len(names) > 4:
            base += "_and_%d_more" % (len(names) - 4)
        out = os.path.join(ROOT, ".cache", "preview", base + ".png")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    sheet.save(out)
    print(os.path.relpath(out, os.getcwd()))


if __name__ == "__main__":
    main()
