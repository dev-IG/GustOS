[bits 64]

[section .text]

long_mode_start:
    cli                           ; Clear the interrupt flag.
    mov ax, DATA_SEG              ; Set the A-register to the data descriptor.
    mov ds, ax                    ; Set the data segment to the A-register.
    mov es, ax                    ; Set the extra segment to the A-register.
    mov fs, ax                    ; Set the F-segment to the A-register.
    mov gs, ax                    ; Set the G-segment to the A-register.
    mov ss, ax                    ; Set the stack segment to the A-register.

    mov rax, 0x2f592f412f4b2f4f
    mov qword [0xb8000], rax
    hlt                           ; Halt the processor.


;Global Variables