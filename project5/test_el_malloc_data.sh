#!/bin/bash
T=0                             # global test number

# Global template to start a test
read  -r -d '' TEMPLATE <<EOF
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
EOF


################################################################################
((T++))
tnames[T]="single_alloc"
#
read  -r -d '' defines[$T] <<"ENDDEF"
#define HEAP_SIZE 1024
ENDDEF
#
read  -r -d '' cfile[$T] <<"ENDCFILE"
void run_test(){
  void *p0 = el_malloc(128);
  printf("MALLOC 0\n"); el_print_stats(); printf("\n");

  printf("POINTERS\n");
  print_ptr_offset("p0",p0);
}
ENDCFILE
#
read  -r -d '' output[$T] <<"ENDOUT"
MALLOC 0
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    856}
  [  0] head @    168 {state: a  size:    816}  foot @   1016 {size:    816}
USED LIST: blocklist{length:      1  bytes:    168}
  [  0] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
p0: 32 from heap start
ENDOUT

################################################################################
((T++))
tnames[T]="three_allocs"
#
read  -r -d '' defines[$T] <<"ENDDEF"
#define HEAP_SIZE 1024
ENDDEF
#
read  -r -d '' cfile[$T] <<"ENDCFILE"
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
}
ENDCFILE
#
read  -r -d '' output[$T] <<"ENDOUT"
MALLOC 0
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    856}
  [  0] head @    168 {state: a  size:    816}  foot @   1016 {size:    816}
USED LIST: blocklist{length:      1  bytes:    168}
  [  0] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start

MALLOC 1
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    616}
  [  0] head @    408 {state: a  size:    576}  foot @   1016 {size:    576}
USED LIST: blocklist{length:      2  bytes:    408}
  [  0] head @    168 {state: u  size:    200}  foot @    400 {size:    200}
  [  1] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start

MALLOC 2
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    512}
  [  0] head @    512 {state: a  size:    472}  foot @   1016 {size:    472}
USED LIST: blocklist{length:      3  bytes:    512}
  [  0] head @    408 {state: u  size:     64}  foot @    504 {size:     64}
  [  1] head @    168 {state: u  size:    200}  foot @    400 {size:    200}
  [  2] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start
ptr[ 2]: 440 from heap start
ENDOUT

################################################################################
((T++))
tnames[T]="reqd_basics"
#
read  -r -d '' defines[$T] <<"ENDDEF"
#define HEAP_SIZE 1024
ENDDEF
#
read  -r -d '' cfile[$T] <<"ENDCFILE"
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
ENDCFILE
#
read  -r -d '' output[$T] <<"ENDOUT"
used head 0: 408 from heap start
used foot 0: 504 from heap start
used head 1: 168 from heap start
used foot 1: 400 from heap start
used head 2: 0 from heap start
used foot 2: 160 from heap start
used head below 2 is: (nil)
ENDOUT



################################################################################
((T++))
tnames[T]="alloc_free"
#
read  -r -d '' defines[$T] <<"ENDDEF"
#define HEAP_SIZE 1024
ENDDEF
#
read  -r -d '' cfile[$T] <<"ENDCFILE"
void run_test(){
  void *ptr[16] = {};
  int len = 0;

  ptr[len++] = el_malloc(128);
  printf("\nMALLOC 0\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  el_free(ptr[0]);
  printf("\nFREE 0\n"); el_print_stats(); printf("\n");
}
ENDCFILE
#
read  -r -d '' output[$T] <<"ENDOUT"
MALLOC 0
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    856}
  [  0] head @    168 {state: a  size:    816}  foot @   1016 {size:    816}
USED LIST: blocklist{length:      1  bytes:    168}
  [  0] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start

FREE 0
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:   1024}
  [  0] head @      0 {state: a  size:    984}  foot @   1016 {size:    984}
USED LIST: blocklist{length:      0  bytes:      0}
ENDOUT


################################################################################
((T++))
tnames[T]="four_alloc_free_1"
#
read  -r -d '' defines[$T] <<"ENDDEF"
#define HEAP_SIZE 1024
ENDDEF
#
read  -r -d '' cfile[$T] <<"ENDCFILE"
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

  el_free(ptr[0]);
  printf("\nFREE 0\n"); el_print_stats(); printf("\n");

  el_free(ptr[1]);
  printf("\nFREE 1\n"); el_print_stats(); printf("\n");

  el_free(ptr[2]);
  printf("\nFREE 2\n"); el_print_stats(); printf("\n");

  el_free(ptr[3]);
  printf("\nFREE 3\n"); el_print_stats(); printf("\n");
}
ENDCFILE
#
read  -r -d '' output[$T] <<"ENDOUT"

