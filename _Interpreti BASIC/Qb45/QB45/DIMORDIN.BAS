' ============================================================================
'                                 DIMORDIN
' Questo programma dimostra sei comuni algoritmi per l'ordinamento;
' prima stampa in ordine casuale 25 o 43 barre orizzontali di lunghezze
' diverse, poi le ordina dalla pi— corta alla pi— lunga.
'
' Il programma usa istruzioni SOUND per generare toni diversi a seconda
' della posizione della barra stampata. Notare che le istruzioni SOUND
' rallentano l'esecuzione degli algoritmi, rendendo osservabile il loro
' progredire. I tempi risultanti, perci•, sono solo un termine di confronto,
' e non rappresentano le velocit… assolute degli algoritmi.
'
' Nell'uso pratico di queste routine di ordinamento si noteranno differenze
' tra le loro relative velocit… (per esempio l'ordinamento per scambi
' pu• risultare pi— veloce dell'ordinamento di Shell) a seconda del numero
' di elementi da ordinare e dal loro "disordine" iniziale.
' ============================================================================

DEFINT A-Z      ' Il tipo predefinito Š intero.

' Dichiarazione delle procedure FUNCTION e SUB col numero e tipo di argomenti:
  DECLARE FUNCTION IntCasuale% (Basso, Alto)

  DECLARE SUB CasIniz ()
  DECLARE SUB OrdPerm ()
  DECLARE SUB ControllaSchermo ()
  DECLARE SUB DisegnaBordo (LatoSup, LatoInf, LatoSin, LatoDes)
  DECLARE SUB TempoTrasc (RigaCorrente)
  DECLARE SUB OrdScamb ()
  DECLARE SUB OrdHeap ()
  DECLARE SUB Inizializza ()
  DECLARE SUB OrdInser ()
  DECLARE SUB FiltraGiu (LivelloMass)
  DECLARE SUB FiltraSu (LivelloMass)
  DECLARE SUB StampaBarra (Riga)
  DECLARE SUB OrdQuick (Basso, Alto)
  DECLARE SUB ReInizializza ()
  DECLARE SUB OrdShell ()
  DECLARE SUB MenuOrd ()
  DECLARE SUB ScambiaBarre (Riga1, Riga2)
  DECLARE SUB InterrSuono (Riga, Colonna)

' Definisce il tipo di dati usato per contenere i dati delle barre:
  TYPE TipoOrd
     Lung AS INTEGER              ' Lunghezza della barra (l'elemento di
                                  ' confronto nei vari ordinamenti)
     ValColore AS INTEGER         ' Colore della barra
     StringaBarra AS STRING * 43  ' La barra (una stringa di 43 caratteri)
  END TYPE

' Dichiara le costanti globali:
  CONST FALSO = 0, VERO = NOT FALSO, COLONNASIN = 49
  CONST NUMOPZIONI = 11, NUMORDINAMENTI = 6

' Dichiara le variabili globali e alloca loro spazio nella memoria. MatrOrd
' e BackupOrd sono matrici del tipo di dati TipoOrd definito sopra:
  DIM SHARED MatrOrd(1 TO 43) AS TipoOrd, BackupOrd(1 TO 43) AS TipoOrd
  DIM SHARED LeggendaOpzioni(1 TO NUMOPZIONI) AS STRING * 14
  DIM SHARED TempoIniz AS SINGLE
  DIM SHARED PrimoPiano, Sfondo, Silenzio, Pausa
  DIM SHARED Selezione, RigheMass, RigheIniz, ColoriMass

' Istruzioni DATA per le varie opzioni del menu degli ordinamenti:
  DATA Inserzione, Permutazioni, Heap, sCambi, Shell, Quick,
  DATA Effetto sonoro, , < (pi— lento), > (pi— veloce)

' Inizia il corpo del programma a livello di modulo:

  Inizializza             ' Inizializza i valori dei dati.
  MenuOrd                 ' Stampa il menu degli ordinamenti.
  WIDTH 80, RigheIniz     ' Ripristina il numero di righe iniziale.
  COLOR 7, 0              ' Ripristina il colore predefinito.
  CLS
  END

' OttRighe, RilevMono, e RilevRighe sono routine per la gestione di errori
' chiamate dalla procedura SUB ControllaSchermo. OttRighe determina se il
' programma ha iniziato con 25, 43, o 50 righe. RilevMono determina se
' l'adattatore video Š monocolore. RilevRighe imposta il numero massimo
' di righe (43 o 25).

