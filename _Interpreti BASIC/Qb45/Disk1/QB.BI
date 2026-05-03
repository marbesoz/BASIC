'***
' QB.BI - File da includere di supporto routine linguaggio assembler
'
'       Copyright <C> 1987-1989 Microsoft Corporation
'
' Scopo:
'       Questo file da includere definisce i tipi e include le
'       istruzioni DECLARE per le routine in linguaggio assembler
'       ABSOLUTE, INTERRUPT, INTERRUPTX, INT86OLD, e INT86XOLD.
'
'***************************************************************************
'
' Definisce il tipo necessario per INTERRUPT
'
TYPE RegType
     ax    AS INTEGER
     bx    AS INTEGER
     cx    AS INTEGER
     dx    AS INTEGER
     bp    AS INTEGER
     si    AS INTEGER
     di    AS INTEGER
     flags AS INTEGER
END TYPE
'
' Definisce il tipo necessario per INTERUPTX
'
TYPE RegTypeX
     ax    AS INTEGER
     bx    AS INTEGER
     cx    AS INTEGER
     dx    AS INTEGER
     bp    AS INTEGER
     si    AS INTEGER
     di    AS INTEGER
     flags AS INTEGER
     ds    AS INTEGER
     es    AS INTEGER
END TYPE
'
'                 Istruzioni DECLARE per le 5 routine
'                 -----------------------------------
'
' Genera un interrupt software, caricando tutti i registri tranne quelli
' di segmento
'
DECLARE SUB INTERRUPT (intnum AS INTEGER, inreg AS RegType, outreg AS RegType)
'
' Genera un interrupt software, caricando tutti i registri
'
DECLARE SUB INTERRUPTX (intnum AS INTEGER, inreg AS RegTypeX, outreg AS RegTypeX)
'
' Chiama una routine a un indirizzo assoluto.
' NOTA: Se la routine chiamata richiede parametri, questi vanno aggiunti
'       all'istruzione DECLARE prima del parametro dato.
'
DECLARE SUB ABSOLUTE (address AS INTEGER)
'
' Genera un interrupt software, caricando tutti i registri tranne quelli
' di segmento (versione vecchia)
'
DECLARE SUB INT86OLD (intnum AS INTEGER, inarray() AS INTEGER, outarray() AS INTEGER)
'
' Genera un interrupt software, caricando tutti i registri (versione vecchia)
'
DECLARE SUB INT86XOLD (intnum AS INTEGER, inarray() AS INTEGER, outarray() AS INTEGER)
'

