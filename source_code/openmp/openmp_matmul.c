#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#define N 800

int main() {
    double **A, **B, **C;
    int i, j, k;

    A = (double**) malloc(N * sizeof(double*));
    B = (double**) malloc(N * sizeof(double*));
    C = (double**) malloc(N * sizeof(double*));

    for (i = 0; i < N; i++) {
        A[i] = (double*) malloc(N * sizeof(double));
        B[i] = (double*) malloc(N * sizeof(double));
        C[i] = (double*) malloc(N * sizeof(double));
    }

    for (i = 0; i < N; i++)
        for (j = 0; j < N; j++) {
            A[i][j] = rand() % 10;
            B[i][j] = rand() % 10;
            C[i][j] = 0;
        }

    double start = omp_get_wtime();

    #pragma omp parallel for private(j, k) shared(A, B, C)
    for (i = 0; i < N; i++)
        for (j = 0; j < N; j++)
            for (k = 0; k < N; k++)
                C[i][j] += A[i][k] * B[k][j];

    double end = omp_get_wtime();
    printf("Threads: %d | Time: %.6f seconds\n", omp_get_max_threads(), end - start);

    return 0;
}
