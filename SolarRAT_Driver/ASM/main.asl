

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
(0031)                       176  || .EQU DELAY_COUNT_MIDDLE =  176
(0032)                       201  || .EQU DELAY_COUNT_OUTER =  201
(0033)                       013  || .EQU BUBBLE_OUTER_COUNT =  13 
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
(0044)  CS-0x00E  0x080A1         || 	CALL sweep
(0045)                            || 	;CALL delay
(0046)  CS-0x00F  0x081D9         || 	CALL bubble_sort
(0047)  CS-0x010  0x08289         || 	CALL goBestLocation 
(0048)  CS-0x011  0x08129         || 	CALL delay
(0049)  CS-0x012  0x15F00         || 	WSP R31 ; have stack pointer go back to 0
(0050)  CS-0x013  0x08068         || 	BRN main
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
(0069)                     0x014  || sweep:
(0070)  CS-0x014  0x3630D         || 	MOV R3, SWEEP_COUNT ;sweep_count = 12
(0071)  CS-0x015  0x3640D         || 	MOV R4, SWEEP_COUNT  
(0072)                            || 
(0073)                     0x016  || sweep_loop:
(0074)                            || 
(0075)  CS-0x016  0x30300         || 	CMP R3, 0 ; is sweep_count == 0?
(0076)  CS-0x017  0x08112         || 	BREQ reset_sweep ; if yes == > PC = reset_sweep
(0077)                            || 	;else
(0078)  CS-0x018  0x3640D         ||         MOV R4, SWEEP_COUNT ;	
(0079)                            || 
(0080)  CS-0x019  0x0241A         || 	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)
(0081)                            || 
(0082)  CS-0x01A  0x04121         || 	MOV R1, R4 ; aruino[3:0] = 12-sweep count
(0083)                            || 
(0084)  CS-0x01B  0x32296         || 	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
(0085)                            || 
(0086)                            || 
(0087)  CS-0x01C  0x34169         || '	OUT R1, ARDUINO_PORT ; output arduino[3:0] to Arduino_ID
            syntax error

