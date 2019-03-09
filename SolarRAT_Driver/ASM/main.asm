;--------------------------------------------------------------------
; Final Project: sweeep
; Author: Victor Delaplaine
; Date: 2019-03-09
; Description : Reads in a voltage from 180/12 positions each 15 degrees per location
;		Then stores it in the Reg file, and outputs the a value to turn the 
;		arduino 15 degrees more from its current location.
;
;
; Registers 0-11 are used specifically for arduino[7:0] on each 15 degrees.
; Example:
;	R0 - stores the data for location 0 degrees (natural position)
;	.
;	.
;	R11 - stores the data for location 180 degrees (last sweep position)
;
;
;  
;
; Register uses:
;
; R0 - arduino[i][7:0]
; R1 - arduino[i][3:0]
; R2 - arduino[i][7:4]
; R3 - Variable for sweep_count 
; R4 - Variable for 12 - sweep_count
; R5 - address of ith sweep position for arduino[i][7:0]
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
;--------------------------------------------

;----CONSTANT DECLARATION-------------------
.EQU SWEEP_COUNT = 12
;--------------------------------------------

.CSEG
.ORG 0x01



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
	BRN end



;--------------------------------------------------------------------
; Final Project: Delay
; Author: Victor Delaplaine
; Date: 1/23/19
; Description : Delays for .5s
;
;
;
; Register uses:
; R0 - reads in value X: (X)
; R1 - outer count variable  (C1)
; R2 - middle count variable  (C2)
; R3 - inner count variable  (C3)

;--------------------------------------------------------------------

.EQU IN_PORT = 0x9A
.EQU OUT_PORT = 0x42

.EQU COUNT_INNER = 108
.EQU COUNT_MIDDLE = 232
.EQU COUNT_OUTER = 246
;N_inner = 5
;N_middle = 3
;N_outer = 2


.CSEG
.ORG 0x01 

sweep:		IN R0, IN_PORT ; X = IN_PORT
		MOV R1, COUNT_OUTER ; R1 = OUTER_COUNT

outer_loop:	MOV R2, COUNT_MIDDLE
				
 	
middle_loop:	MOV R3, COUNT_INNER
		
inner_loop:	SUB R3, 1 
		CLC
		CLC
		CLC
		BRNE inner_loop
		
		CLC
		BRNE middle_loop
		BRNE outer_loop
		
return:		RET
;-----------------------------------------------------------




end:
