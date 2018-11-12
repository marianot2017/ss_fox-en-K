* ====================================================================
* Funciones de Seteo Dinamico de Impresora
*
* IniSetImp  = Inicializa Handles que usaran las funciones.
*                         Var ImpPre con DEVICE predeterminado.
*                         Vec PRINTERS y WINDEV.
*              Retorna ''
*
* ImpAct     = Retorna string con DEVICE Actual
* 
* SetImp(St) = Setea DEVICE Indicada en St,
*              si este es nulo, setea la predeterminada.
*              Retorna .t. por exito y .f. por fracaso.
*
* TomDev(St) = Retorna DEVICE a partir del nombre pasado por St
*
* GetPrinters= Inicializa Vector PRINTERS con Nombres de Impresoras 
*                            Vector WINDEV   con DEVICE completo      
*
* =====================================================================
* --------------------------------------
Func IniSetImp
* --------------------------------------
* Inicializa Handles y Variables que usaran las funciones 
* de seteo de impresoras
*
public H_TomaImp, H_GrabImp
H_TomaImp = REGFN('GetProfileString','CCC@CI','I')
H_GrabImp = REGFN('WriteProfileString','CCC','L')
public ImpPre  && Impresora Predeterminada
ImpPre = ImpAct()
=GetPrinters()
return ''
* ----------------------------------------
Function ImpAct
* ----------------------------------------
* Retorna Impresora Actual
*
private IDEVICENAME, IDEVLEN
IDEVICENAME = REPLICATE(CHR(0), 255)
IDEVLEN = CALLFN(H_TomaImp,'windows','device','Not-Installed',@IDEVICENAME,255)
return LEFT(IDEVICENAME, IDEVLEN)
* ---------------------------------------
Function SetImp
* ---------------------------------------
* Setea Impresora Indicada en SDEVICENAME
*
parameter SDEVICENAME
private SDEVNAME,SRET
SDEVNAME = ALLTRIM(SDEVICENAME)
if empty(SDEVNAME)
   * Si la impresora esta vacia, setea la predeterminada
   SDEVNAME=ImpPre
endif    
if ImpAct()=SDEVNAME
   SRET = .t.
else    
   SRET = IIF(CALLFN(H_GrabImp,'windows','device',SDEVNAME)>0, .T., .F.)
endif   
RETURN SRET
* -------------------------------------------
Function GETPRINTERS
* -------------------------------------------
* Inicializa Vector PRINTERS con Nombres de Impresoras 
*            Vector WINDEV   con DEVICE completo      
* 
private DFOUND, FILEHANDLE
Public Array WINDEV  [20]
Public Array PRINTERS[20]
FILEHANDLE = FOPEN(GETENV('windir')+'\'+'WIN.INI')
PINST = 0
TMPS = ''
DFOUND = .F.
do WHILE  .not. FEOF(FILEHANDLE) .and.  .not. DFOUND
   TMPS = FGETS(FILEHANDLE)
   if ATC('[devices]', TMPS)>0
      DFOUND = .T.
   endif
enddo
if  .not. DFOUND
   DFOUND = .F.
   = FSEEK(FILEHANDLE, 0, 0)
   do WHILE  .not. FEOF(FILEHANDLE) .and.  .not. DFOUND
      TMPS = FGETS(FILEHANDLE)
      if ATC('[devices]', TMPS)>0
         DFOUND = .T.
      endif
   enddo
endif
if  .not. DFOUND
   = MSGBOX('No hay Impresoras Instaladas','Advertencia',48)
   = FCLOSE(FILEHANDLE)
   return
endif
DFOUND = .T.
do WHILE  .not. FEOF(FILEHANDLE) .and. DFOUND
   TMPS = ALLTRIM(FGETS(FILEHANDLE))
   if LEN(TMPS)>0
      do RESDEV
   else
      DFOUND = .F.
   endif
enddo
if PINST>0
   Dimension WINDEV  [PINST]
   Dimension PRINTERS[PINST]
endif
= FCLOSE(FILEHANDLE)
return ''
* -------------------------------------
procedure RESDEV
* -------------------------------------
* Usada por GetPrinters
*
private TMP0, OCS, DEVTYPE, PORT, I, DEVNAME
OCS = OCCURS(CHR(44), TMPS)
DEVNAME = LEFT(TMPS, AT('=', TMPS)-1)
TMP0 = LEFT(TMPS, AT(CHR(44), TMPS)-1)
DEVTYPE = STUFF(TMP0, AT('=', TMP0), 1, CHR(44))
TMP0 = TMPS
for I = 1 TO OCS
   PINST = PINST+1
   TMP0 = SUBSTR(TMP0, AT(CHR(44), TMP0)+1)
   PORT = IIF(I=OCS, TMP0, LEFT(TMP0, AT(CHR(44), TMP0)-1))
   WINDEV[ PINST] = DEVTYPE+','+PORT
   *PRINTERS[ PINST] = DEVNAME+' en '+PORT
   PRINTERS[ PINST] = DEVNAME
   *if WINDEV(PINST)=ImpPre
   *   PRINTERS[ PINST] = PRINTERS(PINST)+' (Predeterminada)'
   *endif
endfor
return
* -------------------------------
Function TomDev
* -------------------------------
* Retorna DEVICE completo a partir del nombre 
*
para NomImp
NomImp=alltrim(NomImp)
priv Tind,Tret,Ti,Tnom
do GetPrinters
Texa=set('exact')
set exact on
Tind=ascan(Printers,NomImp)
set exact &Texa
if empty(Tind)
   Ti=ascan(windev,ImpAct())  && Busco nombre de impresora actual
   if empty(Ti)
       Tnom=ImpPre
       Tret=ImpPre       
   else
       Tnom=printers[Ti] 
       Tret = ImpAct()
   endif
   = MSGBOX('No existe impresora "'+NomImp+'"';
             +CHR(13)+chr(13);
             +'Se Imprimira por "'+Tnom+'"','Advertencia',48)
else
   Tret = windev[Tind]
endif   
return Tret
