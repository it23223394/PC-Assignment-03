
CC = mpicc
CFLAGS = -O2
TARGET = mpi_exec
SRC = mpi.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

run1:
	mpirun -np 1 ./$(TARGET)

run2:
	mpirun -np 2 ./$(TARGET)

run4:
	mpirun -np 4 ./$(TARGET)

run8:
	mpirun -np 8 ./$(TARGET)

clean:
	rm -f $(TARGET)
