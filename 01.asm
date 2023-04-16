        .ORG    $0010
LOOP    LW      r1, r0, SUM     ;load sum[0] -> r1
        ADDI    r3, r0, $1      ;1 -> r3
        LW      r2, r3, SUM     ;load sum[1] -> r2
        LW      r4, r0, i       ;load i -> r4
        SLLI    r4, r4, $1      ;multiply i by 2    
        LW      r5, r4, ARRAY   ;load ARRAY[i] -> r5
        ADDI    r4, r4, $2      ;add 2 to i
        LW      r6, r4, ARRAY   ;load ARRAY[i+1] -> r6
        ADD     r1, r1, r5      ;sum[0]+=ARRAY[i]
        ADD     r2, r2, r6      ;sum[1]+=ARRAY[i+1]
        BRC     CARRY           ;if lower 16 carry
        BRA     NEXT            ;else skip
CARRY   ADDI    r1, r1, $1      ;add 1 to upper 16
NEXT    SW      r1, r0, SUM     ;write back sum[0]
        SW      r2, r3, SUM     ;write back sum[1]
        SRAI    r4, r4, $1      ;divide i by 2 to convert back to index
        ADDI    r4, r4, $2      ;increment i
        SW      r4, r0, i       ;write back i
CHECK   LW      r3, r0, LENGTH
        SLLI    r3, r3, $1      ;LENGTH*2
        SLTI    r0, r4, r3      ;check i < LENGTH*2
        BRN     LOOP            ;keep looping if i<LENGTH*2 
        STOP

i       .DW     $0              ;initial value of i
SUM     .DW     $0              ;initial value of sum[0]
        .DW     $0              ;initial value of sum[1]
LENGTH  .DW     $00FF           ;placeholder
ARRAY   .ORG    $3000

