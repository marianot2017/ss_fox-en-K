*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ Sys.Info ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H Programa        : MANTENIMIENTO DE USUARIOS
*-H Release			: 05
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
w_agre= .t.
w_modi= .t.
w_recn=0


** Datos del archivo a mantener
w_title='USUARIOS'
w_pfile='01'
w_alias='s'+w_pfile
w_clave='m.D1USER'

w_modicampo=.f.	&& variable que indica si se modifico un campo del abm

if .not. w_call
   use ssf003 in 0 alias s03 order 1
   use ssf001 in 0 alias s01 order 1 
    
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

on key label f1 do nada
if w_agre
	On Key Label F9 keyboard '{ctrl+f9}'
endif

do ssm999.mpr && Menu Ayuda

=skipbar('Registro','Insertar' ,.t.)

w_radio=1	&& R.01 Mariano
*w_radio2=1	&& R.01 Mariano	&& R.02 Mariano
w_g0web=1	&& R.02 Mariano
w_g1web=0	&& R.02 Mariano
w_g2web=0	&& R.02 Mariano
w_g3web=0	&& R.02 Mariano
w_g4web=0	&& R.02 Mariano
w_g5web=0	&& R.02 Mariano
w_g6web=0	&& R.02 Mariano
w_g7web=0	&& R.02 Mariano
w_g8web=0	&& R.02 Mariano
w_g9web=0	&& R.02 Mariano

if w_call
    ***vfp***
*	do brow01
    if version()='Visual FoxPro'
		*** cambio el lastkey() ***
		keyboard '{tab}'
		=inkey()
		DO wbrow WITH 'brow01()'
    else
   		do brow01
    endif
    ***vfp***
   
   if w_alta
      w_alta=.f. 
      scatter memvar blank 

      =skipbar('Registro','Eliminar'  ,.t.)
      =skipbar('Registro','Modificar' ,.t.)

      do sss001.spr   

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
	&& R.01b Mariano
	m.d1pweb=m.d1pweb+1
*	m.d1gweb=m.d1gweb+1	&& R.02 Mariano
	&& R.01e Mariano
	do sss001.spr   
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
else
  =closall() 
endif

return

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
    PROC Alta01
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

if w_call
   w_alta=.t.
   deac wind (w_title)
endif
 
return

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
    PROC Baja01
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

do clav01 

if eof(w_alias) .or. .not. st_rlock(w_alias)
   return 
endif

if sino('Acepta eliminaci๓n ? ')='S'

  w_modicampo=.f.	&& variable que indica si se modifico un campo del abm
  
  && R.03b Mariano
  if type('d0f15')='C' and file(d0f15+'.dbf') 	&& R.04 Mariano	&& R.05 Mariano (agregue .dbf)
	  use (d0f15) in 0 alias f15
	  w_empf15=''
	  do while !eof('f15')
		if f15.p0pweb=1
			w_empf15=w_empf15+'G'+str(f15.p0gweb,1)+'E'+f15.p0coem
		endif
		skip in f15
	  enddo		
	  use in f15
	  sele (w_alias)
	  && R.01b Mariano
