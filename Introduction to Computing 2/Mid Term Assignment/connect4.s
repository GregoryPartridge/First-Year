;
; CS1022 Introduction to Computing II 2018/2019
; Mid-Term Assignment - Connect 4 - SOLUTION
;
; get, put and puts subroutines provided by jones@scss.tcd.ie
;

PINSEL0	EQU	0xE002C000
U0RBR	EQU	0xE000C000
U0THR	EQU	0xE000C000
U0LCR	EQU	0xE000C00C
U0LSR	EQU	0xE000C014


	AREA	globals, DATA, READWRITE

BOARD	DCB	0,0,0,0,0,0,0
		DCB	0,0,0,0,0,0,0
		DCB	0,0,0,0,0,0,0
		DCB	0,0,0,0,0,0,0
		DCB	0,0,0,0,0,0,0
		DCB	0,0,0,0,0,0,0


	AREA	RESET, CODE, READONLY
	ENTRY

	; initialise SP to top of RAM
	LDR	R13, =0x40010000	; initialse SP

	; initialise the console
	BL	inithw

	;
	; your program goes here
	;	
	
	BL mains
	
	
	

stop	B	stop


;
; your subroutines go here
;

mains
	LDR R0, =str_go				; load a string of text
	MOV R2, #1					; if R2=1, it is reds turn, if R2=2, its yellows turn, if its equal to 3 then restart the game
	BL puts						; print the line of text
	BL innitialiseBoard			; sets the board up, it converts the ROM to RAM
	
re	BL drawBoard				; draws the board as it currently is
	BL makeMove					; allows the players to make moves on the board
	B re						; repeat loop


innitialiseBoard
	PUSH {R4-R7, lr}			;
	LDR R4, =0x400000B0			; load the memory address 0x400000B0 on R4
	LDR R5, =BOARD				; load the ROM BOARD on R5
	MOV R6, #0				    ; start a counter from 0 on register 6
	
