#!/usr/bin/env bash

# Helper script to configure RTEMS for build

set -e

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
cd "$TOP/rtems"

while test $# -gt 0; do
    case $1 in
    -h|--help)
        echo "A simple utility to configure RTEMS"
        echo "This will copy in the required configs and run ./waf configure"
        exit 1
        ;;
    *)
        ;;
    esac
done

# Save old config
if [ -f config.ini ]; then
    mv config.ini config.ini.orig
fi

# Copy in the configs
echo "# Generated config!" > config.ini
for c in ../configs/rtems-config.*.ini; do
    cat $c >> config.ini
done

ALL_TARGETS="$(cat ../configs/targets.txt | tr '\n' ' ')"

PREFIX="$PWD/../../target/rtems"

./waf configure --rtems-bsps="$ALL_TARGETS" --prefix="$PREFIX" --rtems-tools="$PWD/../../host/linux-x86_64"

