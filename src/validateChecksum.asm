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
	lb	$t0	0($a0)		# copy the first char into $t0
	addiu	$t0	$t0	-55	# convert to int + 10
	
	addiu	$sp	$sp	-8	# shift the stack pointer
	sw	$ra	0($sp)		# save the return address
	sw	$a0	4($sp)		# save the buffer address
	
	li	$a2	2		# length of integer to be converted
	addiu	$a1	$a0	22	# $a1 = buffer address to write new chars
	move	$a0	$t0		# $a0 = integer
	jal	int_to_buf		# call of the function to convert and write
	
	lw	$a0	4($sp)		# recover the address of the buffer
	addiu	$a1	$a0	24	# $a1 = buffer address to write new chars
	lb	$t0	1($a0)		# copy the second char into $t0
	addiu	$t0	$t0	-55	# convert to int + 10
	move	$a0	$t0		# $a0 = integer
	jal	int_to_buf		# call of the function to convert and write
	
	lw	$a0	4($sp)		# recover the address of the buffer
	lw	$ra	0($sp)		# recover the return address
	addiu	$sp	$sp	8	# shift the stack pointer
	
	lb	$t0	2($a0)		# copy the third char into $t0
	sb	$t0	26($a0)		# write the third char at the end
	lb	$t0	3($a0)		# copy the fourth char into $t0
	sb	$t0	27($a0)		# write the fourth char at the end
	
	addiu	$a0	$a0	4	# jump over "country code"
	li	$a1	24		# $a1 = length of the number
	li	$a2	97		# $a2 = divisor
	
	addiu	$sp	$sp	-4	# shift the stack pointer
	sw	$ra	0($sp)		# save the return address
	jal	modulo_str		# calling the function to calculate the reminder
	lw	$ra	0($sp)		# recover the return address
	addiu	$sp	$sp	4	# shift the stack pointer back
	
	jr	$ra
