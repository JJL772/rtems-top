# rtems-top

Top-level build directory for RTEMS 6.0 at SLAC. Contains useful patches and helper scripts for compiling things.

## Cloning & Updating

### Initial Clone

Clone into your directory of choice with --recursive
```sh
cd /sdf/sw/epics/package/rtems
git clone git@github.com:JJL772/rtems-top.git --recursive 6.0
```

After that, you're good to go.

### Updating 

When you update, make sure to run the following commands from your rtems top directory:
```sh
git pull # Update the branch to latest
git submodule sync # Ensure the submodule URLs are up to date
git submodule update --recursive
```

## System Requirements

To build RTEMS, the following applications must be installed:
1. python 2.7+ (3+ works too!)
2. git
3. bash

Generally a newer OS is better. i.e. choose rocky 9 over rhel 7, if you can, otherwise the source builder may fail.

## Building

To build RTEMS 6.0, you should follow these steps, in order.

### Applying Patches

Apply relevant patches to the RTEMS source tree.
```
./apply-patches.sh
```

### Assembling the toolchain

Building the toolchain can be done using `build-toolchain.sh`. This will automatically install the toolchain into host/<hostarch>.

Usually this takes around ~2 hours, although you only need to do this once.

### Building RTEMS

`conf-rtems.sh` is provided as a helper to configure RTEMS.

```sh
cd src/rtems

# This script will copy in the configs and run waf configure
../conf-rtems.sh

./waf install
```

### Building libbsd

```sh
cd src/rtems-libbsd

# Configure
../conf-libbsd.sh

./waf install
```

### Building rtems-net-services

```sh
cd src/rtems-net-services

../conf-net-services.sh

./waf install
```
