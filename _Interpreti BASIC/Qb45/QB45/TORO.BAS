' ======================================================================
'                                TORO
'   Questo programma disegna un toro geometrico. Il programma legge input
'   per stabilire vari parametri del toro, controlla la configurazione
'   corrente del sistema e prende misure atte a impostare la modalit…
'   iniziale ottimale.
' ======================================================================

DEFINT A-Z
DECLARE SUB ProvaConfig ()
DECLARE SUB ImpostaPalette ()
DECLARE SUB DefToro ()
DECLARE SUB CalcToro (T() AS ANY)
DECLARE SUB ColoriToro (T() AS ANY)
DECLARE SUB OrdinaToro (Basso, Alto)
DECLARE SUB DisegnaToro (T() AS ANY, Indice())
DECLARE SUB DisegnaCasella (T AS ANY)
DECLARE SUB RuotaToro (Primo)
DECLARE SUB Ritardo (Secondi!)
DECLARE SUB ContaCaselle (T1, T2)
DECLARE SUB Messaggio (Testo$)
DECLARE SUB ImpostaConfig (modalita)
DECLARE FUNCTION Interno (T AS ANY)
DECLARE FUNCTION GradiInRad! (Gradi)
DECLARE FUNCTION ScalaVal (LimInf, LimSup, Corrente, Inc)

' Costanti generali
CONST PIGRECO = 3.14159
CONST VERO = -1, FALSO = 0
CONST SFON = 0
CONST RIGAT = 24, COLONT = 60

' Flag per la rotazione
CONST CASUALE = -1
CONST INIZIO = 0
CONST CONTINUA = 1

' Costanti per la modalit… schermo ottimale
CONST VGA = 12
CONST MCGA = 13
CONST EGA256 = 9
CONST EGA64 = 8
CONST MONO = 10
CONST HERC = 3
CONST CGA = 1

' Tipo definito dall'utente per le caselle che compongono il toro
TYPE Casella
   x1    AS SINGLE
   x2    AS SINGLE
   x3    AS SINGLE
   x4    AS SINGLE
   y1    AS SINGLE
   y2    AS SINGLE
   y3    AS SINGLE
   y4    AS SINGLE
   z1    AS SINGLE
   xc    AS SINGLE
   yc    AS SINGLE
   ColoreT AS INTEGER
END TYPE

' Tipo definito dall'utente per i dati sulla modalit… schermo
TYPE Config
   Schermo     AS INTEGER
   colori      AS INTEGER
   Attributi   AS INTEGER
   PixX        AS INTEGER
   PixY        AS INTEGER
   COLONT      AS INTEGER
   RIGAT       AS INTEGER
END TYPE
                                       
DIM VC AS Config

' Tipo definito dall'utente per i dati sul toro corrente
TYPE TORO
   Pann       AS INTEGER
   Sett       AS INTEGER
   Spess      AS SINGLE
   GradiX     AS INTEGER
   GradiY     AS INTEGER
   Bord       AS STRING * 2
   Ritardo    AS SINGLE
END TYPE

DIM TOR AS TORO, Mass AS INTEGER

' Una palette di colori
DIM Pal(0 TO 300) AS LONG

' Variabili di errore per controllare il tipo dello schermo
DIM RigheIniz AS INTEGER, ModalOtt AS INTEGER, Disponibile AS STRING

' Il programma a livello di modulo inizia qui
  
   ' Inizializza i valori predefiniti
   TOR.Spess = 3: TOR.Bord = "S"
   TOR.Pann = 8: TOR.Sett = 14
   TOR.GradiX = 60: TOR.GradiY = 165

   ' Ottiene la configurazione ottimale vi imposta la modalit…
   ' grafica iniziale
   ProvaConfig
   VC.Schermo = ModalOtt
             
   DO WHILE VERO           ' Ciclo perenne (si esce dall'interno di una SUB)
          
      ' Sollecita dall'utente e legge i parametri del toro
      DefToro
     
      ' Dimensiona le matrici dinamicamente
      DO
         Tmp = TOR.Pann
         Mass = TOR.Pann * TOR.Sett
                   
         ' La matrice degli indici
         REDIM Indice(0 TO Mass - 1) AS INTEGER
         ' Attiva la gestione di errori per insufficienza di memoria
         ON ERROR GOTO ErrMem
         ' La matrice delle caselle
         REDIM T(0 TO Mass - 1) AS Casella
         ON ERROR GOTO 0
      LOOP UNTIL Tmp = TOR.Pann
     
      ' Inizializza la matrice degli indici
      FOR Cas = 0 TO Mass - 1
         Indice(Cas) = Cas
      NEXT

      ' Calcola le coordinate dei punti delle caselle del toro
      Messaggio "Calcolo"
      CalcToro T()
                 
      ' Colora le caselle del toro.
      ColoriToro T()
                
      ' Ordina le caselle secondo le rispettive "distanze" dallo schermo
      Messaggio "Ordinamento"
      OrdinaToro 0, Mass - 1
         
      ' Imposta la modalit… dello schermo
      SCREEN VC.Schermo
      
      ' Crea una palette di colori
      ImpostaPalette
      
      ' Imposta una finestra logica a spessore variabile col centro a 0, il
      ' senso positivo in alto e a destra, e il negativo in basso e a sinistra
      WINDOW (-(TOR.Spess + 1), -(TOR.Spess + 1))-(TOR.Spess + 1, TOR.Spess + 1)
         
      ' Disegna e colora le caselle dalla pi— lontana alla pi— vicina
      DisegnaToro T(), Indice()
     
      ' Fa ruotare il toro facendo scalare i colori della palette
      DO WHILE INKEY$ = ""
         Ritardo (TOR.Ritardo)
         RuotaToro CONTINUA
      LOOP
      SCREEN 0
      WIDTH 80
   LOOP
  
   ' Ripristina le righe originarie
   WIDTH 80, RigheIniz

