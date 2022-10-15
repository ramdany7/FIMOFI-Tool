@ECHO off
:: Author  : Ramdany
:: Name    : Folder Icons & Movie Files Tools (FIMOFI) v0.1a
:: Date  Created : 20 September 2022
:: Last Edited      : 13 Oktober 2022
:: --------- 13 Oktober 2022
:: - genFIJ & genFIP beres,tinggal cosmetic
:: - perlu bikin copy
:: - perlu imageMagick play button
:: - tambahin Regedit remove app icon
:: - tambahin Testing Env
:: - bikin Priority config
:: - yg penting Work, jgn rapihin dulu
:: --------- 08 Oktober 2022
:: - delFI Berhasil
:: - genFIJ perlu FIX,  masih menampilkan FI yang sudah ada
:: - Perlu tes genFIP
:: - perlu bikin scPNG
:: - Explorer icon & thumbnail cache gak update
::===============================

:Name & Title                     
set name=Folder Icons ^^^& Movie Files Tools ^(FIMOFIS^) v0.1a
title %name% ^| %cd%

:getDirectory                     
cd /d "%~dp0"
if exist "%~dp0drive_path.ini" for %%d in ("%~dp0drive_path.ini") ^
do pushd "%%~dpd" &for /f "tokens=1 delims=<>" %%d in (drive_path.ini) ^
do set "lastlocation=%%d" &popd
if exist "%lastlocation%" cd /d "%lastlocation%"

