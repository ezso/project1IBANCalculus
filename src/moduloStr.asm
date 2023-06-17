	.data
	.globl modulo_str
	.text

# --- modulo_str ---
# Arguments:
# a0: start address of the buffer
# a1: number of bytes in the buffer
# a2: divisor
# Return:
# v0: the decimal number (encoded using ASCII digits '0' to '9') in the buffer [$a0 to $a0 + $a1 - 1] modulo $a2 
modulo_str:
	# TODO
	move	$t0	$zero		# initiate the result variable $t0 with the value 0
	li	$t1	10		# initiate $t1 with 10 as multiplier
	
loop_mod:				# beginning of the loop
	lb	$t2	($a0)		# load char into $t2
	addiu	$t2	$t2	-48	# convert the char to int
	addiu	$a0	$a0	1	# array = array + 1
	addiu	$a1	$a1	-1	# length = length - 1
	mul	$t0	$t0	$t1	# result = result * 10
	addu	$t0	$t0	$t2	# result = result + digit
	rem	$t0	$t0	$a2	# result = result modulo divisor
	bgtz	$a1	loop_mod	# repeat if length > 0
	
	move	$v0	$t0
	
	jr	$ra
