# Last updated: Sat 15 Jun 2019 05:17:26 PM CDT
CFLAGS = -Wall -g -lm
CC     = gcc $(CFLAGS)
SHELL  = /bin/bash
CWD    = $(shell pwd | sed 's/.*\///g')

PROGRAMS = \
	save_deltas \
	deltas_main \
	print_graph_demo \
	graph_file \
	tree_main \

all : $(PROGRAMS)

zip :
	rm -f a1-code.zip
	cd .. && zip "$(CWD)/a1-code.zip" -r "$(CWD)"
	@echo Zip created in a1-code.zip
	@if (( $$(stat -c '%s' a1-code.zip) > 10*(2**20) )); then echo 'WARNING: a1-code.zip seems *really big*, check there are no abnormally large test files'; du -h a1-code.zip; fi

clean :
	rm -f $(PROGRAMS) *.o

# int delta problem
deltas_main.o : deltas_main.c deltas.h
	$(CC) -c $<

deltas_main : deltas_main.o read_deltas.o
	$(CC) -o $@ $^

read_deltas.o : read_deltas.c deltas.h
	$(CC) -c $<

save_deltas.o : save_deltas.c deltas.h
	$(CC) -c $<

save_deltas : save_deltas.o
	$(CC) -o $@ $^

# print_graph
print_graph.o : print_graph.c
	$(CC) -c $<

print_graph_demo.o : print_graph_demo.c
	$(CC) -c $<

print_graph_demo : print_graph_demo.o print_graph.o
	$(CC) -o $@ $^

graph_file.o : graph_file.c
	$(CC) -c $<

graph_file : graph_file.o print_graph.o read_deltas.o
	$(CC) -o $@ $^

# tree problem
tree_main : tree_main.o tree_funcs.o
	$(CC) -o $@ $^

tree_main.o : tree_main.c tree.h
	$(CC) -c $<

tree_funcs.o : tree_funcs.c tree.h
	$(CC) -c $<


# Testing Targets
VALGRIND = valgrind --leak-check=full --show-leak-kinds=all

test : test-p1 test-p2 test-p3

test-p1 : test_read_deltas
	@printf "===TESTS for P1===\n"
	@printf "RUNNING binary tests for read_deltas\n"
	./test_read_deltas
	@printf "\n"
	@printf "\n"
	@printf "RUNNING tests under Valgrind to look for memory errors\n"
	@echo $(VALGRIND) ./test_read_deltas
	@$(VALGRIND) ./test_read_deltas >& test-data/p1-valgrind.tmp
	@chmod u+x ./test_check_valgrind.sh
	@./test_check_valgrind.sh 5 '#PROBLEM 1 Valgrind Memory Checks' test-data/p1-valgrind.tmp
	@printf "\n"



test_read_deltas.o : test_read_deltas.c deltas.h
	$(CC) -c $<

test_read_deltas : test_read_deltas.o read_deltas.o
	$(CC) -o $@ $^

test-p2 : print_graph_demo graph_file save_deltas
	@printf "===TESTS for P2===\n"
	@printf "Testing print_graph via print_graph_demo\n"
	@chmod u+x ./test_print_graph.sh
	./test_print_graph.sh
	@printf "\n"
	@printf "Testing graph_file\n"
	chmod u+x ./test_print_graph.sh
	./test_graph_file.sh

test-p3 : tree_main
	@printf "===TESTS for P3===\n"
	@chmod u+x ./test_tree_main.sh
	./test_tree_main.sh

clean-tests :
	rm -f test_read_deltas
	rm -f test-data/*.tmp test-data/*.tree
