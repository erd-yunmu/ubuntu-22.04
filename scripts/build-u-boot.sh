#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

cd "$(dirname -- "$(readlink -f -- "$0")")" && cd ..
mkdir -p build && cd build

if [[ -z ${UBOOT_PACKAGE} ]]; then
    echo "Error: UBOOT_PACKAGE is not set"
    exit 1
fi

if [ ! -d "${UBOOT_PACKAGE}" ]; then
    # shellcheck source=/dev/null
    cp -r ../u-boot "${UBOOT_PACKAGE}"
    cp -r ../packages/"${UBOOT_PACKAGE}"/debian "${UBOOT_PACKAGE}"
fi
cd "${UBOOT_PACKAGE}"

# Compile u-boot into a deb package
dpkg-buildpackage -a "$(cat debian/arch)" -d -b -nc -uc

rm -f ../*.buildinfo ../*.changes
