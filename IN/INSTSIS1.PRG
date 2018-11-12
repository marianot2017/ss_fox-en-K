*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ Sys.Info ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H Programa        : instsis1.prg -> Generacion diskettes de instalacion
*-H
*-H Fecha de inicio :
*-H Fecha de fin    :
*-H
*-H Actualizaciones
*-H
*-H  Fecha       Programmer      Comentarios
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
private all like w_*

** Salvado de estados anteriores

w_curobj=_curobj     && Salva numero de objeto en el read activo
w_alan=alias()       && Salva alias vigente al llamado del programa
w_wind=wontop()      && Salva ventana vigente al llamado del programa
w_rdlevel=rdlevel()  && Salva Nro. de read activo

** Variables internas

w_prog=upper(prompt())

w_alta=.f.
w_recn=0

** Datos del archivo a mantener
w_pfile='1'

w_disc=1

w_cant1=adir(wfile1,'\Instal??.exe')
w_cant2=adir(wfile2,'\Instal??.?')
if w_cant2>0
	=asort(wfile2)
endif
w_cant3=adir(wfile3,'\Instal??.??')
if w_cant3>0
	=asort(wfile3)
endif

if w_cant1+w_cant2+w_cant3=0
	=advgrave('No se pueden generar diskettes')
else
	sele 0
	create dbf &d0f99.c (p0sele c(1), p0disco c(7), p0cont c(20))
	use &d0f99.c alias f99c exclusive

	insert into f99c values ('', 'Disk.'+strcero(str(1,2)), wfile1[1,1])
	for i=1 to w_cant2
		insert into f99c values ('', 'Disk.'+strcero(str(w_cant1+i,2)), wfile2[i,1])
	endfor
	for i=1 to w_cant3
		if val(substr(wfile3[i,1], at('.', wfile3[i,1])+1,2))>=10
			insert into f99c values ('', 'Disk.'+strcero(str(w_cant1+w_cant2+i,2)), wfile3[i,1])
		endif
	endfor

	go top

	w_disk=0
	w_cont=0
	w_sali=0
	
	w_cont1=0
	w_sali1=0

	w_todo=0
	w_algu=0
	w_inst2=0
	w_sali2=0

	do instsist.spr	&& principal
	
endif

w_title=''

if wexist(w_wind) and !empty(w_wind)
	acti wind (w_wind)
endif

=closall()

dele file &d0f99.c.dbf

return

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure when1
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_show
private w_retu,w_vari

w_retu=.t.
w_vari=varread()

w_recno=recno('f99c')

if w_vari='W_DISC'

	do case

	case str(lastkey(),3)$'110. 78'	&& No generar

		w_opc=1

		clear read

	case str(lastkey(),3)$'116. 84'	&& marcar Todos

		w_opc=2

		repl all f99c.p0sele with 'X'

	case str(lastkey(),3)$'114. 82'	&& desmarcaR todos

		w_opc=3

		repl all f99c.p0sele with ' '

	case str(lastkey(),3)$'109. 77'	&& Marcar

		w_opc=4

		if f99c.p0sele=' '
			repl f99c.p0sele with 'X'
		endif

	case str(lastkey(),3)$'100. 68'	&& Desmarcar

		w_opc=5

		if f99c.p0sele='X'
			repl f99c.p0sele with ' '
		endif

	case str(lastkey(),3)$'103. 71'	&& Generar

		w_opc=6
		
		do cons1
		clear read

	endcase

	show get w_disc

endif

count for f99c.p0sele='X' to w_cant

if w_cant=0
	show get w_opc,6 disable
else
	show get w_opc,6 enable
endif

go w_recno in f99c

if f99c.p0sele='X'
	show get w_opc,4 disable
	show get w_opc,5 enable
else
	show get w_opc,4 enable
	show get w_opc,5 disable
endif

return


* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure valid1
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_show
private w_retu,w_vari

w_retu=.t.
w_vari=varread()

if w_vari='W_DISK'
	if w_disk=1
		w_cont1=0
		w_sali1=0
		w_sali2=0

		do instsis1.spr	&& primer mensaje
		
		do while w_cont1=1 and w_sali2<>1
			w_todo=0
			w_algu=0
			w_inst2=0
			w_sali2=0
			w_leye='Nota: Antes de iniciar deberแ contar con '+allt(str(reccount('f99c'),2))+;
					iif(reccount('f99c')=1,' diskette formateado y completamente vacํo.',' diskettes formateados y completamente vacํos.')
			do instsis2.spr	&& segundo mensaje
	
			if w_algu=1
				repl all f99c.p0sele with ''
				w_opc=0
				do instsis3.spr && Screen de eleccion de discos
			endif
	
			if w_inst2=1
				=winword('instalad.doc')
			endif
		enddo
		_curobj=objnum(w_sali)
		
	endif
