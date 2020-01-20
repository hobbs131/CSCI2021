#include "matvec.h"
#include <stdlib.h>

int optimized_matrix_trans_mult_vec(matrix_t mat, vector_t vec, vector_t res){
  // local variables to avoid main memory access
  vector_t temp_vec = vec;
  vector_t temp_res = res;
  matrix_t temp_mat = mat;

  // Set values of temp_res.data to 0 in order to avoid uninitialized value in valgrind
  for (int a = 0; a < temp_res.len; a++){
    temp_res.data[a] = 0;
  }
  // error conditionals
  if(temp_mat.rows!= temp_vec.len){
    printf("mat.rows (%ld) != vec.len (%ld)\n",temp_mat.rows,temp_vec.len);
    return 1;
  }
  if(temp_mat.cols != temp_res.len){
    printf("mat.cols (%ld) != res.len (%ld)\n", temp_mat.cols,temp_res.len);
    return 2;
  }

  // Row-major order loops
  for(int i=0; i<temp_mat.rows; i++){
    int j;
    // loop unrolled x4
    for(int j = 0; j<temp_mat.cols; j+=4){
      // one liners for result calculations. Formulas taken from matvec.h
      temp_res.data[j] = (temp_mat.data[(i*temp_mat.cols + j)] * temp_vec.data[i] + temp_res.data[j]);
      temp_res.data[j + 1] = (temp_mat.data[(i*temp_mat.cols + j + 1)] * temp_vec.data[i] + temp_res.data[j + 1]);
      temp_res.data[j + 2] = (temp_mat.data[(i*temp_mat.cols + j+ 2)] * temp_vec.data[i] + temp_res.data[j + 2]);
      temp_res.data[j + 3] = (temp_mat.data[(i*temp_mat.cols + j + 3)] * temp_vec.data[i] + temp_res.data[j  + 3]);
    }
    // clean-up loop
    for(; j < temp_mat.cols; j++){
      temp_res.data[j] =  (temp_mat.data[(i*temp_mat.cols + j)] * temp_vec.data[i] + temp_res.data[j]);
    }
  }
  res = temp_res;

  return 0;
}
