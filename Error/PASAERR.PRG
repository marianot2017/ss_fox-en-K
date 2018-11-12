parameters nro, linerr, progerr

if !type('fieldvec')='U'

if !empty(fieldvec)

	er_var   = 0
	er_ascan = space(3)
	er_valor = 0
	er_trans = space(3)

	if nro=108 or nro=1705 or nro=1101
	
		wait window str(nro)+'/'+str(linerr)

		for i = 1 to 255

			er_trans = alias(i)

			if empty(er_trans )
				er_var = i - 1
				if er_var = 0
					er_var = 1
				endif
				er_ascan = alias(er_var)
				exit
			endif
		next

		er_valor = ascan(fieldvec, er_ascan)

		if er_valor = 0
			er_valor = 1
		else
			er_valor = er_valor + 1
		endif
		
		if seek(fieldvec[ er_valor ], 'F98')
		
			wait 'Archivo : ' + alltrim(upper(f98.d98desc)) +' utilizado por otros usuarios... '  wind timeout 5
		else
			wait 'Archivo : ' + fieldvec[ er_valor ] +' utilizado por otros usuarios... '  wind timeout 5
		endif

		=adel(fieldvec, er_valor )

		p_neterr=.t.

		ia=1
		do while len(sys(16,ia))#0
			ia=ia+1
		enddo
		qqq=program( iif(ia-3<1, 1, ia-3) )
		set near off
		
		return to &qqq

	endif

endif

endif

do documenta WITH LINERR, PROGRAM() , ;
		 MESSAGE(), MESSAGE(1), ERROR(), WLAST(), WREAD(), WONTOP(), ;
		  DBF(),ALIAS(),RECNO()

do suena

set echo off
set debug off

aue=sys(101)

on escape ?? ""

set udfparms to value

set multilocks off
set device to screen

DEFINE WINDOW error ;
		AT  0.000, 0.000  ;
		SIZE 15.000, 65.000 ;
		TITLE "ERROR" ;
		FONT "Fixedsys", 9 ;
		FLOAT ;
		NOCLOSE ;
		NOMINIMIZE ;
		SYSTEM ;
		COLOR RGB(,,,192,192,192)
MOVE WINDOW error CENTER

activate window error

clear typeahead

do case
case nro=43

	p_neterr=.t.

	@2,4 say "Memoria insuficiente para efectuar la operación"
	@4,2 say "trate de habilitar mas memoria."
	
case nro=39
	@2,4 say "El valor de una variable es muy alto para ser guardado"
	@4,4 say "Avise a su Distribuidor en que circunstancia se dió"
	
case nro=1410
	@2,4 say "No se pudo abrir un archivo temporal"
	@4,4 say "posiblemente se trate que el directorio se"
	@6,4 say "se encuentre completo, o hay problemas de accesos"
	@8,4 say "permitidos en el directorio."
	
case nro=1149 .or. nro=1150 .or. nro=1151 .or. nro=1600

	p_neterr=.t.

	@4,4 say "Deberá considerar agregar más memoria o borrar programas"
	@6,4 say "Residentes."
	
	do cancela

case nro=109 .or. nro=130 or nro=1503

	@2,4 say "El registro esta siendo utilizado por otro usuario."
	@4,4 say "Intente más adelante."
	wait "Presione una tecla para continuar" window

	deactivate window error
	release window error
	retry

case nro=1002

	p_neterr=.t.

	@2,4 say  "Mensaje de error de lectura/grabación del sistema operativo"

	do cancela
	
case nro=1309
	@4,4 say "Se ha borrado un programa con extensión: 'fxp'"
	@6,4 say "Vuelva a instalar 'SOLO'los discos de programas."

case nro=41
	base=''
	for i = 1 to 255
		if empty(fieldvec(i))
			exit
		endif
		if !used(fieldvec(i))
			exit
		endif
	next
	if i<255
		if !empty(fieldvec(i))
			if !used(fieldvec(i))
				base='d0'+fieldvec(i)
				base=&base
				base=base+'.dbf'
			endif
		endif
	endif

	if !empty(base)
		set library to foxfix addi
		arre=fixdbf(base,1)
		DO CASE
			CASE arre = 0
				deactivate window error
				release window error
				release library foxfix
				retry
			CASE arre > 0
				deactivate window error
				release window error
				release library foxfix
				retry
			OTHERWISE

				p_neterr=.t.

				@2,4 say "Se intentó reparar un archivo en malas condiciones."
				@4,4 say "No se pudo arreglar. Verificar la base "+base
				wait "Presione una tecla para continuar" window

				do cancela	
				
		ENDCASE
	else
		p_neterr=.t.

		@2,4 say "Se intentó reparar un archivo en malas condiciones."
		@4,4 say "No se pudo arreglar."
		wait "Presione una tecla para continuar" window

		do cancela
		
	endif
	
case nro=1105
	@2,4 say "No se pudo grabar sobre una unidad."