endif
	
if wontop('')

	if w_vari='W_CONT'
		if sys(2003)='\SS_FOX\IN'
			wait wind 'Instalando...' time 1
			clear read
		else
			if file('\LEEME.DOC')
				=winword('\leeme.doc')
				=advgrave('Se recomienda leer el documento LEEME.DOC, antes de seguir con la instalaci๓n del sistema.', 'INSTALACION')
			endif
			w_file=wfile1[1,1]
			run /N \&w_file
			clear read
		endif
	endif

	if w_vari='W_SALI'
		clear read
	endif

endif

if wontop('INSTSIS1')

	if w_vari='W_CONT1'
		clear read
	endif

	if w_vari='W_SALI1'
		clear read
	endif
	
endif

if wontop('INSTSIS2')

	if w_vari='W_TODO'
		if w_todo=1
			repl all f99c.p0sele with 'X'
			w_opc=6
			do cons1
		endif
	endif

	if w_vari='W_ALGU'
		clear read
	endif
	
	if w_vari='W_INST2'
		clear read
	endif

	if w_vari='W_SALI2'
		clear read
	endif

endif

if wontop('INSTSIS3')

	if w_vari='W_OPC' or w_vari='W_DISC'
		do case
			case w_opc=1	&& No generar
				clear read
			case w_opc=2	&& marcar Todos
				repl all f99c.p0sele with 'X'
			case w_opc=3	&& desmarcaR todos
				repl all f99c.p0sele with ' '
			case w_opc=4	&& Marcar
				if f99c.p0sele=' '
					repl f99c.p0sele with 'X'
				endif
			case w_opc=5	&& Desmarcar
				if f99c.p0sele='X'
					repl f99c.p0sele with ' '
				endif
			case w_opc=6	&& Generar
				do cons1
				clear read
		endcase

		show get w_disc
		show get w_opc
	endif
	
endif

return

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure cons1
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

sele f99c

count for f99c.p0sele='X' to w_cant

if w_opc=6	&& Genera

	if w_cant=1 && una empresa

		if sino('Desea generarlo ?','No', 'Generaci๓n diskettes de instalaci๓n')='N'
			return
		endif

	else

		if sino('Desea generarlos ?','No', 'Generaci๓n diskettes de instalaci๓n')='N'
			return
		endif

	endif

else

	return

endif

p_cancela=.t.
on key label esc do cancela with .t.

go top in f99c

**elijo dispositivo**
w_driv=Elijeflopy('DESTINO DE GENERACION')

load isdiskin.bin

w_flag=.f.
w_resp=''
do while !eof('f99c') and p_cancela
	if f99c.p0sele=' '
		skip in f99c
		loop
	endif
	
	if w_flag
		w_resp=advsuave('Inserte el '+f99c.p0disco+' a generar en la unidad '+w_driv,'',.t.)
		if w_resp='Cancelar'
			do cancela with .t.
		endif
	endif
	
	do while p_cancela and !valiflop(w_driv)
	enddo
	
	if p_cancela
		wait wind 'Generando '+f99c.p0disco+'...' nowait

		w_file=f99c.p0cont

		copy file \&w_file. to &w_driv.\&w_file.
	
		wait clear
	
		=advsuave('Retire el '+f99c.p0disco+' generado')
		w_flag=.t.

		skip in f99c
	endif
enddo

release module isdiskin.bin

on key label esc

return

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function elijeflopy
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_title

load isdiskin.bin

private w_unid,e_dr

w_unid=1
e_dr='A:'

do while .t. and p_cancela
	do elijeflo.spr

	if lastkey()=p_esc and p_cancela
		loop
	else
		exit
	endif

	if w_unid=1
		e_dr='A:'
	else
		e_dr='B:'
	endif

	exit
enddo

release module isdiskin.bin

return (e_dr)

*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function valiflop
*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_driv

private w_retu,w_auxi,w_resp
w_retu=.t.
w_auxi=w_driv
w_resp=''

call isdiskin.bin with w_driv

if w_driv=='0:'
	w_resp=advsuave('Inserte el '+f99c.p0disco+' a generar en la unidad '+w_auxi,'',.t.)
	w_retu=.f.
else
	w_dran=set('default')
	set default to &w_auxi.\
	w_cant=adir(wfile1,w_auxi+'\*.*')
	if diskspace()<1450000
		if ascan(wfile1,upper(allt(f99c.p0cont)))=0
			w_resp=advgrave('El '+f99c.p0disco+' contiene archivos. Insertar un diskette vacio en la unidad '+w_auxi,'',.t.)
			w_retu=.f.
		endif
	endif
	set default to &w_dran
endif

if w_resp='Cancelar'
	do cancela with .t.
endif

return (w_retu)
