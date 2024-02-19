; disk.asm
; Has all code related to floppy disk management
; @author Dev IG
[bits 16]
reset_disk_controller:
    pusha ; Store Registers

    mov ah, 0x00 ;Store bios code to reset disk to ah
    int 0x13
    jc reset_error
    mov bx, RESET_SUCCESS
    call print_string

    popa ; restore registers
    ret

reset_error:
    mov bx, RESET_ERROR
    call print_string
    call print_registers
    hlt

load_boot_1:
    pusha ;Store Registers

    cld ;reset direction flag
    ; set data and extra segment to 0
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ah, 0x02 ; set ah registers to 0x02 to signal reading of disk
    mov al, 17   ; boot 1 is in 17 sectors of the disk
    mov ch, 0    ; from cylinder 0
    mov cl, 2    ; from sector 2
    mov dh, 0    ; from head 0
    mov bx, START_OF_BOOT_1 ;load into bx 0x1000
    int 0x13
    jc boot_1_load_error
    cmp al, 17
    jne boot_1_sector_mismatch_error
    mov bx, BOOT_1_LOAD_ERROR
    call print_string

    popa ;Restore Registers
    ret

boot_1_load_error:
    call print_registers
    mov bx, BOOT_1_LOAD_ERROR
    call print_string
    jmp $

boot_1_sector_mismatch_error:
    call print_registers
    mov bx, BOOT_1_SECTOR_MISMATCH_ERROR
    call print_string
    jmp $

RESET_ERROR db "er: disk reset! ", 0
RESET_SUCCESS db "success: disk reset! ", 0
BOOT_1_LOAD_SUCCESS db "success: disk load! ", 0
BOOT_1_LOAD_ERROR db "error: boot 1 load! ", 0
BOOT_1_SECTOR_MISMATCH_ERROR db "error: !17 sector load! ", 0