# RubyDung: Pre-Classic Revival — agent guide

RubyDung is a Minecraft 1.20.1 resource pack that brings back the 2009
pre-Classic textures (the `rd-*` builds that still carried the name of
Notch's earlier game, RubyDung) and extends their style to modern blocks
and items. It is an add-on over a required Alpha-style base pack (Golden
Days Base + Alpha, or PACP+ with its Beta and Alpha add-ons) and ships only
the textures those packs lack (ADR 0007). Product direction and coverage
live in [SPEC.md](SPEC.md);
decisions and their reasons live in [docs/adr/](docs/adr/); bootstrapping
knowledge lives in [docs/reference/](docs/reference/). Read them before
changing the look, the file layout or compatibility.

## Hard constraints

- Minecraft **1.20.1 only** (ADR 0002). `pack.mcmeta` has `pack_format` 15
  and no `supported_formats` or overlays. Widening the range needs a new ADR.
- 16x: every texture has the width of its vanilla 1.20.1 counterpart
  (`tools/vanilla-1.20.1-sizes.txt`); only animated textures may be taller.
- Everything lives in the `minecraft:` namespace at vanilla 1.20.1 paths. A
  texture at a path vanilla doesn't have does nothing unless a pack model
  uses it.
- Vanilla files only: textures, `.mcmeta` animations, models, blockstates,
  lang. No OptiFine (CTM, CIT, CEM, random entities), no mod-only files.
- `assets/minecraft/lang/*.json` only renames things that exist (the Ruby
  and Cyan Flower renames); keys must exist in vanilla. The English
  locales other than en_us have their own strings, so each gets a copy.

## Art direction (ADR 0003)

- The 2009 `rd-*` and Classic 0.0.11a sprites are the source of truth. Use
  their pixels where they exist; derive from them where they don't.
- Ores are the ore pattern overlaid on RubyDung stone, with extra shadow or
  highlight where a colour gets lost (coal).
- Planks, leaves and saplings keep one RubyDung shape and are re-palettised
  per wood type (`tools/palette.py remap`).
- High contrast, few colours, no smooth gradients or anti-aliasing.
- Emerald is Ruby (red gem, lang renames); blue orchid is the Cyan Flower.
- A coloured texture of a tinted block (leaves, grass, vines…) needs a
  pack model without `tintindex`, or is left to the base pack (ADR 0007).

## Hygiene

- Suckless: the smallest change that works. No new tools, formats or
  abstractions without a reason.
- Refs in models are written `minecraft:block/x`; old files use `block/x`.
  Both work; match the file you're in.
- Never commit Mojang assets beyond what the pack already ships as its own
  art. Reference textures are fetched into `.cache/` (ADR 0006).
- Finder `.DS_Store` files are ignored; never add them.

## File map

```
pack.mcmeta, pack.png, credits.txt    pack metadata and credits
LICENSE                               CC BY-SA 4.0
assets/minecraft/
  textures/block/         blocks (stone family, ores, wood, glass, liquids…)
  textures/item/          axes, doors, gems, raw ores, flint and steel…
  textures/entity/        grey creeper, ender dragon, Steve
  textures/environment/   sun, moon phases, end sky
  textures/painting/, misc/   two paintings, spyglass scope
  models/block/           logs (shared oak_log_top end), torches,
                          mineral blocks, untinted leaves
                          and grass block
  lang/en_*.json          Ruby and Cyan Flower renames (en_us, copied
                          to en_gb, en_au, en_ca, en_nz)
future/assets/            textures for blocks newer than 1.20.1 (pale
                          oak, copper doors); not shipped, for the port
tools/
  check.sh                offline checks (see below)
  build.sh                dist/rubydung-<version>+1.20.1.zip from git archive
  release.sh              tag, GitHub release, Modrinth version and page
  modrinth.json           Modrinth project id, loader, game versions,
                          dependencies
  setup.sh                one-time: .venv with Pillow, vanilla lists
  vanilla.sh              writes the three vanilla-1.20.1*.txt lists
  vanilla-1.20.1.txt      vanilla blockstate, model and texture paths
  vanilla-1.20.1-sizes.txt   "path WxH" of every vanilla texture
  vanilla-1.20.1-lang.txt    vanilla en_us keys
  reference.sh            fetches pre-Classic and 1.20.1 textures into
                          .cache/ref/
  preview.py              upscaled contact sheets in .cache/preview/
  palette.py              show a palette, remap one texture to another's
  coverage.sh             vanilla textures the pack doesn't cover yet
  install.sh              symlinks the repo into the dev instances
docs/adr/                 decisions
docs/reference/           RubyDung history, 1.20.1 resource pack cheat sheet
.claude/skills/retexture/ how to make one texture in RubyDung style
```

`tools/check.sh` fails on: JSON or `.mcmeta` that doesn't parse;
`pack_format` other than 15 (or formats ranges, overlays); model parents
and texture refs that resolve to neither the pack nor vanilla 1.20.1;
blockstate or item files with no 1.20.1 block or item; lang keys vanilla
doesn't have; animations whose image isn't a whole number of frames or
whose `frames` index past the last frame; PNGs whose width differs from
vanilla, or whose height differs while not animated; private data. It warns
about textures and models that are neither vanilla paths nor used by a pack
model; those do nothing in game (SPEC.md, Known gaps).

## Setup

Once per clone: `tools/setup.sh`, then `tools/reference.sh`. Both are
idempotent. `.cache/` and `.venv/` are gitignored.

## Texture workflow

Use the `retexture` skill (`.claude/skills/retexture/SKILL.md`) for any new
or changed texture. In short: find the vanilla path and size, find the
nearest RubyDung tile, preview both, derive the palette, write the PNG
pixel by pixel with a small Pillow script, preview it tiled and next to
vanilla, then the task loop.

You can't see 16×16 PNGs well directly. Always look through
`tools/preview.py` (it writes `.cache/preview/*.png`; Read that file).

## Task loop

For every task:

1. Implement it.
2. Run `tools/check.sh` and fix everything it reports.
3. Add a line under `## [Unreleased]` in `CHANGELOG.md` (Added / Changed /
   Fixed / Removed) if a player would notice.
4. Write an ADR in `docs/adr/` if the change decides something about the
   look, compatibility or distribution (see ADR 0001).
5. Update SPEC.md (coverage, known gaps) and README.md if what they claim
   changed. README.md is the Modrinth page: every claim must match a file.
6. Commit: imperative, concise subject; body only if the why isn't obvious;
   end with the co-author trailer your harness asks for.
7. `git push`. Don't wait for confirmation.

Don't ask for screenshots or wait for an in-game check. The user tests on
their own and tells you when something is wrong.

## Visual verification

Only when the user reports a problem, or asks you to look. You can't see the
game: ask them to reload resources in-game (F3+T) and press F2, then read the
newest screenshot:

```sh
sh -c '. ./.local.env; IFS=:; for d in $MC_DIRS; do
  ls -t "$d/screenshots"/*.png | head -1; done'
```

(`sh -c` because zsh doesn't split `$MC_DIRS` on `IFS`.)

`.local.env` is gitignored and holds `MC_DIRS`, a colon-separated list of
`.minecraft` directories of 1.20.1 dev instances. If it is missing, ask the
user for the paths, write it, and run `tools/install.sh`, which symlinks the
repo into each instance's `resourcepacks/rubydung`.

## Release

Only when the user says **release**. Never on your own initiative.

1. Pick the SemVer bump: patch = fixes and art tweaks; minor = newly
   covered textures or visible look changes; major = a dropped Minecraft
   version or a reverted art direction.
2. In `CHANGELOG.md`, rename `## [Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD`
   and add a fresh empty `## [Unreleased]` above it. Commit and push.
3. Run `tools/release.sh X.Y.Z --dry-run`, read the output, then
   `tools/release.sh X.Y.Z`. It checks, builds the zip, tags, creates the
   GitHub release, uploads the version to Modrinth (`tools/modrinth.json`),
   syncs the Modrinth page from README.md, and submits the project for
   review if it is still a draft.

README.md is the Modrinth page body: change the page by editing README.md,
never on the site. The page metadata (summary, license, categories, sides,
links) was set once through the API (ADR 0005).

## Privacy

- The only identity in this repo is `HandLock_` with
  `54068030+Hand-Lock@users.noreply.github.com`. Check `git config user.email`
  before the first commit.
- Never commit emails, real names, local paths (`/Users/…`), or tokens.
  `tools/check.sh` greps for them.
- The Modrinth token lives in the macOS Keychain (service `modrinth-token`)
  or `$MODRINTH_TOKEN`; never write it to a file.

## References

- Resource pack format: https://minecraft.wiki/w/Resource_pack
- Textures and animation `.mcmeta`: https://minecraft.wiki/w/Resource_pack#Animation
- Block and item models: https://minecraft.wiki/w/Model
- Pack format numbers: https://minecraft.wiki/w/Pack_format
- Pre-Classic history: https://minecraft.wiki/w/Java_Edition_pre-Classic
- Modrinth API v2: https://docs.modrinth.com/api/
- Template this workflow came from: https://github.com/Hand-Lock/billy-boarding
