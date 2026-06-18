# gsd-beads

A Claude Code plugin that wires the [GSD](https://github.com/) planning
workflow (`/gsd:*`, `.planning/`) to the [beads](https://github.com/gastownhall/beads)
issue tracker (`bd`, `.beads/`) so phase planning and execution **create,
claim, and close** tracked work automatically.

It is **thin glue** — it does not fork, vendor, or modify GSD or beads. Both
stay independent upstream dependencies; this plugin only ships the convention
that connects them.

## What it does

When a repo contains **both** `.planning/` (GSD) and `.beads/` (beads):

- **Phase ↔ issues** — each GSD phase `NN` maps requirement IDs → bd issue IDs
  in `.planning/phases/NN-<slug>/NN-BEADS-MAP.md`.
- **Labels** — every bd issue for phase `N` carries `phase-N` (`bd list -l phase-N`).
- **Plan frontmatter** — each `PLAN.md` carries `beads: [ids]` it advances.
- **Lifecycle** — `new-project` creates issues, `plan-phase` reads the map and
  sets frontmatter, `execute-phase` claims → in_progress → closes, `ship`
  verifies all closed before push.
- **Precedence** — GSD phase docs win over conflicting bd issue text.

It activates **only** when both directories are present, so it's silent in
non-GSD or non-beads repos.

## Requirements

- [GSD](https://github.com/) installed (provides `/gsd:*`)
- [beads](https://github.com/gastownhall/beads) installed (`bd` on PATH)

## Install

```text
/plugin marketplace add BigJiggity/claude-plugins
/plugin install gsd-beads@claude-plugins
```

## Use

```text
/gsd-beads:init        # bootstrap: git + bd init in the current repo
/gsd:new-project       # then create .planning/ + ROADMAP
```

After both `.planning/` and `.beads/` exist, every `/gsd:*` command follows the
integration convention (see the bundled `gsd-beads` skill).

## Components

| Path | Purpose |
|---|---|
| `skills/gsd-beads/SKILL.md` | the integration convention (loaded on demand) |
| `commands/init.md` | `/gsd-beads:init` — bootstrap a repo |
| `hooks/session-start.sh` | injects an "integration active" reminder when both dirs present |
| `scripts/gsd-beads-init.sh` | the bootstrap script (git + bd init) |

## License

MIT
