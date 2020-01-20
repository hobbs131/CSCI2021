#include "matvec.h"
#include <stdlib.h>

// Multiplies the parameter matrix mat by the parameter vector
// vec. Stores the resulting vector in parameter res.  Multiplies each
// row I of mat by vec to get a dot product and stores the resulting
// number in res[I]. Returns 0 on success.
// 
// If there is a dimension mismatch between mat, vec, res, prints an
// error message and returns a non-zero error code.
int baseline_matrix_mult_vec(matrix_t mat, vector_t vec, vector_t res){
  if(mat.cols != vec.len){
    printf("mat.cols (%ld) != vec.len (%ld)\n",mat.cols,vec.len);
    return 1;
  }
  if(mat.rows != res.len){
    printf("mat.rows (%ld) != res.len (%ld)\n",mat.rows,res.len);
    return 2;
  }
  for(int i=0; i<mat.rows; i++){
    VSET(res,i,0);              // initialize res[i] to zero
    for(int j=0; j<mat.cols; j++){
      int elij = MGET(mat,i,j); 
      int vecj = VGET(vec,j);
      int prod = elij * vecj;
      int curr = VGET(res,i);
      int next = curr + prod;
      VSET(res,i, next);        // add on the newest product
    }
  }
  return 0;
}

// Multiplies the transpose of the parameter matrix mat by the
// parameter vector vec. Stores the resulting vector in parameter res.
// Multiplies each column J of mat by vec to get a dot product and
// stores the resulting number in res[J]. Returns 0 on success.
// 
// If there is a dimension mismatch between mat, vec, res, prints an
// error message and returns a non-zero error code.
int baseline_matrix_trans_mult_vec(matrix_t mat, vector_t vec, vector_t res){
  if(mat.rows != vec.len){
    printf("mat.rows (%ld) != vec.len (%ld)\n",mat.rows,vec.len);
    return 1;
  }
  if(mat.cols != res.len){
    printf("mat.cols (%ld) != res.len (%ld)\n",mat.cols,res.len);
    return 2;
  }
  for(int j=0; j<mat.cols; j++){
    VSET(res,j,0);              // initialize res[j] to zero
    for(int i=0; i<mat.rows; i++){
      int elij = MGET(mat,i,j); 
      int veci = VGET(vec,i);
      int prod = elij * veci;
      int curr = VGET(res,j);
      int next = curr + prod;
      VSET(res,j, next);        // add on the newest product
    }
  }
  return 0;
}
