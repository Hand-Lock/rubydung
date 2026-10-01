#!/bin/sh
# List the vanilla 1.20.1 block and item textures this pack doesn't override
# yet, grouped by family (the last word of the name once state suffixes like
# _top or _stage3 are dropped: oak_door_bottom -> door). Families of one go
# under "other". Feeds the coverage table in SPEC.md.
# Usage: tools/coverage.sh [block|item]...   (default: block item)
set -eu

cd "$(dirname "$0")/.."
V=tools/vanilla-1.20.1.txt
[ -f $V ] || { echo "$V missing: run tools/vanilla.sh" >&2; exit 1; }

for kind in ${*:-block item}; do
    grep -E "^textures/$kind/[^/]+\.png$" $V | while IFS= read -r f; do
        n=${f##*/} n=${n%.png}
        [ -f "assets/minecraft/$f" ] && echo "+ $n" || echo "- $n"
    done > "${TMPDIR:-/tmp}/coverage.$$"
    total=$(wc -l < "${TMPDIR:-/tmp}/coverage.$$" | tr -d ' ')
    have=$(grep -c '^+' "${TMPDIR:-/tmp}/coverage.$$" || true)
    echo "== $kind: $have of $total covered, $((total - have)) missing"
    grep '^-' "${TMPDIR:-/tmp}/coverage.$$" | cut -c3- | awk '
        {
            k = $0
            while (k ~ /_(top|bottom|side|front|back|end|inner|outer|on|off|lit|base|tip|overlay|particle|stage[0-9]+|[0-9]+|north|south|east|west|up|down|still|flow)$/)
                sub(/_[a-z0-9]+$/, "", k)
            n = split(k, w, "_"); fam = w[n]
            m[fam] = m[fam] " " $0; c[fam]++
        }
        END {
            for (f in c) if (c[f] > 1) printf "%4d %s:%s\n", c[f], f, m[f]
            for (f in c) if (c[f] == 1) o = o m[f]
            if (o != "") printf "   - other:%s\n", o
        }' | sort -k1,1nr -k2
    rm -f "${TMPDIR:-/tmp}/coverage.$$"
done
