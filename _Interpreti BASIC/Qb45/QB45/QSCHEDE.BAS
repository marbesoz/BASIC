'* QSchede - Un database che interfaccia con l'utente come uno schedario.
'* Ogni record nel database Š rappresentato da una scheda, e l'utente
'* pu• visualizzare le schede con i normali tasti di scorrimento;
'* altri comandi permettono all'utente di modificare, aggiungere,
'* ordinare, trovare, o cancellare schede.
'*
'* Input:  Tastiera - comandi e immissioni di testo dell'utente
'*         File - i record del database
'*
'* Output: Schermo - visualizzazione schede e guida
'*         File - i record del database records
'*

' Il programma a livello di modulo inizia qui.

'*************** Dichiarazioni e definizioni ********************

DEFINT A-Z     'Reimposta il tipo dati predefinito da numero in precisione
               'semplice a intero

' Definisce nomi simili ai nomi dei tasti con i relativi codici di tasto.
CONST SPAZIO = 32, ESC = 27, INVIO = 13, TASTOTAB = 9
CONST GIU = 80, SU = 72, SINISTRA = 75, DESTRA = 77
CONST HOME = 71, FINE = 79, PGGIU = 81, PGSU = 73
CONST INS = 82, CANC = 83, NULLO = 0
CONST CTRLD = 4, CTRLG = 7, CTRLH = 8, CTRLS = 19, CTRLV = 22

' Definisce nomi per i numeri dei colori. Aggiunge INTENSO al nome
' di un colore per la versione intensa.
CONST NERO = 0, BLU = 1, VERDE = 2, AZZURRO = 3, ROSSO = 4, MAGENTA = 5
CONST GIALLO = 6, BIANCO = 7, INTENSO = 8

' Assegna colori ai diversi tipi di testo. Cambiando il colore assegnato,
' si pu• cambiare il colore della visualizzazione di QSCHEDE. I colori
' iniziali funzionano con display a colori o in bianco e nero.
CONST SFONDO = NERO, NORMALE = BIANCO, EVIDENZ = BIANCO + INTENSO
' Codici per colore normale ed evidenziato (usato in istruzioni dati)
CONST COLNORMALE = 0, COLEVIDENZ = 1

' Posizioni sullo schermo - Inizializzate per 25 righe. Le posizioni sullo
' schermo si possono modificare per modalit… a 43 righe se si dispone di
' adattatore EGA o VGA.
CONST GUIDALT = 16, GUIDBAS = 23, GUIDSIN = 58, GUIDLARG = 23
CONST SCHEDEPERSCHERMO = 7, ULTIMARIGA = 25

' Altre costanti simboliche
CONST FALSO = 0, VERO = NOT FALSO
CONST CURSOREACC = 1, CURSORESPEN = 0

' Nomi di file
CONST FILETMP$ = "$$$87y$.$5$"       ' Nome di file insolito

' Nomi dei campi
CONST NPERSONA = 0, NNOTE = 1, NGIORNO = 2, NMESE = 3, NANNO = 4, NTELEF = 5
CONST NINDIR = 6, NCAP = 7, NCITTA = 8, NPROV = 9, NCAMPI = NPROV + 1

' Dichiara un tipo dati definito dall'utente (una struttura di dati) per
' i record del file ad accesso casuale.
TYPE PERSONA
    NumScheda   AS INTEGER          'Il primo elemento Š il numero della scheda
    Nome        AS STRING * 44      'Nome (in order for alphabetical sort)
    Note        AS STRING * 38      'Note sulla persona
    Giorno      AS INTEGER          'Giorno di nascita 
    Mese        AS INTEGER          'Mese di nascita
    Anno        AS INTEGER          'Anno di nascita
    Telef       AS STRING * 12      'Numero telefonico
    Indirizzo   AS STRING * 33      'Indirizzo
    Cap         AS STRING * 5       'Codice di avviamento postale
    Citta       AS STRING * 17      'Citt…
    Prov        AS STRING * 2       'Capoluogo di provincia
END TYPE

' Le dichiarazioni di procedure SUB iniziano qui.

' Questo spazio Š riservato

DECLARE SUB TastoAscii (Scelta$, SchedaSup%, UltimaScheda%)
DECLARE SUB Termina (UltimaScheda%)
DECLARE SUB CancGuida ()
DECLARE SUB DisSchede ()
DECLARE SUB ModScheda (scheda AS PERSONA)
DECLARE SUB InizIndice (UltimaScheda%)
DECLARE SUB StampaIndir (scheda AS PERSONA)
DECLARE SUB OrdinaIndice (CampoOrd%, UltimaScheda%)
DECLARE SUB MostraGuidaVis ()
DECLARE SUB MostraSchedaSup (SchedaLav AS PERSONA)
DECLARE SUB MostraGuidaMod ()
DECLARE SUB MostraRigaCom ()
DECLARE SUB MostraSchede (SchedaSup%, UltimaScheda%)

' Le dichiarazioni di procedure FUNCTION iniziono qui.
DECLARE FUNCTION ModStringa$ (StringaIn$, Lungezza%, CampoSucc%)
DECLARE FUNCTION TrovaScheda% (SchedaSup%, UltimaScheda%)
DECLARE FUNCTION Prompt$ (Msg$, Riga%, Colonna%, Lungezza%)
DECLARE FUNCTION SelezCampo% ()

' Le dichiarazioni di procedure terminano qui.

' Definisce una matrice temporanea Indice() per illustrare lo schermo QSCHEDE.
REDIM SHARED Indice(1) AS PERSONA

' Definisce un record fittizio come scheda di lavoro.
DIM scheda AS PERSONA

'*************** Le dichiarazioni e definizioni terminano qui ********************

' Le istruzioni eseguibili di QSCHEDE iniziano qui.

' Apre il file di dati QSCHEDE.DAT per l'accesso casuale usando file #1



' Per contare i record nel file, divide la lunghezza del file per la
' lunghezza di un singolo record; usa la divisione intera (\) invece
' della divisione normale (/). Assegna il risultante valore a UltimaScheda.



' Ridefinisce la matrice Indice perch‚ contenga i record nel file pi—
' 20 altri (i record in pi— permettono all'utente di aggiungere schede).
' La matrice Š dinamica - cioŠ il numero di elementi in Indice() varia
' secondo le dimensioni del file. Inoltre, Indice Š una procedura in comune,
' per cui Š disponibile a tutte le procedure SUB e FUNCTION del programma.
'
' Notare che la gestione di errori permette a QSCHEDE di terminare con un
' messaggio di errore se la memoria disponibile non Š sufficiente. Se non
' viene rilevato alcun errore, la gestione di errori viene disattivata dopo
' l'istruzione REDIM.



