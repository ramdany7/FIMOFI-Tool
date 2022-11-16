@echo off
cd /d %~dp0
set HKEY=HKEY
set RegExBG=%HKEY%_CLASSES_ROOT\Directory\Background\shell
set RegExDir=%HKEY%_CLASSES_ROOT\Directory\shell
set RegExImage=%HKEY%_CLASSES_ROOT\SystemFileAssociations\image\shell
set RegExShell=%HKEY%_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell
set cmd=cmd.exe /k
set "curdir=%cd%"
set "curdir=%curdir:\=\\%"
set Fimofi=\"%curdir%\\FIMOFI Tool v0.0.1f.bat\"

(
echo Windows Registry Editor Version 5.00
echo [%RegExImage%\FIMOFI]
echo "MUIVerb"="Fimofi: Folder Icon Tools"
echo "Icon"="shell32.dll,-35"
echo "SubCommands"="Fimofi.Create;Fimofi.ChoTemplate"
echo [%RegExDir%\FIMOFI]
echo "MUIVerb"="Fimofi: Folder Icon Tools"
echo "Icon"="shell32.dll,-35"
echo "SubCommands"="Fimofi.OpenHere;Fimofi.Refresh;Fimofi.RefreshNR;Fimofi.ChoTemplate;Fimofi.Scan;Fimofi.DefKey;Fimofi.GenKey;Fimofi.GenJPG;Fimofi.GenPNG;Fimofi.GenPosterJPG;Fimofi.GenLandscapeJPG;Fimofi.ActivateFolderIcon;Fimofi.DeactivateFolderIcon;Fimofi.RemFolderIcon"
echo [%RegExBG%\FIMOFI]
echo "MUIVerb"="Fimofi: Folder Icon Tools"
echo "Icon"="shell32.dll,-35"
echo "SubCommands"="Fimofi.OpenHere;Fimofi.Refresh.Here;Fimofi.RefreshNR.Here;Fimofi.ChoTemplate;Fimofi.Scan.Here;Fimofi.DefKey;Fimofi.GenKey.Here;Fimofi.GenJPG.Here;Fimofi.GenPNG.Here;Fimofi.GenPosterJPG.Here;Fimofi.GenLandscapeJPG.Here;Fimofi.ActivateFolderIcon.Here;Fimofi.DeactivateFolderIcon.Here;Fimofi.RemFolderIcon.Here"
echo.

REM Selected_File
:REG-Create
echo [%RegExShell%\Fimofi.Create]
echo "MUIVerb"="Create / Make this as folder icon"
echo "Icon"="shell32.dll,-16801"
echo [%RegExShell%\Fimofi.Create\command]
echo @="%cmd% set \"xInput=Create\" &call %Fimofi% \"%%1\""

:REG-Choose_Template
echo [%RegExShell%\Fimofi.ChoTemplate]
echo "MUIVerb"="Choose Template"
echo "Icon"="shell32.dll,-270"
echo "CommandFlags"=dword:00000020
echo [%RegExShell%\Fimofi.ChoTemplate\command]
echo @="%cmd% set \"xInput=ChoTemplate\" &call %Fimofi% \"%%V\""

REM Selected_Dir
:REG-Open_Here
echo [%RegExShell%\Fimofi.OpenHere]
echo "MUIVerb"="Open Here"
echo "Icon"="shell32.dll,-35"
echo [%RegExShell%\Fimofi.OpenHere\command]
echo @="%cmd% set \"xInput=OpenHere\" &call %Fimofi% \"%%V\""

:REG-Refresh
echo [%RegExShell%\Fimofi.Refresh]
echo "MUIVerb"="Refresh Icon Cache (Restart)"
echo "Icon"="shell32.dll,-16739"
echo [%RegExShell%\Fimofi.Refresh\command]
echo @="%cmd% set \"xInput=Refresh\" &call %Fimofi% \"%%V\""

:REG-Refresh_No_Restart
echo [%RegExShell%\Fimofi.RefreshNR]
echo "MUIVerb"="Refresh Icon Cache (No Restart)"
echo "Icon"="shell32.dll,-16739"
echo [%RegExShell%\Fimofi.RefreshNR\command]
echo @="%cmd% set \"xInput=RefreshNR\" &call %Fimofi% \"%%V\""

:REG-Scan
echo [%RegExShell%\Fimofi.Scan]
echo "MUIVerb"="Scan"
echo "Icon"="shell32.dll,-23"
echo "CommandFlags"=dword:00000020
echo [%RegExShell%\Fimofi.Scan\command]
echo @="%cmd% set \"xInput=Scan\" &call %Fimofi% \"%%V\""

:REG-Define_Keyword
echo [%RegExShell%\Fimofi.DefKey]
echo "MUIVerb"="Define keyword"
echo "Icon"="shell32.dll,-242"
echo [%RegExShell%\Fimofi.DefKey\command]
echo @="%cmd% set \"xInput=DefKey\" &call %Fimofi% \"%%V\""

:REG-Generate_Keyword
echo [%RegExShell%\Fimofi.GenKey]
echo "MUIVerb"="Generate using keyword"
echo "Icon"="shell32.dll,-241"
echo [%RegExShell%\Fimofi.GenKey\command]
echo @="%cmd% set \"xInput=GenKey\" &call %Fimofi% \"%%V\""

:REG-Generate_.JPG
echo.
echo [%RegExShell%\Fimofi.GenJPG]
echo "MUIVerb"="Generate using *.JPG"
echo "Icon"="shell32.dll,-241"
echo "CommandFlags"=dword:00000020
echo [%RegExShell%\Fimofi.GenJPG\command]
echo @="%cmd% set \"xInput=GenJPG\" &call %Fimofi% \"%%V\""

:REG-Generate_.PNG
echo [%RegExShell%\Fimofi.GenPNG]
echo "MUIVerb"="Generate using *.PNG"
echo "Icon"="shell32.dll,-241"
echo [%RegExShell%\Fimofi.GenPNG\command]
echo @="%cmd% set \"xInput=GenPNG\" &call %Fimofi% \"%%V\""

:REG-Generate_Poster.JPG
echo [%RegExShell%\Fimofi.GenPosterJPG]
echo "MUIVerb"="Generate using *Poster.jpg"
echo "Icon"="shell32.dll,-241"
echo [%RegExShell%\Fimofi.GenPosterJPG\command]
echo @="%cmd% set \"xInput=GenPosterJPG\" &call %Fimofi% \"%%V\""

:REG-Generate_Landscape.JPG
echo [%RegExShell%\Fimofi.GenLandscapeJPG]
echo "MUIVerb"="Generate using *Landscape.jpg"
echo "Icon"="shell32.dll,-241"
echo [%RegExShell%\Fimofi.GenLandscapeJPG\command]
echo @="%cmd% set \"xInput=GenLandscapeJPG\" &call %Fimofi% \"%%V\""

:REG-Activate_Folder_Icon
echo [%RegExShell%\Fimofi.ActivateFolderIcon]
echo "MUIVerb"="Activate Folder Icon"
echo "Icon"="shell32.dll,-210"
echo "CommandFlags"=dword:00000020
echo [%RegExShell%\Fimofi.ActivateFolderIcon\command]
echo @="%cmd% set \"xInput=ActivateFolderIcon\" &call %Fimofi% \"%%V\""

:REG-Deactivate_Folder_Icon
echo [%RegExShell%\Fimofi.DeactivateFolderIcon]
echo "MUIVerb"="Deactivate Folder Icon"
echo "Icon"="shell32.dll,-4"
echo [%RegExShell%\Fimofi.DeactivateFolderIcon\command]
echo @="%cmd% set \"xInput=DeactivateFolderIcon\" &call %Fimofi% \"%%V\""

:REG-Remove_Folder_Icon
echo [%RegExShell%\Fimofi.RemFolderIcon]
echo "MUIVerb"="Remove Folder Icon"
echo "Icon"="shell32.dll,-145"
echo "CommandFlags"=dword:00000020
echo [%RegExShell%\Fimofi.RemFolderIcon\command]
echo @="%cmd% set \"xInput=RemFolderIcon\" &call %Fimofi% \"%%V\""

REM Background Dir
:REG-Refresh_here
echo [%RegExShell%\Fimofi.Refresh.Here]
echo "MUIVerb"="Refresh Icon Cache (Restart Explorer)"
echo "Icon"="shell32.dll,-16739"
echo [%RegExShell%\Fimofi.Refresh.Here\command]
echo @="%cmd% set \"xInput=Refresh.Here\" &call %Fimofi% \"%%V\""

:REG-Refresh_No_Restart_here
echo [%RegExShell%\Fimofi.RefreshNR.Here]
echo "MUIVerb"="Refresh Icon Cache (Without Restart)"
echo "Icon"="shell32.dll,-16739"
echo [%RegExShell%\Fimofi.RefreshNR.Here\command]
echo @="%cmd% set \"xInput=RefreshNR.Here\" &call %Fimofi% \"%%V\""

:REG-Scan_here
echo [%RegExShell%\Fimofi.Scan.Here]
echo "MUIVerb"="Scan"
echo "Icon"="shell32.dll,-23"
echo "CommandFlags"=dword:00000020
echo [%RegExShell%\Fimofi.Scan.Here\command]
echo @="%cmd% set \"xInput=Scan.Here\" &call %Fimofi% \"%%V\""

:REG-Generate_Keyword_here
echo [%RegExShell%\Fimofi.GenKey.Here]
echo "MUIVerb"="Generate using keyword"
echo "Icon"="shell32.dll,-241"
echo [%RegExShell%\Fimofi.GenKey.Here\command]
echo @="%cmd% set \"xInput=GenKey.Here\" &call %Fimofi% \"%%V\""

:REG-Generate_.JPG_here
echo [%RegExShell%\Fimofi.GenJPG.Here]
echo "MUIVerb"="Generate using *.JPG"
echo "Icon"="shell32.dll,-241"
echo "CommandFlags"=dword:00000020
echo [%RegExShell%\Fimofi.GenJPG.Here\command]
echo @="%cmd% set \"xInput=GenJPG.Here\" &call %Fimofi% \"%%V\""

:REG-Generate_.PNG_here
echo [%RegExShell%\Fimofi.GenPNG.Here]
echo "MUIVerb"="Generate using *.PNG"
echo "Icon"="shell32.dll,-241"
echo [%RegExShell%\Fimofi.GenPNG.Here\command]
echo @="%cmd% set \"xInput=GenPNG.Here\" &call %Fimofi% \"%%V\""

:REG-Generate_Poster.JPG_here
echo [%RegExShell%\Fimofi.GenPosterJPG.Here]
echo "MUIVerb"="Generate using *Poster.jpg"
echo "Icon"="shell32.dll,-241"
echo [%RegExShell%\Fimofi.GenPosterJPG.Here\command]
echo @="%cmd% set \"xInput=GenPosterJPG.Here\" &call %Fimofi% \"%%V\""

:REG-Generate_Landscape.JPG_here
echo [%RegExShell%\Fimofi.GenLandscapeJPG.Here]
echo "MUIVerb"="Generate using *Landscape.jpg"
echo "Icon"="shell32.dll,-241"
echo [%RegExShell%\Fimofi.GenLandscapeJPG.Here\command]
echo @="%cmd% set \"xInput=GenLandscapeJPG.Here\" &call %Fimofi% \"%%V\""

:REG-Activate_Folder_Icon_here
echo [%RegExShell%\Fimofi.ActivateFolderIcon.Here]
echo "MUIVerb"="Activate Folder Icons"
echo "Icon"="shell32.dll,-210"
echo "CommandFlags"=dword:00000020
echo [%RegExShell%\Fimofi.ActivateFolderIcon.Here\command]
echo @="%cmd% set \"xInput=ActivateFolderIcon.Here\" &call %Fimofi% \"%%V\""

:REG-Deactivate_Folder_Icon_here
echo [%RegExShell%\Fimofi.DeactivateFolderIcon.Here]
echo "MUIVerb"="Deactivate Folder Icons"
echo "Icon"="shell32.dll,-4"
echo [%RegExShell%\Fimofi.DeactivateFolderIcon.Here\command]
echo @="%cmd% set \"xInput=DeactivateFolderIcon.Here\" &call %Fimofi% \"%%V\""

:REG-Remove_Folder_Icon_here
echo [%RegExShell%\Fimofi.RemFolderIcon.Here]
echo "MUIVerb"="Remove Folder Icons"
echo "Icon"="shell32.dll,-145"
echo "CommandFlags"=dword:00000020
echo [%RegExShell%\Fimofi.RemFolderIcon.Here\command]
echo @="%cmd% set \"xInput=RemFolderIcon.Here\" &call %Fimofi% \"%%V\""
echo. 
)>Fimofi_Context_Menu_Install.reg
Fimofi_Context_Menu_Install.reg