.data
	matrix: .space 1048588
    matrix_w: .space 1048588

    lineIndex: .long 1024
    columnIndex: .long 1024
    lines: .space 4
    columns: .space 4

	nrFis: .space 4
	nrOp: .space 4
	tipOp: .space 4
	ctSLibere: .space 4
	descriptor: .space 4
	dimensiune: .space 4

    idInceput: .space 4
	idFinal: .space 4
    counter_w: .space 4

	Input: .asciz "%d"
    Output: .asciz "%d: ((%d, %d), (%d, %d))\n"
    Output_get: .asciz "((%d, %d), (%d, %d))\n"
    Print: .asciz "%d\n"

.text

.global main
main:
	lea matrix, %edi

    pushl $nrOp
	pushl $Input
	call scanf
	addl $8, %esp

	movl nrOp, %ecx

    #  For principal citire 
loopPrincipal:
	pushl %ecx
	pushl $tipOp
    pushl $Input
    call scanf
    addl $8, %esp
    
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
    
    movl $0, lineIndex
    movl $0, columnIndex

add_loop_principal:
    pushl %ecx
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

    # Verificare daca dimensiunea exista
    movl dimensiune, %eax
    cmpl $0, %eax
    je add_loop_principal_next

    # Dimensiune = ceil(dimensiune / 8)
    xorl %edx, %edx  
    movl $8, %ecx
    divl %ecx        
    cmp $0, %edx     
    je dim_ok        
    incl %eax        
    
    dim_ok:
        movl %eax, dimensiune

    movl $0, lineIndex
    add_loop_linii:
        movl lineIndex, %ecx
        cmp %ecx, lines
        je add_loop_linii_done        # verificam daca am terminat liniile 


        movl $0, ctSLibere
        # incepe loop ul de coloane
        movl $0, columnIndex
        add_loop_coloane:
            movl columnIndex, %ecx
		    cmp %ecx, columns
		    je add_loop_linii_next          # Verificam daca s-a terminat linia
                                            # daca da , trecem la urm

            # calc pozitia elem curent in matrice
            movl lineIndex, %eax
            mull columns
            addl columnIndex, %eax
            
            movl (%edi, %eax, 4), %ebx         # %ebx = matrix[k][d]

            cmp $0, %ebx
            jne add_resetare_spatii         
            
            incl ctSLibere                  # Incrementăm ct de spatii libere
            movl ctSLibere, %eax
            cmp %eax, dimensiune            
            jne add_loop_coloane_next       # trecem la urm linie daca n avem loc

            # Suficient spatiu
            movl %ecx, idFinal
            subl dimensiune, %ecx
            incl %ecx
            movl %ecx, idInceput

            # Afisare 
            pushl idFinal
            pushl lineIndex
            pushl idInceput
            pushl lineIndex
            pushl descriptor
            pushl $Output
            call printf
            addl $24, %esp  

            pushl $0
            call fflush
            addl $4, %esp

            # update matrice
            movl idInceput, %eax
            add_update_matrice:
                movl descriptor, %ebx
                movl %ebx, (%edi,%eax,4)
                incl %eax
                cmpl idFinal, %eax
                jle add_update_matrice
            
            jmp add_loop_principal_next

            add_resetare_spatii:
                movl $0, ctSLibere

        add_loop_coloane_next:
            addl $1, columnIndex
		    jmp add_loop_coloane

    add_loop_linii_next:
        addl $1, lineIndex
        jmp add_loop_linii

    add_loop_linii_done:
        movl ctSLibere, %eax
        cmp %eax, dimensiune
        je add_loop_principal_next

        # cazul00
        pushl $1
        pushl $0
        pushl $0
        pushl $0
        pushl descriptor
        pushl $Output
        call printf
        addl $24, %esp  

        pushl $0
        call fflush
        addl $4, %esp

add_loop_principal_next:
    popl %ecx
    decl %ecx
    jmp add_loop_principal

add_end:
    popl %ecx
    jmp loopPrincipalNext



GET:




DELETE:




DEFRAGMENTATION: