#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
TOP="$PWD"

pkgs="rtems-net-services"
_AF=0
for pkg in $pkgs; do
    pushd $pkg > /dev/null
    echo "Working on $pkg"
    for f in "$TOP/patches/$pkg/"*.patch; do
        echo "Applying $f..."
        if ! git apply --check $f 2> /dev/null; then
            if git apply --reverse --check $f 2> /dev/null; then
                echo "Already applied"
                continue
            fi
            _AF=1;
            echo "Patch does not apply"
        else
            git apply $f || _AF=1
        fi
    done
    popd > /dev/null
done

echo "Done"
exit $_AF
