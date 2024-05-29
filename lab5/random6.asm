section .data
    devUrandom db '/dev/urandom', 0  ; Device file for random bytes
    loopCount db 1    
    prompt db 'Generated number: ', 0
    newline db 10, 0

section .bss
    randomValue resb 1            ; Reserve a byte for the random value
    numString resb 5              ; Reserve 5 bytes for the number string (max 3 digits for numbers 1-55 plus newline and null terminator)

section .text
global random
extern printMenuAndLoop, printString

random:
    ; Open /dev/urandom
    mov rax, 2               ; syscall number for sys_open
    mov rdi, devUrandom      ; Pointer to the file path
    mov rsi, 0               ; Flags (O_RDONLY)
    syscall
    mov rbx, rax             ; Save the file descriptor for later use

    mov byte [loopCount], 1

    mov rdi, prompt       
    call printString

generate_number:
    ; Read a random byte
    mov rax, 0               ; syscall number for sys_read
    mov rdi, rbx             ; File descriptor returned by sys_open
    mov rsi, randomValue     ; Buffer to store the read byte
    mov rdx, 1               ; Number of bytes to read
    syscall

    ; Adjust the random byte to the range [1, 55]
    movzx rax, byte [randomValue] ; Load the random byte into rax
    mov rdi, 99
    xor rdx, rdx             ; Clear rdx for division result
    div rdi                 
    mov rax, rdx             ; Move remainder to rax
    add rax, 1               

    ; Convert number to string
    mov rdi, numString       ; Pointer to the string buffer
    add rdi, 3               ; Start at the end of the buffer
    mov rcx, 10              ; Divider for conversion

convert_loop:
    xor rdx, rdx             ; Clear rdx before division
    div rcx                  ; Divide rax by 10, result in rax, remainder in rdx
    add dl, '0'              ; Convert remainder to ASCII
    dec rdi                  ; Move string pointer back
    mov [rdi], dl            ; Store ASCII character
    test rax, rax            ; Check if rax is zero
    jnz convert_loop         ; If not, continue loop

    mov rax, 1             
    mov rdi, 1           
    mov rsi, numString  
    mov rdx, 5         
    syscall

    mov rdi, newline
    call printString

    ; Decrement loop counter and check if zero
    dec byte [loopCount]
    jnz generate_number      ; If not zero, generate another number

    ; Close /dev/urandom
    mov rax, 3               ; syscall number for sys_close
    mov rdi, rbx             ; File descriptor to close
    syscall

    mov rax, 60             
    xor rdi, rdi  
    jmp printMenuAndLoop