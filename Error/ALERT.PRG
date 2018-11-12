*-------------------------------------------------------------------------*
* Procedure ALERT
* Syntax......: m.choice = alert("line1;line2;line3",8,"a;b;c",1,"","")
* Argument(s).: any number of string lines, color scheme button 
*                     button text, default button
*               windows only
*               window title
*				bitmap pointer -- "exclaim" or "question"
* Return(s)...: the text of the button selected 
* Purpose.....: making choices and branching
* Notes.......: 
* Assumes.....: 
*
*  
*  
*
*
* Revised   By  Description
* ========  === ==========================================================
* 
* 
*-------------------------------------------------------------------------*

PROCEDURE alert
PARAMETERS strg, cscheme, buttons, action, wtitle,iconpoint


PRIVATE i,numparams,dflts,m.numlines,m.numbuts,m.remain,m.strg,m.maxlen
PRIVATE m.maxbut, m.top_row, m.top_col,m.bot_row,m.bot_col
PRIVATE but_arry, alrt_arry, m.butsize, m.retval
IF _DOS
SET TALK OFF

in_cons = SET('CONSOLE')

numparams = 4
DIMENSION dflts[numparams,2]
dflts[1,1] = "STRG"
dflts[2,1] = "CSCHEME"
dflts[3,1] = "BUTTONS"
dflts[4,1] = "ACTION"
dflts[1,2] = ''
dflts[2,2] = 7
dflts[3,2] =''
dflts[4,2] = 0

FOR i = 1 TO numparams
   IF PARAMETERS() < i
      vname = dflts[i,1]
      &vname = dflts[i,2]
   ENDIF
ENDFOR

m.numlines = OCCURS(';',strg) + 1          && number of message lines
IF !EMPTY(buttons)
   m.numbuts  = OCCURS(';',buttons) + 1    && number of buttons
ELSE
   m.numbuts = 0
ENDIF

DIMENSION alert_arry[numlines]

IF numbuts > 0
   DIMENSION but_arry[numbuts]
ELSE
   DIMENSION but_arry[1]
ENDIF

m.remain = m.strg
m.maxlen = 0
FOR i = 1 TO m.numlines
   IF AT(';',m.remain) > 0
      alert_arry[i] = SUBSTR(m.remain,1,AT(';',m.remain)-1)
      alert_arry[i] = CHRTRAN(alert_arry[i],';','')
      m.remain = SUBSTR(m.remain,AT(';',m.remain)+1)
   ELSE
      alert_arry[i] = m.remain
      m.remain = ''
   ENDIF
   IF LEN(alert_arry[i]) > SCOLS() - 6
      alert_arry[i] = SUBSTR(alert_arry[i],1,SCOLS()-6)
   ENDIF
   IF LEN(alert_arry[i]) > m.maxlen
      m.maxlen = LEN(alert_arry[i])
   ENDIF
ENDFOR

m.remain = m.buttons
m.maxbut = 0
FOR i = 1 TO m.numbuts
   IF AT(';',m.remain) > 0
      but_arry[i] = SUBSTR(m.remain,1,AT(';',m.remain)-1)
      but_arry[i] = CHRTRAN(but_arry[i],';','')
      m.remain = SUBSTR(m.remain,AT(';',m.remain)+1)
   ELSE
      but_arry[i] = m.remain
      m.remain = ''
   ENDIF
   IF LEN(but_arry[i]) > m.maxbut
      m.maxbut = LEN(but_arry[i])
   ENDIF
ENDFOR

IF !EMPTY(buttons)
   m.numlines = m.numlines + 2
ENDIF

m.butsize = m.numbuts * (m.maxbut + 3)    && chevrons + space
IF m.butsize > m.maxlen
   m.maxlen = m.butsize
ENDIF

m.top_row = INT( (SROWS() - 4 - m.numlines) / 2)
m.bot_row = m.top_row + 3 + m.numlines

m.top_col = INT((SCOLS() - m.maxlen - 6) / 2)
m.bot_col = m.top_col + m.maxlen + 6

DEFINE WINDOW alert FROM m.top_row,m.top_col TO m.bot_row,m.bot_col;
   DOUBLE shadow FLOAT COLOR SCHEME (cscheme)
ACTIVATE WINDOW alert

IF !EMPTY(buttons)
   FOR i = 1 TO m.numlines - 2
      @ i,3 SAY PADC(alert_arry[i],m.maxlen)
   ENDFOR
   m.butpos = 3 + (m.maxlen - m.butsize)/2
   @ m.numlines,m.butpos GET action FUNCTION '*H' PICTURE buttons SIZE 1,m.maxbut+2,1  
    
   READ  cycle MODAL
ELSE
   FOR i = 1 TO m.numlines
      @ i,3 SAY PADC(alert_arry[i],m.maxlen)
   ENDFOR

   SET CONSOLE OFF
   =INKEY(0,'HM')
   SET CONSOLE ON
ENDIF
RELEASE WINDOW alert

IF in_cons = "OFF"
   SET CONSOLE OFF
