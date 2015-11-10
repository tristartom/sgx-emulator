SRCDIR = src
OBJDIR = bin
DEBUG_FLAG = -O0 -g -D DEBUG=1
UNDEBUG_FLAG = -O2 
FLAGS = -m64 -D DLL_APP=1
FLAGS_XX = $(FLAGS) -std=c++11 
CXX = g++
CC = gcc
AR = ar

LIB_SGX_ENL_1 = lib/lib_sgx_enclave.o
LIB_SGX_ENL_2 = lib/lib_sgx_enclave_syscallwrap.o
LIB_SGX_ENL = $(LIB_SGX_ENL_1) $(LIB_SGX_ENL_2)
LIB_SGX_UT = lib/lib_sgx_untrusted.o
FLAGS_SYSCALL_WRAP= \
	-Wl,-wrap,write \
	-Wl,-wrap,access \
	-Wl,-wrap,brk \
	-Wl,-wrap,mmap 
	#-Wl,-wrap,puts 


default : debug 

debug : FLAGS_XX += $(DEBUG_FLAG)
debug : 
	@mkdir -p bin; rm bin/* || true
	@#trusted 
	$(CXX) -shared -fPIC -c $(FLAGS_XX) src/user_enclave_foo.cpp -o $(OBJDIR)/enclave_foo.o
	$(CXX) -shared -fPIC $(FLAGS_SYSCALL_WRAP) -Wl,--whole-archive $(OBJDIR)/enclave_foo.o $(LIB_SGX_ENL) -Wl,--no-whole-archive -o $(OBJDIR)/enclave_foo.so
	@#rm $(OBJDIR)/enclave_foo.o
	@#If a .so needs to be generated, all relocatable objects file needs to be generated with the same '-shared -fPIC' flag
	@#can't combine multiple .so files in Linux, (.so is final); can only combine .o or .a files
	$(CXX) -shared -fPIC $(FLAGS_XX) $(FLAGS_SYSCALL_WRAP) src/user_enclave_foo2.cpp  -Wl,--whole-archive $(LIB_SGX_ENL) -Wl,--no-whole-archive -o $(OBJDIR)/enclave_foo2.so
	@#untrusted 
	$(CXX)  -rdynamic $(FLAGS_XX) src/user_main_ut.cpp $(LIB_SGX_UT) -ldl -o $(OBJDIR)/a.out

c : product-compile 

product-compile : FLAGS_XX += $(UNDEBUG_FLAG)
product-compile : 
	@mkdir -p bin; rm bin/* || true
	@#trusted 
	$(CXX) -shared -fPIC $(FLAGS_XX) $(FLAGS_SYSCALL_WRAP) src/user_enclave_foo.cpp  -Wl,--whole-archive $(LIB_SGX_ENL) -Wl,--no-whole-archive -o $(OBJDIR)/enclave_foo.so
	@#If a .so needs to be generated, all relocatable objects file needs to be generated with the same '-shared -fPIC' flag
	@#can't combine multiple .so files in Linux, (.so is final); can only combine .o or .a files
	$(CXX) -shared -fPIC $(FLAGS_XX) $(FLAGS_SYSCALL_WRAP) src/user_enclave_foo2.cpp  -Wl,--whole-archive $(LIB_SGX_ENL) -Wl,--no-whole-archive -o $(OBJDIR)/enclave_foo2.so
	@#untrusted 
	$(CXX)  -rdynamic $(FLAGS_XX) src/user_main_ut.cpp $(LIB_SGX_UT) -ldl -o $(OBJDIR)/a.out

#deprecated
slink :
	$(CC) $(FLAG) $(SRC_ALL) -o $(OBJDIR)/a.out

#deprecated
dll :
	$(CC) -shared -fPIC $(FLAG) src/enclave.cpp -o $(OBJDIR)/enclave.so
	$(CC) $(FLAG) src/main_ut.cpp $(OBJDIR)/enclave.so -o $(OBJDIR)/a.out

d : debug-run

debug-run :
	@echo 0 | sudo tee /proc/sys/kernel/randomize_va_space #it is important to turn off ASLR! @ubuntu
	@$(MAKE) --no-print-directory  run
	@echo 2 | sudo tee /proc/sys/kernel/randomize_va_space  #it is important to turn back on ASLR! @ubuntu

r : run

run :
	@./bin/a.out

s :
	@strace ./bin/a.out 2>&1 | view -

clean :
	@rm lib/*; rm bin/*  || true
