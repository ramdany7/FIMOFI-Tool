@ECHO off
chcp 65001 >nul
set name=FIMOFI Tools v0.0.1i
title %name%   "%cd%"
:: Author  : Ramdany
:: Name    : FIMOFI Tools v0.0.1i
:: Date  Created : 20 September 2022
:: Last Edited   : 09 March 2023

:Start
call :varset
call :Config-Load
call :UpdateVar
::::::::::::::::::::::::::::::::::::
if /i "%act%"=="Refresh"	set "xInput=1" &set "cdonly=false" &set "RefreshOpen=Index" &goto Refresh
if /i "%xInput%"=="Refresh.Here"	cd /d %1 &set "cdonly=false" &set "RefreshOpen=Index" &goto FI-Refresh
if /i "%xInput%"=="RefreshNR.Here"	cd /d %1 &set "cdonly=false" &set "RefreshOpen=Index" &goto FI-Refresh-NoRestart
if /i "%xInput%"=="Refresh"			cd /d %1 &set "cdonly=true" &set "RefreshOpen=Select" &goto FI-Refresh
if /i "%xInput%"=="RefreshNR"		cd /d %1 &set "cdonly=true" &set "RefreshOpen=Select" &goto FI-Refresh-NoRestart
if defined xInput goto Input-Context

:Intro                            
echo. &echo           %b_% %name% %_%%-%
echo   %u_%Drag and Drop%_% folder ke layar Terminal ini, lalu tekan Enter untuk mengganti direktori.
echo   %u_%Drag and Drop%_% gambar ke layar Terminal ini, lalu tekan Enter untuk mengganti folder icon direktori saat ini.%_%
echo.
:Status                           
%p1%
echo   %_%-------%i_% Status %_%----------------------------------------
echo   Directory           :%ESC%%u_%%cd%%-%%ESC%
echo   Target Folder Icon  : %printTagFI%
if exist "%FItemplate%" ^
echo   Folder Icon Template:%ESC%%cc_%%templatename%%_%%ESC%
if not exist "%FItemplate%" ^
echo   Folder Icon Template: %r_%%i_% Not Found! %ESC%%r_%%u_%%FItemplate%%ESC%
echo   Target MKV          : %printTagMKV%
echo   Setcover            : %g_%%coverimg%%_%
echo   %_%-------------------------------------------------------
goto Options-QuickMenu
:Options                          
call :Input-Context_Exit
echo. &echo.&echo.&echo.
:Options-QuickMenu
call :Input-Context_Exit
echo %_%%GG_%Keyword%G_%^|%GG_%Scan%G_%^|%GG_%Template%G_%^|%GG_%Generate%G_%^|%GG_%Refresh%G_%^|%GG_%ON%G_%^|^
%GG_%OFF%G_%^|%GG_%Remove%G_%^|%GG_%O%G_%^|%GG_%S%G_%^|%GG_%CLS%G_%^|%GG_%R%G_%^|%GG_%HELP%G_%^|..
:Options-CommandInput             
echo %g_%--------------------------------------------------------------------------------------------------
title %name%   "%cd%"
call :Config-Save
call :UpdateVar
call :Config-Load
:Input-Command
set input=kosong
set /p "input=%_%%w_%%cd%%_%%gn_%>"
set "input=%input:"=%"
echo %-% &echo %-% &echo %-%
if /i "%input%"=="cc"				start "" "%~f0" Refresh
if /i "%input%"=="tag"			goto Keyword
if /i "%input%"=="keyword"		goto Keyword
if /i "%input%"=="gt"				goto Scan-GetDir
if /i "%input%"=="scan"			set "recursive=no"		&goto FI-Scan
if /i "%input%"=="scan -s"		set "recursive=yes"		&goto FI-Scan
if /i "%input%"=="generate"		set "recursive=no"		&set "cdonly=false"	&set "input=Generate"	&goto FI-Generate
if /i "%input%"=="generate -s"	set "recursive=yes"		&set "cdonly=false"	&set "input=Generate"	&goto FI-Generate
if /i "%input%"=="Remove"		set "delete=ask"			&set "cdonly=false"	&goto Remove
if /i "%input%"=="on"				set "refreshopen=index"	&goto FI-Activate
if /i "%input%"=="off"			set "refreshopen=index"	&goto FI-Deactivate
if /i "%input%"=="copy"			goto CopyFolderIcon
if /i "%input%"=="refresh-f"		goto FI-Refresh-NoRestart
if /i "%input%"=="refresh"		echo %TAB%%cc_%Refreshing icon cache..%_%&set "act=Refresh" &start "" "%~f0" &goto options
if /i "%input%"=="rf"				goto FI-Refresh
if /i "%input%"=="template"		goto FI-Template 
if /i "%input%"=="ft"				goto FI-Template
if /i "%input%"=="Tes"			goto FI-Template-Test_Config
if /i "%input%"=="setfi"			goto SetFolderIcon
if /i "%input%"=="reset"			goto DeleteFolderIcon
if /i "%input%"=="rst"			goto DeleteFolderIcon
if /i "%input%"=="s"				goto Status
if /i "%input%"=="tagmkv"		goto ChangeTargetMKV
if /i "%input%"=="scanmkv"		goto ScanMkv
if /i "%input%"=="delcover"		goto Delcover
if /i "%input%"=="addcover"		goto Addcover
if /i "%input%"=="setcover"		goto Setcover
if /i "%input%"=="help"			goto Help
if /i "%input%"=="cd.."			goto ChangedirBack
if /i "%input%"=="o"				goto Opendir
if /i "%input%"=="of"				goto OpendirFimofi
if /i "%input%"=="cls"			cls&goto options
if /i "%input%"=="r"				start "" "%~f0" &exit
if /i "%input%"=="delcover-f"	goto DelcoverForce
if /i "%input%"=="tc"				goto Colour
if /i "%input%"=="src"			goto FI-Search_Folder_Icon

if exist "%input%" goto directInput
goto Input-Error