MALLOC 0
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    856}
  [  0] head @    168 {state: a  size:    816}  foot @   1016 {size:    816}
USED LIST: blocklist{length:      1  bytes:    168}
  [  0] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start

MALLOC 1
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    616}
  [  0] head @    408 {state: a  size:    576}  foot @   1016 {size:    576}
USED LIST: blocklist{length:      2  bytes:    408}
  [  0] head @    168 {state: u  size:    200}  foot @    400 {size:    200}
  [  1] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start

MALLOC 2
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    512}
  [  0] head @    512 {state: a  size:    472}  foot @   1016 {size:    472}
USED LIST: blocklist{length:      3  bytes:    512}
  [  0] head @    408 {state: u  size:     64}  foot @    504 {size:     64}
  [  1] head @    168 {state: u  size:    200}  foot @    400 {size:    200}
  [  2] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start
ptr[ 2]: 440 from heap start

MALLOC 3
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    160}
  [  0] head @    864 {state: a  size:    120}  foot @   1016 {size:    120}
USED LIST: blocklist{length:      4  bytes:    864}
  [  0] head @    512 {state: u  size:    312}  foot @    856 {size:    312}
  [  1] head @    408 {state: u  size:     64}  foot @    504 {size:     64}
  [  2] head @    168 {state: u  size:    200}  foot @    400 {size:    200}
  [  3] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start
ptr[ 2]: 440 from heap start
ptr[ 3]: 544 from heap start

FREE 0
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    328}
  [  0] head @      0 {state: a  size:    128}  foot @    160 {size:    128}
  [  1] head @    864 {state: a  size:    120}  foot @   1016 {size:    120}
USED LIST: blocklist{length:      3  bytes:    696}
  [  0] head @    512 {state: u  size:    312}  foot @    856 {size:    312}
  [  1] head @    408 {state: u  size:     64}  foot @    504 {size:     64}
  [  2] head @    168 {state: u  size:    200}  foot @    400 {size:    200}


FREE 1
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    568}
  [  0] head @      0 {state: a  size:    368}  foot @    400 {size:    368}
  [  1] head @    864 {state: a  size:    120}  foot @   1016 {size:    120}
USED LIST: blocklist{length:      2  bytes:    456}
  [  0] head @    512 {state: u  size:    312}  foot @    856 {size:    312}
  [  1] head @    408 {state: u  size:     64}  foot @    504 {size:     64}


FREE 2
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    672}
  [  0] head @      0 {state: a  size:    472}  foot @    504 {size:    472}
  [  1] head @    864 {state: a  size:    120}  foot @   1016 {size:    120}
USED LIST: blocklist{length:      1  bytes:    352}
  [  0] head @    512 {state: u  size:    312}  foot @    856 {size:    312}


FREE 3
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:   1024}
  [  0] head @      0 {state: a  size:    984}  foot @   1016 {size:    984}
USED LIST: blocklist{length:      0  bytes:      0}

ENDOUT


################################################################################
((T++))
tnames[T]="four_alloc_free_2"
#
read  -r -d '' defines[$T] <<"ENDDEF"
#define HEAP_SIZE 1024
ENDDEF
#
read  -r -d '' cfile[$T] <<"ENDCFILE"
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

  el_free(ptr[1]);
  printf("\nFREE 1\n"); el_print_stats(); printf("\n");

  el_free(ptr[0]);
  printf("\nFREE 0\n"); el_print_stats(); printf("\n");

  el_free(ptr[3]);
  printf("\nFREE 3\n"); el_print_stats(); printf("\n");

  el_free(ptr[2]);
  printf("\nFREE 2\n"); el_print_stats(); printf("\n");
}
ENDCFILE
#
read  -r -d '' output[$T] <<"ENDOUT"

MALLOC 0
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    856}
  [  0] head @    168 {state: a  size:    816}  foot @   1016 {size:    816}
USED LIST: blocklist{length:      1  bytes:    168}
  [  0] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start

MALLOC 1
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    616}
  [  0] head @    408 {state: a  size:    576}  foot @   1016 {size:    576}
