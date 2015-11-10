#ifndef USER_SHAREDARGS_H
#define USER_SHAREDARGS_H

//shared between untrusted code and enclave code

struct args_enclave {
   int val_int;
   void * misc;
};

struct enclave_mem_image {
  //static or einit time
  void* handle_so; //.text and .data
  void* heap;
  void* tcs;
  //eenter time
  void* rt_args; 
} ;


#endif