:Input-Context
@echo off
title %name% ^| %1
set Dir=cd /d %1
set Dir1=cd /d "%~dp1"
cls &echo. &echo. &echo.
REM Selected Image
if /i "%xInput%"=="IMG-Actions"						goto IMG-Actions
if /i "%xInput%"=="IMG-Set.As.Folder.Icon"			%Dir1% 		&set input=%1 &set "RefreshOpen=Select" &goto DirectInput
if /i "%xInput%"=="IMG-FI.Choose.Template"			set img=%1	&goto FI-Template
if /i "%xInput%"=="IMG-Set.As.Cover"				set img=%1	&goto IMG-Set_as_MKV_cover
REM Selected Dir	
if /i "%xInput%"=="OpenHere"							%Dir% &call :Config-Save 			&set "xInput=" &cls &goto name
if /i "%xInput%"=="ChoTemplate"						goto FI-Template
if /i "%xInput%"=="FI.Search.Folder.Icon"			goto FI-Search_Folder_Icon
if /i "%xInput%"=="FI.Search.Folder.Icon.Here"	goto FI-Search_Folder_Icon
if /i "%xInput%"=="Scan"								%Dir% &set "input=Scan" 			&set "cdonly=true" &goto Scan
if /i "%xInput%"=="DefKey"							goto Keyword
if /i "%xInput%"=="GenKey"							%Dir% &set "input=Generate"											&set "cdonly=true" &goto FI-Generate
if /i "%xInput%"=="GenJPG"							%Dir% &set "input=Generate"		&set "Target=*.jpg" 				&set "cdonly=true" &goto FI-Generate
if /i "%xInput%"=="GenPNG"							%Dir% &set "input=Generate"		&set "Target=*.png" 				&set "cdonly=true" &goto FI-Generate
if /i "%xInput%"=="GenPosterJPG"					%Dir% &set "input=Generate"		&set "Target=*Poster*.jpg" 		&set "cdonly=true" &goto FI-Generate
if /i "%xInput%"=="GenLandscapeJPG"					%Dir% &set "input=Generate"		&set "Target=*Landscape*.jpg"	&set "cdonly=true" &goto FI-Generate
if /i "%xInput%"=="ActivateFolderIcon"				%Dir% &set "RefreshOpen=Select"	&goto FI-Activate
if /i "%xInput%"=="DeactivateFolderIcon"			%Dir% &set "RefreshOpen=Select"	&goto FI-Deactivate
if /i "%xInput%"=="RemFolderIcon"					%Dir% &set "delete=confirm"		&set "cdonly=true"				&goto FI-Remove
REM Background Dir	                         	
if /i "%xInput%"=="Scan.Here"						%Dir% &set "input=Scan" 			&goto FI-Scan
if /i "%xInput%"=="GenKey.Here"						%Dir% &set "input=Generate"											&set "cdonly=false" &goto FI-Generate
if /i "%xInput%"=="GenJPG.Here"						%Dir% &set "input=Generate"		&set "Target=*.jpg" 				&set "cdonly=false" &goto FI-Generate
if /i "%xInput%"=="GenPNG.Here"						%Dir% &set "input=Generate"		&set "Target=*.png" 				&set "cdonly=false" &goto FI-Generate
if /i "%xInput%"=="GenPosterJPG.Here"				%Dir% &set "input=Generate"		&set "Target=*Poster*.jpg" 		&set "cdonly=false" &goto FI-Generate
if /i "%xInput%"=="GenLandscapeJPG.Here"			%Dir% &set "input=Generate"		&set "Target=*Landscape*.jpg"	&set "cdonly=false" &goto FI-Generate
if /i "%xInput%"=="ActivateFolderIcon.Here"		%Dir% &goto FI-Activate
if /i "%xInput%"=="DeactivateFolderIcon.Here"		%Dir% &goto FI-Deactivate
if /i "%xInput%"=="RemFolderIcon.Here"				%Dir% &set "delete=ask"			&set "cdonly=false"	&goto FI-Remove
REM MKV Tools	
REM Direct Selected MKV	
if /i "%xInput%"=="MKV.Select"						%Dir1% &goto MKV-Select
if /i "%xInput%"=="MKV.Actions "					goto MKV-Actions
if /i "%xInput%"=="MKV.Subtitle.Merge "			goto MKV-Subtitle_Merge
if /i "%xInput%"=="MKV.SetCover"					%Dir1% &goto MKV-SetCover
if /i "%xInput%"=="MKV.Cover-Change"				%Dir1% &goto MKV-Cover_Change
if /i "%xInput%"=="MKV.Cover-Delete"				%Dir1% &goto MKV-Cover_Delete
if /i "%xInput%"=="MKV.Cover-setKey"				%Dir1% &goto MKV-Cover_setKey
if /i "%xInput%"=="MKV.Cover-Generate"				%Dir1% &goto MKV-Cover_Generate
if /i "%xInput%"=="MKV.Cover-fanart"				%Dir1% &set "CoverTarget=fanart"		&goto MKV-Cover_Search
if /i "%xInput%"=="MKV.Cover-poster"				%Dir1% &set "CoverTarget=poster"		&goto MKV-Cover_Search
if /i "%xInput%"=="MKV.Cover-landscape"			%Dir1% &set "CoverTarget=landscape"	&goto MKV-Cover_Search
if /i "%xInput%"=="MKV.Cover-discart"				%Dir1% &set "CoverTarget=discart"	&set "CoverExtension=.png" &goto MKV-Cover_Search
REM MKV Background Dir	
if /i "%xInput%"=="MKV.Subtitle.Merge-Here"		%Dir% &goto MKV-Subtitle_Merge-Here
if /i "%xInput%"=="MKV.Gen.Cover-Delete"			goto MKV-Cover_Delete
if /i "%xInput%"=="MKV.Gen.Cover-setKey"			goto MKV-Cover_setKey
if /i "%xInput%"=="MKV.Gen.Cover-Generate"			goto MKV-Cover_Generate
if /i "%xInput%"=="MKV.Gen.Cover-fanart"			set "CoverTarget=fanart"		&goto MKV-Cover_Search
if /i "%xInput%"=="MKV.Gen.Cover-poster"			set "CoverTarget=poster"		&goto MKV-Cover_Search
if /i "%xInput%"=="MKV.Gen.Cover-landscape"		set "CoverTarget=landscape"	&goto MKV-Cover_Search
if /i "%xInput%"=="MKV.Gen.Cover-discart"			set "CoverTarget=discart"	&set "CoverExtension=.png" &goto MKV-Cover_Search
REM Other context menu
if /i "%xInput%"=="VTM"					goto VTM
if /i "%xInput%"=="MP4.to.MKV"			goto MP4-Convert_to_MKV
goto Input-Error



:Parser-get_file_size
if "%size_B%"=="" echo %r_%Fail to get file size!%_% &exit /b
set /a size_KB=%size_B%/1024
set /a size_MB=%size_KB%00/1024
set /a size_GB=%size_MB%/1024
set size_MB=%size_MB:~0,-2%.%size_MB:~-2%
set size_GB=%size_GB:~0,-2%.%size_GB:~-2%
if %size_B% NEQ 1024 set size=%size_B% Bytes
if %size_B% GEQ 1024 set size=%size_KB% KB
if %size_B% GEQ 1024000 set size=%size_MB% MB
if %size_B% GEQ 1024000000 set size=%size_GB% GB
exit /b

:IMG-Actions
for %%I in (%xSelected%) do echo %%~nxI
goto options

:IMG-Set_as_MKV_cover
for %%I in (%1) do (
	set "IMGname=%%~nxI"
	set "size_B=%%~zI"
	set "MKVcover=%%~dpnxI"
	call :parser-get_file_size
)
if not "%header%"=="show" (
	set "header=show"
	echo %TAB%  --------------%i_% Selected Image %_%------------------------------------- 
	echo %TAB% %ESC%%c_%%IMGname%%_%%ESC%%pp_%%size%%_%
	echo %TAB%  -------------------------------------------------------------------
	echo.&echo.
	echo %TAB% %g_% Drag and drop an MKV file here, then press Enter to set the selected 
	echo %TAB% %g_% image as a cover image. You can add multiple MKVs.
)
echo.
set "IMGinput=0"
set /p "IMGinput=%_%%i_% Input:%_%%gn_% "
echo.
for %%I in (%IMGinput%) do (
	if exist "%%I" PUSHD "%%~dpnxI" 2>nul ||(
		if "%%~xI"==".mkv" (
			PUSHD "%%~dpI"
			set "MKVfile=%%~nxI"
			echo %_%MKV file   :%ESC%%c_%%%~nxI%ESC%
			echo %_%Cover image:%ESC%%c_%%IMGname%%ESC%
			call :MKV-Cover_Changer
			POPD
		)
	)
	if exist "%%I" PUSHD "%%~dpnxI" 2>nul ||(
		if not "%%~xI"==".mkv" (
			echo %ESC%%IMGinput%%ESC% 
			echo %i_%  It's not MKVs file.  %_%
		)
	)
	if exist "%%I" PUSHD "%%~dpnxI" 2>nul &&(
		echo %ESC%%IMGinput%%ESC% 
		echo %i_%  This is folder.  %_%
	)
	if not exist "%%I" echo %i_%%r_% Invalid Input %_% &echo.
)
echo.&echo.
goto IMG-Set_as_MKV_cover
goto options


:MP4-Convert_to_MKV
for %%M in (%xSelected%) do (
	if /i "%%~xM"==".mp4" (
		set "MP4name=%%~nxM"
		set "size_B=%%~zM"
		set "display=MP4"
		call :parser-get_file_size
		call :MP4-Convert_to_MKV-display_file
		PUSHD "%%~dpM" || echo %i_%%r_%  FAIL to PUSHD..  %_%
			start /wait "%%~nxM" cmd.exe /c echo.^&echo.^&echo. ^
			 ^&echo %TAB%%cc_%Converting..%_% ^
			 ^&echo  "%cc_%%%~nxM%_%" ^
			 ^&"%MKVmerge%" -o "%%~nM.mkv" "%%~nxM"
		POPD
		if exist "%%~dpnM.mkv" (
			for %%K in ("%%~dpnM.mkv") do (
				set "MKVname=%%~nxK"
				set "size_B=%%~zK"
				set "display=MKV"
				call :parser-get_file_size
				call :MP4-Convert_to_MKV-display_file
			)
		) else (echo %TAB%%r_%%i_%Convert Fail!%_% "%%~nxM")
	)
)
echo.&echo.&echo.&echo %TAB%%TAB%%g_%Press any key to continue.%_%
pause>nul
goto options

