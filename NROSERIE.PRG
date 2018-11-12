**funcion que trae el numero de serie del disco**
**tratar de hacerla en fox**

=getvol('c:\')
=getvol('d:\')
=getvol('e:\')
=getvol('h:\')
=getvol('g:\')
=getvol('a:\')
=getvol('p:\')

*-----------------------------------------------
FUNCTION GetVol
parameters lpRoot
*-----------------------------------------------
* Nuestra información del volumen
* USO: GetVol("C:\")
* PARAMETRO: lpRoot = LetraDrive + ":\"
*-----------------------------------------------
private lnRet, lcString, lpVolName, ;
  nVolSize, lpVolNumber, ;
  lpMaxComp, lpFlags, ;
  lpFSName, nFSSize

IF EMPTY(lpRoot)
  lpRoot = "d:\"
ENDIF
lpVolName = SPACE(256)
nVolSize = 256
lpVolNumber = 0
lpMaxComp = 256
lpFlags = 0
lpFSName = SPACE(256)
nFSSize = 256

set library to d:\vfp\foxtools.fll

public GetVolInfo
GetVolInfo=regfn('GetVolumenInformation','@C@CI@I@I@I@CI','I','WIN32API')

lnRet=callfn(GetVolInfo,@lpRoot, @lpVolName, ;
  nVolSize, @lpVolNumber, ;
  @lpMaxComp, @lpFlags, ;
  @lpFSName, nFSSize)

IF lnRet > 0
  lcString = "Drive name: " + ;
    ALLT(lpRoot)+CHR(13)+ ;
    "Vol name: " + ;
    LEFT(ALLT(lpVolName),LEN(ALLT(lpVolName))-1)+CHR(13)+ ;
    "Max #/chars in vol name: " + ;
    ALLT(STR(nVolSize))+CHR(13)+ ;
    "Vol Serial #: " + ;
    ALLT(STR(lpVolNumber))+CHR(13)+ ;
    "Max #/chars in dir/file names: " + ;
    ALLT(STR(lpMaxComp))+CHR(13)+ ;
    "File Sys Flags: " + ;
    ALLT(STR(lpFlags))+CHR(13)+ ;
    "File Sys type: " + ;
    LEFT(ALLT(lpFSName),LEN(ALLT(lpFSName))-1)+CHR(13)+ ;
    "File Sys Name Size: " + ;
    ALLT(STR(nFSSize))
ELSE
  lcString = "No se pudo ver información"
ENDIF
=MESSAGEBOX(lcString, "Información del volumen")

RETURN


**********************
* Codigo en C
*//declaracion de api

*Private Declare Function GetVolumeInformation Lib _
*   "kernel32.dll" Alias "GetVolumeInformationA" _
*   (ByVal lpRootPathName As String, _
*   ByVal lpVolumeNameBuffer As String, _
*   ByVal nVolumeNameSize As Integer, _
*   lpVolumeSerialNumber As Long, _
*   lpMaximumComponentLength As Long, _
*   lpFileSystemFlags As Long, _
*   ByVal lpFileSystemNameBuffer As String, _
*   ByVal nFileSystemNameSize As Long) As Long


*//funcion

*Public Function DriveSerialNumber(ByVal Drive As String) As Long
    
*    'usage: SN = DriveSerialNumber("C:\")
 
*    Dim lAns As Long
*    Dim lRet As Long
*    Dim sVolumeName As String, sDriveType As String
*    Dim sDrive As String

*    'Deal with one and two character input values
*    sDrive = Drive
*    If Len(sDrive) = 1 Then
*        sDrive = sDrive & ":\"
*    ElseIf Len(sDrive) = 2 And Right(sDrive, 1) = ":" Then
*        sDrive = sDrive & "\"
*    End If
  
*    sVolumeName = String$(255, Chr$(0))
*    sDriveType = String$(255, Chr$(0))
    
*    lRet = GetVolumeInformation(sDrive, sVolumeName, _
*        255, lAns, 0, 0, sDriveType, 255)

*DriveSerialNumber = lAns
*End Function

**********************************
* Codigo en visual fox
*-----------------------------------------------
*FUNCTION GetVol(lpRoot)
*-----------------------------------------------
* Nuestra información del volumen
* USO: GetVol("C:\")
* PARAMETRO: lpRoot = LetraDrive + ":\"
*-----------------------------------------------
*LOCAL lnRet, lcString, lpVolName, ;
*  nVolSize, lpVolNumber, ;
*  lpMaxComp, lpFlags, ;
*  lpFSName, nFSSize

*IF EMPTY(lpRoot)
*  lpRoot = "d:\"
*ENDIF
*lpVolName = SPACE(256)
*nVolSize = 256
*lpVolNumber = 0
*lpMaxComp = 256
*lpFlags = 0
*lpFSName = SPACE(256)
*nFSSize = 256

*DECLARE INTEGER GetVolumeInformation ;
*        IN Win32API AS GetVolInfo ;
*  STRING  @lpRoot, ;
*  STRING  @lpVolName, ;
*  INTEGER nVolSize, ;
*  INTEGER @lpVolNumber, ;
*  INTEGER @lpMaxComp, ;
*  INTEGER @lpFlags, ;
*  STRING  @lpFSName, ;
*  INTEGER nFSSize

*lnRet=GetVolInfo(@lpRoot, @lpVolName, ;
*  nVolSize, @lpVolNumber, ;
*  @lpMaxComp, @lpFlags, ;
*  @lpFSName, nFSSize)

*IF lnRet > 0
*  lcString = "Drive name: " + ;
*    ALLT(lpRoot)+CHR(13)+ ;
*    "Vol name: " + ;
*    LEFT(ALLT(lpVolName),LEN(ALLT(lpVolName))-1)+CHR(13)+ ;
*    "Max #/chars in vol name: " + ;
*    ALLT(STR(nVolSize))+CHR(13)+ ;
*    "Vol Serial #: " + ;
*    ALLT(STR(lpVolNumber))+CHR(13)+ ;
*    "Max #/chars in dir/file names: " + ;
*    ALLT(STR(lpMaxComp))+CHR(13)+ ;
*    "File Sys Flags: " + ;
*    ALLT(STR(lpFlags))+CHR(13)+ ;
*    "File Sys type: " + ;
*    LEFT(ALLT(lpFSName),LEN(ALLT(lpFSName))-1)+CHR(13)+ ;
*    "File Sys Name Size: " + ;
*    ALLT(STR(nFSSize))
*ELSE
*  lcString = "No se pudo ver información"
*ENDIF
*=MESSAGEBOX(lcString, "Información del volumen")
*RETURN ""
*ENDFUNC

