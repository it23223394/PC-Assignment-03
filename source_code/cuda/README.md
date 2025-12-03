# CUDA Matrix Multiplication

## Description

This program performs matrix multiplication using **CUDA** to utilize GPU parallelization.

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

Run the program with matrix size and block dimensions:

```bash
./cuda_exec 800 16 16
```

* Arguments:

  1. Matrix size (N)
  2. Block size in X direction
  3. Block size in Y direction

### Notes

* Default matrix size is 800x800.
* Performance depends on GPU and block/grid configuration.
* The program reports average execution time and GFLOPS.

---

## Google Colab Setup

### Setup

Install NVIDIA CUDA Toolkit (for Colab, CUDA is usually preinstalled):

```bash
!nvcc --version  # Check CUDA version
```

### Compilation

Compile the CUDA program:

```bash
!nvcc cuda.cu -o cuda_exec
```

### Execution

Run the program:

```bash
!./cuda_exec 800 16 16
```

* Arguments are the same as above.
* You can experiment with different matrix sizes and block dimensions.

### Notes

* Colab provides access to GPUs (select via Runtime → Change runtime type → GPU).
* Performance depends on the allocated GPU and CUDA configuration.
* Use `!` to run shell commands in Colab.
