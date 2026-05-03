DECLARE SUB Conv (D%, Nb%)
'
' *** SHARE_EX.BAS - Programma esempio per l'istruzione SHARED
'
DEFINT A-Z
DO
   INPUT "Numero in base decimale (digitare un numero <= 0 per uscire): ", Dec
   IF Dec <= 0 THEN EXIT DO
   INPUT "Nuova base (un numero > 1): ", NuovaBase
   N$ = ""
   PRINT Dec; "in base 10 Š uguale a ";
   DO WHILE Dec > 0
      CALL Conv(Dec, NuovaBase)
      Dec = Dec \ NuovaBase
   LOOP
   PRINT N$; " in base"; NuovaBase
   PRINT
LOOP

SUB Conv (D, Nb) STATIC
SHARED N$
   ' Usa il resto per determinare il valore della cifra corrente
   R = D MOD Nb
   ' Se la cifra Š minore di dieci la restituisce (0...9);
   ' se no restituisce una lettera (A...Z).
   IF R < 10 THEN Cifra$ = CHR$(R + 48) ELSE Cifra$ = CHR$(R + 55)
   N$ = RIGHT$(Cifra$, 1) + N$
END SUB

