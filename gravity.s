.text
.equ s_letter, 0
.equ s_number, 16
.equ s_s1_aligned, 32
.type main, %function
.global

main:

str x19, [sp, #-16]!
sub sp, sp, #s_s1_aligned
mov x19, sp


