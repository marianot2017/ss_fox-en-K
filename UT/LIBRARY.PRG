external array _pdparms,fieldvec,aarray,aorden,aclave,  w_veract

*	Release : 18		(Doc. wn SUeldos 610)

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function lib
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
** Syntaxis ...: char = LIB()
**
** Fecha.......: Nov 1993
**
** Servicio....: Retorna el nฃmero de libreria.
**
** Ejemplo.....: ? LIB()
**
return '36'


*
*_______________________________________________________________________
* VARIABLES Y VECTORES PUBLICOS QUE DEBEN SER DECLARADOS EN EL
* PROGRAMA $$$000 DEL SISTEMA
*
*    wsuper= .F.
*    Dimension Fieldvec(1)
*
*______________________________________________________________________
*             << EXPLICACION DE CADA COMPONENTE >>
*______________________________________________________________________

* ARRAYS EXTERNOS
*        FIELDVEC definido en :CGP000.PRG
*                 se usa para :VECTOR donde se ingresan los alias
*                 para que la funciขn de error ERRHAND (de Library.prg)
*                 pueda ubicar los ALIAS de los archivos que no se
*                 pudieron abrir .
*                 SE USA EN TODOS LOS PROGRAMAS
*
*        AARRAY   Son Vectores que usa la FUNCION
*        AORDEN   ANARCHY( de Library.prg ), QUE ES
*        ACLAVE   SIMILAR A LA FHELP (facilita consultas
*                 por F2,F4, altas de F5, pero permite
*                 manejar claves de กndices de m s de
*                 un campo .SE DEFINE EN CADA PROGRAMA
*                 QUE LA NECESITA COMO PRIVADA.
*
*       _PDPARMS  Es un array que usa la rutina de Impresiขn
*_________________________________________________________________________
*
* VARIABLES PUBLICAS QUE RECIBE LA LIBRARY.PRG
*
*
* WSUPER.....................Variable pฃblica declarada en el 000
*                            de tipo Lขgico.Cuando es .T. indica
*                            que est  logeado el Supervisor.
*                            EN LIBRARY.PRG es invocada en MPROT(),
*
*_________________________________________________________________________________
* FUNCIONES RELACIONADAS CON LA PROTECCION (Sกntesis)
*
* MPROT()---- (cuando es el supervisor)-->PRGRABA
*
* PRGRABA= Agrega ข borra los registros del s02.
*
*______________________________________________________________________________
*
function setup
**  Syntaxis ...: nul = SETUP()
**
** Fecha.......: Set 1988
**
** Servicio....: Inicializa todas las variables que utiliza la Libreria
**
******************************************************************************
* Seguridad
public lresp777, wsuper, lresp
lresp777 = .f.
wsuper =.f.
lresp = .f.

&& R.18b Ra๚l			 Variable para la ENCRIPTA
PUBLIC factor
factor  		= 7
&& R.18e Ra๚l

set library to foxtools.fll

**** Teclas
public p_f1,p_f2,p_f3,p_f4,p_f5,p_f6,p_f7,p_f8,p_f9,p_f10,p_f11,p_f12
public p_ins,p_home,p_del,p_end,p_pgup,p_pgdn,p_up,p_down,p_right,p_left,;
	p_esc,p_enter,p_bspace,p_tab,p_ctrl_enter,p_ctrl_ins,p_space
public p_ctrl_w,p_ctrl_q,p_ctrl_a,p_ctrl_f4,p_ctrl_f2, p_curobj,;
	p_baropc1, p_baropc2, p_baropc3, p_baropc4, p_ayuda, p_date,;
	p_ctrl_tab, p_sh_tab, p_sh_pgup, p_sh_pgdn, p_sh_up, p_sh_down

p_date={} && dia de habilitacion para controlar expiracion por tiempo

p_ayuda=.f.


store 1 to p_curobj, p_baropc1, p_baropc2, p_baropc3, p_baropc4


p_f1          =  28
p_f2  		  =  -1
p_f3          =  -2
p_f4          =  -3
p_f5          =  -4
p_f6          =  -5
p_f7          =  -6
p_f8          =  -7
p_f9          =  -8
p_f10         =  -9
p_f11         = 133
p_f12         = 134

p_ins         =  22
p_home        =   1
p_del         =   7
p_end         =   6
p_pgup        =  18
p_pgdn        =   3
p_up          =   5
p_right       =   4
p_left        =  19
p_down        =  24
p_esc         =  27
p_enter       =  13
p_bspace      = 127
p_tab         =   9
p_ctrl_enter  =  10
p_ctrl_ins    = 146
p_space       =  32

p_ctrl_a      =   1
p_ctrl_w      =  23
p_ctrl_q      =  17
p_ctrl_f4     =  97
p_ctrl_f2     =  95

p_ctrl_tab	  =  148
p_sh_tab	  =  15
p_sh_pgup     =  51
p_sh_pgdn	  =  57
p_sh_up		  =  56
p_sh_down	  =	 50

** Variables para impresion **
public p_repout,p_repfile,p_reptype,p_pdsetup,p_printer,p_cancela,;
	p_resource,p_error,p_alias,p_report,p_congtit,p_repclaus,;
	p_sepa, p_poin, p_memo, p_repfields, p_repfor, p_repfor2, p_repwhile, p_repdos,;
	p_preview, p_lmargrep, p_reptype2,p_dparms7,p_dparms8,p_dparms9,p_dparms10
public p_mail	&& R.11 pa

p_repout='Pantalla'
p_repclaus=''
p_reptype='TXT   Pantalla'
p_reptype2='LPT1'
p_repfile=''
p_repfields=''
p_repfor=''
p_repfor2=''
p_repwhile=''
p_repdos=0
p_preview=0
p_mail=0	&& R.11 pa
p_lmargrep=0

p_dparms7=''
p_dparms8=''
p_dparms9=''
p_dparms10=''

p_alias=''
p_report=''
p_congtit=.t.

public p_arrout[10]
p_cancela=.t.

public p_arrtype[7]
p_arrtype[1]='DBF Dbase'
p_arrtype[2]='DBF FoxPro'
p_arrtype[3]='SDF Texto'
p_arrtype[4]='WK1 Lotus123'
p_arrtype[5]='WR1 Symphony'
p_arrtype[6]='XLS Excel'
p_arrtype[7]='DEL Delimited'

public p_arrport[8]
p_arrport[1]='Prn'
p_arrport[2]='Lpt1'
p_arrport[3]='Lpt2'
p_arrport[4]='Lpt3'
p_arrport[5]='Com1'
p_arrport[6]='Com2'
p_arrport[7]='Com3'
p_arrport[8]='Archivo'

** Variables para termometro **
public g_thermwidth,g_graphic,g_boxstrg,g_numplatforms,g_outfile, c_dlgface, c_dlgsize, c_dlgstyle
public p_updtherm    &&

g_thermwidth = 0       && Thermometer width
g_graphic  = .t.
g_boxstrg = ['ฤ','ฤ','ณ','ณ','ฺ','ฟ','ภ','ู','ฤ','ฤ','ณ','ณ','ฺ','ฟ','ภ','ู']
g_numplatforms = 1     && number of platforms we are generating for
g_outfile=' '

c_dlgface = 'Arial'
c_dlgsize = 9
c_dlgstyle = 'N'

** Colores **

if _windows
	set keycom to dos
endif

public p_netuser,p_neterr,p_user,p_mean,ps_user
p_user=ps_user
p_neterr=.f.

*
* Aqui inicializo prefijo camuflado
* si d0pref='CG' -->  d0PrXX da DH
* si d0pref='IW' -->  d0PrXX da JX
* si d0pref='SJ' -->  d0PrXX da TK
* si d0pref='AW' -->  d0PrXX da BX
* si d0pref='ST' -->  d0PrXX da TU
* si d0pref='GA' -->  d0prXX da HB
* si d0pref='GW' -->  d0prXX da HX
*
publ d0prxx
d0prxx=iif( left (d0pref,1)='Z','Z',chr(asc(left (d0pref,1))+1) ) + ;
       iif( right(d0pref,1)='Z','Z',chr(asc(right(d0pref,1))+1) )

*
* Aqui se define nombre de File Seguridad
*
publ d0fise
d0fise='XFO'+d0prxx+'RM.DLL'

*
* Toma de p_netuser
*
if 'U'$type('P_PAR1')  && Si no existe parametro (Sistemas no enlatados)
	* normalmente los sistemas que no tienen p_par1
	p_netuser=getenv('NETUSER')  && Toma enviroment
	if !empty(p_netuser)
		do case
			case isalpha(p_netuser)
				p_netuser=str(asc(upper(p_netuser)),2)
				
			case len(p_netuser)=0
				p_netuser='00'
		
			case len(p_netuser)=1
				p_netuser=strcero(' '+p_netuser)
		
			otherwise
				p_netuser=strcero(left(p_netuser,2))
		endcase
	else
		p_netuser=tomuserc()
	endif
else
    * Ingreso a sistemas enlatados
	p_netuser=tomuserc()
endif

if p_netuser='00'
	=advgrave('NetUser No Definido')
	=mquit()
endif

public p_read  && Para activar el menu principal
p_read=.f.

public p_strc,p_char,p_lock
p_strc=.t.
p_char=.f.
p_lock=.t.

public p_prot,p_prfl && Para activar la proteccion
p_prot=.f.
p_prfl=.f.

public p_popup,p_bar && Para activar los menues en cascada
p_popup=''
p_bar  =0


=inisetimp()	&& Inicializa Handles que usaran las funciones.

** Reindexa el archivo de seguridad y usuarios siempre que pueda acceder **

if type('fieldvec')='U'
	dimension fieldvec(1)
endif

if type('d0f77')='C'

	if file('indexar.mem') or !file('ssf001.cdx')

		fieldvec[1]='F77 - Semแforo Windows'
		use &d0f77 in 0 alias f77 shared

		if !neterr()
		
			if flock('f77')
				sele f77
				use &d0f77 alias f77 exclusive
	
				if neterr()

					use &d0f77 in 0 alias f77 shared

				else
					do cpzero with 'SSF001.DBF',1252	&& R.03 Mariano
					fieldvec[1] = 'S01 - Usuarios'
					use ssf001 in 0 alias s01 exclusive
					if !neterr()
						sele s01
						dele tag all
					    dele file ssf001.cdx
						index on d1user tag d1user
						index on upper(d1nomb) tag d1nomb
						index on d1perf tag d1perf
						use
					endif
					fieldvec=''

					do cpzero with 'SSF002.DBF',1252	&& R.03 Mariano
					fieldvec[1] = 'S02 - Seguridad'
					use ssf002 in 0 alias s02 exclusive
					if !neterr()
						sele s02
						dele tag all
					    dele file ssf002.cdx
						index on d2user+d2prog+d2menu+d2prom tag d2user
						use
					endif
					fieldvec=''

					do cpzero with 'SSF003.DBF',1252	&& R.03 Mariano
					fieldvec[1] = 'S03'
					use ssf003 in 0 alias s03 exclusive
					if !neterr()
						sele s03
						dele tag all
					    dele file ssf003.cdx
						index on d3perf tag d3perf
						index on upper(d3desc) tag d3desc
						use
					endif
					fieldvec=''

					do cpzero with 'SSF097.DBF',1252	&& R.03 Mariano
					if file('ssf097.dbf')
						fieldvec[1] = 'F97'
						use ssf097 in 0 alias f97 exclusive
						if .not. neterr() 
						   sele f97
						   dele tag all
						   dele file ssf097.cdx
						   inde on d97empr+upper(d97alia) tag d97alia
						   use
						endif
					endif

					do cpzero with 'SSF098.DBF',1252	&& R.03 Mariano
					fieldvec[1] = 'F98'
					use ssf098 in 0 alias f98 exclusive
					if .not. neterr() 
					   sele f98
					   dele tag all
					   dele file ssf098.cdx
					   inde on upper(d98alia) tag d98alia
					   use
					endif
				endif

			endif

		endif
		sele f77
		use
	endif
endif


return ''
*******************************************************************************
function start
******************************************************************************
** Syntaxis ...: logica = START (<var1chr>,<var2chr>)
**                                clave     alias
** Fecha.......: Jun 1988
**
** Servicio....: Se posiciona en la primera ocurrencia de la CLAVE en el
**               archivo del ALIAS y si no existe queda posicionada en el
**               siguiente registro por mayor. Retorna .f. por fin de arch..
**
** Ejemplo.....: if START(f02->d2arti,'f01')
**
**
para s_clave,s_alias
private all like s_*
set near on
s_ret=seek(s_clave,s_alias)

if eof(s_alias)
	s_ret=.f.
else
	s_ret=.t.
endif

set near off
return s_ret

*FUNCTION Start
******************************************************************************
** Syntaxis ...: logica = START (<var1chr>,<var2chr>)
**                                alias      clave
** Fecha.......: Jun 1988
**
** Servicio....: Se posiciona en la primera ocurrencia de la CLAVE en el
**               archivo del ALIAS y si no existe queda posicionada en el
**               siguiente registro por mayor. Retorna .f. por fin de arch..
**
** Ejemplo.....: if START('f01',f02->d2arti)
**
**
*PARA s_clave,s_alias
*PRIVATE ALL LIKE s_*
*set near on
*s_ret=seek(s_clave,s_alias)
*set near off
*return s_ret

*********************************************************************************
function readf
******************************************************************************
** Syntaxis ...: char = READF (<var1chr>,<var2chr>,<var3chr),<var4num>,[<var5num>],[<var6log>])
**                              alias     clave      campo    posiciones   decimales  restaura registro del alias
** Fecha.......: Junio 1988
**
**
** Servicio....: Retorna el contenido de CAMPO ubicado en el archivo del ALIAS
**               segun CLAVE, se debe informar cantidad de POSICIONES y si es
**               numerico ademas cantidad de DECIMALES.
**
** Ejemplo.....: ? READF('f01',f02->d2arti,'d1desc',20)
**
**
para r_alias,r_clave,r_camp,r_posi,r_deci,r_rest
r_pcou=parameters()
private r_alian,r_macro,r_ret, r_recno
r_alian=alias()
sele (r_alias)

&&R.01b Carlos
do case 
	case r_pcou=5 or type(r_alias+'.'+r_camp)='N'	&& R.04 Mariano
		r_macro='str('+r_alias+'.'+r_camp+',r_posi,r_deci)'		&& R.04 Mariano
	case r_pcou=5 or type(r_alias+'.'+r_camp)='D'	&& R.04 Mariano
		r_macro='substr(dtoc('+r_alias+'.'+r_camp+'),1,'+str(r_posi)+')'	&& R.04 Mariano
otherwise
	r_macro='subs('+r_alias+'.'+r_camp+',1,'+str(r_posi)+')'	&& R.04 Mariano
endcase

*!*	if r_pcou=5 or type(r_camp)='N'
*!*		r_macro='str('+r_alias+'.'+r_camp+',r_posi,r_deci)'
*!*	else
*!*		r_macro='subs('+r_alias+'.'+r_camp+',1,'+str(r_posi)+')'
*!*	endif
&&R.01e Carlos

r_recno=recno(r_alias)
if seek(r_clave,r_alias)
	r_ret = eval(r_macro)
else
	r_ret = replicate(' ',r_posi)
endif

if r_rest	&& Restaura registro del alias
	if betw(r_recno,1,reccount(r_alias))
		go r_recno in (r_alias)
	else
		=db_goeof(r_alias)
	endif
endif

if .not. empty(r_alian)
	sele (r_alian)
endif

return(r_ret)	&& R.04 Mariano
******************************************************************************
function ok
** Syntaxis ...: nulo = OK ()
**
** Fecha.......: Jun 1988
**
** Servicio....: Emite tono de atencion compuesto.
**
** Ejemplo.....: OK()
**
**
para warp
if parameters()<1
	warp=20
endif

set bell to warp*150,8
?? chr(7)
set bell to warp*130,10
?? chr(7)
set bell to warp*140,9
?? chr(7)
set bell to warp*100,15
?? chr(7)
set bell to 2500,1

return ''

******************************************************************************
function strcero
********************************************************************************
** Syntaxis ...: char = STRCERO (<var1char>[,<var2num][,var3num])
**                                variable      fila     colu
** Fecha.......: Jun 1988
**
** Servicio....: justifica VARIABLE con ceros a izquierda, retornando ese
**               valor, y despliega en pantalla segun .t. o .f.
**
** Ejemplo.....: w1arti = STRCERO(w1arti)
**
**
para s_vari
s_pcou=parameters()
s_ceros='1'+replic('0',len(s_vari))
s_temp=substr(str(val(s_ceros)+val(s_vari),len(s_vari)+1),2,len(s_vari))
return s_temp


********************************************************************************
func r_ound
********************************************************************************
** Sintaxis....: num = r_ound (<varnum1>, varnum3)
**                             numero     decimales
** Fecha.......: Agosto 2005
**
** Servicio....: Reemplazo la funcion round() que para algunos casos trunca a los decimales
**               en lugar de redondear. 
** Caso test   : round( 5.00000 * 20.65300,2)=103.26 y debe ser 103.27
**				 ...   15 ...
**				 ...   25 ...
**					....	
parameters a,b
private c
c=val('1'+repl('0',b+1))
a=round(round(a*c,0)/c,b)	&& trunco al decimal siguiente y luego redondeo
return(a)

********************************************************************************
function div
******************************************************************************
** Sintaxis....: num = DIV (<varnum1>,<varnum2>,   [varnum3])
**                        numerador    denominador  decimales
**
** Fecha.......: Agosto 1988
**
** Servicio....: Chequea si el denominador es 0, devolviendo 0 como resultado
**               caso contrario devuelve el cociente.
**
** Ejemplo.....: wnum = DIV(wsuma,wcant)
**
**
PARA d_nume,d_deno,d_deci

d_pcou=parameters()
if d_pcou<2
   wait ' Error en funcion Div , falta parametro !!! ' wind 
endif

if empty(d_deno)
   do case
   	case type('d_deci')='L'
	   return 0
	case type('d_deci')='N'
	   return round(0,d_deci)
   endcase
else
   do case
   	case type('d_deci')='L'
	   return d_nume/d_deno
	case type('d_deci')='N'
	   return round(d_nume/d_deno,d_deci)
   endcase
endif
return ''

********************************************************************************
function numlet
******************************************************************************
** Sintaxis....: char = NUMLET (<varNum>)
**                               numero
**
** Fecha.......: Octubre 1988
**
** Servicio....: Retorna el numero en letras.
**
** Ejemplo.....: NUMLET(wnume)
**
**
*para num_number	&& R.14 pa
parameters num_number,num_leng	&& R.14 pa
private num_n1,num_p1,num_p2	&& R.14 pa
&& R.14b pa
if type('num_leng')!='C'
	num_leng='ESP'
else
	num_leng=upper(num_leng)
endif
&& R.14e pa

*num_number=val(str(num_number,12,2))
num_number=abs(num_number)
num_n1=int(num_number)
*num_p1=numword(num_n1)	&& R.14 pa
num_p1=numword(num_n1,num_leng)	&& R.14 pa
*num_p2='con '+substr(str((num_number-int(num_number))*100+100,3),2,2)+'/100'	&& R.14 pa
&& R.14b pa
do case
	case num_leng='ING'	&&Ingl้s
		num_p2=' and '+substr(str((num_number-num_n1)*100+100,3),2,2)+'/100'
	otherwise	&&Castellano
		num_p2=' con '+substr(str((num_number-num_n1)*100+100,3),2,2)+'/100'
endcase
&& R.14e pa

*return num_p1+num_p2+'._'	&& R.14 pa
return allt(num_p1+num_p2)+'._'	&& R.14 pa

**************************************************************************************
function numword
*
* funciona en conjunto con numlet()
*
*para nuwo_number	&& R.14 pa
parameters nuwo_number,nuwo_leng	&& R.14 pa
private nuwo_v,nuwo_x,nuwo_z1,nuwo_z2,nuwo_z3,nuwo_z4	&& R.14 pa
declare nuwo_za[3]

if nuwo_number=0
	&& R.14b pa
	do case
		case nuwo_leng='ING'
			return 'Zero '
		otherwise
	&& R.14e pa
	return 'Cero '
	endcase	&& R.14 pa
endif

nuwo_v=substr(str(1000000000+nuwo_number,10),2,9)
nuwo_za[1]=val(substr(nuwo_v,1,3))
nuwo_za[2]=val(substr(nuwo_v,4,3))
nuwo_za[3]=val(substr(nuwo_v,7,3))
nuwo_v=''
nuwo_x=1

do case	&& R.14 pa
	&& R.14b pa
	case nuwo_leng='ING'	&&Ingl้s
		do while nuwo_x<=3
			if nuwo_za[nuwo_x]=0
				nuwo_x=nuwo_x+1
				loop
			endif

			** Ej. 123 **

			nuwo_z1=val(substr(str(nuwo_za[nuwo_x],3),1,1))	&&1
			nuwo_z2=val(substr(str(nuwo_za[nuwo_x],3),2,1))	&&2
			nuwo_z3=val(substr(str(nuwo_za[nuwo_x],3),3,1))	&&3
			nuwo_z4=val(substr(str(nuwo_za[nuwo_x],3),2,2))	&&23

			if nuwo_z1>0
				nuwo_v=nuwo_v+diglet(nuwo_z1,nuwo_leng)+' hundred '
			endif

			do case
				case nuwo_z4<10
					nuwo_v=nuwo_v+diglet(nuwo_z3,nuwo_leng)
				case nuwo_z4=10
					nuwo_v=nuwo_v+'ten'
				case nuwo_z4=11
					nuwo_v=nuwo_v+'eleven'
				case nuwo_z4=12
					nuwo_v=nuwo_v+'twelve'
				case nuwo_z4=13
					nuwo_v=nuwo_v+'thirteen'
				case nuwo_z4=14
					nuwo_v=nuwo_v+'fourteen'
				case nuwo_z4=15
					nuwo_v=nuwo_v+'fifteen'
				case nuwo_z4=16
					nuwo_v=nuwo_v+'sixteen'
				case nuwo_z4=17
					nuwo_v=nuwo_v+'seventeen'
				case nuwo_z4=18
					nuwo_v=nuwo_v+'eighteen'
				case nuwo_z4=19
					nuwo_v=nuwo_v+'nineteen'
				case between(nuwo_z4,20,29)
					nuwo_v=nuwo_v+'twenty '+diglet(nuwo_z3,nuwo_leng)
				case between(nuwo_z4,30,39)
					nuwo_v=nuwo_v+'thirty '+diglet(nuwo_z3,nuwo_leng)
				case between(nuwo_z4,40,49)
					nuwo_v=nuwo_v+'fourty '+diglet(nuwo_z3,nuwo_leng)
				case between(nuwo_z4,50,59)
					nuwo_v=nuwo_v+'fifty '+diglet(nuwo_z3,nuwo_leng)
				case between(nuwo_z4,60,69)
					nuwo_v=nuwo_v+'sixty '+diglet(nuwo_z3,nuwo_leng)
				case between(nuwo_z4,70,79)
					nuwo_v=nuwo_v+'seventy '+diglet(nuwo_z3,nuwo_leng)
				case between(nuwo_z4,80,89)
					nuwo_v=nuwo_v+'eighty '+diglet(nuwo_z3,nuwo_leng)
				case between(nuwo_z4,90,99)
					nuwo_v=nuwo_v+'ninety '+diglet(nuwo_z3,nuwo_leng)
			endcase
			
			do case
				case nuwo_x=1
					nuwo_v=allt(nuwo_v)+' million '
				case nuwo_x=2
					nuwo_v=allt(nuwo_v)+' thousand '
			endcase

			nuwo_x=nuwo_x+1
		enddo
	&& R.14e pa

	otherwise	&&Castellano	&& R.14 pa
do while nuwo_x<=3
	if nuwo_za[nuwo_x]=0
		nuwo_x=nuwo_x+1
		loop
	endif
	if nuwo_za[nuwo_x]=1 .and. nuwo_x=1
		nuwo_v='un millon '
		nuwo_x=nuwo_x+1
		loop
	endif
	if nuwo_za[nuwo_x]=100
		nuwo_v=nuwo_v+'cien '
		if nuwo_x=1
			nuwo_v=nuwo_v+'millones '
		endif
		if nuwo_x=2
			nuwo_v=nuwo_v+'mil '
		endif
		nuwo_x=nuwo_x+1
		loop
	endif
	nuwo_z1=int(nuwo_za[nuwo_x]/100)
	if nuwo_z1<>0
		do case
			case nuwo_z1=1
				nuwo_v=nuwo_v+'ciento '
			case nuwo_z1=2
				nuwo_v=nuwo_v+'doscientos '
			case nuwo_z1=3
				nuwo_v=nuwo_v+'trescientos '
			case nuwo_z1=4
				nuwo_v=nuwo_v+'cuatrocientos '
			case nuwo_z1=5
				nuwo_v=nuwo_v+'quinientos '
			case nuwo_z1=6
				nuwo_v=nuwo_v+'seiscientos '
			case nuwo_z1=7
				nuwo_v=nuwo_v+'setecientos '
			case nuwo_z1=8
				nuwo_v=nuwo_v+'ochocientos '
			case nuwo_z1=9
				nuwo_v=nuwo_v+'novecientos '
		endcase
	endif
	nuwo_z3=nuwo_za[nuwo_x]-(nuwo_z1*100)
	nuwo_z4=0
	if .not. (nuwo_z3>19 .or. nuwo_z3<11)
		nuwo_z4=nuwo_z3-10
		do case
			case nuwo_z4=1
				nuwo_v=nuwo_v+'once '
			case nuwo_z4=2
				nuwo_v=nuwo_v+'doce '
			case nuwo_z4=3
				nuwo_v=nuwo_v+'trece '
			case nuwo_z4=4
				nuwo_v=nuwo_v+'catorce '
			case nuwo_z4=5
				nuwo_v=nuwo_v+'quince '
			case nuwo_z4=6
				nuwo_v=nuwo_v+'dieciseis '
			case nuwo_z4=7
				nuwo_v=nuwo_v+'diecisiete '
			case nuwo_z4=8
				nuwo_v=nuwo_v+'dieciocho '
			case nuwo_z4=9
				nuwo_v=nuwo_v+'diecinueve '
		endcase
	endif
	if nuwo_z3=20
		nuwo_v=nuwo_v+'veinte '
		if nuwo_x=1
			nuwo_v=nuwo_v+'millones '
		endif
		if nuwo_x=2
			nuwo_v=nuwo_v+'mil '
		endif
		nuwo_x=nuwo_x+1
		loop
	endif
	if .not. (nuwo_z4>=1 .and. nuwo_z4<=9)
		nuwo_z2=int(nuwo_z3/10)
		if nuwo_z2<>0
			do case
				case nuwo_z2=1
					nuwo_v=nuwo_v+'diez '
				case nuwo_z2=2
					nuwo_v=nuwo_v+'veinti'
				case nuwo_z2=3
					nuwo_v=nuwo_v+'treinta '
				case nuwo_z2=4
					nuwo_v=nuwo_v+'cuarenta '
				case nuwo_z2=5
					nuwo_v=nuwo_v+'cincuenta '
				case nuwo_z2=6
					nuwo_v=nuwo_v+'sesenta '
				case nuwo_z2=7
					nuwo_v=nuwo_v+'setenta '
				case nuwo_z2=8
					nuwo_v=nuwo_v+'ochenta '
				case nuwo_z2=9
					nuwo_v=nuwo_v+'noventa '
			endcase
		endif
		nuwo_z1=nuwo_z3-(nuwo_z2*10)
		if nuwo_z1<>0
			if nuwo_z2<>0 .and. nuwo_z2<>2
				nuwo_v=nuwo_v+'y '
			endif
			do case
				case nuwo_z1=1
					if nuwo_x=3
						nuwo_v=nuwo_v+'uno '
					else
						nuwo_v=nuwo_v+'un '
					endif
				case nuwo_z1=2
					nuwo_v=nuwo_v+'dos '
				case nuwo_z1=3
					nuwo_v=nuwo_v+'tres '
				case nuwo_z1=4
					nuwo_v=nuwo_v+'cuatro '
				case nuwo_z1=5
					nuwo_v=nuwo_v+'cinco '
				case nuwo_z1=6
					nuwo_v=nuwo_v+'seis '
				case nuwo_z1=7
					nuwo_v=nuwo_v+'siete '
				case nuwo_z1=8
					nuwo_v=nuwo_v+'ocho '
				case nuwo_z1=9
					nuwo_v=nuwo_v+'nueve '
			endcase
		endif
	endif
	if nuwo_x=1
		nuwo_v=nuwo_v+'millones '
	endif
	if nuwo_x=2
		nuwo_v=nuwo_v+'mil '
	endif
	nuwo_x=nuwo_x+1
enddo
endcase	&& R.14 pa

*return nuwo_v	&& R.14 pa
return allt(nuwo_v)	&& R.14 pa

&& R.14b pa
**************************************************************************************
function diglet
**************************************************************************************
* funciona en conjunto con numlet()
*
parameters dig_number,dig_leng
private dig_ret,dig_list

if type('dig_number')!='N'
	dig_number=0
endif
if !between(dig_number,0,9)
	return ''
endif

do case
	case dig_leng='ING'	&&Ingl้s
		dig_list='     one  two  threefour five six  seveneightnine '
		dig_ret=allt(substr(dig_list,(dig_number*5)+1,5))
	otherwise	&&Castellano
		dig_list='      uno   dos   tres  cuatrocinco seis  siete ocho  nueve '
		dig_ret=allt(substr(dig_list,(dig_number*6)+1,6))
endcase

return (dig_ret)
&& R.14e pa

*******************************************************************************
function mes
******************************************************************************
** Sintaxis....: char = MES(<var1char>)
**                            Fecha o Mes
** Fecha.......: Mayo 1989
**
** Servicio....: Retorna leyenda del mes
**
** Ejemplo.....: mes(1)   retorna Enero
**
**
******************************************************************************
para m_fech
priv w_mes
do case
case type('m_fech')='D'		&& viene la fecha
	w_mes=month(m_fech)
case type('m_fech')='N'		&& viene el mes numerico
	w_mes=m_fech
case type('m_fech')='C'		&& viene el mes caracter
	w_mes=val(m_fech)
endcase

return trim(substr('          Enero     Febrero   Marzo     Abril     Mayo      Junio     Julio     Agosto    SeptiembreOctubre   Noviembre Diciembre ',(w_mes)*10+1,10))
*****************************************************************************

function xbegtran
******************************************************************************
** Sintaxis....: nul = BegTran()
**
** Ejemplo.....:
**
bt_alias=alias()

for bt_x=1 to 225
	if .not. empty(alias(bt_x))
		bt_vara=alias(bt_x)
		sele (bt_vara)
		if .not. eof()
			go recno()
		endif
	endif
next

flush

if .not. empty(bt_alias)
	sele (bt_alias)
endif
return ''
*******************************************************************************
function xendtran
******************************************************************************
** Sintaxis....: nul = EndTran()
**
** Ejemplo.....:
**
et_alias=alias()

for et_x=1 to 225
	if .not. empty(alias(et_x))
		et_vara=alias(et_x)
		sele (et_vara)
		if .not. eof()
			go recno()
		endif
	endif
next

flush

if .not. empty(et_alias)
	sele (et_alias)
endif
return ''
******************************************************************************
function dele_rec
******************************************************************************
** Sintaxis....: nul = DELE_REC(<var1char>)
**                                 alias
para g_alias
priv g_sele

g_sele=select(0)
sele (g_alias)
delete
if .not. empty(g_sele)
	sele (g_sele)
endif
return ''
***********************************************************************
function net_appe
para     ap_alias
private all like ap_*

*if .not. empty(p_alias)
*	wait ' Verifique todas las llamadas a Rest_alia()' wind
*	close all
*	return
*endif

ap_retu=.t.
ap_alan=alias()

sele (ap_alias)
ap_repr=set('REPROCESS')

****  wait ' Agregando registro ...' wind nowait

set reprocess to -1    && Insiste indefinidamente

append blank

**** wait clear

if .not. empty(ap_alan)
	sele (ap_alan)
endif

set reprocess to ap_repr

return ap_retu
******************************************************************************
function neterr
private ne_error, ne_i, ne_alia

ne_error=p_neterr
p_neterr=.f.

do while .t.
if ne_error	&& dio error apertura de archivo
	for ne_i=1 to 225	&& cierra las bases que pudo abrir
		if empty(fieldvec[ne_i])
			exit
		else
			ne_alia=iif(at(' ',fieldvec[ne_i])=0,fieldvec[ne_i], alltrim(left(fieldvec[ne_i],at(' ',fieldvec[ne_i]))))
			if !empty(ne_alia) and used(ne_alia)
				select (ne_alia)
				use
			endif
		endif
	endfor
	exit
else
	for ne_i=1 to 225	&& controlo que las bases no esten readonly()
		if empty(fieldvec[ne_i])
			exit
		else
			ne_alia=iif(at(' ',fieldvec[ne_i])=0,fieldvec[ne_i], alltrim(left(fieldvec[ne_i],at(' ',fieldvec[ne_i]))))
			if used(ne_alia)
				if isreadonly(ne_alia)
					wait window 'El archivo '+ne_alia+' se encuentra como solo lectura' time 2
					ne_error=.t.
					exit
				endif
			endif
		endif
	endfor
	if !ne_error
		exit
	endif
endif
enddo

fieldvec=''	&& inicializa el vector

return ne_error


*****************************************************************************
function sino
*****************************************************************************
parameters s_preg, s_defa, s_titu

if type('s_titu')!='C'
	s_titu=''
endif
if type('s_defa')!='C'
	s_defa='NO'
endif
if type('s_preg')!='C'
	s_preg='..?'
endif

s_defa=upper(s_defa)

private s_btn

s_btn=msgbox(s_preg, s_titu, 4 + 32 + iif(s_defa='SI', 0, 256))
if type('s_btn')<>'N' && cuando se invoca msgbox 2 veces en misma maquina hace release de s_btn
	s_btn=0
endif

return( iif(s_btn=6,'S','N') )

*****************************************************************************
function advgrave
*****************************************************************************
parameters s_preg, s_titu, s_canc

private all like s_*

if parameters()<2 or empty(s_titu)
	s_titu='Advertencia'
endif
if parameters()<1
	s_preg='..!'
endif

