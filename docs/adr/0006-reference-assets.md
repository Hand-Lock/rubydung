# 0006. Reference assets stay out of the repo

Date: 2026-10-01
Status: Accepted

## Context

Agents can't judge 16×16 pixel art without the originals next to it: the
2009 pre-Classic tiles and the vanilla 1.20.1 textures. Both are Mojang's
assets and must not be redistributed from this repo.

## Decision

- `tools/reference.sh` downloads the client jars of `rd-132211`,
  `rd-132328`, `rd-20090515`, `rd-160052`, `rd-161348`, `c0.0.11a` and
  1.20.1 from Mojang's version manifest, extracts their textures into the
  gitignored `.cache/ref/<version>/`, and slices each `terrain.png` into
  numbered 16×16 tiles (`tiles/NNN.png`, NNN = row × 16 + column).
- The repo commits only lists derived from the 1.20.1 jar: paths, sizes and
  lang keys (`tools/vanilla-1.20.1*.txt`).
- `tools/preview.py` and `tools/palette.py` read `.cache/ref/` directly.

## Consequences

- A fresh clone needs `tools/setup.sh` and `tools/reference.sh` before the
  image tools work; both are idempotent.
- The launcher's pre-Classic jars are 2013 repackages, not the 2009
  originals (see `docs/reference/rubydung-history.md`); tile numbers refer
  to those jars.
