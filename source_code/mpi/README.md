# MPI Matrix Multiplication

## Description

This program performs matrix multiplication using **MPI** (Message Passing Interface) to parallelize computation across multiple processes.

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

Run the program with a specific number of processes:

```bash
mpirun -np 4 ./mpi_exec
```

* `-np` specifies the number of processes.
* The matrix is distributed row-wise among processes.

**Notes**

* Matrix size is defined in `mpi.c`.
* Communication overhead increases with the number of processes.
* Designed for Linux/Unix systems with MPI installed.

---

## Google Colab Setup

### Setup

Install MPI tools:

```bash
!apt-get update
!apt-get install -y mpich
```

### Compilation

Compile the MPI program:

```bash
!mpicc mpi.c -o mpi_exec
```

### Execution

Run the program with a specific number of processes:

```bash
!mpirun -np 4 ./mpi_exec
```

**Notes**

* Use `!` to run shell commands in Colab.
* Matrix size is defined in `mpi.c`.
* Communication overhead increases with more processes.
* MPI programs can be run in Colab, but speedup may be limited due to single CPU cores.
