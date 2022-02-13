; Says to the assembler to make adjustments to the program so that 
; it could calculate 0x7c00 as the address which it will be loaded to
[org 0x7c00]

; To produce 16 bit opcodes for the instruction below
[bits 16]


;Switch To Protected Mode---------------

cli             ; Turns Interrupts off
lgdt [GDT_DESC] ; Loads Our GDT using lgdt keyword

; Sets the bit in cr0 to switch to 32 bit mode
mov eax , cr0
or  eax , 0x1
mov cr0 , eax 

; Switch To Protected Mode--------------

; Jumps To Our 32 bit Code (INIT_PM)
; Forces the cpu to flush out contents in cache memory
jmp  CODE_SEG:INIT_PM 


[bits 32]

INIT_PM:
mov ax , DATA_SEG
mov ds , ax
mov ss , ax
mov es , ax
mov fs , ax
mov gs , ax

mov ebp , 0x90000
mov esp , ebp ; Updates Stack Segment


jmp $ ;Hang , Remove This To Start Doing Things In 32 bit Mode





GDT_BEGIN:

GDT_NULL_DESC:  ;The  Mandatory  Null  Descriptor
	dd 0x0
	dd 0x0

GDT_CODE_SEG:
	dw 0xffff		;Limit
	dw 0x0			;Base
	db 0x0			;Base
	db 10011010b	;Flags
	db 11001111b	;Flags
	db 0x0			;Base

GDT_DATA_SEG:
	dw 0xffff		;Limit
	dw 0x0			;Base
	db 0x0			;Base
	db 10010010b	;Flags
	db 11001111b	;Flags
	db 0x0			;Base

GDT_END:

GDT_DESC:
	dw GDT_END - GDT_BEGIN - 1  ; Size of GDT table
	dd GDT_BEGIN                ; Beginning of GDT table

; defines the CODE SEGMENT and DATA SEGMENT locations
CODE_SEG equ GDT_CODE_SEG - GDT_BEGIN
DATA_SEG equ GDT_DATA_SEG - GDT_BEGIN

times 510-($-$$) db 0
dw 0xaa55