USED LIST: blocklist{length:      2  bytes:    408}
  [  0] head @    168 {state: u  size:    200}  foot @    400 {size:    200}
  [  1] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start

MALLOC 2
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    512}
  [  0] head @    512 {state: a  size:    472}  foot @   1016 {size:    472}
USED LIST: blocklist{length:      3  bytes:    512}
  [  0] head @    408 {state: u  size:     64}  foot @    504 {size:     64}
  [  1] head @    168 {state: u  size:    200}  foot @    400 {size:    200}
  [  2] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start
ptr[ 2]: 440 from heap start

MALLOC 3
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    160}
  [  0] head @    864 {state: a  size:    120}  foot @   1016 {size:    120}
USED LIST: blocklist{length:      4  bytes:    864}
  [  0] head @    512 {state: u  size:    312}  foot @    856 {size:    312}
  [  1] head @    408 {state: u  size:     64}  foot @    504 {size:     64}
  [  2] head @    168 {state: u  size:    200}  foot @    400 {size:    200}
  [  3] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start
ptr[ 2]: 440 from heap start
ptr[ 3]: 544 from heap start

FREE 1
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    400}
  [  0] head @    168 {state: a  size:    200}  foot @    400 {size:    200}
  [  1] head @    864 {state: a  size:    120}  foot @   1016 {size:    120}
USED LIST: blocklist{length:      3  bytes:    624}
  [  0] head @    512 {state: u  size:    312}  foot @    856 {size:    312}
  [  1] head @    408 {state: u  size:     64}  foot @    504 {size:     64}
  [  2] head @      0 {state: u  size:    128}  foot @    160 {size:    128}


FREE 0
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    568}
  [  0] head @      0 {state: a  size:    368}  foot @    400 {size:    368}
  [  1] head @    864 {state: a  size:    120}  foot @   1016 {size:    120}
USED LIST: blocklist{length:      2  bytes:    456}
  [  0] head @    512 {state: u  size:    312}  foot @    856 {size:    312}
  [  1] head @    408 {state: u  size:     64}  foot @    504 {size:     64}


FREE 3
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    920}
  [  0] head @    512 {state: a  size:    472}  foot @   1016 {size:    472}
  [  1] head @      0 {state: a  size:    368}  foot @    400 {size:    368}
USED LIST: blocklist{length:      1  bytes:    104}
  [  0] head @    408 {state: u  size:     64}  foot @    504 {size:     64}


FREE 2
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:   1024}
  [  0] head @      0 {state: a  size:    984}  foot @   1016 {size:    984}
USED LIST: blocklist{length:      0  bytes:      0}

ENDOUT

################################################################################
((T++))
tnames[T]="four_alloc_free_3"
#
read  -r -d '' defines[$T] <<"ENDDEF"
#define HEAP_SIZE 1024
ENDDEF
#
read  -r -d '' cfile[$T] <<"ENDCFILE"
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
ENDCFILE
#
read  -r -d '' output[$T] <<"ENDOUT"

MALLOC 0
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    856}
  [  0] head @    168 {state: a  size:    816}  foot @   1016 {size:    816}
USED LIST: blocklist{length:      1  bytes:    168}
  [  0] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start

MALLOC 1
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    616}
  [  0] head @    408 {state: a  size:    576}  foot @   1016 {size:    576}
USED LIST: blocklist{length:      2  bytes:    408}
  [  0] head @    168 {state: u  size:    200}  foot @    400 {size:    200}
  [  1] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start

MALLOC 2
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    512}
  [  0] head @    512 {state: a  size:    472}  foot @   1016 {size:    472}
USED LIST: blocklist{length:      3  bytes:    512}
  [  0] head @    408 {state: u  size:     64}  foot @    504 {size:     64}
  [  1] head @    168 {state: u  size:    200}  foot @    400 {size:    200}
  [  2] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start
ptr[ 2]: 440 from heap start

MALLOC 3
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    160}
  [  0] head @    864 {state: a  size:    120}  foot @   1016 {size:    120}
USED LIST: blocklist{length:      4  bytes:    864}
  [  0] head @    512 {state: u  size:    312}  foot @    856 {size:    312}
  [  1] head @    408 {state: u  size:     64}  foot @    504 {size:     64}
  [  2] head @    168 {state: u  size:    200}  foot @    400 {size:    200}
  [  3] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start
