'
' *** COM2_EX.BAS - Programma esempio per l'istruzione COMMON
'
DIM X(1 TO 50)
COMMON X(), N

PRINT
PRINT "Esecuzione del file COM2_EX.BAS, raggiunto via un comando CHAIN..."
IF N > 0 THEN
   Somma = 0
   FOR I = 1 TO N
      Somma = Somma + X(I)
   NEXT I
   PRINT "La media dei valori Š"; Somma / N
END IF

