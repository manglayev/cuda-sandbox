NVCC=nvcc
CUDAFLAGS=-arch=sm_60
RM=/bin/rm -f

all: stream

stream: stream.o
	${NVCC} ${CUDAFLAGS} stream.o -o stream

stream.o: stream.cu
	${NVCC} ${CUDAFLAGS} -dc stream.cu

clean:
	${RM} *.o stream
