  org 0x0000
  addiu $1,$0,0x1
	addiu $2,$0,0x3
  sw    $1,0xFF00($0)
  sw    $1,0xFF00($0)
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  halt  # that's all
