@echo off
title "Refreshing .."
mode con:cols=50 lines=9
title  refresh.. %cd%
echo    %i_% Refreshing ..  %-%
set refreshCount=0
if exist "%cd%\desktop.ini" (set /a refreshCount+=1
	echo. &echo.  &%p1%
	echo                  [96mREFRESHING ...[0m
	echo [1m"%cd%"[0m
	attrib +r "%cd%" >nul
	attrib -s -h "desktop.ini" >nul
	ren "desktop.ini" "Desktop.Ini" >nul
	ren "Desktop.Ini" "desktop.ini" >nul
	attrib +s +h "desktop.ini" >nul
)
for /d /r "%cd%" %%a in (*) do (
    pushd "%%~fa"
	echo. &echo.  &%p1% 
	attrib +r "%%a" >nul
	if exist "desktop.ini" (set /a refreshCount+=1
	echo                  [96mREFRESHING ...[0m
	echo [96m"%%a"[0m
	attrib -s -h "desktop.ini" >nul
	ren "desktop.ini" "Desktop.Ini" >nul
	ren "Desktop.Ini" "desktop.ini" >nul
	attrib +s +h "desktop.ini" >nul
	cls
	) else (echo    Skiping reguler folder&echo   Skip.. %g_% "%%a" %_% &%p1%&cls)
	
	popd 
)
if %refreshCount% LSS 1 exit
ping localhost -n 1 >nul
ie4uinit.exe -ClearIconCache
ie4uinit.exe -show
echo. &echo.&echo.
echo   [96mRefresh        
echo  "%cd% .."        &echo.
echo             [106m [30m        Done!         [0m
echo. &echo. &ping localhost -n 10 >nul

exit