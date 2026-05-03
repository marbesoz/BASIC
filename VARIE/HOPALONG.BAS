'
'  H O P A L O N G
'
'  Algoritmo tratto dalla rubrica di A. K. Dewdney
'  su LE SCIENZE, novembre 1986
'
'  (C) by M. Besozzi  -  Versione 1.00 [20/12/92]
'

DECLARE FUNCTION Trim$ (x$)
DECLARE FUNCTION GetString$ (Row, Col, Start$, End$, Vis, Max)

CONST TRUE = -1
CONST FALSE = NOT TRUE

Cerchi:
     GOSUB Logo

     COLOR 0, 3
     LOCATE 25, 1: PRINT " Provare ad esempio con 640, 480, -14, -14, 11, 11, 10000, -3.14, 0.3, 0.3, 0, 0";
     COLOR 7, 0
     DO
     a$ = INPUT$(1)
     LOOP UNTIL ASC(a$) = 13
    
     COLOR 0, 3
     LOCATE 25, 1: PRINT " Introdurre un valore, INVIO per confermare, ESC per uscire                     ";
     COLOR 7, 0
     LOCATE 9, 6: PRINT "Risoluzione orizzontale (in pixel)      -->              [1ö640]"
     Row = 9: Col = 50: Vis = 3: Max = 3
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= 1 AND VAL(End$) <= 640 AND ASC(a$) = 13
     NumPixelOr = VAL(End$)

     COLOR 7, 0
     LOCATE 10, 6: PRINT "Risoluzione verticale   (in pixel)      -->              [1ö480]"
     Row = 10: Col = 50: Vis = 3: Max = 3
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= 1 AND VAL(End$) <= 480 AND ASC(a$) = 13
     NumPixelVe = VAL(End$)
    
     COLOR 7, 0
     LOCATE 12, 6: PRINT "Asse delle ascisse, valore minimo       -->              [-99999ö99999]"
     Row = 12: Col = 50: Vis = 6: Max = 6
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= -99999 AND VAL(End$) <= 99999 AND ASC(a$) = 13
     StartX = VAL(End$)

     COLOR 7, 0
     LOCATE 13, 6: PRINT "Asse delle ascisse, valore massimo      -->              [-99999ö99999]"
     Row = 13: Col = 50: Vis = 6: Max = 6
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= -99999 AND VAL(End$) <= 99999 AND ASC(a$) = 13
     EndX = VAL(End$)

     COLOR 7, 0
     LOCATE 14, 6: PRINT "Asse delle ordinate, valore minimo      -->              [-99999ö99999]"
     Row = 14: Col = 50: Vis = 6: Max = 6
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= -99999 AND VAL(End$) <= 99999 AND ASC(a$) = 13
     StartY = VAL(End$)

     COLOR 7, 0
     LOCATE 15, 6: PRINT "Asse delle ordinate, valore massimo     -->              [-99999ö99999]"
     Row = 15: Col = 50: Vis = 6: Max = 6
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= -99999 AND VAL(End$) <= 99999 AND ASC(a$) = 13
     EndY = VAL(End$)

     LOCATE 17, 6: PRINT "Numero delle iterazioni                 -->              [1ö999999]"
     Row = 17: Col = 50: Vis = 6: Max = 6
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= 1 AND VAL(End$) <= 999999 AND ASC(a$) = 13
     Num = VAL(End$)

     COLOR 7, 0
     LOCATE 18, 6: PRINT "Variabile  a                            -->              [-9999ö9999]"
     Row = 18: Col = 50: Vis = 5: Max = 5
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= -9999 AND VAL(End$) <= 9999 AND ASC(a$) = 13
     a = VAL(End$)

     COLOR 7, 0
     LOCATE 19, 6: PRINT "Variabile  b                            -->              [-9999ö9999]"
     Row = 19: Col = 50: Vis = 5: Max = 5
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= -9999 AND VAL(End$) <= 9999 AND ASC(a$) = 13
     b = VAL(End$)

     COLOR 7, 0
     LOCATE 20, 6: PRINT "Variabile  c                            -->              [-9999ö9999]"
     Row = 20: Col = 50: Vis = 5: Max = 5
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= -9999 AND VAL(End$) <= 9999 AND ASC(a$) = 13
     c = VAL(End$)

     COLOR 7, 0
     LOCATE 22, 6: PRINT "Palette colori                          -->              [0ö15]"
     Row = 22: Col = 50: Vis = 2: Max = 2
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= 0 AND VAL(End$) <= 15 AND ASC(a$) = 13
     PaletteColori = VAL(End$)

     COLOR 7, 0
     LOCATE 23, 6: PRINT "Colore dello sfondo                     -->              [0ö15]"
     Row = 23: Col = 50: Vis = 2: Max = 2
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= 0 AND VAL(End$) <= 15 AND ASC(a$) = 13
     ColoreDelloSfondo = VAL(End$)

     COLOR 0, 3
     LOCATE 25, 1: PRINT " Premere INVIO per continuare                                                   ";
     COLOR 7, 0
     DO
     LOOP UNTIL INKEY$ = CHR$(13)

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

     DO
     a$ = INPUT$(1)
     LOOP UNTIL ASC(a$) = 13

