; max.asm
; Test scores will be loaded into R1 to R5
; Program will check every one to determine which one is greatest

.ORIG x3000

START
 LEA R1, TEST_SCORES	; Hold starting point for array
 LDR R6, R1, #0		; Load value of TEST_SCORES[0] into R6
 JSR NEGATE_MAX
 
 AND R2, R2, #0		; R2 is our loop incrementer. Reset to 0
		
LOOP
 ADD R2, R2, #1		; Increment loop by 1
 AND R3, R3, #0		; Reset R3
 ADD R3, R1, R2		; R3 = &TEST_SCORES[R2] 
 LDR R4, R3, #0		; R4 = TEST_SCORES[R2]
 
 AND R5, R5, #0		; Reset R5
 ADD R5, R4, R6		; R4 = val next in array + max
 BRnz CHECK_LOOP_TERM	; if neg, then we know max is already max
 
 AND R6, R6, #0		; if pos, then we have a new max value
 ADD R6, R4, #0
 JSR NEGATE_MAX
 BR CHECK_LOOP_TERM

CHECK_LOOP_TERM
 LD R0, LOOP_MAX
 ADD R0, R0, R2		; R2 = loop increment, check if 0 (4 + (-4))
 BRnp LOOP

JSR NEGATE_MAX
ST R6, MAX
HALT

NEGATE_MAX
 NOT R6, R6		; 1's complement
 ADD R6, R6, #1		; 2's complement
 RET

; Variables
TEST_SCORES	.FILL 62
		.FILL 63
		.FILL 0
		.FILL 6
		.FILL 64
LOOP_MAX	.FILL -4
MAX		.FILL 0
.END