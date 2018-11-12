*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ Sys.Info ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H Programa        : ssp003l.prg -> Listador de perfiles
*-H
*-H Fecha de inicio : 
*-H Fecha de fin    :
*-H
*-H Updates
*-H
*-H  Fecha       Programmer      Comentarios
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PRIVATE ALL LIKE w_*

if rdlevel()=1
	p_popup=popup()
	p_bar=bar()
endif

push key clear      && Salva estados de teclas 
push menu _msysmenu && Salva estado de menu
set skip of menu _msysmenu .t.

* Apertura de archivos ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*fieldvec[1] = 'f00'
fieldvec[1] = 'S01'
fieldvec[2] = 'S02'
fieldvec[3] = 'S03'

*use (d0f00)in 0 alias 'f00' 
use ssf001 in 0 alias 's01' order 'd1perf'
if !used('s02')
	use ssf002 in 0 alias 's02' order 'd2user'
else
	set order to tag 'd2user' in s02
endif
use ssf003 in 0 alias 's03' order 'd3perf'

if neterr()
		
	pop key
	pop menu _msysmenu
	fieldvec = ''
	=closall()
	return

endif

fieldvec=''

* Variables ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

w_pfile = '03l'
w_prog  = upper(prompt())
w_alias = 'S03'
w_title = upper(prompt())
w_alta  =.f.

w_pede  = ''
w_peha  = 'ZZZZZZZZZZ'
w_chk01 = .f.
w_chk02 = .f.

do ssm998.mpr

p_congtit=.f.

do sss003l.spr

pop key
pop menu _msysmenu
=closall()
return

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
Procedure Cons03l
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
if !valid03l(.t.)
	return
endif

use ssr003la.frx in 0 alias freport
sele freport
p_width=width
p_report=dbf()
use


select s03
set filter to between(d3perf,w_pede,w_peha)
go top

do repdest  && Setea variables internas del reporte

do case
	case !w_chk01 and !w_chk02
		p_report='ssr003la'
*		report form ssr003la &p_repclaus
	
	case w_chk01 or w_chk02
		
		if w_chk01
			select s03
			set relation to d3perf into s01
			set skip to s01
			p_report='ssr003lb'
*			report form ssr003lb &p_repclaus
*			set skip to
*			set relation to
		endif
		
		if w_chk02
			select s03
			set relation to d3perf into s02
			set skip to s02
			p_report='ssr003lc'
*			report form ssr003lc &p_repclaus
*			set skip to
*			set relation to
		endif

endcase

if !empty(p_repclaus) &&(debe ser preview o to printer)
	=rep_form()
	p_report=''
endif

do represet && Resetea estado

select s03
set skip to
set relation to
set filter to

return

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
Function valid03l
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PARAMETERS w_show

if empty(parameters())
	w_show = .f.
endif

PRIVATE w_retu,w_vari
w_retu=.t.
w_vari=varread()

if w_vari = 'W_PEDE' and !w_show
	if lastk() = p_f4
		do fhelp with 'W_PEDE','','ssp003','s03','d3perf','d3perf','',.f.,'w_retu'
	endif
endif

if w_vari = 'W_PEHA' and !w_show
	if lastk() = p_f4
		do fhelp with 'W_PEHA','','ssp003','s03','d3perf','d3perf','',.f.,'w_retu'
	endif
endif

return(w_retu)

***puesto adrede para que incluya el report al proyecto**
report form ssr003la
report form ssr003lb
report form ssr003lc
