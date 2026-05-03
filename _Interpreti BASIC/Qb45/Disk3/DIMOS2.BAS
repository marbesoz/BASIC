DECLARE SUB Claxon (Alt%, Bas%)
DECLARE SUB Rimbalzi (Alt%, Bas%)
DECLARE SUB Caduta (Alt%, Bas%, Rit%)
DECLARE SUB Sirena (Alt%, Interv%)
DEFINT A-Z
' Versione QB2 del programma dimostrativo degli effetti sonori
'   (funziona con la maggior parte dei compiler di BASIC)

' Menu effetti sonori
WHILE Q$ <> "U"
    CLS
    PRINT "Effetti sonori": PRINT
    COLOR 15, 0: PRINT "  R"; : COLOR 7, 0: PRINT "imbalzi"
    COLOR 15, 0: PRINT "  C"; : COLOR 7, 0: PRINT "aduta"
    COLOR 7, 0: PRINT "  C"; : COLOR 15, 0: PRINT "l"; : COLOR 7, 0: PRINT "axon"
    COLOR 15, 0: PRINT "  S"; : COLOR 7, 0: PRINT "irena"
    COLOR 15, 0: PRINT "  U"; : COLOR 7, 0: PRINT "scita"
    PRINT : PRINT "Digitare la selezione: ";

    ' Ottiene un tasto ammesso
    Q$ = " "
    WHILE INSTR("RCLSUrclsu", Q$) = 0
        Q$ = INPUT$(1)
    WEND

    ' Esegue la scelta dell'utente
    CLS
    IF Q$ = "R" OR Q$ = "r" THEN
        PRINT "Rimbalza . . . "
        CALL Rimbalzi(32767, 246)
    ELSEIF Q$ = "C" OR Q$ = "c" THEN
        PRINT "Cade . . . "
        CALL Caduta(2000, 550, 500)
    ELSEIF Q$ = "S" OR Q$ = "s" THEN
        PRINT "Suona . . ."
        PRINT " . . . premere un tasto per terminare."
        CALL Sirena(780, 650)
    ELSEIF Q$ = "L" OR Q$ = "l" THEN
        PRINT "Oscilla . . ."
        PRINT " . . . premere un tasto per terminare."
        CALL Claxon(987, 329)
    ELSEIF Q$ = "u" THEN
        Q$ = "U"
    END IF
WEND
END

' Il ciclo porta da un tono alto ad uno basso
SUB Caduta (Alt, Bas, Rit) STATIC
    FOR Cont = Alt TO Bas STEP -10
        SOUND Cont, Rit / Cont
    NEXT
END SUB

' Alterna due suoni finch‚ non viene premuto un tasto
SUB Claxon (Alt, Bas) STATIC
    WHILE INKEY$ = ""
        SOUND Alt, 5
        SOUND Bas, 5
    WEND
END SUB

' Ciclo di due suoni sempre pi— ravvicinati
SUB Rimbalzi (Alt, Bas) STATIC
    FOR Cont = 60 TO 1 STEP -2
        SOUND Bas - Cont / 2, Cont / 20
        SOUND Alt, Cont / 15
    NEXT
END SUB

' Il tono cicla da basso ad alto e viceversa
SUB Sirena (Alt, Interv) STATIC
    WHILE INKEY$ = ""
        FOR Cont = Interv TO -Interv STEP -4
            SOUND Alt - ABS(Cont), .3
            Cont = Cont - 2 / Interv
        NEXT
    WEND
END SUB

