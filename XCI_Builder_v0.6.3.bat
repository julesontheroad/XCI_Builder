@echo off
setlocal enabledelayedexpansion
color 03

if not exist "%~dp0\ztools\KEYS.txt" echo Falta archivo "KEYS.txt" o "keys.txt!"
echo.
if not exist "%~dp0\ztools\KEYS.txt" pause
if not exist "%~dp0\ztools\KEYS.txt" exit
set file=%~n1
FOR %%i IN ("%file%") DO (
set filename=%%~ni
)
CD /d "%~dp0"
cls


if "%~x1"==".nsp" (goto nsp)
if "%~x1"==".xci" (goto xci)
echo No hagas doble click sobre XCI_Builder
echo.
echo Este programa solo funciona arrastrando el archivo sobre el mismo
echo.
echo.Recuerda, necesitaras tener la licencia instalada en la consola para ejecutar el juego resultante
echo.
echo.Para ello el programa genera un nsp "nombre programa"_lc.nsp
echo.
echo.Este nsp incluye la licencia del juego
echo.
echo.Para su instalación usar instalador de SX OS o versiones antiguas de tinfoil.
echo.
echo.Versiones actuales de tinfoil no funcionan por su verificación de firma.
echo.
echo.El autor no es responsable de cualquier problema que los programas puedan acarrear sobre su dispositivo
echo.
pause
exit

:xci
MD game_info
if exist "game_info\!filename!.ini" del "game_info\!filename!.ini"
"%~dp0\ztools\hacbuild.exe" read xci "%~f1"
move  "%~dp1\*.ini"  "%~dp0\game_info\" 

exit

:nsp
@echo off
setlocal enabledelayedexpansion
if exist "%~dp0\output_xcib\!filename!\" rmdir /s /q "%~dp0\output_xcib\!filename!\"
if exist "%~dp0\nspDecrypted\" rmdir /s /q "%~dp0\nspDecrypted\"
MD nspDecrypted
"%~dp0\ztools\hactool.exe" -k "%~dp0\ztools\keys.txt" -t pfs0 --pfs0dir=nspDecrypted\rawsecure "%~1" > nspDecrypted/log_hactool.txt
if exist nspDecrypted\rawsecure\*.jpg del nspDecrypted\rawsecure\*.jpg
del log_hactool.txt
dir nspDecrypted\rawsecure\*.nca > nspDecrypted\lisfiles.txt
FINDSTR /I ".nca" "nspDecrypted\lisfiles.txt">nspDecrypted\nca_list.txt
del nspDecrypted\lisfiles.txt
set /a nca_number=0
for /f %%a in (nspDecrypted\nca_list.txt) do (
    set /a nca_number=!nca_number! + 1
)
::echo !nca_number!>nspDecrypted\nca_number.txt

if exist "nspDecrypted\rawsecure\*.cnmt.xml" goto nsp_proper
goto nsp_notproper

:nsp_proper

if !nca_number! LEQ 4 goto nsp_proper_nm

set meta_xml=nspDecrypted\rawsecure\*.cnmt.xml

FINDSTR /N /I "<id>" %meta_xml%>nspDecrypted\id.txt

FINDSTR /N "HtmlDocument" %meta_xml%>nspDecrypted\ishtmldoc.txt
for /f "tokens=2* delims=: " %%a in (nspDecrypted\ishtmldoc.txt) do (
set html_pos=%%a)
::echo !html_pos!>nspDecrypted\html_pos.txt
set /a html_id_pos=!html_pos!+1
::echo %html_id_pos%>nspDecrypted\html_nca_id__pos.txt
FINDSTR /N "%html_id_pos%" nspDecrypted\id.txt>nspDecrypted\ishtml_id.txt
for /f "tokens=3* delims=<>" %%a in (nspDecrypted\ishtml_id.txt) do (
set myhtmlnca=%%a.nca)
::echo %myhtmlnca%>nspDecrypted\myhtmlnca.txt
if exist "nspDecrypted\rawsecure\%myhtmlnca%" del "nspDecrypted\rawsecure\%myhtmlnca%"
echo %myhtmlnca%>nspDecrypted\myhtmlnca.txt

:nsp_proper_nm
set meta_xml=nspDecrypted\rawsecure\*.cnmt.xml
if exist nspDecrypted\id.txt del nspDecrypted\id.txt

FINDSTR /N /I "<id>" %meta_xml%>nspDecrypted\id.txt

FINDSTR /N "Control" %meta_xml%>nspDecrypted\iscontrolnca.txt
for /f "tokens=2* delims=: " %%a in (nspDecrypted\iscontrolnca.txt) do (
set control_pos=%%a)
::echo !control_pos!>nspDecrypted\control_pos.txt
set /a control_id_pos=!control_pos!+1
echo %control_id_pos%>nspDecrypted\control_id_pos.txt
FINDSTR /N "%control_id_pos%" nspDecrypted\id.txt>nspDecrypted\iscrl_id.txt
for /f "tokens=3* delims=<>" %%a in (nspDecrypted\iscrl_id.txt) do (
set myctrlnca=%%a.nca)
echo %myctrlnca%>nspDecrypted\myctrlnca.txt

