# 0009. Ship only what differs from the base

Date: 2026-10-01
Status: Accepted; refines 0007; refined by 0011

## Context

0007 made RubyDung an add-on over Golden Days Base + Alpha or PACP+. It
didn't say what an add-on texture must add. A texture that matches the base
pack only overrides it with the same pixels, and proposals for other tool
tiers, ingots, coal, diamond and birch or cherry bark would have done that.

Comparing the 2009 tiles with Golden Days Base/Alpha 16.4:

- rd-160052 dirt (tile 2), grass side (3) and "new stone" (1) are identical
  to Golden Days: 0 pixels differ.
- Golden Days doesn't retexture bedrock, so players see the 1.14 redesign.
  rd-161348 tile 17, the Classic-to-Beta bedrock, differs in 94 of 256
  pixels (black specks instead of dark grey).
- The pack's water and lava were static and overrode Golden Days' animated
  ones.

## Decision

Ship a texture only if it is the actual older texture, or an older variant
that is substantially different from what the base pack already shows
(including vanilla textures the base leaves alone). Before adding one,
diff it against the base packs.

So: bedrock is in; dirt, grass side and the new stone are left to the base;
water and lava are animated from the 2009 tiles (tile 14, and tile 30 in
its exact colours) so they no longer replace motion with stillness. The
double-headed axes stay because they differ.

## Consequences

- Fewer textures, each one visibly RubyDung.
- A texture that later turns out to match the base should be removed.
- Liquid motion is derived (pre-0.0.19a liquids were static): the 2009
  tiles scroll 1 px per frame, without `interpolate` (ADR 0003).
