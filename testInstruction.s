.text
.global main
main:

    mov x0, #0b0 
    mov x1, #0b0 
    tst x0, x1 //tst instruction is used to perform a bitwise AND between two values and update in CPSR flag. 
    // after this operation, the zero flag should be set to 1

    mov x2, #0b10001100
    mov x3, #0b00001001
    tst x2, x3

    mov x4, #0b10000100
    tst x4, x3

    mov x0, #0
    ret