ptr[ 2]: 440 from heap start
ptr[ 3]: 544 from heap start

FREE 3
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    512}
  [  0] head @    512 {state: a  size:    472}  foot @   1016 {size:    472}
USED LIST: blocklist{length:      3  bytes:    512}
  [  0] head @    408 {state: u  size:     64}  foot @    504 {size:     64}
  [  1] head @    168 {state: u  size:    200}  foot @    400 {size:    200}
  [  2] head @      0 {state: u  size:    128}  foot @    160 {size:    128}


FREE 0
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    680}
  [  0] head @      0 {state: a  size:    128}  foot @    160 {size:    128}
  [  1] head @    512 {state: a  size:    472}  foot @   1016 {size:    472}
USED LIST: blocklist{length:      2  bytes:    344}
  [  0] head @    408 {state: u  size:     64}  foot @    504 {size:     64}
  [  1] head @    168 {state: u  size:    200}  foot @    400 {size:    200}


FREE 2
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    784}
  [  0] head @    408 {state: a  size:    576}  foot @   1016 {size:    576}
  [  1] head @      0 {state: a  size:    128}  foot @    160 {size:    128}
USED LIST: blocklist{length:      1  bytes:    240}
  [  0] head @    168 {state: u  size:    200}  foot @    400 {size:    200}


FREE 1
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:   1024}
  [  0] head @      0 {state: a  size:    984}  foot @   1016 {size:    984}
USED LIST: blocklist{length:      0  bytes:      0}

ENDOUT


################################################################################
((T++))
tnames[T]="alloc_fail"
#
read  -r -d '' defines[$T] <<"ENDDEF"
#define HEAP_SIZE 1024
ENDDEF
#
read  -r -d '' cfile[$T] <<"ENDCFILE"
void run_test(){
  void *ptr[16] = {};
  int len = 0;

  ptr[len++] = el_malloc(128);
  ptr[len++] = el_malloc(256);
  ptr[len++] = el_malloc(64);
  ptr[len++] = el_malloc(200);
  printf("\nMALLOC 4\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  ptr[len++] = el_malloc(512);
  printf("\nMALLOC 5\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);
  printf("should be (nil)\n");
}
ENDCFILE
#
read  -r -d '' output[$T] <<"ENDOUT"

MALLOC 4
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    216}
  [  0] head @    808 {state: a  size:    176}  foot @   1016 {size:    176}
USED LIST: blocklist{length:      4  bytes:    808}
  [  0] head @    568 {state: u  size:    200}  foot @    800 {size:    200}
  [  1] head @    464 {state: u  size:     64}  foot @    560 {size:     64}
  [  2] head @    168 {state: u  size:    256}  foot @    456 {size:    256}
  [  3] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start
ptr[ 2]: 496 from heap start
ptr[ 3]: 600 from heap start

MALLOC 5
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    216}
  [  0] head @    808 {state: a  size:    176}  foot @   1016 {size:    176}
USED LIST: blocklist{length:      4  bytes:    808}
  [  0] head @    568 {state: u  size:    200}  foot @    800 {size:    200}
  [  1] head @    464 {state: u  size:     64}  foot @    560 {size:     64}
  [  2] head @    168 {state: u  size:    256}  foot @    456 {size:    256}
  [  3] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start
ptr[ 2]: 496 from heap start
ptr[ 3]: 600 from heap start
ptr[ 4]: (nil)
should be (nil)
ENDOUT

################################################################################
((T++))
tnames[T]="el_demo"
#
read  -r -d '' defines[$T] <<"ENDDEF"
#define HEAP_SIZE 1024
ENDDEF
#
read  -r -d '' cfile[$T] <<"ENDCFILE"
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
ENDCFILE
#
read  -r -d '' output[$T] <<"ENDOUT"
INITIAL
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:   1024}
  [  0] head @      0 {state: a  size:    984}  foot @   1016 {size:    984}
USED LIST: blocklist{length:      0  bytes:      0}

MALLOC 3
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    572}
  [  0] head @    452 {state: a  size:    532}  foot @   1016 {size:    532}
USED LIST: blocklist{length:      3  bytes:    452}
  [  0] head @    256 {state: u  size:    156}  foot @    444 {size:    156}
  [  1] head @    168 {state: u  size:     48}  foot @    248 {size:     48}
  [  2] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
