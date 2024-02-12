all: run

compile-boot:
	nasm bootblock/boot0.asm -f bin -o bootblock/boot.bin

run: compile-boot
	qemu-system-x86_64 -nographic -drive format=raw,file=bootblock/boot.bin

clean:
	rm -f bootblock/boot.bin
