; reset.asm
; Function call to reset disk
; @author Dev IG
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
    cli
    mov bx, RESET_ERROR
    call print_string
    call print_registers
    jmp $

RESET_ERROR db "er: disk reset ", 0
RESET_SUCCESS db "success: disk reset ", 0