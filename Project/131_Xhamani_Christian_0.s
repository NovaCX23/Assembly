.data

	v: .space 1024
	nOperatii: .space 4
	codOperatie: .space 4
	countSpaatiiLibere: .space 4
	descriptor: .space 4
	dimensiune: .space 4
	j: .space 4
	d: .space 4
	idInceput: .space 4
	idFinal: .space 4
	formatInput: .asciz "%d"
    formatOutput: .asciz "%d\n"

.text

.global main
main:
	lea v, %edi
    pushl $nOperatii
	pushl $formatInput
	call scanf
	popl %ebx
	popl %ebx

	movl nOperatii, %ecx
	
	; ========== For principal citire ============
et_loopPrincipal:
		
	pushl $codOperatie
    pushl $formatInput
    call scanf
    popl %ebx
    popl %ebx

    ; ========== Cazuri ============

	movl codOperatie, %eax
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

	pushl $nFisiere
	pushl $formatInput
	call scanf
	popl %ebx
	popl %ebx
	xorl %eax, %eax
	
	add_loop_j:
		pushl %eax ; stocare eax inainte de a-l folosi altundeva
		cmp $nFisiere, %eax
		je end_ADD
		movl $0, countSpaatiiLibere

		;  ======== descriptor + dimensiune ===========
		pushl $descriptor
		pushl $formatInput
		pushl $dimensiune
		pushl $formatInput
		call scanf
		popl %ebx
		popl %ebx
		popl %ebx
		popl %ebx
		
		;  ======== calc  dimensiune ============

		movl dimensiune, %eax
		movl $8, %ebx
		divl %ebx
		cmp $0, %edx ; restul 
		je add_done_dimension
		incl %eax
	
	add_done_dimension:
		movl %eax, dimensiune
		movl $0, countSpaatiiLibere
		xorl %ebx, %ebx
		xorl %edx, %edx
		xorl %eax, %eax
	
	add_loop_d:
		cmp $255, %ebx  ; ebx este d ul 
		jge spatiu_insuficient

		; ======= verificam daca avem spatiu liber =======
		movl v(, %ebx, 4), %eax
		cmp $0, %eax
		jne urm_spatiu

		; ======= daca e liber =======
		incl countSpaatiiLibere
		movl countSpaatiiLibere, %edx
		cmp %edx, dimensiune
		je spatiu_gasit

	urm_spatiu:
		incl %ebx
		jmp add_loop_d

	spatiu_gasit:
		movl %ebx , idFinal
		subl dimensiune, %ebx
		incl %ebx
		movl %ebx , idInceput
		
		; ========= AFISARE ========
		pushl idFinal
        pushl idInceput
        pushl descriptor
        pushl $formatOutput
        call printf
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ebx

		; ========== marcare spatii ocupate ==========
		movl idInceput, %ebx
		ocupa:
			cmp idFinal, %ebx
			je ocupate
			movl descriptor, v(,%ebx,4)
			incl %ebx
			jmp ocupa
		ocupate:
			popl %eax
			incl %eax
			jmp add_loop_j


	end_ADD:
		jmp et_loopPrincipalNext 

GET:



        jmp et_loopPrincipalNext 

DELETE:




        jmp et_loopPrincipalNext

DEFRAGMENTATION:





        jmp et_loopPrincipalNext