;--------------------------------------------------------------------
; bubble_sort - subroutine returns highest voltage data on at SCR[0]
;
; Register uses:
; R0 - input_count 
; R1 - outer count
; R2 - inner count
; R3 - ADDR for inner count arr[i]
; R4 - ADDR for inner count + 1 ( arr[i+1[)
; R5 - temp
; R6  - used for input and outputting values (X)
; R7 - value fro arr[i] 
; R8 - value for arr[i+1]
;--------------------------------------------------------------------

.DSEG
.ORG 0x00
arr: .BYTE 10 ; declares 10 bytes 

;--------------CONSTANTS------------------------------------------------------
.EQU COUNT = 3
.EQU IN_PORT = 0x42
.EQU OUTER_COUNT =  3 ; one extra one because on 10 transversal print out array
.EQU INNER_COUNT = 3
;----------------------------------------------------------------------------^

;--------------------Code Segment --------------------------------
.CSEG
.ORG 0x1D

bubble_sort: 

	MOV R0, COUNT ; initalizing count_input = 10
	MOV R3, 1 ; address three is stored into arr[10 - count_input]
	
;read in 10 values and store in SCR from addrss 1 ... 11
	
input:  	
	IN R6, IN_PORT ; x = 10-count_input value
    ST R6, (R3) ; X = arr[10-count_input]	
    ADD R3, 1 ; address = address + 1
	SUB R0, 1 ; count_input = count_input - 1
	BRNE input ; if(count_input-1 != 0){PC=input}else{PC=PC+1}
	MOV R1, OUTER_COUNT ; outer_count = 10


outer_loop: 
	MOV R2, INNER_COUNT ; inner_count = 3
	
inner_loop:
	;get index of k and k+1 from 0->10
    ;ADDR_i = 4
	MOV R3, INNER_COUNT
	;ADD R3, 1
	
	; ADDR_i+1 = 5
	MOV R4, INNER_COUNT 
	ADD R4, 1
	
	SUB R3, R2 ; ADDR_i = 5 - count_inner
	SUB R4, R2 ; ADDR_i+1 = 6 - count_inner
	
	;get those values stored in the addres
	LD R7, (R3) ; Y = arr[ADDR_i]
	LD R8, (R4) ; Z = arr[ADDR_i+1]

	;COMPARE now

	CMP R7, R8 ; 
	
;if we get c = 1 that means arr[ADDR_i+1] is greater than or equal to arr[ADDR_i]
;so lets swap if this is the case
	BRCS swap 

decrement_count_inner: 	
	SUB R2, 1 ; count_inner = count_inner -1 
	BRNE inner_loop 
	SUB R1, 1 ;count_outer = count_outer - 1
	
	BRNE outer_loop
	BRN end
	
swap:   ;swap(arr[ADD_i], arr[ADD_i+1]) 
	MOV R5, R7 ; temp = arr[ADDR_i]
	MOV R7, R8 ; arr[ADDR_i] = arr[ADDR_i+1]
	MOV R8, R5 ; arr[ADDR_i+1]  = temp
	ST R8, (R4)
	ST R7, (R3)
	BRN decrement_count_inner 

; check if count_outer ==1 to output sorted list
 		
	
	
end:

	











 
