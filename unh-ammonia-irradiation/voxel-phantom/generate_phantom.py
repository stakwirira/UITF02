import numpy as np
import time

start_time = time.time()

print("\n=== VOXEL PHANTOM GENERATION STARTED ===\n")

# -----------------------------
# PARAMETERS (must match TOPAS)
# -----------------------------
voxel_size = 0.02  # cm
R_cyl = 2.5        # cm
H_cyl = 10.0       # cm
sphere_radius = 0.1  # cm

print(f"[INFO] voxel_size = {voxel_size} cm")
print(f"[INFO] cylinder radius = {R_cyl} cm, height = {H_cyl} cm")

# -----------------------------
# GRID SETUP
# -----------------------------
nx = int(2 * R_cyl / voxel_size)
ny = nx
nz = int(H_cyl / voxel_size)

print(f"[INFO] Grid size: {nx} x {ny} x {nz} ({nx*ny*nz:,} voxels)")

print("[STEP] Creating coordinate arrays...")
t0 = time.time()

x = (np.arange(nx) - nx/2) * voxel_size
y = (np.arange(ny) - ny/2) * voxel_size
z = (np.arange(nz) - nz/2) * voxel_size

X, Y, Z = np.meshgrid(x, y, z, indexing='ij')

print(f"[DONE] Meshgrid created in {time.time() - t0:.2f} s")

# -----------------------------
# CYLINDER MASK
# -----------------------------
print("[STEP] Building cylinder mask...")
t0 = time.time()

cyl_mask = (X**2 + Y**2 <= R_cyl**2) & (np.abs(Z) <= H_cyl/2)

print(f"[DONE] Mask created in {time.time() - t0:.2f} s")

# -----------------------------
# INITIALIZE PHANTOM
# -----------------------------
print("[STEP] Initializing phantom (LAr)...")
phantom = np.zeros((nx, ny, nz), dtype=np.uint8)

# -----------------------------
# RANDOM SPHERE CENTERS
# -----------------------------
num_spheres = 12000
print(f"[STEP] Generating {num_spheres} random sphere centers...")

centers = []

t0 = time.time()
for i in range(num_spheres):
    cx = np.random.uniform(-R_cyl, R_cyl)
    cy = np.random.uniform(-R_cyl, R_cyl)
    cz = np.random.uniform(-H_cyl/2, H_cyl/2)

    if cx**2 + cy**2 > R_cyl**2:
        continue

    centers.append((cx, cy, cz))

    if i % 2000 == 0 and i > 0:
        print(f"   -> generated {i} candidates...")

print(f"[DONE] {len(centers)} valid centers in {time.time() - t0:.2f} s")

# -----------------------------
# FILL NH3 VOXELS
# -----------------------------
print("[STEP] Filling NH3 spheres into voxel grid...")
t0 = time.time()

total = len(centers)

for i, (cx, cy, cz) in enumerate(centers):
    dist = (X - cx)**2 + (Y - cy)**2 + (Z - cz)**2
    phantom[dist <= sphere_radius**2] = 1

    # progress update
    if (i + 1) % 500 == 0:
        elapsed = time.time() - t0
        print(f"   -> {i+1}/{total} spheres placed ({100*(i+1)/total:.1f}%) | {elapsed:.1f}s")

print(f"[DONE] Sphere filling completed in {time.time() - t0:.2f} s")

# -----------------------------
# APPLY CYLINDER MASK
# -----------------------------
print("[STEP] Applying cylinder boundary...")
t0 = time.time()

phantom[~cyl_mask] = 0

print(f"[DONE] Mask applied in {time.time() - t0:.2f} s")

# -----------------------------
# SAVE FILES
# -----------------------------
print("[STEP] Saving phantom.raw...")
t0 = time.time()

phantom.tofile("phantom.raw")

print(f"[DONE] phantom.raw written in {time.time() - t0:.2f} s")

print("[STEP] Writing materials.txt...")
with open("materials.txt", "w") as f:
    f.write("G4_lAr\n")
    f.write("SolidNH3\n")

print("[DONE] materials.txt written")

# -----------------------------
# FINISHED
# -----------------------------
total_time = time.time() - start_time
print(f"\n=== DONE in {total_time:.2f} seconds ===")