DEFINT A-Z

' Definisce le costanti simboliche usate globalmente nel programma:
CONST FALSO = 0, VERO = NOT FALSO

' Definisce la struttura di record per i record del file
' ad accesso casuale:
TYPE UnitaInMag
   NumPezzo  AS STRING * 6
   Descrizione AS STRING * 20
   PrezzoUnitario   AS SINGLE
   Quantita    AS INTEGER
END TYPE

' Definisce una struttura di record per ciascun elemento dell'indice:
TYPE TipoIndice
   NumRecord AS INTEGER
   NumPezzo   AS STRING * 6
END TYPE

' Dichiara le procedure da chiamare:
DECLARE FUNCTION Filtro$ (Prompt$)
DECLARE FUNCTION TrovaRecord% (NumPezzo$, VarRecord AS UnitaInMag)

DECLARE SUB AggRecord (VarRecord AS UnitaInMag)
DECLARE SUB LeggiRecord (VarRecord AS UnitaInMag)
DECLARE SUB StampaRecord (VarRecord AS UnitaInMag)
DECLARE SUB OrdinaIndice ()
DECLARE SUB VisNumPezzo ()

' Definisce un buffer (usando il tipo UnitaInMag) e
' definisce e dimensiona la matrice dell'indice:
DIM RecordMag AS UnitaInMag, Indice(1 TO 100) AS TipoIndice

' Apre il file ad accesso casuale:
OPEN "MAGAZ.DAT" FOR RANDOM AS #1 LEN = LEN(RecordMag)

' Calcola il numero dei record nel file:
NumDeiRecord = LOF(1) \ LEN(RecordMag)

' Se ci sono record, li legge e crea l'indice:
IF NumDeiRecord <> 0 THEN
   FOR NumRecord = 1 TO NumDeiRecord

      ' Legge i dati dai nuovi record nel file:
      GET #1, NumRecord, RecordMag

      ' Immette il numero del pezzo e il numero del record nell'indice:
      Indice(NumRecord).NumRecord = NumRecord
      Indice(NumRecord).NumPezzo = RecordMag.NumPezzo
   NEXT

   OrdinaIndice            ' Ordina l'indice secondo il numero del pezzo.
END IF

DO                      ' Ciclo del menu principale.
   CLS
   PRINT "(A)ggiungi dei record."
   PRINT "(V)isualizza dei record."
   PRINT "(E)sci dal programma."
   PRINT
   LOCATE , , 1
   PRINT "Digitare l'azione desiderata (A, V, o E) : ";

   ' Cicla finchÇ l'utente non digita  A, V, o E:
   DO
      Scelta$ = UCASE$(INPUT$(1))
   LOOP WHILE INSTR("AVE", Scelta$) = 0

   ' Dirama secondo la scelta fatta:
   SELECT CASE Scelta$
      CASE "A"
         AggRecord RecordMag
      CASE "V"
         IF NumDeiRecord = 0 THEN
            PRINT : PRINT "Nessun record nel file. ";
            PRINT "Premere un tasto per continuare.";
            Pausa$ = INPUT$(1)
         ELSE
            LeggiRecord RecordMag
         END IF
      CASE "E"          ' Termina il programma
   END SELECT
LOOP UNTIL Scelta$ = "E"

CLOSE #1                ' Tutto fatto, chiude il file ed esce.
END

'
' ======================== AggRecord =====================
'  Aggiunge record al file dai dati digitati.
' ========================================================
'
SUB AggRecord (VarRecord AS UnitaInMag) STATIC
   SHARED Indice() AS TipoIndice, NumDeiRecord
   DO
      CLS
      INPUT "Numero del pezzo: ", VarRecord.NumPezzo
      INPUT "Descrizione: ", VarRecord.Descrizione
      VarRecord.PrezzoUnitario = VAL(Filtro$("Prezzo unitario : "))
      VarRecord.Quantita = VAL(Filtro$("QuantitÖ   : "))

      NumDeiRecord = NumDeiRecord + 1

      PUT #1, NumDeiRecord, VarRecord

      Indice(NumDeiRecord).NumRecord = NumDeiRecord
      Indice(NumDeiRecord).NumPezzo = VarRecord.NumPezzo
      PRINT : PRINT "Aggiungere un altro record? (Sç/No)";
      OK$ = UCASE$(INPUT$(1))
   LOOP WHILE OK$ = "S"

   OrdinaIndice            ' Riordina l'indice.
