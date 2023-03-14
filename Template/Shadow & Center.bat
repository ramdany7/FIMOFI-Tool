::# Output image will be the same as source image, without frame or anything
::# but with added shadow and image posisition will be in the center.
::# Convert and edit using ImageMagick (Convert.exe).
::# -------------------------------------------------------------------

Convert.exe %inputfile% -resize 245x245 ^( +clone -background BLACK -shadow 70x1.3+2+3.5 ^) +swap -background none -layers flatten -gravity CENTER -extent 256x256 %outputfile%
