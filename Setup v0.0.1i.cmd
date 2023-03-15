@echo off
cd /d %~dp0
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
set bk_=[30m
set _=[0m
set -=[0m[30m-[0m
set i_=[7m
set b_=[44m[97m
set bg_=[100m
set p_=[35m
set pp_=[95m
:Setup_Options
echo.&echo.&echo.&echo.&echo.&echo.
echo                  %i_%%cc_%  Setup Options  %_%                
echo.
echo                  %gn_%1 %w_%^> %cc_%Install%_%
echo                  %gn_%2 %w_%^> %cc_%Uninstall%_%
echo.&echo.
echo            %g_%This setup will add  %w_%Folder Icon Tools%g_% and  %w_%MKV Tools
echo            %g_%to your right click menu. Press %gg_%1%g_% to Install or Press
echo            %gg_%2%g_% to Uninstall.%_%%bk_%
echo.&echo.
choice /C:12 /N
set select=%errorlevel%
if "%select%"=="1" echo %_%Installing ..	&set "Setup_action=install"		&set "HKEY=HKEY"	&goto Setup_Proccess
if "%select%"=="2" echo %_%Uninstalling ..	&set "Setup_action=uninstall"	&set "HKEY=-HKEY"	&goto Setup_Proccess
goto Options

:Setup_Proccess
set "Setup_Write=%~dp0Setup_%Setup_action%.reg"
call :Setup_Writing
if not exist "%~dp0Setup_%Setup_action%.reg" goto Setup_error
echo %g_%Updating shell extention menu ..%_%
regedit.exe /s "%~dp0Setup_%Setup_action%.reg" ||goto Setup_error
del /q "%~dp0Setup_%Setup_action%.reg"
REM ping localhost -n 2 >nul
echo %i_%%cc_%   Done!   %_%
REM ping localhost -n 4 >nul
pause>nul
exit

:Setup_error
cls
echo.&echo.&echo.&echo.&echo.&echo.&echo.&echo.
echo            %r_%Access Denied! 
echo            %w_%Pls. Run As Admin.
del /q "%~dp0Setup_%Setup_action%.reg"
pause>nul&exit


:Setup_Writing
echo %g_%Preparing registry entry ...%_%
REM ping localhost -n 2 >nul
:: /k to pass variable to main batch

:: Escaping the slash using slash
set "curdir=%cd%"
set "curdir=%curdir:\=\\%"

:: Multi Select, Separate instance
set cmd=cmd.exe /c
set fimofi=\"%curdir%\\FIMOFI Tool v0.0.1i.bat\"

:: Multi Select, Single instance
set SCMD=\"%curdir%\\SingleInstanceAccumulator.exe\" \"-c:cmd /c
set SFIMOFI=^^^&set \"\"xSelected=$files\"\" ^^^&call \"\"%curdir%\\FIMOFI Tool v0.0.1i.bat\"\"\"

:: Define registry root
set RegExBG=%HKEY%_CLASSES_ROOT\Directory\Background\shell
set RegExDir=%HKEY%_CLASSES_ROOT\Directory\shell
set RegExImage=%HKEY%_CLASSES_ROOT\SystemFileAssociations\image\shell
set RegExVideo=%HKEY%_CLASSES_ROOT\SystemFileAssociations\MyVideo\shell
set RegExMKV=%HKEY%_CLASSES_ROOT\SystemFileAssociations\.mkv\shell
set RegExMP4=%HKEY%_CLASSES_ROOT\SystemFileAssociations\.mp4\shell
set RegExSRT=%HKEY%_CLASSES_ROOT\SystemFileAssociations\.srt\shell
set RegExShell=%HKEY%_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell

:: Generating setup_*.reg
(
	echo Windows Registry Editor Version 5.00
	
	:REG-IMAGE-Actions
	echo [%RegExShell%\FIMOFI.IMG-Actions]
	echo "MUIVerb"="Actions"
	echo "Icon"="shell32.dll,-16801"
	echo [%RegExShell%\FIMOFI.IMG-Actions\command]
	echo @="%SCMD% set \"\"xInput=IMG-Actions\"\" %SFIMOFI% \"%%1\""
	
	:REG-IMAGE-Set.As.Folder.Icon
	echo [%RegExShell%\FIMOFI.IMG-Set.As.Folder.Icon]
	echo "MUIVerb"="Set As Folder Icon"
	echo "Icon"="shell32.dll,-16825"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.IMG-Set.As.Folder.Icon\command]
	echo @="%cmd% set \"xInput=IMG-Set.As.Folder.Icon\" &call %fimofi% \"%%1\""

	:REG-IMAGE-FI.Choose.Template
	echo [%RegExShell%\FIMOFI.IMG-FI.Choose.Template]
	echo "MUIVerb"="Coose Template"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.IMG-FI.Choose.Template\command]
	echo @="%cmd% set \"xInput=IMG-FI.Choose.Template\" &call %fimofi% \"%%V\""	

	:REG-IMAGE-Set.as.Cover
	echo [%RegExShell%\FIMOFI.IMG-Set.As.Cover]
	echo "MUIVerb"="Set As MKV Cover"
	echo "Icon"="shell32.dll,-16825"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.IMG-Set.As.Cover\command]
	echo @="%cmd% set \"xInput=IMG-Set.As.Cover\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Extend-Cover
	echo [%RegExShell%\FIMOFI.MKV.Extend-Cover]
	echo "MUIVerb"="MKV Cover Tools"
	echo "Icon"="shell32.dll,-16801"
	echo "CommandFlags"=dword:00000020
	echo "SubCommands"="FIMOFI.MKV.KeySearch;FIMOFI.MKV.KeySet;FIMOFI.MKV.KeyCover"
	
	:REG-MKV.Extend-Selection
	echo [%RegExShell%\FIMOFI.MKV.Extend-Selection]
	echo "MUIVerb"="Selection List"
	echo "Icon"="shell32.dll,-16801"
	echo "SubCommands"="FIMOFI.MKV.Selection.Action;FIMOFI.MKV.Selection.Add;FIMOFI.MKV.Selection.Scan;FIMOFI.MKV.Selection.View;FIMOFI.MKV.Selection.Clear;FIMOFI.MKV.Selection.Edit"
	
	:REG-MKV.SetCover
	echo [%RegExShell%\FIMOFI.MKV.SetCover]
	echo "MUIVerb"="Set as MKV Cover"
	echo "Icon"="shell32.dll,-16825"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.MKV.SetCover\command]
	echo @="%cmd% set \"xInput=MKV.SetCover\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Actions
	echo [%RegExShell%\FIMOFI.MKV.Actions]
	echo "MUIVerb"="Actions"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Actions\command]
	echo @="%Scmd% set \"xInput=MKV.Actions\" %Sfimofi% \"%%1\""
	
	:REG-MKV.Selection.Action
	echo [%RegExShell%\FIMOFI.MKV.Selection.Action]
	echo "MUIVerb"="Action"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Selection.Action\command]
	echo @="%cmd% set \"xInput=MKV.Selection.Action\" &call %fimofi% \"%%1\""

	:REG-MKV.Selection.View
	echo [%RegExShell%\FIMOFI.MKV.Selection.View]
	echo "MUIVerb"="Selection List"
	echo "Icon"="shell32.dll,-16825"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.MKV.Selection.View\command]
	echo @="%cmd% set \"xInput=MKV.Selection.View\" &call %fimofi% \"%%1\""

	:REG-MKV.Selection.Add
	echo [%RegExShell%\FIMOFI.MKV.Selection.Add]
	echo "MUIVerb"="Add to Selection"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Selection.Add\command]
	echo @="%cmd% set \"xInput=MKV.Selection.Add\" &call %fimofi% \"%%1\""
		
	:REG-MKV.Selection.Clear
	echo [%RegExShell%\FIMOFI.MKV.Selection.Clear]
	echo "MUIVerb"="Clear Selection List"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Selection.Clear\command]
	echo @="%cmd% set \"xInput=MKV.Selection.Clear\" &call %fimofi% \"%%1\""

	:REG-MKV.Selection.Edit
	echo [%RegExShell%\FIMOFI.MKV.Selection.Edit]
	echo "MUIVerb"="Open MKV_List.txt"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Selection.Edit\command]
	echo @="%cmd% set \"xInput=MKV.Selection.Edit\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Subtitle.Merge-Here
	echo [%RegExShell%\FIMOFI.MKV.Subtitle.Merge-Here]
	echo "MUIVerb"="Auto Merge Subtitles Here"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Subtitle.Merge-Here\command]
	echo @="%cmd% set \"xInput=MKV.Subtitle.Merge-Here\" &call %fimofi% \"%%V\""

	:REG-MKV.Subtitle.Merge
	echo [%RegExShell%\FIMOFI.MKV.Subtitle.Merge]
	echo "MUIVerb"="Auto Merge Subtitles"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Subtitle.Merge\command]
	echo @="%Scmd% set \"xInput=MKV.Subtitle.Merge\" %Sfimofi% \"%%1\""
	
	:REG-MKV.Subtitle.Extract
	echo [%RegExShell%\FIMOFI.MKV.Subtitle.Extract]
	echo "MUIVerb"="Extract Subtitles"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Subtitle.Extract\command]
	echo @="%cmd% set \"xInput=MKV.Subtitle.Extract\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Subtitle.Delete.All
	echo [%RegExShell%\FIMOFI.MKV.Subtitle.Delete.All]
	echo "MUIVerb"="Delete Subtitles"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Subtitle.Delete.All\command]
	echo @="%cmd% set \"xInput=MKV.Subtitle.Delete.All\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Extract
	echo [%RegExShell%\FIMOFI.MKV.Extract]
	echo "MUIVerb"="Extract"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Extract\command]
	echo @="%cmd% set \"xInput=MKV.Extract\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Extract.Here
	echo [%RegExShell%\FIMOFI.MKV.Extract.Here]
	echo "MUIVerb"="Extract"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Extract.Here\command]
	echo @="%cmd% set \"xInput=MKV.Extract.Here\" &call %fimofi% \"%%1\""

	:REG-MKV.Extract.to.Folder
	echo [%RegExShell%\FIMOFI.MKV.Extract.to.Folder]
	echo "MUIVerb"="Extract to Folder"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Extract.to.Folder\command]
	echo @="%cmd% set \"xInput=MKV.Extract.to.Folder\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Extract.All
	echo [%RegExShell%\FIMOFI.MKV.Extract.All]
	echo "MUIVerb"="Extract All"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.MKV.Extract.All\command]
	echo @="%cmd% set \"xInput=MKV.Extract.All\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Cover_Delete
	echo [%RegExShell%\FIMOFI.MKV.Cover-Delete]
	echo "MUIVerb"="Delete Cover"
	echo "Icon"="shell32.dll,-1004"
	echo [%RegExShell%\FIMOFI.MKV.Cover-Delete\command]
	echo @="%cmd% set \"xInput=MKV.Cover-Delete\" &call %fimofi% \"%%1\""
	
	:REG-MKV.KeySearch
	echo [%RegExShell%\FIMOFI.MKV.KeySearch]
	echo "MUIVerb"="Scan"
	echo "Icon"="shell32.dll,-23"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.MKV.KeySearch\command]
	echo @="%cmd% set \"xInput=MKV.KeySearch\" &call %fimofi% \"%%1\""
	
	:REG-MKV.KeySet
	echo [%RegExShell%\FIMOFI.MKV.KeySet]
	echo "MUIVerb"="Define Keyword"
	echo "Icon"="shell32.dll,-242"
	echo [%RegExShell%\FIMOFI.MKV.KeySet\command]
	echo @="%cmd% set \"xInput=MKV.KeySet\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Cover_Change
	echo [%RegExShell%\FIMOFI.MKV.KeyCover]
	echo "MUIVerb"="Change Cover using Keyword"
	echo "Icon"="shell32.dll,-16801"
	echo [%RegExShell%\FIMOFI.MKV.KeyCover\command]
	echo @="%cmd% set \"xInput=MKV.KeyCover\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Cover_Fanart
	echo [%RegExShell%\FIMOFI.MKV.Cover-Fanart]
	echo "MUIVerb"="Change Cover <- *Fanart.jpg"
	echo "Icon"="shell32.dll,-16801"
	echo [%RegExShell%\FIMOFI.MKV.Cover-Fanart\command]
	echo @="%cmd% set \"xInput=MKV.Cover-Fanart\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Cover_Landscape
	echo [%RegExShell%\FIMOFI.MKV.Cover-Landscape]
	echo "MUIVerb"="Change Cover <- *Landscape.jpg"
	echo "Icon"="shell32.dll,-16801"
	echo [%RegExShell%\FIMOFI.MKV.Cover-Landscape\command]
	echo @="%cmd% set \"xInput=MKV.Cover-Landscape\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Cover_Poster
	echo [%RegExShell%\FIMOFI.MKV.Cover-Poster]
	echo "MUIVerb"="Change Cover <- *Poster.jpg"
	echo "Icon"="shell32.dll,-16801"
	echo [%RegExShell%\FIMOFI.MKV.Cover-Poster\command]
	echo @="%cmd% set \"xInput=MKV.Cover-Poster\" &call %fimofi% \"%%1\""
	
	:REG-MKV.Cover_Discart
	echo [%RegExShell%\FIMOFI.MKV.Cover-Discart]
	echo "MUIVerb"="Change Cover <- *Discart.png"
	echo "Icon"="shell32.dll,-16801"
	echo [%RegExShell%\FIMOFI.MKV.Cover-Discart\command]
	echo @="%cmd% set \"xInput=MKV.Cover-Discart\" &call %fimofi% \"%%1\""
	
	REM MKV Tools Background Menu
	:REG-MKV.Gen.Cover_Delete
	echo [%RegExShell%\FIMOFI.MKV.Gen.Cover-Delete]
	echo "MUIVerb"="Delete Cover"
	echo "Icon"="shell32.dll,-1004"
	echo [%RegExShell%\FIMOFI.MKV.Gen.Cover-Delete\command]
	echo @="%cmd% set \"xInput=MKV.Gen.Cover-Delete\" &call %fimofi% \"%%V\""
	
	:REG-MKV.Gen.Cover_Generate
	echo [%RegExShell%\FIMOFI.MKV.Gen.Cover-Generate]
	echo "MUIVerb"="Generate Cover using Keyword"
	echo "Icon"="shell32.dll,-241"
	echo [%RegExShell%\FIMOFI.MKV.Gen.Cover-Generate\command]
	echo @="%cmd% set \"xInput=MKV.Gen.Cover-Generate\" &call %fimofi% \"%%V\""
	
	:REG-MKV.Gen.Cover_Fanart
	echo [%RegExShell%\FIMOFI.MKV.Gen.Cover-Fanart]
	echo "MUIVerb"="Generate Cover <- *Fanart.jpg"
	echo "Icon"="shell32.dll,-241"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.MKV.Gen.Cover-Fanart\command]
	echo @="%cmd% set \"xInput=MKV.Gen.Cover-Fanart\" &call %fimofi% \"%%V\""
	
	:REG-MKV.Gen.Cover_Landscape
	echo [%RegExShell%\FIMOFI.MKV.Gen.Cover-Landscape]
	echo "MUIVerb"="Generate Cover <- *Landscape.jpg"
	echo "Icon"="shell32.dll,-241"
	echo [%RegExShell%\FIMOFI.MKV.Gen.Cover-Landscape\command]
	echo @="%cmd% set \"xInput=MKV.Gen.Cover-Landscape\" &call %fimofi% \"%%V\""
	
	:REG-MKV.Gen.Cover_Poster
	echo [%RegExShell%\FIMOFI.MKV.Gen.Cover-Poster]
	echo "MUIVerb"="Generate Cover <- *Poster.jpg"
	echo "Icon"="shell32.dll,-241"
	echo [%RegExShell%\FIMOFI.MKV.Gen.Cover-Poster\command]
	echo @="%cmd% set \"xInput=MKV.Gen.Cover-Poster\" &call %fimofi% \"%%V\""
	
	:REG-MKV.Gen.Cover_Discart
	echo [%RegExShell%\FIMOFI.MKV.Gen.Cover-Discart]
	echo "MUIVerb"="Generate Cover <- *Discart.png"
	echo "Icon"="shell32.dll,-241"
	echo [%RegExShell%\FIMOFI.MKV.Gen.Cover-Discart\command]
	echo @="%cmd% set \"xInput=MKV.Gen.Cover-Discart\" &call %fimofi% \"%%V\""
		
	REM Selected_Dir
	:REG-Open_Here
	echo [%RegExShell%\FIMOFI.OpenHere]
	echo "MUIVerb"="Open Here"
	echo "Icon"="shell32.dll,-35"
	echo [%RegExShell%\FIMOFI.OpenHere\command]
	echo @="%cmd% set \"xInput=OpenHere\" &call %fimofi% \"%%V\""
	
	:REG-FI.Search.Folder.Icon
	echo [%RegExShell%\FIMOFI.FI.Search.Folder.Icon]
	echo "MUIVerb"="Search This Folder Icon"
	echo "Icon"="shell32.dll,-35"
	echo [%RegExShell%\FIMOFI.FI.Search.Folder.Icon\command]
	echo @="%cmd% set \"xInput=FI.Search.Folder.Icon\" &call %fimofi% \"%%V\""

	:REG-FI.Search.Folder.Icon.Here
	echo [%RegExShell%\FIMOFI.FI.Search.Folder.Icon.Here]
	echo "MUIVerb"="Search Folder Icon"
	echo "Icon"="shell32.dll,-35"
	echo [%RegExShell%\FIMOFI.FI.Search.Folder.Icon.Here\command]
	echo @="%cmd% set \"xInput=FI.Search.Folder.Icon.Here\" &call %fimofi% \"%%V\""
	
	:REG-Refresh
	echo [%RegExShell%\FIMOFI.Refresh]
	echo "MUIVerb"="Refresh Icon Cache (Restart Explorer)"
	echo "Icon"="shell32.dll,-16739"
	echo [%RegExShell%\FIMOFI.Refresh\command]
	echo @="%cmd% set \"xInput=Refresh\" &call %fimofi% \"%%V\""
	
	:REG-Refresh_No_Restart
	echo [%RegExShell%\FIMOFI.RefreshNR]
	echo "MUIVerb"="Refresh Icon Cache (Without Restart)"
	echo "Icon"="shell32.dll,-16739"
	echo [%RegExShell%\FIMOFI.RefreshNR\command]
	echo @="%cmd% set \"xInput=RefreshNR\" &call %fimofi% \"%%V\""
	
	:REG-Choose_Template
	echo [%RegExShell%\FIMOFI.ChoTemplate]
	echo "MUIVerb"="Choose Template"
	echo "Icon"="shell32.dll,-270"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.ChoTemplate\command]
	echo @="%cmd% set \"xInput=ChoTemplate\" &call %fimofi% \"%%V\""
	
	:REG-Scan
	echo [%RegExShell%\FIMOFI.Scan]
	echo "MUIVerb"="Scan"
	echo "Icon"="shell32.dll,-23"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.Scan\command]
	echo @="%cmd% set \"xInput=Scan\" &call %fimofi% \"%%V\""
	
	:REG-Define_Keyword
	echo [%RegExShell%\FIMOFI.DefKey]
	echo "MUIVerb"="Define keyword"
	echo "Icon"="shell32.dll,-242"
	echo [%RegExShell%\FIMOFI.DefKey\command]
	echo @="%cmd% set \"xInput=DefKey\" &call %fimofi% \"%%V\""
	
	:REG-Generate_Keyword
	echo [%RegExShell%\FIMOFI.GenKey]
	echo "MUIVerb"="Generate using Keyword"
	echo "Icon"="shell32.dll,-241"
	echo [%RegExShell%\FIMOFI.GenKey\command]
	echo @="%cmd% set \"xInput=GenKey\" &call %fimofi% \"%%V\""
	
	:REG-Generate_.JPG
	echo.
	echo [%RegExShell%\FIMOFI.GenJPG]
	echo "MUIVerb"="Generate <- *.JPG"
	echo "Icon"="shell32.dll,-241"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.GenJPG\command]
	echo @="%cmd% set \"xInput=GenJPG\" &call %fimofi% \"%%V\""
	
	:REG-Generate_.PNG
	echo [%RegExShell%\FIMOFI.GenPNG]
	echo "MUIVerb"="Generate <- *.PNG"
	echo "Icon"="shell32.dll,-241"
	echo [%RegExShell%\FIMOFI.GenPNG\command]
	echo @="%cmd% set \"xInput=GenPNG\" &call %fimofi% \"%%V\""
	
	:REG-Generate_Poster.JPG
	echo [%RegExShell%\FIMOFI.GenPosterJPG]
	echo "MUIVerb"="Generate <- *Poster.jpg"
	echo "Icon"="shell32.dll,-241"
	echo [%RegExShell%\FIMOFI.GenPosterJPG\command]
	echo @="%cmd% set \"xInput=GenPosterJPG\" &call %fimofi% \"%%V\""
	
	:REG-Generate_Landscape.JPG
	echo [%RegExShell%\FIMOFI.GenLandscapeJPG]
	echo "MUIVerb"="Generate <- *Landscape.jpg"
	echo "Icon"="shell32.dll,-241"
	echo [%RegExShell%\FIMOFI.GenLandscapeJPG\command]
	echo @="%cmd% set \"xInput=GenLandscapeJPG\" &call %fimofi% \"%%V\""
	
	:REG-Activate_Folder_Icon
	echo [%RegExShell%\FIMOFI.ActivateFolderIcon]
	echo "MUIVerb"="Activate Folder Icon"
	echo "Icon"="shell32.dll,-210"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.ActivateFolderIcon\command]
	echo @="%cmd% set \"xInput=ActivateFolderIcon\" &call %fimofi% \"%%V\""
	
	:REG-Deactivate_Folder_Icon
	echo [%RegExShell%\FIMOFI.DeactivateFolderIcon]
	echo "MUIVerb"="Deactivate Folder Icon"
	echo "Icon"="shell32.dll,-4"
	echo [%RegExShell%\FIMOFI.DeactivateFolderIcon\command]
	echo @="%cmd% set \"xInput=DeactivateFolderIcon\" &call %fimofi% \"%%V\""
	
	:REG-Remove_Folder_Icon
	echo [%RegExShell%\FIMOFI.RemFolderIcon]
	echo "MUIVerb"="Remove Folder Icon"
	echo "Icon"="shell32.dll,-145"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.RemFolderIcon\command]
	echo @="%cmd% set \"xInput=RemFolderIcon\" &call %fimofi% \"%%V\""
	
	REM Background Dir
	:REG-Refresh_here
	echo [%RegExShell%\FIMOFI.Refresh.Here]
	echo "MUIVerb"="Refresh Icon Cache (Restart Explorer)"
	echo "Icon"="shell32.dll,-16739"
	echo [%RegExShell%\FIMOFI.Refresh.Here\command]
	echo @="%cmd% set \"xInput=Refresh.Here\" &call %fimofi% \"%%V\""
	
	:REG-Refresh_No_Restart_here
	echo [%RegExShell%\FIMOFI.RefreshNR.Here]
	echo "MUIVerb"="Refresh Icon Cache (Without Restart)"
	echo "Icon"="shell32.dll,-16739"
	echo [%RegExShell%\FIMOFI.RefreshNR.Here\command]
	echo @="%cmd% set \"xInput=RefreshNR.Here\" &call %fimofi% \"%%V\""
	
	:REG-Scan_here
	echo [%RegExShell%\FIMOFI.Scan.Here]
	echo "MUIVerb"="Scan"
	echo "Icon"="shell32.dll,-23"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.Scan.Here\command]
	echo @="%cmd% set \"xInput=Scan.Here\" &call %fimofi% \"%%V\""
	
	:REG-Generate_Keyword_here
	echo [%RegExShell%\FIMOFI.GenKey.Here]
	echo "MUIVerb"="Generate <- keyword"
	echo "Icon"="shell32.dll,-241"
	echo [%RegExShell%\FIMOFI.GenKey.Here\command]
	echo @="%cmd% set \"xInput=GenKey.Here\" &call %fimofi% \"%%V\""
	
	:REG-Generate_.JPG_here
	echo [%RegExShell%\FIMOFI.GenJPG.Here]
	echo "MUIVerb"="Generate <- *.JPG"
	echo "Icon"="shell32.dll,-241"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.GenJPG.Here\command]
	echo @="%cmd% set \"xInput=GenJPG.Here\" &call %fimofi% \"%%V\""
	
	:REG-Generate_.PNG_here
	echo [%RegExShell%\FIMOFI.GenPNG.Here]
	echo "MUIVerb"="Generate <- *.PNG"
	echo "Icon"="shell32.dll,-241"
	echo [%RegExShell%\FIMOFI.GenPNG.Here\command]
	echo @="%cmd% set \"xInput=GenPNG.Here\" &call %fimofi% \"%%V\""
	
	:REG-Generate_Poster.JPG_here
	echo [%RegExShell%\FIMOFI.GenPosterJPG.Here]
	echo "MUIVerb"="Generate <- *Poster.jpg"
	echo "Icon"="shell32.dll,-241"
	echo [%RegExShell%\FIMOFI.GenPosterJPG.Here\command]
	echo @="%cmd% set \"xInput=GenPosterJPG.Here\" &call %fimofi% \"%%V\""
	
	:REG-Generate_Landscape.JPG_here
	echo [%RegExShell%\FIMOFI.GenLandscapeJPG.Here]
	echo "MUIVerb"="Generate <- *Landscape.jpg"
	echo "Icon"="shell32.dll,-241"
	echo [%RegExShell%\FIMOFI.GenLandscapeJPG.Here\command]
	echo @="%cmd% set \"xInput=GenLandscapeJPG.Here\" &call %fimofi% \"%%V\""
	
	:REG-Activate_Folder_Icon_here
	echo [%RegExShell%\FIMOFI.ActivateFolderIcon.Here]
	echo "MUIVerb"="Activate Folder Icons"
	echo "Icon"="shell32.dll,-210"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.ActivateFolderIcon.Here\command]
	echo @="%cmd% set \"xInput=ActivateFolderIcon.Here\" &call %fimofi% \"%%V\""
	
	:REG-Deactivate_Folder_Icon_here
	echo [%RegExShell%\FIMOFI.DeactivateFolderIcon.Here]
	echo "MUIVerb"="Deactivate Folder Icons"
	echo "Icon"="shell32.dll,-4"
	echo [%RegExShell%\FIMOFI.DeactivateFolderIcon.Here\command]
	echo @="%cmd% set \"xInput=DeactivateFolderIcon.Here\" &call %fimofi% \"%%V\""
	
	:REG-Remove_Folder_Icon_here
	echo [%RegExShell%\FIMOFI.RemFolderIcon.Here]
	echo "MUIVerb"="Remove Folder Icons"
	echo "Icon"="shell32.dll,-145"
	echo "CommandFlags"=dword:00000020
	echo [%RegExShell%\FIMOFI.RemFolderIcon.Here\command]
	echo @="%cmd% set \"xInput=RemFolderIcon.Here\" &call %fimofi% \"%%V\""
	echo. 

	:REG-SRT.Rename.Selected
	echo [%RegExShell%\FIMOFI.SRT.Rename.Selected]
	echo "MUIVerb"="Rename to Selected Video"
	echo "Icon"="shell32.dll,-16825"
	echo [%RegExShell%\FIMOFI.SRT.Rename.Selected\command]
	echo @="%SCMD% set \"\"xInput=SRT.Rename.Selected\"\" %SFIMOFI% \"%%1\""
	
	:REG-Context_Menu-SRT
	echo [%RegExSRT%\FIMOFI]
	echo "MUIVerb"="FIMOFI: SRT Rename"
	echo "Icon"="shell32.dll,-35"
	echo "SubCommands"="FIMOFI.SRT.Rename.Selected"
		
	:REG-Context_Menu-FI-Folder
	echo [%RegExDir%\FIMOFI.Folder.Icon.Tools]
	echo "MUIVerb"="FIMOFI: Folder Icon Tools"
	echo "Icon"="shell32.dll,-35"
	echo "SubCommands"="FIMOFI.OpenHere;FIMOFI.Refresh;FIMOFI.RefreshNR;FIMOFI.ChoTemplate;FIMOFI.FI.Search.Folder.Icon;FIMOFI.Scan;FIMOFI.DefKey;FIMOFI.GenKey;FIMOFI.GenJPG;FIMOFI.GenPNG;FIMOFI.GenPosterJPG;FIMOFI.GenLandscapeJPG;FIMOFI.ActivateFolderIcon;FIMOFI.DeactivateFolderIcon;FIMOFI.RemFolderIcon"
	
	:REG-Context_Menu-FI-Background
	echo [%RegExBG%\FIMOFI.Folder.Icon.Tools]
	echo "MUIVerb"="FIMOFI: Folder Icon Tools"
	echo "Icon"="shell32.dll,-35"
	echo "SubCommands"="FIMOFI.OpenHere;FIMOFI.Refresh.Here;FIMOFI.RefreshNR.Here;FIMOFI.ChoTemplate;FIMOFI.FI.Search.Folder.Icon.Here;FIMOFI.Scan.Here;FIMOFI.DefKey;FIMOFI.GenKey.Here;FIMOFI.GenJPG.Here;FIMOFI.GenPNG.Here;FIMOFI.GenPosterJPG.Here;FIMOFI.GenLandscapeJPG.Here;FIMOFI.ActivateFolderIcon.Here;FIMOFI.DeactivateFolderIcon.Here;FIMOFI.RemFolderIcon.Here"
	
	:REG-Context_Menu-Images
	echo [%RegExImage%\FIMOFI]
	echo "MUIVerb"="FIMOFI: Image Options"
	echo "Icon"="shell32.dll,-35"
	echo "SubCommands"="FIMOFI.IMG-Actions;FIMOFI.IMG-Set.As.Folder.Icon;FIMOFI.IMG-FI.Choose.Template;FIMOFI.IMG-Set.As.Cover"
	
	:REG-Context_Menu-MKV-Background
	echo [%RegExBG%\FIMOFI.MKV.Tools]
	echo "MUIVerb"="FIMOFI: MKV Tools"
	echo "Icon"="shell32.dll,-35"
	echo "SubCommands"="FIMOFI.MKV.Subtitle.Merge-Here;FIMOFI.MKV.Gen.Cover-Delete;FIMOFI.MKV.KeySearch;FIMOFI.MKV.KeySet;FIMOFI.MKV.Gen.Cover-Generate;FIMOFI.MKV.Gen.Cover-Fanart;FIMOFI.MKV.Gen.Cover-Landscape;FIMOFI.MKV.Gen.Cover-Poster;FIMOFI.MKV.Gen.Cover-Discart"
	
	:REG-Context_Menu-MKV
	echo [%RegExMKV%\FIMOFI]
	echo "MUIVerb"="FIMOFI: MKV Tools"
	echo "Icon"="shell32.dll,-35"
	echo "SubCommands"="FIMOFI.MKV.Actions;FIMOFI.MKV.Cover-Delete;FIMOFI.MKV.Subtitle.Merge;FIMOFI.MKV.Selection.View;FIMOFI.MKV.Selection.Add;FIMOFI.MKV.Extend-Cover;FIMOFI.MKV.Cover-Fanart;FIMOFI.MKV.Cover-Landscape;FIMOFI.MKV.Cover-Poster;FIMOFI.MKV.Cover-Discart"
	
	:REG-Context_Menu-VTM.MP4
	echo [%RegExMP4%\FIMOFI.VTM]
	echo "MUIVerb"="View Preview Thumbnail"
	echo [%RegExMP4%\FIMOFI.VTM\command]
	echo @="%SCMD% set \"\"xInput=VTM\"\" %SFIMOFI% \"%%1\""
	
	:REG-Context_Menu-VTM.MKV
	echo [%RegExMKV%\FIMOFI.VTM]
	echo "MUIVerb"="View Preview Thumbnail"
	echo [%RegExMKV%\FIMOFI.VTM\command]
	echo @="%SCMD% set \"\"xInput=VTM\"\" %SFIMOFI% \"%%1\""
	
	:REG-Context_Menu-Convert.MP4
	echo [%RegExMP4%\FIMOFI.MP4.Convert.to.MKV]
	echo "MUIVerb"="Convert MP4 to MKV"
	echo [%RegExMP4%\FIMOFI.MP4.Convert.to.MKV\command]
	echo @="%SCMD% set \"\"xInput=MP4.to.MKV\"\" %SFIMOFI% \"%%1\""
	
)>"%Setup_Write%"
exit /b