#first processor

org 0x0000

ori   $1,$zero,0xF0
ori   $2,$zero,0x80
ori   $3, $zero, 0xF00

sw    $3,0($2) 

halt

#second processor
org 0x0200


ori   $1,$zero,0xF4
ori   $4,$zero,0x80


nop
nop
nop

sw    $1,0($4)


halt


