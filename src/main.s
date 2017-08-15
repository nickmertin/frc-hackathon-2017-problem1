    .text
    .globl main
    .type main, @function
main:
    /* function prologue */
    push %rbx
    push %r12
    push %r13
    push %r14
    push %r15
    push %rbp
    mov %rsp, %rbp

    /* check number of arguments */
    cmp $3, %rdi
    jge main.valid1
    lea main.invalid1(%rip), %rdi
    call puts
    mov $1, %rax
    jmp main.ret
main.valid1:

    /* open source file */
    mov $2, %rax
    mov 8(%rsi), %rdi
    push %rsi
    mov $2, %rsi
    syscall
    test %rax, %rax
    jne main.valid2
    mov %rax, %r11
    lea main.invalid2(%rip), %rdi
    call puts
    mov %r11, %rax
    jmp main.ret
main.valid2:

    /* get length */
    mov %rax, %rdi
    mov %rax, %rbx
    mov $5, %rax
    lea -144(%rsp), %rsi
    syscall
    mov -96(%rsp), %r12

    /* read file */
    call readall
    test %rax, %rax
    jne main.ret

    /* close file */
    mov $3, %rax
    mov %rbx, %rdi
    syscall

    /* get metadata */
    call metadata

    /* print info */
    call info

    /* run algorithm */
    call algorithm

    /* print result */
    pop %rsi
    push %r11
    mov 16(%rsi), %rdi
    mov $2, %rax
    mov $2, %rsi
    syscall
    mov %rax, %rbp
    pop %r11
    call result

    /* return zero */
    mov $0, %rax

main.ret:
    mov %rax, %rdi
    mov $60, %rax
    syscall

main.end:
    .size main, .-main

    /* constants */
    .section .rodata
main.invalid1:
    .string "Expected 12 arguments!"
main.invalid2:
    .string "Unable to open input file!"
