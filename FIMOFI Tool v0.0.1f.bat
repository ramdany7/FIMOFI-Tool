@ECHO off
chcp 65001 >nul
:: Author  : Ramdany
:: Name    : FIMOFI Tools v0.0.1f
:: Date  Created : 20 September 2022
:: Last Edited   : 04 November 2022
:: - New Scanner
:: - New Generator
:: - Scanner now using FOR from DIR command
:: - hapus label :FolderTemplateDeactivated
:: - Adding Activate, Deactivate
:: - All integrate into GetDir
:: - Integrate refresh into main
:: - New Remover FI
:Name                             
set name=FIMOFI Tools v0.0.1f
title %name% ^| %cd%

:Start
call :varset
call :LoadConfig
call :UpdateVar
if /i "%xInput%"=="Refresh.Here"	cd /d %1 &set "cdonly=false" &set "RefreshOpen=Index" &goto Refresh
if /i "%xInput%"=="RefreshNR.Here"	cd /d %1 &set "cdonly=false" &set "RefreshOpen=Index" &goto Refresh-NoRestart
if /i "%xInput%"=="Refresh"			cd /d %1 &set "cdonly=true" &set "RefreshOpen=Select" &goto Refresh
if /i "%xInput%"=="RefreshNR"		cd /d %1 &set "cdonly=true" &set "RefreshOpen=Select" &goto Refresh-NoRestart
if not "%xInput%"=="" goto Input-Context

:Intro                            
echo. &echo           %b_% %name% %_%%-%
echo   %u_%Drag and Drop%_% folder ke layar Terminal ini, lalu tekan Enter untuk mengganti direktori.
echo   %u_%Drag and Drop%_% file   ke layar Terminal ini, lalu tekan Enter untuk mengganti folder icon direktori saat ini.%_%
echo.
echo   %gg_%TAG      %_%: Atur  keyword  pencarian untuk menentukan file mana yang akan dijadikan folder icon.
echo   %gg_%SCAN     %_%: Melakukan pencarian file berdasarkan TAG yang ditentukan.
echo   %gg_%TEMPLATE %_%: Memilih  template  untuk  dijadikan  folder  icon.
echo   %gg_%GENERATE %_%: Memulai proses untuk  menjadikan file yang ada  didalam folder  menjadi icon folder.
echo   %gg_%REFRESH  %_%: Melakukan  reset  icon cache   untuk  meng-update   icon/thumbnail  pada   Explorer.
echo   %gg_%RESET    %_%: Reset folder, nonaktifkan folder icon pada direktori dan semua direktori didalamnya.
echo   %gg_%SCANMKV  %_%: Melakukan pencarian file MKV berdasarkan TAGMKV yang ditentukan.
echo   %gg_%ADDCOVER %_%: Melakukan  pencarian  dan  mengganti  cover/thumbnail  dari file MKV yang ditemukan.
echo   %gg_%DELCOVER %_%: Melakukan  pencarian  dan  menghapus  cover/thumbnail  dari file MKV yang ditemukan.
echo   %gg_%SETCOVER %_%: Atur file yang akan digunakan sebagai cover/thumbnail MKV.
echo   %gg_%S        %_%: Menampilkan status.
echo   %gg_%CLS      %_%: Bersihkan tampilan terminal.
echo   %gg_%HELP     %_%: Menampilkan daftar perintah yang tersedia beserta detail fungsi-fungsinya. 
echo.
:Status                           
%p1%
echo   %_%-------%i_% Status %_%----------------------------------------
echo   Directory           : %u_%%cd%%-%
echo   Target Folder Icon  : %printTagFI%
if exist "%FItemplate%" ^
echo   Folder Icon Template: %cc_%%templatename%%_%
if not exist "%FItemplate%" ^
echo   Folder Icon Template: %r_%!ERROR (%FItemplate%)%i_%Template tidak ditemukan.%-%
echo   Target MKV          : %printTagMKV%
echo   Setcover            : %g_%%coverimg%%_%
echo   %_%-------------------------------------------------------
goto Options-QuickMenu
:Options                          
call :ContextExit
echo. &echo.&echo.&echo.
:Options-QuickMenu
call :ContextExit
echo %_%%GG_%SCAN%G_%^|%GG_%GEN%G_%^|%GG_%REFRESH%G_%^|%GG_%COPY%G_%^|%GG_%TAG%G_%^|^
%GG_%SCANMKV%G_%^|%GG_%DELCOVER%G_%^|%GG_%SETCOVER%G_%^|%GG_%ADDCOVER%G_%^|%GG_%TAGMKV%G_%^|%GG_%O%G_%^|%GG_%S%G_%^|%GG_%CLS%G_%^|%GG_%R%G_%^|%GG_%HELP%G_%^|..
:Options-CommandInput             
echo %g_%--------------------------------------------------------------------------------------------------
title %name% ^| %cd%
call :SaveConfig &call :UpdateVar

:Input-Command
set input=kosong
set /p "input=%_%%w_%%cd%%_%%gn_%>"
set "input=%input:"=%"
echo %-% &echo %-% &echo %-%
if /i "%input%"=="cc"			start "" "%~f0" Refresh
if /i "%input%"=="scan"		goto Scan
if /i "%input%"=="tag"		goto Keyword
if /i "%input%"=="gt"			goto Scan-GetDir
if /i "%input%"=="gen"		goto Generate
if /i "%input%"=="generate"	goto Generate
if /i "%input%"=="copy"		goto CopyFolderIcon
if /i "%input%"=="refresh-f"	goto Refresh-NoRestart
if /i "%input%"=="refresh"	goto Refresh
if /i "%input%"=="rf"			goto Refresh
if /i "%input%"=="template"	goto LoadFolderTemplate 
if /i "%input%"=="ft"			goto LoadFolderTemplate
if /i "%input%"=="Tes"		goto TestConfig
if /i "%input%"=="setfi"		goto SetFolderIcon
if /i "%input%"=="reset"		goto DeleteFolderIcon
if /i "%input%"=="rst"		goto DeleteFolderIcon
if /i "%input%"=="on"			goto FolderIcon-ON
if /i "%input%"=="off"		goto FolderIcon-OFF
if /i "%input%"=="s"			goto Status
if /i "%input%"=="tagmkv"	goto ChangeTargetMKV
if /i "%input%"=="scanmkv"	goto ScanMkv
if /i "%input%"=="delcover"	goto Delcover
if /i "%input%"=="addcover"	goto Addcover
if /i "%input%"=="setcover"	goto Setcover
if /i "%input%"=="help"		goto Help
if /i "%input%"=="cd.."		goto ChangedirBack
if /i "%input%"=="o"			goto Opendir
if /i "%input%"=="of"			goto OpendirFimofi
if /i "%input%"=="cls"		cls&goto options
if /i "%input%"=="r"			start "" "%~f0" &exit
if /i "%input%"=="delcover-f"goto DelcoverForce
if /i "%input%"=="tc"			goto Colour
if exist "%input%" goto directInput
echo %TAB%%TAB%%r_%Input tidak valid.  %_%
echo %TAB%%g_%Pastikan input adalah perintah, alamat file atau alamat direktori yang tersedia.
goto options

