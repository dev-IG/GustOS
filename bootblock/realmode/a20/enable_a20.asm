[bits 16]

[section .text]

enable_a20:
    pusha ;save all registers
    call check_a20
    cmp ax, 1;
    je enable_a20_finish
    jmp a20_method_1

; try enabling from BIOS
a20_method_1:
    mov ax, 0x2402
    int 0x15
    call check_a20
    cmp ax, 1
    je enable_a20_finish
    jmp a20_method_2

;Try via system port
a20_method_2:
    in al, 0x92
    or al, 2
    out 0x92, al
    call check_a20
    cmp ax, 1
    je enable_a20_finish
    jmp a20_method_3

;Finally try via keyboard controller
;credit: http://independent-software.com/operating-system-development-enabling-a20-line.html
a20_method_3:
    cli                        ; Disable interrupts

    call    Wait_8042_command  ; When controller ready for command
    mov     al,0xAD            ; Send command 0xad (disable keyboard).
    out     0x64,al

    call    Wait_8042_command  ; When controller ready for command
    mov     al,0xD0            ; Send command 0xd0 (read from input)
    out     0x64,al

    call    Wait_8042_data     ; When controller has data ready
    in      al,0x60            ; Read input from keyboard
    push    eax                ; ... and save it

    call    Wait_8042_command  ; When controller is ready for command
    mov     al,0xD1            ; Set command 0xd1 (write to output)
    out     0x64,al

    call    Wait_8042_command  ; When controller is ready for command
    pop     eax                ; Write input back, with bit #2 set
    or      al,2
    out     0x60,al

    call    Wait_8042_command  ; When controller is ready for command
    mov     al,0xAE            ; Write command 0xae (enable keyboard)
    out     0x64,al

    call    Wait_8042_command  ; Wait until controller is ready for command

    sti                        ; Enable interrupts

    call check_a20
    cmp ax, 1
    je enable_a20_finish
    jmp a20_error

Wait_8042_data:
    in      al,0x64
    test    al,1
    jz      Wait_8042_data
    ret

Wait_8042_command:
    in      al,0x64
    test    al,2
    jnz     Wait_8042_command
    ret

a20_error:
    cli ;disable interrupts
    mov bx, A20_ERROR ;print error to allow tracing
    call print_string
    jmp $

enable_a20_finish:
    mov bx, A20_SUCCESS
    call print_string
    popa ;restore all registers
    ret


A20_ERROR db "Could not activate a20 line! ", 0
A20_SUCCESS db "A20 Line active! ", 0