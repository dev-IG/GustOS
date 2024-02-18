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

RESET_ERROR db "error occurred during disk reset! ", 0
RESET_SUCCESS db "Disk Successfully Reseted! ", 0
