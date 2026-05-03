DECLARE SUB DisegnaMotivo ()
DECLARE SUB ModificaMotivo ()
DECLARE SUB Inizializza ()
DECLARE SUB MostraMotivo (OK$)

DIM Bit%(0 TO 7), Motivo$, Esc$, DimensMotivo%

DO
   Inizializza
   ModificaMotivo
   MostraMotivo OK$
LOOP WHILE OK$ = "S"

END

'
' ======================== DisegnaMotivo ===================================
'    Disegna un rettangolo contenente un motivo sulla destra dello schermo
' ==========================================================================
'
SUB DisegnaMotivo STATIC
SHARED Motivo$

   VIEW (320, 24)-(622, 150), 0, 1  ' Visualizza solo il rettangolo.
   PAINT (1, 1), Motivo$            ' Lo colora con PAINT.
   VIEW                             ' Visualizza l'intero schermo.

END SUB

'
' ======================== Inizializza ========================
'               Imposta lo schermo e il motivo di partenza
' =============================================================
'
SUB Inizializza STATIC
SHARED Motivo$, Esc$, Bit%(), DimensMotivo%

   Esc$ = CHR$(27)              ' Il carattere ESC ä ASCII 27.

   ' Imposta una matrice contenente bit nelle posizioni da 0 a 7:
   FOR I% = 0 TO 7
      Bit%(I%) = 2 ^ I%
   NEXT I%

   CLS

   ' Legge le dimensioni del motivo (in numero di byte):
   LOCATE 5, 5
   PRINT "Digitare le dimensioni del motivo (1-16 righe):";
   DO
      LOCATE 5, 53
      PRINT "    ";
      LOCATE 5, 53
      INPUT "", DimensMotivo%
   LOOP WHILE DimensMotivo% < 1 OR DimensMotivo% > 16

   ' Accende tutti i bit come motivo iniziale:
   Motivo$ = STRING$(DimensMotivo%, 255)

   SCREEN 2                ' ModalitÖ grafica monocolore 640 x 200.

   ' Traccia le linee divisorie:
   LINE (0, 10)-(635, 10), 1
   LINE (300, 0)-(300, 152)
   LINE (302, 0)-(302, 152)

   ' Stampa i titoli:
   LOCATE 1, 11: PRINT "Byte del motivo"
   LOCATE 1, 47: PRINT "Visualizzazione del motivo"

   ' Traccia la finestra per modifiche al motivo:
   FOR I% = 1 TO DimensMotivo%

      ' Stampa l'etichetta alla sinistra di ogni riga:
      LOCATE I% + 3, 8
      PRINT USING "##:"; I%

      ' Disegna le caselle dei "bit":
      X% = 80
      Y% = (I% + 2) * 8
      FOR J% = 1 TO 8
         LINE (X%, Y%)-STEP(13, 6), 1, BF
         X% = X% + 16
      NEXT J%
   NEXT I%

   DisegnaMotivo                  ' Traccia il rettangolo per la
                                  ' visualizzazione del motivo.
   LOCATE 21, 1
   PRINT "I tasti di DIREZIONE.....................................Spostano il cursore"
   PRINT "La BARRA SPAZIATRICE........................................Cambia il colore"
   PRINT "Il tasto INVIO..........................................Visualizza il motivo"
   PRINT "Il tasto ESC.............................................Termina la sessione";

END SUB

