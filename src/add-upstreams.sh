#!/usr/bin/env bash

set -e
cd rtems
git remote add upstream ssh://git@gitlab.rtems.org:2222/rtems/rtos/rtems.git || true

cd ../rtems-libbsd
git remote add upstream ssh://git@gitlab.rtems.org:2222/rtems/pkg/rtems-libbsd.git || true

cd ../rtems-net-legacy
git remote add upstream ssh://git@gitlab.rtems.org:2222/rtems/pkg/rtems-net-legacy.git || true

cd ../rtems-net-services
git remote add upstream ssh://git@gitlab.rtems.org:2222/rtems/pkg/rtems-net-services.git || true

