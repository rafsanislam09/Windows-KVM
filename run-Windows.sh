if [ -f virtio-win*.iso ]; then
    echo "A disk image of Virtio Drivers for Windows found. Skipping downloading virtio-win.iso."
else
    echo "virtio-win.iso not found. Downloading...."
    wget -O "virtio-win.iso" "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
fi

qemu-system-x86_64 \
 --enable-kvm \
 -cpu host \
 -machine q35 \
 -vga none -display gtk,gl=on \
 -m 2G \
 -smp 2 \
 -drive if=pflash,format=raw,readonly=on,file=OVMF_CODE_4M.secboot.fd,index=0 \
 -drive if=pflash,format=raw,file=OVMF_VARS_4M.ms.fd,index=1 \
 -drive file=win.qcow2,id=disk,format=qcow2,index=2,if=none \
 -drive file=virtio-win.iso,format=raw,index=3,media=cdrom \
 -device virtio-scsi-pci,id=scsi \
 -device scsi-hd,drive=disk,vendor='RCA',product='RGB+++',serial='123456',wwn='6789',ver='2.5' \
 -device virtio-balloon \
 -device usb-tablet \
 -device virtio-vga-gl,hostmem=16M \
 -audiodev pipewire,id=audio0 \
 -device intel-hda -device hda-output,audiodev=audio0 \
 -net nic,model=virtio \
 -usb \