:Palette                          
set g_=[90m
set gr_=[100m
set gg_=[32m
set gn_=[92m
set u_=[4m
set w_=[97m
set r_=[31m
set y_=[33m
set yy_=[93m
set c_=[36m
set cc_=[96m
set _=[0m
set -=[0m[30m-[0m
set i_=[7m
set b_=[44m[97m
set bg_=[100m
set p_=[95m
set ntc_=%_%%i_%%w_% %_%%-%
set "TAB=   "
set "ast=%r_%^*%_%"

:varSet                           
set "tagMKV=*"
set "tagFI=*"
set "ext=.mkv"
set "updateVar=0"
set p1=ping localhost -n 1 ^>nul
set p2=ping localhost -n 2 ^>nul
set printTagMKV=%ast%%c_%%tagMKV%%ast%%_% %ast%%c_%%ext%%_%
set printTagFI=%w_%%tagFI%%_%
if exist "%cd%\cover.jpg" set "coverimg=%cd%\cover.jpg"
call :varFunction

:resource                         
set MKVPROPEDIT="C:\Program Files\MKVToolNix\mkvpropedit.exe"
set MKVPROPEDITx="C:\Program Files (x86)\MKVToolNix\mkvpropedit.exe"

:checkresource                    
IF EXIST %MKVPROPEDIT% set "MKVedit=%MKVPROPEDIT%" &goto intro
IF NOT EXIST %MKVPROPEDIT% echo %r_%   Program tidak ditemukan%_% %y_%%MKVPROPEDIT%%_%
IF EXIST %MKVPROPEDITx% set "MKVedit=%MKVPROPEDITx%" &goto intro
IF NOT EXIST %MKVPROPEDITx% echo %r_%   Program tidak ditemukan%_% %y_%%MKVPROPEDITx%%_%
echo.
echo   %b_%MKVToolNix%_% %w_%belum terinstall^%c_%?%_%
echo   %g_%pastikan MKVToolNix sudah terinstall pada salah satu drive path di atas.%_%
pause >nul &exit

:::::::::::::::::::::::::::::::::::: INTERFACE ::::::::::::::::::::::::::::::::::::::::::
:intro                            
echo           %b_% %name% %_%%-%
echo    Script ini berfungsi untuk mencari file %r_%*%_%.MKV dengan keyword tertentu
echo    lalu menghapus atau mengganti cover/thumbnail yang ada didalam MKV.
%p1% &echo. &%p%
:menu                             
echo   ^| %gg_% SCMKV    %_%: Scan MKV, Melakukan pencarian file %ast%%c_%.MKV%_%
echo   ^| %gg_% SCPNG    %_%: Scan PNG, Melakukan pencarian file %ast%%c_%.PNG%_%
echo   ^| %gg_% SCJPG    %_%: Scan JPG, Melakukan pencarian file %ast%%c_%.JPG%_%
echo   ^| %gg_% ADDCO    %_%: Melakukan pencarian dan mengganti cover/thumbnail dari file MKV yang ditemukan.
echo   ^| %gg_% DELCO    %_%: Melakukan pencarian dan menghapus cover/thumbnail dari file MKV yang ditemukan.
echo   ^O %gg_% SETCO    %_%: Atur file yang akan digunakan sebagai cover/thumbnail MKV.
echo   ^P %gg_% GENFIP   %_%: Melakukan pencarian dan mengganti icon/thumbnail dari folder yang ditemukan.
echo   ^T %gg_% GENFIJ   %_%: Melakukan pencarian dan mengganti icon/thumbnail dari folder yang ditemukan.
echo   ^I %gg_% DELFI    %_%: Melakukan pencarian dan menghapus icon/thumbnail dari folder yang ditemukan.
echo   ^O %gg_% SETFI    %_%: Atur file yang akan digunakan sebagai folder icon.
echo   ^N %gg_% CPFI     %_%: Copy semua folder yg memiliki icon ke folder "- MCFI (copied folder icon)".
echo   ^S %gg_% CD       %_%: Change Directory, ganti folder/drive path untuk pencarian target file.
echo   ^| %gg_% TAGMKV   %_%: Target MKV, Ubah keyword untuk pencarian file MKV.
echo   ^| %gg_% TAGFI    %_%: Target Folder Icon, Ubah keyword untuk pencarian file Folder yg akan diberi icon.
echo   ^| %gg_% O        %_%: Membuka directory saat ini.
echo   ^| %gg_% S        %_%: Menampilkan status saat ini.
echo   ^| %gg_% CLS      %_%: Bersihkan tampilan terminal.
echo   ^| %gg_% R        %_%: Restart script.
:status                           
echo. &%p1%
echo  %_%-------------------  Status ---------------------------
echo  directory         : %i_%%cd%%-%
echo  cover image       : %g_%%coverimg%%_%
echo  target file MKV   : %printTagMKV%
echo  target folder icon: %printTagFI%
echo  %_%-------------------------------------------------------
:options                          
%p1% &echo.&echo.
echo %_% Options: %GG_%SCANMKV%G_%^|%GG_%DELCOVER%G_%^|%GG_%SETCOVER%G_%^|%GG_%ADDCOVER%G_%^|%GG_%TAGMKV%G_%
echo  %GG_%SCANPNG%G_%^|%GG_%SCANJPG%G_%^|%GG_%GENFIP%G_%^|%GG_%GENFIJ%G_%^|%GG_%SETFI%G_%^|%GG_%COPY%G_%^|%GG_%ON%G_%^|%GG_%OFF%G_%^|%GG_%TAGFI%G_%^|^
%GG_%CD%G_%^|%GG_%O%G_%^|%GG_%S%G_%^|%GG_%CLS%G_%^|%GG_%R%G_%^|%GG_%HELP%G_%^|.. 
echo %g_%--------------------------------------------------------------------------------------------------[92m
title %name% ^| %cd%
set /p "input=%_%%w_%%cd%%_%%gn_%>"
echo %-%
echo %-%
if /i %input%==scanmkv   goto scanMkv
if /i %input%==scanjpg   goto scanFolderJPG
if /i %input%==scanpng   goto scanFolderPNG
if /i %input%==cls      goto close
if /i %input%==cd       goto changedir
if /i %input%==cd..       goto changedirBack
if /i %input%==o        goto opendir
if /i %input%==tagmkv  goto changeTargetMKV
if /i %input%==tagfi   goto changeTargetFI
if /i %input%==r        goto restart
if /i %input%==s        goto status
if /i %input%==delcover   goto delcover
if /i %input%==addcover   goto addcover
if /i %input%==setcover   goto setcover
if /i %input%==genfiJ  goto generateFolderIconbyJPG
if /i %input%==genfiP  goto generateFolderIconbyPNG
if /i %input%==genfiB  goto generateFolderIconbyBMP
if /i %input%==genfiI  goto generateFolderIconbyICO
if /i %input%==genfiJPEG  goto generateFolderIconbyJPEG
if /i %input%==ShadowConfig    goto ShadowConfigurator
if /i %input%==ConvertConfig    goto ConvertConfigurator
if /i %input%==TestConfig    goto TestConfig
if /i %input%==setfi   goto setFolderIcon
if /i %input%==delfi   goto deleteFolderIcon
if /i %input%==cpfi   goto copyFolderIcon
if /i %input%==on   goto folderIcon-ON
if /i %input%==off   goto folderIcon-OFF
if /i %input%==help    goto help
if /i %input%==refresh    goto refreshFolderIcon
if /i %input%==refreshforce    goto refreshForce
if /i %input%==delcoverForce  goto delcoverForce
if /i %input%==tc    goto colour
echo %_%%i_%gak ada opsi itu bambank! %_%%-%
goto options


:varFunction                      
set "result=0"

set "PrintCurrentdir=IF EXIST "*%tagMKV%**%ext%" echo   %_%%cd%"
set "PrintSubdir=IF EXIST "*%tagMKV%**%ext%" echo   %_%%%a"

set "scanDetect=FOR %%a in (*%tagMKV%**%ext%) do"
set "do=echo   %g_%-- %c_%%%a%_%%g_% &set /a result+=1"

set "editExit=%MKVedit% |exit /b"
set "exitCode=>nul"

set printTagMKV=%ast%%c_%%tagMKV%%ast%%_% %ast%%c_%%ext%%_%
set printTagFI=%w_%%tagFI%%_%

set delcover=--delete-attachment name:cover.jpg  --delete-attachment name:cover.png ^
			  --delete-attachment name:cover.jpeg --delete-attachment name:cover.gif ^
			  --delete-attachment name:cover
set delCoverforce=--delete-attachment "mime-type:image/jpeg" --delete-attachment "mime-type:image/png"
exit /b


:scanFunction                     
%PrintCurrentdir%
%scanDetect% (%do%)
FOR /d /r "%cd%" %%a in (*) do (
pushd "%%a" 
%PrintSubdir%
%scanDetect% (%do%)
popd)
exit /b

:changeTargetMKV                  
set /p "newTag= %-%%-%%-%%yy_%Masukan keyword file:%c_%" 
set "tagMKV=%newTag%"
call :varFunction 
echo    %_%Target pencarian file MKV: %printTagMKV% &goto Options

:scanMkv                          
echo      %cc_%Scanning MKV..%_%
set "ext=.mkv"
call :varFunction
call :scanFunction
IF /i %result% LSS 1 (echo   ^(file dengan keyword %printTagMKV% tidak ditemukan.^) &goto options)
echo. &echo    %w_%^(%c_%%result%%_%%w_%^) file ditemukan.%_% &echo. &goto options

:delCover                         
echo      %cc_%Menghapus cover MKV..%_%
set "ext=.mkv"
call :varFunction
set "Action=%scanDetect% (%do% &%MKVedit% "%%a" %delCover% %exitcode%)"
%PrintCurrentdir%
%Action%
for /d /r "%cd%" %%a in (*) do (
pushd "%%a"  
%PrintSubdir%
%Action% 
popd)
call :coverResult &goto options

:coverResult                      
IF /i %result% LSS 1 (echo   ^(file dengan keyword %printTagMKV% tidak ditemukan.^) &goto options)
echo. &echo    %w_%^(%c_%%result%%_%%w_%^) file ditemukan. Proses selesai.%_% &echo. &exit /b

:setCOVER                         
echo   %g_%File path untuk "setcover" bisa diisi file path lengkap ^(contoh:%u_%D:\pahe\gambar\cover.jpg%_%%g_%^)
echo   atau bisa juga diisi hanya nama filenya saja jika file yg akan dijadikan cover berada
echo   atu folder dengan file MKV nya. ^(contoh:%u_%cover.jpg%_%%g_%^) &echo.
set /p "coverimg=  %_%    Masukan file path:%w_%"
%p1% &goto status

:addCover                         
echo      %cc_%Mengganti cover MKV..%_%
set "ext=.mkv"
call :varFunction
set Action=%MKVedit% "%%~nxa" %delcover% --attachment-name cover --add-attachment
%PrintCurrentdir%	&call :addCover-priorityOptions
for /d /r "%cd%" %%a in (*) do (pushd "%%a"
	%PrintSubdir%	&call :addCover-priorityOptions 
popd)
call :coverResult	&goto options
:addCover-priorityOptions         
%scanDetect% (%do%
		 if exist "%%~na.jpg"  			( echo      %g_%Cover: %%~na.jpg			%r_% &%Action% "%%~na.jpg" 				%exitcode%
) else ( if exist "%%~na-landscape.jpg" ( echo      %g_%Cover: %%~na-landscape.jpg	%r_% &%Action% "%%~na-landscape.jpg"	%exitcode%
) else ( if exist "%%~na-fanart.jpg" 	( echo      %g_%Cover: %%~na-fanart.jpg	%r_% &%Action% "%%~na-fanart.jpg" 		%exitcode%
) else ( if exist "%%~na.jpeg" 			( echo      %g_%Cover: %%~na.jpeg			%r_% &%Action% "%%~na.jpeg" 			%exitcode%
) else ( if exist "%coverimg%" 			( echo      %g_%Cover: %coverimg%			%r_% &%Action% "%coverimg%" 			%exitcode%
) else ( echo      %r_%^(tidak dapat mengganti cover, gambar tidak ditemukan.^)%_% ))))))
exit /b
:addCover-priorityVar
set "NamaFile=%%~na"
set "Prioritas1=%namaFile%.jpg"
set "Prioritas2=%namaFile%-lanscape.jpg"
set "Prioritas3=%namaFile%-fanart.jpg"
set "Prioritas4=%namaFile%-poster.jpg"
set "Prioritas5=%setcover%"



:scanFolderJPG                    
echo %TAB%%TAB%%cc_%Scanning JPG..%_%
set result=0 &set "target=.jpg" &goto scannerFolderIcon
:scanFolderPNG                    
echo %TAB%%TAB%%cc_%Scanning PNG..%_%
set result=0 &set "target=.png" &goto scannerFolderIcon
:scannerFolderIcon                            
::current folder
IF EXIST "*%target%" echo %TAB%%_%%cd% &set /a result+=1
FOR %%a in (*%target%) do (echo %TAB%%g_% -- %c_%%%a%_%%g_%)
::recursive
FOR /d /r "%cd%" %%a in (*) do (
	pushd "%%a" 
		IF EXIST "*%target%" echo %TAB%%_%%%a &set /a result+=1
		FOR %%a in (*%target%) do (echo %TAB%%g_% -- %c_%%%a%_%%g_%) 
	popd)
IF /i %result% LSS 1 (echo    ^(file %ast%%target% tidak ditemukan.^) &goto options)
echo. &echo    %w_%^(%c_%%result%%_%%w_%^) folder berisi file %ast%%c_%%target%%_%%w_% ditemukan.%_% &echo.
echo   %g_%jika ada lebih  dari  satu  file %ast%%g_%%target%  didalam  folder, maka  yang akan dipilih sebagai
echo   folder icon adalah file %ast%%g_%%target% teratas didalam folder, atau file dengan nama %c_%foldericon%target%%_% 
set result=0 &goto options

:generateFolderIconbyJPG                       
echo %TAB%%TAB%%cc_%Scanning Folder and JPG..%_%
set "target=*.jpg" &set "result=0" &goto GenerateFolder

:generateFolderIconbyPNG                       
echo %TAB%%TAB%%cc_%Scanning Folder and PNG..%_%
set "target=*.png" &set "result=0" &goto GenerateFolder

:generateFolderIconbyico                       
echo %TAB%%TAB%%cc_%Scanning Folder and BMP..%_%
set "target=*.ico" &set "result=0" &goto GenerateFolder

:generateFolderIconbyBMP                       
echo %TAB%%TAB%%cc_%Scanning Folder and BMP..%_%
set "target=*.bmp" &set "result=0" &goto GenerateFolder

:generateFolderIconbyJPEG                       
echo %TAB%%TAB%%cc_%Scanning Folder and JPEG..%_%
set "target=*.jpeg" &set "result=0" &goto GenerateFolder

:
:GenerateFolder
call :IconGeneratorSettings
if not "%CustomConvertConfig%"=="" %p2% &echo %_%%TAB%Custom Config Detected. &echo %i%%yy_%%CustomConvertConfig% %-% &echo. &%p2%
::current dir
if exist "desktop.ini" echo %y_%%TAB%"%cd%" %_%
if not exist "%target%" if not exist "desktop.ini" echo %g_%%TAB%"%cd%" %_%
if exist "%target%" if not exist "desktop.ini" echo %_%%TAB%"%cd%" %_% 
if exist "%target%" if not exist "desktop.ini" (
	for %%f in (%target%) do (
				if not exist "folderIcon.ico"    echo %g_%%TAB%Folder icon: %c_%"%%f"%_%%g_%%r_%
				if not exist "folderIcon.ico" (
					"%~dp0convert.exe" "%%f" %convert% "folderIcon.ico"
					"%~dp0convert.exe" |exit /b
					if exist "foldericon.ico" echo ^[.ShellClassInfo^] >desktop.ini ^
						&>>desktop.ini echo IconResource=folderIcon.ico,0 ^
						&>>desktop.ini echo ^;Folder Icon generated using FIMOFI Script written by ^Ram^dan^y. ^
						&attrib +h +s "desktop.ini" >nul ^
						&attrib +h +s "folderIcon.ico" >nul ^
						&set /a result+=1
					)
					if not exist "foldericon.ico" echo convert "%%a" ke icon gagal.
				)
		if exist "desktop.ini" attrib +r "%cd%" >nul
		echo WHAT IS THIS %yy_% %cd% %_%
	rem call :IconGenerator
	)
::recursive
for /d /r "%cd%" %%a in (*) do (
	PUSHD "%%a"
		if exist "desktop.ini" echo %y_%%TAB%"%%a" %_%
		if not exist "%target%" if not exist "desktop.ini" echo %g_%%TAB%"%%a" %_%
		if exist "%target%" if not exist "desktop.ini" echo %_%%TAB%"%%a" %_% 
		if exist "%target%" if not exist "desktop.ini" (
			for %%f in (%target%) do (
				if not exist "folderIcon.ico" echo %g_%%TAB%Folder icon: %c_%"%%f"%_%%g_%%r_%
				if not exist "folderIcon.ico" (
					"%~dp0convert.exe" "%%f" %convert% "folderIcon.ico"
					"%~dp0convert.exe" |exit /b
					if exist "foldericon.ico" echo ^[.ShellClassInfo^] >desktop.ini ^
						&>>desktop.ini echo IconResource=folderIcon.ico,0 ^
						&>>desktop.ini echo ^;Folder Icon generated using FIMOFI Script written by ^Ram^dan^y. ^
						&attrib +h +s "desktop.ini" >nul ^
						&attrib +h +s "folderIcon.ico" >nul ^
						&set /a result+=1
				)
				if not exist "foldericon.ico" echo    convert "%%a" ke icon gagal.
			)
		if exist "desktop.ini" if exist "foldericon.ico" attrib +r "%%a" >nul
		%yy_% %cd% %_%
		rem call :IconGenerator
			)
	POPD
	)
goto genfiresult
:LoadFolderTemplate    
if exist "%~dp0\Template" PUSHD "%~dp0\Template"
for %%i in (*.png) do (
	echo   %cc_% %%i %_%
	)
goto options
:IconGeneratorSettings
set Shadow=70x1.3+2+3.5
set ConvertConfig=-resize 245x245 ^^( +clone -background BLACK -shadow %shadow% ^^) +swap -background none -layers flatten -gravity Center -extent 256x256
for %%B in ("%~dp0config.ini") do (pushd "%%~dpB" &for /f "tokens=1,2 delims==<>" %%C in (config.ini) do set "%%C=%%D" &popd)
if "%CustomConvertConfig%"=="" (set "Convert=%ConvertConfig%") else set "Convert=%CustomConvertConfig%"
if "%CustomConvertConfig%"=="" if /i %target%==*.png (set Shadow=100x0+0+0)
if /i %target%==*.ico (set Convert=-resize 256x256!)
exit /b

:IconGenerator
Echo 		Icon Generator is OFF
pause&goto options
:ConvertConfigurator               
call :IconGeneratorSettings
echo %_%Current Converter config:%yy_%%Convert% %_%
set /p "CustomConvertConfig=%_%Input new config:%yy_%"
goto TestConfig
:ShadowConfigurator               
call :IconGeneratorSettings
echo %_%Current config:%yy_%%Shadow% %_%
set /p "CustomShadowConfig=%_%Input new config:%yy_%"
:TestConfig
call :IconGeneratorSettings
set inputFile=testConfig.jpg
set outputFile=testConfig.ico
echo. &echo %_%Config: %yy_%%Convert%%_%%g_%
echo. &echo %_%%cc_%Testing config to ^-^> %g_%"%~dp0%inputFile%"%r_%
"%~dp0convert.exe" "%~dp0%inputFile%" %Convert% "%~dp0%outputFile%"
"%~dp0convert.exe" |exit /b
if exist "%~dp0%outputFile%" (explorer.exe "%~dp0%outputFile%") else (echo    %i_%%r_% Convert fail^! %-%  )
goto options

:genfiresult                     
IF /i %result% LSS 1 (echo. &echo %TAB%^(file %ast%.jpg tidak ditemukan.^) &goto options)
echo. &echo %TAB%%w_%^(%c_%%result%%_%%w_%^) folder berisi file %ast%%c_%.jpg%_%%w_% diproses.%_%
ie4uinit.exe -ClearIconCache
ie4uinit.exe -show
goto options

:generateFolderIconbyPNGx          
set "target=*.png"
set "result=0"
IF EXIST "%target%" echo %_%%cd% &set /a result+=1
call :IconGenerator
for /d /r "%cd%" %%a in (*) do (
	pushd "%%a"
		IF EXIST "%target%" echo %_%%%a &set /a result+=1
		call :IconGenerator
	popd)
goto genfiresult




:deleteFolderIcon                 
echo %TAB%%TAB%%cc_%Scanning folder icon..%_%
set result=0
		IF EXIST "desktop.ini" echo     %_%%y_%%cd%%_% &set /a result+=1
for /d /r "%cd%" %%a in (*) do ( pushd "%%a"  
		IF EXIST "desktop.ini" echo     %_%%y_%%%a%_% &set /a result+=1 
									popd )                     
:deleteFolderIcon-Asking          
IF /i %result% LSS 1 echo. &echo %_%%TAB%^(%r_%%result%%_%%_%^) folder icon tidak ditemukan. &goto options
echo. &echo %_%%TAB%  ^(%y_%%result%%_%%_%^) folder icon ditemukan.%_% &echo.
echo       %_%%r_%Reset (%yy_%%result%%_%%r_%^) folder icon diatas^?%-% 
echo   %ast%%g_%Folder icon pada folder akan dinon-aktifkan dan file desktop.ini dan foldericon.ico%_%
echo   %g_% didalam folder akan dihapus. Masukan perintah %gg_%Y%g_% untuk konfirmasi.%_%
set /p "cho=%-%%-%%-%Options: %gn_%Y%_% / %gn_%N%_% %gn_%> " 
echo %-%%r_%
if /i %cho%==Y goto deleteFolderIcon-Confirm
echo %_%%TAB%%I_%     Dibatalkan     %_% &goto options
:deleteFolderIcon-Confirm         
IF EXIST "desktop.ini" attrib /d -r "%cd%" &attrib -h -s "desktop.ini" &del /f /q "desktop.ini" ^
& if exist "foldericon.ico" &attrib -s -h "foldericon.ico" &del /f /q "foldericon.ico"
for /d /r "%cd%" %%a in (*) do (
pushd "%%a"  
IF EXIST "desktop.ini" attrib /d -r "%%a" &attrib -h -s "desktop.ini" &del /f /q "desktop.ini" ^
& if exist "foldericon.ico" &attrib -s -h "foldericon.ico" &del /f /q "foldericon.ico"
popd)
echo            %_%%i_%    Done!    %_%%-%
goto options

:refreshFolderIcon                
echo. &echo %TAB%%ntc_%%cc_%refreshing folder icon on "%cd%" ..%_%
if exist "%~dp0refresh.bat" start "Refresing .." cmd /c "%~dp0refresh.bat"
if not exist "%~dp0refresh.bat" echo %r_%"%~dp0refresh.bat" %_% %r_%(tidak ditemukan)%_%
echo. &goto options
:refreshForce
echo %TAM% %cc_%Forcing windows to update icon cache..
C:\Users\exer\AppData\Local\IconCache.db
ie4uinit.exe -show
taskkill /F /IM explorer.exe
PUSHD "%userprofile%\AppData\Local\Microsoft\Windows\Explorer"
attrib -h iconcache_*.db
DEL /A /Q "%localappdata%\IconCache.db"
DEL /A /F /Q "%localappdata%\Microsoft\Windows\Explorer\iconcache*"
explorer.exe "%cd%"
POPD

start explorer
goto options
:folderIcon-ON                    
FOR /R "%cd%" %%I IN (.) DO attrib +r "%%I" >nul
echo %_%%i_%%gn_% ON  %_% Folder icon di Aktifkan.
goto options
:folderIcon-OFF                   
FOR /R "%cd%" %%I IN (.) DO attrib -r "%%I" >nul
echo %_%%i_%%r_% OFF %_% Folder icon di Nonaktifkan.
goto options
:close                            
cls &goto options
:changedir                        
set /p "here=  %-%%-%%w_%Masukan drive path:%_%%i_%"
if exist "%here%" (cd /d "%here%") else %p1% &echo %-% %i_%%r_%Drive path tidak ditemukan.%_%%-% &echo. &%p2% &goto options
%p1% &echo %-% &title %name% ^| %cd% &%p1% &>"%~dp0Drive_path.ini" echo %cd%&goto options
:changedirBack                    
cd .. &%p1% &title %name% ^| %cd% &%p1% 
echo   Changing directory to %i_%%cd%%-% &>"%~dp0Drive_path.ini" echo %cd%&goto options
:opendir                          
echo   %_%Membuka..   %i_%%cd%%-% &echo. &explorer.exe "%cd%" &goto options
:restart                          
start "" "%~f0" &exit

:help                             
echo    %gg_% scmkv    %_%: Scan MKV, Melakukan pencarian file %ast%%c_%.MKV%_%
echo    %gg_% scpng    %_%: Scan PNG, Melakukan pencarian file %ast%%c_%.PNG%_%
echo    %gg_% scjpg    %_%: Scan JPG, Melakukan pencarian file %ast%%c_%.JPG%_%
echo    %gg_% delcover %_%: Melakukan pencarian dan menghapus cover/thumbnail dari file MKV yang ditemukan.
echo    %gg_% setcover %_%: Atur file yang akan digunakan sebagai cover/thumbnail MKV.
echo    %gg_% addcover %_%: Melakukan pencarian dan mengganti cover/thumbnail dari file MKV yang ditemukan.
echo     %g_%Note: "addcover" akan otomatis memilih nama file .jpg yang namanya sama, sebagai cover MKV.
echo      contoh: %u_%D:\movie\cover.jpg%_%%g_% ^ -------------------^>  (nama file cover yg sudah diatur oleh "setcover"^)
echo              %u_%D:\movie\folder.nama.movie\nama.movie%c_%.mkv%_%%g_% ^(target file yg ditemukan^)
echo              %u_%D:\movie\folder.nama.movie\nama.movie%c_%.jpg%_%%g_% ^(nama file .jpg yg sama dengan nama movie^)
echo     Maka cover yg akan dimasukan kedalam nama.movie.mkv adalah nama.movie.jpg, "setcover" akan diabaikan.
echo    %gg_% cd       %_%: Change Directory / ganti drive path untuk pencarian target file.
echo    %gg_% tag      %_%: Ubah keyword untuk pencarian file MKV.
echo    %gg_% cls      %_%: Bersihkan tampilan terminal.
echo    %gg_% r        %_%: Restart script.
goto options



:colour
start "Colour options" cmd /c "D:\Document\Script\Text color in batch\Tes colour.bat"
goto options

:otherScript (recycle bin) ::::::::::::::::::::::::::::::::::::::::::::::
exit
for %%F in (.) do echo folder name is %%~nF                                             <<<<<< to get folder name
set "print=for /f %%^" in ("""") do echo (%%~" (pakai satu lagi tandakutip di ujung)   <<<<<< (%print% trik untuk print output jika echo error)
set "exitCode=&echo Error code: %errorlevel% &%editExit%"                              <<<<<< cek errorlevel dari action


:hapusFolderIcon.old
IF EXIST "desktop.ini" (if exist "FolderIcon.ico" echo %_%Removing folder icon.. %_%%g_%%cd%%_%)
IF EXIST "desktop.ini" (if exist "FolderIcon.ico" (
		attrib "%cd%" -r 
		attrib "desktop.ini" -s -h
		del "desktop.ini"
		del "FolderIcon.ico"
))
::If exist "desktop.ini" echo echo Removing folder icon.. %_%%g_%%cd%%_% &attrib "%cd%" -r &attrib -h -s "desktop.ini" &del "desktop.ini"
::If exist "FolderIcon.ico" echo echo Removing folder icon.. %_%%g_%%cd%%_% &attrib "%cd%" -r &attrib -h -s "FolderIcon.ico" &del "FolderIcon.ico"

for /d /r "%cd%" %%a in (*) do (
    pushd "%%~fa"
IF EXIST "desktop.ini" if exist "FolderIcon.ico" echo Removing folder icon.. %_%%g_%%%a%%_%
IF EXIST "desktop.ini" (if exist "FolderIcon.ico" (
		echo UHUHUHUHUHU %%~fa
		attrib "%cd%" -r 
		attrib "desktop.ini" -s -h
		del "desktop.ini"
		del "FolderIcon.ico"
))
::If exist "desktop.ini" echo echo Removing folder icon.. %_%%g_%%cd%%_% &attrib "%cd%" -r &attrib -h -s "desktop.ini" &del "desktop.ini"
::If exist "FolderIcon.ico" echo echo Removing folder icon.. %_%%g_%%cd%%_% &attrib "%cd%" -r &attrib -h -s "FolderIcon.ico" &del "FolderIcon.ico"
	popd
)
goto options

: MENDING SIMPLE YANG PENTING WORK!
: MENDING SIMPLE YANG PENTING WORK!:deleteFolderIcon (ribet, Gak bener)
echo   %_%Scanning folder icon..
set fiAktif=0
set "deleteFolderIconChoice=set noChoiceYet=1"
set deleteFolderIcon-Confirm=if exist "%%i" for %%F in (.) do attrib -r "%%~dpnF" >nul ^
								&if exist "%%i" attrib -h -s "%%i" >nul &if exist "%%i" del "%%i" >nul
set deleteFolderIcon-ScanOnly=if exist "%%~dpidesktop.ini" pushd "%%~dpi" ^
								 &set /a fiAktif+=1 &for %%F in (.) do echo %w_% %%~dpnF%r_%
set "deleteFolderIconLoop=%deleteFolderIcon-ScanOnly%"
: MENDING SIMPLE YANG PENTING WORK!:deleteFolderIcon-Action (ribet, Gak bener)
for /r %%i in (desktop.ini) do (
		echo ini file nya kah %%~fi
		%deleteFolderIconLoop%
		popd
		)
%deleteFolderIconChoice%
: MENDING SIMPLE YANG PENTING WORK!:deleteFolderIcon-Asking (ribet, Gak bener)
if /i %fiAktif% LSS 1 (echo  %i_%%r_%Folder icon tidak ditemukan.%_%)
echo.
echo %_%^(%w_%%fiAktif%%_%^) Folder ditemukan.
echo %_%%yy_%Hapus folder icon dari list folder diatas^?%-% 
echo %g_%Hanya icon folder yang dihapus. Folder dan file didalamnya tidak akan ikut dihapus.%_%
echo %g_%Masukan perintah %gg_%Y%g_% untuk konfirmasi.%_%
set /p "cho=Options: %gg_%Y%_% / %gg_%N%_% %gg_%>%_%" 
if /i %cho%==Y set deleteFolderIconLoop=^%deleteFolderIcon-Confirm^% &set "deleteFolderIconChoice=goto options" &goto deleteFolderIcon-Action
echo %I_%Aksi dibatalkan %_% &echo. &goto options