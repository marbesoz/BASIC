DEFINT A-Z               ' Il tipo predefinito per le variabili ä intero

' Definisce un tipo di dati per i nomi dei mesi e il
' numero di giorni in ogni mese:
TYPE TipoMese
   NumerG AS INTEGER     ' Numero di giorni nel mese
   NomeM AS STRING * 9   ' Nome del mese
END TYPE

' Dichiara le procedure usate:
DECLARE FUNCTION AnnoBisest% (N%)
DECLARE FUNCTION GetInput% (Prompt$, Riga%, ValBasso%, ValAlto%)

DECLARE SUB VisualizCal (Anno%, Mese%)
DECLARE SUB CalcolaMese (Anno%, Mese%, GiornoIniz%, NumGiorni%)

DIM DatiMese(1 TO 12) AS TipoMese

' Inizializza le definizioni dei mesi dalle istruzioni DATA in fondo:
FOR I = 1 TO 12
   READ DatiMese(I).NomeM, DatiMese(I).NumerG
NEXT

' Ciclo principale; ripete se si desidera vedere altri mesi:
DO

   CLS

   ' Ottiene l'anno e il mese come input:
   Anno = GetInput("Anno (dal 1899 al 2099): ", 1, 1899, 2099)
   Mese = GetInput("Mese (da 1 a 12): ", 2, 1, 12)

   ' Visualizza il calendario:
   VisualizCal Anno, Mese

   ' Un'altra data?
   LOCATE 13, 1                     ' Posiziona su 13a riga, 1a colonna
   PRINT "Un'altra data? (Sç/No)";  ' Tiene il cursore sulla stessa riga
   LOCATE , , 1, 0, 13              ' Attiva il cursore e lo fa alto
                                    '   un carattere.
   Risp$ = INPUT$(1)                ' Attende la pressione di un tasto.
   PRINT Risp$                      ' Visualizza il tasto premuto.

LOOP WHILE UCASE$(Risp$) = "S"
END

' Dati per i mesi dell'anno:
DATA Gennaio, 31, Febbraio, 28, Marzo, 31
DATA Aprile, 30, Maggio, 31, Giugno, 30, Luglio, 31, Agosto, 31
DATA Settembre, 30, Ottobre, 31, Novembre, 30, Dicembre, 31

'
' ====================== ANNOBISEST ==========================
'         Determina se un anno ä bisestile o no.
' ============================================================
'
FUNCTION AnnoBisest (N) STATIC

   ' Se l'anno ä divisibile per 4 ma non per 100,
   ' oppure se ä divisibile per 400, significa che
   ' ä bisestile:
   AnnoBisest = (N MOD 4 = 0 AND N MOD 100 <> 0) OR (N MOD 400 = 0)
END FUNCTION

'
' ====================== CALCOLAMESE ========================
'     Calcola il primo giorno e il numero di giorni in un mese.
' ============================================================
'
SUB CalcolaMese (Anno, Mese, GiornoIniz, NumGiorni) STATIC
   SHARED DatiMese() AS TipoMese
   CONST BISEST = 366 MOD 7
   CONST NORMALE = 365 MOD 7

   ' Calcola il totale dei giorni (TotGiorni) dal 1/1/1899:

   ' Comincia dagli anni interi:
   TotGiorni = -1
   FOR I = 1899 TO Anno - 1
      IF AnnoBisest(I) THEN               ' Se l'anno ä bisestile, aggiungere
         TotGiorni = TotGiorni + BISEST   '   366 MOD 7.
      ELSE                                ' Se l'anno ä normale, aggiungere
         TotGiorni = TotGiorni + NORMALE  '   365 MOD 7.
      END IF
   NEXT

   ' Poi, aggiungere i giorni dei mesi interi:
   FOR I = 1 TO Mese - 1
      TotGiorni = TotGiorni + DatiMese(I).NumerG
   NEXT

   ' Imposta il numero di giorni del mese desiderato:
   NumGiorni = DatiMese(Mese).NumerG

   ' Compensa se l'anno desiderato ä bisestile:
   IF AnnoBisest(Anno) THEN

      ' Se ä dopo febbraio, aggiunge uno al numero totale dei giorni:
      IF Mese > 2 THEN
         TotGiorni = TotGiorni + 1

      ' Se ä febbraio, aggiunge uno al numero dei giorni del mese:
      ELSEIF Mese = 2 THEN
         NumGiorni = NumGiorni + 1

      END IF
   END IF

   ' 1/1/1899 era domenica (-1), quindi calcolando "TotGiorni MOD 7"
   ' si ottiene il giorno della settimana (lunedç = 0, martedç = 1,
   ' e cosç via) del primo giorno del mese desiderato:
   GiornoIniz = TotGiorni MOD 7
END SUB

'
' ======================== GETINPUT =======================================
'       Sollecita l'input, quindi verifica se ä compreso nell'intervallo.
' =========================================================================
'
FUNCTION GetInput (Prompt$, Riga, ValBasso, ValAlto) STATIC

   ' Posiziona il prompt alla riga specificata, attiva il cursore e
   '   lo fa alto un carattere:
   LOCATE Riga, 1, 1, 0, 13
   PRINT Prompt$;

   ' Salva la posizione della colonna:
   Colonna = POS(0)

   ' Legge un valore finchÇ non ä compreso nell'intervallo:
   DO
      LOCATE Riga, Colonna   ' Posiziona il cursore dopo il prompt.
      PRINT SPACE$(10)       ' Cancella ciï che potrebbe trovarvi.
      LOCATE Riga, Colonna   ' Riposiziona il cursore dopo il prompt.
      INPUT "", Valore       ' Legge il valore (e scarta il prompt).
   LOOP WHILE (Valore < ValBasso OR Valore > ValAlto)

   ' Restituisce un input valido come valore della funzione:
   GetInput = Valore

END FUNCTION

'
' ===================== VISUALIZCAL ==========================
'     Visualizza il calendario del mese nell'anno specificato.
' ============================================================
'
SUB VisualizCal (Anno, Mese) STATIC
SHARED DatiMese() AS TipoMese

   ' Calcola il primo giorno (L Ma Me ...) e il numero di
   ' giorni nel mese:
   CalcolaMese Anno, Mese, GiornoIniz, NumGiorni
   CLS
   Testata$ = RTRIM$(DatiMese(Mese).NomeM) + "," + STR$(Anno)

   ' Calcola la posizione sullo schermo per il mese e l'anno:
   MargineSin = (35 - LEN(Testata$)) \ 2

   ' Stampa la testata:
   PRINT TAB(MargineSin); Testata$
   PRINT
   PRINT " L    Ma   Me   G    V    S    D"
   PRINT

   ' Ricalcola e stampa la tabulazione al primo
   ' giorno del mese (L Ma Me ...):
   MargineSin = 5 * GiornoIniz + 1
   PRINT TAB(MargineSin);

   ' Stampa i giorni del mese:
   FOR I = 1 TO NumGiorni
      PRINT USING "##   "; I;

      ' Avanza alla riga successiva quando il cursore
      ' passa la colonna 32:
      IF POS(0) > 32 THEN PRINT
   NEXT

END SUB