goto :lcnsp

:nsp_notproper

set /a c_gamenca=1
set mycheck=Manual
set mycheck2=Control

for /f "tokens=4* delims= " %%a in (nspDecrypted\nca_list.txt) do (
echo %%a>>nspDecrypted\nca_list_helper.txt)
del nspDecrypted\nca_list.txt

if !nca_number! LEQ 4 goto nsp_notproper_nm

:nsp_notproper_man
set gstring=
if !c_gamenca! EQU 6 ( goto nsp_notproper_man2 )
if !c_gamenca! EQU 1 ( set gstring=,2,3,4,5, )
if !c_gamenca! EQU 2 ( set gstring=,1,3,4,5, )
if !c_gamenca! EQU 3 ( set gstring=,1,2,4,5, )
if !c_gamenca! EQU 4 ( set gstring=,1,2,3,5, )
if !c_gamenca! EQU 5 ( set gstring=,1,2,3,4, )

::Sacar equivalencia a game_nca
Set "skip=%gstring%"
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<nspDecrypted\nca_list_helper.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>nspDecrypted\ncatocheck.txt

for /f %%a in (nspDecrypted\ncatocheck.txt) do (
    set ncatocheck=%%a
)
"%~dp0\ztools\hactool.exe" -k "%~dp0\ztools\keys.txt" -t nca -i "nspDecrypted\rawsecure\%ncatocheck%" >"nspDecrypted\nca_data.txt"
FINDSTR "Type" nspDecrypted\nca_data.txt >nspDecrypted\nca_helper.txt
for /f "tokens=3* delims=: " %%a in (nspDecrypted\nca_helper.txt) do (
echo %%a>>nspDecrypted\nca_helper2.txt)
Set "skip=,2,3,"
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<nspDecrypted\nca_helper2.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>nspDecrypted\nca_type.txt
for /f %%a in (nspDecrypted\nca_type.txt) do (
    set nca_type=%%a
)
if %nca_type% EQU %mycheck% ( echo %ncatocheck%>>nspDecrypted\manual_list.txt )
if %nca_type% EQU %mycheck2% ( set myctrlnca=%ncatocheck% )
::echo %myctrlnca%> nspDecrypted\myctrlnca.txt
set /a c_gamenca+=1
del nspDecrypted\ncatocheck.txt
del nspDecrypted\nca_data.txt
del nspDecrypted\nca_helper.txt
del nspDecrypted\nca_helper2.txt
del nspDecrypted\nca_type.txt
goto nsp_notproper_man

:nsp_notproper_man2
::We'll get the route of the alleged "manual nca" 
set crlt=0
for /f %%a in (nspDecrypted\manual_list.txt) do (
    set /a crlt=!crlt! + 1
    set tmanual!crlt!=%%a
)

::del manual_list.txt

::Set complete route
set f_tmanual1="%~dp0\nspDecrypted\rawsecure\%tmanual1%"
set f_tmanual2="%~dp0\nspDecrypted\rawsecure\%tmanual2%"

::Get size of both nca
for /f "usebackq" %%A in ('%f_tmanual1%') do set size_tm1=%%~zA
for /f "usebackq" %%A in ('%f_tmanual2%') do set size_tm2=%%~zA

echo !size_tm1!>nspDecrypted\size_tm1.txt
echo !size_tm2!>nspDecrypted\size_tm2.txt

::Ok, here's some technical explanation
::Normaly legas is like 130-190kb
::Manual can be some mb (offline manual) or less size than legal (online manual)
::I'm assuming the limit for legal sise is a little over 300kb. Can be altered if needed

if !size_tm1! GTR 3400000 ( goto case1 )
if !size_tm1! GTR 3400000 ( goto case2 )
if !size_tm1! GTR !size_tm2! ( goto case3 )
if !size_tm2! GTR !size_tm1!( goto case4 )
goto nomanual

:case1
del "%f_tmanual1%"
::set filename=!filename![nm]
goto lcnsp
:case2
del "%f_tmanual2%"
::set filename=!filename![nm]
goto lcnsp
:case3
del "%f_tmanual2%"
::set filename=!filename![nm]
goto lcnsp
:case4
del "%f_tmanual1%"
::set filename=!filename![nm]
goto lcnsp

:nsp_notproper_nm
set gstring=
if !c_gamenca! EQU 5 ( goto lcnsp )
if !c_gamenca! EQU 1 ( set gstring=,2,3,4, )
if !c_gamenca! EQU 2 ( set gstring=,1,3,4, )
if !c_gamenca! EQU 3 ( set gstring=,1,2,4, )
if !c_gamenca! EQU 4 ( set gstring=,1,2,3, )

::Sacar equivalencia a game_nca
Set "skip=%gstring%"
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<nspDecrypted\nca_list_helper.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>nspDecrypted\ncatocheck.txt

