section .data
    promptStr db 'Enter a string: ', 0
    promptChar db 'Enter a character to find: ', 0
    posMsg db 'Position: ', 0
    notFoundMsg db 'Character not found.', 10, 0
    newline db 10, 0

section .bss
    input resb 256
    chr resb 1
    result resb 3    

section .text
global position
extern printString, printMenuAndLoop

position:
    ; Prompt for the string
    mov rdi, promptStr
    call printString

    ; Get the user string
    mov rax, 0              ; syscall number for sys_read
    mov rdi, 0              ; file descriptor (stdin)
    mov rsi, input          ; buffer to store input
    mov rdx, 256            ; number of bytes to read
    syscall

    ; Null-terminate the string (replace newline with null terminator)
    mov rbx, input


find_newline:
    cmp byte [rbx], 10      ; check for newline character
    je found_newline
    inc rbx
    cmp byte [rbx], 0       ; if we reach the end of buffer, break
    je end_find_newline
    jmp find_newline

found_newline:
    mov byte [rbx], 0

end_find_newline:
    ; Prompt for the character
    mov rdi, promptChar
    call printString

    ; Get the user character
    mov rax, 0
    mov rdi, 0
    mov rsi, chr
    mov rdx, 1              ; only need to read one byte for one character
    syscall

    ; Get the character to search for
    mov al, byte [chr]

    ; Search for the character in the string
    mov rbx, input
    xor rcx, rcx            ; Initialize counter

search_char:
    cmp byte [rbx], 0       ; Check for end of string
    je not_found
    cmp byte [rbx], al      ; Check if current character matches
    je found_char
    inc rbx
    inc rcx
    jmp search_char

found_char:
    add rcx, 1              ; Adjust index to be human readable (1-based)

    ; Convert rcx to a string in result
    lea rsi, [result]
    mov rdi, rcx
    call numToStr

    mov rdi, posMsg
    call printString

    mov rax, 1              ; syscall number for sys_write
    mov rdi, 1              ; file descriptor (stdout)
    mov rsi, result         ; buffer containing position
    mov rdx, 3              ; number of bytes to write (2 digits + newline)
    syscall

    mov rdi, newline
    call printString


    jmp printMenuAndLoop

not_found:
    mov rdi, notFoundMsg
    call printString
    jmp printMenuAndLoop

numToStr:
    ; rdi = number, rsi = buffer to write string
    mov rax, rdi
    mov rdx, 0
    mov rbx, 10
    div rbx                ; divide rax by 10, result in rax, remainder in rdx
    add dl, '0'
    mov [rsi+1], dl        ; save the second digit
    test rax, rax
    jz .Lfinished
    add al, '0'
    mov [rsi], al          ; save the first digit
    mov byte [rsi+2], 0    ; null-terminate
    ret
.Lfinished:
    mov [rsi], dl          ; save the only digit
    mov byte [rsi+1], 0    ; null-terminate
    ret