close data
w_dire='report\'
cant=adir(w_file,w_dire+'*.frx')
wait wind 'Se encontraron '+str(cant,5)+' archivos'
for i=1 to cant
	w_nomb=w_dire+w_file(i,1)
	use &w_nomb.
	locate for "sj"$expr
	if found()
		replace expr with strtran(expr,'sj','ga') all
		use
	else 
		use
	endif
endfor

return

close data
w_dire='screen\'
cant=adir(w_file,w_dire+'*.scx')
wait wind 'Se encontraron '+str(cant,5)+' archivos'
for i=1 to cant
	w_nomb=w_dire+w_file(i,1)
	use &w_nomb.
	locate for "sj"$name
	if found()
		replace name with strtran(name,'sj','ga') all
		use
	else 
		use
	endif
endfor

return

close data
w_dire='menu\'
cant=adir(w_file,w_dire+'*.mnx')
wait wind 'Se encontraron '+str(cant,5)+' archivos'
for i=1 to cant
	w_nomb=w_dire+w_file(i,1)
	use &w_nomb.
	locate for "sj"$command
	if found()
		replace command with strtran(command,'sj','ga') all
		use
	else 
		use
	endif
endfor

return

