DECLARE SUB CreaMazzo (Mazzo() AS ANY)
DECLARE SUB Mescola (Mazzo() AS ANY)
DECLARE SUB MostraCarta (SingolaCarta AS ANY)
'
' *** TYPE_EX.BAS -- Programma esempio per l'istruzione TYPE
'
TYPE Carta
   Valore AS INTEGER
   Seme AS STRING * 6
END TYPE

DEFINT A-Z
' Definisce Mazzo come una matrice di 52 elementi di tipo Carta.
DIM Mazzo(1 TO 52) AS Carta

' Crea e mescola il mazzo e distribuisce le prime cinque carte.
CALL CreaMazzo(Mazzo())
CALL Mescola(Mazzo())
FOR I% = 1 TO 5
   CALL MostraCarta(Mazzo(I%))
NEXT I%
PRINT

' Crea il mazzo--inizializza la matrice delle carte con i valori
' appropriati.
SUB CreaMazzo (Mazzo() AS Carta) STATIC
DIM Semi(4) AS STRING * 6

   Semi(1) = "Cuori"
   Semi(2) = "Fiori"
   Semi(3) = "Quadri"
   Semi(4) = "Picche"
' Questo ciclo determina il seme.
   FOR I% = 1 TO 4
    ' Questo ciclo determina il valore.
      FOR J% = 1 TO 13
       ' Calcola la carta (1...52) da creare.
         NumCarta% = J% + (I% - 1) * 13
       ' Ne imposta il valore e il seme.
         Mazzo(NumCarta%).Valore = J%
         Mazzo(NumCarta%).Seme = Semi(I%)
      NEXT J%
   NEXT I%

END SUB

' Mescola il mazzo (una matrice di 52 elementi di tipo Carta).
SUB Mescola (Mazzo() AS Carta) STATIC

   RANDOMIZE TIMER
' Mescola permutando 1000 coppie di carte selezionate a caso.
   FOR I% = 1 TO 1000
      PrimaCarta% = INT(52 * RND + 1)
      SeconCarta% = INT(52 * RND + 1)
   ' Notare che SWAP funziona anche su matrici di elementi
   ' definiti dall'utente.
      SWAP Mazzo(PrimaCarta%), Mazzo(SeconCarta%)
   NEXT I%

END SUB

' Visualizza una singlola carta convertendo e mostrandone il
' valore e il seme.
SUB MostraCarta (SingolaCarta AS Carta) STATIC

   SELECT CASE SingolaCarta.Valore
      CASE 13
         PRINT "    Re ";
      CASE 12
         PRINT "Regina ";
      CASE 11
         PRINT " Fante ";
      CASE 1
         PRINT "  Asso ";
      CASE ELSE
         PRINT USING "    ## "; SingolaCarta.Valore;
   END SELECT

   PRINT " di "; SingolaCarta.Seme

END SUB

