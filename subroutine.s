.data
    arr: .word 4, 8, 8, 20

.text

    .type main, %function
    .global main
    main:
        adr x0, arr // base address of arr is moved in x0 to be passed as params
        mov x1, #4 // the number of elements moved in x1 to be passed as params 
        bl calcAvg
        //expect x0 to contain 20
        ret

    .type calcAvg, %function
    calcAvg:
    //x0 contains the address of the array passed as param
    //x1 contains the number of elements, will be used as divisor and the for loop limit
    mov x8, #0 // initialize loop counter
    mov w9, #0 // initialize sum

    //compare the loop-counter with size of the array x1
    check:
        cmp x8, x1
        blt for
        b end
    
    for:
        ldr w10, [x0, x8, lsl #2]
        add w9, w9, w10
        add x8, x8, #1
        b check

    end:
        //calculate the avg here
        udiv w0, w9, x1

    ret