:Input-Context
@echo off
set Gen=cd /d %1 ^&set input=Generate
set Dir=cd /d %1
cls &echo. &echo. &echo.
REM Selected file
if /i "%xInput%"=="Create"						cd /d "%~dp1" &set input=%1 &set "RefreshOpen=Select" &goto DirectInput
if /i "%xInput%"=="ChoTemplate"					goto LoadFolderTemplate
REM Selected Dir	
if /i "%xInput%"=="OpenHere"						%Dir% &call :SaveConfig 			&set "xInput=" &cls &goto name
if /i "%xInput%"=="Scan"							%Dir% &set "input=Scan" 			&set "cdonly=true" &goto Scan
if /i "%xInput%"=="DefKey"						goto Keyword
if /i "%xInput%"=="GenKey"						%Dir% &set "input=Generate"											&set "cdonly=true" &goto Generate
if /i "%xInput%"=="GenJPG"						%Dir% &set "input=Generate"		&set "Target=*.jpg" 				&set "cdonly=true" &goto Generate
if /i "%xInput%"=="GenPNG"						%Dir% &set "input=Generate"		&set "Target=*.png" 				&set "cdonly=true" &goto Generate
if /i "%xInput%"=="GenPosterJPG"				%Dir% &set "input=Generate"		&set "Target=*Poster*.jpg" 		&set "cdonly=true" &goto Generate
if /i "%xInput%"=="GenLandscapeJPG"				%Dir% &set "input=Generate"		&set "Target=*Landscape*.jpg"	&set "cdonly=true" &goto Generate
if /i "%xInput%"=="ActivateFolderIcon"			%Dir% &set "RefreshOpen=Select"	&goto Activate-Folder_Icon
if /i "%xInput%"=="DeactivateFolderIcon"		%Dir% &set "RefreshOpen=Select"	&goto Deactivate-Folder_Icon
if /i "%xInput%"=="RemFolderIcon"				%Dir% &set "delete=confirm"		&set "cdonly=true"			&goto Remove
REM Background Dir	                         
if /i "%xInput%"=="Scan.Here"					%Dir% &set "input=Scan" 			&goto Scan
if /i "%xInput%"=="GenKey.Here"					%Dir% &set "input=Generate"											&set "cdonly=false" &goto Generate
if /i "%xInput%"=="GenJPG.Here"					%Dir% &set "input=Generate"		&set "Target=*.jpg" 				&set "cdonly=false" &goto Generate
if /i "%xInput%"=="GenPNG.Here"					%Dir% &set "input=Generate"		&set "Target=*.png" 				&set "cdonly=false" &goto Generate
if /i "%xInput%"=="GenPosterJPG.Here"			%Dir% &set "input=Generate"		&set "Target=*Poster*.jpg" 		&set "cdonly=false" &goto Generate
if /i "%xInput%"=="GenLandscapeJPG.Here"		%Dir% &set "input=Generate"		&set "Target=*Landscape*.jpg"	&set "cdonly=false" &goto Generate
if /i "%xInput%"=="ActivateFolderIcon.Here"	%Dir% &goto Activate-Folder_Icon
if /i "%xInput%"=="DeactivateFolderIcon.Here"	%Dir% &goto Deactivate-Folder_Icon
if /i "%xInput%"=="RemFolderIcon.Here"			%Dir% &set "delete=ask"			&set "cdonly=false"	&goto Remove

:ContextExit
if /i "%xInput%"=="refresh.NR" exit
if not "%xInput%"=="" (
	echo. &echo. 
	if /i "%input%"=="Generate" (
		echo %TAB%%TAB%%g_%Press any key to close this window.
		pause >nul &exit
	)
	if /i "%input%"=="Scan" (
		echo %TAB%%TAB%%g_%Press any key to close this window.
		pause >nul &exit
	)
	echo %TAB%%g_%This window will close in 3 sec.
	ping localhost -n 4 >nul&exit
)
EXIT /B
REM    ::::::::::::::::::::::::::::::::::::::::::::::::::::
REM   ::::::::::: DIRECT INPUT COMMAND :::::::::::::::::::
REM  ::::::::::::::::::::::::::::::::::::::::::::::::::::


:DirectInput
set "input=%input:"=%"
PUSHD "%input%" 2>nul &&goto directInput-folder ||goto directInput-file
POPD&goto options
:DirectInput-Folder
cd /d "%input%"
echo %TAB%Changing directory
echo %TAB%%i_%%input%%-% &>"%~dp0- FIMOFI Status\DrivePath.ini" echo ^<DrivePath=%input%^>&goto options
call :SaveConfig &call :UpdateVar
goto options
:DirectInput-File
for %%I in ("%input%") do (
		set "fileName=%%~nxI"
		if /i %%~xI==.jpg 	goto DirectInput-Generate
		if /i %%~xI==.png 	goto DirectInput-Generate
		if /i %%~xI==.jpeg 	goto DirectInput-Generate
		if /i %%~xI==.bmp 	goto DirectInput-Generate
		if /i %%~xI==.webp 	goto DirectInput-Generate
		if /i %%~xI==.mkv 	echo it is MKV
		)
echo %TAB%%r_%Format file tidak dikenali.%-%
echo %TAB%%g_%^(supported file: *.jpg, *.png, *.jpeg, *.bmp, *.webp, *.mkv^)
goto options
:DirectInput-Generate
for %%D in ("%cd%") do set "foldername=%%~nD%%~xD" &set "folderpath=%%~dpD"
if not exist desktop.ini echo %TAB%%w_%📁%ESC%%foldername%%_%%ESC% ^
	&echo %TAB%%ESC%Image selected:%c_%%filename%%ESC%%r_% ^
	&goto directInput-generate-confirm
