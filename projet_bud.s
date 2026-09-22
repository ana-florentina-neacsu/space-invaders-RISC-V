.data
newline: .asciz "\n"
.text
j task3

task1:

li t0 1
li t1 10
loop:
	bgt t0 t1 end_loop
	mv a0 t0
	li a7 1
	ecall
	la a0 newline
	li a7 4
	ecall
	li a0 500
	li a7 32
	ecall
	addi t0 t0 1
	j loop
ecall
end_loop:
li a7 10
ecall

task2:
	li a1 0xffff0000
	li a2 0xffff0004
	li a3 105    #i
	li a4 112    #p
	li a5 111    #o
	li t0 0
never_ending:
	mv a0 t0
	li a7 1
	ecall
	la a0 newline
	li a7 4
	ecall
	li a0 500
	li a7 32
	ecall
	#check if key was pressed
	lw t1 (a1)
	andi t1,t1,1
	beqz t1, no_key
	#key was pressed
yes_key:
	lw t1 (a2)
	beq t1 a5 end
	beq t1 a3 diminuer
	beq t1 a4 augmenter
	#
no_key:
	j never_ending
	#
diminuer:
	addi t0 t0 -1
	lw zero (a2)
	j never_ending
augmenter:
	addi t0 t0 1
	lw zero (a2)
	j never_ending
end:
	li a7 10
	ecall
task3:
j applic_2

applic_1:
li t0 0x10010000 #start of screen
li t1 0x10050000 #end of first half of screen
li s0 0x00ff0000 #red
mv t2 t0 #iterator
red_loop:
bgt t2 t1 end_red_loop
sw s0 (t2)
addi t2 t2 4
j red_loop
end_red_loop:
li a7 10
ecall

applic_2:
li t0 0x10010000 #start of screen
li t1 0x10010800 #end of first half of screen
li s0 0x00ff0000 #red
mv t2 t0 #iterator
red_loop_64:
sw s0 (t2)
addi t2 t2 4
bge t2 t1 end_red_loop_64
j red_loop_64
end_red_loop_64:
li a7 10
ecall