' Usa il blocco istruzione IF...THEN...ELSE per decidere se caricare
' i record dal file su disco QSCHEDE.DAT alla matrice di record detta
' Indice() dichiarata in precedenza. Nella parte IF, controlla se vi
' sono effettivamente record nel file. Se ve ne sono, UltimaScheda
' sar… maggiore di 0, e si chiamer… la procedura InizIndice per caricare
' i record in Indice(). UltimaScheda sar… 0 se non vi sono ancora record
' nel file. In questo caso, verr… eseguita la clausola ELSE. Le istruzioni
' tra ELSE e END IF iniziano la matrice Indice() alla scheda no. 1.




' Usa la procedura DisSchede per inizializzare lo schermo e disegnare
' le schede. Poi imposta la prima scheda come scheda superiore. Infine
' passa le variabili SchedaSup e UltimaScheda come argomenti alla
' procedura MostraSchede. La chiamata a MostraSchede mette tutti i dati
' della SchedaSup sulla prima scheda sullo schermo, e poi mette i dati
' della prima riga (il nome della persona) sulle schede rimanenti.




' Lascia la figura sullo schermo a tempo indeterminato con un'istruzione
' DO...LOOP senza condizioni. La parte DO dell'istruzione va messa alla
' successiva riga di programma. La parte LOOP va messa subito prima della
' istruzione END. Questo ciclo contiene la parte centrale del programma
' dedicato all'interazione dell'utente con QSCHEDE.




' Legge la pressione dei tasti dell'utente con un'istruzione DO...LOOP.
' All'interno del ciclo, usa la funzione INKEY$ per rilevare la battuta di
' tasto dell'utente, che viene poi assegnata a una variabile a stringa. La
' parte WHILE della riga LOOP continua a provare la variabile a stringa.
' Finch‚ non viene premuto un tasto, INKEY$ restituisce la stringa nulla
' (cioŠ di lunghezza zero), rappresentata da "". Alla pressione di un tasto,
' INKEY$ restituisce una stringa di lunghezza maggiore di zero, e il ciclo
' termina.




' Usa la funzione LEN per determinare se Scelta$ consiste di pi— di un
' carattere (un singolo byte). Se Scelta$ Š un solo carattere (cioŠ se Š
' lungo meno di due 2 byte), il tasto premuto era un normale tasto di
' carattere (questi vengono detti tasti ASCII perch‚ fanno parte del
' set di caratteri ASCII). Se l'utente digita un carattere ASCII, ci•
' indica la selezione di uno dei comandi dalla riga di comando di QSCHEDE
' in fondo allo schermo. Se l'utente ha premuto un tasto ASCII, usa la
' funzione LCASE$ per convertirlo in minuscola (nel caso sia stata digitata
' una maiuscola).
'
' La clausola ELSE viene eseguita solo se Scelta$ Š pi— lunga di un
' carattere singolo (e non Š quindi un tasto della riga di comando).
' Se Scelta$ non Š un tasto ASCII, rappresenta un tasto "esteso". (I
' tasti estesi includono i tasti di DIREZIONE sul tastierino numerico;
' perci• QSCHEDE li deve rilevare.) La funzione RIGHT$ viene poi impiegata
' per rimuovere il byte extra, lasciando un valore che pu• corrispondere
' a uno dei tasti di DIREZIONE. Usa poi il costrutto SELECT CASE per
' rispondere ai valori dei tasti di DIREZIONE sul tastierino numerico.



' Riposiziona le schede secondo il tasto premuto dall'utente,
' e chiama la procedura MostraSchede per visualizzarle.



' Il ciclo DO senza condizioni termina qui.


END

' La sequenza delle istruzioni eseguibili a livello di modulo termina
' qui. Il programma pu• legittimamente terminare altrove, ma la normale
' sequenza di esecuzione termina qui. Le istruzioni poste oltre la
' istruzione END vengono eseguite solo se invocate da altre istruzioni.
                           
' La prima etichetta, ErrMemoria, gestisce errori.

ErrMemoria:
    PRINT "Memoria insufficiente. Impossibile leggere il file."
    END

' Istruzioni dati per output sullo schermo - inizializzate a 25 righe.
' Si possono modificare per modalit… a 43 righe se si dispone di un
' adattatore EGA o VGA.

SchermoSchede:
DATA "                  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
DATA "                  ³                                              ³"
DATA "               ÚÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÍÍµ"
DATA "               ³                                              ³  ³"
DATA "            ÚÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÍÍµ  ³"
DATA "            ³                                              ³  ³  ³"
DATA "         ÚÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÍÍµ  ³  ³"
DATA "         ³                                              ³  ³  ³  ³"
DATA "      ÚÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÍÍµ  ³  ³  ³"
DATA "      ³                                              ³  ³  ³  ³  ³"
DATA "   ÚÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÍÍµ  ³  ³  ÃÄÄÙ"
DATA "   ³                                              ³  ³  ³  ³  ³"
DATA "ÚÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÍÍµ  ³  ³  ÃÄÄÙ"
DATA "³ ____________________________________________ ³  ³  ³  ³  ³"
DATA "ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ  ³  ³  ÃÄÄÙ"
DATA "³ Note: ______________________________________ ³  ³  ³  ³"
DATA "³                                              ³  ³  ÃÄÄÙ"
DATA "³ Data di nasc.: __/__/__    Tel: ____________ ³  ³  ³"
DATA "³                                              ³  ÃÄÄÙ"
DATA "³ Indirizzo: _________________________________ ³  ³"
DATA "³                                              ÃÄÄÙ"
DATA "³ CAP:_____ Citt…: _________________ Prov:(__) ³"
DATA "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

' Codici colore e stringhe per la guida in visualizzazione

GuidaVis:
DATA 0,  "Per selezionare una"
DATA 0,  "scheda usare i tasti:"
DATA 1, "        SU"
DATA 1, "        GIU'"
DATA 1, "        PGSU"
DATA 1, "        PGGIU'"
DATA 1, "        HOME"
DATA 1, "        FINE"
DATA 1, ""
DATA 1, ""

' Codici colore e stringhe per la guida in modalit… modifica

GuidaMod:
DATA 0,  "Al campo successivo:"
DATA 1, "      TAB"
DATA 0,  "Registra la scheda:"
DATA 1, "      INVIO"
DATA 0,  "Modifica il campo:"
DATA 1, "      CANC     BKSP"
DATA 1, "      DESTRA   SINISTRA"
DATA 1, "      HOME     END"
DATA 1, "      INS      ESC"

