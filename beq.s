.text
.global main
main:
    mov x0, #1
    neg x0, x0
    adds x1, x0, #1
    bcs end

    mov x1, #1000

end:
    mov x0, #0
    mov x8, #93
    svc #0