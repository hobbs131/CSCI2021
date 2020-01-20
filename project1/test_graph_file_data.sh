#!/bin/bash
T=0                             # global test number


((T++))
tnames[T]="text-ten-5"
format[T]="text"
height[T]="5"
read  -r -d '' input[$T] <<"ENDIN"
0 1 2 3 4 5 6 7 8 9 10
ENDIN
#
read  -r -d '' output[$T] <<"ENDOUT"
Reading text format
length: 11
min: 0
max: 10
range: 10
max_height: 5
units_per_height: 2.00
     +----+----+
 10 |          X
  8 |        XXX
  6 |      XXXXX
  4 |    XXXXXXX
  2 |  XXXXXXXXX
  0 |XXXXXXXXXXX
     +----+----+
     0    5    10   
ENDOUT

((T++))
tnames[T]="text-ten-20"
format[T]="text"
height[T]="20"
read  -r -d '' input[$T] <<"ENDIN"
0 1 2 3 4 5 6 7 8 9 10
ENDIN
#
read  -r -d '' output[$T] <<"ENDOUT"
Reading text format
length: 11
min: 0
max: 10
range: 10
max_height: 20
units_per_height: 0.50
     +----+----+
 10 |          X
  9 |         XX
  9 |         XX
  8 |        XXX
  8 |        XXX
  7 |       XXXX
  7 |       XXXX
  6 |      XXXXX
  6 |      XXXXX
  5 |     XXXXXX
  5 |     XXXXXX
  4 |    XXXXXXX
  4 |    XXXXXXX
  3 |   XXXXXXXX
  3 |   XXXXXXXX
  2 |  XXXXXXXXX
  2 |  XXXXXXXXX
  1 | XXXXXXXXXX
  1 | XXXXXXXXXX
  0 |XXXXXXXXXXX
  0 |XXXXXXXXXXX
     +----+----+
     0    5    10   
ENDOUT

((T++))
tnames[T]="text-21-5"
format[T]="text"
height[T]="5"
read  -r -d '' input[$T] <<"ENDIN"
20 18 14 10 7 2 3 1 5 9 5 7 7 5 5 5 7 8 3 7 4
ENDIN
#
read  -r -d '' output[$T] <<"ENDOUT"
Reading text format
length: 21
min: 1
max: 20
range: 19
max_height: 5
units_per_height: 3.80
     +----+----+----+----+
 20 |X                    
 16 |XX                   
 12 |XXX                  
  8 |XXXX     X       X   
  4 |XXXXX   XXXXXXXXXX XX
  1 |XXXXXXXXXXXXXXXXXXXXX
     +----+----+----+----+
     0    5    10   15   20   
ENDOUT

((T++))
tnames[T]="text-21-12"
format[T]="text"
height[T]="12"
read  -r -d '' input[$T] <<"ENDIN"
20 18 14 10 7 2 3 1 5 9 5 7 7 5 5 5 7 8 3 7 4
ENDIN
#
read  -r -d '' output[$T] <<"ENDOUT"
Reading text format
length: 21
min: 1
max: 20
range: 19
max_height: 12
units_per_height: 1.58
     +----+----+----+----+
 20 |X                    
 18 |XX                   
 16 |XX                   
 15 |XX                   
 13 |XXX                  
 12 |XXX                  
 10 |XXXX                 
  8 |XXXX     X       X   
  7 |XXXXX    X XX   XX X 
  5 |XXXXX   XXXXXXXXXX X 
  4 |XXXXX   XXXXXXXXXX XX
  2 |XXXXXXX XXXXXXXXXXXXX
  1 |XXXXXXXXXXXXXXXXXXXXX
     +----+----+----+----+
     0    5    10   15   20   
ENDOUT


((T++))
tnames[T]="int-21-7"
format[T]="int"
height[T]="7"
read  -r -d '' input[$T] <<"ENDIN"
20 18 14 10 7 2 3 1 5 9 5 7 7 5 5 5 7 8 3 7 4
ENDIN
#
read  -r -d '' output[$T] <<"ENDOUT"
Reading binary int format
length: 21
min: 1
max: 20
range: 19
max_height: 7
units_per_height: 2.71
     +----+----+----+----+
 20 |X                    
 17 |XX                   
 14 |XXX                  
 11 |XXX                  
  9 |XXXX     X           
  6 |XXXXX    X XX   XX X 
  3 |XXXXX X XXXXXXXXXXXXX
  1 |XXXXXXXXXXXXXXXXXXXXX
     +----+----+----+----+
     0    5    10   15   20   
