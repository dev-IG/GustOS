switch_to_pm:
    cli             ; disable interrupts
    call enable_A20 ; Enable A_20 Line
    lgdt [gdt_32_descriptor] ; Load GDT

    mov [BOOT_DRIVE], dl ;Load boot drive from dl to addr of BOOT DRIVE

    mov eax, cr0    ; eax = c20
    or eax, 0x1     ; eax |= 0x1 to set the protection bit
    mov cr0, eax    ; cr0 = eax

    jmp CODE_SEG:start_protected_mode

bits 32
STACK equ 0x7c00 ;Address that stack will start off at.
start_protected_mode:
    ; Load segment registers
    mov ax, DATA_SEG    ; ax = data-seg
    mov ds, ax          ; Data segment
    mov es, ax          ; Extra segment
    mov ss, ax          ; Stack segment
    mov 0, ax           ; set ax to 0 to clear other non-needed
    mov fs, ax          ; fs = 0
    mov gs, ax          ; gs = 0

    mov ebp, 0x9000
    mov esp, STACK       ; Set stack pointer to 0x7C00 (start from boot.asm points to 0x7C00)

    call begin_pm       ; Call function to start kernel