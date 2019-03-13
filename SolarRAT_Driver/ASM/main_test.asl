

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
(0042)                       002  || .EQU SWEEP_OUTPUT_DELAY = 2
(0043)                            || ;-------------------------------------------------
(0044)                            || .CSEG
(0045)                       013  || .ORG 0x0D
(0046)                            || 
(0047)                            || 
(0048)                            || 
(0049)                     0x00D  || main:
(0050)  CS-0x00D  0x1A000         || 	SEI ; set interupts
(0051)  CS-0x00E  0x08099         || 	CALL sweep
(0052)  CS-0x00F  0x08161         || 	CALL bubble_sort
(0053)  CS-0x010  0x08211         || 	CALL goBestLocation 
(0054)  CS-0x011  0x15F00         || 	WSP R31 ; have stack pointer go back to 0
(0055)  CS-0x012  0x08068         || 	BRN main
(0056)                            || 
(0057)                            || ;------------------------------------------------------------------------------------
(0058)                            || ; sweep  subroutine - goes through 12 degrees every 2s collects data and moves servo
(0059)                            || ;
(0060)                            || ; Tweaked Parameters : 
(0061)                            || ;	      
(0062)                            || ; R0 - arduino[i][7:0]
(0063)                            || ; R1 - arduino[i][3:0]
(0064)                            || ; R2 - arduino[i][7:4]
(0065)                            || ; R3 - Variable for sweep_count 
(0066)                            || ; R4 - Variable for 12 - sweep_count
(0067)                            || ; R5 - address of ith sweep position for arduino[i][7:0]
(0068)                            || ; 
(0069)                            || 	
(0070)                            || ; Return : Nothing 
(0071)                            || ;
(0072)                            || ;--------------------------------------------------------------------
(0073)                            || 
(0074)                     0x013  || sweep: 
(0075)                            || 
(0076)  CS-0x013  0x3630D         || 	MOV R3, SWEEP_COUNT
(0077)                            || 
(0078)                     0x014  || sweep_loop:
(0079)                            || 
(0080)  CS-0x014  0x36602         || 	MOV R6, DELAY_COUNT_OUTER
(0081)                            || 
(0082)  CS-0x015  0x30300         || 	CMP R3, 0 ; is sweep_count == 0?
(0083)                            || 
(0084)  CS-0x016  0x0815A         || 	BREQ return_sweep ; if yes == > PC = reset_sweep
(0085)                            || 	;else
(0086)                            ||    
(0087)  CS-0x017  0x3640D         ||     MOV R4, SWEEP_COUNT ;	
(0088)                            || 
(0089)  CS-0x018  0x0241A         || 	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)
(0090)                            || 
(0091)  CS-0x019  0x04121         || 	MOV R1, R4 ; aruino[3:0] = 12-sweep count
(0092)                            || 		
(0093)  CS-0x01A  0x32296         || 	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
(0094)                            || 
(0095)  CS-0x01B  0x34169         || 	OUT R1, ARDUINO_PORT ; output arduino[3:0] to Arduino_ID
(0096)                            || 	
(0097)  CS-0x01C  0x00111         || 	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}
(0098)                            || 
(0099)  CS-0x01D  0x04009         || 	MOV R0, R1 ; 
(0100)                            || 
(0101)                            || 	; before storing arduino[7:0] got to concatenate its componets
(0102)                            || 
(0103)  CS-0x01E  0x04023         || 	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]
(0104)                            || 
(0105)                            ||    
(0106)                            || 	
(0107)                            || 
(0108)                     0x01F  || outer_loop:	
(0109)  CS-0x01F  0x36704         || 		MOV R7, DELAY_COUNT_MIDDLE
(0110)  CS-0x020  0x2010F         || 		AND R1, 15 
(0111)  CS-0x021  0x34169         || 		OUT R1, ARDUINO_PORT 
(0112)                            ||  	
(0113)  CS-0x022  0x36818  0x022  || middle_loop:	MOV R8, DELAY_COUNT_INNER
(0114)                            || 		
(0115)                     0x023  || inner_loop:	
(0116)                            || 
(0117)  CS-0x023  0x2C801         || 		SUB R8, 1
(0118)                            || 		 
(0119)  CS-0x024  0x0811B         || 		BRNE inner_loop
(0120)                            || 		
(0121)  CS-0x025  0x2C701         || 		SUB R7, 1
(0122)                            || 		
(0123)  CS-0x026  0x08113         || 		BRNE middle_loop
(0124)                            || 		
(0125)  CS-0x027  0x2C601         || 		SUB R6, 1
(0126)  CS-0x028  0x080FB         || 		BRNE outer_loop
(0127)                            || 		
(0128)  CS-0x029  0x2C301         || 		SUB R3, 1 ; sweep_count = sweep_count - 1
(0129)  CS-0x02A  0x080A3         || 		BRNE sweep_loop
(0130)                            || 
(0131)                            || 
(0132)  CS-0x02B  0x18002  0x02B  || return_sweep:		RET
(0133)                            || ; Tweaked Parmeter : R6,R7,R8
(0134)                            || ;
(0135)                            || ;--------------------------------------------------------------------
(0136)                            || 
(0137)                            || ;N_inner = 6
(0138)                            || ;N_middle = 4
(0139)                            || ;N_outer = 10
(0140)                            || 
(0141)                            || ;3 inner
(0142)                            || ;2 middle
(0143)                            || ;1 outer
(0144)                            || 
(0145)                            || 
(0146)                            || ;-----------------------------------------------------------
(0147)                            || 
(0148)                            || 
(0149)                            || ;--------------------------------------------------------------------
(0150)                            || ; bubble_sort - subroutine returns highest voltage data on at SCR[0]
(0151)                            || ;
(0152)                            || ; Tweaked parameters
(0153)                            || ; R9 - outer count
(0154)                            || ; R10 - inner count
(0155)                            || ; R11 - ADDR for inner count arr[i]
(0156)                            || ; R12 - ADDR for inner count + 1 ( arr[i+1[)
(0157)                            || ; R13 - temp
(0158)                            || ; R14  - used for input and outputting values (X)
(0159)                            || ; R15 - value fro arr[i] 
(0160)                            || ; R16 - value for arr[i+1]
(0161)                            || ;--------------------------------------------------------------------
(0162)                            || 
(0163)                     0x02C  || bubble_sort: 
(0164)                            || 
(0165)  CS-0x02C  0x3690C         || 	MOV R9, BUBBLE_OUTER_COUNT ; outer_count = 10
(0166)                            || 
(0167)                     0x02D  || bubble_outer_loop: 
(0168)                            || 
(0169)  CS-0x02D  0x36A0C         || 	MOV R10, BUBBLE_INNER_COUNT ; inner_count = 3
(0170)                            || 	
(0171)                     0x02E  || bubble_inner_loop:
(0172)                            || 	;get index of k and k+1 from 0->
(0173)                            || 
(0174)                            ||         ;ADDR_i = 4
(0175)  CS-0x02E  0x36B0C         || 	MOV R11, BUBBLE_INNER_COUNT
(0176)                            || 	;ADD R11, 1
(0177)                            || 	
(0178)                            || 	; ADDR_i+1 = 5
(0179)  CS-0x02F  0x36C0C         || 	MOV R12, BUBBLE_INNER_COUNT 
(0180)  CS-0x030  0x28C01         || 	ADD R12, 1
(0181)                            || 	
(0182)  CS-0x031  0x02B52         || 	SUB R11, R10 ; ADDR_i = 5 - count_inner
(0183)  CS-0x032  0x02C52         || 	SUB R12, R10 ; ADDR_i+1 = 6 - count_inner
(0184)                            || 	
(0185)                            || 	;get those values stored in the addres
(0186)  CS-0x033  0x04F5A         || 	LD R15, (R11) ; Y = arr[ADDR_i]
(0187)  CS-0x034  0x05062         || 	LD R16, (R12) ; Z = arr[ADDR_i+1]
(0188)                            || 
(0189)                            || 	;COMPARE now
(0190)                            || 
(0191)  CS-0x035  0x04F80         || 	CMP R15, R16 ; 
(0192)                            || 	
(0193)                            || ;if we get c = 1 that means arr[ADDR_i+1] is greater than or equal to arr[ADDR_i]
(0194)                            || ;so lets swap if this is the case
(0195)  CS-0x036  0x0A1E0         || 	BRCS swap 
(0196)                            || 
(0197)                     0x037  || decrement_count_inner: 	
(0198)  CS-0x037  0x2CA01         || 	SUB R10, 1 ; count_inner = count_inner -1 
(0199)  CS-0x038  0x08173         || 	BRNE bubble_inner_loop 
(0200)  CS-0x039  0x2C901         || 	SUB R9, 1 ;count_outer = count_outer - 1
(0201)                            || 	
(0202)  CS-0x03A  0x0816B         || 	BRNE bubble_outer_loop
(0203)  CS-0x03B  0x18002         || 	RET
(0204)                            || 	
(0205)                     0x03C  || swap:   ;swap(arr[ADD_i], arr[ADD_i+1]) 
(0206)  CS-0x03C  0x04D79         || 	MOV R13, R15 ; temp = arr[ADDR_i]
(0207)  CS-0x03D  0x04F81         || 	MOV R15, R16 ; arr[ADDR_i] = arr[ADDR_i+1]
(0208)  CS-0x03E  0x05069         || 	MOV R16, R13 ; arr[ADDR_i+1]  = temp
(0209)  CS-0x03F  0x05063         || 	ST R16, (R12)
(0210)  CS-0x040  0x04F5B         || 	ST R15, (R11)
(0211)  CS-0x041  0x081B8         || 	BRN decrement_count_inner 
(0212)                            || 
(0213)                            ||  		
(0214)                            || 	
(0215)                            || 	
(0216)                            || ;-----------------------------------------------------------------------------
(0217)                            || ; goBestLocation - takes a value arr[0] top of stack and goes to that position
(0218)                            || ;
(0219)                            || ; Tweaked parameters:
(0220)                            || ; R17 - best location[3:0]
(0221)                            || ; R31 - using for zero 
(0222)                            || ;--------------------------------------------------------------------
(0223)                            || 
(0224)                     0x042  || goBestLocation:
(0225)  CS-0x042  0x15F00         || 		WSP R31 ; reg that has value of 0
(0226)  CS-0x043  0x13102         || 		POP R17
(0227)  CS-0x044  0x2110F         || 	    AND R17, 15 ; masking so R17 outputs 0000 loc[3:0] 	
(0228)                     0x045  || goBestLocation_output:
(0229)  CS-0x045  0x35169         || 		OUT R17, ARDUINO_PORT
(0230)  CS-0x046  0x08228         || 	    BRN goBestLocation_output
(0231)                            || 		
(0232)                            || 		
(0233)                            || ;---------------------------------------------
(0234)                            || 
(0235)                            || ;-----------------------------------------------------------------------------
(0236)                            || ; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
(0237)                            || ;
(0238)                            || ; Tweaked parameters:
(0239)                            || ; R18 - {1,0,0,0,0,0,SW[1:0]} 
(0240)                            || ; - SW[7] tells us to go back from isr mode if high
(0241)                            || ;--------------------------------------------------------------------
(0242)                            || 
(0243)                     0x047  || ISR:
(0244)  CS-0x047  0x37200         || 	MOV R18, 0
(0245)  CS-0x048  0x33222         || 	IN R18, SWITCH_PORT
(0246)  CS-0x049  0x21283         || 	AND R18, 131  ;telling ardino we are in isr by setting sw[7] ==1 and setting sw[6:2] = 0 (masking)
(0247)  CS-0x04A  0x35269         || 	OUT R18, ARDUINO_PORT ; output that sw[7] high and the value inputted
(0248)  CS-0x04B  0x21280         || 	AND R18, 128 ; check if we need to return from isr
(0249)                            || 	
(0250)  CS-0x04C  0x31280         || 	CMP R18, 128
(0251)                            || 	
(0252)                            || 	;z == 1 if they are equal thus SW[7] is high
(0253)  CS-0x04D  0x0823B         || 	BRNE ISR
(0254)  CS-0x04E  0x1A003         || 	RETIE
(0255)                            || 	
(0256)                            || .CSEG
(0257)                       1023  || .ORG 0x3FF
(0258)  CS-0x3FF  0x08238         || BRN ISR
(0259)                            || 
(0260)                            || 	
(0261)                            || 
(0262)                            || 
(0263)                            || 
(0264)                            || 
(0265)                            || 
(0266)                            || 
(0267)                            || 
(0268)                            || 
(0269)                            || 
(0270)                            || 
(0271)                            || 
(0272)                            ||  





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
BUBBLE_INNER_LOOP 0x02E   (0171)  ||  0199 
BUBBLE_OUTER_LOOP 0x02D   (0167)  ||  0202 
BUBBLE_SORT    0x02C   (0163)  ||  0052 
DECREMENT_COUNT_INNER 0x037   (0197)  ||  0211 
GOBESTLOCATION 0x042   (0224)  ||  0053 
GOBESTLOCATION_OUTPUT 0x045   (0228)  ||  0230 
INNER_LOOP     0x023   (0115)  ||  0119 
ISR            0x047   (0243)  ||  0253 0258 
MAIN           0x00D   (0049)  ||  0055 
MIDDLE_LOOP    0x022   (0113)  ||  0123 
OUTER_LOOP     0x01F   (0108)  ||  0126 
RETURN_SWEEP   0x02B   (0132)  ||  0084 
SWAP           0x03C   (0205)  ||  0195 
SWEEP          0x013   (0074)  ||  0051 
SWEEP_LOOP     0x014   (0078)  ||  0129 


-- Directives: .BYTE
------------------------------------------------------------ 
ARDUINO_SWEEP  0x00D   (0020)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0025)  ||  0095 0111 0229 0247 
BUBBLE_INNER_COUNT 0x00C   (0037)  ||  0169 0175 0179 
BUBBLE_OUTER_COUNT 0x00C   (0036)  ||  0165 
DELAY_COUNT_INNER 0x018   (0031)  ||  0113 
DELAY_COUNT_MIDDLE 0x004   (0032)  ||  0109 
DELAY_COUNT_OUTER 0x002   (0033)  ||  0080 
LIGHT_PORT     0x096   (0024)  ||  0093 
SWEEP_COUNT    0x00D   (0041)  ||  0076 0087 
SWEEP_OUTPUT_DELAY 0x002   (0042)  ||  
SWITCH_PORT    0x022   (0026)  ||  0245 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
