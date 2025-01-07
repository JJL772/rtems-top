# Environment configuration script for use with the fish shell
set TOP (readlink -f (dirname (status --current-filename)))

export PATH="$TOP/host/linux-x86_64/bin:$PATH"

