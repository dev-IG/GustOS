; @brief First stage bootloader.
; @author Dev IG


bits 16     ; We're dealing with 16 bit code
org 0x7c00  ; Inform the assembler of the starting location for this code
KERNEL_OFFSET equ 0x1000 ;Address of where Kernel is located

start:
    jmp 0, next_line_code ;Long Jump to canonicalize %CS:%EIP

next_line_code:

    mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in DL , so it ’s best to remember this for later.

    mov bp, 0x7c00 ;set-up stack
    mov sp, bp

    ;Clear the Code, Data, Extra, Stack segments
    xor ax, ax
    mov ds, ax     ; Data segment
    mov es, ax     ; Extra segment
    mov ss, ax     ; Stack segment

    mov bx, MSG_REAL_MODE
    call print_string

    call load_kernel

    call switch_to_pm

    ; Go to error cause we should NOT ever visit here after handing control to boot1
    jmp error_handler

%include "gdt.asm"
%include "A20.asm"
%include "switch_to_pm.asm"
%include "print_string.asm"
%include "print_string_pm.asm"
%include "disk_load.asm"
%include "begin_pm.asm"
%include "switch_to_pm.asm"

; Prints `ERR: ` and the given error code to screen and hangs.
; parameter: error code (in ascii) in al
error_handler:
    ; Disable interrupts
    cli

    ; 2. Display error message (for example, printing to screen)
    mov dword [0xb8000], 0x4f524f45   ; "ERROR"
    mov dword [0xb8004], 0x4f3a4f52   ; ": OR"
    mov dword [0xb8008], 0x4f204f20   ; " O "
    mov byte  [0xb800a], al           ; Print error code (assuming it's in AL)

    ; 3. Permanently suspend progress in execution
    hlt


; Global variables
BOOT_DRIVE db 0
MSG_REAL_MODE db " Started in 16 - bit Real Mode " , 0
MSG_PROT_MODE db " Successfully landed in 32 - bit Protected Mode " , 0
MSG_LOAD_KERNEL db " Loading kernel into memory. " , 0

times 510-($-$$) db 0
dw 0xAA55 ; Magic Number to let BIOS know we are the boot sector