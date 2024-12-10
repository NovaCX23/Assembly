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
    pushl $nrFis
    pushl $Input
    call scanf
    popl %ebx
    popl %ebx

    add_for_principal:
        xorl %eax, %eax
        cmp nrFis, %eax
        je add_end
        movl $0, ctSLibere

        #citire descriptor
        pushl descriptor
        pushl Input
        call scanf
        popl %ebx 
        popl %ebx

        #citire dimensiune
        pushl dimensiune
        pushl Input
        call scanf
        popl %ebx 
        popl %ebx


        #calc dimensiune
        movl dimensiune, %eax
        movl $8, %ecx
        divl %ecx
        cmpl $0, %edx
        je dimensiune_ok
        incl %eax

        dimensiune_ok:
            movl %eax, dimensiune
        
        xorl %ebx, %ebx
        add_for_secundar:
            pushl %ebx
            cmp $255, %ebx
            jge add_for_secundar_end

            
            #intoarcere fortata + incrementare 
            add_for_secundar_incrementare:
                popl %ebx
                incl %ebx
                jmp add_for_secundar
        
        add_for_secundar_end:
            #break --- > aici pun cazul de 0,0

    add_for_principal_end:
        decl nrFis
        jmp add_for_principal

    add_end:
        jmp et_loopPrincipalNext

resetare_spatii_libere:
    movl $0, ctSLibere
    jmp add_for_secundar_incrementare

GET:

DELETE:

DEFRAGMENTATION:
