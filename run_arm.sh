#!/bin/bash

# Check if a source file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <assembly_file>"
  exit 1
fi

# Check for required tools
for tool in aarch64-linux-gnu-as aarch64-linux-gnu-ld qemu-aarch64 gdb-multiarch; do
  if ! command -v $tool &> /dev/null; then
    echo "Error: $tool not found. Install it to proceed."
    exit 1
  fi
done

# Variables
ASM_FILE=$1
OBJ_FILE=${ASM_FILE%.s}.o
BIN_FILE=${ASM_FILE%.s}

# Assemble
echo "Assembling $ASM_FILE..."
aarch64-linux-gnu-as -g -o $OBJ_FILE $ASM_FILE
if [ $? -ne 0 ]; then
  echo "Assembly failed."
  exit 1
fi

# Link
echo "Linking $OBJ_FILE..."
aarch64-linux-gnu-ld -o $BIN_FILE $OBJ_FILE
if [ $? -ne 0 ]; then
  echo "Linking failed."
  exit 1
fi

# Run with QEMU
echo "Running $BIN_FILE with QEMU..."
qemu-aarch64 -g 1234 $BIN_FILE &
QEMU_PID=$!

# Start GDB
echo "Starting GDB with TUI and register layout..."
gdb-multiarch -ex "target remote localhost:1234" \
              -ex "tui enable" \
              -ex "layout regs" \
              $BIN_FILE

# Cleanup
kill $QEMU_PID
echo "QEMU process terminated."
