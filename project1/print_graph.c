#include <stdio.h>
void print_graph(int *data, int len, int max_height){
  int min;
  int max;
  int range;
  double units_per_height;

  // Simple loop to determine max and min
  for (int i = 0; i < len; i++){
    // starts with first value as max and min
    if (i == 0){
      min = data[i];
      max = data[i];
      continue;
    }
    //Update max
    if (data[i] > max){
      max = data[i];
    }
    // Update min
    else if (data[i] < min){
      min = data[i];
    }
  }
  // Calculations for other stats
  range = max - min;
  units_per_height = ((double)range/(double)max_height);

  printf("length: %d",len);
  printf("\nmin: %d", min);
  printf("\nmax: %d", max);
  printf("\nrange: %d", range);
  printf("\nmax_height: %d", max_height);
  printf("\nunits_per_height: %.2lf", units_per_height);

  // Formatting top bar
  printf("\n     ");
  for(int i = 0; i < len; i++){
    if (i % 5 == 0){
      printf("+");
    }
    else{
      printf("-");
    }
  }
  printf("\n");


  // Formatting and data printing middle section
  for (int i = max_height; i >= 0; i--){
    int cut_off = (int) (min + i * units_per_height);
    printf("%3d |",cut_off);
    for (int i = 0; i < len; i++){
      if (data[i] >= cut_off){
        printf("X");
      }
      else{
        printf(" ");
      }
    }
    printf("\n");
  }
  printf("     ");

  // Formatting bottom bar
  for(int i = 0; i < len; i++){
    if (i % 5 == 0){
      printf("+");
    }
    else{
      printf("-");
    }
  }
  printf("\n     ");
  // Print the array indeces under the bottom bar in steps of 5.
  for(int i = 0; i < len; i++){
    if (i % 5 == 0){
      printf("%-5d",i);
    }
  }
}