Esce:
      GOSUB Logo
        FOR i = 8 TO 23
          LOCATE i, 2: PRINT "                                                                              ";
        NEXT i
      COLOR 0, 3
      LOCATE 25, 1: PRINT " Digitare s + INVIO per confermare, ESC per rimanere nel programma              ";
      COLOR 7, 0
      LOCATE 16, 16: PRINT "                Fine lavoro ?"
      DO
      Row = 16: Col = 46: Vis = 1: Max = 1: Start$ = ""
      COLOR 15, 0
      a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
      COLOR 7, 0
        IF ASC(a$) = 27 THEN
          FOR i = 8 TO 23
            LOCATE i, 2: PRINT "                                                                              ";
          NEXT i
          GOTO Cerchi
        END IF
      LOOP UNTIL End$ = "s"
      CLS
      SYSTEM

Logo:
     SCREEN 0, 0, 0
     COLOR 4, 0
     LOCATE 1, 1: PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
     FOR i = 1 TO 4
       LOCATE i + 1, 1: PRINT "³                                                                              ³"
     NEXT i
     LOCATE 6, 1: PRINT "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
     COLOR 10, 0
     LOCATE 2, 2: PRINT "                             H O P A L O N G                                  "
     COLOR 14, 0
     LOCATE 3, 2: PRINT "              Algoritmo tratto dalla rubrica di A. K. Dewdney                 "
     LOCATE 4, 2: PRINT "                       su LE SCIENZE, novembre 1986                           "
     COLOR 3, 0
     LOCATE 5, 2: PRINT "               (C) by M. Besozzi  -  Versione 1.00 [20/12/92]                 "
     COLOR 7, 0
     COLOR 4, 0
     LOCATE 7, 1: PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
     FOR i = 1 TO 16
       LOCATE i + 7, 1: PRINT "³                                                                              ³"
     NEXT i
     LOCATE 24, 1: PRINT "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ";
     COLOR 7, 0
     RETURN

'  GetString$
'  row = riga e col = colonna inizio input, start$ = stringa iniziale
'  (normalmente ""), end$ = stringa introdotta, Vis = lunghezza
'  visibile del campo input, Max lunghezza massima consentita
'
FUNCTION GetString$ (Row, Col, Start$, End$, Vis, Max)
    curr$ = Trim$(LEFT$(Start$, Max))
    IF curr$ = CHR$(8) THEN curr$ = ""

    LOCATE , , 1

    finished = FALSE
    DO
        GOSUB GetStringShowText
        GOSUB GetStringGetKey

        IF LEN(Kbd$) > 1 THEN
            finished = TRUE
            GetString$ = Kbd$
        ELSE
            SELECT CASE Kbd$
                CASE CHR$(13), CHR$(27), CHR$(9)
                    finished = TRUE
                    GetString$ = Kbd$

                CASE CHR$(8)
                    IF curr$ <> "" THEN
                        curr$ = LEFT$(curr$, LEN(curr$) - 1)
                    END IF

                CASE " " TO "}"
                    IF LEN(curr$) < Max THEN
                        curr$ = curr$ + Kbd$
                    ELSE
                        BEEP
                    END IF

                CASE ELSE
                    BEEP
            END SELECT
        END IF

    LOOP UNTIL finished

    End$ = curr$
    LOCATE , , 0
    EXIT FUNCTION


GetStringShowText:
    LOCATE Row, Col
    IF LEN(curr$) > Vis THEN
        PRINT RIGHT$(curr$, Vis);
    ELSE
        PRINT curr$; SPACE$(Vis - LEN(curr$));
        LOCATE Row, Col + LEN(curr$)
    END IF
    RETURN

GetStringGetKey:
    Kbd$ = ""
    WHILE Kbd$ = ""
        Kbd$ = INKEY$
    WEND
    RETURN
END FUNCTION

'Trim$
'  rimuove carattere null e spazi alla fine di una stringa
'
FUNCTION Trim$ (x$)

    IF x$ = "" THEN
        Trim$ = ""
    ELSE
        lastChar = 0
        FOR a = 1 TO LEN(x$)
            y$ = MID$(x$, a, 1)
            IF y$ <> CHR$(0) AND y$ <> " " THEN
                lastChar = a
            END IF
        NEXT a
        Trim$ = LEFT$(x$, lastChar)
    END IF

END FUNCTION

