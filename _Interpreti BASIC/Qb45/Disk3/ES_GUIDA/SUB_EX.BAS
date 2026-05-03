DECLARE SUB CercaInRiga (Prova$, S$)
'
' *** SUB1_EX.BAS - Programma esempio per l'istruzione SUB
'
INPUT "File in cui cercare"; F$
INPUT "Stringa da cercare"; S$
OPEN F$ FOR INPUT AS #1
DO WHILE NOT EOF(1)
   LINE INPUT #1, Prova$
   CALL CercaInRiga(Prova$, S$)
LOOP

SUB CercaInRiga (Prova$, S$) STATIC
   Num = Num + 1
   X = INSTR(Prova$, S$)
   IF X > 0 THEN PRINT "Riga n."; Num; ": "; Prova$
END SUB

