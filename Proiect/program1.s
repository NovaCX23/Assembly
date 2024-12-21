.data
	v: .space 4200
    w: .space 4200
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
    counter_w: .space 4
	Input: .asciz "%d"
    Output_add: .asciz "%d: (%d, %d)\n"
    Output_get: .asciz "(%d, %d)\n"

.text

.global main
main:
	lea v, %edi
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
add_loop_secundar:
    cmpl $1024, %ebx
    jge add_no_space  

    # If v[d] == 0
    movl v(,%ebx,4), %eax
    cmpl $0, %eax
    jne add_resetare_spatii
    
    # Increment free space counter
    incl ctSLibere
    movl ctSLibere, %eax
    cmpl dimensiune, %eax
    jne add_loop_secundar_continue  # Not enough space yet

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

    pushl $0
	call fflush
	addl $4, %esp

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

    jmp add_loop_principal_continue

add_resetare_spatii:
    movl $0, ctSLibere

add_loop_secundar_continue:
    incl %ebx
    jmp add_loop_secundar

add_no_space:
    # Cazul (0,0)
    pushl $0
    pushl $0
    pushl descriptor
    pushl $Output_add
    call printf
    addl $16, %esp  

    pushl $0
	call fflush
	addl $4, %esp

add_loop_principal_continue:
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
    xorl %ecx, %ecx # d=0

get_loop:
    cmpl $1024, %ecx
    je get_end

    movl v(,%ecx,4), %eax
    cmpl descriptor, %eax # v[d] == descriptor
    je get_indici

    incl %ecx
    jmp get_loop

get_indici:
    cmpl $1025, idInceput # daca idInceput e ocupat 
    jne get_id_final

    movl %ecx, idInceput # altfel
    incl %ecx
    jmp get_loop

get_id_final:
    movl %ecx, idFinal
    incl %ecx
    jmp get_loop


get_end:
    cmpl $1025, idInceput
    je get_caz_special

    # Afisare
    pushl idFinal
    pushl idInceput
    pushl $Output_get
    call printf
    addl $12, %esp

    pushl $0
	call fflush
	addl $4, %esp

    jmp loopPrincipalNext

get_caz_special:
    # Afișează caz special (dacă nu s-au găsit indicii)
    pushl $0
    pushl $0
    pushl $Output_get
    call printf
    addl $12, %esp

    pushl $0
	call fflush
	addl $4, %esp

    jmp loopPrincipalNext




DELETE:

    # Citim descriptorul
    pushl $descriptor         
    pushl $Input               
    call scanf                 
    addl $8, %esp              

    # Inițializare registru pentru iterație
    movl $0, %eax              

delete_Loop:
    # Verificăm dacă am terminat iterația
    cmpl $1024, %eax            
    je delete_beforeOverwriteLoop              

    # Calculăm adresele pentru v[%eax] și w[%eax]
    movl v(,%eax,4), %ebx      

    # Comparăm valoarea din v[%eax] cu descriptorul
    cmpl descriptor, %ebx      
    jne delete_Copy            # Dacă nu sunt egale, mergem la copiere

    # Dacă sunt egale, setăm w[%eax] = 0
    movl $0, w(,%eax,4)        
    jmp delete_Next            # Continuăm cu următorul element

delete_Copy:
    # Copiem v[%eax] în w[%eax]
    movl %ebx, w(,%eax,4)    # w[%eax] = v[%eax]

delete_Next:
    incl %eax                  
    jmp delete_Loop            # Repetăm bucla

delete_beforeOverwriteLoop:
    movl $0, %eax

delete_OverwriteLoop:
    cmpl $1024, %eax        
    je afisare        

    # Accesăm w[%eax]
    movl w(,%eax,4), %ebx 
    movl $0, w(,%eax,4) # resetare vector auxiliar
    movl %ebx, v(,%eax,4)    # v[%eax] = w[%eax]

    # Incrementăm %eax și revenim
    incl %eax
    jmp delete_OverwriteLoop


# Probabil voi transforma delete_afisare intr o afisare pt delete & defrag -> MERGE
afisare:
    # Inițializăm variabilele
    movl $0, descriptor         # descriptor = 0
    movl $0, idInceput          # idInceput = 0
    movl $0, idFinal            # idFinal = 0
    xorl %ebx, %ebx             # i = 0 (index pentru parcurgerea vectorului v)

afisare_loop:
    cmpl $1024, %ebx            # Comparăm i cu 1024
    jg afisare_end              # Dacă i > 1024, ieșim din buclă

    # Verificăm dacă descriptor == 0
    cmpl $0, descriptor
    je afisare_check_v          # Dacă descriptor = 0, verificăm v[i]

    # Dacă descriptor != 0, verificăm dacă v[i] == descriptor
    movl v(,%ebx, 4), %eax      # %eax = v[i]
    cmpl descriptor, %eax
    je afisare_update_idFinal   # Dacă v[i] == descriptor, actualizăm idFinal

    # Afișăm intervalul anterior
    pushl idFinal
    pushl idInceput
    pushl descriptor
    pushl $Output_add           # Formatul de afișare: "%d: (%d, %d)\n"
    call printf
    addl $16, %esp

    pushl $0
    call fflush
    addl $4, %esp

    # Resetăm descriptor și idInceput
    movl v(,%ebx, 4), %eax # descriptor = v[i]
    movl %eax, descriptor
    movl %ebx, idInceput        # idInceput = i
    jmp afisare_nextloop

afisare_update_idFinal:
    # Dacă v[i] == descriptor, actualizăm idFinal
    movl %ebx, idFinal          # idFinal = i
    jmp afisare_nextloop

afisare_check_v:
    # Verificăm dacă v[i] != 0
    movl v(,%ebx, 4), %eax      # %eax = v[i]
    cmpl $0, %eax
    je afisare_nextloop         # Dacă v[i] == 0, continuăm la următoarea iterație

    # Dacă v[i] != 0 și descriptor == 0, setăm descriptor = v[i] și idInceput = i
    movl %eax, descriptor       # descriptor = v[i]
    movl %ebx, idInceput        # idInceput = i

afisare_nextloop:
    incl %ebx                   # i++
    jmp afisare_loop            # Continuăm bucla

afisare_end:
    jmp loopPrincipalNext                         # Întoarcem la funcția apelantă






DEFRAGMENTATION:
# !!!trebuie afisare cum vrea rusu dar voi face o functie comuna de afisare pt delete si defrag 

    movl $0, counter_w

# Loop pentru copierea valorilor nenule din v în w
    movl $0, %eax   # indexului pentru v și w

defrag_CopyLoop:
    cmpl $1024, %eax    
    je defrag_FinishCopy 

    # Accesăm v[%eax]
    movl v(,%eax,4), %ebx 

    # Verificăm v[%eax] != 0
    cmpl $0, %ebx          
    je defrag_NextElement  

    # Dacă v[%eax] este nenul, copiem valoarea în w[counter_w]
    movl counter_w, %ecx  
    movl v(,%eax,4), %ebx  
    movl %ebx, w(,%ecx,4) # w[counter_w] = v[%eax]

    incl counter_w

defrag_NextElement:
    # Incrementăm %eax și revenim la următorul element
    incl %eax
    jmp defrag_CopyLoop

defrag_FinishCopy:
    # Loop pentru a copia valorile din w înapoi în v
    movl $0, %eax          # inițializarea indexului pentru w și v

defrag_OverwriteLoop:
    cmpl $1024, %eax        
    je defrag_afisare        

    # Accesăm w[%eax]
    movl w(,%eax,4), %ebx 
    movl $0, w(,%eax,4) # resetare vector auxiliar
    movl %ebx, v(,%eax,4)    # v[%eax] = w[%eax]

    # Incrementăm %eax și revenim
    incl %eax
    jmp defrag_OverwriteLoop


defrag_afisare:
    # folosesc exact acceasi afisare ca la delete 
    jmp afisare