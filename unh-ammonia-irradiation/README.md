# UNH Ammonia Target Irradiation Studies

TOPAS/Geant4 studies of electron irradiation of solid ammonia (ND3 and NH3)
for polarized-target preparation, carried out in the UNH Nuclear Physics Group
under Prof. Karl Slifer from December 2025 to April 2026.

These studies built up the geometry, materials, scoring, and analysis approach
that the [UITF two-sided irradiation study](../uitf-dnp-irradiation/) later
used.

## Model

All parameter files share the same base setup:

- **Beam:** 20 MeV electrons with 3% energy spread and a Gaussian spot cut off
  at 2 cm.
- **Cryostat:** aluminum dewar (9.2 cm outer radius) filled with a
  liquid-argon bath.
- **Target:** ammonia basket inside the bath, offset 5 cm from the dewar
  center.
- **Physics:** `g4em-standard_opt4` for low-energy electron transport.
- **Scoring:** depth profile of deposited energy (reported as -dE/dz) and 2D
  dose-uniformity maps. From late February 2026 onward, NH3 and LAr are
  scored separately.

## Development of the Model

| Date (2026) | Parameter file(s) | Change |
| --- | --- | --- |
| Jan 21–27 | `2026-01-21_TOPAS_ND3*`, `2026-01-23_TOPAS_ND3*`, `20260127ND3.txt` | Static solid-ND3 box basket in the LAr bath; `_Ge` files are geometry-check variants |
| Feb 16 | `20260216ND3.txt` | Time features added to model target rotation |
| Feb 23 | `20260223NH3Rot.txt` | Spherical NH3 target rotated through 2π, with accumulated 2D map and depth profile |
| Feb 23 | `voxel-phantom/20260223NH3-4D.txt` | First voxelized NH3/LAr phantom |
| Feb 26 | `20260226ND3Rot.txt` | Rotating sphere of homogenized 65% ND3 + 35% LAr |
| Feb 27 | `20260227NH3Rot.txt`, `20260227NH3RotPi.txt` | Packed 1 mm NH3 spheres (packing fraction ≈ 0.55) in LAr, rotating |
| Mar 4–8 | `20260304NH3.txt`, `20260308NH3.txt` | Packed-sphere target without rotation; NH3 and LAr scored separately |
| Mar 23–25 | `20260323NH3.txt`, `20260325NH3.txt` | 1 mm NH3 spheres on a repeated 52 × 52 × 105 lattice |
| Mar 26 | `voxel-phantom/20260326NH3.txt` | 250 × 250 × 500 voxel phantom (0.2 mm voxels) of randomly placed NH3 spheres in LAr |

## Folder Layout

| Folder | Contents |
| --- | --- |
| `parameter-files/` | TOPAS parameter files, named by date |
| `voxel-phantom/` | `generate_phantom.py`, its output (`phantom.raw`, `materials.txt`), and the two parameter files that load the phantom |
| `beam-check/` | `beam_check.txt` (TOPAS) and `analyze_beam_check.m` (MATLAB), which check the beam against its specification |
| `analysis/` | MATLAB scripts for depth-dose profiles and bilateral (two-sided) superposition |
| `results/` | TOPAS scorer outputs (CSV) and time-feature particle counts |
| `logs/` | TOPAS console logs, named after the parameter file that was run |
| `figures/` | Geometry views, the bilateral-irradiation coordinate sketch, and exported plots |
| `presentations/` | Slide deck summarizing the method and early results |

## Running

**TOPAS.** Run a parameter file from the folder where you want its CSV
output written:

```sh
cd parameter-files
topas 20260308NH3.txt
```

The voxel-phantom cards load `phantom.raw` by relative path, so run them from
`voxel-phantom/`. To rebuild the phantom, run `python3 generate_phantom.py` in
that folder. The sphere positions are random, so a rebuilt phantom will not
match the committed one exactly.

**MATLAB.** The analysis scripts read a CSV by file name from the current
folder. Run them from `results/` with `analysis/` on the path:

```matlab
cd results
addpath ../analysis
plot_bilateral_depth_dose
```

Set the `filename` variable near the top of each script to choose which result
file to plot.

**Beam check.** Run `topas beam_check.txt` in `beam-check/`, then
`analyze_beam_check` in MATLAB. The script reads the `BeamResults.phsp` file
the card writes and reports whether the mean energy, energy spread, and spot
size are within 5% of the intended values.

## Results Files

Each result file is named for its material, quantity, and usually a date, for
example `NH3_DepthDose_0406.csv` or `LAr_Map_032426.csv`. Each file begins with
a TOPAS scorer header that names the parameter file that produced it and gives
the binning and units. A few results, including the `_0406` files, came from
parameter files that are not in the repository (for example
`20260406NH3.txt`), so their headers are the only record of how they were
produced.