' Riga, colonna, e lunghezza di ogni campo

PosizCampi:
DATA 14, 3, 44                      : ' Nome
DATA 16, 9, 38                      : ' Note
DATA 18, 18, 2                      : ' Giorno
DATA 18, 21, 2                      : ' Mese
DATA 18, 24, 2                      : ' Anno
DATA 18, 35, 12                     : ' Telef
DATA 20, 14, 33                     : ' Indirizzo
DATA 22, 7, 5                       : ' CAP
DATA 22, 20, 17                     : ' Citt…
DATA 22, 44, 2                      : ' Prov
DATA 0, 0, 0

'*
'* CancGuida - Immette spazi vuoti nella zona schermo della guida.
'*
'* Parametri:  Nessuno
'*
'* Output:     Spazi vuoti sullo schermo
'*
SUB CancGuida

    ' Cancella la guida sui tasti
    COLOR NORMALE, SFONDO
    FOR Riga = GUIDALT TO GUIDBAS
        LOCATE Riga, GUIDSIN
        PRINT SPACE$(GUIDLARG)
    NEXT

    ' Cancella la riga di comando
    LOCATE ULTIMARIGA, 1
    PRINT SPACE$(80);

END SUB

'*
'* DisSchede - Inizializza lo schermo: imposta i colori, la larghezza
'* e l'altezza; cancella lo schermo; nasconde il cursore. Poi stampa sullo
'* schermo il testo delle schede e la guida in visualizzazione.
'*
'* Parametri:  Nessuno
'*
'* Output:     Testo sullo schermo
'*
SUB DisSchede

    ' Cancella e colora lo schermo.
    WIDTH 80, ULTIMARIGA
    COLOR NORMALE, SFONDO
    CLS
    LOCATE , , CURSORESPEN, 0, 7

    ' Visualizza i caratteri grafici che formano le schede.
    RESTORE SchermoSchede
    FOR Riga = 1 TO 23
        LOCATE Riga, 1
        READ Tmp$
        PRINT Tmp$;
    NEXT

    ' Visualizza la guida.
    CALL MostraGuidaVis

END SUB

'*
'* InizIndice - Legge i record dal file e assegna i valori ai record
'* della matrice. I valori degli indici rappresentano l'ordine dei
'* record nel file. L'ordine dei record nella matrice cambier… in
'* seguito a ordinamenti o aggiunte, ma il campo NumScheda rappresenter…
'* sempre la posizione in cui i record effettivamente si trovano nel file.
'*
'* Parametri:  UltimaScheda - il numero dei record nella matrice
'*
'* Input:      Il file "QSCHEDE.DAT"
'*
SUB InizIndice (UltimaScheda) STATIC
DIM scheda AS PERSONA

    FOR record = 1 TO UltimaScheda
    
        ' Legge un record dal file e ne trascrive i campi nella matrice.
        GET #1, record, scheda
        Indice(record).NumScheda = record
        Indice(record).Nome = scheda.Nome
        Indice(record).Note = scheda.Note
        Indice(record).Giorno = scheda.Giorno
        Indice(record).Mese = scheda.Mese
        Indice(record).Anno = scheda.Anno
        Indice(record).Telef = scheda.Telef
        Indice(record).Indirizzo = scheda.Indirizzo
        Indice(record).Cap = scheda.Cap
        Indice(record).Citta = scheda.Citta
        Indice(record).Prov = scheda.Prov

    NEXT record

END SUB

'*
'* ModScheda - Modifica i campi di un record specificato.
'*
'* Parametri:    Scheda - il record da modificare
'*
'* Restituisce:  Dato che Scheda viene passata per riferimento, in effetti
'                viene restituita la versione modificata del record.
'*      
'*
SUB ModScheda (scheda AS PERSONA)

    ' Imposta FlagSucc e continua a modificare i campi.
    ' FlagSucc viene azzerato quando l'utente preme INVIO.

    FlagSucc = VERO
    DO

        RESTORE PosizCampi

        ' Inizia dal primo campo.
        READ Riga, Colonna, Lungezza
        LOCATE Riga, Colonna
        ' Modifica i campi stringa direttamente.
        scheda.Nome = ModStringa(RTRIM$(scheda.Nome), Lungezza, FlagSucc)
        ' Il risultato della modifica determina se continuare.
        IF FlagSucc = FALSO THEN EXIT SUB

        READ Riga, Colonna, Lungezza
        LOCATE Riga, Colonna
        scheda.Note = ModStringa(RTRIM$(scheda.Note), Lungezza, FlagSucc)
        IF FlagSucc = FALSO THEN EXIT SUB

        READ Riga, Colonna, Lungezza
        LOCATE Riga, Colonna
        ' Converte i campi numerici in stringhe per la modifica.
        Tmp$ = LTRIM$(STR$(scheda.Giorno))
        Tmp$ = ModStringa(Tmp$, Lungezza, FlagSucc)
        ' Riconverte il risultato in numero.
        scheda.Giorno = VAL(Tmp$)
        LOCATE Riga, Colonna
        PRINT USING "##_/"; scheda.Giorno;
        IF FlagSucc = FALSO THEN EXIT SUB

        READ Riga, Colonna, Lungezza
        LOCATE Riga, Colonna
        Tmp$ = LTRIM$(STR$(scheda.Mese))
        Tmp$ = ModStringa(Tmp$, Lungezza, FlagSucc)
        scheda.Mese = VAL(Tmp$)
        LOCATE Riga, Colonna
        PRINT USING "##_/"; scheda.Mese;
        IF FlagSucc = FALSO THEN EXIT SUB

        READ Riga, Colonna, Lungezza
        LOCATE Riga, Colonna
        Tmp$ = LTRIM$(STR$(scheda.Anno))
        Tmp$ = ModStringa(Tmp$, Lungezza, FlagSucc)
        scheda.Anno = VAL(Tmp$)
        LOCATE Riga, Colonna
        PRINT USING "##"; scheda.Anno;
        IF FlagSucc = FALSO THEN EXIT SUB

        READ Riga, Colonna, Lungezza
        LOCATE Riga, Colonna
        scheda.Telef = ModStringa(RTRIM$(scheda.Telef), Lungezza, FlagSucc)
        RSET scheda.Telef = scheda.Telef
        IF FlagSucc = FALSO THEN EXIT SUB

        READ Riga, Colonna, Lungezza
        LOCATE Riga, Colonna
        scheda.Indirizzo = ModStringa(RTRIM$(scheda.Indirizzo), Lungezza, FlagSucc)
        IF FlagSucc = FALSO THEN EXIT SUB

        READ Riga, Colonna, Lungezza
        LOCATE Riga, Colonna
        scheda.Cap = ModStringa(RTRIM$(scheda.Cap), Lungezza, FlagSucc)
        IF FlagSucc = FALSO THEN EXIT SUB

        READ Riga, Colonna, Lungezza
        LOCATE Riga, Colonna
        scheda.Citta = ModStringa(RTRIM$(scheda.Citta), Lungezza, FlagSucc)
        IF FlagSucc = FALSO THEN EXIT SUB

        READ Riga, Colonna, Lungezza
        LOCATE Riga, Colonna
        scheda.Prov = ModStringa(RTRIM$(scheda.Prov), Lungezza, FlagSucc)
        LOCATE Riga, Colonna + 2
        PRINT ")";
        IF FlagSucc = FALSO THEN EXIT SUB

    LOOP

