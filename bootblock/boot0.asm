; @brief First stage bootloader.
; @author Dev IG

bits 16     ; We're dealing with 16 bit code
GLOBAL start ; define global start variable for boot0
org 0x7c00  ; Inform the assembler of the starting location for this code
start:
    cli     ; Disable Interrupts
    ljmp 0, next_line_code ;Long Jump to canonicalize %CS:%EIP


next_line_code:
    ;Clear the Code, Data, Extra, Stack segments
    xor ax, ax
    xor ax, cs     ; Code segment
    mov ax, ds     ; Data segment
    mov ax, es     ; Extra segment
    mov ax, ss     ; Stack segment


    ; Step 6: Jump to boot1 code
    call _start


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

%include "boot1.asm"
dw 0xAA55 ; Magic Number to let BIOS know we are the boot sector