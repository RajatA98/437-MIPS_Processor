org 0x0000

#ori $2, $0, 0xFFFC
#sw $2, 2000($0)
ori $3,$0,3
jal push_process

ori $3,$0,4
jal push_process

ori $3,$0,5
jal push_process

ori $3, $0,2
jal push_process

#halt
ori $10, $0, 0 #counter
ori $11, $0, 0 #result
ori $12, $0, 0
ori $13, $0, 0
ori $14, $0, 2000



pop_process: 
	lw $2, 0xFFFC($0)
	lw $12, 4($2)

	addi $2, $2, 4
	sw $2, 0xFFFC($0)

	lw $2, 0xFFFC($0)
	lw $13, 4($2)

	addi $2, $2, 4
	sw $2, 0xFFFC($0)
	j mul
	

	 



mul: 
	add $11,$11,$12
	addi $10, $10,1
	bne $10, $13, mul
#check:
	lw $2, 0xFFFC($0)
	beq $2, $14, exit
	sw $2, 0xFFFC($0)


ori $10, $0, 0 
or $3, $0, $11
ori $11, $0, 0
jal push_process
#addi $2, $2, -4
#sw $3, 4($2)

j pop_process
exit:

	halt
push_process:
	lw $2, 0xFFFC($0)
	addi $2, $2, -4 
	sw $3,4($2)
	sw $2, 0xFFFC($0)
	jr $31
org 0xFFFC
cfw 2000
	      





