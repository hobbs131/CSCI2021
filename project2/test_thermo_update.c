#include <string.h>
#include <math.h>
#include <stdio.h>
#include <limits.h>
#include <stdlib.h>
#include "thermo.h"

// Struct to hold test information
typedef struct {
  char *id;
  int ret;
  unsigned short thermo_sensor;
  unsigned char  thermo_status;
  int thermo_display;
  temp_t temp;
  int expect_display;
} temp_test_case;

int passed = 0;
int testn = 0;

#define TOLERANCE 1e-4

int compare_temp_t(temp_t x, temp_t y){
  return
    x.tenths_degrees == y.tenths_degrees &&
    x.is_fahrenheit  == y.is_fahrenheit;
}

void print_temp_t(temp_t temp){
  printf("{\n"); 
  printf("  .tenths_degrees = %d,\n",temp.tenths_degrees);
  printf("  .is_fahrenheit  = %d,\n",temp.is_fahrenheit);
  printf("}\n");
}

void print_test_description(char *function, char *id){
  printf("TEST %2d: %-30s %-16s : ",testn,function,id);
}

void test_set_temp_from_ports(temp_test_case test){
  testn++;
  print_test_description("set_temp_from_sensors()",test.id);
  temp_t expect = test.temp;
  int expect_ret = test.ret;
  
  THERMO_SENSOR_PORT  = test.thermo_sensor;
  THERMO_STATUS_PORT  = test.thermo_status;
  THERMO_DISPLAY_PORT = -1;

  temp_t actual = {};            // all 0s
  int actual_ret = set_temp_from_ports(&actual);

  if(   THERMO_SENSOR_PORT  != test.thermo_sensor
     || THERMO_STATUS_PORT  != test.thermo_status
     || THERMO_DISPLAY_PORT != -1)
  {
    printf("FAILED\n");
    printf("----------------------------------------------------------------\n");
    printf("Do not modify global variables, THERMO_SENSOR_PORT, THERMO_STATUS_PORT, THERMO_DISPLAY_PORT\n");
    printf("----------------------------------------------------------------\n");
    return;
  }
  else if( !compare_temp_t(actual,expect) || actual_ret!=expect_ret){
    printf("FAILED\n");
    printf("----------------------------------------------------------------\n");
    printf("Actual and Expected temp_t differ or return value wrong\n");
    printf("THERMO_SENSOR_PORT: %d\n",THERMO_SENSOR_PORT);
    printf("THERMO_STATUS_PORT: %d\n",THERMO_STATUS_PORT);
    printf("EXPECT: "); print_temp_t(expect);
    printf("ACTUAL: "); print_temp_t(actual);
    printf("EXPECT return %d\n",expect_ret);
    printf("ACTUAL return %d\n",actual_ret);
    printf("----------------------------------------------------------------\n");
    return;
  }
  passed++;
  printf("ok\n");
}    

void test_set_display_from_temp(temp_test_case test){
  temp_t temp = test.temp;
  testn++;
  print_test_description("set_display_from_temp()",test.id);
  THERMO_SENSOR_PORT  =  0;
  THERMO_STATUS_PORT  =  0;
  THERMO_DISPLAY_PORT = -1;

  int actual = test.thermo_display;
  int actual_ret = set_display_from_temp(temp, &actual);

  // printf("%hd %hhd %d\n",THERMO_SENSOR_PORT,THERMO_STATUS_PORT,THERMO_DISPLAY_PORT);
  if(   (int) THERMO_SENSOR_PORT  !=  0
     || (int) THERMO_STATUS_PORT  !=  0
     || (int) THERMO_DISPLAY_PORT != -1)
  {
    printf("FAILED\n");
    printf("----------------------------------------------------------------\n");
    printf("Do not modify global variables, THERMO_SENSOR_PORT, THERMO_STATUS_PORT, THERMO_DISPLAY_PORT\n");
    printf("----------------------------------------------------------------\n");
    return;
  }
  else if(actual != test.expect_display || actual_ret!=test.ret){
    printf("FAILED\n");
    printf("----------------------------------------------------------------\n");
    printf("Actual and Expected bits differ\n");
    printf("temp = \n"); print_temp_t(temp);
    printf("index:   3         2         1    0    0\n");
    printf("index:  10987654321098765432109876543210\n");
    printf("EXPECT: "); showbits(test.expect_display); printf("\n");
    printf("ACTUAL: "); showbits(actual); printf("\n");
    printf("guide:   |    |    |    |    |    |    |\n");
    printf("index:   30        20        10        0\n");
    printf("\n");
    printf("EXPECT return %d\n",test.ret);
    printf("ACTUAL return %d\n",actual_ret);
    printf("----------------------------------------------------------------\n");
    return;
  }
  passed++;
  printf("OK\n");
}

