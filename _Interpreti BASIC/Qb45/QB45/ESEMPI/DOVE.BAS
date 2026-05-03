DEFINT A-Z

' Dichiara le costanti simboliche usate nel programma:
CONST TIPOEOF = 0, TIPOFILE = 1, TIPODIR = 2, RADICE = "TWH"

DECLARE SUB GuardaDir (SpecPerc$, Livello, SpecFile$, Riga)

DECLARE FUNCTION CreaNomeFile$ (Num)
DECLARE FUNCTION OttVoce$ (NumFile, TipoVoce)

CLS
INPUT "File da trovare"; SpecFile$
PRINT
PRINT "Digitare la directory da cui iniziare la ricerca (l'unit…"
PRINT "disco (opzionale) + la directory), o premere <INVIO> per"
PRINT "iniziare la ricerca dalla directory principale dell'unit… corrente."
PRINT
INPUT "Directory iniziale"; SpecPerc$
CLS

CarDes$ = RIGHT$(SpecPerc$, 1)

IF SpecPerc$ = "" OR CarDes$ = ":" OR CarDes$ <> "\" THEN
   SpecPerc$ = SpecPerc$ + "\"
END IF

SpecFile$ = UCASE$(SpecFile$)
SpecPerc$ = UCASE$(SpecPerc$)
Livello = 1
Riga = 3

' Esegue la chiamata al livello pi— alto (il livello 1)
' per iniziare la ricerca:
GuardaDir SpecPerc$, Livello, SpecFile$, Riga

KILL RADICE + ".*"        ' Elimina tutti i file temporanei
                          ' creati dal programma.

LOCATE Riga + 1, 1: PRINT "Ricerca compiuta."
END

'
' ===================== CREANOMEFILE$ =======================
'    Questa procedura crea un nome di file da una radice
'    ("TWH" - definita come costante simbolica al livello del
'    modulo) e un numero passato come argomento (Num).
' ===========================================================
'
FUNCTION CreaNomeFile$ (Num) STATIC

   CreaNomeFile$ = RADICE + "." + LTRIM$(STR$(Num))

END FUNCTION

'
' ======================= GUARDADIR ===========================
'   Questa procedura ricerca ricorsivamente in una directory
'   il file con il nome digitato dall'utente.
'
'   NOTA: La testata della SUB non usa la parola chiave
'         STATIC perch‚ la procedura usa nuove variabili
'         ad ogni chiamata.
' ===========================================================
'
SUB GuardaDir (SpecPerc$, Livello, SpecFile$, Riga)

   LOCATE 1, 1: PRINT "Ricerca in corso in "; SPACE$(50);
   LOCATE 1, 21: PRINT SpecPerc$;

   ' Crea un nome per il file temporaneo:
   FileTemp$ = CreaNomeFile$(Livello)

   ' Ottiene un listato della directory corrente,
   ' e lo salva nel file temporaneo:
   SHELL "DIR " + SpecPerc$ + " > " + FileTemp$

   ' Trova il primo numero di file disponibile:
   NumFile = FREEFILE

   ' Apre il file con il listato DIR e lo legge:
   OPEN FileTemp$ FOR INPUT AS #NumFile

   ' Elabora il file riga per riga:
   DO

      ' Ottiene una voce dal listato DIR:
      VoceDir$ = OttVoce$(NumFile, TipoVoce)

      ' Se la voce Š un file:
      IF TipoVoce = TIPOFILE THEN

         ' Se la stringa SpecFile$ corrisponde, stampa la voce
         ' ed esce dal ciclo:
         IF VoceDir$ = SpecFile$ THEN
            LOCATE Riga, 1: PRINT SpecPerc$; VoceDir$;
            Riga = Riga + 1
            TipoVoce = TIPOEOF
         END IF

      ' Se la voce Š una directory, esegue una chiamata ricorsiva
      ' a GuardaDir passandole la nuova directory:
      ELSEIF TipoVoce = TIPODIR THEN
         NuovoPerc$ = SpecPerc$ + VoceDir$ + "\"
         GuardaDir NuovoPerc$, Livello + 1, SpecFile$, Riga
         LOCATE 1, 1: PRINT "Ricerca in corso in "; SPACE$(50);
         LOCATE 1, 21: PRINT SpecPerc$;
      END IF

   LOOP UNTIL TipoVoce = TIPOEOF

   ' La ricerca nel file listato di DIR Š terminata, lo chiude:
   CLOSE NumFile
END SUB

'
' ======================= OTTVOCE ==========================
'    Questa procedura elabora le singole righe di un listato
'    DIR memorizzato in un file.
' ===========================================================
'
FUNCTION OttVoce$ (NumFile, TipoVoce) STATIC

   ' Ripete il ciclo finch‚ non legge o una voce valida
   ' o il carattere di fine file (EOF):
   DO UNTIL EOF(NumFile)
      LINE INPUT #NumFile, RigaVoce$
      IF RigaVoce$ <> "" THEN

         ' Seleziona il primo carattere della riga per la prova:
         CarProva$ = LEFT$(RigaVoce$, 1)
         IF CarProva$ <> " " AND CarProva$ <> "." THEN EXIT DO
      END IF
   LOOP

   ' Ha trovato o una voce o l'EOF, e decide quale Š:
   IF EOF(NumFile) THEN
      TipoVoce = TIPOEOF
      OttVoce$ = ""

   ELSE           ' Non Š l'EOF, Š o un file o una directory.

      ' Compone e restituisce il nome della voce:
      NomeVoce$ = RTRIM$(LEFT$(RigaVoce$, 8))

      ' Prova se c'Š un estensione da aggiungere al nome:
      EstenVoce$ = RTRIM$(MID$(RigaVoce$, 10, 3))
      IF EstenVoce$ <> "" THEN
         OttVoce$ = NomeVoce$ + "." + EstenVoce$
      ELSE
         OttVoce$ = NomeVoce$
      END IF

      ' Determina il tipo della voce, e ne restituisce il valore
      ' al punto da cui Š stata chiamata OttVoce$:
      IF MID$(RigaVoce$, 15, 3) = "DIR" THEN
         TipoVoce = TIPODIR            ' Directory
      ELSE
         TipoVoce = TIPOFILE           ' File
      END IF

   END IF

END FUNCTION

