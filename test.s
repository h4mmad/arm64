.data
varA: .quad 1

.text
.global main
main:
    


    //revised equation
    //value = (varA / -100) * (varB + varC)
    mov x1, #60
    mov x2, #50
    mov x7, #-100
    udiv x8, x0, x7
    // x8 will no contain (varA / -100)
    // (10/-100) so 0

    add x9, x1, x2
    // x9 will now contain (varB + varC)




    mov x0, #0
    ret