void test_thermo_update(temp_test_case test){
  testn++;
  print_test_description("thermo_update()",test.id);
  THERMO_SENSOR_PORT  = test.thermo_sensor;
  THERMO_STATUS_PORT  = test.thermo_status;
  THERMO_DISPLAY_PORT = test.thermo_display;
  int expect_ret  = test.ret;
  int actual_ret = thermo_update();
  if(   THERMO_DISPLAY_PORT != test.expect_display
     || THERMO_STATUS_PORT  != test.thermo_status 
     || THERMO_SENSOR_PORT  != test.thermo_sensor 
     || actual_ret          != test.ret)
  {
    printf("FAILED\n");
    printf("----------------------------------------------------------------\n");
    printf("Expect THERMO_SENSOR_PORT: %d\n",test.thermo_sensor);
    printf("Actual THERMO_SENSOR_PORT: %d\n",THERMO_SENSOR_PORT);
    printf("Expect THERMO_STATUS_PORT: %d\n",test.thermo_status);
    printf("Actual THERMO_STATUS_PORT: %d\n",THERMO_STATUS_PORT);
    printf("Bits of THERMO_DISPLAY_PORT\n");
    printf("index:   3         2         1    0    0\n");
    printf("index:  10987654321098765432109876543210\n");
    printf("EXPECT: "); showbits(test.expect_display); printf("\n");
    printf("ACTUAL: "); showbits(THERMO_DISPLAY_PORT); printf("\n");
    printf("guide:   |    |    |    |    |    |    |\n");
    printf("index:   30        20        10        0\n");
    printf("\n");
    printf("EXPECT return %d\n",expect_ret);
    printf("ACTUAL return %d\n",actual_ret);
    printf("----------------------------------------------------------------\n");
    return;
  }
  passed++;
  printf("OK\n");
  return;
}


