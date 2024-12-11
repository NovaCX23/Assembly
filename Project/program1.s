.data
	v: .space 1024
	nrFis: .space 4
	nrOp: .space 4
	tipOp: .space 4
	ctSLibere: .space 4
	descriptor: .space 4
	dimensiune: .space 4
    idInceput: .space 4
	idFinal: .space 4
	j: .space 4
	d: .space 4
	Input: .asciz "%d"
    Output_add: .asciz "%d:  (%d,%d)\n"
    Output_get: .asciz "(%d,%d)\n"
    Output_zero: .asciz "%d:  (0,0)\n"

.text

.global main
main:
	lea v, %edi
    pushl $nrOp
	pushl $Input
	call scanf
	popl %ebx
	popl %ebx

	movl nrOp, %ecx

    #  For principal citire 
et_loopPrincipal:
	pushl %ecx
	pushl $tipOp
    pushl $Input
    call scanf
    popl %ebx
    popl %ebx
    
    # Cazuri  
	movl tipOp, %eax
	cmp $1, %eax
	je ADD
	cmp $2, %eax
	je GET
	cmp $3, %eax
	je DELETE
	cmp $4, %eax
	je DEFRAGMENTATION	
	
et_loopPrincipalNext:
    popl %ecx
	loop et_loopPrincipal
	
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80


ADD:
    # Read number of files (nrFis)
    pushl $nrFis
    pushl $Input
    call scanf
    addl $8, %esp  # Adjust stack after scanf

    movl nrFis, %ecx  # Outer loop counter (number of files)

add_outer_loop:
    cmpl $0, %ecx
    je add_end  # Exit loop if no files left

    # Reset free space counter
    movl $0, ctSLibere

    # Read descriptor
    pushl $descriptor
    pushl $Input
    call scanf
    addl $8, %esp

    # Read dimensiune
    pushl $dimensiune
    pushl $Input
    call scanf
    addl $8, %esp

    # Ensure dimensiune is valid
    movl dimensiune, %eax
    cmpl $0, %eax
    jle add_no_space

    # Calculate dimensiune = ceil(dimensiune / 8)
    xorl %edx, %edx  # Clear upper 32 bits of dividend
    movl $8, %ecx
    divl %ecx        # Divide dimensiune by 8
    testl %edx, %edx # Check remainder
    je dim_ok        # If no remainder, skip increment
    incl %eax        # Increment to ceil
dim_ok:
    movl %eax, dimensiune

    # Inner loop to find free space
    xorl %ebx, %ebx  # %ebx = d (array index)
add_inner_loop:
    cmpl $255, %ebx
    jge add_no_space  # Exit if no space found

    # Check if v[d] == 0
    movl v(,%ebx,4), %eax
    cmpl $0, %eax
    jne add_reset_free_count

    # Increment free space counter
    incl ctSLibere
    movl ctSLibere, %eax
    cmpl dimensiune, %eax
    jne add_continue  # Not enough space yet

    # Found enough space
    movl %ebx, idFinal
    subl dimensiune, %ebx
    incl %ebx
    movl %ebx, idInceput

    # Print result
    pushl idFinal
    pushl idInceput
    pushl descriptor
    pushl $Output_add
    call printf
    addl $16, %esp  # Cleanup stack

    # Update v array
    movl idInceput, %eax
add_update_loop:
    pushl %ebx
    movl descriptor, %ebx
    movl %ebx, v(,%eax,4)
    popl %ebx
    incl %eax
    cmpl idFinal, %eax
    jle add_update_loop

    jmp add_outer_continue

add_reset_free_count:
    movl $0, ctSLibere

add_continue:
    incl %ebx
    jmp add_inner_loop

add_no_space:
    # Print (0,0) for no space found
    pushl $0
    pushl $0
    pushl descriptor
    pushl $Output_zero
    call printf
    addl $16, %esp  # Cleanup stack

add_outer_continue:
    decl %ecx
    jmp add_outer_loop
add_end:
    jmp et_loopPrincipalNext

GET:

DELETE:

DEFRAGMENTATION:
