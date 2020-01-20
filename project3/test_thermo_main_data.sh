#!/bin/bash
T=0                             # global test number


((T++))
tnames[T]="64000-c"
input[T]="64000 c"
read  -r -d '' output[$T] <<"ENDOUT"
THERMO_SENSOR_PORT set to: 64000
set_temp_from_sensors(&temp );
temp is {
  .tenths_degrees = 500
  .is_fahrenheit  = 0
}
Simulated temp is: 50.0 deg C

Checking results for display bits
set_display_from_temp(temp, &display);

display is:
        3         2         1         0
index: 10987654321098765432109876543210
bits:  00010000000110110101111110111111
guide:  |    |    |    |    |    |    |
index:  30        20        10        0

Running thermo_update()

THERMO_DISPLAY_PORT is:
index:  3         2         1    0    0
index: 10987654321098765432109876543210
bits:  00010000000110110101111110111111
guide:  |    |    |    |    |    |    |
index:  30        20        10        0

Thermometer Display:
         ~~   ~~   ~~  o       
        |    |  | |  |  C      
         ~~                    
           | |  | |  |         
         ~~   ~~ o ~~          
ENDOUT

((T++))
tnames[T]="32563-c"
input[T]="32563 c"
read  -r -d '' output[$T] <<"ENDOUT"
THERMO_SENSOR_PORT set to: 32563
set_temp_from_sensors(&temp );
temp is {
  .tenths_degrees = 9
  .is_fahrenheit  = 0
}
Simulated temp is: 0.9 deg C

Checking results for display bits
set_display_from_temp(temp, &display);

display is:
        3         2         1         0
index: 10987654321098765432109876543210
bits:  00010000000000000001111111101111
guide:  |    |    |    |    |    |    |
index:  30        20        10        0

Running thermo_update()

THERMO_DISPLAY_PORT is:
index:  3         2         1    0    0
index: 10987654321098765432109876543210
bits:  00010000000000000001111111101111
guide:  |    |    |    |    |    |    |
index:  30        20        10        0

Thermometer Display:
              ~~   ~~  o       
             |  | |  |  C      
                   ~~          
             |  |    |         
              ~~ o ~~          

ENDOUT

((T++))
tnames[T]="23000-f"
input[T]="23000 f"
read  -r -d '' output[$T] <<"ENDOUT"
THERMO_SENSOR_PORT set to: 23000
set_temp_from_sensors(&temp );
temp is {
  .tenths_degrees = 67
  .is_fahrenheit  = 1
}
Simulated temp is: 6.7 deg F

Checking results for display bits
set_display_from_temp(temp, &display);

display is:
        3         2         1         0
index: 10987654321098765432109876543210
bits:  00100000000000000011111010000111
guide:  |    |    |    |    |    |    |
index:  30        20        10        0

Running thermo_update()

THERMO_DISPLAY_PORT is:
index:  3         2         1    0    0
index: 10987654321098765432109876543210
bits:  00100000000000000011111010000111
guide:  |    |    |    |    |    |    |
index:  30        20        10        0

Thermometer Display:
              ~~   ~~          
             |       |         
              ~~       o       
             |  |    |  F      
              ~~ o             

ENDOUT


((T++))
tnames[T]="31800-c"
input[T]="31800 c"
read  -r -d '' output[$T] <<"ENDOUT"
THERMO_SENSOR_PORT set to: 31800
set_temp_from_sensors(&temp );
temp is {
  .tenths_degrees = -3
  .is_fahrenheit  = 0
}
Simulated temp is: 0.3 deg C

Checking results for display bits
set_display_from_temp(temp, &display);

display is:
        3         2         1         0
index: 10987654321098765432109876543210
bits:  00010000000100000001111111001111
guide:  |    |    |    |    |    |    |
index:  30        20        10        0

Running thermo_update()

THERMO_DISPLAY_PORT is:
index:  3         2         1    0    0
index: 10987654321098765432109876543210
bits:  00010000000100000001111111001111
guide:  |    |    |    |    |    |    |
index:  30        20        10        0

Thermometer Display:
              ~~   ~~  o       
             |  |    |  C      
         ~~        ~~          
             |  |    |         
              ~~ o ~~          
ENDOUT


((T++))
tnames[T]="51697-c"
input[T]="51697 c"
read  -r -d '' output[$T] <<"ENDOUT"
THERMO_SENSOR_PORT set to: 51697
set_temp_from_sensors(&temp );
temp is {
  .tenths_degrees = 308
  .is_fahrenheit  = 0
}
Simulated temp is: 30.8 deg C

Checking results for display bits
set_display_from_temp(temp, &display);

display is:
        3         2         1         0
index: 10987654321098765432109876543210
bits:  00010000000100111101111111111111
guide:  |    |    |    |    |    |    |
index:  30        20        10        0

Running thermo_update()

THERMO_DISPLAY_PORT is:
index:  3         2         1    0    0
index: 10987654321098765432109876543210
bits:  00010000000100111101111111111111
guide:  |    |    |    |    |    |    |
index:  30        20        10        0

Thermometer Display:
         ~~   ~~   ~~  o       
           | |  | |  |  C      
         ~~        ~~          
           | |  | |  |         
         ~~   ~~ o ~~          

ENDOUT
