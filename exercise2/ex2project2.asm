#Students: Itamar Cohen & Maor Moshe
#ID:	   318558236	& 211390877
#Assembly
#Exercise 2 Project 2
.data 
msg1: .asciiz "\nENTER  VALUE: "
msg2: .asciiz "ENTER OP CODE: "
msg3: .asciiz "\nthe result is : "
msg4: .asciiz "\nERROR"
.text

	li $t0, '+'
	li $t1, '-'
	li $t2, '*'
	li $t3, '@'
	
	li $v0, 4     
	la $a0, msg1
	syscall	#prints first message 
	
	li $v0, 5
	syscall #reading first number
	
	add $t7, $v0, $zero #$t7 = first numer = result
	
continue:
	li $v0, 4     
	la $a0, msg2
	syscall	#prints second message 

	li $v0, 12
	syscall#reading op code
	add $t4, $v0, $zero #$t4 = op code
	
	beq $t4, $t3, end
	
	li $v0, 4     
	la $a0, msg1
	syscall	#prints first message 
	
	li $v0, 5
	syscall #reading another number
	add $t5, $v0, $zero #$t5 = another number
	
	bne $t4, $t0, not_plus
	add $t7, $t7, $t5   #$t7 += $t5,meaning: result += number
	j continue
not_plus:	
	
	bne $t4, $t1, not_minus
	sub $t7, $t7, $t5 #$t7 -= $t5,meaning: result -= number
	j continue
not_minus:
#must be mult here.
	mult $t7, $t5
#checking for errors:
	mfhi $t6 #$t6 = high
	beq $t6, 0, highIsZero
	bne $t6, -1, error
	mflo $t6 #high = -1
	slt $t6, $t6, $zero
	bne $t6, $zero, noError#lo < 0
	j error
highIsZero:
	mflo $t6
	slt $t6, $t6, $zero
	bne $t6, $zero, error#lo < 0
noError:
	mflo $t7 #$t7 = mult.
	j continue
end:
	li $v0, 4     
	la $a0, msg3
	syscall	#prints third message 
	
	li $v0, 1
	add $a0, $t7, $zero
	syscall#printing result
	j endProject
	
error: 
	li $v0, 4     
	la $a0, msg4
	syscall	#prints error message 
endProject: nop
	
	
	
	
	
	
	
	
	