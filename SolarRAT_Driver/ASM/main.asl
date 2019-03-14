

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
(0026)                       255  || .EQU SWITCH_PORT = 0xFF
(0027)                            || ;--------------------------------------------
(0028)                            || 
(0029)                            || ;----CONSTANT DECLARATION-------------------
(0030)                       236  || .EQU DELAY_COUNT_INNER = 236
(0031)                       176  || .EQU DELAY_COUNT_MIDDLE = 176
(0032)                       201  || .EQU DELAY_COUNT_OUTER = 201
(0033)                       013  || .EQU BUBBLE_OUTER_COUNT =  13 ; 
(0034)                       013  || .EQU BUBBLE_INNER_COUNT = 13
(0035)                       013  || .EQU SWEEP_COUNT = 13
(0036)                       150  || .EQU MAIN_COUNT = 150
(0037)                            || ;-------------------------------------------------
(0038)                            || .CSEG
(0039)                       013  || .ORG 0x0D
(0040)                            || 
(0041)  CS-0x00D  0x37B96         || MOV R27, MAIN_COUNT
(0042)                            || 
(0043)                     0x00E  || main:
(0044)  CS-0x00E  0x1A000         || 	SEI ; set interupts
(0045)  CS-0x00F  0x080B1         || 	CALL sweep
(0046)  CS-0x010  0x08141         || 	CALL delay
(0047)  CS-0x011  0x081F1         || 	CALL bubble_sort
(0048)  CS-0x012  0x082A1         || 	CALL goBestLocation 
(0049)  CS-0x013  0x08141         || 	CALL delay
(0050)  CS-0x014  0x15F00         || 	WSP R31 ; have stack pointer go back to 0
(0051)  CS-0x015  0x08070         || 	BRN main
(0052)                            || 
(0053)                            || ;------------------------------------------------------------------------------------
(0054)                            || ; sweep  subroutine - goes through 12 degrees every 2s collects data and moves servo
(0055)                            || ;
(0056)                            || ; Tweaked Parameters : 
(0057)                            || ;	      
(0058)                            || ; R0 - arduino[i][7:0]
(0059)                            || ; R1 - arduino[i][3:0]
(0060)                            || ; R2 - arduino[i][7:4]
(0061)                            || ; R3 - Variable for sweep_count 
(0062)                            || ; R4 - Variable for 12 - sweep_count
(0063)                            || ; R5 - address of ith sweep position for arduino[i][7:0]
(0064)                            || ; 
(0065)                            || 	
(0066)                            || ; Return : Nothing 
(0067)                            || ;
(0068)                            || ;--------------------------------------------------------------------
(0069)                            || 
(0070)                     0x016  || sweep:
(0071)  CS-0x016  0x3630D         || 	MOV R3, SWEEP_COUNT ;sweep_count = 12
(0072)  CS-0x017  0x3640D         || 	MOV R4, SWEEP_COUNT  
(0073)                            || 
(0074)                     0x018  || sweep_loop:
(0075)                            || 
(0076)  CS-0x018  0x30300         || 	CMP R3, 0 ; is sweep_count == 0?
(0077)  CS-0x019  0x0812A         || 	BREQ reset_sweep ; if yes == > PC = reset_sweep
(0078)                            || 	;else
(0079)  CS-0x01A  0x3640D         ||         MOV R4, SWEEP_COUNT ;	
(0080)                            || 
(0081)  CS-0x01B  0x0241A         || 	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)
(0082)                            || 
(0083)  CS-0x01C  0x04121         || 	MOV R1, R4 ; aruino[3:0] = 12-sweep count
(0084)                            || 
(0085)  CS-0x01D  0x32296         || 	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
(0086)                            || 
(0087)  CS-0x01E  0x08141         || 	CALL delay
(0088)                            || 
(0089)  CS-0x01F  0x34169         || 	OUT R1, ARDUINO_PORT ; output arduino[3:0] to Arduino_ID
(0090)                            || 	
(0091)  CS-0x020  0x00111         || 	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}
(0092)                            || 
(0093)  CS-0x021  0x04009         || 	MOV R0, R1 ; 
(0094)                            || 
(0095)                            || 	; before storing arduino[7:0] got to concatenate its componets
(0096)                            || 
(0097)  CS-0x022  0x04023         || 	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]
(0098)                            || 
(0099)  CS-0x023  0x2C301         ||         SUB R3, 1 ; sweep_count = sweep_count - 1
(0100)                            || 	
(0101)  CS-0x024  0x080C0         || 	BRN sweep_loop 
(0102)                            || 
(0103)                            || 
(0104)                     0x025  || reset_sweep:
(0105)  CS-0x025  0x36100         || 	MOV R1, 0
(0106)  CS-0x026  0x34169         || 	OUT R1, ARDUINO_PORT
(0107)  CS-0x027  0x18002         || 	RET
(0108)                            || 
(0109)                            || 
(0110)                            || 
(0111)                            || ;------------------------------------------------------------------------------------
(0112)                            || ; delay subroutine
(0113)                            || ; Delays for a given input of paramets R6, R7, R8
(0114)                            || ; Parameters : R6 - outer count variable  (C1)
(0115)                            || ; 	       R7 - middle count variable  (C2)
(0116)                            || ;              R8 - inner count variable  (C3)
(0117)                            || ;	      
(0118)                            || ;	
(0119)                            || ; Return : Nothing 
(0120)                            || ; Tweaked Parmeter : R6,R7,R8
(0121)                            || ;
(0122)                            || ;--------------------------------------------------------------------
(0123)                            || 
(0124)                            || ;N_inner = 6
(0125)                            || ;N_middle = 4
(0126)                            || ;N_outer = 10
(0127)                            || 
(0128)                            || ;3 inner
(0129)                            || ;2 middle
(0130)                            || ;1 outer
(0131)                            || 
(0132)                            || 
(0133)  CS-0x028  0x366C9  0x028  || delay:	MOV R6, DELAY_COUNT_OUTER ; R1 = BUBBLE_OUTER_COUNT
(0134)                            || 
(0135)  CS-0x029  0x367B0  0x029  || outer_loop:	MOV R7, DELAY_COUNT_MIDDLE
(0136)                            || 				
(0137)                            ||  	
(0138)  CS-0x02A  0x368EC  0x02A  || middle_loop:	MOV R8, DELAY_COUNT_INNER
(0139)                            || 		
(0140)  CS-0x02B  0x2C801  0x02B  || inner_loop:	SUB R8, 1 
(0141)  CS-0x02C  0x18000         || 		CLC
(0142)  CS-0x02D  0x18000         || 		CLC
(0143)  CS-0x02E  0x18000         || 		CLC
(0144)  CS-0x02F  0x18000         || 		CLC
(0145)  CS-0x030  0x0815B         || 		BRNE inner_loop
(0146)                            || 		
(0147)  CS-0x031  0x18000         || 		CLC
(0148)  CS-0x032  0x18000         || 		CLC
(0149)  CS-0x033  0x08153         || 		BRNE middle_loop
(0150)                            || 		
(0151)  CS-0x034  0x18000         || 		CLC
(0152)  CS-0x035  0x18000         || 		CLC
(0153)  CS-0x036  0x18000         || 		CLC
(0154)  CS-0x037  0x18000         || 		CLC
(0155)  CS-0x038  0x18000         || 		CLC
(0156)  CS-0x039  0x18000         || 		CLC
(0157)  CS-0x03A  0x18000         || 		CLC
(0158)  CS-0x03B  0x18000         || 		CLC
(0159)  CS-0x03C  0x0814B         || 		BRNE outer_loop
(0160)                            || 		
(0161)  CS-0x03D  0x18002  0x03D  || return:		RET
(0162)                            || ;-----------------------------------------------------------
(0163)                            || 
(0164)                            || 
(0165)                            || ;--------------------------------------------------------------------
(0166)                            || ; bubble_sort - subroutine returns highest voltage data on at SCR[0]
(0167)                            || ;
(0168)                            || ; Tweaked parameters
(0169)                            || ; R9 - outer count
(0170)                            || ; R10 - inner count
(0171)                            || ; R11 - ADDR for inner count arr[i]
(0172)                            || ; R12 - ADDR for inner count + 1 ( arr[i+1[)
(0173)                            || ; R13 - temp
(0174)                            || ; R14  - used for input and outputting values (X)
(0175)                            || ; R15 - value fro arr[i] 
(0176)                            || ; R16 - value for arr[i+1]
(0177)                            || ;--------------------------------------------------------------------
(0178)                            || 
(0179)                     0x03E  || bubble_sort: 
(0180)                            || 
(0181)  CS-0x03E  0x3690D         || 	MOV R9, BUBBLE_OUTER_COUNT ; outer_count = 10
(0182)                            || 
(0183)                     0x03F  || bubble_outer_loop: 
(0184)                            || 
(0185)  CS-0x03F  0x36A0D         || 	MOV R10, BUBBLE_INNER_COUNT ; inner_count = 3
(0186)                            || 	
(0187)                     0x040  || bubble_inner_loop:
(0188)                            || 	;get index of k and k+1 from 0->
(0189)                            || 
(0190)                            ||         ;ADDR_i = 4
(0191)  CS-0x040  0x36B0D         || 	MOV R11, BUBBLE_INNER_COUNT
(0192)                            || 	;ADD R11, 1
(0193)                            || 	
(0194)                            || 	; ADDR_i+1 = 5
(0195)  CS-0x041  0x36C0D         || 	MOV R12, BUBBLE_INNER_COUNT 
(0196)  CS-0x042  0x28C01         || 	ADD R12, 1
(0197)                            || 	
(0198)  CS-0x043  0x02B52         || 	SUB R11, R10 ; ADDR_i = 5 - count_inner
(0199)  CS-0x044  0x02C52         || 	SUB R12, R10 ; ADDR_i+1 = 6 - count_inner
(0200)                            || 	
(0201)                            || 	;get those values stored in the addres
(0202)  CS-0x045  0x04F5A         || 	LD R15, (R11) ; Y = arr[ADDR_i]
(0203)  CS-0x046  0x05062         || 	LD R16, (R12) ; Z = arr[ADDR_i+1]
(0204)                            || 
(0205)                            || 	;COMPARE now
(0206)                            || 
(0207)  CS-0x047  0x04F80         || 	CMP R15, R16 ; 
(0208)                            || 	
(0209)                            || ;if we get c = 1 that means arr[ADDR_i+1] is greater than or equal to arr[ADDR_i]
(0210)                            || ;so lets swap if this is the case
(0211)  CS-0x048  0x0A270         || 	BRCS swap 
(0212)                            || 
(0213)                     0x049  || decrement_count_inner: 	
(0214)  CS-0x049  0x2CA01         || 	SUB R10, 1 ; count_inner = count_inner -1 
(0215)  CS-0x04A  0x08203         || 	BRNE bubble_inner_loop 
(0216)  CS-0x04B  0x2C901         || 	SUB R9, 1 ;count_outer = count_outer - 1
(0217)                            || 	
(0218)  CS-0x04C  0x081FB         || 	BRNE bubble_outer_loop
(0219)  CS-0x04D  0x18002         || 	RET
(0220)                            || 	
(0221)                     0x04E  || swap:   ;swap(arr[ADD_i], arr[ADD_i+1]) 
(0222)  CS-0x04E  0x04D79         || 	MOV R13, R15 ; temp = arr[ADDR_i]
(0223)  CS-0x04F  0x04F81         || 	MOV R15, R16 ; arr[ADDR_i] = arr[ADDR_i+1]
(0224)  CS-0x050  0x05069         || 	MOV R16, R13 ; arr[ADDR_i+1]  = temp
(0225)  CS-0x051  0x05063         || 	ST R16, (R12)
(0226)  CS-0x052  0x04F5B         || 	ST R15, (R11)
(0227)  CS-0x053  0x08248         || 	BRN decrement_count_inner 
(0228)                            || 
(0229)                            ||  		
(0230)                            || 	
(0231)                            || 	
(0232)                            || ;-----------------------------------------------------------------------------
(0233)                            || ; goBestLocation - takes a value arr[0] top of stack and goes to that position
(0234)                            || ;
(0235)                            || ; Tweaked parameters:
(0236)                            || ; R17 - best location[3:0]
(0237)                            || ; R31 - using for zero 
(0238)                            || ;--------------------------------------------------------------------
(0239)                            || 
(0240)                     0x054  || goBestLocation:
(0241)  CS-0x054  0x15F00         || 		WSP R31 ; reg that has value of 0
(0242)  CS-0x055  0x13102         || 		POP R17
(0243)                     0x056  || stay:
(0244)                            || 		
(0245)  CS-0x056  0x35169         || 		OUT R17, ARDUINO_PORT
(0246)  CS-0x057  0x08141         || 		CALL delay
(0247)  CS-0x058  0x31B01         || 		CMP R27, 1 	
(0248)  CS-0x059  0x082B2         || 		BREQ stay
(0249)  CS-0x05A  0x18002         || 		RET 
(0250)                            || 		
(0251)                            || 		
(0252)                            || ;---------------------------------------------
(0253)                            || 
(0254)                            || ;-----------------------------------------------------------------------------
(0255)                            || ; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
(0256)                            || ;
(0257)                            || ; Tweaked parameters:
(0258)                            || ; R18 - {1,0,0,0,0,SW[2],SW[1:0]} 
(0259)                            || ; - first bit tells arduino isr mode
(0260)                            || ; - SW[2] tells us to go back from isr mode if high
(0261)                            || ;--------------------------------------------------------------------
(0262)                            || 
(0263)                     0x05B  || ISR:
(0264)  CS-0x05B  0x332FF         || 	IN R18, SWITCH_PORT
(0265)  CS-0x05C  0x21283         || 	AND R18, 131
(0266)  CS-0x05D  0x35269         || 	OUT R18, ARDUINO_PORT
(0267)  CS-0x05E  0x21280         || 	AND R18, 128 ; check if we need to return from isr	
(0268)  CS-0x05F  0x31280         || 	CMP R18, 128
(0269)                            || 	
(0270)                            || 	;z == 1 if they are equal thus SW[2] is high
(0271)  CS-0x060  0x082DA         || 	BREQ ISR
(0272)                            || 
(0273)  CS-0x061  0x1A003         || 	RETIE
(0274)                            || 	
(0275)                            || .CSEG
(0276)                       1023  || .ORG 0x3FF
(0277)  CS-0x3FF  0x082D8         || BRN ISR





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
BUBBLE_INNER_LOOP 0x040   (0187)  ||  0215 
BUBBLE_OUTER_LOOP 0x03F   (0183)  ||  0218 
BUBBLE_SORT    0x03E   (0179)  ||  0047 
DECREMENT_COUNT_INNER 0x049   (0213)  ||  0227 
DELAY          0x028   (0133)  ||  0046 0049 0087 0246 
GOBESTLOCATION 0x054   (0240)  ||  0048 
INNER_LOOP     0x02B   (0140)  ||  0145 
ISR            0x05B   (0263)  ||  0271 0277 
MAIN           0x00E   (0043)  ||  0051 
MIDDLE_LOOP    0x02A   (0138)  ||  0149 
OUTER_LOOP     0x029   (0135)  ||  0159 
RESET_SWEEP    0x025   (0104)  ||  0077 
RETURN         0x03D   (0161)  ||  
STAY           0x056   (0243)  ||  0248 
SWAP           0x04E   (0221)  ||  0211 
SWEEP          0x016   (0070)  ||  0045 
SWEEP_LOOP     0x018   (0074)  ||  0101 


-- Directives: .BYTE
------------------------------------------------------------ 
ARDUINO_SWEEP  0x00D   (0020)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0025)  ||  0089 0106 0245 0266 
BUBBLE_INNER_COUNT 0x00D   (0034)  ||  0185 0191 0195 
BUBBLE_OUTER_COUNT 0x00D   (0033)  ||  0181 
DELAY_COUNT_INNER 0x0EC   (0030)  ||  0138 
DELAY_COUNT_MIDDLE 0x0B0   (0031)  ||  0135 
DELAY_COUNT_OUTER 0x0C9   (0032)  ||  0133 
LIGHT_PORT     0x096   (0024)  ||  0085 
MAIN_COUNT     0x096   (0036)  ||  0041 
SWEEP_COUNT    0x00D   (0035)  ||  0071 0072 0079 
SWITCH_PORT    0x0FF   (0026)  ||  0264 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
