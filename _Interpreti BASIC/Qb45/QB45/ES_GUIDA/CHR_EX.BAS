DECLARE SUB DCas (RigA%, ColA%, RigB%, ColB%)
' *** CAR_EX.BAS ***
'
DEFINT A-Z
CLS   'Pulisce lo schermo.
' Visualizza due caselle con doppio bordo.
CALL DCas(5, 22, 18, 40)
CALL DCas(1, 4, 4, 50)
END

' Subroutine che visualizza le caselle.
' Parametri:
'  RigA%, ColA% : Riga e colonna dell'angolo in alto a sinistra.
'  RigB%, ColB% : Riga e colonna dell'angolo in basso a destra.
'  Costanti per i caratteri grafici estesi ASCII.
CONST ANGAS = 201, ANGAD = 187, VERTICALE = 186, ORIZZONTALE = 205
CONST ANGBS = 200, ANGBD = 188

SUB DCas (RigA%, ColA%, RigB%, ColB%) STATIC
   ' Disegna il bordo superiore della casella.
   LOCATE RigA%, ColA%: PRINT CHR$(ANGAS);
   LOCATE , ColA% + 1: PRINT STRING$(ColB% - ColA%, CHR$(ORIZZONTALE));
   LOCATE , ColB%: PRINT CHR$(ANGAD);
   ' Disegna la parte centrale.
   FOR I = RigA% + 1 TO RigB% - 1
      LOCATE I, ColA%: PRINT CHR$(VERTICALE);
      LOCATE , ColB%: PRINT CHR$(VERTICALE);
   NEXT I
   ' Disegna il bordo inferiore.
   LOCATE RigB%, ColA%: PRINT CHR$(ANGBS);
   LOCATE , ColA% + 1: PRINT STRING$(ColB% - ColA%, CHR$(ORIZZONTALE));
   LOCATE , ColB%: PRINT CHR$(ANGBD);
END SUB

