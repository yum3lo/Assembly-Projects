section .data
  strPrompt db "Enter the string: ", 0
  sufPrompt db "Enter the suffix: ", 0
  resMsg db "The concatenated string is: ", 0
  newline db 10, 0

section .bss
  string1 resb 50
  string2 resb 50

section .text
global suffix
extern printString, printMenuAndLoop

suffix:
  ; Print strPrompt
  mov rdi, strPrompt
  call printString

  ; Read string1
  mov rsi, string1
  call readString

  ; Print sufPrompt
  mov rdi, sufPrompt
  call printString

  ; Read string2
  mov rsi, string2
  call readString

  ; Print resMsg
  mov rdi, resMsg
  call printString

  ; Concatenate strings
  mov rdi, string1
  call printString

  mov rdi, string2
  call printString

  ; Print newline
  mov rdi, newline
  call printString

  jmp printMenuAndLoop

readString:
  ; Read a string from stdin into rsi
  ; Returns nothing
  mov rax, 0          ; syscall: sys_read
  mov rdi, 0          ; stdin
  mov rdx, 50         ; max length
  syscall
  ret