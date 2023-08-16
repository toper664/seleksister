zeros:
        stp     x29, x30, [sp, -48]!
        mov     x29, sp
        str     w0, [sp, 28]
        ldrsw   x0, [sp, 28]
        lsl     x0, x0, 3
        bl      malloc
        str     x0, [sp, 32]
        str     wzr, [sp, 44]
        b       .L2
.L3:
        ldrsw   x0, [sp, 44]
        lsl     x0, x0, 3
        ldr     x1, [sp, 32]
        add     x0, x1, x0
        str     xzr, [x0]
        ldr     w0, [sp, 44]
        add     w0, w0, 1
        str     w0, [sp, 44]
.L2:
        ldr     w1, [sp, 44]
        ldr     w0, [sp, 28]
        cmp     w1, w0
        blt     .L3
        ldr     x0, [sp, 32]
        ldp     x29, x30, [sp], 48
        ret
denom:
        sub     sp, sp, #48
        str     w0, [sp, 12]
        str     x1, [sp]
        str     w2, [sp, 8]
        fmov    d0, 1.0e+0
        str     d0, [sp, 40]
        ldrsw   x0, [sp, 12]
        lsl     x0, x0, 4
        ldr     x1, [sp]
        add     x0, x1, x0
        ldr     d0, [x0]
        str     d0, [sp, 24]
        str     wzr, [sp, 36]
        b       .L6
.L8:
        ldr     w1, [sp, 12]
        ldr     w0, [sp, 36]
        cmp     w1, w0
        beq     .L7
        ldrsw   x0, [sp, 36]
        lsl     x0, x0, 4
        ldr     x1, [sp]
        add     x0, x1, x0
        ldr     d0, [x0]
        ldr     d1, [sp, 24]
        fsub    d0, d1, d0
        ldr     d1, [sp, 40]
        fmul    d0, d1, d0
        str     d0, [sp, 40]
.L7:
        ldr     w0, [sp, 36]
        add     w0, w0, 1
        str     w0, [sp, 36]
.L6:
        ldr     w1, [sp, 36]
        ldr     w0, [sp, 8]
        cmp     w1, w0
        blt     .L8
        ldr     d0, [sp, 40]
        add     sp, sp, 48
        ret
interpolate:
        stp     x29, x30, [sp, -64]!
        mov     x29, sp
        str     w0, [sp, 28]
        str     x1, [sp, 16]
        str     w2, [sp, 24]
        ldr     w0, [sp, 24]
        bl      zeros
        str     x0, [sp, 56]
        ldr     w2, [sp, 24]
        ldr     x1, [sp, 16]
        ldr     w0, [sp, 28]
        bl      denom
        fmov    d1, d0
        fmov    d0, 1.0e+0
        fdiv    d0, d0, d1
        ldr     x0, [sp, 56]
        str     d0, [x0]
        str     wzr, [sp, 52]
        b       .L11
.L19:
        ldr     w1, [sp, 52]
        ldr     w0, [sp, 28]
        cmp     w1, w0
        beq     .L21
        ldr     w0, [sp, 24]
        bl      zeros
        str     x0, [sp, 40]
        ldr     w1, [sp, 52]
        ldr     w0, [sp, 28]
        cmp     w1, w0
        bge     .L14
        ldr     w0, [sp, 52]
        add     w0, w0, 1
        b       .L15
.L14:
        ldr     w0, [sp, 52]
.L15:
        str     w0, [sp, 48]
        b       .L16
.L18:
        ldr     w0, [sp, 48]
        cmp     w0, 1
        bgt     .L17
        ldrsw   x0, [sp, 48]
        add     x0, x0, 1
        lsl     x0, x0, 3
        ldr     x1, [sp, 40]
        add     x0, x1, x0
        ldr     d1, [x0]
        ldrsw   x0, [sp, 48]
        lsl     x0, x0, 3
        ldr     x1, [sp, 56]
        add     x0, x1, x0
        ldr     d0, [x0]
        ldrsw   x0, [sp, 48]
        add     x0, x0, 1
        lsl     x0, x0, 3
        ldr     x1, [sp, 40]
        add     x0, x1, x0
        fadd    d0, d1, d0
        str     d0, [x0]
        ldrsw   x0, [sp, 48]
        lsl     x0, x0, 3
        ldr     x1, [sp, 40]
        add     x0, x1, x0
        ldr     d1, [x0]
        ldrsw   x0, [sp, 52]
        lsl     x0, x0, 4
        ldr     x1, [sp, 16]
        add     x0, x1, x0
        ldr     d2, [x0]
        ldrsw   x0, [sp, 48]
        lsl     x0, x0, 3
        ldr     x1, [sp, 56]
        add     x0, x1, x0
        ldr     d0, [x0]
        fmul    d0, d2, d0
        ldrsw   x0, [sp, 48]
        lsl     x0, x0, 3
        ldr     x1, [sp, 40]
        add     x0, x1, x0
        fsub    d0, d1, d0
        str     d0, [x0]
.L17:
        ldr     w0, [sp, 48]
        sub     w0, w0, #1
        str     w0, [sp, 48]
.L16:
        ldr     w0, [sp, 48]
        cmp     w0, 0
        bge     .L18
        ldr     x0, [sp, 56]
        bl      free
        ldr     x0, [sp, 40]
        str     x0, [sp, 56]
        b       .L13
.L21:
        nop
.L13:
        ldr     w0, [sp, 52]
        add     w0, w0, 1
        str     w0, [sp, 52]
.L11:
        ldr     w1, [sp, 52]
        ldr     w0, [sp, 24]
        cmp     w1, w0
        blt     .L19
        ldr     x0, [sp, 56]
        ldp     x29, x30, [sp], 64
        ret
