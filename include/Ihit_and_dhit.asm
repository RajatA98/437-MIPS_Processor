org 0x0000

ori $2, 1
ori $3, 1
ori $4, 3

sw $2, 0x000A($3)

loop
	lw $5, 0x000A($3)
	addi $4, $4,-1
	bne $4,$0, loop 

halt
