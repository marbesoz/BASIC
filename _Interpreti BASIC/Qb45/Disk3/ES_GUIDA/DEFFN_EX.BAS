'
' *** DEFFN_EX.BAS - Programma esempio per la funzione DEF FN
'
DEF FnFattoriale# (X)
   STATIC Tmp#, I
   Tmp# = 1
   FOR I = 2 TO X
      Tmp# = Tmp# * I
   NEXT I
   FnFattoriale# = Tmp#
END DEF

INPUT "Digitare un numero: ", Num
PRINT Num; "fattoriale fa"; FnFattoriale#(Num)

