parameters nro, linerr, progerr
_REFOX_ = (9876543210)
_REFOX_ = (9876543210)

m.errordbf = "errdemo.dbf"
do documenta WITH LINENO(1), PROGRAM() , ;
		 MESSAGE(), MESSAGE(1), ERROR(), WLAST(), WREAD(), WONTOP(), ;
		  DBF(),ALIAS(),RECNO()


set echo off
set debug off
private pos, a, aux
aue=sys(101)
define window error from 6,0 to 20,65 close panel font let_gen, tam_gen
on escape ?? ""
set udfparms to value
set multilocks off
set device to screen
set message window
activate window error
clear typeahead
do bruto
if _windows
	@0,56 say 'trffc10c.bmp' BITMAP isometric size 4,7
endif
do case
case nro=30
	if _windows

		release window error
		wait "POSICION fuera de pantalla"window
		if  wontop('screen')
			modi window screen from -0.2,-0.35 to 28.5,81 title "KROPOL Soft" font let_gen, tam_gen style tip_gen noclose float
			retry	
		else
			do reto_r
		endif
	else
		wait "POSICION fuera de pantalla"window
	endif
case nro=1707
	@2,4 say "No se encuentra un INDICE estructurado"
	@4,2 say "Realice REPARACION de INDICES."
	wait "Presione una tecla para continuar" window
case nro=1412
	@2,4 say "No se encuentra variable COMSPEC"
	wait "Presione una tecla para continuar" window


case nro=43
	@2,4 say "Memoria insufuciente para efectuar la OPERACION"
	@4,2 say "trate de habilitar mas memoria."
	wait "Presione una tecla para continuar" window
	release window error
	do reto_r
case nro=1502
	release window error
	wait "Presione una tecla para continuar" window
	return
case nro=1661
	@2,4 say "Formato invalido de archivo"
	release window error
	wait "Presione una tecla para continuar" window
	do reto_r
	
case nro=1423
	@2,4 say "No se pudo crear objeto OLE"
	wait "Presione una tecla para continuar" window
	release window error
	return
case nro=1421
	@2,4 say "No se pudo abrir el servidor OLE. Posiblemente"
	@4,4 say "el objeto se paso a estático."
	wait "Presione una tecla para continuar" window
	release window error
	return
case nro=356
	erase kropol.fky
	release window error
	wait "Archivo Macro en mal estado se procedió al borrado del mismo" window
	return
case nro=12
	@2,4 say "El sistema no encontró una variable, posiblemente"
	@3,4 say "por no coincidir su versión de programas con la"
	@4,4 say "de archivos. Anote la siguiente línea y consulte"
	@5,4 say "al distribuidor"
	@6,4 say message() color w+/n
	@7,4 say "Del programa"
	@7,20 say progerr color w+/n
case nro=39
	@2,4 say "El valor de una variable es muy alto para ser guardado"
	@3,2 say "en base de datos "+dbf()
	wait "Avise a Netlan en que circunstancia se DIO" window
	deactivate window error
	release window error
	pos=recno()
	if !empty(dbf())
		do brow_on2
		define window error from 6,0 to 11,80 close panel font let_gen, tam_gen
		browse wind error for recno()=pos title "Verifique el registro con problemas, y presione ENTER" nomodify noappend nodelete nomenu timeout(300) color scheme 15 font let_gen, tam_gen-1
		release window error
		do brow_off
		pos=afields(campo)
		if rlock()
			for a=1 to pos
				aux=campo(a,1)
				
				if campo(a,2)='N' .and.  abs( &aux ) > 10^campo(a,3)
					aux=campo(a,1)
					replace &aux with 0
				
				endif
			endfor
		endif
	endif
	return
case nro=1410
	@2,4 say "No se pudo abrir un archivo temporal"
	@4,4 say "posiblemente se trate que el directorio se"
	@6,4 say "se encuentre completo, o hay problemas de accesos"
	@8,4 say "permitidos en el directorio."
case nro=1149 .or. nro=1150 .or. nro=1151 .or. nro=1600
	@2,4 say "No hay suficiente memoria para ejecutar una OPERACION"
	@4,4 say "DEBERA considerar agregar MAS memoria o borrar programas"
	@6,4 say "Residentes."
	wait "Presione una tecla para continuar" window
	do final
case nro=109 .or. nro=130
	@2,4 say "El registro esta siendo utilizado por otro usuario."
	@4,4 say "Intente MAS adelante."
	wait "Presione una tecla para continuar" window
	deactivate window error
	release window error
	retry
