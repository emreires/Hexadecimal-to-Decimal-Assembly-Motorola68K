*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

 MOVE.W #$000000CC, D7


* Credits: 
* https://www.microchip.com/forums/m24484.aspx (BRA)
* 

HEX2DEC:          
 MOVE.W #$0001, D0 ; We are setting 1 to D0.
 MOVE.W #$0000, D1 ; D1 will be our counter.
 MOVE.W D7, D3 ; For make D7 clear and put our decimal in the end to D7, we will copy our hexadecimal to D3.
 MOVE.W #$0000, D7 ; Make D7 clear
 SUB.W #$0001, D3 ; Set BCD adder to 1.
 
 
* ABCD example from PDF:
* [destination]10 ‹ [source]10 + [destination]10 + [X]
 
HEX2DECLOOP:
 CMPI.B #$99, D1 ; Compare the D1 with 99
 BEQ BCDOVERFLOW ; If D1 == 99, jump to BCDOVERFLOW
 ABCD D0, D1 ; Add binary coded to decimal
 

BCD_RET:
 DBF D3, HEX2DECLOOP
 * IF(condition false)
 * THEN [Dn] ‹ [Dn] - 1 {decrement loop counter}
 * IF [Dn] = -1 THEN [PC] ‹ [PC] + 2 {fall through to next instruction}
 * ELSE [PC] ‹ [PC] + d {take branch}
 * ELSE [PC] ‹ [PC] + 2 {fall through to next instruction}
 BRA END_BCD
 
BCDOVERFLOW:
 ABCD D0,D7 ; Count number of times we hit 99
 MOVE.W #$0000, D1 ; Make D1 clear (our first counter)
 BRA BCD_RET
 
 
END_BCD:
 LSL.W #$08, D7 ; Create some room for 8 bits to make in D7 space
 EOR.W D1, D7 ; Combine the overflow register with the main register


* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
