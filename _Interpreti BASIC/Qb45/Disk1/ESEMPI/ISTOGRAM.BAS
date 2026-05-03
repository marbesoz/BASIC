' Definisce il tipo per i titoli:
TYPE TipoTitolo
   TitoloPrinc AS STRING * 40
   TitoloX AS STRING * 40
   TitoloY AS STRING * 18
END TYPE

DECLARE SUB TitoliInput (T AS TipoTitolo)
DECLARE FUNCTION TracciaGrafo$ (T AS TipoTitolo, Etich$(), Valore!(), N%)
DECLARE FUNCTION DatiInput% (Etich$(), Valore!())

' Dichiarazione delle variabili per i titoli e i dati delle barre:
DIM Titoli AS TipoTitolo, Etich$(1 TO 5), Valore(1 TO 5)

CONST FALSO = 0, VERO = NOT FALSO

DO
   TitoliInput Titoli
   N% = DatiInput%(Etich$(), Valore())
   IF N% <> FALSO THEN
      NuovoGrafo$ = TracciaGrafo$(Titoli, Etich$(), Valore(), N%)
   END IF
LOOP WHILE NuovoGrafo$ = "S"

END

'
' ========================= DatiInput ============================
'         Ottiene l'input per le etichette e i valori delle barre
' ================================================================
'
FUNCTION DatiInput% (Etich$(), Valore()) STATIC

   ' Inizializza il numero dei valori:
   NumDati% = 0

   ' Visualizza le istruzioni per l'immissione dei dati:
   CLS
   PRINT "Digitare i dati per non pió di cinque barre:"
   PRINT "   * Digitare l'etichetta e il valore per ogni barra."
   PRINT "   * I valori possono essere negativi."
   PRINT "   * Immettere un'etichetta vuota per terminare."
   PRINT
   PRINT "Dopo aver visionato il grafico, premere un tasto ";
   PRINT "per terminare il programma."

   ' Smette di leggere dopo 5 dati, oppure se Etich ä vuota:
   Fatto% = FALSO
   DO
      NumDati% = NumDati% + 1
      PRINT
      PRINT "Barra("; LTRIM$(STR$(NumDati%)); "):"
      INPUT ; "        Etichetta? ", Etich$(NumDati%)

      ' Legge Valore solo se Etich non ä vuota:
      IF Etich$(NumDati%) <> "" THEN
         LOCATE , 35
         INPUT "Valore? ", Valore(NumDati%)

      ' Se Etich ä vuota, decrementare il conteggio dei dati e
      ' impostare il valore della flag Fatto a VERO:
      ELSE
         NumDati% = NumDati% - 1
         Fatto% = VERO
      END IF
   LOOP UNTIL (NumDati% = 5) OR Fatto%

   ' Restituisce il numero di valori letti:
   DatiInput% = NumDati%

END FUNCTION

'
' ======================= TitoliInput ========================
'       Accetta l'input per tre diversi titoli del grafico
' ============================================================
'
SUB TitoliInput (T AS TipoTitolo) STATIC

   ' Imposta lo schermo in modalitÖ testo:
   SCREEN 0, 0

   ' Legge i titoli
   DO
      CLS
      INPUT "Digitare il titolo principale del grafico: ", T.TitoloPrinc
      INPUT "Digitare il titolo dell'ascissa          : ", T.TitoloX
      INPUT "Digitare il titolo dell'ordinata         : ", T.TitoloY

      ' Verifica che i titoli sono giusti:
      LOCATE 7, 1
      PRINT "Va bene ? (Sç per continuare, No per cambiare)";
      LOCATE , , 1
      OK$ = UCASE$(INPUT$(1))
   LOOP UNTIL OK$ = "S"
END SUB

