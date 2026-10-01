# 0005. Modrinth release

Date: 2026-10-01
Status: Accepted

Amends 0004 (release).

## Context

The Modrinth project `rubydung-pre-classic-revival` (`WHfjy2pa`) exists as
a draft with LGPL-3.0 as its license. Billy Boarding already releases with
one command and keeps its Modrinth page in README.md.

## Decision

- `tools/release.sh X.Y.Z` does the whole release: preconditions (main,
  clean, pushed, tag free, a `## [X.Y.Z]` changelog section),
  `tools/check.sh`, `tools/build.sh`, tag `vX.Y.Z`, GitHub release with the
  zip, Modrinth version, and the Modrinth page body from README.md.
  `--dry-run` prints every payload and sends nothing.
- If the project is still a draft after the upload, release.sh submits it
  for review (`status: processing`); if the API refuses, it prints the page
  link to submit by hand.
- `tools/modrinth.json` holds what the version upload needs: loader
  `minecraft`, `game_versions` `[1.20.1]` (0002), and Fast Better Grass:
  Untinted Edition (`2bXJhCck`) as an **optional** dependency, because the
  README recommends it for full-block grass.
- README.md is the page body. The page is edited in the repo, never on the
  site.
- The page metadata is set once through the API, not by release.sh:
  license `CC-BY-SA-4.0`, `client_side: required`,
  `server_side: unsupported`, categories from `/v2/tag/category` (including
  the 16x resolution), source and issues URLs on GitHub. The gallery is
  managed by hand on the site.

## Consequences

- A release is: changelog section, commit, push, `tools/release.sh X.Y.Z`.
- The Modrinth changelog is the CHANGELOG.md section, reformatted.
- Metadata changes are one-off API calls.
