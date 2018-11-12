TT=1
CC=""
on error do pasaerr with error(), lineno(), program(), TT, cc
SELECT 0
USE INGRESOS EXCLU
SELECT 0
USE INGRESOS
RETURN

do while .t.
	y=inkey()
	if lastkey()=27
		exit
	endif
	?lastkey()
enddo
	