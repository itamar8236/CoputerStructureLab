#Students: Itamar Cohen & Maor Moshe
#ID:	   318558236	& 211390877
#Assembly
#Exercise 3 Project 2
.data
array: .word	-1, 2, -4, 8, -16, 32, -64, -128
size: .word 	8
msg1: .asciiz "\nEngineering Series\n"
msg2: .asciiz "Invoice Series\n"
msg3: .asciiz "first number: "
msg4: .asciiz " d = "
msg5: .asciiz " q = "
msg6: .asciiz "No Series"
.text
#assuming that size > 1 for check of series.
	la $t0, size 	#$t0 points to size.
	lw $t7, 0($t0)	#$t7 = size of array.
	la $t0, array 	#$t0 points to array.
	
	
	li $t1, 1 	 #$t1 = 1 if series is invoice, and = 0 if not.
	li $t2, 1	#$t2 = 1 if series is Engineering, and = 0 if not.
	
	lw $t5, 0($t0)	#$t5 = arr[0]
	lw $t6, 4($t0)	#$t6 = arr[1]
	
	sub $t3, $t6, $t5	#$t3 = d
	div $t6, $t5		#calculating q
	mfhi $v0	#$v0 = remainfer
	beq $v0, $zero, QisInt	#checking if q is integer
	li $t2, 0		#if not, series is not Engineering
QisInt:
	mflo $t4	#$t4 = q	
	
	addi $t7, $t7, -1	#size--,  i did one "check"
	addi $t0,$t0,  8	#$t0 += 8, points to arr[2]
	add $t5, $t6, $zero	#$t5 = arr[1]
checkAgain:
	li $v1, 1
	beq $t7, $v1, finish	#checking until size-1 because checking 2 elements every check
	lw $t6, 0($t0)	#$t6 = next number.
	
	sub $v1, $t6, $t5 	#$v1 = cur d
	beq $v1, $t3, continue	#checking d
	li $t1, 0	#series is not invoice
continue:
	div $t6, $t5		#calculating q
	add $t5, $t6, $zero #$t5 = $t6
	addi $t7, $t7, -1	#size--
	addi $t0, $t0,  4	#$t0++
	
	mfhi $v0	#$v0 = remainfer
	beq $v0, $zero, checkQ 	#checking if q is integer
	li $t2, 0	#if not, series is not Engineering
checkQ:
	mflo $v1
	beq $v1, $t4, checkAgain
	li $t2, 0 #$v1!=$t4,not enfgeneering
	j checkAgain
	
	
finish:
	li $v1, 1
	beq $t1, $v1, print	#checking series
	beq $t2, $v1, print
	
	li $v0, 4     
	la $a0, msg6
	syscall	#prints "no series"
	j end
print:
	beq $t1, $zero, notInvoice
	
	li $v0, 4     
	la $a0, msg2
	syscall	#prints invoice message 
	
	li $v0, 4     
	la $a0, msg3
	syscall	#prints "first number: "
	la $t0, array
	lw $a0, 0($t0)
	li $v0, 1
	syscall #prints first number
	
	li $v0, 4     
	la $a0, msg4
	syscall	#prints "d = "
	add $a0, $t3, $zero #$a0 = d
	li $v0, 1
	syscall #prints d
notInvoice:
	beq $t2, $zero, end#if no engeneering series
	li $v0, 4     
	la $a0, msg1
	syscall	#prints Engineering message 
	
	li $v0, 4     
	la $a0, msg3
	syscall	#prints "first number: "
	la $t0, array
	lw $a0, 0($t0)
	li $v0, 1
	syscall #prints first number
	
	li $v0, 4     
	la $a0, msg5
	syscall	#prints "d = "
	add $a0, $t4, $zero #$a0 = q
	li $v0, 1
	syscall #prints q
	
end: nop
	
