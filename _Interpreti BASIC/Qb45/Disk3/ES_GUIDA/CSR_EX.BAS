DECLARE SUB ScrMsSenzaSpos (Msg$, Riga%, Col%)
'
' *** CSR_EX.BAS - Programma esempio per l'istruzione CSRLIN
'
' Sposta il cursore al centro dello schermo e scrive un messaggio;
' poi riporta il cursore al centro dello schermo.
   CLS
   LOCATE 12, 40
   CALL ScrMsSenzaSpos("Un messaggio da non perdere.", 9, 35)
   INPUT "Digitare qualunque cosa: ", A$

' Stampa un messaggio senza cambiare la posizione corrente del cursore.
SUB ScrMsSenzaSpos (Msg$, Riga%, Col%) STATIC

   ' Salva la riga corrente.
   RigaCorr% = CSRLIN
   ' Salva la colonna corrente.
   ColCorr% = POS(0)
   ' Stampa il messaggio nella posizione assegnata.
   LOCATE Riga%, Col%: PRINT Msg$;
   ' Riporta il cursore alla posizione originaria.
   LOCATE RigaCorr%, ColCorr%

END SUB

