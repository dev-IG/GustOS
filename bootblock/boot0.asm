; boot0.asm
; Zeroth stage bootloader.
; @author Dev IG
[bits 16]
[org 0x7c00]
REAL_MODE_STACK equ 0x7000 ;Address of where Kernel is located
START_OF_BOOT_1 equ 0x1000 ;Address of where the start of boot 1 is located
[section .text]
    global _start
_start:
    cli                     ;disable interrupts
    jmp 0000h:setup         ; Canonicalization CS:EIP

setup:
    mov bx, MSG_REAL_MODE   ; push starting addr of message to indicate 16 bit mode to bx
    call print_string       ; Call print_string to print the message

    ;Zero out segment registers
    xor ax, ax ; ax = 0
    mov ds, ax ;ds = 0 -> data segment
    mov es, ax ;es = 0 -> extra segment
    mov ss, ax ;ss = 0 -> stack segment
    mov fs, ax ;fs = 0 -> gen purpose
    mov gs, ax ;gs = 0 -> gen purpose

    mov sp, REAL_MODE_STACK ;set up stack pointer

    sti ; enable interrupts

    mov [DRIVE_NUMBER], dl ;Before we reset the disk, we need to record and store the value of the drive number which the dl has currently
    call reset_disk_controller
    call load_boot_1
    jmp START_OF_BOOT_1 ;Address of where the start of boot 1 is located
    jmp $

;include files statement so nasm can pick these up and the respective functions can be referenced
%include "print_rm.asm"
%include "disk.asm"

; Global variables
DRIVE_NUMBER db 0
MSG_REAL_MODE db "Started in 16-bit Real Mode ", 0
times 510-($-$$) db 0
dw 0xAA55 ; Magic Number to let BIOS know we are the boot sector