* 	  if d0pweb=1 and file('pedidweb'+'\data\'+str(d0gweb,1)+'\params.dbf')
*			w_p0gweb=str(d0gweb,1)
*			use pedidweb\data\&w_p0gweb.\params in 0 alias params
*			if file(iif(str(d0gweb,1)$params.path_expor, allt(params.path_expor), allt(params.path_expor)+str(d0gweb,1)+'\')+allt(params.usuarios))
*				w_cmd='use '+iif(str(d0gweb,1)$params.path_expor, allt(params.path_expor), allt(params.path_expor)+str(d0gweb,1)+'\')+allt(params.usuarios)+' in 0 alias usuarios'
*				&w_cmd
*				select usuarios
*				for i=1 to 10	&& R.02 Mariano
*					if !empty(substr(m.d1gwso,i,1))	&& R.02 Mariano
*						append blank
*						gather memvar
*						&& R.02b Mariano
**						replace d1pweb with 0, d1gweb with 0
*						replace d1pweb with 0, d1gweb with val(substr(m.d1gwso,i,1))
*						&& R.02e Mariano
*					endif	&& R.02 Mariano
*				endfor	&& R.02 Mariano
*				use in usuarios
*			endif
*			use in params
*			sele (w_alias)
*	  endif
	  && R.01e Mariano
	  if type('w_empf15')='C' 	&& R.04 Mariano
		  for j=0 to 9
			if len(w_empf15)>0 and 'G'+str(j,1)$w_empf15
				if file('pedidweb'+'\data\'+str(j,1)+'\params.dbf')
					w_p0gweb=str(j,1)
					use pedidweb\data\&w_p0gweb.\params in 0 alias params
					if file(iif(w_p0gweb$params.path_expor, allt(params.path_expor), allt(params.path_expor)+w_p0gweb+'\')+allt(params.usuarios))
						w_cmd='use '+iif(w_p0gweb$params.path_expor, allt(params.path_expor), allt(params.path_expor)+w_p0gweb+'\')+allt(params.usuarios)+' in 0 alias usuarios'
						&w_cmd
						sele usuarios
						append blank
						gather memvar
						replace d1pweb with 0, d1gweb with j
						use in usuarios
					endif
					use in params
					sele (w_alias)
				endif
			endif
		  endfor
	 endif	&& R.04 Mariano
  endif	&& R.04 Mariano
  && R.03e Mariano

  =dele_rec(w_alias)
  unlock in (w_alias)
  do siguiente 
endif

return

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PROC clav01
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

w_orde=order(w_alias)

w_recn=recno(w_alias)

set orde to 1 in (w_alias)

if w_recn<>0
   w_recn=recno(w_alias)
endif

if seek(w_pref+&w_clave,w_alias) 

   if w_recn<>recno(w_alias) .or. .not. st_rlock(w_alias)
      do work01 
      w_recn=recno(w_alias)
   endif

   if w_call
      clear read
   endif

else 

   w_cclav=&w_clave

   if w_recn<>recno(w_alias)
      do work01 
      w_recn=recno(w_alias)
   endif

   &w_clave=w_cclav   

   show gets 

endif   

set orde to w_orde in (w_alias)

return 

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
FUNC when01
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	w_retu=.t.
	w_vari=varread()
	w_vread='m.'+w_vari

	p_curobj=_curobj

	=irclave('D1USER','m.d1nomb')
	
	&& R.03b Mariano
	if m.d1pasw=s01.d1pasw and m.d1user=s01.d1user and !eof('s01')
		m.d1pasw=decript(m.d1pasw,3)
		show get m.d1pasw
	endif
	&& R.03e Mariano
	
	if w_vari='W_OPCNADA'
		if w_modicampo
			if m.d1pweb=2
*				_curobj=objnum(m.d1gweb)	&& R.02 Mariano
				_curobj=objnum(w_g9web)	&& R.02 Mariano
			else
				_curobj=objnum(m.d1pweb)
			endif
		else
			_curobj=1
		endif
		w_retu=.f.
	endif
return (w_retu)

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
FUNC valid01
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PARAMETER w_show

***vfp***
if version()='Visual Fox' and (w_pfile!='01' or wontop()!='SSS001') and w_show
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

&& R.01b Mariano
if w_vari='D1PWEB'
	=mchkbox(@m.d1pweb,w_radio)
	w_radio=m.d1pweb
	m.d1pweb=m.d1pweb-1
endif
&& R.02b Mariano
*if w_vari='D1GWEB'
*	=mchkbox(@m.d1gweb,w_radio2)
*	w_radio2=m.d1gweb
*	m.d1gweb=m.d1gweb-1
*endif
if w_vari='W_G0WEB'
	=mchkbox(@w_g0web)
	m.d1gwso=iif(w_g0web=1,'0',' ')+iif(w_g1web=1,'1',' ')+iif(w_g2web=1,'2',' ')+iif(w_g3web=1,'3',' ')+iif(w_g4web=1,'4',' ')+iif(w_g5web=1,'5',' ')+iif(w_g6web=1,'6',' ')+iif(w_g7web=1,'7',' ')+iif(w_g8web=1,'8',' ')+iif(w_g9web=1,'9',' ')	&& R.03 Mariano
endif
if w_vari='W_G1WEB'
	=mchkbox(@w_g1web)
	m.d1gwso=iif(w_g0web=1,'0',' ')+iif(w_g1web=1,'1',' ')+iif(w_g2web=1,'2',' ')+iif(w_g3web=1,'3',' ')+iif(w_g4web=1,'4',' ')+iif(w_g5web=1,'5',' ')+iif(w_g6web=1,'6',' ')+iif(w_g7web=1,'7',' ')+iif(w_g8web=1,'8',' ')+iif(w_g9web=1,'9',' ')	&& R.03 Mariano
endif
if w_vari='W_G2WEB'
	=mchkbox(@w_g2web)
	m.d1gwso=iif(w_g0web=1,'0',' ')+iif(w_g1web=1,'1',' ')+iif(w_g2web=1,'2',' ')+iif(w_g3web=1,'3',' ')+iif(w_g4web=1,'4',' ')+iif(w_g5web=1,'5',' ')+iif(w_g6web=1,'6',' ')+iif(w_g7web=1,'7',' ')+iif(w_g8web=1,'8',' ')+iif(w_g9web=1,'9',' ')	&& R.03 Mariano
endif
if w_vari='W_G3WEB'
	=mchkbox(@w_g3web)
	m.d1gwso=iif(w_g0web=1,'0',' ')+iif(w_g1web=1,'1',' ')+iif(w_g2web=1,'2',' ')+iif(w_g3web=1,'3',' ')+iif(w_g4web=1,'4',' ')+iif(w_g5web=1,'5',' ')+iif(w_g6web=1,'6',' ')+iif(w_g7web=1,'7',' ')+iif(w_g8web=1,'8',' ')+iif(w_g9web=1,'9',' ')	&& R.03 Mariano
endif
if w_vari='W_G4WEB'
	=mchkbox(@w_g4web)
	m.d1gwso=iif(w_g0web=1,'0',' ')+iif(w_g1web=1,'1',' ')+iif(w_g2web=1,'2',' ')+iif(w_g3web=1,'3',' ')+iif(w_g4web=1,'4',' ')+iif(w_g5web=1,'5',' ')+iif(w_g6web=1,'6',' ')+iif(w_g7web=1,'7',' ')+iif(w_g8web=1,'8',' ')+iif(w_g9web=1,'9',' ')	&& R.03 Mariano
endif
if w_vari='W_G5WEB'
	=mchkbox(@w_g5web)
	m.d1gwso=iif(w_g0web=1,'0',' ')+iif(w_g1web=1,'1',' ')+iif(w_g2web=1,'2',' ')+iif(w_g3web=1,'3',' ')+iif(w_g4web=1,'4',' ')+iif(w_g5web=1,'5',' ')+iif(w_g6web=1,'6',' ')+iif(w_g7web=1,'7',' ')+iif(w_g8web=1,'8',' ')+iif(w_g9web=1,'9',' ')	&& R.03 Mariano
endif
if w_vari='W_G6WEB'
	=mchkbox(@w_g6web)
	m.d1gwso=iif(w_g0web=1,'0',' ')+iif(w_g1web=1,'1',' ')+iif(w_g2web=1,'2',' ')+iif(w_g3web=1,'3',' ')+iif(w_g4web=1,'4',' ')+iif(w_g5web=1,'5',' ')+iif(w_g6web=1,'6',' ')+iif(w_g7web=1,'7',' ')+iif(w_g8web=1,'8',' ')+iif(w_g9web=1,'9',' ')	&& R.03 Mariano
endif
if w_vari='W_G7WEB'
	=mchkbox(@w_g7web)
	m.d1gwso=iif(w_g0web=1,'0',' ')+iif(w_g1web=1,'1',' ')+iif(w_g2web=1,'2',' ')+iif(w_g3web=1,'3',' ')+iif(w_g4web=1,'4',' ')+iif(w_g5web=1,'5',' ')+iif(w_g6web=1,'6',' ')+iif(w_g7web=1,'7',' ')+iif(w_g8web=1,'8',' ')+iif(w_g9web=1,'9',' ')	&& R.03 Mariano
endif
if w_vari='W_G8WEB'
	=mchkbox(@w_g8web)
	m.d1gwso=iif(w_g0web=1,'0',' ')+iif(w_g1web=1,'1',' ')+iif(w_g2web=1,'2',' ')+iif(w_g3web=1,'3',' ')+iif(w_g4web=1,'4',' ')+iif(w_g5web=1,'5',' ')+iif(w_g6web=1,'6',' ')+iif(w_g7web=1,'7',' ')+iif(w_g8web=1,'8',' ')+iif(w_g9web=1,'9',' ')	&& R.03 Mariano
endif
if w_vari='W_G9WEB'
	=mchkbox(@w_g9web)
	m.d1gwso=iif(w_g0web=1,'0',' ')+iif(w_g1web=1,'1',' ')+iif(w_g2web=1,'2',' ')+iif(w_g3web=1,'3',' ')+iif(w_g4web=1,'4',' ')+iif(w_g5web=1,'5',' ')+iif(w_g6web=1,'6',' ')+iif(w_g7web=1,'7',' ')+iif(w_g8web=1,'8',' ')+iif(w_g9web=1,'9',' ')	&& R.03 Mariano
endif
&& R.02e Mariano
&& R.01e Mariano
	
&& R.01b Mariano
*=ultdepri('D1USER','m.d1perf')
*=prideult('D1PERF','m.d1perf')
if m.d1pweb=2
*	=ultdepri('D1USER','m.d1gweb')	&& R.02 Mariano
	=ultdepri('D1USER','w_g9web')	&& R.02 Mariano
else
	=ultdepri('D1USER','m.d1pweb')
endif
&& R.01e Mariano

if w_vari='D1PERF' .or. w_show
    do fhelp with 'D1PERF','','SSP003','S03','D3PERF' ,'D3DESC', 'Perfil inexistente',p_char,'w_retu'
endif

&& R.01b Mariano
*=modicampo('D1USER')
=modicampo('D1USER','D1PASW')

if m.d1user=s01.d1user and !eof('s01')	&& R.03 Mariano
	if encript(m.d1pasw,3)!=s01.d1pasw
		w_modicampo=.t.
	endif
	&& R.03b Mariano
	if m.d1gwso!=s01.d1gwso
		w_modicampo=.t.
	endif
	&& R.03e Mariano
endif	&& R.03 Mariano
&& R.01e Mariano

&& R.01b Mariano
if w_vari='D1PWEB'
	m.d1pweb=m.d1pweb+1
endif
&& R.02b Mariano
*if w_vari='D1GWEB'	
*	m.d1gweb=m.d1gweb+1
*endif
&& R.02e Mariano
if w_vari='D1PWEB' or w_show
	if m.d1pweb=2 and empty(m.d1mail)	&& si esta activo y no hay usuario
         if .not. w_show
            wait 'Debe completar el usuario pedidos web' wind
         endif
         m.d1pweb=1
         show get m.d1pweb
	endif		
	if m.d1pweb=1
		&& R.02b Mariano
*		show get m.d1gweb disable
		show get w_g0web disable
		show get w_g1web disable
		show get w_g2web disable
		show get w_g3web disable
		show get w_g4web disable
		show get w_g5web disable
		show get w_g6web disable
		show get w_g7web disable
		show get w_g8web disable
		show get w_g9web disable
		&& R.02e Mariano
	else
		&& R.02b Mariano
*		show get m.d1gweb enable
		show get w_g0web enable
		show get w_g1web enable
		show get w_g2web enable
		show get w_g3web enable
		show get w_g4web enable
		show get w_g5web enable
		show get w_g6web enable
		show get w_g7web enable
		show get w_g8web enable
		show get w_g9web enable
		&& R.02e Mariano
	endif
endif
&& R.01e Mariano

&& R.04b Mariano
if w_vari='D1MAIL' or w_show
	if !empty(m.d1mail)
		m.d1mail=lower(m.d1mail)
		if not('@'$m.d1mail)
			if !w_show
				wait window 'Direcci๓n de mail incorrecta'
			endif
			w_retu=.f.
		endif
	endif
endif
&& R.04e Mariano

return (w_retu)

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PROC Actu01
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

if !w_agre .and. !w_modi
    return
endif

do clav01

if .not. eof(w_alias) .and. .not. st_rlock(w_alias)
   return 
endif   

if .not. valid01(.t.)
   wait ' Debe completar todos los datos ! ' wind nowait
   return 
endif 

=db_capt(w_alias)

set orde to 1 in (w_alias)

&& R.03b Mariano
if type('d0f15')='C' and file(d0f15+'.dbf') 	&& R.04 Mariano	&& R.05 Mariano (agregue .dbf)
	use (d0f15) in 0 alias f15
	w_empf15=''
	do while !eof('f15')
		if f15.p0pweb=1
			w_empf15=w_empf15+'G'+str(f15.p0gweb,1)+'E'+f15.p0coem
		endif
		skip in f15
	enddo		
	use in f15
endif	&& R.04 Mariano
sele (w_alias)
&& R.03e Mariano

if .not. seek(w_pref+&w_clave,w_alias) 
   if w_agre
      wait ' Agregando registro... ' wind time .4
      =net_appe(w_alias)
      m.d1mean=1
      && R.01b Mariano
      m.d1pweb=m.d1pweb-1
      && R.02b Mariano
*     m.d1gweb=m.d1gweb-1
	  m.d1gwso=iif(w_g0web=1,'0',' ')+iif(w_g1web=1,'1',' ')+iif(w_g2web=1,'2',' ')+iif(w_g3web=1,'3',' ')+iif(w_g4web=1,'4',' ')+iif(w_g5web=1,'5',' ')+iif(w_g6web=1,'6',' ')+iif(w_g7web=1,'7',' ')+iif(w_g8web=1,'8',' ')+iif(w_g9web=1,'9',' ')
	  && R.02e Mariano
      && R.01e Mariano
      gather memvar
      replace d1pasw with encript(m.d1pasw,3)	&& R.01 Mariano
      && R.01b Mariano
      m.d1pweb=m.d1pweb+1
*     m.d1gweb=m.d1gweb+1	&& R.02 Mariano
      && R.01e Mariano

      && R.03b Mariano
      && R.01b Mariano
*      if w_modicampo and d0pweb=1 and file('pedidweb'+'\data\'+str(d0gweb,1)+'\params.dbf')
*		w_p0gweb=str(d0gweb,1)
*		use pedidweb\data\&w_p0gweb.\params in 0 alias params
*		if file(iif(str(d0gweb,1)$params.path_expor, allt(params.path_expor), allt(params.path_expor)+str(d0gweb,1)+'\')+allt(params.usuarios))
*			w_cmd='use '+iif(str(d0gweb,1)$params.path_expor, allt(params.path_expor), allt(params.path_expor)+str(d0gweb,1)+'\')+allt(params.usuarios)+' in 0 alias usuarios'
*			&w_cmd
*			sele usuarios
*			for i=1 to 10	&& R.02 Mariano
*				if !empty(substr(m.d1gwso,i,1))	&& R.02 Mariano
*					append blank
*					gather memvar
*					&& R.02b Mariano
**					replace d1pweb with d1pweb-1, d1gweb with d1gweb-1
*					replace d1pweb with d1pweb-1, d1gweb with val(substr(m.d1gwso,i,1))	
					&& R.02e Mariano
*				endif	&& R.02 Mariano
*			endfor	&& R.02 Mariano
*			use in usuarios
*		endif
*		use in params
*		sele (w_alias)
*	  endif
	  && R.01e Mariano

	  m_retu=''
	  w_vfox=sys(5)+sys(2003)+'\'+sys(3)+'.mem'
	  release all like w_inst*
	  w_inst001='m_retu=hash('+"'"+m.d1pasw+"'"+')'
	  save to &w_vfox. all like w_inst*
	  release all like w_inst*
	  =visuafox('ejeproc(.f.)',w_vfox,'Hasheando...')
	  if file(w_vfox)
		restore from &w_vfox. additive
		erase &w_vfox.
	  endif
	  if type('w_empf15')='C' 	&& R.04 Mariano
		  for j=0 to 9
			if len(w_empf15)>0 and 'G'+str(j,1)$w_empf15
				if file('pedidweb'+'\data\'+str(j,1)+'\params.dbf')
					w_p0gweb=str(j,1)
					use pedidweb\data\&w_p0gweb.\params in 0 alias params
					if file(iif(w_p0gweb$params.path_expor, allt(params.path_expor), allt(params.path_expor)+w_p0gweb+'\')+allt(params.usuarios))
						w_cmd='use '+iif(w_p0gweb$params.path_expor, allt(params.path_expor), allt(params.path_expor)+w_p0gweb+'\')+allt(params.usuarios)+' in 0 alias usuarios'
						&w_cmd
						sele usuarios
						append blank
						gather memvar
						if empty(substr(m.d1gwso,j+1,1))
							replace d1pweb with 0, d1gweb with j
						else
							replace d1pweb with d1pweb-1, d1gweb with j
						endif
						replace d1pasw with m_retu
						use in usuarios
					endif
					use in params
					sele (w_alias)
				endif
			endif
		 endfor
	  endif	&& R.04 Mariano
	  && R.03e Mariano
	 
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
		 && R.01b Mariano
		 m.d1pweb=m.d1pweb-1
*		 m.d1gweb=m.d1gweb-1	&& R.02 Mariano
		 && R.01e Mariano
		 m.d1gwso=iif(w_g0web=1,'0',' ')+iif(w_g1web=1,'1',' ')+iif(w_g2web=1,'2',' ')+iif(w_g3web=1,'3',' ')+iif(w_g4web=1,'4',' ')+iif(w_g5web=1,'5',' ')+iif(w_g6web=1,'6',' ')+iif(w_g7web=1,'7',' ')+iif(w_g8web=1,'8',' ')+iif(w_g9web=1,'9',' ')	&& R.03 Mariano
		 gather memvar
		 replace d1pasw with encript(m.d1pasw,3)	&& R.01 Mariano
		 && R.01b Mariano
		 m.d1pweb=m.d1pweb+1
*		 m.d1gweb=m.d1gweb+1	&& R.02 Mariano
		 && R.01e Mariano

		 && R.03b Mariano
		 && R.01b Mariano
*		 if w_modicampo and d0pweb=1 and file('pedidweb'+'\data\'+str(d0gweb,1)+'\params.dbf')
*			w_p0gweb=str(d0gweb,1)
*			use pedidweb\data\&w_p0gweb.\params in 0 alias params
*			if file(iif(str(d0gweb,1)$params.path_expor, allt(params.path_expor), allt(params.path_expor)+str(d0gweb,1)+'\')+allt(params.usuarios))
*				w_cmd='use '+iif(str(d0gweb,1)$params.path_expor, allt(params.path_expor), allt(params.path_expor)+str(d0gweb,1)+'\')+allt(params.usuarios)+' in 0 alias usuarios'
*				&w_cmd
*				select usuarios
*				for i=1 to 10	&& R.02 Mariano
*					if !empty(substr(m.d1gwso,i,1))	&& R.02 Mariano
*						append blank
*						gather memvar
*						&& R.02b Mariano
**						replace d1pweb with d1pweb-1, d1gweb with d1gweb-1
*						replace d1pweb with d1pweb-1, d1gweb with val(substr(m.d1gwso,i,1))	
*						&& R.02e Mariano
*					endif	&& R.02 Mariano
*				endfor	&& R.02 Mariano
*				use in usuarios
*			endif
*			use in params
*			sele (w_alias)
*		 endif
		 && R.01e Mariano

		  m_retu=''
		  w_vfox=sys(5)+sys(2003)+'\'+sys(3)+'.mem'
		  release all like w_inst*
		  w_inst001='m_retu=hash('+"'"+m.d1pasw+"'"+')'
		  save to &w_vfox. all like w_inst*
		  release all like w_inst*
		  =visuafox('ejeproc(.f.)',w_vfox,'Hasheando...')
		  if file(w_vfox)
			restore from &w_vfox. additive
			erase &w_vfox.
		  endif
		  if type('w_empf15')='C' 	&& R.04 Mariano
			  for j=0 to 9
				if len(w_empf15)>0 and 'G'+str(j,1)$w_empf15
					if file('pedidweb'+'\data\'+str(j,1)+'\params.dbf')
						w_p0gweb=str(j,1)
						use pedidweb\data\&w_p0gweb.\params in 0 alias params
						if file(iif(w_p0gweb$params.path_expor, allt(params.path_expor), allt(params.path_expor)+w_p0gweb+'\')+allt(params.usuarios))
							w_cmd='use '+iif(w_p0gweb$params.path_expor, allt(params.path_expor), allt(params.path_expor)+w_p0gweb+'\')+allt(params.usuarios)+' in 0 alias usuarios'
							&w_cmd
							sele usuarios
							append blank
							gather memvar
							if empty(substr(m.d1gwso,j+1,1))
								replace d1pweb with 0, d1gweb with j
							else
								replace d1pweb with d1pweb-1, d1gweb with j
							endif
							replace d1pasw with m_retu	&& R.03 Mariano
							use in usuarios
						endif
						use in params
						sele (w_alias)
					endif
				endif
			 endfor
		 endif	&& R.04 Mariano
		 && R.03e Mariano

		 w_modicampo=.f.	&& variable que indica si se modifico un campo del abm
		 
         if p_user=s01->d1user
            p_mean=s01->d1mean
         endif   

      endif 
   else 
      do work01
   endif      
endif 

unlock in f98

if w_call
   clear read
endif


return

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PROC work01
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

scatter memvar 

&& R.01b Mariano
m.d1pasw=decript(m.d1pasw,3)
m.d1pweb=m.d1pweb+1
*m.d1gweb=m.d1gweb+1	&& R.02 Mariano
w_radio=m.d1pweb
&& R.02b Mariano
*w_radio2=m.d1gweb
w_g0web=iif('0'$m.d1gwso,1,0)
w_g1web=iif('1'$m.d1gwso,1,0)
w_g2web=iif('2'$m.d1gwso,1,0)
w_g3web=iif('3'$m.d1gwso,1,0)
w_g4web=iif('4'$m.d1gwso,1,0)
w_g5web=iif('5'$m.d1gwso,1,0)
w_g6web=iif('6'$m.d1gwso,1,0)
w_g7web=iif('7'$m.d1gwso,1,0)
w_g8web=iif('8'$m.d1gwso,1,0)
w_g9web=iif('9'$m.d1gwso,1,0)
&& R.01e Mariano

if w_rdlevel<>rdlevel() and iif(version()='Visual Fox', !w_call,.t.)	&& ***vfp***
     show gets 
     =valid01(.t.)
endif 

if .not. eof(w_alias)
   =rlock(w_alias)
   if .not. st_rlock(w_alias,.t.) 
      _curobj=1
   endif
endif  

return .t.

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PROC brow01
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

activate screen 

w_orde=order(w_alias)

push menu _msysmenu

=skipbar('Registro','Insertar' ,!w_call or wexist('GETDEST'))

=skipbar('Registro','Eliminar' ,.t.)
=skipbar('Registro','Consultar',.t.)
=skipbar('Registro','Agregar'  ,.t.)
=skipbar('Registro','Elegir'   ,.t.)
=skipbar('Registro','Modificar',.t.)

set orde to 2 in (w_alias)

sele s01
set relation to d1perf into s03

browse  ;
      fields d1user :h='Usuario':v=fenter() :f ,; 
             d1nomb :h='Apellido y nombres'    ,;
             s03.d3desc :h='Perfil Asignado'   ,;
             d1perf :h=''                       ;
     title w_title ;
     nomenu ;
     noedit ;
     valid :f salebrow(Lastkey()) ;
     font 'Arial', 10 ;
     nodelete ;
     noappend 


set rela to

set orde to w_orde in (w_alias)

do work01

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
    PROC busc01
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

w_orde=order(w_alias)
*set orde to 2 in (w_alias) 
do busca
if .not. eof(w_alias)
   do work01
endif
set orde to w_orde in (w_alias)
return 

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
    PROC Orde01
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

do case 
   case upper(prompt())=upper('Ordenado por C๓digo')
      set orde to 1 in (w_alias)
   case upper(prompt())=upper('Ordenado por Descripci๓n')
      set orde to 2 in (w_alias)
endcase

if wexist(w_title)
   show wind (w_title) refresh
endif

return

