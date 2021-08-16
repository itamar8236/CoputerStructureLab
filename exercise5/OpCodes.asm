#Students: Itamar Cohen & Maor Moshe
#ID:	   318558236	& 211390877
#Assembly
#Exercise 5 question 2
.data
msg1: .asciiz "\nEnter hex number: "
msg2: .asciiz "ERROR! op code not valid."
msg3: .asciiz "INPUT =  "
msg4: .asciiz "\nRESULT = "
.align 2
number: .space 10  # The number in ASCII

.text
#Since there was no mention about it in the question, we assume that opcode = 0x74
#and bits 20-24 < 0 cannot be an input!!!
read_again:
	li	$v0,4
	la	$a0,msg1
	syscall		#prints first message
		
	jal	read_hex_number #number save in $v1.
	
	beq $v1, $zero, stop_reading
	
	add $t0, $v1, $zero	#$t0 = $v1 = number.
	srl $t0, $t0, 24 	#$t0 = op code.
	
	li $t1, 0x31	#$t1 - possible op code.
	bne $t0, $t1, not_0x31
	#op code  = 0x31
	li $t1, 0xc3
	or $a2, $v1, $t1 #'1' in bits: 0, 1, 6, 7. $a2 = result
	add $a1, $v1, $zero #$a1 = input number.
	jal print 	#print input and result
	j read_again
not_0x31:
	li $t1, 0x30
	bne $t0, $t1, not_0x30
	#op code  = 0x30
	li $t1, 0xffffff3c
	and  $a2, $v1, $t1 #'0' in bits: 0, 1, 6, 7. $a2 = result
	add $a1, $v1, $zero #$a1 = input number.
	jal print 	#print input and result
	j read_again
not_0x30:
	li $t1, 0x48
	bne $t0, $t1, not_0x48
	#op code  = 0x48
	li $t1, 0xff00
	xor $a2, $v1, $t1 #reverse all bits 8-15. $a2 = result.
	add $a1, $v1, $zero #$a1 = input number.
	jal print 	#print input and result
	j read_again
not_0x48:
	li $t1, 0x74
	bne $t0, $t1, error
	#op code  = 0x74
	add $t1, $v1, $zero #$t1 = number.
	srl $t1, $t1, 20 #shifitng 20 bits to the right.
	li $t2, 0x1f #$t2 mask
	and $t1, $t1, $t2 #$t1 = bits 20-24 = counetr
	add $a2, $v1, $zero #$a2 = input number.
shift_again:
	beq $t1, $zero, stop_shifting 
	sll $a2, $a2, 1 #shift to left. $a2 = result
	addi $t1,$t1, -1 #counter--
	j shift_again
stop_shifting:
	add $a1, $v1, $zero #$a1 = input number.
	jal print 	#print input and result
	j read_again
error:
	li	$v0,4
	la	$a0,msg2
	syscall		#prints error message
	j read_again
	
stop_reading:	
	li	$v0,10
	syscall #exit program
	
# This function reads a number in hex
# A to F must be BIG LETTERS
read_hex_number:
	addi	$sp,$sp,-20	# Save room for 5 registers
	sw	$t0,0($sp)	# Save $t0
	sw	$t1,4($sp)	# Save $t1
	sw	$t2,8($sp)	# Save $t2
	sw	$t3,12($sp)	# Save $t3
	sw	$t4,16($sp)	# Save $t4
	li	$v0,8
	la	$a0,number
	li	$a1,10
	syscall			# Read number as string
	li	$t0,0		# $t0 = The result
	la	$t1,number	# $t1 = pointer to number
next:	lb	$t2,0($t1)	# $t2 = next digit
	li	$t4,10
	beq	$t2,$t4,end	# if $t2 = enter --> finish
	sll	$t0,$t0,4	# $t0 *= 16
	slti	$t3,$t2,0x3a    # check if tav <= '9'
	bne	$t3,$zero,digit
	addi	$t2,$t2,-55	# $t2 = $t2 -'A' + 10	
	j	cont
digit:	addi	$t2,$t2,-48	# $t2 = $t2 - '0'	
cont:	add	$t0,$t0,$t2	# add to sum
	addi	$t1,$t1,1	# increment pointer
	j	next	
end:	addi	$v1,$t0,0
	lw	$t0,0($sp)	# Restore $t0
	lw	$t1,4($sp)	# Restore $t1
	lw	$t2,8($sp)	# Restore $t2
	lw	$t3,12($sp)	# Restore $t3
	lw	$t4,16($sp)	# Restore $t4
	addi	$sp,$sp,20	# Restore $sp
	jr	$ra		# return
	
	
#this function gets the input and the result in $a1 and $a2.
#the function prints the numbers in hex.
print:
	li	$v0,4
	la	$a0,msg3
	syscall		#prints third message

	li	$v0,34
	add	$a0,$a1,$zero
	syscall		#prints input in hex
	
	li	$v0,4
	la	$a0,msg4
	syscall		#prints fourth message

	li	$v0,34
	add	$a0,$a2,$zero
	syscall		#prints result in hex
	
	jr	$ra		# return
