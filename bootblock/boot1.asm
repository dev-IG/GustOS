; @brief First stage bootloader.
; @author Dev IG
bits 16
GLOBAL _start ; define global _start variable for boot1
_start:
    cli ; Disable interrupts if not already done


    call enable_A20 ; Enable A_20 Line


    ; TODO: load the global descriptor table
    ; TODO: Switch to protected mode -> Long Mode?
    ; TODO: Load segment registers
    ; TODO: Call bootmain for multiboot loader

    mov start, sp       ; Set stack pointer to 0x7C00 (start from boot0.asm points to 0x7C00)

boot_error_handler:
    ; Notify the user of a failure condition
    ; Disable interrupts (if not already disabled)
    cli
    mov dword [0xb8000], 0x4f524f45   ; "ERROR"
    mov dword [0xb8004], 0x4f3a4f52   ; ": OR"
    mov dword [0xb8008], 0x4f204f20   ; " O "
    mov dword [0xb800C], 0x4f524f46   ; "PROT" (Protected Mode)
    mov dword [0xb8010], 0x4f204f20   ; " O "
    mov dword [0xb8014], 0x4f444e49   ; "INDI" (Indicator)
    mov byte  [0xb800a], al           ; Print error code (assuming it's in AL)
    ; Permanently suspend progress in execution
    hlt

%include "boot0.asm"
%include "A20.asm"