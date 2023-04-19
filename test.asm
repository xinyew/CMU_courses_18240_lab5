ADD32_1     .EQU     $6453
            .ORG     $5000
            .DW      ADD32_1
ADD32       .EQU     $32
            .DW      ADD32 r3,r2,r1
