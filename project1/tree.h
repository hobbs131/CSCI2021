// Header for BST problem

#ifndef TREE_H
#define TREE_H 1

// Type of tree nodes
typedef struct node {
  char name[128];               // node data
  struct node *left;            // left branch,  NULL if not present
  struct node *right;           // right branch, NULL if not present
} node_t;

// Type of tree itself
typedef struct {
  node_t *root;                 // root of tree, NULL if tree empty
  int size;                     // number of nodes in tree
} bst_t;

// tree functions which will be tested in binary
void bst_init(bst_t *tree);
int bst_insert(bst_t *tree, char name[]);
int bst_find(bst_t *tree, char name[]);
void bst_clear(bst_t *tree);
// void bst_print_inorder(bst_t *tree);
void bst_print_revorder(bst_t *tree);
void bst_print_preorder(bst_t *tree);
void bst_save(bst_t *tree, char *fname);
int bst_load(bst_t *tree, char *fname);

// node functions, not tested but useful as helpers
node_t *node_insert(node_t *cur, char name[]);
int node_find(node_t *cur, char name[]);
void node_remove_all(node_t *cur);
// void node_print_inorder(node_t *cur);
void node_print_revorder(node_t *cur, int indent);
void node_write_preorder(node_t *cur, FILE *out, int depth);

#endif
