*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ Sys.Info ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ Solver Systems      ฤฤฤฤ
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H Programa        : SSP001  Eleccion de Usuario 
*-H	Release			: 02
*-H Fecha de inicio : 
*-H Fecha de fin    :
*-H
*-H Updates         :
*-H
*-H  Fecha       Programmer      Comentarios
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PRIVATE ALL LIKE w_*
PUBLIC p_user
** Salvado de estados anteriores 

push key clear      && Salva estados de teclas 
push menu _msysmenu && Salva estado de menu

w_curobj=_curobj      && Salva numero de objeto en el read activo
w_alan =alias()       && Salva alias vigente al llamado del programa 
w_wind =wontop()      && Salva ventana vigente al llamado del programa 

** Variables internas

w_prog=program()
w_rdlevel=rdlevel()

&& R.01b Mariano
*ps_user=space(10)
if p_par2='NO'
	ps_user=space(10)
else
	ps_user=left(p_par2+space(10),10)
	keyboard '{enter}'
endif
&& R.01e Mariano

p_user=space(10)
p_pasw=space(10)

fieldvec[1]='S01'
fieldvec[2]='S03'

use ssf001 in 0 alias s01 order 1 
use ssf003 in 0 alias s03 order 1 

if neterr()

      pop key  
      pop menu _msysmenu

      if .not. empty(w_wind)
         acti wind (w_wind)
      endif

      close data
      =mquit()

endif

sele s01

set skip of menu _msysmenu .t.

do while .t.
   do sss001u.spr   

   if lastkey()=p_esc 
      s_sino=2 
      if sino('Desea Abandonar el Sistema ? ') ='N'
         loop
      endif   
      =Mquit()
   endif
   
   exit 
enddo

*p_mean=s01->d1mean
p_mean=1

pop key 
pop menu _msysmenu

if .not. empty(w_wind)
   acti wind (w_wind)
endif
        
*close data
sele s01
use
sele s03
use

if .not. empty(w_alan)
    sele (w_alan)
endif

return

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
    FUNCTION user01u
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

w_retu=.t.

do case 

   case upper(varread())='PS_USER'

      if .not. seek(ps_user)

         wait ' Usuario no Existe ' wind 
         w_retu=.f.

      endif
      
      if ps_user='SUPERVISOR'

         wsuper=.T.
         p_user=ps_user

      else

         wsuper=.F.
         if .not. seek(s01.d1perf,'s03')

            wait ' Perfil no Existe ' wind 
            w_retu=.f.

         else

            p_user=s01.d1perf

         endif

      endif   
                 
   case upper(varread())='P_PASW'

*      if trim(d1pasw)==trim(p_pasw)	&& R.02 Mariano
      if trim(d1pasw)==trim(encript(p_pasw,3))	&& R.02 Mariano

         clear read

      else 

         wait ' Clave de acceso erronea, reintente ' wind  nowait

      endif   
      
endcase

return w_retu      
