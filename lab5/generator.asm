section .data
    random_max equ 55      ; Maximum random number
    random_min equ 1       ; Minimum random number
    count equ 10           ; Number of random numbers to generate
    newline db 0xA         ; Newline character for formatting output
    seed dd 0              ; Random number seed (initialized to 0)

section .text
    global _main
    extern _printf, _srand, _rand

_main:
    ; Seed the random number generator
    push dword [seed]
    call _srand
    add esp, 4             ; Clean up the stack

    ; Loop to generate and print 10 random numbers
    mov ecx, count         ; Loop counter
.loop:
    ; Generate a random number
    call _rand
    ; Scale the random number to the desired range
    mov edx, random_max
    sub edx, random_min
    inc edx                ; Adjust for inclusive range
    call _rand             ; Generate a random number again for better randomness
    div edx                ; Divide the random number by the range
    add eax, random_min    ; Add the minimum value to get the final random number
    push eax               ; Push the random number onto the stack
    push dword "%d"        ; Push the format string for printing an integer
    call _printf           ; Print the random number
    add esp, 8             ; Clean up the stack after printf
    ; Print a comma and space after each number, except the last one
    dec ecx
    jz .end_loop           ; Jump to end loop if it's the last iteration
    push dword ", "        ; Push comma and space onto the stack
    push dword newline    ; Push newline character for formatting output
    call _printf           ; Print the comma and space
    add esp, 8             ; Clean up the stack after printf
    jmp .loop              ; Repeat the loop
.end_loop:
    ; Print a newline character at the end
    push dword newline     ; Push newline character onto the stack
    call _printf           ; Print the newline
    ; Exit the program
    mov eax, 0             ; Return 0 to indicate successful execution
    ret