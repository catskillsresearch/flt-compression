# Unification opportunities (residue only)

Cream stays untouched: paper vocabulary that is not a theorem (FLT + geometry nouns,
`IsModular`, `Place`, `Pic0`, Frey curve, Néron model, …). Everything below is
private residue, or bookkeeping around cream.

Counts are theorem *files* unless noted. I have not rebuilt Lean; this is from
names and a few statement diffs.

Suggested morning order: **0 → 1 → 2 → 3**. The later items are larger and
messier.

---

## 0. Delete before unifying

**22 theorems outside the citation closure of `fermat_last_theorem`.**
The html docs say 19 are cited by no proof. First mechanical win: drop anything
`FinalCheck` does not import, then rebuild.

**2,890 of 106,853 citation edges (2.7%)** do not mention the cited name in the
proof text. Some are instances/notation; some are unused imports. Tightening
those shrinks the live set before you unify.

**Generated `attribute [-instance]` walls.** The site calls them generated.
They dominate file size (see `Thm_FreyPackage_no_frey_package.lean`) and are
copied across thousands of files. Not a theorem-unify, but the largest
*textual* factoring: one shared disable-list, or a `set_option` / scoped
setup, instead of a page of names per file.

**V2/V3/V4 definition forks (33 modules),** e.g.
`MazurCase1Bundle` / `MazurCase1BundleNoBT1`,
`JOnePOpsV2`/`V3`, `JZeroGoodReductionV2`/`V3`,
`JZeroNeronTorsionSheafV4`, `SheafOfModules_MonoidalV2`,
`MvFormalGroup_*V2`. These look like API restatements kept because both
callers exist. Keep one interface; re-prove the other as an abbrev.

---

## 1. Best first unify: `p = 2` vs `p = 3` copies

**259 exact name pairs** differing only by `_eq_two` / `_eq_three`
(and often a matching `_of_dvd` suffix).

Hot spots:

- `ModularCurve.FullLevel.Diamond.AuxLevel.*` (rigid-chart / Igusa /
  invariants / inertia law)
- `FullLevelTate.exists_linearMap_tateProd_…`
- `GaloisRep.exists_stableLine_of_theta_T_ne_zero_…`
- `LanglandsTunnell.Artin.exists_transferData_of_finrank_eq_{two,three}`
- `ModularCurve.FullLevel.AuxLevel.exists_isLevelAutAt_of_mem_gamma0_of_eq_{two,three}`

I read one pair. They are *almost* the same theorem, not identical:

- `…_eq_two`: extra `k = 2`
- `…_eq_three`: `p = 3` and `2 ≤ k ≤ p+1`

So the unify is “one lemma in the weight/level, specialize,” not a
blind rename. Still the cleanest large family: same prototype, one
numeric parameter, paper-level objects (`ρ`, Hecke `T`, Igusa) stay
cream and are only *used*.

**Also nearby:** `_of_five_le` (61 theorems), `_of_eq_two` without a
three-twin, `_finrank_eq_two` (77, automorphic). Same pattern:
specialize a prime or a rank that a paper would write as “let ℓ = 2 or 3.”

---

## 2. Two-chart / glued-curve stencil (biggest structural copy)

Several packages are the same geometric picture — a curve (or model)
glued from two affine charts, with immersions `fInf`/`ιInf`/`fFin`/`ιFin`
(or `0`/`∞`) and a special fibre — then hundreds of lemmas restated
per package:

| package | theorems |
|---|---:|
| `PlaceSpecialization` | 704 |
| `XHDRModelAtP` | 313 |
| `DRModelPackage` (not Resolved) | 274 |
| `XOneP` + `twoChartModel_x1_mul` | 264 |
| `IgusaScheme` | 132 |
| `TwoChartIntegralModel` | 127 |
| `DRResolvedModel*` | 36 |

Cream here is “semistable model / two charts / Igusa / Drinfeld.” The
residue is `*Package`, `*Input`, `*Witness`, and the lemma clones
(`isOpenImmersion_fInf` four times, `preimage_closure_image_range_comp_eq`,
`exists_residueField_point_baseChangeMap`, …).

Natural factoring: one `TwoChartModel` interface (the four immersions +
overlap + special fibre), prove the chart lemmas once, instantiate for
DR / XHDR / Igusa / X1(p) / integral models.

`V3Glue.ChartInput` / `RawChartInput` / `GlueInput` is the same idea
one layer down (pure bookkeeping).

---

## 3. `monoidalV2` — same lemmas, second monoidal API

**68 theorems** named `*_monoidalV2` with a matching un-suffixed twin
(and more V2-only). Clustered in
`AlgebraicGeometry.Scheme.Modules.IsInvertible_*` (invertible sheaves,
`zeroSchemeIdeal`, `tensorPow`, Euler characteristic).

This is an elaborator/API fork (old vs new monoidal `Scheme.Modules`),
not two mathematical theorems. One statement; two `abbrev`s if Lean
needs both spellings.

Related def modules: `SheafOfModules_MonoidalV2`,
`AlgebraicGeometry_Modules*V2` (about 8 files).

---

## 4. Limit-over-finitely-generated-subalgebras

**61 theorems** `exists_fg_subalgebra_…`. Typical shape (affine case):

> there is a finitely generated `A₀`-subalgebra `T ⊆ A` through a
> given finite set, and the scheme-theoretic property (pullback,
> proper+flat, iso, …) descends to `Spec T`.