p3: 288 from heap start
p2: 200 from heap start
p1: 32 from heap start

MALLOC 5
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    406}
  [  0] head @    618 {state: a  size:    366}  foot @   1016 {size:    366}
USED LIST: blocklist{length:      5  bytes:    618}
  [  0] head @    514 {state: u  size:     64}  foot @    610 {size:     64}
  [  1] head @    452 {state: u  size:     22}  foot @    506 {size:     22}
  [  2] head @    256 {state: u  size:    156}  foot @    444 {size:    156}
  [  3] head @    168 {state: u  size:     48}  foot @    248 {size:     48}
  [  4] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
p5: 546 from heap start
p4: 484 from heap start
p3: 288 from heap start
p2: 200 from heap start
p1: 32 from heap start

FREE 1
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    574}
  [  0] head @      0 {state: a  size:    128}  foot @    160 {size:    128}
  [  1] head @    618 {state: a  size:    366}  foot @   1016 {size:    366}
USED LIST: blocklist{length:      4  bytes:    450}
  [  0] head @    514 {state: u  size:     64}  foot @    610 {size:     64}
  [  1] head @    452 {state: u  size:     22}  foot @    506 {size:     22}
  [  2] head @    256 {state: u  size:    156}  foot @    444 {size:    156}
  [  3] head @    168 {state: u  size:     48}  foot @    248 {size:     48}

FREE 3
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      3  bytes:    770}
  [  0] head @    256 {state: a  size:    156}  foot @    444 {size:    156}
  [  1] head @      0 {state: a  size:    128}  foot @    160 {size:    128}
  [  2] head @    618 {state: a  size:    366}  foot @   1016 {size:    366}
USED LIST: blocklist{length:      3  bytes:    254}
  [  0] head @    514 {state: u  size:     64}  foot @    610 {size:     64}
  [  1] head @    452 {state: u  size:     22}  foot @    506 {size:     22}
  [  2] head @    168 {state: u  size:     48}  foot @    248 {size:     48}

RE-ALLOC 3,1
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      3  bytes:    458}
  [  0] head @    858 {state: a  size:    126}  foot @   1016 {size:    126}
  [  1] head @    328 {state: a  size:     84}  foot @    444 {size:     84}
  [  2] head @      0 {state: a  size:    128}  foot @    160 {size:    128}
USED LIST: blocklist{length:      5  bytes:    566}
  [  0] head @    618 {state: u  size:    200}  foot @    850 {size:    200}
  [  1] head @    256 {state: u  size:     32}  foot @    320 {size:     32}
  [  2] head @    514 {state: u  size:     64}  foot @    610 {size:     64}
  [  3] head @    452 {state: u  size:     22}  foot @    506 {size:     22}
  [  4] head @    168 {state: u  size:     48}  foot @    248 {size:     48}

POINTERS
p1: 650 from heap start
p3: 288 from heap start
p5: 546 from heap start
p4: 484 from heap start
p2: 200 from heap start

FREE'D 1
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      3  bytes:    698}
  [  0] head @    618 {state: a  size:    366}  foot @   1016 {size:    366}
  [  1] head @    328 {state: a  size:     84}  foot @    444 {size:     84}
  [  2] head @      0 {state: a  size:    128}  foot @    160 {size:    128}
USED LIST: blocklist{length:      4  bytes:    326}
  [  0] head @    256 {state: u  size:     32}  foot @    320 {size:     32}
  [  1] head @    514 {state: u  size:     64}  foot @    610 {size:     64}
  [  2] head @    452 {state: u  size:     22}  foot @    506 {size:     22}
  [  3] head @    168 {state: u  size:     48}  foot @    248 {size:     48}

FREE'D 2
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      3  bytes:    786}
  [  0] head @      0 {state: a  size:    216}  foot @    248 {size:    216}
  [  1] head @    618 {state: a  size:    366}  foot @   1016 {size:    366}
  [  2] head @    328 {state: a  size:     84}  foot @    444 {size:     84}
USED LIST: blocklist{length:      3  bytes:    238}
  [  0] head @    256 {state: u  size:     32}  foot @    320 {size:     32}
  [  1] head @    514 {state: u  size:     64}  foot @    610 {size:     64}
  [  2] head @    452 {state: u  size:     22}  foot @    506 {size:     22}

