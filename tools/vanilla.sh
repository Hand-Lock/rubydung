#!/bin/sh
# Record what vanilla Minecraft ships, for tools/check.sh and coverage.sh:
#   tools/vanilla-<ver>.txt        blockstate, item, model and texture paths
#   tools/vanilla-<ver>-sizes.txt  "path WxH" of every texture
#   tools/vanilla-<ver>-lang.txt   en_us translation keys
# Only file names, sizes and keys are recorded; no Mojang assets are committed.
# Usage: tools/vanilla.sh [version]   (default: 1.20.1)
set -eu

cd "$(dirname "$0")/.."
ver=${1:-1.20.1}
out=tools/vanilla-$ver
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

manifest=https://piston-meta.mojang.com/mc/game/version_manifest_v2.json
meta=$(curl -fsS "$manifest" | jq -r --arg v "$ver" '.versions[] | select(.id == $v) | .url')
[ -n "$meta" ] || { echo "vanilla: unknown version $ver" >&2; exit 1; }
curl -fsS "$meta" | jq -r '.downloads.client.url' | xargs curl -fsS -o "$TMP/client.jar"

unzip -Z1 "$TMP/client.jar" 'assets/minecraft/*' |
    grep -E '^assets/minecraft/((blockstates|items|models)/.*\.json|textures/.*\.png)$' |
    sed 's|^assets/minecraft/||' | LC_ALL=C sort > "$out.txt"

# PNG width and height are big-endian at bytes 16-23 of the IHDR chunk.
python3 - "$TMP/client.jar" <<'EOF' | LC_ALL=C sort > "$out-sizes.txt"
import struct, sys, zipfile
pre = "assets/minecraft/"
with zipfile.ZipFile(sys.argv[1]) as z:
    for n in z.namelist():
        if n.startswith(pre + "textures/") and n.endswith(".png"):
            with z.open(n) as f:
                w, h = struct.unpack(">II", f.read(24)[16:24])
            print(f"{n[len(pre):]} {w}x{h}")
EOF

unzip -p "$TMP/client.jar" assets/minecraft/lang/en_us.json |
    jq -r 'keys[]' | LC_ALL=C sort > "$out-lang.txt"

for f in "$out.txt" "$out-sizes.txt" "$out-lang.txt"; do
    echo "$f: $(wc -l < "$f" | tr -d ' ') lines"
done
