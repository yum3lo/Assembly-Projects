section .bss
    randomValue resb 1      ; a byte for the random value
    numString resb 5        ; 5 bytes for the number string

section .data
    urandomPath db '/dev/urandom', 0  ; device file for random bytes
    loopCount db 10
    space db ' ', 0

section .text
global main

main:   ; Open /dev/urandom
    mov rax, 2               ; syscall number for sys_open
    mov rdi, urandomPath     ; pointer to the file path
    mov rsi, 0               ; flags
    syscall
    mov rbx, rax

generate_number:    ; read a random byte
    mov rax, 0               ; syscall number for sys_read
    mov rdi, rbx             ; file descriptor returned by sys_open
    mov rsi, randomValue     ; buffer to store the read byte
    mov rdx, 1               ; number of bytes to read
    syscall

    ; the random byte in the range 1-56
    movzx rax, byte [randomValue]   ; load the random byte into rax
    mov rdi, 56
    xor rdx, rdx             ; clear rdx for division result
    div rdi                  ; rax = rax / 56, rdx = rax % 56
    mov rax, rdx             ; move remainder to rax
    add rax, 1               ; adjust range to 1-56

    ; number to string
    mov rdi, numString       ; pointer to the string buffer
    add rdi, 3               ; start at the end of the buffer
    mov rcx, 10              ; divider for conversion

convert_loop:
    xor rdx, rdx             ; clear rdx before dividing
    div rcx                  ; divide rax by 10, result in rax, remainder in rdx
    add dl, '0'              ; convert remainder to ASCII
    dec rdi                  ; move string pointer back
    mov [rdi], dl            ; store ASCII character
    test rax, rax            ; check if rax is 0
    jnz convert_loop         ; if not, continue loop

    ; write the number string to stdout
    mov rax, 1               ; syscall number for sys_write
    mov rdi, 1               ; file descriptor for stdout
    mov rsi, numString       ; pointer to the string buffer
    mov rdx, 5               ; number of bytes to write
    syscall

    ; print space character
    mov rax, 1
    mov rdi, 1               
    mov rsi, space           ; pointer to the space character
    mov rdx, 1             
    syscall

    ; decrement loop counter and check if = 0
    dec byte [loopCount]
    jnz generate_number      ; if not, generate another number

    ; close /dev/urandom
    mov rax, 3               ; syscall number for sys_close
    mov rdi, rbx             ; file descriptor to close
    syscall

    ; exit
    mov rax, 60              ; syscall number for sys_exit
    xor rdi, rdi
    syscall