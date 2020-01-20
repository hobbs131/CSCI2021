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
  ptr[len++] = el_malloc(200);
  ptr[len++] = el_malloc(64);

  el_blockhead_t *head = el_ctl.used->beg->next;
  el_blockfoot_t *foot;

  foot = el_get_footer(head);
  head = el_get_header(foot);
  print_ptr_offset("used head 0",head);
  print_ptr_offset("used foot 0",foot);

  head = el_block_below(head);
  foot = el_get_footer(head);
  head = el_get_header(foot);
  print_ptr_offset("used head 1",head);
  print_ptr_offset("used foot 1",foot);

  head = el_block_below(head);
  foot = el_get_footer(head);
  head = el_get_header(foot);
  print_ptr_offset("used head 2",head);
  print_ptr_offset("used foot 2",foot);

  head = el_block_below(head);
  printf("used head below 2 is: %p\n",head);
}
