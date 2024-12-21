.data
	matrix: .space 1048588
    matrix_w: .space 1048588

    lineIndex: .space 4
    columnIndex: .space 4
    
    lines: .long 8
    columns: .long 8

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

    movl nrFis, %ecx                # Counter loop fisiere

    movl $0, lineIndex
    movl $0, columnIndex

add_loop_fisiere:
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

    movl $0, lineIndex
    movl $0, columnIndex
    
    # Loop linii
    add_loop_linii:
        movl lineIndex, %ecx
        cmp %ecx, lines
        je add_loop_linii_done

        movl $0, ctSLibere
        movl $0, columnIndex

        # incepe loop-ul de coloane
        add_loop_coloane:
            movl columnIndex, %ecx
            cmp %ecx, columns
            je add_loop_linii_next

            # Calculare element curent  -> v[k][d]
            movl lineIndex, %eax
            mull columns
            addl columnIndex, %eax
            movl (%edi, %eax, 4), %ebx      # %ebx = v[k][d]

            cmp $0, %ebx
            jne add_resetare_spatii

            # daca v[k][d] == 0
            addl $1, ctSLibere
            
            # verificam daca avem destul spatiu liber pt dimensiune, daca nu trecem la urm col
            movl ctSLibere, %edx
            cmp %edx, dimensiune
            jne add_loop_coloane_next

            # daca avem spatiu, calc indicii
            movl %ecx, idFinal
            incl %ecx
            subl dimensiune, %ecx
            movl %ecx, idInceput

            # afisam intervalele
            pushl idFinal
            pushl lineIndex
            pushl idInceput
            pushl lineIndex
            pushl descriptor
            pushl $Output
            call printf
            addl $24, %esp  

            # actualizam matricea 
            movl idInceput, %ecx
            add_update_matrice:
                movl descriptor, %eax
                movl %eax, (%edi, %ecx, 4)
                 
                incl %ecx
                # daca am terminat de actualizat 
                cmp %ecx, idFinal
                jg add_loop_fisiere_next
                
                # altfel continuam
                jmp add_update_matrice 

            add_resetare_spatii:
                movl $0, ctSLibere
                jmp add_loop_coloane_next


        add_loop_coloane_next:
            addl $1, columnIndex
            jmp add_loop_coloane


    add_loop_linii_next:
        addl $1, lineIndex
        jmp add_loop_linii


    add_loop_linii_done:
        movl ctSLibere, %eax
        je add_loop_fisiere_next            # verificam daca ctSLibere != dimensiune

        # daca e diferit afisam cazul 00
        pushl $0
        pushl $0
        pushl $0
        pushl $0
        pushl descriptor
        pushl $Output
        call printf
        addl $24, %esp  

add_loop_fisiere_next:
    popl %ecx
    decl %ecx
    jmp add_loop_fisiere

add_end:
    popl %ecx
    jmp loopPrincipalNext



GET:




DELETE:




DEFRAGMENTATION: