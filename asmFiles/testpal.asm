#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000              # first processor p0
  ori   $sp, $zero, 0x3ffc  # stack
  jal   mainp0              # go to program
	halt

mainp0:
	push $ra
	
	ori $t7, $0, 1           #r15 fine
	ori $t8, $0, 2				 #r24 fine
	#ori $a1, $0, 0x0000			
  

loop0:
	ori $a0, $zero, l      # move lock to arguement register r4 fine
	jal lock                # try to aquire the lock	
	#jal crc32
	#or $v1, $0, $v0           #pushes crc val on the stack // change reg
	ori $v1, $0, 3
	jal push_process
	ori   $a0, $zero, l      # move lock to arguement register r4 fine
  jal   unlock              # release the lock
	addi $t7, $t7, 1					#r15 = r15 + 1
	bne $t7, $t8, loop0				#r15 == r24 ? 0:1

	pop $ra
	jr $ra

push_process:
	lw $t6, mystack($0)
	#beq $t6, $0, pop_process
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
	ori 	$t5, $0, mystack
  jal   mainp1              # go to program
  halt
mainp1:
	push $ra
	
	ori $t7, $0, 1 
	ori $t8, $0, 2
	#ori $t9, $0, -1 #initial min val
	#ori $t1, $0, 0 #initial max val
  #ori $t2, $0, 0 #initial sum 
	
	

loop1:
	ori $a0, $zero, l      # move lock to arguement register
	jal lock                # try to aquire the lock
	jal pop_process
	or $a2, $0, $v1        #a- thing being poped off
	#or $a3, $0, $t9				#b- current min
	#jal min
	#or $t9, $0, $v0       #update min
	#or $a3, $0, $t1			#b- current max
	#jal max
	#or $t1, $0, $v0       #update max
	#add $t2, $t2, $v1 			#update sum
	ori $a0, $zero, l      # move lock to arguement register
  jal unlock              # release the lock
	addi $t7, $t7, 1
	bne $t7, $t8, loop1
	
	#ori $a0, $zero, l      # move lock to arguement register
	#jal lock                # try to aquire the lock
	#ori $t3, $0, 8
	#srlv $t4, $t3, $t2
	#ori $a0, $zero, l      # move lock to arguement register
  #jal unlock              # release the lock
	pop $ra
	jr $ra

#--------------------------------------------------
#push pop process for shared stack
#--------------------------------------------------


pop_process: 
	lw $t6, mystack($0)
	#beq $t6, $t5, pop_process 
	lw $v1, 4($t6)
	sw $zero, mystack($0)
	addi $t6, $t6, 4
	#sw $t6, mystack($0)

	#lw $t6, mystack($0)
	#lw $13, 4($t6)

	#addi $t6, $t6, 4
	#sw $t6, mystack($0)
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
cfw 40
