.data
##YOU WILL NOT EAT MY VARIABLES!!! (change at your own risk)
	no_eating_variables: .space 65536
##for image
	larg_image: .word 256
	haut_image: .word 256
	larg_unit: .word 8
	haut_unit: .word 8
	I_buff: .word 0 ##will change to address of image space
	larg_in_units: .word 0 #we will need these a lot and they don't change once the game starts
	haut_in_units: .word 0 #so it's more efficient to calculate them once and store them here
	I_visu: .word 0x10010000
## for keyboard
	RCR: .word 0xffff0000
	RDR: .word 0xffff0004
## for joueur
	x_joueur: .word 12
	y_joueur: .word 29
	larg_joueur: .word 5
	haut_joueur: .word 2
	col_joueur: .word 0x0000ff
#for envahisseurs
	nr_env: .word 20
	larg_env: .word 2
	haut_env: .word 1
	col_env: .word 0xff0000
	esp_hor_env: .word 1
	aug_ord_env: .word 1
	rythme_tirs: .word 50
#for obstacles
	no_obs: .word 5
	larg_obs: .word 3
	haut_obs: .word 2
	esp_hor_obs: .word 1
	col_obs: .word 0xfff000
#for missiles
	col_mis: .word 0xffffff
	vit_mis: .word 50
	long_mis: .word 3
	ep_mis: .word 1
	no_max_mis: .word 5
## for tests
newline: .asciz "\n"
space: .asciz " "
.text
j main
## fonctions image
I_largeur:
	lw t0, larg_image
	lw t1, larg_unit
	div a0, t0, t1
	la t0, larg_in_units
	sw a0, (t0)
	jr ra
I_hauteur:
	lw t0, haut_image
	lw t1, haut_unit
	div a0, t0, t1
	la t0, haut_in_units
	sw a0, (t0)
	jr ra
I_creer:
##prologue
	addi sp sp -12
	sw ra (sp)
	sw s0 4(sp)
	sw s1 8(sp)
##corps
	jal I_largeur
	mv s0, a0
	jal I_hauteur
	mv s1, a0
	mul s0, s0, s1 #s0 is total nr of units allocated
	li t0 4 # size of word in bytes
	mul a0, s0, t0 # a0 = nr bytes allocated
	li a7 9
	ecall
	la t0 I_buff
	sw a0 (t0)
	lw s1 8(sp)
	lw s0 4(sp)
	lw ra(sp)
	addi sp sp 12
	jr ra
I_xy_to_addr: # a0 = abs, a1 = ord
	lw t0, larg_in_units
	mul t0, t0, a1
	add t0, t0, a0
	li t1 4
	mul a0, t0, t1
	lw t1 I_buff
	add a0 a0 t1
	jr ra
I_addr_to_xy: #a0 = address of unit
	lw t0, I_buff
	sub a0 a0 t0 #a0 = decalage in bytes
	li t0 4
	div a0 a0 t0 #a0 = decalage in units
	mv t0 a0
	lw t1 larg_in_units
	div t0 t0 t1 #t0 = abscisse
	mul t2 t0 t1 #t2 = decalage - ordonee
	sub a1 a0 t2 # a1 = ordonee
	mv a0 t0 # a0 = abscisse
	jr ra
I_plot:
#prologue
# this function does not modify any a register
	addi sp sp -12
	sw ra (sp)
	sw a0 4(sp)
	sw a1 8(sp)
#corps
# a0 = abscisse, a1 = ordonee, a2 = couleur
	jal I_xy_to_addr
	sw a2 (a0)
#epilogue
	lw ra (sp)
	lw a0 4(sp)
	lw a1 8(sp)
	addi sp sp 12
	jr ra
I_effacer:
	lw t1 I_buff
	lw t2 larg_in_units
	lw t3 haut_in_units
	mul t2 t2 t3 #t2 is now total number of units
loop_effacer:
	beqz t2 exit_loop_effacer
	sw zero (t1)
	addi t1 t1 4
	addi t2 t2 -1
	j loop_effacer
exit_loop_effacer:
	jr ra
I_rectangle:
# a0, a1 = abs, ord coin gauche
# a2 = hauteur , a3 = largeur, a4 = couleur
# prologue
	addi sp sp -44
	sw ra (sp)
	sw s0 4(sp)
	sw s1 8(sp)
	sw s2 12(sp)
	sw s3 16(sp)
	sw s4 20(sp)
## i am also saving the a registers for animation purposes
	sw a0 24(sp)
	sw a1 28(sp)
	sw a2 32(sp)
	sw a3 36(sp)
	sw a4 40(sp)
