org 0x0000

andi $t0, $t0, 0
andi $t1, $t1, 0

bne $t0, $t0, test
addi $t0, $t0, 5
halt

test:
	addi $t0, $t0, 8
	halt