OttRighe:
   IF RigheIniz = 50 THEN
      RigheIniz = 43
      RESUME
   ELSE
      RigheIniz = 25
      RESUME NEXT
   END IF

RilevMono:
   ColoriMass = 2
   RESUME NEXT

RilevRighe:
   RigheMass = 25
   RESUME

' =============================== CasIniz ====================================
'    Chiama la procedura DisegnaBordo, che disegna il bordo del menu degli
'    ordinamenti, e poi stampa le opzioni della matrice LeggendaOpzioni.
' ============================================================================
'
SUB CasIniz STATIC
   DisegnaBordo 1, 22, COLONNASIN - 3, 80

   LOCATE 3, COLONNASIN + 2: PRINT "DIMOSTRAZIONE ORDINAMENTI";
   LOCATE 5
   FOR i = 1 TO NUMOPZIONI - 1
      LOCATE , COLONNASIN: PRINT LeggendaOpzioni(i)
   NEXT i

   ' Non stampare l'opzione (> Pi— veloce) se il valore della Pausa Š
   ' ridotto a 1 (un ciclo del temporizzatore):
   IF Pausa > 1 THEN LOCATE , COLONNASIN: PRINT LeggendaOpzioni(NUMOPZIONI);

   ' Accendere o spegnere l'effetto sonoro e stamparne il valore corrente:
   Silenzio = NOT Silenzio
   InterrSuono 12, COLONNASIN + 14

   LOCATE NUMOPZIONI + 6, COLONNASIN
   PRINT "Digitare la MAIUSCOLA della"
   LOCATE , COLONNASIN
   PRINT "scelta ( I P H C S Q E < > )"
   LOCATE , COLONNASIN
   PRINT "o il tasto ESC per uscire:";
END SUB

' ============================== ControllaSchermo =================================
'     Verifica il tipo di monitor (VGA, EGA, CGA, or monocolore) e il
'     numero iniziale di righe dello schermo (50, 43, o 25).
' ============================================================================
'
SUB ControllaSchermo STATIC

   ' Prova a trovare la 50a riga; se non ci riesce, prova la 43a. Se anche
   ' questa non c'Š, l'utente Š nella modalit… di 25 righe:
   RigheIniz = 50
   ON ERROR GOTO OttRighe
   LOCATE RigheIniz, 1

   ' Prova un'istruzione SCREEN 1 per vedere se l'adattatore supporta la
   ' modalit… grafica a colori; se causa un errore, reimposta ColoriMass a 2:
   ColoriMass = 15
   ON ERROR GOTO RilevMono
   SCREEN 1
   SCREEN 0

   ' Prova se Š accettata la modalit… di 43 righe; se no, esegue il programma
   ' in modalit… 25 righe:
   RigheMass = 43
   ON ERROR GOTO RilevRighe
   WIDTH 80, RigheMass
   ON ERROR GOTO 0              ' disattiva la gestione di errori.
END SUB

' ============================== DisegnaBordo ===================================
'   Disegna un bordo rettangolare con i caratteri grafici ASCII É (201) ,
'   » (187) , È (200) , ¼ (188) , º (186) , e Í (205). I parametri LatoSup,
'   LatoInf, LatoSin, e LatoDes sono i valori di riga e di colonna degli
'   angoli del bordo in alto a sinistra e in basso a destra.
' ============================================================================
'
SUB DisegnaBordo (LatoSup, LatoInf, LatoSin, LatoDes) STATIC
   CONST ALTSIN = 201, ALTDES = 187, BASSIN = 200, BASDES = 188
   CONST VERTICALE = 186, ORIZZONTALE = 205

   LargBordo = LatoDes - LatoSin - 1
   LOCATE LatoSup, LatoSin
   PRINT CHR$(ALTSIN); STRING$(LargBordo, ORIZZONTALE); CHR$(ALTDES);
   FOR Riga = LatoSup + 1 TO LatoInf - 1
      LOCATE Riga, LatoSin
      PRINT CHR$(VERTICALE); SPC(LargBordo); CHR$(VERTICALE);
   NEXT Riga
   LOCATE LatoInf, LatoSin
   PRINT CHR$(BASSIN); STRING$(LargBordo, ORIZZONTALE); CHR$(BASDES);
