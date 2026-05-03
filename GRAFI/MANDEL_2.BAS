Continua = 1
   
DO
   
     NumPixelOr = 200
     NumPixelVe = 200
     NumColori = 16

     RANDOMIZE TIMER
     PaletteColori = INT(RND * 16)

     RANDOMIZE TIMER
     ColoreMandel = INT(RND * 16)

     RANDOMIZE TIMER
     StartX = (RND * 2.4) + .1
     RANDOMIZE TIMER
     Dummy = RND
     IF Dummy < .5 AND StartX >= -1 THEN StartX = -StartX

     RANDOMIZE TIMER
     EndX = (RND * 2.4) + .1
     RANDOMIZE TIMER
     Dummy = RND
     IF Dummy < .5 AND EndX >= -1 THEN EndX = -EndX

     RANDOMIZE TIMER
     StartY = (RND * 1.6) + .1
     RANDOMIZE TIMER
     Dummy = RND
     IF Dummy < .5 THEN StartY = -StartY

     RANDOMIZE TIMER
     EndY = (RND * 1.6) + .1
     RANDOMIZE TIMER
     Dummy = RND
     IF Dummy < .5 THEN EndY = -EndY

     RANDOMIZE TIMER
     Iterazioni = INT(RND * 20) + 20

SCREEN 12
CLS

OffsetOr = (640 - NumPixelOr) / 2
OffsetVe = (480 - NumPixelVe) / 2

FOR I = 1 TO NumPixelOr
  FOR j = 1 TO NumPixelVe
    c1 = StartX + (EndX - StartX) * I / NumPixelOr
    c2 = EndY - (EndY - StartY) * j / NumPixelVe
    x = c1
    y = c2
      FOR n = 1 TO Iterazioni
        x1 = x * x - y * y + c1
        y1 = 2 * x * y + c2
        r = x1 * x1 + y1 * y1
          IF r > 4 THEN                ' il punto non appartiene all'insieme
            Colore = PaletteColori + (NumColori * n / Iterazioni)
              IF Colore > NumColori THEN
                Colore = Colore - NumColori
              END IF
            PSET (OffsetOr + I, OffsetVe + j), Colore
            GOTO ProssimoPixelVe
          ELSE
            PSET (OffsetOr + I, OffsetVe + j), ColoreMandel
          END IF
        x = x1
        y = y1
      NEXT n

ProssimoPixelVe:
  NEXT j
NEXT I

LOOP UNTIL Continua <> 1

