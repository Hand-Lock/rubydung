#!/bin/sh
# Fetch reference textures into .cache/ref/ (gitignored, never committed;
# ADR 0006): the pre-classic RubyDung builds, Classic 0.0.11a and 1.20.1.
#   .cache/ref/<version>/...           every PNG in the client jar
#   .cache/ref/<version>/tiles/NNN.png  terrain.png sliced into 16x16 tiles,
#                                       NNN = row * 16 + column
#   .cache/ref/1.20.1/textures/...     vanilla textures, pack paths
# Jars are kept in .cache/jars/ so reruns don't download again.
# Usage: tools/reference.sh [version...]
set -eu

cd "$(dirname "$0")/.."
VERSIONS=${*:-rd-132211 rd-132328 rd-20090515 rd-160052 rd-161348 c0.0.11a 1.20.1}
manifest=https://piston-meta.mojang.com/mc/game/version_manifest_v2.json
PY=.venv/bin/python3
[ -x "$PY" ] || { echo "reference: no .venv; run tools/setup.sh" >&2; exit 1; }
mkdir -p .cache/jars .cache/ref
curl -fsS "$manifest" > .cache/jars/manifest.json

for v in $VERSIONS; do
    jar=.cache/jars/$v.jar
    if [ ! -s "$jar" ]; then
        meta=$(jq -r --arg v "$v" '.versions[] | select(.id == $v) | .url' .cache/jars/manifest.json)
        [ -n "$meta" ] || { echo "reference: unknown version $v" >&2; continue; }
        curl -fsS "$meta" | jq -r '.downloads.client.url' | xargs curl -fsS -o "$jar"
    fi
    out=.cache/ref/$v
    rm -rf "$out"
    mkdir -p "$out"
    if [ "$v" = 1.20.1 ]; then
        unzip -qo "$jar" 'assets/minecraft/textures/*' -d "$out"
        mv "$out/assets/minecraft/textures" "$out/textures"
        rm -rf "$out/assets"
    else
        unzip -qo "$jar" '*.png' -d "$out"
    fi
    if [ -f "$out/terrain.png" ]; then
        "$PY" - "$out" <<'EOF'
import os, sys
from PIL import Image
out = sys.argv[1]
im = Image.open(os.path.join(out, "terrain.png")).convert("RGBA")
os.makedirs(os.path.join(out, "tiles"), exist_ok=True)
# Unused tiles are a purple placeholder grid; skip them.
empty = {(107, 63, 127, 255), (214, 127, 255, 255)}
for y in range(im.height // 16):
    for x in range(im.width // 16):
        t = im.crop((x * 16, y * 16, x * 16 + 16, y * 16 + 16))
        if not {c for _, c in t.getcolors(256 * 256)} <= empty:
            t.save(os.path.join(out, "tiles", "%03d.png" % (y * 16 + x)))
EOF
    fi
    echo "$out: $(find "$out" -name '*.png' | wc -l | tr -d ' ') PNGs"
done
