org 0x0000

ori $2, $0,1
ori $3, $0, 4

sw $2, 0xF000($3)
ori $2, $0, 2
sw $2, 0xFF00($3)
ori $2,$0, 3
sw $2, 0xFF00($3)
lw $2, 0x000C($3)
halt
