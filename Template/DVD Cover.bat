::# "DVD Cover.png" Design by musacakir (www.deviantart.com/musacakir)
::#  Convert and edit using ImageMagick (Convert.exe).
::# -------------------------------------------------------------------

Convert.exe %inputfile% -scale 169x240! -background none -extent 256x256-19-4 ^( "Template\img\DVD Cover.png" -resize 256x256! ^) -compose Over -composite %outputfile% &Convert.exe |EXIT /B