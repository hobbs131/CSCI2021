CC = gcc -Og -g

warsim : warsim.c libwar.o libcardlist.o
	$(CC) -o $@ $^

libcardlist.o : libcardlist.c libcardlist.h
	$(CC) -c $<

libwar.o : libwar.c libwar.h
	$(CC) -c $<

clean :
	rm -f warsim *.o a.out gmon.out