#corps
	mv s0 a0
	mv s1 a1
	mv s2 a2
	mv s3 a3
	mv s4 a4
rectangle_loop_ext:
	beqz s2 exit_rectangle_loop_ext
	mv a3 s3
rectangle_loop_int:
	beqz a3 exit_rectangle_loop_int
	mv a2 s4
	jal I_plot
	addi a1 a1 1
	addi a3 a3 -1
	j rectangle_loop_int
exit_rectangle_loop_int:
	addi s2 s2 -1
	addi a0 a0 1
	mv a1 s1
	j rectangle_loop_ext
exit_rectangle_loop_ext:
#epilogue
	lw ra (sp)
	lw s0 4(sp)
	lw s1 8(sp)
	lw s2 12(sp)
	lw s3 16(sp)
	lw s4 20(sp)
## restoring a registers too
	lw a0 24(sp)
	lw a1 28(sp)
	lw a2 32(sp)
	lw a3 36(sp)
	lw a4 40(sp)
	addi sp sp 44
	jr ra
animation_1:
# made this into a function so the code looks cleaner
# a0, a1 = coordonees start
# a2, a3 = dimensions
# a4 = couleur
#prologue
	addi sp sp -8
	sw ra (sp)
	sw s0 4(sp)
#corps
	mv s0 a0
animation_loop_1:
	add t0 a0 a2
	lw t1 larg_in_units
	bgt t0 t1 stop_animation_1
	jal I_effacer
	li a0 50
	li a7 32
	ecall
	mv a0 s0
	jal I_rectangle
	li a0 50
	li a7 32
	ecall
	mv a0 s0
	jal affichage
	addi a0 a0 1
	addi s0 s0 1
	j animation_loop_1
stop_animation_1:
#epilogue
	lw ra (sp)
	lw s0 4(sp)
	addi sp sp 8
	jr ra
affichage:
## for debug and testing
#prologue
	addi sp sp -8
	sw ra (sp)
	sw a0 4(sp)
#corps
	lw t0 I_buff
	lw t1 larg_in_units
	lw t2 haut_in_units
external_loop:
	beqz t2 stop_affichage
	lw t1 larg_in_units
internal_loop:
	beqz t1 exit_internal
	lw a0 (t0)
	li a7 1
	ecall
	la a0 space
	li a7 4
	ecall
	addi t0 t0 4
	addi t1 t1 -1
	j internal_loop
exit_internal:
	addi t2 t2 -1
	la a0 newline
	li a7 4
	ecall
	j external_loop
stop_affichage:
#epilogue
	lw ra (sp)
	lw a0 4(sp)
	addi sp sp 8
	jr ra
I_buff_to_visu:
#prologue
#corps	
	lw t0 I_buff # t0 is buffer start address
	lw t1 I_visu # t1 is display start address
	lw t2 larg_in_units # t2 is largeur in units of screen
	lw t3 haut_in_units # t3 is hauteur in units of screen
	mul t2 t2 t3 # t2 is number of units on screen
	#we will use t2 as counter and t3 as aux from buff to visu
btv_loop:
	beqz t2 end_btv_loop
	lw t3 (t0)
	sw t3 (t1)
	addi t2 t2 -1
	addi t0 t0 4
	addi t1 t1 4
	j btv_loop
end_btv_loop:	
#epilogue
	jr ra
animation_2:
#this time we can see it happen on the screen
#no longer need debug afffichage, we use buff_to_visu instead
# a0, a1 = coordonees start
# a2, a3 = dimensions
# a4 = couleur
#prologue
	addi sp sp -8
	sw ra (sp)
	sw s0 4(sp)
#corps
	mv s0 a0
animation_loop_2:
	add t0 a0 a2
	lw t1 larg_in_units
	bgt t0 t1 stop_animation_2
	jal I_effacer
	li a0 50
	li a7 32
	ecall
	mv a0 s0
	jal I_rectangle
	li a0 50
	li a7 32
	ecall
	mv a0 s0
	jal I_buff_to_visu
	addi a0 a0 1
	addi s0 s0 1
	j animation_loop_2
stop_animation_2:
#epilogue
	lw ra (sp)
	lw s0 4(sp)
	addi sp sp 8
	jr ra
main:
	
	jal I_creer
	#create rectangle
	li a0 0
	li a1 0
	li a2 5
	li a3 2
	li a4 0xff0000
	jal animation_2
	li a7,10
	ecall	

