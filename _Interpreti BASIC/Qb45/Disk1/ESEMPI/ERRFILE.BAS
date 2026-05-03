' Dichiara le costanti simboliche usate nel programma:
CONST FALSO = 0, VERO = NOT FALSO

DECLARE FUNCTION LetturaNomeFile$ ()

' installa la gestione di errori, e specifica il nome della
' routine gestione errori:
ON ERROR GOTO GestErr

DO
   Ricomincia = FALSO
   CLS

   NomeFile$ = LetturaNomeFile$     ' Legge il nome del file.

   IF NomeFile$ = "" THEN
      END                           ' Termina se viene premuto <INVIO>.
   ELSE

      ' Altrimenti apre il file, assegnandogli il primo
      ' numero di file disponibile:
      NumFile = FREEFILE
      OPEN NomeFile$ FOR INPUT AS NumFile
   END IF

   IF NOT Ricomincia THEN

      ' Legge la stringa da cercare:
      LINE INPUT "Digitare la stringa da cercare: ", StringaCerca$
      StringaCerca$ = UCASE$(StringaCerca$)

      ' Cicla per le righe del file, stampandole
      ' se contengono la stringa da cercare:
      NumRiga = 1
      DO WHILE NOT EOF(NumFile)

         ' Legge una riga dal file:
         LINE INPUT #NumFile, BufferRiga$

         ' Controlla se c'Š la stringa; se c'Š stampa la riga e il
         ' relativo numero:
         IF INSTR(UCASE$(BufferRiga$), StringaCerca$) <> 0 THEN
            PRINT USING "#### &"; NumRiga; BufferRiga$
         END IF

         NumRiga = NumRiga + 1
      LOOP

      CLOSE NumFile             ' Chiude il file.

   END IF
LOOP WHILE Ricomincia = VERO

END

GestErr:

   SELECT CASE ERR

      CASE 64:                  ' Nome di file non valido
         PRINT "** ERRORE - Nome di file non valido"

         ' Ottiene un nuovo nome di file e riprova:
         NomeFile$ = LetturaNomeFile$

         ' Riprende all'istruzione che aveva causato l'errore:
         RESUME

      CASE 71:                  ' Disco non pronto
         PRINT "** ERRORE - Unit… disco non pronta"
         PRINT "Premere C per continuare, R per ricominciare, U per uscire: "
         DO
            Car$ = UCASE$(INPUT$(1))
            IF Car$ = "C" THEN
               RESUME              ' Riprende da dove aveva interrotto

            ELSEIF Car$ = "R" THEN
               Ricomincia = VERO   ' Ricomincia dall'inizio
               RESUME NEXT

            ELSEIF Car$ = "U" THEN
               END                 ' Termina l'esecuzione
            END IF
         LOOP

      CASE 53, 76:                 ' File o percorso non trovato
         PRINT "** ERRORE - File o percorso non trovato"
         NomeFile$ = LetturaNomeFile$
         RESUME

      CASE ELSE:                ' Errore imprevedibile

         ' Disattiva la gestione di errori e visualizza il messaggio
         ' standard del sistema:
         ON ERROR GOTO 0
   END SELECT

'
' ======================= LetturaNomeFile$ =======================
'              Restituisce un nome di file digitato dall'utente
' ================================================================
'
FUNCTION LetturaNomeFile$ STATIC
   INPUT "Cercare in quale file? (premere INVIO per terminare): ", FTemp$
   LetturaNomeFile$ = FTemp$
END FUNCTION

