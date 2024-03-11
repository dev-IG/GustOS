; Code for the global descriptor table for 32-bit protected mode
; contains the null, code and data descriptions where each is 8 bytes
; DB - Define Byte. 8 bits
; DW - Define Word. Generally 2 bytes on a typical x86 32-bit system
; DD - Define double word. Generally 4 bytes on a typical x86 32-bit system
gdt32_start:
gdt32_null:
    dd 0 ; null descriptor -> fill with all zeros
    dd 0

gdt32_code:
    dw 0FFFFh 			; limit low -> 0th-15th bit
    dw 0 				; base low -> 16th-31st bit
    db 0 				; base middle -> 32nd-39th bit
    db 10011010b 	    ; access (0x9A) -> 40th-47th bit
    db 11001111b 	    ; flags(0xC) + limit(0xFF) -> 48th-55th bit with the first four being flags and the last four being limit
    db 0 				; base high -> 56th-63rd bit

gdt32_data:
    dw 0FFFFh 			; limit low -> 0th-15th bit
    dw 0 				; base low -> 16th-31st bit
    db 0 				; base middle -> 32nd-39th bit
    db 10010010b 	    ; access (0x92) -> 40th-47th bit
    db 11001111b 	    ; flags(0xC) + limit(0xFF) -> 48th-55th bit with the first four being flags and the last four being limit
    db 0 				; base high -> 56th-63rd bit
end_of_gdt32:

gdtr_32:
    dw end_of_gdt32 - gdt32_null - 1   ;Size of the GDT
    dd gdt32_null                    ;Start of the GDT

CODE_SEG equ gdt32_code - gdt32_start
DATA_SEG equ gdt32_data - gdt32_start