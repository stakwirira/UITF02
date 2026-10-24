# UITF02 DNP Target Irradiation Study

This repository contains a TOPAS/Geant4 Monte Carlo study of two-sided 8 MeV electron irradiation for cryogenic packed ND3 target material preparation at the Jefferson Lab Upgraded Injector Test Facility (UITF).

The primary question is whether a front/back irradiation protocol can deliver a traceable target-volume dose field while keeping the cold-operation heat load within a reasonable range. The analysis reports quantities directly supported by Monte Carlo transport, including dose, fluence, spectral diagnostics, energy deposition, radial coverage, and target heat load.

## Report

- `Project_Report.md` serves as the main report source.
- `pandoc_uitf2.yaml` and `uitf2_manuscript.css` assist in HTML rendering.
- `outputs/manual-20260507-uitf/presentations/uitf-dnp-topas/output/UITF_DNP_TOPAS_MC_Report.pptx` is the presentation deck prepared from the analysis figures.

The report comprises an abstract, methods, results and analysis, discussion, conclusion, acknowledgments, data availability statement, and references.

## Key Results

- The 6.5 cm target length is not adequately represented by a single-sided 8 MeV electron exposure.
- Sequential front/back irradiation achieves the proposal-relevant cumulative target-coordinate dose field.
- The cold 1 uA case delivers approximately `4.97e15 e-/cm2` per side, with an estimated heat load of `0.064 W` per active side.
- The warm 10 uA case delivers approximately `9.97e16 e-/cm2` per side, with an estimated heat load of `0.644 W` per active side.
- Radical chemistry and final DNP polarization are not directly modeled by TOPAS and require ESR, NMR, or polarization benchmarking.

## Main Files

- `UITF2-10M-front.txt` and `UITF2-10M-back.txt`: production TOPAS cards for the front and back irradiation directions.
- `UITF2-050426.txt`: contains the main TOPAS geometry and scorer definition.
- `UITF2G-050426.txt`: serves as a wrapper for the OpenGL geometry viewer.
- `analyze_DNP_UITF2.py`: post-processes the single-run scorer.
- `analyze_DNP_UITF2_MATLAB.m`: combines front/back analysis and generates a report figure.
- `figures_matlab/pptx_deck_assets/`: contains the final figure assets used in the report and presentation.

## Figure Preview

## Reproducing the Analysis

To reproduce the analysis, run the front and back production cards, followed by the post-processing scripts:

```sh
./run_UITF2.command
```

The wrapper expects TOPAS and MATLAB to be installed in the application paths specified near the top of `run_UITF2.command`. The Python analysis requires the installation of `numpy`, `pandas`, `matplotlib`, and `scipy`. # UITF02-EDITS

