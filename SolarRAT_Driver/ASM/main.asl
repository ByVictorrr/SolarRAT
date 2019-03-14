

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
(0033)                       012  || .EQU BUBBLE_OUTER_COUNT =  12 ;
(0034)                       012  || .EQU BUBBLE_INNER_COUNT = 12
(0035)                       013  || .EQU SWEEP_COUNT = 13
(0036)                            || ;-------------------------------------------------
(0037)                            || .CSEG
(0038)                       013  || .ORG 0x0D
(0039)                            || 
(0040)                            || 
(0041)                     0x00D  || main:
(0042)  CS-0x00D  0x1A000         || 	SEI ; set interupts
(0043)  CS-0x00E  0x08091         || 	CALL sweep
(0044)                            || 	;CALL delay
(0045)  CS-0x00F  0x081C9         || 	CALL bubble_sort
(0046)                            || 	;CALL delay
(0047)  CS-0x010  0x08279         || 	CALL goBestLocation
(0048)  CS-0x011  0x08068         || 	BRN main
(0049)                            || ;------------------------------------------------------------------------------------
(0050)                            || ; sweep  subroutine - goes through 12 degrees every 2s collects data and moves servo
(0051)                            || ;
(0052)                            || ; Tweaked Parameters :
(0053)                            || ;
(0054)                            || ; R0 - arduino[i][7:0]
(0055)                            || ; R1 - arduino[i][3:0]
(0056)                            || ; R2 - arduino[i][7:4]
(0057)                            || ; R3 - Variable for sweep_count
(0058)                            || ; R4 - Variable for 12 - sweep_count
(0059)                            || ; R5 - address of ith sweep position for arduino[i][7:0]
(0060)                            || ;
(0061)                            || 
(0062)                            || ; Return : Nothing
(0063)                            || ;
(0064)                            || ;--------------------------------------------------------------------
(0065)                            || 
(0066)                     0x012  || sweep:
(0067)  CS-0x012  0x3630D         || 	MOV R3, SWEEP_COUNT ;sweep_count = 12
(0068)  CS-0x013  0x3640D         || 	MOV R4, SWEEP_COUNT
(0069)                            || 
(0070)                     0x014  || sweep_loop:
(0071)                            || 
(0072)  CS-0x014  0x30300         || 	CMP R3, 0 ; is sweep_count == 0?
(0073)  CS-0x015  0x08102         || 	BREQ reset_sweep ; if yes == > PC = reset_sweep
(0074)                            || 	;else
(0075)                            ||    
(0076)  CS-0x016  0x3640D         ||     MOV R4, SWEEP_COUNT ;
(0077)                            || 
(0078)  CS-0x017  0x0241A         || 	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)
(0079)                            || 
(0080)  CS-0x018  0x04121         || 	MOV R1, R4 ; aruino[3:0] = 12-sweep count
(0081)                            || 
(0082)  CS-0x019  0x32296         || 	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
(0083)                            || 
(0084)                            || 	;CALL delay
(0085)                            || 
(0086)  CS-0x01A  0x34169         || 	OUT R1, ARDUINO_PORT ; output arduino[3:0] to Arduino_ID
(0087)                            || 
(0088)  CS-0x01B  0x00111         || 	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}
(0089)                            || 
(0090)  CS-0x01C  0x04009         || 	MOV R0, R1 ;
(0091)                            || 
(0092)                            || 	; before storing arduino[7:0] got to concatenate its componets
(0093)                            || 
(0094)  CS-0x01D  0x04023         || 	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]
(0095)                            || 
(0096)  CS-0x01E  0x2C301         ||         SUB R3, 1 ; sweep_count = sweep_count - 1
(0097)                            || 
(0098)  CS-0x01F  0x080A0         || 	BRN sweep_loop
(0099)                            || 
(0100)                            || 
(0101)                     0x020  || reset_sweep:
(0102)  CS-0x020  0x36100         || 	MOV R1, 0
(0103)  CS-0x021  0x34169         || 	OUT R1, ARDUINO_PORT
(0104)  CS-0x022  0x18002         || 	RET
(0105)                            || 
(0106)                            || 
(0107)                            || 
(0108)                            || ;------------------------------------------------------------------------------------
(0109)                            || ; delay subroutine
(0110)                            || ; Delays for a given input of paramets R6, R7, R8
(0111)                            || ; Parameters : R6 - outer count variable  (C1)
(0112)                            || ; 	       R7 - middle count variable  (C2)
(0113)                            || ;              R8 - inner count variable  (C3)
(0114)                            || ;
(0115)                            || ;
(0116)                            || ; Return : Nothing
(0117)                            || ; Tweaked Parmeter : R6,R7,R8
(0118)                            || ;
(0119)                            || ;--------------------------------------------------------------------
(0120)                            || 
(0121)                            || ;N_inner = 6
(0122)                            || ;N_middle = 4
(0123)                            || ;N_outer = 10
(0124)                            || 
(0125)                            || ;3 inner
(0126)                            || ;2 middle
(0127)                            || ;1 outer
(0128)                            || 
(0129)                            || 
(0130)  CS-0x023  0x366C9  0x023  || delay:	MOV R6, DELAY_COUNT_OUTER ; R1 = BUBBLE_OUTER_COUNT
(0131)                            || 
(0132)  CS-0x024  0x367B0  0x024  || outer_loop:	MOV R7, DELAY_COUNT_MIDDLE
(0133)                            || 
(0134)                            || 
(0135)  CS-0x025  0x368EC  0x025  || middle_loop:	MOV R8, DELAY_COUNT_INNER
(0136)                            || 
(0137)  CS-0x026  0x2C801  0x026  || inner_loop:	SUB R8, 1
(0138)  CS-0x027  0x18000         || 		CLC
(0139)  CS-0x028  0x18000         || 		CLC
(0140)  CS-0x029  0x18000         || 		CLC
(0141)  CS-0x02A  0x18000         || 		CLC
(0142)  CS-0x02B  0x08133         || 		BRNE inner_loop
(0143)                            || 
(0144)  CS-0x02C  0x18000         || 		CLC
(0145)  CS-0x02D  0x18000         || 		CLC
(0146)  CS-0x02E  0x0812B         || 		BRNE middle_loop
(0147)                            || 
(0148)  CS-0x02F  0x18000         || 		CLC
(0149)  CS-0x030  0x18000         || 		CLC
(0150)  CS-0x031  0x18000         || 		CLC
(0151)  CS-0x032  0x18000         || 		CLC
(0152)  CS-0x033  0x18000         || 		CLC
(0153)  CS-0x034  0x18000         || 		CLC
(0154)  CS-0x035  0x18000         || 		CLC
(0155)  CS-0x036  0x18000         || 		CLC
(0156)  CS-0x037  0x08123         || 		BRNE outer_loop
(0157)                            || 
(0158)  CS-0x038  0x18002  0x038  || return:		RET
(0159)                            || ;-----------------------------------------------------------
(0160)                            || 
(0161)                            || 
(0162)                            || ;--------------------------------------------------------------------
(0163)                            || ; bubble_sort - subroutine returns highest voltage data on at SCR[0]
(0164)                            || ;
(0165)                            || ; Tweaked parameters
(0166)                            || ; R9 - outer count
(0167)                            || ; R10 - inner count
(0168)                            || ; R11 - ADDR for inner count arr[i]
(0169)                            || ; R12 - ADDR for inner count + 1 ( arr[i+1[)
(0170)                            || ; R13 - temp
(0171)                            || ; R14  - used for input and outputting values (X)
(0172)                            || ; R15 - value fro arr[i]
(0173)                            || ; R16 - value for arr[i+1]
(0174)                            || ;--------------------------------------------------------------------
(0175)                            || 
(0176)                     0x039  || bubble_sort:
(0177)                            || 
(0178)  CS-0x039  0x3690C         || 	MOV R9, BUBBLE_OUTER_COUNT ; outer_count = 10
(0179)                            || 
(0180)                     0x03A  || bubble_outer_loop:
(0181)                            || 
(0182)  CS-0x03A  0x36A0C         || 	MOV R10, BUBBLE_INNER_COUNT ; inner_count = 3
(0183)                            || 
(0184)                     0x03B  || bubble_inner_loop:
(0185)                            || 	;get index of k and k+1 from 0->
(0186)                            || 
(0187)                            ||         ;ADDR_i = 4
(0188)  CS-0x03B  0x36B0C         || 	MOV R11, BUBBLE_INNER_COUNT
(0189)                            || 	;ADD R11, 1
(0190)                            || 
(0191)                            || 	; ADDR_i+1 = 5
(0192)  CS-0x03C  0x36C0C         || 	MOV R12, BUBBLE_INNER_COUNT
(0193)  CS-0x03D  0x28C01         || 	ADD R12, 1
(0194)                            || 
(0195)  CS-0x03E  0x02B52         || 	SUB R11, R10 ; ADDR_i = 5 - count_inner
(0196)  CS-0x03F  0x02C52         || 	SUB R12, R10 ; ADDR_i+1 = 6 - count_inner
(0197)                            || 
(0198)                            || 	;get those values stored in the addres
(0199)  CS-0x040  0x04F5A         || 	LD R15, (R11) ; Y = arr[ADDR_i]
(0200)  CS-0x041  0x05062         || 	LD R16, (R12) ; Z = arr[ADDR_i+1]
(0201)                            || 
(0202)                            || 	;COMPARE now
(0203)                            || 
(0204)  CS-0x042  0x04F80         || 	CMP R15, R16 ;
(0205)                            || 
(0206)                            || ;if we get c = 1 that means arr[ADDR_i+1] is greater than or equal to arr[ADDR_i]
(0207)                            || ;so lets swap if this is the case
(0208)  CS-0x043  0x0A248         || 	BRCS swap
(0209)                            || 
(0210)                     0x044  || decrement_count_inner:
(0211)  CS-0x044  0x2CA01         || 	SUB R10, 1 ; count_inner = count_inner -1
(0212)  CS-0x045  0x081DB         || 	BRNE bubble_inner_loop
(0213)  CS-0x046  0x2C901         || 	SUB R9, 1 ;count_outer = count_outer - 1
(0214)                            || 
(0215)  CS-0x047  0x081D3         || 	BRNE bubble_outer_loop
(0216)                            || 	;CALL delay
(0217)  CS-0x048  0x18002         || 	RET
(0218)                            || 
(0219)                     0x049  || swap:   ;swap(arr[ADD_i], arr[ADD_i+1])
(0220)  CS-0x049  0x04D79         || 	MOV R13, R15 ; temp = arr[ADDR_i]
(0221)  CS-0x04A  0x04F81         || 	MOV R15, R16 ; arr[ADDR_i] = arr[ADDR_i+1]
(0222)  CS-0x04B  0x05069         || 	MOV R16, R13 ; arr[ADDR_i+1]  = temp
(0223)  CS-0x04C  0x05063         || 	ST R16, (R12)
(0224)  CS-0x04D  0x04F5B         || 	ST R15, (R11)
(0225)  CS-0x04E  0x08220         || 	BRN decrement_count_inner
(0226)                            || 
(0227)                            || 
(0228)                            || 
(0229)                            || 
(0230)                            || ;-----------------------------------------------------------------------------
(0231)                            || ; goBestLocation - takes a value arr[0] top of stack and goes to that position
(0232)                            || ;
(0233)                            || ; Tweaked parameters:
(0234)                            || ; R17 - best location[3:0]
(0235)                            || ; R31 - using for zero
(0236)                            || ;--------------------------------------------------------------------
(0237)                            || 
(0238)                     0x04F  || goBestLocation:
(0239)  CS-0x04F  0x15F00         || 		WSP R31 ; reg that has value of 0
(0240)  CS-0x050  0x13102         || 		POP R17
(0241)  CS-0x051  0x2110F         || 		AND R17, 15
(0242)                     0x052  || stayBestLocation:
(0243)  CS-0x052  0x35169         || 		OUT R17, ARDUINO_PORT
(0244)  CS-0x053  0x08290         || 		BRN stayBestLocation
(0245)  CS-0x054  0x18002         || 		RET
(0246)                            || 
(0247)                            || 
(0248)                            || ;-----------------------------------------------------------------------------
(0249)                            || ; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
(0250)                            || ;
(0251)                            || ; Tweaked parameters:
(0252)                            || ; R18 - {1,0,0,0,0,0,SW[1:0]} 
(0253)                            || ; - SW[7] tells us to go back from isr mode if high
(0254)                            || ;--------------------------------------------------------------------
(0255)                            || 
(0256)                            || 
(0257)                            || 
(0258)                     0x055  || ISR: ;keeping it on the sw[7]
(0259)                            || 	
(0260)                            || 
(0261)  CS-0x055  0x332FF         || IN R18, SWITCH_PORT ;reading an input 
(0262)  CS-0x056  0x21283         || AND R18, 131 ;telling ardino we are in isr by setting sw[7] ==1 and setting sw[6:2] = 0 (masking)
(0263)  CS-0x057  0x05391         || MOV R19, R18 ;setting a number equal to R19 before masking
(0264)                            || 
(0265)                            || ;is sw[7] == 1
(0266)                            || 
(0267)  CS-0x058  0x21280         || AND R18, 128 ; SW[7] && 1
(0268)                            || 
(0269)  CS-0x059  0x31280         || CMP R18, 128  
(0270)                            || 
(0271)                            || ;is SW[7] === 1 go to ISR
(0272)  CS-0x05A  0x082AA         || BREQ ISR
(0273)                            || 
(0274)  CS-0x05B  0x1A003         || RETIE
(0275)                            || 
(0276)                            || 
(0277)                            || .CSEG
(0278)                       1023  || .ORG 0x3FF
(0279)  CS-0x3FF  0x082A8         || BRN ISR





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
BUBBLE_INNER_LOOP 0x03B   (0184)  ||  0212 
BUBBLE_OUTER_LOOP 0x03A   (0180)  ||  0215 
BUBBLE_SORT    0x039   (0176)  ||  0045 
DECREMENT_COUNT_INNER 0x044   (0210)  ||  0225 
DELAY          0x023   (0130)  ||  
GOBESTLOCATION 0x04F   (0238)  ||  0047 
INNER_LOOP     0x026   (0137)  ||  0142 
ISR            0x055   (0258)  ||  0272 0279 
MAIN           0x00D   (0041)  ||  0048 
MIDDLE_LOOP    0x025   (0135)  ||  0146 
OUTER_LOOP     0x024   (0132)  ||  0156 
RESET_SWEEP    0x020   (0101)  ||  0073 
RETURN         0x038   (0158)  ||  
STAYBESTLOCATION 0x052   (0242)  ||  0244 
SWAP           0x049   (0219)  ||  0208 
SWEEP          0x012   (0066)  ||  0043 
SWEEP_LOOP     0x014   (0070)  ||  0098 


-- Directives: .BYTE
------------------------------------------------------------ 
ARDUINO_SWEEP  0x00D   (0020)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0025)  ||  0086 0103 0243 
BUBBLE_INNER_COUNT 0x00C   (0034)  ||  0182 0188 0192 
BUBBLE_OUTER_COUNT 0x00C   (0033)  ||  0178 
DELAY_COUNT_INNER 0x0EC   (0030)  ||  0135 
DELAY_COUNT_MIDDLE 0x0B0   (0031)  ||  0132 
DELAY_COUNT_OUTER 0x0C9   (0032)  ||  0130 
LIGHT_PORT     0x096   (0024)  ||  0082 
SWEEP_COUNT    0x00D   (0035)  ||  0067 0068 0076 
SWITCH_PORT    0x0FF   (0026)  ||  0261 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
