'
' *** DECL_EX.BAS - Programma esempio per l'istruzione DECLARE
'
' Genera 20 numeri casuali, li registra in una matrice, e li ordina.
' Il sottoprogramma di ordinamento viene chiamato senza la parolachiave CALL.
DECLARE SUB Ordina (A() AS SINGLE, N AS INTEGER)
DIM Matr1(1 TO 20)

' Genera 20 numeri casuali.
RANDOMIZE TIMER
FOR I = 1 TO 20
   Matr1(I) = RND
NEXT I

' Ordina la matrice e chiama Ordina senza la parolachiave CALL.
' Notare l'assenza di parentesi intorno agli argomenti nella
' chiamata a Ordina.
Ordina Matr1(), 20

' Stampa la matrice ordinata.
FOR I = 1 TO 20
   PRINT Matr1(I)
NEXT I
END

' Subroutine per l'ordinamento.
SUB Ordina (A(), N%) STATIC

   FOR I = 1 TO N% - 1
      FOR J = I + 1 TO N%
         IF A(I) > A(J) THEN SWAP A(I), A(J)
      NEXT J
   NEXT I

END SUB

