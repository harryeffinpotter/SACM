@echo off
setlocal enableExtensions disableDelayedExpansion
cd %~dp0
set /p Ver=<..\src\bin\Ver.txt
echo Ver.txt version number = %Ver%
pause
cls
bat2exe.exe /bat Launcher.cmd /exe "..\bin\SACM.exe" /include ..\src /workdir 1 /extractdir 1 /deleteonexit /icon ..\icon\SteamAutoCrack.ico
pause