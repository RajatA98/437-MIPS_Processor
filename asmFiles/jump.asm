org 0x0000
ori $8, $0, 0
ori $2, $0, 0x0010
jal store
addi $2, $2, 0x005
j addr
add $2, $2, $8

store:
ori $2, $0, 1
jr $31
or $8, $2, $0


addr:
addi $3, $2, 1

halt
