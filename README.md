**Assignment
 Overview**
- **Purpose**: A collection of matrix-multiplication implementations used for performance comparison across serial, OpenMP (multi-threaded CPU), MPI (multi-process), and CUDA (GPU) approaches.
- **Language**: C / CUDA C
- **Location**: Source code is under `source_code/` with a subfolder per implementation.

**Repository Structure**
- **`source_code/1 serial/`**: Serial implementation (`serial.c`).
- **`source_code/openmp/`**: OpenMP implementation (`openmp_matmul.c`) and a `Makefile`.
- **`source_code/mpi/`**: MPI implementation (`mpi_matmul.c`) and a `Makefile`.
- **`source_code/cuda/`**: CUDA implementation (`cuda_matmul.cu`), a `Makefile`, and a README with usage notes.
- **`screenshots/`**:  image assets used for verification or reporting.

**Build & Run (quick)**
- **Notes**: These instructions assume a Unix-like environment (Linux, WSL, MSYS2). On native Windows you may need WSL, MS-MPI, or an appropriate toolchain (MinGW) and the CUDA toolkit + drivers for GPU runs.

- **Serial**:
	- **Compile**: `gcc -O2 "source_code/1 serial/serial.c" -o serial_exec`
	- **Run**: `./serial_exec`
	- **Notes**: The serial program uses a fixed `#define N 800` in the source. Change the source if you want a different matrix size and recompile.

- **OpenMP**:
	- **Make (if available)**: `cd source_code/openmp && make`
	- **Direct compile**: `gcc -fopenmp -O2 source_code/openmp/openmp_matmul.c -o openmp_exec`
	- **Run** (set threads):
		- POSIX / WSL: `export OMP_NUM_THREADS=4; ./openmp_exec`
		- PowerShell (Windows): `$env:OMP_NUM_THREADS=4; ./openmp_exec`
	- **Notes**: Default matrix size is set with `#define N 800` in `openmp_matmul.c`.

- **MPI**:
	- **Make (if MPI toolchain present)**: `cd source_code/mpi && make`
	- **Direct compile**: `mpicc -O2 source_code/mpi/mpi_matmul.c -o mpi_exec`
	- **Run**: `mpirun -np 4 ./mpi_exec` (replace `4` with number of processes)
	- **Notes**: Default `N` is `800` in `mpi_matmul.c`. On Windows use MS-MPI or run inside WSL for an easier experience.

- **CUDA**:
	- **Prerequisites**: NVIDIA GPU, correct drivers, and CUDA Toolkit (nvcc) installed.
	- **Make**: `cd source_code/cuda && make`
	- **Direct compile**: `nvcc -O2 source_code/cuda/cuda_matmul.cu -o cuda_exec`
	- **Run**: `./cuda_exec 1024 16 16`
		- Arguments: `N [block_x] [block_y]` — matrix size and block dimensions. If omitted, defaults are used (example program default `N=1024`).
	- **Notes**: The CUDA program prints required GPU memory and will warn if available memory is insufficient.

**Expected Output Samples**
- **Serial**: `Serial time: X.XXXXXX seconds`
- **OpenMP**: `Threads: <T> | Time: X.XXXXXX seconds`
- **MPI**: `Processes: <P> | Time: X.XXXXXX sec`
- **CUDA**: Summary including grid/block sizes, average time per iteration, and `Performance: XX.XX GFLOPS`

**Troubleshooting & Tips**
- If `make` fails in a subdirectory, compile the source file directly using the commands above — some bundled `Makefile` targets reference generic filenames and may need manual invocation.
- On Windows, prefer WSL (Windows Subsystem for Linux) for the MPI build/run workflow and for CUDA use the native CUDA toolkit with an NVIDIA GPU and up-to-date drivers.
- For reproducible timing, ensure other heavy workloads are minimized and, for GPU runs, that the device has sufficient free memory (the CUDA program itself prints memory info).
 
**Google Colab**
- **Overview**: The repository was tested on Google Colab for convenience. Colab is useful for quick experimentation but has limits (ephemeral VMs, limited GPU memory, and single-node MPI only). Below are example cells you can run in a Colab notebook.

- **Clone the repo**
```bash
!git clone https://github.com/it23223394/PC-Assignment-03.git
%cd PC-Assignment-03
```

- **Install build tools & MPI (if needed)**
```bash
!apt-get update -qq
!apt-get install -y build-essential mpich -qq
```

- **Serial (build & run)**
```bash
!gcc -O2 "source_code/1 serial/serial.c" -o serial_exec
!./serial_exec
```

- **OpenMP (build & run)**
```bash
!gcc -fopenmp -O2 source_code/openmp/openmp_matmul.c -o openmp_exec
import os
os.environ["OMP_NUM_THREADS"] = "4"
!./openmp_exec
```

- **MPI (single VM multiple processes)**
```bash
!mpicc -O2 source_code/mpi/mpi_matmul.c -o mpi_exec
!mpirun -np 4 ./mpi_exec
```
Note: MPI on Colab runs processes on the same VM — suitable for testing correctness and per-process scaling but not multi-node distributed runs.

- **CUDA (GPU)**
1. Switch the runtime: Runtime → Change runtime type → Hardware accelerator → GPU.
2. Then run:
```bash
!nvcc --version || echo "nvcc not found; CUDA toolkit may not be installed in this runtime"
!nvcc -O2 source_code/cuda/cuda_matmul.cu -o cuda_exec
!./cuda_exec 1024 16 16
```
Notes:
- Colab often provides preinstalled CUDA drivers/toolkit; if `nvcc` is missing, try another runtime or image.
- GPU memory is limited on Colab; reduce `N` if you hit allocation errors.

- **Colab tips & limitations**
	- Enable the GPU runtime for CUDA tests.
	- Save large outputs to Google Drive if you need to keep results across sessions.
	- MPI runs on one VM only; Colab does not provide multi-node clusters.
	- If you have a Colab notebook used for testing, consider adding a link to it here and note the runtime type (e.g., "GPU: Tesla T4").

