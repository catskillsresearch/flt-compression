# flt-compression

A smaller, still-readable Lean 4 development of Fermat's Last Theorem, obtained
by semantic compression of [Anthropic's formalization](https://github.com/anthropics/fermats-last-theorem)
(commit `aa2d8b34692b16c70f699536de0d8e75b9a3e9ef`). The proof uses
**Lean 4.33.1** (`lean-toolchain`) and Mathlib `v4.33.0` (commit
`db584cd6d46c92f209a44c0f1c829460d327499d` in `lakefile.lean`).

The target is the same theorem, from the same three axioms:

```lean
theorem fermat_last_theorem (n : ℕ) (hn : 3 ≤ n)
    (a b c : ℕ) (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    a ^ n + b ^ n ≠ c ^ n
```

`propext`, `Classical.choice`, `Quot.sound`. A different shorter proof is
allowed. Mathlib's ring/field/ℕ/`^` stay. Check via `factored/FinalCheck.lean`,
which also derives Mathlib's `FermatLastTheorem`.

This is an update of the vendored tree, not a fork of Mathlib. Paper vocabulary
(Frey curve, residual representation, Néron model, `IsModular`, …) is kept.
Bookkeeping records and duplicated residue lemmas are what we delete or unify.
The walkthrough is [notes/plans/unification-roadmap.md](notes/plans/unification-roadmap.md).

## Layout

| path | role |
|---|---|
| `vendor/fermats-last-theorem` | Gitlink only: [anthropics/fermats-last-theorem@aa2d8b34](https://github.com/anthropics/fermats-last-theorem/tree/aa2d8b34692b16c70f699536de0d8e75b9a3e9ef) |
| `factored/` | Working Lean sources: import closure of `FinalCheck` only |
| `lakefile.lean`, `lean-toolchain`, `lake-manifest.json` | Lake project (sources live under `factored/`) |
| `notes/` | Session write-ups and standing plans |
| `sources/` | Inventory and working artifacts |

See [vendor/FROZEN.txt](vendor/FROZEN.txt) and [vendor/FACTORED.txt](vendor/FACTORED.txt).
Do not `git clone --recurse-submodules` or `git submodule update --init`; that
would fetch the original 1.6 GB tree. The pin is the gitlink in this repo.

## Check the working tree

You need Linux or macOS, [elan](https://github.com/leanprover/elan), and a
network connection (Lake fetches Mathlib). From a clone:

```sh
lake build
```

Success ends with `fermat_last_theorem` / `flt_mathlib` depending on
`propext`, `Classical.choice`, `Quot.sound`. The first build compiles Mathlib
from source and needs a large machine; the [upstream README](https://github.com/anthropics/fermats-last-theorem/blob/aa2d8b34692b16c70f699536de0d8e75b9a3e9ef/README.md)
describes memory and time.

## Licence

Apache License 2.0, same as the upstream work. See [LICENSE](LICENSE) and
[NOTICE](NOTICE).

Copyright 2026 Anthropic, PBC (vendored sources and unmodified copies).
Copyright 2026 The flt-compression authors (this repository's own files and
later edits in `factored/`).

Third-party Apache-2.0 material in the upstream tree (Imperial College London
FLT, flt-regular, Mathlib excerpts) is listed in the
[upstream NOTICE](https://github.com/anthropics/fermats-last-theorem/blob/aa2d8b34692b16c70f699536de0d8e75b9a3e9ef/NOTICE)
and
[ATTRIBUTION.md](https://github.com/anthropics/fermats-last-theorem/blob/aa2d8b34692b16c70f699536de0d8e75b9a3e9ef/ATTRIBUTION.md).
The root [NOTICE](NOTICE) reproduces those attributions.
