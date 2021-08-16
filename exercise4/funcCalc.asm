#Students: Itamar Cohen & Maor Moshe
#ID:	   318558236	& 211390877
#Assembly
#Exercise 4 
#there was no mention about it in the question or lectures, so we assume that input for divition by 0 is not possible.
.data 
msg1: .asciiz "Enter first number: "
msg2: .asciiz "Enter operation: "
msg3: .asciiz "\nEnter second number: "
msg4: .asciiz "The result is: "
msg5: .asciiz "Invalid operation"
.text

	li $t0, '+' #saving valid operations.
	li $t1, '-'
	li $t2, '*'
	li $t3, '/'
	li $t4, '^'
	
	li $v0, 4     
	la $a0, msg1
	syscall	#prints first message 
	
	li $v0, 5
	syscall #reading first number
	add $t6, $v0, $zero #$t6 = first numer
	
	li $v0, 4     
	la $a0, msg2
	syscall	#prints second message 
	
	li $v0, 12
	syscall#reading operation
	add $t5, $v0, $zero #$t5 = operation
	
	li $v0, 4     
	la $a0, msg3
	syscall	#prints third message 
	
	li $v0, 5
	syscall #reading second number
	add $t7, $v0, $zero #$t7 = second numer

	add $a0, $t6, $zero #$a0 = first number
	add $a1, $t7, $zero #$a1 = second number
	
	bne $t5, $t0, not_adding	#calling the right functions for the operation
	jal adding 			#add op
	j printResult
not_adding:
	bne $t5, $t1, not_substraction
	jal  substraction		#sub op
	j printResult
not_substraction:
	bne $t5, $t2, not_multiplication
	jal multiplication		#mult op
	j printResult
not_multiplication:
	bne $t5, $t3, not_difference
	jal difference			#div op
	j printResult
not_difference:
	bne $t5, $t4, error
	jal power			#power op
	j printResult
error:
	li $v0, 4     
	la $a0, msg5
	syscall	#prints error message 
	j end
	
printResult:
	add $t0, $v0, $zero	#saving result
	
	li $v0, 4     
	la $a0, msg4
	syscall	#prints fourth message 
	
	add $a0, $t0, $zero #$a0 = result
	li $v0, 1
	syscall
end:
	li $v0, 10 #exit program
	syscall
#*********************************functions area*********************************
#all functions gets 2 numbers in $a0-1, and return result in $v0

adding: #this function return $a0 + $a1
	add $v0, $a0, $a1
	jr $ra
#*********************************************************************************
substraction: #this function return $a0 - $a1
	sub $v0, $a0, $a1
	jr $ra
#*********************************************************************************	
multiplication: #this function return $a0 * $a1
	#saving registers
	addi $sp, $sp, -24
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $ra, 16($sp)
	sw $a1, 20($sp)

	add $t3, $a1, $zero #$t3 saving $a1
	li $t2, 0 #$t2 = 0 = result
	li $t1, 0 #$t1 checking for negative/positive.
	
	slt $t0, $t3, $zero	#checking if second number smaller then 0
	beq $t0, $zero, addAgain#if positive
	nor $t3, $t3, $t3 
	addi $t3,$t3, 1	#$t3 = -$t3
	
	li $t1, 1 	#$t1 = 1 means second number is negative
addAgain:
	beq $t3, $zero, stopAdding
	add $a1, $t2, $zero 	#setting parameter
	jal adding #$v0 = $a0 + result
	add $t2, $v0, $zero #t2 = result
	addi $t3,$t3, -1
	j addAgain
stopAdding:	
	add $v0, $t2, $zero #$v0 = result
	#checking result sign
	slt $t0, $v0, $zero
	bne $t0, $zero, negative
	#if here, result is positive
	beq $t1, $zero, end_fun #2 positive numbers
	#if here result is negative
	nor $v0, $v0, $v0
	addi $v0,$v0, 1	#$v0 = -$v0
	j end_fun
negative:
	beq $t1, $zero, end_fun #result should be negative
	#if here, result should be positive
	nor $v0, $v0, $v0
	addi $v0,$v0, 1	#$v0 = -$v0
end_fun:
#restoring registers
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $ra, 16($sp)
	lw $a1, 20($sp)
	addi $sp, $sp, 24

	jr $ra
#*********************************************************************************	
difference: #this function return $a0 / $a1
#saving registers
	addi $sp, $sp, -24
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $ra, 16($sp)
	sw $a0, 20($sp)
	
	li $t1, 0 #$t1 checking for negative result
	#checking for result sign.
	slt $t0, $a0, $zero
	beq $t0, $zero, firstPositive
	nor $a0, $a0, $a0 #first is negative
	addi $a0,$a0, 1	#$a0 = -$a0
	slt $t0, $a1, $zero
	bne $t0, $zero, twoNegative
	li $t1, 1 #first negative second positive
	j startCalc
twoNegative:
	nor $a1, $a1, $a1
	addi $a1,$a1, 1	#$a1 = -$a1
	j startCalc
firstPositive:
	slt $t0, $a1, $zero
	beq $t0, $zero, startCalc #two positives
	li $t1, 1 #first positive second negative
	nor $a1, $a1, $a1
	addi $a1,$a1, 1	#$a1 = -$a1
startCalc:
	li $t0, 0 #$t0 = 0 = result.
subAgain:	
	slt $v0, $a0, $a1 #checking if mone < mechane
	bne $v0, $zero, stopCalc
	jal substraction
	add $a0, $v0, $zero #mone = mone - mechane
	addi $t0, $t0, 1 #result += 1
	j subAgain
stopCalc:
	add $v0, $t0, $zero #$v0 = result
	beq $t1, $zero, endDivFunc
	nor $v0, $v0, $v0
	addi $v0,$v0, 1	#$v0 = -$v0
endDivFunc:
#restoring registers:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $ra, 16($sp)
	lw $a0, 20($sp)
	addi $sp, $sp, 24
	
	jr $ra
#*********************************************************************************
power: #this function return $a0 ^ $a1
#saving registers:
	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $ra, 8($sp)
	sw $a1, 12($sp)
	
	li $t0, 1 #$t0 = result
	add $t1, $a1, $zero #$t1 saving the power
multagain:
	beq $t1, $zero, stopMult
	add $a1, $t0, $zero #setting parameter
	jal multiplication
	add $t0, $v0, $zero #$t0 = result
	addi $t1, $t1, -1
	j multagain
stopMult:
	add $v0, $t0, $zero #$v0 = result
#restore registers
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $ra, 8($sp)
	lw $a1, 12($sp)
	addi $sp, $sp, 16
	jr $ra
#*********************************************************************************