s_btn=msgbox(s_preg, s_titu, iif(s_canc,1,0) + 48 + 0)
if type('s_btn')<>'N' && cuando se invoca msgbox 2 veces en misma maquina hace release de s_btn
	s_btn=0
endif

return( iif(s_btn=1,'Aceptar', iif(s_canc,'Cancelar','')) )

*****************************************************************************
function advsuave
*****************************************************************************
parameters s_preg, s_titu, s_canc

private all like s_*

if parameters()<2 or empty(s_titu)
	s_titu='Advertencia'
endif
if parameters()<1
	s_preg='..!'
endif

s_btn=msgbox(s_preg, s_titu, iif(s_canc,1,0) + 64 + 0)
if type('s_btn')<>'N' && cuando se invoca msgbox 2 veces en misma maquina hace release de s_btn
	s_btn=0
endif

return( iif(s_btn=1,'Aceptar',iif(s_canc,'Cancelar','')) )

*****************************************************************************
function xsino
*****************************************************************************
parameters s_text,s_defa

private all like s_*
if parameters()<2
	s_defa='NO'
endif
s_obj=iif(s_defa=='SI',1,2)

push key clear
push menu _msysmenu
on key label escape do nada
set skip of menu _msysmenu .t.

s_onto=wontop()
s_btn=0

if .not. wexist('s_wind')

	define window s_wind ;
		at 0,0 size 6,60 ;
		float ;
		noclose ;
		shadow ;
		nominimize ;
		font 'arial', 10 style 'B' ;
		color rgb(,,,192,192,192)
	move wind s_wind center
endif

if wvisible("s_wind")
	activate window s_wind same
else
	activate window s_wind noshow
endif

@ 1,(60-txtwidth(s_text))/2 say s_text

@ 4,7 get s_btn ;
	picture "@*HT \<Si;\?\<No" ;
	size 1.5,10,26

if .not. wvisible('s_wind')
	if wexist('s_wind')
		activate window s_wind
	endif
endif

read cycle modal object s_obj
release window s_wind

if .not. empty(s_onto)
	activate wind (s_onto)
endif

pop menu _msysmenu
pop key
on key label escape
return( iif(s_btn=1,'S','N') )


*****************************************************************************
function sinob
parameters s_text,s_defa_
private all like s_*.*

if parameters()=1
	s_sino='Si'
	s_defa=2
else
	if s_defa_='SI'
		s_sino='Si'
		s_defa=2
	else
		s_sino='No'
		s_defa=3
	endif
endif

if rdlevel() > 3
	return(space(1))
endif

push key clear
push menu _msysmenu
on key label escape do nada
set skip of menu _msysmenu .t.

s_onto=wontop()

if .not. wexist('s_wind')

	define window s_wind ;
		from int((srow()-7)/2),int((scol()-54)/2) ;
		to int((srow()-7)/2)+6,int((scol()-54)/2)+53 ;
		float ;
		noclose ;
		shadow ;
		nominimize ;
		double ;
		color scheme 7

endif

if wvisible("s_wind")
	activate window s_wind same
else
	activate window s_wind noshow
endif

s_text=padc(s_text,54)

s_colu = 0
s_colu = ( 54 - len(s_text)) / 2

if s_colu < 0
	s_colu = 1
endif

@ 1,s_colu get s_text ;
	size 1,54 ;
	default " " ;
	disable

@ 4,1 get s_sino ;
	picture "@*HT \!\<Si;\?\<No" ;
	size 1,10,30

if .not. wvisible('s_wind')
	if wexist('s_wind')
		activate window s_wind
	endif
endif

read cycle modal object s_defa valid iif(lastkey()=13,.t.,.f.)

release window s_wind

if .not. empty(s_onto)
	activate wind (s_onto)
endif

pop menu _msysmenu
pop key
on key label escape

return left(s_sino,1)



*****************************************************************************
procedure BUSCA
*****************************************************************************
parameters k_t1,k_t2,k_t3,k_t4,k_t5,k_t6,k_do
private all like k_*

if type('k_do')='L'
	k_do=2	&& orden por default descripcion
endif


  for k_i=1 to 6
		k_aux='k_t'+str(k_i,1)
		if empty(&k_aux)
			do case
				case k_i=1
					&k_aux='1-Por C๓digo'
				case k_i=2 and !empty(tag(k_i))
					&k_aux='2-Por Descripci๓n'
				otherwise
					&k_aux=''
			endcase
		endif
		if !empty(&k_aux)
			dimension k_tag(k_i)
			k_tag[k_i]=&k_aux
		endif
	endfor

	push menu _msysmenu

	set skip of menu _msysmenu .t.

	push key clear
	k_busca=space(40)

if not wexist("buscalib")
	define window buscalib ;
		at  0.000, 0.000  ;
		size 5.000,49.875 ;
		title "BUSCA" ;
		font "Fixedsys", 9 ;
		float ;
		noclose ;
		nominimize ;
		system ;
		color rgb(,,,192,192,192)
	move window buscalib center

endif

if wvisible("buscalib")
	activate window buscalib same
else
	activate window buscalib noshow
endif

@ 1,4.750 GET k_ord ;
	PICTURE "@^" ;
	FROM k_tag ;
	SIZE 3,40.125 ;
	DEFAULT iif(empty(tag(k_do)) or k_do=1, 1, k_do) ;
	COLOR SCHEME 8, 9
@ 2.933,4.750 get k_busca ;
	size 1.000,40.125 ;
	default " " ;
	font "Fixedsys", 9 ;
	picture "@!" ;
	valid valbusca() ;
	color ,rgb(,,,255,255,255)
@ 0.667,1.125 to 4.334,48.500 ;
	pen 1, 8 ;
	color rgb(255,255,255,,,,)
@ 0.667,1.125 to 4.267,48.375 ;
	pen 1, 8 ;
	color rgb(128,128,128,,,,)

if not wvisible("buscalib")
	activate window buscalib
endif

read modal object 2

release window buscalib


k_busca=trim(k_busca)

if .not. empty(k_busca)
	if .not. start(w_pref+k_busca,alias())
		?? chr(7)
	endif
endif

pop key
pop menu _msysmenu

return

***************************************************************
func valbusca
***************************************************************
	if !empty(tag(k_ord))
		set order to k_ord
	endif
return


**********************************************************************
function uniqfile
return sys(3)
*********************************************************************
procedure filtro
private w_count

if empty(w_filt)
	getexpr to w_filt type 'L'
else
	w_filt=''
	set filt to
	go top
	return
endif

wait ' Filtrando archivo ... ' wind nowait
set filt to &w_filt
count to w_count

if empty(w_count)
	wait ' No se encontraron registros ' wind timeout 1
	w_filt=''
	set filt to
endif

wait clear
go top in (w_alias)
return

* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*
*                          P R O T E C C I O N
*
*                   ~MPROT()
*                   ~PRGRABA
*                   ~SETEAF1
*
*                WSUPER
*                ------
*                Variable pฃblica  definida en  CGP000.        *
*                .T. significa que esta logeado el supervisor  *
*                por defecto es .F.                            *
*
* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function mprot
* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters m_user,m_prog,m_menu,m_prom
private w_menud,w_promd,w_altf1
private all like m_*

w_menud= space(35)
w_promd= space(35)
m_retu = .f.
m_alias= alias()
w_altf1= 104
m_prom = upper(	m_prom)

if .not. used('S02')

	f_acce=1
	do while .t.

		fieldvec[1]='S02 - Seguridad'
		use ssf002 in 0 order 1 alias s02

		if !neterr()
			exit
		else
			if f_acce>=3	&& tres intentos
				=mquit()
   			endif
			f_acce=f_acce+1
		endif

	enddo

	fieldvec=''


endif

select s02
m_key=' '

if !empty(m_prog) .and. !empty(m_menu) .and. !empty(m_prom)
	m_key = padr(m_user,10) + padr(m_prog,20)+ upper(padr(m_menu,35)) + upper(padr(m_prom,35))
	if seek(m_key,'s02')

		if p_prot	&& marca los popup protegidos

			for m_x=1 to cntbar(m_menu)

				if getbar(m_menu,m_x)<0   && Salta las opciones de #Bar no definidas
					loop
				endif

				if upper(prmbar(m_menu,m_x))=m_prom
					set mark of bar m_x of &m_menu to .t.
					exit
				endif

			next

		endif

		m_retu=.t.

	else

		if p_prot	&& desmarca los popup desprotegidos

			for m_x=1 to cntbar(m_menu)

				if getbar(m_menu,m_x)<0   && Salta las opciones de #Bar no definidas
					loop
				endif

				if upper(prmbar(m_menu,m_x))=m_prom
					set mark of bar m_x of &m_menu to .f.
					exit
				endif

			next

		endif

	endif

endif

if .not. empty(m_alias)
	sele (m_alias)
endif

* Cuando esta logeado el supervisor devuelve .f. para no inhabilitarlo

return( iif(wsuper,.f.,m_retu))

*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure setprot
*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

if rdlevel()=1
	p_popup=popup()
	p_bar=bar()
endif

push key clear      && Salva estados de teclas
push menu _msysmenu && Salva estado de menu
set skip of menu _msysmenu .t.

* ________________________________________________________*
* Este procedimiento MUESTRA LA PANTALLA PARA SELECCIONAR *
* PERFILES.Asimismo deshabilita el menu al entrar y lo    *
* rehabilita al salir.                                    *
*_________________________________________________________*

p_alian= alias()

f_acce=1
do while .t.
	fieldvec[1]='S03_3 - Perfiles'
	use ssf003 in 0 alias s03_3 order d3desc again
	if !neterr()
		exit
	else
		if f_acce>=3	&& tres intentos
			=mquit()
		endif
		f_acce=f_acce+1
	endif
enddo
fieldvec=''

sele s03_3

w_item=1

on key label esc do nada

p_prot=.f.

do sss003s.spr

p_prot= .t.

on key label esc

pop key
pop menu _msysmenu

p_user= d3perf
p_ayuda=.f.	&& desactiva menu ayuda cuando cambia perfil

set status bar on

csalida=left(w_ver+'  '+nf_text+'  Perfil: "'+p_user+'"  MODO PROTECCION',79)

set message to csalida

select s03_3
use

return

*-------------------------------------------------------------------------
*                         PROCEDURE PRGRABA
*
*   Este procedimiento setea con F12 como protegido\desprotegido       *
*   las opciones de menu marcadas por el SUPERVISOR.Este procedimiento *
*   es el que da el ALTA o BAJA EFECTIVA en el archivo SSF002 para     *
*   configurar los derechos de acceso a los menฃes.                    *
*______________________________________________________________________*

procedure prgraba
parameters w_menud,w_promd

*set curs off

if empty(w_menud)
	wait wind 'Esta opci๓n no es protegible' time 1
	return
endif

*private w_key, w_prog, m_retu
private w_key, m_retu

w_retu= .f.
w_key = padr(p_user,10) + padr(w_prog,20)+ padr(upper(w_menud),35) + padr(upper(w_promd) ,35)

if !seek(w_key,'S02')

	append blank
	replace s02.d2user with p_user
	replace s02.d2prog with w_prog
	replace s02.d2menu with upper(w_menud)
	replace s02.d2prom with upper(w_promd)

	m_retu = .t.

else
	if rlock()
		delete
		m_retu=.f.
		unlock
	endif
endif

if !eof('s02')
	go recno('s02') in s02
endif

return
****************************************************************************
function seteaf12

on key label f12 do prgraba with upper(popup()),upper(prompt())

return
*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function set_alia
* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_alia
private all like w_*

if .not. empty(p_alias)
	wait ' Verifique todas las llamadas a Rest_alia()' wind
	close all
	return
*	clear all
*	set sysmenu to default
*	on error
*	cancel
endif

p_alias=alias()

if .not. used(w_alia)
	wait ' Archivo '+w_alia+ ' no esta abierto ' wind
	close all
	clear all
	cancel
endif

select (w_alia)

return []
*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function rest_alia
*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

if .not. empty(p_alias)
	sele (p_alias)
	p_alias=''
endif

return []

*-F ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure pantalla
*-F ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
private all like r_*

if p_repout='Pantalla'

	if .not.  mfile(d0f99+'.tmp')
		wait clear
		wait ' No se registra informaci๓n ! ' wind
		return
	endif

	r_alian=alias()

	r_mode='25'

	r_display=set('display')


	if p_repout='Pantalla 50 renglones'
		*      r_display=set('display')
		*      set disp to vga50
		r_mode='50'
	endif

	*define wind r_wind from 1,0 to srows()-1,scols()-1 system color;
	*                          scheme 8 title ' REPORTE POR PANTALLA '

	if p_congtit
		r_cong='S'
	else
		r_cong='N'
	endif

	r_tmpfile=d0f99+'.dbx'

	do case
		case p_width<=80
			crea table (r_tmpfile) ;
				(c01 c(5),;
				c02 c(10),c03 c(10),c04 c(10),c05 c(10),;
				c06 c(10),c07 c(10),c08 c(10),c09 c(10))

		case p_width>80 .and. p_width<=132
			crea table (r_tmpfile) ;
				(c01 c(5),;
				c02 c(10),c03 c(10),c04 c(10),c05 c(10),;
				c06 c(10),c07 c(10),c08 c(10),c09 c(10),;
				c10 c(10),c11 c(10),c12 c(10),c13 c(10),c14 c(10))

		case p_width>132 .and. p_width<=160

			crea table (r_tmpfile) ;
				(c01 c(5),;
				c02 c(10),c03 c(10),c04 c(10),c05 c(10),;
				c06 c(10),c07 c(10),c08 c(10),c09 c(10),;
				c10 c(10),c11 c(10),c12 c(10),c13 c(10),;
				c14 c(10),c15 c(10),c16 c(10),c17 c(10))

		case p_width>160 .and. p_width<=190
			crea table (r_tmpfile) ;
				(c01 c(5),;
				c02 c(10),c03 c(10),c04 c(10),c05 c(10),;
				c06 c(10),c07 c(10),c08 c(10),c09 c(10),;
				c10 c(10),c11 c(10),c12 c(10),c13 c(10),;
				c14 c(10),c15 c(10),c16 c(10),c17 c(10),;
				c18 c(10),c19 c(10),c20 c(10))

		case p_width>190 .and. p_width<=210
			crea table (r_tmpfile) ;
				(c01 c(5),;
				c02 c(10),c03 c(10),c04 c(10),c05 c(10),;
				c06 c(10),c07 c(10),c08 c(10),c09 c(10),;
				c10 c(10),c11 c(10),c12 c(10),c13 c(10),;
				c14 c(10),c15 c(10),c16 c(10),c17 c(10),;
				c18 c(10),c19 c(10),c20 c(10),c21 c(10),c22 c(10))

		case p_width>210 .and. p_width<=240
			crea table (r_tmpfile) ;
				(c01 c(5),;
				c02 c(10),c03 c(10),c04 c(10),c05 c(10),;
				c06 c(10),c07 c(10),c08 c(10),c09 c(10),;
				c10 c(10),c11 c(10),c12 c(10),c13 c(10),;
				c14 c(10),c15 c(10),c16 c(10),c17 c(10),;
				c18 c(10),c19 c(10),c20 c(10),c21 c(10),;
				c22 c(10),c23 c(10),c24 c(10),c25 c(10))

		case p_width>240 .and. p_width<=255
			crea table (r_tmpfile) ;
				(c01 c(5),;
				c02 c(10),c03 c(10),c04 c(10),c05 c(10),;
				c06 c(10),c07 c(10),c08 c(10),c09 c(10),;
				c10 c(10),c11 c(10),c12 c(10),c13 c(10),;
				c14 c(10),c15 c(10),c16 c(10),c17 c(10),;
				c18 c(10),c19 c(10),c20 c(10),c21 c(10),;
				c22 c(10),c23 c(10),c24 c(10),c25 c(10),;
				c26 c(10))

	endcase

	use
	use &d0f99..dbx in 0 alias fdbx
	sele fdbx
	appe from &d0f99..tmp sdf

	if reccount()=0	&& el report creo el archivo vacio
		use
		dele file &d0f99..tmp
		dele file &d0f99..dbx

		wait clear
		wait ' No se registra informaci๓n ! ' wind
		return
	endif

	use

	if .not. empty(r_alian)
		sele (r_alian)
	endif

	wait clear
	clear type

	! ssp999 &d0f99..dbx &r_cong &r_mode

	set disp to &r_display


	* modi comm &d0f99..tmp

	** p_congtit es una variable publica que permite no congelar el titulo
	** de acuerdo al listado que este mostrando, generalmente sirve para
	** aquellos listados que saltan por pagina y muestran en el titulo
	** diferentes cosas.
	** si fue informada como .f. la reasigno como .t.

	p_congtit=.t.

	=skipbar('Registro','ALL',.f.)
	** rele wind r_wind

	if p_repout='Pantalla 50 renglones'
		**      set disp to &r_display
	endif


	dele file &d0f99..tmp
	dele file &d0f99..dbx

endif

return
*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function fupdtherm
*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters i_text
if parameters()=0
	i_text=''
endif

if p_updtherm
	p_acctherm=p_acctherm+1

	do updtherm with p_acctherm/p_tottherm * 100

	if .not. empty(i_text)
		@ 1.5,6 say left(i_text+space(55),55) font c_dlgface, c_dlgsize style c_dlgstyle
	endif

endif

return .t.
*____________________________________________________________________________
**
** Code Associated With Displaying of the Thermometer
**
*
* ACTTHERM(<text>) - Activate thermometer.
*
* Activates thermometer.  Update the thermometer with UPDTHERM().
* Thermometer window is named "thermometer."  Be sure to RELEASE
* this window when done with thermometer.  Creates the global
* m.g_thermwidth.
*
*!*****************************************************************************
*!
*!      Procedure: ACTTHERM
*!
*!      Called by: BUILD              (procedure in GENSCRN.PRG)
*!
*!*****************************************************************************
procedure acttherm
parameter m.text1,m.text2
private m.prompt

if parameters()=1
	m.text2=''
endif

if m.g_graphic
	m.prompt = lower(m.g_outfile)
	if txtwidth(m.prompt, c_dlgface, c_dlgsize, c_dlgstyle) > 43
		do while txtwidth(m.prompt+"...", c_dlgface, c_dlgsize, c_dlgstyle) > 43
			m.prompt = left(m.prompt, len(m.prompt)-1)
		enddo
		m.prompt = m.prompt + "..."
	endif

	define window thermomete ;
		at  int((srow() - (( 5.615 * ;
		fontmetric(1, c_dlgface, c_dlgsize, c_dlgstyle )) / ;
		fontmetric(1, wfont(1,""), wfont( 2,""), wfont(3,"")))) / 2), ;
		int((scol() - (( 63.833 * ;
		fontmetric(6, c_dlgface, c_dlgsize, c_dlgstyle )) / ;
		fontmetric(6, wfont(1,""), wfont( 2,""), wfont(3,"")))) / 2) ;
		size 5.615,63.833 ;
		font c_dlgface, c_dlgsize ;
		title 'Procesando Archivos...' ;
		style c_dlgstyle ;
		nofloat ;
		noclose ;
		shadow ;
		none ;
		color rgb(0, 0, 0, 192, 192, 192)
	move window thermomete center
	activate window thermomete noshow

	@ 0.5,3 say m.text1 font c_dlgface, c_dlgsize style c_dlgstyle
	*	@ 1.5,6 say m.text2 font c_dlgface, c_dlgsize style c_dlgstyle
	@ 0.000,0.000 to 0.000,63.833 ;
		color rgb(255, 255, 255, 255, 255, 255)
	@ 0.000,0.000 to 5.615,0.000 ;
		color rgb(255, 255, 255, 255, 255, 255)
	@ 0.385,0.667 to 5.231,0.667 ;
		color rgb(128, 128, 128, 128, 128, 128)
	@ 0.308,0.667 to 0.308,63.167 ;
		color rgb(128, 128, 128, 128, 128, 128)
	@ 0.385,63.000 to 5.308,63.000 ;
		color rgb(255, 255, 255, 255, 255, 255)
	@ 5.231,0.667 to 5.231,63.167 ;
		color rgb(255, 255, 255, 255, 255, 255)
	@ 5.538,0.000 to 5.538,63.833 ;
		color rgb(128, 128, 128, 128, 128, 128)
	@ 0.000,63.667 to 5.615,63.667 ;
		color rgb(128, 128, 128, 128, 128, 128)
	@ 3.000,3.333 to 4.231,3.333 ;
		color rgb(128, 128, 128, 128, 128, 128)
	@ 3.000,60.333 to 4.308,60.333 ;
		color rgb(255, 255, 255, 255, 255, 255)
	@ 3.000,3.333 to 3.000,60.333 ;
		color rgb(128, 128, 128, 128, 128, 128)
	@ 4.231,3.333 to 4.231,60.500 ;
		color rgb(255, 255, 255, 255, 255, 255)
	m.g_thermwidth = 56.269

	show window thermomete top
else
	***   m.prompt = SUBSTR(SYS(2014,m.g_outfile),1,48)+;
	iif(len(m.g_outfile)>48,"...","")

m.prompt=''

define window thermomete;
	from int((srow()-6)/2), int((scol()-57)/2) ;
	to int((srow()-6)/2) + 6, int((scol()-57)/2) + 57;
	double color scheme 5 ;
	shadow

activate window thermomete noshow

m.g_thermwidth = 50
@ 0,3 say m.text1
@ 1,6 say m.text2
@ 2,1 to 4,m.g_thermwidth+4 &g_boxstrg

show window thermomete top
endif
return

*
* UPDTHERM(<percent>) - Update thermometer.
*
*!*****************************************************************************
*!
*!      Procedure: UPDTHERM
*!
*!      Called by: BUILD              (procedure in GENSCRN.PRG)
*!               : DISPATCHBUILD      (procedure in GENSCRN.PRG)
*!               : BUILDCTRL          (procedure in GENSCRN.PRG)
*!               : EXTRACTPROCS       (procedure in GENSCRN.PRG)
*!               : BUILDFMT           (procedure in GENSCRN.PRG)
*!
*!*****************************************************************************
procedure updtherm
parameter m.percent
private m.nblocks, m.percent

activate window thermomete

* Map to the number of platforms we are generating for
m.percent = min(int(m.percent / m.g_numplatforms) ,100)

m.nblocks = (m.percent/100) * (m.g_thermwidth)
if m.g_graphic
	@ 3.000,3.333 to 4.231,m.nblocks + 3.333 ;
		pattern 1 color rgb(128, 128, 128, 128, 128, 128)
else
	@ 3,3 say replicate("Û",m.nblocks) font "FoxFont",9
endif
return

*
* DEACTTHERMO - Deactivate and Release thermometer window.
*
*!*****************************************************************************
*!
*!      Procedure: DEACTTHERMO
*!
*!      Called by: BUILD              (procedure in GENSCRN.PRG)
*!
*!*****************************************************************************
procedure deactthermo
if wexist("thermomete")
	release window thermomete
endif

return

*-P ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function fenter
private lret
lret=.t.

if lastkey()=p_enter
	keyboard '{CTRL+W}'
	lret= .t.
endif

return(lret)

********************************************************************************
*_________________________________________________________________________*
*                          FUNCION SALEBROW
*
*        Esta funciขn es invocada desde cada BROWSE,sirve
*        para evitar que al salir por ESCAPE de un BROWSE,
*        tome igualmente el registro en el que est  parado.
*        Esta funciขn devuelve un CADENA VACIA cuando se
*        sale por ESCAPE de un BROWSE.Recibe como par metro
*        la ฃltima tecla oprimida.Solo actฃa si esa tecla
*        es ESCAPE
*___________________________________________________________________________*

function salebrow
parameters tecla

if tecla=27
	go bottom
	skip
	scatter memvar
endif

return(.t.)

* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function skipbar
* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters s_popup,s_bar,s_skip
private all like s_*

s_cntb=cntbar(s_popup)
s_bar=upper(trim(s_bar))

if empty(s_bar) .or. empty(s_popup)
	return(.f.)
endif

for s_x=1 to s_cntb

	if upper(prmbar(s_popup,s_x))=s_bar .or. upper(s_bar)='ALL'

		s_salta = s_skip or mprot(p_user, w_prog, s_popup, prmbar(s_popup, s_x))

		set skip of bar s_x of (s_popup) s_salta

		do mapeofb with s_x	&& habilita o deshabilita botones de la botonera

		if s_bar<>'ALL'
			exit
		endif
	endif

next

**do mapeoFB	&& habilita o deshabilita botones de la botonera

return ''

*-P ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function skipbarstat
*-P ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters s_popup,s_bar, s_vbar
private all like s_*

if parameters()=3	&& s_vbar es la fila del prompt
	return skpbar(s_popup,s_vbar)
endif

*if p_prot
*	s_retu=.f.
*endif
*if type('p_user') = 'C'
*	if p_user='SUPERVISOR'
*		s_retu=.f.
*		return s_retu
*	endif
*endif

if rdlevel()=1 .and. p_mean=1
	p_popup=popup()
	p_bar=bar()
endif

if empty(s_popup)
	return(.f.)
endif

s_cntb=cntbar(s_popup)
s_bar=upper(trim(s_bar))
s_retu=.f.

for s_x=1 to s_cntb

	if getbar(s_popup,s_x)<0   && Salta las opciones de #Bar no definidas
		loop
	endif

	if upper(prmbar(s_popup,s_x))=s_bar
		s_retu=skpbar(s_popup,s_x)
		exit
	endif

next

return s_retu
* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure deleteitem
*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
private all like d_*
d_recn=recno()
dele
pack
if reccount()>d_recn
	go d_recn
else
	go bott
endif
return

*-P ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure insertitem
*-P ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
private all like i_*

i_recn=recno()
i_tmpf=sys(3)
copy next 10000 to (i_tmpf)
if reccount()>0
	go i_recn
endif
dele next 9999999
appe blan
appe from (i_tmpf)
pack
if reccount()>1
	go i_recn
endif
dele file &i_tmpf..dbf
return

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proc siguiente
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

if .not. eof(w_alias)
	skip 1 in alias (w_alias)
endif

if eof(w_alias)
	?? chr(7)
	**   wait ' Ultimo registro ' wind  nowait
	go top in (w_alias )
endif

do work&w_pfile

return

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure anterior
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

if .not. bof(w_alias)
	skip -1 in (w_alias)
endif

if bof(w_alias)
	?? chr(7)
	**   wait ' Primer registro ' wind nowait
	go bott in (w_alias)
endif

do work&w_pfile

return

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proc primero
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

go top in alias (w_alias )
do work&w_pfile
return

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proc ultimo
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

go bott in alias (w_alias )
do work&w_pfile
return

*-F ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure repdest
*-F ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
private w_arch,w_nomb,w_exte

p_cancela=.t.
p_alia=alias()

p_sepa=set('separator')
p_poin=set('point')
*p_memo=set('memowidth')

set separator to '.'
set point to ','
*set memowidth to 200
set pdsetup to

set status bar off
set safety on

p_repfile=''
p_repfields=''
p_repfor=''
p_repfor2=''
p_repwhile=''

do case
	case p_repout="Pantalla"

		p_repclaus='noconsole preview'

	case p_repout="Impresora"

		if p_mail=0	&& R.11 pa
		p_repclaus='noconsole to printer prompt'
		&& R.11b pa
		else
			p_repclaus='noconsole to printer'
		endif
		&& R.11e pa

	case p_repout="Archivo"

		w_defd= sys(5)+sys(2003)
		**		w_dire= sys(5)+d0path

		**		set default to &w_dire

		do case
			case p_reptype='TXT   Pantalla'
				w_nomb='nombre.txt'
				w_exte='TXT'

			case p_reptype='SDF   System Data Format'
				w_nomb='nombre.txt'
				w_exte='TXT'

			case p_reptype='ASCII con ,'
				w_nomb='nombre.txt'
				w_exte='TXT'

			case p_reptype='ASCII sin ,'
				w_nomb='nombre.txt'
				w_exte='TXT'

			otherwise
				w_nomb='nombre.'+left(p_reptype, 3)
				w_exte=left(p_reptype, 3)
		endcase

		w_arch=putfile("Archivo a grabar?", w_nomb, w_exte)

		if !empty(w_arch) and upper(right(w_arch,3))=w_exte

			**			p_repclaus='noconsole to file &w_arch prompt'

			do case

				case left(p_reptype, 3) ='DBF'
					p_repfile=w_arch

				case left(p_reptype, 3) ='TXT'
					p_repfile=w_arch

				case left(p_reptype, 3) ='SDF'
					p_repfile=w_arch+' type SDF'

				case left(p_reptype, 11)='ASCII con ,'
					p_repfile=w_arch+' delimited '

				case left(p_reptype, 11)='ASCII sin ,'
					p_repfile=w_arch+' delimited with blank '

				otherwise
					p_repfile=w_arch+' type '+left(w_exte,3)

			endcase

		else

			p_repfile=''

		endif

		if p_reptype='TXT   Pantalla' and !empty(p_repfile)
			p_repclaus='noconsole preview'
		else
			p_repclaus=''
		endif

		set default to &w_defd

	otherwise
		** impresion en modo DOS **
	
*		if 	p_reptype2<>'Pantalla' and p_reptype2<>'Archivo'  
*			if advgrave('Verifique que la impresora este encendida. En caso contrario ocurrirแ un error que abortarแ el programa debiendo reiniciar la PC', 'IMPRESION en modo DOS',.t.)='Cancelar'
*				return .f.
*			endif
*		endif		
		
		_genpd='genpd.app'
		set pdsetup to p_repout

		p_repclaus='noconsole to printer'

		if empty(p_report)	&& no hay report
			do case
			case p_reptype2='Pantalla' 
				set printer to file &d0f99.y.txt
			case p_reptype2='Archivo' 
				set printer to file &d0f99.y.txt
			otherwise
*				set printer to &p_reptype2.
*				Mando a un archivo y luego imprimo el archivo con !type >&p_reptype2.
				set printer to file &d0f99.y.txt
			endcase
			set device to printer
			set printer on
			_pdparms[41]=0
			set console off
		endif

endcase

if .not. empty(p_alia)
	sele (p_alia)
endif

p_escape=on('escape')
on escape do cancela

wait window ' Procesando, <Esc> Interrumpe... ' nowait

=skipbar('Registro','ALL',.t.)

set safety off
set escape on

return

*-F ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure represet
*-F ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
private w_arch,w_defd,w_nomb

set safety on

do case

	case p_repout='Pantalla'
		set escape off
		on escape
		set pdsetup to

	case p_repout='Impresora'
		set escape off
		on escape
		set pdsetup to
		set printer to

	case p_repout='Archivo'

		if p_reptype='TXT   Pantalla'
			set escape off
			on escape
			set pdsetup to
		else
			if !empty(p_repfields)
				p_repfields=' fields '+p_repfields
			endif
			if !empty(p_repfor)
				p_repfor=' for '+p_repfor
			endif
			if !empty(p_repwhile)
				p_repwhile=' while '+p_repwhile
			endif

			if !empty(p_repfile)
		
				set safety off

				copy to &p_repfile &p_repfields &p_repfor &p_repfor2 &p_repwhile

			endif

			set escape off
			on escape

		endif

	otherwise
		** impresion en modo DOS **
		**restauro las que puedo cambiar, en setprinter() de preview**
		_pdparms[7]=p_dparms7
		_pdparms[8]=p_dparms8
		_pdparms[9]=p_dparms9
		_pdparms[10]=p_dparms10
		
		_genpd=''

		set escape off
		on escape
		set printer off
		set pdsetup to
		set printer to
		set device to screen
		set console on

		do case
			case p_reptype2='Pantalla'

				w_stat=set('status')
				set status bar off

				w_tfont=7

				DEFINE WINDOW pantalla1 ;
					AT  0.000, 0.000  ;
					SIZE 20.667,76.500 ;
					FONT 'Foxfont',w_tfont ;
					TITLE "Pantalla"+space(40)+'<Esc> -> para salir' ;
					SYSTEM

				zoom wind pantalla1 max
	
				DEFINE WINDOW pantalla2 ;
					AT  0.000, 0.000  ;
					SIZE 17.667,66.500 ;
					FONT 'Foxfont',w_tfont ;
					system ;
					in window pantalla1

				zoom wind pantalla2 max

				acti window pantalla1

				if file(d0f99+'y.txt') and p_cancela

					keyboard '{ctrl+home}'	&& Queda siempre en el comienzo
		
					modi file &d0f99.y.txt window pantalla2 noedit
		
					keyboard '{enter}'	&& cambio el lastkey()=p_esc a =p_enter
					=inkey()
				else
					wait window 'No hay informaci๓n para mostrar'
	
					keyboard '{enter}'	&& cambio el lastkey()=p_esc a =p_enter
					=inkey()

				endif

				rele wind pantalla1,pantalla2

				set status bar &w_stat

			case p_reptype2='Archivo'
			
				w_defd= sys(5)+sys(2003)
				w_nomb='nombre.txt'
				w_exte='TXT'

				w_arch=putfile("Archivo a grabar?", w_nomb, w_exte)

				if !empty(w_arch) and upper(right(w_arch,3))=w_exte
					p_repfile=w_arch
				else
					p_repfile=''
				endif
				set default to &w_defd

				if !empty(p_repfile) and p_cancela
					set safety off
					copy file &d0f99.y.txt to &p_repfile
				endif


			otherwise 	&& impresora DOS
			
				run type &d0f99.y.txt >&p_reptype2.
				
		endcase

endcase

set separator to (p_sepa)
set point to (p_poin)
*set memo to p_memo

set safety off
set status bar on
set message to csalida

=skipbar('Registro','ALL',.f.)

wait clear

p_repout='Pantalla'
p_reptype='TXT   Pantalla'
p_reptype2='LPT1'

show get p_repout
show get p_reptype disable
show get p_reptype2 disable

return

* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure cancela
* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_clre

if sino('Interrumpe proceso ?', 'NO')='S'
	p_cancela=.f.
	if w_clre
		clear read
	endif
endif

return

* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure xxcancela
* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
on escape
p_cancela=.f.
wait ' Interrumpiendo proceso ... ' wind nowait
on escape do cancela
return

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function fhelp
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*function fhelp	&& R.16 pa
parameters f_field,f_pref,f_proc,f_alias,f_clav,f_desc,f_mens,f_adjc,f_retu,f_lock,f_alde,f_prde,f_clde
private all like f_*
f_real = f_field
p_para=parameters()

