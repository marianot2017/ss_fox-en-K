**pone code page determinado a las bases del directorio determinado
parameters x_dire, x_cpage

do case
	case parameters()=0
		x_dire=''
		x_cpage=0
	case parameters()=1
		x_cpage=0
endcase


dime w_file(1)
w_cant=adir(w_file, x_dire+'*.dbf')

for w_i=1 to w_cant

	do cpzero with (x_dire+w_file(w_i,1)), (x_cpage)

endfor

return
