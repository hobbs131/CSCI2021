#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "deltas.h"
// Main very similar to A1 problem 1 main
int main(int argc, char *argv[]){
  if(argc < 3){
    printf("usage: %s <format> <filename>\n",argv[0]);
    printf(" <format> is one of\n");
    printf(" text : text ints are in the given filename\n");
    printf(" int  : binary ints are in the given filename\n");
    printf(" 4bit : 4bit binary ints are in the given filename\n");
    return 1;
  }
  char *format = argv[1];
  char *fname = argv[2];
  // Conversion from string to int
  int max_height = atoi(argv[3]);
  int data_len = -1;
  int *data_vals = NULL;

  // Text format handler
  if( strcmp("text", format)==0 ){
    printf("Reading text format\n");
    data_vals = read_text_deltas(fname, &data_len);
    print_graph(data_vals,data_len,max_height);
  }
  // Binary format handler
  else if( strcmp("int", format)==0 ){
    printf("Reading binary int format\n");
    data_vals = read_int_deltas(fname, &data_len);
    print_graph(data_vals,data_len,max_height);
  }
  else{
    printf("Unknown format '%s'\n",format);
    return 1;
  }
  //Free the alotted array.
  free(data_vals);
  return 0;
}