case nro=1115 .or. nro=15
	base=''
	for i = 1 to 255
		if empty(fieldvec(i))
			exit
		endif
		if !used(fieldvec(i))
			exit
		endif
	next
	if i<255
		if !empty(fieldvec(i))
			if !used(fieldvec(i))
				base='d0'+fieldvec(i)
				base=&base
				base=base+'.dbf'
			endif
		endif
	endif

	if !empty(base)
		set library to foxfix addi
		arre=fixdbf(base,1)
		DO CASE
			CASE arre = 0
				deactivate window error
				release window error
				release library foxfix
				retry
			CASE arre > 0
				deactivate window error
				release window error
				release library foxfix
				retry
			OTHERWISE

				p_neterr=.t.

				@2,4 say "Se intentó reparar un archivo en malas condiciones."
				@4,4 say "No se pudo arreglar. Verificar la base "+base
				wait "Presione una tecla para continuar" window

				do cancela
				
		ENDCASE
	else
		p_neterr=.t.

		@2,4 say "Se intentó reparar un archivo en malas condiciones."
		@4,4 say "No se pudo arreglar."
		wait "Presione una tecla para continuar" window

		do cancela
		
	endif
case nro=1157

	p_neterr=.t.

	@2,4 say "No se pudo actualizar un archivo, posiblemente por falta"
	@4,4 say "de suficiente espacio. De haber inconsistencia"
	@6,4 say "en archivos, recupere copia protección."

case nro=1102
	@2,4 say "No se ha podido crear un archivo auxiliar."
	@4,4 say "Posiblemente por no haber espacio"
	@5,4 say "en el disco o en el directorio,"
	@6,4 say "o por haber archivos temporarios con"
	@7,4 say "extensión TMP. De ser así, borrarlos."

case nro=111
	@2,4 say "Se ha intentado grabar sobre un archivo"
	@4,4 say "definido para read-only"
	@6,4 say "Consulte al supervisor de la red."

case nro=55
	@2,4 say "Se ha arruinado un archivo de variables"
	@4,4 say "Recupere la copia de datos generales"
	@6,4 say "del sistema."

case nro=1405

	p_neterr=.t.

	@2,4 say "No se pudo correr un programa externo"
	@3,4 say "Esto se puede deber a poca memoria, o"
	@4,4 say "a no haber definido la variable COMSPEC"
	@5,4 say "si se trata de una red."

	do cancela
	
case nro=1

	p_neterr=.t.

	@2,4 say "Se ha borrado un archivo del sistema."
	@3,4 say "Intente primero la reparación de indices."
	@4,4 say "a) Si este proceso da error es que el problema está en un"
	@5,4 say "   archivo 'DBF' que se borró, Recuperar copia protección."
	@6,4 say "b) Si la reparación de indices salió bien pero persiste"
	@7,4 say "   este error, instale nuevamente solo los discos de"
	@8,4 say "   programas."
	
	do cancela
	
case nro=5 .or. nro=114 .or. nro=113 .or. nro=20

	p_neterr=.t.

	@2,4 say "Ha habido un error en una archivo índice"
	@4,4 say "Ejecute la opción REPARACION DE INDICES."
	@6,4 say "y de persistir el problema, recupere la"
	@8,4 say "copia de protección"

	do cancela

case nro=6

	p_neterr=.t.

	@2,4 say "Verifique que en el archivo 'CONFIG.SYS'"
	@4,4 say "del directorio raiz, tenga especificado"
	@6,4 say "que 'FILES=' sea por lo menos igual a 99."

	do cancela

case nro=56

	p_neterr=.t.

	@4,4 say "No hay mas espacio en el disco, debe borrar archivos"
	@6,4 say "superfluos, o realizar una depuración de movimientos."
	@8,4 say "Verifique que no haya archivos con nombres como *.tmp"

	do cancela
	
case nro=125 .or. nro=124

	auy=sys(100)
	set console on
	release window error
	
	if sino('Impresora no preparada, reintenta ?','SI')='S'
		if aue#'SCREEN'
			set device to print
		endif
		if auy="OFF"
			set console off
		endif
		retry
	else
		p_neterr=.t.

		if auy="OFF"
			set console off
		endif
	endif

case nro=1907 or nro=202
	@4,4 say "Unidad de disco o Drive incorrecto, tipee otro"
	wait "Presione una tecla para continuar" window

	deactivate window error
	release window error
	retry

otherwise

	p_neterr=.t.

	set device to screen
	@2,4 say "ERROR nro. "+str(nro,5,0) color w+/n
	@4,4 say message() color w+/n
	@6,4 say "En línea "
	@6,20 say linerr
	@8,4 say "Del programa"
	@8,20 say progerr
	@10,4 say "Consulte al distribuidor."

	do cancela

endcase

wait "Presione una tecla para continuar" window

release window error

ia=1
do while len(sys(16,ia))#0
	ia=ia+1
enddo
qqq=program( iif(ia-5<1, 1, ia-5) )

return to &qqq

***************
procedure suena
***************
	set bell on
	set bell to 200,6
	?? chr(7)
	set bell off
return