(0088)                            || 	
(0089)  CS-0x01D  0x00111         || 	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}
(0090)                            || 
(0091)  CS-0x01E  0x04009         || 	MOV R0, R1 ; 
(0092)                            || 
(0093)                            || 	; before storing arduino[7:0] got to concatenate its componets
(0094)                            || 
(0095)  CS-0x01F  0x04023         || 	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]
(0096)                            || 
(0097)  CS-0x020  0x2C301         ||         SUB R3, 1 ; sweep_count = sweep_count - 1
(0098)                            || 	
(0099)  CS-0x021  0x080B0         || 	BRN sweep_loop 
(0100)                            || 
(0101)                            || 
(0102)                     0x022  || reset_sweep:
(0103)  CS-0x022  0x36100         || 	MOV R1, 0
(0104)  CS-0x023  0x34169         || 	OUT R1, ARDUINO_PORT
(0105)  CS-0x024  0x18002         || 	RET
(0106)                            || 
(0107)                            || 
(0108)                            || 
(0109)                            || ;------------------------------------------------------------------------------------
(0110)                            || ; delay subroutine
(0111)                            || ; Delays for a given input of paramets R6, R7, R8
(0112)                            || ; Parameters : R6 - outer count variable  (C1)
(0113)                            || ; 	       R7 - middle count variable  (C2)
(0114)                            || ;              R8 - inner count variable  (C3)
(0115)                            || ;	      
(0116)                            || ;	
(0117)                            || ; Return : Nothing 
(0118)                            || ; Tweaked Parmeter : R6,R7,R8
(0119)                            || ;
(0120)                            || ;--------------------------------------------------------------------
(0121)                            || 
(0122)                            || ;N_inner = 6
(0123)                            || ;N_middle = 4
(0124)                            || ;N_outer = 10
(0125)                            || 
(0126)                            || ;3 inner
(0127)                            || ;2 middle
(0128)                            || ;1 outer
(0129)                            || 
(0130)                            || 
(0131)  CS-0x025  0x366C9  0x025  || delay:	MOV R6, DELAY_COUNT_OUTER ; R1 = BUBBLE_OUTER_COUNT
(0132)                            || 
(0133)  CS-0x026  0x367B0  0x026  || outer_loop:	MOV R7, DELAY_COUNT_MIDDLE
(0134)                            || 				
(0135)                            ||  	
(0136)  CS-0x027  0x368EC  0x027  || middle_loop:	MOV R8, DELAY_COUNT_INNER
(0137)                            || 		
(0138)  CS-0x028  0x2C801  0x028  || inner_loop:	SUB R8, 1 
(0139)  CS-0x029  0x18000         || 		CLC
(0140)  CS-0x02A  0x18000         || 		CLC
(0141)  CS-0x02B  0x18000         || 		CLC
(0142)  CS-0x02C  0x18000         || 		CLC
(0143)  CS-0x02D  0x08143         || 		BRNE inner_loop
(0144)                            || 		
(0145)  CS-0x02E  0x18000         || 		CLC
(0146)  CS-0x02F  0x18000         || 		CLC
(0147)  CS-0x030  0x0813B         || 		BRNE middle_loop
(0148)                            || 		
(0149)  CS-0x031  0x18000         || 		CLC
(0150)  CS-0x032  0x18000         || 		CLC
(0151)  CS-0x033  0x18000         || 		CLC
(0152)  CS-0x034  0x18000         || 		CLC
(0153)  CS-0x035  0x18000         || 		CLC
(0154)  CS-0x036  0x18000         || 		CLC
(0155)  CS-0x037  0x18000         || 		CLC
(0156)  CS-0x038  0x18000         || 		CLC
(0157)  CS-0x039  0x08133         || 		BRNE outer_loop
(0158)                            || 		
(0159)  CS-0x03A  0x18002  0x03A  || return:		RET
(0160)                            || ;-----------------------------------------------------------
(0161)                            || 
(0162)                            || 
(0163)                            || ;--------------------------------------------------------------------
(0164)                            || ; bubble_sort - subroutine returns highest voltage data on at SCR[0]
(0165)                            || ;
(0166)                            || ; Tweaked parameters
(0167)                            || ; R9 - outer count
(0168)                            || ; R10 - inner count
(0169)                            || ; R11 - ADDR for inner count arr[i]
(0170)                            || ; R12 - ADDR for inner count + 1 ( arr[i+1[)
(0171)                            || ; R13 - temp
(0172)                            || ; R14  - used for input and outputting values (X)
(0173)                            || ; R15 - value fro arr[i] 
(0174)                            || ; R16 - value for arr[i+1]
(0175)                            || ;--------------------------------------------------------------------
(0176)                            || 
(0177)                     0x03B  || bubble_sort: 
(0178)                            || 
(0179)  CS-0x03B  0x3690D         || 	MOV R9, BUBBLE_OUTER_COUNT ; outer_count = 10
(0180)                            || 
(0181)                     0x03C  || bubble_outer_loop: 
(0182)                            || 
(0183)  CS-0x03C  0x36A0D         || 	MOV R10, BUBBLE_INNER_COUNT ; inner_count = 3
(0184)                            || 	
(0185)                     0x03D  || bubble_inner_loop:
(0186)                            || 	;get index of k and k+1 from 0->
(0187)                            || 
(0188)                            ||         ;ADDR_i = 4
(0189)  CS-0x03D  0x36B0D         || 	MOV R11, BUBBLE_INNER_COUNT
(0190)                            || 	;ADD R11, 1
(0191)                            || 	
(0192)                            || 	; ADDR_i+1 = 5
(0193)  CS-0x03E  0x36C0D         || 	MOV R12, BUBBLE_INNER_COUNT 
(0194)  CS-0x03F  0x28C01         || 	ADD R12, 1
(0195)                            || 	
(0196)  CS-0x040  0x02B52         || 	SUB R11, R10 ; ADDR_i = 5 - count_inner
(0197)  CS-0x041  0x02C52         || 	SUB R12, R10 ; ADDR_i+1 = 6 - count_inner
(0198)                            || 	
(0199)                            || 	;get those values stored in the addres
(0200)  CS-0x042  0x04F5A         || 	LD R15, (R11) ; Y = arr[ADDR_i]
(0201)  CS-0x043  0x05062         || 	LD R16, (R12) ; Z = arr[ADDR_i+1]
(0202)                            || 
(0203)                            || 	;COMPARE now
(0204)                            || 
(0205)  CS-0x044  0x04F80         || 	CMP R15, R16 ; 
(0206)                            || 	
(0207)                            || ;if we get c = 1 that means arr[ADDR_i+1] is greater than or equal to arr[ADDR_i]
(0208)                            || ;so lets swap if this is the case
(0209)  CS-0x045  0x0A258         || 	BRCS swap 
(0210)                            || 
(0211)                     0x046  || decrement_count_inner: 	
(0212)  CS-0x046  0x2CA01         || 	SUB R10, 1 ; count_inner = count_inner -1 
(0213)  CS-0x047  0x081EB         || 	BRNE bubble_inner_loop 
(0214)  CS-0x048  0x2C901         || 	SUB R9, 1 ;count_outer = count_outer - 1
(0215)                            || 	
(0216)  CS-0x049  0x081E3         || 	BRNE bubble_outer_loop
(0217)  CS-0x04A  0x18002         || 	RET
(0218)                            || 	
(0219)                     0x04B  || swap:   ;swap(arr[ADD_i], arr[ADD_i+1]) 
(0220)  CS-0x04B  0x04D79         || 	MOV R13, R15 ; temp = arr[ADDR_i]
(0221)  CS-0x04C  0x04F81         || 	MOV R15, R16 ; arr[ADDR_i] = arr[ADDR_i+1]
(0222)  CS-0x04D  0x05069         || 	MOV R16, R13 ; arr[ADDR_i+1]  = temp
(0223)  CS-0x04E  0x05063         || 	ST R16, (R12)
(0224)  CS-0x04F  0x04F5B         || 	ST R15, (R11)
(0225)  CS-0x050  0x08230         || 	BRN decrement_count_inner 
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
(0238)                     0x051  || goBestLocation:
(0239)  CS-0x051  0x15F00         || 		WSP R31 ; reg that has value of 0
(0240)  CS-0x052  0x13102         || 		POP R17
(0241)  CS-0x053  0x2110F         || 		AND R17, 15
(0242)                     0x054  || stayBestLocation:
(0243)  CS-0x054  0x35169         || 		OUT R17, ARDUINO_PORT
(0244)  CS-0x055  0x082A0         || 		BRN stayBestLocation
(0245)                            || 		; 	
(0246)                            || 		;RET 
(0247)                            || 		
(0248)                            || 		
(0249)                            || ;---------------------------------------------
(0250)                            || 
(0251)                            || ;-----------------------------------------------------------------------------
(0252)                            || ; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
(0253)                            || ;
(0254)                            || ; Tweaked parameters:
(0255)                            || ; R18 - {1,0,0,0,0,SW[2],SW[1:0]} 
(0256)                            || ; - first bit tells arduino isr mode
(0257)                            || ; - SW[2] tells us to go back from isr mode if high
(0258)                            || ;--------------------------------------------------------------------
(0259)                            || 
(0260)                     0x056  || ISR:
(0261)  CS-0x056  0x332FF         || 	IN R18, SWITCH_PORT
(0262)  CS-0x057  0x21283         || 	AND R18, 131
(0263)  CS-0x058  0x35269         || 	OUT R18, ARDUINO_PORT
(0264)  CS-0x059  0x21280         || 	AND R18, 128 ; check if we need to return from isr	
(0265)  CS-0x05A  0x31280         || 	CMP R18, 128
(0266)                            || 	
(0267)                            || 	;z == 1 if they are equal thus SW[2] is high
(0268)  CS-0x05B  0x082B2         || 	BREQ ISR
(0269)                            || 
(0270)  CS-0x05C  0x1A003         || 	RETIE
(0271)                            || 	
(0272)                            || .CSEG
(0273)                       1023  || .ORG 0x3FF
(0274)  CS-0x3FF  0x082B0         || BRN ISR
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
(0288)                            ||  





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
BUBBLE_INNER_LOOP 0x03D   (0185)  ||  0213 
BUBBLE_OUTER_LOOP 0x03C   (0181)  ||  0216 
BUBBLE_SORT    0x03B   (0177)  ||  0046 
DECREMENT_COUNT_INNER 0x046   (0211)  ||  0225 
DELAY          0x025   (0131)  ||  0048 
GOBESTLOCATION 0x051   (0238)  ||  0047 
INNER_LOOP     0x028   (0138)  ||  0143 
ISR            0x056   (0260)  ||  0268 0274 
MAIN           0x00D   (0042)  ||  0050 
MIDDLE_LOOP    0x027   (0136)  ||  0147 
OUTER_LOOP     0x026   (0133)  ||  0157 
RESET_SWEEP    0x022   (0102)  ||  0076 
RETURN         0x03A   (0159)  ||  
STAYBESTLOCATION 0x054   (0242)  ||  0244 
SWAP           0x04B   (0219)  ||  0209 
SWEEP          0x014   (0069)  ||  0044 
SWEEP_LOOP     0x016   (0073)  ||  0099 


-- Directives: .BYTE
------------------------------------------------------------ 
ARDUINO_SWEEP  0x00D   (0020)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0025)  ||  0087 0104 0243 0263 
BUBBLE_INNER_COUNT 0x00D   (0034)  ||  0183 0189 0193 
BUBBLE_OUTER_COUNT 0x00D   (0033)  ||  0179 
DELAY_COUNT_INNER 0x0EC   (0030)  ||  0136 
DELAY_COUNT_MIDDLE 0x0B0   (0031)  ||  0133 
DELAY_COUNT_OUTER 0x0C9   (0032)  ||  0131 
LIGHT_PORT     0x096   (0024)  ||  0084 
SWEEP_COUNT    0x00D   (0035)  ||  0070 0071 0078 
SWITCH_PORT    0x0FF   (0026)  ||  0261 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
