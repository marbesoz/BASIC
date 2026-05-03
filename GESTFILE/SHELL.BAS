10  'ESEMPIO DI ORDINAMENTO DI 32 NUMERI CON IL METODO SHELL
15  '**********************************************************************
20  'INSERIMENTO NUMERI DA ORDINARE E PREPARAZIONE VETTORE
30 CLS
40 D=32
50 DIM NUMERO(D)
60 FOR I=1 TO D
70 READ NUMERO(I)
80 NEXT I
81 '***********************************************************************
82 PRINT "INIZIO ORDINAMENTO  : ";TIME$
90 PASSO = D
100 PASSO=INT(PASSO/2):'ad ogni ritorno da riga 160 il valore PASSO si dimezza
105 IF PASSO < 1 THEN GOTO 162
110 INVERSIONI = 0
120 FOR I = 1 TO D - PASSO
130     C= C+1 : ' CONTATORE DEI CONFRONTI
140     IF NUMERO(I) > NUMERO(I+PASSO) THEN SWAP NUMERO(I),NUMERO(I+PASSO) :                                                INVERSIONI=1 :S=S+1
150 NEXT I
160 IF INVERSIONI = 1 THEN GOTO 110 ELSE GOTO 100
162 PRINT "FINE ORDINAMENTO    : ";TIME$
165 '**********************************************************************
180 PRINT "CONFRONTI  ";C;TAB(40) "SCAMBI  ";S
190 PRINT " "
200 PRINT "SEQUENZA DEI NUMERI DOPO L'ORDINAMENTO  "
210 FOR T=1 TO D
220 PRINT NUMERO(T);" ";
230 NEXT T
240 END
245 '**********************************************************************
300 DATA 450,321,178,190,4,256,54,435,43,89,350,210,5,432,48,376,1,34,277,444,9,222,20,50,333,6,454,111,100,200,400,32
