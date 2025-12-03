#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void matmul_kernel(double* A, double* B, double* C, int N) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < N && col < N) {
        double sum = 0;
        for (int k = 0; k < N; k++)
            sum += A[row * N + k] * B[k * N + col];
        C[row * N + col] = sum;
    }
}

int main(int argc, char** argv) {
    int N = 1024;
    int block_x = 16, block_y = 16;

    if(argc >= 2) N = atoi(argv[1]);
    if(argc >= 3) block_x = atoi(argv[2]);
    if(argc >= 4) block_y = atoi(argv[3]);

    // Initialize CUDA context first
    cudaFree(0);

    printf("Matrix size: %d x %d\n", N, N);
    printf("CUDA Block size: %dx%d\n", block_x, block_y);

    size_t size = N * N * sizeof(double);
    size_t total_mem = size * 3; // A, B, and C

    printf("Required GPU memory: %.2f GB\n", total_mem / (1024.0*1024.0*1024.0));

    // Check available GPU memory (after CUDA initialization)
    size_t free_mem, total_gpu_mem;
    cudaError_t err = cudaMemGetInfo(&free_mem, &total_gpu_mem);

    if (err != cudaSuccess) {
        printf("ERROR: Could not get GPU memory info: %s\n", cudaGetErrorString(err));
        printf("Attempting to continue anyway...\n");
    } else {
        printf("Available GPU memory: %.2f GB / %.2f GB\n",
               free_mem / (1024.0*1024.0*1024.0),
               total_gpu_mem / (1024.0*1024.0*1024.0));

        if (total_mem > free_mem) {
            printf("WARNING: Not enough GPU memory! Attempting allocation anyway...\n");
        }
    }

    printf("Allocating host memory...\n");
    double *A = (double*) malloc(size);
    double *B = (double*) malloc(size);
    double *C = (double*) malloc(size);

    if (!A || !B || !C) {
        printf("ERROR: Host memory allocation failed!\n");
        return 1;
    }

    printf("Initializing matrices...\n");
    for (long long i = 0; i < (long long)N*N; i++) {
        A[i] = rand() % 10;
        B[i] = rand() % 10;
    }

    printf("Allocating GPU memory...\n");
    double *dA, *dB, *dC;

    err = cudaMalloc((void**)&dA, size);
    if (err != cudaSuccess) {
        printf("ERROR: cudaMalloc failed for dA: %s\n", cudaGetErrorString(err));
        free(A); free(B); free(C);
        return 1;
    }

    err = cudaMalloc((void**)&dB, size);
    if (err != cudaSuccess) {
        printf("ERROR: cudaMalloc failed for dB: %s\n", cudaGetErrorString(err));
        cudaFree(dA);
        free(A); free(B); free(C);
        return 1;
    }

    err = cudaMalloc((void**)&dC, size);
    if (err != cudaSuccess) {
        printf("ERROR: cudaMalloc failed for dC: %s\n", cudaGetErrorString(err));
        cudaFree(dA);
        cudaFree(dB);
        free(A); free(B); free(C);
        return 1;
    }

    printf("Copying data to GPU...\n");
    cudaMemcpy(dA, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(dB, B, size, cudaMemcpyHostToDevice);

    dim3 block(block_x, block_y);
    dim3 grid((N + block.x - 1)/block.x, (N + block.y - 1)/block.y);

    printf("Grid size: %dx%d, Total blocks: %d\n", grid.x, grid.y, grid.x * grid.y);
    printf("Threads per block: %d\n", block_x * block_y);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Adjust repetitions based on matrix size
    int repeat = (N <= 2048) ? 100 : (N <= 8192) ? 10 : 1;
    printf("Running %d iterations...\n", repeat);

    cudaEventRecord(start);
    for(int i = 0; i < repeat; i++) {
        matmul_kernel<<<grid, block>>>(dA, dB, dC, N);
    }
    cudaDeviceSynchronize();
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    // Check for kernel errors
    err = cudaGetLastError();
    if (err != cudaSuccess) {
        printf("ERROR: Kernel launch failed: %s\n", cudaGetErrorString(err));
        cudaFree(dA); cudaFree(dB); cudaFree(dC);
        free(A); free(B); free(C);
        return 1;
    }

    float ms_f;
    cudaEventElapsedTime(&ms_f, start, stop);
    double ms = (double)ms_f;

    // Calculate average time per iteration
    double avg_time_us = (ms * 1000.0) / repeat;
    double avg_time_ms = ms / repeat;

    printf("\n=== RESULTS ===\n");
    printf("Total time for %d iterations: %.3f ms\n", repeat, ms);
    printf("Average time per iteration: %.3f ms (%.3f µs)\n", avg_time_ms, avg_time_us);

    // Calculate GFLOPS
    double flops = 2.0 * N * N * N; // 2N^3 operations for matrix multiplication
    double gflops = (flops / (avg_time_ms / 1000.0)) / 1e9;
    printf("Performance: %.2f GFLOPS\n", gflops);

    printf("Copying result back to host...\n");
    cudaMemcpy(C, dC, size, cudaMemcpyDeviceToHost);

    free(A); free(B); free(C);
    cudaFree(dA); cudaFree(dB); cudaFree(dC);

    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    printf("Done!\n");
    return 0;
}
