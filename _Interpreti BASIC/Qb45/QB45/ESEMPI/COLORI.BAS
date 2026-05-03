SCREEN 1

Esc$ = CHR$(27)

' Disegna tre quadrati e ne dipinge l'interno
' con tre colori diversi:
FOR ColorVal = 1 TO 3
   LINE (X, Y)-STEP(60, 50), ColorVal, BF
   X = X + 61
   Y = Y + 51
NEXT ColorVal

LOCATE 21, 1
PRINT "Premere ESC per uscire."
PRINT "Premere un tasto per continuare."

' Limita ogni ulteriore visualizzazione di testo alla riga 23:
VIEW PRINT 23 TO 23

DO
   PaletteVal = 1
   DO

      ' PaletteVal Š o uno o zero:
      PaletteVal = 1 - PaletteVal

      ' Imposta il colore dello sfondo e sceglie la palette:
      COLOR SfondoVal, PaletteVal
      PRINT "Sfondo ="; SfondoVal; "Palette ="; PaletteVal;

      Pausa$ = INPUT$(1)        ' Aspetta la pressione di un tasto.
      PRINT

   ' Esce dal ciclo se entrambe le palette sono state visualizzate,
   ' oppure se l'utente ha premuto il tasto ESC :
   LOOP UNTIL PaletteVal = 1 OR Pausa$ = Esc$

   SfondoVal = SfondoVal + 1

' Esce dal ciclo se tutti e sedici i colori di sfondo sono stati
' visualizzati, oppure se l'utente ha premuto il tasto ESC:
LOOP UNTIL SfondoVal > 15 OR Pausa$ = Esc$

SCREEN 0                        ' Ripristina la modalit… testo e la
WIDTH 80                        ' larghezza schermo di 80 colonne.