ENDIF
but_arry[action] = strtran(but_arry[action],"\","")
but_arry[action] = strtran(but_arry[action],"<","")
RETURN alltrim(but_arry[action])

ELSE
  IF !used('bitmaps')
     use (m.nethmdir+'\dbfs\bitmaps') in 0 alias bitmaps 
  ENDIF
  
  m.strg = strtran(m.strg,";",chr(13))
  IF PARAMETERS() < 6
     iconpoint = "bitmaps.exclaim"
  endif
  m.retval = wmsgbox(m.strg,wtitle,iconpoint, m.buttons) 
  return (alltrim(m.retval))
ENDIF


*******************************************************************************
*   File........: wmsgbox.prg
*   Date........: June 26, 1994
*   Author......: Ly Minh Tri (CIS 73062,512)
*   Copyright...: Copyright (c) 1993, Tri M. Ly
*   Version.....: 2.04
*******************************************************************************
*   PURPOSE:    WMsgBox will place the given message in a window at the given
*               coordinates (or centered if -1 was passed).  The message may be
*               broken into multi-lines by embedding a CHR(13) in the message
*               string.  Mimics function MsgBox() found in FOXTOOLS.FLL.
*               However, the following features are included:
*
*                      User-definable button options
*                      Option to return numeric value
*                      Option to specify message's font, size, and style
*                      Option to specify message font's color
*                      Option to specify justification of message in window
*                      Option to specify help messages for buttons
*                      Option to specify VALID routine for valid clause
*                      Option to specify window border style
*
*   SYNTAX:     wmsgbox (<cmsg>, <ctitle>, <ctype>, <cprompt>, <nrow>, <ncol>,
*                       [<cjust>], [<cfont>], [<nsize>], [<cstyle>],
*                       [<cncolor>], [1], [<chelp>], [<cvalfunc>],
*                       [<cnborder>])
*
*   PARAMETERS: <cmsg>      - The messages to display...each line separated
*                             by a carriage return, CHR(13).
*               <ctitle>    - The title for the message window. Defaults to
*                             "System Message"
*               <ctype>     - Type of ICON to display with dialog or the file
*                             name of the ICON to display or the field name
*                             of the ICON to display.  Icon must be 36 x 36
*                             in size.  The alias may be included with the
*                             field name.
*               <cprompt>   - The options to choose from. Pass empty string
*                             to display message without waiting for user
*                             input.
*               <nrow>      - The row where top of window starts. Pass -1
*                             to have window centered.
*               <ncol>      - The column where left of window starts. Pass
*                             -1 to have window centered.
*               <cjust>     - Optional justification of message. Default is
*                             left justification.
*               <cfont>     - Optional font type.
*               <nsize>     - Optional Size of cfont.
*               <cstyle>    - Optional Style of cfont.
*               <cncolor>   - Optional Color string for given font.  Will
*                             accept a color string that is valid for an
*                             @...SAY command.  A color scheme or RGB(...)
*                             color style may be passed as well.  For color
*                             scheme, pass the scheme number; for RGB(...)
*                             enclosed the RGB(...) specification in quotes.
*               <1>         - Optional, if a 1 is passed in, then function
*                             returns a number indicating which button was
*                             chosen.
*               <chelp>     - Optional help message for buttons.  Separate
*                             each button message by a semi-colon (similar
*                             to how each button is separated!)
*               <cvalfunc>  - Optional name of function to be called when
*                             a button is selected.  WMsgBox() will clear
*                             its read only when this function returns .T.!
*                             To determine which button was selected, you
*                             can use the _CUROBJ value in your validation
*                             routine.
*               <cnborder>  - The characters defining the window border,
*                             or the number indicating system border type.
*                             The border string must be in this format:
*                             1st and 2nd chars are top and bottom
*                             3rd and 4th chars are the sides
*                             5th and 6th chars are top left/right corners
*                             7th and 8th chars are bottom left/right corners.
*
*                             Example: "ÄÄ³³Ú¿ÀÙ" will yield a single border
*                                      window.
*                                                                             
*   RETURNS:    Character or Numeric.
*
*******************************************************************************
FUNCTION wmsgbox

PARAMETERS  cmsg, ctitle, ctype, cprompt, nrow, ncol, cjust, ;
            cfont, nsize, cstyle, cncolor, nnumeric, chelp, ;
            cvalfunc, cnborder

PRIVATE lvisible,   cdevice,    retval,     nselect,    cbitmaps,	cudfparm
PRIVATE cwinsave,   cprinter,   cconsole,   ciconfile,  i
PRIVATE nbuttons,   ndefault,   nbutwidth,  nbutsize,   nbutheight, dbfields_
PRIVATE cbfont,     nbsize,     cbstyle,    ngap,       nmaxstr,    aclrset
PRIVATE nwwidth,    nwheight,   nmaxlen,    nmaxline,   nsayrow,    nicongap
PRIVATE nwfheight,  nchoice,    amsg,       aprompt,    nsaycol,    lpicbut
PRIVATE nbfheight,  nbfwidth,   nwbwidth,   nloc1,      nloc2
PRIVATE amsgclr,    nmaxrow,    cstatmesg,  aborder
PRIVATE k_saycolor, k_icongap,  k_iconwidth, k_iconheight

*
* Release message window if it already exists...and clear the keyboard
* buffer
*
RELEASE WINDOW wmsgbox
CLEAR TYPEAHEAD
DO WHILE CHRSAW()
    = INKEY(0.1)
ENDDO

IF EMPTY(cmsg)
    RETURN ""
ENDIF

PUSH KEY CLEAR

*
* Declare some psuedo-constants so WMSGBOX() will recognize the type of
* icons and type of dialog to initiate.
*
#DEFINE K_LEFTJUST          "L"
#DEFINE K_CENTERJUST        "C"
#DEFINE K_RIGHTJUST         "R"

#DEFINE K_NORMALSTYLE       "N"
#DEFINE K_BOLDSTYLE         "B"
#DEFINE K_ITALICSTYLE       "I"
#DEFINE K_ITALICBOLDSTYLE   "BI"

#DEFINE K_OK                "OK"
#DEFINE K_CONTINUE          "C"
#DEFINE K_OKCANCEL          "OKC"
#DEFINE K_YESNO             "YN"
#DEFINE K_YESNOCANCEL       "YNC"
#DEFINE K_RETRYCANCEL       "RC"
#DEFINE K_ABORTRETRYIGNORE  "ARI"

#DEFINE K_NONE_BORDER       1
#DEFINE K_SINGLE_BORDER     2
#DEFINE K_DOUBLE_BORDER     3
#DEFINE K_PANEL_BORDER      4
#DEFINE K_SYSTEM_BORDER     5

#DEFINE K_ICONHAND          "HAND"
#DEFINE K_ICONQUESTION      "?"
#DEFINE K_ICONEXCLAMATION   "!"
#DEFINE K_ICONASTERISK      "*"
#DEFINE K_ICONINFORMATION   "INFO"
#DEFINE K_ICONSTOP          K_ICONHAND
#DEFINE K_RETURN            CHR(13)
#DEFINE K_MAXREADLEVEL      5
#DEFINE K_CONTACTNAME       "your developer!"       &&  Your name goes here!

*
* Foreground Character Code Colors to use with WMsgBox()
*
#DEFINE K_BLACK             "{N}"
#DEFINE K_BLUE              "{B+}"
#DEFINE K_CYAN              "{BG+}"
#DEFINE K_DRKBLUE           "{B}"
#DEFINE K_DRKCYAN           "{BG}"
#DEFINE K_DRKGREEN          "{G}"
#DEFINE K_DRKMAGENTA        "{RB}"
#DEFINE K_DRKRED            "{R}"
#DEFINE K_DRKYELLOW         "{GR}"
#DEFINE K_DRKGRAY           "{N+}"
#DEFINE K_GRAY              "{W}"
#DEFINE K_GREEN             "{G+}"
#DEFINE K_MAGENTA           "{RB+}"
#DEFINE K_RED               "{R+}"
#DEFINE K_WHITE             "{W+}"
#DEFINE K_YELLOW            "{GR+}"
#DEFINE K_MAXSCHEME         24

*
* Save some environment variables to restore later
*
cdevice     = SET("DEVICE")
cconsole    = SET("CONSOLE")
cprinter    = SET("PRINTER")
cstatmesg   = SET("MESSAGE", 1)
cudfparm	= SET("UDFPARM")
cwinsave    = WOUTPUT()
lvisible    = WVISIBLE(cwinsave)

DIMENSION aclrset[K_MAXSCHEME]
FOR i = 1 TO K_MAXSCHEME
    IF _WINDOWS
        aclrset[i] = RGBSCHEME(i)
    ELSE
        aclrset[i] = SCHEME(i)
    ENDIF
ENDFOR

SET PRINTER OFF
SET CONSOLE ON
SET DEVICE TO SCREEN
SET UDFPARM TO VALUE

*
* Initialize color string and icon info
*
IF _WINDOWS
    k_saycolor      = RGBSCHEME(5, 1)
    k_icongap       = 10
    k_iconwidth     = 36
    k_iconheight    = k_iconwidth
ELSE
    k_saycolor      = SCHEME(5, 1)
    k_icongap       = 1
    k_iconwidth     = 6
    k_iconheight    = 3
ENDIF

*
* Initialize button's font info...
*
cbfont  = "MS Sans Serif"
nbsize  = 8
cbstyle = "B"

*
* Initialize needed variables
*
lpicbut     = .F.
IF _WINDOWS
    nbutheight = 1.80
ELSE
    nbutheight = 1.00
ENDIF
nrow        = IIF(TYPE("nrow") <> "N", -1, nrow)
ncol        = IIF(TYPE("ncol") <> "N", -1, ncol)
retval      = IIF(TYPE("nnumeric") <> "N" OR EMPTY(nnumeric), "", 0)
ctype       = IIF(TYPE("ctype")<>"C", K_ICONEXCLAMATION, ;
                UPPER(ALLTRIM(ctype)))
IF TYPE("ctitle") == [C]
	ctitle	= IIF(EMPTY(ctitle), IIF(_WINDOWS, [System Message], ""), ;
			  [ ] + ALLTRIM(ctitle) + [ ])
ELSE
	ctitle	= IIF(_WINDOWS, [System Message], "")
ENDIF

*
* Determine type of padding to use in displaying message.  Default to
* flush left.
*
IF (TYPE("cjust") <> [C]) OR EMPTY(cjust) OR ;
    (NOT INLIST(UPPER(ALLTRIM(cjust)), K_LEFTJUST, K_CENTERJUST, K_RIGHTJUST))
    cjust = K_LEFTJUST
ELSE
    cjust = UPPER(ALLTRIM(cjust))
ENDIF

*
* Verify border style
*
IF EMPTY(cnborder)
	cnborder = IIF(_WINDOWS, K_SYSTEM_BORDER, K_DOUBLE_BORDER)
ENDIF

IF TYPE([cnborder]) == [N] 
    DO CASE
        CASE cnborder == K_SINGLE_BORDER
            cnborder = "ÄÄ³³Ú¿ÀÙ"
        CASE cnborder > K_SYSTEM_BORDER
            cnborder = IIF(_WINDOWS, K_SYSTEM_BORDER, K_DOUBLE_BORDER)
    ENDCASE
ENDIF

IF TYPE([cnborder]) == [C]
    DIMENSION aborder[8]
    FOR i = 1 TO 8
        aborder[i] = SUBSTR(cnborder, i, 1)
    ENDFOR
ENDIF

*
* Determine the corresponding Icon to display with message
*
cbitmaps    = ""
ciconfile   = ""

IF _WINDOWS
    DO CASE
        CASE ctype == K_ICONEXCLAMATION
            ciconfile =  IIF(FILE("EXCLAIM.BMP"), "EXCLAIM.BMP", "")
        CASE ctype == K_ICONHAND OR ctype == K_ICONSTOP
            ciconfile =  IIF(FILE("STOP.BMP"), "STOP.BMP", "")
        CASE ctype == K_ICONINFORMATION OR ctype == K_ICONASTERISK
            ciconfile =  IIF(FILE("INFO.BMP"), "INFO.BMP", "")
        CASE ctype == K_ICONQUESTION
            ciconfile = IIF(FILE("QUESTION.BMP"), "QUESTION.BMP", "")
        OTHERWISE
            IF FILE(ctype)
                ciconfile   = ctype
            ELSE
                nloc1       = AT(".", ctype)
                nloc2       = AT("->", ctype)
                *
                * Save current work area and check if an alias was provided.
                *
                nselect = SELECT(0)
                DO CASE
                    CASE (nloc1 > 0) OR (nloc2 > 0)
                        *
                        * If so, then parse string into alias and field parts.
                        *
                        cbitmaps    = LEFT(ctype, nloc2 - 1)
                        ciconfile   = SUBSTR(ctype, nloc2 + 2)
                        IF EMPTY(cbitmaps)
                            cbitmaps    = LEFT(ctype, nloc1 - 1)
                            ciconfile   = SUBSTR(ctype, nloc1 + 1)
                        ENDIF

                    CASE NOT EMPTY(ALIAS())
                        cbitmaps    = ALIAS()
                        ciconfile   = ctype
                ENDCASE

                IF USED(cbitmaps)
                    ctype = cbitmaps + "->" + ciconfile
                    SELECT (cbitmaps)

                    *
                    * Verify that the field exists...
                    *
                    i = FCOUNT()
                    DIMENSION dbfields_[i]
                    = AFIELDS(dbfields_)

                    ciconfile = IIF(ASCAN(dbfields_, ciconfile) > 0, ctype, "")
                    RELEASE dbfields_

                    SELECT (nselect)
                    cbitmaps = "DBF"
                ELSE
                    cbitmaps = ""
                    ciconfile = ""
                ENDIF
            ENDIF
    ENDCASE

    *
    * Initialize message window's font info and save old color setting...
    *
    cfont   = IIF(TYPE("cfont") <> "C" OR EMPTY(cfont), ;
                "MS Sans Serif", ALLTRIM(cfont))
    nsize   = IIF(TYPE("nsize") <> "N" OR EMPTY(nsize), ;
                8, nsize)
    cstyle  = IIF(TYPE("cstyle") <> "C" OR EMPTY(cstyle), ;
                "B", UPPER(ALLTRIM(cstyle)))

    *
    * Initialize window with the message font's properties so our work will
    * depend on this window's font attributes and window color.
    *
    IF TYPE([cnborder]) == [N]
        DO CASE
            CASE cnborder == K_DOUBLE_BORDER
                DEFINE WINDOW wmsgbox AT 0,0 SIZE 25,25 ;
                    FONT cfont,nsize STYLE cstyle DOUBLE FLOAT
            CASE cnborder == K_SYSTEM_BORDER
                DEFINE WINDOW wmsgbox AT 0,0 SIZE 25,25 ;
                    FONT cfont,nsize STYLE cstyle SYSTEM FLOAT
            CASE cnborder == K_PANEL_BORDER
                DEFINE WINDOW wmsgbox AT 0,0 SIZE 25,25 ;
                    FONT cfont,nsize STYLE cstyle PANEL FLOAT
            CASE cnborder == K_NONE_BORDER
                DEFINE WINDOW wmsgbox AT 0,0 SIZE 25,25 ;
                    FONT cfont,nsize STYLE cstyle NONE FLOAT
        ENDCASE
    ELSE
        DEFINE WINDOW wmsgbox AT 0,0 SIZE 25,25 ;
            FONT cfont,nsize STYLE cstyle aborder[1], aborder[2], aborder[3],;
            aborder[4], aborder[5], aborder[6], aborder[7], aborder[8] FLOAT
    ENDIF
    ACTIVATE WINDOW wmsgbox NOSHOW

    *
    * Height of the main window's font, the message window's font, and the
    * button's font.
    *
    nwfheight   = FONTMETRIC(1, cfont, nsize, cstyle) ;
                + FONTMETRIC(5, cfont, nsize, cstyle)
    nbfheight   = FONTMETRIC(1, cbfont, nbsize, cbstyle) ;
                + FONTMETRIC(5, cbfont, nbsize, cbstyle)
    *
    * Define icon width and height based on message window's font.
    *
    IF NOT EMPTY(ciconfile)
        niconheight = k_iconheight / nwfheight
        niconwidth  = k_iconwidth  / FONTMETRIC(6, cfont, nsize, cstyle)
        nicongap    = k_icongap    / FONTMETRIC(6, cfont, nsize, cstyle)
    ELSE
        niconheight = 0
        niconwidth  = 0
        nicongap    = 0
    ENDIF
ELSE
    DEFINE WINDOW wmsgbox AT 0,0 SIZE 1,1
    ACTIVATE WINDOW wmsgbox NOSHOW

    DO CASE
        CASE ctype == K_ICONEXCLAMATION
            ciconfile = [ !! ]
        CASE ctype == K_ICONHAND OR ctype == K_ICONSTOP
            ciconfile = [STOP]
        CASE ctype == K_ICONINFORMATION OR ctype == K_ICONASTERISK
            ciconfile = [NOTE]
        CASE ctype == K_ICONQUESTION
            ciconfile = [ ?? ]
        OTHERWISE
            ciconfile = IIF(EMPTY(ctype), [], [ !! ])
    ENDCASE

    *
    * Define icon width and height based on message window's font.
    *
    IF NOT EMPTY(ciconfile)
        niconheight = k_iconheight
        niconwidth  = k_iconwidth
        nicongap    = k_icongap
    ELSE
        niconheight = 0
        niconwidth  = 0
        nicongap    = 0
    ENDIF
ENDIF

DO CASE
    CASE EMPTY(cncolor)
        cncolor = k_saycolor
    CASE TYPE("cncolor") == "N"
        cncolor = IIF(NOT BETWEEN(cncolor, 1, 12), k_saycolor, cncolor)
    CASE TYPE("cncolor") == "C"
        cncolor = ALLTRIM(cncolor)
    OTHERWISE
        cncolor = k_saycolor
ENDCASE

IF TYPE("cncolor") == "N"
    SET COLOR OF SCHEME 5 TO SCHEME cncolor
ELSE
    SET COLOR OF SCHEME 5 TO (cncolor)
ENDIF

*
* Determine the longest string to display.  Each new line is indicated by
* a CHR(13), or K_RETURN, code.
*
nmaxline    = 1
nloc        = AT(K_RETURN, cmsg)

IF nloc > 0
    DO WHILE nloc > 0
        DIMENSION amsg[nmaxline]
        DIMENSION amsgclr[nmaxline]
        amsg[nmaxline] = get_msg(LEFT(cmsg, nloc-1), @amsgclr, nmaxline)

        nmaxline = nmaxline + 1
        cmsg = IIF(nloc+1 > LEN(cmsg), "", SUBSTR(cmsg, nloc+1))
        nloc = AT(K_RETURN, cmsg)
    ENDDO

    DIMENSION amsg[nmaxline]
    DIMENSION amsgclr[nmaxline]
    amsg[nmaxline] = get_msg(cmsg, @amsgclr, nmaxline)

    nmaxlen = -1
    FOR i = 1 TO nmaxline
        nlen = TXTWIDTH(amsg[i], cfont, nsize, cstyle)

        IF nmaxlen < nlen
            nmaxlen = nlen
            nmaxstr = i
        ENDIF
    ENDFOR
ELSE
    DIMENSION amsg[1]
    DIMENSION amsgclr[1]
    amsg[1]     = get_msg(cmsg, @amsgclr, 1)
    nmaxstr     = 1
    nmaxline    = 1
ENDIF

*
* Parse the prompt statement if any
*
IF EMPTY(cprompt) OR TYPE("cprompt") <> "C"
    cprompt     = ""
    nbutwidth   = 0
    nbuttons    = 0
    nmax1       = 0
    nmax2       = 0
ELSE
    ndefault = 1
    DO CASE
        CASE UPPER(cprompt) == K_OK
            DIMENSION aprompt[1]
            nbuttons    = 1
            cprompt     = "\?\!\<OK"
            aprompt[1]  = "OK"

        CASE UPPER(cprompt) == K_CONTINUE
            DIMENSION aprompt[1]
            nbuttons    = 1
            cprompt     = "\?\!\<Continue"
            aprompt[1]  = "Continue"

        CASE UPPER(cprompt) == K_OKCANCEL
            DIMENSION aprompt[2]
            IF "C" $ cprompt
                ndefault = 2
            ENDIF
            cprompt     = "\!\<OK;\?\<Cancel"
            nbuttons    = 2
            aprompt[1]  = "OK"
            aprompt[2]  = "Cancel"

        CASE LEFT(UPPER(cprompt), 2) == K_YESNO
            DIMENSION aprompt[2]
            ctemp       = "\<Yes;\<No"
            aprompt[1]  = "Yes"
            aprompt[2]  = "No"

            IF UPPER(cprompt) == K_YESNOCANCEL
                *
                * Make cancel button react to ESC-key press
                *
                DIMENSION aprompt[3]
                nbuttons    = 3
                ctemp       = ctemp + ";\?\<Cancel"
                aprompt[3]  = "Cancel"
            ELSE
                nbuttons    = 2
            ENDIF

            DO CASE
                CASE "Y" $ cprompt
                    cprompt = "\!" + ctemp

                CASE "N" $ cprompt
                    cprompt  = STUFF(ctemp, 7, 0, "\!")
                    ndefault = 2

                CASE "C" $ cprompt
                    cprompt  = STUFF(ctemp, 12, 0, "\!")
                    ndefault = 3

                OTHERWISE
                    cprompt = ctemp
            ENDCASE

        CASE UPPER(cprompt) == K_RETRYCANCEL
            DIMENSION aprompt[2]
            IF "C" $ cprompt
                ndefault = 2
            ENDIF
            nbuttons    = 2
            cprompt     = "\!\<Retry;\?\<Cancel"
            aprompt[1]  = "Retry"
            aprompt[2]  = "Cancel"

        CASE UPPER(cprompt) == K_ABORTRETRYIGNORE
            DIMENSION aprompt[3]
            nbuttons    = 3
            ctemp       = "\<Abort;\<Retry;\<Ignore"
            aprompt[1]  = "Abort"
            aprompt[2]  = "Retry"
            aprompt[3]  = "Ignore"

            DO CASE
                CASE "A" $ cprompt
                    cprompt = "\!" + ctemp

                CASE "R" $ cprompt
                    cprompt  = STUFF(ctemp, 9, 0, "\!")
                    ndefault = 2

                CASE "I" $ cprompt
                    cprompt  = STUFF(ctemp, 17, 0, "\!")
                    ndefault = 3
            ENDCASE

        OTHERWISE
            *
            * Parse user-defined buttons
            *
            nbuttons  = OCCURS(";", cprompt) + 1
            nbutsize  = 0

            DIMENSION aprompt[nbuttons]

            IF _WINDOWS
                lpicbut = get_prompt(cprompt, @aprompt, @nbuttons, @ndefault, ;
                                     @nbutheight, @nbutsize)
            ELSE
                *
                * Picture buttons are not supported in DOS so pass nbutheight
                * and nbutsize as value parameters instead of variable parm.
                *
                lpicbut = get_prompt(cprompt, @aprompt, @nbuttons, @ndefault, ;
                                     nbutheight, nbutsize)
            ENDIF

            *
            * If it's a picture button, then remove SIZE clause from the
            * prompt string.
            *
            IF lpicbut
                IF NOT _WINDOWS
                    WAIT WINDOW [Picture buttons not supported in DOS!] NOWAIT
                    = INKEY(0, [HM])
                    = reset_set()
                    RETURN
                ENDIF

                IF [SIZE] $ cprompt
                    cprompt = ALLTRIM(LEFT(cprompt, AT("SIZE", cprompt) - 1))
                ENDIF
            ENDIF
    ENDCASE

    nmaxbut = 0
    IF NOT lpicbut
        nbutsize = 0

        FOR i = 1 TO nbuttons
            IF _WINDOWS
                IF nbutsize < TXTWIDTH(aprompt[i], cbfont, nbsize, cbstyle)
                    nbutsize = TXTWIDTH(aprompt[i], cbfont, nbsize, cbstyle)
                    nmaxbut  = i
                ENDIF
            ELSE
                IF nbutsize < LEN(aprompt[i])
                    nbutsize = LEN(aprompt[i])
                    nmaxbut  = i
                ENDIF
            ENDIF
        ENDFOR
    ENDIF
ENDIF

*
* Determine if user wants window to be centered.
*
lcenter = (nrow == -1) OR (ncol == -1)
IF lcenter
    nrow = 0
    ncol = 0
ENDIF

*
* The width of the window includes:
*   1.  the icon width and gaps
*   2.  the longest message line or the length of the row of buttons
*   3.  the border between the text and right side of message window
*       (Indicated by "WW" in TXTWIDTH())
*
* If no icon is to be displayed, then the borders between text and the
* message window (Indicated by "W" in TXTWIDTH()).
*
IF niconwidth <> 0
    IF _WINDOWS
        nwwidth = nicongap * 2 + niconwidth + ;
            TXTWIDTH(amsg[nmaxstr]+"W", cfont, nsize, cstyle)
    ELSE
        nwwidth = nicongap * 2 + niconwidth + LEN(amsg[nmaxstr]) + 1
    ENDIF
ELSE
    *
    * Set icon gap to one character spacing if no icons are used.
    *
    IF _WINDOWS
        nwwidth = TXTWIDTH(amsg[nmaxstr]+"WW", cfont, nsize, cstyle)
    ELSE
        nwwidth = LEN(amsg[nmaxstr]) + 2
    ENDIF
ENDIF

*
* The height of the window includes...
*   1.  gap between 1st line and top of window
*   2.  gap between last line and bottom of window
*   3.  if buttons are needed, then consider only gap between 1st line
*       and top of window...the other gaps will be considered in the code
*       below for buttons.
*
nwheight = nmaxline + IIF(EMPTY(cprompt), 2, 1)

*
* Redefine our window with the appropriate attributes
*
IF _WINDOWS
	MODIFY WINDOW wmsgbox COLOR SCHEME 5 ;
    	AT nrow,ncol SIZE nwheight,nwwidth ;
		TITLE ctitle FONT cfont,nsize STYLE cstyle
ELSE
    IF TYPE([cnborder]) == [N]
        DO CASE
            CASE cnborder == K_DOUBLE_BORDER
                DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                    AT nrow,ncol SIZE nwheight,nwwidth ;
                    TITLE ctitle DOUBLE FLOAT SHADOW
            CASE cnborder == K_SYSTEM_BORDER
                DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                    AT nrow,ncol SIZE nwheight,nwwidth ;
                    TITLE ctitle SYSTEM FLOAT SHADOW
            CASE cnborder == K_PANEL_BORDER
                DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                    AT nrow,ncol SIZE nwheight,nwwidth ;
                    TITLE ctitle PANEL FLOAT SHADOW
            CASE cnborder == K_NONE_BORDER
                DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                    AT nrow,ncol SIZE nwheight,nwwidth ;
                    TITLE ctitle NONE FLOAT SHADOW
        ENDCASE
    ELSE
        DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
            AT 0,0 SIZE nwheight,nwwidth ;
            TITLE ctitle FLOAT SHADOW aborder[1], aborder[2], aborder[3],;
            aborder[4], aborder[5], aborder[6], aborder[7], aborder[8]
    ENDIF
    ACTIVATE WINDOW wmsgbox NOSHOW
ENDIF

*
* Get # of rows in window based on this font's attributes and determine
* if icon will fit properly.  Adjust window size and get new row count
* as appropriate.
*
nmaxrow = WROWS()
IF _WINDOWS
    IF (nmaxrow <= (niconheight + 1.25))
        nwheight = niconheight + 1.25
        MODIFY WINDOW wmsgbox AT nrow,ncol SIZE nwheight,nwwidth
    ENDIF
ELSE
    IF (nmaxrow <= (niconheight + IIF(nbuttons > 0, 1, 2)))
        nwheight = niconheight + IIF(nbuttons > 0, 1, 2)
        IF TYPE([cnborder]) == [N]
            DO CASE
                CASE cnborder == K_DOUBLE_BORDER
                    DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                        AT nrow,ncol SIZE nwheight,nwwidth ;
                        TITLE ctitle DOUBLE FLOAT SHADOW
                CASE cnborder == K_SYSTEM_BORDER
                    DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                        AT nrow,ncol SIZE nwheight,nwwidth ;
                        TITLE ctitle SYSTEM FLOAT SHADOW
                CASE cnborder == K_PANEL_BORDER
                    DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                        AT nrow,ncol SIZE nwheight,nwwidth ;
                        TITLE ctitle PANEL FLOAT SHADOW
                CASE cnborder == K_NONE_BORDER
                    DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                        AT nrow,ncol SIZE nwheight,nwwidth ;
                        TITLE ctitle NONE FLOAT SHADOW
            ENDCASE
        ELSE
            DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                AT 0,0 SIZE nwheight,nwwidth ;
                TITLE ctitle FLOAT SHADOW aborder[1], aborder[2], aborder[3],;
                aborder[4], aborder[5], aborder[6], aborder[7], aborder[8]
        ENDIF
        ACTIVATE WINDOW wmsgbox NOSHOW
    ENDIF
ENDIF
nmaxrow = WROWS()

*
* Now check this window to see if the buttons (if any) will fit.
*
IF NOT EMPTY(cprompt)
    IF _WINDOWS
        *
        * Change the window's font attributes so we may position the button
        * list in the bottom-center of the window based on the button's font
        * properties.
        *
        MODIFY WINDOW wmsgbox FONT cbfont,nbsize STYLE cbstyle
    ENDIF

    *
    * Determine the spaces between each button
    *
    DO CASE
        CASE nbuttons == 2
            ngap = 6
        CASE nbuttons == 3
            ngap = 4
        OTHERWISE
            ngap = 2
    ENDCASE

    *
    * Get the TXTWIDTH length of the longest button based on button font.
    *
    * However, if length of longest button is shorter than 5, then get default
    * to TXTWIDTH length of word "Cancel".  This way, the button width will not
    * look too small.
    *
    IF NOT lpicbut
        IF LEN(aprompt[nmaxbut]) > 5
            IF _WINDOWS
                nbutsize = TXTWIDTH(aprompt[nmaxbut], cbfont, nbsize, cbstyle) ;
                         + 5
            ELSE
                nbutsize = LEN(aprompt[nmaxbut]) + 2
            ENDIF
        ELSE
            IF _WINDOWS
                nbutsize = TXTWIDTH("Cancel", cbfont, nbsize, cbstyle) + 5
            ELSE
                nbutsize = LEN("Cancel") + 2
            ENDIF
        ENDIF
    ENDIF
    nbutwidth = (nbuttons * nbutsize) + (ngap * (nbuttons - 1))

    *
    * Resize window's height to include buttons and gap between button row
    * and bottom of window as well as last line of text.
    *
    IF _WINDOWS
        nwheight = WROWS() + 1.5 * nbutheight
    ELSE
        nwheight = WROWS() + nbutheight + 2
    ENDIF

    *
    * Now, make sure that the window is large enough to display all the
    * buttons.  If not, then resize to proper width and re-center the
    * buttons based on new window width.
    *
    nwwidth = nbutwidth + ngap
    IF (WCOLS() / nwwidth) > 1
        nwwidth = WCOLS()
    ENDIF
    IF _WINDOWS
        MODIFY WINDOW wmsgbox AT nrow,ncol SIZE nwheight,nwwidth

        *
        * Restore original window font so we can display our message
        *
        MODIFY WINDOW wmsgbox FONT cfont,nsize STYLE cstyle
    ELSE
        IF TYPE([cnborder]) == [N]
            DO CASE
                CASE cnborder == K_DOUBLE_BORDER
                    DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                        AT nrow,ncol SIZE nwheight,nwwidth ;
                        TITLE ctitle DOUBLE FLOAT SHADOW
                CASE cnborder == K_SYSTEM_BORDER
                    DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                        AT nrow,ncol SIZE nwheight,nwwidth ;
                        TITLE ctitle SYSTEM FLOAT SHADOW
                CASE cnborder == K_PANEL_BORDER
                    DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                        AT nrow,ncol SIZE nwheight,nwwidth ;
                        TITLE ctitle PANEL FLOAT SHADOW
                CASE cnborder == K_NONE_BORDER
                    DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                        AT nrow,ncol SIZE nwheight,nwwidth ;
                        TITLE ctitle NONE FLOAT SHADOW
            ENDCASE
        ELSE
            DEFINE WINDOW wmsgbox COLOR SCHEME 5 ;
                AT 0,0 SIZE nwheight,nwwidth ;
                TITLE ctitle FLOAT SHADOW aborder[1], aborder[2], aborder[3],;
                aborder[4], aborder[5], aborder[6], aborder[7], aborder[8]
        ENDIF
        ACTIVATE WINDOW wmsgbox NOSHOW
    ENDIF
ENDIF

IF lcenter
    MOVE WINDOW wmsgbox CENTER
ENDIF

*
* Clear the window so new colors will be in effect.
*
CLEAR

*
* Display the icon, centering vertically between the message area
*
IF NOT EMPTY(ciconfile)
    IF _WINDOWS
        nsayrow = (nmaxrow - niconheight) / 2
        IF cbitmaps == [DBF]
            @ nsayrow, nicongap ;
                SAY EVAL(ciconfile) BITMAP ;
                    SIZE niconheight, niconwidth ISOMETRIC
        ELSE
            @ nsayrow, nicongap SAY ciconfile BITMAP
        ENDIF
    ELSE
        *
        * Draw DOS bitmap border first, and then draw the text bitmap!
        *
        IF EMPTY(cprompt)
            nsayrow = INT((nmaxrow - niconheight) / 2)
        ELSE
            nsayrow = ROUND((nmaxrow - niconheight) / 2, 0)
        ENDIF
        @ nsayrow, nicongap TO nsayrow+niconheight-1, nicongap+niconwidth-1
        @ nsayrow+1, nicongap+1 SAY ciconfile
    ENDIF
ENDIF

*
* Caculate which row to start displaying the multi-line message
*
IF _WINDOWS
    nsayrow = (nmaxrow - nmaxline) / 2
ELSE
    nsayrow = ROUND((nmaxrow - nmaxline) / 2, 0) + ;
              IIF(nmaxline==2 AND EMPTY(cprompt), -1, 0)
ENDIF

DO CASE
    CASE cjust == K_LEFTJUST
        *
        * Set starting column for message lines at 1 character after icon
        *
        IF niconwidth > 0
            nsaycol = niconwidth + nicongap * 2
        ELSE
            IF _WINDOWS
                nsaycol = TXTWIDTH("W", cfont, nsize, cstyle)
            ELSE
                nsaycol = 1
            ENDIF
        ENDIF

        IF TYPE("cncolor") == "N"
            FOR i = 1 TO nmaxline
                IF _WINDOWS
                    @ nsayrow,nsaycol SAY amsg[i] ;
                        FONT cfont,nsize ;
                        STYLE cstyle ;
                        COLOR SCHEME cncolor
                ELSE
                    @ nsayrow,nsaycol SAY amsg[i] ;
                        COLOR SCHEME cncolor
                ENDIF
                nsayrow = nsayrow + 1
            ENDFOR
        ELSE
            FOR i = 1 TO nmaxline
                IF _WINDOWS
                    @ nsayrow,nsaycol SAY amsg[i] ;
                        FONT cfont,nsize ;
                        STYLE cstyle ;
                        COLOR (amsgclr[i])
                ELSE
                    @ nsayrow,nsaycol SAY amsg[i] ;
                        COLOR (amsgclr[i])
                ENDIF
                nsayrow = nsayrow + 1
            ENDFOR
        ENDIF

    CASE cjust == K_CENTERJUST
        *
        * Set starting column for message lines at center of window
        * but after icon
        *
        IF _WINDOWS
            IF niconwidth > 0
                nsaycol = niconwidth + 2 * nicongap ;
                        + (WCOLS() - 1 - niconwidth - 2 * nicongap)/2
            ELSE
                nsaycol = WCOLS()/2
            ENDIF
        ELSE
            IF niconwidth > 0
                nsaycol = ROUND(niconwidth + 2 * nicongap ;
                        + (WCOLS() - 1 - niconwidth - 2 * nicongap)/2, 0)
            ELSE
                nsaycol = ROUND(WCOLS()/2, 0)
            ENDIF
        ENDIF

        IF TYPE("cncolor") == "N"
            FOR i = 1 TO nmaxline
                IF _WINDOWS
                    @ nsayrow,nsaycol-TXTWIDTH(amsg[i],cfont,nsize,cstyle)/2;
                        SAY amsg[i] ;
                        FONT cfont,nsize ;
                        STYLE cstyle ;
                        COLOR SCHEME cncolor
                ELSE
                    @ nsayrow,nsaycol-TXTWIDTH(amsg[i],cfont,nsize,cstyle)/2;
                        SAY amsg[i] ;
                        COLOR SCHEME cncolor
                ENDIF
                nsayrow = nsayrow + 1
            ENDFOR
        ELSE
            FOR i = 1 TO nmaxline
                IF _WINDOWS
                    @ nsayrow,nsaycol-TXTWIDTH(amsg[i],cfont,nsize,cstyle)/2;
                        SAY amsg[i] ;
                        FONT cfont,nsize ;
                        STYLE cstyle ;
                        COLOR (amsgclr[i])
                ELSE
                    @ nsayrow,nsaycol-TXTWIDTH(amsg[i],cfont,nsize,cstyle)/2;
                        SAY amsg[i] ;
                        COLOR (amsgclr[i])
                ENDIF
                nsayrow = nsayrow + 1
            ENDFOR
        ENDIF

    CASE cjust == K_RIGHTJUST
        *
        * Set starting column for message lines at right side of window
        * but 2 spaces before border (Indicated by "W" in TXTWIDTH()).
        *
        IF _WINDOWS
            nsaycol = WCOLS() - TXTWIDTH("W", cfont, nsize, cstyle)
        ELSE
            nsaycol = WCOLS() - 1
        ENDIF

        IF TYPE("cncolor") == "N"
            FOR i = 1 TO nmaxline
                IF _WINDOWS
                    @ nsayrow,nsaycol-TXTWIDTH(amsg[i],cfont,nsize,cstyle) ;
                        SAY amsg[i] ;
                        FONT cfont,nsize ;
                        STYLE cstyle ;
                        COLOR SCHEME cncolor
                ELSE
                    @ nsayrow,nsaycol-TXTWIDTH(amsg[i],cfont,nsize,cstyle) ;
                        SAY amsg[i] ;
                        COLOR SCHEME cncolor
                ENDIF
                nsayrow = nsayrow + 1
            ENDFOR
        ELSE
            FOR i = 1 TO nmaxline
                IF _WINDOWS
                    @ nsayrow,nsaycol-TXTWIDTH(amsg[i],cfont,nsize,cstyle) ;
                        SAY amsg[i] ;
                        FONT cfont,nsize ;
                        STYLE cstyle ;
                        COLOR (amsgclr[i])
                ELSE
                    @ nsayrow,nsaycol-TXTWIDTH(amsg[i],cfont,nsize,cstyle) ;
                        SAY amsg[i] ;
                        COLOR (amsgclr[i])
                ENDIF
                nsayrow = nsayrow + 1
            ENDFOR
        ENDIF
ENDCASE

IF EMPTY(cprompt) OR (RDLEVEL() == K_MAXREADLEVEL)
    ACTIVATE WINDOW wmsgbox TOP
    IF (RDLEVEL() == K_MAXREADLEVEL)
        WAIT WINDOW "Maximum read level exceeded!!!" + CHR(13) + ;
            "Please contact " + K_CONTACTNAME NOWAIT
        = INKEY(0, 'HM')
    ENDIF
ELSE
    IF _WINDOWS
        *
        * Now change to window's font attribute to the button's font.
        *
        MODIFY WINDOW wmsgbox FONT cbfont,nbsize STYLE cbstyle
    ENDIF

    *
    * Calculate the starting row and column for buttons...center of window
    *
    nsayrow = WROWS() - (1.35 * nbutheight)
    cprompt = IIF(lpicbut, "*HB ", "*H ") + cprompt
    nchoice = ndefault

    *
    * Create the buttons
    *
    IF _WINDOWS
        nsaycol = (WCOLS() - nbutwidth) / 2
        @ nsayrow,nsaycol GET nchoice ;
            FUNCTION cprompt;
            SIZE nbutheight, nbutsize, ngap;
            FONT cbfont, nbsize ;
            STYLE cbstyle ;
            MESSAGE show_mesg()
    ELSE
        nsaycol = ROUND((WCOLS() - nbutwidth) / 2, 0)
        @ nsayrow,nsaycol GET nchoice ;
            FUNCTION cprompt;
            SIZE nbutheight, nbutsize, ngap;
            MESSAGE show_mesg()
    ENDIF

    ACTIVATE WINDOW wmsgbox TOP

    *
    * Determine if a VALID routine was provided...if so, then call it
    * to determine whether WMsgBox() should terminate upon button
    * selection!
    *
    IF NOT EMPTY(cvalfunc) AND TYPE([CVALFUNC]) == [C]
        READ CYCLE ;
            WHEN chk_menu() ;
            MODAL OBJECT ndefault ;
            VALID EVAL(cvalfunc+IIF(![()] $ cvalfunc, [()], []))
    ELSE
        READ CYCLE ;
            WHEN chk_menu() ;
            MODAL OBJECT ndefault
    ENDIF

    IF BETWEEN(nchoice, 1, nbuttons)
        retval = IIF(TYPE('nnumeric') == [N] AND nnumeric == 1, ;
                    nchoice, aprompt[nchoice])
    ENDIF

    RELEASE WINDOW wmsgbox
ENDIF

= reset_set()

RETURN retval


***
*
*   GET_PROMPT()
*
*   Called by WMSGBOX() to parse the prompt string into an array of choices.
*
*   If more than one default settings was found, then the first one will be
*   the default one.
*
**
FUNCTION get_prompt
    PARAMETER cchoice, achoice, nmax, ndefault, nbutheight, nbutsize
    PRIVATE i, nloc, nloc2, lpicbut
    EXTERNAL ARRAY achoice

    ndefault = 0

    *
    * Picture buttons have .BMP or .ICO extensions for bitmapped objects, or
    * a SIZE clause!
    *
    lpicbut = ([.BMP] $ UPPER(cchoice)) OR ([.ICO] $ UPPER(cchoice)) OR ;
              ([SIZE] $ UPPER(cchoice))

    FOR i = 1 TO nmax
        nloc = AT(";", cchoice)

        IF nloc = 0
            IF lpicbut
                nloc        = AT("SIZE", UPPER(cchoice))
                achoice[i]  = IIF(nloc = 0, cchoice, LEFT(cchoice, nloc - 1))
            ELSE
                achoice[i]  = cchoice
            ENDIF
        ELSE
            achoice[i] = LEFT(cchoice, nloc - 1)
            cchoice    = SUBSTR(cchoice, nloc + 1)
        ENDIF

        IF ndefault == 0
            *
            * In order for a choice to be a default, it must have a "\!"
            * and it must not be right before a letter in the option string.
            *
            nloc2 = AT("\!", achoice[i])
            IF INLIST(nloc2, 1, 3)
                ndefault = i
            ENDIF
        ENDIF

        *
        * Now remove all control-character combinations from the string
        * and determine the longest button option.
        *
        achoice[i] = STRTRAN(STRTRAN(STRTRAN(achoice[i], '\!'), '\<'), '\?')
    ENDFOR

    IF lpicbut
        *
        * For, picture buttons, user must define the size of the buttons.
        *
        nloc    = AT("SIZE", UPPER(cchoice)) + 5
        nloc2   = AT(",", cchoice)

        *
        * If no size is given or invalid size, then assign default values...
        *
        IF nloc == 6 OR ((nloc2 - nloc) < 1)
            nbutheight  = 5
            nbutsize    = 10
        ELSE
            nbutheight  = VAL(ALLTRIM(SUBSTR(cchoice, nloc, (nloc2 - nloc))))
            nbutsize    = VAL(ALLTRIM(SUBSTR(cchoice, nloc2 + 1)))
        ENDIF
    ENDIF

    *
    * If no default button is specified, then default to first button!
    *
    IF ndefault == 0
        ndefault = 1
    ENDIF
RETURN lpicbut


***
*
*   GET_MSG()
*
*   Called by WMSGBOX() to parse the message string for embedded color
*   specifier.
*
*   If no color is specified, then default to RGBSCHEME(5,1), the color of
*   a dialog window.
*
*   'accolor' is passed by reference, therefore, what is assigned to it will
*   be returned to the calling procedure.
*
**
FUNCTION get_msg
    PARAMETER cmesg, accolor, nindex
    EXTERNAL ARRAY accolor
    PRIVATE nloc1, nloc2, ccolor

    nloc1 = AT('{', cmesg)
    nloc2 = AT('}', cmesg)

    IF nloc1 > 0 AND nloc2 > 0
        IF INLIST(SUBSTR(cmesg, nloc1, nloc2 - nloc1 + 1), ;
            K_BLACK, K_BLUE, K_CYAN, K_DRKBLUE, K_DRKCYAN, K_DRKGREEN, ;
            K_DRKMAGENTA, K_DRKRED, K_DRKYELLOW, K_DRKGRAY, K_GRAY, ;
            K_GREEN, K_MAGENTA, K_RED, K_WHITE, K_YELLOW)

            accolor[nindex] =  SUBSTR(cmesg, nloc1 + 1, nloc2-nloc1-1) ;
                            + SUBSTR(SCHEME(5), AT('/', SCHEME(5)))
            cmesg           = LEFT(cmesg, nloc1 - 1)
        ELSE
            accolor[nindex] = cncolor
        ENDIF
    ELSE
        accolor[nindex] = cncolor
    ENDIF
RETURN cmesg


***
*
*   CHK_MENU()
*
*   Called by WMSGBOX() to determine whether the system menu should be
*   hidden before activation of the read for WMSGBOX().
*
**
FUNCTION chk_menu
    IF TYPE("lmenubar") == "L" AND NOT lmenubar
    	HIDE MENU _MSYSMENU
	ENDIF

    *
    * Set default button number here since WMsgBox() maybe called when
    * there are established GETs with no READ issued!
    *
    ndefault = OBJNUM(nchoice) + ndefault - 1
    _CUROBJ  = ndefault
    SHOW OBJECT _CUROBJ
RETURN .T.


***
*
*   SHOW_MESG()
*
*   Called by WMSGBOX() to display messages for currently selected
*   button (if provided).
*
**
FUNCTION show_mesg
    PRIVATE nloc1, nloc2, nlen, cmesg

    IF EMPTY(chelp) OR (TYPE([chelp]) <> [C])
        RETURN [ ]
	ENDIF
	
    nlen = LEN(chelp)
    nloc1 = AT(';', chelp, _CUROBJ)

    IF _CUROBJ == 1
        IF nloc1 > 0
            nloc2 = nloc1 - 1
            nloc1 = 1
        ELSE
            nloc1 = 1
            nloc2 = nlen
        ENDIF
    ELSE
        IF nloc1 > 0
            nloc2 = nloc1 - 1
            nloc1 = AT(';', chelp, _CUROBJ - 1) + 1
        ELSE
            nloc1 = AT(';', chelp, _CUROBJ - 1) + 1
            nloc2 = nlen
        ENDIF
    ENDIF

    IF (nloc2 - nloc1 + 1 > 0)
        cmesg = SUBSTR(chelp, nloc1, nloc2 - nloc1 + 1)
    ELSE
        cmesg = [ ]
    ENDIF
RETURN cmesg


***
*
*   RESET_SET()
*
*   Called by WMSGBOX() to restore saved environment variables and
*   color settings.
*
**
PROCEDURE reset_set
    *
    * If no prompt is provided, then don't activate screen/window.
    *
    IF EMPTY(cwinsave)
        ACTIVATE SCREEN
    ELSE
        IF lvisible
            ACTIVATE WINDOW (cwinsave) SAME
        ELSE
            ACTIVATE WINDOW (cwinsave) SAME NOSHOW
        ENDIF
    ENDIF

	IF cudfparm == "REFERENCE"
		SET UDFPARM TO REFERENCE
	ENDIF
	
    *
    * Restore environment settings
    *
    IF cdevice <> "SCREEN"
        SET DEVICE TO &cdevice
    ENDIF

    IF cconsole <> "ON"
        SET CONSOLE OFF
    ENDIF

    IF cprinter <> "OFF"
        SET PRINTER ON
    ENDIF

    SET MESSAGE TO cstatmesg

    FOR i = 1 TO 24
        IF (i <> 13) AND (i <> 14)
            SET COLOR OF SCHEME i TO (aclrset[i])
        ENDIF
    ENDFOR

    IF TYPE("lmenubar") == "L" AND NOT lmenubar
        HIDE MENU _MSYSMENU
    ENDIF

    POP KEY
RETURN
