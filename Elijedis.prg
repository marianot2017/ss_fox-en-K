EXTERNAL PROC ELIJEDIS.SCX

DO FORM "ELIJEDIS.SCX" NAME _1S1081W1V LINKED 

*- [CONVERTER] Begin CLEANUP and other procedures from 2.x Form

PROC CICLOPATH
keyb '{ctrl+o}'
RETURN


function velige

if upper(e_defa)$upper(w_path)
	=advsuave('No se puede elegir directorio de sistema ')
	return .f.
endif
if !dispOk(w_path)
	=advsuave('No se tiene permiso Read/Write a este directorio')
 	return .f.
endif

clear read
return




*- [CONVERTER] End CLEANUP and other procedures from 2.x Form