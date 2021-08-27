#include "open_acc_map_header.cuh"

#include "device_launch_parameters.h"
#include "cuda.h"
#include "cuda_runtime.h"
#include <stdio.h>
#include <stdlib.h>

template <typename T>
CUDA_HOSTDEV Vec4Simple<T>::Vec4Simple() { }
template <typename T>
CUDA_HOSTDEV Vec4Simple<T>::Vec4Simple(T *p) : _p(p) {}
template <typename T>
CUDA_HOSTDEV T Vec4Simple<T>::getSquare(T b)
{ return b*b; }
template <typename T>
CUDA_HOSTDEV Vec4Simple<T>::Vec4Simple(T x)
{
  for(unsigned int i=0;i<4;i++)
    val[i]=x;
}
template <typename T>
CUDA_HOSTDEV Vec4Simple<T>::Vec4Simple(T a,T b,T c,T d)
{
   val[0]=a;
   val[1]=b;
   val[2]=c;
   val[3]=d;
}
template <typename T>
CUDA_HOSTDEV Vec4Simple<T>::Vec4Simple(Vec4Simple const &x)
{
   for(unsigned int i=0;i<4;i++)
      val[i]=x.val[i];
}

// Member function to load from array (unaligned)
template <typename T>
CUDA_HOSTDEV Vec4Simple<T> & Vec4Simple<T>::load(T const * p)
{
   for(unsigned int i=0;i<4;i++)
      val[i]=p[i];
   return *this;
}

// Member function to load from array, aligned by 32
template <typename T>
CUDA_HOSTDEV Vec4Simple<T> & Vec4Simple<T>::load_a(T const * p)
{
   return this->load(p);
}

template <typename T>
CUDA_HOSTDEV Vec4Simple<T> & Vec4Simple<T>::insert(int i,T const &x)
{
   val[i]=x;
   return *this;
}

// Member function to store into array (unaligned)
template <typename T>
CUDA_HOSTDEV void Vec4Simple<T>::store(T * p) const
{
   for(unsigned int i=0;i<4;i++)
      p[i]=val[i];
}

// Member function to store into array, aligned by 32
template <typename T>
CUDA_HOSTDEV void Vec4Simple<T>::store_a(T * p) const
{
   this->store(p);
}

template <typename T>
CUDA_HOSTDEV Vec4Simple<T> & Vec4Simple<T>::operator = (Vec4Simple<T> const & r)
{
   for(unsigned int i=0;i<4;i++)
      val[i]=r.val[i];
   return *this;
}

template <typename T>
CUDA_HOSTDEV T Vec4Simple<T>::operator [](int i) const
{
   return val[i];
}

template <typename T>
CUDA_HOSTDEV Vec4Simple<T> Vec4Simple<T>::operator++ (int)
{
   Vec4Simple<T> temp (*this);
   for(unsigned int i=0;i<4;i++)
      val[i]++;
   return temp;
}

template class Vec4Simple<int>;

template <class T>
static inline Vec4Simple<T> truncate_to_int(Vec4Simple<T> const & a)
{
  return Vec4Simple<int>(a.val[0], a.val[1], a.val[2], a.val[3]);
}
