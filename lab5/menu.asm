section .bss
    choice resb 4

section .data
    menu  db 0xA, 'Select a process from 1 to 10, or enter 0 to exit:', 0xA
        db '1. Determining the larger of two numbers', 0xA
        db '2. Determining the smaller of two numbers', 0xA
        db '3. Checking if number is even or odd', 0xA
        db '4. Calculating the factorial of an integer', 0xA
        db '5. Adding a suffix to a string', 0xA
        db '6. Generating a random number', 0xA
        db '7. Adding two numbers', 0xA
        db '8. Subtraction of two numbers', 0xA
        db '9. Calculating the square root of a number', 0xA
        db '10. Finding the position of a character in a string', 0xA, 0
        db '0. Exit', 0xA, 0
    invalidOption db 'Invalid option. Please choose a number between 0 and 10.', 0xA, 0

section .text
global main, printMenuAndLoop
extern printString, larger, smaller, oddEven, factorial, suffix, random, sum, subtract, root, position

main:
    mov rdi, menu
    call printString

input_loop:
    call getInput
    call isDigit
    test rax, rax
    je printInvalidOption

    ; Check if second character is a digit or newline
    movzx eax, byte [choice+1]
    cmp rax, 0xA
    je processSingleDigit
    call isDigit
    test rax, rax
    je printInvalidOption

processSingleDigit:
    movzx eax, byte [choice]      ; Get first digit
    sub eax, '0'
    movzx edx, byte [choice+1]    ; Get second character
    cmp edx, 0xA                  ; Check if it's a newline
    je check_option               ; If newline, process single digit
    sub edx, '0'
    imul eax, eax, 10
    add eax, edx                  ; Combine digits

check_option:
    cmp eax, 10
    jg printInvalidOption   

    cmp eax , 0
    je exit

    cmp eax, 1
    je larger

    cmp eax, 2
    je smaller

    cmp eax, 3
    je oddEven

    cmp eax, 4
    je factorial

    cmp eax, 5
    je suffix

    cmp eax, 6
    je random

    cmp eax, 7
    je sum

    cmp eax, 8
    je subtract

    cmp eax, 9
    je root

    cmp eax, 10
    je position

    ; reset choice buffer
    jmp printMenuAndLoop

printMenuAndLoop:
    mov rdi, menu
    call printString
    jmp input_loop

getInput:
    mov rax, 0
    mov rdi, 0
    mov rsi, choice
    mov rdx, 3    ; Read 3 characters + newline
    syscall
    mov byte [rsi+2], 0 
    ret

isDigit:
    movzx eax, byte [rsi]  ; Load the character
    cmp eax, '0'
    jb not_digit
    cmp eax, '9'
    ja not_digit
    mov eax, 1
    ret
not_digit:
    xor eax, eax
    ret

printInvalidOption:
    mov rdi, invalidOption
    call printString
    jmp input_loop

exit:
    mov rax, 60
    xor rdi, rdi
    syscall