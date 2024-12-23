.text
.global main
main:
    mov x0, #10
    cmp x0, #5



end:
    //ending sequence of instructions for linux
    mov x0, #0
    mov x8, #93
    svc #0