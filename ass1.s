.data
varA: .quad 10
varB: .quad 60
varC: .quad 50
value: .quad 0
divzero: .quad 0

.text
.global main
main:
    ldr x0, =varA
    ldr x0, [x0]

    ldr x1, =varB
    ldr x1, [x1]

    ldr x2, =varC
    ldr x2, [x2]


    // create the equation
    // store -100 in a register
    mov x3, #-100

    // varA * -100
    mul x4, x0, x3
    // x4 will now contain -1000

    // varB - varC
    sub x5, x1, x2
    // x5 will now contain 10

    // value = (varA * -100) / (varB -varC)
    // value = x4 / x5

    sdiv x6, x4, x5
    // x6 should be -1000/10 so -100
    // use signed division sdiv

    

    //revised equation
    //value = (varA / -100) * (varB + varC)
    
    mov x7, #-100
    sdiv x8, x0, x7
    // x8 will no contain (varA / -100)
    // (10/-100) so 0

    add x9, x1, x2
    // x9 will now contain (varB + varC)
    // so x9 will contain 110

    //then complete the equation
    //so 
    mul x10, x8, x9
    // x10 should contain 0 since we multiplied with 0

// the register in which value is stored move zero.
    b end


    //this instruction will not run because of b instruction
    mov x22, #21


// the register in which value is stored move zero.
end:
    // the register in which value of the equation was stored is now zero
    mov x6, #0
    mov x10, #0
    mov x0, #0
    ret