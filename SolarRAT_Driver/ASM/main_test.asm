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
.EQU SWITCH_PORT = 0x22
;--------------------------------------------

;=====CONSTANT DECLARATION========
;----General Delay Constants--------------
.EQU DELAY_COUNT_INNER = 24
.EQU DELAY_COUNT_MIDDLE = 4
.EQU DELAY_COUNT_OUTER = 2
;--------------------------------
;----Bubble sort Constants------
.EQU BUBBLE_OUTER_COUNT =  12 ; 
.EQU BUBBLE_INNER_COUNT = 12
;-------------------------------

;-----Sweep function consatns----
.EQU SWEEP_COUNT = 13
.EQU SWEEP_OUTPUT_DELAY = 2
;-------------------------------------------------
.CSEG
.ORG 0x0D



main:
	SEI ; set interupts
	CALL sweep
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

	MOV R3, SWEEP_COUNT

sweep_loop:

	MOV R6, DELAY_COUNT_OUTER

	CMP R3, 0 ; is sweep_count == 0?

	BREQ return_sweep ; if yes == > PC = reset_sweep
	;else
   
    MOV R4, SWEEP_COUNT ;	

	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)

	MOV R1, R4 ; aruino[3:0] = 12-sweep count
		
	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
	
	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}

	MOV R0, R1 ; 

	; before storing arduino[7:0] got to concatenate its componets

	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]

   
outer_loop:	
		MOV R7, DELAY_COUNT_MIDDLE
		OUT R1, ARDUINO_PORT 
 	
middle_loop:	MOV R8, DELAY_COUNT_INNER
		
inner_loop:	

		SUB R8, 1
		 
		BRNE inner_loop
		
		SUB R7, 1
		
		BRNE middle_loop
		
		SUB R6, 1
		BRNE outer_loop
		
		SUB R3, 1 ; sweep_count = sweep_count - 1
		BRNE sweep_loop


return_sweep:		RET

 
