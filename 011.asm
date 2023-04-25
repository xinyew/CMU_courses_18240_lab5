; r1 used to store loop number
; r2 used for indexing
; r3 tmp var for storing array elemenets
; r4 used for store ARRAY + r2 + 1
; r5 used for storing carry bits
; r6 used for storing lower 16bit
; r7 used for storing higher 16bit

            .ORG    $0010
            LW      r1, r0, LENGTH  ; loop counter
            ADD     r1, r1, r1      ; loop counter *= 2
            ADD     r1, r1, r1      ; loop counter *= 2
            LI      r2, $0          ; indexing
            LI      r5, $0          ; carry bits
            LI      r6, $0          ; lower part
            LI      r7, $0          ; higher part

LOOP        SLT     r0, r1, r2
            BRZ     DONE

HIGHER      LW      r3, r2, ARRAY
            ADD     r7, r7, r3

LOWER       MV      r4, r2
            ADDI    r4, r4, $2
            LW      r3, r4, ARRAY
            ADD     r6, r6, r3
            BRC     CAR
            BRA     NEXT

CAR         ADDI    r5, r5, $1

NEXT        ADDI    r2, r2, $4
            BRA     LOOP


DONE        ADD     r7, r7, r5
            SW      r0, r7, SUM
            ADDI    r4, r0, $2
            SW      r4, r6, SUM
            STOP

            .ORG    $5000
LENGTH      .DW     $3
            .ORG    $6000
SUM         .DW     $0000
            .DW     $0000
            .ORG    $1234
ARRAY       .DW     $FFFF
            .DW     $FFFF
            .DW     $FFFF
            .DW     $FFFF
            .DW     $FFFF
            .DW     $FFFF
            .DW     $f0f0
            .DW     $f0f0
            .DW     $0000
            .DW     $0000
            .DW     $0000
            .DW     $0000
            .DW     $0000
            .DW     $0000
            .DW     $0000