END SUB

'
' ========================= Filtro ===========================
'       Elimina tutti i caratteri non numerici da una stringa
'       e restituisce la stringa filtrata.
' ============================================================
'
FUNCTION Filtro$ (Prompt$) STATIC
   ValTemp2$ = ""
   PRINT Prompt$;                    ' Stampa il prompt passato.
   INPUT "", ValTemp1$               ' Legge il numero come stringa.
   LungStringa = LEN(ValTemp1$)      ' Ottiene la lunghezza della stringa.
   FOR I% = 1 TO LungStringa         ' Esamina la stringa un carattere
      Car$ = MID$(ValTemp1$, I%, 1) ' per volta.

      ' Il carattere fa parte di un numero (cioä ä una
      ' cifra o una virgola decimale)?  Se sç, la aggiunge
      ' alla fine della nuova stringa:
      IF INSTR(".0123456789", Car$) > 0 THEN
         ValTemp2$ = ValTemp2$ + Car$

      ' Se no, controlla se ä una "l" minuscola,
      ' perchÇ un utente abituato a battere a macchina
      ' potrebbe digitarla al posto della cifra "1":
      ELSEIF Car$ = "l" THEN
         ValTemp2$ = ValTemp2$ + "1" ' Cambia la "l" in "1".
      END IF
   NEXT I%

   Filtro$ = ValTemp2$           ' Restituisce la stringa filtrata.

END FUNCTION

'
' ======================= LeggiRecord ========================
'    LeggiRecord prima chiama VisNumPezzo, che stampa
'    il menu dei numeri di pezzo sullo schermo in alto.
'    LeggiRecord poi sollecita dall'utente l'immissione di un
'    numero di pezzo. Infine, chiama le procedure TrovaRecord
'    e StampaRecord per trovare e stampare il record scelto.
' ============================================================
'
SUB LeggiRecord (VarRecord AS UnitaInMag) STATIC
   CLS
   VisNumPezzo      ' Chiama la SUBRoutine VisNumPezzo.

   ' Stampa sullo schermo in basso i dati dei record scelti:
   DO
      PRINT "Digitare uno dei numeri di pezzo elencati in "
      INPUT "alto (o U per uscire), e premere <INVIO>: ", Pezzo$
      IF UCASE$(Pezzo$) <> "U" THEN
         IF TrovaRecord%(Pezzo$, VarRecord) THEN
            StampaRecord VarRecord
         ELSE
            PRINT "Pezzo non trovato."
         END IF
      END IF
      PRINT STRING$(40, "_")
   LOOP WHILE UCASE$(Pezzo$) <> "U"

   VIEW PRINT   ' Reimposta la finestra di testo all'intero schermo.
END SUB

'
' ========================= OrdinaIndice ========================
'                Ordina l'indice secondo il numero del pezzo
' ===============================================================
'
SUB OrdinaIndice STATIC
   SHARED Indice() AS TipoIndice, NumDeiRecord

   ' Imposta l'offset per il confronto alla metÖ del
   ' numero dei record nell'indice:
   Offset = NumDeiRecord \ 2

   ' Cicla finchÇ l'offset non diventa zero:
   DO WHILE Offset > 0
      Limite = NumDeiRecord - Offset
      DO

         ' Presume non vi siano stati scambi con questo offset:
         Scambi = FALSO

         ' Confronta elementi e scambia quelli non in ordine:
         FOR I = 1 TO Limite
            IF Indice(I).NumPezzo > Indice(I + Offset).NumPezzo THEN
               SWAP Indice(I), Indice(I + Offset)
               Scambi = I
            END IF
         NEXT I

         ' Al successivo passaggio, ordina solo fino al punto
         ' del precedente scambio:
         Limite = Scambi
      LOOP WHILE Scambi

      ' Nessuno scambio al precedente offset; dimezza l'offset:
      Offset = Offset \ 2
   LOOP
