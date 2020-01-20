
#include <stdio.h>
#include <string.h>
#include "tree.h"

// Code heavily influenced from list_main.c in lab 2.
int main(int argc, char *argv[]){
  // Echo: function influenced by A1 instructions
  int echo = 0;
  if(argc > 1 && strcmp("-echo",argv[1])==0) {
    echo=1;
  }
  // Available commands that are printed to the screen.
  printf("BST Demo\n");
  printf("Commands:\n");
  printf("  print:          shows contents of the tree in reverse sorted order\n");
  printf("  clear:          eliminates all elements from the tree\n");
  printf("  quit:           exit the program\n");
  printf("  add <name>:     inserts the given string into the tree, duplicates ignored\n");
  printf("  find <name>:    prints FOUND if the name is in the tree, NOT FOUND otherwise\n");
  printf("  preorder:       prints contents of the tree in pre-order which is how it will be saved\n");
  printf("  save <file>:    writes the contents of the tree in pre-order to the given file\n");
  printf("  load <file>:    clears the current tree and loads the one in the given file\n");

  // Initialization for cmd line argument and tree
  char cmd[128];
  bst_t tree;
  int success;
  bst_init(&tree);

  // Continues until quit command
  while(1){
    printf("BST> ");
    success = fscanf(stdin,"%s",cmd);
    if(success==EOF){
      printf("\n");
      break;
    }
    // Conditionals for each command
    // Quit
    if(strcmp("quit", cmd)==0 ){
      // Echo loop checks at the beginning of each command
      if(echo){
        printf("quit\n");
      }
      break;
    }
    //Add
    else if( strcmp("add", cmd)==0 ){
      fscanf(stdin,"%s",cmd);
      if(echo){
        printf("add %s\n",cmd);
      }
      // Success variable indicates whether the insert was successful (0 on failure)
      success = bst_insert(&tree, cmd);
      if(!success){
        printf("insert failed\n");
      }
    }
    // Find
    else if( strcmp("find", cmd)==0 ){
      fscanf(stdin,"%s",cmd);

      if(echo){
        printf("find %s\n",cmd);
      }
      // Success variable indicates whether item is found (1 for success)
      success = bst_find(&tree,cmd);

      if(success){
        printf("FOUND\n");
      }
      else{
        printf("NOT FOUND\n");
      }
    }
    // Clear
    else if( strcmp("clear", cmd)==0 ){
      if(echo){
        printf("clear\n");
      }
      bst_clear(&tree);
    }
    // Print
    else if( strcmp("print", cmd)==0 ){
      if(echo){
        printf("print\n");
      }
      bst_print_revorder(&tree);
    }
    // Preorder
    else if(strcmp("preorder",cmd) == 0){
      if(echo){
        printf("preorder\n");
      }
      bst_print_preorder(&tree);
    }
    // Save
    else if(strcmp("save",cmd) == 0){

      fscanf(stdin,"%s", cmd);

      if(echo){
        printf("save %s\n",cmd);
      }
      bst_save(&tree, cmd);
    }
    // Load
    else if(strcmp("load",cmd) == 0){

      fscanf(stdin,"%s",cmd);

      if(echo){
        printf("load %s\n",cmd);
      }
      bst_load(&tree, cmd);
    }
    // Unknown command
    else{
      if(echo){
        printf("%s\n",cmd);
      }
      printf("Unknown command '%s'\n",cmd);
    }
  }
  // Clear the tree up and free memory allocated by doing so
  bst_clear(&tree);
  return 0;
}
