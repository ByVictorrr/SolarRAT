

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
(0002)                            || ; Final Project: sweeep
(0003)                            || ; Author: Victor Delaplaine
(0004)                            || ; Date: 2019-03-09
(0005)                            || ; Description : Reads in a voltage from 180/12 positions each 15 degrees per location
(0006)                            || ;		Then stores it in the Reg file, and outputs the a value to turn the 
(0007)                            || ;		arduino 15 degrees more from its current location.
(0008)                            || ;
(0009)                            || ;
(0010)                            || ; Registers 0-11 are used specifically for arduino[7:0] on each 15 degrees.
(0011)                            || ; Example:
(0012)                            || ;	R0 - stores the data for location 0 degrees (natural position)
(0013)                            || ;	.
(0014)                            || ;	.
(0015)                            || ;	R11 - stores the data for location 180 degrees (last sweep position)
(0016)                            || ;
(0017)                            || ;
(0018)                            || ;  
(0019)                            || ;
(0020)                            || ; Register uses:
(0021)                            || ;
(0022)                            || ; R0 - arduino[i][7:0]
(0023)                            || ; R1 - arduino[i][3:0]
(0024)                            || ; R2 - arduino[i][7:4]
(0025)                            || ; R3 - Variable for sweep_count 
(0026)                            || ; R4 - Variable for 12 - sweep_count
(0027)                            || ; R5 - address of ith sweep position for arduino[i][7:0]
(0028)                            || ; 
(0029)                            || ;--------------------------------------------------------------------
(0030)                            || 
(0031)                            || ;-----------------Data Segment-------------------------------------
(0032)                            || .DSEG
(0033)                       001  || .ORG 0x01;
(0034)                            || 
(0035)  DS-0x001             00C  || arduino_sweep: .BYTE 12 ; 0x01 ... 0x0C (12th)
(0036)                            || ;-------------------------------------------------------------------
(0037)                            || 
(0038)                            || ;-----PORT DECLARATIONS----------------------
(0039)                       150  || .EQU LIGHT_PORT  =  0x96
(0040)                       105  || .EQU ARDUINO_PORT = 0x69
(0041)                            || ;--------------------------------------------
(0042)                            || 
(0043)                            || ;----CONSTANT DECLARATION-------------------
(0044)                       012  || .EQU SWEEP_COUNT = 12
(0045)                            || ;--------------------------------------------
(0046)                            || 
(0047)                            || .CSEG
(0048)                       013  || .ORG 0x0D
(0049)                            || 
(0050)                            || 
(0051)                            || 
(0052)                     0x00D  || sweep:
(0053)  CS-0x00D  0x3630C         || 	MOV R3, SWEEP_COUNT ;sweep_count = 12
(0054)  CS-0x00E  0x3640C         || 	MOV R4, SWEEP_COUNT  
(0055)                            || 
(0056)                     0x00F  || sweep_loop:
(0057)                            || 
(0058)  CS-0x00F  0x30300         || 	CMP R3, 0 ; is sweep_count == 0?
(0059)  CS-0x010  0x080E2         || 	BREQ reset_sweep ; if yes == > PC = reset_sweep
(0060)                            || 	;else
(0061)  CS-0x011  0x3640C         ||         MOV R4, SWEEP_COUNT ;	
(0062)                            || 
(0063)  CS-0x012  0x0241A         || 	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)
(0064)                            || 
(0065)  CS-0x013  0x04121         || 	MOV R1, R4 ; aruino[3:0] = 12-sweep count
(0066)                            || 
(0067)                            || 
(0068)  CS-0x014  0x32296         || 	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
(0069)                            || 
(0070)  CS-0x015  0x08349         || 	CALL delay
(0071)                            || 
(0072)  CS-0x016  0x34169         || 	OUT R1, ARDUINO_PORT ; output arduino[3:0] to Arduino_ID
(0073)                            || 	
(0074)  CS-0x017  0x00111         || 	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}
(0075)                            || 
(0076)  CS-0x018  0x04009         || 	MOV R0, R1 ; 
(0077)                            || 
(0078)                            || ; before storing arduino[7:0] got to concatenate its componets
(0079)                            || 
(0080)  CS-0x019  0x04023         || 	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]
(0081)                            || 
(0082)  CS-0x01A  0x2C301         ||         SUB R3, 1 ; sweep_count = sweep_count - 1
(0083)                            || 	
(0084)  CS-0x01B  0x08078         || 	BRN sweep_loop 
(0085)                            || 
(0086)                            || 
(0087)                     0x01C  || reset_sweep:
(0088)  CS-0x01C  0x36100         || 	MOV R1, 0
(0089)  CS-0x01D  0x34169         || 	OUT R1, ARDUINO_PORT
(0090)  CS-0x01E  0x083A8         || 	BRN end
(0091)                            || 
(0092)                            || 
(0093)                            || 
(0094)                            || ;--------------------------------------------------------------------
(0095)                            || ;------------------------------------------------------------------------------------
(0096)                            || ; delay subroutine
(0097)                            || ; Delays for a given input of paramets R6, R7, R8
(0098)                            || ; Parameters : R6 - outer count variable  (C1)
(0099)                            || ; 			   R7 - middle count variable  (C2)
(0100)                            || ;              R8 - inner count variable  (C3)
(0101)                            || ;	      
(0102)                            || ;	
(0103)                            || ; Return : Nothing 
(0104)                            || ; Tweaked Parmeter : R6,R7,R8
(0105)                            || ;
(0106)                            || 
(0107)                            || 
(0108)                            || ;--------------------------------------------------------------------
(0109)                            || 
(0110)                       154  || .EQU IN_PORT = 0x9A
(0111)                       066  || .EQU OUT_PORT = 0x42
(0112)                            || 
(0113)                       108  || .EQU COUNT_INNER = 108
(0114)                       232  || .EQU COUNT_MIDDLE = 232
(0115)                       246  || .EQU COUNT_OUTER = 246
(0116)                            || ;N_inner = 5
(0117)                            || ;N_middle = 3
(0118)                            || ;N_outer = 2
(0119)                            || 
(0120)                            || 
(0121)                            || .CSEG
(0122)                       105  || .ORG 0x69
(0123)                            || 
(0124)  CS-0x069  0x366F6  0x069  || delay:	MOV R6, COUNT_OUTER ; R1 = OUTER_COUNT
(0125)                            || 
(0126)  CS-0x06A  0x367E8  0x06A  || outer_loop:	MOV R7, COUNT_MIDDLE
(0127)                            || 				
(0128)                            ||  	
(0129)  CS-0x06B  0x3686C  0x06B  || middle_loop:	MOV R8, COUNT_INNER
(0130)                            || 		
(0131)  CS-0x06C  0x2C801  0x06C  || inner_loop:	SUB R8, 1 
(0132)  CS-0x06D  0x18000         || 		CLC
(0133)  CS-0x06E  0x18000         || 		CLC
(0134)  CS-0x06F  0x18000         || 		CLC
(0135)  CS-0x070  0x08363         || 		BRNE inner_loop
(0136)                            || 		
(0137)  CS-0x071  0x18000         || 		CLC
(0138)  CS-0x072  0x0835B         || 		BRNE middle_loop
(0139)  CS-0x073  0x08353         || 		BRNE outer_loop
(0140)                            || 		
(0141)  CS-0x074  0x18002  0x074  || return:		RET
(0142)                            || ;-----------------------------------------------------------
(0143)                            || 
(0144)                            || 
(0145)                            || 
(0146)                            || 
(0147)                     0x075  || end:





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
DELAY          0x069   (0124)  ||  0070 
END            0x075   (0147)  ||  0090 
INNER_LOOP     0x06C   (0131)  ||  0135 
MIDDLE_LOOP    0x06B   (0129)  ||  0138 
OUTER_LOOP     0x06A   (0126)  ||  0139 
RESET_SWEEP    0x01C   (0087)  ||  0059 
RETURN         0x074   (0141)  ||  
SWEEP          0x00D   (0052)  ||  
SWEEP_LOOP     0x00F   (0056)  ||  0084 


-- Directives: .BYTE
------------------------------------------------------------ 
ARDUINO_SWEEP  0x00D   (0035)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0040)  ||  0072 0089 
COUNT_INNER    0x06C   (0113)  ||  0129 
COUNT_MIDDLE   0x0E8   (0114)  ||  0126 
COUNT_OUTER    0x0F6   (0115)  ||  0124 
IN_PORT        0x09A   (0110)  ||  
LIGHT_PORT     0x096   (0039)  ||  0068 
OUT_PORT       0x042   (0111)  ||  
SWEEP_COUNT    0x00C   (0044)  ||  0053 0054 0061 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
