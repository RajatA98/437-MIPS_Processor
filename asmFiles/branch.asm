org 0x0000

ori $8, $0, 0
ori $9, $0, 3

loop:
addi $8, $8, 1
bne $8,$9, loop
add $2, $8, $9
sub $2, $8, $9

beq $8,$9, exit
nor $8,$9,$0

exit:
halt

