org 0x0000
jal store
j addr

store:
ori $2, $0, 1
jr $31

addr:
addi $3, $2, 1

halt
