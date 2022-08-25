@echo off
setlocal enableExtensions disableDelayedExpansion
set /p exepath=<temp2.txt
set /p args=<temp3.txt
set /p gamedir=<gdir.txt
set /p gamename=<gname.txt
set /p filename=<filename.txt
set /p steamargs=<tempSteam.txt
set /p pathstrings=<temp1.txt
set /p dis=<dis.txt
set /p currdir=<currdir.txt
set /p exetitle=<ExeTitle.txt
set "currdir=%currdir%\My Launchers"
if NOT [%exetitle%] == [] set ""gamedir=.\\""
if NOT [%exetitle%] == [] set ""currdir=.\\""

echo %pathstrings%>>"".\Temp\%gamename%(OtherHMDs).bat""
echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%APPDATA%\Microsoft\Windows\Start Menu\Programs\My Launchers\%gamename%(OtherHMDs).lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "%currdir%\%gamename%(OtherHMDs).exe" >> CreateShortcut.vbs
echo oLink.WorkingDirectory = "%gamedir%" >> CreateShortcut.vbs
echo oLink.IconLocation = "%exepath%" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs

cscript CreateShortcut.vbs
del CreateShortcut.vbs


%dis%


echo %pathstrings%> ".\Temp\%gamename%(OtherHMDs).bat"
echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%HOMEDRIVE%%HOMEPATH%\Desktop\%gamename%(OtherHMDs).lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "%currdir%\%gamename%(OtherHMDs).exe" >> CreateShortcut.vbs
echo oLink.WorkingDirectory = "%gamedir%" >> CreateShortcut.vbs
echo oLink.IconLocation = "%exepath%" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs

cscript CreateShortcut.vbs
del CreateShortcut.vbs
:exit
exit
