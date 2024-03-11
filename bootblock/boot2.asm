[bits 32]

[section .text]

protected_mode_start:
    hlt


;include files statement so nasm can pick these up and the respective functions can be referenced
%include "protectedmode/print/print_string.asm"


; Global variables