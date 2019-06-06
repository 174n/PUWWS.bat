@echo off
chcp 65001
cls
if not exist "%cd%\aria2c.exe" (
  call :printbanner
  call :printline
  echo Downloading aria2c.exe...
  call :printline
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://uupdump.ml/autodl_files/aria2c.exe', '%cd%\aria2c.exe')"
)
call :checkhash "SHA256" "3eb8712b0db6ba466f8afe1bf606983fe8341c941bdfcadc07068288c7ca5a9c" "aria2c.exe"
goto start

:printbanner
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
goto :EOF

:printline
echo ...............................................
goto :EOF



:start
cls
call :printbanner
echo.
call :printline
echo PRESS 1-9 to select your installation, 0 to exit
call :printline
echo.
echo 1 - PHP-7.3.6, Composer, SQLite
echo 2 - PHP-7.3.6, Composer, MariaDB-5.5.29, HeidiSQL-10.1
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
  call :showDownloadingBanner "PHP, Composer"
  call :downloadAria2 https://raw.githubusercontent.com/Rundik/PUWWS.bat/master/metalinks/PHP_SQLite_7za.meta4
  call :unpack php 7z
  call :printline
  call :installComposer
  call :cleanup
  goto END_CASE

:CASE_2
  call :showDownloadingBanner "PHP, Composer, MariaDB, HeidiSQL"
  call :downloadAria2 https://raw.githubusercontent.com/Rundik/PUWWS.bat/master/metalinks/PHP_MariaDB_HeidiSQL_7za.meta4
  call :unpack php 7z
  call :unpack mariadb 7z
  call :unpack HeidiSQL zip
  call :printline
  call :installComposer
  call :cleanup
  goto END_CASE

:CASE_3
  call :showDownloadingBanner "PHP, Composer, MariaDB, HeidiSQL"
  call :downloadAria2 https://raw.githubusercontent.com/Rundik/PUWWS.bat/master/metalinks/PHP_MariaDB_HeidiSQL_WordPress_7za.meta4
  call :unpack php 7z
  call :unpack mariadb 7z
  call :unpack HeidiSQL zip
  call :unpack wordpress zip
  7za x postinstall.zip
  call :printline
  call :installComposer
  call :cleanup
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

:showDownloadingBanner
  cls
  call :printbanner
  echo.
  call :printline
  echo Downloading and unpacking %~1...
  call :printline
  echo.
  goto :EOF

:downloadAria2
  aria2c -c -x2 -Z --follow-metalink=mem --console-log-level=error %~1
  goto :EOF

:unpack
  7za x %~1.%~2 -o%~1 -y

:installComposer
  if not exist "%cd%\composer.phar" (
    php\php -r "copy('https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer', 'composer-setup.php');"
    php\php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php\php composer-setup.php
    php\php -r "unlink('composer-setup.php');"
  )
  goto :EOF

:cleanup
  del 7za.exe
  rem del aria2c.exe
  del *.7z
  del *.zip
  goto :EOF

:checkhash
  for /F "skip=1" %%i in ('certutil -hashfile %~3 %~1') do set CURRHASH=%%i & goto HaveValue
  :HaveValue
  set CURRHASH=%CURRHASH: =%

  if not "%~2" == "%CURRHASH%" (
    del %~3
    cls
    call :printbanner
    call :printline
    echo %~3 hash does not match
    call :printline
    goto halt
  )
  goto :EOF
:halt
call :haltHelper 2> nul
:haltHelper
() 
exit /b