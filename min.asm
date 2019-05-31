.ORIG x3000
LDI R1, TS1
LDI R2, TS2
LDI R3, TS3
LDI R4, TS4
LDI R5, TS5


  NOT R2, R2
  ADD R2, R2, #1    ; R0 = R1 - R2
  ADD R0, R1, R2    ; if negative, R1 is the target. If positive, R2 is the target
  BRn MIN1V3        ; if R1 is target, go to MINI1V3 (Minimum Branch 1 Versus 3)
  BRp MIN2V3        ; if R1 is target, go to MINI2V3

MIN1V3  
  NOT R3, R3
  ADD R3, R3, #1
  ADD R0, R1, R3  ; R0 = R1 - R3
  BRn MIN1V4
  BRp MIN3V4

MIN1V4
  NOT R4, R4
  ADD R4, R4, #1
  ADD R0, R1, R4
  BRn MIN1V5
  BRp MIN4V5
  
MIN1V5
  NOT R5, R5
  ADD R5, R5 #1
  ADD R0, R1, R5
  BRn TS1MIN
  BRp TS5MIN
  
MIN2V3
  NOT R3, R3
  ADD R3, R3, #1
  ADD R0, R2, R3
  BRn MIN2V4
  BRp MIN3V4
  
MIN2V4
  NOT R4, R4
  ADD R4, R4 #1
  ADD R0, R2, R4
  BRn MIN2V5
  BRp MIN4V5
  
MIN2V5
  NOT R5, R5
  ADD R5, R5, #1
  ADD R0, R2, R5
  BRn TS2MIN
  BRp TS5MIN
  
MIN3V4
  NOT R4, R4
  ADD R4, R4, #1
  ADD R0, R3, R4
  BRn MIN3V5
  BRp MIN4V5
  
MIN3V5
  NOT R5, R5
  ADD R5, R5, #1
  ADD R0, R3, R5
  BRn TS3MIN
  BRp TS5MIN
  
MIN4V5
  NOT R5, R5
  ADD R5, R5, #1
  ADD R0, R4, R5
  BRn TS4MIN
  BRp TS5MIN
  
TS1MIN
  STI MIN, R1
TS2MIN
  STI MIN, R2
TS3MIN
  STI MIN, R3
TS4MIN
  STI MIN, R4
TS5MIN
  STI MIN, R5

TS1     .FILL x3200
TS2     .FILL x3201
TS3     .FILL x3202
TS4     .FILL x3203
TS5     .FILL x3204
MIN     .FILL x3205
MAX     .FILL x3206
AVG     .FILL x3207

MINZ   .STRINGZ "The minimum value is: "
MAXZ   .STRINGZ "The maximum value is: "
AVGZ   .STRINGZ "The average value is: "




;Experimental MIN procedure
;non-operational
;.ORIG x3000
;
;LDI R1, TS1
;LDI R2, TS2
;LDI R3, TS3
;LDI R4, TS4
;LDI R5, TS5
;
;FINDMIN
;  ADD R1, R1, #-1
;  BRz GIVEMIN1
;  ADD R2, R2, #-1
;  BRz GIVEMIN2
;  ADD R3, R3, #-1
;  BRz GIVEMIN3
;  ADD R4, R4, #-1
;  BRz GIVEMIN4
;  ADD R5, R5, #-1
;  BRz GIVEMIN5
;  BR FINDMIN
;  
;GIVEMIN1
;  STI R1, MIN
;  PUTS MINZ
;GIVEMIN2
;  STI R2, MIN
;  PUTS MINZ
;GIVEMIN3
;  STI R3, MIN
;  PUTS MINZ
;GIVEMIN4
;  STI R4, MIN
;  PUTS MINZ
;GIVEMIN5
;  STI R5, MIN
;  PUTS MINZ
;  PUT MIN
;
;TS1     .FILL x3200
;TS2     .FILL x3201
;TS3     .FILL x3202
;TS4     .FILL x3203
;TS5     .FILL x3204
;MIN     .FILL x3205
;MAX     .FILL x3206
;AVG     .FILL x3207
;
;MINZ   .STRINGZ "The minimum value is: "
;MAXZ   .STRINGZ "The maximum value is: "
;AVGZ   .STRINGZ "The average value is: "
