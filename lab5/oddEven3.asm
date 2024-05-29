section .data
    prompt db "Enter a number: ", 0
    oddMsg db "The number is odd", 0xA, 0
    evenMsg db "The number is even", 0xA, 0

section .bss
    num resb 3 ; space for two digits and newline

section .text
global oddEven
extern printMenuAndLoop, printString

oddEven:
    ; Prompt and read the first number
    mov rdi, prompt
    call printString
    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 3
    syscall
    mov byte [num + rax - 1], 0 ; Null-terminate the input


    ; Convert num and num2 to integers
    xor rax, rax
    xor rbx, rbx
    mov rsi, num
    call atoi
    mov rdx, rax   ; Store first number in rdx
    
    ; Check if the number is even or odd
    mov rax, rdx
    mov rdi, 2
    xor rdx, rdx
    div rdi
    cmp rdx, 0
    je even
    jmp odd

even:
    mov rdi, evenMsg
    call printString
    jmp finish

odd:

    mov rdi, oddMsg
    call printString
    jmp finish

finish:
    jmp printMenuAndLoop

; Convert ASCII string to integer (stores result in rax)
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