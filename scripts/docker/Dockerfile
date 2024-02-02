# Use an existing docker image as a base
FROM ubuntu:latest

ADD file ... in /

CMD ["/bin/bash"]


# Install necessary tools
RUN /bin/sh -c apt-get update && apt-get update && apt-get install -y \
    nasm \
    qemu \
    qemu-kvm \
    qemu-system \
    binutils

# Make a directory for your project
RUN mkdir /bootloader

# Set the working directory
WORKDIR /bootloader

# Copy your .asm file into the Docker image
COPY . .

# Compile the .asm file
RUN nasm -f bin -o bootloader.bin bootloader.asm

# Command to run your OS in QEMU when the Docker container is started
CMD ["qemu-system-x86_64", "-fda", "bootloader.bin"]