END

' Gestione di errore per rendere indipendente lo schermo del toro
ErrVideo:
   SELECT CASE ModalOtt     ' Continua a provare finch‚ uno non funziona
      CASE VGA
         ModalOtt = MCGA
         Disponibile = "12BD"
      CASE MCGA
         ModalOtt = EGA256
         Disponibile = "12789"
      CASE EGA256
         ModalOtt = CGA
         Disponibile = "12"
      CASE CGA
         ModalOtt = MONO
         Disponibile = "A"
      CASE MONO
         ModalOtt = HERC
         Disponibile = "3"
      CASE ELSE
         PRINT "Impossibile eseguire Toro: manca il supporto grafico."
         END
   END SELECT
   RESUME

' Trap to detect 64K EGA
EGAErr:
   ModalOtt = EGA64
   Disponibile = "12789"
   RESUME NEXT

' Trap to detect insufficient memory for large Torus
ErrMem:
   LOCATE 22, 1
   PRINT "Out of memory"
   PRINT "Reducing panels from"; TOR.Pann; "to"; TOR.Pann - 1
   PRINT "Reducing sections from"; TOR.Sett; "to"; TOR.Sett - 1;
   DO WHILE INKEY$ = "": LOOP
   TOR.Pann = TOR.Pann - 1
   TOR.Sett = TOR.Sett - 1
   RESUME NEXT

' Trap to determine initial number of rows so they can be restored
RowErr:
   IF RigheIniz = 50 THEN
      RigheIniz = 43
      RESUME
   ELSE
      RigheIniz = 25
      RESUME NEXT
   END IF

DEFSNG A-Z
' =========================== CalcToro ================================
'   Calcola le coordinate x e y di ogni casella.
' ======================================================================
'
SUB CalcToro (T() AS Casella) STATIC
SHARED TOR AS TORO, Mass AS INTEGER
DIM SettX AS INTEGER, PannY AS INTEGER
  
   ' Calcola il seno e coseno degli angoli di rotazione
   RotX = GradiInRad(TOR.GradiX)
   RotY = GradiInRad(TOR.GradiY)
   CRotX = COS(RotX)
   SRotX = SIN(RotX)
   CRotY = COS(RotY)
   SRotY = SIN(RotY)

   ' Calcola l'angolo da incrementare tra una casella e la successiva.
   IncX = 2 * PIGRECO / TOR.Sett
   IncY = 2 * PIGRECO / TOR.Pann
  
   ' Prima calcola il primo punto, che servir… da riferimento per i punti
   ' successivi, e che va calcolato a parte perch‚ Š sia all'inizio che
   ' alla fine della giunzione centrale.
   PrimaY = (TOR.Spess + 1) * CRotY
                                 
   ' Il primo punto Š x1 della sezione 0, panello 0   last     0
   T(0).x1 = PrimaY                             ' +------+------+
   ' e x2 dell'ultima sezione, panello 0        ' |      |      | last
   T(TOR.Sett - 1).x2 = PrimaY                  ' |    x3|x4    |
   ' e x3 dell'ultima sezione, ultimo pannello  ' +------+------+
   T(Mass - 1).x3 = PrimaY                      ' |    x2|x1    |  0
   ' e x4 della sezione 0, ultimo panello       ' |      |      |
   T(Mass - TOR.Sett).x4 = PrimaY               ' +------+------+
   ' Un procedimento simile Š usato per l'assegnazione di tutti i punti
  
   ' Il punto Y iniziale Š 0 (il centro)
   T(0).y1 = 0
   T(TOR.Sett - 1).y2 = 0
   T(Mass - 1).y3 = 0
   T(Mass - TOR.Sett).y4 = 0
                          
   ' Un'unica coordinata z serve per l'ordinamento, le altre tre
   ' vengono ignorate
   T(0).z1 = -(TOR.Spess + 1) * SRotY
  
   ' Cominciando dal primo punto prosegue intorno al toro seguendo la
   ' giunzione centrale, assegnando punti a ogni sezione. La giunzione va
   ' calcolata a parte perch‚ Š sia all'inizio che alla fine di ogni sezione.
   FOR SettX = 1 TO TOR.Sett - 1
       
      ' Gli elementi X, Y, e Z dell'equazione
      sx = (TOR.Spess + 1) * COS(SettX * IncX)
      sy = (TOR.Spess + 1) * SIN(SettX * IncX) * CRotX
      sz = (TOR.Spess + 1) * SIN(SettX * IncX) * SRotX
      ssx = (sz * SRotY) + (sx * CRotY)
  
      T(SettX).x1 = ssx
      T(SettX - 1).x2 = ssx
      T(Mass - TOR.Sett + SettX - 1).x3 = ssx
      T(Mass - TOR.Sett + SettX).x4 = ssx
                                         
      T(SettX).y1 = sy
      T(SettX - 1).y2 = sy
      T(Mass - TOR.Sett + SettX - 1).y3 = sy
      T(Mass - TOR.Sett + SettX).y4 = sy
                                         
      T(SettX).z1 = (sz * CRotY) - (sx * SRotY)
   NEXT
  
   ' Ora inizia dalla prima giuntura di pannelli e assegna punti a ogni
   ' sezione di ogni pannello. Il ciclo esterno assegna il punto iniziale
   ' del pannello, che va calcolato a parte perch‚ Š sia all'inizio che
   ' alla fine della giunzione di pannelli.
   FOR PannY = 1 TO TOR.Pann - 1
        
      ' Gli elementi X, Y, e Z dell'equazione
      sx = TOR.Spess + COS(PannY * IncY)
      sy = -SIN(PannY * IncY) * SRotX
      sz = SIN(PannY * IncY) * CRotX
      ssx = (sz * SRotY) + (sx * CRotY)
       
      ' Assegna i punti X a ogni pannello
      ' Anello corrente, lato corrente
      T(TOR.Sett * PannY).x1 = ssx
      ' Anello corrente meno 1, lato successivo
      T(TOR.Sett * (PannY + 1) - 1).x2 = ssx
      ' Anello corrente meno 1, lato precedente
      T(TOR.Sett * PannY - 1).x3 = ssx
      ' Anello corrente, lato precedente
      T(TOR.Sett * (PannY - 1)).x4 = ssx
                                          
      ' Assegna i punti Y a ogni pannello
      T(TOR.Sett * PannY).y1 = sy
      T(TOR.Sett * (PannY + 1) - 1).y2 = sy
      T(TOR.Sett * PannY - 1).y3 = sy
      T(TOR.Sett * (PannY - 1)).y4 = sy
                                        
      ' Assegna l punto Z a ogni pannello
      T(TOR.Sett * PannY).z1 = (sz * CRotY) - (sx * SRotY)
       
      ' Il ciclo interno assegna punti a ogni anello (tranne il primo)
      ' del lato corrente.
      FOR SettX = 1 TO TOR.Sett - 1
                                                 
         ' Visualizza la sezione e il pannello
         ContaCaselle SettX, PannY
                                                            
         ty = (TOR.Spess + COS(PannY * IncY)) * SIN(SettX * IncX)
         tz = SIN(PannY * IncY)
         sx = (TOR.Spess + COS(PannY * IncY)) * COS(SettX * IncX)
         sy = ty * CRotX - tz * SRotX
         sz = ty * SRotX + tz * CRotX
         ssx = (sz * SRotY) + (sx * CRotY)
          
         T(TOR.Sett * PannY + SettX).x1 = ssx
         T(TOR.Sett * PannY + SettX - 1).x2 = ssx
         T(TOR.Sett * (PannY - 1) + SettX - 1).x3 = ssx
         T(TOR.Sett * (PannY - 1) + SettX).x4 = ssx
                                                          
         T(TOR.Sett * PannY + SettX).y1 = sy
         T(TOR.Sett * PannY + SettX - 1).y2 = sy
         T(TOR.Sett * (PannY - 1) + SettX - 1).y3 = sy
         T(TOR.Sett * (PannY - 1) + SettX).y4 = sy
                                                            
         T(TOR.Sett * PannY + SettX).z1 = (sz * CRotY) - (sx * SRotY)
      NEXT
   NEXT
   ' Cancella il messaggio
   ContaCaselle -1, -1