:MP4-Convert_to_MKV-display_file
if "%display%"=="MP4" (echo %TAB%%gg_%🎞%ESC%%MP4name% %pp_%%size%%_% %g_%(%size_B% Bytes)%ESC%) 
if "%display%"=="MKV" ( echo %TAB%%c_%🎞%ESC%%MKVname% %pp_%%size%%_% %g_%(%size_B% Bytes)%ESC%)
exit /b

:MKV-Actions
for %%K in (%xSelected%) do (if /i "%%~xK"==".mkv" echo %TAB%%ESC%%%~nxK%ESC%)
echo.
echo %TAB%%TAB%%i_%%cc_%   Options   %_%
echo %TAB%  %gn_%1 %w_%^> %cc_%Show MKV Info%_%
echo %TAB%  %gn_%2 %w_%^> %cc_%Manage Subtitle%_%
echo %TAB%  %gn_%3 %w_%^> %cc_%Manage Cover%_%
echo %TAB%  %gn_%4 %w_%^> %cc_%Delete Properties%_%
echo.&echo.
echo %TAB%%g_%you can also 'Drag and Drop' folder, image, video, or subtitle
echo %TAB%%g_%to the input column below. Then, press Enter to confirm.
echo.
set "MKVInput=0"
set /p "MKVInput=%_%%i_% Input:%_%%gn_% "
if "%MKVinput%"=="1" goto MKV-Info
for %%I in (%MKVInput%) do (
	set /a "MKVinput_count+=1"
	set "MKVinput_item=%%I"
	call :MKV-Actions-Parser-Input
)
goto options

:MKV-Actions-Parser-Input
set MKVinput_item=%MKVinput_item:"=%
if exist "%MKVinput_item%" (
	set MKVinput_set="%MKVinput_item%"
) else set MKVinput="%MKVinput_item%" &goto MKV-Actions-Decide
exit /b

:MKV-Actions-Decide
if /i "%MKVInput%"=="1" goto MKV-Info
echo %TAB% %_%%i_%   Invalid Input!   %_%
cls&goto MKV-Actions
goto options




:MKV-Info
for %%K in (%xSelected%) do (
	if /i "%%~xK"==".mkv" (
		echo %TAB%%ESC%%c_%%%~nxK%ESC%
		call "%MKVMerge%" -i "%%~dpnxK"
		echo.&echo.
	)
)
pause>nul
goto Options

:MKV-Subtitle_Merge-Here
for %%S in (*.mkv) do (
	set "MKVname=%%~nS"
	set "MKVdir=%%~dpS__"
	set "size_B=%%~zS"
	call :parser-get_file_size
	call :MKV-Subtitle-merge_proccess
)
Echo.&echo.&echo %TAB%         %i_%%cc_%  Done!  %_%
pause>nul
goto Options

:MKV-Subtitle_Merge
for %%S in (%xSelected%) do (
	if /i "%%~xS"==".mkv" (
		set "MKVname=%%~nS"
		set "MKVdir=%%~dpS__"
		set "size_B=%%~zS"
		call :parser-get_file_size
		call :MKV-Subtitle-merge_proccess
	)
)
echo       %_%%i_%   Done!   %_%
pause>nul
goto options

:MKV-Subtitle-merge_proccess
set "MKVDisplay=yes"
set MKVfileDisplay=%TAB%%ESC%%c_%%MKVname%.mkv%_% %pp_%%size% %g_%(%size_B% Bytes)%ESC%
set MKVfileDisplay_=%TAB%%ESC%%g_%%MKVname%.mkv%_% %g_%%size% %g_%(%size_B% Bytes)%ESC%
PUSHD "%MKVdir:\__=%" || echo %i_%%r_% PUSH DIRECTORY FAIL! -^>%_%"%MKVdir%"

REM Search subtitle
set /a Found=0
for %%X in (srt,sub,ass) do (

	REM Search Sub with the same name.

	if exist "%MKVname%.%%X" (
		set /a Found+=1
		set "subLang=%subLanguage%"
		set "subFound=%MKVname%.%%X"
		call :MKV-Subtitle-display_sub
		set subtitleSet= ^
		--language			0:%subLanguage% ^
		--track-name		0:"%SubName%" ^
		--default-track	0:%SubSetAsDefault% ^
		"%MKVname%.%%X" 
	)

	REM Search Sub with the same name with language Tag.

	for %%S in ("%MKVname%__*.%%X") do (
		set /a Found+=1
		set "subFormat=.%%X"
		set "subFound=%%S"
		set "subLang=%%S"
		call :MKV-Subtitle-get_language
		call :MKV-Subtitle-display_sub
	)
)

if %Found% LSS 1 (
	echo %MKVfileDisplay_%
	echo %TAB% %g_%No subtitle match the MKV file name.%_%
	echo.&echo.
	POPD&exit /b
)
echo %TAB% Subtitle found ^(%gn_%%Found%%_%^), %_%Adding subtitle into MKV ..%_%
start /wait "" "%MKVMERGE%" -o "%MKVname%_subs.mkv" "%MKVname%.mkv" %subtitleSet%
if exist "%MKVname%_subs.mkv" (
	for %%O in ("%MKVname%_subs.mkv") do (
		set "size_B=%%~zO" 
		call :parser-get_file_size
	)
)
if exist "%MKVname%_subs.mkv" echo %TAB% %gn_%Success:%ESC%%w_%%MKVname%_subs.mkv%_% %pp_%%size% %g_%(%size_B% Bytes)%ESC%
if not exist "%MKVname%_subs.mkv" echo %TAB% %r_%Fail!%_% %g_%Make sure it has a valid "name" and a valid "language id".%_%
echo.&echo.
POPD&exit /b

:MKV-Subtitle-display_sub
for %%F in ("%subFound%") do (
	set "size_B=%%~zF"
	call :parser-get_file_size
)
if /i "%MKVDisplay%"=="yes" if found GEQ 1 echo %MKVfileDisplay%
if /i "%MKVDisplay%"=="yes" if found LSS 1 echo %MKVfileDisplay_%
set "MKVDisplay=no"
echo %TAB%%ESC%%yy_%%subFound%%_% %pp_%%size% %g_%(%size_B% Bytes)%_%%ESC%
echo %TAB%%ESC%%g_%Name:%w_%%SubName%	%g_%Language:%w_%%subLang%	%g_%Default:%w_%%SubSetAsDefault%%ESC%
exit /b

:MKV-Subtitle-get_language
call set "subLang=%%Sublang:%MKVname%__=%%"
call set "subLang=%%Sublang:%SubFormat%=%%"
set subtitleSet= %subtitleSet%^
	--language			0:"%subLang%" ^
	--track-name		0:"%SubName%" ^
	--default-track	0:"%SubSetAsDefault%" ^
	"%subFound%"
exit /b

:Input-Error
echo %TAB%%TAB%%r_%Invalid input.  %_%
echo.
echo %TAB%%TAB%%i_%%r_%%xInput%%_%
echo.
echo %TAB%%g_%The command, file path, or directory path is unavailable. 
echo %TAB%Use %gn_%Help%g_% to see available commands.
goto options

