CC = gcc -g -Wall

libds_search.a : tree.o array.o list.o util.o
	ar rcs libds_search.a tree.o array.o list.o util.o

clean :
	rm *.o *.a

tree.o : tree.c ds_search.h
	$(CC) -c $<

array.o : array.c ds_search.h
	$(CC) -c $<

list.o : list.c ds_search.h
	$(CC) -c $<

util.o : util.c ds_search.h
	$(CC) -c $<
