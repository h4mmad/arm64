    .data

// initializing a 10 element array of 4 bytes with 69. 
arr:    .fill 10, 4, 0

msg:    .asciz "Element %d is: %d\n"

    .text
    .type _start, %function
    .global _start
_start:

    // loads the start address of the array relative to PC in register x2
    // use a xN register as memory addresses are 64 bit.
    adr x2, arr
    
    // moving in x3 the number 0
    // will be used as i the counter.
    mov w3, #0 
 
for:
        cmp w3, #10
        blt increment
        b end

increment:
        
       // j = i * 2, (x4 = x3 * 2)
        lsl w4, w3, #1
        
        str w4, [x2, x3, lsl #2] 
        // Increment x3 by 1 (x3 = x3 + 1)
        add w3, w3, #1
        b for

end:

// Verify the values in the array by loading from mem
    ldr w5, [x2]
    ldr w6, [x2, #4]
    ldr w7, [x2, #8]
    ldr w8, [x2, #12]
    ldr w9, [x2, #16]
  
    mov x0, #0            // Return 0
    ret
