[bits 16]

[section .text]
SMAP equ 0x0534D4150
ENTRY_SIZE equ 20
query_upper_memory:
    mov di, entry_description ;point ES:DI at the destination buffer for the list
    xor ebx, ebx ;clear ebx
    mov edx, SMAP ;set edx to signature
    mov eax, 0xE820
    mov ecx, ENTRY_SIZE

    int 0x15 ;first call





;Global Variables
entry_description:
BaseAddrLow dd 0
BaseAddrHigh dd 0
LengthLow dd 0
LengthHigh dd 0
Type dd 0