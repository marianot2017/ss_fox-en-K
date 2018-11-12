para p_par1

if parameters()=0
	p_par1='NO'
endif
set resou off

if file('instala.exe')
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
	
w_sys=subs(__curdir,2,2)

d0pref=w_sys

*saco la rutina de error, ya que va estar en cd y no 
*puede crear ni modificar el ssf090.dbf

*on error do ssp090 with error(), lineno(), program()

set proc to library.prg

=setup()

d0pate=sys(2023)  && path temporario
d0f99=d0pate+'\'+sys(3)

__windir=dimaqi()

if mfile('sopo.123')
	* Para trabajar en el cliente
	dele file sopo.123
	set sysmenu to defa
	do comwin
	clear all
	on error
	cancel
endif

d0f77=w_sys+'f077'
w_vexe='00000000'

wsalir=.f.

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
set excl on

com=.f.

__lib=lib()

do instsis1

set sysmenu to defa

return

* -----------------------------
function valmaqini
* -----------------------------
if p_par1<>'01'
	show get w_var,5 disable
	show get w_var,6 disable
endif
return .t.


* -----------------------------
function lock77
* -----------------------------
l_retu=.t.
use &d0F77 excl alia F77
if neterr()
	=advgrave('Hay usuarios Utilizando el sistema'+chr(13)+'No puede seguir adelante')
	l_retu=.f.
endif
return l_retu

* -----------------------------
function setup
* -----------------------------
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
	p_sepa, p_poin, p_memo, p_repfields, p_repfor, p_repwhile, p_repdos,;
	p_preview, p_lmargrep, p_reptype2

p_repout='Pantalla'
p_repclaus=''
p_reptype='TXT   Pantalla'
p_reptype2='LPT1'
p_repfile=''
p_repfields=''
p_repfor=''
p_repwhile=''
p_repdos=0
p_preview=0
p_lmargrep=0

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
g_boxstrg = ['Ä','Ä','³','³','Ú','¿','À','Ù','Ä','Ä','³','³','Ú','¿','À','Ù']
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


*=inisetimp()	&& Inicializa Handles que usaran las funciones.

** Reindexa el archivo de seguridad y usuarios siempre que pueda acceder **

if type('fieldvec')='U'
	dimension fieldvec(1)
endif

return ''

