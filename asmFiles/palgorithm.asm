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
#t6 - sw sp pointer
#t7 - counter variable that counts up to 256 to generate 256 crc val

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
	ori $t8, $0, 256				 #r24 fine
	ori $a0, $0, 0xC
	nop
	

loop0:
	jal crc32	
	
wait1:
	lw $t9, mystack($0)
	beq $t9, $0, wait1
	or $v1, $0, $v0           #pushes crc val on the stack // change reg
	
	ori $a0, $zero, l      # move lock to arguement register r4 fine
	jal lock                # try to aquire the lock	
	jal push_process
	ori   $a0, $zero, l      # move lock to arguement register r4 fine
  jal   unlock              # release the lock
	or $a0, $0, $v0
	
	addi $t7, $t7, 1					#r15 = r15 + 1
	bne $t7, $t8, loop0				#r15 == r24 ? 0:1

	pop $ra
	jr $ra
	
	
#----------------------------------------------------------
#subroutine_crc
#----------------------------------------------------------

crc32:
  lui $t1, 0x04C1        #r9
  ori $t1, $t1, 0x1DB7		#r9
  or $t2, $0, $0				#r10
  ori $t3, $0, 32				#r11

l1:
  slt $t4, $t2, $t3			#slt r12, r10, r11 
  beq $t4, $zero, l2  	#r12 == 0? 1:0

  ori $t5, $0, 31				#r13
  srlv $t4, $t5, $a0		#srtv r12, r13, r5
  ori $t5, $0, 1 				
  sllv $a0, $t5, $a0
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
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
	ori 	$t5, $0, 40
	
  jal   mainp1              # go to program
  halt
mainp1:
	push $ra
	
	ori $t7, $0, 1 
	ori $t8, $0, 256
	ori $t9, $0, -1 #initial min val
	ori $t1, $0, 0 #initial max val
  ori $t2, $0, 0 #initial sum 
	
	

loop1:
	
wait2:	
	lw $t6, mystack($0)
	beq $t6, $t5, wait2 
	ori $a0, $zero, l      # move lock to arguement register
	jal lock                # try to aquire the lock
	jal pop_process
	ori $a0, $zero, l      # move lock to arguement register
  jal unlock              # release the lock
	or $a2, $0, $v1        #a- thing being poped off
	or $a3, $0, $t9				#b- current min
	jal min
	or $t9, $0, $v0       #update min
	or $a3, $0, $t1			#b- current max
	jal max
	or $t1, $0, $v0       #update max
	add $t2, $t2, $v1 			#update sum
	
	addi $t7, $t7, 1
	bne $t7, $t8, loop1
	
	
	ori $t3, $0, 8
	srlv $t4, $t3, $t2
	
	
	
	
	pop $ra
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


pop_process: 
	lw $t6, mystack($0)
	
	lw $v1, 4($t6)
	sw $zero, 4($t6)
	addi $t6, $t6, 4
	
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
