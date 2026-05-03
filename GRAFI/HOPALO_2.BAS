Continua = 1
   
DO
   
     NumPixelOr = 640
     NumPixelVe = 480
    
     'RANDOMIZE TIMER
     'StartX = -INT(RND * 100)
     'RANDOMIZE TIMER
     'Dummy = RND
     'IF Dummy < .5 THEN StartX = -StartX
     StartX = -14

     'RANDOMIZE TIMER
     'EndX = -INT(RND * 100)
     'RANDOMIZE TIMER
     'Dummy = RND
     'IF Dummy < .5 THEN EndX = -EndX
     EndX = 11

     'RANDOMIZE TIMER
     'StartY = INT(RND * 100)
     'RANDOMIZE TIMER
     'Dummy = RND
     'IF Dummy < .5 THEN StartY = -StartY
     StartY = -14

     'RANDOMIZE TIMER
     'EndY = INT(RND * 100)
     'RANDOMIZE TIMER
     'Dummy = RND
     'IF Dummy < .5 THEN EndY = -EndY
     EndY = 11

     Num = 400000

     RANDOMIZE TIMER
     a = RND * 10
     RANDOMIZE TIMER
     Dummy = RND
     IF Dummy < .5 THEN a = -a

     RANDOMIZE TIMER
     b = RND
     RANDOMIZE TIMER
     Dummy = RND
     IF Dummy < .5 THEN b = -b

     RANDOMIZE TIMER
     c = RND
     RANDOMIZE TIMER
     Dummy = RND
     IF Dummy < .5 THEN c = -c

     RANDOMIZE TIMER
     PaletteColori = INT(RND * 16)

     RANDOMIZE TIMER
     ColoreDelloSfondo = 0

SCREEN 12
CLS

OffsetOr = (640 - NumPixelOr) / 2
OffsetVe = (480 - NumPixelVe) / 2

x = 0
y = 0

WINDOW (StartX, StartY)-(EndX, EndY)
VIEW (OffsetOr, OffsetVe)-(OffsetOr + NumPixelOr - 1, OffsetVe + NumPixelVe - 1)

LINE (StartX, StartY)-(EndX, StartY), ColoreDelloSfondo
LINE (EndX, StartY)-(EndX, EndY), ColoreDelloSfondo
LINE (EndX, EndY)-(StartX, EndY), ColoreDelloSfondo
LINE (StartX, EndY)-(StartX, StartY), ColoreDelloSfondo
PAINT (StartX + ((EndX - StartX) / 2), StartY + ((EndY - StartY) / 2)), ColoreDelloSfondo

  FOR i = 1 TO Num
    Colore = i MOD (14) + PaletteColori
      IF Colore > 15 THEN
        Colore = Colore - 15
      END IF
    PSET (x, y), Colore
    xx = y - SGN(x) * SQR(ABS(b * x - c))
    yy = a - x
    x = xx
    y = yy
  NEXT i

LOOP UNTIL Continua <> 1

