#include <math.h>
#include <stdio.h>
#include <algorithm>
#include "intrin.h"
#include "logger.h"

using namespace std;

void CAXPYSerial(int N, int cond[], int a, int X[], int Y[]) {
  int i;
  for (i = 0; i < N; i++) {
    if (cond[i]) Y[i] = a * X[i] + Y[i];
  }
}

// implementation of relu using instrinsics
void CAXPYVector(int N, int cond[], int a, int X[], int Y[]) {
 // TODO
  // create vector registers (vr) for processing
  __cs295_vec_int cond_v;
  __cs295_vec_int x_v;
  __cs295_vec_int y_v;
  
  __cs295_vec_int zeros = _cs295_vset_int(0);
  __cs295_vec_int a_v = _cs295_vset_int(a);
  // loop thru N times & increment counter by VLEN
  for(int i=0; i<N; i+=VLEN) {
    // check for number of elements 
    int width = VLEN;
    if(N - i < VLEN) {
      width = N - i;
    }
    // activate VLEN elements
    __cs295_mask maskAll = _cs295_init_ones(width);

    // load VLEN elements from X
    _cs295_vload_int(x_v, X + i, maskAll);            // x = x[i];
    // load VLEN elements from Y
    _cs295_vload_int(y_v, Y + i, maskAll);            // y = Y[i];
    // load VLEN elements from cond
    _cs295_vload_int(cond_v, cond + i, maskAll);      // c = cond[i];

    // active cond_elements != 0 
    __cs295_mask mask_val_zero;
    _cs295_veq_int(mask_val_zero, cond_v, zeros, maskAll);
    __cs295_mask mask_val_n_zero = _cs295_mask_not(mask_val_zero);
    __cs295_vec_int temp;
    _cs295_vmult_int(temp, a_v, x_v, maskAll);
    _cs295_vadd_int(y_v, temp, y_v, mask_val_n_zero);

    //  load VLEN elements to output
    _cs295_vstore_int(Y + i, y_v, maskAll);
  }
}