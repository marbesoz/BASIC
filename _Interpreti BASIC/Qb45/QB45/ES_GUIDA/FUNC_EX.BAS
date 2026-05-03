DECLARE FUNCTION LungStr! (X$)
' *** FUNC_EX.BAS ***

LINE INPUT "Digitare una stringa: ", InString$
PRINT "La lunghezza della stringa Š"; LungStr(InString$)

FUNCTION LungStr (X$)
   IF X$ = "" THEN
      ' La lunghezza di una stringa nulla Š zero.
      LungStr = 0
   ELSE
      ' Stringa non nulla--esegue una chiamata ricursiva.
      ' La lunghezza di una stringa non nulla Š 1
      ' pi— la lunghezza del resto della stringa.
      LungStr = 1 + LungStr(MID$(X$, 2))
   END IF
END FUNCTION

