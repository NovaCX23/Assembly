delete_loop_linii:
	movl lineIndex, %ecx
	cmp %ecx, lines
	je et_exit

	movl $0, columnIndex
	delete_loop_coloane:
		movl columnIndex, %ecx
		cmp %ecx, columns
		je delete_loop_linii_next
		
		movl lineIndex, %eax
		mull columns
		addl columnIndex, %eax	
		movl (%edi, %eax, 4), %ebx
		

    delete_loop_coloane_next:
		addl $1, columnIndex
		jmp delete_loop_coloane
	
delete_loop_linii_next:
	addl $1, lineIndex
	jmp delete_loop_linii