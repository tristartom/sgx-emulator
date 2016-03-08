SGX-emulator and SDK
===

Attention: use the emulator with the following specific setting only!

**64-bit `Ubuntu 14.04.3 LTS` guest OS in VirtualBox** 

(This is the setting we have tested so far, and we can ensure the working of our emulator! We may relieve the requirement on VirtualBox in the future release.)


Workflow
---

```
sudo insmod sgx.ko
make sha
make r
sudo rmmod sgx
```
(alternative, you can also run `make` in the second line).


make sure right Linux version

```
uname -r
3.19.0-25-generic
```
