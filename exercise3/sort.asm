#Students: Itamar Cohen & Maor Moshe
#ID:	   318558236	& 211390877
#Assembly
#Exercise 3 Project 1
.data
arr:	.word	23,56,87,-87,123,0,-66,444,-2,100
size:	.word	10
msg1:	.asciiz "The sorted array is: "
msg2: 	.asciiz " "

.text
	la 	$t1,size	
	lw 	$t1,0($t1)	#$t1=size of the array
Outerloop: 
	addi	$t1,$t1,-1	#t1=size--
	beq	$t1,$zero,print	#if size=0 go to print
	li	$t2,0		#$t2 pass on the array from 0 to $t1
	la	$t0,arr		#$t0 pointer to arr
	
Internalloop:	
	slt	$t5,$t2,$t1	#if $t2<$t1 then $t5=1
	beq 	$t5,$zero,Outerloop #if $t5=0 go to outerloop
	addi	$t2,$t2,1	#$t2++
	lw	$t3,0($t0)	#$t3= number in the array
	lw	$t4,4($t0)	#$t4=The subsequent number
	slt	$t5,$t4,$t3	#if $t4<$3 then $t5=1
	bne	$t5,$zero,swap	#if $t5=0 we need to swap $t3 and $t4
	addi	$t0,$t0,4	#$t0 pointer to the next number in the array
	j	Internalloop

swap:	
	sw	$t4,0($t0)
	sw	$t3,4($t0)	#swap
	addi	$t0,$t0,4	#$t0 pointer to the next number in the array
	j	Internalloop
	
print:
	li $v0,4
	la $a0,msg1		#print msg1
	syscall
	
	la 	$t1,size	
	lw 	$t1,0($t1)	#$t1=size of the array
	la	$t0,arr		#$t0 pointer to arr
	
loop:	
	beq 	$t1,$zero,finish #if $t1=0 finish
	addi	$t1,$t1,-1	#$t1--
	lw 	$t2,0($t0)	#$t2=number in the array by order
	li 	$v0,1
	add 	$a0,$t2,$zero	#print the number
	syscall
	li $v0,4
	la $a0,msg2		#print space
	syscall
	addi	$t0,$t0,4	#$t0 pointer to the next number in the array
	j	loop
	
finish:	li 	$v0,10
	syscall








