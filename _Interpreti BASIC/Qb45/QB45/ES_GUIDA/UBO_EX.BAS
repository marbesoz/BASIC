DECLARE SUB STAMPAMATR (A!())
'
' *** UBO_EX.BAS - Programma esempio per UBOUND e LBOUND
'
DIM A(0 TO 3, 0 TO 3)
FOR I% = 0 TO 3
    FOR J% = 0 TO 3
	A(I%, J%) = I% + J%
    NEXT J%
NEXT I%
CALL STAMPAMATR(A())
END

SUB STAMPAMATR (A()) STATIC
    FOR I% = LBOUND(A, 1) TO UBOUND(A, 1)
	FOR J% = LBOUND(A, 2) TO UBOUND(A, 2)
	   PRINT A(I%, J%); " ";
	NEXT J%
    PRINT : PRINT
    NEXT I%
END SUB

