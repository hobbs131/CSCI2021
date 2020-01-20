#include <stdlib.h>
#include "ds_search.h"

////////////////////////////////////////////////////////////////////////////////
// RANDOM NUMBER GENERATION UTILITY

// state of the random number generator for phase09 
unsigned long state = 1;

// generate a random integer
unsigned int pb_rand() {
  state = state * 1103515245 + 12345;
  return (unsigned int)(state/65536) % 32768;
}

// set seed for pb_rand()
void pb_srand(unsigned long seed){
  state = seed;
}
