# Chat: unification roadmap and clone-complete notes

- **When:** 2026-09-08 05:21–05:29 (America/New_York)
- **Saved:** 2026-09-08 05:29 (this file)
- **Cursor transcript (local only):** `~/.cursor/projects/home-catskills-Desktop-flt-compression/agent-transcripts/4fbf2d78-bd6e-414a-9c7b-6eeb2a4b8263`
- **Cursor plan (inception):** `~/.cursor/plans/unification_roadmap_d3e19f46.plan.md`
- **In repo:** `notes/plans/unification-roadmap.md`, `notes/plans/cursor/unification_roadmap_d3e19f46.plan.md`

## What we did

Turned `sources/unification-opportunities.md` into a standing, gated walkthrough (`notes/plans/unification-roadmap.md`). The inventory file stays as the raw count list.

Decided that “save the chat” must also copy **this project’s** Cursor plans from `~/.cursor/plans/` (machine-wide; do not copy other repos) into `notes/plans/cursor/`, including drafts, then commit and push. Bar: a `git clone` of HEAD on another PC is enough to continue planning. Lean/`lake` caches and Cursor UI transcripts stay local.

## Walkthrough order (settled)

S0 live-set → S0a dead theorems → S0b instance walls → S0c V2 forks → S1 one `_eq_two` / `_eq_three` unify → scale → S2 two-chart → S3 `monoidalV2` → S4–S7 later.

Vendor (`aa2d8b34`) stays frozen. Cream stays. Theorems are thin wrappers over `P2M/Sol`; unifying a statement means unifying the Sol proof too.

The first S1 pair is **not** a blind rename: `_eq_two` has `k = 2`; the three side is `_of_three_le_of_eq_three` with `p = 3` and `2 ≤ k ≤ p+1`.

## Not done this session

No Lean edits, no `lake` rebuild, no deletion of the 22 dead theorems.
