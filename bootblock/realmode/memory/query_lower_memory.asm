[bits 16]

[section .text]
query_lower_memory:
    clc ; clear carry flag
    xor ax, ax ; set ax to 0
    int 0x12 ; call interrupt to read the value of lower_memory into ax
    jc low_read_error
    inc ax  ; add 1 to account for the 1kb used by the BIOS
    ret

low_read_error:
    cli ;disable interrupts
    mov bx, LOW_READ_ERROR ;print error to allow tracing
    call print_string
    jmp $

LOW_READ_ERROR db 'error reading lower memory size ', 0