case nro=1002
	release all
	wait  "Mensaje de error de lectura/GRABACION del sistema operativo" window
	do final	
case nro=1309
	@4,4 say "Se ha borrado un programa con EXTENSION: 'fxp'"
	@6,4 say "Vuelva a instalar 'SOLO'los discos de programas."
case nro=41
	@2,4 say "Se ha borrado un archivo de detalles  con EXTENSION: 'fpt'"
	@4,4 say "que guarda los detalles anexos. Pruebe primero con repara-"
	@6,4 say "cion indices, y sino, recupere la copia de PROTECCION."
case nro=1105
	@2,4 say "No se pudo grabar sobre una unidad."
case nro=1115 .or. nro=15
	if _zuyt(20)='S'
		@2,4 say "Se INTENTO abrir un archivo en malas condiciones"
		@3,4 say "o se INGRESO en forma incorrecta clave encriptado"
		@4,4 say "Si es clave, salga e ingresela coorectamente, sino"
		@5,4 say "con la OPCION 'REPARACION INDICES DE ARCHIVOS'"
		@6,4 say "se PODRA verificar cual ha tenido problemas."
		@7,4 say "Utilice ALGUN programa para reparar archivos DBF,"
		@8,4 say "o recupere la copia de PROTECCION."
		wait "Presione una tecla para continuar" window
	else
		@2,4 say "Se INTENTO abrir un archivo en malas condiciones"
		@4,4 say "Con la OPCION 'REPARACION INDICES DE ARCHIVOS'"
		@5,4 say "se PODRA verificar cual ha tenido problemas."
		@7,4 say "Utilice ALGUN programa para reparar archivos DBF,"
		@8,4 say "o recupere la copia de PROTECCION."
		wait "Presione una tecla para continuar" window
	endif
	do final
case nro=1157
	@2,4 say "No se pudo actualizar un archivo, posiblemente por falta"
	@4,4 say "de suficiente espacio. De haber inconsistencia"
	@6,4 say "en archivos, recupere copia PROTECCION."
	wait "Presione una tecla para continuar" window
	do reto_r
case nro=1101
	@2,4 say "No se pudo abrir un archivo."
	@4,4 say "Posiblemente por haberse borrado,"
	@5,4 say "o por no tener acceso al directorio."
case nro=1102
	@2,4 say "No se ha podido crear un archivo auxiliar."
	@4,4 say "Posiblemente por no haber espacio"
	@5,4 say "en el disco o en el directorio,"
	@6,4 say "o por haber archivos temporarios con"
	@7,4 say "EXTENSION TMP. De ser ASI, borrarlos."
case nro=111
	@2,4 say "Se ha intentado grabar sobre un archivo"
	@4,4 say "definido para read-only"
	@6,4 say "Consulte al supervisor de la red."
case nro=108 .or. nro=1705
	@2,4 say "Para realizar esta OPERACION, necesita uso exclusivo de un"
	@3,4 say "archivo que es utilizado en este momento por otro usuario."
	@4,4 say "O otro usuario lo utiliza en forma exclusiva."
	@6,4 say "Reintente MAS adelante o solicite que terminen el"
	@7,4 say "proceso en el que ESTA el otro usuario."
case nro=55
	@2,4 say "Se ha arruinado un archivo de variables"
	@4,4 say "Recupere la copia de datos generales"
	@6,4 say "del sistema."
case nro=1405
	@2,4 say "No se pudo correr un programa externo"
	@3,4 say "Esto se puede deber a poca memoria, o"
	@4,4 say "a no haber definido la variable COMSPEC"
	@5,4 say "si se trata de una red."
	wait "Presione una tecla para continuar" window
	do final
case nro=1
	@2,4 say "Se ha borrado un archivo del sistema."
	@3,4 say "Intente primero la REPARACION de indices."
	@4,4 say "a) Si este proceso da error es que el problema ESTA en un"
	@5,4 say "   archivo 'DBF' que se BORRO, Recuperar copia PROTECCION."
	@6,4 say "b) Si la REPARACION de indices SALIO bien pero persiste"
	@7,4 say "   este error, instale nuevamente solo los discos de"
	@8,4 say "   programas."
	wait "Presione una tecla para continuar" window
	do final
