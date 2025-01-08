# Environment configuration script for use with the fish shell
set TOP (readlink -f (dirname (status --current-filename)))

export RTEMS_TOP="$TOP"
export PATH="$TOP/host/linux-x86_64/bin:$PATH"
