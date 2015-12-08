SGX-emulator and SDK
===

An Emulator and SDK for Intel SGX extension

Workflow
---

```
sudo insmod sgx.ko
make 
make c
make r
sudo rmmod sgx
```

make sure right Linux version

```
uname -r
3.19.0-25-generic
```

We have tested the emulator on 64-bit `Ubuntu 14.04.3 LTS` as virtual machine in **VirtualBox**. (It is important to test it in a virtual-machine scenario!)



