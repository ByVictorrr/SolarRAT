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

;----CONSTANT DECLARATION-------------------
.EQU DELAY_COUNT_INNER = 10
.EQU DELAY_COUNT_MIDDLE = 10
.EQU DELAY_COUNT_OUTER = 10
.EQU BUBBLE_OUTER_COUNT =  12 ; 
.EQU BUBBLE_INNER_COUNT = 12
.EQU SWEEP_COUNT = 3
;-------------------------------------------------
.CSEG
.ORG 0x0D



main:
	;SEI ; set interupts
	CALL sweep
	CALL delay
	WSP R31 ; have stack pointer go back to 0
	BRN end

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
	MOV R0, 0 ; reset 

sweep_loop:

	CMP R3, 0 ; is sweep_count == 0?
	
	BREQ reset_sweep ; if yes == > PC = reset_sweep
	;else	

	MOV R4, SWEEP_COUNT
	
	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)

	MOV R1, R4 ; aruino[3:0] = 12-sweep count

	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT



	CALL delay

	OUT R1, ARDUINO_PORT ; output arduino[3:0] to Arduino_ID
	
	CALL delay
	
	;CALL delay
	
	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}

	MOV R0, R1 ; 

	; before storing arduino[7:0] got to concatenate its componets

	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]

    SUB R3, 1 ; sweep_count = sweep_count - 1
	
	BRN sweep_loop 


reset_sweep:
;	MOV R1, 0
;	OUT R1, ARDUINO_PORT
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




end:

 

 sweep_check:
			MOV R10, 0
sweep_check_loop:
			LSL R10	 ; starting sweep
			OUT R10, ARDUINO_PORT
			CALL delay 
			CALL delay
			IN R10, ARDUINO_PORT
			RET
			
			
			
 
 


