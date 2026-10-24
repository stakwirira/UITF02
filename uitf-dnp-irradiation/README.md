# UITF Two-Sided DNP Target Irradiation Study

A TOPAS/Geant4 Monte Carlo study of two-sided 8 MeV electron irradiation for
preparing cryogenic packed ND3 target material at the Jefferson Lab Upgraded
Injector Test Facility (UITF).

The study asks whether irradiating the target from the front and then from the
back can produce a traceable dose field through the whole target while keeping
the cold-operation heat load reasonable. It reports only quantities that Monte
Carlo transport supports directly: dose, fluence, spectral diagnostics, energy
deposition, radial coverage, and target heat load.

## Report and Presentation

- [`Project_Report.pdf`](Project_Report.pdf): *Monte Carlo Assessment of
  Two-Sided 8 MeV Electron Irradiation of Cryogenic ND3 for Polarized Target
  Preparation* (May 2026).
- [`presentation/UITF_DNP_TOPAS_MC_Report.pptx`](presentation/UITF_DNP_TOPAS_MC_Report.pptx):
  the presentation deck, with slide previews in
  [`presentation/preview/`](presentation/preview/).

## Key Results

- A single-sided 8 MeV exposure does not cover the 6.5 cm target length.
- Irradiating the front and then the back gives the cumulative dose field the
  proposal needs, expressed in target coordinates.
- Cold case (1 uA): about `4.97e15 e-/cm2` per side, with an estimated heat
  load of `0.064 W` per active side.
- Warm case (10 uA): about `9.97e16 e-/cm2` per side, with an estimated heat
  load of `0.644 W` per active side.
- TOPAS does not model radical chemistry or the final DNP polarization; these
  need ESR, NMR, or polarization benchmarks.

## Files

| Path | Purpose |
| --- | --- |
| `UITF2-050426.txt` | Main TOPAS geometry, beam, and scorer definition |
| `UITF2-10M-front.txt`, `UITF2-10M-back.txt` | Front and back production cards run by `run_UITF2.command` |
| `UITF2-100M-front.txt`, `UITF2-100M-back.txt` | Earlier production cards, kept because existing outputs cite them |
| `UITF2-20k-debug.txt` | Short 20,000-history check of the geometry and scorers |
| `UITF2G-050426.txt` | Opens the geometry in the OpenGL viewer |
| `analyze_DNP_UITF2.py` | Post-processing and diagnostic figures for one run |
| `analyze_DNP_UITF2_MATLAB.m` | Combines the front and back runs and makes the report figures |
| `run_UITF2.command` | Full pipeline: both TOPAS runs, then the Python and MATLAB analysis |
| `*.csv` (this folder) | Scorer outputs from the most recent back-side run |
| `UITF_DNP_Output_*/` | Scorer outputs and diagnostic figures, one folder per run |
| `figures/` | Diagnostic figure from the single-run analysis |
| `figures_matlab/` | MATLAB summary tables and figures; `pptx_deck_assets/` holds the report and deck figures |
| `geometry_view.pdf` | Exported OpenGL rendering of the geometry |

Each scorer CSV starts with a TOPAS header that names the parameter file that
produced it.

## Reproducing the Analysis

From this folder, run:

```sh
./run_UITF2.command
```

This runs the front and back production cards and then the analysis. The
script expects TOPAS and MATLAB at their default macOS install locations. To
use other installs, set `TOPAS_DIR` (or `TOPAS`), `MATLAB`, and
`TOPAS_G4_DATA_DIR`, for example:

```sh
TOPAS_DIR=/opt/topas MATLAB=/usr/local/bin/matlab ./run_UITF2.command
```

The Python analysis needs `numpy`, `pandas`, `matplotlib`, and `scipy`. Each
production card sets its own history count (`NumberOfHistoriesInRun`), so
check it before starting a long run.

## Notes

Collaboration documents and reference papers are not included. The cited
literature is listed in the report's references.
