DECLARE FUNCTION OttDimMatr (LSin, LDes, LAlto, LBasso)

SCREEN 2
CLS
VIEW (20, 10)-(620, 190), , 1

CONST PIGRECO = 3.141592653589#

WINDOW (-3.15, -.14)-(3.56, 1.01)

' $DYNAMIC
' Il rettangolo ä pió piccolo di quello nel programma
' precedente, per cui pure Matrice ä pió piccola:
LSin = -.18
LDes = .18
LAlto = .05
LBasso = -.05

DimensMatr% = OttDimMatr(LSin, LDes, LAlto, LBasso)

DIM Matrice(1 TO DimensMatr%) AS INTEGER

CIRCLE (0, 0), .18
PAINT (0, 0)

GET (LSin, LAlto)-(LDes, LBasso), Matrice
CLS

LINE (-3, .8)-(3.4, .2), , B
Motivo$ = CHR$(126) + CHR$(0) + CHR$(126) + CHR$(126)
PAINT (0, .5), Motivo$

LOCATE 21, 29
PRINT "Premere un tasto per terminare"

Incremento = .02
InizioCiclo = -PIGRECO
AltRimb = 1

DO
   FineCiclo = -InizioCiclo
   FOR X = InizioCiclo TO FineCiclo STEP Incremento
      Y = ABS(COS(X)) * AltRimb - .14

      ' La prima istruzione PUT posiziona l'immagine
      ' sullo schermo:
      PUT (X, Y), Matrice, XOR

      ' Un ciclo FOR...NEXT vuoto per ritardare il programma e
      ' ridurre lo sfarfallço dell'immagine:
      FOR I = 1 TO 5: NEXT I

      IF Y < -.13 THEN AltRimb = AltRimb * .9
      Esc$ = INKEY$
      IF Esc$ <> "" OR AltRimb < .01 THEN EXIT FOR

      ' La seconda istruzione PUT cancella l'immagine e
      ' ripristina lo sfondo:
      PUT (X, Y), Matrice, XOR
   NEXT X

   Incremento = -Incremento
   InizioCiclo = -InizioCiclo
LOOP UNTIL Esc$ <> "" OR AltRimb < .01

Pausa$ = INPUT$(1)
END

FUNCTION OttDimMatr (LSin, LDes, LAlto, LBasso) STATIC
   FSin = PMAP(LSin, 0)
   FDes = PMAP(LDes, 0)
   FAlto = PMAP(LAlto, 1)
   FBasso = PMAP(LBasso, 1)

   AltRett = ABS(FBasso - FAlto) + 1
   LargRett = ABS(FDes - FSin) + 1

   DimByte = 4 + AltRett * INT((LargRett + 7) / 8)
   OttDimMatr = DimByte \ 2 + 1
END FUNCTION

