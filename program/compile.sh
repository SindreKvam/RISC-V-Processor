# Path to compiler (download from: https://github.com/stnolting/riscv-gcc-prebuilt)
export RISCV_GCC_DIR=../riscv-gcc/bin/


$RISCV_GCC_DIR/riscv32-unknown-elf-as -o 4.o 4.S
$RISCV_GCC_DIR/riscv32-unknown-elf-ld --oformat binary -o 4.bin 4.o
xxd -p -c 4 4.bin 4.hex


$RISCV_GCC_DIR/riscv32-unknown-elf-gcc -nostdlib -nostartfiles -nodefaultlibs -ffreestanding -O2 -c -o hello_world.o hello_world.c
$RISCV_GCC_DIR/riscv32-unknown-elf-ld -Ttext 0x0 -o hello_world.elf hello_world.o
$RISCV_GCC_DIR/riscv32-unknown-elf-objcopy -O binary hello_world.elf hello_world.bin
$RISCV_GCC_DIR/riscv32-unknown-elf-objdump -d hello_world.elf > hello_world.asm
xxd -p -c 4 hello_world.bin hello_world.hex

$RISCV_GCC_DIR/riscv32-unknown-elf-objcopy -I binary -O elf32-littleriscv -B riscv hello_world.bin hello_world_bin.elf
$RISCV_GCC_DIR/riscv32-unknown-elf-objdump -D -M no-aliases,numeric hello_world_bin.elf > hello_world_bin_disassebled.asm


