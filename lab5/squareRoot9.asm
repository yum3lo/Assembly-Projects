section .data
    prompt db 'Enter an integer from 0 to 9: ', 0
    squareRoot_0 db '0', 0
    squareRoot_1 db '1', 0
    squareRoot_2 db '1.4142', 0
    squareRoot_3 db '1.7320', 0
    squareRoot_4 db '2', 0
    squareRoot_5 db '2.2360', 0
    squareRoot_6 db '2.4495', 0
    squareRoot_7 db '2.6457', 0
    squareRoot_8 db '2.8284', 0
    squareRoot_9 db '3', 0
    resultMsg db 'The square root is: ', 0
    newline db 10, 0

section .bss
    input resb 2

section .text
global root
extern printString, printMenuAndLoop

root:
    ; Print the prompt
    mov rdi, prompt
    call printString

    ; Get user input
    mov rax, 0          ; syscall number for sys_read
    mov rdi, 0          ; file descriptor (stdin)
    mov rsi, input      ; buffer to store input
    mov rdx, 2          ; number of bytes to read (including newline)
    syscall

    mov rdi, resultMsg
    call printString

    ; Compare input and jump to corresponding print label
    cmp byte [input], '0'
    je print_0
    cmp byte [input], '1'
    je print_1
    cmp byte [input], '2'
    je print_2
    cmp byte [input], '3'
    je print_3
    cmp byte [input], '4'
    je print_4
    cmp byte [input], '5'
    je print_5
    cmp byte [input], '6'
    je print_6
    cmp byte [input], '7'
    je print_7
    cmp byte [input], '8'
    je print_8
    cmp byte [input], '9'
    je print_9

; Print the square roots based on the input
print_0:
    mov rdi, squareRoot_0
    jmp print_newline

print_1:
    mov rdi, squareRoot_1
    jmp print_newline

print_2:
    mov rdi, squareRoot_2
    jmp print_newline

print_3:
    mov rdi, squareRoot_3
    jmp print_newline

print_4:
    mov rdi, squareRoot_4
    jmp print_newline

print_5:
    mov rdi, squareRoot_5
    jmp print_newline

print_6:
    mov rdi, squareRoot_6
    jmp print_newline

print_7:
    mov rdi, squareRoot_7
    jmp print_newline

print_8:
    mov rdi, squareRoot_8
    jmp print_newline

print_9:
    mov rdi, squareRoot_9
    jmp print_newline

print_newline:
    call printString

    mov rdi, newline
    call printString

    jmp printMenuAndLoop