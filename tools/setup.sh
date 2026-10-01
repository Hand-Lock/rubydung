#!/bin/sh
# One-time setup: check the command-line tools, create .venv with Pillow for
# tools/*.py, and write the vanilla lists (tools/vanilla.sh).
# Usage: tools/setup.sh
set -eu

cd "$(dirname "$0")/.."
missing=
for c in jq gh zip unzip curl python3; do
    command -v "$c" >/dev/null || missing="$missing $c"
done
[ -z "$missing" ] || { echo "setup: missing:$missing (brew install ...)" >&2; exit 1; }

[ -x .venv/bin/python3 ] || python3 -m venv .venv
.venv/bin/python3 -m pip install -q --disable-pip-version-check --upgrade pillow
.venv/bin/python3 -c 'import PIL; print("setup: Pillow", PIL.__version__)'

tools/vanilla.sh
echo "setup: ok. Next: tools/reference.sh, and tools/install.sh for a live dev instance"
