#!/usr/bin/env bash

# Helper script to configure RTEMS for build

set -e

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
cd "$TOP/rtems-libbsd"

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

PREFIX="$PWD/../../target/rtems"

./waf configure --prefix="$PREFIX" --rtems-tools="$PWD/../../host/linux-x86_64" --rtems="$PREFIX" --buildset=buildset/default.ini

