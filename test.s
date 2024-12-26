.section .data
my_string: .asciz "Hello, World!%d\n"

.section .text
.global _start

_start:
   
    ldr x0, =my_string
    mov x1, #69

    
    bl printf

    
    mov x8, 93                  
    mov x0, 0                   
    svc 0
