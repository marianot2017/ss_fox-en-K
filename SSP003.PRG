*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ Sys.Info ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H Programa        : MANTENIMIENTO DE PERFILES
*-H
*-H Fecha de inicio : 
*-H Fecha de fin    :
*-H
*-H Actualizaciones
*-H
*-H  Fecha       Programmer      Comentarios
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PARAMETERS w_pref,w_call
PRIVATE ALL LIKE w_*

if parameters()=0
   w_call=.f.
   w_pref=''
endif

if rdlevel()=1
	p_popup=popup()
	p_bar=bar()
endif

** Salvado de estados anteriores 

push key clear      && Salva estados de teclas 
push menu _msysmenu && Salva estado de menu

w_curobj=_curobj     && Salva numero de objeto en el read activo
w_alan=alias()       && Salva alias vigente al llamado del programa 
w_wind=wontop()      && Salva ventana vigente al llamado del programa 
w_rdlevel=rdlevel()  && Salva Nro. de read activo

** Variables internas

w_prog=upper(prompt())
w_alta=.f.
w_agre=.t.
w_modi=.t.
w_recn=0


** Datos del archivo a mantener
w_title='PERFILES'
w_pfile='03'
w_alias='s'+w_pfile
w_clave='m.D3PERF'

w_modicampo=.f.	&& variable que indica si se modifico un campo del abm

if .not. w_call
   use ssf003 in 0 alias s03 order 1 

   if neterr()

      pop key  
      pop menu _msysmenu

      if .not. empty(w_wind)
         acti wind (w_wind)
      endif

      =closall() 
      return

   endif
endif

sele &w_alias
if .not. w_call
   =db_goeof(w_alias)
endif
scatte memvar blank

set skip of menu _msysmenu .t.

do ssm999.mpr && Menu General

=skipbar('Registro','Insertar' ,.t.)

if w_call
    ***vfp***
*	do brow03
    if version()='Visual FoxPro'
		*** cambio el lastkey() ***
		keyboard '{tab}'
		=inkey()
		DO wbrow WITH 'brow03()'
    else
   		do brow03
    endif
    ***vfp***
   if w_alta
      w_alta=.f. 
      scatter memvar blank 

      =skipbar('Registro','Eliminar'  ,.t.)
      =skipbar('Registro','Modificar' ,.t.)

      do sss003.spr   

   endif
else 
   if !empty(w_wind)
      deac wind (w_wind)
   endif   

	***vfp***
    if version()='Visual FoxPro'
	    on key label esc do actsalir
	endif
	***vfp***
	do sss003.spr   
	***vfp***
    if version()='Visual FoxPro'
	    on key label esc
	endif
	***vfp***

endif

pop key 
pop menu _msysmenu

if w_call
   set orde to 1 in (w_alias)
   if .not. empty(w_alan)
      sele &w_alan
   endif
   if .not. empty(w_wind)
      acti wind (w_wind)
   endif
   
   release window sss003
else

	release window sss003, barraabm

	=closall() 
endif

return

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
    PROC Alta03
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

if w_call
   w_alta=.t.
   deac wind (w_title)
endif
 
return

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
    PROC Baja03
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

do clav03

if eof(w_alias) .or. .not. st_rlock(w_alias)
   return 
endif

if sino('Acepta eliminaci๓n ? ')='S'
  w_modicampo=.f.	
  =dele_rec(w_alias)
  unlock in (w_alias)
  do siguiente 
endif

return

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PROC clav03
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

w_orde=order(w_alias)

w_recn=recno(w_alias)

set orde to 1 in (w_alias)

if w_recn<>0
   w_recn=recno(w_alias)
endif

if seek(w_pref+&w_clave,w_alias) 

   if w_recn<>recno(w_alias) .or. .not. st_rlock(w_alias)
      do work03
      w_recn=recno(w_alias)
   endif

   if w_call
      clear read
   endif