END SUB

DEFINT A-Z
' =========================== ColoriToro ===============================
'   Assegna gli attributi dei colori ad ogni casella.
' ======================================================================
'
SUB ColoriToro (T() AS Casella) STATIC
SHARED VC AS Config, Mass AS INTEGER
        
   ' Salta il primo e l'ultimo attributo
   UltAtr = VC.Attributi - 2
   Atr = 1

   ' Cicla per gli attributi finch‚ non ha finito tutte le caselle
   FOR Cas = 0 TO Mass - 1
      IF (Atr >= UltAtr) THEN
         Atr = 1
      ELSE
         Atr = Atr + 1
      END IF
      T(Cas).ColoreT = Atr
   NEXT

END SUB

' ============================ ContaCaselle ==============================
'   Visualizza il numero delle caselle in via di calcolo o di ordinamento.
' ========================================================================
'
SUB ContaCaselle (T1, T2) STATIC

   ' Cancella il precedente
   LOCATE RIGAT - 1, COLONT: PRINT SPACE$(19);
   ' Se positivo, visualizza - i valori negativi servono per cancellare
   IF T1 > 0 AND T2 > 0 THEN
      LOCATE RIGAT - 1, COLONT
      PRINT "Casella ";
      PRINT USING " ###"; T1;
      PRINT USING " ###"; T2;
   END IF

END SUB

' ============================ DefToro =============================
'   Definisce gli attributi del Toro secondo l'input dell'utente, la
'   configurazione del video, e la modalit… corrente dello schermo.
' ======================================================================
'
SUB DefToro STATIC
SHARED VC AS Config, TOR AS TORO, Disponibile AS STRING

