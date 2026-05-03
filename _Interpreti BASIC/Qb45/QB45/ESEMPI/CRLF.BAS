DEFINT A-Z              ' Il tipo predefinito per le variabili ä intero

' La funzione Backup$ crea un file backup con lo stesso
' nome di base di NomeFile$, ma con l'estensione .BAK :
DECLARE FUNCTION Backup$ (NomeFile$)

' Inizializza le costanti e le variabili simboliche:
CONST FALSO = 0, VERO = NOT FALSO

Invio$ = CHR$(13)
Interlinea$ = CHR$(10)

DO
   CLS

   ' Ottiene il nome del file da cambiare:
   INPUT "Qual ä il file da convertire"; FileOrig$

   FileDest$ = Backup$(FileOrig$)  ' Ottiene il nome del file backup.

   ON ERROR GOTO GestErrori   ' Attiva la gestione di errori.

   NAME FileOrig$ AS FileDest$     ' Copia il file di origine al
                                ' file backup.

   ON ERROR GOTO 0              ' Disattiva la gestione di errori.

   ' Apre il file backup per l'input e il file di origine
   ' per l'output:
   OPEN FileDest$ FOR INPUT AS #1
   OPEN FileOrig$ FOR OUTPUT AS #2

   ' La variabile PrecInvio ä un flag che viene impostato su VERO
   ' quando il programma legge un carattere di INVIO:
   PrecInvio = FALSO

   ' Legge dal file di origine finchÇ non incontra
   ' la fine del file:
   DO UNTIL EOF(1)

      ' Non ä la fine del file, quindi legge un carattere:
      CarFile$ = INPUT$(1, #1)

      SELECT CASE CarFile$

         CASE Invio$        ' Il carattere ä INVIO.

            ' Se anche il carattere precedente era
            ' INVIO, antepone INTERLINEA al carattere:
            IF PrecInvio THEN
                CarFile$ = Interlinea$ + CarFile$
            END IF

            ' In ogni caso, imposta la variabile PrecInvio
            ' a VERO:
            PrecInvio = VERO

         CASE Interlinea$         ' Il carattere ä INTERLINEA.

            ' Se il carattere precedente non era INVIO,
            ' antepone INVIO al carattere:
            IF NOT PrecInvio THEN
                CarFile$ = Invio$ + CarFile$
            END IF

            ' In ogni caso, imposta la variabile PrecInvio
            ' a FALSO:
            PrecInvio = FALSO

         CASE ELSE              ' NÇ INVIO nÇ INTERLINEA.

            ' Se il carattere precedente era INVIO,
            ' imposta la variabile PrecInvio a FALSO
            ' ed antepone INTERLINEA al carattere corrente:
            IF PrecInvio THEN
                PrecInvio = FALSO
                CarFile$ = Interlinea$ + CarFile$
            END IF

      END SELECT

      ' Registra i(l) caratteri(e) nel nuovo file:
      PRINT #2, CarFile$;
   LOOP

   ' Registra INTERLINEA se l'ultimo carattere del file ä INVIO:
   IF PrecInvio THEN PRINT #2, Interlinea$;

   CLOSE                           ' Chiude i due file.
   PRINT "Un altro file? (Sç/No)"  ' Chiede se si desidera proseguire.

   ' Cambia l'input in maiuscolo:
   Ancora$ = UCASE$(INPUT$(1))

' Continua il programma se l'utente ha digitato "s" o "S":
LOOP WHILE Ancora$ = "S"
END

GestErrori:           ' Routine per la gestione di errori
   CONST NESSUNFILE = 53, FILEESISTE = 58

   ' La funzione ERR restituisce il codice di errore dell'ultimo errore:
   SELECT CASE ERR
      CASE NESSUNFILE       ' Il programma non ha trovato un file di origine
                            ' con il nome specificato.
         PRINT "Impossibile trovare il file nella directory corrente."
         INPUT "Digitare un nuovo nome: ", FileOrig$
         FileDest$ = Backup$(FileOrig$)
         RESUME
      CASE FILEESISTE   ' Esiste giÖ un file di nome
                        ' <nomefile>.BAK nella directory:
                        ' lo rimuove, e continua.
         KILL FileDest$
         RESUME
      CASE ELSE         ' E' avvenuto un errore imprevisto:
                        ' ferma il programma.
         ON ERROR GOTO 0
   END SELECT

'
' ========================= BACKUP$ ==========================
'   Questa procedura restituisce un nome di file che consiste del
'   nome di base del file di input (i caratteri prima del "."),
'   pió l'estensione ".BAK"
' ============================================================
'
FUNCTION Backup$ (NomeFile$) STATIC

   ' Cerca il punto fermo:
   Estensione = INSTR(NomeFile$, ".")

   ' Se trova il punto fermo, aggiunge .BAK alla base:
   IF Estensione > 0 THEN
      Backup$ = LEFT$(NomeFile$, Estensione - 1) + ".BAK"

   ' Se non lo trova, aggiunge .BAK all'intero nome:
   ELSE
      Backup$ = NomeFile$ + ".BAK"
   END IF
END FUNCTION

