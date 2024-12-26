#!/bin/bash

# Ensure a source file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <assembly_file>"
  exit 1
fi

# Required tools check
for tool in aarch64-linux-gnu-as aarch64-linux-gnu-gcc qemu-aarch64 gdb-multiarch; do
  if ! command -v $tool &> /dev/null; then
    echo "Error: $tool not found. Install it to proceed."
    exit 1
  fi
done

# Variables
ASM_FILE=$1
OBJ_FILE=${ASM_FILE%.s}.o
BIN_FILE=${ASM_FILE%.s}
ROOT_FS=${ROOT_FS:-"/usr/aarch64-linux-gnu"} # Default root filesystem

# Ensure the dynamic loader and libraries exist in the root filesystem
if [ ! -f "$ROOT_FS/lib/ld-linux-aarch64.so.1" ] || [ ! -f "$ROOT_FS/lib/libc.so.6" ]; then
  echo "Error: Required libraries not found in $ROOT_FS. Please install or set up the correct root filesystem."
  exit 1
fi

# Assemble
echo "Assembling $ASM_FILE..."
aarch64-linux-gnu-as -g -o $OBJ_FILE $ASM_FILE
if [ $? -ne 0 ]; then
  echo "Assembly failed."
  exit 1
fi

# Link
echo "Linking $OBJ_FILE..."
aarch64-linux-gnu-gcc -nostartfiles -o $BIN_FILE $OBJ_FILE -lc
if [ $? -ne 0 ]; then
  echo "Linking failed."
  exit 1
fi

# Verify the binary's dynamic loader
echo "Verifying dynamic loader in the binary..."
aarch64-linux-gnu-readelf -a $BIN_FILE | grep interpreter
if [ $? -ne 0 ]; then
  echo "Error: Dynamic loader not set in the binary. Ensure proper linking."
  exit 1
fi

# Run with QEMU
echo "Running $BIN_FILE with QEMU..."
qemu-aarch64 -L $ROOT_FS $BIN_FILE

# Cleanup
if kill -0 $QEMU_PID 2>/dev/null; then
  kill $QEMU_PID
  echo "QEMU process terminated."
fi