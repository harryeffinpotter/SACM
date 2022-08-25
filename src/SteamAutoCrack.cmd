

@echo off
mode con:cols=100 lines=50
cd /d %~dp0
set /p Ver=<bin\Ver.txt
title  SACM - %Ver% by KillinMeSmalls/HFP
echo   =====================================================================
echo   =====================================================================
echo   ==                                                                 ==
echo   ==      SACM aka SteamAutoCrack MOD - by KillinMeSmalls/HFP.       ==
echo   ==                             v%Ver%                                ==
echo   ==                                                                 ==
echo   =====================================================================
echo   =====================================================================
echo.
echo Original Steam auto crack can be found here:
echo ^-^> https://github.com/oureveryday/Steam-auto-crack
echo.
echo Source code + updates on development and discussion on SACM can be found here:
echo ^-^> https://cs.rin.ru/forum/viewtopic.php?f=29^&t=117252
echo.
echo FFA - My group that hosts my actual programs, Loader, VRL and my FFA repacks: 
echo ^-^> https://t.me/FFAMain
echo.
echo -=Loader=- 
echo Windows program that DLs+Installs Quest games and so much more QOL stuff
echo such as FULL cracked game backup/restore and an UPDATE ALL feature.
echo.
echo -=VRL=- 
echo Tool that makes PCVR shortcuts that work for Oculus Link and/or Virtual Desktop.
echo. 
echo -=FFA=Repacks=- 
echo Our repacks are fine tuned for Oculus Quest owners. These repacks will AUTOMATICALLY 
echo ADD THEMSELVES  TO WINDOWS DEFENDER'S FOLDER EXCLUSIONS PRIOR TO INSTALL.
echo.
echo PS. We are looking for more repackers and also anyone who can help us seed/get an 
echo approved status on rutracker/1337x, etc. Also if you use AllDebrid and would like
echo to help beta test my special AllDebrid program for windows. It converts mags from clipboard
echo and also pops the filecrypt captions that JDL2 doesn't! I also coded an AllDebrid iOS
echo shortcut!
echo.
echo If any of the above applies to you, hit me up here on telegram: 
echo ^-^> https://t.me/YouStayGold
echo.
echo Thanks!
pause
set "_null=1>nul 2>nul"
chcp 65001 %_null%

setlocal EnableDelayedExpansion
setlocal Enableextensions


cls
Taskkill /IM APPID.exe /F %_null%
Taskkill /IM SACM.exe /F %_null%
Taskkill /IM VRL.exe /F %_null%
mkdir "TEMP" %_null%

"%~dp0bin\curl\curl.exe" "https://mr_goldberg.gitlab.io/goldberg_emulator/" -s > "TEMP\1.tmp" 
findstr /I /R /C:"https://gitlab.com/Mr_Goldberg/goldberg_emulator/-/jobs/.*/artifacts/download" "TEMP\1.tmp" > "TEMP\2.tmp"
for /f "tokens=7 delims=/" %%a in (TEMP\2.tmp) do ( set "JobID=%%a" )
del /f /s /q "TEMP\1.tmp" %_null%
del /f /s /q "TEMP\2.tmp" %_null%
set /p OldJobID=<bin\Goldberg\job_id
IF /I !JobID! == !OldJobID! (
echo Goldberg Emulator Already Updated to Latest Version.
timeout /T 4
goto :Menu
)
echo Downloading update...
"bin\curl\curl.exe" -L "!URL!" --output "TEMP\Goldberg.zip" %_null%
echo Download Complete. Extracting files......
"%~dp0bin\7z\7za.exe" -o"TEMP\Goldberg" x "TEMP\Goldberg.zip" %_null%
del /f /s /q "TEMP\Goldberg.zip" %_null%
copy /Y "TEMP\Goldberg\steam_api.dll" "bin\Goldberg\steam_api.dll" %_null%
copy /Y "TEMP\Goldberg\steam_api64.dll" "bin\Goldberg\steam_api64.dll" %_null% 
echo !JobID!> "bin\Goldberg\job_id"
echo Update completed.
del /f /s /q "Temp\Goldberg" %_null%
rd /s /q "Temp\Goldberg" %_null%
echo.
timeout /T 4
ENDLOCAL
:Menu
set "_null=1>nul 2>nul"
chcp 65001 %_null%
echo SACM (SteamAutoCrack MOD) - v%Ver% by KillinMeSmalls/HFP.
setlocal EnableDelayedExpansion
setlocal Enableextensions
cd /d "%~dp0"
cls
echo Please select parent directory of Steam game you wish to crack.
echo.
echo NOTE: This should not be done directly on a folder that is located
echo in Program Files or Program Files(x86) because it will likely fail
echo due to permissions issues. Instead copy the game folder out of your
echo Steam directory to somewhere like your Desktop first then select it.
Timeout /T 2 /NOBREAK %_null%

