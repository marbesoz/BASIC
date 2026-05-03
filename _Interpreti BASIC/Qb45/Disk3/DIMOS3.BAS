DECLARE SUB Rimbalzi (Alt%, Bas%)
DECLARE SUB Caduta (Alt%, Bas%, Inter%)
DECLARE SUB Sirena (Alt%, Interv%)
DECLARE SUB Claxon (Alt%, Bas%)
DEFINT A-Z

' Versione QB 4.5 del programma dimostrazione effetti sonori

' Menu effetti sonori
DO
   CLS
   PRINT "Effetti sonori": PRINT
   COLOR 15, 0: PRINT "  R"; :  COLOR 7, 0: PRINT "imbalzi"
   COLOR 15, 0: PRINT "  C"; :  COLOR 7, 0: PRINT "aduta"
   COLOR 7, 0: PRINT "  C"; :  COLOR 15, 0: PRINT "l"; : COLOR 7, 0: PRINT "axon"
   COLOR 15, 0: PRINT "  S"; :  COLOR 7, 0: PRINT "irena"
   COLOR 15, 0: PRINT "  U"; :  COLOR 7, 0: PRINT "scita"
   PRINT : PRINT "Digitare la selezione: ";

   ' Ottiene un tasto ammesso
   DO
      Q$ = UCASE$(INPUT$(1))
   LOOP WHILE INSTR("RCLSU", Q$) = 0

   ' Esegue la scelta dell'utente
   CLS
   SELECT CASE Q$
      CASE IS = "R"
         PRINT "Rimbalza . . . "
         Rimbalzi 32767, 246
      CASE IS = "C"
         PRINT "Cade . . . "
         Caduta 2000, 550, 500
      CASE IS = "S"
         PRINT "Suona . . ."
         PRINT " . . . premere un tasto per terminare."
         Sirena 780, 650
      CASE IS = "L"
         PRINT "Oscilla . . ."
         PRINT " . . . premere un tasto per terminare."
         Claxon 987, 329
      CASE ELSE
   END SELECT
LOOP UNTIL Q$ = "U"
END

' Il ciclo porta da un suono alto ad uno basso
SUB Caduta (Alt%, Bas%, Inter%) STATIC
   FOR Cont = Alt TO Bas STEP -10
      SOUND Cont, Inter / Cont
   NEXT Cont
END SUB

' Alterna due suoni finch‚ non viene premuto un tasto
SUB Claxon (Alt%, Bas%) STATIC
   DO WHILE INKEY$ = ""
      SOUND Alt, 5
      SOUND Bas, 5
   LOOP
END SUB

' Ciclo di due suoni sempre pi— ravvicinati
SUB Rimbalzi (Alt%, Bas%) STATIC
   FOR Cont = 60 TO 1 STEP -2
      SOUND Bas - Cont / 2, Cont / 20
      SOUND Alt, Cont / 15
   NEXT Cont
END SUB

' Il tono cicla da basso ad alto e viceversa
SUB Sirena (Alt%, Interv%)
   DO WHILE INKEY$ = ""
      FOR Cont = Interv TO -Interv STEP -4
         SOUND Alt - ABS(Cont), .3
         Cont = Cont - 2 / Interv
      NEXT Cont
   LOOP
END SUB

