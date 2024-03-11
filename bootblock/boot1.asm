; boot1.asm
; First stage bootloader.
; @author Dev IG
[bits 16]
; VERY IMPORTANT TO SPECIFY ADDRESS!!!! Even if we are loading from disk, we need to give the org
; and it needs to match exactly with what boot0.asm has set its START_OF_BOOT_1 value to
[org 0x1000]
PROTECTED_MODE_STACK equ 0xF000 ;Address of where Kernel is located
LOWER_MEMORY_REQUIRE equ 0x280 ; Required amount of lower memory. Needs to be = 640
UPPER_MEMORY_REQUIRE equ 0x05 ; should have 5 entries for upper memory
_start:
    mov bx, MSG_BOOT_ONE_LOAD ;print message to show we are at boot1 now
    call print_string

    call query_lower_memory ;load the size of lower memory into ax
    mov [LOWER_MEM_SIZE], ax ;store the value of ax before checking. Incase ax gets changed somewhere along the way
    cmp ax, LOWER_MEMORY_REQUIRE ;compare ax to the necessary amount of lower memory
    jl not_enough_low_mem
    jmp low_mem_success

not_enough_low_mem:
    cli ;disable interrupts
    mov bx, LOW_MEM_SIZE_ERROR ;print error to allow tracing
    call print_string
    mov dx, [LOWER_MEM_SIZE]
    call print_hex
    mov bx, KB_STR
    call print_string
    jmp $

low_mem_success:
    mov bx, LOW_MEM_SUCCESS ;print success message for correct lower memory size
    call print_string
    mov dx, [LOWER_MEM_SIZE]
    call print_hex
    mov bx, KB_STR
    call print_string

    call query_upper_memory
    mov [UPPER_MEM_SIZE], bp ;Store the value of the upper memory size returned from call
    cmp bp, UPPER_MEMORY_REQUIRE ;need the count of entries to be = 5
    jne not_enough_upper_memory
    jmp upper_memory_success

not_enough_upper_memory:
    cli ;disable interrupts
    mov bx, UPPER_MEM_SIZE_ERROR ;print error to allow tracing
    call print_string
    mov dx, [UPPER_MEM_SIZE]
    call print_hex
    mov bx, ENTRIES_STR
    call print_string
    jmp $

upper_memory_success:
    mov bx, UPPER_MEM_SUCCESS ;print success message for correct upper memory size
    call print_string
    mov dx, [UPPER_MEM_SIZE]
    call print_hex
    mov bx, ENTRIES_STR
    call print_string

    call enable_a20
    jmp error

error:
    cli ;disable interrupts
    mov bx, MSG_ERROR ;print error to allow tracing
    call print_string
    jmp $

;include files statement so nasm can pick these up and the respective functions can be referenced
%include "realmode/print/string.asm"
%include "realmode/print/hex.asm"
%include "realmode/memory/query_lower_memory.asm"
%include "realmode/memory/query_upper_memory.asm"
%include "realmode/a20/check_a20.asm"
%include "realmode/a20/enable_a20.asm"

; Global variables
MSG_BOOT_ONE_LOAD db "Boot 1 successfully loaded! ", 0
MSG_ERROR db "Error Occured! ", 0
LOW_MEM_SIZE_ERROR db 'lower memory size not enough: ', 0
LOW_MEM_SUCCESS db 'lower memory: ', 0
UPPER_MEM_SIZE_ERROR db 'upper memory size not enough: ', 0
UPPER_MEM_SUCCESS db 'upper memory: ', 0
KB_STR db 'kb ', 0
ENTRIES_STR db 'entries ', 0
LOWER_MEM_SIZE db 0
UPPER_MEM_SIZE db 0