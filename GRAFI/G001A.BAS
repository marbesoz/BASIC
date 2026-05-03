PRINT "Introdurre (per esempio) 8, 8, 24"
INPUT AngA
INPUT AngB
INPUT Lato
KEY OFF
CLS
SCREEN 12
  FOR i = 1 TO 640
    FOR j = 1 TO 480
      x = AngA + (Lato * i / 640)
      y = AngB + (Lato * j / 480)
      z = x * x + y * y
      c = INT(z)
      IF c / 2 = INT(c / 2) THEN
      Colore = i * j MOD (15)
        PSET (i, j), Colore
      END IF
    NEXT j
  NEXT i
DO
LOOP UNTIL INKEY$ = CHR$(13)
END

