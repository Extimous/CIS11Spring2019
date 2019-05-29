; Test Score Calculator
; CIS 11
; 

.ORIG x3000
LEA R1, TEST_SCORES

;;
; Input - Get 5 test scores from user (3 character input, 000 to 100)
;         and push data to TEST_SCORES stack


;; Stack - Push and pop operations
;
;

;;
; Output - Convert processed data (min, max, avg) to readable text
;          and provide letter grade equivalence
;

; Variables
TEST_SCORES	.FILL 0
		.FILL 0
		.FILL 0
		.FILL 0
		.FILL 0

.END