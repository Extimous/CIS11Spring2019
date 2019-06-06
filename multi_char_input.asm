.ORIG x3000

START			LEA R1, TEST_SCORES	; Hold starting point for array
			LDR R6, R1, #0		; Load value of TEST_SCORES[0] into R6 (tried R7 and worked)
; 			JSR NEGATE_MAX
 
 			AND R2, R2, #0		; R2 is our loop incrementer. Reset to 0
		
LOOP			ADD R2, R2, #1		; Increment loop by 1
 			AND R3, R3, #0		; Reset R3
 			ADD R3, R1, R2		; R3 = &TEST_SCORES[R2] 
 			LDR R4, R3, #0		; R4 = TEST_SCORES[R2]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
			;Get first number
      			LEA R0, prompt1
      			PUTS
      			JSR ReadInput
      			LD R1, num_temp
      			ST R1, TEST_SCORES

      			; reset temp variable
      			AND R0, R0, #0
      			ST R0, num_temp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 			BR CHECK_LOOP_TERM

CHECK_LOOP_TERM		LD R0, LOOP_MAX
 			ADD R0, R0, R2		; R2 = loop increment, check if 0 (4 + (-4))
 			BRnp LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ReadInput		ST R7, saveR7
  			LEA R3, inputArray      ; R3 <- pointer to inputArray
  			AND R4, R4, #0          ; init R4 to 0
  			AND R5, R5, #0          ; init R5 to 0

LoopReadInput 		GETC
    			ADD R6, R0, #-10      ; check for return key
    			BRz DoneReadInput
    			OUT                   ; print character to screen
    			STR R0, R3, #0        ; store char into inputArray
    			ADD R4, R4, #1        ; inc++ size value
    			ST R4, inputSize      ; store R4 into inputSize variable
    			ADD R3, R3, #1        ; inc++ array index
    			ADD R5, R4, #-3       ; stop when 4 char long
    			BRn LoopReadInput     ; loop back for next character

DoneReadInput		LEA R3, inputArray    ; R3 <- pointer to inputArray
    			LEA R4, constArray    ; R4 <- pointer to constArray
    			LD R5, minus30        ; R5 <- contains hex 30
    			LD R6, inputSize      ; R6 <- contains length of input
    			ADD R6, R6, #-1       ; length - 1

LoopReadInput2		LDR R1, R3, #0        ; load ASCII digit from inputArray
    			ADD R1, R1, R5        ; R1 <- contains integer
    			ADD R2, R4, R6        ; R2 <- contins address of constant
    			LDR R2, R2, #0        ; R2 <- load the number from the arrary
    			JSR ReadInputExpand   ; R1 <- Integer, R2 <- Constant
    			LD R1, num_R          ; Load mult result into R1
    			LD R0, num_temp       ; Load the current num into R0
    			ADD R0, R0, R1        ; Add together
    			ST R0, num_temp       ; Store the sum back into the temp num
    			ADD R3, R3, #1        ; increment pointer in inputArray
    			ADD R6, R6, #-1       ; decrement size
    			BRzp LoopReadInput2   ; loop back and continue to multiply out
  			LD R7, saveR7
  			RET

ReadInputExpand		ST R6, saveR6
  			ST R4, saveR4
  			AND R6, R6, #0
  			AND R4, R4, #0
  			ADD R4, R4, R2  ; duplicate R2 so it remains unchanged

Mult			ADD R6, R6, R1
    			ADD R4, R4, #-1
  			BRp Mult
  			ST R6, num_R
  			LD R4, saveR4
  			LD R6, saveR6
  			RET

TEST_SCORES         	.FILL     #0
num_temp      		.FILL     #0

minus30       		.FILL     x-30
inputArray    		.BLKW     #5

constArray    		.FILL     #1
              		.FILL     #10
              		.FILL     #100
              		.FILL     #1000
              		.FILL     #10000
inputSize     		.FILL     #0
saveR4        		.FILL     #0
saveR6        		.FILL     #0
saveR7        		.FILL     #0
num_R         		.FILL     #0
prompt1       		.STRINGZ  "\nEnter Test Score: "
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Variables
;TEST_SCORES		.FILL 62
;			.FILL 63
;			.FILL 0
;			.FILL 6
;			.FILL 64
LOOP_MAX		.FILL -4
MAX			.FILL 0

.END
