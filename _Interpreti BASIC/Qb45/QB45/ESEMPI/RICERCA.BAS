DEFLNG A-Z              ' Il tipo di variabile predefinito Š intero lungo.
LINE INPUT "File in cui cercare: ", NomeFile$
LINE INPUT "Stringa da trovare: ", StrTrov$
OPEN NomeFile$ FOR BINARY AS #1

CONST DIMBLOCCO = 10000, VERO = -1
LunStringa% = LEN(StrTrov$)
LunFile = LOF(1)
ByteRiman = LunFile
FileOffset = 0

' Continua la ricerca finch‚ il numero di byte rimanenti nel file
' Š maggiore della lunghezza della stringa da trovare:
DO WHILE ByteRiman > LunStringa%

   ' Legge o 10000 byte o tutti i byte rimanenti nel file (se sono
   ' meno di 10000), e li registra in Buffer$. Se il numero dei byte
   ' rimanenti Š minore di DIMBLOCCO, la seguente istruzione legge
   ' ugualmente solo i byte rimanenti senza messaggi di errore, perch‚
   ' l'I/O binario non cerca di leggere oltre la fine del file:
   Buffer$ = INPUT$(DIMBLOCCO, #1)

   ' Trova ogni istanza della stringa in Buffer$:
   Inizio% = 1
   DO
      PosStringa% = INSTR(Inizio%, Buffer$, StrTrov$)
      IF PosStringa% > 0 THEN

         ' Ha trovato la stringa, quindi stampa la posizione nel file
         ' del byte in cui la stringa ha inizio:
         PRINT "Stringa trovata al byte numero";
         PRINT FileOffset + PosStringa%
         Inizio% = PosStringa% + 1
         Trovata% = VERO
      END IF
   LOOP WHILE PosStringa% > 0

   ' Punta sul byte dove avverrebbe la successiva operazione di I/O, poi fa
   ' retrocedere il puntatore del file una distanza pari alla lunghezza
   ' della stringa, nel caso la stringa sia a cavallo del limite del buffer:
   FileOffset = SEEK(1) - LunStringa%
   SEEK #1, FileOffset + 1

   ByteRiman = LunFile - FileOffset
LOOP

CLOSE #1

IF NOT Trovata% THEN PRINT "Stringa non trovata."