END SUB

' ============================ FiltraGiu =================================
'   La procedura FiltraGiu ristruttura gli elementi di MatrOrd da 1 a
'   LivelloMass in un "heap" (vedi il diagramma nella procedura OrdHeap).
' ============================================================================
'
SUB FiltraGiu (LivelloMass) STATIC
   i = 1

   ' Sposta il valore in MatrOrd(1) in basso nell' heap finch‚ non Š
   ' giunto a un nodo valido (cioŠ finch‚ non Š minore del nodo genitore o
   ' finch‚ non ha raggiunto LivelloMass, la base dell'heap corrente):
   DO
      Figlio = 2 * i             ' Ottiene l'indice del nodo figlio.

      ' E' giunto alla base dell'heap; esce da questa procedura:
      IF Figlio > LivelloMass THEN EXIT DO

      ' Se vi sono due nodi figlio, stabilire il maggiore:
      IF Figlio + 1 <= LivelloMass THEN
         IF MatrOrd(Figlio + 1).Lung > MatrOrd(Figlio).Lung THEN
            Figlio = Figlio + 1
         END IF
      END IF

      ' Spostare il valore in basso se non Š maggiore dei nodi figlio:
      IF MatrOrd(i).Lung < MatrOrd(Figlio).Lung THEN
         SWAP MatrOrd(i), MatrOrd(Figlio)
         ScambiaBarre i, Figlio
         i = Figlio

      ' Altrimenti MatrOrd Š stato ristrutturato in un heap da 1 a
      ' LivelloMass, perci• esce:
      ELSE
         EXIT DO
      END IF
   LOOP
END SUB

' ============================== FiltraSu =================================
'   La procedura FiltraSu ristruttura gli elementi da 1 a LivelloMass in
'   MatrOrd in un "heap" (vedi il diagramma nella procedura OrdHeap).
' ============================================================================
'
SUB FiltraSu (LivelloMass) STATIC
   i = LivelloMass

   ' Sposta il valore in MatrOrd(LivelloMass) in su nell'heap finch‚ non Š
   ' giunto a un nodo valido (cioŠ finch‚ non Š maggiore dei due nodi figlio,
   ' o finch‚ non ha raggiunto 1, la cima dell'heap):
   DO UNTIL i = 1
      Parent = i \ 2            ' Ottiene l'indice del nodo genitore.

      ' Il valore del nodo corrente Š maggiore del valore del nodo genitore,
      ' perci• scambia i due elementi:
      IF MatrOrd(i).Lung > MatrOrd(Parent).Lung THEN
         SWAP MatrOrd(Parent), MatrOrd(i)
         ScambiaBarre Parent, i
         i = Parent

      ' Altrimenti l'elemento Š giunto alla posizione giusta nell'heap,
      ' perci• esce dalla procedura:
      ELSE
         EXIT DO
      END IF
   LOOP
END SUB

' ============================== Inizializza ==================================
'    Inizializza le matrici BackupOrd e LeggendaOpzioni, e chiama le
'    procedure ControllaSchermo, CasIniz, e IntCasuale%.
' ============================================================================
'
SUB Inizializza STATIC
   DIM MatrTemp(1 TO 43)

   ControllaSchermo                  ' Verifica se la modalit… Š monocolore
                                     ' o EGA e imposta il numero massimo di
                                     ' righe di testo.
   FOR i = 1 TO RigheMass
      MatrTemp(i) = i
   NEXT i

   IndiceMass = RigheMass

   RANDOMIZE TIMER              ' Seed il generatore di numeri casuali.
   FOR i = 1 TO RigheMass

      ' Chiama IntCasuale% per trovare un elemento casuale in MatrTemp tra
      ' 1 e IndiceMass, e assegna il valore nell'elemento a LungBarra:
      Indice = IntCasuale%(1, IndiceMass)
      LungBarra = MatrTemp(Indice)

      ' Sovrascrive il valore in MatrTemp(Indice) col valore in
      ' MatrTemp(IndiceMass) perch‚ il valore in MatrTemp(Indice) venga
      ' scelto una sola volta:
      MatrTemp(Indice) = MatrTemp(IndiceMass)

      ' Decrementa il valore di IndiceMass perch‚ MatrTemp(IndiceMass) non
      ' possa essere scelto al successivo passaggio del ciclo:
      IndiceMass = IndiceMass - 1

      ' Assegna il valore di LungBarra all'elemento .Lung, poi registra
      ' una stringa di LungBarra caratteri blocco (ASCII 223: ß) nell'
      '  elemento .StringaBarra:
      BackupOrd(i).Lung = LungBarra
      BackupOrd(i).StringaBarra = STRING$(LungBarra, 223)

      ' Registra il colore appropriato nell'elemento .ValColore:
      IF ColoriMass > 2 THEN
         BackupOrd(i).ValColore = (LungBarra MOD ColoriMass) + 1
      ELSE
         BackupOrd(i).ValColore = ColoriMass
      END IF
   NEXT i

   FOR i = 1 TO NUMOPZIONI          ' Legge le opzioni per il menu degli
      READ LeggendaOpzioni(i)       ' ordinamenti e li registra nella
   NEXT i                           ' matrice LeggendaOpzioni.

   CLS
   ReInizializza         ' Assegna i valori in BackupOrd a MatrOrd e traccia
                         ' sullo schermo le barre non ordinate.
   Silenzio = FALSO
   Pausa = 2             ' Inizializza Pausa a 2 cicli del temporizzatore
   CasIniz               ' (c. 1/9 di secondo). Disegna il bordo del menu
                         ' degli ordinamenti e stampa le opzioni.
