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



ISR:
IN R18, SWITCH_PORT
AND R18, 131 ;telling ardino we are in isr by setting sw[7] ==1 and setting sw[6:2] = 0 (masking)
MOV R19, R18
OUT R18, ARDUINO_PORT ; output that sw[7] high and the value inputted
AND R18, 128 ; check if we need to return from isr
CMP R18, 128
;z == 1 if they are equal thus SW[7] is high
BRNE ISR
BRN output

output: 
OUT R19, ARDUINO_PORT
BRN output

 
