;--------------------------------------------------------------------
; Final Project: main.asm
; Author: Victor Delaplaine
; Date: 2019-03-09
; Description : Reads in a voltage from 180/12 positions each 15 degrees per location
;		Then stores it in the Reg file, and outputs the a value to turn the 
;		arduino 15 degrees more from its current location.
;
;
;  
;
; Register uses:
;
;--------------------------------------------------------------------

;-----------------Data Segment-------------------------------------
.DSEG
.ORG 0x01;

arduino_sweep: .BYTE 12 ; 0x01 ... 0x0C (12th)
;-------------------------------------------------------------------

;-----PORT DECLARATIONS----------------------
.EQU LIGHT_PORT  =  0x96
.EQU ARDUINO_PORT = 0x69
.EQU SWITCH_PORT = 0xFF
;--------------------------------------------

;----CONSTANT DECLARATION-------------------
.EQU DELAY_COUNT_INNER = 236
.EQU DELAY_COUNT_MIDDLE = 176
.EQU DELAY_COUNT_OUTER = 201
.EQU BUBBLE_OUTER_COUNT =  13 ; 
.EQU BUBBLE_INNER_COUNT = 13
.EQU SWEEP_COUNT = 13
;-------------------------------------------------
.CSEG
.ORG 0x0D


main:
	SEI ; set interupts
	CALL sweep
	CALL delay
	CALL bubble_sort
	CALL goBestLocation 
	CALL delay
	WSP R31 ; have stack pointer go back to 0
	BRN main

;------------------------------------------------------------------------------------
; sweep  subroutine - goes through 12 degrees every 2s collects data and moves servo
;
; Tweaked Parameters : 
;	      
; R0 - arduino[i][7:0]
; R1 - arduino[i][3:0]
; R2 - arduino[i][7:4]
; R3 - Variable for sweep_count 
; R4 - Variable for 12 - sweep_count
; R5 - address of ith sweep position for arduino[i][7:0]
; 
	
; Return : Nothing 
;
;--------------------------------------------------------------------

sweep:
	MOV R3, SWEEP_COUNT ;sweep_count = 12
	MOV R4, SWEEP_COUNT  

sweep_loop:

	CMP R3, 0 ; is sweep_count == 0?
	BREQ reset_sweep ; if yes == > PC = reset_sweep
	;else
        MOV R4, SWEEP_COUNT ;	

	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)

	MOV R1, R4 ; aruino[3:0] = 12-sweep count

	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT

	CALL delay

	OUT R1, ARDUINO_PORT ; output arduino[3:0] to Arduino_ID
	
	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}

	MOV R0, R1 ; 

	; before storing arduino[7:0] got to concatenate its componets

	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]

        SUB R3, 1 ; sweep_count = sweep_count - 1
	
	BRN sweep_loop 


reset_sweep:
	MOV R1, 0
	OUT R1, ARDUINO_PORT
	RET



;------------------------------------------------------------------------------------
; delay subroutine
; Delays for a given input of paramets R6, R7, R8
; Parameters : R6 - outer count variable  (C1)
; 	       R7 - middle count variable  (C2)
;              R8 - inner count variable  (C3)
;	      
;	
; Return : Nothing 
; Tweaked Parmeter : R6,R7,R8
;
;--------------------------------------------------------------------

;N_inner = 6
;N_middle = 4
;N_outer = 10

;3 inner
;2 middle
;1 outer


delay:	MOV R6, DELAY_COUNT_OUTER ; R1 = BUBBLE_OUTER_COUNT

outer_loop:	MOV R7, DELAY_COUNT_MIDDLE
				
 	
middle_loop:	MOV R8, DELAY_COUNT_INNER
		
inner_loop:	SUB R8, 1 
		CLC
		CLC
		CLC
		CLC
		BRNE inner_loop
		
		CLC
		CLC
		BRNE middle_loop
		
		CLC
		CLC
		CLC
		CLC
		CLC
		CLC
		CLC
		CLC
		BRNE outer_loop
		
return:		RET
;-----------------------------------------------------------


;--------------------------------------------------------------------
; bubble_sort - subroutine returns highest voltage data on at SCR[0]
;
; Tweaked parameters
; R9 - outer count
; R10 - inner count
; R11 - ADDR for inner count arr[i]
; R12 - ADDR for inner count + 1 ( arr[i+1[)
; R13 - temp
; R14  - used for input and outputting values (X)
; R15 - value fro arr[i] 
; R16 - value for arr[i+1]
;--------------------------------------------------------------------

bubble_sort: 

	MOV R9, BUBBLE_OUTER_COUNT ; outer_count = 10

bubble_outer_loop: 

	MOV R10, BUBBLE_INNER_COUNT ; inner_count = 3
	
bubble_inner_loop:
	;get index of k and k+1 from 0->

        ;ADDR_i = 4
	MOV R11, BUBBLE_INNER_COUNT
	;ADD R11, 1
	
	; ADDR_i+1 = 5
	MOV R12, BUBBLE_INNER_COUNT 
	ADD R12, 1
	
	SUB R11, R10 ; ADDR_i = 5 - count_inner
	SUB R12, R10 ; ADDR_i+1 = 6 - count_inner
	
	;get those values stored in the addres
	LD R15, (R11) ; Y = arr[ADDR_i]
	LD R16, (R12) ; Z = arr[ADDR_i+1]

	;COMPARE now

	CMP R15, R16 ; 
	
;if we get c = 1 that means arr[ADDR_i+1] is greater than or equal to arr[ADDR_i]
;so lets swap if this is the case
	BRCS swap 

decrement_count_inner: 	
	SUB R10, 1 ; count_inner = count_inner -1 
	BRNE bubble_inner_loop 
	SUB R9, 1 ;count_outer = count_outer - 1
	
	BRNE bubble_outer_loop
	RET
	
swap:   ;swap(arr[ADD_i], arr[ADD_i+1]) 
	MOV R13, R15 ; temp = arr[ADDR_i]
	MOV R15, R16 ; arr[ADDR_i] = arr[ADDR_i+1]
	MOV R16, R13 ; arr[ADDR_i+1]  = temp
	ST R16, (R12)
	ST R15, (R11)
	BRN decrement_count_inner 

 		
	
	
;-----------------------------------------------------------------------------
; goBestLocation - takes a value arr[0] top of stack and goes to that position
;
; Tweaked parameters:
; R17 - best location[3:0]
; R31 - using for zero
;--------------------------------------------------------------------

goBestLocation:
		WSP R31 ; reg that has value of 0
		POP R17
		OUT R17, ARDUINO_PORT
		CALL delay 	
		RET 
		
		
;---------------------------------------------

;-----------------------------------------------------------------------------
; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
;
; Tweaked parameters:
; R18 - {1,0,0,0,0,SW[2],SW[1:0]} 
; - first bit tells arduino isr mode
;--------------------------------------------------------------------

ISR:
	IN R18, SWITCH_PORT
	AND R18, 131
	OUT R18, ARDUINO_PORT
	AND R18, 128 ; check if we need to return from isr	
	CMP R18, 128
	
	;z == 1 if they are equal thus SW[2] is high
	BREQ ISR

	RETIE
	
.CSEG
.ORG 0x3FF
BRN ISR
