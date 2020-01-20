CC = gcc -g -Wall -fpic

libds_search.so : tree.o array.o list.o util.o
	gcc -shared -o libds_search.so tree.o array.o list.o util.o

tree.o : tree.c ds_search.h
	$(CC) -c $<

array.o : array.c ds_search.h
	$(CC) -c $<

list.o : list.c ds_search.h
	$(CC) -c $<

util.o : util.c ds_search.h
	$(CC) -c $<

clean :
	rm -f *.o *.so
