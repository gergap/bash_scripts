#!/bin/bash
# Resize all jpeg files in the current dir to a max width of 1024
# and store them in the subfolder small/
# This script uses ImageMagick for the actual conversion

mkdir -p small
for file in *.JPG; do
    # check if the file already exists
    if [ ! -f small/$file ]; then
        echo "Converting $file..."
        convert -resize 1024 $file small/$file
    else
        echo "Skipping $file, because it already exists."
    fi
done
