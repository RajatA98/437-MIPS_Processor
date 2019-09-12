org 0x0000

ori $3, $0, 28
jal push_process

ori $3, $0, 8
jal push_process

ori $3, $0, 2019
jal push_process

jal pop_process
addi $12, $3, -2000
ori $13, $0, 365
ori $10, $0, 0
ori $11, $0, 0
jal mul

or $15, $0, $11

ori $11, $0, 0
ori $10, $0, 0

jal pop_process
addi $3, $3, -1
or $13, $0, $3

ori $12, $0, 30
jal mul

or $14, $0, $11
ori $11, $0, 0
ori $10, $0, 0

jal pop_process


add $11, $3, $14
add $11, $11, $15
halt


mul: 
	add $11,$11,$12
	addi $10, $10,1
	bne $10, $13, mul
	jr $31

push_process:
	lw $2, 0xFFFC($0)
	addi $2, $2, -4 
	sw $3,4($2)
	sw $2, 0xFFFC($0)
	jr $31
pop_process: 
	lw $2, 0xFFFC($0)
	lw $3, 4($2)

	addi $2, $2, 4
	sw $2, 0xFFFC($0)
	jr $31

org 0xFFFC
cfw 5000


