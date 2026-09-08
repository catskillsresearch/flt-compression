# Project notes

Cursor chats, transcripts, and plans under `~/.cursor` are **not** in git.
They live on this machine and can vanish if the workspace is removed or
the editor cache is cleared. A `git clone` of the last pushed commit on
another PC must be enough to continue this work. Anything we want kept
has to be a file in this repo, committed and pushed.

## Layout

| path | what |
|---|---|
| `notes/chats/` | Session write-ups (decisions, not tool traces) |
| `notes/plans/` | Standing plans you step through |
| `notes/plans/cursor/` | Verbatim Cursor `.plan.md` files (original slug+hash names) |
| `sources/` | Working artifacts (images, opportunity lists) |

Standing plan: [unification-roadmap.md](plans/unification-roadmap.md).
Raw inventory: [`sources/unification-opportunities.md`](../sources/unification-opportunities.md).

## Habit

After a substantial chat, or when asked to “save the chat”:

1. Write `notes/chats/YYYY-MM-DD-short-slug.md` (or append if the same thread continues the same day).
2. Copy this project’s Cursor plans from `~/.cursor/plans/` (and the workspace `.cursor/plans/` if present) into `notes/plans/cursor/`. Include drafts. Keep the original filename. Match by content (`flt-compression`, `vendor/fermats-last-theorem`, …); do not copy other repos’ plans from the machine-wide folder.
3. Update standing plans under `notes/plans/` if the session changed them.
4. Commit and push. Clone-of-HEAD is the bar.

A Cursor rule (`.cursor/rules/preserve-project-notes.mdc`) reminds the agent to do this.

A clone will not have Lean/`lake` caches or Cursor UI transcripts. Those can be rebuilt. Planning state cannot.