lagrange:
        stp     x29, x30, [sp, -64]!
        mov     x29, sp
        str     x0, [sp, 24]
        str     w1, [sp, 20]
        ldr     w0, [sp, 20]
        bl      zeros
        str     x0, [sp, 48]
        str     wzr, [sp, 60]
        b       .L23
.L26:
        ldr     w2, [sp, 20]
        ldr     x1, [sp, 24]
        ldr     w0, [sp, 60]
        bl      interpolate
        str     x0, [sp, 40]
        str     wzr, [sp, 56]
        b       .L24
.L25:
        ldr     w0, [sp, 20]
        sub     w1, w0, #1
        ldr     w0, [sp, 56]
        sub     w0, w1, w0
        sxtw    x0, w0
        lsl     x0, x0, 3
        ldr     x1, [sp, 48]
        add     x0, x1, x0
        ldr     d1, [x0]
        ldrsw   x0, [sp, 60]
        lsl     x0, x0, 4
        ldr     x1, [sp, 24]
        add     x0, x1, x0
        ldr     d2, [x0, 8]
        ldrsw   x0, [sp, 56]
        lsl     x0, x0, 3
        ldr     x1, [sp, 40]
        add     x0, x1, x0
        ldr     d0, [x0]
        fmul    d0, d2, d0
        ldr     w0, [sp, 20]
        sub     w1, w0, #1
        ldr     w0, [sp, 56]
        sub     w0, w1, w0
        sxtw    x0, w0
        lsl     x0, x0, 3
        ldr     x1, [sp, 48]
        add     x0, x1, x0
        fadd    d0, d1, d0
        str     d0, [x0]
        ldr     w0, [sp, 56]
        add     w0, w0, 1
        str     w0, [sp, 56]
.L24:
        ldr     w1, [sp, 56]
        ldr     w0, [sp, 20]
        cmp     w1, w0
        blt     .L25
        ldr     x0, [sp, 40]
        bl      free
        ldr     w0, [sp, 60]
        add     w0, w0, 1
        str     w0, [sp, 60]
.L23:
        ldr     w1, [sp, 60]
        ldr     w0, [sp, 20]
        cmp     w1, w0
        blt     .L26
        ldr     x0, [sp, 48]
        ldp     x29, x30, [sp], 64
        ret
.LC0:
        .string "r"
.LC1:
        .string "ingput.txt"
.LC2:
        .string "%d"
.LC3:
        .string "%lf %lf"
.LC4:
        .string "w"
.LC5:
        .string "otput.txt"
.LC6:
        .string "%lf "
.LC7:
        .string "Lagrange coefficients successfully written."
main:
        stp     x29, x30, [sp, -80]!
        mov     x29, sp
        adrp    x0, .LC0
        add     x1, x0, :lo12:.LC0
        adrp    x0, .LC1
        add     x0, x0, :lo12:.LC1
        bl      fopen
        str     x0, [sp, 64]
        add     x0, sp, 36
        mov     x2, x0
        adrp    x0, .LC2
        add     x1, x0, :lo12:.LC2
        ldr     x0, [sp, 64]
        bl      __isoc99_fscanf
        ldr     w0, [sp, 36]
        add     w0, w0, 1
        sxtw    x0, w0
        lsl     x0, x0, 4
        bl      malloc
        str     x0, [sp, 56]
        str     wzr, [sp, 76]
        b       .L29
.L30:
        add     x1, sp, 16
        add     x0, sp, 24
        mov     x3, x1
        mov     x2, x0
        adrp    x0, .LC3
        add     x1, x0, :lo12:.LC3
        ldr     x0, [sp, 64]
        bl      __isoc99_fscanf
        ldrsw   x0, [sp, 76]
        lsl     x0, x0, 4
        ldr     x1, [sp, 56]
        add     x0, x1, x0
        ldr     d0, [sp, 24]
        str     d0, [x0]
        ldrsw   x0, [sp, 76]
        lsl     x0, x0, 4
        ldr     x1, [sp, 56]
        add     x0, x1, x0
        ldr     d0, [sp, 16]
        str     d0, [x0, 8]
        ldr     w0, [sp, 76]
        add     w0, w0, 1
        str     w0, [sp, 76]
.L29:
        ldr     w0, [sp, 36]
        ldr     w1, [sp, 76]
        cmp     w1, w0
        ble     .L30
        ldr     x0, [sp, 64]
        bl      fclose
        ldr     w0, [sp, 36]
        add     w0, w0, 1
        mov     w1, w0
        ldr     x0, [sp, 56]
        bl      lagrange
        str     x0, [sp, 48]
        adrp    x0, .LC4
        add     x1, x0, :lo12:.LC4
        adrp    x0, .LC5
        add     x0, x0, :lo12:.LC5
        bl      fopen
        str     x0, [sp, 40]
        str     wzr, [sp, 72]
        b       .L31
.L32:
        ldrsw   x0, [sp, 72]
        lsl     x0, x0, 3
        ldr     x1, [sp, 48]
        add     x0, x1, x0
        ldr     d0, [x0]
        adrp    x0, .LC6
        add     x1, x0, :lo12:.LC6
        ldr     x0, [sp, 40]
        bl      fprintf
        ldr     w0, [sp, 72]
        add     w0, w0, 1
        str     w0, [sp, 72]
.L31:
        ldr     w0, [sp, 36]
        ldr     w1, [sp, 72]
        cmp     w1, w0
        ble     .L32
        ldr     x0, [sp, 40]
        bl      fclose
        ldr     x0, [sp, 48]
        bl      free
        ldr     x0, [sp, 56]
        bl      free
        adrp    x0, .LC7
        add     x0, x0, :lo12:.LC7
        bl      puts
        mov     w0, 0
        ldp     x29, x30, [sp], 80
        ret