DEFINT A-Z         ' Il tipo predefinito di variabile Š intero

DECLARE SUB ScorrePalette ()
DECLARE SUB ValFinestra (LS%, LD%, LA%, LB%)
DECLARE SUB ProvaSchermo (ME%, GC%, FS%, FD%, FA%, FB%)

CONST FALSO = 0, VERO = NOT FALSO       ' Costanti booleane

' Imposta il numero massimo di iterazioni per ogni punto:
CONST LIMCICLO = 30, LIMDIMENS = 1000000

DIM MatrPalette(15)
FOR I = 0 TO 15: MatrPalette(I) = I: NEXT I

' Chiama ValFinestra per stabilire le coordinate logiche della finestra:
ValFinestra LSin, LDes, LAlt, LBas

' Chiama ProvaSchermo per stabilire se il computer Š dotato di EGA, e per
' ottenere le coordinate fisiche degli angoli della finestra:
ProvaSchermo ModEga, GammaColori, FSin, FDes, FAlt, FBas

' Definisce la finestra con le corrispondenti coordinate fisiche e logiche:
VIEW (FSin, FAlt)-(FDes, FBas), 0, GammaColori
WINDOW (LSin, LAlt)-(LDes, LBas)

LOCATE 24, 10: PRINT "Premere un tasto per terminare.";

LungX = FDes - FSin
LungY = FBas - FAlt
LargColori = LIMCICLO \ GammaColori

' Esamina ogni pixel della finestra e calcola se
' appartiene all'insieme di Mandelbrot:
FOR Y = 0 TO LungY         ' Il ciclo esterno esamina ogni riga
                           ' della finestra.
   LogicY = PMAP(Y, 3)     ' Ottiene la coordinata logica y del pixel.
   PSET (LSin, LogicY)     ' Traccia il pixel pi— a sinistra della riga.
   ColPrec = 0            ' Comincia col colore di sfondo.

   FOR X = 0 TO LungX      ' Questo ciclo esamina ogni pixel della riga.
      LogicX = PMAP(X, 2)  ' Ottiene la coordinata logica x del pixel.
      MandelX& = LogicX
      MandelY& = LogicY

      ' Calcola se il punto appartiene all'insieme di Mandelbrot:
      FOR I = 1 TO LIMCICLO
         NumReal& = MandelX& * MandelX&
         NumImag& = MandelY& * MandelY&
         IF (NumReal& + NumImag&) >= LIMDIMENS THEN EXIT FOR
         MandelY& = (MandelX& * MandelY&) \ 250 + LogicY
         MandelX& = (NumReal& - NumImag&) \ 500 + LogicX
      NEXT I

      ' Assegna un colore al punto:
      ColPunto = I \ LargColori

      ' Se il colore Š cambiato, traccia una linea dal precedente
      ' punto di riferimento al nuovo punto, usando il precedente
      ' colore:
      IF ColPunto <> ColPrec THEN
         LINE -(LogicX, LogicY), (GammaColori - ColPrec)
         ColPrec = ColPunto
      END IF

      IF INKEY$ <> "" THEN END
   NEXT X

   ' Traccia l'ultimo segmento fino al bordo destro della finestra:
   LINE -(LogicX, LogicY), (GammaColori - ColPrec)

   ' Se il computer Š dotato di EGA, fa scorrere la palette dopo
   ' aver tracciato il segmento:
   IF ModEga THEN ScorrePalette
NEXT Y

DO
   ' Continua a far scorrere la palette finch‚ l'utente non
   ' preme un tasto:
   IF ModEga THEN ScorrePalette
LOOP WHILE INKEY$ = ""

SCREEN 0, 0             ' Ripristina lo schermo in modalit… testo
WIDTH 80                ' a 80 colonne.
END

SchermoInf:             ' Gestore di errori chiamato se il computer non
   ModEga = FALSO       ' Š dotato di scheda grafica EGA
   RESUME NEXT

'
' ======================== ProvaSchermo =================================
'    Con il comando SCREEN 0, controlla se il computer Š dotato di EGA.
'    Se questo causa un errore, il flag ME viene impostato su FALSO e
'    lo schermo viene impostato con SCREEN 1.
'
'    Imposta poi i valori delle coordinate fisiche degli angoli della
'    finestra (FS = sinistro, FD = destro, FA = alto, FB = basso), tenendo
'    conto del rapporto delle dimensioni per ottenere una finestra quadrata.
' ========================================================================
'
SUB ProvaSchermo (ME, GC, FS, FD, FA, FB) STATIC
   ME = VERO
   ON ERROR GOTO SchermoInf
   SCREEN 8, 1
   ON ERROR GOTO 0

   IF ME THEN           ' Nessun errore, SCREEN 8 va bene
      FS = 110: FD = 529
      FA = 5: FB = 179
      GC = 15           ' 16 colori (0 - 15)

   ELSE                 ' Errore, usare SCREEN 1
      SCREEN 1, 1
      FS = 55: FD = 264
      FA = 5: FB = 179
      GC = 3            ' 4 colori (0 - 3)
   END IF

END SUB

'
' ======================= ScorrePalette =======================
' Fa scorrere la palette di un colore ogni chiamata.
' ============================================================
'
SUB ScorrePalette STATIC
   SHARED MatrPalette(), GammaColori

   FOR I = 1 TO GammaColori
      MatrPalette(I) = (MatrPalette(I) MOD GammaColori) + 1
   NEXT I
   PALETTE USING MatrPalette(0)

END SUB

'
' ======================== ValFinestra =================================
'     Legge le coordinate logiche degli angoli della finestra digitate
'     dall'utente, o imposta i valori predefiniti in mancanza di input.
' ======================================================================
'
SUB ValFinestra (LS, LD, LA, LB) STATIC
   CLS
   PRINT "Questo programma visualizza una immagine grafica dell'intero"
   PRINT "insieme di Mandelbrot. La finestra predefinita va da (-1000,625)"
   PRINT "a (250,-625). Per vedere un ingrandimento di una parte del"
   PRINT "grafico, digitarne le rispettive coordinate."
   PRINT
   PRINT "Premere <INVIO> per usare la finestra predefinita. Premere"
   PRINT "un altro tasto per impostare coordinate diverse: ";
   LOCATE , , 1
   Risp$ = INPUT$(1)

   ' L'utente non ha premuto INVIO, quindi legge le coordinate logiche
   ' della finestra:
   IF Risp$ <> CHR$(13) THEN
      PRINT
      INPUT "Coordinata X dell'angolo in alto a sinistra: ", LS
      DO
         INPUT "Coordinata X dell'angolo in basso a destra: ", LD
         IF LD <= LS THEN
         PRINT "L'angolo destro deve essere maggiore di quello sinistro."
         END IF
      LOOP WHILE LD <= LS
      INPUT "Coordinata Y dell'angolo in alto a sinistra: ", LA
      DO
         INPUT "Coordinata Y dell'angolo in basso a destra: ", LB
         IF LB >= LA THEN
         PRINT "L'angolo in basso deve essere minore di quello in alto."
         END IF
      LOOP WHILE LB >= LA

   ELSE         ' L'utente ha premuto INVIO; imposta i valori predefiniti.
      LS = -1000
      LD = 250
      LA = 625
      LB = -625
   END IF
END SUB

