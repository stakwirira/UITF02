# ==============================================================================
# TOPAS PARAMETER FILE: Beam Phase-Space Check
# AUTHOR:               Samuel B. Takwirira
# ADVISOR:              Prof. Karl Slifer
# GROUP:                Nuclear Physics Group
# INSTITUTION:          University of New Hampshire
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SESSION & IO
# ------------------------------------------------------------------------------
s:Ts/IfOutputFileAlreadyExists = "Overwrite"
b:Ts/UseQt                     = "False"
i:Ts/NumberOfThreads           = 8

# ------------------------------------------------------------------------------
# 2. GEOMETRY (Pure Vacuum)
# ------------------------------------------------------------------------------
s:Ge/World/Type     = "TsBox"
s:Ge/World/Material = "Vacuum"
d:Ge/World/HLX      = 20 cm
d:Ge/World/HLY      = 20 cm
d:Ge/World/HLZ      = 50 cm

# Thin detector box at Z=0
s:Ge/Detector/Type     = "TsBox"
s:Ge/Detector/Parent   = "World"
s:Ge/Detector/Material = "Vacuum"
d:Ge/Detector/HLX      = 10 cm
d:Ge/Detector/HLY      = 10 cm
d:Ge/Detector/HLZ      = 0.05 mm
d:Ge/Detector/TransZ   = 0 cm

# ------------------------------------------------------------------------------
# 3. BEAM (production beam parameters)
# ------------------------------------------------------------------------------
s:So/Beam/Type         = "Beam"
s:So/Beam/Component    = "World"
s:So/Beam/BeamParticle = "e-"
d:So/Beam/BeamEnergy   = 20 MeV
u:So/Beam/BeamEnergySpread = 0.03
i:So/Beam/NumberOfHistoriesInRun = 100000

d:So/Beam/BeamPositionZ = -10 cm

s:So/Beam/BeamPositionDistribution = "Gaussian"
s:So/Beam/BeamPositionCutoffShape  = "Ellipse" # Required with a Gaussian position distribution
d:So/Beam/BeamPositionSpreadX      = 0.8 cm
d:So/Beam/BeamPositionSpreadY      = 0.8 cm
d:So/Beam/BeamPositionCutoffX      = 2.0 cm
d:So/Beam/BeamPositionCutoffY      = 2.0 cm

# ------------------------------------------------------------------------------
# 4. SCORING
# ------------------------------------------------------------------------------
s:Sc/BeamCheck/Quantity    = "PhaseSpace"
s:Sc/BeamCheck/Component   = "Detector"
s:Sc/BeamCheck/Surface     = "Detector/ZMinusSurface"
s:Sc/BeamCheck/OutputType  = "ASCII"
s:Sc/BeamCheck/OutputFile  = "BeamResults"
b:Sc/BeamCheck/OutputColumnHeader = "True"

# ------------------------------------------------------------------------------
# 5. PHYSICS
# ------------------------------------------------------------------------------
sv:Ph/Default/Modules = 1 "g4em-standard_opt4"