.data
    student:
        .asciz "Siti"         // First name (null-terminated string)
        .asciz "Aminah"       // Last name (null-terminated string)
        .word 5               // Class (int, 4 bytes)
        .word 67, 59, 71, 92, 85, 63, 82 // Grades (int array, 4 bytes each)
    num_grades: .word 7       // Number of elements in array

.text

.global main
main:
    ldr x9, =student          // Load the base address of `student`             
    add x0, x9, #16  // Load the address of the grades array (67)
    bl calcAvg
    ret




.type calcAvg,%function
calcAvg:
    mov x8, x0              // Start address of array
    mov x9, #0              // Loop counter
    mov w10, #0             // Sum accumulator
    ldr x11, =num_grades    // Load the address of num_grades
    ldr w11, [x11]          // Load the value of num_grades into w11

loop_start:
    cmp x9, x11             // Compare counter (x9) with num_grades (x11)
    bge calc_done           // If counter >= num_grades, exit loop

    ldr w12, [x8, x9, LSL #2] // Load array element (4 bytes per element)
    add w10, w10, w12       // Add current grade to sum
    add x9, x9, #1          // Increment loop counter
    b loop_start            // Repeat loop

calc_done:
    udiv w0, w10, w11       // Calculate average (x10 / x11)
    ret                     // Return result in x0



