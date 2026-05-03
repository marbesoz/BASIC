10 'ESEMPIO DI ORDINAMENTO DI 32 NUMERI CON IL METODO METZNER (metzner.bas)
20 ' ********************************************************************
30 'PREPARAZIONE DEL VETTORE CON 32 NUMERI DA ORDINARE
40 CLS
50 D=32
60 DIM NUMERO(D)
70 FOR I=1 TO D
80 READ NUMERO(I)
90 NEXT I
100 ' ********************************************************************
110 PRINT "INIZIO ORDINAMENTO  : ";TIME$
120 PASSO = D
130 PASSO = INT(PASSO/2)
140 IF PASSO < 1 THEN GOTO 250
150 LINI = 1         :'limite iniziale del segmento dei numeri
160 LIFI = D - PASSO :'limite finale del segmento dei numeri
170 PRIMO = LINI
180 SECONDO = PRIMO + PASSO
190 C=C+1:IF NUMERO(PRIMO) < NUMERO(SECONDO) GOTO 230
200 SWAP NUMERO(PRIMO),NUMERO(SECONDO):S=S+1
210 PRIMO = PRIMO - PASSO
220 IF PRIMO < 1 GOTO 230 ELSE GOTO 180
230 LINI = LINI + 1
240 IF LINI > LIFI GOTO 130 ELSE GOTO 170
250 PRINT "FINE ORDINAMENTO    : ";TIME$
260 ' ********************************************************************
270 PRINT "CONFRONTI  ";C;TAB(40) "SCAMBI  ";S
280 PRINT " "
290 PRINT "SEQUENZA DEI NUMERI DOPO L'ORDINAMENTO  "
300 FOR T=1 TO D
310 PRINT NUMERO(T);" ";
320 NEXT T
330 END
335 ' ********************************************************************
340 DATA 450,321,178,190,4,256,54,435,43,89,350,210,5,432,48,376,1,34,277,444,9,222,20,50,333,6,454,111,100,200,400,32
