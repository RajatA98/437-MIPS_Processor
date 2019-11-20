org 0x000

lw $t6, mystack($0)
halt

org 0xF000
mystack:
cfw 40
