/*
    Author: Mohammed Hammad
 */

.data
    // Define struct
    student:
        .asciz "Siti"         // First name (null-terminated string)
        .asciz "Aminah"       // Last name (null-terminated string)
        .word 5               // Class (int, 4 bytes)
        .word 67, 59, 71, 92, 85, 63, 82 // Grades (int array, 4 bytes each)
    
    // Define offsets
    .equ s_fname, 0                // first name offset
    .equ s_lname, 5                // last name offset
    .equ s_class, 12               // Offset for class
    .equ s_grades, 16              // Offset for grades array

    .equ num_grades, 7  // number of elements

    full_name_format: .asciz "The student's full name is %s %s.\n"
    avg_format: .asciz "The grade average is: %d.\n"
    element_format: .asciz "The element at index %d is %d.\n"
.text


/*
calc_avg_median has one argument:
1. Start address of array - x0

It returns the average grade in w0
and median in w1.
*/
.type calc_avg_median,%function
    calc_avg_median:
        mov x1, #0              // Loop counter
        mov w2, #0             // Sum accumulator
        mov x11, #num_grades

    loop_start:
        cmp x1, x11             // Compare counter (x9) with num_grades (x11)
        bge calc_done           // If counter >= num_grades, exit loop

        ldr w12, [x0, x1, LSL #2] // Load array element (4 bytes per element)
        add w2, w2, w12       // Add current grade to sum
        add x1, x1, #1          // Increment loop counter
        b loop_start            // Repeat loop

    calc_done:
        mov w11, #num_grades
        udiv w0, w2, w11   // Calculate average (x10 / x11)
        ret                     // Return result in x0
        
/*
This subroutine has two arguments:
1. Start address of array - x0
2. Index of element - x1 (has to xN register as for scaled addressing only 64-bit registers allowed)

It returns the element at the provided valid index
*/
.type get_element_by_index,%function
get_element_by_index:
    ldr w0, [x0, x1, lsl #2]
    ret

.global _start
.type _start,%function
_start:

    /*  Load the base of student struct into x19, which is a callee-saved register non-volatile
        will remain intact across function calls. (x19-x28)

        Load the start address of grades array into x20, by using offset.
    */ 

    adr x19, student
    add x20, x19, #s_grades   

    // First printf: Print full name

    adr x0, full_name_format   // Format string
    add x1, x19, #s_fname        // Address of "Siti"
    add x2, x19, #s_lname        // Address of "Aminah"
    bl printf



    // Prepare params for calculating avg, pass into x0, the start address of array
    // Return value in w0
    mov x0, x20
    bl calc_avg_median

    // store in x0, the format address.
    // store in w1 the avg value
    mov w1, w0
    ldr x0, =avg_format
    bl printf


        
    // Linux specific
    mov x8, 93                  
    mov x0, 0                   
    svc 0