:Input-Context_Exit
if /i "%xInput%"=="refresh.NR" exit
if defined xInput (
	if %exitwait% GTR 9 echo.&echo.&echo %TAB%%g_% Press Any Key to Close this window. &pause>nul&exit
	echo. &echo.
	if /i "%xinput%"=="MKV.Cover-Delete" (
		echo %TAB%%g_%This window will close in %ExitWait% sec.
		ping localhost -n %ExitWait% >nul&exit
	)
	if /i "%cdonly%"=="true" (
		echo %TAB%%g_%This window will close in %ExitWait% sec.
		ping localhost -n %ExitWait% >nul&exit
	)
	if /i "%input%"=="Generate" (
		echo %TAB%%TAB%%g_%Press any key to close this window.
		pause >nul &exit
	)
	if /i "%input%"=="Scan" (
		echo %TAB%%TAB%%g_%Press any key to close this window.
		pause >nul &exit
	)
	echo %TAB%%g_%This window will close in %ExitWait% sec.
	ping localhost -n %ExitWait% >nul&exit
)
exit /b

:MKV-Select
if /i not "%xInput%"=="" mode con:cols=90 lines=11
echo.&echo.&echo.
set MKVselected=%1
for %%I in (%MKVselected%) do (
	set "filename=%%~nxI"
	set "MKVfile=%%~fI"
)
call :Config-Save
echo %TAB% %cc_%File selected!
echo %TAB%%ESC%%c_%%filename%%_%%ESC%
goto options


:MKV-SetCover
if /i not "%xInput%"=="" mode con:cols=90 lines=11
echo.&echo.
for %%I in (%1) do set "filename=%%~nxI"
echo %TAB% %cc_%File selected!
echo %TAB%%ESC%%c_%%filename%%_%%ESC%
set MKVcover=%1
set "MKVcover=%MKVcover:"=%"
call :Config-Save
goto MKV-Cover_Change

:MKV-Cover_Delete
if /i not "%xInput%"=="" mode con:cols=90 lines=11
echo.&echo.&echo.
for %%I in (%1) do set "filename=%%~nxI"
echo %TAB%%cc_% Analyzing.. 
echo %TAB%%ESC%%c_%%filename%%ESC%
echo %TAB%%g_% delete-attachment name: *cover*
"%MKVPROPEDIT%" %1	--delete-attachment name:cover.jpg  --delete-attachment name:cover.png ^
					--delete-attachment name:cover.jpeg --delete-attachment name:cover.gif ^
					--delete-attachment name:cover.tiff --delete-attachment name:cover >nul
MKVPROPEDIT.exe |exit /b
echo %TAB% Done!
goto options

:MKV-Cover_Search.check
setlocal EnableDelayedExpansion
	if /i "x!filename:%CoverTarget%=!"=="x!filename!" exit /b
setlocal DisableDelayedExpansion
echo %TAB%%ESC%%p_%%filename%%ESC% %r_%^[Selected!^]%_%
set "MKVcover=%fullfilename%"
goto MKV-Cover_Change

:MKV-Cover_Search
for %%I in (%1) do set "mkvfilename=%%~nxI" &set mkvfile=%1
set "mkvfile=%mkvfile:"=%"
if /i "%CoverExtension%"=="" set "CoverExtension=.jpg"
PUSHD %1 2>nul &&cd /d %1 ||for %%I in (%1) do cd /d "%%~dpI"
title %name% ^| "%cd%"
FOR /f "tokens=*" %%K in ('dir /b /a:-d') do (
	set "filename=%%~nxK"
	set "fullfilename=%%~fK"
	set "StringCheck=%%K"
	if /i "%CoverExtension%"=="%%~xK" call :MKV-Cover_Search.check
	echo %TAB%%ESC%%g_%%%~nxK%ESC%
)
echo.&echo.
echo %TAB%    No File Match with keyword "%r_%%CoverTarget%%_%"
goto options

:MKV-Cover_Change
echo.&echo.&echo.
for %%I in ("%MKVfile%") do set "MKVfilename=%%~nxI"
for %%I in ("%MKVcover%") do set "Coverfilename=%%~nxI"
echo %TAB%  %cc_%     Changing MKV Cover..%_%
echo %TAB%  MKV File   :%ESC%%c_%%MKVfilename%%ESC% 
echo %TAB%  Cover image:%ESC%%_%%Coverfilename%%ESC%
%p2%
if /i not "%xinput%"=="" echo.
call :MKV-Cover_Changer
goto options

:MKV-Cover_Changer
"%MKVPROPEDIT%" "%mkvfile%"	--delete-attachment name:cover.jpg  --delete-attachment name:cover.png ^
					--delete-attachment name:cover.jpeg --delete-attachment name:cover.gif ^
					--delete-attachment name:cover.tiff --delete-attachment name:cover >nul
"%MKVPROPEDIT%" "%mkvfile%" --attachment-name cover --add-attachment "%MKVcover%"
exit /b

:MKV-Cover_Generate
goto options


:DirectInput
set "input=%input:"=%"
PUSHD "%input%" 2>nul &&goto directInput-folder ||goto directInput-file
POPD&goto options
:DirectInput-Folder
cd /d "%input%"
echo %TAB%Changing directory
echo %TAB%%i_%%input%%-% &>"%~dp0- FIMOFI Status\DrivePath.ini" echo ^<DrivePath=%input%^>&goto options
call :Config-Save
call :UpdateVar
call :Config-Load
goto options
:DirectInput-File
for %%I in ("%input%") do (
		set "filename=%%~nxI"
		set "filepath=%%~dpI"
		if /i %%~xI==.jpg 	goto DirectInput-Generate
		if /i %%~xI==.png 	goto DirectInput-Generate
		if /i %%~xI==.jpeg 	goto DirectInput-Generate
		if /i %%~xI==.bmp 	goto DirectInput-Generate
		if /i %%~xI==.tiff 	goto DirectInput-Generate
		if /i %%~xI==.ico 	goto DirectInput-Generate
		if /i %%~xI==.mkv 	echo %yy_%   it is MKV%_%
		)
echo %TAB%%r_%Format file tidak dikenali.%-%
echo %TAB%%g_%^(supported file: *.ico, *.jpg, *.png, *.jpeg, *.bmp, *.tiff, *.mkv^)
goto options
:DirectInput-Generate
for %%D in ("%cd%") do set "foldername=%%~nD%%~xD" &set "folderpath=%%~dpD"
if not exist desktop.ini echo %TAB%%ESC%%yy_%📁 %foldername%%_%%ESC% &goto directInput-generate-confirm
for /f "usebackq tokens=1,2 delims==," %%C in ("desktop.ini") do set "%%C=%%D"
if not exist "%iconresource%" echo %TAB%%ESC%%y_%📁 %foldername%%_%%ESC% &goto directInput-generate-confirm
echo %TAB%%ESC%%y_%📁 %foldername%%_%%ESC%
echo %TAB%%ESC%Folder icon:%c_%%iconresource%%ESC%
goto directInput-generate-confirm
REM NO NEED TO CONFIRM, Libas aja..
echo %TAB%%ESC%Image selected:%c_%%filename%%ESC% &echo.
echo %TAB% This folder already have folder icon.
echo %TAB% Did you want to replace it^?%_%
set DIchoice=kosong
set /p DIchoice=%-%%-%%-%%-%%gn_%Y%_%/%gn_%N ^> %gn_%
echo %-%
if /i not "%DIchoice%"=="y" echo %TAB%%_%%g_%%i_%   Canceled   %-%&goto options
if /i not "%xInput%"=="" cls &echo.&echo.&echo.&echo.&echo %TAB%%ESC%%yy_%📁 %foldername%%_%%ESC%
:DirectInput-Generate-Confirm
call :Config-Load
call :FI-Generate-Folder_Icon
goto options

