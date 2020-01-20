#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "deltas.h"

int QUIET = 0;                  // controls if verbose error output is subverted 

int NTESTS = 0;
int NPASS  = 0;

// Save a file in text delta format, based on code in save_deltas.c
void save_text_deltas(char *filename, int *data, int len){
  FILE *fout = fopen(filename,"w");
  if(fout == NULL){
    printf("failure to open output file %s\n",filename);
    exit(1);
  }
  fprintf(fout,"%5d\n",data[0]);        // write initial value
  int total = data[0];
  for(int i=1; i<len; i++){
    fprintf(fout,"%d\n",data[i]-total); // write delta
    total = data[i];
  }
  fclose(fout);
}

// Save a file in binary int delta format, based on code in save_deltas.c
void save_int_deltas(char *filename, int *data, int len){
  FILE *fout = fopen(filename,"w");
  if(fout == NULL){
    printf("failure to open output file %s\n",filename);
    exit(1);
  }
  int total = data[0];
  fwrite(&total,sizeof(int),1,fout);           // write initial value
  for(int i=1; i<len; i++){
    int delta = data[i]-total;
    fwrite(&delta,sizeof(int),1,fout);         // write delta
    total = data[i];
  }
  fclose(fout);
}

// Not yet implemented
void save_4bit_deltas(char *filename, int *data, int len){
  printf("Not implemented: use save_deltas.c for testing\n");
  exit(1);
}

#define MODE_TEXT  1
#define MODE_INT   2
#define MODE_4BIT  3

// Write a test data file the call read_text_deltas() to see if it
// works properly
void check_deltas(char *testname, int format,
                  int *expect_data, int expect_len)
{
  NTESTS++;
  char out_fname[512];
  int actual_len = -10;
  int *actual_data = NULL;

  if(format == MODE_TEXT){
    sprintf(out_fname,"test-data/%s_datafile.txt",testname);
    save_text_deltas(out_fname, expect_data, expect_len);
    actual_data = read_text_deltas(out_fname, &actual_len);
  }
  else if(format == MODE_INT){
    sprintf(out_fname,"test-data/%s_datafile.int",testname);
    save_int_deltas(out_fname, expect_data, expect_len);
    actual_data = read_int_deltas(out_fname, &actual_len);
  }
  // COMMENT this block if not implementing the optional 4bit function
  // else if(format == MODE_4BIT){
  //   printf("Not implemented: use save_deltas.c for testing\n");
  //   exit(1);
  // }
  else{
    printf("unknown format '%d'\n",format);
    exit(1);
  }

  if(actual_len != expect_len){
    printf("FAIL\n");
    if(!QUIET){
      printf("----------------------------------------\n");
      printf("Unexpected length:\n");
      printf("EXPECT LENGTH: %d\n",expect_len);
      printf("ACTUAL LENGTH: %d\n",actual_len);
      printf("----------------------------------------\n");
    }
    return;                                    // failure
  }
  int mismatch = 0;
  int i;
  for(i=0; i<expect_len; i++){
    if(expect_data[i] != actual_data[i]){
      mismatch = 1;
      break;
    }
  }
  if(mismatch==1){
    printf("FAIL\n");
    if(!QUIET){
      printf("----------------------------------------\n");
      printf("Element at index %d is incorrect\n",i);
      printf("[%2s] %5s %5s\n","i","EXPECT","ACTUAL");
      for(int i=0; i<expect_len; i++){
        char *diff = "";
        if(expect_data[i] != actual_data[i]){
          diff = "***";
        }
        printf("[%2d] %5d %5d %s\n",
               i,expect_data[i],actual_data[i],diff);
      }
      printf("----------------------------------------\n");
    }
    return;
  }
  free(actual_data);
  printf("OK\n");
  NPASS++;
}


void check_empty_deltas(char *testname, int format, int create_empty){
  NTESTS++;
  char out_fname[512];
  int actual_len = -8;
  int *actual_data = NULL;

  sprintf(out_fname,"test-data/%s_datafile.empty",testname);
  if(create_empty){
    FILE *fout = fopen(out_fname,"w");           // create empty file
    fprintf(fout," ");                           // single space
    fclose(fout);
  }

  if(format == MODE_TEXT){
    actual_data = read_text_deltas(out_fname, &actual_len);
  }
  else if(format == MODE_INT){
    actual_data = read_int_deltas(out_fname, &actual_len);
  }
  // else if(format == MODE_4BIT){
  //   actual_data = read_4bit_deltas(out_fname, &actual_len);
  // }
  else{
    printf("unknown format '%d'\n",format);
    exit(1);
  }

  if(actual_data!=NULL || actual_len!=-1){
    printf("FAIL\n");
    if(!QUIET){
      printf("----------------------------------------\n");
      printf("Unexpected result for empty/non-existent file:\n");
      printf("EXPECT POINTER: (nil)\n");
      printf("ACTUAL POINTER: %p\n",actual_data);
      printf("EXPECT LENGTH: -1\n");
      printf("ACTUAL LENGTH: %d\n",actual_len);
      printf("----------------------------------------\n");
    }
    return;
  }
  printf("OK\n");
  NPASS++;
}

typedef struct{
  char name[128];
  int format;
  int len;
  int data[256];
} test_t;