END SUB

' =============================== IntCasuale% ===================================
'   Restituisce un intero casuale maggiore o uguale al parametro Basso
'   e minore o uguale al parametro Alto.
' ============================================================================
'
FUNCTION IntCasuale% (Basso, Alto) STATIC
   IntCasuale% = INT(RND * (Alto - Basso + 1)) + Basso
END FUNCTION

' ============================== InterrSuono =================================
'   Inverte il valore corrente di Silenzio, e lo stampa accanto all'opzione
'   "Effetto sonoro" nel menu degli ordinamenti.
' ============================================================================
'
SUB InterrSuono (Riga, Colonna) STATIC
   Silenzio = NOT Silenzio
   LOCATE Riga, Colonna
   IF Silenzio THEN
      PRINT ": SPENTO  ";
   ELSE
      PRINT ": ACCESO  ";
   END IF
END SUB

' =============================== MenuOrd ====================================
'   La procedura MenuOrd prima chiama la procedura ReInizializza per far s
'   che MatrOrd sia in forma non ordinata, poi sollecita l'utente a scegliere
'   tra le seguenti azioni:
'
'               * Eseguire uno degli algoritmi di ordinamento
'               * Accendere o spegnere l'effetto sonoro
'               * Aumentare o diminuire la velocit…
'               * Uscire dal programma
' ============================================================================
'
SUB MenuOrd STATIC
   Esc$ = CHR$(27)

   ' Crea una stringa comprendente le scelte valide:
   Opzioni$ = "IPHCSQ><E" + Esc$

   DO

      ' Visualizza il cursore:
      LOCATE NUMOPZIONI + 8, COLONNASIN + 27, 1

      Scelta$ = UCASE$(INPUT$(1))          ' Legge la scelta e prova se Š
      Selezione = INSTR(Opzioni$, Scelta$) ' una opzione dal menu.

      ' L'utente ha scelto una delle procedure di ordinamento:
      IF (Selezione >= 1) AND (Selezione <= NUMORDINAMENTI) THEN
         ReInizializza                  ' Ricasualizza le barre.
         LOCATE , , 0                   ' Rende invisibile il cursore.
         PrimoPiano = 0                 ' Imposta i valori di schermo inverso.
         Sfondo = 7
         TempoIniz = TIMER              ' Registra il tempo iniziale.
      END IF

      ' Salta alla procedura relativa al tasto selezionato:
      SELECT CASE Scelta$
         CASE "I"
            OrdInser
         CASE "P"
            OrdPerm
         CASE "H"
            OrdHeap
         CASE "C"
            OrdScamb
         CASE "S"
            OrdShell
         CASE "Q"
            OrdQuick 1, RigheMass
         CASE ">"

            ' Decrementa Pausa per accelerare i tempi di ordinamento, e
            ' ritraccia il menu per cancellare i tempi precedenti (non
            ' saranno paragonabili a quelli successivi):
            Pausa = (2 * Pausa) / 3
            CasIniz

         CASE "<"

            ' Incrementa Pausa per ritardare i tempi di ordinamento, e
            ' ritraccia il menu per cancellare i tempi precedenti (non
            ' saranno paragonabili a quelli successivi):
            Pausa = (3 * Pausa) / 2
            CasIniz

         CASE "E"
            InterrSuono 12, COLONNASIN + 14

         CASE Esc$

            ' L'utente ha premuto ESC; esce dalla procedura e ritorna al
            ' livello del modulo:
            EXIT DO

         CASE ELSE

            ' Tasto non valido
      END SELECT

      IF (Selezione >= 1) AND (Selezione <= NUMORDINAMENTI) THEN
         PrimoPiano = ColoriMass            ' Disattiva il video inverso.
         Sfondo = 0
         TempoTrasc 0                       ' Stampa il tempo trascorso.
      END IF

   LOOP

