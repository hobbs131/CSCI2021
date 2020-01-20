#define HEAP_SIZE 1024
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "el_malloc.h"

void print_ptr_offset(char *str, void *ptr){
  if(ptr == NULL){
    printf("%s: (nil)\n", str);
  }
  else{
    printf("%s: %lu from heap start\n",
           str, PTR_MINUS_PTR(ptr,el_ctl.heap_start));
  }
}
void print_ptrs(void *ptr[], int len){
  char buf[128];
  for(int i=0; i<len; i++){
    snprintf(buf,128,"ptr[%2d]",i);
    print_ptr_offset(buf,ptr[i]);
  }
}

void run_test();

int main(){
  el_init(HEAP_SIZE);
  run_test();
  el_cleanup();
  return 0;
}
void run_test(){
  void *ptr[16] = {};
  int len = 0;

  ptr[len++] = el_malloc(128);
  printf("\nMALLOC 0\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  ptr[len++] = el_malloc(200);
  printf("\nMALLOC 1\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  ptr[len++] = el_malloc(64);
  printf("\nMALLOC 2\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  ptr[len++] = el_malloc(312);
  printf("\nMALLOC 3\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  el_free(ptr[3]);
  printf("\nFREE 3\n"); el_print_stats(); printf("\n");

  el_free(ptr[0]);
  printf("\nFREE 0\n"); el_print_stats(); printf("\n");

  el_free(ptr[2]);
  printf("\nFREE 2\n"); el_print_stats(); printf("\n");

  el_free(ptr[1]);
  printf("\nFREE 1\n"); el_print_stats(); printf("\n");
}
