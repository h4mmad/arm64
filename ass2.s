/*
    Author: Mohammed Hammad
    Group members:
      - Mohammed Hammad 154434
      - Hateez Shafat Khan
*/

.data
    // Define struct
    student:
        .asciz "Siti"         // First name (null-terminated string)
        .asciz "Aminah"       // Last name (null-terminated string)
        .word 5               // Class (int, 4 bytes)
        .word 67, 59, 71, 92, 85, 63, 82 // Grades (int array, 4 bytes each)
    
    // Define offsets
    .equ s_first_name, 0                // first name offset
    .equ s_last_name, 5                // last name offset
    .equ s_class, 12               // Offset for class
    .equ s_grades, 16              // Offset for grades array

    .equ num_grades, 7  // number of elements

    full_name_format: .asciz "The student's full name is %s %s.\n"
    avg_median_format: .asciz "The average is: %d, and the median is: %d.\n"
    max_min_value: .asciz "The MIN value of the arrays is: %d. and the MAX value is: %d\n"
    element_format: .asciz "The element at index %d is %d.\n"

.text


/****************************************************************************** 
 * calc_avg_median
 *
 * Description:
 *   Calculates the average and median of an array of integers.
 *
 * Parameters (inputs):
 *   x0 = pointer to the start of the integer array
 *
 * Return values (outputs):
 *   w0 = average of all array elements (32-bit integer)
 *   w1 = median of all array elements (32-bit integer)
 *
 * Notes:
 *   - This function assumes the array size is known (num_grades).
 *   - The function assumes the array is sorted to find median
 ******************************************************************************/
.type calc_avg_median,%function
    calc_avg_median:
        mov x1, #0              // Loop counter
        mov w2, #0              // Sum accumulator
        mov x11, #num_grades
        mov x10, x0 // copy of address araay

    loop_start:
        cmp x1, x11             // Compare counter (x9) with num_grades (x11)
        bge calc_done           // If counter >= num_grades, exit loop

        ldr w12, [x0, x1, LSL #2] // Load array element (4 bytes per element)
        add w2, w2, w12       // Add current grade to sum
        add x1, x1, #1          // Increment loop counter
        b loop_start            // Repeat loop

    calc_done:
        mov w11, #num_grades   
        udiv w0, w2, w11 

    // Median calculation
   
    // get middle element and return in w1
    // logic to get middle element index of  array size divided by 2
    mov x1, #num_grades        // Load the number of elements in the array (odd size)
    mov x2, #2                 // Divisor for calculating middle index
    udiv x3, x1, x2            // Unsigned division: x3 = num_grades / 2

    ldr w1, [x10, x3, LSL #2]  // Load the element at index (x3 * 4) into w1

    ret       



/****************************************************************************** 
 * bubble_sort_array
 *
 * Description:
 *   Sorts the array in ascending order using bubble sort
 *
 * Parameters (inputs):
 *   x0 = pointer to the start of the grades array
 *
 * Return values (outputs):
 *   None
 *   
 *
 * Notes:
 *   - This function assumes the array size is known (num_grades).
 *   - Sorting is done in-place (the array is modified).
 ******************************************************************************/
.type bubble_sort_array,%function
bubble_sort_array:
    mov x2, #num_grades          // Number of elements in the array
    sub x2, x2, #1               // Outer loop: size - 1 passes

    outer_loop:
        cmp x2, #0               // If size <= 0, sorting is complete
        ble exit_loop            // Exit when all passes are done
        mov x1, #0               // Reset inner loop index

    inner_loop:
        cmp x1, x2                 // Compare inner loop index with size - pass
        bge next_outer_loop        // If inner loop completes, go to next outer loop

        ldr w3, [x0, x1, LSL #2]  // Load element at index i
        add x5, x1, #1             // Calculate index i + 1
        ldr w4, [x0, x5, LSL #2]  // Load element at index i + 1

        cmp w3, w4                 // Compare element[i] and element[i + 1]
        ble no_swap                // If element[i] <= element[i + 1], no swap needed

        // Swap element[i] and element[i + 1]
        str w4, [x0, x1, LSL #2] // Store element[i + 1] at index i
        str w3, [x0, x5, LSL #2] // Store element[i] at index i + 1

    no_swap:
        add x1, x1, #1           // Increment inner loop index
        b inner_loop             // Repeat inner loop

    next_outer_loop:
        sub x2, x2, #1           // Decrement outer loop counter
        b outer_loop             // Repeat outer loop

    exit_loop:
        mov x0, #0
        ret


/****************************************************************************** 
 * get_element_by_index
 *
 * Description:
 *   Returns the element at the provided valid index.
 *
 * Parameters (inputs):
 *   x0 = pointer to the start of the grades array
 *   x1 = index of element to be returned
 * Return values (outputs):
 *   w0 = element at index provided
 *   
 *
 * Notes:
 *   - This function assumes the array size is known (num_grades).
 ******************************************************************************/
.type get_element_by_index,%function
get_element_by_index:
    ldr w0, [x0, x1, lsl #2]
    ret



/****************************************************************************** 
 * get_max_min_value
 *
 * Description:
 *   Returns the maximum and minimum value of the array provided it is sorted.
 *   The min value will be located at index 0 of the array, the max value 
 *   will be located at index array_size -1. 
 *Parameters (inputs):
 *   x0 = pointer to the start of the grades array
 *
 * Return values (outputs):
 *   w0 = MIN element in array
 *   w1 = MAX element in array
 *
 * Notes:
 *   - This function assumes the array size is known (num_grades) and is sorted.
 ******************************************************************************/
.type get_max_min_value, %function
get_max_min_value:
    mov x1, x0        // copy address of array into x1
    mov x2, #num_grades
    sub x2, x2, #1
    ldr w0, [x1, #0]
    ldr w1, [x1, x2, lsl #2]
    ret 

.global _start
.type _start,%function
_start:

    adr x19, student            // Load address of student struct
    add x20, x19, #s_grades     // Use offset, load address of grades array

    //Print student's name
    adr x0, full_name_format
    add x1, x19, #s_first_name
    add x2, x19, #s_last_name
    bl printf
   
    //Prepare x0, copy address into x0
    // Call Bubble sort
    // Call calc_avg_median
    mov x0, x20
    bl bubble_sort_array 
    mov x0, x20
    bl calc_avg_median

    mov w5, w0
    mov w6, w1
    adr x0, avg_median_format
    mov w1, w5
    mov w2, w6
    bl printf 


    mov x0, x20
    bl get_max_min_value
    mov w5, w0
    mov w6, w1
    adr x0, max_min_value
    mov w1, w5
    mov w2, w6
    bl printf
            
    // Linux specific
    mov x8, 93                  
    mov x0, 0                   
    svc 0