END SUB

'
' ======================= StampaRecord ========================
'                Stampa un record sullo schermo
' ============================================================
'
SUB StampaRecord (VarRecord AS UnitaInMag) STATIC
   PRINT "Numero del pezzo: "; VarRecord.NumPezzo
   PRINT "Descrizione: "; VarRecord.Descrizione
   PRINT USING "Prezzo unitario : Lit######"; VarRecord.PrezzoUnitario
   PRINT "QuantitÖ   :"; VarRecord.Quantita
END SUB

'
' ======================= TrovaRecord% =================================
'     Utilizza una ricerca binaria per trovare il record nell'indice.
' ======================================================================
'
FUNCTION TrovaRecord% (Pezzo$, VarRecord AS UnitaInMag) STATIC
   SHARED Indice() AS TipoIndice, NumDeiRecord

   ' Imposta i limiti superiore e inferiore della ricerca:
   RecordSup = NumDeiRecord
   RecordInf = 1

   ' Ricerca finchÇ il limite superiore non ä minore del limite inferiore:
   DO UNTIL (RecordSup < RecordInf)

      ' Determina il punto intermedio:
      PuntoInt = (RecordSup + RecordInf) \ 2

      ' Prova se ä il record desiderato (RTRIM$() toglie
      ' gli spazi vuoti dalla fine di una stringa fissa):
      Prova$ = RTRIM$(Indice(PuntoInt).NumPezzo)

      ' Se ä la stringa giusta, esce dal ciclo:
      IF Prova$ = Pezzo$ THEN
         EXIT DO

      ' Altrimenti, se sta cercando un valore pió alto,
      ' alza il limite inferiore:
      ELSEIF Pezzo$ > Prova$ THEN
         RecordInf = PuntoInt + 1

      ' Se no, abbassa il limite superiore:
      ELSE
         RecordSup = PuntoInt - 1
      END IF
   LOOP

   ' Se il pezzo ä stato trovato, ottiene il record dal file usando
   ' un pointer all'indice e imposta TrovaRecord% a VERO:
   IF Prova$ = Pezzo$ THEN
      GET #1, Indice(PuntoInt).NumRecord, VarRecord
      TrovaRecord% = VERO

   ' Se non ä stato trovato, imposta TrovaRecord% a FALSO:
   ELSE
      TrovaRecord% = FALSO
   END IF
END FUNCTION

'
' ===================== VisNumPezzo ==========================
'  Stampa un elenco di tutti i numeri di pezzo nelle parte
'  alta dello schermo.
' ============================================================
'
SUB VisNumPezzo STATIC
   SHARED Indice() AS TipoIndice, NumDeiRecord

   CONST NUMCOL = 8, LARGCOL = 80 \ NUMCOL

   ' In cima allo schermo stampa l'elenco dei numeri di pezzo
   ' dei record nel file. Questo menu viene stampato in colonne della
   ' stessa lunghezza (tranne forse l'ultima, che puï essere pió
   ' corta delle altre):
   LungCol = NumDeiRecord
   DO WHILE LungCol MOD NUMCOL
      LungCol = LungCol + 1
   LOOP
   LungCol = LungCol \ NUMCOL
   Colonna = 1
   NumRecord = 1
   DO UNTIL NumRecord > NumDeiRecord
      FOR Riga = 1 TO LungCol
         LOCATE Riga, Colonna
         PRINT Indice(NumRecord).NumPezzo
         NumRecord = NumRecord + 1
         IF NumRecord > NumDeiRecord THEN EXIT FOR
      NEXT Riga
      Colonna = Colonna + LARGCOL
   LOOP

   LOCATE LungCol + 1, 1
   PRINT STRING$(80, "_")       ' Stampa la linea divisoria.

   ' Fa scorrere le informazioni sui record sotto l'elenco dei
   ' numeri di pezzo, cosç i numeri non vengono cancellati:
   VIEW PRINT LungCol + 2 TO 24
END SUB

