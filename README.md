SGX-emulator and SDK
===

Use the emulator with the following specific setting only!

**64-bit `Ubuntu 14.04.3 LTS` guest OS in VirtualBox** 

(This is the setting we have tested so far, and we can ensure the working of our emulator! We may relieve the requirement on VirtualBox in the future release.)

Before execution, make sure about the right Linux version

```
uname -r
3.19.0-25-generic
```

Demo 
---

```
sudo insmod sgx.ko
make sha
#sudo dmesg -c
make r # view the standard output
dmesg # view kernel output
sudo rmmod sgx
```
(alternative, you can also run `make` in the second line).

#### Explanation

This demo will show you a simple Enclave program that computes `sha1` (cryptographic hash from `openssl`) inside Enclave. 

- In user-space code, it appears to be a simple function call into a dynamically loaded library. 
- In `dmesg`, you can see that the function call is "captured" in the kernel space (triggered by an illegal instruction, verified through the following "experiment"). We use this kernel-space hooking to emulate the SGX ENCLU instructions (`EENTER` and `EEXIT`).

```
sudo rmmod sgx
make r #you should be able to see the "illegal instruction" exception
```
