gdt64_start:
gdt64_null:
    dd 0 ; null descriptor -> fill with all zeros
    dd 0

gdt64_code:
    dw 0FFFFh 			; limit low -> 0th-15th bit
    dw 0 				; base low -> 16th-31st bit
    db 0 				; base middle -> 32nd-39th bit
    db 10011010b 	    ; access (0x9A) -> 40th-47th bit
    db 10101111b 	    ; flags(0xA) + limit(0xFF) -> 48th-55th bit with the first four being flags and the last four being limit
    db 0 				; base high -> 56th-63rd bit

gdt64_data:
    dw 0FFFFh 			; limit low -> 0th-15th bit
    dw 0 				; base low -> 16th-31st bit
    db 0 				; base middle -> 32nd-39th bit
    db 10010010b 	    ; access (0x92) -> 40th-47th bit
    db 11001111b 	    ; flags(0xC) + limit(0xFF) -> 48th-55th bit with the first four being flags and the last four being limit
    db 0 				; base high -> 56th-63rd bit
end_of_gdt64:

gdtr_64:
    dw end_of_gdt64 - gdt64_null - 1   ;Size of the GDT
    dd gdt64_null                    ;Start of the GDT