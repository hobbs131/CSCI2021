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
  printf("INITIAL\n"); el_print_stats(); printf("\n");

  void *p1 = el_malloc(128);
  void *p2 = el_malloc(48);
  void *p3 = el_malloc(156);
  printf("MALLOC 3\n"); el_print_stats(); printf("\n");

  printf("POINTERS\n");
  print_ptr_offset("p3",p3);
  print_ptr_offset("p2",p2);
  print_ptr_offset("p1",p1);
  printf("\n");

  void *p4 = el_malloc(22);
  void *p5 = el_malloc(64);
  printf("MALLOC 5\n"); el_print_stats(); printf("\n");

  printf("POINTERS\n");
  print_ptr_offset("p5",p5);
  print_ptr_offset("p4",p4);
  print_ptr_offset("p3",p3);
  print_ptr_offset("p2",p2);
  print_ptr_offset("p1",p1);
  printf("\n");

  el_free(p1);
  printf("FREE 1\n"); el_print_stats(); printf("\n");

  el_free(p3);
  printf("FREE 3\n"); el_print_stats(); printf("\n");

  p3 = el_malloc(32);
  p1 = el_malloc(200);
  
  printf("RE-ALLOC 3,1\n"); el_print_stats(); printf("\n");

  printf("POINTERS\n");
  print_ptr_offset("p1",p1);
  print_ptr_offset("p3",p3);
  print_ptr_offset("p5",p5);
  print_ptr_offset("p4",p4);
  print_ptr_offset("p2",p2);
  printf("\n");

  el_free(p1);

  printf("FREE'D 1\n"); el_print_stats(); printf("\n");

  el_free(p2);

  printf("FREE'D 2\n"); el_print_stats(); printf("\n");

  el_free(p3);
  el_free(p4);
  el_free(p5);

  printf("FREE'D 3,4,5\n"); el_print_stats(); printf("\n");
}
