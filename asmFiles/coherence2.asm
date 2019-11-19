#first processor

org 0x0000

ori   $1,$zero,0xF0
ori   $2,$zero,0x80
ori   $5, $zero, 0x40 

sw    $3,0($2) 
sw    $5,0($2)

halt

#second processor
org 0x0200

ori   $1,$zero,0xF0
ori   $2,$zero,0x80
ori   $5, $zero, 0x40 

nop
nop
nop

nop
nop
nop

nop
nop
nop


nop
nop
nop

nop
nop
nop


nop
nop
nop

nop
nop
nop

nop
nop
nop
lw    $3, 0($2)

halt

