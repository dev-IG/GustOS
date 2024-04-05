[bits 32]

[section .text]
PROTECTED_MODE_STACK equ 0xe000 ;Start of protected mode stack
PM4LT equ 0x101000 ;Start Address of PM4LT - Page Table Level 4
PDPT equ 0x102000 ;Start Address of PDPT - Page Table Level 3
PDT equ 0x103000 ;Start Address of PDT - Page Table Level 2
PT equ 0x104000 ;Start Address of PT - Page Table Level 1
PG_PRESENT equ 0x1 ;0th bit set means page is present
PG_R_W equ 0x2  ;1st bit set means page is read/write enabled
PG_LAST equ 0x80 ;8th bit set means this is the past page frame

;Credit for long-mode setup: https://wiki.osdev.org/Setting_Up_Long_Mode
protected_mode_start:
    ;set all of the segment registers with the data segment selector
    ; corresponding to the data segment descriptor loaded in the temporary GDT
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov sp, PROTECTED_MODE_STACK ;set stack pointer

    mov bx, MSG_PROT_MODE ;print message of arriving in protected mode
    call print_string_pm

    call check_cpuid ;check for cpuid instruction. On failure, a msg will be printed informing of a lack of instruction

    ;check for ability to go into long-mode
    mov eax, 80000000h  ; Extended-function 8000000h.
    cpuid              ; Is largest extended function
    cmp eax, 80000000h  ; any function > 80000000h?
    jbe no_long_mode     ; If not, no long mode.
    mov eax, 80000001h ; Extended-function 8000001h.
    cpuid               ; Now EDX = extended-features flags.
    bt edx, 29      ; Test if long mode is supported.
    jnc no_long_mode      ; Exit if not supported.

    ; Need to now set up paging to properly go into long mode
    ; First, clear tables
    mov edi, PM4LT    ; Set the destination index to 0x1000.
    mov cr3, edi       ; Set control register 3 to the destination index.
    xor eax, eax       ; Nullify the A-register.
    mov ecx, 4096      ; Set the C-register to 4096.
    rep stosd          ; Clear the memory.
    mov edi, cr3       ; Set the destination index to control register 3.

    ;point PML4T[0] to point to PDPT, PDT, and then PT
    mov DWORD [edi], 0x102003    ; Set the uint32_t at the destination index to 0x102003.
    add edi, 0x1000              ; Add 0x1000 to the destination index.
    mov DWORD [edi], 0x103003    ; Set the uint32_t at the destination index to 0x103003.
    add edi, 0x1000             ; Add 0x10000 to the destination index.
    mov DWORD [edi], 0x104003    ; Set the uint32_t at the destination index to 0x104003.
    add edi, 0x1000             ; Add 0x10000 to the destination index.

    mov ebx, 0x00000003          ; Set the B-register to 0x00000003.
    mov ecx, 512                 ; Set the C-register to 512 for the 512 entries

set_entry:
    mov DWORD [edi], ebx         ; Set the uint32_t at the destination index to the B-register.
    add ebx, 0x1000               ; Add 0x10000 to the B-register.
    add edi, 8                   ; Add eight to the destination index.
    loop set_entry               ; Set the next entry.


    ;enable pae-paging
    mov eax, cr4                 ; Set the A-register to control register 4.
    or eax, 1 << 5               ; Set the PAE-bit, which is the 6th bit (bit 5).
    mov cr4, eax                 ; Set control register 4 to the A-register.

    ; start the switch to long mode by setting the LM-bit
    mov ecx, 0xC0000080          ; Set the C-register to 0xC0000080, which is the EFER MSR.
    rdmsr                        ; Read from the model-specific register.
    or eax, 1 << 8               ; Set the LM-bit which is the 9th bit (bit 8).
    wrmsr                        ; Write to the model-specific register.

    ;enable paging
    mov eax, cr0                 ; Set the A-register to control register 0.
    or eax, 1 << 31              ; Set the PG-bit, which is the 32nd bit (bit 31).
    mov cr0, eax                 ; Set control register 0 to the A-register.


    lgdt [gdtr_64] ;load 64 bit gdt
    jmp CODE_SEG:long_mode_start

    jmp long_mode_jump_error

no_long_mode:
    mov bx, MSG_NO_LONG_MODE
    call print_string_pm
    hlt

long_mode_jump_error:
    mov bx, MSG_LONG_MODE_JUMP_ERROR
    call print_string_pm
    hlt

;include files statement so nasm can pick these up and the respective functions can be referenced
%include "protectedmode/print/print_string.asm"
%include "protectedmode/cpuid/check_cpuid.asm"
%include "gdt/gdt_64.asm"
%include "boot3.asm"


; Global variables
MSG_PROT_MODE db " Successfully landed in 32 - bit Protected Mode " , 0
MSG_NO_LONG_MODE db " Can't jump into long mode: archiecture doesn't allow it? " , 0
MSG_LONG_MODE_JUMP_ERROR db " Failed to jump into long mode after setting up paging and gdt  " , 0
PAGING_SETUP_SUCCESS db " Paging successfully set up to jump into long mode  " , 0
