100 '=========================================================================
110 '
120 ' PREPOST.BAS - (c) P.BIANCHI 1986, OSPEDALE DI GALLARATE (VA - ITALY)
130 '
140 ' Il programma permette la rappresentazione grafica di uno o due gruppi di
150 ' osservazioni, ciascuno composto da varie coppie di valori (pre-evento e
160 ' post-evento). L'uscita avviene su video, stampante o plotter.
170 ' Caratteristiche tecniche:
180 ' - hardware: PC IBM, M24 e compatibili, sotto DOS 2.xx o superiore;
190 ' - software: interprete BASICA o GWBASIC versioni 2.xx o superiori;
200 ' - codice sorgente strutturato per facile manutenzione programma;
210 ' - immissione di dati a partire da file disco in formato DIF;
220 ' - autosensing IBM o Olivetti per settaggio video in alta (SCREEN 2: 640 x         200) o altissima (SCREEN 3: 640 x 400) risoluzione;
230 ' - supporto automatico di hardware IBM in dual mode (MDA+CGA) e solo modo          testo;
240 ' - supporto di scheda Hercules (solo sotto interprete HBasic);
250 ' - uscita su plotter secondo specifiche HPGL, per HP 7470A o compatibile;
260 ' - il device logico di plottaggio puo' essere assegnato alla porta                 parallela, a quella seriale o a un file disco per tracciatura successiva        off-line;
270 ' - specifiche di visualizzazione e tracciatura parametrizzate e                    riconfigurabili senza uscire dal programma.
280 '
290 '=========================================================================
300 '
310 '(* BEGIN MAIN *)
320 GOSUB 1000  '(* INIZIALIZZAZIONI *)
330 GOSUB 2000  '(* INPUT FILE(s) TO BE SHOWN *)
340 GOSUB 3000  '(* SORT DATA *)
350 GOSUB 4000  '(* GRAPH DATA *)
360 GOSUB 5000  '(* PLOT DATA *)
370 GOSUB 6000  '(* SHUT DOWN *)
380 END '(* MAIN *)
390 '
400 '
1000 '=========================================================================
1010 '(* BEGIN  INIZIALIZZAZIONE *)
1020 '
1030 TRUE = -1: FALSE=NOT TRUE
1040 '
1050 DEF SEG=0: POKE &H417, (PEEK(&H417) OR &H20): DEF SEG   'SET NUMERIC PAD
1060 DEF SEG=0: POKE &H417,(PEEK(&H417) OR &H40): DEF SEG '(* SET UPPERCASE *)
1070 '
1100 DIM M(500,2)    '(* M STANDS FOR 'MATTINO' : PRE-EVENT DATA SET(s) *)
1110 DIM P(500,2)    '(* P STANDS FOR 'POMERIGGIO': POST-EVENT DATA SET(s) *)
1150 '
1160 PLOTTER$ = "COM1: 2400,E,7,1,RS,CS0,DS0,CD0"   '(* SERIAL INTERFACE *)
1170 PLOTTER$ = "LPT1:"                            '(* PARALLEL INTERFACE *)
1180    PATH$ = "B:\"                              '(* DATAFILES PATH *)
1190     EXT$ = ".DIF"                             '(* DATAFILES EXTENSION *)
1200 '
1300 '
1500 GOSUB 30000: CLS: KEY OFF: IF NOT NOCGA THEN LOCATE 15,25:                      PRINT "GRAPH WILL SHOW HERE"        '(* SWITCH TO CGA *)
1510 GOSUB 20000: CLS: KEY OFF           '(* SWITCH TO MDA *)
1515 '
1520 PRINT "PRE-TO-POST CONNECTOR DIAGRAM - CIRCLE & LINES "
1530 PRINT
1540 PRINT "THIS PROGRAM ACCEPTS UP TO TWO DATA FILES. "
1550 PRINT "EACH FILE MUST HOLD DATA IN FORM OF PAIRED COUPLES; DATA COULD BE "
1560 PRINT "REPRESENTED BY A TABLE, IN WHICH ROWS ARE THE COUPLES, THE FIRST"
1570 PRINT "COLUMN HOLDING THE PRE-EVENT MEMBER OF THE PAIR, AND THE SECOND"
1580 PRINT "COLUMN HOLDING THE POST-EVENT MEMBER."
1590 PRINT
1600 PRINT "EACH DATA SET RESIDES IN A SINGLE DISK FILE STORED IN 'DIF' FORMAT."
1610 PRINT "DIF FILES MAY BE CREATED EITHER VIA A DEDICATED BASIC PROGRAM, OR"
1620 PRINT "FROM A VISICALC OR 123 SPREADSHEET, OR THEY MAY BE SIMPLY WRITTEN"
1630 PRINT "WITH AN EDITOR SUCH AS WORDSTAR, FOLLOWING THE DIF CONVENTIONS.":        PRINT
1640 PRINT "PROGRAM SETTINGS:"
1650 PRINT "GRAPHIC SCREEN AVAILABLE : ";: IF NOCGA THEN PRINT "NO"                                                                 ELSE PRINT "YES"
1660 PRINT "              PLOTTER IS : "; PLOTTER$
1670 PRINT "         DATA FILES PATH : "; PATH$
1680 PRINT "    DATA FILES EXTENSION : "; EXT$
1690 '
1700 '
1800 LOCATE 25,30: PRINT "PRESS SPACE BAR TO BEGIN";:
1810 AN$ = INPUT$(1): IF AN$<>" " THEN 1810 ELSE CLS
1900 '
1980 RETURN '(* END INIZIALIZZAZIONE *)
1990 '=========================================================================
1995 '
2000 '=========================================================================
2010 '(* BEGIN INPUT *)
2020 '
2030 ON ERROR GOTO 2600 '(* SET ERROR TRAP *)
2040 '
2050 PRINT "AVAILABLE DATA FILES ARE: "
2060 NOFILE = FALSE
2070 FILES PATH$ + "*" + EXT$
2080 IF NOFILE THEN PRINT "NONE! CHANGE DISK AND RETRY, OR ABORT PROGRAM":                          PRINT "PRESS SPACEBAR TO RETRY, 'Esc' TO QUIT ":
2090 IF NOFILE THEN AN$ = INPUT$(1): IF AN$=CHR$(32) THEN PRINT : GOTO 2050                                     ELSE IF AN$=CHR$(27) THEN STOP ELSE 2090
2100 PRINT : PRINT
2110 '
2120 PRINT "FILENAME FOR 1ST DATA SET (OMIT EXTENSION " EXT$ ")";
2130 INPUT FILE$(1): IF FILE$(1) = "" THEN 2120
2140 '
2150 PRINT "FILENAME FOR 2ND DATA SET (OMIT EXTENSION " EXT$ ")";
2155 INPUT FILE$(2)
2160 '
2170 FOR J=1 TO 2
2180   IF FILE$(J) = "" THEN 2450          '(* SKIP IF EMPTY *)
2190   PRINT "LOADING " FILE$(J) "..."     '(* MESSAGE *)
2200   OPEN PATH$+FILE$(J)+EXT$ FOR INPUT  AS #1  '(* BEGIN OPEN *)
2210   IF BADNAME THEN CLOSE: PRINT "BAD FILENAME! REINPUT": BADNAME = FALSE:          PRINT : IF J=1 THEN GOTO 2120 ELSE GOTO 2150
2220   '
2230   INPUT #1, TABLE$    : IF TABLE$   <> "TABLE"   THEN STOP
2240   INPUT #1, Z,U       : INPUT #1, TABLE$
2250   INPUT #1, VECTORS$  : IF VECTORS$ <> "VECTORS" THEN STOP
2260   INPUT #1, Z, DUE    : INPUT #1, VECTOR$:
2270   INPUT #1, TUPLES$   : IF TUPLES$  <> "TUPLES"  THEN STOP
2280   INPUT #1, Z, N(J)   : INPUT #1,TUPLES$
2290   INPUT #1, DA$       : IF DA$ <> "DATA" THEN STOP
2300   INPUT #1, Z, Z   : INPUT #1, DA$
2310   '
2320   FOR SET=1 TO DUE      '(* 1st set = M(attino), 2nd set = P(omeriggio) *)
2330     INPUT #1, U,Z: INPUT #1, ST$: IF NOT U OR ST$ <> "BOT" THEN STOP
2340     FOR PAIR = 1 TO N(J)
2350       INPUT #1, Z, VALUE: INPUT #1, ST$
2360       IF SET = 1 THEN 2370 ELSE 2390
2370        IF Z=0 AND ST$ ="V"  THEN M(PAIR,J)= VALUE                                      ELSE IF Z=0 AND ST$ ="NA" THEN M(PAIR,J)=-9999: P(PAIR,J)= -9999                ELSE STOP
2380       IF SET = 1 THEN 2400
2390        IF Z=0 AND ST$ ="V" AND M(PAIR,J)<>-9999 THEN P(PAIR,J)=VALUE                   ELSE P(PAIR,J)=-9999: M(PAIR,J)=-9999 '(* outscale if not Valid *)
2400     NEXT PAIR
2410   NEXT SET
2420 '
2430   INPUT #1, U,Z: INPUT #1, ST$: IF NOT U OR ST$ <> "EOD" THEN STOP
2440   CLOSE 1
2450 NEXT J
2460 '
2470 PRINT
2480 LINE INPUT "CHART MAIN TITLE   >" ; TI$
2490 IF TI$ = "" THEN TI$ = "PRE-EVENT AND POST-EVENT COMPARISON GRAPH"
2510                      LINE INPUT "1st DATA SET LABEL >"; L$(1)
2520 IF FILE$(2)<>"" THEN LINE INPUT "2nd DATA SET LABEL >"; L$(2)
2530 IF L$(1) = "" THEN L$(1) = FILE$(1)
2540 IF L$(2) = "" THEN L$(2) = FILE$(2)
2550 LINE INPUT "MEAS. UNITS  LABEL >"; UNIT$
2560 PRINT
2570 '
2580 ON ERROR GOTO 0: GOTO 2650 '(* DISABLE ERROR TRAP & EGRESS *)
2590 '
2600 '(* BEGIN ERROR TRAP *)
2610 IF ERR=53 AND ERL=2070 THEN NOFILE = TRUE
2620 IF ERR=53 AND ERL=2200 THEN BADNAME = TRUE
2630 RESUME NEXT '(* END ERROR TRAP *)
2640 '
2650 RETURN '(* END INPUT *)
2660 '=========================================================================
2670 '
3000 '=========================================================================
3010 '(* BEGIN FIND LIMITS *)
3020 '
3100 MIN = M(1,1): MAX = P(1,1)
3110 '
3115 PRINT "SEARCHING FOR MINIMA AND MAXIMA..."
3120 FOR J=1 TO 2
3130   FOR I=1 TO N(J)
3140     IF M(I,J)=-9999 OR P(I,J)=-9999 THEN 3190  '(* skip ouliers *)
3150     IF M(I,J) < MIN THEN MIN = M(I,J)
3160     IF M(I,J) > MAX THEN MAX = M(I,J)
3170     IF P(I,J) < MIN THEN MIN = P(I,J)
3180     IF P(I,J) > MAX THEN MAX = P(I,J)
3190   NEXT I
3200 NEXT J
3210 '
3450 '
3460 RETURN '(* END FIND LIMITS *)
3470 '=========================================================================
3480 '
4000 '=========================================================================
4010 '(* BEGIN DRAW *)
4020 '
4030 '(* BEGIN TABELLA PARAMETRI *)
4040 RAGG = 2          '(* RAGGIO PALLINI *)
4050 SPAZ = 2          '(* SPAZIATURA OR. *)
4060 ASPT = 1          '(* SFERICITA' DEI PALLINI *)
4070 '(* END TABELLA PARAMETRI *)
4080 '
4090 IF NOT NOCGA THEN PRINT "DRAWING ..."                                                        ELSE PRINT "GRAPHICS ADAPTER NOT INSTALLED - SKIP TO PLOT":                          GOTO 4730  '(* SKIP GRAPH *)
4100 GOSUB 30000  '(*  MONO -> COLOR *)
4110 '
4120 DEF SEG = &HF000: OFFSET=&HC050 '(* test for Olivetti or IBM *)
4130 SIG$ = CHR$(PEEK(OFFSET))+ CHR$(PEEK(OFFSET+1)) + CHR$(PEEK(OFFSET+2)):         DEF SEG
4140 IF SIG$ = "OLI" THEN OLI = TRUE ELSE OLI = FALSE
4150 '
4160 IF OLI THEN SCREEN 3 ELSE SCREEN 2
4170 IF NOT OLI THEN ASPE = ASPT/2 ELSE ASPE = ASPT
4180 CLS: KEY OFF
4190 WINDOW (0,0)-(200,100)             '(* scaling *)
4200 LINE   (  0,  0)-(200,100),,B      '(* outern box *)
4210 LINE   (  1,  1)-(199, 99),,B      '(* inner box *)
4220 '
4230 LINE ( 10, 10)-( 90, 90),,B        '(* box for 1st data set *)
4240 LINE (110, 10)-(190, 90),,B        '(* box for 2nd data set *)
4250 '
4260 LOCATE  2,    (80-LEN(TI$))/2: PRINT TI$      '(* title label *)
4270 LOCATE 24,    (40-LEN(L$(1)))/2: PRINT L$(1); '(* left label *)
4280 LOCATE 24, 40+(40-LEN(L$(2)))/2: PRINT L$(2); '(* right label *)
4290 LOCATE 22, 6: PRINT MIN; UNIT$: LOCATE 4, 6: PRINT MAX; UNIT$
4300 LOCATE 22,45: PRINT MIN; UNIT$: LOCATE 4,45: PRINT MAX; UNIT$
4310 '
4320 OFFS.X(1) =  10
4330 OFFS.X(2) = 110
4340 OFFS.Y    =  10
4350 SIDE      =  80
4360 '
4370 MIY = MIN - MAX*.1
4380 MAY = MAX * 1.1
4390 '
4400 RANGE.Y = MAY-MIY
4410 FY    = SIDE / RANGE.Y
4420 '
4430 FOR J=1 TO 2
4440   FOR I=1 TO N(J)
4450     IF -I MOD 2 THEN OFFS.X = OFFS.X(J) - SPAZ                                                  ELSE OFFS.X = OFFS.X(J) + SPAZ
4460     XM = OFFS.X + 15
4470     XP = OFFS.X + 65
4480     YM = OFFS.Y + (M(I,J)-MIY)*FY
4490     YP = OFFS.Y + (P(I,J)-MIY)*FY
4500     CIRCLE (XM,YM), RAGG,,,,ASPE : PAINT (XM,YM)
4510     CIRCLE (XP,YP), RAGG,,,,ASPE : PAINT (XP,YP)
4520     LINE (XM,YM)-(XP,YP)
4530   NEXT I
4540 NEXT J
4550 '
4560 AN$ = INPUT$(1): IF AN$ <> " " THEN 4560
4570 '
4580 GOSUB 20000  '(* CGA --> MDA *)
4590 AN$=""
4600 PRINT "NEW DOTS  RADIUM (PREVIOUS WAS" RAGG ") >";: INPUT R$: AN$=AN$ + R$
4610 IF R$="" THEN 4640 ELSE RAGG=VAL(R$): IF RAGG=0 THEN 4600
4620 R$="": PRINT
4630 '
4640 PRINT "NEW DOTS SPACING (PREVIOUS WAS" SPAZ ") >";: INPUT R$: AN$=AN$ + R$
4650 IF R$="" THEN 4680 ELSE SPAZ=VAL(R$): IF SPAZ=0 THEN 4640
4660 R$="": PRINT
4670 '
4680 PRINT "NEW DOTS  ASPECT (PREVIOUS WAS" ASPT ") >";: INPUT R$: AN$=AN$ + R$
4690 IF R$="" THEN 4710 ELSE ASPT=VAL(R$): IF ASPT=0 THEN 4680
4700 '
4710 IF AN$ = "" THEN 4730 ELSE 4090    '(* PLOT ELSE REDRAW USING NEW PARMS *)
4720 '
4730 '
4740 '
4750 RETURN '(* END DRAW *)
4760 '=========================================================================
4770 '
5000 '=========================================================================
5010 '(* BEGIN PLOT *)
5020 '
5030 PRINT
5040 PRINT"SET UP PLOTTER. PLOTTING COMMANDS ISSUED TO " PLOTTER$ ";"
5050 PRINT"              - PRESS SPACE BAR TO BEGIN PLOT; "
5060 PRINT"              - ELSE PRESS 'ESC' TO QUIT WITHOUT PLOTTING;"
5070 PRINT"              - OTHERWISE SPECIFY NEW PLOTTING DEVICE: ";
5080 '
5090 LOCATE ,,1: AN$=INPUT$(1): IF AN$=CHR$(13) THEN 5090  '(* NULL KEYPRESS *)
5100 IF AN$ = CHR$(27) THEN 5800                       '(* SKIP PLOT, EGRESS *)
5110 IF AN$ = " "      THEN 5140                              '(* BEGIN PLOT *)
5120 PRINT AN$;:LINE INPUT R$: PLOTTER$ = AN$+R$ : GOTO 5030  '(* NEW DEVICE *)
5130 '
5140 OPEN PLOTTER$ FOR OUTPUT AS #1
5150 PRINT: PRINT: PRINT "PLOTTING ..."
5160 '
5170 PRINT #1, "IN"              '(* INITIALIZE *)
5180 PRINT #1, "CS0"             '(* CHARACTER SET 0 *)
5190 PRINT #1, "DT"+CHR$(13)     '(* LABEL TERMINATOR IS CR *)
5200 PRINT #1, "SP1; VS 20"      '(* SELECT PEN 1 & SPEED *)
5210 PRINT #1, "SC 0,200,0,100"  '(* SCALE IN USER UNITS *)
5220 '
5230 PRINT #1, "PU  0, 0; PD 200 , 0, 200, 100 ,  0,100 ,  0, 0"' '(* MAIN
5240 PRINT #1, "PU .1,.1; PD 199.9,.1,199.9,99.9, .1,99.9, .1,.1"'    BOX *)
5250 PRINT #1, "PU .3,.3; PD 199.7,.3,199.7,99.7, .3,99.7, .3,.3"
5260 PRINT #1, "PU .4,.4; PD 199.6,.4,199.6,99.6, .4,99.6, .4,.4"
5270 '
5280 PRINT #1, "PU 10,10;    PD  90, 10,   90,90,   10,90,   10,10"
5290 PRINT #1, "PU  11,10.5; PD  91, 10.5, 91,90.5, 11,90.5, 11,10.5"
5300 '
5310 PRINT #1, "PU 110,10;   PD 190, 10,  190,90,  110,90,  110,10"
5320 PRINT #1, "PU 111,10.5; PD 191, 10.5,191,90.5,111,90.5,111,10.5"
5330 '
5340 PRINT #1, "SS; SI 0.3,0.6"                 '(* STANDARD SET & CHAR SIZE *)
5350 IF LEN(TI$)<57 THEN TI$ = SPACE$((55-LEN(TI$))/2)+TI$                                          ELSE TI$ = LEFT$(TI$,55)    '(* CENTER TITLE *)
5360 PRINT #1, "PU  0,93.0; LB" +TI$+ CHR$(13)  '(* WRITE TITLE *)
5370 PRINT #1, "PU .1,93.1; LB" +TI$+ CHR$(13)  '(* EMPHASIZE TITLE *)
5380 '
5390 OFFS.X(1) = 10
5400 OFFS.X(2) = 110
5410    OFFS.Y = 10
5420      SIDE = 80
5430       MIY = MIN - MAX*.1
5440       MAY = MAX * 1.1
5450   RANGE.Y = MAY-MIY
5460        FY = SIDE / RANGE.Y
5470 '
5490 DOT$ = ",15"  '(* DOT DRAWING RESOLUTION IN DEGREES; LOWER TO SMOOTHEN *)
5500 '
5510 FOR J=1 TO 2
5520   PRINT #1, "SP"+ STR$(J+1)                          '(* CHANGE COLOR *)
5530   PRINT #1, "SI 0.1, 0.3"                            '(* SMALL SIZE *)
5540   PRINT #1, "PU " + STR$(100*(J-1)+12) + ",12"       '(* LOWER LABEL *)
5550   PRINT #1, "LB "+STR$(MIN)+" "+ UNIT$ + CHR$(13)    '(* WRITE MIN *)
5560   PRINT #1, "PU " + STR$(100*(J-1)+12) + ",86"       '(* UPPER LABEL *)
5570   PRINT #1, "LB "+STR$(MAX)+" "+ UNIT$ + CHR$(13)    '(* WRITE MAX *)
5580   PRINT #1, "SI 0.3,0.6"                             '(* BIG SIZE *)
5590   PRINT #1, "PU "+ STR$(100*(J-1)+10  ) +", 5; LB " + L$(J) + CHR$(13)
5600   PRINT #1, "PU "+ STR$(100*(J-1)+10.1) +", 5; LB " + L$(J) + CHR$(13)
5610   '
5620   FOR I=1 TO N(J)
5630     IF -I MOD 2 THEN OFFS.X = OFFS.X(J) - SPAZ                                                  ELSE OFFS.X = OFFS.X(J) + SPAZ
5640     XM = OFFS.X + 15
5650     XP = OFFS.X + 65
5660     YM = OFFS.Y + (M(I,J)-MIY)*FY
5670     YP = OFFS.Y + (P(I,J)-MIY)*FY
5680     PRINT #1, "PU" + STR$(XM) + "," + STR$(YM)
5685     FOR RA=RAGG/2 TO 0 STEP -RAGG/10
5690       PRINT #1, "CI" + STR$(RA) + DOT$
5695     NEXT  RA
5700     PRINT #1, "PU" + STR$(XP) + "," + STR$(YP)
5705     FOR RA=RAGG/2 TO 0 STEP -RAGG/10
5710       PRINT #1, "CI" + STR$(RA) + DOT$
5715     NEXT RA
5720     PRINT #1, "PU" +"," STR$(XM) + ","+STR$(YM)
5730     PRINT #1, "PD" +"," STR$(XP) + ","+STR$(YP)
5740   NEXT I
5750 NEXT J
5760 '
5770 PRINT #1, "PU 0,0; SP 0": CLOSE 1       '(* HOME, CAP PENS & CLOSE *)
5780 PRINT "PLOT DONE "
5790 '
5800 RETURN '(* END PLOT *)
5810 '=========================================================================
5820 '
6000 '=========================================================================
6010 '(* BEGIN  SHUT DOWN *)
6020 '
6030 PRINT : PRINT "End Program 'PREPOST.BAS'"
6040 DEF SEG=0: POKE &H417, (PEEK(&H417) AND &HBF): DEF SEG   'SET lowercase
6050 DEF SEG=0: POKE &H417, (PEEK(&H417) AND &HDF): DEF SEG   'SET cursor pad
6060 COLOR 7,0: KEY ON
6070 '
6080 RETURN '(* END SHUT DOWN *)
6090 '=========================================================================
6100 '
20000 '======================================================================
20520 '(* begin crtswap - set to monochrome *)
20530 '
20540 DEF SEG = 64: IF (PEEK(16) AND 48)/16 =3 THEN 20630:
20550 '
20560 '(* now color, switch to monochrome *)
20570 IF INP(954)=255 THEN 20630                                                                      ELSE POKE 16,(PEEK(16)OR 48):LOCATE,,,12,13: GOTO 20630
20580 '
20630 LOCATE 1,1,0: SCREEN 0: WIDTH 40:WIDTH 80:
20640 DEF SEG : RETURN '(* end crtswap *)
20650 '======================================================================
20660 '
30000 '======================================================================
30520 '(* begin crtswap - switch to color *)
30530 '
30540 DEF SEG = 64: IF (PEEK(16) AND 48)/16 =3 THEN 30590:
30550 '
30590 '(* now monochrome, switch to color *)
30600 OUT 987,0
30610 IF INP(986)=255 THEN NOCGA=TRUE: GOTO 30630                                                     ELSE POKE 16,(PEEK(16)AND 207) OR 16: LOCATE ,,,7,7
30620 '
30630 LOCATE 1,1,0: SCREEN 0: WIDTH 40:WIDTH 80:
30640 DEF SEG : RETURN '(* end crtswap *)
30650 '======================================================================
30660 '
37000 '(* END LISTING PREPOST.BAS *)
37990 '========================================================================
