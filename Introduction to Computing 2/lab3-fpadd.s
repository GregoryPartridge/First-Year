;
; CS1022 Introduction to Computing II 2018/2019
; Lab 3 - Floating-Point Addition
;

	AREA	RESET, CODE, READONLY
	ENTRY

;
; Test Data
;
FP_A	EQU	0x41960000			;0100,0001,1100,0100,0000,0000
FP_B	EQU	0x41C40000


	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	LDR	r0, =FP_A		; test value A
	LDR	r1, =FP_B		; test value B
	BL		fpadd

stop	B	stop


;
; fpdecode
; decodes an IEEE 754 floating point value to the signed (2's complement)
; fraction and a signed 2's complement (unbiased) exponent
; parameters:
;	r0 - ieee 754 float
; return:
;	r0 - fraction (signed 2's complement word)
;	r1 - exponent (signed 2's complement word)
;
fpdecode
		PUSH 	{LR}						;remember where to branch back to at the end
		MOV		R2, #0						;set the carry bit register to 0
		MOVS	R0, R0, LSL#1				;shift out the sign bit
		ADC		R2, R2, #0					;put the carry bit in R2
		MOV		R3, #0xFF					;R3 = exponent mask
		AND		R1, R3, R0, LSR#24			;get the exponent
		SUBS	R1, R1, #127				;make the exponent unbiased
		LDR		R3, =0x007FFFFF				;R3 = fraction mask
		AND		R0, R3, R0, LSR#1			;get the fraction
		MOV		R3, #1						;R3 = the hiddent bit
		ORR		R0, R0, R3, LSL#23			;put in the hidden bit
		CMP		R2, #0						;check if it is positive or negative
		BEQ		positiveF					;if its positive, do not get 2's complement
		MVN		R0, R0						;invert the bits
		ADD		R0, R0, #1					;add one
positiveF	
		POP		{PC}						;return to the main program

	


;don't assume normalised fractions
; fpencode
; encodes an IEEE 754 value using a specified fraction and exponent
; parameters:
;	r0 - fraction (signed 2's complement word)
;	r1 - exponent (signed 2's complement word)
; result:
;	r0 - ieee 754 float
;
fpencode
		PUSH 	{LR}					;remember where to branch back to
		MOV		R2, #0					;reset the value of the sign register
		MOVS	R3, R0, LSL #1			;shift out the sign bit
		ADC		R2, R2, #0				;get the sign bit
		CMP		R2, #0					;check if its positive
		BEQ		positivef				;if its positive, skip ahead
		MVN		R0, R0					;invert the bits
		ADD		R0, R0, #1				;add one
positivef
check	CMP		R0, #0x800000			;check to see if it is normalised
		BLT		under					;if the fraction is too small, shift left
		CMP		R0, #0x1000000			;check to see if it is normalised
		BGE		greater					;if the fraction is too big, shift right
		B		finishEncode			;if normalised, skip ahead
under	MOV		R0, R0, LSL#1			;shift fraction left
		SUB		R1, R1, #1				;exponent--
		B		check					;check if normalised
greater MOV		R0, R0, LSR#1			;shoft fraction right
		ADD		R1, R1, #1				;exponent++
		B		check					;check if normalised
finishEncode
		BIC		R0, R0, #0x00800000		;clear the hidden bit
		ORR		R0, R0, R2, LSL#31		;put the sign bit 
		ADD		R1, R1, #127			;bias the exponent
		ORR		R0, R0, R1, LSL#23		;put in the exponent
		POP 	{PC}					;return to the main program

	


;
; fpadd
; adds two IEEE 754 values
; parameters:
;	r0 - ieee 754 float A
;	r1 - ieee 754 float B
; return:
;	r0 - ieee 754 float A+B
;
fpadd
	PUSH	{LR, R4-R12}			;remember where to go back to and save all the values of the used registers
	MOV		R12, R1					;save the value of the second coded fraction
	BL		fpdecode				;decode the first frction
	MOV		R4, R0					;store the first fraction in R4
	MOV		R5, R1					;store the first exponent in R5
	MOV		R0, R12					;pass the second coded fraction in
	BL		fpdecode				;decode the second coded fration
	MOV		R6, R0					;store the second fraction in R6
	MOV		R7, R1					;store the second exponnt in R7
	CMP		R5, R7					;check which exponent is bigger
	BEQ		noChange				;move on to the add part
	BLT		dontSwap				;dont swap the positions of the fractions
	MOV		R0, R4					;
	MOV		R1, R5					;
	MOV		R4, R6					;this block just swaps the fractions and exponents into the other registers
	MOV		R5, R7					;
	MOV		R6, R0					;
	MOV		R7, R1					;
dontSwap
	SUB		R8, R7, R5				;get how much you need to change the exponent by
	MOV		R4, R4, LSR R8			;shift over the lower fraction
	ADD		R1, R5, R8				;add the difference onto the lower exponent
noChange
	ADD		R0, R4, R6				;add the fractions
	BL		fpencode				;encode the result
	POP		{PC, R4-R12}			;go back to the main program
	END
		
		
		
		
