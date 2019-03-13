

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
(0051)  CS-0x00E  0x08081         || 	CALL sweep
(0052)  CS-0x00F  0x08068         || 	BRN main
(0053)                            || 
(0054)                            || ;------------------------------------------------------------------------------------
(0055)                            || ; sweep  subroutine - goes through 12 degrees every 2s collects data and moves servo
(0056)                            || ;
(0057)                            || ; Tweaked Parameters : 
(0058)                            || ;	      
(0059)                            || ; R0 - arduino[i][7:0]
(0060)                            || ; R1 - arduino[i][3:0]
(0061)                            || ; R2 - arduino[i][7:4]
(0062)                            || ; R3 - Variable for sweep_count 
(0063)                            || ; R4 - Variable for 12 - sweep_count
(0064)                            || ; R5 - address of ith sweep position for arduino[i][7:0]
(0065)                            || ; 
(0066)                            || 	
(0067)                            || ; Return : Nothing 
(0068)                            || ;
(0069)                            || ;--------------------------------------------------------------------
(0070)                            || 
(0071)                     0x010  || sweep: 
(0072)                            || 
(0073)  CS-0x010  0x3630D         || 	MOV R3, SWEEP_COUNT
(0074)                            || 
(0075)                     0x011  || sweep_loop:
(0076)                            || 
(0077)  CS-0x011  0x36602         || 	MOV R6, DELAY_COUNT_OUTER
(0078)                            || 
(0079)  CS-0x012  0x30300         || 	CMP R3, 0 ; is sweep_count == 0?
(0080)                            || 
(0081)  CS-0x013  0x08132         || 	BREQ return_sweep ; if yes == > PC = reset_sweep
(0082)                            || 	;else
(0083)                            ||    
(0084)  CS-0x014  0x3640D         ||     MOV R4, SWEEP_COUNT ;	
(0085)                            || 
(0086)  CS-0x015  0x0241A         || 	SUB R4, R3 ; R4 = 12 - sweep_count  (R4 == the location in which the motor is currently at)
(0087)                            || 
(0088)  CS-0x016  0x04121         || 	MOV R1, R4 ; aruino[3:0] = 12-sweep count
(0089)                            || 		
(0090)  CS-0x017  0x32296         || 	IN R2, LIGHT_PORT ; arduino[7:4] = from LIGHT_PORT
(0091)                            || 	
(0092)  CS-0x018  0x00111         || 	OR R1, R2 ; arduino[7:0]  = {arduino[7:4],arduino[3:0]}
(0093)                            || 
(0094)  CS-0x019  0x04009         || 	MOV R0, R1 ; 
(0095)                            || 
(0096)                            || 	; before storing arduino[7:0] got to concatenate its componets
(0097)                            || 
(0098)  CS-0x01A  0x04023         || 	ST R0, (R4) ; SCR[12 - sweep_count] = arduino[7:0]
(0099)                            || 
(0100)                            ||    
(0101)                     0x01B  || outer_loop:	
(0102)  CS-0x01B  0x36704         || 		MOV R7, DELAY_COUNT_MIDDLE
(0103)  CS-0x01C  0x34169         || 		OUT R1, ARDUINO_PORT 
(0104)                            ||  	
(0105)  CS-0x01D  0x36818  0x01D  || middle_loop:	MOV R8, DELAY_COUNT_INNER
(0106)                            || 		
(0107)                     0x01E  || inner_loop:	
(0108)                            || 
(0109)  CS-0x01E  0x2C801         || 		SUB R8, 1
(0110)                            || 		 
(0111)  CS-0x01F  0x080F3         || 		BRNE inner_loop
(0112)                            || 		
(0113)  CS-0x020  0x2C701         || 		SUB R7, 1
(0114)                            || 		
(0115)  CS-0x021  0x080EB         || 		BRNE middle_loop
(0116)                            || 		
(0117)  CS-0x022  0x2C601         || 		SUB R6, 1
(0118)  CS-0x023  0x080DB         || 		BRNE outer_loop
(0119)                            || 		
(0120)  CS-0x024  0x2C301         || 		SUB R3, 1 ; sweep_count = sweep_count - 1
(0121)  CS-0x025  0x0808B         || 		BRNE sweep_loop
(0122)                            || 
(0123)                            || 
(0124)  CS-0x026  0x18002  0x026  || return_sweep:		RET
(0125)                            || 
(0126)                            ||  





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
INNER_LOOP     0x01E   (0107)  ||  0111 
MAIN           0x00D   (0049)  ||  0052 
MIDDLE_LOOP    0x01D   (0105)  ||  0115 
OUTER_LOOP     0x01B   (0101)  ||  0118 
RETURN_SWEEP   0x026   (0124)  ||  0081 
SWEEP          0x010   (0071)  ||  0051 
SWEEP_LOOP     0x011   (0075)  ||  0121 


-- Directives: .BYTE
------------------------------------------------------------ 
ARDUINO_SWEEP  0x00D   (0020)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0025)  ||  0103 
BUBBLE_INNER_COUNT 0x00C   (0037)  ||  
BUBBLE_OUTER_COUNT 0x00C   (0036)  ||  
DELAY_COUNT_INNER 0x018   (0031)  ||  0105 
DELAY_COUNT_MIDDLE 0x004   (0032)  ||  0102 
DELAY_COUNT_OUTER 0x002   (0033)  ||  0077 
LIGHT_PORT     0x096   (0024)  ||  0090 
SWEEP_COUNT    0x00D   (0041)  ||  0073 0084 
SWEEP_OUTPUT_DELAY 0x002   (0042)  ||  
SWITCH_PORT    0x022   (0026)  ||  


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
