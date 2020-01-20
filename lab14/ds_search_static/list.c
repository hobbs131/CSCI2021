#include <stdlib.h>
#include "ds_search.h"


////////////////////////////////////////////////////////////////////////////////
// SEARCH ALGORITHMS

// Search a linked list linearly, does not need to be sorted
int linkedlist_search(list_t *list, int len, int query){
  for(node_t *n=list->head; n!=NULL; n=n->right){
    int data = n->data;
    if(data == query){
      return 1;
    }
  }
  return 0;
}

////////////////////////////////////////////////////////////////////////////////
// SETUP FUNCTIONS


// allocate a linked list with data elements 0, 1*strdie, 2*stride, ...
list_t *make_sequential_list(int len, int stride){
  node_t **arr = malloc(sizeof(node_t*)*len);
  for(int i=0; i<len; i++){
    int *gap = malloc(1024);      // create gaps in malloc'd memory
    arr[i] = malloc(sizeof(node_t));
    free(gap);
  }

  int rounds = len * 100;
  // scramble the array so that the node memory locations are not
  // necessarily sequential. Simulates behavior of general
  // implementation when the mallocs may not all happen at once.
  for(int i=0; i<rounds; i++){
    unsigned int idx = pb_rand() % len;
    unsigned int jdx = pb_rand() % len;
    node_t *tmp = arr[idx];
    arr[idx] = arr[jdx];
    arr[jdx] = tmp;
  }

  // first node
  arr[0]->data = 0*stride;
  arr[0]->right = arr[1];
  arr[0]->left  = NULL;

  // set the data as sorted
  for(int i=1; i<len-1; i++){
    arr[i]->data = i*stride;
    arr[i]->right = arr[i+1];
    arr[i]->left  = arr[i-1];
  }
  
  // last node
  arr[len-1]->data  = (len-1)*stride;
  arr[len-1]->right = NULL;
  arr[len-1]->left  = arr[len-2];

  list_t *list = malloc(sizeof(list_t));
  list->size = len;
  list->head = arr[0];
  free(arr);                                  // don't need array of pointers: in tree now

  return list;
}


////////////////////////////////////////////////////////////////////////////////
// CLEANUP FUNCTIONS

// Free a linked list
void list_free(list_t *list){
  node_t *cur=list->head;
  for(int i=0; i < list->size; i++){
    node_t *n = cur;
    cur = cur->right;
    free(n);
  }
  free(list);
}


