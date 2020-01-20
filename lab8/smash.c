#include <stdio.h>

void fill_seq(int *a);

int main(){
  int arr[4];

  fill_seq(arr);

  for(int i=0; i<4; i++){
    printf("[%d]: %d\n",i,arr[i]);
  }

  return 0;
}

#define END 8
void fill_seq(int *a){
  for(int i=0; i<END; i++){
    a[i] = (i+1)*2;
  }
}
    