echo %TAB% Folder ini sudah memiliki icon. 
echo %TAB%%ESC%%y_%📁 %foldername%%_%%ESC%
echo %TAB%%ESC%Image selected:%c_%%filename%%ESC% &echo.
echo %TAB% Apakah anda ingin mengganti icon^?%_%
set DIchoice=kosong
set /p DIchoice=%-%%-%%-%%-%%-%%gn_%Y%_%/%gn_%N ^> %gn_%
echo %-%%r_%
if /i not "%DIchoice%"=="y" echo %TAB%%_%%g_%%i_%   Dibatalkan   %-%&goto options
:DirectInput-Generate-Confirm
set "location=%cd%"
set "inputFile=%input%"
set "outputFile=%cd%\folderIcon.ico"
if exist folderIcon.ico 	attrib -h -s foldericon.ico
if exist desktop.ini 		attrib -h -s desktop.ini
PUSHD "%~dp0Template"
	"%magick%" "%inputFile%" %convert% "%outputFile%"
	"%magick%" |EXIT /B
POPD
if not exist "folderIcon.ico" echo %i_%convert ke icon gagal.%-%
if exist "folderIcon.ico" (
	>desktop.ini 	echo ^[.ShellClassInfo^]
	>>desktop.ini 	echo IconResource=folderIcon.ico
	>>desktop.ini 	echo ^;Folder Icon generated using %name%. File convert using ImageMagick.
	attrib +s +h "desktop.ini" 
	attrib +s +h "folderIcon.ico"
	attrib +r "%cd%"
	attrib |EXIT /B
	echo %TAB%%_%%i_%   Done!   %-%
)
ie4uinit.exe -ClearIconCache
ie4uinit.exe -show
set "RefreshOpen=Select"
call :SaveConfig
goto options

:GetDir
set "locationCheck=Start"
if /i "%cdonly%"=="true" (
	FOR %%D in (.) do (
		set "location=%%~fD" &set "folderpath=%%~dpD" &set "foldername=%%~nxD"
		if /i "%input%"=="Generate" call :Scan-Desktop.ini
		if /i "%input%"=="Scan" call :Scan-Desktop.ini
		EXIT /B
	)
)
FOR /f "tokens=*" %%D in ('dir /b /a:d') do (
		set "location=%%~fD" &set "folderpath=%%~dpD" &set "foldername=%%~nxD"
		if /i "%input%"=="Generate" call :Scan-Desktop.ini
		if /i "%input%"=="Scan" call :Scan-Desktop.ini
)
EXIT /B
			
:Scan
set "yy_result=0"
set "y_result=0"
set "g_result=0"
set "r_result=0"
set "success_result=0"
set "fail_result=0"
set "target=%target: =*%"
echo %TAB%%TAB%%cc_%%i_%  Scanning folder.. %-%
Echo %TAB%Keyword   :%ESC%%target%%ESC%
if exist "%FItemplate%" for %%T in ("%FItemplate%") do ^
Echo %TAB%Template  :%ESC%%%~nT%_%%ESC%
echo %TAB%Directory :%ESC%%cd%%ESC%
echo %TAB%%cc_%==============================================================================%_%
call :GetDir
echo %TAB%%cc_%==============================================================================%_%
echo %TAB%^
%cc_%%i_% %_%%gn_%%success_result%  ^
%cc_%%i_% %_%%r_%%fail_result%  ^
%cc_%%i_% %_%%w_%%YY_result%  ^
%y_%%i_% %_%%y_%%Y_result%    ^
%g_%%i_% %_%%g_%%G_result%    ^
%r_%%i_% %_%%r_%%R_result% %_%
IF /i %yy_result% LSS 1 (echo    ^(file %printTagFI% tidak ditemukan.^) &goto options)
echo. &echo    %w_%^(%c_%%yy_result%%_%%w_%^) folder berisi file %printTagFI%%w_% ditemukan.%_% &echo.
echo   %g_%jika ada lebih  dari  satu  file %FItarget%*%FIextension%  didalam  folder, maka  yang akan dipilih sebagai
echo   folder icon adalah file %FItarget%*%FIextension% teratas didalam folder. 
echo yy%yy_result% y%y_result% g%g_result% r%r_result%
set "result=0" &goto options

:Scan-Desktop.ini
	if "%locationCheck%"=="%location%" EXIT /B
:: Hati-hati, jangan selalu gunakan (), gunakan ESCAPE disetiap variable.
PUSHD "%location%"
	set "locationCheck=%location%" &set "Selected="
	if not exist "desktop.ini" (
		if exist "%Target%" (
			if "%newline%"=="yes" echo.
			echo %TAB%%ESC%%yy_%📁 %foldername%%ESC%
			set /a YY_result+=1 
			call :Scan-Find_Target
			POPD&EXIT /B
		)
		echo %TAB%%ESC%%g_%📁 %foldername%%ESC%
		set /a G_result+=1
		set "newline=yes"
		POPD&EXIT /B
	)
	if exist "desktop.ini" for /f "usebackq tokens=1,2 delims==," %%C in ("desktop.ini") do set "%%C=%%D"
	if exist "desktop.ini" if "%iconresource%"=="" (
		if exist "%Target%" (
			if "%newline%"=="yes" echo.
			echo %TAB%%ESC%%yy_%📁 %foldername%%ESC%
			set /a YY_result+=1
			echo %TAB% - "desktop.ini" already exist, creating backup.. %r_%
			attrib -s -h "desktop.ini" &attrib |EXIT /B
			copy "desktop.ini" "desktop.shellinfo.ini" >nul||echo %TAB%     %r_%%i_% copy fail! %-%
			attrib +s +h "desktop.ini"
			call :Scan-Find_Target
			POPD&EXIT /B
		)
		echo %TAB%%ESC%%g_%📁 %foldername%%ESC%
		set /a G_result+=1
		set "newline=yes"
		POPD&EXIT /B
	)
	if exist "desktop.ini" if not exist "%iconresource%" (
		if exist "%Target%" (
			if "%newline%"=="yes" echo.
			echo %TAB%%ESC%%r_%📁 %foldername%%ESC%
			set /a R_result+=1
			echo %TAB%%ESC%Assosiated icon:%c_%%iconresource%%ESC%%i_%Not Found!%-%
			echo %TAB%%_% This folder already have assosiated icon, but icon is missing.%_%
			echo %TAB%%_% Icon will be repalced by selected image.%_%
			call :Scan-Find_Target
			set "iconresource="
			POPD&EXIT /B
		)
	echo %TAB%%ESC%%g_%📁 %foldername%%ESC%
	set /a G_result+=1
	set "newline=yes"
	POPD&EXIT /B
	)
	set "newline=yes"
	if exist "desktop.ini" if exist "%iconresource%" echo %TAB%%ESC%%y_%📁 %foldername%%ESC% &set /a Y_result+=1
	set "newline=yes"
	set "iconresource="