FREE'D 3,4,5
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:   1024}
  [  0] head @      0 {state: a  size:    984}  foot @   1016 {size:    984}
USED LIST: blocklist{length:      0  bytes:      0}

ENDOUT

################################################################################
((T++))
tnames[T]="stress1"
#
read  -r -d '' defines[$T] <<"ENDDEF"
#define HEAP_SIZE 1024
ENDDEF
#
read  -r -d '' cfile[$T] <<"ENDCFILE"
void run_test(){
  void *ptr[16] = {};
  int len = 0;

  ptr[len++] = el_malloc(128);
  ptr[len++] = el_malloc(256);
  ptr[len++] = el_malloc(64);
  ptr[len++] = el_malloc(200);
  printf("\nMALLOC 1-4\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  el_free(ptr[2]);    ptr[2] = NULL;
  printf("\nFREE 2\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  ptr[len++] = el_malloc(64);
  printf("\nMALLOC 5\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  el_free(ptr[1]);    ptr[1] = NULL;
  printf("\nFREE 1\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  ptr[len++] = el_malloc(50);
  ptr[len++] = el_malloc(50);
  printf("\nMALLOC 6-7\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  ptr[len++] = el_malloc(100);
  printf("\nMALLOC 8\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  el_free(ptr[5]);   ptr[5] = NULL;
  el_free(ptr[0]);   ptr[0] = NULL;
  el_free(ptr[6]);   ptr[6] = NULL;
  printf("\nFREE 5,0,6\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);

  ptr[len++] = el_malloc(200);
  ptr[len++] = el_malloc(512);
  ptr[len++] = el_malloc(16);
  ptr[len++] = el_malloc(32);
  printf("\nMALLOC 9,10,11\n"); el_print_stats(); printf("\n");
  printf("POINTERS\n"); print_ptrs(ptr, len);
}
ENDCFILE
#
read  -r -d '' output[$T] <<"ENDOUT"

MALLOC 1-4
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      1  bytes:    216}
  [  0] head @    808 {state: a  size:    176}  foot @   1016 {size:    176}
USED LIST: blocklist{length:      4  bytes:    808}
  [  0] head @    568 {state: u  size:    200}  foot @    800 {size:    200}
  [  1] head @    464 {state: u  size:     64}  foot @    560 {size:     64}
  [  2] head @    168 {state: u  size:    256}  foot @    456 {size:    256}
  [  3] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start
ptr[ 2]: 496 from heap start
ptr[ 3]: 600 from heap start

FREE 2
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    320}
  [  0] head @    464 {state: a  size:     64}  foot @    560 {size:     64}
  [  1] head @    808 {state: a  size:    176}  foot @   1016 {size:    176}
USED LIST: blocklist{length:      3  bytes:    704}
  [  0] head @    568 {state: u  size:    200}  foot @    800 {size:    200}
  [  1] head @    168 {state: u  size:    256}  foot @    456 {size:    256}
  [  2] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start
ptr[ 2]: (nil)
ptr[ 3]: 600 from heap start

MALLOC 5
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    216}
  [  0] head @    912 {state: a  size:     72}  foot @   1016 {size:     72}
  [  1] head @    464 {state: a  size:     64}  foot @    560 {size:     64}
USED LIST: blocklist{length:      4  bytes:    808}
  [  0] head @    808 {state: u  size:     64}  foot @    904 {size:     64}
  [  1] head @    568 {state: u  size:    200}  foot @    800 {size:    200}
  [  2] head @    168 {state: u  size:    256}  foot @    456 {size:    256}
  [  3] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: 200 from heap start
ptr[ 2]: (nil)
ptr[ 3]: 600 from heap start
ptr[ 4]: 840 from heap start

FREE 1
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    512}
  [  0] head @    168 {state: a  size:    360}  foot @    560 {size:    360}
  [  1] head @    912 {state: a  size:     72}  foot @   1016 {size:     72}
USED LIST: blocklist{length:      3  bytes:    512}
  [  0] head @    808 {state: u  size:     64}  foot @    904 {size:     64}
  [  1] head @    568 {state: u  size:    200}  foot @    800 {size:    200}
  [  2] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: (nil)
ptr[ 2]: (nil)
ptr[ 3]: 600 from heap start
ptr[ 4]: 840 from heap start

MALLOC 6-7
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    332}
  [  0] head @    348 {state: a  size:    180}  foot @    560 {size:    180}
  [  1] head @    912 {state: a  size:     72}  foot @   1016 {size:     72}
USED LIST: blocklist{length:      5  bytes:    692}
  [  0] head @    258 {state: u  size:     50}  foot @    340 {size:     50}
  [  1] head @    168 {state: u  size:     50}  foot @    250 {size:     50}
  [  2] head @    808 {state: u  size:     64}  foot @    904 {size:     64}
  [  3] head @    568 {state: u  size:    200}  foot @    800 {size:    200}
  [  4] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: (nil)
ptr[ 2]: (nil)
ptr[ 3]: 600 from heap start
ptr[ 4]: 840 from heap start
ptr[ 5]: 200 from heap start
ptr[ 6]: 290 from heap start

MALLOC 8
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      2  bytes:    192}
  [  0] head @    488 {state: a  size:     40}  foot @    560 {size:     40}
  [  1] head @    912 {state: a  size:     72}  foot @   1016 {size:     72}
USED LIST: blocklist{length:      6  bytes:    832}
  [  0] head @    348 {state: u  size:    100}  foot @    480 {size:    100}
  [  1] head @    258 {state: u  size:     50}  foot @    340 {size:     50}
  [  2] head @    168 {state: u  size:     50}  foot @    250 {size:     50}
  [  3] head @    808 {state: u  size:     64}  foot @    904 {size:     64}
  [  4] head @    568 {state: u  size:    200}  foot @    800 {size:    200}
  [  5] head @      0 {state: u  size:    128}  foot @    160 {size:    128}

POINTERS
ptr[ 0]: 32 from heap start
ptr[ 1]: (nil)
ptr[ 2]: (nil)
ptr[ 3]: 600 from heap start
ptr[ 4]: 840 from heap start
ptr[ 5]: 200 from heap start
ptr[ 6]: 290 from heap start
ptr[ 7]: 380 from heap start

FREE 5,0,6
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      3  bytes:    540}
  [  0] head @      0 {state: a  size:    308}  foot @    340 {size:    308}
  [  1] head @    488 {state: a  size:     40}  foot @    560 {size:     40}
  [  2] head @    912 {state: a  size:     72}  foot @   1016 {size:     72}
