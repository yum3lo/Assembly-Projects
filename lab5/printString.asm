section .text
global printString

printString:
    push rdi             ; Save RDI register on stack since it will be modified
    mov rcx, -1          ; Set RCX to the maximum possible negative value
    xor al, al           ; Set AL to 0 (searching for a null-terminator)
    repne scasb          ; Repeat scanning byte by byte until AL is found in [RDI]
    not rcx              ; Calculate the length of the string from the negated value of RCX
    dec rcx              ; Adjust length to exclude the null terminator

    ; Prepare to call the write syscall
    mov rdx, rcx         ; Set RDX to the length of the string
    mov rax, 1           ; Syscall number for sys_write
    mov rdi, 1           ; File descriptor 1 - standard output
    pop rsi              ; Restore the original RDI (string pointer) from the stack to RSI
    syscall              ; Invoke the operating system to perform the write
    ret                  ; Return from the function