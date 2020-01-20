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
  void *p0 = el_malloc(128);
  printf("MALLOC 0\n"); el_print_stats(); printf("\n");

  printf("POINTERS\n");
  print_ptr_offset("p0",p0);
}