' Costanti per i codici dei tasti e per la posizione delle colonne
CONST INVIO = 13, ESC = 27
CONST GIU = 80, SU = 72, SINISTRA = 75, DESTRA = 77
CONST COL1 = 18, COL2 = 52, RIGA = 9

   ' Display key instructions
   LOCATE 1, COL1
   PRINT "SU'....... Spostarsi al campo successivo"
   LOCATE 2, COL1
   PRINT "GIU'...... Spostarsi al campo precedente"
   LOCATE 3, COL1
   PRINT "SINISTRA .......... Incrementa il valore"
   LOCATE 4, COL1
   PRINT "DESTRA ............ Decrementa il valore"
   LOCATE 5, COL1
   PRINT "INVIO ..... Inizia con i valori correnti"
   LOCATE 6, COL1
   PRINT "ESC ............... Termina il programma"

   ' Blocca il cursore
   LOCATE RIGA, COL1, 1, 1, 12
   ' Visualizza i campi
   LOCATE RIGA, COL1: PRINT "Spessore";
   LOCATE RIGA, COL2: PRINT USING "[ # ]"; TOR.Spess;
 
   LOCATE RIGA + 2, COL1: PRINT "Pannelli per Settore";
   LOCATE RIGA + 2, COL2: PRINT USING "[ ## ]"; TOR.Pann;
  
   LOCATE RIGA + 4, COL1: PRINT "Settori nel Toro";
   LOCATE RIGA + 4, COL2: PRINT USING "[ ## ]"; TOR.Sett;
 
   LOCATE RIGA + 6, COL1: PRINT "Inclinazione orizzontale";
   LOCATE RIGA + 6, COL2: PRINT USING "[ ### ]"; TOR.GradiX;
  
   LOCATE RIGA + 8, COL1: PRINT "Inclinazione verticale";
   LOCATE RIGA + 8, COL2: PRINT USING "[ ### ]"; TOR.GradiY;
  
   LOCATE RIGA + 10, COL1: PRINT "Caselle Bordate";
   LOCATE RIGA + 10, COL2: PRINT USING "[ & ] "; TOR.Bord;
 
   LOCATE RIGA + 12, COL1: PRINT "Modalit… Schermo";
   LOCATE RIGA + 12, COL2: PRINT USING "[ ## ]"; VC.Schermo

   ' Salta la 10a riga se c'Š un valore solo
   IF LEN(Disponibile$) = 1 THEN Campi = 10 ELSE Campi = 12
 
   ' Aggiorna le entrate e la posizione a seconda dei tasti premuti
   DO
      ' Mette il cursore sul campo
      LOCATE RIGA + Cmp, COL2 + 2
      ' Ottiene il valore del tasto; se Š un codice esteso elimina
      ' il carattere nullo
      DO
        K$ = INKEY$
      LOOP WHILE K$ = ""
      Tasto = ASC(RIGHT$(K$, 1))

      SELECT CASE Tasto
         CASE ESC
            ' Termina il programma
            CLS : END
         CASE SU, GIU
            ' Aggiorna la posizione del campo
            IF Tasto = GIU THEN Inc = 2 ELSE Inc = -2
            Cmp = ScalaVal(0, Campi, Cmp, Inc)
         CASE DESTRA, SINISTRA
            ' Aggiorna il valore del campo
            IF Tasto = DESTRA THEN Inc = 1 ELSE Inc = -1
            SELECT CASE Cmp
               CASE 0
                  ' Spessore
                  TOR.Spess = ScalaVal(1, 9, INT(TOR.Spess), Inc)
                  PRINT USING "#"; TOR.Spess
               CASE 2
                  ' Pannelli
                  TOR.Pann = ScalaVal(6, 20, TOR.Pann, Inc)
                  PRINT USING "##"; TOR.Pann
               CASE 4
                  ' Settori
                  TOR.Sett = ScalaVal(6, 20, TOR.Sett, Inc)
                  PRINT USING "##"; TOR.Sett
               CASE 6
                  ' Inclinazione orizontale
                  TOR.GradiX = ScalaVal(0, 345, TOR.GradiX, (15 * Inc))
                  PRINT USING "###"; TOR.GradiX
               CASE 8
                  ' Inclinazione verticale
                  TOR.GradiY = ScalaVal(0, 345, TOR.GradiY, (15 * Inc))
                  PRINT USING "###"; TOR.GradiY
               CASE 10
                  ' Bordi
                  IF VC.Attributi > 2 THEN
                     IF TOR.Bord = "S" THEN
                        TOR.Bord = "No"
                     ELSE
                        TOR.Bord = "S"
                     END IF
                  END IF
                  PRINT TOR.Bord
               CASE 12
                  ' Modalit… schermo disponibili
                  I = INSTR(Disponibile$, HEX$(VC.Schermo))
                  I = ScalaVal(1, LEN(Disponibile$), I, Inc)
                  VC.Schermo = VAL("&h" + MID$(Disponibile$, I, 1))
                  PRINT USING "##"; VC.Schermo
               CASE ELSE
            END SELECT
         CASE ELSE
      END SELECT
   ' Imposta i dati di configurazione per la modalit… grafica
   ImpostaConfig VC.Schermo
   ' Disegna il toro se Š stato premuto INVIO
   LOOP UNTIL Tasto = INVIO
 
   ' Toglie il cursore
   LOCATE 1, 1, 0
 
   ' Imposta ritardi diversi a seconda della modalit…
   SELECT CASE VC.Schermo
      CASE 1
         TOR.Ritardo = .3
      CASE 2, 3, 10, 11, 13
         TOR.Ritardo = 0
      CASE ELSE
         TOR.Ritardo = .05
   END SELECT
 
   ' Crea un nuovo seme casuale per il toro
   RANDOMIZE TIMER

END SUB

