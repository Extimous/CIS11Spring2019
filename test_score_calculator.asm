
.ORIG x3000
 ; Output application name
 LEA R0, INI_PROMPT
 PUTS
START
  AND R0, R0, #0	; Reset registers
  AND R1, R1, #0
  AND R2, R2, #0
  AND R3, R3, #0
  AND R4, R4, #0
  AND R5, R5, #0
  AND R6, R6, #0
  LEA R0, PROMPT	; Ask for test score
  PUTS			; Output test score
  LEA R6, MEMORYSPACE 	; saves the address of the storage memory block
  

LOOP

; Get Input from user
  GETC
  PUTC
  
  STR R0, R6, #0        ; Store user input into array
  ADD R6, R6, #1        ; Increment the memory address
  ADD R1, R1, #1	; Increment loop counter

  ADD R2, R1, #-3     	; If looped 3 times, then start conversion from ASCII to hex
  BRz CONVERT 
  BR LOOP

CONVERT
; At this point, we have three values stored as input

; Counter adjustments
  AND R1, R1, #0	; Reset LOOP offset

; Juicy part
 LEA R6, MEMORYSPACE	
 AND R1, R1, #0		; Reset R1
 AND R2, R2, #0		; Reset R2
 AND R3, R3, #0		; Reset R3
 AND R4, R4, #0		; Reset R4
 AND R5, R5, #0		; Reset R5


 ; Handle the DIGITS
 ; R1 = x
 ; R2 = y
 ; R3 = value of 100's place
 ; R4 = value of 10's place
 ; R5 = value of 1's place
 ; R1 = R3 + R4 + R5

; Handle's hundred's place
 LD R1, HUNDREDS
 LDR R2, R6, #0
 JSR DECREASE_ASCII_VALUE
 JSR MULT
 ADD R3, R0, #0		; Move result into R3

; Handle ten's place
 LD R1, TENTHS
 ADD R6, R6, #1		; Move to next address (MEMORYSPACE + 1)
 LDR R2, R6, #0		; Load next value into Y
 JSR DECREASE_ASCII_VALUE
 JSR MULT
 ADD R4, R0, #0		; Move result into R4

; Handle one's place
  ADD R6, R6, #1	; Move to next address (MEMORYSPACE + 2)
  LDR R2, R6, #0	; Load next value into Y
  JSR DECREASE_ASCII_VALUE
  ADD R5, R5, R2	; Move 1's digit into R5

; Add all the values together, number = R2 + R3 + R4
  ADD R0, R2, #0
  ADD R0, R0, R3
  ADD R0, R0, R4
  
; Load test score address and apply offset
; based on which test input are we on
  LEA R1, TEST_SCORES
  LD R2, NUM_INPUTS
  ADD R1, R1, R2
  STR R0, R1, #0
 
; Increment number of tests input 
  ADD R2, R2, #1
  ST R2, NUM_INPUTS

; Check to see how many test scores have been input
  LD R3, NUM_TEST_SCORES
  ADD R4, R2, R3	
  BRz FUNC_MAX
  BR START

MULT ; R1 = X, R2 = Y, Return value into R0
 AND R0, R0, #0		; Reset R0 	

MULT_LOOP		
 ; Check if Y is 0
 ADD R2, R2, #0		; Add 0 to check if it is 0
 BRz MULT_EXIT_EARLY	; Exit loop 
 ADD R0, R0, R1		; SUM = SUM + X
 ADD R2, R2, #-1	; Decrement Y
 BRp MULT_LOOP
MULT_EXIT_EARLY
 RET

DECREASE_ASCII_VALUE
  ADD R2, R2, #-16
  ADD R2, R2, #-16
  ADD R2, R2, #-16
  RET

