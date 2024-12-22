.data
	matrix: .space 4194304
    matrix_w: .space 4194304

    lineIndex: .space 4
    columnIndex: .space 4

    lines: .long 1024
    columns: .long 1024

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
	
    pushl $0
    call fflush
    addl $4, %esp


	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80

# when i started only I and GOD knew how this worked, now only god knows, please don't change shit!!
ADD:
    # Citire nr fisiere (nrFis)
    pushl $nrFis
    pushl $Input
    call scanf
    addl $8, %esp 

    movl nrFis, %ecx  # Counter loop exterior
    
add_loop_principal:

    # ne asiguram ca matricea e parcursa de la inceput de fiecare data 

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


    # Dimensiune = ceil(dimensiune / 8)
    movl dimensiune, %eax
    xorl %edx, %edx  
    movl $8, %ecx
    divl %ecx        
    cmp $0, %edx     
    je dim_ok        
    incl %eax        
    dim_ok:
    movl %eax, dimensiune


    movl $0, lineIndex
for_lines:
	movl lineIndex, %ecx
	cmp %ecx, lines
	je add_loop_linii_end
	
    movl $0, ctSLibere
    movl $0, idInceput
    movl $0, idFinal
	movl $0, columnIndex
	for_columns:
		movl columnIndex, %ecx
		cmp %ecx, columns
		je cont_for_lines
		
	
		
		movl lineIndex, %eax
		mull columns
		addl columnIndex, %eax
		
		movl (%edi, %eax, 4), %ebx # %ebx are elem curent

        cmp $0, %ebx
        je add_calcul

        movl $0, ctSLibere
        jmp for_columns_end

        add_calcul:

        incl ctSLibere
        movl dimensiune, %edx
        cmp ctSLibere, %edx
        jne for_columns_end

        # idInceput = columnIndex + 1 - dimensiune;
        movl columnIndex, %ecx
        movl %ecx, idFinal
        incl %ecx
        subl %edx, %ecx
        movl %ecx, idInceput

        pushl %eax
        pushl %edx
        pushl idFinal
        pushl lineIndex
        pushl idInceput
        pushl lineIndex
        pushl descriptor
        pushl $Output
        call printf
        addl $24, %esp
        popl %edx
        popl %eax

        # idInceput = (lineIndex * columns + columnIndex) + 1 - dimensiune;
        movl %eax, idFinal
        incl %eax
        subl %edx, %eax
        movl %eax, idInceput


        movl idInceput, %eax
        add_Memorie:
        cmp idFinal, %eax
        jg add_loop_linii_end

        movl descriptor, %ecx
        movl %ecx, (%edi, %eax, 4)
        incl %eax
        jmp add_Memorie

		
		for_columns_end:
		addl $1, columnIndex
		jmp for_columns
	
cont_for_lines:


	addl $1, lineIndex
	jmp for_lines


    add_loop_linii_end:

    cmp ctSLibere, %edx
    je add_loop_linii_end_skip

    pushl $0
    pushl $0
    pushl $0
    pushl $0
    pushl descriptor
    pushl $Output
    call printf
    addl $24, %esp

    add_loop_linii_end_skip:
    popl %ecx
    decl %ecx
    jmp add_loop_principal
add_end:
    popl %ecx
    jmp loopPrincipalNext





GET:
    movl $1025, idInceput
    movl $1025, idFinal
    
    # Citirea descriptorului
    pushl $descriptor
    pushl $Input
    call scanf
    addl $8, %esp

    xorl %eax, %eax
    xorl %ecx, %ecx # i=0
    movl $0, lineIndex

    # incepem primul for

get_loop_linii:
	movl lineIndex, %ecx
	cmp %ecx, lines
	je get_end

	movl $0, columnIndex
	get_loop_coloane:
		movl columnIndex, %ecx
		cmp %ecx, columns
		je get_cont_loop_linii
		
		movl lineIndex, %eax
		mull columns
		addl columnIndex, %eax
		
		movl (%edi, %eax, 4), %ebx      # %ebx are elem curent matrix 
        cmp %ebx, descriptor            # verificam daca elem curent e cel cautat
        je get_indici
		
        get_cont_loop_coloane:
		addl $1, columnIndex
		jmp get_loop_coloane
	
    
    get_indici:
        cmpl $1025, idInceput # daca idInceput e ocupat 
        jne get_id_final

        movl %ecx, idInceput # altfel
        pushl lineIndex
        jmp get_cont_loop_coloane

    get_id_final:
        movl %ecx, idFinal
        jmp get_cont_loop_coloane



get_cont_loop_linii:
    addl $1, lineIndex
    jmp get_loop_linii

get_end:
    cmpl $1025, idInceput
    je get_caz_special

    popl lineIndex

    # Afisare
    pushl idFinal
    pushl lineIndex
    pushl idInceput
    pushl lineIndex
    pushl $Output_get
    call printf
    addl $20, %esp

    jmp loopPrincipalNext

