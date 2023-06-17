	.data
	.globl iban2knr
	.text
# -- iban2knr
# Arguments:
# a0: IBAN buffer (22 bytes)
# a1: BLZ buffer (8 bytes)
# a2: KNR buffer (10 bytes)
iban2knr:
	# TODO
	addiu	$sp	$sp	-16	# shift the stack pointer
	sw	$ra	0($sp)		# save the $ra value
	sw	$a0	4($sp)		# save the IBAN's buffer address
	sw	$a1	8($sp)		# save the target address for BLZ
	sw	$a2	12($sp)		# save the target address for KNR
	
	addiu	$a0	$a0	4	# jump over "country code" part
	move	$t0	$a0		# temorary save the new IBAN's buffer address in $t0
	move	$a0	$a1		# move the BLZ buffer address into $a0
	move	$a1	$t0		# move the new IBAN's buffer address into $a1
	li	$a2	8		# load the number of characters to be copied into $a2
	jal	memcpy			# copy 8 characters from $a1 to $a0
	
	addiu	$a1	$a1	8	# jump over "BLZ" part
	lw	$a0	12($sp)		# copy the KNR's buffer address into $a0
	li	$a2	10		# load the number of characters to be copied into $a2
	jal	memcpy			# copy 8 characters from $a1 to $a0
	
	move	$a2	$a0		# copy the KNR's buffer address into $a2
	lw	$a1	8($sp)		# copy the BLZ's buffer address into $a1
	lw	$a0	4($sp)		# copy the original IBAN's buffer address into $a0
	lw	$ra	0($sp)		# recover the $ra value
	addiu	$sp	$sp	16	# shift the stackpointer back
	
	jr	$ra


















