' Valori dei tasti sul tastierino numerico e della BARRA SPAZIATRICE:
CONST SU = 72, GIU = 80, SINIS = 75, DES = 77
CONST SUSINIS = 71, SUDES = 73, GIUSINIS = 79, GIUDES = 81
CONST BARRASPAZ = " "

' Null$ Š il primo carattere dei due restituiti da INKEY$
' alla lettura dei tasti di direzione come SU e GIU:
Null$ = CHR$(0)

' Se Traccia$ = "" traccia linee; se Traccia$ = "B" sposta
' il cursore grafico, ma non traccia linee:
Traccia$ = ""

PRINT "Usare i tasti di DIREZIONE per tracciare linee."
PRINT "Premere la BARRA SPAZIATRICE per accendere e spegnere"
PRINT "il disegno delle linee."
PRINT "Premere <INVIO> per iniziare. Premere u per uscire dal programma."
DO: LOOP WHILE INKEY$ = ""

SCREEN 1
CLS

DO
   SELECT CASE ValTasto$
      CASE Null$ + CHR$(SU)
         DRAW Traccia$ + "C1 U2"
      CASE Null$ + CHR$(GIU)
         DRAW Traccia$ + "C1 D2"
      CASE Null$ + CHR$(SINIS)
         DRAW Traccia$ + "C2 L2"
      CASE Null$ + CHR$(DES)
         DRAW Traccia$ + "C2 R2"
      CASE Null$ + CHR$(SUSINIS)
         DRAW Traccia$ + "C3 H2"
      CASE Null$ + CHR$(SUDES)
         DRAW Traccia$ + "C3 E2"
      CASE Null$ + CHR$(GIUSINIS)
         DRAW Traccia$ + "C3 G2"
      CASE Null$ + CHR$(GIUDES)
         DRAW Traccia$ + "C3 F2"
      CASE BARRASPAZ
         IF Traccia$ = "" THEN Traccia$ = "B " ELSE Traccia$ = ""
      CASE ELSE
         ' L'utente ha premuto un tasto che non Š un tasto
         ' di direzione, n‚ la BARRA SPAZIATRICE, n‚ "u",
         ' quindi rimane inattivo.
   END SELECT

   ValTasto$ = INKEY$

LOOP UNTIL ValTasto$ = "u"

SCREEN 0, 0
WIDTH 80
END

