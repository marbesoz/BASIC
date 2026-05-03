' *** DRAW_EX.BAS ***
'
' Dichiara la procedura.
DECLARE SUB Quadrante (Min$)
'
' Seleziona la modalit… schermo a 640 x 200 pixel ad alta risoluzione.
SCREEN 2
DO
   CLS
   ' Crea una stringa contenente il valore dei minuti.
   Min$ = MID$(TIME$, 4, 2)
   ' Disegna il quadrante dell'orologio.
   Quadrante Min$
   ' Attende che cambi il minuto o che venga premuto un tasto.
   DO
      ' Visualizza l'ora in cima allo schermo.
      LOCATE 2, 37
      PRINT TIME$
      ' Prova se Š stato premuto un tasto.
      Tasto$ = INKEY$
   LOOP WHILE Min$ = MID$(TIME$, 4, 2) AND Tasto$ = ""
' Termina il programma alla pressione di un tasto.
LOOP WHILE Tasto$ = ""
END

'
' Disegna il quadrante dell'orologio.
SUB Quadrante (Min$) STATIC
   LOCATE 23, 27
   PRINT "Premere un tasto per uscire"
   CIRCLE (320, 100), 175
   ' Converte stringhe in numeri.
   Ora = VAL(TIME$)
   Min = VAL(Min$)
   ' Converte numeri in angoli.
   Corta = 360 - (30 * Ora + Min / 2)
   Lunga = 360 - (6 * Min)
   ' Disegna le lancette.
   DRAW "TA=" + VARPTR$(Corta) + "NU40"
   DRAW "TA=" + VARPTR$(Lunga) + "NU70"
END SUB

