

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
(0036)                       255  || .EQU MAIN_COUNT = 255
(0037)                            || ;-------------------------------------------------
(0038)                            || .CSEG
(0039)                       013  || .ORG 0x0D
(0040)                            || 
(0041)  CS-0x00D  0x37EFF         || MOV R30, MAIN_COUNT
(0042)                            || 
(0043)                     0x00E  || main_main:
(0044)  CS-0x00E  0x37DFF         || MOV R29, MAIN_COUNT
(0045)                            || 
(0046)                     0x00F  || main:
(0047)  CS-0x00F  0x1A000         || 	SEI ; set interupts
(0048)  CS-0x010  0x080C9         || 	CALL sweep
(0049)  CS-0x011  0x08151         || 	CALL delay
(0050)  CS-0x012  0x08201         || 	CALL bubble_sort
(0051)  CS-0x013  0x08151         || 	CALL delay
(0052)  CS-0x014  0x082B1         || 	CALL goBestLocation
(0053)  CS-0x015  0x2DD01         || 	SUB R29, 1
(0054)  CS-0x016  0x0807A         || 	BREQ main
(0055)  CS-0x017  0x2DE01         || 	SUB R30, 1
(0056)  CS-0x018  0x08070         || 	BRN main_main
(0057)                            || 
(0058)                            || ;------------------------------------------------------------------------------------
(0059)                            || ; sweep  subroutine - goes through 12 degrees every 2s collects data and moves servo
(0060)                            || ;
(0061)                            || ; Tweaked Parameters :
(0062)                            || ;
(0063)                            || ; R0 - arduino[i][7:0]
(0064)                            || ; R1 - arduino[i][3:0]
(0065)                            || ; R2 - arduino[i][7:4]
(0066)                            || ; R3 - Variable for sweep_count
(0067)                            || ; R4 - Variable for 12 - sweep_count
(0068)                            || ; R5 - address of ith sweep position for arduino[i][7:0]
(0069)                            || ;
(0070)                            || 
(0071)                            || ; Return : Nothing
(0072)                            || ;
(0073)                            || ;--------------------------------------------------------------------
(0074)                            || 
(0075)                     0x019  || sweep:
(0076)  CS-0x019  0x3630D         || 	MOV R3, SWEEP_COUNT ;sweep_count = 12
(0077)  CS-0x01A  0x3640D         || 	MOV R4, SWEEP_COUNT
(0078)                            || 
(0079)                     0x01B  || sweep_loop:
(0080)                            || 
(0081)  CS-0x01B  0x30300         || 	CMP R3, 0 ; is sweep_count == 0?
(0082)  CS-0x01C  0x0813A         || 	BREQ reset_sweep ; if yes == > PC = reset_sweep
(0083)                            || 	;else
(0084)  CS-0x01D  0x3640D         ||         MOV R4, SWEEP_COUNT ;
(0085)                            || 
(0086)  CS-0x01E  0x0241A         || 	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)
(0087)                            || 
(0088)  CS-0x01F  0x04121         || 	MOV R1, R4 ; aruino[3:0] = 12-sweep count
(0089)                            || 
(0090)  CS-0x020  0x32296         || 	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
(0091)                            || 
(0092)                            || 	;CALL delay
(0093)                            || 
(0094)  CS-0x021  0x34169         || 	OUT R1, ARDUINO_PORT ; output arduino[3:0] to Arduino_ID
(0095)                            || 
(0096)  CS-0x022  0x00111         || 	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}
(0097)                            || 
(0098)  CS-0x023  0x04009         || 	MOV R0, R1 ;
(0099)                            || 
(0100)                            || 	; before storing arduino[7:0] got to concatenate its componets
(0101)                            || 
(0102)  CS-0x024  0x04023         || 	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]
(0103)                            || 
(0104)  CS-0x025  0x2C301         ||         SUB R3, 1 ; sweep_count = sweep_count - 1
(0105)                            || 
(0106)  CS-0x026  0x080D8         || 	BRN sweep_loop
(0107)                            || 
(0108)                            || 
(0109)                     0x027  || reset_sweep:
(0110)  CS-0x027  0x36100         || 	MOV R1, 0
(0111)  CS-0x028  0x34169         || 	OUT R1, ARDUINO_PORT
(0112)  CS-0x029  0x18002         || 	RET
(0113)                            || 
(0114)                            || 
(0115)                            || 
(0116)                            || ;------------------------------------------------------------------------------------
(0117)                            || ; delay subroutine
(0118)                            || ; Delays for a given input of paramets R6, R7, R8
(0119)                            || ; Parameters : R6 - outer count variable  (C1)
(0120)                            || ; 	       R7 - middle count variable  (C2)
(0121)                            || ;              R8 - inner count variable  (C3)
(0122)                            || ;
(0123)                            || ;
(0124)                            || ; Return : Nothing
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
(0138)  CS-0x02A  0x366C9  0x02A  || delay:	MOV R6, DELAY_COUNT_OUTER ; R1 = BUBBLE_OUTER_COUNT
(0139)                            || 
(0140)  CS-0x02B  0x367B0  0x02B  || outer_loop:	MOV R7, DELAY_COUNT_MIDDLE
(0141)                            || 
(0142)                            || 
(0143)  CS-0x02C  0x368EC  0x02C  || middle_loop:	MOV R8, DELAY_COUNT_INNER
(0144)                            || 
(0145)  CS-0x02D  0x2C801  0x02D  || inner_loop:	SUB R8, 1
(0146)  CS-0x02E  0x18000         || 		CLC
(0147)  CS-0x02F  0x18000         || 		CLC
(0148)  CS-0x030  0x18000         || 		CLC
(0149)  CS-0x031  0x18000         || 		CLC
(0150)  CS-0x032  0x0816B         || 		BRNE inner_loop
(0151)                            || 
(0152)  CS-0x033  0x18000         || 		CLC
(0153)  CS-0x034  0x18000         || 		CLC
(0154)  CS-0x035  0x08163         || 		BRNE middle_loop
(0155)                            || 
(0156)  CS-0x036  0x18000         || 		CLC
(0157)  CS-0x037  0x18000         || 		CLC
(0158)  CS-0x038  0x18000         || 		CLC
(0159)  CS-0x039  0x18000         || 		CLC
(0160)  CS-0x03A  0x18000         || 		CLC
(0161)  CS-0x03B  0x18000         || 		CLC
(0162)  CS-0x03C  0x18000         || 		CLC
(0163)  CS-0x03D  0x18000         || 		CLC
(0164)  CS-0x03E  0x0815B         || 		BRNE outer_loop
(0165)                            || 
(0166)  CS-0x03F  0x18002  0x03F  || return:		RET
(0167)                            || ;-----------------------------------------------------------
(0168)                            || 
(0169)                            || 
(0170)                            || ;--------------------------------------------------------------------
(0171)                            || ; bubble_sort - subroutine returns highest voltage data on at SCR[0]
(0172)                            || ;
(0173)                            || ; Tweaked parameters
(0174)                            || ; R9 - outer count
(0175)                            || ; R10 - inner count
(0176)                            || ; R11 - ADDR for inner count arr[i]
(0177)                            || ; R12 - ADDR for inner count + 1 ( arr[i+1[)
(0178)                            || ; R13 - temp
(0179)                            || ; R14  - used for input and outputting values (X)
(0180)                            || ; R15 - value fro arr[i]
(0181)                            || ; R16 - value for arr[i+1]
(0182)                            || ;--------------------------------------------------------------------
(0183)                            || 
(0184)                     0x040  || bubble_sort:
(0185)                            || 
(0186)  CS-0x040  0x3690C         || 	MOV R9, BUBBLE_OUTER_COUNT ; outer_count = 10
(0187)                            || 
(0188)                     0x041  || bubble_outer_loop:
(0189)                            || 
(0190)  CS-0x041  0x36A0C         || 	MOV R10, BUBBLE_INNER_COUNT ; inner_count = 3
(0191)                            || 
(0192)                     0x042  || bubble_inner_loop:
(0193)                            || 	;get index of k and k+1 from 0->
(0194)                            || 
(0195)                            ||         ;ADDR_i = 4
(0196)  CS-0x042  0x36B0C         || 	MOV R11, BUBBLE_INNER_COUNT
(0197)                            || 	;ADD R11, 1
(0198)                            || 
(0199)                            || 	; ADDR_i+1 = 5
(0200)  CS-0x043  0x36C0C         || 	MOV R12, BUBBLE_INNER_COUNT
(0201)  CS-0x044  0x28C01         || 	ADD R12, 1
(0202)                            || 
(0203)  CS-0x045  0x02B52         || 	SUB R11, R10 ; ADDR_i = 5 - count_inner
(0204)  CS-0x046  0x02C52         || 	SUB R12, R10 ; ADDR_i+1 = 6 - count_inner
(0205)                            || 
(0206)                            || 	;get those values stored in the addres
(0207)  CS-0x047  0x04F5A         || 	LD R15, (R11) ; Y = arr[ADDR_i]
(0208)  CS-0x048  0x05062         || 	LD R16, (R12) ; Z = arr[ADDR_i+1]
(0209)                            || 
(0210)                            || 	;COMPARE now
(0211)                            || 
(0212)  CS-0x049  0x04F80         || 	CMP R15, R16 ;
(0213)                            || 
(0214)                            || ;if we get c = 1 that means arr[ADDR_i+1] is greater than or equal to arr[ADDR_i]
(0215)                            || ;so lets swap if this is the case
(0216)  CS-0x04A  0x0A280         || 	BRCS swap
(0217)                            || 
(0218)                     0x04B  || decrement_count_inner:
(0219)  CS-0x04B  0x2CA01         || 	SUB R10, 1 ; count_inner = count_inner -1
(0220)  CS-0x04C  0x08213         || 	BRNE bubble_inner_loop
(0221)  CS-0x04D  0x2C901         || 	SUB R9, 1 ;count_outer = count_outer - 1
(0222)                            || 
(0223)  CS-0x04E  0x0820B         || 	BRNE bubble_outer_loop
(0224)  CS-0x04F  0x18002         || 	RET
(0225)                            || 
(0226)                     0x050  || swap:   ;swap(arr[ADD_i], arr[ADD_i+1])
(0227)  CS-0x050  0x04D79         || 	MOV R13, R15 ; temp = arr[ADDR_i]
(0228)  CS-0x051  0x04F81         || 	MOV R15, R16 ; arr[ADDR_i] = arr[ADDR_i+1]
(0229)  CS-0x052  0x05069         || 	MOV R16, R13 ; arr[ADDR_i+1]  = temp
(0230)  CS-0x053  0x05063         || 	ST R16, (R12)
(0231)  CS-0x054  0x04F5B         || 	ST R15, (R11)
(0232)  CS-0x055  0x08258         || 	BRN decrement_count_inner
(0233)                            || 
(0234)                            || 
(0235)                            || 
(0236)                            || 
(0237)                            || ;-----------------------------------------------------------------------------
(0238)                            || ; goBestLocation - takes a value arr[0] top of stack and goes to that position
(0239)                            || ;
(0240)                            || ; Tweaked parameters:
(0241)                            || ; R17 - best location[3:0]
(0242)                            || ; R31 - using for zero
(0243)                            || ;--------------------------------------------------------------------
(0244)                            || 
(0245)                     0x056  || goBestLocation:
(0246)  CS-0x056  0x15F00         || 		WSP R31 ; reg that has value of 0
(0247)  CS-0x057  0x13102         || 		POP R17
(0248)  CS-0x058  0x2110F         || 		AND R17, 15
(0249)                     0x059  || stayBestLocation:
(0250)  CS-0x059  0x35169         || 		OUT R17, ARDUINO_PORT
(0251)                            || 		;CALL delay
(0252)  CS-0x05A  0x31E01         || 		CMP R30, 1
(0253)  CS-0x05B  0x082CA         || 		BREQ stayBestLocation
(0254)  CS-0x05C  0x18002         || 		RET
(0255)                            || 
(0256)                            || 
(0257)                            || ;-----------------------------------------------------------------------------
(0258)                            || ; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
(0259)                            || ;
(0260)                            || ; Tweaked parameters:
(0261)                            || ; R18 - {1,0,0,0,0,0,SW[1:0]} 
(0262)                            || ; - SW[7] tells us to go back from isr mode if high
(0263)                            || ;--------------------------------------------------------------------
(0264)                            || 
(0265)                            || 
(0266)                            || 
(0267)                     0x05D  || ISR: ;keeping it on the sw[7]
(0268)                            || 	
(0269)                            || 
(0270)  CS-0x05D  0x332FF         || IN R18, SWITCH_PORT ;reading an input 
(0271)  CS-0x05E  0x21283         || AND R18, 131 ;telling ardino we are in isr by setting sw[7] ==1 and setting sw[6:2] = 0 (masking)
(0272)  CS-0x05F  0x05391         || MOV R19, R18 ;setting a number equal to R19 before masking
(0273)                            || 
(0274)                            || ;is sw[7] == 1
(0275)                            || 
(0276)  CS-0x060  0x21280         || AND R18, 128 ; SW[7] && 1
(0277)                            || 
(0278)  CS-0x061  0x31280         || CMP R18, 128  
(0279)                            || 
(0280)                            || ;is SW[7] === 1 go to ISR
(0281)  CS-0x062  0x082EA         || BREQ ISR
(0282)                            || 
(0283)  CS-0x063  0x1A003         || RETIE
(0284)                            || 
(0285)                            || 
(0286)                            || .CSEG
(0287)                       1023  || .ORG 0x3FF
(0288)  CS-0x3FF  0x082E8         || BRN ISR





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
BUBBLE_INNER_LOOP 0x042   (0192)  ||  0220 
BUBBLE_OUTER_LOOP 0x041   (0188)  ||  0223 
BUBBLE_SORT    0x040   (0184)  ||  0050 
DECREMENT_COUNT_INNER 0x04B   (0218)  ||  0232 
DELAY          0x02A   (0138)  ||  0049 0051 
GOBESTLOCATION 0x056   (0245)  ||  0052 
INNER_LOOP     0x02D   (0145)  ||  0150 
ISR            0x05D   (0267)  ||  0281 0288 
MAIN           0x00F   (0046)  ||  0054 
MAIN_MAIN      0x00E   (0043)  ||  0056 
MIDDLE_LOOP    0x02C   (0143)  ||  0154 
OUTER_LOOP     0x02B   (0140)  ||  0164 
RESET_SWEEP    0x027   (0109)  ||  0082 
RETURN         0x03F   (0166)  ||  
STAYBESTLOCATION 0x059   (0249)  ||  0253 
SWAP           0x050   (0226)  ||  0216 
SWEEP          0x019   (0075)  ||  0048 
SWEEP_LOOP     0x01B   (0079)  ||  0106 


-- Directives: .BYTE
------------------------------------------------------------ 
ARDUINO_SWEEP  0x00D   (0020)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0025)  ||  0094 0111 0250 
BUBBLE_INNER_COUNT 0x00C   (0034)  ||  0190 0196 0200 
BUBBLE_OUTER_COUNT 0x00C   (0033)  ||  0186 
DELAY_COUNT_INNER 0x0EC   (0030)  ||  0143 
DELAY_COUNT_MIDDLE 0x0B0   (0031)  ||  0140 
DELAY_COUNT_OUTER 0x0C9   (0032)  ||  0138 
LIGHT_PORT     0x096   (0024)  ||  0090 
MAIN_COUNT     0x0FF   (0036)  ||  0041 0044 
SWEEP_COUNT    0x00D   (0035)  ||  0076 0077 0084 
SWITCH_PORT    0x0FF   (0026)  ||  0270 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