for /f %%a in (nspDecrypted\ncatocheck.txt) do (
    set ncatocheck=%%a
)
"%~dp0\ztools\hactool.exe" -k "%~dp0\ztools\keys.txt" -t nca -i "nspDecrypted\rawsecure\%ncatocheck%" >"nspDecrypted\nca_data.txt"
FINDSTR "Type" nspDecrypted\nca_data.txt >nspDecrypted\nca_helper.txt
for /f "tokens=3* delims=: " %%a in (nspDecrypted\nca_helper.txt) do (
echo %%a>>nspDecrypted\nca_helper2.txt)
Set "skip=,2,3,"
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<nspDecrypted\nca_helper2.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>nspDecrypted\nca_type.txt
for /f %%a in (nspDecrypted\nca_type.txt) do (
    set nca_type=%%a
)

if %nca_type% EQU %mycheck2% ( set myctrlnca=%ncatocheck% )
::echo %myctrlnca%> nspDecrypted\myctrlnca.txt
set /a c_gamenca+=1
del nspDecrypted\ncatocheck.txt
del nspDecrypted\nca_data.txt
del nspDecrypted\nca_helper.txt
del nspDecrypted\nca_helper2.txt
del nspDecrypted\nca_type.txt
goto nsp_notproper_nm


:lcnsp
::del nspDecrypted\*.txt
if exist "nspDecrypted\licencia" RD /S /Q "nspDecrypted\licencia"
MD nspDecrypted\licencia
echo f | xcopy /f /y "nspDecrypted\rawsecure\%myctrlnca%" "nspDecrypted\licencia\"
move  "nspDecrypted\rawsecure\*.cnmt.xml"  "nspDecrypted\licencia" 
move  "nspDecrypted\rawsecure\*.tik"  "nspDecrypted\licencia" 
move  "nspDecrypted\rawsecure\*.cert"  "nspDecrypted\licencia" 

dir "%~dp0\nspDecrypted\licencia" /b  > "%~dp0\nspDecrypted\fileslist.txt"
set list=0
for /F "tokens=*" %%A in (nspDecrypted\fileslist.txt) do (
    SET /A list=!list! + 1
    set varlist!list!=%%A
)
set varlist

if exist  nspDecrypted\licencia\*.cnmt.xml goto nspwithxml
if exist  nspDecrypted\licencia\*.tik goto nspwithoutxml
goto createxci
:nspwithxml
"%~dp0\ztools\nspbuild.py" "%~dp0\nspDecrypted\!filename!_lc.nsp" "%~dp0\nspDecrypted\licencia\%varlist1%" "%~dp0\nspDecrypted\licencia\%varlist2%" "%~dp0\nspDecrypted\licencia\%varlist3%" "%~dp0\nspDecrypted\licencia\%varlist4%"
del nspDecrypted\fileslist.txt
rmdir /s /q "%~dp0\nspDecrypted\licencia"
goto createxci
:nspwithoutxml
"%~dp0\ztools\nspbuild.py" "%~dp0\nspDecrypted\!filename!_lc.nsp" "%~dp0\nspDecrypted\licencia\%varlist1%" "%~dp0\nspDecrypted\licencia\%varlist2%" "%~dp0\nspDecrypted\licencia\%varlist3%"
del nspDecrypted\fileslist.txt
rmdir /s /q "%~dp0\nspDecrypted\licencia"
goto createxci

:createxci
del nspDecrypted\rawsecure\*.tik
del nspDecrypted\rawsecure\*.xml
del nspDecrypted\rawsecure\*.cert
del nspDecrypted\*.txt
if exist nspDecrypted\rawsecure\*.jpg del nspDecrypted\rawsecure\*.jpg
if exist nspDecrypted\secure RD /S /Q nspDecrypted\secure\
MD nspDecrypted\secure
echo f | xcopy /f /y "game_info_preset.ini" "nspDecrypted\"
RENAME nspDecrypted\game_info_preset.ini ""game_info.ini"
move  "%~dp0\nspDecrypted\rawsecure\*.nca"  "%~dp0\nspDecrypted\secure\" 
RD /S /Q nspDecrypted\rawsecure\
MD nspDecrypted\normal
MD nspDecrypted\update

"%~dp0\ztools\hacbuild.exe" xci_auto "%~dp0\nspDecrypted"  "%~dp0\nspDecrypted\!filename!.xci" 
RD /S /Q "%~dp0\nspDecrypted\secure"
RD /S /Q "%~dp0\nspDecrypted\normal"
RD /S /Q "%~dp0\nspDecrypted\update"
del "%~dp0\nspDecrypted\game_info.ini"
MD "%~dp0\output_xcib\!filename!"
move  "%~dp0\nspDecrypted\*.*"  "%~dp0\output_xcib\!filename!" 
rmdir /s /q "%~dp0\nspDecrypted"

echo    /@
echo    \ \
echo  ___\ \
echo (__O)  \
echo (____@)  \
echo (____@)   \
echo (__o)_    \
echo       \    \


PING -n 2 127.0.0.1 >NUL 2>&1
exit















