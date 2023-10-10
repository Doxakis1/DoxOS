ORG 0x7c00
BITS 16 ; Legacy boot loaders start with 16 bits


start:
    mov     si, message
    call    print_string
    jmp     $ ; locks booter for now
print_string:
    mov     bx, 0
    lodsb          ; loads next char from si to al and incriments si by 1
    cmp     al, 0 ;checks for string terminator
    je      .done
    mov     ah, 0eh ; Puts BIOS interupt '0e' to print one char from al
    int     0x10 ; BIOS interupt to print one char from ah
    jmp     print_string ; Back to main loop
.done:
    ret
message: db 'Welcome to DoxOS', 10, 0

times 510-($ - $$) db 0 ; In order to be a bootable sector it must have '0xAA55' at the 512th byte location, hence I fill the memory with empty space until that location using the asm times function 
dw 0xAA55