else 

   w_cclav=&w_clave

   if w_recn<>recno(w_alias)
      do work03
      w_recn=recno(w_alias)
   endif

   &w_clave=w_cclav   

   show gets 

endif   

set orde to w_orde in (w_alias)

return 

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
FUNC when03
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	w_retu=.t.
	w_vari=varread()

	p_curobj=_curobj

	=irclave('D3PERF','m.d3desc')
	
return w_retu

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
FUNC valid03
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PARAMETER w_show

***vfp***
if version()='Visual Fox' and (w_pfile!='03' or wontop()!='SSS003') and w_show
	if lastkey()=p_esc
		return .t.
	else
		return .f.
	endif
endif
***vfp***

if parameters()=0 
   w_show=.f.
endif

w_retu=.t.
w_vari=varread()
w_vread='m.'+w_vari

	
=ultdepri('D3PERF','m.d3deta')
	
=prideult('D3DETA','m.d3deta')

=modicampo('D3PERF')

return w_retu

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PROC Actu03
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

if !w_agre .and. !w_modi
    return
endif

do clav03

if .not. eof(w_alias) .and. .not. st_rlock(w_alias)
   return 
endif   

if .not. valid03(.t.)
   wait ' Debe completar todos los datos ! ' wind nowait
   return 
endif 

=db_capt(w_alias)

set orde to 1 in (w_alias)

if .not. seek(w_pref+&w_clave,w_alias) 
   if w_agre
      wait ' Agregando registro... ' wind time .4
      =net_appe(w_alias)
      gather memvar 

	  w_modicampo=.f.	&& variable que indica si se modifico un campo del abm

      =db_rlock(w_alias) 
      if .not. w_call
         _curobj=1
      endif
  endif
else 
   if st_rlock(w_alias) 
      if w_modi 
         wait ' Modificando registro... ' wind time .4
         gather memvar

		 w_modicampo=.f.	&& variable que indica si se modifico un campo del abm
		 
      endif 
   else 
      do work03
   endif      
endif 

unlock in f98

if w_call
   clear read
endif


return

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PROC work03
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

scatter memvar 

if w_rdlevel<>rdlevel() and iif(version()='Visual Fox', !w_call,.t.)	&& ***vfp***
     show gets 
     =valid03(.t.)
endif 

if .not. eof(w_alias)
   =rlock(w_alias)
   if .not. st_rlock(w_alias,.t.) 
      _curobj=1
   endif
endif  

return .t.

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PROC brow03
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

activate screen 

w_orde=order(w_alias)

push menu _msysmenu

=skipbar('Registro','Insertar'  ,!w_call or wexist('GETDEST'))

=skipbar('Registro','Eliminar'  ,.t.)
=skipbar('Registro','Consultar' ,.t.)
=skipbar('Registro','Agregar'   ,.t.)
=skipbar('Registro','Elegir'    ,.t.)
=skipbar('Registro','Modificar' ,.t.)

set orde to 2 in (w_alias)

browse  ;
      fields d3perf :h='Perfil':v=fenter() :f ,; 
             d3desc :h='Descripci๓n';
     title w_title ;
     nomenu ;
     noedit ;
     valid :f salebrow(Lastkey()) ;
     font 'Arial', 10 ;
     nodelete ;
     noappend 


set orde to w_orde in (w_alias)

do work03

pop menu _msysmenu

***vfp***
IF version()='Visual FoxPro'
	if w_call
		rele wind wbrow
	else
		clear read
		on key label esc do actsalir
	endif
endif
***vfp***

return 

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
    PROC busc03
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

w_orde=order(w_alias)
*set orde to 2 in (w_alias) 
do busca
if .not. eof(w_alias)
   do work03
endif
set orde to w_orde in (w_alias)
return 

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
    PROC Orde03
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

do case 
   case prompt()='Ordenado por C๓digo'
      set orde to 1 in (w_alias)
   case prompt()='Ordenado por Descripci๓n'
      set orde to 2 in (w_alias)
endcase

if wexist(w_title)
   show wind (w_title) refresh
endif

return

