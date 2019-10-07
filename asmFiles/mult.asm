org 0x0000

ori $3, $0, 0x03
jal push_process
ori $4, $0, 0
ori $3, $0, 0x02
jal push_process
ori $6, $0, 0
pop_process: 
	lw $2, 0xFFF8($0)
	lw $12, 4($2)

	addi $2, $2, 4
	sw $2, 0xFFF8($0)

	lw $2, 0xFFF8($0)
	lw $13, 4($2)

	addi $2, $2, 4
	sw $2, 0xFFF8($0)
	j mul



mul: 
	add $6,$6,$12
	addi $4, $4,1
	bne $4,$13, mul 
	
halt
push_process:
	lw $2, 0xFFF8($0)
	addi $2, $2, -4 
	sw $3,4($2)
	sw $2, 0xFFF8($0)
	jr $31

org 0xFFF8
cfw 2000

