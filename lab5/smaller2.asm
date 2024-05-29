section .data
    prompt db "Enter a number: ", 0
    prompt2 db "Enter another number: ", 0
    firstMsg db "The first number is smaller.", 0xA, 0
    secondMsg db "The second number is smaller.", 0xA, 0
    equalMsg db "The numbers are equal.", 0xA, 0

section .bss
    num resb 3 ; space for two digits and newline
    num2 resb 3 ; space for two digits and newline

section .text
global smaller
extern printMenuAndLoop, printString

smaller:
    ; Prompt and read the first number
    mov rdi, prompt
    call printString
    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 3
    syscall
    mov byte [num + rax - 1], 0 ; Null-terminate the input

    ; Prompt and read the second number
    mov rdi, prompt2
    call printString
    mov rax, 0
    mov rdi, 0
    mov rsi, num2
    mov rdx, 3
    syscall
    mov byte [num2 + rax - 1], 0 ; Null-terminate the input

    ; Convert num and num2 to integers
    xor rax, rax
    xor rbx, rbx
    mov rsi, num
    call atoi
    mov rdx, rax   ; Store first number in rdx
    mov rsi, num2
    call atoi
    mov rcx, rax   ; Store second number in rcx

    ; Compare two numbers
    cmp rdx, rcx
    je equal_numbers
    ja second_smaller
    jb first_smaller

second_smaller:
    mov rdi, secondMsg
    call printString
    jmp finish

first_smaller:
    mov rdi, firstMsg
    call printString
    jmp finish

equal_numbers:
    mov rdi, equalMsg
    call printString

finish:
    jmp printMenuAndLoop

; Function: Convert ASCII string to integer (stores result in rax)
atoi:
    xor rax, rax ; Clear rax for result
atoi_loop:
    movzx rbx, byte [rsi] ; Load byte and zero-extend to 32-bit
    test rbx, rbx        ; Test if null-terminator
    jz atoi_done         ; If zero, end of string
    sub rbx, '0'         ; Convert from ASCII to integer
    imul rax, rax, 10    ; Multiply current result by 10
    add rax, rbx         ; Add new digit to result
    inc rsi              ; Move to next character
    jmp atoi_loop
atoi_done:
    ret