all: run

boot:
	nasm bootblock/boot0.asm -f bin -o bootblock/boot0.bin -i bootblock/
	nasm bootblock/boot1.asm -f bin -o bootblock/boot1.bin -i bootblock/

create-disk: boot
	dd if=/dev/zero of=bootblock/disk.img bs=512 count=2880
	dd if=bootblock/boot0.bin of=bootblock/disk.img bs=512 count=1 conv=notrunc
	dd if=bootblock/boot1.bin of=bootblock/disk.img bs=512 seek=1 count=17 conv=notrunc

run: create-disk
	qemu-system-x86_64 -nographic -drive format=raw,file=bootblock/disk.img

boot-dump: create-disk
	hexdump -C -n 9216 bootblock/disk.img > bootblock/disk.hex

clean:
	rm -f bootblock/*.bin bootblock/*.img bootblock/*.hex