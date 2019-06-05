@echo off

if not exist "%~dp0aria2c.exe" (
  echo Downloading aria2c.exe...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://uupdump.ml/autodl_files/aria2c.exe', '%~dp0aria2c.exe')"
)
call :checkhash "3eb8712b0db6ba466f8afe1bf606983fe8341c941bdfcadc07068288c7ca5a9c" "aria2c.exe"
goto start
:checkhash
  for /F "skip=1" %%i in ('certutil -hashfile %~2 SHA256') do set CURRHASH=%%i & goto HaveValue
  :HaveValue
  set CURRHASH=%CURRHASH: =%

  if not "%~1" == "%CURRHASH%" (
    del %~2
    echo "%~2 hash does not match"
    goto halt
  )
goto :EOF
:halt
call :haltHelper 2> nul
:haltHelper
() 
exit /b




:start

chcp 65001
cls
echo █████▙▄ ▜██▌███▙███ ██ ██████▙▐██ ███ ▗▟███▄ 
echo ███████▖███▌███▖███▝██▌███▝██▛▐██▗███ ██████▙
echo ██▛▌▟██▌▟██▖██▜▖▜██▐██▌█▛▙ ███▐█▜▙██▌▝███▖▀▀▀
echo ██████▛ ▜█▜▌███▘▐████████▛ ▜▟█████▛█▌ ▜███▙▖ 
echo ██▜▛▘▘  ▜██▌█▟█▌▐███▛█▟██▘ ▐██▛██▜██▖  ▝▜███▙
echo ███▌    ▜██▌███▖ ██▟▛▜██▟▌ ▐███▌████ ▐██▌▐███
echo ███▌    ▜█▙██▛█  ███▛▐███   ██▜▌▐██▛ ▝█████▙▛
echo ██▟▌     ▀███▛▘  ▜██▌ ██▙   ███ ▐██▌  ▝▜███▀ 
echo.
echo     Portable Universal Wundows Web Server
echo.
echo ...............................................
echo PRESS 1-9 to select your installation, 0 to exit
echo ...............................................
echo.
echo 1 - PHP-7.3.6, Composer, SQLite
echo 2 - PHP-7.3.6, Composer, MariaDB-5.5.29, HeidiSQL_10.1
echo 3 - WordPress-5.2.1, HeidiSQL_10.1
echo 4 - Cockpit CMS
echo 5 - Cockpit CMS, Vue.js frontend (with cli)
echo 6 - Cockpit CMS, Vue.js frontend (without cli)
echo 7 - Composer, Laravel
echo 8 - Composer, Laravel, Vue.js frontend (with cli)
echo 9 - Composer, Laravel, Vue.js frontend (without cli)
echo 0 - Exit
echo.
:dialog
SET /P M=Type 1-9 then press ENTER: 

2>NUL CALL :CASE_%M%
IF ERRORLEVEL 1 CALL :DEFAULT_CASE

EXIT /B

:CASE_1
  echo PHP-7.3.6, Composer, SQLite  
  goto END_CASE

:CASE_2
  echo PHP-7.3.6, Composer, MariaDB-5.5.29, HeidiSQL_10.1  
  goto END_CASE

:CASE_3
  echo WordPress-5.2.1, HeidiSQL_10.1  
  goto END_CASE

:CASE_4
  echo Not done yet
  goto END_CASE

:CASE_5
  echo Not done yet
  goto END_CASE

:CASE_6
  echo Not done yet
  goto END_CASE

:CASE_7
  echo Not done yet
  goto END_CASE

:CASE_8
  echo Not done yet
  goto END_CASE

:CASE_9
  echo Not done yet
  goto END_CASE

:CASE_0
  goto END_CASE

:DEFAULT_CASE
  goto dialog
:END_CASE
  VER > NUL
  goto :EOF
