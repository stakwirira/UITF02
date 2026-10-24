# UITF Two-Sided DNP Target Irradiation Study

A TOPAS/Geant4 Monte Carlo study of two-sided 8 MeV electron irradiation used
to prepare cryogenic packed ND3 target material at the Jefferson Lab Upgraded
Injector Test Facility (UITF).

The main question is whether irradiating the target from the front and then
the back can give a traceable dose field through the whole target volume
while keeping the cold-operation heat load reasonable. The analysis reports
only quantities that Monte Carlo transport directly supports: dose, fluence,
spectral diagnostics, energy deposition, radial coverage, and target heat
load.

![Front, mirrored-back, and combined cold cumulative dose through the target](figures_matlab/pptx_deck_assets/01_front_back_superimposed_cold_dose.png)

## Report and Presentation

- [`Project_Report.pdf`](Project_Report.pdf): the project report, *Monte Carlo
  Assessment of Two-Sided 8 MeV Electron Irradiation of Cryogenic ND3 for
  Polarized Target Preparation*. It covers the abstract, methods, results and
  analysis, discussion, conclusion, acknowledgments, data availability, and
  references.
- [`UITF_DNP_TOPAS_MC_Report.pptx`](outputs/manual-20260507-uitf/presentations/uitf-dnp-topas/output/UITF_DNP_TOPAS_MC_Report.pptx):
  the presentation deck built from the analysis figures. Slide previews are in
  [`preview/`](outputs/manual-20260507-uitf/presentations/uitf-dnp-topas/preview/).
- [`UITF2_research_comments.md`](UITF2_research_comments.md): the study
  rationale and validation notes.

## Key Results

- One-sided 8 MeV exposure does not adequately cover the 6.5 cm target
  length.
- Sequential front/back irradiation gives the cumulative dose field the
  proposal needs, expressed in target coordinates.
- Cold case (1 uA): about `4.97e15 e-/cm2` per side, with an estimated heat
  load of `0.064 W` per active side.
- Warm case (10 uA): about `9.97e16 e-/cm2` per side, with an estimated heat
  load of `0.644 W` per active side.
- TOPAS does not model radical chemistry or the final DNP polarization. These
  need ESR, NMR, or polarization benchmarks.

## Files

| Path | Purpose |
| --- | --- |
| `UITF2-050426.txt` | Main TOPAS geometry, beam, and scorer definition. |
| `UITF2-10M-front.txt`, `UITF2-10M-back.txt` | Production cards for the front and back irradiation directions, used by `run_UITF2.command`. |
| `UITF2-100M-front.txt`, `UITF2-100M-back.txt` | Older production cards with legacy filenames, kept so older shortcuts still run. |
| `UITF2-20k-debug.txt` | Quick 20k-history check of the geometry and scorers. |
| `UITF2G-050426.txt` | Wrapper that opens the geometry in the OpenGL viewer. |
| `ChangedParameters_*.txt` | Saved viewer camera states. |
| `analyze_DNP_UITF2.py` | Post-processing and diagnostic figures for a single run. |
| `analyze_DNP_UITF2_MATLAB.m` | Combined front/back analysis and report figures. |
| `run_UITF2.command` | Runs the whole pipeline: both TOPAS runs, then the Python and MATLAB analysis. |
| `UITF_DNP_Output_*` | TOPAS scorer outputs and per-run diagnostic figures. |
| `figures_matlab/pptx_deck_assets/` | Final figure set used in the report and presentation. |
| `G4OpenGL_ViewA_0000.pdf` | Exported geometry rendering. |
| `pandoc_uitf2.yaml` | Pandoc settings used to render the manuscript. |

## Reproducing the Analysis

From this folder, run the front and back production cards and then the
post-processing:

```sh
./run_UITF2.command
```

The wrapper expects TOPAS and MATLAB at the application paths set near the top
of `run_UITF2.command`. The Python analysis needs `numpy`, `pandas`,
`matplotlib`, and `scipy`. If you open the repository root in VS Code, the
default build task runs the same pipeline.

Each production card sets its own history count, so check
`NumberOfHistoriesInRun` before starting a long run.

## Notes

Local collaboration documents and external reference PDFs are deliberately
left out of the repository. The cited literature is listed in the report's
references.