'
' ========================== TracciaGrafo =========================
'   Disegna un istogramma con i dati letti dalle procedure
'   TitoliInput e DatiInput.
' ==============================================================
'
FUNCTION TracciaGrafo$ (T AS TipoTitolo, Etich$(), Valore(), N%) STATIC

   ' Imposta le dimensioni del grafico:
   CONST GRAFSUP = 24, GRAFINF = 171
   CONST GRAFSIN = 48, GRAFDES = 624
   CONST LUNGY = GRAFINF - GRAFSUP

   ' Calcola i valori massimo e minimo:
   MassY = 0
   MinY = 0
   FOR I% = 1 TO N%
      IF Valore(I%) < MinY THEN MinY = Valore(I%)
      IF Valore(I%) > MassY THEN MassY = Valore(I%)
   NEXT I%

   ' Calcola la larghezza delle barre e lo spazio intermedio:
   LargBar = (GRAFDES - GRAFSIN) / N%
   SpazBar = .2 * LargBar
   LargBar = LargBar - SpazBar

   SCREEN 2
   CLS

   ' Traccia l'ordinata:
   LINE (GRAFSIN, GRAFSUP)-(GRAFSIN, GRAFINF), 1

   ' Scrive il titolo principale:
   Inizio% = 44 - (LEN(RTRIM$(T.TitoloPrinc)) / 2)
   LOCATE 2, Inizio%
   PRINT RTRIM$(T.TitoloPrinc);

   ' Annota l'ordinata:
   Inizio% = CINT(13 - LEN(RTRIM$(T.TitoloY)) / 2)
   FOR I% = 1 TO LEN(RTRIM$(T.TitoloY))
      LOCATE Inizio% + I% - 1, 1
      PRINT MID$(T.TitoloY, I%, 1);
   NEXT I%

   ' Calcola il fattore di scala perchÇ le etichette non superino i 4 digit:
   IF ABS(MassY) > ABS(MinY) THEN
      Espon = MassY
   ELSE
      Espon = MinY
   END IF
   Espon = CINT(LOG(ABS(Espon) / 100) / LOG(10))
   IF Espon < 0 THEN Espon = 0

   ' Ridimensiona il minimo e il massimo:
   FattoreScala = 10 ^ Espon
   MassY = CINT(MassY / FattoreScala)
   MinY = CINT(MinY / FattoreScala)

   ' Se l'esponente non ä zero, visualizza sul grafico il fattore di scala:
   IF Espon <> 0 THEN
      LOCATE 3, 2
      PRINT "x 10^"; LTRIM$(STR$(Espon))
   END IF

   ' Mette una tacca e il valore numerico del massimo sull'ordinata:
   LINE (GRAFSIN - 3, GRAFSUP)-STEP(3, 0)
   LOCATE 4, 2
   PRINT USING "####"; MassY

   ' Mette una tacca e il valore numerico del minimo sull'ordinata:
   LINE (GRAFSIN - 3, GRAFINF)-STEP(3, 0)
   LOCATE 22, 2
   PRINT USING "####"; MinY

   ' Ridimensiona il minimo e il massimo per calcolare il display:
   MassY = MassY * FattoreScala
   MinY = MinY * FattoreScala

   ' Annota l'ascissa:
   Inizio% = 44 - (LEN(RTRIM$(T.TitoloX)) / 2)
   LOCATE 25, Inizio%
   PRINT RTRIM$(T.TitoloX);

   ' Calcola l'intervallo dei pixel per l'ordinata:
   IntervY = MassY - MinY

   ' Definisce un motivo a strisce diagonali:
   Casella$ = CHR$(1) + CHR$(2) + CHR$(4) + CHR$(8) + CHR$(16) + CHR$(32) + CHR$(64) + CHR$(128)

   ' Disegna una linea allo zero se ä appropriato:
   IF MinY < 0 THEN
      Basso = GRAFINF - ((-MinY) / IntervY * LUNGY)
      LOCATE INT((Basso - 1) / 8) + 1, 5
      PRINT "0";
   ELSE
      Basso = GRAFINF
   END IF

   ' Disegna l'ascissa:
   LINE (GRAFSIN - 3, Basso)-(GRAFDES, Basso)

   ' Disegna le barre e le etichette:
   Inizio% = GRAFSIN + (SpazBar / 2)
   FOR I% = 1 TO N%

      ' Disegna una etichetta di barra:
      CentroBarra = Inizio% + (LargBar / 2)
      CentroCaratt = INT((CentroBarra - 1) / 8) + 1
      LOCATE 23, CentroCaratt - INT(LEN(RTRIM$(Etich$(I%))) / 2)
      PRINT Etich$(I%);

      ' Disegna la barra e la colora con il motivo a strisce:
      AltezzaBarra = (Valore(I%) / IntervY) * LUNGY
      LINE (Inizio%, Basso)-STEP(LargBar, -AltezzaBarra), , B
      PAINT (CentroBarra, Basso - (AltezzaBarra / 2)), Casella$, 1

      Inizio% = Inizio% + LargBar + SpazBar
   NEXT I%

   LOCATE 1, 1, 1
   PRINT "Nuovo grafico? ";
   TracciaGrafo$ = UCASE$(INPUT$(1))

END FUNCTION

