#include "intrin.h"
#include "logger.h"
#include <algorithm>
#include <math.h>
#include <stdio.h>
using namespace std;

int SoASerial(int *values, int N)
{
  int sum = 0;
  for (int i = 0; i < N; i++)
  {
    sum += values[i];
  }

  return sum;
}

// Assume N % VLEN == 0
// Assume VLEN is a power of 2
int SoAVector(int *values, int N) {
  // TODO
  // create vector registers (vr) for processing
  __cs295_vec_int val_v;
  __cs295_vec_int sum_v = _cs295_vset_int(0);

  // loop thru N times & increment counter by VLEN
  for(int i=0; i<N; i+=VLEN) {
    // check for number of elements 
    int width = VLEN;
    if(N - i < VLEN) {
      width = N - i;
    }
    // activate VLEN elements
    __cs295_mask maskAll = _cs295_init_ones(width);

    // load VLEN elements from values
    _cs295_vload_int(val_v, values + i, maskAll);     // x = values[i];

    __cs295_vec_int temp_v = val_v;
    for(int j=0; j<3; j++) {
      _cs295_hadd_int(temp_v, temp_v);
      _cs295_interleave_int(temp_v, temp_v);
    }
    _cs295_vadd_int(sum_v, sum_v, temp_v, maskAll);
  }
  // return sum
  return sum_v.value[0];
}