get_caz_special:
    # Afișează caz special (dacă nu s-au găsit indicii)
    pushl $0
    pushl $0
    pushl $0
    pushl $0
    pushl $Output_get
    call printf
    addl $20, %esp


    jmp loopPrincipalNext


DELETE:
    # Citim descriptorul
    pushl $descriptor         
    pushl $Input               
    call scanf                 
    addl $8, %esp              

    movl $0, lineIndex              

delete_loop_linii:
	movl lineIndex, %ecx
	cmp %ecx, lines
	je delete_OverwriteLoop

	movl $0, columnIndex
	delete_loop_coloane:
		movl columnIndex, %ecx
		cmp %ecx, columns
		je delete_loop_linii_next
		
		movl lineIndex, %eax
		mull columns
		addl columnIndex, %eax	
		movl (%edi, %eax, 4), %ebx              # elem curent in matrice
		
        # verif daca elem curent din matrice e egal cu descriptorul
        cmp descriptor, %ebx
        jne delete_Copy

        # daca e egal bagam 0 in matricea aux
        movl $0, matrix_w(,%eax,4)
        jmp delete_loop_coloane_next

        delete_Copy:
            # daca nu e egal bagam elem curent din matrice in matricea aux
            movl %ebx, matrix_w(,%eax,4)

    delete_loop_coloane_next:
		addl $1, columnIndex
		jmp delete_loop_coloane
	
delete_loop_linii_next:
	addl $1, lineIndex
	jmp delete_loop_linii

delete_OverwriteLoop:
    
    movl $0, columnIndex
    movl $0, lineIndex
    
    overwrite_loop_linii:
	movl lineIndex, %ecx
	cmp %ecx, lines
	je AFISARE

	movl $0, columnIndex
	overwrite_loop_coloane:
		movl columnIndex, %ecx
		cmp %ecx, columns
		je overwrite_loop_linii_next
		
		movl lineIndex, %eax
		mull columns
		addl columnIndex, %eax	
		movl matrix_w(, %eax, 4), %ebx              # elem curent din matricea aux
		
        # incarcam matrix{} = matrix_w{} si matrix_w[i][j] = 0
        movl %ebx , (%edi, %eax, 4)
        movl $0, matrix_w(, %eax, 4)

    overwrite_loop_coloane_next:
		addl $1, columnIndex
		jmp overwrite_loop_coloane
	
overwrite_loop_linii_next:
	addl $1, lineIndex
	jmp overwrite_loop_linii



DEFRAGMENTATION:





AFISARE:

	movl $0, descriptor         
    movl $0, idInceput          
    movl $0, idFinal            
	movl $0, idInceput

    movl $0, lineIndex
afisare_loop_linii:
	movl lineIndex, %ecx
	cmp %ecx, lines
	je afisare_end

	movl $0, columnIndex
	afisare_loop_coloane:
		movl columnIndex, %ecx
		cmp %ecx, columns
		je afisare_loop_linii_next
		
		movl lineIndex, %eax
		mull columns
		addl columnIndex, %eax	
		movl (%edi, %eax, 4), %ebx      # elem curent matrix
		
        movl $0, %edx
        cmp %edx, descriptor
        je afisare_descriptor0          # Dacă descriptor == 0, verif matrix[i][j] 

        # Daca descriptor != 0
        cmp %ebx, descriptor
        jne afisare_printare_intervale
        
        # matrix[i][j] == descriptor
        movl %ecx, idFinal                 # idFinal = j
        jmp afisare_loop_coloane_next


        afisare_printare_intervale:
            pushl %ebx
            
            pushl idFinal
            pushl lineIndex
            pushl idInceput
            pushl lineIndex
            pushl descriptor
            pushl $Output           
            call printf
            addl $24, %esp
            
            popl %ebx

            movl %ebx, descriptor
            movl %ecx, idInceput
            jmp afisare_loop_coloane_next

        afisare_descriptor0:
            # Verificăm dacă v[i] != 0
            movl %ebx, %edx      # %edx = matrix[i][j] (%ebx)
            cmpl $0, %edx
            je afisare_loop_coloane_next    # Dacă matrix[i][j] == 0, continuăm la următoarea iterație

        # Dacă matrix[i][j] != 0 și descriptor == 0, setăm descriptor = matrix[i][j] și idInceput = j
            movl %edx, descriptor       # descriptor = matrix[i][j]
            movl %ecx, idInceput
            jmp afisare_loop_coloane_next


    afisare_loop_coloane_next:
		addl $1, columnIndex
		jmp afisare_loop_coloane
	
afisare_loop_linii_next:
	addl $1, lineIndex
	jmp afisare_loop_linii

afisare_end:
    jmp loopPrincipalNext