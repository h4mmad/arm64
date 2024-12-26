.text
.global main
main:

    mov x0, #100
    subs x1, x0, #50
    beq end

    mov x2, #10
    bne end

    mov x3, #20

end:
    mov x0, #0
    ret