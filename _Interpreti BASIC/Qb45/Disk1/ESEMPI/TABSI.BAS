' TABSI.BAS
'
' In un file, sostituisce sequenze di spazi con tabulazioni.
'
DECLARE SUB ImpostaPosTab ()
DECLARE SUB InterpretaComando (RComando$)


DEFINT A-Z
DECLARE FUNCTION EUnPuntoTab (Colonna AS INTEGER)

CONST COLMASS = 255
CONST TABULAZ = 8
CONST NO = 0, SI = NOT NO

DIM SHARED PuntiTab(COLMASS) AS INTEGER

InterpretaComando (COMMAND$)

' Imposta la posizione delle tabulazioni (usando la matrice globale PuntiTab).
ImpostaPosTab

UltColonna = 1

DO

   CorrColonna = UltColonna

' Sostituisce una serie di spazi con una tabulazione quando arriva a
' una colonna di tabulazione. CorrColonna Š la colonna corrente.
' UltColonna Š l'ultima colonna stampata.
   DO
      C$ = INPUT$(1, #1)
      IF C$ <> " " AND C$ <> CHR$(9) THEN EXIT DO
      CorrColonna = CorrColonna + 1
      IF C$ = CHR$(9) OR EUnPuntoTab(CorrColonna) THEN
         ' Si sposta su una colonna di tabulazione se trova una tabulazione
         ' mentre non Š in una colonna di tabulazione.
         DO WHILE NOT EUnPuntoTab(CorrColonna)
            CorrColonna = CorrColonna + 1
         LOOP
         PRINT #2, CHR$(9);
         UltColonna = CorrColonna
      END IF
   LOOP

' Stampa eventuali spazi avanzati.
   DO WHILE UltColonna < CorrColonna
      PRINT #2, " ";
      UltColonna = UltColonna + 1
   LOOP

' Stampa il carattere non vuoto.
   PRINT #2, C$;

' Reimposta la posizione della colonna quando raggiunge la fine della riga.
   IF C$ = CHR$(10) THEN
      UltColonna = 1
   ELSE
      UltColonna = UltColonna + 1
   END IF

LOOP UNTIL EOF(1)
CLOSE #1, #2
END

'---------------FUNCTION EUnPuntoTab----------------------
' Risponde al quesito "E' un punto di tabulazione?"
'
FUNCTION EUnPuntoTab (UltColonna AS INTEGER) STATIC
   IF UltColonna > COLMASS THEN
      EUnPuntoTab = SI
   ELSE
      EUnPuntoTab = PuntiTab(UltColonna)
   END IF
END FUNCTION

'------------------SUB ImpostaPosTab-------------------------
' Imposta i punti di tabulazione nella matrice PuntiTab.
'
SUB ImpostaPosTab STATIC
   FOR I = 1 TO 255
      PuntiTab(I) = ((I MOD TABULAZ) = 1)
   NEXT I
END SUB

'
'------------------SUB InterpretaComando----------------------
'
SUB InterpretaComando (RigaComando$) STATIC
   IF RigaComando$ = "" THEN
      INPUT "File da intabulare:   ", NomeFileOrig$
      INPUT "Memorizza il file intabulato in:   ", NomeFileDest$
   ELSE
      PosSpazio = INSTR(RigaComando$, " ")
      IF PosSpazio > 0 THEN
         NomeFileOrig$ = LEFT$(RigaComando$, PosSpazio - 1)
         NomeFileDest$ = LTRIM$(MID$(RigaComando$, PosSpazio))
      ELSE
         NomeFileOrig$ = RigaComando$
         INPUT "Memorizza il file intabulato in:   ", NomeFileDest$
      END IF
   END IF
   OPEN NomeFileOrig$ FOR INPUT AS #1
   OPEN NomeFileDest$ FOR OUTPUT AS #2
END SUB