POPD&EXIT /B
rem if exist "desktop.shellinfo.ini" >desktop.ini type desktop.shellinfo.ini &>>desktop.ini echo Tes &>>desktop.ini echo Satu &>>desktop.ini echo dua &echo. &EXIT /B

:Scan-Find_Target
for %%F in (%target%) do (
	set "newline=no"
	set "File=%%~nxF"
	set "FilePath=%%~dpF"
	if /i "%input%"=="Scan" call :Scan-Display_Result
	if /i "%input%"=="Generate" call :Generate-Folder_Icon
)
echo. &EXIT /B

:Scan-Display_Result
if "%Selected%"=="" (
	set "Selected=%File%" 
	echo %TAB%%ESC%%_%Selected Image:%c_%%File%%ESC%
)
EXIT /B

:Generate
set "yy_result=0"
set "y_result=0"
set "g_result=0"
set "r_result=0"
set "success_result=0"
set "fail_result=0"
echo %TAB%%TAB%%cc_%%i_%  Generating folder icon..  %-%
call :Generate-Get_Template
Echo %TAB%Target    : %target%
if exist "%FItemplate%" for %%T in ("%FItemplate%") do ^
Echo %TAB%Template  : %cc_%%%~nT%_% 
echo %TAB%Directory :%ESC%%cd%%ESC%
echo %TAB%%cc_%==============================================================================%_%
call :GetDir
echo %TAB%%cc_%==============================================================================%_%
echo %TAB%^
%cc_%%i_% %_%%gn_%%success_result%  ^
%cc_%%i_% %_%%r_%%fail_result%  ^
%cc_%%i_% %_%%w_%%YY_result%  ^
%y_%%i_% %_%%y_%%Y_result%    ^
%g_%%i_% %_%%g_%%G_result%    ^
%r_%%i_% %_%%r_%%R_result% %_%
echo.
IF /i %YY_result% 	GTR 0 echo %TAB%^(%cc_%%YY_result%%_%^)	Folder berhasil diproses.
IF /i %R_result% 	GTR 0 echo %TAB%^(%r_%%R_result%%_%^)	Folder icon di replace.
IF /i %Y_result% 	GTR 0 echo %TAB%^(%y_%%Y_result%%_%^)	Folder dilewati karna sudah memiliki icon.
IF /i %G_result% 	GTR 0 echo %TAB%^(%g_%%G_result%%_%^)	Folder dilewati karna %Target% tidak ditemukan.
IF /i %YY_result%	LSS 1 echo %TAB%^(%YY_result%^)	File %Target% tidak ditemukan, Tidak ada folder yang diproses.
IF /i %success_result%	GTR 1 echo %TAB%^(%YY_result%^)	Berhasil diproses.
IF /i %fail_result%	GTR 1 echo %TAB%^(%YY_result%^)	Gagal diproses.
echo %TAB%------------------------------------------------------------------------------
ie4uinit.exe -ClearIconCache
ie4uinit.exe -show
REM if /i "%cdonly%"=="true" (set "RefreshOpen=Select" &call :SaveConfig) else (set "RefreshOpen=Index" &call :SaveConfig)
goto options

:Generate-Folder_Icon
if "%Selected%"=="" (
	set "Selected=%File%" 
	echo %TAB%%ESC%%_%Selected Image:%c_%%File%%ESC%
	if exist "foldericon.ico" (
		attrib -s -h "foldericon.ico"
		ren "foldericon.ico" "foldericon.old.ico"
	)
	PUSHD "D:\Document\Script\FIMOFI Tools\Template"
		"%magick%" "%FilePath%%File%" %convert% "%FilePath%foldericon.ico" &"%magick%" |EXIT /B
	POPD
	if exist "foldericon.ico" for /f %%S in ("foldericon.ico") do (
		if %%~zS GTR 50000 echo  %cc_%%TAB%Convert success - foldericon.ico ^(%%~zS Byte^)%r_%
		if %%~zS LSS 50000 echo  %r_%%TAB%Convert error - foldericon.ico ^(%%~zS Byte^)%r_% &del /q foldericon.ico >nul
	)
	if exist "foldericon.ico" (
		echo  %g_%%TAB%%cc_%Applying resources and attributes..%r_%
		if exist "desktop.ini" attrib -s -h "desktop.ini"
		if not exist "desktop.ini" >Desktop.ini	echo ^[.ShellClassInfo^]
		>>Desktop.ini	echo IconResource=foldericon.ico
		>>Desktop.ini	echo ^;Folder Icon generated using %name%. File convert using ImageMagick.
		attrib +r "%cd%"
		ren "Desktop.ini" "desktop.ini"
		attrib +s +h "desktop.ini"
		attrib +h +s "foldericon.ico"
		attrib |EXIT /B
	) else (
		echo  %i_%Convert "%File%" ke icon gagal.%-% &set /a "fail_result+=1"
		if exist "foldericon.old.ico" ren "foldericon.old.ico" "foldericon.ico"
		attrib +s +h "foldericon.ico" 
		attrib |EXIT /B
	)
	if exist "desktop.ini" if exist "foldericon.ico" echo %TAB% %i_%%cc_%  Done!  %-% &set /a "success_result+=1"
)
EXIT /B

:Generate-Get_Template
for /f "usebackq tokens=1,2 delims==<>" %%C in ("%~dp0config.ini") do set %%C=%%D
if exist "%FItemplate%" for /f "usebackq tokens=1,2 delims==<>" %%C in ("%FItemplate%") do set Convert=%%D
EXIT /B

:TestConfig
call :Generate-Get_Template
set inputFile=%~dp0Template\test.jpg
set outputFile=%~dp0Template\test.ico
echo %_%Config: %yy_%%Convert%%_%%g_%
echo %_%%g_%Testing config to ^-^> %g_%"%inputFile%"%r_%
PUSHD "%~dp0Template"
"%~dp0convert.exe" "%inputfile%" %Convert% "%outputFile%" &&explorer.exe "%outputFile%"
"%~dp0convert.exe" |EXIT /B
POPD
echo %g_% Done! %_%
goto options

REM    ::::::::::::::::::::::::::::::::::::::::::::::::::::
REM   :::::::::::: FOLDER ICON TEMPLATE ::::::::::::::::::
REM  ::::::::::::::::::::::::::::::::::::::::::::::::::::

