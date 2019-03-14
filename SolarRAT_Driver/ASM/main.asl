

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
(0036)                            || ;-------------------------------------------------
(0037)                            || .CSEG
(0038)                       013  || .ORG 0x0D
(0039)                            || 
(0040)                            || 
(0041)                            || 
(0042)                     0x00D  || main:
(0043)  CS-0x00D  0x1A000         || 	SEI ; set interupts
(0044)  CS-0x00E  0x080A9         || 	CALL sweep
(0045)  CS-0x00F  0x08139         || 	CALL delay
(0046)  CS-0x010  0x081E9         || 	CALL bubble_sort
(0047)  CS-0x011  0x08299         || 	CALL goBestLocation 
(0048)  CS-0x012  0x08139         || 	CALL delay
(0049)  CS-0x013  0x15F00         || 	WSP R31 ; have stack pointer go back to 0
(0050)  CS-0x014  0x08068         || 	BRN main
(0051)                            || 
(0052)                            || ;------------------------------------------------------------------------------------
(0053)                            || ; sweep  subroutine - goes through 12 degrees every 2s collects data and moves servo
(0054)                            || ;
(0055)                            || ; Tweaked Parameters : 
(0056)                            || ;	      
(0057)                            || ; R0 - arduino[i][7:0]
(0058)                            || ; R1 - arduino[i][3:0]
(0059)                            || ; R2 - arduino[i][7:4]
(0060)                            || ; R3 - Variable for sweep_count 
(0061)                            || ; R4 - Variable for 12 - sweep_count
(0062)                            || ; R5 - address of ith sweep position for arduino[i][7:0]
(0063)                            || ; 
(0064)                            || 	
(0065)                            || ; Return : Nothing 
(0066)                            || ;
(0067)                            || ;--------------------------------------------------------------------
(0068)                            || 
(0069)                     0x015  || sweep:
(0070)  CS-0x015  0x3630D         || 	MOV R3, SWEEP_COUNT ;sweep_count = 12
(0071)  CS-0x016  0x3640D         || 	MOV R4, SWEEP_COUNT  
(0072)                            || 
(0073)                     0x017  || sweep_loop:
(0074)                            || 
(0075)  CS-0x017  0x30300         || 	CMP R3, 0 ; is sweep_count == 0?
(0076)  CS-0x018  0x08122         || 	BREQ reset_sweep ; if yes == > PC = reset_sweep
(0077)                            || 	;else
(0078)  CS-0x019  0x3640D         ||         MOV R4, SWEEP_COUNT ;	
(0079)                            || 
(0080)  CS-0x01A  0x0241A         || 	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)
(0081)                            || 
(0082)  CS-0x01B  0x04121         || 	MOV R1, R4 ; aruino[3:0] = 12-sweep count
(0083)                            || 
(0084)  CS-0x01C  0x32296         || 	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
(0085)                            || 
(0086)  CS-0x01D  0x08139         || 	CALL delay
(0087)                            || 
(0088)  CS-0x01E  0x34169         || 	OUT R1, ARDUINO_PORT ; output arduino[3:0] to Arduino_ID
(0089)                            || 	
(0090)  CS-0x01F  0x00111         || 	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}
(0091)                            || 
(0092)  CS-0x020  0x04009         || 	MOV R0, R1 ; 
(0093)                            || 
(0094)                            || 	; before storing arduino[7:0] got to concatenate its componets
(0095)                            || 
(0096)  CS-0x021  0x04023         || 	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]
(0097)                            || 
(0098)  CS-0x022  0x2C301         ||         SUB R3, 1 ; sweep_count = sweep_count - 1
(0099)                            || 	
(0100)  CS-0x023  0x080B8         || 	BRN sweep_loop 
(0101)                            || 
(0102)                            || 
(0103)                     0x024  || reset_sweep:
(0104)  CS-0x024  0x36100         || 	MOV R1, 0
(0105)  CS-0x025  0x34169         || 	OUT R1, ARDUINO_PORT
(0106)  CS-0x026  0x18002         || 	RET
(0107)                            || 
(0108)                            || 
(0109)                            || 
(0110)                            || ;------------------------------------------------------------------------------------
(0111)                            || ; delay subroutine
(0112)                            || ; Delays for a given input of paramets R6, R7, R8
(0113)                            || ; Parameters : R6 - outer count variable  (C1)
(0114)                            || ; 	       R7 - middle count variable  (C2)
(0115)                            || ;              R8 - inner count variable  (C3)
(0116)                            || ;	      
(0117)                            || ;	
(0118)                            || ; Return : Nothing 
(0119)                            || ; Tweaked Parmeter : R6,R7,R8
(0120)                            || ;
(0121)                            || ;--------------------------------------------------------------------
(0122)                            || 
(0123)                            || ;N_inner = 6
(0124)                            || ;N_middle = 4
(0125)                            || ;N_outer = 10
(0126)                            || 
(0127)                            || ;3 inner
(0128)                            || ;2 middle
(0129)                            || ;1 outer
(0130)                            || 
(0131)                            || 
(0132)  CS-0x027  0x366C9  0x027  || delay:	MOV R6, DELAY_COUNT_OUTER ; R1 = BUBBLE_OUTER_COUNT
(0133)                            || 
(0134)  CS-0x028  0x367B0  0x028  || outer_loop:	MOV R7, DELAY_COUNT_MIDDLE
(0135)                            || 				
(0136)                            ||  	
(0137)  CS-0x029  0x368EC  0x029  || middle_loop:	MOV R8, DELAY_COUNT_INNER
(0138)                            || 		
(0139)  CS-0x02A  0x2C801  0x02A  || inner_loop:	SUB R8, 1 
(0140)  CS-0x02B  0x18000         || 		CLC
(0141)  CS-0x02C  0x18000         || 		CLC
(0142)  CS-0x02D  0x18000         || 		CLC
(0143)  CS-0x02E  0x18000         || 		CLC
(0144)  CS-0x02F  0x08153         || 		BRNE inner_loop
(0145)                            || 		
(0146)  CS-0x030  0x18000         || 		CLC
(0147)  CS-0x031  0x18000         || 		CLC
(0148)  CS-0x032  0x0814B         || 		BRNE middle_loop
(0149)                            || 		
(0150)  CS-0x033  0x18000         || 		CLC
(0151)  CS-0x034  0x18000         || 		CLC
(0152)  CS-0x035  0x18000         || 		CLC
(0153)  CS-0x036  0x18000         || 		CLC
(0154)  CS-0x037  0x18000         || 		CLC
(0155)  CS-0x038  0x18000         || 		CLC
(0156)  CS-0x039  0x18000         || 		CLC
(0157)  CS-0x03A  0x18000         || 		CLC
(0158)  CS-0x03B  0x08143         || 		BRNE outer_loop
(0159)                            || 		
(0160)  CS-0x03C  0x18002  0x03C  || return:		RET
(0161)                            || ;-----------------------------------------------------------
(0162)                            || 
(0163)                            || 
(0164)                            || ;--------------------------------------------------------------------
(0165)                            || ; bubble_sort - subroutine returns highest voltage data on at SCR[0]
(0166)                            || ;
(0167)                            || ; Tweaked parameters
(0168)                            || ; R9 - outer count
(0169)                            || ; R10 - inner count
(0170)                            || ; R11 - ADDR for inner count arr[i]
(0171)                            || ; R12 - ADDR for inner count + 1 ( arr[i+1[)
(0172)                            || ; R13 - temp
(0173)                            || ; R14  - used for input and outputting values (X)
(0174)                            || ; R15 - value fro arr[i] 
(0175)                            || ; R16 - value for arr[i+1]
(0176)                            || ;--------------------------------------------------------------------
(0177)                            || 
(0178)                     0x03D  || bubble_sort: 
(0179)                            || 
(0180)  CS-0x03D  0x3690D         || 	MOV R9, BUBBLE_OUTER_COUNT ; outer_count = 10
(0181)                            || 
(0182)                     0x03E  || bubble_outer_loop: 
(0183)                            || 
(0184)  CS-0x03E  0x36A0D         || 	MOV R10, BUBBLE_INNER_COUNT ; inner_count = 3
(0185)                            || 	
(0186)                     0x03F  || bubble_inner_loop:
(0187)                            || 	;get index of k and k+1 from 0->
(0188)                            || 
(0189)                            ||         ;ADDR_i = 4
(0190)  CS-0x03F  0x36B0D         || 	MOV R11, BUBBLE_INNER_COUNT
(0191)                            || 	;ADD R11, 1
(0192)                            || 	
(0193)                            || 	; ADDR_i+1 = 5
(0194)  CS-0x040  0x36C0D         || 	MOV R12, BUBBLE_INNER_COUNT 
(0195)  CS-0x041  0x28C01         || 	ADD R12, 1
(0196)                            || 	
(0197)  CS-0x042  0x02B52         || 	SUB R11, R10 ; ADDR_i = 5 - count_inner
(0198)  CS-0x043  0x02C52         || 	SUB R12, R10 ; ADDR_i+1 = 6 - count_inner
(0199)                            || 	
(0200)                            || 	;get those values stored in the addres
(0201)  CS-0x044  0x04F5A         || 	LD R15, (R11) ; Y = arr[ADDR_i]
(0202)  CS-0x045  0x05062         || 	LD R16, (R12) ; Z = arr[ADDR_i+1]
(0203)                            || 
(0204)                            || 	;COMPARE now
(0205)                            || 
(0206)  CS-0x046  0x04F80         || 	CMP R15, R16 ; 
(0207)                            || 	
(0208)                            || ;if we get c = 1 that means arr[ADDR_i+1] is greater than or equal to arr[ADDR_i]
(0209)                            || ;so lets swap if this is the case
(0210)  CS-0x047  0x0A268         || 	BRCS swap 
(0211)                            || 
(0212)                     0x048  || decrement_count_inner: 	
(0213)  CS-0x048  0x2CA01         || 	SUB R10, 1 ; count_inner = count_inner -1 
(0214)  CS-0x049  0x081FB         || 	BRNE bubble_inner_loop 
(0215)  CS-0x04A  0x2C901         || 	SUB R9, 1 ;count_outer = count_outer - 1
(0216)                            || 	
(0217)  CS-0x04B  0x081F3         || 	BRNE bubble_outer_loop
(0218)  CS-0x04C  0x18002         || 	RET
(0219)                            || 	
(0220)                     0x04D  || swap:   ;swap(arr[ADD_i], arr[ADD_i+1]) 
(0221)  CS-0x04D  0x04D79         || 	MOV R13, R15 ; temp = arr[ADDR_i]
(0222)  CS-0x04E  0x04F81         || 	MOV R15, R16 ; arr[ADDR_i] = arr[ADDR_i+1]
(0223)  CS-0x04F  0x05069         || 	MOV R16, R13 ; arr[ADDR_i+1]  = temp
(0224)  CS-0x050  0x05063         || 	ST R16, (R12)
(0225)  CS-0x051  0x04F5B         || 	ST R15, (R11)
(0226)  CS-0x052  0x08240         || 	BRN decrement_count_inner 
(0227)                            || 
(0228)                            ||  		
(0229)                            || 	
(0230)                            || 	
(0231)                            || ;-----------------------------------------------------------------------------
(0232)                            || ; goBestLocation - takes a value arr[0] top of stack and goes to that position
(0233)                            || ;
(0234)                            || ; Tweaked parameters:
(0235)                            || ; R17 - best location[3:0]
(0236)                            || ; R31 - using for zero 
(0237)                            || ;--------------------------------------------------------------------
(0238)                            || 
(0239)                     0x053  || goBestLocation:
(0240)  CS-0x053  0x15F00         || 		WSP R31 ; reg that has value of 0
(0241)  CS-0x054  0x13102         || 		POP R17
(0242)  CS-0x055  0x35169         || 		OUT R17, ARDUINO_PORT
(0243)  CS-0x056  0x08139         || 		CALL delay 	
(0244)  CS-0x057  0x18002         || 		RET 
(0245)                            || 		
(0246)                            || 		
(0247)                            || ;---------------------------------------------
(0248)                            || 
(0249)                            || ;-----------------------------------------------------------------------------
(0250)                            || ; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
(0251)                            || ;
(0252)                            || ; Tweaked parameters:
(0253)                            || ; R18 - {1,0,0,0,0,SW[2],SW[1:0]} 
(0254)                            || ; - first bit tells arduino isr mode
(0255)                            || ; - SW[2] tells us to go back from isr mode if high
(0256)                            || ;--------------------------------------------------------------------
(0257)                            || 
(0258)                     0x058  || ISR:
(0259)  CS-0x058  0x332FF         || 	IN R18, SWITCH_PORT
(0260)  CS-0x059  0x23280         || 	OR R18, 128
(0261)  CS-0x05A  0x35269         || 	OUT R18, ARDUINO_PORT
(0262)  CS-0x05B  0x08139         || 	CALL delay
(0263)  CS-0x05C  0x21204         || 	AND R18, 4 ; check if we need to return from isr
(0264)                            || 	
(0265)  CS-0x05D  0x31204         || 	CMP R18, 4
(0266)                            || 	
(0267)                            || 	;z == 1 if they are equal thus SW[2] is high
(0268)  CS-0x05E  0x082C3         || 	BRNE ISR
(0269)  CS-0x05F  0x1A003         || 	RETIE
(0270)                            || 	
(0271)                            || .CSEG
(0272)                       1023  || .ORG 0x3FF
(0273)  CS-0x3FF  0x082C0         || BRN ISR
(0274)                            || 
(0275)                            || 	
(0276)                            || 
(0277)                            || 
(0278)                            || 
(0279)                            || 
(0280)                            || 
(0281)                            || 
(0282)                            || 
(0283)                            || 
(0284)                            || 
(0285)                            || 
(0286)                            || 
(0287)                            ||  





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
BUBBLE_INNER_LOOP 0x03F   (0186)  ||  0214 
BUBBLE_OUTER_LOOP 0x03E   (0182)  ||  0217 
BUBBLE_SORT    0x03D   (0178)  ||  0046 
DECREMENT_COUNT_INNER 0x048   (0212)  ||  0226 
DELAY          0x027   (0132)  ||  0045 0048 0086 0243 0262 
GOBESTLOCATION 0x053   (0239)  ||  0047 
INNER_LOOP     0x02A   (0139)  ||  0144 
ISR            0x058   (0258)  ||  0268 0273 
MAIN           0x00D   (0042)  ||  0050 
MIDDLE_LOOP    0x029   (0137)  ||  0148 
OUTER_LOOP     0x028   (0134)  ||  0158 
RESET_SWEEP    0x024   (0103)  ||  0076 
RETURN         0x03C   (0160)  ||  
SWAP           0x04D   (0220)  ||  0210 
SWEEP          0x015   (0069)  ||  0044 
SWEEP_LOOP     0x017   (0073)  ||  0100 


-- Directives: .BYTE
------------------------------------------------------------ 
ARDUINO_SWEEP  0x00D   (0020)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0025)  ||  0088 0105 0242 0261 
BUBBLE_INNER_COUNT 0x00D   (0034)  ||  0184 0190 0194 
BUBBLE_OUTER_COUNT 0x00D   (0033)  ||  0180 
DELAY_COUNT_INNER 0x0EC   (0030)  ||  0137 
DELAY_COUNT_MIDDLE 0x0B0   (0031)  ||  0134 
DELAY_COUNT_OUTER 0x0C9   (0032)  ||  0132 
LIGHT_PORT     0x096   (0024)  ||  0084 
SWEEP_COUNT    0x00D   (0035)  ||  0070 0071 0078 
SWITCH_PORT    0x0FF   (0026)  ||  0259 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
