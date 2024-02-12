FROM ubuntu:24.04

# Update the system and install necessary packages
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    qemu-kvm \
    nasm \
    rustc \
    cargo \
    git \
    make

# Set the working directory in the container
WORKDIR /gust_os

# Copy everything from the current directory (on your machine) to the working directory in the container
COPY . .

# You can specify the command to run your application here
CMD ["/bin/bash"]