END SUB

' =============================== OrdHeap ===================================
'  Il funzionamento di OrdHeap dipende da due altre procedure - FiltraSu
'  e FiltraGiu. FiltraSu ristruttura MatrOrd in un "heap," una struttura con
'  le caratteristiche delineate nel seguente diagramma:
'
'                               MatrOrd(1)
'                               /          \
'                    MatrOrd(2)           MatrOrd(3)
'                   /          \            /          \
'         MatrOrd(4)   MatrOrd(5)   MatrOrd(6)  MatrOrd(7)
'          /      \       /       \       /      \      /      \
'        ...      ...   ...       ...   ...      ...  ...      ...
'
'
'  in cui ogni "nodo genitore" Š maggiore dei rispettivi "nodi figlio"; per
'  esempio, MatrOrd(1) Š maggiore di MatrOrd(2) e MatrOrd(3), MatrOrd(3)
'  Š maggiore di MatrOrd(6) e MatrOrd(7), e cos via.
'
'  Di conseguenza, al completamento del primo ciclo FOR...NEXT in OrdHeap,
'  l'elemento massimo sar… MatrOrd(1).
'
'  Il secondo ciclo FOR...NEXT in OrdHeap scambia l'elemento in MatrOrd(1)
'  con l'elemento in RigheMass, ricostruisce l'heap (con FiltraGiu) con
'  RigheMass - 1, poi scambia l'elemento in MatrOrd(1) con l'elemento in
'  RigheMass - 1, ricostruisce l'heap con RigheMass - 2, e cos via,
'  finch‚ la matrice non Š ordinata.
' ============================================================================
'
SUB OrdHeap STATIC
   FOR i = 2 TO RigheMass
      FiltraSu i
   NEXT i

   FOR i = RigheMass TO 2 STEP -1
      SWAP MatrOrd(1), MatrOrd(i)
      ScambiaBarre 1, i
      FiltraGiu i - 1
   NEXT i
END SUB

' ============================= OrdInser ================================
'   La procedura OrdInser confronta via via la lunghezza di ogni elemento
'   in MatrOrd con la lunghezza degli elementi precedenti. Quando trova la
'   posizione appropriata dell'elemento corrente, lo inserisce e sposta in
'   basso tutti gli elementi successivi.
' ============================================================================
'
SUB OrdInser STATIC
   DIM TempVal AS TipoOrd
   FOR Riga = 2 TO RigheMass
      TempVal = MatrOrd(Riga)
      LungTemp = TempVal.Lung
      FOR J = Riga TO 2 STEP -1

         ' Finch‚ la lunghezza dell'elemento J-1 Š maggiore della lunghezza
         ' dell'elemento originario in MatrOrd(Riga), continua a spostare
         ' in basso gli elementi della matrice:
         IF MatrOrd(J - 1).Lung > LungTemp THEN
            MatrOrd(J) = MatrOrd(J - 1)
            StampaBarra J               ' Stampa la nuova barra.
            TempoTrasc J                ' Stampa il tempo trascorso.

         ' Se non lo Š, esce dal ciclo FOR...NEXT:
         ELSE
            EXIT FOR
         END IF
      NEXT J

      ' Inserisce il valore originario di MatrOrd(Riga) in MatrOrd(J):
      MatrOrd(J) = TempVal
      StampaBarra J
      TempoTrasc J
   NEXT Riga
END SUB

