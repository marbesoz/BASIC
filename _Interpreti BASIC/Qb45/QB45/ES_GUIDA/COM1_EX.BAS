'
' *** COM1_EX.BAS - Programma esempio per l'istruzione COMMON
'
DIM Valori(1 TO 50)
COMMON Valori(), NumValori

PRINT "Digitare i valori uno per riga. Digitare 'FINE' per uscire."
NumValori = 0
DO
   INPUT "-> ", N$
   IF I >= 50 OR UCASE$(N$) = "FINE" THEN EXIT DO
   NumValori = NumValori + 1
   Valori(NumValori) = VAL(N$)
LOOP
PRINT "Uscita da COM1_EX.BAS per concatenare a COM2_EX.BAS"
PRINT "Premere un tasto per concatenare... "
DO WHILE INKEY$ = ""
LOOP

CHAIN "com2_ex"

