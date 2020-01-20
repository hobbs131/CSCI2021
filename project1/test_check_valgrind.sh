#!/bin/bash

# usage: test_check_valgrind.sh 10 "prob name" output_file.txt

MAX_POINTS=$1
PROBNAME=$2
VALGOUT=$3

printf '========================================\n'
printf "%s\n" "$PROBNAME"
# printf "%s\n" '----------------------------------------'

points=$MAX_POINTS

if ! grep -q 'ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)' $VALGOUT ||
   ! grep -q 'in use at exit: 0 bytes in 0 blocks'  $VALGOUT ||
     grep -q 'definitely lost: 0 bytes in 0 blocks' $VALGOUT;
then
    printf "FAIL: Valgrind detected problems\n"
    cat $VALGOUT | sed 's/#RESULTS/RESULTS/g; s/#PROBLEM/PROBLEM/g; s/#TEST/TEST/g;'
    points="0"
else
    echo "Valgrind ok"
fi

printf '========================================\n'
printf "#RESULTS: %d / %d points for avoiding memory errors\n" "$points" "$MAX_POINTS"
