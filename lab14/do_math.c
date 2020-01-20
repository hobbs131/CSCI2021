// Demo program using math operations, requires linking to math
// library
#include <stdio.h>
#include <math.h>
#include <unistd.h>

int main(int argc, char *argv[]){
  double e = M_E;
  double cos_e = cos(e);
  double sin_e = sin(e);
  double e_squared = pow(e,2.0);

  printf("E is %.3f\n",e);
  printf("cos(E) is %.3f\n",cos_e);
  printf("sin(E) is %.3f\n",sin_e);
  printf("E^2 is %.3f\n",e_squared);

  printf("program pid is %d\n",getpid());
  printf("press any key to continue\n");
  getchar();

  return 0;
}
