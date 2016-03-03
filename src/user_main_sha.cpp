#include "stdio.h"
#include "stdlib.h"

#include "lib_untrusted.h"
#include "user_sharedargs.h"

void bar(int * ptr_int){
  printf("outside enclave: %d\n", *ptr_int);
}



int main(){
  enclave_mem_image* enclave_handle_sha;

//enclave sha
  enclave_handle_sha = dload_enclave_so("./bin/enclave_sha.so"); 

  struct args_enclave args;
  args.val_int = 37;
  args.misc = NULL;

  //wrapping sha
  call_enclave(enclave_handle_sha, &args);

  printf("Returned from the enclave sha!\n");

//non-enclave bar
  bar(&args.val_int);

  dunload_enclave_so(enclave_handle_sha);
}

