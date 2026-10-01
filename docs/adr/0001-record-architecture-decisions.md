# 0001. Record architecture decisions

Date: 2026-10-01
Status: Accepted

## Context

RubyDung is developed largely by AI agents in short sessions. Without a
record, each session re-derives or silently reverses earlier choices, and
pixel-art decisions (which tile a texture comes from, why a palette looks
the way it does) are easy to lose.

## Decision

Record decisions in `docs/adr/NNNN-slug.md` using a short Nygard format:
Status, Context, Decision, Consequences. Write one when a change decides
something about the look, compatibility, or distribution. Bug fixes, new art
and newly covered textures that follow an existing pattern don't need one.

Statuses: Proposed, Accepted, Accepted — not yet implemented, Superseded by
NNNN. Don't rewrite an accepted ADR's decision; supersede it with a new one.

## Consequences

Agents read `docs/adr/` before changing the art direction or compatibility
(AGENTS.md says so). Reasons survive after the conversation that produced
them is gone.
