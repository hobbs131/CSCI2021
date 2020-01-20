#!/bin/bash
# 
# tests for graph_file executable, run as one of
#   > ./test_graph_file.sh         # run everything
#   > ./test_graph_file.sh 2       # run only tests 2
#   > ./test_graph_file.sh norm    # run only normal tests
#   > ./test_graph_file.sh valg    # run only valgrind tests
#   > ./test_graph_file.sh norm 2  # run only normal test 2
#   > ./test_graph_file.sh valg 2  # run only vaglgrind test 2
#
# 1 point(s) per 10 normal tests
# 0-3 point(s) penalty for memory problems under Valgrind

generate=1
run_norm=1                                 # run normal tests
run_valg=1                                 # run valgrind tests
valg_penalty_max=3                         # maximum point deduction for valgrind problems

VALGRIND="valgrind --leak-check=full --show-leak-kinds=all"
DIFF="diff -bBy"                            # -b ignore whitespace, -B ignore blank lines, -y do side-by-side comparison

INPUT=test-data/input.in                    # name for expected output file
EXPECT=test-data/expect.txt                 # name for expected output file
ACTUAL=test-data/actual.txt                 # name for actual output file
DIFFOUT=test-data/test.diff                 # name for diff output file
VALGOUT=test-data/valgrind.txt              # name for valgrind output file


function major_sep(){
    printf '%s\n' '====================================='
}
function minor_sep(){
    printf '%s\n' '-------------------------------------'
}

printf "Loading tests... "
source test_graph_file_data.sh
printf "%d tests loaded\n" "$T"

NTESTS=$T
VTESTS=$T
NPASS=0
NVALG=0

all_tests=$(seq $NTESTS)

case "$1" in
    norm)
        run_valg=0
        shift
        ;;
    valg)
        run_norm=0
        shift
        ;;
esac

# Check whether a single test is being run
single_test=$1
if ((single_test > 0 && single_test <= NTESTS)); then
    printf "Running single TEST %d\n" "$single_test"
    all_tests=$single_test
    NTESTS=1
    VTESTS=1
else
    printf "Running %d tests\n" "$NTESTS"
fi

# printf "tests: %s\n" "$all_tests"
printf "\n"

major_sep
printf "#PROBLEM 2 graph_file.c TESTS\n"

# Run normal tests: capture output and check against expected
if [ "$run_norm" = "1" ]; then
    minor_sep
    printf "graph_file.c NORMAL TESTS\n"
    for i in $all_tests; do
        printf "#TEST %2d %-18s : " "$i" "${tnames[i]}"
        
        # Run the test

        # generate the input file
        printf "%s\n" "${input[i]}" | ./save_deltas "${format[i]}" $INPUT > /dev/null
        # run program on input file
        ./graph_file "${format[i]}" $INPUT "${height[i]}" >& $ACTUAL
        # generate expected output
        printf "%s\n" "${output[i]}" > $EXPECT

        # Check for failure, print side-by-side diff if problems
        if ! $DIFF $EXPECT $ACTUAL > $DIFFOUT
        then
            printf "FAIL: Output Incorrect\n"
            minor_sep
            printf "INPUT:\n%s\n" "${input[i]}"
            printf "OUTPUT: EXPECT   vs   ACTUAL\n"
            cat $DIFFOUT
            if [ "$generate" == "1" ]; then
                printf "FULL ACTUAL\n"
                cat $ACTUAL
            fi
            minor_sep
        else
            printf "OK\n"
            ((NPASS++))
        fi

    done
    printf "Finished\n"
    printf "%2d / %2d Normal correct\n" "$NPASS" "$NTESTS"
    printf "\n"
fi

# ================================================================================

# Run valgrind tests: check only for problems identified by valgrind
if [ "$run_valg" = "1" ]; then
    minor_sep
    printf "graph_file.c VALGRIND TESTS\n"

    for i in $all_tests; do
        printf "TEST %2d %-18s : " "$i" "${tnames[i]}"
        
        # Run the test
        # generate the input file
        printf "%s\n" "${input[i]}" | ./save_deltas "${format[i]}" $INPUT > /dev/null
        # run code through valgrind
        $VALGRIND ./graph_file "${format[i]}" $INPUT "${height[i]}" >& $VALGOUT

        # Check various outputs from valgrind
        if ! grep -q 'ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)' $VALGOUT ||
           ! grep -q 'in use at exit: 0 bytes in 0 blocks'  $VALGOUT ||
             grep -q 'definitely lost: 0 bytes in 0 blocks' $VALGOUT;
        then
            printf "FAIL: Valgrind detected problems\n"
            minor_sep
            cat $VALGOUT
            minor_sep
        else
            printf "Valgrind OK\n"
            ((NVALG++))
        fi
    done
    printf "Finished\n"
    printf "%2d / %2d Valgrind correct\n" "$NVALG" "$VTESTS"
    printf "\n"
fi


major_sep
printf "OVERALL:\n"
printf "%2d / %2d Normal correct\n" "$NPASS" "$NTESTS"
printf "%2d / %2d Valgrind correct\n" "$NVALG" "$VTESTS"

valg_penalty=$((VTESTS-NVALG))
if ((valg_penalty > valg_penalty_max)); then
    valg_penalty=$valg_penalty_max
fi
printf "Valgrind penalty: -%d\n" "$valg_penalty"
printf "#RESULTS: %d / %d points for normal/valgrind tests\n" "$((NPASS-valg_penalty))" "$NTESTS"



