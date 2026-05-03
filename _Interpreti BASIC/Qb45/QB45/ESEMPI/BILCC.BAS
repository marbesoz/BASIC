DEFDBL A-Z
DIM Quantit(1 TO 100)
CONST FALSO = 0, VERO = NOT FALSO

' Ottiene il bilancio iniziale del conto:
CLS
INPUT "Digitare il bilancio iniziale e premere <INVIO>: ", Bilancio

' Ottiene operazioni. Continua ad accettare input finch‚ l'input
' non Š zero per un'operazione, fino a un limite di 100
' operazioni:
FOR NumOperaz% = 1 TO 100
   PRINT NumOperaz%;
   PRINT ") Digitare il valore dell'operazione, o 0 per uscire"
   PRINT "     (numero positivo = deposito, negativo = prelievo). ";
   INPUT "", Quantit(NumOperaz%)
   PRINT
   IF Quantit(NumOperaz%) = 0 THEN
      NumOperaz% = NumOperaz% - 1
      EXIT FOR
   END IF
NEXT

' Ordina le operazioni in ordine crescente,
' usando un ordinamento per permutazioni:
Limite% = NumOperaz%
DO
   Scambi% = FALSO
   FOR I% = 1 TO (Limite% - 1)

      ' Se due elementi adiacenti non sono in ordine, permutarli:
      IF Quantit(I%) < Quantit(I% + 1) THEN
         SWAP Quantit(I%), Quantit(I% + 1)
         Scambi% = I%
      END IF
   NEXT I%

   ' Al passaggio successivo, non ordinare oltre il punto
   '  dell'ultima permutazione:
   IF Scambi% THEN Limite% = Scambi%

' Ordina finch‚ non avvengono pi— permutazioni:
LOOP WHILE Scambi%

' Stampa la matrice ordinata delle operazioni. Se un'operazione
' Š maggiore di zero, rappresentarla come "ATTIVO"; se Š
' minore di zero, rappresentarla come "PASSIVO":
FOR I% = 1 TO NumOperaz%
   IF Quantit(I%) > 0 THEN
      PRINT USING "ATTIVO:           L.  ########"; Quantit(I%)
   ELSEIF Quantit(I%) < 0 THEN
      PRINT USING "PASSIVO:          L.  ########"; Quantit(I%)
   END IF

   ' Aggiorna il bilancio:
   Bilancio = Bilancio + Quantit(I%)
NEXT I%

' Stampa il bilancio finale:
PRINT
PRINT "------------------------------"
PRINT USING "Bilancio finale:  L. #########"; Bilancio
END

