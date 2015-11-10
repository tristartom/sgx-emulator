#include "stdio.h"
#include "lib_enclave.h"

int cur_idx = 1;

void user_entry_point(const void* args){
  cur_idx++;
  printf("inside enclave_foo2: %d\n", cur_idx);
}