// Global array of test data; terminated by a struct with .id=NULL 
temp_test_case tests[] = {

  { .id = "zero-c",
    .ret = 0,
    .thermo_sensor = 0,
    .thermo_status = 0,
    .thermo_display = -1,
    .temp = {
      .tenths_degrees = -500,
      .is_fahrenheit  = 0,
    },
    .expect_display=0b00011000000110110101111110111111,
  },

  { .id = "zero-f",
    .ret = 0,
    .thermo_sensor = 0,
    .thermo_status = 1,
    .thermo_display = -1,
    .temp = {
      .tenths_degrees = -580,
      .is_fahrenheit  = 1,
    },
    .expect_display=0b00101000000110110111111110111111,
  },

  { .id = "64-c",
    .ret = 0,
    .thermo_sensor = 64,
    .thermo_status = 0,
    .thermo_display = -1,
    .temp = {
      .tenths_degrees = -499,
      .is_fahrenheit  = 0,
    },
    .expect_display=0b00011000000110011011011111101111,
  },

  { .id = "120-c",
    .ret = 0,
    .thermo_sensor = 120,
    .thermo_status = 0,
    .thermo_display = -1,
    .temp = {
      .tenths_degrees = -498,
      .is_fahrenheit  = 0,
    },
    .expect_display=0b00011000000110011011011111111111,
  },


  { .id = "32000-c",
    .ret = 0,
    .thermo_sensor = 32000,
    .thermo_status = 0,
    .thermo_display = -1,
    .temp = {
      .tenths_degrees = 0,
      .is_fahrenheit  = 0,
    },
    .expect_display=0b00010000000000000001111110111111,
  },

  { .id = "32000-f",
    .ret = 0,
    .thermo_sensor = 32000,
    .thermo_status = 1,
    .thermo_display = -1,
    .temp = {
      .tenths_degrees = 320,
      .is_fahrenheit  = 1,
    },
    .expect_display=0b00100000000100111110110110111111,
  },

  { .id = "18000-f",
    .ret = 0,
    .thermo_sensor = 18000,
    .thermo_status = 1,
    .thermo_display = -1,
    .temp = {
      .tenths_degrees = -74,
      .is_fahrenheit  = 1,
    },
    .expect_display=0b00100000000100000000001111100110,
  },


  { .id = "18105-c",
    .ret = 0,
    .thermo_sensor = 18105,
    .thermo_status = 0,
    .thermo_display = -1,
    .temp = {
      .tenths_degrees = -217,
      .is_fahrenheit  = 0,
    },
    .expect_display=0b00011000000101101100001100000111,
  },


  // { .id = "64000-c",
  //   .ret = 0,
  //   .thermo_sensor = 64000,
  //   .thermo_status = 0,
  //   .thermo_display = -1,
  //   .temp = {
  //     .tenths_degrees = 500,
  //     .is_fahrenheit  = 0,
  //   },
  //   .expect_display=0b00010000000110110101111110111111,
  // },

  { .id = "64000-f",
    .ret = 0,
    .thermo_sensor = 64000,
    .thermo_status = 1,
    .thermo_display = -1,
    .temp = {
      .tenths_degrees = 1220,
      .is_fahrenheit  = 1,
    },
    .expect_display=0b00100000110101101110110110111111,
  },

  {.id = NULL }
};

// special tests for error conditions
void test_error_conditions(){

  temp_test_case err_fahr_field = 
  { .id = "err-fahr-field",
    .ret = 1,
    .thermo_sensor = 0,
    .thermo_status = 0,
    .thermo_display = -1,
    .temp = {
      .tenths_degrees = 0,
      .is_fahrenheit  = 5,
    },
    .expect_display=-1,
  };
  test_set_display_from_temp(err_fahr_field);

  temp_test_case err_bad_temp = 
  { .id="err-big-temp",
    .ret = 1,
    .thermo_sensor = -1,
    .thermo_status = -1,
    .thermo_display = -1,
    .temp = {
      .tenths_degrees = -531,
      .is_fahrenheit  = 0,
    },
    .expect_display=-1,
  };
  test_set_display_from_temp(err_bad_temp);


  temp_test_case err_big_temp = 
  { .id="err-big-temp",
    .ret = 1,
    .thermo_sensor = 64500,
    .thermo_status = 0,
    .thermo_display = -1,
    .temp = {
      .tenths_degrees = 0,
      .is_fahrenheit  = 0,
    },
    .expect_display=-1,
  };
  test_thermo_update(err_big_temp);
}




int main(int argc, char **argv){
  printf("========================================\n");
  printf("PROBLEM 1A: test_thermo_update.c tests for themo_update.c\n");

  int i;

  // Run set_temp_from_ports() tests
  for(i=0; tests[i].id != NULL; i++){
    test_set_temp_from_ports(tests[i]);
  }
    
  // Run set_display_from_temp() tests
  for(i=0; tests[i].id != NULL; i++){
    test_set_display_from_temp(tests[i]);
  }

  // Run lcd_update() tests
  for(i=0; tests[i].id != NULL; i++){
    test_thermo_update(tests[i]);
  }

  test_error_conditions();

  printf("================================================================\n");
  printf("Passed: %d / %d tests with 0.5 points per test\n",passed,testn);
  double dpassed = 0.5 * passed;
  double dtestn  = 0.5 * testn;
  printf("RESULTS: %.1f / %.1f points\n",dpassed,dtestn);

  return 0;
}