USED LIST: blocklist{length:      3  bytes:    484}
  [  0] head @    348 {state: u  size:    100}  foot @    480 {size:    100}
  [  1] head @    808 {state: u  size:     64}  foot @    904 {size:     64}
  [  2] head @    568 {state: u  size:    200}  foot @    800 {size:    200}

POINTERS
ptr[ 0]: (nil)
ptr[ 1]: (nil)
ptr[ 2]: (nil)
ptr[ 3]: 600 from heap start
ptr[ 4]: 840 from heap start
ptr[ 5]: (nil)
ptr[ 6]: (nil)
ptr[ 7]: 380 from heap start

MALLOC 9,10,11
HEAP STATS
Heap bytes: 1024
AVAILABLE LIST: blocklist{length:      3  bytes:    172}
  [  0] head @    984 {state: a  size:      0}  foot @   1016 {size:      0}
  [  1] head @    296 {state: a  size:     12}  foot @    340 {size:     12}
  [  2] head @    488 {state: a  size:     40}  foot @    560 {size:     40}
USED LIST: blocklist{length:      6  bytes:    852}
  [  0] head @    912 {state: u  size:     32}  foot @    976 {size:     32}
  [  1] head @    240 {state: u  size:     16}  foot @    288 {size:     16}
  [  2] head @      0 {state: u  size:    200}  foot @    232 {size:    200}
  [  3] head @    348 {state: u  size:    100}  foot @    480 {size:    100}
  [  4] head @    808 {state: u  size:     64}  foot @    904 {size:     64}
  [  5] head @    568 {state: u  size:    200}  foot @    800 {size:    200}

POINTERS
ptr[ 0]: (nil)
ptr[ 1]: (nil)
ptr[ 2]: (nil)
ptr[ 3]: 600 from heap start
ptr[ 4]: 840 from heap start
ptr[ 5]: (nil)
ptr[ 6]: (nil)
ptr[ 7]: 380 from heap start
ptr[ 8]: 32 from heap start
ptr[ 9]: (nil)
ptr[10]: 272 from heap start
ptr[11]: 944 from heap start
ENDOUT
