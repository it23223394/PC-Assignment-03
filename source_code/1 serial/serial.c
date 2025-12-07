#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define N 800   // Use large N for better comparison

double wall_time() {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec + tv.tv_usec * 1e-6;
}

int main() {
    double **A, **B, **C;
    double start, end;
    // Allocate row pointers
    A = (double**) malloc(N * sizeof(double*));
    B = (double**) malloc(N * sizeof(double*));
    C = (double**) malloc(N * sizeof(double*));
    
    // Allocate each row
    for (int i = 0; i < N; i++) {
        A[i] = (double*) malloc(N * sizeof(double));
        B[i] = (double*) malloc(N * sizeof(double));
        C[i] = (double*) malloc(N * sizeof(double));
    }

    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++) {
            A[i][j] = rand() % 10;
            B[i][j] = rand() % 10;
            C[i][j] = 0;
        }

    start = wall_time();

    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            for (int k = 0; k < N; k++)
                C[i][j] += A[i][k] * B[k][j];

    end = wall_time();

    printf("Serial time: %.6f seconds\n", end - start);

    // Free allocated memory
    for (int i = 0; i < N; i++) {
        free(A[i]);
        free(B[i]);
        free(C[i]);
    }
    free(A);
    free(B);
    free(C);

    return 0;
}

/* #define ROWS_A 800   // A is ROWS_A × COLS_A
#define COLS_A 600   // Must equal ROWS_B
#define ROWS_B 600   // B is ROWS_B × COLS_B
#define COLS_B 500   // Result C is ROWS_A × COLS_B

// Allocate matrices differently
double **A = malloc(ROWS_A * sizeof(double*));
double **B = malloc(ROWS_B * sizeof(double*));
double **C = malloc(ROWS_A * sizeof(double*));

for (int i = 0; i < ROWS_A; i++) {
    A[i] = malloc(COLS_A * sizeof(double));
    C[i] = malloc(COLS_B * sizeof(double));
}
for (int i = 0; i < ROWS_B; i++) {
    B[i] = malloc(COLS_B * sizeof(double));
}

// Modified multiplication loop
for (int i = 0; i < ROWS_A; i++)
    for (int j = 0; j < COLS_B; j++)
        for (int k = 0; k < COLS_A; k++)  // Note: COLS_A must equal ROWS_B
            C[i][j] += A[i][k] * B[k][j]; */