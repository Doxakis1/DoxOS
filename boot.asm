ORG 0
BITS 16 ; Legacy boot loaders start with 16 bits

; BIOS Parameter block error prevention code following (read more online about this if interested)
_biosprotect:
    jmp short init_cs
    nop
times 33 db 0 ; Makes 33 bytes for the needed block
; BIOS Parameter block ends here
init_cs:
    jmp 0x7c0:init ; this makes our cs (code segement) be the correct 0x7c0
init:
    cli     ; stops interupts through the use of the interupt flag
    mov     ax, 0x7c0 ; we cannot use intermidiates to load to ds and es hence we use ax
    mov     ds, ax ; we make datasegment(data offset) be 0x7c0
    mov     es, ax ; we do the same for extra segment (extra segment offset) be 0x7c0
    mov     ax, 0x00 
    mov     ss, ax  ; we put 0 into the stack segment(offset) with the use of ax
    mov     sp, 0x7c00 ; we put our stackpointer to our Origin at 0x7c00
    sti     ; re-enables interupts
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
