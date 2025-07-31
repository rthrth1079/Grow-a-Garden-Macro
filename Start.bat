@echo off
setlocal EnableDelayedExpansion
chcp 65001 > nul
cd %~dp0

set "arch=%PROCESSOR_ARCHITECTURE%"

set "ahkExe="

if /i "%arch%"=="AMD64" (
	if exist "scripts\AutoHotkey64.exe" (
		set "ahkExe=scripts\AutoHotkey64.exe"
	) else if exist "scripts\AutoHotkey32.exe" (
		set "ahkExe=scripts\AutoHotkey32.exe"
	)
) else (
	if exist "scripts\AutoHotkey32.exe" (
		set "ahkExe=scripts\AutoHotkey32.exe"
	)
)

if exist "scripts\Epic's_GAG_macro.ahk" (
	if defined ahkExe (
		if not [%~3]==[] (
			set /a "delay=%~3" 2>nul
			echo Starting Epic's GAG macro in !delay! seconds.
			<nul set /p =Press any key to skip . . . 
			timeout /t !delay! >nul
		)
		start "" "%~dp0!ahkExe!" "%~dp0scripts\Epic's_GAG_macro.ahk" %*
		exit
	)
)

for /f "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "\e=%%E"
set red=%\e%[91m
set reset=%\e%[0m

echo %red%Could not find a compatible AutoHotkey executable!%reset%
echo %red%Expected one of the following in 'scripts' folder:%reset%
echo %red%- AutoHotkey64.exe (for 64-bit systems)%reset%
echo %red%- AutoHotkey32.exe (for all systems)%reset%
echo:
<nul set /p "=%red%Press any key to exit . . . %reset%"
pause >nul
exit
