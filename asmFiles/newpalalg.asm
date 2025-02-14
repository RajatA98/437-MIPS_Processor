#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000              # first processor p0
  ori   $sp, $zero, 0x3ffc  # stack
	ori   $s4, $0, 0xFF70
	jal   mainp0              # go to program
	halt

mainp0:
	push $ra
	ori $s1, $0, 0           #r15 fine
	ori $s2, $0, 5				 #r24 fine
	
loop0:
wait1:
	lw $s3, mystack($0)
	beq $s3, $s4, wait1
	or $v1, $0, $s1
	ori $a0, $zero, l      # move lock to arguement register r4 fine
	jal lock                # try to aquire the lock	
	jal push_process
	ori   $a0, $zero, l      # move lock to arguement register r4 fine
  jal   unlock     
		
	addi $s1, $s1, 1					#r15 = r15 + 1
	bne $s1, $s2, loop0				#r15 == r24 ? 0:1

	pop $ra
	jr $ra


push_process:
	
	lw $t6, mystack($0)
	addi $t6, $t6, -4 
	sw $v1,4($t6)
	sw $t6, mystack($0)
	jr $ra		

		
l:
  cfw 0x0

#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1
  ori   $sp, $zero, 0x7ffc 	#stack
	ori 	$s0, $0, 0xFF98
	
  jal   mainp1              # go to program
  halt
mainp1:
	push $ra
	
	ori $s1, $0, 0 
	ori $s2, $0, 5

loop1:
wait2:	
	lw $s7, mystack($0)
	beq $s7, $s0, wait2 
	ori $a0, $zero, l      # move lock to arguement register
	jal lock                # try to aquire the lock
	jal pop_process
	ori $a0, $zero, l      # move lock to arguement register
  jal unlock              # release the lock

	addi $s1, $s1, 1
	bne $s1, $s2, loop1
	
	pop $ra
	jr $ra
#--------------------------------------------------
#push pop process for shared stack
#--------------------------------------------------


pop_process: 
	lw $t6, mystack($0)
	
	lw $v1, 4($t6)
	#andi $v1, $v1, 0xFFFF #jihan changed this
	sw $zero, 4($t6)
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


org 0x0FF0
mystack:
cfw 0xFF98

