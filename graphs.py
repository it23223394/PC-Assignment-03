import matplotlib.pyplot as plt
import numpy as np


# Serial
serial_time = 1.043264  # seconds

# OpenMP
omp_threads = np.array([1, 2, 4, 8])
omp_time = np.array([1.831468, 2.826709, 2.455275, 2.437010])
omp_speedup = serial_time / omp_time

# MPI
mpi_procs = np.array([1, 2, 4, 8])
mpi_time = np.array([0.923679, 1.192825, 1.148780, 0.946988])
mpi_speedup = serial_time / mpi_time

# CUDA (800x800)
cuda_block = np.array([8, 16, 32])
cuda_time = np.array([6.488, 4.440, 4.288]) / 1000  # convert ms → seconds
cuda_speedup = serial_time / cuda_time

# Best methods for comparison
methods = ["Serial", "OpenMP", "MPI", "CUDA"]
best_times = [
    serial_time,
    np.min(omp_time),
    np.min(mpi_time),
    np.min(cuda_time),
]
best_speedups = serial_time / np.array(best_times)

# ============================
# 1️⃣ OpenMP Graphs
# ============================

plt.figure()
plt.plot(omp_threads, omp_time, marker='o')
plt.xlabel("Threads")
plt.ylabel("Time (s)")
plt.title("OpenMP: Threads vs Time")
plt.grid(True)
plt.show()

plt.figure()
plt.plot(omp_threads, omp_speedup, marker='o')
plt.xlabel("Threads")
plt.ylabel("Speedup")
plt.title("OpenMP: Threads vs Speedup")
plt.grid(True)
plt.show()

# ============================
# 2️⃣ MPI Graphs
# ============================

plt.figure()
plt.plot(mpi_procs, mpi_time, marker='o')
plt.xlabel("Processes")
plt.ylabel("Time (s)")
plt.title("MPI: Processes vs Time")
plt.grid(True)
plt.show()

plt.figure()
plt.plot(mpi_procs, mpi_speedup, marker='o')
plt.xlabel("Processes")
plt.ylabel("Speedup")
plt.title("MPI: Processes vs Speedup")
plt.grid(True)
plt.show()

# ============================
# 3️⃣ CUDA Graphs
# ============================

plt.figure()
plt.plot(cuda_block, cuda_time, marker='o')
plt.xlabel("Block Size")
plt.ylabel("Time (s)")
plt.title("CUDA: Block Size vs Time")
plt.grid(True)
plt.show()

plt.figure()
plt.plot(cuda_block, cuda_speedup, marker='o')
plt.xlabel("Block Size")
plt.ylabel("Speedup")
plt.title("CUDA: Block Size vs Speedup")
plt.grid(True)
plt.show()

# ============================
# 4️⃣ Comparative Graphs
# ============================

# Graph 7: Time comparison
plt.figure()
plt.bar(methods, best_times)
plt.ylabel("Execution Time (s)")
plt.title("Serial vs OpenMP vs MPI vs CUDA (Best Times)")
plt.grid(axis='y')
plt.show()

# Graph 8: Speedup comparison
plt.figure()
plt.bar(methods, best_speedups)
plt.ylabel("Speedup")
plt.title("Speedup Comparison Across All Methods")
plt.grid(axis='y')
plt.show()

# Graph 9: OpenMP vs MPI Comparison
plt.figure()
plt.plot(omp_threads, omp_time, marker='o', label="OpenMP Time")
plt.plot(mpi_procs, mpi_time, marker='s', label="MPI Time")
plt.xlabel("Threads / Processes")
plt.ylabel("Time (s)")
plt.title("OpenMP vs MPI Performance Comparison")
plt.legend()
plt.grid(True)
plt.show()

# Graph 10: CPU vs GPU Trend
plt.figure()
plt.plot([1,2,3], [serial_time, np.min(omp_time), np.min(mpi_time)],
         marker='o', label="CPU Methods")
plt.plot([4], [np.min(cuda_time)], marker='s', label="GPU (CUDA)")
plt.xticks([1,2,3,4], ["Serial", "OpenMP", "MPI", "CUDA"])
plt.ylabel("Time (s)")
plt.title("CPU vs GPU Scalability Trend")
plt.legend()
plt.grid(True)
plt.show()
