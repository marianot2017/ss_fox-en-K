*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ Sys.Info ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H Programa        : MANEJO DE ERRORES
*-H	Release			: 06
*-H Fecha de inicio : 
*-H Fecha de fin    :
*-H
*-H Actualizaciones
*-H
*-H  Fecha       Programmer      Comentarios
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*-H ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

parameters nro, linerr, progerr

if progerr='DOCUMENTA'
   
	=advgrave('Error Recursivo, '+str(nro,4)+', '+str(linerr,5), 'Error Fatal')
	=mquit()

endif

if progerr='SSP090'

	do documenta WITH LINERR, PROGRAM() , ;
		 MESSAGE(), MESSAGE(1), ERROR(), WLAST(), WREAD(), WONTOP(), ;
		  DBF(),ALIAS(),RECNO()
    
	=advgrave('Error Recursivo, '+str(nro,4)+', '+str(linerr,5), 'Error Fatal')
	=mquit()

endif

if !type('fieldvec')='U'

	er_valor = 1

	if (nro=108 or nro=1101) or (nro=1705 or nro=1718) or (nro=41 or nro=1115 or nro=15)
		
		if !empty(fieldvec)

			for i=1 to 255

				if !used(fieldvec[i])
					er_valor=i
					exit
				endif
			next

			if .not. used('F98')
				er_abre=.t.
				use ssf098  in 0 alias f98 orde d98alia shared
			else
				er_abre=.f.
				if bof('f98') or eof('f98')
					er_reg=1
				else
					er_reg=recno('f98')
				endif
			endif

			if seek(upper(fieldvec[ er_valor ]), 'F98')
				er_mes='Archivo : ' + alltrim(upper(f98.d98desc))
			else
				er_mes='Archivo : ' + fieldvec[ er_valor ]
			endif

			do case 
				case nro=108
					er_mes=er_mes+' utilizado por otros usuarios... '
				case nro=1718
					er_mes=er_mes+' bloqueado en la red... '
				case nro=1705
					er_mes=er_mes+' denegado el acceso... '
					if fieldvec[ er_valor ] = 'FOX_USER'	&& esto se usa como clave para tirar el siguiente mensaje
						er_mes='Presione <Enter> para continuar'
					endif					
				case nro=1718
					er_mes=er_mes+' s๓lo lectura... '
				case nro=15
					er_mes=er_mes+' con Header defectuoso... '
				case nro=41
					er_mes=er_mes+' con Memo defectuoso... '
				case nro=1115
					er_mes=er_mes+' CURSOR defectuoso... '
			endcase
			
			wait wind er_mes time 3

			&& R.06b Mariano
			if file('SOPO.123')
				wait wind 'Programa : '+progerr+' Linea:'+str(linerr) time 2
			endif
			&& R.06e Mariano

			=adel(fieldvec, er_valor )
			
			if er_abre
				use in f98
			else
				go er_reg in f98
			endif
		
		else
		
			er_mes='Archivo, '
			do case 
				case nro=108
					er_mes=er_mes+' utilizado por otros usuarios... '
				case nro=1718
					er_mes=er_mes+' bloqueado en la red... '
				case nro=1705
					er_mes=er_mes+' denegado el acceso... '
				case nro=1718
					er_mes=er_mes+' s๓lo lectura... '
				case nro=15
					er_mes=er_mes+' con Header defectuoso... '
				case nro=41
					er_mes=er_mes+' con Memo defectuoso... '
				case nro=1115
					er_mes=er_mes+' CURSOR defectuoso... '
			endcase
			wait wind er_mes time 3

			&& R.06b Mariano
			if file('SOPO.123')
				wait wind 'Programa : '+progerr+' Linea:'+str(linerr) time 2
			endif
			&& R.06e Mariano
		endif

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

if nro=1421	&& acceso a la documentacio ole a winword
	
	w_err1='Esta mแquina no tiene disponible el enlace con WORD'
	w_err2='El archivo esta disponible en el directorio'+d0pref+'\DOC'
	=advgrave(w_err1+chr(13)+w_err2)

	ia=1
	do while len(sys(16,ia))#0
		ia=ia+1
	enddo
	qqq=program( iif(ia-3<1, 1, ia-3) )
	set near off
		
	return to &qqq
endif

