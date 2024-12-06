#!/usr/bin/env bash

set -e

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")/../")"

"$TOP/src/rtems-tools/tester/rtems-run" --rtems-bsp=xilinx_zynq_a9_qemu --rtems-tools="$TOP/host/linux-x86_64" $@

