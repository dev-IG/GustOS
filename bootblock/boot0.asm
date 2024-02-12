; @brief First stage bootloader.
; @author Dev IG

bits 16     ; We're dealing with 16 bit code
org 0x7c00  ; Inform the assembler of the starting location for this code

start:
    mov ah, 0x0e   ;Set AH to 0x0e so when we call int 0x10, BIOS calls the write to TTY

    mov bx, the_secret
    jmp loop

loop:
    mov al, [bx]
    cmp al, 0
    je  halt
    int 0x10
    inc bx
    jmp loop

halt:
    jmp $

the_secret:
    db 'HELLO WORLD', 0

; Mark the device as bootable
times 510-($-$$) db 0 ; Add any additional zeroes to make 510 bytes in total
dw 0xAA55 ; Magic Number to let BIOS know we are the boot sector