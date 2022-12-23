#include "intrin.h"
#include "logger.h"
#include <algorithm>
#include <math.h>
#include <stdio.h>
using namespace std;

void ReluSerial(int *values, int *output, int N)
{
  for (int i = 0; i < N; i++)
  {
    int x = values[i];
    if (x < 0)
    {
      output[i] = 0;
    }
    else
    {
      output[i] = x;
    }
  }
}

// implementation of relu using instrinsics
void ReluVector(int *values, int *output, int N)
{
  // TODO
  // create vector registers (vr) for processing
  __cs295_vec_int val_v;
  __cs295_vec_int out_v;

  __cs295_vec_int zeros = _cs295_vset_int(0);
  // loop thru values N times & increment counter by VLEN
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

    // active elements > 0 
    __cs295_mask mask_val_gt_zero;
    _cs295_vgt_int(mask_val_gt_zero, val_v, zeros, maskAll);     // (x < 0)
    __cs295_mask  mask_val_zeros = _cs295_mask_not(mask_val_gt_zero);
    __cs295_vec_int temp_v;
    _cs295_vset_int(temp_v, 1, mask_val_gt_zero);
    _cs295_vset_int(temp_v, 0, mask_val_zeros);
    _cs295_vmult_int(out_v, val_v, temp_v, maskAll);     // output[i] = 0; & output[i] = x;
    //  load VLEN elements to output
    _cs295_vstore_int(output + i, out_v, maskAll);
  }
}