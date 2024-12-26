.data
sqrt: .word 0, 1, 1, 2, 2, 2, 2, 3, 3, 3  // Lookup table for sqrt
.equ gravity_constant, 10
.equ test_height, 35

.text

.type main, %function
.global main
main:
    mov x0, #test_height
    bl caclDropTime
    
    mov x1, x0 // mov the index into w1, as second arg
    adr x0, sqrt //load the address of sqrt as first argument
   
    bl getSqrootLUT

    ret


// returns the index, 
// so we can find its sqrt in lookup table
.type caclDropTime, %function
caclDropTime:
    lsl x0, x0, #1 // 2h
    mov x8, #gravity_constant 
    udiv x0, x0, x8// 2h/g
    ret


// first argument is address of LUT
// second argument is index 
.type getSqrootLUT, %function
getSqrootLUT:
    ldr w3, [x0, x1, lsl #2]
    mov w0, w3
    ret