:FI-GetDir
set "locationCheck=Start"
REM Current dir only
if /i "%cdonly%"=="true" (
	FOR %%D in (.) do (
		set "location=%%~fD" &set "folderpath=%%~dpD" &set "foldername=%%~nxD"
		call :FI-Scan-Desktop.ini
		EXIT /B
	)
)
REM All inside current dir including subfolders
if /i "%Recursive%"=="yes" (
	FOR /r %%D in (.) do (
		set "location=%%D" &set "folderpath=%%~dpD" &set "foldername=%%~fD"
		call :FI-Scan-Desktop.ini
	)
	EXIT /B
)
REM All inside current dir only
FOR /f "tokens=*" %%D in ('dir /b /a:d') do (
	set "location=%%~fD" &set "folderpath=%%~dpD" &set "foldername=%%~nxD"
	call :FI-Scan-Desktop.ini
)
EXIT /B
:FI-Scan
set "yy_result=0"
set "y_result=0"
set "g_result=0"
set "r_result=0"
set "success_result=0"
set "fail_result=0"
set "target=%target: =*%"
echo %TAB%%TAB%%cc_%%i_%  Scanning folder.. %-%
Echo %TAB%Target    : %target%
echo %TAB%Directory :%ESC%%cd%%ESC%
echo %TAB%%w_%==============================================================================%_%
call :FI-GetDir
echo %TAB%%w_%==============================================================================%_%
echo.
set /a "result=%yy_result%+%y_result%+%g_result%+%r_result%"
echo %TAB%%w_%^(%result% Folder ditemukan.^)%_%
echo.
IF /i %Y_result% 	GTR 0 echo %TAB%%y_%%Y_result%%_% Folder dilewati karna sudah memiliki folder icon.
IF /i %G_result% 	GTR 0 echo %TAB%%g_%%G_result%%_% Folder dilewati karna "%Target%" tidak ditemukan.
IF /i %R_result% 	GTR 0 echo %TAB%%r_%%R_result%%_% Folder icon dapat diganti.
IF /i %YY_result% GTR 0 echo %TAB%%yy_%%YY_result%%_% Folder berisi file "%target%" ditemukan.
IF /i %Y_result% 	LSS 1 IF /i %yy_result% LSS 1 echo %TAB%^("%target%" tidak ditemukan.^) &goto options
echo.
echo   %g_%Note: jika ada lebih dari satu file "%target%" didalam folder, maka yang akan dipilih
echo   sebagai folder icon adalah file "%target%" teratas didalam folder.
set "result=0" &goto options

:FI-Scan-Desktop.ini
	if "%locationCheck%"=="%location%" EXIT /B
