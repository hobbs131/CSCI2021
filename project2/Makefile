CFLAGS = -Wall -g
CC     = gcc $(CFLAGS)
SHELL  = /bin/bash
CWD    = $(shell pwd | sed 's/.*\///g')

PROGRAMS = \
	thermo_main \
	puzzlebox   \


all : $(PROGRAMS)

clean :
	rm -f $(PROGRAMS) *.o

AN=a2
zip :
	rm -f $(AN)-code.zip
	cd .. && zip "$(CWD)/$(AN)-code.zip" -r "$(CWD)"
	@echo Zip created in $(AN)-code.zip
	@if (( $$(stat -c '%s' $(AN)-code.zip) > 10*(2**20) )); then echo "WARNING: $(AN)-code.zip seems REALLY big, check there are no abnormally large test files"; du -h $(AN)-code.zip; fi

# thermometer problem
thermo_main : thermo_main.o thermo_update.o thermo_sim.o
	$(CC) -o $@ $^

thermo_main.o : thermo_main.c thermo.h
	$(CC) -c $<

thermo_sim.o : thermo_sim.c thermo.h
	$(CC) -c $<

thermo_update.o : thermo_update.c thermo.h
	$(CC) -c $<


# debugging problem
puzzlebox.o : puzzlebox.c
	$(CC) -c $<

puzzlebox : puzzlebox.o
	$(CC) -o $@ $^



# Testing Targets
VALGRIND = valgrind --leak-check=full --show-leak-kinds=all

test: test-p1 test-p2

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
	./test_thermo_main.sh


test_thermo_update : test_thermo_update.o thermo_sim.o thermo_update.o
	$(CC) -o $@ $^

test_thermo_update.o : test_thermo_update.c
	$(CC) -c $<


test-p2 : puzzlebox
	./puzzlebox input.txt


clean-tests : clean
	rm -f test-data/*.tmp test_thermo_update

