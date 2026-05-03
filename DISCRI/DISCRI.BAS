100 '==========================================================================
110 '  ** DISCRI.BAS **      -  CALCOLO DELLA FUNZIONE DSCRIMINANTE LINEARE -
120 '
130 ' (1) PRIMA STESURA DI STRAZZERA, LEONE, CUGINI, ROMA, 1985
140 ' (2) STRUTTURAZIONE, REVISIONE E GRAFICA DI P.BIANCHI, GALLARATE, 1986
150 '==========================================================================
160 '
170 GOSUB  1000 '(* INIZIALIZZAZIONI *)
180 GOSUB  2000 '(* CALCOLO CODEVIANZA E COVARIANZA *)
190 GOSUB  3000 '(* CALCOLO MEDIE *)
200 GOSUB  4000 '(* SOLVE NV EQUAZIONI IN NV INCOGNITE *)
210 GOSUB  5000 '(* FUNZ. DISCRIMINANTE *)
220 GOSUB  6000 '(* CALCOLA LO = SOGLIA DI DISCRIMINAZIONE *)
230 GOSUB  6500 '(* F *)
240 GOSUB  7000 '(* FUNZIONE L PER SOGGETTO A(esimo) *)
250 GOSUB  8000 '(* CALCOLO DELL'ERRORE DI DISCRIMINAZIONE *)
260 GOSUB  9000 '(* COSTRUZIONE ISTOGRAMMA *)
270 END
280 '
1000 '=========================================================================
1010 '(* BEGIN  INIZIALIZZAZIONE *)
1020 '
1100 CLS: PRINT "** ANALISI DISCRIMINANTE **": PRINT
1102 '
1104 DEFINT I,J,K
1106 DEF FNFIL$(X,Y) =   FIL$(Y)+ "." + CHR$(64+X)
1110 '
1120 SYM1$= "o": SYM2$= "*"
1125 '
1130 DIM FIL$(20)       '
1132 DIM C(20,21,2)     '
1134 DIM M(20,1)        '
1136 DIM L(20)          '
1138 DIM V(20)          '
1140 DIM S(2)           '
1142 DIM A(1000,1)      '
1144 DIM N(2)           '
1146 DIM ISTO(61,1)     '
1148 DIM FUNZ(2)        '
1150 DIM P(12), Z(12)   '
1155 '
1170 DATA 0.001,3.0931,     0.005,2.5802,     0.01,2.33175,   0.02,2.060547
1180 DATA 0.03, 1.8886297,  0.04, 1.7593675,  0.05,1.654246,  0.06,1.5647695
1190 DATA 0.07, 1.486296,   0.08, 1.4159985,  0.09,1.352018,  0.10,1.293065
1200 FOR I=1 TO 12: READ P(I),Z(I): NEXT
1210 '
1220 PRINT "RISULTATI SU CONSOLLE O STAMPANTE (C/S) ? ";
1230 A$="\": WHILE INSTR("CcSs",A$)= 0: A$=INPUT$(1): WEND: PRINT A$
1240 IF A$="S" OR A$="s" THEN LPT=-1 ELSE LPT=0
1250 IF A$="S" OR A$="s" THEN DEV$ = "LPT1:" ELSE DEV$="SCRN:"
1260 OPEN DEV$ FOR OUTPUT AS #2
1265 '
1270 PRINT : PRINT "FILES ACCESSIBILI AL TEST: ": FILES "*.A"
1280 '
1300 PRINT : INPUT "QUANTE VARIABILI PER GRUPPO "; NV
1310 IF NV<1 OR NV>20 THEN PRINT "Minimo 1, massimo 20: RIPETERE ": GOTO 1300
1320 PRINT :PRINT "IMPOSTARE IL NOME DEI FILE (*.A E *.B  DEFAULT) "
1330 FOR I=1 TO NV
1340   PRINT "Per la variabile n.";I;": ";: LINE INPUT A$
1350   L=LEN(A$): IF L<1 OR L>8 THEN PRINT "* Nome non valido *": GOTO 1340
1360   FIL$(I) = A$
1370 NEXT I
1380 '
1400 '
1970 '
1980 RETURN '(* END INIZIALIZZAZIONE *)
1990 '=========================================================================
1995 '
2000 '=====================================================================
2010 '(* BEGIN CALCOLO CODEVIANZE IN C() *)
2020 '
2030 PRINT #2,: PRINT #2, "MATRICE DELLE CODEVIANZE :"
2040 PRINT #2, "(CO)DEVIANZE              A             B          MEDIA"
2050 FOR I=1 TO NV
2060   FOR J=I TO NV
2070     FOR T=1 TO 2
2080       F1$=FNFIL$(T,I)
2090       F2$=FNFIL$(T,J)
2100         GOSUB 2240 '(* ---> CALCOLA CODEVIANZA *)
2110       C(I,J,T)=CD
2120       C(J,I,T)=CD
2130     NEXT T
2140     C( I,J,0)=(C(I,J,1)+C(I,J,2))/2
2150     C( J,I,0)= C(I,J,0)
2160     M$="\               \:  #######.##    #######.##     #######.##"
2170     FI$ = FIL$(I)+" * "+FIL$(J)
2180     PRINT #2, USING M$;FI$, C(I,J,1), C(I,J,2), C(I,J,0)
2190   NEXT J
2200 NEXT I
2210 PRINT #2, CHR$(12) '(* FORM FEED *)
2215 GOTO 2500 '(* egress *)
2220 '
2230 '(* - - - - - - - - - - - - - - - - - - - - - - - - *)
2240 '(* BEGIN CALCOLA CODEV. - INPUT F1$, F2$ : FILES DATI ;
2250 '                          OUTPUT CD, CV  : CODEVIANZA, COVARIANZA; *)
2260 S(1)=0: S(2)=0: SP=0
2270 '
2280 OPEN F1$ FOR INPUT  AS #1: N=0
2290 WHILE NOT EOF(1)
2300   N=N+1
2310   INPUT #1, A(N,0)
2320 WEND: CLOSE 1
2330 '
2340 OPEN F2$ FOR INPUT AS #1
2350 FOR K=1 TO N: P=1
2360   FOR G=1 TO 2
2370     IF G=2 THEN INPUT #1, X ELSE X=A(K,0)
2380     P=P*X
2390     S(G) = S(G)+X
2400   NEXT G
2410   SP=SP+P
2420 NEXT K: CLOSE 1
2430 PS=S(1)*S(2)
2440 CD=SP-PS/N       '(* CODEVIANZA *)
2450 CV=CD/(N-1)      '(* COVARIANZA *)
2460 RETURN '(* END CALCOLO CODEVIANZA fra f1$ e f2$ ---> CD *)
2470 '(* - - - - - - - - - - - - - - - - - - - - - - - - - - *)
2480 '
2490 '
2500 RETURN '(END CALCOLO TABELLA CODEVIANZE IN C() *)
2510 '=====================================================================
2520 '
3000 '=======================================================================
3010 '(* BEGIN CALCOLO MEDIE IN M() *)
3020 '
3030 PRINT #2,: PRINT #2, "TABELLA DELLE MEDIE: "
3040 PRINT #2,  "variabile       MEDIA A       MEDIA B"
3050 FOR K=1 TO NV                   '(* PER TUTTE LE VARIABILI ...
3060   FOR T=1 TO 2                  '... E PER ENTRAMBI I GRUPPI:
3070     F$=FNFIL$(T,K)              '    - STABILISCE NOME FILE;
3080     OPEN "I",1,F$: N=0: M=0     '    - APRE FILE DATI;
3090       WHILE NOT EOF(1): N=N+1   '    - CONTA I DATI;
3100         INPUT #1, A: M=M+A      '    - CALCOLA SOMMATORIA DATI;
3110       WEND : CLOSE 1            '    - CHIUDE IL FILE;
3120       M=M/N                     '    - CALCOLA LA MEDIA;
3130     M(K,T-1)=M                  '    - SETTA TABELLA DELLE MEDIE;
3140     N(T)=N                      '    - SETTA VETTORE DELLE NUMEROSITA';
3150   NEXT T                        '    - ALTRO GRUPPO ...
3160   M$= "\       \    ####.#####     ####.####"
3170   PRINT #2, USING M$; FIL$(K), M(K,0), M(K,1)
3180 NEXT K                          '(    - ALTRA VARIABILE... FATTO *)
3185 PRINT #2,: PRINT #2,
3190 '
3200 RETURN '(* END CALCOLO MEDIE IN M() *)
3210 '=======================================================================
3220 '
4000 '========================================================================
4010 '(* BEGIN SOLUZIONE NV EQUAZIONI LINEARI A NV INGOGNITE -
4020 '   INPUT : C( NV, NV )=MATRICE COEFFIC.;
4030 '           C(...,NV+1)=VETTORE TERM. NOTI *)
4040 '
4050 FOR I=1 TO NV
4060   C(I,NV+1,0)=M(I,0)-M(I,1)
4070 NEXT I
4080 '
4090 FOR J=1 TO NV
4100   F=0
4110   FOR I=J TO NV
4120     IF C(I,J,0) THEN F=I: I=NV
4130   NEXT I
4140   IF F=0 THEN PRINT "NON ESISTE SOLUZ. UNICA": STOP
4150 '
4160   FOR K=1 TO NV+1
4170     SWAP C(J,K,0),C(F,K,0)
4180   NEXT K
4190   Y=1/C(J,J,0)
4200 '
4210   FOR K=1 TO NV+1
4220     C(J,K,0)=C(J,K,0)*Y
4230   NEXT K
4240 '
4250   FOR I=1 TO NV:
4260     IF I=J THEN 4310
4270     Y=-C(I,J,0)
4280     FOR K=1 TO NV+1
4290       C(I,K,0) = C(I,K,0) + Y*C(J,K,0)
4300     NEXT K
4310   NEXT I
4320 NEXT J
4330 '
4340 FOR I=1 TO NV                     '(* L(I) SONO I COEFFICIENTI
4350   L(I)=C( I, NV+1, 0)             '   DELL'EQUAZIONE LINEARE
4360 NEXT I                            '   DISCRIMINANTE *)
4370 '
4380 PRINT #2, "COEFFICIENTI DELL' EQUAZIONE DISCRIMINANTE:"
4390 PRINT #2, "L =  "+ STR$(L(1)) + " * " + FIL$(1) + " + "
4400 '
4410 FOR I=2 TO NV
4420   D$ = "    " : IF L(I)>=0 THEN D$=D$+ "+" ELSE D$=D$+ " "
4430   D$ = D$ + STR$(L(I))+ " * "+FIL$(I) + " " + CHR$(43 -3*(I=NV))
4440   PRINT #2, D$
4450 NEXT I
4455 PRINT #2,: PRINT #2,
4460 '
4470 RETURN '(* END SOLUZIONE EQUAZIONI LINEARI *)
4480 '========================================================================
4490 '
5000 '======================================================================
5010 '( CALCOLA FUNZ. DISCR. PER I DUE GRUPI A CONFRONTO *)
5020 '
5030 FOR T=1 TO 2              '(* PER ENTRAMBI I GRUPPI:
5040   FOR I=1 TO NV
5050     V(I)=M(I,T-1)         '   - LEGGE IL VETTORE DELLE MEDIE NOTE;
5060   NEXT I
5070   L=0
5080   FOR I=1 TO NV
5090     L=L+L(I)*V(I)
5100   NEXT I
5110   FUNZ(T) = L             '   -...E LA PASSA A FUNZ( 1 o 2 ) *)
5120 '
5130   D$="VALORE MEDIO DELLA FUNZIONE PER IL GRUPPO "+ CHR$(64+T) +"       :"
5140   D$=D$+ STR$( FUNZ(T))
5150   PRINT #2, D$
5160 NEXT T                    '(* ALTRO GRUPPO *)
5170 '
5180 D=FUNZ(1) - FUNZ(2)
5190 D$="DIFFERENZA                                        :"+ STR$(D)
5200 PRINT #2, D$
5210 '
5220 RETURN '(* END CALCOLA FUNZ. DISCRIMINANTE *)
5230 '======================================================================
5240 '
6000 '========================================================================
6010 '(* BEGIN CERCA LO = SOGLIA DI DISCRIMINAZIONE *)
6020 '
6030 FOR T=1 TO 2: S(T)=0
6040   FOR G=1 TO NV: S=0
6050     FOR I=1 TO NV
6060       S=S+C(G,I,T)*L(I)
6070     NEXT I
6080     S=S*L(G): S(T)=S(T)+S
6090   NEXT G
6100   S(T) = SQR(S(T)/(N(T)-1))
6110 NEXT T
6120 '
6130 LO=(S(2)*FUNZ(1)+S(1)*FUNZ(2))/(S(1)+S(2))
6140 D$="SOGLIA OTTIMALE DI DISCRIMINAZIONE                :"+ STR$(LO)
6150 PRINT #2, D$
6160 '
6170 RETURN '(* END CERCA LO = SOGLIA OTTIMALE *)
6180 '========================================================================
6190 '
6500 '========================================================================
6510 '(* BEGIN CALCOLO DI F *)
6520 '
6530 GF=NV
6540 GE=N(1)+N(2)-GF-1
6550 '
6560 DF=N(1)*N(2)/(N(1)+N(2))*D*D: DE=D
6570 DE=D
6580 '
6590 F=DF/DE*GE/GF
6600 '
6610 PRINT #2, "F di Fisher: F("+MID$(STR$(GF),2)+","+ MID$(STR$(GE),2)+")";
6620 PRINT #2, TAB(51); ":";F
6625 PRINT #2,: PRINT #2,
6630 '
6640 RETURN '(END CALCOLO DI F *)
6650 '========================================================================
6660 '
7000 '=======================================================================
7010 '(* BEGIN CALCOLA FUNZ. L E SUO RANGE MI MA PER OGNI SOGGETTO )
7020 '
7030 MI=1E+10: MA=-1E+10
7040 '
7050 FOR T=1 TO 2
7060   FOR K=1 TO N(T)
7070     A(K,T-1)=0
7080   NEXT K
7090   PRINT #2,
7100   PRINT #2, "FUNZIONE L PER SOGGETTO NEL GRUPPO "+ CHR$(64+T)+":"
7110   PRINT #2,: PRINT #2, "CASO   FUNZIONE    DISCRIMINAZIONE"
7120   PRINT #2,            " N.    DISCRIM.         ERRATA"
7130   L=FUNZ(T)
7140   GOSUB 7470   '(* STABILISCE FORMATO DI USCITA FRM$ *)
7150   F$="###)   "+ FRM$ +SPACE$(22-LEN(FRM$))+"!"
7160   FOR G=1 TO NV
7170     OPEN "i",1,FNFIL$(T,G)
7180     FOR K=1 TO N(T)
7190       INPUT #1,Z: A(K,T-1)= A(K,T-1)+ Z* L(G)
7200     NEXT K
7210     CLOSE 1
7220   NEXT G
7230   CNT=0
7240   FOR K=1 TO N(T)
7250     L=A(K,T-1)
7260     IF L>MA THEN MA=L
7270     IF L<MI THEN MI=L
7280     D$ = MID$(" *",(SGN(LO-FUNZ(T))=SGN(LO-L))+2,1)
7290     CNT=CNT-(D$="*")
7300     PRINT #2, USING F$; K, A(K,T-1), D$
7310   NEXT K
7320   D$="CASI CON DISCRIMINAZIONE ERRATA: "+ STR$( 100* CNT/N(T)) + "%"
7330   PRINT #2, D$: PRINT #2,
7340 NEXT T
7350 '
7440 GOTO 7620  '(* EGRESS *)
7450 '
7460 '(* - - - - - - - - - - - - - - - - - - - *)
7470 '(* STABILISCE FORMATO FRM$ DA USARE IN STAMPA *)
7480 L$=MID$( STR$( ABS( L )),2)
7490 IF L=0 OR INSTR( L$,"E") OR INSTR(L$,"D")                                         THEN FRM$="#.######^^^^": GOTO 7540
7500 IPART= INSTR(L$,".")
7510 IF IPART=0 THEN IPART = LEN(L$): DPART=0                                                   ELSE DPART = LEN(L$)-IPART
7520 FRM$ = STRING$(IPART+1, "#")+"."+STRING$(DPART,"#")
7530 '
7540 C=0
7550 FOR I=1 TO LEN(FRM$)
7560   C=C-(MID$(FRM$,I,1)="#")
7570 NEXT I
7580 IF C<6 THEN  FRM$=FRM$+STRING$(7,C, "#")
7590 RETURN '(* END STABILISCE FORMATO FRM$ *)
7600 '(* - - - - - - - - - - - - - - - - - - - *)
7610 '
7620 RETURN '(* END  CALCOLA FUNZ. L E SUO RANGE MI MA PER OGNI SOGGETTO )
7630 '=======================================================================
7640 '
8000 '=======================================================================
8010 '(* BEGIN CALCOLO ERRORE DI DISCRIMINAZIONE *)
8020 '
8030 X = ABS(LO-FUNZ(1))/S(1)                      '(* CALCOLA P(robabilit…)
8040 Y=ABS(X)                                      '   COME AREA A DESTRA
8050 C=2.5066283#                                  '   DI X
8060 IF Y<1 THEN P=.5 - (Y-Y*Y*Y/7)/C                                                       ELSE P=(1+Y)*EXP(-Y*Y/2)/C/(1+Y+Y*Y)   '   INPUT: LO, FUNZ(), S()
8070 IF X<0 THEN P=1-P                             '   OUTPUT: P *)
8080 '
8090 PRINT #2,"PROBABILITA' CHE UN SOGGETTO DI UN GRUPPO SIA ERRONEAMENTE CON-"
8110 PRINT #2,USING "SIDERATO APPARTENENTE ALL'ALTRO GRUPPO:###.## %"; P*100
8120 PRINT #2, "(UTILIZZANDO IL VALORE DI SOGLIA "+ STR$(LO)+"):"
8130 PRINT #2,: PRINT #2,
8140 PRINT #2, "VALORI DI SOGLIA PER PREFISSATO RISCHIO DI ERRORE:"
8150 PRINT #2, " %        A         B "
8160 '
8170 FOR I=1 TO 12
8180   M$ = "###.#  "
8190   PRINT #2, USING M$; 100*P(I);
8200   M$ = FRM$ + SPACE$(12-LEN(FRM$))
8210   FOR T=1 TO 2
8220     V=FUNZ(T)+ SGN(LO-FUNZ(T))*Z(I)*S(T)
8230     PRINT #2, USING M$;V;
8240   NEXT T: PRINT #2,
8250 NEXT I
8255 PRINT #2,: PRINT #2,
8260 '
8270 RETURN'(* END CALCOLO ERRORE DI DISCRIMINAZIONE *)
8280 '======================================================================
8290 '
9000 '======================================================================
9010 '(* BEGIN ISTOGRAMMA )
9020 '
9030 PRINT : PRINT "ISTOGRAMMA ..."
9040 GOSUB 9420  '(* NUOVI ESTREMI *)
9050 RANGE = MAX - MIN
9060 GOSUB 9570  '(* CHIEDE N. CLASSI *)
9070 '
9080 N=0
9090 FOR T=1 TO 2
9100   FOR I=1 TO 61
9110     ISTO(1, T-1) = 0
9120   NEXT I
9130   FOR I=1 TO N(T)
9140     IF (A(I,T-1) < MIN) OR (A(I,T-1) > MAX) THEN 9180
9150     IX = CINT( 1+ (A(I,T-1)-MIN) / PASSO)
9160     ISTO(IX,T-1) = ISTO(IX,T-1)+1
9170     IF ISTO(IX, T-1) > N THEN N=ISTO(IX, T-1)
9180   NEXT I
9190 NEXT T
9200 '
9210 S=1: WHILE N>25: S=S*2: N=N/2: WEND
9220 PRINT #2, "NELL'ISTOGRAMMA, OGNI SIMBOLO CORRISPONDE A " S;
9230 IF S=1 THEN PRINT #2, "CASO" ELSE PRINT #2, "CASI"
9240 '
9250 PRINT #2, "IL GRUPPO A E' RAPPRESENTATO CON '" SYM1$ "' ;"
9260 PRINT #2, "IL GRUPPO B E' RAPPRESENTATO CON '" SYM2$ "' ."
9270 '
9280 FOR IX = 1 TO N.IN +1
9290   S1=ISTO(IX,0)
9300   S2=ISTO(IX,1)
9310   D$=FRM$ + " ": V=MIN+(IX-1)*PASSO
9320   PRINT #2, USING D$; V;
9330   D$ = STRING$(S1,SYM1$)+SPACE$(29-S1)+STRING$(S2,SYM2$)
9340   PRINT #2, D$
9350 NEXT IX
9360 '
9370 PRINT "RIPARAMETRIZZI L'ISTOGRAMMA (S/N) ?";
9380 A$ = "\": WHILE INSTR("SsNn", A$)=0: A$=INPUT$(1): WEND: PRINT A$
9390 IF A$="S" OR A$="s" THEN 9010
9400 GOTO 9680 '(* EGRESS *)
9410 '
9420 '(* LIMITI ISTOGRAMMA *)
9440 PRINT
9450 PRINT USING "RANGE      : ###.###### "; MA-MI
9460 PRINT USING "MINIMO     : ###.###### "; MI
9470 PRINT USING "MASSIMO    : ###.###### "; MA
9480 INPUT "LIMITE MINIMO  PER L'ISTOGRAMMA "; MIN
9482 INPUT "LIMITE MASSIMO PER L'ISTOGRAMMA "; MAX
9490 IF MIN => MAX THEN PRINT "ESTREMI ERRATI": GOTO 9420
9500 IF MIN <= MI AND MAX >= MA THEN 9550
9510 PRINT "CON QUESTO INTERVALLO RESTANO ESCLUSI ALCUNI VALORI "
9520 PRINT "PROCEDI UGUALMENTE (s/n) ?";
9530 A$ = "\": WHILE INSTR("SsNn", A$)=0: A$=INPUT$(1): WEND: PRINT A$
9540 IF A$="N" OR A$="n" THEN 9420
9550 RETURN '(* END LIMITI ISTOGRAMMA *)
9560 '
9570 '(* DIVIDE IN CLASSI *)
9580 PRINT
9590 PRINT "RANGE    : "RANGE
9600 INPUT "IN QUANTI INTERVALLI VA DIVISO "; N.IN
9610 IF N.IN  <1 OR N.IN >60 THEN PRINT "DA 1 A 60. RIPETERE.": GOTO 9570
9620 PASSO = RANGE / N.IN
9630 PRINT "IL PASSO E' " PASSO "; VA BENE (S/N) ?";
9640 A$ = "\": WHILE INSTR("SsNn", A$)=0: A$=INPUT$(1): WEND: PRINT A$
9650 IF A$="N" OR A$="n" THEN 9570
9660 RETURN '(* END RICHIESTA N. INTERVALLI *)
9670 '
9680 RETURN '(* END ISTOGRAMMA *)
9690 '======================================================================
9700 '
9990 '(* END LISTING "DISCRI.BAS" *)
9999 '======================================================================
