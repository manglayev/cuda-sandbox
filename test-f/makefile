NVCC=nvcc
CUDAFLAGS=-arch=sm_60
RM=/bin/rm -f
VEC4D_FALLBACK=VEC4D_FALLBACK

all: main

main: main.o wrapperCaller.o open_acc_map_cuda.o link.o
	g++ main.o wrapperCaller.o open_acc_map_cuda.o link.o -o main -L/usr/local/cuda/lib64 -lcuda -lcudart

main.o: main.cpp open_acc_map_header.cuh
	g++ -std=c++11 -c main.cpp

wrapperCaller.o: wrapperCaller.cpp open_acc_map_header.cuh
	g++ -std=c++11 -c wrapperCaller.cpp

open_acc_map_cuda.o: cuda_header.cuh vectorclass_fallback.cuh vec.h open_acc_map_header.cuh open_acc_map_cuda.cu
	${NVCC} ${CUDAFLAGS} -D${VEC4D_FALLBACK} -dc open_acc_map_cuda.cu

link.o: open_acc_map_cuda.o
	${NVCC} ${CUDAFLAGS} -dlink open_acc_map_cuda.o -o link.o

clean:
	${RM} *.o main