if nro=124 or nro=125 	&& impresora no instalada
	
	w_err1='No se puede imprimir por impresora'
	=advgrave(w_err1)

	ia=1
	do while len(sys(16,ia))#0
		ia=ia+1
	enddo
	qqq=program( iif(ia-3<1, 1, ia-3) )
	set near off
		
	return to &qqq
endif

if nro=1707		&& si el cdx no esta, da una advertencia
      
   retry 
   
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

	@2,4 say "Memoria insuficiente para efectuar la operaci๓n"
	@4,2 say "trate de habilitar mas memoria."
	
case nro=39
	@2,4 say "El valor de una variable es muy alto para ser guardado"
	@4,4 say "Avise a su Distribuidor en que circunstancia se di๓"
	
case nro=1410
	@2,4 say "No se pudo abrir un archivo temporal"
	@4,4 say "posiblemente se trate que el directorio se"
	@6,4 say "se encuentre completo, o hay problemas de accesos"
	@8,4 say "permitidos en el directorio."
	
case nro=1149 .or. nro=1150 .or. nro=1151 .or. nro=1600

	p_neterr=.t.

	@4,4 say "Deberแ considerar agregar mแs memoria o borrar programas"
	@6,4 say "Residentes."
	
	do cancela

case nro=109 .or. nro=130 or nro=1503

	@2,4 say "El registro esta siendo utilizado por otro usuario."
	@4,4 say "Intente mแs adelante."
	wait "Presione una tecla para continuar" window

	deactivate window error
	release window error
	retry

case nro=1002

	p_neterr=.t.

	@2,4 say  "Mensaje de error de lectura/grabaci๓n del sistema operativo"

	do cancela
	
case (nro=41 or nro=1115 or nro=15) and .f.
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

				@2,4 say "Se intent๓ reparar un archivo en malas condiciones."
				@4,4 say "No se pudo arreglar. Verificar la base "+base
				wait "Presione una tecla para continuar" window

				do cancela	
				
		ENDCASE
	else
		p_neterr=.t.

		@2,4 say "Se intent๓ reparar un archivo en malas condiciones."
		@4,4 say "No se pudo arreglar."
		wait "Presione una tecla para continuar" window

		do cancela
		
	endif
	
case nro=1105
	@2,4 say "No se pudo grabar sobre una unidad."

case nro=1157

	p_neterr=.t.

	@2,4 say "No se pudo actualizar un archivo, posiblemente por falta"
	@4,4 say "de suficiente espacio. De haber inconsistencia"
	@6,4 say "en archivos, recupere copia protecci๓n."

case nro=1102
	@2,4 say "No se ha podido crear un archivo auxiliar."
	@4,4 say "Posiblemente por no haber espacio"
	@5,4 say "en el disco o en el directorio,"
	@6,4 say "o por haber archivos temporarios con"
	@7,4 say "extensi๓n TMP. De ser asํ, borrarlos."

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
	
case nro=5 .or. nro=114 .or. nro=113 .or. nro=20

	p_neterr=.t.

	@2,4 say "Ha habido un error en una archivo ํndice"
	@4,4 say "Ejecute la opci๓n REPARACION DE INDICES."
	@6,4 say "y de persistir el problema, recupere la"
	@8,4 say "copia de protecci๓n"

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
	@6,4 say "superfluos, o realizar una depuraci๓n de movimientos."
	@8,4 say "Verifique que no haya archivos con nombres como *.tmp"

	do cancela
	
case nro=1907 or nro=202
	@4,4 say "Unidad de disco o Drive incorrecto, tipee otro"
	wait "Presione una tecla para continuar" window

	deactivate window error
	release window error
	retry