FUNC_MAX
 LEA R1, TEST_SCORES	; Hold starting point for array
 LDR R6, R1, #0		; Load value of TEST_SCORES[0] into R6
 JSR NEGATE_MAX
 
 AND R2, R2, #0		; R2 is our loop incrementer. Reset to 0
		
 MAX_LOOP
  ADD R2, R2, #1	; Increment loop by 1
  AND R3, R3, #0	; Reset R3
  ADD R3, R1, R2	; R3 = &TEST_SCORES[R2] 
  LDR R4, R3, #0	; R4 = TEST_SCORES[R2]
 
  AND R5, R5, #0	; Reset R5
  ADD R5, R4, R6	; R4 = val next in array + max
  BRnz CHECK_LOOP_TERM	; if neg, then we know max is already max
 
  AND R6, R6, #0	; if pos, then we have a new max value
  ADD R6, R4, #0
  JSR NEGATE_MAX
  BR CHECK_LOOP_TERM

 CHECK_LOOP_TERM
  LD R0, LOOP_MAX
  ADD R0, R0, R2	; R2 = loop increment, check if 0 (4 + (-4))
  BRnp MAX_LOOP

 JSR NEGATE_MAX
 ST R6, MAX
 JSR FUNC_MIN

 NEGATE_MAX
  NOT R6, R6		; 1's complement
  ADD R6, R6, #1	; 2's complement
  RET

FUNC_MIN
 LEA R1, TEST_SCORES	; Hold starting point for array
 LDR R6, R1, #0		; Load value of TEST_SCORES[0] into R6
 JSR NEGATE_MIN
 
 AND R2, R2, #0		; R2 is our loop incrementer. Reset to 0
		
 MIN_LOOP
  ADD R2, R2, #1		; Increment loop by 1
  AND R3, R3, #0		; Reset R3
  ADD R3, R1, R2		; R3 = &TEST_SCORES[R2] 
  LDR R4, R3, #0		; R4 = TEST_SCORES[R2]
 
  AND R5, R5, #0		; Reset R5
  ADD R5, R4, R6		; R4 = val next in array + max
  BRzp CHECK_MIN_LOOP_TERM	; if neg, then we know max is already max

  AND R6, R6, #0		; if neg, then we have a new min value
  ADD R6, R4, #0
  JSR NEGATE_MIN
  BR CHECK_MIN_LOOP_TERM
 CHECK_MIN_LOOP_TERM
  LD R0, LOOP_MIN
  ADD R0, R0, R2		; R2 = loop increment, check if 0 (4 + (-4))
  BRnp MIN_LOOP

 JSR NEGATE_MIN
 ST R6, MIN
 JSR FUNC_AVG

 NEGATE_MIN
  NOT R6, R6			; 1's complement
  ADD R6, R6, #1		; 2's complement
  RET

FUNC_AVG
 AND R1, R1, #0
 LEA R2, TEST_SCORES		; Hold starting point for array
 AND R3, R3, #0			; R3 is our loop incrementer. Reset to 0
 AND R4, R4, #0			; Reset R4
 AND R5, R5, #0

 AVG_LOOP
  LDR R4, R2, #0		; Load TEST_SCORES[i] into R4, where i is R3
  ADD R1, R1, R4		; Add to running total
  ADD R3, R3, #1		; Increment index
  ADD R2, R2, #1		; Increment address offset

  ; Check if we're done summing everything
  ; LD R5, LOOP_MAX
  ADD R5, R3, #-5		
  BRnp AVG_LOOP
  ST R1, AVG

  LD R2, NUM_TEST_SCORES	; Load divisor into R2 for division
  NOT R2, R2
  ADD R2, R2, #1

  ; R1 now contains running total
  ; R2 contains number of tests
  ST R7, REG7
  JSR SIMPLE_DIV
  LD R7, REG7
  ST R3, AVG			; R1 contains our quotient
  JSR OUTPUT


