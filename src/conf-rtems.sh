#!/usr/bin/env bash

# Helper script to configure RTEMS for build

set -e

TOP="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
cd "$TOP/rtems"

function usage {
	echo "Utility script to configure RTEMS"
	echo "This will copy in the required configs for RTEMS and run ./waf configure"
	echo "OPTIONS:"
	echo "   -h --help               - Show this help text"
	echo "   -t --targets <targets>  - Space separated list of target systems"
	echo -e "\nExamples:"
	echo " $0 # Configure for all supported targets"
	echo " $0 -t powerpc/mvme3100 # Configure only for mvme3100"
}

while test $# -gt 0; do
    case $1 in
    -h|--help)
		usage
        exit 1
        ;;
	-t|--targets)
		ALL_TARGETS="$2"
		shift 2
		;;
    *)
        ;;
    esac
done

if [ -z "$ALL_TARGETS" ]; then
	ALL_TARGETS="$(cat ../configs/targets.txt | tr '\n' ' ')"
fi

echo "Targeting $ALL_TARGETS"

# Save old config
if [ -f config.ini ]; then
    mv config.ini config.ini.orig
fi

# Copy in the configs
echo "# Generated config! If you edit this, conf-rtems.sh will overwrite your changes!" > config.ini
for target in $ALL_TARGETS; do
	_T="$(echo $target | cut -f2 -d '/')"
	cat ../configs/rtems-config.$_T.ini >> config.ini
done

PREFIX="$PWD/../../target/rtems"

./waf configure --rtems-bsps="$ALL_TARGETS" --prefix="$PREFIX" --rtems-tools="$PWD/../../host/linux-x86_64"

