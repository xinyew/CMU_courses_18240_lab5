; r1 used to store loop number
; r2 used for indexing
; r2 for rd
; r5 for rs1 
; r7 for rs2

            .ORG    $0010
            LW      r1, r0, LENGTH  ; loop counter
            ADD     r1, r1, r1      ; loop counter *= 2
            ADD     r1, r1, r1      ; loop counter *= 2
            LI      r2, $0          ; indexing
            LI      r6, $0
            LI      r7, $0

LOOP        SLT     r0, r1, r2
            BRZ     DONE

LOAD        LW      r5, r2, ARRAY
            ADDI    r2, r2, $2
            LW      r4, r2, ARRAY
CALC        .DW     ADD32
            ADDI    r2, r2, $2

            BRA     LOOP


DONE        SW      r0, r7, SUM
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

ADD32       .EQU     $65B4



