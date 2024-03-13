[bits 32]

[section .text]
DATA_SEG equ 0x10 ;Offset to the data segment in GDT which is 16 bytes or 0x10 in hex
PROTECTED_MODE_STACK equ 0xf000 ;Address of where Kernel is located
protected_mode_start:
    ;set all of the segment registers with the data segment selector
    ; corresponding to the data segment descriptor loaded in the temporary GDT
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov sp, PROTECTED_MODE_STACK ;set stack pointer


    mov bx, MSG_PROT_MODE
    call print_string_pm

    hlt


;include files statement so nasm can pick these up and the respective functions can be referenced
%include "protectedmode/print/print_string.asm"


; Global variables
MSG_PROT_MODE db " Successfully landed in 32 - bit Protected Mode " , 0
