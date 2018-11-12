clear
*	do mensa with 5, "***Documentaci¢n de errores***"
	@ 5,0 clear to 23,79
*	do mensa with 24,replicate(" ",80)

*	do pane_bie with  6,8 , 22,70
	define window verifi ;
		from 7,9 to  19,69 ;
		title "Documentaci¢n de errores" ;
		footer "<ESC> para salir" ;
		nofloat ;
		noclose ;
		nominimize;
		color scheme 1

	if !used('errordbf')
		select 0
		use errdemo alias errordbf
		if flock("errordbf")
			use errdemo alias errordbf exclusive
		endif
	endif

	@ 21,10 say "<F4> --> borrado"
	@ 21,31 say "<F8> --> listado"
	@ 21,50 say "<F12> --> ver memo"

	activate window verifi

	on key label f4 do hacer
	on key label f8 do hacer
	on key label f12 keyboard '{ctrl+pgup}'
	on key label esc keyboard(chr(23))
	on key label mouse do donde
	tecla=""

	browse fields errdate  :h="DIA" :w=.f., errtime  :h="HORA" :w=.f.,  errdata :r, snapshot :r, listing :r, usernotes :r in window verifi noappend nodelete color scheme 7   

	on key label esc
	on key label f12
	on key label f8
	on key label f4
	on key label mouse

	deactivate window verifi

	clear
return

function hacer
do case
	case lastkey()=-3 or tecla="F4"
		if reccount()>0
			wait "Borra del comienzo hasta aqui inclusive (Si/No)" to borra window
			if upper(borra)="S"
				regi=recno()
				delete for recno()<=regi
				deactivate window verifi
				set deleted off
				pack
				go top
				activate window verifi
			endif
		endif
	case lastkey()=-7 or tecla="F8"
		if reccount()>0
			wait "lista del comienzo hasta aqui inclusive (Si/No)" to lista window
			if upper(lista)="S"
				deactivate window verifi
				save screen to panta1
				do prepimp
				set device to print
				on escape do termi
				@prow()+1,20+5*xwin say "DOCUMENTACION DE ERRORES"  font 'Courier New', xtam style xest
				regi=recno()
				go top
				do while recno()<=regi
					set date british
					set century on
					scatter memvar memo
					@prow()+1,1 say replicate("*",79)
					@prow()+1,1 say m.errdate
					@prow(),12 say m.errtime
					@prow()+1,1 say replicate("*",79)
					@prow()+1,1 say "Errdata:"
					do impre1 with m.errdata, len(m.errdata)
					@prow()+1,1 say replicate("*",79)
					@prow()+1,1 say "Snapshot:"
					@prow()+1,1 say "guarda pantalla"
**					do impre2 with m.snapshot, len(m.snapshot)
					@prow()+1,1 say replicate("*",79)
					@prow()+1,1 say "Listing:"
					do impre1 with m.listing, len(m.listing)
					@prow()+1,1 say replicate("*",79)
					@prow()+1,1 say "Usernotes:"
					do impre1 with m.usernotes, len(m.usernotes)
					@prow()+1,1 say replicate("*",79)
					@prow()+1,1 say ""
					skip
				enddo
				on escape ?? ""
				set device to screen
				restore screen from panta1
				activate window verifi
			endif
		endif
endcase
return

procedure termi
on escape ?? ""
close data
do campagd
set device to screen
set console off
return to rescuen


procedure donde
	deactivate window verifi 
	do case
		case (mcol()>=10 and mcol()<=25) and mrow()=21
			activate window verifi
			tecla="F4"
			wait
			do hacer
		case (mcol()>=31 and mcol()<=46) and mrow()=21
			activate window verifi
			tecla="F8"
			wait
			do hacer
		case (mcol()>=50 and mcol()<=67) and mrow()=21
			activate window verifi
			keyboard '{ctrl+pgup}'
		case (mcol()>=31 and mcol()<=46) and mrow()=19
			activate window verifi
			keyboard(chr(23))
		otherwise
			activate window verifi
	endcase
	tecla=""
return

procedure impre1
	parameter varstr, tot
	if tot>0
		j=1
		ante=0
		do while ante<tot
			enter=at(chr(13), varstr,j)
			if enter=0 
				exit
			endif
			@prow()+1,1 say substr(varstr,ante+1,enter-(ante+1))
			ante=enter
			j=j+1
		enddo
	else
		@prow()+1,1 say " "
	endif
return

procedure impre2
	parameter varstr, tot
	if tot>0 and tot>254
		j=1
		do while j<tot
			@prow()+1,1 say substr(varstr, j, 254)
			j=j+254
		enddo
	else
		@prow()+1,1 say varstr
	endif
return