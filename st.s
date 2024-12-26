.text
.global main
main:

mov x1, #69
mov x2, #100

// allocate 16 bytes and then store x1 in stack
// sp will point to the top of the stack where 69 is located.
str x1, [sp, #-16]! 
str x2, [sp, #-16]!

// x3 should now contain 100
ldr x3, [sp]
add sp, sp, #16

//x4 should now contain 69
ldr x4, [sp]


mov x0, #0
ret
