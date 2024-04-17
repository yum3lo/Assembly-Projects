        global    _main                ; declare main() method
        extern    _printf              ; link to external library
        extern    _scanf             

        segment .data
        prompt_msg: db  'Enter an integer value: ', 0       
                        ; Null-terminated string for prompt message
        int_format: db '%d', 0   
                        ; Format string for reading and printing integers

        section .bss
        input_value resd 1  ; Reserve space for the input value

        section .text
_main:
    ; Display prompt message
    push    dword prompt_msg
    call    _printf
    add     esp, 4          ; Clean up the stack

    ; Read input integer
    lea     eax, [input_value]
    push    eax
    push    dword int_format    ; Push format string for reading integer ("%d")
    call    _scanf
    add     esp, 8              ; Clean up the stack

    ; Print the value
    mov     eax, [input_value]
    push    eax
    push    dword int_format    ; Push format string for printing integer ("%d")
    call    _printf
    add     esp, 8              ; Clean up the stack

    ; Exit program
    mov     eax, 0
    ret