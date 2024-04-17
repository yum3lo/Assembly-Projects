        section  .data
        message: db   'Hello world! This is my lab for AC', 0xA, 0  ; text message
                    ; 0xA (10) is hex for (newline character)
                    ; 0 terminates the line

        section .text
        global    _main           ; declare main() method
        extern    _printf         ; link to external library
_main:                            ; the entry point! void main()
        push    message           ; save message to the stack
        call    _printf           ; display the first value on the stack
        add     esp, 4            ; clear the stack
        ret                       ; return