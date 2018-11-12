! ts prg\*.prg 'set step on'

set procedure to k:\ss_fox\library
set library to foxtools.fll
close data
w_dire='\gw\impresio\'
cant=adir(w_file,w_dire+'*.frx')
wait wind 'Se encontraron '+str(cant,5)+' reports'
for i=1 to cant
	w_nomb=w_dire+w_file(i,1)
	use &w_nomb.
	wait wind "1) Verifica Modo report: "+w_nomb nowait
*	locate for empty(mode) and (objtype=5 or objtype=8) and platform='WINDOWS'
	locate for 'ORIGINAL'$upper(expr) and platform='WINDOWS'
	if found()
		*		brows for empty(mode) and (objtype=5 or objtype=8)

		wait wind '1) Texto original: '+w_nomb+chr(13)
*		wait wind '1) Verifica Modo Report: '+w_nomb+chr(13)
*		if sino(' Arregla Mode (S/N)','N') ='S'
*			replace mode with 1 for empty(mode) and (objtype=5 or objtype=8) and platform='WINDOWS'
*		endif
		use
		if lastkey()=27
			exit
		endif
	else
		use
	endif
endfor

close data
return

w_dire='\gw\o_pago\'
cant=adir(w_file,w_dire+'*.frx')
wait wind 'Se encontraron '+str(cant,5)+' reports'
for i=1 to cant
	w_nomb=w_dire+w_file(i,1)
	use &w_nomb.
	wait wind "1) Verifica Modo report: "+w_nomb nowait
	locate for empty(mode) and (objtype=5 or objtype=8) and platform='WINDOWS'
	if found()
		*		brows for empty(mode) and (objtype=5 or objtype=8)

		wait wind '1) Verifica Modo Report: '+w_nomb+chr(13)
		if sino(' Arregla Mode (S/N)','N') ='S'
			replace mode with 1 for empty(mode) and (objtype=5 or objtype=8) and platform='WINDOWS'
		endif
		use
		if lastkey()=27
			exit
		endif
	else
		use
	endif
endfor
return


close data
use 000\gvf022 orde d22tipo alias f22 in 0
sele f22
=seek('30','f22')
scatt memva
skip in f22
do while f22.d22tipo='30' and !eof('f22')
	if val(m.d22nume)+1!=val(f22.d22nume)
		wait wind 'Libre : '+str(val(m.d22nume)+1,8)
	endif
	scatter memvar
	skip in f22
enddo
return

close data
use 010\gvf038 orde d38tipo alias f38 in 0
sele f38
do while !eof('f38')
	scatter memvar
	skip in f38
	if !eof('f38')
		do while m.d38tipo+m.d38loca+m.d38nume+m.d38prov=f38.d38tipo+f38.d38loca+f38.d38nume+f38.d38prov and !eof('f38')
			delete
			skip in f38
		enddo
	endif
enddo
return


set procedure to h:\ss_fox\library
set library to foxtools.fll
close data
w_dire='\gw\impresio\'
cant=adir(w_file,w_dire+'*.frx')
wait wind 'Se encontraron '+str(cant,5)+' reports'
for i=1 to cant
	w_nomb=w_dire+w_file(i,1)
	use &w_nomb.
	wait wind "1) Verifica Modo report: "+w_nomb nowait
	locate for 'f20.d20'$expr and platform='WINDOWS'
	if found()
		brows for 'f20.d20'$expr and platform='WINDOWS'
		USE

		if lastkey()=27
			exit
		endif
	else
		use
	endif
endfor
return

** Clientes a recuperar eliminados **

** 00234	inscripto
** 00235	inscripto
** 00297	inscripto
** 00280	inscripto
** 00297	inscripto
** 01000	consumidor

** Correr en  Logracom para corregir los Productos que eliminaron **

close data
use 000\gvf006 orde d6prod alias f06
skip 
scatte memvar
m.d6dete=''
use 000\gvf018 orde d18fech alias f18 in 0
sele f18
set rela to d18prod into f06
do while !eof('f18')
	m.d6prod=f18.d18prod
	m.d6desc=f18.d18desc
	m.d6rcve=f18.d18reco
	m.d6gru1=f18.d18rubr
	m.d6gru2=f18.d18srub
	m.d6pre1=f18.d18prun
	m.d6acti='N'
	if eof('f06') and !empty(f18.d18prun) and !empty(f18.d18prod)
	   sele f06
	   append blank
	   gather memvar
	endif
	skip in f18
enddo
return


SCATTE MEMVAR
SKIP
DO WHILE !EOF()
	if m.d6dete=d6dete
		brows
	endif
	scatter memvar
	skip
enddo

RETURN

=getvol('c:\')


*********************************
* Codigo en visual fox
*-----------------------------------------------
FUNCTION GetVol(lpRoot)
*-----------------------------------------------
* Nuestra información del volumen
* USO: GetVol("C:\")
* PARAMETRO: lpRoot = LetraDrive + ":\"
*-----------------------------------------------
LOCAL lnRet, lcString, lpVolName, ;
  nVolSize, lpVolNumber, ;
  lpMaxComp, lpFlags, ;
  lpFSName, nFSSize

IF EMPTY(lpRoot)
  lpRoot = "d:\"
ENDIF
lpVolName = SPACE(256)
nVolSize = 256
lpVolNumber = 0
lpMaxComp = 256
lpFlags = 0
lpFSName = SPACE(256)
nFSSize = 256

DECLARE INTEGER GetVolumeInformation ;
        IN Win32API AS GetVolInfo ;
  STRING  @lpRoot, ;
  STRING  @lpVolName, ;
  INTEGER nVolSize, ;
  INTEGER @lpVolNumber, ;
  INTEGER @lpMaxComp, ;
  INTEGER @lpFlags, ;
  STRING  @lpFSName, ;
  INTEGER nFSSize

lnRet=GetVolInfo(@lpRoot, @lpVolName, ;
  nVolSize, @lpVolNumber, ;
  @lpMaxComp, @lpFlags, ;
  @lpFSName, nFSSize)

IF lnRet > 0
  lcString = "Drive name: " + ;
    ALLT(lpRoot)+CHR(13)+ ;
    "Vol name: " + ;
    LEFT(ALLT(lpVolName),LEN(ALLT(lpVolName))-1)+CHR(13)+ ;
    "Max #/chars in vol name: " + ;
    ALLT(STR(nVolSize))+CHR(13)+ ;
    "Vol Serial #: " + ;
    ALLT(STR(lpVolNumber))+CHR(13)+ ;
    "Max #/chars in dir/file names: " + ;
    ALLT(STR(lpMaxComp))+CHR(13)+ ;
    "File Sys Flags: " + ;
    ALLT(STR(lpFlags))+CHR(13)+ ;
    "File Sys type: " + ;
    LEFT(ALLT(lpFSName),LEN(ALLT(lpFSName))-1)+CHR(13)+ ;
    "File Sys Name Size: " + ;
    ALLT(STR(nFSSize))
ELSE
  lcString = "No se pudo ver información"
ENDIF
=MESSAGEBOX(lcString, "Información del volumen")
RETURN ""
ENDFUNC

