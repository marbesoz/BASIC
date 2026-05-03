10 SCREEN 0
16 CLS
20 COLOR 15
30 PRINT "CIRCLE"
40 PRINT "da Le Scienze, novembre 1986 - Versione per VGA"
50 PRINT "Introdurre (per esempio) -4, -8, 16"
60 PRINT "Introdurre (per esempio)  4, 12, 48"
70 PRINT
80 INPUT "Angolo A : ", ANGA
90 INPUT "Angolo B : ", ANGB
100 INPUT "Lato     : ", LATO
110 KEY OFF
120 CLS
130 SCREEN 12
140 FOR I = 0 TO 639
150 FOR J = 0 TO 479
160 X = ANGA + (LATO * I / 639)
170 Y = ANGB + (LATO * J / 479)
180 Z = X * X + Y * Y
190 C = INT(Z)
200 EUREKA = C MOD (14)
210 COLOR EUREKA + 1
220 IF C / 2 = INT(C / 2) THEN PSET (I, J)
230 NEXT: NEXT
240 A$ = INPUT$(1)
250 IF ASC(A$) = 27 THEN SYSTEM
260 IF ASC(A$) = 13 THEN GOTO 10
270 BEEP
280 GOTO 240