f_para=.f.
f_elec=.f.
f_last=lastkey()

w_doproc=.f.   && Variable que devuelve si fue llamado el programa del abm

if w_vari=upper(f_field) .or. w_show

	f_memv='m.'+f_field
	f_dbfv=f_alias+'->'+f_clav

	if f_adjc
		if isalpha(eval(f_memv))
			if .not. w_show
				f_orde=order(f_alias)
				set orde to 2 in (f_alias)
				=start(upper(f_pref)+upper(trim(eval(f_memv))),f_alias)
				if !empty(f_alde)
					set orde to 2 in (f_alde)
					f_prde=iif(empty(f_prde),'',upper(f_prde))
					=start(f_prde+upper(trim(eval(f_memv))),f_alde)
					f_dbft=f_alde+'->'+f_desc
				else
					f_dbft=f_alias+'->'+f_desc
				endif
				if upper(eval(f_dbft))=upper(trim(eval(f_memv)))
					if !empty(f_alde)
						skip in alias (f_alde)
					else
						skip in alias (f_alias)
					endif
					if upper(eval(f_dbft))=upper(trim(eval(f_memv)))
						f_elec=.t.
					else
						if !empty(f_alde)
							if eof(f_alde)
								go bott in (f_alde)
							else
								skip -1 in alias (f_alde)
							endif
							if .not. empty(f_prde)
								&f_memv=left(eval(f_alde+'->'+f_clde),ftable(f_prde,'len'))
							else
								&f_memv=eval(f_alde+'->'+f_clde)
							endif
						else
							if eof(f_alias)
								go bott in (f_alias)
							else
								skip -1 in alias (f_alias)
							endif
							if .not. empty(f_pref)
								&f_memv=left(eval(f_dbfv),ftable(f_pref,'len'))
							else
								&f_memv=eval(f_dbfv)
							endif
						endif
					endif
					if !empty(f_alde)
						if eof(f_alde)
							go bott in (f_alde)
						else
							skip -1 in alias (f_alde)
						endif
					else
						if eof(f_alias)
							go bott in (f_alias)
						else
							skip -1 in alias (f_alias)
						endif
					endif
				else
					f_elec=.t.
				endif

				if !empty(f_alde)
					set orde to 2 in (f_alde)
				endif
				set orde to f_orde in (f_alias)

			endif
		else

			if .not. ( val(eval(f_memv))=0 .and. w_show )
				&f_memv=strcero(eval(f_memv))
				show get (f_memv)
			endif

			*         if .not. seek(upper(f_pref)+eval(f_memv),f_alias)
			*            f_elec=.t.
			*         endif
		endif
	else
		if .not. seek(upper(f_pref)+eval(f_memv),f_alias)
			if .not. w_show
				f_orde=order(f_alias)
				set orde to 2 in (f_alias)
				if start(upper(f_pref)+trim(eval(f_memv)),f_alias)
					f_elec=.t.
				endif
				set orde to f_orde in (f_alias)
			endif
		endif
	endif

	f_f3f4=.f.

	if f_elec .or. w_alta .or. lastkey()=p_f3 .or. lastkey()=p_f4
		*      f_alta

		if lastkey()=p_f3 .or. lastkey()=p_f4
			f_f3f4=.t.
		endif

		if .not. f_elec 
			=seek(upper(f_pref)+eval(f_memv),f_alias)
		endif

		*      if .not. empty(f_pref)
		*         f_key=f_pref
		*      else
		*         f_key=eval(f_memv)
		*      endif

		f_key=f_pref

		w_doproc=.t.
		f_para=.t.
		do &f_proc with f_key,f_para
		if lastkey() = 27
			f_field = f_real
			show get f_field
			w_retu= .f.
			return(w_retu)
		endif
		if f_f3f4
			keyb '{Enter}'
		endif

		if .not. empty(f_pref)
			&f_memv=left(eval(f_dbfv),ftable(f_pref,'len'))
		else
			&f_memv=eval(f_dbfv)
		endif

	endif

	if .not. f_para
		if .not. seek(upper(f_pref)+eval(f_memv),f_alias)

*			if f_last<>p_up
				&f_retu=.f.
				if .not. w_show
					wait f_mens wind
				endif
*			endif

		else
			show get (f_memv)

			** Bloqueo segun parametro

			if p_para=10
				if f_lock .and. .not. w_show
					** wait ' Bloqueo ' wind time .5
					if .not. rlock(f_alias)
						wait ' Registro utilizado por otra terminal ! ' wind
						f_retu=.f.
					endif
				endif
			endif

		endif
	endif

	if .not. empty(f_desc)
		if !empty(f_alde)
			f_prde=iif(empty(f_prde),'',upper(f_prde))
			=seek(f_prde+(trim(eval(f_memv))),f_alde)
			if empty(trim(eval(f_memv)))
				=db_goeof(f_alde)
			endif
			f_dbfv=f_alde+'->'+f_desc
		else
			f_dbfv=f_alias+'->'+f_desc
		endif
		f_memv='w_'+right(f_field,4)
		&f_memv=eval(f_dbfv)
		show get (f_memv)
	endif

endif

return f_retu

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function st_rlock
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters d_alias,d_mens
private all like d_*
d_para=parameters()

do case
	case d_para=0
		d_alias=''
		d_mens=.t.
	case d_para=1
		d_mens=.f.
endcase

d_retu=.f.
d_alian=alias()

if .not. empty(d_alias)
	sele (d_alias)
endif

if lower(sys(2011))='record locked' .or.  lower(sys(2011))='exclusive'
	d_retu=.t.
else
	if d_mens
		if upper(d_alias)='F98' and used('F98')
			wait ' Registro ('+iif(!empty(f98.d98desc),alltrim(f98.d98desc),f98.d98alia)+') en ('+d_alias+') utilizado por otra terminal, aguarde unos instantes... ' wind time 2
		else
			wait ' Registro en : ('+d_alias+') utilizado por otra terminal, aguarde unos instantes... ' wind time 2
		endif
	endif
endif

if .not. empty(d_alian)
	sele (d_alian)
endif

return d_retu

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function db_rlock
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters d_alias,d_time
private all like d_*

d_para=parameters()

do case
	case d_para=0
		d_alias=''
		d_time=0
	case d_para=1
		d_time=0
endcase

if type('d_alias')='L'
	d_alias=''
endif
if type('d_time')='L'
	d_time=0
endif

d_retu=.f.
d_alian=alias()

if !empty(d_alias)
	sele (d_alias)

	if !eof(d_alias)
		go recno(d_alias) in (d_alias)
	endif

	do while .not. rlock(d_alias)
		=st_rlock(d_alias,.t.)
		flush
	enddo
endif

if .not. empty(d_alian)
	sele (d_alian)
endif

if d_time<>0
	=inkey(d_time)
endif

return d_retu
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function st_flock
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters d_alias,d_mens
private all like d_*

d_para=parameters()

do case
	case d_para=0
		d_alias=''
		d_mens=.t.
	case d_para=1
		d_mens=.f.
endcase

d_retu=.f.
d_alian=alias()

if .not. empty(d_alias)
	sele (d_alias)
endif

if lower(sys(2011))='file locked' .or. lower(sys(2011))='exclusive'
	d_retu=.t.
else
	if d_mens
		if upper(d_alias)='F98' and used('f98')
			wait ' Registro ('+iif(!empty(f98.d98desc),alltrim(f98.d98desc),f98.d98alia)+') en ('+d_alias+') utilizado por otra terminal, aguarde unos instantes... ' wind time 2
		else
			wait ' Registro en : ('+d_alias+') utilizado por otra terminal, aguarde unos instantes... ' wind time 1
		endif
	endif
endif

if .not. empty(d_alian)
	sele (d_alian)
endif

return d_retu
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function db_flock
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters d_alias
private all like d_*
if parameters()=0
	d_alias=''
endif

d_retu=.f.
d_alian=alias()

if .not. empty(d_alias)
	sele (d_alias)
endif

do while .not. flock()
	=st_flock(d_alias,.t.)
	flush
enddo

if .not. empty(d_alian)
	sele (d_alian)
endif

return d_retu
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure db_rlocks
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters db_loc1,db_loc2,db_loc3,db_loc4,db_loc5,db_loc6,db_loc7,db_loc8,db_loc9
private all like db_*

db_para=parameters()
db_lock=.t.
db_alian=alias()

do while .t.

	for db_x=1 to db_para

		db_temp='db_loc'+str(db_x,1)
		db_alia=eval(db_temp)

		sele (db_alia)

		if !eof(db_alia)
			go recno(db_alia) in (db_alia)
		endif

		if .not. rlock(db_alia)
			=st_rlock(db_alia,.t.)
			db_lock=.f.

			flush
			exit
		endif

	next

	if .not. db_lock

		for db_x=1 to db_para
			db_xxxx='db_loc'+str(db_x,1)
			db_alia=eval(db_xxxx)
			unlock in (db_alia)
		next

		db_lock=.t.

	else
		exit
	endif

enddo

if .not. empty(db_alian)
	sele (db_alian)
endif

return .t.
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure db_flocks
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters db_loc1,db_loc2,db_loc3,db_loc4,db_loc5,db_loc6,db_loc7,db_loc8,db_loc9
private all like db_*

db_para=parameters()
db_lock=.t.

db_alian=alias()

do while .t.

	for db_x=1 to db_para

		db_temp='db_loc'+str(db_x,1)
		db_alia=eval(db_temp)

		sele (db_alia)

		if .not. flock(db_alia)
			=st_flock(db_alia,.t.)
			db_lock=.f.

			flush

			exit
		endif
	next

	if .not. db_lock

		for db_x=1 to db_para
			db_xxxx='db_loc'+str(db_x,1)
			db_alia=eval(db_xxxx)
			unlock in (db_alia)
		next

		db_lock=.t.

	else
		exit
	endif

enddo

if .not. empty(db_alian)
	sele (db_alian)
endif

return .t.
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure db_index
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters i_pack
private all like i_*

if type('fieldvec')='U'
	dimension fieldvec(1)
endif

fieldvec[1] = 'F98'

if !used('f98')
	f_acce=1
	do while .t.
		fieldvec[1] = 'F98'
		use &d0f98 in 0 alias f98 order d98alia
		if !neterr()
			exit
		else
			if f_acce>=3	&& tres intentos
				return
   			endif
			f_acce=f_acce+1
		endif
	enddo
endif

sele f98

p_updtherm=.t.
p_acctherm=0
p_tottherm=reccount()

do acttherm with 'Verificando archivos...'

go top in f98
i_reccount=0

do while .not. eof('f98')

	i_file=trim(f98->d98file)
	i_alia=trim(f98->d98alia)

	=fupdtherm()

	if  empty(f98->d98in01)
		skip in f98
		loop
	endif

	f_acce=1
	do while .t.
		use (i_file) in 0 alias (i_alia) exclusive

		if !neterr()
			exit
		else
			if f_acce>=3	&& tres intentos
				do deactthermo
				return
	    	endif
			f_acce=f_acce+1
		endif
	enddo

	sele (i_alia)
	i_reccount=i_reccount+reccount()

	use
	skip in f98

enddo

=fupdtherm()

p_acctherm=0
p_tottherm=i_reccount

if i_pack
	p_text1='Compactando archivos...'
else
	p_text1='Generando indices...'
endif

do acttherm with p_text1

go top in f98

do while .not. eof('f98')

	i_file=trim(f98->d98file)
	i_alia=trim(f98->d98alia)

	if  empty(f98->d98in01)
		skip in f98
		loop
	endif

	=fupdtherm(f98->d98desc)

	do while .t.
		use (i_file) in 0 alias (i_alia) exclusive
		if !neterr()
			exit
		else
			if f_acce>=3	&& tres intentos
				do deactthermo
				return
	    	endif
			f_acce=f_acce+1
		endif
	enddo

	sele (i_alia)

	dele tag all

	p_acctherm=p_acctherm+reccount()
	=fupdtherm()

	if i_pack
		*      wait ' Compactando archivo de '+trim(f98->d98desc)+'... ' wind nowait
		pack
	endif

	*   wait ' Generando indices de '+trim(f98->d98desc)+'... ' wind nowait

	for i_x=1 to 20
		i_s=strcero(str(i_x,2))

		if type('f98.d98in&i_s')='U'
			exit
		endif

		i_i=trim(f98->d98in&i_s)
		i_t=trim(f98->d98ta&i_s)
		if .not. empty(i_i)
			set orde to 0 in (i_alia)
			inde on &i_i tag (i_t)
		endif
	next

	use

	skip in f98

enddo

do deactthermo

wait clear

=closall()

return

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure db_indexfile
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters i_alias,i_pack
private all like i_*

if parameters()=1
	i_pack=.f.
endif

i_alias=trim(upper(i_alias))
i_alian=alias()

if !used('f98')
	f_acce=1
	do while .t.
		fieldvec[1] = 'F98'
		use &d0f98 in 0 alias f98 order d98alia
		if !neterr()
			exit
		else
			if f_acce>=3	&& tres intentos
				return
   			endif
			f_acce=f_acce+1
		endif
	enddo
endif

sele f98

if empty(order('f98'))
	set order to d98alia
endif

=seek(i_alias)

if  empty(f98->d98in01)

	if .not. empty(i_alian)
		sele (i_alian)
	endif
	return

endif

p_updtherm=.t.
p_acctherm=0
p_tottherm=1

if i_pack
	p_text1='Compactando archivos...'
else
	p_text1='Generando indices...'
endif

do acttherm with p_text1

=fupdtherm(f98->d98desc)

i_file=''

if !used(i_alias)

	i_file=trim(f98->d98file)
	i_alia=trim(f98->d98alia)

	do while .t.
		use (i_file) in 0 alias (i_alia) exclusive
		if !neterr()
			exit
		else
			if f_acce>=3	&& tres intentos
				do deactthermo
				return
	    	endif
			f_acce=f_acce+1
		endif
	enddo

endif

sele (i_alias)

dele tag all

if i_pack
	pack
endif

for i_x=1 to 10
	i_s=strcero(str(i_x,2))
	i_i=trim(f98->d98in&i_s)
	i_t=trim(f98->d98ta&i_s)
	if .not. empty(i_i)
		inde on &i_i tag (i_t)
	endif
next

if !empty(i_file)	&& debio abrir la base a indexar
	use in &i_alias
endif

if .not. empty(i_alian)
	sele (i_alian)
endif

do deactthermo

wait clear

return

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure db_name
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters i_alias
private all like i_*

i_retu=''
i_alian=alias()

if type('fieldvec')='U'
	dimension fieldvec(1)
endif
fieldvec[1] = 'F98'

if .not. used('F98')
	use (d0f98) in 0 alias f98 orde d98alia
	if neterr()
		fieldvec=''
		return i_retu
	endif
endif

fieldvec=''

sele f98

=seek(upper(i_alias),'f98')
i_retu=trim(upper(f98->d98desc))

if .not. empty(i_alian)
	sele (i_alian)
endif

return i_retu

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure db_tagcod
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters i_alias
private all like i_*

i_retu=''
i_alian=alias()

if type('fieldvec')='U'
	dimension fieldvec(1)
endif
fieldvec[1] = 'F98'

if .not. used('F98')
	use (d0f98) in 0 alias f98 orde d98alia
	if neterr()
		fieldvec=''
		return i_retu
	endif
endif

fieldvec=''

sele f98
=seek(upper(i_alias),'f98')
i_retu=''

if .not. empty(d98tgnu)
	i_vari='d98ta'+d98tgnu
	i_retu=trim(eval(i_vari))
endif

if .not. empty(i_alian)
	sele (i_alian)
endif

return i_retu

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure db_tagdes
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters i_alias
private all like i_*

i_retu=''
i_alian=alias()

if type('fieldvec')='U'
	dimension fieldvec(1)
endif
fieldvec[1] = 'F98'

if .not. used('F98')
	use (d0f98) in 0 alias f98 orde d98alia
	if neterr()

		fieldvec=''
		return i_retu
	endif
endif

fieldvec=''

sele f98
=seek(upper(i_alias),'f98')

i_retu=''
if .not. empty(d98tgal)
	i_vari='d98ta'+d98tgal
	i_retu=trim(eval(i_vari))
else
	if .not. empty(d98tgnu)
		i_vari='d98ta'+d98tgnu
		i_retu=trim(eval(i_vari))
	endif
endif

if .not. empty(i_alian)
	sele (i_alian)
endif

return i_retu

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
    PROCEDURE db_capt
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PARAMETERS i_alias
PRIVATE ALL LIKE i_*
private auxemp

i_retu=''
i_alian=alias()

if .not. used('F98')
	if type('fieldvec')='U'
		dimension fieldvec(1)
	endif

	f_acce=1
	do while .t.
		fieldvec[1] = 'F98'
		use (d0f98) in 0 alias f98 orde d98alia
		if !neterr()
			exit
		else
			if f_acce>=3	&& tres intentos
				return
   			endif
			f_acce=f_acce+1
		endif
	enddo
	fieldvec=''
endif

if !file('ssf097.dbf')
	sele 0
	create dbf ssf097.dbf (d97empr c(3), d97alia c(4))
	use ssf097 alias f97 exclusive
	index on d97empr+upper(d97alia) tag d97alia
	f_acce=1
	do while .t.
		fieldvec[1] = 'F97'
		use ssf097 alias f97 orde d97alia
		if !neterr()
			exit
		else
			if f_acce>=3	&& tres intentos
				return
   			endif
			f_acce=f_acce+1
		endif
	enddo
	fieldvec=''
else
	if !used('f97')
		f_acce=1
		do while .t.
			fieldvec[1] = 'F97'
			use ssf097 in 0 alias f97 orde d97alia
			if !neterr()
				exit
			else
				if f_acce>=3	&& tres intentos
					=mquit()
   				endif
				f_acce=f_acce+1
			endif
		enddo
		fieldvec=''
	endif
endif

sele f98

