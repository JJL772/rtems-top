# rtems-top

Top-level build directory for RTEMS 6.0 at SLAC. Contains useful patches and helper scripts for compiling things.

## System Requirements

To build RTEMS, the following applications must be installed:
1. python 2.7+ (3+ works too!)
2. git
3. bash

Generally a newer OS is better. i.e. choose rocky 9 over rhel 7, if you can, otherwise the source builder may fail.

## Assembling the toolchain

Building the toolchain can be done using `build-toolchain.sh`. This will automatically install the toolchain into ../host/<hostarch>.

Usually this takes around ~2 hours, although you only need to do this once.

## Building RTEMS

`conf-rtems.sh` is provided as a helper to configure RTEMS.

```sh
cd src/rtems

# This script will copy in the configs and run waf configure
../conf-rtems.sh

./waf install
```

## Building libbsd

```sh
cd src/rtems-libbsd

# Configure
../conf-libbsd.sh

./waf install
```

## Building rtems-net-services

```sh
cd src/rtems-net-services

../conf-net-services.sh

./waf install
```
