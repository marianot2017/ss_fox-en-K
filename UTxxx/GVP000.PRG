para p_par1

if parameters()=0
	p_par1='NO'
endif
set resou off

clear

_refox_=(9876543210)
_refox_=(9876543210)


if file('sopo.123')
	* Para trabajar en el cliente
	dele file sopo.123
	set sysmenu to defa
	clear macros
	do comwin
	clear all
	on error
	cancel
else 
	quit
endif

