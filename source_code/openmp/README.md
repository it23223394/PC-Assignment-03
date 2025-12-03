# OpenMP Matrix Multiplication

## Description

This program performs matrix multiplication using **OpenMP** to parallelize computation on the CPU. It demonstrates the use of multiple threads to speed up matrix operations.

---

## Standard Compilation and Execution

### Compilation

To compile the code:

```bash
make
```

To clean compiled files:

```bash
make clean
```

### Execution

Run the executable:

```bash
./openmp_exec
```

You can also control the number of threads:

```bash
export OMP_NUM_THREADS=4
./openmp_exec
```

**Notes**

* The program multiplies two N x N matrices.
* Default matrix size is defined in `openmp.c`.
* Speedup depends on the number of threads specified.

---

## Google Colab Setup

### Setup

Install necessary tools:

```bash
!apt-get update
!apt-get install -y build-essential
```

### Compilation

Compile the C program with OpenMP support:

```bash
!gcc -fopenmp openmp.c -o openmp_exec
```

### Execution

Run the executable:

```bash
!./openmp_exec
```

Control the number of threads:

```python
import os
os.environ["OMP_NUM_THREADS"] = "4"
!./openmp_exec
```

**Notes**

* The program multiplies two N x N matrices.
* Default matrix size is defined in `openmp.c`.
* Speedup depends on the number of threads specified.
* Use `!` for shell commands in Google Colab.
