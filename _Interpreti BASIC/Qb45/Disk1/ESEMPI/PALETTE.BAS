DECLARE SUB InizPalette ()
DECLARE SUB CambiaPalette ()
DECLARE SUB DisegnaEllissi ()
DEFINT A-Z

DIM SHARED MatrPalette(15)

SCREEN 8                 ' risoluzione 640 x 200; 16 colori

InizPalette
DisegnaEllissi

DO
   CambiaPalette
LOOP WHILE INKEY$ = ""   ' Sposta la palette finch‚ non viene premuto un tasto

END

'
' ====================== CambiaPalette =======================
'    Questa procedura sposta la palette di una unit… a
'    ogni chiamata. Per esempio, dopo la prima chiamata a
'    CambiaPalette, MatrPalette(1) = 2, MatrPalette(2) = 3,
'    . . . , MatrPalette(14) = 15, e MatrPalette(15) = 1
' ============================================================
'
SUB CambiaPalette STATIC
   FOR I = 1 TO 15
      MatrPalette(I) = (MatrPalette(I) MOD 15) + 1
   NEXT I

   ' Sposta il colore visualizzato dagli attributi 1 - 15
   PALETTE USING MatrPalette(0)
END SUB

'
' ====================== DisegnaEllissi ========================
'    Questa procedura disegna quindici ellissi concentriche e ne
'    colora l'interno con colori diversi.
' ============================================================
'
SUB DisegnaEllissi STATIC
   CONST ASPECT = 1 / 3
   FOR ColorVal = 15 TO 1 STEP -1
      Radius = 20 * ColorVal
      CIRCLE (320, 100), Radius, ColorVal, , , ASPECT
      PAINT (320, 100), ColorVal
   NEXT
END SUB

'
' ======================= InizPalette ========================
'    Questa procedura inizializza la matrice usata per
'    cambiare la palette.
' ============================================================
'
SUB InizPalette STATIC
   FOR I = 0 TO 15
      MatrPalette(I) = I
   NEXT I
END SUB

