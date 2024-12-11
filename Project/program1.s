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
loopPrincipal:
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
	
loopPrincipalNext:
    popl %ecx
	loop loopPrincipal
	
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80


ADD:
    # Citire nr fisiere (nrFis)
    pushl $nrFis
    pushl $Input
    call scanf
    addl $8, %esp 

    movl nrFis, %ecx  # Counter loop exterior

add_outer_loop:
    cmpl $0, %ecx
    je add_end  

    # Resetare spatii libere 
    movl $0, ctSLibere

    # Descriptor
    pushl $descriptor
    pushl $Input
    call scanf
    addl $8, %esp

    # Dimensiune
    pushl $dimensiune
    pushl $Input
    call scanf
    addl $8, %esp

    # Verificare dimensiune
    movl dimensiune, %eax
    cmpl $0, %eax
    jle add_no_space

    # Dimensiune = ceil(dimensiune / 8)
    xorl %edx, %edx  
    movl $8, %ecx
    divl %ecx        
    cmp $0, %edx     
    je dim_ok        
    incl %eax        
dim_ok:
    movl %eax, dimensiune

    # Loop interior pentru spatii libere
    xorl %ebx, %ebx  # %ebx = d 
add_inner_loop:
    cmpl $255, %ebx
    jge add_no_space  

    # If v[d] == 0
    movl v(,%ebx,4), %eax
    cmpl $0, %eax
    jne add_reset_free_count

    # Increment free space counter
    incl ctSLibere
    movl ctSLibere, %eax
    cmpl dimensiune, %eax
    jne add_continue  # Not enough space yet

    # Suficient spatiu
    movl %ebx, idFinal
    subl dimensiune, %ebx
    incl %ebx
    movl %ebx, idInceput

    # Afisare 
    pushl idFinal
    pushl idInceput
    pushl descriptor
    pushl $Output_add
    call printf
    addl $16, %esp  

    # Actualizare array
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
    # Cazul (0,0)
    pushl $0
    pushl $0
    pushl descriptor
    pushl $Output_add
    call printf
    addl $16, %esp  

add_outer_continue:
    decl %ecx
    jmp add_outer_loop
add_end:
    jmp loopPrincipalNext

GET:

DELETE:

DEFRAGMENTATION:
