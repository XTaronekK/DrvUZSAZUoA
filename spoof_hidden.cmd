@echo off
:: Minimiert starten, falls nicht schon minimiert
if not defined MINIMIZED (
    set MINIMIZED=true
    powershell -WindowStyle Minimized -Command "Start-Process '%~f0' -ArgumentList 'MINIMIZED' -WindowStyle Minimized"
    exit /b
)

cd /d "%~dp0"
title AMIDEWINx64 Spoofing Tool
color 0A
setlocal EnableDelayedExpansion

:: Zeichenpools
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
set "digits=0123456789"

:: Serien generieren
call :genSerial serial_bs
call :genSerial serial_ss
call :genSerial serial_cs
call :genSerial serial_sk
call :genUUID serial_su
call :genSerial serial_psn
call :genSerial serial_pat
call :genSerial serial_ppn
call :genSerial serial_cmh

:: Ausgabe
echo [*] Spoofing BIOS serial number...
AMIDEWINx64.EXE /BS !serial_bs!

echo [*] Spoofing system serial number...
AMIDEWINx64.EXE /SS !serial_ss!

echo [*] Spoofing baseboard serial number...
AMIDEWINx64.EXE /CS !serial_cs!

echo [*] Spoofing chassis serial number...
AMIDEWINx64.EXE /SK !serial_sk!

echo [*] Spoofing UUID...
AMIDEWINx64.EXE /SU !serial_su!

echo [*] Spoofing Processor...
AMIDEWINx64.EXE /PSN !serial_psn!

echo [*] Spoofing Processor Tag...
AMIDEWINx64.EXE /PAT !serial_pat!

echo [*] Spoofing Processor number...
AMIDEWINx64.EXE /PPN !serial_ppn!

echo.
echo [✔] Spoofing complete!
timeout /t 3 >nul
exit /b

:genSerial
:: Generiert: 2 Buchstaben + 6 Zahlen + 2 Buchstaben + 6 Zahlen
set "result="

:: 2 Buchstaben
for /L %%i in (1,1,2) do (
    set /A rand=!random! %% 26
    for %%C in (!rand!) do set "result=!result!!chars:~%%C,1!"
)

:: 6 Zahlen
for /L %%i in (1,1,6) do (
    set /A rand=!random! %% 10
    for %%D in (!rand!) do set "result=!result!!digits:~%%D,1!"
)

:: Nochmal 2 Buchstaben
for /L %%i in (1,1,2) do (
    set /A rand=!random! %% 26
    for %%C in (!rand!) do set "result=!result!!chars:~%%C,1!"
)

:: Nochmal 6 Zahlen
for /L %%i in (1,1,6) do (
    set /A rand=!random! %% 10
    for %%D in (!rand!) do set "result=!result!!digits:~%%D,1!"
)

set "%~1=!result!"
exit /b

:genUUID
setlocal EnableDelayedExpansion
set "hex=0123456789ABCDEF"
set "uuid="

:: Abschnitt 1: 8 Hex-Zeichen
for /L %%i in (1,1,8) do (
    set /A r=!random! %% 16
    for %%x in (!r!) do set "uuid=!uuid!!hex:~%%x,1!"
)
set "uuid=!uuid!-"

:: Abschnitt 2: 4 Hex-Zeichen
for /L %%i in (1,1,4) do (
    set /A r=!random! %% 16
    for %%x in (!r!) do set "uuid=!uuid!!hex:~%%x,1!"
)
set "uuid=!uuid!-"

:: Abschnitt 3: 4 Hex-Zeichen, beginnt mit 4 (Version 4)
set "uuid=!uuid!4"
for /L %%i in (1,1,3) do (
    set /A r=!random! %% 16
    for %%x in (!r!) do set "uuid=!uuid!!hex:~%%x,1!"
)
set "uuid=!uuid!-"

:: Abschnitt 4: 4 Hex-Zeichen, beginnt mit 8-B (Variant)
set /A r=!random! %% 4 + 8
for %%x in (!r!) do set "uuid=!uuid!!hex:~%%x,1!"
for /L %%i in (1,1,3) do (
    set /A r=!random! %% 16
    for %%x in (!r!) do set "uuid=!uuid!!hex:~%%x,1!"
)
set "uuid=!uuid!-"

:: Abschnitt 5: 12 Hex-Zeichen
for /L %%i in (1,1,12) do (
    set /A r=!random! %% 16
    for %%x in (!r!) do set "uuid=!uuid!!hex:~%%x,1!"
)

endlocal & set "%~1=!uuid!"
exit /b