' ============================ DisegnaCasella ================================
'   Disegna una casella e la colora se vi sono pi— di due attributi e
'   se Š reperibile l'interno della casella.
' ======================================================================
'
SUB DisegnaCasella (T AS Casella) STATIC
SHARED VC AS Config, TOR AS TORO

   'Imposta il bordo
   Bordo = VC.Attributi - 1

   IF VC.Attributi = 2 THEN
      ' Disegna ed esce se la modalit… Š a due colori
      LINE (T.x1, T.y1)-(T.x2, T.y2), T.ColoreT
      LINE -(T.x3, T.y3), T.ColoreT
      LINE -(T.x4, T.y4), T.ColoreT
      LINE -(T.x1, T.y1), T.ColoreT
      EXIT SUB
   ELSE
      ' Per le altre modalit… traccia il colore del bordo
      ' (diverso da tutti i colori di casella)
      LINE (T.x1, T.y1)-(T.x2, T.y2), Bordo
      LINE -(T.x3, T.y3), Bordo
      LINE -(T.x4, T.y4), Bordo
      LINE -(T.x1, T.y1), Bordo
   END IF

   ' Prova se la casella Š abbastanza grande da essere colorata
   IF Interno(T) THEN
      'Annerire il centro per assicurare che non sia dello stesso colore
      PRESET (T.xc, T.yc)
      ' Colora la casella di nero perch‚ i colori delle caselle sottostanti
      ' non interferiscano
      PAINT STEP(0, 0), SFON, Bordo
      ' Riempie con il colore finale della casella
      PAINT STEP(0, 0), T.ColoreT, Bordo
   END IF
 
   ' Un bordo del colore dello sfondo appare come bordo; uno del colore
   ' della casella non si vede
   IF TOR.Bord = "S" THEN
      Bordo = SFON
   ELSE
      Bordo = T.ColoreT
   END IF

   ' Ridisegna con il bordo finale
   LINE (T.x1, T.y1)-(T.x2, T.y2), Bordo
   LINE -(T.x3, T.y3), Bordo
   LINE -(T.x4, T.y4), Bordo
   LINE -(T.x1, T.y1), Bordo

END SUB

' =========================== DisegnaToro ================================
'   Disegna le caselle del toro in ordine dalla pi— lontana alla pi— vicina,
'   in modo da sovrascrivere via via le parti non visibili, creando un
'   effetto tridimensionale. Notare che l'indice della casella da disegnare
'   Š in realt… l'indice di una matrice di indici, perch‚ non viene ordinata
'   la matrice delle caselle, ma una parallela matrice di indici. Riferirsi
'   a OrdinaToro per informazioni sull'ordinamento degli indici.
' ======================================================================
'
SUB DisegnaToro (T() AS Casella, Indice() AS INTEGER)
SHARED Mass AS INTEGER

   FOR Cas = 0 TO Mass - 1
      DisegnaCasella T(Indice(Cas))
   NEXT

END SUB

' ============================ GradiInRad ================================
'   Converte gradi in radianti, dato che le funzioni trigonometriche in
'   BASIC prevedono radianti.
' ======================================================================
'
FUNCTION GradiInRad! (Gradi) STATIC

   GradiInRad! = (Gradi * 2 * PIGRECO) / 360

END FUNCTION

' ============================ ImpostaConfig ===============================
'   Imposta i vari campi della variabile VC ai valori giusti, che
'   dipendono dalla modalit… e dalla configurazione corrente.
' ======================================================================
'
SUB ImpostaConfig (modalita AS INTEGER) STATIC
SHARED VC AS Config, ModalOtt AS INTEGER

   SELECT CASE modalita
      CASE 1   ' Modalit… grafica a quattro colori per CGA, EGA, VGA, o MCGA
         IF ModalOtt = CGA OR ModalOtt = MCGA THEN
            VC.colori = 0
         ELSE
            VC.colori = 16
         END IF
         VC.Attributi = 4
         VC.PixX = 319
         VC.PixY = 199
         VC.COLONT = 40
         VC.RIGAT = 25
      CASE 2   ' Modalit… grafica a due colori a media risoluzione
               ' per CGA, EGA, VGA, o MCGA
         IF ModalOtt = CGA OR ModalOtt = MCGA THEN
            VC.colori = 0
         ELSE
            VC.colori = 16
         END IF
         VC.Attributi = 2
         VC.PixX = 639
         VC.PixY = 199
         VC.COLONT = 80
         VC.RIGAT = 25
      CASE 3   ' Modalit… grafica a due colori ad alta risoluzione
               ' per Hercules
         VC.colori = 0
         VC.Attributi = 2
         VC.PixX = 720
         VC.PixY = 348
         VC.COLONT = 80
         VC.RIGAT = 25
      CASE 7   ' Modalit… grafica a 16 colori a media risoluzione
               ' per EGA o VGA
         VC.colori = 16
         VC.Attributi = 16
         VC.PixX = 319
         VC.PixY = 199
         VC.COLONT = 40
         VC.RIGAT = 25
      CASE 8   ' Modalit… grafica a 16 colori ad alta risoluzione
               ' per EGA o VGA
         VC.colori = 16
         VC.Attributi = 16
         VC.PixX = 639
         VC.PixY = 199
         VC.COLONT = 80
         VC.RIGAT = 25
      CASE 9   ' Modalit… grafica a 16 o 4 colori ad altissima risoluzione
               ' per EGA o VGA
         VC.colori = 64
         IF ModalOtt = EGA64 THEN VC.Attributi = 4 ELSE VC.Attributi = 16
         VC.PixX = 639
         VC.PixY = 349
         VC.COLONT = 80
         VC.RIGAT = 25
      CASE 10  ' Modalit… grafica a 2 colori ad alta risoluzione per EGA
               ' o VGA monocolore
         VC.colori = 0
         VC.Attributi = 2
         VC.PixX = 319
         VC.PixY = 199
         VC.COLONT = 80
         VC.RIGAT = 25
      CASE 11  ' Modalit… grafica a due colori ad altissima risoluzione
               ' per VGA o MCGA
         ' Notare che negli schermi VGA screen 11, 12, e 13, il numero di
         ' colori disponibile dipende da come vengono creati.
         VC.colori = 216
         VC.Attributi = 2
         VC.PixX = 639
         VC.PixY = 479
         VC.COLONT = 80
         VC.RIGAT = 30
      CASE 12  ' Modalit… grafica a 16 colori ad altissima risoluzione per VGA
         VC.colori = 216
         VC.Attributi = 16
         VC.PixX = 639
         VC.PixY = 479
         VC.COLONT = 80
         VC.RIGAT = 30
      CASE 13  ' Modalit… grafica a 256 colori a media risoluzione
               ' per VGA o MCGA
         VC.colori = 216
         VC.Attributi = 256
         VC.PixX = 639
         VC.PixY = 479
         VC.COLONT = 40
         VC.RIGAT = 25
      CASE ELSE
         VC.colori = 16
         VC.Attributi = 16
         VC.PixX = 0
         VC.PixY = 0
         VC.COLONT = 80
         VC.RIGAT = 25
         VC.Schermo = 0
         EXIT SUB
   END SELECT
   VC.Schermo = modalita