*******************
procedure documenta
*******************
PARAMETERS errlineno,errprog, errmsg,errline, errno;
    lastwind,readwind,topwind, dbfused, aliasused, err_rec

	SET PRINT OFF
	SET CONSOLE ON
	SET DEVICE TO SCREEN

 
 	IF !USED('errordbf')
		if file('errordbf.dbf')
			USE errordbf in 0 alias ERRORDBF
		else
			select 0
			create dbf errordbf (errdate d(8), errtime c(10), errdata m(10), errscreen m(10), snapshot m(10), listing m(10), usernotes m(10))
		endif
	ENDIF
	
	SELECT ERRORDBF

	APPEND BLANK
	
	scatter fields errscreen memvar blank memo

	SAVE SCREEN TO m.errscreen
	
	gather fields errscreen memvar memo
	
	SAVE WINDOWS ALL TO MEMO SNAPSHOT

	REPLACE errdate WITH DATE()
	REPLACE errtime WITH TIME()

	WAIT "Procesando Error..." WINDOW NOWAIT


	m.nestdepth = 1
	DO WHILE LEN(SYS(16,m.nestdepth)) <> 0
		REPLACE listing WITH "PROGRAM STACK # " ;
		  + str(m.nestdepth,2) + " " + PROGRAM(m.nestdepth) + CHR(13) ADDITIVE
		STORE m.nestdepth+1 TO m.nestdepth
	ENDDO

	REPLACE listing WITH "Error number  = " + ALLTRIM(STR(errno)) + CHR(13) ADDITIVE
	REPLACE listing WITH "Error message = " + errmsg + CHR(13) ADDITIVE
	REPLACE listing WITH "lineno        = " + ALLTRIM(STR(errlineno)) + CHR(13) ADDITIVE
	REPLACE listing WITH "linetext      = " + ALLTRIM(errline)      + CHR(13) ADDITIVE
	REPLACE listing WITH "Error parameter  = " + ALLTRIM(SYS(2018)) + CHR(13) ADDITIVE
	REPLACE listing WITH "BOF() = " + IIF(BOF(),"YES","NO") + CHR(13)  ADDITIVE
	REPLACE listing WITH "EOF() = " + IIF(EOF(),"YES","NO") + CHR(13)  ADDITIVE

	IF empty(dbfused)
	   dbfused = "None"
	   aliasused = "None"
	ENDIF
	REPLACE listing WITH "Database in Use " + dbfused + " alias " + aliasused + CHR(13) ADDITIVE
	REPLACE listing WITH "RECNO = " + alltrim(str(err_rec)) + " "            + CHR(13) ADDITIVE
	IF ("None" $ dbfused)
	  REPLACE listing WITH "RECCOUNT = N/A"  + CHR(13) ADDITIVE
	ELSE
	  REPLACE listing WITH "RECCOUNT = " + alltrim(str(reccount(aliasused),5))   + CHR(13) ADDITIVE
	ENDIF
	REPLACE listing WITH "Active Window = " + topwind               + CHR(13) ADDITIVE
	REPLACE listing WITH "Last Window   = " + lastwind              + CHR(13) ADDITIVE
	REPLACE listing WITH "Window in Read = " + IIF(readwind,"YES","NO") + CHR(13) ADDITIVE
	REPLACE listing WITH "Active Obj = " + IIF(readwind,alltrim(varread()),"NONE") + CHR(13) ADDITIVE
	REPLACE listing WITH "Platform used = " + IIF(_DOS,"DOS","WINDOWS") + CHR(13) ADDITIVE
	REPLACE listing WITH "SYS(12) Remaining Memory = "+ Alltrim(SYS(12)) + CHR(13) ADDITIVE
	REPLACE listing WITH "SYS(2010) FILES in config.sys = "+ Alltrim(SYS(2010)) + CHR(13) ADDITIVE

	REPLACE listing WITH REPLICATE('=',50)                          + CHR(13) ADDITIVE

	SET SAFETY OFF
	m.errlog = SYS(3) + ".err"
	DO WHILE FILE(errlog)
	  errlog = SYS(3) + ".err"
	ENDDO
  
  
	LIST STATUS NOCONSOLE TO (errlog)
	APPEND MEMO listing FROM (errlog)
	REPLACE listing WITH REPLICATE('=',50)                          + CHR(13) ADDITIVE
	LIST MEMORY NOCONSOLE TO (errlog)
	APPEND MEMO listing FROM (errlog)
   
	ERASE (errlog)

	if set('DEVELOP')='ON'
		activate screen
		modify memo listing noedit
	endif    
	
	use
 
	wait clear

return


*******************
procedure cancela
*******************

	wait "Presione una tecla para continuar" window

	if set('DEVELOP')='ON'
		set debug on
		set help on
		if file('system.fky')
			restore macros from system.fky
		endif
	else
	 	IF !USED('errordbf')
			if file('errordbf.dbf')
				USE errordbf in 0 alias ERRORDBF
			endif
		else
			sele errordbf
		endif
		
		go bottom
		
		do errinput.spr   
	endif

	close all
	on error
	release all
	set sysmenu to default	
	clear all
	cancel


return