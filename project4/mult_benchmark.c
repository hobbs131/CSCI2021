#include <stdlib.h>
#include <stdio.h>
#include <error.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include "matvec.h"

void check_hostname();

int main(int argc, char *argv[]){
  check_hostname();

  int min_size_pow =  9;        // 1024
  int max_size_pow = 13;        // 8192

  if(argc > 1){
    max_size_pow = 10;          // for valgrind testing
  }

  printf("%6s ","SIZE");
  printf("%10s ","BASE");
  printf("%10s ","NORM");
  printf("%10s ","OPT");
  printf("%6s ", "BSPDUP");
  printf("%6s ", "NSPDUP");
  printf("%6s ", "POINTS");
  printf("\n");


  int total_points = 0;

  // Iterate over different sizes of the matrix
  for(int pow=min_size_pow; pow<=max_size_pow; pow++){
    long size = 1 << pow;
    long rows=size, cols=size;

    matrix_t mat;
    vector_t vec, res_base, res_norm, res_opt;
    int ret = matrix_init(&mat,rows,cols);
    if(ret){ return ret; }
    matrix_fill_sequential(mat);

    ret = vector_init(&vec, mat.rows);
    ret = vector_init(&res_base, mat.cols);
    ret = vector_init(&res_norm, mat.rows);
    ret = vector_init(&res_opt,  mat.cols);
    vector_fill_sequential(vec);

    clock_t begin, end;
    begin = clock();
    ret = baseline_matrix_mult_vec(mat,vec,res_norm);
    end = clock();
    double norm_cpu_time = ((double) (end - begin)) / CLOCKS_PER_SEC;

    begin = clock();
    ret = baseline_matrix_trans_mult_vec(mat,vec,res_base);
    end = clock();
    double base_cpu_time = ((double) (end - begin)) / CLOCKS_PER_SEC;

    begin = clock();
    // ret = baseline_matrix_trans_mult_vec(mat,vec,res_opt);
    ret = optimized_matrix_trans_mult_vec(mat,vec,res_opt);
    end = clock();
    double opt_cpu_time = ((double) (end - begin)) / CLOCKS_PER_SEC;


    double base_opt_speedup = (base_cpu_time / opt_cpu_time);
    double norm_opt_speedup = (norm_cpu_time / opt_cpu_time);

    int points = (int)
      (base_opt_speedup*0.5 + norm_opt_speedup - 1.0 - (norm_cpu_time / base_opt_speedup) - 0.5);
    if(points < 0){
      points = 0;
    }
    total_points += points;

    for(int i=0; i<res_base.len; i++){
      int base_i = VGET(res_base,i);
      int opt_i  = VGET(res_opt,i);
      if(base_i != opt_i){
        printf("ERROR: base and opt multiplication produced different results\n");
        printf("ERROR: res[%d]: %d != %d\n",i,base_i,opt_i);
        points = 0;
      }
    }

    printf("%6ld ", size);
    printf("%10.4e ",base_cpu_time);
    printf("%10.4e ",norm_cpu_time);
    printf("%10.4e ",opt_cpu_time);
    printf("%6.2f ",base_opt_speedup);
    printf("%6.2f ",norm_opt_speedup);
    printf("%6d ",  points);
    printf("\n");


    matrix_free_data(&mat);       // clean up data
    vector_free_data(&vec);
    vector_free_data(&res_base);
    vector_free_data(&res_norm); // ADD THIS LINE to free memory
    vector_free_data(&res_opt);
  }

  int max_score = 35;
  int actual_score = total_points;
  printf("RAW POINTS: %d\n",actual_score);

  if(actual_score > max_score){
    actual_score = max_score;
  }

  printf("TOTAL POINTS: %d / %d\n",actual_score,max_score);

  return 0;
}

#define MAXHOSTNAMELEN 1024
#define EXPECT_HOST "csel-apollo"

void check_hostname(){
  char actual_host[MAXHOSTNAMELEN];
  char *expect_host = EXPECT_HOST;
  if (gethostname(actual_host, MAXHOSTNAMELEN) != 0) {
    printf("WARNING: Couldn't get machine hostname\n");
  }
  else if(strcasecmp(expect_host, actual_host) != 0){
    printf("WARNING: expected host '%s' but got host '%s'\n",expect_host,actual_host);
    printf("WARNING: timing results / scoring will not reflect actual scoring\n");
    printf("WARNING: run on host '%s' for accurate results\n",expect_host);
  }
}
