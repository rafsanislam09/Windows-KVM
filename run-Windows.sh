#!/bin/sh
export WINDOWS_DISK_CAPACITY = 64G #Default maximum disk capacity is 64GB. Change as your need.

if [ -f virtio-win.iso ]; then
    echo "A disk image of Virtio Drivers for Windows found. Skipping downloading virtio-win.iso."
else
    echo "virtio-win.iso not found. Downloading...."
    wget -O "virtio-win.iso" "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
fi

if [ -f win.qcow2 ]; then
    echo "win.qcow2 found. Skipping creating new disk."
else
    echo "win.qcow2 disk not found. Creating...."
    qemu-img create -f qcow2 win.qcow2 $WINDOWS_DISK_CAPACITY
fi

qemu-system-x86_64 \
 --enable-kvm \
 -cpu host,hv-relaxed,hv-vapic,hv-vpindex,hv-runtime,hv-time,hv-synic,hv-stimer,hv-tlbflush,hv-ipi,hv-frequencies,hv-reenlightenment,hv-evmcs,hv-stimer-direct,hv-avic,hv-syndbg,hv-xmm-input,hv-tlbflush-ext,hv-tlbflush-direct \
 -machine q35 \
 -vga none -display gtk,gl=on \
 -m 2G \
 -smp 2 \
 -drive if=pflash,format=raw,readonly=on,file=OVMF_CODE_4M.secboot.fd,index=0 \
 -drive if=pflash,format=raw,file=OVMF_VARS_4M.ms.fd,index=1 \
 -drive file=win.qcow2,id=disk,format=qcow2,index=2,if=none \
 -drive file=virtio-win-0.1.262.iso,format=raw,index=3,media=cdrom \
 -drive file="Windows.iso",format=raw,index=4,media=cdrom \
 -device virtio-scsi-pci,id=scsi \
 -device scsi-hd,drive=disk,vendor='Rafsan',product='QCOW2 Disk',serial='0001',wwn='6789',ver='1.0' \
 -device virtio-balloon \
 -device usb-tablet \
 -device virtio-vga-gl,hostmem=16M \
 -audiodev pipewire,id=audio0 \
 -device intel-hda -device hda-output,audiodev=audio0 \
 -usb 
