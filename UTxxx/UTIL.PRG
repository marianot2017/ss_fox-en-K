*	RELEASE : 06

para p_par1, p_par2, p_par3, p_par4, p_par5

if parameters()=0
	p_par1='NO'
endif
set resou off

if type('p_par2')$'L.U'
	p_par2=''
endif

do case
	case type('p_par3')$'U'
		p_par3=0
	case type('p_par3')$'C'
		p_par3=val(p_par3)
endcase

do case
	case type('p_par4')$'U'
		p_par4=0
	case type('p_par4')$'C'
		p_par4=val(p_par4)
endcase

if type('p_par5')$'L.U'
	p_par5=''
endif


** p_par1 = numero de usuario
** p_par2 = dispositivo donde se hace resguardo automatico / sopo --> suplanta sopo.123 
** p_par3 = particiona el resguardo sistema completo automatico (0-no, 1-si)
** p_par4 = pregunta confirmacion del resguardo sistema completo automatico (0-no, 1-si)
** p_par5 = Nro. empresa que se hace resguardo si esta vacio se hace resguardo completo
** ej:		'---;---;[---;---];---;[---;---]'
if file('util.exe')
	set devel off
else
	set devel on
endif

clear

set sysmenu to

_refox_=(9876543210)
_refox_=(9876543210)

public array fieldvec[255]
fieldvec=''

__curdir=curdir()
__curdrv=sys(5)
w_cd=__curdrv+__curdir

