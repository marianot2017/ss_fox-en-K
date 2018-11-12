EXTERNAL ARRAY _pdparms
****transformador de report windows a report dos y preview en pantalla****
**nuevo**

** Release : 09 **

DO CASE
CASE p_repout='Pantalla' OR p_repout='Impresora' OR p_repout='Archivo'
	SET PRINTER TO
ENDCASE
SET ESCAPE OFF
ON ESCAPE DO nada

x_alias=ALIAS()

**if .f.

SELE 0
&& R.03b pa
IF mfile('report\'+p_report+'.frx') AND !('report\'$LOWER(p_report))
	p_report='report\'+p_report
ENDIF
&& R.03e pa
USE &p_report..frx
&& R.07b Mariano
***vfp***
IF VERSION()='Visual FoxPro'
	COPY TO &d0f99.y.frx FOR platform='WINDOWS' AND objtype<>23	TYPE fox2x	&& descarto cosas de windows
ELSE
	COPY TO &d0f99.y.frx FOR platform='WINDOWS' AND objtype<>23	&& descarto cosas de windows
ENDIF
***vfp***
&& R.07e Mariano

USE
USE &d0f99.y.frx EXCLU

COUNT FOR objtype=9 TO w_toes		&& cuento estructura de report

IF w_toes>0		&& Si w_toes=0 el report fue hecho para DOS, no convierte

	DIME w_height(w_toes,3)
	w_height=0

	DIME reng(RECCOUNT()-(w_toes+1),10)
	reng=0

	*replace objtype with 7, objcode with 4 for objtype=6 and width<800		&& lineas a box


	*** calculo de vpos,hpos,height,width de cada get o literal ***
	*** recalcula estructura segun lineas ***
	GO TOP
	h_aybox=.F.
	d_font=fontsize
	d_height=66		&& largo de pagina
	w_width=0	&& maximo ancho de pagina
	SKIP && saltea objtype=1
	w_i=1
	w_j=1
	DO WHILE !EOF()
		IF objtype=9
			w_height[w_j,1]=IIF(w_j=1,HEIGHT,w_height[w_j-1,1]+2083.333+HEIGHT)	&& sumo 2083.333 porque en windows estan las barras que delimitan sectores
			w_j=w_j+1
		ELSE
			IF objtype=7	&& hay recuadros o box
				h_aybox=.T.
			ENDIF
			IF objtype=17	&& hay imagenes
				h_aybox=.T.
			ENDIF
			IF fontsize=0
				p_font=d_font
			ELSE
				p_font=fontsize
			ENDIF
			DO CASE	&& calcula el factor p_font para el font del objeto
			CASE p_font=4
				p_font=27
			CASE p_font=5
				p_font=25
			CASE p_font=6
				p_font=23
			CASE p_font=7
				p_font=20
			CASE p_font=8
				p_font=17
			CASE p_font=9
				p_font=15.5
			CASE p_font=10
				p_font=14
			CASE p_font=11
				p_font=13
			CASE p_font=12
				p_font=12
			CASE p_font=14
				p_font=10
			CASE p_font=16
				p_font=9
			CASE p_font=18
				p_font=8
			CASE p_font=20
				p_font=7
			CASE p_font=22
				p_font=6
			CASE p_font=24
				p_font=6
			CASE p_font=26
				p_font=5
			CASE p_font=28
				p_font=5
			CASE p_font=36
				p_font=4
			CASE p_font=48
				p_font=3
			CASE p_font=72
				p_font=2
			ENDCASE
			x_font=p_font
			h_font=1000
			DO CASE		&& calcula factor x_font para el font por defecto
			CASE d_font=4
				x_font=27
				d_height=130
				h_font=937.500
			CASE d_font=5
				x_font=25
				d_height=120
				h_font=1145.833
			CASE d_font=6
				x_font=23
				d_height=110
				h_font=11250.000
			CASE d_font=7
				x_font=20
				d_height=90
				h_font=1458.333
			CASE d_font=8
				x_font=17
				d_height=60
				h_font=1666.667
			CASE d_font=9
				x_font=15.5
				d_height=51
				h_font=1770.833
			CASE d_font=10
				x_font=14
				d_height=40
				h_font=1875.000
			CASE d_font=11
				x_font=13
				d_height=40
				h_font=2187.500
			CASE d_font=12
				x_font=p_font
				d_height=37
				h_font=2291.667
			CASE d_font=14
				x_font=p_font
				d_height=35
				h_font=2708.333
			CASE d_font=16
				x_font=p_font
				d_height=30
				h_font=2916.667
			ENDCASE
			reng[w_i,1]=vpos
			reng[w_i,2]=hpos
			reng[w_i,3]=HEIGHT
			reng[w_i,4]=WIDTH
			reng[w_i,5]=objtype												&& tipo de objeto
			reng[w_i,6]=0														&& vpos Dos, lo calula luego
			reng[w_i,7]=ROUND(hpos*x_font/10013.889,0)				&& hpos Dos, lo calcula proporcional al font x defecto
			reng[w_i,8]=IIF(objtype=7,ROUND(HEIGHT/h_font,0)+1,1)	&& height Dos, siempre es 1
			reng[w_i,9]=MAX(1,ROUND(WIDTH*p_font/10013.889,0))		&& width Dos, lo calcula proporcional al font del objeto
			reng[w_i,10]=RECNO()
			w_width=MAX(reng[w_i,7]+reng[w_i,9],w_width)				&& maximo ancho del report
			w_i=w_i+1
		ENDIF
		SKIP
	ENDDO

	=ASORT(reng,1)

	w_j=1
	w_l=0
	w_header=.T.	&& esta en header
	FOR w_i=1 TO ALEN(reng,1)
		DO WHILE reng[w_i,1]>w_height[w_j,1]
			IF w_header
				w_header=.F.	&& salio del header
			ENDIF
			w_height[w_j,2]=w_l+1-IIF(w_j=1,0,w_height[w_j-1,3])	&& #lineas Dos
			w_height[w_j,3]=IIF(w_j=1,0,w_height[w_j-1,3])+w_height[w_j,2]
			w_l=w_l+1
			w_j=w_j+1
		ENDDO
		IF w_header		&& para las lineas del header uso factor de ajuste determinado
			GO reng[w_i,10]
			w_dencab=5	&& lineas en DOS del encabezado
			DO CASE
			CASE d_font=6
				d_vpos=1250		&& altura en puntos de la letter gotic para el d_font
				w_wencab=11900	&& puntos en Windows del encabezado
			CASE d_font=7
				d_vpos=1458.333
				w_wencab=11700	&& puntos en Windows del encabezado
			CASE d_font=8
				d_vpos=1666.667
				w_wencab=11500	&& puntos en Windows del encabezado
			CASE d_font=9
				d_vpos=1770.833
				w_wencab=11450	&& puntos en Windows del encabezado
			CASE d_font=10
				d_vpos=1875
				w_wencab=11400	&& puntos en Windows del encabezado
			CASE d_font=11
				d_vpos=2187.5
				w_wencab=11250	&& puntos en Windows del encabezado
			CASE d_font=12
				d_vpos=2291.667
				w_wencab=11200	&& puntos en Windows del encabezado
			CASE d_font=14
				d_vpos=2708.333
				w_wencab=11000	&& puntos en Windows del encabezado
			CASE d_font=16
				d_vpos=2916.667
				w_wencab=10900	&& puntos en Windows del encabezado
			OTHERWISE
				d_vpos=w_height[w_i,3]
				w_wencab=11000	&& puntos en Windows del encabezado
				WAIT WIND 'sin font por defecto'
			ENDCASE
			IF reng[w_i,1]<= w_wencab	&& es parte del encabezado del 0 a 4 linea
				reng[w_i,6]=INT(reng[w_i,1]/2082)
			ELSE
				reng[w_i,6]=ROUND((reng[w_i,1]-w_wencab)/d_vpos,0)+w_dencab
			ENDIF

		ELSE	&&	uso otro para los demas
			DO CASE
			CASE d_font=6
				d_vpos=1250		&& altura en puntos de la letter gotic para el d_font
			CASE d_font=7
				d_vpos=1458.333
			CASE d_font=8
				d_vpos=1666.667
			CASE d_font=9
				d_vpos=1770.833
			CASE d_font=10
				d_vpos=1875
			CASE d_font=11
				d_vpos=2187.5
			CASE d_font=12
				d_vpos=2291.667
			CASE d_font=14
				d_vpos=2708.333
			CASE d_font=16
				d_vpos=2916.667
			OTHERWISE
				d_vpos=w_height[w_i,3]
				WAIT WIND 'sin font por defecto'
			ENDCASE
			reng[w_i,6]=ROUND((reng[w_i,1]-(w_height[w_j-1,1]+2083.333))/d_vpos,0)+w_height[w_j-1,3]
		ENDIF
		DO WHILE w_l>reng[w_i,6]	&& linea fuera de estructura
			reng[w_i,6]=reng[w_i,6]+1
			WAIT WINDOW 'linea fuera de estructura '+STR(reng[w_i,6],3)
		ENDDO
		w_l=reng[w_i,6]	&& ultima linea
	ENDFOR
	w_height[w_j,2]=w_l+1-IIF(w_j=1,0,w_height[w_j-1,3])	&& #lineas Dos
	w_height[w_j,3]=IIF(w_j=1,0,w_height[w_j-1,3])+w_height[w_j,2]
	FOR w_i=w_j+1 TO w_toes
		w_height[w_i,2]=1
	ENDFOR

	FOR w_i=1 TO ALEN(reng,1)
		GO reng[w_i,10]
		REPLA vpos WITH	reng[w_i,6],;
			hpos WITH		reng[w_i,7],;
			HEIGHT WITH	reng[w_i,8],;
			WIDTH WITH	reng[w_i,9]
	ENDFOR

	GO 2 &&	recalcula estructura
	FOR w_i=1 TO w_toes
		REPLA HEIGHT WITH w_height[w_i,2]
		IF objtype=9 AND objcode=4		&& detalle del report
			w_ddeta=w_height[w_i-1,3]	&& linea desde
			*		w_hdeta=w_height[w_i,3]		&& lineas hasta		&& R.04 Mariano
			w_hdeta=w_height[w_i-1,3]+HEIGHT-1		&& lineas hasta	&& R.04 Mariano
		ENDIF
		SKIP
	ENDFOR

	*** Ajustes varios ***

	REPLA ALL platform WITH 'DOS'

	** en windows el norepeat de la estructura se maneja al reves de DOS **
	REPLA WIDTH WITH 0,;
		norepeat WITH IIF(norepeat,.F.,.T.) ;
		FOR objtype=9

	REPLA resettotal WITH resettotal-3 ;
		FOR resettotal>=6

	REPLA resettotal WITH 0 ;
		FOR resettotal=1

	REPLA resettotal WITH 1 ;
		FOR resettotal=2

	**********
	IF h_aybox=.T.		&& por ahora si vienen boxes de Windows los elimino
		DELE FOR objtype=7 AND objcode=4
		DELE FOR objtype=17
		h_aybox=.F.
	ENDIF

	** El ancho de un report DOS no puede superar 254 **
	REPLA hpos WITH 252 FOR hpos>=254 AND objtype<>1 AND objtype<>9 AND objtype<>18
	REPLA WIDTH WITH MAX(1,WIDTH-((hpos+WIDTH)-253)) FOR hpos+WIDTH>=254 AND objtype<>1 AND objtype<>9 AND objtype<>18
	w_width=MIN(253,w_width)	&& reservo el lugar 254

	*** Reordeno los objetos por vpos+hpos ***
	SORT TO &d0f99.x ON vpos,hpos FOR objtype<>1 AND objtype<>9 AND objtype<>18
	DELETE FOR objtype<>1 AND objtype<>9 AND objtype<>18
	IF FILE(d0f99+'x.dbf')
		APPEND FROM &d0f99.x
		PACK	&& quizas lo saco despues
		DELE FILE &d0f99.x.dbf
	ENDIF

	*** Arregla codepage de caracteres para que se vean bien ***
	w_norepeat=.F.	&& lo pongo .f. por que lo resuelvo en el txt
	w_maxvert=1		&& maximo vertical del report
	GO TOP
	SKIP w_toes+1	&& saltea estructura
	DO WHILE !EOF()
		SCATTE MEMVAR MEMO
		w_supexpr=m.supexpr
		IF objtype=5
			m.width=LEN(m.expr)-2	&& ajusto el largo del campo para literales
		ENDIF
		IF h_aybox OR '*'$p_repout	&& impresion DOS pura
			DO CASE
			CASE objtype=5
				m.expr=CPCONVERT(1252,850,m.expr)
				w_maxvert=MAX(w_maxvert,vpos+HEIGHT)
			CASE objtype=8 AND fillchar='C'
				aux=m.expr
				IF AT("'",aux)>0
					m.expr="cpconvert(1252,850,&aux.)"
				ELSE
					m.expr='cpconvert(1252,850,&aux.)'
				ENDIF
				w_maxvert=MAX(w_maxvert,vpos+HEIGHT)
			ENDCASE
		ENDIF
		IF offset=2	&& centrado en Windows
			IF fillchar='N'
				m.style='C'	&& centrado DOS
			ELSE
				IF objtype<>6
					m.picture='"@I"'	&& centrado DOS
				ENDIF
			ENDIF
		ENDIF
		IF offset=1	&& derecha en Windows
			IF fillchar='N'
				m.style='J'	&& derecha en DOS
			ELSE
				IF objtype<>6
					m.picture='"@J"'	&& derecha en DOS
				ENDIF
			ENDIF
		ENDIF
		IF fontstyle=5	&& rayado y negrita
			m.style='UB'
		ENDIF
		IF !EMPTY(w_supexpr)
			IF m.norepeat
				w_norepeat=.T.
			ENDIF
			IF objtype=6
				*			if h_aybox or '*'$p_repout	&& impresion DOS pura
				*			else
				m.expr='"'+REPLICATE('—',IIF(vpos=0, MAX(w_width,WIDTH), WIDTH))+'"'	&& R.06 Mariano (cambie el caracter a replicar. Sale linea llena)
				m.expr=CPCONVERT(1252,850,m.expr)
				*			endif
				m.width=IIF(vpos=0, MAX(w_width,WIDTH), WIDTH)
			ENDIF
			IF m.totaltype>0 AND m.fillchar='N' 	&& cuando es campo calculado debe ir cero
				m.expr='iif('+w_supexpr+','+m.expr+',0)'
				*			if norepeat and !empty(m.picture)	&& R.04 Mariano
				IF norepeat AND !EMPTY(m.picture) AND !'@Z '$UPPER(m.picture)	&& R.04 Mariano
					m.picture='"@Z '+SUBSTR(m.picture,2,LEN(m.picture)-1)	&& R.02 Mariano
				ENDIF
			ELSE
				IF m.fillchar='N'
					IF EMPTY(m.picture)
						WAIT WIND 'Necesita agregar picture al valor numerico '+m.expr
					ENDIF
					m.expr='iif('+w_supexpr+','+'transform('+m.expr+','+m.picture+')'+',"")'
					m.picture='"@J"'	&& derecha en DOS
					m.fillchar='C'
				ELSE
					m.expr='iif('+w_supexpr+','+m.expr+',"")'
					&& R.08b Mariano
					if len(m.expr)>254
						IF objtype=6
							m.expr="REPLICATE('—',"+allt(str(IIF(vpos=0, MAX(w_width,WIDTH), WIDTH),3))+")"	
							m.expr=CPCONVERT(1252,850,m.expr)
							m.width=IIF(vpos=0, MAX(w_width,WIDTH), WIDTH)
							m.expr='iif('+w_supexpr+','+m.expr+',"")'
						ENDIF
					endif
					&& R.08e Mariano
				ENDIF
			ENDIF
			IF totaltype=0		&& objetos simples
				DO CASE
				CASE m.resetrpt=1
					m.resetrpt=0
				CASE m.resetrpt=2
					m.resetrpt=1
				CASE m.resetrpt>=3
					m.resetrpt=m.resetrpt-3
				ENDCASE
			ELSE		&& objetos calculados
				m.resetrpt=m.resettotal
			ENDIF
			IF w_toes=3  OR BETWEEN(m.vpos,w_ddeta,w_hdeta)	&& las lineas en blanco del detalle se remueven globalmente y no cada get
				m.norepeat=.F.
			ENDIF
			m.supvalchng=.F.
			m.supexpr=''
			IF objtype=6
				*			if h_aybox or '*'$p_repout	&& impresion DOS pura
				*				m.objtype=7
				*				m.objcode=4
				*			else
				m.objtype=8		&& si es linea o literal con print when pasa a get
				*			endif
			ELSE
				m.objtype=8		&& si es linea o literal con print when pasa a get
			ENDIF
			GATHER MEMVAR MEMO
		ELSE
			IF objtype=6
				*			if h_aybox or '*'$p_repout	&& impresion DOS pura
				*				m.objtype=7
				*				m.objcode=4
				*			else
				m.expr='"'+REPLICATE('—',IIF(vpos=0, MAX(w_width,WIDTH), WIDTH))+'"'	&& R.06 Mariano (cambie el caracter a replicar. Sale linea llena)
				m.expr=CPCONVERT(1252,850,m.expr)
				m.objtype=8
				*			endif
				m.width=IIF(vpos=0, MAX(w_width,WIDTH), WIDTH)
			ELSE
				IF m.fillchar='N' AND !EMPTY(m.picture) AND totaltype=0
					m.expr='transform('+m.expr+','+m.picture+')'
					m.picture='"@J"'	&& derecha en DOS
					m.fillchar='C'
				ENDIF
				IF totaltype=0		&& objetos simples
					DO CASE
					CASE m.resetrpt=1
						m.resetrpt=0
					CASE m.resetrpt=2
						m.resetrpt=1
					CASE m.resetrpt>=3
						m.resetrpt=m.resetrpt-3
					ENDCASE
				ELSE		&& objetos calculados
					m.resetrpt=m.resettotal
				ENDIF
				IF w_toes=3  OR BETWEEN(m.vpos,w_ddeta,w_hdeta)	&& las lineas en blanco del detalle se remueven globalmente y no cada get
					IF m.norepeat
						w_norepeat=.T.
					ENDIF
					m.norepeat=.F.
				ENDIF
			ENDIF
			GATHER MEMVAR MEMO
		ENDIF
		SKIP
	ENDDO

	*** ajuste de box mas grande que el report **
	REPLA HEIGHT WITH w_maxvert-vpos FOR objtype=7 AND objcode=4 AND vpos+HEIGHT>w_maxvert

	*** Ajuste del titulo ***
	REPLA WIDTH WITH w_width FOR fontsize=16 AND offset=2	&& w_title


	*if .f.
	*** Arregla objetos encimados ***
	w_recpri=0
	w_recult=0
	w_haydos=.F.
	GO TOP
	SKIP w_toes+1	&& saltea estructura
	DO WHILE !EOF()
		IF objtype=18 OR objtype=7	&& son variables las salteo o boxes
			SKIP
			LOOP
		ENDIF
		w_recpri=RECNO()
		SCATTER MEMVAR MEMO
		SKIP
		DO WHILE m.vpos=vpos	AND !EOF() && recorro la fila completa
			** recorro la fila mientras haya encimados **
			w_caen=1			&& cantidad de encimados con respecto al objeto que estoy parado
			w_recant=RECNO()
			DO WHILE m.vpos=vpos AND !EOF() AND BETWEEN(hpos,m.hpos,m.hpos+m.width-1)
				w_caen=w_caen+1
				SCATTER MEMVAR
				w_recult=RECNO()
				SKIP
			ENDDO
			DO CASE
			CASE .F. AND w_caen>=2 AND '*Epson'$p_repout	&& impresion DOS pura y hay dos objetos encimados, agrego objeto
				GO w_recpri
				SCATTE MEMVAR MEMO
				IF LEFT(m.expr,4)='iif('
					m.expr=STRTRAN(m.expr,'""',"'"+CHR(14)+"'")	&& caracter control
					GATHER MEMVAR MEMO
				ENDIF
				GO w_recant	&& voy al segundo encimado
				SCATTER MEMVAR MEMO
				w_haydos=.T.
				*** coloco el control en la posicion del segundo y corro el segundo ***
				m.objtype=5	&& literales
				m.expr="'"+CHR(14)+"'"
				m.width=1
				m.norepeat=.F.
				m.fillchar=''
				m.picture=''
				m.resetrpt=0
				m.totaltype=0
				m.resettotal=0
				offset=0
				supalways=.F.
				suprpcol=0
				supgroup=0
				INSERT BEFORE BLANK
				GATHER MEMVAR MEMO
				*				w_recpri=w_recpri+1	&& al insertar un registro antes de w_recpri corro en 1 w_recpri
				w_recant=w_recant+1	&& al insertar un registro antes de w_recant corro en 1 w_recant
				w_recult=w_recult+1	&& al insertar un registro antes de w_recult corro en 1 w_recult
				SKIP	&& vuelvo donde estaba parado
				SCATTE MEMVAR MEMO
				IF LEFT(m.expr,4)='iif('
					m.expr=STRTRAN(m.expr,'""',"'"+CHR(14)+"'")	&& caracter control
					GATHER MEMVAR MEMO
				ENDIF
				DO WHILE RECNO()<=w_recult
					SKIP
					IF m.hpos+1+m.width>=hpos
						SKIP -1	&& vuelvo donde estaba parado
						REPLA hpos WITH hpos+1, WIDTH WITH WIDTH-1
					ELSE
						SKIP -1	&& vuelvo donde estaba parado
						REPLA hpos WITH hpos+1
					ENDIF
					SKIP
				ENDDO
			CASE w_caen>=2 AND '*Epson'$p_repout	&& impresion DOS pura y hay dos objetos encimados, agrego objeto
				GO w_recpri
				SCATTE MEMVAR MEMO
				IF LEFT(m.expr,4)='iif(' AND ',""'$m.expr
					m.width=m.width+1
					m.expr=STRTRAN(m.expr,',""','+"'+CHR(14)+'"'+',"'+CHR(14)+'"')	&& caracter control
					GATHER MEMVAR MEMO
				ENDIF
				GO w_recant
				DO WHILE RECNO()<=w_recult
					SCATTE MEMVAR MEMO
					IF LEFT(m.expr,4)='iif(' AND ',""'$m.expr
						IF RECNO()=w_recult	&& para el ultimo no agrego control al dato
							m.expr=STRTRAN(m.expr,'""','"'+CHR(14)+CHR(14)+'"')	&& caracter control
						ELSE
							IF ',""'$m.expr
								m.width=m.width+1
							ENDIF
							m.expr=STRTRAN(m.expr,',""','+"'+CHR(14)+'"'+',"'+CHR(14)+'"')	&& caracter control
						ENDIF
						GATHER MEMVAR MEMO
					ENDIF
					SKIP
				ENDDO
			CASE w_caen>=2	&& mas de dos
				GO w_recpri
				SCATTE MEMVAR MEMO
				IF LEFT(m.expr,4)='iif('
					m.expr=STRTRAN(m.expr,'""',"'"+CHR(14)+"'")	&& caracter control
					GATHER MEMVAR MEMO
				ENDIF
				GO w_recant
				DO WHILE RECNO()<=w_recult
					SCATTE MEMVAR MEMO
					IF LEFT(m.expr,4)='iif('
						m.expr=STRTRAN(m.expr,'""',"'"+CHR(14)+"'")	&& caracter control
						GATHER MEMVAR MEMO
					ENDIF
					SKIP
				ENDDO
			OTHERWISE
				EXIT
			ENDCASE
			IF !EOF()
				w_recult=RECNO()
				GO w_recpri
				SCATTER MEMVAR
				GO w_recult
			ENDIF
		ENDDO
		GO w_recpri
		SKIP
	ENDDO
	*endif

	** Agrego caracter de control chr(14) cuando toda una linea tiene remove blank en windows **
	w_agrego=.F.

	*if .f.

	*index on str(vpos,9,3)+str(objtype,2) tag vpos


	GO TOP
	DO WHILE !EOF()
		IF objtype=5 OR objtype=8	&& me fijo en los gets y literales nada mas
			w_control=.T.
			SCATTER MEMVAR MEMO
			DO WHILE m.vpos=vpos AND !EOF()
				IF !norepeat
					w_control=.F.
				ENDIF
				SKIP
			ENDDO
			IF w_control	&& debo agregar el caracter de control chr(14)
				w_recno=RECNO()	&& guardo el registro donde estoy parado
				m.objtype=5	&& literales
				m.expr="'"+CHR(14)+"'"
				m.hpos=w_width
				m.width=1
				m.norepeat=.F.
				m.fillchar=''
				m.picture=''
				m.resetrpt=0
				m.totaltype=0
				m.resettotal=0
				offset=0
				supalways=.F.
				suprpcol=0
				supgroup=0
				INSERT BLANK BEFORE
				GATHER MEMVAR MEMO
				w_agrego=.T.
				***saco el .t. del norepeat de toda la fila, ya que si esta vacia
				***la linea por control la borra y me aseguro que salgan los datos
				***porque en Dos a veces no salen.
				GO w_recno	&& vuelvo donde estaba parado
				DO WHILE m.vpos=vpos AND !BOF()
					REPLACE norepeat WITH .F.
					SKIP -1
				ENDDO
				GO w_recno	&& vuelvo donde estaba parado
			ELSE	&& R.03b Mariano
				IF !BOF()
					SKIP -1
				ENDIF	&& R.03e Mariano
			ENDIF
		ENDIF
		IF !EOF()
			SKIP
		ENDIF
	ENDDO
	*set order to
	*delete tag vpos

	*endif

	*** Ajuste de la primer linea ***
	IF w_agrego	&& hay caracter de control
		w_width=w_width+1
	ENDIF
	g_width=w_width

	REPLA vpos WITH 0,;
		hpos WITH 0,;
		HEIGHT WITH IIF(EMPTY(p_repdos),d_height,p_repdos),;
		WIDTH WITH w_width, ;
		norepeat WITH w_norepeat, ;
		botmargin WITH IIF('*Epson'$p_repout, 1, IIF('*HP'$p_repout, 0, 0)) ;
		FOR objtype=1	&& el norepeat=.t. remueve las lineas en blanco del detalle

	USE

ELSE
	USE		&& cierro el report DOS (w_toes=0)
	SELE 0
	USE &p_report..frx
	w_width=WIDTH
	&& R.07b Mariano
	***vfp***
	IF VERSION()='Visual FoxPro'
		COPY TO &d0f99.y.frx TYPE fox2x
	ELSE
		COPY TO &d0f99.y.frx
	ENDIF
	***vfp***
	&& R.07e Mariano
	h_aybox=.F.
	USE
ENDIF

SELE (x_alias)
**go top
x_recno=RECNO()	&& guardo registro por impresion DOS PURO en WINDOWS XP o 2000

p_report=d0f99+'y.frx'

*acti scre
*brows
*go top
*report form &p_report preview
*go top

IF '*'$p_repout && impresion DOS pura
	p_seteo=''
	DO setprinter
ENDIF

p_repclaus='to file '+d0f99+'y.txt noconsole'

*w_sepa=set('separator')
*w_poin=set('point')
*set separator to ''
*set point to ''

SET ESCAPE ON
&& R.05b Mariano
*report form &p_report &p_repfor &p_repfor2 &p_repwhile &p_repclaus
IF VERSION()='Visual FoxPro'
	IF '*'$p_repout	&& impresora DOS puro
		REPORT FORM &p_report &p_repfor &p_repfor2 &p_repwhile
	ELSE
		REPORT FORM &p_report &p_repfor &p_repfor2 &p_repwhile &p_repclaus
	ENDIF
ELSE
	REPORT FORM &p_report &p_repfor &p_repfor2 &p_repwhile &p_repclaus
ENDIF
&& R.05e Mariano
SET ESCAPE OFF

IF LASTKEY()=p_esc
	p_cancela=.F.
ENDIF

*set separator to w_sepa
*set point to w_poin

*modi file &d0f99.y.txt noedit

WAIT WIND 'Aguarde unos instantes. Por favor!!..' NOWAIT

SELE 0

IF '*HP '$p_repout	&& impresora HP DOS puro

	** vuelvo a hacer report a otro temporario,  ya que &d0f99.y.txt queda abierto y da error en WINDOWS XP o 2000
	SELE (x_alias)
	IF BETWEEN(x_recno,1,RECCOUNT())
		GO x_recno
	ELSE
		=db_goeof(x_alias)
	ENDIF
	p_repclaus='to file '+d0f99+'x.txt noconsole'
	REPORT FORM &p_report &p_repfor &p_repfor2 &p_repwhile &p_repclaus

	SELE 0
	&& R.07b Mariano
	***vfp***
	IF VERSION()='Visual FoxPro'
		CREATE DBF &d0f99.z (reng C(254))
		COPY TO &d0f99.y TYPE fox2x
		USE &d0f99.y EXCLUSIVE
		ERASE &d0f99.z.dbf
	ELSE
		CREATE DBF &d0f99.y (reng C(254))
	ENDIF
	***vfp***
	&& R.07e Mariano

	APPEND FROM &d0f99.x.txt TYPE SDF

	*	acti scree
	*	brows
	*	set step on
	*	acti wind command
	*	acti wind debug

	p_width=w_width
	GO TOP
	DO WHILE !EOF() AND p_cancela

		SCATTER MEMVAR

		** si fin de pagina esta al final de la linea para HP DeskJet o LaserLet **
		IF AT(CHR(27)+'&l0H',m.reng)>1
			REPLA reng WITH RTRIM(LEFT(m.reng,AT(CHR(27)+'&l0H',m.reng)-1))	&& elimino caracter de control chr(27)+'&l0H
			** lo mando al principio de la siguiente linea **
			INSERT BLANK
			REPLA reng WITH SUBSTR(m.reng, AT(CHR(27)+'&l0H',m.reng),254)
			SKIP -1
		ENDIF
		***********************

		REPLA reng WITH STRTRAN(reng,CHR(27)+'&a0C','') 	&& cuando hay objetos encimados aparece control <-&a0C por lo tanto lo elimino

		p_width=MAX(LEN(RTRIM(reng)),p_width)
		SKIP
	ENDDO

	USE

	&& R.07b Mariano
	***vfp***
	IF VERSION()='Visual FoxPro'
		CREATE DBF &d0f99.x (reng C(p_width))
		COPY TO &d0f99.z TYPE fox2x
		USE &d0f99.z EXCLUSIVE
		ERASE &d0f99.x.dbf
	ELSE
		CREATE DBF &d0f99.z (reng C(p_width))
	ENDIF
	***vfp***
	&& R.07e Mariano

	APPEND FROM &d0f99.y.dbf

	w_width=p_width

ELSE

	IF '*Epson '$p_repout	&& Impresion DOS pura por windows XP o 2000
		** vuelvo a hacer report a otro temporario,  ya que &d0f99.y.txt queda abierto y da error
		SELE (x_alias)
		IF BETWEEN(x_recno,1,RECCOUNT())
			GO x_recno
		ELSE
			=db_goeof(x_alias)
		ENDIF
		p_repclaus='to file '+d0f99+'x.txt noconsole'
		REPORT FORM &p_report &p_repfor &p_repfor2 &p_repwhile &p_repclaus

		SELE 0

		** con esto no da error pero sale una hoja en blanco en predeterminada **
		*		set pdsetup to
		*		set printer to
		*		set pdsetup to p_repout

		&& R.07b Mariano
		***vfp***
		IF VERSION()='Visual FoxPro'
			CREATE DBF &d0f99.x (reng C(MIN(254,w_width+1)))
			COPY TO &d0f99.z TYPE fox2x
			USE &d0f99.z EXCLUSIVE
			ERASE &d0f99.x.dbf
		ELSE
			CREATE DBF &d0f99.z (reng C(MIN(254,w_width+1)))
		ENDIF
		***vfp***
		&& R.07e Mariano

		APPEND FROM &d0f99.x.txt TYPE SDF

	ELSE

		&& R.07b Mariano
		***vfp***
		IF VERSION()='Visual FoxPro'
			CREATE DBF &d0f99.x (reng C(MIN(254,w_width+1)))
			COPY TO &d0f99.z TYPE fox2x
			USE &d0f99.z EXCLUSIVE
			ERASE &d0f99.x.dbf
		ELSE
			CREATE DBF &d0f99.z (reng C(MIN(254,w_width+1)))
		ENDIF
		***vfp***
		&& R.07e Mariano

		APPEND FROM &d0f99.y.txt TYPE SDF

	ENDIF

	IF '*Epson '$p_repout	&& impresora Epson DOS puro
		** relleno renglon en blanco con control
		GO TOP
		DO WHILE !EOF() AND p_cancela
			IF ALLTRIM(reng)==CHR(14)
				SKIP
				IF LEN(ALLTRIM(reng))=0
					REPLA reng WITH CHR(14)
				ENDIF
			ENDIF
			IF !EOF()
				SKIP
			ENDIF
		ENDDO
	ENDIF

ENDIF

DELETE FOR ALLTRIM(reng)==CHR(14)		&& deleteo las lineas demas

REPLA reng WITH LEFT(reng,w_width-1)+' ' FOR RIGHT(reng,1)==CHR(14)	&& elimino caracter de control chr(14) final que queda

** arreglo objetos encimados **
*if .f.
w_cctrl=0
GO TOP
DO WHILE !EOF() AND p_cancela AND w_toes>0	&& solo para report windows
	SCATTER MEMVAR
	** si fin de pagina esta al final de la linea para epson 80**
	IF AT(CHR(12),reng)>1
		REPLA reng WITH RTRIM(LEFT(reng,AT(CHR(12),reng)-1))	&& elimino caracter de control chr(12)
		** lo mando al principio de la siguiente linea **
		IF '*Epson'$p_repout
			INSERT BLANK
			REPLA reng WITH CHR(12)
			SKIP -1
		ENDIF
	ENDIF
	***********************

	SCATTER MEMVAR
	w_ctrl=AT(CHR(14), reng)
	IF w_ctrl>0
		IF LEN(ALLTRIM(LEFT(m.reng,w_ctrl-1)))=0	&& control a izquierda
			SKIP -1	&& renglon anterior
			*** mergeo las dos lineas
			w_cara=MAX(w_width-LEN(LTRIM(m.reng))+1,0)	&& R.01 Mariano
			IF LEN(RTRIM(reng))<=w_cara 	&& no se enciman las dos lineas
				m.reng=LEFT(RTRIM(reng)+SPACE(w_cara),w_cara)+RIGHT(m.reng,LEN(LTRIM(m.reng))-1)
			ELSE
				w_cara=w_width-LEN(LTRIM(RIGHT(m.reng,w_width-w_ctrl)))+1
				IF LEN(RTRIM(reng))<w_cara	&& se enciman las dos lineas
					m.reng=RTRIM(reng)+RIGHT(m.reng,w_width-LEN(RTRIM(reng)))
				ELSE
					*					skip 2	&& no puede encimar porque pierde datos
					*					loop
					m.reng=RTRIM(reng)+' '+LTRIM(SUBSTR(m.reng,w_ctrl+1,WIDTH))	&& encimo al final de prepo lo que entre
				ENDIF
			ENDIF
			DELETE
			SKIP
			IF EOF()
				EXIT
			ENDIF
			GATHER MEMVAR
		ELSE
			IF LEN(ALLTRIM(RIGHT(reng,g_width-w_ctrl)))=0 AND g_width-w_ctrl>0	&& control a derecha
				DELETE
				SKIP	&& renglon siguiente
				*** mergeo las dos lineas
				w_cara=MAX(w_width-LEN(LTRIM(reng)),0)	&& R.01 Mariano
				m.reng=LEFT(RTRIM(LEFT(m.reng,w_ctrl-1))+SPACE(w_cara),MAX(w_cara,w_ctrl-1))+LTRIM(reng)
				IF EOF()
					EXIT
				ENDIF
				GATHER MEMVAR
			ENDIF
		ENDIF
	ENDIF
	IF AT(CHR(14), reng)>0 AND w_cctrl<5
		w_cctrl=w_cctrl+1
	ELSE
		w_cctrl=0
		SKIP
	ENDIF
ENDDO
*endif

REPLA ALL reng WITH STRTRAN(reng,CHR(14),'')	&& elimino caracter de control chr(14)

REPLA ALL reng WITH STRTRAN(reng,'.',' ') FOR ALLTRIM(reng)=='.'	&& elimino caracter de control . para cuando se agrega adrede

IF '*Epson '$p_repout	&& impresora Epson DOS puro

	USE

	** restauro el ancho del report **

	&& R.07b Mariano
	***vfp***
	IF VERSION()='Visual FoxPro'
		CREATE DBF &d0f99.x (reng C(w_width))
		COPY TO &d0f99.y TYPE fox2x
		USE &d0f99.y EXCLUSIVE
		ERASE &d0f99.x.dbf
	ELSE
		CREATE DBF &d0f99.y (reng C(w_width))
	ENDIF
	***vfp***
	&& R.07e Mariano

	APPEND FROM &d0f99.z.dbf

	*	if w_toes>0		&& viene de windows
	** inserto al comienzo seteos de la impresora **
	GO TOP
	INSERT BLANK BEFORE
	REPLA reng WITH p_seteo

	** salta al fin de pagina **
	GO BOTTOM
	IF AT(CHR(12),reng)=0
		&& R.07b Mariano
		*			repla reng with chr(12)+reng
		IF EMPTY(reng)
			REPLA reng WITH CHR(12)+reng
		ELSE
			APPEND BLANK
			REPLA reng WITH CHR(12)
		ENDIF
		&& R.07e Mariano
	ENDIF
	*	endif

ENDIF

&& R.07b Mariano
***vfp***
IF VERSION()='Visual FoxPro'
	SET PRINTER TO
	ERASE &d0f99.y.txt
ENDIF
***vfp***
&& R.07e Mariano
COPY TO &d0f99.y.txt TYPE SDF


w_recc=RECCOUNT()

USE

WAIT CLEAR

DO CASE
CASE p_repout='Pantalla'

	PUSH MENU _msysmenu				&& R.07 Mariano
	SET SKIP OF MENU _msysmenu .T.	&& R.07 Mariano

	w_stat=SET('status')
	SET STATUS BAR OFF

	IF h_aybox	&& impresion DOS pura

		&& R.07b Mariano
		***vfp***
		IF VERSION()='Visual FoxPro'
			DEFINE WINDOW pantalla1 ;
				AT  0.000, 0.000  ;
				SIZE 20.667,76.500 ;
				FONT 'Foxfont',7 ;
				TITLE "Pantalla"+SPACE(40)+'<Esc> -> para salir' ;
				SYSTEM CLOSE NOFLOAT NOZOOM NOMINIMIZE NOGROW NOMDI

			ACTI WINDOW pantalla1
			ZOOM WIND pantalla1 MAX
		ELSE
			DEFINE WINDOW pantalla1 ;
				AT  0.000, 0.000  ;
				SIZE 20.667,76.500 ;
				FONT 'Foxfont',7 ;
				TITLE "Pantalla"+SPACE(40)+'<Esc> -> para salir' ;
				SYSTEM

			ZOOM WIND pantalla1 MAX

			DEFINE WINDOW pantalla2 ;
				AT  0.000, 0.000  ;
				SIZE 17.667,66.500 ;
				FONT 'Foxfont',7 ;
				SYSTEM ;
				IN WINDOW pantalla1
		ENDIF
		***vfp***
		&& R.07e Mariano
	ELSE

		FOR w_i=14 TO 8 STEP -1
			IF FONTMETRIC(6,'Letter Gothic', w_i, 'N')*w_width<=SYSMETRIC(1)
				w_tfont=w_i
				EXIT
			ELSE
				w_tfont=w_i
			ENDIF
		ENDFOR

		&& R.07b Mariano
		***vfp***
		IF VERSION()='Visual FoxPro'
			DEFINE WINDOW pantalla1 ;
				AT  0.000, 0.000  ;
				SIZE 20.667,76.500 ;
				FONT 'Letter Gothic',w_tfont ;
				TITLE "Pantalla"+SPACE(40)+'<Esc> -> para salir' ;
				SYSTEM CLOSE NOFLOAT NOZOOM NOMINIMIZE NOGROW NOMDI
		ELSE
			DEFINE WINDOW pantalla1 ;
				AT  0.000, 0.000  ;
				SIZE 20.667,76.500 ;
				FONT 'Letter Gothic',w_tfont ;
				TITLE "Pantalla"+SPACE(40)+'<Esc> -> para salir' ;
				SYSTEM

			ZOOM WIND pantalla1 MAX

			DEFINE WINDOW pantalla2 ;
				AT  0.000, 0.000  ;
				SIZE 17.667,66.500 ;
				FONT 'Letter Gothic',w_tfont ;
				SYSTEM ;
				IN WINDOW pantalla1
		ENDIF
		***vfp***
		&& R.07e Mariano

	ENDIF

	&& R.07b Mariano
	***vfp***
	IF VERSION()='Visual FoxPro'
		ACTI WINDOW pantalla1

		ZOOM WIND pantalla1 MAX
	ELSE

		ZOOM WIND pantalla2 MAX

		ACTI WINDOW pantalla1
	ENDIF
	***vfp***
	&& R.07e Mariano

	IF w_recc>0 AND p_cancela

		=INKEY(0.3)	&& demora intencional

		KEYBOARD '{ctrl+home}'	&& Queda siempre en el comienzo

		&& R.07b Mariano
		***vfp***
		IF VERSION()='Visual FoxPro'
			MODI FILE &d0f99.y.txt WINDOW pantalla1 NOEDIT
		ELSE
			MODI FILE &d0f99.y.txt WINDOW pantalla2 NOEDIT
		ENDIF
		***vfp***
		&& R.07e Mariano

		KEYBOARD '{enter}'	&& cambio el lastkey()=p_esc a =p_enter
		=INKEY()
	ELSE
		WAIT WINDOW 'No hay información para mostrar'

		IF w_recc=0
			KEYBOARD '{enter}'	&& cambio el lastkey()=p_esc a =p_enter
			=INKEY()
		ENDIF

	ENDIF

	RELE WIND pantalla1,pantalla2

	SET STATUS BAR &w_stat

	POP MENU _msysmenu				&& R.07 Mariano

CASE p_repout='Archivo'

	
	IF !EMPTY(p_repfile) AND p_cancela
		SET SAFETY OFF
		COPY FILE &d0f99.y.txt TO &p_repfile
	ENDIF

OTHERWISE	&& impresion DOS pura arreglando la salida

	DO CASE
	CASE p_reptype2='Pantalla'
	CASE p_reptype2='Archivo'
	OTHERWISE	&& impresora

		SET CONSOLE OFF
		*				set heading off
		*				set printer to &p_reptype2.
		*				Imprimo el archivo con !type >&p_reptype2. en represet()
		*				type &d0f99.y.txt to printer
		*				set heading on

	ENDCASE

ENDCASE

SELE(x_alias)

p_repclaus='noconsole preview'

RETURN


***************
PROC setprinter
***************
**mantengo las que puedo cambiar, para restaurar en represet**
p_dparms7=_pdparms[7]
p_dparms8=_pdparms[8]
p_dparms9=_pdparms[9]
p_dparms10=_pdparms[10]

SELE 0
USE &p_report

DO CASE
CASE '*HP '$_PDSETUP
	DO CASE
	CASE w_width<=80
		_pdparms[8]="(s10H"
	CASE w_width<=97
		_pdparms[8]="(s12H"
	CASE w_width<=137
		_pdparms[8]="(s16.7H"
	CASE w_width<=161
		_pdparms[8]="(s20H"
	CASE w_width<=173 AND 'Laser'$_PDSETUP
		_pdparms[8]="(s22H"
	CASE w_width<=187 AND 'Laser'$_PDSETUP
		_pdparms[8]="(s24H"
	CASE w_width<=193 AND 'Deskjet'$_PDSETUP
		_pdparms[8]="(s22H"
	CASE w_width<=204 AND 'Laser'$_PDSETUP
		_pdparms[8]="(s26H"
	CASE w_width<=226 AND 'Laser'$_PDSETUP
		_pdparms[8]="(s28H"
	CASE w_width<=235 AND 'Laser'$_PDSETUP
		_pdparms[8]="(s30H"
	CASE w_width<=254 AND 'Laser'$_PDSETUP
		_pdparms[8]="(s32H"
	OTHERWISE
		_pdparms[7]="&l8D"
		_pdparms[10]="&l1O"
		IF 'Laser'$_PDSETUP	&& >254
			_pdparms[8]="(s26H"
		ELSE						&& >193
			_pdparms[8]="(s22H"
		ENDIF
	ENDCASE
	DO CASE
	CASE _pdparms[10]="&l1O"	&& lanscape
		_pdparms[7]="&l8D"
		REPLA HEIGHT WITH 58 FOR objtype=1
	CASE 'Carta'$_PDSETUP
		IF 'Laser'$_PDSETUP
			REPLA HEIGHT WITH 62 FOR objtype=1
		ELSE
			REPLA HEIGHT WITH 60 FOR objtype=1
		ENDIF
	CASE 'A4'$_PDSETUP
		IF 'Laser'$_PDSETUP
			REPLA HEIGHT WITH 68 FOR objtype=1
		ELSE
			REPLA HEIGHT WITH 66 FOR objtype=1
		ENDIF
	CASE 'Oficio'$_PDSETUP
		IF 'Laser'$_PDSETUP
			REPLA HEIGHT WITH 74 FOR objtype=1
		ELSE
			REPLA HEIGHT WITH 72 FOR objtype=1
		ENDIF
	ENDCASE
CASE '*Epson'$_PDSETUP
	DO CASE
	CASE w_width<=80
		_pdparms[8]="P"
	CASE w_width<=97
		_pdparms[8]="M"
	CASE w_width<=137
		_pdparms[8]=""
	CASE w_width<=161
		_pdparms[8]="M"
	OTHERWISE	&& >161
		_pdparms[8]="M"
	ENDCASE
	DO CASE
	CASE 'Carta'$_PDSETUP
		_pdparms[8]="CB"+_pdparms[8]
		REPLA HEIGHT WITH 62 FOR objtype=1
	CASE 'A4'$_PDSETUP
		_pdparms[8]="CH"+_pdparms[8]
		REPLA HEIGHT WITH 68 FOR objtype=1
	CASE 'Oficio'$_PDSETUP
		_pdparms[8]="CN"+_pdparms[8]
		REPLA HEIGHT WITH 74 FOR objtype=1
	ENDCASE
	p_seteo=_pdparms[8]
	_pdparms[8]=""
ENDCASE

USE
SELE (x_alias)

RETURN
