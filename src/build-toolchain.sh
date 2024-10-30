#!/usr/bin/env bash
set -e 
TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
cd "$TOP/rtems-source-builder"

ONLY_DL=0
NO_DL=0
while test $# -gt 0; do
    case $1 in
    --download-only)
        ONLY_DL=1
        ;;
    --no-download)
        NO_DL=1
        ;;
    *)
        echo "Unknown argument"
        exit 1
        ;;
    esac
    shift
done

mkdir -p "${TOP}/../host/linux-$(uname -m)"
PREFIX="$(readlink -f "${TOP}/../host/linux-$(uname -m)")"

# RTEMS version
VERSION="6"

# Apply patches to rtems-source-builder
for p in ${TOP}/patches/rtems-source-builder/*.patch; do
    patch -N -b -p1 < "$p" || true
done

echo "Installing to $PREFIX. This may take a while..."

if [ $ONLY_DL -eq 1 ]; then
    EXTRA_ARGS=--source-only-download
elif [ $NO_DL -eq 1 ]; then
    EXTRA_ARGS=--no-download
fi

./source-builder/sb-set-builder --prefix="${PREFIX}" "${VERSION}/rtems-powerpc.bset" $EXTRA_ARGS

./source-builder/sb-set-builder --prefix="${PREFIX}" "${VERSION}/rtems-m68k.bset" $EXTRA_ARGS

