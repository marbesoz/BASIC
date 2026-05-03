SCREEN 2

' Dimensiona la finestra per il grafico:
VIEW (20, 2)-(620, 172), , 1
CONST PIGRECO = 3.141592653589#

' Dimensiona le coordinate logiche della finestra per tracciare il seno
' da 0 radianti a 2ã radianti:
WINDOW (0, -1.1)-(2 * PIGRECO, 1.1)

Stile% = &HFF00                 ' Per la linea tratteggiata.

VIEW PRINT 23 TO 24             ' Fa scorrere l'output di testo
                                ' nelle righe 23 e 24.
DO
   PRINT TAB(20);
   INPUT "Numero di cicli (o 0 per terminare): ", Cicli
   CLS
   LINE (2 * PIGRECO, 0)-(0, 0), , , Stile%  ' Traccia l'ascissa.
   IF Cicli > 0 THEN
      ' Inizia da (0,0) e traccia il grafico:
      FOR X = 0 TO 2 * PIGRECO STEP .01
         Y = SIN(Cicli * X)     ' Calcola la coordinata y.
         LINE -(X, Y)           ' Traccia una linea dal punto precedente
                                ' al punto corrente.
      NEXT X
   END IF
LOOP WHILE Cicli > 0

