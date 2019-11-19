#REGISTERS
#at $1 at
#v $t6-3 function returns
#a $4-7 function args
#t $8-15 temps
#s $16-23 saved temps (callee preserved)
#t $t64-25 temps
#k $t66-27 kernel
#gp $t68 gp (callee preserved)
#sp $t69 sp (callee preserved)
#fp $30 fp (callee preserved)
#ra $31 return address
#a0 - for lock
#a1 - for subcrc
#a2, 3 - submm
#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000              # first processor p0
	ori   $sp, $zero, 0x3ffc  # stack
  jal   mainp0              # go to program
	halt

mainp0:
	push $ra
	
	
	
		

#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1
  ori   $sp, $zero, 0x7ffc 	#stack
  jal   mainp1              # go to program
  halt

#----------------------------------------------------------
#subroutine_crc
#----------------------------------------------------------

crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  ori $t5, $0, 31
  srlv $t4, $t5, $a1
  ori $t5, $0, 1
  sllv $a1, $t5, $a1
  beq $t4, $0, l3
  xor $a1, $a1, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a1, $0
  jr $ra

#----------------------------------------------------------
#subroutine_mm
#----------------------------------------------------------

#-max (a2=a,a3=b) returns v0=max(a,b)--------------
max:
  push  $ra
  push  $a2
  push  $a3
  or    $v0, $0, $a2
  slt   $t0, $a2, $a3
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a3
maxrtn:
  pop   $a3
  pop   $a2
  pop   $ra
  jr    $ra
#--------------------------------------------------

#-min (a2=a,a3=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $a2
  push  $a3
  or    $v0, $0, $a2
  slt   $t0, $a3, $a2
  beq   $t0, $0, minrtn
  or    $v0, $0, $a3
minrtn:
  pop   $a3
  pop   $a2
  pop   $ra
  jr    $ra
#--------------------------------------------------

#--------------------------------------------------
#push pop process for shared stack
#--------------------------------------------------

push_process:
	lw $t6, mystack($0)
	addi $t6, $t6, -4 
	sw $3,4($t6)
	sw $t6, mystack($0)
	jr $ra
pop_process: 
	lw $t6, mystack($0)
	lw $12, 4($t6)

	addi $t6, $t6, 4
	sw $t6, mystack($0)

	lw $t6, mystack($0)
	lw $13, 4($t6)

	addi $t6, $t6, 4
	sw $t6, mystack($0)
	jr $ra

#--------------------------------------------------
#lock unlock
#--------------------------------------------------

# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
aquire:
  ll    $t0, 0($a0)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a0)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra


# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
  sw    $0, 0($a0)
  jr    $ra
org 0xF000
mystack:
cfw 2000
