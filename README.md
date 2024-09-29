# Windows-KVM
Run Windows 10 and older versions in optimized environment inside plain QEmu with KVM. TPM is currently not available. Need qemu-system-x86 package and KVM support. Download Windows ISO from https://www.microsoft.com/software-download/ and rename it as Windows.iso. Required QEmu version is 9.0.2.
You need these packages : *qemu-system-x86_64 (with KVM support), qemu-utils, qemu-system-gui, wget* and other dependencies that they need. 
**Available features :**
1) UEFI with Secure Boot enabled
2) VirtIO and Hyper-V based optimizations
4) Manual memory (RAM) ballooning
5) Paravirtualized Internet
6) Universal audio support

**Currently not available :**
1) Shared Clipboard
2) Shared folder
3) TPM 
