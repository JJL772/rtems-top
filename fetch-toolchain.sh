#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

mkdir -p host/linux-x86_64

CURRENT_VER="2025.05.09-rt7-rc1"
RTEMS_VER=7

if [ -z "$1" ]; then
	echo "Downloads a toolchain tarball off of GitHub"
	echo "USAGE: $0 <arch>"
	exit 1
fi

wget "https://github.com/JJL772/rtems-toolchains/releases/download/${CURRENT_VER}/rtems-${RTEMS_VER}-$1.tar.gz"

echo "Extracting..."
tar -xf "rtems-${RTEMS_VER}-$1.tar.gz" -C "host/linux-x86_64"

rm "rtems-${RTEMS_VER}-$1.tar.gz"

