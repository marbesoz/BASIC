DECLARE SUB DumpSim (InizSimb AS INTEGER, PosTstQ AS LONG)
' Questo programma stampa i nomi delle procedure in una QuickLibrary

DECLARE SUB DumpSim (InizSimb AS INTEGER, PosTstQ AS LONG)

TYPE TestExe                 ' Parte della testata .EXE di DOS
    altri1    AS STRING * 8  ' Altri dati sulla testata
    NParTes   AS INTEGER     ' Numero di paragrafi nella testata
    altri2    AS STRING * 10 ' Altri dati sulla testata
    IP        AS INTEGER     ' Valore IP iniziale
    CS        AS INTEGER     ' Valore CS iniziale (relativo)
END TYPE

TYPE TesQB                   ' Testata QLB
    StitQB    AS STRING * 6  ' Sottotitolo particolare a QB
    Sesamo     AS INTEGER    ' Parola che identifica i file
                             ' QuickLibrary
    InizSimb  AS INTEGER     ' Offset dalla testata al primo simbolo codice
    InizDati  AS INTEGER     ' Offset dalla testata al primo simbolo dati
END TYPE

TYPE SimQb                   ' Voce simbolica QuickLib
    Flag      AS INTEGER     ' Segnalatore di simboli
    InizioNom AS INTEGER     ' Offset nella tabella dei nomi
    altri     AS STRING * 4  ' Altri dati sulla testata
END TYPE

DIM TstE AS TestExe, TstQ AS TesQB, PosTstQ AS LONG

INPUT "Nome del file QuickLibrary: ", NomeFile$
NomeFile$ = UCASE$(NomeFile$)
IF INSTR(NomeFile$, ".QLB") = 0 THEN NomeFile$ = NomeFile$ + ".QLB"

INPUT "Nome del file di destinazione (o INVIO per lo schermo): ", FileDest$
FileDest$ = UCASE$(FileDest$)
IF FileDest$ = "" THEN FileDest$ = "CON"

OPEN NomeFile$ FOR BINARY AS #1
OPEN FileDest$ FOR OUTPUT AS #2

GET #1, , TstE               ' Legge la testata del formato EXE.

PosTstQ = (TstE.NParTes + TstE.CS) * 16 + TstE.IP + 1

GET #1, PosTstQ, TstQ        ' Legge la testata del formato QuickLib.

IF TstQ.Sesamo <> &H6C75 THEN PRINT "Non Š una QuickLibrary di QB": END

PRINT #2, "Simboli di codice:": PRINT #2,
DumpSim TstQ.InizSimb, PosTstQ ' esegue il dump dei simboli di codice
PRINT #2,

PRINT #2, "Simboli di dati:": PRINT #2, ""
DumpSim TstQ.InizDati, PosTstQ ' esegue il dump dei simboli di dati
PRINT #2,

END

SUB DumpSim (InizSimb AS INTEGER, PosTstQ AS LONG)
   DIM SimQlb AS SimQb
   DIM SimSucc AS LONG, SimCorr AS LONG

   ' Calcola la posizione della prima voce simbolica e la legge:
   SimSucc = PosTstQ + InizSimb
   GET #1, SimSucc, SimQlb

   DO
      SimSucc = SEEK(1)          ' Salva la posizione del simbolo
                                 ' successivo.
      SimCorr = PosTstQ + SimQlb.InizioNom
      SEEK #1, SimCorr           ' Usa SEEK per spostarsi al nome
                                 ' della voce simbolica corrente.
      Prospett$ = INPUT$(40, 1)  ' Legge una stringa della massima
                                 ' lunghezza valida, pi— un byte per
                                 ' il carattere nullo finale (CHR$(0)).

      ' Estrae il nome terminante nel carattere nullo:
      NomeS$ = LEFT$(Prospett$, INSTR(Prospett$, CHR$(0)))

      ' Stampa solo i nomi che non iniziano per "__", "$", o "b$",
      ' perch‚ questi sono generalmente riservati:
      IF LEFT$(NomeS$, 2) <> "__" AND LEFT$(NomeS$, 1) <> "$" AND UCASE$(LEFT$(NomeS$, 2)) <> "B$" THEN
         PRINT #2, "  " + NomeS$
      END IF

      GET #1, SimSucc, SimQlb    ' Legge una voce simbolica.
   LOOP WHILE SimQlb.Flag       ' Flag=0 segnala la fine della tabella.
END SUB

