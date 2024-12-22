	
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
		movl (%edi, %eax, 4), %ebx
		

    afisare_loop_coloane_next:
		addl $1, columnIndex
		jmp afisare_loop_coloane
	
afisare_loop_linii_next:
	addl $1, lineIndex
	jmp afisare_loop_linii