ENDOUT


((T++))
tnames[T]="int-21-15"
format[T]="int"
height[T]="15"
read  -r -d '' input[$T] <<"ENDIN"
20 18 14 10 7 2 3 1 5 9 5 7 7 5 5 5 7 8 3 7 4
ENDIN
#
read  -r -d '' output[$T] <<"ENDOUT"
Reading binary int format
length: 21
min: 1
max: 20
range: 19
max_height: 15
units_per_height: 1.27
     +----+----+----+----+
 20 |X                    
 18 |XX                   
 17 |XX                   
 16 |XX                   
 14 |XXX                  
 13 |XXX                  
 12 |XXX                  
 11 |XXX                  
  9 |XXXX     X           
  8 |XXXX     X       X   
  7 |XXXXX    X XX   XX X 
  6 |XXXXX    X XX   XX X 
  4 |XXXXX   XXXXXXXXXX XX
  3 |XXXXX X XXXXXXXXXXXXX
  2 |XXXXXXX XXXXXXXXXXXXX
  1 |XXXXXXXXXXXXXXXXXXXXX
     +----+----+----+----+
     0    5    10   15   20   
ENDOUT

((T++))
tnames[T]="text-wave-8"
format[T]="text"
height[T]="8"
read  -r -d '' input[$T] <<"ENDIN"
0 2 4 6 8 10 11 13 14 16 17 18 19 19 20 20 20 20 19 19 18 17 16 15 14 12 10 9 7 5 3 1 -1 -3 -5 -7 -9 -11 -12 -14 -15 -16 -17 -18 -19 -20 -20 -20 -20 -20 -19 -19 -18 -17 -15 -14 -13 -11 -9 -7 -6 -4 -2 0 2 4 6 8 10 11 13 14 16 17 18 19 19 20 20 20 20 19 19 18 17 16 15 14 12 10 9 7 5 3 1 -1 -3 -5 -7 -9 -11 -12 -14 -15 -16 -17 -18 -19 -20 -20 -20 -20 -20 -19 -19 -18 -17 -15 -14 -13 -11 -9 -7 -6 -4 -2 0
ENDIN
#
read  -r -d '' output[$T] <<"ENDOUT"
Reading text format
length: 127
min: -20
max: 20
range: 40
max_height: 8
units_per_height: 5.00
     +----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+-
 20 |              XXXX                                                           XXXX                                              
 15 |         XXXXXXXXXXXXXXX                                                XXXXXXXXXXXXXXX                                        
 10 |     XXXXXXXXXXXXXXXXXXXXXX                                         XXXXXXXXXXXXXXXXXXXXXX                                     
  5 |   XXXXXXXXXXXXXXXXXXXXXXXXXXX                                    XXXXXXXXXXXXXXXXXXXXXXXXXXX                                  
  0 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                               X
 -5 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                          XXX
-10 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                     XXXXXX
-15 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX             XXXXXXXXXX
-20 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
     +----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+-
     0    5    10   15   20   25   30   35   40   45   50   55   60   65   70   75   80   85   90   95   100  105  110  115  120  125  
ENDOUT

