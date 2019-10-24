org 0x0000

ori $2, $0, 1
ori $3, $0, 4
ori $4, $0, 3

sw $2, 0xF000($3)

loop:
	lw $5,0xF000($3)
	addi $4, $4,-1
	
	#sw $2, 0x000A($3)
	#addi $3, $3, 4
	bne $4,$0, loop 
halt
