

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
(0029)                            || ;----CONSTANT DECLARATION-------------------
(0030)                       010  || .EQU DELAY_COUNT_INNER = 10
(0031)                       010  || .EQU DELAY_COUNT_MIDDLE = 10
(0032)                       010  || .EQU DELAY_COUNT_OUTER = 10
(0033)                       012  || .EQU BUBBLE_OUTER_COUNT =  12 ; 
(0034)                       012  || .EQU BUBBLE_INNER_COUNT = 12
(0035)                       003  || .EQU SWEEP_COUNT = 3
(0036)                            || ;-------------------------------------------------
(0037)                            || .CSEG
(0038)                       013  || .ORG 0x0D
(0039)                            || 
(0040)                            || 
(0041)                            || 
(0042)                     0x00D  || main:
(0043)                            || 	;SEI ; set interupts
(0044)  CS-0x00D  0x08089         || 	CALL sweep
(0045)  CS-0x00E  0x08121         || 	CALL delay
(0046)  CS-0x00F  0x15F00         || 	WSP R31 ; have stack pointer go back to 0
(0047)  CS-0x010  0x081D0         || 	BRN end
(0048)                            || 
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
(0066)                     0x011  || sweep:
(0067)  CS-0x011  0x36303         || 	MOV R3, SWEEP_COUNT ;sweep_count = 12
(0068)  CS-0x012  0x36403         || 	MOV R4, SWEEP_COUNT  
(0069)  CS-0x013  0x36000         || 	MOV R0, 0 ; reset 
(0070)                            || 
(0071)                     0x014  || sweep_loop:
(0072)                            || 
(0073)  CS-0x014  0x30300         || 	CMP R3, 0 ; is sweep_count == 0?
(0074)                            || 	
(0075)  CS-0x015  0x0811A         || 	BREQ reset_sweep ; if yes == > PC = reset_sweep
(0076)                            || 	;else	
(0077)                            || 
(0078)  CS-0x016  0x36403         || 	MOV R4, SWEEP_COUNT
(0079)                            || 	
(0080)  CS-0x017  0x0241A         || 	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)
(0081)                            || 
(0082)  CS-0x018  0x04121         || 	MOV R1, R4 ; aruino[3:0] = 12-sweep count
(0083)                            || 
(0084)  CS-0x019  0x32296         || 	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
(0085)                            || 
(0086)                            || 
(0087)                            || 
(0088)  CS-0x01A  0x08121         || 	CALL delay
(0089)                            || 
(0090)  CS-0x01B  0x34169         || 	OUT R1, ARDUINO_PORT ; output arduino[3:0] to Arduino_ID
(0091)                            || 	
(0092)  CS-0x01C  0x08121         || 	CALL delay
(0093)                            || 	
(0094)  CS-0x01D  0x08121         || 	CALL delay
(0095)                            || 	
(0096)  CS-0x01E  0x00111         || 	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}
(0097)                            || 
(0098)  CS-0x01F  0x04009         || 	MOV R0, R1 ; 
(0099)                            || 
(0100)                            || 	; before storing arduino[7:0] got to concatenate its componets
(0101)                            || 
(0102)  CS-0x020  0x04023         || 	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]
(0103)                            || 
(0104)  CS-0x021  0x2C301         ||     SUB R3, 1 ; sweep_count = sweep_count - 1
(0105)                            || 	
(0106)  CS-0x022  0x080A0         || 	BRN sweep_loop 
(0107)                            || 
(0108)                            || 
(0109)                     0x023  || reset_sweep:
(0110)                            || ;	MOV R1, 0
(0111)                            || ;	OUT R1, ARDUINO_PORT
(0112)  CS-0x023  0x18002         || 	RET
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
(0138)  CS-0x024  0x3660A  0x024  || delay:	MOV R6, DELAY_COUNT_OUTER ; R1 = BUBBLE_OUTER_COUNT
(0139)                            || 
(0140)  CS-0x025  0x3670A  0x025  || outer_loop:	MOV R7, DELAY_COUNT_MIDDLE
(0141)                            || 				
(0142)                            ||  	
(0143)  CS-0x026  0x3680A  0x026  || middle_loop:	MOV R8, DELAY_COUNT_INNER
(0144)                            || 		
(0145)  CS-0x027  0x2C801  0x027  || inner_loop:	SUB R8, 1 
(0146)  CS-0x028  0x18000         || 		CLC
(0147)  CS-0x029  0x18000         || 		CLC
(0148)  CS-0x02A  0x18000         || 		CLC
(0149)  CS-0x02B  0x18000         || 		CLC
(0150)  CS-0x02C  0x0813B         || 		BRNE inner_loop
(0151)                            || 		
(0152)  CS-0x02D  0x18000         || 		CLC
(0153)  CS-0x02E  0x18000         || 		CLC
(0154)  CS-0x02F  0x08133         || 		BRNE middle_loop
(0155)                            || 		
(0156)  CS-0x030  0x18000         || 		CLC
(0157)  CS-0x031  0x18000         || 		CLC
(0158)  CS-0x032  0x18000         || 		CLC
(0159)  CS-0x033  0x18000         || 		CLC
(0160)  CS-0x034  0x18000         || 		CLC
(0161)  CS-0x035  0x18000         || 		CLC
(0162)  CS-0x036  0x18000         || 		CLC
(0163)  CS-0x037  0x18000         || 		CLC
(0164)  CS-0x038  0x0812B         || 		BRNE outer_loop
(0165)                            || 		
(0166)  CS-0x039  0x18002  0x039  || return:		RET
(0167)                            || 
(0168)                            || 
(0169)                            || 
(0170)                            || 
(0171)                     0x03A  || end:
(0172)                            || 
(0173)                            || 
(0174)                            ||  





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
DELAY          0x024   (0138)  ||  0045 0088 0092 0094 
END            0x03A   (0171)  ||  0047 
INNER_LOOP     0x027   (0145)  ||  0150 
MAIN           0x00D   (0042)  ||  
MIDDLE_LOOP    0x026   (0143)  ||  0154 
OUTER_LOOP     0x025   (0140)  ||  0164 
RESET_SWEEP    0x023   (0109)  ||  0075 
RETURN         0x039   (0166)  ||  
SWEEP          0x011   (0066)  ||  0044 
SWEEP_LOOP     0x014   (0071)  ||  0106 


-- Directives: .BYTE
------------------------------------------------------------ 
ARDUINO_SWEEP  0x00D   (0020)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0025)  ||  0090 
BUBBLE_INNER_COUNT 0x00C   (0034)  ||  
BUBBLE_OUTER_COUNT 0x00C   (0033)  ||  
DELAY_COUNT_INNER 0x00A   (0030)  ||  0143 
DELAY_COUNT_MIDDLE 0x00A   (0031)  ||  0140 
DELAY_COUNT_OUTER 0x00A   (0032)  ||  0138 
LIGHT_PORT     0x096   (0024)  ||  0084 
SWEEP_COUNT    0x003   (0035)  ||  0067 0068 0078 
SWITCH_PORT    0x022   (0026)  ||  


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
