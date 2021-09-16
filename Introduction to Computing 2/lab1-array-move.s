;
; CS1022 Introduction to Computing II 2018/2019
; Lab 1 - Array Move
;

N	EQU	16		; number of elements

	AREA	globals, DATA, READWRITE

; N word-size values

ARRAY	SPACE	N*4		; N words


	AREA	RESET, CODE, READONLY
	ENTRY

	; for convenience, let's initialise test array [0, 1, 2, ... , N-1]

	LDR	R0, =ARRAY
	LDR	R1, =0
L1	CMP	R1, #N
	BHS	L2
	STR	R1, [R0, R1, LSL #2]
	ADD	R1, R1, #1
	B	L1
L2

	; initialise registers for your program

	LDR	R0, =ARRAY
	LDR	R1, =6
	LDR	R2, =3
	LDR	R3, =N

	; your program goes here
	
	SUBS	R12, R1, R2				;R12 = distance the element has to move forwards or backwards
	CMP		R12, #0					;check if it's in it's correct spot
	BEQ		finishProgram			;if it's in it's spot go to end
	CMP		R12, #0					;is it moving forwards
	BLT		movingForwards			;if so skip ahead
	
	MOV		R4, #-1					;R4 = amount it will move back every time
	B		movingBackwards			;skip ahead to the moving part
movingForwards	
	MOV		R4, #1					;R4 = amount it will move forward every time
	
movingBackwards

repeat

	CMP		R12, #0					;if the distance the element is away from where it needs to be is 0
	BEQ		finishProgram			;end the program
	
	MOV		R9, R1, LSL #2			;R9 = address offset
	
	LDR		R7, [R0, R9]			;R7 = first swapping element
	ADD		R9, R9, R4, LSL #2		;R9 = address offset to swapping address
	LDR		R8, [R0, R9]			;R8 = second swapping element
	
	STR		R7, [R6]				;store second swapping element in first elements previous spot
	STR		R8, [R5]				;store first swapping element in second elements previous spot
	
	ADD		R12, R12, R4			;decrease the distance that the element needs to travel
	ADD		R1, R1, R4				;decrease the index of the element being shifted
	B		repeat
	


finishProgram
STOP	B	STOP

	END
