# 0004. License, release and privacy

Date: 2026-10-01
Status: Accepted

## Context

The pack is going public on GitHub and Modrinth. It is mostly art, which
software licenses fit badly (the Modrinth draft said LGPL-3.0). It ports
Mojang's 2009 textures and includes a grey creeper by ArkyFursblack, used
with permission (credits.txt).

## Decision

- License: CC BY-SA 4.0 for the pack's own work. Mojang's assets remain
  Mojang's; the license covers HandLock_'s porting, extensions and code.
- SemVer tags `vX.Y.Z` on `main`. Patch = fixes and art tweaks, minor =
  newly covered textures or visible look changes, major = a dropped
  Minecraft version or a reverted art direction. The first release is 1.0.0.
- `CHANGELOG.md` in Keep a Changelog format. `tools/build.sh` zips from
  `git archive HEAD` into `dist/rubydung-X.Y.Z+1.20.1.zip`.
- Releases happen only when the user says "release".
- The only committed identity is `HandLock_` with the GitHub noreply email.
  The Modrinth token lives in the macOS Keychain (`modrinth-token`) or
  `$MODRINTH_TOKEN`, never in a file. `tools/check.sh` greps for emails and
  local paths.

## Consequences

- Zips contain only `pack.mcmeta`, `pack.png`, `assets/`, `credits.txt` and
  `LICENSE`.
- Forks and modpacks may reuse the work with credit, under the same license.
