#Students: Itamar Cohen & Maor Moshe
#ID:	   318558236	& 211390877
#Assembly
#Exercise 5 question 1
.data
block: .align 0
       .space 32
code:  .align 0
       .space 6
msg1: .asciiz "Enter block of digits (0-9) and -1 to finish: "
msg2: .asciiz "Enter basic code: "
msg3: .asciiz "\nThe code "
msg4: .asciiz " exists in the block"
msg5: .asciiz " does not exists in the block"
.text
#reading block:
	li $v0, 4
	la $a0, msg1
	syscall #prints first message
	
	la $t1, block #$t1 points to block array
	add $t7, $zero, $zero #$t7 = 0 = size of block.
read_block_again:
	li $v0, 5
	syscall #reading number.
	
	li $t0, -1
	beq $v0, $t0, stop_block_reading
	
	sb $v0, 0($t1) 
	addi $t1,$t1, 1 #pointer++
	addi $t7, $t7, 1 #size++
	j read_block_again
stop_block_reading:
#reading code:
	li $v0, 4
	la $a0, msg2
	syscall #prints first message
	
	la $t1, code #$t1 points to code array.
	li $t0, 0 #$t0 = counter to 6.
read_code_again:
	li $t6, 6
	beq $t0, $t6, stop_code_reading
	
	li $v0, 5
	syscall 
	sb $v0, 0($t1) 
	addi $t1,$t1, 1 #pointer++
	addi $t0,$t0, 1 #couter++
	j read_code_again
stop_code_reading:
#prints
	li $v0, 4
	la $a0, msg3
	syscall #prints third message
	
	la $t1, code #$t1 points to code array.
	li $t0, 0 #$t0 = counter to 6.
print_code_again:
	li $t6, 6
	beq $t0, $t6, stop_code_printing
	
	
	lb $a0, 0($t1) 
	li $v0, 1
	syscall #prints number from code
	
	addi $t1,$t1, 1 #pointer++
	addi $t0,$t0, 1 #couter++
	j print_code_again
stop_code_printing:

#checking if code exsits in block.
	la $t0, block #$t0 points to block
	la $t1, code #$t1 points to code
	add $t2, $zero, $zero #$t2 = 0 = counetr of matching digits.
	addi $t7, $t7, -5 #size of block -= 5, need to check up to block size - code size.
out_loop:	
	slt $v0, $zero, $t7
	beq $v0, $zero, not_exsits #if $t7 <= 0
	la $t1, code #$t1 points to code array
	add $t2, $zero, $zero #$t2 = 0 = counetr of matching digits.
	add $t5, $t0, $zero #$t5 = $t0 = pointer to block
inner_loop:
	li $t6, 6
	beq $t2, $t6, exsits #if 6 matching digits
	lb $t3, 0($t5) #$t3 = number from block
	lb $t4, 0($t1) #$t4 = number from code
	bne $t3,$t4 end_inner_loop
	addi $t2, $t2, 1 #matching numbers++
	addi $t1, $t1, 1 #pointer to code++
	addi $t5, $t5, 1 #pointer to block++
	j inner_loop
end_inner_loop:
	addi $t0, $t0, 1 #pointer to block++
	addi $t7, $t7, -1 #size of block--
	j out_loop

exsits:
	li $v0, 4
	la $a0, msg4
	syscall #prints exsists message
	j end
not_exsits:
	li $v0, 4
	la $a0, msg5
	syscall #prints not exsists message
end:
	nop
	
	
	