END SUB

' ============================ ImpostaPalette ==============================
'   Crea la palette dei colori in una matrice.
' ======================================================================
'
SUB ImpostaPalette STATIC
SHARED VC AS Config, Pal() AS LONG

   ' Crea la palette solo se l'adattatore supporta gli attributi dei colori
   IF VC.colori THEN
      SELECT CASE VC.Schermo
         CASE 1, 2, 7, 8
            ' Rosso, verde, blu, e intenso in quattro bit di un byte
            ' Bit: 0000irvb
            ' Cambiare l'ordine dei cicli FOR per cambiare la combinazione dei colori
            Indice = 0
            FOR cB = 0 TO 1
               FOR cV = 0 TO 1
                  FOR cR = 0 TO 1
                     FOR cI = 0 TO 1
                        Pal(Indice) = cI * 8 + cR * 4 + cV * 2 + cB
                        Indice = Indice + 1
                     NEXT
                  NEXT
               NEXT
            NEXT
         CASE 9
            ' EGA rosso, verde, e blu in 6 bit di un byte
            ' Le maiuscole indicano un colore intenso, le minuscole normale
            ' Bit:  00rvbRVB
            ' Cambiare l'ordine dei cicli FOR per cambiare la combinazione dei colori
            Indice = 0
            FOR cB = 0 TO 1
               FOR cV = 0 TO 1
                  FOR cR = 0 TO 1
                     FOR cRI = 0 TO 1
                        FOR cVIn = 0 TO 1
                           FOR cBI = 0 TO 1
                              Pal(Indice) = cR * 32 + cV * 16 + cB * 8 + cRI * 4 + cVIn * 2 + cBI
                              Indice = Indice + 1
                           NEXT
                        NEXT
                     NEXT
                  NEXT
               NEXT
            NEXT
         CASE 11, 12, 13
            ' colori VGA in 6 bit di 3 byte di un intero lungo
            ' Bit:  000000000 00bbbbbb 00vvvvvv 00rrrrrr
            ' Cambiare l'ordine dei cicli FOR per cambiare la combinazione
            ' dei colori; diminuire STEP ed aumentare VC.Colori per
            ' aumentarne il numero
            Indice = 0
            FOR cR = 0 TO 63 STEP 11
               FOR cB = 0 TO 63 STEP 11
                  FOR cV = 0 TO 63 STEP 11
                     Pal(Indice) = (65536 * cB) + (256 * cV) + cR
                     Indice = Indice + 1
                  NEXT
               NEXT
            NEXT
         CASE ELSE
      END SELECT
      ' Assegna i colori
      IF VC.Attributi > 2 THEN RuotaToro CASUALE
   END IF

END SUB

