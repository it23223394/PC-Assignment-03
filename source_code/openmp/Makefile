CC = gcc
CFLAGS = -fopenmp -O2
TARGET = openmp_exec
SRC = openmp.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

run:
	./$(TARGET)

clean:
	rm -f $(TARGET)
