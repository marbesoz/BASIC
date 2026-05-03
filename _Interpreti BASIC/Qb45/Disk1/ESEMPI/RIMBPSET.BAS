DECLARE FUNCTION OttDimMatr (LSin, LDes, LAlto, LBasso)

SCREEN 2
CLS

' Definisce una finestra e la contorna con un bordo:
VIEW (20, 10)-(620, 190), , 1

CONST PIGRECO = 3.141592653589#

' Ridefinisce le coordinate della finestra con coordinate
' logiche:
WINDOW (-3.15, -.14)-(3.56, 1.01)

' Le matrici nel programma ora sono dinamiche:
' $DYNAMIC

' Calcola le coordinate logiche dei lati alto e basso di un
' rettangolo grande abbastanza da contenere l'immagine disegnata
' da CIRCLE e PAINT:
LSin = -.21
LDes = .21
LAlto = .07
LBasso = -.07

' Richiama la funzione OttDimMatr, passandole le coordinate
' logiche del rettangolo:
DimensMatr% = OttDimMatr(LSin, LDes, LAlto, LBasso)

DIM Matrice(1 TO DimensMatr%) AS INTEGER

' Disegna e colora il cerchio:
CIRCLE (0, 0), .18
PAINT (0, 0)

' Memorizza il rettangolo in Matrice:
GET (LSin, LAlto)-(LDes, LBasso), Matrice
CLS

' Disegna una casella e la riempie con un motivo:
LINE (-3, .8)-(3.4, .2), , B
Motivo$ = CHR$(126) + CHR$(0) + CHR$(126) + CHR$(126)
PAINT (0, .5), Motivo$

LOCATE 21, 29
PRINT "Premere un tasto per terminare"

' Inizializza le variabili del ciclo:
Incremento = .02
InizioCiclo = -PIGRECO
AltRimb = 1

DO
   FineCiclo = -InizioCiclo
   FOR X = InizioCiclo TO FineCiclo STEP Incremento

      ' Ogni volta che la palla "rimbalza" (dal fondo della
      ' finestra), la variabile AltRimb decresce, diminuendo
      ' l'altezza del rimbalzo successivo:
      Y = ABS(COS(X)) * AltRimb - .14
      IF Y < -.13 THEN AltRimb = AltRimb * .9

      ' Interrompe se viene premuto un tasto o se AltRimb Š minore di 0,01:
      Esc$ = INKEY$
      IF Esc$ <> "" OR AltRimb < .01 THEN EXIT FOR

      ' Mette l'immagine sullo schermo. Lo spostamento di Incremento Š minore
      ' del bordo intorno al cerchio, per cui ogni volta che l'immagine
      ' si sposta, canceller… qualunque traccia lasciata dal precedente
      ' PUT (e qualunque altra cosa occupi quello spazio sullo schermo):

      PUT (X, Y), Matrice, PSET
   NEXT X

   ' Inverte la direzione:
   Incremento = -Incremento
   InizioCiclo = -InizioCiclo
LOOP UNTIL Esc$ <> "" OR AltRimb < .01

Pause$ = INPUT$(1)
END

FUNCTION OttDimMatr (LSin, LDes, LAlto, LBasso) STATIC

   ' Converte le coordinate logiche passate alla funzione nelle
   ' equivalenti coordinate fisiche:
   FSin = PMAP(LSin, 0)
   FDes = PMAP(LDes, 0)
   FAlto = PMAP(LAlto, 1)
   FBasso = PMAP(LBasso, 1)

   ' Calcola l'altezza e la larghezza in pixel del
   ' rettangolo contenente la "palla":
   AltRett = ABS(FBasso - FAlto) + 1
   LargRett = ABS(FDes - FSin) + 1

   ' Calcola le dimensioni in byte della matrice:
   DimensByte = 4 + AltRett * INT((LargRett + 7) / 8)

   ' Matrice Š un intero, quindi divide i byte per due:
   OttDimMatr = DimensByte \ 2 + 1
END FUNCTION

