DECLARE SUB Estensione ()
DECLARE SUB Search ()
' *** STAT2_EX.BAS - Programma esempio per l'istruzione STATIC
'
INPUT "Nome del file"; F1$
INPUT "Stringa da sostituire"; Vc$
INPUT "Sostituirla con"; Nv$
Sost = 0: Num = 0
M = LEN(Vc$)
OPEN F1$ FOR INPUT AS #1
CALL Estensione
OPEN F2$ FOR OUTPUT AS #2
DO WHILE NOT EOF(1)
   LINE INPUT #1, Temp$
   CALL Search
   PRINT #2, Temp$
LOOP
CLOSE
PRINT Sost; " sostituzioni in "; Num; " righe."
PRINT "Le sostituzioni sono nel file "; F2$
END

SUB Estensione STATIC
SHARED F1$, F2$
   Segn = INSTR(F1$, ".")
   IF Segn = 0 THEN
      F2$ = F1$ + ".NVO"
   ELSE
      F2$ = LEFT$(F1$, Segn - 1) + ".NVO"
   END IF
END SUB

SUB Search STATIC
SHARED Temp$, Vc$, Nv$, Sost, Num, M
STATIC S
   Segn = INSTR(Temp$, Vc$)
   WHILE Segn
      PrimoPezzo$ = LEFT$(Temp$, Segn - 1)
      SecondoPezzo$ = MID$(Temp$, Segn + M)
      Temp$ = PrimoPezzo$ + Nv$ + SecondoPezzo$
      S = S + 1
      Segn = INSTR(Temp$, Vc$)
   WEND
   IF Sost = S THEN
       EXIT SUB
   ELSE
       Sost = S
       Num = Num + 1
   END IF
END SUB