:LoadFolderTemplate    
set TCount=0
if exist "%~dp0Template" (
	PUSHD "%~dp0Template"
		FOR %%T in (*.ini) do (
			set /a TCount+=1
			set TName=%%~nT
			set FItemplate=%%~fT
			call :GetFolderTemplateConfig
		)
	POPD
)
echo. 
set TemplateChoice=%FItemplate%
set /p "TemplateChoice=%-%%-%%-%%w_%Pilih template: %gn_%"
if /i "%TemplateChoice%"=="0" Goto FolderTemplateDeactivated
if /i "%TemplateChoice%"=="1" set FItemplate=%Template1% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="2" set FItemplate=%Template2% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="3" set FItemplate=%Template3% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="4" set FItemplate=%Template4% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="5" set FItemplate=%Template5% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="6" set FItemplate=%Template6% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="7" set FItemplate=%Template7% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="8" set FItemplate=%Template8% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="9" set FItemplate=%Template9% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="10" set FItemplate=%Template10% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="11" set FItemplate=%Template11% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="12" set FItemplate=%Template12% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="13" set FItemplate=%Template13% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="14" set FItemplate=%Template14% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="15" set FItemplate=%Template15% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="16" set FItemplate=%Template16% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="17" set FItemplate=%Template17% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="18" set FItemplate=%Template18% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="19" set FItemplate=%Template19% &Goto FolderTemplateSelected
if /i "%TemplateChoice%"=="20" set FItemplate=%Template20% &Goto FolderTemplateSelected
if not exist "%FItemplate%" echo    %r_%"%FItemplate%" %i_%Template tidak ditemukan.%-%
echo %_%%TAB%%i_%  Pilihan tidak valid.  %-% 
echo %TAB%Gunakan angka antara 1 sampai %TCount% untuk memilih template yang tersedia.
goto options
:GetFolderTemplateConfig
echo %TAB%%gn_%%TCount%%_% ^> %cc_%%TName%%_%
set Template%TCount%=%FItemplate%
goto :eof
:FolderTemplateSelected
for %%T in ("%FItemplate%") do set TemplateName=%%~nT
echo %_%Template ^(%cc_%%TemplateName%%_%^) dipilih.
for /f "usebackq tokens=1,2 delims==<>" %%C in ("%FItemplate%") do set %%C=%%D
call :SaveConfig &call :UpdateVar
goto TestConfig

:Keyword                  
echo %TAB%%g_%Current keyword:%ESC%%c_%%FItarget%%ESC%%_%
echo %TAB%%g_%This keyword will be use to search file name to use as folder icon image.%_%
set "newFItarget=*"
echo.
set /p "newFItarget=%-%%-%%-%%w_%Change keyword:%c_%" 
set "FItarget=%newFItarget%"
set "FItarget=%FItarget: =*%"
echo. &echo. &echo.
echo %TAB%%_%%g_%Current extension: %c_%%FIextension%%_%
echo %TAB%%g_%Select file extension of the keyword above, it will automatically convert to .ico
echo %TAB%when Fimofi found matched keyword and extension and then use it as folder icon.
echo %TAB%Use number assosiated with the options below to select or type %gn_%4%_%%g_% to define it yourself.%_%
echo.
echo %TAB%%gn_%  1%_% ^> %c_%.Jpg%_%
echo %TAB%%gn_%  2%_% ^> %c_%.png%_%
echo %TAB%%gn_%  3%_% ^> %c_%.Jpeg%_%
echo %TAB%%gn_%  4%_% ^> %w_%Other%_%
echo.
set "extChoice=kosong"
set /p "extChoice=%-%%-%%-%%w_%Select file extension:%gn_%"
if /i "%extChoice%"=="kosong" goto Keyword-Selected
if /i "%extChoice%"=="1" set "FIextension=.jpg" &goto Keyword-Selected
if /i "%extChoice%"=="2" set "FIextension=.png" &goto Keyword-Selected
if /i "%extChoice%"=="3" set "FIextension=.jpeg" &goto Keyword-Selected
if /i "%extChoice%"=="4" goto Keyword-Extension
echo.
echo %TAB%%_%%i_%  Invalid selection.  %-%
echo.
goto options
:Keyword-Extension
set /p "FIextension=%-%%-%%-%%w_%Define file extension:%c_%"
:Keyword-Selected
call :SaveConfig &call :UpdateVar
if "%xInput%"=="DefKey" (
	cls &echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.
	echo %TAB%%TAB%%TAB%%TAB%%_%%ESC%%printTagFI%%ESC% will be used to generate folder icon.
	ping localhost -n 3 >nul
	goto options
)
goto Status

:Activate-Folder_Icon
echo %TAB%%cc_%  Activating folder Icon.. %_%
if "%RefreshOpen%"=="Select" (
	FOR %%D in (.) do (
		attrib +r "%%~fD" &attrib |EXIT /B
		Echo  %TAB%%w_%📁%ESC%%%~nxD%ESC%
	)
) else (
	FOR /f "tokens=*" %%D in ('dir /b /a:d') do (
		attrib +r "%%~fD" &attrib |EXIT /B
		Echo  %TAB%%w_%📁%ESC%%%D%ESC%
	)
)
echo.
echo %TAB%%cc_% %i_%   Done!   %-%
goto options
:Deactivate-Folder_Icon
echo %TAB%%cc_%    Deactivating folder Icon.. %_%
if "%RefreshOpen%"=="Select" (
	FOR %%D in (.) do (
		attrib -r "%%~fD" &attrib |EXIT /B
		Echo  %TAB%%g_%📁%ESC%%g_%%%~nxD%ESC%
	)
) else (
	FOR /f "tokens=*" %%D in ('dir /b /a:d') do (
		attrib -r "%%~fD" &attrib |EXIT /B
		Echo  %TAB%%g_%📁%ESC%%g_%%%D%ESC%
	)
)
echo.
echo %TAB%%cc_% %i_%   Done!   %-%
goto options
REM    ::::::::::::::::::::::::::::::::::::::::::::::::::::
REM   :::::::: COPY OR DELETE FOLDER ICON ::::::::::::::::
REM  ::::::::::::::::::::::::::::::::::::::::::::::::::::

:CopyJPG
ROBOCOPY /s "%cd%" "%cd%\- FIMOFI Tool" *.jpg *.png *.jpeg /XD "%cd%\- FIMOFI Tool"
explorer "%cd%\- FIMOFI Tool"
goto options

:Copy
ROBOCOPY /s "%cd%" "%cd%\- FIMOFI Tool\- Copied Folders" Desktop.ini foldericon.ico /XD "%cd%\- FIMOFI Tool"
explorer "%cd%\- FIMOFI Tool"
goto options

