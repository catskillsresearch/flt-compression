# Chat: vendoring FLT and semantic compression

- **When:** 2026-09-07 23:38 – 2026-09-08 05:18 (America/New_York)
- **Saved:** 2026-09-08 05:18 (this file)
- **Cursor transcript (local only):** `~/.cursor/projects/home-catskills-Desktop-flt-compression/agent-transcripts/4fbf2d78-bd6e-414a-9c7b-6eeb2a4b8263`
- **Related artifacts:** `vendor/`, `vendor/FROZEN.txt`, `sources/proof_visualization.png`, `sources/unification-opportunities.md`, `notes/README.md`, `.cursor/rules/preserve-project-notes.mdc`

## What we did

Vendored Anthropic’s Lean 4 FLT tree from `../fermats-last-theorem` (pin `aa2d8b34`, origin `https://github.com/anthropics/fermats-last-theorem`) into `vendor/fermats-last-theorem`. First commit `d53fbec` pushed to `https://github.com/catskillsresearch/flt-compression`. Later the user committed `sources/` (`cca63043`, message `sourcse`).

## Visualization

`sources/proof_visualization.png` is a radial spanning tree of the citation DAG. The flower shape is layout. Uneven lobes and labeled wedges (Mazur, Ribet, Langlands–Tunnell, R=T) are real subtree mass. Coloring by first landmark overstates independence: a lot of infrastructure is shared.

## Gzip is not semantic compression

`gzip -9` on all Lean sources: 1.17 GB → 187 MB (**84% saved**). A 25 MB proof sample: 82% original, 68% after line-shuffle, 62% after token-shuffle, 27% after byte-shuffle. Most of the win is repeated long identifiers and `attribute [-instance]` walls, not a short encoding of the argument.

## Goal (settled)

Semantic compression: a smaller, still-readable development that **proves the same**

```lean
theorem fermat_last_theorem (n : ℕ) (hn : 3 ≤ n)
    (a b c : ℕ) (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    a ^ n + b ^ n ≠ c ^ n
```

from `propext`, `Classical.choice`, `Quot.sound` (and Mathlib’s `FermatLastTheorem` via `FinalCheck.lean`). A *different* shorter proof is fine. Mathlib’s ring/field/ℕ/`^` stay.

## Three layers

**Cream — do not compress.** Paper vocabulary that is not a theorem: FLT words and geometry words (`Frey` curve, residual representation, Eisenstein ideal, place, Pic⁰, formal group, Néron model, …) and paper predicates (`IsModular`, `IsCurveOver`). Not Mazur-the-theorem; yes Eisenstein-ideal-the-object. On the order of 100–200 notions, not 1,450 `Def_` files.

**Bookkeeping — delete if the kernel does not need it.** `*Datum`, `*Input`, `*Section`, `*Package`, glue records, generated instance-disable walls. Test: live import closure of `FinalCheck`, then rewrite users of live-but-only-a-tuple structures.

**Residue — black box, unify here.** Private lemmas that establish the cream. Same prototype → one general theorem plus instances. Embeddings are a cluster index, not a codec: you cannot decompile a subspace back into Lean.

## Inventory (this tree)

| | count |
|---|---:|
| Theorems | 29,511 |
| Definition modules | 1,450 (~13 MB) |
| Declarations in `Def_` | 33,391 (of which 19,140 are theorems/lemmas) |
| Structures / classes / inductives | 532 |
| Citation edges | 106,853 (2.7% unused by name) |
| Outside FLT citation closure | 22 theorems |

## Unification list

See `sources/unification-opportunities.md`. Morning order:

0. Delete dead theorems; share/kill generated `attribute [-instance]` walls; collapse V2/V4/NoBT1 def forks (33 modules).
1. **259** `_eq_two` / `_eq_three` pairs (parameterize; one checked pair differs by `k = 2` vs `2 ≤ k ≤ p+1`).
2. Two-chart stencil: PlaceSpecialization / XHDR / DR / X1(p) / Igusa / integral models.
3. 68 `*_monoidalV2` API twins.
4. 61 `exists_fg_subalgebra_*`; 66 SmallExtension cocycle dialects; J₀ Néron data wrappers; two modularity-lifting cases.

Do not smash Fake-elliptic / X1(p) / DR into one type, or merge landmark theorems.

## How to keep chats on GitHub (implemented)

Cursor chats are local only. This repo now keeps them as files:

- `notes/README.md` — convention
- `notes/chats/` — session write-ups
- `notes/plans/` — standing plans
- `.cursor/rules/preserve-project-notes.mdc` — agent reminder
- First notes commit: `0e32d60a`

Say “save the chat” after a useful session; the agent writes under `notes/` and pushes if the remote should get it. This file is that save.
