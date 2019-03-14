

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
(0037)                       100  || .EQU MAIN_OUTER_COUNT = 100
(0038)                            || ;-------------------------------------------------
(0039)                            || .CSEG
(0040)                       013  || .ORG 0x0D
(0041)                            || 
(0042)  CS-0x00D  0x37E64         || MOV R30, MAIN_OUTER_COUNT
(0043)                            || 
(0044)                     0x00E  || main_main:
(0045)  CS-0x00E  0x37DFF         || MOV R29, MAIN_COUNT
(0046)                            || 
(0047)                     0x00F  || main:
(0048)  CS-0x00F  0x1A000         || 	SEI ; set interupts
(0049)  CS-0x010  0x080C1         || 	CALL sweep
(0050)                            || 	;CALL delay
(0051)  CS-0x011  0x081F9         || 	CALL bubble_sort
(0052)                            || 	;CALL delay
(0053)  CS-0x012  0x082A9         || 	CALL goBestLocation
(0054)  CS-0x013  0x2DD01         || 	SUB R29, 1
(0055)  CS-0x014  0x0807A         || 	BREQ main
(0056)  CS-0x015  0x2DE01         || 	SUB R30, 1
(0057)  CS-0x016  0x08149         || 	CALL delay
(0058)  CS-0x017  0x08070         || 	BRN main_main
(0059)                            || 
(0060)                            || ;------------------------------------------------------------------------------------
(0061)                            || ; sweep  subroutine - goes through 12 degrees every 2s collects data and moves servo
(0062)                            || ;
(0063)                            || ; Tweaked Parameters :
(0064)                            || ;
(0065)                            || ; R0 - arduino[i][7:0]
(0066)                            || ; R1 - arduino[i][3:0]
(0067)                            || ; R2 - arduino[i][7:4]
(0068)                            || ; R3 - Variable for sweep_count
(0069)                            || ; R4 - Variable for 12 - sweep_count
(0070)                            || ; R5 - address of ith sweep position for arduino[i][7:0]
(0071)                            || ;
(0072)                            || 
(0073)                            || ; Return : Nothing
(0074)                            || ;
(0075)                            || ;--------------------------------------------------------------------
(0076)                            || 
(0077)                     0x018  || sweep:
(0078)  CS-0x018  0x3630D         || 	MOV R3, SWEEP_COUNT ;sweep_count = 12
(0079)  CS-0x019  0x3640D         || 	MOV R4, SWEEP_COUNT
(0080)                            || 
(0081)                     0x01A  || sweep_loop:
(0082)                            || 
(0083)  CS-0x01A  0x30300         || 	CMP R3, 0 ; is sweep_count == 0?
(0084)  CS-0x01B  0x08132         || 	BREQ reset_sweep ; if yes == > PC = reset_sweep
(0085)                            || 	;else
(0086)                            ||    
(0087)  CS-0x01C  0x3640D         ||     MOV R4, SWEEP_COUNT ;
(0088)                            || 
(0089)  CS-0x01D  0x0241A         || 	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)
(0090)                            || 
(0091)  CS-0x01E  0x04121         || 	MOV R1, R4 ; aruino[3:0] = 12-sweep count
(0092)                            || 
(0093)  CS-0x01F  0x32296         || 	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
(0094)                            || 
(0095)                            || 	;CALL delay
(0096)                            || 
(0097)  CS-0x020  0x34169         || 	OUT R1, ARDUINO_PORT ; output arduino[3:0] to Arduino_ID
(0098)                            || 
(0099)  CS-0x021  0x00111         || 	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}
(0100)                            || 
(0101)  CS-0x022  0x04009         || 	MOV R0, R1 ;
(0102)                            || 
(0103)                            || 	; before storing arduino[7:0] got to concatenate its componets
(0104)                            || 
(0105)  CS-0x023  0x04023         || 	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]
(0106)                            || 
(0107)  CS-0x024  0x2C301         ||         SUB R3, 1 ; sweep_count = sweep_count - 1
(0108)                            || 
(0109)  CS-0x025  0x080D0         || 	BRN sweep_loop
(0110)                            || 
(0111)                            || 
(0112)                     0x026  || reset_sweep:
(0113)  CS-0x026  0x36100         || 	MOV R1, 0
(0114)  CS-0x027  0x34169         || 	OUT R1, ARDUINO_PORT
(0115)  CS-0x028  0x18002         || 	RET
(0116)                            || 
(0117)                            || 
(0118)                            || 
(0119)                            || ;------------------------------------------------------------------------------------
(0120)                            || ; delay subroutine
(0121)                            || ; Delays for a given input of paramets R6, R7, R8
(0122)                            || ; Parameters : R6 - outer count variable  (C1)
(0123)                            || ; 	       R7 - middle count variable  (C2)
(0124)                            || ;              R8 - inner count variable  (C3)
(0125)                            || ;
(0126)                            || ;
(0127)                            || ; Return : Nothing
(0128)                            || ; Tweaked Parmeter : R6,R7,R8
(0129)                            || ;
(0130)                            || ;--------------------------------------------------------------------
(0131)                            || 
(0132)                            || ;N_inner = 6
(0133)                            || ;N_middle = 4
(0134)                            || ;N_outer = 10
(0135)                            || 
(0136)                            || ;3 inner
(0137)                            || ;2 middle
(0138)                            || ;1 outer
(0139)                            || 
(0140)                            || 
(0141)  CS-0x029  0x366C9  0x029  || delay:	MOV R6, DELAY_COUNT_OUTER ; R1 = BUBBLE_OUTER_COUNT
(0142)                            || 
(0143)  CS-0x02A  0x367B0  0x02A  || outer_loop:	MOV R7, DELAY_COUNT_MIDDLE
(0144)                            || 
(0145)                            || 
(0146)  CS-0x02B  0x368EC  0x02B  || middle_loop:	MOV R8, DELAY_COUNT_INNER
(0147)                            || 
(0148)  CS-0x02C  0x2C801  0x02C  || inner_loop:	SUB R8, 1
(0149)  CS-0x02D  0x18000         || 		CLC
(0150)  CS-0x02E  0x18000         || 		CLC
(0151)  CS-0x02F  0x18000         || 		CLC
(0152)  CS-0x030  0x18000         || 		CLC
(0153)  CS-0x031  0x08163         || 		BRNE inner_loop
(0154)                            || 
(0155)  CS-0x032  0x18000         || 		CLC
(0156)  CS-0x033  0x18000         || 		CLC
(0157)  CS-0x034  0x0815B         || 		BRNE middle_loop
(0158)                            || 
(0159)  CS-0x035  0x18000         || 		CLC
(0160)  CS-0x036  0x18000         || 		CLC
(0161)  CS-0x037  0x18000         || 		CLC
(0162)  CS-0x038  0x18000         || 		CLC
(0163)  CS-0x039  0x18000         || 		CLC
(0164)  CS-0x03A  0x18000         || 		CLC
(0165)  CS-0x03B  0x18000         || 		CLC
(0166)  CS-0x03C  0x18000         || 		CLC
(0167)  CS-0x03D  0x08153         || 		BRNE outer_loop
(0168)                            || 
(0169)  CS-0x03E  0x18002  0x03E  || return:		RET
(0170)                            || ;-----------------------------------------------------------
(0171)                            || 
(0172)                            || 
(0173)                            || ;--------------------------------------------------------------------
(0174)                            || ; bubble_sort - subroutine returns highest voltage data on at SCR[0]
(0175)                            || ;
(0176)                            || ; Tweaked parameters
(0177)                            || ; R9 - outer count
(0178)                            || ; R10 - inner count
(0179)                            || ; R11 - ADDR for inner count arr[i]
(0180)                            || ; R12 - ADDR for inner count + 1 ( arr[i+1[)
(0181)                            || ; R13 - temp
(0182)                            || ; R14  - used for input and outputting values (X)
(0183)                            || ; R15 - value fro arr[i]
(0184)                            || ; R16 - value for arr[i+1]
(0185)                            || ;--------------------------------------------------------------------
(0186)                            || 
(0187)                     0x03F  || bubble_sort:
(0188)                            || 
(0189)  CS-0x03F  0x3690C         || 	MOV R9, BUBBLE_OUTER_COUNT ; outer_count = 10
(0190)                            || 
(0191)                     0x040  || bubble_outer_loop:
(0192)                            || 
(0193)  CS-0x040  0x36A0C         || 	MOV R10, BUBBLE_INNER_COUNT ; inner_count = 3
(0194)                            || 
(0195)                     0x041  || bubble_inner_loop:
(0196)                            || 	;get index of k and k+1 from 0->
(0197)                            || 
(0198)                            ||         ;ADDR_i = 4
(0199)  CS-0x041  0x36B0C         || 	MOV R11, BUBBLE_INNER_COUNT
(0200)                            || 	;ADD R11, 1
(0201)                            || 
(0202)                            || 	; ADDR_i+1 = 5
(0203)  CS-0x042  0x36C0C         || 	MOV R12, BUBBLE_INNER_COUNT
(0204)  CS-0x043  0x28C01         || 	ADD R12, 1
(0205)                            || 
(0206)  CS-0x044  0x02B52         || 	SUB R11, R10 ; ADDR_i = 5 - count_inner
(0207)  CS-0x045  0x02C52         || 	SUB R12, R10 ; ADDR_i+1 = 6 - count_inner
(0208)                            || 
(0209)                            || 	;get those values stored in the addres
(0210)  CS-0x046  0x04F5A         || 	LD R15, (R11) ; Y = arr[ADDR_i]
(0211)  CS-0x047  0x05062         || 	LD R16, (R12) ; Z = arr[ADDR_i+1]
(0212)                            || 
(0213)                            || 	;COMPARE now
(0214)                            || 
(0215)  CS-0x048  0x04F80         || 	CMP R15, R16 ;
(0216)                            || 
(0217)                            || ;if we get c = 1 that means arr[ADDR_i+1] is greater than or equal to arr[ADDR_i]
(0218)                            || ;so lets swap if this is the case
(0219)  CS-0x049  0x0A278         || 	BRCS swap
(0220)                            || 
(0221)                     0x04A  || decrement_count_inner:
(0222)  CS-0x04A  0x2CA01         || 	SUB R10, 1 ; count_inner = count_inner -1
(0223)  CS-0x04B  0x0820B         || 	BRNE bubble_inner_loop
(0224)  CS-0x04C  0x2C901         || 	SUB R9, 1 ;count_outer = count_outer - 1
(0225)                            || 
(0226)  CS-0x04D  0x08203         || 	BRNE bubble_outer_loop
(0227)                            || 	;CALL delay
(0228)  CS-0x04E  0x18002         || 	RET
(0229)                            || 
(0230)                     0x04F  || swap:   ;swap(arr[ADD_i], arr[ADD_i+1])
(0231)  CS-0x04F  0x04D79         || 	MOV R13, R15 ; temp = arr[ADDR_i]
(0232)  CS-0x050  0x04F81         || 	MOV R15, R16 ; arr[ADDR_i] = arr[ADDR_i+1]
(0233)  CS-0x051  0x05069         || 	MOV R16, R13 ; arr[ADDR_i+1]  = temp
(0234)  CS-0x052  0x05063         || 	ST R16, (R12)
(0235)  CS-0x053  0x04F5B         || 	ST R15, (R11)
(0236)  CS-0x054  0x08250         || 	BRN decrement_count_inner
(0237)                            || 
(0238)                            || 
(0239)                            || 
(0240)                            || 
(0241)                            || ;-----------------------------------------------------------------------------
(0242)                            || ; goBestLocation - takes a value arr[0] top of stack and goes to that position
(0243)                            || ;
(0244)                            || ; Tweaked parameters:
(0245)                            || ; R17 - best location[3:0]
(0246)                            || ; R31 - using for zero
(0247)                            || ;--------------------------------------------------------------------
(0248)                            || 
(0249)                     0x055  || goBestLocation:
(0250)  CS-0x055  0x15F00         || 		WSP R31 ; reg that has value of 0
(0251)  CS-0x056  0x13102         || 		POP R17
(0252)  CS-0x057  0x2110F         || 		AND R17, 15
(0253)                     0x058  || stayBestLocation:
(0254)  CS-0x058  0x35169         || 		OUT R17, ARDUINO_PORT
(0255)                            || 		;CALL delay
(0256)  CS-0x059  0x31E01         || 		CMP R30, 1
(0257)  CS-0x05A  0x082C2         || 		BREQ stayBestLocation
(0258)  CS-0x05B  0x18002         || 		RET
(0259)                            || 
(0260)                            || 
(0261)                            || ;-----------------------------------------------------------------------------
(0262)                            || ; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
(0263)                            || ;
(0264)                            || ; Tweaked parameters:
(0265)                            || ; R18 - {1,0,0,0,0,0,SW[1:0]} 
(0266)                            || ; - SW[7] tells us to go back from isr mode if high
(0267)                            || ;--------------------------------------------------------------------
(0268)                            || 
(0269)                            || 
(0270)                            || 
(0271)                     0x05C  || ISR: ;keeping it on the sw[7]
(0272)                            || 	
(0273)                            || 
(0274)  CS-0x05C  0x332FF         || IN R18, SWITCH_PORT ;reading an input 
(0275)  CS-0x05D  0x21283         || AND R18, 131 ;telling ardino we are in isr by setting sw[7] ==1 and setting sw[6:2] = 0 (masking)
(0276)  CS-0x05E  0x05391         || MOV R19, R18 ;setting a number equal to R19 before masking
(0277)                            || 
(0278)                            || ;is sw[7] == 1
(0279)                            || 
(0280)  CS-0x05F  0x21280         || AND R18, 128 ; SW[7] && 1
(0281)                            || 
(0282)  CS-0x060  0x31280         || CMP R18, 128  
(0283)                            || 
(0284)                            || ;is SW[7] === 1 go to ISR
(0285)  CS-0x061  0x082E2         || BREQ ISR
(0286)                            || 
(0287)  CS-0x062  0x1A003         || RETIE
(0288)                            || 
(0289)                            || 
(0290)                            || .CSEG
(0291)                       1023  || .ORG 0x3FF
(0292)  CS-0x3FF  0x082E0         || BRN ISR





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
BUBBLE_INNER_LOOP 0x041   (0195)  ||  0223 
BUBBLE_OUTER_LOOP 0x040   (0191)  ||  0226 
BUBBLE_SORT    0x03F   (0187)  ||  0051 
DECREMENT_COUNT_INNER 0x04A   (0221)  ||  0236 
DELAY          0x029   (0141)  ||  0057 
GOBESTLOCATION 0x055   (0249)  ||  0053 
INNER_LOOP     0x02C   (0148)  ||  0153 
ISR            0x05C   (0271)  ||  0285 0292 
MAIN           0x00F   (0047)  ||  0055 
MAIN_MAIN      0x00E   (0044)  ||  0058 
MIDDLE_LOOP    0x02B   (0146)  ||  0157 
OUTER_LOOP     0x02A   (0143)  ||  0167 
RESET_SWEEP    0x026   (0112)  ||  0084 
RETURN         0x03E   (0169)  ||  
STAYBESTLOCATION 0x058   (0253)  ||  0257 
SWAP           0x04F   (0230)  ||  0219 
SWEEP          0x018   (0077)  ||  0049 
SWEEP_LOOP     0x01A   (0081)  ||  0109 


-- Directives: .BYTE
------------------------------------------------------------ 
ARDUINO_SWEEP  0x00D   (0020)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0025)  ||  0097 0114 0254 
BUBBLE_INNER_COUNT 0x00C   (0034)  ||  0193 0199 0203 
BUBBLE_OUTER_COUNT 0x00C   (0033)  ||  0189 
DELAY_COUNT_INNER 0x0EC   (0030)  ||  0146 
DELAY_COUNT_MIDDLE 0x0B0   (0031)  ||  0143 
DELAY_COUNT_OUTER 0x0C9   (0032)  ||  0141 
LIGHT_PORT     0x096   (0024)  ||  0093 
MAIN_COUNT     0x0FF   (0036)  ||  0045 
MAIN_OUTER_COUNT 0x064   (0037)  ||  0042 
SWEEP_COUNT    0x00D   (0035)  ||  0078 0079 0087 
SWITCH_PORT    0x0FF   (0026)  ||  0274 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
