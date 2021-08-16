#Students: Itamar Cohen & Maor Moshe
#ID:	   318558236	& 211390877
#Assembly
#Exercise 6
.data
matrixA: .space 1000
matrixB: .space 1000
matrixC: .space 4000
m:	.word 0
n:	.word 0
k:	.word 0
msg1:	.asciiz "Enter number of rows of A: "
msg2:	.asciiz "Enter number of columns of A: "
msg3:	.asciiz "Enter number of rows of B: "
msg4:	.asciiz "Enter number of columns of B: "
msg5:	.asciiz "Enter "
msg6:	.asciiz " numbers for A: "
msg7:	.asciiz " numbers for B: "
msg8:	.asciiz "Matrix A:\n"
msg9:	.asciiz "Matrix B:\n"
msg10:	.asciiz	"Matrix C (AxB):\n"
errormsg: .asciiz "ERROR! columns of A must be equal to rows of B\n"

.text
	# Main
	li	$v0,4
	la	$a0,msg1
	syscall #prints first message
	
	li	$v0,5
	syscall #reads m
	la	$s1,m
	sw	$v0,0($s1)	# save m
	
	li	$v0,4
	la	$a0,msg2
	syscall  #prints second message
	
	li	$v0,5
	syscall #reads n
	la	$s1,n
	sw	$v0,0($s1)	# save n
	
	add $t0, $v0, $zero #$t0 = n
	
read_n_again:	
	li	$v0,4
	la	$a0,msg3
	syscall  #prints third message
	
	li	$v0,5
	syscall #reads n
	beq $v0, $t0, stop_n_reading
	
	li	$v0,4
	la	$a0,errormsg
	syscall  #prints error message
	j read_n_again
stop_n_reading:
	li	$v0,4
	la	$a0,msg4
	syscall  #prints message4
	
	li	$v0,5
	syscall #reads k
	la	$s1,k
	sw	$v0,0($s1)	# save k
	
	la $a0, msg6
	la $a1, m
	la $a2, n
	la $a3, matrixA
	jal	read_matrix #reads matrix A
	
	la $a0, msg7
	la $a1, n
	la $a2, k
	la $a3, matrixB
	jal	read_matrix #reads matrix B
	
	jal mult_matrix
	
	li	$v0,4
	la	$a0,msg8
	syscall  #prints message8
	la $a1, m
	la $a2, n
	la $a3, matrixA
	jal	print_matrix #print matrix A
	
	li	$v0,4
	la	$a0,msg9
	syscall  #prints message9
	la $a1, n
	la $a2, k
	la $a3, matrixB
	jal	print_matrix #print matrix B
	
	li	$v0,4
	la	$a0,msg10
	syscall  #prints message10
	la $a1, m
	la $a2, k
	la $a3, matrixC
	jal	print_matrix #print matrix C
	
	
	li	$v0,10
	syscall 		# Exit
	
#************************************************************************
#this function gets address for m, n, and matrix in: $a1, $a2, $a3.
#the function gets address for A/B input msg in $a0.	
read_matrix:	
	#saving registers
	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $v0, 12($sp)

	add $t2, $a0, $zero #save affress in $a0 in $t2.
	
	li	$v0,4
	la	$a0,msg5
	syscall  #prints "enter"
	
	
	lw	$t0,0($a1) #t0 = rows(m)
	lw	$t1,0($a2) #$t1 = columns (n)
	mult	$t0,$t1
	mflo	$t0		# $t0 = number of elements in matrix
	li	$v0,1
	add	$a0,$t0,$zero
	syscall #prints $t0
	li	$v0,4
	add $a0, $t2, $zero #return to $a0 the original value
	syscall #prints A/B
	
	add	$t1, $a3, $zero	#$t1 = pointer to matrix
read:	li	$v0,5
	syscall
	sw	$v0,0($t1)
	addi	$t1,$t1,4
	addi	$t0,$t0,-1
	beq	$t0,$zero,end_read
	j	read
end_read:
	#restore registers
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $v0, 12($sp)
	addi $sp, $sp, 16
	jr	$ra		# return
#************************************************************************
#this function gets address for m, n, and matrix in: $a1, $a2, $a3.
print_matrix:
	#saving registers
	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $v0, 12($sp)

	lw	$t0,0($a1)	# $t0 = m
	lw	$t1,0($a2)	# $t1 = n
	add	$t2,$a3, $zero	# $t2 = address of matrix
print:  lw	$a0,0($t2)
	li	$v0,1
	syscall 
	li	$v0,11
	li	$a0,9		# 9 is TAB
	syscall
	addi	$t2,$t2,4
	addi	$t1,$t1,-1
	bne	$t1,$zero,print
	
	lw	$t1,0($a2)	# $t1 = n again
	li	$v0,11
	li	$a0,'\n'
	syscall
	addi	$t0,$t0,-1
	bne	$t0,$zero,print
	
	#restore registers
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $v0, 12($sp)
	addi $sp, $sp, 16
	jr	$ra		# return
#************************************************************************	
mult_matrix: #c = AxB
	#saving registers
	addi $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $t6, 24($sp)
	sw $v1, 28($sp)
	


	la $t1, matrixA #$t1 points to matA
	la $t2, matrixB #$t2 points to matB
	la $t3, matrixC #$t3 points to matC
	
	li $t5, 1#$t5 index to what row we are.
next_row:
	li $t6, 1 #$t6 index to what col we are.

next_col:	
	add $t7, $zero, $zero #$t7 = 0 = sum
	
	la $t0, n
	lw $t0, 0($t0) #$t0 = n, as counter.
add_sum:	
	lw $t4, 0($t1)
	lw $v1, 0($t2)
	mult $t4, $v1
	mflo $t4
	add $t7, $t7, $t4 #sum += $t4 * $v1
	
	la $t4, k
	lw $t4, 0($t4)
	sll $t4, $t4, 2 #$t4 = 4*k (the distance between 2 numbers is the same column in matB)
	add $t2, $t2, $t4
	
	addi $t1, $t1, 4
	
	addi $t0, $t0, -1
	bne $t0, $zero, add_sum
	
	sw $t7, 0($t3) #store sum in mat C
	addi $t3, $t3, 4 #pointer to matC++
	
	la $t4, k
	lw $t4, 0($t4)
	beq $t4, $t6, increae_row

	la $t1, matrixA
	add $t4, $t5, $zero #calculate what row we are
	addi $t4, $t4, -1
	la $v1, n
	lw $v1, 0($v1)
	sll $v1, $v1, 2
	mult $v1, $t4
	mflo $t4 #$t4 = 4*n*(how many rows to add)
	add $t1, $t1, $t4
	
	la $t2, matrixB
	add $t4, $t6, $zero
	sll $t4, $t4, 2 #$t4 = cur col *4 
	add $t2, $t2, $t4 #$t2 points to next col
	addi $t6, $t6, 1
	j next_col	
	
increae_row:
	la $t4, m
	lw $t4, 0($t4)
	beq $t4, $t5, finish_calc

	la $t2, matrixB
	la $t1, matrixA
	la $t4, n
	lw $t4, 0($t4)
	sll $t4, $t4, 2
	mult $t4, $t5
	mflo $t4 #$t4 = n*4*cur row
	add $t1, $t1, $t4 #$t1 points to next row
	addi $t5, $t5, 1
	j next_row
	
finish_calc:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	lw $t5, 20($sp)
	lw $t6, 24($sp)
	lw $v1, 28($sp)
	addi $sp, $sp, 32
	jr	$ra		# return