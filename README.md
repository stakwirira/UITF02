# UITF02: Electron Irradiation of Polarized Ammonia Targets

Monte Carlo studies (TOPAS/Geant4) of electron-beam irradiation of solid
ammonia (NH3 and ND3) as part of preparing targets for dynamic nuclear
polarization (DNP).

**Samuel B. Takwirira**, Nuclear Physics Group, University of New Hampshire.
Advisor: Prof. Karl Slifer. Carried out in collaboration with the Jefferson Lab
Target Group.

## Background

Before DNP can polarize an ammonia target, irradiation has to create
paramagnetic centers in it. How well a target is prepared depends on more
than the delivered charge. It also depends on where the ionization dose is
deposited, how evenly it covers the target volume, and how much heat a cold
irradiation deposits. These studies use Monte Carlo transport to estimate
those quantities before beam time.

## Studies

| | Study | Period | Setup |
| --- | --- | --- | --- |
| 1 | [UNH ammonia irradiation studies](unh-ammonia-irradiation/) | Dec 2025 – Apr 2026 | 20 MeV electrons; ND3/NH3 target in a liquid-argon bath |
| 2 | [UITF two-sided DNP irradiation](uitf-dnp-irradiation/) | May – Jul 2026 | 8 MeV electrons at JLab UITF; packed ND3 in liquid helium, irradiated from the front and then the back |

The first study developed the geometry, materials, scoring, and analysis
methods that the second study used.

### 1. UNH Ammonia Irradiation Studies

A sequence of TOPAS models of an ammonia target basket inside an aluminum
dewar filled with liquid argon. The models start with a homogeneous ND3 block
and move on to rotating targets (TOPAS time features), packed 1 mm NH3
spheres, regular sphere lattices, and a voxelized random-sphere phantom. Dose
is scored separately in the ammonia and the argon.

### 2. UITF Two-Sided DNP Irradiation

Asks whether an 8 MeV electron beam at the Jefferson Lab Upgraded Injector
Test Facility can irradiate a 6.5 cm packed ND3 target from both faces, giving
a usable dose field at an acceptable cold heat load. The findings are in the
[project report](uitf-dnp-irradiation/Project_Report.pdf):

- A single-sided exposure does not cover the full 6.5 cm target length.
- Irradiating the front and then the back gives the cumulative dose field
  the proposal needs.
- Cold case (1 uA): about `4.97e15 e-/cm2` per side and `0.064 W` heat load
  per active side.
- Warm case (10 uA): about `9.97e16 e-/cm2` per side and `0.644 W` per
  active side.
- TOPAS does not model radical chemistry or the final polarization; these
  need ESR/NMR benchmarks.

## Repository Layout

```
UITF02/
├── unh-ammonia-irradiation/    Study 1
│   ├── parameter-files/        TOPAS parameter files, named by date
│   ├── voxel-phantom/          phantom generator and the cards that use it
│   ├── beam-check/             beam phase-space validation
│   ├── analysis/               MATLAB plotting scripts
│   ├── results/                TOPAS scorer outputs (CSV)
│   ├── logs/                   TOPAS console logs
│   ├── figures/                geometry views and exported plots
│   └── presentations/          slide deck
└── uitf-dnp-irradiation/       Study 2
    ├── UITF2-*.txt             TOPAS geometry and production cards
    ├── analyze_DNP_UITF2.py    single-run analysis
    ├── analyze_DNP_UITF2_MATLAB.m
    ├── run_UITF2.command       full pipeline
    ├── UITF_DNP_Output_*/      scorer outputs and diagnostic figures
    ├── figures_matlab/         report and presentation figures
    ├── presentation/           slide deck and previews
    └── Project_Report.pdf
```

Each study folder has its own README with the details and run instructions.

## Software

- [TOPAS](https://www.topasmc.org/) 3.9 (Geant4-based) with
  `g4em-standard_opt4` electromagnetic physics
- MATLAB R2025a
- Python 3 with `numpy`, `pandas`, `matplotlib`, and `scipy`
