bits 32
begin_pm:
    mov ebx, MST_PROT_MODE ; print message
    call print_string_pm
    call KERNEL_OFFSET ; enter and execute the kernel

    jmp error_handler ; handle error if we get here which we should not