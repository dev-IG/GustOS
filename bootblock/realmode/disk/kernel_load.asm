[bits 16]
; Kernel is located at the 36th block (sector) and goes to another 1,152 blocks
; Need to read each sector by sector from LBA to CHS
[section .text]
START_OF_KERNEL_PRELOAD equ 0xf000 ;Address of where the kernel needs to be loaded into
START_OF_SECTOR_READ equ 0x24 ;Kernel is located at 36th sector
SECTORS_TO_READ equ 0x480 ;Need to read 1152 blocks
BYTES_PER_SECTOR equ 0x200; 512 bytes per sector
load_kernel:
    pusha
    mov bx, START_OF_KERNEL_PRELOAD ; load into bx the start of the kernel preload
    mov ax, START_OF_SECTOR_READ ; load into ax the sector to start from
    mov cx, SECTORS_TO_READ ;load into cx the number of sectors to read
sector_loop:
    push ax
    push bx
    push cx
    push bx

    call LBACHS                              ; convert starting sector to CHS
    mov ah, 0x02
    mov dl, [DRIVE_NUMBER] ;set dl to point to saved drive number
    mov al, 1    ; read 1 sector
    pop bx
    int 0x13

    jc kernel_load_error
    pop cx
    pop bx
    pop ax
    inc ax  ;queue next sector
    add bx, BYTES_PER_SECTOR ;add to bx for next 512 address
    loop sector_loop
    mov bx, KERNEL_LOAD_SUCCESS
    call print_string
    popa
    ret

kernel_load_error:
    cli
    call print_registers
    mov bx, KERNEL_LOAD_ERROR
    call print_string
    jmp $

;Global Variables
KERNEL_LOAD_SUCCESS db "success: kernel load ", 0
KERNEL_LOAD_ERROR db "error: kernel load ", 0