END SUB

'*
'* ModStringa$ - Modifica un a stringa specificata. Questa funzione
'* implementa una parte delle funzioni di modifica dell'ambiente QuickBASIC
'* e Windows. Sono riconosciuti tasti di modifica in uso corrente, inclusi
'* i tasti di direzione, CANC, BKSP, INS (per le modalit… inserisci o
'* sovrascrivi), ESC, e INVIO. TAB Š riconosciuto solo se Š attivato il
'* flag CampoSucc. CTRL-key equivalents are recognized for most keys.
'* A null string can be specified if no initial value is desired.
'* You could modify this function to handle additional QB edit
'* commands, such as CTRL+A (word back) and CTRL+F (word forward).
'*
'* Parametri: StringaIn$ - La stringa di input (anche nulla)
'*            Lungezza - Lunghezza massima della stringa (la funzione emette
'*               un bip e rifiuta ulteriore input se si tenta di superarla)
'*            CampoSucc - Flag indicante all'entrata se accettare il tasto
'*              TAB; all'uscita, indica se l'utente ha premuto TAB (VERO)
'*              o INVIO (FALSO)
'*
'* Input:     Tastiera
'* Ouput:     Schermo - Tasti premuti non di controllo vengono rivisualizzati.
'*            Altoparlante - emette un bip se il tasto non Š valido o se
'*              la stringa Š troppo lunga
'*
'* Restituisce: La stringa modificata
'*
FUNCTION ModStringa$ (StringaIn$, Lungezza, CampoSucc)
STATIC Inser

    ' Inizializza le variabili e cancella tutta la lunghezza del campo.
    Lav$ = StringaIn$
    Riga = CSRLIN: Colonna = POS(0)
    PrimaVolta = VERO
    P = LEN(Lav$): PMass = P
    PRINT SPACE$(Lungezza);

    ' Dato che Inser Š STATIC, il suo valore si conserva da una chiamata
    ' all'altra. Inser Š 0 (FALSO) alla prima chiamata della funzione.
    IF Inser THEN
        LOCATE Riga, Colonna, CURSOREACC, 6, 7
    ELSE
        LOCATE Riga, Colonna, CURSOREACC, 0, 7
    END IF

    ' Video inverso all'entrata.
    COLOR SFONDO, NORMALE
    PRINT Lav$;

    ' Elabora i tasti finch‚ non viene premuto o TAB o INVIO.
    DO

        ' Legge un tasto -- o un codice ASCII a un byte o un
        ' codice esteso a due byte.
        DO
            Scelta$ = INKEY$
        LOOP WHILE Scelta$ = ""

        ' Riduce i due byte dei codici estesi a un byte significativo.
        IF LEN(Scelta$) = 2 THEN
            Scelta$ = RIGHT$(Scelta$, 1)
            SELECT CASE Scelta$

                ' Traduce i codici estesi in codici di controllo ASCII.
                CASE CHR$(SINISTRA)
                    Scelta$ = CHR$(CTRLS)
                CASE CHR$(DESTRA)
                    Scelta$ = CHR$(CTRLD)
                CASE CHR$(INS)
                    Scelta$ = CHR$(CTRLV)
                CASE CHR$(CANC)
                    Scelta$ = CHR$(CTRLG)

                ' Gestisce i tasti HOME e FINE, dato che mancano di codice
                ' di controllo. Invia NULLO come segnale di ignorarlo.
                CASE CHR$(HOME)
                    P = 0
                    Scelta$ = CHR$(NULLO)
                CASE CHR$(FINE)
                    P = PMass
                    Scelta$ = CHR$(NULLO)

                ' Rende non validi gli altri tasti.
                CASE ELSE
                    Scelta$ = CHR$(1)
            END SELECT
        END IF

        ' Gestisce i codici ASCII a un byte.
        SELECT CASE ASC(Scelta$)

            ' Se Š nullo, lo ignora.
            CASE NULLO

            ' Accetta il campo (e la scheda se non Š attivo CampoSucc).
            CASE INVIO
                CampoSucc = FALSO
                EXIT DO

            ' Accetta il campo se CampoSucc Š attivo. Se CampoSucc
            ' non Š attivo, TAB non Š valido.
            CASE TASTOTAB
                IF CampoSucc THEN
                    EXIT DO
                ELSE
                    BEEP
                END IF

            ' Ripristina la stringa originaria.
            CASE ESC
                Lav$ = StringaIn$
                LOCATE Riga, Colonna, CURSORESPEN
                PRINT SPACE$(PMass)
                EXIT DO

            ' CTRL+S e la freccia SINISTRA spostano il cursore a sinistra.
            CASE CTRLS
                IF P > 0 THEN
                    P = P - 1
                    LOCATE , P + Colonna
                ELSE
                    BEEP
                END IF

            ' CTRL+D e la freccia DESTRA spostano il cursore a destra.
            CASE CTRLD
                IF P < PMass THEN
                    P = P + 1
                    LOCATE , P + Colonna
                ELSE
                    BEEP
                END IF

            ' CTRL+G e CANC cancellano il carattere sotto il cursore.
            CASE CTRLG
                IF P < PMass THEN
                    Lav$ = LEFT$(Lav$, P) + RIGHT$(Lav$, PMass - P - 1)
                    PMass = PMass - 1
                ELSE
                    BEEP
                END IF

            ' CTRL+H e BKSP cancellano il carattere a sinistra del cursore.
            CASE CTRLH, 127
                IF P > 0 THEN
                    Lav$ = LEFT$(Lav$, P - 1) + RIGHT$(Lav$, PMass - P)
                    P = P - 1
                    PMass = PMass - 1
                END IF

            ' CTRL+V e INS alternano tra le modalit… inserisci e sovrascrivi.
            CASE CTRLV
                Inser = NOT Inser
                IF Inser THEN
                    LOCATE , , , 6, 7
                ELSE
                    LOCATE , , , 0, 7
                END IF

            ' Rivisualizza sullo schermo i caratteri ASCII.
            CASE IS >= SPAZIO

                ' Cancella il campo se Š il primo tasto premuto, e
                ' ricomincia dall'inizio.
                IF PrimaVolta THEN
                    LOCATE , Colonna
                    COLOR NORMALE, SFONDO
                    PRINT SPACE$(PMass);
                    LOCATE , Colonna
                    P = 0: PMass = P
                    Lav$ = ""
                END IF

                ' Se Š in modalit… inserisci e il cursore non Š oltre la
                ' fine, inserisce il carattere.
                IF Inser THEN
                    IF PMass < Lungezza THEN
                        Lav$ = LEFT$(Lav$, P) + Scelta$ + RIGHT$(Lav$, PMass - P)
                        PMass = PMass + 1
                        P = P + 1
                    ELSE
                        BEEP
                    END IF

                ELSE
                    ' Se Š in modalit… sovrascrivi e il cursore Š alla
                    ' fine (ma non oltre), inserisce il carattere.
                    IF P = PMass THEN
                        IF PMass < Lungezza THEN
                            Lav$ = Lav$ + Scelta$
                            PMass = PMass + 1
                            P = P + 1
                        ELSE
                            BEEP
                        END IF

                    ' Se Š in modalit… sovrascrivi e prima della fine,
                    ' sovrascrive il carattere.
                    ELSE
                        MID$(Lav$, P + 1, 1) = Scelta$
                        P = P + 1
                    END IF
                END IF

            ' Considera non validi gli altri tasti.
            CASE ELSE
                BEEP
        END SELECT
       
        ' Stampa la stringa modificata.
        COLOR NORMALE, SFONDO
        LOCATE , Colonna, CURSORESPEN
        PRINT Lav$ + " ";
        LOCATE , Colonna + P, CURSOREACC
        PrimaVolta = FALSO

    LOOP

    ' Stampa la versione finale della stringa e ne assegna il valore
    ' alla funzione.
    COLOR NORMALE, SFONDO
    LOCATE Riga, Colonna, CURSORESPEN
    PRINT Lav$;
    ModStringa$ = Lav$
    LOCATE Riga, Colonna

END FUNCTION

'*
'* MostraGuidaMod - Legge i colori e le stringhe per la guida alla
'* modalit… modifica e la visualizza sullo schermo.
'*
'* Parametri:  Nessuno
'*
'* Output:     Schermo
'*
SUB MostraGuidaMod

    ' Cancella la guida precedente e visualizza quella nuova.
    CancGuida
    RESTORE GuidaMod
    FOR Riga = GUIDALT TO GUIDBAS
        READ Clr
        IF Clr = COLNORMALE THEN
            COLOR NORMALE, SFONDO
        ELSE
            COLOR EVIDENZ, SFONDO
        END IF
        LOCATE Riga, GUIDSIN
        READ Tmp$
        PRINT Tmp$;
    NEXT

    ' Ripristina i colori normali.
    COLOR NORMALE, SFONDO

END SUB

'*
'* MostraGuidaVis - Legge i colori e le stringhe per la guida in
'* visualizzazione e la visualizza sullo schermo.
'*
'* Parametri:  Nessuno
'*
'* Output:     Screen
'*
SUB MostraGuidaVis

    ' Cancella la guida precedente e visualizza quella nuova.
    CancGuida
    RESTORE GuidaVis
    FOR Riga = GUIDALT TO GUIDBAS
        READ Clr
        IF Clr = COLNORMALE THEN
            COLOR NORMALE, SFONDO
        ELSE
            COLOR EVIDENZ, SFONDO
        END IF
        LOCATE Riga, GUIDSIN
        READ Tmp$
        PRINT Tmp$;
    NEXT

    ' Ripristina i colori normali e mostra la riga di comando.
    COLOR NORMALE, SFONDO
    MostraRigaCom

END SUB

'*
'* MostraRigaCom - Dispone sullo schermo la riga di comando con i caratteri
'* evidenziati. Modificare questa SUB se si aggiungono altri comandi.
'*
'* Parametri:  Nessuno
'*
'* Output:     Schermo
'*
SUB MostraRigaCom

    LOCATE ULTIMARIGA, 1
    COLOR EVIDENZ, SFONDO: PRINT " M";
    COLOR NORMALE, SFONDO: PRINT "odifica   ";
    COLOR EVIDENZ, SFONDO: PRINT "A";
    COLOR NORMALE, SFONDO: PRINT "ggiungi   ";
    COLOR EVIDENZ, SFONDO: PRINT "R";
    COLOR NORMALE, SFONDO: PRINT "icopia   ";
    COLOR EVIDENZ, SFONDO: PRINT "C";
    COLOR NORMALE, SFONDO: PRINT "ancella   ";
    COLOR EVIDENZ, SFONDO: PRINT "T";
    COLOR NORMALE, SFONDO: PRINT "rova   ";
    COLOR EVIDENZ, SFONDO: PRINT "O";
    COLOR NORMALE, SFONDO: PRINT "rdina   ";
    COLOR EVIDENZ, SFONDO: PRINT "S";
    COLOR NORMALE, SFONDO: PRINT "tampa   ";
    COLOR EVIDENZ, SFONDO: PRINT "U";
    COLOR NORMALE, SFONDO: PRINT "scita ";

END SUB

