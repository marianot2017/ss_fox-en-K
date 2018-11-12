
m.olderr = ON("ERROR")
close data
PUBLIC m.errdbf
m.errdbf = "errdemo.dbf"
ON ERROR DO ERRORHANDLER WITH LINENO(1), PROGRAM() , ;
		 MESSAGE(), MESSAGE(1), ERROR(), WLAST(), WREAD(), WONTOP(), ;
		  DBF(),ALIAS(),RECNO()

Wait window "About to set up a demo error trap..." timeout 2

m.test =    && create an error


m.testmac = "ON ERROR "+m.olderr  && restore the error handler
&testmac
select errordbf
browse
SET SAFETY ON
*-------------------------------------------------------------------------*
* Procedure ERRORHANDLER
* Syntax......:  ON ERROR DO ERRORHANDLER WITH LINENO(1), PROGRAM() ,;
*                MESSAGE(), MESSAGE(1), ERROR(), WLAST(), WREAD(), WONTOP(), ;
*                 DBF(),ALIAS(),RECNO()
*
* Argument(s).: any number of string lines, color scheme button 
*                     button text, default button
* Return(s)...:  
* Purpose.....: handles all errors and writes out records
* Notes.......: 
* Assumes.....: 
*
* Based on the Work of Lisa Slater and Steven Arnott, from USING FOXPRO 2.0
* for DOS -- Que Publishing
*
* Revised   By  Description
* ========  === ==========================================================
* 
* 
*-------------------------------------------------------------------------*
PROCEDURE ERRORHANDLER
PARAMETERS errlineno,errprog, errmsg,errline, errno;
    lastwind,readwind,topwind, dbfused, aliasused, err_rec
    
PRIVATE m.nestdepth,m.choice,m.system
PRIVATE m.oldsel, m.oldtag, m.oldrec

m.oldsel = SELECT()
m.oldtag = ORDER()
m.oldrec = recno()


ON ERROR
m.choice = ""

DO CASE 
CASE ERROR() = 125
	*
	* printer not ready in the middle of a run
	*
	*!PRINTER NOT READY
	 
	m.message = "THE PRINTER HAS GONE OFF LINE;"
	m.message = m.message + "YOU MAY FIX AND RETRY;"
	m.message = m.message + "OR STOP THE PRINTOUT;"
	m.message = m.message + "AND RETURN TO THE MENU"
    m.bt_str = "\!\<Retry;\<Stop"
    m.choice = alert(m.message,7,m.bt_str,1)
   
IF  "Retry" $ m.choice
   do Reset_err
   RETRY
ELSE
   do Reset_err
   RETURN
ENDIF
   

CASE ERROR() = 216
	*
	* Extended display mode not available.
	*
	WAIT WINDOW "Extended mode not available" NOWAIT
	m.err_flag = MESSAGE()
	RETURN
	
CASE ERROR() = 109
	*
	*! Record in use by another.
	*
	m.message = "RECORD IS CURRENTLY IN USE;"
	m.message = m.message + "BY ANOTHER;"
	m.message = m.message + "RETRY OR EXIT THE PROGRAM;"
	m.message = m.message + "AND REPORT THE ERROR"
    m.bt_str = "Retry;Exit"
    m.choice = alert(m.message,7,m.bt_str,1)
 
IF m.choice = "Retry"
   do Reset_err
   m.err_flag = MESSAGE()
   RETRY
ENDIF

CASE ERROR() = 108
	*
	*! File is in use by another.
	* Can also be a result of collision in APPEND BLANK.
	* Also is the error message for exclusive use conflicts
	* on NETWARE
	m.message = "FILE IS CURRENTLY IN USE;"
	m.message = m.message + "BY ANOTHER;"
	m.message = m.message + "RETRY OR EXIT THE PROGRAM;"
	m.message = m.message + "AND REPORT THE ERROR"
    m.bt_str = "Retry;Exit"
    m.choice = alert(m.message,7,m.bt_str,1)
  
IF m.choice = "Retry"
    do Reset_err  
     m.err_flag = MESSAGE()
   RETURN
ENDIF

CASE ERROR() = 1705
*! FILE ACCESS DENIED
* OCCURS WHEN AN EXCLUSIVE USE REQUESTS FAILS
* OR SOMEONE REQUESTS TO SHARE A FILE THAT IS OPENED EXCLUSIVELY
* ON PERSONAL NETWARE!!
*
*       m.message = "FILE IS READ/ONLY OR OPENED EXCLUSIVELY;"
*       m.message = m.message + "RETRY OR EXIT THE PROGRAM;"
*       m.message = m.message + "AND REPORT THE ERROR"
*    m.bt_str = "Retry;Exit"
*    m.choice = alert(m.message,7,m.bt_str,1)

  
* IF m.choice = "Retry"
   do Reset_err
   m.err_flag = MESSAGE()  
   RETURN
* ENDIF


 


ENDCASE



SET PRINT OFF
SET CONSOLE ON
SET DEVICE TO SCREEN

 
USE (m.errdbf) in 0 alias ERRORDBF
SELECT ERRORDBF

APPEND BLANK
SAVE WINDOWS ALL TO MEMO SNAPSHOT

REPLACE errdate WITH DATE()
REPLACE errtime WITH TIME()

WAIT "ERROR PROCESSING..." WINDOW NOWAIT


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

* REPLACE listing WITH                                            + CHR(13) ADDITIVE
* REPLACE listing WITH                                            + CHR(13) ADDITIVE
* REPLACE listing WITH                                            + CHR(13) ADDITIVE
* REPLACE listing WITH                                            + CHR(13) ADDITIVE
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
* m.errtext = "An error has occurred;Contact your supervisor;"
* m.errtext = m.errtext + "Be ready to describe;the nature of the problem;"
* m.errtext = m.errtext + "Thank you!;"   
* = ALERT(m.errtext,7,"Okay",1)
do errinput.spr   
 
*!*********************************************************************
*!
*
PROCEDURE Reset_err
ON ERROR DO errorhandler  WITH LINENO(1), PROGRAM(),;
    MESSAGE(), MESSAGE(1), ERROR(),;
    WLAST(), WREAD(), WONTOP(), DBF(),ALIAS(),RECNO()

*!*********************************************************************
*-------------------------------------------------------------------------*
FUNCTION path_exr
* Syntax......: m.pathval = path_exr(m.datadbf)
* Argument(s).: string containing the path you want to extract
* Return(s)...: path with the last '\' included
* Purpose.....: extract a path from a string
* Notes.......:
*
*
*
* Revised   By  Description
* ========  === ==========================================================
*


PARAMETERS pathstring
PRIVATE m.sl_loc, m.pathval 

m.sl_loc = RAT("\",pathstring)
m.pathval = left(pathstring,m.sl_loc)
return m.pathval