The property varies (`IsPullback`, `IsProper ∧ Flat`, `IsIso`, …
). That is a standard “spread out from ℤ / from a finite-type
subring” schema. One lemma parameterized by a class of morphisms
closed under the relevant limits would eat most of these.

Same pattern shows up under `CerednikDrinfeld.QM.FakeEllipticCurve`
(`exists_fg_subalgebra_isPullback_…`). Do not unify the cream object
(fake elliptic curve / QM surface); unify the descent lemma.

---

## 5. Deformation / square-zero / Pic obstruction (AG residue)

**66** `SmallExtension` theorems: `isTangentCoordsOfPairAt(Via)`,
`isPicDeformationCocycle`, `isPicObstructionCocycle`,
`isFibreReading`, `isTangentOfPair`.

These are the same square-zero extension calculus with the cocycle
written in three dialects (tangent, Pic deformation, Pic obstruction).
A paper would have one “first-order deformations of a sheaf / of a
map.” Keep `Pic` as cream; fold the three cocycle languages.

**173** `IsInvertible` + **86** `eulerChar` + **20** `IsFrameOn`
are the same invertible-sheaf toolkit (Hilbert polynomial, frames,
zero scheme). Overlaps the `monoidalV2` fork.

---

## 6. Parallel “geometry of J₀ / X₁ / special fibre”

Not one stencil, but three that should each collapse internally:

- **`JZeroNeron*` (166 theorems)** plus def twins
  `JZeroNeronData` / `…AtPData` / `…AtPDataCore` / `…OrdV22` /
  `PrimaryTorsionSheaf` / `TorsionSheafV4` / `TorsionFlag` /
  `PrimaryTorsionFlag`. Same Néron object, many data wrappers.
  Cream = Néron model of \(J_0(N)\), identity component, torsion.
  Residue = the `*Data` / `*Flag` / `*SheafV4` records and their
  lemma clones.

- **`RelativeGroupLaw` (417)** — group law on a Jacobian / abelian
  scheme over a base, restated for `AlgPoints`, `KerPair`, `Fibre`,
  `Translate`, `nsmul`. One relative group-law API.

- **`QM.FakeEllipticCurve` (741)** — largest single namespace of
  clones (`of_not_dvd`, `of_two_mul_dvd`, `of_five_le`, `of_isAlgClosed`,
  …). Cream = quaternionic fake elliptic curve / Shimura moduli.
  Residue = the case-split lemmas. Unify *after* the two-chart work;
  this one will fight typeclass search.

---

## 7. Patching / Hecke-local / two lifting theorems

**37** `CuspForm.heckeLocal` theorems about `patchingDatum`,
`taylorWilesModule`, `cornerData`, `h1CornerData`, ordinary vs
non-flat. Plus the two cream-adjacent lifting theorems:

- `modularityLiftingAtConductor_threeFive_of_level_of_not_sq_dvd_of_not_cube_dvd`
  (`p = 3 ∨ p = 5`, `¬ p² ∣ M₀`)
- `…_of_inertia_moves_torsion_of_eq_three_of_not_cube_dvd`
  (`p = 3`, extra inertia-fixed 3-torsion hypothesis when `9 ∣ M₀`)

PROOF-PATH already presents these as two cases of one Wiles lifting.
A single theorem with a `p = 3 ∨ p = 5` disjunct and an optional
inertia hypothesis is the paper-shaped unify. The 37 `heckeLocal`
lemmas underneath look like the same corner/patching argument with
the ordinary/flat/level-raising switches as parameters.

`MazurCase1Bundle` vs `MazurCase1BundleNoBT1` is the same story one
step lower: `OdaDictionary` with or without a BT1 flag. `VerFrobPair`
(Frobenius + Verschiebung, compositions zero) is a real small object;
the two dictionaries around it are packaging.

---

## 8. What I would *not* unify

- Cream nouns: `FreyPackage` as a *name*, `Place`, `Pic0`,
  `IsCurveOver`, Hecke algebra, deformation ring, Shimura curve.
  You may still delete unused *fields* of those structures.
- Landmark *theorems* (`Mazur_Frey`, `frey_isModular`, Ribet, LT)
  — different proofs are allowed, but do not merge them into one
  parameterized gadget just because they all say `False` or
  `IsModular`.
- `FakeEllipticCurve` × `XOneP` × `DRModel` as a single type.
  Same *chart lemmas*, different moduli problems.
- Any pair whose hypotheses actually differ in a way a paper would
  keep (the `k = 2` vs `2 ≤ k ≤ p+1` pair is the warning).

---

## Concrete first experiment (30–60 minutes of reading)

1. Open the 259 `_eq_two` / `_eq_three` pairs; skim
   `Theorems/Thm_GaloisRep_exists_stableLine_of_theta_T_ne_zero_of_det_eq_pow_of_eq_{two,three}.lean`
   and one `FullLevel.Diamond.AuxLevel` pair.
2. Decide the parameter (`p` vs weight `k` vs “level 2 or 3”).
3. Try *one* unified statement that specializes to both, without
   touching cream definitions.
4. If that works, the same script applies to the other ~250 pairs.

If you would rather start with deletion: compute the import closure
of `FinalCheck.lean` and list `Def_` / `Thm_` files outside it.
That is strictly required-for-check, no unification judgment needed.