'*
'* MostraSchedaSup - Visualizza i campi della scheda superiore.
'*
'* Parametri:  SchedaLav - il record da da disporre come scheda superiore
'*
'* Output:     Schermo
'*
SUB MostraSchedaSup (SchedaLav AS PERSONA)

    ' Visualizza ciascun campo della scheda corrente.
    RESTORE PosizCampi
    READ Riga, Colonna, Lungezza
    LOCATE Riga, Colonna
    PRINT SPACE$(Lungezza);
    LOCATE Riga, Colonna
    PRINT SchedaLav.Nome;

    READ Riga, Colonna, Lungezza
    LOCATE Riga, Colonna
    PRINT SPACE$(Lungezza);
    LOCATE Riga, Colonna
    PRINT SchedaLav.Note;

    READ Riga, Colonna, Lungezza
    LOCATE Riga, Colonna
    PRINT SPACE$(Lungezza);
    LOCATE Riga, Colonna
    PRINT USING "##_/"; SchedaLav.Giorno; SchedaLav.Mese;
    PRINT USING "##"; SchedaLav.Anno;
    READ Riga, Colonna, Lungezza, Riga, Colonna, Lungezza

    READ Riga, Colonna, Lungezza
    LOCATE Riga, Colonna
    PRINT SPACE$(Lungezza);
    LOCATE Riga, Colonna
    PRINT SchedaLav.Telef;

    READ Riga, Colonna, Lungezza
    LOCATE Riga, Colonna
    PRINT SPACE$(Lungezza);
    LOCATE Riga, Colonna
    PRINT SchedaLav.Indirizzo;

    READ Riga, Colonna, Lungezza
    LOCATE Riga, Colonna
    PRINT SPACE$(Lungezza)
    LOCATE Riga, Colonna
    PRINT SchedaLav.Cap;

    READ Riga, Colonna, Lungezza
    LOCATE Riga, Colonna
    PRINT SPACE$(Lungezza);
    LOCATE Riga, Colonna
    PRINT SchedaLav.Citta;

    READ Riga, Colonna, Lungezza
    LOCATE Riga, Colonna
    PRINT SPACE$(Lungezza);
    LOCATE Riga, Colonna
    PRINT SchedaLav.Prov;

END SUB

'*
'* MostraSchede - I campi della scheda superiore e il primo campo
'* delle altre schede visibili.
'*
'* Parametri:  SchedaSup - numero della scheda superiore
'*             UltimaScheda - numero dell'ultima scheda
'*
'* Output:     Schermo
'*
SUB MostraSchede (SchedaSup, UltimaScheda)

    ' Mostra i campi della scheda superiore.
    CALL MostraSchedaSup(Indice(SchedaSup))

    ' Mostra il campo Nome delle altre schede visibili.
    scheda = SchedaSup
    RESTORE PosizCampi
    READ Riga, Colonna, Lungezza
    FOR Cont = 2 TO SCHEDEPERSCHERMO

        ' Mostra la posizione e il numero della successiva scheda.
        Riga = Riga - 2: Colonna = Colonna + 3
        scheda = scheda + 1
        IF scheda > UltimaScheda THEN scheda = 1

        LOCATE Riga, Colonna
        PRINT SPACE$(Lungezza)

        LOCATE Riga, Colonna
        PRINT Indice(scheda).Nome

    NEXT Cont

END SUB

'*
'* OrdinaIndice - Ordina tutti i record in memoria secondo un campo
'* specificato. Dopo l'ordinamento, il primo record in memoria diventa
'* la scheda superiore. Notare che l'ordine cambia solo in memoria, non
'* nel file. L'ordine nel file Š rappresentato dal campo NumScheda di
'* ciascun record. Questa SUB usa l'algoritmo di ordinamento Shell.
'*
'* Parametri:  CampoOrd - numero (a partire da 0) del campo su cui ordinare
'*             UltimaScheda - numero dell'ultima scheda
'*
SUB OrdinaIndice (CampoOrd, UltimaScheda)

    ' Imposta lo scarto per il confronto alla met… del numero dei record.
    Offset = UltimaScheda \ 2

    ' Cicla finch‚ lo scarto (offset) non diventa zero.
    DO WHILE Offset > 0

        Limite = UltimaScheda - Offset

        DO

            ' Presume non vi siano stati scambi con questo scarto.
            Scambio = FALSO

            ' Confronta gli elementi del campo specificato e li scambia se
            ' non sono in ordine.
            FOR I = 1 TO Limite
                SELECT CASE CampoOrd
                    CASE NPERSONA
                        IF Indice(I).Nome > Indice(I + Offset).Nome THEN
                            SWAP Indice(I), Indice(I + Offset)
                            Scambio = I
                        END IF
                    CASE NNOTE
                        IF Indice(I).Note > Indice(I + Offset).Note THEN
                            SWAP Indice(I), Indice(I + Offset)
                            Scambio = I
                        END IF
                    CASE NGIORNO
                        IF Indice(I).Giorno > Indice(I + Offset).Giorno THEN
                            SWAP Indice(I), Indice(I + Offset)
                            Scambio = I
                        END IF
                    CASE NMESE
                        IF Indice(I).Mese > Indice(I + Offset).Mese THEN
                            SWAP Indice(I), Indice(I + Offset)
                            Scambio = I
                        END IF
                    CASE NANNO
                        IF Indice(I).Anno > Indice(I + Offset).Anno THEN
                            SWAP Indice(I), Indice(I + Offset)
                            Scambio = I
                        END IF
                    CASE NTELEF
                        IF Indice(I).Telef > Indice(I + Offset).Telef THEN
                            SWAP Indice(I), Indice(I + Offset)
                            Scambio = I
                        END IF
                    CASE NINDIR
                        IF Indice(I).Indirizzo > Indice(I + Offset).Indirizzo THEN
                            SWAP Indice(I), Indice(I + Offset)
                            Scambio = I
                        END IF
                    CASE NCAP
                        IF Indice(I).Cap > Indice(I + Offset).Cap THEN
                            SWAP Indice(I), Indice(I + Offset)
                            Scambio = I
                        END IF
                    CASE NCITTA
                        IF Indice(I).Citta > Indice(I + Offset).Citta THEN
                            SWAP Indice(I), Indice(I + Offset)
                            Scambio = I
                        END IF
                    CASE NPROV
                        IF Indice(I).Prov > Indice(I + Offset).Prov THEN
                            SWAP Indice(I), Indice(I + Offset)
                            Scambio = I
                        END IF
                END SELECT

            NEXT I

            ' Al successivo passaggio, ordina solo fino al punto del
            ' precedente scambio.
            Limite = Scambio

        LOOP WHILE Scambio

        ' Nessono scambio con lo scarto precedente: dimezza lo scarto.
        Offset = Offset \ 2
    LOOP

END SUB

'*
'* Prompt$ - Stampa un prompt sullo schermo alla posizione specificata e
'* (facoltativamente) legge le risposta dell'utente. La funzione esegue
'* una delle tre azioni a seconda del valore del parametro Lunghezza.
'*
'* Parametri:  Msg$ - messaggio o prompt ("" significa nessun messaggio)
'*             Riga
'*             Colonna
'*             Lungezza - una delle seguenti:
'*               <1 - Non aspettare risposta
'*                1 - Legge un carattere come risposta
'*               >1 - Legge una stringa della lunghezza indicata
'*                    (o meno) come risposta
'*
'* Input:      Tastiera
'* Output:     Schermo - Rivisualizza i caratteri non di controllo
'*
'* Restituisce:  La stringa digitata dall'utente
'*
FUNCTION Prompt$ (Msg$, Riga, Colonna, Lungezza)

    LOCATE Riga, Colonna
    PRINT Msg$;
    
    SELECT CASE Lungezza
        CASE IS <= 0    ' Non restituisce
            Prompt$ = ""
        CASE 1          ' Restituisce un carattere
            LOCATE , , CURSOREACC
            Prompt$ = INPUT$(1)
        CASE ELSE       ' Restituisce una stringa
            Prompt$ = ModStringa("", Lungezza, FALSO)
    END SELECT

