; num_to_ascii.asm
; Convert a number (090) into each constituent digit to output
; 0 | 9 | 0

.ORIG x3000

; Store X into R1
; Store Y into R2

MAIN
 LD R1, INPUT_NUM	; Divide by 100 to get hundred's place
 LD R2, DIV_HUNDRED
 
 JSR DIV
 JSR ASCIIFY
 JSR PRINT_QUOTIENT	; Print 100's place

 LD R1, INPUT_NUM 	; Divide by 10 to get ten's place
 LD R2, DIV_TENS
 JSR DIV
 JSR ASCIIFY
 JSR PRINT_QUOTIENT
 JSR PRINT_REMAINDER
 HALT

DIV
  NOT R2, R2		; Negate divisor
  ADD R2, R2, #1

  AND R3, R3, #0	; Reset R3
 
 LOOP
  ADD R1, R1, R2
  BRn LOOP_END
  ADD R3, R3, #1
  BR LOOP
 LOOP_END
  LD R4, DIV_TENS
  ADD R1, R1, R4
 ST R3, QUOTIENT
 ST R1, REMAINDER
 RET

ASCIIFY
 ;LD R4, NEGTEN		; Check if it's 10
 ;ADD R3, R3, R4
 ;BRz
 LD R4, ASCII_NUM_START
 ADD R3, R3, R4		; R3 is quotient
 ADD R1, R1, R4		; R1 is remainder
 RET

PRINT_QUOTIENT
 AND R0, R0, #0		; Print 100's/10's column
 ADD R0, R3, #0
 ST R7, SAVEREG7	
 OUT
 LD R7, SAVEREG7
 RET

PRINT_REMAINDER
 AND R0, R0, #0		; Print 1's column
 ADD R0, R1, #0
 ST R7, SAVEREG7
 OUT
 LD R7, SAVEREG7
 RET

; Variables
INPUT_NUM	.FILL 087
DIV_HUNDRED	.FILL 100
DIV_TENS	.FILL 10
NEGTEN		.FILL -10
QUOTIENT	.FILL 0
REMAINDER	.FILL 0
ASCII_NUM_START	.FILL 48
SAVEREG7	.FILL 0
.END