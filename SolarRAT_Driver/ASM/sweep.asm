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

end:
delay:MOV R6, DELAY_COUNT_OUTER ; R1 = BUBBLE_OUTER_COUNT

outer_loop:MOV R7, DELAY_COUNT_MIDDLE

 
middle_loop:MOV R8, DELAY_COUNT_INNER

inner_loop:SUB R8, 1 
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

return:RET
