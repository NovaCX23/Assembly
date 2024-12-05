; .data
;     x: .long 15
; .text
; .global main

; main:
;     movl $0, %eax
;     movl %eax, x
;     movl x, %ebx
;     mov $1, %eax
;     mov $0, %ebx
;     int $0x80


.data
.text
.global main

main:
    movl $0, %eax
    mov $1, %al
    mov $1, %eax
    mov $0, %ebx
    int $0x80