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

; subroutine to print a hex number.
;
; ```
; dx = the hexadecimal value to print
; ```
;
; Usage
;
; ```
; mov dx, 0x1fb6
; call print_hex
; ```
;
; Credit: https://stackoverflow.com/a/27686875/7132678
;
print_hex:
        ; push all registers onto the stack
        pusha
        ; use si to keep track of the current char in our template string
        mov si, HEX_OUT + 2
        ; start a counter of how many nibbles we've processed, stop at 4
        mov cx, 0

next_character:
        ; increment the counter for each nibble
        inc cx
        ; isolate this nibble
        mov bx, dx
        and bx, 0xf000
        shr bx, 4
        ; add 0x30 to get the ASCII digit value
        add bh, 0x30
        ; If our hex digit was > 9, it'll be > 0x39, so add 7 to get
        ; ASCII letters
        cmp bh, 0x39
        jg add_7

add_character_hex:
        ; put the current nibble into our string template
        mov [si], bh
        ; increment our template string's char position
        inc si
        ; shift dx by 4 to start on the next nibble (to the right)
        shl dx, 4
        ; exit if we've processed all 4 nibbles, else process the next
        ; nibble
        cmp cx, 4
        jnz next_character
        jmp _done

_done:
        ; copy the current nibble's ASCII value to a char in our template
        ; string
        mov bx, HEX_OUT
        ; print our template string
        call print_string
        ; pop all arguments
        popa
        ; return from subroutine
        ret

add_7:
        ; add 7 to our current nibble's ASCII value, in order to get letters
        add bh, 0x7
        ; add the current nibble's ASCII
        jmp add_character_hex

; our global template string. We'll replace the zero digits here with the
; actual nibble values from the hex input.
HEX_OUT:
        db '0x0000 ', 0

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