((T++))
tnames[T]="int-wave-15"
format[T]="int"
height[T]="15"
read  -r -d '' input[$T] <<"ENDIN"
0 2 4 6 8 10 11 13 14 16 17 18 19 19 20 20 20 20 19 19 18 17 16 15 14 12 10 9 7 5 3 1 -1 -3 -5 -7 -9 -11 -12 -14 -15 -16 -17 -18 -19 -20 -20 -20 -20 -20 -19 -19 -18 -17 -15 -14 -13 -11 -9 -7 -6 -4 -2 0 2 4 6 8 10 11 13 14 16 17 18 19 19 20 20 20 20 19 19 18 17 16 15 14 12 10 9 7 5 3 1 -1 -3 -5 -7 -9 -11 -12 -14 -15 -16 -17 -18 -19 -20 -20 -20 -20 -20 -19 -19 -18 -17 -15 -14 -13 -11 -9 -7 -6 -4 -2 0
ENDIN
#
read  -r -d '' output[$T] <<"ENDOUT"
Reading binary int format
length: 127
min: -20
max: 20
range: 40
max_height: 15
units_per_height: 2.67
     +----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+-
 20 |              XXXX                                                           XXXX                                              
 17 |          XXXXXXXXXXXX                                                   XXXXXXXXXXXX                                          
 14 |        XXXXXXXXXXXXXXXXX                                              XXXXXXXXXXXXXXXXX                                       
 12 |       XXXXXXXXXXXXXXXXXXX                                            XXXXXXXXXXXXXXXXXXX                                      
  9 |     XXXXXXXXXXXXXXXXXXXXXXX                                        XXXXXXXXXXXXXXXXXXXXXXX                                    
  6 |   XXXXXXXXXXXXXXXXXXXXXXXXXX                                     XXXXXXXXXXXXXXXXXXXXXXXXXX                                   
  4 |  XXXXXXXXXXXXXXXXXXXXXXXXXXXX                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXX                                  
  1 | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                
 -1 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                              X
 -4 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                           XXX
 -6 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                         XXXX
 -9 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                     XXXXXX
-12 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                  XXXXXXX
-14 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX               XXXXXXXXX
-17 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          XXXXXXXXXXX
-20 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
     +----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+-
     0    5    10   15   20   25   30   35   40   45   50   55   60   65   70   75   80   85   90   95   100  105  110  115  120  125  
ENDOUT


((T++))
tnames[T]="text-rand-14"
format[T]="text"
height[T]="14"
read  -r -d '' input[$T] <<"ENDIN"
18 9 84 26 41 90 60 61 78 17 71 38 24 83 18 53 85 79 21 36 16 14 52 95 21 34 11 42 95 71 49 7 58 77 62 84 24 14 47 8 87 94 96 17 55 75 89 73 79 94 76 37 59 66 86 92 15 7 75 30 67 7 5 42 55 39 2 75 81 26 14 59 48 59 89 25 96 77 35 36 46 26 8 47 7 15 47 98 75 67 90 5 83 85 43 90 40 94 43 84 38 75 22 13 37 77 83 13 12 9 18 67 79 39 61 83 52 72 34 63 44 5 14 51 14 49 91 24 
ENDIN
#
read  -r -d '' output[$T] <<"ENDOUT"
Reading text format
length: 128
min: 2
max: 98
range: 96
max_height: 14
units_per_height: 6.86
     +----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+--
 98 |                                                                                       X                                        
 91 |                       X    X            XX      X     X                    X          X         X                            X 
 84 |  X  X          X      X    X      X    XXX   X  X    XX                  X X          X  X  X X X X                          X 
 77 |  X  X  X    X  XX     X    X    X X    XXX   X XX    XX            X     X XX         X  X XX X X X     XX     X  X          X 
 70 |  X  X  X X  X  XX     X    XX   X X    XXX  XXXXXX   XX  X        XX     X XX         XX X XX X X X X   XX     X  X X        X 
 63 |  X  X  X X  X  XX     X    XX   X X    XXX  XXXXXX  XXX  X X      XX     X XX         XXXX XX X X X X   XX    XX  X X X      X 
 56 |  X  XXXX X  X  XX     X    XX  XXXX    XXX  XXXXXX XXXX  X X      XX  X XX XX         XXXX XX X X X X   XX    XX XX X X      X 
 50 |  X  XXXX X  X XXX    XX    XX  XXXX    XXX XXXXXXX XXXX  X X   X  XX  X XX XX         XXXX XX X X X X   XX    XX XXXX X   X  X 
 43 |  X  XXXX X  X XXX    XX    XXX XXXX  X XXX XXXXXXX XXXX  X X   X  XX  XXXX XX  X  X  XXXXX XXXX XXX X   XX    XX XXXX XX  X XX 
 36 |  X XXXXX XX X XXX X  XX   XXXX XXXX  X XXX XXXXXXXXXXXX  X X  XXX XX  XXXX XX XX  X  XXXXX XXXXXXXXXX  XXX    XXXXXXX XX  X XX 
 29 |  X XXXXX XX X XXX X  XX X XXXX XXXX  X XXX XXXXXXXXXXXX  XXX  XXX XX  XXXX XXXXX  X  XXXXX XXXXXXXXXX  XXX    XXXXXXXXXX  X XX 
 22 |  XXXXXXX XXXX XXX X  XX X XXXX XXXXX X XXX XXXXXXXXXXXX  XXX  XXX XXX XXXXXXXXXXX X  XXXXX XXXXXXXXXXX XXX    XXXXXXXXXX  X XXX
 15 |X XXXXXXXXXXXXXXXXXXX XXXX XXXX XXXXX X XXXXXXXXXXXXXXXXX XXX  XXX XXX XXXXXXXXXXX X XXXXXX XXXXXXXXXXX XXX   XXXXXXXXXXX  X XXX
  8 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX XXX  XXX XXXXXXXXXXXXXXXXX XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXX
  2 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
     +----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+--
     0    5    10   15   20   25   30   35   40   45   50   55   60   65   70   75   80   85   90   95   100  105  110  115  120  125  
