#!/bin/bash

# usage: test_check_valgrind.sh 10 "prob name" output_file.txt
# Applies a PENALTY for failing valgrind 

VALG_PENALTY=$1
PROBNAME=$2
VALGOUT=$3

printf '========================================\n'
printf "%s\n" "$PROBNAME"
# printf "%s\n" '----------------------------------------'

points="0"                      # may change to penalty

if ! grep -q 'ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)' $VALGOUT ||
   ! grep -q 'in use at exit: 0 bytes in 0 blocks'  $VALGOUT ||
     grep -q 'definitely lost: 0 bytes in 0 blocks' $VALGOUT;
then
    printf "FAIL: Valgrind detected problems\n"
    cat $VALGOUT | sed 's/RESULTS/*RESULTS/g; s/PROBLEM/*PROBLEM/g;'
    points=VALG_PENALTY
else
    echo "Valgrind ok"
fi

printf '========================================\n'
printf "RESULTS: %d / %d point(s) penalty for memory errors\n" "$points" "0"
