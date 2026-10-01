#!/bin/sh
# Offline checks against vanilla 1.20.1 (tools/vanilla-1.20.1*.txt):
# every JSON file parses; pack_format is 15; model parents and texture refs
# resolve to the pack or vanilla; blockstate and item files name a 1.20.1
# block or item; lang keys exist in vanilla; animation .mcmeta files fit
# their image; PNG sizes match vanilla; no private data. Warns about pack
# textures and models that nothing uses. Exits non-zero on any failure.
# Usage: tools/check.sh
set -u

cd "$(dirname "$0")/.." || exit 1
V=tools/vanilla-1.20.1
A=assets/minecraft
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
fail=0
err() { printf 'FAIL %s\n' "$*"; fail=1; }
warn() { printf 'warn %s\n' "$*"; }

command -v jq >/dev/null || { echo "jq missing: brew install jq"; exit 1; }
for f in $V.txt $V-sizes.txt $V-lang.txt; do
    [ -f "$f" ] || { echo "$f missing: run tools/vanilla.sh"; exit 1; }
done

# Every JSON file parses.
json=$(find . -path ./.git -prune -o -path ./dist -prune -o -path ./.cache -prune -o \
    -path ./.venv -prune -o \( -name '*.json' -o -name '*.mcmeta' \) -type f -print | sed 's|^\./||' | sort)
for f in $json; do
    jq empty "$f" 2>/dev/null || err "$f: invalid JSON"
done

jq -e '.pack.pack_format == 15' pack.mcmeta >/dev/null 2>&1 || err "pack.mcmeta: pack_format is not 15"
jq -e '.pack | has("supported_formats") | not' pack.mcmeta >/dev/null 2>&1 || err "pack.mcmeta: supported_formats (1.20.1 only, ADR 0002)"
jq -e 'has("overlays") | not' pack.mcmeta >/dev/null 2>&1 || err "pack.mcmeta: overlays (1.20.1 only, ADR 0002)"

# Refs without a namespace are minecraft:. A ref resolves to a pack file or a
# vanilla path. Resolved texture refs are collected in $TMP/used.
resolve() { # KIND REF SOURCE
    case $2 in
        builtin/*|minecraft:builtin/*) return ;;
        *:*) ns=${2%%:*}; path=${2#*:} ;;
        *) ns=minecraft; path=$2 ;;
    esac
    case $1 in models) ext=json ;; *) ext=png ;; esac
    [ "$ns" = minecraft ] || { err "$3: $1 ref $2: namespace $ns is not in this pack"; return; }
    echo "$1/$path.$ext" >> "$TMP/used"
    [ -f "$A/$1/$path.$ext" ] && return
    grep -qxF "$1/$path.$ext" $V.txt || err "$3: $1 ref $2 not in the pack or vanilla"
}
: > "$TMP/used"

for f in $(cd "$A" && find blockstates items -name '*.json' 2>/dev/null | sort); do
    grep -qxF "$f" $V.txt || err "$A/$f: no such block or item in 1.20.1"
    for m in $(jq -r '[.. | objects | .model? | strings] | unique[]' "$A/$f" 2>/dev/null); do
        resolve models "$m" "$A/$f"
    done
done
for f in $(cd "$A" && find models -name '*.json' 2>/dev/null | sort); do
    p=$(jq -r '.parent // empty' "$A/$f" 2>/dev/null)
    [ -n "$p" ] && resolve models "$p" "$A/$f"
    for m in $(jq -r '[.overrides[]?.model | strings] | unique[]' "$A/$f" 2>/dev/null); do
        resolve models "$m" "$A/$f"
    done
    for t in $(jq -r '.textures // {} | .[] | strings | select(startswith("#") | not)' "$A/$f" 2>/dev/null); do
        resolve textures "$t" "$A/$f"
    done
done

# Lang keys exist in vanilla (every language uses the en_us keys).
for f in $(find "$A/lang" -name '*.json' 2>/dev/null | sort); do
    for k in $(jq -r 'keys[]' "$f" 2>/dev/null); do
        grep -qxF "$k" $V-lang.txt || err "$f: lang key $k not in 1.20.1"
    done
done

# PNG width and height: big-endian at bytes 16-23.
pngsize() { od -An -j16 -N8 -tu1 "$1" | awk 'NF { printf "%dx%d", $1*16777216+$2*65536+$3*256+$4, $5*16777216+$6*65536+$7*256+$8; exit }'; }

# Animations: the image splits into whole frames (square of the smaller side
# unless width/height are given) and every frames index exists.
for m in $(find "$A/textures" -name '*.png.mcmeta' | sort); do
    png=${m%.mcmeta}
    [ -f "$png" ] || { err "$m: no $png"; continue; }
    jq -e 'has("animation")' "$m" >/dev/null 2>&1 || continue
    s=$(pngsize "$png"); w=${s%x*} h=${s#*x}
    fw=$(jq -r '.animation.width // empty' "$m") fh=$(jq -r '.animation.height // empty' "$m")
    if [ -z "$fw$fh" ]; then fw=$(( w < h ? w : h )) fh=$fw; fi
    fw=${fw:-$w} fh=${fh:-$h}
    if [ $((w % fw)) != 0 ] || [ $((h % fh)) != 0 ]; then
        err "$png: ${w}x$h is not a multiple of the ${fw}x$fh frame"; continue
    fi
    n=$(( (w / fw) * (h / fh) ))
    bad=$(jq -r --argjson n "$n" '[.animation.frames[]? | if type == "object" then .index else . end | select(. >= $n)] | unique | map(tostring) | join(" ")' "$m")
    [ -n "$bad" ] && err "$m: frames $bad beyond the $n frame(s) of the image"
done

# Textures: same size as vanilla (height may differ when animated); warn about
# non-vanilla textures no pack model uses.
for f in $(cd "$A" && find textures -name '*.png' | sort); do
    s=$(pngsize "$A/$f")
    vs=$(grep -F "$f " $V-sizes.txt | awk -v p="$f" '$1 == p { print $2 }')
    if [ -z "$vs" ]; then
        grep -qxF "$f" "$TMP/used" || warn "$A/$f: not a 1.20.1 texture and no pack model uses it"
        continue
    fi
    [ "$s" = "$vs" ] && continue
    if [ "${s%x*}" != "${vs%x*}" ]; then
        err "$A/$f: ${s}, vanilla is $vs"
    elif ! jq -e 'has("animation")' "$A/$f.mcmeta" >/dev/null 2>&1; then
        err "$A/$f: ${s}, vanilla is $vs (not animated)"
    fi
done

# Non-vanilla models nothing references.
for f in $(cd "$A" && find models -name '*.json' | sort); do
    grep -qxF "$f" $V.txt || grep -qxF "$f" "$TMP/used" || warn "$A/$f: not a 1.20.1 model and nothing references it"
done

# Private data: emails other than GitHub noreply, local home paths.
priv=$(git ls-files -co --exclude-standard | grep -v '^tools/check\.sh$' | while IFS= read -r f; do
    [ -f "$f" ] || continue
    grep -HnoIE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}|/Users/[A-Za-z0-9._-]+|/home/[a-z][A-Za-z0-9._-]*' "$f"
done | grep -vE ':[0-9]+:([^:]*@users\.noreply\.github\.com|noreply@anthropic\.com)$')
[ -n "$priv" ] && { err "private data:"; printf '%s\n' "$priv" | sed 's/^/    /'; }

[ "$fail" = 0 ] && echo "check: ok"
exit "$fail"
