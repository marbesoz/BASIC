5 DEFINT A-Z
10 ' Versione BASICA/GWBASIC del programma dimostrazione effetti sonori
15 '
20 ' Menu effetti sonori
25 Q = 2
30 WHILE Q >= 1
35     CLS
40     PRINT "Effetti sonori": PRINT
45     COLOR 15, 0: PRINT "  R"; : COLOR 7, 0: PRINT "imbalzi"
50     COLOR 15, 0: PRINT "  C"; : COLOR 7, 0: PRINT "aduta"
55     COLOR 7, 0: PRINT "  C"; : COLOR 15, 0: PRINT "l"; : COLOR 7, 0: PRINT "axon"
60     COLOR 15, 0: PRINT "  S"; : COLOR 7, 0: PRINT "irena"
65     COLOR 15, 0: PRINT "  U"; : COLOR 7, 0: PRINT "scita"
70     PRINT : PRINT "Digitare la selezione: ";
75     Q$ = INPUT$(1): Q = INSTR("RCLSUrclsu", Q$) ' Ottiene un tasto ammesso
80     IF Q = 0 GOTO 75
85     CLS     ' Esegue l'azione scelta
90     ON Q GOSUB 100, 200, 300, 400, 500, 100, 200, 300, 400, 500
95 WEND
100 ' Rimbalzi - ciclo di due suoni sempre pi— ravvicinati
105    TONALT = 32767: TONBASS = 246
110    PRINT "Rimbalza . . ."
115    FOR CONT = 60 TO 1 STEP -2
120       SOUND TONBASS - CONT / 2, CONT / 20
125       SOUND TONALT, CONT / 15
130    NEXT CONT
135 RETURN
200 ' Caduta - il ciclo porta da un tono alto ad uno basso
205    TONALT = 2000: TONBASS = 550: RITARDO = 500
210    PRINT "Cade . . ."
215    FOR CONT = TONALT TO TONBASS STEP -10
220       SOUND CONT, RITARDO / CONT
225    NEXT CONT
230 RETURN
300 ' Claxon - alterna due toni finch‚ non viene premuto un tasto
305    TONALT = 987: TONBASS = 329
310    PRINT "Oscilla . . ."
315    PRINT " . . . premere un tasto per terminare."
320    WHILE INKEY$ = ""
325       SOUND TONALT, 5: SOUND TONBASS, 5
330    WEND
335 RETURN
400 ' Siren - il tono cicla da basso ad alto e viceversa
405    TONALT = 780: INTERV = 650
410    PRINT "Suona . . ."
415    PRINT " . . . premere un tasto per terminare."
420    WHILE INKEY$ = ""
425       FOR CONT = INTERV TO -INTERV STEP -4
430          SOUND TONALT - ABS(CONT), .3
435          CONT = CONT - 2 / INTERV
440       NEXT CONT
445    WEND
450 RETURN
500 ' Uscita
505 END

