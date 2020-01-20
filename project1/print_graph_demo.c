#include <stdio.h>

void print_graph(int *data, int len, int max_height);

int main(int argc, char *argv[]){
  printf("DEMO DATA 1\n");
  printf("===========\n");
  int data1[22] =
    {0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
     2,  4,  6,  8, 10, 12, 14, 16, 18, 20, 10,};
  int len1 = 22;
  print_graph(data1, len1, 10);
  printf("\n");

  printf("DEMO DATA 2\n");
  printf("===========\n");
  print_graph(data1, len1, 20);
  printf("\n");

  printf("DEMO DATA 3\n");
  printf("===========\n");
  int data2[50] = {
    13 , 397, 813, 745, 154, 473, 212, 939, 593, 849, 247, 453, 662, 806,
    478, 390, 996, 792, 929, 372, 603, 577, 146, 801, 276, 328, 422, 481,
    438, 126, 701, 988, 555, 376, 674, 781, 795, 780, 415, 521, 581, 412,
    701, 617, 367, 258, 704, 192, 869, 791,
  };
  int len2 = 50;
  print_graph(data2, len2, 10);
  printf("\n");

  printf("DEMO DATA 4\n");
  printf("===========\n");
  print_graph(data2, len2, 18);
  printf("\n");

  return 0;
}
