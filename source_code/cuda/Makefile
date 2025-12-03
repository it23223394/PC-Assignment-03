
NVCC = nvcc
TARGET = cuda_exec
SRC = cuda.cu

all: $(TARGET)

$(TARGET): $(SRC)
	$(NVCC) -O2 -o $(TARGET) $(SRC)

run:
	./$(TARGET) 800 16 16

clean:
	rm -f $(TARGET)
