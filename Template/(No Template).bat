::# Output image will be the same as source image, without frame,
::# without shadow  and image posisition will be in the center of
::# 1:1 Image ratio.
::#   
::# Convert and edit using ImageMagick (Convert.exe).
::# -------------------------------------------------------------------

Convert.exe %inputfile% -resize 256x256 -background none -gravity CENTER -extent 256x256 %outputfile%