' ============================== Interno ================================
'   Trova un punto T.xc e T.yc teoricamente all'interno di una casella,
'   e prova se il punto Š effettivamente all'interno. A causa dei lati
'   a zigzag, il punto centrale spesso non si trova all'interno in caselle
'   molto sottili che quindi non vengono colorate; ci• potrebbe causare
'   visibili imperfezioni ai bordi del toro.
'
'   Restituisce FALSO se non trova un punto centrale interno.
' ======================================================================
'
FUNCTION Interno (T AS Casella) STATIC
SHARED VC AS Config
DIM Massimo AS SINGLE, Minimo AS SINGLE

   Bordo = VC.Attributi - 1

   ' Trova un punto interno. Siccome alcune caselle sono triangolari, il
   ' centro delle diagonali non basta. Invece per trovare il centro
   ' traccia una diagonale dal centro dell'esterno a un angolo inferiore.
   T.xc = T.x2 + ((T.x3 + (T.x4 - T.x3) / 2 - T.x2) / 2)
   T.yc = T.y2 + ((T.y3 + (T.y4 - T.y3) / 2 - T.y2) / 2)

   ' Se si trova sul bordo, Š inutile colorare
   IF POINT(T.xc, T.yc) = Bordo THEN
      Interno = FALSO
      EXIT FUNCTION
   END IF

   ' Trova il massimo e il minimo valore di Y nella casella
   Massimo = T.y1
   Minimo = T.y1
   IF T.y2 > Massimo THEN Massimo = T.y2
   IF T.y2 < Minimo THEN Minimo = T.y2
   IF T.y3 > Massimo THEN Massimo = T.y3
   IF T.y3 < Minimo THEN Minimo = T.y3
   IF T.y4 > Massimo THEN Massimo = T.y4
   IF T.y4 < Minimo THEN Minimo = T.y4

   ' Converte le coordinate in pixel
   X = PMAP(T.xc, 0)
   YS = PMAP(T.yc, 1)
   YG = YS
   Ma = PMAP(Massimo, 1)
   Mi = PMAP(Minimo, 1)
 
   ' Cerca i bordi superiore ed inferiore della casella finch‚ o li trova
   ' o supera i punti massimo e minimo.
 
   BordSup = FALSO
   BordInf = FALSO

   DO
      YS = YS - 1
      YG = YG + 1
   
      ' Cerca in alto
      IF NOT BordSup THEN
         IF POINT(T.xc, PMAP(YS, 3)) = Bordo THEN BordSup = VERO
      END IF
  
      ' Cerca in basso
      IF NOT BordInf THEN
         IF POINT(T.xc, PMAP(YG, 3)) = Bordo THEN BordInf = VERO
      END IF
                                         
      ' Se ha trovato i due bordi, il punto Š interno
      IF BordSup AND BordInf THEN
         Interno = VERO
         EXIT FUNCTION
      END IF

   LOOP UNTIL (YG > Mi) AND (YS < Ma)
   Interno = FALSO

END FUNCTION

' ============================= Messaggio ================================
'   Visualizza un messaggio di stato seguito da puntini lampeggianti.
' ======================================================================
'
SUB Messaggio (Testo$) STATIC
SHARED VC AS Config

   LOCATE RIGAT, COLONT: PRINT SPACE$(19);
   LOCATE RIGAT, COLONT
   COLOR 7       ' Bianco
   PRINT Testo$;
   COLOR 23      ' Lampeggio
   PRINT " . . .";
   COLOR 7       ' Bianco

END SUB

' ============================ OrdinaToro ===============================
'   Ordina le caselle del toro secondo il valore della coordinata Z (la
'   distanza dal piano dello schermo). Le pi— lontane vengono disegnate
'   prima, e vengono sovrascritte man mano dalle pi— vicine, in modo da
'   creare un effetto tridimensionale.
'
'   Per velocizzare al massimo l'ordinamento, viene usato l'algoritmo
'   Quick Sort. Inoltre, al posto della matrice delle caselle viene ordinata
'   una parallela matrice degli indici. Ci• complica un po' le cose, ma
'   l'ordinamento procede pi— velocemente, perch‚ invece di variabili di
'   casella (lunghe 46 byte) vengono scambiati interi di 2 byte.
' ======================================================================
'
SUB OrdinaToro (Basso, Alto)
SHARED T() AS Casella, Indice() AS INTEGER
DIM PuntoSepar AS SINGLE

   IF Basso < Alto THEN
      ' Se sono solo due, li confronta e li scambia se necessario
      ' La procedura SUB termina la ricursione a questo punto
      IF Alto - Basso = 1 THEN
         IF T(Indice(Basso)).z1 > T(Indice(Alto)).z1 THEN
            ContaCaselle Alto, Basso
            SWAP Indice(Basso), Indice(Alto)
         END IF
      ELSE
      ' Se sono pi— di due, li separa in due gruppi a caso
         IndCasuale = INT(RND * (Alto - Basso + 1)) + Basso
         ContaCaselle Alto, Basso
         SWAP Indice(Alto), Indice(IndCasuale%)
         PuntoSepar = T(Indice(Alto)).z1
         ' Mette dutti gli elementi minori di PuntoSepar in un gruppo,
         ' e tutti gli elementi maggiori di PuntoSepar nell'altro
         DO
            I = Basso: J = Alto
            ' Trova il pi— grande
            DO WHILE (I < J) AND (T(Indice(I)).z1 <= PuntoSepar)
               I = I + 1
            LOOP
            ' Trova il pi— piccolo
            DO WHILE (J > I) AND (T(Indice(J)).z1 >= PuntoSepar)
               J = J - 1
            LOOP
            ' Li scambia se necessario
            IF I < J THEN
               ContaCaselle Alto, Basso
               SWAP Indice(I), Indice(J)
            END IF
         LOOP WHILE I < J
       
         ' Ora chiama OrdinaToro ricursivamente sui due gruppi, elaborando
         ' prima il pi— corto per economizzare lo spazio nella memoria
         ContaCaselle Alto, Basso
         SWAP Indice(I), Indice(Alto)
         IF (I - Basso) < (Alto - I) THEN
            OrdinaToro Basso, I - 1
            OrdinaToro I + 1, Alto
         ELSE
            OrdinaToro I + 1, Alto
            OrdinaToro Basso, I - 1
         END IF
      END IF
   END IF

END SUB

