#!/bin/sh

ISO_FILE_PATH="${1:?}"

VM_IMG_PATH="temp-vm.img"

echo "Creating temporary VM disk image"
qemu-img create -f qcow2 -o compression_type=zstd "$VM_IMG_PATH" 5G

echo
echo "Starting VM"
qemu-system-x86_64 \
	-cpu host \
	-smp 4,cores=2,threads=2 \
	-accel kvm \
	-m 2G \
	-nic user,model=virtio-net-pci \
	-boot d -cdrom "$ISO_FILE_PATH" \
	"$VM_IMG_PATH"

echo
echo "Removing temporary VM disk image"
rm "$VM_IMG_PATH"

echo
echo "Done!"
