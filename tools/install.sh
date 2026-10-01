#!/bin/sh
# Symlink this repo into each dev instance as resourcepacks/rubydung, so F3+T
# reloads edits live. Instances come from MC_DIRS in .local.env, a
# colon-separated list of .minecraft directories.
# Usage: tools/install.sh
set -eu

cd "$(dirname "$0")/.."
[ -f .local.env ] || { echo "install: no .local.env; write MC_DIRS=/path/to/.minecraft there" >&2; exit 1; }
. ./.local.env
[ -n "${MC_DIRS:-}" ] || { echo "install: MC_DIRS is empty in .local.env" >&2; exit 1; }

repo=$(pwd)
IFS=:
for d in $MC_DIRS; do
    [ -d "$d" ] || { echo "install: $d: no such directory" >&2; continue; }
    mkdir -p "$d/resourcepacks"
    link=$d/resourcepacks/rubydung
    if [ -e "$link" ] && [ ! -L "$link" ]; then
        echo "install: $link exists and is not a symlink; left alone" >&2
        continue
    fi
    ln -sfn "$repo" "$link"
    echo "$link -> repo"
done
