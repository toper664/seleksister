zeros:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     DWORD PTR [rbp-20], edi
        mov     eax, DWORD PTR [rbp-20]
        cdqe
        sal     rax, 3
        mov     rdi, rax
        call    malloc
        mov     QWORD PTR [rbp-16], rax
        mov     DWORD PTR [rbp-4], 0
        jmp     .L2
.L3:
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-16]
        add     rax, rdx
        pxor    xmm0, xmm0
        movsd   QWORD PTR [rax], xmm0
        add     DWORD PTR [rbp-4], 1
.L2:
        mov     eax, DWORD PTR [rbp-4]
        cmp     eax, DWORD PTR [rbp-20]
        jl      .L3
        mov     rax, QWORD PTR [rbp-16]
        leave
        ret
denom:
        push    rbp
        mov     rbp, rsp
        mov     DWORD PTR [rbp-36], edi
        mov     QWORD PTR [rbp-48], rsi
        mov     DWORD PTR [rbp-40], edx
        movsd   xmm0, QWORD PTR .LC1[rip]
        movsd   QWORD PTR [rbp-8], xmm0
        mov     eax, DWORD PTR [rbp-36]
        cdqe
        sal     rax, 4
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-48]
        add     rax, rdx
        movsd   xmm0, QWORD PTR [rax]
        movsd   QWORD PTR [rbp-24], xmm0
        mov     DWORD PTR [rbp-12], 0
        jmp     .L6
.L8:
        mov     eax, DWORD PTR [rbp-36]
        cmp     eax, DWORD PTR [rbp-12]
        je      .L7
        mov     eax, DWORD PTR [rbp-12]
        cdqe
        sal     rax, 4
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-48]
        add     rax, rdx
        movsd   xmm1, QWORD PTR [rax]
        movsd   xmm0, QWORD PTR [rbp-24]
        subsd   xmm0, xmm1
        movsd   xmm1, QWORD PTR [rbp-8]
        mulsd   xmm0, xmm1
        movsd   QWORD PTR [rbp-8], xmm0
.L7:
        add     DWORD PTR [rbp-12], 1
.L6:
        mov     eax, DWORD PTR [rbp-12]
        cmp     eax, DWORD PTR [rbp-40]
        jl      .L8
        movsd   xmm0, QWORD PTR [rbp-8]
        movq    rax, xmm0
        movq    xmm0, rax
        pop     rbp
        ret
interpolate:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 48
        mov     DWORD PTR [rbp-36], edi
        mov     QWORD PTR [rbp-48], rsi
        mov     DWORD PTR [rbp-40], edx
        mov     eax, DWORD PTR [rbp-40]
        mov     edi, eax
        call    zeros
        mov     QWORD PTR [rbp-8], rax
        mov     edx, DWORD PTR [rbp-40]
        mov     rcx, QWORD PTR [rbp-48]
        mov     eax, DWORD PTR [rbp-36]
        mov     rsi, rcx
        mov     edi, eax
        call    denom
        movapd  xmm1, xmm0
        movsd   xmm0, QWORD PTR .LC1[rip]
        divsd   xmm0, xmm1
        mov     rax, QWORD PTR [rbp-8]
        movsd   QWORD PTR [rax], xmm0
        mov     DWORD PTR [rbp-12], 0
        jmp     .L11
.L19:
        mov     eax, DWORD PTR [rbp-12]
        cmp     eax, DWORD PTR [rbp-36]
        je      .L21
        mov     eax, DWORD PTR [rbp-40]
        mov     edi, eax
        call    zeros
        mov     QWORD PTR [rbp-24], rax
        mov     eax, DWORD PTR [rbp-12]
        cmp     eax, DWORD PTR [rbp-36]
        jge     .L14
        mov     eax, DWORD PTR [rbp-12]
        add     eax, 1
        jmp     .L15
.L14:
        mov     eax, DWORD PTR [rbp-12]
.L15:
        mov     DWORD PTR [rbp-16], eax
        jmp     .L16
.L18:
        cmp     DWORD PTR [rbp-16], 1
        jg      .L17
        mov     eax, DWORD PTR [rbp-16]
        cdqe
        add     rax, 1
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rdx
        movsd   xmm1, QWORD PTR [rax]
        mov     eax, DWORD PTR [rbp-16]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-8]
        add     rax, rdx
        movsd   xmm0, QWORD PTR [rax]
        mov     eax, DWORD PTR [rbp-16]
        cdqe
        add     rax, 1
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rdx
        addsd   xmm0, xmm1
        movsd   QWORD PTR [rax], xmm0
        mov     eax, DWORD PTR [rbp-16]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rdx
        movsd   xmm0, QWORD PTR [rax]
        mov     eax, DWORD PTR [rbp-12]
        cdqe
        sal     rax, 4
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-48]
        add     rax, rdx
        movsd   xmm2, QWORD PTR [rax]
        mov     eax, DWORD PTR [rbp-16]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-8]
        add     rax, rdx
        movsd   xmm1, QWORD PTR [rax]
        mulsd   xmm1, xmm2
        mov     eax, DWORD PTR [rbp-16]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rdx
        subsd   xmm0, xmm1
        movsd   QWORD PTR [rax], xmm0
.L17:
        sub     DWORD PTR [rbp-16], 1
.L16:
        cmp     DWORD PTR [rbp-16], 0
        jns     .L18
        mov     rax, QWORD PTR [rbp-8]
        mov     rdi, rax
        call    free
        mov     rax, QWORD PTR [rbp-24]
        mov     QWORD PTR [rbp-8], rax
        jmp     .L13
.L21:
        nop
.L13:
        add     DWORD PTR [rbp-12], 1
