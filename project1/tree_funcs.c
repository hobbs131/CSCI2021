#include <stdlib.h>
#include <stdio.h>
#include <string.h> // for strcpy() and strcmp()
#include "tree.h"

// Initializes the bst
void bst_init(bst_t *tree){
  tree->root = NULL;
  tree->size = 0;
  return;
}

int bst_insert(bst_t *tree, char name[]){
  // Nodes for traversal and insertion
  node_t *ptr = tree -> root;
  node_t *trailer = NULL;

  // Allocates room for the new node and sets its parameters (name,left,right)
  node_t *node_to_insert = (node_t*)malloc(sizeof(node_t));
  strcpy(node_to_insert -> name, name);
  node_to_insert -> left = NULL;
  node_to_insert -> right = NULL;

  while (ptr != NULL){
    trailer = ptr;
    // Traverse through left branch
    if (strcmp(ptr -> name, name) > 0){
      ptr = ptr -> left;
    }
    // Don't insert duplicates
    else if (strcmp(ptr -> name,name) == 0){
      return 0;
    }
    // Traverse through right branch
    else{
      ptr = ptr -> right;
    }
  }
  // Root is null, so make node_to_insert the root
  if (trailer == NULL){
    tree -> root = node_to_insert;
    tree -> size++;
    return 1;
  }
  // Name is less than node's name, assign node_to_insert to be left child
  else if (strcmp(trailer -> name,name) > 0){
    trailer -> left = node_to_insert;
  }
  // Name is greater than node's name, assign node_to_insert to be the right child
  else{
    trailer -> right = node_to_insert;
  }
  tree -> size++;
  return 1;
}

int bst_find(bst_t *tree, char name[]){
  node_t *ptr = tree -> root;

  // Searches through right side of tree for name
  while (ptr != NULL){
    if (strcmp(ptr -> name, name) > 0){
      ptr = ptr -> left;
    }
    else if(strcmp(ptr -> name, name) < 0){
      ptr = ptr -> right;
    }
    else{
      return 1;
    }
  }
  return 0;
  // Resets pointer to root if name is not found on right side
  ptr = tree -> root;

  // Searches through left side of tree for name
  while (ptr != NULL){

    if (strcmp(ptr -> name, name) == 0){
      return 1;
    }
    ptr = ptr -> left;
  }
  // Returns 0 if name not found.
  return 0;
}

void bst_clear(bst_t *tree){
  node_remove_all(tree->root);
  tree -> root = NULL;
  tree -> size = 0;
}
// Helper function that uses post-order recursive traversal to fre enodes.
void node_remove_all (node_t *cur){
  if (cur == NULL){
    return;
  }
  node_remove_all(cur -> left);
  node_remove_all(cur -> right);
  free(cur);
}
void bst_print_revorder(bst_t *tree){
  node_print_revorder(tree -> root, 0);
  return;
}

// Helper function that formats and prints the tree in reverse order.
void node_print_revorder(node_t *cur,int indent){
  indent++;
  if (cur == NULL){
    return;
  }
  node_print_revorder(cur -> right, indent);
  for(int i = 1; i < indent; i++){
    printf("  ");
  }
  printf("%s\n", cur -> name);
  node_print_revorder(cur -> left,indent);

}
// Traverses and prints elements in tree in preorder.
void node_print_preorder(node_t *cur, int depth){
  depth++;
  node_t *ptr = cur;
  if (ptr == NULL){
    return;
  }
  // Formatting loop
  for (int i = 1; i < depth; i++){
    printf("  ");
  }
  printf("%s\n", ptr -> name);
  // Recursive calls
  node_print_preorder(ptr -> left, depth);
  node_print_preorder(ptr -> right, depth);
}
void bst_print_preorder(bst_t *tree){
  node_t *ptr = tree -> root;
  node_print_preorder(ptr,0);
}
// Opens and writes to file using helper function node_write_preorder
void bst_save(bst_t *tree, char *fname){
  FILE *fp = fopen(fname,"w");
  node_write_preorder(tree -> root,fp,0);
  fclose(fp);
  return;
}
// Takes open file handle and writes tree into it in preorder
void node_write_preorder(node_t *cur, FILE *out, int depth){
  node_t *ptr = cur;
  depth++;

  if(ptr == NULL){
    return;
  }
  for(int i = 1; i < depth; i++){
    fprintf(out,"  ");
  }
  fprintf(out,"%s\n",ptr -> name);
  node_write_preorder(ptr -> left,out,depth);
  node_write_preorder(ptr -> right,out,depth);
}
// Clears tree and loads in new one from given filename
int bst_load(bst_t *tree, char *fname){
  bst_clear(tree);

  FILE *fp = fopen(fname,"r");
  if (fp == NULL){
    return 0;
  }
  char string_to_insert[128];
  while(fscanf(fp,"%s",string_to_insert) != EOF){
    bst_insert(tree,string_to_insert);
  }
  fclose(fp);
  return 1;
}
