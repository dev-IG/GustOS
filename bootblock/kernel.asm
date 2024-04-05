[bits 16]

[org 0xf000]
_kernel_start:
    mov bx, MSG_KERNEL_LOAD ;print message to show we are at boot1 now
    call print_string
    jmp $

;include files statement so nasm can pick these up and the respective functions can be referenced
%include "realmode/print/string.asm"
%include "realmode/print/hex.asm"
%include "realmode/print/registers.asm"


;Global Variables
MSG_KERNEL_LOAD db "Kernel successfully loaded! ", 0

