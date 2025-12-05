#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

#define N 800

int main(int argc, char* argv[]) {
    int rank, size;
    double start, end;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    double *A = NULL;
    double *B = (double*) malloc(N*N*sizeof(double));
    double *C_local = (double*) malloc(N*N/size * sizeof(double));
    double *C = NULL;

    if (rank == 0) {
        A = (double*) malloc(N*N*sizeof(double));
        C = (double*) malloc(N*N*sizeof(double));
        for (int i = 0; i < N*N; i++) {
            A[i] = rand() % 10;
            B[i] = rand() % 10;
        }
    }

    MPI_Bcast(B, N*N, MPI_DOUBLE, 0, MPI_COMM_WORLD);

    double* A_local = (double*) malloc(N*N/size * sizeof(double));
    MPI_Scatter(A, N*N/size, MPI_DOUBLE, A_local, N*N/size, MPI_DOUBLE, 0, MPI_COMM_WORLD);

    start = MPI_Wtime();

    for (int i = 0; i < N/size; i++)
        for (int j = 0; j < N; j++) {
            C_local[i*N + j] = 0;
            for (int k = 0; k < N; k++)
                C_local[i*N + j] += A_local[i*N + k] * B[k*N + j];
        }

    end = MPI_Wtime();
    MPI_Gather(C_local, N*N/size, MPI_DOUBLE, C, N*N/size, MPI_DOUBLE, 0, MPI_COMM_WORLD);

    if (rank == 0)
        printf("Processes: %d | Time: %.6f sec\n", size, end - start);
    if (rank == 0 && C) free(C);

    MPI_Finalize();
    return 0;
}
