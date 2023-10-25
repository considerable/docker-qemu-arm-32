# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# Install QEMU and ARM assembly tools
RUN apt-get update && apt-get install -y \
    qemu-system-arm \
    binutils-arm-none-eabi \
    gcc-arm-none-eabi \
    gdb-arm-none-eabi

WORKDIR /arm

# Copy the hello world program 
COPY hello.s .

# Build from the source:
RUN arm-none-eabi-as -o hello.o hello.s
RUN arm-none-eabi-ld -Ttext=0x0 -o hello.elf hello.o
RUN arm-none-eabi-objcopy -O binary hello.elf hello.bin

# Because the “virt” board expects a 64MB image:
RUN dd if=/dev/zero of=flash.img bs=1M count=64
RUN dd if=hello.bin of=flash.img conv=notrunc

# Run qemu-system-arm when the container starts
ENTRYPOINT ["qemu-system-arm", "-machine", "virt", "-m", "128M", "-nographic", "-drive", "if=pflash,format=raw,file=/arm/flash.img"]

