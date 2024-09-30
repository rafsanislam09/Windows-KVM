#!/bin/sh

# Editable section. You can edit values here.
export WINDOWS_DISK_CAPACITY=64G # Default maximum disk capacity is 64 Gigabyte. Change as your need.
export PROCESSOR_CORE_AMOUNT=2 # Default is 2 core. Add or remove core(s) as your need.
export RAM=4G # Default is 4 Gigabyte RAM. Change as your need.

if [ -f virtio-win.iso ]; then
    echo "A CDROM image of Virtio Drivers for Windows found. Skipping downloading virtio-win.iso."
else
    echo "virtio-win.iso not found. Downloading...."
    wget -O 'virtio-win.iso' 'https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso'
fi

if [ -f win.qcow2 ]; then
    echo "A virtual disk image named win.qcow2 in QCOW2 format found. Skipping creating new disk."
else
    echo "win.qcow2 disk not found. Creating...."
    qemu-img create -f qcow2 win.qcow2 $WINDOWS_DISK_CAPACITY
fi

# Run qemu
qemu-system-x86_64 \
 --enable-kvm \
 -name "Windows VM" \
 -cpu host,hv-relaxed,hv-vapic,hv-vpindex,hv-runtime,hv-time,hv-synic,hv-stimer,hv-tlbflush,hv-ipi,hv-frequencies,hv-reenlightenment,hv-evmcs,hv-stimer-direct,hv-avic,hv-syndbg,hv-xmm-input,hv-tlbflush-ext,hv-tlbflush-direct \
 -machine q35 \
 -vga none -display gtk,gl=on \
 -netdev user,id=net0 \
 -m $RAM \
 -smp cores=$PROCESSOR_CORE_AMOUNT \
 -drive if=pflash,format=raw,readonly=on,file=OVMF_CODE_4M.secboot.fd,index=0 \
 -drive if=pflash,format=raw,file=OVMF_VARS_4M.ms.fd,index=1 \
 -drive file=win.qcow2,id=disk,format=qcow2,index=2,if=none \
 -drive file=virtio-win.iso,format=raw,index=3,media=cdrom \
 -drive file=Windows.iso,format=raw,media=cdrom,index=4 \
 -device virtio-scsi-pci,id=scsi \
 -device scsi-hd,drive=disk,vendor='Rafsan',product='QCOW2 Disk',serial='0001',wwn='6789',ver='1.0' \
 -device virtio-balloon \
 -device usb-tablet \
 -device virtio-net-pci,netdev=net0 \
 -device virtio-vga-gl,hostmem=32M \
 -device intel-hda -device hda-output,audiodev=audio0 \
 -audiodev sdl,id=audio0 \
 -virtfs local,path=/home/hashem/,mount_tag=host0,security_model=passthrough,id=host0 \
 -usb 
 
