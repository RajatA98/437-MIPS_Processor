org 0x000

ori $2, $0, 3
ori $3, $0, 2
add $2, $3, $2
ori $29, $0, 0xfffc
addi $29, $29, -4
sw $2, 0($29)
lw $1, 0($29)
sub $4, $1, $3
addi $29, $29, 4
sw $2, 0($29)
add $14,$2,$29
sw $14,-12($29)
halt

