

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
(0002)                            || ; bubble_sort - subroutine returns highest voltage data on at SCR[0]
(0003)                            || ;
(0004)                            || ; Register uses:
(0005)                            || ; R0 - input_count 
(0006)                            || ; R1 - outer count
(0007)                            || ; R2 - inner count
(0008)                            || ; R3 - ADDR for inner count arr[i]
(0009)                            || ; R4 - ADDR for inner count + 1 ( arr[i+1[)
(0010)                            || ; R5 - temp
(0011)                            || ; R6  - used for input and outputting values (X)
(0012)                            || ; R7 - value fro arr[i] 
(0013)                            || ; R8 - value for arr[i+1]
(0014)                            || ;--------------------------------------------------------------------
(0015)                            || 
(0016)                            || .DSEG
(0017)                       000  || .ORG 0x00
(0018)  DS-0x000             00A  || arr: .BYTE 10 ; declares 10 bytes 
(0019)                            || 
(0020)                            || ;--------------CONSTANTS------------------------------------------------------
(0021)                       003  || .EQU COUNT = 3
(0022)                       066  || .EQU IN_PORT = 0x42
(0023)                       003  || .EQU OUTER_COUNT =  3 ; one extra one because on 10 transversal print out array
(0024)                       003  || .EQU INNER_COUNT = 3
(0025)                            || ;----------------------------------------------------------------------------^
(0026)                            || 
(0027)                            || ;--------------------Code Segment --------------------------------
(0028)                            || .CSEG
(0029)                       029  || .ORG 0x1D
(0030)                            || 
(0031)                     0x01D  || bubble_sort: 
(0032)                            || 
(0033)  CS-0x01D  0x36003         || 	MOV R0, COUNT ; initalizing count_input = 10
(0034)  CS-0x01E  0x36301         || 	MOV R3, 1 ; address three is stored into arr[10 - count_input]
(0035)                            || 	
(0036)                            || ;read in 10 values and store in SCR from addrss 1 ... 11
(0037)                            || 	
(0038)                     0x01F  || input:  	
(0039)  CS-0x01F  0x32642         || 	IN R6, IN_PORT ; x = 10-count_input value
(0040)  CS-0x020  0x0461B         ||     ST R6, (R3) ; X = arr[10-count_input]	
(0041)  CS-0x021  0x28301         ||     ADD R3, 1 ; address = address + 1
(0042)  CS-0x022  0x2C001         || 	SUB R0, 1 ; count_input = count_input - 1
(0043)  CS-0x023  0x080FB         || 	BRNE input ; if(count_input-1 != 0){PC=input}else{PC=PC+1}
(0044)  CS-0x024  0x36103         || 	MOV R1, OUTER_COUNT ; outer_count = 10
(0045)                            || 
(0046)                            || 
(0047)                     0x025  || outer_loop: 
(0048)  CS-0x025  0x36203         || 	MOV R2, INNER_COUNT ; inner_count = 3
(0049)                            || 	
(0050)                     0x026  || inner_loop:
(0051)                            || 	;get index of k and k+1 from 0->10
(0052)                            ||     ;ADDR_i = 4
(0053)  CS-0x026  0x36303         || 	MOV R3, INNER_COUNT
(0054)                            || 	;ADD R3, 1
(0055)                            || 	
(0056)                            || 	; ADDR_i+1 = 5
(0057)  CS-0x027  0x36403         || 	MOV R4, INNER_COUNT 
(0058)  CS-0x028  0x28401         || 	ADD R4, 1
(0059)                            || 	
(0060)  CS-0x029  0x02312         || 	SUB R3, R2 ; ADDR_i = 5 - count_inner
(0061)  CS-0x02A  0x02412         || 	SUB R4, R2 ; ADDR_i+1 = 6 - count_inner
(0062)                            || 	
(0063)                            || 	;get those values stored in the addres
(0064)  CS-0x02B  0x0471A         || 	LD R7, (R3) ; Y = arr[ADDR_i]
(0065)  CS-0x02C  0x04822         || 	LD R8, (R4) ; Z = arr[ADDR_i+1]
(0066)                            || 
(0067)                            || 	;COMPARE now
(0068)                            || 
(0069)  CS-0x02D  0x04740         || 	CMP R7, R8 ; 
(0070)                            || 	
(0071)                            || ;if we get c = 1 that means arr[ADDR_i+1] is greater than or equal to arr[ADDR_i]
(0072)                            || ;so lets swap if this is the case
(0073)  CS-0x02E  0x0A198         || 	BRCS swap 
(0074)                            || 
(0075)                     0x02F  || decrement_count_inner: 	
(0076)  CS-0x02F  0x2C201         || 	SUB R2, 1 ; count_inner = count_inner -1 
(0077)  CS-0x030  0x08133         || 	BRNE inner_loop 
(0078)  CS-0x031  0x2C101         || 	SUB R1, 1 ;count_outer = count_outer - 1
(0079)                            || 	
(0080)  CS-0x032  0x0812B         || 	BRNE outer_loop
(0081)                            || 	
(0082)                     0x033  || swap:   ;swap(arr[ADD_i], arr[ADD_i+1]) 
(0083)  CS-0x033  0x04539         || 	MOV R5, R7 ; temp = arr[ADDR_i]
(0084)  CS-0x034  0x04741         || 	MOV R7, R8 ; arr[ADDR_i] = arr[ADDR_i+1]
(0085)  CS-0x035  0x04829         || 	MOV R8, R5 ; arr[ADDR_i+1]  = temp
(0086)  CS-0x036  0x04823         || 	ST R8, (R4)
(0087)  CS-0x037  0x0471B         || 	ST R7, (R3)
(0088)  CS-0x038  0x08178         || 	BRN decrement_count_inner 
(0089)                            || 
(0090)                            || ; check if count_outer ==1 to output sorted list
(0091)                            ||  		
(0092)                            || 	
(0093)                            || 	
(0094)                     0x039  || end:
(0095)                            || 
(0096)                            || 	
(0097)                            || 
(0098)                            || 
(0099)                            || 
(0100)                            || 
(0101)                            || 
(0102)                            || 
(0103)                            || 
(0104)                            || 
(0105)                            || 
(0106)                            || 
(0107)                            || 
(0108)                            ||  





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
BUBBLE_SORT    0x01D   (0031)  ||  
DECREMENT_COUNT_INNER 0x02F   (0075)  ||  0088 
END            0x039   (0094)  ||  
INNER_LOOP     0x026   (0050)  ||  0077 
INPUT          0x01F   (0038)  ||  0043 
OUTER_LOOP     0x025   (0047)  ||  0080 
SWAP           0x033   (0082)  ||  0073 


-- Directives: .BYTE
------------------------------------------------------------ 
ARR            0x00A   (0018)  ||  


-- Directives: .EQU
------------------------------------------------------------ 
COUNT          0x003   (0021)  ||  0033 
INNER_COUNT    0x003   (0024)  ||  0048 0053 0057 
IN_PORT        0x042   (0022)  ||  0039 
OUTER_COUNT    0x003   (0023)  ||  0044 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
