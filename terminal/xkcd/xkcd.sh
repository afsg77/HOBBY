################################
#!/bin/bash
# Based on subiet script.
# Download all xkcd with tooltip text, build a pdf with all and store the jpeg's on a folder.
# Created by afsg77

singlequote="'"

# Remember 404 doesn't exists ;)
for i in `seq 1 1498`
do
# Get the html of the i-th image
wget http://xkcd.com/$i/

# Get the i-th images
img_name="$(grep http://imgs.xkcd.com/comics/ index.html | head -1 | cut -d\" -f2)"
wget "$img_name"

# Get the image name
img_name="$(echo $img_name | sed 's/.*comics\///;')"

# Get the tooltip for the i-th image
tooltip="$(grep http://imgs.xkcd.com/comics/ index.html | head -1 | cut -d\" -f4)"

# Clean tooltip
tooltip="${tooltip//&#39;/$singlequote}"
tooltip="${tooltip//&quot;/\"}"
tooltip=`echo $tooltip| perl -ne ' while( m/.{1,70}/g ){ print "$&\n" } '`

# Append tooltip and image
convert "$img_name" -background gray label:"$tooltip" \-gravity Center -append $i.jpeg

# Clean files
rm index.html
rm *.jpg
rm *.png

done

# Convert all to a pdf
convert *.jpeg xkcd.pdf

# Save images on folder
mkdir xkcd-library
mv *.jpeg xkcd-library
###################################