.L11:
        mov     eax, DWORD PTR [rbp-12]
        cmp     eax, DWORD PTR [rbp-40]
        jl      .L19
        mov     rax, QWORD PTR [rbp-8]
        leave
        ret
lagrange:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 48
        mov     QWORD PTR [rbp-40], rdi
        mov     DWORD PTR [rbp-44], esi
        mov     eax, DWORD PTR [rbp-44]
        mov     edi, eax
        call    zeros
        mov     QWORD PTR [rbp-16], rax
        mov     DWORD PTR [rbp-4], 0
        jmp     .L23
.L26:
        mov     edx, DWORD PTR [rbp-44]
        mov     rcx, QWORD PTR [rbp-40]
        mov     eax, DWORD PTR [rbp-4]
        mov     rsi, rcx
        mov     edi, eax
        call    interpolate
        mov     QWORD PTR [rbp-24], rax
        mov     DWORD PTR [rbp-8], 0
        jmp     .L24
.L25:
        mov     eax, DWORD PTR [rbp-44]
        sub     eax, 1
        sub     eax, DWORD PTR [rbp-8]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-16]
        add     rax, rdx
        movsd   xmm1, QWORD PTR [rax]
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        sal     rax, 4
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-40]
        add     rax, rdx
        movsd   xmm2, QWORD PTR [rax+8]
        mov     eax, DWORD PTR [rbp-8]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rdx
        movsd   xmm0, QWORD PTR [rax]
        mulsd   xmm0, xmm2
        mov     eax, DWORD PTR [rbp-44]
        sub     eax, 1
        sub     eax, DWORD PTR [rbp-8]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-16]
        add     rax, rdx
        addsd   xmm0, xmm1
        movsd   QWORD PTR [rax], xmm0
        add     DWORD PTR [rbp-8], 1
.L24:
        mov     eax, DWORD PTR [rbp-8]
        cmp     eax, DWORD PTR [rbp-44]
        jl      .L25
        mov     rax, QWORD PTR [rbp-24]
        mov     rdi, rax
        call    free
        add     DWORD PTR [rbp-4], 1
.L23:
        mov     eax, DWORD PTR [rbp-4]
        cmp     eax, DWORD PTR [rbp-44]
        jl      .L26
        mov     rax, QWORD PTR [rbp-16]
        leave
        ret
.LC2:
        .string "r"
.LC3:
        .string "ingput.txt"
.LC4:
        .string "%d"
.LC5:
        .string "%lf %lf"
.LC6:
        .string "w"
.LC7:
        .string "otput.txt"
.LC8:
        .string "%lf "
.LC9:
        .string "Lagrange coefficients successfully written."
main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 64
        mov     esi, OFFSET FLAT:.LC2
        mov     edi, OFFSET FLAT:.LC3
        call    fopen
        mov     QWORD PTR [rbp-16], rax
        lea     rdx, [rbp-44]
        mov     rax, QWORD PTR [rbp-16]
        mov     esi, OFFSET FLAT:.LC4
        mov     rdi, rax
        mov     eax, 0
        call    __isoc99_fscanf
        mov     eax, DWORD PTR [rbp-44]
        add     eax, 1
        cdqe
        sal     rax, 4
        mov     rdi, rax
        call    malloc
        mov     QWORD PTR [rbp-24], rax
        mov     DWORD PTR [rbp-4], 0
        jmp     .L29
.L30:
        lea     rcx, [rbp-64]
        lea     rdx, [rbp-56]
        mov     rax, QWORD PTR [rbp-16]
        mov     esi, OFFSET FLAT:.LC5
        mov     rdi, rax
        mov     eax, 0
        call    __isoc99_fscanf
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        sal     rax, 4
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rdx
        movsd   xmm0, QWORD PTR [rbp-56]
        movsd   QWORD PTR [rax], xmm0
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        sal     rax, 4
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rdx
        movsd   xmm0, QWORD PTR [rbp-64]
        movsd   QWORD PTR [rax+8], xmm0
        add     DWORD PTR [rbp-4], 1
.L29:
        mov     eax, DWORD PTR [rbp-44]
        cmp     DWORD PTR [rbp-4], eax
        jle     .L30
        mov     rax, QWORD PTR [rbp-16]
        mov     rdi, rax
        call    fclose
        mov     eax, DWORD PTR [rbp-44]
        lea     edx, [rax+1]
        mov     rax, QWORD PTR [rbp-24]
        mov     esi, edx
        mov     rdi, rax
        call    lagrange
        mov     QWORD PTR [rbp-32], rax
        mov     esi, OFFSET FLAT:.LC6
        mov     edi, OFFSET FLAT:.LC7
        call    fopen
        mov     QWORD PTR [rbp-40], rax
        mov     DWORD PTR [rbp-8], 0
        jmp     .L31
.L32:
        mov     eax, DWORD PTR [rbp-8]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-32]
        add     rax, rdx
        mov     rdx, QWORD PTR [rax]
        mov     rax, QWORD PTR [rbp-40]
        movq    xmm0, rdx
        mov     esi, OFFSET FLAT:.LC8
        mov     rdi, rax
        mov     eax, 1
        call    fprintf
        add     DWORD PTR [rbp-8], 1
.L31:
        mov     eax, DWORD PTR [rbp-44]
        cmp     DWORD PTR [rbp-8], eax
        jle     .L32
        mov     rax, QWORD PTR [rbp-40]
        mov     rdi, rax
        call    fclose
        mov     rax, QWORD PTR [rbp-32]
        mov     rdi, rax
        call    free
        mov     rax, QWORD PTR [rbp-24]
        mov     rdi, rax
        call    free
        mov     edi, OFFSET FLAT:.LC9
        call    puts
        mov     eax, 0
        leave
        ret
.LC1:
        .long   0
        .long   1072693248