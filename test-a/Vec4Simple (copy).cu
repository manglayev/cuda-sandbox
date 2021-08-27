#include "open_acc_map_header.cuh"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "cuda_runtime.h"

extern __device__ Vec4Simple<int> cuda_device_1(int *dev_a, int *dev_b);

template <class T>
class Vec4Simple
{
  public:
   //T val[4] __attribute__((aligned(32)));
   T val[4];
   Vec4Simple() { }
   // Replicate scalar x across v.
   Vec4Simple(T x)
   {
      for(unsigned int i=0;i<4;i++)
         val[i]=x;
   }
   // Replicate 4 values across v.
   Vec4Simple(T a,T b,T c,T d)
   {
      val[0]=a;
      val[1]=b;
      val[2]=c;
      val[3]=d;
   }
   // Copy vector v.
   Vec4Simple(Vec4Simple const &x)
   {
      for(unsigned int i=0;i<4;i++)
         val[i]=x.val[i];
   }
   // Member function to load from array (unaligned)
   Vec4Simple & load(T const * p)
   {
      for(unsigned int i=0;i<4;i++)
         val[i]=p[i];
      return *this;
   }
   // Member function to load from array, aligned by 32
   Vec4Simple & load_a(T const * p)
   {
      return this->load(p);
   }

   Vec4Simple & insert(int i,T const &x)
   {
      val[i]=x;
      return *this;
   }
   // Member function to store into array (unaligned)
   void store(T * p) const
   {
      for(unsigned int i=0;i<4;i++)
         p[i]=val[i];
   }
   // Member function to store into array, aligned by 32
   void store_a(T * p) const
   {
      this->store(p);
   }
   /*
   Vec4Simple & operator = (Vec4Simple const & r)
   {
      for(unsigned int i=0;i<4;i++)
         val[i]=r.val[i];
      return *this;
   }
   */
   __device__ __host__ Vec4Simple & operator = (Vec4Simple const & r)
   {
      for(unsigned int i=0;i<4;i++)
         val[i]=r.val[i];
      return *this;
   }

   T operator [](int i) const
   {
     return val[i];
   }

   Vec4Simple operator++ (int)
   {
      Vec4Simple<T> temp (*this);
      for(unsigned int i=0;i<4;i++)
         val[i]++;
      return temp;
   }

   __device__ Vec4Simple<int> cuda_device_1(int *dev_a, int *dev_b)
   {
      Vec4Simple<T> temp (*this);
      int i = threadIdx.x;
      if (i < 4)
      {
        val[i] = dev_a[i] + dev_b[i];
      }
      return temp;
   }
};
