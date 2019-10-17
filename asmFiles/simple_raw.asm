org 0x0000
ori   $1,$zero,0xD269

ori   $21,$zero,0x80

ori   $14,$0,4 
sllv  $11,$14,$1
sw    $11,0($21)
halt
