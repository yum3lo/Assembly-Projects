section .data
    prompt db "Enter a number: ", 0
    prompt2 db "Enter another number: ", 0
    subMsg db "The difference is: ", 0
    newline db 10, 0

section .bss
    num resb 3
    num2 resb 3
    res resb 5

section .text
global subtract
extern printMenuAndLoop, printString

subtract:
    ; Prompt and read the first number
    mov rdi, prompt
    call printString
    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 3
    syscall

    ; Prompt and read the second number
    mov rdi, prompt2
    call printString
    mov rax, 0
    mov rdi, 0
    mov rsi, num2
    mov rdx, 3
    syscall

    ; Convert ASCII digits to integers
    movzx eax, byte [num]
    sub eax, '0'
    movzx edx, byte [num2]
    sub edx, '0'

    ; Calculate the difference
    sub eax, edx

    ; Convert the difference back to ASCII
    add al, '0'

    ; Store the result
    mov [res], al
    mov byte [res + 1], 0xA ; newline
    mov byte [res + 2], 0   ; null-terminator

    ; Display subtraction message
    mov rdi, subMsg
    call printString

    ; Display result directly using sys_write
    mov rax, 1 ; sys_write
    mov rdi, 1 ; stdout
    mov rsi, res
    mov rdx, 2 ; length of the result string
    syscall

    ; Print newline
    mov rdi, newline
    call printString

    ; Return to the main loop or menu
    jmp printMenuAndLoop