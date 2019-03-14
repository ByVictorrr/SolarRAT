

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
(0041)                       002  || .EQU SWEEP_COUNT = 2
(0042)                       002  || .EQU SWEEP_OUTPUT_DELAY = 2
(0043)                            || ;-------------------------------------------------
(0044)                            || .CSEG
(0045)                       013  || .ORG 0x0D
(0046)                            || 
(0047)                            || 
(0048)                     0x00D  || main:
(0049)  CS-0x00D  0x1A000         || 	SEI ; set interupts
(0050)  CS-0x00E  0x08099         || 	CALL sweep
(0051)  CS-0x00F  0x08151         || 	CALL bubble_sort
(0052)  CS-0x010  0x08201         || 	CALL goBestLocation 
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
(0074)                            || 
(0075)  CS-0x013  0x36302         || 	MOV R3, SWEEP_COUNT
(0076)                            || 
(0077)                     0x014  || sweep_loop:
(0078)                            || 
(0079)  CS-0x014  0x36602         || 	MOV R6, DELAY_COUNT_OUTER
(0080)                            || 
(0081)  CS-0x015  0x30300         || 	CMP R3, 0 ; is sweep_count == 0?
(0082)                            || 
(0083)  CS-0x016  0x0814A         || 	BREQ return_sweep ; if yes == > PC = reset_sweep
(0084)                            || 	;else
(0085)                            ||    
(0086)  CS-0x017  0x36402         ||     MOV R4, SWEEP_COUNT ;	
(0087)                            || 
(0088)  CS-0x018  0x0241A         || 	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)
(0089)                            || 
(0090)  CS-0x019  0x04121         || 	MOV R1, R4 ; aruino[3:0] = 12-sweep count
(0091)                            || 		
(0092)  CS-0x01A  0x32296         || 	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
(0093)                            || 	
(0094)  CS-0x01B  0x00111         || 	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}
(0095)                            || 
(0096)  CS-0x01C  0x04009         || 	MOV R0, R1 ; 
(0097)                            || 
(0098)                            || 	; before storing arduino[7:0] got to concatenate its componets
(0099)                            || 
(0100)  CS-0x01D  0x04023         || 	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]
(0101)                            || 
(0102)                            ||    
(0103)                     0x01E  || outer_loop:	
(0104)  CS-0x01E  0x36704         || 		MOV R7, DELAY_COUNT_MIDDLE
(0105)  CS-0x01F  0x34169         || 		OUT R1, ARDUINO_PORT 
(0106)                            ||  	
(0107)  CS-0x020  0x36818  0x020  || middle_loop:	MOV R8, DELAY_COUNT_INNER
(0108)                            || 		
(0109)                     0x021  || inner_loop:	
(0110)                            || 
(0111)  CS-0x021  0x2C801         || 		SUB R8, 1
(0112)                            || 		 
(0113)  CS-0x022  0x0810B         || 		BRNE inner_loop
(0114)                            || 		
(0115)  CS-0x023  0x2C701         || 		SUB R7, 1
(0116)                            || 		
(0117)  CS-0x024  0x08103         || 		BRNE middle_loop
(0118)                            || 		
(0119)  CS-0x025  0x2C601         || 		SUB R6, 1
(0120)  CS-0x026  0x080F3         || 		BRNE outer_loop
(0121)                            || 		
(0122)  CS-0x027  0x2C301         || 		SUB R3, 1 ; sweep_count = sweep_count - 1
(0123)  CS-0x028  0x080A3         || 		BRNE sweep_loop
(0124)                            || 
(0125)                            || 
(0126)  CS-0x029  0x18002  0x029  || return_sweep:		RET
(0127)                            || 
(0128)                            || 
(0129)                            || 
(0130)                            || 
(0131)                            || ;--------------------------------------------------------------------
(0132)                            || ; bubble_sort - subroutine returns highest voltage data on at SCR[0]
(0133)                            || ;
(0134)                            || ; Tweaked parameters
(0135)                            || ; R9 - outer count
(0136)                            || ; R10 - inner count
(0137)                            || ; R11 - ADDR for inner count arr[i]
(0138)                            || ; R12 - ADDR for inner count + 1 ( arr[i+1[)
(0139)                            || ; R13 - temp
(0140)                            || ; R14  - used for input and outputting values (X)
(0141)                            || ; R15 - value fro arr[i] 
(0142)                            || ; R16 - value for arr[i+1]
(0143)                            || ;--------------------------------------------------------------------
(0144)                            || 
(0145)                     0x02A  || bubble_sort: 
(0146)                            || 
(0147)  CS-0x02A  0x3690C         || 	MOV R9, BUBBLE_OUTER_COUNT ; outer_count = 10
(0148)                            || 
(0149)                     0x02B  || bubble_outer_loop: 
(0150)                            || 
(0151)  CS-0x02B  0x36A0C         || 	MOV R10, BUBBLE_INNER_COUNT ; inner_count = 3
(0152)                            || 	
(0153)                     0x02C  || bubble_inner_loop:
(0154)                            || 	;get index of k and k+1 from 0->
(0155)                            || 
(0156)                            ||         ;ADDR_i = 4
(0157)  CS-0x02C  0x36B0C         || 	MOV R11, BUBBLE_INNER_COUNT
(0158)                            || 	;ADD R11, 1
(0159)                            || 	
(0160)                            || 	; ADDR_i+1 = 5
(0161)  CS-0x02D  0x36C0C         || 	MOV R12, BUBBLE_INNER_COUNT 
(0162)  CS-0x02E  0x28C01         || 	ADD R12, 1
(0163)                            || 	
(0164)  CS-0x02F  0x02B52         || 	SUB R11, R10 ; ADDR_i = 5 - count_inner
(0165)  CS-0x030  0x02C52         || 	SUB R12, R10 ; ADDR_i+1 = 6 - count_inner
(0166)                            || 	
(0167)                            || 	;get those values stored in the addres
(0168)  CS-0x031  0x04F5A         || 	LD R15, (R11) ; Y = arr[ADDR_i]
(0169)  CS-0x032  0x05062         || 	LD R16, (R12) ; Z = arr[ADDR_i+1]
(0170)                            || 
(0171)                            || 	;COMPARE now
(0172)                            || 
(0173)  CS-0x033  0x04F80         || 	CMP R15, R16 ; 
(0174)                            || 	
(0175)                            || ;if we get c = 1 that means arr[ADDR_i+1] is greater than or equal to arr[ADDR_i]
(0176)                            || ;so lets swap if this is the case
(0177)  CS-0x034  0x0A1D0         || 	BRCS swap 
(0178)                            || 
(0179)                     0x035  || decrement_count_inner: 	
(0180)  CS-0x035  0x2CA01         || 	SUB R10, 1 ; count_inner = count_inner -1 
(0181)  CS-0x036  0x08163         || 	BRNE bubble_inner_loop 
(0182)  CS-0x037  0x2C901         || 	SUB R9, 1 ;count_outer = count_outer - 1
(0183)                            || 	
(0184)  CS-0x038  0x0815B         || 	BRNE bubble_outer_loop
(0185)  CS-0x039  0x18002         || 	RET
(0186)                            || 	
(0187)                     0x03A  || swap:   ;swap(arr[ADD_i], arr[ADD_i+1]) 
(0188)  CS-0x03A  0x04D79         || 	MOV R13, R15 ; temp = arr[ADDR_i]
(0189)  CS-0x03B  0x04F81         || 	MOV R15, R16 ; arr[ADDR_i] = arr[ADDR_i+1]
(0190)  CS-0x03C  0x05069         || 	MOV R16, R13 ; arr[ADDR_i+1]  = temp
(0191)  CS-0x03D  0x05063         || 	ST R16, (R12)
(0192)  CS-0x03E  0x04F5B         || 	ST R15, (R11)
(0193)  CS-0x03F  0x081A8         || 	BRN decrement_count_inner 
(0194)                            || 
(0195)                            ||  		
(0196)                            || 	
(0197)                            || 	
(0198)                            || ;-----------------------------------------------------------------------------
(0199)                            || ; goBestLocation - takes a value arr[0] top of stack and goes to that position
(0200)                            || ;
(0201)                            || ; Tweaked parameters:
(0202)                            || ; R17 - best location[3:0]
(0203)                            || ; R31 - using for zero 
(0204)                            || ;--------------------------------------------------------------------
(0205)                            || 
(0206)                     0x040  || goBestLocation:
(0207)  CS-0x040  0x15F00         || 		WSP R31 ; reg that has value of 0
(0208)  CS-0x041  0x13102         || 		POP R17
(0209)  CS-0x042  0x2110F         || 	    AND R17, 15 ; masking so R17 outputs 0000 loc[3:0] 	
(0210)                     0x043  || goBestLocation_output:
(0211)  CS-0x043  0x35169         || 		OUT R17, ARDUINO_PORT
(0212)  CS-0x044  0x08218         || 	    BRN goBestLocation_output
(0213)                            || 		
(0214)                            || 		
(0215)                            || ;---------------------------------------------
(0216)                            || 
(0217)                            || ;-----------------------------------------------------------------------------
(0218)                            || ; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
(0219)                            || ;
(0220)                            || ; Tweaked parameters:
(0221)                            || ; R18 - {1,0,0,0,0,0,SW[1:0]} 
(0222)                            || ; - SW[7] tells us to go back from isr mode if high
(0223)                            || ;--------------------------------------------------------------------
(0224)                            || 
(0225)                     0x045  || ISR:
(0226)  CS-0x045  0x37200         || 	MOV R18, 0
(0227)  CS-0x046  0x33222         || 	IN R18, SWITCH_PORT
(0228)  CS-0x047  0x21283         || 	AND R18, 131  ;telling ardino we are in isr by setting sw[7] ==1 and setting sw[6:2] = 0 (masking)
(0229)  CS-0x048  0x35269         || 	OUT R18, ARDUINO_PORT ; output that sw[7] high and the value inputted
(0230)                            || 	 
(0231)                            || 
(0232)  CS-0x049  0x21280         || 	AND R18, 128 ; check if we need to return from isr
(0233)                            || 	
(0234)  CS-0x04A  0x31280         || 	CMP R18, 128
(0235)                            || 	
(0236)                            || 	;z == 1 if they are equal thus SW[7] is high
(0237)  CS-0x04B  0x0822B         || 	BRNE ISR
(0238)  CS-0x04C  0x1A003         || 	RETIE
(0239)                            || 	
(0240)                            || .CSEG
(0241)                       1023  || .ORG 0x3FF
(0242)  CS-0x3FF  0x08228         || BRN ISR
(0243)                            || 
(0244)                            || 
(0245)                            || 
(0246)                            || 
(0247)                            || 
(0248)                            || 
(0249)                            ||  





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
BUBBLE_INNER_LOOP 0x02C   (0153)  ||  0181 
BUBBLE_OUTER_LOOP 0x02B   (0149)  ||  0184 
BUBBLE_SORT    0x02A   (0145)  ||  0051 
DECREMENT_COUNT_INNER 0x035   (0179)  ||  0193 
GOBESTLOCATION 0x040   (0206)  ||  0052 
GOBESTLOCATION_OUTPUT 0x043   (0210)  ||  0212 
INNER_LOOP     0x021   (0109)  ||  0113 
ISR            0x045   (0225)  ||  0237 0242 
MAIN           0x00D   (0048)  ||  0054 
MIDDLE_LOOP    0x020   (0107)  ||  0117 
OUTER_LOOP     0x01E   (0103)  ||  0120 
RETURN_SWEEP   0x029   (0126)  ||  0083 
SWAP           0x03A   (0187)  ||  0177 
SWEEP          0x013   (0073)  ||  0050 
SWEEP_LOOP     0x014   (0077)  ||  0123 


-- Directives: .BYTE
------------------------------------------------------------ 
ARDUINO_SWEEP  0x00D   (0020)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0025)  ||  0105 0211 0229 
BUBBLE_INNER_COUNT 0x00C   (0037)  ||  0151 0157 0161 
BUBBLE_OUTER_COUNT 0x00C   (0036)  ||  0147 
DELAY_COUNT_INNER 0x018   (0031)  ||  0107 
DELAY_COUNT_MIDDLE 0x004   (0032)  ||  0104 
DELAY_COUNT_OUTER 0x002   (0033)  ||  0079 
LIGHT_PORT     0x096   (0024)  ||  0092 
SWEEP_COUNT    0x002   (0041)  ||  0075 0086 
SWEEP_OUTPUT_DELAY 0x002   (0042)  ||  
SWITCH_PORT    0x022   (0026)  ||  0227 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