ENDOUT

((T++))
tnames[T]="int-rand-32"
format[T]="text"
height[T]="32"
read  -r -d '' input[$T] <<"ENDIN"
18 9 84 26 41 90 60 61 78 17 71 38 24 83 18 53 85 79 21 36 16 14 52 95 21 34 11 42 95 71 49 7 58 77 62 84 24 14 47 8 87 94 96 17 55 75 89 73 79 94 76 37 59 66 86 92 15 7 75 30 67 7 5 42 55 39 2 75 81 26 14 59 48 59 89 25 96 77 35 36 46 26 8 47 7 15 47 98 75 67 90 5 83 85 43 90 40 94 43 84 38 75 22 13 37 77 83 13 12 9 18 67 79 39 61 83 52 72 34 63 44 5 14 51 14 49 91 24 
ENDIN
#
read  -r -d '' output[$T] <<"ENDOUT"
Reading text format
length: 128
min: 2
max: 98
range: 96
max_height: 32
units_per_height: 3.00
     +----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+--
 98 |                                                                                       X                                        
 95 |                       X    X             X                                 X          X                                        
 92 |                       X    X            XX      X     X                    X          X         X                              
 89 |     X                 X    X            XX   X  X     X                  X X          X  X    X X                            X 
 86 |     X                 X    X           XXX   X  X    XX                  X X          X  X    X X                            X 
 83 |  X  X       X  X      X    X      X    XXX   X  X    XX                  X X          X  X XX X X X      X        X          X 
 80 |  X  X       X  X      X    X      X    XXX   X  X    XX            X     X X          X  X XX X X X      X        X          X 
 77 |  X  X  X    X  XX     X    X    X X    XXX   X XX    XX            X     X XX         X  X XX X X X     XX     X  X          X 
 74 |  X  X  X    X  XX     X    X    X X    XXX  XX XXX   XX  X        XX     X XX         XX X XX X X X X   XX     X  X          X 
 71 |  X  X  X X  X  XX     X    XX   X X    XXX  XXXXXX   XX  X        XX     X XX         XX X XX X X X X   XX     X  X X        X 
 68 |  X  X  X X  X  XX     X    XX   X X    XXX  XXXXXX   XX  X        XX     X XX         XX X XX X X X X   XX     X  X X        X 
 65 |  X  X  X X  X  XX     X    XX   X X    XXX  XXXXXX  XXX  X X      XX     X XX         XXXX XX X X X X   XX    XX  X X        X 
 62 |  X  X  X X  X  XX     X    XX   XXX    XXX  XXXXXX  XXX  X X      XX     X XX         XXXX XX X X X X   XX    XX  X X X      X 
 59 |  X  XXXX X  X  XX     X    XX   XXX    XXX  XXXXXX XXXX  X X      XX  X XX XX         XXXX XX X X X X   XX    XX XX X X      X 
 56 |  X  XXXX X  X  XX     X    XX  XXXX    XXX  XXXXXX XXXX  X X      XX  X XX XX         XXXX XX X X X X   XX    XX XX X X      X 
 53 |  X  XXXX X  X XXX     X    XX  XXXX    XXX XXXXXXX XXXX  X X   X  XX  X XX XX         XXXX XX X X X X   XX    XX XX X X      X 
 50 |  X  XXXX X  X XXX    XX    XX  XXXX    XXX XXXXXXX XXXX  X X   X  XX  X XX XX         XXXX XX X X X X   XX    XX XXXX X   X  X 
 47 |  X  XXXX X  X XXX    XX    XXX XXXX  X XXX XXXXXXX XXXX  X X   X  XX  XXXX XX     X  XXXXX XX X X X X   XX    XX XXXX X   X XX 
 44 |  X  XXXX X  X XXX    XX    XXX XXXX  X XXX XXXXXXX XXXX  X X   X  XX  XXXX XX  X  X  XXXXX XX X X X X   XX    XX XXXX XX  X XX 
 41 |  X XXXXX X  X XXX    XX   XXXX XXXX  X XXX XXXXXXX XXXX  X X  XX  XX  XXXX XX  X  X  XXXXX XXXX XXX X   XX    XX XXXX XX  X XX 
 38 |  X XXXXX XX X XXX    XX   XXXX XXXX  X XXX XXXXXXX XXXX  X X  XXX XX  XXXX XX  X  X  XXXXX XXXXXXXXXX   XX    XXXXXXX XX  X XX 
 35 |  X XXXXX XX X XXX X  XX   XXXX XXXX  X XXX XXXXXXXXXXXX  X X  XXX XX  XXXX XXXXX  X  XXXXX XXXXXXXXXX  XXX    XXXXXXX XX  X XX 
 32 |  X XXXXX XX X XXX X  XX X XXXX XXXX  X XXX XXXXXXXXXXXX  X X  XXX XX  XXXX XXXXX  X  XXXXX XXXXXXXXXX  XXX    XXXXXXXXXX  X XX 
 29 |  X XXXXX XX X XXX X  XX X XXXX XXXX  X XXX XXXXXXXXXXXX  XXX  XXX XX  XXXX XXXXX  X  XXXXX XXXXXXXXXX  XXX    XXXXXXXXXX  X XX 
 26 |  XXXXXXX XX X XXX X  XX X XXXX XXXX  X XXX XXXXXXXXXXXX  XXX  XXX XXX XXXX XXXXXX X  XXXXX XXXXXXXXXX  XXX    XXXXXXXXXX  X XX 
 23 |  XXXXXXX XXXX XXX X  XX X XXXX XXXXX X XXX XXXXXXXXXXXX  XXX  XXX XXX XXXXXXXXXXX X  XXXXX XXXXXXXXXX  XXX    XXXXXXXXXX  X XXX
 20 |  XXXXXXX XXXX XXXXX  XXXX XXXX XXXXX X XXX XXXXXXXXXXXX  XXX  XXX XXX XXXXXXXXXXX X  XXXXX XXXXXXXXXXX XXX    XXXXXXXXXX  X XXX
 17 |X XXXXXXXXXXXXXXXXXX  XXXX XXXX XXXXX X XXXXXXXXXXXXXXXX  XXX  XXX XXX XXXXXXXXXXX X  XXXXX XXXXXXXXXXX XXX   XXXXXXXXXXX  X XXX
 14 |X XXXXXXXXXXXXXXXXXXXXXXXX XXXX XXXXXXX XXXXXXXXXXXXXXXXX XXX  XXX XXXXXXXXXXXXXXX X XXXXXX XXXXXXXXXXX XXX   XXXXXXXXXXX XXXXXX
 11 |X XXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXX XXXXXXXXXXXXXXXXX XXX  XXX XXXXXXXXXXXXXXX X XXXXXX XXXXXXXXXXXXXXXXX XXXXXXXXXXX XXXXXX
  8 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX XXX  XXX XXXXXXXXXXXXXXXXX XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXX
  5 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  2 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
     +----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+--
     0    5    10   15   20   25   30   35   40   45   50   55   60   65   70   75   80   85   90   95   100  105  110  115  120  125  
ENDOUT