#define EMPTY_FILE   -4
#define MISSING_FILE -8

int main(int argc, char *argv[]){
  if( argc>1 && strcmp(argv[1],"-quiet")==0){
    QUIET = 1;
  }

  printf("========================================\n");
  printf("#PROBLEM 1 read_deltas.c tests\n");
  //  printf("----------------------------------------\n");

  test_t tests[] = {
    {.name="text-5",       .format=MODE_TEXT, .len= 5, .data={1,2,3,4,5}},
    // {.name="text-10",      .format=MODE_TEXT, .len=10, .data={16, 17, 18, 0, 13, 5, 12, 8, 2, 4}},
    // {.name="text-32",      .format=MODE_TEXT, .len=32, .data={79, 43, 46, 74, 192, 172, 296, 275, 161, 163, 157, 137, 321, 48, 124, 233, 321, 226, 123, 86, 316, 197, 224, 161, 33, 300, 22, 298, 302, 69, 56, 105, }},
    {.name="text-128",     .format=MODE_TEXT, .len=32, .data={257, 278, 68, 12, 117, 109, 225, 36, 91, 1, 260, 101, 317, 302, 83, 313, 129, 77, 13, 55, 251, 177, 20, 90, 285, 176, 163, 64, 64, 318, 117, 282, 151, 125, 326, 304, 223, 184, 217, 199, 128, 283, 325, 138, 64, 44, 298, 34, 327, 156, 124, 14, 88, 326, 170, 43, 179, 130, 124, 111, 99, 39, 270, 135, 93, 80, 319, 152, 236, 256, 6, 274, 323, 83, 200, 283, 243, 276, 207, 254, 319, 264, 270, 276, 19, 9, 48, 33, 308, 56, 106, 20, 308, 322, 150, 102, 140, 9, 87, 306, 272, 153, 70, 85, 281, 37, 244, 80, 222, 317, 16, 14, 308, 147, 215, 136, 216, 208, 323, 96, 155, 206, 300, 237, 95, 100, 6, 145, }},
    {.name="text-one",     .format=MODE_TEXT, .len= 1, .data={43}},
    {.name="text-empty",   .format=MODE_TEXT, .len=EMPTY_FILE},
    {.name="text-missing", .format=MODE_TEXT, .len=MISSING_FILE},
    {.name="int-5",        .format=MODE_INT,  .len= 5, .data={1,2,3,4,5}},
    // {.name="int-10",       .format=MODE_INT, .len=10, .data={16, 17, 18, 0, 13, 5, 12, 8, 2, 4}},
    // {.name="int-32",       .format=MODE_INT, .len=32, .data={79, 43, 46, 74, 192, 172, 296, 275, 161, 163, 157, 137, 321, 48, 124, 233, 321, 226, 123, 86, 316, 197, 224, 161, 33, 300, 22, 298, 302, 69, 56, 105, }},
    {.name="int-128",      .format=MODE_INT, .len=32, .data={257, 278, 68, 12, 117, 109, 225, 36, 91, 1, 260, 101, 317, 302, 83, 313, 129, 77, 13, 55, 251, 177, 20, 90, 285, 176, 163, 64, 64, 318, 117, 282, 151, 125, 326, 304, 223, 184, 217, 199, 128, 283, 325, 138, 64, 44, 298, 34, 327, 156, 124, 14, 88, 326, 170, 43, 179, 130, 124, 111, 99, 39, 270, 135, 93, 80, 319, 152, 236, 256, 6, 274, 323, 83, 200, 283, 243, 276, 207, 254, 319, 264, 270, 276, 19, 9, 48, 33, 308, 56, 106, 20, 308, 322, 150, 102, 140, 9, 87, 306, 272, 153, 70, 85, 281, 37, 244, 80, 222, 317, 16, 14, 308, 147, 215, 136, 216, 208, 323, 96, 155, 206, 300, 237, 95, 100, 6, 145, }},
    {.name="int-one",      .format=MODE_INT, .len= 1, .data={43}},
    {.name="int-empty",    .format=MODE_INT, .len=EMPTY_FILE},
    {.name="int-missing",  .format=MODE_INT, .len=MISSING_FILE},

    {.name="", .len=-1}
  };
  
  for(int i=0; tests[i].len != -1; i++){
    test_t test = tests[i];
    char *format = "???";
    if(test.format == MODE_TEXT){
      format = "read_text_deltas()";
    }
    else if(test.format == MODE_INT){
      format = "read_int_deltas()";
    }
    else if(test.format == MODE_4BIT){
      format = "read_4bit_deltas()";
    }
    else{
      printf("WTF^M?\n");
      exit(1);
    }
    printf("#TEST %2d %12s : %20s  len=%3d : ",
           i+1,test.name,format,test.len);
    if(test.len == EMPTY_FILE){
      check_empty_deltas(test.name, test.format, 1);
    }
    else if(test.len == MISSING_FILE){
      check_empty_deltas(test.name, test.format, 0);
    }
    else{
      check_deltas(test.name, test.format,
                   test.data, test.len);
    }

  }
  printf("========================================\n");
  printf("#RESULTS: %d / %d tests passed\n",NPASS,NTESTS);
  return 0;
}
