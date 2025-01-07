#!/usr/bin/env bash

TOP="$(realpath "$(dirname ${BASH_SOURCE[0]})")"

export PATH="$TOP/host/linux-x86_64/bin:$PATH"

