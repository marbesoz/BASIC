' *** DEFSG_EX.BAS ***
'
DECLARE SUB BlocMaius ()
DECLARE SUB SblocMaius ()
DECLARE SUB StampMsg (R%, C%, M$)

CLS
BlocMaius
StampMsg 24, 1, "<BLOC MAIUS>"
LOCATE 12, 10
LINE INPUT "Digitare una stringa (i caratteri sono in maiuscolo): ", S$
SblocMaius
StampMsg 24, 1, "              "
StampMsg 25, 1, "Premere un tasto per continuare..."
DO WHILE INKEY$ = "": LOOP
CLS
END

SUB BlocMaius STATIC
' Attiva il blocco delle maiuscole
   ' Imposta il segmento nella parte bassa della memoria
   DEF SEG = 0
   ' Attiva BLOC MAIUSC (attiva il bit 6 di &H0417)
   POKE &H417, PEEK(&H417) OR &H40
   ' Ripristina il segmento
   DEF SEG
END SUB

SUB SblocMaius STATIC
' Disattiva il blocco delle maiuscole
   DEF SEG = 0
   ' Disattiva BLOC MAIUSC (disattiva il bit 6 di &H0417)
   POKE &H417, PEEK(&H417) AND &HBF
   DEF SEG
END SUB

SUB StampMsg (Riga%, Col%, Mess$) STATIC
' Stampa il messaggio alla Riga% e Col% senza spostare il cursore
   ' Salva la posizione del cursore
   RigaCorr% = CSRLIN: ColCorr% = POS(0)
   LOCATE Riga%, Col%: PRINT Mess$;
   ' Ripristina il cursore
   LOCATE RigaCorr%, ColCorr%
END SUB

