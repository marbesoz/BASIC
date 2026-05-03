' TOKEN.BAS
'
' Dimostra una versione BASIC della funzione strtok di C.
'
DECLARE FUNCTION StrTok$ (Stringa$, Delimitatori$)

LINE INPUT "Digitare la stringa: ", P$
' Imposta i caratteri che separano i token.
Delimitatori$ = " ,;:().?" + CHR$(9) + CHR$(34)
' Chiama StrTok$ con la stringa da analizzare.
Token$ = StrTok$(P$, Delimitatori$)
WHILE Token$ <> ""
   PRINT Token$
   ' Chiama StrTok$ con una stringa nulla per segnalare che non
   ' la prima chiamata.
   Token$ = StrTok$("", Delimitatori$)
WEND

FUNCTION StrTok$ (Strg$, Delim$)
STATIC Inizio%, SalvaStrg$

   ' Se Š la prima chiamata, copia la stringa.
   IF Strg$ <> "" THEN
      Inizio% = 1: SalvaStrg$ = Strg$
   END IF

   PosIniz% = Inizio%: Lung% = LEN(SalvaStrg$)
   ' Cerca l'inizio di un token (un carattere non delimitatore).
   WHILE PosIniz% <= Lung% AND INSTR(Delim$, MID$(SalvaStrg$, PosIniz%, 1)) <> 0
      PosIniz% = PosIniz% + 1
   WEND
   ' Prova se Š stato trovato l'inizio di un token.
   IF PosIniz% > Lung% THEN
      StrTok$ = "": EXIT FUNCTION
   END IF
   ' Trova la fine del token.
   PosFin% = PosIniz%
   WHILE PosFin% <= Lung% AND INSTR(Delim$, MID$(SalvaStrg$, PosFin%, 1)) = 0
      PosFin% = PosFin% + 1
   WEND
   StrTok$ = MID$(SalvaStrg$, PosIniz%, PosFin% - PosIniz%)
   ' Imposta il punto da cui cercare il successivo token.
   Inizio% = PosFin%

END FUNCTION

