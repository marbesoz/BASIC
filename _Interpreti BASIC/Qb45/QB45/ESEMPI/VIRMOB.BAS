'
' VIRMOB.BAS
'
' Mostra come Š registrato in memoria un dato valore reale.
'
'
DEFINT A-Z
DECLARE FUNCTION FEsa$ (X AS INTEGER)
DIM Byte(3)

CLS
PRINT "Rappresentazione interna del numero IEEE (valori esadecimali)"
PRINT
DO

   ' Ottiene il valore e calcola l'indirizzo della variabile.
   INPUT "Digitare un numero reale (o Fine per finire): ", A$
   IF UCASE$(A$) = "FINE" THEN EXIT DO
   ValoreReale! = VAL(A$)
   ' Converte il valore reale in reale lungo senza cambiarne i bit.
   ValLungo& = CVL(MKS$(ValoreReale!))
   ' Costruisce una stringa di digit esadecimali e vi pone gli zeri iniziali.
   Strout$ = HEX$(ValLungo&)
   Strout$ = STRING$(8 - LEN(Strout$), "0") + Strout$

   ' Salva il bit del segno, e poi lo elimina perch‚ non
   ' influenzi la scomposizione del byte
   BitSegno& = ValLungo& AND &H80000000
   ValLungo& = ValLungo& AND &H7FFFFFFF
   ' Scompone il valore reale in quattro byte
   ' --il comando AND toglie i bit superflui; la divisione per 256 sposta
   ' il valore otto bit a destra.
   FOR I = 0 TO 3
      Byte(I) = ValLungo& AND &HFF&
      ValLungo& = ValLungo& \ 256&
   NEXT I
   ' Visualizza come il valore appare in memoria.
   PRINT
   PRINT "Byte in memoria"
   PRINT " Alta  Bassa"
   FOR I = 1 TO 7 STEP 2
      PRINT " "; MID$(Strout$, I, 2);
   NEXT I
   PRINT : PRINT

   ' Imposta il valore visualizzato del bit del segno.
   Segno = ABS(BitSegno& <> 0)

   ' L'esponente Š composto dai sette bit di destra del terzo byte e dal
   ' bit pi— a sinistra del secondo byte. La moltiplicazione per 2 sposta
   ' a sinistra e crea spazio per il bit aggiuntivo dal secondo byte.
   Esponente = Byte(3) * 2 + Byte(2) \ 128

   ' La prima parte della mantissa Š composta dai sette bit di destra del
   ' secondo byte.  L'operazione OR, impostando il bit pi— a sinistra,
   ' assicura che il bit implicito venga visualizzato.
   Mant1 = (Byte(2) OR &H80)
   PRINT "Bit 31     Bit  30-23        Bit Implicito e Bit 22-0"
   PRINT "Bit Segno  Bit Esponente     Bit Mantissa"
   PRINT TAB(4); Segno; TAB(17); FEsa$(Esponente);
   PRINT TAB(33); FEsa$(Mant1); FEsa$(Byte(1)); FEsa$(Byte(0))
   PRINT

LOOP

' FEsa$ assicura che si ottengano sempre due digit esadecimali.
FUNCTION FEsa$ (X AS INTEGER) STATIC
   D$ = HEX$(X)
   IF LEN(D$) < 2 THEN D$ = "0" + D$
   FEsa$ = D$
END FUNCTION

