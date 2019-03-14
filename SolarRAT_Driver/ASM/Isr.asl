

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
(0003)                       001  || .ORG 0x01
(0004)                            || 
(0005)                            || ;-----------------------------------------------------------------------------
(0006)                            || ; ISR - allows someone to go in manual mode, turn servo using SW's 45 degrees each
(0007)                            || ;
(0008)                            || ; Tweaked parameters:
(0009)                            || ; R18 - {1,0,0,0,0,0,SW[1:0]} 
(0010)                            || ; - SW[7] tells us to go back from isr mode if high
(0011)                            || ;--------------------------------------------------------------------
(0012)                            || 
(0013)                            || 
(0014)                            || 
(0015)                     0x001  || ISR:
(0016)  CS-0x001  0x33296         || IN R18, SWITCH_PORT
(0017)  CS-0x002  0x05391         || MOV R19, R18
(0018)  CS-0x003  0x21283         || AND R18, 131 ;telling ardino we are in isr by setting sw[7] ==1 and setting sw[6:2] = 0 (masking)
(0019)  CS-0x004  0x35269         || OUT R18, ARDUINO_PORT ; output that sw[7] high and the value inputted
(0020)                            ||  
(0021)  CS-0x005  0x21280         || AND R18, 128 ; check if we need to return from isr
(0022)                            || 
(0023)  CS-0x006  0x31280         || CMP R18, 128
(0024)                            || ;z == 1 if they are equal thus SW[7] is high
(0025)  CS-0x007  0x0800B         || BRNE ISR
(0026)  CS-0x008  0x08048         || BRN output
(0027)                            || 
(0028)                     0x009  || output: 
(0029)  CS-0x009  0x35369         || OUT R19, ARDUINO_PORT
(0030)  CS-0x00A  0x08048         || BRN output
(0031)                            || 
(0032)                            ||  





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
ISR            0x001   (0015)  ||  0025 
OUTPUT         0x009   (0028)  ||  0026 0030 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
ARDUINO_PORT   0x069   (0002)  ||  0019 0029 
SWITCH_PORT    0x096   (0001)  ||  0016 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
