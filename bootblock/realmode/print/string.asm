[bits 16]
[section .text]
print_string:
    pusha   ; save registers
    mov ah, 0x0e   ;Set AH to 0x0e so when we call int 0x10, BIOS calls the write to TTY
    jmp loop

loop:
    mov al, [bx]
    cmp al, 0
    je  finish
    int 0x10
    inc bx
    jmp loop

finish:
    popa    ; restore registers
    ret