; Function to print register information
print_registers:
    pusha   ;save registers
    push bx

    ;Print DX register Value
    mov bx, MSG_DX
    call print_string
    call print_hex

    ; Print BX register value
    mov dx, bx
    mov bx, MSG_BX
    call print_string
    pop bx
    mov dx, bx
    call print_hex

    ; Print AX register value
    mov bx, MSG_AX
    call print_string
    mov dx, ax
    call print_hex

    ; Print CX register value
    mov bx, MSG_CX
    call print_string
    mov dx, cx
    call print_hex

    ; Print DI register value
    mov bx, MSG_DI
    call print_string
    mov dx, di
    call print_hex

    ; Print SI register value
    mov bx, MSG_SI
    call print_string
    mov dx, si
    call print_hex

    ; Print DS register value
    mov bx, MSG_DS
    call print_string
    mov dx, ds
    call print_hex

    ; Print ES register value
    mov bx, MSG_ES
    call print_string
    mov dx, es
    call print_hex

    ; Print SS register value
    mov bx, MSG_SS
    call print_string
    mov dx, ss
    call print_hex

    ; Print CS register value
    mov bx, MSG_CS
    call print_string
    mov dx, cs
    call print_hex

    popa    ;restore registers
    ret

MSG_AX db "AX: ", 0
MSG_BX db "BX: ", 0
MSG_CX db "CX: ", 0
MSG_DX db "DX: ", 0
MSG_DI db "DI: ", 0
MSG_SI db "SI: ", 0
MSG_DS db "DS: ", 0
MSG_ES db "ES: ", 0
MSG_SS db "SS: ", 0
MSG_CS db "CS: ", 0