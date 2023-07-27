#!/bin/bash

set -e
. ./build.sh

mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub

cp sysroot/boot/mbos.kernel isodir/boot/mbos.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "mbos" {
	multiboot /boot/mbos.kernel
}
EOF
grub-mkrescue -o mbos.iso isodir
