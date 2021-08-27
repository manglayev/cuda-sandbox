#ifdef __CUDACC__
#define CUDA_HOSTDEV __host__ __device__
#else
#define CUDA_HOSTDEV
#endif

#define DIMS 1
#define BLOCKS 1
#define THREADS 4
#define CUDASIZE 4
