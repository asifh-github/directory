#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <algorithm>
#include "intrin.h"
#include "logger.h"

using namespace std;

void imaxSerial(int *values, int *output, int N) {
  int x = 0xffffffff;
  int index = 0;
  for (int i = 0; i < N; i++) {
    if (values[i] > x) {
      x = values[i];
      index = i;
    }
  }
  //printf("%d, %d\n", index, values[index]);
  *output = index;
}

// implementation of imax using instrinsics
void imaxVector(int *values, int *output, int N) {
  // create vector registers (vr) for processing
  __cs295_vec_int val_v;

  __cs295_vec_int max = _cs295_vset_int(0xffffffff);      // -1
  __cs295_vec_int index = _cs295_vset_int(0);

  for(int i=0; i<N; i+=VLEN) {
    //printf("%d\n", i);
    // check for number of elements 
    int width = VLEN;
    if(N - i < VLEN) {
      width = N - i;
    }
    // activate VLEN elements
    __cs295_mask maskOne = _cs295_init_ones(1);
    __cs295_mask maskAll = _cs295_init_ones(width);
    // load VLEN elements from values
    _cs295_vload_int(val_v, values + i, maskAll);     // x = values[i];

    __cs295_mask mask_gt_max;
    __cs295_mask temp;                                
    __cs295_vec_int cmax = _cs295_vset_int(0);        // 0
    int cindex = 0;

    for(int j=0; j<width; j++) {
      // find max in VLEN/width
      _cs295_vgt_int(mask_gt_max, val_v, cmax, maskAll);
      // update max and index 
      cindex = _cs295_firstbit(mask_gt_max);
      cmax = _cs295_vset_int(val_v.value[cindex]);
      //printf("Inner Loop: %d, %d\n", cindex, cmax);
      //printf("# of 1 in mask: %d\n", _cs295_cntbits(mask_gt_max));
      // !!update mask to only include elements greater than max
      _cs295_vgt_int(temp, val_v, cmax, maskAll);
      if( _cs295_cntbits(temp) == 0) {
        break;
      }
    }
    //printf("\n");

    __cs295_mask temp2;  
    _cs295_vgt_int(temp2, cmax, max, maskOne);
    if(_cs295_cntbits(temp2)) {
      int ti = cindex + i;
      index = _cs295_vset_int(ti);
      max = cmax;
      //printf("Outer Loop: %d, %d\n", ti, max);
      //printf("\n");
    }
    _cs295_vstore_int(output, index, maskOne);
  }
}