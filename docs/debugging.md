# Debugging

## Debugging RTEMS 6 using QEMU

The xilinx-zynq-a9-qemu BSP is useful for testing RTEMS 6 code in QEMU, where it's much easier to debug
than on hardware.

The following scripts are provided to ease the usage of QEMU + remote GDB:
1. scripts/run-xiling-zynq-a9.sh
2. scripts/run-remote-gdb.sh

For this to work, you must have qemu-system-arm available on your system.

Launching an RTEMS application and waiting for GDB to connect:
```
run-xiling-zynq-a9.sh -g myRTEMSapp
```

This will connect to it using remote GDB on port 1234.
```
run-remote-gdb -a arm --symfile myRTEMSapp
```

`--symfile` is optional, but useful to get debug symbols.