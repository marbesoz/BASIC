'
'  C E R C H I
'
'  Algoritmo tratto dalla rubrica di A. K. Dewdney
'  su LE SCIENZE, novembre 1986
'
'  (C) by M. Besozzi  -  Versione 1.04 [19/12/92]
'

DECLARE FUNCTION Trim$ (x$)
DECLARE FUNCTION GetString$ (Row, Col, Start$, End$, Vis, Max)

CONST TRUE = -1
CONST FALSE = NOT TRUE

Cerchi:
     GOSUB Logo

     COLOR 0, 3
     LOCATE 25, 1: PRINT " Provare ad esempio con 640, 480, -4, -8, 16, 1, 0 o 640, 480, 4, 12, 48, 1, 0  ";
     COLOR 7, 0
     DO
     a$ = INPUT$(1)
     LOOP UNTIL ASC(a$) = 13
    
     COLOR 0, 3
     LOCATE 25, 1: PRINT " Introdurre un valore, INVIO per confermare, ESC per uscire                     ";
     COLOR 7, 0
     LOCATE 11, 6: PRINT "Risoluzione orizzontale (in pixel)      -->              [1ö640]"
     Row = 11: Col = 50: Vis = 3: Max = 3
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= 1 AND VAL(End$) <= 640 AND ASC(a$) = 13
     NumPixelOr = VAL(End$)

     COLOR 7, 0
     LOCATE 12, 6: PRINT "Risoluzione verticale   (in pixel)      -->              [1ö480]"
     Row = 12: Col = 50: Vis = 3: Max = 3
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= 1 AND VAL(End$) <= 480 AND ASC(a$) = 13
     NumPixelVe = VAL(End$)
    
     LOCATE 14, 6: PRINT "Angolo inferiore sinistro, ascisse      -->              [-9999ö9999]"
     Row = 14: Col = 50: Vis = 5: Max = 5
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= -9999 AND VAL(End$) <= 9999 AND ASC(a$) = 13
     AngA = VAL(End$)

     COLOR 7, 0
     LOCATE 15, 6: PRINT "Angolo inferiore sinistro, ordinate     -->              [-9999ö9999]"
     Row = 15: Col = 50: Vis = 5: Max = 5
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= -9999 AND VAL(End$) <= 9999 AND ASC(a$) = 13
     AngB = VAL(End$)

     COLOR 7, 0
     LOCATE 17, 6: PRINT "Lato                                    -->              [1ö9999]"
     Row = 17: Col = 50: Vis = 4: Max = 4
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= 1 AND VAL(End$) <= 9999 AND ASC(a$) = 13
     Lato = VAL(End$)

     COLOR 7, 0
     LOCATE 19, 6: PRINT "Palette colori                          -->              [0ö15]"
     Row = 19: Col = 50: Vis = 2: Max = 2
     DO
     COLOR 15, 0
     a$ = GetString$(Row, Col, Start$, End$, Vis, Max)
     COLOR 7, 0
     IF ASC(a$) = 27 THEN GOTO Esce
     LOOP UNTIL VAL(End$) >= 0 AND VAL(End$) <= 15 AND ASC(a$) = 13
     PaletteColori = VAL(End$)

     COLOR 7, 0
     LOCATE 20, 6: PRINT "Colore dello sfondo                     -->              [0ö15]"
     Row = 20: Col = 50: Vis = 2: Max = 2
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

FOR i = 1 TO NumPixelOr
  FOR j = 1 TO NumPixelVe
    x = AngA + (Lato * i / NumPixelOr)
    y = AngB + (Lato * j / NumPixelVe)
    z = x * x + y * y
    c = INT(z)
      IF c / 2 = INT(c / 2) THEN
        Colore = c MOD (14) + PaletteColori
      ELSE
        Colore = ColoreDelloSfondo
      END IF
    PSET (OffsetOr + i, OffsetVe + j), Colore
  NEXT j
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
     LOCATE 2, 2: PRINT "                               C E R C H I                                    "
     COLOR 14, 0
     LOCATE 3, 2: PRINT "              Algoritmo tratto dalla rubrica di A. K. Dewdney                 "
     LOCATE 4, 2: PRINT "                       su LE SCIENZE, novembre 1986                           "
     COLOR 3, 0
     LOCATE 5, 2: PRINT "               (C) by M. Besozzi  -  Versione 1.04 [19/12/92]                 "
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

