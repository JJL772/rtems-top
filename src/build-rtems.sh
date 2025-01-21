#!/usr/bin/env bash

# Build EVERYTHING!

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

./conf-rtems.sh
pushd rtems > /dev/null
./waf build install
popd > /dev/null

./conf-libbsd.sh
pushd rtems-libbsd > /dev/null
./waf build install
popd > /dev/null

./conf-net-services.sh
pushd rtems-net-services > /dev/null
./waf build install
popd > /dev/null