:Remove
echo %TAB%%r_%   %i_%  Remove Folder Icon  %-%
echo.
echo %TAB%%w_%Directory:%ESC%%w_%%cd%%ESC%
set "result=0"
set "delresult=0"
echo %TAB%%cc_%==============================================================================%_%
if /i "%delete%"=="confirm" echo.
call :Remove-Get
echo %TAB%%cc_%==============================================================================%_%
if %delresult% GTR 0 echo. &echo %TAB% ^(%cc_%%delresult%%_%^) Folder icon deleted.
if /i "%delete%"=="confirm" echo. &echo %TAB%Press any key to close this window. &pause >nul &exit
IF /i %result% LSS 1 echo. &echo %_%%TAB%^(%r_%%result%%_%%_%^) Couldn't find any folder icon. &goto options
echo. &echo %_%%TAB%  ^(%y_%%result%%_%%_%^) Folder icon found.%_% &echo.
echo       %_%%r_%Continue to Remove (%y_%%result%%_%%r_%^) folder icon ^?%-% 
echo %TAB%%ast%%g_%Folder icon will deactivated from the folder, "desktop.ini" and "foldericon.ico"
echo %TAB% inside folder will be deleted. Insert command %gg_%Y%g_% to confirm.%_%
set cho=kosong
set /p "delete=%-%%-%%-%%-%%g_%Options: %gn_%Y%_%/%gn_%N%_% %gn_%> " 
if /i "%delete%"=="Y" set "delete=confirm" &cls &goto Remove
echo %_%%TAB%%I_%     Canceled     %_% &goto options
if /i "%cdonly%"=="false" echo.pause >nul
goto options
:Remove-Get
if /i "%cdonly%"=="true" (
	FOR %%D in (.) do (
	set "location=%%~fD" &set "folderpath=%%~dpD" &set "foldername=%%~nxD"
		PUSHD "%%~fD"
			if exist "desktop.ini" (
				for /f "usebackq tokens=1,2 delims==," %%C in ("desktop.ini") do (
					set "%%C=%%D"
					call :Remove-Act
				)
			)
		POPD
	)
	EXIT /B
)
FOR /f "tokens=*" %%D in ('dir /b /a:d') do (
	set "location=%%~fD" &set "folderpath=%%~dpD" &set "foldername=%%~nxD"
	PUSHD "%%~fD"
		if exist "desktop.ini" (
			for /f "usebackq tokens=1,2 delims==," %%C in ("desktop.ini") do (
				set "%%C=%%D"
				call :Remove-Act
			)
		)
	POPD
)
EXIT /B

:Remove-Act
if exist "%iconresource%" (
	set /a result+=1
	if "%delete%"=="confirm" (echo %ESC%%TAB%%cc_%📁 %foldername%%ESC%) else (echo %ESC%%TAB%%y_%📁 %foldername%%ESC%)
	if "%delete%"=="confirm" (
		echo %TAB% %g_%Assosiated icon:%ESC%%c_%%iconresource%%ESC%
		if /i not "%iconresource%"=="foldericon.ico" echo %TAB% %g_%Assosiated icon is not "foldericon.ico", it wont be deleted.%_%
		echo %TAB% %g_%Deleting resources..%r_%
		attrib /d -r "%cd%" 
		attrib -h -s "Desktop.ini" 
		del /f /q "Desktop.ini"
		if exist "foldericon.ico" attrib -s -h "foldericon.ico" 
		if exist "foldericon.ico" del /f /q "foldericon.ico"
		attrib |exit /b
		if not exist "desktop.ini" if not exist "foldericon.ico" echo %TAB% %g_%%i_%  Done!  %-% &set /a delresult+=1 &echo.
	)
)
EXIT /B

:checkMKVToolNix
set MKVToolNix=C:\Program Files\MKVToolNix\mkvpropedit.exe
set MKVToolNix86=C:\Program Files (x86)\MKVToolNix\mkvpropedit.exe
if exist "%MKVToolNix%" (set MKVEdit="%MKVToolNix%" &goto :eof) else (echo %r_%   Program tidak ditemukan%_% %y_%%MKVToolNix% )
if exist "%MKVToolNix86%" (set MKVEdit="%MKVToolNix86%" &goto :eof) else (echo %r_%   Program tidak ditemukan%_% %y_%%MKVToolNix86% )
echo. &echo   %b_%MKVToolNix%_% %w_%belum terinstall^%c_%?%_%
echo   %g_%pastikan MKVToolNix sudah terinstall pada salah satu path di atas.%_%
goto options

:ScanFunction                     
%PrintCurrentdir%
%scanDetect% (%do%)
FOR /d /r "%cd%" %%a in (*) do (
pushd "%%a" 
%PrintSubdir%
%scanDetect% (%do%)
popd)
EXIT /B

:ChangeTargetMKV                  
set /p "newTag= %-%%-%%-%%w_%Masukan keyword file:%c_%" 
set "MKVtarget=%newTag%"
set "MKVtarget=%MKVtarget: =*%"
call :SaveConfig &call :UpdateVar 
echo    %_%Target pencarian file MKV: %printTagMKV% &goto Options

:ScanMkv                          
echo      %cc_%Scanning MKV..%_%
set "ext=.mkv"
call :scanFunction
IF /i %result% LSS 1 (echo   ^(file dengan keyword %printTagMKV% tidak ditemukan.^) &goto options)
echo. &echo    %w_%^(%c_%%result%%_%%w_%^) file ditemukan.%_% &echo. &goto options

:DelCover                         
call :checkMKVToolNix
echo      %cc_%Menghapus cover MKV..%_%
set "ext=.mkv"
set "Action=%scanDetect% (%do% &%MKVedit% "%%a" %delCover% %exitcode%)"
%PrintCurrentdir%
%Action%
for /d /r "%cd%" %%a in (*) do (
pushd "%%a"  
%PrintSubdir%
%Action% 
popd)
call :coverResult &goto options

:CoverResult                      
IF /i %result% LSS 1 (echo   ^(file dengan keyword %printTagMKV% tidak ditemukan.^) &goto options)
echo. &echo    %w_%^(%c_%%result%%_%%w_%^) file ditemukan. Proses selesai.%_% &echo. &EXIT /B