END FUNCTION

'*
'* SelezCampo - Permette all'utente di selezionare un campo con il tasto
'* TAB. TAB sposta al campo successivo. INVIO seleziona il campo corrente.
'*
'* Parametri:    Nessuno
'*
'* Restituisce:  Il numero (a partire da zero) del campo selezionato
'*
FUNCTION SelezCampo%

    ' Get first cursor position and set first NumCampo.
    RESTORE PosizCampi
    READ Riga, Colonna, Lungezza
    NumCampo = 0

    ' Sposta il cursore da un campo al successivo, tornando a capo.
    DO

        ' Posiziona il cursore sul campo corrente.
        LOCATE Riga, Colonna, CURSOREACC

        ' Legge un tasto TAB o INVIO.
        DO
            Tasto = ASC(INPUT$(1))
        LOOP UNTIL (Tasto = INVIO) OR (Tasto = TASTOTAB)

        ' Se Š stato premuto INVIO, spegne il cursore e restituisce il campo.
        IF Tasto = INVIO THEN
            
            LOCATE , , CURSORESPEN
            SelezCampo% = NumCampo
            EXIT FUNCTION

        ' Altrimenti era un TAB, e avanza al campo successivo.
        ELSE

            NumCampo = NumCampo + 1
            READ Riga, Colonna, Lungezza
            IF Riga = 0 THEN
                RESTORE PosizCampi
                READ Riga, Colonna, Lungezza
                NumCampo = 0
            END IF

        END IF

    LOOP

END FUNCTION

'*
'* StampaIndir - Stampa il nome, l'indirizzo, il CAP, la citt… e il
'* capoluogo di provincia da una scheda. Questa SUB si potrebbe facilmente
'* modificare per esempio per far stampare un indirizzo di ritorno o per
'* allineare l'indirizzo su una busta.
'*
'* Parametri:  Scheda - l'insieme dei dati su una persona
'*
'* Output:     Stampante
'*
SUB StampaIndir (scheda AS PERSONA)

    LPRINT scheda.Nome
    LPRINT scheda.Indirizzo
    LPRINT scheda.Cap; scheda.Citta; " ("; scheda.Prov; ")"
    LPRINT

END SUB

'*
'* TastoAscii - Gestisce i tasti ASCII. Si possono aggiungere comandi
'* assegnandone i tasti e le azioni qui, e aggiungendoli alla riga di
'* comando visualizzata da MostraRigaCom. Per esempio, si potrebbe
'* aggiungere F (Carica File) per sollecitare dall'utente un nuovo database.
'*
'* Parametri:  SceltaUten$ - il tasto premuto dall'utente
'*             SchedaSup - il numero del record corrente
'*             UltimaScheda - il numero dei record
'*
SUB TastoAscii (SceltaUten$, SchedaSup%, UltimaScheda%)
DIM SchedaLav AS PERSONA

    SELECT CASE SceltaUten$
        ' Modifica la scheda corrente.
        CASE "m"
            CALL MostraGuidaMod
            Tmp$ = Prompt$("Modifica della scheda...", ULTIMARIGA, 1, 0)
            CALL ModScheda(Indice(SchedaSup))
            PUT #1, Indice(SchedaSup).NumScheda, Indice(SchedaSup)
            LOCATE , , CURSORESPEN
            CALL MostraGuidaVis

        ' Aggiunge e modifica una scheda vuota o duplice.
        CASE "a", "r"
            IF SceltaUten$ = "r" THEN
                SchedaLav = Indice(SchedaSup)   ' Ricopia la scheda superiore.
            ELSE
                SchedaLav.NumScheda = 0         ' Inizializza la nuova scheda.
                SchedaLav.Nome = ""
                SchedaLav.Note = ""
                SchedaLav.Giorno = 0
                SchedaLav.Mese = 0
                SchedaLav.Anno = 0
                SchedaLav.Telef = ""
                SchedaLav.Indirizzo = ""
                SchedaLav.Cap = ""
                SchedaLav.Citta = ""
                SchedaLav.Prov = ""
            END IF
            SchedaSup = UltimaScheda + 1
            UltimaScheda = SchedaSup
            Indice(SchedaSup) = SchedaLav
            Indice(SchedaSup).NumScheda = SchedaSup
            CALL MostraSchede(SchedaSup, UltimaScheda)
            CALL MostraGuidaMod
            Tmp$ = Prompt$("Modifica della scheda...", ULTIMARIGA, 1, 0)
            CALL ModScheda(Indice(SchedaSup))
            PUT #1, Indice(SchedaSup).NumScheda, Indice(SchedaSup)
            LOCATE , , CURSORESPEN
            CALL MostraGuidaVis

        ' Sposta la scheda cancellata alla fine e riposiziona l'ultima scheda.
        CASE "c"
            FOR scheda = SchedaSup TO UltimaScheda - 1
                SWAP Indice(scheda + 1), Indice(scheda)
            NEXT scheda
            UltimaScheda = UltimaScheda - 1

        ' Trova la scheda specificata.
        CASE "t"
            CALL MostraGuidaMod
            Tmp$ = "Digitare i campi per la ricerca (i campi vuoti vengono ignorati)"
            Tmp$ = Prompt$(Tmp$, ULTIMARIGA, 1, 0)
            scheda = TrovaScheda(SchedaSup, UltimaScheda)
            IF scheda THEN
                SchedaSup = scheda
            ELSE
                BEEP
                CALL CancGuida
                Tmp$ = "Scheda non trovata. Premere un tasto..."
                Tmp$ = Prompt$(Tmp$, ULTIMARIGA, 1, 1)
            END IF
            LOCATE , , CURSORESPEN
            CALL MostraGuidaVis

        ' Ordina le schede secondo il campo specificato.
        CASE "o"
            CALL CancGuida
            Tmp$ = "TABulare al campo desiderato e premere INVIO"
            Tmp$ = Prompt$(Tmp$, ULTIMARIGA, 1, 0)
            CALL OrdinaIndice(SelezCampo, UltimaScheda)
            SchedaSup = 1
            CALL MostraGuidaVis

        ' Manda l'indirizzo della scheda superiore alla stampante.
        CASE "s"
            CALL StampaIndir(Indice(SchedaSup))

        ' Termina il programma.
        CASE "u", CHR$(ESC)
            CALL Termina(UltimaScheda)
            LOCATE , , CURSOREACC
            CLS
            END
        CASE ELSE
            BEEP
    END SELECT