case nro=14		&& error MemoSoft

	p_neterr=.t.

	set device to screen
	nro=right(sys(3),1)
	do case
		case nro='0'
			@2,4 say "ERROR nro. "+str(2,5) color w+/n
			@4,4 say 'Header error in Table/DBF file' color w+/n
		case nro='1'
			@2,4 say "ERROR nro. "+str(8,5) color w+/n
			@4,4 say 'Record error in Table/DBF file' color w+/n
		case nro='2'
			@2,4 say "ERROR nro. "+str(14,5) color w+/n
			@4,4 say 'Write error in Table/DBF file' color w+/n
		case nro='3'
			@2,4 say "ERROR nro. "+str(25,5) color w+/n
			@4,4 say 'Table with bad header' color w+/n
		case nro='4'
			@2,4 say "ERROR nro. "+str(28,5) color w+/n
			@4,4 say 'Table with bad record' color w+/n
		case nro='5'
			@2,4 say "ERROR nro. "+str(29,5) color w+/n
			@4,4 say 'Table write error' color w+/n
		case nro='6'
			@2,4 say "ERROR nro. "+str(32,5) color w+/n
			@4,4 say 'Header is not valid' color w+/n
		case nro='7'
			@2,4 say "ERROR nro. "+str(33,5) color w+/n
			@4,4 say 'Record is not valid' color w+/n
		case nro='8'
			@2,4 say "ERROR nro. "+str(35,5) color w+/n
			@4,4 say 'Table/DBF file is not valid' color w+/n
		case nro='9'
			@2,4 say "ERROR nro. "+str(40,5) color w+/n
			@4,4 say 'Record count is not valid' color w+/n
	endcase
	@6,4 say "En lํnea "
	@6,20 say right(sys(3),4)
	@8,4 say "Del programa"
	@8,20 say progerr
	@10,4 say "Consulte al distribuidor."

	nro=14
	
	do cancela

otherwise

	p_neterr=.t.

	set device to screen
	@2,4 say "ERROR nro. "+str(nro,5,0) color w+/n
	@4,4 say message() color w+/n
	@6,4 say "En lํnea "
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
PARAMETERS errlineno,errprog, errmsg,errline, errno,;
    lastwind,readwind,topwind, dbfused, aliasused, err_rec

	SET PRINT OFF
	SET CONSOLE ON
	SET DEVICE TO SCREEN

 
 	IF !USED('SSF090')
		if file('ssf090.dbf')
			USE ssf090 in 0 alias ssf090
		else
			select 0
			create dbf ssf090 (errdate d(8), errtime c(10), errdata m(10), errscreen m(10), snapshot m(10), listing m(10), usernotes m(10))
		endif
	ENDIF
	
	SELECT ssf090

	APPEND BLANK
	
*	scatter fields errscreen memvar blank memo	&& R.01 Mariano

*	SAVE SCREEN TO m.errscreen	&& R.01 Mariano
	
*	gather fields errscreen memvar memo	&& R.01 Mariano
	
*	SAVE WINDOWS ALL TO MEMO SNAPSHOT	&& R.02 Mariano

	REPLACE errdate WITH DATE()
	REPLACE errtime WITH TIME()

	WAIT "Procesando Error..." WINDOW NOWAIT


	&& R.03b Mariano
	if alias()!='ssf090'
		sele ssf090
	endif
	&& R.03e Mariano
	m.nestdepth = 1
	DO WHILE LEN(SYS(16,m.nestdepth)) <> 0
		REPLACE listing WITH "PROGRAM STACK # " ;
		  + str(m.nestdepth,2) + " " + PROGRAM(m.nestdepth) + CHR(13) ADDITIVE
		STORE m.nestdepth+1 TO m.nestdepth
	ENDDO

	&& R.03b Mariano
	if alias()!='ssf090'
		sele ssf090
	endif
	&& R.03e Mariano
	
	REPLACE listing WITH "Error number  = " + ALLTRIM(STR(errno)) + CHR(13) ADDITIVE
	REPLACE listing WITH "Error message = " + errmsg + CHR(13) ADDITIVE
	REPLACE listing WITH "lineno        = " + ALLTRIM(STR(errlineno)) + CHR(13) ADDITIVE
	REPLACE listing WITH "linetext      = " + ALLTRIM(errline)      + CHR(13) ADDITIVE
	REPLACE listing WITH "Error parameter  = " + ALLTRIM(SYS(2018)) + CHR(13) ADDITIVE

	IF empty(dbfused)
	   dbfused = "None"
	   aliasused = "None"
	ENDIF

	&& R.03b Mariano
	if alias()!='ssf090'
		sele ssf090
	endif
	&& R.03e Mariano
	REPLACE listing WITH "Database in Use " + dbfused + " alias " + aliasused + CHR(13) ADDITIVE
	REPLACE listing WITH "RECNO = " + alltrim(str(err_rec)) + " "            + CHR(13) ADDITIVE
	IF ("None" $ dbfused)
	  REPLACE listing WITH "RECCOUNT = N/A"  + CHR(13) ADDITIVE
	ELSE
	  REPLACE listing WITH "ORDER = " + order(aliasused) + CHR(13) ADDITIVE
	  REPLACE listing WITH "RECCOUNT = " + alltrim(str(reccount(aliasused),15))   + CHR(13) ADDITIVE	&& R.05 Mariano (aumente de 5 a 15)
	  REPLACE listing WITH "BOF() = " + IIF(BOF(aliasused),"YES","NO") + CHR(13)  ADDITIVE
	  REPLACE listing WITH "EOF() = " + IIF(EOF(aliasused),"YES","NO") + CHR(13)  ADDITIVE
	ENDIF
	REPLACE listing WITH "LASTKEY() = " + str(lastkey(),4) + CHR(13)  ADDITIVE	&& R.04 Mariano

	&& R.03b Mariano
	if alias()!='ssf090'
		sele ssf090
	endif
	&& R.03e Mariano
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
	DO WHILE file(errlog)
	  errlog = SYS(3) + ".err"
	ENDDO
  
	&& R.03b Mariano
	if alias()!='ssf090'
		sele ssf090
	endif
	&& R.03e Mariano
	LIST STATUS NOCONSOLE TO (errlog)
	APPEND MEMO listing FROM (errlog)
	REPLACE listing WITH REPLICATE('=',50)                          + CHR(13) ADDITIVE

	&& R.05b Mariano
