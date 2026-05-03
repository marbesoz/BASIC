DEFINT A-Z

DECLARE SUB Filtro (StringaIn$)

COLOR 7, 1                        ' Imposta il colore dello schermo.
CLS

Uscita$ = CHR$(0) + CHR$(22)      ' Valore restituito da INKEY$
                                  ' alla pressione di ALT+u.

' Posiziona il prompt all'ultima riga dello schermo e attiva il cursore:
LOCATE 24, 1, 1
PRINT STRING$(80, "_");
LOCATE 25, 1
PRINT TAB(30); "Premere ALT+u per uscire";

VIEW PRINT 1 TO 23                ' Stampa tra le righe 1 e 23.

' Apre la porta di comunicazione (1200 baud, nessuna parit…, dati a 8 bit,
' 1 bit di stop, buffer per l'input di 256 byte):
OPEN "COM1:1200,N,8,1" FOR RANDOM AS #1 LEN = 256

DO                                ' Ciclo di comunicazioni principale.

   TastoInput$ = INKEY$           ' Controlla lo schermo.

   IF TastoInput$ = Uscita$ THEN  ' Esce dal ciclo se l'utente ha
      EXIT DO                     ' premuto ALT+q.

   ELSEIF TastoInput$ <> "" THEN  ' Se no, se l'utente ha premuto
      PRINT #1, TastoInput$;      ' un tasto, lo invia al modem.
   END IF

   ' Controlla il modem. Se ci sono caratteri in attesa (EOF(1) Š
   ' vero), li legge e li stampa sullo schermo:
   IF NOT EOF(1) THEN

      ' LOC(1) restituisce il numero dei caratteri in attesa:
      ModemInput$ = INPUT$(LOC(1), #1)

      Filtro ModemInput$          ' Filtra i caratteri di interlinea e
      PRINT ModemInput$;          ' di ritorno unitario, poi stampa.
   END IF
LOOP

CLOSE                             ' Chiude le communicazioni.
CLS
END

'
' ========================= FILTRO ==========================
'     Filtra i caratteri nella stringa di input.
' ============================================================
'
SUB Filtro (StringaIn$) STATIC

   ' Cerca i caratteri di ritorno unitario e li sostituisce con
   ' CHR$(29) (la freccia SINISTRA):
   DO
      RitUn = INSTR(StringaIn$, CHR$(8))
      IF RitUn THEN
         MID$(StringaIn$, RitUn) = CHR$(29)
      END IF
   LOOP WHILE RitUn

   ' Cerca i caratteri di interlinea e li elimina:
   DO
      InterLin = INSTR(StringaIn$, CHR$(10))
      IF InterLin THEN
         StringaIn$ = LEFT$(StringaIn$, InterLin - 1) + MID$(StringaIn$, InterLin + 1)
      END IF
   LOOP WHILE InterLin

END SUB

