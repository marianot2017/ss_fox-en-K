**ver code page determinado a las bases del directorio determinado
parameters x_dire

do case
	case parameters()=0
		x_dire=''
endcase


dime w_file(1)
w_cant=adir(w_file, x_dire+'*.dbf')

close data

for w_i=1 to w_cant

	if !w_file(w_i,1)='FOXUSER.DBF')
	
		x_file=x_dire+w_file(w_i,1)
	
		use &x_file alias file

		wait windo w_file(w_i,1)+' CP:'+alltrim(str(cpdbf('file'),10))

		use
	endif
	
endfor

close data

return