*	LIST MEMORY NOCONSOLE TO (errlog)
*	APPEND MEMO listing FROM (errlog)
   
*	ERASE (errlog)

	&& R.03b Mariano
*	if alias()!='ssf090'
*		sele ssf090
*	endif
	&& R.03e Mariano

*	SAVE TO MEMO errdata all like *	&& R.03 Mariano
	SAVE TO MEMO errdata all except p_par*
	&& R.05e Mariano

*	release all like * 	&& R.03 Mariano
	
*	scatter fields errscreen memvar blank memo	&& R.01 Mariano

*	SAVE SCREEN TO m.errscreen	&& R.01 Mariano
	
*	gather fields errscreen memvar memo	&& R.01 Mariano
*	release m.errscreen
	
*	SAVE WINDOWS ALL TO MEMO SNAPSHOT	&& R.02 Mariano

*	RESTORE FROM MEMO errdata 	&& R.03 Mariano
	
	&& R.05b Mariano
	private w_vfox,w_inst001,w_inst002,w_inst003,w_inst004,w_inst005,w_inst006,w_inst007,w_inst008
	w_inst001='use '+left(sys(5)+sys(2003),6)+'\ssf090.dbf shared'
	w_inst002='go '+alltrim(str(recno('ssf090'),20))
	w_inst003='=rlock("ssf090")'
	w_inst004='restore from memo errdata additive'
	w_inst005='errlog = '+'SYS(3)+".err"'
	w_inst006='LIST MEMORY NOCONSOLE TO (errlog)'
	w_inst007='APPEND MEMO listing FROM (errlog)'
	w_vfox=sys(5)+sys(2003)+'\'+sys(3)+'.mem'
	save to &w_vfox. all like w_inst*
	release all like w_inst*
	=visuafox('ejeproc(.f.)',w_vfox)
	
	use in ssf090

	=inkey(1)
	   
	wait clear
	&& R.05 Mariano

*	LIST MEMORY NOCONSOLE TO (errlog)
*	APPEND MEMO listing FROM (errlog)
   
	ERASE (errlog)

	&& R.03b Mariano
*	if alias()!='ssf090'
*		sele ssf090
*	endif
	&& R.03e Mariano
*	if set('DEVELOP')='ON' and nro!=14
*		set sysmenu to default	
*		activate screen
*		modify memo listing noedit
*	endif    
	

*	use 			&& R.03 Mariano
*	use in ssf090	&& R.03 Mariano	&& R.05 Mariano
 
*	wait clear

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
		set resource to
	else
	 	IF !USED('SSF090')
			if file('ssf090.dbf')
				USE ssf090 in 0 alias ssf090
			endif
		else
			sele ssf090
		endif
		
		go bottom
		
		do sss090.spr   
	endif

	close all
	on error
	release all
	set sysmenu to default	
	clear all
	cancel


return