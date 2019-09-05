org 0x000

ori $4, $0,4 #n 
push $4
ori $16, $0, 0
ori $3, $0, 1
jal FIB

	#push $31i
Recursion: 	
	addi $4, $4, -1 #n-1
	jal FIB
	
	add $16, $16, $4
	pop $4
	#push $3

	addi $4, $4, -2 #n -2
	jal FIB
	add $16, $16, $4
	halt

FIB:
	beq $4, $0, r0
	beq $4, $3, r1
	jr $31
	
r0:
	halt
r1:
	halt
	
		
