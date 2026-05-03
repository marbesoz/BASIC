Continua = 1
    
DO
    
     NumPixelOr = 640
     NumPixelVe = 480

     'RANDOMIZE TIMER
     'NumPixelOr = INT(RND * 640)
     'IF NumPixelOr < 100 THEN NumPixelOr = 100
     'RANDOMIZE TIMER
     'NumPixelVe = INT(RND * 480)
     'IF NumPixelOr < 75 THEN NumPixelOr = 75
    
     RANDOMIZE TIMER
     AngA = INT(RND * 999) + 1
     'RANDOMIZE TIMER
     Dummy = RND
     IF Dummy < .5 THEN AngA = -AngA

     'RANDOMIZE TIMER
     AngB = INT(RND * 999) + 1
     'RANDOMIZE TIMER
     Dummy = RND
     IF Dummy < .5 THEN AngB = -AngB

     'RANDOMIZE TIMER
     Lato = INT(RND * 99) + 1
    
     'RANDOMIZE TIMER
     PaletteColori = INT(RND * 16)

     'RANDOMIZE TIMER
     ColoreDelloSfondo = INT(RND * 16)

SCREEN 12
CLS

OffsetOr = (640 - NumPixelOr) / 2
OffsetVe = (480 - NumPixelVe) / 2

FOR I = 1 TO NumPixelOr
  FOR j = 1 TO NumPixelVe
    x = AngA + (Lato * I / NumPixelOr)
    y = AngB + (Lato * j / NumPixelVe)
    z = x * x + y * y
    c = INT(z)
      IF c / 2 = INT(c / 2) THEN
        Colore = c MOD (14) + PaletteColori
      ELSE
        Colore = ColoreDelloSfondo
      END IF
    PSET (OffsetOr + I, OffsetVe + j), Colore
  NEXT j
NEXT I

LOOP UNTIL Continua <> 1

