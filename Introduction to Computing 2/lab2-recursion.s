;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Recursion
;

N	EQU	10

	AREA	globals, DATA, READWRITE

; N word-size values

SORTED	SPACE	N*4		; N words (4 bytes each)


	AREA	RESET, CODE, READONLY
	ENTRY

	;
	; copy the test data into RAM
	;

	LDR	R4, =SORTED
	LDR	R5, =UNSORT
	LDR	R6, =0
whInit	CMP	R6, #N
	BHS	eWhInit
	LDR	R7, [R5, R6, LSL #2]
	STR	R7, [R4, R6, LSL #2]
	ADD	R6, R6, #1
	B	whInit
eWhInit


	;
	; call your sort subroutine to test it
	;
	
	LDR		R0, =SORTED
	LDR		R1,	=N
	BL		SORT
	

STOP	B	STOP


	;
	; your swap subroutine goes here
	;
	
;This swap subroutine has three parameters passed into it via R0, R1 and R2
;R0 is the start address of the array
;R1 is the index of the first element to be swapped
;R2 is the index of the second element to be swapped
;
;At the end of the function, the parameter registers remain untouched but the elements have been swapped in the array
;starting at the memory address stored in R0
	
SWAP		PUSH	{R4, R5, LR}				; Push the registers used and the Link Register onto stack

			LDR		R4, [R0, R1, LSL #2]		; Load the first value into R4
			LDR		R5, [R0, R2, LSL #2]		; Load the second value into R5
					
			STR		R4, [R0, R2, LSL #2]		; Store the first value in the other index
			STR		R5, [R0, R1, LSL #2]		; Store the second value in the other index

			POP		{R4, R5, PC}				; restore the values of the used variables and go back to the program
			


	;
	; your sort subroutine goes here
	;
	
;This sort subroutine has two parameters passed into it via R0 and R1
;R0 is the start address of the array
;R1 is the length of the array

	
SORT		PUSH	{R4, R5, R6, R7, LR}

			SUB		R1, R1, #1					; R1 = N-1 (for the loop counter)

doWhile		MOV		R4, #0						; swapped = false
			MOV		R5, #0						; i = 0
			
			
sortForLoop	LDR		R6, [R0, R5, LSL #2]		; load in the value array[i - 1]
			ADD		R5, R5, #1					; make R5 = i
			LDR		R7, [R0, R5, LSL #2]		; load in the value array[i]
			
			CMP		R6, R7
			BLE		sortIfSkip
					
			PUSH	{R1}						; Temporarily store the length of the array on the stack
			MOV		R1, R5						; Make R1 the index of the first element to be swapped
			SUB		R2, R5, #1					; Make R2 the index of the second element  to be swapped
			BL		SWAP						; Swap these elements
	
			POP		{R1}						; Make R1 the length of the array again
			MOV		R4, #1						; swapped = true
			
sortIfSkip	CMP		R5, R1						; if i >= N
			BLT		sortForLoop					; don't repeat the for loop
			
			CMP		R4, #1
			BEQ		doWhile
			

			POP		{R4, R5, R6, R7, PC}

UNSORT	DCD	9,3,0,1,6,2,4,7,8,5

	END
