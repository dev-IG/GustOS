[bits 16]

[section .text]
SMAP equ 0x0534D4150
ENTRY_SIZE equ 24
EAX_VALUE equ 0xE820

query_upper_memory:
    mov di, entry_description ;point ES:DI at the destination buffer for the list
    xor ebx, ebx ;clear ebx
    xor bp, bp   ; clear bp to keep track of entry count
    mov edx, SMAP ;set edx to signature
    mov eax, EAX_VALUE
    mov [es:di + 20], dword 1	; force a valid ACPI 3.X entry
    mov ecx, ENTRY_SIZE

    int 0x15 ;first call

    jc unsupported_function ;if carry flag set for first call, it is unsupported
    mov edx, SMAP ;edx is trashed after 0x15 on some BIOSes, just set it to SMAP
    cmp eax, edx ;eax needs to be set to SMAP
    jne invalid_eax_for_e820


e820_call:
    cmp ebx, 0 ;if ebx is zero, we only have a valid lower-memory entry
    je upper_finish
    ; calling 0x15 trashes all registers so we gotta reset our registers to be able to call it
    mov eax, 0xE820
    mov edx, SMAP
    mov ecx, ENTRY_SIZE
    int 0x15

check_val:
    jcxz skip_entry ; checks if it's a zero length entry which we ignore
    cmp cl, 20		; got a 24 byte ACPI 3.X response?Z
    jbe parse_entry ; If not usable go onto next entry
    test dword [Type], 0x1 ; if so: is the "ignore this data" bit clear?
    je skip_entry

parse_entry:
    mov ecx, [LengthLow] ;get lower length
    or ecx, [LengthHigh] ; or with upper to test for zero
    jz skip_entry
    inc bp ;valid entry so increment bp
    jmp e820_call

skip_entry:
    cmp ebx, 0
    jne e820_call
    jmp upper_finish

upper_finish:
    clc ;clear carry bit since we get here on successful e820
    ret

unsupported_function:
    cli ;disable interrupts
    mov bx, UNSUPPORTED_FUNCTION_ERROR ;print error to allow tracing
    call print_string
    jmp $

invalid_eax_for_e820:
    cli ;disable interrupts
    mov bx, INVALID_EAX_ERROR ;print error to allow tracing
    call print_string
    jmp $

;Global Variables
UNSUPPORTED_FUNCTION_ERROR db 'unsupported function ', 0
INVALID_EAX_ERROR db 'eax not set to 0x0534D4150 after first call to 0x15 ', 0

entry_description:
BaseAddrLow dd 0
BaseAddrHigh dd 0
LengthLow dd 0
LengthHigh dd 0
Type dd 0
ACPI_3 dd 0