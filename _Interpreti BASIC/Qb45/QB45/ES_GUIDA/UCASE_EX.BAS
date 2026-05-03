DECLARE FUNCTION RispPos% (Prompt$, Riga%, Col%)
'
' *** UCASE_EX.BAS -- Programma esempio per la funzione UCASE$
'
DEFINT A-Z

DO
LOOP WHILE NOT RispPos("Conosci la frequenza?", 12, 5)

FUNCTION RispPos (Prompt$, Riga, Col) STATIC
   RigaOrig = CSRLIN
   ColOrig = POS(0)
   ' Stampa il prompt alla posizione Riga, Col.
   LOCATE Riga, Col: PRINT Prompt$; "(Sç/No):";
   DO
      ' Fa premere un tasto all'utente.
      DO
	 Risp$ = INKEY$
      LOOP WHILE Risp$ = ""
      Risp$ = UCASE$(Risp$)
      ' Prova se ä sç o no.
      IF Risp$ = "S" OR Risp$ = "N" THEN
	 EXIT DO
      ELSE
	 BEEP
      END IF
   LOOP
   ' Stampa la risposta sulla riga.
   PRINT Risp$;
   ' Rimette il cursore alla posizione originaria.
   LOCATE RigaOrig, ColOrig
   ' Restituisce un valore Booleano come risultato della prova.
   RispPos = (Risp$ = "S")
END FUNCTION