:: Hati-hati, jangan selalu gunakan (), gunakan ESCAPE disetiap variable.
PUSHD "%location%"
	set "locationCheck=%location%" &set "Selected="
	if not exist "desktop.ini" (
		if exist "%Target%" (
			if "%newline%"=="yes" echo.
			echo %TAB%%ESC%%yy_%📁 %foldername%%ESC%
			set /a YY_result+=1 
			call :FI-Scan-Find_Target
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
			call :FI-Scan-Find_Target
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
			echo %TAB%%ESC%Folder icon:%r_%%iconresource%%ESC%%r_%%i_%Not Found!%-%
			echo %TAB%%g_% This folder already have a Folder icon, but icon is missing.%_%
			echo %TAB%%g_% Icon will be repalced by selected image.%_%
			call :FI-Scan-Find_Target
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
	if /i "%xinput%"=="Create" call :FI-Scan-Find_Target
POPD&EXIT /B
rem if exist "desktop.shellinfo.ini" >desktop.ini type desktop.shellinfo.ini &>>desktop.ini echo Tes &>>desktop.ini echo Satu &>>desktop.ini echo dua &echo. &EXIT /B

:FI-Scan-Find_Target
for %%F in (%target%) do (
	set "newline=no"
	set "Filename=%%~nxF"
	set "FilePath=%%~dpF"
	if /i "%input%"=="Scan" call :FI-Scan-Display_Result
	if /i "%input%"=="Generate" call :FI-Generate-Folder_Icon
)
echo. &EXIT /B

:FI-Scan-Display_Result
if "%Selected%"=="" (
	set "Selected=%Filename%" 
	echo %TAB%%ESC%%_%Selected Image:%c_%%Filename%%ESC%
)
EXIT /B

:FI-Generate
set "yy_result=0"
set "y_result=0"
set "g_result=0"
set "r_result=0"
set "success_result=0"
set "fail_result=0"
echo %TAB%%TAB%%cc_%%i_%  Generating folder icon..  %-%
call :Config-Load
if "%Converter%"=="" (set "Converter=%~dp0Convert.exe") else (set "Converter=%~dp0%Converter%")
Echo %TAB%Target    : %target%
if exist "%FItemplate%" for %%T in ("%FItemplate%") do ^
Echo %TAB%Template  : %w_%%%~nT%_% 
echo %TAB%Directory :%ESC%%cd%%ESC%
echo %TAB%%cc_%==============================================================================%_%
call :FI-GetDir
echo %TAB%%cc_%==============================================================================%_%
echo.
set /a "result=%yy_result%+%y_result%+%g_result%+%r_result%"
if /i "%cdonly%"=="true" if %success_result% EQU 1 goto options
if /i "%cdonly%"=="true" if %y_result% EQU 1 (
	cls &echo.&echo.&echo.&echo.
	echo %TAB%%ESC%%y_%📁 %foldername%%ESC%
	echo.
	echo %TAB%%w_%Folder already have icon. 
	echo %TAB%Remove it first.%_% 
	goto options
)
if /i "%cdonly%"=="true" if %g_result% EQU 1 (
	cls &echo.&echo.&echo.&echo.
	echo %TAB%%ESC%%g_%📁 %foldername%%ESC%
	echo.
	echo %TAB%%w_%Couldn't find %target%
	echo %TAB%Make sure there is file ^(%target%^) inside selected folder.%_%
	goto options
)
echo %TAB%  ^(%result% Folder ditemukan.^)
echo.
IF /i %fail_result% LSS 1 IF /i %YY_result% GTR 0 echo %TAB%%cc_%%YY_result%%_% Folder berhasil diproses.
IF /i %R_result% 	GTR 0 echo %TAB%%r_%%R_result%%_% Folder icon di gantikan.
IF /i %Y_result% 	GTR 0 echo %TAB%%y_%%Y_result%%_% Folder dilewati karna sudah memiliki icon.
IF /i %G_result% 	GTR 0 echo %TAB%%g_%%G_result%%_% Folder dilewati karna %Target% tidak ditemukan.
IF /i %YY_result%	LSS 1 echo %TAB% Tidak ada folder untuk diproses.
IF /i %fail_result% GTR 1 IF /i %success_result%	GTR 1 (
	echo %TAB% %success_result% Berhasil diproses.
	echo %TAB% %fail_result% Gagal diproses.
)
echo %TAB%------------------------------------------------------------------------------
ie4uinit.exe -ClearIconCache
ie4uinit.exe -show
REM if /i "%cdonly%"=="true" (set "RefreshOpen=Select" &call :Config-Save) else (set "RefreshOpen=Index" &call :Config-Save)
goto options

:FI-Generate-Folder_Icon
@echo off
if "%Selected%"=="" (
	if "%xInput%"=="" (
		set inputfile="%input%" &set outputfile="%cd%\foldericon.ico"
	) else (
		set inputfile="%filepath%%filename%" &set outputfile="%filepath%foldericon.ico"
	)
)
if "%Selected%"=="" (
	attrib -r "%cd%" &attrib |exit /b
	set "Selected=%Filename%" 
	echo %TAB%%ESC%%_%Selected Image:%c_%%Filename%%ESC%%r_%
	if exist "foldericon.ico" (
		attrib -s -h "foldericon.ico"
		ren "foldericon.ico" "foldericon.old.ico"
	)
	PUSHD "%~dp0"
		call "%FItemplate%"
	POPD
	if exist "foldericon.ico" for /f %%S in ("foldericon.ico") do (
		if %%~zS GTR 10000 echo  %cc_%%TAB%Convert success - foldericon.ico ^(%%~zS Byte^) %r_%
		if %%~zS LSS 10000 echo  %r_%%TAB%Convert error - foldericon.ico ^(%%~zS Byte^) "%%~dpnxS"%r_% &del /q foldericon.ico >nul
	)
	if exist "foldericon.ico" (
		echo  %g_%%TAB%%cc_%Applying resources and attributes..%r_%
		if exist "desktop.ini" attrib -s -h "desktop.ini" &attrib |exit /b
		>Desktop.ini	echo ^[.ShellClassInfo^]
		>>Desktop.ini	echo IconResource=foldericon.ico
		>>Desktop.ini	echo ^;Folder Icon generated using %name%.
		attrib +r "%cd%" &attrib |exit /b
	) else (
		echo  %i_%Convert "%Filename%" ke icon gagal.%-% &set /a "fail_result+=1"
		if exist "foldericon.old.ico" ren "foldericon.old.ico" "foldericon.ico"
	)
	if exist "desktop.ini" if exist "foldericon.ico" (
		if exist "foldericon.old.ico" del /q "foldericon.old.ico"
		ren "Desktop.ini" "desktop.ini"
		attrib +s +h "desktop.ini"
		attrib +h +s "foldericon.ico"
		attrib |EXIT /B
		echo %TAB% %i_%%cc_%  Done!  %-% 
		set /a "success_result+=1"
	)
)
EXIT /B

:FI-Generate-Get_Template
for /f "usebackq tokens=1,2 delims==<>" %%C in ("%~dp0config.ini") do set %%C=%%D
if not exist "%FItemplate%" (
	echo.
	echo %TAB% %w_%Couldn't load template.
	echo %TAB%%ESC%%r_%%FItemplate%%ESC%
	echo %TAB% %i_%%r_%File not found.%-%
	goto options
)
EXIT /B

:FI-Template
if /i not "%xInput%"=="" cls &echo.&echo.&echo.&echo.
for %%I in ("%FITemplate%") do (set "TName=%%~nI")
echo %TAB%%w_%%u_%Current Template%_%:%ESC%%cc_%%TName%%ESC%
for /f "usebackq tokens=1,2 delims=#" %%I in ("%FITemplate%") do if /i not "%%J"=="" echo %ESC%%%J%ESC%
echo %TAB%%_%
echo.
echo %TAB%%TAB%%i_%%cc_%   Template   %-%
echo.
set "TCount=0"
set "TSelector=GetList"
PUSHD "%~dp0Template"
	FOR %%T in (*.bat) do (
		set /a TCount+=1
		set "TName=%%~nT"
		set "TPath=%%~fT"
		call :FI-Template-Get_List
	)
POPD
set "TCount=0"
set "TemplateChoice= "
echo.
set /p "TemplateChoice=%_%%w_%%TAB%%TAB%Choose template:%_%%gn_%"
if /i "%TemplateChoice%"==" " goto FI-Template
set "TSelector=Select"
PUSHD "%~dp0Template"
	FOR %%T in (*.bat) do (
		set /a TCount+=1
		set "TName=%%~nT"
		set "TPath=%%~fT"
		call :FI-Template-Get_List
	)
POPD
if not exist "%FItemplate%" echo    %r_%"%FItemplate%" %i_%Not found.%-%
echo %_%%TAB%%i_%  Invalid selection.  %-% 
echo %TAB%Use number beetween 1 up to %TCount% to select it.
goto options

:FI-Template-Get_List
if /i "%Tselector%"=="GetList" (
	echo %TAB%%TAB%%gn_%%TCount%%_% ^>%ESC%%cc_%%TName%%_%%ESC%
	exit /b
)
set "_info="
if /i "%TSelector%"=="Select" (
	if /i not "%xInput%"=="" cls &echo.&echo.&echo.&echo.
	if /i not "%TCount%"=="%TemplateChoice%" exit /b
	set "FItemplate=%TPath%"
	echo.
	echo   %_%%ESC%%cc_%  %TName%%_% selected.%ESC%&%p1%
	for /f "usebackq tokens=1,2 delims=#" %%I in ("%TPath%") do if /i not "%%J"=="" echo %ESC%%%J%ESC%
	%p2%
	goto FI-Template-Test_Config
)
goto options

:FI-Template-Test_Config
call :Config-Save 
call :UpdateVar
call :Config-Load
set inputfile="%~dp0Template\img\test.jpg"
set outputfile="%~dp0Template\img\test.ico"
if exist %outputFile% del /q %outputFile%
if /i "%xInput%"=="IMG-FI.Choose.Template" set inputfile=%img%
echo %i_%%g_%  Testing Config %-%
echo %g_%Test img: %inputfile%%r_%
PUSHD "%~dp0"
Call "%FItemplate%"
POPD
IF %ERRORLEVEL% NEQ 0 echo   %r_%%i_%   error ^(%ERRORLEVEL%^)   %-%
IF exist %outputFile% echo %g_%Done! &explorer.exe %outputFile%
goto options

:FI-Search_Folder_Icon
if /i "%xInput%"=="FI.Search.Folder.Icon" (
	For %%I in (%1) do (Start "" "https://google.com/search?q=%%~nxI folder icon&tbm=isch&tbs=ic:trans")
	exit
)
echo.&echo.
echo                     %g_%    Search folder icon  on google image search, Just type
echo                     %g_% the keyword and then hit [Enter], you will be redirected 
echo                     %g_% to google search image.%_%
echo.&echo.&echo.&echo.
echo                                       %i_%%w_% SEARCH FOLDER ICON %_%
echo.
set "SrcInput= "
set /p "SrcInput=%_%%w_%                                     %_%%w_%"
if /i "%SrcInput%"==" " cls &echo.&echo.&echo.&goto FI-Search_Folder_Icon
Start "" "https://google.com/search?q=%SrcInput% folder icon&tbm=isch&tbs=ic:trans"
cls
Goto Options

:FI-Keyword                  
echo %TAB%%g_%Current keyword:%ESC%%c_%%FItarget%%ESC%%_%
echo %TAB%%g_%This keyword will be use to search file name to generate folder icon.%_%
set "newFItarget=*"
echo.
set /p "newFItarget=%-%%-%%-%%w_%Change keyword:%c_%"
if "%newFItarget%"=="*" set "newFItarget=%FItarget%"
set "FItarget=%newFItarget%"
set "FItarget=%FItarget: =*%"
echo. &echo. &echo.
echo %TAB%%_%%g_%Current extension: %c_%%FIextension%%_%
echo %TAB%%g_%In generate proccess, matched file name and file extension will
echo %TAB%%g_%automatically convert into .Ico and set it as folder icon.
echo.
echo %TAB%%gn_%  1%_% ^> %c_%.Png%_%
echo %TAB%%gn_%  2%_% ^> %c_%.Jpg%_%
echo %TAB%%gn_%  3%_% ^> %c_%.Ico%_%
echo %TAB%%gn_%  4%_% ^> %c_%.Webp%_%
echo %TAB%%gn_%  5%_% ^> %c_%.Jpeg%_%
echo %TAB%%gn_%  6%_% ^> %c_%Other..%_%
echo.
set "extChoice=kosong"
set /p "extChoice=%-%%-%%-%%w_%Select file extension:%gn_%"
if /i "%extChoice%"=="kosong" goto Keyword-Selected
if /i "%extChoice%"=="1" set "FIextension=.Png" &goto Keyword-Selected
if /i "%extChoice%"=="2" set "FIextension=.Jpg" &goto Keyword-Selected
if /i "%extChoice%"=="3" set "FIextension=.Ico" &goto Keyword-Selected
if /i "%extChoice%"=="4" set "FIextension=.Webp" &goto Keyword-Selected
if /i "%extChoice%"=="5" set "FIextension=.Jpeg" &goto Keyword-Selected
if /i "%extChoice%"=="6" goto Keyword-Extension
echo.
echo %TAB%%_%%i_%  Invalid selection.  %-%
echo.
goto options
:FI-Keyword-Extension
set /p "FIextension=%-%%-%%-%%w_%Define file extension:%c_%"
:FI-Keyword-Selected
call :Config-Save &call :UpdateVar
if "%xInput%"=="DefKey" (
	cls &echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.
	echo %TAB%%TAB%%TAB%%TAB%%_%%ESC%%printTagFI%%ESC% will be used to generate folder icon.
	ping localhost -n 3 >nul
	goto options
)
goto Status

:FI-Activate
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
:FI-Deactivate
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

:FI-Remove
@echo off
set "result=0"
set "delresult=0"
IF /I "%DELETE%"=="CONFIRM" goto FI-Remove-Confirm
echo %TAB%%r_%   %i_%  Remove Folder Icon  %-%
echo.
echo %TAB%%w_%Directory:%ESC%%w_%%cd%%ESC%
echo %TAB%%w_%==============================================================================%_%
call :FI-Remove-Get
echo %TAB%%w_%==============================================================================%_%
IF /i %result% LSS 1 if defined xInput cls
IF /i %result% LSS 1 echo.&echo.&echo. &echo %_%%TAB%^(%r_%%result%%_%%_%^) Couldn't find any folder icon. &goto options
echo. &echo %_%%TAB%  ^(%y_%%result%%_%%_%^) Folder icon found.%_% &echo.
echo       %_%%r_%Continue to Remove (%y_%%result%%_%%r_%^) folder icon^?%-% 
echo %TAB%%ast%%g_%Folder icon will deactivated from the folder, "desktop.ini" and "foldericon.ico"
echo %TAB% inside folder will be deleted. Insert command %gg_%Y%g_% to confirm.%_%
set cho=kosong
set /p "delete=%-%%-%%-%%-%%g_%Options: %gn_%Y%_%/%gn_%N%_% %gn_%> " 
if /i "%delete%"=="Y" if defined xInput cls
if /i "%delete%"=="Y" set "delete=confirm" &goto FI-Remove
echo %_%%TAB%%I_%     Canceled     %_% &goto options
if /i "%cdonly%"=="false" echo.pause >nul
goto options

:FI-Remove-Confirm
echo.&echo.&echo.&echo.
echo %TAB%%r_%   %i_%  Removing Folder Icon..  %-%
echo.
if /i not "%cdonly%"=="true" echo %TAB%%w_%Directory:%ESC%%w_%%cd%%ESC%
if /i not "%cdonly%"=="true" echo %TAB%%w_%==============================================================================%_%
if /i not "%cdonly%"=="true" echo.
call :FI-Remove-Get
if /i not "%cdonly%"=="true" echo %TAB%%w_%==============================================================================%_%
IF /i %result% LSS 1 if defined xInput cls
IF /i %result% LSS 1 echo.&echo.&echo. &echo %_%%TAB%^(%r_%%result%%_%%_%^) Couldn't find any folder icon. &goto options
if %delresult% GTR 0 echo. &echo %TAB% ^(%r_%%delresult%%_%^) Folder icon deleted.
rem if /i not "%cdonly%"=="true" echo. &echo %TAB%%g_%Press any key to close this window. &pause >nul &exit
goto options

:FI-Remove-Get
if /i "%cdonly%"=="true" (
	FOR %%D in (.) do (
	set "location=%%~fD" &set "folderpath=%%~dpD" &set "foldername=%%~nxD"
		PUSHD "%%~fD"
			if exist "desktop.ini" (
				FOR /f "usebackq tokens=1,2 delims==," %%C in ("desktop.ini") do (
					set "%%C=%%D"
					if /i "%%C"=="iconresource" call :FI-Remove-Act
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
			FOR /f "usebackq tokens=1,2 delims==," %%C in ("desktop.ini") do (
				set "%%C=%%D"
				if /i "%%C"=="iconresource" call :FI-Remove-Act
			)
		)
	POPD
)
EXIT /B

:FI-Remove-Act
if not "%delete%"=="confirm" (
	if exist "%iconresource%" (
		set /a result+=1
		echo %ESC%%TAB%%y_%📁 %foldername%%ESC% &exit /b
	)
	exit /b
)
if exist "%iconresource%" (
	set /a result+=1
	if "%delete%"=="confirm" (
		echo %ESC%%TAB%%w_%📁 %_%%foldername%%ESC%
		echo %TAB% %g_%Folder icon:%ESC%%c_%%iconresource%%ESC%
		if /i not "%iconresource%"=="foldericon.ico" echo %TAB% %g_%Folder icon is not "foldericon.ico", it wont be deleted.%_%
		echo %TAB% %r_%Deleting resources..%r_%
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

:FI-ScanFunction                     
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
set "MKVfile=%newTag%"
set "MKVfile=%MKVfile: =*%"
call :Config-Save &call :UpdateVar 
echo    %_%Target pencarian file MKV: %printTagMKV% &goto Options

:FI-ScanMkv                          
echo      %cc_%Scanning MKV..%_%
set "ext=.mkv"
call :FI-ScanFunction
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
:FI-Refresh
rem if defined xInput (
rem 	echo %TAB%%TAB%%_%%r_%Restart File Explorer^?%-% 
rem 	echo   %ast%%g_%Untuk memaksa windows melakukan update icon dan  thumbnail  cache%_%
rem 	echo   %g_% File Explorer akan direstart. Masukan perintah %gn_%Y%g_% untuk konfirmasi.
rem 	set choice=kosong
rem 	set /p "choice=%-%%-%%-%Options: %gn_%Y%_%/%gn_%N%_% %gn_%^> " 
rem 	if /i not %choice%==y echo %_%%TAB%%I_%     Canceled     %_% &goto options
rem )
if /i not "%xInput%"=="" echo.&echo.&echo.
echo %_%%g_%%TAB%Note: In case if the proccess is stuck and explorer won't come back. 
echo %TAB%Hold %i_% CTRL %_%%g_%+%i_% SHIFT %_%%g_%+%i_% ESC %_%%g_%%-% %g_%^> Click File ^> Run New Task ^> Type "explorer" ^> OK.
echo %TAB%%cc_%Restarting Explorer and updating icon cache ..%r_%
echo.&set "startexplorer="
ie4uinit.exe -ClearIconCache
ie4uinit.exe -show
taskkill /F /IM explorer.exe >nul ||echo 	echo %i_%%r_% Failed to Terminate "Explorer.exe" %_%
PUSHD "%userprofile%\AppData\Local\Microsoft\Windows\Explorer"
if exist "iconcache_*.db" attrib -h iconcache_*.db
if exist "%localappdata%\IconCache.db" DEL /A /Q "%localappdata%\IconCache.db"
if exist "%localappdata%\Microsoft\Windows\Explorer\iconcache*" DEL /A /F /Q "%localappdata%\Microsoft\Windows\Explorer\iconcache*"
start explorer.exe ||set "startexplorer=fail"
POPD
if "%startexplorer%"=="fail" (
	echo.&%P4%&%P3%
	echo %i_%%r_%  Failed to start "Explorer.exe"  %_%
	)
if /i "%RefreshOpen%"=="Select" (explorer.exe /select, "%cd%") else explorer.exe "%cd%"
echo %TAB%%TAB%%cc_%%i_%    Done!   %-%
call :FI-Refresh-NoRestart
if /i "%act%"=="Refresh" exit /b
%p2% &%p2% &goto options

:FI-Refresh-NoRestart                
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
		attrib +r "%cd%"
		attrib -s -h 		"desktop.ini"
		ren "desktop.ini" "DESKTOP.INI"
		attrib +r "%cd%"
		ren "DESKTOP.INI" "Desktop.ini"
		attrib +s +h 		"Desktop.ini"
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
			attrib +r "%%~fR"
			attrib -s -h 		"desktop.ini"
			ren "desktop.ini" "DESKTOP.INI"
			attrib +r "%%~fR"
			ren "DESKTOP.INI" "Desktop.ini"
			attrib +s +h 		"Desktop.ini"
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
	echo  Couldn't find any folder icon in here..
	echo  "%cd%"
	ping localhost -n 5 >nul
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
cd .. &%p1% &title %name% ^| "%cd%" &%p1% 
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
:VTM
mode con:cols=50 lines=9
set "ms=0" &cls
for %%A in (%xSelected%) do set /a xfiles+=1
for %%V in (%xSelected%) do (
	set /a count+=1
	set "output=%%~fV.jpg"
	set "fname=%%~nV"
	if not exist "%%~fV.jpg" (
		start "" /min cmd.exe /c call "%VTM%" "%%~fV"
		call :VTMloop
	) else (explorer.exe "%%~fV.jpg")
)
echo.
if %ms% LSS 1 exit
echo %i_%%cc_%  Done!  %_% 
goto options
:VTMloop
cls
set /a ms+=1
if %xfiles% GTR 1 echo files ^(%count%^)
echo %_%Processing...%r_% %ms%%_% ms
if not exist "%output%" goto VTMloop
%p2%
taskkill /F /IM "VideoThumbnailsMaker.exe" >nul
if %xfiles% GTR 1 exit /b
explorer "%output%"
%p3%
rem del /q "%output%"
exit /b

:Varset                           
set "MKVPROPEDIT=%programfiles%\MKVToolNix\mkvpropedit.exe"
set "MKVMERGE=%programfiles%\MKVToolNix\mkvmerge.exe"
set "MKVINFO=%programfiles%\MKVToolNix\mkvinfo.exe"
set "MKVEXTRACT=%programfiles%\MKVToolNix\mkvextract.exe"
set g_=[90m
set gr_=[100m
set gg_=[32m
set gn_=[92m
set u_=[4m
set w_=[97m
set r_=[31m
set rr_=[91m
set r_=[31m
set b_=[34m
set bb_=[94m
set yy_=[93m
set c_=[36m
set cc_=[96m
set _=[0m
set -=[0m[30m-[0m
set i_=[7m
set p_=[35m
set pp_=[95m
set ntc_=%_%%i_%%w_% %_%%-%
set "TAB=   "
set "ESC=[30m"[0m"
set "AST=%r_%*%_%"                         
set p1=ping localhost -n 1 ^>nul
set p2=ping localhost -n 2 ^>nul
set p3=ping localhost -n 3 ^>nul
set p4=ping localhost -n 4 ^>nul
call :Config-Load
if exist "%DrivePath%" (cd /d "%DrivePath%") else (cd /d "%~dp0")
call :UpdateVar
EXIT /B

:UpdateVar                      
title %name%    "%cd%"
set "result=0"
set "target=*%FItarget%*%FIextension%"
for %%T in ("%FItemplate%") do set TemplateName=%%~nT
set "PrintCurrentdir=IF EXIST "*%MKVfile%**%MKVextension%" echo   %_%%cd%"
set "PrintSubdir=IF EXIST "*%MKVfile%**%MKVextension%" echo   %_%%%a"
set "scanDetect=FOR %%a in (*%MKVfile%**%MKVextension%) do"
set "do=echo   %g_%-- %c_%%%a%_%%g_% &set /a result+=1"
set "editExit=%MKVedit% |EXIT /B"
set "exitCode=>nul"
set "printTagMKV=%ast%%c_%%MKVfile%%ast%%_% %ast%%c_%%MKVextension%%_%"
set "printTagFI=%ast%%c_%%FItarget%%ast%%_%%c_%%FIextension%%_%"
set delcover=--delete-attachment name:cover.jpg  --delete-attachment name:cover.png ^
			  --delete-attachment name:cover.jpeg --delete-attachment name:cover.gif ^
			  --delete-attachment name:cover
set delCoverforce=--delete-attachment "mime-type:image/jpeg" --delete-attachment "mime-type:image/png"
EXIT /B

:Config-Save
REM Save current config to Config.ini
(
	echo ;                          [FIMOFI CONFIGURATION]
	echo ; Here you can configure something.
	echo ;
	echo ;   [Resources]
	echo ;------------------------------------------------------------------------------
	echo Converter="%Converter%"
	echo MKVmerge="%MKVmerge%"
	echo MKVpropedit="%MKVpropedit%"
	echo VTM="%VTM%"
	echo ; The Actual tools i use.
	echo ;------------------------------------------------------------------------------
	echo DrivePath="%cd%"
	echo ; Active directory when you open main batch script.
	echo ;------------------------------------------------------------------------------
	echo ;
	echo ;   [Folder Icon]
	echo ;------------------------------------------------------------------------------
	echo FItarget="%FItarget%"
	echo ; Keyword to search and select image as Folder Icon.
	echo ;
	echo FIextension="%FIextension%"
	echo ; Image extension to search and select as Folder Icon.
	echo ;
	echo FItemplate="%FItemplate%"
	echo ; Tempalte for Folder Icon you want to set.
	echo ;------------------------------------------------------------------------------
	echo ;
	echo ;   [MKV]
	echo ;------------------------------------------------------------------------------
	echo MKVfile="%MKVfile%"
	echo ; Selected MKV file.
	echo ;
	echo MKVcover="%MKVcover%"
	echo ; Selected image to set as MKV cover.
	echo ;
	echo MKVsubtitle="%MKVsubtitle%"
	echo ; Selected subtitle to add to selected MKV file.
	echo ;------------------------------------------------------------------------------
	echo ;
	echo ;   [Subtitle]
	echo ;------------------------------------------------------------------------------
	echo SubLanguage="%SubLanguage%"
	echo ; Set language for  added subtitle. You can use 2 digits  or 3 digits  language
	echo ; code. Example: EN for English, ID for Indonesian, RUS for Russian and so on..
	echo ;
	echo SubName="%SubName%"
	echo ; Set name for added subtitle.
	echo ;
	echo SubSetAsDefault="%SubSetAsDefault%"
	echo ; Make added subtitle set as default, so when you play the MKV it automatically
	echo ; selected.
	echo ;------------------------------------------------------------------------------
	echo ;
	echo ;   [Other]
	echo ;------------------------------------------------------------------------------
	echo ExitWait="%ExitWait%"
	echo ; Set a delay before command window closes by itself after a task is completed.
	echo ; if it's set to 10 seconds or more, the window will just pause.
	echo ;------------------------------------------------------------------------------
)>"%~dp0Config.ini"
EXIT /B

:Config-Load
REM Load Config from Config.ini
if not exist "%~dp0Config.ini" call :Config-GetDefault &%p3%
if exist "%~dp0Config.ini" (
	for /f "usebackq tokens=1,2 delims==" %%C in ("%~dp0Config.ini") do (set "%%C=%%D")
) else (echo.&echo.&echo.&echo.&echo.       %w_%Couldn't load %r_%Config.ini%_%.&pause>nul&exit)
set "Converter=%Converter:"=%"
set "MKVmerge=%MKVmerge:"=%"
set "MKVpropedit=%MKVpropedit:"=%"
set "VTM=%VTM:"=%"
set "DrivePath=%DrivePath:"=%"
set "FItarget=%FItarget:"=%"
set "FIextension=%FIextension:"=%"
set "FItemplate=%FItemplate:"=%"
set "MKVfile=%MKVfile:"=%"
set "MKVcover=%MKVcover:"=%"
set "MKVsubtitle=%MKVsubtitle:"=%"
set "SubLanguage=%SubLanguage:"=%"
set "SubName=%SubName:"=%"
set "SubSetAsDefault=%SubSetAsDefault:"=%"
set "ExitWait=%ExitWait:"=%"
EXIT /B

:Config-GetDefault
(
	echo Converter="%~dp0Convert.exe"
	echo MKVmerge="%programfiles%\MKVToolNix\mkvmerge.exe"
	echo MKVpropedit="%programfiles%\MKVToolNix\mkvpropedit.exe"
	echo VTM="%programfiles%\Video Thumbnails Maker\VideoThumbnailsMaker.exe"
	echo DrivePath="%cd%"
	echo FItarget="*"
	echo FIextension=".png"
	echo FItemplate="%~dp0Template\(No Template).bat"
	echo MKVfile=""
	echo MKVcover=""
	echo MKVsubtitle=""
	echo SubLanguage="id"
	echo SubName="(Added Subtitle)"
	echo SubSetAsDefault="Yes"
	echo ExitWait="3"
)>"%~dp0Config.ini"
EXIT /B

:Colour
start "Colour options" cmd /c "D:\Document\Script\Text color in batch\Tes colour.bat"
goto options