set "AutoCrackStep=:AutoCrack1"
set "GamePath="
call :FileSelect Folder
set "GamePath=%FilePath%"
set "MYDIR=%GamePath%
for %%f in (%GamePath%) do set ArgsForAPPID=%%~nxf

echo.
SETLOCAL
set "AutoCrackStep=:AutoCrack2"
::Init
del /F /S /Q "%~dp0Temp\steam_settings"  %_null% & rd /S /Q "%~dp0Temp\steam_settings" %_null%
set "GameAPPID="
set "SteamAPIKEY=189DD8DC8BB725C1F95CB831AC02BB22"
set "Image="
set "Num="
mode con:cols=100 lines=50
echo.
echo.
echo Launching HFP'S APPID finder, search game and click APPID #...
echo.
echo.
start bin\APPID\APPID.exe "%ArgsForAPPID%"
:Menu
echo Awaiting APPID selection...
:Await
tasklist /fi "ImageName eq APPID.exe" /fo csv 2>NUL | find /I "APPID.exe">NUL
if "%ERRORLEVEL%"=="1" goto :SetAPPID
if "%ERRORLEVEL%"=="0" goto :Await
:SetAPPID
FOR /F "tokens=*" %%g IN ('powershell -sta "add-type -as System.Windows.Forms; [windows.forms.clipboard]::GetText()"') do (SET GameAPPID=%%g)
@echo.
@echo.
@echo APPID: %GameAPPID%
@echo.
@echo.
if NOT defined GameAPPID ( echo Invalid APPID, try again! & pause & goto :Menu )
for /f "delims=0123456789" %%i in ("%GameAPPID%") do set Num=%%i
if defined Num ( echo Please Input vaild Game APPID. & pause & goto :Menu ) 
if /I %GameAPPID% GTR 99999999 ( echo Please Input vaild Game APPID. & pause & goto :Menu ) 
mkdir Temp\steam_settings %_null%
echo | set /p="%GameAPPID%"> "%~dp0Temp\steam_settings\steam_appid.txt"
set "Image=" 
mkdir "%~dp0TEMP\steam_settings" %_null%
"%~dp0bin\generate_game_infos\generate_game_infos.exe" "!GameAPPID!" -s "!SteamAPIKEY!" -o "%~dp0Temp\steam_settings" !Image! %_null%
ENDLOCAL

SETLOCAL
if EXIST "%~dp0Temp\steam_settings\settings" (
del /F /S /Q "%~dp0Temp\steam_settings\settings"  %_null% & rd /S /Q "%~dp0Temp\steam_settings\settings" %_null%)
set "Language=english"
set "AccountName=FFA"
set "ListenPort=47584"
set "UserSteamID=76561197960287930"
echo Writing Goldberg Steam Emulator Settings......
echo.
echo.
mkdir "%~dp0Temp\steam_settings\settings" %_null%
echo | set /p="%AccountName%"> "%~dp0Temp\steam_settings\settings\account_name.txt"
echo | set /p="%Language%"> "%~dp0Temp\steam_settings\settings\language.txt"
echo | set /p="%ListenPort%"> "%~dp0Temp\steam_settings\settings\listen_port.txt"
echo | set /p="%UserSteamID%"> "%~dp0Temp\steam_settings\settings\user_steam_id.txt"
)
ENDLOCAL
:AutoCrack4
set "AutoCrackStep=:AutoCrack4"
SETLOCAL
set "FilePath=%GamePath%"
FOR /R %FilePath% %%i IN (*.dll) DO ( set "_EMUPathInput=%%i" & call :AutoCrackAutoFindApplyEMU1 )