if (len(__curdir)<>4 and right(__curdir,4)<>'\UT\')
	wait window 'UTIL.EXE debe ser ejecutado desde un directorio de Sistemas del Proveedor'
	cancel
endif
	
w_sys=subs(__curdir,2,2)

** cuando estoy en desarrollo del util w_sys='SS' por ss_fox

d0pref=w_sys

on error do ssp090 with error(), lineno(), program()

set proc to library.prg
=setup()

__windir=dimaqi()

if mfile('sopo.123') or upper(p_par2)='SOPO'
	* Para trabajar en el cliente
	dele file sopo.123
	set sysmenu to defa
	do comwin
	clear all
	on error
	cancel
endif


do case
case w_sys='AW'
	d0f77='AIF077'
	w_vexe=fx('invarpub(.t.)','aip000')
	empresas=''
	auditor=''
	w_title='Administración Interna Utilitarios '
case w_sys='CG'
	d0f77='COF077'
	w_vexe=fx('invarpub(.t.)','cgp000')
	empresas='cof010'
	auditor=w_cd+'cof020'
	w_title='Contabilidad General Utilitarios '
case w_sys='GA'
	d0f77='GAF077'
	w_vexe=fx('invarpub(.t.)','gap000')
	empresas=''
	auditor=''
	w_title='Generador de datos Utilitarios '
case w_sys='GW'
	d0f77='GVF077'
	w_vexe=fx('invarpub(.t.)','gwp000')
	empresas='gvf015'
	auditor=w_cd+'gvf074'
	w_title='Gestión Comercial Utilitarios '
case w_sys='IW'
	d0f77='IVF077'
	w_vexe=fx('invarpub(.t.)','iwp000')
	empresas='ivf010'
	auditor=w_cd+'ivf022'
	w_title='I.V.A. Ventas/Compras Utilitarios '
case w_sys='SJ'
	d0f77='SUF077'
	w_vexe=fx('invarpub(.t.)','sjp000')
	empresas='suf020'
	auditor=w_cd+'suf031'
	w_title='Sueldos y Jornales Utilitarios '
case w_sys='ST'
	d0f77='STF077'
	w_vexe=fx('invarpub(.t.)','stp000')
	empresas=''
	auditor=''
	w_title='Servicio Técnico Utilitarios '
case w_sys='SE'
	d0f77='SEF077'
	w_vexe=fx('invarpub(.t.)','sep000')
	empresas='sef015'
	auditor=''
	w_title='Seguimiento Comercial Utilitarios '
other
	d0f77=w_sys+'f077'
	w_vexe='00000000'
	empresas=''
	auditor=''
	w_title='Utilitarios '
endcase

w_title=w_title+' v3.33 '+lib()

deac menu _msysmenu

if empty(p_par2)
	modi wind screen;
		title w_title ;
		font 'arial',10
else
	modi wind screen;
		title w_title ;
		fill file MemoFond.bmp;
		font 'arial',10
endif
zoom wind screen max


*  Toma de parametros de XX.mem
if mfile(w_sys+'.mem')
	rest from &w_sys addi

	if type('Z_VE')=='C' .and. type('Z_NT')=='C'
		nf_cla1 = decript(z_ve,3)
		nf_cla2 = decript(z_nt,3)
		nf_vers = subst(nf_cla1,18+asc(subst(nf_cla1,17,1))+1,8)
		nf_cate = subst(nf_cla2,18+asc(subst(nf_cla2,17,1))+1,4)

	else
		x=adir(versys,'VER*.*')
		if !empty(x)
			=asort(versys)
			nf_vers=right(versys[x,1],3)+subs(versys[x,1],4,5)
		else
			nf_vers = '00000000'
		endif

		nf_cate = '0001'
	endif

	if type('Z_NI')=='C'
		wssni = decript(z_ni,3)
		nf_ni = subst(wssni,18+asc(subst(wssni,17,1))+1,4)
	else
		nf_ni = 'DEMO'
	endif

	if val(nf_cate) > 1
		__modo='MU'
	else
		__modo='MO'
	endif

	if type('Z_NC')=='C'
		w_cla = decript(z_nc,3)
		wacla = subst(w_cla,18+asc(subst(w_cla,17,1))+1,4)
	else
		wacla = '    '
	endif

	__term=tomuserc()


	sline= __curdrv+__curdir+'  Versión:'+nf_vers+'  NI:'+nf_ni+'  Modo:'+__modo+'#'+__term

else
	sline= __curdrv+__curdir

	nf_ni = 'DEMO'
endif


wsalir=.f.

if empty(p_par2)
	do util.mpr
endif

set talk off
set echo off
set date french
set conf on
set bell off
set dele on
set safe off
set lock off
set esca off
set print off
set print to
set century on
set multilock off
set reprocess to 5
set notify off
set autosave on
set bell to 2500,1
set mouse on
set color of message to b*/w
set status bar off
set mackey to
*set excl off
*set resource on
set excl on

com=.f.

__lib=lib()

if empty(p_par2)
	do util.spr
else
	if empty(p_par5)
		&& fuerzo resguardo de sistema completo
		wait wind '' nowait		&& para activar la screen
		w_res=1
		w_conf=1
		w_path=sys(5)+'\'
		do dispsc
		do validres
	else
		&& fuerzo resguardo de empresa (p_par5)
		wait wind '' nowait		&& para activar la screen
		w_res=2
		w_conf=1
		w_path=sys(5)+'\'
		do dispsc
		do validres
	endif
endif

set sysmenu to defa

return

* -----------------------------------------------------
proc validvis
* -----------------------------------------------------
para v_auto

v_in=adir(v_file,'*.uti')
if !empty(v_in)
	for v_i=1 to v_in
		v_fi=v_file[v_i,1]
		dele file &v_fi
	next
endif


wsalir=.t.
do case
case w_vis=1   &&  Config.sys
	modi comm c:\config.sys in screen
	if mfile('c:\config.sys')
		copy file c:\config.sys to consys.uti
	endif

case w_vis=2   &&  Autoexec.bat
	modi comm c:\autoexec.bat in screen
	if mfile('c:\autoexec.bat')
		copy file c:\autoexec.bat to autoexec.uti
	endif

case w_vis=3   &&  Set
	! set > set.uti
	modi comm set.uti noedit   in screen

case w_vis=4   &&  Win.ini
	modi comm &__windir\win.ini noedit in screen
	if mfile(__windir+'win.ini')
		copy file &__windir\win.ini to win.uti
	endif

case w_vis=5   && 'Config.fpw'
	modi comm config.fpw  in screen
	if mfile('config.fpw')
		copy file config.fpw to confpw.uti
	endif

case w_vis=6   &&  Users
	! dir &__curdir.users\*.* /ad /on > users.uti
	modi comm users.uti noedit   in screen

case w_vis=7   &&  MEM
	! mem /c > mem.uti
	modi comm mem.uti noedit   in screen

case w_vis=8   &&  Directorios
	! dir &__curdir.*.* /ad /on > dirsy.uti
	modi comm dirsy.uti noedit   in screen as 1252

case w_vis=9   &&  Red

	if crearedbat()
		! red
		modi comm red.uti noedit   in screen
	endif

endcase

v_in=adir(v_file,'*.uti')

if !empty(v_in)
	if v_in=1
		w_arch='Archivo '+v_file[1]
	else
		w_arch='Se imprimirán '+str(v_in,2)+' Archivos'
	endif
	if sino('Desea Imprimir la Visualización ? ','N',w_arch)='S'
		set talk off
		set console off
		for v_i=1 to v_in
			v_fi=v_file[v_i,1]
			if mfile(v_fi)
				type &v_fi to print prompt number
			endif
		next
		set console on
	endif
endif

set defa to &w_cd

wsalir=.f.

return

* -----------------------------------------------------
proc validres
* -----------------------------------------------------
if !lock77()
	return
endif

do case
case w_res=1 and nf_ni!='DEMO'  &&  Resguardo Sistema Completo

	w_driv='A:'
	w_conf=1

	priv w_title
	w_title='Resguardo Completo'

	if empty(p_par2)
		w_path=sys(5)+'\'
	endif

	w_part=0
	
	if empty(p_par2)
		do utildr.spr
	endif

	if !empty(p_par3)	&& si viene algo lo particiona
		w_part=1
	endif

	** Los archivos *.uti de configuracion los hace con enviar a Proveedor **
	** los sacamos de resguardo completo y de empresa **

	if w_conf=1 and lastkey()<>p_esc
		if iif(empty(p_par2) or !empty(p_par4), sino(' Confirma Resguardo de Sistema Completo? ','N','De '+__curdir+' hacia  '+w_path)='S', .t.)

*			do todosuti

			erase &w_path&w_sys..001

			sele f77
			use
	
			set alter to &w_cd.names.
			set alter on
			set conso off
			?'names'
			?'*.exe'
			?'*.esl'
			?'*.fll'
			?'*.doc'
			?'*.hlp'
			?'*.zip'
			?'*.cdx'
			?'condtrib.*'
			?w_sys+'*.0??'	&& excluyo los posibles resguardos que hubiese dentro del mismo
							&& ya que el arj se mama y los recupera tambien produciendo cagadas
			set conso on
			set alter to
			set alter off

**			w_run='arj a &w_path&w_sys..001 &w_cd.*.* -r -va -hf -x*.exe -x*.esl -x*.fll -x*.doc -x*.zip -x*.cdx -x*.0??'
	
			set defa to &w_path
			if val(sys(2020))<1500000	&& Disketera
*			if 'A:'$w_path or 'B:'$w_path
				w_part=0
			endif
			set defa to &w_cd
			
			if w_part=0
				w_run='arj a &w_path&w_sys..001 &w_cd.*.* -r -va -hf -x!&w_cd.names'
			else
				=delefile(w_path,w_sys+'.0*')
				w_run='arj a &w_path&w_sys..001 &w_cd.*.* -r -v1440 -hf -x!&w_cd.names'
			endif
			wait wind 'Ejecutando: '+left(w_run,75)+iif(len(w_run)>75,chr(13)+substr(w_run,76,75),'') nowait

			! &w_run
			
			=delefile(w_cd,'*.uti')
			=delefile(w_cd,'names')

		endif
	endif


case w_res=2 and nf_ni!='DEMO'   &&  Resguardo de empresa

	if empresas='gvf015' or empresas='sef015'	&& gestion o seguimiento
		w_empr='   '
		w_form='999'
	else
		w_empr='  '
		w_form='99'
	endif
	w_driv='A:'
	w_conf=1

	priv w_title
	w_title='Resguardo de Empresa'

	if empty(empresas)
		=advsuave('Sistema sin empresas a resguardar', w_title)
	else

		sele 0
		use &empresas. alias 'Fempr' order p0coem shared 
		if neterr()
			wait wind 'No se puede realizar el Resguardo' nowait
		else
			if empty(p_par2)
				w_path=sys(5)+'\'
			endif

			w_part=0

			if empty(p_par2)
				do utildrem.spr
			endif
			
			if !empty(p_par3)	&& si viene algo lo particiona
				w_part=1
			endif
			
			private i,j,w_seri,w_eman
			j=1
			w_seri=.f.
			w_eman=''
			do while w_conf=1 and lastkey()<>p_esc
		
			if !empty(p_par5)
				if !w_seri
					w_empr=''
				else
					w_eman=w_empr
					w_empr=''
				endif
				for i=j to len(p_par5)
					do case
						case isdigit(substr(p_par5,i,1))
							w_empr=w_empr+substr(p_par5,i,1)
						case substr(p_par5,i,1)='['		&& Empieza serie
							w_seri=.t.
						case substr(p_par5,i,1)=']'		&& Termina serie
							if w_seri
								w_eman=padl(allt(str(val(w_eman)+1,3)),len(w_empr),'0')
								do while !seek(w_eman,'Fempr') and w_eman<w_empr
									w_eman=padl(allt(str(val(w_eman)+1,3)),len(w_empr),'0')
								enddo
								if fempr.p0coem=w_eman and w_eman<w_empr
									i=j-1
									w_empr=w_eman
									exit
								endif														
							endif
							w_seri=.f.
						otherwise
							exit
					endcase
				endfor
				j=i+1	
*				w_empr=p_par5
			endif
				
			w_empr=allt(w_empr)
			
			if empty(w_empr)
				exit
			endif
			
			if w_conf=1 and lastkey()<>p_esc
				if iif(empty(p_par2) or !empty(p_par4), sino(' Confirma Resguardo de Empresa? ','N','De '+__curdir+w_empr+' hacia  '+w_path)='S', .t.)

					if seek(w_empr,'Fempr')
						Empr_Ver=w_cd+'Empr_Ver.dbf'
						sele 0
						create dbf &Empr_Ver. (p0coem c(len(w_form)), p0veda c(3), p0memo l(1))
						insert into &Empr_Ver. (p0coem, p0veda, p0memo) values (w_empr, Fempr.p0veda, iif(mfile('\aw\aif000.dbf'),.t.,.f.))
						use in Empr_Ver
					else
						Empr_Ver=''
						loop						
					endif

*					do todosuti
				
					erase &w_path&w_sys&w_empr..001
	
					if used('f77')
						sele f77
						use
					endif

					**no ejecutaba en Windows 2000 porque el limite del parametro es 127 caracteres
					**no ejecutaba en XP, aparentemente es menor de 127 caracteres, por eso lo particione.
					**primero guardo lo que entra en un disquet y luego agrego lo demas que puede ocupar mas de un disquet.
					

**					w_run='&w_cd.arj a &w_path&w_sys&w_empr..001 &w_cd.??F077.* *.UTI'+iif(empty(auditor),'',' '+auditor+'.*')+' '+Empr_Ver+' -va -p1 -hf'

					set defa to &w_path
					if val(sys(2020))<1500000	&& Disketera
*					if 'A:'$w_path or 'B:'$w_path
						w_part=0
					endif
					set defa to &w_cd

					if w_part=0
						w_run='arj a &w_path&w_sys&w_empr..001 &w_cd.*.dbf &w_cd.*.fpt &w_cd.*.dbt'+' '+Empr_Ver+' -va -p1 -hf'
					else
						=delefile(w_path,w_sys+w_empr+'.0*')
						w_run='arj a &w_path&w_sys&w_empr..001 &w_cd.*.dbf &w_cd.*.fpt &w_cd.*.dbt'+' '+Empr_Ver+' -v1440 -p1 -hf'
					endif

					wait wind 'Ejecutando: '+left(w_run,75)+iif(len(w_run)>75,chr(13)+substr(w_run,76,75),'') nowait
					
					! &w_run

					if w_part=0
						w_run='arj u &w_path&w_sys&w_empr..001 &w_cd&w_empr.\*.dbf &w_cd&w_empr.\*.fpt '+' -va -p1 -hf'
					else
						w_run='arj u &w_path&w_sys&w_empr..001 &w_cd&w_empr.\*.dbf &w_cd&w_empr.\*.fpt '+' -v1440 -p1 -hf'
					endif

					wait wind 'Ejecutando: '+left(w_run,75)+iif(len(w_run)>75,chr(13)+substr(w_run,76,75),'') nowait
					
					! &w_run

					=delefile(w_cd,'*.uti')
					=delefile(w_cd,'Empr_Ver.dbf')

				endif
			endif

			if empty(p_par5)
				exit
			endif

			enddo
			
			use in Fempr
		endif
	endif

case nf_ni='DEMO'

	=advsuave('Versión Demostración. Inhibido el acceso.')

endcase

set defa to &w_cd
wait clear

if used('F77')
	sele F77
	use
endif

return

* -----------------------------------------------------
proc validrec
* -----------------------------------------------------
if !lock77()
	return
endif

do case
case w_rec=1 and nf_ni!='DEMO'   &&  Recupero Sistema Completo
	w_driv='A:'
	w_conf=1

	w_title='Recupero Completo'

	w_path=sys(5)+'\'
	w_part=0
	do utildr2.spr

	if w_conf=1 and lastkey()<>p_esc
		if mfile(w_path+w_sys+'.001')
			if sino(' Confirma Recupero de Sistema Completo? ','N','De  '+w_path+'  a '+__curdir)='S'
				
				set alter to &w_cd.names.
				set alter on
				set conso off
				?'*.mem'
				?'*.prt'	&& R.04 Mariano
				?'names'
				?w_sys+'\fi\*.*'
				?w_sys+'\fi\00\*.*'
				?w_sys+'\fi\000\*.*'
				?w_sys+'\etc\*.*'
				?w_sys+'\doc\*.*'
				?w_sys+'\form\*.*'
				?w_sys+'\ssf098.*'
				?'foxuser.*'
				?w_sys+'\o_pago\*.*'
				?w_sys+'\listas\*.*'
				?w_sys+'\label\*.*'
				?w_sys+'\impresio\*.*'
				?w_sys+'\*.tmp'
				?w_sys+'\*.err'
				?w_sys+'*.0??'	&& excluyo los posibles resguardos que hubiese dentro del mismo
								&& ya que el arj se mama y los recupera tambien produciendo cagadas
				set conso on
				set alter to
				set alter off

				sele f77
				use

				**no ejecutaba en Windows 2000 porque el limite del parametro es 127 caracteres
				
				w_run='&w_cd.arj x &w_path&w_sys..001 *.* -r -v -jyco -x!&w_cd.names -hf2 -ht&__curdrv.\'
**				w_run='&w_cd.arj x &w_path&w_sys..001 \ -r -v -jyco -x!&w_cd.names -hf2 -ht&__curdrv.\'

**				w_run='arj x &w_driv&w_sys..001 \ -r -v -jyco -x*.mem -x&w_sys.\fi\*.* -x&w_sys.\fi\00\*.* -x&w_sys.\etc\*.* -x&w_sys.\doc\*.* -x&w_sys.\form\*.* -xfoxuser.*'

				wait wind 'Ejecutando: '+left(w_run,75)+iif(len(w_run)>75,chr(13)+substr(w_run,76,75),'') nowait

				! &w_run
				
				=delefile(w_cd,'names')
				
				sele 0
				use &empresas. alias 'Fempr' shared 
				if !neterr()
					do while !eof()
						w_empr=p0coem
						if dispok(w_cd+w_empr)	&& por si existe la empresa pero no el directorio
							=delefile(w_cd+w_empr+'\','*.cdx')
							set alter to &w_cd&w_empr.\indexar.mem
							set alter on
							set conso off
							?'indexar siempre'
							set conso on
							set alter to
							set alter off
						endif
						skip
					enddo
					use in Fempr
				endif
*				=delefile(w_cd,'\*.cdx')	&& R.02 Mariano
*				set alter to &w_cd.\indexar.mem	&& R.02 Mariano
				=delefile(w_cd,'*.cdx')		&& R.02 Mariano
				set alter to &w_cd.indexar.mem	&& R.02 Mariano
				set alter on
				set conso off
				?'indexar siempre'
				set conso on
				set alter to
				set alter off
			endif
		else
			wait wind 'No Existe Archivo '+w_path+w_sys+'.001'+' a Recuperar' time 3
		endif
	endif

case w_rec=2 and nf_ni!='DEMO'   &&  Recupero de empresa

	if empresas='gvf015' or empresas='sef015'	&& gestion o seguimiento
		w_empr='   '
		w_form='999'
	else
		w_empr='  '
		w_form='99'
	endif
	w_driv='A:'
	w_conf=1

	priv w_title
	w_title='Recupero de Empresa'

	if empty(empresas)
		=advsuave('Sistema sin empresas para recuperar', w_title)
	else

		sele 0
		use &empresas. alias 'Fempr' order p0coem shared 
		if neterr()
			wait wind 'No se puede realizar el Recupero' nowait
		else

			w_path=sys(5)+'\'
			w_part=0
			do utildre2.spr

			w_empr=allt(w_empr)

			** Cuando recupero la empresa recupero el F77, si el resguardo es anterior del problema puede seguir trabajando **
			** Si el resguardo es posterior al error transacional si lo levantan va a seguir sin acceder a la empresa **

			if w_conf=1 and lastkey()<>p_esc
				if mfile(w_path+w_sys+w_empr+'.001')
					if sino(' Confirma Recupero de Empresa? ','N','De '+w_path+' a  '+__curdir+w_empr)='S'
					
						set alter to &w_cd.names.
						set alter on
						set conso off
						?'names'
*						if !empty(d0f77)
*							?d0f77+'.*'
*						endif
						if !empty(auditor)
							?right(auditor,6)+'.*'
						endif
						?'ssf*.*'
						?'*.txt'
						?'*.log'
						?'*.uti'
						?w_sys+'*.0??'	&& excluyo los posibles resguardos que hubiese dentro del mismo
										&& ya que el arj se mama y los recupera tambien produciendo cagadas
						set conso on
						set alter to
						set alter off

						sele f77
						use

						**modifique para que cambiando el nombre del archivo restaure en otra empresa.
						**ademas si en DOS estoy parado en cualquier directorio igualmente restaura correctamente.
						**esto ultimo es para todos los recuperos.

						w_run='&w_cd.arj e &w_path&w_sys&w_empr..001 empr_ver.dbf &d0F77..dbf -v -jyco -hf2 -ht&w_cd&w_empr.\'

						! &w_run

						if mfile(w_empr+'\'+'Empr_Ver.dbf')
							sele 0
							use &w_empr.\Empr_Ver alias Empr_Ver
							w_p0coem=empr_ver.p0coem
							use in empr_ver
						else
							w_p0coem=w_empr
						endif
						
						&& version nueva graba todo el path 
						w_run='&w_cd.arj e &w_path&w_sys&w_empr..001 &w_sys.\&w_p0coem.\*.* -x!&w_cd.names -v -jyco -hf2 -ht&w_cd&w_empr.\'

						wait wind 'Ejecutando: '+left(w_run,75)+iif(len(w_run)>75,chr(13)+substr(w_run,76,75),'') nowait

						! &w_run
					
						&& version vieja no grababa todo el path
						w_run='&w_cd.arj e &w_path&w_sys&w_empr..001 &w_p0coem.\*.* -x!&w_cd.names -v -jyco -hf2 -ht&w_cd&w_empr.\'

						wait wind 'Ejecutando: '+left(w_run,75)+iif(len(w_run)>75,chr(13)+substr(w_run,76,75),'') nowait

						! &w_run

						if mfile(w_empr+'\'+'Empr_Ver.dbf')
							sele 0
							use &w_empr.\Empr_Ver alias Empr_Ver
							sele Fempr
							if seek(w_empr, 'Fempr')
								Replace p0vein with Empr_Ver.p0veda, p0vees with Empr_Ver.p0veda, p0veda with Empr_Ver.p0veda
							endif
							if Empr_Ver.p0memo	&& arregla f77
								if lock77()	&& abro f77
									delete for d77empr=w_empr
									pack
									use in f77
								endif
							endif
							use in Empr_Ver
							dele file &w_empr.\Empr_Ver.dbf
						endif
						
						=delefile(w_cd+w_empr+'\','*.log')
						=delefile(w_cd,'names')

						=delefile(w_cd+w_empr+'\','*.cdx')
				
						set alter to &w_cd&w_empr.\indexar.mem
						set alter on
						set conso off
						?'indexar siempre'
						set conso on
						set alter to
						set alter off

						if mfile(w_empr+'\'+d0f77+'.dbf')
*							copy file &w_empr.\&d0f77..dbf to &d0f77..dbf	&& no lo hago porque me puede inhibir otras empresas
							&& De esta manera solo levanto lo de la empresa que estoy recuperando
							if lock77()	&& abro f77
								delete for d77empr=w_empr
								append from &w_empr.\&d0f77..dbf for d77empr=w_empr
								pack
								use in f77
							endif
							dele file &w_empr.\&d0f77..dbf
						endif							

						wait clear

					endif
				else
					wait wind 'No Existe Archivo '+w_path+w_sys+w_empr+'.001'+' a Recuperar' time 3
				endif
			endif
		
			use in Fempr
		endif
	endif
case nf_ni='DEMO'

	=advsuave('Versión Demostración. Inhibido el acceso.')

endcase
set defa to &w_cd
wait clear

if used('F77')
	sele F77
	use
endif

return


* -----------------------------------------------------
proc validvar
* -----------------------------------------------------
do case
case w_var=1 and nf_ni!='DEMO'   &&  Enviar a Proveedor

*	if lock77() && no lockeo el f77 por si es corrupto, obligo a pedir clave

	wcon   = 0
	wncla  = Space(4)
	wopci  = 'EMEMO'
	whabi  = 'C'

	wterm = nf_cate
	walet = genale()
			
	w_salida=' '
			
	wversexe=left(w_vexe,3)
	wversrel=' '+substr(w_vexe,4,2)+' '+substr(w_vexe,6,2)
			
	priv w_title
	w_title='Enviar a Proveedor'

	do utildesh.spr

	if mfile('etc\letdema.fot') and not(w_Salida='S'.OR. Lastkey() = p_esc)

		w_driv='A:'
		w_conf=1

		priv w_title
		w_title='Enviar a Proveedor'
		w_path=sys(5)+'\'
		w_part=0
		do utildr.spr

		if w_conf=1 and lastkey()<>p_esc
			if sino(' Confirma Envío de Datos a Proveedor ? ','Si')='S'
*				sele F77
*				use

				do todosuti

				erase &w_path.MEMOUTIL.001
				
				w_run='&w_cd.arj a &w_path.MEMOUTIL.001 &w_cd.*.dbf &w_cd.*.fpt *.UTI'+iif(empty(auditor),'',' '+auditor+'.*')+' -va -p1 -hf'
				wait wind 'Ejecutando: '+left(w_run,75)+iif(len(w_run)>75,chr(13)+substr(w_run,76,75),'') nowait

				! &w_run

				=delefile(w_cd,'*.uti')

			endif
		endif
	else
	   If Wexist('UTILDESH')
	      Deactivate Window UTILDESH
	      Release Window UTILDESH
	   Endif   

	   =advgrave('NO HA SIDO EJECUTADO Enviar a Proveedor')

	endif

case w_var=2 and nf_ni!='DEMO'   &&  Recibir de  Proveedor

*	if lock77() && no lockeo el f77 por si es corrupto, obligo a pedir clave

	wcon   = 0
	wncla  = Space(4)
	wopci  = 'RMEMO'
	whabi  = 'C'

	wterm = nf_cate
	walet = genale()
			
	w_salida=' '
			
	wversexe=left(w_vexe,3)
	wversrel=' '+substr(w_vexe,4,2)+' '+substr(w_vexe,6,2)
			
	priv w_title
	w_title='Recibir de Proveedor'

	do utildesh.spr

	if mfile('etc\letdema.fot') and not(w_Salida='S'.OR. Lastkey() = p_esc)

		w_driv='A:'
		w_conf=1

		priv w_title
		w_title='Recibir de Proveedor'
		w_path=sys(5)+'\'
		w_part=0
		do utildr2.spr

		if w_conf=1 and lastkey()<>p_esc
			if mfile(w_path+'MEMOFILE.001')
				if sino(' Confirma Recibir de Proveedor ? ','Si')='S'
*					sele F77
*					use

					w_run='&w_cd.arj x &w_path.MEMOFILE.001 \ -r -v -jyco -hf2 -ht&__curdrv.\'
					wait wind 'Ejecutando: '+left(w_run,75)+iif(len(w_run)>75,chr(13)+substr(w_run,76,75),'') nowait

					! &w_run

				endif
			else
				wait wind 'No Existe Archivo '+w_path+'MEMOFILE.001'+' a Recuperar' time 3
			endif
		endif
	else
	   If Wexist('UTILDESH')
	      Deactivate Window UTILDESH
	      Release Window UTILDESH
	   Endif   

	   =advgrave('NO HA SIDO EJECUTADO Recibir de Proveedor')

	endif
case w_var=3   &&  Command
	! command

case w_var=4   &&  Filler
	=seterr('OFF')
	wfile=getfile()
	=seterr('ON')

	if !empty(wfile)
		wext=right(wfile,3)

		do case
		case wext='DBF'
			fieldvec[1]=''
			use &wfile alia ff
			if !neterr()
				if used('FF')
					browse noedit nodelete noappend title wfile
					use
				endif
			endif

		case wext$'INI.SYS.BAT.TXT.DOC.UTI.CFG.FPW.FP .NT '
			modi comm &wfile

		endcase
	endif


case w_var=5   &&  HABILITACION
	if lock77()

		werr1='Este Proceso HABILITARA el Sistema'+chr(13)
		werr2='Antes de efectuarlo recuerde el horario de atención del Proveedor'
		werr3='Lunes a Viernes de 10:00 a 13:00 y 14:00 a 18:00 '+chr(13)
		werr4='Si sigue adelante y no obtiene la autorización no podrá seguir trabajando con el Sistema'

		if sino(werr1+chr(13)+werr2+chr(13)+werr3+chr(13)+werr4,'N','HABILITACION')='S'

			w_si=.t.
			if !nf_ni='DEMO'
				if nf_vers=w_vexe	
					w_si=.f.
				endif
			endif
			if nf_ni='DEMO' or w_si		&& inicial o actualizo
				w_multi=sino('Ha adquirido una licencia multiusuario ?','N','HABILITACION')='S'

				if w_multi
					if sino('Se Habilitará MULTIUSUARIO. Sigue adelante ?','N','HABILITACION')='S'
						if mfile('etc\letdemc.fot')
							copy file etc\letdemc.fot to &w_sys.2.mem
						endif
					else
						w_si=.f.
					endif
				else
					if sino('Se Habilitará MONOUSUARIO. Sigue adelante ?','N','HABILITACION')='N'
						w_si=.f.
					endif
				endif

				sele F77
				use

				if w_si

					do case
					case w_sys='GA'
						do while .t.
							d0opci='     '
							valopci=''
							do utilopci.spr
							if !valopci()
								loop
							endif
							if sino('Confirma Opciones de Instalación = '+d0opci,'N','HABILITACION')='S'
								exit
							endif
						enddo
						if !empty(val(d0opci))	&& graba el nro. de cliente en &w_sys.3.mem
							if mfile('etc\letdemb.fot')
								copy file etc\letdemb.fot to &w_sys.3.mem
							endif
							=grabacli(d0opci,w_sys)
						endif
						** Siempre multiusuario **
						if mfile('etc\letdemc.fot')
							copy file etc\letdemc.fot to &w_sys.2.mem
						endif
					case w_sys='CG'
						do while .t.
							d0opci='     '
							valopci=''
							do utilopci.spr
							if !valopci()
								loop
							endif
							if sino('Confirma Opciones de Instalación = '+d0opci,'N','HABILITACION')='S'
								exit
							endif
						enddo
						if !empty(val(d0opci))	&& graba el nro. de meses de uso en &w_sys.3.mem
							if mfile('etc\letdemb.fot')
								copy file etc\letdemb.fot to &w_sys.3.mem
							endif
							=grabacli(d0opci,w_sys)
						endif
					case w_sys='IW'
						do while .t.
							d0opci='IC   '
							valopci='IC'
							do utilopci.spr
							if sino('Confirma Opciones de Instalación = '+d0opci,'N','HABILITACION')='S'
								exit
							endif
						enddo
						do case
							case 'IC'$d0opci
								if mfile('etc\letdemb.fot')
									copy file etc\letdemb.fot to &w_sys.3.mem
								endif
							case 'I'$d0opci
								if mfile('etc\letdemd.fot')
									copy file etc\letdemd.fot to &w_sys.3.mem
								endif
							case 'C'$d0opci
								if mfile('etc\letdeme.fot')
									copy file etc\letdeme.fot to &w_sys.3.mem
								endif
							otherwise
								if mfile('etc\letdemf.fot')	&& sin opciones
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
						endcase
						if !empty(val(d0opci))	&& graba opciones de sistema y de meses de uso en &w_sys.3.mem
							if mfile('etc\letdemf.fot')	&& sin opciones
								copy file etc\letdemf.fot to &w_sys.3.mem
							endif
							=grabacli(d0opci,w_sys)
						endif
					case w_sys='GW'
						do while .t.
							d0opci='M'
*							valopci='MSP.MP'		&& R.05 Mariano
*							valopci='MSP.MP.MV.MC.MVC.MVF.MCF.MVCF'	&& R.05 Mariano	&& R.06 pa
							valopci='MSP.MSY.MP.MY.MV.MC.MVC.MVF.MCF.MVCF'	&& R.06 pa
							do utilopci.spr
							if sino('Confirma Opciones de Instalación = '+d0opci,'N','HABILITACION')='S'
								exit
							endif
						enddo
						do case
							&& R.05b Mariano
							case 'MVCF'$d0opci	&& multiempresa, Ventas, Compras y Fondos
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							&& R.05e Mariano
							case 'MSP'$d0opci	&& Multiempresa, stock detallado y produccion
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)	
							&& R.05b Mariano
							case 'MVC'$d0opci	&& multiempresa, Ventas y Compras
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							case 'MVF'$d0opci	&& Multiempresa, Ventas y Fondos
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							case 'MCF'$d0opci	&& multiempresa, Compras y Fondos
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							&& R.05e Mariano
							&& R.06b Mariano
							case 'MPY'$d0opci	&& Multiempresa y Produccion y Proyectos
								if mfile('etc\letdemb.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							case 'MSY'$d0opci	&& Multiempresa y Stock Detallado y Proyectos
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							case 'MY'$d0opci	&& Multiempresa y Proyectos
								if mfile('etc\letdemb.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)		&& R.06 Mariano
							case 'MSY'$d0opci	&& Multiempresa y Stock Detallado y Proyectos
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							&& R.06e Mariano
							case 'MP'$d0opci	&& Multiempresa y Produccion
								if mfile('etc\letdemb.fot')
									copy file etc\letdemb.fot to &w_sys.3.mem
								endif
							case 'MS'$d0opci	&& Multiempresa y Stock Detallado
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							&& R.05b Mariano
							case 'MV'$d0opci	&& Multiempresa y ventas
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							case 'MC'$d0opci	&& multiempresa y Compras
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							&& R.05e Mariano
							case 'SP'$d0opci	&& Stock detallado y produccion
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							&& R.06b Mariano
							case 'PY'$d0opci	&& Produccion y Proyectos
								if mfile('etc\letdemb.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							case 'SY'$d0opci	&& Stock Detallado y Proyectos
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							case 'Y'$d0opci	&& Proyectos
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							&& R.06e Mariano
							case 'M'$d0opci		&& Multiempresa
								if mfile('etc\letdemd.fot')
									copy file etc\letdemd.fot to &w_sys.3.mem
								endif
							case 'P'$d0opci		&& Produccion
								if mfile('etc\letdeme.fot')
									copy file etc\letdeme.fot to &w_sys.3.mem
								endif
							case 'S'$d0opci		&& Stock Detallado
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)	
							&& R.05b Mariano
							case 'V'$d0opci		&& Ventas
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							case 'C'$d0opci		&& Compras
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							&& R.05e Mariano
							otherwise
								if mfile('etc\letdemf.fot')	&& sin opciones
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
						endcase
						if !empty(val(d0opci))	&& graba opcion de sistema y de meses de uso en &w_sys.3.mem
							if mfile('etc\letdemf.fot')	&& sin opciones
								copy file etc\letdemf.fot to &w_sys.3.mem
							endif
							=grabacli(d0opci,w_sys)
						endif
					case w_sys='SE'
						do while .t.
							d0opci='M'
							valopci='M'
							do utilopci.spr
							if sino('Confirma Opciones de Instalación = '+d0opci,'N','HABILITACION')='S'
								exit
							endif
						enddo
						do case
							case 'M'$d0opci
								if mfile('etc\letdemd.fot')
									copy file etc\letdemd.fot to &w_sys.3.mem
								endif
							otherwise
								if mfile('etc\letdemb.fot')	&& sin opciones
									copy file etc\letdemb.fot to &w_sys.3.mem
								endif
						endcase
						if !empty(val(d0opci))	&& graba opcion de sistema y de meses de uso en &w_sys.3.mem
							if mfile('etc\letdemb.fot')	&& sin opciones
								copy file etc\letdemb.fot to &w_sys.3.mem
							endif
							=grabacli(d0opci,w_sys)
						endif
					case w_sys='SJ'
						do while .t.
							d0opci='J    '
							valopci='JR.JH'						&& R.01 Raúl				
							do utilopci.spr
							if sino('Confirma Opciones de Instalación = '+d0opci,'N','HABILITACION')='S'
								exit
							endif
						enddo
						do case
&& R.01b Raúl
							case 'JH'$d0opci						
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							case 'H'$d0opci						
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
&& R.01e Raúl
							case 'JR'$d0opci						
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
								**Borro multiusuario**
								erase &w_sys.2.mem
							case 'J'$d0opci
								if mfile('etc\letdemb.fot')
									copy file etc\letdemb.fot to &w_sys.3.mem
								endif
							case 'R'$d0opci	
								if mfile('etc\letdemf.fot')
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
								**Borro multiusuario**
								erase &w_sys.2.mem

							case betw(right(allt(d0opci),4),'R000','R999')	&& opcion reducida y con sector
								if mfile('etc\letdemf.fot')	&& sin opciones
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
								=grabacli(d0opci,w_sys)
							otherwise
								if mfile('etc\letdemf.fot')	&& sin opciones
									copy file etc\letdemf.fot to &w_sys.3.mem
								endif
						endcase
						if !empty(val(d0opci))	&& graba opcion de sistema y de meses de uso en &w_sys.3.mem
							if mfile('etc\letdemf.fot')	&& sin opciones
								copy file etc\letdemf.fot to &w_sys.3.mem
							endif
							=grabacli(d0opci,w_sys)
						endif
					endcase

					if nf_ni='DEMO'	&& si esta en demo habilito sino actualizo -> no creo habi.tst
						_text=f_create('HABI.TST')
						if _text = -1
							=advgrave('No Pudo Crearse HABI')
							return .f.
						endif
					endif

					set cons off
					set textmerge on
               text
	           <<date()>> <<time()>>	
	           endtext
					set cons on
					set textmerge off

					=f_close(_text)

					exe=w_sys+'P000 01 -T -CCONFIG.FPW'

					run /N &exe

					cancel
				endif
			else
				wait window 'El sistema ya se encuentra habilitado'
			endif
		endif
	endif

case w_var=6   &&  DESHABILITACION

	if lock77()

		werr1='Este Proceso DESHABILITARA el Sistema'+chr(13)
		werr2='Antes de efectuarlo recuerde el horario de atención del Proveedor'
		werr3='Lunes a Viernes de 10:00 a 13:00 y 14:00 a 18:00  '+chr(13)
		werr4='Si sigue adelante y no obtiene la autorización no podrá seguir trabajando con el Sistema'

		if sino(werr1+chr(13)+werr2+chr(13)+werr3+chr(13)+werr4,'N','DESHABILITACION')='S'
			
			wcon   = 0
			wncla  = Space(4)
			wopci  = 'DESHA'
			whabi  = 'C'

			wterm = nf_cate
			walet = genale()
			
			w_salida=' '
			
			wversexe=left(w_vexe,3)
			wversrel=' '+substr(w_vexe,4,2)+' '+substr(w_vexe,6,2)
			
			priv w_title
			w_title='DESHABILITAR'
			
			do utildesh.spr

			if mfile('etc\letdema.fot') and not(w_Salida='S'.OR. Lastkey() = p_esc)
				*
				* puede deshabilitar desde cualquier maquina entrando con 01
				*
				copy file etc\letdema.fot to &w_sys..mem
				if mfile('etc\letdemb.fot')
					copy file etc\letdemb.fot to &w_sys.1.mem
					do case
					case adir(x_opci,'etc\letdem?.fot')>3	&& sistema con opciones
						rele x_opci
						copy file etc\letdemb.fot to &w_sys.3.mem
					otherwise	&& sistema sin opciones
						rele x_opci
						w_file='\&w_sys.\&w_sys.3.mem'
						if mfile(w_file)
							* Borra archivo de opciones
							dele file &w_file
						endif
					endcase
				endif

				w_file='\&w_sys.\&w_sys.2.mem'
				if mfile(w_file)
					* en la que entra borra multiusuario
					dele file &w_file
				endif

				w_file=dimaqi()+d0fise
				if mfile(w_file)
					* en la que entra borra archivo de seguridad
					dele file &w_file
				endif

				&& R.03b Mariano
				if mfile('ssf000.prt')
					* en la que entra borra archivo de proteccion de hardware
					dele file ssf000.prt
				endif
				&& R.03e Mariano

				=advsuave('Se Ha deshabilitado Exitosamente')

				=advsuave('Si desea seguir usando UTIL deberá ingresar nuevamente')
				cancel

			else
			   If Wexist('UTILDESH')
			      Deactivate Window UTILDESH
			      Release Window UTILDESH
			   Endif   

				=advgrave('NO HA SIDO POSIBLE DESHABILITAR')

			endif
		endif
	endif

case w_var=7 and nf_ni!='DEMO'   &&  Sistema Indices

	if lock77()

		werr1='Este Proceso ELIMINA LOS INDICES de las Bases de Sistema'+chr(13)
		werr2='Antes de efectuarlo recuerde el horario de atención del Proveedor'
		werr3='Lunes a Viernes de 10:00 a 13:00 y 14:00 a 18:00  '

		if sino(werr1+chr(13)+werr2+chr(13)+werr3,'N','SISTEMA INDICES')='S'
			=delefile(w_cd,'*.cdx')
			&& R.02b Mariano
			set alter to &w_cd.indexar.mem
			set alter on
			set conso off
			?'indexar siempre'
			set conso on
			set alter to
			set alter off
			&& R.02e Mariano
		endif
	endif

case w_var=8 and nf_ni!='DEMO'   &&  Empresa Indices

	if lock77()

		werr1='Este Proceso ELIMINA LOS INDICES de las Bases de Empresa'+chr(13)
		werr2='Antes de efectuarlo recuerde el horario de atención del Proveedor'
		werr3='Lunes a Viernes de 10:00 a 13:00 y 14:00 a 18:00  '

		if sino(werr1+chr(13)+werr2+chr(13)+werr3,'N','EMPRESA INDICES')='S'
			if empresas='gvf015' or empresas='sef015'	&& gestion o seguimiento
				w_empr='   '
				w_form='999'
			else
				w_empr='  '
				w_form='99'
			endif
			w_conf=1

			priv w_title
			w_title='Elimina Indices de Empresa'

			if empty(empresas) or !mfile(empresas+'.cdx')
				if empty(empresas)
					=advsuave('Sistema sin empresas para recuperar', w_title)
				else
					=advsuave('Deberá primero entrar al sistema para ejecutar esta opción', w_title)
				endif
			else

				sele 0
				use &empresas. alias 'Fempr' order p0coem shared 
				if neterr()
					wait wind 'No se puede realizar el Recupero' nowait
				else

					do utilemp.spr

					w_empr=allt(w_empr)

					if w_conf=1 and lastkey()<>p_esc
						=delefile(w_cd+w_empr+'\','*.cdx')
						&& R.02b Mariano
						set alter to &w_cd.&w_empr.\indexar.mem
						set alter on
						set conso off
						?'indexar siempre'
						set conso on
						set alter to
						set alter off
						&& R.02e Mariano
					endif
				endif
			
				use in Fempr
			endif
		endif
	endif

case w_var=100   &&  Acceso Directo

	werr1='Este Proceso Instalará el acceso directo al sistema en esta computadora'+chr(13)
	werr2='Antes de efectuarlo recuerde el horario de atención del Proveedor'
	werr3='Lunes a Viernes de 10:00 a 13:00 y 14:00 a 18:00  '+chr(13)

	if sino(werr1+chr(13)+werr2+chr(13)+werr3,'N','ACCESO DIRECTO')='S'

		exe=w_sys+'ETC\ACCESO'+w_sys

		! &exe

	endif
case nf_ni='DEMO'

	=advsuave('Versión Demostración. Inhibido el acceso.')

endcase
set defa to &w_cd
wait clear
if used('F77')
	sele F77
	use
endif

return

* -----------------------------------------------------
proc todosuti
* -----------------------------------------------------
v_in=adir(v_file,'*.uti')
if !empty(v_in)
	for v_i=1 to v_in
		v_fi=v_file[v_i,1]
		dele file &v_fi
	next
endif

wait wind 'Generando CONFIG.UTI....' nowait
if mfile('c:\config.sys')
	copy file c:\config.sys to &w_cd.config.uti
endif

wait wind 'Generando AUTOEXEC.UTI....' nowait
if mfile('c:\autoexec.bat')
	copy file c:\autoexec.bat to &w_cd.autoexec.uti
endif

wait wind 'Generando SET.UTI....'  nowait
! set > set.uti

wait wind 'Generando WIN.UTI....'  nowait
if mfile(__windir+'win.ini')
	copy file &__windir\win.ini to &w_cd.win.uti
endif

wait wind 'Generando CONFPW.UTI....'  nowait
if mfile('config.fpw')
	copy file config.fpw to &w_cd.confpw.uti
endif

wait wind 'Generando USERS.UTI....'  nowait
! dir &__curdir.users\*.* /ad /on > &w_cd.users.uti

wait wind 'Generando MEM.UTI....'  nowait
! mem /c > &w_cd.mem.uti

wait wind 'Generando DIRSY.UTI....'  nowait
! dir &__curdir.*.* /ad /on > &w_cd.dirsy.uti

wait wind 'Generando RED.UTI....'  nowait

if crearedbat()
	! red
endif

wait clear

return

* -----------------------------
function crearedbat
* -----------------------------

_text=f_create('RED.BAT')
if _text = -1
	=advgrave('No Pudo Crearse RED.BAT')
	return .f.
endif

set cons off
set textmerge on

text
REM Novell
nver         >> &w_cd.RED1.UTI < ent.
nlist * /c   >> &w_cd.RED1.UTI < ent.
map          >> &w_cd.RED1.UTI < ent.
chkvol       >> &w_cd.RED1.UTI < ent.

REM WorkGroup
net use      > &w_cd.RED.UTI

copy &w_cd.RED.UTI+&w_cd.RED1.UTI &w_cd.RED.UTI

del &w_cd.red.uti
del &w_cd.red1.uti

endtext

set cons on
set textmerge off

return f_close(_text)

* -----------------------------
function valmaqini
* -----------------------------
if p_par1<>'01' 
	show get w_var,5 disable
	show get w_var,6 disable
endif

if nf_ni='DEMO'
	show get w_var,6 disable
endif

return .t.


* -----------------------------
function lock77
* -----------------------------
l_retu=.t.
if !file(d0f77+'.dbf')
	=advgrave('No existe '+d0f77+chr(13)+'No puede seguir adelante')
	l_retu=.f.
else
	sele 0
	use &d0F77 excl alia F77
	if neterr()
		=advgrave('Hay usuarios Utilizando el sistema'+chr(13)+'No puede seguir adelante')
		l_retu=.f.
	endif
endif
return l_retu

* -----------------------------
function valopci
* -----------------------------

do case
	case w_sys='GA'	&& Generador de archivos
		if !between(alltrim(d0opci),'0000','9999') or !len(alltr(d0opci))=4
			wait window 'Las opciones deben ser [0000...9999]'
			return (.f.)
		endif
	otherwise
		if !(len(alltrim(d0opci))=0 or iif(val(d0opci)>0, iif(len(opca())>0, opca()$valopci,.t.), iif(len(opca())>0, opca()$valopci,.f.)))
			wait window 'Las opciones pueden ser alguna o todas de éstas,  '+valopci
			return (.f.)
		endif
endcase
return (.t.)

* -----------------------------
function grabacli
* -----------------------------
parameters w_ncli,w_sys

private all except w_*

restore from &w_sys.3.mem additive

z_op = decript(z_op,3)
z_op = strtran(z_op,'     ',w_ncli)
z_op = encript(z_op,3)

z_ve=encript('×ì·eTÈ{Û[]&!#%^~'+w_sys+repl('',asc(w_sys))+'00000000'+;
	'×ì·eTÈ{Û[]&!#%^~',3)

save to &w_sys.3.mem all except w_*

return

*-R ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
proc browempr
*-R ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

activate screen

push menu _msysmenu

sele Fempr
go top

defi wind w_most from 0,0 to 15,79 color scheme 10

browse  ;
	fields p0coem :h='Código':v=fenter() :f ,;
	p0empr :h='Nombre' ,;
	p0path :h='Path'    ;
	title 'ELECCION DE EMPRESAS' ;
	nomenu ;
	noedit ;
	nodelete ;
	valid :f salebrow(lastkey()) ;
	font 'Arial', 10 ;
	noappend ;
	window w_most

rele wind w_most

pop menu _msysmenu

private w_retu

if lastkey()=p_ctrl_w
	w_retu=p0coem	
else	
	if empresas='gvf015' or empresas='sef015'	&& gestion o seguimiento
		w_retu='000'
	else
		w_retu='00'
	endif
endif

return(w_retu)

*-R ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
FUNCTION VALCLAVE
*-R ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
PRIVATE wvopc, ww,wwcla,wok

=multi()

wvopc=0
for ww=1 to 5
    wvopc=wvopc+iif(asc(subst(wopci,ww,1)) <> 32,;
                    asc(subst(wopci,ww,1)),0)
next

wwcla=gencla(val(wacla),val(walet) + wvopc + iif(!empty(whabi),asc(whabi),0), '1')
wOk  = .f.

wncla= strcero(wncla)

if wncla = wwcla
   wOk=.t.
   wcon=3
else
   wOk=.f.
   Wait Wind 'Número de Autorización Incorrecto ...'
   wcon = wcon + 1
   wncla= Space(4)
endif

if wcon = 3
   w_salida='S'
   wOk=.t.
   wcon=0
endif    


RETURN(wok)

* -----------------------------
function OPCA
* -----------------------------
private w_opca, w_i, w_aux

w_opca=''
for w_i=1 to 5
	w_aux=substr(d0opci,w_i,1)
	if isalpha(w_aux)
		w_opca=w_opca+substr(d0opci,w_i,1)
	endif
endfor

return(w_opca)

* -----------------------------
function OPNU
* -----------------------------
private w_opnu, w_i, w_aux

w_opnu=''
for w_i=1 to 5
	w_aux=substr(d0opci,w_i,1)
	if isdigit(w_aux)
		w_opnu=w_opnu+w_aux
	else
		if isalpha(w_aux) and len(w_opnu)>0
			exit
		endif
	endif
endfor

return(w_opnu)

* --------------------------------------------------------------------
function dispsc		&& dispositivo para sistema completo automatico
* --------------------------------------------------------------------
private a, b
a=dow(date())-1
do case
	case a=1
		b='1_lun'
	case a=2
		b=+'2_mar'
	case a=3
		b='3_mie'
	case a=4
		b='4_jue'
	case a=5
		b='5_vie'
	case a=6
		b='6_sab'
	case a=7
		b='7_dom'
endcase

w_path=p_par2+'\_bkmemo\'+b

if w_conf=1 && procesar
	do case
		case !dispok(left(w_path,2))
			=advsuave('No se tiene permiso Read/Write a este directorio')
			show get w_conf,1 disable
			w_conf=2
			return .f.
		otherwise
			=creadir(left(w_path,3)+'_bkmemo')
			=creadir(w_path)
			w_path=w_path+'\'
	endcase
endif

return
