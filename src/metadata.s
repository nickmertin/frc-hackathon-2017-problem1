    .text
    .globl metadata
    .type metadata, @function
metadata:
    /* count columns */
    mov $0, %rax
metadata.loop1:
    mov (%r15,%rax), %dl
    cmp $0x0A, %dl
    je metadata.break1
    inc %rax
    jmp metadata.loop1
metadata.break1:

    /* count rows */
    inc %rax
    mov %rax, %rcx
    mov $1, %r8
metadata.loop2:
    mov (%r15,%rax), %dl
    cmp $0x0A, %dl
    je metadata.break2
    cmp %r12, %rax
    jl metadata.continue2
    mov $1, %r9
    ret
metadata.continue2:
    inc %r8
    add %rcx, %rax
    jmp metadata.loop2
metadata.break2:
    dec %rcx

    /* count levels */
    inc %rax
    mov $0, %rdx
    mov %rax, %rsi
    mov %r12, %rax
    div %rsi
    mov %rax, %r9
    sub %rdx, %rsi
    cmp $2, %rsi
    jg metadata.skip1
    cmp $0, %rsi
    je metadata.skip1
    inc %r9
metadata.skip1:
    ret

    .section .rodata
format:
    .string "%llx\n"