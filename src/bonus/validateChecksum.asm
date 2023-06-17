	.data
	.globl validate_checksum
	.text


# -- validate_checksum --
# Arguments:
# a0 : Address of a string containing a german IBAN (22 characters)
# Return:
# v0 : the checksum of the IBAN
validate_checksum:
	# TODO
	lb	$t0	0($a0)		# read the 1st char from buffer
	addiu	$t0	$t0	-55	# convert to int + 10
	lb	$t1	1($a0)		# read the 2nd char from buffer 
	addiu	$t1	$t1	-55	# convert to int + 10
	li	$t2	100		# $t2 = 100
	mul	$t0	$t0	$t2	# $t0 = $t0 * 100
	addu	$t0	$t0	$t1	# $t0 = $t0 + $t1
	
	lb	$t1	2($a0)		# read the 3rd char from buffer 
	addiu	$t1	$t1	-48	# convert char to int
	lb	$t2	3($a0)		# read the 4th char from buffer
	addiu	$t2	$t2	-48	# convert char to int
	li	$t3	10		# $t3 = 10
	mulu	$t1	$t1	$t3	# $t1 = $t1 * 10
	addu	$t1	$t1	$t2	# $t1 = $t1 + $t2
	mul	$t0	$t0	$t3	# $t0 = $t0 * 10
	mul	$t0	$t0	$t3	# $t0 = $t0 * 10
	addu	$t0	$t0	$t1	# $t0 = $t0 + $t1
	
	addiu	$sp	$sp	-12	# shift the stack pointer
	sw	$ra	0($sp)		# store the return address
	sw	$a0	4($sp)		# store the buffer address
	sw	$t0	8($sp)		# store the converting result of the first 4 bytes
	addiu	$a0	$a0	4	# jump over the country code
	li	$a1	18		# number of remaining bytes
	li	$a2	97		# $a2 = divisor
	jal	modulo_str		# count the reminder of the rest from the buffer
	lw	$t0	8($sp)		# recover the previous result
	li	$t3	1000000		# $t3 = 1 000 000
	mul	$t1	$v0	$t3	# $t1 = result of modulo_str * 1000000
	rem	$t1	$t1	$a2	# $t1 = $t1 % 97
	addu	$t0	$t0	$t1	# $t0 = $t0 + $t1
	rem	$v0	$t0	$a2	# $v0 = $t0 % 97
	
	lw	$a0	4($sp)		# recover the original buffer address
	lw	$ra	0($sp)		# recover the return address
	addiu	$sp	$sp	12	# shift	the stack pointer back
	jr	$ra







