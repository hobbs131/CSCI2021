int main(int argc, char *argv[]){
  int[] arr = {1,2,3,4,5,6,7,8,9,10};
  int size = sizeof(arr);
  printf("%d", size);
  reverse_arr1(arr,size);
  reverse_arr2(arr,size);
  return 1;
}