if seek(upper(i_alias),'f98')
	=db_rlock('f98')

	if !f98.d98sist && es de empresa loqueo f97
		if d0coem+'\'$d0&i_alias.
			if !seek(d0coem+' '+upper(i_alias),'f97')
				=net_appe('f97')
				=set_alia('f97')
				repla d97empr with d0coem, d97alia with upper(i_alias)
				=rest_alia()
			endif
		else	&& por el caso de direccionamiento a otra empresa
			auxemp=subs(d0&i_alias., at('\',d0&i_alias.)-2, 2)
			if !seek(auxemp+' '+upper(i_alias),'f97')
				=net_appe('f97')
				=set_alia('f97')
				repla d97empr with auxemp, d97alia with upper(i_alias)
				=rest_alia()
			endif
		endif
		unlock in f98
		=db_rlock('f97')
	endif
endif

sele(i_alias)
if !eof(i_alias)
	i_recno=recno()
	go top
	go i_recno
else
	go top
	go bottom
	if !eof(i_alias)
		skip
	endif
endif

if .not. empty(i_alian)
   sele (i_alian)
endif

return i_retu

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure xdb_capt	&& no uso mas esta version
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters i_alias
private all like i_*

i_retu=''
i_alian=alias()

if .not. used('F98')
	if type('fieldvec')='U'
		dimension fieldvec(1)
	endif
	fieldvec[1] = 'F98'
	
	do while .t.
		use (d0f98) in 0 alias f98 orde d98alia
		if !neterr()
			exit
		endif
	enddo
	fieldvec=''
endif

sele f98

=seek(upper(i_alias),'f98')
=db_rlock('f98')

sele(i_alias)
if !eof(i_alias)
	i_recno=recno()
	go top
	go i_recno
else
	go top
	go bottom
	if !eof(i_alias)
		skip
	endif
endif

if .not. empty(i_alian)
	sele (i_alian)
endif

return i_retu

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure db_goeof
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters i_alias
private all like i_*

i_alian=alias()

sele (i_alias)

if .not. eof()

	go bott in (i_alias)

	if .not. eof()
		skip in alias (i_alias)
	endif
endif

if .not. empty(i_alian)
	sele (i_alian)
endif

return .t.

*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure db_gobof
*-R อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters i_alias
private all like i_*

i_alian=alias()

sele (i_alias)

if .not. empty(reccount(i_alias))
	go top in (i_alias)
	skip -1 in alias (i_alias)
endif

if .not. empty(i_alian)
	sele (i_alian)
endif

return .t.

*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function fvread
*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

deactivate window all

if .not. empty(p_popup) .and. .not. empty(p_bar) .and. p_mean=1 .and. .not. p_read
	p_popu1=p_popup
	p_popup=''
	wait wind '' time 0.2	&& R.07 Mariano
	activate popup &p_popu1 bar p_bar
endif

if wexist('BARRAABM')
	release window barraabm
endif

set message to csalida

return p_read

* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure fsalir
* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
p_read=.t.
clear read
on error
set sysm to defa
set resource off
deac wind all

return
*******************************************************************************
function net_open
*******************************************************************************

parameters carch,calias,cexclu,corder
private uno, w_vuelve

w_vuelve = .f.
uno =0

do while .t.
	if parameters() = 3
		if !cexclu
			use (carch)  in 0 alias (calias)
		else
			use (carch)  in 0 alias (calias) exclusive
		endif
	endif

	if parameters() = 4
		if !cexclu
			use (carch) in 0 alias (calias) order (corder)
		else
			use (carch) in 0 alias (calias) order (corder) exclusive
		endif
	endif

	if p_neterr
		wait wind 'Archivo '+(carch) + ' tomado por otro usuario... ' time 3
	else
		w_vuelve = .t.
		exit
	endif

	uno = uno + 1
	if uno >3
		exit
	endif
enddo

return(w_vuelve)
***********************************************************************
procedure nada
return

***************************************************************************
* FUNCTION Fhelpx (BROWSEADO/ALTA MEDIANTE F4+F5)
* By Hugo Charles, junio 1998 for all the people
*       ---alternativa a la funcion FHELP -------
*________________________________________________________________________

************************************************************************

function anidado

priv a_char
a_char=''
for i=1 to 32
	if empty(program(i))
		exit
	endif
	a_char=a_char+program(i)+','
next
return a_char

*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure mapeofb
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters s_x
private w_i, w_prompt, w_todos, w_wind

if wexist("BARRAABM")

	if parameters()=0
		w_todos=.t.
		w_i=1
	else
		w_todos=.f.
		w_i=s_x
	endif

	do while type('w_i')='N'	&& si es numerico

		w_prompt=upper(alltrim(prmbar('registro', w_i)))

		do case
			case w_prompt == upper('Consultar')

				if skpbar('registro', w_i) or mprot(p_user, w_prog, 'registro', prmbar('registro', w_i))
					show get p_baropc1,1 disable
				else
					show get p_baropc1,1 enable
				endif

			case w_prompt == upper('Buscar')

				if skpbar('registro', w_i) or mprot(p_user, w_prog, 'registro', prmbar('registro', w_i))
					show get p_baropc1,2 disable
				else
					show get p_baropc1,2 enable
				endif

			case w_prompt == upper('Ordenado por C๓digo')

			case w_prompt == upper('Ordenado por Descripci๓n')

			case w_prompt == upper('Agregar')

				if skpbar('registro', w_i) and skpbar('registro', w_i+1) && por el Modificar
					show get p_baropc2,1 disable
				else
					if mprot(p_user, w_prog, 'registro', prmbar('registro', w_i)) and mprot(p_user, w_prog, 'registro', prmbar('registro', w_i+1))
						show get p_baropc2,1 disable
					else
						show get p_baropc2,1 enable
					endif
				endif

			case w_prompt == upper('Modificar')

				if skpbar('registro', w_i) and skpbar('registro', w_i-1) && por el Agregar
					show get p_baropc2,1 disable
				else
					if mprot(p_user, w_prog, 'registro', prmbar('registro', w_i)) and mprot(p_user, w_prog, 'registro', prmbar('registro', w_i-1))
						show get p_baropc2,1 disable
					else
						show get p_baropc2,1 enable
					endif
				endif

			case w_prompt == upper('Eliminar')

				if skpbar('registro', w_i) or mprot(p_user, w_prog, 'registro', prmbar('registro', w_i))
					show get p_baropc2,2 disable
				else
					show get p_baropc2,2 enable
				endif

			case w_prompt == upper('Insertar')

				if skpbar('registro', w_i) or mprot(p_user, w_prog, 'registro', prmbar('registro', w_i))
					show get p_baropc2,3 disable
				else
					show get p_baropc2,3 enable
				endif

			case w_prompt == upper('Ir al Anterior')

				if skpbar('registro', w_i) or mprot(p_user, w_prog, 'registro', prmbar('registro', w_i))
					show get p_baropc3,1 disable
				else
					show get p_baropc3,1 enable
				endif

			case w_prompt == upper('Ir al Siguiente')

				if skpbar('registro', w_i) or mprot(p_user, w_prog, 'registro', prmbar('registro', w_i))
					show get p_baropc3,2 disable
				else
					show get p_baropc3,2 enable
				endif

			case w_prompt == upper('Ir al Primero')

				if skpbar('registro', w_i) or mprot(p_user, w_prog, 'registro', prmbar('registro', w_i))
					show get p_baropc3,3 disable
				else
					show get p_baropc3,3 enable
				endif

			case w_prompt == upper('Ir al Ultimo')

				if skpbar('registro', w_i) or mprot(p_user, w_prog, 'registro', prmbar('registro', w_i))
					show get p_baropc3,4 disable
				else
					show get p_baropc3,4 enable
				endif

			case w_prompt == upper('Elegir')

				if skpbar('registro', w_i) or mprot(p_user, w_prog, 'registro', prmbar('registro', w_i))
					show get p_baropc4,1 disable
				else
					show get p_baropc4,1 enable
				endif

			case w_prompt == upper('Calculadora')

				if skpbar('registro', w_i) or mprot(p_user, w_prog, 'registro', prmbar('registro', w_i))
					show get p_baropc4,2 disable
				else
					show get p_baropc4,2 enable
				endif

			case w_prompt == upper('Salir')

				if skpbar('registro', w_i)
					show get p_baropc4,3 disable
				else
					show get p_baropc4,3 enable
				endif

		endcase

		if !w_todos or w_i = cntbar('registro')

			exit

		else

			w_i=w_i+1

		endif


	enddo

endif

return

*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure irclave	&& ir a la clave
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_vclave, w_siget

private x_alia

if !alias()=w_alias and type(w_vari)='U'	&& si estoy parado en otra base y no tiene el campo a comparar
	x_alia=alias()
	sele(w_alias)
else
	x_alia=''
endif

**** si modifico algun campo y quiere ir al campo clave *****
if w_modicampo

	if w_vari==w_vclave	&& campo clave

		if sino('Desea perder las modificaciones ?', 'NO', 'Campo Clave')='S'

*===> Agregado para que restaure efectivamente los campos
			scatter memvar 
			show gets
			w_modicampo=.f.

		else

			w_retu=.f.
			_curobj=objnum(&w_siget)

		endif
	endif

endif
**************************

if !empty(x_alia)
	sele(x_alia)
endif

return

*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure ultdepri	&&	va al ultimo campo desde el primer campo (ciclo)
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_vclave, w_ultget
*private x_alia		&& R.05 Mariano
private x_alia, w_retu	&& R.05 Mariano

w_retu=.f.		&& R.05 Mariano


if !alias()=w_alias and type(w_vari)='U'	&& si estoy parado en otra base y no tiene el campo a comparar
	x_alia=alias()
	sele(w_alias)
else
	x_alia=''
endif

if w_vari==w_vclave
	
	*si el lastkey()=p_pgup como cambia de screen se trata en la barraabm
	*shift+tab=15
	
	if lastkey()=p_sh_tab or lastkey()=p_home or lastkey()=p_left or lastkey()=p_up or lastkey()=p_bspace

		_curobj=objnum(&w_ultget)	&& Ultimo get de la screen principal

        w_retu=.t.	&& R.05 Mariano

	endif

endif

if !empty(x_alia)
	sele(x_alia)
endif

*return	&& R.05 Mariano
return(w_retu)	&& R.05 Mariano

*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure prideult	&& va al primer campo desde el ultimo campo	(ciclo)
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_ultcampo, w_ultget

private x_alia

if !alias()=w_alias and type(w_vari)='U'	&& si estoy parado en otra base y no tiene el campo a comparar
	x_alia=alias()
	sele(w_alias)
else
	x_alia=''
endif

if w_vari==w_ultcampo

	*****Si modifica ultimo campo*****
	if w_modicampo=.f. and w_retu

		w_modicampo = !(&w_vread == &w_vari)

	endif
	************************************

	*si el lastkey()=p_pgdn como cambia de screen se trata en la barraabm

	if (lastkey()=p_tab or lastkey()=p_end or lastkey()=p_right or lastkey()=p_down or lastkey()=p_enter or lastkey()=p_ctrl_w)

		if w_modicampo	&& no sigo navegando

			keyboard '{home}'	&& Cambia el lastkey() y puedo usar botonera
			=inkey()
			_curobj=objnum(&w_ultget)	&& mantengo el get activo

		else

			_curobj=1	&& navegando

		endif

	endif

endif

if !empty(x_alia)
	sele(x_alia)
endif

return

*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure modicampo	&& verifica si se modifico un campo distinto al clave
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_vclave1, w_vclave2, w_vclave3, w_vclave4, w_vclave5, w_vclave6, w_vclave7, w_vclave8

private x_alia

if !alias()=w_alias and type(w_vari)='U'	&& si estoy parado en otra base y no tiene el campo a comparar
	x_alia=alias()
	sele(w_alias)
else
	x_alia=''
endif

do case
	case parameters()=0
		store ' ' to w_vclave1, w_vclave2, w_vclave3, w_vclave4, w_vclave5, w_vclave6, w_vclave7, w_vclave8
	case parameters()=1
		store w_vclave1 to w_vclave2, w_vclave3, w_vclave4, w_vclave5, w_vclave6, w_vclave7, w_vclave8
	case parameters()=2
		store w_vclave1 to w_vclave3, w_vclave4, w_vclave5, w_vclave6, w_vclave7, w_vclave8
	case parameters()=3
		store w_vclave1 to w_vclave4, w_vclave5, w_vclave6, w_vclave7, w_vclave8
	case parameters()=4
		store w_vclave1 to w_vclave5, w_vclave6, w_vclave7, w_vclave8
	case parameters()=5
		store w_vclave1 to w_vclave6, w_vclave7, w_vclave8
	case parameters()=6
		store w_vclave1 to w_vclave7, w_vclave8
	case parameters()=7
		store w_vclave1 to w_vclave8
endcase

*****Si modifica algun campo que no sea el campo clave*****
if w_modicampo=.f. and w_retu and !w_show and !(w_vari==w_vclave1) and !(w_vari==w_vclave2) and !(w_vari==w_vclave3) and !(w_vari==w_vclave4) ;
		and !(w_vari==w_vclave5) and !(w_vari==w_vclave6) and !(w_vari==w_vclave7) and !(w_vari==w_vclave8) and !(lastkey()=p_esc)

	w_modicampo = !(&w_vread == &w_vari)

endif
************************************

if !empty(x_alia)
	sele(x_alia)
endif

return


*-f ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function salimodi	&& salida preguntando si modifico
*-f ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

if w_modicampo	&& hay modificaciones
	if sino('Desea perder las modificaciones ?', 'NO', 'Salir')='S'
		w_modicampo=.f.
	else
		return .f.
	endif
endif

return .t.

*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure gentmp	&& Generando datos para temporario antes del report
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

p_cancela=.t.
wait window 'Generando Datos, <ESC> Aborta...' nowait
set escape on
on escape do abotmp

return

*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure abotmp	&& Aborta temporario y antes del report
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

p_cancela=.f.
set escape off
on escape
wait window 'Generaci๓n Abortada.' timeout 2
clear read

return

*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proc mchkbox
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*
*
*	Debe ser un objeto del tipo chkbok o radio bottom
*	La variable que lo controla debe ser de tipo booleano (.t. , .f.) o numerico (1 , 0)
*	Si aparece el w_radio, significa que es el valor del radio bottom antes de cambiarlo.
*   El parametro que recibe, es el nombre del objeto(variable), y debe ser pasada al procedimiento
*	por REFERENCIA.
*
*	Altera el modo de navegacion del objeto, entonces la unica manera de marcar o desmarcar al mismo,
*	se hace a travez de la tecla SPACE o CLICK-IZQUIERDO del mouse y no con ENTER(pasa al siguiente objeto)
*
*	ej: mchkbox(@w_chk)
*	ej: mchkbox(@w_chk,3)	&& para radio bottom con varias opciones
**************************************************************************************************
parameters pobjvar, w_radio

if lastkey() = p_enter

	keyboard '{tab}'	&& cambio el lastkey()
	=inkey()			&& obligo al cambio del lastkey() y consumo buffer teclado

	do case
		case type('pobjvar')='L'
			pobjvar=iif(pobjvar,.f.,.t.)
		case type('pobjvar')='N' and type('w_radio')='N'
			pobjvar=w_radio
		case type('pobjvar')='N'
			pobjvar=iif(pobjvar=1,0,1)
	endcase			
		
	show get pobjvar

endif

return

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proc ap	&& accion de los programas desde el menu
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters a_prg, a_menu, a_para3, a_para4

private all like a_*

if rdlevel()=1
	p_popup=popup()
	p_bar=bar()
endif

if wsuper	&& Entra en modo proteccion

	if !p_user='SUPERVISOR'

		if !empty(a_menu) and p_ayuda and !mrkbar(popup(),bar())

			w_prog=upper(prompt())

			lresp777=.f.

			push menu _msysmenu

			set skip of menu _msysmenu .t.

			do &a_menu		&& Menu Ayuda

			keyboard '{alt+y}'

			read valid lresp777

			pop menu _msysmenu

			w_prog='PRINCIPAL'
		else

			if !p_ayuda

				a_popup=popup()
				
				if bar()>0

					set mark of bar bar() of &a_popup to !mrkbar(popup(),bar())

					do prgraba with upper(popup()),upper(prompt())

				endif

				keyboard '{Esc}'

			else

				keyboard '{Esc}'

			endif

		endif

	endif

else	&& ejecuta programa

	***graba donde estaba por una posible salida anormal***
	if used('f77')
		=set_alia('f77')
		if .not. empty(nf_reem)

			go nf_reem
	
			replace d77prog with ' Dํa:'+dtoc(date())+' Hora:'+time()+' Prog:'+a_prg+' '+csalida

			if !eof('f77')
				go recno('f77') in f77
			endif

		endif
		=rest_alia()
	endif
	*********************************************************

	do &a_prg	&& los parametros del programa estan dentro de a_prg

	read when .f.	&& bajo y subo un nivel de read

endif


return

*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proc ac	&& accion de las funciones del menu ayuda
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters a_prg, a_preg

private all like a_*

if parameters()=1
	a_preg=.f.
endif

if wsuper and !(p_popup='VARPRT')	&& Entra en modo proteccion

	if !p_user='SUPERVISOR'

		if prompt()=='Salir'

			lresp777=.t.

			keyboard '{esc}'


		else

			a_popup=popup()

			if bar()>0

				set mark of bar bar() of &a_popup to !mrkbar(popup(),bar())

				do prgraba with upper(popup()),upper(prompt())

			endif

			keyboard '{alt+y}'

		endif

	endif

else		&& ejecuta accion

	****** No esta definida la variable de modificacion de campo o No modifico nada****

	if iif(type('w_modicampo')="U", .t., w_modicampo=.f.)

		do &a_prg

	else	&& Existe la variable de modificacion de campo del archivo

		if a_preg

			if sino('Desea perder las modificaciones ?', 'NO', prompt())='S'
				do &a_prg
				w_modicampo=.f.
			endif

		else

			do &a_prg

		endif
	endif

endif

return


*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proce actcalcu	&& activa calculadora
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

activate window calculator
move window calculator center
zoom window calculator norm

keyboard '{esc}'
=inkey()		&& cambio el lastkey() de prepo
wait window '' timeout 0.5
return


*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proce actelegir	&& activa elegir
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

if lastkey()=p_f4
	do valid&w_pfile
else
	keyboard '{f4}'
endif

return

*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proce actsalir	&& activa salir
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

keyboard '{esc}'

return

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proce setayuda
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
private all like w_*

w_mtitu=iif(p_ayuda, 'Men๚ Ayuda Activado', 'Men๚ Ayuda Desactivado')
w_macde=iif(p_ayuda, 'Desactivar', 'Activar')
w_opcion=left(w_macde,1)

if sino(' Confirma '+w_macde+' ? ', 'NO', w_mtitu)='S'

	if w_opcion='A'

		p_ayuda=.t.

	else

		p_ayuda=.f.

	endif

endif

return


*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function closall  && Cierra todos las areas de 2 a 225
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

cl_bu=0

if 'F77'$alias(1)
	cl_dear=2
else
	cl_dear=1
endif

for cl_bu=cl_dear to 225
	cl_ar=str(cl_bu,3)
	sele &cl_ar
	use
next

close alternate
close format

fieldvec=''	&& inicializa el vector

return ''


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
func inisetimp
* --------------------------------------
* Inicializa Handles y Variables que usaran las funciones
* de seteo de impresoras
*
public h_tomaimp, h_grabimp
h_tomaimp = regfn('GetProfileString','CCC@CI','I')
h_grabimp = regfn('WriteProfileString','CCC','L')
public imppre  && Impresora Predeterminada
imppre = impact()
=getprinters()
return ''
* ----------------------------------------
function impact
* ----------------------------------------
* Retorna Impresora Actual
*
private idevicename, idevlen
idevicename = replicate(chr(0), 255)
idevlen = callfn(h_tomaimp,iif(dispOk('c:\windows'),'windows','winnt'),'device','Not-Installed',@idevicename,255)
return left(idevicename, idevlen)
* ---------------------------------------
function setimp
* ---------------------------------------
* Setea Impresora Indicada en SDEVICENAME
*
parameter sdevicename
private sdevname,sret
sdevname = alltrim(sdevicename)
if empty(sdevname)
	* Si la impresora esta vacia, setea la predeterminada
	sdevname=imppre
endif

if impact()=sdevname
	sret = .t.
else
	sret = iif(callfn(h_grabimp,iif(dispOk('c:\windows'),'windows','winnt'),'device',sdevname)>0, .t., .f.)
endif
return sret
* -------------------------------------------
function getprinters
* -------------------------------------------
* Inicializa Vector PRINTERS con Nombres de Impresoras
*            Vector WINDEV   con DEVICE completo
*
private dfound, filehandle
public array windev  [20]
public array printers[20]

filehandle = f_open(dimaqi()+'WIN.INI')

pinst = 0
tmps = ''
dfound = .f.
do while  .not. f_eof(filehandle) .and.  .not. dfound
	tmps = f_gets(filehandle)
	if atc('[devices]', tmps)>0
		dfound = .t.
	endif
enddo
if  .not. dfound
	dfound = .f.
	=f_seek(filehandle, 0, 0)
	do while  .not. f_eof(filehandle) .and.  .not. dfound
		tmps = f_gets(filehandle)
		if atc('[devices]', tmps)>0
			dfound = .t.
		endif
	enddo
endif
if  .not. dfound
	if 'WINDOWS'$upper(dimaqi())
		* Muestra la advertencia unicamente si esta en WINDOWS
		* en NT aparentemente no le da bola al WIN.INI
		*=advgrave('No hay Impresoras Instaladas')
	endif
	=f_close(filehandle)
	return
endif
dfound = .t.
do while  .not. f_eof(filehandle) .and. dfound
	tmps = alltrim(f_gets(filehandle))
	if len(tmps)>0
		do resdev
	else
		dfound = .f.
	endif
enddo
if pinst>0
	dimension windev  [PINST]
	dimension printers[PINST]
endif
=f_close(filehandle)
return ''
* -------------------------------------
procedure resdev
* -------------------------------------
* Usada por GetPrinters
*
private tmp0, ocs, devtype, port, i, devname
ocs = occurs(chr(44), tmps)
devname = left(tmps, at('=', tmps)-1)
tmp0 = left(tmps, at(chr(44), tmps)-1)
devtype = stuff(tmp0, at('=', tmp0), 1, chr(44))
tmp0 = tmps
for i = 1 to ocs
	pinst = pinst+1
	if pinst>20
		dimension windev  [PINST]
		dimension printers[PINST]
	endif
	tmp0 = substr(tmp0, at(chr(44), tmp0)+1)
	port = iif(i=ocs, tmp0, left(tmp0, at(chr(44), tmp0)-1))
	windev[ PINST] = devtype+','+port
	*PRINTERS[ PINST] = DEVNAME+' en '+PORT
	printers[ PINST] = devname
	*if WINDEV(PINST)=ImpPre
	*   PRINTERS[ PINST] = PRINTERS(PINST)+' (Predeterminada)'
	*endif
endfor
return
* -------------------------------
function tomdev
* -------------------------------
* Retorna DEVICE completo a partir del nombre
*
para nomimp
nomimp=alltrim(nomimp)
priv tind,tret,ti,tnom
do getprinters
texa=set('exact')
set exact on
tind=ascan(printers,nomimp)
set exact &texa
if empty(tind)
	ti=ascan(windev,impact())  && Busco nombre de impresora actual
	if empty(ti)
		tnom=imppre
		tret=imppre
	else
		tnom=printers[Ti]
		tret = impact()
	endif
	if type('printers[1]')='C'	&& en windows NT/XP/2000 o mayor no reconoce impresoras
		= msgbox('No existe impresora "'+nomimp+'"';
			+chr(13)+chr(13);
			+'Se Imprimira por "'+tnom+'"','Advertencia',48)
	endif
else
	tret = windev[Tind]
endif
return tret

*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proce dokl	&& do on key label
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters a_prg

push key clear	&& limpia keys para evitar recursividad

do &a_prg	&& ejecuta el do del on key label

pop key		&& restaura las keys

return


*-f ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
func readdeac
*-f ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters a_pwname, a_barra, a_owname

if parameters()<3
	a_owname=''
endif

if mtype('w_call')='U'
	w_call=.f.
endif

if w_call or a_barra
	if !wontop(a_pwname) and (!wontop('barraabm') or a_barra) ;
		and !wontop(a_owname)
		if wexist(a_pwname) and !wexist('calculator')
			if !empty(a_owname)
				if wexist(a_owname)
					_curobj=2
					keyboard '{backtab}'
					activate window (a_owname)
				endif
			endif
			activate window (a_pwname)
		endif
	endif
endif
return(.f.)


*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
func begintran
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

be_area=alias()
be_reva=.t.

sele f77

if terano('')

	=errornet(058)
	be_reva=.f.

else

	*	wait wind 'lock antes del go ' +sys(2011)+' reg 77 ' + str(recno())

	go nf_reem

	*	wait wind 'lock  despues ' +sys(2011)+' reg 77 ' + str(recno())

	repl d77tran with 'T'
	
	if type('d77date')='D'
		repl d77date with date(), d77time with time()
	endif

	if not eof()	&& reemplaza al skip 0
		go recno()
	endif

	flush

endif

if !empty(be_area)

	sele &be_area

	=rwtran()	&& Lecturas al comenzar la transaccion

endif

return be_reva

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
func endtran
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

en_area=alias()
en_reva=.t.

sele f77

go nf_reem
repl d77tran with ' '

if not eof()	&& reemplaza al skip 0
	go recno()
endif

flush

if !empty(en_area)

	sele &en_area

	=rwtran()	&& Escrituras al terminar la transaccion

endif

return en_reva

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function rwtran		&& Lecturas(Read) o Escrituras(Write) al comenzar o terminar Transaccion
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
** Sintaxis....: nul = RWTran()
**
** Ejemplo.....:
**

private bt_alias, bt_x, vt_vara

bt_alias=alias()

for bt_x=1 to 225

	if .not. empty(alias(bt_x))

		bt_vara=alias(bt_x)

		sele (bt_vara)

		if .not. eof()	&& reemplaza al skip 0

			go recno()

		endif

	endif

next

flush

if .not. empty(bt_alias)

	sele (bt_alias)

endif

return


* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure leerresg  && Leer Datos de un Resguardo
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

push key clear      && Salva estados de teclas
push menu _msysmenu && Salva estado de menu
set skip of menu _msysmenu .t.

if sino(' Confirma Lectura ? ','NO',upper(prompt()))='S'

	wnume=''
	wvolu=''
	wsist=''
	wcoem=''
	wempr=''
	wtipo=''
	wvein=''
	wvees=''
	wveda=''
	wpath=''

	w_dire=''
	l_dr=elijedisp('ORIGEN')

	l_dr=l_dr+w_dire

	* LECTURA DEL NUMERO DE SERIE
	* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

	fileserie=f_open(l_dr+'SERIE.NUM',12)

	if fileserie=-1
		* Hubo problemas en Apertura
		if ferror()=2
			* No existe Serie.Num
			wnume='No es un Resguardo'
		else
			wnume='ERROR en Diskette!'
		endif
	else
		* El Serie.Num se abri๓ Ok.
		=f_seek(fileserie,0)
		werror=ferror()
		if werror=0
			wnume=f_read(fileserie,8)
		endif
		if ferror() <> 0
			wnume='ERROR de Lectura!'
		else
			=f_close(fileserie)
			* LECTURA NUMERO DE DISCO
			* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
			wvolu=''
			wwild=l_dr+'DISCO.???'
			declare wfiles[100]
			wcant=adir(wfiles,wwild)
			if wcant>0
				* Es un Backup del tipo DISCO.999
				* -------------------------------
				declare wfiles[wCant]
				=adir(wfiles,wwild)
				do case
					case wcant=1
						wvolu=right(ltrim(wfiles[1,1]),3)
					case wcant>1
						wvolu='Hay mas de un Identificador!'
				endcase
			else
				* Es un Backup del Sistema Nuevo: SiEmTi.999
				* ------------------------------------------
				wwild=l_dr+'??????.0??'
				wcant=adir(wfiles,wwild)

				do case
					case wcant=0
						wvolu='Inexistente'
					case wcant>1
						wvolu='Hay mas de un Identificador!'
					case wcant=1
						declare wfiles[wCant]
						=adir(wfiles,wwild)
						wsist=left(wfiles[1,1],2)
						wcoem=subs(wfiles[1,1],3,2)
						wtipo=subs(wfiles[1,1],5,2)
						wfiles=trim(wfiles[1,1])
						wvolu=right(alltrim(wfiles[1,1]),3)
						if wvolu='001'
							if mfile(l_dr+'EMPRESAS.DBF')
								use &l_dr.empresas in 0 alias f99
								sele f99
								locate for p0coem=wcoem
								if ! eof('f99')
									wvein=f99->p0vein
									wvees=f99->p0vees
									wveda=f99->p0veda
									wempr=f99->p0empr
									if type('f99->p0path')<>'U'
										wpath=f99->p0path
									endif
								endif
								use
							endif
						endif
				endcase
			endif
		endif
	endif

	do leerresg.spr

endif

wait clear
pop key
pop menu _msysmenu

return

* -----------------------------------------------------------------------------
function recupero
* -----------------------------------------------------------------------------
parameters wdror, wdior, wwild, wdrde, wdide, wsist, wempr, wtiba, wbufflen

* Ejemplo: RECUPERO("a:","","*.*","d:","\xx\00\",'Su',d0CoEm,'Em',8192)

if type('wSist')=='L'
	wsist='  '
endif

if type('wEmpr')=='L'
	wempr='  '
endif

if type('wTiBa')=='L'
	wtiba='  '
endif

if type('wBuffLen')=='L'
	wbufflen=20000
endif

if type('d0pref')=='L'
	d0pref=''
endif

wfunc='R'

declare vect[40]

vect=replicate(chr(254),15)

* wDrOr    Drive Origen
* wDiOr    Path Origen
* wWild    WildCard de Archivos a Copiar
* wDrDe    Drive Destino
* wDiDe    Path Destino
* wBuffLen Longitud del Buffer
* wBackName  Nombre del Backup: Su00Em
* wControlar Determina si hay que controlar Sistema/Empresa/TipoDeBackup

set cons off
set alte to recupero.tra
set alte on
? repl('-',50)
?  ' '+dtoc(date())+' '+time()+' '
?? ' Mem:'+ltrim(str(memory(0)))
? repl('-',50)
? 'Operaci๓n   Handle Error File'
? repl('-',50)
set alte off
set cons on

priv fileserie,wpaor,wpade,wnudi,wtrun,wcant,wbuffstr,wdestino
priv wtrunant,wcopio,wclavestr,wtrunfile,filedisco,wfin,wprimero
priv wdrnu,abortar,interrupt,wbackname,wcontrolar,sinmensaje
fileserie=0
filedisco=0
wdestino=0
wclavestr=spac(8)
wtrunfile=0
wpaor = wdror + wdior
wpade = wdrde + wdide
wfin=0
wcontrolar=.t.

wpartes=0

wbackname= wsist+wempr+wtiba

if empty(wbackname)
	wbackname='DISCO'
endif
wbackname=wbackname+'.'

=fbox('R')
priv wcant
wcopio=.f.
public wfiles[10]
wdrnu= asc(left(upper(wdrde),1)) -64
wnudi='001'
wcant=0
wtrun=' '
wtrunant=' '
interrupt=.f.
sinmensaje=.f.

abortar=.t.
wlogfile=wpade+'Restore.Log'
dele file &wlogfile
wprimero=fnuevo( wlogfile,'DER','SUP')
if wprimero>0
	if fcierra(wprimero,wlogfile,'DER','SUP')
		abortar=.f.
	endif
endif

wfirstdisk=.t.
wparticion=.f.

* CICLO DE COPIA DE VARIOS DISKETTES
* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
wfinrest=.f.
do while !wfinrest .and. !abortar

	@ 17,43 clear to 22,78
	if wfirstdisk
		* PEDIR DISKETTE 1
		* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
		if !restdisk(wdror,'001')
			abortar=.t.
		else
			wfirstdisk=.f.
		endif
	endif

	w_curr=sys(5)
	w_chan=chr(wdrnu+64)+':'
	set defa to &w_chan

	@ 09,72 say str( diskspace()/1024,5)+'K'

	set defa to &w_curr

	* COPIA DE LOS ARCHIVOS DE UN DISKETTE
	* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	for i=1 to wcant
		wfilecomp=alltrim(wfiles[i,1])

		if !wfilecomp==upper(wbackname)+wnudi;
				.and. ! '.NUM' $ wfilecomp;
				.and. ! '.LOG' $ wfilecomp;
				.and. !wfilecomp==wtrun;
				.and. !wfilecomp==wtrunant

			wfileorig=wpaor+alltrim(wfiles[i,1])
			wfiledest=wpade+alltrim(wfiles[i,1])
			=recucopy(.t.)
		endif
	next

	* COPIA DE LA 1ra 2da Nma PARTICION DE UN FILE TRUNCADO
	* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	abortar=.f.
	do case
		case wnudi = '001' .and. !empty(wtrun) .and. left(wtrun,5)<>'Sigue'
			* Primer Diskette con la Pra Partici๓n de un File Truncado
			* corresponde copiarlo con COPY.
			wfileorig=wpaor+wtrun
			wfiledest=wpade+wtrun
			=recucopy(.t.)
		case wnudi > '001' .and. !empty(wtrun) .and. left(wtrun,5)<>'Sigue';
				.and. left(wtrunant,5)='Sigue'
			* Ensimo Diskette con la Pra Partici๓n de un File Truncado
			* corresponde copiarlo con COPY.
			wfileorig=wpaor+wtrun
			wfiledest=wpade+wtrun
			=recucopy(.t.)

		case wnudi > '001'  .and. left(wtrunant,5)='Sigue'
			* Diskettes siguientes, pero no tienen como anterior un diskette
			* con File Truncado: No hay que hacer nada.

		case wnudi > '001'
			* Se asume que aquก entran los que tienen como anterior un diskette
			* con File Truncado.
			wfin=fabre( wpade+wtrunant ,'DER','INF')
			if wfin=-1
				abortar=.t.
			else
				if ! fposic(wfin,0,2,wpade+wtrunant)
					abortar=.t.
				else
					wtrunfile=fabre( wpaor+wtrunant,'IZQ','INF')
					if wtrunfile=-1
						abortar=.t.
					else
						if ! fposic(wtrunfile,0,0,wpaor+wtrunant)
							abortar=.t.
						else
							* COPIA EN PEDAZOS
							* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
							wend=0
							wbuffstr=space(wbufflen)
							wfinpartes=.f.
							do while !wfinpartes .and. !abortar and !f_eof(wTrunFile)
								*        wend=f_read(wTrunFile,@wBuffStr,wBuffLen)
								wbuffstr=f_read(wtrunfile,wbufflen)
								wend=len(wbuffstr)
								do case
									case ferror() <> 0
										=fmensa('ERROR en Lectura de','Archivo Origen!','',wtrunfile)
										abortar=.t.
									case ! fgraba(wfin,wbuffstr,wend,wpade+wtrunant)
										abortar=.t.
									otherwise
										wcopio=.t.
										do case
											case wend < wbufflen
												wfinpartes=.t.
											case ! fposic(wtrunfile,0,1,wpaor+wtrunant)
												abortar=.t.
											case ! fposic(wfin,0,2,wpade+wtrunant)
												abortar=.t.
										endcase
								endcase
							enddo
							do case
								case abortar
								case ! fcierra(wtrunfile,wpaor+wtrunant,'IZQ','INF')
									abortar=.t.
								case ! fcierra(wfin,wpade+wtrunant,'DER','INF')
									abortar=.t.
								case !wtrun==wtrunant;
										.and. !empty(wtrun);
										.and. left(wtrun,5)<>'Sigue'
									wfileorig=wpaor+wtrun
									wfiledest=wpade+wtrun
									=recucopy(.t.)
							endcase

						endif
					endif
				endif
			endif
	endcase
	if !abortar

		wtrunant = alltrim(wtrun)
		if empty(wtrun)
			wfinrest=.t.
		else
			wnudi = subs(str(1001+val(wnudi),4),2,3)
			if !restdisk(wdror,wnudi)
				abortar=.t.
			else
				=recucopy(.f.)
			endif
		endif
	endif
enddo

for i=wprimero to 39  && 19
	=fcierra(i,'','','')
next

priv wloghand,wstringlog,wlogfile
wlogfile=wpade+'Restore.Log'
dele file &wlogfile
wloghand=fnuevo( wlogfile  ,'IZQ','SUP')
if wloghand>0
	wstringlog=dtoc(date())+' '+time()+' '+wclavestr
	=f_write(wloghand,wstringlog,26)
	if ferror()=0
		=fcierra(wloghand,wlogfile,'IZQ','SUP')
	endif
endif

priv wretu
do case
	case interrupt
		if ! sinmensaje
			=fmensa('','','',0,0)
		endif
		wretu=.f.
	case ! wcopio .or. abortar
		if ! sinmensaje
			=fmensa('RECUPERO DE ARCHIVOS','FINALIZO ANORMALMENTE!','',0,0)
		endif
		wretu=.f.
	otherwise
		*      fTone(0)
		@ 17,43 clear to 22,78
		*      setcolor(hi)
		@ 18,44 say 'Recupero Finaliz๓ Normalmente.'
		*      setcolor(bh)
		@ 21,44 say 'Digite una Tecla para Continuar'
		*      setcolor(lo)
		=inkey(0)
		@ 21,44 say space(31)
		wretu=.t.
endcase
close alte
set cons on
release window box
return wretu

*-----------------------------------------------------------------------------
function restdisk
*-----------------------------------------------------------------------------
para wdrive,wdisk
priv wdiok,wkeyb
wdiok=.f.
wkeyb=0

do while !wdiok .and. !interrupt
	@ 17,43 clear to 22,78
	@ 17,44 say 'Inserte el Diskette Nro. '+wdisk
	@ 18,44 say 'en el Drive '+ wdrive +' y digite:'

	wkeyb=enteresc()
	if wkeyb=13
		@ 21,50 say 'Controlando Diskette.'

		if mfile(wdrive+'\nul')

			* RECUPERO: ACEPTO SOLO DISKETTES DE ESTE RESGUARDO
			* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
			fileserie=fabre( wpaor+'SERIE.NUM','IZQ','SUP')
			if fileserie=-1
				* Hubo problemas en Apertura
				if ferror()=2
					* No existe Serie.Num
					=fmensa('No encontr Archivo '+wpaor+'SERIE.NUM','Este Diskette NO PERTENECE','a un Resguardo.',fileserie)
				else
					=fmensa('ERROR en Diskette!')
				endif
			else
				* El Serie.Num se abri๓ Ok.

				wclaveexi=f_read(fileserie,8)
				if ferror() <> 0
					=fmensa('ERROR en Diskette!')
				else
					if wnudi='001'
						wclavestr=wclaveexi
						wdiok=.t.
					else
						if !wclaveexi==wclavestr
							=fmensa('Diskette perteneciente','a otro Resguardo!')
						else
							wdiok=.t.
						endif
					endif
				endif
				=fcierra(fileserie,wpaor+'SERIE.NUM','IZQ','SUP')
			endif

			if wdiok
				* RECUPERO: VALIDACION NUMERO DE DISCO
				* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
				wtrun=space(12)

				if !wcontrolar
					* El primer diskette era del tipo disco.999
					wdiok=.t.
				else
					* Es un Restore del Sistema Nuevo: SiEmTi.999
					wdiok=.f.
					priv xcant,xwild
					xwild=wpaor+wsist+'????.0??'
					declare xfiles[50]
					xcant=adir(xfiles,xwild)
					*               declare xFiles[xCant]
					*               adir(xWild,xFiles)

					do case
						case xcant=0
							declare w_temp[50]
							xwild=wpaor+'DISCO.???'
							xcant=adir(w_temp,xwild)
							do case
								case xcant>0 .and. wnudi='001'
									wbackname='DISCO.'
									wdiok=.t.
									wcontrolar=.f.
								case xcant>0
									wdiok=.t.
								otherwise
									xwild=wpaor+'??????.0??'
									*                           xCant=adir(xWild)
									release xfiles
									declare xfiles[50]
									xcant=adir(xfiles,xwild)
									if xcant=0
										=fmensa('ERROR: En este diskette No existe','archivo de Identificaci๓n','de Volumen!')
									else
										wmens1='ERROR: Diskette pertenece'
										wmens2='a un Resguardo del'
										wmens3='Sistema '+left(xfiles[1,1],2)+'!'
										=fmensa(wmens1,wmens2,wmens3)
									endif
							endcase
						case xcant>1
							=fmensa('ERROR: En este diskette HAY MAS','DE UN ARCHIVO DE','Identificaci๓n de Volumen!')
						case subs(xfiles[1,1],3,2) <> wempr
							=fmensa('ERROR: Diskette pertenece','a un Resguardo de la','Empresa '+subs(xfiles[1],3,2)+'!' )
						case subs(xfiles[1,1],5,2) <> upper(wtiba)
							=fmensa('ERROR: Diskette es de otro','Tipo de Resguardo!')
						otherwise
							wdiok=.t.
					endcase
					release xcant,xfiles,xwild,w_temp
				endif

				if wdiok
					* CONTROL SECUENCIA
					* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
					wdiok=.f.

					priv xcant,xwild,xnudi
					xwild=wpaor+wbackname+'???'
					*xCant=adir(xWild)
					declare xfiles[50]
					xcant=adir(xfiles,xwild)
					if xcant=1
						xfiles[1,1]=trim(xfiles[1,1])
						xnudi=right(xfiles[1,1],3)
					endif
					do case
						case xcant=0
							=fmensa('ERROR: En este diskette No existe','archivo de Identificaci๓n','de Volumen!')
						case xcant>1
							=fmensa('ERROR: En este diskette','HAY MAS DE UN ARCHIVO DE','Identificaci๓n de Volumen!')
						case xnudi <> wnudi
							=fmensa('ERROR: Disco '+xnudi+' Fuera','de Secuencia!')
						otherwise
							* BackDisk.NNN Existe.
							filedisco=fabre( wpaor+wbackname+wnudi ,'IZQ','SUP')
							if filedisco<>-1

								wtrun=f_read(filedisco,12)
								if ferror()=0

									* Cargo en wTrun el contenido de BackDisk.NNN
									* que puede estar vacกo, tener un ARCHIVO PARTIDO
									* o 'Sigue en 999'

									* Cargo Array con nombres de archivos
									if fcierra(filedisco,wpaor+wbackname+wnudi,'IZQ','SUP')

										* CONTROL DIRECTORIO DE RECUPERO EN DISK 001
										* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
										wdiok=.t.
										if wcontrolar;
												.and. wnudi='001';
												.and. upper(wsist)$'CG.IW.SJ.ST.GA'
											if mfile(wdror+'Empresas.dbf')
												sele 0
												use &wdror.empresas
												locate for p0coem=wempr
												if ! eof()
													wpath=''
													if upper(wsist)$'CG.IW.SJ.ST.GA'
														if wdide='\ST\CLIENTES\'
															wpath='\ST\CLIENTES\'
														else
															wpath=p0path
														endif
														wpunt=at(':',wpath)
														if wpunt<>0
															wpath = subs(wpath,wpunt + 1,100)
														endif
														wpath=trim(wpath)
														if ! upper(wpath)==upper(wdide)
															*-----------------------------------------
															*Se deja Recuperar la Empresa aunque venga
															*de distinto directorio.
															*-----------------------------------------
															=fmensa('Esta Empresa fue creada en','Directorio '+wdide+'!')
															=fmensa('Datos en Diskette pertenecen a','Directorio: '+wpath+'!')
															*   SinMensaje=.t.
															*   wDiOk=.f.
															*   wAbortar=.t.
															*   Interrupt=.t.
														endif
													endif
													if wdiok
														@ 17,01 say 'Sistema: '+wsist
														@ 18,01 say 'Empresa: '+p0coem+' '+left(p0empr,29)
														@ 19,01 say 'Tipo   : '+wtiba
														@ 20,01 say 'Versi๓n: '+p0vein+' '+p0vees+' '+p0veda
														@ 21,01 say 'Path   : '+wpath
														@ 22,01 say 'N๚mero : '+wclavestr
													endif
												endif
												use
											endif
										endif
										if wdiok
											* LECTURA DE DIRECTORIO EN DISKETTE
											* ---------------------------------
											wtrun=alltrim(wtrun)
											wtrunant=alltrim(wtrunant)

											public wfiles[50]
											wcant=adir(wfiles,wpaor+wwild)
											*release wFiles
											*public wFiles[wCant]
											*adir(wPaOr+wWild,wFiles)
											i=1
											do while i<=wcant
												if '.LOG'$wfiles[i,1] .or. '.NUM'$wfiles[i,1] .or. upper(wbackname)$wfiles[i,1]
													=adel(wfiles,i)
													wcant=wcant-1
												else
													i=i+1
												endif
											enddo
										endif
									endif
								endif
							endif
							if !wdiok .and. !sinmensaje
								=fmensa('ERROR en Lectura de','Archivo '+wbackname+wnudi+'!')
							endif
					endcase
				endif
			endif

		else
			*         fTone(1)
			@ 17,43 clear to 22,78
			*         setcolor(hi)
			@ 17,44 say 'ERROR: Diskettera abierta'
			@ 18,44 say '     ๓ Diskette Da๑ado!'
			*         setcolor(lo)
			wkeyb=enteresc()
		endif
	endif
	if wkeyb=27
		interrupt=.t.
		if wnudi='001'
			sinmensaje=.t.
			abortar=.t.
		endif
	endif
enddo
return wdiok


*-F -----------------------------------------------------------------------------
function backup
*-F -----------------------------------------------------------------------------
parameters wdror, wdior, wwild, wwil2, wdrde, wdide, wsist, wempr, wtiba, wbufflen

** Si wWil2 viene vacio no se toma **

* Ejemplo: BACKUP('c:','\xx\00\','*.dbf','*.fpt','a:','','Su',d0CoEm,'Em',8192)

if type('wSist')=='L'
	wsist='  '
endif

if type('wEmpr')=='L'
	wempr='  '
endif

if type('wTiBa')=='L'
	wtiba='  '
endif

if type('wBuffLen')=='L'
	wbufflen=20000
endif


wfunc='B'
wpasemp=.f.             &&     Nueva
wpassem=.t.             &&     Semaforo

**********************************************

if at(',',wwild)>0
	wpwild=wwild
	wwild=subst(wwild,1,at(',',wwild)-1)
	if 'E'$upper(subst(wpwild,at(',',wpwild)+1,2))
		wpasemp=.t.
	endif
	if 'N'$upper(subst(wpwild,at(',',wpwild)+1,2))
		wpassem=.f.
	endif
endif

**********************************************

declare vect[40]
vect=replicate(chr(254),15)

* wDrOr    Drive Origen
* wDiOr    Path Origen
* wWild    WildCard de Archivos a Copiar
* wDrDe    Drive Destino
* wDiDe    Path Destino
* wBuffLen Longitud del Buffer

* wGrPrBl    Ya se realiz๓ la grabaci๓n del Primer Bloque en File Destino.
* wBackName  Nombre del Backup: Su00Em

set cons off

set alte to resguard.tra

* CREACION CLAVE
* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿
priv wclavenum,wclavestr,wpaor,wpade,wdrnu,wnudi,fileserie,filedisco
priv wspaces,wleidos,wbuffstr,wcreado,wgrprbl
priv worigen,wdestino,abortar,wprimero,interrupt,wbackname,sinmensaje

worigen=0
fileserie=0
filedisco=0
wdestino=0
abortar=.f.
interrupt=.f.
sinmensaje=.f.
wgrprbl=.f.

wbackname= wsist+wempr+wtiba
if empty(wbackname)
	wbackname='DISCO'
endif
wbackname=wbackname+'.'

wclavenum= month(date()) * day(date())
wclavenum= wclavenum * val(left(time(),2)) * val(subs(time(),4,2))
wclavenum= wclavenum * val(right(time(),2)) + 10^8
wclavestr= str(wclavenum,9)
wclavestr= right(wclavestr,8)

set cons off
set alte on
? repl('-',50)
?  ' '+dtoc(date())+' '+time()
?? ' Mem:'+ltrim(str(memory(0)))+' Serie:'+wclavestr
? repl('-',50)
? 'Operaci๓n   Handle Error File'
? repl('-',50)
set alte off
set cons on

wpade=wdrde+wdide       && drive destino + directorio destino
wpaor=wdror+wdior       && drive origen  + directorio origen

wdrnu= asc(left(upper(wdrde),1)) -64

wnudi='001'
wleidos=0
wspaces=space(12)
wpartes=0

=fbox('B')

* CARGAR NOMBRES DE ARCHIVOS DE PATH ORIGEN
* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
logfile=wpaor+'Backup.Log'
if mfile(logfile)
	dele file &logfile
endif

if .not. empty(wwil2)
	declare w_aux1[1],w_aux2[1]

	w_can1=adir(w_aux1,wpaor+wwild)
	w_can2=adir(w_aux2,wpaor+wwil2)

	if wpasemp
		declare wfiles[w_Can1+w_Can2+1,5]
	else
		declare wfiles[w_Can1+w_Can2,5]
	endif

	for w_cont=1 to w_can1
		wfiles[w_cont,1]=w_aux1[w_cont,1]
		wfiles[w_cont,2]=w_aux1[w_cont,2]
		wfiles[w_cont,3]=w_aux1[w_cont,3]
		wfiles[w_cont,4]=w_aux1[w_cont,4]
		wfiles[w_cont,5]=w_aux1[w_cont,5]
	next

	for w_cont=1 to w_can2
		wfiles[w_Can1+w_cont,1]=w_aux2[w_cont,1]
		wfiles[w_Can1+w_cont,2]=w_aux2[w_cont,2]
		wfiles[w_Can1+w_cont,3]=w_aux2[w_cont,3]
		wfiles[w_Can1+w_cont,4]=w_aux2[w_cont,4]
		wfiles[w_Can1+w_cont,5]=w_aux2[w_cont,5]
	next

	if wpasemp
		wfiles[w_Can1+w_Can2+1,1]='EMPRESAS.DBF'
		wcant=w_can1+w_can2+1
	else
		wcant=w_can1+w_can2
	endif

else
	declare wfiles[1]
	*wCant=adir(wPaOr+wWild)
	wcant=adir(wfiles,wpaor+wwild)

	if wpasemp
		declare w_auxi[wCant+1,5]
		=acopy(wfiles,w_auxi)
		w_auxi[wCant+1,1]='EMPRESAS.DBF'

		release wfiles
		declare wfiles[wCant+1,5]
		=acopy(w_auxi,wfiles)

		wcant=wcant+1

	endif
endif


if wcant > 0

	if !wpassem                               && *-------------------
		elem=0                                 &&
		** Utilizo esta rutina para eliminar el archivo **
		** XXF077.DBF usado como semaforo en los siste- **
		** mas de red                                   **
		for elem=1 to wcant
			if 'F077.DBF'$wfiles[Elem,1]
				=adel(wfiles,elem)
				wfiles[wCant,1]=''
				wcant=wcant-1
				elem =wcant+1
			endif
		next
	endif

	** Elimino archivo foxuser **
	** y EMPRESAS levantado por adir
	for elem=1 to wcant
		if 'FOXUSER'  $ wfiles[Elem,1] .or.;
				('EMPRESAS' $ wfiles[Elem,1] .and. !empty(wfiles[Elem,2]) )
			=adel(wfiles,elem)
			wfiles[alen(wFiles)/5,1]=''
			wcant=wcant-1
		endif
	next

	=asort(wfiles)
	elem=0
	do while elem<wcant
		elem=elem+1
		if 'EMPRESAS'$wfiles[Elem,1]
			* Enroque de Archivos: El File Empresas.Dbf a Primera Posici๓n.
			welem1=wfiles[1,1]
			wfiles[1,1]=wfiles[Elem,1]
			wfiles[Elem,1]=welem1
			exit
		endif
	enddo
else
	=fmensa('No se encontraron','Archivos para copiar!')
	abortar=.t.
endif

if ! abortar
	i=1
	do while i<=wcant
		if '.LOG'$wfiles[i,1] .or. '.NUM'$wfiles[i,1] .or. upper(wbackname)$wfiles[i,1]
			=adel(wfiles,i)
			wcant=wcant-1
		else
			i=i+1
		endif
	enddo
endif

abortar=.t.
wlogfile=wpaor+'Backup.Log'
dele file &wlogfile
wprimero=fnuevo(wlogfile ,'IZQ','SUP')
if wprimero>0
	if fcierra(wprimero,wlogfile,'IZQ','SUP')
		abortar=.f.
	endif
endif

wfirstdisk=.t.
wparticion=.f.

* CICLO DE LECTURA Y GRABACION DE ARCHIVOS
* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
wj=1
do while  wj <= wcant .and. !abortar
	@ 17,43 clear to 22,78

	if wfirstdisk
		* PEDIR DISKETTE 1
		* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
		if !backdisk(wdrde,wnudi)
			abortar=.t.
		else
			wcreado=.f.
			wbuffstr=space(wbufflen)
			worigen=fabre( wpaor+wfiles[wj,1] ,'IZQ','INF')
			if worigen=-1
				abortar=.t.
			else
				wfirstdisk=.f.
				wgrprbl=.f.
			endif
		endif
	endif

	wparticion=.f.
	if ! abortar
		w_curr=sys(5)
		w_chan=chr(wdrnu+64)+':'
		set defa to &w_chan

		@ 09,72 say str( diskspace()/1024,5)+'K'
		w_auxi= diskspace()- wbufflen+1024 && - 40000

		set defa to &w_curr

		if w_auxi <= wbufflen

			* CAMBIO DE DISKETTE
			* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
			if wleidos = wbufflen
				* Acaba de Grabar un Bloque del tamaคo del Buffer: Archivo Partido
				* GRABACION NOMBRE ARCHIVO EN DISCO.nnn
				* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
				abortar=.t.
				filedisco=fabre( wpade+wbackname+wnudi , 'DER','SUP')
				if filedisco<>-1
					wtam=12-len(wfiles[wj,1])
					wfiles[wj,1]=wfiles[wj,1] + space(wtam)
					if fgraba(filedisco,wfiles[wj,1],12,wbackname+wnudi)
						if fcierra(filedisco,wbackname+wnudi,'DER','SUP')
							abortar=.f.
							wparticion=.t.
						endif
					endif
				endif
			else

				* GRABACION DE XXXXXXXXXXXX EN DISCO.nnn
				* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
				abortar=.t.
				filedisco=fabre( wpade+wbackname+wnudi , 'DER','SUP')
				if filedisco<>-1
					wtam=12-len(wfiles[wj,1])
					wfiles[wj,1]=wfiles[wj,1] + space(wtam)
					if fgraba(filedisco,'Sigue en '+subs(str(1001+val(wnudi),4),2,3),12,wbackname+wnudi)
						if fcierra(filedisco,wbackname+wnudi,'DER','SUP')
							abortar=.f.
							wparticion=.t.
						endif
					endif
				endif
			endif
			if ! abortar
				* ACA INTENTA CERRAR EL ULTIMO: PERO NO FUE CREADO EN DISKETTE

				if wcreado
					if ! fcierra(wdestino,wpade+wfiles[wj,1],'DER','INF')
						abortar=.t.
					endif
				endif
				if ! abortar
					wcreado=.f.

					* PEDIR SIGUIENTE DISKETTE
					* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

					wnudi = subs(str(1001+val(wnudi),4),2,3)
					if !backdisk(wdrde,wnudi)
						abortar=.t.
					endif
				endif
			endif
		endif
	endif

	* CREACION DEL ARCHIVO DESTINO SI AUN NO FUE CREADO
	* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	if !abortar
		if !wcreado

			if wparticion .and. wgrprbl
				*scroll(05,01,09,78,1)
				scroll 05,01,09,77,1
				wpartes=wpartes+1
			else
				wpartes=0
			endif
			wdestino=fnuevo( wpade+wfiles[wj,1]  ,'DER','INF')   && Û Û Û Û ฒ ฑ ฐ
			if wdestino>0
				wcreado=.t.
			else
				wabortar=.t.
			endif
		endif
	endif

	if !abortar
		* CARGA DEL BUFFER
		* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

		*wLeidos=f_read(worigen,@wBuffStr,wBuffLen)

		wbuffstr=f_read(worigen,wbufflen)
		wleidos=len(wbuffstr)

		if ferror() <> 0
			=fmensa('ERROR en Lectura de','Archivo Origen','en Diskette.',worigen)
			abortar=.t.
		else
			* GRABACION DEL BUFFER
			* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
			if ! fgraba(wdestino,wbuffstr,wleidos,wpade+wfiles[wj,1])
				abortar=.t.
			else
				wgrprbl=.t.
				if ! fposic(worigen,0,1,'Origen')
					abortar=.t.
				else
					if wleidos = wbufflen and !f_eof(worigen)
						* Grab๓ un Bloque: pero hay mแs.
						* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
					else
						* Termin๓ un Archivo: CERRAR ARCHIVOS
						* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
						abortar=.t.
						wleidos=0
						wj= wj +1   && Paso a Siguiente Archivo
						if fcierra(wdestino,wpade+wfiles[wj-1,1],'DER','INF')
							if fcierra(worigen,wpaor+wfiles[wj-1,1],'IZQ','INF')
								* ABRIR SIGUIENTE ARCHIVO
								* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
								if wj>wcant
									abortar=.f.
									wcreado=.f.
								else
									worigen=fabre( wpaor+wfiles[wj,1] , 'IZQ','INF')
									if worigen<>-1
										abortar=.f.
										wcreado=.f.
										wgrprbl=.f.
									endif
								endif
							endif
						endif
					endif
				endif
			endif
		endif
	endif
enddo

priv wloghand,wstringlog,wlogfile
wlogfile=wpaor+'Backup.Log'
dele file &wlogfile
wloghand=fnuevo( wlogfile  ,'IZQ','SUP')

if wloghand>0
	wstringlog=dtoc(date())+' '+time()+' '+wclavestr
	=f_write(wloghand,wstringlog,26)
	if ferror()=0
		=fcierra(wloghand,wlogfile,'IZQ','SUP')
	endif
endif

for i=wprimero to 39   && 19
	=fcierra(i,'','','')
next
priv wretu

do case
	case interrupt
		if ! sinmensaje
			=fmensa()
		endif
		wretu=.f.
	case abortar
		if ! sinmensaje
			=fmensa('RESGUARDO FINALIZO','ANORMALMENTE!','',0,0)
		endif
		wretu=.f.
	otherwise

		@ 17,43 clear to 22,78
		@ 18,44 say 'Resguardo Ocup๓ '+ ltrim(str(val(wnudi),3)) +' Diskettes.'
		@ 21,44 say 'Digite una Tecla para Continuar'

		=inkey(0)
		wretu=.t.
endcase

close alte
set cons on
release window box

return wretu

* -----------------------------------------------------------------------------
function backdisk
* -----------------------------------------------------------------------------

parameters wdrive,wdisk
priv wdiok,wkeyb
wdiok=.f.
wkeyb=0

do while !wdiok .and. !interrupt

	@ 17,43 clear to 22,78

	@ 18,44 say 'Inserte el Diskette Nro. '+wdisk
	@ 19,44 say 'en el Drive '+ wdrive +' y digite:'
	wkeyb=enteresc()
	if wkeyb=13
		@ 21,50 say 'Controlando Diskette.'
		if mfile(wdrive+'\nul')

			if wdisk='001'
				wdiok=.t.
			else
				* BACKUP: CONTROLO QUE NO USEN DISKETTES DE ESTE RESGUARDO
				* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
				fileserie=fabre( wpade+'SERIE.NUM' , 'DER','SUP',.f.)
				if fileserie=-1
					* Hubo problemas en Apertura
					if ferror()=2
						* No existe Serie.Num
						wdiok=.t.
					else
						=fmensa('ERROR en Diskette!','','',fileserie)
					endif
				else
					* El Serie.Num se abri๓ Ok.
					wclaveexi=f_read(fileserie,8)
					if ferror() <> 0
						=fmensa('ERROR en Diskette!','','',fileserie)
					else
						if wclaveexi=wclavestr
							=fmensa('Diskette perteneciente','al Resguardo en curso.')
						else
							wdiok=.t.
						endif
					endif
					=fcierra(fileserie,wpade+'SERIE.NUM','DER','SUP')

				endif
			endif

			if wdiok
				* BORRAR DISKETTE
				* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
				wdiok=deledisk()

				* CHEQUEAR ESPACIO EN DISKEETE
				* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

				w_curr=sys(5)
				w_chan=chr(wdrnu+64)+':'
				set defa to &w_chan

				w_auxi= diskspace()

				set defa to &w_curr

				if wdiok .and. w_auxi < 50000 && 100000
					=fmensa('No hay suficiente','espacio disponible en','Drive Destino!')
					wdiok=.f.
				endif
			endif

			if wdiok
				@ 21,43 clear to 22,78
				@ 21,47 say 'Creando Archivos de Control'

				* CREACION FILE Serie.Num
				* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
				wdiok=.f.
				fileserie=fnuevo( wpade+'SERIE.NUM'  ,'DER','SUP')
				if fileserie>0
					if fgraba(fileserie,wclavestr,8,wpade+'SERIE.NUM')
						if fcierra(fileserie,wpade+'SERIE.NUM','DER','SUP')
							wdiok=.t.
						endif
					endif
				endif
			endif

			if wdiok
				* CREACION FILE Disco.nnn
				* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
				wdiok=.f.
				filedisco=fnuevo( wpade+wbackname+wnudi  ,'DER','SUP')
				if filedisco>0
					if fgraba(filedisco,wspaces,12,wpade+wbackname+wnudi)
						if fcierra(filedisco,wpade+wbackname+wnudi,'DER','SUP')
							wdiok=.t.
						endif
					endif
				endif
				if !wdiok
					=fmensa('ERROR en Creaci๓n de','Archivo '+wbackname+wnudi,'en Diskette.',filedisco)
				endif
			endif

		else

			@ 17,43 clear to 22,78
			@ 17,44 say 'ERROR: Diskettera abierta'
			@ 18,44 say '     ๓ Diskette Sin Formattear'
			@ 19,44 say '     ๓ Diskette Da๑ado!'
			wkeyb=enteresc()
		endif
	endif
	if wkeyb=27
		interrupt=.t.
		if wnudi='001'
			sinmensaje=.t.
			abortar=.t.
		endif
	endif
enddo

return wdiok


* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function defined
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para wexpr
return !'U'$type('&wExpr')

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function deledisk
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

wait 'Borrando Diskette.' wind nowait

priv wcant,wronly,i,wfiledele
wcant=1
declare wnames[wCant]  &&,wSizes[wCant],wDates[wCant],wTimes[wCant],wAttrs[wCant]
*wCant=adir(wPaDe+'*.*',wNames,wSizes,wDates,wTimes,wAttrs)
wcant=adir(wnames,wpade+'*.*')
*adir(wPaDe+'*.*',wNames,wSizes,wDates,wTimes,wAttrs)
wronly=.f.
for i = 1 to wcant
	if 'R'$wnames[i,5]
		wronly=.t.
	else
		wfiledele=wpade+wnames[i,1]
		erase &wfiledele
	endif
next
wait clear
if wronly
	=fmensa('Debe Formattear','este diskette!')
	return .f.
else
	return .t.
endif

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function fposic
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

para whandle,wposi,wmode,wname
w_para=parameters()
=f_seek(whandle,wposi,wmode)

if ferror() = 0
	=xtrace(whandle,iif(w_para>3,wname,''),'SEEKEADO')
	return .t.
else
	if w_para>3
		=fmensa('ERROR en Posicionamiento de','Archivo '+wname+'!','',whandle)
	endif
	return .f.
endif

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function fgraba
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para whandle,wstring,wlen,wname
w_para=parameters()

=f_write(whandle,wstring,wlen)
if ferror()=0
	=xtrace(whandle,iif(w_para>3,wname,''),'GRABADO ')
	return .t.
else
	if w_para>3
		=fmensa('ERROR en Grabaci๓n de','Archivo '+wname+'!','',whandle)
	endif
	return .f.
endif

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function recucopy
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para wcopy
@ 17,43 clear to 22,78
@ 17,44 say 'Diskette Nro.: '+wnudi
@ 18,44 say 'Orig: '+wfileorig
@ 19,44 say 'Dest: '+wfiledest
@ 21,55 say 'Recuperando'

if wcopy
	wcopio=.t.
	copy file &wfileorig to &wfiledest
endif
return ''

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function fmensa
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para wmen1,wmen2,wmen3,whandle,wtone

w_para=parameters()

if w_para<5
	wtone=1
endif
priv werror

if w_para<3
	wmen3=''
endif

if w_para<2
	wmen2=''
endif

if w_para<1
	wmen1=''
endif

@ 17,43 clear to 22,78
werror=ferror()

if interrupt
	if wfunc='B'
		wmen1='Resguardo'
	else
		wmen1='Recupero'
	endif
	wmen1=wmen1+' fue Interrumpido'
	wmen2='por el Usuario.'
	@ 17,44 say wmen1
	@ 18,44 say wmen2
	@ 19,44 say wmen3
	@ 21,44 say 'Digite ESCAPE para volver al Men๚'
	wtone=0
else
	@ 17,44 say wmen1
	@ 18,44 say wmen2
	@ 19,44 say wmen3
	wmensaje='[E'+ltrim(str(werror,5))+' M'+ltrim(str(memory(0),5))
	if w_para=4
		wmensaje=wmensaje+' H'+ltrim(str(whandle,3))
	endif
	@ 20,60 say wmensaje+']'
	@ 21,44 say 'Digite una Tecla para Continuar'
endif

if werror>0
	* GRABACION ARCHIVO ERROR
	* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	set cons off
	set alte on

	?  space(2)+'ERROR '
	?? wmen1
	?  space(8)
	?? wmen2
	?  space(8)
	?? wmen3
	? space(2)+'Error '+ltrim(str(werror,5))+'.  Mem:'+ltrim(str(memory(0)))
	priv i,wbuff
	for i=iif(wprimero>0,wprimero,6) to alen(vect)
		wbuff=space(10)
		=f_seek(i,0)
		?  str(i,2)
		?? space(2)+str(f_seek(i,0),3)
		?? space(2)+str(ferror(),2)
		wbuff=f_read(i,10)
		?? space(2)+str(len(wbuff),3)
		?? space(2)+str(ferror(),2)
		?? space(2)+wbuff
		?? space(2)+vect[i]
	next
	set alte off
	set cons on
endif

=inkey(0)
@ 17,43 clear to 22,78
return ''

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function xtrace
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para whandle,wname,woper

set cons off
set alte on

? 'Fue '+woper
?? str(whandle,6)
?? str(ferror(),6)
?? ' '+wname
set alte off
set cons on
return ''

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function fnuevo
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters wfile,wbloque,wzona
priv werror,whandle
werror=0
whandle=f_create(wfile,0)

if whandle = -1
	werror=ferror()
else
	=f_close(whandle)

	whandle=f_open(wfile,12)

	vect[wHandle]=wfile
	=xtrace(whandle,wfile,'CREADO  ')
	=f_seek(whandle,0)
	werror=ferror()
endif
if wbloque='IZQ'
	wcol=04
else
	wcol=37
endif

if wzona='INF'
	if wfunc='B' .and. wbloque='IZQ'
		*scroll(05,01,09,78,1)
		scroll 05,01,09,77,1
	endif
	if wfunc='R' .and. wbloque='DER'
		*scroll(05,01,09,78,1)
		scroll 05,01,09,77,1
	endif

	@ 09,01 say wnudi
	wrow=9
else
	wrow=3
endif
@ wrow,wcol say str(whandle,2)
@ wrow,wcol+8 say wfile
if whandle=-1 .or. !werror=0
	=fmensa('ERROR en Creaci๓n de','Archivo '+wfile,'',whandle)
	@ wrow,wcol+3 say 'ERR '
else
	@ wrow,wcol+3 say 'Nuev'
endif
return whandle

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function fcierra
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para whandle,wname,wbloque,wzona

w_para=parameters()

priv wcerro
wcerro=.f.
=f_seek(whandle,0)
if ferror()<>6
	=f_close(whandle)
	if ferror()=0
		vect[wHandle]=''
		=xtrace(whandle,wname,'CERRADO ')
		wcerro=.t.
		if !empty(wbloque)
			priv wcol,wrow
			do case
				case wbloque='IZQ'
					wcol=04
				case wbloque='DER'
					wcol=37
			endcase
			do case
				case wzona='INF' .and. wpartes<5 .and. wbloque='IZQ'
					@ 09-wpartes,wcol+3 say 'Cerr'
				case wzona='INF' .and. wbloque='DER'
					@ 09,wcol+3 say 'Cerr'
				case wzona='SUP'
					@ 03,wcol+3 say 'Cerr'
			endcase
		endif
	else
		if w_para > 1
			=fmensa('ERROR en Cierre de','Archivo '+wname+'!','',whandle)
		endif
	endif
else
	if ! empty(wbloque)
		=fmensa('ERROR en Cierre de','Archivo '+wname+'!','',whandle)
	endif
endif
return wcerro

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function fabre
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters wfilename,wbloque,wzona,wdisperr

w_para=parameters()
if w_para<4
	wdisperr=.t.
endif
priv werror,wrow,wcol,whandle
werror=0

whandle=f_open(wfilename,12)

if whandle=-1
	werror=ferror()
else
	vect[wHandle]=wfilename
	=xtrace(whandle,wfilename,'ABIERTO ')
	=f_seek(whandle,0)
	werror=ferror()
endif

if wbloque='IZQ'
	wcol=04
else
	wcol=37
endif

if wzona='INF'
	if wfunc='B' .and. wbloque='IZQ'
		*scroll(05,01,09,78,1)
		scroll 05,01,09,77,1
	endif
	if wfunc='R' .and. wbloque='DER'
		*      scroll(05,01,09,78,1)
		scroll 05,01,09,77,1
	endif
	@ 09,01 say wnudi
	wrow=9
else
	wrow=3
	if wbloque='IZQ'
		@ wrow,wcol say space(33)
	else
		@ wrow,wcol say space(42)
	endif
endif
if whandle=-1 .or. !werror=0
	if wdisperr
		=fmensa('ERROR en Apertura de','Archivo '+wfilename,'',whandle)
		@ wrow,wcol+3 say 'ERR '
		@ wrow,wcol say str(whandle,2)
		@ wrow,wcol+8 say wfilename
	endif
else
	@ wrow,wcol+3 say 'Open'
	@ wrow,wcol say str(whandle,2)
	@ wrow,wcol+8 say wfilename
endif
return whandle

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function enteresc
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
priv wkey

@ 21,50 say 'ENTER'
@ 22,50 say 'ESC'

@ 21,57 say 'para continuar'
@ 22,57 say 'para interrumpir'
wkey=0

do while wkey<>27 .and. wkey<>13
	wkey=inkey()
enddo

@ 17,43 clear to 22,78
return wkey

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function fbox
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para wtipo

if wtipo='B'
	fbtitle='EL RESGUARDO DE ARCHIVOS SE REALIZARA EN   '+upper(wdrde+wdide)
else
	fbtitle='RECUPERO DE ARCHIVOS SE REALIZARA DESDE '+upper(wdror+wdior)
endif

define window box ;
	at  0.000, 0.000  ;
	size 24,80 ;
	title fbtitle ;
	font "Fixedsys", 9 ;
	float ;
	noclose ;
	nominimize ;
	system ;
	color rgb(,,,192,192,192)

move window box center
activate window box

*@ 02,00,10,79 box('ษอปบผอศบ ')
*@ 02,00,04.500,79 box('ษอปบผอศบ ')

@ 02,00,10,79     box
@ 02,00,04.500,79 box

*@ 04,00 say 'บ'+repl('อ',78)+'บ'

@ 04,01 say 'Disk'
@ 04,07 say 'Stat'
@ 04,12 say 'Origen'
@ 04,40 say 'Stat'
@ 04,45 say 'Destino'
@ 04,74 say 'Disp'

@ 10,00,16,79 box     && ('ฬอนบผอศบ ')
@ 01,40 say  space(40)
if wtipo='B'
	@ 11,01 say 'ATENCION: El Sistema asume que los diskettes que se utilizan, fueron previa-'
	@ 12,01 say '          mente formatteados.'
	@ 13,01 say '          Si se usan diskettes que contengan Archivos u otros Resguardos, '
	@ 14,01 say '          esos datos serแn borrados antes de comenzar la grabaci๓n de cada'
	@ 15,01 say '          diskette del presente Resguardo.'
	*   @ 01,59 say 'Resguardo de Archivos'
endif

if wtipo='R'

	@ 11,01 say 'ATENCION !!!   La informaci๓n Existente en el Disco Duro serแ Borrada.'
	@ 13,01 say 'Los Archivos que se recuperarแn, reemplazarแn a los existentes en el  '
	@ 14,01 say 'Directorio '+upper(wpade)
	*   @ 01,60 say 'Recupero de Archivos'
endif

@ 16,00,23.500,79 box  &&('ฬอนบผอศบ ')
@ 16,42,23.500,79 box  &&('หอนบผอสบ ')

return ''

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function elijeflopy
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_title
load \ss_fox\isdiskin.bin

w_unid=1

do while .t.
	do elijeflo.spr

	if lastkey()=p_esc
		loop
	endif

	if w_unid=1
		e_dr='A:'
	else
		e_dr='B:'
	endif

	exit
enddo

release module isdiskin.bin

return e_dr

* ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function valflop
*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

w_driv=iif(w_unid=1,'A:','B:')

w_retu=.t.
w_auxi=w_driv

call isdiskin.bin with w_driv

if w_driv=='0:'
	wait 'Diskette sin formatear o no existe diskette'+chr(13)+;
		'Inserte un diskette en la unidad '+w_auxi+' y presione una tecla...' wind

	w_retu=.f.
endif

if w_retu
	clear read
endif

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function elijedisp
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters e_title, e_def, e_canc, e_inic

priv like e_*

if type('e_title')!='C'
	e_title=''
endif
if type('e_def')!='C'
	e_def=set('default')+'\'
endif

e_defa=sys(5)+sys(2003)

set defa to &e_def

do while .t.
	w_path=''

	=seterr('OFF')
	do elijedis.spr
	=seterr('ON')

	if lastkey()=p_esc
		if !e_canc
			loop
		else
			e_dr=''
			w_dire=''
			exit
		endif	
	endif

	e_dr=left(w_path,2)
	w_dire=trim(subs(w_path,3,50))

	exit
enddo
set defa to &e_defa
return (e_dr)


*> NETFUN <********************************************************************
* Funciones NET :
* -------------    Pแrametro :
* Login()      ->  'S' o 'E'   Abre File XXF077 Share, Logonea Empresa-Terminal.
* Logout()     ->              Deslogonea Empresa-Terminal.
* ClosAll()    ->              Cierra todas las Areas de 2 a 30.
* TerAno()     ->  'R' o ''    Busca Secuencialmente Salidas Anormales.
* LockEmp()    ->  '99'        Busca que no haya usuarios logoneados en '99'
* BeginTran()  ->              Verifica antes de bajar informacion SA.
* EndTran()    ->              Cierra Begintran().
* ClearTran()  ->  '99'        Limpia despues de Recupero las salidas Anormales.
* ViewExit()   ->              Muestra Secuencia de Salida Anormal.
*******************************************************************************
* -----------------------------------------------------------------------------
proc cleartran
*-----------------------------------------------------------------------------
para cl_coem

cl_area=alias()

cl_exit=.t.

d0wait=.5
d0nede=.1
d0mene=.f.

sele f77
set filter to d77empr$cl_coem
go top in f77

do while .not. eof('f77')

	cl_ulre=recno()

	do while cl_exit

		if .not. rlock('f77')
			if !nf_puab
				=errornet(056)
				=login('E')
				loop
			else
				=login('E')
				cl_exit=.f.
			endif
		else
			repl d77tran with ' ',;
				d77logi with ' ',;
				d77stat with ' '

			=login('E')
			cl_exit=.f.
		endif
	enddo

	cl_exit=.t.

	go cl_ulre

	skip

enddo

set filter to

d0mene=.t.
d0nede=.5
d0wait=1

if !empty(cl_area)
	sele &cl_area
endif

return


* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function viewexit
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

return ''

*VI_Area=alias()
*
*n0fipas=NF_Fi66
*d0mene=.f.
*net_use[1]=net_nf('n0fipas','S')
*if !net_use()
*   d0mene=.t.
*   return ''
*endif
*d0mene=.t.
*
*go bott
*do while .not. bof()
*   if .not. empty(m_cami)
*      save scree to m_screen
*      clear
*
*      @   1,  1 SAY d0emp
*      @   1, 50 SAY d0sys
*      @   2,  0 SAY "ฺ------------------------------------------------------------------------------ฟ"
*      if NF_ReBa
*         @   3,  0 SAY "ณ Se ha detectado que la Terminal :   , tuvo una salida anormal del sistema.   ณ"
*         @   4,  0 SAY "ณ La misma ocurri๓ en un proceso que alteraba informaci๓n. Serแ necesario      ณ"
*         @   5,  0 SAY "ณ RECUPERAR el ๚ltimo Resguardo realizado. En todos los casos notificar a su   ณ"
*         @   6,  0 SAY "ณ PROVEEDOR  de  la  situaci๓n  detallando  NUMERO :     , EMPRESA Y OPCIONES. ณ"
*         @   7,  0 SAY "ณ Ante cualquier duda su PROVEEDOR le indicara.                      ฏ NG005 ฎ ณ"
*      else
*         @   3,  0 SAY "ณ Se ha detectado que la Terminal :   , tuvo una salida anormal del sistema.   ณ"
*         @   4,  0 SAY "ณ La misma ocurrio en un proceso que NO alteraba informaci๓n. Se recomienda    ณ"
*         @   5,  0 SAY "ณ Realizar el proceso 'Terminaciones Anormales'. Si tiene Problemas con la     ณ"
*         @   6,  0 SAY "ณ informaci๓n,  notifique  a  su  PROVEEDOR de  la situaci๓n  detallando ,     ณ"
*         @   7,  0 SAY "ณ NUMERO :     , EMPRESA Y OPCIONES.                                 ฏ NG006 ฎ ณ"
*      endif
*      @   8,  0 SAY "ร----ย-------------------------------------------------------------------ย-----ด"
*      @   9,  0 SAY "ณ    ณ Opcion                   Descripcion                              ณ     ณ"
*      @  10,  0 SAY "ณ    ร-------------------------------------------------------------------ด     ณ"
*      @  11,  0 SAY "ณ    ณ                                                                   ณ     ณ"
*      @  12,  0 SAY "ณ    ณ                                                                   ณ     ณ"
*      @  13,  0 SAY "ณ    ณ                                                                   ณ     ณ"
*      @  14,  0 SAY "ณ    ณ                                                                   ณ     ณ"
*      @  15,  0 SAY "ณ    ณ                                                                   ณ     ณ"
*      @  16,  0 SAY "ณ    ณ                                                                   ณ     ณ"
*      @  17,  0 SAY "ณ    ณ                                                                   ณ     ณ"
*      @  18,  0 SAY "ณ    ณ                                                                   ณ     ณ"
*      @  19,  0 SAY "ณ    ณ                                                                   ณ     ณ"
*      @  20,  0 SAY "ณ    ณ                                                                   ณ     ณ"
*      @  21,  0 SAY "ณ    ภ-------------------------------------------------------------------ู     ณ"
*      @  22,  0 SAY "ณ                                                                              ณ"
*      @  23,  0 SAY "ภ------------------------------------------------------------------------------ู"
*      @  24,  0 SAY "Fecha:"
*      @  24,  7 SAY date()
*
*      go top
*      me_clav=right(str(10000+int((val(m_key)+99)*2),5),4)
*      setcolor(hi)
*      @ 3,36 say NF_TeAb
*      if NF_ReBa
*         @ 06,53 say me_clav
*      else
*         @ 07,11 say me_clav
*      endif
*
*      @ 24,20 SAY 'Presione cualquier tecla para continuar.'
*      m_cara=''
*      for me_x=1 to 10
*	 @ me_x+10,7 say m_cami
*	 @ row(),31  say m_desc
*	 skip
*      next
*
*      setcolor(lo)
*
*      inkey(0)
*
*      restore scree from m_screen
*
*      exit
*   endif
*   skip -1
*enddo
*
*use
*
*if .not. empty(VI_Area)
*   sele &VI_Area
*endif
*return ''

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function lockemp  && Busca que no existan usuarios en una determinada empresa
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

para lo_coem

lo_area=alias()
lo_retu=.t.
lo_prim=.t.

if lo_coem=nf_coem
	lo_stat=nf_stat
	nf_stat='C'
	=login('E',.t.)
endif

sele f77

if !empty(lo_coem)
	set filter to d77empr$lo_coem
endif

go top in f77

if eof('f77')
	=net_appe('f77')
	=db_rlock('f77')
	repl d77empr with lo_coem,;
		d77term with netuser
	=login('E')
endif

go top in f77

do while .not. eof('f77')

	if !d77term$netuser .and. !d77stat$'R'
		if f77->d77logi$'N' .or. f77->d77stat$'E' .or. f77->d77stat$'C'
			nf_telo=f77->d77term
			lo_retu=.f.

			* Dejo limpia sin 'C'
			* -------------------

			if !lo_prim .and. !lo_coem$nf_coem
				* go_rec('f77',LO_ReLo)
				go lo_relo in f77
				repl d77stat with ' '
				if !eof('f77')
					go recno('f77') in f77
				endif

				=login('E')
			endif

			exit
		endif
	endif

	if !d77stat$'R' .and. !d77empr$nf_coem .and. lo_prim

		=db_rlock('f77')
		repl d77stat with 'C'
		lo_prim=.f.
		lo_relo=recno('f77')
	endif

	skip
enddo

if !lo_retu .and. lo_coem=nf_coem
	nf_stat=lo_stat
	=login('E',.t.)
else
	=login('E')
endif

set filter to

if !empty(lo_area)
	sele &lo_area
endif

return lo_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function unlockemp   && Termina uso exclusivo de la Empresa.
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para lo_coem

un_area=alias()

sele f77
if !empty(lo_coem)
	set filter to d77empr$lo_coem
endif
go top in f77

do while .not. eof('f77')

	if f77->d77stat$'C'

		=db_rlock('f77')
		repl d77stat with ' '
		if !eof('f77')
			go recno('f77') in f77
		endif

	endif

	skip
enddo

set filter to

=login('E')

if !empty(un_area)
	sele &un_area
endif

return ''

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function terano  && Busca que no haya salidas anormales
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para te_fure

if parameters()=0
	te_fure=''
endif

te_area=alias()
te_reva=.f.

d0wait=.5
d0nede=.1
d0mene=.f.

sele f77
set filter to d77empr$nf_coem
go top in f77

do while .not. eof('f77')

	te_ulre=recno()

	do case
		case !f77->d77term$netuser .and.;
				!f77->d77tran$'T'     .and.;
				!nf_puab              .and.;
				f77->d77logi$'N'     .and.;
				te_fure$'R'

			if rlock('f77')
				nf_teab=f77->d77term
				=login('E')
				nf_puab=.t.
			else
				=login('E')
			endif
		case f77->d77tran$'T'
			if rlock('f77')
				if f77->d77term<>netuser .and.;
						!f77->d77stat$'E'      .and.;
						!f77->d77stat$'R'      .and.;
						te_fure$'R'

					repl f77->d77stat with 'R'    && lo guardo Duro...
					if !eof('f77')
						go recno() in f77
					endif
				endif
				nf_teab=f77->d77term
				nf_reab=recno('f77')
				=login('E')
				te_reva=.t.
				exit
			else
				if f77->d77stat$'E' .or. f77->d77stat$'R'
					nf_teab=f77->d77term
					nf_reab=recno('f77')
					=login('E')
					te_reva=.t.
					exit
				else
					=login('E')
				endif
			endif
	endcase

	go te_ulre
	skip
enddo

d0mene=.t.
d0wait=1
d0nede=.5

set filter to

if te_reva
	nf_puab=.f.
endif

do case
	case te_reva .and. te_fure$'R'
		if !lockemp(nf_coem)
			te_reva=.f.
			nf_reba=.f.
		endif
endcase

if !empty(te_area)
	sele &te_area
endif

return te_reva

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function lockemp && Busca que no existan usuarios en un determinada empresa
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para lo_coem

lo_area=alias()
lo_retu=.t.
lo_prim=.t.

if lo_coem=nf_coem
	lo_stat=nf_stat
	nf_stat='C'
	=login('E',.t.)
endif

sele f77

if !empty(lo_coem)
	set filter to d77empr$lo_coem
endif

go top in f77

if eof('f77')
	=net_appe('f77')
	=db_rlock('f77')
	=set_alia('f77')
	repl d77empr with lo_coem,;
		d77term with netuser
	=rest_alia()
	=login('E')
endif

go top in f77

do while .not. eof('f77')

	if !d77term$netuser .and. !d77stat$'R'
		if f77->d77logi$'N' .or. f77->d77stat$'E' .or. f77->d77stat$'C'
			nf_telo=f77->d77term
			lo_retu=.f.

			* Dejo limpia sin 'C'
			* -------------------

			if !lo_prim .and. !lo_coem$nf_coem
				*go_rec('f77',LO_ReLo)
				go lo_relo in f77
				=set_alia('f77')
				repl d77stat with ' '
				if !eof('f77')
					go recno() in f77
				endif
				=rest_alia()

				=login('E')
			endif

			exit
		endif
	endif

	if !d77stat$'R' .and. !d77empr$nf_coem .and. lo_prim
		=db_rlock('f77')
		=set_alia('f77')
		repl d77stat with 'C'
		=rest_alia()
		lo_prim=.f.
		if .not. eof('f77')
			lo_relo=recno('f77')
		else
			lo_relo=0
		endif
	endif

	skip
enddo

if !lo_retu .and. lo_coem=nf_coem
	nf_stat=lo_stat
	=login('E',.t.)
else
	=login('E')
endif

set filter to

if !empty(lo_area)
	sele &lo_area
endif

return lo_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function equalstr    && Comparador de Estructuras de UN File
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para wfile1,wfile2

priv wequal,walias,wscreen
wequal=.f.
walias=alias()

wexis1=.f.
wexis2=.f.

if mfile(wfile1)
	wexis1=.t.
endif
if mfile(wfile2)
	wexis2=.t.
endif

if wexis1 .and. wexis2
if wfile1='000\GVF002X.DBF'
	set step on
	acti wind debug
endif
	sele 0
	use &wfile1 alias file1
	wcant1=fcount()

	sele 0
	use &wfile2 alias file2
	wcant2=fcount()

	if wcant1=wcant2
		declare names1[wCant1,4]
		declare names2[wCant1,4]

		names1=''
		names2=''

		sele file1
		=afields(names1)
		sele file2
		=afields(names2)
		for y=1 to wcant1
			names1[y,1]=left(names1[y,1]+space(10),10)
			names2[y,1]=left(names2[y,1]+space(10),10)
		next
		db_comp=.f.

		declare array1[wCant1,4],array2[wCant1,4]

		array1=repl('.',19)
		array2=repl('.',19)

		for y=1 to wcant1
			**           Nombre           Tipo                 Longitud                Decimales
			array2[y,1]=names2[y,1]+'  '+names2[y,2]+'  '+str(names2[y,3],3)+'  '+str(names2[y,4],3)
			array1[y,1]=names1[y,1]+'  '+names1[y,2]+'  '+str(names1[y,3],3)+'  '+str(names1[y,4],3)
		next

		=asort(array1)
		=asort(array2)

		wequal=.t.
		for y=1 to wcant1
			if array1[y,1] <> array2[y,1]
				* Se pregunta si es mayor la estructura
				* -------------------------------------
				*if Array1[y] < Array2[y]
				wequal=.f.
				*endif
			endif
		next
	endif

 	sele file1
	use
	sele file2
	use
endif
if !empty(walias)
	sele &walias
endif
return wequal

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function chqnet  && Funcion chqnet : INS0 -> Verificador de Claves.
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para wpre

if mfile(wpre+'.mem')
	if mfile(wpre+'2.mem')

		rest from &wpre additive      && Leo Archivo Parametros

		if type('Z_NT')=='C'
			* si ya existia Z_NT en el xx.mem trae el numero de terminales
			* y lo guarda en la variable temporaria wz_nt
			wz_nt=z_nt
		endif

		rest from &wpre.2 additive    && Aqui esta tomando el nuevo valor de Z_NT

		if !type('wz_nt')=='C'
			* Si no se inicializo arriba fuerzo la desigualdad
			* (es la primera vez)
			wz_nt=z_nt+' '
		endif

		if z_nt<>wz_nt
			* El fin de esta grabacion es grabar el nuevo numero
			* de Z_NT
			save to &wpre all like z_*   && Grabo Parametros y Terminales
		endif
	endif

	if mfile(wpre+'3.mem')

		rest from &wpre additive      && Leo Archivo Parametros

		if type('Z_OP')=='C'
			* si ya existia Z_OP en el xx.mem trae las opciones disponibles
			* y lo guarda en la variable temporaria wz_op
			wz_op=z_op
		endif

		rest from &wpre.3 additive    && Aqui esta tomando el nuevo valor de Z_OP

		if !type('wz_op')=='C'
			* Si no se inicializo arriba fuerzo la desigualdad
			* (es la primera vez)
			wz_op=z_op+' '
		endif

		if z_op<>wz_op
			* El fin de esta grabacion es grabar el nuevo numero
			* de Z_OP

			* Este proceso se hace para forzar un numero de instalacion por cambiar
			* las opciones disponibles.
			z_ve=decript(z_ve,3)
			z_ve=left(z_ve,18+asc(subst(z_ve,17,1)))+'00000000'+right(z_ve,len(z_ve)-(18+asc(subst(z_ve,17,1))+8))
			z_ve=encript(z_ve,3)

			save to &wpre all like z_*   && Grabo Parametros y Terminales
		endif

	endif

else
	=salir('Instalaci๓n Incompleta')
endif
return ''

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function chqcfg  && Chequeo de configuracion
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para c_mini
if parameters()=0
	c_mini=55
endif

set resou off

*modi wind screen;
	fill file memofond.bmp ;
	font 'arial',10		&& R.09 Mariano

*zoom wind screen max	&& R.09 Mariano


read when .f.


*
* Chequeo de si el sistema esta corriendo en el directorio raiz
*
if !curdir()='\'+d0pref+'\'
	w_err1='El Sistema est๓ siendo ejecutado'
	w_err2='en un directorio no vแlido :' + curdir()
	w_err3=''
	w_err4='Debe hacerse desde: '+'\'+d0pref+'\'
	w_err5=''
	=advgrave(w_err1+chr(13)+w_err2+chr(13)+w_err3+chr(13)+w_err4+chr(13)+w_err5)
	=mquit()
endif

*
* Chequeo y creacion de Directorio Memosoft en C:
*
if !mfile('C:\MEMOSYS\NUL')
	=creadir('C:\MEMOSYS')
endif

*
* Chequeo y creacion de Directorio de directorio de sistema en C:
*
if !mfile('C:\MEMOSYS\'+d0pref+'\NUL')
	=creadir('C:\MEMOSYS\'+d0pref)
endif


if !mfile(d0pref+'.mem')
	=salir('Instalaci๓n Incompleta')
else
	* Necesito saber si es mono o multiuser

	rest from &d0pref addi

	if type('z_nt')='C'
		nf_cla2 = decript(z_nt,3)
		nf_cate = subst(nf_cla2,18+asc(subst(nf_cla2,17,1))+1,4)
	else
		nf_cate='0001'
	endif

	if val(p_netuser)>val(nf_cate)
		p_netuser='01'
	endif

endif



*
* Chequeo y creacion de Directorio de usuario en C:
*

* Borro todos los directorios distintos del que corresponde
t_cant=adir(wdius,'C:\MEMOSYS\'+d0pref+'\??','D')
if t_cant>2
	=asort(wdius)
	for i=3 to t_cant
		if alltrim(wdius[i,1])<>p_netuser
			=rmdir('C:\MEMOSYS\'+d0pref+'\'+alltrim(wdius[i,1]))
		endif
	next
endif

* Si el que corresponde no existe, lo creo
if !mfile('C:\MEMOSYS\'+d0pref+'\'+p_netuser+'\NUL')
	=creadir('C:\MEMOSYS\'+d0pref+'\'+p_netuser)
endif



*
* ChequeO y creaci๓n de Directorio de USERS
*
c_refi='\'+d0pref+'\USERS\00\FOXUSER.DBF'              && RESOURSE generico

c_reus='\'+d0pref+'\USERS\'+ p_netuser + '\FOXUSER.DBF' && RESOURSE De usuario

c_dius='\'+d0pref+'\users\'+p_netuser

if !mfile(c_refi)
	w_err1='No Existe '+c_refi
	w_err2=''
	w_err3='Comunicarse Con Su Proveedor'
	w_err4=''
	w_err5=''
	=advgrave(w_err1+chr(13)+w_err2+chr(13)+w_err3+chr(13)+w_err4+chr(13)+w_err5)
	=mquit()
else
	if !mfile(c_reus) && chequea si existe RESOU usuario

		=creadir(c_dius,.t.)

		* Copia FOXUSER.DBF
		copy file &c_refi to &c_reus

		* Copia FOXUSER.FPT
		c_orig='\'+d0pref+'\users\00\foxuser.fpt'
		c_dest='\'+d0pref+'\users\'+ p_netuser + '\foxuser.fpt'
		copy file &c_orig to &c_dest

	endif
endif


*** Chequeo de File Handles
=creadir(curdir()+'TEMP')

c_han=0
c_handle=0
c_cant=0
c_ini=1

dimension ciehand(c_mini+1)	&& mantiene el nro de file handle creado
ciehand=0

do while c_han>-1 and c_cant<=c_mini
	c_name=curdir()+'TEMP\H'+d0pref+p_netuser+strcero(str(c_han+1,3))

	c_han=f_create(c_name,0)

	if c_han>c_handle
		if c_ini=1
			c_ini=c_han
		endif
		c_handle=c_han
		c_cant=c_cant+1
		ciehand(c_cant)=c_han
	endif
enddo

for i=1 to c_cant
	=f_close(ciehand(i))		&& cierra el nro de file handle creado
next

release ciehand

if c_mini>c_cant

	w_err1='FILES:  Actual='+str(c_handle-c_cant,3)+'  Disponibles='+str(c_cant,3)
	w_err2=''
	w_err3='Debe aumentar el n๚mero de FILES en el Archivo CONFIG.SYS'
	w_err4='     Como mํnimo FILES='+str(c_mini-c_cant,2)
	w_err5='    Y luego Reiniciar la Computadora.'
	w_err6=' Si la red es NOVELL consultar a soporte t้cnico'

	=advgrave(w_err1+chr(13)+w_err2+chr(13)+w_err3+chr(13)+w_err4+chr(13)+w_err5+chr(13)+w_err6)

	=mquit()
endif

* Borrado de Archivos Generados por chequeo de files
=delefile(curdir()+'TEMP\' , 'H'+d0pref+p_netuser+'???.')

* Chequeo de si no esta siendo usado con el mismo netuser, otra terminal o otra ventana
c_ini=f_open(c_reus,2)
if c_ini>-1
	=f_close(c_ini)
else
	clear
	w_err1='El Sistema estแ siendo Ejecutado'
	w_err2=''
	w_err3='en otra Ventana de esta Computadora'
	w_err4=''
	w_err5='o en otra Terminal con NETUSER='+p_netuser

	=advgrave(w_err1+chr(13)+w_err2+chr(13)+w_err3+chr(13)+w_err4+chr(13)+w_err5)

	=mquit()
endif

c_defa=sys(5)+curdir()
set defa to &c_dius
set resource to
set defa to &c_defa

return c_cant

* --------------------------------------------------------
function creadir
* --------------------------------------------------------
para c_dire,c_quit
priv all like c_*

if parameters()=1
	c_quit=.f.
endif

c_mkdir=mkdir(c_dire)
do case
	case c_mkdir=0
		* Exitoso
	case c_mkdir=6
		* Directorio ya existente
	case c_mkdir=1
		w_err1='No Pudo Crearse '+c_dire
		w_err2=''
		w_err3='Comunicarse Con Su Proveedor'
		w_err4=''
		w_err5=''
		=advgrave(w_err1+chr(13)+w_err2+chr(13)+w_err3+chr(13)+w_err4+chr(13)+w_err5)
		if c_quit
			=mquit()
		endif
	other
		w_err1='Error '+ str(c_mkdir,2)+ ' de MKDIR al Crearse '+c_dire
		w_err2=''
		w_err3='Comunicarse Con Su Proveedor'
		w_err4=''
		w_err5=''
		=advgrave(w_err1+chr(13)+w_err2+chr(13)+w_err3+chr(13)+w_err4+chr(13)+w_err5)
		if c_quit
			=mquit()
		endif
endcase
return c_mkdir

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function testini
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
* wspre : prefijo de sistema
* wssys : nombre de sistema
* wsver : version
* wsval : si proteje o no
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
param wspre,wssys,wsver,wsval
private ccadena, clinea ,ncade1, ncade2
ccadena = ''
clinea=''
ncade1=0
ncade2=0

publi nf_vers, nf_cate, d0opci
nf_vers=spac(8)
nf_cate=spac(4)
d0opci=spac(5)   && que opciones puede utilizar

wspre = upper(wspre)
if set('DEVELOP')='OFF'
	** No es produccion **

	public      w0ses,w0sek  && variables sentinel
	store '' to w0ses,w0sek
	public w0mop             && modo de protec.  V=por volume, D=demo, S=sentinel
	w0mop = 'V'

	wftst  = wspre+'.tst'
	wfmem  = wspre+'.mem'
	wf1mem = wspre+'1.mem'

	if !mfile(wfmem)  &&  no existe XX.mem
		=salir('Instalaci๓n Incompleta')
	endif

	rest from (wfmem) additive

	if type('Z_&wspre')=='C'
		&wspre  = z_&wspre
		co      = z_co

	endif

	if type('Z_VE')=='C' .and. type('Z_NT')=='C'
		nf_cla1 = decript(z_ve,3)
		nf_cla2 = decript(z_nt,3)
		nf_vers = subst(nf_cla1,18+asc(subst(nf_cla1,17,1))+1,8)
		nf_cate = subst(nf_cla2,18+asc(subst(nf_cla2,17,1))+1,4)
	else
		nf_vers = '00000000'
		nf_cate = '0001'
	endif

	if type('Z_NI')=='C'
		nf_ni = decript(z_ni,3)
		wssni = subst(nf_ni,18+asc(subst(nf_ni,17,1))+1,4)
	else
		wssni = '0000'
	endif

	if type('Z_OP')=='C'
		w0_op = decript(z_op,3)
		d0opci = subst(w0_op,18+asc(subst(w0_op,17,1))+1,5)
	endif

	if type('Z_NC')=='C'
		w_cla = decript(z_nc,3)
		wacla = subst(w_cla,18+asc(subst(w_cla,17,1))+1,4)
	else
		wacla = '    '
	endif

	if type('Z_DA')=='C'
		p_date = decript(z_da,3)
		p_date = subst(p_date,18+asc(subst(p_date,17,1))+1,8)
		p_date = ctod(right(p_date,2)+'/'+substr(p_date,5,2)+'/'+left(p_date,4))
	else
		p_date = {}
	endif

	wsver=wsver+'   NI:'+wssni

	if !mfile(wf1mem)  && no existe xx1.mem

		wvol = volume(sys(5))

		if empty(wvol)
			wvol='El volumen de la unidad '+sys(5)+' no tiene etiqueta'
		else
			wvol='El volumen de la unidad '+sys(5)+' es '+wvol
		endif

		wvol = encript(wvol,3)

		* aqui se hace el control de seguridad
		if !mfile('habi.tst') and wvol<>&wspre and wsval and p_netuser='01'
			* Si el volume es distinto
			* e ingreso queriendolo controlar
			* y no esta en proceso de habilitaci๓n
			* y es MAQUINA 01
			=salir('MAQUINA DESCONOCIDA')
		endif

		if !mfile('habi.tst') and !mfile(dimaqi()+d0fise) and p_netuser='01' and wsval
			* Si no existe el archivo de control
			* e ingreso queriendolo controlar
			* y no esta en proceso de habilitaci๓n
			* y es MAQUINA 01
			=salir('NO ES MAQUINA INICIAL')
		endif
		*
	else
		*  existe xx1.mem
		*
		w_nva = d0prxx

		rest from (wf1mem) additive

		w_str = decript(&w_nva,3)

		w0ses = left(w_str,18)
		w0sek = right(w_str,6)

		* Se fuerza modo demo
		w0mop = 'D'
		w0sek = 'D'


	endif
else
	* Entra por aqui cuando es produccion, voy a inicializar
	* d0opci para que funcionen TODAS LAS OPCIONES
	if d0pref='GW'
		d0opci='MSPY'
	else
		d0opci='ABCDEFGHIJKLMNOPQSTUVWXYZ' && Todas Menos R
	endif
	nf_cate='0099'
	public      w0ses,w0sek  && variables sentinel
	store '' to w0ses,w0sek
	public w0mop             && modo de protec.  V=por volume, D=demo, S=sentinel
	w0mop = 'V'
	w0sek = 'V'
endif

if iif(empty(val(d0opci)),.f., date()-p_date>val(d0opci)*30)		&& cuando se exceda el tiempo de habilitacion se pondra en demo

	if mfile('etc\letdema.fot')
		*
		* puede deshabilitar desde cualquier maquina entrando con 01
		*
		copy file etc\letdema.fot to &wspre..mem
		if mfile('etc\letdemb.fot')
			copy file etc\letdemb.fot to &wspre.1.mem
			do case
				case adir(x_opci,'etc\letdem?.fot')>3	&& sistema con opciones
					rele x_opci
					copy file etc\letdemb.fot to &wspre.3.mem
				otherwise	&& sistema sin opciones
					rele x_opci
					w_file='\&wspre.\&wspre.3.mem'
					if mfile(w_file)
						* Borra archivo de opciones
						dele file &w_file
					endif
			endcase
		endif

		w_file='\&wspre.\&wspre.2.mem'
		if mfile(w_file)
			* en la que entra borra multiusuario
			dele file &w_file
		endif

		w_file=dimaqi()+d0fise
		if mfile(w_file)
			* en la que entra borra archivo de seguridad
			dele file &w_file
		endif

		if lresp
			=advgrave('Si desea rehabilitar el sistema, por favor, comunํquese con el Proveedor.'+chr(13)+chr(13)+;
					  'El tiempo pactado de uso del sistema ha caducado.')
		else
			=advgrave('Si desea rehabilitar el sistema, por favor, comunํquese con MemoSoft.'+chr(13)+chr(13)+;
					  space(30)+'info@memosoft.com.ar'+chr(13)+space(30)+'comercial@memosoft.com.ar'+chr(13)+;
					  space(30)+'www.memosoft.com.ar'+chr(13)+space(30)+'Tel/Fax:4554-6111','El tiempo pactado de uso del sistema ha caducado.')
		endif

		=mquit()
	endif

endif

=Expira()	&& tiempo de expiracion del sistema

return ''

*-P อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure setnet
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameter ww_filnet

*Public Net_Use[15]       ,;
*       Net_Lock[15]

public d0f77   , d0wait  ,  d0mene  , d0nede  ,;
	netuser ,;
	nf_logi , nf_stat ,  nf_reem , nf_rean ,;
	nf_coem , nf_teab ,  nf_reab , nf_reba ,;
	nf_puab , nf_exit ,  nf_telo , nf_text

d0wait=1                     && Ciclos -1 en Net_use y -.5 en net_lock
d0nede=.5                    && demora entre ciclos en net_lock
d0mene=.t.                   && Emite mensaje cuando no puede Abrir o Lockear.

netuser=p_netuser            && Es la que tiene el verdadero valor

do case
	case val(netuser)<1                              && Usuario no definido.
		netuser='01'                                &&
	case val(nf_cate)=1 .and. val(netuser)>1         && Fuerza MonoUsuario.
		netuser='01'                                &&
	case val(netuser)>val(nf_cate)                   && Excede cantidad de
		netuser=right(nf_cate,2)                    && Usuarios.
endcase

p_netuser=netuser

* NetFun : variables
* ------------------

d0f77=ww_filnet

nf_logi=' '
nf_stat=' '

nf_reem=0
nf_rean=0
nf_coem=spac(2)
nf_teab=''
nf_telo=''
nf_reab=0
nf_reba=.f.
nf_puab=.f.
nf_exit=.f.

* Para Version MonoUsuario.
* -------------------------

if val(nf_cate)==1
	d0mene=.f.
	use &d0f77 in 0 alias f77 exclusive
	if neterr()
		=errornet(098)
		=mquit()
	endif

	d0mene=.t.
	close data
endif

if val(nf_cate)>1
	nf_text=' MU#'+netuser+' '+alltrim(left(d0opci,5))+' '
else
	nf_text=' MO#'+netuser+' '+alltrim(left(d0opci,5))+' '
endif

return

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function login   && Apertura de file XXF077
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para lo_aper,log_value

if parameters()=1
	log_value=.f.
endif

lg_area=alias()
lo_reva=.t.

do case
	case upper(lo_aper)$'E' .and. nf_reem<>0
		sele f77
		go nf_reem

		=db_rlock('f77')

		if (d77logi<>nf_logi .or. d77stat<>nf_stat) .and. log_value
			=set_alia('f77')
			repl d77logi with nf_logi,;
				d77stat with nf_stat

			=rest_alia()
			if !eof('f77')
				go recno() in f77
			endif

		endif
		nf_reem=recno('f77')

	case upper(lo_aper)$'S'
		* Si no existe el File de NET
		* ---------------------------
		if !mfile(d0f77+'.DBF')
			clear
			*? chr(7)+'Instalaci๓n Incompleta...'
			w_err1='Instalacion Incompleta...'
			=advgrave(w_err1)

			close all
			=mquit()
		endif
		* Fin de Validaci๓n
		* -----------------
		*net_use[1]=net_nf('d0f77','s')

		if !used('F77')
			use &d0f77 in 0 alias f77
		endif

		d0mene=.f.
		*        LO_ReVA=net_use()
		lo_reva=.not. neterr()
		d0mene=.t.

	case upper(lo_aper)$'E' .and. nf_reem=0
		sele f77
		set filter to d77empr$nf_coem .and. !d77term$netuser
		go top in f77

		* Chequeo que no existe algun usuario realizando un proceso CRITICO.
		* ------------------------------------------------------------------
		do while !eof('f77')
			if f77->d77stat$'C'
				nf_telo=f77->d77term
				lo_reva=.f.
				exit
			endif
			skip in f77
		enddo

		set filter to d77empr$nf_coem .and. d77term$netuser
		go top in f77

		if lo_reva
			if eof('f77')
				=net_appe('f77')
				=db_rlock('f77')
				=set_alia('f77')
				repl d77empr with nf_coem,;
					d77term with netuser,;
					d77logi with nf_logi,;
					d77stat with nf_stat,;
					d77prog with csalida+' Dํa:'+dtoc(date())+' Hora:'+time()

				=rest_alia()

				if !eof('f77')
					go recno() in f77
				endif
				*                   commit
				nf_reem=recno('f77')
			else
				*net_lock[1]='f77  r'

				*              if !net_lock()
				if .not. rlock('f77')
					if d77logi$'N'
						=errornet(007)
					endif
					lo_reva=.f.
					nf_exit=.t.
				else
					if d77logi$'N'
						nf_puab=.t.
						nf_teab=netuser
					endif
					=set_alia('f77')
					repl d77logi with nf_logi,;
						d77stat with nf_stat,;
						d77prog with csalida+' Dํa:'+dtoc(date())+' Hora:'+time()

					if !eof('f77')
						go recno() in f77
					endif
					=rest_alia()
					*                 commit

					nf_reem=recno('f77')
				endif
			endif
		else
			=errornet(057)
		endif
		set filter to
endcase

if !empty(lg_area)
	sele &lg_area
endif

return lo_reva

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function logout  &&  Cierra file XXF077
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
lo_area=alias()

if used('f77')
	sele f77

	if .not. empty(nf_reem)
		go nf_reem

		=db_rlock('f77')
		repl d77logi with ' ',;
			d77stat with ' ',;
			d77prog with ''

		if !eof('f77')
			go recno() in f77
		endif

		unlock in f77
	endif
endif

nf_reem=0

if !empty(lo_area)
	sele &lo_area
endif

return ''

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*                Mensajes para red : Funcion llamada ErrorNet()...            *
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
* Codigos :
* 000-049    > Mensaje de Sistema para Todos los Sistemas
* 050-099    > Mensaje de Empresa-Sistema para Todos los Sistemas
* 100-199    > Mensajes para Contabilidad.
* 200-299    > Mensajes para Sueldos.
* 300-399    > Mensajes para Iva.
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function errornet
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameter numerr

if parameters()==0
	return ''
endif

public  nummen
private mener1, mener2, mener3, mener4 ,;
	menma1, menma2, menma3, menma4
store space(0) to mener1, mener2, mener3, mener4 ,;
	menma1, menma2, menma3, menma4
do case

		* Sistema
		* -------
	case numerr=001
		mener1='ATENCION !!!. Se ha detectado la Utilizaci๓n Exclusiva del Sistema,'
		mener2='desde otra Terminal.'
	case numerr=002
		mener1='Se ha detectado otro Usuario Actualizando la VERSION del Sistema.'
		mener2='No podrแ ingresar al mismo hasta no Finalizar dicho Proceso.'
	case numerr=003
		mener1='Se ha detectado que la empresa estแ sin Actualizar, deberแ salir'
		mener2='del sistema y volver a entrar.'
	case numerr=004
		mener1='CUIDADO !!!. La informaci๓n a Resguardar puede ser Err๓nea, Utilice'
		mener2='un Nuevo Juego de Diskettes para el Proceso.'
	case numerr=007
		mener1='Se ha  detectado que  otro Puesto  de Trabajo  utiliza el mismo'
		mener2='N๚mero de Usuario. Verifique que cada Terminal este configurada'
		mener3='con un N๚mero de Usuario Distinto. > Puesto Detectado : '+netuser


		* Empresa
		* -------
	case numerr=050
		mener1='Se ha detectado que la Terminal : '+nf_telo+' estแ utilizando la Empresa.'
		mener2='No podrแ continuar con el Proceso.'
	case numerr=051
		mener1='Se ha detectado que la Terminal : '+nf_telo+' estแ utilizando la Empresa'
		mener2='Seleccionada, No pudiendo continuar con el Proceso.'
	case numerr=052
		mener1='Se ha detectado  que la Terminal : '+nf_teab+' tuvo  una  salida  Anormal del'
		mener2='Sistema, en un proceso que alteraba informaci๓n. No podrแ ingresar a'
		mener3='la Empresa Seleccionada por encontrarse otra Terminal  efectuando el'
		mener4='RECUPERO correspondiente.'
	case numerr=053
		mener1='Se ha  detectado  que la Terminal : '+nf_teab+' tuvo  una  salida  Anormal'
		mener2='del Sistema, en un proceso  que alteraba informaci๓n. No pudiendo'
		mener3='Realizar el proceso de Recupero, por encontrarse la Terminal :'+nf_telo
		mener4='utilizando la misma EMPRESA.'
	case numerr=054
		mener1='Se ha detectado que una Terminal estแ utilizando la Empresa. No'
		mener2='podrแ continuar con el Proceso.'
	case numerr=055
		mener1='CUIDADO !!!. Se ingreso a un proceso critico, detectando la presencia de'
		mener2='otra TERMINAL intentando  utilizar la Empresa. No podrแ continuar con el'
		mener3='proceso Hasta que la terminal no abandone la Empresa.'
	case numerr=056
		mener1='Se ha  detectado que la Terminal : '+d77term+' estแ  intentado  ingresar a la'
		mener2='Empresa, No pudiendo continuar con el proceso de Recupero. Verifique'
		mener3='que el usuario cancele el proceso de Elecci๓n para esta Empresa.'
	case numerr=057
		mener1='ATENCION !!! Se ha detectado que la Terminal : '+nf_telo+' estแ Realizando un'
		mener2='Proceso CRITICO, no pudiendo ingresar a la empresa, hasta no terminar'
		mener3='dicho Proceso.'
	case numerr=058
		mener1='CUIDADO !!!. Se ha detectado  una Salida  Anornal  desde la'
		mener2='Terminal : '+nf_teab+' La misma ocurrio  en un Proceso  que alteraba'
		mener3='informaci๓n. Deberแ RECUPERAR el ๚ltimo Resguardo Realizado.'


		* Empresa-Sistema
		* ---------------
	case numerr=075
		mener1='Se ha detectado que la Terminal : '+nf_telo+' estแ utilizando el Sistema,'
		mener2='No podrแ continuar con el Proceso.'
	case numerr=076
		mener1='Se ha detectado que una Terminal estแ utilizando el Sistema, No'
		mener2='podrแ continuar con el Proceso.'
	case numerr=077
		mener1='CUIDADO !!!. Se  ingreso a un  proceso critico, detectando la presencia'
		mener2='de otra TERMINAL intentando Ingresar al Sistema. No podrแ continuar con'
		mener3='el proceso Hasta que la terminal no abandone el Sistema.'

		* -------------
		* -------------
	case numerr=098
		mener1='ATENCION !!!. No podrแ Utilizar el Sistema desde otra Terminal'
		mener2='                   < Versi๓n Monousuario >                    '

	case numerr=099
		mener1='ATENCION !!!. Se ha detectado demasiados Archivos Abiertos.'

		* Contabilidad
		* ------------
	case numerr=100
		mener1='CUIDADO !!!. Se ingreso a un Proceso Crํtico, detectando la presencia de'
		mener2='otra TERMINAL utilizando los Archivos de  Contabilidad. Si Ud.  Posee el'
		mener3='Sistema de IVA Compras-Ventas MemoSoft Verifique que ning๚n Usuario est้'
		mener4='usando en dicho Sistema una Empresa con la misma Informaci๓n Contable.'
	case numerr=101
		menma1='ctop(cpadre(ptoc(m.d1cuen)))'
		mener1='ATENCION !!!. Ud esta en un ejercicio '+iif(d0esej$'QP','Precerrado','Preabierto')+' Creando una nueva'
		mener2='Cuenta imputable y  Transformando  la Cuenta '+&menma1+' en Madre'
		mener3='debiendo efectuar el mismo proceso en el ejercicio '+iif(d0esej$'L','Precerrado','Preabierto')+'.'
	case numerr=102
		menma1='ctop(f99->d2cuen)'
		mener1='ATENCION !!!. No se puede continuar con el '+iif(w_opci$'C','Cierre','Precierre')+' porque la Cuenta'
		mener2=&menma1+' No existe en el Nuevo Ejercicio Contable.'
	case numerr=103
		menma1='ctop(f01n->d1cuen)'
		mener1='ATENCION !!!. No se puede continuar con el '+iif(w_opci$'C','Cierre','Precierre')+' porque la Cuenta'
		mener2=&menma1+' No es Imputable en el Nuevo Ejercicio Contable.'
	case numerr=104
		mener1='ATENCION !!!. Ud esta en un ejercicio '+iif(d0esej$'QP','Precerrado','Preabierto')+' Transfiriendo una'
		mener2='Cuenta imputable a Otra. Es Recomendable efectuar el mismo proceso'
		mener3='en el Ejercicio '+iif(d0esej$'L','Precerrado','Preabierto')+'.'


		* Sueldos
		* -------
	case numerr=200
		mener1='Se ha detectado que la Terminal : '+nf_telo+' estแ utilizando la Empresa,'
		mener2='Madre : '+d0comp+' No podrแ continuar con el Proceso.'
	case numerr=201
		mener1='Se ha detectado que la Empresa utilizada es Madre, no pudiendo'
		mener2='Realizar este proceso por encontrarse una terminal  utilizando'
		mener3='el Sistema.'
	case numerr=202
		mener1='CUIDADO !!!. Se ingreso a un Proceso Crํtico, detectando la presencia de'
		mener2='otra TERMINAL utilizando el Maestro de Liquidaciones, No podrแ continuar'
		mener3='con el Proceso Hasta que la terminal no aborte el Proceso.'


	otherwise
		*Mensa('Error Desconocido')
		wait 'Error Desconocido' wind time 4
		return ''
endcase

do case
	case numerr >0   .and. numerr<100
		nummen='ฏ NG'
	case numerr>=100 .and. numerr<200
		nummen='ฏ NC'
	case numerr>=200 .and. numerr<300
		nummen='ฏ NS'
	case numerr>=300 .and. numerr<400
		nummen='ฏ NI'
endcase

nummen=nummen+right(str(numerr+1000,4),3)+' ฎ'

* Do Case
*    Case !empty(MenEr1) .and. ;
*         !empty(MenEr2) .and. ;
*         !empty(MenEr3) .and. ;
*         !empty(MenEr4)
*         Boxmen(MenEr1,MenEr2,MenEr3,MenEr4)
*    Case !empty(MenEr1) .and. ;
*         !empty(MenEr2) .and. ;
*         !empty(MenEr3)
*         Boxmen(MenEr1,MenEr2,MenEr3)
*    Case !empty(MenEr1) .and. ;
*         !empty(MenEr2)
*         Boxmen(MenEr1,MenEr2)
*    Otherwise
*         Boxmen(MenEr1)
* EndCase

w_err1=mener1
w_err2=mener2
w_err3=mener3
w_err4=mener4

=advgrave(w_err1+chr(13)+w_err2+chr(13)+w_err3+chr(13)+w_err4)


return ''

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function frun
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para fr_run
! &fr_run
return ''

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function sentinel   && Llave netsentinel de rainbow
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para s_s
priv s_r
s_r = spac(6)

return strcero(s_s)

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function mquit
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

if set('develop')='OFF'
	=expira()	&& tiempo de expiracion del sistema
endif

on shutdown
close data
*clear all
*release all
if set('develop')='OFF'
	set curs off
	if lresp
*		do sss000q2.spr
	else
		do sss000q.spr
	endif
	clear all
	release all
	quit
else
	clear all
	release all
	set talk on
	set reso on
	set reso to
	set esca on
	set noti on
	set bell on
	set shad off
	set safe on
	set status bar on
	set help on
	set sysmenu to default
	rest macros from system
	set exclusive on
	modify window screen
	set message to
	set library to
	cancel
endif

return ''

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function salir   && Salir del sistema
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
param s_text
clear
set escape off

if lresp
	do salir2.spr
else
	do salir.spr
endif
=mquit()
return ''

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function testclav
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para wz_sis

whabi=iif(mfile('habi.tst'),'H','A')   &&  Variable que Sirve para Habilitar

if w0mop=='D' .and. !whabi$'H'    && Retorna si esta en modo demo...
	return .t.
endif

if netuser<>'01'
	=salir('La Habilitaci๓n Debe Efectuarse Desde la MAQUINA 01')
endif

wret=.f.        && retorno de esta funcion

wncla=spac(4)   && Nueva Clave
wacla=spac(4)   && Clave anterior
walet=spac(4)   && Aleatorio con letra
wopci=spac(5)   && Opciones

wcon=0          && Contador de reintentos

if mfile(wz_sis+'.MEM')
	rest from &wz_sis additive
endif

if type('Z_NI')=='U' .and. type('Z_NC')=='U' && .and. type('Z_NT')=='U'
	w_st=.t.
	winst=spac(4)
	wncla=spac(4)
	wterm='0001'

	* Generacion de Variables Z_M*
	* ------------------------------

	*   z_&wz_sis= &wz_sis
	*   z_co     = co

	if mfile(wz_sis+'2.mem')
		rest from &wz_sis.2 additive
		w_znt=decript(z_nt,3)
		wterm=subst(w_znt,18+asc(subst(w_znt,17,1))+1,4)
	endif
else
	w_st=.f.
	clav1=decript(z_ni,3)
	clav2=decript(z_nc,3)
	clav3=decript(z_nt,3)

	winst=subst(clav1,18+asc(subst(clav1,17,1))+1,4)
	wacla=subst(clav2,18+asc(subst(clav2,17,1))+1,4)
	wterm=subst(clav3,18+asc(subst(clav3,17,1))+1,4)

	if val(winst)==0 .or. val(wacla)==0
		w_st=.t.
		winst=spac(4)
		wncla=spac(4)
		wacla=spac(4)
	endif
endif

if !mfile(dimaqi()+d0fise) and p_netuser='01' and !winst=wacla
	=RmDir('C:\MEMOSYS\'+d0pref+'\01')
	=salir('La Habilitaci๓n Debe Efectuarse Desde la MAQUINA INICIAL')
endif

if type('Z_OP')=='C'
	clav4=decript(z_op,3)
	wopci=subst(clav4,18+asc(subst(clav4,17,1))+1,5)
endif

werr=.t.
wwcla=spac(4)   && compara con Clave

if !w_st
	*** tomo control aqui, cuando winst tiene algo

	walet=genale()

	walex=walet

	=multi()

	wvopc=0
	for ww=1 to 5
		wvopc=wvopc+iif(asc(subst(wopci,ww,1))<>32,;
			asc(subst(wopci,ww,1)),0)
	next

	wwcla=gencla(val(wacla),val(walet) + wvopc + iif(!empty(whabi),asc(whabi),0), '2')	&& R.18 Mariano

endif

if lresp
	do screins2.spr
else
	do screinst.spr
endif

* se deletea el archivo flag para habilitar
* -----------------------------------------
if mfile('habi.tst')
	dele file habi.tst
endif

return wret

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function screinstva	&& valida los campos de la screinst.spr 
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
private w_retu, w_vari

w_retu=.t.
w_vari=varread()
wret=.f.

if w_vari='WINST'

	if val(winst) > 0

		if lastkey()=27

			werr=.f.
			wret=.f.
			w_vari=.f.

		else

			winst=right(str(100000+val(winst),7),4)
			wacla=winst

			show get winst
			show get wacla

			walet=genale()

			walex=walet

			show get walex

			show get wopci
			show get whabi

			=multi()

			wvopc=0

			for ww=1 to 5
				wvopc=wvopc+iif(asc(subst(wopci,ww,1))<>32,;
					asc(subst(wopci,ww,1)),0)
			next

			wwcla=gencla(val(wacla),val(walet) + wvopc + iif(!empty(whabi),asc(whabi),0), '2')	&& R.18 Mariano

			w_st=.f.

			w_retu=.t.

		endif

	else

		w_retu=.f.

	endif

endif

if w_vari='WNCLA'

	if lastkey()=27

		wret=.f.
		w_retu=.t.

	else

		***wait window wncla + '/' + wwcla

		if wncla==wwcla
			wret=.t.
			wcon=3

			z_ni=encript('ท6Nฝ)D(๑ศT’…'+wz_sis+repl('ธ',asc(wz_sis))+winst+;
				'ท6Nฝ)D(๑ศT’…',3)

			z_nc=encript('$eTyC”๏zฃ@๘ีÛ'+wz_sis+repl('*',asc(wz_sis))+wncla+;
				'$eTyC”๏zฃ@๘ีÛ',3)

			z_nt=encript('‘’x“แฺี[f\]:ฎฉd'+wz_sis+repl('',asc(wz_sis))+wterm+;
				'‘’x“แฺี[f\]:ฎฉd',3)

			z_ve=encript('ื์ทeTศ{Û[]&!#%^~'+wz_sis+repl('',asc(wz_sis))+wverxexe+;
				'ื์ทeTศ{Û[]&!#%^~',3)

			z_da=encript('ศ{Û[‘’x“C”๏#%^~'+wz_sis+repl('',asc(wz_sis))+dtos(date())+;
				'ศ{Û[‘’x“C”๏#%^~',3)

			if mfile('habi.tst')

				wvol = volume(sys(5))
				if empty(wvol)
					wvol='El volumen de la unidad '+sys(5)+' no tiene etiqueta'
				else
					wvol='El volumen de la unidad '+sys(5)+' es '+wvol
				endif

				wvol=encript(wvol,3)

				z_&wz_sis=wvol

			endif

			save to &wz_sis all like z_*

			* renombrar el archivo sentinel
			if mfile('habi.tst')
				nw= subs(wz_sis,1,1)

				if mfile(wz_sis+'1.mem')
					dele file (nw)+'.mem'
					rename (wz_sis)+'1.mem' to (nw)+'.mem'
				endif
			endif

			w0mop='V'
			w0ses=''
			w0sek=''

			=db_flock('f77')
			=set_alia('f77')

			repl all f77->d77tran with spac(1),;
				f77->d77logi with spac(1),;
				f77->d77stat with spac(1)

			=rest_alia()
			unlock in f77

			if mfile(wz_sis+'2.mem')
				dele file &wz_sis.2.mem
			endif

			w_dire=dimaqi()

			if !mfile(w_dire+d0fise) and !empty(w_dire) and winst=wacla

				* Crea el archivo de seguridad
				copy file foxtools.fll to &w_dire&d0fise

			endif

			w_ver=stuff(w_ver, at('NI:', w_ver)+4 , 4, winst)

		else
			wait 'N๚mero de Autorizaci๓n Incorrecto...' wind time 2
			wcon=wcon+1
			wncla=spac(4)
		endif

		if wcon=3
			werr=.f.
			
			if mfile('etc\letdema.fot') and !wret
				*
				* puede deshabilitar desde cualquier maquina entrando con 01
				*
				copy file etc\letdema.fot to &wz_sis..mem
				if mfile('etc\letdemb.fot')
					copy file etc\letdemb.fot to &wz_sis.1.mem
					do case
					case adir(x_opci,'etc\letdem?.fot')>3	&& sistema con opciones
						rele x_opci
						copy file etc\letdemb.fot to &wz_sis.3.mem
					otherwise	&& sistema sin opciones
						rele x_opci
						w_file='\&wz_sis.\&wz_sis.3.mem'
						if mfile(w_file)
							* Borra archivo de opciones
							dele file &w_file
						endif
					endcase
				endif

				w_file='\&wz_sis.\&wz_sis.2.mem'
				if mfile(w_file)
					* en la que entra borra multiusuario
					dele file &w_file
				endif

				w_file=dimaqi()+d0fise
				if mfile(w_file)
					* en la que entra borra archivo de seguridad
					dele file &w_file
				endif
			endif

		endif

		w_retu=.t.

	endif

endif

return w_retu

*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function multi
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

if left(walet,1)$'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	walet = stuff(walet,1,1,right(str(asc(left(walet,1)) + asc(right(walet,1)),3),1))
endif

return ''

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function gencla
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para w_ni,w_na,w_al

if parameters()=2
	w_al='0'	&& algoritmo viejo
endif

private w_vexe
do case
	&& R.18b Mariano
	case w_al='2'	&& algoritmo new
		w_Vexe=val(wVersExe+strtran(wVersRel,' ','')+'0')*2.5/100000000	&& version del sistema
	&& R.18e Mariano
	case w_al='1'	&& algoritmo nuevo
		w_Vexe=val(wVersExe+strtran(wVersRel,' ','')+'0')/100000000	&& version del sistema
	otherwise
		w_Vexe=1
endcase

a1=int(w_ni*w_na*3.14159265*w_Vexe*1000000)-int(w_ni*w_na*3.14159265*w_Vexe*100)*10000
a2=right(str(100000+a1,7),4)

return (a2)

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function genale
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

do while .t.
	a1=seconds()*100
	a2=sqrt(a1-int(a1/10000)*10000)
	a3=a1-int(a1/100)*100
	a4=int((a3*100+(a2-int(sqrt(a2))))*1000000)-int((a3*100+(a2-int(sqrt(a2))))*100)*10000
	if a4>0
		exit
	endif
enddo

a5=right(str(100000+a4,7),4)

if val(wterm)>1
	a5=stuff(a5,1,1,chr(val(left(a5,1))+65))
endif

return a5
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function encript
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
** Sintaxis....: char = ENCRIPT (<var1char>[,<var2num>])
**
** Fecha.......: Octubre 1988
**
** Servicio....: Retorna var1char encriptada var2num cantidad de veces.
**
** Ejemplo.....: ENCRIPT(wpala)
**
para p_pala,p_cant

if parameters()=1
	p_cant=1
endif

priv i,j

long=len(p_pala)

for j=1 to p_cant
	wpala=''
	for i=long to 1 step -1
		w_nume=asc(subs(p_pala,i,1))+i
		if w_nume >= 256
			w_nume=w_nume-256
		endif

		wpala=wpala+chr(w_nume)
	next
	p_pala=wpala
next
return wpala

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function decript
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
** Sintaxis....: char = DECRIPT (<var1char>[,<var2num>])
**
** Fecha.......: Octubre 1988
**
** Servicio....: Retorna var1char desencriptada var2num cantidad de veces.
**
** Ejemplo.....: DECRIPT(wpala)
**
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para p_pala,p_cant

if parameters()=1
	p_cant=1
endif

long=len(p_pala)
priv i,j

for j=1 to p_cant
	wpala=''
	for i=long to 1 step -1
		w_nume=asc(subs(p_pala,i,1))-(long-i+1)
		do case
			case w_nume < 0
				** Esto es porque en Clipper la funcion Chr() si le paso un
				** valor negativo me devuelve un valor, que es como si fuese
				** la inversa del numero que se estoy pasando, pero en
				** Foxpro se cuelga
				w_nume=256+w_nume

			case w_nume >= 256
				w_nume=w_nume-256

		endcase

		wpala=wpala+chr(w_nume)
	next
	p_pala=wpala
next
return wpala

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function autor
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
priv a_retu
a_retu = .t.
if .not. empty(w0ses)  && modulo sentinel activado
	if sentinel(w0ses)<>w0sek
		w0mop = 'D'
		if reccount() >= w0top
			=advsuave('Versi๓n Demostraci๓n. Fin Autorizaci๓n.')
	        a_retu = .f.
		endif
	else
		w0mop = 'S'
	endif
endif
return a_retu


*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function hayspace
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para bytes
if parameters()=0
	bytes=1000000
endif

w_retu=.t.

if diskspace()<bytes
	wait 'NO HAY SUFICIENTE ESPACIO EN DISCO'+chr(13)+;
		'Disponible: '+ alltrim(str(diskspace()/1024,12)) + ' Kbytes' wind nowait
	w_retu=.f.
endif

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function deledir
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para wpath,wmodo

if parameters()=1
	wmodo='D'
else
	if !wmodo$'D'
		wmodo='F'
	endif
endif

if !right(wpath,1)='\' and wmodo=='D' 	&& el directorio debe terminar con \
	wpath=wpath+'\'
endif

priv wdeleted,wejec
wdeleted=.t.
wejec=.f.

if !mfile(wpath+'nul')
	wait 'Directorio '+wpath+' inexistente!' wind nowait
	wdeleted=.t.
else
	wait 'Chequeando Directorio '+wpath+'.' wind nowait
	priv wcant,wronly,i,wfiledele,wdires
	wcant=1
	declare wnames[wCant]  && ,wSizes[wCant],wDates[wCant],wTimes[wCant],wAttrs[wCant]

	wcant=adir(wnames,wpath+'*.*','DHS')

	if wcant=2

		wait 'Directorio '+wpath+' Vacํo!' wind nowait

		wmacro=left(wpath,len(wpath)-1)
		=rmdir(wmacro)

	else
		wait 'Borrando Directorio '+wpath+'.' wind nowait
		*     declare wNames[wCant],wSizes[wCant],wDates[wCant],wTimes[wCant],wAttrs[wCant]
		*     adir(wPath+'*.*',wNames,wSizes,wDates,wTimes,wAttrs)
		wronly=0
		wdires=0
		for i = 1 to wcant
			if 'R'$wnames[i,5]
				wronly=wronly+1
			endif
			if 'D'$wnames[i,5]
				wdires=wdires+1
			endif
		next

		if wronly>0 .and. wmodo$'D'
			wait 'Hay '+ltrim(str(wronly))+' archivos ReadOnly en '+wpath+'!' wind
			wdeleted=.f.
		endif
		if wdires>2 .and. wmodo$'D'
			wait 'Hay '+ltrim(str(wdires-2))+' SubDirectorios en '+wpath+'!' wind
			wdeleted=.f.
		endif
		if wdeleted

			for i = 1 to wcant

				if !(alltrim(wnames[i,1])='.' .or. alltrim(wnames[i,1])='..')

					wfiledele=wpath+wnames[i,1]

					*** No abro ninguna base antes de borrarla ***

					*               if upper(right(alltrim(wNames[i,1]),4))='.DBF'
					*                  n0file=wPath+left(trim(wNames[i,1]),at('.',wNames[i,1])-1)

					*                  do while .t.
					*                      use &n0file alias f99X in 0 excl

					*                      if .not. neterr()
					*                          exit
					*                      endif
					*                  enddo
					*                  sele f99X

					* Pongo el use Aca para que no cierre otros alias()
					* -------------------------------------------------
					*                  use
					*               endif

					erase &wfiledele
				endif
			next
			wejec=.t.
		endif
	endif
endif

if wejec .and. wmodo$'D'

	wmacro=left(wpath,len(wpath)-1)
	=rmdir(wmacro)

endif

wait clear

return wdeleted

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function delefile
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para wpath, wilc

priv wcant,wronly,i,wfiledele,wdeleted

wdeleted=.t.

if !right(wpath,1)='\' 	&& el directorio debe terminar con \
	wpath=wpath+'\'
endif

wcant=adir(wnames,wpath+wilc)

if wcant>0

	wronly=0

	for i = 1 to wcant

		if 'R'$wnames[i,5]
			wronly=wronly+1
		endif

	next

	if wronly>0
		wait 'Hay '+ltrim(str(wronly))+' archivos ReadOnly en '+wpath+'!' wind
		wdeleted=.f.
	endif

	if wdeleted

		for i = 1 to wcant

			wfiledele=wpath+wnames[i,1]
			erase &wfiledele

		next

	endif
endif

wait clear

return wdeleted

*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
proce flock77	&& si puede lockear el f77 lo toma en forma exclusiva
*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

if !flock('f77')
	if wsuper
		w_err1='Para entrar como SUPERVISOR, no debe haber ning๚n Usuario en el sistema'
		=advgrave(w_err1)
	else
		=errornet(076)
	endif

	=logout()
	=mquit()
else
	sele f77
	use &d0f77 alias f77 exclusive

	if neterr()

		use &d0f77 in 0 alias f77

		if wsuper
			w_err1='Para entrar como SUPERVISOR, no debe haber ning๚n Usuario en el sistema'
			=advgrave(w_err1)
		else
			=errornet(076)
		endif

		=logout()
		=mquit()
	endif

endif

return

*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
function chqsal		&& chequea salidas anormales y depura errores
*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

*** Graba salidas anormales en el archivo de errores ***

m.d77prog=''

=set_alia('f77')

go top

do while !eof()

	if rlock()

		if d77logi$'N' or d77stat$'C'

			m.d77prog=m.d77prog+' Empr:'+d77empr+' Term:'+d77term+' Tran:'+d77tran+' Logi:'+d77logi+' Stat:'+d77stat+' '+d77prog+chr(13)

			if !d77tran$'T'

				replace d77logi with ' ', d77stat with ' ', d77prog with ''

			endif

		endif

	endif

	unlock

	skip

enddo

=rest_alia()

if !used('SSF090')
	if mfile('ssf090.dbf')
		use ssf090 in 0 alias ssf090
	else
		select 0
		create dbf ssf090 (errdate d(8), errtime c(10), errdata m(10), errscreen m(10), snapshot m(10), listing m(10), usernotes m(10))
	endif
endif

if !empty(m.d77prog)

	=net_appe('ssf090')
	=set_alia('ssf090')

	replace errdate with date()
	replace errtime with time()
	replace listing with m.d77prog

	=rest_alia()

endif

*****************************************

*** Depuracion del archivo de errores ***

if reccount('ssf090')>50

	if flock('f77')
		sele f77
		use &d0f77 alias f77 exclusive

		if neterr()

			use &d0f77 in 0 alias f77

		else

			sele ssf090
			use ssf090 alias ssf090 exclusive
			go top
			delete next reccount()-40 for upper(left(errdata,13))!='ACTUALIZACION'
			pack
			use

			sele f77
			use &d0f77 alias f77

		endif
	endif

endif

******************************************

return

*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
proce trdate	&& el parametro es el nombre de la variable fecha (string)
*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
parameters a_fech


*if parameters()=0 or empty(&a_fech)
*	return
*endif

*if type(a_fech)='D'

*	if left(dtos(&a_fech),4) < '1980'
*		&a_fech=ctod(left(dtoc(&a_fech),6)+'20'+right(dtoc(&a_fech),2))
*	endif

*	show get &a_fech

*endif

*===> CODIGO NUEVO, PARA VALIDAR QUE LA FECHA SEA UNA FECHA Y NO CUALQUIER COSA
if parameters() = 0
	return
endif

if empty(&a_fech) or type(a_fech) <> "D"
		return .F.			
endif

if year(&a_fech) < 1980
		&a_fech	= ctod(substr(dtoc(&a_fech),1,6) + ltrim(str(year(&a_fech) + 100)))
endif

show get &a_fech

return

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function dispok
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para d_disp,d_mode

if parameters()=1 or type('d_mode')!='C'
	d_mode='G'
endif

priv d_retu,d_pudo,d_cant,d_dir

d_retu=.f.

if d_mode='G'

	d_pudo=f_create(d_disp+'\CHK.')

	if d_pudo>0
		=f_close(d_pudo)
		d_retu=.t.
		dele file d_disp+'\CHK.'
	else
		d_retu=.f.
	endif

else

	=seterr('OFF')
	d_cant=0
	d_cant=adir(d_dir,d_disp+'\*.*','D')
	=seterr('ON')
	if d_cant=0
		d_retu=.f.
	else
		d_retu=.t.
	endif

endif

return (d_retu)

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function mfile
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para m_file
priv like m_*

m_retu=.f.
m_file=alltrim(upper(m_file))

if right(m_file,4)=='\NUL'
	m_dire=subs(m_file,1,len(m_file)-4)
	m_retu=dispok(m_dire)
else
	=seterr('OFF')
	m_retu=file(m_file)
	=seterr('ON')
endif
return m_retu


*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function seterr
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para s_mode

do case
	case s_mode='OFF'
		on error do erroralt
	case s_mode='ON'
		on error do ssp090 with error(), lineno(), program()
	other
		wait wind 'SetErr mal Invocada'
		cancel
endcase
return ''

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proc erroralt
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
return

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proc renombrar		&& renombra archivos que cumplan con el primer parametro
&& y el segundo son las primeras letras para renombrar
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters a_old, a_wilc

a_path = justpath(a_old)

do case

	case len(a_path) = 0

		a_path = sys(5)+curdir()

	case len(a_path) > 3

		a_path= a_path+'\'

endcase

if adir(a_files,a_old) > 0

	for a_i = 1 to alen(a_files,1)

		a_old = a_path+a_files[a_i,1]	&& tomo el nombre del archivo

		a_new = a_path+a_wilc+right( a_files[a_i,1], ( len(a_files[a_i,1]) - len(a_wilc) ) )

		rename &a_old to &a_new

	next

endif

return

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
procedure volume
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameter drive
string = drive + ':'
dimension temparray(1)
=adir(temparray,(string),'V')
return temparray(1)

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
Procedure Expira	&& Tiempo de expiracion del sistema
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
* los dias impares de cada mes a partir de los 6 meses
if date()-p_date>180 and mod(day(date()),2)=1
	on key label esc do nada
	if set('develop')='OFF'
		if lresp
			do sss093.spr
		else
			do sss091.spr
		endif
	endif
	on key label esc
endif

return

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
Procedure Expiremp	&& Error transaccional en empresa debido al Tiempo de expiracion del sistema
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters wspre

private w_retu

w_retu=.f.

* A partir de los 33 meses, cuando se graba da 1 error transaccional por mes

if date()-p_date>1000 and set('DEVELOP')='OFF'

	wfmem  = wspre+'.mem'

	if !mfile(wfmem)  &&  no existe XX.mem
		=salir('Instalaci๓n Incompleta')
	endif

	rest from (wfmem) additive

	*retraso 1 mes el proximo error transaccional
	p_date=p_date+31
	z_da=encript('ศ{Û[‘’x“C”๏#%^~'+wspre+repl('',asc(wspre))+dtos(p_date)+;
	'ศ{Û[‘’x“C”๏#%^~',3)

	save to &wfmem all like z_*
	
	w_retu=.t.
	
endif

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function tomuserc
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
priv t_cant,t_retu

if p_par1!='01' and p_par1!='NO'	&& Cuando el parametro no es 01 ni en blanco
   if mfile(dimaqi()+d0fise)
      * Y existe el archivo de control lo borra
      dele file (dimaqi()+d0fise)
   endif
endif

if !mfile(dimaqi()+d0fise)
   * Si no existe el archivo de control borro el directorio 01 siempre
	=RmDir('C:\MEMOSYS\'+d0pref+'\01')
endif

* Tomo el Nro de USUARIO desde el C:
t_cant=adir(wcaus,'C:\MEMOSYS\'+d0pref+'\??.','D')
if t_cant=<2
	* Si no existe MEMOSYS en C
	* Genero Nuevo numero de Usuario en Base a Directorio USERS
	*
	t_cant=adir(wcaus,'\'+d0pref+'\USERS\??.','D')
	if t_cant=<2
		=advgrave('No existe Directorio USERS. Comuniquese con su proveedor')
		=mquit()
	else
		=asort(wcaus)
		for t_cant=1 to alen(wcaus,1)-1
			if t_cant<val(wcaus[t_cant+1,1])
				exit
			endif
		endfor
		t_retu=strcero(str(val(wcaus[t_cant,1])+1,2))

		if t_retu='99'
			=advgrave('Excede tope de Usuarios')
			=mquit()
		endif
	endif
else
	=asort(wcaus)
	t_retu=left(wcaus[t_cant,1],2)
endif

if p_par1<>'NO'  && Cualquier valor que se fuerce desde param lo toma
	t_retu=p_par1
endif

do case
	case len(t_retu)=0
		t_retu='00'

	case len(t_retu)=1
		t_retu=strcero(' '+t_retu)

	otherwise
		t_retu=strcero(left(t_retu,2))

endcase

return t_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function dimaqi
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
private all like w_*


w_dire=getenv('windir')

if empty(w_dire)
   * Supone que es NT
   w_os=UPPER(getenv('OS'))
   if w_os==('WINDOWS_NT')
		do case
			case dispOk('c:\winnt')
				w_dire='C:\WINNT'
			case dispOk('c:\windows')
				w_dire='C:\WINDOWS'
			otherwise
				w_dire=''
		endcase
   else
		do case
			case dispOk('c:\windows')
				w_dire='C:\WINDOWS'
			case dispOk('c:\winnt')
				w_dire='C:\WINNT'
			otherwise
				w_dire=''
		endcase
   endif
endif

if !empty(w_dire)
   w_dire=w_dire+'\'
endif   

return w_dire

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function f_create
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_par1, f_par2

private w_para, w_retu

w_para=parameters()

w_retu=0

=seterr('OFF')

if w_para=1

	w_retu=fcreate(f_par1)

else

	w_retu=fcreate(f_par1, f_par2)

endif

=seterr('ON')

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function f_open
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_par1, f_par2

private w_para, w_retu

w_para=parameters()

w_retu=0

=seterr('OFF')

if w_para=1

	w_retu=fopen(f_par1)

else

	w_retu=fopen(f_par1, f_par2)

endif

=seterr('ON')

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function f_write
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_par1, f_par2, f_par3

private w_para, w_retu

w_para=parameters()

w_retu=0

=seterr('OFF')

do case

	case w_para=2

		w_retu=fwrite(f_par1, f_par2)

	otherwise

		w_retu=fwrite(f_par1, f_par2, f_par3)

endcase

=seterr('ON')

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function f_seek
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_par1, f_par2, f_par3

private w_para, w_retu

w_para=parameters()

w_retu=-1

=seterr('OFF')

do case

	case w_para=2

		w_retu=fseek(f_par1, f_par2)

	otherwise

		w_retu=fseek(f_par1, f_par2, f_par3)

endcase

=seterr('ON')

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function f_close
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_par1

private w_para, w_retu

w_para=parameters()

private w_retu

w_retu=.f.

=seterr('OFF')

w_retu=fclose(f_par1)

=seterr('ON')

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function f_eof
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_par1

private w_para, w_retu

w_para=parameters()

w_retu=.f.

=seterr('OFF')

w_retu=feof(f_par1)

=seterr('ON')

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function f_flush
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_par1

private w_para, w_retu

w_para=parameters()

w_retu=.f.

=seterr('OFF')

w_retu=fflush(f_par1)

=seterr('ON')

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function f_gets
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_par1, f_par2

private w_para, w_retu

w_para=parameters()

w_retu=''

=seterr('OFF')

if w_para=1

	w_retu=fgets(f_par1)

else

	w_retu=fgets(f_par1, f_par2)

endif

=seterr('ON')

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function f_read
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_par1, f_par2

private w_para, w_retu

w_para=parameters()

w_retu=''

=seterr('OFF')

w_retu=fread(f_par1, f_par2)

=seterr('ON')

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function f_chsize
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_par1, f_par2

private w_para, w_retu

w_para=parameters()

w_retu=-1

=seterr('OFF')

w_retu=fchsize(f_par1, f_par2)

=seterr('ON')

return w_retu

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function f_puts
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_par1, f_par2, f_par3

private w_para, w_retu

w_para=parameters()

w_retu=-1

=seterr('OFF')

do case

	case w_para=2

		w_retu=fputs(f_par1, f_par2)

	otherwise

		w_retu=fputs(f_par1, f_par2, f_par3)

endcase

=seterr('ON')

return w_retu

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
Procedure ncodpage	&& se utiliza para no transformar los campos con codepage de la base abierta
					&& cuando se hace un append from
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
private w_fields, w_cantf, w_i, w_nf

w_cantf=afields(w_fields)

w_nf=''

for w_i=1 to w_cantf
	
	if w_fields[w_i, 2]$'CM'
	
		w_nf=iif(empty(w_nf), w_fields[w_i,1], w_nf+', '+w_fields[w_i,1])

	endif

endfor

if empty(w_nf)
	set nocptrans to
else
	set nocptrans to &w_nf
endif

return

* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
Procedure scodpage	&& corrige el code page de cada campo descripcion de la base abierta
* อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_dosawin	&& .t. -> 850 a 1252 ; .f. -> 1252 a 850

private w_fields, w_cantf, w_i, w_campo

w_cantf=afields(w_fields)

w_campo=''

for w_i=1 to w_cantf
	
	if w_fields[w_i, 2]$'CM'
	
		w_campo=w_fields[w_i,1]
		if w_dosawin
			replace &w_campo with cpconvert(850,1252,&w_campo) all
		else
			replace &w_campo with cpconvert(1252,850,&w_campo) all
		endif

	endif

endfor

return

*)อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PROC mtype	&& el parametro es el nombre de la variable (string)
*)อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters a_var
private w_retu,wtype
w_retu=''

if parameters()=0
	return(w_retu)
endif

=seterr('OFF')
wType=&a_var
w_retu=type('wtype')
=seterr('ON')

if empty(w_retu)	&& no pudo evaluar el type()
	w_retu='U'
endif

return(w_retu)


*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
proce rep_form	&& ejecuta el report form
*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
parameters w_prev	&& .t. vista previa exclusiva si la eligen
private w_npdf,w_ruta,w_temp,w_i	&& R.11 pa

if !empty(p_repfor)
	p_repfor=' for '+p_repfor
endif
if !empty(p_repwhile) and at('while',p_repwhile)=0
	p_repwhile=' while '+p_repwhile+' and p_cancela'
else
	p_repwhile=' while p_cancela'
endif

if 'preview'$p_repclaus	or '*'$p_repout
	do preview
else
	p_alia=alias()
	&& R.12b pa
	if mfile('report\'+p_report+'.frx') and !('report\'$lower(p_report))
		p_report='report\'+p_report
	endif
	&& R.12e pa
	use &p_report..frx in 0 alias frpt
	sele frpt
	copy to &d0f99.z.frx
	use in frpt
	use &d0f99.z.frx in 0 alias frpt
	p_unme=1	&& unidad de medida
	p_fact=1	&& factor mult. de un.medida
	p_point=set('POINT')
	set point to '.'
	p_lmarep=round(frpt.hpos/10000,3)	&& margen izquierdo
	p_reso=set('RESO')
	set reso off
	p_resou=alltr(sys(2005))
	use &p_resou in 0 alias freso exclu
	sele freso
	locate for type='PREFW' and id='LMARGREP' and name=p_report
	if found('freso')
		scatter memvar memo
		p_lmarep=round(val(alltrim(m.data))/10000,3)
	else
		scatter memvar memo blank
	endif	
	if p_lmargrep=1		&& margen izquierdo
		sele frpt
		do lmargrep.spr	&& setea margen izquierdo del report
		m.data=str(p_lmarep/iif(p_unme=1,1,25.4)*10000,9,3)
		sele freso
		if empty(m.type) and empty(m.id) and empty(m.name)	&& nuevo registro
			append blank
		endif
		m.type='PREFW'
		m.id='LMARGREP'
		m.name=p_report
		m.readonly=.t.
		m.chkval=0
		m.updated=date()
		gather memvar memo
	endif
	use in freso
	set resource &p_reso
	p_lmarep=p_lmarep/iif(p_unme=1,1,25.4)*10000
	sele frpt
	repla hpos with p_lmarep	&& actualizo el margen izquierdo
	use in frpt
	set point to (p_point)
	sele(p_alia)
	if p_preview=1	&& vista previa
		report form &d0f99.z.frx &p_repfor &p_repfor2 &p_repwhile noconsole preview
	endif
	if iif(p_preview=1, !w_prev, .t.)	&& si saque vista previa y no es exclusiva --> imprimo
		&& R.11b pa
		if p_mail=1
			keyboard '{F9}' clear
*			=delefile(curdir()+'USERS\'+p_netuser+'\' ,'*.PDF')	&& R.18 Mariano
			=delefile('C:\MEMOSYS\'+d0pref+'\'+p_netuser+'\','*.PDF')	&& R.18 Mariano
			w_npdf=dtos(date())+'_'+allt(w_title)
			w_npdf=strtran(w_npdf,' ','_')
			w_npdf=strtran(w_npdf,'.','-')
			*w_ruta='USERS\'+p_netuser+'\'	&& R.17 pa
			w_ruta='C:\MEMOSYS\'+d0pref+'\'+p_netuser+'\'	&& R.17 pa
			w_temp=w_ruta+'OK.dbf'
			if file(w_temp)
				dele file &w_temp
			endif
			&& R.15b pa
			=ini_pdf(w_ruta)
			for w_i=1 to 100
				=inkey(3)
				if !empty(adir(w_dire,w_ruta+'OK.DBF'))
					exit
				endif
			endfor
			&& R.15e pa
			=set_pdf(w_ruta,w_npdf,.t.)
		endif
		&& R.11e pa

		report form &d0f99.z.frx &p_repfor &p_repfor2 &p_repwhile &p_repclaus

		&& R.11b pa
		if p_mail=1
			set step on
			acti wind debug
			for w_i=1 to 100
				wait wind 'Generando PDF...' nowait
				=inkey(3)
				if !empty(adir(w_dire,w_ruta+'*.PDF'))
					exit
				endif
			endfor
			=rest_pdf(w_ruta)
		endif
		&& R.11e pa
	endif
	
endif

return

*)อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
FUNC linediv	&& divide texto en dos o mas lineas
*)อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
** w_texto -> texto a dividir
**   linea -> Nro. de linea de la division
**   largo -> longitud de las lineas
*************************************************************************
** ej: linediv('Esto es una prueba de texto',1,15) -> 'Esto es una'
**	   linediv('Esto es una prueba de texto',2,15) -> 'prueba de texto'
*************************************************************************
parameters w_texto,linea,largo

if parameters()=0
	w_texto=''
	largo=80
endif
if parameters()<=1
	linea=1
endif
if parameters()<=2
	largo=80
endif

w_texto=alltrim(w_texto)

private w_linea,w_desin,w_desde,w_hasta,w_sale,w_i

if len(w_texto)>0	&& viene algo para dividir

	w_desin=1
	w_desde=1
	w_sale=.t.

	** voy formando las lineas hasta encontrar la que me piden
	for w_i=1 to linea
		w_desin=w_desde
		w_desde=rat(' ',substr(w_texto, w_desin, largo))+ w_desin
		if len(w_texto)-w_desin<largo
			if w_i<linea
				w_sale=.f.
			endif
			exit
		endif
	endfor
	if w_sale and linea>0
		w_linea=alltrim(substr(w_texto,w_desin,largo+1))
		w_hasta=iif(len(w_linea)>largo, rat(' ', subs(w_linea,1,largo))-1,len(w_linea))

		w_linea=substr(w_linea, 1, w_hasta)
	else
		w_linea=''
	endif
else
	w_linea=''
endif

return (w_linea)

*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
proce winword	&& ejecuta el winword con .doc
*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
parameter w_file
private w_ejec, w_word, w_dire, w_defa
	do case
		case mfile('c:\archiv~1\micros~1\office\winword.exe')
			run /n c:\archiv~1\micros~1\office\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~2\office\winword.exe')
			run /n c:\archiv~1\micros~2\office\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~3\office\winword.exe')
			run /n c:\archiv~1\micros~3\office\winword.exe /t &w_file
&& R.07b Ra๚l
		case mfile('c:\archiv~1\micros~4\office\winword.exe')
			run /n c:\archiv~1\micros~4\office\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~1\office10\winword.exe')
			run /n c:\archiv~1\micros~1\office10\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~2\office10\winword.exe')
			run /n c:\archiv~1\micros~2\office10\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~3\office10\winword.exe')
			run /n c:\archiv~1\micros~3\office10\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~4\office10\winword.exe')
			run /n c:\archiv~1\micros~4\office10\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~1\office11\winword.exe')
			run /n c:\archiv~1\micros~1\office11\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~2\office11\winword.exe')
			run /n c:\archiv~1\micros~2\office11\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~3\office11\winword.exe')
			run /n c:\archiv~1\micros~3\office11\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~4\office11\winword.exe')
			run /n c:\archiv~1\micros~4\office11\winword.exe /t &w_file
&& R.07e Ra๚l
&& R.10b Ra๚l
		case mfile('c:\archiv~1\micros~1\office12\winword.exe')
			run /n c:\archiv~1\micros~1\office12\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~2\office12\winword.exe')
			run /n c:\archiv~1\micros~2\office12\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~3\office12\winword.exe')
			run /n c:\archiv~1\micros~3\office12\winword.exe /t &w_file
		case mfile('c:\archiv~1\micros~4\office12\winword.exe')
			run /n c:\archiv~1\micros~4\office12\winword.exe /t &w_file
&& R.10e Ra๚l
		otherwise
			w_reso=sys(2005)
			set resource off
			use &w_reso in 0 alias reso
			sele reso
			locate for type='PREFW' and id='WINWORD' and name='winword.exe'
			w_ejec=.f.
			if found()
				scatter memvar field data memo
				w_word=alltrim(m.data)
				if mfile(w_word)
					use
					set resource on
					if type('w_alias')='C' and used(w_alias)
						sele(w_alias)
					endif
					run /n &w_word. /t &w_file
					w_ejec=.t.
				endif
			endif
			if !w_ejec
				w_defa=set('default')
				w_dire=curdir()
				set defa to c:\
				=seterr('OFF')
				if len(locfile('winword','exe','ฟD๓nde estแ WinWord?'))>0
					w_word=set('path')+'\winword.exe'
					set path to
					set defa to &w_defa.&w_dire
					if mfile(w_word)
						locate for type='PREFW' and id='WINWORD' and name='winword.exe'
						if !found()
							append blank
						endif
						m.type='PREFW'
						m.id='WINWORD'
						m.name='winword.exe'
						m.readonly=.f.
						m.data=w_word
						m.updated=date()
						gather memvar memo
						use
						set resource on
						if type('w_alias')='C' and used(w_alias)
							sele(w_alias)
						endif
																
						run /n &w_word. /t &w_file
					else
						use
						set resource on
						if type('w_alias')='C' and used(w_alias)
							sele(w_alias)
						endif
						=advgrave('No se encontr๓ el WinWord.exe. No se puede ver '+w_file)
					endif
				else
					use
					set resource on
					if type('w_alias')='C' and used(w_alias)
						sele(w_alias)
					endif
					=advgrave('No se encontr๓ el WinWord.exe. No se puede ver '+w_file)
				endif
				=seterr('ON')
				set defa to &w_defa
			endif
	endcase
return

*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
proce winexcel	&& ejecuta el excel con .xls
*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
parameter w_file
private w_ejec, w_word, w_dire, w_defa
	do case
		case mfile('c:\archiv~1\micros~1\office\excel.exe')
			run /n c:\archiv~1\micros~1\office\excel.exe /t &w_file
		case mfile('c:\archiv~1\micros~2\office\excel.exe')
			run /n c:\archiv~1\micros~2\office\excel.exe /t &w_file
		case mfile('c:\archiv~1\micros~3\office\excel.exe')
			run /n c:\archiv~1\micros~3\office\excel.exe /t &w_file
		otherwise
			w_reso=sys(2005)
			set resource off
			use &w_reso in 0 alias reso
			sele reso
			locate for type='PREFW' and id='EXCEL' and name='excel.exe'
			w_ejec=.f.
			if found()
				scatter memvar field data memo
				w_word=alltrim(m.data)
				if mfile(w_word)
					use
					set resource on
					if type('w_alias')='C' and used(w_alias)
						sele(w_alias)
					endif
					run /n &w_word. /t &w_file
					w_ejec=.t.
				endif
			endif
			if !w_ejec
				w_defa=set('default')
				w_dire=curdir()
				set defa to c:\
				=seterr('OFF')
				if len(locfile('excel','exe','ฟD๓nde estแ Excel?'))>0
					w_word=set('path')+'\excel.exe'
					set path to
					set defa to &w_defa.&w_dire
					if mfile(w_word)
						locate for type='PREFW' and id='EXCEL' and name='excel.exe'
						if !found()
							append blank
						endif
						m.type='PREFW'
						m.id='EXCEL'
						m.name='excel.exe'
						m.readonly=.f.
						m.data=w_word
						m.updated=date()
						gather memvar memo
						use
						set resource on
						if type('w_alias')='C' and used(w_alias)
							sele(w_alias)
						endif
																
						run /n &w_word. /t &w_file
					else
						use
						set resource on
						if type('w_alias')='C' and used(w_alias)
							sele(w_alias)
						endif
						=advgrave('No se encontr๓ el Excel.exe. No se puede ver '+w_file)
					endif
				else
					use
					set resource on
					if type('w_alias')='C' and used(w_alias)
						sele(w_alias)
					endif
					=advgrave('No se encontr๓ el Excel.exe. No se puede ver '+w_file)
				endif
				=seterr('ON')
				set defa to &w_defa
			endif
	endcase
return

*)อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
FUNC MEMOLINE
*)-----------------------------------------------------------------------------
*)
*)
*)อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PARAMETERS pmemo,ptam,pline

PRIVATE w_oldmwidth,w_retu
w_oldmwidth=SET('MEMOWIDTH')

set memowidth to ptam
w_retu=MLINE(pmemo,pline)
set memowidth to (w_oldmwidth)

return(w_retu)

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function copyfile
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
para wpato, wpatd, wilc

priv wcant,wronly,i,wfilecopy,wcopiado

wcopiado=.t.

if !right(wpato,1)='\' 	&& el directorio debe terminar con \
	wpato=wpato+'\'
endif

if !right(wpatd,1)='\' 	&& el directorio debe terminar con \
	wpatd=wpatd+'\'
endif

** controla files en el path destino **

wcant=adir(wnames,wpatd+wilc)

if wcant>0

	wronly=0

	for i = 1 to wcant

		if 'R'$wnames[i,5]
			wronly=wronly+1
		endif

	next

	if wronly>0
		wait 'Hay '+ltrim(str(wronly))+' archivos ReadOnly en '+wpatd+'!' wind
		wcopiado=.f.
	endif

endif

** copia de files de path origen a path destino **

wcant=adir(wnames,wpato+wilc)

if wcant>0 and wcopiado

	for i = 1 to wcant

		wfilecopy=wnames[i,1]
		if wfilecopy!='GVF077.DBF'
			copy file &wpato.&wfilecopy. to &wpatd.&wfilecopy
		endif

	next

endif

*wait clear

return wcopiado

*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
function fx	 && administra funciones que no estan en principal o libreria
*-F อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_func, f_prog

private f_retu,f_pran,f_pcou

f_pcou=parameters()

f_pran=set('PROCEDURE')

do case
	case (f_pcou=1 and mfile(sys(2023)+'\'+'memosoft.fxp'))
		f_prog=sys(2023)+'\'+'memosoft'
		set procedure to &f_prog.
	case f_pcou=2
		set procedure to &f_prog.
endcase

f_retu=&f_func

set procedure to &f_pran.

return(f_retu)

*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proce actpegar	&& activa pegar del clipboard a donde estoy
*-p ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
private w_vari,w_vread

w_vari=varread()
w_vread='m.'+w_vari

&w_vread = &w_vread + _cliptext

show get &w_vread

return

*)อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
proc gendatos
*)อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_sist	&& codigo sistema Admin.Interna

private exe,w_drive,w_netuser,t_cant,wdius,w_driv

	do while !mfile(d0diga+'\ga\gap000.exe') and !mfile(d0diga+'\ga\gap000.app') and lastkey()!=p_esc
		if !empty(d0diga)
			w_driv=d0diga+'\'
		else
			w_driv=sys(5)+'\'
		endif
		w_driv=upper(elijedisp('NO DISPONIBLE EL GENERADOR DE DATOS EN '+w_driv))
		if !mfile(w_driv+'\ga\gap000.exe') and !mfile(w_driv+'\ga\gap000.app')
			if advgrave('NO DISPONIBLE EL GENERADOR DE DATOS EN '+w_driv+'\','',.t.)!='Aceptar'
				keyboard '{Esc}'	&& Obligo a salir
				=inkey()
			endif
		else
			d0diga=w_driv
			exit
		endif
	enddo
	
	if mfile(d0diga+'\ga\gap000.exe') or ( mfile(d0diga+'\ga\gap000.app') and mfile('c:\fpw26\foxprow.exe') )
	
		w_drive=sys(5)
		
		set default to &d0diga.\GA

		if mfile(d0diga+'\ga\gap000.exe')

			t_cant=adir(wcaus,'C:\MEMOSYS\GA\??.','D')
			if t_cant>2
				=asort(wcaus)
				t_retu=left(wcaus[t_cant,1],2)
			else 
				t_retu='NO'
			endif
		
			exe='gap000 '+t_retu+' '+w_sist+' '+d0coem+' '+w_drive+' -T -CCONFIG.FPW'
		else		
			exe='c:\fpw26\foxprow gap000.app '+'NO '+w_sist+' '+d0coem+' '+w_drive+' -T -CCONFIG.FPW'
		endif

		run /N &exe

		=inkey(2)	&& demoro 2 segundos para dar tiempo al generador de datos a tomar el foxuser

		keyboard '{Esc}'
		=inkey()

		w_netuser='01'	&& por defecto
		t_cant=adir(wdius,'C:\MEMOSYS\GA\??','D')
		if t_cant>2
			=asort(wdius)
			w_netuser=alltrim(wdius[3,1])	&& en el tercer registro esta el nro.de usuario en ga
		endif

		c_reus=d0diga+'\GA\USERS\'+ w_netuser + '\FOXUSER.DBF' && RESOURSE De usuario del generador
			
		do while .t.

			fieldvec[1] = 'FOX_USER'

			use &c_reus in 0 alias fox_user

			if .not. neterr()
				exit
	  		endif

			if lastkey()=p_enter
				exit
			endif
		enddo
		fieldvec=''
		if used('fox_user')
			use in fox_user
		endif
		
		set default to &w_drive.\&d0pref.	&& directorio de sistema
		
		wait clear
	else
		if lresp
			=advsuave('Consulte con el Proveedor, para adquirir este m๓dulo')
		else		
			=advsuave('Consulte con MemoSoft, para adquirir este m๓dulo')
		endif
	endif
return

********************************************************************************
func stag
********************************************************************************
** Sintaxis....: = stag (varcar1, <varcar2>)
**                        tag   ,   alias
** Fecha.......: Agosto 2005
**
** Servicio....: Busca si existe el indice tag en el alias, para saber si lo indexo
**
**					....	
parameters a,b
private c,d
=set_alia(b)
d=.f.
for c=1 to 20
	if empty(tag(c))
		exit
	else
		if tag(c)=upper(a)	&& encontro el tag
			d=.t.
			exit
		endif
	endif
endfor
=rest_alia()
return(d)

*)อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
func f_cmparc
* busca si existe un archivo, si tiene datos, si el archivo fue copiado si 
* quiero comparar el archivo destino con el archivo origen.
* devuelve .T. o .F.
* parametros:
* 1- el archivo y el path completo del archivo destino	ej:'c:\nuevo\pepenew.txt'
* 2- el archivo origen con el path completo				ej:'c:\viejo\pepeold.txt'
*    si es ' ' no compara los archivos
* 3- si quiero comparar los nombres de los archivos .T. sino .F.
*)อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters f_arch, f_olddir, f_cmpnom
if type('f_olddir')= 'L'
	f_olddir = ' '
endif
private w_valret, w_arch, w_oldarc, i, cmp_arch, f_ext, f_dir
w_valret=.F.
i=1
f_dir=allt(justpath(f_arch))
f_ext=f_dir+'\*.'+allt(justext(f_arch))
dimension w_arch(1), w_oldarc(1)
if file(f_olddir)
	=adir(w_oldarc, f_olddir)
endif
if file(f_arch)
	=adir(w_arch, f_ext)
endif
if !empty(w_arch)
	for i = 1 to alen(w_arch)/5
		if upper(allt(f_dir))+'\'+allt(w_arch[i,1])=upper(f_arch)
			if w_arch[i,2]!=0
				if !empty(allt(f_olddir)) and !empty(w_oldarc)
					if f_cmpnom
						cmp_arch = 'w_oldarc[1,1] = w_arch[i,1] and w_oldarc[1,2] = w_arch[i,2] and w_oldarc[1,3] = w_arch[i,3] and w_oldarc[1,4] = w_arch[i,4] and w_oldarc[1,5] = w_arch[i,5]'
					else
						cmp_arch = 'w_oldarc[1,2] = w_arch[i,2] and w_oldarc[1,3] = w_arch[i,3] and w_oldarc[1,4] = w_arch[i,4] and w_oldarc[1,5] = w_arch[i,5]'
					endif	
					if &cmp_arch
						w_valret = .T.				
					endif
				else
					if empty(allt(f_olddir))
						w_valret = .T.
					else
						w_valret = .F.
					endif
				endif
			else
				wait wind ' Archivo Vacio, VERIFIQUE .... presione una tecla para continuar'
			endif
			exit
		endif
	endfor
endif

return (w_valret)

*==================================================================
procedure repdest1

*===> R12
PARAMETERS	nombre


private w_arch,w_nomb,w_exte

p_cancela=.t.
p_alia=alias()

p_sepa=set('separator')
p_poin=set('point')
*p_memo=set('memowidth')

set separator to '.'
set point to ','
*set memowidth to 200
set pdsetup to

set status bar off
set safety on

p_repfile=''
p_repfields=''
p_repfor=''
p_repfor2=''
p_repwhile=''

*===> R12
IF EMPTY(nombre)
				w_nomb='nombre'
ELSE
	w_nomb = nombre				
ENDIF

w_exte	= left(p_reptype, 3)

IF w_exte $ "SDF.ASC"
			w_exte	= "TXT"
ENDIF			

w_nomb	= w_nomb + "." + w_exte

do case
	case p_repout="Pantalla"

		p_repclaus='noconsole preview'

	case p_repout="Impresora"

		if p_mail=0	&& R.11 pa
		p_repclaus='noconsole to printer prompt'
		&& R.11b pa
		else
			p_repclaus='noconsole to printer'
		endif
		&& R.11e pa

	case p_repout="Archivo"

		w_defd= sys(5)+sys(2003)

		w_arch=putfile("Archivo a grabar?", w_nomb, w_exte)

		if !empty(w_arch) and upper(right(w_arch,3))=w_exte

			**			p_repclaus='noconsole to file &w_arch prompt'

			do case

				case left(p_reptype, 3) ='DBF'
					p_repfile=w_arch

				case left(p_reptype, 3) ='TXT'
					p_repfile=w_arch

				case left(p_reptype, 3) ='SDF'
					p_repfile=w_arch+' type SDF'

				case left(p_reptype, 11)='ASCII con ,'
					p_repfile=w_arch+' delimited '

				case left(p_reptype, 11)='ASCII sin ,'
					p_repfile=w_arch+' delimited with blank '

				otherwise
					p_repfile=w_arch+' type '+left(w_exte,3)

			endcase

		else

			p_repfile=''

		endif

		if p_reptype='TXT   Pantalla' and !empty(p_repfile)
			p_repclaus='noconsole preview'
		else
			p_repclaus=''
		endif

		set default to &w_defd

	otherwise
		** impresion en modo DOS **
	
*		if 	p_reptype2<>'Pantalla' and p_reptype2<>'Archivo'  
*			if advgrave('Verifique que la impresora este encendida. En caso contrario ocurrirแ un error que abortarแ el programa debiendo reiniciar la PC', 'IMPRESION en modo DOS',.t.)='Cancelar'
*				return .f.
*			endif
*		endif		
		
		_genpd='genpd.app'
		set pdsetup to p_repout

		p_repclaus='noconsole to printer'
		if empty(p_report)	&& no hay report
			do case
			case p_reptype2='Pantalla' 
				set printer to file &d0f99.y.txt
			case p_reptype2='Archivo' 
				set printer to file &d0f99.y.txt
			otherwise
*				set printer to &p_reptype2.
*				Mando a un archivo y luego imprimo el archivo con !type >&p_reptype2.
				set printer to file &d0f99.y.txt
			endcase
			set device to printer
			set printer on
			_pdparms[41]=0
			set console off
		endif

endcase

if .not. empty(p_alia)
	sele (p_alia)
endif

p_escape=on('escape')
on escape do cancela

wait window ' Procesando, <Esc> Interrumpe... ' nowait

=skipbar('Registro','ALL',.t.)

set safety off
set escape on

return

*======================================================================
PROCEDURE checkver1				&& PARA IW - CG - SJ - GW

wCont	= .T.

*===>  NF_VERS = nro. de versi๓n guardada LARGO = 8 !!!!!!!!!!!!!
if (NF_VERS<>wVerxExe .or. mfile('habi.tst') ) .and. set('DEVELOP')='OFF'
   if !TestClav(d0pref)                           &&     Verifica
      return !wCont                               &&
   endif                                          &&     Version
endif                                             &&

wVerxExe	= wVersExe + STRTRAN(wVersRel,' ','') + SUBSTR(w_ver,19,2)

wvercant	= 0
wversdbf	= ""
wversant	= ""

*clear 	&& R.09 Mariano

wVerCant = ADIR(VerFiles,'\' + d0pref + '\ver?????.*')

IF wvercant = 0
	wVerCant = ADIR(VerFiles,'\' + d0pref + '\V???????.*')
	&& R.08b Mariano
	do while ascan(verfiles,'VFP9')!=0
		=adel(verfiles,int(ascan(verfiles,'VFP9')/5)+1)
		wvercant=wvercant - 1
		if wvercant>0
			dimension verfiles(wvercant,5)
		endif
	enddo
	&& R.08e Mariano
ENDIF

w_sort = ASORT(VerFiles)

w_file = Verfiles(1)

IF w_sort = 1	AND wvercant > 0
			IF SUBSTR(verfiles(1),1,3) = "VER"
					   wVersDbf = RIGHT(VerFiles[1,1],3) + SUBS(VerFiles[1,1],4,4) + "  " 
			ELSE
			   wVersDbf = RIGHT(VerFiles[1,1],3) + SUBS(VerFiles[1,1],4,4) + SUBS(VerFiles[1,1],2,2) 
			ENDIF
ELSE
   if mfile('inicial.in')
      * Instalacion Inicial  
      * Crea el VER que corresponde a este EXE

      w_file='\' + d0pref + '\V' + SUBSTR(wVerxExe,8,2) + SUBSTR(wVerxExe,4,4) + '0.' + wVersExe 

      w_hand=f_create(w_file)
         
      if w_hand > 0
*					=f_write(w_hand,dtoc(date()) + ' ' + time() + " "+right(w_ver,1))	&& ultimo digito w_ver, viene con A o blanco				&& R.02 Ra๚l
					=f_write(w_hand,dtoc(date()) + ' ' + time() + " " + IIF(w_rel = 'A', 'A', ' '))				&& R.02 Ra๚l
					=f_close(w_hand)
      endif

	  wVerCant = ADIR(VerFiles,'\' + d0pref + '\V???????.*')
	  && R.08b Mariano
	  do while ascan(verfiles,'VFP9')!=0
		=adel(verfiles,int(ascan(verfiles,'VFP9')/5)+1)
		wvercant=wvercant - 1
		if wvercant>0
			dimension verfiles(wvercant,5)
		endif
	  enddo
	  && R.08e Mariano

      wVersDbf = wVerxExe

      dele file inicial.in

      if w0mop=='D'
         w_err2=''
         w_err3='Usted estแ operando en modalidad demostraci๓n'
         w_err4=''
         w_err5='Para acceder a todas las prestaciones deberแ habilitarlo, a trav้s del UTIL'
      
        =AdvSuave(w_err1+chr(13)+w_err2+chr(13)+w_err3+chr(13)+w_err4+chr(13)+w_err5,'')
      endif  

   else
      * Han borrado archivo VER??, se fuerza actualizaci๓n
      	wVersDbf='000'+'00000'
	  	w_file = "V0000000.000"
		w_hand=f_create(w_file)
        if w_hand > 0
				=f_write(w_hand,dtoc(date()) + ' ' + time() + "  ")
				=f_close(w_hand)
		ELSE
			if lresp
				=advgrave("ERROR : NO EXISTE VERSION"+CHR(13)+CHR(13)+"COMUNICARSE CON EL PROVEEDOR")
			else
				=advgrave("ERROR : NO EXISTE VERSION"+CHR(13)+CHR(13)+"COMUNICARSE CON MEMOSOFT")
			endif
			RETURN .F.
		endif
   endif   
ENDIF

* EMPRESAS SIN ACTUALIZAR. Control Empresa por Empresa
* ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

wEmSinAct=0

f_acce=1
do while .t.
	
    use &n0femp in 0 alias f10
    
    if !neterr()
        exit
	else
		if f_acce>=3	&& tres intentos
			=mquit()
		endif
		f_acce=f_acce+1
    endif
    
enddo

if type('f10.p0VeDa')='C'
*if type(w_archempr + ".p0veda")	=	'C'

   do while !eof('f10')

*      if f10->p0VeEs+f10->p0VeDa <> wVersExe+wVersExe			&& R.06 Ra๚l
      if f10->p0VeEs+f10->p0VeDa < wVersExe+wVersExe			&& R.06 Ra๚l
         wEmSinAct=wEmSinAct+1
      endif
      skip in f10
   enddo
   if wEmSinAct>0
   
   	   if wemsinact=1
	       w_err1='ATENCION!! : FUE ENCONTRADA UNA EMPRESA DESACTUALIZADA'
	       =advsuave(w_err1)
	   else
	       w_err1='ATENCION!! : FUERON ENCONTRADAS '+ltrim(str(wEmSinAct))+' EMPRESAS DESACTUALIZADAS'
	       =advgrave(w_err1)
	   endif

   endif
endif

sele f10
use

w_a	= " "


IF wvercant > 0		AND SUBSTR(w_file,1,3) <> "VER"
			w_hand	= FOPEN(w_file)
			IF w_hand < 0
						if lresp
							=advgrave("ERROR DE ACTUALIZACION"+CHR(13)+CHR(13)+"COMUNICARSE CON EL PROVEEDOR")
						else
							=advgrave("ERROR DE ACTUALIZACION"+CHR(13)+CHR(13)+"COMUNICARSE CON MEMOSOFT")
						endif
						RETURN .F.
			ENDIF
			w_b		= FREAD(w_hand,verfiles(1,2))
			w_a		= SUBSTR(w_b,verfiles(1,2),1)
			=FCLOSE(w_hand)
ENDIF

DO CASE
*	 			Versi๓n > Instalada
		CASE SUBSTR(wVerxExe,1,7) > SUBSTR(wVersDbf,1,7) 
				w_actver = .T.

*				Versi๓n y Release = Instalado, Versi๓n termina en "A" e instalado NO
		CASE wVerxExe = wVersDbf	AND	w_rel = "A"	AND w_rel <> w_a	 		 
				w_actver = .T.

*				Versi๓n = , Release > Instalado y termina en "A"
*		CASE SUBSTR(wVerxExe,8,2) > SUBSTR(wVersDbf,8,2)	AND w_rel = "A"								&& R.06 Ra๚l
		CASE SUBSTR(wVerxExe,1,7) = SUBSTR(wVersDbf,1,7)	AND	SUBSTR(wVerxExe,8,2) > SUBSTR(wVersDbf,8,2)	AND w_rel = "A"		&& R.06 Ra๚l		 
				w_actver = .T.

*				Versi๓n = , Release > Instalado y NO termina en "A"		===> Busco si hay alg๚n Release con A entre ambos Releases
*		CASE SUBSTR(wVerxExe,8,2) > SUBSTR(wVersDbf,8,2)	AND w_rel = "0"								&& R.06 Ra๚l
		CASE SUBSTR(wVerxExe,1,7) = SUBSTR(wVersDbf,1,7)	AND	SUBSTR(wVerxExe,8,2) > SUBSTR(wVersDbf,8,2)	AND w_rel = "0"		&& R.06 Ra๚l
				w_ind2 = VAL(SUBSTR(wVerxExe,8,2)) + 1
				w_ind1 = VAL(SUBSTR(wVersDbf,8,2)) + 2
				FOR n = w_ind1 TO w_ind2
						IF w_veract(n)	= "A"
										w_actver = .T.
										n = 1000
						ENDIF
				ENDFOR
ENDCASE


wversant	= wversdbf


IF	w_actver	OR wEmSinAct > 0
			wEjec='N'

			&w_panta

			if wEjec='S'
				if ! mfile("\" + d0pref + "\fi\" + w_system + SUBSTR(w_archempr,1,1) + "0" + SUBSTR(w_archempr,2, LEN(w_archempr) - 1) + ".dbf")
						if lresp
							=advgrave("NO EXISTE DIRECTORIO DE ESTRUCTURAS"+CHR(13)+CHR(13)+"COMUNICARSE CON EL PROVEEDOR")
						else
							=advgrave("NO EXISTE DIRECTORIO DE ESTRUCTURAS"+CHR(13)+CHR(13)+"COMUNICARSE CON MEMOSOFT")
						endif
						RETURN .F.
				else

					&w_prog
         
					dele file &w_File
					for i=1 to wVerCant
							w_File=VerFiles[i,1]
							dele file &w_File
					next

					w_file='\' + d0pref + '\V'+ SUBSTR(wverxexe, 8,12) + SUBSTR(wVerxExe,4,4)+'0.'+wVersExe 

					w_hand=f_create(w_file)
         
					if w_hand > 0
							IF w_rel = "A"
									=f_write(w_hand,dtoc(date()) + ' ' + time() + " A")
									=f_close(w_hand)
							ELSE
								=f_write(w_hand,dtoc(date()) + ' ' + time() + "  ")
								=f_close(w_hand)
							ENDIF
					ELSE
						if lresp
							=advgrave("ERROR AL GENERAR ACTUALIZACION"+CHR(13)+CHR(13)+"COMUNICARSE CON EL PROVEEDOR")
						else
							=advgrave("ERROR AL GENERAR ACTUALIZACION"+CHR(13)+CHR(13)+"COMUNICARSE CON MEMOSOFT")
						endif
						RETURN .F.
					endif

					IF w_leer
							w_resul	=	sino("Desea ver la documentaci๓n de esta versi๓n ?","SI", "Actualizaci๓n de versi๓n")
							IF w_resul = "S"
										DO ap WITH d0pref + iif(d0pref$'GW.SE',"p097","p096")	&& R.05 Mariano
							ENDIF
					ENDIF
        		endif
			endif
ELSE
	IF wverxexe < wVersDbf
					=advgrave("ESTA INTENTANDO INSTALAR :" + CHR(13) + CHR(13) + w_ver + CHR(13) + CHR(13) + "QUE ES ANTERIOR A LA EXISTENTE.")
*					RETURN .F.		&& R.06 Ra๚l	
					CLOSE DATA		&& R.06 Ra๚l
					QUIT			&& R.06 Ra๚l
	ENDIF
	DELE FILE &verfiles(1,1)
	verfiles(1,1) = SUBSTR(verfiles(1,1),1,1) + SUBSTR(wverxexe,8,2) + SUBSTR(verfiles(1,1),4,LEN(verfiles(1,1))-3)
	w_hand	= FCREATE(verfiles(1,1))
	IF w_hand > 0
			  =FWRITE(w_hand,dtoc(date()) + ' ' + time() + " " + w_rel)
			  =FCLOSE(w_hand)
	ENDIF
ENDIF

close data

RETURN wCont

*=====================================================================================

&& R.09b Mariano
*=================================================================================================
Procedure memosoft
*=================================================================================================
s_resolucion=allt(TRANSFORM(SYSMETRIC(1),'999999'))+'x'+allt(TRANSFORM(SYSMETRIC(2),'999999'))

do case
	case s_resolucion='800x'
*		@ 0,90 say 'MEMOSOFTฎ' font 'Verdana',30 style 'BT' COLOR RGB(255,255,255)
*		@ 0,100 say 'logoem01.bmp' BITMAP
	case s_resolucion='1024x'
*		@ 0,120 say 'MEMOSOFTฎ' font 'Verdana',30 style 'BT' COLOR RGB(255,255,255)
*		@ 0,130 say 'logoem01.bmp' BITMAP
	case s_resolucion='1280x'
*		@ 0,150 say 'MEMOSOFTฎ' font 'Verdana',30 style 'BT' COLOR RGB(255,255,255)
*		@ 0,170 say 'logoem01.bmp' BITMAP
	otherwise
*		@ 0,65 say 'MEMOSOFTฎ' font 'Verdana',30 style 'BT' COLOR RGB(255,255,255)
*		@ 0,75 say 'logoem01.bmp' BITMAP

endcase

*@ 0,0 say ''

return
*=================================================================================================
&& R.09e Mariano

&& R.11b pa
*)ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
FUNCTION set_pdf	&&Setea PDFCreator para impresi๓n automแtica
*)ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_ruta,w_arch,w_send

if type('w_arch')!='C'
	return
endif
if type('w_ruta')!='C'
	w_ruta=''
endif

private w_resu,w_exec
w_resu=sys(2005)

wait wind 'Estableciendo configuraci๓n de PDF, aguarde por favor..' nowait

set resource to
*w_exec='run /N2 setpdf.exe '+w_ruta+','+w_arch
w_exec='run /N2 setpdf.exe '+iif(w_send,'@','')+w_ruta+','+w_arch
&w_exec
set resource to &w_resu

=inkey(3)	&& R.17 pa

wait clear

return

*)ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
FUNCTION rest_pdf	&&Restaura configuraci๓n de PDFCreator luego de imprimir
*)ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_ruta

if type('w_ruta')!='C'
	w_ruta=''
endif

private w_resu,w_exec,w_i
w_resu=sys(2005)

wait wind 'Restaurando configuraci๓n de PDF, aguarde por favor..' nowait

*set resource to
*w_exec='run /N2 setpdf.exe *'+w_ruta
*&w_exec
*set resource to &w_resu

*do while file(w_ruta+'OK.dbf')	&& R.13 pa
do while file(w_ruta+'OK.dbf') and p_cancela	&& R.13 pa
	set resource to
	*w_exec='run /N2 setpdf.exe *'+w_ruta	&& R.17 pa
	w_exec='run /N2 setpdf.exe {'+w_ruta	&& R.17 pa
	&w_exec
	set resource to &w_resu
	=inkey(3)
enddo

wait clear

return

*)ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
PROC send_mail	&&Envํa comprobante por mail a trav้s de Outlook usando Progmail.exe
*)ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_file,w_ruta,w_par1,w_par2,w_par3,w_par4,w_par5,w_par6,w_par7,w_par8
private w_resu,w_temp
w_temp=w_ruta+'MAIL.dbf'
	
set alter to &w_file..
set alter on
set conso off
??'1'+w_par1
?'2'+w_par2
?'3'+w_par3
?'4'+w_par4
?'5'+w_par5
?'6'+w_par6
?'7'+w_par7
?'8'+w_par8
?''
set conso on
set alter to
set alter off
									
wait wind 'Enviando Comprobante ..' nowait
w_resu=sys(2005)
set resource to
run /N2 progmail &w_file..
wait wind 'Enviando Comprobante ..' time 5
set resource to &w_resu

*do while !file(w_temp)	&& R.13 pa
do while !file(w_temp) and p_cancela	&& R.13 pa
	=inkey(1)	&& R.13 pa
enddo

dele file &w_temp

return
&& R.11e pa

&& R.13b pa
*)ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
FUNCTION ini_pdf	&&Inicia configuraci๓n de PDFCreator antes de imprimir
*)ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
parameters w_ruta

if type('w_ruta')!='C'
	w_ruta=''
endif

private w_resu,w_exec,w_i
w_resu=sys(2005)

wait wind 'Iniciando PDF, aguarde por favor..' nowait

set resource to
*w_exec='run /N2 setpdf.exe +'+w_ruta	&& R.17 pa
w_exec='run /N2 setpdf.exe ['+w_ruta	&& R.17 pa
&w_exec
set resource to &w_resu
=inkey(3)

&& R.17b pa
do while !mfile(w_ruta+'PDFC.INI') and p_cancela
	=inkey(1)
enddo
&& R.17e pa

wait clear

return
&& R.13e pa

&& R.18b Ra๚l
*====================================================================
FUNCTION Encripta
PARAMETERS t
PRIVATE Ret, n, wAsc, Coef, xLargo

xLargo = LEN(RTRIM(t))
Ret = []
FOR n = 1 TO xLargo
	wAsc = ASC(SUBSTR(t,n,1))
	Coef = FACTOR + n
   	Ret = Ret + CHR( wAsc + Coef )
    
ENDFOR
ret = ret + SPACE(LEN(t) - xlargo)

RETURN( Ret )

*==================================================
FUNCTION DESENCRIPTA
PARAMETERS t
PRIVATE n, xLargo, wAsc, Coef
   
xLargo = LEN(RTRIM(t))
Ret = []
FOR n = 1 TO xlargo  STEP 1
	wAsc = ASC(SUBSTR(t,n,1))
	Coef = FACTOR + n
	Ret =  Ret + CHR( wAsc - Coef  ) 
ENDFOR

ret = ret + SPACE(LEN(t) - xlargo)

RETURN( Ret )

*==================================================
&& R.18e Ra๚l