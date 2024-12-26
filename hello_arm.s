.text
.global main
main:

mov x1, #1
add x2, x1, #2

end:
    mov x0, #0            // Exit code (0 = success)
    mov x8, #93           // System call number for exit
    svc #0