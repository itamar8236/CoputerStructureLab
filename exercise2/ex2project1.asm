#Students: Itamar Cohen & Maor Moshe
#ID:	   318558236	& 211390877
#Assembly
#Exercise 2 Project 1
.data 
arr: .byte 100,-124,90,98,34,77,125
size: .word 7
msg1: .asciiz "Maximum =  "
msg2: .asciiz "\nMinimum = "
.text
#assigm registers
	la $t7, arr 		#$t7 pointer to arr
	la $t2, size
	lw $t2, 0($t2) 		#$t2 = size of arr
#reading first number in arr	
	lb $t0, 0($t7)		 #read first number to  $t0.  $t0 = max
	add $t1, $t0, $zero	 #$t1 = $t0 = first number.  $t1 = min
	addi $t7, $t7, 1 	 #$t7++
	addi $t2, $t2, -1 	 #$t2--
#reading all numbers in arr	
next:	beq $t2,$zero, finish
        lb $t3, 0($t7) 		 #read next number to  $t3
	addi $t7, $t7, 1 	 #$t7++
	addi $t2, $t2, -1 	 #$t2--
#finding max and min
	slt $t4, $t3, $t0 	 #checking if current > max
	bne $t4, $zero, smallerThenMax
	add $t0, $t3, $zero  	 #$t0 = $t3 = max
smallerThenMax:
        slt $t4, $t1, $t3	 #checking if current < min
	bne $t4, $zero, biggerThenMin
	add $t1, $t3, $zero  	 #$t1 = $t3 = min
biggerThenMin:
	j next
finish:
#printing max and min
	li $v0, 4     
	la $a0, msg1
	syscall	#prints first message 

	li $v0, 1
	add $a0, $t0, $zero
	syscall #prints max
	
	li $v0, 4     
	la $a0, msg2
	syscall	#prints second message 

	li $v0, 1
	add $a0, $t1, $zero
	syscall #prints max