case nro=5 .or. nro=113 .or. nro=20
	@2,4 say "Ha habido un error en una archivo INDICE"
	@4,4 say "Ejecute la OPCION REPARACION DE INDICES."
	@6,4 say "y de persistir el problema, recupere la"
	@8,4 say "copia de PROTECCION"
	wait "Presione una tecla para continuar" window
	do final
case nro=114 .or. nro=19
	@2,4 say "El archivo INDICE no corresponde."
	@4,4 say "Ejecute la OPCION REPARACION DE INDICES."
	@6,4 say "y de persistir el problema, borre"
	@7,4 say "el archivo INDICE con EXTENSION"
	@8,4 say "CDX o IDX"
	wait "Presione una tecla para continuar" window
	do final
case nro=6
	close all
	@2,4 say "Verifique que en el archivo 'CONFIG.SYS'"
	@4,4 say "del directorio raiz, tenga especificado"
	@6,4 say "que 'FILES=' sea por lo menos igual a 99."
	wait "Presione una tecla para continuar" window
	do final
case nro=56
	close all
	@4,4 say "No hay mas espacio en el disco, debe borrar archivos"
	@6,4 say "superfluos, o realizar una DEPURACION de movimientos."
	@8,4 say "Verifique que no haya archivos con nombres como '$T232234'"
	wait "Presione una tecla para continuar" window
	do final
case nro=125 .or. nro=124
	auy=sys(100)
	no=" "
	@4,4 say "LA IMPRESORA NO SE ENCUENTRA LISTA,"
	do while no#"S" .and. no#"N"
		@6,4 say "CONTINUA CON LA IMPRESION ?  S/N " get no picture "!"
		read
	enddo
	release window error
	if no="N"
		pumbi=cambimp
		set printer to ( _zzz(12,cambimp) )
		do reto_r
	else
		if aue#'SCREEN'
			set device to print
		endif
		if auy="OFF"
			set console off
		endif
		if conde="C"
			do letra with 2,"C"
		endif
		if conde="G"
			do letra with 4,"G"
		endif
		retry
	endif
otherwise
	close all
	set device to screen
	@2,4 say "ERROR nro. "+str(nro,5,0) color w+/n
	@4,4 say message() color w+/n
	@6,4 say "En LINEA "
	@6,20 say linerr
	@8,4 say "Del programa"
	@8,20 say progerr
	@10,4 say "Consulte al distribuidor."
	wait "Presione una tecla para continuar" window
	do final
endcase
close data
wait "Presione una tecla para continuar" window
do reto_r



procedure reto_r
close data
ia=1
do while len(sys(16,ia))#0
	ia=ia+1
enddo
qqq=program( iif(ia-6<1, 1, ia-6) )
release window error
rele window thermo
close procedure
set century off
release windows
release windows
do inicio
set near off
return to &qqq



procedure bruto
set bell on
set bell to 200,6
?? chr(7)
set bell off
return




procedure final
	do sale with .F.
	close all
	on error
	release all
	set sysmenu to default	
	release windows
	clear memory
	set library to
	cancel

return

*******************
procedure documenta
*******************
PARAMETERS errlineno, errprog, errmsg, errline, errno;
    lastwind, readwind, topwind, dbfused, aliasused, err_rec

	SET PRINT OFF
	SET CONSOLE ON
	SET DEVICE TO SCREEN

 
 	IF !USED('errordbf')
		USE (m.errordbf) in 0 alias ERRORDBF
	ENDIF
	
	SELECT ERRORDBF

	APPEND BLANK
	SAVE WINDOWS ALL TO MEMO SNAPSHOT

	REPLACE errdate WITH DATE()
	REPLACE errtime WITH TIME()

	WAIT "ERROR PROCESSING..." WINDOW NOWAIT

	REPLACE errdata WITH ALLTRIM(errline)      + CHR(13)

	m.nestdepth = 1
	DO WHILE LEN(SYS(16,m.nestdepth)) <> 0
		REPLACE listing WITH "PROGRAM STACK # " ;
		  + str(m.nestdepth,2) + " " + PROGRAM(m.nestdepth) + CHR(13) ADDITIVE
		STORE m.nestdepth+1 TO m.nestdepth
	ENDDO

	REPLACE listing WITH "Error number  = " + ALLTRIM(STR(errno)) + CHR(13) ADDITIVE
	REPLACE listing WITH "Error message = " + errmsg + CHR(13) ADDITIVE
	REPLACE listing WITH "lineno        = " + ALLTRIM(STR(errlineno,2)) + CHR(13) ADDITIVE
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
	wait clear

	do errinput.spr   
 
 	use
return