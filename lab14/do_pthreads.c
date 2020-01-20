// Demo program using threads, requires linking to pthread library
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

void *doit(void *param){
  long me = (long) param;
  printf("doit: I am thread %ld\n",me);
  return NULL;
}

int main(){
  pthread_t thread_1, thread_2;
  pthread_create(&thread_1, NULL, doit, (void *)1);
  pthread_create(&thread_1, NULL, doit, (void *)2);
  printf("main: I am the main thread\n");
  pthread_join(thread_1, NULL);

  printf("program pid is %d\n",getpid());
  printf("press any key to continue\n");
  getchar();
  return 0;
}