' ============================== OrdPerm ==================================
'    L'algoritmo OrdPerm percorre MatrOrd confrontando elementi adiacenti
'    e scambiando coppie di elementi non in ordine, e continua a ciclare
'    finch‚ non avvengono pi— scambi.
' ============================================================================
'
SUB OrdPerm STATIC
   Limite = RigheMass
   DO
      Scambi = FALSO
      FOR Riga = 1 TO (Limite - 1)

         ' Due elementi adiacenti non sono in ordine: li scambia
         ' e ne ritraccia le barre:
         IF MatrOrd(Riga).Lung > MatrOrd(Riga + 1).Lung THEN
            SWAP MatrOrd(Riga), MatrOrd(Riga + 1)
            ScambiaBarre Riga, Riga + 1
            Scambi = Riga
         END IF
      NEXT Riga

      ' Al passaggio successivo ordina solo fino al punto del precedente
      ' scambio:
      Limite = Scambi
   LOOP WHILE Scambi

END SUB

' ============================== OrdQuick ===================================
'   OrdQuick sceglie un elemento "pivot" a caso in MatrOrd, e poi sposta
'   tutti gli elementi maggiori del pivot da una parte, e tutti gli elementi
'   minori dall'altra. QuickSort poi si autochiama ricursivamente su ognuna
'   delle due sottomatrici definite dal pivot. Quando il numero di elementi
'   in una sottomatrice Š due, le chiamate ricursive terminano: la matrice
'   Š in ordine.
' ============================================================================
'
SUB OrdQuick (Basso, Alto)
   IF Basso < Alto THEN

      ' La sottomatrice ha solo due elementi; li scambia se non sono in
      ' ordine, e pone fine alla ricursione:
      IF Alto - Basso = 1 THEN
         IF MatrOrd(Basso).Lung > MatrOrd(Alto).Lung THEN
            SWAP MatrOrd(Basso), MatrOrd(Alto)
            ScambiaBarre Basso, Alto
         END IF
      ELSE

         ' Sceglie un elemento a caso come pivot, e lo sposta alla fine:
         IndiceCas = IntCasuale%(Basso, Alto)
         SWAP MatrOrd(Alto), MatrOrd(IndiceCas)
         ScambiaBarre Alto, IndiceCas
         PuntoSepar = MatrOrd(Alto).Lung
         DO

            ' Si avvicina al pivot da entrambe le direzioni:
            i = Basso: J = Alto
            DO WHILE (i < J) AND (MatrOrd(i).Lung <= PuntoSepar)
               i = i + 1
            LOOP
            DO WHILE (J > i) AND (MatrOrd(J).Lung >= PuntoSepar)
               J = J - 1
            LOOP

            ' Se non Š stato raggiunto l'elemento pivot, significa che due
            ' elementi sui due lati non sono in ordine; li scambia:
            IF i < J THEN
               SWAP MatrOrd(i), MatrOrd(J)
               ScambiaBarre i, J
            END IF
         LOOP WHILE i < J

         ' Riporta l'elemento pivot alla sua giusta posizione nella matrice:
         SWAP MatrOrd(i), MatrOrd(Alto)
         ScambiaBarre i, Alto

         ' Chiama la procedura OrdQuick ricursivamente (passa la sottomatrice
         ' pi— corta per prima per conservare spazio di memoria):
         IF (i - Basso) < (Alto - i) THEN
            OrdQuick Basso, i - 1
            OrdQuick i + 1, Alto
         ELSE
            OrdQuick i + 1, Alto
            OrdQuick Basso, i - 1
         END IF
      END IF
   END IF
END SUB

' ============================= OrdScamb =================================
'   OrdScamb confronta ogni elemento di MatrOrd - a partire dal primo - con
'   ogni elemento successivo.  Se uno degli elementi successivi risulta
'   minore dell'elemento corrente, viene scambiato con l'elemento corrente
'   e il procedimento ricomincia dal successivo elemento di MatrOrd.
' ============================================================================
'
SUB OrdScamb STATIC
   FOR Riga = 1 TO RigheMass
      RigaMinima = Riga
      FOR J = Riga + 1 TO RigheMass
         IF MatrOrd(J).Lung < MatrOrd(RigaMinima).Lung THEN
            RigaMinima = J
            TempoTrasc J
         END IF
      NEXT J

      ' Ha trovato una riga pi— corta di quella corrente;
      ' scambia i due elementi:
      IF RigaMinima > Riga THEN
         SWAP MatrOrd(Riga), MatrOrd(RigaMinima)
         ScambiaBarre Riga, RigaMinima
      END IF
   NEXT Riga
