.data
    arr: .word 69, 54, 2, 96, 1  // Array of integers
    .equ arr_len, 5              // Length of the array
    format_str: .asciz "The element at index %d is now: %d\n"

.text

    .global _start
    .type _start,%function
_start:
    adr x0, arr              // Address of the array
    mov x1, #4               // Outer loop counter (arr_len - 1)

outer_loop:
    cmp x1, #0               // Check if outer loop is complete
    beq sort_done            // If complete, exit sorting

    mov x2, #0               // Reset inner loop counter

inner_loop:
    cmp x2, x1               // Compare inner loop counter with outer loop limit
    bge outer_decrement      // If inner loop complete, go to next outer loop iteration

    ldr w3, [x0, x2, LSL #2]       // Load element at index x2
    add x4, x2, #1                 // Compute index for x2 + 1
    ldr w4, [x0, x4, LSL #2]       // Load element at index x2 + 1

    cmp w3, w4                     // Compare the two elements
    ble skip_swap                  // If already sorted, skip swapping

    str w4, [x0, x2, LSL #2]       // Swap elements: Store the larger value at x2
    str w3, [x0, x4, LSL #2]       // Swap elements: Store the smaller value at x2 + 1

skip_swap:
    add x2, x2, #1                 // Increment inner loop counter
    b inner_loop                   // Repeat inner loop

outer_decrement:
    sub x1, x1, #1                 // Decrement outer loop counter
    b outer_loop                   // Repeat outer loop

sort_done:
    mov w1, #1
    ldr w2, [x0]                  // Load the first element of the sorted array into w1
    adr x0, format_str            // Load the format string address into x0
    bl printf                     // Print the first element
    mov x8, #93                   // Exit code 93 (or any arbitrary code for testing)
    svc #0                        // Exit system call (for Linux)

    ret                           // Sorting complete

