DECLARE SUB Zoom (x!)
'
' *** WINDO_EX.BAS -- Programma esempio per l'istruzione WINDOW
'
PRINT "Premere INVIO per iniziare."
INPUT ; "", A$
SCREEN 1: COLOR 7               'Schermo grigio.
x = 500: DeltaX = 50

DO
   DO WHILE x < 525 AND x > 50
      x = x + DeltaX            'Cambia la dimensione della finestra.
      CALL Zoom(x)
      FOR I = 1 TO 1000         'Ciclo di ritardo.
         IF INKEY$ <> "" THEN END   'Si ferma alla pressione di un tasto.
      NEXT
   LOOP
   x = x - DeltaX
   DeltaX = -DeltaX             'Inverte il cambiamento di dimensione.
LOOP

SUB Zoom (x) STATIC
   CLS
   WINDOW (-x, -x)-(x, x)       'Definisce nuove coordinate per la finestra
                                'corrente (l'intero schermo in questo caso).
   LINE (-x, -x)-(x, x), 1, B   'Ne disegna il bordo.
   CIRCLE (0, 0), 60, 1, , , .5 'Disegna un'ellisse con un semiasse
                                'maggiore uguale a 60.
   PAINT (0, 0), 1              'Colora l'ellisse.
END SUB

