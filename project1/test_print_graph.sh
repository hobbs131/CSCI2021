#!/bin/bash
# 
# tests for print_graph_demo, run as one of
#   > ./test_print_graph.sh         # run everything
#   > ./test_print_graph.sh 2       # run only tests 2
#   > ./test_print_graph.sh norm    # run only normal tests
#   > ./test_print_graph.sh valg    # run only valgrind tests
#   > ./test_print_graph.sh norm 2  # run only normal test 2
#   > ./test_print_graph.sh valg 2  # run only vaglgrind test 2
#
# 4 point(s) for the single normal test
# 1 point(s) for avoiding memory problems under Valgrind

generate=1
run_norm=1                                 # run normal tests
run_valg=1                                 # run valgrind tests
norm_mult=4                                # weighting for normal tests
valg_mult=1                                # weighting for valgrind tests

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
source test_print_graph_data.sh
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

# Run normal tests: capture output and check against expected
if [ "$run_norm" = "1" ]; then
    major_sep
    printf "#PROBLEM 2 print_graph_demo NORMAL TESTS\n"
    for i in $all_tests; do
        printf "#TEST %2d %-18s : " "$i" "${tnames[i]}"
        
        # Run the test

        # run program on input file
        ./print_graph_demo >& $ACTUAL
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
    major_sep
    printf "#RESULTS: %2d / %2d Normal correct\n" "$((NPASS*norm_mult))" "$((NTESTS*norm_mult))"
    printf "\n"
fi

# ================================================================================

# Run valgrind tests: check only for problems identified by valgrind
if [ "$run_valg" = "1" ]; then
    major_sep
    printf "#PROBLEM 2 print_graph_demo VALGRIND TESTS\n"

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
    major_sep
    printf "#RESULTS: %2d / %2d Valgrind correct\n" "$((NVALG*valg_mult))" "$((VTESTS*valg_mult))"
    printf "\n"
fi


major_sep
printf "OVERALL:\n"
printf "%2d / %2d Normal correct\n"   "$((NPASS*norm_mult))" "$((NTESTS*norm_mult))"
printf "%2d / %2d Valgrind correct\n" "$((NVALG*valg_mult))" "$((VTESTS*valg_mult))"