:SetCOVER                         
echo   %g_%File path untuk "setcover" bisa diisi file path lengkap ^(contoh:%u_%D:\pahe\gambar\cover.jpg%_%%g_%^)
echo   atau bisa juga diisi hanya nama filenya saja jika file yg akan dijadikan cover berada
echo   atu folder dengan file MKV nya. ^(contoh:%u_%cover.jpg%_%%g_%^) &echo.
set /p "coverimg=  %_%    Masukan file path:%w_%"
%p1% &goto status

:AddCover                         
call :checkMKVToolNix
echo      %cc_%Mengganti cover MKV..%_%
set "ext=.mkv"
set Action=%MKVedit% "%%~nxa" %delcover% --attachment-name cover --add-attachment
%PrintCurrentdir%	&call :addCover-priorityOptions
for /d /r "%cd%" %%a in (*) do (pushd "%%a"
	%PrintSubdir%	&call :addCover-priorityOptions 
popd)
call :coverResult	&goto options
:AddCover-priorityOptions         
%scanDetect% (%do%
		 if exist "%%~na.jpg"  			( echo      %g_%Cover: %%~na.jpg			%r_% &%Action% "%%~na.jpg" 				%exitcode%
) else ( if exist "%%~na-landscape.jpg" ( echo      %g_%Cover: %%~na-landscape.jpg	%r_% &%Action% "%%~na-landscape.jpg"	%exitcode%
) else ( if exist "%%~na-fanart.jpg" 	( echo      %g_%Cover: %%~na-fanart.jpg	%r_% &%Action% "%%~na-fanart.jpg" 		%exitcode%
) else ( if exist "%%~na.jpeg" 			( echo      %g_%Cover: %%~na.jpeg			%r_% &%Action% "%%~na.jpeg" 			%exitcode%
) else ( if exist "%coverimg%" 			( echo      %g_%Cover: %coverimg%			%r_% &%Action% "%coverimg%" 			%exitcode%
) else ( echo      %r_%^(tidak dapat mengganti cover, gambar tidak ditemukan.^)%_% ))))))
EXIT /B
:AddCover-priorityVar
set "NamaFile=%%~na"
set "Prioritas1=%namaFile%.jpg"
set "Prioritas2=%namaFile%-lanscape.jpg"
set "Prioritas3=%namaFile%-fanart.jpg"
set "Prioritas4=%namaFile%-poster.jpg"
set "Prioritas5=%setcover%"


REM    ::::::::::::::::::::::::::::::::::::::::::::::::::::
REM   :::::::::::::::   LAIN NYA..  ::::::::::::::::::::::
REM  ::::::::::::::::::::::::::::::::::::::::::::::::::::
:Refresh
rem if not "%xInput%"=="" (
rem 	echo %TAB%%TAB%%_%%r_%Restart File Explorer^?%-% 
rem 	echo   %ast%%g_%Untuk memaksa windows melakukan update icon dan  thumbnail  cache%_%
rem 	echo   %g_% File Explorer akan direstart. Masukan perintah %gn_%Y%g_% untuk konfirmasi.
rem 	set choice=kosong
rem 	set /p "choice=%-%%-%%-%Options: %gn_%Y%_%/%gn_%N%_% %gn_%^> " 
rem 	if /i not %choice%==y echo %_%%TAB%%I_%     Dibatalkan     %_% &goto options
rem )
if /i not "%xInput%"=="" echo.&echo.&echo.
echo %_%%g_%%TAB%Note: Jika proses stuck dan explorer tidak muncul kembali, gunakan cara manual. 
echo %TAB%Tekan %i_% CTRL %_%%g_%+%i_% SHIFT %_%%g_%+%i_% ESC %_%%g_%%-% %g_%^> Klik File ^> Run New Task ^> Tulis "explorer" ^> OK.
echo %TAB%%cc_%Forcing Windows to update icon cache..%r_%
taskkill /F /IM explorer.exe >nul
PUSHD "%userprofile%\AppData\Local\Microsoft\Windows\Explorer"
if exist "iconcache_*.db" attrib -h iconcache_*.db
if exist "%localappdata%\IconCache.db" DEL /A /Q "%localappdata%\IconCache.db"
if exist "%localappdata%\Microsoft\Windows\Explorer\iconcache*" DEL /A /F /Q "%localappdata%\Microsoft\Windows\Explorer\iconcache*"
%p2%
start explorer.exe
POPD
ie4uinit.exe -ClearIconCache
ie4uinit.exe -show
if /i "%RefreshOpen%"=="Select" (explorer.exe /select, "%cd%") else explorer.exe "%cd%"
echo %TAB%%TAB%%cc_%%i_%    Done!   %-%
call :Refresh-NoRestart
%p2% &%p2% &goto options

