org 0x000

ori $2, $0, 3
ori $3, $0, 2
add $2, $3, $2
addi $29, $29, -4
sw $2, 4($29)
lw $1, 4($29)
sub $4, $1, $3
addi $29, $29, 4

halt

