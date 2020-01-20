#include <stdio.h>
#include "thermo.h"

int set_temp_from_ports(temp_t *temp){
  // Out of range
  if (THERMO_SENSOR_PORT > 64000 || THERMO_SENSOR_PORT < 0 || THERMO_STATUS_PORT > 1) {
    return 1;
  }
  int temp_in_tenths = (THERMO_SENSOR_PORT / 64) - 500;
  // Round up if remainder is between 31-63 and not zero.
  if(THERMO_SENSOR_PORT % 64 > 31 && THERMO_SENSOR_PORT % 64 != 0){
    temp_in_tenths += 1;
  }
  // Check for fahrenheit, if so, make conversion
  if(THERMO_STATUS_PORT == 1){
    temp_in_tenths = (temp_in_tenths * 9) / 5 + 320;
  }
  // Set parameters for temp
  temp -> tenths_degrees = temp_in_tenths;
  temp -> is_fahrenheit = THERMO_STATUS_PORT;
  return 0;
}

int digit_mask_arr[10] = {0b0111111, 0b0000110, 0b1011011, 0b1001111,
                          0b1100110,0b1101101,0b1111101,0b0000111,0b1111111,0b1101111};
#define C_POSITION (0x1 << 28)
#define F_POSITION (0x1 << 29)
#define NEG 0b1000000

int set_display_from_temp(temp_t temp, int *display){
  //Incorrect value for is_fahrenheit (can only be 0 or 1)
  if (temp.is_fahrenheit != 0 && temp.is_fahrenheit != 1){
    return 1;
  }
  // Out of bounds temp for fahrenheit
  if(temp.is_fahrenheit == 1){
    if (temp.tenths_degrees < -1220 || temp.tenths_degrees > 1220){
      return 1;
    }
  }
  // Out of bounds temp for celsius
  else if (temp.is_fahrenheit == 0){
    if(temp.tenths_degrees < -500 || temp.tenths_degrees > 500){
      return 1;
    }
  }
  int total_tenths = temp.tenths_degrees;
  int temp_display = 0;

  // Checks for negative temp, adds neg sign,shifts, and flips sign
  // On total_tenths so that each individual digit is positive
  if (temp.tenths_degrees < 0){
    temp_display|= NEG;
    temp_display = temp_display << 7;
    total_tenths = total_tenths * -1;
  }
  // Digit calculations
  int temp_tenths = total_tenths % 10;
  total_tenths = total_tenths / 10;
  int temp_ones = total_tenths % 10;
  total_tenths = total_tenths / 10;
  int temp_tens = total_tenths % 10;
  total_tenths = total_tenths / 10;
  int temp_hundreds = total_tenths % 10;


  // Check for valid hundreds place, if so, index digit_mask_arr to find value of hundreds place
  // Then shift
  if (temp_hundreds != 0){
    temp_display |= digit_mask_arr[temp_hundreds];
    temp_display = temp_display << 7;
  }
  // Check for valid tens place, if so, index digit_mark_arr to find value of tens
  // place then shift
  if(temp_hundreds != 0 || temp_tens != 0){
    temp_display |= digit_mask_arr[temp_tens];
    temp_display = temp_display << 7;
  }
  // Ones place set and shifted, tenths place set, no shift
  temp_display |= digit_mask_arr[temp_ones];
  temp_display = temp_display << 7;
  temp_display |= digit_mask_arr[temp_tenths];

  // Check for C or F and set.
  if(temp.is_fahrenheit){
    temp_display |= F_POSITION;
  }
  else{
    temp_display |= C_POSITION;
  }
  *display = temp_display;
  return 0;
}
int thermo_update(){
  temp_t temp = {};
  int error_check = set_temp_from_ports(&temp);

  // erorr encountered from set_temp_from_ports
  if (error_check == 1){
    return 1;
  }
  int display = 0;
  error_check = set_display_from_temp(temp,&display);

  // error encountered in set_display_from_temp
  if (error_check != 0){
    return 1;
  }
  THERMO_DISPLAY_PORT = display;
  return 0;
}
