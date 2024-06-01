#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

if [ "$(id -u)" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

cd "$(dirname -- "$(readlink -f -- "$0")")" && cd ..
mkdir -p build && cd build

if [[ "${MAINLINE}" != "Y" ]]; then
    cp -r ../kernel-5.10 linux-rockchip
fi
cd linux-rockchip

# Compile kernel into a deb package
# make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 rockchip_defconfig
# make KBUILD_IMAGE="arch/arm64/boot/Image" CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 -j "$(nproc)" bindeb-pkg
dpkg-buildpackage -a "$(cat debian/arch)" -d -b -nc -uc
# Cleanup garbage
rm -f ../linux-image-*dbg*.deb ../linux-libc-dev_*.deb ../*.buildinfo ../*.changes ../*.dsc ../*.tar.gz