:Refresh-NoRestart                
@echo off
if /i not "%xInput%"=="" echo.
mode con:cols=50 lines=9
title  refresh folder icon..
set refreshCount=0
for %%F in (.) do (
	set foldername="%%~nxF"
	if exist "desktop.ini" (
		title  refreshing.. "%%~nxF"
		echo %TAB%%cc_%REFRESHING..
		echo %ESCAPE%%cc_%%%~nxF%ESCAPE%%r_%
		attrib -r "%cd%"
		attrib -s -h 		"desktop.ini"
		ren "desktop.ini" "DESKTOP.INI"
		attrib +r "%cd%"
		ren "DESKTOP.INI" "desktop.ini"
		attrib +s +h 		"desktop.ini"
		attrib |exit /b
		set /a refreshCount+=1
	) else (
		echo %TAB%%w_%Skiping regular folder..%_%
		echo %ESCAPE%%_%%%~nxF%ESCAPE%
	)
)
CLS
if /i not "%cdonly%"=="true" FOR /f "tokens=*" %%R in ('dir /b /a:d') do (
	PUSHD "%%R"
		echo. &echo.
		if exist "desktop.ini" (
			title  refreshing.. "%%R"
			echo %TAB%%cc_%REFRESHING..
			echo %ESCAPE%%cc_%%%R%ESCAPE%%r_%
			attrib -r "%%~fR"
			attrib -s -h 		"desktop.ini"
			ren "desktop.ini" "DESKTOP.INI"
			attrib +r "%%~fR"
			ren "DESKTOP.INI" "desktop.ini"
			attrib +s +h 		"desktop.ini"
			attrib |exit /b
			set /a refreshCount+=1
		) else (
			echo %TAB%%w_%Skiping regular folder..%_%
			echo %ESCAPE%%_%%%R%ESCAPE%
		)
		CLS
	POPD
)
if %refreshCount% LSS 1 (
	echo. &echo.
	echo  Couldn't find any folder icon ..
	ping localhost -n 3 >nul
	exit
)
%p1%
ie4uinit.exe -ClearIconCache
ie4uinit.exe -show
echo.
if %refreshCount% GTR 1 echo %g_% %refreshCount% Folder icon found.%_%
echo.
echo %TAB%   %cc_%REFRESH%_%       
for %%F in (.) do set "foldername=%%~nxF"
echo %ESC%%w_%%foldername%.. .%ESC%        &echo.
echo %TAB%  [106m [30m Done! [0m
echo. &echo. &ping localhost -n 4 >nul
if /i not "%xInput%"=="" EXIT
goto options

:ChangeDirBack                    
cd .. &%p1% &title %name% ^| %cd% &%p1% 
echo   Changing directory to %i_%%cd%%-% &>"%~dp0- FIMOFI Status\DrivePath.ini" echo ^<DrivePath=%cd%^>&goto options
:OpenDir                          
echo %TAB%%_%Membuka..   
echo %TAB%%i_%%cd%%-% &explorer.exe "%cd%" &goto options
:OpenDirFimofi                          
echo   %_%Membuka..   %i_%%~dp0%-% &echo. &explorer.exe "%~dp0" &goto options

:Help                             
echo   %u_%Drag and Drop%_% folder ke layar Terminal ini, lalu tekan Enter untuk mengganti direktori.
echo   %u_%Drag and Drop%_% file   ke layar Terminal ini, lalu tekan Enter untuk mengganti folder icon direktori ini.%_%
echo.
echo   %gg_%TAG      %_%: Atur keyword pencarian untuk menentukan file mana yang akan dijadikan folder icon.
echo   %gg_%SCAN     %_%: Melakukan pencarian file berdasarkan TAG yang ditentukan.
echo   %gg_%TEMPLATE %_%: Memilih  template  untuk  dijadikan  folder  icon.
echo   %gg_%GENERATE %_%: Memulai proses untuk  menjadikan file yang ada  didalam folder  menjadi icon folder.
echo   %gg_%REFRESH  %_%: Melakukan  reset  icon cache   untuk  meng-update   icon/thumbnail  pada   Explorer.
echo   %gg_%RESET    %_%: Reset folder, nonaktifkan folder icon pada direktori dan semua direktori didalamnya.
echo   %gg_%COPY     %_%: Salin folder yang memiliki folder icon ke folder.
echo   %gg_%SCANMKV  %_%: Melakukan pencarian file MKV berdasarkan TAGMKV yang ditentukan.
echo   %gg_%ADDCOVER %_%: Melakukan pencarian dan mengganti cover/thumbnail dari file MKV yang ditemukan.
echo   %gg_%DELCOVER %_%: Melakukan pencarian dan menghapus cover/thumbnail dari file MKV yang ditemukan.
echo   %gg_%SETCOVER %_%: Atur file yang akan digunakan sebagai cover/thumbnail MKV.
echo   %gg_%S        %_%: Menampilkan status.
echo   %gg_%CLS      %_%: Bersihkan tampilan terminal.
echo   %gg_%HELP     %_%: Menampilkan daftar perintah yang tersedia beserta detail fungsi-fungsinya. 
goto options

:Varset                           
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
set "ESC=[30m"[0m"
set "AST=%r_%*%_%"                         
set p1=ping localhost -n 1 ^>nul
set p2=ping localhost -n 2 ^>nul
set p3=ping localhost -n 3 ^>nul
set p4=ping localhost -n 4 ^>nul
call :LoadConfig
if exist "%DrivePath%" (cd /d "%DrivePath%") else (cd /d "%~dp0")
call :UpdateVar
EXIT /B

:UpdateVar                      
title %name% ^| %cd%
set "result=0"
set "magick=%~dp0convert.exe"
set "target=*%FItarget%*%FIextension%"
set "PrintCurrentdir=IF EXIST "*%MKVtarget%**%MKVextension%" echo   %_%%cd%"
set "PrintSubdir=IF EXIST "*%MKVtarget%**%MKVextension%" echo   %_%%%a"
set "scanDetect=FOR %%a in (*%MKVtarget%**%MKVextension%) do"
set "do=echo   %g_%-- %c_%%%a%_%%g_% &set /a result+=1"
set "editExit=%MKVedit% |EXIT /B"
set "exitCode=>nul"
set "printTagMKV=%ast%%c_%%MKVtarget%%ast%%_% %ast%%c_%%MKVextension%%_%"
set "printTagFI=%ast%%c_%%FItarget%%ast%%_%%c_%%FIextension%%_%"
set delcover=--delete-attachment name:cover.jpg  --delete-attachment name:cover.png ^
			  --delete-attachment name:cover.jpeg --delete-attachment name:cover.gif ^
			  --delete-attachment name:cover
set delCoverforce=--delete-attachment "mime-type:image/jpeg" --delete-attachment "mime-type:image/png"
EXIT /B

:SaveConfig
REM Save current config to Config.ini
>"%~dp0Config.ini"	echo ^[FIMOFI CONFIGURATION^]
>>"%~dp0Config.ini"	echo DrivePath=%cd%
>>"%~dp0Config.ini" 	echo FItarget=%FItarget%
>>"%~dp0Config.ini" 	echo FIextension=%FIextension%
>>"%~dp0Config.ini" 	echo FItemplate=%FItemplate%
>>"%~dp0Config.ini" 	echo RefreshOpen=%RefreshOpen%
>>"%~dp0Config.ini" 	echo MKVtarget=%MKVtarget%
>>"%~dp0Config.ini" 	echo MKVextension=%MKVextension%
>>"%~dp0Config.ini" 	echo MKVsetcover=%MKVsetcover%
EXIT /B

:LoadConfig
REM Load Config from Config.ini
if exist "%~dp0Config.ini" (
	for /f "usebackq tokens=1,2 delims==" %%C in ("%~dp0Config.ini") do (set "%%C=%%D")
) else (
	CLS &echo. &echo. &echo.
	echo %TAB% %r_%Config.ini is Missing.
	pause >nul &exit
)
REM Define Folder Icon Template
if exist "%FItemplate%" (
	for /f "usebackq tokens=1,2 delims==<>" %%C in ("%FItemplate%") do set Convert=%%D
	for %%T in ("%FItemplate%") do set TemplateName=%%~nT
) else (
	echo %TAB%%r_%%FItemplate%%i_%Template not found!%-%
	set "FItemplate=%~dp0Template\Default - With Shadow.ini"
)
EXIT /B

:Colour
start "Colour options" cmd /c "D:\Document\Script\Text color in batch\Tes colour.bat"
goto options