; multi_char_input.asm
;

.ORIG x3000
; Get first number
LEA R0, prompt1
PUTS
JSR ReadInput
LD R1, num_temp
ST R1, num_X
HALT

ReadInput
  ST R7, saveR7
  LEA R3, inputArray      ; R3 <- pointer to inputArray
  AND R4, R4, #0          ; init R4 to 0
  AND R5, R5, #0          ; init R5 to 0
  LoopReadInput GETC
    ADD R6, R0, #-10      ; check for return key
    BRz DoneReadInput
    OUT                   ; print character to screen
    STR R0, R3, #0        ; store char into inputArray
    ADD R4, R4, #1        ; inc++ size value
    ST R4, inputSize      ; store R4 into inputSize variable
    ADD R3, R3, #1        ; inc++ array index
    ADD R5, R4, #-4       ; stop when 4 char long
    BRn LoopReadInput     ; loop back for next character
  DoneReadInput
    LEA R3, inputArray    ; R3 <- pointer to inputArray
    LEA R4, constArray    ; R4 <- pointer to constArray
    LD R5, minus30        ; R5 <- contains hex 30
    LD R6, inputSize      ; R6 <- contains length of input
    ADD R6, R6, #-1       ; length - 1
  LoopReadInput2
    LDR R1, R3, #0        ; load ASCII digit from inputArray
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

minus30       .FILL     x-30
inputArray    .BLKW     #5

ReadInputExpand
  ST R6, saveR6
  ST R4, saveR4
  AND R6, R6, #0
  AND R4, R4, #0
  ADD R4, R4, R2  ; duplicate R2 so it remains unchanged
  Mult
    ADD R6, R6, R1
    ADD R4, R4, #-1
  BRp Mult
  ST R6, num_R
  LD R4, saveR4
  LD R6, saveR6
  RET

NumToASCII ; prints number in R1
  ST R7, saveR7
  LD R3, outputSize       ; load size into R3

  LEA R6, outputArray     ; load address of output into R6
  Convert_Loop
    LEA R5, constArray    ; load address of constArray -> R5
    ADD R3, R3, #-1       ; decrement size of num
    ADD R5, R5, R3        ; R5 <- R5 + R3
    LDR R2, R5, #0        ; load const from constArray at index R5
    LD R1, num_R          ; load the number into R1
    ST R3, saveR3
    ST R4, saveR4
    ST R5, saveR5
    ST R6, saveR6
    JSR Division          ; divide
    LD R3, saveR3
    LD R4, saveR4
    LD R5, saveR5
    LD R6, saveR6
    LD R0, convert_quot   ; load quotient into R0
    LD R5, num_remainder  ; load remainder into R5
    LD R4, plus30         ; load ASCII converter into R4
    ADD R0, R0, R4        ; Convert quotient into ASCII
    STR R0, R6, #0        ; store R0 (ASCII) into index at R6
    ADD R6, R6, #1        ; increment index at R6
    ADD R3, R3, #0        ; break on R3 (size)
    ST R5, num_R
    BRp Convert_Loop
  ADD R0, R0, #0
  ST R0, outputSize
  LD R7, saveR7
  RET

Division
  AND R3, R3, #0  ; init R3
  ADD R3, R1, #0  ; add X to R3
  AND R4, R4, #0  ; init Y
  ADD R4, R2, #0  ; add Y to R4
  AND R6, R6, #0  ; Quotient
  NOT R4, R4
  ADD R4, R4, #1  ; Invert R4
  Div
    ADD R3, R3, R4  ; X = X - Y
    BRn EndDiv
    ADD R6, R6, #1
    ST R3, num_remainder
    Br Div
  EndDiv
    ST R6, convert_quot     ; special case
  RET
; Variables
num_X         .FILL     #0
num_Y         .FILL     #0
num_temp      .FILL     #0
constArray    .FILL     #1
              .FILL     #10
              .FILL     #100
              .FILL     #1000
              .FILL     #10000
inputSize     .FILL     #0
saveR3        .FILL     #0
saveR4        .FILL     #0
saveR5        .FILL     #0
saveR6        .FILL     #0
saveR7        .FILL     #0
plus30        .FILL     x30
num_R         .FILL     #0
prompt1       .STRINGZ  "\nInput first number: "
prompt2       .STRINGZ  "\nInput second number: "
prompt3       .STRINGZ  "\nInput operation (+, -, *, /): "
result1       .STRINGZ  "\nResult = "
endStrg       .STRINGZ  "\nContinue? Yes = 0, No = 1: "
outputSize    .FILL     #0
outputQuot    .FILL     #0
outputArray   .BLKW     #5
convert_quot  .FILL     #0
num_remainder .FILL     #0
.END