END SUB

'*
'* Termina - Trascrive tutti i record dalla memoria al file. I record
'* cancellati (dopo l'ultima scheda) non vengono trascritti. I record
'* validi vengono trascritti su un file temporaneo; poi il vecchio file
'* viene cancellato e al nuovo file viene dato il vecchio nome.
'*
'* Parametri:  UltimaScheda - il numero dei record validi
'*
'* Output:     I record validi su "QSCHEDE.DAT" attraverso FILETMP$
'*
SUB Termina (UltimaScheda)

    ' Trascrive i record al file temporaneo nell'ordine corrente.
    OPEN FILETMP$ FOR RANDOM AS #2 LEN = LEN(Indice(1))
    FOR scheda = 1 TO UltimaScheda
        PUT #2, scheda, Indice(scheda)
    NEXT

    ' Cancella il vecchio file e lo sostituisce con la versione nuova.
    CLOSE
    KILL "QSCHEDE.DAT"
    NAME FILETMP$ AS "QSCHEDE.DAT"

END SUB

'*
'* TrovaScheda - Trova il record specificato. L'utente specifica i campi
'* da ricercare. La ricerca inizia alla scheda successiva a quella corrente
'* e procede finch‚ non giunge al record specificato o non ritorna alla
'* scheda corrente. I record specificati vengono conservati tra chiamate
'* per facilitare le ricerche ripetute. Si potrebbe potenziare questa SUB
'* perch‚ risponda a corrispondenze parziali nei campi a stringa.
'*
'* Parametri:  SchedaSup - il numero della scheda superiore
'*             UltimaScheda - il numero dell'ultima scheda
'*
'* Parametri:  Nessuno
'*
'* Restituisce:  Il numero (a partire da zero) del campo selezionato
'*
FUNCTION TrovaScheda% (SchedaSup%, UltimaScheda%)

STATIC SchedaTmp AS PERSONA, NonPrima

    ' Imposta la stringa nulla nei campi alla prima chiamata. (Le variabili
    ' SchedaTmp e NonPrima, dichiarate STATIC, conservano il loro valore
    ' tra una chiamata e l'altra.)
    IF NonPrima = FALSO THEN
        SchedaTmp.Nome = ""
        SchedaTmp.Note = ""
        SchedaTmp.Telef = ""
        SchedaTmp.Indirizzo = ""
        SchedaTmp.Cap = ""
        SchedaTmp.Citta = ""
        SchedaTmp.Prov = ""
        NonPrima = VERO
    END IF

    ' Mostra la scheda superiore e con ModSchedaFunction specifica i campi
    ' per la ricerca.
    CALL MostraSchedaSup(SchedaTmp)
    CALL ModScheda(SchedaTmp)

    ' La ricerca continua finch‚ non si trova una corrispondenza o
    ' non sono esaurite le schede.
    scheda = SchedaSup
    DO
        scheda = scheda + 1
        IF scheda > UltimaScheda THEN scheda = 1
        trovata = 0

        ' Prova se corrisponde il nome.
        SELECT CASE RTRIM$(UCASE$(SchedaTmp.Nome))
            CASE "", RTRIM$(UCASE$(Indice(scheda).Nome))
                trovata = trovata + 1
            CASE ELSE
        END SELECT
                                   
        ' Prova se corrisponde il testo delle note.
        SELECT CASE RTRIM$(UCASE$(SchedaTmp.Note))
            CASE "", RTRIM$(UCASE$(Indice(scheda).Note))
                trovata = trovata + 1
            CASE ELSE
        END SELECT
                                   
        ' Prova se corrisponde il giorno.
        SELECT CASE SchedaTmp.Giorno
            CASE 0, Indice(scheda).Giorno
                trovata = trovata + 1
            CASE ELSE
        END SELECT
                                
        ' Prova se corrisponde il mese.
        SELECT CASE SchedaTmp.Mese
            CASE 0, Indice(scheda).Mese
                trovata = trovata + 1
            CASE ELSE
        END SELECT
                                 
        ' Prova se corrisponde l'anno.
        SELECT CASE SchedaTmp.Anno
            CASE 0, Indice(scheda).Anno
                trovata = trovata + 1
            CASE ELSE
        END SELECT
                                 
        ' Prova se corrisponde il numero di telefono.
        SELECT CASE RTRIM$(UCASE$(SchedaTmp.Telef))
            CASE "", RTRIM$(UCASE$(Indice(scheda).Telef))
                trovata = trovata + 1
            CASE ELSE
        END SELECT
                                 
        ' Prova se corrisponde l'indirizzo
        SELECT CASE RTRIM$(UCASE$(SchedaTmp.Indirizzo))
            CASE "", RTRIM$(UCASE$(Indice(scheda).Indirizzo))
                trovata = trovata + 1
            CASE ELSE
        END SELECT
                                  
        ' Prova se corrisponde il codice di avviamento postale.
        SELECT CASE SchedaTmp.Cap
            CASE "", RTRIM$(UCASE$(Indice(scheda).Cap))
                trovata = trovata + 1
            CASE ELSE
        END SELECT

        ' Prova se corrisponde la citt….
        SELECT CASE RTRIM$(UCASE$(SchedaTmp.Citta))
            CASE "", RTRIM$(UCASE$(Indice(scheda).Citta))
                trovata = trovata + 1
            CASE ELSE
        END SELECT
                                  
        ' Prova se corrisponde il capoluogo.
        SELECT CASE RTRIM$(UCASE$(SchedaTmp.Prov))
            CASE "", RTRIM$(UCASE$(Indice(scheda).Prov))
                trovata = trovata + 1
            CASE ELSE
        END SELECT
                                  
        ' Se trova una corrispondenza, imposta il valore della funzione e
        ' termina, se no prova la scheda successiva.
        IF trovata = NCAMPI - 1 THEN
            TrovaScheda% = scheda
            EXIT FUNCTION
        END IF

    LOOP UNTIL scheda = SchedaSup

    ' Restituisce FALSO se non trova una corrispondenza.
    TrovaScheda% = FALSO

END FUNCTION

