#include <stdio.h>
#include <unistd.h>
#include "lib_enclave.h"
#include "user_sharedargs.h"

#define malloc lib_malloc
#define free lib_free


int cur_idx = 1;

//w parameter: void entry_point(){
void user_entry_point(const void* args){
/**
  enclave coding rule:
  1. every memory dynamically allocated (e.g. malloc or mmap) should be simulated and operated on enclave heap space.
  2. args is a pointer (should not be val) and is read only, and should not be modified (modified value will not be reflected to untrusted code!)
*/

  int * ptr_int = & ((struct args_enclave *) args)->val_int; //always use ptr_int here!
  cur_idx = 1000;
  printf("inside enclave_foo: ptr_int (args): %p\n", args);
  printf("inside enclave_foo: ptr_int (ptr): %p\n", ptr_int);
  printf("inside enclave_foo: ptr_int (val): %d\n", *ptr_int);
  printf("inside enclave_foo: cur_idex: %d\n", cur_idx);
  printf("inside enclave_foo: malloc(): %p\n", &lib_malloc);
  *ptr_int = cur_idx; 
  int* p = new int[10];
  p[2] = 3;
  free(p);
  write(1, "writen\n", 7);
  //hooked heap allocation
  free(malloc(10));
}

#undef malloc 
#undef free


