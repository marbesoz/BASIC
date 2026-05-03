10 SCREEN 0
16 CLS
18 X = 0: Y = 0
20 COLOR 15
30 PRINT "HOPALONG"
40 PRINT "da Le Scienze, novembre 1986 - Versione per VGA"
50 PRINT "Introdurre (per esempio) 10000, 0.1, 1, 0"
70 PRINT
74 INPUT "Numero iterazioni : ", NUM
80 INPUT "Variabile a       : ", A
82 INPUT "Variabile b       : ", B
84 INPUT "Variabile c       : ", C
90 SCREEN 12
100 WINDOW (-1, -1)-(1, 1.2)
110 VIEW (0, 0)-(639, 479)
120 FOR I = 1 TO NUM
130 EUREKA = ABS(X MOD (4))
132 COLOR EUREKA + 1
136 PSET (X, Y)
140 XX = Y - SGN(X) * SQR(ABS(B * X - C))
150 YY = A - X
160 X = XX
170 Y = YY
180 NEXT I
240 A$ = INPUT$(1)
250 IF ASC(A$) = 27 THEN SYSTEM
260 IF ASC(A$) = 13 THEN GOTO 10
270 BEEP
280 GOTO 240

