# Project notes

Cursor chats and agent transcripts are **not** in git. They live on this
machine under Cursor’s project folder and can vanish if the workspace is
removed or the editor cache is cleared. Anything we want on GitHub has to
be a file in this repo, committed and pushed.

## Layout

| path | what |
|---|---|
| `notes/chats/` | Session write-ups (decisions, not tool traces) |
| `notes/plans/` | Standing plans and architecture notes |
| `sources/` | Working artifacts (images, opportunity lists) |

## Habit

After a substantial chat, or when asked to “save the chat”:

1. Write `notes/chats/YYYY-MM-DD-short-slug.md` (or append if the same thread continues the same day).
2. Put lasting plans in `notes/plans/`.
3. Commit and push with the rest of the work.

A Cursor rule (`.cursor/rules/preserve-project-notes.mdc`) reminds the agent to do this.
