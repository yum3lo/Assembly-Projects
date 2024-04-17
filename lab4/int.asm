section .data
    prompt_msg: db 'Enter the first integer: ', 0       ; Null-terminated string for first prompt message
    prompt_msg2: db 'Enter the second integer: ', 0     ; Null-terminated string for second prompt message
    result_msg: db 'The result is: ', 0                 ; Null-terminated string for result message
    int_format: db '%d', 0                              ; Format string for reading and printing integers

section .bss
    input_value1: resd 1    ; Reserve space for the first input value
    input_value2: resd 1    ; Reserve space for the second input value
    result: resd 1          ; Reserve space for the result

section .text
    extern  _printf
    extern  _scanf

    global _main

_main:
    ; Display first prompt message
    push    dword prompt_msg
    call    _printf
    add     esp, 4                           ; Clean up the stack

    ; Read first input integer
    lea     eax, [input_value1]
    push    eax
    push    dword int_format                  ; Push format string for reading integer ("%d")
    call    _scanf
    add     esp, 8                           ; Clean up the stack

    ; Display second prompt message
    push    dword prompt_msg2
    call    _printf
    add     esp, 4                           ; Clean up the stack

    ; Read second input integer
    lea     eax, [input_value2]
    push    eax
    push    dword int_format                  ; Push format string for reading integer ("%d")
    call    _scanf
    add     esp, 8                           ; Clean up the stack

    ; Add the two values
    mov     eax, [input_value1]
    add     eax, [input_value2]
    mov     [result], eax

    ; Display result message
    push    dword result_msg
    call    _printf
    add     esp, 4                           ; Clean up the stack

    ; Print the result
    mov     eax, [result]
    push    eax
    push    dword int_format                  ; Push format string for printing integer ("%d")
    call    _printf
    add     esp, 8                           ; Clean up the stack

    ; Exit program
    mov     eax, 0
    ret