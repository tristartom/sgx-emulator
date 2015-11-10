#include "stdio.h"
#include "stdlib.h"

#include "lib_untrusted.h"
#include "user_sharedargs.h"

void bar(int * ptr_int){
  printf("outside enclave: %d\n", *ptr_int);
}



int main(){
  enclave_mem_image* enclave_handle_foo;
  enclave_mem_image* enclave_handle_foo2;

//enclave foo
  enclave_handle_foo = dload_enclave_so("./bin/enclave_foo.so"); 

  struct args_enclave args;
  args.val_int = 37;
  args.misc = NULL;

  //wrapping foo
  call_enclave(enclave_handle_foo, &args);

  printf("Returned from the enclave foo!\n");

//non-enclave bar
  bar(&args.val_int);

//enclave foo2
  enclave_handle_foo2 = dload_enclave_so("./bin/enclave_foo2.so"); 
  struct args_enclave args2;
  args2.val_int = 0;

  //wrapping foo2
  call_enclave(enclave_handle_foo2, &args2);

  printf("Returned from the enclave foo2!\n");

  dunload_enclave_so(enclave_handle_foo);
  dunload_enclave_so(enclave_handle_foo2);
}

