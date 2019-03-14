.EQU SWITCH_PORT = 0x96
.EQU ARDUINO_PORT =  0x69
.CSEG
.ORG 0x01


;-----------------------------------------------------------------------------
; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
;
; Tweaked parameters:
; R18 - {1,0,0,0,0,0,SW[1:0]} 
; - SW[7] tells us to go back from isr mode if high
;--------------------------------------------------------------------



ISR: ;keeping it on the sw[7]

IN R18, SWITCH_PORT ;reading an input 
AND R18, 131 ;telling ardino we are in isr by setting sw[7] ==1 and setting sw[6:2] = 0 (masking)
MOV R19, R18 ;setting a number equal to R19 before masking
OUT R18, ARDUINO_PORT ; output that sw[7] high and the value inputted

;is sw[7] == 1

AND R18, 128 ; SW[7] && 1

CMP R18, 128  

;is SW[7] === 1?
;if Sw[7] != 1 then branch to isr
BREQ ISR

output: ;loop for sw[7] being off
;keeping the sw[7] on  
OUT R19, ARDUINO_PORT
IN R19, SWITCH_PORT

AND R19, 128 ; SW[7] && 1

CMP R19, 128 

BREQ ISR
BRN output

 
