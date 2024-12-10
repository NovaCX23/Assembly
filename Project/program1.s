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
    Output: .asciz "%d\n"

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

    ; ========== For principal citire ============
et_loopPrincipal:
		
	pushl $tipOp
    pushl $Input
    call scanf
    popl %ebx
    popl %ebx
    
    ; ========== Cazuri ============
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
	loop et_loopPrincipal
	
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80


ADD:
    pushl $nrFis
    pushl $Input
    call scanf
    popl %ebx
    popl %ebx
    