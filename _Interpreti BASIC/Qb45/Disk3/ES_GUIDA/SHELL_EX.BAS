' *** SHELL_EX.BAS ***
'
DECLARE FUNCTION OttNome$ (RigaDir$)
LINE INPUT "Digitare l'unit… e la directory di destinazione: ", SpecPerc$
SHELL "DIR > FILEDIR"    'Registra il listato della directory in FILEDIR.
DO
   OPEN "FILEDIR" FOR INPUT AS #1
   INPUT "Digitare la data (MM-GG-AA): ", MDate$
   PRINT
   ' Legge FILEDIR e vi cerca la data digitata.
   DO
      LINE INPUT #1, RigaDir$
      ' Prova se la data nella riga del listato corrisponde, e se la riga
      ' non Š di una delle directories speciali ( . o .. ).
      IF INSTR(RigaDir$, MDate$) > 0 AND LEFT$(RigaDir$, 1) <> "." THEN
	 SpecFile$ = OttNome$(RigaDir$)
	 ' Non sposta il file temporaneo.
	 IF SpecFile$ <> "FILEDIR" THEN
	    ' Crea una riga di comando DOS per copiare il file.
	    RigaDOS$ = "COPY " + SpecFile$ + "  " + SpecPerc$
	    PRINT RigaDOS$
	    ' Copia il file.
	    SHELL RigaDOS$
	 END IF
      END IF
   LOOP UNTIL EOF(1)
CLOSE #1
   PRINT "Nuova data?"
   R$ = INPUT$(1)
   CLS
LOOP UNTIL UCASE$(R$) <> "S"
' KILL "FILEDIR".
END

FUNCTION OttNome$ (RigaDir$) STATIC
' Questa funzione ottiene il nome e l'estensione del file dalla
' riga del listato della directory.
   NomeBase$ = RTRIM$(LEFT$(RigaDir$, 8))
   ' Cerca l'estensione.
   NomeEst$ = RTRIM$(MID$(RigaDir$, 10, 3))
   IF NomeEst$ <> "" THEN
      NomeBase$ = NomeBase$ + "." + NomeEst$
   END IF
   OttNome$ = NomeBase$
END FUNCTION

