org 0x0000

ori $8, $0, 0
ori $9, $0, 3

loop:
addi $8, $8, 1
bne $8,$9, loop

beq $8,$9, exit

exit:
halt

