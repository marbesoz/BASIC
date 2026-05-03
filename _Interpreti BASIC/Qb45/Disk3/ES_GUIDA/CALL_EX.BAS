DECLARE SUB RigaCom (NumArg%, Arg$(), NumMassArg%)
DECLARE SUB Stampa (F$(), N%)
' *** CALL_EX.BAS
'
DEFINT A-Z
CONST NUMMASSFILE = 5, DIMMATR = NUMMASSFILE + 1
DIM File$(1 TO DIMMATR)
' Separa la riga di comando in argomenti.
CALL RigaCom(NumArg, File$(), DIMMATR)
IF NumArg < 3 OR NumArg > NUMMASSFILE THEN
  ' Troppi o troppo pochi file.
   PRINT "Usare da 3 a"; NUMMASSFILE; "file"
ELSE
  ' Stampa un listato dei file.
   CALL Stampa(File$(), NumArg)
END IF
END

SUB RigaCom (NumArg, Arg$(), NumMassArg) STATIC
' Subroutine che crea la riga di comando e ne individua gli argomenti.
' Parameters:  NumArg : Numero degli argomenti trovati.
'              Arg$() : Matrice in cui restituisce gli argomenti.
'              NumMassArg : Numero massimo di argomenti.
CONST VERO = -1, FALSO = 0
NumArg = 0: In = FALSO
' Ottiene la riga di comando con la funzione COMMAND$.
   Rc$ = COMMAND$
   L = LEN(Rc$)
' Percorre la riga di comando un carattere alla volta.
   FOR I = 1 TO L
      C$ = MID$(Rc$, I, 1)
      'Prova se Š uno spazio o una tabulazione.
      IF (C$ <> " " AND C$ <> CHR$(9)) THEN
         ' N‚ uno spazio n‚ una tabulazione.
         ' Prova se il carattere Š all'interno di un argomento.
         IF NOT In THEN
         ' E' all'inizio di un nuovo argomento.
         ' Prova se ci sono troppi argomenti.
            IF NumArg = NumMassArg THEN EXIT FOR
            NumArg = NumArg + 1
            In = VERO
         END IF
         ' Aggiunge il carattere all'argomento corrente.
         Arg$(NumArg) = Arg$(NumArg) + C$
      ELSE
         ' Ha trovato uno spazio o una tabulazione.
         ' Imposta il flag "Non all'interno di un argomento" a FALSO.
         In = FALSO
      END IF
   NEXT I
END SUB

SUB Stampa (F$(), N) STATIC
   ' Apre il file di destinazione.
   OPEN F$(N) FOR OUTPUT AS #3
   ' Il ciclo viene eseguito una volta per ogni file.
   ' Copia i primi N-1 file al file N.
   FOR File = 1 TO N - 1
      OPEN F$(File) FOR INPUT AS #1
      DO WHILE NOT EOF(1)
         'Legge il file.
         LINE INPUT #1, Temp$
         'Immette i dati nel file di destinazione.
         PRINT #3, Temp$
         PRINT Temp$
      LOOP
      CLOSE #1
    NEXT
    CLOSE
END SUB