NUM_TO_ASCII
 LD R1, INPUT_NUM
 LD R2, HUNDREDS

 AND R3, R3, #0			; Reset registers
 AND R4, R4, #0
 AND R5, R5, #0
 AND R6, R6, #0
 
 ST R7, REG7_2			; Store R7 address to return back to
 JSR DIV
 JSR ASCIIFY
 JSR PRINT_QUOTIENT		; Print 100's place

 LD R1, INPUT_NUM 		; Divide by 10 to get ten's place
 LD R2, TENTHS
 JSR DIV
 JSR ASCIIFY
 JSR PRINT_QUOTIENT
 JSR PRINT_REMAINDER
 LD R7, REG7_2			; Reload our old register 7 for proper RET functionality
 RET

 DIV
  NOT R2, R2			; Negate divisor
  ADD R2, R2, #1

  AND R3, R3, #0		; Reset R3
 
 N2A_LOOP
  ADD R1, R1, R2
  BRn N2A_LOOP_END
  ADD R3, R3, #1
  BR N2A_LOOP
 N2A_LOOP_END
  LD R4, TENTHS
  ADD R1, R1, R4
 ST R3, QUOTIENT
 ST R1, REMAINDER
 RET

 ASCIIFY
 ;LD R4, NEGTEN			; Check if it's 10
 ;ADD R3, R3, R4
 ;BRz
  LD R4, ASCII_NUM_START
  ADD R3, R3, R4		; R3 is quotient
  ADD R1, R1, R4		; R1 is remainder
  RET

 PRINT_QUOTIENT
  AND R0, R0, #0		; Print 100's/10's column
  ADD R0, R3, #0
  ST R7, REG7	
  OUT
  LD R7, REG7
  RET

 PRINT_REMAINDER
  AND R0, R0, #0		; Print 1's column
  ADD R0, R1, #0
  ST R7, REG7
  OUT
  LD R7, REG7
  RET

SIMPLE_DIV
  NOT R2, R2			; Negate divisor
  ADD R2, R2, #1

  AND R3, R3, #0		; Reset R3
 
 SDIV_LOOP
  ADD R1, R1, R2
  BRn SDIV_LOOP_END
  ADD R3, R3, #1
  BR SDIV_LOOP
 SDIV_LOOP_END
  ST R3, QUOTIENT
  ST R1, REMAINDER
  RET

OUTPUT
 ; Output min data
 LEA R0, MIN_PROMPT
 PUTS
 LD R1, MIN
 ST R1, INPUT_NUM
 JSR NUM_TO_ASCII

 ; Output max data
 LEA R0, MAX_PROMPT
 PUTS
 LD R1, MAX
 ST R1, INPUT_NUM
 JSR NUM_TO_ASCII

 ; Output avg data
 LEA R0, AVG_PROMPT
 PUTS
 LD R1, AVG
 ST R1, INPUT_NUM
 JSR NUM_TO_ASCII

HALT

; Variables
INI_PROMPT	.STRINGZ "CIS11 Test Score Calculator\n"
MEMORYSPACE 	.FILL 0 ; Hold's hundredth's digit
	  	.FILL 0 ; Hold's tenth's digit
		.FILL 0 ; Hold's 1's digit
HUNDREDS	.FILL 100
TENTHS		.FILL 10
PROMPT		.STRINGZ "\nPlease enter test score (000 - 099): "
NEG30		.FILL -30
NUM_TEST_SCORES	.FILL -5
NUM_INPUTS	.FILL 0
REG7		.FILL 0
REG7_2		.FILL 0
NEGTEN		.FILL -10
QUOTIENT	.FILL 0
REMAINDER	.FILL 0
ASCII_NUM_START	.FILL 48
TEST_SCORES	.FILL 0
		.FILL 0
		.FILL 0
		.FILL 0
		.FILL 0
MAX		.FILL 0
MIN		.FILL 0
AVG		.FILL 0
LOOP_MAX	.FILL -4
LOOP_MIN	.FILL -4
INPUT_NUM	.FILL 0
MAX_PROMPT	.STRINGZ "\nThe max value of the test scores is: "
MIN_PROMPT	.STRINGZ "\n\nThe min value of the test scores is: "
AVG_PROMPT	.STRINGZ "\nThe avg value of the test scores is: "
.END