ENDLOCAL
goto :AutoCrack5

:AutoCrackAutoFindApplyEMU1
SETLOCAL
::steam_api.dll
set _EMUPath=!_EMUPathInput!
call :checkfile "%_EMUPath%" steam_api.dll
if %result%==1 (
move /Y "%_EMUPath%" "%_EMUPath%.bak" %_null%
echo Replacing "%_EMUPath%" with Goldberg Steam Emulator
echo.
echo.
copy /Y "%~dp0bin\Goldberg\steam_api.dll" "%_EMUPath%" %_null%
set _EMUPath=%_EMUPath:\steam_api.dll=%
xcopy "%~dp0Temp\steam_settings" "!_EMUPath!\steam_settings" /H /E /Y /C /Q /R /I %_null% 
)
::steam_api64.dll
set _EMUPath=!_EMUPathInput!
call :checkfile "%_EMUPath%" steam_api64.dll
if %result%==1 (
move /Y "%_EMUPath%" "%_EMUPath%.bak" %_null%
echo Replacing "%_EMUPath%" with Goldberg Steam Emulator
echo.
echo.
copy /Y "%~dp0bin\Goldberg\steam_api64.dll" "%_EMUPath%" %_null%
set _EMUPath=%_EMUPath:\steam_api64.dll=%
xcopy "%~dp0Temp\steam_settings" "!_EMUPath!\steam_settings" /H /E /Y /C /Q /R /I %_null% 
)
ENDLOCAL
goto :eof



:AutoCrack5
set "AutoCrackStep=:AutoCrack5"
SETLOCAL
set "FilePath=%GamePath%"
FOR /R %FilePath% %%i IN (*.exe) DO (
set unppath=%%i
.\bin\Steamless\Steamless.CLI.exe "!unppath!" %_null%
if !errorlevel! EQU 0 (
echo Unpacked "!unppath!"
move /Y "!unppath!" "!unppath!.bak" %_null%
move /Y "!unppath!.unpacked.exe" "!unppath!" %_null%
)
)
echo.
echo.
echo.
echo.
ENDLOCAL
::Complete
echo ==================================
echo ^|                                ^|
echo ^| Game Crack Completed. Enjoy :) ^|
echo ^|                                ^|
echo ==================================
set "AutoCrackStep="
del /f /s /q "%~dp0Temp" %_null%
rd /s /q "%~dp0Temp" %_null%
echo.
echo.

pause
exit


goto :Menu


