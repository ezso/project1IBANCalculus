	.data
	.globl knr2iban
	.text
# -- knr2iban
# Arguments:
# a0: IBAN buffer (22 bytes)
# a1: BLZ buffer (8 bytes)
# a2: KNR buffer (10 bytes)
knr2iban:
	# TODO
	li	$t0	68		# load the letter D into $t0
	sb	$t0	0($a0)		# save the letter D in the first byte of IBAN buffer
	li	$t0	69		# load the letter E into $t0
	sb	$t0	1($a0)		# save the letter E in the second byte of IBAN buffer
	li	$t0	48		# load the number 0 into $t0
	sb	$t0	2($a0)		# save the number 0 in the third byte of IBAN buffer
	sb	$t0	3($a0)		# save the number 0 in the fourth byte of IBAN buffer
	
	addiu	$sp	$sp	-16	# shift the stack pointer
	sw	$ra	0($sp)		# save the return address
	sw	$a0	4($sp)		# save the first byte's address of IBAN
	sw	$a1	8($sp)		# save the BLZ buffer address
	sw	$a2	12($sp)		# save the KNR buffer address
	addiu	$a0	$a0	4	# jump over "country code" part
	li	$a2	8		# $a2 = number of chars to be copied
	jal	memcpy			# copies the BLZ into IBAN buffer (startnig from 5th byte)
	
	addiu	$a0	$a0	8	# jump over "BLZ" part
	lw	$a1	12($sp)		# recover the KNR's buffer address in $a1
	li	$a2	10		# $a2 = number of chars to be copied
	jal	memcpy			# copies the KNR into IBAN buffer (startnig from 13th byte)
	
	lw	$a0	4($sp)		# recover the IBAN's first byte address in $a0
	jal	validate_checksum	# validate and give the reminder back
	move	$t0	$v0		# move the reminder of validation into the $t0
	li	$t1	98		# $t1 = 98
	subu	$t0	$t1	$t0	# $t0 = $t1 - $t0
	lw	$a0	4($sp)		# recover the IBAN's first byte address in $a0
	addiu	$a1	$a0	2	# $a1 = the address of the 3rd byte of the IBAN buffer
	li	$a2	2		# $a2 = length of the int (2)
	bgt	$t0	9	two_digit_number
	move	$a0	$zero		# $a0 = 0
	addiu	$a2	$a2	-1	# $a2 = length of the int (1)
	jal	int_to_buf
	addiu	$a1	$a1	1	# point to the fourth byte of the IBAN buffer
two_digit_number:
	move	$a0	$t0
	jal	int_to_buf
	
	lw	$a2	12($sp)
	lw	$a1	8($sp)
	lw	$a0	4($sp)
	lw	$ra	0($sp)
	addiu	$sp	$sp	16
	jr	$ra









