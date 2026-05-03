DECLARE FUNCTION Filtro$ (Testo$, StringaFiltro$)

' Legge una riga:
LINE INPUT "Digitare un numero con virgole: ", A$

' Conserva solo i caratteri numerici (0123456789.-) nella stringa
' digitata:
NumPuro$ = Filtro$(A$, "0123456789.-")

' Converte la stringa in numero:
PRINT "Il valore numerico Š "; VAL(NumPuro$)
END

'
' ========================== FILTER ==========================
'        Elimina i caratteri non desiderati da una stringa
'        confrontadoli con una stringa filtro composta dai
'        caratteri numerici accettabili
' ============================================================
'
FUNCTION Filtro$ (Testo$, StringaFiltro$) STATIC
   Temp$ = ""
   LungTesto = LEN(Testo$)

   FOR I = 1 TO LungTesto     ' Isola ogni carattere della stringa.
      C$ = MID$(Testo$, I, 1)

      ' Se il carattere Š nella stringa filtro, lo salva:
      IF INSTR(StringaFiltro$, C$) <> 0 THEN
         Temp$ = Temp$ + C$
      END IF
   NEXT I

   Filtro$ = Temp$
END FUNCTION

