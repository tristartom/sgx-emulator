#include <stdio.h>
#include <unistd.h>
#include "lib_enclave.h"
#include "user_sharedargs.h"

void* sha1(void*, int, void*);

void user_entry_point(const void* args){
printf("SHA \n");
  unsigned char output_digest[20];
  unsigned char input_message[40];
  input_message[0] = 'a';
  sha1(input_message,40,output_digest);
}
