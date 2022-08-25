@echo off
setlocal enableExtensions disableDelayedExpansion
set /p exetitle=<ExeTitle.txt
set /p fullpathVD=<temp.txt
set /p exepath=<temp2.txt
set /p exewithoutVD=<temp3.txt
set /p gamedir=<GDir.txt
set /p gamename=<gname.txt
set /p filename=<filename.txt
set /p steamargs=<tempSteam.txt
set /p dis=<dis.txt
set /p currdir=<currdir.txt
set "currdir=%currdir%\My Launchers"
if NOT [%exetitle%] == [] set ""gamedir=.\\""
if NOT [%exetitle%] == [] set ""currdir=.\\""

echo %fullpathVD%>"".\Temp\%gamename%(VD).bat""
echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%APPDATA%\Microsoft\Windows\Start Menu\Programs\My Launchers\%gamename%(VD).lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "%currdir%\%gamename%(VD).exe" >> CreateShortcut.vbs
echo oLink.WorkingDirectory = "%gamedir%" >> CreateShortcut.vbs
echo oLink.IconLocation = "%exepath%" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs
cscript CreateShortcut.vbs
del CreateShortcut.vbs

%dis%
echo %fullpathVD% > ".\Temp\%gamename%(VD).bat"
echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%HOMEDRIVE%%HOMEPATH%\Desktop\%gamename%(VD).lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "%currdir%\%gamename%(VD).exe" >> CreateShortcut.vbs
echo oLink.WorkingDirectory = "%gamedir%" >> CreateShortcut.vbs
echo oLink.IconLocation = "%exepath%" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs
cscript CreateShortcut.vbs
del CreateShortcut.vbs

:exit
exit