L1	CMP R6, #42					; if the counter is greater than 42 then leave the loop
	BHS L2 						; 
	LDR R7, [R5, R6, LSL #2]	; load the value of the BOARD, each subsequent loop it will get the next value
	STR R7, [R4, R6, LSL #2]	; store the value of the board, this process is converting ROM to RAM
	ADD R6, R6, #1				; increase the counter by 1
	B L1						; repeat the loop
	
L2	POP {R4-R7, pc}		;

drawBoard
	PUSH{R4-R8, lr}
	LDR R0, =str_start_of_row	; load the string for the start of the board
	BL puts						; print the string
	LDR R4, =0x400000B0			; load the emory address at the start of the board
	LDR R5, =0x0				; load the counter that is for knowing which memory adress to access
	LDR R6, =0x0				; load the counter that is for knowing when to drop to the next row
L13	CMP R5, #42					; if R5 is equal or greater than this number leave the loop
	BHS L11						;
	MOV R7, #7					; load 7 on a registor
	MUL R8, R7, R6 				; R8 = counter * 7
	CMP R5, R8					; pseudo code, if the number is less than the available slots in the current row, skip the next few lines 
	BLO L12						;
	LDR R0, =str_newl			; load a string equal to a enter key press
	BL puts						; print the string
	ADD R6, R6, #1				; increment the row you are working on by 1
	MOV R1, R6					; make R1 equal the value of R6
	BL whatToPrintOnColoum		; call the subroutine whatToPrintOnColoumn
L12 LDR R0, [R4, R5, LSL #2]	; Load the value of the connect4 table onto the register
	CMP R0, #0					; compare the value from the table to 0
	BNE	L14						; if not equal skip this section and check with the next
	LDR R0, =str_blank_tile		; load a blank tile
	BL puts						; print the tile on the board
	B L16						; hop to end  of this segment
L14	CMP R0, #1					; compare the value fro the table with 1
	BNE L15						;
	LDR R0, =str_red_tile		;
	BL puts						;
	B L16						;
L15	CMP R0, #2					;
	BNE L16						;
	LDR R0, =str_yellow_tile		;
	BL puts						;
L16	ADD R5, R5, #1				; increment the count by 1
	B L13						; repeat loop
L11 LDR R0, =str_newl			; load the string to skip line
	BL puts						; print the string
	LDR R0, =str_newl			; load the string to skip line
	BL puts						; print string
	POP{R4-R8, pc}				; 

whatToPrintOnColoum
	PUSH{lr}					;
	CMP R1, #1					; compare the value to 1, if not equal skip to next statement
	BNE	L21						;
	LDR R0, =str_first_row		; load string for number 1
	B L26						; skip to end
L21	CMP R1, #2					; compare the value to 2, if not equal skip to next statement
	BNE	L22						;
	LDR R0, =str_second_row		; load string for number 2
	B L26						; skip to end
L22	CMP R1, #3					; compare the value to 3, if not equal skip to next statement
	BNE	L23						;
	LDR R0, =str_third_row		; load string for number 3
	B L26						; skip to end
L23	CMP R1, #4					; compare the value to 4, if not equal skip to next statement
	BNE	L24						;
	LDR R0, =str_fourth_row		; load string for number 4
	B L26						; skip to end
L24	CMP R1, #5					; compare the value to 5, if not equal skip to next statement
	BNE	L25						;
	LDR R0, =str_fifth_row		; load string for number 5
	B L26						; skip to end
L25	LDR R0, =str_sixth_row		; load string for number 6
L26 BL puts						; print string
	POP{pc}						;

makeMove
	PUSH{R4-R8, lr}				;
	LDR R5, =0x6				; load the amount of coloums on registor 5
	LDR R4, =0x4000013C			; load  the memory at the bottom of the coloums
	CMP R2, #1					; compare R2 to 0 and 1. This decides whos turn it is.
	BNE L35						;
	LDR R0, =str_reds_go		; Load the string signaling its reds go
	B L34						; skip the next line
L35	LDR R0, =str_yellows_go		; Load the string signaling its yellows go
L34	BL puts						; print the string
	BL get						; get a input from the user
	BL put						;
	SUB R0, R0, #0x30			; convert from ASCII to numerical
	CMP R0, #0					; check whether it is less than or equal to 0
	BLS L31						; pseudo code, if true leave loop as unsatisfactory input
	CMP R0, #7					; check wethers its greater than 7
	BHI L31						; pseudo code, if true leave loop as unsatisfactory input
	SUB R0, R0, #1				; subtract one as it technicaly starts at 0
	LDR R6, =0x4				; load the number 4 as that is the offset when working with words
	MUL R6, R0, R6				; multiply the inputed number by 4
	ADD R4, R6, R4				; add the number to the memory adress we wish to acess
L33	LDR R3, [R4]				; load the memory adress
	CMP R3, #0					; compare the adress with 0
	BEQ	L32						; if its equal we move to a new part of the code
	SUB R5, R5, #1				; otherwise we subtract 1 from the coloum we are in as there is already a tile there
	SUB R4, R4, #0x1c			; move the memory adress to refer to the tile above the inputed tile to see if its free
	CMP R5, #0					; see if the coloum counter has passed the top, then stop the turn and request to replace the tile
	BEQ L36						; if equal skip to this point
	B	L33						; else repeat the last bit of code
L31 CMP R0, #0x71				; see if the input was asking for a restart
	BNE L36						; skip to asking question again setup
	LDR R3, =0xa				; make R2 equal 3 to signify a restart
	B L37						; skip to end
L36	LDR R0, =str_newl			; load the string to skip line
	BL puts						; print the string
	LDR R0, =str_newl			; load the string to skip line
	BL puts						; print string
	LDR R0, =str_bad_input		; 
	BL puts						;
	B L37						; skip to end
L32	STR R2, [R4]				; load the current players turn onto the board
	CMP R2, #1					; see if its equal to 1
	BEQ L38						; if so skip 2 lines
	LDR R2, =0x1				; make R2 = 1
	B L37						; skip to end
L38	LDR R2, =0x2				; make R2 = 2
L37	LDR R0, =str_newl			; load the string to skip line
	BL puts						; print the string
	LDR R0, =str_newl			; load the string to skip line
	BL puts						; print string
	POP{R4-R6, pc}				;


	
	
;
; inithw subroutines
; performs hardware initialisation, including console
; parameters:
;	none
; return value:
;	none
;
inithw
	LDR	R0, =PINSEL0		; enable UART0 TxD and RxD signals
	MOV	R1, #0x50
	STRB	R1, [R0]
	LDR	R0, =U0LCR		; 7 data bits + parity
	LDR	R1, =0x02
	STRB	R1, [R0]
	BX	LR

;
; get subroutine
; returns the ASCII code of the next character read on the console
; parameters:
;	none
; return value:
;	R0 - ASCII code of the character read on teh console (byte)
;
get	LDR	R1, =U0LSR		; R1 -> U0LSR (Line Status Register)
get0	LDR	R0, [R1]		; wait until
	ANDS	R0, #0x01		; receiver data
	BEQ	get0			; ready
	LDR	R1, =U0RBR		; R1 -> U0RBR (Receiver Buffer Register)
	LDRB	R0, [R1]		; get received data
	BX	LR			; return

;
; put subroutine
; writes a character to the console
; parameters:
;	R0 - ASCII code of the character to write
; return value:
;	none
;
put	LDR	R1, =U0LSR		; R1 -> U0LSR (Line Status Register)
	LDRB	R1, [R1]		; wait until transmit
	ANDS	R1, R1, #0x20		; holding register
	BEQ	put			; empty
	LDR	R1, =U0THR		; R1 -> U0THR
	STRB	R0, [R1]		; output charcter
put0	LDR	R1, =U0LSR		; R1 -> U0LSR
	LDRB	R1, [R1]		; wait until
	ANDS	R1, R1, #0x40		; transmitter
	BEQ	put0			; empty (data flushed)
	BX	LR			; return

;
; puts subroutine
; writes the sequence of characters in a NULL-terminated string to the console
; parameters:
;	R0 - address of NULL-terminated ASCII string
; return value:
;	R0 - ASCII code of the character read on teh console (byte)
;
puts	STMFD	SP!, {R4, LR} 		; push R4 and LR
	MOV	R4, R0			; copy R0
puts0	LDRB	R0, [R4], #1		; get character + increment R4
	CMP	R0, #0			; 0?
	BEQ	puts1			; return
	BL	put			; put character
	B	puts0			; next character
puts1	LDMFD	SP!, {R4, PC} 		; pop R4 and PC


;
; hint! put the strings used by your program here ...
;

str_go
	DCB	"Let's play Connect4!!",0xA, 0xD, 0xA, 0xD, 0x0

str_newl
	DCB	0xA, 0xD, 0x0
	
str_reds_go
	DCB "RED: choose a column for your next move (1-7, q to restart): ", 0x0
	
str_yellows_go
	DCB "YELLOW: choose a column for your next move (1-7, q to restart): ", 0x0
	
str_bad_input
	DCB "The number you have put in is not an option at the moment. Please try again.", 0x0
	
str_start_of_row
	DCB "	 1	2	3	4	5	6	7", 0x0

str_red_tile
	DCB "R ", 0x0
	
str_yellow_tile
	DCB "Y ", 0x0
	
str_blank_tile
	DCB "O ", 0x0
	
str_first_row
	DCB "1 ", 0x0
	
str_second_row
	DCB "2 ", 0x0
	
str_third_row
	DCB "3 ", 0x0
	
str_fourth_row
	DCB "4 ", 0x0
	
str_fifth_row
	DCB "5 ", 0x0
	
str_sixth_row
	DCB "6 ", 0x0
	

	END
