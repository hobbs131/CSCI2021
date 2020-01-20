#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

int *read_text_deltas(char *fname, int *len){
  int n;
  *len = 0;
  FILE *fp = fopen(fname,"r");

  // Error conditionals
  if (fp == NULL){
    printf("\nError: file could not be opened ");
    *len = -1;
    return NULL;
  }

  if(fscanf(fp,"%d",&n) == EOF){
    printf("\nError: no integers in file ");
    *len = -1;
    fclose(fp);
    return NULL;
  }
  rewind(fp);

  // Loop to determine the amount of integers in the file
  while (fscanf(fp,"%d",&n) != EOF){
    (*len)++;
  }
  int *int_array = malloc(*len*sizeof(int));
  int current_index = 0;
  rewind(fp);
  // loop to store delta values
  while (fscanf(fp,"%d",&n) != EOF){
    // Accounts for first value in the array (not a delta value)
    if (current_index == 0){
      int_array[current_index] = n;
      current_index++;
      continue;
    }
    // Delta value calculation to change value in int_array
    int_array[current_index] = int_array[current_index - 1] + n;
    current_index++;
  }
  fclose(fp);
  return int_array;
}
int *read_int_deltas(char *fname, int *len){
  FILE *fp = fopen(fname,"r");

  // File error conditional
  if (fp == NULL){
    printf("\nError: file could not be opened ");
    *len = -1;
    return NULL;
  }
  // struct for obtaining file information
  struct stat sb;
  int result = stat(fname, &sb);

  // Checks to see if any ints exist in the file
  if(result == -1 || sb.st_size < sizeof(int)){
    *len = -1;
    printf("Error: no integers in file");
    fclose(fp);
    return NULL;
  }
  // Array allocation
  int total_bytes = sb.st_size;
  int array_size = (int) (total_bytes / 4);
  int *int_array = (int*)malloc(array_size*sizeof(int));
  (*len) = array_size;
  int current_index = 0;


  while(current_index < array_size){

    //Accounts for first value
    if(current_index == 0){
      fread(&int_array[current_index], sizeof(int),1,fp);
      current_index++;
      continue;
    }
    // Stores and does delta value calculations
    fread(&int_array[current_index], sizeof(int),1,fp);
    int_array[current_index] = int_array[current_index - 1] + int_array[current_index];
    current_index++;
  }
  fclose(fp);
  return int_array;
}
