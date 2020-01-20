#include <stdlib.h>
#include "ds_search.h"


////////////////////////////////////////////////////////////////////////////////
// SEARCH ALGORITHMS

// Search a binary search tree
int binary_tree_search(bst_t *tree, int ignore, int query){
  node_t *node = tree->root;
  while(node != NULL){
    int data = node->data;
    if(query < data){
      node = node->left;
    }
    else if(query > data){
      node =node->right;
    }
    else{
      return 1;
    }
  }
  return 0;
}


////////////////////////////////////////////////////////////////////////////////
// SETUP FUNCTIONS

// Create a binary search tree with data elements 0,1,2,... that is
// well-balanced
bst_t *make_sequential_tree(int len, int stride){
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

  // set the data as sorted
  for(int i=0; i<len; i++){
    arr[i]->data = i*stride;
    arr[i]->left  = NULL;
    arr[i]->right = NULL;

  }

  node_t *root = tree_merge(arr, 0, len-1);   // merge the nodes into a tree
  free(arr);                                  // don't need array of pointers: in tree now

  bst_t *tree = malloc(sizeof(bst_t));
  tree->size = len;
  tree->root = root;

  return tree;
}


// Recursively merge the nodes in a sorted array of nodes into a
// balanced binary search tree
node_t *tree_merge(node_t *arr[], int lo, int hi){
  if(lo == hi){                 // 1 node remaining
    return arr[lo];             // return it
  }

  int mid = (lo+hi)/2;
  if(mid == lo){                // 2 nodes remaining
    arr[lo]->right = arr[hi]; // make left root, right child
    return arr[lo];
  }

  // recursive case
  node_t *root  = arr[mid];
  root->left  = tree_merge(arr, lo, mid-1);
  root->right = tree_merge(arr, mid+1, hi);
  return root;
}


////////////////////////////////////////////////////////////////////////////////
// CLEANUP FUNCTIONS

// Eliminate all nodes in the tree setting its contents empty. Uses
// recursive node_remove_all() function to free memory for all nodes.
void bst_free(bst_t *tree){
  node_remove_all(tree->root);
  free(tree);
  return;
}

// Recursive helper function which visits all nodes in a tree and
// frees the memory associated with them. This requires a post-order
// traversal: visit left tree, visit right tree, then free the cur
// node.
void node_remove_all(node_t *cur){
  if(cur == NULL){
    return;
  }
  node_remove_all(cur->left);
  node_remove_all(cur->right);
  free(cur);
  return;
}


