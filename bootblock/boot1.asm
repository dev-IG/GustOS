; boot1.asm
; First stage bootloader.
; @author Dev IG
[bits 16]
; VERY IMPORTANT TO SPECIFY ADDRESS!!!! Even if we are loading from disk, we need to give the org
; and it needs to match exactly with what boot0.asm has set its START_OF_BOOT_1 value to
[org 0x1000]
LOWER_MEMORY_REQUIRE equ 0x280 ; Required amount of lower memory. Needs to be = 640
UPPER_MEMORY_REQUIRE equ 0x05 ; should have 5 entries for upper memory
_start:
    mov [DRIVE_NUMBER], dl ;We are using dx here, so before anything, we need to record and store the value of the drive number which the dl(lower 8 bits of dx) has currently
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

    ;load the contents of the kernel from disk to low memory
    call load_kernel
    jmp 0xf000
    call enable_a20

    jmp transition_to_protected_mode

transition_to_protected_mode:
    cli ;disable interrupts
    lgdt [gdtr_32]

    mov eax, cr0    ; eax = c20
    or eax, 0x1     ; eax |= 0x1 to set the protection bit
    mov cr0, eax    ; cr0 = eax

    jmp CODE_SEG:protected_mode_start

    jmp error ; we don't expected to return from the jump above so if we do, need to return error



error:
    cli ;disable interrupts
    mov bx, MSG_ERROR ;print error to allow tracing
    call print_string
    jmp $

;include files statement so nasm can pick these up and the respective functions can be referenced
%include "realmode/print/string.asm"
%include "realmode/print/hex.asm"
%include "realmode/print/registers.asm"
%include "realmode/memory/query_lower_memory.asm"
%include "realmode/memory/query_upper_memory.asm"
%include "realmode/disk/kernel_load.asm"
%include "realmode/disk/lba_to_chs.asm"
%include "realmode/a20/check_a20.asm"
%include "realmode/a20/enable_a20.asm"
%include "gdt/gdt_32.asm"
%include "boot2.asm"

; Global variables
DRIVE_NUMBER db 0
MSG_BOOT_ONE_LOAD db "Boot 1 successfully loaded! ", 0
MSG_ERROR db "Failed to jump into protected mode stage! ", 0
LOW_MEM_SIZE_ERROR db 'lower memory size not enough: ', 0
LOW_MEM_SUCCESS db 'lower memory: ', 0
UPPER_MEM_SIZE_ERROR db 'upper memory size not enough: ', 0
UPPER_MEM_SUCCESS db 'upper memory: ', 0
KB_STR db 'kb ', 0
ENTRIES_STR db 'entries ', 0
LOWER_MEM_SIZE db 0
UPPER_MEM_SIZE db 0