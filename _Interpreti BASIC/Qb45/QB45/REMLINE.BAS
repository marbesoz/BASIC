DEFINT A-Z
'
'   Microsoft RemLine - Utilit… per la rimozione dei numeri di riga.
'   Copyright (C) Microsoft Corporation   - 1985, 1986, 1987
'
'   REMLINE.BAS Š un programma per la rimozione dei numeri di riga dai
'   programmi Microsoft in BASIC. Rimuove solo i numeri di riga che non
'   sono l'oggetto di una delle seguenti istruzioni: GOSUB, RETURN, GOTO,
'   THEN, ELSE, RESUME, RESTORE, e RUN.
'
'   Per eseguire REMLINE digitare
'
'      REMLINE [<input> [, <output>]]
'
'   dove <input> Š il nome del file da elaborare e <output> Š il nome
'   del file o periferica a cui va indirizzato l'output riformattato.
'   Se non si specifica l'estensione, Š predefinita .BAS (tranne che per
'   le periferiche). Se non si specificano nomi di file, REMLINE sollecita
'   l'utente. Se i due nomi di file sono uguali, REMLINE salva il file
'   originale con l'estensione .BAK.
'
'   REMLINE opera con i seguenti presupposti:
'
'     1. Il programma deve essere sintatticamente corretto, e deve
'        funzionare con l'interprete BASICA o GWBASIC.
'     2. C'Š un limite di 400 righe. Per elaborare file pi— grandi,
'        modificare la costante RigheMass.
'     3. Il primo numero in ogni riga viene considerato un numero di riga,
'        perci• le righe di continuazione (in costrutti particolari
'        al compiler) potrebbero non essere gestite correttamente.
'     4. REMLINE gestisce espressioni semplici in cui la funzione ERL Š usata
'        con operatori relazionali come =, <, e >. Per esempio, l'istruzione
'        seguente viene gestita correttamente:
'
'             IF ERL = 100 THEN END
'
'        e il numero 100 non viene rimosso dalla riga d'origine. Tuttavia,
'        espressioni ERL complesse contenenti gli operatori +, -, AND, OR,
'        XOR, EQV, MOD, o IMP potrebbero non essere gestite bene. Ad esempio,
'        nell'istruzione seguente REMLINE non riconosce il riferimento alla
'        riga 105 e ne rimuove il numero dal programma:
'
'             IF ERL + 5 = 105 THEN END
'
'   Per cambiare il modo in cui REMLINE formatta l'output, modificare le
'   istruzioni per l'output della SUB CreaFileOut; vedere l'esempio nel
'   commento per una alternativa.

' Dichiarazioni delle funzioni e delle subroutine

DECLARE FUNCTION OttToken$ (StrDaAnal$, Delim$)
DECLARE FUNCTION StrSpn% (StringaIn$, Separatore$)
DECLARE FUNCTION StrBrk% (StringaIn$, Separatore$)
DECLARE FUNCTION EUnaCifra% (Car$)
DECLARE SUB LeggiNomiFile ()
DECLARE SUB AggTabella ()
DECLARE SUB CreaFileOut ()
DECLARE SUB InizTabChiave ()

' Costanti e variabili globali

CONST VERO = -1
CONST FALSO = 0
CONST RigheMass = 400

DIM SHARED TabellaRighe!(RigheMass)
DIM SHARED ContaRighe
DIM SHARED Separ$, FileInput$, FileOutput$, FileTemp$

' Dati per l'identificazione delle parole chiave

CONST NumParChiave = 9
DIM SHARED TabParChiave$(NumParChiave)

DatiChiave:
   DATA THEN, ELSE, GOSUB, GOTO, RESUME, RETURN, RESTORE, RUN, ERL, ""

' Inizio del programma a livello di modulo

   Separ$ = " ,:=<>()" + CHR$(9)
   InizTabChiave
   LeggiNomiFile
   ON ERROR GOTO ErrFile1
   OPEN FileInput$ FOR INPUT AS 1
   ON ERROR GOTO 0
   COLOR 7: PRINT "Elaborazione"; : COLOR 23: PRINT " . . .": COLOR 7: PRINT
   AggTabella
   CLOSE #1
   OPEN FileInput$ FOR INPUT AS 1
   ON ERROR GOTO ErrFile2
   OPEN FileOutput$ FOR OUTPUT AS 2
   ON ERROR GOTO 0
   CreaFileOut
   CLOSE #1, #2
   IF FileOutput$ <> "CON" THEN CLS

END

ErrFile1:
   CLS
   PRINT "      Nome di file non valido": PRINT
   INPUT "      Nuovo nome del file (premere INVIO per terminare): ", FileInput$
   IF FileInput$ = "" THEN END
ErrFile2:
   INPUT "      Nome del file di output (o INVIO per visualizzare sullo schermo) :", FileOutput$
   PRINT
   IF (FileOutput$ = "") THEN FileOutput$ = "CON"
   IF FileTemp$ = "" THEN
      RESUME
   ELSE
      FileTemp$ = ""
      RESUME NEXT
   END IF

'
' AggTabella:
'   Esamina l'intero file di testo cercando numeri di riga che siano
'   l'oggetto di GOTO, GOSUB, ecc. Man mano che li trova li registra in
'   una tabella, che verr… usata a un successivo passaggio (vedi CreaFileOut)
'   in cui tutti i numeri di riga che non si trovano sulla tabella vengono
'   rimossi.
' Input:
'   Usa le globali TabParChiave$, NumParChiave, e Separ$
' Output:
'   Modifica TabellaRighe! e ContaRighe
'
SUB AggTabella STATIC

   DO WHILE NOT EOF(1)
      ' Ottiene la riga e il primo token
      LINE INPUT #1, RigaIn$
      Tok$ = OttToken$(RigaIn$, Separ$)
      DO WHILE (Tok$ <> "")
         FOR IndChiave = 1 TO NumParChiave
            ' Prova se il token Š una parola chiave
            IF (TabParChiave$(IndChiave) = UCASE$(Tok$)) THEN
               ' Legge il token (forse un numero di riga) che lo segue
               Tok$ = OttToken$("", Separ$)
               ' Controlla se Š effettivamente un numero di riga.
               ' Il LOOP Š necessario perch‚ con ON GOSUB e ON GOTO
               ' vi sono pi— numeri; termina quando incontra un
               ' carattere non numerico.
               DO WHILE (EUnaCifra(LEFT$(Tok$, 1)))
                  ContaRighe = ContaRighe + 1
                  TabellaRighe!(ContaRighe) = VAL(Tok$)
                  Tok$ = OttToken$("", Separ$)
                  IF Tok$ <> "" THEN IndChiave = 0
               LOOP
            END IF
         NEXT IndChiave
         ' Ottiene il token successivo
         Tok$ = OttToken$("", Separ$)
      LOOP
   LOOP

END SUB

'
' CreaFileOut:
'  Genera un file di output senza i numeri di riga non necessari.
' Input:
'  Usa le globali TabellaRighe!, ContaRighe, e Separ$
' Output:
'  Il file elaborato
'
SUB CreaFileOut STATIC

   ' Per velocizzare elimina la virgola e i due punti
   ' (non servono per separare il primo token)
   Sep$ = " " + CHR$(9)
   DO WHILE NOT EOF(1)
      LINE INPUT #1, RigaIn$
      IF (RigaIn$ <> "") THEN
         ' Legge ed elabora il primo token se Š un numero di riga
         Tok$ = OttToken$(RigaIn$, Sep$)
         IF EUnaCifra(LEFT$(Tok$, 1)) THEN
            NumeroRiga! = VAL(Tok$)
            TrovInTab = FALSO
            ' Prova se il numero di riga si trova nella tabella dei numeri
            ' che sono oggetto di istruzioni
            FOR Indice = 1 TO ContaRighe
               IF (NumeroRiga! = TabellaRighe!(Indice)) THEN
                  TrovInTab = VERO
               END IF
            NEXT Indice
            ' Modifica la stringa (toglie il numero di riga)
            IF (NOT TrovInTab) THEN
               Tok$ = SPACE$(LEN(Tok$))
               MID$(RigaIn$, StrSpn(RigaIn$, Sep$), LEN(Tok$)) = Tok$
            END IF
              
            ' Si possono sostituire le precedenti istruzioni per cambiare
            ' il formato dell'output. Per esempio, provare queste:
               
            'TmpPos1 = StrSpn(RigaIn$, Sep$) + LEN(Tok$)
            'TmpPos2 = TmpPos1 + StrSpn(MID$(RigaIn$, TmpPos1), Sep$)
            '
            'IF TrovInTab THEN
            '   RigaIn$ = LEFT$(RigaIn$, TmpPos1 - 1) + CHR$(9) + MID$(RigaIn$, TmpPos2)
            'ELSE
            '   RigaIn$ = CHR$(9) + MID$(RigaIn$, TmpPos2)
            'END IF

         END IF
      END IF
      ' Stampa la riga al file o alla console (PRINT Š pi— veloce della
      ' periferica console)
      IF FileOutput$ = "CON" THEN
         PRINT RigaIn$
      ELSE
         PRINT #2, RigaIn$
      END IF
   LOOP

END SUB

'
' EUnaCifra:
'  Restituisce VERO se il carattere passato Š una cifra in base dieci. Dato
'  che ogni token BASIC che inizia con una cifra Š un numero, la funzione
'  controlla solo la prima cifra. Non controlla se il numero Š negativo dato
'  che non Š necessario.
' Input:
'  Car$ - primo carattere della stringa da controllare
' Output:
'  EUnaCifra - VERO se Š tra 0 e 9
'
FUNCTION EUnaCifra (Car$) STATIC

   IF (Car$ = "") THEN
      EUnaCifra = FALSO
   ELSE
      CarAsc = ASC(Car$)
      EUnaCifra = (CarAsc >= ASC("0")) AND (CarAsc <= ASC("9"))
   END IF

END FUNCTION

'
' InizTabChiave:
'  Inizializza una tabella di parole chiave. Il riconoscimento delle parole
'  chiave serve per distinguere i numeri di riga dalle costanti numeriche.
' Input:
'  Usa DatiChiave
' Output:
'  Modifica la matrice globale TabParChiave$
'
SUB InizTabChiave STATIC

   RESTORE DatiChiave
   FOR Conta = 1 TO NumParChiave
      READ KeyWord$
      TabParChiave$(Conta) = KeyWord$
   NEXT

END SUB

'
' LeggiNomiFile:
'  Legge un nome di file da COMMAND$ o lo sollecita dall'utente.
' Input:
'  Usa Command$ o l'input dell'utente
' Output:
'  Definisce FileInput$ e FileOutput$
'
SUB LeggiNomiFile STATIC

   IF (COMMAND$ = "") THEN
      CLS
      PRINT " Microsoft RemLine: Utilit… Rimozione Numeri di Riga"
      PRINT "        (.BAS Š l'estensione predefinita)"
      PRINT
      INPUT "Nome del file di origine (INVIO per terminare): ", FileInput$
      IF FileInput$ = "" THEN END
      INPUT "Nome del file di destinazione (INVIO per visualizzare sullo schermo): ", FileOutput$
      PRINT
      IF (FileOutput$ = "") THEN FileOutput$ = "CON"
   ELSE
      FileInput$ = UCASE$(OttToken$(COMMAND$, Separ$))
      FileOutput$ = UCASE$(OttToken$("", Separ$))
      IF (FileOutput$ = "") THEN
         INPUT "Nome del file di destinazione (INVIO per visualizzare sullo schermo): ", FileOutput$
         PRINT
         IF (FileOutput$ = "") THEN FileOutput$ = "CON"
      END IF
   END IF
   IF INSTR(FileInput$, ".") = 0 THEN
      FileInput$ = FileInput$ + ".BAS"
   END IF
   IF INSTR(FileOutput$, ".") = 0 THEN
      SELECT CASE FileOutput$
         CASE "CON", "SCRN", "PRN", "COM1", "COM2", "LPT1", "LPT2", "LPT3"
            EXIT SUB
         CASE ELSE
            FileOutput$ = FileOutput$ + ".BAS"
      END SELECT
   END IF
   DO WHILE FileInput$ = FileOutput$
      FileTemp$ = LEFT$(FileInput$, INSTR(FileInput$, ".")) + "BAK"
      ON ERROR GOTO ErrFile1
      NAME FileInput$ AS FileTemp$
      ON ERROR GOTO 0
      IF FileTemp$ <> "" THEN FileInput$ = FileTemp$
   LOOP

END SUB

'
' OttToken$:
'  Analizza i token di una stringa. Per token si intende una "parola"
'  delimitata da separatori (spazi, virgole, ecc.); i token vanno
'  identificati per fare l'analisi delle istruzioni e dei comandi. Per usare
'  la funzione OttToken$, alla prima chiamata va passata la stringa da
'  analizzare e alle chiamate successive una stringa nulla, finch‚ la
'  funzione non restituisce un carattere nullo indicando la fine dell'analisi
'  per l'intera stringa.
'
' Input:
'  StrDaAnal$ = stringa da analizzare
'  Delim$  = stringa dei separatori
' Output:
'  OttToken$ = il token successivo
'
FUNCTION OttToken$ (StrDaAnal$, Delim$) STATIC

   ' SalvaStr$ e PosIniz devono essere statiche tra chiamate
   ' (le altre variabili sono statiche solo per efficienza).
   ' Se Š la prima chiamata, copia la stringa
   IF (StrDaAnal$ <> "") THEN
      PosIniz = 1
      SalvaStr$ = StrDaAnal$
   END IF
  
   ' Trova l'inizio del token successivo
   NuovaPos = StrSpn(MID$(SalvaStr$, PosIniz, LEN(SalvaStr$)), Delim$)
   IF NuovaPos THEN
      ' Imposta il puntatore all'inizio del token
      PosIniz = NuovaPos + PosIniz - 1
   ELSE
      ' Se non vi sono pi— token, termina e restituisce il carattere nullo
      OttToken$ = ""
      EXIT FUNCTION
   END IF

   ' Trova la fine del token
   NuovaPos = StrBrk(MID$(SalvaStr$, PosIniz, LEN(SalvaStr$)), Delim$)
   IF NuovaPos THEN
      ' Imposta il puntatore alla fine del token
      NuovaPos = PosIniz + NuovaPos - 1
   ELSE
      ' Se non la trova, restituisce come valore il resto della stringa
      NuovaPos = LEN(SalvaStr$) + 1
   END IF
   ' Elimina il token dalla stringa da analizzare
   OttToken$ = MID$(SalvaStr$, PosIniz, NuovaPos - PosIniz)
   ' Imposta la nuova posizione iniziale
   PosIniz = NuovaPos

END FUNCTION

'
' StrBrk:
'  Cerca il primo carattere in StringaIn$ che sia tra quelli in
'  Separatore$, e ne restituisce l'indice. La funzione Š utile per
'  trovare la fine di un token.
' Input:
'  StringaIn$ = stringa in cui cercare
'  Separatore$ = caratteri da trovare
' Output:
'  StrBrk = indice della prima corrispondenza in StringaIn$,
'  oppure 0 se non c'Š corrispondenza
'
FUNCTION StrBrk (StringaIn$, Separatore$) STATIC

   Lun = LEN(StringaIn$)
   PosIniz = 1
   ' Cerca la fine del token (il primo carattere delimitatore).
   DO WHILE INSTR(Separatore$, MID$(StringaIn$, PosIniz, 1)) = 0
      IF PosIniz > Lun THEN
         StrBrk = 0
         EXIT FUNCTION
      ELSE
         PosIniz = PosIniz + 1
      END IF
   LOOP
   StrBrk = PosIniz
  
END FUNCTION

'
' StrSpn:
'  Cerca il primo carattere in StringaIn$ che non sia tra quelli in
'  Separatore$, e ne restituisce l'indice. La funzione Š utile per
'  trovare l'inizio di un token.
' Input:
'  StringaIn$ = stringa in cui cercare
'  Separatore$ = caratteri da ricercare
' Output:
'  StrSpn = Indice della prima non corrispondenza in StringaIn$,
'  oppure 0 se corrispondono tutti i caratteri
'
FUNCTION StrSpn% (StringaIn$, Separatore$) STATIC

   Lun = LEN(StringaIn$)
   PosIniz = 1
   ' Cerca l'inizio del token (un carattere che non sia un delimitatore)
   DO WHILE INSTR(Separatore$, MID$(StringaIn$, PosIniz, 1))
      IF PosIniz > Lun THEN
         StrSpn = 0
         EXIT FUNCTION
      ELSE
         PosIniz = PosIniz + 1
      END IF
   LOOP
   StrSpn = PosIniz

END FUNCTION

