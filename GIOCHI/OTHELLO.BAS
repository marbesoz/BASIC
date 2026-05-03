5 REM SAVE "OTHELLO",A
10 KEY OFF
20 DIM A(200),A1(100)
30 CLS
40 U=33
50 V=66
60 DATA   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
70 DATA   0, -99,  -1, -15, -15, -15, -15,  -1, -99,   0
80 DATA   0,  -1,  -1,  -5,  -5,  -5,  -5,  -1,  -1,   0
90 DATA   0, -15,  -5, -12, -10, -10, -12,  -5, -15,   0
100 DATA   0, -15,  -5, -10,   1,   2, -10,  -5, -15,   0
110 DATA   0, -15,  -5, -10,   1,   2, -10,  -5, -15,   0
120 DATA   0, -15,  -5, -12, -10, -10, -12,  -5, -15,   0
130 DATA   0,  -1,  -1,  -5,  -5,  -5,  -5,  -1,  -1,   0
140 DATA   0, -99,  -1, -15, -15, -15, -15,  -1, -99,   0
150 DATA   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
160 ROW=5
170 COL=5
180 RESTORE
190 FOR I=0 TO 99
200   READ A(I)
210   A1(I)=A(I)
220 NEXT I
230 INPUT "SKILL LEVEL (1 TO 5)";Z2
240 ON Z2 GOTO 300, 290, 280, 270, 260
250 GOTO 230
260 A(81)=2
270 A(18)=2
280 A(88)=2
290 A(11)=2
300 INPUT "WHO STARTS (1=ME  2=YOU)";Z
310 FOR I=9 TO 12
320   J=11*(I\12)
330   A(91+I)=I-J
340   A(95+I)=J-I
350 NEXT I
360 GOSUB 1660
370 GOSUB 1370
380 IF Z=2 THEN 830
390 LOCATE 5,65:PRINT "I'M THINKING";
400 C=0
410 D=0
420 FOR F=U TO V
430   IF A(F)=0 THEN F=F+2
440   IF A(F)>0 THEN 570
450   B=0
460   FOR K=100 TO 107
470     J=F
480     A=0
490     J=J+A(K)
500     IF A(J)<1 THEN 530
510     IF A(J)=1 THEN A=A-A(F): GOTO 490
520     B=B+A
530   NEXT K
540   IF B=0 GOTO 570
550   IF B>C THEN C=B: A(108)=F: D=1
560   IF B=C THEN A(108+D)=F: D=D+1
570 NEXT F
580 IF C>0 THEN 640
590 LOCATE 7,60
600 PRINT "I HAVE NO MOVES!"
610 IF Q=1 THEN 1480
620 S5=1
630 GOTO 830
640 I=A(107+INT(D*RND(1)+1))
650 ROW=I\10
660 COL=I-ROW*10
670 A(I)=2
680 GOSUB 1250
690 J=I
700 Q=0
710 FOR K=100 TO 107
720   A=0
730   I=J
740   I=I+A(K)
750   IF A(I)<1 THEN 810
760   IF A(I)=2 THEN 790
770   A=A+1
780   GOTO 740
790   I=J
800   IF A>0 THEN Z=Z: FOR L=1 TO A: I=I+A(K): A(I)=2: GOSUB 1250: NEXT L
810 NEXT K
820 GOSUB 1370
830 GOSUB 1950
840 M=INT(M)
850 IF M=0 THEN 1220
860 IF M=1 THEN Z=Z: GOSUB 1660: GOSUB 1370: GOTO 830
870 IF M=2 THEN S1=0: S2=64: GOTO 1480
880 'IF M=3 THEN 9200
890 IF M=4 THEN 1560
900 IF (M<11) OR (M>88) OR (A(M)>0) GOTO 1180
910 S5=0
920 B=0
930 FOR K=100 TO 107
940   J=M
950   A=0
960   J=J+A(K)
970   IF A(J)<1 THEN 1080
980   IF A(J)=2 THEN A=A+1: GOTO 960
990   I=M
1000   IF A=0 THEN 1080
1010   IF A(I)<0 THEN A(I)=1: GOSUB 1250
1020   FOR Z1=1 TO A
1030     I=I+A(K)
1040     A(I)=1
1050     B=B+1
1060     GOSUB 1250
1070   NEXT Z1
1080 NEXT K
1090 IF B=0 THEN 1180
1100 W=M-11
1110 IF W<U THEN U=W
1120 IF A(U)=0 THEN U=U+1: GOTO 1120
1130 W=M+11
1140 IF W>V THEN V=W                           
1150 IF A(V)=0 THEN V=V-1: GOTO 1150
1160 GOSUB 1370
1170 GOTO 390
1180 LOCATE 8,65
1190 PRINT "ILLEGAL MOVE"
1200 GOSUB 1460
1210 GOTO 830
1220 IF S5=1 THEN 1480
1230 Q=1
1240 GOTO 390
1250 IF I<11 OR I>88 THEN 1360
1260 R=I\10
1270 C=7*(I-R*10)-2
1280 R=3*R-1
1290 IF A(I)=2 THEN PIECE$=CHR$(176)+CHR$(176): GOTO 1310 ELSE PIECE$=CHR$(178)+CHR$(178)
1300 IF A(I)=1 THEN PIECE$=CHR$(178)+CHR$(178) ELSE GOTO 1360
1310 PIECE$=PIECE$+PIECE$
1320 LOCATE R,C
1330 PRINT PIECE$;
1340 LOCATE R+1,C
1350 PRINT PIECE$;
1360 RETURN
1370 S1=0                      
1380 S2=0
1390 FOR I=11 TO 88: IF A(I)=1 THEN S1=S1+1
1400 IF A(I)=2 THEN S2=S2+1
1410 NEXT I
1420 LOCATE 3,65
1430 PRINT S1;"     ";S2;
1440 IF (S1=0) OR (S2=0) OR (S1+S2=64) THEN 1490
1450 RETURN                                          
1460 SOUND 2000,1
1470 RETURN
1480 GOSUB 1460
1490 LOCATE 1,60
1500 IF S1=S2 THEN PRINT "TIED GAME": GOTO 1530
1510 IF S1>S2 THEN PRINT "YOU WIN": GOTO 840
1520 PRINT "COMPUTER WINS !!!!"
1530 LOCATE 10,60
1540 INPUT "PLAY AGAIN (1=YES)";M
1550 IF M=1 GOTO 30
1560 '*************************************************************************
1570 '* REVERSE SIDES
1580 '*************************************************************************
1590 FOR I=11 TO 88
1600   IF A(I)=1 THEN A(I)=2: GOSUB 1250: GOTO 1620
1610   IF A(I)=2 THEN A(I)=1: GOSUB 1250
1620 NEXT I
1630 GOSUB 1370
1640 GOSUB 1460
1650 GOTO 830
1660 '*************************************************************************
1670 '*  DRAW BOARD
1680 '*************************************************************************
1690 CLS
1700 TEMP$=STRING$(3,CHR$(205))
1710 TOP$=TEMP$+CHR$(209)+TEMP$
1720 TOP$=TOP$+TOP$+TOP$+TOP$+TOP$+TOP$+TOP$
1730 TOP$=CHR$(201)+TEMP$+TOP$+TEMP$+CHR$(187)
1740 BOT$=TEMP$+CHR$(207)+TEMP$
1750 BOT$=CHR$(200)+TEMP$+BOT$+BOT$+BOT$+BOT$+BOT$+BOT$+BOT$+TEMP$+CHR$(188)
1760 V$=CHR$(179)+STRING$(6," ")
1770 V$=V$+V$+V$+V$+V$+V$+V$+V$+CHR$(186)
1780 MID$(V$,1,1)=CHR$(186)
1790 H$=STRING$(6,CHR$(196))+CHR$(197)
1800 H$=CHR$(199)+H$+H$+H$+H$+H$+H$+H$+STRING$(6,CHR$(196))+CHR$(182)
1810 LOCATE 1,3
1820 COLOR 0,7
1830 PRINT TOP$
1840 FOR J=1 TO 23
1850   LOCATE J+1,3
1860   IF (J\3)*3=J THEN PRINT H$; ELSE PRINT V$;
1870 NEXT J
1880 LOCATE 25,3
1890 PRINT BOT$;
1900 COLOR 7,0
1910 FOR I=11 TO 88
1920   GOSUB 1250
1930 NEXT I
1940 RETURN
1950 '*************************************************************************
1960 LOCATE 5,65
1970 PRINT STRING$(14," ");
1980 LOCATE (3*ROW)-1,(7*COL)-1,1
1990 A$=INKEY$
2000 IF LEN(A$)=0 THEN 1990
2010 IF LEN(A$)=2 THEN 2050
2020 IF ASC(A$)=&HD THEN 2290
2030 IF A$="R" OR A$="r" THEN 1560
2040 IF A$="P" OR A$="p" THEN 390
2050 KEYIN=ASC(RIGHT$(A$,1))-71
2060 IF KEYIN <=0 THEN 1990
2070 ON KEYIN GOTO 2090, 1990, 1990, 2140, 1990, 2190, 1990, 1990, 2240, 1990
2080 GOTO 1990
2090 '*************************************************************************
2100 '* CURSOR UP
2110 '*************************************************************************
2120 IF ROW=1 THEN ROW=8 ELSE ROW=ROW-1
2130 GOTO 1980
2140 '*************************************************************************
2150 '* CURSOR LEFT
2160 '*************************************************************************
2170 IF COL=1 THEN COL=8 ELSE COL=COL-1
2180 GOTO 1980
2190 '*************************************************************************
2200 '* CURSOR RIGHT
2210 '*************************************************************************
2220 IF COL=8 THEN COL=1 ELSE COL=COL+1
2230 GOTO 1980
2240 '*************************************************************************
2250 '* CURSOR DOWN
2260 '*************************************************************************
2270 IF ROW=8 THEN ROW=1 ELSE ROW=ROW+1
2280 GOTO 1980
2290 '*************************************************************************
2300 '* INSERT
2310 '*************************************************************************
2320 M=10*ROW+COL
2330 LOCATE 8,65,0
2340 PRINT STRING$(14," ");
2350 LOCATE 7,60
2360 PRINT STRING$(19," ");
2370 RETURN