END SUB

' =============================== OrdShell ===================================
'  La procedura OrdShell Š simile alla procedura OrdPerm, per• OrdShell inizia
'  a confrontare elementi lontani tra di loro (la distanza Š il valore della
'  variabile Scarto, che inizialmente viene posto alla met… della distanza tra
'  il primo a l'ultimo elemento); poi confronta elementi sempre pi— vicini
'  (l'ultima iterazione della procedura, quando Scarto Š uguale a uno, si
'  riduce a un ordinamento per permutazioni).
' ============================================================================
'
SUB OrdShell STATIC

   ' Imposta lo scarto per il confronto a met… del numero di record in MatrOrd:
   Scarto = RigheMass \ 2

   DO WHILE Scarto > 0          ' Cicla finch‚ Scarto non diventa zero.
      Limite = RigheMass - Scarto
      DO
         Scambi = FALSO         ' Presume non vi siano stati scambi
                                ' con questo valore di Scarto.

         ' Confronta elementi e scambia quelli non in ordine:
         FOR Riga = 1 TO Limite
            IF MatrOrd(Riga).Lung > MatrOrd(Riga + Scarto).Lung THEN
               SWAP MatrOrd(Riga), MatrOrd(Riga + Scarto)
               ScambiaBarre Riga, Riga + Scarto
               Scambi = Riga
            END IF
         NEXT Riga

         ' Al passaggio successivo ordina solo fino al punto dell'ultimo
         ' scambio:
         Limite = Scambi - Scarto
      LOOP WHILE Scambi

      ' Nessuno scambio al precedente valore di scarto; lo dimezza:
      Scarto = Scarto \ 2
   LOOP
END SUB

' ============================== ReInizializza ================================
'   Reimposta la matrice MatrOrd all'originario stato non ordinato e ne
'   stampa le barre colorate.
' ============================================================================
'
SUB ReInizializza STATIC
   FOR i = 1 TO RigheMass
      MatrOrd(i) = BackupOrd(i)
   NEXT i

   FOR i = 1 TO RigheMass
      LOCATE i, 1
      COLOR MatrOrd(i).ValColore
      PRINT MatrOrd(i).StringaBarra;
   NEXT i

   COLOR ColoriMass, 0
END SUB

' =============================== ScambiaBarre ===================================
'   Chiama StampaBarra due volte per scambiare le barre in Riga1 e Riga2
'   e poi chiama la procedura TempoTrasc.
' ============================================================================
'
SUB ScambiaBarre (Riga1, Riga2) STATIC
   StampaBarra Riga1
   StampaBarra Riga2
   TempoTrasc Riga1
END SUB

' ============================== StampaBarra =================================
'  Stampa MatrOrd(Riga).StringaBarra alla riga indica dal parametro Riga,
'  usando il colore in MatrOrd(Riga).ValColore.
' ============================================================================
'
SUB StampaBarra (Riga) STATIC
   LOCATE Riga, 1
   COLOR MatrOrd(Riga).ValColore
   PRINT MatrOrd(Riga).StringaBarra;
END SUB

' ============================= TempoTrasc ==================================
'    Stampa il tempo (in secondi) trascorso durante l'ordinamento. Questo
'    include sia il tempo necessario per ritracciare le barre che le pause
'    causate dall'istruzione SOUND per l'emissione dei suoni, e quindi non
'    rappresenta la velocit… reale dell'ordinamento.
' ============================================================================
'
SUB TempoTrasc (RigaCorrente) STATIC
   CONST FORMAT = "  &###.### secondi  "

   ' Stampa la selezone corrente e il numero dei secondi trascorsi, in
   ' modalit… video inverso:
   COLOR PrimoPiano, Sfondo
   LOCATE Selezione + 4, COLONNASIN - 2
   PRINT USING FORMAT; LeggendaOpzioni(Selezione); TIMER - TempoIniz;

   IF Silenzio THEN
      SOUND 30000, Pausa        ' L'effetto sonoro Š spento: pausa solamente.
   ELSE
      SOUND 60 * RigaCorrente, Pausa  ' L'effetto sonoro Š acceso: emette un
   END IF                             ' suono durante la pausa.

   COLOR ColoriMass, 0                ' Ripristina i normali colori di
                                      ' primopiano e di sfondo.
END SUB

