DECLARE SUB Suono (Freq!, Lung!)
'*** Programma esempio per l'istruzione OUT
'
' Esegue una scala con l'altoparlante e il temporizzatore
CONST SEMIBREVE = 5000!, SEMIMINIMA = SEMIBREVE / 4!
CONST Do1 = 523!, Re = 587.33, Mi = 659.26, Fa = 698.46, Sol = 783.99
CONST La = 880!, Si = 987.77, Do2 = 1046.5
CALL Suono(Do1, SEMIMINIMA): CALL Suono(Re, SEMIMINIMA)
CALL Suono(Mi, SEMIMINIMA): CALL Suono(Fa, SEMIMINIMA)
CALL Suono(Sol, SEMIMINIMA): CALL Suono(La, SEMIMINIMA)
CALL Suono(Si, SEMIMINIMA): CALL Suono(Do2, SEMIBREVE)

SUB Suono (Freq!, Lung!) STATIC
'Le porte 66, 67, e 97 controllano il temporizzatore e l'altoparlante
'
'Divide la frequenza del temporizzatore per la frequenza del suono
'per ottenere il numero di "clic" che il temporizzatore deve produrre
    Clic% = CINT(1193280! / Freq!)
    ByteBas% = Clic% AND &HFF
    ByteAlt% = Clic% \ 256
'Avverte il temporizzatore dei dati in arrivo
    OUT 67, 182
'Invia il conteggio al temporizzatore
    OUT 66, ByteBas%
    OUT 66, ByteAlt%
'Attiva l'altoparlante impostando i bit 0 e 1 del chip PPI.
    AttAlt% = INP(97) OR &H3
    OUT 97, AttAlt%
'Lascia l'altoparlante acceso
    FOR I! = 1 TO Lung!: NEXT I!
'Disattiva l'altoparlante.
    DisattAlt% = INP(97) AND &HFC
    OUT 97, DisattAlt%
END SUB

