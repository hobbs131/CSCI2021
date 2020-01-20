#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <error.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include "ds_search.h"


int main(int argc, char *argv[]){
  long repeats = 10;
  long len = 2048;

  list_t *data = make_sequential_list(len,2);
  long successes = 0;
  clock_t begin = clock();      // start timing

  for(int r=0; r<repeats; r++){ // repeats
    for(int i=0; i<len/2; i++){ // all elements of data structure
      successes += linkedlist_search(data, len, i);
      successes += linkedlist_search(data, len, i+len/2);
    }
  }

  clock_t end = clock();        // stop timing
  double cpu_time = ((double) (end - begin)) / CLOCKS_PER_SEC;
  printf("Searching %ld elem array, %ld repeats: %10.4e seconds\n",
         len,repeats,cpu_time);
  list_free(data);

  printf("program pid is %d\n",getpid());
  printf("press any key to continue\n");
  getchar();

  return 0;
}