'
' ======================== ModificaMotivo =======================
'                  Modifica un motivo di caselle-byte
' ===============================================================
'
SUB ModificaMotivo STATIC
SHARED Motivo$, Esc$, Bit%(), DimensMotivo%

   NumByte% = 1         ' Posizione di partenza.
   NumBit% = 7
   Null$ = CHR$(0)      ' CHR$(0) ä il primo byte della stringa
                        ' a due byte restituita quando viene premuto
                        ' un tasto di direzione come SU o GIU'.
   DO

      ' Calcola la posizione di partenza sullo schermo di questo bit:
      X% = ((7 - NumBit%) * 16) + 80
      Y% = (NumByte% + 2) * 8

      ' Aspetta la pressione di un tasto (e fa lampeggiare
      ' il cursore ogni 3/10 di secondo):
      Stato% = 0
      TempoRif = 0
      DO

         ' Controlla il temporizzatore e cambia lo stato del cursore
         ' se sono passati 3/10 di secondo:
         IF ABS(TIMER - TempoRif) > .3 THEN
            TempoRif = TIMER
            Stato% = 1 - Stato%

            ' Accende e spegne il bordo del bit:
            LINE (X% - 1, Y% - 1)-STEP(15, 8), Stato%, B
         END IF

         Controlla$ = INKEY$        ' Controlla la pressione di un tasto.

      LOOP WHILE Controlla$ = ""    ' Cicla finchÇ non viene premuto un tasto.

      ' Cancella il cursore:
      LINE (X% - 1, Y% - 1)-STEP(15, 8), 0, B

      SELECT CASE Controlla$        ' Risponde alla pressione di un tasto.

         CASE CHR$(27)          ' E' stato premuto il tasto ESC:
            EXIT SUB            ' esce da questo sottoprogramma.

         CASE CHR$(32)          ' E' stata premuta la BARRA SPAZIATRICE:
                                ' reimposta lo stato del bit.

            ' Inverte il bit nella stringa di motivo:
            ByteCorrente% = ASC(MID$(Motivo$, NumByte%, 1))
            ByteCorrente% = ByteCorrente% XOR Bit%(NumBit%)
            MID$(Motivo$, NumByte%) = CHR$(ByteCorrente%)

            ' Ridisegna il bit sullo schermo:
            IF (ByteCorrente% AND Bit%(NumBit%)) <> 0 THEN
                ColoreCorrente% = 1
            ELSE
                ColoreCorrente% = 0
            END IF
            LINE (X% + 1, Y% + 1)-STEP(11, 4), ColoreCorrente%, BF

         CASE CHR$(13)             ' E' stato premuto il tasto INVIO:
            DisegnaMotivo          ' disegna il motivo nel riquadro a destra.

         CASE Null$ + CHR$(75)     ' E' stato premuto il tasto SINISTRA:
                                   ' sposta il cursore a sinistra.
            NumBit% = NumBit% + 1
            IF NumBit% > 7 THEN NumBit% = 0

         CASE Null$ + CHR$(77)     ' E' stato premuto il tasto DESTRA:
                                   ' sposta il cursore a destra.
            NumBit% = NumBit% - 1
            IF NumBit% < 0 THEN NumBit% = 7

         CASE Null$ + CHR$(72)     ' E' stato premuto il tasto SU:
                                   ' sposta il cursore in alto.
            NumByte% = NumByte% - 1
            IF NumByte% < 1 THEN NumByte% = DimensMotivo%

         CASE Null$ + CHR$(80)     ' E' stato premuto il tasto GIU':
                                   ' sposta il cursore in basso.
            NumByte% = NumByte% + 1
            IF NumByte% > DimensMotivo% THEN NumByte% = 1

         CASE ELSE
            ' L'utente ha premuto un tasto diverso da ESC, BARRA SPAZIATRICE,
            ' INVIO, SU, GIU', SINISTRA, o DESTRA; non fare nulla.
      END SELECT
   LOOP
END SUB

'
' ======================== MostraMotivo ================================
'     Stampa i valori di CHR$ usati da PAINT per costruire il motivo
' ======================================================================
'
SUB MostraMotivo (OK$) STATIC
SHARED Motivo$, DimensMotivo%

   ' Riporta lo schermo in modalitÖ testo a 80 colonne:
   SCREEN 0, 0
   WIDTH 80

   PRINT "Il motivo ä composto dai caratteri seguenti:"
   PRINT

   ' Stampa il valore di ogni byte del motivo:
   FOR I% = 1 TO DimensMotivo%
      ByteMotivo% = ASC(MID$(Motivo$, I%, 1))
      PRINT "CHR$("; LTRIM$(STR$(ByteMotivo%)); ")"
   NEXT I%

   PRINT
   LOCATE , , 1
   PRINT "Un altro motivo? (Sç/No)";
   OK$ = UCASE$(INPUT$(1))
END SUB

