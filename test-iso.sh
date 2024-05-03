#!/bin/sh

ISO_FILE_PATH="${1:?}"

qemu-system-x86_64 -m 1G -net user -boot d -cdrom "$ISO_FILE_PATH"
