; boot1.asm
; First stage bootloader.
; @author Dev IG
[bits 16]
; VERY IMPORTANT TO SPECIFY ADDRESS!!!! Even if we are loading from disk, we need to give the org
; and it needs to match exactly with what boot0.asm has set its START_OF_BOOT_1 value to
[org 0x1000]
_start:
    cli     ;disable interrupts once we jump to this stage

    mov bx, MSG_BOOT_ONE_LOAD ;print message to show we are at boo1 now
    call print_string

    jmp $

;include files statement so nasm can pick these up and the respective functions can be referenced
%include "print_string_rm.asm"

; Global variables
MSG_BOOT_ONE_LOAD db "Boot 1 successfully loaded! ", 0

