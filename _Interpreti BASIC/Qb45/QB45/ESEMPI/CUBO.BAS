' La stringa macro che disegna il cubo e ne colora i lati:
Traccia$ = "BR30 BU25 C1 R54 U45 L54 D45 BE20 P1,1 G20 C2 G20" + "R54 E20 L54 BD5 P2,2 U5 C4 G20 U45 E20 D45 BL5 P4,4"

PagCalc% = 1      ' Inizializza i valori della pagina di calcolo e di
PagVisual% = 0      ' visualizzazione e dell'angolo di rotazione.
Angolo% = 0

DO

   ' Disegna alla pagina di calcolo mentre visualizza
   ' la pagina di visualizzazione:
   SCREEN 7, , PagCalc%, PagVisual%
   CLS 1

   ' Ruota il cubo di "Angolo%" gradi:
   DRAW "TA" + STR$(Angolo%) + Traccia$

   ' Angolo% Š un multiplo di 15 gradi:
   Angolo% = (Angolo% + 15) MOD 360

   ' Scambia la pagina di calcolo con quella di visualizzazione:
   SWAP PagCalc%, PagVisual%

LOOP WHILE INKEY$ = ""     ' La pressione di un tasto termina il programma.

END

