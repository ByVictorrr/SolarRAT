

List FileKey 
----------------------------------------------------------------------
C1      C2      C3      C4    || C5
--------------------------------------------------------------
C1:  Address (decimal) of instruction in source file. 
C2:  Segment (code or data) and address (in code or data segment) 
       of inforation associated with current linte. Note that not all
       source lines will contain information in this field.  
C3:  Opcode bits (this field only appears for valid instructions.
C4:  Data field; lists data for labels and assorted directives. 
C5:  Raw line from source code.
----------------------------------------------------------------------


(0001)                            || ;--------------------------------------------------------------------
(0002)                            || ; Final Project: main.asm
(0003)                            || ; Author: Victor Delaplaine
(0004)                            || ; Date: 2019-03-09
(0005)                            || ; Description : Reads in a voltage from 180/12 positions each 15 degrees per location
(0006)                            || ;		Then stores it in the Reg file, and outputs the a value to turn the 
(0007)                            || ;		arduino 15 degrees more from its current location.
(0008)                            || ;
(0009)                            || ;
(0010)                            || ;  
(0011)                            || ;
(0012)                            || ; Register uses:
(0013)                            || ;
(0014)                            || ;--------------------------------------------------------------------
(0015)                            || 
(0016)                            || ;-----------------Data Segment-------------------------------------
(0017)                            || .DSEG
(0018)                       001  || .ORG 0x01;
(0019)                            || 
(0020)  DS-0x001             00C  || arduino_sweep: .BYTE 12 ; 0x01 ... 0x0C (12th)
(0021)                            || ;-------------------------------------------------------------------
(0022)                            || 
(0023)                            || ;-----PORT DECLARATIONS----------------------
(0024)                       150  || .EQU LIGHT_PORT  =  0x96
(0025)                       105  || .EQU ARDUINO_PORT = 0x69
(0026)                       034  || .EQU SWITCH_PORT = 0x22
(0027)                            || ;--------------------------------------------
(0028)                            || 
(0029)                            || ;=====CONSTANT DECLARATION========
(0030)                            || ;----General Delay Constants--------------
(0031)                       024  || .EQU DELAY_COUNT_INNER = 24
(0032)                       004  || .EQU DELAY_COUNT_MIDDLE = 4
(0033)                       002  || .EQU DELAY_COUNT_OUTER = 2
(0034)                            || ;--------------------------------
(0035)                            || ;----Bubble sort Constants------
(0036)                       012  || .EQU BUBBLE_OUTER_COUNT =  12 ; 
(0037)                       012  || .EQU BUBBLE_INNER_COUNT = 12
(0038)                            || ;-------------------------------
(0039)                            || 
(0040)                            || ;-----Sweep function consatns----
(0041)                       013  || .EQU SWEEP_COUNT = 13
(0042)                            || ;-------------------------------------------------
(0043)                            || .CSEG
(0044)                       013  || .ORG 0x0D
(0045)                            || 
(0046)                            || 
(0047)                            || 
(0048)                     0x00D  || main:
(0049)  CS-0x00D  0x1A000         || 	SEI ; set interupts
(0050)  CS-0x00E  0x08099         || 	CALL sweep
(0051)  CS-0x00F  0x08149         || 	CALL bubble_sort
(0052)  CS-0x010  0x081F9         || 	CALL goBestLocation 
(0053)  CS-0x011  0x15F00         || 	WSP R31 ; have stack pointer go back to 0
(0054)  CS-0x012  0x08068         || 	BRN main
(0055)                            || 
(0056)                            || ;------------------------------------------------------------------------------------
(0057)                            || ; sweep  subroutine - goes through 12 degrees every 2s collects data and moves servo
(0058)                            || ;
(0059)                            || ; Tweaked Parameters : 
(0060)                            || ;	      
(0061)                            || ; R0 - arduino[i][7:0]
(0062)                            || ; R1 - arduino[i][3:0]
(0063)                            || ; R2 - arduino[i][7:4]
(0064)                            || ; R3 - Variable for sweep_count 
(0065)                            || ; R4 - Variable for 12 - sweep_count
(0066)                            || ; R5 - address of ith sweep position for arduino[i][7:0]
(0067)                            || ; 
(0068)                            || 	
(0069)                            || ; Return : Nothing 
(0070)                            || ;
(0071)                            || ;--------------------------------------------------------------------
(0072)                            || 
(0073)                     0x013  || sweep: 
(0074)  CS-0x013  0x3630D         || 	MOV R3, SWEEP_COUNT
(0075)                            || 
(0076)                            || 
(0077)                     0x014  || sweep_loop:
(0078)                            || 
(0079)  CS-0x014  0x3660D         || 	MOV R6, SWEEP_COUNT
(0080)                            || 
(0081)  CS-0x015  0x30300         || 	CMP R3, 0 ; is sweep_count == 0?
(0082)                            || 
(0083)  CS-0x016  0x08142         || 	BREQ return_sweep ; if yes == > PC = reset_sweep
(0084)                            || 	;else
(0085)                            ||    
(0086)  CS-0x017  0x3640D         ||     MOV R4, SWEEP_COUNT ;	
(0087)                            || 
(0088)  CS-0x018  0x0241A         || 	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)
(0089)                            || 
(0090)  CS-0x019  0x04121         || 	MOV R1, R4 ; aruino[3:0] = 12-sweep count
(0091)                            || 		
(0092)  CS-0x01A  0x32296         || 	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
(0093)                            || 
(0094)  CS-0x01B  0x34169         || 	OUT R1, ARDUINO_PORT ; output arduino[3:0] to Arduino_ID
(0095)                            || 	
(0096)  CS-0x01C  0x00111         || 	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}
(0097)                            || 
(0098)  CS-0x01D  0x04009         || 	MOV R0, R1 ; 
(0099)                            || 
(0100)                            || 	; before storing arduino[7:0] got to concatenate its componets
(0101)                            || 
(0102)  CS-0x01E  0x04023         || 	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]
(0103)                            || 
(0104)  CS-0x01F  0x2C301         ||     	SUB R3, 1 ; sweep_count = sweep_count - 1
(0105)                            || 	
(0106)                            || 
(0107)  CS-0x020  0x36704  0x020  || outer_loop:	MOV R7, DELAY_COUNT_MIDDLE
(0108)  CS-0x021  0x34169         || 		OUT R1, ARDUINO_PORT 
(0109)                            ||  	
(0110)  CS-0x022  0x36818  0x022  || middle_loop:	MOV R8, DELAY_COUNT_INNER
(0111)                            || 		
(0112)  CS-0x023  0x2C801  0x023  || inner_loop:	SUB R8, 1 
(0113)  CS-0x024  0x0811B         || 		BRNE inner_loop
(0114)                            || 		
(0115)  CS-0x025  0x08113         || 		BRNE middle_loop
(0116)                            || 		
(0117)                            || 
(0118)  CS-0x026  0x08103         || 		BRNE outer_loop
(0119)                            || 		
(0120)                            || 
(0121)  CS-0x027  0x080A0         || 		BRN sweep_loop
(0122)                            || 
(0123)                            || 
(0124)  CS-0x028  0x18002  0x028  || return_sweep:		RET
(0125)                            || ; Tweaked Parmeter : R6,R7,R8
(0126)                            || ;
(0127)                            || ;--------------------------------------------------------------------
(0128)                            || 
(0129)                            || ;N_inner = 6
(0130)                            || ;N_middle = 4
(0131)                            || ;N_outer = 10
(0132)                            || 
(0133)                            || ;3 inner
(0134)                            || ;2 middle
(0135)                            || ;1 outer
(0136)                            || 
(0137)                            || 
(0138)                            || ;-----------------------------------------------------------
(0139)                            || 
(0140)                            || 
(0141)                            || ;--------------------------------------------------------------------
(0142)                            || ; bubble_sort - subroutine returns highest voltage data on at SCR[0]
(0143)                            || ;
(0144)                            || ; Tweaked parameters
(0145)                            || ; R9 - outer count
(0146)                            || ; R10 - inner count
(0147)                            || ; R11 - ADDR for inner count arr[i]
(0148)                            || ; R12 - ADDR for inner count + 1 ( arr[i+1[)
(0149)                            || ; R13 - temp
(0150)                            || ; R14  - used for input and outputting values (X)
(0151)                            || ; R15 - value fro arr[i] 
(0152)                            || ; R16 - value for arr[i+1]
(0153)                            || ;--------------------------------------------------------------------
(0154)                            || 
(0155)                     0x029  || bubble_sort: 
(0156)                            || 
(0157)  CS-0x029  0x3690C         || 	MOV R9, BUBBLE_OUTER_COUNT ; outer_count = 10
(0158)                            || 
(0159)                     0x02A  || bubble_outer_loop: 
(0160)                            || 
(0161)  CS-0x02A  0x36A0C         || 	MOV R10, BUBBLE_INNER_COUNT ; inner_count = 3
(0162)                            || 	
(0163)                     0x02B  || bubble_inner_loop:
(0164)                            || 	;get index of k and k+1 from 0->
(0165)                            || 
(0166)                            ||         ;ADDR_i = 4
(0167)  CS-0x02B  0x36B0C         || 	MOV R11, BUBBLE_INNER_COUNT
(0168)                            || 	;ADD R11, 1
(0169)                            || 	
(0170)                            || 	; ADDR_i+1 = 5
(0171)  CS-0x02C  0x36C0C         || 	MOV R12, BUBBLE_INNER_COUNT 
(0172)  CS-0x02D  0x28C01         || 	ADD R12, 1
(0173)                            || 	
(0174)  CS-0x02E  0x02B52         || 	SUB R11, R10 ; ADDR_i = 5 - count_inner
(0175)  CS-0x02F  0x02C52         || 	SUB R12, R10 ; ADDR_i+1 = 6 - count_inner
(0176)                            || 	
(0177)                            || 	;get those values stored in the addres
(0178)  CS-0x030  0x04F5A         || 	LD R15, (R11) ; Y = arr[ADDR_i]
(0179)  CS-0x031  0x05062         || 	LD R16, (R12) ; Z = arr[ADDR_i+1]
(0180)                            || 
(0181)                            || 	;COMPARE now
(0182)                            || 
(0183)  CS-0x032  0x04F80         || 	CMP R15, R16 ; 
(0184)                            || 	
(0185)                            || ;if we get c = 1 that means arr[ADDR_i+1] is greater than or equal to arr[ADDR_i]
(0186)                            || ;so lets swap if this is the case
(0187)  CS-0x033  0x0A1C8         || 	BRCS swap 
(0188)                            || 
(0189)                     0x034  || decrement_count_inner: 	
(0190)  CS-0x034  0x2CA01         || 	SUB R10, 1 ; count_inner = count_inner -1 
(0191)  CS-0x035  0x0815B         || 	BRNE bubble_inner_loop 
(0192)  CS-0x036  0x2C901         || 	SUB R9, 1 ;count_outer = count_outer - 1
(0193)                            || 	
(0194)  CS-0x037  0x08153         || 	BRNE bubble_outer_loop
(0195)  CS-0x038  0x18002         || 	RET
(0196)                            || 	
(0197)                     0x039  || swap:   ;swap(arr[ADD_i], arr[ADD_i+1]) 
(0198)  CS-0x039  0x04D79         || 	MOV R13, R15 ; temp = arr[ADDR_i]
(0199)  CS-0x03A  0x04F81         || 	MOV R15, R16 ; arr[ADDR_i] = arr[ADDR_i+1]
(0200)  CS-0x03B  0x05069         || 	MOV R16, R13 ; arr[ADDR_i+1]  = temp
(0201)  CS-0x03C  0x05063         || 	ST R16, (R12)
(0202)  CS-0x03D  0x04F5B         || 	ST R15, (R11)
(0203)  CS-0x03E  0x081A0         || 	BRN decrement_count_inner 
(0204)                            || 
(0205)                            ||  		
(0206)                            || 	
(0207)                            || 	
(0208)                            || ;-----------------------------------------------------------------------------
(0209)                            || ; goBestLocation - takes a value arr[0] top of stack and goes to that position
(0210)                            || ;
(0211)                            || ; Tweaked parameters:
(0212)                            || ; R17 - best location[3:0]
(0213)                            || ; R31 - using for zero 
(0214)                            || ;--------------------------------------------------------------------
(0215)                            || 
(0216)                     0x03F  || goBestLocation:
(0217)  CS-0x03F  0x15F00         || 		WSP R31 ; reg that has value of 0
(0218)  CS-0x040  0x13102         || 		POP R17
(0219)  CS-0x041  0x2110F         || 	    AND R17, 15 ; masking so R17 outputs 0000 loc[3:0] 	
(0220)                     0x042  || goBestLocation_output:
(0221)  CS-0x042  0x35169         || 		OUT R17, ARDUINO_PORT
(0222)  CS-0x043  0x08210         || 	    BRN goBestLocation_output
(0223)                            || 		
(0224)                            || 		
(0225)                            || ;---------------------------------------------
(0226)                            || 
(0227)                            || ;-----------------------------------------------------------------------------
(0228)                            || ; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
(0229)                            || ;
(0230)                            || ; Tweaked parameters:
(0231)                            || ; R18 - {1,0,0,0,0,0,SW[1:0]} 
(0232)                            || ; - SW[7] tells us to go back from isr mode if high
(0233)                            || ;--------------------------------------------------------------------
(0234)                            || 
(0235)                     0x044  || ISR:
(0236)  CS-0x044  0x37200         || 	MOV R18, 0
(0237)  CS-0x045  0x33222         || 	IN R18, SWITCH_PORT
(0238)  CS-0x046  0x21283         || 	AND R18, 131  ;telling ardino we are in isr by setting sw[7] ==1 and setting sw[6:2] = 0 (masking)
(0239)  CS-0x047  0x35269         || 	OUT R18, ARDUINO_PORT ; output that sw[7] high and the value inputted
(0240)  CS-0x048  0x21280         || 	AND R18, 128 ; check if we need to return from isr
(0241)                            || 	
(0242)  CS-0x049  0x31280         || 	CMP R18, 128
(0243)                            || 	
(0244)                            || 	;z == 1 if they are equal thus SW[7] is high
(0245)  CS-0x04A  0x08223         || 	BRNE ISR
(0246)  CS-0x04B  0x1A003         || 	RETIE
(0247)                            || 	
(0248)                            || .CSEG
(0249)                       1023  || .ORG 0x3FF
(0250)  CS-0x3FF  0x08220         || BRN ISR
(0251)                            || 
(0252)                            || 	
(0253)                            || 
(0254)                            || 
(0255)                            || 
(0256)                            || 
(0257)                            || 
(0258)                            || 
(0259)                            || 
(0260)                            || 
(0261)                            || 
(0262)                            || 
(0263)                            || 
(0264)                            ||  





Symbol Table Key 
----------------------------------------------------------------------
C1             C2     C3      ||  C4+
-------------  ----   ----        -------
C1:  name of symbol
C2:  the value of symbol 
C3:  source code line number where symbol defined
C4+: source code line number of where symbol is referenced 
----------------------------------------------------------------------


-- Labels
------------------------------------------------------------ 
BUBBLE_INNER_LOOP 0x02B   (0163)  ||  0191 
BUBBLE_OUTER_LOOP 0x02A   (0159)  ||  0194 
BUBBLE_SORT    0x029   (0155)  ||  0051 
DECREMENT_COUNT_INNER 0x034   (0189)  ||  0203 
GOBESTLOCATION 0x03F   (0216)  ||  0052 
GOBESTLOCATION_OUTPUT 0x042   (0220)  ||  0222 
INNER_LOOP     0x023   (0112)  ||  0113 
ISR            0x044   (0235)  ||  0245 0250 
MAIN           0x00D   (0048)  ||  0054 
MIDDLE_LOOP    0x022   (0110)  ||  0115 
OUTER_LOOP     0x020   (0107)  ||  0118 
RETURN_SWEEP   0x028   (0124)  ||  0083 
SWAP           0x039   (0197)  ||  0187 
SWEEP          0x013   (0073)  ||  0050 
SWEEP_LOOP     0x014   (0077)  ||  0121 


-- Directives: .BYTE
------------------------------------------------------------ 
ARDUINO_SWEEP  0x00D   (0020)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0025)  ||  0094 0108 0221 0239 
BUBBLE_INNER_COUNT 0x00C   (0037)  ||  0161 0167 0171 
BUBBLE_OUTER_COUNT 0x00C   (0036)  ||  0157 
DELAY_COUNT_INNER 0x018   (0031)  ||  0110 
DELAY_COUNT_MIDDLE 0x004   (0032)  ||  0107 
DELAY_COUNT_OUTER 0x002   (0033)  ||  
LIGHT_PORT     0x096   (0024)  ||  0092 
SWEEP_COUNT    0x00D   (0041)  ||  0074 0079 0086 
SWITCH_PORT    0x022   (0026)  ||  0237 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