::-----------------Generate Goldberg Steam Emulator Game Info (Appid + Achievements + DLC)-----------
:GenerateEMUInfo
set "Info=Generate Goldberg Steam Emulator Game Info (Appid + Achievements + DLC)"
call :MenuInfo
::Init
if EXIST "%~dp0Temp\steam_settings" (
choice /N /M "Delete Previous steam_settings Folder[Y/N]:"
IF ERRORLEVEL 2 ( echo Canceled. & pause & goto :Menu )
IF ERRORLEVEL 1 (del /F /S /Q "%~dp0Temp\steam_settings"  %_null% & rd /S /Q "%~dp0Temp\steam_settings" %_null% & echo Deleted. )
)
set "GameAPPID="
set "SteamAPIKEY=189DD8DC8BB725C1F95CB831AC02BB22"
set "Image=-i"
set "Num="
::Input
echo.
echo (If you don't know the Game APPID, Find it Here: https://steamdb.info/)
set /p GameAPPID=Input Game APPID, then press Enter:
if NOT defined GameAPPID ( echo Please Input vaild Game APPID. & pause & goto :Menu )
for /f "delims=0123456789" %%i in ("%GameAPPID%") do set Num=%%i
if defined Num (echo Please Input vaild Game APPID. & pause & goto :Menu ) 
if /I %GameAPPID% GTR 99999999 (echo Please Input vaild Game APPID. & pause & goto :Menu ) 
choice /N /M "Generate Game Infos online (Default: Yes)[Y/N]:"
IF ERRORLEVEL 2 (
mkdir Temp\steam_settings %_null%
echo | set /p="%GameAPPID%"> "%~dp0Temp\steam_settings\steam_appid.txt"
echo Default Goldberg Steam Emulator Game Info Generated.
pause
goto :Menu
)

IF ERRORLEVEL 1 (
choice /N /M "Generate Achievement Images (Generate can take longer time. Default: No)[Y/N]:"
IF ERRORLEVEL 2 ( set "Image=-i" )
echo --------------------
echo Use Steam Web API:  Input Steam Web API Key, then press Enter.
echo Use xan105 API:     Leave Blank, then press Enter. (Default)
echo If use xan105 API, No Steam Web API Key needed, But Can't Generate Items.
echo --------------------
set /p SteamAPIKEY=Steam API Key:
echo --------------------
mkdir "%~dp0TEMP\steam_settings" %_null%
if NOT defined SteamAPIKEY (  )
if defined SteamAPIKEY ( echo Using Steam Web API. & "%~dp0bin\generate_game_infos\generate_game_infos.exe" "!GameAPPID!" -s "!SteamAPIKEY!" -o "%~dp0Temp\steam_settings" !Image! )
echo --------------------
echo Goldberg Steam Emulator Game Info Generated.
echo.
pause
goto :Menu
)



::-----------------Auto apply Goldberg Steam Emulator (Apply + Backup)-----------
:AutoApplyEMU
set "Info=Auto apply Goldberg Steam Emulator (Apply + Backup)"
call :MenuInfo
if NOT EXIST %~dp0Temp\steam_settings echo Please Set Goldberg Steam Emulator first. & pause & goto :Menu
echo Please select steam_api(64).dll :
call :FileSelect File .dll

::steam_api.dll
call :checkfile %FilePath% steam_api.dll
if %result%==1 (
set "_FilePath=%FilePath:"=%"
echo Backuping "!_FilePath!" .......
move /Y "!_FilePath!" "!_FilePath!.bak" %_null%
echo Replacing "%_EMUPath%" with Goldberg Steam Emulator steam_api.dll ......
copy /Y "%~dp0bin\Goldberg\steam_api.dll" "!_FilePath!" %_null%
set _FilePath=!_FilePath:\steam_api.dll=!
echo Copying Config to "!_FilePath!\steam_settings\"......
xcopy "%~dp0Temp\steam_settings\" "!_FilePath!\steam_settings\" /E /C /Q /H /R /Y %_null%
echo Goldberg Steam Emulator Applied.
pause
goto :Menu
)

::steam_api64.dll
call :checkfile %FilePath% steam_api64.dll
if %result%==1 (
set "_FilePath=%FilePath:"=%"
echo Backuping "!_FilePath!" .......
move /Y "!_FilePath!" "!_FilePath!.bak" %_null%
echo Replacing "%_EMUPath%" with Goldberg Steam Emulator steam_api64.dll......
copy /Y "%~dp0bin\Goldberg\steam_api64.dll" "!_FilePath!" %_null%
set _FilePath=!_FilePath:\steam_api64.dll=!
echo Copying Config to "!_FilePath!\steam_settings\"......
xcopy "%~dp0Temp\steam_settings\" "!_FilePath!\steam_settings\" /E /C /Q /H /R /Y %_null%
echo Goldberg Steam Emulator Applied.
pause
goto :Menu
)
echo Not selected steam_api(64).dll .
pause 
goto :Menu

::-----------------Auto Find and apply Goldberg Steam Emulator (Apply + Backup)-----------
:AutoFindApplyEMU
set "Info=Auto Find and apply Goldberg Steam Emulator (Apply + Backup)"
call :MenuInfo
if NOT EXIST %~dp0Temp\steam_settings echo Please Set Goldberg Steam Emulator first. & pause & goto :Menu
echo Please select Game Folder:
call :FileSelect Folder
FOR /R %FilePath% %%i IN (*.dll) DO ( set "_EMUPathInput=%%i" & call :AutoFindApplyEMU1 )
echo All Goldberg Steam Emulator has been Applied.
echo.
pause 
goto :Menu

:AutoFindApplyEMU1
::steam_api.dll
set _EMUPath=!_EMUPathInput!
call :checkfile "%_EMUPath%" steam_api.dll
if %result%==1 (
echo ---------------
echo Found "%_EMUPath%" .
echo Backuping "%_EMUPath%" .......
move /Y "%_EMUPath%" "%_EMUPath%.bak" %_null%
echo Replacing "%_EMUPath%" with Goldberg Steam Emulator steam_api.dll......
copy /Y "%~dp0bin\Goldberg\steam_api.dll" "%_EMUPath%" %_null%
set _EMUPath=%_EMUPath:\steam_api.dll=%
echo Copying Config to "!_EMUPath!\steam_settings\"......
xcopy "%~dp0Temp\steam_settings" "!_EMUPath!\steam_settings" /H /E /Y /C /Q /R /I %_null% 
echo Goldberg Steam Emulator Config Applied.
)
::steam_api64.dll
set _EMUPath=!_EMUPathInput!
call :checkfile "%_EMUPath%" steam_api64.dll
if %result%==1 (
echo ---------------
echo Found "%_EMUPath%" .
echo Backuping "%_EMUPath%" .......
move /Y "%_EMUPath%" "%_EMUPath%.bak" %_null%
echo Replacing "%_EMUPath%" with Goldberg Steam Emulator steam_api64.dll......
copy /Y "%~dp0bin\Goldberg\steam_api64.dll" "%_EMUPath%" %_null%
set _EMUPath=%_EMUPath:\steam_api64.dll=%
echo Copying Config to "!_EMUPath!\steam_settings\"......
xcopy "%~dp0Temp\steam_settings" "!_EMUPath!\steam_settings" /H /E /Y /C /Q /R /I %_null% 
echo Goldberg Steam Emulator Config Applied.
)
goto :eof

::------------Auto Unpack----------------
:AutoUnpack
set "Info=Auto Unpack SteamStub (Unpack + Backup)"
call :MenuInfo
echo Please select Packed .exe file:
call :FileSelect File .exe
%~dp0bin\Steamless\Steamless.CLI.exe %FilePath% %_null%
if errorlevel 1 echo Unpack error. (File not Packed/Other Packer) & pause & goto :Menu
echo Unpack successful, backuping......
move /Y %FilePath% %FilePath%.bak %_null%
move /Y %FilePath%.unpacked.exe %FilePath% %_null%
echo File backuped.
pause
goto :Menu


::----------Auto Unpack Find (Unpack + Backup)----------
:AutoUnpackFind
set "Info=Auto find and Unpack SteamStub (Unpack + Backup)"
call :MenuInfo
echo Please select Game Folder:
call :FileSelect Folder
FOR /R %FilePath% %%i IN (*.exe) DO (
echo --------
set unppath=%%i
.\bin\Steamless\Steamless.CLI.exe "!unppath!" %_null%
if !errorlevel! EQU 1 echo Unpack error. File not Packed or Packed by Other Packer/Protector.
if !errorlevel! EQU 0 (
echo echo Unpacked: "!unppath!".
move /Y "!unppath!" "!unppath!.bak" %_null%
move /Y "!unppath!.unpacked.exe" "!unppath!" %_null%
)
)
goto :Menu

::------------------------------Files---------------------------------------------------------------------
::------------Check File--------------------------
:checkfile
if /I ["%~nx1"]==["%2"] set "result=1"
if /I NOT ["%~nx1"]==["%2"] set "result=0"
set "CheckFileName=%~nx1"
goto :eof
::------------File Selector-------------------------
:FileSelect
set "FilePath="
set "FileType=%1"
set "FileExt=%2"
if /i %FileType%==File (
choice /N /C CIS /M "Please [S]elect File or [I]nput File Full path or [C]ancel: [S,I,C]:"
if errorlevel 3 goto :selectpath 
if errorlevel 2 goto :inputpath  
if errorlevel 1 echo Cenceled. & pause & goto :Menu
)

if /i %FileType%==Folder (
goto :selectpath 
)

:FileSelect1
if NOT exist %FilePath% cls & echo -------- & echo %FileType% Not Found. & echo -------- & pause & goto :FileSelect
goto :eof

::---------------Select File Path---------------
:selectpath
for %%i in (powershell.exe) do if "%%~$path:i"=="" (
echo Powershell is not installed in the system.
echo Please use Input %FileType% Path.
goto :FileSelect
)

if /i %FileType%==File goto :selectfile 
if /i %FileType%==Folder goto :selectfolder

:selectfile
set "dialog=powershell -sta "Add-Type -AssemblyName System.windows.forms^|Out-Null;$f=New-Object System.Windows.Forms.OpenFileDialog;$f.InitialDirectory=pwd;$f.showHelp=$false;$f.Filter='%FileExt% files (*%FileExt%)^|*%FileExt%^|All files (*.*)^|*.*';$f.ShowDialog()^|Out-Null;$f.FileName""
for /f "delims=" %%I in ('%dialog%') do set "FilePath="%%I""
if NOT defined FilePath echo No %FileType% selected. & goto :FileSelect
goto :FileSelect1

:selectfolder
set "dialog=powershell -sta "Add-Type -AssemblyName System.windows.forms^|Out-Null;$f=New-Object System.Windows.Forms.FolderBrowserDialog;$f.ShowNewFolderButton=$true;$f.ShowDialog();$f.SelectedPath""
for /F "delims=" %%I in ('%dialog%') do set "FilePath="%%I""
if NOT defined FilePath echo No %FileType% selected. & goto :FileSelect
goto :FileSelect1
::---------------Input File Path---------------
:inputpath
if /i %FileType%==File echo Drag and Drop File or Input File Full Path, then press Enter:
if /i %FileType%==Folder echo Drag and Drop Folder or Input Folder Full Path, then press Enter:
set /p FilePath=
if NOT defined FilePath echo No %FileType% selected. & goto :FileSelect
set FilePath=%FilePath:"=%
set FilePath="%FilePath%"
goto :FileSelect1

::--------------------------------------------------------------------------------------------------------------

::-------------About---------------------
:About
set "Info=About"
call :MenuInfo
echo.
echo  HarryEffinPotters SteamAutoCrack FullyAutoMod  %Ver%
echo           Automatic Steam Game Cracker
echo  Github: https://github.com/oureveryday/Steam-auto-crack
echo  Gitlab: https://gitlab.com/oureveryday/Steam-auto-crack
echo.
pause
goto :Menu

::--------------------Info------------------------
:MenuInfo
cls
echo.
echo.
echo -------------------------------------------------------------
echo ----  FFA Games Presents                                 ----
echo ----  HarryEffinPotters SteamAutoCrack FullyAutoMod %ver% ----
echo -------------------------------------------------------------   
echo.
echo.

echo -------------------------------------------------------------          
echo ----  FFA Telegram      FFA Discord                      ---- 
echo ----  t.me/FFAMain      discord.com/invite/QvYwqvdgxc    ----
echo -------------------------------------------------------------
echo.
echo.
echo ---------------%Info%---------------------
goto :eof

::----------------------Delete TEMP File-----------------
:DelTMP
set Info=Delete TEMP File
call :MenuInfo
if NOT EXIST "%~dp0Temp" echo No TEMP File Generated. & pause & goto :Menu
choice /N /M "Delete TEMP file[Y/N]?"
IF ERRORLEVEL 2 echo Cenceled. & pause & goto :Menu
del /f /s /q "%~dp0Temp" %_null%
rd /s /q "%~dp0Temp" %_null%
echo Temp file deleted.
pause
goto :Menu