' ============================ ProvaConfig ===============================
'   Ottiene il numero originario di righe e l'adattatore video.
' ======================================================================
'
SUB ProvaConfig STATIC
SHARED RigheIniz AS INTEGER, ModalOtt AS INTEGER, Disponibile AS STRING

   ' Presuppone un display a 50 righe e se sbaglia continua a provare
   ' finch‚ non trova il numero giusto
   RigheIniz = 50
   ON ERROR GOTO RowErr
   LOCATE RigheIniz, 1

   ' Presuppone la modalit… schermo pi— avanzata possibile
   ModalOtt = VGA
   Disponibile = "12789BCD"
   
   ON ERROR GOTO ErrVideo
   ' Continua a provare finch‚ non trova una modalit… funzionale
   SCREEN ModalOtt
   ' Se Š EGA, controlla se le pagine contano pi— di 64K
   ON ERROR GOTO EGAErr
   IF ModalOtt = EGA256 THEN SCREEN 8, , 1
   
   ON ERROR GOTO 0
   
   ' Reimposta la modalit… testo
   SCREEN 0, , 0
   WIDTH 80, 25
   
END SUB

' =============================== Ritardo ================================
'   Il ritardo Š basato sul tempo iniziale perch‚ risulti uguale su qualunque
'   processore. Notare il test per valori negativi, per evitare che Ritardo
'   si blocchi a mezzanotte al cambio dell'ora.
' ======================================================================
'
SUB Ritardo (Secondi!) STATIC
 
   TempIniz! = TIMER
   DO UNTIL (TIMER - TempIniz! > Secondi!) OR (TIMER - TempIniz! < 0)
   LOOP

END SUB

' =========================== RuotaToro ==============================
'   Fa ruotare il toro. Questo si pu• fare meglio in alcune modalit…
'   che in altre. Vi sono tre metodi:
'
'     1. Far scalare i colori della palette assegnati a ogni attributo
'     2. Disegnare, cancellare, e ridisegnare il toro (modalit… a due colori)
'     3. Alternare tra due palette (modalit… CGA e MCGA screen 1)
'
'   Notare nelle modalit… EGA e VGA screen 2, vengono usati i metodi 1 e 2.
' ======================================================================
'
SUB RuotaToro (Primo) STATIC
SHARED VC AS Config, TOR AS TORO, Pal() AS LONG, Mass AS INTEGER
SHARED T() AS Casella, Indice() AS INTEGER, ModalOtt AS INTEGER
DIM Temp AS LONG

   ' Per modalit… EGA e superiori fa scalare i colori della palette
   IF VC.colori THEN

      ' L'argomento determina se to iniziare al colore successivo,
      ' al primo colore, o a un colore a caso
      SELECT CASE Primo
         CASE CASUALE
            PrimoClr = INT(RND * VC.colori)
         CASE INIZIO
            PrimoClr = 0
         CASE ELSE
            PrimoClr = PrimoClr - 1
      END SELECT
       
      ' Imposta l'ultimo colore al minore tra l'ultimo colore possibile
      ' e l'ultima casella
      IF VC.colori > Mass - 1 THEN
         UltClr = Mass - 1
      ELSE
         UltClr = VC.colori - 1
      END IF
   
      ' Se il valore del colore Š troppo basso, lo sposta alla fine
      IF PrimoClr < 0 OR PrimoClr >= UltClr THEN PrimoClr = UltClr

      ' Imposta l'ultimo attributo
      IF VC.Attributi = 2 THEN
         ' L'ultimo per modalit… a due colori
         UltAtr = VC.Attributi - 1
      ELSE
         ' Il minore tra l'ultimo colore e il penultimo attributo
         IF UltClr < VC.Attributi - 2 THEN
            UltAtr = UltClr
         ELSE
            UltAtr = VC.Attributi - 2
         END IF
      END IF

      ' Il cicla percorre gli attributi, assegnando colori
      Appun = PrimoClr
      FOR Atr = UltAtr TO 1 STEP -1
         PALETTE Atr, Pal(Appun)
         Appun = Appun - 1
         IF Appun < 0 THEN Appun = UltClr
      NEXT

   END IF

   ' Per modalit… a due colori, cancella e ridisegna il toro
   IF VC.Attributi = 2 THEN
  
      ' Imposta tutte le caselle al colore
      FOR I = 0 TO Mass - 1
         T(I).ColoreT = Altern
      NEXT
      ' Disegna il toro
      DisegnaToro T(), Indice()
      ' Alterna tra il colore e lo sfondo
      Altern = (Altern + 1) MOD 2

   END IF

   ' Per CGA o MCGA screen 1, alterna le palette con l'istruzione COLOR
   ' (queste modalit… non riconoscono l'istruzione PALETTE)
   IF VC.Schermo = 1 AND (ModalOtt = CGA OR ModalOtt = MCGA) THEN
      COLOR , Altern
      Altern = (Altern + 1) MOD 2
      EXIT SUB
   END IF
       
END SUB

' ============================ ScalaVal =================================
'   Restituisce il valore di Corrente incrementato di Inc e scalato se
'   necessario perch‚ rientri nell'intervallo tra LimInf e LimSup.
' ======================================================================
'
FUNCTION ScalaVal (LimInf, LimSup, Corrente, Inc)

   ' Calcola il successivo valore
   Corrente = Corrente + Inc
  
   ' Gestisce i casi in cui il valore esce dall'intervallo prestabilito
   IF Corrente > LimSup THEN Corrente = LimInf
   IF Corrente < LimInf THEN Corrente = LimSup
   ScalaVal = Corrente

END FUNCTION

