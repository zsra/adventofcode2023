import numpy as np
from sympy import Symbol, solve_poly_system

# Read input from file
handle = open("day24.in", "r")
shards = []

# Parse input lines and store shard information
for line in handle:
    pos, vel = line.strip().split(" @ ")
    px, py, pz = map(int, pos.split(", "))
    vx, vy, vz = map(int, vel.split(", "))
    shards.append((px, py, pz, vx, vy, vz))

handle.close()

# Part 1: Count intersections
count = 0
for adx in range(len(shards) - 1):
    shard_a = shards[adx]
    ma = shard_a[4] / shard_a[3]
    ba = shard_a[1] - ma * shard_a[0]

    for bdx in range(adx + 1, len(shards)):
        shard_b = shards[bdx]
        mb = shard_b[4] / shard_b[3]
        bb = shard_b[1] - mb * shard_b[0]

        if ma == mb:
            if ba == bb:
                print(shard_a, shard_b, "ARE THE SAME LINE")
                exit()
            continue

        ix = (bb - ba) / (ma - mb)
        iy = ma * ix + ba

        ta = (ix - shard_a[0]) / shard_a[3]
        tb = (ix - shard_b[0]) / shard_b[3]

        if ta >= 0 and tb >= 0 and 200000000000000 <= ix <= 400000000000000 and 200000000000000 <= iy <= 400000000000000:
            count += 1

# Part 1: Print the count of intersections
print("Part 1:", count)

# Part 2: Solve system of equations
x, y, z = Symbol('x'), Symbol('y'), Symbol('z')
vx, vy, vz = Symbol('vx'), Symbol('vy'), Symbol('vz')

equations = []
t_syms = []

# Build equations for the first 3 shards
for idx, shard in enumerate(shards[:3]):
    x0, y0, z0, xv, yv, zv = shard
    t = Symbol('t' + str(idx))
    eqx = x + vx * t - x0 - xv * t
    eqy = y + vy * t - y0 - yv * t
    eqz = z + vz * t - z0 - zv * t

    equations.extend([eqx, eqy, eqz])
    t_syms.append(t)

# Solve the system of equations
result = solve_poly_system(equations, *[x, y, z, vx, vy, vz] + t_syms)

# Part 2: Print the sum of coordinates at the first time of intersection
print("Part 2:", result[0][0] + result[0][1] + result[0][2])
