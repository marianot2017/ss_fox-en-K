**-------------------------------------------------------------------
**
** 24/02/94    COMWIN.PRG
**
** Foxpro Command Window Emulator.
**
** Opens a window similar to the one Fox displays and lets you 
** enter any FOX command. Eg use,replace,brow,locate etc You can
** even write programs (MODI COMM {filename}) but you have to 
** compile them by typeing COMP {filename} the system menu compile
** option is disabled. As with FOX type QUIT to quit out.
**
** Do not run from within another FOXPRO program, run it from the DOS
** prompt (FOXR -t COMWIN) because if while running COMWIN you issue
** say for example CLEAR ALL or CLOSE DATABASE, these commands will effect
** the environment that called COMWIN. (NB. YOU CANT COMPILE PROGRAMS IF 
** YOU RUN COMWIN USING FOXR)
**
** Some code would need to be added to save windows and variables to 
** protect them from CLEAR/CLOSE etc (save to.../restore from...) to
** make it safe to run from an application.
**
**
** VARIABLES
**			COMHIST		- command history array
**			HISTLINE	- when scrolling through command history with
**						  cursor up/down keys it controls what history 
**						  line you are on.
**			HISTCOMSIZE	- declares the maximum command history array size
**			COMLINE		- the command line entered via a GET statement
**			HISTSIZE	- the total number of commands currently stored in 
**						  the history array. This will grow up to a maximum
**						  of HISTCOMSIZE
**
** PROCEDURES
**			SAVECOM		- procedure that saves a command in the history
**						  array. The most recent command always resides
**						  in element 1 of the array. Previous commands
**						  are shuffled down prior to saving a command
**						  in element 1
**			ERRHAND		- A simple error handling/displaying procedure
**
**
** Anyway it was fun to write and I hope you find it useful,
** but more to the point, it will alow you to properly support an 
** application on a customer site without illegally installing a copy of
** foxpro. (and none of us do that do we!!!!!)
**
** (c)1994 Phillip.G Harding
**--------------------------------------------------------------------

set talk off
set escape off
set sysmenu on

clear
on error do errhand with ERROR(), PROGRAM(), LINENO(), message(), message(1)

HISTCOMSIZE=40
declare comhist(HISTCOMSIZE,1)
** default 40 line command history
** If you want to increase/decrease the command history size just change
** the variable HISTCOMSIZE

define window uwin from 5,2 to 20,70 system grow zoom float font 'Arial',10 &&COLOR gr+/wb,g+/b,B+/gb,b/gb,G+/gb
define window commwin from 17,1 to 23,50 system grow zoom float title ' Command ' COLOR w+/gb+,W+/gb+,w/w,gr+/w,G+/w shadow
define window datawin from 0,0 to 24,79  system nofloat nozoom nogrow
password=''

activate window datawin
activate window commwin
@ 4,0 say '.Password=' get password size 1,10 color ,b/b
read 

if upper(password)<>'SYSPASS'
	release window commwin
	release window uwin
	release window datawin
	clear all
	close all
	clear
	? chr(07)
	on error
	set talk on
	set escape on
	set sysmenu on
	clear 
	RETURN
endif

comline=''
histline=0
histsize=0
comline=space(47)

do while upper(comline)<>'QUIT'
	@ 4,0 say "." 
	@ 4,1 get comline
	read
	keypress=readkey()
	if keypress=36
		wait window "Foxpro Command Window Emulator.                                          " timeout 10
		wait window "Press Up/Down keys for command history, type quit to quit out" timeout 10
		loop
	endif
	if keypress=4 or keypress=5 or keypress=12 or keypress=268
		if keypress=4
			histline=histline+1
			if (histline>histsize)
				histline=histsize
			endif		
		endif
		if keypress=5
			histline=histline-1
			if histline<1
				histline=1
			endif		
		endif
		if keypress=12 or keypress=268
			comline=space(37)
		else
			if histsize>0
				comline=comhist(histline,1)
			endif
		endif
	else
		if len(alltrim(comline))>0
			do savecomm
		endif
		scroll 0,0,4,47,1,0
		if upper(comline)<>'QUIT'
			histline=0
			if upper(comline)='BROW' or upper(comline)='BROWSE'
				comline=comline+' window uwin'
			endif
			activate window datawin
			set talk on
			show window commwin
			&comline
			set talk off
			activate window commwin
			comline=space(47)
		endif
	endif
enddo

release window commwin
release window uwin
release window datawin

clear all
close all
clear

on error
set talk on
set escape on
set sysmenu automatic
RETURN

PROCEDURE savecomm
PRIVATE loop
	** shuffle all previous commands up the array so the latest command
	** can reside in element 1
	for loop=(HISTCOMSIZE-1) to 1 step -1
		store comhist(loop,1) to comhist(loop+1,1)
	endfor	
	store comline to comhist(1,1)
	if histsize<HISTCOMSIZE
		histsize=histsize+1
	endif
RETURN

PROCEDURE errhand
PARAMETER merror, mprog, mlineno, merrstr, mcodelin
PRIVATE errstr
	set talk off
	store '' to errstr
	if merror<>16
		errstr=errstr+'Err('+ alltrim(str(merror))+') '
		errstr=errstr+'Line('+alltrim(str(mlineno))+') '
		errstr=errstr+'Program('+mprog +') '
		errstr=errstr+'['+merrstr+']'
	else
		errstr='Unrecognised Command'
	endif
	wait window errstr timeout 3 
	wait window '['+mcodelin+']' timeout 1 
RETURN
** The one Fox displays and lets you
** enter any FOX command. Eg use,replace,brow
