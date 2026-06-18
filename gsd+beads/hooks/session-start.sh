#!/usr/bin/env bash
# gsd-beads SessionStart hook.
# Only emits context when the project uses BOTH GSD and beads.
# Anything printed to stdout is injected into the session as additional context.
set -euo pipefail

# Resolve project dir: prefer the hook payload's cwd, fall back to $PWD.
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$PWD}"

if [ -d "$PROJECT_DIR/.planning" ] && [ -d "$PROJECT_DIR/.beads" ]; then
  cat <<'MSG'
[gsd-beads] This repo uses BOTH GSD (.planning/) and beads (.beads/).
The gsd-beads integration is active — use the `gsd-beads` skill conventions:
  • each phase NN maps requirements -> bd ids in .planning/phases/NN-*/NN-BEADS-MAP.md
  • every bd issue carries label phase-N ; list with: bd list -l phase-N
  • every PLAN.md carries a `beads:` frontmatter list of the bd ids it advances
  • execute-phase: claim -> in_progress -> close each plan's bd ids
  • on conflict, GSD phase docs (CONTEXT/PLAN/ROADMAP) win over bd issue text
  • use `bd` for ALL task tracking (not TodoWrite / markdown TODOs)
Run `bd prime` for the full bd command reference and session-close protocol.
MSG
fi

exit 0
