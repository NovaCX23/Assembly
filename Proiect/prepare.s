
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

		addl $1, columnIndex
		jmp get_loop_coloane

    get_indici:

get_cont_loop_linii:
	addl $1, lineIndex
	jmp get_loop_linii

get_end:
    