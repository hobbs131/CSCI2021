#include <time.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "search.h"

int main(int argc, char *argv[]){
  // local variables defined
  int do_binary_search = 0;
  int do_linear_array = 0;
  int do_linked_list = 0;
  int do_tree_search = 0;
  int min = atoi(argv[1]);
  int max = atoi(argv[2]);
  int repetitions = atoi(argv[3]);
  double linked_time;
  double linear_time;
  double bst_time;
  double binary_time;

  clock_t begin, end;
  // if there is no algorithm argument, time them all
  if (argv[4] == NULL){
    do_binary_search = 1;
    do_linear_array = 1;
    do_linked_list = 1;
    do_tree_search = 1;
    //formatting
    printf("LENGTH SEARCHES");
    printf("  binary");
    printf("     linear");
    printf("         list");
    printf("      tree");
  }
  // Otherwise time chosen algorithms
  else{
    char *algs_arg = argv[4];
    printf("LENGTH SEARCHES");
    for(int i = 0; i < strlen(algs_arg); i++){
      if(algs_arg[i] == 'a'){
        do_linear_array = 1;
        printf("   binary");
      }
      else if(algs_arg[i] == 'l'){
        do_linked_list = 1;
        printf("      linear");
      }
      else if (algs_arg[i] == 'b'){
        do_binary_search = 1;
        printf("           list");

      }
      else if (algs_arg[i] == 't'){
        do_tree_search = 1;
        printf("     tree");
      }
    }
  }

  printf("\n");

  // Loop for sizes
  for (int a = min; a <= max; a++){
    // a = a * 2
    int length = 1 << a;
    //formatting for length and searches
    printf("%6d %6d", length, length * 2 * repetitions);
    
    // time binary search
    if (do_binary_search == 1){
      int* binary_array = make_evens_array(length);
      begin = clock();
      for (int i = 0; i < repetitions; i++){
        for(int j = 0; j <= length; j++){
          binary_array_search(binary_array,length,j);
        }
      }
      end = clock();
      double binary_time = ((double) (end - begin)) / CLOCKS_PER_SEC;
      printf("  %10.4e", binary_time);
      free(binary_array);
    }
    // time linear search
    if (do_linear_array == 1){
      int* linear_array = make_evens_array(length);
      begin = clock();
      for (int i = 0; i < repetitions; i++){
        for(int j = 0; j <= length; j++){
          linear_array_search(linear_array,length,j);
        }
      }
      end = clock();
      double linear_time = ((double) (end - begin)) / CLOCKS_PER_SEC;
      printf("  %10.4e", linear_time);
      free(linear_array);
    }

    // time linked-list search
    if (do_linked_list == 1){
      list_t* linked_list = make_evens_list(length);
      begin = clock();
      for (int i = 0; i < repetitions; i++){
        for(int j = 0; j <= length; j++){
          linkedlist_search(linked_list,length,j);
        }
      }
      end = clock();
      double linked_time = ((double) (end - begin)) / CLOCKS_PER_SEC;
      printf("    %10.4e", linked_time);
      list_free(linked_list);
    }
    // time bst search
    if (do_tree_search == 1){
      bst_t* binary_tree = make_evens_tree(length);
      begin = clock();
      for (int i = 0; i < repetitions; i++){
        for(int j = 0; j <= length; j++){
          binary_tree_search(binary_tree,0,j);
        }
      }
      end = clock();
      double bst_time = ((double) (end - begin)) / CLOCKS_PER_SEC;
      printf("    %10.4e", bst_time);
      bst_free(binary_tree);
    }
    printf("\n");
  }
  return 0;
}
