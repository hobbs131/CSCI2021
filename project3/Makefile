CFLAGS = -Wall -g
CC     = gcc $(CFLAGS)
SHELL  = /bin/bash
CWD    = $(shell pwd | sed 's/.*\///g')

PROGRAMS = \
	thermo_main \


all : $(PROGRAMS)

clean :
	rm -f $(PROGRAMS) *.o vgcore.* hybrid_main

AN=a3
zip :
	rm -f $(AN)-code.zip
	cd .. && zip "$(CWD)/$(AN)-code.zip" -r "$(CWD)"
	@echo Zip created in $(AN)-code.zip
	@if (( $$(stat -c '%s' $(AN)-code.zip) > 10*(2**20) )); then echo "WARNING: $(AN)-code.zip seems REALLY big, check there are no abnormally large test files"; du -h $(AN)-code.zip; fi

# thermometer problem
thermo_main : thermo_main.o thermo_sim.o thermo_update_asm.o 
	$(CC) -o $@ $^

thermo_main.o : thermo_main.c thermo.h
	$(CC) -c $<

thermo_sim.o : thermo_sim.c thermo.h
	$(CC) -c $<

# required assembly implementation
thermo_update_asm.o : thermo_update_asm.s thermo.h
	$(CC) -c $<


# C version of functions
thermo_update.o : thermo_update.c thermo.h
	$(CC) -c $<


# main which uses both assmebly and C update functions for incremental
# testing
hybrid_main : thermo_main.o thermo_sim.o thermo_update_asm.o thermo_update.o
	$(CC) -o $@ $^

################################################################################
# Testing Targets
VALGRIND = valgrind --leak-check=full --show-leak-kinds=all

test: test-p1 

test-p1: test-p1a test-p1b

test-p1a : test_thermo_update
	@printf "Running test_thermo_update.c function tests for thermo_update.c\n"
	./test_thermo_update
	@printf "\n"
	@printf "Running tests in Valgrind\n"
	$(VALGRIND) ./test_thermo_update >& test-data/valgrind.tmp
	@chmod u+rx test_check_valgrind.sh
	./test_check_valgrind.sh '-10' 'PROBLEM 1A Valgrind Penalties' test-data/valgrind.tmp
	@printf "\n"

test-p1b : thermo_main
	@printf "Running test_thermo_main.sh tests for thermo_main\n"
	@chmod u+rx test_thermo_main.sh
	./test_thermo_main.sh thermo_main


test_thermo_update : test_thermo_update.o thermo_sim.o thermo_update_asm.o
	$(CC) -o $@ $^

test_thermo_update.o : test_thermo_update.c
	$(CC) -c $<


clean-tests : clean
	rm -f test-data/*.tmp test_thermo_update test_hybrid


# test hybrid for incremental work
test-hybrid : test_hybrid hybrid_main
	@printf "===TESTS for Hybrid===\n"
	@printf "Running binary tests for hybrid\n"
	./test_hybrid
	@printf "\n"
	@printf "Running tests in Valgrind\n"
	$(VALGRIND) ./test_hybrid
	@printf "\n"
	@printf "Running shell tests for hybrid_main\n"
	./test_thermo_main.sh hybrid_main


# hybrid test program
test_hybrid : test_thermo_update.o thermo_sim.o thermo_update_asm.o thermo_update.o
	$(CC) -o $@ $^
