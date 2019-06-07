@echo off
setlocal enabledelayedexpansion
chcp 65001
cls
if exist "%cd%\.puwws" (
  goto installed
)
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
echo 4 - Cockpit CMS, Composer
echo 5 - Laravel, MariaDB-5.5.29, HeidiSQL-10.1
echo 0 - Exit
echo.
:dialog
SET /P M=Type 1-9 then press ENTER: 

2>NUL CALL :CASE_%M%
IF ERRORLEVEL 1 CALL :DEFAULT_CASE

EXIT /B

:CASE_1
  call :writeInstallMark php
  call :showDownloadingBanner "PHP, Composer"
  call :downloadAria2 https://raw.githubusercontent.com/Rundik/PUWWS.bat/master/metalinks/PHP_SQLite_7za.meta4
  call :unpack php 7z
  call :installComposer
  call :cleanup
  mkdir www
  echo ^<?php phpinfo(); > www\index.php
  goto installed
  goto END_CASE

:CASE_2
  call :writeInstallMark mariadb
  call :showDownloadingBanner "PHP, Composer, MariaDB, HeidiSQL"
  call :downloadAria2 https://raw.githubusercontent.com/Rundik/PUWWS.bat/master/metalinks/PHP_MariaDB_HeidiSQL_7za.meta4
  call :unpack php 7z
  call :unpack mariadb 7z
  call :unpack HeidiSQL zip
  call :installComposer
  call :cleanup
  mkdir www
  echo ^<?php phpinfo(); > www\index.php
  goto installed
  goto END_CASE

:CASE_3
  call :writeInstallMark wordpress
  call :showDownloadingBanner "WordPress, HeidiSQL"
  call :downloadAria2 https://raw.githubusercontent.com/Rundik/PUWWS.bat/master/metalinks/PHP_MariaDB_HeidiSQL_WordPress_7za.meta4
  call :unpack php 7z
  call :unpack mariadb 7z
  call :unpack HeidiSQL zip
  7za x wordpress.7z -y
  ren wordpress www
  7za x postinstall.7z -y
  call :cleanup
  goto installed
  goto END_CASE

:CASE_4
  echo Not done yet
  goto END_CASE

:CASE_5
  call :writeInstallMark laravel
  call :showDownloadingBanner "Laravel, MariaDB, HeidiSQL"
  call :downloadAria2 https://raw.githubusercontent.com/Rundik/PUWWS.bat/master/metalinks/PHP_MariaDB_HeidiSQL_Laravel_7za.meta4
  call :unpack php 7z
  call :unpack mariadb 7z
  call :unpack HeidiSQL zip
  7za x postinstall.7z -y
  call :installComposer
  call :cleanup
  echo Installing laravel...
  php\php php\composer.phar create-project --prefer-dist laravel/laravel www
  php\php www\artisan migrate
  goto installed
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

:writeInstallMark
  echo %~1 > .puwws

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
  goto :EOF

:installComposer
  %cd%\php\php -r "copy('https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer', 'composer-setup.php');"
  %cd%\php\php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  %cd%\php\php composer-setup.php
  %cd%\php\php -r "unlink('composer-setup.php');"
  move composer.phar php
  echo @echo off > composer.cmd
  echo php\php php\composer.phar %%* >> composer.cmd
  goto :EOF

:cleanup
  del 7za.exe
  rem del aria2c.exe
  del *.7z
  del *.zip
  goto :EOF

:checkhash
  set /a count=1 
  for /f "skip=1 delims=:" %%a in ('CertUtil -hashfile %~3 %~1') do (
    if !count! equ 1 set "CURRHASH=%%a"
    set/a count+=1
  )
  set "CURRHASH=%CURRHASH: =%"

  if not "%~2" == "%CURRHASH%" (
    del %~3
    cls
    call :printbanner
    call :printline
    echo %~3 hash does not match
    echo %CURRHASH%
    call :printline
    goto halt
  )
  goto :EOF
:halt
call :haltHelper 2> nul
:haltHelper
() 
exit /b

:installed
  cls
  set /p build=< .puwws
  call :printbanner
  echo.
  call :printline

  2>NUL CALL :CASE2_%build%
  IF ERRORLEVEL 1 CALL :DEFAULT_CASE2

  EXIT /B

  :CASE2_php
    echo PHP server started. Close the window to stop
    call :printline
    start "php" /B %cd%\php\php.exe -S localhost:8000 -t www\
    start "browser" http://localhost:8000
    goto END_CASE2
  :CASE2_mariadb
    echo PHP, MariaDB server started. Close the window to stop
    call :printline
    start "php" /B %cd%\php\php.exe -S localhost:8000 -t www\
    start "mariadb" /B %cd%\mariadb\bin\mysqld.exe --console
    start "browser" http://localhost:8000
    goto END_CASE2
  :CASE2_wordpress
    echo Wordpress server started. Close the window to stop
    call :printline
    start "php" /B %cd%\php\php.exe -S localhost:8000 -t www\
    start "mariadb" /B %cd%\mariadb\bin\mysqld.exe --console
    start "browser" http://localhost:8000
    goto END_CASE2
  :CASE2_laravel
    echo Laravel server started. Close the window to stop
    call :printline
    start "laravel" /B %cd%\php\php.exe www\artisan serve
    start "mariadb" /B %cd%\mariadb\bin\mysqld.exe --console
    start "browser" http://localhost:8000
    goto END_CASE2

  :DEFAULT_CASE2
    goto END_CASE2
  :END_CASE2
    VER > NUL
    goto :EOF