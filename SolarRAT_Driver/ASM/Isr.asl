

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


(0001)                       150  || .EQU SWITCH_PORT = 0x96
(0002)                       105  || .EQU ARDUINO_PORT =  0x69
(0003)                            || .CSEG
(0004)                       001  || .ORG 0x01
(0005)                            || 
(0006)                            || 
(0007)                            || ;-----------------------------------------------------------------------------
(0008)                            || ; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
(0009)                            || ;
(0010)                            || ; Tweaked parameters:
(0011)                            || ; R18 - {1,0,0,0,0,0,SW[1:0]} 
(0012)                            || ; - SW[7] tells us to go back from isr mode if high
(0013)                            || ;--------------------------------------------------------------------
(0014)                            || 
(0015)                            || 
(0016)                            || 
(0017)                     0x001  || ISR: ;keeping it on the sw[7]
(0018)                            || 
(0019)  CS-0x001  0x33296         || IN R18, SWITCH_PORT ;reading an input 
(0020)  CS-0x002  0x21283         || AND R18, 131 ;telling ardino we are in isr by setting sw[7] ==1 and setting sw[6:2] = 0 (masking)
(0021)  CS-0x003  0x05391         || MOV R19, R18 ;setting a number equal to R19 before masking
(0022)  CS-0x004  0x35269         || OUT R18, ARDUINO_PORT ; output that sw[7] high and the value inputted
(0023)                            || 
(0024)                            || ;is sw[7] == 1
(0025)                            || 
(0026)  CS-0x005  0x21280         || AND R18, 128 ; SW[7] && 1
(0027)                            || 
(0028)  CS-0x006  0x31280         || CMP R18, 128  
(0029)                            || 
(0030)                            || ;is SW[7] === 1?
(0031)                            || ;if Sw[7] != 1 then branch to isr
(0032)  CS-0x007  0x0800A         || BREQ ISR
(0033)                            || 
(0034)                     0x008  || output: ;loop for sw[7] being off
(0035)                            || ;keeping the sw[7] on  
(0036)  CS-0x008  0x35369         || OUT R19, ARDUINO_PORT
(0037)  CS-0x009  0x33396         || IN R19, SWITCH_PORT
(0038)                            || 
(0039)  CS-0x00A  0x21380         || AND R19, 128 ; SW[7] && 1
(0040)                            || 
(0041)  CS-0x00B  0x31380         || CMP R19, 128 
(0042)                            || 
(0043)  CS-0x00C  0x0800A         || BREQ ISR
(0044)  CS-0x00D  0x08040         || BRN output
(0045)                            || 
(0046)                            ||  





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
ISR            0x001   (0017)  ||  0032 0043 
OUTPUT         0x008   (0034)  ||  0044 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0002)  ||  0022 0036 
SWITCH_PORT    0x096   (0001)  ||  0019 0037 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
