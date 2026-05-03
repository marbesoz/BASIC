'
' *** CMD_EX.BAS -- Programma esempio per la funzione COMMAND$
'
' Il tipo di variabile predefinito Š intero in questo modulo.
DEFINT A-Z

' Dichiara il sottoprogramma RigaCom e il numero e tipo dei
' parametri.
DECLARE SUB RigaCom (N, A$(), Mass)

DIM A$(1 TO 15)
' Ottiene la stringa digitata nella riga di comando.
CALL RigaCom(N, A$(), 10)
' Stampa gli elementi della riga di comando.
PRINT "Numero degli argomenti = "; N
PRINT "Gli argomenti sono: "
FOR I = 1 TO N: PRINT A$(I): NEXT I

' Subroutine che ottiene la riga di comando e la divide in argomenti.
' Parametri:  NumArg : Numero degli argomenti trovati nella riga di comando.
'             Args$() : Matrice in cui restituisce gli argomenti.
'             MassArg : Numero massimo degli argomenti che la matrice
'                       pu• restituire.

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

