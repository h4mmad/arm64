.data
mesg:	.asciz		"Number is: %d\n"
arr:	.word		1, 2, 3, 4, 5, 6, 7

		.text
		.type		main, %function
		.global		main

main:
		mov		x19, #0 // counter
        adr		x20, arr

    

loop:
        cmp x19, #28  // compare counter with array size 4*7
        bge end

        adr		x0, mesg
        ldr		w1, [x20, x19]
		bl		printf

		add		x19, x19, #4
		b		loop
end:
	
    // this is linux specific, you can use mov x0, 0 and then ret
    mov x8, 93                  
    mov x0, 0                   
    svc 0
		