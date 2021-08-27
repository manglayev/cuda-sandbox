NVCC=nvcc
CC=gcc
CUDAFLAGS=-arch=sm_60
RM=/bin/rm -f

all: open_acc_map_cuda

main: open_acc_map_cuda.o
	${NVCC} -o main open_acc_map_cuda.o

open_acc_map_cuda.o: open_acc_map_h.h open_acc_map_cuda.cu
	$(NVCC) $(CUDAFLAGS) -c	open_acc_map_cuda.cu

open_acc_map_cuda: open_acc_map_cuda.o
	${NVCC} ${CUDAFLAGS} -o open_acc_map_cuda open_acc_map_cuda.o

clean:
	${RM} *.o open_acc_map_cuda
